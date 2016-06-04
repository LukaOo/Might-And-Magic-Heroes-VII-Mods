/*=============================================================================
 * H7SeqAct_StartNpcScene
 * 
 * TODO: Merge with H7SeqAct_ToggleFlythroughMode/ real unreal cinematic mode
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_StartNpcScene extends H7SeqAct_InterruptAction
	implements(H7IAliasable)
	hideCategories(Interrupt)
	native;

var(Properties) string mSceneName<DisplayName="Scene Name">;

function Activated()
{
	local H7PlayerController playerCntl;
	local H7AdventurePlayerController advPlayerCntl;
	local H7ReplicationInfo h7RI;

	super.Activated();

	playerCntl = class'H7PlayerController'.static.GetPlayerController();
	playerCntl.SetInputAllowedFromKismet(false);
	advPlayerCntl = H7AdventurePlayerController( playerCntl );
	h7RI = class'H7ReplicationInfo'.static.GetInstance();

	if(h7RI != none)
	{
		h7RI.SetCutsceneMode(true);

		if(h7RI.IsAdventureMap())
		{
			if(playerCntl.GetHud().GetHUDMode() != HM_CINEMATIC_SUBTITLE)
			{
				class'H7ScriptingController'.static.GetInstance().SetPreviousHUDMode(playerCntl.GetHud().GetHUDMode());
				playerCntl.GetHud().SetHUDMode(HM_CINEMATIC_SUBTITLE);
			}
		}
	}

	if( advPlayerCntl != none && h7RI.IsAdventureMap() && !advPlayerCntl.IsFlythroughRunning()) 
	{
		advPlayerCntl.ResetCutsceneFlags();
		advPlayerCntl.SetFlythroughRunning(true, true, true, false);
	}
	else if( playerCntl != none  && !playerCntl.IsFlythroughRunning())
	{
		playerCntl.ResetCutsceneFlags();
		playerCntl.SetFlythroughRunning(true, true, true, false);
	}

	// mute sound effect channel
	class'H7SoundController'.static.GetInstance().EnableSoundCutsceneChannel(false);
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

