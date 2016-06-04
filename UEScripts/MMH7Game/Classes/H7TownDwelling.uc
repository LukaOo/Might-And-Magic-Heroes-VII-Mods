/*=============================================================================
* H7TownDwelling
* =============================================================================
*  Class for describing dwellings that can be built in towns.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownDwelling extends H7TownBuilding
	native;

var(Properties) protected savegame H7DwellingCreatureData    mCreaturePool<DisplayName=Creature Pool>;
var protected savegame float                                 mDailyGrowthBuffer;
var protected savegame int                                   mGrowthCycle;
var protected savegame bool                                  mIsSabotaged;

function H7DwellingCreatureData GetCreaturePool()               { return mCreaturePool; }
function SetCreaturePool( H7DwellingCreatureData pool )         { mCreaturePool = pool; }

function SetSabotaged( bool isSabotaged ) 
{ 
	mIsSabotaged = isSabotaged; 
	;
}

function bool IsSabotaged() { return mIsSabotaged; }

function int GetCreatureIncome()
{
	switch( mCreaturePool.Creature.GetTier() )
	{
		case CTIER_CORE:
			if( mIsSabotaged )
			{
				return FFloor( GetModifiedStatByID( STAT_CORE_PRODUCTION ) / 2.0f );
			}
			else
			{
				return GetModifiedStatByID( STAT_CORE_PRODUCTION );
			}
		case CTIER_ELITE:
			if( mIsSabotaged )
			{
				return FFloor( GetModifiedStatByID( STAT_ELITE_PRODUCTION ) / 2.0f );
			}
			else
			{
				return GetModifiedStatByID( STAT_ELITE_PRODUCTION );
			}
		case CTIER_CHAMPION:
			if( mIsSabotaged )
			{
				return FFloor( GetModifiedStatByID( STAT_CHAMPION_PRODUCTION ) / 2.0f );
			}
			else
			{
				return GetModifiedStatByID( STAT_CHAMPION_PRODUCTION );
			}
		default:
			return 0;
	}
}

function ModifyReserve( float mu )
{
	mCreaturePool.Reserve *= mu;
}

function ProduceUnits( int bonus )
{
	local float dailyGrowth;
	local int income;
	local H7AdventureController advCntl;


	advCntl = class'H7AdventureController'.static.GetInstance();

	if( mIsSabotaged )
	{
		bonus /= 2.0f;
		bonus = FFloor( bonus );
	}
	income = GetCreatureIncome() + bonus;
	if( mTown.GetPlayer().IsControlledByAI() )
	{
		income *= GetPlayer().mDifficultyAICreatureGrowthRateMultiplier;
		;
	}

	;
	;
	if( advCntl.GetConfig().mEnableDailyGrowth )
	{
		mGrowthCycle++;
		dailyGrowth = ( float( income ) ) / 7.0f;
		mDailyGrowthBuffer += dailyGrowth - int( dailyGrowth );
		mCreaturePool.Reserve += int( dailyGrowth ) + int( mDailyGrowthBuffer );
		mDailyGrowthBuffer = mDailyGrowthBuffer - int( mDailyGrowthBuffer );
		;
		mGrowthCycle++;
		if( mGrowthCycle == 7 )
		{
			mDailyGrowthBuffer = 0;
			mGrowthCycle = 0;
			if( mIsSabotaged )
			{
				SetSabotaged( false );
			}
			;
		}
	}
	else
	{
		mCreaturePool.Reserve += income;
		if( mIsSabotaged )
		{
			SetSabotaged( false );
		}
	}
	
	;
}

function CarryReserveForUpgrade( int baseBuildingReserve)
{
	mCreaturePool.Reserve += baseBuildingReserve;
}

/**
 * Removes a part of the creature reserve of the dwelling
 * 
 * @param count         Amount of creatures to recruit
 * 
 * */
