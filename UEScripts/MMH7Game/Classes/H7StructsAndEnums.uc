//=============================================================================
// H7StructsAndEnumsNative
//=============================================================================
// Contains all non-native enums depicted in the 
// refactoring Wish List on Confluence.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7StructsAndEnums extends H7StructsAndEnumsNative
	abstract;

// maximum number of int params for instant commands !Defined twice!
const INSTANT_COMMAND_MAX_INT_PARAMS = 8;

//from H7EditorHero
enum EHeroAffinity
{
	AFF_MIGHT<DisplayName="Might">,
	AFF_MAGIC<DisplayName="Magic">,
};

//====== A I ======
//from H7AiCombatSensors
enum EAiCombatSensor
{
	ACS_ArmyHasRangeAttack      <DisplayName=army has range attack>,
	ACS_GridCellReachable       <DisplayName=grid cell is reachable>,
	ACS_GeomDistance            <DisplayName=geometric distance>,
	ACS_CanRangeAttack          <DisplayName=unit can range attack>,
	ACS_CanRetaliate            <DisplayName=unit can retaliate>,
	ACS_ThreatLevel             <DisplayName=grid cell threat level>,
	ACS_HasAdjacentEnemy        <DisplayName=unit has enemy in melee range>,
	ACS_HPPercentLoss           <DisplayName=creature stack hp loss percentage>,
	ACS_HPPercentLossRetaliate  <DisplayName=creature stack hp loss percentage upon getting retaliated>,
	ACS_CanMoveAttack           <DisplayName=unit can move to and attack target unit>,
	ACS_HasGreaterDamage        <DisplayName=unit has greater damage than another unit>,
	ACS_CanCastBuff             <DisplayName=unit can cast a buff type spell>,
	ACS_MeleeCasualityCount     <DisplayName=melee casuality count>,
	ACS_MeleeCreatureDamage     <DisplayName=melee creature damage>,
	ACS_RangeCasualityCount     <DisplayName=range casuality count>,
	ACS_RangeCreatureDamage     <DisplayName=range creature damage>,
	ACS_ManaCost                <DisplayName=relative mana cost>,
	ACS_SpellTargetCheck        <DisplayName=spell target check>,
	ACS_HealingPercentage       <DisplayName=healing percentage>,
	ACS_AbilityCasualityCount   <DisplayName=ability casuality count>,
	ACS_AbilityCreatureDamage   <DisplayName=ability creature damage>,
	ACS_Opportunity             <DisplayName=opportunity>,
	ACS_SpellSingleDamage       <DisplayName=spell single damage>,
	ACS_SpellMultiDamage        <DisplayName=spell multi damage>,
	ACS_SpellSingleHeal         <DisplayName=spell single heal>,
	ACS_SpellMultiHeal          <DisplayName=spell multi heal>,
	ACS_CreatureCount           <DisplayName=creature count>,
	ACS_CreatureStrength        <DisplayName=creature strength>,
	ACS_MoveDistance            <DisplayName=move distance>,
	ACS_CreatureStat            <DisplayName=creature stat>,
	ACS_CreatureIsRanged        <DisplayName=creature is ranged>,
	ACS_CreatureAdjacentToEnemy <DisplayName=creature is adjacent to enemy>,
	ACS_CreatureAdjacentToAlly  <DisplayName=creature is adjacent to ally>,
	ACS_CreatureTier            <DisplayName=creature tier>,
	ACS_CreatureCanAttack       <DisplayName=creature can attack>,
	ACS_CreatureCanBeAttacked   <DisplayName=creature can be attacked>,
	ACS_RangedCreatureCount     <DisplayName=ranged creature count>,
	ACS_GoodTimeToWait          <DisplayName=good time to wait>,
};

