//=============================================================================
// H7CreatureStack
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStack extends H7Unit
	implements(H7IGUIListenable)
	placeable
	PerObjectConfig
	dependsOn(H7BaseAbility,H7StructsAndEnumsNative)
	native;

// remaining health points of top stack creature
var protected int								mTopCreatureHealth;
// the creature object the stack is composed of to take the default parameters from
var protected H7Creature						mCreature;

var protectedwrite H7BaseCell                   mPreviousCell;

var protected SkeletalMeshActor                 mGhost;
var protected SkeletalMeshActor                 mGhostMove;
var protected Vector                            mGhostMoveTargetLocation;
var protected Rotator                           mGhostMoveTargetRotation;
var protected float                             mGhostMoveTimer;

var protected float                             mFadeInTimerOpacity;
var protected float                             mFadeInTimerWhite;
var protected bool                              mFadeInDone;
var protected bool                              mFadeInOpacityDone;
var protected bool                              mFadeInWhiteDone;
var protected array<float>                      mFadeInOpacities;
var protected array<LinearColor>                mFadeInDiffuses;
var protected array<LinearColor>                mFadeInEmissives;
var protected array<MaterialInstanceConstant>   mFadeInMICs;

var protected Vector                            mDivingAttackTargetHeight;
var protected Vector                            mDivingAttackCurrentHeight;
var protected Vector                            mDivingAttackStartHeight;
var protected float                             mDivingAttackTimer;
var protected float                             mDivingAttackMovementSpeed;
var protected float                             mDivingAttackMovementSpeedDescend;
var protected bool                              mIsDiving;
var protected bool                              mDoDivingParabola;
var protected bool                              mParabolaReachedZero;
var protected Rotator	                        mStartRotation;
var protected Rotator	                        mTargetRotation;

var protected bool                              mRestoreRotationAtEndTurn;
var protected Rotator                           mBeginTurnRotation;

// --- moved here from H7EffectSpecialReappearCreatureOnGrid ---
var protected H7CombatMapCell					mTargetCell;
var protected array<H7IEffectTargetable>		mHitUnits;
var protected H7Effect							mEffect;
var protected H7EventContainerStruct			mContainer;
var protected bool								mHasTargets;
var protected bool								mDescend;

var int											mFlyForwardUnits;
var int											mDescendFrom;
// -------------------------------------------------------------

var protected H7Command                         mDelayedCommand;

// the initial stack size beginning of the battle
var protected int								mInitialStackSize;
// current stack size (number of creatures)
var protected int								mStackSize;
// current grid pos on the combat grid
var protected H7CreatureStackMovementControl	mMoveControl;
var protected H7CreatureStackFX					mStackFX;
var protected bool								mIsVisible;
var protected bool								mIsOrphan;

var protected Color								mStackColor;

var protected H7CombatMapGridController			mCombatGridController;

var protected H7CombatMapPathfinder				mPathfinder;
var protected H7UnitCoverManager				mCoverManager;

var protected bool                              mCanBeRevived;
var protected H7BaseCreatureStack               mBaseCreatureStack;
var protected float                             mCoverDamageReduction;
var protected int								mAmmo;
var protected EMovementType                     mMovementType;
var protected bool                              mHasDataChanged;
var protected bool                              mHasMovedThisTurn;

var protected bool                              mIsSummoned;
var protected bool                              mKilled;
var protected bool                              mSkipDeathAnim;
var protected float                             mFakeDeathDelay;
var protected array<H7BaseBuff>                 mStasisSourcesArray;
var protected bool                              mHasCoverFromEffects;
var protected bool                              mIsAlliedPassable;
var protected bool                              mIsBeingTeleported;

var protected float                             mMovementSpeedModifier;
var protected float                             mFlyingSpeedModifier;

var protected H7BaseBuff                        mRetaliatedBuff;
var protected H7BaseAbility                     mSubstituteMoraleAbility;

var protected array<H7CombatMapCell>            mDivingAttackTargetArea;

var protected array<SkeletalMeshActorSpawnable> mPlatoonCreatures;

var protected H7CombatMapCell                   mStrikeAndReturnReferenceCell;

// properties Get/Set methods
// ==========================

function                        DoRestoreRotationAfterTurn()                            { mRestoreRotationAtEndTurn = true; }
function bool                   ShouldRestoreRotationAfterTurn()                        { return mRestoreRotationAtEndTurn; }
function                        SetDelayedCommand( H7Command comm )                     { mDelayedCommand = comm; }
function bool                   HasDelayedCommand()                                     { return mDelayedCommand != none; }
function                        SetHasCoverFromEffects( bool val )                      { mHasCoverFromEffects = val; }
function bool                   HasCoverFromEffects()                                   { return mHasCoverFromEffects; }
function                        SetAlliedPassable( bool val )                           { mIsAlliedPassable = val; }
function bool                   IsAlliedPassable()                                      { return mIsAlliedPassable; }
function                        SetIsBeingTeleported( bool val )                        { mIsBeingTeleported = val; }
function bool                   IsBeingTeleported()                                     { return mIsBeingTeleported; }
function                        SetMovedThisTurn( bool val )                            { mHasMovedThisTurn = val; }
function bool                   HasMovedThisTurn()                                      { return mHasMovedThisTurn; }
native function bool            IsInStasis();
function                        SetIsSummoned( bool val )                               { mIsSummoned = val; }
function bool                   IsSummoned()                                            { return mIsSummoned; }
function                        SetSkipDeathAnim(bool doSkip)	                        { mCreature.SkipDeathAnim(doSkip); }
function bool                   GetSkipDeathAnim()                                      { return mSkipDeathAnim; }
function                        SetFakeDeathDelay(float seconds)                        { mFakeDeathDelay = seconds; }
function						SetStackSize( int stackSize )					        { if( mKilled ) return; mStackSize=stackSize; DataChanged();}
function int					GetStackSize()									        { return mStackSize; }
function						SetCreature(H7Creature creature)				        { mCreature = creature;}
function H7Creature				GetCreature()									        { return mCreature; }
function						SetInitialStackSize(int size)					        { mInitialStackSize = size; }
function int					GetInitialStackSize()							        { return mInitialStackSize; }
function						SetGridPosition( IntPoint gp )					        
{  
	mPreviousCell = mCombatGridController.GetCombatGrid().GetCellByIntPoint( mGridPos );
	mGridPos = gp; 
} // dangerous! - does produce illegal grid and cell states when called in wrong contexts (old cell does not delete stack ref)
function IntPoint				GetGridPosition( )								        { return mGridPos; }
function int					GetAmmo()										        { return mAmmo; }
function						SetAmmo( int ammo )								        { mAmmo = ammo; }
function int					GetLuck()	                                            { return GetDestiny(); }
function                        SetLuck( int luck )                                     { mDestiny = luck; DataChanged();}
function int					GetMorale()										        { return GetCurrentMoral(); }
function                        SetMorale(int moral)                                    { mLeadership = moral; DataChanged(); }
function int					GetMovementPoints()							    
{ 
	local float move;
	move = GetModifiedStatByID(STAT_MAX_MOVEMENT);
	if( move >= 0 )
	{
		return move;
	}
	else
	{
		// no negative movement points!
		return 0;
	}
}
native function bool            IsOffGrid();
native function int             GetDamagePotential( optional int stackSize = -1 );
function array<H7CombatMapCell> GetDivingAttackArea()                                   { return mDivingAttackTargetArea; }
function                        SetDivingAttackArea(array<H7CombatMapCell> area)        { mDivingAttackTargetArea = area; }
delegate                        OnDivingAttackFlyingFinished()                          {}

function H7BaseCreatureStack    GetBaseCreatureStack()                                  { return mBaseCreatureStack; }
function                        SetBaseCreatureStack(H7BaseCreatureStack baseStack)     { mBaseCreatureStack = baseStack; }
function                        SetMovementType(EMovementType type)                     { mMovementType = type; }
function                        SetSubstitutionMoraleAbility( H7BaseAbility ability )
{
	if( ability != none )
	{
		if( ability.IsEqual( mCreature.GetMoralAbility() ) )
		{
			mSubstituteMoraleAbility = none;
			//mCreature.GetMoralAbility().Suppress( false );
			mAbilityManager.LearnAbility( mCreature.GetMoralAbility() );
			return;
		}
		mAbilityManager.UnlearnAbility( mCreature.GetMoralAbility() );
		mSubstituteMoraleAbility = ability;
	}
	else
	{
		mAbilityManager.LearnAbility( mCreature.GetMoralAbility() );
		mSubstituteMoraleAbility = none;
	}
}
function String					GetFlashIconPath()								{ return mCreature.GetFlashIconPath(); }

function						ModifyDefense( int toAdd )					    { mDefense += toAdd; DataChanged();}
function						ModifyAttack( int toAdd )					    { mAttack += toAdd; DataChanged();}
function						ModifyLuck( int toAdd )							{ mDestiny += toAdd; DataChanged();}
function						ModifyMorale( int toAdd )						{ mLeadership += toAdd; DataChanged();}
function bool					IsVisible()										{ return mIsVisible; }
function Color					GetStackColor()									{ return GetCombatArmy().GetPlayer().GetColor(); }
function						SetStackColor( Color value )					{ mStackColor = value; }
native function vector			GetMeshCenter();
function float					GetFXScale()									{ return mCreature.GetFXScale(); }
function vector					GetHeightPos( float offset )					{ return mCreature.GetHeightPos( offset ); }
function float					GetHeight()										{ return mCreature.GetHeight(); }
native function SkeletalMeshComponent	GetMeshComponent();
function bool               	IsRanged()      								{ return mCreature.IsRanged(); }
function bool               	UsesAmmo()      								{ return mCreature.UsesAmmo(); }
function H7CombatMapPathfinder	GetPathfinder()									{ return mPathfinder; }
function H7UnitCoverManager		GetCoverManager()								{ return mCoverManager; }
function bool                   CanBeRevived()                                  { return mCanBeRevived; }
function                        BeRevived( bool value )                         { mCanBeRevived = value; }
function int                    GetBaseInitiative()                             { return mCreature.GetInitiative(); }
function EAbilitySchool         GetSchool()                                     { return mCreature.GetSchool(); }
function EMovementType          GetMovementType()                               { return mMovementType; }
native function H7BaseAbility   GetMeleeAttackAbility();
native function H7BaseAbility   GetRangedAttackAbility();
function H7BaseAbility          GetDefendAbility()                              { return mCreature.GetDefendAbility(); }
function H7BaseAbility          GetWaitAbility()                                { return mCreature.GetWaitAbility(); }
function H7BaseAbility          GetLuckAbility()                                { return mCreature.GetLuckAbility(); }
function H7BaseAbility          GetRetaliationAbility()                         { return mCreature.GetRetaliationAbility(); }
function H7BaseAbility          GetRetaliationOverrideMelee()					{ return mCreature.GetRetaliationOverrideMelee(); }
function H7BaseAbility          GetRetaliationOverrideRanged()					{ return mCreature.GetRetaliationOverrideRanged(); }

native function Vector          GetSocketLocation( name socketName );
function name                   GetProjectileStartSocketName()                  { return mCreature.GetProjectileStartSocketName(); }

function bool                   IsFlankable()                                   { return mCreature.IsFlankable(); }
function                        SetFlankability( bool value )                    { mCreature.SetIsFlankable( value ); }
function bool                   IsFullFullFlankable()                           { return mCreature.IsFullFlankable(); }
function                        SetFullFlankability( bool value )               { mCreature.SetIsFullFlankable( value ); }

function H7CreatureStackMovementControl     GetMovementControl()				    { return mMoveControl; }
function float                              GetMovementSpeed()                      { return mCreature.GetVisuals().GetMovementSpeed() * mMovementSpeedModifier; }
function float                              GetFlyingSpeed()                        { return mCreature.GetVisuals().GetFlyingSpeed() * mFlyingSpeedModifier; }

