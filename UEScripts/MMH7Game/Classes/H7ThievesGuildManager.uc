//=============================================================================
// H7ThievesGuildManager
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//
//  is created once per player -> so every player has its own
//
//=============================================================================
class H7ThievesGuildManager extends Object
	savegame;

var protected savegame Array<H7PlayerSpyInfo>    mPlayerSpyInfos;
var protected savegame int                       mBusySpies;
var protected savegame int                       mOwnerID;
var protected savegame int                       mInstantSpyMissions;
var protected savegame int                       mRunningPlundersCount;
var protected savegame int                       mRunningSabotageCount;

function Array<H7PlayerSpyInfo>         GetPlayerSpyInfos()                             { return mPlayerSpyInfos;}
function                                SetPlayerSpyInfos(Array<H7PlayerSpyInfo> infos) { mPlayerSpyInfos = infos; }
function int                            GetInstantSpyMissions()                         { return mInstantSpyMissions; }
function                                SetInstantSpyMissions(int val)                  { mInstantSpyMissions = val; }
function int                            GetBusySpiesCount()                             { return mBusySpies; }
function int                            GetRunningPlundersCount()                       { return mRunningPlundersCount; } 
function int                            GetRunningSabotageCount()                       { return mRunningSabotageCount; }

function int GetTotalSpiesCount()
{
	local Array<H7Town> towns;
	local H7Town town;
	local H7TownBuildingData thievesGuild, spiesGuild;
	local int totalSpies;

	towns = class'H7AdventureController'.static.GetInstance().GetPlayerByID(mOwnerID).GetTowns();
	foreach towns(town)
	{
		thievesGuild = town.GetBuildingTemplateByType(class'H7TownThiefGuild');
		if(thievesGuild.Building != none && thievesGuild.IsBuilt)
			totalSpies++;

		spiesGuild = town.GetBuildingTemplateByType(class'H7TownSpiesGuild');
		if(spiesGuild.Building != none && spiesGuild.IsBuilt)
			totalSpies++;
	}
	
	return totalSpies;
}

function Initialize(Array<H7Player> players, int ownerID)
{
	local H7Player player;
	local H7PlayerSpyInfo info, emptyinfo;
	local int ownerTeamNumber;

	ownerTeamNumber = class'H7AdventureController'.static.GetInstance().GetPlayerByID(ownerID).GetTeamNumber();
	mOwnerID = ownerID;

	foreach players(player)
	{
		if(player.IsNeutralPlayer()) continue;
		if(player.GetStatus() == PLAYERSTATUS_UNUSED) continue;
		//if player is supposed to be discovered manually AND its not the current player AND hes not
		//in the current players team -> skip it
		if(!player.IsDiscoveredFromStart() && player.GetID() != ownerID
			&& player.GetTeamNumber() != ownerTeamNumber) continue;
		info = emptyinfo;
		info.PlayerID = player.GetID();
		
		if(player.GetStatus() == PLAYERSTATUS_QUIT)
		{
			info.PlayerName = ESIS_dead;
			info.Towns = ESIS_dead;
			info.Heroes = ESIS_dead;
			info.BestHero = ESIS_dead;
			info.CommonResourceIncome = ESIS_dead;
			info.Gold = ESIS_dead;
			info.RareResourceIncome = ESIS_dead;
			info.MapDiscovery = ESIS_dead;
			info.TearOfAshan = ESIS_dead;
		}

		if((player.GetID() == mOwnerID) || (player.GetTeamNumber() == ownerTeamNumber) && player.GetTeamNumber() != TN_NO_TEAM)
		{
			info.PlayerName = ESIS_new;
			info.Towns = ESIS_new;
			info.Heroes = ESIS_new;
			info.BestHero = ESIS_new;
			info.CommonResourceIncome = ESIS_new;
			info.Gold = ESIS_new;
			info.RareResourceIncome = ESIS_new;
			info.MapDiscovery = ESIS_new;
			info.TearOfAshan = ESIS_new;
		}
		// else use default values in H7PlayerSpyInfo
		mPlayerSpyInfos.AddItem(info);
	}
}

function SendSpy(int playerID, string infoType)
{
	local int i;
	
	;
	for(i = 0; i < mPlayerSpyInfos.Length; i++)
	{
		if(mPlayerSpyInfos[i].PlayerID == playerID)
		{
			switch (infoType)
			{
				case "HEROES":  mPlayerSpyInfos[i].Heroes = ESIS_spying;
								break;
				case "BEST_HERO":  mPlayerSpyInfos[i].BestHero = ESIS_spying;
								break;
				case "GOLD":    mPlayerSpyInfos[i].Gold = ESIS_spying;
								;
								break;
				case "COMMON":  mPlayerSpyInfos[i].CommonResourceIncome = ESIS_spying;
								break;
				case "RARE":    mPlayerSpyInfos[i].RareResourceIncome = ESIS_spying;
								break;
				case "MAP":     mPlayerSpyInfos[i].MapDiscovery = ESIS_spying;
								break;
				case "TEAR":    mPlayerSpyInfos[i].TearOfAshan = ESIS_spying;
								break;
			}
		}
	}
	mBusySpies++;
}

