//=============================================================================
// H7ListingSavegame
//=============================================================================
//
//=============================================================================
// Copyright 2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ListingSavegame extends Object
	dependson(H7SaveGameController)
	native(Core);

enum H7SavegameHealthStatus
{
	H7_HS_VALID,
	H7_HS_UNSUPPORTEDVERSION,
	H7_HS_CORRUPTED
};

struct native H7ListingSavegameDataScene
{
	var int SlotIndex;
	var init string Name; // DEPRECATED //
	var H7SavegameHealthStatus HealthStatus; 
	var H7SavegameData SavegameData;

	structdefaultproperties
	{
		SlotIndex = -1;
	}
};

native function Start();
native function Poll(out array<H7ListingSavegameDataScene> outData, out int isPollingOver);
native function Stop();

static native function string GetSavegameFolderPath();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
