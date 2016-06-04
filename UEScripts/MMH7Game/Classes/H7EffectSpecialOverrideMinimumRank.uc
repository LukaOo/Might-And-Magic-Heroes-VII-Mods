//=============================================================================
// H7EffectSpecialOverrideMinimumRank
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialOverrideMinimumRank extends Object 
	implements( H7IEffectDelegate )
	hidecategories( Object )
	native(Tussi);

var(Rank) ESkillRank	mRankToSet<DisplayName=Rank with which spell will be allowed to cast>;
var(Rank) H7HeroAbility mSpecificSpell<DisplayName=Specific spell (will be the only spell affected)>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7HeroAbility spell;
	local H7EditorHero hero;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;

	effect.GetTargets( targets );
	
	spell = H7HeroAbility( container.EffectContainer );
	if( mSpecificSpell != none && !mSpecificSpell.IsEqual( spell ) )
	{
		return;
	}
	foreach targets( target )
	{
		hero = H7EditorHero( target );
		if( hero != none && spell != none )
		{
			H7HeroAbility( hero.GetAbilityManager().GetAbility( spell ) ).SetMinimumRankOverride( mRankToSet );
		}
	}
}


function String GetTooltipReplacement() 
{	
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_SPELLRANK_MOD","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%rankToSet", mRankToSet);

	return ttMessage;
}

