//=============================================================================
// H7AdventureGridManager
//=============================================================================
//
// Manager of multiple grids
//
//=============================================================================
// Copyright 2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AdventureGridManager extends H7EditorAdventureGridManager
	native
	placeable
	hidecategories(Display, Attachment, Collision, Physics, Advanced, Mobile)
	config( game )
	dependson( H7ReplicationInfo );

var protected config bool cUseFogOfWar;
var protected config bool cWinAllCombatCheat;
var protected config bool cTogglePlaneWithoutExploration;
var protected config int cPickupCost;

var protected H7AdventureMapPathfinder		mPathfinder;

var protected H7AdventureMapPathPreviewer	mPathPreviewer;
var protected bool							mIsTeleportPhase;
var protected Actor							mHitActor;
var protected H7AdventureMapCell            mHoveredCell;
var protected ECurrentArmyAction            mLastArmyAction;
var protected H7TownAsset					mLastHitAsset;
var protected bool                          mIsInitialized;

var protected array<H7AreaOfControlCells>	mAreaOfControls;

var protected H7AdventureController			mAdventureController;

var protected int							mCurrentGridIndex; // index in the mGridList of the grid that is currently selected


var protected array<ParticleSystemComponent> mFogRevealPreviewParticles;

function bool							IsFogOfWarUsed()	{ return cUseFogOfWar; }
function bool							IsWinAllCheatUsed()	{ return cWinAllCombatCheat; }
function bool							IsTogglePlaneWithoutExplorationCheatUsed()	{ return cTogglePlaneWithoutExploration; }
function int                            GetPickupCost()     { return cPickupCost; }
function H7AdventureMapPathfinder		GetPathfinder()		{ return mPathfinder; }
function H7AdventureMapPathPreviewer	GetPathPreviewer()	{ return mPathPreviewer; }
function bool							IsTeleportPhase()	{ return mIsTeleportPhase; }
function Actor							GetLastHitActor()	{ return mHitActor; }
function array<H7AreaOfControlCells>	GetAoCCells()		{ return mAreaOfControls; }
function H7AdventureMapGridController	GetCurrentGrid()	{ return mGridList[mCurrentGridIndex]; }
function H7AdventureMapGridController	GetGridByIndex(int index)	{ return mGridList[index]; }
function array<H7AdventureMapGridController> GetAllGrids()  { return mGridList; }
function int                            GetCurrentGridIndex(){ return mCurrentGridIndex; }
function bool                           IsInitialized()     { return mIsInitialized; }

function SetAdventureController( H7AdventureController advCtrl ) { mAdventureController = advCtrl; }
function SetTeleportPhase( bool isPhase ) { mIsTeleportPhase = isPhase; }

function ToggleFogOfWarUsed()
{
	cUseFogOfWar = !cUseFogOfWar;
}

function SetWinAllCheat( bool val )
{
	cWinAllCombatCheat = val;
}

function SetTogglePlaneWithoutExploration( bool val )
{
	cTogglePlaneWithoutExploration = val;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.PrintLogMessage("H7AdventureGridManager.PostBeginPlay", 0);;
	Role=ROLE_Authority;
}

event Init()
{
	local array<int> usedAreas, totalUsedAreas;
	local H7AdventureMapGridController gridController;
	local int counter, i;

	if( !mIsInitialized && class'WorldInfo'.static.GetWorldInfo().GRI != none && class'H7PlayerController'.static.GetPlayerController() != none && class'H7ReplicationInfo'.static.GetInstance() != none )
	{
		mIsInitialized = true;
		mCurrentGridIndex = 0;

		class'H7ReplicationInfo'.static.GetInstance().SetIsAdventureMap();
		class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetAdventureGridManager( self );
		class'H7PlayerController'.static.GetPlayerController().GetHud().Init();
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().SetCombatHudVisible(false,true); 

		for( counter = 0; counter < mGridList.Length; ++counter )
		{
			usedAreas = mGridList[counter].GetAoCArray();
			for( i = 0; i < usedAreas.Length; ++i )
			{
				if( totalUsedAreas.Find( usedAreas[i] ) == INDEX_NONE )
				{
					totalUsedAreas.AddItem( usedAreas[i] );
				}
			}
		}
		
		mAreaOfControls.Add( totalUsedAreas.Length );
		for( i = 0; i < mAreaOfControls.Length; ++i )
		{
			mAreaOfControls[i].AreaOfControlIndex = totalUsedAreas[i];
		}

		foreach mGridList( gridController, counter )
		{
			gridController.InitGrid( counter );
		}

		mPathfinder = new class'H7AdventureMapPathfinder';
		mPathfinder.Init();
		mPathPreviewer = Spawn( class'H7AdventureMapPathPreviewer', self );

		SetTimer( 1.f, true, NameOf(MPSetPlayerReady) );
	}
}

// there is only one combatmap grid per level
simulated static function H7AdventureGridManager GetInstance()
{
	if(class'H7ReplicationInfo'.static.GetInstance() == none)
	{
		return none;
	}
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetAdventureGridManager();
}

protected simulated function MPSetPlayerReady()
{
	local int targetNumPlayers, numPlayers;

	if( WorldInfo.GRI != none && WorldInfo.GRI.IsMultiplayerGame() && GetALocalPlayerController().PlayerReplicationInfo != none )
	{
		targetNumPlayers = class'H7TransitionData'.static.GetInstance().GetHumanPlayersCounter();
		numPlayers = class'H7ReplicationInfo'.static.GetInstance().PRIArray.Length;

		if(targetNumPlayers == 0 || targetNumPlayers == numPlayers)
		{
			H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).SetPlayerReady();
			ClearTimer( NameOf(MPSetPlayerReady) );
		}
	}
}


function int GetAoCIndexOfCell( H7AdventureMapCell cell )
{
	return cell.GetAreaOfControl();
}

function array<H7AdventureMapCell> GetAoCCellsByIntPoint( IntPoint point )
{
	local array<H7AdventureMapCell> outCells;
	local H7AreaOfControlCells currentCells;
	local H7AdventureMapCell cell;
	local int index;

	cell = class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetCell( point.X, point.Y );

	index = GetAoCIndexOfCell( cell );

	foreach mAreaOfControls( currentCells )
	{
		if( currentCells.AreaOfControlIndex == index )
		{
			outCells = currentCells.Cells;
			break;
		}
	}

	return outCells;
}

native function GetAoCPointsByIntPoint( IntPoint point, int index, out array<IntPoint> points );

function InitFOWControllers()
{
	local H7AdventureMapGridController gridController;
	local H7FOWController fogController;

	foreach mGridList( gridController )
	{
		fogController = Spawn( class'H7FOWController', gridController );
		fogController.Init( gridController.GetIndex() );
	}
}

// if gridIndex == -1, we will use the current grid
function H7AdventureMapCell GetCell( int x, int y, optional int gridIndex = -1)
{
	if( gridIndex == -1 )
	{
		gridIndex = mCurrentGridIndex;
	}
	return mGridList[gridIndex].GetCell( x, y );
}

native function H7AdventureMapCell GetCellByWorldLocation( Vector pos );


function array<H7AdventureMapCell> GetCellsByWorldExtent( Vector minPos, Vector maxPos )
{
	local array<H7AdventureMapCell> cells;
	local H7AdventureMapGridController gridController;

	foreach mGridList( gridController )
	{
		cells = gridController.GetCellsByWorldExtent( minPos, maxPos );
		if( cells.Length > 0 )
		{
			return cells;
		}
	}

	return cells;
}

function SetHoverDotDelayed()
{
	class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().SetHoverDot( mHoveredCell, mLastArmyAction );
}

/**
 * Function for all hover effects (cell, asset, cursor) detects the 
 * collision of the mouse cursor with the cells and update their 
 * state (selected and mouseover). Also updates hover cursors. Also for townscreens.
 * 
 * Called every frame.
 **/
