//=============================================================================
// H7CombatPlayerReplicationInfo
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatPlayerReplicationInfo extends PlayerReplicationInfo;

var protected bool mIsAttacker; // false = defender, true = attacker
var protected bool mIsHostReady;
var protected bool mIsPlayerReady;

replication
{
	if( bNetDirty )
		mIsAttacker, mIsHostReady, mIsPlayerReady;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "PostBeginPlay", 0);;
}

function bool IsAttacker() { return mIsAttacker; }
function bool IsHostReady() { return mIsHostReady; }
function bool IsPlayerReady() { return mIsPlayerReady; }

function SetIsAttacker( bool isAttacker )
{
	mIsAttacker = isAttacker;
}

reliable server function SetHostReady()
{
	mIsHostReady = true;
	bNetDirty = true;
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetHostReady", 0);;
}

reliable server function SetPlayerReady()
{
	mIsPlayerReady = true;
	bNetDirty = true;
	class'H7ReplicationInfo'.static.PrintLogMessage(self @ "SetPlayerReady", 0);;
}
