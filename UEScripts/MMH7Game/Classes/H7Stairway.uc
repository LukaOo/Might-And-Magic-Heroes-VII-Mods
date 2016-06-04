/*=============================================================================
* H7Stairway
* =============================================================================
* Subclass for teleporters that are used as underground/surface gates. Makes
* sure end users can only connect underground/surface gates.
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Stairway extends H7Teleporter
	hideCategories(Teleporter,Coloring)
	native
	placeable;

// The Dimension Portal to warp to
var(Stairway) private H7Stairway mTargetStairway<DisplayName="Linked Stairway">;

native function H7Teleporter GetTargetTeleporter();
native function protected ClearTargetTeleporter();

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_STAIRWAY_DESC","H7Teleporter") $ "</font>";
	return data;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

