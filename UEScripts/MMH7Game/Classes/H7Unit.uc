//=============================================================================
// H7Unit
//=============================================================================
//
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Unit extends SkeletalMeshActorMAT implements (H7IEffectTargetable, H7ICaster)
	native
	perobjectconfig
	dependsOn(H7Faction)
	dependsOn(H7Command)
	dependsOn(H7StructsAndEnumsNative)
	dependsOn(H7EffectContainer)
	savegame;

const DEFAULT_INITIATIVE = 1;

var() private edithide editconst bool mNeedsPrivileg;
var() private edithide editconst int mPrivilegID;
var() protected edithide CylinderComponent mCollider;

var(Properties) protected localized string          mName<DisplayName="Name">;
var(Properties) protected localized string          mLore<DisplayName="Lore">;
/**1 = 1.00 % faster -1 = 1.00 % slower*/
var(Properties) protected float                     mAnimSoundSpeedManipulator<DisplayName="Animation Sound Speed Manipulator">;

var(Properties) protected bool  mOverrideAutoCollider<DisplayName="Override Auto TargetingCollider">;
var(Properties) protected float mColliderRadius<DisplayName="Targeting Capsule Radius (Default: 2x2 Creatures: 100, 1x1: 50)"|EditCondition=mOverrideAutoCollider>;
var(Properties) protected float mColliderHeight<DisplayName="Targeting Capsule Height (Default: Creature Height)"|EditCondition=mOverrideAutoCollider>;

var transient protected string	                    mNameInst;
var transient protected string                      mLoreInst;
var(Visuals)    dynload protected Texture2D	        mIcon<DisplayName="Icon">;
var(Visuals)    dynload protected Texture2D         mArtwork<DisplayName="Artwork">;
var(Properties) protected H7Faction                 mFaction<DisplayName="Faction">;
var(Properties) protected array<H7ResourceQuantity> mUnitCost<DisplayName="Cost">;
var(Visuals)    protected name                      mProjectileStartSocket<DisplayName="Projectile Start Socket">;
var(Visuals)    protected Texture2D		            mFactionSymbol<DisplayName="Symbol (Flags & GUI)">; // small
var transient   protected float                     mStatCache[EStat.STAT_MAX];


var(Stats) protected int                mInitiative<DisplayName=Initiative|ClampMin=0>;
var(Stats) protected int                mAttack<DisplayName=Attack|ClampMin=0>;
var(Stats) protected int                mDefense<DisplayName=Defense|ClampMin=0>;
var(Stats) protected int                mLeadership<DisplayName=Leadership|ClampMin=0>;
var(Stats) protected int                mDestiny<DisplayName=Destiny|ClampMin=0>;
var(Stats) protected int                mMinimumDamage<DisplayName=Minimum Damage|ClampMin=0>;
var(Stats) protected int                mMaximumDamage<DisplayName=Maximum Damage|ClampMin=0>;
var(Stats) protected int                mMovementPoints<DisplayName=Movement Points Maximum|ClampMin=0>;
var(Stats) protected EAbilitySchool     mSchoolType<DisplayName=Magic School>;
var        protected int                mMagicAbs;

/// DEFAULT ABILITIES
var(Stats) protected H7BaseAbility		mLuckAbility<DisplayName=Luck Ability>;
var(Stats) protected H7BaseAbility      mMeleeAttackAbilityTemplate<DisplayName=Melee Attack>;
var(Stats) protected H7BaseAbility      mRangedAttackAbilityTemplate<DisplayName=Ranged Attack>;
var(Stats) protected H7BaseAbility      mWaitAbility<DisplayName=Wait Ability>;

//Effects
var(Visuals)protected ParticleSystem    mGhostWalkParticles <DisplayName=Ghostwalk Effect>;
var(Visuals)protected ParticleSystem    mTeleportStartEffect <DisplayName=Start Teleport Effect>;
var(Visuals)protected ParticleSystem    mTeleportEndEffect <DisplayName=End Teleport Effect>;
var(Audio)protected AkEvent             mTeleportationStartSound <DisplayName=Start Teleport fx sound>;
var(Audio)protected AkEvent             mTeleportationEndSound <DisplayName=End Teleport fx sound>;

var protected H7BaseAbility             mSubstituteLuckAbility;

var protected IntPoint                  mGridPos;

var protected array<H7BaseCell>         mLastPath;


// not an editor value! only used for stat modifiers that change the attack range of a creature
// which can't be done directly because its an EAttackRange value
var protected int                   mRange;
var protected float                 mFlankingBonus;

var protected savegame H7AbilityManager	    mAbilityManager;
var protected H7BuffManager			mBuffManager;
var protected H7EventManager        mEventManager;
var protected H7EffectManager       mEffectManager;
var protected savegame H7EditorArmy	mArmy;
var protected H7AdventureArmy       mArmyAdventure;
var protected bool                  mHasBadMoral;

var protected savegame int			mID;
var protected bool                  mDoStatusCheck; // needs to be set to true, so unit checks only then checks its state and not every frame

var protected ELuckType				mLuckType;
var protected bool                  mWaitClicked;
var protected bool                  mIsWaiting;
var protected bool                  mIsWaitTurn;
var protected int                   mAttackCount;
var protected int                   mMoveCount;
var protected int                   mKillsOnCurrentTurn;
var protected bool                  mIsMoralTurn;
var protected bool                  mMarkForSkipTurn;
//var protected bool                  mIsLastDefendTurn;
var protected bool                  mIsAdditionalTurn;
var protected bool                  mFinishedCommand;
var protected bool                  mTriggerTurnStartEvents;
var protected bool                  mTriggerTurnEndEvents;
var protected bool                  mOverrideWithAI;

var protected bool                  mIsDoneForAI;

var protected bool					mSkipTurn;
var protected bool                  mIgnoreAllegiances;
var protected int                   mAttackCountMod;

var protected H7Wave	            mCurrentWave;
// ---- ported from H7EffectSpecialTsunami ----
var protected array<CreaturePositon>	mNewCreaturePosition;
var protected array<H7CreatureStack>	mCasualtyStacks;
var protected H7BaseAbility             mWaveSource;
var protected bool	                    mRotateRandom;
// --------------------------------------------

var protected H7CombatController    mCombatCtrl;

var transient protected array<H7StatModSource>    mStatModSourceBuffer;

var transient array<ParticleSystemComponent> mEmitterPoolParticleComps;

native function ECellSize			GetUnitBaseSize();
function int					    GetUnitBaseSizeInt()		                    { return CELLSIZE_1x1+1; }

native function H7BaseAbility       GetMeleeAttackAbility();
/** Get Ranged Default Attack Template (Archetype)*/
native function H7BaseAbility       GetRangedAttackAbility();
/** Get Ranged Default Wait Template (Archetype)*/
function H7BaseAbility              GetWaitAbility()                                { return mWaitAbility; }

function                            SetMeleeAttackAbility(H7BaseAbility ability)	{ mMeleeAttackAbilityTemplate = ability; }
function                            SetRangedAttackAbility(H7BaseAbility ability)	{ mRangedAttackAbilityTemplate = ability; }
function                            SetWaitAbility(H7BaseAbility ability)           { mWaitAbility = ability; }

