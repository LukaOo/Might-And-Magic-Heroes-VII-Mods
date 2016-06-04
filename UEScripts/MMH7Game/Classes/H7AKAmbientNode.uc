//=============================================================================
// H7AKAmbientNode
//=============================================================================
// Special Node for special ambient sound, with a activity state
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AKAmbientNode extends Actor
	placeable
	savegame;

var (Properties) protected savegame bool mActive<DisplayName=Play on start(Is Active)>;

var(Audio) protected AkEvent mPlayAkEvent<DisplayName=Play AKEvent>;
var(Audio) protected AkEvent mStopAkEvent<DisplayName=Stop AKEvent>;

function bool GetAmbientState() { return mActive; }

function PostBeginPlay()
{
	//The AKAudioDevice must be ready
	SetTimer(1.0f,false,'Initialize');
}

function Initialize()
{
	if(mActive)
	{
		self.PlayAkEvent(mPlayAkEvent,true,,true,self.Location);
	}
}

function EnableAkEvent()
{
	if(!mActive)
	{
		self.PlayAkEvent(mPlayAkEvent,true,,true,self.Location);
		mActive = true;
	}
}

function DisableAkEvent()
{
	if(mActive)
	{
		self.PlayAkEvent(mStopAkEvent,true,,true,self.Location);
		mActive = false;
	}
}

