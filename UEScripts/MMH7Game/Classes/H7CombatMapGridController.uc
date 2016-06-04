//=============================================================================
// CombatMapGridController
//=============================================================================
//
// These parameters are commonly used in this class:
// hitCell: The cell that is actually hit by the cursor.
// hitCells: Group of cells that are affected by the hitCell.
//
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapGridController extends H7EditorCombatGrid implements(H7IEffectTargetable, H7ICaster )
	placeable
	dependson( H7ReplicationInfo )
	native;

var protected H7CombatController		mCombatController;
var protected H7CombatMapPathPreviewer	mPathPreviewer;
var protected H7CreatureStack			mSelectedStack;
var protected H7WarUnit					mSelectedWarUnit;
var protected ECellSize					mSelectedCreatureSize;
var protected H7CombatMapGrid			mGrid;
var protected H7FCTController			mFCT;
var protected array<H7CombatMapCell>	mMouseOverCells; // glows when mouse over them and can do something there // future position of stack
var protected array<H7CombatMapCell>	mReachableCells; // these are foreshadow/movement-reachable cells
var protected array<H7CombatMapCell>	mReachableAltCells; // these are foreshadow/movement-reachable cells alternative
var protected array<H7CombatMapCell>	mSelectedCells;
var protected array<H7CombatMapCell>    mAbilityHighlightCells;
var protected array<H7CombatMapCell>    mNewAbilityHighlightCells;
var protected H7CombatMapCell			mCurrentMouseOverCell;
var protected H7CombatMapCell			mCurrentMouseOverTrueCell;
var protected H7Unit			        mCurrentReachableAltCreature; // the current creature stack that is using the reachable alternative cells
var protected int						mTacticsPlaceableColumns;
var protected bool						mIsSiegeMap;
var protected H7AbilityManager		    mAbilityManager;
var protected H7BuffManager			    mBuffManager;
var protected H7EventManager            mEventManager;
var protected H7EffectManager           mEffectManager;
var protected H7AuraManager             mAuraManager;
var protected H7IEffectTargetable       mCurrentHoverTarget;
var protected bool                      mCanForceUpdateGrid;

var protected array<ParticleSystemComponent> mParticleList;

var protected H7CreatureStack           mPreviousAttacker;
var protected bool                      mCouldAttackBefore;
var protected array<H7CombatMapCell>    mCurrentAttackPosition;

var protected array<Actor>              mTraceBufferActors;		// saves the actors that were traced in this frame already, for mouseover
var protected array<Vector>             mTraceBufferLocations;	// saves the locations that were traced in this frame already, for mouseover

var protected DynamicSMActor_Spawnable  mConePreview;

// these obstacles are created from mObstacles and are targetable on the combat map
var protected array<H7CombatObstacleObject>    mPlacedObstacles;

var protected bool                      mIsDecalDirty;

function SetDecalDirty( bool isDirty )
{
	mIsDecalDirty = isDirty;
}
function bool IsDecalDirty()
{
	return mIsDecalDirty;
}

simulated function SetCombatController(H7CombatController combatController) { mCombatController = combatController; }

simulated function H7CombatMapGrid	        GetCombatGrid()	                                { return mGrid; }
simulated function H7CreatureStack	        GetSelectedStack()	                            { return mSelectedStack; }
simulated function array<H7CombatMapCell>	GetMouseOverCells()	                            { return mMouseOverCells; }
simulated function H7CombatMapCell	        GetCurrentMouseOverCell()	                    { return mCurrentMouseOverCell; }
simulated function H7CombatMapPathPreviewer	GetPathPreviewer()	                            { return mPathPreviewer; }
simulated function bool	                    IsSiegeMap()	                                { return mIsSiegeMap; }

native function H7ICaster					GetOriginal();
native function H7AbilityManager			GetAbilityManager();
native function H7BuffManager				GetBuffManager();
native function H7EventManager				GetEventManager();
function H7EffectManager					GetEffectManager()								{ return mEffectManager; }
native function int							GetID();
function string								GetName()			                            { return "CombatGrid"; }
function									DataChanged(optional String cause)	            {}
function array<H7CombatObstacleObject>		GetObstacles()			                        { return mPlacedObstacles; }
native function EUnitType  					GetEntityType();
native function float						GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);
function H7AuraManager						GetAuraManager()                                { return mAuraManager; }

native function Vector						GetLocation();
native function IntPoint					GetGridPosition();
native function bool						IsDefaultAttackActive();
function ECommandTag						GetActionID( H7BaseAbility ability )            { return ACTION_ABILITY; }  
function									PrepareAbility(H7BaseAbility ability)			{ GetAbilityManager().PrepareAbility( ability ); }
function H7BaseAbility						GetPreparedAbility()                            { return GetAbilityManager().GetPreparedAbility(); }
native function H7Player					GetPlayer();
native function H7CombatArmy				GetCombatArmy();
function H7IEffectTargetable				GetCurrentHoverTarget()                         { return mCurrentHoverTarget; }
function bool								IsShip()                                        { return mIsShip; }


function float			GetMinimumDamage()  { return 0;}
function float			GetMaximumDamage()  { return 0;}
function int			GetAttack()         { return 0;}
native function int		GetLuckDestiny();//    { return 0;}
function int			GetMagic()          { return 0;}
function int			GetStackSize()      { return 1;}
function EAbilitySchool	GetSchool()	        { return ABILITY_SCHOOL_NONE; }
function int	        GetHitPoints()	    {}

simulated function	    ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}
function	            TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) {}


// there is only one combatmap grid per level
simulated static function H7CombatMapGridController GetInstance()
{
	if(class'H7ReplicationInfo'.static.GetInstance()==none) return none;
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatGridController();
}

function UsePreparedAbility(H7IEffectTargetable target)  
{ 
	local H7BaseGameController bgController;

	bgController = class'H7BaseGameController'.static.GetBaseInstance();
	bgController.GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( self, UC_ABILITY, ACTION_ABILITY, GetPreparedAbility(), target ) );
}

function AddAbilityHighlightCells( H7CombatMapCell cell )
{
	if( cell != none && mNewAbilityHighlightCells.Find( cell ) == INDEX_NONE ) 
	{
		mNewAbilityHighlightCells.AddItem( cell );
	}
}

function SetAbilityHighlightCells( array<H7CombatMapCell> cells )
{
	mNewAbilityHighlightCells = cells;
}

function bool HasReachableCells( H7CreatureStack stack )     
{
	local array<H7CombatMapCell> cells;

	if( stack == none ) return false;

	cells = stack.GetCell().GetMergedCells();
	return mReachableCells.Length > cells.Length;
}

function H7CombatObstacleObject GetObstacle( int id )
{
	local H7CombatObstacleObject dasObstacle;

	foreach mPlacedObstacles( dasObstacle )
	{
		if( dasObstacle.GetID() == id )
		{
			return dasObstacle;
		}
	}
	
	return none;
}

simulated function IntPoint GetAttackerPosition() 
{ 
	local IntPoint attackerPos;
	attackerPos.X = mAttackerHeroOffset.X;
	attackerPos.Y = mAttackerHeroOffset.Y;
	return attackerPos;
}

simulated function IntPoint GetDefenderPosition() 
{ 
	local IntPoint defenderPos;
	defenderPos.X = mDefenderHeroOffset.X + mAdjustedGridSizeX - WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
	defenderPos.Y = mDefenderHeroOffset.Y;
	return defenderPos;
}

function IntPoint GetAttackerWarUnitPosition( EWarUnitClass id ) 
{ 
	local IntPoint attackerPos;
	// use the attack warfare unit's position for hybrids
	if( id == WCLASS_HYBRID )
	{
		id = WCLASS_ATTACK;
	}
	attackerPos.X = 0;
	attackerPos.Y = mAttackerWarUnitOffset[id];
	return attackerPos;
}

function IntPoint GetDefenderWarUnitPosition( EWarUnitClass id ) 
{ 
	local IntPoint defenderPos;
	// use the attack warfare unit's position for hybrids
	if( id == WCLASS_HYBRID )
	{
		id = WCLASS_ATTACK;
	}
	defenderPos.X = mAdjustedGridSizeX - WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
	defenderPos.Y = mDefenderWarUnitOffset[id];
	return defenderPos;
}

simulated event Tick(float deltaTime)
{
	super.Tick(deltaTime);

	Init();
	
	mTraceBufferActors.Length = 0;
	mTraceBufferLocations.Length = 0;

	if( WorldInfo.GRI != none )
	{
		if( WorldInfo.GRI.bMatchHasBegun && !WorldInfo.GRI.bMatchIsOver )
		{
			UpdateHoverEffects();
			if( mIsDecalDirty )
			{
				mGridDecal.UpdateGridDataRendering();
				mIsDecalDirty = false;
			}
		}
	}

	if (mEffectManager != none )
	{
		mEffectManager.Update();
	}
}

function AddParticleSystemToMonitorList( ParticleSystemComponent newParticle )
{
	mParticleList.AddItem( newParticle );
}

function ClearParticles()
{
	local ParticleSystemComponent paquito;
	foreach mParticleList( paquito )
	{
		paquito.DeactivateSystem();
	}
}

// detects the collision of the mouse cursor with the cells and update their state (selected and mouseover)
simulated protected function UpdateHoverEffects()
{
	local H7CombatMapCell hitCell;
	local H7CombatMapCell trueHitCell;
	local array<H7CombatMapCell> hitCells;
	local H7PlayerController playerController;
	local H7IEffectTargetable target;
	local Vector hitLocation;
	local bool gotCell;

	//`log_dui("UpdateHoverEffects");
	playerController = class'H7PlayerController'.static.GetPlayerController();
	mCanForceUpdateGrid = true;

	if( !playerController.IsMouseOverHUD() && class'H7CombatController'.static.GetInstance() != none )
	{
		if( playerController.IsInputAllowed() )
		{
			if( !( mCombatController.GetActiveUnit() != none && mCombatController.GetActiveUnit().GetPlayer().IsControlledByAI() ) )
			{
				mCanForceUpdateGrid = false;
				gotCell = GetMouseOverCell( hitCell, hitCells, hitLocation,, trueHitCell, target );

				mCurrentHoverTarget = target;

				if( gotCell )
				{
					// TODO: this is check is not working anymore, if enabled the attack cells are not updated correctly. Investigate why not
					//if( hitCell != mCurrentMouseOverCell || (trueHitCell != none && trueHitCell != mCurrentMouseOverTrueCell) )
					//{
						UpdateReachableAltCells( target );
						UpdateGridState( hitCell, hitCells, hitLocation, trueHitCell );
						if( mCombatController.GetActiveUnit() != none && 
							mCombatController.GetActiveUnit().GetAbilityManager().GetPreparedAbility() != none && 
							mCombatController.GetActiveUnit().GetAbilityManager().GetPreparedAbility().GetTargetType() != TARGET_TSUNAMI )
						{
							mCombatController.DestroyAllStackGhosts();
						}
					//}
				}
				else 
				{
					ClearMouseOverCells();
					mPathPreviewer.HidePreview();
				}
				mCurrentMouseOverCell = hitCell;
				mCurrentMouseOverTrueCell = trueHitCell;
			}
		}	

		mCombatController.GetCursor().UpdateCursor( trueHitCell != none ? trueHitCell : hitCell, hitLocation );
	}
}

simulated function ForceGridStateUpdate()
{
	local H7CombatMapCell hitCell;
	local array<H7CombatMapCell> hitCells;
	local Vector hitLocation;

	//if( !mCanForceUpdateGrid ) { return; }

	if( GetMouseOverCell( hitCell, hitCells, hitLocation ) )
	{
		UpdateGridState( hitCell, hitCells, hitLocation );
	}
}

// overwrited in the states
simulated protected function UpdateReachableAltCells(H7IEffectTargetable target){}
simulated function DoCurrentUnitAction(){}
simulated function TacticsPickUnit( H7CreatureStack creatureStack ){}
simulated function TacticsReleaseUnit(optional bool releasedOnBar){}
simulated function TacticsStoreUnitOnBar(){}
simulated protected function UpdateGridState(H7CombatMapCell hitCell, array<H7CombatMapCell> hitCells, vector hitLocation, optional H7CombatMapCell trueHitCell ){}

simulated function InitTraceBuffer()
{
	local LocalPlayer localPlayer;
	local Vector hitNormal, hitLocation;
	local Vector worldOrigin, worldDirection;
	local Vector2D viewportSize, relativeScreenPos;
	local Actor actorIterator;

	// check if already initialized this frame
	if( mTraceBufferActors.length > 0 )
	{
		return;
	}

	localPlayer = class'H7PlayerController'.static.GetLocalPlayer();
	
	if( localPlayer != None && localPlayer.ViewportClient != None )
	{
		// Get the deprojection coordinates from the screen location
		localPlayer.ViewportClient.GetViewportSize( viewportSize );
		relativeScreenPos = localPlayer.ViewportClient.GetMousePosition();
		relativeScreenPos.x /= viewportSize.x;
		relativeScreenPos.y /= viewportSize.y;
		localPlayer.DeProject( relativeScreenPos, worldOrigin, worldDirection );

		foreach TraceActors( class'Actor', actorIterator, hitLocation, hitNormal, worldOrigin + worldDirection * 16384.f, worldOrigin )
		{
			mTraceBufferActors.AddItem(actorIterator);
			mTraceBufferLocations.AddItem( hitLocation );
		}
	}
}

simulated function Actor GetMouseHitActorAndLocation( out Vector hitLocation )
{
	local int i;
	local Actor actorIterator;

	InitTraceBuffer();

	foreach mTraceBufferActors( actorIterator, i )
	{
		hitLocation = mTraceBufferLocations[i];
		return actorIterator;
	}
		
	return none;
}

