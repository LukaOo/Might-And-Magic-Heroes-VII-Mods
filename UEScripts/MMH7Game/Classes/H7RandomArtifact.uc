/*=============================================================================
 * H7RandomArtifact
 * 
 * Artifact placeholder
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7RandomArtifact extends H7ItemPile
	hideCategories(Visuals, Audio, Items, Editor)
	implements(H7IRandomSpawnable)
	native
	placeable;

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

/** Default Archetype - used for getting the Visuals from */
var H7ItemPile mDefaultArtifactArchetype;

var(AI) protected float mAiUtilityValue<DisplayName="AI Utility Value">;

event H7Faction GetChosenFaction() { return none; }
function H7AreaOfControlSite GetSpawnedSite() { return none; }
event DisposeShell() 
{ 

}

function native SetRandomPlayerNumber( EPlayerNumber number );
function native SetFactionType( ERandomSiteFaction factionType );
function ERandomSiteFaction GetFactionType() { return E_H7_RSF_PLAYER; }

protected native function InitGlobalList();
protected native function ResetGlobalList();
protected native function H7HeroItem GetRandomHeroItemFromPool();

static function H7HeroItem GetRandomHeroItemFromSet(H7ItemSet specificSet)
{
	local int randomIndex;
	local array<H7HeroItem> items, forbiddenItems;
	local H7HeroItem forbiddenItem;

	if( specificSet == none )
	{
		return none;
	}

	items = specificSet.GetItems();

	forbiddenItems = class'H7AdventureController'.static.GetInstance().GetMapInfo().mForbiddenHeroItems;
	foreach forbiddenItems(forbiddenItem)
	{
		items.RemoveItem(forbiddenItem);
	}

	if( items.Length == 0 )
	{
		return none;
	}

	randomIndex = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( items.Length );

	return items[randomIndex];
}

protected function HatchArtifact( H7HeroItem heroItem )
{
	if( heroItem == none )
	{
		return;
	}

	AddItem( heroItem );

	SetAiUtilityValue( mAiUtilityValue );
}

event HatchRandomSpawnable()
{
	local H7HeroItem heroItem;

	if( mUseSpecificSet )
	{
		heroItem = GetRandomHeroItemFromSet(mSpecificSet);
	}
	else
	{
		InitGlobalList();
		heroItem = GetRandomHeroItemFromPool();

		if(heroItem == none)
		{
			// We ran out of unique items, reset the global list
			ResetGlobalList();
			heroItem = GetRandomHeroItemFromPool();
		}
	}

	if( heroItem != none )
	{
		HatchArtifact( heroItem );
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

