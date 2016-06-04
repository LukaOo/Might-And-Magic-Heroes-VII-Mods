/*=============================================================================
* H7SchoolOfWar
* =============================================================================
*  Grants for a price a might skill
* =============================================================================
*  Copyright 2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7SchoolOfWar extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native;

var(CostSetup)      protected Array<H7ResourceQuantity>         mCosts;

var protected bool                       mIsHidden;
var protected savegame array<int>        mHeroesVisitedList;

native function bool IsHiddenX();

event InitAdventureObject()
{
	super.InitAdventureObject();
}

function OnVisit( out H7AdventureHero hero )
{
	local string popUpMessage;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit(hero);

	mVisitingArmy = hero.GetAdventureArmy();

	// sry only once
	if( HasVisited( hero ) )
	{
		if( hero.GetPlayer().IsControlledByLocalPlayer() )
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_ALREADY_IMPROVED_SKILLPOINTS","H7FCT");
			popUpMessage = Repl(popUpMessage, "%hero", hero.GetName());

			//class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(255,0,0,255));
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().OKPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp") );
		}
		return;
	}

	//The visiting hero needs to spend all unspended skillpoints, before he's allowed to visit the building
	if( hero.GetSkillPoints() != 0 && hero.GetPlayer().IsControlledByLocalPlayer() )
	{
		popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_UNSPENDED_SKILLPOINTS","H7FCT");
		popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());

		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(255,0,0,255));

		return;
	}

	if( hero.GetPlayer().IsControlledByAI() && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled() )
	{
		if( FulfillRequirements( hero ) && hero.GetPlayer().GetResourceSet().CanSpendResources( mCosts ) )
		{
			hero.GetPlayer().GetResourceSet().SpendResources( mCosts, false, true );
			hero.GetSkillManager().IncreaseRandomMightSkillRank();
		}
	}
	else if( hero.GetPlayer().IsControlledByLocalPlayer() )
	{
		if( FulfillRequirements(hero) )
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("PU_SCHOOL_OF_WAR","H7PopUp");
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ACCEPT","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Accept, Leave, mCosts );
		}
		else
		{
			if(HasUnskilledMightSkills(hero))
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("PU_MIGHT_DONT_FULFILL_REQ","H7PopUp");
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().OKPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp") );
			}
			else
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("PU_ALL_SKILLS_LEARNED","H7PopUp");
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().OKPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp") );
			}
		}
	}
}

function Accept()
{
	local H7Skill skill;
	local H7Message message;

	//class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("HUD_SKILLWHEEL_CLICK_WIDGET");
	//class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetSkillwheelCntl().Update( mVisitingArmy.GetHero() ); //UpdateFromArcaneAcademy(mVisitingArmy.GetHero(), self);
	skill = LearnRandomSkill(mVisitingArmy.GetHero());
	
	if( skill != none ) 
	{
		if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == mVisitingArmy.GetPlayer())
		{
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroSkillIncrease.CreateMessageBasedOnMe();
			message.AddRepl("%hero", mVisitingArmy.GetHero().GetName());
			message.AddRepl("%skill", skill.GetName());
			message.AddRepl("%rank", class'H7Loca'.static.LocalizeSave(string(skill.GetCurrentSkillRank()),"H7abilities")  );
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
		PayPrice();
	}
}

function PayPrice()
{
	//TODO Connect this to the skillwheel, when confirming the skill
	mVisitingArmy.GetHero().GetPlayer().GetResourceSet().SpendResources(mCosts, true, true);
	mHeroesVisitedList.AddItem(mVisitingArmy.GetHero().GetID());
}

function Leave()
{
	return;
}

function bool FulfillRequirements(H7AdventureHero hero)
{
	local H7Skill skill;
	local array<H7Skill> skills;

	skills = hero.GetSkillManager().GetAllSkills();

	ForEach skills(skill)
	{
		if(hero.GetSkillManager().CanIncreaseSkillRank(skill.GetID()) && skill.IsMight()
			&& skill.GetCurrentSkillRank() != SR_UNSKILLED )
			return true;
	}

	return false;
}

function bool CanAffordTicket(H7AdventureHero hero)
{
	if(hero!=none && hero.GetPlayer().GetPlayerNumber()!=PN_NEUTRAL_PLAYER )
	{
		return hero.GetPlayer().GetResourceSet().CanSpendResources(mCosts);
	}
	return false;
}

function H7Skill LearnRandomSkill(H7AdventureHero hero ) 
{
	local array<H7Skill> skills,skillPool;
	local int rndNumber; 
	local H7Skill skill,choosenSkill;

	skills = hero.GetSkillManager().GetAllSkills();
	
	// create pool
	ForEach skills(skill)
	{
		if(hero.GetSkillManager().CanIncreaseSkillRank(skill.GetID()) && skill.IsMight()
			&& skill.GetCurrentSkillRank() != SR_UNSKILLED )
		{
			skillPool.AddItem( skill );
		}
	}
	
	if( skillPool.Length == 0 ) 
		return none;

	// pick skill rnd ( should not use GetSynchRNG, just the normal one ) 
	rndNumber = Rand( skillPool.Length );
	choosenSkill = skillPool[rndNumber];
	hero.GetSkillManager().IncreaseSkillRank( choosenSkill.GetID(), false , true );
	
	return choosenSkill;
}

function bool WillBenefitFromVisit( H7AdventureHero hero )
{
	// will not gain anything
	if( FulfillRequirements(hero) == false ) return false;
	// can't use the site
	if( CanAffordTicket(hero) == false ) return false;
	// good to go
	return true;
}


function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;	
	local string message,visited;
	local H7AdventureHero hero;
	local bool hasUpgradeableMightSkills;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();

	hasUpgradeableMightSkills = FulfillRequirements(hero);
	
	message = class'H7Loca'.static.LocalizeSave("TT_SCHOOL_OF_WAR","H7AdvMapObjectToolTip");

	if(mVisitingArmy != none && HasVisited(mVisitingArmy.GetHero()))
	{
		visited = "<font color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_VISITED","H7PermanentBonusSite") $ "</font>";
	}
	else if(	hasUpgradeableMightSkills )
	{
		visited = "<font color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_CAN_IMPROVE","H7AdvMapObjectToolTip") $ "</font>";
	}
	else if(hero != none && HasUnskilledMightSkills(hero))
	{
		visited = "<font color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_CAN_NOT_IMPROVE","H7AdvMapObjectToolTip") $ "</font>";
	}

	data.type = TT_TYPE_STRING;
	data.Title = self.GetName();
	data.Description = "<font size='#TT_BODY#'>" $ message $ "</font>";
	data.Visited = "<font size='22'>"$ visited $ "</font>";

	return data;
}

function bool HasVisited( H7AdventureHero hero )
{
	return mHeroesVisitedList.Find( hero.GetID() ) != INDEX_NONE;
}

function bool HasUnskilledMightSkills(H7AdventureHero hero)
{
	local H7Skill skill;
	local array<H7Skill> skills;

	skills = hero.GetSkillManager().GetAllSkills();

	ForEach skills(skill)
	{
		if(skill.IsMight() && skill.GetCurrentSkillRank() == SR_UNSKILLED)
			return true;
	}

	return false;
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