simulated function Actor GetMouseHitActorAndLocationIgnoringClass(out Vector hitLocation, optional name classTypeNameToIgnore)
{
	local int i;
	local Actor actorIterator;

	InitTraceBuffer();

	foreach mTraceBufferActors( actorIterator, i )
	{
		if( !actorIterator.IsA( classTypeNameToIgnore ) )
		{
			hitLocation = mTraceBufferLocations[i];
			return actorIterator;
		}
	}
		
	return none;
}

simulated function Actor GetMouseHitActor(name classTypeName)
{
	local Actor actorIterator;

	InitTraceBuffer();

	foreach mTraceBufferActors( actorIterator )
	{
		if( actorIterator.IsA( classTypeName ) )
		{
			return actorIterator;
		}
	}
		
	return none;
}

simulated function array<H7IEffectTargetable> GetTargetsFromCombatCells( array<H7CombatMapCell> cells )
{
	local array<H7IEffectTargetable> targets;
	local H7CombatMapCell currentCell;
	local H7IEffectTargetable target;
	//local Vector hitLocation;
	
	target = mCurrentMouseOverCell;// GetMouseOverTarget( hitLocation );
	if( target != none && targets.Find( target ) == INDEX_NONE )
	{
		if( H7CombatMapCell( target ).GetUnit() != none ) target = H7CombatMapCell( target ).GetUnit();

		targets.AddItem( target );
	}
	foreach cells( currentCell )
	{
		target = currentCell.GetUnit();
		if( target != none && targets.Find( target ) == INDEX_NONE)
		{
			targets.AddItem( target );
		}
	}

	return targets;
}

// this is in fact "hover" over a cells for move-preview, and now also targeting preview
// hitCell = MousePos and hitCells = nextCreaturePosition
simulated protected function DisplayHoverEffect(H7CombatMapCell hitCell, array<H7CombatMapCell> hitCells)
{
	local int creatureSize,i;
	local H7BaseAbility ability;
	local array<H7CombatMapCell> aoeCells, cellsToRemove;
	local H7CombatMapCell currentCell;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable currentTarget;	
	local array<int> indeces;
	local array<IntPoint> tPoints;

	//`log_dui("DisplayHoverEffect" @ hitCell @ hitCells.Length @ "activeUnit=" $ mCombatController.GetActiveUnit());

	if( mCombatController.GetActiveUnit() != none && mCombatController.GetActiveUnit().GetPlayer().GetPlayerType() == PLAYER_AI ) return;

	if( mCombatController.GetActiveUnit() != none )
	{
		ability = mCombatController.GetActiveUnit().GetPreparedAbility();
	
		if( ability != none ) // showing target of ability (casting)
		{
			if( !ability.IsCasting() && mCombatController.AllAnimationsDone() )
			{
				if( ability.GetTargetType() == TARGET_CUSTOM_SHAPE && ( !mCombatController.GetActiveUnit().IsDefaultAttackActive() || hitCell.GetUnit() != none ) )
				{
					mGrid.GetCellsFromShape( hitCell, ability.GetShape(), aoeCells );
					UpdateMouseOverCells( hitCell, aoeCells, -1,,false );
				}
				else if( ability.GetTargetType() == TARGET_AREA && ( !mCombatController.GetActiveUnit().IsDefaultAttackActive() || hitCell.GetUnit() != none ) )
				{
					// select the new mouse over cells
					mGrid.GetCellsFromDimensions( hitCell, ability.GetTargetArea(),aoeCells,, ability.IsAreaFilled() );
					UpdateMouseOverCells( hitCell, aoeCells, -1,,false );
				}
				else if( ability.GetTargetType() == TARGET_ELLIPSE && ( !mCombatController.GetActiveUnit().IsDefaultAttackActive() ||hitCell.GetUnit() != none ) )
				{
					mGrid.GetCellsOnEllipse( hitCell, ability.GetTargetArea(), aoeCells );
					UpdateMouseOverCells( hitCell, aoeCells, -1,,false );
				}
				else if( ability.GetTargetType() == TARGET_LINE && (!mCombatController.GetActiveUnit().IsDefaultAttackActive() || hitCell.GetUnit() != none) )
				{
					GetLineCellsIntersectingGrid( aoeCells, mCombatController.GetActiveUnit().GetGridPosition() , hitCell.GetCellPosition() );
					// remove ourself from the AoE cells
					foreach aoeCells( currentCell )
					{
						if( currentCell.GetUnit() == mCombatController.GetActiveUnit() )
						{
							cellsToRemove.AddItem( currentCell );
						}
					}
					foreach cellsToRemove( currentCell )
					{
						aoeCells.RemoveItem( currentCell );
					}
					UpdateMouseOverCells( hitCell, aoeCells, -1 );
				}
				else if(ability.GetTargetType() == TARGET_SUNBURST)
				{
					GetCellsForSunburst( aoeCells, hitCell.GetCellPosition(), indeces, tPoints );
					UpdateMouseOverCells( hitCell, aoeCells);
				}
				else if(ability.GetTargetType() == TARGET_TSUNAMI )
				{
					GetCellsForTsunami( aoeCells, hitCell.GetCellPosition(), ability.GetTsunamiRows() );
					UpdateMouseOverCells( hitCell, aoeCells );
				}
				else if( ability.GetTargetType() == TARGET_DOUBLE_LINE )
				{
					creatureSize = int(mSelectedCreatureSize) + 1;

					GetDoubleLineCellsIntersectingGrid( aoeCells, H7CreatureStack(mCombatController.GetActiveUnit()), hitcell);
					targets = GetTargetsFromCombatCells( aoeCells );

					if( aoeCells.Length == 0 || targets.Length == 0 )
					{
						UpdateMouseOverCells( hitCell, hitCells, creatureSize , mGrid.GetTargetMoveCell( hitCells ) );
						return;
					}

					for( i=targets.Length-1; i>=0;i--)
					{
						if(!ability.CanCastOnTargetActor(targets[i]))
						{
							targets.Remove(i,1);
						}
					}

					mCombatController.GetActiveUnit().GetPreparedAbility().SetTargets( targets );
				
					// this case its an none affected target so mark the cell as selected 
					foreach aoeCells( currentCell) 
					{
						if( !currentCell.HasUnit() )
							continue;

						if( !ability.CanCastOnTargetActor( currentCell.GetUnit() ) )
						{
 						    currentCell.SetForceHighlight( true );
						}
					}
					
					// Add cells to target if there are partial included in the line ( Ex. 2X2 )
					foreach targets( currentTarget )
					{

						if( H7CreatureStack( currentTarget ) != none || H7WarUnit( currentTarget ) != none )
						{
							currentCell = mGrid.GetCellByIntPoint( H7Unit( currentTarget ).GetGridPosition());

							if( currentCell.GetSelectionType() != SELECTED_ENEMY )
							{
								currentCell.SetForceEnemyHightlight( true );
							}

							if( aoeCells.Find( mGrid.GetCellByIntPoint( H7Unit( currentTarget ).GetGridPosition())) == INDEX_NONE  )
							{
								aoeCells.AddItem( mGrid.GetCellByIntPoint( H7Unit( currentTarget ).GetGridPosition() ) );
							}
						}
					}
					
					UpdateMouseOverCells( hitCell, aoeCells , creatureSize, mGrid.GetTargetMoveCell( hitCells ), true, hitCells );
				}
				else if( ability.GetTargetType() == TARGET_SWEEP )
				{
					creatureSize = int(mSelectedCreatureSize) + 1;

					GetAdjacentCellsInCone( aoeCells, H7CreatureStack(mCombatController.GetActiveUnit()), hitcell, 45.0f);
					targets = GetTargetsFromCombatCells( aoeCells );

					mCombatController.GetActiveUnit().GetPreparedAbility().SetTargets( targets );
				
					aoeCells.Length = 0;
					foreach targets( currentTarget )
					{
						if( H7CreatureStack( currentTarget ) != none || H7WarUnit( currentTarget ) != none )
						{
							aoeCells.AddItem( mGrid.GetCellByIntPoint( H7Unit( currentTarget ).GetGridPosition() ) );
						}
					}

					foreach hitCells( currentCell )
					{
						if( aoeCells.Find(currentCell) == INDEX_NONE )
						{
							aoeCells.AddItem( currentCell );
						}
					}
	
					UpdateMouseOverCells( hitCell, aoeCells, creatureSize , mGrid.GetTargetMoveCell( hitCells ) );
				}
				else if( ability.GetTargetType() == TARGET_CONE )
				{
					creatureSize = int(mSelectedCreatureSize) + 1;
				
					GetCellsInCone( aoeCells, H7CreatureStack(mCombatController.GetActiveUnit()), hitcell, ability, true );
					targets = GetTargetsFromCombatCells( aoeCells );

					if( aoeCells.Length == 0 || targets.Length == 0 )
					{
						UpdateMouseOverCells( hitCell, hitCells, creatureSize , mGrid.GetTargetMoveCell( hitCells ) );
						return;
					}


					for( i=targets.Length-1; i>=0;i--)
					{
						if(!ability.CanCastOnTargetActor(targets[i]))
						{
							targets.Remove(i,1);
						}
					}

					mCombatController.GetActiveUnit().GetPreparedAbility().SetTargets( targets );
				
					// this case its an none affected target so mark the cell as selected 
					foreach aoeCells( currentCell) 
					{
						if( !currentCell.HasUnit() )
							continue;

						if( !ability.CanCastOnTargetActor( currentCell.GetUnit() ) )
						{
							//`Log( "CONE : " @ currentCell.GetGridPosition().X @ "," @ currentCell.GetGridPosition().Y );
 						    currentCell.SetForceHighlight( true );
						}
					}
					
					// Add cells to target if there are partial included in the cone ( Ex. 2X2 )
					foreach targets( currentTarget )
					{

						if( H7CreatureStack( currentTarget ) != none || H7WarUnit( currentTarget ) != none )
						{
							currentCell = mGrid.GetCellByIntPoint( H7Unit( currentTarget ).GetGridPosition());

							if( currentCell.GetSelectionType() != SELECTED_ENEMY )
							{
								currentCell.SetForceEnemyHightlight( true );
								//currentCell.SetAbilityHighlight( true );
							}

							if( aoeCells.Find( mGrid.GetCellByIntPoint( H7Unit( currentTarget ).GetGridPosition())) == INDEX_NONE  )
							{
								aoeCells.AddItem( mGrid.GetCellByIntPoint( H7Unit( currentTarget ).GetGridPosition() ) );
							}
						}
					}
					
					UpdateMouseOverCells( hitCell, aoeCells , creatureSize, mGrid.GetTargetMoveCell( hitCells ), true, hitCells );
				}
				else
				{
					 // showing target of unit (moving)
					creatureSize = int(mSelectedCreatureSize) + 1;
					UpdateMouseOverCells( hitCell, hitCells, creatureSize , mGrid.GetTargetMoveCell( hitCells ) );
				}
			}
		}
		else if (mCombatController.GetActiveUnit().GetMoveCount() > 0 ) // mobile shooter 
		{
			// select the new mouse over cells
			creatureSize = int(mSelectedCreatureSize) + 1;
			UpdateMouseOverCells( hitCell, hitCells, creatureSize,  mGrid.GetTargetMoveCell( hitCells ) );
		}
	}
	else // no active unit // showing target of unit (moving) ? and TACTICS!
	{
		// select the new mouse over cells
		creatureSize = int(mSelectedCreatureSize) + 1;
		UpdateMouseOverCells( hitCell, hitCells, creatureSize,  mGrid.GetTargetMoveCell( hitCells ) );
	}
}

simulated protected function DisplayHeroHoverEffect( H7CombatMapCell hitCell, array<H7CombatMapCell> hitCells, vector hitLocation, optional H7CombatMapCell trueHitCell )
{
	local array<H7CombatMapCell> aoeCells;
	local array<int> indeces;
	local array<IntPoint> tPoints;
	local H7BaseAbility ability;
	
	if( mCombatController.GetActiveUnit() != none )
	{
		ability = mCombatController.GetActiveUnit().GetPreparedAbility();
	}

	if( ability != none )
	{
		if( !ability.IsCasting()  )
		{
			if( ability.GetTargetType() == TARGET_CUSTOM_SHAPE )
			{
				mGrid.GetCellsFromShape( trueHitCell != none ? trueHitCell : hitCell, ability.GetShape(), aoeCells );
				UpdateMouseOverCells( trueHitCell != none ? trueHitCell : hitCell, aoeCells, -1,,false );
			}
			else if( ability.GetTargetType() == TARGET_AREA )
			{
				// select the new mouse over cells
				GetCombatGrid().GetCellsFromDimensions( trueHitCell != none ? trueHitCell : hitCell , ability.GetTargetArea(),aoeCells,, ability.IsAreaFilled() );
				UpdateMouseOverCells( trueHitCell != none ? trueHitCell : hitCell, aoeCells, -1,,false );
			}
			else if( ability.GetTargetType() == TARGET_ELLIPSE )
			{
				GetCombatGrid().GetCellsOnEllipse( hitCell, ability.GetTargetArea(), aoeCells );
				UpdateMouseOverCells( hitCell, aoeCells, -1,,false );
			}
			else if( ability.GetTargetType() == TARGET_SUNBURST )
			{
				GetCellsForSunburst( aoeCells, hitCell.GetCellPosition(), indeces, tPoints);
				//foreach aoeCells( cell )
				//{
				//	if( cell.GetUnit() != none && ability.TargetIsImmuneToAllExecutingEffects( cell.GetUnit()) )
				//	{
				//		removeCells.AddItem(cell);
				//	}
				//}

				//foreach removeCells( cell )
				//{
				//	aoeCells.RemoveItem( cell );
				//}
				UpdateMouseOverCells( hitCell, aoeCells, -1,,true );
			}
			else if( ability.GetTargetType() == TARGET_TSUNAMI )
			{
				GetCellsForTsunami( aoeCells, hitCell.GetCellPosition(), ability.GetTsunamiRows() );
				UpdateMouseOverCells( hitCell, aoeCells, -1,,true); 
			}
			else if( ability.GetTargetType() == TARGET_LINE || ability.GetTargetType() == TARGET_DOUBLE_LINE )
			{
				// any line spell logic should go here
			}
			else
			{
				DisplayHoverEffect(hitCell, hitCells);
			}
		}
	}
	else
	{
		DisplayHoverEffect(hitCell, hitCells);
	}
}

