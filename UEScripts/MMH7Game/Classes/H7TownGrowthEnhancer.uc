/*=============================================================================
* H7TownGrowthEnhancer
* =============================================================================
*  Class for describing buildings that increase creature income.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownGrowthEnhancer extends H7TownBuilding;

/** E.g. Sentinel or Crossbowman, not Praetorian or Sharpshooter */
var(Properties) protected H7Creature mCreatureType<DisplayName=Base Creature Type>;
var(Properties) protected int mBonus<DisplayName=Growth Bonus|ClampMin=1>;

function H7Creature GetCreatureType()		{ return mCreatureType; }
function SetCreatureType( H7Creature t )	{ mCreatureType = t; }
function int GetBonus()						{ return mBonus; }
function SetBonus( int bonus )				{ mBonus = bonus; }
