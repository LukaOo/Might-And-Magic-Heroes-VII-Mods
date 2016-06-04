//=============================================================================
// H7PostprocessManager
//=============================================================================
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7PostprocessManager extends Actor config(Game);

var globalconfig bool mUseAA;
var globalconfig int mPostProcessQuality;
var globalconfig bool mUseFog;

var protected MaterialEffect                    mOutlinesPP;
var protected RenderTargetMaterialEffect        mPreOutlinesPP;
var protected MaterialInstanceConstant          mOutlinesPPMat;
var protected MaterialInstanceConstant          mPreOutlinesPPMat;
var protected MaterialEffect                    mSharpenPP;
var protected MaterialEffect                    mCinematicPP;
var protected RenderTargetMaterialEffect        mFoWPPBlur;
var protected MaterialEffect                    mFoWPP;
var protected UberPostProcessEffect             mUberPP;
var protected MaterialEffect                    mArtisticPP;
var protected RenderTargetMaterialEffect        mAtmosphericPrePass;
var protected DynamicMaterialEffect             mAtmosphericPostPass;

var bool mUsePixellated;
var protected RenderTargetMaterialEffect        mPrePixelPP;
var protected MaterialEffect                    mPixelPP;

function MaterialEffect GetOutlinesPP()	{ return mOutlinesPP; }

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetTimer(1.0f, false, 'InitAA');
	SetTimer(1.0f, false, 'InitOutline');
	SetTimer(1.0f, false, 'InitFog');
}

simulated event Destroyed()
{
	super.Destroyed();

	mOutlinesPP = none;
	mPreOutlinesPP = none;
	mOutlinesPPMat = none;
	mPreOutlinesPPMat = none;
	mSharpenPP = none;
	mCinematicPP = none;
	mFoWPPBlur = none;
	mFoWPP = none;
	mUberPP = none;
	mArtisticPP = none;
	mPrePixelPP = none;
	mPixelPP = none;
}


function bool GetAA()
{
	return mUseAA;
}

function SetAA(bool bVal)
{
	mUseAA = bVal;
	SaveConfig();
	InitAA();
}

function InitOutline()
{
	if (class'H7PlayerController'.static.GetPlayerController() == none)
	{
		SetTimer(1.0f, false, 'InitOutline');
		return;
	}

	mOutlinesPP = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPOutlines'));
	if (mOutlinesPP != None)
	{
		mOutlinesPPMat = new class'MaterialInstanceConstant';
		mOutlinesPPMat.SetParent(mOutlinesPP.Material);
		mOutlinesPP.Material = mOutlinesPPMat;
	}
	mPreOutlinesPP = RenderTargetMaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPPreOutlines'));
	if (mPreOutlinesPP != None)
	{
		mPreOutlinesPPMat = new class'MaterialInstanceConstant';
		mPreOutlinesPPMat.SetParent(mPreOutlinesPP.ProcessMaterial);
		mPreOutlinesPP.ProcessMaterial = mPreOutlinesPPMat;
	}

	mCinematicPP = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPCinematic'));
	mFoWPPBlur = RenderTargetMaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPFoWBlur'));
	mFoWPP = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPFoW'));
}

function ApplyGameTypeEffect(bool bCombat, optional bool bSkipFoW)
{
	if (mPreOutlinesPPMat != None)
	{
		if (bCombat)
		{
			mPreOutlinesPPMat.SetScalarParameterValue( 'UseOcclusion',  0.0f );
			if(mCinematicPP != none)
			{
				mCinematicPP.SceneDPG = SDPG_Foreground;
			}
			if (!bSkipFoW)
			{
				mFoWPPBlur.bShowInGame = false;
				mFoWPP.bShowInGame = false;
			}
		}
		else
		{
			mPreOutlinesPPMat.SetScalarParameterValue( 'UseOcclusion',  1.0f );
			if(mCinematicPP != none)
			{
				mCinematicPP.SceneDPG = SDPG_World;
			}
			if (!bSkipFoW)
			{
				mFoWPPBlur.bShowInGame = true;
				mFoWPP.bShowInGame = true;
			}
		}
	}

	InitFog();
}

