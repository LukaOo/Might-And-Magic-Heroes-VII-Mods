//=============================================================================
// H7CouncilGameInfo
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilGameInfo extends H7MainMenuInfo;

struct CouncilTable
{
	var() string matineeName;
	var() array<Actor> tableMeshes;

};

struct CampaignsMapData
{
	var() H7CampaignDefinition campaignDef;
	var() array<H7CouncilFlagActor> campaignFlags;
};

// @TODO: later move to StructsAndEnums
struct CouncillorData
{
	var() H7CampaignDefinition councillorCampaign;
	var() array<Actor> characterPoses;
	var() string matineeName;
	var() bool isIvan;
	var() AkEvent StartCampaignVoiceOver;
	var() AkEvent ContinueCampaignVoiceOver;
	var() AkEvent RestartCampaignVoiceOver;
	var() array <AKEvent> StartCampaignConfirmEvent;
	var() array <AKEvent> ContinueCampaignConfirmEvent;
	var() array <AKEvent> RestartCampaignConfirmEvent;
	var() array <AKEvent> IvanCampaignSelectEvent;
};

// @TODO: later move to StructsAndEnums
enum ECouncilState
{
	CS_Invalid,
	CS_MainMenu,
	CS_TransitionBack, // ex. Matinee Playing
	CS_CouncilView,
	CS_CouncillorView,
	CS_CampaignView
};



var protected H7CouncilManager mCouncilManager;
var protected H7PlayerProfile mPlayerProfile; // @TODO Assign player profile

function H7CouncilManager GetCouncilManager()
{
	return mCouncilManager;
}

function SetCouncilManager(H7CouncilManager newManager)
{
	mCouncilManager = newManager;
}

function H7PlayerProfile GetPlayerProfile()
{
	return mPlayerProfile;
}

function PlayerController SpawnPlayerController(vector SpawnLocation, rotator SpawnRotation)
{
	local PlayerController newPC;

	newPC = Spawn(PlayerControllerClass,,, SpawnLocation, SpawnRotation);

	// fix the postprocess
	RestartPlayer(newPC);

	return newPC;
}

// Restart Player and SpawnDefaultPawnFor are overriden to avoid a Pawn to be spawned. We cleary don't need one for Heroes.
function RestartPlayer(Controller NewPlayer) //override
{
	local PlayerController PC;
	local LocalPlayer LP;

	// To fix custom post processing chain when not running in editor or PIE.
	PC = PlayerController(NewPlayer);
	if (PC != none)
	{
		LP = class'Engine'.static.GetEngine().GameViewport.GetPlayerOwner(0);
		if(LP != None) 
		{ 
			LP.RemoveAllPostProcessingChains(); 
			LP.InsertPostProcessingChain(LP.Outer.GetWorldPostProcessChain(),INDEX_NONE,true); 
			if(PC.myHUD != None)
			{
				PC.myHUD.NotifyBindPostProcessEffects();
			}
		} 
	}

	return;
}

