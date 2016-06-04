//=============================================================================
// H7CouncilPlayerControll
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilPlayerController extends H7PlayerController
	dependson(H7CouncilGameInfo);
/*	config(Game)
	native;*/

var protected float mLastLeftClickTime;
var protected Actor mLastClickedActor;

// To infinity and beyond!
var protected const float FLOAT_MAX;

var protected H7CouncilManager mCouncilManager;
var protected Actor mPreviousActorUnderMouse;
var protected Actor mActorUnderMouse;

var protected bool mCampaignCheatEnabled;

var protected array<InterpActor> mDynamicCouncilActors;

function array<InterpActor> GetCouncilInterpActors() { return mDynamicCouncilActors; }

function H7CouncilManager GetCouncilManager()
{
	return mCouncilManager;
}
function SetCouncilManager(H7CouncilManager newManager)
{
	mCouncilManager = newManager;
}

function Actor GetCurrentActorUnderMouse()
{
	return mActorUnderMouse;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	mCouncilManager = H7CouncilGameInfo(WorldInfo.Game).GetCouncilManager();

	if(class'H7PlayerProfile'.static.GetInstance() != none)
	{
		class'H7PlayerProfile'.static.GetInstance().CacheSaves();
	}

	FindAllInterpActors(mDynamicCouncilActors);
}

// Called after viewport/net/ref of PC are set
simulated event ReceivedPlayer()
{
	local vector resultPos;
	local rotator resultRot;
	local float resultFOV;

	super.ReceivedPlayer();

	class'H7Camera'.static.GetInstance().UseCameraCouncil();

	if(mCouncilManager != none)
	{
		mCouncilManager.GetMatineeManager().CaptureMatineeAtPos(mCouncilManager.GetIntroMatinee(), resultPos, resultRot, resultFOV, 0.0f, false);

		mCouncilManager.GetCouncilCamera().SetCameraTransform(resultPos, resultRot, resultFOV);
	}
}

event PlayerTick( float DeltaTime )
{
	local ImpactInfo finalHitInfo;

	class'H7PlayerProfile'.static.GetInstance().TickSave(DeltaTime);

	class'H7TransitionData'.static.GetInstance().GetContentScanner().ComputeTick();

	HandleCinematics(DeltaTime);
	
	mPreviousActorUnderMouse = mActorUnderMouse;

	// @TODO: Move it to cpp or find better solution then spamming traces
	if( !IsMouseOverHUD() && IsKismetAllowsInput() && IsUnrealAllowsInput() && !mCouncilManager.GetMatineeManager().IsMatineePlaying() )
	{
		if(GetActorUnderMouse(finalHitInfo))
		{
			mActorUnderMouse = finalHitInfo.HitActor;

			//WorldInfo.AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 0, 0, 255), "Under mouse ->"@finalHitInfo.HitActor);
		}
		else
		{
			mActorUnderMouse = none;
		}
	}

	
	if(mActorUnderMouse != mPreviousActorUnderMouse)
	{
		// Tell previous actor that mouse is not over him anymore
		if(H7CouncilInteractive(mPreviousActorUnderMouse) != none)
		{
			H7CouncilInteractive(mPreviousActorUnderMouse).MouseOverStop();
		}

		if(mCouncilManager != none && mCouncilManager.GetCouncilState() == CS_CouncilView && mCouncilManager.CheckIfActorIsATable(mPreviousActorUnderMouse))
		{
			if(mCouncilManager.GetMapManager() != none && mCouncilManager.GetMapManager().GetContinentMesh() != none)
			{
				mCouncilManager.GetMapManager().GetContinentMesh().StaticMeshComponent.SetOutlined(false);
			}
		}

		// Tell cure actor that mouse is over him
		if(H7CouncilInteractive(mActorUnderMouse) != none)
		{
			H7CouncilInteractive(mActorUnderMouse).MouseOverStart();
		}

		if(mCouncilManager != none && mCouncilManager.GetCouncilState() == CS_CouncilView && mCouncilManager.CheckIfActorIsATable(mActorUnderMouse))
		{
			if(mCouncilManager.GetMapManager() != none && mCouncilManager.GetMapManager().GetContinentMesh() != none)
			{
				mCouncilManager.GetMapManager().GetContinentMesh().StaticMeshComponent.SetOutlined(true);
			}
		}
	}
}

