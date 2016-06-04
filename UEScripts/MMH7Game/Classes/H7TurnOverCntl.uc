//=============================================================================
// H7RequestPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TurnOverCntl extends H7FlashMovieBlockPopupCntl;

var protected H7GFxTurnOver mTurnOverPopup;
var protected bool bIsHotSeat;
var protected   GFxCLIKWidget   mOkButton;

function        H7GFxTurnOver   GetTurnOverPopup()  {return mTurnOverPopup; }
function        H7GFxUIContainer   GetPopup()          {return mTurnOverPopup; }
static function H7TurnOverCntl  GetInstance()       { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTurnOverCntl(); }

public function      SetIsHotSeat(bool isHotSeat)   { bIsHotSeat = isHotSeat; }
public function bool GetIsHotSeat()                 { return bIsHotSeat; }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mTurnOverPopup = H7GFxTurnOver(mRootMC.GetObject("aTurnOverPopup", class'H7GFxTurnOver'));
	mTurnOverPopup.SetVisibleSave(false);
	
	mOkButton = GFxCLIKWidget( mTurnOverPopup.GetObject("mOkButton", class'GFxCLIKWidget') );
	mOkButton.AddEventListener('CLIK_click', OkClicked);

	Super.Initialize();
	return true;
}


/**
 * Does NOT check for actual HotSeat, just if there is more than one Player not controlled by AI.
 * (Not sure how this interacts in network-play!)
 * @return true, if more than one human-player
 */
/*
function InitHotSeat()
{
	bIsHotSeat = class'H7AdventureController'.static.GetInstance().IsHotSeat();
}

function StartTurn(String infoMessage, String okCaption)
{
	class'H7PlayerController'.static.GetPlayerController().SetPause(true);
	mTurnOverPopup.StartTurn(infoMessage, okCaption);

	OpenPopup();
}
*/
public function OkClicked(EventData data)
{
	class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetFOWController().RestoreNextPlayer();
	ClosePopup();
}

function OnOk()
{
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);
	
	ClosePopup();
}

function Fail()
{
	class'H7PlayerController'.static.GetPlayerController().SetPause(false);
	
	ClosePopup();

}

