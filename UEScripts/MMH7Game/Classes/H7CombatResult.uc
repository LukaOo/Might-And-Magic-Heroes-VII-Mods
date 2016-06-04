//=============================================================================
// H7CombatResult
//=============================================================================
// Output object for GameProcessor to hold all results.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatResult extends H7CombatAction
	native;

const MAX_RESULTS = 42;

var protected CRData		mResults[MAX_RESULTS];

var array<ConditionalStatMod>   mConditionalStatMods;
var bool                        mIsForecast;
var transient bool              mShowsSomething;

function ClearResult()
{
	local int i;
	for( i = 0; i < MAX_RESULTS; ++i )
	{
		mResults[i].mTriggeredEffects.Length = 0;
		mResults[i].mEffects.Length = 0;
	}
	mAttackerUnit = none;
	mDefenders.Length = 0;
	mEffects.Length = 0;
	mCurrentProcessedEffect = none;
	mContainer = none; // ability/spell with which to attack
	ClearConditionalStatMods();
}

function                    AddConditionalStatMod( ConditionalStatMod cond )                    { mConditionalStatMods.AddItem( cond ); }
function                    ClearConditionalStatMods()                                          { mConditionalStatMods.Length = 0; }
 
function EAbilitySchool     GetDamageSchool( optional int idx )                                 { return mResults[idx].mSchoolType; }
function                    SetDamageSchool( EAbilitySchool school, optional int idx )          { mResults[idx].mSchoolType = school; }
function int				GetKillsLow( optional int idx )										{ return mResults[idx].mKillsLow; }
function int				GetKillsHigh( optional int idx )									{ return mResults[idx].mKillsHigh; }

// range
function float				GetDamageLow( optional int idx )									{ return mResults[idx].mDamageLow; }
function float				GetDamageHigh( optional int idx )									{ return mResults[idx].mDamageHigh; }
function					SetDamageRange( float damageLow, float damageHigh, optional int idx )	{ mResults[idx].mDamageLow = damageLow; mResults[idx].mDamageHigh = damageHigh; }
// rolled damage within the range
function					SetDamage( int newDamage, optional int idx )						{ mResults[idx].mDamage = newDamage; }
function int				GetDamage( optional int idx )										{ return mResults[idx].mDamage; }

function					SetKillRange( int minKills, int maxKills, optional int idx )		{ mResults[idx].mKillsLow = minKills; mResults[idx].mKillsHigh = maxKills; }
function					SetKills( int kills, optional int idx )								{ mResults[idx].mKills = kills; }
function int				GetKills( optional int idx )										{ return mResults[idx].mKills; }
function float              GetFinalDamageModifier( optional int idx )                          { return mResults[idx].mDamageModifier; }
function					SetAttackPower( int newPower, optional int idx )					{ mResults[idx].mAttackPower = newPower; }
function int				GetAttackPower( optional int idx )									{ return mResults[idx].mAttackPower; }
function					SetDefensePower( int newPower, optional int idx )					{ mResults[idx].mDefensePower = newPower; }
function int				GetDefensePower( optional int idx )									{ return mResults[idx].mDefensePower; }

// Whether the defender should get events raised on him, during simulation
// only used by MagicLink // TODO CHECK if can be removed, if such a special one time use
function                    SetTriggerEvents( bool value ,optional int idx )                    { mResults[idx].mTriggerEvents = value; }
function bool               GetTriggerEvents( optional int idx )                                { return mResults[idx].mTriggerEvents; }

function array<H7TooltipMultiplier>     GetMultipliers(int idx)                                 { return mResults[idx].mMultipliers; }
// primary effects onto the target (from the spell)
function array<H7Effect>                GetTooltipEffects(int idx)                              { return mResults[idx].mEffects; }
// effects chain-reaction triggering _after_ the primary effects
function array<H7Effect>                GetTriggeredEffects(int idx)                            { return mResults[idx].mTriggeredEffects; }

function					SetIsCovered( bool isCovered, optional int idx )					{ mResults[idx].mIsCovered = isCovered; }
function bool				IsCovered( optional int idx )										{ return mResults[idx].mIsCovered; }
function                    SetIsConstDamagerRange( bool isConst, optional int idx )            { mResults[idx].mConstDamageRange = isConst; }
function bool               IsConstDamageRange( optional int idx )                              { return mResults[idx].mConstDamageRange; }
function bool               DidMiss( optional int idx )                                         { return mResults[idx].mMissed; }
function                    SetMiss( bool value, optional int idx )                             { mResults[idx].mMissed = value; }

