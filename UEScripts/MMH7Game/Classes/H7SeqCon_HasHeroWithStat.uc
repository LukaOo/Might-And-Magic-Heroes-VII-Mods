 // Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
class H7SeqCon_HasHeroWithStat extends H7SeqCon_HasHeroWith
	native;

/* Stat to be checked. */
var(Properties) protected EHeroWithStat mStat<DisplayName="Stat">;
/* How to compare. */
var(Properties) protected ECompareOp mCompareOper<DisplayName="Relation">;
/* The value to check against. */
var(Properties) protected int mTargetValue<DisplayName="Value">;
/* Consider only the base value without any modifications. */
var(Properties) protected bool mBaseOnly<DisplayName="Base only (no modifications)">;

function protected bool IsConditionFulfilledForHero(H7AdventureHero currentHero)
{
	local int currentValue;
	currentValue = GetCurrentStatValue(currentHero);
	return Eval(mCompareOper, currentValue, mTargetValue);
}

function int GetCurrentStatValue(H7AdventureHero hero)
{
	if(mStat == E_H7_HWS_MIGHT)
	{
		return mBaseOnly ? hero.GetAttackBase() : hero.GetAttack();
	}
	else if(mStat == E_H7_HWS_DEFENSE)
	{
		return mBaseOnly ? hero.GetDefenseBase() : hero.GetDefense();
	}
	else if(mStat == E_H7_HWS_MAGIC)
	{
		return mBaseOnly ? hero.GetMagicBase() : hero.GetMagic();
	}
	else if(mStat == E_H7_HWS_SPIRIT)
	{
		return mBaseOnly ? hero.GetSpiritBase() : hero.GetSpirit();
	}
	else if(mStat == E_H7_HWS_LEADERSHIP)
	{
		return mBaseOnly ? hero.GetLeadershipBase() : hero.GetLeadership();
	}
	else if(mStat == E_H7_HWS_DESTINY)
	{
		return mBaseOnly ? hero.GetDestinyBase() : hero.GetDestiny();
	}
	else if(mStat == E_H7_HWS_ARCANE_KNOWLEDGE)
	{
		return mBaseOnly ? hero.GetArcaneKnowledgeBaseAsInt() : hero.GetArcaneKnowledgeAsInt();
	}
	else if(mStat == E_H7_HWS_DAMAGE_MIN)
	{
		return mBaseOnly ? hero.GetMinimumDamageBase() : int(hero.GetMinimumDamage());
	}
	else if(mStat == E_H7_HWS_DAMAGE_MAX)
	{
		return mBaseOnly ? hero.GetMaximumDamageBase() : int(hero.GetMaximumDamage());
	}
	else if(mStat == E_H7_HWS_MANA_CURRENT)
	{
		return hero.GetClampedCurrentMana();
	}
	else if(mStat == E_H7_HWS_MANA_MAX)
	{
		return mBaseOnly ? hero.GetMaxManaBase() : hero.GetMaxMana();
	}
	else if(mStat == E_H7_HWS_MOVEMENT_CURRENT)
	{
		return hero.GetCurrentMovementPoints();
	}
	else if(mStat == E_H7_HWS_MOVEMENT_MAX)
	{
		return mBaseOnly ? hero.GetMovementPointsBase() : hero.GetMovementPoints();
	}
	else if(mStat == E_H7_HWS_LEVEL)
	{
		return hero.GetLevel();
	}
	else if(mStat == E_H7_HWS_EXP_TOTAL)
	{
		return hero.GetExperiencePoints();
	}
	else if(mStat == E_H7_HWS_EXP_NEXT)
	{
		return hero.GetCurrentXPForNextLevel();
	}
	else if(mStat == E_H7_HWS_SKILL_POINTS)
	{
		return hero.GetSkillPoints();
	}
	
	return 0;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

