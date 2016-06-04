/*=============================================================================
* H7Teleporter
* =============================================================================
* Dimension portal: A dimension portal leads to one other dimension portal.
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Teleporter extends H7NeutralSite
	native
	hideCategories(Defenses)
	implements(H7ITooltipable, H7IDestructible, H7IHideable)
	dependson(H7ITooltipable)
	placeable
	savegame;

/** Don't access this directly, as subclasses might use a different property of a different teleporter type. */
var(Teleporter) private H7Teleporter mTargetTeleporter<DisplayName="Linked Teleporter"|ToolTip="The other Teleporter to warp to">;
/** The color for this Dimension Portal and its Target */
var(Coloring) protected EEditorObjectColor mColor<DisplayName="Portal Color">;
var(Visuals) protected ParticleSystem mTeleportParticle<DisplayName="Teleport Particle System">;
var(Destruction) protected array<H7DestructibleObjectManipulator> mManipulators<DisplayName="Manipulators to destroy/repair the Teleporter">;

var protected H7AdventureMapCell        mTargetCell; // exit cell of teleporter
var protected H7AdventureGridManager    mGridManager;
var protected savegame bool				mIsDestroyed;
var protected savegame bool				mIsDestroying;
var protected savegame bool				mIsRepairing;

var protected savegame bool				mIsHidden;

native function bool IsHiddenX();

function bool SpendPickupCostsOnVisit(H7AdventureHero visitingHero) { return true; }

// implementation of interface H7IHideable START

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();

	if( GetTargetTeleporter() != none && mTargetCell != none )
	{
		mGridManager.GetCellByWorldLocation( GetEntranceCell().GetLocation() ).RemoveNeighbour( mTargetCell );
		GetEntranceCell().RemoveWayPointNeighbour( mTargetCell.GetWayPoint() );
	}
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();

	if( GetTargetTeleporter() != none && mTargetCell != none && !mIsDestroyed )
	{
		mGridManager.GetCellByWorldLocation( GetEntranceCell().GetLocation() ).AddNeighbour( mTargetCell );
		GetEntranceCell().GetWayPoint().AddWayPointNeighbour( mTargetCell.GetWayPoint() );
	}
}

// implementation of interface H7IHideable END


// implementation of interface H7IDestructible START
function DestroyDestructibleObject()  
{
	local ParticleSystemComponent particle;

	mIsDestroyed = true;

	if( GetTargetTeleporter() != none && mTargetCell != none )
	{
		mGridManager.GetCellByWorldLocation( GetEntranceCell().GetLocation() ).RemoveNeighbour( mTargetCell );
		mGridManager.GetCellByWorldLocation( GetEntranceCell().GetWayPoint().GetLocation() ).RemoveWayPointNeighbour( mTargetCell.GetWayPoint() );
	}

	foreach ComponentList( class'ParticleSystemComponent', particle )
	{
		particle.SetActive( false );
	}
}

function RepairDestructibleObject()   
{
	local ParticleSystemComponent particle;

	mIsDestroyed = false;
	if( GetTargetTeleporter() != none && mTargetCell != none )
	{
		mGridManager.GetCellByWorldLocation( GetEntranceCell().GetLocation() ).AddNeighbour( mTargetCell );
		GetEntranceCell().GetWayPoint().AddWayPointNeighbour( mTargetCell.GetWayPoint() );
	}

	foreach ComponentList( class'ParticleSystemComponent', particle )
	{
		particle.SetActive( true );
	}
}

function bool IsDestroyed()  
{
	return mIsDestroyed;
}

function bool                           IsDestroying()				{ return mIsDestroying; }
function bool                           IsRepairing()				{ return mIsRepairing; }
function                                SetDestroying( bool v )     { mIsDestroying = v; }
function                                SetRepairing( bool v )      { mIsRepairing = v; }

function array<H7DestructibleObjectManipulator> GetManipulators()   { return mManipulators; }

// implementation of interface H7IDestructible END

function H7AdventureMapCell GetTargetCell()         { return mTargetCell; }

/** Always use this to get the target teleporter, as subclasses might override this to use a different property of a different teleporter type. */
native function H7Teleporter GetTargetTeleporter();

/** Always use this to set the target teleporter to none, as subclasses might override this to use a different property of a different teleporter type. */
native function protected ClearTargetTeleporter();

event InitAdventureObject()
{
	local H7AdventureArmy army;
	local H7DestructibleObjectManipulator manipulator;

	super.InitAdventureObject();
	class'H7AdventureController'.static.GetInstance().AddTeleporter( self );

	mGridManager = class'H7AdventureGridManager'.static.GetInstance();

	if( GetTargetTeleporter() != none )
	{
		mTargetCell = GetTargetTeleporter().GetEntranceCell();
	}

	if( GetEntranceCell() != none )
	{
		GetEntranceCell().SetTeleporter( self );
	}
	
	//adding targets visitingCell to own neighbourCells
	if( mTargetCell != none )
	{
		mGridManager.GetCellByWorldLocation( GetEntranceCell().GetLocation() ).AddNeighbour( mTargetCell );
		GetEntranceCell().GetWayPoint().AddWayPointNeighbour( mTargetCell.GetWayPoint() );
	}

	army = GetEntranceCell().GetArmy();
	if( army != none )
	{
		GetEntranceCell().UnregisterArmy( army );
		GetEntranceCell().RegisterArmy( army );
	}

	foreach mManipulators( manipulator )
	{
		manipulator.AddDestructibleObjectByInterface( self );
	}
}

