//=============================================================================
// H7MouseCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MouseCntl extends H7FlashMovieCntl;

var protected H7GFxMouse mMouse;

function H7GFxMouse GetMouse() { return mMouse; }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mMouse = H7GFxMouse( mRootMC.GetObject( "aMouse", class'H7GFxMouse' ));
	mMouse.LoadCursorTexture( Texture2d'H7Cursors.Pointer' );

	if(class'H7PlayerController'.static.GetPlayerController().GetHud() != none && !class'H7GUIGeneralProperties'.static.GetInstance().mFlashMouse)
	{
		mMouse.UnLoadCursor();
	}

	SetViewScaleMode(SM_ShowAll);

	Super.Initialize();

	SetPriority(1);

	return true;
}

// not used
function SetMouse()
{
	local Vector2D pos;
	
	;
	pos = UnrealPixels2FlashPixels(mPlayerController.GetMousePosition());
	mMouse.SetPosition(pos.X,pos.Y);
}

