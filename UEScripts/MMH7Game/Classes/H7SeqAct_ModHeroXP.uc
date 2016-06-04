/*=========================================================================
 Clear all units from an hero/army
 Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
===========================================================================*/

class H7SeqAct_ModHeroXP extends H7SeqAct_ManipulateHero
	native;

/** What to do with the units */
var(Properties) protected EModQuantityOper mOper<DisplayName="Operator">;
/** The amount of XP to change */
var(Properties) protected int mQuantity<DisplayName="Quantity"|ClampMin=1>;

function Activated()
{
	local H7AdventureArmy army;
	local H7AdventureHero hero;
	local int oldXP;

	army = GetTargetArmy();

	if(army == none)
	{
		return;
	}

	hero = army.GetHero();

	if (hero == none)
	{
		return;
	}

	if(mOper == EMQO_ADD)
	{
		oldXP = hero.GetExperiencePoints();
		hero.SetXp(oldXp + mQuantity);
	}
	else if(mOper == EMQO_SUB)
	{
		oldXP = hero.GetExperiencePoints();
		hero.SetXp(Max(0, oldXp - mQuantity));
	}
	else if (mOper == EMQO_SET)
	{
		hero.SetXp(mQuantity);
	}

	hero.AddXp(0);  // Apply EXP
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