function float                      GetAnimSoundSpeedManipulator()                  { return mAnimSoundSpeedManipulator; }
function ParticleSystem             GetGhostWalkParticleFX()                        { return mGhostWalkParticles; }
function ParticleSystem             GetTeleportStartParticleFX()                    { return mTeleportStartEffect; }
function ParticleSystem             GetTeleportEndParticleFX()                      { return mTeleportEndEffect; }
function AkEvent                    GetStartTeleportFXSound()                       { return mTeleportationStartSound;}
function AkEvent                    GetEndTeleportFXSound()                         { return mTeleportationEndSound;}
function bool                       HasTeleportStartFX()                            { return mTeleportStartEffect != none; }
function bool                       HasTeleportEndFX()                              { return mTeleportEndEffect != none; }
function bool                       CanMakeAction()                                 { return !mSkipTurn && ( CanAttack() || CanMove() ) && !IsDead();  }
function bool                       HasFullAction()                                 { return !mSkipTurn && ( CanAttack() && CanMove() );  }
function                            ResetTurnCount()                                { mAttackCount = default.mAttackCount; mMoveCount = default.mMoveCount; SetAdditionalTurn( false ); }
function                            ClearTurns()                                    { mAttackCount = -class'Object'.const.MaxInt; mMoveCount = -class'Object'.const.MaxInt; }
function 				            UseAttack()                                     { --mAttackCount; mAttackCount = Clamp( mAttackCount, 0, MaxInt ); }
function int						GetAttackCount()                                { return GetModifiedStatByID( STAT_ATTACK_COUNT ); }
function bool						CanAttack()                                     { return GetAttackCount() > 0; }
function 				            UseMove()                                       { --mMoveCount; mMoveCount = Clamp( mMoveCount, 0, MaxInt ); }
function int						GetMoveCount()                                  { return GetModifiedStatByID( STAT_MOVE_COUNT ); }
function bool						CanMove()                                       { return self.IsA('H7CreatureStack') ? GetMoveCount() > 0 : false; }
function                            SetMoralTurn( bool boool )                      { mIsMoralTurn = boool; }
function                            SetAdditionalTurn( bool boool )                 { mIsAdditionalTurn = boool; }
function bool                       IsMarkedForTurnSkip()                           { return mMarkForSkipTurn; }
function                            MarkForTurnSkip( bool mark )                    { mMarkForSkipTurn = mark; }
function bool                       FinishedCommand()                               { return mFinishedCommand; }
function                            SetCommandFinished( bool isFinished )           { mFinishedCommand = isFinished; }
function							SetSkipTurn( bool newSkipTurn )			        {  mSkipTurn = newSkipTurn; }
function                            SetUnitCosts( array<H7ResourceQuantity> costs ) { mUnitCost = costs; }
native function H7ICaster           GetOriginal();
native function H7AbilityManager	GetAbilityManager();
native function H7BuffManager		GetBuffManager();
native function H7EventManager      GetEventManager();
function							SetArmy( H7EditorArmy army )					{ mArmy = army; }
function H7EditorArmy				GetArmy()					                    { return mArmy; }
native function H7CombatArmy		GetCombatArmy();
native function H7AdventureArmy		GetAdventureArmy();
native function EUnitType			GetEntityType();
function H7Faction					GetFaction()									{ return mFaction; }
native function int					GetID();
function ELuckType					GetCurrentLuckType()							{ return mLuckType; }
function 					        SetCurrentLuckType( ELuckType luck )			{ mLuckType = luck; }
function        					SetWaitClick(bool value)						{ mWaitClicked = value; }
function bool						IsRanged()										{ return mRangedAttackAbilityTemplate != none; }
function H7EffectManager            GetEffectManager()								{ return mEffectManager; }
function name                       GetProjectileStartSocketName()					{ return mProjectileStartSocket; }
function int                        GetKillsOnCurrentTurn()							{ return mKillsOnCurrentTurn; }
function                            SetKillsOnCurrentTurn( int kills )				{ mKillsOnCurrentTurn = kills; }
function                            SetIgnoreAllegiances(bool value)                { mIgnoreAllegiances = value; }
function bool                       GetIgnoreAllegiances()                          { return mIgnoreAllegiances; }
function array<H7BaseCell>          GetLastWalkedPath()                             { return mLastPath; }
function                            SetLastWalkedPath( array<H7BaseCell> path )     { mLastPath = path; }
function int                        GetLastWalkedPathLength()                       { return mLastPath.Length-1; }
function int GetHitPoints()  {}

function bool                       IsAutoColliderOverridden()                      { return mOverrideAutoCollider; }
function float                      GetColliderRadius()                             { return mColliderRadius; }
function float                      GetColliderHeight()                             { return mColliderHeight; }

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}

function EAttackType			    GetAttackType()									{ if( GetSchool()==MIGHT ) { return CATTACK_MIGHT; } else { return CATTACK_MAGIC; } }
function EAbilitySchool		        GetSchool()                                     { return mSchoolType; }
function                            SetNewCreaturePosition( array<CreaturePositon> pos ) {mNewCreaturePosition = pos; }
function bool                       HasBadMoral()                                   { return mHasBadMoral; }

native function DumpModifiers();

function SetName(string overrideName)
{
	mNameInst = overrideName;
}
function string GetName()
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		if(mNameInst == "") 
		{
			mNameInst = class'H7Loca'.static.LocalizeContent(self, "mName", mName);
		}
		return mNameInst;
	}
	else
	{
		return H7Unit( ObjectArchetype ).GetName();
	}
}

event string GetUnitName()
{
	return GetName();
}

function String	GetFlashArtworkPath()	
{ 
	local string path;
	
	/*if( mArtwork == none ) 
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mArtwork');
		}
		else
		{
			if( GetOriginArchetype() != none )
			{
				return 
			}
		}
	}*/
	self.DynLoadObjectProperty('mArtwork');
	path = "img://" $ Pathname( mArtwork );
	
	return path;
}

function DeleteImage()
{
	if(!class'Engine'.static.IsEditor())
	{
		mArtwork = none;
	}
}

function string GetLore()
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		if(mLoreInst == "") 
		{
			mLoreInst = class'H7Loca'.static.LocalizeContent(self, "mLore", mLore);
		}
		return mLoreInst;
	}
	else
	{
		return H7Unit( ObjectArchetype ).GetLore();
	}
}

function string GetIDString() 
{
	local string path;

	path = class'H7GameUtility'.static.GetArchetypePath( self );
	return path;
}

function int GetMagic(){    return 0;}
function int GetStackSize(){    return 1;}

function 		                    SetSchoolType(EAbilitySchool school)            { mSchoolType = school; }

function							ResetLuckType()									{ mLuckType = NOTHING_LUCK; }

function bool						IsControlledByAI()								
{ 
	if( mOverrideWithAI )
	{
		return true;
	}
	else if(GetAdventureArmy() != none)
	{
		return GetAdventureArmy().GetPlayer().IsControlledByAI();
	}
	else if(GetCombatArmy() != none)
	{
		return GetCombatArmy().GetPlayer().IsControlledByAI();
	}
	return false;
}

//Modified Stats
function int					    GetAttack()								        { return GetModifiedStatByID(STAT_ATTACK); } 
function float					    GetMinimumDamage()								{ return GetModifiedStatByID(STAT_MIN_DAMAGE); }
function float					    GetMaximumDamage()								{ return GetModifiedStatByID(STAT_MAX_DAMAGE); }
function int					    GetMinimumDamageBase()							{ return GetBaseStatByID(STAT_MIN_DAMAGE); }
function int					    GetMaximumDamageBase()							{ return GetBaseStatByID(STAT_MAX_DAMAGE); }
function int					    GetDefense()									{ return GetModifiedStatByID(STAT_DEFENSE); }
function int                        GetDefenseBase()                                { return mDefense; }
function int					    GetLeadership()									{ return GetModifiedStatByID(STAT_MORALE_LEADERSHIP); }
function int                        GetLeadershipBase()                             { return mLeadership; }
function int					    GetDestiny()									{ return GetModifiedStatByID(STAT_LUCK_DESTINY); }
function int                        GetDestinyBase()                                { return mDestiny; }
native function int					GetLuckDestiny();//								{ return GetModifiedStatByID(STAT_LUCK_DESTINY); }
function float					    GetNegotiationChance()						    { return GetModifiedStatByID(STAT_NEGOTIATION); } 
function float					    GetSurrenderCostModifier()  				    { return GetModifiedStatByID(STAT_SURRENDER_COST_MODIFIER); }
function float					    GetForeignMoralePenaltyModifier()			    { return GetModifiedStatByID(STAT_FOREIGN_MORALE_PENALTY_MODIFIER); }
function String					    GetFlashIconPath()								{ return "img://" $ Pathname( GetIcon() ); }
//function String					    GetFlashArtworkPath()							{ return "img://" $ Pathname( mArtwork ); }
function array<H7ResourceQuantity>  GetUnitCost()                                   { return mUnitCost; }

