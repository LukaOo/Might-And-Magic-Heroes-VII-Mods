//=============================================================================
// H7HeroItem
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroEquipment extends Object
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	native
	savegame;

var() protected H7HeroItem mHelmet<DisplayName=Helmet>;
var() protected H7HeroItem mWeapon<DisplayName=Weapon>;
var() protected H7HeroItem mChestArmor<DisplayName=ChestArmor>;
var() protected H7HeroItem mGloves<DisplayName=Gloves>;
var() protected H7HeroItem mShoes<DisplayName=Shoes>;
var() protected H7HeroItem mNecklace<DisplayName=Necklace>;
var() protected H7HeroItem mRing1<DisplayName=Ring1>;
var() protected H7HeroItem mCape<DisplayName=Cape>; 

var protected savegame string mHelmetRef;
var protected savegame string mWeaponRef;
var protected savegame string mChestArmorRef;
var protected savegame string mGlovesRef;
var protected savegame string mShoesRef;
var protected savegame string mNecklaceRef;
var protected savegame string mRing1Ref;
var protected savegame string mCapeRef; 

var protected savegame int mHelmetID;
var protected savegame int mWeaponID;
var protected savegame int mChestArmorID;
var protected savegame int mGlovesID;
var protected savegame int mShoesID;
var protected savegame int mNecklaceID;
var protected savegame int mRing1ID;
var protected savegame int mCapeID; 

var protected H7EditorHero mOwner;

function H7HeroItem     GetHelmet()         {return class'H7GameUtility'.static.IsArchetype(mHelmet)?none:mHelmet;}
function H7HeroItem     GetWeapon()         {return class'H7GameUtility'.static.IsArchetype(mWeapon)?none:mWeapon;}
function H7HeroItem     GetChestArmor()     {return class'H7GameUtility'.static.IsArchetype(mChestArmor)?none:mChestArmor;}
function H7HeroItem     GetGloves()         {return class'H7GameUtility'.static.IsArchetype(mGloves)?none:mGloves;}
function H7HeroItem     GetShoes()          {return class'H7GameUtility'.static.IsArchetype(mShoes)?none:mShoes;}
function H7HeroItem     GetNecklace()       {return class'H7GameUtility'.static.IsArchetype(mNecklace)?none:mNecklace;}
function H7HeroItem     GetRing1()          {return class'H7GameUtility'.static.IsArchetype(mRing1)?none:mRing1;}
function H7HeroItem     GetCape()           {return class'H7GameUtility'.static.IsArchetype(mCape)?none:mCape;}

function SetHelmet(H7HeroItem item)         { if(item == none) return; mHelmet = item;        item.SetEquipped(true,mOwner);}
function SetWeapon(H7HeroItem item)         { if(item == none) return; mWeapon = item;        item.SetEquipped(true,mOwner);}
function SetChestArmor(H7HeroItem item)     { if(item == none) return; mChestArmor = item;    item.SetEquipped(true,mOwner);}
function SetGloves(H7HeroItem item)         { if(item == none) return; mGloves = item;        item.SetEquipped(true,mOwner);}
function SetShoes(H7HeroItem item)          { if(item == none) return; mShoes = item;         item.SetEquipped(true,mOwner);}
function SetNecklace(H7HeroItem item)       { if(item == none) return; mNecklace = item;      item.SetEquipped(true,mOwner);}
function SetRing1(H7HeroItem item)          { if(item == none) return; mRing1 = item;         item.SetEquipped(true,mOwner);}
function SetCape(H7HeroItem item)           { if(item == none) return; mCape = item;          item.SetEquipped(true,mOwner);}

native function CleanItemsAfterCombat();

