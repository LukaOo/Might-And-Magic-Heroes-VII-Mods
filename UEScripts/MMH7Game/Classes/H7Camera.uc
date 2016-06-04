//=============================================================================
// H7Camera
//
// Camera class which handles the camera position. The camera has two modes
// depending on the platform that the game is running on. The camera uses a 
// interpolating method; so that movement of the camera is always fluid.
//
// It uses a fixed height birds eye view. The player is able to move
// the camera by using the arrow keys and when the mouse is on the edge of the 
// screen. The player can also go straight back to their hero by using a 
// console command, and lock onto their hero by double tapping the console
// command. 
//
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Camera extends Camera
	dependson(H7StructsAndEnumsNative)
	dependson(H7CombatMapInfo)
	dependson(H7AdventureMapInfo)
	config(Game)
	native;

const CAMERA_GROUND_CLIPPING_TRESHHOLD = 500.f;

// view reference point (this one is calculated within the UpdateViewTarget() function)
var protected Vector	TargetVRP[ECameraMode.EnumCount];
var protected Vector	CurrentVRP[ECameraMode.EnumCount];
var protected Rotator	TargetRotation[ECameraMode.EnumCount];
var protected Rotator	CurrentRotation[ECameraMode.EnumCount];
var protected float		TargetViewingDistance[ECameraMode.EnumCount];
var protected Vector	DefaultGridCenter[ECameraMode.EnumCount];
var protected float     BaseZ[ECameraMode.EnumCount];
var protected int	    lastGridID[ECameraMode.EnumCount];
var protected int       IsInitialized[ECameraMode.EnumCount];

// Camera properties
var protected H7CameraProperties CameraProperties[ECameraMode.EnumCount];
var protected const H7CameraProperties DefaultTownCameraProperties;
var protected H7CameraProperties RetroModeAdvCameraProperties;
var protected H7CameraProperties RetroModeCombatCameraProperties;
var protected config String CustomAdventureCameraProperties;
var protected config String CustomCombatCameraProperties;
var protected int		mActiveCameraIdx;
// Camera focus parameters
var protected int       mIsFollowing[ECameraMode.EnumCount];
var protected Actor     mToFocus[ECameraMode.EnumCount];
var protected bool      mCameraLocked;
var protected bool      mCameraLockAffectsFocusCamera;
var protected bool      mIsInCameraActionMode;
var protected bool      mOverridenFOV;
var protected float     mCameraPanYOffset;
var protected float     mCameraPanXOffset;
var protected float     mCameraPanYOffsetCloseZoom;
var protected float     mCameraMaxDistanceCalculated;

var(CameraAnim) protected CameraAnim    mBattleStartAnim<DisplayName=Battle Start Animation>;
var protected CameraAnimInst            mBSAInst;
var protected float                     mCameraMaxDistanceCache;
var protected float                     mCurrentGridBorderHorizontalSize;
var protected float                     mCurrentGridBorderVerticalSize;
var protected float                     mGridBorderVerticalSize;
var protected float                     mGridBorderHorizontalSize;

var protected float                     mTileCheckTargetTime;
var protected Name                      mRefTileDisplayName;
var protected bool                      mChangeTileType;

var protected Vector                    VRPRef;
var protected float                     mDeltaTimeDelay; // for avoiding first-tick bullshit from input

var protectedwrite float                mLastPannedDistance;
var protectedwrite float                mLastRotatedAngle;

// Council
var protected Rotator mOriginalRotation;
var protected Vector mOriginalPosition;
var protected float mOriginalFOV;

var protected bool mMatineeActive;

var protected bool mCinematicListenerEnabled;

var protected DynamicCameraActor mTreasureCam;


function Actor GetCurrentFocusActor()         { return mToFocus[mActiveCameraIdx];}
function UseCameraCombat()              { mActiveCameraIdx=CAM_COMBAT; Reset(); }
function UseCameraDeployment()          { mActiveCameraIdx=CAM_COMBAT_DEPLOYMENT; Reset(); }
function UseCameraBattleStart()         { mActiveCameraIdx=CAM_COMBAT_START; Reset(); StartBattleCamera(); }
function UseCameraAdventure()           { mActiveCameraIdx=CAM_ADVENTURE; Reset(); }
function UseCameraCouncil()             { mActiveCameraIdx=CAM_COUNCIL; Reset(); }
function UseCameraCouncilMap()          { mActiveCameraIdx=CAM_COUNCIL_MAP; Reset(); }

event H7CameraProperties GetActiveProperties() { return CameraProperties[mActiveCameraIdx]; }
function int                GetActiveCameraMode() { return mActiveCameraIdx; }

function bool               IsFollowing()         { return mIsFollowing[mActiveCameraIdx] == 1 ? true : false; }

static function H7Camera GetInstance() { return H7Camera( class'H7PlayerController'.static.GetPlayerController().PlayerCamera ); }

event Rotator GetCurrentRotation() {	return CurrentRotation[mActiveCameraIdx]; }
function Rotator GetTargetRotation()  { return TargetRotation[mActiveCameraIdx]; }
function SetTargetRotation(Rotator value) {	TargetRotation[mActiveCameraIdx] = value; }
function SetCurrentRotation(Rotator value) { CurrentRotation[mActiveCameraIdx] = value; }
function float GetCurrentRotationAngle() { return CurrentRotation[mActiveCameraIdx].Yaw; }
function float GetCurrentPitchAngle() {	return CurrentRotation[mActiveCameraIdx].Pitch; }
function float GetDefaultRotationAngle() { return CameraProperties[mActiveCameraIdx].Rotation.Yaw; }
function Vector GetDefaultGridCenter() { return DefaultGridCenter[mActiveCameraIdx]; }

event float GetTargetViewingDistance() { return TargetViewingDistance[mActiveCameraIdx]; }
function SetTargetViewingDistance(float viewingDistance) { TargetViewingDistance[mActiveCameraIdx] = viewingDistance; }

function SetTargetVRP( Vector vrp ) { TargetVRP[mActiveCameraIdx]=vrp; mToFocus[mActiveCameraIdx] = none; mIsFollowing[mActiveCameraIdx] = 0; }
function Vector GetTargetVRP() { return TargetVRP[mActiveCameraIdx]; }

function SetIsInCameraActionMode(bool value) {mIsInCameraActionMode = value;}

function SetOverridenFOV(bool value) { mOverridenFOV = value; }
function bool GetOverridenFOV() { return mOverridenFOV; }

function SetTreasureCam(DynamicCameraActor newCam) { mTreasureCam = newCam; }
function DynamicCameraActor GetTreasureCam() { return mTreasureCam; }

function SetDeltaDelay( float delay) { mDeltaTimeDelay = delay; }

function ResetCurrentViewingDistance()
{
	TargetViewingDistance[mActiveCameraIdx] = CalculateInitialViewingDistance();
	TargetViewingDistance[mActiveCameraIdx] = FClamp( TargetViewingDistance[mActiveCameraIdx], CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, CameraProperties[mActiveCameraIdx].ViewDistanceMaximum );
}

function SetCameraTransform(vector newPosition, rotator newRotation, optional float newFOV = 0.0f)
{
	mOriginalRotation = newRotation;
	mOriginalPosition = newPosition;
	if(newFOV != 0.0f)
	{
		mOriginalFOV = newFOV;
	}
}


