//=============================================================================
// H7CombatArmy
//=============================================================================
//
// Army used in the combat map
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatArmy extends H7EditorArmy
	dependsOn(H7Deployment)
	native;

var protected H7CombatHero mHero;
var protected H7AdventureHero mAdvHero;
var protected array<H7CreatureStack> mCreatureStacks;
var protected array<H7WarUnit> mWarUnits;

// false = defender, true = attacker
var protected bool mIsAttacker;
var protected bool mIsForQuickCombat;

var protected array<H7Faction> mFactionsInArmy;

var protected bool mWonBattle;

var protected array<H7TowerUnit> mTowers;

var const array<IntPoint> AmbushDeployRelativeCellOffset_1x1;

var protected int mInitialTotalLife;

struct native SClockwiseCircleDetectionPoint
{
	var IntPoint coord;
	var float distanceSq;//squared distance
	var Vector2D relativeCoordToCenter;
};
struct native SAmbushDeploymentCircle
{
	var array<IntPoint> points;
};

// Get / Set
// =======
function int                            GetInitialTotalLife()														{ return mInitialTotalLife; }
function                                SetIsAttacker( bool isAttacker )                                            { mIsAttacker = isAttacker; }
function bool                           IsAttacker()                                                                { return mIsAttacker; }
function                                SetIsForQuickCombat( bool val )                                             { mIsForQuickCombat = val; }
function bool                           IsForQuickCombat()                                                          { return mIsForQuickCombat; }
function H7CombatHero                   GetCombatHero()                                                             { return mHero; }
function H7CombatHero                   GetHero()                                                                   { return mHero; }
function                                SetHero( H7CombatHero value )                                               { mHero = value; } 
function H7AdventureHero                GetAdventureHero()                                                          { return mAdvHero; }
function                                SetAdventureHero( H7AdventureHero value )                                   { mAdvHero = value; } 
function array<H7WarUnit>               GetWarUnits()                                                               { return mWarUnits; }
function bool                           WonBattle()                                                                 { return mWonBattle; } // true -> this army won the battle in the combat map, false -> this army lost the battle in the combat map
function                                SetWonBattle( bool value )                                                  { mWonBattle = value; }
function                                AddTower( H7TowerUnit tower )												{ mTowers.AddItem( tower ); }
function array<H7TowerUnit>				GetTowers()																	{ return mTowers; }
function int                            GetFactionsInArmyCount(bool checkForDeployed = false)                                                    
{ 
	local H7BaseCreatureStack stack;
	mFactionsInArmy.Length = 0;
	foreach mBaseCreatureStacks( stack )
	{
		if( stack != none && stack.GetStackType() != none &&
			stack.GetStackType().GetFaction() != class'H7GameData'.static.GetInstance().GetNeutralFaction() &&
			mFactionsInArmy.Find( stack.GetStackType().GetFaction() ) == INDEX_NONE )
		{
			if( ( !checkForDeployed || stack.IsDeployed() ) && stack.GetSpawnedStackOnMap() != none && !stack.GetSpawnedStackOnMap().IsDead() )
			{
				mFactionsInArmy.AddItem( stack.GetStackType().GetFaction() );
			}
		}
	}
	return mFactionsInArmy.Length;
}

// Welcome to mCreatureStacks, one of 4 arrays for creature stacks
// 1) mCreatureStackProperties
// 2) mBaseCreatureStacks
// 3) deployment-array
// 4) mCreatureStacks
// mCreatureStacks is for the actually spawned and instanciated stacks with models&effects on the combat map 
// -also invisible (undeployed) stacks are in this array
// -initially it contains none-entries, but is then cleaned up, to remove all none entries (or never had none entries, not sure atm)
// --and then it gets none entries again if you split something (see: SplitCreatureStackComplete)
// --but at the end of combat none entries are gone again (not sure how atm)
// -it is matched with mBaseCreatureStacks, by H7BaseCreatureStack having a reference (H7BaseCreatureStack.mSpawnedStackOnMap) to their spawned version in mCreatureStacks
function array<H7CreatureStack>         GetCreatureStacks()                                                         { return mCreatureStacks; }
function int                            GetCreatureStackIndex(H7CreatureStack stack)                                { return mCreatureStacks.Find(stack); }
function                                AddCreatureStackOnMap( H7CreatureStack stack )                              { mCreatureStacks.AddItem( stack ); }
function                                SetCreatureStacks(array<H7CreatureStack> stacks)                            { mCreatureStacks = stacks; }
function array<H7CreatureStack> GetDeployedCreatureStacks()
{
	local array<H7CreatureStack> deployedCreatureStacks;
	local H7BaseCreatureStack baseStack;
	local int i;

	for(i=0;i<mCreatureStacks.Length;i++)
	{
		baseStack = GetBaseStackBySpawnedStack(mCreatureStacks[i]);
		if(baseStack.IsDeployed()) deployedCreatureStacks.AddItem(mCreatureStacks[i]);
	}
	return deployedCreatureStacks;
}
// in this function we no longer trust that mCreatureStacks and mBaseCreatureStacks are index synchron (they used to be, but whatever)
function H7CreatureStack GetStackBySourceSlotId(int baseStackindex) 
{
	// but we hope at least flash_index = mBaseCreatureStacks_index
	return mBaseCreatureStacks[baseStackindex].mSpawnedStackOnMap; // use the link from mBaseCreatureStacks to spawned creaturestack
}
function H7BaseCreatureStack GetBaseStackBySpawnedStack(H7CreatureStack spawnedStack)
{
	// atm we can't rely on any data structure and index and reference linking, so just brute force search it // OPTIONAL understand and refactor the entire system
	local int i;
	for(i=0;i<mBaseCreatureStacks.Length;i++)
	{
		if(mBaseCreatureStacks[i] != none && mBaseCreatureStacks[i].mSpawnedStackOnMap == spawnedStack)
		{
			return mBaseCreatureStacks[i];
		}
	}
	;
}



function H7EditorHero GetEditorHero() { return mHero; }

// methods
// =======

// returns true if the player owns this army, only for multiplayer
function bool IsOwnedByPlayerMP()
{
	local H7PlayerReplicationInfo playerRepInfo;

	// only allow input to the right player in multiplayer
	if( WorldInfo.GRI.IsMultiplayerGame() )
	{
		playerRepInfo = H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo );
		if( ( IsAttacker() && playerRepInfo.GetCombatPlayerType() == COMBATPT_ATTACKER ) || ( !IsAttacker() && playerRepInfo.GetCombatPlayerType() == COMBATPT_DEFENDER ) )
		{
			return true;
		}
	}
	return false;
}

// updates the faction counter array
function UpdatedAlliesAndEnemies()
{
	local H7CreatureStack currentStack;

	if(class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetAdventureController() == none) return;

	//all units
	foreach mCreatureStacks( currentStack )
	{
		if( !currentStack.IsDead() && mFactionsInArmy.Find( currentStack.GetFaction() ) == -1 && currentStack.GetFaction() != class'H7GameData'.static.GetInstance().GetNeutralFaction())
		{
			mFactionsInArmy.AddItem( currentStack.GetFaction() );
		}
	}
	
	//hero
	if( mFactionsInArmy.Find( mHero.GetFaction() ) == -1 && mHero.GetFaction() != class'H7GameData'.static.GetInstance().GetNeutralFaction() )
	{
		mFactionsInArmy.AddItem( mHero.GetFaction() );
	}
}

