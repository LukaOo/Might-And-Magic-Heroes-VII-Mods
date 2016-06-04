//=============================================================================
// H7GFxCouncilorWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxCouncilorWindow extends H7GFxUIContainer;

// Councilor
// Councillor
// Counselor
// Counsellor

var protected H7CampaignDefinition mDisplayedCampaign;
var protected bool mStandAloneMode;

function bool GetStandAloneMode() { return mStandAloneMode; }

function H7CampaignDefinition GetLastDisplayedCampaign()
{
	return mDisplayedCampaign;
}

function Update(H7CampaignDefinition theCampaign, bool standAloneMode)
{
	local GFxObject mData;
	local int currentMapNumber,completedMaps;
	local H7PlayerProfile playerProfile;

	mDisplayedCampaign = theCampaign;
	mStandAloneMode = standAloneMode;

	playerProfile = class'H7PlayerProfile'.static.GetInstance();

	mData = CreateObject("Object");

	mData.SetString("CouncilorName",(theCampaign.GetCouncillor() != none)?theCampaign.GetCouncillor().GetName():"");
	mData.SetString("CampaignName",theCampaign.GetName());
	mData.SetString("FactionIcon",theCampaign.GetFaction().GetFactionColorIconPath());
	mData.SetString("Color",GetHud().GetDialogCntl().UnrealColorToFlashColor( theCampaign.GetFaction().GetColor() ) );
	mData.SetInt("MaxMaps",theCampaign.GetMaxMaps());
	mData.SetBool("StandAloneMode",standAloneMode);

	completedMaps = class'H7PlayerProfile'.static.GetInstance().GetNumCompletedMaps(theCampaign);
	currentMapNumber = completedMaps + 1;
	if(currentMapNumber > theCampaign.GetMaxMaps()) currentMapNumber = 0;
	mData.SetInt("CompletedMaps",completedMaps);
	mData.SetInt("CurrentMap",currentMapNumber); // I will load or start this map

	if(playerProfile.IsCampaignComplete(theCampaign)) // OPTIONAL detach bonus from completion
	{
		mData.SetString("Bonus",theCampaign.GetBonusDescription());
	}

	if(playerProfile.GetCampaignFinishedMapsNum(theCampaign) >= theCampaign.GetMapsNum())
	{
		mData.SetBool("Completed",true);
	}
	else
	{
		if(playerProfile.IsCampaignStarted(theCampaign))
		{
			mData.SetBool("ContinueCampaign",true);
		}
		else
		{
			mData.SetBool("ContinueCampaign",false);
		}
	}
	// theCampaign.GetCurrentCharacterText() $ "\n\n" $  // character text removed as of 27.07.2015
	mData.SetString("Text",theCampaign.GetDescription());

	if(theCampaign.GetAID() == "IvanCampaign") // archetype name hack bc special design
	{
		if(class'H7PlayerProfile'.static.GetInstance().GetNumCompletedCampaigns() < 2)
		{
			mData.SetBool("Locked",true);
			mData.SetString("Text",class'H7Loca'.static.LocalizeSave("CAMPAIGN_LOCKED","H7MainMenu"));
			mData.SetInt("CurrentMap",0);
		}
	}

	AddMapData(mData,theCampaign);

	SetObject("mData",mData);
	ActionscriptVoid("Update");
}

function AddMapData(GFxObject data,H7CampaignDefinition theCampaign)
{
	local GFxObject mapList;
	local array<string> maps;
	local string map;
	local int i;

	mapList = CreateArray();
	maps = theCampaign.GetMaps();
	foreach maps(map,i)
	{
		mapList.SetElementString(i,theCampaign.GetMapLocaName(map));
	}

	data.SetObject("MapList",mapList);
}

function DisplayDifficultySettings(int global,int res,int strength,int growth,int ai)
{
	ActionScriptVoid("DisplayDifficultySettings");
}
