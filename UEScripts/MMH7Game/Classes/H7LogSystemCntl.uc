//=============================================================================
// H7LogSystemCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7LogSystemCntl extends H7FlashMovieCntl;

var protected H7GFxLog                    mLog;
var protected H7GFxLogQA                  mQALog;
var protected H7GFxLogChat                mChat;

var protected H7GFxUIContainer mBorderBlack;

static function H7LogSystemCntl GetInstance()
{
	if(class'H7PlayerController'.static.GetPlayerController().GetHud() == none) { ScriptTrace(); }
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetLogCntl(); 
}

function    H7GFxLog                GetLog()                    {   return mLog; }
function    H7GFxLogChat            GetChat()                   {   return mChat; }
function    H7GFxLogQA              GetQALog()                  {   return mQALog; }
function    H7GFxUIContainer        GetBorderBlack()            {   return mBorderBlack; }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mLog = H7GFxLog(mRootMC.GetObject("aLog", class'H7GFxLog'));
	mQALog = H7GFxLogQA(mRootMC.GetObject("aQALog", class'H7GFxLogQA'));
	mChat = H7GFxLogChat(mRootMC.GetObject("aLog", class'H7GFxLogChat'));
	// all logs will be inited H7Hud.EnableTickFunctionality

	mBorderBlack = H7GFxUIContainer( mRootMC.GetObject( "mBorderBlack", class'H7GFxUIContainer' ));

	mBorderBlack.SetVisibleSave(false);

	mQALog.SetVisibleSave(class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_WINDOW"));

	Super.Initialize();
	return true;
}

function SetVisible(bool visible)
{
	mLog.SetVisibleSave(visible);
}

function LogOver(int id)
{
	local H7Message mes;
	mes = class'H7MessageSystem'.static.GetInstance().GetMessage(id);

	if(H7CreatureStack(mes.settings.referenceObject) != none)
	{
		H7CreatureStack(mes.settings.referenceObject).HighlightStack(true);
	}
	// TODO heroes when they have glow
}

function LogOut(int id)
{
	local H7Message mes;
	mes = class'H7MessageSystem'.static.GetInstance().GetMessage(id);

	if(H7CreatureStack(mes.settings.referenceObject) != none)
	{
		H7CreatureStack(mes.settings.referenceObject).DehighlightStack();
	}
	// TODO heroes when they have glow
}

function LogClick(int id)
{
	local H7Message mes;

	mes = class'H7MessageSystem'.static.GetInstance().GetMessage(id);

	if(Actor(mes.settings.referenceObject) != none)
	{
		class'H7Camera'.static.GetInstance().SetFocusActor(Actor(mes.settings.referenceObject));
	}
	else
	{
		;
	}
}

function SetLogStatus(String logName, bool status)
{
	if(logName == "aLog")
	{
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().SetLogStatus(status);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().SetQALogStatus(status);
	}
}


//////////////////////////////////////////////////////////////////////////////////////////////7
// CHAT
//////////////////////////////////////////////////////////////////////////////////////////////7

// flash calls this
function SendChatLine(string line,int channel)
{
	;

	if(line == "")
	{
		//if(!mLog.WasChatOpenedThisFrame()) GetLog().DeactivateChatInput();
		return;
	}

	class'H7PlayerController'.static.GetPlayerController().SendLobbyChat( line , EChatChannel(channel) );

	//mLog.DeactivateChatInput();
}

// call this to add a message to the chat window
function AddChatLine(string line,string playerName,EChatChannel channel)
{
	//local H7MessageSettings settings;
	local H7Message message;
	local string preText;
	local string targetPlayerName;
	;

	// 6 cases
	// me2all
	// player2all
	if(channel == CHAT_ALL)
	{
		if(playerName == class'H7PlayerController'.static.GetPlayerController().GetPlayerReplicationInfo().PlayerName)
		{
			preText = class'H7Loca'.static.LocalizeSave("CHAT_YOU_TO_ALL","H7Combat");
		}
		else
		{
			preText = Repl(class'H7Loca'.static.LocalizeSave("CHAT_PLAYER_TO_ALL","H7Combat"),"%player",playerName);
		}
	}
	// me2team
	// player2team
	else if(channel == CHAT_TEAM)
	{
		if(playerName == class'H7PlayerController'.static.GetPlayerController().GetPlayerReplicationInfo().PlayerName)
		{
			preText = class'H7Loca'.static.LocalizeSave("CHAT_YOU_TO_TEAM","H7Combat");
		}
		else
		{
			preText = Repl(class'H7Loca'.static.LocalizeSave("CHAT_PLAYER_TO_TEAM","H7Combat"),"%player",playerName);
		}
	}
	// me2player
	// player2me
	else
	{
		if(playerName == class'H7PlayerController'.static.GetPlayerController().GetPlayerReplicationInfo().PlayerName)
		{
			targetPlayerName = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(EPlayerNumber(channel - CHAT_WHISPER)).GetName();
			preText = Repl(class'H7Loca'.static.LocalizeSave("CHAT_YOU_TO_PLAYER","H7Combat"),"%player",targetPlayerName);
		}
		else
		{
			preText = Repl(class'H7Loca'.static.LocalizeSave("CHAT_PLAYER_TO_YOU","H7Combat"),"%player",playerName);
		}
	}
	
	message = new class'H7Message';
	message.text = "<font size='#W_BODY#'>" $ preText @ line $ "</font>";

	class'H7MessageSystem'.static.GetInstance().GetChat().AddMessage(message);
	class'H7LogSystemCntl'.static.GetInstance().GetChat().SwitchToChat();
}

