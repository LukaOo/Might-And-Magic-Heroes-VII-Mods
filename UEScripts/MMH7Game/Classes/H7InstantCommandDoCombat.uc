//=============================================================================
// H7InstantCommandDoCombat
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandDoCombat extends H7InstantCommandBase;

var private H7AdventureHero mAttackingHero;
var private H7AdventureHero mDefendingHero;
var private H7VisitableSite mSite;
var private bool mIsQuickCombat;
var private bool mIsReplay;


function bool IsQuickCombat() { return mIsQuickCombat; }

function Init( H7AdventureHero attackingHero, H7AdventureHero defendingHero, bool isQuickCombat, bool isReplay, H7VisitableSite site )
{
	mAttackingHero = attackingHero;
	mDefendingHero = defendingHero;
	mIsQuickCombat = isQuickCombat;
	mIsReplay = isReplay;
	mSite = site;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mAttackingHero = H7AdventureHero(eventManageable);
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mDefendingHero = H7AdventureHero(eventManageable);
	mIsQuickCombat = bool(command.IntParameters[2]);	
	mIsReplay = bool(command.IntParameters[3]);

	if(command.IntParameters[4] != -1)
	{
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[4] );
		mSite = H7VisitableSite(eventManageable);
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_DO_COMBAT;
	command.IntParameters[0] = mAttackingHero.GetID();
	command.IntParameters[1] = mDefendingHero.GetID();
	command.IntParameters[2] = int(mIsQuickCombat);
	command.IntParameters[3] = int(mIsReplay);
	command.IntParameters[4] = mSite != none ? mSite.GetID() : -1;
	
	return command;
}

function Execute()
{
	local MPSimTurnOngoingStartCombat ongoingStartCombat;
	local ECombatPlayerType			combatPlayerType;
	local bool participatingInCombat, combatPopupOpen;

	// reset fake random numbers
	if( class'H7ReplicationInfo'.static.GetInstance().GetFakeRandomTarget() != -1 )
	{
		class'H7ReplicationInfo'.static.GetInstance().ResetFakeRandomNumbers();
	}

	// clean combat merge pools
	mAttackingHero.GetAdventureArmy().CleanAllCombatMergePools();
	mDefendingHero.GetAdventureArmy().CleanAllCombatMergePools();

	// set if the player will be attacker or defender
	if( mAttackingHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		combatPlayerType = COMBATPT_ATTACKER;
	}
	else if( mDefendingHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		combatPlayerType = COMBATPT_DEFENDER;
	}
	else
	{
		combatPlayerType = COMBATPT_SPECTATOR;
	}

	if(mSite != none)
	{
		if(mSite.IsA( 'H7BattleSite' ))
		{
			class'H7AdventureController'.static.GetInstance().SetCurrentBattleSite(H7BattleSite(mSite));
		}
		else if(mSite.IsA( 'H7AreaOfControlSite'))
		{
			class'H7AdventureController'.static.GetInstance().SetBeforeBattleArea(H7AreaOfControlSite(mSite));
		}
	}
	H7PlayerReplicationInfo( class'WorldInfo'.static.GetWorldInfo().GetALocalPlayerController().PlayerReplicationInfo ).SetCombatPlayerType( combatPlayerType );

	// safeguard for 'empty' fights
	if( mAttackingHero.GetAdventureArmy().HasUnits()==false || 
		(mDefendingHero.GetAdventureArmy().HasUnits()==false && !mDefendingHero.GetAdventureArmy().HasLocalGuardBacking()) )
	{
		mIsQuickCombat=true;
	}

	// safeguard for PIE
	if(class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor())
	{
		mIsQuickCombat=true;
	}

	if( mIsQuickCombat )
	{
		combatPopupOpen = class'H7PlayerController'.static.GetPlayerController().GetHud().GetCombatPopUpCntl().GetPopup().IsVisible();
		participatingInCombat = mAttackingHero.GetPlayer().IsControlledByLocalPlayer() || ( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && mDefendingHero.GetPlayer().IsControlledByLocalPlayer() );
		if( !mAttackingHero.GetPlayer().IsControlledByAI() && participatingInCombat && combatPopupOpen )
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetCombatPopUpCntl().CompleteQuickCombat();
		}
		else
		{
			class'H7AdventureController'.static.GetInstance().QuickCombatWithAdventureArmies( mAttackingHero.GetAdventureArmy(), mDefendingHero.GetAdventureArmy() );
		}

		if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
		{
			// in singleplayer it is done on closing the combat popup
			if(class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite() != none)
			{
				class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite().OnAccept( mAttackingHero );
				class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite().GetReward( mAttackingHero );
				class'H7AdventureController'.static.GetInstance().SetCurrentBattleSite( none );
			}
			class'H7AdventureController'.static.GetInstance().SetBeforeBattleArea( none );
		}
	}
	else
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && 
			!mDefendingHero.GetPlayer().IsControlledByLocalPlayer() && 
			!mAttackingHero.GetPlayer().IsControlledByLocalPlayer() && 
			!class'H7AdventureController'.static.GetInstance().IsSimTurnOfAI())
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().HighlightGUIElement( "", "", Repl( class'H7Loca'.static.LocalizeSave("PU_MULTIPLAYER_COMBAT_STARTING_SEC","H7PopUp"),"%seconds", 3), none );
			class'H7AdventureController'.static.GetInstance().SetTimer( 1.f, false, nameof(Show2SecondsGUI), self );
			class'H7AdventureController'.static.GetInstance().SetTimer( 2.f, false, nameof(Show1SecondGUI), self );
			class'H7AdventureController'.static.GetInstance().SetTimer( 3.f, false, nameof(ShowStartingGUI), self );
			class'H7AdventureController'.static.GetInstance().SetTimer( 3.5f, false, nameof(StartCombatMap), self );
		}
		else
		{
			StartCombatMap();
		}
	}

	// reset the ongoingstartcombat if the player army attacks a neutral army 
	if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
	{
		ongoingStartCombat = class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().GetOngoingStartCombat();
		if( ongoingStartCombat.Source == mAttackingHero && ongoingStartCombat.Target == mDefendingHero && (mDefendingHero.GetPlayer().IsNeutralPlayer() || mDefendingHero.GetPlayer().IsControlledByAI()) )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().ResetOngoingStartCombat();
		}
	}
}