exec function ToggleMenu() // it's really: Cancel current window/action, Escape
{
	local bool canGoBack;

	// Go back in main menu
	// first, where are we?
	if(IsCinematicRunning())
	{
		SkipMovie();
		return;
	}

	// OPTIONAL if matinee playing
	if(bCinematicMode && mCouncilManager.GetMatineeManager().IsMatineePlaying())
	{
		mCouncilManager.GetMatineeManager().CancelCurrentMatinee(true);
		SetCinematicMode(false,false,false,false,false,false);
		return;
	}

	// standalone semi-official campaign select
	if(H7MainMenuHud(GetHud()).GetMainMenuCntl().GetCouncilorWindow().IsVisible() && H7MainMenuHud(GetHud()).GetMainMenuCntl().GetCouncilorWindow().GetStandAloneMode())
	{
		if(H7MainMenuHud(GetHud()).GetMainMenuCntl().IsCustomDifficultyVisible())
		{
			H7MainMenuHud(GetHud()).GetMainMenuCntl().CloseCustomDifficulty();
			return;
		}
		H7MainMenuHud(GetHud()).GetMainMenuCntl().GetCouncilorWindow().SetVisibleSave(false);
		H7MainMenuHud(GetHud()).GetMainMenuCntl().CouncilorWindowClosed();
		return;
	}

	if(mCouncilManager.GetCouncilState() != CS_MainMenu && !mCouncilManager.WaitingForStateChange())
	{
		if(mCouncilManager.GetCouncilState() == CS_CouncillorView)
		{
			if(H7MainMenuHud(GetHud()).GetMainMenuCntl().IsCustomDifficultyVisible())
			{
				H7MainMenuHud(GetHud()).GetMainMenuCntl().CloseCustomDifficulty();
				return;
			}
		}
		if( mCouncilManager.GetCouncilState() == CS_CampaignView )
		{
			if(GetHud().GetDialogCntl().IsCustomDifficultyVisible())
			{
				GetHud().GetDialogCntl().CloseCustomDifficulty();
				return;
			}
		}
		mCouncilManager.TransitionBack();
		return;
	}

	// campaign select - screen - does this state make sense? when are the map controls visible and it goes back to main menu?
	if(GetHud().GetDialogCntl().GetMapControls().IsVisible())
	{
		GetHud().GetDialogCntl().GetMapControls().SetVisibleSave(false);
		H7MainMenuHud(GetHud()).GetMainMenuCntl().GetMainMenu().Reset();
		H7MainMenuHud(GetHud()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(true);
		return;
	}
	// map select - screen
	if(H7MainMenuHud(GetHud()).GetMapSelectCntl().GetMapList().IsVisible())
	{
		H7MainMenuHud(GetHud()).GetMapSelectCntl().ClosePopup();
		return;
	}
	// join game - popup
	if(H7MainMenuHud(GetHud()).GetLobbySelectCntl().GetLobbyList().IsVisible())
	{
		H7MainMenuHud(GetHud()).GetLobbySelectCntl().ClosePopup();
		return;
	}
	// option menu - popup
	if(GetHud().GetOptionsMenuCntl().GetOptionsMenu().IsVisible())
	{
		GetHud().GetOptionsMenuCntl().ClosePopup();
		H7MainMenuHud(GetHud()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(true);
		return;
	}
	
	// loadsave
	if(H7MainMenuHud(GetHud()).GetLoadSaveWindowCntl().GetLoadSaveWindow().IsVisible())
	{
		H7MainMenuHud(GetHud()).GetLoadSaveWindowCntl().ClosePopup();
		return;
	}

	// heropedia, skirmish, duel
	super.ToggleMenu();

	if(!mDidToggle)
	{
		// main menu back
		canGoBack = H7MainMenuHud(GetHud()).GetMainMenuCntl().GetMainMenu().GoBack() == 1;
		if(!canGoBack)
		{
			H7MainMenuHud(GetHud()).GetMainMenuCntl().QuitGame();
		}
	}
}

	

exec function LeftMouseDown()
{
	local ImpactInfo finalHitInfo;
	local CouncillorData councillorInfo;
	local AkEvent currentVoiceOver;
	// Check if we are allowed to do any actions ( are we in council view! not main menu )

	if(mCouncilManager == none)
	{
		// Change it later to `log
		WorldInfo.AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 0, 0, 255) , "Found no CouncilManager on scene! Please place it." );
	}

	// Mouse is not over HUD and input is allowed
	if( !IsMouseOverHUD() && IsKismetAllowsInput() && IsUnrealAllowsInput() && !mCouncilManager.GetMatineeManager().IsMatineePlaying())
	{
		if(GetActorUnderMouse(finalHitInfo))
		{
			
			if(mCouncilManager != none && mCouncilManager.GetCouncilState() == CS_CouncilView )
			{

				if(mCouncilManager.CheckIfActorIsCouncillor(finalHitInfo.HitActor, councillorInfo))
				{
					mCouncilManager.SetCurrentCouncillorInfo(councillorInfo);
					mCouncilManager.SetCouncilState(CS_CouncillorView);
					
					class'H7SoundManager'.static.PlayAkEventOnActor(finalHitInfo.HitActor, class'H7SoundController'.static.GetInstance().GetVoiceOverStopAllEvent(), true);

					if(!councillorInfo.isIvan)
					{
						// Playing the Councillor Selected AkEvent, when the Player selects the Actor
						currentVoiceOver = GetProgressDependantCouncillorAkEvent(councillorInfo);
					}
					else
					{
						currentVoiceOver = GetGameProgressDependantIvanVoiceOver(councillorInfo);
					}
					
					if(currentVoiceOver != none)
					{
						class'H7SoundManager'.static.PlayAkEventOnActor(finalHitInfo.HitActor, currentVoiceOver,true,true,finalHitInfo.HitActor.Location);
					}
				}
				else if( mCouncilManager.CheckIfActorIsATable(finalHitInfo.HitActor) )
				{
					mCouncilManager.SetCouncilState(CS_CampaignView);
					//WorldInfo.AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 0, 0, 255) , "OH MY GOD! ITS SUPERMAP!." );
				}
				// If he is an councillor
			}

			if(H7CouncilGameInfo(WorldInfo.Game) != none)
			{
				if(H7CouncilFlagActor(finalHitInfo.HitActor) != none && mCouncilManager.GetCouncilState() == CS_CampaignView)
				{
					FlagSelected(H7CouncilFlagActor(finalHitInfo.HitActor), H7CouncilGameInfo(WorldInfo.Game).GetCouncilManager().GetMapManager() );
				}
			}

			if(H7CouncilInteractive(finalHitInfo.HitActor) != none)
			{
				H7CouncilInteractive(finalHitInfo.HitActor).ClickedOn();
			}
		}
	}
}

