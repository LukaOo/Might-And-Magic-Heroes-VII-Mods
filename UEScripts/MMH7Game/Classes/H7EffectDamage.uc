//=============================================================================
// H7EffectDamage
//
// - if an effect does damage, it's this type
// - uses data from the H7DamageEffect-struct
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectDamage extends H7Effect
	native(Tussi);

var() protected H7RangeValue mDamage; // TODO: is really needed?
var() protected H7DamageEffect mData;

function H7DamageEffect GetData() { return mData; }

event bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }
function bool IsHeal()                  { return HasTag(TAG_HEAL) || HasTag(TAG_REPAIR) || HasTag(TAG_RESURRECT); }

event InitSpecific(H7DamageEffect data,H7EffectContainer source,optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	properties.mConditions = data.mConditions;
	
	InitEffect(properties, source,registerEffect);
	
	mData = data;
	mDamage = mData.mDamage;


	if(data.mTrigger.mTriggerType == PERSISTENT)
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(mSourceOfEffect.GetDebugName() @ " -persistant damage effects are IMPOSSIBRU!",MD_QA_LOG);;
	}
}

protected function int SpellScaling( H7SpellScaling SpellScalingStruct, H7ICaster caster , optional out String formular )
{
	local int  value;

	if(caster == none) 
	{
		//`warn("Can not spellscale without caster" @ mSourceOfEffect.GetName() @ "returning formular");
		// 30+10*Magic
		formular = class'H7GameUtility'.static.FloatToString(SpellScalingStruct.mIntercept) $ "+" $ class'H7GameUtility'.static.FloatToString(SpellScalingStruct.mSlope) @ "*" @ class'H7Loca'.static.LocalizeSave("STAT_MAGIC","H7Abilities"); 
		return value;
	}

	if( mSourceOfEffect.GetCaster().GetEntityType() != UNIT_HERO )
	{
		;
		return 0;
	}

	if( H7UnitSnapShot( caster ) != none ) H7UnitSnapShot( caster ).UpdateSnapShot(,,true);

	value = ( SpellScalingStruct.mSlope * caster.GetMagic() ) + SpellScalingStruct.mIntercept;
    
	if( SpellScalingStruct.mUseCap )
		value = FMax( SpellScalingStruct.mMinCap, FMax( value, SpellScalingStruct.mMaxCap ) );

	return value;
}

