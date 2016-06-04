//=============================================================================
// H7BaseBuff
//=============================================================================
//
// ...
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BaseBuff extends H7EffectContainer
	hidecategories(Object)
	native(Tussi)
	savegame;

 
// Only needed if mIsPermanent is false, duration in turns
// true = debuff, false = buff
var(Container,Buff) protected bool				                  mIsDebuff<DisplayName=Debuff>;
// buff can not be removed or changed
var(Container,Buff) protected bool				                  mIsFromMagicSource<DisplayName=Is From Magic Source>; 
// can be buffed by multiple sources
var(Container,Buff) protected bool                                mIsMultipleBuffable<DisplayName=Multiple Buffable>;
/** If the buff is stackable, it can be applied to the same target multiple times if casted by the same source. **/
var(Container,Buff) protected bool                                mIsStackable<DisplayName=Buff is stackable>;
/** The maximum amount of buffs that can be stacked. (0=no limit) */
var(Container,Buff) protected int                                 mMaximumStackables<DisplayName=Max amount of stacked buffs|EditCondition=mIsStackable>;

var(Container,Buff) protected array<H7DurationEffect>             mDurationEffects<DisplayName=Duration>;
var(Container,Buff) protected array<H7DurationModifierEffect>     mDurationModifierEffects<DisplayName=Duration Modifier>;
var(Container,Buff) protected array<ESpellTag>                    mTags<DisplayName=Tags>;
var(Container,Buff) protected bool                                mIsCombatBuff<DisplayName=Is Combat Buff>;
var(Container,Buff) protected bool                                mIsOverPortrait<DisplayName=Gets Displayed over Creature Portrait>;
var(Container,Buff) protected EFloatingTextOptions                mFloatingTextOption<DisplayName=Display Buffname Floating Text|ToolTip=Floating Text will be shown when the Buff is applied (only applies to buff name, stats are independent)>;
var(Container,Buff) protected ELogTextOptions                     mLogTextOption<DisplayName=Display Buff Happenings in Log|ToolTip=Log Text will be shown when the Buff is applied or removed>;


// internal vars ...
var transient protected int	                    mDuration;
var transient protected int						mCurrentDuration;
var transient protected bool					mIsActive;
var transient protected array<H7SimDuration>    mSimDurations;

function AddSimulatedDuration( H7Effect effect, int duration )
{
	local H7SimDuration newDuration;

	if( effect == none ) return;

	if( mSimDurations.Find( 'effect', effect ) == INDEX_NONE )
	{
		newDuration.effect = effect;
		newDuration.newDuration = duration;

		mSimDurations.AddItem( newDuration );
	}
}

native function int GetSimulatedDuration();

function ResetSimDuration()
{
	mSimDurations.Length = 0;
}

function bool                       IsCombatBuff()                  { return mIsCombatBuff; }

function bool                       IsBuff()                        { return true; }
function Texture2D		            GetIcon()			            { if(super.GetIcon() == none) return Texture2D'H7AbilityIcons.Defend'; else return super.GetIcon(); }
function String			            GetFlashIconPath()	            { return "img://" $ Pathname( GetIcon() ); }
function int			            GetDuration()		            { return mDuration; }
function                            SetDuration( int value )        { mDuration = value; }
function bool			            IsDebuff()			            { return mIsDebuff; }
function bool			            IsActive()			            { return mIsActive; }
function 			                SetActive( bool isActive )      { mIsActive = IsActive; }
function int                        GetCurrentDuration()            { return mCurrentDuration; }
function bool			            IsFromMagicSource()             { return mIsFromMagicSource; }
native function array<ESpellTag>	GetTags();
function bool                       IsMultipleBuffable()            { return mIsMultipleBuffable; }
function bool                       IsStackable()                   { return mIsStackable; }
function int                        GetMaxAmountStackable()         { return mMaximumStackables; }
function bool                       IsOverPortrait()                { return mIsOverPortrait; }
function EFloatingTextOptions       GetFloatingTextOption()         { return mFloatingTextOption; }
function ELogTextOptions            GetLogTextOption()              { return mLogTextOption; }

