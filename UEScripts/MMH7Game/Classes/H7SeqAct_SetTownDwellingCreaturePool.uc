// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_SetTownDwellingCreaturePool extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Town that gets one of its Dwellings adjusted
var(Properties) protected H7Town mTown<DisplayName="Town">;
// The Dwelling whose Creature Pool is set.
var(Properties) protected archetype H7TownDwelling mDwelling<DisplayName="Dwelling">;
// The Creature Pool to set
var(Properties) protected H7DwellingCreatureData mCreaturePool<DisplayName="Creature Pool">;
// Name to be used by the Dwelling. Leave empty to use the default name
var(Properties) protected string mName<DisplayName="Name">;
// Description to be used by the Dwelling. Leave empty to use the default description
var(Properties) protected string mDescription<DisplayName="Description">;
// Icon to be used by the Dwelling. Leave empty to use the default icon
var(Properties) protected archetype Texture2D mIcon<DisplayName="Icon">;

event Activated()
{
	local H7TownDwellingOverride dwellingOverride;

	if(mTown == none || mDwelling == none)
	{
		return;
	}

	dwellingOverride.TargetTown = mTown;
	dwellingOverride.TargetDwelling = mDwelling;
	dwellingOverride.Name = mName;
	dwellingOverride.Description = mDescription;
	dwellingOverride.CreaturePool = mCreaturePool;
	dwellingOverride.IconPath = PathName(mIcon);
	
	class'H7ScriptingController'.static.GetInstance().AddTownDwellingOverride(dwellingOverride);
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
// (cpptext)

