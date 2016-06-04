/*=============================================================================
* H7Garrison
* =============================================================================
* 
* =============================================================================
*  Copyright 2014 Limbic Entertainment All Rights Reserved.
*  
*  
*  
* =============================================================================*/

class H7Garrison extends H7AreaOfControlSite
	implements(H7ITooltipable,H7IStackContainer, H7IDestructible)
	dependson(H7ITooltipable)
	placeable
	native;

var protected savegame H7AdventureArmy mGarrisonArmy; // the garrison hero with the garrison units

var(Properties) protected string                                mCombatMapName<DisplayName="Combat map">;
// faction banner icon
var(Visuals)  dynload  protected Texture2D                      mFactionBannerIcon<DisplayName=Banner Icon>; // OPTIONAL move back to faction

var(Destruction) protected array<H7DestructibleObjectManipulator> mManipulators<DisplayName="Manipulators to destroy/repair the Teleporter">;

var(Developer) protected int mDestructionSteps<DisplayName="Amount of destruction steps needed to fully destroy the army inside">;

var(SiegeBuildings) dynload protectedwrite H7CombatMapTower					mSiegeObstacleTower<DisplayName="Siege obstacle Tower">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapWall					mSiegeObstacleWall<DisplayName="Siege obstacle Wall">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapMoat					mSiegeObstacleMoat<DisplayName="Siege obstacle Moat">;
var(SiegeBuildings) dynload protectedwrite H7CombatMapGate					mSiegeObstacleGate<DisplayName="Siege obstacle Gate">;
var(SiegeBuildings) protectedwrite array<H7EditorSiegeDecoration>	        mSiegeDecorationList<DisplayName="List of Siege Decorations">; //TODO: dynload

var protected savegame int mCurrentDestructionSteps;
var protected savegame bool mIsDestroying;

function array<H7EditorSiegeDecoration>  GetCombatMapDecoList()             { /*if( mSiegeDecorationList.Length == 0 )  self.DynLoadObjectProperty('mSiegeDecorationList');*/ return mSiegeDecorationList; } //TODO: dynload
function H7CombatMapTower GetCombatMapTower()
{
	if( mSiegeObstacleTower == none )
	{
		if(H7Garrison(self.ObjectArchetype).mSiegeObstacleTower == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleTower');
		}
		mSiegeObstacleTower = H7Garrison(self.ObjectArchetype).mSiegeObstacleTower;
	}
	return mSiegeObstacleTower;
}

function DelCombatMapTowerRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Garrison(self.ObjectArchetype).mSiegeObstacleTower = none;
	}
	mSiegeObstacleTower = none;
}

function H7CombatMapWall GetCombatMapWall()
{
	if( mSiegeObstacleWall == none ) 
	{
		if(H7Garrison(self.ObjectArchetype).mSiegeObstacleWall == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleWall');
		}
		mSiegeObstacleWall = H7Garrison(self.ObjectArchetype).mSiegeObstacleWall;
	}
	return mSiegeObstacleWall;
}

function DelCombatMapWallRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Garrison(self.ObjectArchetype).mSiegeObstacleWall = none;
	}
	mSiegeObstacleWall = none;
}

function H7CombatMapMoat GetCombatMapMoat()
{
	if( mSiegeObstacleMoat == none )
	{
		if(H7Garrison(self.ObjectArchetype).mSiegeObstacleMoat == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleMoat');
		}
		mSiegeObstacleMoat = H7Garrison(self.ObjectArchetype).mSiegeObstacleMoat;
	}
	return mSiegeObstacleMoat;
}

function DelCombatMapMoatRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Garrison(self.ObjectArchetype).mSiegeObstacleMoat = none;
	}
	mSiegeObstacleMoat = none;
}

function H7CombatMapGate GetCombatMapGate()
{
	if( mSiegeObstacleGate == none )
	{
		if(H7Garrison(self.ObjectArchetype).mSiegeObstacleGate == none)
		{
			self.ObjectArchetype.DynLoadObjectProperty('mSiegeObstacleGate');
		}
		mSiegeObstacleGate = H7Garrison(self.ObjectArchetype).mSiegeObstacleGate;
	}
	return mSiegeObstacleGate;
}