function SetActiveProperties( H7CameraProperties camProperties ) 
{ 
	CameraProperties[mActiveCameraIdx] = camProperties; 

	//reset rotation if need
	if ( TargetRotation[mActiveCameraIdx] != camProperties.Rotation )
	{
		TargetRotation[mActiveCameraIdx] = camProperties.Rotation;
		CurrentRotation[mActiveCameraIdx] = camProperties.Rotation;
	}

	//reset viewing distance if need
	TargetViewingDistance[mActiveCameraIdx] = CalculateInitialViewingDistance();
	TargetViewingDistance[mActiveCameraIdx] = FClamp( TargetViewingDistance[mActiveCameraIdx], camProperties.ViewDistanceMinimum, camProperties.ViewDistanceMaximum );

	Reset();
}

function UseCameraTown( H7CameraProperties camProperties )    
{   
	CameraProperties[CAM_TOWN] = camProperties != none ? camProperties : DefaultTownCameraProperties;
	mActiveCameraIdx=CAM_TOWN;      
	Reset(); 
}

function SetCinematicListenerEnabled(bool val)
{
	mCinematicListenerEnabled = val;
}

function bool IsMatineeControlled()
{
	return mMatineeActive;
}

function ActivateMatineeTransform()
{
	SetCameraLocation(mOriginalPosition);
	SetCameraRotation(mOriginalRotation);
}

function ForceInitialisation()
{
	IsInitialized[CAM_COMBAT]=0;
	IsInitialized[CAM_COMBAT_DEPLOYMENT]=0;
	IsInitialized[CAM_COMBAT_START]=0;
	IsInitialized[CAM_ADVENTURE]=0;
	IsInitialized[CAM_TOWN]=0;
	IsInitialized[CAM_COUNCIL]=0;
	IsInitialized[CAM_COUNCIL_MAP]=0;
}

function ForceReInitialisation(int CamIdx)
{
	local H7AdventureController advCntl;
	switch(CamIdx)
	{
	case 0:
		IsInitialized[CAM_COMBAT]=0;
		Reset();
		break;
	case 1: 
		IsInitialized[CAM_COMBAT_DEPLOYMENT]=0;
		Reset();
		break;
	case 3: 
		IsInitialized[CAM_ADVENTURE]=0;
		Reset();
		advCntl = class'H7AdventureController'.static.GetInstance();
		if( advCntl.GetCurrentPlayer() != advCntl.GetLocalPlayer() )
		{
			SetFocusActor(advCntl.GetLocalPlayer().GetLastSelectedArmy(),,,true);
		}
		else
		{
			SetFocusActor(advCntl.GetSelectedArmy(),,,true);
		}
		break;
	}
}