protected event UpdateHoverEffects()
{
	local H7AdventureArmy	        hitArmy;
	local Vector			        hitPosition;
	local H7AdventureObject         hitObject;
	local Actor                     hitActor;
	local ECurrentArmyAction        armyAction;
	local float                     negotiationChance;
	local H7PlayerController        playerController;
	local H7AdventureMapCell        previousHoveredCell;

	if( mAdventureController == none ) { return; }
	playerController = class'H7PlayerController'.static.GetPlayerController();
	
	if( playerController.IsInputAllowed() && class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		if(!mAdventureController.IsCouncilMapActive())
		{
			armyAction = GetCurrentArmyAction( hitArmy, hitPosition, negotiationChance, hitObject , hitActor );
		}
		else
		{
			armyAction = CAA_NOTHING;
			negotiationChance = 0.0f;
		}

		mLastArmyAction = armyAction;
		
		// ------------- CELL -----------
		previousHoveredCell = mHoveredCell;
		if(hitObject != none && hitObject.IsA('H7VisitableSite') && ( mAdventureController.GetSelectedArmy() == none || !mAdventureController.GetSelectedArmy().GetHero().HasPreparedAbility() ) )
		{
			mHoveredCell = H7VisitableSite(hitObject).GetEntranceCell();
		}
		else
		{
			mHoveredCell = GetCellByWorldLocation( hitPosition );
		}
		if( !class'H7PlayerController'.static.GetPlayerController().IsMouseMoving() )
		{
			if( mHoveredCell != none ) 
			{
				// highlight cell
				if( GetRemainingTimeForTimer( 'SetHoverDotDelayed' ) <= 0 )
				{
					//class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().RemoveHoverDot(); // feels lacky without :-(, frickly with :-(
					SetTimer( 0.025f, false, 'SetHoverDotDelayed' );
				}
			}
			else
			{
				GetPathPreviewer().RemoveHoverDot();
			}
		}
		else
		{
			ClearTimer( 'SetHoverDotDelayed' );
			if( previousHoveredCell != mHoveredCell )
			{
				GetPathPreviewer().RemoveHoverDot(); 
				UpdateFogRevealPreview();
			}
		}

		// ------------------ CURSOR -----------
		
		switch( armyAction )
		{
			case CAA_NOTHING:
				if(playerController.GetAdventureHud().GetTownHudCntl().IsInTownScreen())
				{
					HandleTownHighlight();
					mAdventureController.GetCursor().SetCursor( CURSOR_ACTION );
				}
				else if(class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsCouncilMapActive())
				{
					mAdventureController.GetCursor().SetCursor( CURSOR_ACTION );
				}
				else
				{
					;
					mAdventureController.GetCursor().SetCursor( CURSOR_UNAVAILABLE );
					mAdventureController.UnhoverArmy();
				}
				
				break;

			case CAA_MOVE:
				if( mAdventureController.GetSelectedArmy().HasShip() )
				{
					if( GetCellByWorldLocation( hitPosition ).mMovementType == MOVTYPE_WATER )
					{
						mAdventureController.GetCursor().SetCursor( CURSOR_SHIP_MOVE );
					}
					else
					{
						mAdventureController.GetCursor().SetCursor( CURSOR_SHIP_ANCHOR );
					}
				}
				else
				{
					mAdventureController.GetCursor().SetCursor( CURSOR_POINTER ); // formaly CURSOR_MOVE
				}
				
				mAdventureController.UnhoverArmy();
				break;

			case CAA_BOARD:
				mAdventureController.GetCursor().SetCursor( CURSOR_SHIP_ANCHOR );
				mAdventureController.UnhoverArmy();
				break;

			case CAA_UNBOARD:
				mAdventureController.GetCursor().SetCursor( CURSOR_SHIP_ANCHOR );
				mAdventureController.UnhoverArmy();
				break;

			case CAA_SELECT_ARMY:
				mAdventureController.GetCursor().SetCursor( CURSOR_POINTER );
				mAdventureController.SetHoverArmy( hitArmy );
				break;

			case CAA_ATTACK_ARMY:
				mAdventureController.GetCursor().SetCursor( CURSOR_MELEE_SE );
				mAdventureController.SetHoverArmy( hitArmy );
				break;

			case CAA_TELEPORT:
				mAdventureController.GetCursor().SetCursor( CURSOR_TELEPORT );
				mAdventureController.UnhoverArmy();
				break;

			case CAA_VISIT:
				if( mHitActor != none && mHitActor.IsA('H7VisitableSite') && !mHitActor.IsA('H7NeutralSite') && !mHitActor.IsA('H7CustomNeutralDwelling') )
				{
					if( H7VisitableSite( mHitActor ).GetPlayer() == none)
					{
						// VIsiting shell?
						mAdventureController.GetCursor().SetCursor( CURSOR_VISIT );
					}
					else if( H7VisitableSite( mHitActor ).GetPlayer().IsPlayerHostile( mAdventureController.GetLocalPlayer() ))
					{
						if( mHitActor.IsA('H7AreaOfControlSiteLord') && H7AreaOfControlSiteLord(mHitActor).IsHidden() )
						{
							mAdventureController.GetCursor().SetCursor( CURSOR_ACTION_BLOCKED );
						}
						if( H7AreaOfControlSite( mHitActor ) != none && H7AreaOfControlSite( mHitActor ).GetGarrisonArmy() != none && H7AreaOfControlSite( mHitActor ).GetGarrisonArmy().HasUnits( false ) )
						{
							mAdventureController.GetCursor().SetCursor( CURSOR_MELEE_SE );
						}
						else
						{
							mAdventureController.GetCursor().SetCursor( CURSOR_VISIT );
						}
					}
					else if( H7VisitableSite( mHitActor ).GetPlayer() == mAdventureController.GetLocalPlayer() )
					{
						mAdventureController.GetCursor().SetCursor( CURSOR_VISIT );
					}
					else // is allied
					{
						mAdventureController.GetCursor().SetCursor( CURSOR_ACTION_BLOCKED );
					}
				}
				else
				{
					mAdventureController.GetCursor().SetCursor( CURSOR_VISIT );
				}

				mAdventureController.UnhoverArmy();
				break;

			case CAA_PICK_UP:
				mAdventureController.GetCursor().SetCursor( CURSOR_MEETING ); // OPTIONAL CURSOR_PICKUP
				mAdventureController.UnhoverArmy();
				break;

			case CAA_ZOOM_TO:
				mAdventureController.GetCursor().SetCursor( CURSOR_VISIT );
				HandleTownHighlight();
				break;

			case CAA_SPELL_OK:
				mAdventureController.GetCursor().SetCursor( CURSOR_ABILITY );
				mAdventureController.UnhoverArmy();
				break;

			case CAA_SPELL_NO:
				mAdventureController.GetCursor().SetCursor( CURSOR_ABILITY_DENY );
				mAdventureController.UnhoverArmy();
				break;

			case CAA_MEET_ARMY:
				mAdventureController.GetCursor().SetCursor( CURSOR_TRADE );
				mAdventureController.UnhoverArmy();
				break;

			case CAA_TALK:
				mAdventureController.GetCursor().SetCursor( CURSOR_TALK );
				break;

			case CAA_BRIBE:
				if(negotiationChance < 1) mAdventureController.GetCursor().SetCursor( CURSOR_MELEE_SE );
				else mAdventureController.GetCursor().SetCursor( CURSOR_EXCHANGE );
				break;

			case CAA_JOIN_FORCE:
				if(negotiationChance < 1) mAdventureController.GetCursor().SetCursor( CURSOR_MELEE_SE );
				else mAdventureController.GetCursor().SetCursor( CURSOR_MEETING ); // OPTIONAL CURSOR_PICKUP
				break;

			case CAA_JOIN_OFFER:
				if(negotiationChance < 1) mAdventureController.GetCursor().SetCursor( CURSOR_MELEE_SE );
				else mAdventureController.GetCursor().SetCursor( CURSOR_MEETING ); // OPTIONAL CURSOR_PICKUP
				break;

			case CAA_FLEE:
				if(negotiationChance < 1) mAdventureController.GetCursor().SetCursor( CURSOR_MELEE_SE );
				else mAdventureController.GetCursor().SetCursor( CURSOR_MOVE_WALK );
				break;

			case CAA_ENTER_TOWN:
				mAdventureController.GetCursor().SetCursor( CURSOR_TOWN );
				break;
		
			case CAA_DESHELTER:
				// no code, but we don't want to spam warning
				break;

			case CAA_ABORT_ACTION:
				// no code, but we don't want to spam warning
				break;

			default:
				;
				mAdventureController.GetCursor().SetCursor( CURSOR_UNAVAILABLE );
				break;
		}
		
		
	}
	else if(!playerController.IsUnrealAllowsInput() 
		&& !playerController.IsMouseOverHUD()
		&& !playerController.IsPopupOpen()
		&& !playerController.IsInCinematicView() )
	{
		class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().RemoveHoverDot();
		mAdventureController.GetCursor().SetCursor( CURSOR_BUSY );
	}
	else if(playerController.IsCaravanTurn() || playerController.IsCommandRequested())
	{
		mAdventureController.GetCursor().SetCursor( CURSOR_BUSY );
	}
	else
	{
		class'H7AdventureGridManager'.static.GetInstance().GetPathPreviewer().RemoveHoverDot();
	}
}