function bool AreAllCreaturesDead()
{
	local H7CreatureStack singleStack;	
	
	foreach mCreatureStacks ( singleStack )
	{
		if( singleStack.GetBaseCreatureStack().IsDeployed() 
			&& ( ( singleStack.GetGridPosition().X != -1 
			&& singleStack.GetGridPosition().Y != -1 
			&& singleStack.IsVisible() ) || singleStack.IsOffGrid() ) ) // off grid creatures are: not dead, invisible, and at position -1,-1
		{
			if ( !singleStack.IsDead() )
			{
				return false;
			}
		}
	}

	return true;
}

function DoVictory()
{
	local H7CreatureStack singleStack;	
	
	SetWonBattle( true );

	foreach mCreatureStacks ( singleStack )
	{
		if ( !singleStack.IsDead() )
		{
			singleStack.PlayRandomlyDelayedVictoryAnim();
		}
	}

	mHero.GetAnimControl().PlayAnim( HA_VICTORY );
}

// returns 50% of the current army costs (gold only)
function int GetSurrenderPrice()
{
	local array<H7CreatureStack> survivingStacks;
	local H7CreatureStack creatureStack;
	local int overallCosts;
	local int tmpCosts;
	local H7Resource currency;
	local array<H7ResourceQuantity> costs;
	local H7ResourceQuantity currentCosts;
	
	// get currency aka gold resource from player
	currency = GetPlayer().GetResourceSet().GetCurrencyResourceType();

	GetSurvivingCreatureStacks( survivingStacks );

	overallCosts = 0;

	foreach survivingStacks( creatureStack )
	{
		costs = creatureStack.GetCreature().GetUnitCost();
		foreach costs(currentCosts)
		{
			if(currentCosts.Type == currency)
			{
				tmpCosts = ( ( currentCosts.Quantity * creatureStack.GetStackSize() ) / 2);
				overallCosts += tmpCosts;
			}
		}
	}

	overallCosts = overallCosts * GetHero().GetSurrenderCostModifier();

	return overallCosts;
}


function GetSurvivingCreatureStacks(out array<H7CreatureStack> livingStacks )
{
	local H7CreatureStack singleStack;	
	
	livingStacks.Remove( 0, livingStacks.Length ); // clear array

	foreach mCreatureStacks ( singleStack )
	{
		if ( !singleStack.IsDead() && singleStack.GetBaseCreatureStack().IsDeployed()==true )
		{
			livingStacks.AddItem(singleStack);
		}
	}
}

function GetKilledCreatureStacks(out array<H7CreatureStack> killedStacks )
{
	local H7CreatureStack singleStack;	
	
	killedStacks.Remove( 0, killedStacks.Length ); // clear array

	foreach mCreatureStacks ( singleStack )
	{
		if ( singleStack.IsDead() )
		{
			killedStacks.AddItem(singleStack);
		}
	} 
}

function int GetKilledCreaturesXP()
{
	local array<H7CreatureStack> killedStacks, livingStacks; 
	local H7CreatureStack stack;
	local int xpGain, size; 

	GetKilledCreatureStacks( killedStacks );
	GetSurvivingCreatureStacks( livingStacks );

	// count xp for killed stacks
	foreach killedStacks(stack)
	{
		size = stack.GetInitialStackSize();
		if( stack != none )
		{
			xpGain += size * stack.GetCreature().GetExperiencePoints();
		}
	}

	// count xp for killed creatures
	foreach livingStacks(stack)
	{
		size = stack.CountDeadCreatures();
		xpGain += size * stack.GetCreature().GetExperiencePoints();
		;
	}
	;
	return xpGain;
}

function KillRemainingStacks() 
{
	local H7CreatureStack singleStack;	
	
	foreach mCreatureStacks ( singleStack )
	{
		if ( !singleStack.IsDead() )
		{
			singleStack.Kill();
		}
	}
}

function HideStacks() 
{
	local H7CreatureStack singleStack;	
	
	foreach mCreatureStacks ( singleStack )
	{
		if ( !singleStack.IsDead() )
		{
			singleStack.Hide();
		}
	}
}

function ShowStacks(optional bool updateHealthAfterCombatStart = false) 
{
	local H7CreatureStack singleStack;	
	
	foreach mCreatureStacks ( singleStack )
	{
		if ( !singleStack.IsDead() && singleStack.GetBaseCreatureStack().IsDeployed() )
		{
			singleStack.Show();
		}
	}

	if(updateHealthAfterCombatStart)
	{
		UpdateHealthpoints();
	}
}

// event - when unit action is finished, next unit is now active
function TurnChanged() 
{
	local H7CreatureStack singleStack;	
	
	foreach mCreatureStacks ( singleStack )
	{
		if ( !singleStack.IsDead() )
		{
			singleStack.TurnChanged();
		}
	}
}

// event - when clicking the mouse, ordering an action
function bool RefreshAllUnits()
{
	local H7CreatureStack singleStack;	
	local H7WarUnit warUnit;
	local H7Unit unit;
	local bool hasAliveUnits;
	
	hasAliveUnits = false;
	foreach mCreatureStacks ( singleStack )
	{
		singleStack.StatusChanged();
		//singleStack.GetPathfinder().ForceUpdate();
		singleStack.SetIsBeingTeleported( false );
		hasAliveUnits = hasAliveUnits || !singleStack.IsDead();
	}
	unit = class'H7CombatController'.static.GetInstance().GetActiveUnit(); 
	singleStack = H7CreatureStack( unit );
	if( singleStack != none && mCreatureStacks.Find( singleStack ) != INDEX_NONE )
	{
		singleStack.GetPathfinder().ForceUpdate();
	}
	foreach mWarUnits( warUnit )
	{
		warUnit.StatusChanged();
	}

	return hasAliveUnits;
}

function TeleportSpellWasCanceled()
{
	local H7CreatureStack singleStack;

	foreach mCreatureStacks ( singleStack )
	{
		singleStack.StatusChanged();
		singleStack.GetPathfinder().ForceUpdate();
		singleStack.SetIsBeingTeleported( false );
	}
}

function CleanAllUnitsAbilitiesAfterCombat()
{
	local H7CreatureStack singleStack;	
	local H7WarUnit warUnit;
	
	foreach mCreatureStacks ( singleStack )
	{
		singleStack.GetAbilityManager().CleanAbilitiesAfterCombat();
		singleStack.GetBuffManager().CleanBuffsAfterCombat();
	}
	foreach mWarUnits( warUnit )
	{
		warUnit.GetAbilityManager().CleanAbilitiesAfterCombat();
		warUnit.GetBuffManager().CleanBuffsAfterCombat();
	}

	mHero.GetAbilityManager().CleanAbilitiesAfterCombat();  // clean abilities...
	mHero.GetInventory().CleanItemsAfterCombat();
	mHero.GetEquipment().CleanItemsAfterCombat();
	mHero.GetBuffManager().CleanBuffsAfterCombat();         // ...and buffs...
	mHero.GetSkillManager().CleanSkillsAfterCombat();       // ...and skills...
	mHero.GetEffectManager().ResetFX();                     // ...and remove stray VFX
}

function DestroyStackGhosts()
{
	local H7CreatureStack singleStack;	
	foreach mCreatureStacks ( singleStack )
	{
		singleStack.DestroyGhost();
	}
}

