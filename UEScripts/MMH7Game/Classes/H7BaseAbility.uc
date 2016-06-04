//=============================================================================
// H7BaseAbility
//=============================================================================
//
// ...
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BaseAbility extends H7EffectContainer 
		hidecategories(Object)
		dependson( H7CombatMapCell, H7Faction, H7GameTypes, H7StructsAndEnumsNative )
		native
		savegame; // Not in Tussi header to avoid circular reference


// special tooltips
var(Container) protected localized string         mTooltipMagicGuild<DisplayName=Tooltip for Magic Guild>;
var(Container) protected localized string         mTooltipMagicGuildRankLine<DisplayName=Tooltip for Magic Guild Rank Lines>;
var(Container) protected localized string         mTooltipUpgraded<DisplayName=Tooltip for Upgraded Version>;
var protected transient string                    mTooltipMagicGuildLocalized;
var protected transient string                    mTooltipUpgradedLocalized;
var protected transient string                    mTooltipMagicGuildRankLineLocalized;

// true = passive ability, false = active ability
var(Container, Ability)                             protected bool				    mIsPassive<DisplayName=Passive Ability>;
// Use this if this ability applies any Governor effect
var(Container, Ability)								protected bool					mIsGovernorEffect<DisplayName=Is Governor Ability>;
var(Container, Ability)                             protected array<ESpellTag>      mTags<DisplayName=Ability Tags>;
var(Container, Ability)                             protected int                   mPowerValue<DisplayName=Arbitrary Power Value (Quick Combat)>;
var(Container, Ability)                             protected bool                  mIsRanged<DisplayName=Ranged Ability|EditCondition=!mIsPassive>;
var(Container, Ability)                             protected bool                  mMoveToTarget<DisplayName=Move to Target|EditCondition=!mIsPassive>;
var(Container, Ability)                             protected bool                  mIsDirectionalCast<DisplayName=Directional Cast|EditCondition=!mIsPassive>;
var(Container, Ability)                             protected bool                  mIsTeleportSpell<DisplayName=Is A Teleport Spell>;
var(Container, Ability)                             protected H7AuraStruct          mAuraData<DisplayName=Aura-Specific Properties>;
var(Container, Ability)                             protected bool                  mDisableFleeSurrender<DisplayName=Disable Flee/Surrender in Combat TODO: make into special effect :( >;
var(Container, Ability)                             protected bool                  mOncePerCombat<DisplayName=Can only use once per combat>;
var(Container, Ability)                             protected H7BaseAbility         mUpradeAbility<DisplayName=Ability that upgrades this>;

// targeting (user with gui and mouse)
var(Container, Ability, TargetSelection)            protected EAbilityTarget	    mTargetType<DisplayName=Target Selection Type>;
// targeting group specifier. 
// * For buildings you can set it to 'Mine' for example to limit the valid targets the ability does stick.
// * For combat you can set it to 'Hero' or 'CreatureStack'
var(Container, Ability, TargetSelection)            protected String                mTargetClassSpecifier<DisplayName=Target Class Specifier>;
// only used then selected AREA or ELLIPSE above:
var(Container, Ability, TargetSelection)            protected int                   mTsunamiRows<DisplayName=Width of Tsunami>;
var(Container, Ability, TargetSelection)            protected bool                  mIsAreaFilled<DisplayName=Filled?>;
var(Container, Ability, TargetSelection)            protected IntPoint              mAreaOfEffectSize<DisplayName=Area of Effect|EditCondition=mTargetSelectionArea>;
// only used then selected CUSTOM above:
var(Container, Ability, TargetSelection)            protected array<IntPoint>       mTargetShape<DisplayName=AoE shape|EditCondition=mTargetSelectionShape>;
var(Container, Ability, TargetSelection)            protected H7ConeStruct          mTargetCone<DisplayName=Cone(Sweep) shape|EditCondition=mTargetSelectionCone>;

var (Container, SoundAndVisuals, Animation)          protected EUnitAnimation       mAnimation<DisplayName=Animation for This Ability>;

var (Container, SoundAndVisuals, Sound)              protected AkEvent             mProjectileHitSound<DisplayName= Projectile Hit Sound>;
var (Container, SoundAndVisuals, Sound)              protected AKEvent             mProjectileFiringSound<DisplayName= Projectile Firing Sound>;


/* FX-------------------------- */
/** particle effect that will be played when the ability is casted, socket is used for start point of projectile */
var(Container, SoundAndVisuals, VisualEffects)       protected H7FXStruct           mCasterFXS<DisplayName=Caster Particle Effect>;
var(Container, SoundAndVisuals, VisualEffects)       protected bool                 mCasterNoDuplicateFXS<DisplayName=No Duplicate Particle Effect>;

var(Container, SoundAndVisuals, VisualEffects)       protected bool                 mTurnToTarget<DisplayName=Face Target when Casting (only important for Ability animation)>;

var(Container, SoundAndVisuals, VisualEffects)       protected float                mTimerSpawnProjectile<DisplayName=Timer Spawn Projectile|ClampMin=0>;
var(Container, SoundAndVisuals, VisualEffects)       protected float                mTimerRaiseEvents<DisplayName=Timer Raise Events|ClampMin=0>;

/** The projectile */
var(Container, SoundAndVisuals, VisualEffects)       protected H7USSProjectile      mProjectile<DisplayName=Projectile|ToolTip=No projectile means this ability will hit instantly>;

var(Container, SoundAndVisuals, VisualEffects)       protected float                mTimerSpawnCritProjectile<DisplayName=Timer Spawn Critical Projectile|ClampMin=0>;
var(Container, SoundAndVisuals, VisualEffects)       protected H7USSProjectile      mCritProjectile<DisplayName=Critical Hit Projectile|ToolTip=No projectile means this ability will hit instantly on critical hits>;

/** particle effect that will be played when the ability hit reaches the target location */
var(Container, SoundAndVisuals, VisualEffects)       protected H7FXStruct           mImpactFXS<DisplayName=Impact Particle Effect>;

/** particle effect that will be played when the ability hits a target */
var(Container, SoundAndVisuals, VisualEffects)       protected H7FXStruct           mHitTargetFXS<DisplayName=Hit Target Particle Effect>;

var(Container, SoundAndVisuals, Camera)              protected bool                     mUseCameraShake<DisplayName=Use Camera Shake Effect>;
var(Container, SoundAndVisuals, Camera)              protected float                    mCameraShakeDelay<DisplayName=Camera Shake Effect Delay>;
var(Container, SoundAndVisuals, Camera)              protected bool                     mUseCoolCam<DisplayName=Use Cool Cam Effect>;
var(Container, SoundAndVisuals, Camera)              protected float                    mCoolCamDuration<DisplayName=Cool Cam Duration|EditCondition=mUseCoolCam>;
var(Container, SoundAndVisuals, Camera)              protected editinline CameraShake   mCameraShake<DisplayName=Camera Shake|EditCondition=mUseCameraShake>;

/** AI Hints */
var(Ai)                                              protected ETargetStat      	mAiTargetStatPrimary<DisplayName=Primary Target Stat>;
var(Ai)                                              protected ETargetStat      	mAiTargetStatSecondary<DisplayName=Secondary Target Stat>;
var(Ai)                                              protected float                mAiGeneralUtility<DisplayName=General Utility>;



// ----------------------------
// instance ID
var transient editoronly private bool	mTargetSelectionArea;
var transient editoronly private bool	mTargetSelectionShape;
var transient editoronly private bool	mTargetSelectionCone;

var protected int						mAbilityID;
var protected bool						mIsCasting;
var protected bool						mWasProjectileCreated;
var protected H7EventContainerStruct	mEventContainerActivateAbility;
var Vector								mImpactTargetPos;
var protected int						mSuppressCounter;
var protected EDirection				mAbilityDirection;
var protected EAbilityTarget			mTargetTypeOverride;
var protected H7IEffectTargetable		mOriginalPrimaryTarget;
var protected bool						mUnlearnAfterActivation;
var protected bool						mCastedOnce;
var protected H7USSProjectile			mValidProjectile; // might be a different projectile whether the hit is critical or not
var protected float						mValidTimerSpawnProjectile;
var protected bool						mIsHeal;
var protected array<int>	            mSunburstIndeces;
var protected array<IntPoint>	        mSunburstTargetPoints;
var protected array<H7CombatMapCell>	mSunburstOriginalTargets;
var protected bool                      mIsSummoningSpell;
var protected bool                      mIsDivingAttack;

var(Container, Ability, QuickCombat) protected int mQuickCombatNumOfTargets                     <DisplayName="Quick Combat: Number of Targets (Base)">;
var(Container, Ability, QuickCombat) protected int mQuickCombatNumOfTargetsUpgraded             <DisplayName="Quick Combat: Number of Targets (Upgraded)">;
var(Container, Ability, QuickCombat) protected bool mQuickCombatTargetType                      <DisplayName="Quick Combat: Target Type: True-Friendly, False-Enemy">;
var(Container, Ability, QuickCombat) protected array<QuickCombatImpact> mQuickCombatSubstitute  <DisplayName="Quick Combat: Effect Substitute">;

// charges
var protected int   mCurrentCharges;
var protected int   mNumCharges;

function H7EventContainerStruct GetEventContainerActivateAbility() { return mEventContainerActivateAbility; }

function OverrideTargetType( EAbilityTarget t ) { mTargetTypeOverride = t; }

function bool			                    GetQuickCombatTargetType()			    { return mQuickCombatTargetType; }
function array<QuickCombatImpact>			GetQuickCombatSubstitutes()			    { return mQuickCombatSubstitute; }
function int			                    GetQuickCombatNumOfTargets()			{ return mQuickCombatNumOfTargets; }
function int			                    GetQuickCombatNumOfTargetsUpgraded()	{ return mQuickCombatNumOfTargetsUpgraded; }

function H7USSProjectile    GetProjectile()                     { return mProjectile; }
function name               GetCasterFXSocket()                 { return name(mCasterFXS.mSocketName); }
function EUnitAnimation     GetAnimation()                      { return mAnimation; }
function bool               IsRanged()                          { return mIsRanged; }
function bool               ShouldMoveToTarget()                { return mMoveToTarget; }
function bool               ShouldTurnTowardsTarget()           { return mTurnToTarget; }
function array<IntPoint>    GetShape()                          { return mTargetShape; }
function                    SetShape( array<IntPoint> shape )   { mTargetShape = shape; }
function bool               IsCustom()                          { return GetTargetType() == TARGET_CUSTOM_SHAPE; }
function bool               IsArea()                            { return GetTargetType() == TARGET_AREA; }
function bool               IsTsunami()                         { return GetTargetType() == TARGET_TSUNAMI; }
function                    SetTargetType( EAbilityTarget type ){ mTargetType = type; }
function bool               IsSuppressed()                      { return mSuppressCounter > 0; }
function                    Suppress( bool boool )              
{ 
	if( boool )
	{
		++mSuppressCounter;
	}
	else
	{
		if( mSuppressCounter > 0 )
		{
			--mSuppressCounter;
		}
		else
		{
			//wtf
		}
	}
}
function H7AuraStruct       GetAuraData()                       { return mAuraData; }
function bool               IsAura()                            { return mAuraData.mIsAura; }
function                    SetAuraDuration( int duration )     { mAuraData.mAuraProperties.mCurrentDuration = duration; }
function int                GetAuraDuration()                   { return mAuraData.mAuraProperties.mCurrentDuration; }
function float              GetConeAngle()                      { return mTargetCone.mAngle; }
function int                GetConeRange()                      { return mTargetCone.mRange; }
function bool               GetConeDebug()                      { return mTargetCone.mDebug; }
function EDirection         GetAbilityDirection()               { return mAbilityDirection; }
function                    SetTargetCone( H7ConeStruct cone )  { mTargetCone = cone; }
function H7IEffectTargetable GetOriginalPrimaryTarget()         { return mOriginalPrimaryTarget; }
function int				GetCurrentCharges()                 { return mCurrentCharges; }
function int				GetNumCharges()                     { return mNumCharges; }     
function					SetCurrentCharges( int newValue )   { mCurrentCharges = newValue; } 
function					SetNumCharges( int newValue )       { mNumCharges = newValue; } 
function bool               UnlearnAfterActivation()            { return mUnlearnAfterActivation; }
function                    SetUnlearnAfterActivation( bool a ) { mUnlearnAfterActivation = a; }
function bool               IsTeleportSpell()                   { return mIsTeleportSpell; }
function bool               IsSummoningSpell()                  { return mIsSummoningSpell; }
function bool               IsDivingAttack()	                { return mIsDivingAttack; }
function int                GetTsunamiRows()                    { return mTsunamiRows; }
function Vector             GetImpactTargetPos()                { return mImpactTargetPos; }
function bool               GetDisableFleeSurrender()           { return mDisableFleeSurrender; }
event bool                  HasCasterFX()                       { return mCasterFXS.mVFX != none; }

function H7AuraStructProperties GetAuraProperties()             { return mAuraData.mAuraProperties; }
function StaticMeshComponent    GetConePreview()                { return mTargetCone.mPreview;  }



function bool			IsSpell()								{ return false; }
function bool           IsAbility()                             { return true; }
function bool			IsPassive()								{ return mIsPassive; }
function bool			IsGovernorEffect()						{ return mIsGovernorEffect; }
function bool			IsCasting()								{ return mIsCasting; }
function                SetCasting( bool isCasting )            { mIsCasting = IsCasting; }
native function int    	GetID();
native function EAbilityTarget GetTargetType();
function String         GetTargetClassSpecifier()               { return mTargetClassSpecifier; }
function String			GetFlashIconPath()						{ return "img://" $ Pathname( GetIcon() ); }
function bool			CanCast(optional out String blockReason){ return false; }
function int            GetPowerValue()                         { return mPowerValue; }
function IntPoint       GetTargetArea()                         { return mAreaOfEffectSize; }
function                SetTargetArea( IntPoint aoe )           { mAreaOfEffectSize = aoe; }
function bool           IsAreaFilled()                          { return mIsAreaFilled; }
function                SetAreaFilled( bool isFilled )          { mIsAreaFilled = isFilled; }
function bool           UseCameraShake()                        { return mUseCameraShake; }
function bool           IsDirectionalCast()                     { return mIsDirectionalCast; }
function bool           IsHeal()                                { return mIsHeal; }

function ETargetStat    GetAiTargetStatPrimary()                { return mAiTargetStatPrimary; }
function ETargetStat    GetAiTargetStatSecondary()              { return mAiTargetStatSecondary; }
function float          GetAiGeneralUtility()                   { return mAiGeneralUtility; }

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

// only base tags
function array<ESpellTag> GetTags() { return mTags; } 

native function bool HasTag(ESpellTag searchTag,optional bool checkAllEffectsToo=true);

native function bool IsActiveAura();

// TODO distinguish between 
// - stack has a red square (only if not-immune)
// - stack has a tooltip (but can be immune)
// - stack actually gets the effect thrown at him (but then can be immune)
function bool HighlightsRed(H7IEffectTargetable targetable)
{
	// ...
}

/**
 * Function to determine if ability is castable on a target by using its class. This function should replace the 'old' CanCastOnTarget() when we have removed all old spells.
 * 
 * checks only container-targeting and container-school&tags, also all effects
 * 
 * only checks immunity when TARGET_SINGLE
 * 
 * */
native function bool CanCastOnTargetActor( H7IEffectTargetable targetable );

native function bool CanDiveAttackTo( array<H7CombatMapCell> targetCells );

// return "unresolved result" = "old combat action"
// only used for simulations!
function H7CombatResult GenerateCombatAction(H7EventContainerStruct eventContainer)
{
	local H7CombatResult result;
	local array<H7Effect> effects,triggeredEffects;
	local H7Effect effect;
	local ETrigger event;
	local H7IEffectTargetable target;
	local array<H7IEffectTargetable> targets;

	// get all effects of this spell that are used at current rank
	GetEffects( effects, mCaster );

	;
	if(effects.Length > 1)
	{
		;
	}

	foreach effects( effect ) // we don't care if the effects are on_activate,on_impact,on_finish,or whatever, we just assume they will happen, if the ability is used
	{
		effect.ClearCachedTargets();

		event = effect.GetTrigger().mTriggerType;
		switch(event)
		{
			// list of events that DO NOT happen when activating ability (clicking)
			case ON_ABILITY_PREPARE:
			case ON_ABILITY_UNPREPARE:
			break;
			case ON_WAVE_IMPACT:
				if( effect.IsA( 'H7EffectDamage' ) && H7EffectDamage(effect).GetData().mTarget == TARGET_TARGET )
				{
					foreach eventContainer.TargetableTargets(target)
					{
						effect.SetUnitTargetOverwrite(target);
						result = H7EffectDamage( effect ).GenerateCombatAction( result );
						triggeredEffects.AddItem( effect );
					}
				}
			break;
			default:
				//`log_dui("\n\nWriting" @ effect @ "into combatresult...");
				// effects are overwriting data in the same combatAction, but this is ok for now TODO refactor simulate
				// this is essentially a "fake" execute, but instead of generating and resolving its own combatresult
				// effects write themselves into the main combatresult
				if( effect.IsA( 'H7EffectDamage' ) )
				{
					if( IsHeal() )
					{
						targets.Length = 0;
						H7EffectDamage( effect ).GetTargets( targets );
						if( targets.Length > 0 )
						{
							result = H7EffectDamage( effect ).GenerateCombatAction( result );
							triggeredEffects.AddItem( effect );
						}
					}
					else
					{
						result = H7EffectDamage( effect ).GenerateCombatAction( result );
						triggeredEffects.AddItem( effect );
					}
				}
				else if( effect.IsA( 'H7EffectWithSpells' ) )
				{
					result = H7EffectWithSpells( effect ).GenerateCombatAction( result );
					triggeredEffects.AddItem( effect );
				}
				else if( effect.IsA('H7EffectCommand'))
				{
					result = H7EffectCommand( effect ).GenerateCombatAction( result );
					triggeredEffects.AddItem( effect );
				}
				else if( effect.IsA('H7EffectSpecial') )
				{
					result = H7EffectSpecial( effect ).GenerateCombatAction( result );
					triggeredEffects.AddItem( effect );
				}
				else 
				{
					;
				}
				mCasterSnapShot.UpdateSnapShot( true, true );
				//`log_dui("Now defenders:" @ result.GetDefenderCount() @ "\n");
		}
	}

	if( result == none ) 
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(GetDebugName() @ "has no effects that can generate a combataction, can not go through combat processor",MD_QA_LOG);;
		Abort();
		return none;
	}

	if( result != none ) result.SetAttacker( mCasterSnapShot );
	result.SetContainer( self );
	result.SetEffects( triggeredEffects );
	result.SetActionId( mCaster.GetActionID(self) );

	;

	return result;
}

