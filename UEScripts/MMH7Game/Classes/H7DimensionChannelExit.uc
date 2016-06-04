/*=============================================================================
* H7DimensionChannelExit
* =============================================================================
* A dimension channel is a one way teleport to a channel exit.
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7DimensionChannelExit extends H7Teleporter
	hideCategories(Teleporter,Coloring)
	native
	placeable;

native function H7Teleporter GetTargetTeleporter();

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_DIMENSION_CHANNEL_EXIT_DESC","H7Teleporter") $ "</font>";
	return data;
}

