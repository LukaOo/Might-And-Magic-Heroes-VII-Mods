//=============================================================================
// H7CombatUnitInfoCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapTestCntl extends H7FlashMovieCntl;

function bool Initialize() 
{
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	Super.Initialize();
	return true;
}

