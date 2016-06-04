//=============================================================================
// H7EffectWarunitControl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectWarunitControl extends Object 
	implements( H7IEffectDelegate )
	hidecategories(Object)
	native(Tussi);


var() EWarUnitClass mEffectedWarType<DisplayName=WarUnitType>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local int i;
	local H7CombatHero hero;
	local H7ICaster caster;
	local array<H7WarUnit> warUnits; 

	// this effect only works on combat map
	if( isSimulated || class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) 
	{
		return;
	}

	caster = effect.GetSource().GetCasterOriginal();
	if( caster == none ) 
	{
		return;
	}

	hero = H7CombatHero( caster );
	warUnits = hero.GetCombatArmy().GetWarUnits();

	for ( i=0;i<warUnits.Length;++i)
	{
		if( warUnits[i].GetWarUnitClass() == mEffectedWarType ) 
		{
			warUnits[i].SetAIControled(false);
		}
	}
}


function String GetTooltipReplacement() 
{
	return Repl(
		Localize("H7TooltipReplacement", "TTR_TAKE_CONTROL", "MMH7Game" ),
		"%unittype",
		Localize("H7Abilities",String(mEffectedWarType),"MMH7Game")
	);
}
