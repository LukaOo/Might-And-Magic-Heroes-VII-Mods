/*=============================================================================
 * H7SeqAct_UnlockStorypoint
 * 
 * Unlock Storypoint in 'Previously On' list of map
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *=============================================================================*/

class H7SeqAct_UnlockStorypoint extends SequenceAction
	implements(H7IAliasable)
	native;

// Storypoint index in mapinfo 'Previously On' list
var(Storypoint) protected int mStoryPointIndex<DisplayName="Storypoint index">;

function Activated()
{
	if( class'H7PlayerProfile'.static.GetInstance() != none )
	{
		 class'H7PlayerProfile'.static.GetInstance().UnlockStorypoint(mStoryPointIndex);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