function Texture2d GetIcon()
{
	if(class'H7GameUtility'.static.IsArchetype(self))
	{
		if(mIcon == none)
		{
			self.DynLoadObjectProperty('mIcon');
			//`log(self @ "of" @ ObjectArchetype @ "dynloaded" @ mIcon);
		}
		return mIcon;
	}
	else
	{
		if(InStr(string(ObjectArchetype),"Default__") != INDEX_NONE)
		{
			// instance was wrongly constructed, not based on archetype, have to dynload into instance
			if(mIcon == none)
			{
				self.DynLoadObjectProperty('mIcon');
				//`log(self @ "of" @ ObjectArchetype @ "dynloaded2" @ mIcon);
			}
			return mIcon;
		}
		else
		{
			return H7Unit(ObjectArchetype).GetIcon();
		}
	}
	return mIcon;
}
 
function bool IsMoving() { return false; }
function bool IsCasting() { return HasPreparedAbility() && GetPreparedAbility().IsCasting(); }
function bool IsAttacker() { return GetCombatArmy().IsAttacker(); }
function bool HasPreparedAbility() { return GetPreparedAbility() != none; }
function bool HasPreparedAbilityId( H7BaseAbility aid ) { if(GetPreparedAbility()!=none) return (GetPreparedAbility().GetName() == aid.GetName()); return false; }

//native function int GetQuickCombatSubstituteImpact( EQuickCombatSubstitute substitute );

function bool IsWaiting() {	return mIsWaiting; }
//function bool IsLastDefendTurn() { return mIsLastDefendTurn;}
function bool IsWaitTurn() { return mIsWaitTurn;}
function SetWaiting( bool isWaiting ) {	mIsWaiting = isWaiting; } 
function bool IsOverridenByAI() { return mOverrideWithAI; }
function SetOverrideByAI( bool val ) { mOverrideWithAI = val; }
function bool HasWaitClicked() { return mWaitClicked; }
function bool TriggerStartTurnEvents() { return mTriggerTurnStartEvents; }
function SetTriggerStartTurnEvents(bool should) { mTriggerTurnStartEvents = should; }

function H7BaseAbility GetPreparedAbility() { return mAbilityManager.GetPreparedAbility(); }
function PrepareAbility( H7BaseAbility ability ) 
{ 
	if(ability==None) return;
	if( ability.IsArchetype() )
	{
		mAbilityManager.PrepareAbility( mAbilityManager.GetAbility( ability ) ); 
	}
	else
	{
		mAbilityManager.PrepareAbility( mAbilityManager.GetAbilityByID( ability.GetID() ) ); 
	}
}
native function Vector GetLocation();

native function vector GetMeshCenter();
function vector GetHeightPos( float offset ){ return Vect( 0.f, 0.f, 0.f); }

native function SkeletalMeshComponent GetMeshComponent();

native function bool IsDead();

function bool       GetDoneForAI()              { return mIsDoneForAI; }
function            SetDoneForAI(bool val)      { mIsDoneForAI = val;  }

function bool IsAdditionalTurn() 
{ 
	return mIsAdditionalTurn;
}

function bool IsMoralTurn()
{
	return mIsMoralTurn;
}

function array<H7EffectContainer> GetEffectContainerForStat( EStat stat )
{
	local array<H7EffectContainer> container, foundContainer;
	local array<H7BaseAbility> abilities;
	local int i;

	if( mAbilityManager != none )
	{
		mAbilityManager.GetAbilities(abilities);
		container = abilities;
	}
	if( mBuffManager != none )
	{
		foundContainer = mBuffManager.GetBuffs();
	}

	for( i = 0; i < foundContainer.Length; ++i )
	{
		container.AddItem( foundContainer[i] );
	}

	foundContainer.Length = 0;

	for( i = 0; i < container.Length; ++i )
	{
		if( container[i].HasStatModFor( stat ) )
		{
			foundContainer.AddItem( container[i] );
		}
	}

	return foundContainer;
}

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	if( class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
	{
		EnableUnitSound(false);
	}
}

function RecalculatePostAnimInput()
{
	// This is done in H7Command.uc CommandFinish if wait for anim is turned off. To prevent
	// showing unnecessary grid highlights while waiting for animations, CommandFinish will skip this
	// and we update the grid here (so input + grid highlight will be activated at the same time).
	if( CanMakeAction() && H7CreatureStack( self ) != none )
	{
		class'H7CombatController'.static.GetInstance().GetGridController().CalculateReachableCellsFor( H7CreatureStack( self ), H7CreatureStack( self ).GetMovementPoints() );
		H7CreatureStack( self ).GetPathfinder().ForceUpdate();
	}

	// allow user input (don't care about other animations here; we're idling anyway)
	class'H7CombatController'.static.GetInstance().CalculateInputAllowed( false );
}

function bool MakeTurn(optional bool usedAttack = true, optional bool usedMove = true)
{
	//SetAdditionalTurn( true );
	SetCommandFinished( true );

	if( usedAttack ) UseAttack();
	if( usedMove ) UseMove();

	if( H7WarUnit( self ) != none && mAttackCount > 0 )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
	}

	ClearStatCache();
	return CanMakeAction();
}

function InitCurrentWave( H7Wave myWave, Vector startPos, Vector targetPos, array<H7IEffectTargetable> targets, H7BaseAbility source, bool rotateRandom )
{
	mWaveSource = source;
	mRotateRandom = rotateRandom;
	mCurrentWave = class'WorldInfo'.static.GetWorldInfo().Spawn( class'H7Wave', self,, startPos,, myWave); 
	mCurrentWave.InitWave( startPos, targetPos, targets, HitUnit, NextWaveStep);
}

// ---- ported from H7EffectSpecialTsunami ----
function NextWaveStep( array<H7CombatMapCell> cells ) 
{
	local int i,j,CreatureIndex;
	local CreaturePositon prev; 
	local IntPoint point;
	local array<IntPoint> shiftLine; 
	local Rotator rot;

	// is cell in colum 
	for ( j=0;j<cells.Length;++j)
	{

		// for every creature get a shift line  
		for( i=0;i< mCasualtyStacks.Length; ++i )
		{
			// find stack in preview
			CreatureIndex = mNewCreaturePosition.Find('Stack', mCasualtyStacks[i] );
			
			// shft creature
			if(CreatureIndex != INDEX_NONE ) 
			{
				prev = mNewCreaturePosition[CreatureIndex];
				shiftLine = prev.ShiftCells;
				point = cells[j].GetGridPosition();

				if( shiftLine.Find( 'X' ,point.X) != INDEX_NONE && shiftLine.Find( 'Y' ,point.Y ) != INDEX_NONE )  
				{
					mCasualtyStacks[i].GetMovementControl().LerpStackToLocation( cells[j].GetCenterByCreatureDim( mCasualtyStacks[i].GetUnitBaseSizeInt() ) );
					if(mRotateRandom)
					{
						rot = RotRand( false );
						rot.Pitch = 0.f;
						mCasualtyStacks[i].GetMovementControl().LerpStackToRotation( rot );
					}
				}
				// place if creature is at end pos
				if( prev.ToGridPosition == cells[j].GetGridPosition() )
				{
					prev.Stack.SetGridPosition( cells[j] .GetGridPosition() );
					cells[j].PlaceCreature(prev.Stack, false );
					mCasualtyStacks.RemoveItem(prev.Stack);
				}
			}
		}
	}
}

