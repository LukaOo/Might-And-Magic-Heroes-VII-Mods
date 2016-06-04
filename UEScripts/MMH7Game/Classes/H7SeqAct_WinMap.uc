/*=============================================================================
 * H7SeqAct_WinMap
 * Copyright 2013-2016 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_WinMap extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The winning player
var(Properties) EPlayerNumber mWinningPlayer<DisplayName="Player">;

function Activated()
{
	local H7Player winningPlayer;
	local H7PlayerEventParam eventParam;
	local H7AdventureController adventureController;

	adventureController = class'H7AdventureController'.static.GetInstance();
	winningPlayer = adventureController.GetPlayerByNumber(mWinningPlayer);
	if( winningPlayer==None )
	{
		return;
	}
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		winningPlayer.GetQuestController().SetQueuedForWin( true );
		winningPlayer.GetQuestController().SetWinSeq( self );
		return;
	}
	winningPlayer.GetQuestController().SetQueuedForWin( false );
	winningPlayer.GetQuestController().WinGame();
	winningPlayer.WinGame();
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	//Player win event
	eventParam = new class'H7PlayerEventParam';
	eventParam.mEventPlayerNumber = mWinningPlayer;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerWinLoseGame', eventParam, winningPlayer, 0/*win*/);
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

