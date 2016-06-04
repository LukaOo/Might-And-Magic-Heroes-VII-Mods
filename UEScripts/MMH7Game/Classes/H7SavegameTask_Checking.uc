//=============================================================================
// H7SavegameController
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SavegameTask_Checking extends H7SavegameTask_Base
	native(Core);

// -------------------- PRIVATE VARS --------------------

var protected transient bool mResultIsSlotFilled;

// system data
var native protected pointer mUPlayOverlapOperation; // UPLAY: this is meant to be a void* casted in cpp to UPLAY_Overlapped*
var native protected pointer mUPlayGameList; // UPLAY: this is meant to be a void* casted in cpp to UPLAY_SAVE_GameList*

// -------------------- PUBLIC FUNCTIONS --------------------

native function StartTaskCheckSlot(int SlotIndex); // use it only for Profile and Quicksave slot
native function bool FinishTaskCheckSlot(out int isSlotFilled); // Call it when GetCurrentTaskState() == ReadyToFinish

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

