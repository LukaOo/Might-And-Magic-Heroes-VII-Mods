//=============================================================================
// H7EffectSpecialSummonShip
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialSummonShip extends Object implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var(Properties) protected H7Ship mShip <DisplayName = Ship>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster;
	local H7AdventureHero hero;
	local array<H7AdventureMapCell> cells;
	local H7AdventureMapCell cell;
	local H7FxStruct fxStr;
	local H7Ship ship;

	if( isSimulated && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		return;
	}
	
	caster = effect.GetSource().GetCasterOriginal();
	
	hero = H7AdventureHero( caster );


	cells = hero.GetAdventureArmy().GetCell().GetNeighbours();

	fxStr = effect.GetFx();

	foreach cells( cell )
	{
		if( !hero.GetAdventureArmy().HasShip() && cell.mMovementType == MOVTYPE_WATER && cell.GetArmy() == none && cell.GetShip() == none && cell.GetVisitableSite() == none )
		{
			fxStr.mFXPosition = FXP_HIT_POSITION;
			class'H7AdventureController'.static.GetInstance().GetGridController().GetCurrentGrid().GetEffectManager().AddToFXQueue( fxStr, effect, false,, cell.GetLocation() );
			ship = hero.Spawn(class'H7Ship',,, cell.GetLocation(),,mShip );
			ship.InitAdventureObject();
			break;
		}
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_SUMMON_EFFECT","H7TooltipReplacement");
}
