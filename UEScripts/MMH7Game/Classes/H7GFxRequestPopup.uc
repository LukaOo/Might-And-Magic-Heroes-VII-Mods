//=============================================================================
// H7GFxRequestPopup
//
// Popup for general questions and buttons to answer these questions
//
// Available Popups:
// a) Popup with no buttons = NoChoicePopup
// b) Popup with one button = OKPopup
// c) Popup with two buttons = YesNoPopup
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxRequestPopup extends H7GFxUIContainer;

var protected GFxCLIKWidget yesButton;
var protected GFxCLIKWidget noButton;
var protected bool mYesButtonEnabled;
var protected bool mNoButtonEnabled;
var protected bool mCloseButtonEnabled;

var protected GFxObject mData;

var protected bool mOpenedThisFrame;

public delegate OnYes();
public delegate OnNo();
public delegate OnTimerRunOut();
public delegate OnClose();

function Initialize() // not really a standard Cntl Initialize function
{
	yesButton = GFxCLIKWidget(GetObject("mYesButton", class'GFxCLIKWidget'));
	;
	yesButton.AddEventListener('CLIK_click', YesButtonClicked);

	noButton = GFxCLIKWidget(GetObject("mNoButton", class'GFxCLIKWidget'));
	;
	noButton.AddEventListener('CLIK_click', NoButtonClicked);
}

function NoChoicePopup(String blockMessage)
{
	mData = CreateObject("Object");

	if(class'H7Loca'.static.IsLocaKey(blockMessage))
	{
		blockMessage = class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().FlashLocalize(blockMessage);
	}

	mData.SetString("question",blockMessage);
	mData.SetBool("closeButton",false);
	SetObject("mData",mData);

	Update();

	mCloseButtonEnabled = false;
	mYesButtonEnabled = false;
	mNoButtonEnabled = false;

	OnYes = none;
	OnNo = none;
	OnClose = none;

	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().OpenPopup();
}

function OKPopup(String infoMessage,String okCaption,optional delegate<OnYes> okDelegate)
{
	mData = CreateObject("Object");
	mData.SetString("question",infoMessage);
	mData.SetString("yesCaption",okCaption);
	mData.SetBool("closeButton",false);
	SetObject("mData",mData);

	Update();

	mYesButtonEnabled = true;
	mNoButtonEnabled = false;
	mCloseButtonEnabled = false;
	
	OnYes = okDelegate;
	OnNo = none;
	OnClose = none;

	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().OpenPopup();
}

function YesNoPopup(String question,String yesCaption,String noCaption, delegate<OnYes> yesDelegate,delegate<OnNo> noDelegate,optional bool closeButton=false,optional delegate<OnClose> closeDelegate)
{
	mData = CreateObject("Object");
	mData.SetString("yesCaption",yesCaption);
	mData.SetString("noCaption",noCaption);
	mData.SetString("question",question);
	mData.SetBool("closeButton",closeButton);
	SetObject("mData",mData);

	Update();

	mYesButtonEnabled = true;
	mNoButtonEnabled = true;
	mCloseButtonEnabled = closeButton;

	OnYes = yesDelegate;
	OnNo = noDelegate;
	OnClose = closeDelegate;
	
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().OpenPopup();
}

function YesNoCostPopup(String question,String yesCaption,String noCaption, delegate<OnYes> yesDelegate,delegate<OnNo> noDelegate, array<H7ResourceQuantity> cost,optional bool closeButton=false,optional delegate<OnClose> closeDelegate)
{
	mData = CreateObject("Object");
	mData.SetString("yesCaption", yesCaption);
	mData.SetString("noCaption", noCaption);
	mData.SetString("question", question);
	mData.SetObject("cost", CreateCostArray(cost));
	mData.SetBool("closeButton",closeButton);
	SetObject("mData",mData);

	if(!class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().CanSpendResources(cost))
	{
		mData.SetBool("yesDisabled", true);
		mYesButtonEnabled = false;
	}
	else
	{
		mYesButtonEnabled = true;
	}

	Update();

	mNoButtonEnabled = true;
	mCloseButtonEnabled = closeButton;

	OnYes = yesDelegate;
	OnNo = noDelegate;
	OnClose = closeDelegate;

	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().OpenPopup();
}

// sign post - OPTIONAL create new popup with wood-asset or something
function MessagePopup(String title,String message)
{
	OKPopup("<font size='#W_TITLE#'>" $ title $ "</font>\n<font size='#W_BODY#'>" $ message $ "</font>","OK",none);
}

