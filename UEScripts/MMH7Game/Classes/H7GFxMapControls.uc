//=============================================================================
// H7GFxMapControls
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxMapControls extends H7GFxUIContainer;

function SetAvailableCampaigns(array<H7CampaignDefinition> campaigns)
{	
	local GFxObject list,campaignData;
	local H7CampaignDefinition campaign;
	local int i;

	list = CreateArray();

	foreach campaigns(campaign,i)
	{
		campaignData = CreateObject("Object");

		campaignData.SetString("AID",String(campaign));
		campaignData.SetString("Name",campaign.GetName());
		
		list.SetElementObject(i,campaignData);
	}

	SetObject("mData", list);
	ActionscriptVoid("Update");
}

function SetAvailableMaps(array<string> maps)
{
	local GFxObject list,campaignData;
	local H7CampaignDefinition theCampaign;
	local string map;
	local int i;

	list = CreateArray();

	;

	foreach maps(map,i)
	{
		theCampaign = class'H7GameData'.static.GetInstance().GetCampaignOfMap(map);

		campaignData = CreateObject("Object");

		campaignData.SetString("MapFileName",map);
		campaignData.SetString("Campaign",string(theCampaign));
		campaignData.SetInt("Year",theCampaign.GetYearOfMap(map));
		campaignData.SetInt("Pixel",theCampaign.GetPixelOfMap(map));
		campaignData.SetString("FactionIcon",theCampaign.GetFaction().GetFactionMarkerIconPath());
		campaignData.SetString("Color",GetHud().GetDialogCntl().UnrealColorToFlashColor(theCampaign.GetFaction().GetColor()));
		
		


		
		list.SetElementObject(i,campaignData);
	}

	SetObject("mData", list);
	ActionscriptVoid("UpdateMaps");
}

function UpdateMarkerStates(string camp,string map)
{
	ActionscriptVoid("UpdateMarkerStates");
}

function DisplayCampaign(string campaignAID)
{
	ActionscriptVoid("DisplayCampaign");
}
