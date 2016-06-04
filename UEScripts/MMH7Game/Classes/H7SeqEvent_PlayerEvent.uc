//=============================================================================
// H7SeqEvent_PlayerEvent
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
// Base class for One/any player events

class H7SeqEvent_PlayerEvent extends H7SeqEvent
	implements(H7ITriggerable)
	abstract
	native;

/** Only a specific player triggers the event, otherwise any player will trigger it */
var(Properties) protected bool mOnePlayer<DisplayName="Triggered by one player">;
/** The specific player to trigger the event */
var(Properties) protected EPlayerNumber mPlayerNumber<DisplayName="Player"|EditCondition=mOnePlayer>;
/** Specify a set of players that trigger the event */
var(Properties) protected bool mOnePlayers<DisplayName="Triggered by player(s)">;
/** The players that trigger the event */
var(Properties) protected H7AffectedPlayers mAffectedPlayers<DisplayName="Trigger Player(s)"|EditCondition=mOnePlayers>;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7PlayerEventParam param;
	local bool onePlayer, onePlayers;
	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		param = H7PlayerEventParam(evtParam);
		if (param != none)
		{
			onePlayer = (!mOnePlayer || param.mEventPlayerNumber == self.mPlayerNumber);
			onePlayers = (!mOnePlayers || IsChecked(self.mAffectedPlayers, param.mEventPlayerNumber));

			return onePlayer && onePlayers;
		}
	}
	return false;
}

static function bool IsChecked(H7AffectedPlayers players, EPlayerNumber playerID)
{
	if(playerID == PN_PLAYER_1)
	{
		return players.Player1;
	}
	else if(playerID == PN_PLAYER_2)
	{
		return players.Player2;
	}
	else if(playerID == PN_PLAYER_3)
	{
		return players.Player3;
	}
	else if(playerID == PN_PLAYER_4)
	{
		return players.Player4;
	}
	else if(playerID == PN_PLAYER_5)
	{
		return players.Player5;
	}
	else if(playerID == PN_PLAYER_6)
	{
		return players.Player6;
	}
	else if(playerID == PN_PLAYER_7)
	{
		return players.Player7;
	}
	else if(playerID == PN_PLAYER_8)
	{
		return players.Player8;
	}

	return false;	// No love for the neutral player
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

