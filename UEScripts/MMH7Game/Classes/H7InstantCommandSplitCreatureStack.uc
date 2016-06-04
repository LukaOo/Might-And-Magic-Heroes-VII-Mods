//=============================================================================
// H7InstantCommandSplitCreatureStack
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSplitCreatureStack extends H7InstantCommandBase;

var private H7EditorArmy mSourceArmy;
var private H7EditorArmy mTargetArmy;
var private int mSourceIndex;
var private int mSplitCount;
var private int mTargetIndex;
var private H7EditorArmy mRequesterArmy;
var private bool mForceTransferToTargetArmy;
var private H7Player mPlayerRequester;

function Init( H7EditorArmy sourceArmy, H7EditorArmy targetArmy, int sourceIndex, int splitCount, int targetIndex, H7EditorArmy requesterArmy, optional bool forceTransferToTargetArmy = false )
{
	mSourceArmy = sourceArmy;
	mTargetArmy = targetArmy;
	mSourceIndex = sourceIndex;
	mSplitCount = splitCount;
	mTargetIndex = targetIndex;
	mRequesterArmy = requesterArmy;
	mForceTransferToTargetArmy = forceTransferToTargetArmy;

	// we need to get the localplayer because can happen that the request is done to an army that the local player doesnt own (merge window)
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		if( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().IsControlledByAI())
		{
			mPlayerRequester = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();
		}
		else
		{
			mPlayerRequester = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
		}
	}
	else
	{
		mPlayerRequester = class'H7CombatController'.static.GetInstance().GetLocalPlayer();
	}
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mSourceArmy = H7EditorHero(eventManageable).GetArmy();
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mTargetArmy = H7EditorHero(eventManageable).GetArmy();
	mSourceIndex = command.IntParameters[2];
	mSplitCount = command.IntParameters[3];
	mTargetIndex = command.IntParameters[4];
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[5] );
	mRequesterArmy = H7EditorHero(eventManageable).GetArmy();
	mForceTransferToTargetArmy = bool(command.IntParameters[6]);
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		mPlayerRequester = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[7]) );
	}
	else
	{
		mPlayerRequester = class'H7CombatController'.static.GetInstance().GetPlayerByNumber( EPlayerNumber(command.IntParameters[7]) );
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	
	command.Type = ICT_SPLIT_CREATURESTACK;
	command.IntParameters[0] = mSourceArmy.GetEditorHero().GetID();
	command.IntParameters[1] = mTargetArmy.GetEditorHero().GetID();
	command.IntParameters[2] = mSourceIndex;
	command.IntParameters[3] = mSplitCount;
	command.IntParameters[4] = mTargetIndex;
	command.IntParameters[5] = mRequesterArmy.GetEditorHero().GetID();
	command.IntParameters[6] = int(mForceTransferToTargetArmy);
	command.IntParameters[7] = mPlayerRequester.GetPlayerNumber();

	return command;
}

function Execute()
{
	local bool success;

	if( mTargetIndex >= 0 && mSplitCount == 0)
	{
		success = class'H7EditorArmy'.static.TransferCreatureStacksByArmyComplete( mSourceArmy, mTargetArmy, mSourceIndex, mTargetIndex, mSplitCount );
		SplitCreatureStackComplete(success, true);

		/*if( mSourceArmy.GetPlayer() != mTargetArmy.GetPlayer() )
		{
			// register the gift that recieved a hero of the localplayer
			if( mRequesterArmy != mTargetArmy && mTargetArmy.GetPlayer().IsControlledByLocalPlayer() )
			{
				//`log_gui( mTargetHero.GetName() @ "recieved" @ mTargetArmy.GetBaseCreatureStacks()[mTargetIndex].GetStackSize() @ mSourceArmy.GetBaseCreatureStacks()[mTargetIndex].GetStackType() @ "from" @ mSourceArmy.GetEditorHero().GetName() );
				class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTradeResultCntl().AddReceivedCreature(mTargetIndex, H7AdventureHero(mTargetArmy.GetEditorHero()), H7AdventureHero(mSourceArmy.GetEditorHero()));
			}
			// unregister the gift that recieved a hero of the localplayer
			else if( mRequesterArmy != mSourceArmy && mSourceArmy.GetPlayer().IsControlledByLocalPlayer() )
			{
				//`log_gui( mSourceHero.GetName() @ "lost" @ mTargetArmy.GetBaseCreatureStacks()[mTargetIndex].GetStackSize() @ mTargetArmy.GetBaseCreatureStacks()[mTargetIndex].GetStackType() @ "from" @ mTargetArmy.GetEditorHero().GetName() );
				class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTradeResultCntl().RemoveReceivedCreature(mTargetIndex, H7AdventureHero(mSourceArmy.GetEditorHero()), H7AdventureHero(mTargetArmy.GetEditorHero()));
			}
		}*/
	}
	else
	{
		success = class'H7EditorArmy'.static.SplitCreatureStackToEmptySlotComplete( mSourceArmy, mTargetArmy, mSourceIndex, mSplitCount, mTargetIndex, mForceTransferToTargetArmy );
		SplitCreatureStackComplete(success, false);
	}
}

