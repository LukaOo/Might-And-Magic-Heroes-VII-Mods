//=============================================================================
// H7CombatMapCell
//
//
// Showdebug pathfinder: shows the current pathfinder setup
// Showdebug cellstate:  Shows the states of the cells
//
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapCell extends H7BaseCell
	dependson(H7StructsAndEnumsNative)
	native;


// State g
var protected bool mIsMouseOver;
var protected bool mIsSelected;
var protected bool mIsSelectedEnemy;
var protected bool mIsSelectedAlly;
var protected bool mIsSelectedDeadAlly;
var protected bool mIsPassable;
var protected bool mIsWarfareBuffer;
var protected bool mIsGatePassage;
var protected bool mIsMerged;
var protected bool mIsMergedOn2ndLayer;	// 2nd layer for deas creaturestacks
var protected bool mIsForeshadow;
var protected bool mIsForeshadowAlt;    // foreshadow alternative
var protected bool mHasRemains;
var protected bool mForceHighlight;     // Cone cell highlight
var protected bool mForceEnemyHighlight;// Cone cell highlight
var protected bool mIsSiegeWallCover;
var protected bool mIsAbilityHighlight;
var protected bool mHasObstacleNearby;  // for random obstacle placement
var bool mRandomObstaclePlacementFlag;  // for random obstacle placement

// type of select (hover,selected,blocked) 
var protected ESelectionType mSelectionType; 

// each cell knows its neighbours
var protected array<H7CombatMapCell> mNeighbours;

// Merged Cells if the CellSize is larger than 1x1
var protected array<H7CombatMapCell> mMergedCells; 

// Merged Cells if the CellSize is larger than 1x1 for dead creature stacks
var protected array<H7CombatMapCell> mMergedCells2ndLayer; 

// size of the Cell depending on Creature that is placed on it
var protected ECellSize mCellSize<DisplayName=Base Size>;

// size of the Cell depending on Creature that is placed on it ( 2nd layer )
var protected ECellSize mCellSize2ndLayer;

// warfareunit that is in this cell (a big creature can be in more than one cell)
var protected H7WarUnit mWarUnit; 

// creature that is in this cell (a big creature can be in more than one cell)
var protected H7CreatureStack mCreatureStack; 

// creature that is in this cell (a big creature can be in more than one cell)
var protected H7CreatureStack mDeadCreatureStack; 

// obstacle that is in this cell (a big obstacle can be in more than one cell)
var protected H7CombatObstacleObject  mObstacle;

// to know who handles the rendering for sizes bigger than 1x1 on mouse over
var protected H7CombatMapCell mMouseOverMaster;

// to know who handles the rendering for sizes bigger than 1x1
var protected H7CombatMapCell mMaster;

// to know who handles the rendering for sizes bigger than 1x1
var protected H7CombatMapCell mMaster2ndLayer;

// only the master will render the mouseover decal, the rest will render nothing (-1 AOE, 0 is not the master, 1 = master size 1, 2 = master size 2, etc..)
var protectedwrite int mIsMouseOverMaster;

// decal used to show the graphical state of the cell
var protected DecalComponent mDecal;

// decal used to show the graphical state of the cell, only for the cover system
var protected DecalComponent mCoverDecal;

// position offset injected to each decals
var protected Vector mDecalOffset;

// precalculated center position for any size
var protected array<Vector> mCenterPosition;

// AI helpers
// - calculated threat-level for current unit
var protected float mThreat;
// - calculated opertunity values for current unit
var protected float mOpportunity;

var protected MaterialInterface mMaterial;
var protected DynamicLightEnvironmentComponent mDynamicLightEnv;

// Static Mesh for creature remains
var protected DynamicSMActor_Spawnable mDynamicStaticMeshActor;
var protected H7FracturedDynMeshActor mFracturedStaticMeshActor;
var protected EmitterSpawnable mEmitterActor;

var protectedwrite H7CombatMapGridController mGridController;
var protected H7CombatController mCombatController;

// variables to improve the performance
var protected bool mHasObstacle;
var protected bool mHasCreatureStack;
var protected bool mHasWarUnit;

function H7AbilityManager			GetAbilityManager()				        { return mGridController.GetAbilityManager(); }
function H7BuffManager				GetBuffManager()				        { return mGridController.GetBuffManager(); }
native function H7EventManager      GetEventManager();
function H7EffectManager            GetEffectManager()                      { return mGridController.GetEffectManager(); }
function                            DataChanged(optional String cause)      { }