function HireUnits( int count )
{
	if( mCreaturePool.Reserve >= count )
	{
		;
		mCreaturePool.Reserve -= count; 
	}
	else
	{
		;
	}
}

/**
 * Gets all of the creatures that can be recruited from
 * this dwelling. In essence, it is the assigned creature,
 * and all it's lower variants, e.g. mCreaturePool.Creature is Superman:
 * Sentinel->Praetorian->Superman
 * 
 * */
function array<H7Creature> GetRecruitableCreatures()
{
	local bool hasUpgrade;
	local H7Creature creature;
	local array<H7Creature> creatures;

	if( mCreaturePool.Creature == none )
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("dwelling"@self@GetName()@"has invalid creature pool data",MD_QA_LOG);;
		return creatures;
	}
	if( mCreaturePool.Creature.GetBaseCreature() != none )
	{
		creature = mCreaturePool.Creature.GetBaseCreature();
		creatures.AddItem( creature );
		do
		{
			if( creature.GetName() == mCreaturePool.Creature.GetName() || creature.GetUpgradedCreature() == none )
			{
				break;
			}
			else
			{
				creature = creature.GetUpgradedCreature();
				creatures.AddItem( creature );
				hasUpgrade = true;
			}
		} until( !hasUpgrade );
	}
	else
	{
		creatures.AddItem( mCreaturePool.Creature );
	}

	return creatures;
}


function float GetModifiedStatByID(Estat desiredStat)
{
	local float statBase,statAdd,statMulti;

	statBase = GetBaseStatByID(desiredStat);
	statAdd =  GetAddBoniOnStatByID(desiredStat);
	statMulti = GetMultiBoniOnStatByID(desiredStat);

	return ( statBase + statAdd ) * statMulti;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of additive modifications, coming from abilities, buffs etc.
 */
function float GetAddBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADD,,,mCreaturePool.Creature);
	foreach applicableMods(currentMod)
	{
		modifierSum += currentMod.mModifierValue;
	}

	return modifierSum;
}

/** @param desiredStat Stat that will be affected
 *  @return Sum of percentages in modifications, where 50% extra means 1.5f
 */
function float GetMultiBoniOnStatByID(Estat desiredStat)
{
	local float modifierSum;

	local H7MeModifiesStat currentMod;
	local array<H7MeModifiesStat> applicableMods;	
	GetModifiersByID(applicableMods, desiredStat, OP_TYPE_ADDPERCENT, OP_TYPE_MULTIPLY,,mCreaturePool.Creature);
	modifierSum = 1; 

	foreach applicableMods(currentMod)
	{
		if(currentMod.mCombineOperation == OP_TYPE_ADDPERCENT)
		{
			modifierSum += modifierSum * currentMod.mModifierValue * 0.01f;
		} 
		else if(currentMod.mCombineOperation == OP_TYPE_MULTIPLY)
		{
			modifierSum *= currentMod.mModifierValue;
		}
	}
	return modifierSum;
}

function float GetBaseStatByID(Estat desiredStat)
{
	switch(desiredStat)
	{
		case STAT_CORE_PRODUCTION: 
			if( mCreaturePool.Creature.GetTier() == CTIER_CORE )
			{
				return mCreaturePool.Income;
			}
			else
			{
				return 0;
			}
		case STAT_ELITE_PRODUCTION: 
			if( mCreaturePool.Creature.GetTier() == CTIER_ELITE )
			{
				return mCreaturePool.Income;
			}
			else
			{
				return 0;
			}
		case STAT_CHAMPION_PRODUCTION: 
			if( mCreaturePool.Creature.GetTier() == CTIER_CHAMPION )
			{
				return mCreaturePool.Income;
			}
			else
			{
				return 0;
			}
		case STAT_GROWTH_BONUS_PRODUCTION:
			return 1;
	}

	
	return 0;
}

native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType checkForOperation1 = -1, optional EOperationType checkForOperation2 = -1, optional bool nextRound, optional H7Creature specificCreature);