simulated function bool IsTargetInMeleeRange( H7Unit active, H7IEffectTargetable target )
{
	return mGrid.AreInMeleeRange( active, target );
}

// WARNING this is called every frame TODO investigate
// check if in melee range by getting attackpositions and checking if there is one green(in range)
simulated function bool IsUnitIsInMoveRange( H7Unit active, H7Unit target )
{
	local array<H7CombatMapCell> attackPositions;
	
	// NEW WAY // TODO check performance of new way:
	mGrid.GetAllAttackPositionsAgainst( target, active, attackPositions );
	return attackPositions.Length > 0;
	
	// OLD WAY
	//return mGrid.IsUnitIsInMoveRange( H7CreatureStack(active), H7CreatureStack(target) );
}

simulated function bool IsUnitInFarRange( H7Unit active, H7Unit target )
{
	return !mGrid.UnitsInHalfRange( active, target );
}

// get the currently glowing cells of future/projected attack position
simulated function array<H7CombatMapCell> GetCurrentAttackPosition()
{
	return mCurrentAttackPosition;
}

simulated function ClearCurrentAttackPosition()
{
	mCurrentAttackPosition.Length = 0;
}
// hitCell: The cell that is actually hit by the cursor (might be modified after detecting)
// hitCells: Group of cells that are affected by the hitCell.
// trueHitCell: the cell we actually hitted (never modified after detecting)
// returns false if the mouse is not over a cell
// called every frame
simulated function protected bool GetMouseOverCell( out H7CombatMapCell hitCell, out array<H7CombatMapCell> hitCells, optional out Vector hitLocation, optional out EDirection hitDirection, out optional H7CombatMapCell trueHitCell, out optional H7IEffectTargetable target )
{
	local Actor hitActor;
	local array<H7CombatMapCell> attackPosition;
	local H7Unit unit;
	local bool isDead;

	hitCells.Length = 0; // clear array
	mCurrentAttackPosition.Length = 0;

	target = GetMouseOverTarget( hitLocation );
	if( H7CombatMapCell( target ) != none )
	{
		unit = H7CombatMapCell( target ).GetUnit();
		trueHitCell = H7CombatMapCell( target );
	}
	else
	{
		unit = H7Unit( target );
		trueHitCell = GetCell( hitLocation );
	}
	isDead = true;
	
	if( unit != none )
	{
		isDead = unit.IsDead();
	}
	else if( H7CombatObstacleObject( target ) != none )
	{
		isDead = H7CombatObstacleObject( target ).GetHitpoints() <= 0;
	}


	// the defender should be able to move to the cells of the gate
	if( target != none && H7CombatMapGate(target) != none && !class'H7CombatController'.static.GetInstance().GetActiveUnit().IsAttacker() )
	{
		target = none;
	}

	// check for living creatures and obstacles
	if( target != none && !isDead && IsInState( 'Combat' ) )
	{
		//hitCell = mGrid.GetCellByIntPoint( target.GetGridPosition() );
		hitCell = trueHitCell;
		if( hitCell != none )
		{
			
			hitCells = hitCell.GetMergedCells();
			hitDirection = mCombatController.GetCursor().GetCurrentDirection();
		
			if( mSelectedStack != none )
			{
				// we want to get the hitlocation to the cell, not to the unit
				if( unit != none )
				{
					GetMouseHitActorAndLocationIgnoringClass( hitLocation, 'H7Unit' );
				}
				else if( H7CombatObstacleObject( target ) != none )
				{
					GetMouseHitActorAndLocationIgnoringClass( hitLocation, 'H7CombatObstacleObject' );
				}

				// calculate attack position
				mGrid.GetAttackPosition( hitCell, hitLocation, mSelectedStack, attackPosition );
			
				mCurrentAttackPosition = attackPosition;

				if(hitCell == mCurrentMouseOverCell && mSelectedStack == mPreviousAttacker)
				{
					if(mCouldAttackBefore) 
					{
						hitCells = attackPosition;
					}

					return true;
				}

				mCouldAttackBefore = mSelectedStack.CanAttack();
				if( attackPosition.Length > 0 && mCouldAttackBefore )
				{
					hitCells = attackPosition;

				}
				mPreviousAttacker = mSelectedStack;
			}

			return true;
		}
	}
	else
	{
		hitActor = GetMouseHitActorAndLocation( hitLocation );
		
		if( hitActor != none )
		{
			hitCell = GetCell( hitLocation );
			
			if( hitCell != none )
			{
				mGrid.GetHitCells( mSelectedCreatureSize, hitCell, hitLocation, true, hitCells );
				//mCurrentMouseOverCell = hitCell;
				return true;
			}
			
		}
	}

	return false;
}

native simulated function GetMovementPreviewCells( out array<H7CombatMapCell> outCells );

simulated function bool DoAbility( H7CombatMapCell hitCell, optional EDirection direction = EDirection_MAX, optional H7CombatMapCell trueHitCell, optional array<H7CombatMapCell> hitCells )
{
	local array<H7CombatMapCell> attackPositions;
	local H7CombatMapCell targetCell;
	local ECommandTag preferredCommandTag;
	local bool canUseAbility, canCast, isHeal;

	preferredCommandTag = ACTION_MAX;
	if( !mCombatController.GetActiveUnit().CanAttack() )
	{ 
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_ATTACKS_LEFT","H7FCT"));  
		return false; 
	}

	canCast = mCombatController.GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor( hitCell.GetTargetable() );
	if( mCombatController.GetActiveUnit().IsDefaultAttackActive() || ( mCombatController.GetActiveUnit().GetPreparedAbility() != none && mCombatController.GetActiveUnit().GetPreparedAbility().ShouldMoveToTarget() ) )
	{
		if( ( hitCell.GetTargetable() != none ) && canCast )
		{
			if( mCombatController.GetActiveUnit().GetEntityType() == UNIT_CREATURESTACK )
			{
				if( !mCombatController.GetActiveUnit().GetPreparedAbility().ShouldMoveToTarget() && mCombatController.CanRangeAttack( hitCell.GetTargetable() ) && !IsTargetInMeleeRange( mSelectedStack, hitCell.GetTargetable() ) )
				{
					canUseAbility = true;
				}
				else
				{
					
					mGrid.GetAllAttackPositionsAgainst( hitCell.GetTargetable(), mSelectedStack, attackPositions );
					if( attackPositions.Length > 0 && ( ShowPathPreview( attackPositions, true ) || IsTargetInMeleeRange( mSelectedStack, hitCell.GetTargetable() ) ) )
					{
						isHeal = mCombatController.GetActiveUnit().GetPreparedAbility().IsHeal();
						if( hitCells.Length > 0 )
						{
							targetCell = mGrid.GetTargetMoveCell( hitCells );
						}
						// move
						if( IsTargetInMeleeRange( mSelectedStack, hitCell.GetTargetable() ) && ( targetCell == none || targetCell != none && mSelectedStack.GetCell() == targetCell ) )
						{
							canUseAbility = true;
							preferredCommandTag = isHeal ? ACTION_ABILITY : ACTION_MELEE_ATTACK;
						}
						// attack
						else if( mGrid.CanMoveTo( attackPositions, mSelectedStack ) )
						{
							if( hitCells.Length == 0 ) hitCells = attackPositions;

							DoMovement( hitCell, hitCells, ,!isHeal );
						}
						else
						{
							class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_REACH_TARGET","H7FCT"));
							return false;
						}
					}
					else
					{
						class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_TARGET","H7FCT"));
						return false;
					}
				}
			}
			else
			{
				// hero's melee attack
				canUseAbility = true;
			}
		}
		else if( hitCell.HasObstacle() && canCast )
		{
			if( mCombatController.GetActiveUnit().GetEntityType() == UNIT_WARUNIT )
			{
				canUseAbility = true;
			}
		}
	}
	else if( canCast )
	{
		canUseAbility = true;
	}

	if( canUseAbility )
	{
		ClearMouseOverCells();
		ResetSelectedAndReachableCells();
		if( (trueHitCell != none && trueHitCell.GetTargetable() != none)								// Make sure we can use this cell
		&&  ( (trueHitCell.GetMaster() == hitCell) || (trueHitCell.GetMaster2ndLayer() == hitCell) ))	// Make sure hitCell is our master (on any layer)
		{
			mCombatController.SetActiveUnitCommand_UsePreparedAbility( trueHitCell.GetTargetable(), direction, trueHitCell, preferredCommandTag );
		}
		else
		{
			mCombatController.SetActiveUnitCommand_UsePreparedAbility( hitCell.GetTargetable(), direction,,preferredCommandTag );
		}

		
		return true;
	}
	return false;
}

simulated function bool DoAttackAI( H7CombatMapCell hitCell, optional H7CombatMapCell attackCell, optional EDirection direction=EDirection_MAX )
{
	local array<H7CombatMapCell> attackPositions;
	local bool canUseAbility, canCast, isHeal;

	if( !mCombatController.GetActiveUnit().CanAttack() )
	{ 
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_ATTACKS_LEFT","H7FCT"));  
		return false; 
	}

	attackPositions.AddItem(attackCell);

	canCast = mCombatController.GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor( hitCell.GetTargetable() );
	if( mCombatController.GetActiveUnit().IsDefaultAttackActive() || ( mCombatController.GetActiveUnit().GetPreparedAbility() != none && mCombatController.GetActiveUnit().GetPreparedAbility().ShouldMoveToTarget() ) )
	{
		if( ( hitCell.GetTargetable() != none ) && canCast )
		{
			if( mCombatController.GetActiveUnit().GetEntityType() == UNIT_CREATURESTACK )
			{
				if( !mCombatController.GetActiveUnit().GetPreparedAbility().ShouldMoveToTarget() && mCombatController.CanRangeAttack( hitCell.GetTargetable() ) && !IsTargetInMeleeRange( mSelectedStack, hitCell.GetTargetable() ) )
				{
					canUseAbility = true;
				}
				else
				{
					
//					mGrid.GetAllAttackPositionsAgainst( hitCell.GetTargetable(), mSelectedStack, attackPositions );
					if( attackPositions.Length > 0 && ( ShowPathPreview( attackPositions, true ) || IsTargetInMeleeRange( mSelectedStack, hitCell.GetTargetable() ) ) )
					{
						// move
						if( IsTargetInMeleeRange( mSelectedStack, hitCell.GetTargetable() ) && attackPositions[0]==mSelectedStack.GetCell() )
						{
							canUseAbility = true;
						}
						// attack
						else if( mGrid.CanMoveTo( attackPositions, mSelectedStack ) )
						{
							isHeal = mCombatController.GetActiveUnit().GetPreparedAbility().IsHeal();
							DoMovement( mGrid.GetCellByIntPoint( hitCell.GetTargetable().GetGridPosition() ), attackPositions,, !isHeal );
						}
						else
						{
							class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_REACH_TARGET","H7FCT"));
							return false;
						}
					}
					else
					{
						class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_TARGET","H7FCT"));
						return false;
					}
				}
			}
			else
			{
				// hero's melee attack
				canUseAbility = true;
			}
		}
		else if( hitCell.HasObstacle() && canCast )
		{
			if( mCombatController.GetActiveUnit().GetEntityType() == UNIT_WARUNIT )
			{
				canUseAbility = true;
			}
		}
	}
	else if( canCast )
	{
		canUseAbility = true;
	}

	if( canUseAbility )
	{
		ClearMouseOverCells();
		ResetSelectedAndReachableCells();
		mCombatController.SetActiveUnitCommand_UsePreparedAbility( hitCell.GetTargetable(), direction );
		return true;
	}
	return false;
}

// acitvates and deactivates the HUD Unit Over effects and cursor
// UnitOut || MouseOver -> targetUnit == none -> deactivate
// UnitOver             -> targetUnit == unit -> activate
// called once per event
simulated function ShowHUDUnitOverEffects( H7Unit targetUnit ) 
{
	local H7CombatMapCell pathCell;
	local array<H7CombatMapCell> attackPositions, path, hitCells;

	ClearMouseOverCells();
	mPathPreviewer.HidePreview();
		
	if( targetUnit != none ) // activate the unitover effects (if possible)
	{
		// cursor has it's own logic handling checking and can always be called
		if( targetUnit.GetEntityType() == UNIT_CREATURESTACK )
		{
			mCombatController.GetCursor().ShowUnitOverCursor( targetUnit );

			if( mSelectedStack != none // if it is a hero we need no path
				&& targetUnit.IsAttacker() != mSelectedStack.IsAttacker() 
				&& !mCombatController.CanRangeAttack( targetUnit ) )
			{
				mGrid.GetAllAttackPositionsAgainst( targetUnit, mSelectedStack, attackPositions );

				if( attackPositions.Length > 0 && ShowPathPreview( attackPositions, true ) )
				{
					mSelectedStack.GetPathfinder().GetShortestPath( attackPositions, path );
					if( path.Length > 1 )
					{
						pathCell = path[path.Length - 1];
						pathCell.GetCellsHitByCellSize( mSelectedStack.GetUnitBaseSize(), hitCells );
						UpdateMouseOverCells( pathCell, hitCells, mSelectedStack.GetUnitBaseSizeInt(), pathCell );
						
					}
				}
			}
		}
	}
}