function                                    SetMovementSpeedModifier(float speed)	{ mMovementSpeedModifier = speed; }
function                                    SetFlyingSpeedModifier(float speed)	    { mFlyingSpeedModifier = speed; }
function array<SkeletalMeshActorSpawnable>  GetPlatoonCreatures()                   { return mPlatoonCreatures; }
function                                    SetStrikeAndReturnCell(H7CombatMapCell cell){ mStrikeAndReturnReferenceCell = cell; }

// Get cretarue morale ability or a substitution
function H7BaseAbility GetMoralAbility()                               
{
	if( mSubstituteMoraleAbility != none ) 
	{
		return mSubstituteMoraleAbility;
	}
	else 
	{
		return mCreature.GetMoralAbility(); 
	}
}

// state functions
// ===============
native function bool IsDead();

function RemoveStackFromGrid( optional bool removeFromCell = true )   
{
	local IntPoint outsideGrid; // OPTIONAL CHECK if this -1 hack is really neccessary
	Hide( removeFromCell );
	outsideGrid.X = -1;
	outsideGrid.Y = -1;
	SetGridPosition(outsideGrid);
}
function RemoveCreatureFromCell()   { if(GetCell() != none) GetCell().RemoveCreatureStack();}
function H7CombatMapCell GetCell()  { return mCombatGridController.GetCombatGrid().GetCellByIntPoint( GetGridPosition() ); }

/**
 *  buries a creature on a cell and spawning creature remains
 *  set to dead but keep it on the grid
 * */
function BuryCreature() { GetCell().PlaceDeadCreature( self ); }

function ShowCreatureRemains() { GetCell().SpawnCreatureRemains(); }

// stasis functions
function                        AddStasisBuff( H7BaseBuff buff )                        { mStasisSourcesArray.AddItem( buff ); }
function H7BaseBuff             GetStasisBuff()                                         
{ 
	if( mStasisSourcesArray.Length > 0 )
	{
		return mStasisSourcesArray[0]; 
	}
	else
	{
		return none;
	}
}
function bool                   HasStasisBuff( H7BaseBuff buff )                        { return mStasisSourcesArray.Find( buff ) != INDEX_NONE; }
function RemoveFirstStasisBuff()                                 
{ 
	if( mStasisSourcesArray.Length > 0 )
	{
		mStasisSourcesArray.Remove( 0, 1 );  
	}
}
function RemoveStasisBuff( H7BaseBuff buff )                     
{
	mStasisSourcesArray.RemoveItem( buff ); 
}

function CreateGhost( H7CombatMapCell destinationCell, optional Rotator rot, optional bool showGhostMove, optional float ghostOpacity = 0.35f )
{
	local int i;
	local MaterialInstanceConstant dasNewMaterial;
	local Rotator empty;
	local AnimNodeRandom animRandom;
	local AnimNodeSequence animIdle;

	//TODO: warnings are coming from here...? 
	if( mGhost != none )
	{
		mGhost.Destroy();
		mGhost = none;
	}
	if( mGhostMove != none )
	{
		mGhostMove.Destroy();
		mGhostMove = none;
	}
	
	mGhost = Spawn( class'SkeletalMeshActorMATSpawnable', self,,Location, Rotation );
	mGhost.SkeletalMeshComponent = new class'SkeletalMeshComponent'( mCreature.GetVisuals().GetSkeletalMesh() );
	if( mGhost.SkeletalMeshComponent != none )
	{
		mGhost.SkeletalMeshComponent.CastShadow = false;
		mGhost.SetLocation( destinationCell.GetCenterByCreatureDim( GetUnitBaseSizeInt() ) );
		mGhost.AttachComponent( mGhost.SkeletalMeshComponent );
		mGhost.SkeletalMeshComponent.SetLightEnvironment( mGhost.LightEnvironment );
		AnimNodeRandom( mGhost.SkeletalMeshComponent.FindAnimNode( 'IdleRandom' ) ).RandomInfo[1].Chance = 0.f;
		animIdle = AnimNodeSequence( mGhost.SkeletalMeshComponent.FindAnimNode( 'Idle' ) );
		if (animIdle != None)
		{
			animIdle.bNoNotifies = true;
		}
	}
	if( rot != empty )
	{
		mGhost.SetRotation( Normalize( Rotation + rot ) );
	}
	else
	{
		mGhost.SetRotation( Rotation );
	}
	if( mGhost.SkeletalMeshComponent != none )
	{
		for( i = 0; i < mGhost.SkeletalMeshComponent.SkeletalMesh.Materials.Length; ++i )
		{
			dasNewMaterial = mGhost.SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant( i );
			dasNewMaterial.SetScalarParameterValue( 'Opacity_Global', ghostOpacity );
		}
	}
	if( showGhostMove )
	{
		if( mGhost.SkeletalMeshComponent != none )
		{
			mGhostMove = Spawn( class'SkeletalMeshActorMATSpawnable', self,,Location, Rotation );
			mGhostMove.SkeletalMeshComponent = new class'SkeletalMeshComponent'( mCreature.GetVisuals().GetSkeletalMesh() );
			mGhostMove.AttachComponent( mGhostMove.SkeletalMeshComponent );
			mGhostMove.SkeletalMeshComponent.CastShadow = false;
			animRandom = AnimNodeRandom( mGhostMove.SkeletalMeshComponent.FindAnimNode( 'IdleRandom' ) );
			if (animRandom != None)
			{
				animRandom.RandomInfo[1].Chance = 0.f;
			}
			animIdle = AnimNodeSequence( mGhostMove.SkeletalMeshComponent.FindAnimNode( 'Idle' ) );
			if (animIdle != None)
			{
				animIdle.bNoNotifies = true;
			}
			mGhostMove.SkeletalMeshComponent.SetLightEnvironment( mGhostMove.LightEnvironment );
		}
		mGhostMoveTargetLocation = destinationCell.GetCenterByCreatureDim( GetUnitBaseSizeInt() );
		mGhostMoveTargetRotation = Normalize( Rotation + rot );
		
		if( mGhost.SkeletalMeshComponent != none )
		{
			for( i = 0; i < mGhostMove.SkeletalMeshComponent.SkeletalMesh.Materials.Length; ++i )
			{
				dasNewMaterial = mGhostMove.SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant( i );			
				dasNewMaterial.SetScalarParameterValue( 'Opacity_Global', ghostOpacity );
			}
		}
	}
}

function LerpGhostMove( float deltaTime )
{
	local Rotator empty;

	if( mGhostMove != none )
	{
		mGhostMoveTimer += deltaTime * 0.1f;
		mGhostMove.SetLocation( VLerp( mGhostMove.Location, mGhostMoveTargetLocation, mGhostMoveTimer ) );
		if( mGhostMoveTargetRotation != empty )
		{
			mGhostMove.SetRotation( RLerp( mGhostMove.Rotation, mGhostMoveTargetRotation, mGhostMoveTimer ) );
		}

		if( mGhostMoveTimer >= 0.1f ) 
		{
			mGhostMove.SetLocation( Location );
			mGhostMove.SetRotation( empty );
			mGhostMoveTimer = 0.0f;
		}
	}
}

// restore rotation the creature had at the beginning of its turn (necessary for Strike and Return)
function RestoreRotation()
{
	mRestoreRotationAtEndTurn = false;
	if( IsDead() ) return;
	mMoveControl.RotateStack( mBeginTurnRotation );
}

function DestroyGhost()
{
	if( mGhost != none )
	{
		mGhost.Destroy();
		mGhost = none;
	}
	if( mGhostMove != none )
	{
		mGhostMove.Destroy();
		mGhostMove = none;
	}
}

function StartFadeIn()
{
	local MaterialInstanceConstant dasNewMaterial;
	local int i;
	local float opacity;
	local LinearColor white, originalCol;

	mFadeInDone = false;
	mFadeInOpacityDone = false;
	mFadeInWhiteDone = false;
	mCreature.SetFadeInAnimDone( false );
	mFadeInOpacities.Length = 0;
	mFadeInDiffuses.Length = 0;
	mFadeInEmissives.Length = 0;
	mFadeInMICs.Length = 0;
	
	white.A = 1.0f;
	white.R = 51.0f;
	white.G = 51.0f;
	white.B = 51.0f;
	for( i = 0; i < mCreature.SkeletalMeshComponent.SkeletalMesh.Materials.Length; ++i )
	{
		mCreature.SkeletalMeshComponent.SkeletalMesh.Materials[i].GetScalarParameterValue( 'Opacity_Global', opacity );
		mFadeInOpacities.AddItem( opacity );
		mCreature.SkeletalMeshComponent.SkeletalMesh.Materials[i].GetVectorParameterValue( 'DiffColor_Global', originalCol );
		mFadeInDiffuses.AddItem( originalCol );
		mCreature.SkeletalMeshComponent.SkeletalMesh.Materials[i].GetVectorParameterValue( 'EmissiveColor_Global', originalCol );
		mFadeInEmissives.AddItem( originalCol );
		
		dasNewMaterial = mCreature.SkeletalMeshComponent.CreateAndSetMaterialInstanceConstant( i );	
		mFadeInMICs.AddItem( dasNewMaterial );
		dasNewMaterial.SetScalarParameterValue( 'Opacity_Global', 0.0f );
		dasNewMaterial.SetVectorParameterValue( 'DiffColor_Global', white );
		dasNewMaterial.SetVectorParameterValue( 'EmissiveColor_Global', white );
	}
}

function LerpFadeIn( float deltaTime )
{
	local int i;
	local float opacity;
	local LinearColor temp;

	if( !mFadeInDone )
	{
		if( !mCreature.GetAnimControl().IsInState( 'DoingVictory' ) && !mCreature.mFadeInAnimDone )
		{
			mCreature.GetAnimControl().PlayAnim( CAN_VICTORY );
		}
		mFadeInTimerWhite += deltaTime * 0.025f;
		mFadeInTimerOpacity += deltaTime * 0.030f;

		if( mFadeInTimerOpacity >= 0.1f && !mFadeInOpacityDone ) 
		{
			for( i = 0; i < mFadeInMICs.Length; ++i )
			{
				mFadeInMICs[i].SetScalarParameterValue( 'Opacity_Global', mFadeInOpacities[i] );
			}
			mFadeInTimerOpacity = 0.0f;
			mFadeInOpacityDone = true;
		}

		if( mFadeInTimerWhite >= 0.1f && !mFadeInWhiteDone ) 
		{
			for( i = 0; i < mFadeInMICs.Length; ++i )
			{
				temp = mFadeInDiffuses[i];
				mFadeInMICs[i].SetVectorParameterValue( 'DiffColor_Global', temp );
				temp = mFadeInEmissives[i];
				mFadeInMICs[i].SetVectorParameterValue( 'EmissiveColor_Global', temp );
			}
			mFadeInTimerWhite = 0.0f;
			mFadeInWhiteDone = true;
		}

		if( mFadeInTimerWhite >= 0.1f && mFadeInTimerOpacity >= 0.1f )
		{
			mFadeInDone = true;
			return;
		}

		for( i = 0; i < mFadeInMICs.Length; ++i )
		{
			if( mFadeInTimerOpacity < 0.1f ) 
			{
				mFadeInMICs[i].GetScalarParameterValue( 'Opacity_Global', opacity );
				mFadeInMICs[i].SetScalarParameterValue( 'Opacity_Global', Lerp( opacity, mFadeInOpacities[i], mFadeInTimerOpacity ) );
			}

			if( mFadeInTimerWhite < 0.1f )
			{
				mFadeInMICs[i].GetVectorParameterValue( 'DiffColor_Global', temp );
				temp.A = Lerp( temp.A, mFadeInDiffuses[i].A, mFadeInTimerWhite );
				temp.R = Lerp( temp.R, mFadeInDiffuses[i].R, mFadeInTimerWhite );
				temp.G = Lerp( temp.G, mFadeInDiffuses[i].G, mFadeInTimerWhite );
				temp.B = Lerp( temp.B, mFadeInDiffuses[i].B, mFadeInTimerWhite );
				mFadeInMICs[i].SetVectorParameterValue( 'DiffColor_Global', temp );

				mFadeInMICs[i].GetVectorParameterValue( 'EmissiveColor_Global', temp );
				temp.A = Lerp( temp.A, mFadeInEmissives[i].A, mFadeInTimerWhite );
				temp.R = Lerp( temp.R, mFadeInEmissives[i].R, mFadeInTimerWhite );
				temp.G = Lerp( temp.G, mFadeInEmissives[i].G, mFadeInTimerWhite );
				temp.B = Lerp( temp.B, mFadeInEmissives[i].B, mFadeInTimerWhite );
				mFadeInMICs[i].SetVectorParameterValue( 'EmissiveColor_Global', temp );
			}
		}
	}
}


