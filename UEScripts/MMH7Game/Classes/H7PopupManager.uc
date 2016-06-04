//=============================================================================
// H7PopupManager - in development ; coming soon...?
//
// construciton site for future plans for H7PopupManager
// 
// TODO work with Cntl or UIcontainer???
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7PopupManager extends Object;

var protected array<H7GFxUIContainer> mPopupList;

function OpenPopup(H7GFxUIContainer popup)
{
	if(mPopupList.Length == 0)
	{
		// block unreal
	}
	mPopupList.AddItem(popup);

	// block all lower popups
	// move black-block-layer
	
}

function bool CloseUpperMostPopup()
{
	local H7GFxUIContainer upperPopup;

	if(mPopupList.Length > 0)
	{
		upperPopup = mPopupList[mPopupList.Length-1];
		upperPopup.Hide();

		mPopupList.Remove(mPopupList.Length-1,1);

		if(mPopupList.Length == 0)
		{
			// re-enable unreal
			GetHUD().PopupWasClosed();
		}
		else
		{
			// enable next lower popup
		}

		return true;
	}
	return false;
}

function bool IsPopupOpen()
{
	return mPopupList.Length > 0 ? true : false;
}

function H7Hud GetHUD()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud();
}
