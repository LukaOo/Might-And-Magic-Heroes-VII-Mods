//=============================================================================
// H7HeroTradeWindowCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroTradeWindowCntl extends H7ItemSlotMovieCntl; 

var protected H7GFxHeroTradeWindow mHeroTradeWindow;

var protected H7GFxHeroInfo mHeroInfo1;
var protected H7GFxHeroEquip mHeroEquip1;
var protected H7GFxInventory mInventory1;
var protected H7GFxArmyRow mArmyRow1;
var protected H7GFxWarfareUnitRow mWarfareUnitRow1;

var protected H7GFxHeroInfo mHeroInfo2;
var protected H7GFxHeroEquip mHeroEquip2;
var protected H7GFxInventory mInventory2;
var protected H7GFxArmyRow mArmyRow2;
var protected H7GFxWarfareUnitRow mWarfareUnitRow2;
var protected array<IntPoint> mInventory2ItemsPoses;
var protected array<int> mArmy2CreaturePosses;
var protected array<H7StackCount> mArmy2Original;

var protected int mHeroID1;
var protected H7AdventureArmy mArmy1; 
var protected H7AdventureHero mHero1;
var protected int mHeroID2;
var protected H7AdventureArmy mArmy2;
var protected H7AdventureHero mHero2;

var protected H7GFxInventory dropInventory;

var protected int mDismissArmy;
var protected int mDismissIndex;

var protected bool mAlliedTrade;
var protected Array<H7BaseCreatureStack> mTradedCreatures;
var protected Array<H7HeroItem> mTradedItems;
var protected Array<IntPoint>mTradedItemPoses;

function H7GFxHeroTradeWindow GetHeroTradeWindow() {return mHeroTradeWindow;}
function H7GFxUIContainer GetPopUp() {return mHeroTradeWindow;}

function bool Initialize()
{
	;
	Super.Start();
	AdvanceDebug(0);

	mHeroTradeWindow = H7GFxHeroTradeWindow(mRootMC.GetObject("aHeroTradeWindow", class'H7GFxHeroTradeWindow'));
	
	mHeroInfo1 = H7GFxHeroInfo(mHeroTradeWindow.GetObject("mHeroInfo1", class'H7GFxHeroInfo'));
	mHeroEquip1 = H7GFxHeroEquip(mHeroTradeWindow.GetObject("aHeroEquip1", class'H7GFxHeroEquip'));
	mInventory1 = H7GFxInventory(mHeroTradeWindow.GetObject("aInventory1", class'H7GFxInventory'));
	mArmyRow1 = H7GFxArmyRow(mHeroTradeWindow.GetObject("aArmyRow1", class'H7GFxArmyRow'));
	mWarfareUnitRow1 = H7GFxWarfareUnitRow(mHeroTradeWindow.GetObject("aWarfareRow1", class'H7GFxWarfareUnitRow'));

	mHeroInfo2 = H7GFxHeroInfo(mHeroTradeWindow.GetObject("mHeroInfo2", class'H7GFxHeroInfo'));
	mHeroEquip2 = H7GFxHeroEquip(mHeroTradeWindow.GetObject("aHeroEquip2", class'H7GFxHeroEquip'));
	mInventory2 = H7GFxInventory(mHeroTradeWindow.GetObject("aInventory2", class'H7GFxInventory'));
	mArmyRow2 = H7GFxArmyRow(mHeroTradeWindow.GetObject("aArmyRow2", class'H7GFxArmyRow'));
	mWarfareUnitRow2 = H7GFxWarfareUnitRow(mHeroTradeWindow.GetObject("aWarfareRow2", class'H7GFxWarfareUnitRow'));

	mHeroTradeWindow.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function Update( H7AdventureHero hero, H7AdventureHero targetHero, optional bool isAlliedTrade = false )
{
	local H7HeroItem ring1_1, ring2_1;
	local array<H7HeroItem> items;
	local array<H7BaseCreatureStack> stacks;
	local int i;
	
	// multiplayer games, only show the screen for the local player
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && !hero.GetPlayer().IsControlledByLocalPlayer() )
	{
		return;
	}

	//if target hero is not a hero -> a caravan has been clicked so we open the mergerPopUp
	if(!targetHero.IsHero())
	{
		H7AdventureHud(GetHUD()).GetCombatPopUpCntl().StartCaravanMerger(hero.GetArmy(), targetHero.GetArmy());
		return;
	}

	;
	mAlliedTrade = isAlliedTrade;
	mHeroID1 = hero.GetID();
	mArmy1 = hero.GetAdventureArmy();
	mCurrentHero = mArmy1.GetHero();
	mArmy2 = targetHero.GetAdventureArmy();
	mHero1 = mArmy1.GetHero();
	mHero2 = targetHero;
	
	mArmyRow1.Update(mArmy1);
	mArmyRow2.Update(mArmy2);

	mWarfareUnitRow1.Update(mArmy1);
	mWarfareUnitRow2.Update(mArmy2);

	if(!targetHero.IsA('H7Caravan') )
	{ 
		if(mHero2.GetEquipment().GetRing1() != none) ring2_1 = mHero2.GetEquipment().GetRing1();
		
		mInventory2ItemsPoses = mHero2.GetInventory().GetItemPoses();
		if(mAlliedTrade)
		{
			mHeroEquip2.SetLocked(true);
			mInventory2.SetLocked(true, mInventory2ItemsPoses);
		}
		else
		{
			mHeroEquip2.SetLocked(false);
			mInventory2.SetLocked(false);
		}

		
		mHero2.GetEquipment().GetItemsAsArray(items);
		mHeroEquip2.Update(items, ring2_1, mHero2);
		
		mInventory2.Update(mHero2.GetInventory().GetItems(), mHero2);
		mInventory2.ListenTo(mHero2);
		
		mArmy2Original = GetStackCount(mArmy2.GetBaseCreatureStacks());
		mArmy2CreaturePosses.Length = 0;
		stacks = mArmy2.GetBaseCreatureStacks();
		for(i = 0; i < stacks.Length;i++)
		{
			if(stacks[i] != none) mArmy2CreaturePosses.AddItem(i);
		}
		if(mAlliedTrade) 
		{
			mArmyRow2.AddLockIconToUnitSlots(mArmy2CreaturePosses);
			mWarfareUnitRow2.AddLockIconToUnitSlots();
		}
		mHeroEquip2.ListenTo(mHero2);
	}

	if(mHero1.GetEquipment().GetRing1() != none) ring1_1 = mHero1.GetEquipment().GetRing1();
	mHero1.GetEquipment().GetItemsAsArray(items);
	mHeroEquip1.Update(items, ring1_1, mHero1);
    mHeroEquip1.ListenTo(mHero1);

	mInventory1.Update(mHero1.GetInventory().GetItems(), mHero1);
	mInventory1.ListenTo(mHero1);

	mHeroTradeWindow.Update(mHero1, mHero2, isAlliedTrade);
	mHeroInfo1.Update(mHero1);
	mHeroInfo2.Update(mHero2);
	mHeroTradeWindow.SetVisibleSave(true);

	mHeroTradeWindow.UpdateMergeButtons(mArmy1, mArmy2, mAlliedTrade);

	OpenPopup();

	H7AdventureHud( GetHud() ).BlockFlashBelow(self);
	//H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(true);
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetRelevantPopupOpen(true);
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().DisableHeroHUDMiniMapTownList();
}