// returns what you can do with the current selected army depending on where the cursor is pointing
// called for Cursor-Hover (every frame) and Cursor-Click (onClick)
function ECurrentArmyAction GetCurrentArmyAction( out H7AdventureArmy mouserOverArmy, out Vector hitPosition, optional out float chanceOfAction, optional out H7AdventureObject hitObject , optional out Actor hitActor)
{
	local H7AdventureHero hitHero;
	local H7AdventureMapCell cell;
	local H7AdventureArmy actingArmy;
	local Actor prevActor;
	local H7Flag flag;

	// first not-really-army-actions:

	// DATA PREPARATION

	// don't get a new hitActor if we already have one as a param
	if (hitActor == none)
	{
		prevActor = mHitActor;
		
		hitActor = GetMouseHitActorAndLocation( hitPosition );
		if( prevActor != mHitActor )
		{
			flag = H7Flag( prevActor );
			if( flag != none && ( H7Town( flag.Owner ) != none && H7Town( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() || 
				H7Garrison( flag.Owner ) != none && H7Garrison( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() || 
				H7Fort( flag.Owner ) != none && H7Fort( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() ||
				H7AdventureArmy( flag.Owner ) != none && H7AdventureArmy( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() && H7AdventureArmy( flag.Owner ) != mAdventureController.GetSelectedArmy() ) )
			{
				flag.StopAnim();
			}
			flag = H7Flag( hitActor );
			if( flag != none && ( H7Town( flag.Owner ) != none && H7Town( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() || 
				H7Garrison( flag.Owner ) != none && H7Garrison( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() || 
				H7Fort( flag.Owner ) != none && H7Fort( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() ||
				H7AdventureArmy( flag.Owner ) != none && H7AdventureArmy( flag.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() && H7AdventureArmy( flag.Owner ) != mAdventureController.GetSelectedArmy() ) )
			{
				flag.ShowAnim( true );
			}
		}
	}
	
	// every frame hitting flag
	if(hitActor != none && hitActor.IsA('H7Flag'))
	{
		if( hitActor.Owner.IsA( 'H7AdventureArmy' ) && H7AdventureArmy( hitActor.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() )
		{
			//armies/heroes
			mouserOverArmy = H7AdventureArmy( hitActor.Owner );
			return CAA_SELECT_ARMY;
		}
		else if( ( hitActor.Owner.IsA( 'H7Town' ) || hitActor.Owner.IsA( 'H7Garrison' ) || hitActor.Owner.IsA( 'H7Fort' ) ) && H7AreaOfControlSite( hitActor.Owner ).GetPlayer() == mAdventureController.GetLocalPlayer() )
		{
			//buildings
			return CAA_ENTER_TOWN;
		}
	}

	// We are in a town, actually
	if( hitActor != none && hitActor.IsA( 'H7TownAsset' ) )
	{
		if(class'H7TownHudCntl'.static.GetInstance().GetTown().GetBuildingByAssetType(H7TownAsset(hitActor).GetType()).GetPopup() != POPUP_NONE)
		{
			return CAA_ZOOM_TO;
		}
		else
		{
			return CAA_NOTHING;
		}
	}
	
	// now the real army actions:

	cell = GetCellByWorldLocation( hitPosition );
	actingArmy = mAdventureController.GetSelectedArmy();

	if(actingArmy == none)
	{
		return CAA_NOTHING;
	}

	// Cannot take any action without a selected army or a non-existent cell
	if(cell == none )
	{
		;
		return CAA_NOTHING;
	}

	if( actingArmy.IsLocked() )
	{
		if( actingArmy.IsInShelter() )
		{
			return CAA_DESHELTER;
		}
		else
		{
			return CAA_ABORT_ACTION;
		}		
	}

	hitHero = H7AdventureHero( hitActor );
	hitObject = H7AdventureObject( hitActor );
	if( H7Ship( hitObject ) != none )
	{
		hitHero = H7Ship( hitObject ).GetEntranceCell().GetArmy().GetHero();
	}

	if( hitHero == none && H7AdventureArmy( hitActor ) != none && !H7AdventureArmy( hitActor ).IsGarrisoned() )
	{
		hitHero = H7AdventureArmy( hitActor ).GetHero();
	}

	// DATA PREPARATION END
	
	// Hide & rev. feature 
	if( ( H7IHideable( hitObject) != none && H7IHideable( hitObject ).IsHiddenX() || cell != none && H7IHideable( cell.GetAdventureObject() ) != none && H7IHideable( cell.GetAdventureObject() ).IsHiddenX() ) )
	{
		return CAA_NOTHING;
	}

	// Check if we are allowed to provide input
	if( !class'H7PlayerController'.static.GetPlayerController().IsUnrealAllowsInput() )
	{
		;
		return CAA_NOTHING;
	}
	// Check if we can teleport to the destination
	else if ( mIsTeleportPhase )
	{
		if( !cell.IsBlocked() )
		{
			// Cannot teleport with a ship onto a ship and can teleport into water only if we have a ship or if there is a ship at the destination
			if( cell.mMovementType == MOVTYPE_WATER )
			{
				if( actingArmy.HasShip() && cell.GetShip() == none || !actingArmy.HasShip() && cell.GetShip() != none )
				{
					return CAA_TELEPORT;
				}
				else
				{
					;
					return CAA_NOTHING;
				}
			}
			else
			{
				return CAA_TELEPORT;
			}
		}
		else
		{
			;
			return CAA_NOTHING;
		}
	}
	// Check if we are currently casting a spell
	else if( actingArmy.GetHero() != none && actingArmy.GetHero().HasPreparedAbility() )
	{
		// we reassign the hitActor if it's a landscape to the girdController or if cell is covered by fog
		if( (hitActor != None && hitActor.IsA( 'Landscape' ) ) || IsUnderFog( cell )==true )
		{
			if( actingArmy.GetHero().GetPreparedAbility().CanCastOnTargetActor( cell ) )
			{
				return CAA_SPELL_OK;
			}
			else
			{
				return CAA_SPELL_NO;
			}
		}
		else if( H7IEffectTargetable( hitActor ) != none )
		{
			if( actingArmy.GetHero().GetPreparedAbility().CanCastOnTargetActor( H7IEffectTargetable( hitActor ) ) )
			{
				return CAA_SPELL_OK;
			}
			else
			{
				return CAA_SPELL_NO;
			}
		}
		else
		{
			return CAA_SPELL_NO;
		}
	}
	// Check if we are hitting the fog
	else if( IsUnderFog( cell ) ) 
	{
		;
		return CAA_NOTHING;
	}
	// Check if we traced a hero or army
	else if( hitHero != none )
	{
		mouserOverArmy = hitHero.GetAdventureArmy();
		hitPosition = hitHero.Location;
		return GetArmyActionByHero( hitHero , chanceOfAction );
	}
	// Check if we traced an adventure object (visitable site)
	else if( hitObject != none )
	{
		// Check if object is defendeable and set the mouse over army the army if yes
		if( H7IDefendable( hitObject ) != none )
		{
			mouserOverArmy = H7IDefendable( hitObject ).GetGarrisonArmy();
		}
		if( H7VisitableSite( hitObject ) != none )
		{
			hitPosition = H7VisitableSite( hitObject ).GetEntranceCell().GetLocation();
			
			if( hitObject.IsA('H7Teleporter') )
			{
				if( H7Teleporter( hitObject ).IsBlockedByArmy( actingArmy.GetPlayer() ) )
				{
					mouserOverArmy = H7Teleporter( hitObject ).GetTargetTeleporter().GetEntranceCell().GetArmy();
					if( mouserOverArmy == none )
					{
						H7Teleporter( hitObject ).GetTargetTeleporter().GetEntranceCell().GetHostileArmy( actingArmy.GetPlayer() );
					}
				}
				else
				{
					mouserOverArmy = none;
				}
			}
		}
		return GetArmyActionByVisitable( H7VisitableSite( hitObject ), chanceOfAction );
	}
	// Check if we traced onto the landscape (cell-based logic)
	else if( hitActor != none && ( hitActor.IsA( 'Landscape' ) || ( H7WalkableInterface( hitActor ) != none) ) )
	{

		if(cell.GetVisitableSite() != none && H7IHideable( cell.GetVisitableSite() ) != none && H7IHideable( cell.GetVisitableSite() ).IsHiddenX() )
		{
			return CAA_NOTHING;
		}

		// Check if there is an army (hero) on the landscape
		if( cell.GetArmy() != none && !cell.GetArmy().IsGarrisoned() )
		{
			mouserOverArmy = cell.GetArmy();
			return GetArmyActionByHero( cell.GetArmy().GetHero(), chanceOfAction );
		}
		else if( cell.HasHostileArmy( actingArmy.GetPlayer() ) && cell.mMovementType != MOVTYPE_IMPASSABLE )
		{
			mouserOverArmy = cell.GetHostileArmy( actingArmy.GetPlayer() );
			return GetArmyActionByHero( cell.GetHostileArmy( actingArmy.GetPlayer() ).GetHero(), chanceOfAction );
		}
		// Check if there is a visitable site on the landscape
		else if ( cell.GetVisitableSite() != none )
		{
			// Check if visitable site is defendeable and set the mouse over army the army if yes
			if( H7IDefendable( cell.GetVisitableSite() ) != none )
			{
				mouserOverArmy = H7IDefendable( cell.GetVisitableSite() ).GetGarrisonArmy();
			}
			return GetArmyActionByVisitable( cell.GetVisitableSite() );
		}
		// Check if the landscape is blocked
		else if( !cell.IsBlocked() )
		{
			if( cell.mMovementType == MOVTYPE_WATER && cell.GetShip() != none && !cell.GetShip().IsHiddenX() )
			{
				return CAA_BOARD;
			}
			else
			{
				return CAA_MOVE;
			}
		}
		else
		{
			;
			return CAA_NOTHING;
		}
	}
	else
	{
		;
		return CAA_NOTHING;
	}
}

// the current selected army will move or attack or cast where the cursor is pointing
// called on left click
// - first click sets the path, second click executes the action
function DoCurrentArmyActionByCursor( optional bool wasDoubleClick )
{
	local Actor				hitActor;
	local H7AdventureArmy	hitArmy;
	local Vector			hitPosition;
	local H7AdventureObject hitObject;
	local ECurrentArmyAction action;
	local H7IEffectTargetable target;
	local H7Flag flag;
	local H7Town town;
	local H7Garrison garrison;
	local H7Fort fort;

	action = GetCurrentArmyAction( hitArmy, hitPosition, , hitObject , hitActor );

	// clicking flag - technically not an army action
	flag = H7Flag( hitActor );
	if( hitActor != none )
	{
		town = H7Town( hitActor.Owner );
		garrison = H7Garrison( hitActor.Owner );
		fort = H7Fort( hitActor.Owner );
	}
	if( flag != none )
	{
		if( town != none )
		{
			town.OpenTownScreenForMe();
			return;
		}
		else if( garrison != none )
		{
			garrison.OpenTownScreenForMe();
			return;
		}
		else if( fort != none )
		{
			if( mAdventureController.GetLocalPlayer() == mAdventureController.GetCurrentPlayer() && mAdventureController.GetCurrentPlayer().GetPlayerType() != PLAYER_AI )
			{
				class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GoToFortScreen( fort );
			}
			return;
		}
	}

	switch( action )
	{
		case CAA_ZOOM_TO: // open town screen popup - technically not an army action
			H7TownAsset( mHitActor ).Click();
			break;

		case CAA_DESHELTER:
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("PU_LEAVE_SHELTER","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_YES","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_NO","H7PopUp"), DoLeaveShelter, none );	
			break;

		case CAA_ABORT_ACTION:
			if( !H7DestructibleObjectManipulator( mAdventureController.GetSelectedArmy().GetVisitableSite() ).IsManipulationInitiated() && H7DestructibleObjectManipulator( mAdventureController.GetSelectedArmy().GetVisitableSite() ).mManipulationCounter == 0 )
			{
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("PU_ABORT_ACTION","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_YES","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_NO","H7PopUp"), HandleAbortManipulation, none );
			}
			break;

		case CAA_MOVE:
			DoMoveByVector( hitPosition );
			break;

		case CAA_BOARD:
			DoMoveByVector( hitPosition );
			break;

		case CAA_UNBOARD:
			DoMoveByVector( hitPosition );
			break;

		// mesh is now transparent but cell? still causes this with hitArmy=none , do nothing
		case CAA_SELECT_ARMY:
			DoSelectArmy( hitArmy );
			break;

		case CAA_ATTACK_ARMY:
		// negotiation actions treated as attacks internally in command system:
		case CAA_BRIBE:
		case CAA_JOIN_FORCE:
		case CAA_JOIN_OFFER:
		case CAA_FLEE:
			DoAttackArmy( hitPosition );
			break;

		case CAA_MEET_ARMY:
		// talk action treated as meet internally in command system:
		case CAA_TALK:
			if( hitArmy != none ) { DoMeetArmy( hitArmy.GetCell().GetLocation() ); }
			else { DoMeetArmy( hitPosition ); }
			break;

		case CAA_TELEPORT:
			class'H7CheatWindowCntl'.static.Teleport( hitPosition );
			break;

		case CAA_VISIT:
			DoVisitByVector( hitPosition );
			break;

		case CAA_PICK_UP:
			DoVisitByVector( hitPosition );
			break;
		
		case CAA_SPELL_OK:
			H7HeroAbility(mAdventureController.GetSelectedArmy().GetHero().GetPreparedAbility()).DoSpellStartUpdates();
			if( hitActor.IsA( 'Landscape' ) || mAdventureController.GetSelectedArmy().GetHero().GetPreparedAbility().RevealsFog() )
			{
				target = GetCellByWorldLocation( hitPosition );
			}
			else
			{
				target = hitActor;
			}

			mAdventureController.SetActiveUnitCommand_UsePreparedAbility(target);
			H7HeroAbility(mAdventureController.GetSelectedArmy().GetHero().GetPreparedAbility()).DoSpellFinishUpdates();
			break;

		case CAA_SPELL_NO:
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitPosition,mAdventureController.GetLocalPlayer(),class'H7Loca'.static.LocalizeSave("FCT_CANNOT_CAST","H7FCT"));
			break;

		case CAA_NOTHING:
			// nothing
			if( mAdventureController.GetSelectedArmy() == none )
			{
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hitPosition,mAdventureController.GetLocalPlayer(),class'H7Loca'.static.LocalizeSave("NO_HERO_SELECTED","H7Adventure"));
			}
			break;

		default:
			;
	}
}

function DoLeaveShelter()
{
	local H7VisitableSite shelter;
	shelter = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetVisitableSite();
	H7Shelter( shelter ).ExpelArmy();
}

function HandleAbortManipulation()
{
	if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none && class'H7AdventureController'.static.GetInstance().GetSelectedArmy().IsLocked() )
	{
		class'H7DestructibleObjectManipulator'.static.AbortManipulation( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() );
	}
	DoCurrentArmyActionByCursor();
}

function bool IsUnderFog( H7AdventureMapCell cell )
{
	return !cell.GetGridOwner().GetFOWController().CheckExploredTile( mAdventureController.GetLocalPlayer().GetPlayerNumber(), cell.GetCellPosition() );
}

// OPTIONAL use unify function for Negotiate() and AddThreatInfo()
// hero can be a neutral army fake hero
function ECurrentArmyAction GetArmyActionByHero( H7AdventureHero hitHero,optional out float chanceOfAction)
{
	local H7AdventureArmy defendArmy,attackArmy;
	local array<EPlayerNumber> playersWithDisposition;
	local bool playerHasDisposition;
	local EDispositionType dispType;
	local int lastNegotiationResult;
	
	mHitActor = hitHero;

	attackArmy = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();
	if( !attackArmy.GetPlayer().IsControlledByLocalPlayer() )
	{
		attackArmy = none;
	}

	if(attackArmy == none)
	{
		return CAA_NOTHING;
	}

	defendArmy = hitHero.GetAdventureArmy();
	chanceOfAction = 1;

	if( defendArmy.IsBeingRemoved() && !defendArmy.IsGarrisoned() ) 
	{
		return CAA_NOTHING;
	}

	// priority 1 - npc
	if(defendArmy.IsNPC())
	{
		if(defendArmy.IsTalking())
		{
			return CAA_TALK;
		}
		else
		{
			return CAA_NOTHING;
		}
	}

	if( attackArmy == none )
	{
		return CAA_ATTACK_ARMY;
	}
	
	// priority 2 - self
	if(attackArmy == defendArmy)
	{
		return CAA_SELECT_ARMY;
	}

	// priority 3 - team armies & own armies
	if(defendArmy.GetPlayer().IsPlayerAllied( attackArmy.GetPlayer() ) || defendArmy.GetPlayer() == attackArmy.GetPlayer())
	{
		// If Team Trade is disabled, players can only trade with their own heroes
		if( class'H7AdventureController'.static.GetInstance().GetTeamTrade() || !class'H7AdventureController'.static.GetInstance().GetTeamTrade() && defendArmy.GetPlayer() == attackArmy.GetPlayer() )
		{
			return CAA_MEET_ARMY;
		}
		else
		{
			return CAA_NOTHING;
		}

	}
	
	// priority 4 - real hero (enemy)
	if(defendArmy.GetHero().IsHero()) 
	{
		return CAA_ATTACK_ARMY;
	}

	// priority 5 - reaction overwrites
	defendArmy.GetPlayerDispositions( playersWithDisposition );
	dispType = defendArmy.GetDiplomaticDisposition();
	if( playersWithDisposition.Find( attackArmy.GetPlayerNumber() ) != INDEX_NONE || playersWithDisposition.Length == 0 )
	{
		playerHasDisposition = true;
		if( attackArmy.GetHero().IsAlliedWithEverybody() && dispType == DIT_JOIN_PRICE )
		{
			dispType = DIT_JOIN_FREE;
		}
	}
	if(playerHasDisposition)
	{
		switch(dispType)
		{
			case DIT_ALWAYS_FIGHT: return CAA_ATTACK_ARMY;
			case DIT_JOIN_PRICE: return CAA_BRIBE;
			case DIT_JOIN_FREE: return CAA_JOIN_OFFER;
			case DIT_FORCE_JOIN: return CAA_JOIN_FORCE;
			case DIT_FLEE: return CAA_FLEE;
			case DIT_NEGOTIATE: 
				if(	attackArmy.HasNegotiatedWith( defendArmy, lastNegotiationResult ) )
				{
					if( lastNegotiationResult == 1 )
					{
						return CAA_BRIBE;
					}
					else
					{
						return CAA_ATTACK_ARMY;
					}
				}
				else
				{
					return CAA_ATTACK_ARMY;
				}
				//(wtf does this mean)
				// TODO calculate chanceOfAction 
		}
	}

	// priority 6 - actual gameplay mechanics, negotiation
	return CAA_ATTACK_ARMY;
}

function DeleteLastHitActor()
{
	mHitActor = none;
}

function ECurrentArmyAction GetArmyActionByVisitable( H7VisitableSite visitableSite, optional out float chanceOfAction )
{
	mHitActor = visitableSite;
	if( visitableSite == none )
	{
		return CAA_NOTHING;
	}
	if( H7IHideable(visitableSite) != none &&  H7IHideable(visitableSite).IsHiddenX() )
	{
		return CAA_NOTHING;
	}
	if( H7Observatory( visitableSite ) != none && H7Observatory( visitableSite ).GetHeadquarters() != none )
	{
		return CAA_NOTHING;
	}
	if( visitableSite.IsA('H7Ship') && H7Ship(visitableSite).IsHidden() )
	{
		return CAA_NOTHING;
	}
	if( visitableSite.GetEntranceCell().HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
	{
		if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			if( visitableSite.GetEntranceCell().GetArmy() == none )
			{
				return CAA_VISIT;
			}
		}

		if( visitableSite.IsA('H7Teleporter') )
		{
			if( H7Teleporter( visitableSite ).IsBlockedByArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
			{
				if( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetArmy() != none )
				{
					return GetArmyActionByHero( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetArmy().GetHero(), chanceOfAction );
				}
				else if( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) != none )
				{
					return GetArmyActionByHero( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero(), chanceOfAction );
				}
				else
				{
					return CAA_VISIT;
				}
			}
			else
			{
				return CAA_VISIT;
			}
		}
		
		return CAA_ATTACK_ARMY;
	}
	if( visitableSite.IsA('H7Teleporter') )
	{
		if( H7Teleporter( visitableSite ).IsBlockedByArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			if( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetArmy() != none )
			{
				return GetArmyActionByHero( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetArmy().GetHero(), chanceOfAction );
			}
			else if( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) != none )
			{
				return GetArmyActionByHero( H7Teleporter( visitableSite ).GetTargetTeleporter().GetEntranceCell().GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero(), chanceOfAction );
			}
			else
			{
				return CAA_VISIT;
			}
		}
		else
		{
			return CAA_VISIT;
		}
	}
	if( visitableSite.IsA( 'H7Ship' ) && !H7Ship( visitableSite ).IsHidden() )
	{
		if( mAdventureController.GetSelectedArmy().HasShip() )
		{
			return CAA_NOTHING;
		}
		else if(H7Ship( visitableSite ).GetEntranceCell().mIsDeepWater)
		{
			return CAA_BOARD;
		}
		else
		{
			return CAA_NOTHING;
		}
	}
	else if( H7IPickable( visitableSite ) != none )
	{
		return CAA_PICK_UP;
	}
	else
	{
		return CAA_VISIT; /// TODO : Hide and .... 
	}
}

function DoCurrentArmyActionByCell(H7AdventureMapCell cell)
{
	local H7AdventureArmy army, friendlyArmy;

	army = cell.GetHostileArmy( mAdventureController.GetLocalPlayer() );
	friendlyArmy = cell.GetArmy();
	if(army != none) // cell has hostile army
	{
		if( !army.IsHidden() && !army.IsBeingRemoved() )
		{
			DoAttackArmy( cell.GetLocation() );
		}
	}
	else if( friendlyArmy != none ) // cell has friendly army
	{
		if( mAdventureController.GetTeamTrade() || !mAdventureController.GetTeamTrade() && mAdventureController.GetLocalPlayer() == friendlyArmy.GetPlayer() )
		{
			if( !friendlyArmy.IsHidden() && !friendlyArmy.IsBeingRemoved() )
			{
				DoMeetArmy( friendlyArmy.Location );
			}
		}
	}
	else if(cell.GetVisitableSite() != none) // cell is building -> visit
	{
		DoVisit( cell.GetVisitableSite() );
	}
	else // cell is free -> move
	{
		DoMoveToCell(cell);
	}
}

function DoSelectArmy( H7AdventureArmy armyToSelect )
{
	if( armyToSelect.GetPlayer() == mAdventureController.GetLocalPlayer() && !armyToSelect.IsACaravan() )
	{
		mAdventureController.SelectArmy( armyToSelect, true );
	}
}

function bool CheckPickup( out array<H7AdventureMapCell> path, H7AdventureMapCell start, H7AdventureArmy armyToAttack, H7AdventureHero currentHero )
{
	if( start.GetArmy().GetHero().GetCurrentMovementPoints() >= start.GetArmy().GetHero().GetModifiedStatByID( STAT_PICKUP_COST ) )
	{
		path.Remove( path.Length - 1, 1 );
		mAdventureController.SetActiveUnitCommand_MoveMeet( path, armyToAttack.GetHero() );
	}
	else
	{
		if( armyToAttack != none )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, currentHero.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NOT_ENOUGH_POINTS_TO_ATTACK","H7FCT"));
		}
		else
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, currentHero.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NOT_ENOUGH_POINTS_TO_PICKUP","H7FCT"));
		}
		return false;
	}

	return true;
}

function bool DoTradeWithArmy( Vector targetPos, optional bool forceExecution = false, optional bool ignoreFoW = false )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local H7AdventureArmy armyToMeet;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool isAdjacentPile;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();

	start = currentHero.GetCell();
	target = GetCellByWorldLocation( targetPos );
	armyToMeet = target.GetArmy();

	if( forceExecution == true )
	{
		currentHero.SetLastCellMovement(target);
	}

	if(start == target)
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, currentHero.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_HERE","H7FCT"));
		return false;
	}

	;
	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), ignoreFoW );
	;

	if( path.Length == 0 )
	{
		if( start.GetCellPosition() != target.GetCellPosition() )
		{
			;
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetPos, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
			return false;
		}
	}


	if( path.Length > 0 )
	{
		// we don't want to have the cell of the target army in the path for pickable items
		path.Remove( path.Length - 1, 1 ); 
		if( path.Length == 0 )
		{
			isAdjacentPile = true;
		}
	}
	isAdjacentPile = start.IsNeighbour( target );
	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );
	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	foreach pathCosts( cost )
	{
		pathCost += cost;
	}

	if( currentHero.GetPlayer().GetPlayerType() != PLAYER_AI )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}

	// check if we should move
	if( target == currentHero.GetLastCellMovement() )
	{
		// check if we can move
		if( numOfWalkableCells > 0 || isAdjacentPile )
		{
			if( mustInteract )
			{
				walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
				if( H7Garrison( visitableSite ) != none )
				{
					mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
				}
			}
			else
			{
				if( pathCost > currentHero.GetCurrentMovementPoints() )
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, armyToMeet.GetHero() );
				}
			}
		}
		else
		{
			ShowFCTNoPath( targetPos, path.Length, currentHero.GetPlayer(), target );
			return false;
		}
	}

	currentHero.SetLastCellMovement(target);
	return true;
}

