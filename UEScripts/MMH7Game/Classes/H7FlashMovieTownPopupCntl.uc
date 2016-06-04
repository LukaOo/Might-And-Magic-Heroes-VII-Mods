//=============================================================================
// H7FlashMovieTownPopupCntl
//
// Here goes what is common to all flash-movies that represent a town popup
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FlashMovieTownPopupCntl extends H7FlashMoviePopupCntl;

var H7Town mTown;

function Update(H7Town town)
{
	mTown = town;
}

function LinkToTownPopupContainer()
{
	mContainer = H7AdventureHud(GetHUD()).GetTownPopupContainerCntl();
	mContainer.GetLoaderManager().LoadMovie(self,LoadComplete);
	mRootMC = mContainer.GetRoot();

	InitWindowKeyBinds();
}

function LoadComplete()
{
	;
}

function bool OpenPopup()
{
	// OPTIONAL should super.OpenPopup be first, so that closing inside it is done first, i.e. townInfo hidden?
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetTownInfo().SetVisibleSave(false);
	
	if(mContainer != none) mContainer.SetExternalInterface(self);

	//GetHUD().TriggerKismetNodeClosePopup("aTownScreen"); // not wanted but would be consistently inconsistent
	H7AdventureHud(GetHUD()).GetTownHudCntl().GetMiddleHUD().StopQuickSlotGlow();

	return super.OpenPopup();
}

function ClosePopup()
{
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().TownPopupWasClosed(self); // GetTownInfo().SetVisibleSave(true) is in here
	super.ClosePopup();

	// set back the listener
	if(mContainer != none) mContainer.SetExternalInterface(mContainer);
}