// checks if at least one of the targets is NOT immune (dummy check)
function bool CanAffectAtLeastOneTarget(array<H7IEffectTargetable> targets) // It is expected that this array is the array from CalculateTargets()
{
	local H7IEffectTargetable target;

	// mTarget currently contains Step 3/4 filtered targets (rank,condition,immunity(sometimes ignored))
	foreach targets(target) 
	{
		//`log_uss(target.GetName());
		if(CanCastOnTargetActor(target)) // what is not checked is container.targeting, so we do it here
		{
			//`log_uss(target.GetName() @ "can target");
			if(!TargetIsImmuneToAllExecutingEffects(target)) // check immunity
			{
				//`log_uss(target.GetName() @ "can harm");
				return true;
			}
			else
			{
				//`log_uss("----" @ target @ target.GetName() @ "is immune");
			}
		}
		else
		{
			//`log_uss("--" @ target @ target.GetName() @ "can not be targeted");
		}
	}

	return false;
}

/**
 * Activates the ability and initialises the targets.
 * 
 * REAL = a complex chain-reaction of events and listeners is triggered = x combatactionresolves (1 per Effect)
 *      = all effects are executed
 *      
 * SIMULATED = an result is generated and put through the processor = 1 combatactionresolve (1 for Effectcontainer)
 *           = main effects of this ability are actually NOT executed
 *           = only sub-effects are executed
 * 
 * @param primaryTargetable        The targetable which is being targeted
 * @param isSimulated       GUI ToolTip Simulation 
 * 
 * @return H7CombatResult only when simulated
 * 
 * */