function array<H7DurationModifierEffect> GetDurationModifierEffects() { return mDurationModifierEffects; }
function SetDurationModifierEffects( array<H7DurationModifierEffect> effects ) { mDurationModifierEffects = effects; }


function ETrigger GetDurationModifierTrigger()
{
	if( mDurationModifierEffects.Length == 0 ) return ETrigger_MAX;

	return mDurationModifierEffects[0].mTrigger.mTriggerType;
}

function Init( optional H7IEffectTargetable target, optional H7ICaster caster, optional bool simulate=false)
{
	local H7EventContainerStruct container;

	if( mInstanciatedEffects.Length > 0 )
	{
		;
		return;
	}

	SetTarget(target);
	SetCaster(caster);
	if(H7ICaster(target) != none) { SetOwner(H7ICaster(target)); } // buffed unit owns the buff, but might not be the caster
	if( caster != none && H7UnitSnapShot( caster ) != none ) mCasterSnapShot = H7UnitSnapShot( caster );
	else if( caster != none ) { mCasterSnapShot = new class'H7UnitSnapShot'(); mCasterSnapShot.TakeSnapShot( caster ); }
	;
	InstanciateEffectsFromStructData(!simulate); // effects are always instanciated but simulate will not register them, so they never trigger and execute

	container.EffectContainer = self;
	container.Targetable = target;

	if( class'H7AdventureController'.static.GetInstance() != none || class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		GetEventManager().Raise(ON_INIT, simulate, container );
	}
	OnApply(simulate);
	GetEventManager().UnregisterBySource( self, ON_INIT );
	
	;
}


function InstanciateEffectsFromStructData(optional bool registerEffects=true) 
{
	local H7DurationModifierEffect durationModifierEffect;
	local H7DurationEffect  durationEffect;
	local H7Effect effect; 

	super.InstanciateEffectsFromStructData(registerEffects);
	
	// initialize Duration
	foreach mDurationEffects(durationEffect)
	{
		effect = new class 'H7EffectDuration';
		H7EffectDuration(effect).InitSpecific(durationEffect,self,registerEffects);
		mInstanciatedEffects.AddItem( effect ); 

		if(durationEffect.mTrigger.mTriggerType != ON_INIT)
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(GetDebugName() @ "duration effects must trigger ON_INIT",MD_QA_LOG);;
		}
	}
	
	foreach mDurationModifierEffects(durationModifierEffect)
	{
		effect = new class 'H7EffectDurationModifier';
		H7EffectDurationModifier(effect).InitSpecific(durationModifierEffect,self,registerEffects);
		mInstanciatedEffects.AddItem(effect);
	}
}

function OnApply(optional bool simulate=false)
{
	if(GetTarget() == none)
	{
		;
	}
	else
	{
		;
	}

	mCurrentDuration = GetDuration(); // GetDuration() contains the result created by triggering and executing durationini effects

	if(simulate && !IsArchetype() && mCurrentDuration == 0) // we have a tmp instanciated buff for a tooltip that failed to get it's duration (because effects are not registered, so did not trigger and execute)
	{
		mCurrentDuration = GetWouldBeDurationIfInitedProperly();
	}
}

function int GetWouldBeDurationIfInitedProperly() // self is an instance, but with unregistered instanciated effects
{
	local int i;
	// since we are scared to register instanciated effects, try to hack some stuff with the raw data
	if(mDurationEffects.Length == 1)
	{
		return mDurationEffects[0].mDuration.MaxValue;
	}
	else
	{
		// check which one applies
		for(i=0;i<mDurationEffects.Length;i++)
		{
			//`log_dui(self @ GetName() @ ObjectArchetype @ "checking duration effect i" @ i @ "for" @ mCaster @ mCaster.GetName() );
			if(class'H7Effect'.static.CasterConditionCheckOnArchetype(mDurationEffects[i].mConditions.mExtededAbilityParameters,mCaster,none,none))
			{
				//`log_dui(" yes, returning" @ i $ "'s duration:" @ mDurationEffects[i].mDuration.MaxValue);
				// found 1; good enough for me
				return mDurationEffects[i].mDuration.MaxValue;
			}
		}
	}
	return 0; // failed anyway :-(
}

