//=============================================================================
// H7GFxCouncilorTooltip
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxCouncilorTooltip extends H7GFxUIContainer;

// Councilor
// Councillor
// Counselor
// Counsellor

function Update(H7CampaignDefinition theCampaign)
{
	local GFxObject mData;
	local int currentMapNumber,completedMaps;

	mData = CreateObject("Object");

	mData.SetString("CouncilorName",theCampaign.GetCouncillor().GetName());
	mData.SetString("CampaignName",theCampaign.GetName());
	mData.SetString("FactionIcon",theCampaign.GetFaction().GetFactionColorIconPath());
	mData.SetString("Color",GetHud().GetDialogCntl().UnrealColorToFlashColor( theCampaign.GetFaction().GetColor() ) );
	mData.SetInt("MaxMaps",theCampaign.GetMaxMaps());

	completedMaps = class'H7PlayerProfile'.static.GetInstance().GetNumCompletedMaps(theCampaign);
	currentMapNumber = completedMaps + 1;
	if(currentMapNumber > theCampaign.GetMaxMaps()) currentMapNumber = 0;
	mData.SetInt("CompletedMaps",completedMaps);
	mData.SetInt("CurrentMap",currentMapNumber); // I will load or start this map
	
	if(theCampaign.GetAID() == "IvanCampaign") // archetype name hack bc special design
	{
		if(class'H7PlayerProfile'.static.GetInstance().GetNumCompletedCampaigns() < 2)
		{
			mData.SetBool("Locked",true);
			mData.SetInt("CurrentMap",0);
			mData.SetString("CampaignName","TT_CAMPAIGN_LOCKED");
		}
	}

	SetObject("mData",mData);
	ActionscriptVoid("Update");
}