// set the default values of the camera
function Reset( )
{
	local H7CombatMapGridController combatGrid;
	local H7AdventureGridManager	adventureGrid;
	local Vector					CameraPosition;
	local H7CombatArmy              combatArmy;
	local H7CameraProperties        customAdvCam, customComCam;
	local bool                      useRetroCam;

	mIsInCameraActionMode = false;
	mDeltaTimeDelay = 0.0f;
	mCameraLocked = false;
	mOverridenFOV = false;
	combatGrid = class'H7CombatMapGridController'.static.GetInstance();
	adventureGrid = class'H7AdventureGridManager'.static.GetInstance();
	;
	;

	if(mActiveCameraIdx == CAM_COUNCIL || mActiveCameraIdx == CAM_COUNCIL_MAP)
	{
		SetCameraEnsureAspectRatio(true);

		if (mActiveCameraIdx == CAM_COUNCIL)
		{
			// We dont want anything else, camera position etc. is captured from matinee
			return;
		}

		if(class'H7CouncilMapManager'.static.GetInstance() != none)
		{
			mOriginalPosition = class'H7CouncilMapManager'.static.GetInstance().GetMapCamera().Location;
			mOriginalRotation = class'H7CouncilMapManager'.static.GetInstance().GetMapCamera().Rotation;

			SetCameraLocation(mOriginalPosition);
			SetCameraRotation(mOriginalRotation);

			DefaultGridCenter[mActiveCameraIdx].X = CameraProperties[mActiveCameraIdx].PanXOffset;
			DefaultGridCenter[mActiveCameraIdx].Y = CameraProperties[mActiveCameraIdx].PanYOffset;
			DefaultGridCenter[mActiveCameraIdx].Z = CameraProperties[mActiveCameraIdx].PanZOffset;

			TargetVRP[mActiveCameraIdx]  = DefaultGridCenter[mActiveCameraIdx]; 
			CurrentVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx];
			BaseZ[mActiveCameraIdx] = TargetVRP[mActiveCameraIdx].Z;

			TargetViewingDistance[mActiveCameraIdx]  = CalculateInitialViewingDistance();

			mDeltaTimeDelay = 1.0f; // we want the next calculation to go through guarenteed!
			//IsInitialized[mActiveCameraIdx] = 1;
		}

		return;
	}
	else
	{
		SetCameraEnsureAspectRatio(false);
	}

	// override the camera with 'retro' archetype for pixellated mode
	useRetroCam = class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().mUsePixellated;
	if (useRetroCam)
	{
		CameraProperties[CAM_ADVENTURE]=RetroModeAdvCameraProperties;
		CameraProperties[CAM_COMBAT]=RetroModeCombatCameraProperties;
	}
	else	
	{
		CameraProperties[CAM_ADVENTURE]=self.default.CameraProperties[CAM_ADVENTURE];
		CameraProperties[CAM_COMBAT]=self.default.CameraProperties[CAM_COMBAT];
	}

	// check for a modded adventuremap camera from the config
	if (CustomAdventureCameraProperties != "")
	{
		;
		customAdvCam = H7CameraProperties(DynamicLoadObject(CustomAdventureCameraProperties, class'H7CameraProperties', true));
		if (customAdvCam != None)
		{
			;
			CameraProperties[CAM_ADVENTURE]=customAdvCam;
		}
	}
	// check for a modded combatmap camera from the config
	if (CustomCombatCameraProperties != "")
	{
		;
		customComCam = H7CameraProperties(DynamicLoadObject(CustomCombatCameraProperties, class'H7CameraProperties', true));
		if (customComCam != None)
		{
			;
			CameraProperties[CAM_COMBAT]=customComCam;
		}
	}

	// don't reset the position/rotation/zoom for adventure map
	if( IsInitialized[mActiveCameraIdx] == 1 && mActiveCameraIdx == CAM_ADVENTURE && adventureGrid != none )
	{
		CameraPosition = CurrentVRP[mActiveCameraIdx] - Vector(CurrentRotation[mActiveCameraIdx]) * TargetViewingDistance[mActiveCameraIdx];
		if(class'H7AdventureController'.static.GetInstance() != none && !class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
		{
			SetCameraRotation(CurrentRotation[mActiveCameraIdx]);
			SetCameraLocation(CameraPosition);
			SetFOV(CameraProperties[mActiveCameraIdx].FieldOfView);
		}
		
		lastGridID[mActiveCameraIdx] = adventureGrid.GetClosestGridToPosition(CurrentVRP[mActiveCameraIdx]).GetIndex();
		
		return;
	}

	mIsFollowing[mActiveCameraIdx] = 0;
	mToFocus[mActiveCameraIdx] = none;

	if( ( mActiveCameraIdx == CAM_COMBAT || mActiveCameraIdx == CAM_COMBAT_DEPLOYMENT || mActiveCameraIdx == CAM_COMBAT_START ) && combatGrid != none )
	{

		TargetRotation[mActiveCameraIdx] = CameraProperties[mActiveCameraIdx].Rotation;
		CurrentRotation[mActiveCameraIdx] = CameraProperties[mActiveCameraIdx].Rotation;

		//CurrentRotation[mActiveCameraIdx] = CameraProperties[mActiveCameraIdx].Rotation;
		SetFOV(CameraProperties[mActiveCameraIdx].FieldOfView);
		TargetViewingDistance[mActiveCameraIdx] = AdjustCombatViewingDistance(CalculateInitialViewingDistance());

		mGridBorderHorizontalSize = CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin;
		mGridBorderVerticalSize = CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin;
		AdjustCombatBorderGridSize();
		TargetViewingDistance[mActiveCameraIdx] = FClamp( TargetViewingDistance[mActiveCameraIdx] + mCameraMaxDistanceCache, CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, (CameraProperties[mActiveCameraIdx].ViewDistanceMaximum + mCameraMaxDistanceCache) );

		mCameraPanXOffset = CameraProperties[mActiveCameraIdx].PanXOffset;
		mCameraPanYOffset = AdjustCombatPanYOffset(CameraProperties[mActiveCameraIdx].PanYOffset);
		mCameraPanYOffsetCloseZoom = AdjustCombatPanYOffset(CameraProperties[mActiveCameraIdx].PanYOffsetCloseZoom);

		combatArmy = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy();

		if(mActiveCameraIdx != CAM_COMBAT_DEPLOYMENT || combatArmy == none )
		{
			DefaultGridCenter[mActiveCameraIdx] = combatGrid.GetCenter();

			DefaultGridCenter[mActiveCameraIdx].Y += mCameraPanYOffset;
			DefaultGridCenter[mActiveCameraIdx].Z += CameraProperties[mActiveCameraIdx].PanZOffset;
			DefaultGridCenter[mActiveCameraIdx].X += mCameraPanXOffset;
		}
		else
		{
			if(combatArmy != none && combatArmy.IsAttacker())
			{
				DefaultGridCenter[mActiveCameraIdx] = combatGrid.GetDeploymentZoneCenter(0.8f);
				CurrentRotation[mActiveCameraIdx].Yaw = CurrentRotation[mActiveCameraIdx].Yaw  + (90.f * DegToUnrRot);
				TargetRotation[mActiveCameraIdx].Yaw = CurrentRotation[mActiveCameraIdx].Yaw  + (90.f * DegToUnrRot);
			}
			else
			{
				DefaultGridCenter[mActiveCameraIdx] = combatGrid.GetDeploymentZoneCenter(0.2f);
				CurrentRotation[mActiveCameraIdx].Yaw = CurrentRotation[mActiveCameraIdx].Yaw  - (90.f * DegToUnrRot);
				TargetRotation[mActiveCameraIdx].Yaw = CurrentRotation[mActiveCameraIdx].Yaw  - (90.f * DegToUnrRot);
			}

			TargetVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx]; 
			CurrentVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx];

			;
		}
		
		TargetVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx];
		CurrentVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx];
		BaseZ[mActiveCameraIdx] = TargetVRP[mActiveCameraIdx].Z;

		CameraPosition = CurrentVRP[mActiveCameraIdx] - Vector(CurrentRotation[mActiveCameraIdx]) * TargetViewingDistance[mActiveCameraIdx];

		SetCameraRotation(CurrentRotation[mActiveCameraIdx]);
		SetCameraLocation(CameraPosition);
	}
	else if( mActiveCameraIdx == CAM_ADVENTURE && adventureGrid != none )
	{
		;
		
		TargetRotation[mActiveCameraIdx] = CameraProperties[mActiveCameraIdx].Rotation;
		CurrentRotation[mActiveCameraIdx] = CameraProperties[mActiveCameraIdx].Rotation;
		SetFOV(CameraProperties[mActiveCameraIdx].FieldOfView);
		TargetViewingDistance[mActiveCameraIdx] = CalculateInitialViewingDistance();
		TargetViewingDistance[mActiveCameraIdx] = FClamp( TargetViewingDistance[mActiveCameraIdx], CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, CameraProperties[mActiveCameraIdx].ViewDistanceMaximum );

		DefaultGridCenter[mActiveCameraIdx] = adventureGrid.GetCurrentGrid().GetCenter();
		DefaultGridCenter[mActiveCameraIdx].X += CameraProperties[mActiveCameraIdx].PanXOffset;
		DefaultGridCenter[mActiveCameraIdx].Y += CameraProperties[mActiveCameraIdx].PanYOffset;
		DefaultGridCenter[mActiveCameraIdx].Z += CameraProperties[mActiveCameraIdx].PanZOffset;

		TargetVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx]; 
		CurrentVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx];
		BaseZ[mActiveCameraIdx] = TargetVRP[mActiveCameraIdx].Z;

		CameraPosition = CurrentVRP[mActiveCameraIdx] - Vector(CurrentRotation[mActiveCameraIdx]) * TargetViewingDistance[mActiveCameraIdx];
		SetCameraRotation(CurrentRotation[mActiveCameraIdx]);
		SetCameraLocation(CameraPosition);

		lastGridID[mActiveCameraIdx] = adventureGrid.GetClosestGridToPosition(CurrentVRP[mActiveCameraIdx]).GetIndex();
	}
	else if ( mActiveCameraIdx == CAM_TOWN )
	{
		;
		// copy of the combat
		TargetRotation[mActiveCameraIdx]  = CameraProperties[mActiveCameraIdx].Rotation;
		CurrentRotation[mActiveCameraIdx] = CameraProperties[mActiveCameraIdx].Rotation;
		SetFOV(CameraProperties[mActiveCameraIdx].FieldOfView);
		TargetViewingDistance[mActiveCameraIdx] = CalculateInitialViewingDistance();
		// Do not use clamp here, or the zoom target will never be reached !
		//TargetViewingDistance = FClamp( TargetViewingDistance, CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, CameraProperties[mActiveCameraIdx].ViewDistanceMaximum );

		DefaultGridCenter[mActiveCameraIdx].X = CameraProperties[mActiveCameraIdx].PanXOffset;
		DefaultGridCenter[mActiveCameraIdx].Y = CameraProperties[mActiveCameraIdx].PanYOffset;
		DefaultGridCenter[mActiveCameraIdx].Z = CameraProperties[mActiveCameraIdx].PanZOffset;

		TargetVRP[mActiveCameraIdx]  = DefaultGridCenter[mActiveCameraIdx]; 
		CurrentVRP[mActiveCameraIdx] = DefaultGridCenter[mActiveCameraIdx];
		BaseZ[mActiveCameraIdx] = TargetVRP[mActiveCameraIdx].Z;

		mDeltaTimeDelay = 1.0f; // we want the next calculation to go through guarenteed!
	}
	else
	{
		;
	}
	if( mActiveCameraIdx != CAM_TOWN )
	{
		IsInitialized[mActiveCameraIdx] = 1;
	}
}

function SetCameraEnsureAspectRatio(bool isActive)
{
	self.bEnsureAspectRatio = isActive;
	if (isActive)
	{
		self.EnsuredAspectRatio = AspectRatio16x9; // We force 16x9 as safe area aspect ratio
	}
}

// calculates the initial viewing distance depending on the viewingDistance propertie (16x9), viewingDistance4x3 propertie and the current aspect ratio
function float CalculateInitialViewingDistance()
{
	local LocalPlayer localPlayer;
	local Vector2D viewportSize;
	local float aspectRatio, aspectRatioDelta, viewingDistanceDelta;

	if(CameraProperties[mActiveCameraIdx].ViewingDistance4x3 == 0)
	{
		return CameraProperties[mActiveCameraIdx].ViewingDistance;
	}

	localPlayer = class'H7PlayerController'.static.GetLocalPlayer();
	if(localPlayer!=None)
	{
		localPlayer.ViewportClient.GetViewportSize( viewportSize );
		aspectRatio = viewportSize.X / viewportSize.Y;
		aspectRatioDelta = (AspectRatio16x9 - aspectRatio) / (AspectRatio16x9 - AspectRatio4x3);
	}
	else
	{
		aspectRatio = 1024.0f / 768.0f;
		aspectRatioDelta = (AspectRatio16x9 - aspectRatio) / (AspectRatio16x9 - AspectRatio4x3);
	}
	viewingDistanceDelta = CameraProperties[mActiveCameraIdx].ViewingDistance - CameraProperties[mActiveCameraIdx].ViewingDistance4x3;

	return CameraProperties[mActiveCameraIdx].ViewingDistance - viewingDistanceDelta * aspectRatioDelta;
}

