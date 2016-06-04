//=============================================================================
// H7Creature
//=============================================================================
// A creature is the data model containing all the creatures properties that 
// are defined in the corresponding archetypes. Creatures are allways 
// associated by a creature stack, that has the life values. 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Creature extends H7Unit
	implements(H7IAliasable, H7IThumbnailable)
	placeable
	dependson(H7CombatMapCell)
	dependson(H7CombatMapCursor,H7GameTypes)
	dependson(H7StructsAndEnumsNative)
	native
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	savegame;

// constants for creature power calculation
const POWER_ATTACK_MOD = 1;
const POWER_MAGIC_DEFENSE_MOD = 1;
const POWER_MIGHT_DEFENSE_MOD = 1;
const POWER_DESTINY_MOD = 1;
const POWER_LEADERSHIP_MOD = 1;
const POWER_HEALTH_MOD = 0.3f;

//
var(Properties) protected ECreatureTier				mTier<DisplayName=Creature Tier>;
// creature level
var(Properties) protected ECreatureLevel            mCreatureLevel<DisplayName="Creature Level">;
// base size 
var(Properties) protected ECellSize					mBaseSize<DisplayName=Base Size>;
// defines creature movement type
var(Properties) protected EMovementType				mMovementType<DisplayName=Movement Type>;
// abilities (passive and active)
var(Properties) protected array<H7CreatureAbility>	mAbilities<DisplayName=Abilities>;

// attack range [0,50,100]
var(Properties) protected EAttackRange				mAttackRange<DisplayName=Attack Range>;
var(Properties) protected bool				        mCritAnimationForRanged<DisplayName="Critical Hit Animation (true - plays for ranged; false - plays for melee)">;
// melee penalty (range units usually have this flag set)
var(Properties) protected bool						mMeleePenalty<DisplayName=Melee Penalty>;
// ammo
var(Properties) protected bool						mUseAmmo<DisplayName=Is Ammo Used>;
// XP gained upon killing
var(Properties) protected int						mXp<DisplayName=XP Gain|ClampMin=0>;
// is a creature flankable?
var(Properties) protected bool						mIsFlankable<DisplayName=Is Flankable>;
// is a creature full flankable?
var(Properties) protected bool						mIsFullFlankable<DisplayName=Is Full Flankable>;
// is resurrectable //TODO: DEPRECATED?
var protected bool						            mResurrectable<DisplayName=Is Resurrectable>;
//
var(Properties) protected H7Creature				mUpgradeOfCoreCreature<DisplayName=Upgraded version of creature>;
//
var(Properties) protected H7Creature				mBaseCreature<DisplayName=Base version of creature>;
//
var(Properties) protected H7Creature                mHeroPediaOverwrite<DisplayName=HeroPedia overwrite>;
// Power value for army strength calculation
var(Stats) protected int							mPowerValue<DisplayName=Power Value|ClampMin=0>;
// hitpoints
var(Stats) protected int							mHitpoints<DisplayName=Hitpoints|ClampMin=0>;
// number of times a creature can retaliate per turn
var(Stats) protected int							mRetaliationCharges<DisplayName=Retaliation Charges|ClampMin=0>;
// Weekly growing when in critter army
var(Stats) protected int							mGrowthRatePercent<DisplayName=Growth Rate Modifier (%)|ClampMin=0>;
// ammo count
var(Stats) protected int							mAmmo<DisplayName=Ammo|EditCondition=mUseAmmo|ClampMin=0>;

// CREATURE BASE ABILITY
var(Stats) protected H7BaseAbility					mDefendAbility<DisplayName=Defend Ability>;
var(Stats) protected H7BaseAbility					mMoralAbility<DisplayName=Good Moral Ability>;
var(Stats) protected H7BaseAbility					mRetaliationAbility<DisplayName=Retaliation Ability>;

var(Stats) protected H7BaseAbility					mMeleeRetaliationOverride<DisplayName=Ability that overrides the default melee attack for retaliation>;
var(Stats) protected H7BaseAbility					mRangedRetaliationOverride<DisplayName=Ability that overrides the default ranged attack for retaliation>;

var(Ai) protected ECreatureCategory					mAiCreatureCategory<DisplayName=Creature Category>;
var(Ai) protected float								mAiBaseUtility<DisplayName=Base Utility>;

var(Visuals) dynload protected H7CreatureVisuals    mVisuals<DisplayName=Visuals>;
var protected H7Creature                            mTemplate;
//Reference ID for the deployment management
var protected int                                   mDeploymentSlotIDReference;

// a non-static copy of the Death material effects, where the values change
var protected Array<H7DeathMaterialEffect> CurrentDeathMaterialEffects;