function bool DoAttackArmy( Vector targetPos, optional bool forceExecution = false, optional bool ignoreFoW = false )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local H7AdventureArmy armyToAttack;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool mustInteract;
	local H7VisitableSite visitableSite;
	local bool isAdjacent, noPreviousFCT;

	noPreviousFCT = true;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();
	start = currentHero.GetCell();
	target = GetCellByWorldLocation( targetPos );

	armyToAttack = target.GetHostileArmy( currentHero.GetPlayer() );
	if( armyToAttack == none )
	{
		if( H7Teleporter( target.GetVisitableSite() ) != none )
		{
			armyToAttack = H7Teleporter( target.GetVisitableSite() ).GetTargetCell().GetHostileArmy( currentHero.GetPlayer() );
		}
	}
	
	// replace target cell with army cell
	if( armyToAttack != none )
	{
		target = target;
		//if( H7Teleporter( target.GetVisitableSite() ) != none && H7Teleporter( target.GetVisitableSite() ).GetTargetCell() == armyToAttack.GetCell() )
		//{
		//	target = target;
		//	// target stays the same I guess?
		//}
		//else
		//{
			
		//	//target = armyToAttack.GetCell();
		//}
	}

	;
	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), ignoreFoW );
	;

	if( path.Length == 1 )
	{
		noPreviousFCT = CheckPickup( path, start, armyToAttack, currentHero );
		if( !noPreviousFCT )
		{
			return false;
		}
	}

	if( path.Length > 0 )
	{	
		if( path[path.Length-1].GetArmy() != none )
		{
			path.Remove( path.Length - 1, 1 ); // we don't want to have the cell of the target army in the path
		}

		currentHero.SetCurrentPath( path );
		pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

		walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
		
		conflictCellIndex = -1;
		for( i = 0; i < walkablePath.Length; ++i )
		{
			if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
			{
				mustInteract =  true;
				interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
				visitableSite = walkablePath[ i ].GetVisitableSite();
				conflictCellIndex = i;
				break;
			}
		}

		if( !currentHero.GetPlayer().IsControlledByAI() )
		{
			mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
		}

		if( !mustInteract && path.Length == 1 )
		{
			noPreviousFCT = CheckPickup( path, start, armyToAttack, currentHero );
		}
	}

	isAdjacent = start.IsNeighbour( target );

	foreach pathCosts( cost )
	{
		pathCost += cost;
	}

	// workaround for "telekinetic" visiting
	if( path.Length == 0 && !isAdjacent )
	{
		currentHero.SetLastCellMovement(target);
		
		if(currentHero.GetPlayer().IsControlledByLocalPlayer())
		{
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CANNOT_MOVE_THERE");
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetPos, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
		}

		return false;
	}

	if( forceExecution == true ) // bypassing the 'double click' madness ...
	{
		currentHero.SetLastCellMovement(target);
	}

	// check if we can move
	if( target == currentHero.GetLastCellMovement())
	{
		if( numOfWalkableCells > 0 || isAdjacent )
		{
			if( pathCost > currentHero.GetCurrentMovementPoints() )
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement( target );
					return false;
				}
			}
			else
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, armyToAttack.GetHero() );
				}
			}
		}
		else
		{
			if( !start.IsNeighbour( target ) && noPreviousFCT )
			{
				ShowFCTNoPath( targetPos, path.Length, currentHero.GetPlayer(), armyToAttack.GetHero() );
			}
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	return true;
}




