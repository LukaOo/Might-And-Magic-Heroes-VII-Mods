//=============================================================================
// H7GFxTreasureHunt
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxTreasureHunt extends H7GFxUIContainer;

const FIELD_OF_VIEW = 50.0f;

var protected TextureRenderTarget2D mMap;
var protected SceneCapture2DComponent mCaptureComponent;

var protected array<Actor> mHiddenActors;

var protected int mPiecesOnPrevVisit;

var protected float mSavedBufferRatio;
var protected bool mSavedBufferActive;
var protected bool mIsFilming;

function bool IsFilming()   { return mIsFilming; }
function bool IsMapReady()   { return mMap != none; }

function Update(bool fadeWhenOpening)
{
	local GFxObject data,factionPieces;
	local int obNow,obMax,piecesVisible;
	local string mapPath;
	local H7Faction faction;

	if(mMap == none)
	{
		CreateMap(fadeWhenOpening);
	}

	obNow = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetNumOfVisitedObelisks();
	obMax = class'H7AdventureController'.static.GetInstance().GetAmountOfObelisks();

	piecesVisible = class'H7Obelisk'.static.GetPiecesRevealed(class'H7AdventureController'.static.GetInstance().GetLocalPlayer());

	data = CreateObject("Object");
	// get data
	data.SetInt("PiecesPrev", mPiecesOnPrevVisit);
	data.SetInt("Pieces", piecesVisible);
	data.SetInt("VisitCurrent", obNow);
	data.SetInt("VisitMax", obMax);
	//mapPath = Pathname(class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().mHighResRenderTarget);
	mapPath = Pathname(mMap);
	data.SetString("MapPath", "img://" $ mapPath);

	faction = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetFaction();

	if(faction.GetPuzzle1() == "img://None") // TODO remove hack when all factions have assets
	{
		faction = class'H7GameData'.static.GetInstance().GetFactionByArchetypeID("H7FactionSylvan");
	}

	factionPieces = CreateArray();
	factionPieces.SetElementString(0,faction.GetPuzzle1());
	factionPieces.SetElementString(1,faction.GetPuzzle2());
	factionPieces.SetElementString(2,faction.GetPuzzle3());
	factionPieces.SetElementString(3,faction.GetPuzzle4());
	factionPieces.SetElementString(4,faction.GetPuzzle5());
	factionPieces.SetElementString(5,faction.GetPuzzle6());
	factionPieces.SetElementString(6,faction.GetPuzzle7());
	factionPieces.SetElementString(7,faction.GetPuzzle8());
	data.SetObject("FactionPieces",factionPieces);

	SetObject("mData",data);

	ActionScriptVoid("Update");

	mPiecesOnPrevVisit = piecesVisible;
}

function CreateMap(bool fadeWhenOpening)
{
	mMap = TextureRenderTarget2D'H7PostProcess.PixelMode.T_PixelModeTarget';
	
	// popup takes 1 frame to open (but only when opened via button, not when opened during obselisk visit OPTIONAL investigate why) 
	// so we see 1 frame flash of the map creation post process, 
	// so we delay it; 
	//GetHud().SetFrameTimer(1,StartVideo);
	// didn't work, flash breaks and can not display the map anymore (OPTIONAL investigate why)
	StartVideo();

	// cover up 1 frame with black screen instead:
	if(fadeWhenOpening)
	{
		class'H7CameraActionController'.static.GetInstance().FadeToBlack(0);
		GetHud().SetFrameTimer(0,RemoveBlack);
	}
}

function RemoveBlack()
{
	class'H7CameraActionController'.static.GetInstance().FadeFromBlack(0);
}

