//=============================================================================
// H7AiCombatSensors
//=============================================================================
// collection of sensors used by combat map ai. Its sole purpose is to create
// all the sensors to be used by utility objects and parameter object for
// calling GetValue<n>()
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiCombatSensors extends H7AiSensorBase
	dependson(H7StructsAndEnumsNative)
	dependsOn(H7AiSensorInputConst);


var protected array<H7AiSensorBase>     mSensors;
var protected H7AiSensorInputConst      mConsts;
var protected EAiSensorIConst           mConstSelect[2];
var protected int                       mConstIter[2];
var protected int                       mConstLength[2];
var protected H7AiSensorParam           mParam[2];

function H7AiSensorBase         GetSensor( EAiCombatSensor sensor )     { return mSensors[sensor]; }
function H7AiSensorParam        GetParam0()                             { return mParam[0]; }
function H7AiSensorParam        GetParam1()                             { return mParam[1]; }
function H7AiSensorInputConst   GetSensorIConsts()                      { return mConsts; }

function UpdateConsts()
{
	mConsts.Reset();
}

function ResetConsts()
{
	mConsts.ResetConsts();
}

function float CallSensor( EAiCombatSensor sensor )
{
	switch(sensor)
	{
		// 1 parameter types ...
		case ACS_ArmyHasRangeAttack:
		case ACS_CanRangeAttack:
		case ACS_CanRetaliate:
		case ACS_ThreatLevel:
		case ACS_HPPercentLoss:
		case ACS_HPPercentLossRetaliate:
		case ACS_HasGreaterDamage:
		case ACS_GoodTimeToWait:
		case ACS_CanCastBuff:
		case ACS_Opportunity:
		case ACS_SpellSingleDamage:
		case ACS_SpellMultiDamage:
		case ACS_SpellSingleHeal:
		case ACS_SpellMultiHeal:
		case ACS_CreatureCount:
		case ACS_CreatureIsRanged:
		case ACS_RangedCreatureCount:
			return GetSensor(sensor).GetValue1(GetParam0());

		// 2 parameter types ...
		case ACS_GridCellReachable:
		case ACS_GeomDistance:
		case ACS_HasAdjacentEnemy:
		case ACS_CanMoveAttack:
		case ACS_ManaCost:
		case ACS_SpellTargetCheck:
		case ACS_HealingPercentage:
		case ACS_AbilityCasualityCount:
		case ACS_AbilityCreatureDamage:
		case ACS_MeleeCasualityCount:
		case ACS_MeleeCreatureDamage:
		case ACS_RangeCasualityCount:
		case ACS_RangeCreatureDamage:
		case ACS_CreatureStrength:
		case ACS_MoveDistance:
		case ACS_CreatureStat:
		case ACS_CreatureAdjacentToEnemy:
		case ACS_CreatureAdjacentToAlly:
		case ACS_CreatureTier:
		case ACS_CreatureCanAttack:
		case ACS_CreatureCanBeAttacked:
			return GetSensor(sensor).GetValue2(GetParam0(),GetParam1());
	};
}

function CallBegin( EAiSensorIConst sic0, EAiSensorIConst sic1 )
{
	local int i;

	mConstSelect[0] = sic0;
	mConstIter[0] = 0;
	mConstSelect[1] = sic1;
	mConstIter[1] = 0;

	for(i=0;i<2;i++)
	{
		switch(mConstSelect[i])
		{
			case SIC_DISABLED:
				mConstLength[i] = 0;
				break;
			case SIC_GRIDCELLS:
				mConstLength[i] = mConsts.GetCellNum();
				break;
			case SIC_CREATURESTACKS:
				mConstLength[i] = mConsts.GetCreatureStackNum();
				break;
			case SIC_OPPONENT_CREATURESTACKS:
				mConstLength[i] = mConsts.GetOppCreatureStackNum();
				break;
			case SIC_HEROABILITIES:
				mConstLength[i] = mConsts.GetHeroAbilityNum();
				break;
			default:
				mConstLength[i] = 1;
		}
	}
}

