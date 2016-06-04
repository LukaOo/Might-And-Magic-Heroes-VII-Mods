//=============================================================================
// H7GameUtility
//=============================================================================
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GameUtility extends Object
	dependson( H7ReplicationInfo )
	native;

static native function bool IsCheatsForced() const;

static native function bool IsArchetype(Object obj) const;
static native function bool IsDefaultObject(Object obj) const;
static native function string GetArchetypePath(Object obj) const;
static native function bool CellsContainIntPoint( array<IntPoint> points, IntPoint checkPoint ) const;
static native function Box GetMeshComponentsBoundingBox(Actor actor, optional bool bNonColliding) const;

static native function MapInfo GetAdventureMapMapInfo() const;
static native function string GetAdventureMapName() const;

static native function bool IsCombatMapObject( Object obj );

static native function CopyAllProperties(Object SourceObject, Object DestObject, Class ChildOfProp);

static function array<EPlayerColor> GetSkirmishColors()
{
	local array<EPlayerColor> skirmishColors;

	skirmishColors.AddItem(PCOLOR_BLUE);
	skirmishColors.AddItem(PCOLOR_RED);
	skirmishColors.AddItem(PCOLOR_GREEN);
	skirmishColors.AddItem(PCOLOR_GOLD);
	skirmishColors.AddItem(PCOLOR_PURPLE);
	skirmishColors.AddItem(PCOLOR_SIENA);
	skirmishColors.AddItem(PCOLOR_CYAN);
	skirmishColors.AddItem(PCOLOR_TEAL);

	return skirmishColors;
}

static function int GetFuncDebth()
{
	local String scripttrace;
	local array<String> scriptraceArray;
	scripttrace = GetScriptTrace();
	scriptraceArray = SplitString(scripttrace,"\n");
	return scriptraceArray.Length-4; // -self, -root, -empty line, -headline
}

static function bool IsInFuncDebth(String search)
{
	local String scripttrace;
	scripttrace = GetScriptTrace();
	if(InStr(scripttrace,search) != INDEX_NONE) return true;
	else return false;
}

static function String GetFuncDebthString()
{
	local int debth,i; 
	local String placeholder;
	placeholder = "";
	if(IsInFuncDebth("GetDamageRangeFinal")) placeholder = placeholder $ "*";
	debth = GetFuncDebth()-1; // -self
	for(i=0;i<debth;i++)  
	{
		placeholder = placeholder $ " ";     
	}
	return placeholder;
}

// 0 = if you want to know your function
// -1 = if you want to know the function that called you
static function String GetFunctionName(optional int parentCount=0)
{
	local String scripttrace,line;
	local array<String> scriptraceArray,lineSplit;


	scripttrace = GetScriptTrace();
	scriptraceArray = SplitString(scripttrace,"\n");
	
	line = scriptraceArray[scriptraceArray.Length-3+parentCount]; // -3 (-1 = empty, -2 = GetFunctionName, -3 = calling function)
	
	lineSplit = SplitString(line,":");
	return lineSplit[1];
}

static function LogUSSConditional(String msg)
{
	if(IsInFuncDebth("GetDamageRangeFinal"))
	{
		// skip it
	}
	else
	{
		;
	}
}

static function LogArray(array<H7IEffectTargetable> arr,optional String caption)
{
	local H7IEffectTargetable ob;
	local String logline;
	local int i;

	logline = caption @ arr.Length @ "(";

	foreach arr(ob,i) // wan kenobi
	{
		if(ob != none)
			logline = logline $ ob.GetName() $ ",";
		else
			logline = logline $ "None" $ ",";
	}

	logline = logline $ ")";

	;
}

// max 2 decimal percentages
function static String FloatToPercent(float value)
{
	local int upscaled,main,dec1,dec2;
	upscaled = Round(value * 10000);
	main = FFloor(upscaled / 100);
	dec1 = (upscaled / 10) % 10;
	dec2 = (upscaled / 1) % 10;

	if(dec2 == 0) 
	{
		if(dec1 == 0) return main $ "%";
		else return main $ "." $ dec1 $ "%";
	}
	else return main $ "." $ dec1 $ dec2 $ "%";	
}

