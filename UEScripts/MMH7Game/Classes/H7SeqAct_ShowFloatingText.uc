/*=============================================================================
 * H7SeqAct_ShowFloatingText
 * 
 * Action to show a floating text
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *=============================================================================*/

class H7SeqAct_ShowFloatingText extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native
	perobjectconfig;

/** The text to show. */
var(Properties) protected localized string mTextToShow<DisplayName="Text to show">;
/** The tile marker where the text should appear */
var(Properties) protected H7TileMarker mTargetTileMarker<DisplayName="Position tile marker">;
/** Style of floating text. */
var(Properties) protected EFCTType mType<DisplayName="Type">;
/** The color for the floating text. */
var(Coloring) protected EEditorObjectColor mColor<DisplayName="Text color">;

var protected vector mPosition;
var protected int mIntParam;
var protected float mFloatParam;
var protected string mStringParam;

function Activated()
{
	local H7MessageSettings messageSettings;
	local string message;

	message = mTextToShow;

	if(InStr(message, "%param1") >= 0)
	{
		message = Repl(message, "%param1", string(mIntParam));
	}

	if(InStr(message, "%param2") >= 0)
	{
		message = Repl(message, "%param2", class'H7GameUtility'.static.FloatToString(mFloatParam));
	}

	if(InStr(message, "%param3") >= 0)
	{
		message = Repl(message, "%param3", mStringParam);
	}

	messageSettings.floatingLocation = (mTargetTileMarker == none) ? mPosition : mTargetTileMarker.Location;
	messageSettings.color = class'H7GameUtility'.static.GetEditorColor(mColor);
	messageSettings.floatingType = mType;
	messageSettings.referenceObject = self;

	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(message, MD_FLOATING, messageSettings,
		class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerNumber());
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