simulated function bool ShowPathPreview( array<H7CombatMapCell> hitCells, optional bool takeShortest = false )
{
	local H7PlayerController playerController;
	local array<H7CombatMapCell> path;
	local bool foundPath;

	playerController = class'H7PlayerController'.static.GetPlayerController();

	if( takeShortest )
	{
		foundPath =	mSelectedStack.GetPathfinder().GetShortestPath( hitCells, path );
	}
	else
	{
		foundPath =	mSelectedStack.GetPathfinder().GetPath( mGrid.GetTargetMoveCell( hitCells ).GetCellPosition(), path );
	}

	if( foundPath && ( !mCombatController.GetActiveUnit().HasPreparedAbility() || mCombatController.GetActiveUnit().GetPreparedAbility().ShouldMoveToTarget() || mCombatController.GetActiveUnit().IsDefaultAttackActive() ) )
	{
		if( playerController.IsInputAllowed() || takeShortest )
		{
			if( !mSelectedStack.CanTeleport() ) 
			{
				if( mSelectedStack.GetPlayer().GetPlayerType() != PLAYER_AI && mSelectedStack.GetMovementType() != CMOVEMENT_JUMP )
				{
					mPathPreviewer.ShowPreview (path, mSelectedStack.GetCreature().GetBaseSize() );
					mSelectedStack.SetLastWalkedPath( path );
				}
			}
		}
	}

	return foundPath;
}

simulated protected function DoMovement( H7CombatMapCell hitCell, array<H7CombatMapCell> hitCells, optional bool takeShortest = false, optional bool isRealAttack = true )
{
	local array<H7CombatMapCell> path;
	local bool foundPath;

	ClearMouseOverCells();
	ResetSelectedAndReachableCells();

	if( takeShortest )
	{
		foundPath =	mSelectedStack.GetPathfinder().GetShortestPath( hitCells, path );
	}
	else
	{
		foundPath =	mSelectedStack.GetPathfinder().GetPath( mGrid.GetTargetMoveCell( hitCells ).GetCellPosition(), path );
	}
			
	if( foundPath )
	{
		if( mGrid.CanMoveTo( hitCells, mSelectedStack ) )
		{
			StartUnitMovement( hitCell, hitCells, path, isRealAttack );
		}
	}
}

// the only way to change/set mMouseOverCells
// highlights cells and stacks and other stuff
simulated protected function UpdateMouseOverCells( H7CombatMapCell hitCell, array<H7CombatMapCell> newHighlightCells, optional int isMouseOverMaster = 0, optional H7CombatMapCell masterCell = none, optional bool highlightTargetCell = true, optional array<H7CombatMapCell> casterCells)
{
	local H7CombatMapCell cell;
	local int i;
	local bool isAnythingChanged;
	local array<H7CreatureStack> stacksToHighlight,stacksAreHighlighted;
	local array<H7CombatObstacleObject> obstaclesToHighlight,obstaclesAreHighlighted;
	local array<H7WarUnit> warUnitsToHighlight,warUnitsAreHighlighted;
	local H7IEventManagingObject eventManageable;
	local H7CreatureStack stack;
	local array<H7CombatMapCell> cells;

	
	if( IsInState('Combat') )
	{ 
		if( casterCells.Length > 0  )
		{
			foreach casterCells(cell)
			{
				 newHighlightCells.AddItem( cell );
			}			
		}
	}

	// add the hitcell only on combat mode
	if( IsInState( 'Combat' ) && highlightTargetCell )
	{
		newHighlightCells.AddItem( hitCell );
		//Handle teleport logic here. We highlight mouse over cells in accordance to the creature being teleported
		if( class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() != INDEX_NONE )
		{
			eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() );
			stack = H7CreatureStack( eventManageable );
			if( stack != none )
			{
				 if( stack.GetUnitBaseSize() == CELLSIZE_2x2 )
				 {
					hitCell.GetCellsHitByCellSize( stack.GetUnitBaseSize(), cells );

					newHighlightCells.Length = 0;
					if( CheckIfCellIsReachable( hitCell, stack.GetUnitBaseSize() ) )
					{
						isMouseOverMaster = stack.GetUnitBaseSizeInt();
						masterCell = hitCell;
						for( i = 0; i < cells.Length; ++i )
						{
							newHighlightCells.AddItem( cells[ i ] );
						}
					}
				 }
			}
		}
	}
	else if( IsInState( 'Tactics' )) // and in tactics?
	{
		if(hitCell == none)
		{
			//`log_dui("hitCell is none");
		}
		else
		{
			if(mReachableCells.Find(hitCell) != INDEX_NONE) // the currently hovered cell is reachable(inside the deploy zone)
			{
				newHighlightCells.AddItem( hitCell );
			}
			else
			{
				// don't highlight it, it's outside deploy area
				//`log_dui("outside deploy zone" @ hitCell.GetGridPosition().X @ hitCell.GetGridPosition().Y);
			}
		}
	}

	//`log_dui("  UpdateMouseOverCells hitCell="$hitCell @ "newHighlightCells="$newHighlightCells.Length);


	isAnythingChanged = false;

	//	Check if there is a difference between old and new highlighted cells
	if( mMouseOverCells.Length == newHighlightCells.Length )
	{
		for( i = 0; i < mMouseOverCells.Length; ++i )
		{
			if( mMouseOverCells[i] != none && newHighlightCells[i] != none )
			{
				if( mMouseOverCells[i].GetCellPosition() != newHighlightCells[i].GetCellPosition() )
				{
					isAnythingChanged = true;
					break;
				}
			}
		}
	}
	else
	{
		isAnythingChanged = true;
	}

	UpdateAbilityHighlightCells();

	if( isAnythingChanged )
	{
		if( mSelectedStack != none )
		{
			mSelectedStack.GetBuffManager().ResetSimDurations(); // TODO : Maybe Charge ???  please check this sounds crazy
		}

		// get a list of creatures that should be highlighed according to the current newest data we got:
		for( i = 0; i < newHighlightCells.Length; ++i )
		{
			if( newHighlightCells[i].HasCreatureStack() )
			{
				if( !newHighlightCells[i].GetForceHightlight())
					stacksToHighlight.AddItem( newHighlightCells[i].GetCreatureStack() );
			}
			if( newHighlightCells[i].HasObstacle() )
			{
				obstaclesToHighlight.AddItem( newHighlightCells[i].GetObstacle() );
			}
			if( newHighlightCells[i].HasWarfareUnit() )
			{
				if( !newHighlightCells[i].GetForceHightlight())
					warUnitsToHighlight.AddItem( newHighlightCells[i].GetWarfareUnit() );
			}
		}

		// get a list of creatures that are currently highlighted (we assume, bc their cells are in the old state array)
		for( i = 0; i < mMouseOverCells.Length; ++i )
		{
			if( mMouseOverCells[i].HasCreatureStack() )
			{
				stacksAreHighlighted.AddItem( mMouseOverCells[i].GetCreatureStack() );
			}
			if(mMouseOverCells[i].HasObstacle() )
			{
				obstaclesAreHighlighted.AddItem( mMouseOverCells[i].GetObstacle() );
			}
			if(mMouseOverCells[i].HasWarfareUnit() )
			{
				warUnitsAreHighlighted.AddItem( mMouseOverCells[i].GetWarfareUnit() );
			}
		}

		// update Buff events if melee attack
		if( hitCell.HasUnit() && mSelectedStack != none && hitCell.GetUnit() != mSelectedStack )
		{
			for( i = 0; i < newHighlightCells.Length; ++i )
			{
				if( !newHighlightCells[i].HasUnit() ) 
				{
					mSelectedStack.GetBuffManager().UpdateBuffEvents( ON_MOVE, true );
					mSelectedStack.GetBuffManager().UpdateBuffEvents( ON_MOVE_ATTACK_START, true );
					break;
				}
			}
		}
		
		//	Clear old cells
		foreach mMouseOverCells( cell ) 
		{
			if( newHighlightCells.Find( cell ) == INDEX_NONE ) 
			{
				cell.SetForceEnemyHightlight(false);
				cell.SetForceHighlight( false );
			}

			cell.SetMouseOver( false );
						
			if( cell.HasCreatureStack() )
			{
				// only dehighlight if not in ToHighlight
				if( stacksToHighlight.Find( cell.GetCreatureStack() ) == INDEX_NONE )
				{
					cell.GetCreatureStack().DehighlightStack();
				}
			}
			else if( cell.HasObstacle() )
			{
				if( obstaclesToHighlight.Find(cell.GetObstacle()) == INDEX_NONE )
				{
					cell.GetObstacle().DehighlightObstacle();
				}
			}
			else if( cell.HasWarfareUnit() )
			{
				if( warUnitsToHighlight.Find(cell.GetWarfareUnit()) == INDEX_NONE )
				{
					cell.GetWarfareUnit().DeHighlightWarfareUnit();
				}
			}
		}

		//	Highlight new cells
		foreach newHighlightCells( cell ) 
		{
		
			// skip cell highlight during tactics if there is no unit on the cursor
			//`log_dui("highlight cell" @ mCombatController.IsInTacticsPhase() @ mSelectedStack);
			if(mSelectedStack == none && mCombatController.IsInTacticsPhase() ) continue; //tactics phase needs to continue to highlight placements
			
			// cone targeting
			if( casterCells.Length > 0 && casterCells.Find( cell ) == INDEX_NONE ) 
			{
				cell.SetMouseOver( true, -1 );
			}
			else
			{
				// show movement-highlight
				if( masterCell == none )
				{
					cell.SetMouseOver( true, isMouseOverMaster );
				}
				else
				{
					if( cell == masterCell )
					{
						cell.SetMouseOver( true, isMouseOverMaster, masterCell );
					}
					else
					{
						cell.SetMouseOver( true, isMouseOverMaster, masterCell );
					}
				}
			}
		}
	
		mMouseOverCells = newHighlightCells;	//	Remember highlighted cells
	}

	//`log_dui("Highlight stacks on cells:" @ newHighlightCells.Length);

	//	Highlight creature stack each frame so the aura mesh is shown when the stack enters its idle state
	foreach newHighlightCells( cell ) 
	{		
		if( cell.HasCreatureStack() )
		{
			// only highlight if was not in areHighlight
			if( stacksAreHighlighted.Find(cell.GetCreatureStack()) == INDEX_NONE )
			{
				if( !cell.GetForceHightlight() ) 
					cell.GetCreatureStack().HighlightStack();
			}
		}
		else if( cell.HasObstacle() )
		{
			if( obstaclesAreHighlighted.Find(cell.GetObstacle()) == INDEX_NONE )
			{
				cell.GetObstacle().HighlightObstacle();
			}
		}
		else if( cell.HasWarfareUnit() )
		{
			if( warUnitsAreHighlighted.Find(cell.GetWarfareUnit()) == INDEX_NONE )
			{
				cell.GetWarfareUnit().HighlightWarfareUnit();
			}
		}
	}
}

simulated protected function UpdateAbilityHighlightCells()
{
	local int i;

	for( i = 0; i < mAbilityHighlightCells.Length; ++i )
	{
		if( mNewAbilityHighlightCells.Find( mAbilityHighlightCells[i] ) == INDEX_NONE )
		{
			mAbilityHighlightCells[i].SetAbilityHighlight( false );
		}
	}

	mAbilityHighlightCells.Length = 0;
	mAbilityHighlightCells.Add( mNewAbilityHighlightCells.Length );

	for( i = 0; i < mNewAbilityHighlightCells.Length; ++i )
	{
		mAbilityHighlightCells[i] = mNewAbilityHighlightCells[i];
		if( !mAbilityHighlightCells[i].IsAbilityHighlight() )
		{
			mAbilityHighlightCells[i].SetAbilityHighlight( true );
		}
	}

	mNewAbilityHighlightCells.Length = 0;
}

//	Clears all mouse over cells. Do NOT call this per frame
simulated protected function ClearMouseOverCells()
{
	local H7CombatMapCell cell;

	if( mMouseOverCells.Length != 0 )
	{
		foreach mMouseOverCells( cell ) 
		{
			cell.SetMouseOver( false );
						
			if( cell.HasCreatureStack() )
			{
				cell.GetCreatureStack().DehighlightStack();
			}
		}
	
		mMouseOverCells.Remove( 0, mMouseOverCells.Length );
	}
}

// either by moving or defending or attacking
simulated function ResetSelectedAndReachableCells(optional bool removeUnit=false)
{
	local int i;

	if( mReachableCells.Length > 0 )
	{
		for( i = 0; i < mReachableCells.Length; ++i )
		{
			mReachableCells[i].SetForeshadow( false );
		}
	}
	mReachableCells.Length = 0;

	// reset the reachable alternative
	for( i = 0; i < mReachableAltCells.Length; ++i )
	{
		mReachableAltCells[i].SetForeshadowAlt( false );
	}
	mReachableAltCells.Length = 0;
	mCurrentReachableAltCreature = none;

	// unselect the cells where the creature is
	for( i = 0; i < mSelectedCells.Length; ++i )
	{
		mSelectedCells[i].SetSelected( false );
		if( removeUnit )
		{
			if( mSelectedCells[i].HasCreatureStack() )
			{
				mSelectedCells[i].RemoveCreatureStack();
			}
			else if( mSelectedCells[i].HasWarfareUnit() )
			{
				mSelectedCells[i].RemoveWarfareUnit();
			}
		}
	}

	for( i = 0; i < mMouseOverCells.Length; ++i )
	{
		mMouseOverCells[i].SetSelected( false );
		if( mMouseOverCells[i].HasCreatureStack() )
		{
			mMouseOverCells[i].GetCreatureStack().DehighlightStack();
		}
		else if( mMouseOverCells[i].HasWarfareUnit() )
		{
			mMouseOverCells[i].GetWarfareUnit().DeHighlightWarfareUnit();
		}
	}
}

