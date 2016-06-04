/*=============================================================================
 * H7GlobalName
 * ============================================================================
 * Class that contains a globally usable and localizable name.
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
===============================================================================*/
class H7GlobalName extends Object
	hideCategories(Object)
	perobjectconfig
	notplaceable
	native;

/** The global name */
var(Properties) protected localized string mName<DisplayName="Global Name">;
var protected transient string mNameInst;

function string GetName()
{
	if(mNameInst == "") 
	{
		mNameInst = class'H7Loca'.static.LocalizeContent(self, "mName", mName);
	}
	return mNameInst;
}

