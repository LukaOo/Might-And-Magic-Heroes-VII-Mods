//=============================================================================
// H7QuickCombatPopUpCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatPopUpCntl extends H7FlashMovieBlockPopupCntl; 

var protected H7GFxCombatPopUp mCombatPopup;
var protected H7GFxUIContainer mSiegeCombatPopUp;
var protected H7GFxUIContainer mNegoPopup;
var protected H7GFxArmyRow mUpperArmy;
var protected H7GFxArmyRow mLowerArmy;
var protected H7GFxArmyMergePopup mArmyMergePopup;
var protected H7EditorHero mOwner;

var protected H7AdventureArmy mAttackingArmy, mDefendingArmy;
var protected H7CombatArmy mAttackingArmyCombat, mDefendingArmyCombat;
var protected array<H7BaseCreatureStack> mSourceStacks;
var protected array<H7BaseCreatureStack> mLocalGuardStacks;
var string mPoolKey;
var bool mActivePlayerIsAttacker, mAttackerWon;
var bool mOnCombatMap;
var bool mCheckMOnCombatMap; //defines if the mOnCombatMap member should be checked in closePopup method
var bool mQuickCombatDone;
var bool mQuickCombatDoneWasTrue; // YOLO
var bool mCanFight;
var bool mReceivedUnits;
var bool mMergeStandAlone;
var bool mCaravanMerge;
var bool mIsSiege;
var bool mUseSourceStacks;
var bool mIsAlreadyClosing;
var bool mDontCallBtnClose; // this is now the goto-solution to not call btnCloseClick, now only used when clicking startCombat
var bool mNegoPopUpUsingMerger; // when negotiationPopUp sets the merger to visible then unreal doesnt know this, so we have to tell it

var int mDismissArmyIndex;
var int mDismissIndex;

var protected H7GFxUIContainer mCurrentPopup;

var array<H7ResourceQuantity> mCreatureArmyCost;
var bool mIsReinforcement;
var H7TeleportCosts mMergeCost;

var protected bool mCombatPopupNeedAnswer;

var protected H7AreaOfControlSite mConquerSite;
var protected H7AdventureHero mConquerHero;

public delegate OnReinforceComplete(bool success);

function H7GFxCombatPopUp GetCombatPopUp() { return mCombatPopup;}
function H7GFxUIContainer GetPopup() { if(mCurrentPopup!=none) return mCurrentPopup; else return mCombatPopup; }
function H7AdventureArmy GetDefendingArmy() { return mDefendingArmy;}
static function H7CombatPopUpCntl GetInstance() {return class'H7PlayerController'.static.GetPlayerController().GetHUD().GetCombatPopUpCntl();}

function bool CanClose()
{
	if(class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor() && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()) return false;
	else return true;
}

function bool Initialize()
{
	;
	mCheckMOnCombatMap = true;
	Super.Start();
	AdvanceDebug(0);

	mCombatPopup = H7GFxCombatPopUp(mRootMC.GetObject("aQuickCombatPopUp", class'H7GFxCombatPopUp'));
	mCombatPopup.SetVisibleSave(false);

	mSiegeCombatPopup = H7GFxUIContainer(mRootMC.GetObject("aSiegeCombatPopUp", class'H7GFxCombatPopUp'));

	mNegoPopup = H7GFxUIContainer(mRootMC.GetObject("aNegotiationPopUp", class'H7GFxUIContainer'));
	
	mArmyMergePopup = H7GFxArmyMergePopup(mRootMC.GetObject("aArmyMerger", class'H7GFxArmyMergePopup'));
	
	mUpperArmy = H7GFxArmyRow(mArmyMergePopup.GetObject("mUpperArmy", class'H7GFxArmyRow'));
	mLowerArmy = H7GFxArmyRow(mArmyMergePopup.GetObject("mLowerArmy", class'H7GFxArmyRow'));

	Super.Initialize();
	
	return true;
}

function InitWindowKeyBinds()
{
	//CreatePopupKeybind('Q',"QuickCombat",GoForward);
	CreatePopupKeybind('C',"PlayCombat",StartCombat);
	
	//CreatePopupKeybind('A',"NegotiationAccept",StartCombatNeg);
	//CreatePopupKeybind('C',"NegotiationCancel",StartCombatNeg);
	CreatePopupKeybind('F',"NegotiationFight",StartCombatNeg);
	
	super.InitWindowKeyBinds();
}

function StartCombat()
{
	if( class'H7AdventureController'.static.GetInstance().GetForceQuickCombat() == FQC_NEVER
		&& !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	BtnStartCombatClicked();
}

function StartCombatNeg()
{
	if(mCurrentPopup == mNegoPopup)
		NegoBtnAttackClicked();
}

function ShowStartCombatPopUp( H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy )
{
	// multiplayer games, all the fights vs neutral armies should be quickcombat
	// only executed for the attacker the others will get a RPC
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && !attackingArmy.GetPlayer().IsControlledByLocalPlayer() && defendingArmy.GetPlayer().GetPlayerNumber() == PN_NEUTRAL_PLAYER )
	{
		return;
	}
	
	// dont show the combatPopUp when is a mulitplayer game and the attacker is not owned by the local player
	// Sim turns: the defender should show the combatPopUp too
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && !attackingArmy.GetPlayer().IsControlledByLocalPlayer() && ( !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() || !defendingArmy.GetPlayer().IsControlledByLocalPlayer() ) )
	{
		return;
	}

	// close a previously open
	GetHUD().UnblockAllFlashMovies();
	GetHUD().GetBackgroundImageCntl().UnloadBackground();

	// really close popup
	GetHUD().CloseCurrentPopup();
	GetHUD().GetRequestPopupCntl().ClosePopup();

	mCombatPopupNeedAnswer = true;
	UpdateCombatPopup( attackingArmy, defendingArmy );
}

