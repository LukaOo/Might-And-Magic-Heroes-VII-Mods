//=============================================================================
// H7RequestPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RequestPopupCntl extends H7FlashMovieBlockPopupCntl;

var protected H7GFxRequestPopup mRequestPopup;

function H7GFxRequestPopup GetRequestPopup() { return mRequestPopup; }
function H7GFxUIContainer GetPopup() { return mRequestPopup; }

static function H7RequestPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHud().GetPopupCntl(); }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mRequestPopup = H7GFxRequestPopup(mRootMC.GetObject("aRequestPopup", class'H7GFxRequestPopup'));
	mRequestPopup.SetVisibleSave(false);
	
	/*
	yesButton = GFxCLIKWidget(mRequestPopup.GetObject("mYesButton", class'GFxCLIKWidget'));
	yesButton.AddEventListener('CLIK_click', YesButtonClicked);

	noButton = GFxCLIKWidget(mRequestPopup.GetObject("mNoButton", class'GFxCLIKWidget'));
	noButton.AddEventListener('CLIK_click', NoButtonClicked);
	*/

	mRequestPopup.Initialize();

	Super.Initialize();
	return true;
}

function OpenPopupByMessage(H7Message message)
{
	GetRequestPopup().YesNoPopup(
		message.text,
		message.settings.callbacks.YesCaption,
		message.settings.callbacks.NoCaption,
		message.settings.callbacks.OnYes,
		message.settings.callbacks.OnNo
	);
}

function InitWindowKeyBinds()
{
	CreatePopupKeybind('Enter',"PositiveResponse",OnPositiveResponse,'SpaceBar');
	CreatePopupKeybind('Escape',"NegativeResponse",OnNegativeResponse);

	super.InitWindowKeyBinds();
}

// Finish Popup

// called by flash key press event [Enter] [Space] on popup
// and by [Enter] inside input field
function OnPositiveResponse()
{
	local EventData dummy;
	;
	if(mRequestPopup.WasOpenedThisFrame()) // don't accept keys from the same frame it was opened
	{
		return;
	}
	mRequestPopup.YesButtonClicked(dummy);
}

// called by flash key press event [Esc]
function OnNegativeResponse()
{
	;
	if(mRequestPopup.WasOpenedThisFrame()) // don't accept keys from the same frame it was opened
	{
		return;
	}
	mRequestPopup.EscapePressed();
}

function Closed()
{
	;
	mRequestPopup.Finish();
}

function bool OpenPopup()
{
	SetPriority(99);
	GetHUD().SetRightClickThisFrame(false); // the right down was in the underlying popup but the right up was on the requestpopup (and was captured someone and did not reset the boolean)
	GetHUD().SetRightMouseDown(false);
	// actually neither SetRightClickThisFrame true nor false is called while requestpopup is open, which means you can click it's buttons with right-click
	return super.OpenPopup();
}

function ClosePopup()
{
	SetPriority(0);
	mRequestPopup.ClearTimer();
	class'H7PlayerController'.static.GetPlayerController().FlushKeys();
	super.ClosePopup();
}

