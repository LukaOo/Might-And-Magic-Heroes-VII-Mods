/*=============================================================================
 * H7SeqAct_ShowText
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/

class H7SeqAct_ShowText extends H7SeqAct_BaseText
	implements(H7IAliasable)
	perobjectconfig
	native;

/** Used in the list on the left and when selected in the event editor */
var(Properties) protected string mTitle<DisplayName="Title (Unused)">;
/** The text to display */
var(Properties) protected localized string mText<DisplayName="Text"|MultilineWithMaxRows=7>;
/** The first image to embed into the text */
var(Developer) protected Texture2D mImage<DisplayName="Image 1">;
/** The second image to embed into the text */
var(Developer) protected Texture2D mImage2<DisplayName="Image 2">;
/** The popup is in the blue tutorial style */
var(Developer) protected bool mTutorialBG<DisplayName="Tutorial Style">;

function Activated()
{
	ShowText();
}

function ShowText()
{
	super.ShowText();

	if(mTutorialBG)
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().SetTutorialBG();
	}
}

function string GetLocalizedContent()
{
	local string str;
	str = class'H7Loca'.static.LocalizeKismetObject(self, "mText", mText);

	if(mImage2 != none)
	{
		str = Repl(str,"%image2","<img src='img://" $ PathName(mImage2) $ "'>");
	}

	if(mImage != none)
	{
		str = Repl(str,"%image1","<img src='img://" $ PathName(mImage) $ "'>");
		str = Repl(str,"%image","<img src='img://" $ PathName(mImage) $ "'>");
	}

	return str;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

