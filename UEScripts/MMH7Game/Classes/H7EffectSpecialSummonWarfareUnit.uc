//=============================================================================
// H7EffectSpecialSummonWarfareUnit
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialSummonWarfareUnit extends Object 
	implements( H7IEffectDelegate )
	hidecategories( Object )
	native(Tussi);

var(Summon) bool                mUseFactionDefault<DisplayName=Use Faction Default Warfare Unit>;
var(Summon) bool                mDefaultTypeAttack<DisplayName=Default Warfare Unit Type (True=Attack/False=Support)>;
var(Summon) H7EditorWarUnit     mWarUnit<DisplayName=Warfare Unit Template|EditCondition=!mUseFactionDefault>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7EditorHero hero;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7EditorWarUnit unit;

	if( isSimulated )
	{
		return;
	}

	effect.GetTargets( targets );
	
	foreach targets( target )
	{
		hero = H7EditorHero( target );
		if( mUseFactionDefault )
		{
			if( mDefaultTypeAttack ) //attack
			{
				unit = hero.GetFaction().GetDefaultWarUnitByType( WCLASS_ATTACK );
			}
			else //support
			{
				unit = hero.GetFaction().GetDefaultWarUnitByType( WCLASS_SUPPORT );
			}
		}
		else
		{
			unit = mWarUnit;
		}

		if( unit == none )
		{
			return;
		}

		if( hero != none )
		{
			if( !hero.GetArmy().HasWarUnitType(unit.GetWarUnitClass()) )
			{
				if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
				{
					// combat map? spawn that dude!
					hero.GetArmy().AddWarUnitTemplate( hero.GetArmy().Spawn( unit.Class, hero.GetArmy(),,,,unit ) );
				}
				else
				{
					// just add the template to the army while on adventure maps :)
					hero.GetArmy().AddWarUnitTemplate( unit );
				}
			}
		}
	}
}


function String GetTooltipReplacement() 
{	
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_SUMMON_WARFARE_UNIT","H7TooltipReplacement");

	return ttMessage;
}