// retaliation functions
// ========================
function bool CanRetaliate() { return false; return !IsDead() && !GetBuffManager().HasBuff( mRetaliatedBuff, none, false ); }
function bool CouldRetaliate() { return mCreature.GetRetaliationCharges() > 0; } // unmodified base retaliaton charges

// unit interface overrides
// ========================
native function EUnitType		GetEntityType();
function string					GetName()						{ return GetCreature().GetName(); }
function int					GetTopCreatureHealth()			{ return mTopCreatureHealth; }
function int        			GetHitPoints()				    { return GetModifiedStatByID( STAT_HEALTH ); }
function int					GetBaseCreatureHealth()			{ return GetCreature().GetHitPointsBase(); }
function bool					CanFly()						{ return mMovementType == CMOVEMENT_FLY; }
function bool					CanTeleport()					{ return mMovementType == CMOVEMENT_TELEPORT; }
function bool                   CanGhostWalk()                  { return mMovementType == CMOVEMENT_GHOSTWALK; }
native function ECellSize		GetUnitBaseSize();
function bool                   CanJump()                       { return mMovementType == CMOVEMENT_JUMP; }
function int					GetUnitBaseSizeInt()		    { return mCreature.GetBaseSize()+1; }
function EAttackType			GetAttackType()					{ return mCreature.GetAttackType(); }
function EAttackRange			GetAttackRange()				
{
	local int range;

	range = int( GetModifiedStatByID(STAT_RANGE) );
	range = Clamp( range, 0, 2 );
	return EAttackRange( range );
}
function int					CountDeadCreatures()			{ return GetInitialStackSize() - GetStackSize(); }
function float					GetMinimumDamage()				{ return GetModifiedStatByID(STAT_MIN_DAMAGE); }
function float					GetMaximumDamage()				{ return GetModifiedStatByID(STAT_MAX_DAMAGE); }


// methods ...
// ===========
function Init( optional bool fromSave )
{
	local vector colliderOffset;

	super.Init( fromSave );

	
	if( GetBaseCreatureStack().GetStackType() == none )
	{
		ScriptTrace();
		;
		Destroy();
		return;
	}

	mCombatCtrl = class'H7CombatController'.static.GetInstance();
	mCombatGridController = class'H7CombatMapGridController'.static.GetInstance();
	
	mPathfinder = new () class'H7CombatMapPathfinder';
	mPathfinder.InitPathfinderForStack( self );

	mCoverManager = new () class'H7UnitCoverManager';
	mCoverManager.Init( self );

	// set current stack size to inital value
	mStackSize = mInitialStackSize;
	mKilled = false;
	// get archetype object according the creature type and spawn it into world
	if( GetBaseCreatureStack().GetStackType() != none )
	{
		mCreature = Spawn(class'H7Creature', Self , , , Rotation , GetBaseCreatureStack().GetStackType() );

		SpawnCreature( GetBaseCreatureStack().GetStackType() );

		mOverrideAutoCollider = mCreature.IsAutoColliderOverridden();
		if(mOverrideAutoCollider) // Override with custom values
		{
			mColliderHeight = mCreature.GetColliderHeight();
			mColliderRadius = mCreature.GetColliderRadius();
		}
		else // Auto-Generate sizes
		{
			mColliderRadius = mCreature.GetBaseSize() == CELLSIZE_2x2 ? 100.f : 50.f;
			mColliderHeight = mCreature.GetHeight() * 0.45f;
		}

		colliderOffset.X = 0.0f;
		colliderOffset.Y = 0.0f;
		colliderOffset.Z = mCollider.Translation.Z + (mColliderHeight);
		mCollider.SetTranslation(colliderOffset);
		
		mCollider.SetCylinderSize( mColliderRadius, mColliderHeight);
	}

	// by default all stacks can be revived
	mCanBeRevived = true;

	if( mCreature == None )
	{
		;
		Destroy();
		return;
	}

	if( mArmy != None ) 
	{
		mCreature.SetTeamColor( GetCombatArmy().IsAttacker() ? 0 : 1 );
	}

	mTopCreatureHealth  = GetHitpoints();
	mAmmo               = mCreature.GetAmmo();
	//mName               = mCreature.GetName();
	mMinimumDamage      = mCreature.GetMinimumDamage();
	mMaximumDamage      = mCreature.GetMaximumDamage();
	mDefense            = mCreature.GetDefense();
	mAttack             = mCreature.GetAttack();
	mDestiny            = mCreature.GetDestiny();
	mLeadership         = mCreature.GetLeadership();
	mMovementPoints     = mCreature.GetMovementPoints();
	mInitiative         = mCreature.GetInitiative();	// just use the unmodified creature initiative value for now
	mSchoolType         = mCreature.GetSchool();
	mMovementType       = mCreature.GetMovementType();
	mFaction            = GetCreature().GetFaction();
	mWaitAbility        = mCreature.GetWaitAbility();
	mMeleeAttackAbilityTemplate = mCreature.GetMeleeAttackAbility();
	mRangedAttackAbilityTemplate = mCreature.GetRangedAttackAbility();
	mRange              = mCreature.GetAttackRange();
	 
	

	mAbilityManager.Init( self, mCreature.GetAbilities() );
	
	if( GetRangedAttackAbility() != none ) 			{ mAbilityManager.LearnAbility( GetRangedAttackAbility() );			}
	if( GetMeleeAttackAbility() != none ) 			{ mAbilityManager.LearnAbility( GetMeleeAttackAbility() );			}
	if( GetWaitAbility() != none )      			{ mAbilityManager.LearnAbility( GetWaitAbility() );					}
	if( GetDefendAbility() != none )    			{ mAbilityManager.LearnAbility( GetDefendAbility() );				}
	if( GetLuckAbility() != none )      			{ mAbilityManager.LearnAbility( GetLuckAbility() );					}
	if( GetMoralAbility() != none )     			{ mAbilityManager.LearnAbility( GetMoralAbility() );				}
	if( GetRetaliationAbility() != none )			{ mAbilityManager.LearnAbility( GetRetaliationAbility() );			}
	if( GetRetaliationOverrideMelee() != none )	    { mAbilityManager.LearnAbility( GetRetaliationOverrideMelee() );	}
	if( GetRetaliationOverrideRanged() != none )	{ mAbilityManager.LearnAbility( GetRetaliationOverrideRanged() );	}


	mRetaliatedBuff = GetRetaliatedBuff();
	mDoStatusCheck = true;

	SetTimer( 2.f, false, NameOf( CreateGUIOverlay) );

	class'H7ReplicationInfo'.static.PrintLogMessage("Creature stack created" @ GetName() @ self, 0);;
}

function SpawnCreature( H7Creature template )
{
	local int i;
	local SkeletalMeshActorSpawnable platoonCreature;

	if( mCreature == none )
	{
		;
		return;
	}

	mCreature.CreateCreature( template );
	mCreature.SetOwner( self );
	InitStackFX();
	
	mCreature.GetSkeletalMesh().SetOutlineColor( GetCombatArmy().GetPlayer().GetColor() );
	mCreature.PostInitAnimTree( mCreature.GetSkeletalMesh() );
	mMoveControl = Spawn( class'H7CreatureStackMovementControl', self );
	mMoveControl.Initialize( self );
	
	if (class'H7CombatController'.static.GetInstance().GetCombatConfiguration().IsUsingPlatoonStacks())
	{
		GetCreature().SetDrawScale(0.425f);
		for (i = 0; i < 8; ++i)
		{
			platoonCreature = Spawn(class'SkeletalMeshActorSpawnable', Self, , GetCreature().Location, GetCreature().Rotation, , true);
			DrawDebugSphere(platoonCreature.Location, 50, 4, 255,255,0, true);
			platoonCreature.SetPhysics(PHYS_Interpolating);
			platoonCreature.SetDrawScale(GetCreature().DrawScale);
			platoonCreature.SetDrawScale3D(GetCreature().DrawScale3D);
			platoonCreature.SkeletalMeshComponent.SetSkeletalMesh(GetCreature().GetSkeletalMesh().SkeletalMesh);
			platoonCreature.SkeletalMeshComponent.AnimSets.AddItem(GetCreature().GetSkeletalMesh().AnimSets[0]);
			platoonCreature.SkeletalMeshComponent.SetAnimTreeTemplate(GetCreature().GetSkeletalMesh().AnimTreeTemplate);
			platoonCreature.SkeletalMeshComponent.SetScale(GetCreature().GetSkeletalMesh().Scale);
			platoonCreature.SkeletalMeshComponent.SetScale3D(GetCreature().GetSkeletalMesh().Scale3D);
			//platoonCreature.SkeletalMeshComponent.SetParentAnimComponent(GetCreature().GetSkeletalMesh());

			platoonCreature.bBlockActors = false;
			//platoonCreature.SetHardAttach(true);
			//platoonCreature.bIgnoreBaseRotation = true;
			//platoonCreature.SetBase(GetCreature());
			//platoonCreature.SetHardAttach(true);
			//platoonCreature.bIgnoreBaseRotation = true;
			platoonCreature.SkeletalMeshComponent.SetOutlineColor( GetCombatArmy().GetPlayer().GetColor() );

			mPlatoonCreatures.AddItem(platoonCreature);
		}
	}
}

function ApplyHeroArmyBonusBuff()
{
	local H7BuffHeroArmyBonus heroArmyBonusBuff;

	heroArmyBonusBuff = new class'H7BuffHeroArmyBonus';
	heroArmyBonusBuff.Init(self, GetCombatArmy().GetCombatHero(), false);

	mBuffManager.AddBuff( heroArmyBonusBuff , GetCombatArmy().GetCombatHero() );
}

function SetTopCreatureHealth( int value )
{
	mTopCreatureHealth = value;
}

function CreateGUIOverlay()
{
	class'H7CombatMapStatusBarController'.static.GetInstance().CreateHealthBar( self, 100 );
	class'H7CreatureStackPlateController'.static.GetInstance().CreatePlate( self );
}

function UseAmmo()
{
	if( UsesAmmo() )
	{
		--mAmmo;
		if( mAmmo < 0 )
		{
			;
			mAmmo = 0;
		}
	}
}

// the function is called to end the last turn for this stack and start with the new
function bool BeginTurn()
{
	GetCreature().GetAnimControl().BeginTurn();
	mHasMovedThisTurn = false;
	mBeginTurnRotation = mCreature.Rotation;
	super.BeginTurn();

	ResetLuckType();

	return true;
}

function StartDelayedCommand()
{
	if( IsDead() ) { mDelayedCommand = none; return; }

	if( mDelayedCommand.GetCommand() == UC_MOVE ) GetCell().SetAbilityHighlight( false );
	class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().Enqueue( mDelayedCommand );
	mDelayedCommand = none;
}

function EndTurn()
{
	super.EndTurn();
	ResetLuckType();
}

function Defend()
{	
	local array<H7Command> commands;

	commands = class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().GetCmdsForCaster( self );
	if( !GetPreparedAbility().IsEqual( GetDefendAbility() ) && commands.Length == 0 )
	{
		PrepareAbility( mAbilityManager.GetAbility( GetDefendAbility() ) );
		class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( self );
	}
}

function bool CanDefend()
{
	return GetAbilityManager().GetAbility(GetDefendAbility()).CanCast();
}

function H7BaseAbility GetSkipTurnAbility()
{
	local H7CreatureAbility ability;
	local array<H7CreatureAbility> creatureAbilities;
	
	creatureAbilities = GetCreature().GetAbilities();
	foreach creatureAbilities(ability)
	{
		if(ability.GetArchetypeID() == "A_MobileShooter_Skip_Ability")
		{
			return GetAbilityManager().GetAbility(ability);
		}
	}

	return none;
}