function bool DoMoveToCell(H7AdventureMapCell target, optional bool forceExecution = false, optional bool ignoreFoW = false )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start;
	local H7AdventureHero currentHero, interactableHero;
	local int numOfWalkableCells, i, conflictCellIndex;
	local array<float> pathCosts;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();
	start = currentHero.GetCell();
	
	if(start == target)
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, currentHero.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_HERE","H7FCT"));
		return false;
	}

	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), ignoreFoW );
	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	if( !currentHero.GetPlayer().IsControlledByAI() )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}


	if( forceExecution == true ) // bypassing the 'double click' madness ...
	{
		currentHero.SetLastCellMovement(target);
	}

	// check if we should move
	if( target == currentHero.GetLastCellMovement() )
	{
		// check if we can move
		if( numOfWalkableCells > 0 )
		{
			if( mustInteract )
			{
				walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);				
				if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
				{
					mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
				}
			}
			else
			{
				mAdventureController.SetActiveUnitCommand_Move( walkablePath );
			}
		}
		else
		{
			ShowFCTNoPath( target.GetLocation(), path.Length, currentHero.GetPlayer(), target );
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	return true;
}

function bool DoMovePatrol(H7AdventureMapCell target, optional bool forceExecution = false)
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start;
	local H7AdventureHero currentHero, interactableHero;
	local int numOfWalkableCells, i, conflictCellIndex;
	local array<float> pathCosts;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();
	start = currentHero.GetCell();
	
	if(start == target)
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, currentHero.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_HERE","H7FCT"));
		return false;
	}

	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), true );
	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	if( !currentHero.GetPlayer().IsControlledByAI() )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}


	if( forceExecution == true ) // bypassing the 'double click' madness ...
	{
		currentHero.SetLastCellMovement(target);
	}

	// check if we should move
	if( target == currentHero.GetLastCellMovement() )
	{
		// check if we can move
		if( numOfWalkableCells > 0 )
		{
			if( mustInteract )
			{
				walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);				
				if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
				{
					mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
				}
			}
			else
			{
				mAdventureController.SetActiveUnitCommand_MovePatrol( walkablePath );
			}
		}
		else
		{
			ShowFCTNoPath( target.GetLocation(), path.Length, currentHero.GetPlayer(), target );
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	return true;
}