function InitAA()
{
	if (class'H7PlayerController'.static.GetPlayerController() == none)
	{
		SetTimer(1.0f, false, 'InitAA');
		return;
	}

	mUberPP = UberPostProcessEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('UberPP'));
	mSharpenPP = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPSharpen'));
	if (mUberPP != None && mSharpenPP != None)
	{
		if (mUseAA)
		{
			mUberPP.PostProcessAAType = PostProcessAA_FXAA5;
			mSharpenPP.bShowInGame = true;
		}
		else
		{
			mUberPP.PostProcessAAType = PostProcessAA_Off;
			mSharpenPP.bShowInGame = false;
		}
	}
}

function InitPixellated()
{
	mPrePixelPP = RenderTargetMaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PixelModeRender'));
	mPixelPP = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PixelMode'));
}

function SetPixellated(bool val)
{
	mUsePixellated = val;

	mPixelPP.bShowInGame = val;
	mPrePixelPP.bShowInGame = val;
}

function int GetPostProcessQuality()
{
	return mPostProcessQuality;
}

function SetPostProcessQuality(int val)
{
	mPostProcessQuality = val;
	SaveConfig();
	InitPPQuality();
}

function array<String> GetPostProcessQualityList()
{
	local array<String> list;
	
	list.AddItem("LOW");
	list.AddItem("HIGH");

	return list;
}

function InitPPQuality()
{
	if (class'H7PlayerController'.static.GetPlayerController() == none)
	{
		SetTimer(1.0f, false, 'InitPPQuality');
		return;
	}

	mArtisticPP = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPArtistic'));
	if (mArtisticPP != None)
	{
		mArtisticPP.bShowInGame = (mPostProcessQuality > 0);
	}
}

function bool GetFog()
{
	return mUseFog;
}

function SetFog(bool bVal)
{
	mUseFog = bVal;
	SaveConfig();
	InitFog();
}

function InitFog()
{
	local WorldInfo MyWorld;
	local ExponentialHeightFog FogActor;

	if (class'H7PlayerController'.static.GetPlayerController() == none)
	{
		SetTimer(1.0f, false, 'InitFog');
		return;
	}

	mAtmosphericPrePass = RenderTargetMaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('AtmosphericFogFocus'));
	if (mAtmosphericPrePass != None)
	{
		mAtmosphericPrePass.bShowInGame = mUseFog;
	}
	mAtmosphericPostPass = DynamicMaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPHighlight'));
	if (mAtmosphericPostPass != None && mAtmosphericPostPass.ProcessMaterial != None)
	{
		MaterialInstanceConstant(mAtmosphericPostPass.ProcessMaterial).SetScalarParameterValue( 'EnableFog', (mUseFog ? 1.0f : 0.0f) );
	}
	//class'H7PlayerController'.static.GetPlayerController().ConsoleCommand( "Show Fog " $ (mUseFog ? "true" : "false") );

	MyWorld = class'WorldInfo'.static.GetWorldInfo();
	if (MyWorld != None)
	{
		foreach MyWorld.AllActors(class'ExponentialHeightFog', FogActor)
		{
			FogActor.Component.SetEnabled(mUseFog);
		}
	}

}

static function SetOutlineActive(bool bActivated)
{
	local PlayerController playerControl;
	local PostProcessChain chain;
	local RenderTargetMaterialEffect outlinePrePP;
	local MaterialEffect outlinePP;

	playerControl = class'H7PlayerController'.static.GetPlayerController();
	chain = LocalPlayer(playerControl.Player).PlayerPostProcess;
	if (chain != None)
	{
		outlinePrePP = RenderTargetMaterialEffect(chain.FindPostProcessEffect('PPPreOutlines'));
		outlinePP = MaterialEffect(chain.FindPostProcessEffect('PPOutlines'));
	}
	if (outlinePrePP != None)
	{
		outlinePrePP.bShowInGame = bActivated;
	}
	if (outlinePP != None)
	{
		outlinePP.bShowInGame = bActivated;
	}
	
	playerControl.ConsoleCommand("SHOW OUTLINE" @ bActivated);
}

function ResetOptions()
{
	// hack
	SetAA(true);
	SetPostProcessQuality(2);
	SetFog(true);
}
