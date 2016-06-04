/*=============================================================================
 * H7SeqAct_FinalChoice
 * 
 * Unlock Storypoint in 'Previously On' list of map
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *=============================================================================*/

class H7SeqAct_FinalChoice extends SequenceAction
	implements(H7IAliasable)
	native;

var protected int mInValue;

var protected int mOutValue;

function Activated()
{
	local H7CampaignTransitionManager transManager;
	local int i;

	if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().GetCampTransManager() != none)
	{
		transManager = class'H7PlayerProfile'.static.GetInstance().GetCampTransManager();
	}
	else
	{
		return;
	}

	for(i = 0; i < VariableLinks.Length; ++i)
	{
		if(VariableLinks[i].LinkDesc == "Save Value")
		{
			transManager.SetFinalHeroChoice(mInValue);
		}
		else if(VariableLinks[i].LinkDesc == "Load Value")
		{
			mOutValue = transManager.GetFinalHeroChoice();
		}
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