function CreateDecay( )
{
	if( mCreature.GetVisuals().GetHideCorpseAfterDeath() )
	{
		if (mCreature.GetVisuals().GetHideCorpseAfterDeathTime() > 0.0f)
		{
			SetTimer( mCreature.GetVisuals().GetHideCorpseAfterDeathTime(), false, 'Hide');
		}
		else
		{
			Hide();
		}
	}
	ShowCreatureRemains();
}

event Tick( float deltaTime )
{
	local Rotator outRot;

	super.Tick( deltaTime );

	LerpGhostMove( deltaTime );
	LerpFadeIn( deltaTime );

	// fly out of map for doing Diving Attack
	if(mIsDiving)
	{
		HideSlotFX(GetCell());
		mDivingAttackTimer += deltaTime * mDivingAttackMovementSpeed;

		// target height reached? great, don't ascend any further
		if( !mDoDivingParabola && ( mDivingAttackTargetHeight.Z > mDivingAttackStartHeight.Z && mDivingAttackCurrentHeight.Z >= mDivingAttackTargetHeight.Z
			|| mDivingAttackTargetHeight.Z < mDivingAttackStartHeight.Z && mDivingAttackCurrentHeight.Z <= mDivingAttackTargetHeight.Z ) ||
			mDoDivingParabola && mParabolaReachedZero && ( Abs( Abs( mDivingAttackCurrentHeight.Z ) - Abs( mDivingAttackStartHeight.Z ) ) <= 100.f ) )
		{
			mIsDiving = false;
			OnDivingAttackFlyingFinished();
			mDivingAttackTimer = 0.0f;
			return;
		}
		else
		{
			if(mDoDivingParabola)
			{
				// move along x^4 parabola while adjust the rotation of the dude (much fun. so code.)
				mDivingAttackCurrentHeight = ParabolaLerp( mDivingAttackStartHeight, mDivingAttackTimer, outRot );
				GetCreature().SetRotation( outRot );
			}
			else
			{
				// normal ascension/descension
				mDivingAttackCurrentHeight = VLerp( mDivingAttackStartHeight, mDivingAttackTargetHeight, mDivingAttackTimer );
				outRot = GetCreature().Rotation;
				outRot.Pitch = 0.f;
				outRot = RLerp( mStartRotation, outRot, (mDivingAttackStartHeight.Z - mDivingAttackCurrentHeight.Z + 0.1f)/mDivingAttackStartHeight.Z);
				GetCreature().SetRotation( outRot );

				if( mDivingAttackCurrentHeight.Z <= ( GetCreature().GetHeight() * 1.5f + mDivingAttackTargetHeight.Z )
					&& GetCreature().GetAnimControl().IsInState('LoopFlying')
					&& mDivingAttackStartHeight.Z > mDivingAttackTargetHeight.Z)
				{
					mDivingAttackMovementSpeed = 0.3f; // TODO editor variable
					GetCreature().GetAnimControl().PlayAnim( CAN_FLY_IN );
				}
			}
		}
		GetCreature().SetLocation(mDivingAttackCurrentHeight);
	}


	if( mCreature != none )
	{
		UpdateSlotFX( mCreature.IsHovering() );
	}
	
	//	Disable highlight effect when an action is executed
	if( mCreature != none && mCreature.IsHovering() && !class'H7PlayerController'.static.GetPlayerController().IsUnrealAllowsInput() )
	{
		DehighlightStack();
	}
}

function Vector ParabolaLerp( Vector start, float currentTime, out Rotator currRot )
{
	local Vector now;
	local float x, height, angle;

	x = ( start.Y + ( currentTime * mDivingAttackMovementSpeed ) ) * 20.f; // TODO make second editor thingy
	height = ( start.Y + ( currentTime * mDivingAttackMovementSpeed ) ) ** 2.f;

	if( ( Abs( 2.f * ( start.Y + ( currentTime * mDivingAttackMovementSpeed ) ) -  mDivingAttackCurrentHeight.Z ) <= 5.f )
		&& !mParabolaReachedZero )
	{
		OnDivingAttackParabolaHit();

		mParabolaReachedZero = true;
	}

	angle = mDivingAttackCurrentHeight.Z != 0.f ? mDivingAttackCurrentHeight.Z / mDivingAttackStartHeight.Z : 0.f; // 1 -> 0 -> 1
	if( mParabolaReachedZero ) angle = -angle;
	currRot = GetCreature().Rotation;
	currRot.Pitch = mStartRotation.Pitch * ( angle * 1.5f );

	// ---- uncomment for impressive loopings ----
	//currRot.Pitch = Lerp( mStartRotation.Pitch, mTargetRotation.Pitch, currentTime );

	now.Y = x;
	now.Z = height;
	now.X = mDivingAttackStartHeight.X;

	return now;
}

function DoDivingAttackFlying( int targetHeight, int fwd, float speed, bool doParabola, bool exAscendDone, bool exDoneEverything, H7Effect sourceEffect )
{
	mEffect = sourceEffect;
	mDivingAttackTimer = 0.0f;
	mDivingAttackStartHeight = GetCreature().GetLocation();
	mDivingAttackCurrentHeight = GetCreature().GetLocation();

	// target position vector
	mDivingAttackTargetHeight.Z = targetHeight;
	mDivingAttackTargetHeight.Y = fwd;
	mDivingAttackTargetHeight.X = mDivingAttackStartHeight.X;

	// diving attack parabola stuff
	mDoDivingParabola = doParabola;
	mParabolaReachedZero = false;

	mDivingAttackMovementSpeed = speed;
	if( exAscendDone )
		OnDivingAttackFlyingFinished = AscendDone;
	else if( exDoneEverything )
		OnDivingAttackFlyingFinished = DoneEverything;
	mStartRotation = GetCreature().Rotation;
	mTargetRotation = GetCreature().Rotation;
	mTargetRotation.Pitch = mTargetRotation.Pitch + 65536;
	mIsDiving = true;
}

function ExecuteDivingAttackReappear( H7Effect effect, H7EventContainerStruct container, float speed, float descendSpeed, int descendFrom, int flyForward )
{
	local array<H7CombatMapCell> targetArea;
	local H7CombatMapCell cell;
	local bool ownerIsBack;

	if( !IsOffGrid() ) 
	{
		return; 
	}

	targetArea = GetDivingAttackArea();
	if(targetArea.Length == 0) { return; }
	mContainer = container;

	mHitUnits.Length = 0;

	foreach targetArea(cell)
	{
		if(cell.HasUnit())
		{
			mHitUnits.AddItem(cell.GetUnit());
		}
	}

	mDivingAttackMovementSpeed = speed;
	mDivingAttackMovementSpeedDescend = descendSpeed;
	mDescendFrom = descendFrom;
	mFlyForwardUnits = flyForward;

	Show(false);

	if(mHitUnits.Length == 0 && !mDescend)
	{
		PlaceOwnerOnCell(targetArea[0], false);
	}
	else
	{
		effect.GetSource().SetTargets(mHitUnits);
		ownerIsBack = false;
		while(!ownerIsBack)
		{
			targetArea = class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().GetGridController().GetCombatGrid().GetNeighbourCells(targetArea);
			foreach targetArea(cell)
			{
				if(cell.CanPlaceCreatureStack(self))
				{
					PlaceOwnerOnCell(cell, !mDescend);
					ownerIsBack = true;
					break;
				}
			}
		}
	}
}

function PlaceOwnerOnCell(H7CombatMapCell cell, bool hasTargets)
{
	local array<H7CombatMapCell> empty;
	local Vector cellPos, origCellPos;
	local float zPos, towards;
	local IntPoint dimensions;
	local Vector backwards;
	local Rotator rota;

	mHasTargets = hasTargets;
	empty.Length = 0;
	if(!mHasTargets)
		SetDivingAttackArea(empty);

	mTargetCell = cell;
	dimensions.X = GetCreature().GetBaseSize() == CELLSIZE_2x2 ? 2 : 1;
	dimensions.Y = dimensions.X;

	if(mHasTargets)
	{
		empty = GetDivingAttackArea();
		origCellPos = empty[0].GetCenterPosByDimensions( dimensions );
	}
	else
		origCellPos = mTargetCell.GetCenterPosByDimensions( dimensions );

	cellPos = origCellPos;

	if(mDescend)
	{
		backwards = GetCreature().Location;
		backwards.Z = mDescendFrom;
		GetCreature().SetLocation( backwards );
	}
	
	backwards = Vector( GetCreature().Rotation ) * mFlyForwardUnits;
	if(mHasTargets)
	{
		// parabola starting point

		backwards.Y = GetCreature().GetLocation().Z ** 0.5f;
	}

	towards = cellPos.Y;
	zPos = cellPos.Z;
	cellPos.Z = GetCreature().GetLocation().Z;
	cellPos.Y = -backwards.Y;
	GetCreature().SetLocation(cellPos);

	rota = Rotator(origCellPos - cellPos);
	if(!mHasTargets)
	{
		GetCreature().GetAnimControl().PlayAnim(CAN_LOOP_FLY);
	}
	else
	{
		GetCreature().GetAnimControl().PlayAnim(CAN_DIVING_LOOP);
	}

	GetCreature().SetRotation( rota );

	if(mDescend || !mHasTargets)
	{
		DoDivingAttackFlying( zPos, towards, mDivingAttackMovementSpeedDescend, false, false, true, mEffect );
	}
	else
	{
		DoDivingAttackFlying( zPos, towards, mDivingAttackMovementSpeed, mHasTargets, false, true, mEffect );
	}
}

function OnDivingAttackParabolaHit()
{
	local H7EventContainerStruct conti;

	conti.Targetable = mHitUnits[0];
	conti.TargetableTargets = mHitUnits;
	conti.EffectContainer = mEffect.GetSource();
	conti.ActionTag = H7BaseBuff( mEffect.GetSource() ).GetTags();
	conti.ActionSchool = mEffect.GetSource().GetSchool();

	TriggerEvents( ON_JUMP_PITCH, false, conti );
}

function DoneEverything()
{
	local Rotator rota;
	local Vector trg;
	local IntPoint pos;
	local array<H7CombatMapCell> empty;
	
	if( mHasTargets )
	{
		mHasTargets = false;
		mDescend = true;

		// look at target
		pos.X = GetCreature().GetBaseSize() == CELLSIZE_2x2 ? 2 : 1;
		pos.Y = pos.X;

		trg = mTargetCell.GetCenterPosByDimensions( pos );
		trg.Y = GetCreature().Location.Y;
		trg.Z = GetCreature().Location.Z;
		rota = Rotator(GetCreature().Location - trg);
		GetCreature().SetRotation(rota);

		ExecuteDivingAttackReappear( mEffect, mContainer, mDivingAttackMovementSpeed, mDivingAttackMovementSpeedDescend, mDescendFrom, mFlyForwardUnits );
	}
	else
	{
		empty.Length = 0;
		SetDivingAttackArea( empty );

		class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().GetGridController().PlaceCreature( mTargetCell.GetGridPosition(), self );
		GetCreature().GetAnimControl().PlayAnim( CAN_IDLE );

		mIsDiving = false;
		mDoDivingParabola = false;
		mDescend = false;

		MakeTurn();
	}
}

function AscendDone()
{
	// play idle anim to signalize that this unit's turn is done
	// (else the game gets stuck when gameplay waits for animations to finish)
	GetCreature().GetAnimControl().PlayAnim(CAN_IDLE);
	Hide(false);
}

function Hide( optional bool removeFromCell = true )
{
	local SkeletalMeshActorSpawnable platoonMesh;

	if( removeFromCell )
	{
		RemoveCreatureFromCell();
	}
	mIsVisible = false; 
	mCreature.HideMeshes();

	SetHidden(true);
	mCreature.SetHidden(true);
	foreach mPlatoonCreatures(platoonMesh)
	{
		platoonMesh.SetHidden(true);
	}
	SetCollisionType( COLLIDE_NoCollision );
	mCreature.SetCollisionType( COLLIDE_NoCollision );
}

