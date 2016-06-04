//=============================================================================
// H7Class
//=============================================================================
// Class for a Hero class
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroClass extends Object
	implements(H7IAliasable)
	perobjectconfig
	native;

var(HeroStats) protected editoronly H7BaseAbility mAttackAbilityTemplate<DisplayName="Hero Attack">;
var(HeroStats) protected editoronly int mMight<DisplayName="Might"|ClampMin=0>;
var(HeroStats) protected editoronly int mDefense<DisplayName="Defense"|ClampMin=0>;
var(HeroStats) protected editoronly int mMagic<DisplayName="Magic"|ClampMin=0>;
var(HeroStats) protected editoronly int mSpirit<DisplayName="Spirit"|Clamp=0>;
var(HeroStats) protected editoronly int mLeadership<DisplayName="Leadership"|ClampMin=0>;
var(HeroStats) protected editoronly int mDestiny<DisplayName="Destiny"|ClampMin=0>;

var(HeroClass) protected localized string           mName                            <DisplayName="Name">;
var(HeroClass) protected H7HeroClassProgress        mClassProgress                   <DisplayName="Defines what stats this class will get when leveling up">;
var(HeroClass) protected H7ClassSkillData           mEditorSkills[10]                <DisplayName="Skills">; // correct game design skills of this class                

var protected array<H7ClassSkillData>               mSkills;    // final skills used at runtime
var protected array<H7HeroSkill>                    mPreSkills; // tmp array to write the overwrite skills into from the hero

function string                                     GetName()                        { return class'H7Loca'.static.LocalizeContent( self, "mName", mName ); }
function H7HeroClassProgress                        GetClassProgress()               { return mClassProgress; };
function array<H7ClassSkillData>                    GetSkills()                      { return mSkills; }

function array<H7ClassSkillData>                             GetEditorSkills()                
{
	local array<H7ClassSkillData> skills;
	local int i;
	
	for(i=0;i<10;i++)
	{
		skills.AddItem(mEditorSkills[i]);
	}
	return skills;
}


function Init( H7EditorHero hero)
{
	local H7ClassSkillData skillAtSlot;
	local array<H7Skill> tmpSkills;
	local int i,j;

	// clear all, for some reason it's not empty here
	mSkills.Remove( 0, mSkills.Length );
	mPreSkills.Remove( 0, mPreSkills.Length );

	hero.GetPreLearnedHeroSkills( mPreSkills );

	// if overrride from EditorHero
	// copy editor -> prop.
	for (i=0;i<ArrayCount(mEditorSkills); ++i )
	{
		
		// For Campaign Heroes, learn Skills that are defined on the Map
		if(hero.GetIsOverrideHeroClass() && mPreSkills.Length > i && mPreSkills[i].Skill!= None)
		{   
			skillAtSlot.Skill = mPreSkills[i].Skill; // use overwrite skill   
			skillAtSlot.Tier = mPreSkills[i].Tier;
		}
		else if(mEditorSkills[i].Skill != none && mEditorSkills[i].Skill !=None ) // only add set skills and no empty entries
		{
			skillAtSlot.Skill = mEditorSkills[i].Skill; // use correct class skill
			skillAtSlot.Tier = mEditorSkills[i].Tier;
		}
		
		tmpSkills.Length = 0;

		for(j=0;j < mSkills.Length; ++j ) 
		{
			tmpSkills.AddItem( mSkills[j].Skill );
		}

		// since some of the skills come from the class and some from the overwrite-data-set, skills can be double added, prevent it
		if(skillAtSlot.Skill != none && tmpSkills.Find(skillAtSlot.Skill) == INDEX_NONE)
		{
			mSkills.AddItem(skillAtSlot);
		}
	}

	InitializeClassSkills(hero);
}

function InitializeClassSkills(H7EditorHero hero)
{
	local H7ClassSkillData skill;  
	local H7HeroSkill overwriteData;
	local int rankIndex;

	
	foreach mSkills( skill ) 
	{
		if( skill.Skill == none)
			continue;
		
		hero.GetSkillManager().InitializeSkill( skill.Skill, skill.Tier );

		// use override skills + abilities from EditorHero 
		if( hero.GetIsOverrideHeroClass() )
		{
			foreach mPreSkills( overwriteData )
			{
				if( overwriteData.Skill == skill.Skill ) // match
				{
					for (rankIndex=SR_NOVICE;rankIndex<=overwriteData.Rank;++rankIndex)  
					{
						// costs no skill points because initialize 
						hero.GetSkillManager().IncreaseSkillRankComplete( hero.GetSkillManager().GetSkillInstance( , skill.Skill ).GetID() , true, true );
					}

					if( overwriteData.LearnedAbilities.Length > 0 )
					{   
						// costs skill points
						hero.GetSkillManager().InitializePreLearnedAbilities( overwriteData.LearnedAbilities );
					}
				}
			}
		}
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

