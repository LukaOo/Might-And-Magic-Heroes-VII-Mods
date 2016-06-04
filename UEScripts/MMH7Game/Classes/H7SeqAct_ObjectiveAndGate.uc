/*=============================================================================
 * H7SeqAct_StartNpcScene
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/
class H7SeqAct_ObjectiveAndGate extends SequenceAction
	native
	savegame;

const STAGE_MAX = 9;

/** The fired state for each gate input link */
var protected savegame array<H7SeqAct_ObjectiveAndGateStatus> mStageGateStati;
var() bool mSkip;//Quick and dirty hack to bypass, used by H7Questmet (for skirmish)

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

