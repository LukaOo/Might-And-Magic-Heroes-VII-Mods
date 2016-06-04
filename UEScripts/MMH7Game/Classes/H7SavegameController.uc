//=============================================================================
// H7SavegameController
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SavegameController extends Object
	dependson(H7SavegameDataHolder)
	native(Core);

// ULTRA IMPORTANT: NEVER MAKE AN INSTANCE OF THIS CLASS ( use the static one with class'H7SavegameController'.static ) !

// Used for Serializing a struct
var savegame transient H7SavegameData mHeaderData;

// Static Config data
const SLOT_PROFILE = 960;
const SLOT_QUICKSAVE = 970;
const SLOT_OFFICIALCAMPAIGNTRANSITION = 975;
const SLOT_AUTOSAVE_AREA_START = 980;
const SLOT_AUTOSAVE_COUNT = 8; // For 1 week + 1 day to include the previous week monday
const SLOT_FREE_AREA_START = 1000;

enum H7SavegameSlotType
{
	H7SavegameSlotType_Normal,
	H7SavegameSlotType_Quicksave,
	H7SavegameSlotType_Autosave,
	H7SavegameSlotType_Profile,
	H7SavegameSlotType_CampaignTransition,
};

enum H7SavegameControllerTaskState
{
	H7SavegameControllerTaskState_None,
	H7SavegameControllerTaskState_InProgress,
	H7SavegameControllerTaskState_ReadyToFinish
};

enum H7SavegameControllerSaveType
{
	H7SavegameControllerSaveType_None,
	H7SavegameControllerSaveType_Disk,
	H7SavegameControllerSaveType_UPlay
};

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