function                            PrepareAbility(H7BaseAbility ability)			{ mGridController.PrepareAbility( ability ); }
function                            UsePreparedAbility(H7IEffectTargetable target)  { mGridController.UsePreparedAbility( target ); }
function H7BaseAbility              GetPreparedAbility()                            { return mGridController.GetPreparedAbility(); }
function                            SetForceHighlight(bool value)                   { mForceHighlight = value; }
function bool                       GetForceHightlight()                            { return mForceHighlight; }
function                            SetForceEnemyHightlight(bool value)             { mForceEnemyHighlight = value; }
function bool                       GetForceEnemyHightlight()                       { return mForceEnemyHighlight; }


/////////////////////////
/// properties 
/////////////////////////
native function bool HasAIDanger( H7CreatureStack creatureStack );

function float  GetThreat() { return mThreat; }
function        SetThreat( float threat ) { mThreat=threat; }
function        ModifyThreat( float threatMod ) { mThreat+=threatMod; }
function float  GetOpportunity() { return mOpportunity; }
function        SetOpportunity( float op ) { mOpportunity=op; }
function        ModifyOpportunity( float opMod ) { mOpportunity+=opMod; }
function bool   IsMerged()       { return mIsMerged; }

function bool   HasObstacleNearby()                 { return mHasObstacleNearby; }
function        SetHasObstacleNearby( bool val )    { mHasObstacleNearby = val; }

native function bool   HasActiveAura();

//function DecalComponent  GetDecal() { return mDecal; }
// used for the siege map cover system (cells that are behind the walls are cover cells)
function bool   IsSiegeWallCover() { return mIsSiegeWallCover; }
function        SetSiegeWallCover( bool isSiegeWallCover ) { mIsSiegeWallCover = isSiegeWallCover; UpdateSelectionType(); }

// used for the line of sight cover system
//function        SetHiddenCoverDecal( bool newHidden ) { mCoverDecal.SetHidden( newHidden ); }

function array<H7CombatMapCell> GetNeighbours() { return mNeighbours; }
function SetNeighbours( array<H7CombatMapCell> newNeighbours ) { mNeighbours = newNeighbours; }

function array<H7CombatMapCell> GetMergedCells() { return mMergedCells; }
function SetMergedCells( array<H7CombatMapCell> newMergedCells ) { mMergedCells = newMergedCells; mIsMerged = mMergedCells.Length > 1; }

function H7CombatMapCell GetMaster() { return mMaster; }
function SetMaster( H7CombatMapCell newMaster ) { mMaster = newMaster; }

function array<H7CombatMapCell> GetMergedCells2ndLayer() { return mMergedCells2ndLayer; }
function SetMergedCells2ndLayer( array<H7CombatMapCell> newMergedCells ) { mMergedCells2ndLayer = newMergedCells; mIsMergedOn2ndLayer = mMergedCells2ndLayer.Length > 1; }

function H7CombatMapCell GetMaster2ndLayer() { return mMaster2ndLayer; }
function SetMaster2ndLayer( H7CombatMapCell newMaster ) { mMaster2ndLayer = newMaster; }

function ECellSize GetCellSize() { return mCellSize; }
function SetCellSize( ECellSize newCellSize ) { mCellSize = newCellSize; }

function ECellSize GetCellSize2ndLayer() { return mCellSize2ndLayer; }
function SetCellSize2ndLayer( ECellSize newCellSize ) { mCellSize2ndLayer =  newCellSize; }

function Vector GetPosition1x1() { return mWorldCenter; }

function ESelectionType GetSelectionType() { return mSelectionType; }
function SetSelectionType( ESelectionType  newSelectionType ) { mSelectionType = newSelectionType; }

function bool IsPassable() { return mIsPassable; }
function SetPassable( bool newIsPassable ) { mIsPassable = newIsPassable; UpdateSelectionType(); }

function bool IsWarfareBuffer() { return mIsWarfareBuffer; }
function SetWarfareBuffer( bool val ) { mIsWarfareBuffer = val; }

function bool IsGatePassage() { return mIsGatePassage; }
function SetGatePassage( bool p ) { mIsGatePassage=p; }

function bool HasObstacle() { return mHasObstacle; }
event H7CombatObstacleObject GetObstacle() { return mMaster==self ? mObstacle : mMaster.GetObstacle(); }

native function H7CreatureStack GetCreatureStack();
function bool HasCreatureStack() { return mHasCreatureStack; }

// Check if one of my slave cells has alive creature standing on it (2nd layer)
native function bool SlaveHasCreatureStack();

function bool HasWarfareUnit() { return mHasWarUnit; }
function H7WarUnit GetWarfareUnit() { return mMaster==self ? mWarUnit : mMaster.GetWarfareUnit(); }

