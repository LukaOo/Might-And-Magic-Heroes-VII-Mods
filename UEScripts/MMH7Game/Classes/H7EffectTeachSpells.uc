//=============================================================================
// H7EffectTeachSpells
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectTeachSpells extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster; 
	local array<H7IEffectTargetable>  targets, validTargets;
	local H7IEffectTargetable target, abilityTarget;
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local H7AdventureHero hero;
	local H7Skill skill;
	local string fctMessage;
	local bool learnableThroughArcaneKnowledge;

	if( isSimulated ) return;

	caster = effect.GetSource().GetCaster().GetOriginal();
	abilityTarget = container.Targetable;
	targets = container.TargetableTargets;
	if( targets.Find( abilityTarget ) == INDEX_NONE )
	{
		targets.AddItem( abilityTarget );
	}

	if( targets.Length <= 0 ) 
	{
		return; 
	}
   
	effect.GetValidTargets( targets, validTargets );
	targets = validTargets;
	if( caster != none )
	{
		abilities = caster.GetAbilityManager().GetNonVolatileAbilities();
		foreach abilities( ability )
		{
			if( ability.IsSpell() )
			{
				foreach targets( target )
				{
					hero = H7AdventureHero( target );
					if( hero != none && hero.IsHero() && !hero.GetAbilityManager().HasAbility( ability ) )
					{
						skill = hero.GetSkillManager().GetSkillBySkillType( ability.GetSkillType() );
						if( hero.GetFaction().GetForbiddenAbilitySchool() == ability.GetSchool() ) continue; // forbidden school? better iterate some more

						learnableThroughArcaneKnowledge = ( H7HeroAbility( ability ).GetRank() <= hero.GetArcaneKnowledge() && ability.IsSpell() ); // be paranoid and check if the thing is a spell
						if( skill != none )
						{
							if( skill.CanLearnAbility( H7HeroAbility( ability ) ) )
							{
								fctMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_SOMETHING","H7FCT");
								fctMessage = Repl(fctMessage, "%owner", hero.GetName());
								fctMessage = Repl(fctMessage, "%ability", ability.GetName());
								fctMessage = Repl(fctMessage, "%target", caster.GetName());
								class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, hero.Location, hero.GetPlayer(), fctMessage,,ability.GetIcon());
								hero.GetAbilityManager().LearnAbility( ability );
								continue;
							}
						}

						// if the spell wasn't already learnt bc of skillz, try arcane knowledge instead
						if( learnableThroughArcaneKnowledge )
						{
							fctMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_SOMETHING","H7FCT");
							fctMessage = Repl(fctMessage, "%owner", hero.GetName());
							fctMessage = Repl(fctMessage, "%ability", ability.GetName());
							fctMessage = Repl(fctMessage, "%target", caster.GetName());
							class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, hero.Location, hero.GetPlayer(), fctMessage,,ability.GetIcon());
							hero.GetAbilityManager().LearnAbility( ability );
						}
					}
				}
			}
		}
	}
}


function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_TEACH_SPELL","H7TooltipReplacement");
}