function DelCombatMapGateRef()
{
	if(!class'Engine'.static.IsEditor())
	{
		H7Garrison(self.ObjectArchetype).mSiegeObstacleMoat = none;
	}
	mSiegeObstacleMoat = none;
}

// from H7IDestructible
function DestroyDestructibleObject()  
{
	local array<H7BaseCreatureStack> stacks;   
	local H7BaseCreatureStack stack;
	local int newSize, changeAmount, i;


	if(mGarrisonArmy == none)
	{
		return;
	}

	stacks = mGarrisonArmy.GetBaseCreatureStacks();

	foreach stacks(stack,i)
	{
		if(stack != none)
		{
			changeAmount = Round((float(stack.GetStackSize())*float(mCurrentDestructionSteps)/float(mDestructionSteps)));

			newSize = stack.GetStackSize() + changeAmount;
			stack.SetStackSize(newSize);

			stack.SetStackSize(newSize);
		}
	}

	for( i = 0; i < mLocalGuard.Length; ++i )
	{
		if( mLocalGuard[i].Creature != none )
		{
			changeAmount = Round((float(mLocalGuard[i].Reserve)*float(mCurrentDestructionSteps)/float(mDestructionSteps)));
			mLocalGuard[i].Reserve += changeAmount;
			mLocalGuard[i].Capacity += changeAmount;
			mLocalGuard[i].Income = 0;
		}
	}

	mCurrentDestructionSteps++;

	foreach stacks(stack,i)
	{
		if(stack != none)
		{
			changeAmount = Round((float(stack.GetStackSize())*float(mCurrentDestructionSteps)/float(mDestructionSteps)));

			newSize = stack.GetStackSize() - changeAmount;


			if(newSize <= 0)
			{
				mGarrisonArmy.RemoveCreatureStackByIndex( i );
			}
			else
			{
				stack.SetStackSize(newSize);
			}
		}
	}

	for( i = 0; i < mLocalGuard.Length; ++i )
	{
		if( mLocalGuard[i].Creature != none )
		{
			changeAmount = Round((float(mLocalGuard[i].Reserve)*float(mCurrentDestructionSteps)/float(mDestructionSteps)));
			mLocalGuard[i].Reserve -= changeAmount;
			if(mLocalGuard[i].Reserve <= 0)
			{
				mLocalGuard[i].Creature = none;
				mLocalGuard[i].Capacity = 0;
			}
		}
	}

	if( mCurrentDestructionSteps == mDestructionSteps )
	{
		mCurrentDestructionSteps = 0;
	}
}

function RepairDestructibleObject()   {}

function bool                           IsDestroyed()				{ return !mGarrisonArmy.HasUnits(); }
function bool                           IsDestroying()				{ return mIsDestroying; }
function bool                           IsRepairing()				{ return false; }
function                                SetDestroying( bool v )     { mIsDestroying = v; }
function                                SetRepairing( bool v )      {}

function array<H7DestructibleObjectManipulator> GetManipulators()   {}
// from H7IDestructible end


function string				    GetCombatMapName()		                { return mCombatMapName; }
function H7Faction              GetFaction()                            { return GetPlayer().GetFaction(); }
event H7AdventureArmy           GetGarrisonArmy()                       { return mGarrisonArmy; }
function String                 GetFactionBannerIconPath()              { self.DynLoadObjectProperty('mFactionBannerIcon'); return "img://" $ Pathname( mFactionBannerIcon ); }
function                        DelFactionBannerIconRef()               { mFactionBannerIcon = none; }  
function                        SetGarrisonArmy( H7AdventureArmy army ) 
{ 
	mGarrisonArmy = army;

	if( mGarrisonArmy != none ) 
	{
		mGarrisonArmy.SetGarrisonedSite( self );
		mGarrisonArmy.HideArmy();
		mGarrisonArmy.SetCell( GetEntranceCell(), false, false, false );
		mGarrisonArmy.SetLocation( Location );
		GetEntranceCell().AddControllingArmy( mGarrisonArmy );
		mCurrentDestructionSteps = 0;
	}
}

function int GetCreatureAmountTotal()
{
	return mGarrisonArmy.GetCreatureAmountTotal();
}

function int GetCreatureAmount( H7Creature creature )
{
	return mGarrisonArmy.GetCreatureAmount(creature);
}