function HitUnit( H7IEffectTargetable target )
{
	local H7EventContainerStruct container;
	
	if( target == none ) return ;

	container.Targetable = target;
    container.ActionTag = mWaveSource.GetTags();
	container.ActionSchool = mWaveSource.GetSchool();
	container.EffectContainer = mWaveSource;

	target.TriggerEvents(ON_WAVE_IMPACT, false, container);
	mWaveSource.GetEventManager().Raise( ON_WAVE_IMPACT, false, container );

	WaveCatchCreatureStack( target );
}

function private WaveCatchCreatureStack( H7IEffectTargetable unit)
{
	local H7CreatureStack stack;

	if( unit == none ) return;

	if( H7CreatureStack( unit ) == none ) return; 

	stack = H7CreatureStack( unit );

	if( mNewCreaturePosition.Find('Stack', stack ) != INDEX_NONE) 
	{
		stack.RemoveCreatureFromCell();
		mCasualtyStacks.AddItem( stack );
	}
}

// --------------------------------------------

/**
 * Returns the world location of a socket. 
 * If no socket was found, returns world location of Unit.
 * 
 * @param socketName        Name of the socket
 * */
native function Vector GetSocketLocation( name socketName );


native function IntPoint GetGridPosition();

// shortcut for resistance to i.e. TAG_MORAL
function float GetResistanceModifierForTag(ESpellTag searchTag)
{
	local array<ESpellTag> tags;
	tags.AddItem(searchTag);
	return GetResistanceModifierFor(ALL,tags);
}

// checks all buffs and abilities of the creature to see if it is resistant/immune/vulnerable against the specified school and tags
native function float GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);

native function GetAllShieldEffects( out array<H7EffectSpecialShieldEffect> shieldEffects );

function ELuckType DoLuckRoll( H7EventContainerStruct container )
{
	local int luck;
	
	ClearStatCache();
	luck = GetDestiny();
	
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		luck = Clamp( luck, GetModifiedStatByID( STAT_LUCK_MIN ), GetModifiedStatByID( STAT_LUCK_CAP ) );
	}

	if( class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( 100 ) < Abs(luck) )
	{
		mLuckType = luck >= 0 ? GOOD_LUCK : BAD_LUCK;
		mLuckType == GOOD_LUCK ? TriggerEvents( ON_GOOD_LUCK, false, container ) : TriggerEvents( ON_BAD_LUCK, false, container );
	}
	else
	{
		mLuckType = NOTHING_LUCK;
	}
	;

	return mLuckType;
}

native function bool IsDefaultAttackActive();

/** @param forGUI if set true this function will return initiative without modifications from WaitBuff 
 */
function int GetInitiative() 
{
	 return GetModifiedStatByID(STAT_INITIATIVE); 
}

function int GetNextInitiative() 
{
	 return GetModifiedStatByID(STAT_INITIATIVE, true); 
}


//Base Stats
native function float GetBaseStatByID(Estat desiredStat);


function float IncreaseBaseStatByID( Estat desiredStat, optional int amount = 1 )
{
	local float actualchangedAmount;
	actualchangedAmount = amount; // unless overwritten otherwise
	switch(desiredStat)
	{
	case STAT_ATTACK: 
		mAttack += amount;
		break;
	case STAT_DEFENSE:
		mDefense += amount;
		break;
	case STAT_LUCK_DESTINY:
		mDestiny += amount; // cap at 100?
		break;
	case STAT_MORALE_LEADERSHIP:
		mLeadership += amount; // cap at 100?
		break;
	case STAT_MAX_MOVEMENT:
		mMovementPoints += amount;
		break;
	case STAT_MIN_DAMAGE:
		mMinimumDamage += amount;
		break;
	case STAT_MAX_DAMAGE:
		mMaximumDamage += amount;
		break;
	case STAT_INITIATIVE:
		mInitiative += amount;
		break;
	case STAT_ATTACK_COUNT:
		mAttackCount += amount;
		break;
	case STAT_MOVE_COUNT:
		mMoveCount += amount;
		break;
	case STAT_RANGE:
		mRange += amount;
		break;
	case STAT_FLANKING_MULTIPLIER_BONUS:
		mFlankingBonus += amount;
		break;
	case STAT_MAGIC_ABS:
		mMagicAbs += amount;
		break;
	default:
		;
		return 0;
		break;
	}
	ClearStatCache();
	return actualchangedAmount;
}

function DecreaseBaseStatByID( Estat desiredStat, optional int amount = 1 )
{
	switch(desiredStat)
	{
	case STAT_ATTACK: 
		mAttack = FClamp(mAttack - amount, 0, MaxInt);
		break;
	case STAT_DEFENSE:
		mDefense = FClamp(mDefense - amount, 0, MaxInt);
		break;
	case STAT_LUCK_DESTINY:
		mDestiny = FClamp(mDestiny - amount, 0, MaxInt);
		break;
	case STAT_MORALE_LEADERSHIP:
		mLeadership = FClamp(mLeadership - amount, 0, MaxInt);
		break;
	case STAT_MAX_MOVEMENT:
		mMovementPoints = FClamp(mMovementPoints - amount, 0, MaxInt);
		break;
	case STAT_MIN_DAMAGE:
		mMinimumDamage = FClamp(mMinimumDamage - amount, 0, MaxInt);
		break;
	case STAT_MAX_DAMAGE:
		mMaximumDamage = FClamp(mMaximumDamage - amount, 1, MaxInt);
		break;
	case STAT_INITIATIVE:
		mInitiative = FClamp(mInitiative - amount, 0, MaxInt);
		break;
	case STAT_ATTACK_COUNT:
		mAttackCount = FClamp(mAttackCount - amount, 0, MaxInt);
		break;
	case STAT_MOVE_COUNT:
		mMoveCount = FClamp(mMoveCount - amount, 0, MaxInt);
		break;
	case STAT_RANGE:
		mRange = FClamp(mRange - amount, 0, MaxInt);
		break;
	case STAT_FLANKING_MULTIPLIER_BONUS:
		mFlankingBonus = FClamp(mFlankingBonus - amount, 0, MaxInt);
		break;
	case STAT_MAGIC_ABS:
		mMagicAbs += FClamp(mMagicAbs - amount, 0, MaxInt);
		break;
	default:
		;
		break;
	}
	ClearStatCache();
}

// shows permanent modifications to stats in the log
function DisplayStatChangeLog(Estat stat,EOperationType op,float amount,optional H7EffectContainer source) // showchange displaychange
{
	local H7Message message;

	if(amount == 0) return;

	message = new class'H7Message';
	message.text = "MSG_GET_STAT"; // "Kalid gets +2 Mana because of Helm"
	message.mPlayerNumber = GetPlayer().GetPlayerNumber();
	message.AddRepl("%target",GetName());
	message.AddRepl("%value",class'H7GameUtility'.static.FloatToString(amount));
	message.AddRepl("%stat",class'H7EffectContainer'.static.GetLocaNameForStat(stat,self.IsA('H7EditorHero')));
	if(source != none) message.AddRepl("%origin",source.GetName());
	else message.AddRepl("%origin",class'H7Loca'.static.LocalizeSave("SOURCE_UNKNOWN","H7Abilities"));
	message.AddRepl("%operator",class'H7Effect'.static.GetOperationString(op,amount));
	message.destination = MD_LOG;
	message.settings.referenceObject = self;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
}

