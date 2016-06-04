//=============================================================================
// H7SavegameController
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SavegameTask_Loading extends H7SavegameTask_Base
	native(Core);

// -------------------- PRIVATE VARS --------------------

// Save data
var protected transient array<byte> mGameDataBuffer;
// system data
var protected transient int mCurrentLoadStep; // UPLAY + DISK
var native protected pointer mUPlayOverlapOperation; // UPLAY: this is meant to be a void* casted in cpp to UPLAY_Overlapped*
var native protected pointer mUPlayGameList; // UPLAY: this is meant to be a void* casted in cpp to UPLAY_SAVE_GameList*
var native protected pointer mSavegameHandle; // UPLAY: this is meant to be a void* pointing to a UPLAY_SAVE_Handle
var native protected pointer mUPlayByteRead; // UPLAY: this is meant to be a void* pointing to a UPLAY_uint32


// -------------------- PUBLIC FUNCTIONS --------------------

native function StartLoadTask(int SlotIndex);
native function bool FinishSceneLoadTask(); // Call it when GetCurrentTaskState() == ReadyToFinish
native function bool FinishObjectLoadTask(Object Obj); // Call it when GetCurrentTaskState() == ReadyToFinish

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

