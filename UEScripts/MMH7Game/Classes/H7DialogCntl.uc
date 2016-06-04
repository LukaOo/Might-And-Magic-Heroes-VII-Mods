//=============================================================================
// H7DialogCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7DialogCntl extends H7FlashMovieBlockPopupCntl
	dependson(H7SkirmishSetupWindowCntl);

var protected H7GFxDialog mDialog;
var protected H7GFxCouncilDialog mCouncilDialog;
var protected H7GFxNarrationDialog mNarrationDialog;
var protected H7GFxUIContainer mNarrationTop;
var protected H7GFxMapControls mMapControls;
var protected H7GFxUIContainer mSubtitle;
var protected H7GFxUIContainer mPopUpCustomDifficulty;

var protected H7GFxUIContainer mCurrentDialog; // reference

var protected H7SeqAct_BaseDialogue mNode;

var protected H7CampaignDefinition mSelectedCampaign;
var protected string mSelectedMap;
var protected int mSelectedPrevOnIndex;
var protected bool mCustomDifficultyVisible;

static function H7DialogCntl GetInstance()  { return class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl(); }

function H7GFxDialog GetDialog() { return mDialog; }
function H7GFxCouncilDialog GetCouncilDialog() { return mCouncilDialog; }
function H7GFxNarrationDialog GetNarrationDialog() { return mNarrationDialog; }
function H7GFxUIContainer GetNarrationTop() { return mNarrationTop; }
function H7GFxMapControls GetMapControls() { return mMapControls; }
function H7GFxUIContainer GetSubtitle() { return mSubtitle; }
function H7GFxUIContainer GetPopup() { return mCurrentDialog; }
function SetVisible(bool visible){	mDialog.SetVisibleSave(visible);}
function H7CampaignDefinition GetSelectedCampaign() { return mSelectedCampaign;}

function bool Initialize() 
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mDialog = H7GFxDialog(mRootMC.GetObject("aDialog", class'H7GFxDialog'));
	mDialog.SetVisibleSave(false);

	mCouncilDialog = H7GFxCouncilDialog(mRootMC.GetObject("aCouncilDialog", class'H7GFxCouncilDialog'));
	mCouncilDialog.SetVisibleSave(false);
	mCouncilDialog.Init();

	mNarrationDialog = H7GFxNarrationDialog(mRootMC.GetObject("aNarrationDialog", class'H7GFxNarrationDialog'));
	mNarrationDialog.SetVisibleSave(false);
	
	mNarrationTop = H7GFxUIContainer(mRootMC.GetObject("aNarrationTop", class'H7GFxUIContainer'));
	mNarrationTop.SetVisibleSave(false);

	mMapControls = H7GFxMapControls(mRootMC.GetObject("aMapControl", class'H7GFxMapControls'));
	mMapControls.SetVisibleSave(false);

	mSubtitle = H7GFxUIContainer(mRootMC.GetObject("aSubtitle", class'H7GFxUIContainer'));
	mSubtitle.SetVisibleSave(false);

	mPopUpCustomDifficulty = H7GFxUIContainer(mRootMC.GetObject("mPopUpCustomDifficulty", class'H7GFxUIContainer'));
	mPopUpCustomDifficulty.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function InitWindowKeyBinds()
{
	CreatePopupKeybind('Enter',"DialogConfirm",GoForward,'SpaceBar');
	//CreatePopupKeybind('Escape',"DialogSkip",Closed);
	CreatePopupKeybind('Right',"DialogForward",GoForward);
	CreatePopupKeybind('Left',"DialogBackward",GoBack,'BackSpace');

	super.InitWindowKeyBinds();
}

function bool GetCurrentAutoPlay()
{
	if(mNode != none)
	{
		return mNode.GetLocalAutoPlaySetting();
	}
	else
	{
		;
	}
	return false;
}

function GoBack()
{
	local array<int> storyPoints;
	
	;
	if(mNode != none) // dialog
	{
		mNode.SetLocalAutoPlaySetting(false);
		mNode.OnPreviousLine();
	}
	else // prev on
	{
		storyPoints = class'H7PlayerProfile'.static.GetInstance().GetStoryPointsByMap(mSelectedMap);
		ShowMapGUI(,,Clamp(mSelectedPrevOnIndex-1,-1,storyPoints.Length-1));
	}
}