function DoMoveByVector( Vector targetPos, optional bool forceExecution = false )
{
	local H7AdventureMapCell  target;

	target = GetCellByWorldLocation( targetPos );
	
	DoMoveToCell(target,forceExecution);
}

function bool DoVisitByVector( Vector targetPos, optional bool forceExecution = false )
{
	local H7VisitableSite targetSite;

	// check if there is an adventure object under the mouse cursor
	if( forceExecution == false )
	{
		targetSite = H7VisitableSite( GetMouseHitActorAndLocation( targetPos ) );
	}

	// check if there is a visitable cell under the mouse cursor if there is no direct collision
	if( targetSite == none )
	{
		targetSite = GetCellByWorldLocation( targetPos ).GetVisitableSite();
	}
	// if there is still no target object found, cease function
	if( targetSite == none )
	{
		return false;
	}

	return DoVisit(targetSite,forceExecution);
}

function bool DoMeetArmy( Vector targetPos, optional bool forceExecution = false)
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local H7AdventureArmy armyToMeet;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool isAdjacentPile;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();

	start = currentHero.GetCell();
	target = GetCellByWorldLocation( targetPos );
	armyToMeet = target.GetArmy();
	if( armyToMeet == none && target.GetTeleporter() != none )
	{
			armyToMeet = target.GetTeleporter().GetTargetCell().GetArmy();
	}

	if( forceExecution == true )
	{
		currentHero.SetLastCellMovement(target);
	}

	if(start == target)
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, currentHero.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_HERE","H7FCT"));
		return false;
	}

	;
	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), currentHero.IsControlledByAI() );
	;

	if( path.Length == 0 )
	{
		if( start.GetCellPosition() != target.GetCellPosition() )
		{
			;
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetPos, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
			return false;
		}
	}


	if( path.Length > 0 )
	{
		// we don't want to have the cell of the target army in the path for pickable items
		path.Remove( path.Length - 1, 1 ); 
	}

	isAdjacentPile = start.IsNeighbour( target );

	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );
	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	foreach pathCosts( cost )
	{
		pathCost += cost;
	}

	if( currentHero.GetPlayer().GetPlayerType() != PLAYER_AI )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}

	// check if we should move
	if( target == currentHero.GetLastCellMovement() )
	{
		// check if we can move
		if( numOfWalkableCells > 0 || isAdjacentPile )
		{
			if( mustInteract )
			{
				walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
				if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
				{
					mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
				}
			}
			else
			{
				if( pathCost > currentHero.GetCurrentMovementPoints() )
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement( target );
					return false;
				}
				else if (armyToMeet != None)
				{
					mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, armyToMeet.GetHero() );
				}
			}
		}
		else
		{
			ShowFCTNoPath( targetPos, path.Length, currentHero.GetPlayer(), target );
			return false;
		}
	}

	currentHero.SetLastCellMovement(target);
	return true;
}

function bool DoVisit(H7VisitableSite targetSite, optional bool forceExecution = false, optional bool ignoreFoW = false )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool isAdjacentPile;
	local bool mustInteract;
	local H7VisitableSite visitableSite;
	local bool foreignVisit;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();

	foreignVisit = currentHero.GetPlayer() != targetSite.GetPlayer();

	start = currentHero.GetCell();
	target = targetSite.GetEntranceCell();

	if( forceExecution == true )
	{
		currentHero.SetLastCellMovement(target);
	}

	if(targetSite.SpendPickupCostsOnVisit(currentHero))
	{
		pathCost = currentHero.GetModifiedStatByID(STAT_PICKUP_COST);
	}

	
	// recurring visit
	if( start == target )
	{
		if( pathCost > currentHero.GetCurrentMovementPoints() ) 
		{
			ShowFCTNoPath( targetSite.Location, path.Length,  currentHero.GetPlayer(), targetSite, true );
			return false;
		}
		else
		{
			mAdventureController.SetActiveUnitCommand_MoveVisit( path, targetSite );
			return true;
		}
	}

	//if( target.GetArmy() != none && target.GetArmy() != start.GetArmy() && H7Fort( targetSite ) == none )
	//{
	//	`LOG_ADVEN("visitable cell blocked by army!"); 
	//	class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, targetSite.GetEntranceCell().GetLocation(), currentHero.GetPlayer(), `Localize("H7FCT", "FCT_BLOCKED_BY_ARMY", "MMH7Game") );
	//	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("BLOCKED_BY_ARMY");
	//	currentHero.SetLastCellMovement(target);
	//	return false;
	//}

	;
	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), ignoreFoW );
	;

	if( path.Length == 0 )
	{
		if( start.GetCellPosition() != target.GetCellPosition() || start.GetGridOwner() != target.GetGridOwner() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetSite.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
			;
			return false;
		}
	}

	isAdjacentPile = start.IsNeighbour( target );

	if( path.Length > 0 )
	{
		// we don't want to have the cell of the target object in the path for things we need to fondle
		if( !targetSite.IsUnblockingEntrance() || ( foreignVisit && targetSite.IsA( 'H7AreaOfControlSiteLord' ) ) )
		{
			path.Remove( path.Length - 1, 1 );
		}
		currentHero.SetCurrentPath( path );
	}
	;
	
	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	foreach pathCosts( cost )
	{
		
		pathCost += cost;
	}
	if( !currentHero.GetPlayer().IsControlledByAI() )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}

	// check if we can move
	if( target == currentHero.GetLastCellMovement() )
	{
		if( numOfWalkableCells > 0 || isAdjacentPile && pathCost <= currentHero.GetCurrentMovementPoints() )
		{
			if( pathCost > currentHero.GetCurrentMovementPoints() )
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement(target);
					return false;
				}
			}
			else
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, targetSite );
				}
			}
		}
		else
		{
			;
			if( isAdjacentPile && pathCost > currentHero.GetCurrentMovementPoints() )
			{
				ShowFCTNoPath( targetSite.Location, path.Length,  currentHero.GetPlayer(), targetSite, true );
			}
			else
			{
				ShowFCTNoPath( targetSite.Location, path.Length, currentHero.GetPlayer(), targetSite );
			}
			currentHero.SetLastCellMovement(target);
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	;
	return true;
}