function UpdateCombatPopup(H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy)
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local H7AreaOfControlSite garrisonSite;
	local H7VisitableSite site;

	// start pending caravans for defending player (only happens if he is interrupted in the recruitment screen)
	if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && defendingArmy.GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER)
	{
		class'H7AdventureController'.static.GetInstance().StartRecruitedCaravans(defendingArmy.GetPlayer());
	}

	mOnCombatMap = false;
	mCanFight = false;
																				
	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies( class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), false);

	//first we assume the current player is the attacker
	mAttackingArmy = attackingArmy;
	mDefendingArmy = defendingArmy;
	mActivePlayerIsAttacker = true;
	
	// Check if we have creatures to fight with
	if( mAttackingArmy.HasUnits() )
	{
		mCanFight = true;
	}

	foreach armies(army)
	{
		if(army == defendingArmy)
		{
			// the player is the defender
			mActivePlayerIsAttacker = false;
			break;
		}
	}

	site = defendingArmy.GetGarrisonedSite();
	garrisonSite = H7AreaOfControlSite( site );
	if( ( defendingArmy.IsGarrisoned() || defendingArmy.IsGarrisonedButOutside() ) && garrisonSite != none )
	{
		;
		//here we just get the local guard to show them in the combatPopUp
		// they are then used later in the complete quickcombat method
		mLocalGuardStacks = garrisonSite.GetLocalGuardAsBaseCreatureStacks();
		mCurrentPopup = mSiegeCombatPopUp;
		mIsSiege = true;
	}
	else
	{
		// when coming from negotiationPopUp we need to set the combatPopUp to be the currentPopUp
		// also in general, it "should" no be a bad idea to set this here
		mCurrentPopup = mCombatPopup;
	}

	OpenPopup();
	mCombatPopUp.Update(attackingArmy, defendingArmy, mActivePlayerIsAttacker, mLocalGuardStacks);
	//mCombatPopUp.SetVisibleSave(true);
	;
}

/**
 * called from flash upon timer running out
 */
function CombatPopUpTimerFinished()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("CombatPopUpTimerFinished", 0);;
	if( mCombatPopupNeedAnswer && class'H7CombatController'.static.GetInstance() == none )
	{
		if(!mAttackingArmy.HasUnits())
		{
			BtnCancelClicked();
			return;
		}       
		
		if( class'H7AdventureController'.static.GetInstance().GetForceQuickCombat() == FQC_NEVER )
		{
			BtnStartCombatClicked();
		}
		else if( class'H7AdventureController'.static.GetInstance().GetForceQuickCombat() == FQC_AGAINST_AI && !mDefendingArmy.GetPlayer().IsControlledByAI() )
		{
			BtnStartCombatClicked();
		}
		else
		{
			//use this mehtod to start quickCombat when timer runs out
			mCombatPopup.ClickBtnQuickCombatFromUnreal(mIsSiege);	
		
		}
	}
}

function NegotiationPopUpTimerFinished()
{
	local int heroId;

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		// Sim Turns: default action for the player is cancel
		heroId = mAttackingArmy.GetPlayer().IsControlledByLocalPlayer() ? mAttackingArmy.GetHero().GetID() : mDefendingArmy.GetHero().GetID();
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendSimTurnAnswerStartCombat( STSCA_CANCEL, heroId );
	}

	class'H7ReplicationInfo'.static.PrintLogMessage("NegotiationPopUpTimerFinished", 0);;
	ClosePopupHard();
}

function ArmyMergerTimerFinished()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("ArmyMergerTimerFinished", 0);;
	ClosePopupHard();
}

////////////////Negotiation

function UpdateNegotiationPopUp(H7AdventureArmy heroArmy, H7AdventureArmy creatureArmy, bool join, optional array<H7ResourceQuantity> cost, optional bool force)
{
	// dont show the combatPopUp when is a mulitplayer game and the attacker is not owned by the local player
	if( heroArmy.GetPlayer().IsControlledByLocalPlayer() )
	{
		if(cost.Length > 0) mCreatureArmyCost = cost;
		mAttackingArmy = heroArmy;
		mDefendingArmy = creatureArmy;
		mCombatPopup.UpdateNegotiationPopUp(heroArmy, creatureArmy, join, cost, force);
		mCurrentPopup = mNegoPopup;
		OpenPopup();
	}
}

function NegoBtnAcceptClicked(bool join, bool canMerge)
{
	local array<H7BaseCreatureStack> creatureStacks;
	local H7BaseCreatureStack stack;

	mAttackingArmy.JoinArmy( mDefendingArmy, join, canMerge );
	
	if( join && mCreatureArmyCost.Length > 0 )
	{
		mAttackingArmy.GetPlayer().GetResourceSet().SpendResources( mCreatureArmyCost, true, true );
		mCreatureArmyCost.Length = 0; // dude paid, so reset costs
	}

	// if can merge is true the armies already have been merged, and feedback was already given
	// otherwise mReceived units is true as soon as the player requested a successfull unit transfer
	// so we assume he transfered units from the defending army to his own
	if( join && mReceivedUnits )
	{
		creatureStacks = mDefendingArmy.GetBaseCreatureStacks();
		foreach creatureStacks(stack)
		{
			if(stack.GetStackType() != none && stack.GetStackSize() > 0)
			{
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, mAttackingArmy.GetHero().GetLocation(), mAttackingArmy.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_RECIEVED_UNIT","H7FCT"), MakeColor(0,255,0,255), stack.GetStackType().GetIcon());
			}
		}
	}
	ClosePopUp();
}

function JoinArmyComplete()
{

}

function NegoBtnRefuseClicked()
{
	ClosePopUp();
}

function NegoBtnAttackClicked()
{
	UpdateCombatPopup(mAttackingArmy, mDefendingArmy);
}

function NegoBtnLetThemGoClicked()
{
	local H7InstantCommandLetEnemyFlee command;

	command = new class'H7InstantCommandLetEnemyFlee';
	command.Init( mDefendingArmy, mAttackingArmy );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );

	ClosePopup();
}

function UpdateFromCombatMap(int XPWinner, int XPLoser, H7CombatArmy army, optional bool fled = false, optional bool surrendered = false, optional int paidGold)
{
	local bool isGarrisonedSite;
	GetHUD().CloseCurrentPopup();
	GetHUD().GetRequestPopupCntl().ClosePopup();

	//TODO: fit window for enmy surrender and flee
	mOnCombatMap = true;
	
	mActivePlayerIsAttacker = true;
	if(class'H7CombatController'.static.GetInstance().GetArmyAttacker() != army)
		mActivePlayerIsAttacker = false;
	
	isGarrisonedSite = army.GetAdventureHero().GetAdventureArmy().GetGarrisonedSite() != none || class'H7CombatController'.static.GetInstance().GetOpponentArmy(army).GetAdventureHero().GetAdventureArmy().GetGarrisonedSite() != none;
	
	if( class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite() == none && isGarrisonedSite )
	{
		;
		mCurrentPopup = mSiegeCombatPopUp;
	}
	;
	
	mCombatPopUp.UpdateFromCombatMap(XPWinner, XPLoser, army, mActivePlayerIsAttacker, fled, surrendered, paidGold);
	
	// spectators cannot see the result
	if( class'H7AdventureController'.static.GetInstance() != none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() &&
		H7PlayerReplicationInfo( class'H7ReplicationInfo'.static.GetInstance().GetALocalPlayerController().PlayerReplicationInfo ).GetCombatPlayerType() == COMBATPT_SPECTATOR )
	{
		BtnCancelClicked();
	}
	else
	{
		OpenPopup();
	}
}

