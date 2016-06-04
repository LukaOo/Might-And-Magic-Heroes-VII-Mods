//=============================================================================
// H7MainMenuController
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MainMenuController extends H7BaseGameController
		hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display);

var (MainMenuConfiguration) protected Archetype H7MainMenuConfiguration mMainMenuConfiguration<DisplayName = Configuration>;

static function H7MainMenuController GetInstance()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetMainMenuController();
}

function H7MainMenuConfiguration	GetConfig()	{ return mMainMenuConfiguration; }

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetMainMenuController(self);

	class'Engine'.static.StopMovie(true); // stop the movie loading screen

	class'H7TransitionData'.static.GetInstance().SetIsInMapTransition(false);
	
	startMusic();

	class'H7ReplicationInfo'.static.PrintLogMessage("Created H7MainMenuController" @ self, 0);;
}

function startMusic()
{
	local bool stillInMainMenu, isPlayingMatinee;
	
	isPlayingMatinee = class'H7CouncilManager'.static.GetInstance().GetMatineeManager().IsMatineePlaying();

	stillInMainMenu = class'H7TransitionData'.static.GetInstance().GetIsMainMenu();

	if(!stillInMainMenu && !isPlayingMatinee )
	{
		//To ensure on every return to the main menu the music is resetted and only one main menu music is played
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_ALL_MUSIC");
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("MAIN_MENU");
		//For switching between the lobby's, the music should remain playing
		
		if(class'H7SoundController'.static.GetInstance().GetMasterSettings() && class'H7SoundController'.static.GetInstance().GetMusicSetting())
		{
			class'H7TransitionData'.static.GetInstance().SetIsMainMenu(true);
			stillInMainMenu = true;
		}
	}
	//Playing Music prevented by matinee, set play after finished
	if(isPlayingMatinee)
	{
		class'H7CouncilManager'.static.GetInstance().GetMatineeManager().SetPlayMainMenuMusicPrevented(true);
	}
	
}