// places the hero and the creatures stacks into the grid. It returns true if setup is done, false if hero has the Tactics abilits 
// and can rearrange the creature stacks
function bool AutoplaceUnits()
{
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	PlaceHero();

	RemoveStacks(mBaseCreatureStacks);
	CreateStacks(mBaseCreatureStacks);

	PlaceWarUnits();
	
	UpdateHealthpoints();

	// no hero, no hero army bonus buff!
	if( GetHero() != none && GetHero().IsHero() )
	{
		InitStacksHeroEffects();
	}
	
	if( !GetDeployment().IsCustomized() )
	{
		AutodeployCreatures();
	}
	else
	{
		DeployCreatures();
	}
	
	return true;
}

function bool AutoplaceUnitsAmbush()
{
	PlaceHero();

	CreateStacks( mBaseCreatureStacks );

	PlaceWarUnits();
	
	UpdateHealthpoints();

	// no hero, no hero army bonus buff!
	if( GetHero() != none && GetHero().IsHero() )
	{
		InitStacksHeroEffects();
	}
	
	if (!self.IsAttacker())//the defender can ambush
		PlaceCreaturesAmbush();
	else
		PlaceCreaturesBeingAmbushed();//the attacker's deployment
	
	return true;
}

protected function PlaceHero()
{
	local H7CombatMapGridController grid;
	local IntPoint heroPos;
	local Rotator heroRot;
	local Vector heroVector;
    
	grid = class'H7CombatMapGridController'.static.GetInstance();

	// set the position of the hero from the grid
	
	heroPos = IsAttacker() ? grid.GetAttackerPosition() : grid.GetDefenderPosition();
	if( grid.GetCombatGrid().GetCellByIntPoint( heroPos ) != none )
	{
		heroVector = grid.GetCombatGrid().GetCellByIntPoint( heroPos ).GetCenterPosBySize( CELLSIZE_2x2 );
	}
	else
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("invalid hero position"@heroPos.X@heroPos.Y@"is attacker?"@IsAttacker()@"check the grid settings for attacker/defender hero offset! attacker: "@grid.GetAttackerHeroOffset().X@grid.GetAttackerHeroOffset().Y@"defender:"@grid.GetDefenderHeroOffset().X@grid.GetDefenderHeroOffset().Y,MD_QA_LOG);;
		;
	}

	if( mAdvHero != none )
	{
		;
		mHero = mAdvHero.Convert( self, GetHeroTag(), heroVector ); // TODO check if this works with skills
	}
	else if( mHeroArchetype == none )
	{
		; // TODO check when used
		mHero = Spawn( class'H7CombatHero', self, GetHeroTag(), heroVector );
	}
	else
	{
		;
		mHero = H7CombatHero( mHeroArchetype.CreateHero( self, GetHeroTag(), heroVector, false ) );
		if(mHeroArchetype.GetVisuals() != none)
		{
			mHero.SetMeshes(mHeroArchetype.GetVisuals().GetHorseSkeletalMesh(), mHeroArchetype.GetVisuals().GetHeroSkeletalMesh(), , mHeroArchetype.GetHorseRiderOffset());
		}
	}

	// set the rotation depending of IsAttacker
	heroRot.Yaw = IsAttacker() ? 0 : 32768;
	mHero.SetRotation(heroRot);
}

protected function PlaceWarUnits()
{
	local H7CombatMapGridController grid;
	local H7EditorWarUnit warUnit;
    
	
	grid = class'H7CombatMapGridController'.static.GetInstance();

	foreach mWarUnitTemplates(warUnit)
	{
		SpawnWarfareUnit( grid, warUnit );
	}
}

protected function SpawnWarfareUnit( H7CombatMapGridController grid,  H7EditorWarUnit template )
{
	local H7WarUnit warUnit;
	local IntPoint wuPos;
	local Rotator wuRot;
	
	
	// GUARDIAN : siege engine is only spawned for sieging attacker (defenders usually don't want to destroy their own fortifications)
	if( template.GetWarUnitClass() == WCLASS_SIEGE && ( !IsAttacker() || IsAttacker() && !grid.IsSiegeMap() ) )
		return;

	// set the position of the war unit from the grid
	wuPos = IsAttacker()? grid.GetAttackerWarUnitPosition(template.GetWarUnitClass()) : grid.GetDefenderWarUnitPosition(template.GetWarUnitClass() );
	
	// set the rotation depending of IsAttacker
	wuRot.Yaw = IsAttacker() ? 0 : 32768;

	// get archetype object according the warunit type and spawn it into world
	warUnit = template.CreateWarUnit( self, GetWarUnitTag(), wuRot, template );
	grid.PlaceWarfareUnit( wuPos, warUnit );
	mWarUnits.AddItem( warUnit );
}

protected function name GetHeroTag()
{
	return IsAttacker() ? 'HeroAttacker' : 'HeroDefender';
}

protected function name GetWarUnitTag()
{
	return IsAttacker() ? 'WarUnitAttacker' : 'WarUnitDefender';
}

// expects index into mBaseCreatureStacks
function bool PlaceStackOnGrid( int slotId )
{
	local IntPoint                      gridPos;
	local H7CombatMapGridController     grid;
	local H7StackDeployment             stackDep;
	local int                           sourceId;
	local H7BaseCreatureStack           baseStack;
	local H7CreatureStack               spawnedStack;

	stackDep=mDeployment.GetStackDeployment(slotId);
	sourceId=stackDep.SourceSlotId;
	if(sourceId!=-1)
	{
		baseStack = mBaseCreatureStacks[sourceId];
		if(baseStack == none)
		{
			;
			ScriptTrace();
			return false;
		}
		spawnedStack = baseStack.GetSpawnedStackOnMap();
		if(spawnedStack == none)
		{
			;
			ScriptTrace();
			return false;
		}

		grid = class'H7CombatMapGridController'.static.GetInstance();

		gridPos.Y = stackDep.DistanceTop;

		if( IsAttacker() == true )
		{
			gridPos.X = stackDep.DistanceSide;
			gridPos.X += class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
		}
		else
		{
			gridPos.X = grid.GetGridSizeX() - stackDep.DistanceSide - class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
			gridPos.X -= spawnedStack.GetCreature().GetXSize();
		}

		// check if creature can be placed at this pos
		if( grid.GetCombatGrid().GetCellByIntPoint(gridPos).CanPlaceCreatureStack(spawnedStack) == false )
		{
//			`LOG_AI("Can not place creature on grid at" @ gridPos.X @ "," @ gridPos.Y );
			return false;
		}

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		baseStack.SetDeployed(true);
		grid.PlaceCreature(gridPos, spawnedStack);
		spawnedStack.Show(true); 

		return true;
	}
	return false;
}

// expects index into mBaseCreatureStacks
function RemoveStackFromGrid( int slotId )
{
	local IntPoint              gridPos;
	local H7StackDeployment     stackDep;
	local int                   sourceId;
	local H7BaseCreatureStack   baseStack;
	local H7CreatureStack       spawnedStack;

	stackDep=mDeployment.GetStackDeployment(slotId);
	sourceId=stackDep.SourceSlotId;
	if(sourceId!=-1)
	{
		baseStack = mBaseCreatureStacks[sourceId];
		if(baseStack == none)
		{
			;
			ScriptTrace();
			return;
		}
		spawnedStack = baseStack.GetSpawnedStackOnMap();
		if(spawnedStack == none)
		{
			;
			ScriptTrace();
			return;
		}

		gridPos.X = -1;
		gridPos.Y = -1;
		mDeployment.SetStackGridPos(slotId,gridPos);

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		baseStack.SetDeployed(false);
		spawnedStack.RemoveStackFromGrid(true);
	}
}

