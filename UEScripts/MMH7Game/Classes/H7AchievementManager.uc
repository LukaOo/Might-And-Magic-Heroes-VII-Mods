//=============================================================================
// H7AchievementManager
//=============================================================================
//
// 
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AchievementManager extends Object
	//hidecategories(Object)
	dependson(H7StructsAndEnumsNative)
	native
;

var array<H7UPlayTask> mRunningUPlayTasks;

var protected H7PlayerProfile playerProfile;

var protected bool mCompletedFirstCampaignMap;

var protected bool mCompletedOneCampaign;
var protected bool mCompletedTwoCampaigns;
var protected bool mCompletedFinalCampaign;

var protected bool mCompletedOneSkirmishGame;

function SetPlayerProfile(H7PlayerProfile profile) { playerProfile = profile; }
function H7PlayerProfile GetPlayerProfile() { return playerProfile; }

function SetCompletedOneCampaign() { mCompletedOneCampaign = true; }
function bool GetCompletedOneCampaign() { return mCompletedOneCampaign; }

function SetCompletedTwoCampigns() { mCompletedTwoCampaigns = true; }
function bool GetCompletedTwoCampaigns() { return mCompletedTwoCampaigns; }

function SetCompletedFinalCampaign() { mCompletedFinalCampaign = true; }
function bool GetCompletedFinalCampaign() { return mCompletedFinalCampaign; }

function SetCompletedOneSkirmishMap() { mCompletedOneSkirmishGame = true; }
function bool GetCompletedOneSkirmishMap() { return mCompletedOneSkirmishGame; } 

function SetCompletedFirstCampaignMap() {	mCompletedFirstCampaignMap = true;}
function bool GetCompletedFirstCampaignMap() { return mCompletedFirstCampaignMap; }

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

native function UpdateStatus();

event SaveProfile()
{
	if( class'H7PlayerProfile'.static.GetInstance() != none)
	{
		class'H7PlayerProfile'.static.GetInstance().Save();
	}
}

///////////////////////////////////////////////////
// Achievements
///////////////////////////////////////////////////

native function HandleMapCompleted(string mapFileName);

///////////////////////////////////////////////////
// Actions
///////////////////////////////////////////////////

native function PullActions();

event ActionUnlocked(string actionID, string actionSID, bool isOffilne, optional bool showPopup = TRUE)
{
	local int i;
	local int uactionIndex;
	local H7UPlayAction uaction;

	uactionIndex = -1;

	// Find it on list pulled from uplay and check if its completed (with simple ID ex. "1")
	for(i = 0; i < playerProfile.mUPlayActions.Length; ++i)
	{
		if(playerProfile.mUPlayActions[i].idUtf8 == actionID)
		{
			if(playerProfile.mUPlayActions[i].completed)
			{
				return;
			}

			uactionIndex = i;
			break;
		}
	}

	// Find it on list pulled from uplay and check if its completed (with complex ID ex. "MMH7ACTION01")
	if(uactionIndex <= -1)
	{
		for(i = 0; i < playerProfile.mUPlayActions.Length; ++i)
		{
			if(playerProfile.mUPlayActions[i].idUtf8 == actionSID)
			{
				if(playerProfile.mUPlayActions[i].completed)
				{
					return;
				}

				uactionIndex = i;
				break;
			}
		}
	}

	// There is no action on list, this is very rare case (it would mean player never connected online or removed player profile while offline)
	if(uactionIndex == -1)
	{
		uaction.idUtf8 = actionSID;

		uactionIndex = playerProfile.mUPlayActions.Length;
		playerProfile.mUPlayActions.AddItem(uaction);
	}

	playerProfile.mUPlayActions[uactionIndex].completed = true;

	if(!showPopup)
	{
		SaveProfile();

		return;
	}

	if(isOffilne || playerProfile.mUPlayActions[uactionIndex].nameUtf8 == "" || playerProfile.mUPlayActions[uactionIndex].units == 0 )
	{
		playerProfile.mUPlayActions[uactionIndex].synchronized = false;

		class'H7GUIOverlaySystemCntl'.static.GetInstance().GetUplayNote().SetData("UPLAY_ACTION_COMPLETED","",0);
	}
	else
	{
		playerProfile.mUPlayActions[uactionIndex].synchronized = true;

		class'H7GUIOverlaySystemCntl'.static.GetInstance().GetUplayNote().SetData("UPLAY_ACTION_COMPLETED", playerProfile.mUPlayActions[uactionIndex].nameUtf8, playerProfile.mUPlayActions[uactionIndex].units);
	}

	SaveProfile();
}

