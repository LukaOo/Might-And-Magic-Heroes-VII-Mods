//=============================================================================
// H7MatineeManager
//=============================================================================
//
// Used for handling Matinees in CouncilHub
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MatineeManager extends Object
	native;

var protected const float FLOAT_MAX;
var protected H7CouncilManager mCouncilManager;

var protected SeqAct_Interp mMonitoredMatinee; 
var protected bool mMatineeWasPlaying;

var protected SeqAct_Interp mCaptureMatinee;
var protected float mCaptureStartTime;
var protected float mCaptureTime;

// Stores information about matinee camera when it Finished playing
var protected Rotator mCamRot;
var protected Vector mCamPos;

var protected bool mPlayMainMenuMusicPrevented;
var protected bool mBlockingFrame;


//If the matinee start was faster then the first attempt to play the main menu music it must me noted to play it after the sequence for sure
function SetPlayMainMenuMusicPrevented(bool val)
{
	mPlayMainMenuMusicPrevented = val;
}

function SetMonitoredMatinee(SeqAct_Interp matineeToMonitor)
{
	mMonitoredMatinee = matineeToMonitor;
}
function SeqAct_Interp GetMonitoredMatinee()
{
	return mMonitoredMatinee;
}

function Initialize(H7CouncilManager newOwner)
{
	mCouncilManager = newOwner;

	HockUpToGameReadyEvent();
}

// CANCELMATINEE can't handle reversing
function CancelCurrentMatinee(optional bool jump = false)
{
	local array <InterpData> matineeInterpData;
	local float rightBeforeEndTime, requestedPos;
	local int i;

	rightBeforeEndTime = 0.1f;

	if(mCouncilManager.GetALocalPlayerController().bCinematicMode && mMonitoredMatinee.bIsPlaying )
	{
		if( mMonitoredMatinee.bReversePlayback)
		{
			mMonitoredMatinee.SetPosition( rightBeforeEndTime, jump );
		}
		else
		{
			mMonitoredMatinee.GetInterpDataVars(matineeInterpData);

			for(i = 0; i < matineeInterpData.Length; ++i)
			{
				requestedPos += matineeInterpData[i].InterpLength;
			}
			class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetVoiceOverStopAllEvent());
			mMonitoredMatinee.SetPosition( requestedPos, jump);
		}
	}

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().HideSubtitle();
}




function CaptureMatineeAtPos(string matineeName, out vector resultPos, out rotator resultRot,out float resultFOV, optional float position = 0.0f /* Time */, optional bool atTheEnd = false/* this overrides position */)
{
	local array <InterpData> matineeInterpData;
	local SeqAct_Interp captureMatinee;
	local float requestedPos;
	local int i;

	captureMatinee = FindMatineeByObjComment(matineeName);

	captureMatinee.GetInterpDataVars(matineeInterpData);

	if(matineeInterpData.Length < 1)
	{
		return; // No interp data
	}

	if(atTheEnd) // Get last interpData
	{
		requestedPos = 0.0f;

		for(i = 0; i < matineeInterpData.Length; ++i)
		{
			requestedPos += matineeInterpData[i].InterpLength;
		}
	}
	else // Get interpData with latest position
	{
		requestedPos = position;
	}

	ProcessCaptureAtPos(captureMatinee, matineeInterpData, requestedPos, resultPos, resultRot, resultFOV);
}

native function ProcessCaptureAtPos(SeqAct_Interp captureMatinee, array <InterpData> matineeInterpData, float position /* Time */, out vector resultPos, out rotator resultRot, out float resultFOV);

function UpdateTick(float deltaTime)
{
	if(mMonitoredMatinee != none)
	{
		if(mMonitoredMatinee.bIsPlaying) mMatineeWasPlaying = true; // to find at least 1 frame where it played

		if(mMatineeWasPlaying && !mMonitoredMatinee.bIsPlaying && !mBlockingFrame)
		{
			mMonitoredMatinee.bRewindOnPlay = true;
			MatineeFinished(mMonitoredMatinee.ObjComment);
			mMonitoredMatinee = none;
			mMatineeWasPlaying = false;
		}

		if(mBlockingFrame)
		{
			mBlockingFrame = false;
		}
	}
}