// adjusts viewing distance depending on the grid size
function float AdjustCombatViewingDistance(float viewingDistance)
{
	local int gridSizeX, gridSizeY;

	gridSizeX = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeX();
	gridSizeY = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeY();
	
	if(mActiveCameraIdx != CAM_COMBAT_DEPLOYMENT)
	{
		viewingDistance += (gridSizeX - CameraProperties[mActiveCameraIdx].BaseGridSize.X) * CameraProperties[mActiveCameraIdx].ViewingDistanceIncreasePerCell.X;
	}

	viewingDistance += (gridSizeY - CameraProperties[mActiveCameraIdx].BaseGridSize.Y) * CameraProperties[mActiveCameraIdx].ViewingDistanceIncreasePerCell.Y;

	if(viewingDistance > CameraProperties[mActiveCameraIdx].ViewDistanceMaximum)
	{
		mCameraMaxDistanceCache = (viewingDistance - CameraProperties[mActiveCameraIdx].ViewDistanceMaximum) + CameraProperties[mActiveCameraIdx].ViewDistanceMaximumCache;
		
		//Important for automated grid border size
		mCameraMaxDistanceCalculated = (CameraProperties[mActiveCameraIdx].ViewDistanceMaximum + mCameraMaxDistanceCache) - CameraProperties[mActiveCameraIdx].ViewDistanceMinimum ;
	}
	else
	{
		//Important for automated grid border size
		mCameraMaxDistanceCalculated = (CameraProperties[mActiveCameraIdx].ViewDistanceMaximum - CameraProperties[mActiveCameraIdx].ViewDistanceMinimum) + CameraProperties[mActiveCameraIdx].ViewDistanceMaximumCache;
	}

	return viewingDistance;
}

function AdjustCombatBorderGridSize()
{
	local int gridSizeX, gridSizeY;

	gridSizeX = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeX();
	gridSizeY = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeY();

	mGridBorderHorizontalSize += (gridSizeX - CameraProperties[mActiveCameraIdx].BaseGridSize.X) * CameraProperties[mActiveCameraIdx].BorderGridSizePerCell.X;
	mGridBorderVerticalSize += (gridSizeY - CameraProperties[mActiveCameraIdx].BaseGridSize.Y) * CameraProperties[mActiveCameraIdx].BorderGridSizePerCell.Y;

	if(mGridBorderHorizontalSize > CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMax)
	{
		mGridBorderHorizontalSize = CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMax;
	}

	if(mGridBorderVerticalSize > CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMax)
	{
		mGridBorderVerticalSize = CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMax;
	}

	if(mGridBorderHorizontalSize < CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin)
	{
		mGridBorderHorizontalSize = CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin;
	}

	if(mGridBorderVerticalSize < CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin)
	{
		mGridBorderVerticalSize = CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin;
	}
}

// adjusts PanYoffset depending on the grid size
function float AdjustCombatPanYOffset(float panYOffset)
{
	local int gridSizeX, gridSizeY;

	gridSizeX = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeX();
	gridSizeY = class'H7CombatMapGridController'.static.GetInstance().GetGridSizeY();

	panYOffset += (gridSizeX - CameraProperties[mActiveCameraIdx].BaseGridSize.X) * CameraProperties[mActiveCameraIdx].PanYOffsetPerCell.X;
	panYOffset += (gridSizeY - CameraProperties[mActiveCameraIdx].BaseGridSize.Y) * CameraProperties[mActiveCameraIdx].PanYOffsetPerCell.Y;

	return panYOffset;
}

function LockCamera(bool locked)
{
	mCameraLocked = locked;
}

function bool IsCameraLocked()
{
	return mCameraLocked;
}

function LockCameraPreventFocusActor(bool locked)
{
	mCameraLockAffectsFocusCamera = locked;
}

function StartBattleCamera()
{
	;
	class'H7PlayerController'.static.GetPlayerController().GetHud().ToggleHUD();
	mBSAInst = PlayCameraAnim(mBattleStartAnim);
	if(mBSAInst!=None)
	{
		mBSAInst.SetPlaySpace(CAPS_CameraLocal);
	}
	else
	{
		;
	}
}

function StopBattleCamera()
{
	;
	class'H7PlayerController'.static.GetPlayerController().GetHud().ToggleHUD();
	if( mBSAInst != None )
	{
		StopCameraAnim( mBSAInst, true );
	}
	mBSAInst = None;
}

function bool IsFinishedBattleCamera()
{
	return ( mBSAInst == None || mBSAInst.bFinished );
}


// get the current values for currentvrp
function Vector GetCurrentVRP()
{
	return CurrentVRP[mActiveCameraIdx];
}

function SetCurrentVRP( Vector vrp ) { CurrentVRP[mActiveCameraIdx] = vrp; }

/**
 * Sets an Actor to be focused by the camera. 
 * Can optionally be set to follow the actor until 
 * another Actor or "none" is passed as the argument.
 * 
 * @param		focusActor		What the camera should focus
 * @param       playerNumber    The player number for which player to focus the camera. 
 *                              -1 means all players
 * @param		isFollowing     Sets whether the camera focus constantly on the actor until actor is set to "none"
 * 
 */
function SetFocusActor( Actor focusActor, optional int playerNumber = -1, optional bool isFollowing = false, optional bool setInstant, optional bool isMoving )
{
	// don't focus on heroes if we are in a town screen! DERP. OR if the camera is locked for set focus
	if( mCameraLocked && mCameraLockAffectsFocusCamera ) return;
	if( mActiveCameraIdx == CAM_TOWN ) return;
	// don't focus armies of non local players
	if( playerNumber != -1 && playerNumber != class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
	{
		// follow the army moving if it is not hidden
		if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() || !isMoving || focusActor == none || focusActor.bHidden)
		{
			return;
		}
	}
	
	//Sets the camera position instant to the actor position
	if( setInstant )
	{
		CurrentVRP[mActiveCameraIdx] = focusActor.Location;
		TargetVRP[mActiveCameraIdx] = focusActor.Location;
	}

	mToFocus[mActiveCameraIdx] = focusActor;
	mIsFollowing[mActiveCameraIdx] = isFollowing ? 1 : 0;
}

function ClearFocusActor()
{
	SetFocusActor( none, -1, false );
}

function CalculateNewZoom( H7PlayerController InputController, float DeltaTimeAdjusted )
{	
	local float CameraDistance;	
	local float MouseWheel;

	if(mCameraLocked || mIsInCameraActionMode)
	{
		return;
	}

	MouseWheel = InputController.GetMouseWheel(DeltaTimeAdjusted);

	if( MouseWheel != 0 )
	{
		CameraDistance = TargetViewingDistance[mActiveCameraIdx] - MouseWheel * CameraProperties[mActiveCameraIdx].DollyMouseScrollVelocity * 0.3f;
	}
	else
	{
		CameraDistance = TargetViewingDistance[mActiveCameraIdx] + InputController.GetDolly() * CameraProperties[mActiveCameraIdx].DollyVelocity * 0.1f;
	}
//	TargetViewingDistance[mActiveCameraIdx] = Lerp( TargetViewingDistance[mActiveCameraIdx], CameraDistance, FClamp(CameraProperties[mActiveCameraIdx].DollyBlendSpeed * DeltaTimeAdjusted,0.0f,1.0f) );
	
	TargetViewingDistance[mActiveCameraIdx] = FInterpEaseInOut( TargetViewingDistance[mActiveCameraIdx], CameraDistance, FClamp(CameraProperties[mActiveCameraIdx].DollyBlendSpeed * DeltaTimeAdjusted * 0.4f,0.0f,1.0f), 0.2f );
	TargetViewingDistance[mActiveCameraIdx] = FClamp( TargetViewingDistance[mActiveCameraIdx], CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, (CameraProperties[mActiveCameraIdx].ViewDistanceMaximum + mCameraMaxDistanceCache) );
	// TODO something still goes beyond min/max somehwere, fix for now: set speed to 0 in the camera
	//`log_dui("target view distance:" @ TargetViewingDistance[mActiveCameraIdx]);
}

