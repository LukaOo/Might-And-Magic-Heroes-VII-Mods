//=============================================================================
// H7BuffHeroArmyBonus
//=============================================================================
//
// ...
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BuffHeroArmyBonus extends H7BaseBuff
	native(Tussi);

function String GetName()
{
	return class'H7Loca'.static.LocalizeSave("BUFF_HEROARMYBONUS","H7Abilities");
}

function OnApply(optional bool simulate=false)
{
	local H7Unit tUnit;

	mIsDisplayed = false;
 
	if( mTargets.Length > 0 )
	{
		tUnit = H7Unit(mTargets[0]);
	}

	super.OnApply(simulate);

	if( tUnit.GetEntityType() == UNIT_CREATURESTACK )
	{
		BuildDynamicEffects();
	}
	else
	{
		;
	}
}

function BuildDynamicEffects()
{
	local H7EffectOnStats newEffect;
	local H7StatEffect statData; 
	local H7CombatHero hero;
	local H7Unit tUnit;

	if( mTargets.Length > 0 )
	{
		tUnit = H7Unit(mTargets[0]);
	}

	hero = tUnit.GetCombatArmy().GetCombatHero();

	self.SetCaster(hero);

	if(hero == none) ;

	statData.mStatMod.mCombineOperation = OP_TYPE_ADD;
	
	statData.mStatMod.mStat = STAT_DEFENSE;
	statData.mStatMod.mModifierValue = hero.GetDefense();
	newEffect = new class'H7EffectOnStats';
	newEffect.InitSpecific(statData,self);
	mInstanciatedEffects.AddItem(newEffect);

	statData.mStatMod.mStat = STAT_ATTACK;
	statData.mStatMod.mModifierValue = hero.GetAttack();
	newEffect = new class'H7EffectOnStats';
	newEffect.InitSpecific(statData,self);
	mInstanciatedEffects.AddItem(newEffect);

	statData.mStatMod.mStat = STAT_LUCK_DESTINY;
	statData.mStatMod.mModifierValue = hero.GetDestiny();
	newEffect = new class'H7EffectOnStats';
	newEffect.InitSpecific(statData,self);
	mInstanciatedEffects.AddItem(newEffect);

	statData.mStatMod.mStat = STAT_MORALE_LEADERSHIP;
	statData.mStatMod.mModifierValue = hero.GetLeadership();
	newEffect = new class'H7EffectOnStats';
	newEffect.InitSpecific(statData,self);
	mInstanciatedEffects.AddItem(newEffect);
}
