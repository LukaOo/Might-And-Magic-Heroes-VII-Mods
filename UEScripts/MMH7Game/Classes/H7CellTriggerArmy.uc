//=============================================================================
// H7CellTriggerArmy
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CellTriggerArmy extends H7AdventureCellMarker
	implements(H7IAdventureMapCellInteractor)
	native
	placeable;

var protected array<H7AdventureArmy> mRegisteredArmies;

function native virtual OnArmyRegister(H7AdventureArmy army); // override (interface)
function native virtual OnArmyUnregister(H7AdventureArmy army, H7AdventureMapCell newDestinationCell); // override (interface)

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