function H7CreatureStack GetDeadCreatureStack() { return mMaster2ndLayer==self ? mDeadCreatureStack : mMaster2ndLayer.GetDeadCreatureStack(); } 
function bool HasDeadCreatureStack() { return GetDeadCreatureStack() != none; }

function bool HasRemains() { return mHasRemains; }

function bool IsSelected() { return mIsSelected; }

function SetForeshadow(bool newIsForeshadow, optional bool updateMat = true ) { mIsForeshadow = newIsForeshadow; if( updateMat )UpdateSelectionType(); }
function bool IsForeshadow() { return mIsForeshadow; }

function SetAbilityHighlight( bool highlight ) { mIsAbilityHighlight = highlight; UpdateSelectionType(); }
function bool IsAbilityHighlight() { return mIsAbilityHighlight; }

function SetForeshadowAlt(bool newIsForeshadowAlt) { mIsForeshadowAlt = newIsForeshadowAlt; UpdateSelectionType(); }
function bool IsForeshadowAlt() { return mIsForeshadowAlt; }

function SetSelectedMergedAlly(bool newIsSelected) { SetSelectedMerged(newIsSelected, SELECTED_ALLY); }
function SetSelectedMergedDeadAlly(bool newIsSelected) { SetSelectedMerged(newIsSelected, SELECTED_DEAD_ALLY); }
function SetSelectedMergedEnemy(bool newIsSelected) { SetSelectedMerged(newIsSelected, SELECTED_ENEMY); }

//Is slave of passed cell on any layer (returns true even when 
native function bool IsSlaveOf(H7CombatMapCell cell);

///////////////////////
/// functions
///////////////////////

function Init( H7CombatMapGridController gridController )
{
	local Vector centerPos;
	local int i;
	local Vector hitNormal, downVector;
	local TraceHitInfo hitData;

	mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();

	SetMaster( self );
	SetMaster2ndLayer( self );

	mGridController = gridController;

	// TEMPORARY UNTIL ADRIEN FIX THE PRECALCULATED POS OF THE CELLS IN THE EDITOR
	downVector.x = 0.0f;
	downVector.y = 0.0f;
	downVector.Z = -16384.f;
	mWorldCenter.z += 1000.0f;

	if (gridController.Trace( mWorldCenter, hitNormal, mWorldCenter + downVector, mWorldCenter,,, hitData ) == none)
	{
		;
	}

	//if( mDecal != None )
	//{
	//	mDecal.Location = mWorldCenter + mDecalOffset;
	//	mDecal.Orientation = Rotator(Vect(0,0,-0.1));
	//	mGridController.AttachComponent( mDecal );
	//}

	//if( mCoverDecal != None )
	//{
	//	mCoverDecal.Location = mWorldCenter + mDecalOffset;
	//	mCoverDecal.Orientation = Rotator(Vect(0,0,-0.1));
	//	mCoverDecal.SetHidden( true );
	//	mGridController.AttachComponent( mCoverDecal );
	//}

	// set for all possible cell sizes ...
	for( i=0; i<= CELLSIZE_MAX; i++ )
	{
		centerPos.X = mWorldCenter.X + CELL_SIZE * 0.5f * (GetWidthFromSize(ECellSize(i)) - 1.0f);
		centerPos.Y = mWorldCenter.Y + CELL_SIZE * 0.5f * (GetHeightFromSize(ECellSize(i)) - 1.0f);
		centerPos.Z = mWorldCenter.Z;
		mCenterPosition.AddItem( centerPos );
	}

	UpdateSelectionType();
}

function SetSelected(bool newIsSelected)
{
	mIsSelectedAlly = false;
	mIsSelectedEnemy = false;
	mIsSelectedDeadAlly = false;
	mIsSelected = newIsSelected; 
	UpdateSelectionType(); 
}

function SetSelectedEnemy(bool newIsSelected)
{ 
	mIsSelectedAlly = false;
	mIsSelected = false;
	mIsSelectedDeadAlly = false;
	mIsSelectedEnemy = newIsSelected;
	UpdateSelectionType(); 
}

function SetSelectedAlly(bool newIsSelected)
{ 
	mIsSelectedEnemy = false;
	mIsSelected = false; 
	mIsSelectedAlly = newIsSelected;
	mIsSelectedDeadAlly = false;
	UpdateSelectionType(); 
}

function SetSelectedDeadAlly(bool newIsSelected)
{ 
	mIsSelectedEnemy = false;
	mIsSelected = false; 
	mIsSelectedDeadAlly = newIsSelected;
	mIsSelectedAlly = false;
	UpdateSelectionType(); 
}