function AkEvent GetGameProgressDependantIvanVoiceOver(CouncillorData data)
{
	local int completed;
	local AkEvent ivanCompleted;

	if(class'H7PlayerProfile'.static.GetInstance() != none)
	{
		completed = class'H7PlayerProfile'.static.GetInstance().GetNumCompletedCampaigns();
	}

	if(class'H7PlayerProfile'.static.GetInstance().IsCampaignComplete(data.councillorCampaign))
	{
		ivanCompleted = AkEvent'Hub_One_VO.hub_one-liners.Play_VO_HUB_001_10IVA_DRY';
		return ivanCompleted;
	}
	else
	{
		return data.IvanCampaignSelectEvent[completed];
	}
}

function AkEvent GetProgressDependantCouncillorAkEvent(CouncillorData data)
{
	if(!class'H7PlayerProfile'.static.GetInstance().IsCampaignEverStarted(data.councillorCampaign))
	{
		return data.StartCampaignVoiceOver;
	}

	if(class'H7PlayerProfile'.static.GetInstance().IsCampaignComplete(data.councillorCampaign))
	{
		return data.RestartCampaignVoiceOver;
	}

	return data.ContinueCampaignVoiceOver;
}

function AkEvent ProgressDependantSelectionConfirmAkEvent(CouncillorData data)
{
	local int random;

	if(!class'H7PlayerProfile'.static.GetInstance().IsCampaignEverStarted(data.councillorCampaign))
	{
		if(!class'H7PlayerProfile'.static.GetInstance().IsCampaignComplete(data.councillorCampaign))
		{
			random = rand(data.StartCampaignConfirmEvent.Length);

			return data.StartCampaignConfirmEvent[random];
		}
		else
		{
			return none;
		}
	}

	random = rand(data.ContinueCampaignConfirmEvent.Length);

	return data.ContinueCampaignConfirmEvent[random];
}