function BtnStartCombatClicked(optional EventData data) // or fightmanually combat start or adv-combat restart
{
	local bool isReplayCombat;
	local int heroId, i;
	local H7InstantCommandDoCombat command;
	local H7EventContainerStruct eventContainer;
	local array<H7HeroItem>	    scrollsUsedInCombat;

	mCombatPopupNeedAnswer = false;
	mQuickCombatDone = false;

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ENGAGE_COMBAT");

	if( class'H7AdventureController'.static.GetInstance() == none ) // DUEL
	{
		if( class'H7TransitionData'.static.GetInstance().GetPreviousMapName() == class'H7GameData'.static.GetInstance().GetHubMapName() )
		{
			class'H7TransitionData'.static.GetInstance().SetUseMe( true );
		}
		class'H7ReplicationInfo'.static.GetInstance().StartMap( class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName() );
		return;
	}

	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SetTransitioningToCombat( true );

	isReplayCombat = class'H7ReplicationInfo'.static.GetInstance().IsCombatMap();

	if( !isReplayCombat && !WillCombatStart() )
	{
		return;
	}
	
	if( isReplayCombat )
	{
		mAttackingArmy = class'H7AdventureController'.static.GetInstance().GetArmyAttacker();
		mAttackingArmy.ResetAllCreatureStack();

		scrollsUsedInCombat = mAttackingArmy.GetHero().GetInventory().GetUsedConsumable();

		if(scrollsUsedInCombat.Length > 0)
		{
			for(i = 0; i<scrollsUsedInCombat.Length; i++)
			{
				mAttackingArmy.GetHero().GetInventory().AddItemToInventoryComplete(scrollsUsedInCombat[i]);
				eventContainer.EffectContainer = scrollsUsedInCombat[i];
				eventContainer.Targetable = mAttackingArmy.GetHero();
				scrollsUsedInCombat[i].TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
				mAttackingArmy.GetHero().TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
			}
		}

		mDefendingArmy = class'H7AdventureController'.static.GetInstance().GetArmyDefender();
		mDefendingArmy.ResetAllCreatureStack();

		scrollsUsedInCombat = mDefendingArmy.GetHero().GetInventory().GetUsedConsumable();

		if(scrollsUsedInCombat.Length > 0)
		{
			for(i = 0; i<scrollsUsedInCombat.Length; i++)
			{
				mDefendingArmy.GetHero().GetInventory().AddItemToInventory(scrollsUsedInCombat[i]);
				eventContainer.EffectContainer = scrollsUsedInCombat[i];
				eventContainer.Targetable = mDefendingArmy.GetHero();
				scrollsUsedInCombat[i].TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
				mDefendingArmy.GetHero().TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
			}
		}

		class'H7CreatureStackPlateController'.static.GetInstance().DeleteAllStackPlates();
		class'H7CombatMapStatusBarController'.static.GetInstance().DeleteAllBars();
	}
	else
	{
		// update stack properties with growth so fight again won't revert the stack sizes
		if( mDefendingArmy.GetPlayer().GetPlayerNumber() == PN_NEUTRAL_PLAYER )
		{
			mDefendingArmy.CreateCreatureStackProperies();
		}
	}

	GetHUD().UnblockAllFlashMovies();
	GetHUD().GetBackgroundImageCntl().UnloadBackground();
	
	mCombatPopUp.Reset();

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && !mDefendingArmy.GetPlayer().IsNeutralPlayer() && !mDefendingArmy.GetPlayer().IsControlledByAI() )
	{
		GetHUD().SetHUDMode(HM_WAITING_OTHER_PLAYER_ANSWER);

		// Sim Turns: the combat only starts when the server says it
		heroId = mAttackingArmy.GetPlayer().IsControlledByLocalPlayer() ? mAttackingArmy.GetHero().GetID() : mDefendingArmy.GetHero().GetID();
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendSimTurnAnswerStartCombat( STSCA_NORMAL_COMBAT, heroId );
	}
	else
	{
		// in case these contain the quickcombat-produced armies, we have to delete them, so that the realcombat-produced armies are taken later
		if( mAttackingArmyCombat != none )
		{
			mAttackingArmyCombat.Destroy();
		}
		if( mDefendingArmyCombat != none )
		{
			mDefendingArmyCombat.Destroy();
		}
		mAttackingArmyCombat = none; 
		mDefendingArmyCombat = none;
		command = new class'H7InstantCommandDoCombat';
		command.Init( mAttackingArmy.GetHero(), mDefendingArmy.GetHero(), false, isReplayCombat, mDefendingArmy.GetGarrisonedSite() );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	}

	//set mDontCallBtnClose so btnClose isnt called
	//call updateArmiesEndCombat
	mDontCallBtnClose = true;
	ClosePopup();
}
////////////////////QUICKCOMBAT///////////////////////////////////////////////////////	     
function BtnStartQuickCombatClicked(optional EventData data)
{
	local H7InstantCommandDoCombat command;
	local int heroId;

	if( !WillCombatStart() )
	{
		return;
	}

	mCombatPopupNeedAnswer = false;
	mQuickCombatDone = true;

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && !mDefendingArmy.GetPlayer().IsNeutralPlayer() && !mDefendingArmy.GetPlayer().IsControlledByAI())
	{
		GetHUD().SetHUDMode( HM_WAITING_OTHER_PLAYER_ANSWER );

		// Sim Turns: the combat only starts when the server says it
		heroId = mAttackingArmy.GetPlayer().IsControlledByLocalPlayer() ? mAttackingArmy.GetHero().GetID() : mDefendingArmy.GetHero().GetID();
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendSimTurnAnswerStartCombat( STSCA_QUICK_COMBAT, heroId );
		return;
	}

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ENGAGE_QUICK_COMBAT");
	command = new class'H7InstantCommandDoCombat';
	command.Init( mAttackingArmy.GetHero(), mDefendingArmy.GetHero(), true, false, mDefendingArmy.GetGarrisonedSite() );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function CompleteQuickCombat()
{
	local array<H7BaseCreatureStack> attackerProps, defenderProps, attackerOriginalProps, defenderOriginalProps, attackerLoses, defenderLoses;
	local H7BaseCreatureStack prop; 
	local int i;
	local H7SiegeTownData siegeTownData;
	local bool isSiege;

	;

	class'H7AdventureController'.static.GetInstance().SetBeforeCombatCell( mDefendingArmy.GetCell() );
	mAttackingArmyCombat = mAttackingArmy.CreateCombatArmyUsingAdventureArmy( mAttackingArmy, true, true );
	mDefendingArmyCombat = mDefendingArmy.CreateCombatArmyUsingAdventureArmy( mDefendingArmy, false, true );

	class'H7AdventureController'.static.GetInstance().SetArmyAttackerCombat(mAttackingArmyCombat);
	class'H7AdventureController'.static.GetInstance().SetArmyDefenderCombat(mDefendingArmyCombat);
	class'H7AdventureController'.static.GetInstance().SetArmyAttacker(mAttackingArmy);
	class'H7AdventureController'.static.GetInstance().SetArmyDefender(mDefendingArmy); 

	// merging local guard to combat army
	isSiege = class'H7AdventureController'.static.GetInstance().PreQuickCombatWithCombatArmies( mDefendingArmy, mDefendingArmyCombat, mLocalGuardStacks, siegeTownData );

	attackerOriginalProps = mAttackingArmy.GetBaseCreatureStacksDereferenced();
	defenderOriginalProps = mDefendingArmyCombat.GetBaseCreatureStacksDereferenced();

	mAttackerWon = class'H7AdventureController'.static.GetInstance().QuickCombatWithCombatArmies( mAttackingArmyCombat, mDefendingArmyCombat, isSiege, siegeTownData );
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr( mAttackerWon ? "VICTORY_QUICK_COMBAT" : "DEFEAT_QUICK_COMBAT" );

	attackerProps = mAttackingArmyCombat.GetBaseCreatureStacks();
	defenderProps = mDefendingArmyCombat.GetBaseCreatureStacks();

	foreach defenderOriginalProps( prop, i )
	{
		defenderLoses[i] = new class'H7BaseCreatureStack'( defenderOriginalProps[i] );
		
		//if creature stack was annihilated completaly
		if((defenderProps[i] == none && defenderOriginalProps[i] != none) || mAttackerWon)
		{
			defenderLoses[i].SetStackSize(defenderOriginalProps[i].GetStackSize());
			continue;
		}
		
		defenderLoses[i].SetStackSize( defenderOriginalProps[i].GetStackSize() - defenderProps[i].GetStackSize() );
	}
	
	foreach attackerOriginalProps( prop, i)
	{
		attackerLoses[i] = new class'H7BaseCreatureStack'( attackerOriginalProps[i] );
		
		//if creature stack was annihilated completaly
		if((attackerProps[i] == none && attackerOriginalProps[i] != none) || !mAttackerWon)
		{
			attackerLoses[i].SetStackSize(attackerOriginalProps[i].GetStackSize());
			continue;
		}
	
		attackerLoses[i].SetStackSize( attackerOriginalProps[i].GetStackSize() - attackerProps[i].GetStackSize() );
	}

	mCombatPopUp.OnEndQuickCombatUpdate( attackerLoses, defenderLoses, mAttackerWon, mAttackingArmyCombat.GetHero(), mDefendingArmyCombat.GetHero(), mActivePlayerIsAttacker, mIsSiege );
		
	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		UpdateArmiesEndCombat();
	}

}

