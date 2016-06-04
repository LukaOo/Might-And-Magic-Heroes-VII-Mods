//=============================================================================
// H7AiSensorParam
//=============================================================================
// Ambigous parameter type used by AiSensor objects. In C++ I would have used
// a union struct but afaik we do not have such things in UScript.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorParam extends Object
	dependson(H7StructsAndEnumsNative);

var EAiSensorParamType  mParamType;
var H7Unit              mUnit;
var H7CombatMapCell     mCMapCell;
var H7AdventureMapCell  mAMapCell;
var H7CombatArmy        mCombatArmy;
var H7AdventureArmy     mAdventureArmy;
var H7VisitableSite     mVisSite;
var H7Player            mPlayer;
var H7TownBuilding      mBuilding;
var H7Town              mTown;
var H7HeroAbility       mHeroAbility;
var H7CreatureAbility   mCreatureAbility;
var H7Teleporter        mTeleporter;
var ResourceStockpile   mResourceStockpile;
var H7BaseCreatureStack mBaseCreatureStack;
var ETargetStat         mCreatureStat;
var ECreatureTier       mCreatureTier;

/// properties 

function EAiSensorParamType         GetPType()                                      { return mParamType; }
function                            SetPType( EAiSensorParamType ptype )            { mParamType = ptype; }
function H7Unit                     GetUnit()                                       { return mUnit; }
function                            SetUnit( H7Unit unit )                          { mUnit = unit; SetPType(SP_UNIT); }
function H7CombatMapCell            GetCMapCell()                                   { return mCMapCell; }
function                            SetCMapCell( H7CombatMapCell cell )             { mCMapCell = cell; SetPType(SP_CMAPCELL); }
function H7AdventureMapCell         GetAMapCell()                                   { return mAMapCell; }
function                            SetAMapCell( H7AdventureMapCell cell )          { mAMapCell = cell; SetPType(SP_AMAPCELL); }
function H7CombatArmy               GetCombatArmy()                                 { return mCombatArmy; }
function                            SetCombatArmy( H7CombatArmy army )              { mCombatArmy = army; SetPType(SP_COMBATARMY); }
function H7AdventureArmy            GetAdventureArmy()                              { return mAdventureArmy; }
function                            SetAdventureArmy( H7AdventureArmy army )        { mAdventureArmy = army; SetPType(SP_ADVENTUREARMY); }
function H7VisitableSite            GetVisSite()                                    { return mVisSite; }
function                            SetVisSite( H7VisitableSite site )              { mVisSite = site; SetPType(SP_VISSITE); }
function H7Player                   GetPlayer( )                                    { return mPlayer; }
function                            SetPlayer( H7Player player )                    { mPlayer = player; SetPType(SP_PLAYER); } 
function H7TownBuilding             GetBuilding()                                   { return mBuilding; }
function                            SetBuilding( H7TownBuilding building )          { mBuilding = building; SetPType(SP_BUILDING); }
function H7Town                     GetTown()                                       { return mTown; }
function                            SetTown( H7Town town )                          { mTown = town; SetPType(SP_TOWN); }
function H7HeroAbility              GetHeroAbility()                                { return mHeroAbility; }
function                            SetHeroAbility( H7HeroAbility ability )         { mHeroAbility = ability; SetPType(SP_HEROABILITY); }
function H7CreatureAbility          GetCreatureAbility()                            { return mCreatureAbility; }
function                            SetCreatureAbility( H7CreatureAbility ability ) { mCreatureAbility = ability; SetPType(SP_CREATUREABILITY); }
function H7Teleporter               GetTeleporter()                                 { return mTeleporter; }
function                            SetTeleporter( H7Teleporter tele )              { mTeleporter = tele; SetPType(SP_TELEPORTER); }
function ResourceStockpile          GetResource()                                   { return mResourceStockpile; }
function                            SetResource( ResourceStockpile rs )             { mResourceStockpile = rs; SetPType(SP_RESOURCE); }
function H7BaseCreatureStack        GetBaseCreatureStack()                          { return mBaseCreatureStack; }
function                            SetBaseCreatureStack( H7BaseCreatureStack c )   { mBaseCreatureStack = c; SetPType(SP_BASECREATURESTACK); }
function ETargetStat                GetCreatureStat()                               { return mCreatureStat; }
function                            SetCreatureStat( ETargetStat stat )             { mCreatureStat = stat; SetPType(SP_CREATURESTAT); }
function ECreatureTier              GetCreatureTier()                               { return mCreatureTier; }
function                            SetCreatureTier( ECreatureTier tier )           { mCreatureTier = tier; SetPType(SP_CREATURETIER); }

/// functions

function Clear()
{
	mParamType= SP_NOTHING;
	mUnit=None;
	mCMapCell=None;
	mAMapCell=None;
	mCombatArmy=None;
	mAdventureArmy=None;
	mVisSite=None;
	mTown=None;
	mHeroAbility=None;
	mCreatureAbility=None;
	mTeleporter=None;
	mBaseCreatureStack=None;
	mCreatureStat=TS_STAT_NONE;
	mCreatureTier=CTIER_CORE;
}
