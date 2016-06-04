//=============================================================================
// H7SavegameController
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SavegameTask_Delete extends H7SavegameTask_Base
	native(Core);

// -------------------- PRIVATE VARS --------------------

// system data
var protected transient int mCurrentDeleteStep; // UPLAY + DISK
var native protected pointer mUPlayOverlapOperation; // UPLAY: this is meant to be a void* casted in cpp to UPLAY_Overlapped*

// -------------------- PUBLIC FUNCTIONS --------------------

native function StartDeleteTask(int SlotIndex);
native function bool FinishDeleteTask(); // Call it when GetCurrentTaskState() == ReadyToFinish

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