protected function UpdateArmiesEndCombat()
{
	// FINALIZE advarmies
	if(mAttackingArmy == none)
	{
		mAttackingArmy = class'H7AdventureController'.static.GetInstance().GetArmyAttacker();
	}
	if(mDefendingArmy == none)
	{
		mDefendingArmy = class'H7AdventureController'.static.GetInstance().GetArmyDefender();
	}
	if(mAttackingArmyCombat == none && class'H7CombatController'.static.GetInstance() != none)
	{
		mAttackingArmyCombat = class'H7CombatController'.static.GetInstance().GetArmyAttacker();
	}
	if(mDefendingArmyCombat == none && class'H7CombatController'.static.GetInstance() != none)
	{
		mDefendingArmyCombat = class'H7CombatController'.static.GetInstance().GetArmyDefender();
	}

	if(mAttackingArmyCombat != none)
	{
		class'H7AdventureController'.static.GetInstance().FinalizeAfterCombat( mAttackingArmy , mDefendingArmy , mAttackingArmyCombat , mDefendingArmyCombat , mQuickCombatDone);
		mAttackingArmy = mAttackingArmyCombat.GetAdventureHero().GetAdventureArmy();
		mDefendingArmy = mDefendingArmyCombat.GetAdventureHero().GetAdventureArmy();
		if(mAttackingArmyCombat.WonBattle())
		{   
			mAttackerWon = true;
		}
		else
		{
			mAttackerWon = false;
		}
	}

	if( mQuickCombatDone )
	{
		;
	}
	else 
	{
		if( mDefendingArmy != none && mDefendingArmy.IsGarrisoned() && !mAttackerWon )
		{
			mDefendingArmy.GetGarrisonedSite().SetVisitingArmy( none );
		}
	}
}

