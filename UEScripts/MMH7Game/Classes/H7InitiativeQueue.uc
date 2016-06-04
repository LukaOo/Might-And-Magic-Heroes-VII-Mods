//===================== Might & Magic - Heroes VII ============================ 
// H7InitiativeQueue
//=============================================================================
// The initiative queue holds all units from the two armies partaking in a 
// battle. The list re-sorts the units by their initiative values, so the unit
// with the highest values goes first. It tracks the active unit, while only
// one unit can be active at any given time.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InitiativeQueue extends Object
	native;

// holds the two army creature stacks and the two commanding heroes
var protected array<H7Unit>		mActiveList;
// sorted initiative queue
var protected array<H7Unit>		mInitiativeQueue;
// units that already acted in the current round
var protected array<H7Unit>		mFinishedActingUnits;
var protected array<H7UnitCounter> mActedCountingTable;
// waiting stack
var protected array<H7Unit>     mWaitingUnitsStack;
// Hero list
var protected array<H7Unit>     mWaitingHeroList;
// Preview Queue
var protected array<H7Unit>     mPrevQueue;

var protected H7Unit            mHeroOverride;

// Remember active unit in case the queue is sorted
var protected H7Unit			mPrevUnit;

var protected int  			    mActiveUnitInitialInitiative;

function array<H7Unit>	GetInitiativeQueue()    { return mInitiativeQueue; } // creatures (...heroes not anymore)
function array<H7Unit>  GetWaitingUnitStack()   { return mWaitingUnitsStack; } // waiting creatures
function array<H7Unit>  GetActiveHeroList()     { return mWaitingHeroList; } // waiting heroes (...now always start as waiting)
function array<H7Unit>  GetPrevQueue()          { return mPrevQueue; }
function array<H7Unit>  GetActiveList()         { return mActiveList; } // all units on map (heroes + units)
function H7Unit         GetUnit( int idx )      { return mInitiativeQueue[idx]; }

function H7Unit GetActiveUnit(optional bool withOutHero) 
{
	if( !withOutHero && mHeroOverride != none ) { return mHeroOverride; }
	if( mInitiativeQueue.Length > 0 )           { return mInitiativeQueue[0];}
	else if ( mWaitingUnitsStack.Length > 0 )   { return mWaitingUnitsStack[0]; }
	// Design Change - hero just loses turn if he is in the waiting list

	else return none;
}

native function int GetIndexForUnit( H7Unit unit );

function bool IsARemainingUnit( H7Unit unit )
{
	return mFinishedActingUnits.Find(unit) < 0;
}
function bool IsAWaitingUnit( H7Unit unit)
{
	return mWaitingUnitsStack.Find(unit) != INDEX_NONE || mWaitingHeroList.Find(unit) != INDEX_NONE;
}

function AddUnit( H7Unit unit, optional bool doSort = true )
{
	mActiveList.AddItem( unit );
	
	if( doSort )
	{
		mInitiativeQueue.AddItem( unit );
		RemoveFromCurrentTurn(unit); // to remove it from current turn
		Sort( true );
	}
}

function AddUnitToIndex( H7Unit unit, int index )
{
	mActiveList.AddItem( unit );
	mInitiativeQueue.InsertItem( index, unit );
}

function RemoveUnit( H7Unit unit )
{
	mActiveList.RemoveItem( unit );
	mInitiativeQueue.RemoveItem( unit );
	mFinishedActingUnits.RemoveItem( unit );
	mWaitingUnitsStack.RemoveItem( unit );
	mPrevQueue.RemoveItem( unit );
}

// called at start of every turn
function SetHeroesFirst(H7CombatHero Attacker, H7CombatHero Defender)
{
	// Design change: Heroes start out as waiting:
	
	mWaitingHeroList.Length = 0;
	mActedCountingTable.Length = 0;
	if( Attacker != none && Attacker.IsHero() ) mWaitingHeroList.AddItem(Attacker);
	if( Defender != none && Defender.IsHero() ) mWaitingHeroList.AddItem(Defender);
}

function bool IsHeroQueued( H7Unit hero )
{
	return  mWaitingHeroList.Find( hero ) >= 0 && mPrevUnit != hero;
}

