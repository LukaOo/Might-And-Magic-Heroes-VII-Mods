/*=============================================================================
 * H7CombatObstacleObject
 * 
 * Base class for combat map obstacles. Handles editor stuff.
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7CombatObstacleObject extends H7EditorMapObject
	implements( H7IGUIListenable, H7IEffectTargetable, H7ICaster, H7IAliasable )
	hideCategories( Movement, Advanced )
	native
	perobjectconfig;

/** Show or hide the preview box */
var(Developer) protected editoronly bool	mShowPreviewBox<DisplayName="Show Preview Box">;
var protected DrawBoxComponent				mPreviewBox;

/** Ingame name of this obstacle */
var(Obstacle) protected localized String	mObstacleName<DisplayName="Name">;
/** X size of the object in tiles */
var(Obstacle) protected int					mBaseSizeX<DisplayName="Base Size X"|ClampMin=1|ClampMax=18>;
/** Y size of the object in tiles */
var(Obstacle) protected int					mBaseSizeY<DisplayName="Base Size Y"|ClampMin=1|ClampMax=18>;
/** Type of the obstacle */
var(Obstacle) protected EObstacleType		mType<DisplayName="Type">;
/** Can this obstacle be destroyed? */
var(Obstacle) protected bool				mDestructible<DisplayName="Destructible">;
/** Hitpoints of this obstacle */
var(Obstacle) protected int					mHitpoints<DisplayName="Hitpoints"|ClampMin=0>;
/** Should the obstacle be removed from the game when it is destroyed? */
var(Obstacle) protected bool				mRemoveWhenDestroyed<DisplayName="Remove when it is destroyed">;
/** The obstacle can provide cover to the units that are in the surrounding cells */
var(Obstacle) protected bool				mApplyCover<DisplayName="Apply cover to surrounding cell"s>;
/** The obstacle will be targeted by the war machines (catapult) in the siege maps */
var(Obstacle) protected bool				mIsSiegeMachineTarget<DisplayName="Is siege machine target">;
/** Spawns this obstacle only if there are moats in the siege map */
var(Obstacle) public bool					mOnlySpawnIfMoats<DisplayName="Spawn only if moats exist">;

var(Obstacle) protected array<H7BaseAbility>mAbilities<DisplayName="Obstacle Abilities">;

var protected transient string mObstacleNameInst;

var protected int							mCurrentHitpoints;
var protected bool							mIsHovering;
var protected IntPoint						mGridPos;
var protected int							mID;
var protected array<Vector>					mCorners;

var protected H7BuffManager					mBuffManager;
var protected H7EventManager				mEventManager;
var protected H7EffectManager				mEffectManager;
var protected H7AbilityManager              mAbilityManager;

var (Sound) protected AkEvent				mDestroySound<DisplayName=Destroy sound>;
var (Sound) protected AkEvent				mHitSound<DisplayName=Get hit sound>;
var (Sound) protected AkEvent				mIdleSound<DisplayName=Idle sound>;

// Implemented from H7IEffectTargetable
native function H7AbilityManager		GetAbilityManager();
native function H7BuffManager			GetBuffManager();
native function H7EventManager			GetEventManager();
function H7EffectManager				GetEffectManager()						{ return mEffectManager; }
native function IntPoint                GetGridPosition();
native function float					GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);
native function H7Player				GetPlayer();
native function H7CombatArmy            GetCombatArmy();

native function Vector                  GetLocation();
native function bool                    IsDefaultAttackActive();
function ECommandTag                    GetActionID( H7BaseAbility ability )    { return ACTION_ABILITY; }  
function								PrepareAbility(H7BaseAbility ability)	{ GetAbilityManager().PrepareAbility( ability ); }
function H7BaseAbility					GetPreparedAbility()                    { return GetAbilityManager().GetPreparedAbility(); }

function Vector							GetProjectileImpactPos()				{ return GetMeshCenter(); }

