//=============================================================================
// H7ContainerCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ContainerCntl extends H7FlashMoviePopupCntl;

var protected H7GFxLoaderManager mLoaderManager;

function GFxObject GetRoot() { return mRootMC; }
function H7GFxLoaderManager GetLoaderManager() { return mLoaderManager; }
function H7GFxUIContainer GetPopup() 
{
	// return currently visible popup, but this is non-trivial // OPTIONAL
	return none;
}

function bool Initialize()
{
	;
	Super.Start();
	AdvanceDebug(0);

	mLoaderManager = H7GFxLoaderManager(mRootMC.GetObject("aLoaderManager", class'H7GFxLoaderManager'));
	
	Super.Initialize();
	return true;
}

function LoadComplete(string filename)
{
	mLoaderManager.LoadComplete(filename);
}

// redirecting loca requests during load/construction of a movie
function String FlashLocalize(String locaKey,optional String keybindingCommand,optional bool replaceIcons)
{
	if(GetLoaderManager().GetCurrentlyLoadingCntl() == none)
	{
		;
		return "["$locaKey$"]container can not localize, set external interface";
	}
	return GetLoaderManager().GetCurrentlyLoadingCntl().FlashLocalize(locaKey,keybindingCommand,replaceIcons);
}