function DeployCreatures()
{
	local H7DeploymentData dData;
	local int dIdx;
	
	dData = mDeployment.GetDeploymentData();

	for( dIdx = 0; dIdx < dData.StackDeployments.Length; ++dIdx )
	{
		if(dData.StackDeployments[dIdx].SourceSlotId!=-1 && mBaseCreatureStacks[dData.StackDeployments[dIdx].SourceSlotId].IsDeployed() )
		{
			//mBaseCreatureStacks[dData.StackDeployments[dIdx].SourceSlotId].SetDeployed(true);
			if( PlaceStackOnGrid(dIdx) == false )
			{
				// we break if any creature placement fails and return to autodeploy
				AutodeployCreatures();
				return;
			}
		}
	}

	UpdateCreaturesDeployedState(false); // after this moment mCreatureStacks and mBaseCreatureStacks are desynced!!!!!!!!!!!!!!!!!!!!!
}

function ResetCreatureDeployPos( H7BaseCreatureStack stack )
{
	local H7DeploymentData dData;
	local int dIdx;
	
	dData = mDeployment.GetDeploymentData();

	for( dIdx = 0; dIdx < dData.StackDeployments.Length; ++dIdx )
	{
		if(dData.StackDeployments[dIdx].SourceSlotId!=-1)
		{
			if( mBaseCreatureStacks[dData.StackDeployments[dIdx].SourceSlotId] == stack )
			{
				RemoveStackFromGrid( dIdx );
				break;
			}
		}
	}

	//UpdateCreaturesDeployedState(false); // after this moment mCreatureStacks and mBaseCreatureStacks are desynced!!!!!!!!!!!!!!!!!!!!!
}

function H7CreatureStack GetCreatureStackFromDeployment(H7StackDeployment deploymentStack)
{
	local int i;

	for( i = 0; i < mCreatureStacks.Length; ++i)
	{
		if(mCreatureStacks[i] == deploymentStack.CreatureStackRef)
		{
			return mCreatureStacks[i];
		}
	}

	return none;
}

