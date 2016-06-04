//=============================================================================
// H7FlashMovieBlockPopupCntl
//
// Here goes what is common to all flash-movies that represent a blocking popup (disables everything and has a dark layer below it)
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FlashMovieBlockPopupCntl extends H7FlashMoviePopupCntl
	dependson(H7KeybindManager);

function bool Initialize()
{
	super.Initialize();

	InitWindowKeyBinds();

	return true;
}

function bool OpenPopup()
{
	//SetPriority(2); // this also causes all stack drag and drops to be under the popup :-(
	
	return super.OpenPopup();
}

function ClosePopup()
{
	super.ClosePopup();
	
	//SetPriority(0);
}