function CheckAlliedTradeAndAddFilters()
{
	if(mAlliedTrade) mArmyRow2.AddLockIconToUnitSlots(mArmy2CreaturePosses);
}

///////////////////STATS///////////////////////////////////////

function GetStatModSourceList(String statStr,int unrealID)
{
	local H7Unit unit;
	local EStat stat;
	local array<H7StatModSource> mods;
	local int i;

	;

	if(unrealID == mHero1.GetID())
		unit = mHero1;
	else if(unrealID == mHero2.GetID())
		unit = mHero2;
	else
	{
		;
		return;
	}

	for(i=0;i<=STAT_MAX;i++)
	{
		stat = EStat(i);
		if(String(stat) == statStr)
		{
			break;
		}
	}

	// special redirects
	if(statStr == "DAMAGE") stat = STAT_MIN_DAMAGE; 
	if(statStr == "STAT_MOVEMENT_TYPE") stat = STAT_MAX_MOVEMENT;

	if(stat == STAT_MAX)
	{
		;
		return;
	}

	;

	mods = unit.GetStatModSourceList(stat);

	if(unrealID == mHero1.GetID())
		mHeroInfo1.SetStatModSourceList(mods);
	else 
		mHeroInfo2.SetStatModSourceList(mods);
	
}

//////////////////ITEM TRADING/////////////////////////////////

function bool CanEquipItem(bool checkCurrentHero)
{
	local H7HeroItem item;
	item = mCurrentHero.GetInventory().GetItemByID(cursorItemID, true);
	if(item == none)
		item = mCurrentHero.GetEquipment().GetItemByID(cursorItemID, true);

	if(item.GetType() == ITYPE_CONSUMABLE || item.GetType() == ITYPE_SCROLL) 
		return false;

	if(checkCurrentHero)
	{
		return !item.CheckRestricted(mCurrentHero);
	}
	else
	{
		if(mCurrentHero == mHero1)
			return !item.CheckRestricted(mHero2);
		else
			return !item.CheckRestricted(mHero1);
	}
}

