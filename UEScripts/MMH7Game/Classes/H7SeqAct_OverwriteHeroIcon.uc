/*============================================================================
* H7SeqAct_SetUnitIcon
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/

class H7SeqAct_OverwriteHeroIcon extends SequenceAction
	native;

var(Properties) protected archetype H7Unit mUnit<DisplayName="Hero Archetype">;
var(Properties) protected Texture2D mNewTexture<DisplayName="Icon">;
var private H7AdventureArmy mArmy;

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

