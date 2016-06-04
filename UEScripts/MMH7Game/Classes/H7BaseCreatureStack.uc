//=============================================================================
// H7BaseCreatureStack
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BaseCreatureStack extends Object
	native
	savegame;

var() protected archetype savegame H7Creature mType;
var() savegame int mSize<DisplayName=StackSize|ClampMin=1>;
var() savegame bool mUseCustomPosition;
var() savegame int mCustomPositionX;
var() savegame int mCustomPositionY;
var protected bool mIsUnDeployed;
var savegame protected bool mIsLocalGuard;
var transient H7CreatureStack mSpawnedStackOnMap;
var savegame protected float mRemainingGrowth;
var savegame protected int mStartingSize;
var savegame protected int mStackSizeAtMapStart;
var savegame protected bool mUpgradeLock;
var savegame protected bool mAILock;
var savegame protected bool mDismissDisabled;

function                SetStackSize( int size, optional bool updateStartingSize )  { mSize = size; if( updateStartingSize ) { SetStartingSize( mSize ); } }
function int            GetStackSize()                                              { return mSize; }
function                AddToStack( int value )                                     { mSize += value; SetStartingSize( mSize ); }

function                SetStackType( H7Creature type )        { mType = type; }
function H7Creature     GetStackType()                         { return mType; }

function                SetAILock( bool b )                    { mAILock = b; }
function bool           HasAILock()                            { return mAILock; }

function                SetDismissDisabled( bool b )           { mDismissDisabled = b; }
function bool           IsDismissDisabled()                    { return mDismissDisabled; }

function                SetIsLocalGuard( bool isLocalGuard )   { mIsLocalGuard = isLocalGuard; }
function bool           IsLocalGuard()                         { return mIsLocalGuard; }

function                SetRemainingGrowth( float remainingGrowth )     { mRemainingGrowth = remainingGrowth; }
function float          GetRemainingGrowth()                            { return mRemainingGrowth; }
		
function                SetStartingSize( int startingSize )             { mStartingSize = startingSize; }
function int            GetStartingSize()                               { return mStartingSize; }

function                SetStackSizeAtMapStart( int size )              { mStackSizeAtMapStart = size; }
function int            GetStackSizeAtMapStart()                        { return mStackSizeAtMapStart; }

function                SetLockedForUpgrade( bool val )                 { mUpgradeLock = val; }
function bool           IsLockedForUpgrade()                            { return mUpgradeLock; }

function                 SetSpawnedStackOnMap( H7CreatureStack type )   { mSpawnedStackOnMap = type; }
function H7CreatureStack GetSpawnedStackOnMap()                         { return mSpawnedStackOnMap; }

function                SetCustomPosition(bool flag, int x, int y)      { mUseCustomPosition = flag; mCustomPositionX = x; mCustomPositionY = y; }
function bool           GetCustomPositionBool()                         { return mUseCustomPosition; }
function int            GetCustomPositionX()                            { return mCustomPositionX; }
function int            GetCustomPositionY()                            { return mCustomPositionY; }

function SetDeployed(bool val)
{
	mIsUnDeployed = !val;
}

function bool IsDeployed()
{
	return !mIsUnDeployed;
}

native function float GetCreatureStackStrength();

function bool IsUnitType( H7BaseCreatureStack stack ) 
{
	return mType == stack.mType;
}

function String GetStackSizeObfuscated() 
{ 
	return GetObfuscatedSize(mSize);
}

static function String GetObfuscatedSize(int stacksize)
{
	if(stacksize < 5) return "1-4";
	if(stacksize < 10) return "5-9";
	if(stacksize < 20) return "10-19";
	if(stacksize < 50) return "20-49";
	if(stacksize < 100) return "50-99";
	if(stacksize < 250) return "100-249";
	if(stacksize < 500) return "250-499";
	return "500+";
}


// this is the master function, all should arrive here
// !!! don't forget to call army.SetBaseCreatureStacks afterwards, if one of these stacks is part of an army !!!
// !!! splitAmount is ignored !!!
function static bool TransferCreatureStacksByArray(out array<H7BaseCreatureStack> sourceStacks,out array<H7BaseCreatureStack> targetStacks,int indexSource, int indexTarget,optional int splitAmount,optional bool withinSameArmy=false)
{
	local int i;
	local H7BaseCreatureStack tmpStack;
	local array<H7BaseCreatureStack> stacks;
	
	;

	if( indexSource < 0 || indexSource > 13 )
	{
		;
		return false;
	}
	else if( indexTarget < 0 || indexTarget > 13 )
	{
		;
		return false;
	}

	// target array too short? increase size and move on
	if( indexTarget > targetStacks.Length-1 )
	{
		targetStacks.Add( indexTarget - targetStacks.Length );
	}

	if( targetStacks[indexTarget] == none ) // move
	{
		;
		tmpStack = sourceStacks[ indexSource ];
		targetStacks.Remove( indexTarget, 1 );
		targetStacks.InsertItem( indexTarget, tmpStack );
		sourceStacks.Remove( indexSource, 1 );
		sourceStacks.Insert( indexSource, 1 );
		;
		if(withinSameArmy)
		{
			targetStacks.Remove( indexSource, 1 );
			targetStacks.Insert( indexSource, 1 );
		}
	}
	else if( targetStacks[indexTarget].GetStackType().GetName() == sourceStacks[indexSource].GetStackType().GetName() ) // merge
	{
		targetStacks[indexTarget].SetStackSize( targetStacks[indexTarget].GetStackSize() + sourceStacks[ indexSource ].GetStackSize() );
		sourceStacks.Remove( indexSource, 1 );
		sourceStacks.Insert( indexSource, 1 );
		if(withinSameArmy)
		{
			targetStacks.Remove( indexSource, 1 );
			targetStacks.Insert( indexSource, 1 );
		}
	}
	else // swap
	{
		;
		tmpStack = sourceStacks[ indexSource ];
			
		// remove from source
		sourceStacks.Remove( indexSource, 1 );
		if(withinSameArmy)
		{
			targetStacks.Remove( indexSource, 1 );
		}
			
		// target -> source
		if( withinSameArmy && indexSource < indexTarget ) { indexTarget--; }
		sourceStacks.InsertItem( indexSource, targetStacks[indexTarget] );
		if(withinSameArmy)
		{
			targetStacks.InsertItem( indexSource, targetStacks[indexTarget] );
		}
			
		// source -> target
		if( withinSameArmy && indexSource < indexTarget+1 ) { indexTarget++; }
		targetStacks.Remove( indexTarget, 1 );
		targetStacks.InsertItem( indexTarget, tmpStack );
	}

	stacks = sourceStacks;
	; 
	;
	for( i = 0; i < stacks.Length; i++ )
	{
		if( stacks[i] != none )
			;
		else
			;
	}
	;
	;

	stacks = targetStacks;
	;
	;
	for( i = 0; i < stacks.Length; i++ )
	{
		if( stacks[i] != none )
			;
		else
			;
	}
	;
	;

	return true;
}

/* Logs current game state for OOS */
function DumpCurrentState()
{
	if(GetStackSize() > 0)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("     "@GetStackType().GetName()@GetStackSize(), 0);;
	}
}