function bool HasCreatureStackOnDeadStack()
{
	local H7CombatMapCell cell; 
	local array<H7CombatMapCell> cells;

	cells = GetMergedCells2ndLayer();

	foreach cells (  cell ) 
	{
		if( cell.HasCreatureStack() )
		{
			return true;
		}
	}

	return false;
} 

function IntPoint GetGridDistanceTo( H7CombatMapCell targetCell )
{
	local IntPoint distGP;
	distGP.X = 0;
	distGP.Y = 0;
	if( targetCell != None )
	{
		distGP.X = GetCellPosition().X - targetCell.GetCellPosition().X;
		distGP.Y = GetCellPosition().Y - targetCell.GetCellPosition().Y;
	}
	return distGP;
}

function Vector GetCenterByCreatureDim(int creatureDim) //override
{
	local Vector center;
	center = mCenterPosition[0];
	center.X += (creatureDim-1)*CELL_SIZE/2;
	center.Y += (creatureDim-1)*CELL_SIZE/2;
	center.Z = 0.f;
	return center;
}

function SetDying( bool value ) 
{ 
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;

	cells = GetMergedCells2ndLayer();
	foreach cells ( cell ) 
	{
		cell.SetPassable( !value );
	} 
}

function SetSelectedMerged(bool newIsSelected, optional ESelectionType type = SELECTED)
{ 
	local H7CombatMapCell selectedCell;
	local array<H7CombatMapCell> cells;
	
	
	
	if( type == SELECTED_DEAD_ALLY )
	{
		cells = GetMergedCells2ndLayer();
	}
	else
	{
		cells = GetMergedCells();
	}
	
	foreach cells(selectedCell) 
	{
		if(type == SELECTED_ALLY)
		{
			selectedCell.SetSelectedAlly( newIsSelected );
		}
		else if (type == SELECTED_DEAD_ALLY && newIsSelected)
		{
			selectedCell.SetSelectedDeadAlly( newIsSelected );
		}
		else if( type == SELECTED_ENEMY)
		{
			selectedCell.SetSelectedEnemy( newIsSelected );
		}
		else
		{
			selectedCell.SetSelected( newIsSelected );
		}
	}
}

function SetMouseOver( bool newIsMouseOver, optional int isMouseOverMaster = 0, optional H7CombatMapCell mouseOverMaster = none ) 
{
	mIsMouseOver = newIsMouseOver;
	mIsMouseOverMaster = isMouseOverMaster;
	mMouseOverMaster = mouseOverMaster;
	UpdateSelectionType();
}

function SetCreatureStack( H7CreatureStack newCreatureStack ) 
{
	if( mDeadCreatureStack == newCreatureStack ) return;

	mHasCreatureStack = true;
	if( mMaster == self )
	{
		mCreatureStack = newCreatureStack;
	}
	else
	{
		mMaster.SetCreatureStack( newCreatureStack );
	}
	UpdateSelectionType();
}

function SetWarfareUnit( H7WarUnit warUnit ) 
{
	mHasWarUnit = true;
	if( mMaster == self )
	{
		mWarUnit = warUnit;
		SetPassable( true );
	}
	else
	{
		mMaster.SetWarfareUnit( warUnit );
		mMaster.SetPassable( true );
	}
	UpdateSelectionType();
}


function SetObstacle( H7CombatObstacleObject newObstacle ) 
{
	if( newObstacle.GetObstacleType() != OT_MOAT )
	{
		mHasObstacle = true;
	}
	if( mMaster == self )
	{
		mObstacle = newObstacle;
	}
	else
	{
		mMaster.SetObstacle( newObstacle );
	}
	UpdateSelectionType();
}

function SetDeadCreatureStack( H7CreatureStack newDeadCreatureStack ) 
{
	if( mMaster2ndLayer== self )
	{
		mDeadCreatureStack  = newDeadCreatureStack;
	}
	else
	{
		mMaster2ndLayer.SetDeadCreatureStack( newDeadCreatureStack );
	}
	
	UpdateSelectionType();
}

function float GetWidthFromSize( ECellSize size )
{
	switch(size)
	{
		case CELLSIZE_1x2:
		case CELLSIZE_1x1:
		case CELLSIZE_1x4: return 1.0f;
		case CELLSIZE_2x2: return 2.0f;
	}
	return 1.0f;
}

function float GetHeightFromSize( ECellSize size )
{
	switch(size)
	{
		case CELLSIZE_1x1: return 1.0f;
		case CELLSIZE_1x2:
		case CELLSIZE_2x2: return 2.0f;
		case CELLSIZE_1x4: return 4.0f;
	}
	return 1.0f;
}

