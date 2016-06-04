/*=============================================================================
 * H7SeqCon_FinishedCampaigns
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqCon_FinishedCampaigns extends H7SeqCon_Condition;

/** The campaigns that should be finished */
var(Developer) protected array<H7CampaignDefinition> mCampaigns<DisplayName="Finished Campaigns">;

function protected bool IsConditionFulfilled()
{
	local int finishedCampaigns;
	local H7PlayerProfile playerProfile;
	local H7CampaignDefinition currentCampaignDef;

	playerProfile =	class'H7PlayerProfile'.static.GetInstance();

	foreach mCampaigns(currentCampaignDef)
	{
		if(playerProfile.IsCampaignComplete(currentCampaignDef))
		{
			++finishedCampaigns;
		}
	}

	return finishedCampaigns == mCampaigns.Length;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

