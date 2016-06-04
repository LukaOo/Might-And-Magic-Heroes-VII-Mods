//=============================================================================
// H7BaseGameController
//=============================================================================
//
// Base class for the game controllers (combat and adventuremap)
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BaseGameController extends Actor
	native;

var protected H7CommandQueue				mCommandQueue;

function H7CommandQueue GetCommandQueue() { return mCommandQueue; }

static function H7BaseGameController GetBaseInstance()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetBaseGameController();
}

function PostBeginPlay()
{
	;
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetBaseGameController( self );

	mCommandQueue = class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue();
}