function HideRemains( bool value ) 
{
	if( GetMaster2ndLayer().mDynamicStaticMeshActor != None ) 
		GetMaster2ndLayer().mDynamicStaticMeshActor.SetHidden( value );

	if (GetMaster2ndLayer().mFracturedStaticMeshActor != None)
		GetMaster2ndLayer().mFracturedStaticMeshActor.SetHidden( value );

	if (GetMaster2ndLayer().mEmitterActor != None)
		GetMaster2ndLayer().mEmitterActor.SetHidden ( value );
}

/**
 * spawns a Static Mesh or a FracturedStaticMesh for the remains of a creature 
 **/
function SpawnCreatureRemains()
{
	if( GetDeadCreatureStack() != none && GetDeadCreatureStack().GetCreature().GetVisuals().GetCreatureRemains() != none )
	{
		if (FracturedStaticMeshComponent(GetDeadCreatureStack().GetCreature().GetVisuals().GetCreatureRemains()) != none)
		{
			mFracturedStaticMeshActor = mGridController.Spawn( class'H7FracturedDynMeshActor',GetDeadCreatureStack(),, GetDeadCreatureStack().GetCreature().Location, GetDeadCreatureStack().GetCreature().Rotation, , true);
			
			mFracturedStaticMeshActor.FracturedStaticMeshComponent.SetTranslation( GetDeadCreatureStack().GetCreature().GetVisuals().GetCreatureRemains().Translation );
			mFracturedStaticMeshActor.FracturedStaticMeshComponent.SetStaticMesh( GetDeadCreatureStack().GetCreature().GetVisuals().GetCreatureRemains().StaticMesh );
			mFracturedStaticMeshActor.FracturedStaticMeshComponent.SetRotation( Rot(0,-16384,0) + GetDeadCreatureStack().GetCreature().GetVisuals().GetCreatureRemains().Rotation );
			mFracturedStaticMeshActor.SetDrawScale( GetDeadCreatureStack().GetCreature().GetVisuals().GetSkeletalMesh().Scale );

			mFracturedStaticMeshActor.ResetHealth();
			mFracturedStaticMeshActor.FractureInterpolated(3.0f, GetDeadCreatureStack().GetCreature().Location, Vect(-100,0,0), none);
		}
		else
		{
			mDynamicStaticMeshActor = mGridController.Spawn( class'DynamicSMActor_Spawnable',GetDeadCreatureStack(),, GetCenterPosFor2ndLayer() );
			mDynamicStaticMeshActor.SetStaticMesh( GetDeadCreatureStack().GetCreature().GetVisuals().GetCreatureRemains().StaticMesh ); 
			mDynamicStaticMeshActor.StaticMeshComponent.SetAbsolute( false, true, true );
		}
		mHasRemains = true;
	}
	if ( GetDeadCreatureStack() != none && GetDeadCreatureStack().GetCreature().GetVisuals().GetDeathParticle() != none )
	{
		mEmitterActor = mGridController.Spawn(class'EmitterSpawnable', GetDeadCreatureStack(),, GetDeadCreatureStack().GetCreature().Location + GetDeadCreatureStack().GetCreature().GetVisuals().GetDeathParticleOffeset(), GetDeadCreatureStack().GetCreature().Rotation, , true);
		if (mEmitterActor != None)
		{
			mEmitterActor.SetTickIsDisabled(false); //somehow needed to make it tick
			mEmitterActor.ParticleSystemComponent.SetTemplate( GetDeadCreatureStack().GetCreature().GetVisuals().GetDeathParticle());
		}
		mHasRemains = true;
	}

	// release lock for this cell
	SetDying( false );
}

/**
 * delete creatue remains  
 **/
function DespawnCreatureRemains()
{
	if( mDynamicStaticMeshActor != none )
	{
		mDynamicStaticMeshActor.Destroy();
	}
	if ( mFracturedStaticMeshActor != none)
	{
		mFracturedStaticMeshActor.Destroy();
	}
	if ( mEmitterActor != none)
	{
		mEmitterActor.Destroy();
	}
	mHasRemains = false;
}


native function Vector GetCenterPos();
native function Vector GetCenterPosFor2ndLayer();
native function Vector GetCenterPosBySize( ECellSize size, optional bool useMaster = true, optional bool use2ndLayer = false );

/** Blocked = not passable or a creature occupies the cell, ignoreCreatureStack can be none if we dont need to ignore a creature stack */
native function bool IsBlocked( H7CreatureStack ignoreCreatureStack );