function Show( optional bool addToCell = true )
{	
	local SkeletalMeshActorSpawnable platoonMesh;

	if( addToCell )
	{
		mCombatGridController.PlaceCreature( GetGridPosition(), self );
	}
	mIsVisible = true;
	SetHidden(false);
	mCreature.SetHidden(false);
	foreach mPlatoonCreatures(platoonMesh)
	{
		platoonMesh.SetHidden(false);
	}
	mCreature.ShowMeshes();
	SetCollisionType( COLLIDE_BlockAll );
	mCreature.SetCollisionType( COLLIDE_BlockAll );
}


/**
 *  Checks if on a cell as some buried creatures
 *  @value (true) when leaving cell
 **/
function ShowCemetary( optional bool value )
{
	local H7CombatMapCell currentUnitcell,deadUnitCell,cell;
	local array<H7CombatMapCell> mergedCellsCurrentUnit,mergedCellsDeadUnit;

	// get the cells for current unit
	currentUnitcell = GetCell();
	currentUnitcell.GetCellsHitByCellSize( GetUnitBaseSize(), mergedCellsCurrentUnit );

	// get the cells and check if they contain a dead body
	foreach mergedCellsCurrentUnit( cell ) 
	{
		// get the merged cells for a dead unit
		mergedCellsDeadUnit = cell.GetMergedCells2ndLayer();
		foreach mergedCellsDeadUnit( deadUnitCell )
		{
			// check if any cells of a dead unit are occupied, or if show_value true check if its another stack
			if( deadUnitCell.HasDeadCreatureStack() && ( deadUnitCell.HasCreatureStack() && ( value && deadUnitCell.GetCreatureStack() != self ) || ( !value && deadUnitCell.GetDeadCreatureStack() != self ) ) ) 
			{
				// hide remains if there is a living creature on the cell
				deadUnitCell.GetMaster2ndLayer().HideRemains( true );
				deadUnitCell.GetDeadCreatureStack().Hide( false );
				break;
			}
			else if( value && ( !deadUnitCell.HasCreatureStack() ||  deadUnitCell.GetCreatureStack() == self  ) )
			{
				// show remains if there is no living creature on the cell
				deadUnitCell.GetMaster2ndLayer().HideRemains( false );
				if( !deadUnitCell.GetDeadCreatureStack().GetCreature().GetVisuals().GetHideCorpseAfterDeath() )
				{
					deadUnitCell.GetDeadCreatureStack().Show( false );
				}
			}
		}
	}
}



// called every frame for every stack on the map, but has internal check, only runs when mDoStatusCheck was set to true in this frame
function UpdateSlotFX( bool isHovering )
{
	local H7Unit activeUnit;
	local H7CombatMapCell myCell;
	
	if( mDoStatusCheck )
	{
		if( !mCombatCtrl.IsInTacticsPhase() )
		{
			;
			activeUnit = mCombatCtrl.GetActiveUnit();
			myCell = mCombatGridController.GetCombatGrid().GetCellByIntPoint( GetGridPosition() );

			if( /*mCombatCtrl.GetCommandQueue().IsCommandRunning()*/ !mCombatCtrl.AllAnimationsDone() || !MPIsYourTurn() || mCombatCtrl.IsEndOfCombat()
				|| class'H7CombatPlayerController'.static.GetCombatPlayerController().IsInCinematicView() || mCombatCtrl.GetActiveUnit().GetPlayer().GetPlayerType() == PLAYER_AI )
			{
				HideSlotFX( myCell );	//	We are busy and don't want our slots to be highlighted
			}
			else if( activeUnit.HasPreparedAbility() )
			{
				//Only friendly creatures can be teleported - check if I am friendly and someone wants to teleport me
				if( activeUnit.GetPreparedAbility().IsTeleportSpell() && 
					class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() == INDEX_NONE &&
					class'H7Effect'.static.GetAlignmentType( activeUnit, self ) == AT_FRIENDLY || 
					class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() == GetID() )
				{
					ShowSlotFXAlly( GetCell(), true );
				}
				else
				{
					UpdateAbilitySlotFX( myCell, activeUnit.GetPreparedAbility(), isHovering );	//	The active unit could cast a spell on me
				}

				if( activeUnit == self )
				{
					ShowSlotFXActive( myCell );
				}
			}
			else if( activeUnit == self )
			{
				ShowSlotFXActive( myCell );	// I am the active unit and don't have a prepared ability
			}
			else
			{
				HideSlotFX( myCell );	//	The active unit cannot touch me. Better luck next time, active unit!
			}
		}
		mDoStatusCheck = false; // I am done, until somebody tells me to recheck
		mCombatGridController.SetDecalDirty( true );
	}
}

protected function UpdateAbilitySlotFX(H7CombatMapCell myCell, H7BaseAbility preparedAbility, bool isHovering )
{
	local array<H7CombatMapCell> validPositions, dummyArray;
	local H7ICaster caster;

	dummyArray.Length = 0;

	caster = preparedAbility.GetCaster().GetOriginal();

	
	if( preparedAbility.GetCaster().GetOriginal().IsA( 'H7CreatureStack' ) )
	{
		if( myCell.GetForceEnemyHightlight() ) 
		{
			ShowSlotFXEnemy( myCell, isHovering );
			return;
		}

		if( !H7Unit(caster).CanAttack() )
		{
			HideSlotFX( myCell );
			return;
		}
		if( !preparedAbility.IsRanged() )
		{
			mCombatGridController.GetCombatGrid().GetAllAttackPositionsAgainst( self, H7CreatureStack( caster ), validPositions );
			if( validPositions.Length == 0 )
			{
				HideSlotFX( myCell );
				return;
			}
		}
		else if( mCombatGridController.GetCombatGrid().HasAdjacentCreature( H7CreatureStack( caster ), none, true, dummyArray ) || preparedAbility.IsHeal() )
		{
			HideSlotFX( myCell );
			return;
		}
	}

	if( preparedAbility.CanCastOnTargetActor( self ) )
	{
		if( ( ( myCell.GetCreatureStack().GetCombatArmy() == mCombatCtrl.GetActiveArmy()  ) 
			|| (myCell.HasDeadCreatureStack() && myCell.GetDeadCreatureStack().GetCombatArmy() == mCombatCtrl.GetActiveArmy() &&  myCell.GetCreatureStack() == none && !myCell.SlaveHasCreatureStack()  ) ) 
			&& preparedAbility.CanAffectAlly() ) 
		{
			if( IsDead() && !GetCell().HasCreatureStackOnDeadStack() && !GetCell().SlaveHasCreatureStack() )
			{
				ShowSlotFXDeadAlly( myCell, true );
			}
			else
			{
				ShowSlotFXAlly( myCell, isHovering );
			}	
		}
		else
		{
			if(!IsDead())
			{
				ShowSlotFXEnemy( myCell, isHovering );
			}
		}
	}
	else
	{
		if( mCombatCtrl.GetActiveUnit() == self )
		{
			ShowSlotFXActive( myCell );
		}
		else if( mCanBeRevived && (!IsDead() && GetCell().HasCreatureStackOnDeadStack()) )
		{
			HideSlotFX( myCell );
		}
		else if( !GetCell().HasCreatureStackOnDeadStack() )
		{
			HideSlotFX( myCell );
		}
	}
}

function TurnChanged()
{
	StatusChanged(); // next frame expensive calculations and checks are redone
}

function ShowStackFXEnemy()
{
	mStackFX.ShowFX();
	mStackFX.UpdateTargetColor( mStackFX.GetProperties().EnemyTargetColor );
}

function ShowStackFXAlly()
{
	mStackFX.ShowFX();
	mStackFX.UpdateTargetColor( mStackFX.GetProperties().AllyTargetColor );
}

function ShowStackFXActive()
{
	mStackFX.ShowFX();
	mStackFX.UpdateTargetColor( mStackFX.GetProperties().ActiveTargetColor );
}

function HideStackFX()
{
	mStackFX.DestroyFX();
}

protected function ShowSlotFXActive( H7CombatMapCell myCell )
{
	mStackFX.UpdateTargetColor( mStackFX.GetProperties().ActiveTargetColor );

	if( myCell != None )
	{
		myCell.SetSelectedMerged( true );
	}
}

protected function ShowSlotFXEnemy( H7CombatMapCell myCell, bool isHovering )
{
	if( isHovering )
	{
		ShowStackFXEnemy();
	}
	else
	{
		mStackFX.HideFX();
	}

	if( myCell != None )
	{
		myCell.SetSelectedMergedEnemy( true );
	}
}



protected function ShowSlotFXAlly( H7CombatMapCell myCell, bool isHovering )
{
	if( isHovering )
	{
		ShowStackFXAlly();
	}
	else if( self == mCombatCtrl.GetActiveUnit() )
	{
		ShowStackFXActive();
	}
	else
	{
		mStackFX.HideFX();
	}

	if( myCell != None )
	{
		if( mCombatCtrl.GetActiveUnit() == self )
		{
			myCell.SetSelectedMerged( true );
		}
		else
		{
			myCell.SetSelectedMergedAlly( true );
		}
	}
}

protected function ShowSlotFXDeadAlly( H7CombatMapCell myCell, bool isHovering )
{
	if( isHovering )
	{
		ShowStackFXAlly();
	}
	else
	{
		mStackFX.HideFX();
	}

	if( myCell != None )
	{
		myCell.SetSelectedMergedDeadAlly( true );
	}
}

function HideSlotFX( H7CombatMapCell myCell )
{
	HideStackFX();
	if( myCell != none )
	{
		myCell.SetSelectedMerged( false );
		
		// deselect 2nd layer for dead units 
		myCell.SetSelectedMerged( false, SELECTED_DEAD_ALLY );
	}
}

// set position according to Cellposition-Center
function SetStackLocation( Vector pos, optional float heightOffset )
{
	local SkeletalMeshActorSpawnable platoonCreature;
	local int i;
	local IntPoint platoonCenter, platoonSize;
	local array<IntPoint> platoonPos;
	local vector platoonLoc;

	pos.z += heightOffset;

	SetLocation( pos );
	mCreature.SetLocation( pos );

	foreach mPlatoonCreatures(platoonCreature, i)
	{
		platoonCenter.X = 0;
		platoonSize.X = 3;
		platoonSize.Y = 3;
		class'H7Math'.static.GetSpiralIntPointsByDimension(platoonPos, platoonCenter, platoonSize);
		platoonLoc.X = platoonPos[i+1].X * 60.0f * GetCreature().GetStackSize();
		platoonLoc.Y = platoonPos[i+1].Y * 60.0f * GetCreature().GetStackSize();
		platoonCreature.SetLocation(pos + platoonLoc);
		FlushPersistentDebugLines();
	}
}

/**
 * Checks for resurrection problems (other dude stands on corpse etc) go here!
 */
function bool CanBeResurrected()
{
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) return false;

	if( !IsDead() ) return true; // no need to check other stufg

	return class'H7CombatMapGridController'.static.GetInstance().CanPlaceCreature( mGridPos, self );
}

