//=============================================================================
// H7SeqAct_CastHeroAbility
//=============================================================================
// Kismet action to cast a hero's ability
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_CastHeroAbility extends SequenceAction;

/** The army that contains the ability casting hero */
var(Properties) protected H7AdventureArmy mInteractingHero<DisplayName="Caster">;
/** The ability that should be cast */
var(Properties) protected H7HeroAbility mAbility<DisplayName="Ability">;
/** The target of the ability */
var(Properties) protected H7IEffectTargetable mTarget<DisplayName="Target">;

event Activated()
{
	local H7AdventureHero hero;
	if (mInteractingHero != none)
	{
		hero = mInteractingHero.GetHero();
		hero.PrepareAbility(mAbility);
		hero.UsePreparedAbility(mTarget);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

