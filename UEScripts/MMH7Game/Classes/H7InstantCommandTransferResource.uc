//=============================================================================
// H7InstantCommandTransferResource
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandTransferResource extends H7InstantCommandBase;

var private H7Player mTargetPlayer;
var private H7Player mSourcePlayer;
var private string mResourceNameGet;
var private string mResourceNameGive;
var private int mResourceQuantityGet;
var private int mResourceQuantityGive;

function Init( H7Player sourcePlayer, H7Player targetPlayer, string resourceNameGive, string resourceNameGet, int resourceQuantityGive, int resourceQuantityGet )
{
	mSourcePlayer = sourcePlayer;
	mTargetPlayer = targetPlayer;
	mResourceNameGive = mTargetPlayer.GetResourceSet().GetResourceByName( resourceNameGive ).GetIDString();
	mResourceNameGet = mTargetPlayer.GetResourceSet().GetResourceByName( resourceNameGet ).GetIDString();
	mResourceQuantityGive = resourceQuantityGive;
	mResourceQuantityGet = resourceQuantityGet;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	mSourcePlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[0]) );
	mTargetPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[1]) );
	mResourceNameGive = Left(command.StringParameter, InStr(command.StringParameter, ","));
	mResourceNameGet = Mid(command.StringParameter, InStr(command.StringParameter, ",") + 1);
	mResourceQuantityGive = command.IntParameters[2];
	mResourceQuantityGet = command.IntParameters[3];
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_TRADE_RESOURCE;
	command.StringParameter = mResourceNameGive$","$mResourceNameGet;
	command.IntParameters[0] = mSourcePlayer.GetPlayerNumber();
	command.IntParameters[1] = mTargetPlayer.GetPlayerNumber();
	command.IntParameters[2] = mResourceQuantityGive;
	command.IntParameters[3] = mResourceQuantityGet;

	return command;
}

function Execute()
{
	local H7Message message;
	local H7Resource resource;

	resource = mTargetPlayer.GetResourceSet().GetResourceByIDString( mResourceNameGet );
	
	if(mSourcePlayer != mTargetPlayer)
	{
		message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mPlayerSentResources.CreateMessageBasedOnMe();
		message.mPlayerNumber = mTargetPlayer.GetPlayerNumber();
		message.AddRepl("%player",mSourcePlayer.GetName());
		message.AddRepl("%amount",string(mResourceQuantityGet));
		message.AddRepl("%icon","<img src='"$ resource.GetIconPath() $"' width='#TT_BODY#' height='#TT_BODY#'>");
		message.AddRepl("%resource",resource.GetName());
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}

	//tooltip = `Localize("H7Message","MSG_PLAYER_SENT_RESOURCES","MMH7Game");

	if( mSourcePlayer.GetResourceSet().GetCurrencyIDString() == mResourceNameGive )
	{
		mSourcePlayer.GetResourceSet().ModifyCurrency( -mResourceQuantityGive, true );
	}
	else
	{
		mSourcePlayer.GetResourceSet().ModifyResource( mSourcePlayer.GetResourceSet().GetResourceByIDString( mResourceNameGive ), -mResourceQuantityGive, true );
	}

	if( mTargetPlayer.GetResourceSet().GetCurrencyIDString() == mResourceNameGet )
	{
		mTargetPlayer.GetResourceSet().ModifyCurrency( mResourceQuantityGet, true );
	}
	else
	{
		mTargetPlayer.GetResourceSet().ModifyResource( mTargetPlayer.GetResourceSet().GetResourceByIDString( mResourceNameGet ), mResourceQuantityGet, true );
	}	

	// update GUI
	if( mSourcePlayer.IsControlledByLocalPlayer() )
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
	return mSourcePlayer;
}