// What a brilliant solution, you should be an engineer
native function ActionCompleted_DIH();
native function ActionCompleted_LFTP();
native function ActionCompleted_PYS();
native function ActionCompleted_ML();
native function ActionCompleted_SAAIDY();

native function ActionCompletedBulk(array<int> actionIDs);

///////////////////////////////////////////////////
// Rewards
///////////////////////////////////////////////////

native function PullUPlayRewards();

event BuildRewardMenu()
{
	if(class'H7OptionsManager'.static.GetInstance() != none)
	{
		class'H7OptionsManager'.static.GetInstance().CreateRewardOptions();
	}
}

// Oh boy, another great piece of code... You should get medal for it :)
function bool GetStateReward_HD() // H7Faction
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD01" );

	if(i > -1)
	{
		return playerProfile.mUPlayRewards[i].enabled;
	}

	return false;
}
function SetStateReward_HD( bool newState )
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD01" );

	if(i > -1)
	{
		playerProfile.mUPlayRewards[i].enabled = newState;
	}
}

function bool GetStateReward_PM()  // AC 855
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD02" );

	if(i > -1)
	{
		return playerProfile.mUPlayRewards[i].enabled;
	}

	return false;
}

function SetStateReward_PM( bool newState )
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD02" );

	if(i > -1)
	{
		playerProfile.mUPlayRewards[i].enabled = newState;
	}
}


function bool GetStateReward_BH() // HeroAnimControl 74
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD03" );

	if(i > -1)
	{
		return playerProfile.mUPlayRewards[i].enabled;
	}

	return false;
}

function SetStateReward_BH( bool newState ) 
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD03" );

	if(i > -1)
	{
		playerProfile.mUPlayRewards[i].enabled = newState;

		if(class'H7PlayerController'.static.GetPlayerController() != none)
		{
			class'H7PlayerController'.static.GetPlayerController().SetBigHead(newState);
		}
	}
}


function bool GetStateReward_AP() // GameData IsRewardEnabled
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD04" );

	if(i > -1)
	{
		return playerProfile.mUPlayRewards[i].enabled;
	}

	return false;
}

function SetStateReward_AP( bool newState )
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD04" );

	if(i > -1)
	{
		playerProfile.mUPlayRewards[i].enabled = newState;
	}
}


function bool GetStateReward_LM() // EditorArmy
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD05" );

	if(i > -1)
	{
		return playerProfile.mUPlayRewards[i].enabled;
	}

	return false;
}

function SetStateReward_LM( bool newState )
{
	local int i;
	i = GetRewardIndexByID( "MMH7REWARD05" );

	if(i > -1)
	{
		playerProfile.mUPlayRewards[i].enabled = newState;
	}
}


function int GetRewardIndexByID( string nameID )
{
	local int i;

	for( i = 0; i < playerProfile.mUPlayRewards.Length; ++i )
	{
		if(playerProfile.mUPlayRewards[i].idUtf8 == nameID)
		{
			return i;
		}
	}

	return -1;
}

function bool CanRewardBeUsed()
{
	local bool canUse;

	canUse = true;

	if( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetMapInfo() != none )
	{
		
		// Do I have it?
		if(class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMapType() == CAMPAIGN) 
		{
			canUse = false;
		}
	}

	// Dont allow reward's in tutorial
	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial || class'H7AdventureController'.static.GetInstance() != none && Caps(class'H7AdventureController'.static.GetInstance().GetMapFileName()) ==  Caps(class'H7TransitionData'.static.GetInstance().GetTutorialMapFileName()) )
	{
		canUse = false;
	}

	return canUse;
}

function Cheat_UnlockAllRewards()
{
	local int i;

	if(playerProfile.mUPlayRewards.Length > 0)
	{
		for( i = 0; i < playerProfile.mUPlayRewards.Length; ++i )
		{
			playerProfile.mUPlayRewards[i].enabled = true;
			playerProfile.mUPlayRewards[i].redeemed = true;
		}
	}
}
