class H7SkillwheelCntl extends H7FlashMoviePopupCntl
	dependson(H7StructsAndEnumsNative);

var protected H7GFxSkillwheel mSkillwheelWindow;
var protected H7EditorHero mCurrentHero;
var protected array<H7EditorHero> leveldUpHeroes;
var protected bool mHallOfHeroesMode;
var protected bool mShowAll;
var protected H7ArcaneAcademy mAcademy;
var protected H7SchoolOfWar mSchool;

function array<H7EditorHero>  GetLeveldUpHeros() {return leveldUpHeroes;}
function bool                 GetHallOfHeroesMode() { return mHallOfHeroesMode;}
function H7GFxSkillwheel      GetSkillwheel() { return mSkillwheelWindow; }

function bool Initialize()
{
	;
	Super.Start();

	AdvanceDebug(0);

	mSkillWheelWindow = H7GFxSkillwheel(mRootMC.GetObject("aSkillWheelWindow", class'H7GFxSkillwheel'));

	mSkillwheelWindow.SetVisibleSave(false);
	
	Super.Initialize();
	return true;
}

function Update(H7EditorHero aHero)
{
	if(aHero == none) return;
	if(mOpenedThisFrame) return;

	mOpenedThisFrame = true;
	GetHud().SetFrameTimer(1,ResetOpenedThisFrame);

	mCurrentHero = aHero;
	OpenPopup();
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false); 
	mSkillwheelWindow.Update(mCurrentHero, mShowAll);
}

function UpdateFromHallOfHeroes(H7EditorHero hero)
{
	mCurrentHero = hero;
	mHallOfHeroesMode = true;
	OpenPopup();
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false); 
	mSkillwheelWindow.Update(mCurrentHero, mShowAll);
	mSkillwheelWindow.SetHallOfHeroesMode();
}

function UpdateFromArcaneAcademy(H7AdventureHero hero, H7ArcaneAcademy academy)
{
	mCurrentHero = hero;
	mAcademy = academy;
	OpenPopup();
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false); 
	mSkillwheelWindow.Update(mCurrentHero, mShowAll);
	mSkillwheelWindow.SetArcaneAcademyMode();
}

function UpdateFromSchoolOfWar(H7AdventureHero hero, H7SchoolOfWar school)
{
	mCurrentHero = hero;
	mSchool = school;
	OpenPopup();
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false); 
	mSkillwheelWindow.Update(mCurrentHero, mShowAll);
	mSkillwheelWindow.SetSchoolOfWarMode();
}

/*function bool OpenPopup()
{
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false); 
	return super.OpenPopup();
}*/

function AddLeveldUpHero(H7EditorHero leveldUpHero)
{
	if(leveldUpHero.IsControlledByAI()==false) // only handle human controlled players
	{
		leveldUpHeroes.AddItem(leveldUpHero);
	}
}

function ResolutionChanged()
{
	;
	mSkillwheelWindow.CreateNewSkillwheel();
}

function HeroClick(int heroID)
{
	mSkillwheelWindow.Reset();
	Update(class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(heroID).GetHero());
	mCurrentHero = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(heroID).GetHero();
}

function String GetAbilityDescription(int skillID, String abilityID)
{
	return mCurrentHero.GetSkillManager().GetAbilityByArchetypeID(skillID, abilityID).GetTooltipForCaster(mCurrentHero);
}

function String GetSkillDescription(int skillID, string level)
{
	switch(level)
	{
		case "SR_NOVICE": return mCurrentHero.GetSkillManager().GetSkillInstance(skillID).GetDescription(2);
	
		case "SR_EXPERT": return mCurrentHero.GetSkillManager().GetSkillInstance(skillID).GetDescription(3);
	 
		case "SR_MASTER": return mCurrentHero.GetSkillManager().GetSkillInstance(skillID).GetDescription(4);
	}
	;

	return "Skill description not found! See log for details"; 
}

function bool LearnSkillAbility(bool isSkillLevelUp, string abilityName, int skillID, String abilityID)
{
	;
	if(isSkillLevelUp)
	{
		mCurrentHero.GetSkillManager().IncreaseSkillRank( skillID );		 
	}
	else
	{
		if( mCurrentHero.GetSkillManager().GetSkillInstance( skillID ).GetUltimateSkillAbiliyArchetype().GetArchetypeID() == abilityID  ) 
		{
			mCurrentHero.GetSkillManager().LearnUltimate( skillID, abilityID );
		}
		else
		{
			mCurrentHero.GetSkillManager().LearnAbilityfromSkillByID(skillID, abilityID);
		}
	}
	
	;
	// TODO: move result to Complete function
	
	if(mCurrentHero.GetSkillPoints() > 0 && class'H7AdventureController'.static.GetInstance().GetRandomSkilling())
	{
		mCurrentHero.GetSkillManager().GetRndSkillManager().GenerateNewBatch();
		mSkillwheelWindow.SetNewRandomSkillsAndAbilities(mCurrentHero);
	}
	else if(class'H7AdventureController'.static.GetInstance().GetRandomSkilling())
	{
		mSkillwheelWindow.DisableAll();
		mCurrentHero.GetSkillManager().GetRndSkillManager().DequeueStatIncreases();
	}
	
	if(mAcademy != none) mAcademy.PayPrice();
	if(mSchool != none) mSchool.PayPrice();

	return true;
}

function LearnSkillAbilityComplete()
{
	if(mCurrentHero.GetSkillPoints() == 0) 
	{
		leveldUpHeroes.RemoveItem(mCurrentHero);
		class'H7MessageSystem'.static.GetInstance().DeleteMessagesFrom(mCurrentHero,MD_NOTE_BAR);
	}
}

function SetShowAll(bool showAll)
{
	mShowAll = showAll;
}

function H7GFxUIContainer GetPopup()
{
	return mSkillwheelWindow;
}

function Closed()
{
	;
	ClosePopup();
}

function ClosePopup()
{
	//Reset will be called be super.closePopUp
	mCurrentHero = none;
	mSchool = none;
	mAcademy = none;
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true);
	super.ClosePopup();

	if(mHallOfHeroesMode)
	{
		H7AdventureHud(GetHUD()).GetHallOfHerosCntl().UpdateBackFromSkillwheel();
		mHallOfHeroesMode = false;
	}
}