function SetOverrideActiveUnitWithHero( H7Unit hero ) 
{
	if( hero == none && H7CombatHero( mHeroOverride ) != none )
	{
		H7CombatHero( mHeroOverride ).GetHeroFX().HideFX();
	}
	mHeroOverride = hero;
} 


/**
 * Wait with the current unit 
 * skip current turn
 * **/
function Waited( H7Unit unit)
{
	if ( mWaitingUnitsStack.Find( unit ) >= 0 ) 
		return;

	if( mFinishedActingUnits.Find( unit ) >= 0 )
		return;

	mInitiativeQueue.RemoveItem( unit );
	mPrevUnit = unit; 

	// special case first time each round hero acts first, wait will remove hero from queue
    if( unit.isA('H7EditorHero') )
    {
		mWaitingHeroList.AddItem( unit );
    	return;
    }

	// seems it is no hero so it's a creature, so we will add it to the waiting stack
	mWaitingUnitsStack.InsertItem( 0 , unit );
}

/**
 * Remove a Turn, works like acting
 ***/
function SkipUnitTurn(H7Unit unit)
{
	Acted(unit);
	RemoveFromCurrentTurn( unit );
}

function CheckMarkedForSkipTurnUnits()
{
	local int i;

	for( i = mInitiativeQueue.Length-1; i > 0; --i )
	{
		if( mInitiativeQueue[i].IsMarkedForTurnSkip() )
		{
			mInitiativeQueue[i].MarkForTurnSkip( false );
			SkipUnitTurn( mInitiativeQueue[i] );
		}
	}
}

/**
 * Unit acted, but still has actions left (Hyrbird Warfare, guaranteed moral, ...)
 */
function Acted(H7Unit actedUnit)
{
	local H7UnitCounter entry;
	local int i;
	local bool createEntry;
	
	createEntry = true;

	foreach mActedCountingTable(entry,i)
	{
		if(entry.unit == actedUnit)
		{
			mActedCountingTable[i].counter++;
			createEntry = false;
		}
	}

	if(createEntry)
	{
		entry.unit = actedUnit;
		entry.counter = 1;
		mActedCountingTable.AddItem(entry);
	}
}

/**
 * 
 */
function int GetActedCount(H7Unit unit)
{
	local H7UnitCounter entry;
	
	foreach mActedCountingTable(entry)
	{
		if(entry.unit == unit)
		{
			return entry.counter;
		}
	}
	return 0;
}

/**
 * 
 */
function bool IsLast(H7Unit unit)
{
	if( mInitiativeQueue.Length>=1 && mInitiativeQueue[mInitiativeQueue.Length-1]==unit ) return true;
	return false;
}

/**
 * Act the final time (this turn) with this unit, will rmemove it from current combat-turn Queue
 **/
function RemoveFromCurrentTurn( H7Unit unit)
{
	if(mFinishedActingUnits.Find( unit ) < 0)
	{
		mFinishedActingUnits.AddItem( unit );
		mPrevUnit = unit;

		// it must be somewhere here 
		if( mInitiativeQueue.Find( unit ) >= 0 ) 
			mInitiativeQueue.RemoveItem( unit );

		if( mWaitingUnitsStack.Find( unit ) >=0 )
			mWaitingUnitsStack.RemoveItem( unit );
		
		if( mWaitingHeroList.Find( unit ) >= 0) 
		{
			mWaitingHeroList.RemoveItem( unit );
			mHeroOverride = none;
		}
	}
}

/** 
 *  returns true if it is the end of the turn 
 ***/
function bool NeedNextTurn()
{	
	// unit turns left ?
	if( mInitiativeQueue.Length > 0 )
		return false;

	// waiting units left ?
	if ( mWaitingUnitsStack.Length > 0 )
		return false;

	// Design Change - hero just loses turn if he is in the waiting list
	// heroes left ?

	mFinishedActingUnits.Length = 0;
	return true;
}

