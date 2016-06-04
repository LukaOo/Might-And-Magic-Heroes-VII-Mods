 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_ArmyHasPlayer extends H7SeqCon_ArmyHas
	native;

// The Player to be checked for
var(Properties) protected EPlayerNumber mPlayerNumber<DisplayName="Player">;

function protected bool IsConditionFulfilledForArmy(H7AdventureArmy army)
{
	return army.GetPlayerNumber() == mPlayerNumber;
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