function AkEvent GetRestartConfirmAkEvent(CouncillorData data)
{
	local int random;

	if(class'H7PlayerProfile'.static.GetInstance().IsCampaignComplete(data.councillorCampaign))
	{
		random = rand(data.RestartCampaignConfirmEvent.Length);

		return data.RestartCampaignConfirmEvent[random];
	}
}

function FlagSelected(H7CouncilFlagActor hitActor, H7CouncilMapManager managerRef)
{
	if(hitActor.bHidden == true || managerRef == none)
	{
		return;
	}

	managerRef.SelectFlag(hitActor);
}

// Override of default Pannig Behavior
function Vector PannigCameraMovement()
{
	local Vector diff;

	
	return diff;
}

// @TODO: Move it to cpp maybe?
// Get any actor under mouse
function bool GetActorUnderMouse(optional out ImpactInfo finalHitInfo)
{
	local Actor	 hitActor;
	local Vector2D mousePosition;
	local Vector2D screenSize;
	local TraceHitInfo hitInfo;

	local Vector worldOrigin;
	local Vector worldDirection;

	mousePosition = GetLocalPlayer().ViewportClient.GetMousePosition();
	GetLocalPlayer().ViewportClient.GetViewportSize(screenSize);

	mousePosition.X /= screenSize.X;
	mousePosition.Y /= screenSize.Y;

	GetLocalPlayer().DeProject(mousePosition, worldOrigin, worldDirection);

	hitActor = Trace(finalHitInfo.HitLocation, finalHitInfo.HitNormal, worldDirection * FLOAT_MAX, worldOrigin, true,,hitInfo);
//	worldOrigin = worldOrigin + vect(0.0f, 50.0f, 0.0f);
//	DrawDebugLine( worldDirection * FLOAT_MAX, worldOrigin, 255, 0, 0, TRUE);

	if(hitActor == none) 
		return false;
	
	finalHitInfo.HitActor = hitActor;
	finalHitInfo.HitInfo = hitInfo;

	return true;
}

exec function RightMouseDown()
{
	local ImpactInfo finalHitInfo;
	local CouncillorData councillorInfo;
	local H7PlayerProfile playerProfile;
	// Check if we are allowed to do any actions ( are we in council view! not main menu )

	GetHud().SetRightClickThisFrame(true);
	GetHud().SetRightMouseDown(true);

	if(mCampaignCheatEnabled)
	{
		playerProfile = class'H7PlayerProfile'.static.GetInstance();

		if(mCouncilManager == none)
		{
			// Change it later to `log
			WorldInfo.AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 0, 0, 255) , "Found no CouncilManager on scene! Please place it." );
		}

		// Mouse is not over HUD and input is allowed
		if( !IsMouseOverHUD() && IsKismetAllowsInput() && IsUnrealAllowsInput() && !mCouncilManager.GetMatineeManager().IsMatineePlaying())
		{
			if(GetActorUnderMouse(finalHitInfo))
			{

				if(mCouncilManager != none && mCouncilManager.GetCouncilState() == CS_CouncilView && mCouncilManager.CheckIfActorIsCouncillor(finalHitInfo.HitActor, councillorInfo))
				{
				
					playerProfile.Cheat_CompleteMapForCampaign(councillorInfo.councillorCampaign);
				}
			
			}
		}
	}
}

exec function ResetProfile()
{
	if(class'H7GUIGeneralProperties'.static.GetInstance().GetDebugCheats())
	{
		class'H7PlayerProfile'.static.GetInstance().Cheat_WipePlayerProfile(true);
	}
}

exec function ToggleCampaignCheat()
{
	if(class'H7GUIGeneralProperties'.static.GetInstance().GetDebugCheats())
	{
		mCampaignCheatEnabled = !mCampaignCheatEnabled;
	}
}

exec function UnlockAction(int actionID)
{
	if(class'H7GUIGeneralProperties'.static.GetInstance().GetDebugCheats())
	{
		if(actionID == 1)
		{
			class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().ActionCompleted_DIH();

			return;
		}

		if(actionID == 2)
		{
			class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().ActionCompleted_LFTP();

			return;
		}

		if(actionID == 3)
		{
			class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().ActionCompleted_ML();

			return;
		}
	
		if(actionID == 4)
		{
			class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().ActionCompleted_PYS();

			return;
		}

		if(actionID == 5)
		{
			class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().ActionCompleted_SAAIDY();

			return;
		}
	}
}

exec function UnlockThatAction()
{
	class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().ActionUnlocked("1", "MMH7ACTION01", false, true);
}