function IncreaseRunningPlundersCount(int playerID)                 
{
	local int i;
	
	;
	for(i = 0; i < mPlayerSpyInfos.Length; i++)
	{
		if(mPlayerSpyInfos[i].PlayerID == playerID)
		{
			mPlayerSpyInfos[i].PlunderCount++;
		}
	}

	mBusySpies++; 
	mRunningPlundersCount++; 
}

function IncreaseRunningSabotageCount(int playerID)
{
	local int i;
	
	;
	for(i = 0; i < mPlayerSpyInfos.Length; i++)
	{
		if(mPlayerSpyInfos[i].PlayerID == playerID)
		{
			mPlayerSpyInfos[i].SabotageCount++;
		}
	}

	mBusySpies++; 
	mRunningSabotageCount++; 
}

function UpdateSpyInfo()
{
	local int i;

	for(i = 0; i < (mPlayerSpyInfos.Length); i++)
	{
		if(mPlayerSpyInfos[i].Heroes == ESIS_spying) mPlayerSpyinfos[i].Heroes = ESIS_new;
		if(mPlayerSpyinfos[i].BestHero == ESIS_spying) mPlayerSpyinfos[i].BestHero = ESIS_new;
		if(mPlayerSpyinfos[i].Gold == ESIS_spying) mPlayerSpyinfos[i].Gold = ESIS_new;
		if(mPlayerSpyinfos[i].CommonResourceIncome == ESIS_spying) mPlayerSpyinfos[i].CommonResourceIncome = ESIS_new;
		if(mPlayerSpyinfos[i].RareResourceIncome == ESIS_spying) mPlayerSpyinfos[i].RareResourceIncome = ESIS_new;
		if(mPlayerSpyinfos[i].MapDiscovery == ESIS_spying) mPlayerSpyinfos[i].MapDiscovery = ESIS_new;
		if(mPlayerSpyinfos[i].TearOfAshan == ESIS_spying) mPlayerSpyinfos[i].TearOfAshan = ESIS_new;
		mPlayerSpyInfos[i].PlunderCount = 0;
		mPlayerSpyInfos[i].SabotageCount = 0;
	}
	mBusySpies = 0;
	mRunningPlundersCount = 0;
	mRunningSabotageCount = 0;
}

// for townscreen, to show jumping tooltip
function bool ThievesGuildHasNewInfo()
{
	local H7PlayerSpyInfo info;

	foreach mPlayerSpyInfos(info)
	{
		if(info.Heroes == ESIS_new) return true;
		if(info.BestHero == ESIS_new) return true;
		if(info.Gold == ESIS_new) return true;
		if(info.CommonResourceIncome == ESIS_new) return true;
		if(info.RareResourceIncome == ESIS_new) return true;
		if(info.MapDiscovery == ESIS_new) return true;
		if(info.TearOfAshan == ESIS_new) return true;
	}
	return false;
}

function SetStateOfNewInfoToUnlocked()
{
	local int i;
	
	for(i = 0; i < mPlayerSpyInfos.Length; i++)
	{
		if(mPlayerSpyInfos[i].PlayerName == ESIS_new) mPlayerSpyinfos[i].PlayerName = ESIS_unlocked;
		if(mPlayerSpyInfos[i].Towns == ESIS_new) mPlayerSpyinfos[i].Towns = ESIS_unlocked;
		if(mPlayerSpyInfos[i].Heroes == ESIS_new) mPlayerSpyinfos[i].Heroes = ESIS_unlocked;
		if(mPlayerSpyinfos[i].BestHero == ESIS_new) mPlayerSpyinfos[i].BestHero = ESIS_unlocked;
		if(mPlayerSpyinfos[i].Gold == ESIS_new) mPlayerSpyinfos[i].Gold = ESIS_unlocked;
		if(mPlayerSpyinfos[i].CommonResourceIncome == ESIS_new) mPlayerSpyinfos[i].CommonResourceIncome = ESIS_unlocked;
		if(mPlayerSpyinfos[i].RareResourceIncome == ESIS_new) mPlayerSpyinfos[i].RareResourceIncome = ESIS_unlocked;
		if(mPlayerSpyinfos[i].MapDiscovery == ESIS_new) mPlayerSpyinfos[i].MapDiscovery = ESIS_unlocked;
		if(mPlayerSpyinfos[i].TearOfAshan == ESIS_new) mPlayerSpyinfos[i].TearOfAshan = ESIS_unlocked;
	}
}