function SetCurrentDuration( int value, optional bool updateGUI = true ) 
{
	local bool change;
	local H7ICaster initiator;
	change = mCurrentDuration != value;

	;

	mCurrentDuration = value; 

	if(change) 
	{
		if(class'H7CombatHud'.static.GetInstance() != none && updateGUI)
		{
			if(mTargets.Length > 0)
			{
				class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateBuffs( H7Unit(mTargets[0]) );
			}
			else// if(mCaster != none || mOwner != none)
			{
				initiator = GetInitiator();
				if(H7Unit(initiator) != none)
					class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateBuffs(H7Unit(initiator));
			}
		}
	}
} 

function OnExpire( optional bool expireCompletely = true )
{
	local H7EventContainerStruct ecs;
	local H7Effect eff;

	;

	if( ChangesInitiative() && class'H7CombatController'.static.GetInstance().GetInitiativeQueue() != none )
	{
		if( H7Unit( mOwner ) != none && H7Unit( mOwner ).IsDead() )
		{
			// dying dudes update the initiative queue anyway
		}
		else
		{
			class'H7CombatController'.static.GetInstance().GetInitiativeQueue().Sort();
		}
	}

	if( H7CreatureStack( mOwner ) != none )
	{
		if( H7CreatureStack( mOwner ).HasStasisBuff( self ) )
		{
			H7CreatureStack( mOwner ).RemoveStasisBuff( self );
		}
	}

	if( H7VisitableSite( mOwner ) != none )
	{
		H7VisitableSite( mOwner ).ReorderBuffFlags( self );
	}

	foreach mInstanciatedEffects( eff )
	{
		if(eff.GetFx().mIsPermanentFX)
		{
			mOwner.GetEffectManager().RemovePermanentFXByEffect( eff );
			if(eff.GetFx().mMaterialFX.Length > 0 && H7CreatureStack( mOwner ) != none && H7CreatureStack( mOwner ).GetCreature().HasPendingMaterialFX())
			{
				H7CreatureStack( mOwner ).GetCreature().ResumeMaterialEffects();
			}
		}
	}

	if( expireCompletely )
	{
		GetEventManager().Raise(ON_BUFF_EXPIRE, false, ecs);
	}
}

function string GetTooltip(optional bool extendedVersion,optional string overwriteBaseString,optional ESkillRank considerOnlyEffectsOfRank=SR_ALL_RANKS, optional bool resetRankOverride = true)
{
	local String finalTT;
	local H7BaseBuff tmpBuff;

	if(IsArchetype()) // this is now illegal
	{
		tmpBuff = new self.Class(self);
		return tmpBuff.GetTooltip(extendedVersion);
	}
	else
	{
		//`log_dui("return instance duration" @ mCurrentDuration);
		AddRepl("%t",String(mCurrentDuration));
	}

	finalTT = super.GetTooltip(extendedVersion);
	return finalTT;
}

// this is called on non-instanciated archetypes - we have to make sure that GetTooltip() has a mCaster but it also needs to be cleaned up afterwards
function string GetTooltipByCaster(H7ICaster caster)
{
	local String tt;

	if(IsArchetype())
	{
		SetCaster(caster);
	}
	tt = GetTooltip();
	if(IsArchetype())
	{
		SetCaster(none);
	}
	return tt;
}

native function bool ChangesInitiative();

native function GetPermanentStatModsNextRound( out array<H7MeModifiesStat> outStats, H7IEffectTargetable unit );

