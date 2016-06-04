//=============================================================================
// H7AdventureMapGridController
//=============================================================================
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureMapGridController extends H7EditorAdventureGrid implements(H7IEffectTargetable, H7ICaster)
	native
	placeable
	dependsOn(H7EditorAdventureGrid)
	dependson(H7StructsAndEnumsNative);

// index of this grid controller in the array of gridcontrollers of the Grid Manager
var protected int							mIndex;

var protected H7FOWController				mFogOfWarController;
var protected H7AbilityManager		        mAbilityManager;
var protected H7BuffManager			        mBuffManager;
var protected H7EventManager                mEventManager;
var protected H7EffectManager               mEffectManager;
var protected H7AuraManager                 mAuraManager;
var protected array<IntPoint>               mUnFoggedTiles;
var protected Texture2DDynamic              mDynamicAOCTexture;
var protected array<H7AdventureMapCell>     mGridWayPoints;

function array<IntPoint>                GetUnFoggedTiles()      { return mUnFoggedTiles; }
native function H7ICaster               GetOriginal();
function H7FOWController				GetFOWController()	    { return mFogOfWarController; }
function SetFogOfWarController( H7FOWController fogController)  { mFogOfWarController = fogController; }
function array<H7VisitableSite>         GetVisitableSites()     { return mVisitableActorList; }
native function H7AbilityManager		GetAbilityManager();
native function H7BuffManager		    GetBuffManager();
native function H7EventManager          GetEventManager();
function H7EffectManager                GetEffectManager()      { return mEffectManager; }
native function int						GetID();
function string					        GetName()			    { return "AdventureGrid"; }
function                                DataChanged(optional String cause) {}
native function EUnitType  				GetEntityType();
native function float                   GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);
function H7AuraManager                  GetAuraManager()        { return mAuraManager; }

function Texture2DDynamic               GetAOCTexture()         { return mDynamicAOCTexture; }

native function Vector                  GetLocation();
native function IntPoint                GetGridPosition();
native function bool                    IsDefaultAttackActive();
function ECommandTag                    GetActionID( H7BaseAbility ability )            { return ACTION_ABILITY; }  
function								PrepareAbility(H7BaseAbility ability)			{ GetAbilityManager().PrepareAbility( ability ); }
function H7BaseAbility					GetPreparedAbility()                            { return GetAbilityManager().GetPreparedAbility(); }
native function H7Player                GetPlayer();
native function H7CombatArmy            GetCombatArmy();
function								UsePreparedAbility(H7IEffectTargetable target)  
{ 
	local H7BaseGameController bgController;

	if(!class'H7AdventureController'.static.GetInstance().CanQueueCommand())
	{
		return;
	}

	bgController = class'H7BaseGameController'.static.GetBaseInstance();
	bgController.GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( self, UC_ABILITY, ACTION_ABILITY, GetPreparedAbility(), target ) );
}

function int GetHitPoints()  {}
function float GetMinimumDamage(){	return 0;}
function float GetMaximumDamage(){	return 0;}
function int GetAttack(){	return 0;}
native function int GetLuckDestiny(); //{  return 0;}
function int GetMagic(){    return 0;}
function int GetStackSize(){    return 1;}
function EAbilitySchool GetSchool() { return ABILITY_SCHOOL_NONE; }

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) {}

function int GetIndex() { return mIndex; }

native function H7AdventureMapCell GetCell( int x, int y );

native function H7AdventureMapCell GetCellByWorldLocation( Vector pos );

function array<H7AdventureMapCell> GetCellsByWorldExtent( Vector minPos, Vector maxPos )
{
	local int tmpX, tmpY;
	local H7AdventureMapCell minCell, maxCell;
	local IntPoint minPoint, maxPoint;
	local array<H7AdventureMapCell> extentCells;

	minCell = GetCellByWorldLocation( minPos );
	if( minCell != none )
	{
		maxCell = GetCellByWorldLocation( maxPos );
		if( maxCell != none )
		{
			minPoint = minCell.GetCellPosition();
			maxPoint = maxCell.GetCellPosition();
			for( tmpX = minPoint.X; tmpX < maxPoint.X; ++tmpX )
			{
				for( tmpY = minPoint.Y; tmpY < maxPoint.Y; ++tmpY )
				{
					extentCells.AddItem( GetCell( tmpX, tmpY ) );
				}
			}
		}
	}
	
	return extentCells;
}