// converts the archetypes to a instances of the them
function Init(optional bool fromSave=false)
{
	if(fromSave)
	{
		if(mHelmetRef != "")
		{
			mHelmet = class'H7HeroItem'.static.CreateItem( mHelmet, mHelmetID );
			if( mHelmet != none ) { mHelmet.SetEquipped( true, mOwner ); }
		}
		if(mWeaponRef != "")
		{
			mWeapon = class'H7HeroItem'.static.CreateItem( mWeapon, mWeaponID );
			if( mWeapon != none ) { mWeapon.SetEquipped( true, mOwner ); }
		}
		if(mChestArmorRef != "")
		{
			mChestArmor = class'H7HeroItem'.static.CreateItem( mChestArmor, mChestArmorID );
			if( mChestArmor != none ) { mChestArmor.SetEquipped( true, mOwner ); }
		}
		if(mGlovesRef != "")
		{
			mGloves = class'H7HeroItem'.static.CreateItem( mGloves, mGlovesID );
			if( mGloves != none ) { mGloves.SetEquipped( true, mOwner ); }
		}
		if(mShoesRef != "")
		{
			mShoes = class'H7HeroItem'.static.CreateItem( mShoes, mShoesID );
			if( mShoes != none ) { mShoes.SetEquipped( true, mOwner ); }
		}
		if(mNecklaceRef != "")
		{
			mNecklace = class'H7HeroItem'.static.CreateItem( mNecklace, mNecklaceID );
			if( mNecklace != none ) { mNecklace.SetEquipped( true, mOwner ); }
		}
		if(mRing1Ref != "")
		{
			mRing1 = class'H7HeroItem'.static.CreateItem( mRing1, mRing1ID );
			if( mRing1 != none ) { mRing1.SetEquipped( true, mOwner ); }
		}
		if(mCapeRef != "")
		{
			mCape = class'H7HeroItem'.static.CreateItem( mCape, mCapeID );
			if( mCape != none ) { mCape.SetEquipped( true, mOwner ); }
		}
	}
	else
	{
		mHelmet = class'H7HeroItem'.static.CreateItem( mHelmet );
		if( mHelmet != none ) { mHelmet.SetEquipped( true, mOwner ); }
		mWeapon = class'H7HeroItem'.static.CreateItem( mWeapon );
		if( mWeapon != none ) { mWeapon.SetEquipped( true, mOwner ); }
		mChestArmor = class'H7HeroItem'.static.CreateItem( mChestArmor );
		if( mChestArmor != none ) { mChestArmor.SetEquipped( true, mOwner ); }
		mGloves = class'H7HeroItem'.static.CreateItem( mGloves );
		if( mGloves != none ) { mGloves.SetEquipped( true, mOwner ); }
		mShoes = class'H7HeroItem'.static.CreateItem( mShoes );
		if( mShoes != none ) { mShoes.SetEquipped( true, mOwner ); }
		mNecklace = class'H7HeroItem'.static.CreateItem( mNecklace );
		if( mNecklace != none ) { mNecklace.SetEquipped( true, mOwner ); }
		mRing1 = class'H7HeroItem'.static.CreateItem( mRing1 );
		if( mRing1 != none ) { mRing1.SetEquipped( true, mOwner ); }
		mCape = class'H7HeroItem'.static.CreateItem( mCape );
		if( mCape != none ) { mCape.SetEquipped( true, mOwner ); }
	}
	
}

function bool IsArchetype()
{
	return class'H7GameUtility'.static.IsArchetype(self);
}

function SetEquipmentOwner(H7EditorHero owner)       
{
	local array<H7HeroItem> items;
	local H7HeroItem        item;
	
	if(IsArchetype())
	{
		;
		scripttrace();
		return;
	}


	mOwner = owner;
	
	GetItemsAsArray(items);
	foreach items(item) 
	{
		if(!class'H7GameUtility'.static.IsArchetype(item))
		{
			item.SetOwner( owner );
		}
		
	}
}

event RaiseEvent(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container)
{
	if(mHelmet != none) { mHelmet.GetEventManager().Raise(triggerEvent, simulate, container); }
	if(mWeapon != none) mWeapon.GetEventManager().Raise(triggerEvent, simulate, container);
	if(mChestArmor != none) mChestArmor.GetEventManager().Raise(triggerEvent, simulate, container);
	if(mGloves != none) mGloves.GetEventManager().Raise(triggerEvent, simulate, container);
	if(mShoes != none) mShoes.GetEventManager().Raise(triggerEvent, simulate, container);
	if(mNecklace != none) mNecklace.GetEventManager().Raise(triggerEvent, simulate, container);
	if(mRing1 != none) mRing1.GetEventManager().Raise(triggerEvent, simulate, container);
	if(mCape != none) mCape.GetEventManager().Raise(triggerEvent, simulate, container);
}

native function GetItemsAsArray( out array<H7HeroItem> items );

native function int CountItem( H7HeroItem item , optional bool checkForInstance );

native function bool HasItemEquipped( H7HeroItem item , optional bool checkForInstance );

// return NUMBER of set items equipped
native function int HasSetItemsEquipped( H7ItemSet set );

native function GetResourceProducingItems(out array<H7EffectSpecialAddResources> produc);

function H7HeroItem GetItemByID(int itemID, optional bool suppressWarning)
{
	local H7HeroItem item;
	local array<H7HeroItem> items;
	GetItemsAsArray(items);
	ForEach items(item)
	{
		if(item.GetID() == itemID) return item;
	}
	if(!suppressWarning) ;
	return none;
}

event H7HeroItem GetItemByType(EItemType type)
{
	switch(type)
	{
		case ITYPE_HELMET: return mHelmet;
		case ITYPE_WEAPON: return mWeapon;
		case ITYPE_CHEST_ARMOR: return mChestArmor;
		case ITYPE_GLOVES: return mGloves;
		case ITYPE_SHOES: return mShoes;
		case ITYPE_NECKLACE: return mNecklace;
		case ITYPE_RING: return mRing1;
		case ITYPE_CAPE: return mCape;
	}

	;
	return none;
}