function H7RangeValue GetDamageRangeFinal( optional bool resetContainer = false ) // returns post-GameProcessor damage getfinaldamage getdamagefinal
{
	local H7EventContainerStruct empty;
	local H7RangeValue damageRange;
	local H7CombatResult result;
	local String formularMin,formularMax;
	local H7EventContainerStruct preContainer,safeContainer;

	if( resetContainer )
	{
		safeContainer = mEventContainer;
		SetEventContainer( empty );
	}

	if( mEventContainer.Targetable == none && ( mSourceOfEffect.GetTarget() == none || mSourceOfEffect.IsA('H7BaseBuff') ) )
	{
		//`log_dui("no mTarget in " @ mSourceOfEffect.GetName() @ "to calculate damage, return base damage with spellscaling=" $ GetData().mUseSpellScaling);

		if(GetData().mUseSpellScaling && mSourceOfEffect.GetCaster() != none)
		{
			damageRange.MinValue = SpellScaling(GetData().mMinDamage, mSourceOfEffect.GetCaster() ,formularMin);
			damageRange.MinValueFormular = formularMin;
			damageRange.MaxValue = SpellScaling(GetData().mMaxDamage, mSourceOfEffect.GetCaster() ,formularMax);
			damageRange.MaxValueFormular = formularMax;
		}
		else
		{
			damageRange = GetDamageRange(); // TODO add caster power
		}


	}
	else
	{
		if( mSourceOfEffect.GetTarget() == none )
		{
			mSourceOfEffect.SetTarget( mEventContainer.Targetable );
		}
		;
		ClearCachedTargets();
		result = GenerateCombatAction(result);
		// !!! RESTORE ORIGINAL EVENT CONTAINER BC TRIGGERS WHILE RESOLVING COMBAT MIGHT CHANGE IT !!!
		preContainer = mEventContainer;
		class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().ResolveCombat( result, true );
		mEventContainer = preContainer;
		;
	
		damageRange.MinValue = result.GetDamageLow(0);
		damageRange.MaxValue = result.GetDamageHigh(0);
	
		;
	}

	if( resetContainer )
	{
		mEventContainer = safeContainer;
		SetEventContainer( mEventContainer );
	}

	return damageRange;
	
}
/**returns pre-GameProcessor damage*/
function H7RangeValue GetDamageRange() 
{
	local String formularMin,formularMax;
	local H7RangeValue damageRange;
	local int creatureHitPoints, stackSize;
	local H7ICaster caster, owner, casterSnapShot;
	local H7UnitSnapShot snapShot;
	local H7CreatureStack stack;
	local float dmg, minDmg, maxDmg;
	local H7CombatHero hero;
	local H7Unit unit;

	if( mSourceOfEffect != none )
	{
		// buff -> use snapshot, else -> use original and leave caster empty
		if( mSourceOfEffect.IsA( 'H7BaseBuff' ) )
		{
			// do NOT do this if source is not a buff!
			casterSnapShot = mSourceOfEffect.GetInitiator();
			if( casterSnapShot.GetOriginal().GetEntityType() != UNIT_CREATURESTACK )
			{
				casterSnapShot = mSourceOfEffect.GetOwner();
				if( H7UnitSnapShot( casterSnapShot ) != none )
				{
					caster = casterSnapShot.GetOriginal();
					stack = H7CreatureStack( caster );
				}
				else if( H7CreatureStack( casterSnapShot ) != none )
				{
					stack = H7CreatureStack( casterSnapShot );
				}
			}
			snapShot = H7UnitSnapShot( casterSnapShot );
		}

		// that's the real caster (just fyi)
		caster = mSourceOfEffect.GetInitiator().GetOriginal();

		if( mSourceOfEffect != none &&
			( mSourceOfEffect.IsA('H7BaseBuff') || mSourceOfEffect.IsA('H7HeroItem') ) &&
			mSourceOfEffect.GetOwner() != none )
		{
			owner = mSourceOfEffect.GetOwner().GetOriginal();
		}

		if( stack == none )
		{
			stack = H7CreatureStack( caster );
			if( stack == none && owner != none ) stack = H7CreatureStack( owner ); // use the owner if necessary
		}
	}

	damageRange = GetData().mDamage; // in case nothing is true
	minDmg = damageRange.MinValue;
	maxDmg = damageRange.MaxValue;

	if(GetData().mUseSpellScaling ) // no none check for caster here, else the magic guild won't have values for some spells!
	{
		damageRange.MinValue = SpellScaling(GetData().mMinDamage, caster, formularMin);
		damageRange.MinValueFormular = formularMin;
		damageRange.MaxValue = SpellScaling(GetData().mMaxDamage, caster, formularMax);
		damageRange.MaxValueFormular = formularMax;
	}

	// unit default damage
	if(GetData().mUseDefaultDamage) 
	{
		if( mSourceOfEffect != none && mSourceOfEffect.GetInitiator() != none )
		{
			minDmg = mSourceOfEffect.GetInitiator().GetOriginal().GetMinimumDamage();
			maxDmg = mSourceOfEffect.GetInitiator().GetOriginal().GetMaximumDamage();
		
			damageRange.MinValue = minDmg;
			damageRange.MaxValue = maxDmg;

			caster = mSourceOfEffect.GetInitiator().GetOriginal();
		}
	}

	// stack size scaling
	if(GetData().mUseStackSize)
	{
		//As UseStackSize is the prerequesition for UseStackSizeTarget, it must be excluded here
		if( (stack != none || snapShot != none) && !GetData().mUseStackSizeTarget )
		{
			if( snapShot != none )
			{
				// get original caster stack size when the buff was casted
				stackSize = snapShot.GetStackSize();
			}
			else
			{
				// get the stack size from caster/owner
				stackSize = stack.GetStackSize();
			}

			damageRange.MinValue = minDmg * stackSize;
			damageRange.MaxValue = maxDmg * stackSize;
		}
		else if( GetData().mUseStackSizeTarget )
		{
			// just hope that the target of the source effect is the target we want (yikes)
			if( mSourceOfEffect.GetTarget().GetEntityType() == UNIT_CREATURESTACK )
			{
				damageRange.MinValue = minDmg * mSourceOfEffect.GetTarget().GetStackSize();
				damageRange.MaxValue = maxDmg * mSourceOfEffect.GetTarget().GetStackSize();
			}
			else
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(mSourceOfEffect.GetDebugName() @ "wants to use stacksize, but" @ mSourceOfEffect.GetInitiator().GetOriginal() @ "has none",MD_QA_LOG);;
			}
		}
		else
		{
			damageRange.MinValue = minDmg * mSourceOfEffect.GetInitiator().GetStackSize();
			damageRange.MaxValue = maxDmg * mSourceOfEffect.GetInitiator().GetStackSize();
		}
	}

	// metamagic scaling
	if( GetData().mMultiplyByMetamagic )
	{
		hero = H7CombatHero( caster );
		if( hero != none )
		{
			//If there is any precalculation done dont overwrite it! Example: calculation of dmg with stacksize and metamagic
			if(damageRange.MinValue == 0 && damageRange.MaxValue == 0)
			{
				damageRange.MinValue = minDmg * hero.GetModifiedStatByID( STAT_METAMAGIC );
				damageRange.MaxValue = maxDmg * hero.GetModifiedStatByID( STAT_METAMAGIC );
			}
			else
			{
				damageRange.MinValue *= hero.GetModifiedStatByID( STAT_METAMAGIC );
				damageRange.MaxValue *= hero.GetModifiedStatByID( STAT_METAMAGIC );
			}
		}
		else
		{
			// Metamagic is not available on adventure maps, so multiply only on combat maps (otherwise, the default damage values will be displayed)
			// (don't change this, else some stuff will display damage 0 and that'll look very dumb)
			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				unit = H7Unit( caster );
				if( unit != none )
				{
					//If there is any precalculation done dont overwrite it! Example: calculation of dmg with stacksize and metamagic
					if(damageRange.MinValue == 0 && damageRange.MaxValue == 0)
					{
						damageRange.MinValue = minDmg * unit.GetCombatArmy().GetHero().GetModifiedStatByID( STAT_METAMAGIC );
						damageRange.MaxValue = maxDmg * unit.GetCombatArmy().GetHero().GetModifiedStatByID( STAT_METAMAGIC );
					}
					else
					{
						damageRange.MinValue *= unit.GetCombatArmy().GetHero().GetModifiedStatByID( STAT_METAMAGIC );
						damageRange.MaxValue *= unit.GetCombatArmy().GetHero().GetModifiedStatByID( STAT_METAMAGIC );
					}
				}
			}
		}
	}

	// scale by percentage
	if( GetData().mUsePercentStackDamage && mSourceOfEffect != none && mSourceOfEffect.GetTarget().GetEntityType() == UNIT_CREATURESTACK )
	{
			stack = H7CreatureStack(class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint(mSourceOfEffect.GetTarget().GetGridPosition()).GetUnit());
		    creatureHitPoints = stack.GetTopCreatureHealth();
			creatureHitPoints += (mSourceOfEffect.GetTarget().GetStackSize() -1) * mSourceOfEffect.GetTarget().GetHitPoints();
	
			damageRange.MinValue =  creatureHitPoints  * GetData().mPercentStackDamage;
			damageRange.MaxValue =  creatureHitPoints  * GetData().mPercentStackDamage;
			
			if( GetData().mPercentUseCasterSpellPower )
			{ 
				damageRange.MinValue = FMin( ((GetData().mPercentStackDamage * mSourceOfEffect.GetInitiator().GetMagic() ) + GetData().mAddPercentStackDamage ), GetData().mPercentStackDamageCap ) * creatureHitPoints ;
				damageRange.MaxValue = FMin( ((GetData().mPercentStackDamage * mSourceOfEffect.GetInitiator().GetMagic() ) + GetData().mAddPercentStackDamage ), GetData().mPercentStackDamageCap ) * creatureHitPoints ;
			}
	}
	
	// magic absorption scaling
	if( stack != none && GetData().mUseMagicAbs )
	{
		dmg = FClamp( stack.GetModifiedStatByID( STAT_MAGIC_ABS ), 0.f, stack.GetMaximumDamage() * stack.GetStackSize() );
		damageRange.MinValue = dmg;
		damageRange.MaxValue = dmg;
	}

	return damageRange;
}

