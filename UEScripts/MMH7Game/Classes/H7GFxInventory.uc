//=============================================================================
// H7GFxInventory
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxInventory extends H7GFxUIContainer;

var protected H7EditorHero mCurrentHero;
var protected bool mLocked;
var protected array<IntPoint> mItemPoses;

function Update(array<H7HeroItem> inventoryItems,H7EditorHero hero)
{
	local GFxObject object, itemObj, items;
	local H7HeroItem item;
	local IntPoint itemPos;
	local int i;

	mCurrentHero = hero;

	object = CreateArray();
	;
	
	items = CreateArray();
	ForEach inventoryItems(item, i)
	{
		itemPos = hero.GetInventory().GetItemPosByIndex(i);
		//`log_gui(" - "@item.GetName()@item.GetID()@itemPos.X@itemPos.Y);
		itemObj = CreateItemObject(item, hero, itemPos);
		items.SetElementObject(i, itemObj);
	}
	//`log_gui("-------------------------");

	object.SetObject("Items", items);
	object.SetInt( "PlayerColorR", hero.GetPlayer().GetColor().R);
	object.SetInt( "PlayerColorG", hero.GetPlayer().GetColor().G);
	object.SetInt( "PlayerColorB", hero.GetPlayer().GetColor().B);

	SetObject( "mData" , object);
	ActionscriptVoid("Update");

	if(mLocked)
		AddLockToItemSlots();
}

function SetLocked(bool locked, optional array<IntPoint> itemPoses)
{
	mLocked = locked;
	if(itemPoses.Length != 0)
		mItemPoses = itemPoses;
	else
		mItemPoses.Length = 0;
}

function AddLockToItemSlots()
{
	local GFxObject lockPoses, lockPos;
	local int i;

	lockPoses = CreateArray();

	for(i = 0; i < mItemPoses.Length; i++)
	{
		lockPos = CreateObject( "Object" );
		lockPos.SetInt("X", mItemPoses[i].X);
		lockPos.SetInt("Y", mItemPoses[i].Y);

		lockPoses.SetElementObject(i, lockPos);
	}

	SetObject("mLockedSlots", lockPoses);
	ActionScriptVoid("AddLockedSlotIcons");
}

function SetCursorItemTrue()
{
	ActionscriptVoid("SetCursorItemTrue");
}

/*function AddItemToSlot(H7HeroItem item)
{
	local GFxObject itemObj;
	createItemObject(itemObj, item);
	SetObject( "mData", itemObj);

	ActionscriptVoid("AddItemToSlot");
}*/

function AddItemToDragSlot(H7HeroItem item)
{
	local GFxObject itemObj;
	itemObj = createItemObject(item,mCurrentHero);
	SetObject( "mData", itemObj);

	ActionscriptVoid("AddItemToDragSlot");
}

function AddItemToDropSlot(H7HeroItem item)
{
	local GFxObject itemObj;
	local H7ICaster caster;

	if( item.GetOwner() != none )
	{
		caster = item.GetOwner();
		itemObj = createItemObject( item, H7EditorHero( caster ) );
	}
	else
	{
		itemObj = createItemObject( item, mCurrentHero );
	}
	SetObject( "mData", itemObj);

	ActionscriptVoid("AddItemToDropSlot");
}

function RemoveItemFromSlot()
{
	ActionScriptVoid("RemoveItemFromSlot");
}

function ListenUpdate(H7IGUIListenable gameEntity)
{
	Update(mCurrentHero.GetInventory().GetItems(),mCurrentHero);
}