// rounds float to 2 degits after the dot
// 1.0000  -> 1
// -1.5    -> -1.5
// 14.7349 -> 14.73
// 7.4992  -> 7.5
// 0.33333 -> 0.33
// 0.5     -> 0.5
function static String FloatToString(float value,optional bool addPlusIfPositive=false)
{
	local int shifted;
	local int dec1,dec2;

	if(float(int(value)) == value) return ((addPlusIfPositive && value>0)?"+":"") $ String(int(value));

	// we have decimal stuff -> round it to x.xx
	value = Round(value * 100) / 100.0f;

	shifted = value * 10;
	dec1 = Abs(shifted % 10); // last digit
	
	shifted = value * 100;
	dec2 = Abs(shifted % 10); // last digit

	return ((addPlusIfPositive && value>0)?"+":"") $ (value>0?FFloor(value):FCeil(value)) $ ((dec1!=0 || dec2!=0)?".":"") $ ((dec1!=0 || dec2!=0)?String(dec1):"") $ ((dec2!=0)?String(dec2):"");
}

native static function Sort_TurnSort( out array<H7IEffectTargetable> List, int Low, int High) const;

native static function int UnitCompareDESC(H7Unit a, H7Unit b) const;

native static function int UnitCompare_NextASC(H7Unit a, H7Unit b) const;

native static function int UnitCompareIndexDESC(H7Unit a, H7Unit b) const;

native static function int UnitCompareASC(H7Unit a, H7Unit b) const;

static function array<H7IEffectTargetable> Concatenate_Targets( array<H7IEffectTargetable> list1, array<H7IEffectTargetable> list2 )
{
	local H7IEffectTargetable t;

	foreach list2(t) 
		list1.AddItem( t );
	
	return list1;
}

static function array<H7IEffectTargetable> Concatenate_UnitsToTargets( array<H7Unit> list1, array<H7Unit> list2 )
{
	local H7Unit t;
	local array<H7IEffectTargetable> tl;
	
	foreach list1(t) 
	{
		tl.AddItem( t );
		;
	}
	foreach list2(t) 
	{
		tl.AddItem( t );
		;
	}
	return tl;
}

static function array<H7Unit> Concatenate_Units( array<H7Unit> list1, array<H7Unit> list2 , optional bool invertAdd)
{
	local H7Unit t;
	local int i;

	if(!invertAdd)
	{
		foreach list2(t) 
			list1.AddItem( t );
	}
	else
	{
		for(i=list2.Length-1;i>=0;i--)
		{
			list1.AddItem(list2[i]);
		}
	}
	return list1;
}

/**
 * Calculates creature costs into a parameter, enabling stacking up costs, if necessary
 * 
 * @param creature      The creature data
 * @param count         Amount of creatures (multiplier)
 * @param costs         The costs array
 * 
 * */
static native function CalculateCreatureCosts( H7Creature creature, int count, out array<H7ResourceQuantity> costs, optional bool upgrade, optional H7Creature baseCreature, optional float currencyModifier = 1.0f, optional H7Resource currencyResource );

function static int DirectionToAngle( EDirection direction )
{
	local int cameraCorrection;
	local H7Camera combatCamera;

	combatCamera = class'H7Camera'.static.GetInstance();

	cameraCorrection =  combatCamera.GetDefaultRotationAngle() - combatCamera.GetCurrentRotationAngle();

	switch(direction)
	{
		case EAST : return class'H7CombatMapCursor'.const.EAST_ANGLE + cameraCorrection;
		case NORTH : return class'H7CombatMapCursor'.const.NORTH_ANGLE + cameraCorrection;
		case NORTH_EAST : return class'H7CombatMapCursor'.const.NORTH_EAST_ANGLE + cameraCorrection;
		case NORTH_WEST : return class'H7CombatMapCursor'.const.NORTH_WEST_ANGLE + cameraCorrection;
		case SOUTH : return class'H7CombatMapCursor'.const.SOUTH_ANGLE + cameraCorrection;
		case SOUTH_EAST : return class'H7CombatMapCursor'.const.SOUTH_EAST_ANGLE + cameraCorrection;
		case SOUTH_WEST : return class'H7CombatMapCursor'.const.SOUTH_WEST_ANGLE + cameraCorrection;
		case WEST : return class'H7CombatMapCursor'.const.WEST_ANGLE + cameraCorrection;
		default: return 0;
	}
}

