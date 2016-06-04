//=============================================================================
// H7UnitFX
//=============================================================================
//
// Class to create an aura effect around the currently active unit.
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7UnitFX extends Actor
	native;

var protected H7UnitSlotFXProperties mProperties;
var protected H7Unit mUnit;
var protected H7PlayerController mPlayerController;

var protected ParticleSystemComponent mSelectionFX;
var protected bool mIsActive;

function H7UnitSlotFXProperties GetProperties() { return mProperties; }

function PostBeginPlay()
{
	super.PostBeginPlay();
	mPlayerController = class'H7PlayerController'.static.GetPlayerController();
}

function InitFX(H7Unit unit) 
{
	mPlayerController = class'H7PlayerController'.static.GetPlayerController();
	mUnit = unit;
}

function CreateFX() {}

function DestroyFX() 
{
	if(mSelectionFX != None)
	{
		WorldInfo.MyEmitterPool.OnParticleSystemFinished(mSelectionFX);
		mSelectionFX = None;
	}
}

function ShowFX()
{
	if(mSelectionFX != None)
	{
		mSelectionFX.SetHidden(false);
		mIsActive = true;
	}
}

function HideFX()
{
	if(mSelectionFX != None)
	{
		mSelectionFX.SetHidden(true);
		mIsActive = false;
	}
}

function UpdateTargetColor( Color targetColor )
{
	local Color currentColor;
	
	if(mSelectionFX != none)
	{
		mSelectionFX.GetColorParameter('Target', currentColor);
	}
	
	if(currentColor != targetColor)
	{
		DestroyFX();
		CreateFX();
		mSelectionFX.SetColorParameter('Target', targetColor);
		mSelectionFX.SetHidden( false );
	}
}

simulated event Destroyed()
{
	super.Destroyed();

	DestroyFX();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