function bool               ShowsSomething()                                                    { return mShowsSomething; }
function                    SetShowsSomething(bool val)                                         { mShowsSomething = val; }

function bool               IsHeal(int idx)															
{ 
	local array<H7Effect> effects;
	local H7Effect effect;
	
	effects =  mResults[idx].mEffects;
	foreach effects(effect)
	{
		if(effect.HasTag(TAG_HEAL) || effect.HasTag(TAG_REPAIR) || effect.HasTag(TAG_RESURRECT))
		{
			return true; // TODO what if multiple damage effects and one is heal and the other is not?
		}
	}
	return false;
}

function bool               DoSendAttackEvent(int idx=0)
{
	local H7IEffectTargetable target;
	local H7EffectWithSpells buffEff;
	local H7BaseBuff buff;
	local array<ESpellTag> damageEffectTags;

	target = GetDefender(idx);
	// no event if attacker == defender
	if( H7ICaster(target) != none && GetAttacker().GetOriginal() == H7ICaster(target)) { return false; }

	// buff/ability thing?
	if(mCurrentProcessedEffect.IsA('H7EffectWithSpells'))
	{
		buffEff = H7EffectWithSpells(mCurrentProcessedEffect);

		// custom -> buff
		if(buffEff.GetData().mSpellStruct.mDefaultAbility == ED_CUSTOM)
		{
			if(buffEff.GetData().mSpellStruct.mSpell.IsBuff())
			{
				buff = H7BaseBuff(buffEff.GetData().mSpellStruct.mSpell);
				if(buff.IsDebuff())
				{
					return true;
				}
				else
				{
					return false;
				}
			}

			if(!buffEff.GetData().mSpellStruct.mSpell.IsDisplayed())
			{
				return false;
			}
		}
		// not custom? ability stuff
		else
		{
			// something suppresses an ability? probably done by an enemy -> send event
			if(buffEff.GetData().mSpellStruct.mSpellOperation == SUPPRESS_ABILITY)
			{
				return true;
			}

			return false;
		}
	}
	// damage?
	else if(mCurrentProcessedEffect.IsA('H7EffectDamage'))
	{
		// healing ability/spell? if yes, don't trigger event
		damageEffectTags = mCurrentProcessedEffect.GetTags();
		if(damageEffectTags.Find(TAG_HEAL) >= 0)
		{
			return false;
		}

		// everything else counts as an attack, even if damage was zero due to immunity
		return true;
	}

	// when in doubt, send event
	return true;
}

// tooltip/simulate
// - for effects from the spell that happen to the defender
function AddEffectToTooltip(H7Effect effect,int defenderIdx)
{
	//`log_dui("AddEffectToTooltip to defender" @ defenderIdx @ effect @ mDefenders[defenderIdx] @ mDefenders[defenderIdx].GetName());
	if( defenderIdx >= 0 && defenderIdx < MAX_RESULTS )
	{
		mResults[defenderIdx].mEffects.AddItem(effect);
	}
}

function bool ShowRetaliationLine(int defenderIdx)
{
	local H7Effect effect;
	local array<ESpellTag> tags;

	foreach mResults[defenderIdx].mEffects(effect)
	{
		if(effect.GetSource().IsA('H7CreatureAbility'))
		{
			effect.GetTagsPlusBaseTags( tags );
			if(tags.Find(TAG_NEGATIVE_EFFECT) != INDEX_NONE
				|| tags.Find(TAG_DAMAGE_DIRECT) != INDEX_NONE)
			{
				return true;
			}
			if(effect.IsA('H7DamageEffect')) 
			{
				if(tags.Find(TAG_HEAL) == INDEX_NONE
					|| tags.Find(TAG_REPAIR) == INDEX_NONE)
				{
					return false;
				}
				else
				{
					return true;
				}
			}
		}
	}

	return false;
}

// - for chain reactions / consequences of your actions
// retaliate,absorbs,...
native function AddTriggeredEffect(H7Effect effect, int defenderIdx);

native function ClearTriggeredEffects();

native function bool HasTriggeredEffectFromSource(H7EffectContainer searchSource,int defenderIdx);

/** Check if an effect that suppresses retaliation has triggered for the defender.
 */
native function bool HasRetaliationSuppressEffect(int defenderIdx);