private function SplitCreatureStackComplete( bool success, bool transfer )
{
	local int i;
	local H7AdventureHud hud;
	local H7CreatureStack spawnedStack;
	local array<H7CreatureStack> spawnedStacks;
	local array<H7BaseCreatureStack> baseStacks;

	if( mSourceArmy.IsA('H7CombatArmy') )
	{
		// Tactics mode
		// actual actor stacks on the map               
		// ~contains nones for empty slots in between~ NOT TRUE ANYMORE SINCE MULTIPLAYER REFACTOR
		// but gets readded none entries after the first split again!!! OPTIONAL refactor everything! but seems to work for now, somehow
		spawnedStacks = H7CombatArmy(mSourceArmy).GetCreatureStacks();  
		// object data from the army (deployment bar)   
		// contains nones for empty slots in between
		baseStacks = mSourceArmy.GetBaseCreatureStacks();

		;

		foreach spawnedStacks(spawnedStack)
		{
			spawnedStack.SetOrphan(true);
		}

		// syncronize spawnedStacks and baseStacks array
		for( i = 0; i < 12; i++ )
		{
			if( i < baseStacks.Length && baseStacks[i] != none )
			{
				if( baseStacks[i].GetSpawnedStackOnMap() != none) // correct actual actor stack on the map (but not neccesarily on grid and visible, can be undeployed)
				{
					spawnedStack = baseStacks[i].GetSpawnedStackOnMap();
					// correct index
					spawnedStacks[i] = spawnedStack;
					// correct size
					spawnedStack.SetStackSize(baseStacks[i].GetStackSize());
					// correct initial size
					spawnedStack.SetInitialStackSize(baseStacks[i].GetStackSize());
				}
				else // spawn new actual actor stack on the map
				{
					spawnedStacks[i] = H7CombatArmy(mSourceArmy).SpawnStack(baseStacks[i]);
					spawnedStacks[i].Hide(); // why hide? because it's an undeployed stack that was just created by splitting
					spawnedStacks[i].ApplyHeroArmyBonusBuff();
				}
				spawnedStacks[i].SetOrphan(false);
			}
			else // if there is no baseStack at i, there should not be a spawnedStack on i (see comment block at function start for confusion)
			{
				// cut reference, but don't delete stack, because could just have moved somewhere else
				spawnedStacks[i] = none;
			}
		}
		
		// clean up orphan actor stacks on map
		for(i=spawnedStacks.Length-1;i>=0;i--)
		{
			if(spawnedStacks[i] != none && spawnedStacks[i].IsOrphan()) 
			{
				spawnedStacks[i].RemoveStackFromGrid();
				spawnedStacks[i].DestroyCreatureStack();
				spawnedStacks[i] = none;
			}
		}

		// write back the 2 arrays into the army:
		H7CombatArmy(mSourceArmy).SetCreatureStacks(spawnedStacks);
		H7CombatArmy(mSourceArmy).SetBaseCreatureStacks(baseStacks);

		;
		for(i=0;i<14;i++)
		{
			if(i < baseStacks.Length)
			{
				if(baseStacks[i] != none) ;
				else ;
			} else ;
		}
		;
		for(i=0;i<14;i++)
		{
			if(i < spawnedStacks.Length)
			{
				if(spawnedStacks[i] != none) ;
				else ;
			} else ;
		}
		
		// (2) Deployment is deleted and recreated
		H7CombatArmy(mSourceArmy).OverrideDeploymentFromBaseStacks(false); // turns the new "BaseCreatureStacks" into a new "Deployment"
	}
	
	// notifies the active GUI about the completion of the creature split
	hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();

	if( hud == none )
	{
		if( class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetAdventureController() == none ) // direct combat: meh, just let it go...
		{
			class'H7CombatHudCntl'.static.GetInstance().CompleteTransfer(success, transfer);
			return;
		}
		else 
		{ 
			; 
		} // adventure controller but no hud? wtf!
	}

	if( !mSourceArmy.GetPlayer().IsControlledByLocalPlayer() && !mTargetArmy.GetPlayer().IsControlledByLocalPlayer() ) // both not mine, we don't care, we aren't caught up in your love affair
	{
		// except if I move stacks in the neutral army that is about to join me:
		if( hud.GetCombatPopUpCntl().GetPopup().IsVisible() && hud.GetCombatPopUpCntl().GetDefendingArmy() == mSourceArmy )
		{
			hud.GetCombatPopUpCntl().CompleteTransfer( success );
		}
		else
		{
			return;
		}
	}
	// normal cases where one of the armies is mine
	if(hud.GetHeroTradeWindowCntl().GetHeroTradeWindow().IsVisible())
	{
		hud.GetHeroTradeWindowCntl().CompleteTransfer(success);
	}
	else if(hud.GetHeroWindowCntl().GetHeroWindow().IsVisible())
	{
		hud.GetHeroWindowCntl().CompleteTransfer(success, mTargetIndex);
	}
	else if(hud.GetCombatPopUpCntl().GetPopup().IsVisible())
	{
		hud.GetCombatPopUpCntl().CompleteTransfer(success);
	}
	else if(hud.GetTownHudCntl().GetMiddleHUD().IsVisible())
	{
		hud.GetTownHudCntl().CompleteTransfer(success, mTargetIndex, H7AdventureArmy(mTargetArmy), transfer);
	}
	else if(hud.GetTrainingGroundsPopUpCntl().GetPopup().IsVisible())
	{
		hud.GetTrainingGroundsPopUpCntl().CompleteTransfer(success, mTargetIndex);
	}
	else if(class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().IsVisible())
	{
		class'H7CombatHudCntl'.static.GetInstance().CompleteTransfer(success, transfer);
	}
	if( mTargetArmy != none && !mTargetArmy.IsA('H7CombatArmy') )
	{
		mTargetArmy.OverrideDeploymentFromBaseStacks( true );
	}
	if( mSourceArmy != none && !mSourceArmy.IsA('H7CombatArmy') )
	{
		mSourceArmy.OverrideDeploymentFromBaseStacks( true );
	}
}

/**
 * Sim Turns:
 * Determines if this instant command waits for ongoing move/startCombat commands in the area of the command location
 */
function bool WaitForInterceptingCommands()
{
	return true;
}

/**
 * Sim Turns:
 * used to check for intersection with ongoing move commands
 */
function Vector GetInterceptLocation()
{
	local MPSimTurnOngoingStartCombat ongoingStartCombat;

	ongoingStartCombat = class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().GetOngoingStartCombat();

	// the merging window when bribing a neutral stack should not be blocked, we dont want to block a split action when is happening with a neutral stacks
	if( ongoingStartCombat.Target != none && ongoingStartCombat.Target.GetPlayer().IsNeutralPlayer() && ( mSourceArmy.GetEditorHero() == ongoingStartCombat.Target || 
		mTargetArmy.GetEditorHero() == ongoingStartCombat.Target || mSourceArmy.GetEditorHero() == ongoingStartCombat.Source || mTargetArmy.GetEditorHero() == ongoingStartCombat.Source ) )
	{
		return vect( -100000000, -100000000, -100000000 );
	}

	return mSourceArmy.GetEditorHero().GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mPlayerRequester;
}
