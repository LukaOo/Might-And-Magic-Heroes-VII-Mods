//=============================================================================
// H7CreatureVisuals
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureVisuals extends Object
	native;


var(Visuals) protected SkeletalMeshComponent		        mSkeletalMesh<DisplayName=Skeletal Mesh>;
var(Visuals) protected DynamicLightEnvironmentComponent		mDynamicLightEnv<DisplayName=Dynamic Light Env>;

/** The scale of this creature when used in an AdventureMap Army */
var(Visuals) float                                          mArmyScale<DisplayName=Army Scale>;

/** The TranslucencySortPriority assigned to particles spawned from AnimNotifies */
var(Visuals) int                                            mParticleTransSortPrio<DisplayName=Anim Particle Translucency Sort Priority>;

var(Visuals) protected array<H7CreatureEvent>	            mCreatureEvents<DisplayName=Creature events>;

// Particles that are attached to the creature
//var(Visuals) array<H7ParticleAttachment>                    mParticles;

var(Visuals,Movement) protectedwrite float                  mFlyStartElevating<DisplayName=Time when the animation Fly_Start start the elevating (percentatge)|ClampMin=0|ClampMax=1>;
var(Visuals,Movement) protectedwrite float                  mFlyEndLanding<DisplayName=Time when the animation Fly_End finishes the landing (percentatge)|ClampMin=0|ClampMax=1>;
var(Visuals,Movement) protectedwrite float                  mFlyHeightOffset<DisplayName=Additional flying offset>;

// The opacity of the creature model while walking through obstacles
var(Visuals,Movement) protected int                         mGhostWalkCreatureOpacity<DisplayName=Ghost Walk creature opacity (percent)>;

// The fading duration of creature model's opacity before or after moving through obstacles
var(Visuals,Movement) protected float                       mGhostWalkFadeDuration<DisplayName=Ghost Walk fade in/out duration (seconds)>;

/** Speed of the creature when moving (seconds per field) */
var(Visuals) protected float                                mMovementSpeed<DisplayName=Seconds per field when walking (movement)>;

// Speed of the creature when flying (seconds per field)
var(Visuals) protected float                                mFlyingSpeed<DisplayName=Seconds per field when flying (movement)>;

// wether to use a FracturedStaticMesh instead of a StaticMesh for creature remains
var(Visuals, Death) bool                                    mUseFractureRemains<DisplayName=Use Fractured Mesh for dead creature>;

// representation of a dead creature 
var(Visuals, Death) protected StaticMeshComponent           mCreatureRemains<DisplayName=StaticMesh Representation of dead creature|EditCondition=!mUseFractureRemains>;

// FracturedMesh representation of a dead creature
var(Visuals, Death) protected FracturedStaticMeshComponent  mFracturedCreatureRemains<DisplayName=FracturedStaticMesh Representation of dead creature|EditCondition=mUseFractureRemains>;

// the list of Death material effects
var(Visuals, Death) Array<H7DeathMaterialEffect>            mDeathMaterialEffects<DisplayName=Material Death Effects>;

// Should the corpse of the creature stay visible after death
var(Visuals, Death) protected bool                          mHideCorpseAfterDeath<DisplayName=Should the mesh of the creature be hidden after death>;
var(Visuals, Death) protected float                         mHideCorpseAfterDeathTime<DisplayName=Time after death to hide the corpse|EditCondition=mHideCorpseAfterDeath>;

// spawn a particle system when we die
var(Visuals, Death, Particles) bool                         mUseDeathParticle<DisplayName=Use Death Particle>;

// particle system to emit on death
var(Visuals, Death, Particles) ParticleSystem               mDeathParticle<EditCondition=mUseDeathParticle|DisplayName=Death Particle>;

// time between actual death and the spawning of the Death particle system
var(Visuals, Death, Particles) float                        mDeathParticleTime<EditCondition=mUseDeathParticle|DisplayName=Death Particle Time>;

// offset for the location of the Death particle system
var(Visuals, Death, Particles) Vector                       mDeathParticleOffset<EditCondition=mUseDeathParticle|DisplayName=Death Particle Offset>;

// REMOVE
// use ragdoll on death
var(Visuals, Death, Ragdoll) bool                           mDeathRagdoll<DisplayName=Use Death Ragdoll>;

// time between actual death and death ragdoll activation
var(Visuals, Death, Ragdoll) float                          mDeathRagdollTime<EditCondition=mDeathRagdoll|DisplayName=Death Ragdoll Time>;


function SkeletalMeshComponent		    GetSkeletalMesh()				{ return mSkeletalMesh; }
function DynamicLightEnvironmentComponent		GetDynamicLightEnv()    { return mDynamicLightEnv; }

function float                          GetFlyStartElevating()          { return mFlyStartElevating; }
function float                          GetFlyEndLanding()              { return mFlyEndLanding; }
function array<H7CreatureEvent>	        GetCreatureEvents()             { return mCreatureEvents; }
//function array<H7ParticleAttachment>    GetParticleAttachments()		{ return mParticles; }
function float                          GetGhostWalkOpacity()           { return mGhostWalkCreatureOpacity; }
function float                          GetMovementSpeed()              { return mMovementSpeed; }
function float                          GetFlyingSpeed()                { return mFlyingSpeed; }
function float                          GetGhostWalkFadeDuration()      { return mGhostWalkFadeDuration; }
function float                          GetDeathParticleTime()          { return mDeathParticleTime; }
function float                          GetDeathRagDollTime()           { return mDeathRagdollTime; }
function StaticMeshComponent            GetCreatureRemains()            { if (mUseFractureRemains) return mFracturedCreatureRemains; return mCreatureRemains; }
function Array<H7DeathMaterialEffect>   GetDeathMaterialEffects()       { return mDeathMaterialEffects; }
function bool                           GetHideCorpseAfterDeath()       { return mHideCorpseAfterDeath; }
function float                          GetHideCorpseAfterDeathTime()   { return mHideCorpseAfterDeathTime; }
function ParticleSystem                 GetDeathParticle()              { return mDeathParticle;}
function Vector                         GetDeathParticleOffeset()       { return mDeathParticleOffset;}
function bool                           IsDeathRagDoll()                { return mDeathRagdoll;}

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