function bool EquipItemByDoubleClick(int itemID)
{
	if(super.EquipItemByDoubleClick(itemID))
	{
		//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);		
		return true;
	}
	return false;
}

function ChangeItemPos(int itemID, int x, int y)
{
	;
	super.ChangeItemPos(itemID, x, y);
		
}

function AddItemIconToCursor(int itemID, bool itemIsStackable)
{
	SetCurrentHero(itemID);
	Super.AddItemIconToCursor(itemID, itemIsStackable);
}

function DropItemInInventory(int posX, int posY)
{
	if(!isItemOnCursor()) return;
	Super.DropItemInInventory(posX, posY);
}

function TradeDropItemInInventory(int posX, int posY)
{
	local H7AdventureHero receivingHero;
	local H7EventContainerStruct eventContainer;
	local H7HeroItem item;
	local IntPoint itemPos;

	if(!isItemOnCursor()) return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; } 
	;
	
	receivingHero = mCurrentHero == mHero1 ? mHero2 : mHero1;
	item = dragItem;

	eventContainer.EffectContainer = item;
	eventContainer.Targetable = mCurrentHero;

	mCurrentHero.GetInventory().RemoveItemByID( cursorItemID );
	
	//check if item with this name is gone!
	item.TriggerEvents( ON_LOSE_ITEM, false, eventContainer );
	
	receivingHero.GetInventory().AddItemToInventory(item, posX, posY);
	
	if(mAlliedTrade && mHero1 == mCurrentHero)
	{
		;
		mTradedItems.AddItem( item );
		itemPos.X = posX; itemPos.Y = posY;
		mTradedItemPoses.AddItem(itemPos);
	}
	else if(mAlliedTrade)
	{
		;
		mTradedItemPoses.Remove(mTradedItems.Find(item), 1);
		mTradedItems.RemoveItem( item );
	}
	eventContainer.Targetable = none;
	mCurrentHero.TriggerEvents( ON_LOSE_ITEM, false, eventContainer );
	receivingHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	eventContainer.Targetable = receivingHero;
	item.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );

	if(mAlliedTrade) mInventory2.AddLockToItemSlots();

	RemoveItemIconFromCursor();
}

function SetDragItemByID(int itemID)
{
	dragItem = mHero1.GetInventory().GetItemByID(itemID, true);
	if(dragItem == none) dragItem = mHero1.GetEquipment().GetItemByID(itemID, true);
	if(dragItem == none) dragItem = mHero2.GetInventory().GetItemByID(itemID, true);
	if(dragItem == none) dragItem = mHero2.GetEquipment().GetItemByID(itemID, true);
}

function SwitchItemsInInventory(int itemIDinDropSlot, int dragSlotX, int dragSlotY, int dropSlotX, int dropSlotY)
{
	SetCurrentHero(itemIDInDropSlot);
	Super.SwitchItemsInInventory(itemIDinDropSlot, dragSlotX, dragSlotY, dropSlotX, dropSlotY);
}

function MergeItemsInInventory(int itemIDinDropSlot, int dragSlotX, int dragSlotY, int dropSlotX, int dropSlotY)
{
	;
	if(!isItemOnCursor()) return;
	//currentHero already set by AddItemIconToCursor
	Super.MergeItemsInInventory(itemIDinDropSlot, dragSlotX, dragSlotY, dropSlotX, dropSlotY);
	
	if(mAlliedTrade) mInventory2.AddLockToItemSlots();
}

function bool HasTradedConsumeableOnSlot(int dropSlotX, int dropSlotY)
{
	local IntPoint pos;
	local int i;

	if(dragItem.GetType() != ITYPE_SCROLL && dragItem.GetType() != ITYPE_CONSUMABLE) return false;
	
	pos.X = dropSlotX;
	pos.Y = dropSlotY;

	for(i = 0; i < mTradedItems.Length; i++)
	{
		if(dragItem.GetName() == mTradedItems[i].GetName())
		{
			if(pos == mTradedItemPoses[i]);
				return true;
		}
	}

	return false;
}

function TradeMergeItemsInInventory(int dropSlotItemID, int dragSlotX, int dragSlotY, int dropSlotX, int dropSlotY)
{
	if(!isItemOnCursor()) return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; }
	;
	if(mAlliedTrade && !HasTradedConsumeableOnSlot(dropSlotX, dropSlotY)) 
	{
		;
		RemoveItemIconFromCursor();
		return;
	}

	;
	TradeDropItemInInventory(dropSlotX, dropSlotY);
}