function int Resurrection( int totalHeal, optional bool wasDead, optional bool preCalc, optional H7CombatResult result, optional int resultIdx, optional bool onlyHeal = false )
{
	local int stackResurrection, unitBaseHealth, maxRes;
	local H7CombatMapCell myCell;
	local int healAmount, i, j;
	local array<H7BaseAbility> aurasOnCell;
	local H7EventContainerStruct conti;

	unitBaseHealth = GetHitpoints();
	maxRes = mInitialStackSize - mStackSize; // maximum amount of creatures that can get resurrected
	
	for( j = 0; j < maxRes; j++ )
	{
		if(unitBaseHealth < totalHeal )
		{
			// get the base potential resurrectable amount
			stackResurrection++;
			totalHeal -= unitBaseHealth;
		}
	}
	
	// The real calculation - cap heal amount for top creature
	if(stackResurrection > maxRes) // overheal -> cap
	{
		healAmount = unitBaseHealth; // should be max 
		stackResurrection = maxRes;
	}
	else
	{
		healAmount = totalHeal;
	}

	// adjust the healamount to overcome the top CreatureHp
	if( wasDead )
	{
		healAmount = Min(unitBaseHealth, totalHeal); // starting health is 1
		mKilled = false; // just in case...
	}

	// if there is any heal value left, and we can still resurrect some stack - DO IT
	if( healAmount > 0.0f && (mStackSize + stackResurrection ) < mInitialStackSize)
	{
		stackResurrection++;
		//healAmount -= (unitBaseHealth - mTopCreatureHealth);
	}

	// If all Creatures are resurrected and the top creature is fully healed -> ignore the overheal
	if( ( mStackSize + stackResurrection ) == mInitialStackSize && healAmount > (unitBaseHealth - mTopCreatureHealth) )
	{
		healAmount = unitBaseHealth - mTopCreatureHealth;
	}

	// GUI Tooltip
	if( preCalc ) 
	{
		// change result
		result.SetDamageRange(healAmount, healAmount, resultIdx);
		if( onlyHeal )
		{
			result.SetKillRange(0, 0, resultIdx);
			result.SetKills(0);
			return 0;
		}
		result.SetKillRange(stackResurrection, stackResurrection, resultIdx);
		result.SetKills(stackResurrection);
		
		return stackResurrection; 
	}

	// Reenable collider for tracing
	mCollider.SetActorCollision(true, true, true);
	mCollider.SetTraceBlocking(true, true);

	// heal the creature
	Heal( healAmount );

	// set the values straight
	SetStackSize( mStackSize + stackResurrection );
	class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateStackSize( self );
	class'H7FCTController'.static.GetInstance().startFCT(FCT_RESURRECTION, GetFloatingTextLocation(), GetPlayer(), string(stackResurrection), MakeColor(255,255,255));

	// What is dead may never die 
	if( wasDead )
	{
		//mTopCreatureHealth = 1;

		// remove Dead 
		myCell = mCombatGridController.GetCombatGrid().GetCellByIntPoint( GetGridPosition() );
		myCell.RemoveDeadCreatureStack();
		myCell.DespawnCreatureRemains();

		
		// shows the creaturestack again, set position etc. 
		Show();

		// undo death material FX
		if(mCreature.HasDeathMaterialFX())
		{
			// undo death material FX
			mCreature.PlayDeathEffects( true );
		}
	
		// add again to initiative queue
		// !!! stacksize need to be >0 to be "not dead" so it wont be removed from INI-Q !!!
		mCombatCtrl.GetInitiativeQueue().AddUnit( self );
		mCombatCtrl.GetArmyAttacker().UpdatedAlliesAndEnemies();
		mCombatCtrl.GetArmyDefender().UpdatedAlliesAndEnemies();
		
		// play Idle Anim to go back to normal state 
		GetCreature().GetAnimControl().PlayAnim( CAN_IDLE, );

		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().ResetInitiativeInfo();
	}

	if( wasDead )
	{
		// restore permanent (aka no duration modifier effects) buffs from passive hero abilities
		GetBuffManager().RestoreStoredBuffs();

		// get passive aura buffs
		conti.Targetable = self;
		conti.TargetableTargets.AddItem( self );
		conti.Action = ACTION_ABILITY;

		class'H7CombatMapGridController'.static.GetInstance().GetAuraManager().GetAuraAbilitiesForCell( GetCell(), aurasOnCell );
		for( i = 0; i < aurasOnCell.Length; ++i )
		{
			conti.EffectContainer = aurasOnCell[i];
			aurasOnCell[i].GetEventManager().Raise( ON_APPLY_AURA, false, conti );
		}
	}

	// notify GUI for changes
	DataChanged();

	return stackResurrection;
}

function Heal( int healAmount )
{
	local int effectiveHeal, unitBaseHealth;
	local H7Message message;
	local H7FCTElement fct;

	unitBaseHealth = GetHitpoints();
	
    if(unitBaseHealth - mTopCreatureHealth > healAmount)
	{
		effectiveHeal = healAmount;
	}
	else
	{
		effectiveHeal = unitBaseHealth - mTopCreatureHealth;
	}
	
	mTopCreatureHealth += healAmount;
	if(effectiveHeal != 0)
	{
		fct = class'H7FCTController'.static.GetInstance().startFCT(FCT_HEAL, GetFloatingTextLocation(), GetPlayer(), string(effectiveHeal), MakeColor(0,255,0,255), none);
		if( fct != none )
		{
			fct.SetDoUpperScreenBorderCheck(true);
		}
	}

	if( mTopCreatureHealth > GetHitpoints() )
	{
		mTopCreatureHealth = GetHitpoints();
	}

	message = new class'H7Message';
	message.text = "MSG_TARGET_HEALED";
	message.AddRepl("%target",GetName());
	message.AddRepl("%value",String(effectiveHeal));
	message.destination = MD_LOG;
	message.settings.referenceObject = self;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	DataChanged();
}

