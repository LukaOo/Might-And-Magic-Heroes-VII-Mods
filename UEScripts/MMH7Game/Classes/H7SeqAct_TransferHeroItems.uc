/*=============================================================================
 * H7SeqAct_TransferHeroItems
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_TransferHeroItems extends H7SeqAct_BaseHeroItems
	native;

/** The Army from which the Artifacts should be transfered. */
var(Properties) protected H7AdventureArmy mSourceArmy<DisplayName="Source Army">;
/** If checked, the equipped Artifacts of the source hero are transfered as well. */
var(Properties) protected bool mIncludeEquipment<DisplayName="Transfer equipped Artifacts">;

function Activated()
{
	local H7AdventureArmy targetArmy;
	local H7AdventureHero sourceHero, targetHero;
	local H7Inventory sourceInventory, targetInventory;
	local H7HeroEquipment sourceEquipment;
	local H7HeroItem currentItem, currentInstance;
	local array<H7HeroItem> itemInstances;
	local array<H7HeroItem> sourceItems;
	local AkEvent sound;

	targetArmy = GetTargetArmy();

	if(targetArmy != none && mSourceArmy != none)
	{
		targetHero = targetArmy.GetHero();
		sourceHero = mSourceArmy.GetHero();
		
		if(targetHero != none)
		{
			targetInventory = targetHero.GetInventory();
			sourceInventory = sourceHero.GetInventory();
			if(targetInventory != none && sourceInventory != none)
			{
				if(mIncludeEquipment)
				{
					sourceEquipment = sourceHero.GetEquipment();
					if(sourceEquipment != none)
					{
						// Move equipment to inventory
						sourceEquipment.GetItemsAsArray(sourceItems);
						foreach sourceItems(currentItem)
						{
							sourceInventory.AddItemToInventoryComplete(currentItem);
						}
					}
				}

				sourceItems = sourceInventory.GetItems();
				
				// Add items to target hero
				foreach sourceItems(currentItem)
				{
					sound = AkEvent'H7SFX_Pickup.pickup_artifact';
					targetArmy.PlayAkEvent(sound, true, true);
					targetInventory.AddItemToInventoryComplete(currentItem);
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_ITEM_PICKUP, targetArmy.Location, targetHero.GetPlayer(), "+"$currentItem.GetName(), MakeColor(0,255,0,255), currentItem.GetIcon());
				}

				// Remove items from source hero
				foreach sourceItems( currentItem )
				{
					itemInstances = GetItemInstances(sourceInventory, sourceEquipment, currentItem);
					foreach itemInstances(currentInstance)
					{
						if(sourceInventory.HasItem(currentInstance))
						{
							sourceInventory.RemoveItemComplete(currentInstance);
						}
						if(mIncludeEquipment && sourceEquipment.HasItemEquipped(currentInstance))
						{
							sourceEquipment.RemoveItemComplete(currentInstance);
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