function H7CombatResult Activate( H7IEffectTargetable primaryTargetable, bool isSimulated, optional EDirection direction = EDirection_MAX, optional H7CombatMapCell trueHitCell )
{
	local H7IEffectTargetable target;
	local H7CombatResult result;
	local H7Message message;
	local array<H7IEffectTargetable> allTargets;
	local bool delayedProjectile;
	local H7AbilityTrackingData data;

	//support cast adventure map ability event
	local H7HeroEventParam eventParam;
	local H7HeroAbility eventCastedHeroAbility;

	mOriginalPrimaryTarget = primaryTargetable;

	if( !isSimulated && H7HeroAbility( self ) != none && H7AdventureHero( mCaster ) != none )
	{
		H7AdventureHero( mCaster ).SetCastedSpellThisTurn( true );
		class'H7AdventureGridManager'.static.GetInstance().ClearFogRevealPreview();
	}

	// Trigger event
	eventCastedHeroAbility = H7HeroAbility(self);
	if ( eventCastedHeroAbility != none && H7EditorHero(mCaster) != none && eventCastedHeroAbility.IsSpell() && !isSimulated )
	{
		eventParam = new class'H7HeroEventParam';
		eventParam.mEventHeroTemplate = class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ? H7EditorHero(mCaster).GetAdventureArmy().GetHeroTemplateSource() : 
		H7EditorHero(mCaster).GetCombatArmy().GetHeroTemplateSource();
		eventParam.mEventPlayerNumber = H7EditorHero(mCaster).GetPlayer().GetPlayerNumber();
		eventParam.mEventCastedAbility = eventCastedHeroAbility;
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_HeroAbilityCasted', eventParam, H7EditorHero(mCaster));
	
		/** TRACKING **/
		if( !H7EditorHero(mCaster).GetPlayer().IsControlledByAI() && 
			 H7EditorHero(mCaster).GetPlayer().IsControlledByLocalPlayer() )
		{
			data.AbilityName = class'H7GameUtility'.static.GetArchetypePath( self );
			data.CasterName = class'H7GameUtility'.static.GetArchetypePath( H7EditorHero(mCaster).GetOriginArchetype() );
			
			if( class'H7AdventureController'.static.GetInstance() != none )
			{
				class'H7AdventureController'.static.GetInstance().AddAbilityTrackingData( data );
			}
			else 
			{
				class'H7CombatController'.static.GetInstance().AddAbilityTrackingData( data );
			}
		}

	
	
	}

	;
	;
	;
	;
	
	// update caster snapshot if necessary
	if( mCasterSnapShot.GetOriginal() == none || mCasterSnapShot.GetOriginal() != mCaster || mCasterSnapShot != mCaster )
	{
		if( H7UnitSnapShot( mCaster ) != none )
		{
			mCasterSnapShot = H7UnitSnapShot( mCaster );
			mCasterSnapShot.UpdateSnapShot();
		}
		else
		{
			mCasterSnapShot.TakeSnapShot(mCaster);
		}
	}
	else
	{
		if( mCaster != none )
			mCasterSnapShot.TakeSnapShot( mCaster );
	}

	if( IsFromScroll() )
	{
		mCasterSnapShot.SetMagic( SCROLL_MAGIC_POWER );
	}

	mWasProjectileCreated = false;

	// Step I - all targets when hovering/targeting the primaryTargetable

	CalculateTargets( primaryTargetable, mTargets, mImpactTargetPos, isSimulated, trueHitCell );
	;
	mAbilityDirection = direction;

	// Step II - Go time! (simulated or for real)

	if( !isSimulated )
	{
		;
		if( mOncePerCombat && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			mCastedOnce = true;
		}
		// play sound and reduce charges only when executed successfully
		if( H7CreatureAbility( self ) != none ) 
		{
			H7CreatureAbility( self ).ExecuteCreatureAbility();
		}
		else if ( H7WarfareAbility(self) != none )
		{
			H7WarfareAbility(self).ExecuteCreatureAbility();
		}
		else if ( H7HeroAbility(self) != none )
		{
			H7HeroAbility(self).ExecuteHeroAbility();
		}
		// log
		if(mCaster.IsA('H7EditorHero') && !H7EditorHero(mCaster).IsHero())
		{
			// No log for fake heroes
		}
		else
		{
			message = new class'H7Message';
			message.text = "MSG_ACTIVATE_ABILITY";
			message.AddRepl("%owner",GetCaster().GetName());
			message.AddRepl("%ability",GetName());
			message.destination = MD_LOG;
			message.settings.referenceObject = GetInitiator();
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}

		// ini bar special icon for heroes
		if(self.IsA('H7HeroAbility') && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
		{
			class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateAction( H7Unit(mCaster) , H7HeroAbility(self) );
		}

		if( mTimerRaiseEvents > 0 )
		{
			class'H7CombatMapGridController'.static.GetInstance().SetTimer( mTimerRaiseEvents / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, nameof( RaiseActivateAbilityEvents ), self );
		}

		// event DO ACTIVATE ABILITY
		mEventContainerActivateAbility.Action = ACTION_ABILITY;
		mEventContainerActivateAbility.Targetable = primaryTargetable;

		mEventContainerActivateAbility.TargetableTargets =  mTargets;
		GetAllTags( mEventContainerActivateAbility.ActionTag );
		mEventContainerActivateAbility.ActionSchool = GetSchool();
		mEventContainerActivateAbility.EffectContainer = self;

		if( mCaster.GetEventManager() != none )
		{
			if( mTimerRaiseEvents == 0 )
			{
				mCasterSnapShot.TriggerEvents( ON_ANY_ABILITY_ACTIVATE, false, mEventContainerActivateAbility );
			}
		}
		
		//////////////////////
		if( mTimerRaiseEvents == 0 )
		{
			GetEventManager().Raise( ON_SELF_ABILITY_ACTIVATE, isSimulated, mEventContainerActivateAbility );
		}

		mCasterSnapShot.UpdateSnapShot();
		if( mIsRanged )
		{
			// calculate the position of the projectile's impact
			if( mCaster != none )
			{
				// set correct timer
				if(H7Unit( mCaster ) != none && H7Unit( mCaster ).GetCurrentLuckType() == GOOD_LUCK && mCritProjectile != none)
				{
					mValidTimerSpawnProjectile = mTimerSpawnCritProjectile;
				}
				else
				{
					mValidTimerSpawnProjectile = mTimerSpawnProjectile;
				}

				// in case the creature is affected by ${put something that affects CustomTimeDilation here}
				if( H7CreatureStack( mOwner ) != none )
				{
					mValidTimerSpawnProjectile = mValidTimerSpawnProjectile * H7CreatureStack( mOwner ).GetCreature().CustomTimeDilation;
				}

				if( mValidTimerSpawnProjectile != 0.0f )
				{
					delayedProjectile = true;
					class'H7CombatMapGridController'.static.GetInstance().SetTimer( mValidTimerSpawnProjectile / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, nameof( DelayedDoProjectile ), self );
				}
				else
				{
					// if there is no projectile, do impact FX right away
					mWasProjectileCreated = DoProjectileAbility( mImpactTargetPos, mCaster );
				}
			}
			if( !mWasProjectileCreated && !delayedProjectile || mWasProjectileCreated && mValidProjectile.IsBeam() )
			{
				PlayHitTargetFX();
			}

			SetTargetVector( mImpactTargetPos );
		}
		else
		{
			foreach mTargets( target )
			{
				;
				DoHitTargetFX( mImpactTargetPos, target );
				
			}
			DoParticleFXImpact( mImpactTargetPos );
			Finish();
		}
		// event AFTER ACTIVATE ABILITY
		mEventContainerActivateAbility.Action = ACTION_ABILITY;
		//mEventContainerActivateAbility.TargetableTargets =  mTargets;
		GetAllTags( mEventContainerActivateAbility.ActionTag );
		mEventContainerActivateAbility.ActionSchool = GetSchool();
		mEventContainerActivateAbility.EffectContainer = self;
		if( mCaster.GetEventManager() != none )
		{
			if( mTimerRaiseEvents == 0 )
			{
				mCaster.TriggerEvents( ON_AFTER_ANY_ABILITY_ACTIVATE, false, mEventContainerActivateAbility );
			}
		}
		if( mTimerRaiseEvents == 0 )
		{

			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				class'H7CombatController'.static.GetInstance().GetAllTargetable( allTargets );
			}
			else
			{
				class'H7AdventureController'.static.GetInstance().GetAllTargetable( allTargets );
			}

			foreach allTargets( target )
			{
				if( target != none )
				{
					mEventContainerActivateAbility.Targetable = target;
					target.TriggerEvents( ON_ABILITY_ACTIVATE, false, mEventContainerActivateAbility );
				}
			}

			if( mOriginalPrimaryTarget != none )
			{
				mEventContainerActivateAbility.Targetable = mOriginalPrimaryTarget;
				mOriginalPrimaryTarget.TriggerEvents( ON_TARGET_ABILITY_ACTIVATED, false, mEventContainerActivateAbility );
			}

		}
		
		mCasterSnapShot.UpdateSnapShot();

		// ...
	}
	else
	{
		;
		// event SIMULATED DO ACTIVATE ABILITY
		mEventContainerActivateAbility.Action = ACTION_ABILITY;
		mEventContainerActivateAbility.Targetable = primaryTargetable;
		mEventContainerActivateAbility.TargetableTargets =  mTargets;
		GetAllTags( mEventContainerActivateAbility.ActionTag );
		mEventContainerActivateAbility.ActionSchool = GetSchool();
		mEventContainerActivateAbility.EffectContainer = self;

		if( mCaster.GetEventManager() != none )
		{
			mCasterSnapShot.TriggerEvents( ON_ANY_ABILITY_ACTIVATE, true, mEventContainerActivateAbility );
		}
			
		mCasterSnapShot.UpdateSnapShot( false, false );
		result = GenerateCombatAction(mEventContainerActivateAbility);
		mEventContainerActivateAbility.Result = result;
		
		GetEventManager().Raise( ON_SELF_ABILITY_ACTIVATE, true, mEventContainerActivateAbility );
		GetEventManager().Raise( ON_IMPACT, true, mEventContainerActivateAbility );		
		mCasterSnapShot.TriggerEvents( ON_AFTER_ANY_ABILITY_ACTIVATE, true, mEventContainerActivateAbility );

		mCasterSnapShot.UpdateSnapShot( false, false );

		class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().ResolveCombat( result, isSimulated, true );
		;
		mRankOverride = SR_MAX;
		if( IsSpell() )
		{
			H7HeroAbility( self ).SetMinimumRankOverride( SR_MAX );
		}
		
		return result;
	}


	
	return none;
}