function RevealInstantLastInfoRequested(int playerID, string infoType)
{
	local int i;
	
    for(i = 0; i < mPlayerSpyInfos.Length; i++)
	{
		if(mPlayerSpyInfos[i].PlayerID == playerID && mInstantSpyMissions > 0)
		{
			;
			switch (infoType)
			{
				case "HEROES":  if(mPlayerSpyInfos[i].Heroes == ESIS_spying) mPlayerSpyinfos[i].Heroes = ESIS_new;
								mInstantSpyMissions--;
								break;
				case "BEST_HERO": if(mPlayerSpyinfos[i].BestHero == ESIS_spying) mPlayerSpyinfos[i].BestHero = ESIS_new;
								mInstantSpyMissions--;
								break;
				case "GOLD":    if(mPlayerSpyinfos[i].Gold == ESIS_spying) mPlayerSpyinfos[i].Gold = ESIS_new;
								mInstantSpyMissions--;
								break;
				case "COMMON":  if(mPlayerSpyinfos[i].CommonResourceIncome == ESIS_spying) mPlayerSpyinfos[i].CommonResourceIncome = ESIS_new;
								mInstantSpyMissions--;
								break;
				case "RARE":    if(mPlayerSpyinfos[i].RareResourceIncome == ESIS_spying) mPlayerSpyinfos[i].RareResourceIncome = ESIS_new;
								mInstantSpyMissions--;
								break;
				case "MAP":     if(mPlayerSpyinfos[i].MapDiscovery == ESIS_spying) mPlayerSpyinfos[i].MapDiscovery = ESIS_new;
								mInstantSpyMissions--;
								break;
				case "TEAR":    if(mPlayerSpyinfos[i].TearOfAshan == ESIS_spying) mPlayerSpyinfos[i].TearOfAshan = ESIS_new;
								mInstantSpyMissions--;
								break;
			}
			;
		}
	}
	
}

function AddPlayer(H7Player player)
{   
	local H7PlayerSpyInfo testInfo, info;

	foreach mPlayerSpyInfos(testInfo)
	{
		if(testInfo.PlayerID == player.GetID()) return;
	}

	if(player.IsNeutralPlayer()) return;
	//if player is supposed to be discovered manually AND its not the current player AND hes not
	//in the current players team -> skip it
	info.PlayerID = player.GetID();
		
	if(player.GetStatus() == PLAYERSTATUS_QUIT)
	{
		info.PlayerName = ESIS_dead;
		info.Towns = ESIS_dead;
		info.Heroes = ESIS_dead;
		info.BestHero = ESIS_dead;
		info.CommonResourceIncome = ESIS_dead;
		info.Gold = ESIS_dead;
		info.RareResourceIncome = ESIS_dead;
		info.MapDiscovery = ESIS_dead;
		info.TearOfAshan = ESIS_dead;
	}

	mPlayerSpyInfos.AddItem(info);
}

function JSonObject Serialize()
{
	local JSonObject myJsonObject, spyInfo;
	local int i;

	myJSonObject = new () class'JSonObject';
	myJsonObject.SetIntValue("PlayerCount", mPlayerSpyInfos.Length);

	for(i = 0; i < mPlayerSpyInfos.Length; ++i)
	{
		spyInfo = new() class'JSonObject';
		spyInfo.SetIntValue("PlayerID", mPlayerSpyInfos[i].PlayerID);
		spyInfo.SetIntValue("PlayerName", mPlayerSpyInfos[i].PlayerName);
		spyInfo.SetIntValue("BestHero", mPlayerSpyInfos[i].BestHero);
		spyInfo.SetIntValue("Gold", mPlayerSpyInfos[i].Gold);
		spyInfo.SetIntValue("CommonResourceIncome", mPlayerSpyInfos[i].CommonResourceIncome);
		spyInfo.SetIntValue("RareResourceIncome", mPlayerSpyInfos[i].RareResourceIncome);
		spyInfo.SetIntValue("MapDiscovery", mPlayerSpyInfos[i].MapDiscovery);
		spyInfo.SetIntValue("TearOfAshan", mPlayerSpyInfos[i].TearOfAshan);
		myJsonObject.SetObject("SpyInfo"$i,spyInfo);
	}
	return myJsonObject;
}

function Deserialize(JSonObject data)
{
	local JSonObject singleInfo;
	local H7PlayerSpyInfo info, emptyinfo;
	local int playerCount, i;

	mPlayerSpyInfos.Remove(0, mPlayerSpyInfos.Length);

	playerCount = data.GetIntValue("PlayerCount");

	for(i = 0; i < playerCount; i++)
	{
		singleInfo = data.GetObject("SpyInfo"$i);
		info = emptyInfo;
		info.PlayerID = singleInfo.GetIntValue("PlayerID");
		info.PlayerName = ESpyInfoState( singleInfo.GetIntValue("PlayerName") );
		info.BestHero = ESpyInfoState( singleInfo.GetIntValue("BestHero") );
		info.Gold = ESpyInfoState( singleInfo.GetIntValue("Gold") );
		info.CommonResourceIncome = ESpyInfoState( singleInfo.GetIntValue("CommonResourceIncome") );
		info.RareResourceIncome = ESpyInfoState( singleInfo.GetIntValue("RareResourceIncome") );
		info.MapDiscovery = ESpyInfoState( singleInfo.GetIntValue("MapDiscovery") );
		info.TearOfAshan = ESpyInfoState( singleInfo.GetIntValue("TearOfAshan") );
		mPlayerSpyInfos.AddItem(info);
	}
}