function TradeSwitchItemsInInventory(int itemIDInDropSlot, int dragSlotX, int dragSlotY, int dropSlotX, int dropSlotY)
{
	local H7AdventureHero receivingHero;
	local array<H7HeroItem> itemsToReceiver, itemsToGiver; 
	local int i;
	local H7EventContainerStruct eventContainer1, eventContainer2;

	if(!isItemOnCursor()) return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; }
	;
	if(mAlliedTrade) 
	{
		RemoveItemIconFromCursor();
		;
		return;
	}
	SetCurrentHero(cursorItemID);
	receivingHero = mCurrentHero == mHero1 ? mHero2 : mHero1;
	
	// 1. get items witch are to be switched
	itemsToReceiver = mCurrentHero.GetInventory().getItemsByPosition(dragSlotX, dragSlotY);
    itemsToGiver = receivingHero.GetInventory().getItemsByPosition(dropSlotX, dropSlotY);
	
	eventContainer1.Targetable = mCurrentHero;
	eventContainer1.EffectContainer = itemsToReceiver[0];
	eventContainer2.Targetable = receivingHero;
	eventContainer2.EffectContainer = itemsToGiver[0];

	// 2. remove the items we just temporarily saved from their origin inventories
	mCurrentHero.GetInventory().RemoveItemStackByID(cursorItemID);
	receivingHero.GetInventory().RemoveItemStackByID(itemIDInDropSlot);

	itemsToReceiver[0].TriggerEvents( ON_LOSE_ITEM, false, eventContainer1 );
	itemsToGiver[0].TriggerEvents(ON_LOSE_ITEM, false, eventContainer2);

	// 3. add items to thier tartget inventories
	for(i=0; i < itemsToReceiver.Length; i++)
    {
		receivingHero.GetInventory().AddItemToInventory(itemsToReceiver[i], dropSlotX, dropSlotY);
    }
	
	for(i=0; i < itemsToGiver.Length; i++)
	{
		mCurrentHero.GetInventory().AddItemToInventory(itemsToGiver[i], dragSlotX, dragSlotY);
	}	

	eventContainer1.Targetable = none;
	mCurrentHero.TriggerEvents( ON_LOSE_ITEM, false, eventContainer1 );
	receivingHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer1 );
	eventContainer1.Targetable = receivingHero;
	itemsToReceiver[0].TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer1 );

	eventContainer2.Targetable = none;
	receivingHero.TriggerEvents( ON_LOSE_ITEM, false, eventContainer2 );
	mCurrentHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer2 );
	eventContainer2.Targetable = mCurrentHero;
	itemsToGiver[0].TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer2 );

	if(mAlliedTrade) mInventory2.AddLockToItemSlots();

	RemoveItemIconFromCursor();
}

function SwitchItemFromInventoryToEquip(int itemIDinDropSlot, int dropSlotX, int dropSlotY)
{
	SetInventory(itemIDInDropSlot);
	SetCurrentHero(itemIDinDropSlot);
	Super.SwitchItemsFromInventoryToEquip(itemIDinDropSlot, dropSlotX, dropSlotY);
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function TradeSwitchItemsFromInventoryToEquip(int itemIDinDropSlot)
{
	local H7AdventureHero receivingHero;
	local H7HeroItem exEquipItem, exInvItem;
	local IntPoint exInvItemPos;

	if(!isItemOnCursor())return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; }
	;
	if(mAlliedTrade) 
	{
		RemoveItemIconFromCursor();
		;
		return;
	}
	SetCurrentHero(cursorItemID);
	if(mCurrentHero == mHero1) {receivingHero = mHero2; exEquipItem = mHero1.GetEquipment().GetItemByID(cursorItemID);
								exInvItem = mHero2.GetInventory().GetItemByID(itemIDinDropSlot);
								exInvItemPos = mHero2.GetInventory().GetItemPosByItem(exInvItem);
	}
								
	else {receivingHero = mHero1; exEquipItem = mHero2.GetEquipment().GetItemByID(cursorItemID);
								  exInvItem = mHero1.GetInventory().GetItemByID(itemIDinDropSlot);
								  exInvItemPos = mHero1.GetInventory().GetItemPosByItem(exInvItem);
	}

	if( ! exInvItem.CheckRestricted(mCurrentHero) )
	{
		receivingHero.GetInventory().AddItemToInventory(exEquipItem, exInvItemPos.X, exInvItemPos.Y);
		mCurrentHero.GetEquipment().SetItem(exInvItem);

		receivingHero.GetInventory().RemoveItem(exInvItem);	
	}
	RemoveItemIconFromCursor();
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function bool EquipItem()
{
	SetCurrentHero(cursorItemID);	
	if( Super.EquipItem() ) 
	{
		mHeroTradeWindow.RemoveItemFromDragSlot();
		//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
		return true;
	}
	return false;
}

function TradeEquipItem()
{
	local H7AdventureHero receivingHero;
	local H7HeroItem item;
	local H7EventContainerStruct eventContainer;
	local array<H7HeroItem> items;

	;

	if(!isItemOnCursor())return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; }

	SetCurrentHero(cursorItemID);
	if(mCurrentHero == mHero1) 
		receivingHero = mHero2;
	else 
		receivingHero = mHero1; 


	item = mCurrentHero.GetInventory().GetItemByID(cursorItemID);
	if(item == none)
	{
		item = mCurrentHero.GetEquipment().GetItemByID(cursorItemID);
	}

	if( !item.CheckRestricted( receivingHero ) )
	{
		if(mCurrentHero.GetInventory().HasItem(item))
		{
			mCurrentHero.GetInventory().RemoveItem(item);
		}
		if(mCurrentHero.GetEquipment().HasItemEquipped(item))
		{
			mCurrentHero.GetEquipment().RemoveItem(item);
		}
		eventContainer.Targetable = none;
		
		receivingHero.GetEquipment().SetItem(item);

		eventContainer.Targetable = mCurrentHero;
		eventContainer.EffectContainer = item;
		eventContainer.Targetable = mCurrentHero;
		item.TriggerEvents( ON_LOSE_ITEM, false, eventContainer );
		eventContainer.Targetable = none;
		mCurrentHero.TriggerEvents( ON_LOSE_ITEM, false, eventContainer );

		receivingHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
		eventContainer.Targetable = receivingHero;
		item.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	
		if(mCurrentHero == mHero1)
		{
			mInventory1.Update(mHero1.GetInventory().GetItems(), mHero1);
			mHero1.GetEquipment().GetItemsAsArray(items);
			mHeroEquip1.Update(items, mHero1.GetEquipment().GetRing1(), mHero1);
		}
		else
		{
			mInventory2.Update(mHero2.GetInventory().GetItems(), mHero2);
			mHero2.GetEquipment().GetItemsAsArray(items);
			mHeroEquip2.Update(items, mHero2.GetEquipment().GetRing1(), mHero2);
		}
	}
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
	RemoveItemIconFromCursor();
}

