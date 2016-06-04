/*=============================================================================
* H7Whirlpool
* =============================================================================
* Subclass for teleporters that are used as whirlpools. Makes sure end users
* cannot connect regular Dimension Portals and Whirlpools (splash!).
* =============================================================================
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Whirlpool extends H7Teleporter
	hideCategories(Teleporter,Coloring)
	native
	placeable;

// The Dimension Portal to warp to
var(Whirlpool) private H7Whirlpool mTargetWhirlpool<DisplayName="Linked Whirlpool">;

native function H7Teleporter GetTargetTeleporter();
native function protected ClearTargetTeleporter();

function ToggleVisibility()
{
	mFX.SetHidden(!mFX.HiddenGame);
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function SetVisibility(bool show)
{
	mFX.SetHidden(!show);
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_WHIRLPOOL_DESC","H7Teleporter") $ "</font>";
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