/** Sets the new material of the decal depending of the current state of the cell */
function UpdateSelectionType()
{
	if( mCombatController == none )
	{
		mCombatController = class'H7CombatController'.static.GetInstance();
		
		if( mCombatController == none )
		{
			return; // combat controller doesnt exist yet
		}
	}

	if( !mIsPassable || mIsWarfareBuffer )
	{
		mSelectionType = OBSTACLE;
	}
	else if( mIsAbilityHighlight && !HasCreatureStack() && !HasWarfareUnit() )
	{
		mSelectionType = FORESHADOW_ABILITY;
	}
	else if( (mIsForeshadow || mIsForeshadowAlt) && !HasCreatureStack() && !HasWarfareUnit() && !mIsMouseOver ) 
	{
		if( mIsForeshadow && mIsForeshadowAlt )
		{
			mSelectionType = FORESHADOW_BOTH;
		}
		else if( mIsForeshadow )
		{
			if( mCombatController.GetActiveArmy().GetPlayer().GetPlayerType() != PLAYER_AI )
			{
				mSelectionType = FORESHADOW;
			}
		}
		else
		{
			mSelectionType = FORESHADOW_ALT;
		}
	}
	else if( mIsMouseOver && mIsForeshadow && (!mIsSelected || mMaster != self) && !HasWarfareUnit() )
	{
		mSelectionType = MOUSE_OVER;
	}
	else if( mIsSelected )
	{
		mSelectionType = SELECTED;
	}
	else if( mIsSelectedAlly )
	{
		mSelectionType = SELECTED_ALLY;
	}
	else if( mIsSelectedEnemy )
	{
		mSelectionType = SELECTED_ENEMY;
	}
	else if( mIsMouseOver && mIsMouseOverMaster == -1 ) // AOE abilities
	{
		if( mHasCreatureStack || mHasWarUnit )
		{
			if( !mCombatController.GetActiveUnit().GetPreparedAbility().CanCastOnTargetActor( GetTargetable() ) )
			{
				if( mForceHighlight ) 
				{
					mSelectionType = MOUSE_OVER;
				}
				else
				{
					mSelectionType = NORMAL;
				}
			}
			else 
			{
			   if( mForceEnemyHighlight )
			   {
				   mSelectionType = SELECTED_ENEMY;
			   }
			}
		}
		else
		{
			mSelectionType = MOUSE_OVER;
		}
	}
	else if( mHasCreatureStack && mCombatController.IsInTacticsPhase() && GetCreatureStack().GetPlayer() == mCombatController.GetCurrentlyDeployingArmy().GetPlayer() )
	{
		mSelectionType = CREATURE_TACTICS;
	}
	else if ( mIsSelectedDeadAlly )
	{
		mSelectionType = SELECTED_DEAD_ALLY;
	}
	else if ( mIsSiegeWallCover )
	{
		mSelectionType = SIEGEWALL_COVER;
	}
	else 
	{
		mSelectionType = NORMAL;
	}
}


native function GetCellsHitByCellSizeXY( int cellX, int cellY, out array<H7CombatMapCell> activeCells, optional bool cleanNoneCells = false );
native function GetCellsHitByCellSize( ECellSize cellSize, out array<H7CombatMapCell> activeCells, optional bool cleanNoneCells = false );

function PlaceCreature( H7CreatureStack creatureStack, optional bool isCreatureMoving = false ) 
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;
	local H7EventContainerStruct container;

	GetCellsHitByCellSize( creatureStack.GetUnitBaseSize(), cells );

	foreach cells( cell )
	{
		cell.SetCellSize( creatureStack.GetUnitBaseSize() );
		cell.SetMaster( self );
		cell.SetCreatureStack( creatureStack ); 
		cell.SetMergedCells( cells );
	}

	container.Targetable = GetCreatureStack();
	container.TargetableTargets.AddItem( GetCreatureStack() );
	
	creatureStack.TriggerEvents( ON_ENTER_CELL, false, container );

	if(!isCreatureMoving)
	{
		creatureStack.TriggerEvents( ON_GRID_POSITION_CHANGED, false );
		if( creatureStack.IsRanged() )
		{
			creatureStack.PrepareDefaultAbility();
		}
		mCombatController.RaiseEvent( ON_ANY_CREATURE_MOVE, false );
	}

	mGridController.GetAuraManager().UpdateAuras( isCreatureMoving );
}

function PlaceWarfareUnit( H7WarUnit warUnit ) 
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;

	GetCellsHitByCellSize( CELLSIZE_2x2, cells );
	foreach cells( cell )
	{
		cell.SetCellSize( CELLSIZE_2x2 );
		cell.SetMaster( self );
		cell.SetWarfareUnit( warUnit ); 
		cell.SetMergedCells( cells );
	}
}

native function bool HasPassableAllies( H7CreatureStack creatureStack );