simulated function StartUnitMovement( H7CombatMapCell hitCell, array<H7CombatMapCell> hitCells, array<H7CombatMapCell> path, optional bool isRealAttack = true )
{
	ResetSelectedAndReachableCells(true);
	if( ( hitCell.HasUnit() || hitCell.HasObstacle() ) && isRealAttack )
	{
		mCombatController.SetActiveUnitCommand_MoveAttack( path, hitCell.GetTargetable() );
	}
	else
	{
		if(!isRealAttack)
		{
			mCombatController.SetActiveUnitCommand_Move( path, true );
			mCombatController.SetActiveUnitCommand_UsePreparedAbility(hitCell.GetTargetable());
		}
		else
		{
			mCombatController.SetActiveUnitCommand_Move( path );
		}
	}

	mPathPreviewer.HidePreview();	
}

// set active (selected) unit
// during combat = active turn unit
// during tactics = dragndrop unit on cursor
simulated function SelectUnit( H7Unit unit, bool isCombatPhase )
{
	local H7CombatMapCell cell;
	local int i;

	mSelectedCells.Remove(0,mSelectedCells.Length);
	ClearMouseOverCells();

	mSelectedStack = None;
	mSelectedWarUnit = None;
	mSelectedCreatureSize = CELLSIZE_1x1;
	SetDecalDirty(true);

	if( unit == None )
	{
		return;
	}

	if( unit.GetEntityType() == UNIT_CREATURESTACK )
	{
		mSelectedStack = H7CreatureStack(unit);

		mSelectedCreatureSize = mSelectedStack.GetCreature().GetBaseSize();

		// select the cells where the creature is
		cell = mGrid.GetCellByIntPoint( mSelectedStack.GetGridPosition() );
		if( cell != None )
		{
			mSelectedCells = cell.GetMergedCells();
			mSelectedCells.AddItem( cell );

			// foreshadowing creature movement
			if( isCombatPhase )
			{
				ResetSelectedAndReachableCells(false);
				mGrid.GetAllReachableCells( mSelectedStack, mReachableCells );

				for( i = 0; i < mReachableCells.Length; ++i )
				{
					mReachableCells[i].SetForeshadow( true, mSelectedStack.GetPlayer().GetPlayerType() != PLAYER_AI );
				}
			}
		}
		else if(!mCombatController.IsInTacticsPhase()) // actually it's ok, during tactics
		{
			ScriptTrace();
			;
		}
	}
	else if( unit.GetEntityType() == UNIT_WARUNIT )
	{
		mSelectedWarUnit = H7WarUnit(unit);
		ResetSelectedAndReachableCells();
	}
	else
	{
		ResetSelectedAndReachableCells();
	}
}

function RecalculateReachableCells()
{
	local H7CreatureStack currentStack;
	local H7CombatMapCell highlightCell;
	local array<H7Command> commands;

	currentStack = H7CreatureStack( mCombatController.GetActiveUnit() );

	if( currentStack == none ) return;

	commands = class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().GetCmdsForCaster( currentStack );
	
	if( commands.Length > 0 ) return;

	ResetSelectedAndReachableCells(false);

	//if( !mCombatController.AllAnimationsDone() ) return;

	mGrid.GetAllReachableCells( currentStack, mReachableCells );

	foreach mReachableCells(highlightCell)
	{
		highlightCell.SetForeshadow( true, currentStack.GetPlayer().GetPlayerType() != PLAYER_AI );
	}
}

function CalculateReachableCellsFor( H7CreatureStack currentStack, optional int movePoints = -1 )
{
	local H7CombatMapCell highlightCell;

	if( currentStack == none ) { return; }

	ClearMouseOverCells();
	ResetSelectedAndReachableCells(false);

	//if( !mCombatController.AllAnimationsDone() ) return;

	mGrid.GetAllReachableCells( currentStack, mReachableCells, movePoints );

	foreach mReachableCells( highlightCell )
	{
		highlightCell.SetForeshadow( true, currentStack.GetPlayer().GetPlayerType() != PLAYER_AI );
	}
}

native function GetReachableCellsFor( H7CreatureStack currentStack, out array<H7CombatMapCell> cells, optional int movePoints = -1 );

native function bool CheckIfCellIsReachable( H7CombatMapCell cell, ECellSize cellSize );

/**
 * Gets cell by world location.

 * */
native simulated function H7CombatMapCell GetCell( Vector pos );

simulated function H7CombatMapCell GetMasterCellForObstacle( H7CombatObstacleObject theObstacle )
{
	if( theObstacle != None )
	{
		return mGrid.GetCellByIntPoint( theObstacle.GetGridPos() );
	}
	return None;
}

/** 
 *  This returns the targets in the selection(shape) - they are different from the targets that are combatresult-affected by effects 
 *  */
simulated function array<H7IEffectTargetable> GetTargetsOnMouseOverCells( optional bool dead = false )
{
	local H7CombatMapCell cell;
	local H7Unit unit;
	local H7CombatObstacleObject obstacle;
	local array<H7IEffectTargetable> targets;

	foreach mMouseOverCells( cell )
	{
		unit = cell.GetUnit();
		if ( unit == none && dead )
		{
			unit = cell.GetDeadCreatureStack();
		}

		if( unit != none && targets.Find( unit ) == INDEX_NONE )
		{
			targets.AddItem( unit );
		}
		obstacle = cell.GetObstacle();
		if ( cell.HasObstacle() && obstacle != none && obstacle.IsDestructible() && targets.Find( obstacle ) == INDEX_NONE )
		{
			targets.AddItem( obstacle );
		}
	}

	return targets;
}

native simulated function GetAdjacentCellsInCone( out array<H7CombatMapCell> outCells, H7CreatureStack castingCreature, H7CombatMapCell targetCell, float angle );

native simulated function GetCellsInCone( out array<H7CombatMapCell> outCells, H7CreatureStack castingCreature, H7CombatMapCell targetCell, H7BaseAbility ability, bool previewCone);

native simulated function RotateAround2x2(IntPoint inPos,out IntPoint outPos, int quadrant,bool reverse, bool targetSizeIs2x2);
native simulated function FindDoubleLinePositions(out IntPoint attackerPos1,out IntPoint defenderPos1,out IntPoint attackerPos2, out IntPoint defenderPos2, IntPoint rotationPos, int quadrant, bool targetSizeIs2x2 );

native simulated function int FindQuadrant(H7CombatMapCell casterPivot, H7CombatMapCell targetPivot );

/**
 * Gets cell array from a line that runs from the origin cell 
 * until an edge of the grid.
 * 
 * @param   lineOriginPoint      Point where the line should start, first point of linear equation
 * @param   lineTargetPoint      Point which is used for the second point of the linear equation
 * 
 * @return  Returns cells that are on the line from the origin to the grid edge.
 * 
 * */
native simulated function GetLineCellsIntersectingGrid( out array<H7CombatMapCell> outCells, IntPoint lineOriginPoint, IntPoint lineTargetPoint );

native simulated function GetDoubleLineCellsIntersectingGrid( out array<H7CombatMapCell> outCells, H7CreatureStack castingCreature,  H7CombatMapCell targetCell );

native simulated function GetCellsForSunburst( out array<H7CombatMapCell> outCells, IntPoint originPoint, out array<int> indeces, out array<IntPoint> targetPoints);

native simulated function RemoveBlockedCellsFromLine(out array<H7CombatMapCell> line);

native simulated function GetCellsForTsunami( out array<H7CombatMapCell> outCells, IntPoint originPoint, int rows );

native simulated function GetCellsInColumn(out array<H7CombatMapCell> outCells, H7CombatMapCell cell);

native simulated function GetPreCellsForTsunami( out array<H7CombatMapCell> outCells, IntPoint originPoint, int rows );
native simulated function GetPostCellsForTsunami( out array<H7CombatMapCell> outCells, IntPoint originPoint, int rows );
native simulated function Vector GetCenterPosForColCells(int ColNum);

// returns the WorldPosition a stack/creature/object has to be to appear to be on gridPos x,y
simulated function Vector GetCellLocation( IntPoint gridPos ) { return mGrid.GetCellByIntPoint( gridPos ).GetCenterPos(); }

simulated public function H7SiegeTownData GetSiegeTownData()
{
	local H7Town town;
	local H7Fort fort;
	local H7Garrison garrison;
	local H7SiegeTownData siegeTownData;

	if( IsSiegeMap() )
	{
		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			town = H7Town( class'H7AdventureController'.static.GetInstance().GetBeforeBattleArea() );
			if( town != none )
			{
				siegeTownData.Faction = town.GetFaction();
				siegeTownData.HasMoats = town.GetBuildingLevelByType( class'H7TownMoat' ) >= 1;
				siegeTownData.HasShootingTowers = town.GetBuildingLevelByType( class'H7TownTower' ) >= 1;
				siegeTownData.WallAndGateLevel = town.GetBuildingLevelByType( class'H7TownGuardBuilding' );
				siegeTownData.WallAndGateLevel = Clamp( siegeTownData.WallAndGateLevel, 0, 3 );
				siegeTownData.TownLevel = town.GetBuildingLevelByType( class'H7TownHall' );
				siegeTownData.SiegeObstacleTower = town.GetCombatMapTower();
				siegeTownData.SiegeObstacleWall = town.GetCombatMapWall();
				siegeTownData.SiegeObstacleMoat = town.GetCombatMapMoat();
				siegeTownData.SiegeObstacleGate = town.GetCombatMapGate();
				siegeTownData.SiegeDecorationList = town.GetCombatMapDecoList();
			}
			fort = H7Fort( class'H7AdventureController'.static.GetInstance().GetBeforeBattleArea() );
			if( fort != none )
			{
				siegeTownData.Faction = fort.GetFaction();
				siegeTownData.WallAndGateLevel = 3;
				siegeTownData.SiegeObstacleTower = fort.GetCombatMapTower();
				siegeTownData.SiegeObstacleWall = fort.GetCombatMapWall();
				siegeTownData.SiegeObstacleMoat = fort.GetCombatMapMoat();
				siegeTownData.SiegeObstacleGate = fort.GetCombatMapGate();
				siegeTownData.SiegeDecorationList = fort.GetCombatMapDecoList();
			}
			garrison = H7Garrison( class'H7AdventureController'.static.GetInstance().GetBeforeBattleArea() );
			if( garrison != none )
			{
				siegeTownData.Faction = garrison.GetFaction();
				siegeTownData.WallAndGateLevel = 1;
				siegeTownData.SiegeObstacleTower = garrison.GetCombatMapTower();
				siegeTownData.SiegeObstacleWall = garrison.GetCombatMapWall();
				siegeTownData.SiegeObstacleMoat = garrison.GetCombatMapMoat();
				siegeTownData.SiegeObstacleGate = garrison.GetCombatMapGate();
				siegeTownData.SiegeDecorationList = garrison.GetCombatMapDecoList();
			}
		}
		else
		{
			siegeTownData = class'H7CombatController'.static.GetInstance().GetCombatConfiguration().mSiegeTownData;
		}
	}
	return siegeTownData;
}

/**
 * Delete all Referances for Siege Objects when leaving the CombatMap to Adventuremap
 * **/
function DeleteTownDataRef()
{
	local H7Town town;

	if( IsSiegeMap() )
	{
		if( class'H7AdventureController'.static.GetInstance() != none )
		{
			town = H7Town( class'H7AdventureController'.static.GetInstance().GetBeforeBattleArea() );
			if( town != none )
			{
				town.DelCombatMapTowerRef();
				town.DelCombatMapWallRef();
				town.DelCombatMapMoatRef();
				town.DelCombatMapGateRef();
				town.DelCombatMapDecoListRef();
			}
		}
	}

}

function InitCellsForObstaclePlacement()
{
	local int defenderDeploy, attackerDeploy, defenderBuffer, attackerBuffer;
	local H7CombatMapCell cell;

	mObstaclePlacementCells.Length = 0;

	defenderDeploy = mCombatController.GetArmyDefender().GetHero().GetModifiedStatByID( STAT_MAX_DEPLOY_ROW );
	attackerDeploy = mCombatController.GetArmyAttacker().GetHero().GetModifiedStatByID( STAT_MAX_DEPLOY_ROW );

	defenderBuffer = mGrid.GetXSize() - WARFARE_UNIT_GRID_BUFFER_SIZE / 2 - defenderDeploy;
	attackerBuffer = WARFARE_UNIT_GRID_BUFFER_SIZE / 2 + attackerDeploy;
	foreach mCombatCells( cell )
	{
		if( cell.mPosition.X >= attackerBuffer && cell.mPosition.X < defenderBuffer )
		{
			mObstaclePlacementCells.AddItem( cell );
		}
	}
}

