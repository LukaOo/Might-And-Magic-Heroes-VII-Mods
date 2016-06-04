/*=============================================================================
 * H7SeqAct_BaseText
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_BaseText extends H7SeqAct_Narration
	abstract
	native;

var protected bool mTextConfirmed;

function ShowText()
{
	local H7GFxRequestPopup requestPopup;

	mTextConfirmed = false;

	requestPopup = class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup();
	requestPopup.OKPopup(GetLocalizedContent(), class'H7Loca'.static.LocalizeSave("CONFIRM_TEXT","H7SeqAct_ShowText"), OnTextConfirmed);
}

function string GetLocalizedContent()
{
	return "";	//	Implemented in derived classes
}

function OnTextConfirmed()
{
	mTextConfirmed = true;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

