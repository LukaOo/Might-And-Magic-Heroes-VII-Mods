//=============================================================================
// H7FxLoadingCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7LoadingScreenCntl extends H7FlashMovieCntl;

var protected H7GFxLoadingScreen mLoadingScreen;

function    H7GFxLoadingScreen   GetLoadingScreen() {return mLoadingScreen;}

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);
	
	mLoadingScreen = H7GFxLoadingScreen(mRootMC.GetObject("aLoadingScreen", class'H7GFxLoadingScreen'));
	mLoadingScreen.SetVisibleSave(false);

	SetViewScaleMode(SM_NoBorder);

	Super.Initialize();
	return true;
}

public function Show(String imgPath="")
{
	local Vector2d currentUnrealRes;

	mLoadingScreen.SetVisibleSave(true);
	currentUnrealRes = UnrealPixels2FlashPixels(class'H7PlayerController'.static.GetPlayerController().GetScreenResolution());
	mLoadingScreen.Show(currentUnrealRes.X, currentUnrealRes.Y, getImageString());
}

public function Hide()
{
	mLoadingScreen.SetVisibleSave(false);
}

private function String getImageString()
{
	return "img://H7Backgrounds.ACA_haven_04"; 
}

