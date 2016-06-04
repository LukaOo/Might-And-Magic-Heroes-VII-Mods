//=============================================================================
// H7TownGuardPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TownGuardPopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GFxTownGuardPopup mTownGuardPopup;

var protected H7AreaOfControlSite mCurrentLocation; // Town or Garrison

static function H7TownGuardPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownGuardCntl(); }
function H7GFxTownGuardPopup GetTownGuardPopup() {return mTownGuardPopup;}

function bool Initialize()
{
	;
	LinkToTownPopupContainer();

	return true;
}

function LoadComplete()
{
	mTownGuardPopup = H7GFxTownGuardPopup(mRootMC.GetObject("aTownGuardPopup", class'H7GFxTownGuardPopup'));
	mTownGuardPopup.SetVisibleSave(false);
}

function Update(H7Town pTown)
{
	mTown = pTown;
	mCurrentLocation = pTown;
	mTownGuardPopup.Update(mTown);
	OpenPopup();
}

function UpdateFromGarrison(H7Garrison pGarry)
{
	mCurrentLocation = pGarry;
	mTownGuardPopup.Update(pGarry);
	OpenPopup();
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	mTownGuardPopup.Reset();
	
	super.ClosePopup();
}

function H7GFxUIContainer GetPopup()
{
	return mTownGuardPopup;
}