function Rotator CalculateNewRotation(H7PlayerController InputController)
{	
	local int RotLimit;
	local float PitchBlendAlpha;
	local float DistanceBlendRangeMin;
	local float DistanceBlendRangeMax;
	local float DistancePercent;
	local H7CombatMapGridController combatGrid;
	local Rotator lastRot;

	if(mIsInCameraActionMode)
	{
		return CurrentRotation[mActiveCameraIdx];
	}
	
	combatGrid = class'H7CombatMapGridController'.static.GetInstance();

	// make zoom pitch adaption
	DistanceBlendRangeMin = CameraProperties[mActiveCameraIdx].ViewDistanceMinimum;
	DistanceBlendRangeMax = Lerp( CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, (CameraProperties[mActiveCameraIdx].ViewDistanceMaximum + mCameraMaxDistanceCache), CameraProperties[mActiveCameraIdx].PitchBlendStart );
	
	if( combatGrid != None &&  mActiveCameraIdx != CAM_COMBAT_DEPLOYMENT)
	{
		DistancePercent = mCameraMaxDistanceCalculated / 100;
		PitchBlendAlpha = (TargetViewingDistance[mActiveCameraIdx] - CameraProperties[mActiveCameraIdx].ViewDistanceMinimum) / DistancePercent;
		PitchBlendAlpha /= 100;

		mCurrentGridBorderHorizontalSize = Lerp(mGridBorderHorizontalSize, CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMax, PitchBlendAlpha);
		mCurrentGridBorderVerticalSize = Lerp(mGridBorderVerticalSize,CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMax, PitchBlendAlpha);
	}

	if( TargetViewingDistance[mActiveCameraIdx] <= DistanceBlendRangeMax ) 
	{
		PitchBlendAlpha = (DistanceBlendRangeMax - DistanceBlendRangeMin) != 0.0f ? (TargetViewingDistance[mActiveCameraIdx] - DistanceBlendRangeMin) / (DistanceBlendRangeMax - DistanceBlendRangeMin) : 0.0f;
		TargetRotation[mActiveCameraIdx].Pitch = Lerp( class'H7Math'.static.ConvertDegreeToUnrealDegree( CameraProperties[mActiveCameraIdx].LowPitch ), CameraProperties[mActiveCameraIdx].Rotation.Pitch, PitchBlendAlpha );

		DefaultGridCenter[mActiveCameraIdx].Y = Lerp( mCameraPanYOffset, mCameraPanYOffsetCloseZoom, (1 - PitchBlendAlpha) );
	}
	else
	{
		PitchBlendAlpha = (DistanceBlendRangeMax - DistanceBlendRangeMin) != 0.0f ? (TargetViewingDistance[mActiveCameraIdx] - DistanceBlendRangeMax) / ((CameraProperties[mActiveCameraIdx].ViewDistanceMaximum + mCameraMaxDistanceCache) - DistanceBlendRangeMax) : 0.0f;
		TargetRotation[mActiveCameraIdx].Pitch = Lerp( CameraProperties[mActiveCameraIdx].Rotation.Pitch, class'H7Math'.static.ConvertDegreeToUnrealDegree( CameraProperties[mActiveCameraIdx].HighPitch ), PitchBlendAlpha );
		
		DefaultGridCenter[mActiveCameraIdx].Y = mCameraPanYOffset;
	}

	// calculate rotation request
	if(!mCameraLocked)
	{
		TargetRotation[mActiveCameraIdx].Yaw = CurrentRotation[mActiveCameraIdx].Yaw - InputController.GetRotation() * CameraProperties[mActiveCameraIdx].RotationVelocity;
	}

	// we skip limitation of rotation if limit are set greater-equal value of 180
	if( CameraProperties[mActiveCameraIdx].RotationLimit < 180.0f)
	{
		RotLimit = class'H7Math'.static.ConvertDegreeToUnrealDegree( CameraProperties[mActiveCameraIdx].RotationLimit );
		TargetRotation[mActiveCameraIdx].Yaw = Clamp( TargetRotation[mActiveCameraIdx].Yaw, CameraProperties[mActiveCameraIdx].Rotation.Yaw -  RotLimit,  CameraProperties[mActiveCameraIdx].Rotation.Yaw + RotLimit );
	}

	lastRot = CurrentRotation[mActiveCameraIdx];
	CurrentRotation[mActiveCameraIdx] = RLerp( CurrentRotation[mActiveCameraIdx], TargetRotation[mActiveCameraIdx],  FClamp( CameraProperties[mActiveCameraIdx].RotationBlendSpeed,0.0f,1.0f) , true );
	lastRot = lastRot - CurrentRotation[mActiveCameraIdx];
	mLastRotatedAngle = lastRot.Pitch + lastRot.Yaw + lastRot.Roll;

	return CurrentRotation[mActiveCameraIdx];
}

native function Vector CalculateNewPositionNative(H7PlayerController InputController, float DeltaTime);

