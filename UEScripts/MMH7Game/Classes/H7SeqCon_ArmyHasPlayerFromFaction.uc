 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_ArmyHasPlayerFromFaction extends H7SeqCon_ArmyHas
	native;

// The Faction to be checked
var(Properties) protected archetype H7Faction mFaction<DisplayName="Faction">;

function protected bool IsConditionFulfilledForArmy(H7AdventureArmy army)
{
	if(mFaction == none ||  army.GetPlayer() == none)
	{
		return false;
	}
	else
	{
		return army.GetPlayer().GetFaction() == mFaction;
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

