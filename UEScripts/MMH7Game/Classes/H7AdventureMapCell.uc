//=============================================================================
// H7AdventureMapCell
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureMapCell extends H7EditorAdventureTile
	dependsOn( H7AdventureArmy )
	native;

/**
 * Holds info about an H7AdventureMapCell's pathfinding data.
 * 
 * 
 * @var gScore                 Tile cost in amount of cells we need to cross
 * @var fScore                 Tile cost with heuristic and amount of cells
 * @var canMoveLand                If we can move to a land cell. (3 states: -1 - Do not know; 0 - Cannot move; 1 - Can move
 * @var canMoveWater           If we can move to a water cell. (3 states: -1 - Do not know; 0 - Cannot move; 1 - Can move
 * @var isAccessibleByShip                If the cell is accessible by ship
 * @var mPathfinderPrevious     Breadcrumb trail (following all the previous cells lead to pathfinder start cell)
 */
struct native CellPathfinderData
{
	var float aiDistance;

	var float gScore;
	var float fScore;
	var int canMoveLand;
	var int canMoveWater;
	var bool isAccessibleByShip;
	var bool isClosed;
	var bool opened;
	var H7AdventureMapCell previousCell;
	var int openListCellIndex;
};

// grid that contains this cell
var protected H7AdventureMapGridController mGridOwner;

// each cell knows its neighbours
var protected transient array<H7AdventureMapCell> mNeighbours;

var protected bool mHasPickable;
var protectedwrite CellPathfinderData mPathfinderData;
var protectedwrite bool mIsDeepWater;
var protected H7AdventureMapCell mWayPoint;
var protected array<H7AdventureMapCell> mWayPointNeighbours; // only filled if this is a waypoint

// army that occupies the cell
var protected H7AdventureArmy mAdvArmy;
/** Army that controls the ZoC **/
var protected array<H7AdventureArmy> mControllingArmies;
// ship that occupies the cell
var protected H7Ship mShip;
// adventure object on top of the cell
var protected H7AdventureObject mAdventureObject;// teleporter with this cell as an entrance
var protected H7Teleporter mTeleporter;
function bool                       IsTeleporterEntrance()                  { return mTeleporter != none; }
function H7Teleporter               GetTeleporter()                         { return mTeleporter; }
function                            SetTeleporter( H7Teleporter porter )    { mTeleporter = porter; }

function bool                       HasPickable()                           { return mHasPickable; }

function String                     GetName()                               { return "Cell at"@mPosition.X@mPosition.Y@"on grid"@mGridOwner.GetIndex(); }

function H7AdventureObject          GetAdventureObject()                    { return mAdventureObject; }
function	                        SetAdventureObject( H7AdventureObject o){ mAdventureObject = o; }

function array<H7AdventureArmy>     GetControllingArmies()                      { return mControllingArmies; }
function                            AddControllingArmy( H7AdventureArmy a )     { if( mControllingArmies.Find( a ) == INDEX_NONE ) { mControllingArmies.AddItem( a ); } }
function                            RemoveControllingArmy( H7AdventureArmy a )  { mControllingArmies.RemoveItem( a ); }

function H7AbilityManager			GetAbilityManager()				        { return mGridOwner.GetAbilityManager(); }
function H7BuffManager				GetBuffManager()				        { return mGridOwner.GetBuffManager(); }
native function H7EventManager      GetEventManager();
function H7EffectManager            GetEffectManager()                      { return mGridOwner.GetEffectManager(); }
function                            DataChanged(optional String cause)      { }

function                            PrepareAbility(H7BaseAbility ability)			{ mGridOwner.PrepareAbility( ability ); }
function                            UsePreparedAbility(H7IEffectTargetable target)  { mGridOwner.UsePreparedAbility( target ); }
function H7BaseAbility              GetPreparedAbility()                            { return mGridOwner.GetPreparedAbility(); }

function bool IsShoreCell()        { return IsShoreTile; }
function SetShoreCell( bool shore ){ IsShoreTile = shore; }