enum EAiAdventureSensor
{
	AAS_ArmyStrength						<DisplayName=army strength>,
	AAS_ArmyStrengthCombined				<DisplayName=combined army strength>,
	AAS_DistanceToTarget					<DisplayName=distance to target>,
	AAS_TargetInterest						<DisplayName=target gain>,
	AAS_ArmyStrengthCombinedNoHero			<DisplayName=combined army strength without hero>,
	AAS_HeroCount							<DisplayName=hero count>,
	AAS_GameProgress						<DisplayName=game progress>,
	AAS_TownDistance						<DisplayName=town distance>,
	AAS_PlayerArmiesCompare					<DisplayName=compare player armies>,
	AAS_PoolGarrison						<DisplayName=pool garrison>,
	AAS_TownBuilding						<DisplayName=town building>,
	AAS_GameDayOfWeek						<DisplayName=game day of week>,
	AAS_TradeResource						<DisplayName=trade resource>,
	AAS_ResourceStockpile					<DisplayName=resource stockpile>,
	AAS_TownDefense							<DisplayName=town defense>,
	AAS_TownArmyCount						<DisplayName=town army count>,
	AAS_HireHeroCount						<DisplayName=hire hero count>,
	AAS_SiteAvailable						<DisplayName=site available>,
	AAS_InstantRecall						<DisplayName=instant recall>,
	AAS_TeleportInterest					<DisplayName=teleport interest>,
	AAS_CanUpgrade							<DisplayName=can upgrade>,
	AAS_ArmyStrengthCombinedReverse			<DisplayName=combined army strength reverse>,
	AAS_UpgradeStrength						<DisplayName=upgrade strength>,
	AAS_TownThreat							<DisplayName=town threat>,
	AAS_TargetThreat						<DisplayName=target threat>,
	AAS_TargetCutoffRange					<DisplayName=target cutoff range>,
	AAS_ArmyStrengthCombinedGlobal			<DisplayName=combined army strength global>,
	AAS_ArmyStrengthCombinedGlobalReverse   <DisplayName=combined army strength global reverse>,
};

//from H7AiActionParam
enum EAiActionParamType
{
	AP_NOTHING,
	AP_UNIT,
	AP_CMAPCELL,
	AP_COMBATARMY,
	AP_AMAPCELL,
	AP_ADVENTUREARMY,
	AP_VISSITE,
	AP_PLAYER,
	AP_BUILDING,
	AP_ABILITY,
	AP_TELEPORTER,
	AP_RESOURCE,
	AP_RECRUIT_HERO_DATA,
	AP_BASECREATURESTACK,
};

enum EAiActionParamId
{
	APID_1,
	APID_2,
	APID_3,
	__APID_NUM
};

//from H7AiSensorParam
enum EAiSensorParamType
{
	SP_NOTHING,
	SP_UNIT,
	SP_CMAPCELL,
	SP_COMBATARMY,
    SP_AMAPCELL,
    SP_ADVENTUREARMY,
	SP_VISSITE,
	SP_PLAYER,
	SP_BUILDING,
	SP_TOWN,
	SP_HEROABILITY,
	SP_CREATUREABILITY,
	SP_TELEPORTER,
	SP_RESOURCE,
	SP_BASECREATURESTACK,
	SP_CREATURESTAT,
	SP_CREATURETIER,
};

//from H7AiSensorInputConst
enum EAiSensorIConst
{
	SIC_DISABLED,
	SIC_GRIDCELLS,
	SIC_THIS_CREATURESTACK,
	SIC_CREATURESTACKS,
	SIC_OPPONENT_CREATURESTACKS,
	SIC_THIS_HERO,
	SIC_OPPONENT_HERO,
	SIC_THIS_ARMY,
	SIC_OPPONENT_ARMY,
	SIC_SOURCE_GRIDCELL,
	SIC_TARGET_GRIDCELL,
	SIC_TARGET_CREATURESTACK,
	SIC_OPPONENT_ARMIES,
	SIC_TOWN_ARMIES,
	SIC_THIS_AOCSITE,
	SIC_VISSITES,
	SIC_TARGET_ARMY,
	SIC_TARGET_VISSITE,
	SIC_THIS_PLAYER,
	SIC_OTHER_PLAYERS,
	SIC_THIS_BUILDINGS,
	SIC_TOWNS,
	SIC_HEROABILITIES,
	SIC_CREATUREABILITY,
	SIC_TELEPORTERS,
	SIC_TARGET_TELEPORTER,
	SIC_RESOURCES,
	SIC_TARGET_RESOURCE,
	SIC_TARGET_BASECREATURESTACK,
	SIC_MAKESHIFT_ARMY,
	SIC_HEROABILITY,
	SIC_CREATURE_STAT,
	SIC_CREATURE_TIER,
};

