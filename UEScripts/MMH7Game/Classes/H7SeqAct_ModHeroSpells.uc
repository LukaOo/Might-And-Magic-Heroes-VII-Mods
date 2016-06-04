//=============================================================================
// Adding/Removing units from an hero/army
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_ModHeroSpells extends H7SeqAct_ManipulateHero
	native;

var(Properties) archetype H7HeroAbility mSpell<DisplayName="Spell to learn">;

function Activated()
{
	local H7AdventureArmy army;
	local H7AdventureHero hero;
	local string popUpMessage;
	local H7FCTController fctController;

	if (mSpell == none)
	{
		return;
	}

	army = GetTargetArmy();
	if(army == none)
	{
		return;
	}

	hero = army.GetHero();
	if (hero == none)
	{
		return;
	}

	fctController = class'H7FCTController'.static.GetInstance();

	if(hero.GetAbilityManager().HasAbility( mSpell ))
	{
		popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_ALREADY_LEARNED_ABILITY","H7FCT");
		popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());
		popUpMessage = Repl(popUpMessage, "%ability", mSpell.GetName());
		fctController.startFCT(FCT_TEXT, hero.Location, hero.GetPlayer(), popUpMessage, MakeColor(255,0,0,255));
	}
	else if(CanLearnSpell(hero) )
	{
		if(hero.GetAbilityManager().LearnAbility(mSpell) != none)
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_ABILITY","H7FCT");
			popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());
			popUpMessage = Repl(popUpMessage, "%ability", mSpell.GetName());
			fctController.startFCT(FCT_TEXT, hero.Location, hero.GetPlayer(), popUpMessage, MakeColor(0,255,0,255), mSpell.GetIcon());
		}
	}
}

function bool CanLearnSpell(H7AdventureHero hero)
{
	local H7Skill skill;
	
	if(hero == none)
	{
		return false;
	}

	skill = hero.GetSkillManager().GetSkillBySkillType( mSpell.GetSkillType() );

	if(skill == none)
	{
		return false;
	}

	return hero.GetFaction().GetForbiddenAbilitySchool() != mSpell.GetSchool() && 
		(mSpell.GetRank() == SR_UNSKILLED || skill.CanLearnAbility(mSpell) || mSpell.GetRank() <= hero.GetArcaneKnowledge());
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

