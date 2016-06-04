//=============================================================================
// H7SoundManager
//=============================================================================
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SoundManager extends Actor
native;

var protected Array<AkAmbientSound>                 mAmbientSoundList;
var protected Array<AkAmbientSound>                 mDisabledAmbientSoundList;
var protected bool                                  mDynamicLoopStarted, mLoadingScreenEnabled;

function PostBeginPlay()
{
	//On creation the level transition is over
	class'H7TransitionData'.static.GetInstance().SetIsInMapTransition(false);
}

// plays a sound taking into account the current gamespeed
static function PlayAkEventOnActor( Actor creator, AkEvent sound, optional bool bStopWhenOwnerDestroyed, optional bool bUseLocation, optional vector SourceLocation )
{
	if(sound==None)
	{
		// UNCOMMENT TO TRACK MISSING SOUNDS
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Missing sound! Actor:" @ creator,MD_QA_LOG);;
		return;
	}

	if(creator!=None)
	{
		;
		creator.PlayAkEvent(sound,true,,bStopWhenOwnerDestroyed,SourceLocation);
	}
}

function StartDynamicMusicTimerLoop()
{
	if(!mDynamicLoopStarted)
	{
		SetTimer(0.5f, true, 'StartDynamicMusicTimerLoop');
		mDynamicLoopStarted = true;
	}

	if( class'H7SoundController'.static.GetInstance() == none ){ return; }

	class'H7SoundController'.static.GetInstance().AdventureMapCellInput();
}

// FOW disables covered SoundNodes
function UpdateHearableAmbientSoundNodes()
{
	local int i;

	if(mDisabledAmbientSoundList.Length == 0){ return; }

	for(i = 0; i<mDisabledAmbientSoundList.Length; i++)
	{
		if(class'H7SoundController'.static.GetInstance().FogOfWarIsRevealedCheck(mDisabledAmbientSoundList[i].Location))
		{
			mDisabledAmbientSoundList[i].StartPlayback();
			mDisabledAmbientSoundList.RemoveItem(mDisabledAmbientSoundList[i]);
		}
	}
}

function StopAmbientLayers()
{
	local AkAmbientSound currentAmbientNode;
	local AkEvent basicAmbientStop;

	basicAmbientStop = class'H7SoundController'.static.GetInstance().GetBasicAmbientStopEvent();

	//AKEVENT stops all basic ambience sound events
	if(basicAmbientStop != none)
	{
		PlayAkEvent(basicAmbientStop);
		class'H7SoundController'.static.GetInstance().SetLastAmbientEvent( basicAmbientStop );
	}

	if(mAmbientSoundList.Length == 0){ return; }

	foreach mAmbientSoundList(currentAmbientNode)
	{
		currentAmbientNode.StopPlayback();
	}
	
	;
}

function StartAmbientLayers()
{
	local AkAmbientSound currentAmbientNode;

	if(mAmbientSoundList.Length == 0){ return; }

	//Dont enable ambient in townscreen
	if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != none && class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInTownScreen())
	{
		return;
	}

	foreach mAmbientSoundList(currentAmbientNode)
	{
		//Play only nodes which are uncovered of FoW
		if(class'H7SoundController'.static.GetInstance().FogOfWarIsRevealedCheck(currentAmbientNode.Location))
		{
			currentAmbientNode.StartPlayback();
		}
	}

	;
}

function GetAmbientSoundNodeList()
{
	local AkAmbientSound ambSound, ambReference; 
	local bool ambientRegistered, coveredAmbientRegistered, ambientSoundSetting, masterSetting;

	ambientSoundSetting = class'H7SoundController'.static.GetInstance().GetAmbientSoundSettings();
	masterSetting = class'H7SoundController'.static.GetInstance().GetMasterSettings();

	foreach class'WorldInfo'.static.GetWorldInfo().AllActors( class'AkAmbientSound', ambSound )
	{
		foreach mAmbientSoundList(ambReference)
		{
			if(ambSound == ambReference)
			{
				ambientRegistered = true;
			}
		}
		if(!ambientRegistered)
		{
			mAmbientSoundList.AddItem( ambSound );
			;
		}
		
		//if the node is covered by FoW
		if(!class'H7SoundController'.static.GetInstance().FogOfWarIsRevealedCheck(ambSound.Location))
		{
			foreach mDisabledAmbientSoundList(ambReference)
			{
				if(ambSound == ambReference)
				{
					coveredAmbientRegistered = true;
				}
			}

			if(!coveredAmbientRegistered)
			{
				mDisabledAmbientSoundList.AddItem( ambSound );
				;
			}
		}
	}

	if(ambientSoundSetting && masterSetting)
	{
		StartAmbientLayers();
	}
	else
	{
		StopAmbientLayers();
	}
}

function TrailerMode()
{
	class'H7SoundController'.static.GetInstance().InCinematicMode(true);
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("CINEMATIC");
	class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(1,TrailerIsPlayingCheck);
}

function TrailerIsPlayingCheck()
{
	//While the cinematic is running, do a recusrice check if it's still the case and end the movie mode if not.

	local bool inCinematicMode;

	inCinematicMode = class'H7PlayerController'.static.GetPlayerController().IsCinematicRunning();

	if(inCinematicMode)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(1,TrailerIsPlayingCheck);
	}
	else
	{
		class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetMainMusicResumeEvent(),true);
		class'H7SoundController'.static.GetInstance().InCinematicMode(false);
		class'H7SoundController'.static.GetInstance().EnableSoundChannel(true);
		class'H7SoundController'.static.GetInstance().EnableAmbientChannel(true);
		class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().SetTrailerStarted(false);
		
		return;
	}
}

function LoadingScreenEnabledDelayed(bool val)
{
	mLoadingScreenEnabled = val;
	SetTimer(0.5f,false,'CallLoadingScreenEnabled');
}

function CallLoadingScreenEnabled()
{
	class'H7SoundController'.static.GetInstance().LoadingScreenEnabled(mLoadingScreenEnabled);
	mLoadingScreenEnabled = false;
}

singular event Destroyed()
{
	if(!class'H7TransitionData'.static.GetInstance().GetIsInMapTransition())
	{
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_ALL_MUSIC");
	}
}

event FocusMultiplierTick(float focusVolumeMutliplier)
{
	local float masterVolume;

	masterVolume = class'H7SoundController'.static.GetInstance().GetMasterVolumeSettings();

	//When minimize the game window the game sound and the cinematic sound is muted
	SetRTPCValueBus ('Master_Volume', ( focusVolumeMutliplier * masterVolume) * 100);
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
