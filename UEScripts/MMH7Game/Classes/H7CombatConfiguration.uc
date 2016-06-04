//=============================================================================
// H7CombatConfiguration
//=============================================================================
// 
// class for configurations on the combat map
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CombatConfiguration extends Actor
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	native;

//Cap for Luck maximum
var( Luck ) private int mLuckMax<DisplayName=Luck Maximum|ClampMin=-100|ClampMax=100>;
//Cap for Luck minimum
var( Luck ) private int mLuckMin<DisplayName=Luck Minimum|ClampMin=-100|ClampMax=100>;



//Cap for Morale maximum
var( Morale ) private int mMoraleMax<DisplayName=Morale Maximum|ClampMin=-100|ClampMax=100>;
//Cap for Morale minimum
var( Morale ) private int mMoraleMin<DisplayName=Morale Minimum|ClampMin=-100|ClampMax=100>;
// Additional morale if all units of the army are from the same faction
var( Morale ) private int mMoraleBuffSameFactionUnits<DisplayName=Additional morale when only one faction|ClampMin=-50|ClampMax=50>;
// Morale handicap if there are enemy factions in one army
var( Morale ) private int mMoraleDebuffEnemyFactionUnits<DisplayName=Morale handicap when enemy factions|ClampMin=-50|ClampMax=50>;
// Morale handicap if there are two or more allied factions in one army
var( Morale ) private int mMoraleDebuffAlliedFactionUnits<DisplayName=Morale handicap when to many allied factions|ClampMin=-50|ClampMax=50>;
// Morale handicap in every other case
var( Morale ) private int mMoraleDebuffOtherCase<DisplayName=Morale handicap in other cases|ClampMin=-50|ClampMax=50>;
// Make Moral and Luck rolls on additional turns
var( Morale ) protectedwrite bool mMoralOnAdditionalTurns<DisplayName=Use Moral on additional turns>;
// Delay the turn skip for units with bad morale by seconds
var( Morale ) protectedwrite float mBadMoraleWaitTime<DisplayName=Bad Morale Wait Time>;

// The name of the Kismet-ParentSequence which holds the Kismet-Ai
var(AI) protectedwrite H7AiCombatMapConfig           mAiCombatMapConfig;

/** If Creature Stacks in the combatmap should be represented by groups of creatures */
var(FX) protected bool mUsePlatoonStacks<DisplayName=Use Platoon Stacks>;

var(FX) protected float mMaxWaitTimeParticles<DisplayName=Continue Gameplay While Waiting for Particle Effect After this Time (Seconds)|TooltipText=Will be used if the particle effect is longer than this amount of seconds and "Gameplay Waits for Animation" is active.>;

var(CoverSystem) protectedwrite float mCoverDamageReduction<DisplayName=Cover damage reduction>;
var(CoverSystem) protected bool mShowCoverSystemDebug<DisplayName=Show debug>;

var(SiegeMap) protectedwrite H7SiegeTownData mSiegeTownData<DisplayName=Siege town data>;
var(SiegeMap) protected int mSiegeDefaultLocalGuard<DisplayName=Default Local Guard Slots>;;

var(DamageCalculation) float  FULL_RANGE_MODIFIER;
var(DamageCalculation) float  HALF_RANGE_MODIFIER;
var(DamageCalculation) float  MELEE_PENALTY_MODIFIER;
var(DamageCalculation) float  HIGHER_ATTACK_VALUE_SCALAR;
var(DamageCalculation) float  LOWER_ATTACK_VALUE_SCALAR;
var(DamageCalculation) float  MIN_ATTACK_MODIFIER_CAP;
var(DamageCalculation) float  MAX_ATTACK_MODIFIER_CAP;

var(Metamagic) int mMetamagicMax;

//getter
function int	GetLuckMax()                            { return mLuckMax; }
function int	GetLuckMin()                            { return mLuckMin; }
function int	GetMoraleMax()                          { return mMoraleMax; }
function int	GetMoraleMin()                          { return mMoraleMin; }
function int	GetMoraleBuffSameFactionUnits()         { return mMoraleBuffSameFactionUnits; }
function int	GetMoraleDebuffEnemyFactionUnits()      { return mMoraleDebuffEnemyFactionUnits; }
function int	GetMoraleDebuffAlliedFactionUnits()     { return mMoraleDebuffAlliedFactionUnits; }
function int	GetMoraleDebuffOtherCase()              { return mMoraleDebuffOtherCase; }
function int	GetDefaultLocGuardSlots()               { return mSiegeDefaultLocalGuard;}
function int	GetMetamagicMax()                       { return mMetamagicMax; }
function bool	IsUsingPlatoonStacks()                  { return mUsePlatoonStacks; }
function bool	IsShowCoverSystemDebug()	            { return mShowCoverSystemDebug; }
function float  GetMaxParticleWaitTime()                { return mMaxWaitTimeParticles; }

//setter
function SetLuckMax( int luckMax )                                              { mLuckMax = luckMax; }
function SetLuckMin( int luckMin )                                              { mLuckMin = luckMin; }
function SetMoraleMax( int moraleMax )                                          { mMoraleMax = moraleMax; }
function SetMoraleMin( int moraleMin )                                          { mMoraleMin = moraleMin; }

function SetMoraleBuffSameFactionUnits ( int moraleBuffSameFactionUnits )       { mMoraleBuffSameFactionUnits = moraleBuffSameFactionUnits; }
function SetMoraleDebuffEnemyFactionUnits ( int moraleDebuffEnemyFactionUnits ) { mMoraleDebuffEnemyFactionUnits = moraleDebuffEnemyFactionUnits; }
function SetMoraleDebuffAlliedFactionUnits ( int moraleDebuffAlliedFactionUnits){ mMoraleDebuffAlliedFactionUnits = moraleDebuffAlliedFactionUnits; }
function SetMoraleDebuffOtherCase ( int moraleDebuffOtherCase)                  { mMoraleDebuffOtherCase = moraleDebuffOtherCase; }