function PlayHitTargetFX()
{
	local H7IEffectTargetable target;

	if( mHitTargetFXS.mSunburstTileFX )
	{
		DoSunburstBeams();
	}
	else
	{
		foreach mTargets( target )
		{
			DoHitTargetFX( mImpactTargetPos, target );
		}
	}

	Finish();
}

// called every frame while moving mouse over grid and also on click
function bool CheckValidTargets( H7IEffectTargetable target, optional array<H7IEffectTargetable> targets, optional bool isSimulated = false)
{
	local bool canCastOnAtLeastOne;
	local H7IEffectTargetable targetable;

	
	;

	;
	foreach targets(targetable)
	{
		;
	}

	foreach targets( targetable )
	{
		if( CanCastOnTargetActor( targetable ) )
		{
			canCastOnAtLeastOne = true;
		}
	}

	if( mCaster.GetEntityType() == UNIT_HERO ) 
	{
		if( GetTargetType() == TARGET_LINE || GetTargetType() == TARGET_DOUBLE_LINE || GetTargetType() == TARGET_AREA || GetTargetType() == TARGET_ELLIPSE || GetTargetType() == TARGET_SUNBURST )
		{
			// if we cannot target any target units legitimately, disallow casting
			if( target != none && !CanCastOnTargetActor( target ) && mCaster.IsDefaultAttackActive() )			
			{
				return false;
			}
			
			if( !canCastOnAtLeastOne )
			{
				;
				return false;
			}
			
		}
		else if ( GetTargetType() == NO_TARGET )
		{
			if(  self.IsA('H7HeroAbility')   )
			{
				if( !canCastOnAtLeastOne )
				{
					return false;
				}
			}
		}
		else
		{
			if( target.IsA( 'H7BaseCell' ) )
			{
				;
				targetable = H7BaseCell( target ).GetTargetable();

				if( !CanCastOnTargetActor( targetable ) )
				{
					;
					return false;
				}
			}
			else
			{
				;
				if( !CanCastOnTargetActor( target ) )
				{ 
					;
					return false;
				}
			}
		}
	}
	else if( mCaster.GetEntityType() == UNIT_CREATURESTACK )
	{
		if( GetTargetType() == TARGET_LINE || GetTargetType() == TARGET_AREA || GetTargetType() == TARGET_SWEEP || GetTargetType() == TARGET_SINGLE || GetTargetType() == TARGET_ELLIPSE || GetTargetType() == TARGET_SUNBURST || GetTargetType() == TARGET_CONE || GetTargetType() == TARGET_DOUBLE_LINE )
		{
			// if we cannot target any target units legitimately, disallow casting
			if( target.IsA( 'H7BaseCell' ) )
			{
				
				targetable = H7BaseCell( target ).GetTargetable();
				targets.AddItem( targetable );
			}
			if( target != none && !canCastOnAtLeastOne && mCaster.IsDefaultAttackActive() )
			{
				class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, mCaster.GetLocation(), mCaster.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_CANT_DEFAULT_ATTACK_INVALID_TARGET","H7FCT") );
				return false;
			}
			// if we cannot target any target units legitimately, disallow casting
			
			if( !canCastOnAtLeastOne )
			{
				if(!isSimulated) class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, mCaster.GetLocation(), mCaster.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_TARGET_FOUND","H7FCT"));
				;
				return false;
			}
		}
	}
	return true;
}