//from H7AiUtilityBase
enum EUtilityFunction
{
	UF_BOOLEAN          <DisplayName=Boolean>,
	UF_INV_BOOLEAN      <DisplayName=Inverse Boolean>,
	UF_LINEAR           <DisplayName=Linear>,
	UF_INV_LINEAR       <DisplayName=Inverse Linear>,
	UF_SINUS            <DisplayName=Sinus>,
	UF_INV_SINUS        <DisplayName=Inverse Sinus>,
	UF_SQUARE           <DisplayName=Square>,
	UF_INV_SQUARE       <DisplayName=Inverse Square>,
	UF_CUBIC            <DisplayName=Cubic>,
	UF_INV_CUBIC        <DisplayName=Inverse Cubic>,
	UF_CUSTOM           <DisplayName=Custom>,
	UF_BIAS             <DisplayName=Bias>,
};

//====== ENUMS ======

enum ECreatureCategory
{
	CREATUREC_FIGHTER,
	CREATUREC_ROGUE,
	CREATUREC_SHOOTER,
	CREATUREC_MAGE
};

enum ETargetStat
{
	TS_STAT_NONE,
	TS_STAT_HITPOINTS,
	TS_STAT_INITIATIVE,
	TS_STAT_ATTACK,
	TS_STAT_DEFENSE,
	TS_STAT_LEADERSHIP,
	TS_STAT_DESTINY,
	TS_STAT_DAMAGE,
	TS_STAT_MOVEMENT
};

//====== AI end ======



enum EZoomDirection
{
	ZD_ZOOM_IN,
	ZD_ZOOM_OUT,
	ZD_NONE,
};

//from H7GameProcessor
enum EADType
{
	Hero_vs_Creature,
	Hero_vs_Obstacle,
	Creature_vs_Creature,
	Creature_vs_Warunit,
	Warunit_vs_Creature,
	Warunit_vs_Obstacle,
	Tower_vs_Creature
};

//from H7FCTController // if you enter a new entry you have to do several things to set it up:
// 1
// 2
// 3
enum EFCTType
{
	FCT_DAMAGE<DisplayName="Damage">,
	FCT_KILL<DisplayName="Kill">,
	FCT_RETALIATION<DisplayName="Retaliation">,
	FCT_TEXT<DisplayName="Text">,
	FCT_HEAL<DisplayName="Heal">,
	FCT_RESURRECTION<DisplayName="Resurrection">,
	FCT_RESOURCE_PICKUP<DisplayName="Resource Pickup">,
	FCT_XP<DisplayName="XP">,
	FCT_ERROR<DisplayName="Error">, // defaultcolor = red
	FCT_IMMUNE<DisplayName="Immune">, // unused
	FCT_BUFF<DisplayName="Buff">, // message hack to delete buffs of creatures that die immidiatly after
	FCT_HIGHLIGHT<DisplayName="Highlight">, // Alt-key diablo object highlighting
	FCT_ITEM_PICKUP<DisplayName="Item Pickup">,
	FCT_STAT_MOD<DisplayName="Stat Modification">,
};

//from H7HeroWindowCntl
enum ERotationDirection
{
	ERDI_CLOCKWISE,
	ERDI_COUNTERCLOCKWISE,
	ERDI_NO_ROTATION,
};

//from H7IPickable
enum ELootType
{
	LOOT_TYPE_GOLD,
	LOOT_TYPE_EXP,
};