// used for simulation (hover tooltip) and real
function H7CombatResult GenerateCombatAction( optional H7CombatResult baseCombatAction )
{
	local array<H7IEffectTargetable> /*targets,*/defenders;
	//local array<H7BaseCell> path;
	local H7IEffectTargetable target;
	local H7CombatResult action;
	local H7Unit sourceUnit;
	local H7ICaster caster;
	local int c;

	GetTargets( mTempTargets );
	;
	
	if( mTempTargets.Length == 0)
		;

	action = super.GenerateCombatAction( baseCombatAction );

	//TODO: Clean/improve logic to set action
	if( class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().GetCurrentCommand() != none )
	{
		action.SetActionId( class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().GetCurrentCommand().GetCommandTag() );
	}
	
	if( class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().GetCurrentCommand() != none && class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().GetCurrentCommand().GetCommandTag() == ACTION_RETALIATE)
	{
		action.SetActionId(ACTION_RETALIATE);
	}
	else if( mSourceOfEffect.IsBuff() )
	{
		action.SetActionId( ACTION_ABILITY );
	}
	else if( mSourceOfEffect.IsAbility() )
	{
		caster = mSourceOfEffect.GetCasterOriginal();
		sourceUnit = H7Unit(caster);

		if( sourceUnit != none && sourceUnit.IsDefaultAttackActive() )
		{
			// its a default attack so its a melee attack
			action.SetActionId( ACTION_MELEE_ATTACK );
			
			// check if its a default range attack
			if( H7BaseAbility( mSourceOfEffect ).IsRanged() )
			{
				action.SetActionId( ACTION_RANGE_ATTACK );
			}
		}
	}

	action.SetBaseDamageRange( GetDamageRange() );
	
	c=0;
	foreach mTempTargets( target, c )
	{
		action.AddDefender( target );
		defenders = action.GetDefenders();
		if(ShowInTooltip() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenEffects())	action.AddEffectToTooltip(self,defenders.Find(target));
		;
	}

	return action;
}