event InitAdventureObject()
{
	local H7DestructibleObjectManipulator manipulator;

	super.InitAdventureObject();

	class'H7AdventureController'.static.GetInstance().AddGarrison( self );

	if(!class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame())
	{
		SpawnGarrisonedArmy();	
	}

	foreach mManipulators( manipulator )
	{
		manipulator.AddDestructibleObjectByInterface( self );
	}
	
}

function OnVisit( out H7AdventureHero hero )
{
	super.OnVisit(hero);

	if( mGarrisonArmy == none )
	{
		CreateEmptyGarrison();
	}
	
	if( hero.GetPlayer() == GetPlayer() && hero.GetPlayer().GetPlayerType() != PLAYER_AI && hero.GetPlayer().GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() && !hero.GetPlayer().IsControlledByAI() )
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GoToGarrisonScreen(self);
	}
}

function OnRightClick() 
{
	
}

function OnDoubleClick()
{
	OpenTownScreenForMe();
}

function OpenTownScreenForMe()
{
	if(self.GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GoToGarrisonScreen( self );
	}
	else if( GetPlayer().IsPlayerHostile( class'H7AdventureController'.static.GetInstance().GetLocalPlayer() ) )
	{
		class'H7MessageSystem'.static.GetInstance().CreateFloat(FCT_ERROR, self.Location, class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), "MSG_GARRISON_ENEMY" );
	}
	else
	{
		class'H7MessageSystem'.static.GetInstance().CreateFloat(FCT_ERROR, self.Location, class'H7AdventureController'.static.GetInstance().GetLocalPlayer(), "MSG_GARRISON_ALLIED" );
	}
}

function CreateEmptyGarrison()
{
	if( mGarrisonArmy == none )
	{
		mGarrisonArmy = Spawn( class'H7AdventureArmy' );
		mGarrisonArmy.SetGarrisonedSite( self );
		mGarrisonArmy.Init( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( GetPlayerNumber() ),, Location );
		mGarrisonArmy.SetCell( GetEntranceCell(), false, false, true );
		mGarrisonArmy.SetLocation( Location );

		GetEntranceCell().AddControllingArmy( mGarrisonArmy );

		mGarrisonArmy.HideArmy();
	}
}

function private SpawnGarrisonedArmy()
{
	local H7AdventureController advenController;

	advenController = class'H7AdventureController'.static.GetInstance();
	
	// reject if building is neither a town or a fort OR A GARRISON >_>. all other building do not need an garrison army
	if( !Self.IsA('H7Town') && !Self.IsA('H7Fort') && !Self.IsA('H7Dwelling') && !Self.IsA('H7Garrison') ) return;

	if( mEditorArmy == none ) 
	{ 
		CreateEmptyGarrison();
	}
	else
	{
		if( class'H7GameUtility'.static.IsArchetype( mEditorArmy ) )
		{
			mGarrisonArmy = Spawn( class'H7AdventureArmy',,,,, mEditorArmy );
			mGarrisonArmy.Init( advenController.GetPlayerByNumber( mEditorArmy.GetPlayerNumber() ),, Location );
			mGarrisonArmy.HideArmy();
			mGarrisonArmy.SetPlayer( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ) );
		}
		else
		{
			SetGarrisonArmy( mEditorArmy );
		}
		mGarrisonArmy.SetGarrisonedSite( self );
		mGarrisonArmy.SetCell( GetEntranceCell(), false, false, true );
		mGarrisonArmy.SetLocation( Location );
		GetEntranceCell().AddControllingArmy( mGarrisonArmy );
	}
}