function bool CallNext()
{
	local int p;

	if( mConstIter[0] >= mConstLength[0] && mConstIter[1] >= mConstLength[1] ) return false;

	// set params
	for(p=0;p<2;p++)
	{
		if( mConstSelect[p] != SIC_DISABLED )
		{
			if( mConstIter[p] < mConstLength[p] ) 
			{
				switch(mConstSelect[p])
				{
					case SIC_GRIDCELLS: 
						mParam[p].SetCMapCell(mConsts.GetCell(mConstIter[p]));
						break;
					case SIC_THIS_CREATURESTACK:
						mParam[p].SetUnit(mConsts.GetThisCreatureStack());
						break;
					case SIC_CREATURESTACKS:
						mParam[p].SetUnit(mConsts.GetCreatureStack(mConstIter[p]));
						break;
					case SIC_OPPONENT_CREATURESTACKS:
						mParam[p].SetUnit(mConsts.GetOppCreatureStack(mConstIter[p]));
						break;
					case SIC_THIS_HERO:
						mParam[p].SetUnit(mConsts.GetHero());
						break;
					case SIC_OPPONENT_HERO:
						mParam[p].SetUnit(mConsts.GetOppHero());
						break;
					case SIC_THIS_HERO:
						mParam[p].SetUnit(mConsts.GetHero());
						break;
					case SIC_TARGET_ARMY:
						if(mConsts.GetTargetCreatureStack()!=None)
						{
							mParam[p].SetCombatArmy(mConsts.GetTargetCreatureStack().GetCombatArmy());
						}
						else
						{
							mParam[p].SetCombatArmy(mConsts.GetArmy());
						}
						break;
					case SIC_THIS_ARMY:
						mParam[p].SetCombatArmy(mConsts.GetArmy());
						break;
					case SIC_OPPONENT_ARMY:
						mParam[p].SetCombatArmy(mConsts.GetOppArmy());
						break;
					case SIC_SOURCE_GRIDCELL:
						mParam[p].SetCMapCell(mConsts.GetSourceCell());
						break;
					case SIC_TARGET_GRIDCELL:
						mParam[p].SetCMapCell(mConsts.GetTargetCell());
						break;
					case SIC_TARGET_CREATURESTACK:
						mParam[p].SetUnit(mConsts.GetTargetCreatureStack());
						break;
					case SIC_HEROABILITIES:
						mParam[p].SetHeroAbility(mConsts.GetHeroAbility(mConstIter[p]));
						break;
					case SIC_CREATUREABILITY:
						mParam[p].SetCreatureAbility(mConsts.GetCreatureAbility());
						break;
					case SIC_HEROABILITY:
						mParam[p].SetHeroAbility(mConsts.GetUseHeroAbility());
						break;
					case SIC_CREATURE_STAT:
						mParam[p].SetCreatureStat(mConsts.GetCreatureStat());
						break;
					case SIC_CREATURE_TIER:
						mParam[p].SetCreatureTier(mConsts.GetCreatureTier());
						break;

				}
			}
		}
	}	

	mConstIter[1]++;
	if( mConstIter[1] >= mConstLength[1] )
	{
		mConstIter[1]=0;
		mConstIter[0]++;
		if( mConstIter[0] > mConstLength[0] )
		{
			// end of list
			return false;
		}
	}
	return true;
}

