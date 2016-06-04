//=============================================================================
// H7GFxHeroEquip
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxHeroEquip extends H7GFxUIContainer;

var protected H7EditorHero mCurrentHero;
var protected bool mLocked;

function Update(array<H7HeroItem> equippedItems, H7HeroItem ring1, H7EditorHero hero)
{
	local GFxObject object, itemObj;
	local H7HeroItem item;
	local int i;

	mCurrentHero = hero;

	object = CreateArray();

	i = 0;
	ForEach equippedItems(item)
	{
		if(item.GetType() == ITYPE_RING) continue;

		;

		itemObj = CreateItemObject(item,hero);

		object.SetElementObject(i, itemObj);
		i++;
	}

	if(ring1 != none)
	{
		;

		itemObj = CreateItemObject(ring1,hero);
		itemObj.SetString("slot", "L");

		object.SetElementObject(i, itemObj);
		i++;
	}

	SetObject( "mData" , object);
	ActionscriptVoid("Update");

	if(mLocked)
		ActionScriptVoid("AddLockToItemSlots");
}

function AddItemToDragSlot(H7HeroItem item)
{
	local GFxObject itemObj;
	itemObj = CreateItemObject(item,mCurrentHero);
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

function SetLocked(bool locked)
{
	mLocked = locked;
}

/*function AddLockToItemSlots()
{
	ActionScriptVoid("AddLockToItemSlots");
}*/

function ListenUpdate(H7IGUIListenable gameEntity)
{
	local H7HeroItem ring1;
	local array<H7HeroItem> items;
	if(mCurrentHero.GetEquipment().GetRing1() != none) ring1 = mCurrentHero.GetEquipment().GetRing1();
	mCurrentHero.GetEquipment().GetItemsAsArray(items);
	Update( items, ring1, mCurrentHero );
}