function PlaceDeadCreature( H7CreatureStack creatureStack ) 
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;

	GetCellsHitByCellSize( creatureStack.GetUnitBaseSize(), cells );
	foreach cells( cell )
	{
		// this is my grave, go away old fart
		if( cell.HasDeadCreatureStack() )
		{
			cell.GetDeadCreatureStack().BeRevived( false );
			cell.GetMaster2ndLayer().DespawnCreatureRemains();
			cell.RemoveDeadCreatureStack();
		}
		cell.SetCellSize2ndLayer( creatureStack.GetUnitBaseSize() );
		cell.SetMaster2ndLayer( self );
		cell.SetDeadCreatureStack( creatureStack ); 
		cell.SetMergedCells2ndLayer( cells );

	}

	mIsSelectedDeadAlly = true;
}

function PlaceObstacle( H7CombatObstacleObject obstacleToPlace ) 
{
	local array<H7CombatMapCell> cells;
	local H7CombatMapCell cell;
	local int sizeX, sizeY;
	local IntPoint gpOffset;

	sizeX = obstacleToPlace.GetObstacleBaseSizeX();
	sizeY = obstacleToPlace.GetObstacleBaseSizeY();

	GetCellsHitByCellSizeXY( sizeX, sizeY, cells );
	foreach cells( cell )
	{
		cell.SetCellSize( CELLSIZE_1x1 );
		cell.SetMaster( self );
		cell.SetObstacle( obstacleToPlace ); 
		cell.SetMergedCells( cells );
		cell.SetPassable( false );
		cell.SetGatePassage( false );
	}

	if( obstacleToPlace.GetObstacleType() == OT_GATE )
	{
		foreach cells( cell )
		{
			gpOffset = cell.GetGridDistanceTo(self);
			// gate passage is the middle 2x2 block (gates are 2x4)
			if( gpOffset.Y>=1 && gpOffset.Y<=2 )
			{
				cell.SetPassable( true );
				cell.SetGatePassage( true );
			}
		}
	}
	else if( obstacleToPlace.GetObstacleType() == OT_MOAT || obstacleToPlace.GetObstacleType() == OT_TRAP )
	{
		foreach cells( cell )
		{
			cell.SetPassable( true );
		}
	}
}

function native bool CanPlaceCreatureStack( H7CreatureStack creatureStack );

function RemoveObstacles()
{
	local H7CombatMapCell cell;
	
	if( mMaster == self )
	{
		foreach mMergedCells( cell )
		{
			if( GetObstacle() != none && GetObstacle().GetObstacleType() == OT_GATE && !cell.IsGatePassage() )
			{
				continue;
			}

			if( cell != self )
			{
				cell.RemoveObstacle();
			}
		}
	}
	else
	{
		if( GetObstacle() == none || GetObstacle().GetObstacleType() != OT_GATE || cell.IsGatePassage() )
		{
			mMaster.RemoveObstacle();
		}
	}

	if( GetObstacle() == none || GetObstacle().GetObstacleType() != OT_GATE || cell.IsGatePassage() )
	{
		RemoveObstacle();
	}
}

protected function RemoveObstacle()
{
	mMergedCells.Remove( 0, mMergedCells.Length );
	mIsMerged = false;
	mObstacle = none;
	mIsPassable = true;
	mCellSize = CELLSIZE_1x1;
	mMaster = self;
	mIsGatePassage= false;
	UpdateSelectionType();
	mHasObstacle = false;
}


// removes the creature from all the cells where is placed
function RemoveCreatureStack()
{
	local H7CombatMapCell cell;
	local H7EventContainerStruct container;

	if( GetCreatureStack() == none ) return;

	container.Targetable = GetCreatureStack();
	container.TargetableTargets.AddItem( GetCreatureStack() );

	GetCreatureStack().TriggerEvents( ON_LEAVE_CELL, false, container );

	if( mMaster == self )
	{
		foreach mMergedCells( cell )
		{
			if( cell != self )
			{
				cell.RemoveCreature();
				cell.SetForeshadow( false );
			}
		}
	}
	else
	{
		mMaster.RemoveCreature();
	}
	
	RemoveCreature();
}

// removes the warfare unit from all the cells where is placed
function RemoveWarfareUnit()
{
	local H7CombatMapCell cell;

	if( GetWarfareUnit() == none ) return;

	// TODO: investigate if necessary for warunits
	GetWarfareUnit().TriggerEvents( ON_LEAVE_CELL, false );

	if( mMaster == self )
	{
		foreach mMergedCells( cell )
		{
			if( cell != self )
			{
				cell.RemoveWarfare();
				cell.SetForeshadow( false );
			}
		}
	}
	else
	{
		mMaster.RemoveWarfare();
	}
	
	RemoveWarfare();
}