function GoForward()
{
	local array<int> storyPoints;
	
	;
	if(mNode != none) // dialog
	{
		mNode.SetLocalAutoPlaySetting(false);
		mNode.OnNextLine();
	}
	else // prev on
	{
		storyPoints = class'H7PlayerProfile'.static.GetInstance().GetStoryPointsByMap(mSelectedMap);
		ShowMapGUI(,,Clamp(mSelectedPrevOnIndex+1,-1,storyPoints.Length-1));
	}
}

function Stop()
{
	;
	if(mNode.GetLocalAutoPlaySetting())
	{
		mNode.SetLocalAutoPlaySetting(false);
		mNode.StopVoiceOver();
	}
}

function Play()
{
	;
	mNode.StopVoiceOver();
	if(!mNode.GetLocalAutoPlaySetting())
	{
		mNode.SetLocalAutoPlaySetting(true);
		mNode.StartVoiceOver();
	}
}

function ClosePopup()
{
	super.ClosePopup();

	if(mCurrentDialog.IsA('H7GFxNarrationDialog')) 
	{
		mNarrationTop.SetVisibleSave(false);

		// this is to change back from narration to normal gui
		class'H7PlayerController'.static.GetPlayerController().GetHud().SetHUDMode(HM_NORMAL);
	}
	if(mCurrentDialog.IsA('H7GfxCouncilDialog'))
	{
		// council-intervention or prevOn-view in council or adventure map
		class'H7PlayerController'.static.GetPlayerController().GetHud().GetDialogCntl().GetMapControls().SetVisibleSave(false);

		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none) // in council
		{
			class'H7CouncilManager'.static.GetInstance().SetCouncilState(CS_CouncilView); // change back to council view
		}
		else // in adventure map
		{
			// change back to normal adventuremap gui
			if( class'H7AdventureController'.static.GetInstance().IsCouncilMapActive() ) 
			{
				class'H7AdventureController'.static.GetInstance().SwitchToAdventureMap();
			}
			class'H7PlayerController'.static.GetPlayerController().GetHud().SetHUDMode(HM_NORMAL);
		}
	}

	mSelectedCampaign = none;
	mSelectedMap = "";
	mSelectedPrevOnIndex = -1;

	if(mNode != none)
	{
		mNode.OnClose();
	}
	mNode = none;
}

function Closed() // button pressed in flash
{
	ClosePopup();
}

function SetNode(H7SeqAct_BaseDialogue node)
{
	mNode = node;
	mNode.Initialize();
}