var(Sounds) protected AkEvent mAttackSound<DisplayName=Attack sound>;
var(Sounds) protected AkEvent mCriticalAttackSound<DisplayName=Critical Attack sound>;
var(Sounds) protected AkEvent mRangeAttackSound<DisplayName=Range Attack sound>;
var(Sounds) protected AkEvent mGetHitSound<DisplayName=Get hit sound>;
var(Sounds) protected AkEvent mDieSound<DisplayName=Die sound>;
// this is not used anymore, this sounds should be placed into the animation
//var(Sounds) protected AkEvent mIdleBridgeSound<DisplayName=Idle Bridge sound>;
var(Sounds) protected AkEvent mIdleSpecialSound<DisplayName=Idle Special sound>;
var(Sounds) protected AkEvent mCastSound<DisplayName=Casting sound>;
var(Sounds) protected AkEvent mAbility1Sound<DisplayName=Ability 1 sound>;
var(Sounds) protected AkEvent mAbility1EndSound<DisplayName=Ability 1 end sound>;
var(Sounds) protected AkEvent mAbility2Sound<DisplayName=Ability 2 sound>;
var(Sounds) protected AkEvent mAbility2EndSound<DisplayName=Ability 2 sound>;
// cue that plays a random move sound
var(Sounds) protected AkEvent mMoveStartSounds<DisplayName=Start Move sound>;
var(Sounds) protected AkEvent mRandomMoveSounds<DisplayName=Random Move sound>;
var(Sounds) protected AkEvent mStopRandomMoveSoundEvent <DisplayName=End Move sound>;;
var(Sounds) protected AkEvent mFlyStartSounds<DisplayName=Fly Start sound>;
var(Sounds) protected AkEvent mFlyEndSounds<DisplayName=Fly End sound>;
var(Sounds) protected AkEvent mTurnLeftSounds<DisplayName=Turn left sound>;
var(Sounds) protected AkEvent mTurnRightSounds<DisplayName=Turn right sound>;
var(Sounds) protected AkEvent mVictorySound<DisplayName=Victory sound>;
var(Sounds) protected AkEvent mDefendSound<DisplayName=Defend sound>;
var(Sounds) protected AkEvent mRandomFlySounds<DisplayName=Random Fly sound>;
var(Sounds) protected AkEvent mStopRandomFlySoundEvent;
var(Sounds) protected AkEvent mSummonSound<DisplayName=Summon sound>;
var(Sounds) protected AkEvent mAdventureMapIdleSound<DisplayName=Adventure Map Idle sound>;


// Effects for team color and hover
var protected bool                          mIsHovering;
var protected bool                          mIsVisible;
var protected float                         mColorLerpBuffer;
var protected float                         mTimeAtEffectStart;
var protected bool                          mFadeInMaterialFX;
var protected bool                          mFadeOutMaterialFX;
var protected bool                          mHasPendingMaterialFX;
var protected H7CreatureAnimControl			mAnimControl;
var array<MaterialInstanceConstant>         mCreatureMaterials;
var protected H7CreatureFX                  mFX;
var protected array<H7CreatureFX>           mWeapFX;
var protected H7FXStruct                    mEffectToPlay;
var protected bool                          mSkipDeathAnim;
var protected bool                          mUndoDeathFX;

var protectedwrite bool                     mFadeInAnimDone;

function bool IsCritAnimPlayedForRanged()   { return mCritAnimationForRanged; }
function SetFadeInAnimDone( bool v )        { mFadeInAnimDone = v; }
function EWarUnitClass GetWarUnitClass()
{ 
	;
	ScriptTrace();
	return WCLASS_ATTACK;
}

native function int GetQuickCombatSubstituteImpact( EQuickCombatSubstitute substitute );
native function bool CanMoraleInQuickCombat( array<H7BaseAbility> criteria );

function ECreatureLevel             GetCreatureLevel()              { return mCreatureLevel; }
function                            SetCreatureLevel( ECreatureLevel lvl ) { mCreatureLevel = lvl; }

//function Texture2D					GetIcon()						{ return mIcon; }
//function String						GetFlashIconPath()				{ return "img://" $ Pathname( GetIcon() ); }

function bool                       IsResurrectable()	            { return mResurrectable; }
function H7CreatureAnimControl		GetAnimControl()				{ return mAnimControl; }
function H7CreatureStack			GetOwner()						{ return H7CreatureStack( Owner ); }
function SkeletalMeshComponent		GetSkeletalMesh()				{ return SkeletalMeshComponent; }

function bool                       IsFlankable()                   { return mIsFlankable; }
function bool                       IsFullFlankable()               { return mIsFullFlankable; }

