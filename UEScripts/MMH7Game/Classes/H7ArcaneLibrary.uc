/*=============================================================================
* H7ArcaneLibrary
* =============================================================================
*  Teaches the visiting Hero a random spell
* =============================================================================
*  Copyright 2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7ArcaneLibrary extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var protected savegame bool             mIsHidden;
var(Abilities) protected bool			mUseCustomList <DisplayName = "Use Custom Ability List">;
var(Abilities) array <H7BaseAbility>	mCustomAbilities<DisplayName="Custom Ability List">;
var(Abilities) protected ESkillRank		mRank<DisplayName="Rank of spells granted ('All Ranks' grants for each rank)">;  
var(Abilities) protected int			mNumberOfAbilities<DisplayName="Number of spells granted (per rank)">;
var(Abilities) protected bool           mOnlyOneSpellPerSchool<DisplayName="Only ONE spell per school will be chosen">;
var array <H7BaseAbility>               mGlobalMapAbilities;
var savegame array<H7BaseAbility>       mChosenAbilities;
var protected savegame bool             mSpellDefined;
var protected int                       mRandomAbilityRoll;
var protected savegame array<int>       mHeroesVisitedList;



native function bool IsHiddenX();

event InitAdventureObject()
{
	local bool sorted;
	local int i;
	local H7BaseAbility tempAbility;

	super.InitAdventureObject();

	ChooseAbilities();

	sorted = true;
	while(sorted)
	{
		sorted = false;
		for(i = 0; i < mChosenAbilities.Length; i++)
		{
			if(mChosenAbilities.Length >= i+1) break;
			if(H7HeroAbility( mChosenAbilities[i] ).GetRank() >  H7HeroAbility( mChosenAbilities[i+1] ).GetRank() )
			{
				tempAbility = mChosenAbilities[i];
				mChosenAbilities[i] = mChosenAbilities[i+1];
				mChosenAbilities[i+1] = tempAbility;
				sorted = true;
				break;
			}
		}
	}
}

native function ChooseAbilities();

function OnVisit( out H7AdventureHero hero )
{
	local string popUpMessage;
	local bool abilityRequirements;
	local bool alreadyLearned;
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit(hero);

	mVisitingArmy = hero.GetAdventureArmy();
	
	alreadyLearned = CheckHeroAbilities(hero);
	abilityRequirements = CheckSkillRequirements(hero);

	if(abilityRequirements && !alreadyLearned)
	{
		LearnTheAbility(hero);
	}
	else
	{
		if(!abilityRequirements)
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_DONT_VISIT","H7FCT");
			popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());

			class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(255,0,0,255));
		}
		else if(alreadyLearned)
		{
			if( mChosenAbilities.Length > 1 )
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_ALREADY_LEARNED_ABILITIES","H7FCT");
				popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());

				class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(255,0,0,255));
			}
			else if( mChosenAbilities.Length == 1 )
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_ALREADY_LEARNED_ABILITY","H7FCT");
				popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());
				popUpMessage = Repl(popUpMessage, "%ability", mChosenAbilities[0].GetName());

				class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(255,0,0,255));
			}

			if( mHeroesVisitedList.Find( hero.GetID() ) == INDEX_NONE )
			{
				mHeroesVisitedList.AddItem(hero.GetID());
			}
		}
	}
}

function bool HasVisited( H7AdventureHero hero )
{
	return mHeroesVisitedList.Find( hero.GetID() ) != INDEX_NONE;
}

function bool WillBenefitFromVisit( H7AdventureHero hero )
{
	// have been there
	if( HasVisited(hero) == true ) return false;
	// will not gain anything
	if( CheckHeroAbilities(hero) == true ) return false;
	// can't use the site
	if( CheckSkillRequirements(hero) == false ) return false;
	// good to go
	return true;
}

function bool CheckSkillRequirements(H7AdventureHero hero)
{
	local H7Skill skill;
	local int i;
	local array<H7BaseAbility> learnableAbilities;

	GetLearnableAbilities( hero, learnableAbilities );

	for( i = 0; i < learnableAbilities.Length; ++i )
	{
		skill = hero.GetSkillManager().GetSkillBySkillType( learnableAbilities[i].GetSkillType() );

		if( H7HeroAbility( learnableAbilities[i] ) != none )
		{
			if(H7HeroAbility( learnableAbilities[i]).GetRank() == SR_UNSKILLED )
			{
				return true;
			}

			if( skill != none && skill.CanLearnAbility( H7HeroAbility( learnableAbilities[i] ) ) )
			{
				return true;
			}

			if( H7HeroAbility( learnableAbilities[i] ).IsSpell() && H7HeroAbility( learnableAbilities[i] ).GetRank() <= hero.GetArcaneKnowledge() )
			{
				return true;
			}
		}
		else
		{
			return true;
		}
	}

	return false;
}

function bool CheckHeroAbilities(H7AdventureHero hero)
{
	local int i;
	local bool hasAllFromHere;

	hasAllFromHere = true;
	for( i = 0; i < mChosenAbilities.Length; ++i )
	{
		if( !hero.GetAbilityManager().HasAbility( mChosenAbilities[i] ) )
		{
			hasAllFromHere = false;
			break;
		}
	}

	if( hasAllFromHere )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function LearnTheAbility(H7AdventureHero hero)
{
	local H7AbilityManager heroAbilityManager;
	local H7Message message;
	local string tooltip, popUpMessage;
	local int i;
	local array<H7BaseAbility> learnableAbilities;
	local H7HeroEventParam eventParam;

	heroAbilityManager = hero.GetAbilityManager();
	GetLearnableAbilities( hero, learnableAbilities );

	for( i = 0; i < learnableAbilities.Length; ++i )
	{
		heroAbilityManager.LearnAbility( learnableAbilities[i] );
		tooltip = tooltip $ "\n" $ "<img src='" $ H7HeroAbility(learnableAbilities[i]).GetFlashIconPath() $ "' width='#TT_BODY#' height='#TT_BODY#'>" @ learnableAbilities[i].GetName();

		popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_ABILITY","H7FCT");
		popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());
		popUpMessage = Repl(popUpMessage, "%ability", learnableAbilities[i].GetName());

		//trigger hero learned ability / spell event
		if (H7HeroAbility(learnableAbilities[i]) != none)
		{
			eventParam = new class'H7HeroEventParam';
			eventParam.mEventHeroTemplate = hero.GetSourceArchetype();
			eventParam.mEventPlayerNumber = hero.GetPlayer().GetPlayerNumber();
			eventParam.mEventLearnedAbility = H7HeroAbility(learnableAbilities[i]);

			if(learnableAbilities[i].IsSpell())
			{
				class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnSpell', eventParam, hero);
			}
			else
			{
				class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnAbility', eventParam, hero);
			}
		}

		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(0,255,0,255), learnableAbilities[i].GetIcon());
	}

	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroSpellLearned.CreateMessageBasedOnMe();
	message.mPlayerNumber = hero.GetPlayer().GetPlayerNumber();
	message.AddRepl("%hero",hero.GetName());
	message.settings.referenceObject = hero;
	message.settings.referenceWindowCntl = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetSpellbookCntl(); 
	tooltip = message.GetFormatedText() $ tooltip;
	message.mTooltip = tooltip;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	if( CheckHeroAbilities( hero ) )
	{
		mHeroesVisitedList.AddItem(hero.GetID());
	}

}

function GetLearnableAbilities( H7AdventureHero hero, out array<H7BaseAbility> learnableAbilities )
{
	local H7AbilityManager heroAbilityManager;
	local int i;
	local H7Skill skill;

	learnableAbilities.Length = 0;
	heroAbilityManager = hero.GetAbilityManager();

	for( i = 0; i < mChosenAbilities.Length; ++i )
	{
		skill = hero.GetSkillManager().GetSkillBySkillType( mChosenAbilities[i].GetSkillType() );
		if( !heroAbilityManager.HasAbility( mChosenAbilities[i] ) && 
			hero.GetFaction().GetForbiddenAbilitySchool() != mChosenAbilities[i].GetSchool() &&
			( mChosenAbilities[i].GetSkillType() != SKT_NONE && skill != none && H7HeroAbility( mChosenAbilities[i] ) != none && skill.CanLearnAbility( H7HeroAbility( mChosenAbilities[i] ) ) ||
			mChosenAbilities[i].GetSkillType() == SKT_NONE ||
			H7HeroAbility( mChosenAbilities[i] ) != none &&
			( H7HeroAbility( mChosenAbilities[i] ).GetRank() == SR_UNSKILLED ||
		 	  H7HeroAbility( mChosenAbilities[i] ).IsSpell() && H7HeroAbility( mChosenAbilities[i] ).GetRank() <= hero.GetArcaneKnowledge() ) )
		 	)
		{ 
			learnableAbilities.AddItem( mChosenAbilities[i] ); 
		}
	}
}

function String GetAbilityColor(H7AdventureHero hero, H7BaseAbility ability)
{
	local H7Skill skill;
	
	if(hero.GetAbilityManager().HasAbility(ability))
		return "#ffffff";

	skill = hero.GetSkillManager().GetSkillBySkillType( ability.GetSkillType() );
	if( hero.GetFaction().GetForbiddenAbilitySchool() != ability.GetSchool() &&
		( ability.GetSkillType() != SKT_NONE && skill != none && H7HeroAbility( ability ) != none && skill.CanLearnAbility( H7HeroAbility( ability ) ) ||
		ability.GetSkillType() == SKT_NONE ||
		H7HeroAbility( ability ) != none &&
		( H7HeroAbility( ability ).GetRank() == SR_UNSKILLED ||
		 	H7HeroAbility( ability ).IsSpell() && H7HeroAbility( ability ).GetRank() <= hero.GetArcaneKnowledge() ) )
		)
	{ 
		return "#00dd00";
	}
	else
		return "#dd0000";

	
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local string message, visited, abilitesStr;
	local H7AdventureHero hero;
	local bool alreadyLearned, abilityRequirements;
	local int i;
	local array<H7BaseAbility> learnableAbilities;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();

	GetLearnableAbilities( hero, learnableAbilities );
	message = class'H7Loca'.static.LocalizeSave("TT_ARCANE_LIBRARY","H7AdvMapObjectToolTip");
	

	for( i = 0; i < mChosenAbilities.Length; ++i )
	{
		if(i == 0 || H7HeroAbility(mChosenAbilities[i-1]).GetRank() < H7HeroAbility(mChosenAbilities[i]).GetRank())
		{
			switch( H7HeroAbility(mChosenAbilities[i]).GetRank())
			{
			case 1: abilitesStr = abilitesStr $ class'H7Loca'.static.LocalizeSave("SPELL_RANK_UNSKILLED","H7Combat");
					break;
			case 2: abilitesStr = abilitesStr $ (i>0?"\n":"") $ "<font color='#ffffff'>" $ class'H7Loca'.static.LocalizeSave("SPELL_RANK_NOVICE","H7Combat");
					break;
			case 3: abilitesStr = abilitesStr $ (i>0?"\n":"") $ "<font color='#ffffff'>" $ class'H7Loca'.static.LocalizeSave("SPELL_RANK_EXPERT","H7Combat");
					break;
			case 4: abilitesStr = abilitesStr $ (i>0?"\n":"") $ "<font color='#ffffff'>" $ class'H7Loca'.static.LocalizeSave("SPELL_RANK_MASTER","H7Combat");
					break;
			}
		}
		
		abilitesStr = abilitesStr $ "\n" $ "<img src='img://" $ PathName( mChosenAbilities[i].GetIcon() ) $ "' width='25' height='25'>" $ "<font color='"$GetAbilityColor(hero, mChosenAbilities[i])$"'>" $ mChosenAbilities[i].GetName();
	}
	
	alreadyLearned = CheckHeroAbilities(hero);
	abilityRequirements = CheckSkillRequirements(hero);

	if(!alreadyLearned && abilityRequirements)
	{
		visited = "<font color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_NOT_VISITED","H7PermanentBonusSite") $ "</font>";
	}
	else if(!abilityRequirements && !alreadyLearned)
	{
		visited = "<font color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_HAVNT_REQUIREMENTS","H7AdvMapObjectToolTip") $ "</font>";
	}
	else if(alreadyLearned)
	{
		visited = "<font color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_ALREADY_LEARNED","H7AdvMapObjectToolTip") $ "</font>";
	}

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ message $ "</font>";
	data.strData = "<font size='#TT_BODY#'>" $ abilitesStr $ "</font>";
	data.Visited = "<font size='22'>"$ visited $ "</font>";

	return data;
}

function Hide()
{
	mIsHidden = true;
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