function OpenPopupSpecific(H7GFxUIContainer element,optional bool blockLayer=true,optional bool blockInput=true)
{
	if(element.IsA('H7GFxNarrationDialog')) mNarrationTop.SetVisibleSave(true);

	mBlockFlash = blockLayer;
	mBlockUnreal = blockInput;

	mCurrentDialog = element;
	super.OpenPopup();
	//else GetPopup().SetVisibleSave(true);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
// MAP CONTROLS
///////////////////////////////////////////////////////////////////////////////////////////////////

function SelectCampaign(string campaignAID) // clicked in flash (drop down or portrait)
{
	local string mapFileName;

	;
	mSelectedCampaign = class'H7GameData'.static.GetInstance().GetCampaignByID(campaignAID);
	mSelectedMap = "";
	mSelectedPrevOnIndex = -1;

	if(mSelectedCampaign != class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef)
	{
		;
	}

	if(class'H7PlayerProfile'.static.GetInstance().IsCampaignStarted(mSelectedCampaign))
	{
		mapFileName = class'H7PlayerProfile'.static.GetInstance().GetCampaignDataByDef(mSelectedCampaign).CurrentMap.MapFileName;

		class'H7CouncilMapManager'.static.GetInstance().SelectFlag(class'H7CouncilMapManager'.static.GetInstance().GetFlagByMapName(mapFileName),false);
	}
	else
	{
		mapFileName = mSelectedCampaign.GetMapByIndex(0);

		class'H7CouncilMapManager'.static.GetInstance().SelectFlag(class'H7CouncilMapManager'.static.GetInstance().GetFlagByMapName(mapFileName),false);	
	}

	ShowMapGUI(mSelectedCampaign);
}

function SelectMap(string mapFileName) // clicked in flash
{
	;
	mSelectedCampaign = class'H7GameData'.static.GetInstance().GetCampaignOfMap(mapFileName);
	mSelectedMap = mapFileName;
	mSelectedPrevOnIndex = -1;
	ShowMapGUI();
	class'H7CouncilMapManager'.static.GetInstance().SelectFlag(class'H7CouncilMapManager'.static.GetInstance().GetFlagByMapName(mapFileName),false);
}

function DisplayMap(string mapFileName) // clicked on 3dworld marker
{
	if( !GetCouncilDialog().IsPrevOnMode() ) return;

	;
	mSelectedCampaign = class'H7GameData'.static.GetInstance().GetCampaignOfMap(mapFileName);
	mSelectedMap = mapFileName;
	mSelectedPrevOnIndex = -1;
	ShowMapGUI();
}

function InitMapGUI()
{
	local array<H7CampaignDefinition> campaigns;
	local array<string> maps;

	// top
	class'H7GameData'.static.GetInstance().GetCampaigns(campaigns);
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetDialogCntl().GetMapControls().SetAvailableCampaigns(campaigns);
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetDialogCntl().GetMapControls().SetVisibleSave(true);

	class'H7CouncilMapManager'.static.GetInstance().GetUnlockedMapsName(maps);

	/* for testing 
	maps.AddItem("AM_Haven_Map1");
	maps.AddItem("AM_Haven_Map2");
	maps.AddItem("AM_Haven_Map3");
	maps.AddItem("AM_Haven_Map4");
	maps.AddItem("AM_Academy_Map1");
	maps.AddItem("AM_Academy_Map2");
	maps.AddItem("AM_Academy_Map3");
	maps.AddItem("AM_Academy_Map4");
	maps.AddItem("AM_Stronghold_Map1");
	maps.AddItem("AM_Stronghold_Map2");
	maps.AddItem("AM_Stronghold_Map3");
	maps.AddItem("AM_Stronghold_Map4");
	maps.AddItem("AM_Necropolis_Map1");
	maps.AddItem("AM_Necropolis_Map2");
	maps.AddItem("AM_Necropolis_Map3");
	maps.AddItem("AM_Necropolis_Map4");
	maps.AddItem("AM_Necropolis_Map5");
	maps.AddItem("AM_Dungeon_Map1");
	maps.AddItem("AM_Dungeon_Map2");
	maps.AddItem("AM_Dungeon_Map3");
	maps.AddItem("AM_Dungeon_Map4");
	maps.AddItem("AM_Sylvan_Map1");
	maps.AddItem("AM_Sylvan_Map2");
	maps.AddItem("AM_Sylvan_Map3");
	maps.AddItem("AM_Sylvan_Map4");
	maps.AddItem("AM_Final_Map1");
	maps.AddItem("AM_Final_Map2");
	*/
	
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetDialogCntl().GetMapControls().SetAvailableMaps(maps);
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetDialogCntl().GetMapControls().SetVisibleSave(true);

	ShowMapGUI();
}

function ShowMapGUI(optional H7CampaignDefinition selectedCampaign,optional string mapFileName,optional int prevOnIndex=-2)
{
	local string showCampaignAID;
	local array<int> storyPoints;
	local H7EditorHero speaker;	
	local array<H7CampaignDefinition> campaigns;

	// calculate params:
	if(selectedCampaign == none) 
	{
		if(mSelectedCampaign == none)
		{
			if(class'H7PlayerProfile'.static.GetInstance().HasCurrentCampaign())
			{
				selectedCampaign = class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef;
			}
			else
			{
				class'H7GameData'.static.GetInstance().GetCampaigns(campaigns);
				selectedCampaign = campaigns[0];
			}
		}
		else
		{
			selectedCampaign = mSelectedCampaign;
		}
	}
	mSelectedCampaign = selectedCampaign;

	if(mapFileName == "")
	{
		if(mSelectedMap == "")
		{
			if(class'H7PlayerProfile'.static.GetInstance().HasCurrentCampaign())
			{
				if(class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CampaignRef.IsSameCampaign(selectedCampaign) )
				{
					mapFileName = class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CurrentMap.MapFileName;
				}
				else
				{
					mapFileName = selectedCampaign.GetMapByNumber(1);
				}
			}
			else
			{
				mapFileName = selectedCampaign.GetMapByNumber(1);
			}
		}
		else
		{
			mapFileName = mSelectedMap;
		}
	}
	mSelectedMap = mapFileName;

	// Get storypoints by map
	storyPoints = class'H7PlayerProfile'.static.GetInstance().GetStoryPointsByMap(mapFileName);

	showCampaignAID = string(selectedCampaign);
	GetMapControls().DisplayCampaign(showCampaignAID);

	// bottom
	speaker = selectedCampaign.GetCouncillor();

	// test
	//storyPoints = class'H7PlayerProfile'.static.GetInstance().GetCurrentCampaign().CompletedMaps[0].UnlockedStorypoints;
	//showMap = "AM_Haven_Map1";
	//showMap = "adventuremap";
	
	if(!IsDialogInProgress()) // because the init of the first map prev on comes later than the already started dialog and fucks it up
	{
		DisplayPrevOn(speaker,storyPoints,mapFileName,prevOnIndex);
	}
	GetMapControls().UpdateMarkerStates(showCampaignAID,mapFileName);
}

function bool IsDialogInProgress()
{
	if(mCouncilDialog.IsVisible() && mCouncilDialog.IsDialogShowing()) return true;
}

function string GetFailSaveMapDescription(string mapFileName,optional out int descriptionFailed)
{
	local string infoName,description;

	infoName = "H7MapInfo_" $ class'H7GameData'.static.GetInstance().GetCampaignOfMap(mapFileName).GetMapInfoNumberOfMap(mapFileName);
	description = class'H7Loca'.static.LocalizeMapInfoObjectByName(
		infoName,
		mapFileName,
		"mDescription",
		"Description not found"
	);
	if(description == "Description not found" || description == "")
	{
		description = class'H7Loca'.static.LocalizeMapInfoObjectByName(
			infoName,
			mapFileName,
			class'H7Loca'.static.GetArrayFieldName("mPreviouslyOn",0),
			"No Description or Previously On 0 found"
		);
	}

	return description;
}

// -2 undefined -> jump to last story point
// -1 general description (mDescription or mPreviouslyOn[0]
// 0 first unlocked story point i.e. 3
// 1 second unlocked story point i.e. 5
function DisplayPrevOn(H7EditorHero speaker,array<int> storyPoints,string mapFileName,optional int displayedPoint=-2)
{
	local string text,mapLocaName,headline;
	local string infoName;
	local bool hasPrev,hasNext,campaignLocked;
	local H7CampaignDefinition campaign;
	
	;

	displayedPoint = Clamp(displayedPoint,-2,storyPoints.Length-1);

	if(displayedPoint == -2)
	{
		displayedPoint = storyPoints.Length-1;
	}
	mSelectedPrevOnIndex = displayedPoint;

	infoName = "H7MapInfo_" $ class'H7GameData'.static.GetInstance().GetCampaignOfMap(mapFileName).GetMapInfoNumberOfMap(mapFileName);

	mapLocaName = class'H7Loca'.static.LocalizeMapInfoObjectByName(infoName,mapFileName,"mName",mapFileName);

	if(displayedPoint == -1)
	{
		text = GetFailSaveMapDescription(mapFileName);
	}
	else if(storyPoints.Length > 0)
	{
		text = class'H7Loca'.static.LocalizeMapInfoObjectByName(
			infoName,
			mapFileName,
			class'H7Loca'.static.GetArrayFieldName("mPreviouslyOn",displayedPoint),
			"Previously On" @ (displayedPoint+1) @ "not found"
		);
	}
	else // no story points
	{
		text = GetFailSaveMapDescription(mapFileName);
	}

	campaign = class'H7GameData'.static.GetInstance().GetCampaignOfMap(mapFileName);
	if(campaign.GetAID() == "IvanCampaign") // archetype name hack bc special design
	{
		if(class'H7PlayerProfile'.static.GetInstance().GetNumCompletedCampaigns() < 2)
		{
			campaignLocked = true;
		}
	}

	if(campaignLocked)
	{
		headline = campaign.GetName();
		text = "CAMPAIGN_LOCKED";
	}
	else if(storyPoints.Length > 0)
	{
		headline = Repl(class'H7Loca'.static.LocalizeSave("PREV_ON","H7MainMenu"),"%map",mapLocaName); 
	}
	else
	{
		headline = mapLocaName;
	}

	hasPrev = displayedPoint > -1;
	hasNext = displayedPoint < storyPoints.Length - 1;

	GetCouncilDialog().ShowPrevOn(speaker,headline,text,hasPrev,hasNext,GetActionCaptionForMap(mapFileName));
	DisplayDifficulty();
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// DIFFICULTY 
///////////////////////////////////////////////////////////////////////////////////////////////////

function DisplayDifficulty()
{
	local H7DifficultyParameters diff;
	//`log_dui("DisplayDifficulty");
	diff = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficulty();
	GetCouncilDialog().DisplayDifficultySettings(
		class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficultyConverted(),
		diff.mStartResources,diff.mCritterStartSize,diff.mCritterGrowthRate,diff.mAiEcoStrength
	);
}

function SetCustomDifficultyVisible(bool visible)
{
	mCustomDifficultyVisible = visible;
}

function bool IsCustomDifficultyVisible()
{
	return mCustomDifficultyVisible;
}

function CloseCustomDifficulty()
{
	mPopUpCustomDifficulty.SetVisibleSave(false);
	mCustomDifficultyVisible = false;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
function HideMapGUI()
{
	//ClosePopup(); // for some reason breaks matinee transitions
	// but we still need mCurrentContext to be reset, or a closing requestpopup will think its active and do a blocklayer
	GetHUD().SetCurrentContext(none);
	GetMapControls().SetVisibleSave(false);
	GetCouncilDialog().SetVisibleSave(false);
}

function StartCurrentContext()
{
	local H7PlayerProfile playerProfile;
	local AkEvent confirmCampaignEvent;

	playerProfile = class'H7PlayerProfile'.static.GetInstance();

	if(playerProfile == none)
	{
		;
		return;
	}
	;

	class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetVoiceOverStopAllEvent(),true);
	
	if(!class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorInfo().isIvan)
	{
		//Ivan Voiceover for confirm 
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none)
		{
			confirmCampaignEvent = H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()).ProgressDependantSelectionConfirmAkEvent(class'H7CouncilManager'.static.GetInstance().GetCurrentCouncillorInfo());
		}

		if(confirmCampaignEvent != none)
		{
			class'H7SoundController'.static.PlayGlobalAkEvent(confirmCampaignEvent,true,, true);
		}
	}

	if(playerProfile.IsCampaignEverStarted(mSelectedCampaign))
	{
		// replay or start -> directly map start
		playerProfile.StartCampaignMap(mSelectedCampaign, mSelectedMap);
	}
	else
	{
		// start first map -> matinee -> map
		playerProfile.StartCampaignMap(mSelectedCampaign);
	}
}

