/*=============================================================================
* H7TownPortal
* =============================================================================
*  Class for the in-town Portal. Heroes can teleport here if this is built.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownPortal extends H7TownBuilding
	native;

// TODO this is used for learning Portal of Asha (remove after gamescom!)
var() protectedwrite H7HeroAbility mAbilitiyToLearn<DisplayName=Ability to Learn|Tooltip=Hero will learn this ability when visiting the town.>;

function H7HeroAbility GetTownPortalSpell()
{
	return mAbilitiyToLearn;
}