function H7AdventureArmy GetArmy() { return mAdvArmy; }
function H7Ship GetShip()          { return mShip; }

function int GetAreaOfControl()                    { return mAreaOfControl; }
function SetAreaOfControl( int area )              { mAreaOfControl = area; }

function H7VisitableSite GetVisitableSite()    { return mVisitableSite; }
function SetVisitableSite( H7VisitableSite site ) { mVisitableSite = site; }

function array<H7AdventureMapCell> GetNeighbours() { return mNeighbours; }
function SetNeighbours( array<H7AdventureMapCell> newNeighbours ) { mNeighbours = newNeighbours; }

function AddNeighbour( H7AdventureMapCell cell )   { mNeighbours.AddItem( cell ); }
function RemoveNeighbour( H7AdventureMapCell cell ){ mNeighbours.RemoveItem( cell ); }

function AddWayPointNeighbour( H7AdventureMapCell cell )   { mWayPointNeighbours.AddItem( cell ); }
function RemoveWayPointNeighbour( H7AdventureMapCell cell ){ mWayPointNeighbours.RemoveItem( cell ); }

function H7AdventureMapCell GetWayPoint() { return mWayPoint; }

native function bool IsSurroundedByImpassable();

function SetGridOwner( H7AdventureMapGridController newGrid ) { mGridOwner = newGrid; }
function H7AdventureMapGridController GetGridOwner() { return mGridOwner; }

function H7IEffectTargetable GetTargetable()
{
	if( mVisitableSite != none )
	{
		return mVisitableSite;
	}
	else if( mTargetableSite != none )
	{
		return mTargetableSite;
	}
	else if( mAdvArmy != none )
	{
		return mAdvArmy.GetHero();
	}
	else
	{
		return self;
	}
}

function string GetCombatMapName() 
{
	local string combatMap;
	combatMap = self.PickAppropriateCombatMap();
	if(Len(combatMap) == 0)
	{
		return "CM_Desert_Canyon_2"; // default one (Pick function should already raise a warning that it's wrong)
	}
	return combatMap;
}

native function InitCell();

function SetHasPickable( bool hasPickable )
{
	mHasPickable = hasPickable;
}

function RegisterArmy( H7AdventureArmy newArmy )
{
	local H7AdventureMapCell neighbour;
	local H7IDefendable defendableSite;
	local H7IAdventureMapCellInteractor interactor;

	if( !newArmy.IsGarrisoned() )
	{
		AddControllingArmy( newArmy );
		// caravans have no ZoC
		//if( H7CaravanArmy( newArmy ) == none )
		//{
			foreach mNeighbours( neighbour )
			{
				neighbour.AddControllingArmy( newArmy );
			}
		//}
	}

	if( mAdvArmy == none )
	{
		mAdvArmy = newArmy; 

		// autoassign army as defending army to any visitablesite that has the Defendable-feature.
		defendableSite = H7IDefendable(mVisitableSite);
		if( defendableSite != None )
		{
			if( defendableSite.GetGuardingArmy() == None || defendableSite.GetGuardingArmy() != mAdvArmy )
			{
				defendableSite.SetGuardingArmy(mAdvArmy);
			}
		}

		if( mVisitableSite != None )
		{
			if( mVisitableSite.IsA( 'H7NeutralSite' ) )
			{
				H7NeutralSite( mVisitableSite).SetArmy( mAdvArmy );
			} 
			else if( mVisitableSite.IsA( 'H7AreaOfControlSite' ) )
			{
				if( mVisitableSite.GetEntranceCell() == self )
				{
					H7AreaOfControlSite(mVisitableSite).SetVisitingArmy( mAdvArmy );
				}
			}
			if( mVisitableSite.IsA( 'H7DestructibleObjectManipulator' ) )
			{
				if( H7DestructibleObjectManipulator( mVisitableSite ).IsManipulationInitiated() )
				{
					H7DestructibleObjectManipulator( mVisitableSite ).SetVisitingArmy( mAdvArmy );
				}
			}
		}

		foreach mInteractorList( interactor )
		{
			interactor.OnArmyRegister(mAdvArmy);
		}
	}
	else
	{
		;
		ScriptTrace();
	}
}

