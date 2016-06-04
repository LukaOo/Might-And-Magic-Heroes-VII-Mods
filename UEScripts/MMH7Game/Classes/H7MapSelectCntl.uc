//=============================================================================
// H7SkirmishSetupWindowCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MapSelectCntl extends H7FlashMovieCntl implements (H7ContentScannerListener)
	dependson(H7MapDataHolder,H7ContentScanner,H7TransitionData)
	native;

var protected H7GFxMapList mMapSelection;
var protected array<H7ContentScannerAdventureMapData> mFoundMaps;           // listed maps in gui 1:1 (without all the filtered out maps)
var protected array<H7CampaignDefinition> mFoundCampaigns;  // listed campaigns in gui 1:1
//var protected bool isVisible;

var protected bool mLoadingThumb;
var protected H7Texture2DStreamLoad mMapThumbnail;
var protected int mCurrentCampaignMap; // number 1,2,3...7

var bool mIsMultiplayer;
var bool mIsHotseat;
var bool mIsLAN;

function H7GFxMapList GetMapList() { return mMapSelection; }

static function H7MapSelectCntl GetInstance() { return H7MainMenuHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetMapSelectCntl(); }

function bool Initialize()
{
	;

	Super.Start();

	AdvanceDebug(0);

	mMapSelection = H7GFxMapList(mRootMC.GetObject("aMapSelection", class'H7GFxMapList'));
	mMapSelection.SetVisibleSave(false);

	mMapThumbnail = new class'H7Texture2DStreamLoad';

	Super.Initialize();
	return true;
}

