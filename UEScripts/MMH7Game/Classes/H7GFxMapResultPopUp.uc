//=============================================================================
// H7GFxMapResultPopUp
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMapResultPopUp extends H7GFxUIContainer; 

function Update(bool win, optional bool isEndOfGame = true)
{
	local GFxObject obj;
	local H7AdventureController advController;
	local EDifficulty difficulty;

	obj = CreateObject("Object");
	advController = class'H7AdventureController'.static.GetInstance();

	obj.SetString("MapName", advController.GetMapInfo().GetName() != "mName" ? advController.GetMapInfo().GetName() : "");
	obj.SetString("Time", advController.GetCalendar().GetTotalPlayTimeString());
	obj.SetBool("Win", win);
	obj.SetBool("IsCampaign", advController.GetMapInfo().GetMapType() == CAMPAIGN);
	
	difficulty = advController.GetGameSettings().mDifficulty;
	switch(difficulty)
	{
		case 0: obj.SetString("Difficulty", class'H7Loca'.static.LocalizeSave("EASY","H7SkirmishSetup"));
				break;
		case 1: obj.SetString("Difficulty", class'H7Loca'.static.LocalizeSave("MEDIUM","H7SkirmishSetup"));
				break;
		case 2: obj.SetString("Difficulty", class'H7Loca'.static.LocalizeSave("HARD","H7SkirmishSetup"));
				break;
		case 3: obj.SetString("Difficulty", class'H7Loca'.static.LocalizeSave("HEROIC","H7SkirmishSetup"));
				break;
		case 4: obj.SetString("Difficulty", class'H7Loca'.static.LocalizeSave("CUSTOM","H7SkirmishSetup"));
			    break;
	}

	obj.SetInt("AIEcoStrength", advController.GetGameSettings().mDifficultyParameters.mAiEcoStrength);
	obj.SetInt("CritterGrowthRate", advController.GetGameSettings().mDifficultyParameters.mCritterGrowthRate);
	obj.SetInt("CritterStartSize", advController.GetGameSettings().mDifficultyParameters.mCritterStartSize);
	obj.SetInt("StartResources", advController.GetGameSettings().mDifficultyParameters.mStartResources);
	
	if(advController.GetCampaign() != none)
	{
		obj.SetBool("IsMultiplayer", false);
		obj.SetBool("IsCampaign", true);
		obj.SetBool("IsCouncilCampaign", advController.GetCampaign().IsCouncilCampaign() );
		obj.SetBool("IsLastMap",  advController.GetCampaign().GetNextMap(advController.GetMapFileName()) == "");
		obj.SetBool("IsHotseat", false);
	}
	else
	{
		obj.SetBool("IsCampaign", false);
		obj.SetBool("IsMultiplayer", class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || advController.IsHotSeat());
		obj.SetBool("IsHotseat", advController.IsHotSeat());
		obj.SetBool("IsLastMap", true);
	}

	obj.SetBool("IsReplay", IsReplay());

	// play on pc -> exit game
	obj.SetBool("PlayOnPC", class'Engine'.static.GetCurrentWorldInfo().IsPlayInPreview());
	
	// play in editor -> disabled
	obj.SetBool("PlayInEditor", class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor());

	obj.SetInt("PlayerColorR", advController.GetLocalPlayer().GetColor().R);
	obj.SetInt("PlayerColorG", advController.GetLocalPlayer().GetColor().G);
	obj.SetInt("PlayerColorB", advController.GetLocalPlayer().GetColor().B);

	obj.SetBool("IsEndOfGame", isEndOfGame);
	
	SetObject("mData", obj);

    ActionScriptInt("Update");
}

function bool IsReplay()
{
	local H7PlayerProfile playerProfile;
	local string map;

	map = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
	playerProfile = class'H7PlayerProfile'.static.GetInstance();

	if(playerProfile.mCampaignsProgress.Length > 0
	&& playerProfile.mCampaignsProgress[playerProfile.GetCurrentCampaignID()].ReplayMap.CurrentMapState == MST_InProgress 
	&& playerProfile.mCampaignsProgress[playerProfile.GetCurrentCampaignID()].ReplayMap.MapFileName == Caps(map) )
	{
		return true;
	}

	return false;
}

function CloseCustomDifficultyPopUp()
{
	ActionScriptVoid("CloseCustomDifficultyPopUp");
}
