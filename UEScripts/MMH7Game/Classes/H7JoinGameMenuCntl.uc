//=============================================================================
// H7JoinGameMenuCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7JoinGameMenuCntl extends H7FlashMoviePopupCntl
	dependson(H7StructsAndEnums);

var protected H7Texture2DStreamLoad mMapThumbnail;
var protected string mMapThumbnailPath;
var protected bool mThumbnailActive;
var protected bool mNatUpdaterActive;

var protected H7GFxJoinGameMenu mJoinGameMenu;

var protected GFxCLIKWidget mButtonRefresh;
var protected GFxCLIKWidget mButtonClose;

function H7GFxJoinGameMenu GetLobbyList() { return mJoinGameMenu; }
function H7GFxUIContainer GetPopup() { return mJoinGameMenu; }

static function H7JoinGameMenuCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetMainMenuHud().GetLobbySelectCntl(); }

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);
	
	mJoinGameMenu = H7GFxJoinGameMenu(mRootMC.GetObject("aJoinGameMenu", class'H7GFxJoinGameMenu'));
	mJoinGameMenu.SetVisibleSave( false );

	mMapThumbnail = new class'H7Texture2DStreamLoad';
	mMapThumbnailPath = "img://" $ Pathname(mMapThumbnail);
	mJoinGameMenu.ReloadThumbnail( mMapThumbnailPath );

	Super.Initialize();
	return true;
}

function InitializeBrowserList(array<OnlineGameSearchResult> SearchResults )
{
	;

	GetLobbyList().SetGames( SearchResults );
}

function RegisterNatUpdater(bool register)
{
	if(register && !mNatUpdaterActive)
	{
		mNatUpdaterActive = true;
		GetHUD().SetFrameTimer(1,UpdateNatDisplay);
	}
	else if(!register && mNatUpdaterActive)
	{
		mNatUpdaterActive = false;
	}
}

function UpdateNatDisplay()
{
	local int statusCode;
	local bool upnp;

	if(mNatUpdaterActive)
	{
		GetHUD().SetFrameTimer(1,UpdateNatDisplay);
	}

	if(OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).mRDVManager != none)
	{
		statusCode = OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).mRDVManager.mStormManager.mNatType;
		upnp = OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).mRDVManager.mStormManager.mIsUPnPMappingDone;
	}

	mJoinGameMenu.UpdateNatDisplay(statusCode,upnp);
}

function JoinGame(String serverName,int index)
{
	class'H7TransitionData'.static.GetInstance().GetContentScanner().Stop();
	;
	class'H7MultiplayerGameManager'.static.GetInstance().JoinSelected( index );
}

function RefreshGameList()
{
	;
	class'H7MultiplayerGameManager'.static.GetInstance().RefreshOnlineGames();
}

// data arrives via different function: InitializeBrowserList
function SetActive( bool visible, bool isLan, bool isDuel )
{
	if( visible )
	{
		OpenPopup();
		GetLobbyList().SetLANDuelMode(isLan,isDuel);

		class'H7TransitionData'.static.GetInstance().GetContentScanner().TriggerListing(true, true, false);
		if(!isLan) 
		{
			RegisterNatUpdater(true);
		}
		else
		{
			mJoinGameMenu.UpdateNatDisplay(0); // hidden
		}
	}
	else
	{
		ClosePopup();
	}
}

function string GetMapSize(string mapFileName)
{
	local array<H7ContentScannerAdventureMapData> advMaps;
	local H7ContentScannerAdventureMapData advMap;
	local array<H7ContentScannerCombatMapData> combatMaps;
	local H7ContentScannerCombatMapData combatMap;
	local EH7MapSize mapSize;

	advMaps = class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_AdventureData;
	foreach advMaps(advMap)
	{
		if(Caps(advMap.Filename) == Caps(mapFileName))
		{
			mapSize = EH7MapSize(advMap.AdventureMapData.mMapSize);
			return string(mapSize);
		}
	}

	combatMaps = class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_CombatData;
	foreach combatMaps(combatMap)
	{
		if(Caps(combatMap.Filename) == Caps(mapFileName))
		{
			return combatMap.CombatMapData.mMapSizeX @ "x" @ combatMap.CombatMapData.mMapSizeY;
		}
	}
	
	return "UNKNOWN";
}