function BtnCancelClicked() // or close
{
	local bool wasQuickCombatDone;

	if(class'Engine'.static.GetCurrentWorldInfo().IsPlayInPreview() 
		&& class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()
		&& class'H7AdventureController'.static.GetInstance() == none)
	{
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_ALL_MUSIC");
		ConsoleCommand("quit");
		return;
	}		

	wasQuickCombatDone = mQuickCombatDone;
	mIsAlreadyClosing = true;
	mCombatPopupNeedAnswer = false;

	;
	class'H7ReplicationInfo'.static.PrintLogMessage("CombatPopUp.BtnCancelClicked()", 0);;

	if( !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		UpdateArmiesEndCombat();
	}

	if( mQuickCombatDone )
	{
		mQuickCombatDoneWasTrue = true; // ooooh yeah
		mQuickCombatDone = false;
				
		mAttackingArmyCombat.Destroy();
		mDefendingArmyCombat.Destroy();
		mAttackingArmyCombat = none;
		mDefendingArmyCombat = none;
		if( wasQuickCombatDone && class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite() != none && mAttackerWon && !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
		{
			// in multiplayer it is done in the H7InstantCommandDoCombat
			class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite().OnAccept( mAttackingArmy.GetHero() );
			class'H7AdventureController'.static.GetInstance().GetCurrentBattleSite().GetReward( mAttackingArmy.GetHero() );
			class'H7AdventureController'.static.GetInstance().SetBeforeBattleArea( none );
		}
	}
	else 
	{
		// TODO: This should be called only when the cancel button is pressed
		if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
		{
			if( mDefendingArmy.GetPlayer().IsNeutralPlayer() || mDefendingArmy.GetPlayer().IsControlledByAI() )
			{
				class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendSimTurnAnswerStartCombat( STSCA_CANCEL, mAttackingArmy.GetHero().GetID() );
			}
			else if( mAttackingArmy.GetPlayer().IsControlledByLocalPlayer() )
			{
				GetHUD().SetHUDMode( HM_WAITING_OTHER_PLAYER_ANSWER );

				class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendSimTurnAnswerStartCombat( STSCA_CANCEL, mAttackingArmy.GetHero().GetID() );
			}
			else if( mDefendingArmy.GetPlayer().IsControlledByLocalPlayer() )
			{
				// sieged armies cannot retreat
				if( mIsSiege || !mDefendingArmy.CanRetreat())
				{
					GetHUD().SetHUDMode( HM_WAITING_OTHER_PLAYER_ANSWER );
					class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendSimTurnAnswerStartCombat( STSCA_NORMAL_COMBAT, mDefendingArmy.GetHero().GetID() );
				}
				else
				{
					GetHUD().SetHUDMode( HM_WAITING_OTHER_PLAYER_ANSWER );
					class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendSimTurnAnswerStartCombat( STSCA_RETREAT, mDefendingArmy.GetHero().GetID() );
					mDefendingArmy.IncNumTimesAlreadyRetreated();
				}
			}
			else
			{
				;
			}
		}
		if( !mOnCombatMap )
		{
			class'H7AdventureController'.static.GetInstance().SetBeforeBattleArea( none );
		}
	}
	
	if( HasArmyToMerge() )
	{
		HandleArmyMerging();
	}
	else
	{
		if (wasQuickCombatDone) // was quick combat, trigger event before reset
		{
			class'H7AdventureController'.static.GetInstance().TriggerQuickCombatStartEvent(mAttackingArmy, mDefendingArmy);
			if (mAttackerWon)
			{
				class'H7AdventureController'.static.GetInstance().TriggerCombatEvent(mAttackingArmy, mDefendingArmy);
			}
			else
			{
				class'H7AdventureController'.static.GetInstance().TriggerCombatEvent(mDefendingArmy, mAttackingArmy);
			}
		}
        else if (mOnCombatMap)
		{
			class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().SetCombatHudVisible(false);
			class'H7CameraActionController'.static.GetInstance().FadeToBlack(0.1f);
			if(class'H7CombatController'.static.GetInstance() != none)
			{
				class'H7CombatController'.static.GetInstance().SetTimer(0.15f, false, 'TravelBack');
			}
		}

		ClosePopup();
	}
}

////////////////////////////////////////////////////////////////
// POST COMBAT MERGE (necromancy & shadow of death) support code & other support code

function int GetNextLevelMaxXP(bool forAttackerHero)
{
	if(mAttackingArmy == none)
	{
		;
		mAttackingArmyCombat = class'H7CombatController'.static.GetInstance().GetArmyAttacker();
	}
	if(mDefendingArmy == none)
	{
		;
		mDefendingArmyCombat = class'H7CombatController'.static.GetInstance().GetArmyDefender();
	}

	if(forAttackerHero)
	{
		mAttackingArmyCombat.GetHero().SetLevel(mAttackingArmyCombat.GetHero().GetLevel() + 1);
		return mAttackingArmyCombat.GetHero().GetNextLevelXp();
	}
	else
	{
		mDefendingArmyCombat.GetHero().SetLevel(mDefendingArmyCombat.GetHero().GetLevel() + 1);
		return mDefendingArmyCombat.GetHero().GetNextLevelXp();
	}
}

function SetWinningArmy(H7AdventureArmy army)
{
	mAttackerWon = true;
	mAttackingArmy = army;
}

function bool HasArmyToMerge()
{
	local array<H7BaseCreatureStack> stacks;
	local H7Player player;
	local H7MergePool pool;

	player = GetWinningArmy().GetPlayer();

	// clear merge pools of losing army
	if( mAttackerWon ) mDefendingArmy.CleanAllCombatMergePools();
	else mAttackingArmy.CleanAllCombatMergePools();

	// hotseat -> yes
	// multi-simturn -> only if localplayer
	// multi-conturn -> only if localplayer
	// single -> if localplayer
	if(player != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()) 
	{
		if(!class'H7AdventureController'.static.GetInstance().IsHotSeat()) return false;
	}
	// ai never merges with popups
	if(player.GetPlayerType() == PLAYER_AI) return false;

	//stacks = GetWinningArmy().GetTempStackArray();
	pool = GetWinningArmy().GetAMergePool();
	stacks = pool.PoolStacks;
	return stacks.Length > 0;
}

function bool ContainesUnits(array<H7BaseCreatureStack> stacks)
{
	local H7BaseCreatureStack stack;
	foreach stacks(stack)
	{
		if(stack != none && stack.GetStackSize() > 0) return true;
	}
	return false;
}

function H7AdventureArmy GetWinningArmy()
{
	// in quick combat and on combat map, both armiey and the bool should be set
	if(mAttackerWon) return mAttackingArmy;
	else return mDefendingArmy;
}


/////////////////////////////////////////////////////

protected function bool WillCombatStart()
{
	local array<H7BaseCreatureStack> emptyArray, localGuard;
	local H7BaseCreatureStack localStack;
	local H7AreaOfControlSite site;
	local int numOfLocalGuardStacks;
	emptyArray.Length = 0;
	numOfLocalGuardStacks = 0;

	site = H7AreaOfControlSite( mDefendingArmy.GetGarrisonedSite() );
	if( site != none )
	{
		localGuard = site.GetLocalGuardAsBaseCreatureStacks();
		foreach localGuard( localStack )
		{
			numOfLocalGuardStacks += localStack.GetStackSize();
		}
	}
	// If we have no creatures, we can't fight
	if( !mCanFight )
	{
		;
		return false;
	}
	// If the defender has no creatures, it must get defeated immediately
	else if( mDefendingArmy.GetCreatureAmountTotal() == 0 && numOfLocalGuardStacks == 0 && !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		mAttackingArmyCombat = mAttackingArmy.CreateCombatArmyUsingAdventureArmy( mAttackingArmy, true );
		mDefendingArmyCombat = mDefendingArmy.CreateCombatArmyUsingAdventureArmy( mDefendingArmy, false );

		;
		mAttackingArmyCombat.GetHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
		mAttackingArmyCombat.GetHero().AddXp(mDefendingArmyCombat.GetExperienceForDefeating());
		
		mAttackingArmyCombat.SetWonBattle( true );
		mDefendingArmyCombat.SetWonBattle( false );

		mAttackingArmy.UpdateAfterCombat( mAttackingArmyCombat, mDefendingArmy.GetPlayerNumber(), true );
		mDefendingArmy.UpdateAfterCombat( mDefendingArmyCombat, mAttackingArmy.GetPlayerNumber(), true );

		class'H7AdventureController'.static.GetInstance().UpdateHUD();
		class'H7AdventureController'.static.GetInstance().AutoSelectArmy();
		mQuickCombatDone = false;
		
		mCombatPopUp.OnEndQuickCombatUpdate( emptyArray, emptyArray, true, mAttackingArmyCombat.GetHero(), mDefendingArmyCombat.GetHero(), mActivePlayerIsAttacker, mIsSiege );

		mAttackingArmyCombat.Destroy();
		mDefendingArmyCombat.Destroy();
		mAttackingArmyCombat = none;
		mDefendingArmyCombat = none;
		
		return false;
	}
	else
	{
		return true;
	}
}

function Closed()
{
	;
	BtnCancelClicked();
}

// CHECK this skips finalize calculation, so could be problem
function ClosePopupHard() // guaranteed to kill the popup and everything it represents
{
	;

	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && mUseSourceStacks)
	{
		// for the case the necromancy popup was closed because of another combat starting
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendAutoMergeRemainingPool(GetWinningArmy());
	}

	mDontCallBtnClose = true;
	if(mArmyMergePopup.IsVisible())
	{
		mArmyMergePopup.SetVisibleSave(false);
	}
	if(mNegoPopUpUsingMerger)
	{
		MergeCompleted();
	}
	mCombatPopup.Reset();
	mSiegeCombatPopUp.Reset();
	ClosePopup();
}

