class H7SpectatorHUDCntl extends H7FlashMovieBlockPopupCntl;

var protected H7GFxSpecatorHUD mSpectatorHUD;
var protected GFxCLIKWidget mBtnPauseMenu;
var protected int mPreviousSpecatorProgress;

function H7GFxUIContainer GetPopup() { return mSpectatorHUD; }

static function H7SpectatorHUDCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetSpectatorHUDCntl(); }

function bool Initialize()
{
	;
	Super.Start();

	AdvanceDebug(0);

	mSpectatorHUD = H7GFxSpecatorHUD(mRootMC.GetObject("aSpectatorHUD", class'H7GFxSpecatorHUD'));

	mBtnPauseMenu = GFxCLIKWidget(mSpectatorHUD.GetObject("mBtnPauseMenu", class'GFxCLIKWidget'));
	mBtnPauseMenu.AddEventListener('CLIK_click', btnPauseMenuClicked);

	mSpectatorHUD.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function Update()
{
	mSpectatorHUD.Update( "img://" $ Pathname(class'H7BackgroundImageCntl'.static.GetInstance().mBackgroundImageProperties.SpecatortHUDImage));
	OpenPopup();
    
	class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetVisibleSave(false);
	class'H7CombatHudCntl'.static.GetInstance().GetCreatureAbilityButtonPanel().SetVisibleSave(false);
	class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().SetVisibleSave(false);
	class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().SetVisibleSave(false);
	class'H7CombatHudCntl'.static.GetInstance().GetHeroPanel().SetVisibleSave(false);
	class'H7CombatHudCntl'.static.GetInstance().GetTacticsBanner().SetVisibleSave(false);
	class'H7CombatHudCntl'.static.GetInstance().GetTimer().SetVisibleSave(false);
}

/**
 * sets the value of the progressBar
 * @param progress: has to be 0 <= progress <= 100 
 */
function UpdateProgress(int progress)
{
	if( mPreviousSpecatorProgress != progress )
	{
		mPreviousSpecatorProgress = progress;
		mSpectatorHUD.UpdateProgress(progress);
	}
}

function btnPauseMenuClicked(EventData data)
{
	if(GetHUD().GetPauseMenuCntl().GetPopup().IsVisible())
		GetHUD().GetPauseMenuCntl().Closed();
	else
		GetHUD().GetPauseMenuCntl().OpenPopup();
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	super.ClosePopup();

	if(!class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen())
	{
		GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);
	}
}

