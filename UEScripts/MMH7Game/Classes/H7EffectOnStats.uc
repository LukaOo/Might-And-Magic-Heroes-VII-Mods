//=============================================================================
// H7EffectOnStats
//
// - if an effect does somthing with stats, it's this type
// - uses data from the H7StatEffect-struct
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectOnStats extends H7Effect
	native(Tussi);


var() protected H7StatEffect mData;
var() bool mIsValueCalculated;

function H7StatEffect   GetData()               { return mData; }
function EStat          GetStatModType()        { return mData.mStatMod.mStat; }
function EOperationType GetStatModCombineOp()   { return mData.mStatMod.mCombineOperation; }
function bool           IsValueCalculated()     { return mIsValueCalculated; }

function SetData( H7StatEffect effect ) { mData = effect; }

event bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }

function float          GetStatModValue()       
{
	local H7ICaster owner;
	local H7ICaster caster;

	owner = GetSource().GetOwner();
	caster = GetSource().GetCaster();

	if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) { return mData.mStatMod.mModifierValue; }

	if( mData.mStatMod.mOverrideWithAnotherStat )
		return H7Unit(owner).GetModifiedStatByID( mData.mStatMod.mStatToOverrideWith );
	if( mData.mStatMod.mUseBattleRageValue )
		return H7Unit(owner).GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_BATTLERAGE );
	if( mData.mStatMod.mMultiplyWithBattleRage )
		return mData.mStatMod.mModifierValue * H7Unit( owner).GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_BATTLERAGE );
	if( mData.mStatMod.mUseMetamagicValue )
		return H7Unit(owner).GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_METAMAGIC );
	if( mData.mStatMod.mMultiplyWithMetamagic )
		return mData.mStatMod.mModifierValue * H7Unit( owner).GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_METAMAGIC );
	if( mData.mStatMod.mMultiplyWithPathLength )
	{
		if( H7CreatureStack( caster ) != none )
		{
			return mData.mStatMod.mModifierValue * Max( 0, H7CreatureStack( caster ).GetLastWalkedPathLength() );
		}

		if( H7BaseBuff( mSourceOfEffect ) != none && H7CreatureStack( owner ) != none )
		{
			return mData.mStatMod.mModifierValue * Max( 0, H7CreatureStack( owner ).GetLastWalkedPathLength() );
		}
	}

	if( self.IsA('H7BuffHeroArmyBonus') )
	{
		if( caster != none && H7UnitSnapShot( caster ) != none )
		{
			if( mData.mStatMod.mStat == STAT_MORALE_LEADERSHIP ) return H7UnitSnapShot( caster ).GetLeadership();
			if( mData.mStatMod.mStat == STAT_LUCK_DESTINY ) return H7UnitSnapShot( caster ).GetLuckDestiny();
		}
		return owner.GetPlayer().GetHeroInCombat().GetModifiedStatByID( mData.mStatMod.mStat );
	}

	return mData.mStatMod.mModifierValue; 
}

event InitSpecific(H7StatEffect data,H7EffectContainer source,optional bool registerEffect=true)
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
	mData.mStatMod.mSource = source;

	// In case of spell scaling we need to calculate the modifier
	if( mData.mStatMod.mUseSpellScaling )
		SetModifier();

	mData.mStatMod.mInitialModValue = mData.mStatMod.mModifierValue;
}

protected function SetModifier()
{
	local H7CombatResult result;
	
	// only works with heroes 
	if( mSourceOfEffect.GetCaster() == none || mSourceOfEffect.GetCaster().GetEntityType() != UNIT_HERO )
		return; 

	result = super.GenerateCombatAction();
	
	if( mSourceOfEffect.GetTarget() != none ) 
		result.AddDefender( mSourceOfEffect.GetTarget() );

	// Calculation
	class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().Calculate_EffectOnStats ( result );

	mData.mStatMod.mModifierValue = result.GetDamageHigh();
	mIsValueCalculated = true;
}

