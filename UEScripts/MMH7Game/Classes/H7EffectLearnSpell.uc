//=============================================================================
// H7EffectLearnSpell
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectLearnSpell extends Object 
	implements( H7IEffectDelegate )
	hidecategories( Object )
	native(Tussi);

var(LearnSpell) protected array<ESkillType> mForbiddenSkills<DisplayName=Exclude Spells/Abilities of these Types|ToolTip=To Prevent Heroes from Learning Warcries in Combat, Add an Item and Choose "Warcries" from the List>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7HeroAbility spell;
	local H7CombatHero hero;
	local H7Skill skill;
	local H7ICaster caster;
	local string fctMessage;

	// this effect only works on combat map
	if( isSimulated || class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ) 
	{
		return;
	}

	caster = effect.GetSource().GetCasterOriginal();
	if( caster == none ) 
	{
		return;
	}

	hero = H7CombatHero( caster );
	spell = H7HeroAbility( container.EffectContainer );
	if( hero != none && spell != none && !hero.GetAbilityManager().HasAbility( spell ) )
	{
		if( hero.GetFaction().GetForbiddenAbilitySchool() == spell.GetSchool() ) return;

		if( spell.GetSkillType() != SKT_NONE && spell.GetSkillType() != SKT_MAX &&
			mForbiddenSkills.Length > 0 && mForbiddenSkills.Find( spell.GetSkillType() ) != INDEX_NONE) return;

		skill = hero.GetSkillManager().GetSkillBySkillType( spell.GetSkillType() );
		if( skill != none && skill.CanLearnAbility( spell )
			|| spell.IsSpell() && spell.GetRank() <= hero.GetArcaneKnowledge() ) // super paranoid check if spell is really a spell
		{
			fctMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_SOMETHING","H7FCT");
			fctMessage = Repl(fctMessage, "%owner", hero.GetName());
			fctMessage = Repl(fctMessage, "%ability", spell.GetName());
			fctMessage = Repl(fctMessage, "%target", spell.GetCaster().GetName());
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, hero.Location, hero.GetPlayer(), fctMessage,,spell.GetIcon());
			hero.GetAbilityManager().LearnAbility( spell );
		}
	}
}


function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_LEARN_ENEMY_SPELL","H7TooltipReplacement");
}
