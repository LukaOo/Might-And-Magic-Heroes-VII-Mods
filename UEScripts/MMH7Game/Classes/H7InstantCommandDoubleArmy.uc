//=============================================================================
// H7InstantCommandDoubleArmy
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandDoubleArmy extends H7InstantCommandBase;

var private H7AdventureArmy mArmy;

function Init( H7AdventureArmy army )
{
	mArmy = army;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mArmy = H7AdventureHero(eventManageable).GetAdventureArmy();
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_DOUBLE_ARMY;
	command.IntParameters[0] = mArmy.GetHero().GetID();

	return command;
}

function Execute()
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;

	stacks = mArmy.GetBaseCreatureStacks();
	foreach stacks(stack)
	{
		stack.AddToStack(stack.GetStackSize());
	}

	mArmy.CreateCreatureStackProperies();   //also set creature stack properties to be sync with current stack size
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mArmy.GetPlayer();
}