// shows permanent modifications to stats as floating text
function DisplayStatChangeFloat(Estat stat,EOperationType op,float amount,optional H7EffectContainer source) 
{
	local H7Message message;

	if(amount == 0) return;

	message = new class'H7Message';
	message.text = "%op%i %s"; // "+2 Mana"
	message.AddRepl("%i",class'H7GameUtility'.static.FloatToString(amount));
	message.AddRepl("%s",class'H7EffectContainer'.static.GetLocaNameForStat(stat,self.IsA('H7EditorHero')));
	message.AddRepl("%op",class'H7Effect'.static.GetOperationString(op,amount));
	message.destination = MD_FLOATING;
	message.settings.icon = class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().mStatIcons.GetStatIcon(stat);
	message.settings.floatingType = FCT_STAT_MOD;
	message.settings.referenceObject = self;
	message.settings.preventHTML = true;
	message.settings.color = MakeColor(255,255,255,255);
	message.settings.floatingLocation = GetTargetLocation(); // OPTIONAL better location for floating texts?
	if(source != none) message.mPlayerNumber = source.GetCaster().GetPlayer().GetPlayerNumber();
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
}

native function SetBaseStatByID( Estat desiredStat, int newValue );

native function float GetModifiedStatByID(Estat desiredStat, optional bool nextRound = false );

/** @param desiredStat Stat that will be affected
 *  @return Sum of additive modifications, coming from abilities, buffs etc.
 */
native function float GetAddBoniOnStatByID(Estat desiredStat, optional bool nextRound = false );

/** @param desiredStat Stat that will be affected
 *  @return Sum of percentages in modifications, where 50% extra means 1.5f
 */
native function float GetMultiBoniOnStatByID(Estat desiredStat, optional bool nextRound = false );

native function H7Player GetPlayer();

function SetInitiative(int val) {mInitiative = val;}

function Init( optional bool fromSave )
{
	mAbilityManager = new(self) class 'H7AbilityManager';
	mBuffManager = new(self) class 'H7BuffManager';
	mEventManager = new(self) class 'H7EventManager';
	mEffectManager = new(self) class 'H7EffectManager'();
	mEffectManager.Init( self );
	mBuffManager.Init( self );

	if( !fromSave )
	{
		mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
		class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self );
	}

	// targeting stuff (not for heroes, since they have their own collider, and not for creatures, since creaturestack has the valid collider)
	if( H7EditorHero( self ) == none && H7Creature( self ) == none )
	{
		mCollider = new( self ) class'CylinderComponent';
		mCollider.SetCylinderSize( 27.f, 59.f );
		mCollider.SetTraceBlocking(true, true);
		CollisionComponent = mCollider;
		AttachComponent( mCollider );
	}

	mGridPos.Y = -1;
	mGridPos.X = -1;


	mCombatCtrl = class'H7CombatController'.static.GetInstance();
}

simulated event Destroyed()
{
	CleanupEmitterPools();

	super.Destroyed();

	if( mID != 0 )
	{
		class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( self );
	}
}

native function TriggerEvents(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container);


function BeginAction()
{
    if( GetBuffManager().HasBuff( class'H7BuffManager'.static.GetMoralBuff(self), none, false) )
	{
		TriggerEvents( ON_MORAL_TURN_START, false );
		//SetMoralTurn ( true );
	}

	ResetPreparedAbility();	
}

function bool BeginTurn()
{
	local H7CombatController combatController;
	local array<H7BaseBuff> buffsFromWait;

	SetKillsOnCurrentTurn( 0 );

	//if( GetBuffManager().HasBuff( class'H7BuffManager'.static.GetDefendBuff(self), none, false) ) {	mIsLastDefendTurn = true;  }
	//else                                                                             {	mIsLastDefendTurn = false; }


	mIsWaitTurn = GetBuffManager().HasBuff( class'H7BuffManager'.static.GetWaitBuff(self), none, false);

	// now its your turn -> no waiting
	// reset waiting status
	mIsWaiting = false;
	mSkipTurn = false;
	mHasBadMoral = false;

	// we Raised this event once, we dont want to do it twice
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		combatController = class'H7CombatController'.static.GetInstance();
		if( !mIsWaitTurn ) 
		{
			if(mTriggerTurnStartEvents)
			{
				mTriggerTurnStartEvents = false; // make sure this stuff doesn't trigger twice
				combatController.RaiseEvent( ON_BEGIN_OF_EVERY_UNITS_TURN );
				TriggerEvents( ON_UNIT_TURN_START, false );
			}
		}
		else
		{
			// kill the wait buff (fucker won't expire correctly: ON_UNIT_TURN_START can't be triggered on wait turn bc that
			// would fuck up other buff; and ON_UNIT_TURN_END is the moment the buff is added to the creature)
			GetBuffManager().GetBuffsFromSource( buffsFromWait, GetWaitAbility() );
			if( buffsFromWait.Length > 0 )
			{
				buffsFromWait[0].SetCurrentDuration( 0, false );
				GetBuffManager().RemoveBuff( buffsFromWait[0], self,, true);
			}

			combatController.GetGridController().RecalculateReachableCells();
		}
	}
	

	// it's a combatmap and no morale turn?  + we did it before wait so dont do it again
	if( combatController != none && !mIsWaiting)
	{
		if( self.IsA('H7CreatureStack') && !H7CreatureStack( self ).IsOffGrid() && H7CreatureStack( self ).DoMoralRoll() == BAD_MORALE) 
		{
			//class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateSkip( self );
			mHasBadMoral = true;
			class'H7CombatController'.static.GetInstance().StartBadMoraleDelay();
			TriggerEvents( ON_BAD_MORAL, false );
		}
	}

	mTriggerTurnEndEvents = true;
	mLastPath.Length = 0;
	
	ResetPreparedAbility();

	return true;
}

function EndAction()
{
	SetCommandFinished( false );
}

function BeforeEndTurn()
{
	local H7CombatController combatController;
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		combatController = class'H7CombatController'.static.GetInstance();
	}

	// DONT DO IT ON MORALE TURN
	if( combatController.GetCombatConfiguration().mMoralOnAdditionalTurns || !IsAdditionalTurn() )
	{
		// DONT DO IT ON WAIT & DEFENSE
		if( ( !IsWaiting() || !IsWaitTurn() ) && ( !GetBuffManager().HasBuff( class'H7BuffManager'.static.GetDefendBuff( self ), none, false ) ) )
		{
			if( self.IsA('H7CreatureStack') && !H7CreatureStack( self ).IsOffGrid() && H7CreatureStack( self ).DoMoralRoll() == GOOD_MORALE )
			{
				SetAdditionalTurn(true);
				SetMoralTurn ( true );
				ClearStatCache();
				ResetLuckType();
				TriggerEvents( ON_GOOD_MORAL, false );
				// trigger only for friendly creatures and army hero (else, the Solidarity skill will crap out)
				combatController.RaiseEvent( ON_ANY_GOOD_MORAL,false, GetCombatArmy() );
			}
		}
	}
	else if ( IsAdditionalTurn() )
	{
		SetAdditionalTurn ( false );
	}

	if( H7CreatureStack( self ) != none && H7CreatureStack( self ).HasDelayedCommand() )
	{
		++mMoveCount;
		H7CreatureStack( self ).StartDelayedCommand();
	}
}


function EndTurn()
{
	// END TURN raised on every creature, this creature has finished its turn
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() && H7CreatureStack( self ) != none && mTriggerTurnEndEvents )
	{
		class'H7CombatController'.static.GetInstance().RaiseEvent( ON_END_OF_EVERY_CREATURES_TURN ); // TODO trigger on moral turn??
	}

	// trigger this also on morale turns (won't be triggered before since the unit
	// won't call this when having good morale)
	if( mTriggerTurnEndEvents )
		TriggerEvents( ON_UNIT_TURN_END, false );
	
	// now we are sure that we cant make anymore actions
	// don't raise this event when waiting because buff might disappear
	if(IsMoralTurn())
	{
		TriggerEvents( ON_MORAL_TURN_END, false );
		SetMoralTurn(false);
		SetAdditionalTurn(false);
	}
	
	mTriggerTurnStartEvents = true;
	mTriggerTurnEndEvents = false;

	SetIgnoreAllegiances(false);
}

