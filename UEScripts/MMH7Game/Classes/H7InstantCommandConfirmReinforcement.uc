//=============================================================================
// H7InstantCommandConfirmReinforcement
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandConfirmReinforcement extends H7InstantCommandBase;

var private H7AdventureHero mHero;
var private int mManaCost;

function Init( H7AdventureHero hero, int manaCost )
{
	mHero = hero;
	mManaCost = manaCost;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7AdventureHero(eventManageable);
	mManaCost = command.IntParameters[1];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_CONFIRM_REINFORCEMENT;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mManaCost;
	
	return command;
}

function Execute()
{
	local array<H7BaseCreatureStack> emptyStacks;

	emptyStacks.Length = 0;
	mHero.UseMana(mManaCost);
	mHero.GetPlayer().SetOriginalReinforcementStacksArmy(emptyStacks);
	mHero.GetPlayer().SetOriginalReinforcementStacksTown(emptyStacks);
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