function array<H7IEffectTargetable> AICalculateAllPossibleTargets()
{
	local int i,j;
	local array<H7IEffectTargetable> validTargets,allTargets,accumulatedValidTargets;
	
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatController'.static.GetInstance().GetAllTargetable(allTargets);
		
		if (allTargets.Length <= 0 )
			return accumulatedValidTargets;

		for ( i=0;i<allTargets.Length;++i)
		{
			CalculateTargets( allTargets[i], validTargets );
			
			if( validTargets.Length >  0 ) 
			{
			
				for (j=0;j<validTargets.Length;++j)
				{
					if( accumulatedValidTargets.Find( validTargets[j] ) == -1 )
						accumulatedValidTargets.AddItem( validTargets[j] );
				}
			}
		}
	}
	else
	{
		// Not implemented yet 
	}

	return accumulatedValidTargets;
}


// 3 checks need to be done for all effects, and if at least one target comes through all checks, it's a valid target:
// 1/3 rankcheck - is the effect even activated/casted at this rank
// 2/3 conditioncheck - target + caster + attack
// 3/3 resistancecheck 
// (actually 4 checks are needed:
//      the 4. one is CanCastOnTargetActor() which is a kind of special target condition check only for abilities (the other condition checks were for effects)
//      which is done later in CheckValidTargets()
native function CalculateTargets( H7IEffectTargetable target, out array<H7IEffectTargetable> targets, optional out Vector targetPos, optional bool ignoreImmunity = false, optional H7CombatMapCell trueHitCell, optional bool skipEffectFilter );


function DelayedDoProjectile()
{
	mWasProjectileCreated = DoProjectileAbility( GetTargetVector(), mCaster );
	
	if( !mWasProjectileCreated || mWasProjectileCreated && mValidProjectile.IsBeam() )
	{
		PlayHitTargetFX();
	}
}

// base + all effects
native function GetAllTags( out array<ESpellTag> allTags );

native function Vector GetProjectileTargetLocation( Vector targetPos, H7IEffectTargetable target );

/**
 * Spawns and initializes the projectile for this ability and sets
 * the callback (delegate) functions. 
 * 
 * @param targetPos The target position where the projectile must fly
 * @param owner     The caster of the ability
 * 
 * @return          Whether the projectile was spawned or not
 * */
