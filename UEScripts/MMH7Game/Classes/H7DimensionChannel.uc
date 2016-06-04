/*=============================================================================
* H7DimensionChannel
* =============================================================================
* A dimension channel is a one way teleport to a channel exit.
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7DimensionChannel extends H7Teleporter
	hideCategories(Teleporter)
	native
	placeable;

var(DimensionChannel) private H7DimensionChannelExit mTargetDimensionChannelExit<DisplayName="Linked Exit"|ToolTip="The Exit to warp to">;

native function H7Teleporter GetTargetTeleporter();
native function protected ClearTargetTeleporter();

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_DIMENSION_CHANNEL_DESC","H7Teleporter") $ "</font>";
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

