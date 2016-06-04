/*=============================================================================
 * H7SeqAct_LoseMap
 * Copyright 2013-2016 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_LoseMap extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The losing player
var(Properties) EPlayerNumber mLosingPlayer<DisplayName="Player">;

function Activated()
{
	local H7Player losingPlayer;
	local H7PlayerEventParam eventParam;
	local H7AdventureController adventureController;

	adventureController = class'H7AdventureController'.static.GetInstance();

	losingPlayer = adventureController.GetPlayerByNumber(mLosingPlayer);

	if( losingPlayer==None )
	{
		return;
	}
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		losingPlayer.GetQuestController().SetQueuedForLoss( true );
		losingPlayer.GetQuestController().SetLossSeq( self );
		return;
	}
	losingPlayer.GetQuestController().SetQueuedForLoss( false );
	//only trigger lose screen if the player is local player
	losingPlayer.GetQuestController().LoseGame();
	losingPlayer.LoseGame();//TODO: this should be moved into LoseGame() end game routine
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();

	//Player lose event
	eventParam = new class'H7PlayerEventParam';
	eventParam.mEventPlayerNumber = mLosingPlayer;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerWinLoseGame', eventParam, losingPlayer, 1/*lose*/);
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


