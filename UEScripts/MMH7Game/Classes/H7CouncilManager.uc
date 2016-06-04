//=============================================================================
// H7CouncilManager
//=============================================================================
//
// This is an actor that sits in the councilscene.umap
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilManager extends Actor 
	dependson(H7CouncilGameInfo)
	dependson(H7PlayerProfile)
	placeable
;

// List of council members and their references to scene actors etc.
var(CouncilSetup) array<CouncillorData> mCouncilMembers<DisplayName=Council Members>;
var(CouncilSetup) CouncilTable mCouncilTable;

var protected H7MatineeManager mMatineeManager;
var protected H7CouncilGameInfo mCouncilGameInfo;
var protected H7CouncilMapManager mMapManager;

var protected ECouncilState   mPreviousCouncilState;
var protected ECouncilState   mCurrentCouncilState;
var protected CouncillorData  mCurrentConcillor;

var protected Actor mLastActorUnderMouse;
var protected CouncillorData mLastConcillorUnderMouse;


var protected bool mWaitingForStateChange;

var protected bool mShouldReverse;
var protected bool mStateHasFirstTick;
var protected bool mStateHasLastTick;
// If council should override transition matinee (not play them)
var protected bool mOverrideTransitionMatinee;
// Matinee that will be played when overriden
var protected string mOverrideMatineeName;

var protected ECouncilState mOverrideCouncilState;
var protected bool mShouldPlayerProgressMatinee;

// -------------------------------------------------

var() protected string mIntroMatinee<DisplayName=Matinee to play for entering council menu>;
var() protected string mFirstIntroMatinee<DisplayName=Matinee to play for first time entering council menu>; // Main_Intro
var() protected array<string> mProgressMatinees<DisplayName=Play after x campaigns completed>; // contains names of matinees that are in the level for purpose of showing campaign progresses
// Should we have outro ?

static function H7CouncilManager GetInstance() 
{ 
	if(class'WorldInfo'.static.GetWorldInfo() == none)
	{
		return none;
	}

	if(class'WorldInfo'.static.GetWorldInfo().Game == none)
	{
		return none;
	}

	if(H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game) == none)
	{
		return none;
	}

	return H7CouncilGameInfo(class'WorldInfo'.static.GetWorldInfo().Game).GetCouncilManager(); 
}

function H7MatineeManager GetMatineeManager() { return mMatineeManager; } 

function H7CouncilMapManager GetMapManager() { return mMapManager; }
function SetMapManager( H7CouncilMapManager newMapManager) { mMapManager = newMapManager; } 

function bool WaitingForStateChange() { return mWaitingForStateChange; }

function string GetIntroMatinee() { return mIntroMatinee; }
function string GetFirstIntroMatinee() { return mFirstIntroMatinee; }
function array<string> GetProgressMatinees() { return mProgressMatinees; }
function int GetProgressMatineesLength() { return mProgressMatinees.Length; } // because ArrayGetter().Length is unreliable

function array<CouncillorData> GetCouncilMemeber() { return mCouncilMembers; }

function ECouncilState GetCouncilState() { return mCurrentCouncilState; }
function SetCouncilState(ECouncilState newState, optional bool isReversing = false, optional bool forceRestartState)
{
	mPreviousCouncilState = mCurrentCouncilState;

	if(forceRestartState)
	{
		mPreviousCouncilState = CS_MainMenu;
	}

	mWaitingForStateChange = true;

	mCurrentCouncilState = newState;
}

function H7CampaignDefinition GetCurrentCouncillorCampaign() { return mCurrentConcillor.councillorCampaign; }

function CouncillorData GetCurrentCouncillorInfo() { return mCurrentConcillor; }
function SetCurrentCouncillorInfo(CouncillorData newInfo) { mCurrentConcillor = newInfo; } 

function OverrideNextTransition(string newMatineeName)
{
	mOverrideTransitionMatinee = true;
	mOverrideMatineeName = newMatineeName;
}

function OverrideCouncilStartState(ECouncilState newState)
{
	mOverrideCouncilState = newState;
}

