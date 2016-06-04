//=============================================================================
// H7InstantCommandHeroAddXp
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandHeroAddXp extends H7InstantCommandBase;

var private H7AdventureHero mHero;
var private int mExpToAdd;
var private H7ResourcePile mPile;

function Init( H7AdventureHero hero, int expToAdd, optional H7ResourcePile pile = none )
{
	mHero = hero;
	mExpToAdd = expToAdd;
	mPile = pile;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7AdventureHero(eventManageable);
	mExpToAdd = command.IntParameters[1];

	if(command.IntParameters[2] != -1)
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable(  command.IntParameters[2] );
		mPile = H7ResourcePile(eventManageable);
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_HERO_ADD_XP;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mExpToAdd;
	if(mPile != none)
	{
		command.IntParameters[2] = mPile.GetID();
	}
	else
	{
		command.IntParameters[2] = -1;
	}

	return command;
}

function Execute()
{
	local int actualXPGain;

	actualXPGain = mHero.AddXp( mExpToAdd );

	if(mPile != none)
	{
		if( mHero.GetPlayer().IsControlledByLocalPlayer() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_XP, mPile.Location, mHero.GetPlayer(),  "+"$actualXPGain , MakeColor(0,255,0,255));
			if(mPile.GetGainXPSound()!=None)
			{
				class'H7SoundManager'.static.PlayAkEventOnActor(mPile, mPile.GetGainXPSound(),true, true, mPile.Location );
			}
		}

		mPile.DestroySecure();
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