function Vector CalculateNewPosition(H7PlayerController InputController, float DeltaTime) 
{	
	local Vector CameraDragVector, result;
	local Vector CameraPanningDir;
	local bool isPanning;
	local Matrix ViewMatrix;
	local H7CombatMapGridController combatGrid;
	local H7AdventureGridManager adventureGrid;
	local H7AdventureHero hero;
	local Vector lastPos;
	local float screenRatioCoef; // This will increase the distance based on the screen ratio. Usefull for ratio bigger than 16:9 to avoid distorted edges (due to high fov)

	combatGrid = class'H7CombatMapGridController'.static.GetInstance();
	adventureGrid = class'H7AdventureGridManager'.static.GetInstance();

	ViewMatrix = MakeRotationMatrix(CurrentRotation[mActiveCameraIdx]);

	if(!mCameraLocked && !mIsInCameraActionMode)
	{
		CameraPanningDir.X = InputController.GetPanningVertical();
		CameraPanningDir.Y = InputController.GetPanningHorizontal();

		CameraDragVector = InputController.PanningCameraMovement();

		isPanning = InputController.GetIsMousePanning();
		
		if(!isPanning)
		{
			VRPRef = TargetVRP[mActiveCameraIdx];
		}

		if(CameraDragVector.X != 0.f || CameraDragVector.Y != 0.f && isPanning)
		{
			CameraDragVector = TransformVector( ViewMatrix, CameraDragVector );
			CameraDragVector.Z = 0.0f;

			TargetVRP[mActiveCameraIdx] = VRPRef + CameraDragVector;
		}
	}

	CameraPanningDir = TransformVector( ViewMatrix, CameraPanningDir );
	CameraPanningDir.Z = 0.0f;

	// Reset the focus actor if there is panning input from player
	if( !mCameraLocked && (InputController.GetPanningHorizontal() != 0 || InputController.GetPanningVertical() != 0) || CameraDragVector.X != 0.f || CameraDragVector.Y != 0.f && isPanning)
	{
		mToFocus[mActiveCameraIdx] = none;
	}
	
	// Set target View Ref Point to focusable actor, if there is one
	if( mToFocus[mActiveCameraIdx] != none ) 
	{
		hero = H7AdventureHero( mToFocus[mActiveCameraIdx] );
		if( hero != none && ( hero.GetCell() == none || !hero.GetCell().GetGridOwner().GetFOWController().CheckExploredTile( class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber(), hero.GetCell().mPosition ) ) )
		{
			// no follow through fog
			mToFocus[mActiveCameraIdx] = none;
		}
		else
		{
 			TargetVRP[mActiveCameraIdx] = mToFocus[mActiveCameraIdx].Location;

			// Focus only once, if the camera is not supposed to follow
			if( mIsFollowing[mActiveCameraIdx] == 0 )
			{
				mToFocus[mActiveCameraIdx] = none;
			}	
		}
	}

	// update the default grid center in case that we moved to another grid
	if( adventureGrid != none && mActiveCameraIdx == CAM_ADVENTURE )
	{
		adventureGrid.SetCurrentGridByPos( TargetVRP[mActiveCameraIdx] );
		DefaultGridCenter[mActiveCameraIdx] = adventureGrid.GetCurrentGrid().GetCenter();
		DefaultGridCenter[mActiveCameraIdx].X += CameraProperties[mActiveCameraIdx].PanXOffset;
		DefaultGridCenter[mActiveCameraIdx].Y += CameraProperties[mActiveCameraIdx].PanYOffset;
		DefaultGridCenter[mActiveCameraIdx].Z += CameraProperties[mActiveCameraIdx].PanZOffset;
	}

	TargetVRP[mActiveCameraIdx] += (CameraProperties[mActiveCameraIdx].PanVelocity * CameraPanningDir * DeltaTime);
	if(!mIsInCameraActionMode)
	{
		if( combatGrid != None && mActiveCameraIdx != CAM_COMBAT_DEPLOYMENT )
		{
			TargetVRP[mActiveCameraIdx].X = FClamp( TargetVRP[mActiveCameraIdx].X, DefaultGridCenter[mActiveCameraIdx].X - combatGrid.GetGridSizeX() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) + mCurrentGridBorderHorizontalSize, DefaultGridCenter[mActiveCameraIdx].X + combatGrid.GetGridSizeX() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) - mCurrentGridBorderHorizontalSize );
			TargetVRP[mActiveCameraIdx].Y = FClamp( TargetVRP[mActiveCameraIdx].Y, DefaultGridCenter[mActiveCameraIdx].Y - combatGrid.GetGridSizeY() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) + mCurrentGridBorderVerticalSize, DefaultGridCenter[mActiveCameraIdx].Y + combatGrid.GetGridSizeY() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) - mCurrentGridBorderVerticalSize );
		}
		else if( combatGrid != None && mActiveCameraIdx == CAM_COMBAT_DEPLOYMENT )
		{
			TargetVRP[mActiveCameraIdx].X = FClamp( TargetVRP[mActiveCameraIdx].X, DefaultGridCenter[mActiveCameraIdx].X - (combatGrid.GetGridSizeX()/4) * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) + mCurrentGridBorderHorizontalSize, DefaultGridCenter[mActiveCameraIdx].X + (combatGrid.GetGridSizeX()/4) * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) - mCurrentGridBorderHorizontalSize );
			TargetVRP[mActiveCameraIdx].Y = FClamp( TargetVRP[mActiveCameraIdx].Y, DefaultGridCenter[mActiveCameraIdx].Y - combatGrid.GetGridSizeY() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) + mCurrentGridBorderVerticalSize, DefaultGridCenter[mActiveCameraIdx].Y + combatGrid.GetGridSizeY() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) - mCurrentGridBorderVerticalSize );
		}
		else if( adventureGrid != None && mActiveCameraIdx == CAM_ADVENTURE)
		{
			TargetVRP[mActiveCameraIdx].X = FClamp( TargetVRP[mActiveCameraIdx].X, DefaultGridCenter[mActiveCameraIdx].X - adventureGrid.GetCurrentGrid().GetGridSizeX() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) + CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin, DefaultGridCenter[mActiveCameraIdx].X + adventureGrid.GetCurrentGrid().GetGridSizeX() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) - CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin ); // http://www.catster.com/files/600px-Longcat_buildings.jpg
			TargetVRP[mActiveCameraIdx].Y = FClamp( TargetVRP[mActiveCameraIdx].Y , DefaultGridCenter[mActiveCameraIdx].Y - adventureGrid.GetCurrentGrid().GetGridSizeY() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) + CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin, DefaultGridCenter[mActiveCameraIdx].Y + adventureGrid.GetCurrentGrid().GetGridSizeY() * (class'H7EditorMapGrid'.const.CELL_SIZE / 2.0f) - CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin );
			// adjust to ground level (z)
			AdjustToGround(adventureGrid);

			// teleport camera if grid at targetpoint changed or the distance is above a certain threshold
			if( adventureGrid.GetClosestGridToPosition(TargetVRP[mActiveCameraIdx]).GetIndex() != lastGridID[mActiveCameraIdx] || class'H7Math'.static.GetDistance(TargetVRP[mActiveCameraIdx],CurrentVRP[mActiveCameraIdx]) > class'H7EditorMapGrid'.const.CELL_SIZE*50.0f )
			{
				lastGridID[mActiveCameraIdx] = adventureGrid.GetClosestGridToPosition(TargetVRP[mActiveCameraIdx]).GetIndex();
				CurrentVRP[mActiveCameraIdx] = TargetVRP[mActiveCameraIdx];
			}

		} 
		else if(mActiveCameraIdx == CAM_TOWN)
		{
			TargetVRP[mActiveCameraIdx].X = FClamp( TargetVRP[mActiveCameraIdx].X, CameraProperties[mActiveCameraIdx].PanXOffset - CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin, CameraProperties[mActiveCameraIdx].PanXOffset + CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin );
			TargetVRP[mActiveCameraIdx].Y = FClamp( TargetVRP[mActiveCameraIdx].Y, CameraProperties[mActiveCameraIdx].PanYOffset - CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin  , CameraProperties[mActiveCameraIdx].PanYOffset + CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin   );
			// use fast lerp mode and return, ignore y, no speed in y direction, will never reach target
			CurrentVRP[mActiveCameraIdx] = VLerp( CurrentVRP[mActiveCameraIdx], TargetVRP[mActiveCameraIdx], FClamp(CameraProperties[mActiveCameraIdx].PanBlendSpeed,0.0f,1.0f) );
			return (CurrentVRP[mActiveCameraIdx] - Vector(CurrentRotation[mActiveCameraIdx]) * TargetViewingDistance[mActiveCameraIdx]);
		}
		else
		{
			TargetVRP[mActiveCameraIdx].X = FClamp( TargetVRP[mActiveCameraIdx].X, DefaultGridCenter[mActiveCameraIdx].X - CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin, DefaultGridCenter[mActiveCameraIdx].X + CameraProperties[mActiveCameraIdx].GridBorderHorizontalSizeMin );
			TargetVRP[mActiveCameraIdx].Y = FClamp( TargetVRP[mActiveCameraIdx].Y, DefaultGridCenter[mActiveCameraIdx].Y - CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin, DefaultGridCenter[mActiveCameraIdx].Y + CameraProperties[mActiveCameraIdx].GridBorderVerticalSizeMin );
		}
	}

	if (mActiveCameraIdx == CAM_ADVENTURE || mActiveCameraIdx == CAM_COMBAT || mActiveCameraIdx == CAM_COMBAT_DEPLOYMENT || mActiveCameraIdx == CAM_COMBAT_START)
	{
		screenRatioCoef = GetScreenRatioCoef();
	}
	else
	{
		screenRatioCoef = 1.0f;
	}

	lastPos = CurrentVRP[mActiveCameraIdx];
	CurrentVRP[mActiveCameraIdx] = VLerp( CurrentVRP[mActiveCameraIdx], TargetVRP[mActiveCameraIdx], FClamp(CameraProperties[mActiveCameraIdx].PanBlendSpeed * DeltaTime * 5.0f,0.0f,1.0f) );
	mLastPannedDistance = VSize( lastPos - CurrentVRP[mActiveCameraIdx] );
	
	result = (CurrentVRP[mActiveCameraIdx] - Vector(CurrentRotation[mActiveCameraIdx]) * (TargetViewingDistance[mActiveCameraIdx] * screenRatioCoef));

	if(mActiveCameraIdx == CAM_ADVENTURE && adventureGrid != None)
	{
		CheckForClipping(result, adventureGrid);
	}

	return result;
}