function bool DoProjectileAbility( Vector targetPos, H7ICaster owner )
{
	local H7USSProjectile proj;
	local H7CombatMapGridController gridController;
	local Vector spawnPos;
	
	gridController = class'H7CombatMapGridController'.static.GetInstance();

	if(H7Unit( owner ) != none && H7Unit( owner ).GetCurrentLuckType() == GOOD_LUCK && mCritProjectile != none)
	{
		mValidProjectile = mCritProjectile;
	}
	else
	{
		mValidProjectile = mProjectile;
	}
	
	if( mValidProjectile != none )
	{
		if( mProjectileFiringSound != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
		{
			class'H7SoundManager'.static.PlayAkEventOnActor( gridController, mProjectileFiringSound,true,true, mValidProjectile.Location);
		}

		if( Actor( owner ) != none )
		{
			spawnPos = owner.IsA('H7Unit') ? H7Unit(mCaster).GetSocketLocation( H7Unit(mCaster).GetProjectileStartSocketName() ) : owner.GetLocation();
			if(mValidProjectile.GetProjectileType() == PT_AIRDROP) { spawnPos.Z = mValidProjectile.GetAirdropHeight();  }
			proj = gridController.Spawn( class'H7USSProjectile',H7EditorHero( owner ) != none ? gridController : Actor( owner ) ,,spawnPos ,, mValidProjectile );
		}
		else
		{
			spawnPos = owner.IsA('H7Unit') ? H7Unit(mCaster).GetSocketLocation( H7Unit(mCaster).GetProjectileStartSocketName() ) : owner.GetLocation();
			if(mValidProjectile.GetProjectileType() == PT_AIRDROP) { spawnPos.Z = mValidProjectile.GetAirdropHeight();  }
			proj = class'H7CombatMapGridController'.static.GetInstance().Spawn( class'H7USSProjectile',gridController,,spawnPos ,, mValidProjectile );
		}

		if( mValidProjectile.IsBeam() )
		{
			proj.InitForLocation( targetPos, mTargets, self );
		}
		else
		{
			proj.InitForLocation( targetPos, mTargets, self, Finish, HitUnit );
		}

		return proj != none;
	}
	
	return false;
}

function DoSunburstBeams()
{
	local H7CombatMapCell origin, current;
	local Rotator rot;
	local int i, index;

	index = 0;
	origin = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( mOriginalPrimaryTarget.GetGridPosition() );
	current = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( mSunburstTargetPoints[index] );

	for( i=0; i<mSunburstOriginalTargets.Length; ++i )
	{
		if( i > mSunburstIndeces[index] && index < mSunburstIndeces.Length )
		{
			++index;
			current = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint(  mSunburstTargetPoints[index] );
		}

		rot = Rotator( origin.GetCenterPos() - current.GetCenterPos() );
		mSunburstOriginalTargets[i].GetEffectManager().AddToFXQueue( mHitTargetFXS, mInstanciatedEffects[0], false, , mSunburstOriginalTargets[i].GetLocation(), true, rot );
	}
}

function Rotator GetRotatorForDirection( EDirection dir )
{
	local Rotator rot;
	switch( dir )
	{
		case NORTH:
			rot.Yaw = DegToUnrRot * 270;
			break;
		case NORTH_EAST:
			rot.Yaw = DegToUnrRot * 315;
			break;
		case EAST:			          
			rot.Yaw = DegToUnrRot * 0;
			break;
		case SOUTH_EAST:
			rot.Yaw = DegToUnrRot * 45;
			break;
		case SOUTH:			
			rot.Yaw = DegToUnrRot * 90;
			break;
		case SOUTH_WEST:
			rot.Yaw = DegToUnrRot * 135;
			break;
		case WEST:			          
			rot.Yaw = DegToUnrRot * 180;
			break;
		case NORTH_WEST:
			rot.Yaw = DegToUnrRot * 225;
			break;
		default:
	}
	return rot;
}

/**
 * Will spawn a particle system at a point of impact.
 * 
 * @param targetLocation    The location where the PS must spawn, if provided
 * 
 * */
function bool DoParticleFXImpact( optional Vector targetLocation = vect(0,0,0), optional H7IEffectTargetable target = none )
{
	local ParticleSystemComponent emitter;
	local Rotator casterRotation;

	if( H7CreatureStack( mCaster ) != none )
	{
		casterRotation = H7CreatureStack( mCaster ).GetCreature().Rotation;
	}
	else if( H7EditorHero( mCaster ) != none )
	{
		casterRotation = H7EditorHero( mCaster ).Rotation;
	}
	else if( H7TowerUnit( mCaster ) != none )
	{
		casterRotation = H7TowerUnit( mCaster ).Rotation;
	}

	if( mImpactFXS.mVFX != none )
	{
		if(mImpactFXS.mUseCasterPosition && mCaster != none && mCaster.GetEffectManager() != none)
		{
			// for NO_TARGET + adventure map + hero spell + use caster pos
			mCaster.GetEffectManager().AddToFXQueue( mImpactFXS, mInstanciatedEffects[0],,,targetLocation,,GetRotatorForDirection( mAbilityDirection ) );
		}
		else if( target != none && target.GetEffectManager() != none )
		{
			if( mIsDirectionalCast )
			{
				target.GetEffectManager().AddToFXQueue( mImpactFXS, mInstanciatedEffects[0],,,targetLocation,,GetRotatorForDirection( mAbilityDirection ) );
			}
			else
			{
				if( mValidProjectile != none && mValidProjectile.GetProjectileType() != PT_AIRDROP && !mIsDirectionalCast )
				{
					target.GetEffectManager().AddToFXQueue( mImpactFXS, mInstanciatedEffects[0],,,targetLocation,,casterRotation);
				}
				else
				{
					target.GetEffectManager().AddToFXQueue( mImpactFXS, mInstanciatedEffects[0],,,targetLocation,,GetRotatorForDirection( mAbilityDirection ) );
				}
			}
		}
		else
		{
			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				if( mValidProjectile != none && mValidProjectile.GetProjectileType() != PT_AIRDROP && !mIsDirectionalCast )
				{
					class'H7CombatMapGridController'.static.GetInstance().GetEffectManager().AddToFXQueue( mImpactFXS, mInstanciatedEffects[0],,,targetLocation,,casterRotation );
				}
				else
				{
					class'H7CombatMapGridController'.static.GetInstance().GetEffectManager().AddToFXQueue( mImpactFXS, mInstanciatedEffects[0],,,targetLocation,,GetRotatorForDirection( mAbilityDirection ) );
					if(target != none)
					{
						target.GetEffectManager().AddToFXQueue( mImpactFXS, mInstanciatedEffects[0],,,targetLocation,,GetRotatorForDirection( mAbilityDirection ) );
					}
				}
			}
			else
			{
				emitter = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter( mImpactFXS.mVFX, targetLocation );
				class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( emitter );
				emitter.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();

				if(mHitTargetFXS.mSFX != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible() )
				{
					emitter.Owner.PlayAkEvent(mHitTargetFXS.mSFX,true,,true,targetLocation);
				}
			}
		}
	}

	if( mUseCameraShake && mCameraShake != none )
	{
		if( mCameraShakeDelay > 0.f )
		{
			class'H7Camera'.static.GetInstance().SetTimer( mCameraShakeDelay, false, NameOf(PlayCameraShakeDelayed), self );
		}
		else
		{
			class'H7Camera'.static.GetInstance().PlayCameraShake( mCameraShake, 1.0f );
		}
	}
	
	if( mProjectileHitSound != none && mValidProjectile != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( class'H7CombatMapGridController'.static.GetInstance(), mProjectileHitSound, true,true, mValidProjectile.Location );
	}

	return ( mImpactFXS.mVFX != none );
}

function PlayCameraShakeDelayed()
{
	class'H7Camera'.static.GetInstance().PlayCameraShake( mCameraShake, 1.0f );
}

/**
 * Will spawn a particle system at a point of impact.
 * 
 * @param targetLocation    The location where the PS must spawn, if provided
 * 
 * */
