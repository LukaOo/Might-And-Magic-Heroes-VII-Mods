//=============================================================================
// H7Inventory
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7Inventory extends Object
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	native
	savegame;

var() protected array<H7HeroItem>	    mItems;
var protected savegame array<string>	mItemsRefs;
var protected savegame array<int>	    mItemIDs;
var protected savegame array<IntPoint>	mItemPositions;
var protected H7EditorHero			    mOwner;
var protected array<H7HeroItem>	        mConsumablesUsedInCombat;

function array<H7HeroItem>  GetItems()							{ return mItems; } 
function array<IntPoint>    GetItemPoses()                      { return mItemPositions; }
function IntPoint			GetItemPosByIndex(int index)		{ return mItemPositions[index]; }

function array<H7HeroItem> GetUsedConsumable()
{
	return mConsumablesUsedInCombat;
}

function AddUsedConsumable(H7HeroItem item)
{
	mConsumablesUsedInCombat.AddItem(item);
}

function DeleteUsedConsumables()
{
	mConsumablesUsedInCombat.Length = 0;
}

native function CleanItemsAfterCombat();
// converts the archetypes to a instances of the them
function Init( H7EditorHero newOwner, optional bool fromSave = false)
{
	local int i, j, numItems;
	local IntPoint location;
	local array<H7Effect> effects;
	local H7Effect effect;
	local H7HeroItem tear;
	
	local bool itemStacked;

	mOwner = newOwner;
	location.X = -1;
	location.Y = -1;

	if(fromSave)
	{
		mItems.Length = 0;
		numItems = mItemsRefs.Length;
		mItems.Add( numItems );
		tear = class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate;
		for( i=0; i<numItems; ++i )
		{
			mItems[i] = H7HeroItem( DynamicLoadObject( mItemsRefs[i], class'H7HeroItem') );
			if( mItems[i] == tear )
			{
				if( H7AdventureHero( mOwner ) != none )
				{
					H7AdventureHero( mOwner ).SetHasTearOfAsha( true );
				}
			}

			mItems[i] = class'H7HeroItem'.static.CreateItem( mItems[i], i < mItemIDs.Length ? mItemIDs[i] : 0 );
			mItems[i].SetOwner(mOwner);
		}
	}
	else
	{
		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			tear = class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate;
			for( i=0; i<mItems.Length; ++i )
			{
				if( mItems[i] == tear )
				{
					if( H7AdventureHero( mOwner ) != none )
					{
						H7AdventureHero( mOwner ).SetHasTearOfAsha( true );
					}
				}
				mItems[i] = class'H7HeroItem'.static.CreateItem( mItems[i] );
				mItemPositions.AddItem(location);
				mItems[i].SetOwner(mOwner);
			}
		}
	}
	

	//to remove empty items from array
	for( i = mItems.Length - 1; i >= 0; --i )
	{
		if( mItems[i] == none )
		{
			mItems.Remove( i, 1 );
			;
		}
	}

	//learn abilities from scrolls
	for( i=0; i<mItems.Length; ++i )
	{
		if(mItems[i].GetType() == ITYPE_SCROLL)
		{
			mItems[i].GetEffects(effects, none);
			foreach effects(effect)
			{
				if(effect.IsA('H7EffectWithSpells') && H7EffectWithSpells(effect).GetData().mSpellStruct.mSpellOperation == ADD_ABILITY)
				{
					mOwner.GetAbilityManager().LearnScrollSpell(H7BaseAbility( H7EffectWithSpells(effect).GetData().mSpellStruct.mSpell ), mItems[i]);
				}
			}
		}
	}

	location.X = 0;
	location.Y = 0;

	//prestack scrolls TODO:currently is hardcoded to 4 items per inventory row, change that!
	if(!fromSave)
	{
		for(i= 0; i<mItems.Length; i++)
		{
			itemStacked = false;

			if(mItems[i].IsStackable())
			{
				for(j = 0; j < i; j++)
				{
					if(mItems[j].GetName() == mItems[i].GetName())
					{
						SetItemPos(mItems[i].GetID(), mItemPositions[j].X, mItemPositions[j].Y, true);
						itemStacked = true;
						break;
					}
				}
			}
		
			if(itemStacked) continue;

			SetItemPos(mItems[i].GetID(), location.X, location.Y, true);
			location.X++;
			if(location.X >= 4)
			{
				location.X = 0;
				location.Y++;
			}
		}
	}
	
	//`log_gui("----------Inventory Init Done--------------");

}

