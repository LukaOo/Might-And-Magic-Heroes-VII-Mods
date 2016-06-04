//=============================================================================
// H7EffectModifySpellRank
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectModifySpellRank extends Object 
	implements( H7IEffectDelegate )
	hidecategories( Object )
	native(Tussi);

var(Rank) ESkillRank	mRankToSet<DisplayName=Rank with which all spells will be casted|EditCondition=!mIncreaseRank>;
var(Rank) ESkillRank	mRankToCompare<DisplayName="Minimum rank of skill required to set rank override">;
var(Rank) bool			mIncreaseRank<DisplayName="Use next rank">;
var(Rank) bool			mDoNotDowngrade<DisplayName="Don't force higher rank spells to be casted on lower rank">;
var(Rank) H7HeroAbility mSpecificSpell<DisplayName="Specific spell (will be the only spell affected)">;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7HeroAbility spell;
	local H7EditorHero hero;
	local H7Skill skill;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local int rank;
	local bool isRealSpell;

	effect.GetTargets( targets );
	
	spell = H7HeroAbility( container.EffectContainer );
	if( mSpecificSpell != none && !mSpecificSpell.IsEqual( spell ) )
	{
		return;
	}

	isRealSpell = spell.IsSpell(); // be paranoid
	foreach targets( target )
	{
		hero = H7EditorHero( target );
		if( hero != none && spell != none )
		{
			skill = hero.GetSkillManager().GetSkillBySkillType( spell.GetSkillType() );
			if( ( skill != none && skill.GetCurrentSkillRank() >= mRankToCompare ) ||
				( isRealSpell && mRankToCompare <= SR_UNSKILLED ) )
			{
				rank = SR_UNSKILLED;
				if( mIncreaseRank )
				{
					if( skill != none )
					{
						rank = skill.GetCurrentSkillRank();
					}

					if( rank != SR_MASTER )
					{
						rank++;
						if( rank <= spell.GetRankOverride() && spell.GetRankOverride() != SR_MAX )
						{
							return;
						}
						spell.SetRankOverride( ESkillRank( rank ) );
					}
				}
				else
				{
					if( mDoNotDowngrade )
					{
						if( skill != none )
						{
							rank = skill.GetCurrentSkillRank();
						}
						if( rank < mRankToSet )
						{
							if( mRankToSet <= spell.GetRankOverride() && spell.GetRankOverride() != SR_MAX )
							{
								return;
							}
							spell.SetRankOverride( mRankToSet );
						}
					}
					else
					{
						spell.SetRankOverride( mRankToSet );
					}
				}
			}
		}
	}
}


function String GetTooltipReplacement() 
{	
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_SPELLRANK_MOD","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%rank", mRankToCompare);
	ttMessage = Repl(ttMessage, "%rankToSet", mRankToSet);

	return ttMessage;
}

