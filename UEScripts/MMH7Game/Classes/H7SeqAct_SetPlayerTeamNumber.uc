//=============================================================================
// H7SeqAct_SetPlayerTeamNumber
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqAct_SetPlayerTeamNumber extends SequenceAction;

/** Set Team Number of the Current Player To */
var(Properties) ETeamNumber mPlayerTeamNumber<DisplayName=Player Team Number>;

/** The player that needs a team change */
var(Properties) protected EPlayerNumber mOwner<DisplayName="Player">;

event Activated()
{
	local H7Player changePlayer; 
	changePlayer =  class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(mOwner);
	changePlayer.SetTeamNumber( mPlayerTeamNumber ); 
	class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetFOWController().ExploreFog();
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

