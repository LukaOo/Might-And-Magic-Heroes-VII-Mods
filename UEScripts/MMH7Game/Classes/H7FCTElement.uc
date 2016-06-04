//=============================================================================
// H7FCTElement
//
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FCTElement extends Object;

var protected Vector mWorldPosition;
var protected float mAge;
var protected String mText;
var protected String mIconPath;
var protected Color mColor;
var protected int mFlashID;
var protected Vector2D mOffset;
var protected EFCTType mType;
var protected bool doUpperScreenBorderCheck;

function SetDoUpperScreenBorderCheck(bool val) {doUpperScreenBorderCheck = val;}
function Vector GetWorldPosition()		{ return mWorldPosition; }
function SetWorldPosition(Vector pos)	{ mWorldPosition = pos; }
function string GetText()				{ return mText; }
function Vector2D GetPixelOffset()      { return mOffset; }
function string GetIconPath()			{ return mIconPath; }
function float GetAge()					{ return mAge; }
function int GetFlashID()				{ return mFlashID; }
function bool isDead()					
{ 
	if( mType != FCT_HIGHLIGHT )
	{
		return mAge >= 3; 
	}
	else
	{
		return false;
	}
}
function EFCTType GetType()             { return mType; }

function Init(Vector startPosition,String text,Color textColor,int flashID, String iconPath,Vector2D offset, EFCTType type)
{
	mWorldPosition = startPosition;
	mAge = 0;
	mText = text;
	mColor = textColor;
	mFlashID = flashID;
	mIconPath = iconPath;
	mOffset = offset;
	mType = type;
}

// 1. gets projected from worldposition to screen
// 2. element floats up in 2d gui space
// 3. applies screen-offset (pixel)
// - called every frame
function Render(Canvas myCanvas)
{
	local Vector lTextLocation, floatWorldPosition;
	local float fadeDuration,fadeFactor; // 0 -> 1
	local Vector2D flashXY,unrealXY;

	floatWorldPosition = mWorldPosition;
	//floatWorldPosition.Z += mAge/class'H7GUIGeneralProperties'.static.GetInstance().mFCTDuration * class'H7GUIGeneralProperties'.static.GetInstance().mFCTHeight;

	fadeDuration = class'H7GUIGeneralProperties'.static.GetInstance().mFCTDuration - class'H7GUIGeneralProperties'.static.GetInstance().mFCTFadeDelay;
	fadeFactor = (mAge <= class'H7GUIGeneralProperties'.static.GetInstance().mFCTFadeDelay)? 0.0f : (mAge-class'H7GUIGeneralProperties'.static.GetInstance().mFCTFadeDelay)/fadeDuration;

	if( mType != FCT_HIGHLIGHT )
	{
		mColor.A = 255 - fadeFactor * (255-class'H7GUIGeneralProperties'.static.GetInstance().mFCTEndAlpha);
	}

	lTextLocation = myCanvas.Project( floatWorldPosition );

	if(doUpperScreenBorderCheck)
	{
		if(lTextLocation.Y < 150)
		{
			lTextLocation.Y = 150;
		}
	}

	unrealXY.X = lTextLocation.X;
	unrealXY.Y = lTextLocation.Y;
	flashXY = class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().UnrealPixels2FlashPixels(unrealXY) + mOffset;

	// move in 2dspace:
	if( mType != FCT_HIGHLIGHT )
	{
		flashXY.Y = flashXY.Y - mAge/class'H7GUIGeneralProperties'.static.GetInstance().mFCTDuration * class'H7GUIGeneralProperties'.static.GetInstance().mFCTHeight;
	}

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().GetFloatingSystem().UpdateFloat(mFlashID,flashXY.X,flashXY.Y,mColor.A);
}

/*
function ChangePos(int deltaX, int deltaY)
{
	mWorldPosition.X += deltaX;
	mWorldPosition.Y += deltaY;
}
*/

function Age(float deltaTime)
{
	mAge += deltaTime;
}