function int                        GetWeeklyGrowthRate()           { return mGrowthRatePercent; }
function ECellSize				    GetBaseSize()			        { return mBaseSize; }
function EAttackRange			    GetAttackRange()                { return mAttackRange; }

function int        			    GetHitPointsBase()				{ return mHitpoints; }
function bool                       HasMeleePenalty()               { return mMeleePenalty; }
function EMovementType              GetMovementType()               { return mMovementType; }
function int                        GetRetaliationCharges()         { return mRetaliationCharges; }
function int                        GetAmmo()                       { return mAmmo; }
function array<H7CreatureAbility>   GetAbilities()                  { return mAbilities; }
function int					    GetExperiencePoints()			{ return mXp; }
function bool                       UsesAmmo()                      { return mUseAmmo; }
function H7Creature                 GetUpgradedCreature()           { return mUpgradeOfCoreCreature; }
event    bool                       IsUpgradeVersion()              { if( mUpgradeOfCoreCreature == none ) return true; return false; }
function string                     GetUpgradedName()               { return mUpgradeOfCoreCreature.GetName(); }
function string                     GetBaseCreatureName()           { if( mBaseCreature != none ) return mBaseCreature.GetName(); return mName; }
function H7Creature                 GetBaseCreature()               { return mBaseCreature; }
function bool                       IsBaseCreature()                { if( mBaseCreature == none ) return true; return false; }
function H7BaseAbility              GetDefendAbility()              { return mDefendAbility; }
function H7BaseAbility              GetMoralAbility()               { return mMoralAbility; }
function H7BaseAbility              GetRetaliationAbility()         { return mRetaliationAbility; }
function H7BaseAbility              GetRetaliationOverrideMelee()   { return mMeleeRetaliationOverride; }
function H7BaseAbility              GetRetaliationOverrideRanged()  { return mRangedRetaliationOverride; }
function bool                       GetCreatureIsVisible()          { return mIsVisible; }
function                            SkipDeathAnim(bool doSkip)	    { mSkipDeathAnim = doSkip; }
function int                        GetLeadership()                 { return mLeadership; }
function int                        GetDestiny()	                { return mDestiny; }
function                            SetIsFlankable( bool value )    { mIsFlankable = value; }
function                            SetIsFullFlankable( bool value ){ mIsFullFlankable = value; }
function                            SetWeeklyGrowthRate( int value ){ mGrowthRatePercent = value; }
function String                     GetOverwriteIDString()          { return mHeroPediaOverwrite != none ? mHeroPediaOverwrite.GetIDString() : ""; }

function ECreatureCategory          GetCreatureCategory()           { return mAiCreatureCategory; }
function float                      GetCreatureBaseUtility()        { return mAiBaseUtility; }

function bool                       HasPendingMaterialFX()          { return mHasPendingMaterialFX; }
function bool                       HasDeathMaterialFX()            { return CurrentDeathMaterialEffects.Length > 0; }

function int                        GetDeploymentSlotID(){ return mDeploymentSlotIDReference; }
function                            SetDeploymentSlotID(int val){ mDeploymentSlotIDReference = val; }

function SetRetaliationCharges( int newRetaliationCharges ) { mRetaliationCharges = newRetaliationCharges; }

// checks all buffs and abilities of the creature to see if it is resistant/immune/vulnerable against the specified school and tags
native function float GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);


native function vector GetMeshCenter();
native function Vector GetSocketLocation( name socketName );

// A H7Creature shall only return the pure database value of the creature type as entered into the editor
// - so it will never have modifiers
native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType exclusiveFirstOT = -1, optional EOperationType exclusiveSecondOT = -1, optional bool nextRound);


function H7CreatureVisuals GetVisuals()
{
	if( mVisuals == none ) 
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mVisuals');
		}
		else
		{
			mVisuals = mTemplate.GetVisuals();
		}
	}
	return mVisuals;	
}