protected function HandleOwnership( H7AdventureHero visitingHero )
{
	local H7Player currentPlayer;
	local H7AdventureMapCell moveTargetCell;
	local array<float> pathCosts;
	local int numOfWalkableCells;

	super.HandleOwnership( visitingHero );

	currentPlayer = visitingHero.GetPlayer();
	if( mGarrisonArmy == none )
	{
		CreateEmptyGarrison();
	}

	// Capture the Vassal only if its Lord is neutral or owned by the capturing player and the Vassal is unguarded
	;

	// Check if the AoC Lord has a garrisoned army and if it's a different player
	if( !mGarrisonArmy.HasUnits( false ) && GetPlayer().IsPlayerHostile( currentPlayer ) )
	{
		// If the Lord is unguarded and from a different player, capture it
		SetSiteOwner( currentPlayer.GetPlayerNumber() );

		// update path preview if there is one (in case the dots past the conquered garrison should switch from red to green)
		moveTargetCell = visitingHero.GetLastCellMovement();
		if(moveTargetCell != none && !visitingHero.IsControlledByAI())
		{
			pathCosts = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( visitingHero.GetCurrentPath(), moveTargetCell, visitingHero.GetCurrentMovementPoints(), numOfWalkableCells );
			class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().ShowPreview( visitingHero.GetCurrentPath(), numOfWalkableCells, visitingHero.GetCurrentMovementPoints(), visitingHero.GetMovementPoints(), pathCosts );	
		}

		mGarrisonArmy.SetPlayer( currentPlayer );
	}

}

function Conquer( H7AdventureHero conqueror )
{
	// After lost combat current mGarrisionArmy is Dead/Unregistered etc. -> Wipe it and create new
	class'H7AdventureController'.static.GetInstance().RemoveArmy(mGarrisonArmy);
	CreateEmptyGarrison();
	super.Conquer( conqueror );
	ClearLocalGuardReserve();
}

function SetSiteOwner( EPlayerNumber newOwner, optional bool showPopup = true ) 
{
	local H7Player newPlayer;

	if(mSiteOwner == newOwner)
	{
		return; // Already owned
	}

	newPlayer = class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( newOwner );

	if( mGarrisonArmy != none )
	{
		if(mGarrisonArmy.GetHero() != none ) 
		{
			if( mGarrisonArmy.GetHero().IsHero() )
			{
				mGarrisonArmy.SetIsDead( true );
				class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().AddDefeatedHero( mGarrisonArmy );
				SetGarrisonArmy( none );
				CreateEmptyGarrison();
			}
			mGarrisonArmy.SetPlayer( newPlayer );
		}
		else 
		{
			mGarrisonArmy.SetPlayer( newPlayer );
		}
	}

	super.SetSiteOwner(newOwner, showPopup);
}

function TransferHero( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	local H7InstantCommandTransferHero command;

	command = new class'H7InstantCommandTransferHero';
	command.Init( self, fromArmy, toArmy );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );	
}

