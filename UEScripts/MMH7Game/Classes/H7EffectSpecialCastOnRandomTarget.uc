//=============================================================================
// H7EffectSpecialCastOnRandomTarget
//
// - Casts an ability through the owner of the source on a random valid target
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialCastOnRandomTarget extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var(Ability) protected H7BaseAbility mAbilityTemplate<DisplayName=Ability to cast>;
var(Ability) protected int mAmountOfCasts<DisplayName=Cast Ability On How Many Targets>;
var(Ability) protected bool mCastOnlyOnceOnTarget<DisplayName=Don't Cast Twice on Same Target>;
var(Ability) bool mFakeRandom<DisplayName=Use Fake Random Target|Tooltip=No>;

var protected H7BaseAbility mAbility;
var protected array<ESpellTag> mAbilityTags;
var protected array<H7IEffectTargetable> mPreviousTargets;

function Initialize( H7Effect effect ) 
{
	if( mAbilityTemplate == none )
	{
		;
		return;
	}
}

function InitAbility( H7Effect effect )
{
	local H7ICaster caster;

	if( mAbilityTemplate == none )
	{
		return;
	}

	mAbility = new class'H7BaseAbility'( mAbilityTemplate );
	mAbility.SetSourceEffect( effect.GetSource() );
	mAbility.SetDisplayed( false );
	mPreviousTargets.Length = 0;
	caster = effect.GetSource().GetOwner();
	if( caster == none )
	{
		caster = effect.GetSource().GetCaster();
		if( caster == none )
		{
			;
			return;
		}
	}
	mAbilityTags = mAbility.GetTags();
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets, validTargets, alreadyChecked;
	local H7IEffectTargetable target;
	local H7Command command;
	local H7ICaster caster;
	local H7Unit prev;
	local int targetAmount,i, rand;

	caster = effect.GetSource().GetOwner();
	if( caster == none )
	{
		caster = effect.GetSource().GetCaster();
	}
	
	if( isSimulated || class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) 
	{ 
		mPreviousTargets.Length = 0;
		return; 
	}

	if( mAbility == none )
	{
		if( !caster.GetAbilityManager().HasVolatileAbility( mAbilityTemplate ) )
		{
			InitAbility( effect );
		}
		else
		{
			mAbility = caster.GetAbilityManager().GetAbility( mAbilityTemplate );
			mAbility.SetSourceEffect( effect.GetSource() ); // update source
		}

		if( mAbility == none )
		{
			;
			return;
		}
	}

	if( !caster.GetAbilityManager().HasVolatileAbility( mAbility ) )
	{
		caster.GetAbilityManager().LearnVolatileAbility( mAbility );
	}

	if(H7CombatHero( caster ) != none)
	{
		prev = class'H7CombatController'.static.GetInstance().GetActiveUnit();
		class'H7CombatController'.static.GetInstance().SetActiveUnit( H7Unit( caster ) );
	}

	class'H7CombatController'.static.GetInstance().GetAllTargetable(targets);
	foreach targets( target )
	{
		if( alreadyChecked.Find(target) != INDEX_NONE ) continue;

		alreadyChecked.AddItem(target);

		if( target.GetResistanceModifierFor(mAbility.GetSchool(), mAbilityTags) == 0.0f) continue;

		if( mAbility.CanCastOnTargetActor( target ) && effect.ConditionCheck(target, caster, true) && effect.RankCheck(caster) && !effect.IsPreventedByImmunityOf(target) )
		{
			if(mCastOnlyOnceOnTarget && mPreviousTargets.Find(target) != INDEX_NONE)
			{
				continue;
			}

			validTargets.AddItem( target );
			mPreviousTargets.AddItem( target );
		}
	}
	alreadyChecked.Length = 0;

	targetAmount = Min( validTargets.Length, mAmountOfCasts );

	// don't cast on zero creatures
	if(targetAmount == 0) 
	{ 
		mPreviousTargets.Length = 0;
		if(H7CombatHero( caster ) != none)
		{
			class'H7CombatController'.static.GetInstance().SetActiveUnit(prev);
		}
		return;
	}

	if(H7CombatHero( caster ) != none)
	{
		AddSupportBuff( H7CombatHero( caster ), targetAmount, effect.GetSource() );
	}

	for(i=0; i<targetAmount; ++i)
	{
		rand = mFakeRandom ? class'H7ReplicationInfo'.static.GetInstance().GetFakeRandomTarget() : class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( validTargets.Length );
		
		target = validTargets[ rand ];
		if(mCastOnlyOnceOnTarget)
		{
			validTargets.Remove(rand,1);
		}
		targets.Length = 0;

		targets.AddItem(target);
		mAbility.SetTarget(target);
		mAbility.SetTargets(targets);
		mAbility.SetCaster(caster);

		command = class'H7Command'.static.CreateCommand( caster, UC_ABILITY, ACTION_ABILITY, mAbility, target,, false,, true, true );
		class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().Enqueue( command );
	}
	
	mPreviousTargets.Length = 0;
	mAbility = none;
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_CAST_ON_RANDOM","H7TooltipReplacement");
}

function String GetDefaultString()
{
	return String(mAmountOfCasts);
}

function AddSupportBuff(H7CombatHero hero, float additionals, H7EffectContainer src)
{
	local H7BaseBuff supportBuff;
	local array<H7StatEffect> mods;
	local H7StatEffect mod;
	local array<H7DurationModifierEffect> durMods;
	local H7DurationModifierEffect durMod;

	// add "plundered" buff so production is 0 for mPlunderingDelay days
	supportBuff = new class'H7BaseBuff';
	supportBuff.SetCaster(hero);
	supportBuff.SetOwner(hero);
	supportBuff.SetDisplayed(false);

	// duration
	durMod.mCombineOperation = OP_TYPE_ADD;
	durMod.mModifierValue = -1;
	durMod.mTrigger.mTriggerType = ON_BEGIN_OF_EVERY_UNITS_TURN;
	durMods.AddItem(durMod);

	supportBuff.SetDuration(1);
	supportBuff.SetCurrentDuration(1);
	supportBuff.SetDurationModifierEffects(durMods);

	// attack count
	mod.mTrigger.mTriggerType = ON_INIT;
	mod.mStatMod.mCombineOperation = OP_TYPE_ADD;
	mod.mStatMod.mModifierValue = additionals;
	mod.mStatMod.mStat = STAT_ATTACK_COUNT;
	mods.AddItem(mod);

	supportBuff.SetStatModEffects(mods);

	// initialize everything and apply buff
	supportBuff.Init(hero,hero);
	hero.GetBuffManager().AddBuff(supportBuff,self,src);
}

