//=============================================================================
// H7IAdventureMapCellInteractor
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

interface H7IAdventureMapCellInteractor
	native(Ed);

function native virtual OnArmyRegister(H7AdventureArmy army); // override (interface)
function native virtual OnArmyUnregister(H7AdventureArmy army, H7AdventureMapCell newDestinationCell); // override (interface)

// Add new virtual function here that a child could override and react to.