function Setup()
{
	mSensors.InsertItem(ACS_ArmyHasRangeAttack,new class 'H7AiSensorArmyHasRangeAttack');
	mSensors.InsertItem(ACS_GridCellReachable,new class 'H7AiSensorGridCellReachable');
	mSensors.InsertItem(ACS_GeomDistance,new class 'H7AiSensorGeomDistance');
	mSensors.InsertItem(ACS_CanRangeAttack, new class 'H7AiSensorCanRangeAttack');
	mSensors.InsertItem(ACS_CanRetaliate, new class 'H7AiSensorCanRetaliate' );
	mSensors.InsertItem(ACS_ThreatLevel, new class 'H7AiSensorThreatLevel' );
	mSensors.InsertItem(ACS_HasAdjacentEnemy, new class 'H7AiSensorHasAdjacentEnemy' );
	mSensors.InsertItem(ACS_HPPercentLoss, new class 'H7AiSensorHPPercentLossAttack' );
	mSensors.InsertItem(ACS_HPPercentLossRetaliate, new class 'H7AiSensorHPPercentLossRetaliation' );
	mSensors.InsertItem(ACS_CanMoveAttack, new class 'H7AiSensorCanMoveAttack' );
	mSensors.InsertItem(ACS_HasGreaterDamage, new class 'H7AiSensorHasGreaterDamage' );
	mSensors.InsertItem(ACS_CanCastBuff, new class 'H7AiSensorCanCastBuff' );
	mSensors.InsertItem(ACS_MeleeCasualityCount, new class 'H7AiSensorMeleeCasualityCount' );
	mSensors.InsertItem(ACS_MeleeCreatureDamage, new class 'H7AiSensorMeleeCreatureDamage' );
	mSensors.InsertItem(ACS_RangeCasualityCount, new class 'H7AiSensorRangeCasualityCount' );
	mSensors.InsertItem(ACS_RangeCreatureDamage, new class 'H7AiSensorRangeCreatureDamage' );
	mSensors.InsertItem(ACS_ManaCost, new class 'H7AiSensorManaCost' );
	mSensors.InsertItem(ACS_SpellTargetCheck, new class 'H7AiSensorSpellTargetCheck' );
	mSensors.InsertItem(ACS_HealingPercentage, new class 'H7AiSensorHealingPercentage' );
	mSensors.InsertItem(ACS_AbilityCasualityCount, new class 'H7AiSensorAbilityCasualityCount' );
	mSensors.InsertItem(ACS_AbilityCreatureDamage, new class 'H7AiSensorAbilityCreatureDamage' );
	mSensors.InsertItem(ACS_Opportunity, new class 'H7AiSensorOpportunity' );
	mSensors.InsertItem(ACS_SpellSingleDamage, new class 'H7AiSensorSpellSingleDamage' );
	mSensors.InsertItem(ACS_SpellMultiDamage, new class 'H7AiSensorSpellMultiDamage' );
	mSensors.InsertItem(ACS_SpellSingleHeal, new class 'H7AiSensorSpellSingleHeal' );
	mSensors.InsertItem(ACS_SpellMultiHeal, new class 'H7AiSensorSpellMultiHeal' );
	mSensors.InsertItem(ACS_CreatureCount, new class 'H7AiSensorCreatureCount' );
	mSensors.InsertItem(ACS_CreatureStrength, new class 'H7AiSensorCreatureStrength' );
	mSensors.InsertItem(ACS_MoveDistance, new class 'H7AiSensorStackMoveDistance' );
	mSensors.InsertItem(ACS_CreatureStat, new class 'H7AiSensorCreatureStat' );
	mSensors.InsertItem(ACS_CreatureIsRanged, new class 'H7AiSensorCreatureIsRanged' );
	mSensors.InsertItem(ACS_CreatureAdjacentToEnemy, new class 'H7AiSensorCreatureAdjacentToEnemy' );
	mSensors.InsertItem(ACS_CreatureAdjacentToAlly, new class 'H7AiSensorCreatureAdjacentToAlly' );
	mSensors.InsertItem(ACS_CreatureTier, new class 'H7AiSensorCreatureTier' );
	mSensors.InsertItem(ACS_CreatureCanAttack, new class 'H7AiSensorCreatureCanAttack' );
	mSensors.InsertItem(ACS_CreatureCanBeAttacked, new class 'H7AiSensorCreatureCanBeAttacked' );
	mSensors.InsertItem(ACS_RangedCreatureCount, new class 'H7AiSensorRangedCreatureCount' );
	mSensors.InsertItem(ACS_GoodTimeToWait, new class 'H7AiSensorGoodTimeToWait' );

	mConsts = new class 'H7AiSensorInputConst';

	mParam[0] = new class 'H7AiSensorParam';
	mParam[1] = new class 'H7AiSensorParam';

	mConstSelect[0] = SIC_DISABLED;
	mConstLength[0] = 0;
	mConstSelect[1] = SIC_DISABLED;
	mConstLength[1] = 0;
}