//from H7ITooltipable
enum EActorTooltipType
{
	TT_TYPE_STRING,
	TT_TYPE_RESOURCE_PILE,
	TT_TYPE_CRITTER_ARMY,
	TT_TYPE_BUILDING_BUFFABLE,
	TT_TYPE_HERO_ARMY,
	TT_TYPE_TOWN,
	TT_TYPE_BATTLESITE,
	TT_TYPE_DWELLING,
	TT_TYPE_ITEM
};

//from H7CreatureStack
enum ORIENTATION
{
	O_NORTH,
	O_EAST,
	O_SOUTH,
	O_WEST,
};

enum ELuckType
{
	GOOD_LUCK,
	BAD_LUCK,
	NOTHING_LUCK,
};

enum EMoraleType
{
	GOOD_MORALE,
	BAD_MORALE,
	NORMAL_MORALE,
};

//from H7HeroAnimControl
enum EHeroAnimation
{
	HA_IDLE,
	HA_MOVE,
	HA_ATTACK,
	HA_ABILITY,
	HA_TURNLEFT,
	HA_TURNRIGHT,
	HA_VICTORY,
	HA_NONE
};

//from H7WarUnitAnimControl
enum EWarUnitAnimation
{
	WA_IDLE,
	WA_ATTACK_CENTER,
	WA_ATTACK_LEFT,
	WA_ATTACK_LEFT_WIDE,
	WA_ATTACK_RIGHT,
	WA_ATTACK_RIGHT_WIDE,
	WA_HIT,
	WA_ABILITY,
	WA_DYING,
};

enum EUnitAnimation
{
	UAN_MELEE_ATTACK,
	UAN_RANGED_ATTACK,
	UAN_ABILITY,
	UAN_ABILITY2,
	UAN_DEFEND,
	UAN_VICTORY,
	UAN_NONE
};

//from H7Faction


//from H7PlayerController
enum EGameMode
{
	SINGLEPLAYER,
	MULTIPLAYER,
	HOTSEAT
};

enum ECursorType // DO NOT CHANGE ORDER, IT'S MATCHED TO HARDWARE CURSOR FILES
{
	CURSOR_ABILITY,
	CURSOR_ABILITY_DENY,
	CURSOR_ACTION,
	CURSOR_ACTION_BLOCKED,
	CURSOR_BUSY,
	CURSOR_DETAILS,
	CURSOR_EXCHANGE,
	CURSOR_EXCHANGE_BLOCKED,
	CURSOR_IBEAM,
	CURSOR_MAGIC,
	CURSOR_MAGIC_DENY, // 11
// DO NOT CHANGE ORDER, IT'S MATCHED TO HARDWARE CURSOR FILES
	CURSOR_MEETING,
	CURSOR_MELEE_N,
	CURSOR_MELEE_NW,
	CURSOR_MELEE_NE,
	CURSOR_MELEE_S,
	CURSOR_MELEE_SW,
	CURSOR_MELEE_SE,
	CURSOR_MELEE_W,
	CURSOR_MELEE_E,
	CURSOR_MOVE, // 21
	CURSOR_MOVE_BLOCKED,
	CURSOR_MOVE_FLY,
	CURSOR_MOVE_TELEPORT,
	CURSOR_MOVE_WALK,
// DO NOT CHANGE ORDER, IT'S MATCHED TO HARDWARE CURSOR FILES
	CURSOR_NORMAL,
	CURSOR_POINTER,
	CURSOR_SHIP_ANCHOR,
	CURSOR_SHIP_ANCHOR_BLOCKED,
	CURSOR_SHIP_MOVE,
	CURSOR_SHIP_MOVE_BLOCKED, // 31
	CURSOR_SHOT,
	CURSOR_SHOT_UNSIGHTED,
	CURSOR_TALK,
	CURSOR_TELEPORT,
	CURSOR_TELEPORT_BLOCKED, // 36
	CURSOR_TOWN,
	CURSOR_TRADE,
	CURSOR_UNAVAILABLE,
	CURSOR_VISIT, // 40
	CURSOR_EMPTY, 
	CURSOR_MOVE_GHOSTWALK,
	CURSOR_INVISIBLE, // 43 used to 'disable' hardware cursor
	CURSOR_ANIMATION_TEST // 44
}; // DO NOT CHANGE ORDER, IT'S MATCHED TO HARDWARE CURSOR FILES



