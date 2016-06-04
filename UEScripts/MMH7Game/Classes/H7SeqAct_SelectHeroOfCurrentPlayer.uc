/*=============================================================================
 * Select an army of the current player
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_SelectHeroOfCurrentPlayer extends H7SeqAct_ManipulateHero
	native;

/** Focus the camera on the selected Hero. */
var(Properties) protected bool mFocusCamera<DisplayName="Focus camera">;

function Activated()
{
	local H7AdventureArmy armyToSelect;
	local H7AdventureController adventureControl;

	adventureControl = class'H7AdventureController'.static.GetInstance();
	armyToSelect = GetTargetArmy();

	if(armyToSelect != none && armyToSelect.GetPlayerNumber() == adventureControl.GetCurrentPlayer().GetPlayerNumber())
	{
		adventureControl.SelectArmy(armyToSelect, mFocusCamera);
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

