//=============================================================================
// H7GateGuardPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GateGuardPopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GFxTownGuardPopup mTownGuardPopup;

var protected H7AreaOfControlSite mCurrentLocation; // Town or Garrison

static function H7GateGuardPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetGateGuardCntl(); }
function H7GFxTownGuardPopup GetGateGuardPopup() {return mTownGuardPopup;}
function H7GFxUIContainer GetPopup() {return mTownGuardPopup;}

function bool Initialize()
{
	;
	LinkToTownPopupContainer();

	return true;
}

function LoadComplete()
{

	mTownGuardPopup = H7GFxTownGuardPopup(mRootMC.GetObject("aGateGuardPopup", class'H7GFxTownGuardPopup'));
	mTownGuardPopup.SetVisibleSave(false);


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

	// if you close this popup you automatically leave the garrsion "town" screen
	class'H7TownHudCntl'.static.GetInstance().Leave();
}