function CreateCreature( H7Creature template )
{
	local int i; 
	local MaterialInstanceConstant MatInst;
	local Color playerColor;
	local LinearColor playerLinearColor;
	local DynamicLightEnvironmentComponent dynLightEnv;

	mTemplate = template;

	SkeletalMeshComponent = new(self) class'SkeletalMeshComponent'( GetVisuals().GetSkeletalMesh() );
	dynLightEnv = DynamicLightEnvironmentComponent(LightEnvironment);
	if (dynLightEnv != None)
	{
		dynLightEnv.bSkipUpdateWhenHidden = GetVisuals().GetDynamicLightEnv().bSkipUpdateWhenHidden;
		dynLightEnv.NumVolumeVisibilitySamples = GetVisuals().GetDynamicLightEnv().NumVolumeVisibilitySamples;
		dynLightEnv.LightingBoundsScale = GetVisuals().GetDynamicLightEnv().LightingBoundsScale;
		dynLightEnv.bCastShadows = GetVisuals().GetDynamicLightEnv().bCastShadows;
		dynLightEnv.bUseBooleanEnvironmentShadowing = GetVisuals().GetDynamicLightEnv().bUseBooleanEnvironmentShadowing;
		dynLightEnv.bDynamic = GetVisuals().GetDynamicLightEnv().bDynamic;
		dynLightEnv.bSynthesizeSHLight = GetVisuals().GetDynamicLightEnv().bSynthesizeSHLight;
		dynLightEnv.bIsCharacterLightEnvironment = GetVisuals().GetDynamicLightEnv().bIsCharacterLightEnvironment;
	}
	SkeletalMeshComponent.SetLightEnvironment( LightEnvironment );
	SkeletalMeshComponent.SetActorCollision( false, false, false );
	SkeletalMeshComponent.SetTraceBlocking( false, false );

	ReattachComponent( SkeletalMeshComponent );

	InitFX();

	// load and set the materials into memory so we can control them at runtime
	if (GetSkeletalMesh() != None && GetSkeletalMesh().SkeletalMesh != None)
	{
		for (i = 0; i < GetSkeletalMesh().SkeletalMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(GetSkeletalMesh().GetMaterial(i));
			GetSkeletalMesh().SetMaterial(i, MatInst);
			mCreatureMaterials.AddItem(MatInst);
		}
	}

	// apply player color to the creature if needed
	if (class'H7GUIGeneralProperties'.static.GetInstance().IsUsingModelColoring()
		&& !GetOwner().GetCombatArmy().GetPlayer().IsNeutralPlayer())
	{
		playerColor = GetOwner().GetCombatArmy().GetPlayer().GetColor();
		playerLinearColor.R = float(playerColor.R) / 255;
		playerLinearColor.G = float(playerColor.G) / 255;
		playerLinearColor.B = float(playerColor.B) / 255;
		foreach mCreatureMaterials(MatInst)
		{
			MatInst.SetScalarParameterValue('bUseFactionColor', 1.0f);
			MatInst.SetVectorParameterValue('FactionColor', playerLinearColor);
		}
	}

	SetCollisionType(COLLIDE_NoCollision);
	SetCollision( false, false, false);
}


simulated function PostBeginPlay()
{
	super.PostBeginPlay();
}

function InitFX()
{
	mFX = new(self) class'H7CreatureFX';
	mFX.InitFX( GetSkeletalMesh() );
}

simulated event PostInitAnimTree(SkeletalMeshComponent SkelComp)
{
	local H7CreatureFX WeapFX;

	super.PostInitAnimTree( SkelComp );

	mAnimControl = Spawn( class'H7CreatureAnimControl', self );
	mAnimControl.Init( self, SkelComp, GetVisuals().GetCreatureEvents() );

	foreach mWeapFX(WeapFX)
	{
		WeapFX.SetIsHovering(false);
	}
}

function SetTeamColor( int teamID )
{
	local H7CreatureFX WeapFX;

	mFX.SetTeamColor(teamID);
	foreach mWeapFX(WeapFX)
	{
		WeapFX.SetTeamColor(teamID);
	}
}

function SetIsHovering( bool isHovering, optional bool evenIfBusy=false)
{
	local H7CreatureFX WeapFX;

	if( (mAnimControl.IsIdling() || evenIfBusy) || !isHovering )
	{
		mIsHovering = isHovering;
		mFX.SetIsHovering(isHovering);
		foreach mWeapFX(WeapFX)
		{
			WeapFX.SetIsHovering(isHovering);
		}
	}
}

function bool IsHovering() { return mIsHovering; }

function HideMeshes()
{
	local ParticleSystemComponent attachedFX;

	foreach GetSkeletalMesh().AttachedComponents(class'ParticleSystemComponent', attachedFX)
	{
		attachedFX.SetIgnoreOwnerHidden(true);
		attachedFX.SetHidden(true);
	}

	GetSkeletalMesh().SetHidden( true );

	//To ensure the dying sounds are played correctly
	if( !self.GetAnimControl().IsDying() )
	{
		EnableUnitSound(false);
	}

	mIsVisible = false;
}

function ShowMeshes()
{
	GetSkeletalMesh().SetHidden( false );
	EnableUnitSound(true);
	mIsVisible = true;
}


function float GetMeshRadius()
{
	return GetSkeletalMesh().Bounds.SphereRadius;
}