function SwitchItemsInEquip(int itemIDinDropSlot)
{
	SetCurrentHero(cursorItemID);
	super.SwitchItemsInEquip(itemIDinDropSlot);
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function TradeSwitchItemsInEquip(int itemIDinDropSlot)
{
	local H7AdventureHero receivingHero;
	local H7HeroItem tempItem;

	if(!isItemOnCursor()) return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; }
	;
	if(mAlliedTrade) 
	{
		RemoveItemIconFromCursor();
		;
		return;
	}
	SetCurrentHero(cursorItemID);
	if(mCurrentHero == mHero1) 
	{
		receivingHero = mHero2; 
		// if one of the heroes cant equip the traded item abort the trade
		if(mCurrentHero.GetEquipment().GetItemByID(cursorItemID).CheckRestricted(receivingHero)
		   || receivingHero.GetEquipment().GetItemByID(itemIDinDropSlot).CheckRestricted( mCurrentHero ))
			return;
	}
	else 
	{
		receivingHero = mHero1;
		// if one of the heroes cant equip the traded item abort the trade
		if(mCurrentHero.GetEquipment().GetItemByID(cursorItemID).CheckRestricted(receivingHero)
		   || receivingHero.GetEquipment().GetItemByID(itemIDinDropSlot).CheckRestricted( mCurrentHero )) 
			return;
	}
	tempItem = receivingHero.GetEquipment().GetItemByID(itemIDinDropSlot);
	receivingHero.GetEquipment().SetItem(mCurrentHero.GetEquipment().GetItemByID(cursorItemID));
	mCurrentHero.GetEquipment().SetItem(tempItem);
	RemoveItemIconFromCursor();
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function SwitchItemsFromEquipToInventory(int itemIDinDropSlot)
{
	SetCurrentHero(cursorItemID);
	Super.SwitchItemsFromEquipToInventory(itemIDinDropSlot);
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function TradeSwitchItemsFromEquipToInventory(int itemIDinDropSlot, int dragSlotX, int dragSlotY)
{
	local H7AdventureHero receivingHero;
	local H7HeroItem exEquipItem, exInvItem;

	if(!isItemOnCursor())return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; }
	;
	if(mAlliedTrade) 
	{
		RemoveItemIconFromCursor();
		;
		return;
	}
	SetCurrentHero(cursorItemID);
	if(mCurrentHero == mHero1) 
	{   receivingHero = mHero2;
		exEquipItem = receivingHero.GetEquipment().GetItemByID(itemIDinDropSlot);
		exInvItem = mHero1.GetInventory().GetItemByID(cursorItemID);
	}
								
	else {receivingHero = mHero1; 
		  exEquipItem = receivingHero.GetEquipment().GetItemByID(itemIDinDropSlot);
		  exInvItem = mHero2.GetInventory().GetItemByID(cursorItemID); 
	}

	if( ! exInvItem.CheckRestricted(receivingHero) )
	{	
		mCurrentHero.GetInventory().AddItemToInventory(exEquipItem, dragSlotX, dragSlotY);
		receivingHero.GetEquipment().SetItem(exInvItem);

		//mInventory.AddItemToDragSlot(exEquipItem);	

		mCurrentHero.GetInventory().RemoveItem(exInvItem);	
	}
	RemoveItemIconFromCursor();
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function UnequipItem(int posX, int posY)
{
	SetCurrentHero(cursorItemID);
	Super.UnequipItem(posX, posY);
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function TradeUnequipItem(int posX, int posY)
{
	local H7AdventureHero receivingHero;
	local H7HeroItem item;
	local H7EventContainerStruct eventContainer;

	if(!isItemOnCursor()) return;
	if(mHero2==none) { RemoveItemIconFromCursor(); return; }
	;
	SetCurrentHero(cursorItemID);

	receivingHero = mCurrentHero == mHero1 ? mHero2 : mHero1;
	item = mCurrentHero.GetEquipment().GetItemByID(cursorItemID);
	receivingHero.GetInventory().AddItemToInventory(mCurrentHero.GetEquipment().GetItemByID(cursorItemID), posX, posY);

	eventContainer.EffectContainer = item;
	eventContainer.Targetable = mCurrentHero;
	item.TriggerEvents( ON_LOSE_ITEM, false, eventContainer );
	mCurrentHero.GetEquipment().RemoveItem(item);
	mHeroTradeWindow.RemoveItemFromDragSlot();

	
	eventContainer.Targetable = none;
	mCurrentHero.TriggerEvents( ON_LOSE_ITEM, false, eventContainer );
	receivingHero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	eventContainer.Targetable = receivingHero;
	item.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
	
	mTradedItems.AddItem(receivingHero.GetInventory().GetItemByID(cursorItemID));
	RemoveItemIconFromCursor();
	//mHeroTradeWindow.UpdateHeroInfoAfterEquipChange(mHero1, mHero2);
}

function SetInventory(int itemID)
{
	if(mHero1.GetInventory().GetItemByID(itemID)!=none)
	{ mInventory = mInventory1; dropInventory = mInventory2;}
	else { mInventory = mInventory2; dropInventory = mInventory1;}
}

function SetEquip(int itemID)
{
	if(mHero1.GetEquipment().GetItemByID(itemID)!=none) 
	{ mHeroEquip = mHeroEquip1; }
	else { mHeroEquip = mHeroEquip2; }
}

function SetCurrentHero(int itemID)
{
	if( (mHero1.GetInventory().GetItemByID(itemID)!=none) || 
		(mHero1.GetEquipment().GetItemByID(itemID)!=none))
	{
		;
		mCurrentHero = mHero1;
		mInventory = mInventory1;
		mHeroEquip = mHeroEquip1;
	}
	else
	{
		;
		mCurrentHero = mHero2;
		mInventory = mInventory2;
		mHeroEquip = mHeroEquip2;
	}
}

///////////////////////////ARMY ROW////////////////////////////////////////////

function AddUnitIconToCursor(int slotID, int armyID)
{
	local array<H7BaseCreatureStack> stacks;
	if(mArmy1.GetHero().GetID() == armyID)
	{
		stacks = mArmy1.GetBaseCreatureStacks();
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack(stacks[slotID]);
		
		if(mAlliedTrade)
		{
			mArmyRow2.HighlightUnitSlotsByCreatureName(stacks[slotID].GetStackType().GetName());
		}
	}
	else
	{
		stacks = mArmy2.GetBaseCreatureStacks();
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack(stacks[slotID]);
	}
}

function BtnMergeArmy1Clicked()
{
	local H7InstantCommandMergeArmiesAdventure command;

	command = new class'H7InstantCommandMergeArmiesAdventure';
	command.Init(mArmy1, mArmy2);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function BtnMergeArmy2Clicked()
{
	local H7InstantCommandMergeArmiesAdventure command;

	command = new class'H7InstantCommandMergeArmiesAdventure';
	command.Init(mArmy2, mArmy1);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

// TODO why are the integers swapped?
function RequestTransfer(int dragSlotIndex, int dragSlotArmyID, int dropSlotIndex, int dropSlotArmyID, optional int amount)
{
	;
	if(dropSlotArmyID == 0) dropSlotArmyID = dragSlotArmyID;
	if(dropSlotIndex != -1 && amount == 0)
	{
		class'H7EditorArmy'.static.TransferCreatureStacksByArmy( mArmy1, dragSlotArmyID == mArmy1.GetHero().GetID() ? mArmy1 : mArmy2, dropSlotArmyID == mArmy1.GetHero().GetID() ? mArmy1 : mArmy2, dragSlotIndex, dropSlotIndex, amount);
	}
	else
	{
		class'H7EditorArmy'.static.SplitCreatureStackToEmptySlot( dragSlotArmyID == mArmy1.GetHero().GetID() ? mArmy1 : mArmy2,
			                                                      dropSlotArmyID == mArmy1.GetHero().GetID() ? mArmy1 : mArmy2,
			                                                      dragSlotIndex, 
			                                                      amount, 
			                                                      dropSlotIndex, 
			                                                      dragSlotArmyID != dropSlotArmyID ? true : false);
	}
}

function CompleteTransfer(bool success)
{
	if(!success)
		return;

	mArmyRow1.Update(mArmy1);
	mArmyRow2.Update(mArmy2);
	if(mAlliedTrade) mArmyRow2.AddLockIconToUnitSlots(mArmy2CreaturePosses);
}

////////////////////////////////WARFAREUNITROW/////////////////////////////////////////////////
function AddWarfareUnitIconToCursor(EWarUnitClass warUnitClassInt, int armyID)
{
	if(mArmy1.GetHero().GetID() == armyID)
	{
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithWarfareUnit(mArmy1.GetWarUnitByType(warUnitClassInt));
	}
	else
	{
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithWarfareUnit(mArmy2.GetWarUnitByType(warUnitClassInt));
	}
}

function RequestWarfareUnitTransfer(EWarUnitClass dragSlotClass, int dragSlotArmyID, EWarUnitClass dropSlotClass, int dropSlotArmyID)
{
	local array<H7EditorWarUnit> targetWarUnits;
	local H7EditorArmy targetArmy;
	local H7EditorWarUnit unit;
	local H7InstantCommandTransferWarUnit command;

	// make sure dragslot and dropslot are from different armies
	;

	if(dragSlotArmyID == dropSlotArmyID) return;

	if(dragSlotArmyID == mArmy1.GetHero().GetID()) 
	{ 
		targetArmy = mArmy2;
		targetWarUnits = mArmy2.GetWarUnitTemplates();
	}
	else
	{ 
		targetArmy = mArmy1;
		targetWarUnits = mArmy1.GetWarUnitTemplates();
	}

	// make sure targetArmy does not already contain a warfare unit of that type
	foreach targetWarUnits(unit)
	{
		if(unit.GetWarUnitClass() == dragSlotClass) return;
	}

	//allied trade && dragged unit is hybrid && target has more the just the siege unit
	if(mAlliedTrade && dragSlotClass == WCLASS_HYBRID && targetWarUnits.Length > 1) return;

	//allied trade && target has hybrid warUnit
	if(mAlliedTrade && targetArmy.HasHybridWarUnit()) return;

	if(dropSlotClass == WCLASS_SIEGE) return;

	command = new class'H7InstantCommandTransferWarUnit';
	command.Init(mArmy1, mArmy2, dragSlotClass, dragSlotArmyID, dropSlotClass);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function RequestWarfareUnitTransferComplete()
{
	mWarfareUnitRow1.Update(mArmy1);
	mWarfareUnitRow2.Update(mArmy2);
	if(mAlliedTrade) mWarfareUnitRow2.AddLockIconToUnitSlots();
}

// DISMISS ---------------------------

function DismissStack(int unitIndex,optional int armyIndex)
{
	;
	
	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;
	if( armyIndex == 1 && mArmy1.GetBaseStackBySourceSlotId( unitIndex ).IsDismissDisabled() ||
		armyIndex == 2 && mArmy2.GetBaseStackBySourceSlotId( unitIndex ).IsDismissDisabled() )
	{
		return;
	}

	mDismissArmy = armyIndex;
	mDismissIndex = unitIndex;
	
	GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("REALLY_DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("CANCEL","H7General"),DismissConfirm, DismissDenied);
}

function DismissConfirm()
{
	if(mDismissArmy == 1)
	{
		mArmy1.RemoveCreatureStackByIndex(mDismissIndex);
		mArmyRow1.StackDismissed();
		mHeroTradeWindow.UpdateMergeButtons(mArmy1, mArmy2, mAlliedTrade);
	}
	else if(mDismissArmy == 2)
	{
		mArmy2.RemoveCreatureStackByIndex(mDismissIndex);
		mArmyRow2.StackDismissed();
		mHeroTradeWindow.UpdateMergeButtons(mArmy1, mArmy2, mAlliedTrade);
	}
	else
	{
		;
	}
}

function DismissDenied()
{
	mDismissArmy = -1;
	mDismissIndex = -1;
}

function BtnDoneClicked()
{
	/*local String tradingText;

	if(mTradedItems.Length > 0 && mTradedCreatures.Length > 0)
	{
		tradingText = `Localize("H7Message", "MSG_YOU_ARE_ABOUT_TO_TRADE_ITEMS_AND_CREATURES", "MMH7Game");
	}
	else if(mTradedItems.Length > 0)
	{
		tradingText = `Localize("H7Message", "MSG_YOU_ARE_ABOUT_TO_TRADE_ITEMS", "MMH7Game");
	}
	else if(mTradedCreatures.Length > 0)
	{
		tradingText = `Localize("H7Message", "MSG_YOU_ARE_ABOUT_TO_TRADE_CREATURES", "MMH7Game");
	}

	if(tradingText != "")
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup(tradingText $ "." @ `Localize("H7Message", "MSG_ARE_YOU_SURE", "MMH7Game"), `Localize("H7General", "YES", "MMH7Game"), `Localize("H7General", "NO", "MMH7Game"), Closed, none);
	}
	else
	{*/
		ClosePopUp();
}

function Closed() // via flash close button
{
	ClosePopup();
}

function array<H7StackCount> GetStackCountDiff(array<H7StackCount> oldState,array<H7StackCount> newState)
{
	local array<H7StackCount> diff;
	local H7StackCount stackCount1,stackCount2;
	local int i;
	local bool createNewEntry;

	diff = newState;
	foreach oldState(stackCount1)
	{
		createNewEntry = true;
		foreach diff(stackCount2,i)
		{
			if(stackCount2.type == stackCount1.type)
			{
				diff[i].count -= stackCount1.count;
				createNewEntry = false;
			}
		}
		if(createNewEntry) // was not in newState
		{
			stackCount2.type = stackCount1.type;
			stackCount2.count = -stackCount1.count; // was removed
			diff.AddItem(stackCount2);
		}
	}

	return diff;
}

function array<H7StackCount> GetStackCount(array<H7BaseCreatureStack> oldState)
{
	local H7BaseCreatureStack stack;
	local array<H7StackCount> stackCounts;
	local H7StackCount stackCount;
	local int i;
	local bool createNewEntry;

	stackCounts.Length = 0; // compiler supressor

	foreach oldState(stack)
	{
		createNewEntry = true;
		foreach stackCounts(stackCount,i)
		{
			if(stackCount.type == stack.GetStackType())
			{
				stackCounts[i].count += stack.GetStackSize();
				createNewEntry = false;
			}
		}
		if(createNewEntry)
		{
			stackCount.type = stack.GetStackType();
			stackCount.count = stack.GetStackSize();
			stackCounts.AddItem(stackCount);
		}
	}

	return stackCounts;
}

// master close - via flash close button, done button, or esc button
function ClosePopup()
{
	local array<H7StackCount> stackDiff;
	local H7StackCount stackCount;

	if(mAlliedTrade)
	{
		stackDiff = GetStackCountDiff(mArmy2Original, GetStackCount(mArmy2.GetBaseCreatureStacks()));
		;
		ForEach stackDiff(stackCount)
		{
			;
		
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTradeResultCntl().AddReceivedCreature(stackCount, mArmy2.GetHero(), mArmy1.GetHero());
		}
	}

	
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendTradeFinished( mHeroID1 );
	}

	mHeroID1 = -1;
	mHeroID2 = -1;
	// if we empty a caravan, we need to destroy it!
	if( mArmy1.IsACaravan() && !mArmy1.HasUnits( true ) )
	{
		class'H7AdventureController'.static.GetInstance().RemoveArmy( mArmy1 );
		mArmy1.Destroy();
	}
	if( mArmy2.IsACaravan() && !mArmy2.HasUnits( true ) )
	{
		class'H7AdventureController'.static.GetInstance().RemoveArmy( mArmy2 );
		mArmy2.Destroy();
	}

	class'H7ListeningManager'.static.GetInstance().RemoveListener(mInventory1);
	class'H7ListeningManager'.static.GetInstance().RemoveListener(mInventory2);
	class'H7ListeningManager'.static.GetInstance().RemoveListener(mHeroEquip1);
	class'H7ListeningManager'.static.GetInstance().RemoveListener(mHeroEquip2);

	;
	GetHUD().PopupWasClosed();
	mHeroTradeWindow.SetVisibleSave(false);
	mHeroTradeWindow.Reset();

	mTradedItems.Remove(0, mTradedItems.Length);
	mTradedCreatures.Remove(0, mTradedCreatures.Length);

	mAlliedTrade = false;
	mArmy1 = none;
	mArmy2 = none;
	mHero1 = none;
	mHero2 = none;

	H7AdventureHud( GetHud() ).UnblockAllFlashMovies();
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetTownMode(false);
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().GetCommandPanel().SetRelevantPopupOpen(false);
	H7AdventureHud( GetHud() ).GetAdventureHudCntl().EnableHeroHUDMiniMapTownList();
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	super.ClosePopup();
}