// float value has to be in the format: (1.2 = +20%) (0.8 = -20%) (1.0 = +0%)
function AddMultiplier( H7MultiplierType type, float value , optional int idx )     
{ 
	local H7TooltipMultiplier multiplier;
	if(idx < 0 || idx >= MAX_RESULTS)
	{
		;
		scripttrace();
		return;
	}
	multiplier.name = class'H7Loca'.static.LocalizeSave(String(type),"H7Abilities");
	multiplier.type = type;
	multiplier.value = value;
	mResults[idx].mMultipliers.AddItem(multiplier);
}

function RemoveMultiplier(H7MultiplierType type,int idx) // hack
{
	local H7TooltipMultiplier multiplier;
	foreach mResults[idx].mMultipliers(multiplier)
	{
		if( multiplier.name == class'H7Loca'.static.LocalizeSave(String(type),"H7Abilities") )
		{
			mResults[idx].mMultipliers.RemoveItem( multiplier );
			return;
		}
	}
}

function H7TooltipMultiplier GetMultiplier(H7MultiplierType type, optional int idx)
{
	local array<H7TooltipMultiplier> multipliers;
	local H7TooltipMultiplier multiplier;

	multipliers = GetMultipliers(idx);
	foreach multipliers( multiplier )
	{
		if( multiplier.type == type )
		{
			return multiplier;
		}
	}

	// nothing was found, so indicate that by setting the type to nonsense
	multiplier.type = MT_MAX;

	return multiplier;
}

// calc final multiplier
function CalcFinalDamageModifier( optional int idx )         
{ 
	local H7TooltipMultiplier multiplier;
	local float finalMultiplier;

	if(mResults[idx].mMissed)
	{
		mResults[idx].mDamageModifier = 0.0f;
		return;
	}

	finalMultiplier = 1;
	
	foreach mResults[idx].mMultipliers( multiplier )
	{
		finalMultiplier = finalMultiplier * multiplier.value;
		;
	}
	mResults[idx].mDamageModifier = finalMultiplier;
}

// use final multiplier
function UpdateDamageRange( optional int idx )       
{ 
	local float damageLow,damageHigh;

	;
	CalcFinalDamageModifier( idx );
	;
	damageLow =     GetDamageLow( idx ) * GetFinalDamageModifier( idx );
	damageHigh =    GetDamageHigh( idx ) * GetFinalDamageModifier( idx );
	SetDamageRange( fceil( damageLow ), fceil( damageHigh ) , idx ); 
	;
}

// flanking type now extracted from result
native function EFlankingType GetFlankingType( int idx );

native function EFlankingType GetFlankingTypeForTarget( H7IEffectTargetable target );

function DebugLogSelf(optional bool showForEventHandlingLogs = false)
{
	local int i;

	;
	if( mAttackerUnit != None )
	{
		;
		if(showForEventHandlingLogs) ;
	}
	else
	{
		;
		if(showForEventHandlingLogs) ;
	}

	if(mContainer != none)
	{
		;
		if(showForEventHandlingLogs) ;
	}
	else
	{
		;
		if(showForEventHandlingLogs) ;
	}

	for( i=0; i<GetDefenderCount(); ++i )
	{
		if( mResults[i].mDamage != -1 )
		{
			;
			if(showForEventHandlingLogs) ;
			;
			if(showForEventHandlingLogs) ;
			;
			if(showForEventHandlingLogs) ;
			;
			if(showForEventHandlingLogs) ;
		}
	}
}

function Reset()
{
	local int i;
	super.Reset();
	for( i=0; i<MAX_RESULTS; i++ )
	{
		mResults[i].mDamageLow=0;
		mResults[i].mDamageHigh=0;
		mResults[i].mDamage=-1;
		mResults[i].mKillsLow=0;
		mResults[i].mKillsHigh=0;
		mResults[i].mKills=-1;
		mResults[i].mIsCovered=false;
		mResults[i].mMultipliers.Remove(0,mResults[i].mMultipliers.Length);
		mResults[i].mTriggeredEffects.Remove(0,mResults[i].mTriggeredEffects.Length);
		mResults[i].mEffects.Remove(0,mResults[i].mEffects.Length);
		mResults[i].mDamageModifier = 1;
		mResults[i].mTriggerEvents = true;
	}
}

native function MergeValueFromOther( H7CombatResult resa, optional bool multipleDefenderInsert = true );