function float GetFXScale()
{
	return GetSkeletalMesh().Bounds.SphereRadius / 200.f;
}

function vector GetHeightPos( float offset )
{
	
	if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
	{
		return Vect( 0.f, 0.f, 1.f ) * (SkeletalMeshComponent.SkeletalMesh.Bounds.BoxExtent.Z + offset) * SkeletalMeshComponent.Scale * SkeletalMeshComponent.Scale3D.Z; 
	}
	else
	{
		return SkeletalMeshComponent.Bounds.Origin + Vect( 0.f, 0.f, 1.f ) * (SkeletalMeshComponent.Bounds.BoxExtent.Z + offset) * SkeletalMeshComponent.Scale * SkeletalMeshComponent.Scale3D.Z; 
	}
}

function float GetHeight()
{
	return SkeletalMeshComponent.Bounds.BoxExtent.Z * 2.f;
}

function string GetTierString()
{
	switch ( mTier )
	{
		case CTIER_CORE: return class'H7Loca'.static.LocalizeSave("TIER_CORE","H7Creature");
		case CTIER_ELITE: return class'H7Loca'.static.LocalizeSave("TIER_ELITE","H7Creature");
		case CTIER_CHAMPION: return class'H7Loca'.static.LocalizeSave("TIER_CHAMPION","H7Creature");
		default: return "";
	}
}

function ECreatureTier GetTier()
{
	return mTier;
}

/* GetXSize
   =============================================================================
   Returns the number of grid cells in x-direction according its basesize
*/
function int GetXSize()
{
	switch(mBaseSize)
	{
		case CELLSIZE_1x1: return 1;
		case CELLSIZE_2x2: return 2;
		default: return 1;
	}
}

/* GetYSize
   =============================================================================
   Returns the number of grid cells in y-direction according its basesize
*/
function int GetYSize()
{
	switch(mBaseSize)
	{
		case CELLSIZE_1x1: return 1;
		case CELLSIZE_2x2: return 2;
		default: return 1;
	}
}

function PlayAttackSound()
{
	if (mAttackSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mAttackSound,true,true, self.Location );
	}
}

function PlayCriticalAttackSound()
{
	if (mCriticalAttackSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mCriticalAttackSound,true,true, self.Location );
	}
}

function PlayRangeAttackSound()
{
	if (mRangeAttackSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mRangeAttackSound,true,true, self.Location );
	}
}

function PlayGetHitSound()
{
	if (mGetHitSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mGetHitSound,true,true, self.Location );
	}
} 

function PlayDieSound()
{
	if (mDieSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mDieSound,true,true, self.Location );
	}
}

// this is not used anymore, this sounds should be placed into the animation
//function PlayIdleBridgeSound()
//{
//	if (mIdleBridgeSound != None)
//	{
//		class'H7SoundManager'.static.PlayAkEventOnActor( self, mIdleBridgeSound,true,true, self.Location );
//	}
//}

function PlayIdleSpecialSound()
{
	if (mIdleSpecialSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mIdleSpecialSound,true,true, self.Location );
	}
}

function PlaySummonSound()
{
	if (mSummonSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mSummonSound,true,true, self.Location );
	}
}

function PlayCastSound()
{
	if (mCastSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mCastSound,true,true, self.Location );
	}
}

function PlayAbility1Sound()
{
	if (mAbility1Sound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mAbility1Sound,true,true, self.Location );
	}
}

function PlayAbility1EndSound()
{
	if (mAbility1EndSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mAbility1EndSound,true,true, self.Location );
	}
}

function PlayAbility2Sound()
{
	if (mAbility2Sound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mAbility2Sound,true,true, self.Location );
	}
}

function PlayMoveStartSound()
{
	if (mMoveStartSounds != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mMoveStartSounds,true,true, self.Location );
	}
}

function PlayRandomMoveSound()
{
	if (mRandomMoveSounds != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mRandomMoveSounds,true,true, self.Location );
	}
}

function PlayTurnLeftSound()
{
	if (mTurnLeftSounds != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mTurnLeftSounds,true,true, self.Location );
	}
}