function Defend() {}

function bool CanDefend() { return false; }

function H7BaseAbility GetSkipTurnAbility()
{
	return none;
}

function Wait()
{
	local array<H7Command> commands;

	if( !mIsWaitTurn )
	{
		commands = class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().GetCmdsForCaster( self );
		if( !GetPreparedAbility().IsEqual( GetWaitAbility() ) && commands.Length == 0 )
		{
			PrepareAbility( mAbilityManager.GetAbility( GetWaitAbility() ) );
			class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_UsePreparedAbility( self ); 
		}
	}
}

function UsePreparedAbility( H7IEffectTargetable target )
{
	local H7BaseGameController bgController;

	bgController = class'H7BaseGameController'.static.GetBaseInstance();
	bgController.GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( self, UC_ABILITY, ACTION_ABILITY, GetPreparedAbility(), target ) );
}

function ResetPreparedAbility()
{ 
	if( HasPreparedAbility() )
	{
		if( !IsCasting() )
		{
			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				if( class'H7CombatController'.static.GetInstance().GetCommandQueue().IsEmpty() )
				{
					class'H7CombatMapGridController'.static.GetInstance().SelectUnit( self, true );
				}
				class'H7CombatController'.static.GetInstance().RefreshAllUnits();
				if( GetPreparedAbility().IsTeleportSpell() )
				{
					class'H7CombatController'.static.GetInstance().TeleportSpellWasCanceled();
				}
				// go back to default attack
				PrepareDefaultAbility();
			}
			else
			{
				GetAbilityManager().PrepareAbility( none );
			}
		}
		else
		{
			;
			scripttrace();
		}
	}
	else
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			if( class'H7CombatController'.static.GetInstance().GetCommandQueue().IsEmpty() )
			{
				class'H7CombatMapGridController'.static.GetInstance().SelectUnit( self, true );
			}
			class'H7CombatController'.static.GetInstance().RefreshAllUnits();
			PrepareDefaultAbility();
		}
		else
		{
			GetAbilityManager().PrepareAbility( none );
		}
	}
}

function PrepareDefaultAbility()
{
	local bool canRangeAttack;
	local array<H7CombatMapCell> dummyArray;
	dummyArray.Length = 0;

	canRangeAttack = true;
	if( self.IsA( 'H7CreatureStack' ) )
	{
		canRangeAttack = !class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().HasAdjacentCreature( self, none, true, dummyArray ) 
					  && H7CreatureStack(self).GetAttackRange() > 0 
					  && GetRangedAttackAbility() != none
					  && !GetAbilityManager().GetAbility(GetRangedAttackAbility()).IsSuppressed();
	}

	if( H7WarUnit( self ) != none )
	{
		// warunits do their own stuff, so let them figure it out themselves
		H7WarUnit( self ).PrepareDefaultAbility();
	}
	else if( GetRangedAttackAbility() != none && canRangeAttack )
	{
		if ( GetAbilityManager().GetAbility( GetRangedAttackAbility() ).CanCast() )
		{
			PrepareAbility( GetRangedAttackAbility() );
		}
		else 
		{
			if ( GetAbilityManager().GetAbility(GetMeleeAttackAbility()) != None && GetAbilityManager().GetAbility(GetMeleeAttackAbility() ).CanCast() )
			{
				PrepareAbility( GetMeleeAttackAbility() );
			}
			else 
			{
				GetAbilityManager().PrepareAbility( none );
			}
		}
	}
	else
	{
		if ( GetAbilityManager().GetAbility(GetMeleeAttackAbility()) != None && GetAbilityManager().GetAbility(GetMeleeAttackAbility() ).CanCast() )
		{
			PrepareAbility( GetMeleeAttackAbility() );
		}
		else
		{
			GetAbilityManager().PrepareAbility( none );
		}
	}
}

function ShowFloatingText( string text )
{
	class'H7FCTController'.static.GetInstance().startFCT( FCT_TEXT, GetHeightPos( 50.f ), GetPlayer(), text, MakeColor(0,0,255,255) );
}

function EndMoving( optional bool ignoreTargetNotReachedMessage = true ) { }

function DataChanged(optional String cause)
{
	class'H7ListeningManager'.static.GetInstance().DataChanged( self );
}

function StatusChanged()
{
	if( class'H7CombatMapGridController'.static.GetInstance() != none )
	{
		class'H7CombatMapGridController'.static.GetInstance().SetDecalDirty( true );
	}
	mDoStatusCheck = true;
}

function IsUnderAttack(bool isSimulated)
{
	if(!isSimulated)
	{
		StatusChanged();
	}
}

function EnableUnitSound(bool enable)
{
	//For disabling the particular unit sounds of this actor
	if( class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
	{
		enable = false;
	}

	if(enable)
	{
		//The sound for this actor is set in wwise to the soundcontrollers value
		SetRTPCValue ('Actor_Volume', 100.f);
	}
	else
	{
		//The sound for this actor is set in wwise to 0
		SetRTPCValue ('Actor_Volume', 0.f);
	}
}

function EnableUnitMoveSound(bool enable)
{
	//For timed disabled move sounds -> called over AnimControl

	if(enable)
	{
		SetRTPCValue ('Movement_Volume', 100.f);

	}
	else
	{
		SetRTPCValue ('Movement_Volume', 0.f);
	}
}

function array<H7StatModSource> GetStatModSourceList( EStat stat ) 
{
	local array<H7StatModSource> allMods;
	local array<H7MeModifiesStat> mods;
	local H7StatModSource statModSource;

	// TODO handle set

	GetModifiersByID(mods, stat,OP_TYPE_ADD); // this call is to trigger the calculation and fill mStatModSourceBuffer
	allMods = mStatModSourceBuffer;

	GetModifiersByID(mods, stat,OP_TYPE_ADDPERCENT,OP_TYPE_MULTIPLY); // this call is to trigger the calculation and fill mStatModSourceBuffer

	if(stat == STAT_MORALE_LEADERSHIP && self.IsA('H7CreatureStack'))
	{
		foreach mStatModSourceBuffer(statModSource)
		{
			allMods.AddItem(statModSource);
			;
		}
		H7CreatureStack(self).GetMorale(); // this call is to trigger the calculation and fill mStatModSourceBuffer
	}
	else if((stat == STAT_MAX_DAMAGE || stat == STAT_MIN_DAMAGE) && self.IsA('H7CreatureStack'))
	{
		statModSource.mMod.mModifierValue = H7CreatureStack(self).GetStackSize();
		statModSource.mMod.mCombineOperation = OP_TYPE_MULTIPLY;
		statModSource.mSourceName = class'H7Loca'.static.LocalizeSave("TT_STACKSIZE","H7General");
		mStatModSourceBuffer.AddItem(statModSource);
	}

	foreach mStatModSourceBuffer(statModSource)
	{
		allMods.AddItem(statModSource);
		;
	}
	return allMods;
}

function ECommandTag GetActionID( H7BaseAbility ability )
{
	if( ( ability.IsEqual( GetRangedAttackAbility() ) || ability.IsEqual( GetMeleeAttackAbility() ) ) )
	{
		if( !ability.IsRanged() )
		{
			return ACTION_MELEE_ATTACK;
		}
		else
		{
			return ACTION_RANGE_ATTACK;
		}
	}
	else
	{
		return ACTION_ABILITY;
	}
}

native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType exclusiveFirstOT = -1, optional EOperationType exclusiveSecondOT = -1, optional bool nextRound);
native function ClearStatCache();

