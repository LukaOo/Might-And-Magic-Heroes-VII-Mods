/*=============================================================================
* H7DimensionPortal
* =============================================================================
* Dimension portal: A dimension portal leads to one other dimension portal.
* 
* Works identical like H7Teleporter, but makes end user editor handling easier
* by making sure Dimension portals can only be connected to other Dimenion
* portals (and no whirlpools or underground gates that have the same class)
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7DimensionPortal extends H7Teleporter
	hideCategories(Teleporter)
	native
	placeable;

// The Dimension Portal to warp to
var(DimensionPortal) private H7DimensionPortal mTargetDimensionPortal<DisplayName="Linked Dimension Portal">;

native function H7Teleporter GetTargetTeleporter();
native function protected ClearTargetTeleporter();

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_DIMENSION_PORTAL_DESC","H7Teleporter") $ "</font>";
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