simulated function PlaceObstacle( IntPoint gridPos, H7CombatObstacleObject theObstacle, H7SiegeTownData siegeTownData )
{
	local H7CombatObstacleObject obstacleToAdd;
	local H7CombatMapCell cell, nearbyCell;
	local array<H7CombatMapCell> cells;
	local IntPoint dimNearbyObstacle, nearbyPoint, dimObstacle;
	local array<IntPoint> nearbyPoints;

	if( theObstacle != none )
	{
		dimObstacle.X = theObstacle.GetObstacleBaseSizeX();
		dimObstacle.Y = theObstacle.GetObstacleBaseSizeY();
		
		obstacleToAdd = theObstacle.PlaceObstacle( siegeTownData, mGrid.GetCellByIntPoint( gridPos ).GetCenterPosByDimensions( dimObstacle ) );

		if( obstacleToAdd != none )
		{
			cell = mGrid.GetCellByIntPoint( gridPos );
			cell.PlaceObstacle( obstacleToAdd );
			obstacleToAdd.SetGridPos(gridPos);
			obstacleToAdd.Init();
			mPlacedObstacles.AddItem( obstacleToAdd );
		}
	}
	cell.GetCellsHitByCellSizeXY( obstacleToAdd.GetObstacleBaseSizeX(), obstacleToAdd.GetObstacleBaseSizeY(), cells, true );

	dimNearbyObstacle.X = 5;
	dimNearbyObstacle.Y = 5;
	foreach cells( cell )
	{
		class'H7Math'.static.GetSpiralIntPointsByDimension( nearbyPoints, cell.mPosition, dimNearbyObstacle );
		cell.SetHasObstacleNearby( true );
		foreach nearbyPoints( nearbyPoint )
		{
			nearbyCell = mGrid.GetCellByIntPoint( nearbyPoint );
			if( nearbyCell != none && !nearbyCell.HasObstacleNearby() )
			{
				nearbyCell.SetHasObstacleNearby( true );
				mObstaclePlacementCells.RemoveItem( nearbyCell );
			}
		}
	}
}

function RaiseEventOnObstacles( ETrigger trigger, optional H7EventContainerStruct container )
{
	local H7CombatObstacleObject obstacle;

	foreach mPlacedObstacles( obstacle )
	{
		obstacle.TriggerEvents( trigger, false, container );
	}
}

native simulated function bool CanPlaceCreature( IntPoint gridPos, H7CreatureStack creatureStack );

simulated function UpdateCreatureDeployment(IntPoint gridPos, H7CreatureStack creature)
{
	local array<H7CreatureStack> stacks;
	local IntPoint deployPos;
	local int idx;

    if(creature!=None) 
	{
		stacks = creature.GetCombatArmy().GetCreatureStacks();
		idx = stacks.Find(creature);
		if(idx!=INDEX_NONE)
		{
			deployPos.X = gridPos.X - (class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2);
			deployPos.Y = gridPos.Y;
			creature.GetCombatArmy().GetDeployment().SetStackGridPos(idx,deployPos);
		}
		else
		{
			;
		}
	}
}

simulated function PlaceCreature( IntPoint gridPos, H7CreatureStack creature )
{
	local Vector cellPos;
	local H7CombatMapCell cell;
	
	if( creature != None ) 
	{
		cell    = mGrid.GetCellByIntPoint(gridPos);
		if( cell == none )
		{
			ScriptTrace();
			;
		}
		else
		{
			cellPos = cell.GetCenterPosBySize(creature.GetCreature().GetBaseSize(),false);
			cell.PlaceCreature(creature);
			creature.SetStackLocation(cellPos);
			creature.SetGridPosition(gridPos);
		}
	}
}

simulated function PlaceWarfareUnit( IntPoint gridPos, H7WarUnit warUnit )
{
	local Vector cellPos;
	local H7CombatMapCell cell;
	
	if( warUnit != None ) 
	{
		cell = mGrid.GetCellByIntPoint( gridPos );
		cellPos = cell.GetCenterPosBySize( CELLSIZE_2x2, false );
		cell.PlaceWarfareUnit( warUnit );

		warUnit.SetLocation( cellPos );
		warUnit.SetGridPosition( gridPos );
		
	}
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Role=ROLE_Authority;

	Init();
}

simulated function Init()
{
	// only when we have the game replication info and the player controller can we init the grid
	if( mID == 0 && class'WorldInfo'.static.GetWorldInfo().GRI != none && class'H7PlayerController'.static.GetPlayerController() != none )
	{
		if(class'H7AdventureController'.static.GetInstance() == none)
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().Init();
		}

		class'H7CombatHudCntl'.static.GetInstance().GetCombatMenu().SetTurnCounter(1);
		mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
		class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self );

		class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetCombatGridController( self );
	
		class'H7ReplicationInfo'.static.GetInstance().SetIsCombatMap();

		CreateGrid();
		SetTimer( 0.f, false, nameof(Init) ); // reset timer

		mConePreview = Spawn( class'DynamicSMActor_Spawnable', self );

		if( WorldInfo.GRI.IsMultiplayerGame() )
		{
			class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().SetWaitingForPlayers( true );
		}

	}
	else if( mID == 0 )
	{
		;
	}
}

simulated function UnregisterEvents()
{
	local int x, y;
	local H7CombatMapCell cell;

	class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( self );

	for (y = 0; y < mGridSizeY; ++y)
	{
		for (x = 0; x < (mAdjustedGridSizeX); ++x)
		{
			cell = mCombatCells[x + y * (mAdjustedGridSizeX)];
			class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( cell );

		}
	}
}

function UpdateCellSelectionTypes()
{
	local int x, y;
	local H7CombatMapCell cell;
    for( y = 0; y < mGridSizeY; ++y )
	{
		for( x = 0; x < mAdjustedGridSizeX; ++x )
		{
			cell = mCombatCells[x + y * (mAdjustedGridSizeX)];
			cell.UpdateSelectionType();
		}
	}
}

simulated function CreateGrid()
{
	local int x, y;
	local H7CombatMapCell cell;
	local Rotator cellRotation;

	mGrid = new class 'H7CombatMapGrid';

	mGrid.SetGridAllowsFlee(mCanFlee);
	mGrid.SetGridAllowsSurrender(mCanSurrender);

	CalculateIsSiegeMap();

	for (y = 0; y < mGridSizeY; ++y)
	{
		mGrid.AddCol();

		for (x = 0; x < (mAdjustedGridSizeX); ++x)
		{
			cell = mCombatCells[x + y * (mAdjustedGridSizeX)];

			cell.SetLocation(cell.GetLocation() + self.Location);
			cell.SetOriginalLocation( cell.GetLocation() ); 
			cellRotation.Pitch = 270 * DegToUnrRot; // 270 degree (needed to see the cell correctly)
			cell.SetRotation( cellRotation );
			cell.Init( self );
			class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( cell );
			
			// set coordinates of the cell
			cell.SetCellSize(CELLSIZE_1X1);
			cell.SetCellSize2ndLayer(CELLSIZE_1X1);
			cell.SetMaster(cell);
			cell.SetMaster2ndLayer(cell);

			mGrid.AddRowCell( y, cell );
			if( x < class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2 || x >= mGridSizeX + class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2 )
			{
				cell.SetWarfareBuffer( true );
				cell.SetPassable( false );
			}
		}
	}
	
	UpdateNeighbours();

	mPathPreviewer = Spawn(class'H7CombatMapPathPreviewer', self);

	SetTimer( 1.f, true, NameOf(MPSetPlayerReady) );

	class'H7ReplicationInfo'.static.PrintLogMessage("CombatMapGridController created" @ self, 0);;
	
	// create the combat controller only when the combat is running inside an adventure map
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		SetTimer( 0.1f, false, 'CreateCombatControllerAndRNG' );
	}

	mAbilityManager = new(self) class 'H7AbilityManager';
	mAbilityManager.SetOwner( self ) ;
	mBuffManager = new(self) class 'H7BuffManager';
	mBuffManager.Init( self );
	mEventManager = new(self) class 'H7EventManager';
	mEffectManager = new(self) class 'H7EffectManager';
	mAuraManager = new(self) Class 'H7AuraManager';
	mAuraManager.SetIsOnCombatMap( true );
	mAuraManager.SetOwner( self );
	mEffectManager.Init( self );
	mBuffManager.Init( self );
	



}

protected function CreateCombatControllerAndRNG()
{
	class'H7ReplicationInfo'.static.GetInstance().CreateSynchRNG();
	class'H7ReplicationInfo'.static.GetInstance().CreateCombatController();
}

function float GetDistanceTiles( H7Unit attacker, H7Unit defender, bool forecast, int range ) 
{
	local int i,j;
	local array<H7CombatMapCell> cells,previewCells;
	local H7CombatMapCell casterCell;
	
	if( forecast ) 
	{
		GetMovementPreviewCells( previewCells );
	}

	if( previewCells.Length == 0 )
	{   
		casterCell = GetCombatGrid().GetCellByIntPoint( attacker.GetGridPosition() ).GetMaster();
	}
	else
	{
		casterCell = previewCells[0].GetMaster();
	}


	for (i=1;i<=range;++i)
	{
		GetCombatGrid().GetCellSurrounding( cells , casterCell, i , attacker.GetUnitBaseSize()  );

		for ( j=0;j<cells.Length;++j)
		{
			if( cells[j].GetMaster().HasCreatureStack() && cells[j].GetMaster().GetUnit() == defender )
			{
				return i; // return range;
			}
		}
	}

	return -1; // not found 
}

simulated function CalculateIsSiegeMap()
{
	local int i;

	for( i = 0; i < mObstacles.Length; i++ )
	{
		if( mObstacles[i].Obstacle == none ) continue;

		if( mObstacles[i].Obstacle.IsA( 'H7CombatMapGate' ) )
		{
			mIsSiegeMap = true;
		}
	}
}

protected simulated function MPSetPlayerReady()
{
	if( WorldInfo.GRI != none && WorldInfo.GRI.IsMultiplayerGame() && GetALocalPlayerController().PlayerReplicationInfo != none )
	{
		H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).SetPlayerReady();
		ClearTimer( NameOf(MPSetPlayerReady) );
	}
}

simulated function PlaceRandomObstacles()
{
	local bool positionFound;
	local H7CombatObstacleObject dasObstacle;
	local H7CombatMapCell cell;
	local array<H7CombatMapCell> cells;
	local IntPoint position;
	local array<H7CombatObstacleObject> obstacles;
	local int randomAmount, i, obstacleIndex;

	obstacles = mRandomObstacleList;
	randomAmount = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( obstacles.Length );
	for( i = 0; i < randomAmount; ++i )
	{
		obstacleIndex = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( obstacles.Length );
		dasObstacle = obstacles[ obstacleIndex ];
		obstacles.Remove( obstacleIndex, 1 );
		cells.Length = 0;
		foreach mObstaclePlacementCells( cell )
		{
			cells.AddItem( cell );
		}
		while( !positionFound && cells.Length > 0 )
		{
			cell = cells[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( cells.Length ) ];
			cells.RemoveItem( cell );
			positionFound = CanPlaceRandomObstacle( cell.mPosition, dasObstacle.GetObstacleBaseSizeX(), dasObstacle.GetObstacleBaseSizeY() );
			position = cell.mPosition;
		
		}
		if( positionFound )
		{
			PlaceObstacle( position, dasObstacle, GetSiegeTownData() );
			positionFound = false;
		}
	}

}

function bool CanPlaceRandomObstacle( IntPoint pos, int xSize, int ySize )
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;
	local int defenderDeploy, attackerDeploy, defenderBuffer, attackerBuffer;

	defenderDeploy = mCombatController.GetArmyDefender().GetHero().GetModifiedStatByID( STAT_MAX_DEPLOY_ROW );
	attackerDeploy = mCombatController.GetArmyAttacker().GetHero().GetModifiedStatByID( STAT_MAX_DEPLOY_ROW );

	defenderBuffer = GetGridSizeX() - WARFARE_UNIT_GRID_BUFFER_SIZE / 2 - defenderDeploy;
	attackerBuffer = WARFARE_UNIT_GRID_BUFFER_SIZE / 2 + attackerDeploy;

	mGrid.GetCellByIntPoint( pos ).GetCellsHitByCellSizeXY( xSize, ySize, cells, true );
	foreach cells( cell )
	{
		if( cell.HasObstacleNearby() || cell.mPosition.X >= defenderBuffer || cell.mPosition.X < attackerBuffer || cell.mPosition.Y + ySize > GetGridSizeY() )
		{
			return false;
		}
	}
	return true;
}

simulated function ResetTacticsGrid()
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;


	mGrid.GetAllPlaceableCells(mTacticsPlaceableColumns,true,cells);

	foreach cells(cell)
	{
		if(cell!=None)
		{
			cell.SetCellSize(CELLSIZE_1X1);
			cell.SetCellSize2ndLayer(CELLSIZE_1X1);
			cell.SetMaster(cell);
			cell.SetMaster2ndLayer(cell);
			cell.SetMouseOver(false);
			cell.SetSelected(false);
			cell.SetSelectionType(CREATURE_TACTICS);
			if(cell.GetCreatureStack()!=None) cell.RemoveCreatureStack();
		}
	}

	ClearMouseOverCells();
	SelectUnit(none,false);
	SetArmyForeShadowedCells(false);
	ResetSelectedAndReachableCells();
}

simulated function UpdateObstacles()
{
	local int i, j;
	local H7CombatMapCell cell;
	local H7SiegeTownData siegeTownData;

	siegeTownData = GetSiegeTownData();
	for( i = 0; i < mObstacles.Length; ++i )
	{
		PlaceObstacle( mObstacles[i].gridPos, mObstacles[i].Obstacle, siegeTownData );
	}

	// update the cells that are behind the walls in a siege map
	if( mIsSiegeMap && siegeTownData.WallAndGateLevel > 0 )
	{
		for( i=0; i<=mGridSizeY-1; ++i )
		{
			for( j=(mAdjustedGridSizeX)-1; j>=0; --j )
			{
				cell = mGrid.GetCell( j, i );
				if( cell.HasObstacle() )
				{
					break;
				}
				cell.SetSiegeWallCover( true );
			}
		}
	}
}