function HockUpToGameReadyEvent()
{
	class'H7TransitionData'.static.GetInstance().SetReadyForMatineeListener(GameIsReady);
}

function SeqAct_Interp FindMatineeByObjComment(string matinee)
{
	local SeqAct_Interp matineeSeq;
	local Sequence gameSeq;
	local array<SequenceObject> allSeqObs;
	local SequenceObject seqOb;

	if(mCouncilManager != none)
	{
		gameSeq = mCouncilManager.WorldInfo.GetGameSequence();
	}

	if( gameSeq != none )
	{
		gameSeq.FindSeqObjectsByClass(class'SeqAct_Interp', true, allSeqObs);	


		foreach allSeqObs(seqOb)
		{
			matineeSeq = SeqAct_Interp(seqOb);
			if(matineeSeq != none && matineeSeq.ObjComment == matinee)
			{
				return matineeSeq;
			}

		}
	}
}

function PlayMatineeByObjComment(string matinee, optional bool playReversed = false)
{
	local array <InterpData> matineeInterpData;
	local SeqAct_Interp matineeSeq;
	local Sequence gameSeq;
	local array<SequenceObject> allSeqObs;
	local SequenceObject seqOb;
	local float newPos;
	local int i;

	;

	if(mCouncilManager != none)
	{
		gameSeq = mCouncilManager.WorldInfo.GetGameSequence();
	}
	
	//ConsoleCommand("toggleallscreenmessages"); // they are not in the final game i.e. "lighting needs to be rebuild"
	class'H7PlayerController'.static.GetPlayerController().GetHud().SetHUDMode(HM_CINEMATIC_SUBTITLE);
	class'H7PlayerController'.static.GetPlayerController().SetCinematicMode(true,false,false,false,false,false);

	if(IsStartMatinee(matinee) || IsEndMatinee(matinee) || IsProgressMatinee(matinee) || mCouncilManager.GetFirstIntroMatinee() == matinee)
	{
		//`log("MatineeName:"@matinee@"IsStartMatinee" @ IsStartMatinee(matinee) @ "IsEndMatinee" @ IsEndMatinee(matinee) @ "IsProgressMatinee" @  IsProgressMatinee(matinee) @ "IsIntroMatinee" @ IsIntroMatinee(matinee));
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("PAUSE_GAME_THEME");
	}

	if (gameSeq != None)
	{
		// find any matinee actions that exist
		gameSeq.FindSeqObjectsByClass(class'SeqAct_Interp', true, allSeqObs);	

		foreach allSeqObs(seqOb)
		{
			matineeSeq = SeqAct_Interp(seqOb);
			if(matineeSeq != none && matineeSeq.ObjComment == matinee)
			{
				;
				mMonitoredMatinee = matineeSeq;
				mMatineeWasPlaying = false;

				mMonitoredMatinee.GetInterpDataVars(matineeInterpData);

				if(playReversed)
				{
					for(i = 0; i < matineeInterpData.Length; ++i)
					{
						newPos += matineeInterpData[i].InterpLength;
					}

					matineeSeq.SetPosition(newPos, false);


					matineeSeq.ForceActivateInput(1);
				}
				else
				{
					matineeSeq.ForceActivateInput(0);
				}
				
				return;
			}
		}
	}

	;
	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("matinee" @ matinee @ "not found",MD_QA_LOG);;
	MatineeFinished(matinee);
}

