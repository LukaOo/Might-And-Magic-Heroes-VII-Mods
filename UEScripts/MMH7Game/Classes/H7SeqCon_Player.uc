//=============================================================================
// H7SeqCon_Player
// Base class for conditions that refer to one/any player
// class deriving of this class need to use IsConditionFulfilledForPlayer(..) instead of IsConditionFulfilled()
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_Player extends H7SeqCon_TimePassed
	abstract
	native;

/* The player that is checked */
var(Player) protected EPlayerNumber mConditionPlayer<DisplayName="Player"|EditCondition=!mAnyPlayer>;
/* The player does not matter */
var(Player) protected bool mAnyPlayer<DisplayName="Any Player">;

// Player objects relevant for this condition. 1 for one specific player, all players if mAnyPlayer is set
var private array<H7Player> mPlayers;

// interface H7IProgressable
function bool HasProgress() { return false; }

function protected array<H7Player> GetPlayers()
{
	local H7AdventureController adventureController;
	local H7Player thePlayer;

	if(mPlayers.Length == 0)
	{
		adventureController = class'H7AdventureController'.static.GetInstance();

		if( adventureController != none )
		{
			if(mAnyPlayer)
			{
				mPlayers = adventureController.GetActivePlayers(false);
			}
			else
			{
				thePlayer = adventureController.GetPlayerByNumber(mConditionPlayer);
				if(thePlayer != none && (thePlayer.GetStatus() != PLAYERSTATUS_UNUSED && thePlayer.GetStatus() != PLAYERSTATUS_QUIT))
				{
					mPlayers.AddItem(thePlayer);
				}
			}
		}
	}
	return mPlayers;
}

function protected bool IsConditionFulfilled()
{
	local H7Player currentPlayer;
	local array<H7Player> players;

	players = GetPlayers();

	foreach players(currentPlayer)
	{
		if(IsConditionFulfilledForPlayer(currentPlayer))
		{
			return true;
		}
	}

	return false;
}

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	return true;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