protected function bool OwnerIsDead()
{
	local H7ICaster owner;
	local H7Unit unit;

	if( H7BaseBuff( mSourceOfEffect ) == none ) return false;
	if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) return false;

	owner = mSourceOfEffect.GetOwner();
	unit = H7Unit( owner );

	if( unit == none ) return false;

	return unit.IsDead();
}

protected event Execute(optional bool isSimulated = false)
{
	local H7CombatResult result;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;

	if( isSimulated ) return;

	// don't execute if source is a buff and owner is dead (caused by damage on expire)
	if( OwnerIsDead() ) { return; }

	// initialize all parameter from container

	if( mEffectTarget == TARGET_TARGET )
	{
		UnpackContainer();
	}

	;

	;
	;
	;

	result = GenerateCombatAction();

	// inform the defenders about the incoming attack
	targets = result.GetDefenders();

	if( GetSource().IsAbility() && H7BaseAbility( GetSource() ).IsPassive() ) 
	{
		H7BaseAbility( GetSource() ).DoParticleFXCaster( GetSource().GetCasterOriginal() );
	}

	if( GetData().mFX.mUseCasterPosition ) 
	{
		GetSource().GetCasterOriginal().GetEffectManager().AddToFXQueue( mData.mFX, self );
	}
	else
	{
		mEventContainer.Result = result; 
		
		foreach targets(target)
		{
			target.GetEffectManager().AddToFXQueue( mData.mFX, self );
		}
	}
	// Calculations
	class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().ResolveCombat( result, false );

	;
	;
	;
}

function UnpackContainer( )
{
	if( GetEventContainer().Targetable != none ) 
	{
		SetUnitTargetOverwrite( GetEventContainer().Targetable );
	}
}