function H7HeroItem GetItem( H7HeroItem item )
{
	local H7HeroItem tmpItem;
	foreach mItems( tmpItem )
	{
		if( tmpItem.IsEqual( item ) )
		{
			return item;
		}
	}
	return none;
}

native function H7HeroItem GetItemByID( int id, optional bool suppressWarning );

function int GetTotalCountOfScroll(H7HeroItem scroll)
{
	local H7HeroItem item;
	local int count;

	if(scroll.GetType() != ITYPE_SCROLL) return 0;
	count = 0;

	ForEach mItems( item )
	{
		if(item.GetName() == scroll.GetName())
			count++;
	}
	return count;
}

function int GetTotalCountOfScrollsOnPosition(H7HeroItem scroll, IntPoint scrollPos)
{
	local H7HeroItem item;
	local int count;

	if(scroll.GetType() != ITYPE_SCROLL) return 0;
	count = 0;

	ForEach mItems( item )
	{
		if(item.GetName() == scroll.GetName() && mItemPositions[mItems.Find(item)] == scrollPos)
			count++;
	}
	return count;
}

/**
 * Sets the position of an item stack based on one itemID of any item in the stack
 */
function SetItemPosStack(int itemID, int x, int y)
{
	local IntPoint originalPos;
	local String itemName;
	local array<H7HeroItem> remainingItemsOnStack;
	local int i;

	itemName = GetItemByID(itemID).GetName();

	for(i = 0; i < mItems.Length; i++)
	{
		if(mItems[i].GetID() == itemID) originalPos = GetItemPosByIndex(i);
	}

	// get the rest of the items in the stack (if there are any)
	for(i = 0; i < mItems.Length; i++)
	{
		if(mItems[i].GetID() != itemID && mItems[i].GetName() == itemName && GetItemPosByIndex(i) == originalPos) 
			remainingItemsOnStack.AddItem(mItems[i]);
	}

	SetItemPos(itemID, x, y);

	for(i = 0; i < remainingItemsOnStack.Length; i++)
	{
		SetItemPos(remainingItemsOnStack[i].GetID(), x, y);
	}

}

/**
 * Call this ONLY when you know the itemID is contained in this inventory
 */
function SetItemPos(int itemID, int x, int y, bool ignoreReplication = false )
{	
	local H7InstantCommandInventoryAction command;

	command = new class'H7InstantCommandInventoryAction';
	command.Init( IA_SET_ITEM_POS, H7AdventureHero( mOwner ), GetItemByID(itemID), x, y );
	if( ignoreReplication )
	{
		command.Execute();
	}
	else
	{
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	}
}

event SetItemPosComplete(int itemID, int x, int y )
{
	local IntPoint location;

	;

	location.X = x;
	location.Y = y;
	
	mItemPositions[mItems.Find(GetItemByID(itemID))] = location;
}

function AddItemToInventory( H7HeroItem item, optional int posX =-1, optional int posY =-1 )
{
	local H7InstantCommandInventoryAction command;
	local H7HeroItem itemInstance;

	// Safeguard (create item if its an archetype!)
	if(item.IsArchetype())
	{
		itemInstance = class'H7HeroItem'.static.CreateItem(item);
	}

	command = new class'H7InstantCommandInventoryAction';
	command.Init( IA_ADD_ITEM, H7AdventureHero( mOwner ), itemInstance != none ? itemInstance : item, posX, posY );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

native function AddItemToInventoryComplete( H7HeroItem item, optional int posX =-1, optional int posY =-1 );

/**
 * remove item stack by id of any item in the stack
 */
function RemoveItemStackByID(int itemID)
{
	local IntPoint originalPos;
	local String itemName;
	local array<H7HeroItem> remainingItemsOnStack;
	local int i;

	itemName = GetItemByID(itemID).GetName();

	for(i = 0; i < mItems.Length; i++)
	{
		if(mItems[i].GetID() == itemID) originalPos = GetItemPosByIndex(i);
	}

	// get the rest of the items in the stack (if there are any)
	for(i = 0; i < mItems.Length; i++)
	{
		if(mItems[i].GetID() != itemID && mItems[i].GetName() == itemName && GetItemPosByIndex(i) == originalPos) 
			remainingItemsOnStack.AddItem(mItems[i]);
	}

	RemoveItemByID(itemID);

	for(i = 0; i < remainingItemsOnStack.Length; i++)
	{
		RemoveItemByID(remainingItemsOnStack[i].GetID());
	}
}

function RemoveItemByID( int itemID )
{
	if(GetItemByID(itemID) == none) return;
	RemoveItem( GetItemByID( itemID ) );
}

function RemoveItem( H7HeroItem item )
{
	local H7InstantCommandInventoryAction command;

	command = new class'H7InstantCommandInventoryAction';
	command.Init( IA_REMOVE_ITEM, H7AdventureHero( mOwner ), item );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );	
}

