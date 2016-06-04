//=============================================================================
// H7SavegameController
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SavegameTaskSlotManager extends Object
	dependson(H7SavegameTask_Base)
	native(Core);

// STATIC ONLY CLASS !

struct native H7SavegameTask_SlotLocking
{
	var int SlotIndex;
	var H7SavegameTask_Base AssociatedTask;
};
var native protected transient array<H7SavegameTask_SlotLocking> mCurrentlyLockedSlot;

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

