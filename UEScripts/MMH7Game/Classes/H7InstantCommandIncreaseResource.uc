//=============================================================================
// H7InstantCommandIncreaseResource
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandIncreaseResource extends H7InstantCommandBase;

var private H7Player mTargetPlayer;
var private string mResourceName;
var private int mResourceQuantity;
var private H7ResourcePile mPile;

function Init( H7Player targetPlayer, string resourceName, int resourceQuantity, optional H7ResourcePile pile = none )
{
	mTargetPlayer = targetPlayer;
	mResourceName = resourceName;
	mResourceQuantity = resourceQuantity;
	mPile = pile;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	mTargetPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[0]) );
	mResourceName = command.StringParameter;
	mResourceQuantity = command.IntParameters[1];

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

	command.Type = ICT_INCREASE_RESOURCE;
	command.StringParameter = mResourceName;
	command.IntParameters[0] = mTargetPlayer.GetPlayerNumber();
	command.IntParameters[1] = mResourceQuantity;
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
	if( mTargetPlayer.GetResourceSet().GetCurrencyIDString() == mResourceName )
	{
		mTargetPlayer.GetResourceSet().ModifyCurrency( mResourceQuantity, true );
	}
	else
	{
		mTargetPlayer.GetResourceSet().ModifyResource( mTargetPlayer.GetResourceSet().GetResourceByIDString( mResourceName ), mResourceQuantity, true );
	}

	if(mPile != none)
	{
		if( mTargetPlayer.IsControlledByLocalPlayer() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_RESOURCE_PICKUP, mPile.Location, mTargetPlayer,  "+"$mResourceQuantity , MakeColor(0,255,0,255), mTargetPlayer.GetResourceSet().GetCurrencyResourceType().GetIcon());

			if(mPile.GetPickUpSound()!=None)
			{
				class'H7SoundManager'.static.PlayAkEventOnActor(mPile, mPile.GetPickUpSound(),true, true, mPile.Location);
			}
		}

		mPile.DestroySecure();
	}

	// update GUI
	if( mTargetPlayer.IsControlledByLocalPlayer() )
	{
		if(class'H7MarketPlacePopupCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			class'H7MarketPlacePopupCntl'.static.GetInstance().UpdateWithCurrentTownOrTradingPost();
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mTargetPlayer;
}
