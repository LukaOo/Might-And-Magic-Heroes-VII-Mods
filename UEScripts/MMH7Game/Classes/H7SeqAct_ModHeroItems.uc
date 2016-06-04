/*=============================================================================
 * H7SeqAct_TransferHeroItems
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_ModHeroItems extends H7SeqAct_BaseHeroItems
	native;

// Adding or removing Artifacts 
var(Properties) EBuffsMod mOperation<DisplayName="Artifact operation">;
// The Artifacts that are added or removed
var(Properties) protected archetype array<H7HeroItem> mItems<DisplayName="Artifacts">;

function Activated()
{
	local H7AdventureArmy army;
	local H7AdventureHero hero;
	local H7Inventory targetInventory;
	local H7HeroEquipment targetEquipment;
	local H7HeroItem item, currentInstance;
	local array<H7HeroItem> itemInstances;
	local array<H7HeroItem> items;
	local AkEvent sound;

	army = GetTargetArmy();

	if(army != none)
	{
		hero = army.GetHero();
		
		if(hero != none)
		{
			targetInventory = hero.GetInventory();
			targetEquipment = hero.GetEquipment();
			if(targetInventory != none && targetEquipment != none)
			{
				if (mOperation == EBM_ADD)
				{
					foreach mItems(item)
					{
						sound = AkEvent'H7SFX_Pickup.pickup_artifact';
						army.PlayAkEvent(sound, true, true);
						targetInventory.AddItemToInventoryComplete(item);
						class'H7FCTController'.static.GetInstance().StartFCT(FCT_ITEM_PICKUP, army.Location, hero.GetPlayer(), "+"$item.GetName(), MakeColor(0,255,0,255), item.GetIcon());
					}
				}
				else
				{
					if(mOperation == EBM_REMOVE_ALL)
					{
						items = GetItemsAndEquipment(targetInventory, targetEquipment);
					}
					else // if (mOperation == EBM_REMOVE)
					{
						items = mItems;
					}

					foreach items(item)
					{
						itemInstances = GetItemInstances(targetInventory, targetEquipment, item);
						foreach itemInstances(currentInstance)
						{
							if(targetInventory.HasItem(currentInstance))
							{
								targetInventory.RemoveItemComplete(currentInstance);
							}
							if(targetEquipment.HasItemEquipped(currentInstance))
							{
								targetEquipment.RemoveItemComplete(currentInstance);
							}
						}
					}
				}
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

