/*=============================================================================
* H7BlindBrotherMonastery
* =============================================================================
*  Grants the visiting hero a random skill ability
* =============================================================================
*  Copyright 2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7BlindBrotherMonastery extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var(Cost) protected H7ResourceQuantity mCost <DisplayName="Cost">;
var protected savegame bool              mIsHidden;
var protected savegame array<int> mHeroesVisitedList;
var protected savegame H7HeroAbility mRandomlyChoosenAbility;

native function bool IsHiddenX();

function H7ResourceQuantity GetCost() { return mCost; }

event InitAdventureObject()
{
	super.InitAdventureObject();
}

function OnVisit( out H7AdventureHero hero )
{
	local string popUpMessage;
	local H7RndSkillManager rndSkillManager;
	local H7HeroAbility rndAbility;
	local array<H7ResourceQuantity> costArray;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit(hero);

	mVisitingArmy = hero.GetAdventureArmy();

	if(!HasVisited(hero))
	{
		//The visiting hero needs to spend all unspended skillpoints, before he's allowed to visit the building
		if(hero.GetSkillPoints() != 0)
		{
			if( hero.GetPlayer().IsControlledByLocalPlayer() )
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_UNSPENDED_SKILLPOINTS","H7FCT");
				popUpMessage = Repl(popUpMessage, "%owner", hero.GetName());

				class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(255,0,0,255));
			}
			return;
		}

		rndSkillManager = hero.GetSkillManager().GetRndSkillManager();
		if(rndSkillManager.GetPickedAbilitiesLength() <= 0) rndSkillManager.GeneratePoolOfAbilitesToLearn();
		rndAbility = rndSkillManager.PickAbilityFromPool(true,true);

		if(rndAbility == none)
		{
			if( hero.GetPlayer().IsControlledByLocalPlayer() )
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_CANNOT_LEARN_ABILITY","H7FCT");
				popUpMessage = Repl(popUpMessage, "%owner",  mVisitingArmy.GetHero().GetName());
				popUpMessage = Repl(popUpMessage, "%ability", mRandomlyChoosenAbility.GetName());

				class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location,  mVisitingArmy.GetHero().GetPlayer(), popUpMessage, MakeColor(255,0,0,255));
			}
			return;
		}

		popUpMessage = class'H7Loca'.static.LocalizeSave("BLIND_BROTHER_MONASTERY_TEXT","H7Adventure");
		popUpMessage = Repl(popUpMessage, "%amount", mCost.Quantity);
		popUpMessage = Repl(popupMessage, "%resource", mCost.Type.GetName());
		popUpMessage = class'H7Loca'.static.ResolveIconPlaceholders(popUpMessage);

		costArray.AddItem(mCost);

		if( !hero.IsControlledByAI() )
		{
			if( hero.GetPlayer().IsControlledByLocalPlayer() )
			{
				class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoCostPopup(popUpMessage, "YES", "NO", OnAccept, none, costArray);
			}
		}
		else if( hero.GetPlayer().GetResourceSet().CanSpendResource(mCost) )
		{
			OnAccept();
		}
	}
	else
	{
		popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT");
		class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location, hero.GetPlayer(), popUpMessage, MakeColor(255,255,0,255));
	}
	
}

function bool HasVisited( H7AdventureHero hero )
{
	return mHeroesVisitedList.Find( hero.GetID() ) != INDEX_NONE;
}

function OnAccept()
{
	local string popUpMessage;
	local array<H7ResourceQuantity> costArray;

	costArray.AddItem(mCost);
	mVisitingArmy.GetPlayer().GetResourceSet().SpendResources(costArray,,!mVisitingArmy.GetPlayer().IsControlledByAI());

	AddRandomSkillAbility();

	if(mVisitingArmy.GetPlayer().IsControlledByAI()) return;
	
	popUpMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_ABILITY","H7FCT");
	popUpMessage = Repl(popUpMessage, "%owner", mVisitingArmy.GetHero().GetName());
	popUpMessage = Repl(popUpMessage, "%ability", mRandomlyChoosenAbility.GetName());

	class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Location,  mVisitingArmy.GetHero().GetPlayer(), popUpMessage, MakeColor(0,255,0,255), mRandomlyChoosenAbility.GetIcon());
	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(popUpMessage, MD_LOG,,H7PlayerReplicationInfo( class'H7ReplicationInfo'.static.GetInstance().GetALocalPlayerController().PlayerReplicationInfo ).GetPlayerNumber());

}

function AddRandomSkillAbility()
{
	local H7RndSkillManager rndSkillManager;
	local H7Skill skill;
	local H7HeroAbility rndAbility;
	local H7AdventureHero hero;
	local H7InstantCommandLearnAbility command;

	hero = mVisitingArmy.GetHero();
	rndSkillManager = hero.GetSkillManager().GetRndSkillManager();
	rndAbility = rndSkillManager.PickAbilityFromPool(true,true);

	if(rndAbility != none)
	{
		skill = hero.GetSkillManager().GetSkillBySkillType(rndAbility.GetSkillType());
		
		command = new class'H7InstantCommandLearnAbility';
		command.Init( hero, skill.GetID(), rndAbility.GetArchetypeID() );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );

		mRandomlyChoosenAbility = rndAbility;
		mHeroesVisitedList.AddItem(hero.GetID());
	}
	
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;	
	local string message,visited;
	local H7AdventureHero hero;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();

	message = class'H7Loca'.static.LocalizeSave("TT_BLIND_BROTHER_MONASTERY","H7AdvMapObjectToolTip");

	if(	HasVisited(hero) )
	{
		visited = "<font color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_VISITED","H7PermanentBonusSite") $ "</font>";
	}
	else
	{
		visited = "<font color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_NOT_VISITED","H7PermanentBonusSite") $ "</font>";
	}

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ message $ "</font>\n";
	data.Visited = "<font size='22'>"$ visited $ "</font>";

	return data;
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