function bool DoHitTargetFX( optional Vector targetLocation = vect(0,0,0), optional H7IEffectTargetable target = none )
{
	local ParticleSystemComponent emitter;

	if( mHitTargetFXS.mVFX != none )
	{
		if( target != none && target.GetEffectManager() != none )
		{
			target.GetEffectManager().AddToFXQueue( mHitTargetFXS, mInstanciatedEffects[0],,,targetLocation );
		}
		else
		{
			emitter = class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter( mHitTargetFXS.mVFX, targetLocation );
			class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( emitter );
			emitter.CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();
				
			if(mHitTargetFXS.mSFX != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
			{
				emitter.Owner.PlayAkEvent(mHitTargetFXS.mSFX,true,,true, targetLocation);
			}
		}
	}

	return ( mHitTargetFXS.mVFX != none );
}

/**
 * Will spawn a particle system at the caster's location.
 * 
 * 
 * */
event bool DoParticleFXCaster( H7ICaster caster )
{
	if( ( mCasterFXS.mVFX != none || mCasterFXS.mSFX != none ) && 
		caster.GetEffectManager() != none && 
		( !mCasterNoDuplicateFXS || ( mCasterNoDuplicateFXS && !caster.GetEffectManager().HasDuplicate( mCasterFXS ) ) ) )
	{
		caster.GetEffectManager().AddToFXQueue( mCasterFXS, mInstanciatedEffects[0] );
		return true;
	}

	return false;
}


/**
 * Animation has hit this unit
 * 
 * @param target      The target that was hit
 * 
 * */
function HitUnit( H7IEffectTargetable target )
{
	local H7EventContainerStruct container;

	if( mValidProjectile != none && mValidProjectile.IsBeam() )
	{
		return;
	}
 
	container.Targetable = target;
    container.ActionTag = mTags;
	container.ActionSchool = GetSchool();
	container.EffectContainer = self;

	;

	// raise the event in hitted unit
	if( mTimerRaiseEvents > 0 )
	{
		class'H7CombatMapGridController'.static.GetInstance().SetTimer( mTimerRaiseEvents / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, nameof( RaiseGetImpactEvent ), self );
	}
	else
	{
		target.TriggerEvents(ON_GET_IMPACT, false, container);

		if( target != none )
		{
			DoHitTargetFX( GetTargetVector(), target );
		}
		else
		{
			;
		}
	}
}

/**
 * Finishes the animation
 * 
 * */
function Finish()
{
	local H7EventContainerStruct container;
 
	container.Targetable = GetTarget();
    container.ActionTag = mTags;
	container.ActionSchool = GetSchool();
	container.TargetableTargets = GetTargets();
	container.EffectContainer = self;

	;
	DoParticleFXImpact( mImpactTargetPos );

	// raise the event in the ability
	if( mTimerRaiseEvents > 0 )
	{
		class'H7CombatMapGridController'.static.GetInstance().SetTimer( mTimerRaiseEvents / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, nameof( RaiseImpactEventAndFinish ), self );
	}
	else
	{
		GetEventManager().Raise( ON_IMPACT, false, container );
		mIsCasting = false;
		mTargets.Length = 0;
		mRankOverride = SR_MAX;
		if( IsSpell() )
		{
			H7HeroAbility( self ).SetMinimumRankOverride( SR_MAX );
		}
		mTargetTypeOverride = EAbilityTarget_MAX;
	}

	if( IsFromScroll() )
	{
		H7HeroItem( mSourceContainer ).GetOwner().GetAbilityManager().RemoveScrollSpell( self, mSourceContainer, true);
	}
	if( mUnlearnAfterActivation )
	{
		mCaster.GetAbilityManager().UnlearnVolatileAbility( self );
	}
	GetEventManager().Raise( ON_FINISH, false );
}

function bool IsFromScroll()
{
	return H7HeroItem( mSourceContainer ) != none && H7HeroItem( mSourceContainer ).GetType() == ITYPE_SCROLL;
}

protected function RaiseImpactEventAndFinish()
{
	local H7EventContainerStruct container;

	container.Targetable = GetTarget();
    container.ActionTag = mTags;
	container.ActionSchool = GetSchool();
	container.EffectContainer = self;

	GetEventManager().Raise( ON_IMPACT, false, container );

	mTargets.Length = 0;

	mIsCasting = false;
	mRankOverride = SR_MAX;
	if( IsSpell() )
	{
		H7HeroAbility( self ).SetMinimumRankOverride( SR_MAX );
	}
	mTargetTypeOverride = EAbilityTarget_MAX;
}

protected function RaiseGetImpactEvent()
{
	local H7EventContainerStruct container;
	local H7IEffectTargetable target;

	container.Targetable = GetTarget();
	container.ActionTag = mTags;
	container.ActionSchool = GetSchool();
	container.EffectContainer = self;

	GetEventManager().Raise( ON_GET_IMPACT, false, container );

	foreach mTargets( target )
	{
		DoHitTargetFX( GetTargetVector(), target );
	}
}

protected function RaiseActivateAbilityEvents()
{
	local array<H7IEffectTargetable> allTargets;
	local H7IEffectTargetable target;

	// event DO ACTIVATE ABILITY
	mEventContainerActivateAbility.Action = ACTION_ABILITY;
	mEventContainerActivateAbility.Targetable = mOriginalPrimaryTarget;
	mEventContainerActivateAbility.TargetableTargets =  mTargets;
	GetAllTags( mEventContainerActivateAbility.ActionTag );
	mEventContainerActivateAbility.ActionSchool = GetSchool();
	mEventContainerActivateAbility.EffectContainer = self;

	if( mCaster.GetEventManager() != none )
	{
		mCaster.TriggerEvents( ON_ANY_ABILITY_ACTIVATE, false, mEventContainerActivateAbility );
	}
	//////////////////////
	GetEventManager().Raise( ON_SELF_ABILITY_ACTIVATE, false, mEventContainerActivateAbility );

	// event AFTER ACTIVATE ABILITY
	mEventContainerActivateAbility.Action = ACTION_ABILITY;
	GetAllTags( mEventContainerActivateAbility.ActionTag );
	mEventContainerActivateAbility.ActionSchool = GetSchool();
	mEventContainerActivateAbility.EffectContainer = self;
	if( mCaster.GetEventManager() != none )
	{
		mCaster.TriggerEvents( ON_AFTER_ANY_ABILITY_ACTIVATE, false, mEventContainerActivateAbility );
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatController'.static.GetInstance().GetAllTargetable(allTargets);
	}
	else
	{
		class'H7AdventureController'.static.GetInstance().GetAllTargetable( allTargets );
	}

	foreach allTargets( target )
	{
		if( target != none )
		{
			mEventContainerActivateAbility.Targetable = target;
			target.TriggerEvents( ON_ABILITY_ACTIVATE, false, mEventContainerActivateAbility );
		}
	}

}

/**
 * Aborts the activation
 * 
 * */
function Abort()
{
	mIsCasting = false;
}

function ModifyAttackDamage( out float attackDamage ){}
function GetPath( out array<H7CombatMapCell> path ) {}

function OnInit( H7ICaster caster, optional H7EventContainerStruct container, optional int abilityID )
{

	if(IsArchetype()) 
	{
		return;
	}

	SetCaster(caster); 
	
	if(mAbilityID == 0 || !IsArchetype())
	{
		mAbilityID = abilityID > 0 ? abilityID : class'H7ReplicationInfo'.static.GetInstance().GetNewID();
		
		mTargetTypeOverride = EAbilityTarget_MAX;
		// instanciate of all effects for this ability  
		InstanciateEffectsFromStructData();

		//Do not raise events during adventure init, as we might not have all potential targets/casters initialised...
		if( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().IsInitialized() || class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			GetEventManager().Raise(ON_INIT,false, container);
		}
	}
}

function InstanciateEffectsFromStructData(optional bool registerEffects=true)
{
	local H7EffectProperties auraEffect;
	local H7DurationEffect durationEffect;
	local H7DurationModifierEffect durationModifierEffect;
	local H7SpecialEffect specialEffect;
	local H7Effect effect;
	local H7IEffectDelegate provider;

	super.InstanciateEffectsFromStructData(registerEffects);

	// check if this ability can summon stuff (necessary to avoid cast outside of grid)
	foreach mSpecialEffects( specialEffect )
	{
		// check for special stuff like summoning spells and Diving Attack
		provider = specialEffect.mFunctionProvider;
		if( H7EffectSpecialSummonCreatureStack( provider ) != none && !H7EffectSpecialSummonCreatureStack( provider ).DoesCopyStack() ) { mIsSummoningSpell = true; break; }
		if( H7EffectSpecialRemoveCreatureFromGrid( provider ) != none || H7EffectSpecialReappearCreatureOnGrid( provider ) != none ) { mIsDivingAttack = true; break; }
	}

	// check if this is a healing ability (necessary to avoid move_attacks with Cabir or weird get_attack event bullshittery)
	mIsHeal = ( HasTag(TAG_HEAL, true) || HasTag(TAG_REPAIR, true) || HasTag(TAG_RESURRECT, true) );

	// don't init aura specific effects if this thing isn't an aura
	if( !mAuraData.mIsAura ) return;

	foreach mAuraData.mAuraProperties.mInitAuraEffects( auraEffect )
	{
		effect = new class'H7EffectInitAura';
		H7EffectInitAura( effect ).InitSpecific( auraEffect, self, registerEffects );
		mInstanciatedEffects.AddItem( effect );
	}

	foreach mAuraData.mAuraProperties.mDestroyAuraEffects( auraEffect )
	{
		effect = new class'H7EffectDestroyAura';
		H7EffectDestroyAura( effect ).InitSpecific( auraEffect, self, registerEffects );
		mInstanciatedEffects.AddItem( effect );
	}

	foreach mAuraData.mAuraProperties.mDuration( durationEffect )
	{
		effect = new class'H7EffectDuration';
		H7EffectDuration( effect ).InitSpecific( durationEffect, self, registerEffects );
		mInstanciatedEffects.AddItem( effect );
	}

	foreach mAuraData.mAuraProperties.mDurationModifier( durationModifierEffect )
	{
		effect = new class'H7EffectDurationModifier';
		H7EffectDurationModifier( effect ).InitSpecific( durationModifierEffect, self, registerEffects );
		mInstanciatedEffects.AddItem( effect );
	}
}

function string GetTooltipForCaster(H7ICaster caster, optional bool resetRankOverride = true, optional ESkillRank effectOfRanks = SR_ALL_RANKS )
{
	local H7BaseAbility tmpAbility;
	local H7ICaster prevOwner;
	local string tt;

	if(IsArchetype())
	{
		tmpAbility = new self.Class(self);
		tmpAbility.SetCaster(caster);
		tt = tmpAbility.GetTooltip(,,,resetRankOverride);
	}
	else
	{
		prevOwner = mCaster;
		mCaster = caster;
		tt = GetTooltip(,,,resetRankOverride);
		mCaster = prevOwner;
	}
	return tt;
}

// overwritten from H7EffectContainer, decides the switch to 1 of the 3 versions here
function string	GetTooltipLocalized( H7ICaster initiator )	                                           
{
	if(IsUpgraded( initiator ) && mTooltipUpgraded != "")
	{
		return GetTooltipUpgradedLocalized();
	}
	else if(IsInMagicGuild() && mTooltipMagicGuild != "")
	{
		return GetTooltipMagicGuildLocalized();
	}
	else
	{
		return super.GetTooltipLocalized( initiator );
	}
}

function bool IsUpgraded( H7ICaster initiator )
{
	local array<H7Effect> effects;
	local H7Effect effect;
	
	if(initiator == none) return false;

	if(mUpradeAbility != none)
	{
		return initiator.GetAbilityManager().HasAbility(mUpradeAbility);
	}

	// search if there is one effect that requires an ability
	GetEffects(effects,initiator);
	foreach effects(effect)
	{
		if(effect.GetConditons().mExtededAbilityParameters.UseHasAbility 
			&& effect.GetConditons().mExtededAbilityParameters.AbilityOp == OP_TYPE_BOOL_EQUAL
			&& effect.GetConditons().mExtededAbilityParameters.HasAbility != none)
		{
			// found one, check if initiator has it
			return initiator.GetAbilityManager().HasAbility(effect.GetConditons().mExtededAbilityParameters.HasAbility);
		}
	}

	return false;
}

function bool IsInMagicGuild()
{
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		return class'H7TownHudCntl'.static.GetInstance().IsInTownScreen() && class'H7MagicGuildPopupCntl'.static.GetInstance().IsActive();
	}
	else
	{
		return false;
	}
}


