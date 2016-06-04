//=============================================================================
// H7CombatMapFCT
//
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapFCT extends Object;

var protected Vector mWorldPosition;
var protected float mAge;
var protected String mText;
var protected Color mColor;
var protected int mFlashID;

function Init(Vector startPosition,String text,Color textColor,int flashID)
{
	mWorldPosition = startPosition;
	mAge = 0;
	mText = text;
	mColor = textColor;
	mFlashID = flashID;
}

function Show(Canvas myCanvas)
{
	local Vector lTextLocation, floatWorldPosition;
	local float lTextLength, lTextHeight;
	local float fadeDuration,fadeFactor; // 0 -> 1
	local Vector2D flashXY,unrealXY;

	floatWorldPosition = mWorldPosition;
	floatWorldPosition.Z += mAge/class'H7GUIGeneralProperties'.static.GetInstance().mFCTDuration * class'H7GUIGeneralProperties'.static.GetInstance().mFCTHeight;

	fadeDuration = class'H7GUIGeneralProperties'.static.GetInstance().mFCTDuration - class'H7GUIGeneralProperties'.static.GetInstance().mFCTFadeDelay;
	fadeFactor = (mAge <= class'H7GUIGeneralProperties'.static.GetInstance().mFCTFadeDelay)? 0.0f : (mAge-class'H7GUIGeneralProperties'.static.GetInstance().mFCTFadeDelay)/fadeDuration;

	myCanvas.Font = Font'enginefonts.TinyFont';
	mColor.A = 255 - fadeFactor * (255-class'H7GUIGeneralProperties'.static.GetInstance().mFCTEndAlpha);
	myCanvas.DrawColor = mColor;
	myCanvas.StrLen(mText, lTextLength, lTextHeight);
	
	lTextLocation = myCanvas.Project( floatWorldPosition );
	
	unrealXY.X = lTextLocation.X;
	unrealXY.Y = lTextLocation.Y;
	flashXY = class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().UnrealPixels2FlashPixels(unrealXY);

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().GetFloatingSystem().UpdateFloat(mFlashID,flashXY.X,flashXY.Y,mColor.A);

	//`LOG_GUI(mFlashID @ mText @ mAge @ flashXY.X @ flashXY.Y @ "w" @ floatWorldPosition.X @ floatWorldPosition.Y @ floatWorldPosition.Z);

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

function bool isDead()
{
	return mAge >= 3;
}

function int GetFlashID()
{
	return mFlashID;
}

function float GetAge()
{
	return mAge;
}