// called for state like current_mana, that can be changed once to a new state
protected event Execute(optional bool isSimulated = false)
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local int baseValue,lastPathLength;
	local float modifierValue,actualChangedValue;
	local EOperationType displayOperation;
	
	if( isSimulated ) 
	{
		;
		return;
	}

	GetTargets( targets );

	if(targets.Length == 0)
	{
		;
		//return;
	}

	foreach targets(target)
	{
		// Does not go through GameProcessor, because <insert answer here>
		;
		;
		;
		;
		if( mData.mStatMod.mUseBattleRageValue && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			modifierValue = GetSource().GetOwner().GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_BATTLERAGE );
		}
		else if( mData.mStatMod.mUseMetamagicValue && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			modifierValue = GetSource().GetOwner().GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_METAMAGIC );
		}
		else 
		{
			modifierValue = mData.mUseAmount ? (mData.mStatMod.mModifierValue * mEventContainer.Amount) : mData.mStatMod.mModifierValue;
		}

		if( mData.mStatMod.mMultiplyWithMetamagic && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			modifierValue *= GetSource().GetOwner().GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_METAMAGIC );
		}
		if( mData.mStatMod.mMultiplyWithBattleRage && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			modifierValue *= GetSource().GetOwner().GetPlayer().GetHeroInCombat().GetModifiedStatByID( STAT_BATTLERAGE );
		}
		if( mData.mStatMod.mUseLevelScaling && H7EditorHero( target ) != none )
		{
			modifierValue *= H7EditorHero( target ).GetLevel();
		}

		if( mData.mStatMod.mMultiplyWithPathLength )
		{
			if( H7CreatureStack( target ) != none )
			{
				lastPathLength = Max( 0, H7CreatureStack( target ).GetLastWalkedPathLength() );
				modifierValue *= lastPathLength;
			}
		}
		actualChangedValue = modifierValue;
		
		baseValue = H7EditorHero(target) == none ? H7Unit(target).GetBaseStatByID(mData.mStatMod.mStat) : H7EditorHero(target).GetBaseStatByID(mData.mStatMod.mStat);

		// one time change forever of base value of this stat i.e. +2 Might Attack permanent through visiting smith
		if( mData.mStatMod.mOverrideWithAnotherStat )
		{
			if(H7AdventureHero(target) != none) { H7AdventureHero(target).SetBaseStatByID(mData.mStatMod.mStat, H7Unit(target).GetModifiedStatByID( mData.mStatMod.mStatToOverrideWith ) ); }
			else if(H7EditorHero(target) != none) { H7EditorHero(target).SetBaseStatByID(mData.mStatMod.mStat, H7Unit(target).GetModifiedStatByID( mData.mStatMod.mStatToOverrideWith )); }
			else { H7Unit(target).SetBaseStatByID(mData.mStatMod.mStat, H7Unit(target).GetModifiedStatByID( mData.mStatMod.mStatToOverrideWith )); }
		}
		else
		{
			switch(mData.mStatMod.mCombineOperation)
			{
				case OP_TYPE_ADD:
					if(H7AdventureHero(target) != none) { actualChangedValue = H7AdventureHero(target).IncreaseBaseStatByID(mData.mStatMod.mStat, modifierValue); }
					else if(H7EditorHero(target) != none) { actualChangedValue = H7EditorHero(target).IncreaseBaseStatByID(mData.mStatMod.mStat, modifierValue); }
					else { actualChangedValue = H7Unit(target).IncreaseBaseStatByID(mData.mStatMod.mStat, modifierValue); }
					break;
				case OP_TYPE_ADDPERCENT:
					modifierValue = modifierValue * 0.01f;
					if(H7AdventureHero(target) != none) { actualChangedValue = H7AdventureHero(target).IncreaseBaseStatByID(mData.mStatMod.mStat, baseValue * modifierValue); }
					else if(H7EditorHero(target) != none) { actualChangedValue = H7EditorHero(target).IncreaseBaseStatByID(mData.mStatMod.mStat, baseValue * modifierValue); }
					else { actualChangedValue = H7Unit(target).IncreaseBaseStatByID(mData.mStatMod.mStat, baseValue * modifierValue); }
					break;
				case OP_TYPE_MULTIPLY:
					if(H7AdventureHero(target) != none) { actualChangedValue = H7AdventureHero(target).IncreaseBaseStatByID(mData.mStatMod.mStat, baseValue * modifierValue - baseValue); }
					else if(H7EditorHero(target) != none) { actualChangedValue = H7EditorHero(target).IncreaseBaseStatByID(mData.mStatMod.mStat, baseValue * modifierValue - baseValue); }
					else { actualChangedValue = H7Unit(target).IncreaseBaseStatByID(mData.mStatMod.mStat, baseValue * modifierValue - baseValue); }
					break;
				case OP_TYPE_SET:
					if(H7AdventureHero(target) != none) { H7AdventureHero(target).SetBaseStatByID(mData.mStatMod.mStat, modifierValue); }
					else if(H7EditorHero(target) != none) { H7EditorHero(target).SetBaseStatByID(mData.mStatMod.mStat, modifierValue); }
					else { H7Unit(target).SetBaseStatByID(mData.mStatMod.mStat, modifierValue); }
					break;
				default:
					;
					;
			}
		}
		
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
			target.GetEffectManager().AddToFXQueue( mData.mFX, self );  
		}

		// Signs & Feedback
		if(GetData().mStatMod.mCombineOperation == OP_TYPE_SET) displayOperation = OP_TYPE_SET;
		else displayOperation = OP_TYPE_ADD; // because add,addpercent,multiply are converted into add(ed amounts)
		// log
		if(H7Unit(target) != none && GetSource().IsDisplayed())
		{
			H7Unit(target).DisplayStatChangeLog(GetData().mStatMod.mStat,displayOperation,actualChangedValue,mSourceOfEffect);
		}
		// floats
		if(H7Unit(target) != none && GetData().mStatMod.mShowFloatingText ) // mShowFloatingText overwrites GetSource().IsDisplayed() 
		{
			H7Unit(target).DisplayStatChangeFloat(GetData().mStatMod.mStat,displayOperation,actualChangedValue,mSourceOfEffect);
		}
	 
		;
		;
		;
	

	}
}