function bool DoExplore(H7AdventureMapCell targetCell, optional bool forceExecution = false, optional bool ignoreFoW = false, optional bool noCut = false )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool isAdjacentPile;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();

	start = currentHero.GetCell();
	target = targetCell;

	if(forceExecution==true)
	{
		currentHero.SetLastCellMovement(target);
	}

	// recurring visit
	if(start==target)
	{
		if( pathCost>currentHero.GetCurrentMovementPoints() ) 
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	if( target.GetArmy()!=none && target.GetArmy()!=start.GetArmy() )
	{
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, targetCell.GetLocation(), currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_BLOCKED_BY_ARMY","H7FCT") );
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("BLOCKED_BY_ARMY");
		currentHero.SetLastCellMovement(target);
		return false;
	}

	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), ignoreFoW );
	if( path.Length==0 )
	{
		if( start.GetCellPosition()!=target.GetCellPosition() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, target.GetLocation(), currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
			return false;
		}
	}

	isAdjacentPile = start.IsNeighbour(target);

	// for exploration of that cell we strip number of cells equal to the discovery range of the hero
	if( noCut==false )
	{
		for( i = 0; i < path.Length; ++i )
		{
			// make a cutoff at where we first see the exploration target
			if( class'H7Math'.static.CheckPointInCircle( path[i].mPosition, target.mPosition, currentHero.GetScoutingRadius() - 1 ) )
			{
				path.Remove( i, path.Length - i );
			}
		}
		if(forceExecution==true)
		{
			target=path[path.Length-1];
			currentHero.SetLastCellMovement(target);
		}
	}

	currentHero.SetCurrentPath(path);

	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	conflictCellIndex = -1;
	for( i=0; i<walkablePath.Length; ++i )
	{
		if( walkablePath[i].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	foreach pathCosts(cost)
	{
		pathCost+=cost;
	}
	if( !currentHero.GetPlayer().IsControlledByAI() )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}

	// check if we can move
	if( target==currentHero.GetLastCellMovement() )
	{
		if( numOfWalkableCells>0 || isAdjacentPile && pathCost<=currentHero.GetCurrentMovementPoints() )
		{
			if( pathCost>currentHero.GetCurrentMovementPoints() )
			{
				if(mustInteract)
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement(target);
					return false;
				}
			}
			else
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement(target);
					return true;
				}
			}
		}
		else
		{
			currentHero.SetLastCellMovement(target);
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	;
	return true;
}

function bool DoRecruitVisit( Vector targetPos, optional bool forceExecution = false )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local H7VisitableSite targetSite;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool isAdjacentPile;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();

	// check if there is an adventure object under the mouse cursor
	if( forceExecution == false )
	{
		targetSite = H7VisitableSite( GetMouseHitActorAndLocation( targetPos ) );
	}

	// check if there is a visitable cell under the mouse cursor if there is no direct collision
	if( targetSite == none )
	{
		targetSite = GetCellByWorldLocation( targetPos ).GetVisitableSite();
	}
	// if there is still no target object found, cease function
	if( targetSite == none )
	{
		return false;
	}

	start = currentHero.GetCell();
	target = targetSite.GetEntranceCell();

	if( forceExecution == true )
	{
		currentHero.SetLastCellMovement(target);
	}

	if( target.GetArmy() != none && target.GetArmy() != start.GetArmy() )
	{
		;
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetPos, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_BLOCKED_BY_ARMY","H7FCT"));
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("BLOCKED_BY_ARMY");
		currentHero.SetLastCellMovement(target);
		return false;
	}

	;
	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), true );
	;

	if( path.Length == 0 )
	{
		if( start.GetCellPosition() != target.GetCellPosition() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetPos, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
			;
			return false;
		}
		else
		{
			mAdventureController.SetActiveUnitCommand_VisitAndRecruit(targetSite);
			return true;
		}
	}


	if( path.Length > 0 )
	{
		// we don't want to have the cell of the target object in the path for fondleable sites
		if( !targetSite.IsUnblockingEntrance() )
		{
			path.Remove( path.Length - 1, 1 ); 
		}
	}
	isAdjacentPile = start.IsNeighbour( target );
	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	foreach pathCosts( cost )
	{
		pathCost += cost;
	}
	if( !currentHero.GetPlayer().IsControlledByAI() )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}

	// check if we can move
	if( target == currentHero.GetLastCellMovement() )
	{
		if( numOfWalkableCells > 0 || isAdjacentPile ) 
		{
			if( pathCost > currentHero.GetCurrentMovementPoints() )
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement(target);
					return false;
				}
			}
			else
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveVisitAndRecruit( walkablePath, targetSite );
				}
			}
		}
		else
		{
			ShowFCTNoPath( targetPos, path.Length, currentHero.GetPlayer(), targetSite );
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	return true;
}

function bool DoGarrisonVisit( Vector targetPos, optional bool forceExecution = false, optional bool ignoreFoW = true )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local H7VisitableSite targetSite;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool isAdjacentPile;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();

	// check if there is an adventure object under the mouse cursor
	if( forceExecution == false )
	{
		targetSite = H7VisitableSite( GetMouseHitActorAndLocation( targetPos ) );
	}

	// check if there is a visitable cell under the mouse cursor if there is no direct collision
	if( targetSite == none )
	{
		targetSite = GetCellByWorldLocation( targetPos ).GetVisitableSite();
	}
	// if there is still no target object found, cease function
	if( targetSite == none )
	{
		return false;
	}

	start = currentHero.GetCell();
	target = targetSite.GetEntranceCell();

	if( forceExecution == true )
	{
		currentHero.SetLastCellMovement(target);
	}

	if( target.GetArmy() != none && target.GetArmy() != start.GetArmy() )
	{
		;
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,targetPos, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_BLOCKED_BY_ARMY","H7FCT"));
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("BLOCKED_BY_ARMY");
		currentHero.SetLastCellMovement(target);
		return false;
	}

	;
	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), ignoreFoW );
	;

	if( path.Length == 0 )
	{
		if( start.GetCellPosition() != target.GetCellPosition() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetPos, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
			;
			return false;
		}
	}


	if( path.Length > 0 )
	{
		// we don't want to have the cell of the target object in the path for fondleable sites
		if( !targetSite.IsUnblockingEntrance() )
		{
			path.Remove( path.Length - 1, 1 ); 

		}
	}
	isAdjacentPile = start.IsNeighbour( target );
	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	foreach pathCosts( cost )
	{
		pathCost += cost;
	}
	if( !currentHero.GetPlayer().IsControlledByAI() )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}

	// check if we can move
	if( target == currentHero.GetLastCellMovement() )
	{
		if( numOfWalkableCells > 0 || isAdjacentPile ) 
		{
			if( pathCost > currentHero.GetCurrentMovementPoints() )
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement(target);
					return false;
				}
			}
			else
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveVisitAndGarrison( walkablePath, targetSite );
				}
			}
		}
		else
		{
			ShowFCTNoPath( targetPos, path.Length, currentHero.GetPlayer(), targetSite );
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	return true;
}

function bool DoUpgradeVisit(H7VisitableSite targetSite, optional bool forceExecution = false, optional bool ignoreFoW = false )
{
	local array<H7AdventureMapCell> path, walkablePath;
	local H7AdventureMapCell start, target;
	local H7AdventureHero currentHero, interactableHero;
	local int numOfWalkableCells, conflictCellIndex, i;
	local array<float> pathCosts;
	local float pathCost, cost;
	local bool isAdjacentPile;
	local bool mustInteract;
	local H7VisitableSite visitableSite;

	currentHero = mAdventureController.GetSelectedArmy().GetHero();

	start = currentHero.GetCell();
	target = targetSite.GetEntranceCell();

	if( forceExecution == true )
	{
		currentHero.SetLastCellMovement(target);
	}

	if(targetSite.SpendPickupCostsOnVisit(currentHero))
	{
		pathCost = currentHero.GetModifiedStatByID(STAT_PICKUP_COST);
	}

	
	// recurring visit
	if( start == target )
	{
		if( pathCost > currentHero.GetCurrentMovementPoints() ) 
		{
			
			return false;
		}
		else
		{
			mAdventureController.SetActiveUnitCommand_MoveVisitAndUpgrade( path, targetSite );
			return true;
		}
	}

	if( target.GetArmy() != none && target.GetArmy() != start.GetArmy() )
	{
		; 
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, targetSite.GetEntranceCell().GetLocation(), currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_BLOCKED_BY_ARMY","H7FCT") );
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("BLOCKED_BY_ARMY");
		currentHero.SetLastCellMovement(target);
		return false;
	}

	;
	path = mPathfinder.GetPath( start, target, currentHero.GetPlayer(), currentHero.GetAdventureArmy().HasShip(), ignoreFoW );
	;

	if( path.Length == 0 )
	{
		if( start.GetCellPosition() != target.GetCellPosition() )
		{
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, targetSite.Location, currentHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT"));
			;
			return false;
		}
	}

	isAdjacentPile = start.IsNeighbour( target );

	if( path.Length > 0 )
	{
		// we don't want to have the cell of the target object in the path for things we need to fondle
		if( !targetSite.IsUnblockingEntrance() )
		{
			path.Remove( path.Length - 1, 1 ); 
		}
		currentHero.SetCurrentPath( path );
	}
	;
	
	currentHero.SetCurrentPath( path );
	pathCosts = mPathfinder.GetPathCosts( path, start, currentHero.GetCurrentMovementPoints(), numOfWalkableCells );

	walkablePath = mPathfinder.CutPathToWalkable(path, numOfWalkableCells);
	conflictCellIndex = -1;
	for( i = 0; i < walkablePath.Length; ++i )
	{
		if( walkablePath[ i ].HasHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ) )
		{
			mustInteract =  true;
			interactableHero = walkablePath[i].GetHostileArmy( mAdventureController.GetSelectedArmy().GetPlayer() ).GetHero();
			visitableSite = walkablePath[ i ].GetVisitableSite();
			conflictCellIndex = i;
			break;
		}
	}

	foreach pathCosts( cost )
	{
		
		pathCost += cost;
	}
	if( !currentHero.GetPlayer().IsControlledByAI() )
	{
		mPathPreviewer.ShowPreview( path, numOfWalkableCells, currentHero.GetCurrentMovementPoints(), currentHero.GetMovementPoints(), pathCosts, conflictCellIndex );
	}

	// check if we can move
	if( target == currentHero.GetLastCellMovement() )
	{
		if( numOfWalkableCells > 0 || isAdjacentPile && pathCost <= currentHero.GetCurrentMovementPoints() )
		{
			if( pathCost > currentHero.GetCurrentMovementPoints() )
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_Move( walkablePath );
					currentHero.SetLastCellMovement(target);
					return false;
				}
			}
			else
			{
				if( mustInteract )
				{
					walkablePath = mPathfinder.CutPathToWalkable(walkablePath, conflictCellIndex);
					if( H7Garrison( visitableSite ) != none && H7Garrison( visitableSite ).GetPlayer().IsPlayerHostile( currentHero.GetPlayer() ) )
					{
						mAdventureController.SetActiveUnitCommand_MoveVisit( walkablePath, visitableSite );
					}
					else
					{
						mAdventureController.SetActiveUnitCommand_MoveMeet( walkablePath, interactableHero );
					}
				}
				else
				{
					mAdventureController.SetActiveUnitCommand_MoveVisitAndUpgrade( walkablePath, targetSite );
				}
			}
		}
		else
		{
			;
			if( isAdjacentPile && pathCost > currentHero.GetCurrentMovementPoints() )
			{
				ShowFCTNoPath( targetSite.Location, path.Length,  currentHero.GetPlayer(), targetSite, true );
			}
			else
			{
				ShowFCTNoPath( targetSite.Location, path.Length, currentHero.GetPlayer(), targetSite );
			}
			currentHero.SetLastCellMovement(target);
			return false;
		}
	}
	currentHero.SetLastCellMovement(target);
	;
	return true;
}