//function Tick( float DeltaTime )
//{
//	ClearStatCache();
//	if( H7AdventureHero( self ) != none && ( !(WorldInfo.TimeSeconds - LastRenderTime < 1.5f ) || bHidden ) )
//	{
//		return;
//	}

//	super.Tick( DeltaTime );

//	if (mEffectManager != none )
//	{
//		mEffectManager.Update();
//	}
//}

function bool MPIsYourTurn()
{
	if( !WorldInfo.GRI.IsMultiplayerGame() )
	{
		return true;
	}
	
	if( class'H7CombatController'.static.GetInstance().GetActiveUnit() == none )
	{
		return false;
	}

	// check if its your turn on multiplayer games 
	return  class'H7CombatController'.static.GetInstance().GetActiveUnit().GetCombatArmy().IsOwnedByPlayerMP();
}

native function int GetMovementPoints();

function int GetMovementPointsBase() { return mMovementPoints; }

function  SetSubstituteLuckAbilty( H7BaseAbility ability )        
{
	if( mSubstituteLuckAbility != none )
	{
		if( mAbilityManager != none )
		{
			mAbilityManager.UnlearnAbility( mSubstituteLuckAbility );
		}
	}

	mSubstituteLuckAbility = ability; 
}

function H7BaseAbility GetLuckAbility()                        
{
	if( mSubstituteLuckAbility != none )
	{
		return mSubstituteLuckAbility;
	}
	return mLuckAbility; 
}

function bool IsMyDefaultAbility(H7BaseAbility ability)
{
	if(ability == none) return false;

	return mLuckAbility != none && ability.IsEqual(mLuckAbility) || mMeleeAttackAbilityTemplate != none && ability.IsEqual(mMeleeAttackAbilityTemplate)
		|| mRangedAttackAbilityTemplate != none && ability.IsEqual(mRangedAttackAbilityTemplate) || mWaitAbility != none && ability.IsEqual(mWaitAbility);
}

// overrideable
function Think(){}

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function JSonObject Serialize()
{
	local JSonObject JSonObject;
	
	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	if (JSonObject == None)
	{
		;
		return JSonObject;
	}

	JSonObject.SetIntValue( "Id", mID );
	JSonObject.SetIntValue( "Initiative", mInitiative );
	JSonObject.SetIntValue( "Attack", mAttack );
	JSonObject.SetIntValue( "Defense", mDefense );
	JSonObject.SetIntValue( "Leadership", mLeadership );
	JSonObject.SetIntValue( "Destiny", mDestiny );
	JSonObject.SetIntValue( "MinimumDamage", mMinimumDamage );
	JSonObject.SetIntValue( "MaximumDamage", mMaximumDamage );
	JSonObject.SetIntValue( "MovementPoints", mMovementPoints );

	// Send the encoded JSonObject
	return JSonObject;
}

