// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_AddRandomHeroItem extends H7SeqAct_ManipulateHero
	native;

// From specific set instead of global list
var(Properties) protected bool mUseSpecificSet<DisplayName="From Specific Set">;
// The specific set to choose an item from
var(Properties) protected archetype H7ItemSet mSpecificSet<DisplayName="Specific Set"|EditCondition=mUseSpecificSet>;

// Allow Minor Artifact
var(Properties) protected bool mMinorAllowed<DisplayName="Minor"|EditCondition=!mUseSpecificSet>;
// Allow Major Artifact
var(Properties) protected bool mMajorAllowed<DisplayName="Major"|EditCondition=!mUseSpecificSet>;
// Allow Relic Artifact
var(Properties) protected bool mRelicAllowed<DisplayName="Relic"|EditCondition=!mUseSpecificSet>;

function Activated()
{
	local H7HeroItem item;
	local H7AdventureArmy army;
	local H7AdventureHero hero;
	local H7Inventory targetInventory;
	local AkEvent sound;

	if( mUseSpecificSet )
	{
		item = class'H7RandomArtifact'.static.GetRandomHeroItemFromSet(mSpecificSet);
	}
	else
	{
		InitGlobalList();
		item = GetRandomHeroItemFromPool();

		if(item == none)
		{
			// We ran out of unique items, reset the global list
			ResetGlobalList();
			item = GetRandomHeroItemFromPool();
		}
	}

	if( item != none )
	{
		army = GetTargetArmy();

		if(army != none)
		{
			hero = army.GetHero();
		
			if(hero != none)
			{
				sound = AkEvent'H7SFX_Pickup.pickup_artifact';
				army.PlayAkEvent(sound, true, true);

				targetInventory = hero.GetInventory();
				targetInventory.AddItemToInventoryComplete(item);
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_ITEM_PICKUP, army.Location, hero.GetPlayer(), "+"$item.GetName(), MakeColor(0,255,0,255), item.GetIcon());
			}
		}
	}
}

protected native function InitGlobalList();
protected native function ResetGlobalList();
protected native function H7HeroItem GetRandomHeroItemFromPool();

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
// (cpptext)
// (cpptext)