simulated function UpdateSiegeMapDecoration()
{
	local H7SiegeMapDecoration currentDecoration;
	local H7SiegeTownData siegeTownData;

	if( mIsSiegeMap )
	{
		siegeTownData = GetSiegeTownData();

		foreach mDecorations( currentDecoration )
		{
			currentDecoration.Update( siegeTownData );
		}
	}
}

simulated protected function UpdateNeighbours()
{
	local array<H7CombatMapCell> neighbours;
	local int x,y; 

	for( y = 0; y < mGridSizeY; ++y )
	{
		for( x = 0; x < (mAdjustedGridSizeX); ++x )
		{
			neighbours.AddItem( mGrid.getCell( x-1, y-1 ) ); // upper left
			neighbours.AddItem( mGrid.getCell( x  , y-1 ) ); /// upper
			neighbours.AddItem( mGrid.getCell( x+1, y-1 ) ); /// upper right
			neighbours.AddItem( mGrid.getCell( x-1, y   ) ); // left
			neighbours.AddItem( mGrid.getCell( x+1, y   ) ); // right
			neighbours.AddItem( mGrid.getCell( x-1, y+1 ) ); /// lower left
			neighbours.AddItem( mGrid.getCell( x  , y+1 ) ); // lower
			neighbours.AddItem( mGrid.getCell( x+1, y+1 ) ); /// lower right

			mGrid.getCell(x,y).SetNeighbours(neighbours);

			neighbours.Length = 0; // empty the array
		}
	}
}

// return none if there is no creature (alive or dead) under the mouse
// case 1: hitting the terrain-cell where a creature is standing
// case 2: hitting the creature-mesh-model, in this case the hitlocation will be the hitlocation of the terrain behind (used for the attack direction)
native simulated function H7IEffectTargetable GetMouseOverTarget( out Vector hitLocation );

simulated function BeginTactics( bool forAttacker, int numberColumns )
{
	// internally we define that a negative column number does mean counting 'from the right edge' and otherwise 'from the left edge'
	mTacticsPlaceableColumns = forAttacker ? numberColumns : -numberColumns;
	GotoState('Tactics',, true ); // to force re-starting the tactics state even it currently is in that state
}

simulated function BeginCombat()
{
	GotoState('Combat');
}

function EFlankingType DetermineFlankingType( H7CombatMapCell attackCell, H7CreatureStack attackTarget )
{
	local Rotator attackerkRot, defenderRot;
	local Vector attackerCenterPos;
	local float rotationDifference; // degrees
 
	if( attackCell == none || attackTarget == none ) return NO_FLANKING;

	attackerCenterPos = attackCell.GetPosition1x1();
	
	attackerkRot = rotator(attackerCenterPos - attackTarget.GetCreature().Location);
	defenderRot = attackTarget.GetCreature().Rotation;
	rotationDifference = RDiff(attackerkRot, defenderRot);
	
	if( rotationDifference >= 140.f && attackTarget.GetCreature().IsFullFlankable() )
	{
		return FULL_FLANKING;
	}
	else if( rotationDifference >= 85.f &&  attackTarget.GetCreature().IsFlankable() )
	{
		return FLANKING;
	}

	return NO_FLANKING;
}

// does include the recalculation of oportunity values
simulated function RefreshThreatMap()
{
	local int i,j;

	local H7CombatArmy thisArmy;
	local H7CombatArmy thatArmy;
	local array<H7CreatureStack> thisCreatures;
	local array<H7CreatureStack> thatCreatures;
	local array<H7CreatureStack> checkedStacks;
	local H7CreatureStack creature;
	local float thisArmyPower, thatArmyPower, stackPower, currentUnitPower, combinedPower, p;
	local H7CombatMapCell cell, neighbour, mergedCell;
	local H7Unit    currentUnit;
	local array<H7CombatMapCell> attackPositions, dummy, neighbours, allNeighbourCells, mergedCells;
	local EFlankingType flankingType;
	local float distScale, dist;

	dummy = dummy;

	// clear cell threat and oportunity values
	for( i=0; i<mAdjustedGridSizeX; ++i )
	{
		for( j=0; j<mGridSizeY; ++j )
		{
			cell = mGrid.getCell(i,j);
			cell.SetThreat(0.0f);
			cell.SetOpportunity(0.0f);
			if( H7CombatMapMoat( cell.GetObstacle() ) != none )
			{
				cell.SetThreat( 1000.0f );
			}
		}
	}

	// get army creature stacks
	thisArmy = mCombatController.GetActiveArmy();
	thisArmyPower = thisArmy.GetStrengthValue();
	thisCreatures = thisArmy.GetCreatureStacks();
	thatArmy = mCombatController.GetOpponentArmy(thisArmy);
	thatArmyPower = thatArmy.GetStrengthValue();
	thatCreatures = thatArmy.GetCreatureStacks();

	// we need to backup current stack and restore the current when finished, because we need to make calls to SelectUnit() for each stack to query if it can reach a cell or not
	currentUnit = mCombatController.GetActiveUnit();
	currentUnitPower = thisArmy.GetStackPower(H7CreatureStack(currentUnit));

	// own army

	foreach thisCreatures(creature)
	{
		if( creature.IsDead() == false )
		{
//			`LOG_AI("selecting unit" @ creature );
			mCombatController.SetActiveUnit(creature);
			SelectUnit( creature, true );
			stackPower = thisArmy.GetStackPower(creature);
//			`LOG_AI("checking position for" @ creature );
			if( stackPower > 0.0f )
			{
				stackPower /= thisArmyPower; // make it relative to total army power
				for( i=0; i<mAdjustedGridSizeX; ++i )
				{
					for( j=0; j<mGridSizeY; ++j )
					{
						cell = mGrid.getCell(i,j);
						
						if( mGrid.CurrentStackCanMoveHere(cell,creature) )
						{
							dist = mGrid.CurrentStackMoveDistance(cell,creature);
							if(dist>=0.9f) dist=0.9f;
							if(dist>=0.0f)
							{
								distScale = 1.0f - dist;
								cell.ModifyThreat(-stackPower * distScale);
							}
							else
							{
								cell.ModifyThreat(-stackPower * 0.1f);
							}
						}
						else
						{
							cell.ModifyThreat(-stackPower * 0.1f);
						}
					}
				}
			}
		}
	}

	//FlushPersistentDebugLines();
	// enemy army
	foreach thatCreatures(creature)
	{
		if( creature.IsDead() == false )
		{
//			`LOG_AI("selecting unit" @ creature );
			mCombatController.SetActiveUnit(creature);
			SelectUnit( creature, true );
			stackPower = thatArmy.GetStackPower(creature);
//			`LOG_AI("checking attack position for" @ creature );
			mGrid.GetAllAttackPositionsAgainst(creature,H7CreatureStack(currentUnit),attackPositions);
//			`LOG_AI("...done" @ attackPositions.Length );

			if( stackPower > 0.0f )
			{
				stackPower /= thatArmyPower; // make it relative to total army power
				for( i=0; i<mAdjustedGridSizeX; ++i )
				{
					for( j=0; j<mGridSizeY; ++j )
					{
						cell = mGrid.getCell(i,j);

						if( mGrid.CurrentStackCanMoveHere(cell,creature) )
						{
							dist = mGrid.CurrentStackMoveDistance(cell,creature);
							if(dist>=0.9f) dist=0.9f;
							if(dist>=0.0f)
							{
								distScale = 1.0f - dist;
								cell.ModifyThreat(stackPower * distScale * 0.5f);
							}
							else
							{
								cell.ModifyThreat(stackPower * 0.1f * 0.5f);
							}
						}
						else if( creature.IsRanged() )
						{
							if( GetCombatGrid().HasAdjacentCreature( creature, none, true, dummy ) )
							{
								dist = mGrid.CurrentStackMoveDistance(cell,creature);
								if(dist>=0.9f) dist=0.9f;
								if(dist>=0.0f)
								{
									distScale = 1.0f - dist;
									cell.ModifyThreat(stackPower * distScale);
								}
								else
								{
									cell.ModifyThreat(stackPower * 0.1f);
								}
							}
							else
							{
								dist = mGrid.CurrentStackMoveDistance(cell,creature);
								if(dist>=0.9f) dist=0.9f;
								if(dist>=0.0f)
								{
									distScale = 1.0f - dist;
									cell.ModifyThreat( stackPower * distScale * 1.75f );
								}
								else
								{
									cell.ModifyThreat( stackPower * 0.1f * 1.75f );
								}
							}
						}

						if( attackPositions.Find(cell) >= 0 )
						{
							p = cell.GetOpportunity();
							flankingType = DetermineFlankingType(cell,creature);
							combinedPower = currentUnitPower;
							if(flankingType==FULL_FLANKING) combinedPower*=2.0f;
							else if(flankingType==FLANKING) combinedPower*=1.5f;

							allNeighbourCells.Length = 0;
							mergedCells.Length = 0;
							checkedStacks.Length = 0;
							
							if( cell.GetMaster() == creature.GetCell() )
							{
								mergedCells = creature.GetCell().GetMergedCells();
							}
							else
							{
								GetCombatGrid().GetCellsIfPlacedHere( cell, creature, mergedCells );
							}
							

							foreach mergedCells( mergedCell )
							{
								neighbours = mergedCell.GetNeighbours();
								foreach neighbours( neighbour )
								{
									if( allNeighbourCells.Find( neighbour ) == INDEX_NONE && mergedCells.Find( neighbour ) == INDEX_NONE )
									{
										allNeighbourCells.AddItem( neighbour );
									}
								}
							}

							foreach allNeighbourCells( neighbour )
							{
								if( neighbour.HasCreatureStack() && checkedStacks.Find( neighbour.GetCreatureStack() ) == INDEX_NONE && neighbour.GetCreatureStack().CanRangeAttack() )
								{
									combinedPower *= 2.1f;
									checkedStacks.AddItem( neighbour.GetCreatureStack() );
								}
							}

							combinedPower /= thisArmyPower;
							
							if( p < combinedPower && H7CombatMapMoat( cell.GetObstacle() ) == none ) 
							{
//								`Log_AI("Opportunity Value:"@combinedPower@"target:"@creature@"from:"@cell);
								cell.SetOpportunity( combinedPower );
								//DrawDebugStar( cell.GetOriginalLocation(), 100, 255*combinedPower, 0, 0, true );
							}
						}
					}
				}
			}
		}
	}

	// reselect current
	mCombatController.SetActiveUnit(currentUnit);
	SelectUnit( currentUnit, true );

}

auto simulated state NotInit
{
	simulated event BeginState(name previousStateName)
	{
		;
	}
	
	simulated event EndState(name nextStateName)
	{
		;
	}
}