enum ETownPopup
{
	POPUP_NONE,
	POPUP_BUILD,
	POPUP_RECRUIT,
	POPUP_WARFARE,
	POPUP_HALLOFHEROS,
	POPUP_MARKETPLACE,
	POPUP_MAGICGUILD,
	POPUP_THIEVES,
	POPUP_CARAVAN,
	POPUP_TOWNGUARD,
	POPUP_CUSTOM1,
	POPUP_CUSTOM2
};

enum EArmyNumber
{
	ARMY_NO,
	ARMY_NUMBER_VISIT,
	ARMY_NUMBER_GARRISON,
	ARMY_NUMBER_GOVERNORTOWNGUARD,
	ARMY_NUMBER_CARAVAN
};

//from H7StackPlateSystem
enum EStackPlateOrientation
{
	PLATE_ORIENTATION_LEFT,
	PLATE_ORIENTATION_RIGHT
};

enum EWaypointCommand
{
	WPC_MOVE_NEXT,
	WPC_WAIT
};

enum EPathControlType
{
	PCT_CONSTANT,
	PCT_MIRROR,
	PCT_REPEAT
};

//====== STRUCTS ======

//from H7ITooltipable
struct H7TooltipData
{
	var() EActorTooltipType type;
	var() GFxObject objData;
	var() String Title;
	var() String Description;
	var() String Visited;
	var() String strData;
	var() bool addRightMouseIcon;
};

struct TradingTableEntry
{
	var(Entry) H7Resource Resource;
	var(Entry) int BuyValue;
	var(Entry) int SellValue;

	structdefaultproperties
	{
		BuyValue = 50;
		SellValue = 25;
	}
};

//from H7AiActionBase
struct AiActionScore
{
	var float                   score;
	var H7AiActionBase          action;
	var H7AiActionParam         params;
	var string                  dbgString;
	var float                   tension;
};

//AI
struct AiTargetValue
{
	var string          targetClass;
	var float           utilityOwnFaction;
	var float           utilityOtherFaction;
};

struct AiWaypoint
{
	var(WP) H7AdventureCellMarker   cell;
	var(WP) EWaypointCommand        cmd;
	var(WP) int                     cmdTurns;
};

struct H7NumberAndIcon
{
	var int number;
	var String iconPath;
};

struct H7StackCount
{
	var int count;
	var H7Creature type;
};

struct H7AlliedTradeData
{
	var int                         receivingHeroID;
	var String                      receivingHeroName;
	var int                         givingHeroID;
	var String                      givingHeroName;
	var Array<H7HeroItem>           receivedItems;
	var Array<H7StackCount>  receivedCreatures;
};

//from H7CombatPlayerController
//  Mulitplayer struct to synchronize the unit positions
struct MPUnitsPos
{
	var int UnitId;
	var IntPoint UnitPos;
};

//from H7CombatMapStatusBarController
enum BarType
{
	BARTYPE_HEALTH,
	BARTYPE_MANA,
	BARTYPE_PROGRESS
};

struct Bar
{
	var H7Unit unit; 
	var BarType type;
	var int flashID;
	var int oldX;
	var int oldY;
	var int oldPercent;
	var bool oldVisible;
};

//from H7CreatureStackPlateController
struct Plate
{
	var H7CreatureStack stack; 
	var int flashID;
	var EStackPlateOrientation orientation;
	var int oldX;
	var int oldY;
	var int oldSize;
	var bool oldVisible;
	var bool oldIsActive;
};

//from H7FCTMappingProperties
struct FCTMappingEntry
{
	var(FCTProperties)  EFCTType        mType<DisplayName=Type>;
	var(FCTProperties)  Texture2D       mIcon<DisplayName=Icon>;
};



//from H7GFxActorTooltip AND H7AdventureMapGridDebug
struct BoundingPoint
{
	var() Vector2D      pixel;
	var() bool          hit;
};



