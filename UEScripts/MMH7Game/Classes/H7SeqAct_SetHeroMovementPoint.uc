class H7SeqAct_SetHeroMovementPoint extends H7SeqAct_ManipulateHero
	native;

/** The new amount of movement points */
var(Properties) protected int mPoints<DisplayName="Movement points"|ClampMin=0>;

function Activated()
{
	local H7AdventureArmy army;
	local H7AdventureHero hero;

	army = GetTargetArmy();
	hero = army.GetHero();
	if(hero != none)
	{
		hero.SetCurrentMovementPoints(mPoints);
		hero.DataChanged();
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

