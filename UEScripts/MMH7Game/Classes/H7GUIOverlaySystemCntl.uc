//=============================================================================
// H7GUIOverlaySystemCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GUIOverlaySystemCntl extends H7FlashMovieCntl;

var protected H7GFxSideBar                mSideBar;
var protected H7GFxUplayNote              mUplayNote;

static function H7GUIOverlaySystemCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetHud().GetGUIOverlaySystemCntl(); }

function    H7GFxSideBar              GetSideBar()                 {   return mSideBar; }
function    H7GFxUplayNote            GetUplayNote()               {   return mUplayNote; }

function bool Initialize() 
{
	;
	// Start playing the movie
     Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mSideBar = H7GFxSideBar(mRootMC.GetObject("aSideBar", class'H7GFxSideBar'));

	mUplayNote = H7GFxUplayNote(mRootMC.GetObject("aUplayNote", class'H7GFxUplayNote'));
	mUplayNote.SetVisibleSave(false);
 
	// class'H7GUIOverlaySystemCntl'.static.GetInstance().GetUplayNote().SetData("Action Completed","You played one map",30):

	Super.Initialize();
	
	return true;
}

function ClickMessage(int id) // messageclicked
{
	local H7Message mes;
	mes = class'H7MessageSystem'.static.GetInstance().GetMessage(id);

	// OPTIONAL move this code to MessageSystem so messages in other destinations have this too

	if(Actor(mes.settings.referenceObject) != none)
	{
		if(mes.settings.referenceWindowCntl.IsA('H7SkillwheelCntl'))
		{
			if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()) return; // no skill wheel in combat
			class'H7AdventureController'.static.GetInstance().SelectArmyByHeroID(H7EditorHero(mes.settings.referenceObject).GetID());
			class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetSkillwheelCntl().Update(H7EditorHero(mes.settings.referenceObject));
			mSideBar.SelectMessage(id);
		}
		else if(mes.destination == MD_SIDE_BAR && mes.settings.referenceObject.IsA('H7CombatHero') 
			&& class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsAWaitingUnit(H7CombatHero(mes.settings.referenceObject)))
		{
			class'H7CombatHudCntl'.static.GetInstance().HeroAttackToggle();
		}
		else
		{
			class'H7Camera'.static.GetInstance().SetFocusActor(Actor(mes.settings.referenceObject));
		}
	}
	else if(H7SeqAct_Quest_NewNode(mes.settings.referenceObject) != none)
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetQuestLogCntl().OpenPopupWithPreselect(
			H7SeqAct_Quest_NewNode(mes.settings.referenceObject)
		);
		mSideBar.SelectMessage(id);
	}
	else
	{
		;
	}
}