function AdjustToGround(H7AdventureGridManager adventureGrid)
{
	local float sum, distance1, distance2;
	local Vector center;
	local int i, offsetX, offsetY;
	local float result;
	// shift center nearer to the player
	center = TargetVRP[mActiveCameraIdx];
	center.Y += 1000;

	// calculate the average height taken from center + 16 positions around it 
	distance1 = class'H7BaseCell'.const.CELL_SIZE * 2;
	distance2 = class'H7BaseCell'.const.CELL_SIZE * 4;

	adventureGrid.GetCurrentGrid().GetCameraHeightAt( center.X, center.Y, sum );

	for(i=0; i<8; i++)
	{
		offsetX = Cos(i / 4.0f * Pi) * distance1;
		offsetY = Sin(i / 4.0f * Pi) * distance1;
		adventureGrid.GetCurrentGrid().GetCameraHeightAt( center.X + offsetX, center.Y + offsetY, result );
		sum += result;

		offsetX *= distance2 / distance1;
		offsetY *= distance2 / distance1;
		adventureGrid.GetCurrentGrid().GetCameraHeightAt( center.X + offsetX, center.Y + offsetY, result );
		sum += result;
	}

	TargetVRP[mActiveCameraIdx].Z = sum / 17;
}

function CheckForClipping(out Vector cameraPos, H7AdventureGridManager adventureGrid)
{
	local Vector center;

	center = cameraPos;

	if(adventureGrid.GetCurrentGrid().IsCameraPosInsideGrid( center.X, center.Y ))
	{
		adventureGrid.GetCurrentGrid().GetCameraHeightAt( center.X, center.Y, center.Z );
	}
	else
	{
		center.Z = adventureGrid.GetCurrentGrid().GetHeight( center );
	}
	
	if(cameraPos.Z < center.Z + CAMERA_GROUND_CLIPPING_TRESHHOLD)
	{
		cameraPos.Z = center.Z + CAMERA_GROUND_CLIPPING_TRESHHOLD;
	}
}

native function float GetScreenRatioCoef();

/**
 * Query ViewTarget and outputs Point Of View.
 *
 * @param		OutVT			ViewTarget to use.
 * @param		DeltaTime		Delta Time since last camera update (in seconds).
 * @network						Client
 */
