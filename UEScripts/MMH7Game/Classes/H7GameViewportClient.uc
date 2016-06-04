class H7GameViewportClient extends GameViewportClient
	native;

var int mCursorType;

var Font mLoadingScreenFont;
var Font mLoadingScreenFontINT;
var Font mLoadingScreenFontCHN;
var Font mLoadingScreenFontCHT;
var Font mLoadingScreenFontCZE;
var Font mLoadingScreenFontDEU;
var Font mLoadingScreenFontESN;
var Font mLoadingScreenFontFRA;
var Font mLoadingScreenFontHUN;
var Font mLoadingScreenFontITA;
var Font mLoadingScreenFontKOR;
var Font mLoadingScreenFontPOL;
var Font mLoadingScreenFontPTB;
var Font mLoadingScreenFontRUM;
var Font mLoadingScreenFontRUS;

var MaterialInterface mMainBackground;
var MaterialInterface mCombatBackground;

var string mCurrentHint;
var array<string> mGameHints;
var Vector mHintSize;

var MaterialInterface mWheelMat;

var H7LoadingHints mHintsArchetype;

function SetCursor(byte cursorNum)
{
	mCursorType = cursorNum + 11; // index must start at 11, it's where the custom ones do
}

function DrawTransitionMessage(Canvas Canvas,string Message)
{
	// empty function to avoid drawing of 'PAUSED' and 'LOADING' messages on-screen
}

function string LoadRandomHint()
{
	local array<string> theHints;

	mHintsArchetype.InitHints();
	theHints = mHintsArchetype.GetHints();

	return theHints[Rand(theHints.Length)];
}

function InitLoadscreen( optional MaterialInterface newBackground, optional bool isCombat)
{
	LoadLanguageFont();

	if (isCombat)
	{
		mMainBackground = mCombatBackground;
	}
	else
	{
		if (newBackground != None)
		{
			mMainBackground = newBackground;
		}
		else
		{
			mMainBackground = default.mMainBackground;
		}
	}

	mCurrentHint = LoadRandomHint();
}

function LoadLanguageFont()
{
	local string currLang;

	currLang = GetLanguage();
	if (currLang == "CHN")
	{
		mLoadingScreenFont = mLoadingScreenFontCHN;
	}
	else if (currLang == "CHT")
	{
		mLoadingScreenFont = mLoadingScreenFontCHT;
	}
	else if (currLang == "CZE")
	{
		mLoadingScreenFont = mLoadingScreenFontCZE;
	}
	else if (currLang == "DEU")
	{
		mLoadingScreenFont = mLoadingScreenFontDEU;
	}
	else if (currLang == "ESN")
	{
		mLoadingScreenFont = mLoadingScreenFontESN;
	}
	else if (currLang == "FRA")
	{
		mLoadingScreenFont = mLoadingScreenFontFRA;
	}
	else if (currLang == "HUN")
	{
		mLoadingScreenFont = mLoadingScreenFontHUN;
	}
	else if (currLang == "ITA")
	{
		mLoadingScreenFont = mLoadingScreenFontITA;
	}
	else if (currLang == "KOR")
	{
		mLoadingScreenFont = mLoadingScreenFontKOR;
	}
	else if (currLang == "POL")
	{
		mLoadingScreenFont = mLoadingScreenFontPOL;
	}
	else if (currLang == "PTB")
	{
		mLoadingScreenFont = mLoadingScreenFontPTB;
	}
	else if (currLang == "RUM")
	{
		mLoadingScreenFont = mLoadingScreenFontRUM;
	}
	else if (currLang == "RUS")
	{
		mLoadingScreenFont = mLoadingScreenFontRUS;
	}
	else
	{
		mLoadingScreenFont = mLoadingScreenFont;
	}
}

native function bool IsVSync();
native function SetVSync(bool IsEnabled);


/**
 * Notifies the player that an attempt to connect to a remote server failed, or an existing connection was dropped.
 *
 * @param MessageType EProgressMessageType of current connection error
 * @param	Message		a description of why the connection was lost
 * @param	Title		the title to use in the connection failure message.
 */
function NotifyConnectionError(EProgressMessageType MessageType, optional string Message=Localize("Errors", "ConnectionFailed", "Engine"), optional string Title=Localize("Errors", "ConnectionFailed_Title", "Engine") )
{
	local WorldInfo WI;

	WI = class'Engine'.static.GetCurrentWorldInfo();
	;
	if (WI.NetMode != NM_Standalone)
	{
		if ( WI.Game != None )
		{
			// Mark the server as having a problem
			WI.Game.bHasNetworkError = true;
		}

		class'H7TransitionData'.static.GetInstance().SetMPClientLostConnectionToServer( true );

		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			class'H7AdventureController'.static.GetInstance().TrackingMapEnd("Connection Error");
			class'H7AdventureController'.static.GetInstance().TrackingGameModeEnd();
		}
		else  // then its a duel map
		{
			class'H7CombatController'.static.GetInstance().TrackingMapEnd("Connection Error");
			class'H7CombatController'.static.GetInstance().TrackingGameModeEnd();
		}
		//@todo: should we have a Travel() function in this class?
		ConsoleCommand("start ?failed");
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