// singleplayer = false 
// multiplayer lan = true true
// multiplayer inet = true false
function Update(bool forMultiplayer,bool forLAN,bool hotseat)
{
	local H7ContentScannerAdventureMapData advData;
	
	mIsMultiplayer = forMultiplayer;
	mIsLAN = forLAN;
	mIsHotseat = hotseat;

	;
	mMapSelection.Update(mMapThumbnail);

	// add initial available maps
	foreach class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_AdventureData(advData)
		AddMap(advData);

	// add initial available campaigns
	if(!mIsMultiplayer)
	{
		AddInitialCustomCampaigns();
	}

	if(class'H7TransitionData'.static.GetInstance().GetContentScanner().mListeners.Find(self) == INDEX_NONE)
	{
		class'H7TransitionData'.static.GetInstance().GetContentScanner().mListeners.AddItem(self);
	}
	class'H7TransitionData'.static.GetInstance().GetContentScanner().TriggerListing(true, false, true);

	GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(true);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Custom Campaigns
///////////////////////////////////////////////////////////////////////////////////////////////////

function H7CampaignDefinition ConvertDataToDefinition(H7ContentScannerCampaignData campaignData)
{
	local H7CampaignDefinition campaignDefinition;
	campaignDefinition = new class'H7CampaignDefinition';   // This is slow!
	campaignDefinition.InitFromCampaignData(campaignData.CampaignData);
	return campaignDefinition;
}

function AddInitialCustomCampaigns()
{
	local int continueIndex;
	local array<H7ContentScannerCampaignData> campaignData;
	local array<H7CampaignDefinition> newCampaignDefinitions;
	local H7CampaignDefinition campaignDefinition;
	local int i;
	
	// TODO fill with semi-official campaigns: or put it in council
	// mFoundMaps = 

	campaignData = class'H7TransitionData'.static.GetInstance().GetContentScanner().mCollection_CampaignData;
	continueIndex = mFoundCampaigns.Length;

	for(i = 0; i < campaignData.Length; ++i)
	{
		campaignDefinition = ConvertDataToDefinition(campaignData[i]);
		newCampaignDefinitions.AddItem(campaignDefinition);
		mFoundCampaigns.AddItem(campaignDefinition);
	}
	
	mMapSelection.AddCustomCampaigns(newCampaignDefinitions,continueIndex);
}

function AddCampaign(H7ContentScannerCampaignData campaignData)
{
	local H7CampaignDefinition campaignDefinition;
	local array<H7CampaignDefinition> newCampaignDefinitions;
	local int continueIndex;

	continueIndex = mFoundCampaigns.Length;

	campaignDefinition = ConvertDataToDefinition(campaignData);
	newCampaignDefinitions.AddItem(campaignDefinition);
	mFoundCampaigns.AddItem(campaignDefinition);

	mMapSelection.AddCustomCampaigns(newCampaignDefinitions,continueIndex);
}

function SetCurrentCampaignMap(int number)
{
	mCurrentCampaignMap = number;
}

function CampaignClicked(int clickedListIndex)
{
	;
	mCurrentCampaignMap = 0; // = use current
	mMapSelection.NoThumbnailAvailable(); // TODO campaign picture
}

function string GetCampaignMapFileName(int campaignIndex,int mapNumber)
{
	local H7CampaignDefinition theCampaign;
	local string mapFileName;

	theCampaign = mFoundCampaigns[campaignIndex];
	if(mapNumber == 0) mapNumber = class'H7PlayerProfile'.static.GetInstance().GetNumCompletedMaps(theCampaign) + 1;
	mapFileName = theCampaign.GetMapByNumber(mapNumber);
	return mapFileName;
}

/////////////////LISTENERS////////////////
event OnScanned_AdventureMap(const out H7ContentScannerAdventureMapData AdvData)
{
	AddMap(advData);
}

event OnScanned_CombatMap(const out H7ContentScannerCombatMapData CombatData)
{

}

event OnScanned_Campaign(const out H7ContentScannerCampaignData CampaignData)
{
	AddCampaign(CampaignData);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

function bool CanBeSingleplayer(H7ContentScannerAdventureMapData mapData)
{
	local int forcedHuman;
	local H7MapHeaderPlayerInfoProperty playerInfo;
	// how many slots are forced human?
	foreach	mapData.AdventureMapData.mPlayerInfoProperties(playerInfo)
	{
		if(EPlayerSlot(playerInfo.Slot) == EPlayerSlot_Human) forcedHuman++;
	}
	return forcedHuman <= 1;
}

function bool CanBeMultiplayer(H7ContentScannerAdventureMapData mapData)
{
	local int canBeHuman;
	local H7MapHeaderPlayerInfoProperty playerInfo;
	// how many slots can be human?
	foreach	mapData.AdventureMapData.mPlayerInfoProperties(playerInfo)
	{
		if(EPlayerSlot(playerInfo.Slot) == EPlayerSlot_Human || EPlayerSlot(playerInfo.Slot)  == EPlayerSlot_UserDefine) canBeHuman++;
	}
	return canBeHuman > 1;
}

function AddMap(H7ContentScannerAdventureMapData advData)
{
	local int isThumbnailTextureReinitialized;
	local H7PlayerProfile profile;
	local H7ContentScannerAdventureMapData tempData;
	
	//if(mListingMap == none) return;

	;

	profile = class'H7PlayerProfile'.static.GetInstance();

	if(advData.AdventureMapData.mMapType == CAMPAIGN)		                                                        {	return;	}
	if(advData.AdventureMapData.mIsOfficial == false && advData.AdventureMapData.mIsValid == false)	                {	return;	}
	if(advData.AdventureMapData.mNeedsPrivileg && !profile.HasPrivileg(advData.AdventureMapData.mPrivilegID))		{	return;	}
	if((mIsMultiplayer || mIsHotseat) && !CanBeMultiplayer(advData))		                                        {	return;	}
	if(!(mIsMultiplayer || mIsHotseat) && !CanBeSingleplayer(advData))		                                        {	return;	}
	

	foreach mFoundMaps(tempData)
	{
		if(tempData == advData) return;
	}
	;
	
	mFoundMaps.AddItem(advData);
		
	if(!mLoadingThumb && advData.AdventureMapData.mIsThumbnailDataAvailable)
	{
		mMapThumbnail.SwitchStreamingTo(advData.Filename, advData.AdventureMapData.mThumbnailData, isThumbnailTextureReinitialized);
		mLoadingThumb = true;
		GetHUD().SetFrameTimer(1, updateThumbnail);
		if (isThumbnailTextureReinitialized == 1)
		{
			mMapSelection.ReloadThumbnail();
		}
	}
	

	mMapSelection.AddMap(advData,mFoundMaps.Length-1);
}

function StopScanner()
{
	class'H7TransitionData'.static.GetInstance().GetContentScanner().Stop();
}

function updateThumbnail()
{
	if(mLoadingThumb)
	{
		//`log_gui("updating thumb");
		mMapThumbnail.PerformUpdate();
		GetHUD().SetFrameTimer(1, updateThumbnail);
	}
}

function MapClicked(int clickedMapIndex)
{
	local int isThumbnailTextureReinitialized;
	local H7TextureRawDataOutput thumbnailData;

	;
	if(mFoundMaps[clickedMapIndex].AdventureMapData.mIsThumbnailDataAvailable)
	{
		;
		thumbnailData = mFoundMaps[clickedMapIndex].AdventureMapData.mThumbnailData;
		mMapThumbnail.SwitchStreamingTo(mFoundMaps[clickedMapIndex].Filename, thumbnailData, isThumbnailTextureReinitialized);
		if (isThumbnailTextureReinitialized == 1)
		{
			;
			mMapSelection.ReloadThumbnail();
		}
		mMapSelection.ShowThumbnail();
	}
	else
	{
		;
		mMapSelection.NoThumbnailAvailable();
	}
}

// map list 0.....length
// campaign list 0......length
function BtnContinueClicked(int selectedListIndex, bool isCampaign)
{
	local H7ContentScannerAdventureMapData mapData;
	local string mapFileName;

	if(isCampaign)
	{
		// campaign currently selected in flash
		;
		// get map to start
		mapFileName = GetCampaignMapFileName(selectedListIndex,mCurrentCampaignMap);
		class'H7PlayerProfile'.static.GetInstance().StartCampaignMap(mFoundCampaigns[selectedListIndex],mapFileName,false);
		return;
	}
	else
	{
		// map currently selected in flash
		mapData = mFoundMaps[selectedListIndex];
		;
	}
	
	if(mapData.Filename == "") 
	{
		;
		return;
	}

	if(mIsMultiplayer)
	{
		// open lobby
		// goto different main map
		class'H7MultiplayerGameManager'.static.GetInstance().CreateOnlineGame( 
			mIsLAN, false, mapData.AdventureMapData.mPlayerAmount, mapData 
		);
	}
	else
	{
		class'H7PlayerController'.static.GetPlayerController().InitLoadingScreen(None, true);
		class'Engine'.static.PlayLoadMapMovie();

		class'H7ReplicationInfo'.static.GetInstance().InitLobbyData(mapData,mIsHotseat,false);
		H7MainMenuHud(GetHUD()).GetSkirmishSetupWindowCntl().OpenPopup(class'H7ReplicationInfo'.static.GetInstance().mLobbyData,true,false,false,mIsHotseat);
	}

	// dont really close it, so we can get easily back to the list
	// ClosePopup();
	mMapSelection.SetVisibleSave(false);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Difficulty copy&paste
///////////////////////////////////////////////////////////////////////////////////////////////////

function array<H7DropDownEntry> GetEnumList(string enumName)
{
	local array<H7DropDownEntry> temp;

	if(H7MainMenuHud(GetHUD()) != none)
	{
		return H7MainMenuHud(GetHUD()).GetSkirmishSetupWindowCntl().GetEnumList(enumName);
	}

	// WOW
	temp = temp;
	return temp;
}

function SetCustomDifficulty(string enumName,int value)
{
	local H7DifficultyParameters diff;
	diff = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficulty();

	switch(enumName)
	{
		case "EDifficultyStartResources":
			diff.mStartResources = EDifficultyStartResources(value);
			break;
		case "EDifficultyCritterStartSize":
			diff.mCritterStartSize = EDifficultyCritterStartSize(value);
			break;
		case "EDifficultyCritterGrowthRate":
			diff.mCritterGrowthRate = EDifficultyCritterGrowthRate(value);
			break;
		case "EDifficultyAIEcoStrength":
			diff.mAiEcoStrength = EDifficultyAIEcoStrength(value);
			break;
	}

	class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(diff);
	DisplayDifficulty();
}

function SetDifficulty(int index,int value)
{
	local EDifficulty difficulty;
	local H7DifficultyParameters difParams;
	difficulty = EDifficulty(value);
	switch( difficulty )
	{
		case DIFFICULTY_EASY:
			difParams.mStartResources = DSR_ABUNDANCE;
			difParams.mCritterStartSize = DCSS_FEW;
			difParams.mCritterGrowthRate = DCGR_SLOW;
			difParams.mAiEcoStrength = DAIES_POOR;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_NORMAL:
			difParams.mStartResources = DSR_AVERAGE;
			difParams.mCritterStartSize = DCSS_AVERAGE;
			difParams.mCritterGrowthRate = DCGR_AVERAGE;
			difParams.mAiEcoStrength = DAIES_AVERAGE;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_HARD:
			difParams.mStartResources = DSR_LIMITED;
			difParams.mCritterStartSize = DCSS_MANY;
			difParams.mCritterGrowthRate = DCGR_FAST;
			difParams.mAiEcoStrength = DAIES_PROSPEROUS;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_HEROIC:
			difParams.mStartResources = DSR_SHORTAGE;
			difParams.mCritterStartSize = DCSS_HORDES;
			difParams.mCritterGrowthRate = DCGR_PROLIFIC;
			difParams.mAiEcoStrength = DAIES_RICH;
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(difParams);
			break;
		case DIFFICULTY_CUSTOM:
			// flash opens popup
			break;
	}
	
	DisplayDifficulty();
}

function DisplayDifficulty()
{
	local H7DifficultyParameters diff;
	;
	diff = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficulty();
	mMapSelection.DisplayDifficultySettings(
		class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficultyConverted(),
		diff.mStartResources,diff.mCritterStartSize,diff.mCritterGrowthRate,diff.mAiEcoStrength
	);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

function BtnBackClicked()
{
	ClosePopup();
}

function ClosePopup()
{
	StopScanner();
	class'H7TransitionData'.static.GetInstance().GetContentScanner().mListeners.RemoveItem(self);

	mFoundMaps.Length = 0;
	mMapSelection.Reset();
	mMapSelection.SetVisibleSave(false);
	GetHUD().GetLogCntl().GetBorderBlack().SetVisibleSave(false);

	H7MainMenuHud(GetHud()).GetMainMenuCntl().GetMainMenu().SetVisibleSave(true);
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