function InputPopup(String question,String defaultInput,String yesCaption,String noCaption, delegate<OnYes> yesDelegate,delegate<OnNo> noDelegate)
{
	mData = CreateObject("Object");
	mData.SetString("yesCaption",yesCaption);
	mData.SetString("noCaption",noCaption);
	mData.SetString("question",question);
	mData.SetString("inputField",defaultInput);
	mData.SetBool("closeButton",false);
	SetObject("mData",mData);

	Update();

	mYesButtonEnabled = true;
	mNoButtonEnabled = true;
	mCloseButtonEnabled = false;

	OnYes = yesDelegate;
	OnNo = noDelegate;
	OnClose = none;

	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().OpenPopup();
}

private function Update()
{
	// Finish(); // this is needed in case requestpopup is killed by requestpopup, so that prev requestpopup finished callbacks etc correctly, but scary change for 1.5

	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		if(class'H7CombatController'.static.GetInstance() != none && class'H7CombatController'.static.GetInstance().GetActiveUnit() != none)
		{
			mData.SetObject("Color", CreateColorObject(class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPlayer().GetColor() ) );
		}
		else
		{
			mData.SetObject("Color", CreateColorObject( MakeColor(255,255,255,255) ) );
		}
	}
	else
	{
		if(class'H7AdventureController'.static.GetInstance() != none)
		{
			mData.SetObject("Color", CreateColorObject(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor()) );
		}
		else
		{
			mData.SetObject("Color", CreateColorObject( MakeColor(255,255,255,255) ) );
		}
	}

	ActionScriptVoid("Update");

	// prevent opening it with esc also instantly closes it
	mOpenedThisFrame = true;
	GetHud().SetFrameTimer(1,EndCloseProtection);
}

function bool WasOpenedThisFrame()
{
	return mOpenedThisFrame;
}
function EndCloseProtection()
{
	mOpenedThisFrame = false;
}

public function String GetInput()
{
	return ActionScriptString("GetInput");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Special Settings after Update

// warning - does not recalculate size
public function SetQuestionText(string newText)
{
	ActionScriptVoid("SetQuestionText");
}

// overwrites, have to be called after popup was set up
public function SetYesButtonState(bool val,String reason)
{
	mYesButtonEnabled = false;
	ActionScriptVoid("SetYesButtonState");
}

// overwrites, have to be called after popup was set up
public function SetNoButtonState(bool val,String reason)
{
	mNoButtonEnabled = false;
	ActionScriptVoid("SetNoButtonState");
}

// overwrites, have to be called after popup was set up
public function SetTimer(int seconds,delegate<OnTimerRunOut> timerDelegate)
{
	OnTimerRunOut = timerDelegate;
	class'H7PlayerController'.static.GetPlayerController().GetHud().SetSelfMadeTimer(seconds,TimerRunOut);
}

public function SetTutorialBG()
{
	ActionScriptVoid("SetTutorialBG");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Decisions/Clicks/Exits

public function TimerRunOut()
{
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().ClosePopup();
	OnTimerRunOut();
}

public function ClearTimer()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().ClearSelfMadeTimer(TimerRunOut);
}

public function Finish()
{
	if(IsVisible())
	{
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().ClosePopup();
		ExecuteFinishCallback();
	}
}

// CALL AFTER Finish();
// first needs to finish, because if someone (kismet) switches to next popup OnNo(), Finish() will kill the next popup
public function ExecuteFinishCallback()
{
	if(mCloseButtonEnabled) // Esc counts as close button clicked
	{
		OnClose();
	}
	else if(mNoButtonEnabled) // Esc counts as no button clicked
	{
		OnNo();
	}
	else if(mYesButtonEnabled)  // Esc counts as yes button clicked
	{
		OnYes();
	}
	else
	{
		// no callback
	}
}

public function YesButtonClicked(EventData data)
{
	;
	if(mYesButtonEnabled)
	{
		// first needs to finish, because if someone (kismet) switches to next popup OnYes(), Finish() will kill the next popup
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().ClosePopup();
		OnYes();
	}
	else
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Yes button failed",MD_QA_LOG);;
	}
}

public function NoButtonClicked(EventData data)
{
	;
	if(mNoButtonEnabled)
	{
		// first needs to finish, because if someone (kismet) switches to next popup OnNo(), Finish() will kill the next popup
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetRequestPopupCntl().ClosePopup();
		OnNo();
	}
	else
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("No button failed",MD_QA_LOG);;
	}
}

public function EscapePressed()
{
	if(mCloseButtonEnabled) // Esc counts as close button clicked
	{
		Finish();
	}
	else if(mNoButtonEnabled) // Esc counts as no button clicked
	{
		Finish();
	}
	else if(mYesButtonEnabled)  // Esc counts as yes button clicked
	{
		Finish();
	}
	else
	{
		// don't close it
	}
}
