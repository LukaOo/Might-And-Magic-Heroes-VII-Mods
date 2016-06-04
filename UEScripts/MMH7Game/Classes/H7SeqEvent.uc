//=============================================================================
// H7SeqEvent
//
// Base class for Heroes VII triggers.
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqEvent extends SequenceEvent
	abstract
	implements(H7IAliasable)
	native;

var transient H7EventParam mEventParam;
//use mEventParam (and cast) to check conditions
event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7PlayerController playerCntl;
	local H7AdventurePlayerController advPlayerCntl;

	playerCntl = class'H7PlayerController'.static.GetPlayerController();
	advPlayerCntl = H7AdventurePlayerController( playerCntl );

	// Make sure linked variables are published at this point
	PublishLinkedVariableValues();

	// Make sure triggers are ignored during scripted scenes
	if( advPlayerCntl != none && class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) 
	{
		return !playerCntl.IsFlythroughRunning();
	}
	else if( playerCntl != none )
	{
		return !playerCntl.IsFlythroughRunning();
	}

	// Make sure triggers are delayed until the entire post combat process has been completed
	// TODO

	return true;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

