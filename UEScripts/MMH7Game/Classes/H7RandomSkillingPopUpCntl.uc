//=============================================================================
// H7RandomSkillingPopUpCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RandomSkillingPopUpCntl extends H7FlashMovieBlockPopupCntl implements (H7IQueueable);

var H7EditorHero mCurrentHero;

var protected H7GfxRandomSkillingPopUp mRandomSkillingPopUp;

static function H7RandomSkillingPopUpCntl GetInstance() { return H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHUD()).GetRandomSkillingPopUpCntl();}

function bool Initialize()
{
	;

	Super.Start();

	AdvanceDebug(0);

	mRandomSkillingPopUp = H7GfxRandomSkillingPopUp(mRootMC.GetObject("aRandomSkillingPopUp", class'H7GFxRandomSkillingPopUp'));
	mRandomSkillingPopUp.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function Update(H7EditorHero hero)
{
	local H7PopupParameters params;
	
	mCurrentHero = hero;
	
	mRandomSkillingPopUp.Update(hero);
	if(!OpenPopup())
	{
		params.param1 = hero;
		PutPopupIntoQueue(params, hero.GetPlayer().GetPlayerNumber());
		mRandomSkillingPopUp.ResetBecuaseOpenPopUpFailed();
	}
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

function LearnSkillAbility(bool isSkillLevelUp, string abilityName, int skillID, String abilityID)
{
	;
	if(isSkillLevelUp)
	{
		mCurrentHero.GetSkillManager().IncreaseSkillRank( skillID );		 
	}
	else
	{
		mCurrentHero.GetSkillManager().LearnAbilityfromSkillByID(skillID, abilityID);
	}
	
	;	
}

function LearnSkillAbilityComplete(H7EditorHero hero)
{
	if(hero.GetSkillPoints() > 0)
	{
		mRandomSkillingPopUp.Reset();
		hero.GetSkillManager().GetRndSkillManager().GenerateNewBatch();
		Update(hero);
		return;
	}
	hero.GetSkillManager().GetRndSkillManager().DequeueStatIncreases();
	
	class'H7MessageSystem'.static.GetInstance().DeleteMessagesFrom(hero,MD_NOTE_BAR);
	
	if(mRandomSkillingPopUp.IsVisible())
		ClosePopup();
}

function OpenPopupFromQueue(H7PopupParameters params)
{
	local H7EditorHero hero;
	hero = H7EditorHero(params.param1);
	
	if(H7AdventureArmy( hero.GetArmy() ).GetStrengthValue() <= 0) return;

	mCurrentHero = hero;
;
	Update(hero);

}

function H7GFxUIContainer GetPopup()
{
	return mRandomSkillingPopUp;
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	//Reset will be called be super.closePopUp
	mCurrentHero = none;
	super.ClosePopup();
}