// * works with blocked grid cells (obstacles) in the deployment area
// * deploys as many stacks as possible (max is 7)
// * local guard stacks are picked last
function AutodeployCreatures()
{
	local H7CombatMapGridController grid;
	local H7DeploymentData dData;
	local array<H7StackDeployment> aStacks;
	local int validColumns;
	local int dIdx, btIdx, amountPlaced, stackID;
	local int topRow, bottomRow, creatureSizeY, creatureSizeX, coverage;
	local IntPoint gp;
	local bool placed;
	local H7CreatureStack creatureStack;


	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	// start fresh
	OverrideDeploymentFromBaseStacks(true);

	grid = class'H7CombatMapGridController'.static.GetInstance();

	foreach mCreatureStacks( creatureStack )
	{
		creatureStack.RemoveStackFromGrid( true );
	}

	grid.ResetTacticsGrid();
	

	mDeployment.SetOriginalMapHeight(grid.GetCombatGrid().GetYSize());

	validColumns = GetCombatHero().GetMaxDeploymentRow();
	
	btIdx = 0;

	dData = mDeployment.GetDeploymentData();

	topRow = grid.GetGridSizeY() / 2;
	bottomRow = topRow;
	coverage = 0;

	creatureStack = none;

	// 2x2 first
	for( dIdx = 0; dIdx < dData.StackDeployments.Length; ++dIdx )
	{
		// slot contains a creature stack
		if( dData.StackDeployments[dIdx].CreatureStackRef != none )
		{
			creatureStack = GetCreatureStackFromDeployment(dData.StackDeployments[dIdx]);

			if( creatureStack == none || creatureStack.GetCreature() == none || creatureStack.GetBaseCreatureStack().IsDeployed()==true  )
			{
				continue;
			}
			if(creatureStack != none)
			{
				creatureSizeY = creatureStack.GetCreature().GetYSize();
				creatureSizeX = creatureStack.GetCreature().GetXSize();
			}
			else
			{
				creatureSizeY = 1;
				creatureSizeX = 1;
			}

			if( creatureSizeX==1 )
			{
				continue;
			}

			if((btIdx & 0x1)==0x1) // odd row
			{
				placed=false;
				while(placed==false)
				{
					if( (bottomRow+creatureSizeY) <= grid.GetGridSizeY() )
					{
						// we push melee creatures towards the enemy and keep ranged at the grid border
						if(creatureStack.GetCreature().IsRanged()==false && creatureSizeX<validColumns )
						{
							gp.X=validColumns-creatureSizeX;
						}
						else
						{
							gp.X=0;
						}
						gp.Y=bottomRow;
						mDeployment.SetStackGridPos(dIdx,gp);
				
						bottomRow += creatureSizeY;

						if( PlaceStackOnGrid(dIdx) == true )
						{
							coverage += creatureSizeY;
							btIdx++;
							amountPlaced++;
							placed=true;
						}
					}
					else
					{
						RemoveStackFromGrid(dIdx);
						placed=true; // :)
					}
				};
			}
			else
			{
				placed=false;
				while(placed==false)
				{
					if( (topRow-creatureSizeY) >= 0 )
					{
						topRow -= creatureSizeY;

						// we push melee creatures towards the enemy and keep ranged at the grid border
						if(creatureStack.GetCreature().IsRanged()==false && creatureSizeX<validColumns )
						{
							gp.X=validColumns-creatureSizeX;
						}
						else
						{
							gp.X=0;
						}

						gp.Y=topRow;
						mDeployment.SetStackGridPos(dIdx,gp);

						if( PlaceStackOnGrid(dIdx) == true )
						{
							coverage += creatureSizeY;
							btIdx++;
							amountPlaced++;
							placed=true;
						}
					}
					else
					{
						RemoveStackFromGrid(dIdx);
						placed=true; // :)
					}
				};
			}
		}
		if( amountPlaced >= class'H7CombatController'.static.GetInstance().GetMaxDeployNumber() )
		{
			break;
		}
	}

	// 1x1 second
	for( dIdx = 0; dIdx < dData.StackDeployments.Length; ++dIdx )
	{
		// slot contains a creature stack
		if( dData.StackDeployments[dIdx].CreatureStackRef != none )
		{
			creatureStack = GetCreatureStackFromDeployment(dData.StackDeployments[dIdx]);

			if( creatureStack == none || creatureStack.GetCreature() == none || creatureStack.GetBaseCreatureStack().IsDeployed()==true  )
			{
				continue;
			}
			if(creatureStack != none)
			{
				creatureSizeY = creatureStack.GetCreature().GetYSize();
				creatureSizeX = creatureStack.GetCreature().GetXSize();
			}
			else
			{
				creatureSizeY = 1;
				creatureSizeX = 1;
			}

			if( creatureSizeX==2 )
			{
				continue;
			}

			if((btIdx & 0x1)==0x1) // odd row
			{
				placed=false;
				while(placed==false)
				{
					if( (bottomRow+creatureSizeY) <= grid.GetGridSizeY() )
					{
						// we push melee creatures towards the enemy and keep ranged at the grid border
						if(creatureStack.GetCreature().IsRanged()==false && creatureSizeX<validColumns )
						{
							gp.X=validColumns-creatureSizeX;
						}
						else
						{
							gp.X=0;
						}
						gp.Y=bottomRow;
						mDeployment.SetStackGridPos(dIdx,gp);
				
						bottomRow += creatureSizeY;

						if( PlaceStackOnGrid(dIdx) == true )
						{
							amountPlaced++;
							coverage += creatureSizeY;
							btIdx++;
							placed=true;
						}
					}
					else
					{
						RemoveStackFromGrid(dIdx);
						placed=true; // :)
					}
				};
			}
			else
			{
				placed=false;
				while(placed==false)
				{
					if( (topRow-creatureSizeY) >= 0 )
					{
						topRow -= creatureSizeY;

						// we push melee creatures towards the enemy and keep ranged at the grid border
						if(creatureStack.GetCreature().IsRanged()==false && creatureSizeX<validColumns )
						{
							gp.X=validColumns-creatureSizeX;
						}
						else
						{
							gp.X=0;
						}

						gp.Y=topRow;
						mDeployment.SetStackGridPos(dIdx,gp);

						if( PlaceStackOnGrid(dIdx) == true )
						{
							amountPlaced++;
							coverage += creatureSizeY;
							btIdx++;
							placed=true;
						}
					}
					else
					{
						RemoveStackFromGrid(dIdx);
						placed=true; // :)
					}
				};
			}
		}
		if( amountPlaced >= class'H7CombatController'.static.GetInstance().GetMaxDeployNumber() )
		{
			break;
		}
	}

	topRow = 0;

	// fill up holes if we have remaining undeployed stacks
	for( dIdx = 0; dIdx < dData.StackDeployments.Length; ++dIdx )
	{
		if( amountPlaced >= class'H7CombatController'.static.GetInstance().GetMaxDeployNumber() )
		{
			break;
		}
		// slot contains a creature stack
		if( dData.StackDeployments[dIdx].CreatureStackRef != none )
		{
			creatureStack = GetCreatureStackFromDeployment(dData.StackDeployments[dIdx]);

			if( creatureStack == none || creatureStack.GetCreature() == none || creatureStack.GetBaseCreatureStack().IsDeployed()==true  )
			{
				continue;
			}
			if(creatureStack != none)
			{
				creatureSizeY = creatureStack.GetCreature().GetYSize();
				creatureSizeX = creatureStack.GetCreature().GetXSize();
			}
			else
			{
				creatureSizeY = 1;
				creatureSizeX = 1;
			}

			gp.X=0;
			gp.Y=topRow;
			placed=false;
			while(placed==false)
			{
				if( (topRow+creatureSizeY) <= grid.GetGridSizeY() )
				{
					mDeployment.SetStackGridPos(dIdx,gp);
					if( PlaceStackOnGrid(dIdx) == true )
					{
						amountPlaced++;
						btIdx++;
						placed=true;
					}
					else
					{
						gp.X++;
						if((gp.X+creatureSizeX)>validColumns)
						{
							gp.X=0;
							topRow++;
							gp.Y=topRow;
						}
					}
				}
				else
				{
					RemoveStackFromGrid(dIdx);
					placed=true;
				}
			}
		}
	}

	mDeployment.RecalcStackOrdinal();

	// spread deployed stacks if we have some wiggle space left to lessen their vulnerability to AoE spells
	if(coverage<grid.GetGridSizeY() && btIdx>1 )
	{
		aStacks=mDeployment.GetDeploymentByOrdinals();

		placed=true;
		while(placed==true)
		{
			placed=false;
			for( dIdx = 0; dIdx < aStacks.Length; ++dIdx )
			{
				stackID = mDeployment.GetIdOfCreatureStack(aStacks[dIdx].CreatureStackRef);

				if(aStacks[dIdx].SpacingTop>MAX(aStacks[dIdx].SpacingBottom,1) && dIdx < aStacks.Length/2 )
				{
					// move up stack by one cell
					RemoveStackFromGrid(stackID);
					gp.X = aStacks[dIdx].DistanceSide;
					gp.Y = aStacks[dIdx].DistanceTop - 1;
					mDeployment.SetStackGridPos(stackID,gp);
					if( PlaceStackOnGrid(stackID) == false ) // we need to rewind the action
					{
						gp.X = aStacks[dIdx].DistanceSide;
						gp.Y = aStacks[dIdx].DistanceTop + 1; // THEN ACTUALLY REWIND THE ACTION MAYBE???
						mDeployment.SetStackGridPos(stackID,gp);
						PlaceStackOnGrid(stackID);
					}
					else
					{
						placed=true;
						aStacks[dIdx].DistanceTop--;
						aStacks[dIdx].SpacingTop--;
						aStacks[dIdx].SpacingBottom++;
						mDeployment.SetStackSpacing(stackID,aStacks[dIdx].SpacingTop,aStacks[dIdx].SpacingBottom);
						if(dIdx<aStacks.Length-1)
						{
							aStacks[dIdx+1].SpacingTop++;
							mDeployment.SetStackSpacing(mDeployment.GetIdOfCreatureStack(aStacks[dIdx + 1].CreatureStackRef), aStacks[dIdx+1].SpacingTop, aStacks[dIdx+1].SpacingBottom);
						}
					}
				}
				if(aStacks[dIdx].SpacingBottom>MAX(aStacks[dIdx].SpacingTop,1) && dIdx > aStacks.Length/2) 
				{
					// move up stack by one cell
					RemoveStackFromGrid(stackID);
					gp.X = aStacks[dIdx].DistanceSide;
					gp.Y = aStacks[dIdx].DistanceTop + 1;
					mDeployment.SetStackGridPos(stackID,gp);
					if( PlaceStackOnGrid(stackID) == false ) // we need to rewind the action
					{
						gp.X = aStacks[dIdx].DistanceSide;
						gp.Y = aStacks[dIdx].DistanceTop - 1; // THEN ACTUALLY REWIND THE ACTION MAYBE???
						mDeployment.SetStackGridPos(stackID,gp);
						PlaceStackOnGrid(stackID);
					}
					else
					{
						placed=true;
						aStacks[dIdx].DistanceTop++;
						aStacks[dIdx].SpacingTop++;
						aStacks[dIdx].SpacingBottom--;
						mDeployment.SetStackSpacing(stackID ,aStacks[dIdx].SpacingTop,aStacks[dIdx].SpacingBottom); // aStacks[dIdx].SourceSlotId
						if(dIdx>0)
						{
							aStacks[dIdx-1].SpacingBottom++;
							mDeployment.SetStackSpacing(mDeployment.GetIdOfCreatureStack(aStacks[dIdx - 1].CreatureStackRef), aStacks[dIdx-1].SpacingTop, aStacks[dIdx-1].SpacingBottom);
						}
					}
				}
			}
		}
	}

	UpdateCreaturesDeployedState(false); // after this moment mCreatureStacks and mBaseCreatureStacks are desynced!!!!!!!!!!!!!!!!!!!!!

	grid.SetArmyForeShadowedCells( false );
	grid.SetDecalDirty( true );

}