//from H7MultiplayerCommandManager
struct MPCommand
{
	var int UnitActionsCounter;
	var EUnitCommand CommandType;
	var ECommandTag CommandTag;
	var H7ICaster CommandSource;
	var H7IEffectTargetable Target;
	var array<H7BaseCell> Path;
	var H7BaseAbility Ability;
	var EDirection Direction;
	var bool ReplaceFakeAttacker;
	var bool InsertHead;
	var int UnitTurnCounter;
	var int TeleportTarget;
	var int CurrentPlayer;
	var H7CombatMapCell TrueHitCell;
	var bool doOOSCheck;
	var int movementPoints;
	var float CreationTime;
};

struct SynchUpData
{
	var int UnitActionsCounter;
	var int RNGCounter;
	var int IDCounter;
};

enum EInstantCommandType
{
	ICT_CHEAT_BUILD_ALL,
	ICT_CHEAT_TELEPORT,
	ICT_END_TURN,
	ICT_BEGIN_TURN,
	ICT_HERO_ADD_XP,
	ICT_INCREASE_RESOURCE,
	ICT_TRADE_RESOURCE,
	ICT_TELEPORT_TO_TOWN,
	ICT_DO_COMBAT,
	ICT_INVENTORY_ACTION,
	ICT_DISMISS_CREATURESTACK,
	ICT_SPLIT_CREATURESTACK,
	ICT_BUILD_BUILDING,
	ICT_TRANSFER_HERO,
	ICT_RECRUIT,
	ICT_RECRUIT_DIRECT, // when recriuting without an AOC lord
	ICT_UPGRADE_UNIT,
	ICT_UPGRADE_DWELLING,
	ICT_RECRUIT_HERO,
	ICT_DESTRUCTION_OR_REPARATION,
	ICT_SET_GOVERNOR,
	ICT_START_CARAVAN,
	ICT_REBUILD_FORT,
	ICT_DESTROY_TOWN_BUILDINGS,
	ICT_FLEE_OR_SURRENDER,
	ICT_CHEAT_STAT_CHANGE,
	ICT_CHEAT_WIN_LOSE,
	ICT_INCREASE_SKILL,
	ICT_LEARN_ABILITY_FROM_SKILL,
	ICT_OVERWRITE_SKILL,
	ICT_JOIN_ARMY,
	ICT_RECRUIT_WARFARE,
	ICT_PLUNDER,
	ICT_LET_GO,
	ICT_TRANSFER_STACK_FROM_MERGE_POOL,
	ICT_SELECT_SPECIALISATION,
	ICT_ENTER_LEAVE_SHELTER,
	ICT_SET_AUTO_COMBAT,
	ICT_SAVE_GAME,
	ICT_RECYCLE_ARTIFACT,
	ICT_DOUBLE_ARMY,
	ICT_DISMISS_HERO,
	ICT_INCREASE_HERO_STAT,
	ICT_BUY_SCROLL,
	ICT_ACCEPT_MERGE,
	ICT_TRANSFER_WAR_UNIT,
	ICT_SABOTAGE,
	ICT_THIEVES_GUILD_PLUNDER,
	ICT_BUY_ARTIFACT_MERCHANT,
	ICT_BUY_ARTIFACT_BLACK_MARKET,
	ICT_SELL_ARTIFACT,
	ICT_SACRIFICE,
	ICT_RESET_REINFORCEMENT,
	ICT_CONFIRM_REINFORCEMENT,
	ICT_BUILD_SHIP,
	ICT_USE_FERTILITY_IDOL,
	ICT_RANDOM_ITEM_SITE,
	ICT_MERGE_ARMIES_AI,
	ICT_UNIFY_ARMY,
    ICT_MERGE_ARMIES_LORD,
    ICT_MERGE_ARMIES_ADVENTURE
};

struct MPInstantCommand
{
	var EInstantCommandType Type;
	var int UnitActionsCounter;
	var int CurrentPlayer;
	var int IntParameters[INSTANT_COMMAND_MAX_INT_PARAMS];
	var string StringParameter;
	var bool ignoreOOSCheck;
};

