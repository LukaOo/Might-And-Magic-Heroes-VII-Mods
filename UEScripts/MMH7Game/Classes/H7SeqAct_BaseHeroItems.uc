/*=============================================================================
 * H7SeqAct_BaseHeroItems
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_BaseHeroItems extends H7SeqAct_ManipulateHero
	abstract
	native;

function array<H7HeroItem> GetItemInstances(H7Inventory targetInventory, H7HeroEquipment targetEquipment, H7HeroItem templateItem)
{
	local array<H7HeroItem> heroItems;
	local array<H7HeroItem> heroItemInstances;
	local H7HeroItem item;

	targetEquipment.GetItemsAsArray(heroItems);
	foreach heroItems(item)
	{
		if(item.GetArchetypeID() == templateItem.GetArchetypeID())
		{
			heroItemInstances.AddItem(item);
		}
	}

	heroItems = targetInventory.GetItems();
	foreach heroItems(item)
	{
		if(item.GetArchetypeID() == templateItem.GetArchetypeID())
		{
			heroItemInstances.AddItem(item);
		}
	}

	return heroItemInstances;
}

function array<H7HeroItem> GetItemsAndEquipment(H7Inventory targetInventory, H7HeroEquipment targetEquipment)
{
	local array<H7HeroItem> items;
	items = targetInventory.GetItems();
	if(targetEquipment.GetHelmet() != none)
	{
		items.AddItem(targetEquipment.GetHelmet());
	}
	if(targetEquipment.GetWeapon() != none)
	{
		items.AddItem(targetEquipment.GetWeapon());
	}
	if(targetEquipment.GetChestArmor() != none)
	{
		items.AddItem(targetEquipment.GetChestArmor());
	}
	if(targetEquipment.GetGloves() != none)
	{
		items.AddItem(targetEquipment.GetGloves());
	}
	if(targetEquipment.GetGloves() != none)
	{
		items.AddItem(targetEquipment.GetGloves());
	}
	if(targetEquipment.GetShoes() != none)
	{
		items.AddItem(targetEquipment.GetShoes());
	}
	if(targetEquipment.GetNecklace() != none)
	{
		items.AddItem(targetEquipment.GetNecklace());
	}
	if(targetEquipment.GetRing1() != none)
	{
		items.AddItem(targetEquipment.GetRing1());
	}
	if(targetEquipment.GetCape() != none)
	{
		items.AddItem(targetEquipment.GetCape());
	}
	return items;
}