function StartVideo()
{
	local float     cameraDistance;
	local Rotator   camRot;
	local Vector    camVect;
	local H7AdventureGridManager gridManager;
	local IntPoint treasure;
	local int treasureGrid;

	local float sampleFactor;
	local PostProcessEffect effectRender, treasurePP, fowPP;
	local H7Camera gameCam;
	local DynamicCameraActor treasureCam;
	local LocalPlayer localP;

	mIsFilming = true;
	localP = class'H7PlayerController'.static.GetLocalPlayer();

	// test------------
	//treasure.X = 20;
	//treasure.Y = 1;

	gameCam = class'H7Camera'.static.GetInstance();
	if (gameCam == None)
	{
		return;
	}

	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	treasure = class'H7AdventureController'.static.GetInstance().GetTearOfAshaCoordinates();
	treasureGrid = class'H7AdventureController'.static.GetInstance().GetTearOfAshaGridIndex();
	;

	HideStuff();

	cameraDistance = 5000; // PI * thumb

	camVect         = gridManager.GetGridByIndex(treasureGrid).GetCell(treasure.X,treasure.Y).GetLocation();
	camVect.Z      += cameraDistance;
	camRot          = Rotator(Vect(0,0,-1));
	camRot.Roll     = class'H7Math'.static.ConvertDegreeToUnrealDegree(270);

	// re-use the existing things that we already use for Pixellated mode
	effectRender = localP.PlayerPostProcess.FindPostProcessEffect('PixelModeRender');
	if (effectRender != None)
	{
		sampleFactor = 1.0;

		// save the used settings to restore them later because they belong to pixelmode
		mSavedBufferRatio = RenderTargetMaterialEffect(effectRender).RenderTargetRatioSize;
		mSavedBufferActive = effectRender.bShowInGame;
		effectRender.bShowInGame = true;
		RenderTargetMaterialEffect(effectRender).RenderTargetRatioSize = sampleFactor;

		treasurePP = localP.PlayerPostProcess.FindPostProcessEffect('TreasureMap');
		if (treasurePP != None)
		{
			treasurePP.bShowInGame = true;
		}

		fowPP = localP.PlayerPostProcess.FindPostProcessEffect('PPFoW');
		if (fowPP != None)
		{
			fowPP.bShowInGame = false;
		}

		treasureCam = gameCam.Spawn(class'DynamicCameraActor', gameCam,, camVect, camRot);
		gameCam.SetViewTarget(treasureCam);
		gameCam.SetTreasureCam(treasureCam);

		treasureCam.AspectRatio = 1150 / 620;
		treasureCam.bConstrainAspectRatio = true;
		treasureCam.FOVAngle = 49.5f; // 5000 height + FOV 49.5 = 24x13 tiles
	}
}

function StopVideo()
{
	local PostProcessEffect effectRender, treasurePP, fowPP;
	local H7Camera gameCam;
	local LocalPlayer localP;

	localP = class'H7PlayerController'.static.GetLocalPlayer();

	effectRender = localP.PlayerPostProcess.FindPostProcessEffect('PixelModeRender');
	if (effectRender != None)
	{
		RenderTargetMaterialEffect(effectRender).RenderTargetRatioSize = mSavedBufferRatio;
		effectRender.bShowInGame = mSavedBufferActive;

		treasurePP = localP.PlayerPostProcess.FindPostProcessEffect('TreasureMap');
		if (treasurePP != None)
		{
			treasurePP.bShowInGame = false;
		}

		fowPP = localP.PlayerPostProcess.FindPostProcessEffect('PPFoW');
		if (fowPP != None)
		{
			fowPP.bShowInGame = true;
		}
	}

	gameCam = class'H7Camera'.static.GetInstance();
	if (gameCam != None)
	{
		gameCam.SetViewTarget(None);
		gameCam.GetTreasureCam().Destroy();
		gameCam.SetTreasureCam(None);
	}

	mMap = None;

	ShowStuff();

	// camera needs 1 frame to update itself, so we need to block minimap frustum 1 frame longer
	GetHud().SetFrameTimer(1,UnlockMiniMapFrustum);
}

function UnlockMiniMapFrustum()
{
	mIsFilming = false;
}

protected function HideStuff()
{
	local H7PlayerController playerCnt;
	local H7AdventureArmy currentArmy;
	local H7ItemPile currentPile;
	local H7ResourcePile currentResource;

	playerCnt = class'H7PlayerController'.static.GetPlayerController();

	// hide decals/effects/emitters
	playerCnt.ConsoleCommand("show decals false");
	playerCnt.ConsoleCommand("show particles false");

	// hide armies/heroes
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'H7AdventureArmy', currentArmy)
	{
		if( !currentArmy.bHidden )
		{
			currentArmy.SetHidden(true);
			mHiddenActors.AddItem( currentArmy );
		}
	}
	// hide piles/items/resources
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'H7ItemPile', currentPile)
	{
		if( !currentPile.bHidden )
		{
			currentPile.SetHidden(true);
			mHiddenActors.AddItem( currentPile );
		}
	}
	foreach class'WorldInfo'.static.GetWorldInfo().AllActors(class'H7ResourcePile', currentResource)
	{
		if( !currentResource.bHidden )
		{
			currentResource.SetHidden(true);
			mHiddenActors.AddItem( currentResource );
		}
	}
	
	// footsteps

	// hide flags/fx/paths
	class'H7PlayerController'.static.GetPlayerController().SetCinematicVisibilities(true);
}

function ShowStuff()
{
	local H7PlayerController playerCnt;
	local Actor currentActor;

	playerCnt = class'H7PlayerController'.static.GetPlayerController();

	playerCnt.SetCinematicVisibilities(false);

	playerCnt.ConsoleCommand("show decals true");
	playerCnt.ConsoleCommand("show particles true");
	
	foreach mHiddenActors(currentActor)
	{
		currentActor.SetHidden( false );
	}
	mHiddenActors.Length = 0;
}