struct MPSimTurnOngoingTrade
{
	var H7AdventureHero Source;
	var H7AdventureHero Target;
};

enum ESimTurnStartCombatAnswer
{
	STSCA_NOT_SET,
	STSCA_RETREAT,
	STSCA_CANCEL,
	STSCA_QUICK_COMBAT,
	STSCA_NORMAL_COMBAT,
};

struct MPSimTurnOngoingStartCombat
{
	var H7AdventureHero				Source;
	var ESimTurnStartCombatAnswer	SourceAnswer;
	var H7AdventureHero				Target;
	var ESimTurnStartCombatAnswer	TargetAnswer;
	var float						StartTimer;
};

enum ESimTurnCommandCancelledReason
{
	STCCR_PATH_CHANGED,
	STCCR_ALREADY_LOOTED,
	STCCR_ARMY_IN_DIFFERENT_CELL,
};

struct MPOutOfSynchData
{
	var int UnitActionsCounter;
	var int SynchRNG;
	var int IdCounter;
	var int UnitsCount;
	var int ResCount;
	var bool IsCombat;
};

struct MPDamageApply
{
	var int CreatureStackId;
	var int StackSize;
	var int TopCreatureHealth;
	var float ExpirationTime;
};

enum ESimTurnCommandState
{
	STCS_DEFAULT,
	STCS_WAITING_RESPONSE_CANCEL_TRADE,
};


//from H7Deployment
struct H7StackDeployment
{
	var savegame CreatureStackProperties StackInfo;  // volatile creature stack info
	var savegame H7CreatureStack CreatureStackRef;   // Ref to creature stack for accurate finding in lists
	var savegame int SourceSlotId;                   // [0..6,7,8] 7 army stacks + 2 additional temp. battle stacks [9..13] 5 guard army stacks
	var savegame int DistanceSide;                   // distance from the grid side border depending of alignment (left or right) [grid coord]
	var savegame int DistanceTop;                    // distance from the grid top border [grid coord]
	var savegame int Ordinal;                        // scanline ordering depending of alignment (left or right), -1 == not deployed (on grid)
	var savegame int SpacingTop;
	var savegame int SpacingBottom;

	structdefaultproperties
	{
		SourceSlotId=0;
		DistanceSide=0;
		DistanceTop=0;
		Ordinal=-1;
		SpacingTop=0;
		SpacingBottom=0;
	}
};

struct H7DeploymentData
{
	var savegame bool ForceAutodeployment;
	var savegame int OriginalMapHeight;
	var savegame int NumberOfDeployedStacks;
	var savegame int NumberOfStacksToDeploy;
	var savegame array<H7StackDeployment> StackDeployments;

	structdefaultproperties
	{ 
		ForceAutodeployment = true;
		OriginalMapHeight = DEFAULT_MAP_HEIGHT;
		NumberOfDeployedStacks = 0;
		NumberOfStacksToDeploy = 0;
	}
};

struct H7LocalGuardData
{
	var() int mCapacityCoreFoot;
	var() int mCapacityCoreRange;
	var() int mCapacityEliteFoot;
	var() int mCapacityEliteRange;
	var() int mCapacityChampion;
	var() int mProductionCore;
	var() int mProductionElite;
	var() int mProductionChampion;
};

enum H7ListenFocus
{
	LF_EVERYTHING,
	LF_HERO_SLOT,
	LF_HERO_WINDOW,
};

enum EQuestStatus
{
	QS_PENDING,
	QS_ACTIVE,
	QS_INACTIVE,
	QS_COMPLETED,
	QS_FAILED,
};

enum EOption // TODO all
{
	OPT_PATH_HOVER_DECAL,

};




struct H7CombatResultSignature
{
	var() H7EffectContainer ability;
	var() array<H7IEffectTargetable> targets;
	var() EDirection cursorDirection;
	var() int cursorAngle;
	var() bool extendedVersion;
};

