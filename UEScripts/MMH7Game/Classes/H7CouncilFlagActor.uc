//=============================================================================
// H7CouncilFlagActor
//=============================================================================
//
// Used on Council Map to represent maps in Selected Campaign
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilFlagActor extends H7CouncilInteractive
	placeable;

var(FlagInfo) protected H7CampaignDefinition mCampaign;
// Map file name
var(FlagInfo) protected string mMapName;
// Check true if this flag is for first map in campaign
var(FlagInfo) protected bool mFirstCampaignMap;

function H7CampaignDefinition GetCampaign() { return mCampaign; }
function string GetMapName() { return mMapName; }
function bool IsFirstMap() { return mFirstCampaignMap; }


function ClickedOn()
{
	
}

function MouseOverStart()
{
	super.MouseOverStart();

}

function MouseOverStop()
{
	super.MouseOverStart();

}
