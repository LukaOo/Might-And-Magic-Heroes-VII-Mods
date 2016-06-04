/*=============================================================================
 * H7SeqAct_EndNpcScene
 * 
 * TODO: Merge with H7SeqAct_ToggleFlythroughMode/ real unreal cinematic mode
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_EndNpcScene extends SequenceAction
	implements(H7IAliasable)
	native;

function Activated()
{
	local H7PlayerController playerCntl;
	local H7AdventurePlayerController advPlayerCntl;
	local H7ReplicationInfo h7RI;

	playerCntl = class'H7PlayerController'.static.GetPlayerController();
	playerCntl.SetInputAllowedFromKismet(true);
	advPlayerCntl = H7AdventurePlayerController( playerCntl );
	h7RI = class'H7ReplicationInfo'.static.GetInstance();

	if(h7RI != none)
	{
		h7RI.SetCutsceneMode(false);

		if(h7RI.IsAdventureMap())
		{
			playerCntl.GetHud().SetHUDMode(class'H7ScriptingController'.static.GetInstance().GetPreviousHUDMode());
		}
	}

	if( advPlayerCntl != none && h7RI.IsAdventureMap() ) 
	{
		advPlayerCntl.SetFlythroughRunning(false, true, true, false);
	}
	else if( playerCntl != none )
	{
		playerCntl.SetFlythroughRunning(false, true, true, false);
	}

	// un-mute sound effect channel
	class'H7SoundController'.static.GetInstance().EnableSoundCutsceneChannel(true);
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