function float							GetMinimumDamage()                      { return 0; }
function float							GetMaximumDamage()                      { return 0; }
function int							GetAttack()                             { return 0; }
native function int						GetLuckDestiny();
function int							GetMagic()                              { return 0; }
function int							GetStackSize()                          { return 0; }
function EAbilitySchool                 GetSchool()                             { return ABILITY_SCHOOL_NONE; }
native function H7ICaster               GetOriginal();

// override functions
native simulated function int			GetObstacleBaseSizeX();
native simulated function int			GetObstacleBaseSizeY();
function    							SetDestructible( bool val )			{ mDestructible = val; }
simulated function EObstacleType		GetObstacleType()                   { return mType; }
simulated function bool					IsDestructible()                    { return mDestructible; }
simulated function int					GetMaxHitpoints()                   { return mHitpoints; }
simulated function int					GetHitpoints()                      { return mCurrentHitpoints; }
simulated function						ModifyHitpoints( int modval )       { mCurrentHitpoints=Clamp(mCurrentHitpoints+modval,0,mHitpoints); }
simulated function bool					IsHovering()                        { return mIsHovering; }
simulated function						SetIsHovering( bool isHovering )    { mIsHovering=isHovering; }
simulated function						SetGridPos( IntPoint gp )           { mGridPos=gp; }
simulated function IntPoint				GetGridPos()                        { return mGridPos; }
native simulated function int			GetID();
native simulated function StaticMeshComponent	GetMeshComponent();
event bool				                IsApplyCover()						{ return mApplyCover; }
simulated function bool					IsSiegeMachineTarget()				{ return mIsSiegeMachineTarget; }
native function EUnitType  				GetEntityType();

function string	GetName()
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		LocalizeName();
		return mObstacleNameInst;
	}
	else
	{
		return H7CombatObstacleObject( ObjectArchetype ).GetName();
	}
}

function LocalizeName()
{ 
	if( mObstacleNameInst == "" ) 
	{
		if( mObstacleName == "" )
		{
			mObstacleNameInst = "No Name for" @ ObjectArchetype.Name;
		}
		else
		{
			mObstacleNameInst = class'H7Loca'.static.LocalizeContent( self, "mObstacleName", mObstacleName );
		}
	}
}

simulated function Init()
{
	local H7BaseAbility ability;

	mCurrentHitpoints = mHitpoints;
	mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
	class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self );

	mAbilityManager = new(self) class 'H7AbilityManager';
	mBuffManager = new(self) class 'H7BuffManager';
	mEventManager = new(self) class 'H7EventManager';
	mEffectManager = new(self) class 'H7EffectManager';
	mEffectManager.Init( self );
	mBuffManager.Init( self );
	mAbilityManager.SetOwner( self );

	foreach mAbilities( ability )
	{
		GetAbilityManager().LearnAbility( ability );
	}

	if( !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mIdleSound, true, true, self.Location );
	}
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	SetOwner( class'H7CombatMapGridController'.static.GetInstance());
}

simulated event Destroyed()
{
	super.Destroyed();

	if( mID != 0 )
	{
		class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( self );
	}
}

simulated function H7CombatObstacleObject PlaceObstacle( H7SiegeTownData siegeTownData, Vector spawnLocation )
{
	local H7CombatObstacleObject obstacleToAdd, obstacleArchetype;

	// check for the obstacles that can only be placed if there are moats
	if( mOnlySpawnIfMoats && !siegeTownData.HasMoats )
	{
		Destroy();
		return none;
	}

	// respawn the obstacle (needed for the client in multiplayer)
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		obstacleArchetype = self;
	}
	else
	{
		obstacleArchetype = H7CombatObstacleObject( DynamicLoadObject( Pathname( self.ObjectArchetype ), class'H7CombatObstacleObject') );
	}
	
	obstacleToAdd = Spawn( class'H7CombatObstacleObject', class'H7CombatMapGridController'.static.GetInstance(),, spawnLocation, Rotation, obstacleArchetype );
	if( !class'H7GameUtility'.static.IsArchetype( self ) )
	{
		Destroy();
	}

	obstacleToAdd.SetAbilities( mAbilities );
	obstacleToAdd.SetDestructible( mDestructible );

	if( mOnlySpawnIfMoats )
	{
		obstacleToAdd = Spawn( class'H7CombatMapMoat', self,, Location, Rotation, siegeTownData.SiegeObstacleMoat );
		obstacleToAdd.SetAbilities( mAbilities );
		obstacleToAdd.SetHidden( true );
	}

	return obstacleToAdd;
}

