/*=============================================================================
 * Transfer units between armies
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_TransferHeroUnits extends H7SeqAct_ManipulateHero
	native;

/** The Army from which the Creatures should be transfered. */
var(Properties) protected H7AdventureArmy mSourceArmy<DisplayName="Source Army">;
/** If checked, the transfer is done via the Merge Window. */
var(Properties) protected bool mUseMergeWindow<DisplayName="Show Merge Window">;

function Activated()
{
	local H7AdventureArmy targetArmy;
	targetArmy = GetTargetArmy();

	if(targetArmy == none || mSourceArmy == none)
	{
		return;
	}

	targetArmy.GetBaseCreatureStacksDereferenced();

	if( mUseMergeWindow )
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetHeroTradeWindowCntl().Update( mSourceArmy.GetHero(), targetArmy.GetHero() );
	}
	else
	{
		targetArmy.MergeArmy( mSourceArmy, true );
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