// what's the purpose of this message, what does it do while active/when clicked, so code can search for and react to it
enum EMessageAction
{
	MA_NONE,
	MA_BLOCK_UNIT_ACTION,
	MA_BLOCK_ENDTURN, // deprecated and not processed
	MA_BLOCK_GAMEPLAY, // TODO
	MA_BLOCK_GAMEPLAY_AND_HIDE_GUI,  // TODO
};



struct H7PopupParameters
{
	var Object param1;
	var Object param2;
	var Object param3;
	var Object param4;
	var bool paramBool1;
	var bool paramBool2;

};

struct H7MessageSettings
{
	var() Texture2D icon<DisplayName=Icon>;
	
	var() bool deleteWhenClicked<DisplayName=Is deleted on left click>;
	var() bool allowDestroy<DisplayName=Can be right clicked and deleted>;
	
	var() EMessageAction action<DisplayName=Effect when triggered>;
	var() int actionDuration<DisplayName=Effect duration>;
	
	var Object referenceObject; // i.e. Actor
	var Object referenceWindowCntl; // i.e. HeroWindow
	var H7PopupParameters popupParams;
	var H7MessageCallbacks callbacks;

	// only for floating texts
	var() EFCTType floatingType;
	var() Color color;
	var() bool preventHTML;
	var Vector floatingLocation;
	
	// deprecated / never implemented / debug
	//var H7Player initiator;
	var bool hideGui;// TODO
	//var() bool deleteWhenActionDone;// TODO
	var int priority;// TODO
	var float fadeOutAfterXSeconds;
	
	structdefaultproperties
	{
		allowDestroy = true;
	}
};

enum EHUDMode
{
	HM_NORMAL,
	HM_CINEMATIC_SUBTITLE,
	HM_WAITING_FOR_OTHERS_TURN,
	HM_WAITING_FOR_OTHERS_CONNECT,
	HM_WAITING_FOR_AI, // and/or caravans?
	HM_WAITING_OTHER_PLAYER_ANSWER,
	HM_WAITING_OTHER_PLAYER_RETREAT,
	HM_COUNCIL,
	HM_IN_BETWEEN_TURNS_FOR_HOTSEAT,
	HM_MAPVIEW
//	HM_SPECTATOR // NEEDED?
};

enum EH7SeqCondUpdateTurnPeriod
{
	EH7SeqCondUpdateTurnPeriod_Week,
	EH7SeqCondUpdateTurnPeriod_Day,
};


//from H7AdventureMapGridController
enum ECurrentArmyAction
{
	CAA_NOTHING,
	CAA_MOVE,
	CAA_ATTACK_ARMY,
	CAA_SELECT_ARMY,
	CAA_MEET_ARMY,
	CAA_TELEPORT,

	CAA_VISIT,
	CAA_PICK_UP,
	CAA_SPELL_OK,
	CAA_SPELL_NO,
	CAA_ZOOM_TO,

	CAA_BOARD,
	CAA_UNBOARD,
	CAA_TALK,
	CAA_JOIN_OFFER,
	CAA_JOIN_FORCE,
	CAA_BRIBE,
	CAA_FLEE,

	CAA_ENTER_TOWN,

	CAA_DESHELTER,
	CAA_ABORT_ACTION
};

enum ECombatPlayerType
{
	COMBATPT_ATTACKER,
	COMBATPT_DEFENDER,
	COMBATPT_SPECTATOR
};

enum EInventoryAction
{
	IA_SET_ITEM_POS,
	IA_ADD_ITEM,
	IA_MERGE_ITEMS,
	IA_REMOVE_ITEM,
	IA_EQUIP_ITEM,
	IA_UNEQUIP_ITEM
};

enum EOOSType
{
	OOS_RNG_COUNTER,
	OOS_ID_COUNTER,
	OOS_UNIT_COUNT
};

enum EMessageCreationContext
{
	MCC_UNKNOWN,
	MCC_ADV_MAP,
	MCC_CBT_MAP,
	MCC_MAIN_MENU
};