function PlaceCreaturesAmbush()//for the defender
{
	local H7CombatMapGridController grid;
	local H7BaseCreatureStack baseStack;
	local IntPoint stackCustomCell;
	local int i;
	local bool bDeployAreaFound;
	local IntPoint deployAreaCenter;
	local H7DeploymentArea deployArea;
	local Rotator rot;
	local H7CreatureStack spawnedStack;

	grid = class'H7CombatMapGridController'.static.GetInstance();

	bDeployAreaFound = false;
	foreach DynamicActors(class'H7DeploymentArea', deployArea)
	{
		deployAreaCenter = grid.GetCell(deployArea.Location).GetCellPosition();
		bDeployAreaFound = true;
		break;
	}

	if (!bDeployAreaFound)
	{
		deployAreaCenter.X = ffloor((grid.GetGridSizeX()-1)/2);
		deployAreaCenter.Y = ffloor((grid.GetGridSizeY()-1)/2);
	}


	foreach mBaseCreatureStacks( baseStack, i )
	{
		if ( baseStack != none && baseStack.mUseCustomPosition )
		{
			stackCustomCell.X = baseStack.mCustomPositionX + class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
			stackCustomCell.Y = baseStack.mCustomPositionY;

			spawnedStack = GetStackBySourceSlotId(i);
			grid.PlaceCreature(stackCustomCell, spawnedStack);
			spawnedStack.Show(true);

			rot.Yaw = -Atan2((deployAreaCenter.Y - stackCustomCell.Y), (deployAreaCenter.X - stackCustomCell.X)) * RadToUnrRot;
			spawnedStack.SetRotation(rot);

			baseStack.SetDeployed(true);
		}
	}
}

delegate int CreatureRangedFirstSort(H7CreatureStack A, H7CreatureStack B) 
{
	if (A.IsRanged() && !B.IsRanged()) return -1;
	if (B.IsRanged() && !A.IsRanged()) return 1;
	return 0;
}

function SetCreatureStackCell(H7CreatureStack stack, int CellX, int CellY)
{
	local H7CombatMapGridController grid;
	local IntPoint stackCustomCell;
	grid = class'H7CombatMapGridController'.static.GetInstance();
	stackCustomCell.X = CellX;
	stackCustomCell.Y = CellY;
	grid.PlaceCreature(stackCustomCell, stack);
	stack.Show(true); 
}

function bool CheckOccupationFree2x2(out array<H7CreatureStack> occupation, int x, int y, int w)//return false if occupied
{
	local int idxKey;

	//top left
	idxKey = y * w + x;
	if ( idxKey<0 || idxKey>=occupation.Length || occupation[idxKey] != none)
	{
		return false;
	}

	//top right
	idxKey = y * w + (x+1);
	if ( idxKey<0 || idxKey>=occupation.Length || occupation[idxKey] != none)
	{
		return false;
	}

	//bottom left
	idxKey = (y+1) * w + x;
	if ( idxKey<0 || idxKey>=occupation.Length || occupation[idxKey] != none)
	{
		return false;
	}

	//bottom right
	idxKey = (y+1) * w + (x+1);
	if ( idxKey<0 || idxKey>=occupation.Length || occupation[idxKey] != none)
	{
		return false;
	}

	return true;
}

function SetOccupation2x2(out array<H7CreatureStack> occupation, int x, int y, int w, H7CreatureStack stack)
{
	local int i, j;
	local int idxKey;
	for(i=x;i<=x+1;i++)
	{
		for(j=y;j<=y+1;j++)
		{
			idxKey = j * w + i;
			if (idxKey >= 0 && idxKey < occupation.Length)
			{
				occupation[idxKey] = stack;
			}
		}
	}
}

function PlaceCreaturesBeingAmbushed()//for the attacker
{
	//TODO: define width / height by config or map setting
	local int TotalW;
	local int TotalH;
	local array<H7CreatureStack> CreatureOccupation;//index = Y * TotalW + X
	local H7CombatMapGridController grid;
	local H7DeploymentArea deployArea;
	local Vector deployAreaMin;
	local IntPoint gridToDeployOffset;
	local bool bDeployAreaFound;
	local int gridW, gridH;
	local H7BaseCreatureStack baseStack;
	local H7Creature creatureTemplate;
	local int i;
	local array<H7CreatureStack> creatureStacks1x1, creatureStacks2x2;
	local int cellStartingX, cellStartingY, cellX, cellY;
	local IntPoint DeployRelativeOffset;	
	local array<IntPoint> CellPosTopLeft2x2;
	

	grid = class'H7CombatMapGridController'.static.GetInstance();
	gridW = grid.GetGridSizeX(); gridH = grid.GetGridSizeY();

	//First search for H7DeploymentArea, if exists, use the definition
	bDeployAreaFound = false;
	foreach DynamicActors(class'H7DeploymentArea', deployArea)
	{
		TotalW = deployArea.GetSizeX();
		TotalH = deployArea.GetSizeY();
		deployAreaMin = deployArea.Location;
		deployAreaMin.X -= deployArea.GetSizeX() * class'H7EditorMapGrid'.const.CELL_SIZE * 0.5;
		deployAreaMin.Y -= deployArea.GetSizeY() * class'H7EditorMapGrid'.const.CELL_SIZE * 0.5;
		gridToDeployOffset = grid.GetCell(deployAreaMin).GetCellPosition();
		bDeployAreaFound = true;
		break;
	}

	if (!bDeployAreaFound)
	{
		TotalW = 6; TotalH = 6;
		//if W / H can not align to grid center, extend by 1
		if ( (gridW - TotalW) % 2 != 0 )
		{
			TotalW += 1;
		}
		if ( (gridH - TotalH) % 2 != 0 )
		{
			TotalH += 1;
		}
		gridToDeployOffset.X = (gridW - TotalW)/2;
		gridToDeployOffset.Y = (gridH - TotalH)/2;
	}

	CreatureOccupation.Add(TotalW * TotalH);//occupation data for all cells in the rectangle, initially none for all cells	

	//prepare data
	foreach mBaseCreatureStacks(baseStack, i)
	{
		if ( baseStack == none ) continue;
		creatureTemplate = baseStack.GetStackType();
		if (creatureTemplate.GetXSize() == 1 && creatureTemplate.GetYSize() == 1)
		{
			creatureStacks1x1.AddItem(GetStackBySourceSlotId(i));
			baseStack.SetDeployed(true);
		}
		else if (creatureTemplate.GetXSize() == 2 && creatureTemplate.GetYSize() == 2)
		{
			creatureStacks2x2.AddItem(GetStackBySourceSlotId(i));
			baseStack.SetDeployed(true);
		}
	}

	//sort by ranged > not ranged
	creatureStacks1x1.Sort(CreatureRangedFirstSort);
	creatureStacks2x2.Sort(CreatureRangedFirstSort);

	//1x1 creature placement using AmbushDeployRelativeCellOffset_1x1
	//Starting cell:
	cellStartingY = (TotalH%2 == 0) ? TotalH/2-1 : (TotalH-1)/2;
	cellStartingX = (TotalW%2 == 0) ? TotalW/2-1 : (TotalW-1)/2;

	foreach AmbushDeployRelativeCellOffset_1x1 ( DeployRelativeOffset, i )
	{
		if ( i >= creatureStacks1x1.Length )
			break;
		CellX = CellStartingX + DeployRelativeOffset.X;
		CellY = cellStartingY + DeployRelativeOffset.Y;

		CreatureOccupation[CellY * TotalW + CellX] = creatureStacks1x1[i];
		SetCreatureStackCell(creatureStacks1x1[i], CellX + gridToDeployOffset.X, CellY + gridToDeployOffset.Y);
	}

	//2x2 creature placement
	if ( creatureStacks1x1.Length < 7 )
	{
		CellPosTopLeft2x2 = GenerateAmbushDeployCellOffset2x2(TotalW, TotalH);
		foreach CellPosTopleft2x2(DeployRelativeOffset)
		{			
			CellX = DeployRelativeOffset.X;
			CellY = DeployRelativeOffset.Y;

			if ( creatureStacks2x2.Length == 0 )
				return;
			//check occupation
			if (CheckOccupationFree2x2(CreatureOccupation, CellX, CellY, TotalW))
			{
				SetOccupation2x2(CreatureOccupation, CellX, CellY, TotalW, creatureStacks2x2[0]);
				SetCreatureStackCell(creatureStacks2x2[0], CellX + gridToDeployOffset.X, CellY + gridToDeployOffset.Y);
				creatureStacks2x2.Remove(0, 1);
			}
		}
	}
}

