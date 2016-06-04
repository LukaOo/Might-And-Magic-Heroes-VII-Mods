//=============================================================================
// H7SeqCon_TimeUp
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_TimeUp extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

function bool HasProgress() { return mUseTimer; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