function SetAbilities( array<H7BaseAbility> abilities )
{
	mAbilities = abilities;
}

simulated function UsePreparedAbility(H7IEffectTargetable target)
{
	local H7BaseGameController bgController;

	bgController = class'H7BaseGameController'.static.GetBaseInstance();
	bgController.GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( self, UC_ABILITY, ACTION_ABILITY, GetPreparedAbility(), target ) );
}

simulated function EObstacleLevel GetLevel()
{
	if( !mDestructible || mCurrentHitpoints >= mHitpoints )
	{
		return OL_UNTOUCHED;
	}
	else if( mCurrentHitpoints > 0 )
	{
		return OL_DEMOLISHED;
	}
	return OL_DESTROYED;
}

simulated function DataChanged(optional string caller)
{
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

native simulated function vector GetMeshCenter();

simulated function vector GetHeightPos( float offset )
{
	return mMesh.Bounds.Origin + Vect( 0.f, 0.f, 1.f ) * (mMesh.Bounds.BoxExtent.Z + offset);
}

simulated function float GetHeight()
{
	return mMesh.Bounds.BoxExtent.Z * 2.f;
}

simulated function HighlightObstacle()
{
	if( !IsHovering() )
	{	
		SetIsHovering(true);
	}
}

simulated function DehighlightObstacle()
{
	if( IsHovering() )
	{	
		SetIsHovering(false);
	}
}

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true )
{
	local int lowKill, highKill, Kill;
	local vector floatLocation;

	if( !mDestructible )
	{
		return;
	}

	if( isForecast )
	{
		lowKill = result.GetDamageLow(resultIdx) >= GetHitpoints() ? 1 : 0;
		highKill = result.GetDamageHigh(resultIdx) >= GetHitpoints() ? 1 : 0;
		result.SetKillRange(lowKill,highKill,resultIdx);
	}

	Kill = result.GetDamage(resultIdx) >= GetHitpoints() ? 1 : 0;
	result.SetKills(Kill,resultIdx);

	

	if( !isForecast )
	{
		ModifyHitpoints( -result.GetDamage(resultIdx) );
		floatLocation = GetHeightPos( 50.f );
		class'H7FCTController'.static.GetInstance().startFCT(FCT_DAMAGE, floatLocation, none, string(result.GetDamage(resultIdx)), MakeColor(255,0,0,255));

		if( GetLevel() == OL_DESTROYED )
		{
			if( mRemoveWhenDestroyed )
			{
				if( !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
				{
					class'H7SoundManager'.static.PlayAkEventOnActor( self, mDestroySound,,true, class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByPos(mGridPos.X, mGridPos.Y).GetLocation() );
				}

				class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( mGridPos ).RemoveObstacles();
			}
			else
			{
				// this destroyed obstacle will stay in the grid
				mDestructible = false;
			}
		}
		else
		{   
			if( !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
			{
				//Only damaged
				class'H7SoundManager'.static.PlayAkEventOnActor( self, mHitSound,,true, class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByPos(mGridPos.X, mGridPos.Y).GetLocation() );
			}
		}
		
		DataChanged();
	}
}

simulated function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container)
{
	GetEventManager().Raise(triggerEvent, forecast, container);
	mBuffManager.UpdateBuffEvents(triggerEvent, forecast, container);
	mAbilityManager.UpdateAbilityEvents(triggerEvent, forecast, container);
}

// returns the cells that occupy this obstacle
simulated event array<H7CombatMapCell> GetCells()
{
	return class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( GetGridPos() ).GetMergedCells();
}

// return the position of the obstacle corners
native simulated function array<Vector> GetCorners();

simulated function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) {}
simulated function GUIAddListener(GFxObject data,optional H7ListenFocus focus) { class'H7ListeningManager'.static.GetInstance().AddListener(self,data); }

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