protected function ShowFCTNoPath( Vector targetLocation, int pathLength, H7Player initiator, optional H7IEffectTargetable target, optional bool pickup )
{
	if( pathLength == 0 && !pickup )
	{
		if( target == none )
		{
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, targetLocation, initiator, class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE","H7FCT") );
		}
		else
		{
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, targetLocation, initiator, class'H7Loca'.static.LocalizeSave("FCT_CANNOT_MOVE_TO","H7FCT") );
		}

		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CANNOT_MOVE_THERE");
	}
	else
	{
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, targetLocation, initiator, class'H7Loca'.static.LocalizeSave("FCT_NO_MOVEPOINTS_LEFT","H7FCT") );
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("NOT_ENOUGH_MOVE_POINTS");
	}
}

native function Actor GetMouseHitActorAndLocation(out Vector hitLocation);

function HandleTownHighlight()
{
	if( mHitActor != none && !mHitActor.IsA( 'H7TownAsset' ) ) 
	{
		if( mLastHitAsset != none && mLastHitAsset.IsHovered() )
		{
			mLastHitAsset.SetUnhovered();
			mLastHitAsset = none;
		}
	}
	else
	{
		if( mLastHitAsset != mHitActor && H7TownAsset( mHitActor ) != none )
		{
			if( mLastHitAsset != none ) { mLastHitAsset.SetUnhovered(); }
			mLastHitAsset = H7TownAsset( mHitActor );
			mLastHitAsset.SetHovered();
		}
	}
}

function RemoveVisitableSite( H7VisitableSite site )
{
	local H7AdventureMapGridController gridController;
	foreach mGridList( gridController )
	{
		gridController.RemoveVisitableSite( site );
	}
}

function UpdateVisitableSiteRef(H7VisitableSite oldSite, H7VisitableSite newSite)
{
	local H7AdventureMapGridController gridController;
	foreach mGridList( gridController )
	{
		gridController.UpdateVisitableSiteRef( oldSite, newSite );
	}
}

// updates the currentGrid to the one that is closest to the targetPos
function SetCurrentGridByPos( Vector targetPos )
{
	local int newGridIndex;

	newGridIndex = GetClosestGridToPosition( targetPos ).GetIndex();
	if( newGridIndex != mCurrentGridIndex )
	{
		mCurrentGridIndex = newGridIndex;
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateBackground();
		GetCurrentGrid().GetFOWController().ExploreFog();
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().ResetFog();

		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("ADVENTURE_MAP");
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateAreaOfControl( true );
	}
	else
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateAreaOfControl( false );
	}
}

function array<H7VisitableSite> GetVisitableSites()
{
	local array<H7VisitableSite> asitesOut;
	local array<H7VisitableSite> asitesGrid;
	local H7VisitableSite site;
	local int k;

	for(k=0;k<mGridList.Length;k++)
	{
		asitesGrid = mGridList[k].GetVisitableSites();
		foreach asitesGrid(site)
		{
			asitesOut.AddItem(site);
		}
	}
	return asitesOut;
}

// changes the current grid to be the next one in the list of grids
// Moves the camera to that grid (mCurrentGridIndex will be updated in SetCurrentGridByPos when the camera is updated) 
function SetNextCurrentGrid()
{
	local H7Camera				currentCamera;
	local Vector				camVect;
	local H7AdventureMapCell	oldCell, newCell;
	local int					nextGridIndex, newCellX, newCellY;

	currentCamera = H7Camera(class'H7PlayerController'.static.GetPlayerController().PlayerCamera);
	camVect = currentCamera.GetTargetVRP();
	oldCell = GetCellByWorldLocation( camVect );
	nextGridIndex = mCurrentGridIndex + 1;
	if( cTogglePlaneWithoutExploration )
	{
		if( nextGridIndex >= mGridList.Length )
		{
			nextGridIndex = 0;
		}
	}
	else
	{
		if( nextGridIndex >= mGridList.Length )
		{
			nextGridIndex = 0;
		}
		while( mGridList[ nextGridIndex ].GetFOWController().GetNumberOfExploredTilesFor( class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() ) == 0 )
		{
			++nextGridIndex;
			if( nextGridIndex >= mGridList.Length )
			{
				nextGridIndex = 0;
			}
		}
	}

	newCellX = class'H7Math'.static.Map( oldCell.GetCellPosition().X, 0, mGridList[mCurrentGridIndex].GetGridSizeX(), 0, mGridList[nextGridIndex].GetGridSizeX() );
	newCellY = class'H7Math'.static.Map( oldCell.GetCellPosition().Y, 0, mGridList[mCurrentGridIndex].GetGridSizeY(), 0, mGridList[nextGridIndex].GetGridSizeY() );

	newCell = mGridList[nextGridIndex].GetCell( newCellX, newCellY );

	// put the camera pointing to the same position (of the previous grid) but in the new grid, if that position doesnt exist we put the camera on the center of the grid
	if( newCell != none )
	{
		currentCamera.SetTargetVRP( newCell.GetLocation() );
	}
	else
	{
		currentCamera.SetTargetVRP( mGridList[nextGridIndex].GetCenter() );
	}
}

function H7AdventureMapGridController GetClosestGridToPosition( Vector targetPos )
{
	local H7AdventureMapGridController gridController, closestGridController;
	local float dist, closestGridDist;

	closestGridDist = 100000000.f; // infinite
	foreach mGridList( gridController )
	{
		dist = VSize( gridController.GetCenter() - targetPos );
		if( dist < closestGridDist )
		{
			closestGridDist = dist;
			closestGridController = gridController;
		}
	}

	return closestGridController;
}

function UpdateFogRevealPreview()
{
	local ParticleSystemComponent part;
	local int radius;

	foreach mFogRevealPreviewParticles( part )
	{
		part.KillParticlesForced();
		part.DeactivateSystem();
	}

	mFogRevealPreviewParticles.Length = 0;
	
	if( mAdventureController.GetSelectedArmy() != none &&
		mAdventureController.GetSelectedArmy().GetHero().GetPreparedAbility() != none &&
		mAdventureController.GetSelectedArmy().GetHero().GetPreparedAbility().RevealsFog() )
	{
		radius = mAdventureController.GetSelectedArmy().GetHero().GetPreparedAbility().GetFogRevealRadius( mAdventureController.GetSelectedArmy().GetHero() );
		part = WorldInfo.MyEmitterPool.SpawnEmitter( mAdventureController.GetConfig().mRevealFogParticle, mHoveredCell.GetLocation() );
		part.SetScale( radius * 2 + 1 );
		part.SetDepthPriorityGroup( SDPG_UberWorld );
		mFogRevealPreviewParticles.AddItem( part );
	}
}

function ClearFogRevealPreview()
{
	local ParticleSystemComponent part;

	foreach mFogRevealPreviewParticles( part )
	{
		part.KillParticlesForced();
		part.DeactivateSystem();
	}

	mFogRevealPreviewParticles.Length = 0;
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