function PlayTurnRightSound()
{
	if (mTurnRightSounds != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mTurnRightSounds,true,true, self.Location );
	}
}
function PlayFlyStartSound()
{
	if (mFlyStartSounds != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mFlyStartSounds,true,true, self.Location );
	}
}
function PlayFlyEndSound()
{
	if (mFlyEndSounds != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mFlyEndSounds,true,true, self.Location );
	}
}
function StopRandomMoveSound()
{
	if(mStopRandomMoveSoundEvent != none)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mStopRandomMoveSoundEvent);
	}
}
function PlayVictorySound()
{
	if (mVictorySound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mVictorySound,true,true, self.Location );
	}
}
function PlayDefendSound()
{
	if (mDefendSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mDefendSound,true,true, self.Location );
	}
}
function PlayRandomFlySound()
{
	if (mRandomFlySounds != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mRandomFlySounds,true,true, self.Location );
	}
}
function StopRandomFlySound()
{
	if(mStopRandomFlySoundEvent != none)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, mStopRandomFlySoundEvent);
	}
}
function PlayAdventureMapIdleSound( actor creator )
{
	if (mAdventureMapIdleSound != None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( creator, mAdventureMapIdleSound,true,true, self.Location );
	}
}

function PlayDeathEffects( optional bool undo = false )
{
	local int i;
	local H7DeathMaterialEffect NewEffect;
	local array<H7DeathMaterialEffect> deathMaterialEffects;

	deathMaterialEffects = GetVisuals().GetDeathMaterialEffects();
	mUndoDeathFX = undo;
	if ( deathMaterialEffects.Length > 0)
	{
		SetTimer(0.05f, true, 'PlayDeathMaterialEffects');
		for (i = 0; i < deathMaterialEffects.Length; i++)
		{
			// copy the effects into the duplicate list
			NewEffect = deathMaterialEffects[i];
			NewEffect.EffectStartingTime = WorldInfo.TimeSeconds;
			CurrentDeathMaterialEffects.AddItem(NewEffect);
		}
	}
}

function PlayDeathMaterialEffects()
{
	if( mUndoDeathFX )
	{
		UndoDeathMaterialFX(CurrentDeathMaterialEffects, mCreatureMaterials);
	}
	else
	{
		// call H7Unit function with correct arrays
		DoDeathMaterialEffectFading(CurrentDeathMaterialEffects, mCreatureMaterials);
	}
}

function ChangeAnimationSpeedFX(H7FXStruct effect)
{
	local float creatureSpeed;

	self.CustomTimeDilation = effect.mAnimationSpeed;

	creatureSpeed = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * effect.mAnimationSpeed;
	SetRTPCValue('Game_Speed', creatureSpeed * (100 + self.mAnimSoundSpeedManipulator));
}

function EnableAdventureIdleBridge(bool val)
{
	//Enables the idle bridge sounds with the different attenuations for the different map types
	if(val)
	{
		SetRTPCValue('Idle_Bridge_AdventureMap', 100.f);
		SetRTPCValue('Idle_Bridge_CombatMap', 0.f);
	}
	else
	{
		SetRTPCValue('Idle_Bridge_AdventureMap', 0.f);
		SetRTPCValue('Idle_Bridge_CombatMap', 100.f);
	}
}

function StartSetEffectMaterialValues(H7FXStruct effect)
{
	mColorLerpBuffer = 0;
	mTimeAtEffectStart = WorldInfo.TimeSeconds;
	mFadeInMaterialFX = true;
	mEffectToPlay = effect;
	mHasPendingMaterialFX = false;
}

function ResumeMaterialEffects()
{
	mColorLerpBuffer = 0;
	mFadeOutMaterialFX = true;
	mHasPendingMaterialFX = false;
	mTimeAtEffectStart = WorldInfo.TimeSeconds;
}

