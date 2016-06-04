//=============================================================================
// H7BackgroundImageCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BackgroundImageCntl extends H7FlashMovieCntl;

var protected H7GFxBackgroundImage mBackgroundImage;

var const H7BackgroundImageProperties mBackgroundImageProperties;

static function H7BackgroundImageCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHUD().GetBackgroundImageCntl(); } 

function bool Initialize()  
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mBackgroundImage = H7GFxBackgroundImage( mRootMC.GetObject( "aBackgroundImage", class'H7GFxBackgroundImage' ));

	SetViewScaleMode(SM_NoBorder);

	//GetHUD().SetFrameTimer(1,StopAdvance);

	Super.Initialize();
	return true;
}

function LoadBackground(Texture2D background, optional int fadeInTime, optional int fadeInDelay,optional string screenText)
{
	;
	StartAdvance();
	mBackgroundImage.SetVisibleSave(true);
	mBackgroundImage.LoadBackgroundTexture(background, fadeInTime, fadeInDelay, screenText);
}

function UnloadBackground()
{
	StartAdvance();
	mBackgroundImage.SetVisibleSave(false);
	//GetHUD().SetFrameTimer(2,StopAdvance);
}