function SetItem( H7HeroItem item, optional bool updateGUI = false)
{
	local H7InstantCommandInventoryAction command;

	command = new class'H7InstantCommandInventoryAction';
	command.Init( IA_EQUIP_ITEM, H7AdventureHero( mOwner ), item, -1, -1, updateGUI );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

event SetItemComplete(H7HeroItem item)
{
	local H7EventContainerStruct eventContainer;
	;
	eventContainer.EffectContainer = item;
	eventContainer.Targetable = mOwner;
	item.TriggerEvents( ON_EQUIP_ITEM, false, eventContainer );
	//mOwner.TriggerEvents( ON_EQUIP_ITEM, false, eventContainer );  // causes double spells

	switch (item.GetType())
	{
		case ITYPE_HELMET: SetHelmet(item); break;
		case ITYPE_WEAPON: SetWeapon(item); break;
		case ITYPE_CHEST_ARMOR: SetChestArmor(item); break;
		case ITYPE_GLOVES: SetGloves(item); break;
		case ITYPE_SHOES: SetShoes(item); break;
		case ITYPE_NECKLACE: SetNecklace(item); break;
		case ITYPE_RING: SetRing1(item);  break;
		case ITYPE_CAPE: SetCape(item); break;
	}

	mOwner.LearnItemAbilities(item , false);   //  learn new abilities

	// in case of Sextant of the Seamen... ehm, Sea Elves
	if( H7AdventureHero( mOwner ) != none )
	{
		H7AdventureHero( mOwner ).GetAdventureArmy().SetCell( H7AdventureHero(mOwner).GetCell() ); //( H7AdventureHero( mOwner ).GetScoutingRadius() );
	}
}

function RemoveItem( H7HeroItem item )
{
	local H7InstantCommandInventoryAction command;

	command = new class'H7InstantCommandInventoryAction';
	command.Init( IA_UNEQUIP_ITEM, H7AdventureHero( mOwner ), item );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function RemoveItemComplete( H7HeroItem item )
{
	local H7EventContainerStruct eventContainer;
	
	eventContainer.EffectContainer = item;
	eventContainer.Targetable = mOwner;
	item.TriggerEvents( ON_UNEQUIP_ITEM, false, eventContainer );   
	//mOwner.TriggerEvents( ON_UNEQUIP_ITEM, false, eventContainer ); // causes double spells

	if(mHelmet != none && mHelmet.GetID() == item.GetID())
	{ 
		mHelmet.SetEquipped(false, mOwner);
		mHelmet = none;
	}
	else if(mWeapon != none && mWeapon.GetID() == item.GetID())
	{ 
		mWeapon.SetEquipped(false, mOwner);
		mWeapon = none;
	}
	else if(mChestArmor != none && mChestArmor.GetID() == item.GetID())
	{ 
		mChestArmor.SetEquipped(false, mOwner);
		mChestArmor = none;
	}
	else if(mGloves != none && mGloves.GetID() == item.GetID())
	{ 
		mGloves.SetEquipped(false, mOwner);
		mGloves = none;
	}
	else if(mShoes != none && mShoes.GetID() == item.GetID())
	{ 
		mShoes.SetEquipped(false, mOwner);
		mShoes = none;
	}
	else if(mNecklace != none && mNecklace.GetID() == item.GetID())
	{ 
		mNecklace.SetEquipped(false, mOwner);
		mNecklace = none;
	}
	else if(mRing1 != none && mRing1.GetID() == item.GetID())
	{ 
		mRing1.SetEquipped(false, mOwner);
		mRing1 = none;
	}
	else if(mCape != none && mCape.GetID() == item.GetID())
	{ 
		mCape.SetEquipped(false, mOwner);
		mCape = none;
	}

	mOwner.LearnItemAbilities(item , true );   //unlearn old abilities
}

function String GetRingSlot(H7HeroItem item)
{
	if(item.GetType() != ITYPE_RING) return "";
	if(item == mRing1) return "L";
	; 
	return "";
}

function UnequipAll()
{
	RemoveItemComplete( mHelmet );
	RemoveItemComplete( mGloves );
	RemoveItemComplete( mRing1 );
	RemoveItemComplete( mCape );
	RemoveItemComplete( mChestArmor );
	RemoveItemComplete( mNecklace );
	RemoveItemComplete( mShoes );
	RemoveItemComplete( mWeapon );
}

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function JSonObject Serialize()
{
	local JSonObject JSonObject;
	
	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	if (JSonObject == None)
	{
		;
		return JSonObject;
	}

	if( mHelmet != none )
	{
		JSonObject.SetStringValue( "Helmet", PathName( mHelmet.ObjectArchetype ) );
	}

	if( mWeapon != none )
	{
		JSonObject.SetStringValue( "Weapon", PathName( mWeapon.ObjectArchetype ) );
	}
	
	if( mChestArmor != none )
	{
		JSonObject.SetStringValue( "ChestArmor", PathName( mChestArmor.ObjectArchetype ) );
	}

	if( mGloves != none )
	{
		JSonObject.SetStringValue( "Gloves", PathName( mGloves.ObjectArchetype ) );
	}
		
	if( mShoes != none )
	{
		JSonObject.SetStringValue( "Shoes", PathName( mShoes.ObjectArchetype ) );
	}

	if( mNecklace != none )
	{
		JSonObject.SetStringValue( "Necklace", PathName( mNecklace.ObjectArchetype ) );
	}
	
	if( mRing1 != none )
	{
		JSonObject.SetStringValue( "Ring1", PathName( mRing1.ObjectArchetype ) );
	}

	if( mCape != none )
	{
		JSonObject.SetStringValue( "Cape", PathName( mCape.ObjectArchetype ) );
	}

	// Send the encoded JSonObject
	return JSonObject;
}

event PostSerialize()
{
	if( mHelmetRef != "" )
	{
		mHelmet = H7HeroItem( DynamicLoadObject( mHelmetRef, class'H7HeroItem') );
	}

	if( mWeaponRef != "" )
	{
		mWeapon = H7HeroItem( DynamicLoadObject( mWeaponRef, class'H7HeroItem') );
	}

	if( mChestArmorRef != "" )
	{
		mChestArmor = H7HeroItem( DynamicLoadObject( mChestArmorRef, class'H7HeroItem') );
	}

	if( mGlovesRef != "" )
	{
		mGloves = H7HeroItem( DynamicLoadObject( mGlovesRef, class'H7HeroItem') );
	}
	
	if( mShoesRef != "" )
	{
		mShoes = H7HeroItem( DynamicLoadObject( mShoesRef, class'H7HeroItem') );
	}

	if( mNecklaceRef != "" )
	{
		mNecklace = H7HeroItem( DynamicLoadObject( mNecklaceRef, class'H7HeroItem') );
	}

	if( mRing1Ref != "" )
	{
		mRing1 = H7HeroItem( DynamicLoadObject( mRing1Ref, class'H7HeroItem') );
	}

	if( mCapeRef != "" )
	{
		mCape = H7HeroItem( DynamicLoadObject( mCapeRef, class'H7HeroItem') );
	}

	Init(true);
}

/**
 * Deserializes the actor from the data given
 *
 * @param    Data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data)
{
	local string archetypeName;

	archetypeName = Data.GetStringValue( "Helmet" );
	if( archetypeName != "" )
	{
		mHelmet = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}

	archetypeName = Data.GetStringValue( "Weapon" );
	if( archetypeName != "" )
	{
		mWeapon = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}

	archetypeName = Data.GetStringValue( "ChestArmor" );
	if( archetypeName != "" )
	{
		mChestArmor = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}

	archetypeName = Data.GetStringValue( "Gloves" );
	if( archetypeName != "" )
	{
		mGloves = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}
	
	archetypeName = Data.GetStringValue( "Shoes" );
	if( archetypeName != "" )
	{
		mShoes = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}

	archetypeName = Data.GetStringValue( "Necklace" );
	if( archetypeName != "" )
	{
		mNecklace = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}

	archetypeName = Data.GetStringValue( "Ring1" );
	if( archetypeName != "" )
	{
		mRing1 = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}

	archetypeName = Data.GetStringValue( "Cape" );
	if( archetypeName != "" )
	{
		mCape = H7HeroItem( DynamicLoadObject( archetypeName, class'H7HeroItem') );
	}

	Init();
}

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame){}

/* Logs current game state for OOS */
function DumpCurrentState()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("    Equipment:", 0);;

	if(mHelmet != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      Helmet:"@mHelmet.GetName(), 0);;
	}
	if(mWeapon != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      Weapon:"@mWeapon.GetName(), 0);;
	}
	if(mChestArmor != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      ChestArmor:"@mChestArmor.GetName(), 0);;
	}
	if(mGloves != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      Gloves:"@mGloves.GetName(), 0);;
	}
	if(mShoes != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      Shoes:"@mShoes.GetName(), 0);;
	}
	if(mNecklace != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      Necklace:"@mNecklace.GetName(), 0);;
	}
	if(mRing1 != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      Ring:"@mRing1.GetName(), 0);;
	}
	if(mCape != none)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("      Cape:"@mCape.GetName(), 0);;
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