// begin(campaign), replay, start or continue
function string GetActionCaptionForMap(string mapFileName)
{
	local H7CampaignDefinition theCampaign;

	theCampaign = class'H7GameData'.static.GetInstance().GetCampaignOfMap(mapFileName);

	if(class'H7PlayerProfile'.static.GetInstance().IsCampaignEverStarted(theCampaign))
	{
		// replay or start
		if(class'H7PlayerProfile'.static.GetInstance().IsMapCompletedInCampaign(theCampaign,theCampaign.GetMapIndex(mapFileName)))
		{
			return "REPLAY";
		}
		else
		{
			return "START";
		}
	}
	else
	{
		// start first map -> matinee -> map
		return "BEGIN";
	}
}

function bool IsInAdvMap()
{
	return class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap();
}

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

// dev only
function SetMapPixel(string map,int pixel)
{
	


}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Subtitles
///////////////////////////////////////////////////////////////////////////////////////////////////

function ShowSubtitle(string text)
{
	if(class'H7OptionsManager'.static.GetInstance().GetSettingBool("SUBTITLE_ENABELED"))
	{
		StartAdvance();
		// fake bink look
		;
		mCurrentDialog = mSubtitle;
		mSubtitle.SetVisibleSave(true);
		mSubtitle.ActionScriptVoid("SetSubTitle");
	}
}

function HideSubtitle()
{
	mCurrentDialog = none;
	mSubtitle.SetVisibleSave(false);
}

///////////////////////////////////////////////////////////////////////////////////////////////////

