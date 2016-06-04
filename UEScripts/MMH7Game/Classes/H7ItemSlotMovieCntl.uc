//=============================================================================
// H7ItemSlotMovieCntl
//
// super class for flash controllers whichs Swf movies contains item slots
// OPTIONAL can this be done as interface or better, structurally it's weird
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ItemSlotMovieCntl extends H7FlashMoviePopupCntl
	dependson(H7StructsAndEnumsNative);

var protected int cursorItemID;
var protected H7AdventureHero mCurrentHero;
var protected H7GFxInventory mInventory;
var protected H7GFxHeroEquip mHeroEquip;
var protected H7HeroItem dragItem;

function AddItemToCursor(optional int itemID)
{
	if(IsRightMouseDown()) {; return;} // can not pick stuff up with rightmouse

	if(dragItem == none) dragItem = mCurrentHero.GetInventory().GetItemByID(itemID, true);
	if(dragItem == none) dragItem = mCurrentHero.GetEquipment().GetItemByID(itemID, true);
	class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithItem(dragItem);
	cursorItemID = itemID;
	;

}

function AddItemIconToCursor(int itemID, bool itemIsStackable)
{
	if(dragItem == none) dragItem = mCurrentHero.GetInventory().GetItemByID(itemID, true);
	if(dragItem == none) dragItem = mCurrentHero.GetEquipment().GetItemByID(itemID, true);
	AddItemToCursor(itemID);
}

function RemoveItemIconFromCursor()
{
	if(GetPopup().IsVisible())
	{
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithItem();
		cursorItemID = -1;
		dragItem = none;
	}
}

function ChangeItemPos(int itemID, int x, int y)
{
	mCurrentHero.GetInventory().SetItemPos(itemID, x, y);
}

function ChangeItemPosStack(int itemID, int x, int y)
{
	mCurrentHero.GetInventory().SetItemPosStack(itemID, x, y);
}

function DropItemInInventory(int x, int y)
{
	if(!isItemOnCursor())return;
	;
	//mInventory.AddItemToDropSlot(mCurrentHero.GetInventory().GetItemByID(cursorItemID));
	//mInventory.AddItemToDropSlot(dragItem);
	ChangeItemPos(cursorItemID, x, y);
	RemoveItemIconFromCursor();
}

function SwitchItemsInInventory(int itemIDinDropSlot, int dragSlotX, int dragSlotY, int dropSlotX, int dropSlotY)
{
	;
	if(!isItemOnCursor())return;

	if(mCurrentHero.GetInventory().GetItemByID(cursorItemID).IsStackable() )
		ChangeItemPosStack(cursorItemID, dropSlotX, dropSlotY);
	else
		ChangeItemPos(cursorItemID, dropSlotX, dropSlotY);

	if(mCurrentHero.GetInventory().GetItemByID(itemIDinDropSlot).IsStackable() )
		ChangeItemPosStack(itemIDinDropSlot, dragSlotX, dragSlotY);
	else
		ChangeItemPos(itemIDinDropSlot, dragSlotX, dragSlotY);
	
	//mInventory.Update(mCurrentHero.GetInventory().GetItems(), mCurrentHero);
}

function MergeItemsInInventory(int itemIDinDropSlot, int dragSlotX, int dragSlotY, int dropSlotX, int dropSlotY)
{
	// items in drag and drop slot are stackable but from different type so switch
	if(mCurrentHero.GetInventory().GetItemByID(cursorItemID).GetName() != mCurrentHero.GetInventory().GetItemByID(itemIDinDropSlot).GetName())
	{
		SwitchItemsInInventory(itemIDinDropSlot, dragSlotX, dragSlotY, dropSlotX, dropSlotY);
		return;
	}

	;
	mCurrentHero.GetInventory().SetItemPos( dragItem.GetID(), dropSlotX, dropSlotY);// MergeStackableItems(itemIDinDropSlot, cursorItemID);
	//mInventory.AddItemToDropSlot(mCurrentHero.GetInventory().GetItemByPosition(dropSlotX, dropSlotY));
}

// this is the case we drag the item from EQUIP -> INV
function SwitchItemsFromInventoryToEquip(int itemIDinDropSlot, int dropSlotX, int dropSlotY)
{
	local H7HeroItem newItem, oldItem;

	;
	
	if(!isItemOnCursor())return;

	oldItem = mCurrentHero.GetEquipment().GetItemByID(cursorItemID);  // remove from EQUIP
	newItem = mCurrentHero.GetInventory().GetItemByID(itemIDinDropSlot); // insert to EQUIP

	if(newItem == none || oldItem == none)
	{
		return;
	}

	if( !newItem.CheckRestricted(mCurrentHero) )
	{
		// remove the new item from inventory
		mCurrentHero.GetInventory().RemoveItem(newItem);

		// set the old item to replace the newitems inventory slot
		mCurrentHero.GetInventory().AddItemToInventory(oldItem, dropSlotX, dropSlotY);
		
		// remove the olditem
		mCurrentHero.GetEquipment().RemoveItem(oldItem);

		// equip the new item to the equipment slot 
		mCurrentHero.GetEquipment().SetItem(newItem);
	}
	RemoveItemIconFromCursor();
}