// Campaign Completed!
function HandleCampaignCompletion()
{
	local H7PlayerProfile playerProfile;
	local string progressMatinee;

	playerProfile = class'H7PlayerProfile'.static.GetInstance();

	if(playerProfile.GetNumCompletedMaps(playerProfile.GetCurrentCampaign().CampaignRef) == playerProfile.GetCurrentCampaign().CampaignRef.GetMapsNum()) 
	{
		if(playerProfile.GetNumCompletedCampaigns(true) < mCouncilManager.GetProgressMatineesLength() && !playerProfile.IsIvanCampaignFinished() && !playerProfile.GetCurrentCampaign().ProgressScenePlayed)
		{
			progressMatinee = mCouncilManager.GetProgressMatinees()[playerProfile.GetNumCompletedCampaigns(true) -1];
			playerProfile.ProgressScenePlayed();

			mCouncilManager.OverrideNextTransition(progressMatinee);
			mBlockingFrame = true;

			mCouncilManager.BeginState(name("StateMainMenu"));
		}
	}

}

// called when this matinee was finished
function MatineeFinished(string nameOfFinishedMatinee)
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().HideSubtitle();

	;
	if(IsStartMatinee(nameOfFinishedMatinee))
	{
		mCouncilManager.StartFirstMapOfCurrentCampaign();
		StartResumeMainMenuMusic();
	}
	else if(IsEndMatinee(nameOfFinishedMatinee))
	{
		// @TODO: Inform campaign data that matinee was played

		//HandleCampaignCompletion();
		//StartResumeMainMenuMusic();
	}
	else if(IsProgressMatinee(nameOfFinishedMatinee))
	{
		mCouncilManager.SetCouncilState(CS_CouncilView);
		StartResumeMainMenuMusic();
	}
	else if(IsIntroMatinee(nameOfFinishedMatinee))
	{
		class'H7PlayerProfile'.static.GetInstance().SetHasEnteredCouncil();
		StartResumeMainMenuMusic();
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().SetHUDMode(HM_NORMAL);
		//StartResumeMainMenuMusic();
	}
}

function StartResumeMainMenuMusic()
{
	if(mPlayMainMenuMusicPrevented)
	{
		class'H7MainMenuController'.static.GetInstance().startMusic();
	}
	else
	{
		class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetMainMusicResumeEvent(),true,,false);
	}
}

function GameIsReady() // game is ready to switch to matinee playing mode
{
	local string matineeToPlay;

	;

	matineeToPlay = class'H7TransitionData'.static.GetInstance().GetPendingMatinee();

	// Play matinee and set state to CouncilView
	if(matineeToPlay != "")
	{
		mCouncilManager.OverrideNextTransition(matineeToPlay);
		mCouncilManager.OverrideCouncilStartState(CS_CouncilView);
	}

	//PlayMatineeByObjComment(matineeToPlay);
}

function PlayIntroMatinee()
{
	if(class'H7PlayerProfile'.static.GetInstance().HasEnteredCouncil())
	{
		;
		PlayMatineeByObjComment(mCouncilManager.GetIntroMatinee());
	}
	else
	{
		;
		PlayMatineeByObjComment(mCouncilManager.GetFirstIntroMatinee());
	}
}

function bool IsMatineePlaying()
{
	if(mMonitoredMatinee != none)
	{
		return mMonitoredMatinee.bIsPlaying;
	}
	else
	{
		return false;
	}
}

function bool WasMatineePlaying()
{
	return mMatineeWasPlaying;
}

function bool IsIntroMatinee(string matineeName)
{
	if(mCouncilManager.GetIntroMatinee() == matineeName || mCouncilManager.GetFirstIntroMatinee() == matineeName) return true;
	return false;
}

// matinee at the start of campaign
function bool IsStartMatinee(string matineeName)
{
	if(class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef == none) return false;
	return class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef.mStartMatineeName == matineeName;
}
// matinee at the end of campaign
function bool IsEndMatinee(string matineeName)
{
	if(class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef == none) return false;
	return class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef.mEndMatineeName == matineeName;
}

// matinee at the end of n completed campaigns 
// one campaign complete = "I know little now"-matinee
// two campaigns complete = "I know ok now"-matinee
// three campaigns complete = "I know a lot now"-matinee 
function bool IsProgressMatinee(string matineeName)
{
	local array<string> progressMatinees;
	progressMatinees = mCouncilManager.GetProgressMatinees();

	return progressMatinees.Find(matineeName) != INDEX_NONE;
}