function string GetTooltipMagicGuildRankLineLocalized()
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		if( mTooltipMagicGuildRankLineLocalized == "")
		{
			mTooltipMagicGuildRankLineLocalized = class'H7Loca'.static.LocalizeContent( self, "mTooltipMagicGuildRankLine", mTooltipMagicGuildRankLine );
			mTooltipMagicGuildRankLineLocalized = ApplyHelperReplacements(mTooltipMagicGuildRankLineLocalized);
		}
		return mTooltipMagicGuildRankLineLocalized;
	}
	else
	{
		return H7BaseAbility( ObjectArchetype ).GetTooltipMagicGuildRankLineLocalized();
	}
}

// returns magic guild tooltip
function string	GetTooltipMagicGuildLocalized()	                                           
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		if( mTooltipMagicGuildLocalized == "")
		{
			mTooltipMagicGuildLocalized = class'H7Loca'.static.LocalizeContent( self, "mTooltipMagicGuild", mTooltipMagicGuild );
			mTooltipMagicGuildLocalized = ApplyHelperReplacements(mTooltipMagicGuildLocalized);
		}
		return mTooltipMagicGuildLocalized;
	}
	else
	{
		return H7BaseAbility( ObjectArchetype ).GetTooltipMagicGuildLocalized();
	}
}

// returns upgraded tooltip
function string	GetTooltipUpgradedLocalized()	                                           
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		if( mTooltipUpgradedLocalized == "")
		{
			mTooltipUpgradedLocalized = class'H7Loca'.static.LocalizeContent( self, "mTooltipUpgraded", mTooltipUpgraded );
			mTooltipUpgradedLocalized = ApplyHelperReplacements(mTooltipUpgradedLocalized);
		}
		return mTooltipUpgradedLocalized;
	}
	else
	{
		return H7BaseAbility( ObjectArchetype ).GetTooltipUpgradedLocalized();
	}
}

function String GetEffectOnRankAsLine(ESkillRank rank) // getrankline
{
	local string tooltip;

	if(GetTooltipMagicGuildRankLineLocalized() != "" && GetTooltipMagicGuildRankLineLocalized() != "mTooltipMagicGuildRankLine")
	{
		// we need to tell all sub objects (buffs) that they should only consider effects from a certain rank
		tooltip = GetTooltip(false,GetTooltipMagicGuildRankLineLocalized(),rank);

		if(tooltip != "")
		{
			// <b> does not work atm
			// tooltip = "<b><font color='" $ class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.UnrealColorToHTMLColor(class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.mReplacementColor) $ "'>" $ `Localize("H7Abilities",String(rank),"MMH7Game") $ "</font>:</b>" @ tooltip;
			tooltip = "<b>" $ class'H7Loca'.static.LocalizeSave(String(rank),"H7Abilities") $ ":</b>" @ tooltip;
		}

		return tooltip;
	}
	else
	{
		return super.GetEffectOnRankAsLine(rank);
	}
}

function string GetTooltip(optional bool extendedVersion,optional string overwriteBaseString,optional ESkillRank considerOnlyEffectsOfRank=SR_ALL_RANKS, optional bool resetRankOverride = true)
{
	local H7BaseAbility tmpAbility;
	
	if(IsArchetype())
	{
		tmpAbility = new self.Class(self);
		tmpAbility.SetCaster( mCaster );
		tmpAbility.SetOwner( mCaster );
		return tmpAbility.GetTooltip(extendedVersion);
	}

	if(GetTargetType() == EAbilityTarget_MAX) class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(GetDebugName() @ "has a corrupted Target Type entry",MD_QA_LOG);;

	// why do we need this here, if super.GetTooltip does it as well? GetAllTags needs it, leave it. (for now)
	if(!mInstanciatedEffectsDone)
	{
		mInstanciatedEffectsByTooltip = true;
		InstanciateEffectsFromStructData();
	}

	mEventContainerActivateAbility.TargetableTargets =  mTargets;
	GetAllTags( mEventContainerActivateAbility.ActionTag );
	mEventContainerActivateAbility.ActionSchool = GetSchool();
	mEventContainerActivateAbility.EffectContainer = self;

	if( mCaster != none && mCaster.GetEventManager() != none )
	{
		mCaster.TriggerEvents( ON_ANY_ABILITY_ACTIVATE, true, mEventContainerActivateAbility );
	}
	
	if( IsFromScroll() && GetCaster() != none )
	{
		mCasterSnapShot.TakeSnapShot( GetCaster().GetOriginal() );
		mCasterSnapShot.SetMagic( SCROLL_MAGIC_POWER );
		mCaster = mCasterSnapShot;
	}
	else if( mCasterSnapShot != none ) mCasterSnapShot.UpdateSnapShot();
	
	return super.GetTooltip(extendedVersion,overwriteBaseString,considerOnlyEffectsOfRank,resetRankOverride);
}

function EHeroAnimation GetHeroAnimation()
{
	switch( mAnimation )
	{
		case UAN_MELEE_ATTACK:
			return HA_ATTACK;
		case UAN_RANGED_ATTACK:
			return HA_ATTACK;
		case UAN_ABILITY:
		case UAN_ABILITY2:
			return HA_ABILITY;
		case UAN_DEFEND:
			return HA_ATTACK; // hero doesnt have a defend animation
		case UAN_VICTORY:
			return HA_VICTORY;
		case UAN_NONE:
			return HA_NONE;
	}

	;
	return HA_ATTACK;
}

function ECreatureAnimation GetCreatureAnimation()
{
	switch( mAnimation )
	{
		case UAN_MELEE_ATTACK:
			return CAN_ATTACK;
		case UAN_RANGED_ATTACK:
			return CAN_RANGE_ATTACK;
		case UAN_ABILITY:
			return CAN_ABILITY;
		case UAN_ABILITY2:
			return CAN_ABILITY2;
		case UAN_DEFEND:
			return CAN_DEFEND;
		case UAN_VICTORY:
			return CAN_VICTORY;
		case UAN_NONE:
			return CAN_NONE;
	}

	;
	return CAN_ATTACK;
}

native function bool RevealsFog();
native function int GetFogRevealRadius( H7AdventureHero hero );