// a) ClosePopup - the start combat popup
// b) ClosePopup - the end combat popup - because you confirmed the end of the combat
function ClosePopup() // user click , user ESC key , with potential confirm question
{
	local bool mergeArmyContainsStacks;
	;
	
	//When the pop up is closed, the jingle fades out
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("STOP_COMBAT_JINGLE");

	//Delete the list of used consumeables, if the combat popup is closed
	mDefendingArmy.GetHero().GetInventory().DeleteUsedConsumables();
	mAttackingArmy.GetHero().GetInventory().DeleteUsedConsumables();

	// in case ESC was pressed we need to handle this standalone merger:
	if(mArmyMergePopup.IsVisible() || mNegoPopUpUsingMerger)
	{
		;
		// mDefendingArmy apparently can be 1) the surrendered army, or 2) the army that was attacked and won (me)
		// mSourceStacks seems to be 1) necro/res/prison stacks or 2) quest-stacks
		// (?) unclear how merging necro-stacks into defending army even works
		if(mUseSourceStacks || !mDefendingArmy.IsGarrisoned() ) // quest and necro/haven-ressurection/prison and negotiation
		{
			// only if the mDefendingArmy is the enemy, check if stacks are left
			if(mDefendingArmy.GetPlayerNumber() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
			{
				mergeArmyContainsStacks = mDefendingArmy.HasUnits(true);
		}
			mergeArmyContainsStacks = mergeArmyContainsStacks || ContainesUnits(mSourceStacks);
			MergerAccepted(mergeArmyContainsStacks);
		}
		else // teleport
		{
			MergeCompleted();
		}
		return;
	}

	if(!mIsAlreadyClosing && !mDontCallBtnClose)
	{
		;
		BtnCancelClicked();
		return;
	}

	;
	super.ClosePopup();
	
	//force close popups
	mCombatPopup.SetVisibleSave(false);
	mSiegeCombatPopUp.SetVisibleSave(false);
	mNegoPopup.SetVisibleSave(false);

	if(!mOnCombatMap) 
	{
		class'H7AdventureController'.static.GetInstance().UpdateHUD( , , false );
		if( !mAttackerWon )
		{
			class'H7AdventureController'.static.GetInstance().AutoSelectArmy( false );
		}
	}

	// this is the only and final way for the whole CombatPopup process to finish! (hopefully?) (but it's also start manual combat)

	if(mQuickCombatDoneWasTrue)
	{
		ExecuteConquer(); // single player quick combat conquer
	}
	else // we need to wait even longer to execute the conquer, because we have to complete DoBackFromAdventureToCombat First
	{
		// In fact there is already conquer code in DoBackFromAdventureToCombat so just let this handle it
	}

	Reset();
}

function Reset()
{
	// reset everything
	RemoveUnitFromCursor();
	mIsReinforcement = false;
	mCurrentPopup = none;
	mQuickCombatDone = false;
	mQuickCombatDoneWasTrue = false;
	mCreatureArmyCost.Length = 0;
	mSourceStacks.Length = 0;
	mAttackingArmy = none;
	mDefendingArmy = none;
	mMergeStandAlone = false;
	mPoolKey = "";
	mUseSourceStacks = false;
	mIsSiege = false;
	mCheckMOnCombatMap = true;
	mIsAlreadyClosing = false;
	mDontCallBtnClose = false;
	//mArmyMergePopup.UpdateCosts(0);
	mArmyMergePopup.Reset();
	mLocalGuardStacks.Length = 0;
	mConquerHero = none;
	mConquerSite = none;
}

//////////////Merger

function NegoPopUsingMerger()
{
	mNegoPopUpUsingMerger = true;
}

function StartPostCombatMerger(H7AdventureArmy army,array<H7BaseCreatureStack> joiners,String poolKey,optional delegate<OnReinforceComplete> callbackFunction)
{
	mCombatPopup.SetVisibleSave(false);
	mSiegeCombatPopup.SetVisibleSave(false);
	
	mMergeStandAlone = true;
	mUseSourceStacks = true;

	mAttackingArmy = army;
	mSourceStacks = joiners;
	
	mPoolKey = poolKey;
	
	if(callbackFunction != none)
	{
		OnReinforceComplete = callbackFunction;
	}

	mArmyMergePopup.SetArmyStacks(army,joiners,FlashLocalize(poolKey));
	
	mCurrentPopup = mArmyMergePopup;
	OpenPopup();
}

function StartQuestMerger(H7AdventureArmy army,array<H7BaseCreatureStack> joiners,optional delegate<OnReinforceComplete> callbackFunction)
{
	mMergeStandAlone = true;
	mUseSourceStacks = true;

	mAttackingArmy = army;
	mSourceStacks = joiners;
	
	if(callbackFunction != none)
	{
		OnReinforceComplete = callbackFunction;
	}

	mArmyMergePopup.SetArmyStacks(army,joiners,FlashLocalize("QUEST_ARMY_MERGE_TITLE"));
	mCurrentPopup = mArmyMergePopup;
	OpenPopup();
}

function StartCaravanMerger(H7EditorArmy heroArmy, H7EditorArmy caravanArmy, optional delegate<OnReinforceComplete> callbackFunction)
{
	mCaravanMerge = true;
	mAttackingArmy = H7AdventureArmy(heroArmy);
	mDefendingArmy = H7AdventureArmy(caravanArmy);

	mArmyMergePopup.SetArmyCaravanArmy(mAttackingArmy, mDefendingArmy,FlashLocalize("EXCHANGE_UNITS_WITH_CARAVAN"));
	mCurrentPopup = mArmyMergePopup;
	// TODO investigate why callbackFunction not used
	OpenPopup();
}

function StartReinforceMerger(H7AdventureArmy army,H7Town town,H7TeleportCosts costs,delegate<OnReinforceComplete> callbackFunction)
{
	mMergeStandAlone = true;

	mIsReinforcement = true;
	mMergeCost = costs;
	mAttackingArmy = army;
	mDefendingArmy = town.GetGarrisonArmy();

	mArmyMergePopup.SetArmyArmy(mDefendingArmy,mAttackingArmy
		,Repl(FlashLocalize("REINFORCE_TITLE"),"%town","<font color='#ffcc99'>" $ town.GetName() $ "</font>")
		,true,army.GetHero().GetCurrentMana(),costs);

	OnReinforceComplete = callbackFunction;

	mCurrentPopup = mArmyMergePopup;
	OpenPopup();
}

function bool UpdateMergeCost(optional bool payForReal)
{
	local array<H7StackCount> stackDiff;
	local array<H7BaseCreatureStack> baseStacksOrg,baseStacksNow;
	local H7StackCount stackCount;
	local ECreatureTier tier;
	local H7Player pl;
	local int cost;

	pl = mAttackingArmy.GetPlayer();
	baseStacksOrg = pl.GetOriginalReinforcementStacksTown();
	baseStacksNow = mDefendingArmy.GetBaseCreatureStacks();
	stackDiff = GetStackCountDiff(GetStackCount(baseStacksOrg),GetStackCount(baseStacksNow));
	
	// if we find added stacks, it's illegal, because you can not port to the garrison (we only look at garrison (mDefendingArmy))
	foreach stackDiff(stackCount)
	{
		if(stackCount.count > 0) // stackCount.count were added (can happen via swapping or bug)
		{
			;
			mArmyMergePopup.UpdateCosts(-1);
			return false;
		}
		else // stackCount.count were removed
		{
			// check type
			tier = stackCount.type.GetTier();
			switch(tier)
			{
				case CTIER_CHAMPION:cost += Abs(stackCount.count * mMergeCost.ChampionCreatureCosts);break;
				case CTIER_CORE:cost += Abs(stackCount.count * mMergeCost.CoreCreatureCosts);break;
				case CTIER_ELITE:cost += Abs(stackCount.count * mMergeCost.EliteCreatureCosts);break;
			}
		}
	}

	mArmyMergePopup.UpdateCosts(cost);

	if(payForReal)
	{
		if(mAttackingArmy.GetHero().GetCurrentMana() >= cost)
		{
			ConfirmTeleport(cost);
			return cost > 0;
		}
		else
		{
			ResetTeleport();
			return false;
		}
	}

	return false;
}

function HandleArmyMerging()
{
	local array<H7BaseCreatureStack> stacks;
	local H7MergePool pool;
	
	if(!HasArmyToMerge()) 
	{
		;
		return;
	}

	pool = GetWinningArmy().GetAMergePool();
	stacks = pool.PoolStacks;

	if(stacks.Length > 0)
	{
		StartPostCombatMerger(GetWinningArmy(),stacks,pool.PoolKey,PostCombatMergeComplete);
	}
}

function PostCombatMergeComplete(bool success)
{
	GetWinningArmy().DeleteMergePool(mPoolKey); // TODO MP instant command so it is deleted in all clients
	;
	
	if(HasArmyToMerge()) // checks if there are other pools left
	{
		HandleArmyMerging();
	}
	else
	{
		// cleanup all combat popups for next time
		mArmyMergePopup.SetVisibleSave(false);
		mCombatPopup.Reset();
		mSiegeCombatPopUp.Reset();
		
		// DO NOT CALL BtnCancelClicked because it resolves combat, which is not needed or was already done!!!
		mDontCallBtnClose = true;
		ClosePopup();
		
		if(!mOnCombatMap) return;

		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().SetCombatHudVisible(false);
		class'H7CameraActionController'.static.GetInstance().FadeToBlack(0.1f);
		class'H7CombatController'.static.GetInstance().SetTimer(0.15f, false, 'TravelBack');
	}
}

// returns for each H7Creature how many were added (positive count) and how many were removed (negative count) from old -> new
function array<H7StackCount> GetStackCountDiff(array<H7StackCount> oldState,array<H7StackCount> newState)
{
	local array<H7StackCount> diff;
	local H7StackCount stackCount1,stackCount2;
	local int i;
	local bool createNewEntry;

	diff = newState;
	foreach oldState(stackCount1)
	{
		createNewEntry = true;
		foreach diff(stackCount2,i)
		{
			if(stackCount2.type == stackCount1.type)
			{
				diff[i].count -= stackCount1.count;
				createNewEntry = false;
			}
		}
		if(createNewEntry) // was not in newState
		{
			stackCount2.type = stackCount1.type;
			stackCount2.count = -stackCount1.count; // was removed
			diff.AddItem(stackCount2);
		}
	}

	return diff;
}

function array<H7StackCount> GetStackCount(array<H7BaseCreatureStack> oldState)
{
	local H7BaseCreatureStack stack;
	local array<H7StackCount> stackCounts;
	local H7StackCount stackCount;
	local int i;
	local bool createNewEntry;

	stackCounts.Length = 0; // compiler supressor

	foreach oldState(stack)
	{
		createNewEntry = true;
		foreach stackCounts(stackCount,i)
		{
			if(stackCount.type == stack.GetStackType())
			{
				stackCounts[i].count += stack.GetStackSize();
				createNewEntry = false;
			}
		}
		if(createNewEntry)
		{
			stackCount.type = stack.GetStackType();
			stackCount.count = stack.GetStackSize();
			stackCounts.AddItem(stackCount);
		}
	}

	return stackCounts;
}

function DismissStack(int unitIndex,optional int armyIndex)
{
	;

	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;

	mDismissArmyIndex = armyIndex;
	mDismissIndex = unitIndex;

	GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("REALLY_DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("CANCEL","H7General"),DismissConfirm, DismissDenied);
}

function DismissConfirm()
{
	if(mDismissArmyIndex == mAttackingArmy.GetHero().GetID())
	{
		mAttackingArmy.RemoveCreatureStackByIndex(mDismissIndex);
		mLowerArmy.StackDismissed();
	}
	else if(mDismissArmyIndex == mDefendingArmy.GetHero().GetID())
	{
		mDefendingArmy.RemoveCreatureStackByIndex(mDismissIndex);
		mUpperArmy.StackDismissed();
	}
	else
	{
		;
	}
}

function DismissDenied()
{
	mDismissArmyIndex = -1;
	mDismissIndex = -1;
}

function AddUnitIconToCursor(int slotIndex, int armyID)
{	
	local array<H7BaseCreatureStack> stacks;
	;
	if(armyID == 0)
	{
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack(mSourceStacks[slotIndex]);
	}
	else if(mDefendingArmy != none && mDefendingArmy.GetHero().GetID() == armyID)
	{
		stacks = mDefendingArmy.GetBaseCreatureStacks();
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack(stacks[slotIndex]);
	}
	else
	{
		stacks = mAttackingArmy.GetBaseCreatureStacks();
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack(stacks[slotIndex]);
	}
	mIsDragginUnit = true;
}

function RequestTransfer( int dragSlotArmyID, int dragSlotIndex, int dropSlotArmyID, int dropSlotIndex, optional int amount)
{
	local H7InstantCommandTranferStackFromMergePool command;
	local H7AdventureArmy alternativeArmyToSplitTo;
	
	;
	// dropping to questreward/pool or dropping to garrison
	if(dropSlotArmyID == 0 || (mMergeStandAlone && mDefendingArmy != none && dropSlotArmyID == mDefendingArmy.GetHero().GetID() && mDefendingArmy.IsGarrisoned() && mIsReinforcement)) // dragging to questrewards or into garrison
	{
		;
		return; // nope
	}
	else if(dragSlotArmyID == 0) // from quest reward, necromancy stacks to my army
	{
		;
		command = new class'H7InstantCommandTranferStackFromMergePool';
		command.Init( mAttackingArmy, dragSlotIndex, dropSlotIndex );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
	}
	else // 2 real armies or garrison->army
	{
		// TODO prevent teleport+swapping
		if(dropSlotIndex == -1)
		{
			alternativeArmyToSplitTo = none; // no splitting to other armies in this window for now // dragSlotArmyID == mDefendingArmy.GetHero().GetID() ? mAttackingArmy : mDefendingArmy;
			class'H7EditorArmy'.static.SplitCreatureStackToEmptySlot( dragSlotArmyID == mDefendingArmy.GetHero().GetID() ? mDefendingArmy : mAttackingArmy, alternativeArmyToSplitTo, dragSlotIndex, amount);
		}
		else
		{
			class'H7EditorArmy'.static.TransferCreatureStacksByArmy( mDefendingArmy, dragSlotArmyID == mDefendingArmy.GetHero().GetID() ? mDefendingArmy : mAttackingArmy, dropSlotArmyID == mDefendingArmy.GetHero().GetID() ? mDefendingArmy : mAttackingArmy, dragSlotIndex, dropSlotIndex, amount);
		}
	}
}

// assumption:
// when 2 armies merge it goes to CompleteTransfer
// when stack-array merges with an army it goes to CompleteTransferForNonArmy
// - negotiation: CompleteTransfer
// - teleport: CompleteTransfer
// - quest: CompleteTransferForNonArmy
// - pools: CompleteTransferForNonArmy

function CompleteTransferForNonArmy(bool success, array<H7BaseCreatureStack> poolStacks)
{
	// can be:
	// quest merge
	// pool merge (necro,haven-necro,dim-prison)
	// NOT teleport merge
	if(success)
	{
		// send success to the rows
		mUpperArmy.TransferResult(success, false, -1);
		mLowerArmy.TransferResult(success, false, -1);

		// update data (this data exists 3 times, in pool, as mSourceStacks, as poolStacks
		mSourceStacks = poolStacks;

		// just to be sure overwrite it from scratch
		mUpperArmy.UpdateFromStacks(poolStacks);
		mLowerArmy.Update(mAttackingArmy); 
		// TODON probably have to refresh more stuff here
	}
	else
	{
		;
		// send non-success to the rows
		mUpperArmy.TransferResult(success, false, -1);
		mLowerArmy.TransferResult(success, false, -1);
	}
}

function CompleteTransfer(bool success)
{
	if(mMergeStandAlone && mIsReinforcement)
	{
		UpdateMergeCost();
	}

	if(success)
	{
		if(mUseSourceStacks)
		{
			mUpperArmy.UpdateFromStacks(mSourceStacks);
		}
		else if(mDefendingArmy != none) 
		{
			mUpperArmy.Update(mDefendingArmy,mIsReinforcement,mMergeCost);
		}

		mUpperArmy.TransferResult(success, false, -1);
		mLowerArmy.TransferResult(success, false, -1);

		mLowerArmy.Update(mAttackingArmy);

		mReceivedUnits = true; // TODO really? what if just splitted/moved in my army?
	}
}

function RemoveUnitFromCursor()
{
	mIsDragginUnit = false;
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
	GetHUD().UnLoadCursorObject();
}
/**
 *  unitsLeft determines if ther are still units in the upper army row
 */
function MergerAccepted(bool unitsLeft)
{
	local H7InstantCommandAcceptMerge command;

	if(mCaravanMerge)
	{
		command = new class'H7InstantCommandAcceptMerge';
		command.Init( mDefendingArmy );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
		
		mCaravanMerge = false;
		ClosePopupHard();
		return;
	}
	
	if(unitsLeft && !mIsReinforcement)
	{
		GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup("PU_ABANDON_MERGE", "YES", "NO", AcceptAbandon, none);
	}
	else
	{
		MergeCompleted();
	}
}

function AcceptAbandon()
{
	MergeCompleted();
}

function MergeCompleted()
{
	local bool didTransferAnything;

	didTransferAnything = false;
	if(mMergeStandAlone)
	{
		if(mIsReinforcement)
		{
			if( !mWasCanceled )
			{
				didTransferAnything = UpdateMergeCost(true); // pays to execute the teleporting
			}
			else
			{
				ResetTeleport(); // tell MP command thing we don't want units after all
				didTransferAnything = false; // popup was canceled, no transfer happened
			}
		}

		// CombatPopup is already closed (invisible?) at this point, 
		// but we neither close nor reset it, since there could be another merge pool triggered after this one
		//ClosePopup();
		//Reset();

		if(OnReinforceComplete != none)
		{
			OnReinforceComplete(didTransferAnything); // we trust that he will clean up
			OnReinforceComplete = none;
		}
		else
		{
			// if no call back, we better cleanup and close for savety
			ClosePopup();
		}
		mMergeStandAlone = false;
	}
	else
	{
		mNegoPopUpUsingMerger = false;
		NegoBtnAcceptClicked(true, false);
	}
}

function ConfirmTeleport(int manaCost)
{
	local H7InstantCommandConfirmReinforcement command;

	command = new class'H7InstantCommandConfirmReinforcement';
	command.Init(mAttackingArmy.GetHero(), manaCost);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

// button during reinforce teleport clicked
function ResetTeleport()
{
	local H7InstantCommandResetReinforcement command;

	command = new class'H7InstantCommandResetReinforcement';
	command.Init(mAttackingArmy, mDefendingArmy);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
}

function ResetTeleportComplete()
{
	mUpperArmy.Update(mDefendingArmy,mIsReinforcement,mMergeCost);
	mLowerArmy.Update(mAttackingArmy);
	UpdateMergeCost();
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Addon to delay conquering

function QueueConquer(H7AreaOfControlSite conquerSite,H7AdventureHero conquerHero)
{
	mConquerSite = conquerSite;
	mConquerHero = conquerHero;
}

function ExecuteConquer()
{
	if(mConquerSite != none && mConquerHero != none)
	{
		mConquerSite.Conquer(mConquerHero);
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////

