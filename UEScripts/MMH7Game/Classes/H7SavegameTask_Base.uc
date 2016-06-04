//=============================================================================
// H7SavegameController
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SavegameTask_Base extends Object
	abstract
	dependson(H7SavegameController)
	native(Core);

// -------------------- PRIVATE VARS --------------------

var protected transient H7SavegameControllerTaskState mCurrentState;
var protected transient H7SavegameControllerSaveType mCurrentSavegameSystem;
var protected transient bool mIsErrorTriggered;

// Save data
var protected transient int mTargetSlotIndex;

// -------------------- PUBLIC FUNCTIONS --------------------

native function H7SavegameControllerTaskState GetCurrentTaskState() const;
native function UpdateStatus(); // Call it while GetCurrentTaskState() == InProgress

function int GetTargetSlotIndex() { return mTargetSlotIndex; } 

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

