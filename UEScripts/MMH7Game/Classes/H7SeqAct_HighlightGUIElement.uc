/*=============================================================================
 * H7SeqAct_HighlightGUIElement
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/

class H7SeqAct_HighlightGUIElement extends H7SeqAct_Narration native;

/** Delete all existing highlights before */
var(Properties) protected bool mDeleteAllHighlights<DisplayName="Delete all old highlights">;
/** Prevents all pending highlights to be opened in 1 frame */
var(Properties) protected bool mPreventAllPendingHighlights<DisplayName="Prevent all pending highlights">;
/** The hud element or popup name */
var(Properties) protected string mContainer<DisplayName="GUI Container Name">;
/** The button / slot / text name */
var(Properties) protected string mElement<DisplayName="GUI Element Name">;
/** The text in the text box next to the GUI element */
var(Properties) protected localized string mText<DisplayName="Text"|MultilineWithMaxRows=7>;
/** The first image to embed into the text */
var(Properties) protected Texture2D mImage<DisplayName="Image 1">;
/** The second image to embed into the text */
var(Properties) protected Texture2D mImage2<DisplayName="Image 2">;
/** false = rect highlight */
var(Properties) protected bool mIsCircle<DisplayName="Circle Highlight">;
/** false = rect highlight (overwrites circle) */
var(Properties) protected bool mIsBanana<DisplayName="Banana Highlight">;
/** The second image to embed into the text */
var(Properties) protected bool mRemoveWhenClicked<DisplayName="Remove When Clicked">;

var protected bool mIsClicked;
var protected bool mEndTicking;

function bool IsCircle() { return mIsCircle; }

function int GetAssetNr() 
{
	if(mIsBanana) return 3; // banana
	else if(IsCircle()) return 2; // circle
	else return 1; // rect
}

function string GetText()   
{	
	local string str;

	if(mText != "")
	{
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
	}

	return str;
}

function Activated()
{
	mEndTicking = false;
	if(mDeleteAllHighlights)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().DeleteAllHighlights();
	}
	if(mPreventAllPendingHighlights)
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().PreventAllPendingHighlights();
	}
	if((mContainer != "" && mElement != "") || (mText != ""))
	{
		// delay 1 frame because kismet nodes with delete are called "parallel" to highlight nodes and delete the highlight instantly
		class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(1,ShowHighlight);
	}
	else
	{
		EndTicking(); // deactivates note, so maybe it can trigger again
	}
	// trigger output; OPTIONAL only when element found by flash
	ActivateOutputLink(0);
}

function ShowHighlight()
{
	if(class'H7PlayerController'.static.GetPlayerController().GetHud().IsPreventingAllPendingHighlights())
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Prevented highlight" @ mContainer @ mElement @ GetText(),MD_QA_LOG);;
		// suppressed nodes have to deactivate themselves, so they can be activated again:
		EndTicking();
		return;
	}
	class'H7PlayerController'.static.GetPlayerController().GetHud().HighlightGUIElement(mContainer,mElement,GetText(),self);
}

function TriggerClick()
{
	// set some output to true
	if(mRemoveWhenClicked)
	{
		mIsClicked = true;
	}
}

function EndTicking()
{
	mEndTicking = true;
}

function bool IsRemoveWhenClicked()
{
	return mRemoveWhenClicked;
}

function bool IsClicked()
{
	return mIsClicked;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 5;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