/**
 * Gets cells in a rectangle from the grid based on a center point and the
 * rectangle dimensions (X&Y) in IntPoint form
 * 
 * @param targetCell    The central cell
 * @param dim           The dimensions of the rectangle
 * 
 * */
native function GetCellsFromDimensions( H7AdventureMapCell targetCell, IntPoint dim, out array<H7AdventureMapCell> cells, optional ECellSize originSize = CELLSIZE_1x1, optional bool isAreaFilled = true );

/**
 * Gets cells in a the shape specified as offsets from the targetCell
 * 
 * @param targetCell    The central cell
 * @param shape         The offsets from the central point from which to draw the shape
 * 
 * */
function array<H7AdventureMapCell> GetCellsFromShape( H7AdventureMapCell targetCell, array<IntPoint> shape, optional ECellSize originSize = CELLSIZE_1x1 )
{
	local IntPoint tmpPoint;
	local array<IntPoint> shapeOnGrid;
	local array<H7AdventureMapCell> cells;

	class'H7Math'.static.GetPointsFromShape( shapeOnGrid, targetCell.GetGridPosition(), shape, mGridSizeX, mGridSizeY, originSize );

	foreach shapeOnGrid( tmpPoint )
	{
		cells.AddItem( GetCell( tmpPoint.X, tmpPoint.Y ) );
	}

	return cells;
}

function array<int> GetCellsAsAoCMatrix()
{
	local array<int>               aocMatrix;
	local H7AdventureMapCell        aocCell;
	local int                       i;
	i = 0;

	aocMatrix.Add( mAdventureCells.Length );

	foreach mAdventureCells(aocCell, i)
	{
		aocMatrix[i] = aocCell.GetAreaOfControl();
	}

	return aocMatrix;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.PrintLogMessage("H7AdventureMapGridController.PostBeginPlay", 0);;
	
	Role=ROLE_Authority;
}

function InitGrid( int index )
{
	mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
	mIndex = index;
	class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self );

	InitCells();
	
	mAbilityManager = new(self) class 'H7AbilityManager';
	mBuffManager = new(self) class 'H7BuffManager';
	mEventManager = new(self) class 'H7EventManager';
	mEffectManager = new(self) class 'H7EffectManager';
	mAuraManager = new(self) class 'H7AuraManager';
	mAuraManager.SetOwner( self );
	mAbilityManager.SetOwner( self );
	mEffectManager.Init( self );
	mBuffManager.Init( self );
}

simulated event Destroyed()
{
	local int x, y;
	local H7AdventureMapCell cell;

	super.Destroyed();

	class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( self );
		
	for (y = 0; y < mGridSizeY; ++y)
	{
		for (x = 0; x < mGridSizeX; ++x)
		{
			cell = mAdventureCells[x + y * mGridSizeX];
			class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( cell );

		}
	}
}

protected function native InitCells();
protected function native AddCellToItsAoC( H7AdventureMapCell cell );

function AddVisitableSiteToList( H7VisitableSite site ) 
{
	if( site != none && mVisitableActorList.Find( site ) == INDEX_NONE )
	{
		mVisitableActorList.AddItem( site );
	}
}

event Tick( float deltaTime )
{
	local H7AdventureMapCell cell;
	super.Tick( deltaTime );

	if( bDebug )
	{
		foreach mAdventureCells( cell )
		{
			cell.DrawAoC();
		}
	}
}

function UpdateVisitableSiteRef(H7VisitableSite oldSite, H7VisitableSite newSite)
{
	local int oldSiteIndex;
	local int newSiteIndex;
	local bool foundInGrid;

	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	// !!! UGLY FIX TO REMOVE ALL REMAINING DUPLICATES                 !!!
	// !!! TODO: Make sure we don't have duplicates in the first place !!!
	// !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	foundInGrid=false;
	do
	{
		oldSiteIndex = mVisitableActorList.Find(oldSite);
		if(oldSiteIndex!=INDEX_NONE)
		{
			mVisitableActorList.RemoveItem(oldSite);
			foundInGrid=true;
		}
	} until(oldSiteIndex==INDEX_NONE);


	// THE NEW SITE IS ALREADY IN THE LIST ... IF NOT ADD IT
	newSiteIndex = mVisitableActorList.Find(newSite);
	if(newSiteIndex==INDEX_NONE && foundInGrid==true)
	{
		mVisitableActorList.AddItem(newSite);
	}

}

function RemoveVisitableSite( H7VisitableSite site )
{
	mVisitableActorList.RemoveItem(site);
}

native function GenerateAOCTexture();