function array<IntPoint> GenerateAmbushDeployCellOffset2x2 (int W, int H)
{
	local array<IntPoint> result;//stores the top left tile idx of 2x2
	local IntPoint resultElement;
	local int cellStartingX, cellStartingY, cellX, cellY;
	local IntPoint point;
	local array<SAmbushDeploymentCircle> Circles;
	local SAmbushDeploymentCircle CircleDef;
	local int generatedCirclesAreaSize;
	//first, get the start cell
	cellStartingY = (H%2 == 0) ? H/2-1 : (H-1)/2;
	cellStartingX = (W%2 == 0) ? W/2-1 : (W-1)/2;

	//for 2x2, the starting cell center is at the top right corner, so the top left cell is one above the starting cell
	//point.X = cellStartingX; point.Y = cellStartingY-1;

	//clockwise traverse using GenerateClockwiseCirclesFromArea
	generatedCirclesAreaSize = max(H,W);
	Circles = GenerateClockwiseCirclesFromArea(generatedCirclesAreaSize);//this may modify generatedCirclesAreaSize to odd if it was even
	//the center of circles are coord(generatedCirclesAreaSize/2, generatedCirclesAreaSize/2)
	//so for each coord in Circles[i].points, the corresponding top left cell should be calculated as
	//coord - (generatedCirclesAreaSize/2, generatedCirclesAreaSize/2) + (cellStartingX+0.5, cellStartingY+0.5) - (0, 1)
	foreach Circles (CircleDef)
	{
		foreach CircleDef.points(point)
		{
			cellX = Round(point.X - generatedCirclesAreaSize/2.f + cellStartingX + 0.5);
			cellY = Round(point.Y - generatedCirclesAreaSize/2.f + cellStartingY + 0.5 - 1);
			//if this 2x2 area is valid in the area of (W,H), push it into result
			if (Check2x2CellIdxValid(cellX, cellY, W, H))
			{
				resultElement.X = cellX; resultElement.Y = cellY; result.AddItem(resultElement);
			}
		}
	}
	return result;
}

function bool Check2x2CellIdxValid(int x_topleft, int y_topleft, int w, int h)
{
	local int i, j;
	for(i=x_topleft;i<=x_topleft+1;i++)
	{
		for(j=y_topleft;j<=y_topleft+1;j++)
		{
			if (i < 0 || i >= w || j < 0 || j >= h)
				return false;
		}
	}
	return true;
}

delegate int SortPointsByAngle12OClock(SClockwiseCircleDetectionPoint p1, SClockwiseCircleDetectionPoint p2)
{
	local float delX_a, delX_b, delY_a, delY_b, det;
	delX_a = p1.relativeCoordToCenter.X;
	delY_a = p1.relativeCoordToCenter.Y;
	delX_b = p2.relativeCoordToCenter.X;
	delY_b = p2.relativeCoordToCenter.Y;

    if (delX_a >= 0 && delX_b < 0)
        return -1;//less
    if (delX_a < 0 && delX_b >= 0)
        return 1;
    if (delX_a == 0 && delX_b == 0) {
        if (delY_a >= 0 || delY_b >= 0)
            return (delY_a > delY_b) ? -1 : 1;
        return (delY_b > delY_a) ? -1 : 1;
    }

    // compute the cross product of vectors (center -> a) x (center -> b)
    det = (delX_a) * (delY_b) - (delX_b) * (delY_a);
    if (det < 0)
        return -1;
    if (det > 0)
        return 1;

    // points a and b are on the same line from the center
    return 0;
}

delegate int SortPointsByDistance(SClockwiseCircleDetectionPoint p1, SClockwiseCircleDetectionPoint p2)
{
	if (p1.distanceSq < p2.distanceSq) return 1;
	if (p1.distanceSq == p2.distanceSq) return 0;
	return -1;
}

function array<SAmbushDeploymentCircle> GenerateClockwiseCirclesFromArea(out int size)
{
	local array<SAmbushDeploymentCircle> results;
	local SAmbushDeploymentCircle resultElement;
	local array<SClockwiseCircleDetectionPoint> allPoints, circlePoints;
	local int i, j;
	local SClockwiseCircleDetectionPoint point;
	local Vector2D CenterCoord;
	local float LastDistanceSq;

	//size must be odd
	if (size%2 == 0) size++;

	//the center coordinate will not be in the set, but has value (size/2, size/2)
	CenterCoord = vect2d(size/2.f, size/2.f);

	//(0,0) indicates the top left corner. generate a set of coordinates from (0,0) to (size,size)
	for(i = 0; i < size; i++)
	{
		for(j=0; j < size; j++)
		{
			point.coord.X = i; point.coord.Y = j;
			point.distanceSq = (i - CenterCoord.X)**2 + (j - CenterCoord.Y)**2;
			point.relativeCoordToCenter.X = i - CenterCoord.X; point.relativeCoordToCenter.Y = j - CenterCoord.Y;
			allPoints.AddItem(point);
		}
	}
	
	allPoints.Sort(SortPointsByDistance);

	//points with the same distance belong to a circle.
	circlePoints.Length = 0;//clear
	LastDistanceSq = 0;//clear
	while (allPoints.Length > 0)
	{
		if ( LastDistanceSq == 0 ) LastDistanceSq = allPoints[0].distanceSq;

		if ( allPoints[0].distanceSq == LastDistanceSq )
		{
			circlePoints.AddItem(allPoints[0]);
			allPoints.Remove(0, 1);
		}
		else
		{
			//circlePoints contains the last circle, sort clockwise
			circlePoints.Sort(SortPointsByAngle12OClock);
			resultElement.points.Length = 0;
			foreach circlePoints (point, i)
			{
				resultElement.points.AddItem(point.coord);
			}
			results.AddItem(resultElement);
			circlePoints.Length = 0;//clear
			LastDistanceSq = 0;//clear
		}
	}
	return results;
}

protected function RemoveStacks( array<H7BaseCreatureStack> baseStacks )
{
	local int i;
	local H7CreatureStack creatureStack;
	// see if something is spawned
	for(i=0; i<baseStacks.Length; i++)
	{
		if(baseStacks[i]!=None)
		{
			creatureStack = baseStacks[i].GetSpawnedStackOnMap();
			if(creatureStack!=None)
			{
				creatureStack.RemoveStackFromGrid(true);
			}
		}
	}
	mCreatureStacks.Remove(0,mCreatureStacks.Length);
}

