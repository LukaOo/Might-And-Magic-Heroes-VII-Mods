//=============================================================================
// H7SeqAct_LoadBackground
//=============================================================================
// Kismet action to load a fullscreen gui background image
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqAct_LoadBackground extends SequenceAction;

var() Texture2D Background;
var() float FadeInTime;
var() float FadeInDelay;
var() bool ShowHUD;
var() bool HideHUD;
var() string ScreenText;

event Activated()
{
	//local SeqEvent_Input inputNode;
	//local Sequence gameSeq;
	//local array<SequenceObject> allSeqObs;
	//local SequenceObject seqOb;
	//local WorldInfo theWorldInfo;
		
	;
	if( Background == none )
	{
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetBackgroundImageCntl().UnloadBackground();
	}
	else
	{
		/*// hack - dont show load screen if already spaced was pressed by monkey spammers
		theWorldInfo = class'WorldInfo'.static.GetWorldInfo();
		gameSeq = theWorldInfo.GetGameSequence();

		if (gameSeq != None)
		{
			// find any matinee actions that exist
			gameSeq.FindSeqObjectsByClass(class'SeqEvent_Input', true, allSeqObs);	
			foreach allSeqObs(seqOb)
			{   
				inputNode = SeqEvent_Input(seqOb);
				`log_dui("InputNode" @ inputNode.ActivateCount @ inputNode.Activated @ inputNode.ActivationTime @ inputNode.bActive @ inputNode.bEnabled @ inputNode.bTrapInput @ inputNode.InputNames[0]);
				//[0044.71]     DUI: InputNode 1 AM_Stronghold_Map1.TheWorld:PersistentLevel.Main_Sequence.Sequence_0.SeqEvent_Input_0.Activated 0.0000 False True True Enter
				//[0044.71]     DUI: InputNode 0 AM_Stronghold_Map1.TheWorld:PersistentLevel.Main_Sequence.Sequence_0.SeqEvent_Input_2.Activated 0.0000 False False False Enter
				if(inputNode.ActivateCount > 0)
				{
					`log_dui("spammer!");
					return;
					//inputNode.ActivateCount = 0;
					//`log_dui("fixed InputNode" @ inputNode.ActivateCount @ inputNode.Activated @ inputNode.ActivationTime @ inputNode.bActive @ inputNode.bEnabled @ inputNode.bTrapInput @ inputNode.InputNames[0]);
				}
			}
		}*/

		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetBackgroundImageCntl().LoadBackground(Background,FadeInTime,FadeInDelay,ScreenText);
	}

	if( HideHUD )
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetLogCntl().GetQALog().SetVisibleSave(false);
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetLogCntl().GetLog().SetVisibleSave(false);
		
		if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
		{
			class'H7AdventureHudCntl'.static.GetInstance().SetVisible(false);
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(false); // debatable
		}
		else
		{
			class'H7CombatHud'.static.GetInstance().SetCombatHudVisible(false);
		}
	}
	else if( ShowHUD )
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetLogCntl().GetQALog().SetVisibleSave(true);
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetLogCntl().GetLog().SetVisibleSave(true);
		
		if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
		{
			class'H7AdventureHudCntl'.static.GetInstance().SetVisible(true);
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetGUIOverlaySystemCntl().GetSideBar().SetVisibleSave(true); // debatable
		}
		else
		{
			class'H7CombatHud'.static.GetInstance().SetCombatHudVisible(true);
		}
	}
}