event RemoveItemComplete( H7HeroItem item )
{
	mItemPositions.Remove( mItems.Find(item), 1 );
	mItems.RemoveItem( item );
	mOwner.DataChanged();
}

function int CountItem(H7HeroItem item)
{
	local array<H7HeroItem> items;
	local H7HeroItem currentItem;
	local int i;

	i = 0;
	items = GetItems();
	foreach items(currentItem)
	{
		if(currentItem.IsArchetype() && item.IsArchetype() && currentItem == item) i++;
		else if(!currentItem.IsArchetype() && !item.IsArchetype() && currentItem.ObjectArchetype == item.ObjectArchetype) i++;
		else if(currentItem.IsArchetype() && !item.IsArchetype() && currentItem == item.ObjectArchetype) i++;
		else if(!currentItem.IsArchetype() && item.IsArchetype() && currentItem.ObjectArchetype == item) i++;
	}
	return i;
}

function bool HasItem(H7HeroItem item)
{
	return CountItem(item) > 0;
}

native function H7HeroItem GetItemByName(string itemName);

native function H7HeroItem GetItemByPosition(int x, int y);

function array<H7HeroItem> getItemsByPosition(int x, int y)
{
	local int i;
	local array<H7HeroItem> items;
	
	for(i = 0; i < mItemPositions.Length; i++)
	{
		if(mItemPositions[i].X == x && mItemPositions[i].Y == y) items.AddItem( mItems[i] );
	}

	if(items.Length == 0)
		;
	
	return items;
}

function IntPoint GetItemPosByItem(H7HeroItem item)
{
	return mItemPositions[mItems.Find(item)];
}

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function JSonObject Serialize()
{
	local JSonObject JSonObject;
	local int i;
	
	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	if (JSonObject == None)
	{
		;
		return JSonObject;
	}

	JSonObject.SetIntValue( "ItemsLength", mItems.Length );
	for( i=0; i<mItems.Length; ++i )
	{
		JSonObject.SetStringValue( "Item"$i, PathName( mItems[i].ObjectArchetype ) );
	}
	
	for(i = 0; i < mItemPositions.Length; i++)
	{
		JsonObject.SetIntValue("Item"$i$"X", mItemPositions[i].X);
		JsonObject.SetIntValue("Item"$i$"Y", mItemPositions[i].Y);
	}

	// Send the encoded JSonObject
	return JSonObject;
}

/**
 * Deserializes the actor from the data given
 *
 * @param    Data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data)
{
	local int numItems, i;
	local IntPoint location;

	mItems.Length = 0;
	numItems = Data.GetIntValue( "ItemsLength" );
	mItems.Add( numItems );
	for( i=0; i<numItems; ++i )
	{
		mItems[i] = H7HeroItem( DynamicLoadObject( Data.GetStringValue( "Item"$i ), class'H7HeroItem') );
		
		//if(Data.GetStringValue("Item"$i$"X") == none) continue;
		location.X = Data.GetIntValue("Item"$i$"X");
		location.Y = Data.GetIntValue("Item"$i$"Y");
		mItemPositions[i] = location;
	}
	
	Init( mOwner );
}

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame){}


event PostSerialize()
{
	/* Not needed Init Called in AdventureHero->RestoreHero */


}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