function bool TransferHeroComplete( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	local H7AdventureArmy tmpArmy;
	local array<H7AdventureArmy> armies;
	local H7BaseCreatureStack stack, garrisonStack;
	local array<H7BaseCreatureStack> stacks, garrisonStacks;
	local bool mergedStack;
	local bool visitArmyWasReal;
	local int i, j;
	
	;

	if(fromArmy == ARMY_NUMBER_GARRISON && toArmy == ARMY_NUMBER_VISIT)
	{
		if( !mGarrisonArmy.GetHero().IsHero() )
		{
			;
			return false;
		}

		if( mVisitingArmy != none && mVisitingArmy.GetPlayer() != GetPlayer() || GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayer() != GetPlayer() )
		{
			;
			return false;
		}

		// Take the entire army if there is no visiting army
		if( mVisitingArmy == none)
		{
			;
			;
			// set the visiting army to be the garrisoned army now, since visiting army is empty
			SetVisitingArmy( mGarrisonArmy );
			// reset the reference to the garrison army
			SetGarrisonArmy( none );
			// the garrison army must always exist, so create a new empty one (with a dummy hero)
			
			// show the garrisoned army outside the town now
			mVisitingArmy.SetGarrisonedSite( none );
			mVisitingArmy.ShowArmy();
			mVisitingArmy.SetCell( GetEntranceCell() );
			mVisitingArmy.SetLocation(mVisitingArmy.GetHero().Location);
			mVisitingArmy.SetHardAttach(true);
			mVisitingArmy.SetBase(mVisitingArmy.GetHero());
			CreateEmptyGarrison();
			// register it as an army in the adventure controller
			armies = class'H7AdventureController'.static.GetInstance().GetArmies();
			if( armies.Find( mVisitingArmy ) == INDEX_NONE )
			{
				class'H7AdventureController'.static.GetInstance().AddArmy( mVisitingArmy );
			}
			if( armies.Find( mGarrisonArmy ) != INDEX_NONE )
			{
				class'H7AdventureController'.static.GetInstance().RemoveArmy( mGarrisonArmy );
			}
			;
				
		}
		else if( mGarrisonArmy.GetHero().IsHero() && mVisitingArmy.GetHero().IsHero() )
		{
			// if both armies exist, swap them
			//tmpArmy = mVisitingArmy;
			//mVisitingArmy = mGarrisonArmy;
			//mGarrisonArmy = tmpArmy;
			
			visitArmyWasReal = mVisitingArmy != none;

			; // swapping was reversed here, because compiler fail #coderswag #hack
			tmpArmy = mGarrisonArmy;
			mGarrisonArmy.SetCell(none);
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( tmpArmy );

			mVisitingArmy.SetGarrisonedSite( none );
			mVisitingArmy.SetCell( GetEntranceCell() );
			mVisitingArmy.ShowArmy();
			mVisitingArmy.SetLocation(mVisitingArmy.GetHero().Location);
			mVisitingArmy.SetHardAttach(true);
			mVisitingArmy.SetBase(mVisitingArmy.GetHero());

			mGarrisonArmy.SetGarrisonedSite( self );
			mGarrisonArmy.SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ) );
			mGarrisonArmy.HideArmy();
			;
			
			if(mGarrisonArmy == none)
			{
				;
				;
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("mGarrisonArmy was lost UnrealScript Compiler Fail",MD_QA_LOG);;
				;
			}
			if(mVisitingArmy == none && visitArmyWasReal)
			{
				;
				;
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("mVisitingArmy was lost UnrealScript Compiler Fail",MD_QA_LOG);;
				;
			}
			;
			;

		}
		if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == none)
		{
			class'H7AdventureController'.static.GetInstance().SelectArmy(mVisitingArmy);
		}
		return true;
	}
	else if( fromArmy == ARMY_NUMBER_VISIT && toArmy == ARMY_NUMBER_GARRISON )
	{
		if( mGarrisonArmy == none)
		{
			;
			CreateEmptyGarrison();
			return false;
		}

		if( mVisitingArmy != none && mVisitingArmy.GetPlayer() != GetPlayer() || GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayer() != GetPlayer() )
		{
			;
			return false;
		}

		if( mGarrisonArmy.GetHero().IsHero() )
		{
			// if both armies exist, swap them
			tmpArmy = mGarrisonArmy;
			mGarrisonArmy.SetCell(none);
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( tmpArmy );
			
			mVisitingArmy.SetGarrisonedSite( none );
			mVisitingArmy.ShowArmy();
			mVisitingArmy.SetCell( GetEntranceCell() );
			mVisitingArmy.SetLocation(mVisitingArmy.GetHero().Location);
			mVisitingArmy.SetHardAttach(true);
			mVisitingArmy.SetBase(mVisitingArmy.GetHero());

			mGarrisonArmy.SetGarrisonedSite( self );
			mGarrisonArmy.HideArmy();
			mGarrisonArmy.SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ) );

			if(mVisitingArmy!=None)
			{
				if(mVisitingArmy.GetPlayer().IsControlledByAI()==false)
				{
					class'H7AdventureController'.static.GetInstance().SelectArmy(mVisitingArmy, true);
				}
			}
			;
		}
		else if( !mGarrisonArmy.HasUnits( true ) && !mGarrisonArmy.GetHero().IsHero() )
		{
			;
			// if the garrisoned army is without units and without a hero, then set the visiting army to the garrisoned army
			tmpArmy = mGarrisonArmy;
			tmpArmy.SetGarrisonedSite( none );
			SetGarrisonArmy( mVisitingArmy );
			class'H7AdventureController'.static.GetInstance().RemoveArmy( tmpArmy );
			SetVisitingArmy( none );
			if(mGarrisonArmy.GetPlayer().IsControlledByLocalPlayer() || mGarrisonArmy.GetPlayer().IsControlledByAI())
			{
				class'H7AdventureController'.static.GetInstance().AutoSelectArmy();
			}
		}
		else if( !mGarrisonArmy.GetHero().IsHero() && GetUniqueStackTypeCount(mGarrisonArmy, mVisitingArmy) <= 7 )
		{
			// if there is no garrison hero, then merge armies!
			// get all the visiting army stacks
			stacks = mVisitingArmy.GetBaseCreatureStacks();
			// add them to the garrisoned army

			foreach stacks( stack )
			{
				garrisonStacks = mGarrisonArmy.GetBaseCreatureStacks();
				mergedStack = false;
				foreach garrisonStacks( garrisonStack )
				{
					if( garrisonStack.GetStackType() == stack.GetStackType() )
					{
						garrisonStack.SetStackSize( garrisonStack.GetStackSize() + stack.GetStackSize() );
						mergedStack = true;
						break;
					}
				}
				if( !mergedStack )
				{
					mGarrisonArmy.PutCreatureStackToEmptySlot( stack );
				}
			}

			// to preserve stack positioning in the army slots, set the visiting army's stacks to be those of the garrisoned army's, and then transfer the entire visiting army over as the garrisoned army

			mVisitingArmy.SetBaseCreatureStacks( mGarrisonArmy.GetBaseCreatureStacks() );
			class'H7AdventureController'.static.GetInstance().RemoveArmy( mGarrisonArmy );
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( none );
			if(mGarrisonArmy.GetPlayer().IsControlledByLocalPlayer() || mGarrisonArmy.GetPlayer().IsControlledByAI())
			{
				class'H7AdventureController'.static.GetInstance().AutoSelectArmy();
			}
			;
		}
		else if( !mGarrisonArmy.GetHero().IsHero() && GetUniqueStackTypeCount(mGarrisonArmy, mVisitingArmy) > 7 && mVisitingArmy.GetHero().GetIsScripted() )
		{
			// SCRIPTED EXCEPTION

			// get all the visiting army stacks
			stacks = mVisitingArmy.GetBaseCreatureStacksDereferenced();
			// add them to the garrisoned army
			garrisonStacks = mGarrisonArmy.GetBaseCreatureStacksDereferenced();
			foreach stacks( stack )
			{
				garrisonStacks.AddItem( stack );
			}

			for( i = 0; i < garrisonStacks.Length; ++i )
			{
				for( j = 0; j < garrisonStacks.Length; ++j )
				{
					if( i != j && garrisonStacks[i].GetStackType() == garrisonStacks[j].GetStackType() )
					{
						garrisonStacks[i].SetStackSize( garrisonStacks[i].GetStackSize() + garrisonStacks[j].GetStackSize() );
						garrisonStacks[j].SetStackSize( 0 );
					}
				}
			}

			for( i = garrisonStacks.Length - 1; i >= 0; --i )
			{
				if( garrisonStacks[i].GetStackSize() == 0 )
				{
					garrisonStacks.Remove( i, 1 );
				}
			}

			garrisonStacks.Sort( SortStackPoolMerge );

			if( garrisonStacks.Length > 7 )
			{
				garrisonStacks.Length = 7;
			}

			mVisitingArmy.SetBaseCreatureStacks( garrisonStacks );
			class'H7AdventureController'.static.GetInstance().RemoveArmy( mGarrisonArmy );
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( none );
		}
		else
		{
			// something probably went wrong.
			;
			return false;
		}

		return true;
	}
	else
	{
		;
		return false;
	}
}