function UpdateViewTarget(out TViewTarget OutVT, float DeltaTime) // TODO spams ScriptWarning: Divide by zero when min or max are equal to current
{
	local H7PlayerController InputController;
	local H7SoundController soundController;
	local CameraActor	CamActor;
	local float DeltaTimeAdjusted;
	local Vector Loc, Pos;
	local Rotator Rot, EgoCamRot;
	local Pawn TPawn;

	// camera is not influenced by the speed of the game (TimeDilation==GameSpeed)
	if( WorldInfo.TimeDilation > 0.1f )
	{
		DeltaTimeAdjusted = DeltaTime / WorldInfo.TimeDilation;
	}

	if( mDeltaTimeDelay < 0.2f )
	{
		mDeltaTimeDelay += DeltaTimeAdjusted;
		return;
	}

	// Make sure we have a valid target
	if( OutVT.Target == None )
	{
		;
		return;
	}

	if (CameraStyle == 'None')
	{
		CameraStyle = 'FirstPerson';
	}

	if (CameraStyle != 'FirstPerson')
	{
		TPawn = Pawn(OutVT.Target);
		switch( CameraStyle )
		{
			case 'Fixed'		:	// do not update, keep previous camera position by restoring
									// saved POV, in case CalcCamera changes it but still returns false
									Pos = OutVT.Target.Location;
									EgoCamRot.Pitch = FreeCamDistance * 3;
									Rot = OutVT.Target.Rotation - EgoCamRot;
									Pos = Pos - Vector(Rot) * FreeCamDistance;
									OutVT.POV.Location = Pos;
									OutVT.POV.Rotation = OutVT.Target.Rotation - EgoCamRot;
									break;

			case 'ThirdPerson'	: // Simple third person view implementation
			case 'FreeCam'		:
			case 'FreeCam_Default':
									Loc = OutVT.Target.Location;
									Rot = OutVT.Target.Rotation;

									// Take into account Mesh Translation so it takes into account the PostProcessing we do there.
									if ((TPawn != None) && (TPawn.Mesh != None))
									{
										Loc += (TPawn.Mesh.Translation - TPawn.default.Mesh.Translation) >> OutVT.Target.Rotation;
									}

									//OutVT.Target.GetActorEyesViewPoint(Loc, Rot);
									if( CameraStyle == 'FreeCam' || CameraStyle == 'FreeCam_Default' )
									{
										Rot = PCOwner.Rotation;
									}
									Loc += FreeCamOffset >> Rot;

									Pos = Loc - Vector(Rot) * FreeCamDistance;
									OutVT.POV.Location = Pos;
									OutVT.POV.Rotation = Rot;
									break;
		}
		return;
	}

	// If we are in council use this
	if(mActiveCameraIdx == CAM_COUNCIL || mActiveCameraIdx == CAM_COUNCIL_MAP) //
	{
		CamActor = CameraActor(OutVT.Target);
		if( CamActor != None ) // Matinee
		{
			//super.UpdateViewTarget(OutVT, DeltaTime);

			if(class'H7CouncilManager'.static.GetInstance() != none && class'H7CouncilManager'.static.GetInstance().GetMatineeManager().GetMonitoredMatinee() != none)
			{
				mOriginalPosition = OutVT.POV.Location;
				mOriginalRotation = OutVT.POV.Rotation;
				mOriginalFOV = CamActor.FOVAngle;

				// @TODO: Should also capture FOV of matinee camera

				CamActor.GetCameraView(DeltaTime, OutVT.POV);
				SetFOV(CamActor.FOVAngle);

				// Grab aspect ratio from the CameraActor.
				bConstrainAspectRatio	= bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
				OutVT.AspectRatio		= CamActor.AspectRatio;

				// See if the CameraActor wants to override the PostProcess settings used.
				CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
				CamPostProcessSettings = CamActor.CamOverridePostProcess;
			}
			
		}
		else if(mActiveCameraIdx == CAM_COUNCIL_MAP) // Gameplay map
		{
			InputController = class'H7PlayerController'.static.GetPlayerController();

			OutVT.POV.Rotation = mOriginalRotation;
			OutVT.POV.Location = mOriginalPosition;

			if(class'H7CouncilMapManager'.static.GetInstance() != none)
			{
				OutVT.POV.Rotation = class'H7CouncilMapManager'.static.GetInstance().GetMapCamera().Rotation;
				OutVT.POV.Location = class'H7CouncilMapManager'.static.GetInstance().GetMapCamera().Location;
				OutVT.POV.FOV = class'H7CouncilMapManager'.static.GetInstance().GetMapCamera().FOVAngle;	
			}
			
			if(class'H7AdventureController'.static.GetInstance() != none && !class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
			{
				class'H7AdventureController'.static.GetInstance().SwitchToCouncilMapReady();
			}
			

			SetFOV(OutVT.POV.FOV);
		}
		else // CAM_COUNCIL
		{
			if(class'H7CouncilManager'.static.GetInstance() != none && class'H7CouncilManager'.static.GetInstance().GetMatineeManager().GetMonitoredMatinee() == none)
			{
				OutVT.POV.Rotation = mOriginalRotation;
				OutVT.POV.Location = mOriginalPosition;

				SetFOV(mOriginalFOV);
			}
		}

		return;
	}

	// Viewing through a camera actor.
	CamActor = CameraActor(OutVT.Target);
	if( CamActor != None ) // Matinee
	{
		CamActor.GetCameraView(DeltaTime, OutVT.POV);
		SetFOV(CamActor.FOVAngle);

		// Grab aspect ratio from the CameraActor.
		bConstrainAspectRatio	= bConstrainAspectRatio || CamActor.bConstrainAspectRatio;
		OutVT.AspectRatio		= CamActor.AspectRatio;

		// See if the CameraActor wants to override the PostProcess settings used.
		CamOverridePostProcessAlpha = CamActor.CamOverridePostProcessAlpha;
		CamPostProcessSettings = CamActor.CamOverridePostProcess;
	}
	else // Gameplay
	{
		// start-of-battle camera animation running ...
		if( mActiveCameraIdx == CAM_COMBAT_START )
		{
			// ----- SHOWCASE ----
			OutVT.POV.Rotation = TargetRotation[mActiveCameraIdx];
			OutVT.POV.Location = CurrentVRP[mActiveCameraIdx] - Vector(CurrentRotation[mActiveCameraIdx]) * TargetViewingDistance[mActiveCameraIdx];
			OutVT.POV.Location.Z += 150.0f;
			OutVT.POV.Location.X += 90.0f;
			OutVT.POV.Location.Y += 100.0f;
			ApplyCameraModifiers(DeltaTime, OutVT.POV);
			SetCameraRotation(OutVT.POV.Rotation);
			SetCameraLocation(OutVT.POV.Location);
			return;
		}

		InputController = class'H7PlayerController'.static.GetPlayerController();
	
		// Return the default update camera target
		if (CameraProperties[mActiveCameraIdx] == None || InputController == None)
		{
			Super.UpdateViewTarget(OutVT, DeltaTime);
			return;
		}

		if(class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
		{   
			class'H7AdventureController'.static.GetInstance().SwitchToAdventureMapReady();
		}
	
		CalculateNewZoom(InputController, DeltaTimeAdjusted);
	
		// update the camera with the new values
		OutVT.POV.Rotation = CalculateNewRotation(InputController);
		OutVT.POV.Location = CalculateNewPosition(InputController, DeltaTimeAdjusted);

		SetCameraRotation(OutVT.POV.Rotation);
		SetCameraLocation(OutVT.POV.Location);

		if(!mIsInCameraActionMode && !mOverridenFOV)
		{
			soundController = class'H7SoundController'.static.GetInstance();

			if (TargetViewingDistance[mActiveCameraIdx] > CameraProperties[mActiveCameraIdx].ViewingDistance)
			{
				SetFOV(Lerp( CameraProperties[mActiveCameraIdx].FieldOfView, CameraProperties[mActiveCameraIdx].FOVMaximum, (TargetViewingDistance[mActiveCameraIdx] - CameraProperties[mActiveCameraIdx].ViewingDistance) / ((CameraProperties[mActiveCameraIdx].ViewDistanceMaximum + mCameraMaxDistanceCache) - CameraProperties[mActiveCameraIdx].ViewingDistance) ));
				if( soundController != none )
				{
					soundController.UpdateCameraDistanceAttenuation(TargetViewingDistance[mActiveCameraIdx], CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, CameraProperties[mActiveCameraIdx].ViewDistanceMaximum);
				}
			}
			else
			{
				SetFOV(Lerp( CameraProperties[mActiveCameraIdx].FieldOfView, CameraProperties[mActiveCameraIdx].FOVMinimum, (CameraProperties[mActiveCameraIdx].ViewingDistance - TargetViewingDistance[mActiveCameraIdx]) / (CameraProperties[mActiveCameraIdx].ViewingDistance - CameraProperties[mActiveCameraIdx].ViewDistanceMinimum) ));
				if( soundController != none )
				{
					soundController.UpdateCameraDistanceAttenuation(TargetViewingDistance[mActiveCameraIdx], CameraProperties[mActiveCameraIdx].ViewDistanceMinimum, CameraProperties[mActiveCameraIdx].ViewDistanceMaximum);
				}
			}
		}
	}

	// Apply camera modifiers at the end (view shakes for example)
	ApplyCameraModifiers(DeltaTime, OutVT.POV);

	if(CamActor != None)
	{
		UpdateAudioListener(CamActor);
	}
	else
	{
		UpdateAudioListener();
	}
}

function PlayCameraShake(CameraShake Shake, float Scale, optional ECameraAnimPlaySpace PlaySpace=CAPS_CameraLocal, optional rotator UserPlaySpaceRot)
{
	if(!class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInTownScreen())
	{
		super.PlayCameraShake(Shake, Scale, PlaySpace,  UserPlaySpaceRot);
	}
}

function UpdateAudioListener(optional CameraActor CamActor)
{
	local Vector up, right, front;

	GetAxes( Rotation, front, right, up );
	
	if(!mCinematicListenerEnabled)
	{
		UpdateAkAudioListener(0, TargetVRP[mActiveCameraIdx], up, right, front ); //We dont expect to have a localplayer index different than 0
	}
	else if(mCinematicListenerEnabled && CamActor != none)
	{
		UpdateAkAudioListener( 0, CamActor.Location, up, right, front );
	}
	else if( mCinematicListenerEnabled && CamActor == none )
	{
		UpdateAkAudioListener( 0, self.Location, up, right, front );
	}
}

native function UpdateAkAudioListener(int PlayerIndex, vector AnchorPoint, vector Up, vector Right, vector Front);

function EnableAudioListener( bool enable )
{
	local AudioDevice Audio;
	local Vector up, right, front;  
	local Vector farAway;


	Audio = class'Engine'.static.GetAudioDevice();
	if( Audio != None )	{
		Audio.bDisableUnrealSetListener = true;
		GetAxes( Rotation, right, front, up );
		farAway.X = 0.0f;
		farAway.Y = 0.0f;
		farAway.Z = 500000.0f;
		if( enable == false )
		{
			Audio.SetSimpleListener( farAway, up, right, front, false );
		}
		else
		{
			Audio.SetSimpleListener( TargetVRP[mActiveCameraIdx], up, right, front, true );
		}
	}
}

///////////////////////////////////////////////////////////
// the 2 elementary basic function everthing boils down to final ultimate:

function SetCameraLocation(Vector newLocation)
{
	if(Location.X != newLocation.X || Location.X != newLocation.X || Location.Y != newLocation.Y)
	{
		SetLocation(newLocation);
	}
}

function SetCameraRotation(Rotator newRotation)
{
	if(Rotation.Pitch != newRotation.Pitch || Rotation.Roll != newRotation.Roll || Rotation.Yaw != newRotation.Yaw)
	{
		SetRotation(newRotation);
	}
}

///////////////////////////////////////////////////////////

event Destroyed()
{
	mTreasureCam = None;

	Super.Destroyed();
}

// Default properties block
