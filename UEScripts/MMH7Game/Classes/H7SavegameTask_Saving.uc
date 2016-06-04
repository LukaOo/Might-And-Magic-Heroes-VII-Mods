//=============================================================================
// H7SavegameController
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SavegameTask_Saving extends H7SavegameTask_Base
	native(Core);

// -------------------- PRIVATE VARS --------------------

// Save data
var protected transient array<byte> mGameDataBuffer;
var protected transient H7SavegameSlotType mCurrentSlotType;
var protected transient string mTargetName;

// system data
var protected transient int mCurrentSaveStep; // UPLAY + DISK
var native protected pointer mUPlayOverlapOperation; // UPLAY: this is meant to be a void* casted in cpp to UPLAY_Overlapped*
var native protected pointer mUPlayGameList; // UPLAY: this is meant to be a void* casted in cpp to UPLAY_SAVE_GameList*
var native protected pointer mSavegameHandle; // UPLAY: this is meant to be a void* pointing to a UPLAY_SAVE_Handle

// -------------------- PUBLIC FUNCTIONS --------------------

native function StartSceneSaveTask(int SlotIndex, string SavegameName, out H7SavegameData SavegameHeaderData);
native function StartSceneSaveTaskToAreaSlot(H7SavegameSlotType slotType, string SavegameName, out H7SavegameData SavegameHeaderData);
native function StartObjectSaveTask(int SlotIndex, string SavegameName, object data);
native function StartObjectSaveTaskToAreaSlot(H7SavegameSlotType slotType, string SavegameName, object data);
native function bool FinishSaveTask(); // Call it when GetCurrentTaskState() == ReadyToFinish, returns false on error (check log for more details)
native function bool FinishSaveTaskGetSlot(out int outSlotIndex); // Call it when GetCurrentTaskState() == ReadyToFinish, returns false on error (check log for more details), give slot as out parameter if it succeed

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

