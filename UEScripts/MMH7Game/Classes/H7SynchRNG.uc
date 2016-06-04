//=============================================================================
// H7SynchRNG
//=============================================================================
//
// Random number generator that is being synchronized between all the players
// Only to be used with operations that affect the logic
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SynchRNG extends Actor
	config(Game)
	native;

const SYNCHRNG_REFILL_SIZE = 8192;
const SYNCHRNG_MIN_POOL_SIZE = 4096;

var protected array<float> mRandomNumbersPool;
var protected int mCounter;
var protected int mMinPoolSize;

function Init()
{
	mMinPoolSize = SYNCHRNG_MIN_POOL_SIZE;

	// lets add enough random numbers for the initialization of the game
	SendRefillPool();
}

// GetRandomIntNative will give you a value between [0 and max) 
native function int GetRandomIntNative( int max ); 

// GetRandomInt will give you a value between [0 and max) 
function int GetRandomInt( int max )
{
	//`LOG_MP("GetRandomInt:"@mCounter);
	//scripttrace();
	return GetRandomIntNative( max );
}

function int GetRandomIntRange(int min, int max)
{
	//`LOG_MP("GetRandomInt:"@mCounter);
	//scripttrace();
	return min + GetRandomIntNative( max - min );
}

function int GetCounter()
{
	return mCounter;
}

function SetCounter( int newCounter )
{
	mCounter = newCounter;
}

// returns a random number between 0 and 1
function float GetRandomFloat()
{
	local float random;

	random = mRandomNumbersPool[mCounter];

	if( mCounter >= mMinPoolSize )
	{
		mMinPoolSize += SYNCHRNG_REFILL_SIZE;
		SendRefillPool();
	}

	mCounter++;

	// cleaning the pool is only allowed in the adventure map
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && mCounter > SYNCHRNG_REFILL_SIZE )
	{
		mRandomNumbersPool.Remove( 0, SYNCHRNG_MIN_POOL_SIZE );
		mCounter -= SYNCHRNG_MIN_POOL_SIZE;
		mMinPoolSize -= SYNCHRNG_MIN_POOL_SIZE;
		//`LOG_MP( "GetRandomFloat Cleaning Pool -->Counter:" @ mCounter );
	}

	//`LOG_MP( "GetRandomFloat:" @ random @ " -->Counter:" @ mCounter );
	//ScriptTrace();
	return random;
}

native function RefillPool( int synchSeed );

native protected function int GenerateSeed();

native protected function SendRefillPool();