function bool EquipItem()
{
	//when dropping an item picked up from inventory OR droping one ring in another ring slot
	local H7HeroItem item;
	;

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("EQUIP_ITEM");

	if(!isItemOnCursor()) return false;
	item = mCurrentHero.GetInventory().GetItemByID(cursorItemID, true);
    if(item == none) item = mCurrentHero.GetEquipment().GetItemByID(cursorItemID);
	if(item == none)
	{
		return false;
	}
	RemoveItemIconFromCursor();
    if( !item.CheckRestricted(mCurrentHero) )
	{
		mHeroEquip.AddItemToDropSlot(item);
	
		if( mCurrentHero.GetEquipment().GetItemByType(item.GetType() ) != none )
		{
			// dunno for what, so we keep it guarded
			mCurrentHero.GetEquipment().RemoveItem(item);
		}

		mCurrentHero.GetEquipment().SetItem(item);
		mCurrentHero.GetInventory().RemoveItem(item);

		return true;
	}
	return false;
}

function bool EquipItemByDoubleClick(int itemID)
{
	local H7HeroItem item, currentEquippedItem;
	item = mCurrentHero.GetInventory().GetItemByID(itemID, true);

	if(item == none)
	{
		return false;
	}

	 ;
	
	 currentEquippedItem = mCurrentHero.GetEquipment().GetItemByType(item.GetType());
	 if(currentEquippedItem != none)
	 {
		cursorItemID = itemID;
	 	SwitchItemsFromEquipToInventory(currentEquippedItem.GetID());
		return true;
	 }

	 if( !item.CheckRestricted(mCurrentHero) )
	 {
		mCurrentHero.GetEquipment().RemoveItem(item);
	 	mCurrentHero.GetEquipment().SetItem(item);
		mCurrentHero.GetInventory().RemoveItem(item);
		return true;
	 }
	 return false;
}

function SwitchItemsInEquip(int itemIDinDropSlot)
{
	local H7HeroItem tempItem;
	;
	if(!isItemOnCursor()) return;
	tempItem = mCurrentHero.GetEquipment().GetItemByID(itemIDinDropSlot);
	mHeroEquip.AddItemToDropSlot(mCurrentHero.GetEquipment().GetItemByID(cursorItemID));
	
	mHeroEquip.AddItemToDragSlot(tempItem);
	mCurrentHero.GetEquipment().SetItem(mCurrentHero.GetEquipment().GetItemByID(cursorItemID));
	mCurrentHero.GetEquipment().SetItem(tempItem);
	RemoveItemIconFromCursor();
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("EQUIP_ITEM");
	
}

// this is the case we drag the item from INV -> EQUIP
function SwitchItemsFromEquipToInventory(int itemIDinDropSlot)
{
	local IntPoint pos;
	local H7HeroItem newItem,oldItem;
	
	;
	
	if(!isItemOnCursor())
		return;
	
	newItem = mCurrentHero.GetInventory().GetItemByID(cursorItemID);
	oldItem = mCurrentHero.GetEquipment().GetItemByID(itemIDinDropSlot);

	if(newItem == none || oldItem == none)
	{
		return;
	}

	if( !newItem.CheckRestricted(mCurrentHero) )
	{
		// get inventory pos for new item
        pos = mCurrentHero.GetInventory().GetItemPosByItem(newItem);

		// remove the new item from inventory
		mCurrentHero.GetInventory().RemoveItem(newItem);

		// set the old item to replace the newitems inventory slot
		mCurrentHero.GetInventory().AddItemToInventory(oldItem, pos.x, pos.y);
		
		// remove the olditem
		mCurrentHero.GetEquipment().RemoveItem(oldItem);

		// equip the new item to the equipment slot 
		mCurrentHero.GetEquipment().SetItem(newItem);

		// no clue what kind of GUI magic this is
		//mHeroEquip.AddItemToDropSlot(newItem);
		//mInventory.AddItemToDragSlot(oldItem);
	}

	RemoveItemIconFromCursor();
}

function UnequipItem(int dropSlotX, int dropSlotY)
{
	local H7HeroItem item;
	item = mCurrentHero.GetEquipment().GetItemByID(cursorItemID);

	if(item == none)
	{
		return;
	}

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("UNEQUIP_ITEM");

	//when dragging item from equip to empty inventory slot
	mInventory.AddItemToDropSlot(item);

	mCurrentHero.GetInventory().AddItemToInventory(item, dropSlotX, dropSlotY);
	mCurrentHero.GetEquipment().RemoveItem(item);

	RemoveItemIconFromCursor();
}

function bool CanEquipItem(bool checkCurrentHero)
{
	local H7HeroItem item;
	item = mCurrentHero.GetInventory().GetItemByID(cursorItemID, true);

	if(item == none || item.GetType() == ITYPE_CONSUMABLE || item.GetType() == ITYPE_SCROLL) 
		return false;

	return !item.CheckRestricted(mCurrentHero);
}

function bool isItemOnCursor()
{
	if(cursorItemID == -1)
	{
		;
		return false;
	}
	return true;
}

function ConsumePotion(int itemID)
{
	;
	mCurrentHero.GetInventory().GetItemByID(itemID).Consume();
	mInventory.Update( mCurrentHero.GetInventory().GetItems(), mCurrentHero);
}