function InitializeQueue( optional bool previousQueue=false )
{
	local int i;

	if(previousQueue) { mPrevQueue.Length = 0; }

	for( i=0;i<mActiveList.Length; ++i )
	{
		if( mActiveList[i] != None )
		{
			if( mActiveList[i].IsDead() ||
				( H7CreatureStack( mActiveList[i] ) != none &&
				H7CreatureStack( mActiveList[i] ).GetCreature().GetAnimControl().IsDying() )
				)
			{
				RemoveUnit( mActiveList[i] );
				continue;
			}

			if(previousQueue)
			{
				mPrevQueue.AddItem( mActiveList[i]);
			}
			else
			{
				mInitiativeQueue.AddItem( mActiveList[i] );
			}
		}
	}
	
}

// used to be called on every unit turn, now only called on demand (when initiative changes somewhere)
function Sort(optional bool sendToFlash = false)
{
	;
	;

	InitializeQueue(true);

	// first pass: sort list by units initiative values in descending order
	mInitiativeQueue.Sort( UnitCompareASC );
	mWaitingUnitsStack.Sort( UnitCompareDESC );
	mPrevQueue.Sort( UnitCompare_NextASC );

	// there is no sort, that does not cause the next unit turn, so we don't need to send the same 2 times
	if( sendToFlash )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
	}
}

// for some unrealscript reason we need to write wrapper functions, otherwise  compiling scripts will crash
function int UnitCompareDESC(H7Unit a, H7Unit b)
{
	return class'H7GameUtility'.static.UnitCompareDESC(a,b);
}

function int UnitCompareASC(H7Unit a, H7Unit b)
{
	return class'H7GameUtility'.static.UnitCompareASC(a,b);
}

function int UnitCompare_NextASC(H7Unit a, H7Unit b)
{
	return class'H7GameUtility'.static.UnitCompare_NextASC(a,b);
}



function array<H7Unit> SortArray(array<H7Unit> units)
{
	units.Sort(UnitCompareASC);
	return units;
}

function bool IsLastUnitOfPlayer(H7Unit unit) // this turn
{
	local H7Unit futureUnit;

	// i'm an uncontrollable warunit, and i won't let the hero do their turn in mine!!
	if( unit != none &&
		H7WarUnit( unit ) != none && unit.GetPlayer().GetPlayerType() == PLAYER_HUMAN &&
		H7WarUnit( unit ).IsControlledByAI() != unit.GetPlayer().IsControlledByAI() )
	{
		return false;
	}

	foreach mInitiativeQueue(futureUnit)
	{
		if( futureUnit.IsAttacker() == unit.IsAttacker() && futureUnit != unit )
		{
			// dude has no warfare skill, so the warunit is controlled by AI -> this doesn't count as last unit
			if( H7WarUnit( futureUnit ) != none && futureUnit.GetPlayer().GetPlayerType() == PLAYER_HUMAN &&
				H7WarUnit( futureUnit ).IsControlledByAI() != futureUnit.GetPlayer().IsControlledByAI() ) continue;

			return false;
		}
	}

	foreach mWaitingUnitsStack(futureUnit)
	{
		if(futureUnit.IsAttacker() == unit.IsAttacker() && futureUnit != unit)
		{
			// dude has no warfare skill, so the warunit is controlled by AI -> this doesn't count as last unit
			if( H7WarUnit( futureUnit ) != none && futureUnit.GetPlayer().GetPlayerType() == PLAYER_HUMAN &&
				H7WarUnit( futureUnit ).IsControlledByAI() != futureUnit.GetPlayer().IsControlledByAI() ) continue;

			return false;
		}
	}

	return true;
}

function bool IsLastUnitOfTurn()
{
	if( mInitiativeQueue.Length == 0 && mWaitingUnitsStack.Length == 1 ||
		mInitiativeQueue.Length == 1 && mWaitingUnitsStack.Length == 0)
	{
		return true;
	}

	return false;
}


function DebugLogSelf()
{
	local H7Unit currentUnit;
	local int c;

	;
	;
	c=1;
	foreach mInitiativeQueue( currentUnit )
	{
		if( currentUnit.IsAttacker() )
		{
			;
		}
		else
		{
			;
		}
		c++;
	}
	c=c; // to avoid warning when LOG_COMBAT is not declared
}