protected function CreateStacks( array<H7BaseCreatureStack> baseStacks )
{
	local int i;
	local H7CreatureStack creatureStack;
	
	// make copy of base stacks
	for(i = 0; i < baseStacks.Length; i++)
	{
		// we must still have a "blank" creature stack for consistency
		if( baseStacks[i] == none || baseStacks[i].GetStackSize() == 0 || baseStacks[i].GetStackType() == none ) { mCreatureStacks.Add( 1 ); continue; }

		creatureStack = SpawnStack(baseStacks[i]);
		
		mCreatureStacks.AddItem(creatureStack);
		
		;
	}
}

// warning - add the returned stack properly to mCreatureStacks
function H7CreatureStack SpawnStack(H7BaseCreatureStack templateStack)
{
	local H7CreatureStack creatureStack;
	local Rotator stackOrientation;
	
	stackOrientation = GetStackOrientation();

	creatureStack = Spawn( class'H7CreatureStack', self, 'name',, stackOrientation );
	creatureStack.SetCreature( templateStack.GetStackType() );
	creatureStack.SetInitialStackSize( templateStack.GetStackSize() );
	creatureStack.SetArmy( self );
	creatureStack.SetBaseCreatureStack( templateStack );
	creatureStack.Init();
	creatureStack.SetOverrideByAI( templateStack.HasAILock() );

	// give basestack a link to spawnedstack
	templateStack.SetSpawnedStackOnMap(creatureStack);

	return creatureStack;
}

protected function InitStacksHeroEffects()
{
	local H7CreatureStack creatureStack;
	if(GetCombatHero() == none)
	{
		;
	}
	foreach mCreatureStacks(creatureStack)
	{
		creatureStack.ApplyHeroArmyBonusBuff();
	}
}

protected function PositionStacks( IntPoint stackPositions[7], optional int verticalOffset = 0 )
{
	local int i;
	local Vector stackPosition;
	local H7CombatMapGridController grid;
	
	grid = class'H7CombatMapGridController'.static.GetInstance();

	for(i = 0; i < mCreatureStacks.Length; i++)
	{
		if( mCreatureStacks[i] == none || mCreatureStacks[i].GetBaseCreatureStack() == none ) { continue; }
		stackPositions[i].Y += verticalOffset;
		stackPosition = grid.GetCellLocation( stackPositions[i] );	// get world position from grid position

		mCreatureStacks[i].SetGridPosition(stackPositions[i]);
		mCreatureStacks[i].SetLocation( stackPosition );
	}
}

protected function UpdateHealthpoints()
{
	local H7CreatureStack currentStack;
	local H7WarUnit currentUnit;

	// Update TopCeature stacks Current HitPoints
	foreach mCreatureStacks( currentStack )
	{
		currentStack.SetTopCreatureHealth( currentStack.GetHitpoints() );
	}

	// Update WarUnits Current HitPoints
	foreach mWarUnits( currentUnit )
	{
		currentUnit.SetCurrentHitPoints( currentUnit.GetHitPoints() );
	}


}

function Rotator GetStackOrientation()
{
	local Rotator stackOrientation;
	stackOrientation.Pitch = 0;
	stackOrientation.Roll = 0;
	stackOrientation.Yaw = IsAttacker() ? 0 : 32768;
	return stackOrientation;
}

function UpdateCreaturesDeployedState(optional bool removeUndeployed = true)
{
	local int i;

	// remove the creatures that were not deployed
	for( i=mCreatureStacks.Length-1; i>=0; --i )
	{
		if( mCreatureStacks[i] == none || ( removeUndeployed && ( mCreatureStacks[i].GetGridPosition().X == -1 || mCreatureStacks[i].GetGridPosition().Y == -1 ) ) ) // TODO multiplayer, we want undeployed stacks to be spawned and invisible, but multiplayer does not?
		{
			;
			if(mCreatureStacks[i] != none && mCreatureStacks[i].GetBaseCreatureStack() != none)
			{
				mCreatureStacks[i].GetBaseCreatureStack().SetDeployed( false );
				mCreatureStacks[i].RemoveStackFromGrid(true);
				mCreatureStacks[i].GetBaseCreatureStack().SetDeployed( false );
			}
			mCreatureStacks.Remove( i, 1 );
		}
	}
}

function SaveTacticsDeployment()
{
	mDeployment.RecalcStackOrdinal();
}

// to update CreatureInfoWindow
function UpdateCreatureStacksGUI()
{
	local H7CreatureStack stack;

	foreach mCreatureStacks(stack)
	{
		stack.ApplyHeroArmyBonusBuff(); // reapply hero army bonus buff because hero data maybe changed ( destiny / leadership )
		stack.DataChanged();
	}
}

delegate int CreatureVerticalPositionSort(H7CreatureStack A, H7CreatureStack B) 
{ 
	return A.GetGridPosition().Y > B.GetGridPosition().Y ? -1 : 0; 
}

function RemoveTower( H7TowerUnit tower )
{
	mTowers.RemoveItem( tower );
	class'H7CombatController'.static.GetInstance().GetInitiativeQueue().RemoveUnit( tower );
}

function float GetStackPower( H7CreatureStack stack )
{
	local H7CreatureStack checkStack;

	// make sure stack is member of this army
	foreach mCreatureStacks(checkStack)
	{
		if( checkStack == stack && !stack.IsDead() ) 
		{
			return stack.GetCreature().GetCreaturePower() * float(stack.GetStackSize());
		}
	}
	return 0.0f;
}

function int GetTotalHealth()
{
	local H7CreatureStack checkStack;
	local H7WarUnit warUnit;

	local int numAliveCreatures;

	foreach mCreatureStacks(checkStack)
	{
		if(  !checkStack.IsDead() ) 
		{
			numAliveCreatures += ( checkStack.GetStackSize() - 1 ) * checkStack.GetHitPoints() + checkStack.GetTopCreatureHealth();
		}
	}

	foreach mWarUnits(warUnit)
	{
		if(  !warUnit.IsDead() ) 
		{
			numAliveCreatures += warUnit.GetCurrentHitPoints();
		}
	}
	
	return numAliveCreatures;
}

event simulated Destroyed()
{
	mHero.Destroy();
	super.Destroyed();
}

function CalculateInitialTotalLife()
{
	mInitialTotalLife = GetTotalHealth();
}

// returns [0,100] of the current life of the army
function int GetPercentTotalLife( bool inverted )
{
	local int percent;

	percent = float(GetTotalHealth()) / float(mInitialTotalLife) * 100.f;
	percent = Clamp( percent, 0, 100 );

	if( inverted )
	{
		return 100 - percent;
	}
	else
	{
		return percent;
	}
}

function RemoveDeadCreatureStackDeploymentSlotID()
{
	local H7CreatureStack singleStack;

	foreach mCreatureStacks( singleStack )
	{
		if(singleStack.IsDead())
		{
			mDeployment.RemoveStackDeplyomentData(singleStack.GetCreature().GetDeploymentSlotID());
		}
	}
}

native function int GetArmyDamagePool();

native function int GetArmyRangedDamage();

native function int GetArmyMeleeDamage();

