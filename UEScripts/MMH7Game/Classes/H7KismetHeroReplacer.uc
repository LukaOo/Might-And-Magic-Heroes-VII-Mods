/*=============================================================================
 * H7KismetHeroReplacer
 * 
 * Tool to replace references to heroes in kismet
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7KismetHeroReplacer extends BrushBuilder
	native(Ed);

// If this is checked, any change of any property or pressing the build button will start the replacement.
var() protected bool mRebuild<DisplayName="Rebuild">;
// If this is checked, you get a list of all nodes that would be changed by the replacement, without any change to the nodes.
var() protected bool mPreview<DisplayName="Preview">;
// The hero you want to replace
var() protected H7EditorHero mOldHero<DisplayName="Old Hero">;
// The hero you want to have referenced instead of the Old Hero
var() protected H7EditorHero mNewHero<DisplayName="New Hero">;

event bool Build()
{
	if (mRebuild)
	{
		ReplaceHeroes();
	}
	return true;
}

native function bool ReplaceHeroes();