function static int DirectionToOpposingAngle(EDirection direction)
{
	if(direction == NORTH)
	{
		return class'H7CombatMapCursor'.const.SOUTH_ANGLE;
	}
	else if(direction == NORTH_EAST)
	{
		return class'H7CombatMapCursor'.const.SOUTH_WEST_ANGLE;
	}
	else if(direction == EAST)
	{
		return class'H7CombatMapCursor'.const.WEST_ANGLE;
	}
	else if(direction == SOUTH_EAST)
	{
		return class'H7CombatMapCursor'.const.NORTH_WEST_ANGLE;
	}
	else if(direction == SOUTH)
	{
		return class'H7CombatMapCursor'.const.NORTH_ANGLE;
	}
	else if(direction == SOUTH_WEST)
	{
		return class'H7CombatMapCursor'.const.NORTH_EAST_ANGLE;
	}
	else if(direction == WEST)
	{
		return class'H7CombatMapCursor'.const.EAST_ANGLE;
	}
	else if(direction == NORTH_WEST)
	{
		return class'H7CombatMapCursor'.const.SOUTH_EAST_ANGLE;
	}
	return 0;
}

static native function int PlayerNumberWithoutNeutralToPlayerNumber(EPlayerNumberWithoutNeutral pnwn);
static native function int PlayerNumberToPlayerNumberWithoutNeutral(EPlayerNumber pn);

static native function Color GetColor(EPlayerColor playerColorID);
static native function Color GetEditorColor(EEditorObjectColor editorColor);

function static H7Faction GetChosenFaction(H7Faction chosenFaction, ERandomSiteFaction factionType, EPlayerNumber siteOwner, H7AreaOfControlSiteLord siteLord, array<H7Faction> forbiddenFactions)
{
	local H7Faction excludedFaction;

	if(chosenFaction == none)
	{
		if(factionType == E_H7_RSF_PLAYER)
		{
			chosenFaction = class'H7TransitionData'.static.GetInstance().GetPlayerFactionDuringGameTime(siteOwner);
			if(chosenFaction == none)
			{
				chosenFaction = GetARandomFaction(forbiddenFactions);
			}
		}
		else if(factionType == E_H7_RSF_RANDOM)
		{
			chosenFaction = GetARandomFaction(forbiddenFactions);
		}
		else if(factionType == E_H7_RSF_AS_ANOTHER_TOWN)
		{
			chosenFaction = GetSiteFaction(siteLord, forbiddenFactions);
		}
		else if(factionType == E_H7_RSF_DIFFERENT_FROM_ANOTHER_TOWN)
		{
			excludedFaction = GetSiteFaction(siteLord, forbiddenFactions);
			if(forbiddenFactions.Find(excludedFaction) < 0)
			{
				forbiddenFactions.AddItem(excludedFaction);
			}

			chosenFaction = GetARandomFaction(forbiddenFactions);
		}
	}

	return chosenFaction;
}

function static H7Faction GetARandomFaction(optional array<H7Faction> forbiddenFactions)
{
	local array<H7Faction> allFactions;
	local H7Faction currentFaction;

	class'H7GameData'.static.GetInstance().GetFactions(allFactions);
	foreach forbiddenFactions(currentFaction)
	{
		allFactions.RemoveItem(currentFaction);
	}

	if(allFactions.Length == 0)
	{
		class'H7GameData'.static.GetInstance().GetFactions(allFactions);
	}

	return allFactions[class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(allFactions.Length)];
}

function static H7Faction GetSiteFaction(H7AreaOfControlSiteLord siteLord, array<H7Faction> forbiddenFactions)
{
	local H7IRandomSpawnable randomSpawnable;

	if(siteLord == none)
	{
		return GetARandomFaction(forbiddenFactions);
	}
	else
	{
		randomSpawnable = H7IRandomSpawnable(siteLord);
		if(randomSpawnable == none)
		{
			return siteLord.GetFaction();
		}
		else
		{
			if(randomSpawnable.GetFactionType() == E_H7_RSF_AS_ANOTHER_TOWN)
			{
				return GetARandomFaction(forbiddenFactions);
			}
			else
			{
				return randomSpawnable.GetChosenFaction();
			}
		}
	}
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