function RemoveDeadCreatureStack()
{
	local H7CombatMapCell cell;

	if( mMaster2ndLayer == self )
	{
		foreach mMergedCells2ndLayer( cell )
		{
			if( cell != self )
			{
				cell.RemoveDeadCreature();
			}
		}
	}
	else
	{
		mMaster2ndLayer.RemoveDeadCreature();
	}
	
	RemoveDeadCreature();
}

protected function RemoveCreature()
{
	mMergedCells.Remove( 0, mMergedCells.Length );
	mIsMerged = false;
	mCreatureStack = none;
	mCellSize = CELLSIZE_1x1;
	mMaster = self;
	mHasCreatureStack = false;
	UpdateSelectionType();
}

protected function RemoveWarfare()
{
	mMergedCells.Remove( 0, mMergedCells.Length );
	mIsMerged = false;
	mWarUnit = none;
	mCellSize = CELLSIZE_1x1;
	mMaster = self;
	mHasWarUnit = false;
	mIsPassable = false;
	UpdateSelectionType();
}

protected function RemoveDeadCreature()
{
	mMergedCells2ndLayer.Remove( 0, mMergedCells2ndLayer.Length );
	mIsMergedOn2ndLayer = false;
	mDeadCreatureStack = none;
	mCellSize2ndLayer = CELLSIZE_1x1;
	mMaster2ndLayer = self;
	mIsSelectedDeadAlly = false;
	UpdateSelectionType();
}

function H7IEffectTargetable GetTargetable()
{
	if( mMaster == self )
	{
		if( mCreatureStack != none )
		{
			return mCreatureStack;
		}
		else if( mDeadCreatureStack != none && !SlaveHasCreatureStack() )
		{
			return mDeadCreatureStack;
		}
		else if( mMaster2ndLayer != none && !SlaveHasCreatureStack() && mMaster2ndLayer.GetDeadCreatureStack() != none )
		{
			return mMaster2ndLayer.GetDeadCreatureStack();
		}
		else if( mObstacle != none && mObstacle.GetObstacleType() != OT_MOAT )
		{
			return mObstacle;
		}

		if( mWarUnit != none )
		{
			return mWarUnit;
		}
		else
		{
			return self;
		}
	}
	else
	{
		return mMaster.GetTargetable();
	}
}

native function H7Unit GetUnit();

function bool HasUnit()
{
	return mHasCreatureStack || mHasWarUnit;
}

function RenderDebugCellStateInfo( Canvas myCanvas, int version )
{
	local Color lTextColor, lBgColor;
	local Font lTextFont;
	local Vector lTextLocation;
	local Vector CellWorldPosition;
	local float lTextLength, lTextHeight;
	local string displayText;
	local H7CombatMapCell cell;

	lTextColor.A = 255.0f;

	lBgColor.R = 255.0f;
	lBgColor.G = 255.0f;
	lBgColor.B = 255.0f;
	lBgColor.A = 255.0f;

	lTextFont = Font'enginefonts.TinyFont';
	myCanvas.Font = lTextFont;
	myCanvas.DrawColor = lTextColor;
	
	CellWorldPosition = mWorldCenter;

	// cell states
	if( version == 0 )
	{
		displayText = "MO" @ mIsMouseOver @  "S" @ mIsSelected @ "M" @ mIsMerged @ "F" @ mIsForeshadow @ "A" @ mIsForeshadowAlt @ mSelectionType @ mCellSize @ mIsMouseOverMaster;
	}
	else if( version  == 1 )
	{
		displayText = "SE" @ mIsSelectedEnemy @  "SA" @ mIsSelectedAlly @ "P" @ mIsPassable @ "N" @ mNeighbours.Length @ mObstacle;
	}
	else
	{
		displayText = mCellSize @  "C" @ mCreatureStack @ "M" @ mMergedCells.Length @ mMaster @ ":";
		foreach mMergedCells( cell )
		{
			displayText = displayText @ cell;
		}
	}

	myCanvas.StrLen( displayText, lTextLength, lTextHeight );
	lTextLocation = myCanvas.Project( CellWorldPosition );
	lTextLocation.X -= lTextLength / 2;

	myCanvas.SetPos( lTextLocation.X, lTextLocation.Y );
	myCanvas.DrawColor = lBgColor;
	myCanvas.DrawRect(lTextLength, lTextHeight);
	
	myCanvas.SetPos( lTextLocation.X, lTextLocation.Y );
	myCanvas.DrawColor = lTextColor;
	myCanvas.DrawText( displayText );
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
// (cpptext)
// (cpptext)
// (cpptext)