/**
 * Checks if there is a hostile army registered on this cell (either directly on top or with Zone of Control)
 * 
 * @param   dasPlayer  The player to check hostility against
 * 
 * */
native function bool HasHostileArmy( H7Player dasPlayer );

/**
 * Gets a hostile army registered on this cell (either directly on top or with Zone of Control)
 * Player-controlled armies are preferred.
 * 
 * @param   dasPlayer  The player to check hostility against
 * 
 * */
native function H7AdventureArmy GetHostileArmy( H7Player dasPlayer );

function UnregisterArmy( H7AdventureArmy armyToRemove, H7AdventureMapCell newDestinationCell = none )
{
	local H7AdventureMapCell neighbour;
	local H7IDefendable defendableSite;
	local H7IAdventureMapCellInteractor interactor;

	mControllingArmies.RemoveItem( armyToRemove );
	foreach mNeighbours( neighbour )
	{
		neighbour.RemoveControllingArmy( armyToRemove );
	}

	if( mAdvArmy != none && mAdvArmy == armyToRemove )
	{
		mAdvArmy = none; 

		if( mVisitableSite != None )
		{
			defendableSite = H7IDefendable(mVisitableSite);
			if( defendableSite != None )
			{
				defendableSite.SetGuardingArmy(None);
			}
			if( H7AreaOfControlSiteLord( defendableSite ) != None && mAdvArmy == H7AreaOfControlSiteLord( defendableSite ).GetVisitingArmy() )
			{
				H7AreaOfControlSiteLord( defendableSite ).SetVisitingArmy( none );
			}
		}

		foreach mInteractorList( interactor )
		{
			interactor.OnArmyUnregister(armyToRemove, newDestinationCell);
		}
	}
}

function RegisterShip( H7Ship newShip ) 
{
	if( mShip == none )
	{
		mShip = newShip; 
		if( mAdvArmy != none && !mAdvArmy.HasShip() && mAdvArmy.GetHero() != none )
		{
			if( mAdvArmy.GetHero().IsHero() )
			{
				mAdvArmy.GetHero().TriggerEvents(ON_EMBARK, false);
				mAdvArmy.SetRotation( mShip.Rotation );
				mAdvArmy.GetHero().SetRotation( mShip.Rotation );
				mAdvArmy.SwitchToBoatVisuals();
				mAdvArmy.SetShip( newShip );
			}
			else
			{
				mShip.Destroy();
			}
		}
	}
	else
	{
		;
	}
}

function UnregisterShip( H7Ship shipToRemove ) 
{
	if( mShip != none && mShip == shipToRemove )
	{
		mShip = none; 
	}
}

// blocked = no passable or a creature occupies the cell, ignoreArmy can be none if we dont need to ignore an army
function bool IsBlocked( optional H7AdventureArmy ignoreArmy ) 
{
	if( mAdvArmy != none && mAdvArmy != ignoreArmy )
	{
		return true;
	}
	if ( mMovementType == MOVTYPE_IMPASSABLE )
	{
		return true;
	}
	if ( mVisitableSite != none && !mVisitableSite.IsUnblockingEntrance() )
	{
		return true;
	}	
	return false; 
}

function bool IsNeighbour( H7AdventureMapCell cell )
{
	return mNeighbours.Find( cell ) != INDEX_NONE;
}

function DrawAoC()
{
	local Color playerColor;
	local H7AdventureArmy army;
	local int radius;
	radius = 100;
	foreach mControllingArmies( army )
	{
		playerColor = army.GetPlayer().GetColor();
		mGridOwner.DrawDebugSphere( mWorldCenter, radius, 8, playerColor.R, playerColor.G, playerColor.B );
		if( radius > 10 )
		{
			radius -= 10;
		}
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
