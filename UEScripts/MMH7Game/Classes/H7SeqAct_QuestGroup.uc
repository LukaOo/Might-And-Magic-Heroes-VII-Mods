/*=============================================================================
 * H7SeqAct_QuestGroup
 * 
 * Questgroups gather quests to give them a general additional description.
 * Quests can exist without a questgroup.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_QuestGroup extends SequenceAction
	implements(H7IAliasable)
	perobjectconfig
	native;

// The name of the questgroup that is shown in the quest log in game.
var(Properties) protected localized string mTitle<DisplayName="Title">;
var protected string mTitleInst;
// A text for narrative purposes.
var(Properties) protected localized string mDescription<DisplayName="Description">;
var protected string mDescriptionInst;

var(Developer) protected bool mPrimary<DisplayName="Primary">;

function string GetTitle()
{
	if(mTitleInst == "") 
	{
		mTitleInst = class'H7Loca'.static.LocalizeKismetObject(self, "mTitle", mTitle);
	}
	return mTitleInst;
}

function string GetDescription()
{
	if(mDescriptionInst == "") 
	{
		mDescriptionInst = class'H7Loca'.static.LocalizeKismetObject(self, "mDescription", mDescription);
	}
	return mDescriptionInst;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