function string GetMapType(string mapFileName)
{
	local array<H7ContentScannerAdventureMapData> advMaps;
	local H7ContentScannerAdventureMapData advMap;
	local EMapType mapType;
	
	advMaps = class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_AdventureData;
	foreach advMaps(advMap)
	{
		if(Caps(advMap.Filename) == Caps(mapFileName))
		{
			mapType = EMapType(advMap.AdventureMapData.mMapType);
			return string(mapType);
		}
	}
	
	return "UNKNOWN";
}

function GameClicked(string mapFileName)
{
	local int isThumbnailTextureReinitialized,i,clickedMapIndex;
	local H7TextureRawDataOutput thumbnailData;
	local array<H7ContentScannerAdventureMapData> advMaps;
	local H7ContentScannerAdventureMapData advMap;
	local array<H7ContentScannerCombatMapData> combatMaps;
	local H7ContentScannerCombatMapData combatMap;

	advMaps = class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_AdventureData;
	combatMaps = class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_CombatData;

	foreach advMaps(advMap,i)
	{
		if(Caps(advMap.Filename) == Caps(mapFileName))
		{
			clickedMapIndex = i;
			;
			if(advMaps[clickedMapIndex].AdventureMapData.mIsThumbnailDataAvailable)
			{
				;
				thumbnailData = advMaps[clickedMapIndex].AdventureMapData.mThumbnailData;
				mMapThumbnail.SwitchStreamingTo(advMaps[clickedMapIndex].Filename, thumbnailData, isThumbnailTextureReinitialized);

				if(!mThumbnailActive)
				{
					mThumbnailActive = true;
					GetHUD().SetFrameTimer(1, updateThumbnail);
				}

				if (isThumbnailTextureReinitialized == 1)
				{
					;
					;
					;
					mJoinGameMenu.ReloadThumbnail( mMapThumbnailPath );
				}
				mJoinGameMenu.ShowThumbnail();
			}
			else
			{
				;
				mJoinGameMenu.NoThumbnailAvailable();
			}
			return;
		}
	}

	foreach combatMaps(combatMap,i)
	{
		if(Caps(combatMap.Filename) == Caps(mapFileName))
		{
			clickedMapIndex = i;
			;
			if(combatMaps[clickedMapIndex].CombatMapData.mIsThumbnailDataAvailable)
			{
				;
				thumbnailData = combatMaps[clickedMapIndex].CombatMapData.mThumbnailData;
				mMapThumbnail.SwitchStreamingTo(combatMaps[clickedMapIndex].Filename, thumbnailData, isThumbnailTextureReinitialized);
				
				if(!mThumbnailActive)
				{
					mThumbnailActive = true;
					GetHUD().SetFrameTimer(1, updateThumbnail);
				}

				if (isThumbnailTextureReinitialized == 1)
				{
					;
					mJoinGameMenu.ReloadThumbnail( "img://" $ Pathname(mMapThumbnail) );
				}
				mJoinGameMenu.ShowThumbnail();
			}
			else
			{
				;
				mJoinGameMenu.NoThumbnailAvailable();
			}
			return;
		}
	}
}

function updateThumbnail()
{
	if(mThumbnailActive)
	{
		//`log_gui("updating thumb");
		mMapThumbnail.PerformUpdate();
		GetHUD().SetFrameTimer(1, updateThumbnail);
	}
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	class'H7TransitionData'.static.GetInstance().GetContentScanner().Stop();

	RegisterNatUpdater(false);
	mThumbnailActive = false;
	super.ClosePopup();
	H7MainMenuHud(GetHud()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(true);
	class'H7MultiplayerGameManager'.static.GetInstance().CancelFindOnlineGames();
}

