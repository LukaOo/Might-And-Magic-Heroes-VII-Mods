//=============================================================================
// H7InstantCommandDismissHero
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandDismissHero extends H7InstantCommandBase;

var private H7EditorHero mHero;

function Init( H7EditorHero hero )
{
	mHero = hero;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7EditorHero(eventManageable);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_DISMISS_HERO;
	command.IntParameters[0] = mHero.GetID();
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local array<H7Town> towns;
	local H7Town town;
	local array<H7Fort> forts;
	local H7Fort fort;

	if( mHero != none )
	{
		if( mHero.GetArmy().CanFleeOrSurrender() )
		{
			if( class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == mHero.GetPlayer() )
			{
				hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
				hud.GetHeroWindowCntl().ClosePopup();
			}

			// remove the army from the town
			if( mHero.GetAdventureArmy().GetVisitableSite() != none )
			{
				if( mHero.GetAdventureArmy().GetVisitableSite().GetVisitingArmy() == mHero.GetAdventureArmy() )
				{
					mHero.GetAdventureArmy().GetVisitableSite().SetVisitingArmy( none );
				}
				mHero.GetAdventureArmy().SetVisitableSite( none );
			}
			if( mHero.GetAdventureArmy().GetGarrisonedSite() != none )
			{
				if( mHero.GetAdventureArmy().GetGarrisonedSite().GetVisitingArmy() == mHero.GetAdventureArmy() )
				{
					mHero.GetAdventureArmy().GetGarrisonedSite().SetVisitingArmy( none );
				}
				mHero.GetAdventureArmy().SetGarrisonedSite( none );
			}

			// the hero registration to towns and forts is a complete mess, we need to be sure that the hero is not in a town or fort
			towns=class'H7AdventureController'.static.GetInstance().GetTownList();
			foreach towns(town)
			{
				if( town.GetVisitingArmy() == mHero.GetAdventureArmy() )
				{
					town.SetVisitingArmy( none );
				}
				if( town.GetGarrisonArmy() == mHero.GetAdventureArmy() )
				{
					town.SetGarrisonArmy( none );
				}
			}

			forts=class'H7AdventureController'.static.GetInstance().GetFortList();
			foreach forts(fort)
			{
				if( fort.GetVisitingArmy() == mHero.GetAdventureArmy() )
				{
					fort.SetVisitingArmy( none );
				}
				if( fort.GetGarrisonArmy() == mHero.GetAdventureArmy() )
				{
					fort.SetGarrisonArmy( none );
				}
			}

			// add the hero to the hall of heroes
			mHero.SetCurrentMana( mHero.GetMaxMana() ); // set back full mana
			mHero.SetCurrentMovementPoints( mHero.GetMovementPoints() ); // set back movement points
			class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().AddDefeatedHero( mHero.GetAdventureArmy() );
			mHero.GetAdventureArmy().SetIsBeingRemoved( true );
			mHero.GetAdventureArmy().StartRemoveEffect();
			mHero.GetAdventureArmy().RemoveArmyAfterCombat();
			mHero.GetAdventureArmy().ClearCreatureStackProperties();
		}
	}
	else
	{
		;
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
