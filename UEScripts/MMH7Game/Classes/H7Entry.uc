/*=============================================================================
* H7Entry - DEPRECATED unused
* =============================================================================
*  Done by 'the Intern'. Handle with care!
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Entry extends H7NeutralSite
	implements(H7ITooltipable)
	dependson(H7ITooltipable)
	placeable;

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;

	data.type = TT_TYPE_STRING;
	data.Title = GetName(); 
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_ENTRY_DESCRIPTION","H7Adventure") $ "</font>";
	return data;
}