function Show1SecondGUI()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().HighlightGUIElement( "", "", Repl( class'H7Loca'.static.LocalizeSave("PU_MULTIPLAYER_COMBAT_STARTING_SEC","H7PopUp"),"%seconds", 1), none );
}

function Show2SecondsGUI()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().HighlightGUIElement( "", "", Repl( class'H7Loca'.static.LocalizeSave("PU_MULTIPLAYER_COMBAT_STARTING_SEC","H7PopUp"),"%seconds", 2), none );
}

function ShowStartingGUI()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().HighlightGUIElement( "", "", class'H7Loca'.static.LocalizeSave("PU_MULTIPLAYER_COMBAT_STARTING","H7PopUp"), none );
}


function StartCombatMap()
{
	local H7AreaOfControlSite garrisonSite;
	local array<H7BaseCreatureStack> baseStacks;
	local int i;

	garrisonSite = H7AreaOfControlSite( mDefendingHero.GetAdventureArmy().GetGarrisonedSite() );
	if( ( mDefendingHero.GetAdventureArmy().IsGarrisoned() || mDefendingHero.GetAdventureArmy().IsGarrisonedButOutside() ) && garrisonSite != none && !mIsReplay )
	{
		;

		baseStacks = garrisonSite.GetLocalGuardAsBaseCreatureStacks();

		//merge local guard and defending army
		if(baseStacks.Length > 0)
		{
		
			for(i = baseStacks.Length-1; i >= 0; i--)
			{
				if( baseStacks[ i ] == none || baseStacks[ i ].GetStackType() == none
					|| baseStacks[ i ].GetStackSize() <= 0)
					continue;

				mDefendingHero.GetAdventureArmy().AddCreatureStack( baseStacks[ i ] );
			}
		}
	}

	if( mAttackingHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		mAttackingHero.PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_ENGAGE_COMBAT);
	}

	class'H7AdventureController'.static.GetInstance().StartCombat( mAttackingHero.GetAdventureArmy(), mDefendingHero.GetAdventureArmy(), false );

	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && !mDefendingHero.GetPlayer().IsControlledByLocalPlayer() && !mAttackingHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		class'H7PlayerController'.static.GetPlayerController().GetHud().DeleteAllHighlights();
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mAttackingHero.GetPlayer();
}