/**
 * Deserializes the actor from the data given
 *
 * @param    Data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data)
{
	mID = Data.GetIntValue("Id");
	mInitiative = data.GetIntValue("Initiative");
	mAttack = data.GetIntValue("Attack");
	mDefense = data.GetIntValue("Defense");
	mLeadership = data.GetIntValue("Leadership");
	mDestiny = data.GetIntValue("Destiny");
	mMinimumDamage = data.GetIntValue("MinimumDamage");
	mMaximumDamage = data.GetIntValue("MaximumDamage");
	mMovementPoints = data.GetIntValue("MovementPoints");
}

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame){}

function DoDeathMaterialEffectFading(array<H7DeathMaterialEffect> deathMaterialEffects, optional array<MaterialInstanceConstant> unitMaterials)
{
	local int i, j;
	local Float CurrValue;
	local LinearColor CurrValueLinCol;
	local bool bPendingEffects;
	local name MaterialParam;
	local bool IsColor;

	// operate on all the death material effects
	for (i = 0; i < deathMaterialEffects.Length; i++)
	{
		IsColor = false;
		// wait for the time to start
		if (WorldInfo.TimeSeconds >= deathMaterialEffects[i].EffectStartingTime + deathMaterialEffects[i].EffectTime)
		{
			if (deathMaterialEffects[i].MaterialParamName == EMP_Emissive)
			{
				MaterialParam = 'EmissiveColor_Global';
				IsColor = true;
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_Opacity)
			{
				MaterialParam = 'Opacity_Global';
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_Spec)
			{
				MaterialParam = 'SpecMul_Global';
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_SpecPow)
			{
				MaterialParam = 'SpecPowMul_Global';
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_Diffuse)
			{
				MaterialParam = 'DiffColor_Global';
				IsColor = true;
			}

			if(unitMaterials.Length > 0)
			{
				// operate on all of the creature's materials
				for (j = 0; j < unitMaterials.Length; j++)
				{
					if (!IsColor)
					{
						unitMaterials[j].GetScalarParameterValue(MaterialParam, CurrValue);
						if (CurrValue > 0.0f)
						{
							// reduce the param by 5% every time: enough for a smooth transition
							unitMaterials[j].SetScalarParameterValue(MaterialParam, CurrValue - 0.05f);
							bPendingEffects = true;
						}
					}
					else
					{
						unitMaterials[j].GetVectorParameterValue( MaterialParam, CurrValueLinCol );

						if( CurrValueLinCol.A < 1.0f )
						{
							CurrValueLinCol.A = CurrValueLinCol.A + 0.05f;
							CurrValueLinCol.R = CurrValueLinCol.R - 0.05f;
							CurrValueLinCol.B = CurrValueLinCol.B - 0.05f;
							CurrValueLinCol.G = CurrValueLinCol.G - 0.05f;
							bPendingEffects = true;
						}

						unitMaterials[j].SetVectorParameterValue( MaterialParam, CurrValueLinCol );
					}
				}
			}
		}
		// make sure if our effect hasn't started make sure we don't end the loop
		else
		{
			bPendingEffects = true;
		}
	}

	// if we're done with all the effects, kill the loop
	if (!bPendingEffects)
	{
		ClearTimer('PlayDeathMaterialEffects');
	}
}

function UndoDeathMaterialFX(array<H7DeathMaterialEffect> deathMaterialEffects, optional array<MaterialInstanceConstant> unitMaterials)
{
	local int i, j;
	local Float CurrValue;
	local LinearColor CurrValueLinCol;
	local bool bPendingEffects;
	local name MaterialParam;
	local bool IsColor;

	// operate on all the death material effects
	for (i = 0; i < deathMaterialEffects.Length; i++)
	{
		IsColor = false;
		// wait for the time to start
		if (WorldInfo.TimeSeconds >= deathMaterialEffects[i].EffectStartingTime + deathMaterialEffects[i].EffectTime)
		{
			if (deathMaterialEffects[i].MaterialParamName == EMP_Emissive)
			{
				MaterialParam = 'EmissiveColor_Global';
				IsColor = true;
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_Opacity)
			{
				MaterialParam = 'Opacity_Global';
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_Spec)
			{
				MaterialParam = 'SpecMul_Global';
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_SpecPow)
			{
				MaterialParam = 'SpecPowMul_Global';
			}
			else if (deathMaterialEffects[i].MaterialParamName == EMP_Diffuse)
			{
				MaterialParam = 'DiffColor_Global';
				IsColor = true;
			}

			if(unitMaterials.Length > 0)
			{
				// operate on all of the creature's materials
				for (j = 0; j < unitMaterials.Length; j++)
				{
					if (!IsColor)
					{
						unitMaterials[j].GetScalarParameterValue(MaterialParam, CurrValue);
						if (CurrValue < 1.0f)
						{
							// increase the param by 5% every time: enough for a smooth transition
							unitMaterials[j].SetScalarParameterValue(MaterialParam, CurrValue + 0.05f);
							bPendingEffects = true;
						}
					}
					else
					{
						unitMaterials[j].GetVectorParameterValue( MaterialParam, CurrValueLinCol );

						if( CurrValueLinCol.A > 0.0f )
						{
							CurrValueLinCol.A = CurrValueLinCol.A - 0.05f;
							CurrValueLinCol.R = CurrValueLinCol.R + 0.05f;
							CurrValueLinCol.B = CurrValueLinCol.B + 0.05f;
							CurrValueLinCol.G = CurrValueLinCol.G + 0.05f;
							bPendingEffects = true;
						}
						unitMaterials[j].SetVectorParameterValue( MaterialParam, CurrValueLinCol );
					}
				}
			}
		}
		// make sure if our effect hasn't started make sure we don't end the loop
		else
		{
			bPendingEffects = true;
		}
	}

	// if we're done with all the effects, kill the loop
	if (!bPendingEffects)
	{
		ClearTimer('PlayDeathMaterialEffects');
	}
}

simulated function UpdateParticleTranslucency( ParticleSystemComponent PSC )
{
	// overloaded by children
}

// We override and copy the SkeletalMesh version of this PlayParticleEffect so we can store on this skeletal mesh the particles that uses the skeletalmesh component.
// We can then cleanup them when this actor is destroyed in CleanupEmitterPools so it avoid an engine assert that uses the destroyed skeletalmesh component.
event bool PlayParticleEffect( const AnimNotify_PlayParticleEffect AnimNotifyData )
{
	local vector Loc;
	local rotator Rot;
	local ParticleSystemComponent PSC;
	local bool bPlayNonExtreme;
	local EmitterSpawnable emitterActor;

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		;
		return true;
	}

	// should I play non extreme content?
	bPlayNonExtreme = ( AnimNotifyData.bIsExtremeContent == TRUE ) && ( WorldInfo.GRI.ShouldShowGore() == FALSE ) ;

	// if we should not respond to anim notifies OR if this is extreme content and we can't show extreme content then return
	if( ( bShouldDoAnimNotifies == FALSE )
		// if playing non extreme but no data is set, just return
		|| ( bPlayNonExtreme && AnimNotifyData.PSNonExtremeContentTemplate==None )
		)
	{
		// Return TRUE to prevent the SkelMeshComponent from playing it as well!
		return true;
	}

	// now go ahead and spawn the particle system based on whether we need to attach it or not
	if( AnimNotifyData.bAttach == TRUE )
	{
		PSC = new(self) class'ParticleSystemComponent';  // move this to the object pool once it can support attached to bone/socket and relative translation/rotation
		if ( bPlayNonExtreme )
		{
			PSC.SetTemplate( AnimNotifyData.PSNonExtremeContentTemplate );
		}
		else
		{
			PSC.SetTemplate( AnimNotifyData.PSTemplate );
		}

		if( AnimNotifyData.SocketName != '' )
		{
			SkeletalMeshComponent.AttachComponentToSocket( PSC, AnimNotifyData.SocketName );
		}
		else if( AnimNotifyData.BoneName != '' )
		{
			SkeletalMeshComponent.AttachComponent( PSC, AnimNotifyData.BoneName );
		}
		else if( SkeletalMeshComponent.GetBoneName(0) != '' ) // LIMBIC
		{
			SkeletalMeshComponent.AttachComponent( PSC, SkeletalMeshComponent.GetBoneName(0) );
		}

		UpdateParticleTranslucency(PSC);

		PSC.ActivateSystem();
		PSC.OnSystemFinished = OnPooledAttachedParticleSystemFinished;

		AllocatePooledEmitter(PSC);
	}
	else
	{
		// find the location
		if( AnimNotifyData.SocketName != '' )
		{
			SkeletalMeshComponent.GetSocketWorldLocationAndRotation( AnimNotifyData.SocketName, Loc, Rot );
		}
		else if( AnimNotifyData.BoneName != '' )
		{
			Loc = SkeletalMeshComponent.GetBoneLocation( AnimNotifyData.BoneName );
			Rot = QuatToRotator(SkeletalMeshComponent.GetBoneQuaternion(AnimNotifyData.BoneName));
		}
		else
		{
			Loc = Location;
			Rot = rot(0,0,1);
		}

		//PSC = WorldInfo.MyEmitterPool.SpawnEmitter( AnimNotifyData.PSTemplate, Loc,  Rot); // these fail to be GC'd if they use SkelVertSurf. using an Emitter actor now instead
		emitterActor = Spawn(class'EmitterSpawnable', self,, Loc, Rot,, false);
		if (emitterActor != None)
		{
			emitterActor.SetTickIsDisabled(false);
			emitterActor.SetDrawScale(DrawScale);
			emitterActor.SetDrawScale3D(DrawScale3D);
			PSC = emitterActor.ParticleSystemComponent;
		}

		if (PSC != None)
		{
			if ( bPlayNonExtreme )
			{
				PSC.SetTemplate( AnimNotifyData.PSNonExtremeContentTemplate );
			}
			else
			{
				PSC.SetTemplate( AnimNotifyData.PSTemplate );
			}

			PSC.SetScale(SkeletalMeshComponent.Scale);
			PSC.SetScale3D(SkeletalMeshComponent.Scale3D);

			UpdateParticleTranslucency(PSC);
		}
	}

	if( PSC != None && AnimNotifyData.BoneSocketModuleActorName != '' )
	{
		PSC.SetActorParameter(AnimNotifyData.BoneSocketModuleActorName, self);
	}

	return true;
}

simulated function AllocatePooledEmitter( ParticleSystemComponent PSC )
{
	local int i;

	for (i = 0; i < mEmitterPoolParticleComps.Length; ++i)
	{
		if (mEmitterPoolParticleComps[i] == None)
		{
			mEmitterPoolParticleComps[i] = PSC;
			return;
		}
	}

	mEmitterPoolParticleComps.AddItem(PSC);
}

simulated function OnPooledAttachedParticleSystemFinished( ParticleSystemComponent PSC )
{
	SkelMeshActorOnParticleSystemFinished(PSC);
	RecyclePooledEmitter(PSC);
}

simulated function RecyclePooledEmitter( ParticleSystemComponent PSC )
{
	local int poolIndex;
	
	poolIndex = mEmitterPoolParticleComps.Find(PSC);
	if (mEmitterPoolParticleComps.Find(PSC) != INDEX_NONE)
	{
		mEmitterPoolParticleComps[poolIndex].CleanupEmitters();
		mEmitterPoolParticleComps[poolIndex].DeactivateSystem();
		mEmitterPoolParticleComps[poolIndex] = None;
	}
}

function CleanupEmitterPools()
{
	local ParticleSystemComponent PSC;
	foreach mEmitterPoolParticleComps(PSC)
	{
		PSC.CleanupEmitters();
		PSC.DeactivateSystem();
	}
	mEmitterPoolParticleComps.Length = 0;
}

function ChangeUnitAnimationSoundSpeed(optional float additionalSpeedMod)
{
		local float animSpeed, gameSpeed, finalSpeed;

		animSpeed = self.CustomTimeDilation;
		gameSpeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();

		finalSpeed = gameSpeed * animSpeed;

		if(additionalSpeedMod == 0.f)
		{
			//For this specific creature the sfx speed
			SetRTPCValue('Game_Speed', finalSpeed * (100 + mAnimSoundSpeedManipulator));
		}
		else
		{
			animSpeed = self.CustomTimeDilation * additionalSpeedMod;
			SetRTPCValue('Game_Speed', finalSpeed * (100 + mAnimSoundSpeedManipulator));
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