function ApplyBuff( H7CombatResult result, int resultIdx, bool isForecast, optional H7UnitSnapShot casterSnapshot )
{
	local H7BaseBuff buff;
    local H7EventContainerStruct eventContainer;
	
	// find the buff to apply
	buff = H7BaseBuff(H7EffectWithSpells(result.GetCurrentEffect()).GetData().mSpellStruct.mSpell);

	;

	if(!isForecast)
	{
		if(buff.IsArchetype())
			buff = new buff.Class(buff);
		buff.Init(result.GetDefender(resultIdx), casterSnapshot /*result.GetAttacker().GetOriginal()*/, false);

		eventContainer.Result = result;
		eventContainer.Targetable = self;
		result.GetCurrentEffect().GetTagsPlusBaseTags( eventContainer.ActionTag );
		eventContainer.EffectContainer = result.GetCurrentEffect().GetSource();

		GetBuffManager().AddBuff(buff,casterSnapshot/*result.GetAttacker().GetOriginal()*/,result.GetCurrentEffect().GetSource());
	}
}

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true  )
{
	local int topCreatureHealth;
	local int stackSize;
	local EAbilitySchool attackSchool;
	local H7Message message;
	local H7EffectContainer container;
	local H7ICaster caster;
	local H7FCTElement fct;
	local bool combatOfLocalPlayer;
	local MPDamageApply mpDamageData;
	
	// Needed for forecast
	local int minStackSize;
	local int maxStackSize;
	local int stackSizeBefore;

	local H7EventContainerStruct eventStruct;

	;

	stackSizeBefore = mStackSize;
     
	TriggerGlobalEventClass( class'SeqEvent_TakeDamage', self, 0 );

	if(isForecast)
	{
		GetDamageResult(result.GetDamageLow(resultIdx), result.DidMiss(resultIdx), topCreatureHealth, minStackSize);
		GetDamageResult(result.GetDamageHigh(resultIdx), result.DidMiss(resultIdx), topCreatureHealth, maxStackSize);
		if( result.IsHeal( resultIdx ) && !result.GetCurrentEffect().HasTag( TAG_RESURRECT ) )
		{
			result.SetKillRange(0, 0, resultIdx);
		}
		else
		{
			result.SetKillRange((stackSizeBefore - minStackSize), (stackSizeBefore - maxStackSize),resultIdx);
		}
	}

	// find the damage to apply (or rather the state after damage)
	GetDamageResult(result.GetDamage(resultIdx), result.DidMiss(resultIdx), topCreatureHealth, stackSize); // GET

	if( isForecast && result.IsHeal( resultIdx ) && !result.GetCurrentEffect().HasTag( TAG_RESURRECT ) )
	{
		result.SetKills( 0, resultIdx );
	}
	else
	{
		result.SetKills( stackSizeBefore - stackSize, resultIdx );
	}

	caster = result.GetAttacker().GetOriginal();
	if( H7Unit( caster ) != none )
	{
		H7Unit( caster ).SetKillsOnCurrentTurn( result.GetKills( resultIdx ) );
	}

	// in case dude dies after the attack, raise ON_GET_DAMAGE here so that eventual targets won't be none
	if( raiseEvent )
	{
		eventStruct.Result = result;
		result.GetCurrentEffect().GetTagsPlusBaseTags( eventStruct.ActionTag );
		eventStruct.ActionSchool = result.GetCurrentEffect().GetSource().GetSchool();
		eventStruct.EffectContainer = result.GetCurrentEffect().GetSource();
		eventStruct.Targetable = self;
		eventStruct.TargetableTargets = result.GetDefenders();
		result.GetAttacker().GetOriginal().TriggerEvents( ON_DO_DAMAGE, isForecast, eventStruct );
		caster = result.GetAttacker().GetOriginal();
		if(H7CreatureStack(caster) != none && H7CreatureStack(caster).GetCurrentLuckType() == GOOD_LUCK)
		{
			result.GetAttacker().GetOriginal().TriggerEvents( ON_DO_CRITICAL_DAMAGE, isForecast, eventStruct );
		}

		// attack missed? dude doesn't get damage, so don't trigger event
		if(!result.DidMiss(resultIdx) && ( !mCreature.GetAnimControl().IsDying() || IsDead() ) )
		{
			TriggerEvents(ON_GET_DAMAGE, isForecast, eventStruct );
		}

		// raise event on buff (NOT owner to avoid triggering abilities)
		if(result.GetCurrentEffect().GetSource().IsA('H7BaseBuff'))
		{
			result.GetCurrentEffect().GetSource().GetEventManager().Raise(ON_DO_DAMAGE, isForecast, eventStruct);
		}
	}

	if( !isForecast && result.GetKills() > 0 )
	{
		eventStruct.Result = result;
		eventStruct.Amount = result.GetKills();
		result.GetCurrentEffect().GetTagsPlusBaseTags( eventStruct.ActionTag );
		eventStruct.ActionSchool = result.GetCurrentEffect().GetSource().GetSchool();
		eventStruct.EffectContainer = result.GetCurrentEffect().GetSource();
		eventStruct.Targetable = self;
		result.GetAttacker().GetOriginal().TriggerEvents( ON_KILL_CREATURE, false, eventStruct );
	}

	if(!isForecast)
	{
		// don't play gethit if creature is moving, the attack misses or the whole stack gets annihilated
		if( !IsMoving() && !result.DidMiss(resultIdx) && ( result.GetKills() < stackSizeBefore ) )
		{
			GetCreature().GetAnimControl().PlayAnim( CAN_GET_HIT );
		}

		// SET actually changing health&stacksize here:
		if( WorldInfo.GRI.IsMultiplayerGame() )
		{
			combatOfLocalPlayer = mCombatCtrl.GetArmyAttacker().GetPlayer().IsControlledByLocalPlayer() || mCombatCtrl.GetArmyDefender().GetPlayer().IsControlledByLocalPlayer();
			// the local player has the turn
			if( mCombatCtrl.GetActiveUnit().GetPlayer().IsControlledByLocalPlayer() ||
				( mCombatCtrl.GetActiveUnit().GetPlayer().GetPlayerType() == PLAYER_AI && combatOfLocalPlayer) )
			{
				SetStackSize( stackSize );
				mTopCreatureHealth = topCreatureHealth;
				// send the damage to the other players
				class'H7CombatPlayerController'.static.GetCombatPlayerController().SendDamageApply( GetID(), mStackSize, mTopCreatureHealth );
			}
			else // the local player doesnt have the turn
			{
				// check if the damage was really applied
				if( class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().TryingDamageApply( GetID(), stackSize, topCreatureHealth ) )
				{
					class'H7ReplicationInfo'.static.PrintLogMessage("-->Damage Confirmed!", 0);;
					// the damage was really applyed
					SetStackSize( stackSize );
					mTopCreatureHealth = topCreatureHealth;
				}
				else
				{
					mpDamageData = class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().GetNextDamageForStack(GetID());
					if(mpDamageData.CreatureStackId == GetID())
					{
						SetStackSize(mpDamageData.StackSize);
						mTopCreatureHealth = mpDamageData.TopCreatureHealth;
					}
					else
					{
						class'H7ReplicationInfo'.static.PrintLogMessage("-->Damage Not Found!" @ GetID() @ stackSize @ topCreatureHealth, 0);;
						SetStackSize( stackSize );
						mTopCreatureHealth = topCreatureHealth;
					}
				}
			}
		}
		else
		{
			SetStackSize( stackSize );
			mTopCreatureHealth = topCreatureHealth;
		}

		caster = result.GetAttacker().GetOriginal();
		if( H7Unit( caster ) != none )
		{
			H7Unit( caster ).SetKillsOnCurrentTurn( result.GetKills( resultIdx ) );
		}

		container = result.GetCurrentEffect().GetSource();
		attackSchool = result.GetDamageSchool(resultIdx);

		if(result.DidMiss(resultIdx))
		{
			fct = class'H7FCTController'.static.GetInstance().startFCT(FCT_ERROR, GetFloatingTextLocation(), GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_MISS","H7FCT"), MakeColor(200,200,200,255));
			if( fct != none )
			{
				fct.SetDoUpperScreenBorderCheck(true);
			}

			message = new class'H7Message';
			message.text = "MSG_TARGET_MISSED";
			message.AddRepl("%target",GetName());
			message.AddRepl("%ability",container.GetName());
		}
		else if(result.GetDamage(resultIdx) == 0)
		{
			fct = class'H7FCTController'.static.GetInstance().startFCT(FCT_ERROR, GetFloatingTextLocation(), GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_IMMUNE","H7FCT"), MakeColor(200,200,200,255));
			if( fct != none )
			{
				fct.SetDoUpperScreenBorderCheck(true);
			}

			message = new class'H7Message';
			message.text = "MSG_TARGET_IMMUNE";
			message.AddRepl("%target",GetName());
			message.AddRepl("%ability",container.GetName());
		}
		else
		{
			fct = class'H7FCTController'.static.GetInstance().startFCT(FCT_DAMAGE, GetFloatingTextLocation(), GetPlayer(), string(result.GetDamage(resultIdx)), MakeColor(255,0,0,255));
			if( fct != none )
			{
				fct.SetDoUpperScreenBorderCheck(true);
			}

			message = new class'H7Message';
			message.text = "MSG_TARGET_DAMAGE";
			message.AddRepl("%school",String(attackSchool)); // not really shown in text but used to prevent merging of log messages
			message.AddRepl("%target",GetName());
			message.AddRepl("%value",string(result.GetDamage(resultIdx)) @ "<img width='#TT_POINT#' height='#TT_POINT#' src='" $ container.GetSchoolFlashPath(attackSchool) $ "'>" @ container.GetSchoolName(attackSchool));
			message.AddRepl("%amount",string(result.GetKills(resultIdx)));
		}

		message.destination = MD_LOG;
		message.settings.referenceObject = self;
		
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);

		;
		
		if(result.GetKills(resultIdx) > 0) 
		{
			fct = class'H7FCTController'.static.GetInstance().startFCT(FCT_KILL, GetFloatingTextLocation(), GetPlayer(), string(result.GetKills(resultIdx)), MakeColor(255,0,0,255));
			if( fct != none )
			{
				fct.SetDoUpperScreenBorderCheck(true);
			}			
			class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateStackSize( self );
		}

		// show retaliation text
		/* nobody liked it
		if(result.GetActionId() == ACTION_RETALIATE )
		{
			fct = class'H7FCTController'.static.GetInstance().startFCT( FCT_RETALIATION, GetFloatingTextLocation(), GetPlayer(), `Localize("H7FCT","FCT_RETALIATION","MMH7GAME"), MakeColor(255,0,0,255));
			fct.SetDoUpperScreenBorderCheck(true);
		}
		*/

		// Killing the creature
		if( mStackSize <= 0 )
		{
			SetDead(result);
		}
		

		DataChanged("ApplyDamage");
	}

	if( raiseEvent )
	{
		eventStruct.Result = result;
		result.GetCurrentEffect().GetTagsPlusBaseTags( eventStruct.ActionTag );
		eventStruct.ActionSchool = result.GetCurrentEffect().GetSource().GetSchool();
		eventStruct.EffectContainer = result.GetCurrentEffect().GetSource();
		eventStruct.Targetable = self;
		eventStruct.TargetableTargets = result.GetDefenders();
		result.GetAttacker().GetOriginal().TriggerEvents( ON_POST_DO_DAMAGE, isForecast, eventStruct );

		// raise event on buff (NOT owner to avoid triggering abilities)
		if(result.GetCurrentEffect().GetSource().IsA('H7BaseBuff'))
		{
			result.GetCurrentEffect().GetSource().GetEventManager().Raise(ON_POST_DO_DAMAGE, isForecast, eventStruct);
		}
	}
}

function RemoveCreature()
{
	mCombatCtrl.GetCommandQueue().RemoveCmdsForCaster( self );
	mCombatCtrl.GetCommandQueue().RemoveCmdsForTarget( self );
	mDelayedCommand = none;
	GetCreature().SetIsHovering(false);
	RemoveCreatureFromCell();

	if( self != H7CreatureStack(mCombatCtrl.GetActiveUnit()) )
	{
		mBuffManager.RemoveBuffsFromDeadOwner();
		mCombatCtrl.GetInitiativeQueue().RemoveUnit( self );
	}
	else
	{
		ClearTurns();
	}

	mCombatCtrl.GetArmyAttacker().UpdatedAlliesAndEnemies();
	mCombatCtrl.GetArmyDefender().UpdatedAlliesAndEnemies();

	HideSlotFX( none );
}

function SetDead(optional H7CombatResult result)
{
	local H7EventContainerStruct container;

	// Disable collision on collider so tracing can ignore it (reenabled when creature is resurrected)
	mCollider.SetActorCollision( false, false, false);
	mCollider.SetTraceBlocking(false, false);

	container.Result = result;
	mDelayedCommand = none;
	if( mStrikeAndReturnReferenceCell != none )
	{
		AfterStrikeAndReturnMove();
		mStrikeAndReturnReferenceCell = none;
	}

	mCombatCtrl.SetSomeoneDying( true );

	TriggerEvents( ON_CREATURE_DIE, false );
	mCombatCtrl.GetGridController().GetAuraManager().TriggerEvents( ON_CREATURE_DIE, false, , self );
	mCombatCtrl.RaiseEvent( ON_ANY_CREATURE_DIE,false,, container );

	if( mCombatCtrl.GetCommandQueue().GetCurrentCommand() != none &&
		mCombatCtrl.GetCommandQueue().GetCurrentCommand().IsRunning() &&
		mCombatCtrl.GetCommandQueue().GetCurrentCommand().GetCommandSource() == self &&
		( mCombatCtrl.GetCommandQueue().GetCurrentCommand().GetCommandTag() == ACTION_MOVE ||
		mCombatCtrl.GetCommandQueue().GetCurrentCommand().GetCommandTag() == ACTION_MOVE_ATTACK ) )
	{
		mCombatCtrl.GetCommandQueue().GetCurrentCommand().SetInterruptOnNextUpdate( true );
		mCombatCtrl.GetCommandQueue().SetLastCommandExecuted( ACTION_MOVE );
	}
	else
	{
		mBuffManager.RemoveBuffsFromDeadOwner();
	}

	mCombatCtrl.GetCommandQueue().RemoveCmdsForCaster( self );
	mCombatCtrl.GetCommandQueue().RemoveCmdsForTarget( self );
	
	if(!mSkipDeathAnim)
	{
		GetCreature().GetAnimControl().PlayAnim( CAN_DIE );
	}
	else
	{
		GetCreature().GetAnimControl().FakeDyingAnimation( mFakeDeathDelay );
	}
	GetCreature().SetIsHovering( false );

	RemoveCreatureFromCell();
	if( !mIsSummoned )
	{
		BuryCreature();  // bury the creature to the 2nd layer of a cell
	}
	
	// block all input to a cell, where a creature is dying
	GetCell().SetDying( true );

	// not remove the creature if has the current turn, it will remove itself at the end of the turn
	if( self != H7CreatureStack(mCombatCtrl.GetActiveUnit()) )
	{
		mCombatCtrl.GetInitiativeQueue().RemoveUnit( self );
	}
	else
	{
		ClearTurns();
	}

	mCombatCtrl.GetArmyAttacker().UpdatedAlliesAndEnemies();
	mCombatCtrl.GetArmyDefender().UpdatedAlliesAndEnemies();
	
	HideSlotFX( none );
	
	TriggerGlobalEventClass( class'SeqEvent_Death', self, 0 );

	;

}

function DestroyCreatureStack()
{
	mCreature.Destroy();
	HideSlotFX( mCombatGridController.GetCombatGrid().GetCellByIntPoint( GetGridPosition() ) );
	mStackFX.Destroy();
	mEffectManager.ResetFX();
	Destroy();

	class'H7CombatMapStatusBarController'.static.GetInstance().removeBar( self );
	class'H7CreatureStackPlateController'.static.GetInstance().removePlate( self );
}

function Kill()
{
	SetStackSize( 0 );
	mKilled = true;
	SetDead();
}

function GetDamageResult( int dmg, bool didMiss, out int topCreatureHealth, out int stackSize )
{
	local int killedStacks, currentHealth;
	topCreatureHealth = mTopCreatureHealth;
	stackSize = mStackSize;

	// attacker missed? everything stays as it is
	if(didMiss) { return; }

	if(dmg < topCreatureHealth)
	{
		topCreatureHealth -= dmg;
	}
	else if( dmg < (stackSize - 1) * GetHitpoints() + topCreatureHealth)
	{
		currentHealth = GetHitPoints();
		killedStacks = 1 + (dmg - topCreatureHealth) / currentHealth;
		stackSize -= killedStacks;
		topCreatureHealth = killedStacks * currentHealth + topCreatureHealth - dmg;
	}
	else
	{
		stackSize = 0;
		topCreatureHealth = 0;
	}
}

function int GetHitpointsTotal()
{
	if(GetStackSize()<=0) return 0;
	return (GetStackSize()-1) * GetHitpoints() + GetTopCreatureHealth();
}

function int GetMaxHitpointsTotal()
{
	return GetInitialStackSize() * GetHitpoints();
}

protected function InitStackFX()
{
	mStackFX = Spawn(class'H7CreatureStackFX', self);
	mStackFX.InitFX(self);
}

function bool IsMoving()
{
	return mMoveControl.IsMoving();
}

function MoveCreature( array<H7BaseCell> path, optional H7IEffectTargetable target )
{	
	ShowCemetary( true );
	path.Remove( 0, 1 );    // The starting cell is not included
	mMoveControl.MoveStack(path, target);
}

delegate OnFaceTargetFinishedFunc(){}
function FaceTarget( H7IEffectTargetable target, delegate<OnFaceTargetFinishedFunc> onFaceTargetFinished )
{
	mMoveControl.AttackStack( target, onFaceTargetFinished );
}

function EndMoving( optional bool ignoreTargetNotReachedMessage = true  )
{
	mCombatGridController.PlaceCreature( mGridPos, self );
    if( GetMovementType() == CMOVEMENT_JUMP )  
    {
    	TriggerEvents( ON_JUMP_PITCH, false );

		if( GetAbilityManager().GetPreparedAbility() != none &&
			!GetAbilityManager().GetPreparedAbility().HasTag( TAG_DAMAGE_DIRECT ) &&
			GetAbilityManager().GetPreparedAbility().GetNumCharges() > 0 )
		{
			GetAbilityManager().GetPreparedAbility().SetCurrentCharges( GetAbilityManager().GetPreparedAbility().GetCurrentCharges() - 1 );
		}
    }
	ShowCemetary();

	if( GetMovementType() != CMOVEMENT_JUMP )  
    {
		GetCreature().GetAnimControl().PlayAnim( CAN_IDLE );
    }
}

function AfterStrikeAndReturnMove()
{
	local array<H7CombatMapCell> mergedCells;
	local int f;

	mStrikeAndReturnReferenceCell.GetCellsHitByCellSize( mCreature.GetBaseSize(), mergedCells );
	for( f = 0; f < mergedCells.Length; ++f )
	{
		mergedCells[f].SetAbilityHighlight( false );
		mergedCells[f].SetSelected( false );
		mergedCells[f].UpdateSelectionType();
	}

	class'H7CombatMapGridController'.static.GetInstance().ResetSelectedAndReachableCells();
	class'H7CombatMapGridController'.static.GetInstance().RecalculateReachableCells();
	class'H7CombatMapGridController'.static.GetInstance().ForceGridStateUpdate();
	StatusChanged();
}

function HighlightStack(optional bool evenIfBusy=false) // called every frame
{
	if ( mCreature.IsHovering() ) 
	{	
		return;
	}
	else if( !IsDead() )
	{
		mCreature.SetIsHovering( true , evenIfBusy);
		class'H7CombatHudCntl'.static.GetInstance().HightlightSlots( GetID() );
		StatusChanged();
		UpdateSlotFX( true );
	}
	else if( IsDead() )
	{
		mCreature.SetIsHovering( true , evenIfBusy);
		StatusChanged();
		UpdateSlotFX( true );
	}
}

function DehighlightStack()
{
	if ( mCreature.IsHovering() )
	{	
		mCreature.SetIsHovering(false);
		class'H7CombatHudCntl'.static.GetInstance().DehighlightSlots( GetID() );
		H7CombatHud(class'H7PlayerController'.static.GetPlayerController().myHUD).GetCombatHudCntl().HideAbilityPreview("DehighlightStack");
		StatusChanged();
		HideStackFX();
	}
}

function ORIENTATION StackHeading()
{	
	switch( Rotation.Yaw )
	{
		case 32768:
			return O_WEST;
		case 0: 
			return O_EAST;
	}
	return O_WEST;
}

protected function DebugLogSelf()
{
	local array<H7BaseBuff> buffs;
	mBuffManager.GetActiveBuffs( buffs );
	;
	;
	;
	;

}

function EMoraleType DoMoralRoll()
{
	local int moral;
	local EMoraleType moralType; 

	moral = GetCurrentMoral();
	moral = Clamp( moral, GetModifiedStatByID( STAT_MORALE_MIN ), GetModifiedStatByID( STAT_MORAL_CAP ) );

	if( class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( 100 ) < Abs(moral) )
	{
		moralType = moral > 0 ? GOOD_MORALE : BAD_MORALE;
	}
	else
	{
		moralType = NORMAL_MORALE;
	}

	return moralType;
}

function ChangeLocomotionSpeed(H7FXStruct effect)
{
	local float modSpeed, speed;

	modSpeed = effect.mAnimationSpeed;
	if(effect.mAnimationSpeed > 0)
		modSpeed = 1 / effect.mAnimationSpeed;
	
	SetMovementSpeedModifier(modSpeed);
	SetFlyingSpeedModifier(modSpeed);
	self.CustomTimeDilation = effect.mAnimationSpeed;

	speed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * effect.mAnimationSpeed;
	SetRTPCValue('Game_Speed', speed * (100 + self.mAnimSoundSpeedManipulator));
}

// CHECK this contains 'hardcoded' numbers that are neither H7EffectContainers nor H7MeModifiesStat :-(
function int GetCurrentMoral()
{
	local int moral, factionCount;
	local float mixedFactionsMod;
	local H7CombatConfiguration combatConfiguration;
	local array<H7MeModifiesStat> setMods;
	local H7StatModSource statModSource;
	local H7MeModifiesStat statMod;

	combatConfiguration = mCombatCtrl.GetCombatConfiguration();

	moral = GetLeadership();

	GetModifiersByID(setMods, STAT_MORALE_LEADERSHIP, OP_TYPE_SET);

	if( setMods.Length > 0 ) return moral;

	if( GetCombatArmy().GetHero() != none && GetCombatArmy().GetHero().IsHero() && GetFaction() != class'H7GameData'.static.GetInstance().GetNeutralFaction() )
	{
		factionCount = GetCombatArmy().GetFactionsInArmyCount(true);

		if( factionCount >= 2 )
		{
			mixedFactionsMod = GetForeignMoralePenaltyModifier() * combatConfiguration.GetMoraleDebuffEnemyFactionUnits();
			moral += mixedFactionsMod;
			statMod.mCombineOperation = OP_TYPE_ADD;
			statMod.mModifierValue = mixedFactionsMod;
			statModSource.mSourceName = class'H7Loca'.static.LocalizeSave("MORAL_MIXED_FACTION","H7Abilities");
			statModSource.mMod = statMod;
			mStatModSourceBuffer.AddItem( statModSource );
		}
	}
	
	return moral;
}

function array<H7CreatureStack> GetNeighbourFriendlyStacks( optional H7CombatHero hero = None )
{
	local array<H7CombatMapCell> neighbourCells;
	local array<H7CombatMapCell> mergedCells;
	local H7CombatMapCell currentNeighbourCell;
	local H7CombatMapCell currentCell;
	local H7CombatController combatController;
	local H7CreatureStack currentCreature;
	local array<H7CreatureStack> neighbourCreatures;
	
	combatController = class'H7CombatController'.static.GetInstance();
	
	mergedCells = combatController.GetGridController().GetCell( combatController.GetGridController().GetCellLocation( GetGridPosition() ) ).GetMergedCells();

	foreach mergedCells( currentCell )
	{   
		neighbourCells = currentCell.GetNeighbours();
			
		foreach neighbourCells( currentNeighbourCell )
		{
			currentCreature = currentNeighbourCell.GetCreatureStack();
			if( currentCreature != none )
			{
				if( currentCreature != self
					&& !currentCreature.IsDead()
					&& ((hero==None && GetCombatArmy()==currentCreature.GetCombatArmy()) || (hero!=None && hero.GetCombatArmy()==currentCreature.GetCombatArmy()))
					)
				{
					neighbourCreatures.AddItem( currentNeighbourCell.GetCreatureStack() );
				}
			}
		}
	}

	return neighbourCreatures;
}

function array<H7CreatureStack> GetNeighbourHostileStacks( optional H7CombatHero hero = None )
{
	local array<H7CombatMapCell> neighbourCells;
	local array<H7CombatMapCell> mergedCells;
	local H7CombatMapCell currentNeighbourCell;
	local H7CombatMapCell currentCell;
	local H7CombatController combatController;
	local H7CreatureStack currentCreature;
	local array<H7CreatureStack> neighbourCreatures;
	
	combatController = class'H7CombatController'.static.GetInstance();
	
	mergedCells = combatController.GetGridController().GetCell( combatController.GetGridController().GetCellLocation( GetGridPosition() ) ).GetMergedCells();

	foreach mergedCells( currentCell )
	{   
		neighbourCells = currentCell.GetNeighbours();
			
		foreach neighbourCells( currentNeighbourCell )
		{
			currentCreature = currentNeighbourCell.GetCreatureStack();
			if( currentCreature != none )
			{
				if( currentCreature != self
					&& !currentCreature.IsDead()
					&& ((hero==None && GetCombatArmy()!=currentCreature.GetCombatArmy()) || (hero!=None && hero.GetCombatArmy()!=currentCreature.GetCombatArmy()))
					)
				{
					neighbourCreatures.AddItem( currentNeighbourCell.GetCreatureStack() );
				}
			}
		}
	}

	return neighbourCreatures;
}

function int GetCellDistanceToCreature( H7CreatureStack targetStack, bool useMasterCells )
{
	local array<H7CombatMapCell> ownCells, targetCells;
	local int closestDistance, currentDistance;
	local int i, j;

	closestDistance = MaxInt;

	if( targetStack == none ) return 0;

	if( useMasterCells )
	{
		return class'H7Math'.static.GetLineCellsLengthBresenham( GetCell().GetGridPosition(), targetStack.GetCell().GetGridPosition() );
	}

	ownCells = GetCell().GetMergedCells();
	targetCells = targetStack.GetCell().GetMergedCells();

	for( i = 0; i < ownCells.Length; ++i )
	{
		for( j = 0; j < targetCells.Length; ++j )
		{
			currentDistance = class'H7Math'.static.GetLineCellsLengthBresenham( ownCells[i].GetGridPosition(), targetCells[j].GetGridPosition() );

			if( currentDistance < closestDistance )
			{
				closestDistance = currentDistance;
			}
		}
	}

	return closestDistance;
}

function H7BaseBuff GetRetaliatedBuff()
{
	local H7BaseAbility retaliateAbility;
	local array<H7SpellEffect> spellEffects;
	local H7SpellEffect currentEffect;

	retaliateAbility = GetRetaliationAbility();

	if( retaliateAbility == none ) return none;

	spellEffects = retaliateAbility.GetSpellEffects();
	
	foreach spellEffects( currentEffect )
	{
		if( currentEffect.mSpellStruct.mSpell.IsA( 'H7BaseBuff' ) )
		{
			return H7BaseBuff( currentEffect.mSpellStruct.mSpell );
		}
	}

	return none;
}

/** Also takes the creature size in account */
function array<H7CombatMapCell> GetNeighbourCells()
{
	local array<H7CombatMapCell> neighbours, mergedCells;

	if( GetCell() == none )
	{
		;

		return neighbours;
	}
	
	mergedCells = GetCell().GetMergedCells();

	if( mergedCells.Length == 0 ) return neighbours;
	neighbours = mCombatGridController.GetCombatGrid().GetNeighbourCells( mergedCells );

	return neighbours;
}

native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType exclusiveFirstOT = -1, optional EOperationType exclusiveSecondOT = -1, optional bool nextRound);
native function float GetAttackPowerRelation( bool capOrFloor );

