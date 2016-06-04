//=============================================================================
// H7InstantCommandIncreaseHeroStat
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandIncreaseHeroStat extends H7InstantCommandBase;

var private H7EditorHero mHero;
var private EStat mStat;
var private int mAmountToIncrease;

function Init( H7EditorHero hero, EStat stat, int amountToIncrease )
{
	mHero = hero;
	mStat = stat;
	mAmountToIncrease = amountToIncrease;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7EditorHero(eventManageable);
	mStat = EStat(command.IntParameters[1]);
	mAmountToIncrease = command.IntParameters[2];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_INCREASE_HERO_STAT;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mStat;
	command.IntParameters[2] = mAmountToIncrease;
	
	return command;
}

function Execute()
{
	local string floatingText;

	if( mHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		floatingText = "+" $ mAmountToIncrease;
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_STAT_MOD, mHero.GetLocation() + Vect(0,0,600), mHero.GetPlayer(), floatingText@class'H7EffectContainer'.static.GetLocaNameForStat(mStat,true), MakeColor(0,255,0,255), class'H7PlayerController'.static.GetPlayerController().GetHud().GetStatIcons().GetStatIcon(mStat, mHero));
	}

	mHero.IncreaseBaseStatByID( mStat, mAmountToIncrease );
	mHero.DataChanged();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
