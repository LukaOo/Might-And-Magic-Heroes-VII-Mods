//=============================================================================
// H7InstantCommandCheatWinLose
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSetAutoCombat extends H7InstantCommandBase;

var private bool mUseAutoCombat;
var private H7Player mPlayer;

function Init( bool useAutoCombat, H7Player player )
{
	mUseAutoCombat = useAutoCombat;
	mPlayer = player;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mUseAutoCombat = bool(command.IntParameters[0]);

	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		mPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(EPlayerNumber(command.IntParameters[1]));
	}
	else if( class'H7CombatController'.static.GetInstance() != none )
	{
		mPlayer = class'H7CombatController'.static.GetInstance().GetPlayerByNumber(EPlayerNumber(command.IntParameters[1]));
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_SET_AUTO_COMBAT;
	command.IntParameters[0] = mUseAutoCombat ? 1 : 0;
	command.IntParameters[1] = mPlayer.GetPlayerNumber();

	return command;
}

function Execute()
{
	local H7Unit activeUnit;

	mPlayer.SetControlledByAI( mUseAutoCombat);

	// If we disable auto combat, cancel all commands, casting spells that were started by AI, and can't be finished without AI Control
	if(!mUseAutoCombat)
	{
		// HERO
		if( class'H7CombatController'.static.GetInstance().IsHeroInCreatureTurn() && class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPlayer() == mPlayer )
		{
			class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectAttackButton(false);
			class'H7CombatController'.static.GetInstance().SetPreviousActiveUnit();
		}
		else if( class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPlayer() == mPlayer)
		{

			activeUnit = class'H7CombatController'.static.GetInstance().GetActiveUnit();
			class'H7CombatHud'.static.GetInstance().GetCombatHudCntl().SetCreatureAbilityData(activeUnit);
			class'H7CombatHudCntl'.static.GetInstance().SelectSlot(activeUnit.GetID());
			class'H7CombatController'.static.GetInstance().CalculateInputAllowed();
		}
	}

	if( mPlayer.IsControlledByAI() && class'H7CombatController'.static.GetInstance().GetActiveArmy().GetPlayer() == mPlayer ) 
	{
		class'H7CombatController'.static.GetInstance().GetAI().DeferExecution( 2.0f );
	}

	if(mPlayer.IsControlledByLocalPlayer())
	{
		class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().ActivateFxOnAutoCombatButton( mUseAutoCombat );
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mPlayer;
}