simulated state Combat
{
	simulated event BeginState(name previousStateName)
	{
		;
		mCombatController.RefreshAllUnits();
	}
	
	simulated event EndState(name nextStateName)
	{
		;
	}

	// the current selected creature will move, attack or use an ability to where the cursor is pointing
	// selfcase (wait/defend) is in SetActiveUnitCommand_PrepareAbility
	simulated function DoCurrentUnitAction()
	{
		local array<H7CombatMapCell> hitCells, potentialSummonCells;
		local H7CombatMapCell hitCell, trueHitCell;
		local EDirection hitDirection;
		local H7BaseAbility prepAbility;
		local H7IEffectTargetable tmpTarget;
		local H7IEventManagingObject eventManageable;
		local bool canCast;
		local int i;

		if(!mCombatController.AllowCurrentUnitAction())
		{
			;
			return;
		}

		prepAbility = mCombatController.GetActiveUnit().GetPreparedAbility();

		// casting/clicking to attack should instant hide the attack-tooltip
		class'H7CombatHudCntl'.static.GetInstance().GetDamageTooltipSystem().ShowTooltip(false);
		;
		
		if( GetMouseOverCell( hitCell, hitCells,,hitDirection, trueHitCell ) )
		{
			// Teleport selection hack (only select if we have prepared a teleport spell and we don't have a target yet)
			if( prepAbility.IsTeleportSpell() && class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() == -1 )
			{
				// Can only teleport units!
				tmpTarget = hitCell.GetTargetable();
				if( H7CreatureStack( tmpTarget ) != none && class'H7Effect'.static.GetAlignmentType( mCombatController.GetActiveUnit(), tmpTarget ) == AT_FRIENDLY )
				{
					class'H7ReplicationInfo'.static.GetInstance().SetTeleportTargetID( tmpTarget.GetID() );
					mCombatController.RefreshAllUnits();
					H7CreatureStack( tmpTarget ).SetIsBeingTeleported( true );
					H7CreatureStack( tmpTarget ).GetPathfinder().ForceUpdate();
					CalculateReachableCellsFor( H7CreatureStack( tmpTarget ), prepAbility.GetTeleportEffectRange() );
				}
				return;
			}
			else if( prepAbility.IsTeleportSpell() && class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() != -1 )
			{
				eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() );

				if(prepAbility.TargetIsImmuneToAllEffects(hitCell) ||
					hitCells.Length == 0 || !hitCell.IsForeshadow() ||
					!CanPlaceCreature( hitCell.GetGridPosition(), H7CreatureStack( eventManageable ) ) )
				{
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_VALID_TARGET","H7FCT"));
					class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
					return;
				}
			}
			else if( prepAbility.IsSummoningSpell() )
			{
				if( hitCell.GetGridPosition().X < 2 || hitCell.GetGridPosition().X > mGridSizeX ||
					hitCell.GetGridPosition().Y < 0 || hitCell.GetGridPosition().Y > mGridSizeY )
				{
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_VALID_TARGET","H7FCT"));
					class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
					return;
				}

				hitCell.GetCellsHitByCellSize( CELLSIZE_2x2, potentialSummonCells, false );
				for( i = 0; i < potentialSummonCells.Length; ++i )
				{
					if( potentialSummonCells[i] == none || !potentialSummonCells[i].IsPassable() )
					{
						class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_VALID_TARGET","H7FCT"));
						class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
						return;
					}
				}
			}
			else if( prepAbility.IsDivingAttack() )
			{
				if( hitCell.GetGridPosition().X < 2 || hitCell.GetGridPosition().X > mGridSizeX ||
					hitCell.GetGridPosition().Y < 0 || hitCell.GetGridPosition().Y > mGridSizeY )
				{
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_VALID_TARGET","H7FCT"));
					class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
					return;
				}
			}

			canCast = prepAbility != none && prepAbility.CanCastOnTargetActor( hitCell.GetTargetable() );
			mCombatController.RefreshAllUnits(); // units lose their red slot fx
			if(prepAbility != none && !mCombatController.GetActiveUnit().IsDefaultAttackActive() )
			{
				if( canCast )
				{
					if( !prepAbility.ShouldMoveToTarget() )
					{
						DoAbility( hitCell, hitDirection, trueHitCell );
					}
					else
					{
						if( prepAbility.HasTag( TAG_RESURRECT ) && hitCell.HasDeadCreatureStack() )
						{
							mGrid.GetAllAttackPositionsAgainst( hitCell.GetTargetable(), mCombatController.GetActiveUnit(), hitCells );
						}

						// FIX no moving with active abilities anymore (-> ask game design)! (ex: Silverback's Feral Charge, Ancient Behemoth's Mighty Pounce)
						if( mGrid.CanMoveTo( hitCells, mSelectedStack ) && hitCell.GetTargetable() != hitCell )
						{
							DoAbility( hitCell, hitDirection, trueHitCell, hitCells);
						}
					}
				}
				else
				{
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_VALID_TARGET","H7FCT"));
					class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
				}
			}
			else
			{
				// move
				if( mGrid.CanMoveTo( hitCells, mSelectedStack ) )
				{
					DoMovement(hitCell, hitCells);
				}
				// attack
				else
				{
					if( canCast )
					{
						DoAbility( hitCell, hitDirection );
					}
					else
					{
						if( hitCell.GetCreatureStack() == none && mCombatController.GetActiveUnit().IsDefaultAttackActive() && !mCombatController.GetActiveUnit().IsA('H7CombatHero'))
						{
							class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
							class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
						}
						else
						{
							class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitCell.GetLocation(), mCombatController.GetActiveArmy().GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_VALID_TARGET","H7FCT"));
							class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
						}
					}
				}
			}
		}
	}

	simulated protected function UpdateReachableAltCells(H7IEffectTargetable target)
	{
		local H7Unit unit;
		local H7CombatMapCell cell;

		unit = H7Unit( target );
		if( unit == class'H7CombatController'.static.GetInstance().GetActiveUnit() )
		{
			unit = none;
		}

		if( unit != mCurrentReachableAltCreature )
		{
			mCurrentReachableAltCreature = unit;
			// clear the previous cells
			foreach mReachableAltCells( cell )
			{
				cell.SetForeshadowAlt( false );
			}
			mReachableAltCells.Remove( 0, mReachableAltCells.Length );

			if( mCurrentReachableAltCreature == none )
			{
				return;
			}

			if( mCurrentReachableAltCreature != none && !mCurrentReachableAltCreature.IsDead() )
			{
				mGrid.GetAllReachableCells( H7CreatureStack( mCurrentReachableAltCreature ), mReachableAltCells );
				foreach mReachableAltCells(cell)
				{
					cell.SetForeshadowAlt( true );
				}
			}
		}
	}

	simulated protected function UpdateGridState(H7CombatMapCell hitCell, array<H7CombatMapCell> hitCells, vector hitLocation, optional H7CombatMapCell trueHitCell )
	{
		if( mSelectedStack != none && /*!mCombatController.GetCommandQueue().IsCommandRunning()*/ mCombatController.AllAnimationsDone() )
		{
			if( hitCell != none && hitCells.Length > 0 && ( !mSelectedStack.HasPreparedAbility() || mSelectedStack.GetPreparedAbility().ShouldMoveToTarget() || mSelectedStack.IsDefaultAttackActive()) )
			{
				if( mGrid.CanMoveTo( hitCells, mSelectedStack ) )
				{
					ShowPathPreview( hitCells );
				}
				else 
				{
					mPathPreviewer.HidePreview();
				}
			}
			else // no cell hit
			{
				mPathPreviewer.HidePreview();
			}
			DisplayHoverEffect(hitCell, hitCells);
		}
		else if( mCombatController.GetActiveUnit() != none && /*!mCombatController.GetCommandQueue().IsCommandRunning()*/ mCombatController.AllAnimationsDone() ) // we have a hero selected
		{
			DisplayHeroHoverEffect( hitCell, hitCells, hitLocation, trueHitCell );
		}

		mGridDecal.UpdateGridDataRendering();
	}
}

simulated function SetArmyForeShadowedCells( bool ignoreUnits )
{
	local H7CombatMapCell cell;

	ResetSelectedAndReachableCells();

	mGrid.GetAllPlaceableCells( mTacticsPlaceableColumns, ignoreUnits, mReachableCells );
	foreach mReachableCells(cell)
	{
		cell.SetForeshadow( true );
	}
}

// mReachableCells = cells where the units can be deployed
simulated state Tactics
{
	simulated event BeginState(name previousStateName)
	{
		;
		SetArmyForeShadowedCells( false );
	}

	simulated event EndState(name nextStateName)
	{
		ResetSelectedAndReachableCells();
		;
	}

	simulated function DoCurrentUnitAction()
	{
		local H7Unit unitUnderMouse;
		//local Vector dummy;
		local H7IEffectTargetable target;

		target = mCurrentHoverTarget; //GetMouseOverTarget(dummy);
		if( H7CombatMapCell( target ) != none )
		{
			unitUnderMouse = H7CombatMapCell( target ).GetUnit();
		}
		else
		{
			unitUnderMouse = H7Unit( target );
		}
		;
		if(unitUnderMouse != none)
		{
			TacticsPickUnit(H7CreatureStack(unitUnderMouse));
		}
	}

	// called if picked up from map AND called if picked up from bar
	simulated function TacticsPickUnit( H7CreatureStack creatureStack )
	{
		local H7CreatureStack currentCreature;
		local array<H7CreatureStack> unitList;

		;

		unitList = class'H7CombatController'.static.GetInstance().GetUnitsForDeployment();

		// check if it is our creature we want to pick up!
		if( creatureStack != none && unitList.Find( creatureStack ) != -1 )
		{
			SelectUnit( creatureStack, false );

			class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().UnitWasPickedUp(creatureStack);

			// remove all the creatures from the cells because the picked unit can be placed anywhere
			foreach unitList( currentCreature )
			{
				if( currentCreature.IsVisible() )
				{
					currentCreature.RemoveCreatureFromCell();
				}
			}
			SetArmyForeShadowedCells( true );

			mCombatController.GetCursor().UpdateTacticsCursor(none);
			mCombatController.CheckStartable();
			mGridDecal.UpdateGridDataRendering();
		}
	}



	// called if released on map/grid/terrain/unreal    (releasedOnBar=false)
	// AND called if releases on bar                    (releasedOnBar=true)
	// AND called when dropped from slot->slot          (releasedOnBar=true)
	// NOT called when dropped on other hud elements
	simulated function TacticsReleaseUnit( optional bool releasedOnBar )
	{
		local bool canBePlaced;
		local H7CombatMapCell cell;
		local array<H7CombatMapCell> cells;
		local H7CreatureStack currentCreature;
		local array<H7CreatureStack> unitList;
		local int spawnedStackIndex, baseStackIndex, displacedBaseStackIndex;
		local H7BaseCreatureStack baseStack,displacedBaseStack;

		; 

		if( class'H7PlayerController'.static.GetPlayerController().IsMouseOverHUD() && !releasedOnBar )
		{
			// release over wrong hud elements; handled by flash, do nothing here
			// OPTIONAL this is never called, because release over wrong hud elements don't even reach this function
			// OPTIONAL also flash does nothing in this case, unit just stays on cursor
			;
			return;
		}

		if( mSelectedStack != none )
		{	
			// We have 3 cell arrays:
			// mMouseOverCells
			// mSelectedCells
			// mReachableCells

			spawnedStackIndex = mCombatController.GetCurrentlyDeployingArmy().GetCreatureStackIndex(mSelectedStack);
			spawnedStackIndex = spawnedStackIndex;
			;
			
			baseStack = mCombatController.GetCurrentlyDeployingArmy().GetBaseStackBySpawnedStack(mSelectedStack);
			baseStackIndex = mCombatController.GetCurrentlyDeployingArmy().GetBaseCreatureStackIndex(baseStack);
			;

			// let's use baseStackIndex as 'master identifier'

			// check if the creature can be placed on the mouseOver cells
			if(!releasedOnBar)
			{
				canBePlaced = mMouseOverCells.Length > 0;

				// clear the selected cells
				foreach mSelectedCells( cell ) 
				{
					cell.SetSelected( false );
				}

				mSelectedCells.Remove( 0, mSelectedCells.Length );

				if( mSelectedStack.GetUnitBaseSize() == CELLSIZE_1x1 )
				{
					canBePlaced = mMouseOverCells.Length >= 1;
				}
				else
				{
					canBePlaced = mMouseOverCells.Length >= 4;
				}
			}

			if( canBePlaced )
			{
				// set the creature on the new position on the 3d grid
				baseStack.SetDeployed(true);
				PlaceCreature( mMouseOverCells[0].GetCellPosition(), mSelectedStack );
				UpdateCreatureDeployment( mMouseOverCells[0].GetCellPosition(), mSelectedStack );
				mSelectedStack.Show();
				class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().MarkAsDeployed( baseStackIndex ); // todo from stack to index
			}
			else
			{
				// set the creature to deployment bar on the 2d gui
				baseStack.SetDeployed(false);
				mSelectedStack.RemoveStackFromGrid();
				mSelectedStack.GetCombatArmy().ResetCreatureDeployPos( baseStack );
				class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().MarkAsUnDeployed( baseStackIndex );
				class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().SetDehighlight( baseStackIndex );
				class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().ClearSelection();
				// designers don't want it, OPTIONAL fix it to not trigger outside grid to keep it
				//if(!class'H7PlayerController'.static.GetPlayerController().IsMouseOverHUD())
				//{
				//	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(`Localize("H7Combat","TACTICS_DEPLOY_FAIL","MMH7Game"),MD_SIDE_BAR);
				//}
			}

			if( mSelectedStack.GetCell() != none )
			{
				cells = mSelectedStack.GetCell().GetMergedCells();
			}

			// restore the rest of creatures to their original position, if the cell is occupied then we put the creature on the deployement bar
			unitList = class'H7CombatController'.static.GetInstance().GetUnitsForDeployment();
			foreach unitList( currentCreature )
			{
				if( currentCreature != mSelectedStack && currentCreature.IsVisible() )
				{
					if( cells.Find( mGrid.GetCellByIntPoint( currentCreature.GetGridPosition() ) ) != INDEX_NONE )
					{
						displacedBaseStack = mCombatController.GetCurrentlyDeployingArmy().GetBaseStackBySpawnedStack(currentCreature);
						displacedBaseStackIndex = mCombatController.GetCurrentlyDeployingArmy().GetBaseCreatureStackIndex(displacedBaseStack);
						displacedBaseStack.SetDeployed(false);
						currentCreature.RemoveStackFromGrid( false );
						//GetAuraManager().UpdateAuras();
						class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().MarkAsUnDeployed( displacedBaseStackIndex );
					}
					else if( CanPlaceCreature( currentCreature.GetGridPosition(), currentCreature ) )
					{
						PlaceCreature( currentCreature.GetGridPosition(), currentCreature );
					}
					else
					{
						displacedBaseStack = mCombatController.GetCurrentlyDeployingArmy().GetBaseStackBySpawnedStack(currentCreature);
						displacedBaseStackIndex = mCombatController.GetCurrentlyDeployingArmy().GetBaseCreatureStackIndex(displacedBaseStack);
						displacedBaseStack.SetDeployed(false);
						currentCreature.RemoveStackFromGrid();
						//GetAuraManager().UpdateAuras();
						class'H7CombatHudCntl'.static.GetInstance().GetDeploymentBar().MarkAsUnDeployed( displacedBaseStackIndex );
					}
				}
			}

			// clear the current selected creature
			ClearMouseOverCells();
			SelectUnit( none, false );
			SetArmyForeShadowedCells( false );
			mCombatController.GetCursor().UpdateTacticsCursor(none);
			mCombatController.CheckStartable();
			mGridDecal.UpdateGridDataRendering();
			class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy().GetDeployment().SetIsCustomized( true );
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
		}
	}

	simulated protected function UpdateGridState(H7CombatMapCell hitCell, array<H7CombatMapCell> hitCells, vector hitLocation, optional H7CombatMapCell trueHitCell )
	{
		DisplayHoverEffect(hitCell, hitCells);
		mGridDecal.UpdateGridDataRendering();
	}
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
