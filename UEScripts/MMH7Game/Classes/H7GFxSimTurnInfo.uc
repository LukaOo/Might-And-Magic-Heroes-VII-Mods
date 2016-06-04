//=============================================================================
// H7GFxSimTurnInfo
//
// Wrapper for SimTurnInfo.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxSimTurnInfo extends H7GFxUIContainer;

var GFxObject mData;
var bool mIsActive;

function bool IsActive() { return mIsActive; }

function SetInfo(H7ReplicationInfo info, bool isHotSeat)
{
	if(!isHotSeat)
	{
		ListenTo(info);
		Update(info);
	}
	else
		UpdateHotSeat();
	
	SetVisibleSave(true);
	mIsActive = true;
}

function UpdateHotSeat()
{
	local array<H7Player> players;
	local H7Player currentPlayer, player;
	local int currentPlayerIndex;
	local int i;

	players = class'H7AdventureController'.static.GetInstance().GetPlayers();
	currentPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();
	currentPlayerIndex = players.Find(currentPlayer);

	mData = CreateArray();

	foreach players(player, i)
	{
		if(player.GetStatus() == PLAYERSTATUS_UNUSED) 
		{
			mData.SetElementObject(i, none);
			continue;
		}
		mData.SetElementObject(i, CreatePlayerObjectFromPlayer(player));
		;
		if(i < currentPlayerIndex)
			mData.GetElementObject(i).SetBool("IsDone", true);
		if(i == currentPlayerIndex)
			mData.GetElementObject(i).SetBool("IsActive", true);
		if(player.IsNeutralPlayer())
			mData.GetElementObject(i).SetBool("IsNeutral", true);
	}

	SetObject("mData",mData);
	ActionScriptVoid("Update");

	//just for testing
	//SetTimerMax(100);
}

function Update(H7ReplicationInfo info)
{
	local int i;
	local array<PlayerReplicationInfo> PRIarray;
	local PlayerReplicationInfo pri;
	local H7PlayerReplicationInfo h7pri;

	mData = CreateArray();

	PRIarray = info.PRIArray;
	foreach PRIarray(pri,i)
	{
		h7pri = H7PlayerReplicationInfo(pri);
		if( h7pri.GetPlayer().GetStatus() == PLAYERSTATUS_UNUSED) 
		{
			mData.SetElementObject(i, none);
			continue;
		}
		mData.SetElementObject(i,CreatePlayerObject(h7pri));
	}

	SetObject("mData",mData);
	ActionScriptVoid("Update");
}

function GFxObject CreatePlayerObject(H7PlayerReplicationInfo pri)
{
	local GFxObject ob;
	local H7Player player;
	player = pri.GetPlayer();
	ob = CreateObject("Object");
	;
	ob.SetString( "Name", player.GetName() );
	ob.SetObject( "Color", CreateColorObject(player.GetColor()) );
	ob.SetString( "Icon", player.GetFaction().GetFactionSepiaIconPath()); 
	ob.SetBool( "IsDone", pri.IsTurnFinished() );
	ob.SetBool( "IsActive", pri.IsTurnFinished() );
	ob.SetBool( "IsDefeated", pri.GetPlayer().GetStatus() != PLAYERSTATUS_ACTIVE );

	if(!class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
	{
		if(player == class'H7AdventureController'.static.GetInstance().GetCurrentPlayer())
			ob.SetBool( "IsActive", true );
		else
			ob.SetBool( "IsActive", false );
	}
	return ob;
}

//Only used for hotseat
function GFxObject CreatePlayerObjectFromPlayer(H7Player player)
{
	local GFxObject ob;
	ob = CreateObject("Object");
	;
	ob.SetString( "Name", player.GetName() );
	ob.SetObject( "Color", CreateColorObject(player.GetColor()) );
	ob.SetString( "Icon", player.GetFaction().GetFactionSepiaIconPath()); 
	ob.SetBool( "IsDone", false );
	ob.SetBool( "IsActive", false);
	ob.SetBool( "IsDefeated", player.GetQuestController().IsGameEnd());
	return ob;
}

function ListenUpdate(H7IGUIListenable info)
{
	;
	Update(H7ReplicationInfo(info));
}
/**
 *  set the maximum amount of time (in seconds) a player has to make its turn
 */
function SetTimerMax(int maxValue)
{
	mIsActive = true;
	ActionScriptVoid("SetTimeMax");
}
/**
 *  set the currently left time (in seconds) for the player to make its turn
 */
function SetCurrentTimeLeft(int seconds)
{
	ActionScriptVoid("SetCurrentTimeLeft");
}

/**
 *  hides the big round timer and replaces it with the smaller bar timer
 */
function SwitchToFullScreen()
{
	ActionScriptVoid("SwitchToFullScreen");
}

/**
 *  hides the smaller bar timer and replaces it with the big round timer
 */
function SwitchToHUD()
{
	ActionScriptVoid("SwitchToHUD");
}

/**
 * show or hide the timer, if called on adventureHud time is will also hide the players
 */
function ShowTimer(bool show)
{
	SetVisibleSave(show);
}