function static int GetUniqueStackTypeCount(H7AdventureArmy army1, H7AdventureArmy army2)
{
	local H7BaseCreatureStack stack;
	local array<H7BaseCreatureStack>stacks;
	local array<H7Creature> uniqueCreatures;

	stacks = army1.GetBaseCreatureStacks();
	foreach stacks(stack)
	{
		if(uniqueCreatures.Find(stack.GetStackType()) == -1) uniqueCreatures.AddItem(stack.GetStackType());
	}

	stacks = army2.GetBaseCreatureStacks();
	foreach stacks(stack)
	{
		if(uniqueCreatures.Find(stack.GetStackType()) == -1) uniqueCreatures.AddItem(stack.GetStackType());
	}
	return uniqueCreatures.Length;
}

function int SortStackPoolMerge( H7BaseCreatureStack a, H7BaseCreatureStack b )
{
	return a.GetCreatureStackStrength() - b.GetCreatureStackStrength();
}


function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	
	data.type = TT_TYPE_TOWN;

	data.Title =  GetName();

	if(!extendedVersion)
	{
		//data.Description = "<font size='#TT_SUBTITLE#'>" $ class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(GetPlayerNumber()).GetName()@"</font>";
		data.addRightMouseIcon = true;
		
	}
	
	return data;
}