function SetEffectsMaterialValues( float deltaTime )
{
	local int i,j;
	local name MaterialParam;
	local float CurrValue;
	local bool IsColor;
	local bool bPendingEffects;
	local LinearColor CurrValueLinCol;

	for (i = 0; i < mEffectToPlay.mMaterialFX.Length; i++)
	{
		IsColor = false;
		if( WorldInfo.TimeSeconds - mTimeAtEffectStart > mEffectToPlay.mMaterialFX[i].FadeInEffectStartingtime )
		{
			// wait for the time to start
			if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Emissive)
			{
				MaterialParam = 'EmissiveColor_Global';
				IsColor = true;
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Opacity)
			{
				MaterialParam = 'Opacity_Global';
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Spec)
			{
				MaterialParam = 'SpecMul_Global';
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_SpecPow)
			{
				MaterialParam = 'SpecPowMul_Global';
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Diffuse)
			{
				MaterialParam = 'DiffColor_Global';
				IsColor = true;
			}

			for (j = 0; j < mCreatureMaterials.Length; j++)
			{
				if (!IsColor)
				{
					mCreatureMaterials[j].GetScalarParameterValue( MaterialParam, CurrValue );

					if( mColorLerpBuffer < mEffectToPlay.mMaterialFX[i].FadeInEffectLength )
					{
						CurrValue = Lerp( 1.0f, mEffectToPlay.mMaterialFX[i].MaxEffectImpact, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeInEffectLength );
						
						bPendingEffects = true;
					}

					mCreatureMaterials[j].SetScalarParameterValue( MaterialParam, CurrValue );
				}
				else
				{
					mCreatureMaterials[j].GetVectorParameterValue( MaterialParam, CurrValueLinCol );
					
					if( mColorLerpBuffer < mEffectToPlay.mMaterialFX[i].FadeInEffectLength )
					{
						CurrValueLinCol.A = Lerp( 0.0f, mEffectToPlay.mMaterialFX[i].ColorManipulationMax.A, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeInEffectLength );
						CurrValueLinCol.R = Lerp( 1.0f, mEffectToPlay.mMaterialFX[i].ColorManipulationMax.R, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeInEffectLength );
						CurrValueLinCol.G = Lerp( 1.0f, mEffectToPlay.mMaterialFX[i].ColorManipulationMax.G, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeInEffectLength );
						CurrValueLinCol.B = Lerp( 1.0f, mEffectToPlay.mMaterialFX[i].ColorManipulationMax.B, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeInEffectLength );
						
						bPendingEffects = true;
					}

					mCreatureMaterials[j].SetVectorParameterValue( MaterialParam, CurrValueLinCol );
				}
			}
		}
		else
		{
			bPendingEffects = true;
		}
	}

	if(!bPendingEffects)
	{
		

		if(!mEffectToPlay.mIsPermanentFX)
		{
			mFadeInMaterialFX = false;
			mFadeOutMaterialFX = true;
			mHasPendingMaterialFX = false;
			mTimeAtEffectStart = WorldInfo.TimeSeconds;
			mColorLerpBuffer = 0;
		}
		else
		{
			mFadeInMaterialFX = false;
			mHasPendingMaterialFX = true;
		}
	}
}

function FadeBackEffectMaterialValues( float deltaTime )
{
	local int i,j;
	local name MaterialParam;
	local float CurrValue;
	local bool IsColor;
	local bool bPendingEffects;
	local LinearColor CurrValueLinCol;

	// operate on all the death material effects
	for (i = 0; i < mEffectToPlay.mMaterialFX.Length; i++)
	{
		IsColor = false;
		if (WorldInfo.TimeSeconds - mTimeAtEffectStart > mEffectToPlay.mMaterialFX[i].FadeOutEffectStartingTime )
		{
			// wait for the time to start
			if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Emissive)
			{
				MaterialParam = 'EmissiveColor_Global';
				IsColor = true;
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Opacity)
			{
				MaterialParam = 'Opacity_Global';
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Spec)
			{
				MaterialParam = 'SpecMul_Global';
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_SpecPow)
			{
				MaterialParam = 'SpecPowMul_Global';
			}
			else if (mEffectToPlay.mMaterialFX[i].MaterialParamName == EMP_Diffuse)
			{
				MaterialParam = 'DiffColor_Global';
				IsColor = true;
			}

			// operate on all of the creature's materials
			for (j = 0; j < mCreatureMaterials.Length; j++)
			{
				if (!IsColor)
				{
					mCreatureMaterials[j].GetScalarParameterValue( MaterialParam, CurrValue );

					if( mColorLerpBuffer < mEffectToPlay.mMaterialFX[i].FadeOutEffectLength )
					{
						CurrValue = Lerp( mEffectToPlay.mMaterialFX[i].MaxEffectImpact, 1.0f, mColorLerpBuffer/ mEffectToPlay.mMaterialFX[i].FadeOutEffectLength );
						
						bPendingEffects = true;
					}

					mCreatureMaterials[j].SetScalarParameterValue( MaterialParam, CurrValue );
				}
				else
				{
					mCreatureMaterials[j].GetVectorParameterValue( MaterialParam, CurrValueLinCol );

					if( mColorLerpBuffer < mEffectToPlay.mMaterialFX[i].FadeOutEffectLength )
					{
						CurrValueLinCol.A = Lerp( mEffectToPlay.mMaterialFX[i].ColorManipulationMax.A, 0.0f, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeOutEffectLength );
						CurrValueLinCol.R = Lerp( mEffectToPlay.mMaterialFX[i].ColorManipulationMax.R, 1.0f, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeOutEffectLength );
						CurrValueLinCol.G = Lerp( mEffectToPlay.mMaterialFX[i].ColorManipulationMax.G, 1.0f, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeOutEffectLength );
						CurrValueLinCol.B = Lerp( mEffectToPlay.mMaterialFX[i].ColorManipulationMax.B, 1.0f, mColorLerpBuffer / mEffectToPlay.mMaterialFX[i].FadeOutEffectLength );
						bPendingEffects = true;
					}
					mCreatureMaterials[j].SetVectorParameterValue( MaterialParam, CurrValueLinCol );
				}
			}
		}
		else
		{
			bPendingEffects = true;
		}

		
		if(!bPendingEffects)
		{
			if( !IsColor )
			{
				//Reset to default if almost faded back to ensure 100% switch back
				for (j = 0; j < mCreatureMaterials.Length; j++)
				{
					mCreatureMaterials[j].SetScalarParameterValue( MaterialParam, 1.0f );
				}
			}
			else
			{
				for (j = 0; j < mCreatureMaterials.Length; j++)
				{
					CurrValueLinCol.A = 0.0f;
					CurrValueLinCol.R = 1.0f;
					CurrValueLinCol.G = 1.0f;
					CurrValueLinCol.B = 1.0f;
					mCreatureMaterials[j].SetVectorParameterValue( MaterialParam, CurrValueLinCol );
				}
			}
			mFadeOutMaterialFX = false;
			GetOwner().GetEffectManager().NotifyMaterialFXCompleted();
		}
	}
}

