// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_SetDwellingCreaturesPool extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Dwelling whose Creature Pool is set
var(Properties) protected H7Dwelling mDwelling<DisplayName="Dwelling">;
// The Creatures Pool to set
var(Properties) protected array<H7DwellingCreatureData> mCreaturesPool<DisplayName="Creatures Pool">;

event Activated()
{
	if(mDwelling != none)
	{
		mDwelling.SetCreaturePool(mCreaturesPool);
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
// (cpptext)