function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{
	
}

function GUIAddListener(GFxObject data,optional H7ListenFocus focus)
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}

function DataChanged(optional String cause)
{
	mHasDataChanged = true;
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

function bool HasDataChanged()
{
	return mHasDataChanged;
}

function ResetHasDataChanged()
{
	mHasDataChanged = false;
}

function PlayRandomlyDelayedVictoryAnim()
{
	SetTimer( FRand() * 1.5f + 0.01f, false, nameof(PlayVictoryAnim) );
}

function PlayVictoryAnim()
{
	GetCreature().GetAnimControl().PlayAnim( CAN_VICTORY );
}

function bool IsInWaitQueue()
{
	return class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsAWaitingUnit(self);
}

function Vector GetFloatingTextLocation()
{
	local Vector loc;

	loc = Location;
	loc.Z += mCollider.Bounds.BoxExtent.Z * 2.f;
	return loc;
}

function String GetStackSizeObfuscated() 
{ 
	return mBaseCreatureStack.GetStackSizeObfuscated();
}

function bool CanRangeAttack()
{
	local array<H7CombatMapCell> dummyArray;
	local bool prepAbi;
	dummyArray.Length = 0;

	if( GetPreparedAbility() != none )
	{
		prepAbi = GetPreparedAbility().IsRanged() && GetPreparedAbility().IsHeal();
	}

	if( IsRanged() && ( !mCombatGridController.GetCombatGrid().HasAdjacentCreature( self, none, true, dummyArray ) || prepAbi ) && !GetAbilityManager().GetAbility( GetRangedAttackAbility() ).IsSuppressed() )	// is not blocked by an enemy unit
	{
		// ammo check
		if( UsesAmmo() && GetAmmo() <= 0 )
		{
			return false;
		}
		else
		{
			return true;
		}
	}

	return false;
}

function array<H7CreatureStack> GetSuppressedStacks()
{
	local array<H7CombatMapCell> mergedCells, allNeighbourCells, neighbours;
	local H7CombatMapCell neighbour, mergedCell;
	local array<H7CreatureStack> suppressingStacks;

	if( CanRangeAttack() )
	{
		mergedCells = GetCell().GetMergedCells();
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
			if( neighbour.HasCreatureStack() && 
				neighbour.GetCreatureStack().GetPlayer() != GetPlayer() &&
				suppressingStacks.Find( neighbour.GetCreatureStack() ) == INDEX_NONE && 
				neighbour.GetCreatureStack().CanRangeAttack() )
			{
				suppressingStacks.AddItem( neighbour.GetCreatureStack() );
			}
		}
	}

	return suppressingStacks;
}

function SetOrphan(bool val) { mIsOrphan = val; }
function bool IsOrphan() { return mIsOrphan; }