simulated function UpdateParticleTranslucency( ParticleSystemComponent PSC )
{
	if (mVisuals.mParticleTransSortPrio != 0)
	{
		PSC.TranslucencySortPriority = mVisuals.mParticleTransSortPrio;
		PSC.ForceUpdate(false);
	}
}

function DoRagdoll()
{
	GetSkeletalMesh().MotionBlurInstanceScale = 0.0f;
	GetSkeletalMesh().SetBlockRigidBody(true);
	GetSkeletalMesh().PhysicsAssetInstance.SetAllBodiesFixed(FALSE);
	GetSkeletalMesh().PhysicsWeight = 1.0f;
	GetSkeletalMesh().SetRBChannel(RBCC_Untitled3);
	GetSkeletalMesh().SetRBCollidesWithChannel(RBCC_Untitled3, true);
	GetSkeletalMesh().SetRBCollidesWithChannel(RBCC_Default, true);
	GetSkeletalMesh().WakeRigidBody();
}



function EDirection CreatureHeading()
{	
	local float rotate;
	rotate = Rotation.Yaw % 65535;
	
	if( rotate >= 0 )
	{
		if( (rotate > 61434 && rotate <= 65535)  || (rotate >= 0 && rotate <= 4095) )
		{
			return EAST;
		}
		else if( rotate > 4095 && rotate <= 12287)
		{
			return SOUTH_EAST;
		}
		else if( rotate > 12287 && rotate <= 20481)
		{
			return SOUTH;
		}
		else if( rotate > 20481 && rotate <= 28673)
		{
			return SOUTH_WEST;
		}
		else if( rotate > 28673 && rotate <= 36923)
		{
			return WEST;
		}
		else if( rotate > 36923 && rotate <= 45116)
		{
			return NORTH_WEST;
		}
		else if( rotate > 45116 && rotate <= 53243)
		{
			return NORTH;
		}
		else if( rotate > 53243 && rotate <= 61434)
		{
			return NORTH_EAST;
		}
	}
	else
	{
		if( rotate < 0  && rotate >= -4095 )
		{
			return EAST;
		}
		else if( rotate < -4095 && rotate >= -12287)
		{
			return NORTH_EAST;
		}
		else if( rotate < -12287 && rotate >= -20481)
		{
			return NORTH;
		}
		else if( rotate < -20481 && rotate >= -28673)
		{
			return NORTH_WEST;
		}
		else if( rotate < -28673 && rotate >= -36923)
		{
			return WEST;
		}
		else if( rotate < -36923 && rotate >= -45116)
		{
			return SOUTH_WEST;
		}
		else if( rotate < -45116 && rotate >= -53243)
		{
			return SOUTH;
		}
		else if( (rotate < -53243 && rotate >= -61434) || (rotate < -61434 && rotate >= -65535))
		{
			return SOUTH_EAST;
		}
	}
}

function Tick( float deltaTime )
{
	// OPTIONAL: Maybe hacky? Improve?
	if( GetOwner().IsDead() && !mAnimControl.IsDead() && !mSkipDeathAnim )
	{
		mAnimControl.PlayAnim( CAN_DIE );
	}

	if( mFadeInMaterialFX )
	{
		mColorLerpBuffer += ( deltaTime * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * CustomTimeDilation );
		SetEffectsMaterialValues( deltaTime );
	}
	else if( mFadeOutMaterialFX )
	{
		mColorLerpBuffer += ( deltaTime * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed() * CustomTimeDilation );
		FadeBackEffectMaterialValues( deltaTime );
	}
}

function float GetCreaturePower()
{
	return mPowerValue;
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