function H7Camera GetCouncilCamera()
{
	if( H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
	{
		return H7Camera( class'H7PlayerController'.static.GetPlayerController().PlayerCamera );
	}
}

function PostBeginPlay()
{
	;

	// Report for duty
	mCouncilGameInfo = H7CouncilGameInfo(WorldInfo.Game);
	mCouncilGameInfo.SetCouncilManager(self);

	mMatineeManager = new class'H7MatineeManager'();
	mMatineeManager.Initialize(self);

	if(class'H7TransitionData'.static.GetInstance().GetPendingCouncilState() != CS_Invalid)
	{
		SetCouncilState(class'H7TransitionData'.static.GetInstance().GetPendingCouncilState());
		OverrideCouncilStartState( class'H7TransitionData'.static.GetInstance().GetPendingCouncilState());
		mOverrideTransitionMatinee = true;
		class'H7TransitionData'.static.GetInstance().SetPendingCouncilState(CS_Invalid); // Reset state
	}
	else
	{
		SetCouncilState(CS_MainMenu);
	}

	// TODO Remove when crashing of matinee when closing game/PIEgame is fixed
	class'H7TransitionData'.static.GetInstance().TriggerReadyForMatineeListener();
}

event Tick(float deltaTime)
{
	super.Tick(deltaTime);

	mMatineeManager.UpdateTick(deltaTime);
}

// :D
function bool CheckIfActorIsATable(Actor testActor)
{
	local int i;

	for(i = 0; i < mCouncilTable.tableMeshes.Length; ++i)
	{
		if(mCouncilTable.tableMeshes[i] == testActor)
		{
			return true;
		}
	}

	return false;
}

function bool CheckIfActorIsCouncillor(Actor testActor, optional out CouncillorData councillorInfo)
{
	local int i, j;

	for(i = 0; i < mCouncilMembers.Length; ++i)
	{
		for(j = 0; j < mCouncilMembers[i].characterPoses.Length; ++j)
		{
			if(mCouncilMembers[i].characterPoses[j] == testActor)
			{
				councillorInfo = mCouncilMembers[i];

				return true;
			}
		}
	}

	return false;
}

// Handles entering to CouncilView (when player presses Campaign button in MainMenu)
function OnEnterCouncil()
{
	SetCouncilState(CS_CouncilView);
}

function H7CampaignDefinition GetCurrentCampaign()
{
	if(class'H7AdventureController'.static.GetInstance() != none)
	{
		return class'H7AdventureController'.static.GetInstance().GetCampaign();
	}
	if(class'H7TransitionData'.static.GetInstance() != none)
	{
		return class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef;
	}
	;
	return none;
}

function StartFirstMapOfCurrentCampaign()
{
	local CampaignProgress currentCampaignData;

	currentCampaignData = class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign();

	class'H7ReplicationInfo'.static.GetInstance().StartMap(currentCampaignData.CampaignRef.GetFirstMap());
}


function bool HasStateChanged()
{
	return mPreviousCouncilState != mCurrentCouncilState;
}

// Returns center position in WS for passed actor (based on all components bounding box)
function Vector GetCenterOfBB(Actor testActor)
{
	local Vector calculatedPosition;
	local Box boundingBox;

	testActor.GetComponentsBoundingBox(boundingBox);

	if(boundingBox.IsValid > 0)
	{
		calculatedPosition = (boundingBox.Min + boundingBox.Max) * 0.5f;
	}
	
	return calculatedPosition;
}
//@TODO: Find better way then idiotc functions with switches... maybe prebuild list with CouncilLayerData structs/class ?
function name DetermineNextState()
{
	

	switch( mCurrentCouncilState )
	{
		case CS_MainMenu:
			return 'StateMainMenu';
		break;

		case CS_CouncilView:
			return 'StateCouncilView';
		break;

		case CS_CouncillorView:
			return 'StateCouncillorView';
		break;

		case CS_CampaignView:
			return 'StateCampaignView';
		break;
	}

	// Add handling for state CS_Invalid and system for recovery
	return 'None';
}

// Bit hardcoded, layer for each state so we can determin direction we are moving on tree
function int GetCouncilStateLayer(ECouncilState testState)
{
	switch(testState)
	{
		case CS_MainMenu:
			return 0;
		break;

		case CS_CouncilView:
			return 1;
		break;

		case CS_CouncillorView:
			return 2;
		break;

		case CS_CampaignView:
			return 2;
		break;
	}

	return -1;
}

function bool IsTransitioningDown()
{
	// We go down
	if(GetCouncilStateLayer(mPreviousCouncilState) < GetCouncilStateLayer(mCurrentCouncilState)) 
	{
		return true;
	}
	// We go up
	else 
	{
		return false;
	}
	
}

// CS_CouncillorView -> CS_CouncilView -> CS_MainMenu
// what is CS_CampaignView ???
function TransitionBack()
{
	local CouncillorData empty;
	switch(mCurrentCouncilState)
	{
		case CS_CouncillorView: // on the face
			// councillor still needed to play back-matinee
			//SetCurrentCouncillorInfo(empty); // reset current councilor to none
			SetCouncilState(CS_CouncilView);
			return;
		break;

		case CS_CouncilView: // on the table and councilor
			SetCurrentCouncillorInfo(empty); // reset current councilor to none
			SetCouncilState(CS_MainMenu);
			return;
		break;

		case CS_CampaignView: // on the table
			SetCouncilState(CS_CouncilView);
		break;

		case CS_MainMenu:
			return;
		break;
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// GUI
///////////////////////////////////////////////////////////////////////////////////////////////////

function SetGUIState(ECouncilState state,bool entering)
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().ShowHUD();
	switch( state )
	{
		case CS_Invalid:
			break;
		case CS_MainMenu:
			if(entering)
			{
				//class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetMainMenu().Reset();
				//class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetMainMenu().FadeIn();
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetMainMenu().SetVisibleSave(true);
			}
			else
			{
				// fades out in flash
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetMainMenu().SetVisibleSave(false);
			}
			break;
		case CS_CouncilView:
			if(!entering) 
			{
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetCouncilorTooltip().SetVisibleSave(false);
			}
			class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetBackButton().SetVisibleSave(entering);
			if(entering && class'H7PlayerProfile'.static.GetInstance().ShouldDisplayAdvice())
			{
				class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup("PU_CAMPAIGN_ADVICE","OK");
			}
			break;
		case CS_CouncillorView:
			class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetCouncilorWindow().SetVisibleSave(entering);
			if(entering)
			{
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().InitCouncilorWindow(GetCurrentCouncillorCampaign(),false);
			}
			else
			{
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetCouncilorWindow().Reset();
			}
			class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetBackButton().SetVisibleSave(entering);
			break;
		case CS_CampaignView:
			if(entering)
			{
				class'H7PlayerController'.static.GetPlayerController().GetHUD().GetDialogCntl().InitMapGUI();
			}
			else
			{
				class'H7PlayerController'.static.GetPlayerController().GetHUD().GetDialogCntl().HideMapGUI();
			}
			break;
	}	
}

// entering mCurrentCouncilState
function EnableHUD()
{
	SetGUIState(mCurrentCouncilState,true);
}

// leaving mPreviousCouncilState
function DisableHUD()
{
	SetGUIState(mPreviousCouncilState,false);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

function SwitchLayerForCouncil(name layerName, bool showLayer)
{
	local int i, j;

	for(i = 0; i < mCouncilMembers.Length; ++i)
	{
		for(j = 0; j < mCouncilMembers[i].characterPoses.Length; ++j)
		{
			if(mCouncilMembers[i].characterPoses[j].Layer == layerName)
			{
				mCouncilMembers[i].characterPoses[j].SetHidden(!showLayer);
			}
		}
	}
}

function CouncillorData GetCouncilorUnderMouse()
{
	local Actor nowActorUnderMouse;
	local CouncillorData emptyInfo,councillorInfo;
	local bool isCouncilor;
	
	nowActorUnderMouse = H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()).GetCurrentActorUnderMouse();
	if(nowActorUnderMouse != none)
	{
		// analyse actor
		if(mLastActorUnderMouse != nowActorUnderMouse)
		{
			// analyse this new actor:
			isCouncilor = CheckIfActorIsCouncillor(nowActorUnderMouse , councillorInfo);
			if(isCouncilor)
			{
				HandleSelectionEffect(mLastActorUnderMouse, false);
				HandleSelectionEffect(nowActorUnderMouse, true);

				mLastConcillorUnderMouse = councillorInfo;
				mLastActorUnderMouse = nowActorUnderMouse;
			}
			else
			{
				HandleSelectionEffect(mLastActorUnderMouse, false);

				mLastActorUnderMouse = nowActorUnderMouse;
				mLastConcillorUnderMouse = emptyInfo;
			}
		}
	}
	else
	{
		HandleSelectionEffect(mLastActorUnderMouse, false);

		mLastActorUnderMouse = nowActorUnderMouse;
		mLastConcillorUnderMouse = emptyInfo;
	}	
	return mLastConcillorUnderMouse;
}

// Handles enabling/disabling of selection effect on actor
function HandleSelectionEffect(Actor affectedActor, bool enableEffect)
{
	local CouncillorData councillorInfo;

	if(affectedActor != none)
	{
		if(StaticMeshActor(affectedActor) != none && StaticMeshActor(affectedActor).StaticMeshComponent.bOutlined != enableEffect)
		{
			if(enableEffect && CheckIfActorIsCouncillor(affectedActor, councillorInfo))
			{
				StaticMeshActor(affectedActor).StaticMeshComponent.SetOutlineColor(councillorInfo.councillorCampaign.GetFaction().GetColor());
			}
		
			StaticMeshActor(affectedActor).StaticMeshComponent.SetOutlined(enableEffect);
		}
		else if(InterpActor(affectedActor) != none && InterpActor(affectedActor).StaticMeshComponent.bOutlined != enableEffect)
		{
			if(enableEffect && CheckIfActorIsCouncillor(affectedActor, councillorInfo))
			{
				InterpActor(affectedActor).StaticMeshComponent.SetOutlineColor(councillorInfo.councillorCampaign.GetFaction().GetColor());
			}
		
			InterpActor(affectedActor).StaticMeshComponent.SetOutlined(enableEffect);
		}
		
	}

	
}

//=============================================================================
// Council States
//=============================================================================

//WorldInfo.AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 0, 0, 255) , "Main Menu waiting for EnterCouncil" );

state BaseCouncilState
{
	local bool hasSetView;

	local vector resultPos;
	local rotator resultRot;
	local float resultFOV;

	event BeginState(name previousStateName)
	{
		mStateHasFirstTick = false;
		
		hasSetView = true;
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		if(!mMatineeManager.IsMatineePlaying() && mMatineeManager.GetMonitoredMatinee() == none)
		{
			// State ticks first time without matinee playing
			if(!mStateHasFirstTick && hasSetView)
			{
				EnableHUD();
				mStateHasLastTick = false;
				mStateHasFirstTick = true;
				mWaitingForStateChange = false;
				hasSetView = false;
			}
		
			// Matinee is not playing, and somebody changed current state
			if(HasStateChanged() )
			{	
				GotoState(DetermineNextState());
			}
		}
	}

	event EndState(name nextStateName)
	{
		mStateHasLastTick = true;

		DisableHUD();
	}
}

// # intitial state
auto state StateMainMenu extends BaseCouncilState
{
	
	event BeginState(name previousStateName)
	{
		super.BeginState(previousStateName);

		if(!IsTransitioningDown())
		{
			mMatineeManager.PlayMatineeByObjComment(mIntroMatinee, true);
		}

		SetCouncilState(CS_MainMenu);

		if(class'H7TransitionData'.static.GetInstance() != none && class'H7TransitionData'.static.GetInstance().GetPendingMatinee() != "")
		{
			OverrideCouncilStartState(CS_CouncilView);
			OverrideNextTransition(class'H7TransitionData'.static.GetInstance().GetPendingMatinee());
			class'H7TransitionData'.static.GetInstance().SetPendingMatinee("");
		}


		if(mOverrideCouncilState != CS_Invalid && mOverrideCouncilState != CS_MainMenu)
		{
			SetCouncilState(mOverrideCouncilState);
			mOverrideCouncilState = CS_Invalid;
		}
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		if(!hasSetView && mMatineeManager.GetMonitoredMatinee() == none)
		{
			GetMatineeManager().CaptureMatineeAtPos(GetIntroMatinee(), resultPos, resultRot, resultFOV, 0.0f, false);

			GetCouncilCamera().SetCameraTransform(resultPos, resultRot, resultFOV);

			hasSetView = true;
		}

	}

	event EndState(name nextStateName)
	{
		super.EndState(nextStateName);
	}
}

state StateCouncilView extends BaseCouncilState
{
	event BeginState(name previousStateName)
	{
		super.BeginState(previousStateName);
		
		if(mOverrideTransitionMatinee)
		{
			GetMatineeManager().PlayMatineeByObjComment(mOverrideMatineeName);

			mStateHasFirstTick = false;
			hasSetView = true;

			// This should be propably moved out of here if we use override for more then end campaign matinee
			mShouldPlayerProgressMatinee = true;
		}
		else
		{
			if(IsTransitioningDown())
			{
				mMatineeManager.PlayIntroMatinee();
			}
			else
			{
				if(mPreviousCouncilState == CS_CouncillorView)
				{
					mMatineeManager.PlayMatineeByObjComment(mCurrentConcillor.matineeName, true);

					mCurrentConcillor.characterPoses.Length = 0;
					mCurrentConcillor.councillorCampaign = none;
					mCurrentConcillor.matineeName = "";
				}
				else if(mPreviousCouncilState == CS_CampaignView)
				{
					mMatineeManager.PlayMatineeByObjComment(mCouncilTable.matineeName, true);
				}
			}
		}


		SetCouncilState(CS_CouncilView);
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		// Set view for this state
		if(!hasSetView && mMatineeManager.GetMonitoredMatinee() == none)
		{
			if(mOverrideTransitionMatinee)
			{
				mOverrideMatineeName = "";
				mOverrideTransitionMatinee = false;
			}

			if(mShouldPlayerProgressMatinee)
			{
				mMatineeManager.HandleCampaignCompletion();
				HandleSelectionEffect(mLastActorUnderMouse, false);

				if(GetMapManager() != none && GetMapManager().GetContinentMesh() != none)
				{
					GetMapManager().GetContinentMesh().StaticMeshComponent.SetOutlined(false);
				}
				mShouldPlayerProgressMatinee = false;
			}
			else
			{
				GetMatineeManager().CaptureMatineeAtPos(GetIntroMatinee(), resultPos, resultRot, resultFOV, 0.0f, true);

			

				GetCouncilCamera().SetCameraTransform(resultPos, resultRot, resultFOV);

				hasSetView = true;
			}
		}


		if(!mMatineeManager.IsMatineePlaying() && !mStateHasLastTick)
		{
			if(GetCouncilorUnderMouse().councillorCampaign != none)
			{
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetCouncilorTooltip().Update(GetCouncilorUnderMouse().councillorCampaign);
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetCouncilorTooltip().SetVisibleSave(true);
			}
			else
			{
				class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetMainMenuCntl().GetCouncilorTooltip().SetVisibleSave(false);
			}
		}

	}

	event EndState(name nextStateName)
	{
		super.EndState(nextStateName);

		HandleSelectionEffect(mLastActorUnderMouse, false);

		if(GetMapManager() != none && GetMapManager().GetContinentMesh() != none)
		{
			GetMapManager().GetContinentMesh().StaticMeshComponent.SetOutlined(false);
		}
	}
}

state StateCouncillorView extends BaseCouncilState
{
	event BeginState(name previousStateName)
	{   
		super.BeginState(previousStateName);

		if(IsTransitioningDown())
		{
			mMatineeManager.PlayMatineeByObjComment(mCurrentConcillor.matineeName);
		}
		else
		{
			
		}


		SetCouncilState(CS_CouncillorView);
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		// Set view for this state
		if(!hasSetView && mMatineeManager.GetMonitoredMatinee() == none)
		{
			GetMatineeManager().CaptureMatineeAtPos(mCurrentConcillor.matineeName, resultPos, resultRot, resultFOV, 0.0f, true);

			GetCouncilCamera().SetCameraTransform(resultPos, resultRot, resultFOV);

			hasSetView = true;
		}

		// @TODO: Move it to camera logic
		//if(!mMatineeManager.IsMatineePlaying() )
		//{
		//	if(GetCouncilCamera() != none )
		//	{
		//		GetCouncilCamera().ActivateMatineeTransform();
		//	}
		//}
	}

	event EndState(name nextStateName)
	{
		super.EndState(nextStateName);
	}
}

state StateCampaignView extends BaseCouncilState
{
	event BeginState(name previousStateName)
	{
		super.BeginState(previousStateName);

		if(IsTransitioningDown())
		{
			mMatineeManager.PlayMatineeByObjComment(mCouncilTable.matineeName);
		}
		else
		{
			
		}

		SetCouncilState(CS_CampaignView);
	}

	event Tick(float deltaTime)
	{
		super.Tick(deltaTime);

		if(!hasSetView && mMatineeManager.GetMonitoredMatinee() == none)
		{
			GetMatineeManager().CaptureMatineeAtPos(mCouncilTable.matineeName, resultPos, resultRot, resultFOV, 0.0f, true);

			GetCouncilCamera().SetCameraTransform(resultPos, resultRot, resultFOV);

			hasSetView = true;

			class'H7Camera'.static.GetInstance().UseCameraCouncilMap();
			mMapManager.ActivateMap();
		}
	}

	event EndState(name nextStateName)
	{
		mMapManager.DeactivateMap();
		class'H7Camera'.static.GetInstance().UseCameraCouncil();

		super.EndState(nextStateName);
	}
}