function bool IsBlockedByArmy( H7Player forPlayer )
{
	local H7AdventureMapCell targetCell;

	if( GetTargetTeleporter() != none )
	{
		targetCell = GetTargetTeleporter().GetEntranceCell();

		if( targetCell != none )
		{
			if( targetCell.GetArmy() != none || targetCell.GetHostileArmy( forPlayer ) != none )
			{
				return true;
			}
		}
	}

	return false;
}

event simulated Destroyed()
{
	mGridManager.GetCellByWorldLocation( GetEntranceCell().GetLocation() ).RemoveNeighbour( mTargetCell );
	mGridManager.GetCellByWorldLocation( GetEntranceCell().GetWayPoint().GetLocation() ).RemoveWayPointNeighbour( mTargetCell.GetWayPoint() );
	ClearTargetTeleporter();
	super.Destroyed();
}

function OnVisit( out H7AdventureHero hero )
{
	local string fctMessage;
	local H7Teleporter porter;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }

	super.OnVisit( hero );

	if( GetTargetTeleporter() == none )
	{
		return;
	}

	if( mIsDestroyed )
	{
		fctMessage = class'H7Loca'.static.LocalizeSave("FCT_DESTRUCTIBLE_OBJECT_DESTROYED","H7FCT");
		fctMessage = Repl(fctMessage, "%name", GetName());
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, hero.GetTargetLocation(), hero.GetPlayer(), fctMessage );
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
	}
	else
	{
		porter = GetTargetTeleporter();

		if( GetTargetCell().GetArmy() == none )
		{
			PlayTeleportParticle( self );
			H7AdventurePlayerController( class'H7PlayerController'.static.GetPlayerController() ).TeleportTo( porter.GetEntranceCell(), hero.GetAdventureArmy() );
			PlayTeleportParticle( porter );
		}
		else
		{
			fctMessage = class'H7Loca'.static.LocalizeSave("FCT_TELEPORTER_BLOCKED","H7FCT");
			fctMessage = Repl(fctMessage, "%target", GetTargetCell().GetArmy());
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, hero.GetTargetLocation(), hero.GetPlayer(), fctMessage );	
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("INVALID_SELECT");
		}
	}

	hero.UseMovementPoints( hero.GetModifiedStatByID( STAT_PICKUP_COST ) );
}

function PlayTeleportParticle( H7Teleporter target )
{
	local Vector spawnLocation;

	if( mTeleportParticle == none ) { return; }

	spawnLocation = target.GetEntranceCell().GetLocation();
	spawnLocation.Z = target.Location.Z;
	
	class'H7AdventureController'.static.GetWorldinfo().MyEmitterPool.SpawnEmitter( mTeleportParticle, spawnLocation, Rotator(Vect(0,0,0)), target );
	
	if(mOnVisitSound!=None && class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetPlayer().IsControlledByLocalPlayer())
	{
		class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnVisitSound,true,true,self.Location);
	}
}

static function bool EnterTeleporterCheck( H7AdventureMapCell currentCell, optional H7AdventureMapCell nextCell, optional bool activateParticle, optional H7AdventureArmy army )
{
	local H7Teleporter currentTeleporter;
	local array<H7Teleporter> teleporterList;

	teleporterList = class'H7AdventureController'.static.GetInstance().GetTeleporterList();

	foreach teleporterList( currentTeleporter )
	{
		if( currentCell == currentTeleporter.GetEntranceCell() )
		{
			if( nextCell == none || nextCell == currentTeleporter.GetTargetCell() )
			{
				if( currentTeleporter.GetTargetCell() == none ) return false; 

				H7AdventurePlayerController( class'H7PlayerController'.static.GetPlayerController() ).TeleportTo( currentTeleporter.GetTargetCell(), army );

				if(activateParticle)
				{
					currentTeleporter.PlayTeleportParticle( currentTeleporter );
					currentTeleporter.PlayTeleportParticle( currentTeleporter.GetTargetTeleporter() );
				}

				return true; 
			}
		}
	}
	return false; 
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = self.GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_PORTAL_DESC","H7Teleporter") $ "</font>";
	return data;
}

event PostSerialize()
{
	local ParticleSystemComponent particle;

	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}

	if(IsDestroyed())
	{
		if( GetTargetTeleporter() != none && mTargetCell != none )
		{
			mGridManager.GetCellByWorldLocation( GetEntranceCell().GetLocation() ).RemoveNeighbour( mTargetCell );
			GetEntranceCell().RemoveWayPointNeighbour( mTargetCell.GetWayPoint() );
		}

		foreach ComponentList( class'ParticleSystemComponent', particle )
		{
			particle.SetActive( false );
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

