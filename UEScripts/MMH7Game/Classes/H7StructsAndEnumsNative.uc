//=============================================================================
// H7StructsAndEnumsNative
//=============================================================================
// Contains all non-native enums depicted in the 
// refactoring Wish List on Confluence.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7StructsAndEnumsNative extends Object
	abstract
	native(Structs);

//====== ENUMS ======
enum EOnlineSettingsProperties
{
	OSP_NUM_PUBLIC_CONNECTIONS,
	OSP_SERVERNAME,
	OSP_MAPINFONUMBER,
	OSP_MAPFILENAME,
	OSP_TURNTYPE,
	OSP_SKILLTYPE,
	OSP_NUMCLOSEDSLOTS,
	OSP_NUMAISLOTS,
	OSP_GAMETYPE,
	OSP_ISGAMESTARTED,
	OSP_SESSION_ID,
	OSP_ISSAVEDGAME,
	OSP_VICTORYCONDITION,
	OSP_USERANDOMPOSITION,
	OSP_GAMESPEEDADVENTURE,
	OSP_GAMESPEEDADVENTUREAI,
	OSP_GAMESPEEDCOMBAT,
	OSP_TIMERCOMBAT,
	OSP_TIMERADV,
	OSP_FORCEQUICKCOMBAT,
	OSP_TEAMSCANTRADE,
	OSP_DIFFICULTY,
	OSP_TEAMSETUP,
	OSP_NAT_TYPE
};

enum EScriptedBehaviour
{
	ESB_None<DisplayName="Not scripted">,
	ESB_Scripted<DisplayName="Scripted">,
	ESB_ScriptedUseResources<DisplayName="Scripted and using ressources">,
};


enum ECompareOp
{
	ECO_EQUAL<DisplayName="exactly">,
	ECO_LESS_EQUAL<DisplayName="exactly or less than">,
	ECO_GREATER_EQUAL<DisplayName="exactly or more than">,
	ECO_LESS<DisplayName="less than">,
	ECO_GREATER<DisplayName="more than">,
};

enum EModQuantityOper
{
	EMQO_ADD        <DisplayName="Add">,
	EMQO_SUB        <DisplayName="Subtract">,
	EMQO_SET        <DisplayName="Set to">,
};

enum EPlayerNumber
{
	PN_NEUTRAL_PLAYER   <DisplayName=Neutral Player>,
	PN_PLAYER_1         <DisplayName=Player 1>,
	PN_PLAYER_2         <DisplayName=Player 2>,
	PN_PLAYER_3         <DisplayName=Player 3>,
	PN_PLAYER_4         <DisplayName=Player 4>,
	PN_PLAYER_5         <DisplayName=Player 5>,
	PN_PLAYER_6         <DisplayName=Player 6>,
	PN_PLAYER_7         <DisplayName=Player 7>,
	PN_PLAYER_8         <DisplayName=Player 8>,
	PN_PLAYER_NONE      <DisplayName=Player Not Set>,
};

enum EPlayerNumberWithoutNeutral
{
	PNWE_PLAYER_1         <DisplayName=Player 1>,
	PNWE_PLAYER_2         <DisplayName=Player 2>,
	PNWE_PLAYER_3         <DisplayName=Player 3>,
	PNWE_PLAYER_4         <DisplayName=Player 4>,
	PNWE_PLAYER_5         <DisplayName=Player 5>,
	PNWE_PLAYER_6         <DisplayName=Player 6>,
	PNWE_PLAYER_7         <DisplayName=Player 7>,
	PNWE_PLAYER_8         <DisplayName=Player 8>,
};

enum EPlayerTargetType
{
	PLAYER_TYPE_ALL         <DisplayName=All Players>,
	PLAYER_TYPE_ONE         <DisplayName=Target Player>,
	PLAYER_TYPE_ALL_ENEMIES <DisplayName=All Enemy Players>,
	PLAYER_TYPE_ALL_ALLIES  <DisplayName=All Allied Players>,
};

enum ESkillRank
{
	SR_ALL_RANKS        <DisplayName=Always/All Ranks>, // default
	SR_UNSKILLED        <DisplayName=Unskilled>,
	SR_NOVICE           <DisplayName=Novice>, 
	SR_EXPERT           <DisplayName=Expert>,
	SR_MASTER           <DisplayName=Master>
};

//from H7Creature
enum ECreatureEventType
{
	CE_ATTACK_HIT_TIME,
	CE_CRITICAL_ATTACK_HIT_TIME,
	CE_RANGE_ATTACK_SHOOT_TIME,
	CE_ABILITY_CAST_TIME,
	CE_ABILITY_CAST_TIME2
};

//from H7Creature
enum EWarfareUnitEventType
{
	WU_RANGE_ATTACK_TIME, 
	WU_ABILITY_CAST_TIME, 
};

//from H7Creature
enum EHeroEventType
{
	HE_ATTACK_HIT_TIME      <DisplayName=Attack Hit Time>,
	HE_ABILITY_CAST_TIME    <DisplayName=Cast Time>
};

enum EH7FlyPointInterp
{
	FPI_Linear          <DisplayName=Linear>,
	FPI_Squared         <DisplayName=Squared>,
	FPI_InvSquared      <DisplayName=Inverse Squared>,
	FPI_Cubed           <DisplayName=Cubed>,
};

//from H7EditorAdventureTile
enum ECellMovementType
{
	MOVTYPE_IMPASSABLE	    <DisplayName="Impassable">,
	MOVTYPE_GROUND	        <DisplayName="Ground">,
	MOVTYPE_WATER	        <DisplayName="Water">,
};

enum EMapType
{
	SKIRMISH        <DisplayName="Skirmish">,
	SCENARIO        <DisplayName="Scenario">,
	CAMPAIGN        <DisplayName="Campaign">,
};

enum EUplayTrackingType
{
	UTT_GAMEMODE_START,
	UTT_GAMEMODE_STOP,
	UTT_CAMPAIGN_START,
	UTT_CAMPAIGN_STOP,
	UTT_CAMPAIGN_COMPLETE,
	UTT_MAP_START,
	UTT_MAP_STOP,
	UTT_ACHIEVEMENT,
	UTT_CUT_SCENES,
	UTT_PLAYER_DLC,
	UTT_CASTLE_BUILD,
	UTT_ABILITY_LEARNT,
	UTT_SPELL_USED,
	UTT_COMBAT_RECAP,
	UTT_HERO_RECRUITED,
	UTT_TREASUREHUNT,
	UTT_GAME_LOCALIZATION,
	UTT_PLAYER_PROGRESSION
};

enum ESaveType // do not change (used in flash)
{
	SAVETYPE_NONE,
	SAVETYPE_MANUAL,
	SAVETYPE_QUICK,
	SAVETYPE_AUTO
};

enum EDifficulty
{
	DIFFICULTY_EASY<DisplayName=Easy>,
	DIFFICULTY_NORMAL<DisplayName=Normal>,
	DIFFICULTY_HARD<DisplayName=Hard>,
	DIFFICULTY_HEROIC<DisplayName=Heroic>,
	DIFFICULTY_CUSTOM<DisplayName=Custom>
};

enum EDifficultyStartResources
{
	DSR_ABUNDANCE,
	DSR_AVERAGE,
	DSR_LIMITED,
	DSR_SHORTAGE
};

enum EDifficultyCritterStartSize
{
	DCSS_FEW,
	DCSS_AVERAGE,
	DCSS_MANY,
	DCSS_HORDES
};

enum EDifficultyCritterGrowthRate
{
	DCGR_SLOW,
	DCGR_AVERAGE,
	DCGR_FAST,
	DCGR_PROLIFIC
};

enum EDifficultyAIEcoStrength
{
	DAIES_POOR,
	DAIES_AVERAGE,
	DAIES_PROSPEROUS,
	DAIES_RICH
};

enum EDifficultyAIAggressiveness
{
	DAIA_SHEEP,
	DAIA_BALANCED,
	DAIA_HOSTILE,
	DAIA_NEFARIOUS
};

//from H7AdventureObject
enum EPassabilityType
{
	BLOCKING,
	PASSABLE
};

enum EFoWOverrideState
{
	FO_NORMAL          <DisplayName="Normal">,
	FO_HIDDEN          <DisplayName="Hidden">,
	FO_SHOWN           <DisplayName="Shown">
};

//from H7CombatObstacleObject
enum EObstacleType
{
	OT_DEFAULT      <DisplayName=Default>,
	OT_WALL         <DisplayName=Wall Segment>,
	OT_GATE	        <DisplayName=Gate Segment>,
	OT_MOAT         <DisplayName=Moat Segment>,
	OT_TOWER        <DisplayName=Tower Segment>,
	OT_TRAP         <DisplayName=Trap>,
};

enum EObstacleLevel
{
	OL_UNTOUCHED,       // health==full
	OL_DEMOLISHED,      // 0 < health < full
	OL_DESTROYED        // health==0
};

//from H7EditorMapObject
enum ESnapVerticalType
{
	SV_NO_SNAP          <DisplayName=No Snapping>,
	SV_GROUND           <DisplayName=Snap to Ground>,
	SV_FLATTEN_TERRAIN  <DisplayName=Flatten terrain>,
};

enum ESnapType
{
	NO_SNAP             <DisplayName=No Snapping>,
	CENTER              <DisplayName=Snap to tile center>,
	BORDER              <DisplayName=Snap to tile border>,
};

//from H7CombatMapCell
enum ESelectionType
{
	NORMAL,
	SELECTED,
	SELECTED_ALLY,
	SELECTED_DEAD_ALLY,
	SELECTED_ENEMY,
	OBSTACLE,
	FORESHADOW,
	FORESHADOW_ALT, // alternative (to show the cells that a target unit can move on)
	FORESHADOW_BOTH,
	CREATURE_TACTICS,
	MOUSE_OVER,
	SIEGEWALL_COVER,
	FORESHADOW_ABILITY,
};

enum EMaterialParam
{
	EMP_Emissive                <DisplayName=Emissive Color>,
	EMP_Opacity                 <DisplayName=Opacity>,
	EMP_Diffuse                 <DisplayName=Diffuse Color>,
	EMP_Spec					<DisplayName=Specular Intensity>,
	EMP_SpecPow					<DisplayName=Specular Power>,
};

//from H7EffectContainer
enum ELogType
{
	LOG_TYPE_STAT,
	LOG_TYPE_ITEM,
	LOG_TYPE_SKILL,
	LOG_TYPE_BUFF,
};

//from H7CombatMapCursor
enum EDirection
{
	WEST<DisplayName="West">,
	NORTH_WEST<DisplayName="North West">,
	NORTH<DisplayName="North">,
	NORTH_EAST<DisplayName="North East">,
	EAST<DisplayName="East">,
	SOUTH_EAST<DisplayName="South East">,
	SOUTH<DisplayName="South">,
	SOUTH_WEST<DisplayName="South West">,
};

enum EFlankingType
{
	NO_FLANKING     <DisplayName=No Flanking>,
	FLANKING        <DisplayName=Flanking>,
	FULL_FLANKING   <DisplayName=Full Flanking>,
};

enum EResourceRank
{
	RRANK_COMMON    <DisplayName=Common>,
	RRANK_RARE      <DisplayName=Rare>,
};

enum EQuestOrObjectiveStatus
{
	QOS_ONGOING<DisplayName="Pending">,
	QOS_COMPLETED<DisplayName="Completed">,
	QOS_FAILED<DisplayName="Failed">,
	QOS_ACTIVATED<DisplayName="Activated">,
};

enum EHeroAiControlType
{
	HCT_STANDARD,
	HCT_SCRIPT_OVERRIDE,
	HCT_EXPLORER,
	HCT_GATHERER,
	HCT_HOMEGUARD,
	HCT_GENERAL
};

enum EAIDifficulty
{
	AI_DIFFICULTY_EASY,
	AI_DIFFICULTY_NORMAL,
	AI_DIFFICULTY_HARD,
	AI_DIFFICULTY_HEROIC
};

enum EHeroAiAggressiveness
{
	HAG_SHEEP,
	HAG_CONTAINED,
	HAG_BALANCED,
	HAG_HOSTILE,
	HAG_NEFARIOUS
};

enum EHeroAiRole
{
	HRL_GENERAL,
	HRL_MAIN,
	HRL_SECONDARY,
	HRL_SCOUT,
	HRL_SUPPORT,
	HRL_MULE
};

enum EShipInteraction
{
	SI_BOARD<DisplayName=Board>,
	SI_DISEMBARK<DisplayName=Disembark>,
};

enum EBuffsMod
{
	EBM_ADD<DisplayName="Add">,
	EBM_REMOVE<DisplayName="Remove">,
	EBM_REMOVE_ALL<DisplayName="Remove all">,
};

enum EHideReveal
{
	EHR_HIDE<DisplayName=Hide>,
	EHR_REVEAL<DisplayName=Reveal>,
};

enum ESpyInfoState
{
	ESIS_locked,
	ESIS_spying,
	ESIS_new,
	ESIS_unlocked,
	ESIS_dead,
	ESIS_Plundering,
	ESIS_Sabotaging
};

enum EVictoryCondition
{
	E_H7_VC_DEFAULT<DisplayName="Map Default">,
	E_H7_VC_STANDARD<DisplayName="Defeat all">,
	E_H7_VC_ASHA<DisplayName="Build the Tear of Asha Structure">,
	E_H7_VC_FORTS<DisplayName="Control all Forts">,
};

enum ERandomSiteFaction
{
	E_H7_RSF_PLAYER<DisplayName="Player Faction">,
	E_H7_RSF_RANDOM<DisplayName="Random Faction">,
	E_H7_RSF_AS_ANOTHER_TOWN<DisplayName="Same as another Town/Fort">,
	E_H7_RSF_DIFFERENT_FROM_ANOTHER_TOWN<DisplayName="Different from another Town/Fort">,
};

enum EH7RandomDwellingType
{
	E_H7_RDT_CORE<DisplayName="Core">,
	E_H7_RDT_ELITE<DisplayName="Elite">,
	E_H7_RDT_CHAMPION<DisplayName="Champion">,
	E_H7_RDT_ANY<DisplayName="Random">,
};

enum EH7RandomDwellingLevel
{
	E_H7_RDL_BASIC<DisplayName="Basic">,
	E_H7_RDL_UPGRADE<DisplayName="Upgrade">,
	E_H7_RDL_ANY<DisplayName="Random">,
};

enum EH7ChampionDwellingChoice
{
	E_H7_CDC_NONE<DisplayName="None">,
	E_H7_CDC_1<DisplayName="Elite">,
	E_H7_CDC_2<DisplayName="Champion">,
};

enum EH7ShowOnMinimap
{
	E_H7_SOM_AUTO<DisplayName="Automatic">,
	E_H7_SOM_CUSTOM<DisplayName="Custom">,
	E_H7_SOM_DISABLED<DisplayName="Disabled">,
};

enum EH7ProgressUnit
{
	E_H7_PU_COUNTER,
	E_H7_PU_DAYS,
	E_H7_PU_WEEKS,
};

enum EH7MapSize
{
	E_H7_MS_SMALL<DisplayName="Small">,
	E_H7_MS_SMALL_BROAD<DisplayName="Small Broad">,
	E_H7_MS_NORMAL<DisplayName="Normal">,
	E_H7_MS_NORMAL_BROAD<DisplayName="Normal Broad">,
	E_H7_MS_BIG<DisplayName="Big">,
	E_H7_MS_BIG_BROAD<DisplayName="Big Broad">,
	E_H7_MS_HUGE<DisplayName="Huge">,
};

enum ESkillTier
{
	SKTIER_MINOR           <DisplayName=Minor>,
	SKTIER_MASTER          <DisplayName=Master>,
	SKTIER_GARNDMASTER     <DisplayName=Grandmaster>,
};

enum EQuickCombatStackType
{
	QCST_CREATURE,
	QCST_WARFARE,
	QCST_TOWER,
};
enum ECreatureLevel
{
	E_H7_CL_Level1<DisplayName="Core">,
	E_H7_CL_Level2<DisplayName="Strong Core">,
	E_H7_CL_Level3<DisplayName="Elite">,
	E_H7_CL_Level4<DisplayName="Strong Elite">,
	E_H7_CL_Level5<DisplayName="Champion">,
};

enum EEditorObjectColor
{
	E_H7_EOC_Blue<DisplayName="Blue">,
	E_H7_EOC_Orange<DisplayName="Orange">,
	E_H7_EOC_Green<DisplayName="Green">,
	E_H7_EOC_Purple<DisplayName="Purple">,
	E_H7_EOC_Yellow<DisplayName="Yellow">,
	E_H7_EOC_Pink<DisplayName="Magenta">,
	E_H7_EOC_Cyan<DisplayName="Cyan">,
	E_H7_EOC_Red<DisplayName="Red">,
	E_H7_EOC_White<DisplayName="White">,
};

enum EMapTag
{
	E_H7_MT_OFFICIAL<DisplayName="Official">,
	E_H7_MT_USER_GENERATED<DisplayName="User generated">,
};

enum EHeroWithStat
{
	E_H7_HWS_MIGHT<DisplayName="Might">,
	E_H7_HWS_DEFENSE<DisplayName="Defense">,
	E_H7_HWS_MAGIC<DisplayName="Magic">,
	E_H7_HWS_SPIRIT<DisplayName="Spirit">,
	E_H7_HWS_LEADERSHIP<DisplayName="Leadership">,
	E_H7_HWS_DESTINY<DisplayName="Destiny">,
	E_H7_HWS_ARCANE_KNOWLEDGE<DisplayName="Arcane Knowledge">,
	E_H7_HWS_DAMAGE_MIN<DisplayName="Minimum Damage">,
	E_H7_HWS_DAMAGE_MAX<DisplayName="Maximum Damage">,
	E_H7_HWS_MANA_CURRENT<DisplayName="Current Mana">,
	E_H7_HWS_MANA_MAX<DisplayName="Maximum Mana">,
	E_H7_HWS_MOVEMENT_CURRENT<DisplayName="Current Movement">,
	E_H7_HWS_MOVEMENT_MAX<DisplayName="Maximum Movement">,
	E_H7_HWS_LEVEL<DisplayName="Level">,
	E_H7_HWS_EXP_TOTAL<DisplayName="Total EXP">,
	E_H7_HWS_EXP_NEXT<DisplayName="Current EXP for Next Level">,
	E_H7_HWS_SKILL_POINTS<DisplayName="Skill Points">,
};

enum EEventStatus	// Beware of changes, this enum is serialized
{
	ES_ACTIVE<DisplayName="Active">,
	ES_INACTIVE<DisplayName="Inactive">,
};

// ====== STRUCTS ======

struct PrivilegesContainer
{
	var int playerIndex;
	var array<int> privileges;
};



struct native H7TooltipReplacementEntry
{
	var String placeholder;
	var String value;
};

// TOOLTIP
struct native H7TooltipLogEntry
{
	var ELogType    type;
	var float       value;
};

struct native ArrivedCaravan
{
	var savegame int index;
	var savegame H7AreaOfControlSiteLord sourceLord;
	var savegame H7AreaOfControlSiteLord targetLord;
	var savegame array<H7BaseCreatureStack> stacks;
	
};

//from H7FOWController
/**
 * Holds info about a player's explored and visible tiles.
 * Player is identified by ID.
 * 
 * @var visibleTiles    Tiles currently visible by the player
 * @var exploredTiles   Tiles explored by the player
 * @var PlayerNumber    Player  ID
 * 
 * */
struct native PlayerFogInfo
{
	var savegame array<int>	                        visibleTiles;
	var savegame array<int>                         exploredTiles;
	var array<StaticMeshComponent>					visibleStaticMeshComponents;
	var array<ParticleSystemComponent>				visibleParticleSystems;
	var savegame int								PlayerNumber;
	var savegame array<int>							handledTiles;
};

struct native H7Rect
{
	var int X;
	var int Y;
	var int width;
	var int height;
};

//from H7AdventureMapGrid
struct native AdvGridColumns
{
  var array< H7AdventureMapCell > Row;
};

//from H7AdventureMapGridController
struct native H7AreaOfControlCells
{
	// BorderCells are included in Cells!
	var array<H7AdventureMapCell> Cells;
	var array<H7AdventureMapCell> BorderCells;
	var int AreaOfControlIndex;
};

struct native H7TownBuildingData
{
	/** The type of building */
	var() savegame archetype H7TownBuilding Building     <DisplayName="Building Type">;
	/** Is this building built on start? */
	var() savegame bool IsBuilt                          <DisplayName="Is Built">;
	var() savegame bool IsBlocked                        <DisplayName="Unavailable">;
};

struct native H7AiTensionParameter
{
	var() float Base                                <DisplayName="Base">;
	var() float Gain                                <DisplayName="Gain">;
	var() float Cap                                 <DisplayName="Cap">;

	structdefaultproperties
	{
		Base=1.0f
		Gain=0.0f
		Cap=2.0f
	}
};

struct native H7AiAoCModifier
{
	var() float PBWeak                              <DisplayName="Powerbalance weak">;
	var() float PBStrong                            <DisplayName="Powerbalance strong">;
	var() float PBBalanced                          <DisplayName="Powerbalance balanced">;
	
	structdefaultproperties
	{
		PBWeak=1.0f
		PBStrong=1.0f
		PBBalanced=1.0f
	}
};

struct native H7AiAoCCompound
{
	var() H7AiAoCModifier OwnAoC                    <DisplayName="own and free AoC">;
	var() H7AiAoCModifier AlliedAoC                 <DisplayName="allied AoC">;
	var() H7AiAoCModifier HostileAoC                <DisplayName="hostile AoC">;
};

// from H7AiAdventureMapConfig
struct native H7AiConfigCompound
{
	var() float Cutoff                             <DisplayName="Cutoff Threshold">;
	var() float Low                                <DisplayName="Low Range Limit">;
	var() float High                               <DisplayName="High Range Limit">;
	var() H7AiTensionParameter Tension             <DisplayName="Tension">;
	var() int ProximityTargetLimit                 <DisplayName="Proximity Target Limit">;
	var() float MovementEffortBias                 <DisplayName="Movement Effort Bias">;
	var() float FightingEffortBias                 <DisplayName="Fighting Effort Bias">;
	var() float ReinforcementBias                  <DisplayName="Reinforcement Bias">;
	var() H7AiAoCCompound AoCMod                   <DisplayName="AoC Modifiers">;
};

struct native H7AiActionConfig
{
	var() H7AiConfigCompound General               <DisplayName="General">;
	var() H7AiConfigCompound Main                  <DisplayName="Main">;
	var() H7AiConfigCompound Secondary             <DisplayName="Secondary">;
	var() H7AiConfigCompound Scout                 <DisplayName="Scout">;
	var() H7AiConfigCompound Support               <DisplayName="Support">;
	var() H7AiConfigCompound Mule                  <DisplayName="Mule">;
};

struct native H7AiActionParameter
{
	var() float General                             <DisplayName="General">;
	var() float Main                                <DisplayName="Main">;
	var() float Secondary                           <DisplayName="Secondary">;
	var() float Scout                               <DisplayName="Scout">;
	var() float Support                             <DisplayName="Support">;
	var() float Mule                                <DisplayName="Mule">;
};

enum EAdvActionID
{
	AID_AttackArmy,
	AID_AttackBorderArmy,
	AID_AttackAoC,
	AID_AttackCity,
	AID_AttackEnemy,
	AID_Plunder,
	AID_Explore,
	AID_Repair,
	AID_Pickup,
	AID_Gather,
	AID_Guard,
	AID_Reinforce,
	AID_Flee,
	AID_Chill,
	AID_UseSite,
	AID_Congregate,
	AID_UseSiteBoost,
	AID_UseSiteCommission,
	AID_UseSiteExercise,
	AID_UseSiteObserve,
	AID_UseSiteShop,
	AID_UseSiteStudy,
	AID_UseSiteKeymaster,
	AID_UseSiteObelisk,
	AID_Replenish,
	//
	__AID_MAX
};

struct native H7AiHeroAgCompound
{
	var() float AttackArmy                          <DisplayName="Attack Army Mod">;
	var() float AttackBorderArmy                    <DisplayName="Attack Border Army Mod">;
	var() float AttackAoC                           <DisplayName="Attack AoC Mod">;
	var() float AttackCity                          <DisplayName="Attack City Mod">;
	var() float AttackEnemy                         <DisplayName="Attack Enemy Mod">;
	var() float Plunder                             <DisplayName="Plunder Mod">;
};

struct native H7AiHeroConfig
{
	var() H7AiHeroAgCompound Sheep                  <DisplayName="Sheep">;
	var() H7AiHeroAgCompound Contained              <DisplayName="Contained">;
	var() H7AiHeroAgCompound Balanced               <DisplayName="Balanced">;
	var() H7AiHeroAgCompound Hostile                <DisplayName="Hostile">;
	var() H7AiHeroAgCompound Nefarious              <DisplayName="Nefarious">;
};

struct native H7AiHeroAgCompound2
{
	var() float Explore                             <DisplayName="Explore Mod">;
	var() float Repair                              <DisplayName="Repair Mod">;
	var() float Pickup                              <DisplayName="Pickup Mod">;
	var() float Gather                              <DisplayName="Gather Mod">;
	var() float Guard                               <DisplayName="Guard Mod">;
	var() float Reinforce                           <DisplayName="Reinforce Mod">;
	var() float Flee                                <DisplayName="Flee Mod">;
	var() float Chill                               <DisplayName="Chill Mod">;
	var() float UseSite                             <DisplayName="Use Site Mod">;
	var() float Congregate                          <DisplayName="Congregate Mod">;
	var() float UseSiteBoost                        <DisplayName="Use Site Boost Mod">;
	var() float UseSiteCommission                   <DisplayName="Use Site Commission Mod">;
	var() float UseSiteExercise                     <DisplayName="Use Site Exercise Mod">;
	var() float UseSiteObserve                      <DisplayName="Use Site Observe Mod">;
	var() float UseSiteShop                         <DisplayName="Use Site Shop Mod">;
	var() float UseSiteStudy                        <DisplayName="Use Site Study Mod">;
	var() float UseSiteKeymaster                    <DisplayName="Use Site Keymaster Mod">;
	var() float UseSiteObelisk                      <DisplayName="Use Site Obelisk Mod">;
	var() float Replenish                           <DisplayName="Replenish Mod">;
};

struct native H7AiHeroConfig2
{
	var() H7AiHeroAgCompound2 Standard              <DisplayName="Standard">;
	var() H7AiHeroAgCompound2 Explorer              <DisplayName="Explorer">;
	var() H7AiHeroAgCompound2 Gatherer              <DisplayName="Gatherer">;
	var() H7AiHeroAgCompound2 Homeguard             <DisplayName="Homeguard">;
	var() H7AiHeroAgCompound2 General               <DisplayName="General">;
};

struct native H7AiTownDevelopment
{
	var() array<H7TownBuilding> Economy             <DisplayName="Economy">;
	var() array<H7TownBuilding> Defensive           <DisplayName="Defensive">;
	var() array<H7TownBuilding> Military            <DisplayName="Military">;
};

struct native H7AiTownConfig
{
	var() H7AiTownDevelopment Haven                 <DisplayName="Haven">;
	var() H7AiTownDevelopment Academy               <DisplayName="Academy">;
	var() H7AiTownDevelopment Stronghold            <DisplayName="Stronghold">;
	var() H7AiTownDevelopment Necropolis            <DisplayName="Necropolis">;
	var() H7AiTownDevelopment Sylvan                <DisplayName="Sylvan">;
	var() H7AiTownDevelopment Dungeon               <DisplayName="Dungeon">;
	var() H7AiTownDevelopment Fortress              <DisplayName="Fortress">;
	var() H7AiTownDevelopment Inferno               <DisplayName="Inferno">;
	var() H7AiTownDevelopment Sanctuary             <DisplayName="Sanctuary">;
};

struct native AiReceptivityEntry
{
	var() float           statHitpoints            <DisplayName=stat hitpoints mod>;
	var() float           statInitiative           <DisplayName=stat initiative mod>;
	var() float           statAttack               <DisplayName=stat attack mod>;
	var() float           statDefense              <DisplayName=stat defense mod>;
	var() float           statLeadership           <DisplayName=stat leadership mod>;
	var() float           statDestiny              <DisplayName=stat destiny mod>;
	var() float           statDamage               <DisplayName=stat damage mod>;
	var() float           statMovement             <DisplayName=stat movement mod>;

	structdefaultproperties
	{
		statHitpoints=1.0f
		statInitiative=1.0f
		statAttack=1.0f
		statDefense=1.0f
		statLeadership=1.0f
		statDestiny=1.0f
		statDamage=1.0f
		statMovement=1.0f
	}
};

struct native AiReceptivityTable
{
	var() AiReceptivityEntry      recEntryFighter  <DisplayName=Fighter>;
	var() AiReceptivityEntry      recEntryRogue    <DisplayName=Rogue>;
	var() AiReceptivityEntry      recEntryShooter  <DisplayName=Shooter>;
	var() AiReceptivityEntry      recEntryMage     <DisplayName=Mage>;
};

//from H7ResourcePile
struct native H7ResourceQuantity
{
	/** The type of resource */
	var() savegame archetype H7Resource Type			<DisplayName="Resource Type">;
	/** The amount of resource */
	var() savegame int Quantity							<DisplayName="Resource Quantity"|ClampMin=0>;
	var(Random) int RandomQuantityMin					<DisplayName="Resource Quantity Min"|ClampMin=1>;
	var(Random) int RandomQuantityMax					<DisplayName="Resource Quantity Max"|ClampMin=1>;
	/** Random quantity will be multiplied by this factor (for Gold for example) */
	var(Random) int RandomQuantityMultiplier			<DisplayName="Resource Quantity Multiplier"|ClampMin=1>;
};

struct native H7ResourceQuantities
{
	var() array<H7ResourceQuantity> Costs       <DisplayName=Resource Quantities>;
};

struct native H7RecruitmentInfo
{
	var() H7Creature Creature                                   <DisplayName=Creature>;
	var() int Count                                             <DisplayName=Count>;
	var() array<H7ResourceQuantity> Costs                       <DisplayName=Resource Quantities>;
	var() H7Dwelling OriginDwelling                             <DisplayName=Dwelling of origin>;
	var() H7CustomNeutralDwelling OriginCostumeDwelling         <DisplayName=Costume Dwelling of origin>;
};

struct native H7PlayerSpyInfo
{
	var savegame int PlayerID;
	var savegame ESpyInfoState PlayerName;
	var savegame ESpyInfoState Towns;
	var savegame ESpyInfoState Heroes;
	var savegame ESpyInfoState BestHero;
	var savegame ESpyInfoState Gold;
	var savegame ESpyInfoState CommonResourceIncome;
	var savegame ESpyInfoState RareResourceIncome;
	var savegame ESpyInfoState MapDiscovery;
	var savegame ESpyInfoState TearOfAshan;
	var savegame int           PlunderCount;
	var savegame int           SabotageCount;

	structdefaultproperties
	{
		PlayerName = ESIS_new;
		Towns = ESIS_new;
		Heroes = ESIS_new;
		BestHero = ESIS_locked;
		Gold = ESIS_locked;
		CommonResourceIncome = ESIS_locked;
		RareResourceIncome = ESIS_locked;
		MapDiscovery = ESIS_locked;
		TearOfAshan = ESIS_locked;
		PlunderCount = 0;
		SabotageCount = 0;
	}
};

struct native H7TeleportCosts
{
	var() ESkillRank HeroRank               <DisplayName=Rank>;
	var() int CoreCreatureCosts             <DisplayName=Core Creature Cost>;
	var() int EliteCreatureCosts            <DisplayName=Elite Creature Cost>;
	var() int ChampionCreatureCosts         <DisplayName=Champion Creature Cost>;
};


struct native H7HeroSkill
{
	var() H7Skill               Skill<DisplayName=Skill>;
	var() ESkillTier            Tier<DisplayName=Tier Of This Skill>;
	var() ESkillRank            Rank<DisplayName=Current Skill Rank>;
	var() array<H7HeroAbility>  LearnedAbilities<DisplayName=Skill Abilities>;
};

//from H7Creature
struct native H7CreatureEvent
{
	var() ECreatureEventType		EventType;
	var() float						Time;
	var() editinline CameraShake    CameraShake;
};

struct native H7WarfareEvent
{
	var() EWarfareUnitEventType		EventType;
	var() float						Time;
	var() editinline CameraShake    CameraShake;
};

struct native H7HeroEvent
{
	var() EHeroEventType		    EventType;
	var() float						Time;
	var() editinline CameraShake    CameraShake;
};


struct native H7DeathMaterialEffect
{
	/** The name of the Scalar Parameter to change in the Material */
	var() EMaterialParam            MaterialParamName       <DisplayName=Material Parameter>;
	/** The time between the actual death and the activation of the effect  */
	var() float                     EffectTime;
	/** The time that the effect lasts */
	var() float                     EffectLength;
	var float                       EffectStartingTime;

	structdefaultproperties
	{
		EffectTime=1.0f
		EffectLength=1.0f
	}

};

struct native H7MaterialEffect
{
	var() bool                      GotMaterialFX               <DisplayName = Activate Material FX>;
	/** The name of the Material Parameter to change in the Material */
	var() EMaterialParam            MaterialParamName           <DisplayName = Material Parameter>;
	/** The time for the effect to fade */
	var() float                     FadeOutEffectLength         <DisplayName = Fade out FX duration>;
	/** The delay for starting fade out*/
	var() float                     FadeOutEffectStartingTime   <DisplayName = Fade out FX delay>;
	/** The time for the effect to peak */
	var() float                     FadeInEffectLength          <DisplayName = Fade in FX duration>;
	/** The delay for starting fade in*/
	var() float                     FadeInEffectStartingtime    <DisplayName = Fade in FX delay>;
	/** Defines how long the Effect is at the same level after fade in*/
	var() float                     SteadyEffectTime            <DisplayName = Steady Effect Duration>;
	/** The max threshold the material will change to (if scalar)*/
	var() float                     MaxEffectImpact             <DisplayName = Max Threshold>;
	/** The max threshold the material will change to (if Color) */
	var() LinearColor               ColorManipulationMax        <DisplayName = Colormanipulation Max Threshold>;

	structdefaultproperties
	{
		GotMaterialFX=false
		FadeOutEffectLength=1.0f
		FadeOutEffectStartingTime=0.0f
		FadeInEffectLength = 1.0f
		FadeInEffectStartingtime=0.0f
		MaxEffectImpact=0.0f
	}

};

struct native H7WeaponAttachment
{
	// skeletal mesh that represents the weapon
	var() SkeletalMeshComponent WeaponSkeletalMesh;
	// true this weapon will shoot a projectile that will be moved
	var() bool IsProjectile;
	// true if this weapon is to be attached to a socket
	var() bool IsSocketAttached                     <DisplayName=Attach To Socket>;
	// name of the socket to attach to
	var() name SocketAttachName                     <DisplayName=Socket Attach Name|EditCondition=IsSocketAttached>;
};

struct native H7ParticleAttachment
{
	// skeletal mesh that represents the weapon
	var() ParticleSystemComponent ParticleSystem;
	// true if this weapon is to be attached to a socket
	var() bool IsSocketAttached                     <DisplayName=Attach To Socket>;
	// name of the socket to attach to
	var() name SocketAttachName                     <DisplayName=Socket Attach Name|EditCondition=IsSocketAttached>;
};

struct native FH7FlyTimePoint
{
	var() float TargetTime                   <DisplayName=Point Time>;
	var() float FlyHeight                    <DisplayName=Fly Height>;
	var() EH7FlyPointInterp PointInterp      <DisplayName=Interpolation Method>;
};


//from H7GameTypes
// Used to specify stacks in the editor
struct native CreatureStackProperties
{
	/** The type of creature */
	var() archetype savegame H7Creature Creature         <DisplayName=Creature>;
	/** The amount of creatures in this stack */
	var() savegame int Size                              <DisplayName=Size|ClampMin=1>;

	/** Custom position on the combat map when ambushing */
	var() savegame int CustomPositionX                   <DisplayName=Custom Cell X>;
	var() savegame int CustomPositionY                   <DisplayName=Custom Cell Y>;

	structdefaultproperties
	{	
		Size = 1;
	}
};

//from H7EditorCombatGrid
struct native H7Obstacle
{
	var() IntPoint gridPos;
	var() H7CombatObstacleObject Obstacle;
};

struct native H7MergePool
{
	var() String PoolKey;
	var() array<H7BaseCreatureStack> PoolStacks;

	structdefaultproperties
	{
		PoolKey = "Empty";
	}
};

struct native H7ResourceGatherData
{
	/** Type of resource */
	var() archetype savegame H7Resource Resource     <DisplayName=Resource>;
	/** Amount of resource */
	var() savegame int Amount                        <DisplayName=Amount|ClampMin=0>;
};


// ---------------------------------- TUSSI -------------------------------
// ------------------------------------------------------------------------


enum EAbilityTarget
{
	NO_TARGET                   <DisplayName=No Target>,
	TARGET_SINGLE               <DisplayName=Single>, 
	TARGET_AREA                 <DisplayName=Area of Effect>,
	TARGET_LINE                 <DisplayName=Line>,
	TARGET_SWEEP                <DisplayName=Sweep>,
	TARGET_CONE                 <DisplayName=Cone>,
	TARGET_CUSTOM_SHAPE         <DisplayName=Custom Shape>,
	TARGET_AOC                  <DisplayName=Current Area of Control>,
	TARGET_ELLIPSE              <DisplayName=Ellipse ( not filled )>,
	TARGET_SUNBURST             <DisplayName=Sun Burst>,
	TARGET_TSUNAMI              <DisplayName=Tsunami>,
	TARGET_DOUBLE_LINE          <DisplayName=Double Line (2x2 Line)>,
};

enum EEffectTarget
{
	TARGET_DEFAULT              <DisplayName=Default>, // TODO DISCUSS what are ability.targets
	TARGET_SELF                 <DisplayName=Initiator( Caster[Ability,Spell,Buff] or Owner[Skill,Item] )>,
	TARGET_CASTER               <DisplayName=Caster of this Ability,Spell or Buff>,
	TARGET_OWNER                <DisplayName=Owner of this Skill, Item or Buff>,           
	TARGET_TARGET               <DisplayName=Target From Event (only one target)>, //mSourceOfEffect.GetTarget() TODO DISCUSS does this make sense + DISCUSS what are ability.targets
	TARGET_ATTACKER             <DisplayName=Attacker (Currently Active Unit in Turn) >,
	TARGET_ATTACKER_COMBAT	    <DisplayName=Attacker (Attacker from Combat Result) >,
	TARGET_DEFENDER             <DisplayName=Defender (Main Target of this ability)>, //GetCurrentCommand().GetAbilityTarget()
	TARGET_AREA_AROUND_CASTER   <DisplayName=Adjacent to Caster>,
	TARGET_AREA_AROUND_TARGET   <DisplayName=Adjacent to Target>, // TODO DSICUSS uses different targeting than TARGET_TARGET and TARGET_DEFENDER
	TARGET_ALL                  <DisplayName=All Targetable>,
	TARGET_FROM_ABILITY         <DisplayName=Override Target From Script>, // TODO DISCUSS what are ability.targets
	TARGET_RANDOM_ADJACENT      <DisplayName=Random Adjacent Target>,
	TARGET_FROM_CONTAINER       <DisplayName=Override Target From Container ( prev Command )>,
};

struct native H7TooltipModifierInfo
{
	var() int       Value;
	var() string    Category;
	var() string    Source;
};



enum EOperationType
{
	OP_TYPE_MULTIPLY            <DisplayName=multiply>,
	OP_TYPE_ADD                 <DisplayName=add amount>,
	OP_TYPE_ADDPERCENT          <DisplayName=add percent>,
	OP_TYPE_SET                 <DisplayName=set>,
	OP_TYPE_CHOOSE_ADD          <DisplayName=choose and add amount>,
	OP_TYPE_BUY_ADD             <DisplayName=buy and add>,

};

enum EOperationBool
{
	OP_TYPE_BOOL_EQUAL          <DisplayName=Equal>,
	OP_TYPE_BOOL_NOTEQUAL       <DisplayName=Not equal>,
	OP_TYPE_BOOL_LESSEQUAL      <DisplayName=Less or equal>,
	OP_TYPE_BOOL_LESS           <DisplayName=Less>,
	OP_TYPE_BOOL_MOREEQUAL      <DisplayName=More or equal>,
	OP_TYPE_BOOL_MORE           <DisplayName=More>,
};

enum EOperationLogic
{
	OP_TYPE_LOGIC_AND           <DisplayName=And>,
	OP_TYPE_LOGIC_OR            <DisplayName=Or>,
};

//from H7CombatMapGrid
struct native GridColumns
{
  var array<H7CombatMapCell> Row;
};

struct native CreaturePositon
{
	var H7CreatureStack Stack;
	var IntPoint        ToGridPosition;
	var IntPoint        FromGridPosition;
	var IntPoint        MasterCellPosition;
	var array<IntPoint> ShiftCells;

	structcpptext
	{
		UBOOL operator==(const FIntPoint& other ) const
		{
			return MasterCellPosition == other;
		}
	}
};

/**
 * Holds info about an H7AdventureMapCell's pathfinding data.
 * 
 * 
 * @var TileType                    Type of tile the cost applies for
 * @var OperationType               Type of operation how the modifier will be applied
 * @var Modifier                    Modifier by which the tile cost is modified
 * 
 */
struct native H7TerrainCostModifier
{
	var() Name                      TileTypeName;
	var() H7PathList                TileTypeNames;
	var() EOperationType            OperationType;
	var() float                     Modifier;
};

enum EStat
{
	// if you change any of these pls let robert or nikos know (for stat icons) + sir christian (artifact tool)
	STAT_ATTACK                                 <DisplayName="Attack">,
	STAT_DEFENSE                                <DisplayName="Defense">,
	STAT_LUCK_DESTINY                           <DisplayName="Luck or Destiny">,
	STAT_MORALE_LEADERSHIP                      <DisplayName="Morale or Leadership">,
	STAT_MAX_MOVEMENT                           <DisplayName="Max Movement Points">,
	STAT_CURRENT_MOVEMENT                       <DisplayName="Current Movement Points (Hero)">,
	STAT_MIN_DAMAGE                             <DisplayName="Minimum Damage">,
	STAT_MAX_DAMAGE                             <DisplayName="Maximum Damage">,
	STAT_HERO_MIN_DAMAGE_PER_LEVEL              <DisplayName="Additonal Minimum Damage per Hero Level">,
	STAT_HERO_MAX_DAMAGE_PER_LEVEL              <DisplayName="Additonal Maximum Damage per Hero Level">,
	STAT_HEALTH                                 <DisplayName="Health">,
	STAT_RANGE                                  <DisplayName="Range (0=No Range, 1=Half Range, 2=Full Range)">,
	STAT_PICKUP_COST                            <DisplayName="Pickup Cost">,	 
	STAT_SIGHT_RADIUS                           <DisplayName="Sight Radius">,
	STAT_INITIATIVE                             <DisplayName="Initiative">,
	STAT_MANA_COST                              <DisplayName="Mana Cost">,
	STAT_MANA                                   <DisplayName="Maximum Mana">,
	STAT_CURRENT_MANA                           <DisplayName="Current Mana">,
	STAT_MANA_REGEN                             <DisplayName="Mana Regeneration">,
	STAT_TRADE_RATE_BONUS                       <DisplayName="Trade Rate Bonus (Marketplace)">,
	STAT_XP_RATE                                <DisplayName="XP Rate">,                                       // %
	STAT_CURRENT_XP                             <DisplayName="Current XP">,
	STAT_SPIRIT                                 <DisplayName="Spirit (Hero)">,
	STAT_MAGIC                                  <DisplayName="Magic (Hero)">,
	STAT_BATTLERAGE                             <DisplayName="Bloodrage (Hero)">,
	STAT_MAX_DEPLOY_NUM                         <DisplayName="Max Deployment Number (Hero)">,
	STAT_MAX_DEPLOY_ROW                         <DisplayName="Deployment Row (Hero)">,
	STAT_PRODUCTION                             <DisplayName="Daily Main Production Amount (Town=Gold,Mines=ResourceX,Dwellings=Creatures)">,          // used for buildings to modify daily production output (Mine,dwelling,...)
	STAT_PLUNDER_GAIN_MOD                       <DisplayName="Plunder Gain Multiplier">,
	STAT_MERCHANT_BUY                           <DisplayName="Merchant Buy Multiplier">,
	STAT_MERCHANT_SELL                          <DisplayName="Merchant Sell Multiplier">,
	STAT_TERRAIN_COST                           <DisplayName="Terrain Cost (Hero)">,                           // used to alter the heroes terrain cost for movement (atm it applies equally to all terrain types)
	STAT_ATTACK_COUNT                           <DisplayName="Attack Count">,
	STAT_MOVE_COUNT                             <DisplayName="Move Count">,
	STAT_FLANKING_MULTIPLIER_BONUS              <DisplayName="Flanking (Damage Multiplier)">,                  // used by "Master Flanker" (Assailant skill)
	STAT_GOLDGAIN_CHEST                         <DisplayName="Gold gain out of Treasure Chests">,
	STAT_NEGOTIATION                            <DisplayName="Negotiation chance with Neutrals (+0.24 == +24%)">,
	STAT_SURRENDER_COST_MODIFIER                <DisplayName="Army surrender cost modifier">,
	STAT_FOREIGN_MORALE_PENALTY_MODIFIER        <DisplayName="Morale penalty modifier (for mixing creatures from different factions)">,
	STAT_CORE_PRODUCTION                        <DisplayName="Core Creature Production">,
	STAT_ELITE_PRODUCTION                       <DisplayName="Elite Creature Production">,
	STAT_CHAMPION_PRODUCTION                    <DisplayName="Champion Creature Production">,
	STAT_MORAL_CAP                              <DisplayName="Moral Cap">,
	STAT_NECROMANCY                             <DisplayName="Necromancy Rate (in %)">,
	STAT_LOCAL_GUARD_CORE_MAX_CAPACITY          <DisplayName="Local Guard Core Creature Maximum Capacity Increase (Town)">,
	STAT_LOCAL_GUARD_ELITE_MAX_CAPACITY         <DisplayName="Local Guard Elite Creature Maximum Capacity Increase (Town)">,
	STAT_LUCK_CAP                               <DisplayName="Luck Cap">,
	STAT_LAND_MOVEMENT                          <DisplayName="Land Movement Cost">,
	STAT_WATER_MOVEMENT                         <DisplayName="Water Movement Cost">,
	STAT_BASE_MOVEMENT                          <DisplayName="Base Terrain Movement Cost">,
	STAT_GROWTH_BONUS_PRODUCTION                <DisplayName="Production Growth Bonus">,
	STAT_SPY_INFILTRATION_TARGETS               <DisplayName="Spy Infiltration Targets">,
	STAT_NEUTRAL_CREATURE_COST                  <DisplayName="Creature Cost In Shops">,
	STAT_LUCK_MIN                               <DisplayName="Minimum Luck">,
	STAT_MORALE_MIN                             <DisplayName="Minimum Morale">,
	STAT_METAMAGIC                              <DisplayName="Metamagic (Hero)">,
	STAT_METAMAGIC_CAP                          <DisplayName="Metamagic Cap (Hero)">,
	STAT_MAGIC_ABS                              <DisplayName="Magic Absorption (capped at stack size * max damage)">,
	STAT_ARCANE_KNOWLEDGE	                    <DisplayName="Arcane Knowledge">,
	STAT_BUILDING_COSTS                         <DisplayName="Building Costs (Town) Modifier">,
	STAT_DIPLOMACY_MOD                          <DisplayName="Diplomacy Cost Modifier">,
};

//from H7CombatMapCell
enum ECellSize
{
	CELLSIZE_1x1        <DisplayName=1x1>,
	CELLSIZE_2x2        <DisplayName=2x2>,
	CELLSIZE_1x2        <DisplayName=1x2>,      // combat map - fortifications
	CELLSIZE_1x4        <DisplayName=1x4>,      // combat map - gates
};

enum EAlignmentType
{
	AT_FRIENDLY                     <DisplayName=Friendly>,
	AT_HOSTILE                      <DisplayName=Hostile>,     
	AT_NEUTRAL                      <DisplayName=Neutral>,
};

enum ETrigger
{
	PERSISTENT                      <DisplayName=Persistent (Attribute Modification)>,      // = wait until looked up (mainly for statmods,percentmods)
	ON_SELF_ABILITY_ACTIVATE        <DisplayName=Ability: On Activate>,				        // cast spell or activate ability 
	ON_INIT                         <DisplayName=Ability: Initialization>,                  // instanciate Buff - init
	ON_FINISH                       <DisplayName=Ability: On Damage FX Finished>,           // Damage Fx Finished
	ON_IMPACT                       <DisplayName=Ability: On Damage FX Impact>,             // Damage FX Impact
	ON_ABILITY_PREPARE              <DisplayName=Ability: Prepare>,
	ON_ABILITY_UNPREPARE            <DisplayName=Ability: Unprepare>,
	ON_ANY_ABILITY_ACTIVATE         <DisplayName=Unit: Before Any Activate Ability>,        // Activate Func. in BaseAbility ( listen for trigger any ability )
	ON_AFTER_ANY_ABILITY_ACTIVATE   <DisplayName=Unit: After Any Activate Ability>,         // Activate Func. in BaseAbility after( listen for trigger any ability )
	ON_GET_IMPACT                   <DisplayName=Unit: On Get Impact>,                      
	ON_WAVE_IMPACT                  <DisplayName=Unit: On Wave Imapct>,                     // Tsunami Trigger
	ON_GET_ATTACKED                 <DisplayName=Unit: On Get Attacked>,                    // raised when another unit attacks this unit( Combat / UnitCommand )  
	ON_DO_ATTACK                    <DisplayName=Unit: On Do Attack>,
	ON_DO_CRITICAL_HIT              <DisplayName=Unit: On Do Critical Hit>,                 // raised in the unit which is attacking
	ON_UNIT_TURN_START              <DisplayName=Unit: On Turn Start>,                     // raised on start turn of a unit
	ON_UNIT_TURN_END                <DisplayName=Unit: On Turn End>,                        // raised when unit turn is over
    ON_GET_DAMAGE                   <DisplayName=Unit: On Get Damage>,                      // raised when a unit get damage
	ON_DO_DAMAGE                    <DisplayName=Unit: On Do Damage>,                       // raised when a unit does damage
	ON_POST_DO_DAMAGE               <DisplayName=Unit: On After Did Damage>,                // raised after a unit does damage
	ON_GET_BUFFED                   <DisplayName=Unit: On Get Buffed>,                      // raised when a unit gets a buff    
	ON_ADD_BUFF                     <DisplayName=Unit/Buff: On Cast Buff>,                  // on add buff (Buffmanager)        
	ON_GOOD_MORAL                   <DisplayName=Unit: On Good Morale>,
	ON_BAD_MORAL                    <DisplayName=Unit: On Bad Morale>,
	ON_GOOD_LUCK                    <DisplayName=Unit: On Good Luck>,
	ON_BAD_LUCK                     <DisplayName=Unit: On Bad Luck>,
	ON_MORAL_TURN_START             <DisplayName=Unit: On Morale Turn Start>,
	ON_MORAL_TURN_END               <DisplayName=Unit: On Morale Turn End>,
	ON_CREATURE_DIE                 <DisplayName=Unit: On Creature Stack Dies>,             // raised when creaturestack dies (removed from combat)
	ON_KILL_CREATURE	            <DisplayName=Unit: On Reduce Creature Stack Size>,      // raised when the creature stack size is droped ( killing )    
	ON_PRE_RETALIATION              <DisplayName=Unit: On Pre Retaliation>,                 // raised before Retaliation on retaliator
	ON_POST_RETALIATION             <DisplayName=Unit: On Post Retaliation>, 
	ON_MOVE_ATTACK_START            <DisplayName=Unit: On Start of Move-Attack>,            // raise after Retaliation
	ON_MOVE                         <DisplayName=Unit: On Move>,
	ON_JUMP_PITCH                   <DisplayName=Unit: On Jump Pitch>,
	ON_DO_CRITICAL_DAMAGE           <DisplayName=Unit: On Do Critical Damage>,
	ON_RECEIVE_ITEM                 <DisplayName=Unit: On Receive Item>,
	ON_LOSE_ITEM                    <DisplayName=Unit: On Lose Item>,
	ON_CONSUME_ITEM                 <DisplayName=Unit: On Consume Item>,
	ON_EQUIP_ITEM                   <DisplayName=Unit: On Equip Item>,
	ON_UNEQUIP_ITEM                 <DisplayName=Unit: On Unequip Item>,
	ON_GET_TARGETED                 <DisplayName=Unit: Get Targeted By Attack/Spell/Ability (Combat)>,
	ON_TARGET_ABILITY_ACTIVATED     <DisplayName=Unit: On Any Ability At One Specific Unit Activated (Combat)>,
	ON_ABILITY_ACTIVATE             <DisplayName=AllUnits: On Any Ability From Any Unit Activated>,
	ON_ANY_CREATURE_MOVE    	    <DisplayName=AllUnits: On Any Creature Grid Position Changed>,
	ON_ANY_GOOD_MORAL               <DisplayName=AllUnits: On Any Good Morale>,
	ON_ANY_CREATURE_DIE             <DisplayName=AllUnits: On Any Creature Stack Dies>,
	ON_ANY_GET_ATTACKED             <DisplayName=AllUnits: On Any Creature Gets Attacked>,
	ON_COMBAT_TURN_START            <DisplayName=AllUnits: On Combat Turn Start>,                     // raised when a new combat turn begins 
	ON_COMBAT_START                 <DisplayName=AllUnits: On Combat Start>,                          // raised on start of a Combat
	ON_COMBAT_TURN_END              <DisplayName=AllUnits: On Combat Turn End>,                     // raised when a new combat turn begins 
	ON_COMBAT_END                   <DisplayName=AllUnits: On Combat End>,                            // raised on end of a Combat // not used ???
	ON_END_OF_EVERY_CREATURES_TURN  <DisplayName=AllUnits: On End of Every Creature's Turn (Combat)>,
	ON_BEGIN_OF_EVERY_UNITS_TURN    <DisplayName=AllUnits: On Begin of Every Creature's Turn (Combat)>,
	ON_QUICKCOMBAT_END              <DisplayName=Hero: End Quick Combat>, 
	ON_BEGIN_OF_DAY                 <DisplayName=Site/Hero/Calendar/Player: On Begin of Day (Adventuremap)>,    
	ON_POST_BUILDING_PRODUCTION	    <DisplayName=Site/Hero/Calendar/Player: On Post Building Production (Adventuremap)>,    
	ON_END_OF_DAY                   <DisplayName=Site/Hero/Calendar: On End of Day (Adventuremap)>,
	ON_BEGIN_OF_WEEK                <DisplayName=Site/Hero/Calendar: On Begin of the Week (Adventuremap)>,    
	ON_END_OF_WEEK                  <DisplayName=Site/Hero/Calendar: On End of the Week (Adventuremap)>,
	ON_BATTLE_WON                   <DisplayName=Site: When player(you) has won a Battle (Adventuremap)>,
	ON_VISIT                        <DisplayName=Site: Visit (Adventuremap)>,
	ON_POST_VISIT                   <DisplayName=Site: Post Visit (Adventuremap)>,
	ON_LEAVE						<DisplayName=Town: Leave (Adventuremap)>,
	ON_LORD_CONQUERED               <DisplayName=Town/Hero: On Town Conquered>,
	ON_ANY_BUILDING_CONQUERED       <DisplayName=Any Building Captured (Adventuremap)>,
	ON_PRE_NEXT_COMMAND             <DisplayName=Attacker&Defender: Long Before Next Command>,
	ON_PRE_COMMAND                  <DisplayName=Attacker&Defender: Before Command>,
	ON_POST_COMMAND                 <DisplayName=Attacker&Defender: After Command>,
	ON_PRE_POST_COMMAND             <DisplayName=Attacker&Defender: Before the After Command>,
	ON_BUFF_EXPIRE                  <DisplayName=Buff/Aura: On Expire>,
	ON_AFTER_BUFF_ADD               <DisplayName=Buff: After Apply>,
	ON_AURA_INIT                    <DisplayName=Aura: Initialize>,
	ON_AURA_DESTROY                 <DisplayName=Aura: Destroy>,
	ON_APPLY_AURA                   <DisplayName=Aura: Apply on Target>,
	ON_REMOVE_AURA                  <DisplayName=Aura: Remove from Target>,
	ON_ENTER_CELL                   <DisplayName=Aura: Enter Cell>,
	ON_LEAVE_CELL                   <DisplayName=Aura: Leave Cell>,
	ON_BUILDING_BUILT               <DisplayName=Aura: Building Built>,
	ON_OTHER_BUILDING_BUILT         <DisplayName=Aura: Other Building in Same Town Built>,
	ON_BUILDING_DESTROY             <DisplayName=Aura: Building Destroyed>,
	ON_BUILDING_CHANGEOWNER         <DisplayName=Aura: Building Changed Owner>,
	ON_GOVERNOR_ASSIGN              <DisplayName=Aura: Assign Governor>,
	ON_GOVERNOR_UNASSIGN            <DisplayName=Aura: Unassign Governor>,
	ON_HERO_DIE                     <DisplayName=Hero: Gets Defeated>,
	ON_MEET                         <DisplayName=Hero: Meet (Adventuremap)>,
	ON_MAGIC_SYNERGY_TRIGGERED      <DisplayName=Hero: Magic Synergy Triggered (For Attacking Hero)>,	
    ON_BATTLE_XP_GAIN               <DisplayName=Hero: On Get XP for Combats>,
	ON_AFTER_XP_GAIN                <DisplayName=Hero: On After Gain XP>,
	ON_OPEN_CHEST                   <DisplayName=Hero: On Open Treasure Chest>,
	ON_CLOSE_CHEST                  <DisplayName=Hero: On Close Treasure Chest>,
	ON_GRID_POSITION_CHANGED	    <DisplayName=CreatureStack: On Grid Position Changed>,
	ON_SKILL_LEVEL_UP               <DisplayName=Skill: On Level Up >,
	ON_TRIGGER_RETALIATION          <DisplayName=On Trigger Retaliation (use for Retaliation only!)>,
	ON_EMBARK                       <DisplayName=Hero/Army: On Embark (Ship)>,
	ON_DISEMBARK                    <DisplayName=Hero/Army: On Disembark (Ship)>,
	ON_SUMMON_ENTER_COMBAT          <DisplayName=Hero: On Summon Enters Field>,
	ON_HERO_RECRUIT                 <DisplayName=Hero: On Hero Recruit (Adventuremap)>,
	ON_PASS_THROUGH                 <DisplayName=Unit: On Passing Through (Combatmap)>,
	ON_CARAVAN_CREATED              <DisplayName=Town: On Caravan Spawned>,
	ON_NEVER                        <DisplayName=Nobody: Never (Dummy Event never raised)>, // used for no-gameplay-impact links from ability to spells
};

// TODO organize and finalize this list with design (haha)
enum ESpellTag // or EffectTag
{
	               
	TAG_                    <DisplayName=---TARGET SELECTION--->,
	TAG_SINGLE_TARGET       <DisplayName=Single Target>,            // -common sense usage- ecample: Haste // not in official design, dummy tag for modders
	TAG_MASS_TARGET         <DisplayName=Mass Target>,              // -common sense usage- example: Mass Haste // not in official design, dummy tag for modders
	TAG__                   <DisplayName=---    EFFECTS     --->,
	TAG_NEGATIVE_EFFECT     <DisplayName=Negative Effect>,          // for Metamagic to know if its negative (buzzword)
	TAG_POSITIVE_EFFECT     <DisplayName=Positive Effect>,          // for Metamagic to know if its postive (buzzword)
	TAG___                  <DisplayName=---   CONTAINER    --->,
	TAG_SPELL               <DisplayName=Spell>,                    // For Titan Absorbtion we need to know what is a Spell so we chan Absorb/Resist it
	TAG_DAMAGE_DIRECT       <DisplayName=Default Ability>,          // Default abilites deal 50% damage on immune units
	TAG____                 <DisplayName=---     EFFECT     --->,
	TAG_HEAL                <DisplayName=Heal Effect>,              // - common sense usage-
	TAG_REPAIR              <DisplayName=Construct Repair>,         // - common sense usage-
	TAG_RESURRECT           <DisplayName=Resurrection Effect>,
	TAG_MOVEMENT_REDUCTION	<DisplayName=Movement Reduction>,       // - common sense usage- needed for unfettered, sum of various effects that manipulate your movement in a bad way
	TAG_POISON              <DisplayName=Poison>,
	TAG_MORAL               <DisplayName=Morale>,
	TAG_BLINDING            <DisplayName=Blinding>,
	TAG_INCAPACITATED       <DisplayName=Incapacitated>,
	TAG_____                <DisplayName=---SPELLBOOK FILTER--->,
	//SPELLBOOK FILTER TAGS
	TAG_FILTER_DAMAGE       <DisplayName=Spellbook Filter: Damage>,
	TAG_FILTER_UTILITY      <DisplayName=Spellbook Filter: Utility>,
};

enum EDefaultAbilities
{
	ED_CUSTOM					<DisplayName=Use Custom>,
	ED_MELEE_ATTACK				<DisplayName=Use Default Melee Attack>,
	ED_RANGED_ATTACK			<DisplayName=Use Default Range Attack>,
	ED_RETALIATION_ABILITY		<DisplayName=Use Default Retaliation>,
	ED_WAIT_ABILITY				<DisplayName=Use Default Wait>,
	ED_DEFEND_ABILITY			<DisplayName=Use Default Defend>,
	ED_MORAL_ABILITY			<DisplayName=Use Default Morale Ability>,
	ED_REPL_MORAL_ABILITY		<DisplayName=Replace Morale Ability>, 
	ED_LUCK_ABILITY				<DisplayName=Use Default Luck>,    
	ED_REPL_LUCK_ABILITY		<DisplayName=Replace Luck Ability>,
	ED_REPL_WARFARE_ATTACK	    <DisplayName=Replace Warfare Unit Attack Ability>,
	ED_REPL_WARFARE_DEFAULT	    <DisplayName=Replace Warfare Unit Base Ability>,
	ED_REPL_WARFARE_SUPPORT	    <DisplayName=Replace Warfare Unit Support Ability>,
};

enum ESpellOperation
{
	ADD_BUFF            <DisplayName=Add Buff>,
	REMOVE_BUFF         <DisplayName=Remove Buff>,
	ADD_ABILITY         <DisplayName=Add Ability>,
	REMOVE_ABILITY      <DisplayName=Remove Ability>,
	ADD_VOLABILITY      <DisplayName=Add Item Ability>,
	REMOVE_VOLABILITY   <DisplayName=Remove Item Ability>,
	SUPPRESS_ABILITY    <DisplayName=Suppress Ability>,
	UNSUPPRESS_ABILITY  <DisplayName=Unsuppress Ability>,
	INCREASE_SKILL      <DisplayName=Increase Skill>,
};

enum EProjectileType
{
	PT_BULLET           <DisplayName=Bullet>,
	PT_BOMBARD          <DisplayName=Bombard>,
	PT_AIRDROP          <DisplayName=Airdrop>,
	PT_BEAM             <DisplayName=Beam>,
};

// ALL HERO SKILLS 
enum ESkillType
{   
	SKT_NONE            <DisplayName=None>,
	// MIGHT SKILLS
	SKT_ASSAILANT       <DisplayName=Offense>,
	SKT_DEFENDER        <DisplayName=Defense>,
	SKT_EXPLORER        <DisplayName=Exploration>,
	SKT_LEADERSHIP      <DisplayName=Leadership>,
	SKT_WARCRIES        <DisplayName=Warcries>,
	// MAGIC SKILLS
	SKT_FIRE_MAGIC      <DisplayName=Fire Magic>,
	SKT_WATER_MAGIC     <DisplayName=Water Magic>,
	SKT_LIGHT_MAGIC     <DisplayName=Light Magic>,
	SKT_DARK_MAGIC      <DisplayName=Dark Magic>,
	SKT_EARTH_MAGIC     <DisplayName=Earth Magic>,
	SKT_AIR_MAGIC       <DisplayName=Air Magic>,
	SKT_PRIME_MAGIC     <DisplayName=Prime Magic>,
	// FACTION SKILLS
	SKT_SOLIDARITY      <DisplayName=Righteousness>,
	SKT_NECROMANCY      <DisplayName=Necromancy>,
	SKT_METAMAGIC       <DisplayName=Meta Magic>,
	SKT_BATTLERAGE      <DisplayName=Bloodrage>,
	SKT_RUNEMAGIC       <DisplayName=Rune Magic>,
	SKT_SHROUD          <DisplayName=Shroud>,
	SKT_GATING          <DisplayName=Gating>,
	SKT_AVENGER         <DisplayName=Avenger>, // NOT IP APPROVED
	SKT_ENLIGHTENMENT   <DisplayName=Paragon>,
	SKT_DESTINYS_CHOSEN <DisplayName=Destiny>,
	SKT_ECONOMIST       <DisplayName=Economy>,
	SKT_DIPLOMACY       <DisplayName=Diplomacy>,
	SKT_WARFARE         <DisplayName=Warfare>,
	SKT_NATURES_MARK    <DisplayName=Natures Mark>,
	SKT_FURTIVENESS     <DisplayName=Furtiveness>,
};


//from H7Unit // really is now entity type // but renaming deletes everything TODO discuss
enum EAttackType
{
	CATTACK_MIGHT       <DisplayName=Might>,
	CATTACK_MAGIC       <DisplayName=Magic>,
};

enum EUnitType
{
	UNIT_HERO                                   <DisplayName=Hero>,
	UNIT_CREATURESTACK                          <DisplayName=Creature Stack>,
	UNIT_WARUNIT                                <DisplayName=Warfare Unit>,
	UNIT_TOWER                                  <DisplayName=Tower>,
	ENTITY_TYPE_ADV_BUILDING                    <DisplayName=Building>,
	ENTITY_TYPE_CELL                            <DisplayName=Map Cell>,
	ENTITY_TYPE_OBSTACLE                        <DisplayName=Obstacle>,
	ENTITY_TYPE_ADV_GRID                        <DisplayName=Adventuremap>,
	ENTITY_TYPE_COMBAT_GRID                     <DisplayName=Combatmap>,
	ENTITY_TYPE_PLAYER                          <DisplayName=Player>,
	ENTITY_TYPE_TOWN                            <DisplayName=Town>,
	ENTITY_TYPE_FORT                            <DisplayName=Fort>,
	ENTITY_TYPE_DWELLING                        <DisplayName=Dwelling>,
	ENTITY_TYPE_MINE                            <DisplayName=Mine>,
	ENTITY_TYPE_MERCHANT                        <DisplayName=Merchant>,   
	ENTITY_TYPE_ADVENTURE_OBJECT                <DisplayName=Adventure Script Object>,
	ENTITY_TYPE_TOWN_BUILDING                   <DisplayName=Town Building>
};

enum EAbilitySchool
{
	MIGHT                                       <DisplayName=Might>,
	AIR_MAGIC                                   <DisplayName=Air Magic>,
	DARK_MAGIC                                  <DisplayName=Dark Magic>,
	EARTH_MAGIC                                 <DisplayName=Earth Magic>,
	FIRE_MAGIC                                  <DisplayName=Fire Magic>,
	LIGHT_MAGIC                                 <DisplayName=Light Magic>,
	PRIME_MAGIC                                 <DisplayName=Prime Magic>,
	WATER_MAGIC                                 <DisplayName=Water Magic>,
	ALL_MAGIC                                   <DisplayName=All Magic>,
	ALL                                         <DisplayName=All>,
	ABILITY_SCHOOL_NONE                         <DisplayName=None>,
};


//from H7Creature
enum ECreatureTier
{
	CTIER_CORE                  <DisplayName=Core>,
	CTIER_ELITE                 <DisplayName=Elite>,
	CTIER_CHAMPION              <DisplayName=Champion>,
};

enum EMovementType // used in flash, inform GUI programmer onChange!!!
{
	CMOVEMENT_WALK              <DisplayName=Walk>,
	CMOVEMENT_FLY               <DisplayName=Fly>,
	CMOVEMENT_TELEPORT          <DisplayName=Teleport>,
	CMOVEMENT_GHOSTWALK         <DisplayName=Ghostwalk>,
	CMOVEMENT_STATIC            <DisplayName=Static>,
	CMOVEMENT_JUMP              <DisplayName=Jump>,	
	CMOVEMENT_SHROUD            <DisplayName=Shroud>,
};

//from H7WarUnit
enum EWarUnitClass
{
	WCLASS_SIEGE        <DisplayName=Siege Engine>,
	WCLASS_ATTACK       <DisplayName=Attack Unit>,
	WCLASS_SUPPORT      <DisplayName=Support Unit>,
	WCLASS_HYBRID       <DisplayName=Support and Attack Unit>
};

//from H7CombatAction
enum ECommandTag
{
	// combat map
	ACTION_MELEE_ATTACK,
	ACTION_RANGE_ATTACK,
	ACTION_RETALIATE,
	ACTION_RANGED_RETALIATE,
	ACTION_ABILITY,
	ACTION_DOUBLE_MELEE_ATTACK,
	ACTION_DOUBLE_RANGED_ATTACK,
	ACTION_LIGHTNING_REFLEXES_STRIKE,
	ACTION_MOVE,
	ACTION_MOVE_ATTACK,
	ACTION_INTERRUPT,
	ACTION_REPEAT,
	// adventure map
	ACTION_MOVE_MEET,
	ACTION_MOVE_VISIT,
	ACTION_MOVE_NO_FOLLOW,
	ACTION_MOVE_PATROL,
	ACTION_MOVE_ROTATE,
};

enum EFXPosition
{
	FXP_TARGET_POSITION,
	FXP_ABOVE_TARGET,
	FXP_SOCKET,
	FXP_BELOW_TARGET,
	FXP_HIT_POSITION,
};

//from H7Player
enum EPlayerType
{
	PLAYER_HUMAN        <DisplayName=Human>,
	PLAYER_AI           <DisplayName=AI>
};

enum EPlayerSlot // possibilities
{
	EPlayerSlot_Closed          <DisplayName=Closed>,
	EPlayerSlot_UserDefine      <DisplayName=User Defined>,
	EPlayerSlot_Human           <DisplayName=Human>,
	EPlayerSlot_AI              <DisplayName=AI>
};

enum EPlayerSlotState // actual selecton // used in flash, do not change!
{
	EPlayerSlotState_Undefined       <DisplayName=Undefined>,
	EPlayerSlotState_Closed          <DisplayName=Closed>,
	EPlayerSlotState_Open            <DisplayName=Open Human Slot or Hotseat Human>,
	EPlayerSlotState_Occupied        <DisplayName=Used Human Slot>,
	EPlayerSlotState_AI              <DisplayName=AI>
};

enum EPlayerColor
{
	PCOLOR_BLUE         <DisplayName=Blue>,
	PCOLOR_CYAN         <DisplayName=Cyan>,
	PCOLOR_TURQUOISE    <DisplayName=Turquoise>,
	PCOLOR_GOLD         <DisplayName=Gold>,
	PCOLOR_GREEN        <DisplayName=Green>,
	PCOLOR_NEUTRAL      <DisplayName=Neutral (White)>,
	PCOLOR_SILVER       <DisplayName=Silver>,
	PCOLOR_ORANGE       <DisplayName=Orange>,
	PCOLOR_PURPLE       <DisplayName=Purple>,
	PCOLOR_RED          <DisplayName=Red>,
	PCOLOR_SIENA        <DisplayName=Siena>,
	PCOLOR_TEAL         <DisplayName=Teal>,
	PCOLOR_ULTRAMARINE  <DisplayName=Ultramarine>,
	PCOLOR_AMETHYST     <DisplayName=Amethyst>,
	PCOLOR_EMERALD      <DisplayName=Emerald>
};

enum ETeamNumber
{
	TN_NO_TEAM          <DisplayName=No Team>,
	TN_TEAM_1           <DisplayName=Team 1>,
	TN_TEAM_2           <DisplayName=Team 2>,
	TN_TEAM_3           <DisplayName=Team 3>,
	TN_TEAM_4           <DisplayName=Team 4>,
	TN_TEAM_5           <DisplayName=Team 5>,
	TN_TEAM_6           <DisplayName=Team 6>,
	TN_TEAM_7           <DisplayName=Team 7>,
	TN_TEAM_8           <DisplayName=Team 8>,
};

enum ETeamSetup // Warning - used in flash, call GUI programmer when changed
{
	TEAM_CUSTOM,
	TEAM_MAP_DEFAULT,
	TEAM_NO_TEAMS
};

enum EForceQuickCombat
{
	FQC_NEVER,
	FQC_AGAINST_AI,
	FQC_ALWAYS
};

//from H7CreatureAnimControl
enum ECreatureAnimation
{
	CAN_IDLE,
	CAN_IDLE_SPECIAL,
	CAN_MOVE,
	CAN_TURNLEFT,
	CAN_TURNRIGHT,
	CAN_DIE,
	CAN_ABILITY,
	CAN_ABILITY2,
	CAN_ATTACK,
	CAN_CRITICAL_ATTACK,
	CAN_RANGE_ATTACK,
	CAN_GET_HIT,
	CAN_VICTORY,
	CAN_DEFEND,
	CAN_START_FLY,
	CAN_LOOP_FLY,
	CAN_END_FLY,
	CAN_START_JUMP,
	CAN_LOOP_JUMP,
	CAN_END_JUMP,
	CAN_FLY_IN,
	CAN_FLY_OUT,
	CAN_DIVING_LOOP,
	CAN_MOVE_START,
	CAN_MOVE_END,
	CAN_NONE,
};

enum EPlayerStatus
{
	PLAYERSTATUS_UNUSED,
	PLAYERSTATUS_ACTIVE,
	PLAYERSTATUS_INACTIVE,
	PLAYERSTATUS_QUIT,
};

enum EArmyCompositionType
{
	EACT_ANY<DisplayName="Any">,
	EACT_BASIC<DisplayName="Basic">,
	EACT_UPGRADED<DisplayName="Upgraded">,
};

enum EHeroTypeId
{
	HEROTYPE_MIGHT,
	HEROTYPE_MAGIC
};

enum EHeroSoundId
{
	HEROSOUND_MOUNTED_ATTACK,
	HEROSOUND_MOUNTED_RANGEATTACK,
	HEROSOUND_MOUNTED_COMMAND,
	HEROSOUND_MOUNTED_ABILITY,
	HEROSOUND_MOUNTED_VICTORY,
	HEROSOUND_MOUNTED_DEFEAT,
	HEROSOUND_MOUNTED_IDLE,     // plays random idle sound
	HEROSOUND_MOUNTED_IDLE_END,
	HEROSOUND_MOUNTED_MOVE,
	HEROSOUND_MOUNTED_MOVE_END,
	HEROSOUND_MOUNTED_TURNLEFT,
	HEROSOUND_MOUNTED_TURNRIGHT,
	HEROSOUND_LEVEL_UP,
	HEROSOUND_COMBAT_SCREEN_START,
	HEROSOUND_ENGAGE_COMBAT,
	HEROSOUND_ENGAGE_QUICK_COMBAT,
	HEROSOUND_MOVE_SHIP,
	HEROSOUND_MOVE_SHIP_END,
	HEROSOUND_BOARDING_SHIP,
	HEROSOUND_SHIP_TURNING,
	HEROSOUND_SHIP_IDLE,
	HEROSOUND_SHIP_IDLE_END
};

//from H7HeroAnimControl
struct native AnimationData
{
	var AnimNodePlayCustomAnim	AnimNode;
	var name					AnimName;
	var name					StateName;
};

struct native H7PlayerProperties
{
	var() H7Player mPlayer;
	var() ETeamNumber mTeam;
};

struct native H7SpellScaling
{
	/** Use minimum or maximum cap */
	var() bool mUseCap                  <DisplayName=Use Minimum/Maximum Cap>;
	/** The minimum cap */
	var() int mMinCap                   <DisplayName=Minimum Cap|EditCondition=mUseCap>;
	/** The maximum cap */
	var() int mMaxCap                   <DisplayName=Maximum Cap|EditCondition=mUseCap>;
	/** The slope or gradient */
	var() float mSlope                  <DisplayName=Slope/Gradient>;
	/** The Y-Intercept */
	var() float mIntercept              <DisplayName=Y-Intercept>;
};

struct native H7LevelScalingRange
{
	/** Min Level (<=) */
	var() int mMin<DisplayName=Min(From)>;
	/** Max Level (>=) */
	var() int mMax<DisplayName=Max(to)>;
	/** The amount for the level range you've selected */
	var() float mAmount<DisplayName=Amount of Resources>;
};

struct native H7PurchaseAbleStatModCosts
{
	/**Enables level scaling costs for the purchase of the permanent buff */
	var() bool mUseLevelScalingCosts <DisplayName=Use Level scaling costs>;
	/** The Type and the amount of the price for the permanent buff*/
	var() H7ResourceQuantity mCosts <DisplayName=Resource costs>;
	/**The level ranges for the price you've selected for the permanent buff */
	var() Array <H7LevelScalingRange> mLevelRanges <DisplayName=Level Ranges>;
};
/* This is kept by each ability, skill, buff (and eventually item)
 * which needs to increase / decrease a value of a Stat
 */
struct native H7MeModifiesStat
{
	/** The stat that gets modified */
	var() EStat mStat                                               <DisplayName=This will be modified>;
	/** How the stat gets modified (operator type "special case" is not implemented for this operation) */
	var() EOperationType mCombineOperation                          <DisplayName=in this way|EditCondition=!mOverrideWithAnotherStat>;
	/** The amount by which the stat gets modified */
	var() float mModifierValue                                      <DisplayName=by this amount|EditCondition=!mUseSpellScaling||!mUseBattleRageValue>;
	/** Shows a floating text */
	var() bool mShowFloatingText                                    <DisplayName=Show floating text?>;
	/** Should spells be taken into account (NOTE: works for heroes as original casters only!) */
	var() bool mUseSpellScaling                                     <DisplayName=Use Spell Scaling|EditorCondition=!mUseBattleRageValue>;
	/** Dependant on the hero level, the amount of the statmodifier is changed*/
	var() bool mUseLevelScaling                                     <DisplayName=Use Level Scaling Stat Modifier>;
	/** BattleRage */
	var() bool mUseBattleRageValue                                  <DisplayName=Use Bloodrage|EditCondition=!mOverrideWithAnotherStat>;
	/** Multiply modifier with BattleRage */
	var() bool mMultiplyWithBattleRage                              <DisplayName=Multiply with Bloodrage|EditCondition=!mOverrideWithAnotherStat>;
	/** Metamagic */
	var() bool mUseMetamagicValue                                   <DisplayName=Use Metamagic|EditCondition=!mOverrideWithAnotherStat>;
	/** Multiply modifier with Metamagic */
	var() bool mMultiplyWithMetamagic                               <DisplayName=Multiply with Metamagic|EditCondition=!mOverrideWithAnotherStat>;
	/** The spell scaling to use */
	var() H7SpellScaling mScalingModifierValue                      <DisplayName=Spell Scaling Modifier|EditCondition=mUseSpellScaling>;
	/** The stat mod level dependant scaling ranges (only with OP_TYPE_CHOOSE_ADD)*/
	var() array<H7LevelScalingRange> mStatModLevelScalingValue      <DisplayName=Level Scaling StatMod Properties>;
	/** The price for the permanent buff, if it must be purchased (only with OP_TYPE_BUY_ADD)*/
	var() array<H7PurchaseAbleStatModCosts> mStatModCosts           <DisplayName=Statmod Purchase Price>;
	/** If the stat mod value is two, and the caster's path is three steps long, the stat mod value will become six. */
	var() bool mMultiplyWithPathLength                              <DisplayName=Multiply with Path Length>;
	/** Special handling for Shrine of the Seventh Dragon (Provides exactly one Level advancement) */
	var() bool mShirneSeventhDragon                                 <DisplayName=Enable Shrine of the Seventh Dragon>;
	/** */
	var() bool mOverrideWithAnotherStat                             <DisplayName=Override with other stat>;
	/** */
	var() EStat mStatToOverrideWith                                 <DisplayName=Stat to use for override|EditCondition=mOverrideWithAnotherStat>;
	/** For Core/Elite/Champion unit production: Modify production only for a single creature instead of the whole tier. */
	var() bool mModifyStatForCreature                               <DisplayName=Modify Unit Production For Creature>;
	/** Modify unit production for this specific creature. */
	var() H7Creature mModifyThatCreature                            <DisplayName=Modify Production For This Creature|EditCondition=mModifyStatForCreature>;
	/** Also modify production of base/upgraded versions of that creature. */
	var() bool  mModifyCreatureVersions                             <DisplayName=Affects also Base/Upgrade of Creature>;

	var H7EffectContainer mSource; //The source that created this mod
	var float mInitialModValue;

	structdefaultproperties
	{
		mCombineOperation = OP_TYPE_ADD;
		mModifyStatForCreature = false;
		mModifyCreatureVersions = false;
		mInitialModValue = 0.f;
	}
};

struct native H7StatModSource
{
	var H7MeModifiesStat mMod;
	var H7EffectContainer mSource;

	var String mSourceName; // workaround for mods that don't come from H7EffectContainer
};

/* This is kept by each ability, skill, buff (and eventually item)
 * which needs to increase / decrease a value of a Stat
 */
struct native H7ManaCostModifier
{
	var() bool mUseForSchool                                        <DisplayName=Use for schools?>;
	/** How the mana cost gets modified  */
	var() EOperationType mCombineOperation                          <DisplayName=Operation type>;
	/** The amount by which the mana cost gets modified */
	var() float mModifierValue                                      <DisplayName=Amount>;
	/** The ability affected **/
	var() H7HeroAbility mAbility                                    <DisplayName=Ability|EditCondition=!mUseForSchool>;
	/** The school affected **/
	var() EAbilitySchool mAbilitySchool                             <DisplayName=School|EditCondition=mUseForSchool>;

	structdefaultproperties
	{
		mCombineOperation = OP_TYPE_ADD;
	}
};

struct native H7RangeValue
{
	 var() int                          MinValue                        <DisplayName=Minimum>; 
	 var() int                          MaxValue                        <DisplayName=Maximum>;
	 var String                         MinValueFormular						             ;
	 var String                         MaxValueFormular                                     ;
};

struct native H7SpellValue
{
	var() H7RangeValue                  mUnskilled                      <DisplayName=Unskilled>;
	var() H7RangeValue                  mNovice                         <DisplayName=Novice>;
	var() H7RangeValue                  mExpert                         <DisplayName=Expert>;
	var() H7RangeValue                  mMaster                         <DisplayName=Master>;
};


struct native H7SpellStruct
{
	var() ESpellOperation               mSpellOperation                 <DisplayName=Operation>;
	var() EDefaultAbilities             mDefaultAbility                 <DisplayName=Ability To Use|Tooltip="Use Custom" uses the Archetype specified by "Spell/Buff/Ability Archetype">;
	var() H7EffectContainer             mSpell                          <DisplayName=Spell/Buff/Ability/Skill Archetype>;
	var() bool                          mAssociateWithSkill             <DisplayName=Associate with skill? (For Hero Abilities)>;
};


struct native H7TriggerStruct
{
	var() ETrigger                      mTriggerType                    <DisplayName=Activation Trigger>;
	var() int                           mChance                         <DisplayName=Chance to Trigger|Tooltip=0-100>;
	var() bool                          mUseLuckRoll                    <DisplayName=Use Units Luck/Destiny value>;

	structdefaultproperties
	{
		mChance = 100;
	}
};

struct native H7ResistanceStruct
{
	var() EAbilitySchool                school                          <DisplayName=School>;
	var() array<ESpellTag>              tags                            <DisplayName=Resistance Tags (resist only if effect has ALL tags)>;
	var() float                         damageMultiplier                <DisplayName=0.0 Immmune, 0.5 Half, 1.25 +25% >;
	var() bool                          MultiplyResByMetamagic          <DisplayName="Multiply value by Metamagic" >;
	var() bool                          ResistOnlyBuffs                 <DisplayName=Only Resist Buffs/Debuffs>;
};

struct native H7StatCondition
{
	var() EStat                         Stat1                           <DisplayName=>;
	var() EOperationBool                OperationType                   <DisplayName=>;
	var() bool                          WithValue                       <DisplayName=With Value?>;
	var() float                         Value                           <DisplayName=|EditCondition=WithValue>;
	var() EStat                         Stat2                           <DisplayName=|EditCondition=!WithValue>;
};

struct native H7ConditionStructExtendedTarget // target
{
	/** Use the unit next to the caster in the initiative bar  */
	var() bool                          NextUnitInQueue                 <DisplayName=Get Next Unit in Initiativebar>;
	
	/** Check if the target is (not) of this type (use "Equal" and "Not equal" only) */
	var() bool                          UseUnitType                     <DisplayName=Check Target Type>;
	var() EOperationBool                UOperation                      <DisplayName=|EditCondition=UseUnitType>;
	var() EUnitType                     UnitType                        <DisplayName=Is|EditCondition=UseUnitType>;

	/** Check if the target is (not) of this type (use "Equal" and "Not equal" only) */
	var() bool                          UseUnitTypes                    <DisplayName=Check Target Types>;
	var() EOperationBool                UTOperation                     <DisplayName=|EditCondition=UseUnitTypes>;
	var() array<EUnitType>              UnitTypes                       <DisplayName=Is>; //arrays should not have editconditions, because this breaks their usage in the editor
	
	/** Check if the target is (not) of this allegiance (use "Equal" and "Not equal" only) */
	var() bool                          UseUnit                         <DisplayName=Check Target Allegiance>;
	var() EOperationBool                UAOperation                     <DisplayName=|EditCondition=UseUnit>;
	var() EAlignmentType                UAAlignment                     <DisplayName=Is|EditCondition=UseUnit>;

	/** Check if the target is (not) of this tier (use "Equal" and "Not equal" only) */
	var() bool                          UseCreatureTier                 <DisplayName=Check Creature Tier>;
	var() EOperationBool                CTTOperation                    <DisplayName|EditCondition=UseCreatureTier>;
	var() ECreatureTier                 CTTier                          <DisplayName=Is|EditCondition=UseCreatureTier>;

	/** Check if the target is (not) of this size (use "Equal" and "Not equal" only) */
	var() bool                          UseCreatureSize                 <DisplayName=Check Creature Size>;
	var() EOperationBool                CSOperation                     <DisplayName|EditCondition=UseCreatureSize>;
	var() ECellSize	                    CSSize                          <DisplayName=Is|EditCondition=UseCreatureSize>;

	/** Check if the target is (not) of this movement type (use "Equal" and "Not equal" only) */
	var() bool                          UseMovementType                 <DisplayName=Check Creature Movement Type>;
	var() EOperationBool                MovementOp                      <DisplayName|EditCondition=UseMovementType>;
	var() EMovementType                 MovementType                    <DisplayName=Is|EditCondition=UseMovementType>;

	/** Check target's magic school */
	var() bool                          UseMagicSchool                  <DisplayName=Check Target Magic School>;
	var() EOperationBool                UMagicSchoolOp                  <DisplayName|EditCondition=UseMagicSchool>;
	var() EAbilitySchool                UMagicSchoolType                <DisplayName=Is|EditCondition=UseMagicSchool>;

	/** Check if the target is (not) a ranged unit */
	var() bool                          UnitIsRanged                    <DisplayName=Check For Range Attack>;
	var() bool                          UnitHasRange                    <DisplayName=Unit Has Range Attack|EditCondition=UnitIsRanged>;

	/** Check if the target has (not) this buff (use "Equal" and "Not equal" only) */
	var() bool                          UnitHasBuff                     <DisplayName=Check Buff>;
	var() EOperationBool                BuffOp                          <DisplayName=|EditCondition=UnitHasBuff>;
	var() H7BaseBuff                    CTBuff                          <DisplayName=has|EditCondition=UnitHasBuff>;

	/** Check if Caster has one or more or none of these buffs (use "Equal" and "Not equal" only) */
	var() bool                          UnitHasBuffs                    <DisplayName=Check Buffs>;
	var() EOperationBool                BuffsOp                         <DisplayName=|EditCondition=UnitHasBuffs>;
	var() array<H7BaseBuff>	            CTBuffs	                        <DisplayName=these>;
	
	/** Check if the target has this stat in the specified state (type "special case" is not implemented for stats) */
	var() bool                          UseConditionStat                <DisplayName=Use Stat Conditions>;
	var() H7StatCondition               StatCondition                   <DisplayName=Stat Condition Check|EditCondition=UseConditionStat>;

	/** Check if the target has (not) this ability (use "Equal" and "Not equal" only) */
	var() bool                          UseHasAbility                   <DisplayName=Unit has Ability>;
	var() EOperationBool                AbilityOp                       <DisplayName=|EditCondition=UseHasAbility>;
	var() H7BaseAbility                 HasAbility                      <DisplayName=this|EditCondition=UseHasAbility>;

	/** Check if the target has at least one or none of the listed abilities (use "Equal" and "Not equal" only) */
	var() bool                          UseHasAbilities                 <DisplayName=Unit has Abilities>;
	var() EOperationBool                AbilitiesOp                     <DisplayName=|EditCondition=UseHasAbilities>;
	var() EOperationLogic               AbilitiesLogic                  <DisplayName=Logical operation apply to all abilities>;
	var() array<H7BaseAbility>          HasAbilities                    <DisplayName=this>; //arrays should not have editconditions, because this breaks their usage in the editor

	/** Check if the target's hero has this Skill. If a hero is targeted, they check themselves, else, the creature will check its hero. If no hero is found [-> critter stack], this will always return false. */
	var() bool                          UseTHHasSkill                   <DisplayName=Target's Hero Has Skill>;
	var() EOperationBool                THSkillOp                       <DisplayName=|EditCondition=UseTHHasSkill>;
	var() ESkillType	                THHasSkill	                    <DisplayName=this|EditCondition=UseTHHasSkill>;

	/** Works only if target is a Town or a Building */
	var() bool                          CheckForBuilding                <DisplayName=Check for Building>;
	var() bool                          BuildingIsBuilt                 <DisplayName=Building is Built|EditCondition=CheckForBuilding>;
	var() H7TownBuilding                ThisBuilding                    <DisplayName=Building|EditCondition=CheckForBuilding>;

	/** Check if the target produces this resource */
	var() bool                          ProducesResources               <DisplayName=Produces Resources>;
	var() H7Resource                    Resource                        <DisplayName=Resource|EditCondition=ProducesResources>;

	/** Check if the target produces this unit */
	var() bool                          ProducesUnits                   <DisplayName=Produces Units>;
	var() H7Unit                        Unit                            <DisplayName=Unit|EditCondition=ProducesUnits>;

	/** Check if the target produces this tier */
	var() bool                          ProducesTier                    <DisplayName=Produces Creature Tier>;
	var() ECreatureTier                 Tier                            <DisplayName=Tier|EditCondition=ProducesTier>;

	/** Remove Caster/Owner from target list */
	var() bool	                        ExcludeOwner                    <DisplayName=Exclude Owner from targets>;

	/** Add dead targets to target list */
	var() bool	                        TargetDead                      <DisplayName=Can Target Dead>;

	/** Check if caster's position is adjacent to the target's position. (Buffs: Owner is the buffed unit, caster is the one that actually casted the buff.) */
	var() bool                          CasterMustBeAdjacent            <DisplayName=Can only be activated when Caster is adjacent to Target>;

	/** Check if owner's position is adjacent to the target's position. Buffs: Owner is the buffed unit, caster is the one that actually casted the buff.) */
	var() bool                          OwnerMustBeAdjacent             <DisplayName=Can only be activated when Owner is adjacent to Target>;

	/** Check if Target lost Health Points - current health points less then max health points*/
	var() bool                          HPTargetDamaged                 <DisplayName=Check if Target is damaged (HP < Max HP)>;
	var() bool                          HPCheckForPercentage            <DisplayName=Check if Target's HP is below/above/at a percentage of its maximum HP|EditCondition=HPTargetDamaged>;
	var() EOperationBool                HPPercentageOperator            <DisplayName=Percentage check operator|EditCondition=HPCheckForPercentage>;
	var() int                           HPDamagePercentage              <DisplayName=Percentage threshold|EditCondition=HPCheckForPercentage>;

	/** Academy magic synergy for faction skill*/
	var() bool                          MagicSynergy                    <DisplayName=Check if Target will trigger Magic Synergy>;

	/** Check if target has adjacent creatures stacks. */
	var() bool                          TargetHasAdjacentCreatures      <DisplayName=Target has Adjacent Creature Stacks>;

	/** Check if the target is a specific creature */
	var() bool                          UseCreatureTypes                <DisplayName=Check For Specific Creatures>;
	var() array<H7Creature>             CreatureTypes                   <DisplayName=Is>;

	var() bool                          UseTargetAreaUnoccupied         <DisplayName=Check If Targeted Area Is Unoccupied>;
	var() IntPoint                      TargetDimensions                <DisplayName=Dimensions>;
};

struct native H7ConditionStructExtendAttack // attack
{
	/** Check if the current attacker is (not) of a specific type (use "Equal" and "Not equal" only) */
	var() bool                          UseAttackerUnitType             <DisplayName=Check Attacker Unit Type>;
	var() EOperationBool                AUTOperation                    <DisplayName=|EditCondition=UseAttackerUnitType>;
	var() array<EUnitType>	            AUTUnitTypes                    <DisplayName=Is>;

	/** Check if the current attack matches this school (use "Equal" and "Not equal" only) */
	var() bool                          UseAttackType                   <DisplayName=Check Attack School>;
	var() EOperationBool                ATOperation                     <DisplayName=|EditCondition=UseAttackType>;
    var() EAbilitySchool                ATSpellSchool                   <DisplayName=Is|EditCondition=UseAttackType>;

	/** Check if attacker is (not) of this size (use "Equal" and "Not equal" only) */
	var() bool                          UseAttackerSize                 <DisplayName=Check Attacker Size>;
	var() bool                          UseDefenderInstead              <DisplayName=Check Defender Instead Of Attacker?>;
	var() EOperationBool                ASOperation                     <DisplayName|EditCondition=UseAttackerSize>;
	var() ECellSize	                    ASize                           <DisplayName=Is|EditCondition=UseAttackerSize>;

	/** Check if the current attack matches (use "Equal" and "Not equal" only) */
	var() bool                          UseFlankingType                 <DisplayName=Check Flanking Type>;
	var() EOperationBool                FlankingOperation               <DisplayName=|EditCondition=UseFlankingType>;
	var() EFlankingType                 FlankingType                    <DisplayName=|EditCondition=UseFlankingType>;

	/** Check if the current attack matches ALL of the tags listed (use "Equal" and "Not equal" only) */
	var() bool                          UseAttackTag                    <DisplayName=Check Attack Tags>;
	var() EOperationBool                AttackTagOperation              <DisplayName=|EditCondition=UseAttackTag>;
    var() array<ESpellTag>              ATAttackTag                     <DisplayName=Is>;

	/** Check if the current attack is from this type */
	var() bool                          UseAttackAction                 <DisplayName=Check Attack Action>;
	var() ECommandTag                   Action                          <DisplayName=Action|EditCondition=UseAttackAction>;

	/** Check if the current attack is (not) from the Owner/Caster of this ability */
	var() bool                          UseAttackInitiator              <DisplayName=Check Attack Initiator>;
	var() bool                          InitiatorIsSelf                 <DisplayName=Triggered by Initiator|EditCondition=UseAttackInitiator|Tooltip=Check if Initiator (Caster in most cases) of this Ability/Buff/Skill/general Effect Container is also the Initiator of the Command>;

	/** Check if the current attack is (not) from the Owner of this buff */
	var() bool                          UseAttackInitiatorBuff	        <DisplayName=Check Attack Initiator (for Effects from Buffs)>;
	var() bool                          InitiatorIsBuffOwner	        <DisplayName=Triggered by Buff Owner|EditCondition=UseAttackInitiatorBuff|Tooltip=Check Owner of Buff instead of Initiator (in case of Buffs casted by Heroes on Creatures, the Initiator is the Hero while the Creature is the Owner)>;

	/** Check if the target is (not) of this allegiance (use "Equal" and "Not equal" only) */
	var() bool                          UseAttackerAlignment            <DisplayName=Check Attacker Allegiance>;
	var() EOperationBool                UAOperation                     <DisplayName=|EditCondition=UseAttackerAlignment>;
	var() EAlignmentType                UAAlignment                     <DisplayName=Is|EditCondition=UseAttackerAlignment>;

	/** Check if the target is (not) of this allegiance (use "Equal" and "Not equal" only) */
	var() bool                          UseDefenderAlignment            <DisplayName=Check Defender Allegiance>;
	var() EOperationBool                UDOperation                     <DisplayName=|EditCondition=UseDefenderAlignment>;
	var() EAlignmentType                UDAlignment                     <DisplayName=Is|EditCondition=UseDefenderAlignment>;

	/** Check if any defender would (not) retaliate when it is attacked */
	var() bool                          UseRetaliation                  <DisplayName=Check Retaliation>;
	var() bool                          WillRetaliate                   <DisplayName=Will trigger Retaliation|EditCondition=UseRetaliation>;

	/** Check if attacker/defender has one or more or none of these buffs (use "Equal" and "Not equal" only) */
	var() bool                          UnitHasBuffs                    <DisplayName=Check Buffs>;
	var() EOperationBool                BuffsOp                         <DisplayName=|EditCondition=UnitHasBuffs>;
	var() array<H7BaseBuff>	            CTBuffs	                        <DisplayName=these>;
	
	/** Check if the attacker/defender has at least one or none of the listed abilities (use "Equal" and "Not equal" only) */
	var() bool                          UseHasAbilities                 <DisplayName=Unit has Abilities>;
	var() EOperationBool                AbilitiesOp                     <DisplayName=|EditCondition=UseHasAbilities>;
	var() EOperationLogic               AbilitiesLogic                  <DisplayName=Logical operation apply to all abilities>;
	var() array<H7BaseAbility>          HasAbilities                    <DisplayName=this>; //arrays should not have editconditions, because this breaks their usage in the editor
};

struct native H7CasterConditionStruct // caster|owner = initiator
{
	/** Check if Caster is (not) of this type (use "Equal" and "Not equal" only) */
	var() bool                          UseUnitType                     <DisplayName=Check Caster Type>;
	var() EOperationBool                UOperation                      <DisplayName=|EditCondition=UseUnitType>;
	var() EUnitType                     UnitType                        <DisplayName=Is|EditCondition=UseUnitType>;

	/** Check if Caster has (not) this ability (use "Equal" and "Not equal" only) */
	var() bool                          UseHasAbility                   <DisplayName=Unit has Ability>;
	var() EOperationBool                AbilityOp                       <DisplayName=|EditCondition=UseHasAbility>;
	var() H7BaseAbility                 HasAbility                      <DisplayName=this|EditCondition=UseHasAbility>;

	/** Check if Caster has (not) this buff (use "Equal" and "Not equal" only) */
	var() bool                          UseHasBuff                      <DisplayName=Unit has Buff>;
	var() EOperationBool                BuffOp                          <DisplayName=|EditCondition=UseHasBuff>;
	var() H7BaseBuff                    HasBuff                         <DisplayName=this|EditCondition=UseHasBuff>;
	var() bool                          UseOwner	                    <DisplayName=Check Owner of this Effect, not Caster|EditCondition=UseHasBuff>;

	/** Check if Caster has one or more or none of these buffs (use "Equal" and "Not equal" only) */
	var() bool                          UseHasBuffs                      <DisplayName=Unit has Buffs>;
	var() EOperationBool                BuffsOp                          <DisplayName=|EditCondition=UseHasBuffs>;
	var() array<H7BaseBuff>             HasBuffs                         <DisplayName=these>;
	var() bool                          UseBuffsOwner	                 <DisplayName=Check Owner of this Effect, not Caster|EditCondition=UseHasBuffs>;

	/** Check if Caster has kill counter in the specified state (operator type "special case" is not implemented for this case) */
	var() bool                          UseHasKill                      <DisplayName=Check Amount Of Kills On Current Turn>;
	var() EOperationBool                KillOp                          <DisplayName=|EditCondition=UseHasKill>;
	var() int                           Kills                           <DisplayName=this|EditCondition=UseHasKill>;

	/** Allow casting by dead creatures */
	var() bool                          UseWhenDead                     <DisplayName=Ability can be used when caster is dead>;
	
	/** Casters Hero has Ability X */
	var() bool                          UseCHHasAbility                 <DisplayName=Caster s Hero has Ability>;
	var() EOperationBool                CHAbilityOp                     <DisplayName=|EditCondition=UseCHHasAbility>;
	var() H7BaseAbility                 HasCHAbilty                     <DisplayName=this|EditCondition=UseCHHasAbility>;

	var() bool                          UseCanSummonShip                <DisplayName=Check if caster can currently summon a ship>;

	var() bool                          UseCheckCasterIsDead            <DisplayName=Check if caster is dead>;
	var() bool                          ShouldCasterBeDead              <DisplayName=Should caster be dead?|EditCondition=UseCheckCasterIsDead>;

	var() bool                          UseCheckCasterMoved             <DisplayName=Check if caster moved>;
	var() bool                          ShouldCasterHaveMoved           <DisplayName=Should caster have moved?|EditCondition=UseCheckCasterIsDead>;
	
	/** Check if Caster has specific ability prepared */
	var() bool                          UseCheckPreparedAbility         <DisplayName=Check Caster Prepared Ability>;
	var() EOperationBool                UPAOperation					<DisplayName=|EditCondition=UseCheckPreparedAbility>;
	var() array<H7BaseAbility>          UPAAbilities					<DisplayName=Is One Of>;

	/** Check if Caster has specific ability prepared */
	var() bool                          UseCheckPreparedAbilitySchool   <DisplayName=Check Caster Prepared Ability School>;
	var() EOperationBool                UPASOperation					<DisplayName=|EditCondition=UseCheckPreparedAbilitySchool>;
	var() array<EAbilitySchool>         UPASSchools					    <DisplayName=Is One Of>;

	/** Check if the current attack matches ALL of the tags listed (use "Equal" and "Not equal" only) */
	var() bool                          UsePreparedAbilityTags	        <DisplayName=Check Prepared Ability Tags>;
	var() EOperationBool                PATagOperation                  <DisplayName=|EditCondition=UsePreparedAbilityTags>;
    var() array<ESpellTag>              PAAttackTags	                <DisplayName=Is>;

	/**Check if there is a owned town with a town portal ready */
	var() bool                          UseCheckTownPortalReady         <DisplayName=Check Own Towns TownPortal Ready>;
	
};


struct native H7ConditionStruct
{
	var() H7CasterConditionStruct           mExtededAbilityParameters     <DisplayName=Caster Conditions|EditCondition=mConditionAbility>;
	var() H7ConditionStructExtendedTarget   mExtendedTargetParameters     <DisplayName=Target Conditions|EditCondition=mConditionTarget>;
	var() H7ConditionStructExtendAttack     mExtendedAttackParameters     <DisplayName=Attack Conditions|EditCondition=mConditionAttack>;

	var bool                                mConditionTarget;
	var bool                                mConditionAttack;
	var bool                                mConditionAbility; // caster condition
};



struct native H7FXStruct
{
	var() bool                          mSkipQueue                      <DisplayName=Skip Queue>;
	var() ParticleSystem                mVFX                            <DisplayName=Particle Effect>;
	var() AkEvent                       mSFX                            <DisplayName=Sound Effect AkEvent>;
	/**Used for looping sounds. They are stopped when the particle is destroyed by the effect manager*/
	var() AkEvent                       mStopSFX                        <DisplayName=Stop AkEvent>;

	var() float                         mBaseScale                      <DisplayName=Effect Scale>;
	var() bool                          mScaleWithTarget                <DisplayName=Scale Effect with Target>;

	var() EFXPosition                   mFXPosition                     <DisplayName=Effect Position>;
	var() bool                          mUseCasterPosition              <DisplayName=Override to Caster Position>;
	var() String                        mSocketName                     <DisplayName=SocketName>;

	var() bool                          mNoDuplicateVFX                 <DisplayName=No duplicate VFX>;
	var() bool                          mIsPermanentFX                  <DisplayName=FX is permanent>;

	var() ECreatureAnimation            mFXAnimations                   <DisplayName=Animations>;

	var() bool                          mChangeAnimSpeed                <DisplayName=Change Animation Speed>;
	var() float                         mAnimationSpeed                 <DisplayName=Animation Speed>;
	
	var() bool                          mSunburstTileFX	                <DisplayName=Use For 8 directional expasion effect>;

	var H7Effect                        mSource;
	var float                           mScale;
	
	var bool                            isBeam;
	var Vector                          source;
	var vector                          target;
	var Rotator                         rotation;

	var ()array<H7MaterialEffect>       mMaterialFX                     <DisplayName=Material FX>;


	structdefaultproperties
	{
		mBaseScale=1.000f
		mFXAnimations = CAN_NONE
		mIsPermanentFX = false
	}
};

// !!! everything added needs to be updated for all effects in InitSpecific because it is all data copy !!!
struct native H7EffectProperties
{
	var() string                        mEffectID                       <DisplayName="Unique ID">;
	var() int                           mGroup                          <DisplayName="Group">;
	var() ESkillRank                    mRank                           <DisplayName="Required Skill Rank">;
	var() array<ESpellTag>              mTags                           <DisplayName="Tags To Use For This Effect">;
	var() EEffectTarget                 mTarget                         <DisplayName="Target">;
	var() H7TriggerStruct               mTrigger                        <DisplayName="Activation">;
	var() H7ConditionStruct             mConditions                     <DisplayName="Condition To Be Activated">;
	var() H7FXStruct                    mFX                             <DisplayName="Sounds and Visuals">;
	var() bool                          mDontShowInTooltip              <DisplayName="Do not show in Tooltip">;
};


// 5 effects: stat , res , damage , spells|buffs|abilities , special
struct native H7StatEffect extends H7EffectProperties
{
	var() H7MeModifiesStat              mStatMod                        <DisplayName=Stat Modifier>;	
	var() bool                          mUseAmount                      <DisplayName=Amount Value|Tooltip="For Special Activation Trigger">;
};

struct native H7SpellEffect extends H7EffectProperties
{
	var() H7SpellStruct                 mSpellStruct                    <DisplayName=Spell/Buff/Ability>;
};

struct native H7ResistanceEffect extends H7EffectProperties
{
	var() H7ResistanceStruct            mResistance                     <DisplayName=Resistance>;
};


struct native H7DamageEffect extends H7EffectProperties
{
	var() H7RangeValue                  mDamage                         <DisplayName=Damage Values|EditCondition=!mUseSpellScaling>;
	var() bool                          mUseDefaultDamage               <DisplayName=Use Creature/Hero Default Damage Value|EditCondition=!mUseSpellScaling>;
	var() bool                          mUseRandomSchool                <DisplayName=Use Random Magic School for damage>;
	var() bool                          mUseMagicAbs                    <DisplayName=Use Magic Absorption>;
	var() bool                          mUseDefaultSchool               <DisplayName=Use Creature/Hero School>;                
	var() bool                          mUseAttackPower                 <DisplayName=Increase by Caster Attack Points|EditCondition=!mUseSpellScaling>;
	var() bool                          mUseDefensePower                <DisplayName=Decrease by Target Defense Points|EditCondition=!mUseSpellScaling>;
	var() bool                          mUseResist                      <DisplayName=Defender Can Resist>;
	var() bool                          mIgnoreCover                    <DisplayName=Ignore cover bonus>;
	var() bool                          mUseStackSize                   <DisplayName=Calculation with Creature Stack Size|EditCondition=!mUseSpellScaling|Tooltip=Damage Calculation Use Stack Size>;
	var() bool                          mMultiplyByMetamagic            <DisplayName=Multiply By Metamagic|EditCondition=!mUseSpellScaling|Tooltip=Damage Calculation Multiply By Metamagic>;
	var() bool                          mUseStackSizeTarget             <DisplayName=Calculation with Creature Stack Size of Target|EditCondition=mUseStackSize|Tooltip=Damage Calculation Use Stack Size>;
	var() bool                          mUsePathLength                  <DisplayName=Use Path Length to Calculate Damage|Tooltip=Use Path Length to Calculate Damage>;
	var() int                           mMightBonusPerPathStep          <DisplayName=Attack Bonus Per Path Step|Tooltip=Use Attack Bonus Per Path Step>;
	var() bool                          mUseSpellScaling                <DisplayName=Use Spell Scaling>;
	var() H7SpellScaling                mMinDamage                      <DisplayName=Minimum Damage|EditCondition=mUseSpellScaling>;
	var() H7SpellScaling                mMaxDamage                      <DisplayName=Maximum Damage|EditCondition=mUseSpellScaling>;
	var() array<float>                  mDistanceDamageReduction        <DisplayName=% Damage Reduction per Tile (applies Ability Target Cone)(ex.: 10% reduction = 0.9, 80% reduction = 0.2)|Tooltip=First value applied to creatures immediately in front of the attacker, the second one to targets one tile away, and so forth>;
	var() bool                          mUsePercentStackDamage          <DisplayName=Use Stack Damage>;
	var() float                         mPercentStackDamage             <DisplayName=x% of Stack as Damage>;
	var() float                         mAddPercentStackDamage          <DisplayName=add x% to Stack Damage|EditCondition=mPercentUseCasterSpellPower>;
	var() float                         mPercentStackDamageCap          <DisplayName=% Damage Cap X |EditCondition=mPercentUseCasterSpellPower>;
	var() bool                          mPercentUseCasterSpellPower     <DisplayName=Scale with Magic Stat|EditCondition=mUsePercentStackDamage>;

	structdefaultproperties
	{
		mPercentStackDamageCap = 1.0f;
	}
};

struct native H7AudioVisualEffect extends H7EffectProperties
{
};

struct native H7SpecialEffect extends H7EffectProperties
{
	var() H7IEffectDelegate             mFunctionProvider               <DisplayName=Special Code Archetype>;
	var() bool                          mDoesDamage                     <DisplayName=Special Code Does Damage>;
	var() bool                          mUseResist                      <DisplayName=Defender Can Resist (Damage)>;                  
};

struct native H7DurationEffect extends H7EffectProperties
{
	var() H7RangeValue                  mDuration                       <DisplayName=Duration>;
	var() bool                          mUseSpellScaling                <DisplayName=Use Spell Scaling>;
	var() H7SpellScaling                mDurationScaling                <DisplayName=DurationScaling|EditCondition=mUseSpellScaling>;
};

struct native H7ChargeEffect extends H7EffectProperties
{
	// Set the Basic Chargevalue ( Zero means not used )
	var() int                           mChargeCounter                  <DisplayName=Charge Counter>;
	// only SET is Implemented
	var() EOperationType                mOp                             <Displayname=Operation>;
};

struct native H7DurationModifierEffect extends H7EffectProperties
{
	/** Modify duration in this way (operator type "special case" is not implemented for duration modifiers) */
	var() EOperationType                mCombineOperation               <DisplayName=Operation>;
	var() int                           mModifierValue                  <DisplayName=Value>;
};

// DISCUSS: the target should always be the recipient of the command, and mCommandRecipient should be changed to mCommandTarget
// i.e. Command [Crossbowman,RangeAttack,Celestial] = [target,command,commandtarget]
// otherwise every code need to treat mTarget differently depending on if it is commandeffect or othereffect
struct native H7CommandEffect extends H7EffectProperties
{
	var() ECommandTag                       mCommandTag                     <DisplayName=Action to Add>;
	var() bool                              mInsertHead                     <DisplayName=Insert to 1st Pos>;
	var() int                               mAmount                         <DisplayName=Amount of Actions|ClampMin=1>;
	/** will be used if "ACTION_ABILITY" is selected */
	var() H7BaseAbility                     mAbility                        <DisplayName=Ability to use>;
	var() EEffectTarget                     mCommandRecipient               <DisplayName=Recipient of Command>; 
	var() H7ConditionStructExtendedTarget   mRecipientConditions            <DisplayName=Recipient Conditions>;
	/** If set, the ability that is executed will ignore its targets allegiance ("friendly fire" possible). */
	var() bool                              mIgnoreAllegiance               <DisplayName=Ignore Target Allegiances for Command>;
	
	structdefaultproperties
	{
		mAmount = 1
	}
};

struct native H7EventContainerStruct
{
	var() H7IEffectTargetable           Targetable;
	var() array<H7IEffectTargetable>    TargetableTargets;
	var() array<ESpellTag>              ActionTag;
	var() EAbilitySchool                ActionSchool;
	var() H7EffectContainer             EffectContainer;
	var   ECommandTag                   Action;
	var array<H7BaseCell>               Path;
	var H7CombatResult                  Result;
	var int                             Amount;
	
	structdefaultproperties
	{
		Amount = 1
	}
};

//from H7UnitCommand
enum EUnitCommand
{
	UC_MOVE         <DisplayName=Move>, // fly and teleport included
	UC_ABILITY      <DisplayName=Ability>,
	//adventure map commands
	UC_VISIT        <DisplayName=Visit>,
	UC_RECRUIT      <DisplayName=Recruit>,
	UC_MEET         <DisplayName=Meet>,
	UC_INTERRUPT    <DisplayName=Interrupt>,
	UC_GARRISON     <DisplayName=Garrison>,
	UC_SKIP_TURN    <DisplayName=Skip Turn>,
	UC_UPGRADE      <DisplayName=Upgrade>,
};

enum ESpeaker
{
	SPEAKER_CUSTOM      <DisplayName="Speaker (below) or Narrator (above)">,
	SPEAKER_IVAN        <DisplayName="Ivan">,
	SPEAKER_HAVEN       <DisplayName="Murazel">,
	SPEAKER_NECRO       <DisplayName="Anastasia">,
	SPEAKER_ACADEMY     <DisplayName="Tanis">,
	SPEAKER_STRONGHOLD  <DisplayName="Kente">,
	SPEAKER_ELVES       <DisplayName="Lasir">,
	SPEAKER_DUNGEON     <DisplayName="Jorgen">,
};

enum EDialogueType
{
	DT_NARRATION        <DisplayName=NAR - Narration>,
	DT_DIALOG           <DisplayName=HDG - Hero Dialogue>,
	DT_COUNCIL_DIALOG   <DisplayName=CIN - Council Intervention>,
	DT_SUBTITLE         <DisplayName=NAR_SUB - Narration Subtitle>,
};

enum EDispositionType
{
	DIT_NEGOTIATE       <DisplayName=Negotiate (use GameMechanics)>,
	DIT_JOIN_PRICE      <DisplayName=Offer to Join for a Price>,
	DIT_JOIN_FREE       <DisplayName=Offer to Join for Free>,
	DIT_ALWAYS_FIGHT    <DisplayName=Fight>,
	DIT_FORCE_JOIN      <DisplayName=Force to Join for Free>,
	DIT_FLEE            <DisplayName=Flee>,
};

enum EAPRLevel
{
	APR_NONE,
	APR_TRIVIAL,
	APR_LOW,
	APR_MODEST,
	APR_AVERAGE,
	APR_SEVERE,
	APR_HIGH,
	APR_DEADLY,
};

enum EConeType
{
	CONE_BOTH,
	CONE_LEFT,
	CONE_RIGHT,
};

//from H7Camera
enum ECameraMode
{
	CAM_COMBAT,
	CAM_COMBAT_DEPLOYMENT,
	CAM_COMBAT_START,
	CAM_ADVENTURE,
	CAM_TOWN,
	CAM_COUNCIL,
	CAM_COUNCIL_MAP
};

// TODO : Check what is still needed here 
//from H7CombatResult 
// - these are all percentages %
// - that influence an attack and appear as list in the tooltip
// - which ones are used depends on the type of the attack
enum H7MultiplierType
{
	MT_RES_VUL_IMM,         // unused
	MT_RESIST,              // 50%
	MT_VUL,                 // 125%
	MT_IMMUNE,              // 0%
	MT_ATT_DEF_POINT_DIFF,  // 70%-300% relative power
	MT_SHIELDED,            // defend - 50% getting shielded
	MT_MORAL,               // attack - 50% during moral turn
	MT_MELEE,               // attack - 50% range-creature melee
	MT_RANGE,               // attack range - 50% outside half-range
	MT_COVER,               // defend range - 50%
	MT_SHIELDER,            // defend - 25% doing shielding
	MT_FLANK_FULL,          // attack - 125%
	MT_FLANK_HALF,          // attack - 150%
	MT_DISTANCE_MOD,        // cone damage distance modifier
	MT_CHAIN,               // ChainLightning reduction
	MT_COLLAPSE,            // multiplier from ability "Collapse"

	// not used atm:
	MT_GENERAL_ATTACK,
	MT_GENERAL_DEFENSE

	// hopefully not needed:
	//MT_GENERAL_ATTACK_POWER, // i.e. half attackers attack power 
	//MT_GENERAL_DEFEND_POWER // i.e. half defenders defend power 
	
};

// Used in H7HeroItem and the Artifact Editor. Let Sir Christian know about any changes
enum EItemType
{
	ITYPE_HELMET        <DisplayName=Head>,
	ITYPE_WEAPON        <DisplayName=Main Hand>,
	ITYPE_CHEST_ARMOR   <DisplayName=Torso>,
	ITYPE_GLOVES        <DisplayName=Off-Hand>,
	ITYPE_SHOES         <DisplayName=Feet>,
	ITYPE_NECKLACE      <DisplayName=Neck>,
	ITYPE_RING          <DisplayName=Finger>,
	ITYPE_CAPE          <DisplayName=Shoulders>,
	ITYPE_SCROLL        <DisplayName=Scroll>,
	ITYPE_CONSUMABLE    <DisplayName=Consumable>,
	ITYPE_INVENTORY_ONLY<DisplayName=Inventory Only>,
	ITYPE_ALL           <DisplayName=All>,
};


enum ECartographerType
{
	CARTYPE_LAND        <DisplayName=Land>,
	CARTYPE_SEA         <DisplayName=Sea>,
};


// Used in H7HeroItem and the Artifact Editor. Let Sir Christian know about any changes
enum ETier
{
	ITIER_MINOR         <DisplayName=Minor>,
	ITIER_MAJOR         <DisplayName=Major>,
	ITIER_RELIC         <DisplayName=Relic>,
	ITIER_CONSUMABLE    <DisplayName=Consumable>,
	ITIER_MINOR_MAJOR   <DisplayName=Minor or Major>,
	ITIER_ALL           <DisplayName=All>,
};

enum EAttackRange
{
	CATTACKRANGE_ZERO   <DisplayName=None (0%)>,
	CATTACKRANGE_HALF   <DisplayName=Half Range (50%)>,
	CATTACKRANGE_FULL   <DisplayName=Full Range (100%)>
};

enum EQuickCombatSubstitute
{
	QC_HITPOINTS        <DisplayName=Hitpoints>,
	QC_DEFENSE          <DisplayName=Defense>,
	QC_ATTACK           <DisplayName=Attack>,
	QC_INITIATIVE       <DisplayName=Initiative>,
	QC_MORALE           <DisplayName=Morale>,
	QC_LUCK             <DisplayName=Luck>,
	QC_DAMAGE           <DisplayName=Damage>,
	QC_MAGIC            <DisplayName=Magic>,
};

struct native H7ClassSkillData
{
	var() ESkillTier Tier<DisplayName="Skill Tier">;
	var() H7Skill   Skill<DisplayName="Skill">;  
};


struct native H7AuraStructProperties
{
	var   int                               mCurrentDuration;
	var() array<H7EffectProperties>         mInitAuraEffects	            <DisplayName=Aura Initialization Effect>;
	var() array<H7EffectProperties>         mDestroyAuraEffects	            <DisplayName=Aura Destroy Effect>;
	var() array<H7DurationEffect>           mDuration                       <DisplayName=Aura Duration>;
	var() array<H7DurationModifierEffect>   mDurationModifier	            <DisplayName=Aura Duration-Modifier>;
	//var() string                            mAuraTooltip	                <DisplayName=Aura Tooltip (visible while hovering over cells)|Tooltip=Works Only for Active Hero Abilities That Apply an Aura to Cells>;
	var() bool                              mUpdateOnStep	                <DisplayName=Should Aura Update On Every Cell Enter (TRUE) Or Only The Destination When Moving (FALSE)>;
	var() bool                              mForceReapply                   <DisplayName=Force Aura Re-Apply (throw event "Aura: On Apply Aura" even if the affected cells didnt change)>;
	var() bool                              mIgnoreBlocked                  <DisplayName=Ignore Blocked Tiles|Tooltip=Aura ignores blocked Tiles (used for Teleport so that its range does not change)>;
};

struct native H7AuraStruct
{
	var() H7AuraStructProperties            mAuraProperties               <DisplayName=Is Aura|EditCondition=mIsAura>;

	var bool                                mIsAura;
};

struct native H7ConeStruct 
{
	var() float                             mAngle                       <DisplayName=Cone Angle>;
	var() int                               mRange                       <DisplayName=Cone Length>;
	var() StaticMeshComponent               mPreview                     <DisplayName=Cone Preview Plane>;
	var() bool                              mDebug                       <DisplayName=DebugModus>;

	structdefaultproperties
	{
		mAngle=45.0f;
		mRange=1;
		mDebug=false;
	}
};

struct native H7AuraInstance
{
	var H7BaseAbility               mAuraAbility;
	var array<IntPoint>             mAffectedCells;
	var array<H7IEffectTargetable>  mAffectedTargets;
};

struct native H7ResourceProbability
{
	var() H7ResourceQuantity   mResource;
	var() int                  mProbability     <DisplayName=Weight|ClampMin=0>;
};

//from H7CombatMapPathfinder

struct native H7CellPathData
{
	// distance to the creature
	var float mPathfinderDistance;
	// cell that leads to the creature
	var H7CombatMapCell mPathfinderPrevious;
};

struct native H7PathfinerGridColumns
{
  var array< H7CellPathData > Row;
};

struct native H7SimDuration
{
	var H7Effect effect;
	var int newDuration;
};

struct native H7TooltipMultiplier
{
	var H7MultiplierType type;
	var String      name;
	var float       value;
};

struct native CRData
{
	// output damage & range
	var float					mDamageLow;
	var float					mDamageHigh;
	var int						mDamage;
	var float					mDamageModifier;

	// output kills & range
	var int						mKillsLow;
	var int						mKillsHigh;
	var int						mKills;

	var int						mAttackPower;
	var int						mDefensePower;

	var bool					mIsCovered;
	var bool                    mMissed;
	var bool                    mTriggerEvents;
	var EAbilitySchool          mSchoolType;

	var bool                    mConstDamageRange;

	// for tooltip/simulate
	var array<H7TooltipMultiplier>     mMultipliers;
	var array<H7Effect>                mEffects; // effects from the spell that hit the defender
	var array<H7Effect>                mTriggeredEffects; // effects that are triggered by chainreactions on the defender
	
	structdefaultproperties
	{
		mTriggerEvents = true
		mMissed = false;
	}
};

// UseWallLevel: the object level to be selected will depend of the wall building level (true) or the town building level (false)
// MeshLevel4: only used when UseWallLevel=false
struct native H7EditorSiegeDecoration 
{
	var() bool					UseWallLevel;
	var() H7SiegeMapDecoration	MeshLevel1;
	var() H7SiegeMapDecoration	MeshLevel2;
	var() H7SiegeMapDecoration	MeshLevel3;
	var() H7SiegeMapDecoration	MeshLevel4;
};

// siege town data
struct native H7SiegeTownData 
{
	var() H7Faction                         Faction;
	var() bool		                        HasShootingTowers;
	var() bool		                        HasMoats;
	var() int		                        WallAndGateLevel        <DisplayName=Wall and Gate level|ClampMin=0|ClampMax=3>;
	var() int		                        TownLevel               <DisplayName=Town Level|ClampMin=0|ClampMax=4>;
	var() H7CombatMapTower					SiegeObstacleTower<DisplayName=Siege obstacle Tower>;
	var() H7CombatMapWall					SiegeObstacleWall<DisplayName=Siege obstacle Wall>;
	var() H7CombatMapMoat					SiegeObstacleMoat<DisplayName=Siege obstacle Moat>;
	var() H7CombatMapGate					SiegeObstacleGate<DisplayName=Siege obstacle Gate>;
	var() array<H7EditorSiegeDecoration>	SiegeDecorationList<DisplayName=List of Siege Decorations>;
};

struct native H7SetBonus
{
	var() int NumberOfItems;
	var() array<H7MeModifiesStat> SetBonusStat;
	var() H7HeroAbility SetBonusAbility;
	// TODO +30 FireDamage: // will be in array<H7MeModifiesStat>
};

struct native H7UnitCounter
{
	var int counter;
	var H7Unit unit;
};

struct native H7CreatureCounter
{
	var() savegame int Counter<DisplayName="Amount"|ClampMin=0>;
	var() savegame archetype H7Creature Creature<DisplayName="Creature">;
	var savegame EPlayerNumber PlayerID;
	var savegame EPlayerNumber EnemyID;
};

struct native H7StackStrengthParams
{
	var savegame int StackSize;
	var savegame float CreaturePower;
	var savegame bool IsUpgrade;
	var savegame H7Faction Faction;
};

struct native H7ArmyStrengthParams
{
	var savegame int HeroLevel;
	var savegame H7Faction HeroFaction;
	var savegame EPlayerNumber PlayerID;
	var savegame array<H7StackStrengthParams> StackStrengths;
};

struct native H7AffectedPlayers
{
	var() bool Player1<DisplayName="Player 1">;
	var() bool Player2<DisplayName="Player 2">;
	var() bool Player3<DisplayName="Player 3">;
	var() bool Player4<DisplayName="Player 4">;
	var() bool Player5<DisplayName="Player 5">;
	var() bool Player6<DisplayName="Player 6">;
	var() bool Player7<DisplayName="Player 7">;
	var() bool Player8<DisplayName="Player 8">;

};

struct native SpellListData
{
	var() string name<DisplayName=Spell Name>;
	var() string ref<DisplayName=ArchetypeRef>;
};

struct native SkillListData
{
	var() string name<DisplayName=Skill Name>;
	var() string ref<DisplayName=ArchetypeRef>;
};

struct native H7TargetableArray
{
	var array<H7IEffectTargetable> targets;
};

struct native H7ChainEffectPair
{
	var H7CreatureStack A;
	var H7CreatureStack B;
	var int Distance;
};

struct native MapInfoArtifactMapData
{
	var() archetype H7HeroItem    mHeroItem <DisplayName = Hero Item>;
	var() bool                    mIsEnabled <DisplayName = Enable>;
};

struct native NegotiationData
{
	var() savegame H7AdventureArmy Army;
	var() savegame int NegotiationResult;
};

struct native H7ConditionProgress
{
	var float CurrentProgress;
	var float MaximumProgress;
	var string ProgressText;
};

struct native H7ArtifactCollection
{
	var() array<H7HeroItem> Artifacts;
};

struct native H7QuickCombatStack
{
	var EQuickCombatStackType StackType;
	
	var bool                HybridSupportDone;
	var H7EditorWarUnit     BaseWarUnit;
	var H7BaseCreatureStack BaseStack;
	var int                 StackSize;
	var int					HitPoints;
	var int					HitPointsSingle;
	var int					Initiative;
	var int					DamageMin;
	var int					DamageMax;
	var int					Attack;
	var int					Defense;
	var EAttackRange        Range;
	var int					Luck;
	var int					Morale;
	var int					Movement;
	var int					MovedTiles;
	var EMovementType		MovementType;

	var bool				HasMeleePenalty;
	var bool				IsMoraleTurn;
	var bool				IsAllowedToMorale;
	var bool				CanMorale;
	var bool				CanRetaliate;
	var bool				IsDead;
	var bool                IsAttacker;
	var bool                HitByMelee;
};

struct native H7QuickCombatHero
{
	var bool                IsHero;

	var int					DamageMin;
	var int					DamageMax;
	var int					Attack;
	var int					Defense;
	var int					Luck;
	var int					Morale;
	var int                 Mana;
	var bool                MadeTurn;
	var bool                AllowedToCast;
	var bool                HasWarcry;
	var int                 WarcryRank;
	var int                 WarfareRank;
	var int                 AmountOfWarcries;

	var bool                HasWarlord;
	var bool                HasArtilleryBarrage;
	var bool                HasPerfectWarfare;
	var bool                HasSiegeWarfare;

	var array<H7HeroAbility>    Spells;
	var array<float>            SpellValues;
	var float                   SumSpellValue;
	var H7EditorHero            Hero;
};


struct native QuickCombatImpact
{
	var() EQuickCombatSubstitute    Substitute;
	var() int                       Intensity;
	var() bool                      IsUpgraded;
	var() bool                      IsNegative;

	structdefaultproperties
	{
		Substitute=QC_ATTACK
		Intensity=1
	}
};

struct native MapSizeDefinition
{
	var EH7MapSize MapSize;
	var int Width;
	var int Height;
};

struct native H7BattleSiteArmySetupData
{
	/** The type of dwelling creature */
	var() archetype H7Creature Creature         <DisplayName="Creature Type">;
	/** The weekly growth of this creature */
	var() int Income                            <DisplayName="Weekly Growth"|ClampMin=1>;
	/** The current reserve */
	var() int Reserve                           <DisplayName="Current Amount"|ClampMin=0>;
	/** The maximum reserve. Set 0 to enable unlimited growing*/
	var() int Capacity                          <DisplayName="Maximum Amount"|ClampMin=0>;
	/** The position on the combat grid (X|Y) of the stack */
	var() Vector2D Position                     <DisplayName="Init Position of the stack">;
};

struct native H7MultiArmySetupData
{
	var() array<H7BattleSiteArmySetupData> FactionArmy  <DisplayName="ArmySetup">;
};

struct native H7CustomResource
{
	var() H7Resource Type<DisplayName="Type">;
	var() int Amount<DisplayName="Amount"|ClampMin=0>;
};

// used in map editor to set default, and also in map setup screen to set/overwride it
struct native MapInfoPlayerProperty
{
	var() EPlayerSlot           mSlot<DisplayName="Slot">; // SlotState ALL Possibilities
	var() string	            mName<DisplayName="Custom Name">;
	var() bool	                mUseCustomName<DisplayName="Use Custom Name">;
	var() H7GlobalName          mGlobalName<DisplayName="Global Name">;
	var() EHeroAiControlType    mAIType<DisplayName="AI Type">;
	var() EAIDifficulty         mAIDifficulty<DisplayName="AI Difficulty">; // TODO
	var() bool                  mInitActive<DisplayName="Initially active">;
	var() ETeamNumber           mTeam<DisplayName="Team">;
	var() H7EditorHero          mStartHero<DisplayName="Start Hero">;
	var() int                   mMaxLevel<DisplayName="Max Level">;
	var() EPlayerColor          mColor<DisplayName="Color">;
	var() bool                  mDiscoveredFromStart<DisplayName="Discovered from start">;

	var() bool mUseCustomStartingResource<DisplayName="Use Custom Starting Resource">;
	var() H7CustomResource mCustomStartingGold<DisplayName="Custom Starting Gold">;
	var() H7CustomResource mCustomStartingWood<DisplayName="Custom Starting Wood">;
	var() H7CustomResource mCustomStartingOre<DisplayName="Custom Starting Ore">;
	var() H7CustomResource mCustomStartingDragonSteel<DisplayName="Custom Starting Dragonsteel">;
	var() H7CustomResource mCustomStartingShadowSteel<DisplayName="Custom Starting Shadowsteel">;
	var() H7CustomResource mCustomStartingStarSilver<DisplayName="Custom Starting Starsilver">;
	var() H7CustomResource mCustomStartingDragonBloodCrystal<DisplayName="Custom Starting Dragonblood Crystal">;

	var() array<H7Faction> mForbiddenFactions<DisplayName="Forbidden Factions">;

	var() array<H7EditorHero> mForbiddenHeroes<DisplayName="Forbidden Heroes">;

	var() editconst bool mPlayerStartAvailable<DisplayName="PlayerStart Available">;

	// This faction will be used as player faction when not starting the map via game lobby.
	var() H7Faction mEditorFaction<DisplayName="Editor Faction">;

	structdefaultproperties
	{
		mTeam = TN_NO_TEAM
		mInitActive = TRUE
		mMaxLevel = 999
		mDiscoveredFromStart = TRUE;
		mUseCustomStartingResource = FALSE
		mAIDifficulty = AI_DIFFICULTY_NORMAL
		// TODO implement in game
		mCustomStartingGold = (Amount=1000)
		mCustomStartingWood = (Amount=30)
		mCustomStartingOre = (Amount=30)
		mCustomStartingDragonSteel = (Amount=10)
		mCustomStartingShadowSteel = (Amount=10)
		mCustomStartingStarSilver = (Amount=10)
		mCustomStartingDragonBloodCrystal = (Amount=10)

		mPlayerStartAvailable = FALSE

		mUseCustomName = FALSE
	}
};

enum EGameSpeed
{
	GS_NORMAL, // 1
	GS_FAST, // 1.5
	GS_VERY_FAST // 2.0 TODO
};

enum ETimerAdv
{
	TIMER_ADV_NONE,
	TIMER_ADV_2_MINUTES,
	TIMER_ADV_3_MINUTES,
	TIMER_ADV_5_MINUTES,
	TIMER_ADV_10_MINUTES,
	TIMER_ADV_15_MINUTES,
};

enum ETimerCombat
{
	TIMER_COMBAT_NONE,
	TIMER_COMBAT_10_SECONDS,
	TIMER_COMBAT_15_SECONDS,
	TIMER_COMBAT_20_SECONDS,
	TIMER_COMBAT_30_SECONDS,
	TIMER_COMBAT_60_SECONDS
};

enum EStartPosition
{
	START_POSITION_RANDOM,
	START_POSITION_1,
	START_POSITION_2,
	START_POSITION_3,
	START_POSITION_4,
	START_POSITION_5,
	START_POSITION_6,
	START_POSITION_7,
	START_POSITION_8
};

enum EGameWinConditionType
{
	EGameWinConditionType_Standard<DisplayName="Standard">,
	EGameWinConditionType_AcquireArtifact<DisplayName="Aquire Artifact">,
	EGameWinConditionType_AccumulateCreatures<DisplayName="Accumulate Creatures">,
	EGameWinConditionType_AccumulateResources<DisplayName="Accumulate Resources">,
	EGameWinConditionType_TearOfAsha<DisplayName="Build Tear of Asha">,
	EGameWinConditionType_DefeatHero<DisplayName="Defeat Hero">,
	EGameWinConditionType_CaptureTown<DisplayName="Capture Town">,
	EGameWinConditionType_DefeatArmy<DisplayName="Defeat Army">,
	EGameWinConditionType_ControlAllForts<DisplayName="Control all Forts">,
	EGameWinConditionType_ControlAllMines<DisplayName="Control all Mines">,
	EGameWinConditionType_TransportArtifact<DisplayName="Transport Artifact">,
	EGameWinConditionType_UserDefined<DisplayName="User Defined">,
	EGameWinConditionType_Disabled<DisplayName="Disabled">,
};

enum EGameLoseConditionType
{
	EGameLoseConditionType_Standard<DisplayName="Standard">,
	EGameLoseConditionType_LoseTown<DisplayName="Lose Town">,
	EGameLoseConditionType_LoseHero<DisplayName="Lose Hero">,
	EGameLoseConditionType_TimeLimit<DisplayName="Turn Limit">,
	EGameLoseConditionType_Disabled<DisplayName="Disabled">,
};

// contains the currently selected ssettings of a player in a Lobby
// !!! WARNING - if you want to change this, talk to Manuel first. There is a size limit !!!
struct native PlayerLobbySelectedSettings
{
	var savegame EPlayerSlotState		mSlotState;
	var savegame init string			mName;
	var savegame EAIDifficulty			mAIDifficulty;
	var savegame ETeamNumber			mTeam;              // only for adventure lobby
	var H7EditorHero		            mStartHero;
	var savegame init string            mStartHeroRef;
	var savegame EPlayerColor			mColor;
	var H7Faction                       mFaction;
	var savegame init string			mFactionRef;
	var savegame int                    mStartBonusIndex;   // only for adventure lobby // -1 = random, 0 = first map-defined bonus, 1 = second ... 
	var savegame EStartPosition         mPosition;
	var bool                            mIsReady;
	//var int                             mArmyIndex;         // only for combat lobby
	var H7EditorArmy                    mArmy;              // only for combat lobby
};
// !!! WARNING - if you want to change this, talk to Manuel first. There is a size limit !!!

struct native H7LobbyDataMapSettings
{
	var savegame init string mMapFileName; // used for duel and skirmish
	// all others only used for skirmish:
		// includes Map Name
		// includes Max Players
		// includes all possible start boni (used if mCanUseStartBonus = true) TODO
		// includes a team setup (used if ETeamSetup = TS_MAP_DEFAULT) TODO
		// includes a startposition setup (used if mUseRandomStartPosition = false)
	var savegame EVictoryCondition mVictoryCondition; // the condition the host has set; if default: used kismet nodes in map
	// TODO VictoryCondition parameters
	var savegame bool mCanUseStartBonus; // false = greyed out
	var savegame ETeamSetup mTeamSetup;
	var savegame bool mUseRandomStartPosition; // false = use map startpositions
	var savegame bool mUseDefaults;
};

struct native H7DifficultyParameters
{
	var savegame EDifficultyStartResources mStartResources; 
	var savegame EDifficultyCritterStartSize mCritterStartSize; 
	var savegame EDifficultyCritterGrowthRate mCritterGrowthRate;
	var savegame EDifficultyAIEcoStrength mAiEcoStrength; 

	structdefaultproperties
	{
		mStartResources=DSR_AVERAGE
		mCritterStartSize=DCSS_AVERAGE
		mCritterGrowthRate=DCGR_AVERAGE
		mAiEcoStrength=DAIES_AVERAGE
	}
};

struct native H7LobbyDataGameSettings
{
	var savegame bool mSpectatorMode; // true -> the spectators can watch the combats, false -> they just see a progress bar screen
	var savegame float mGameSpeedAdventure;
	var savegame float mGameSpeedAdventureAI;
	var savegame float mGameSpeedCombat;
	var savegame ETimerCombat mTimerCombat; // used for duel as well
	// all others only used for skimish:
	var savegame bool mSimTurns;
	var savegame EForceQuickCombat mForceQuickCombat; //
	var savegame bool mUseRandomSkillSystem; // false = use free skill system
	var savegame bool mTeamsCanTrade;
	var savegame EDifficulty mDifficulty;
	var savegame H7DifficultyParameters mDifficultyParameters;
	var savegame ETimerAdv mTimerAdv;

	structdefaultproperties
	{
		mGameSpeedAdventureAI=1.f
		mGameSpeedAdventure=1.f
		mGameSpeedCombat=1.f
	}
};

struct native H7LobbyData 
{
	var H7LobbyDataMapSettings mMapSettings;
	var H7LobbyDataGameSettings mGameSettings;
	var PlayerLobbySelectedSettings mPlayers[EPlayerNumberWithoutNeutral.PNWE_PLAYER_MAX];
	var savegame init string mSaveGameFileName; // contains the slotId
	var savegame int mSaveGameCheckSum;
	var bool mIsInitialized;
	var savegame bool mIsDuel;
};

struct native H7RelativeWeightData
{
	var(Skill) int  SkillWeightNovice       <DisplayName="Novice Weight"|ClampMin=1>;
	var(Skill) int  SkillWeightExpert       <DisplayName="Expert Weight"|ClampMin=1>;
	var(Skill) int  SkillWeightMaster       <DisplayName="Master Weight"|ClampMin=1>;

	var(Ability) int AbilityWeightNovice        <DisplayName="Novice Weight"|ClampMin=1>;
	var(Ability) int AbilityWeightExpert        <DisplayName="Expert Weight"|ClampMin=1>;
	var(Ability) int AbilityWeightMaster        <DisplayName="Master Weight"|ClampMin=1>;
	var(Ability) int AbilityWeightGrandmaster   <DisplayName="Grandmaster Weight"|ClampMin=1>;

	structdefaultproperties
	{
		SkillWeightNovice=1
		SkillWeightExpert=5
		SkillWeightMaster=10
		AbilityWeightNovice=1
		AbilityWeightExpert=3
		AbilityWeightMaster=5
		AbilityWeightGrandmaster=5
	}
};


//SAVEGAME HELPER STRUCTS

struct native SkillReference
{
	var savegame string PathName;
	var savegame ESkillRank SkillRank;
};

// Used for carry data in saves
struct native H7SkillProxy
{
	var savegame init string SkillArchRef;
	var savegame int SkillRank;
	var savegame bool UltimateRequirment;
	var savegame int SkillID;
};

struct native AdventureMapCellCoords
{
	var savegame IntPoint Coordinates;
	var savegame int GridIndex;

	structdefaultproperties
	{
		Coordinates = { ( X = -1, Y = -1) }
		GridIndex = -1
	}
};

struct native SavegameHeroStruct
{
	var savegame bool	HasData;

	var savegame int	Level;
	var savegame int	XP;
	var savegame int	Spirit;
	var savegame int	Magic;
	var savegame int    AttackBase;
	var savegame int    DefenseBase;
	var savegame int    ArcaneKnowledgeBase;
	var savegame float  CurrentMovementPoints;
	var savegame int	CurrentMana;
	var savegame int	MaxManaBonus;
	var savegame int	ManaRegenBase;
	var savegame int	SkillPoints;
	var savegame bool   IsHero;
	var savegame int    PlayerNumber;
	var savegame int    ID;
	var savegame bool   HasTearOfAsha;

	var savegame bool   HasFinishedTurn;
	var savegame bool   HasCastedSpellThisTurn;

	var savegame H7HeroEquipment            Equipment;
	var savegame H7Inventory                Inventory;
	var savegame array<H7SkillProxy>        SkillRefs;
	var savegame int                        SkillPointsSpend;
	var savegame array<init string>         LearnedAbilityRefs;
	var savegame bool                       RandomIsReset;
	var savegame array<init string>         RandomPickedSkillRefs;
	var savegame array<init string>         RandomPickedAbilityRefs;

	var savegame array<init string>         PickableSkillPoolRefs;
	var savegame array<int>                 WeightForSkills;
	var savegame array<init string>         PickableAbilityPoolRefs;
	var savegame array<int>                 WeightForAbilities;
	var savegame H7BuffManager              BuffManager;

	var savegame array<init string>              QuickBarCombatRefs;
	var savegame array<init string>              QuickBarAdventureRefs;
	
	var savegame H7Town                     GovernedTown;

	var savegame bool                       AiHibernation;
	var savegame EHeroAiAggressiveness      AiAggressiveness;
	var savegame EScriptedBehaviour         ScriptedBehaviour;
	var savegame EHeroAiControlType         ControlType;
	var savegame EHeroAiRole                HeroAiRole;
	var savegame H7VisitableSite            HomeSite;
	var savegame bool                       IsPendingLevel;  

	var savegame int    ScoutingRadius;
	var savegame bool   CanScout;
	var savegame bool   IsAlliedWithEverybody;
	var savegame float  TerrainCostModifier;

	var savegame array<AdventureMapCellCoords>  CurrentPath;
	var savegame AdventureMapCellCoords         LastCellMovement;

	var savegame H7AbilityManager           AbilityManager;
	var savegame array<init string>         HeroSpellArchetypeReferences;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
	var savegame array<int>                 HeroSpellIDs;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
	var savegame array<init string>         HeroVolatileSpellArchetypeReferences;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
	var savegame array<int>                 HeroVolatileSpellIDs;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
	var savegame array<init string>         HeroAbilityArchetypeReferences;
	var savegame array<int>                 HeroAbilityIDs;
};

struct native SavegameBuffStruct
{
	var savegame string BuffReference;
	var savegame int    CasterReferenceID;
	var savegame string SourceReference;
	var savegame int    RemainingDuration;
};

struct native H7CreatureArray
{
	var() array<H7Creature> Creatures;
};

struct native H7CreatureList
{
	var() H7CreatureArray Creatures[ECreatureLevel.E_H7_CL_MAX];
};

struct native H7FactionCreatureData
{
	var() H7Faction Faction;
	var() H7CreatureList CreatureList;
};

struct native H7RewardData
{
	var() archetype H7HeroItem Item<DisplayName = "HeroItem">;
	var() ETier ItemTier<DisplayName = "Item Tier">;
	var() EItemType ItemType<DisplayName = "Item Type">;
	/**For Merchant only. The Offer can be bought once and will remain the same until it's sold.*/
	var() bool UniqueOffering<DisplayName = "Unique Offer">;
};

struct native H7MultiRewardData
{
	var() Array <H7RewardData> RewardData <DisplayName = "RewardData">;
};

struct native H7TownBuildingVisitData
{
	var savegame H7TownBuilding Building;
	var savegame H7Town Town;
	var savegame EPlayerNumber PlayerID;
};

struct native H7SiteVisitData
{
	var savegame H7VisitableSite Site;
	var savegame EPlayerNumber PlayerID;
};

// recruiter's office effect special
struct native H7TownBuffToAoCData
{
	var() H7TownBuilding	mBuilding	    <DisplayName=Building>;
	var() H7BaseBuff	    mBuff	        <DisplayName=Buff>;
	var() H7Creature        mCreature       <DisplayName=Produces Unit>;
};

struct native H7CaravanRoute
{
	var() savegame H7AreaOfControlSiteLord SourceLord<DisplayName="Source Lord">;
	var() savegame H7AreaOfControlSiteLord TargetLord<DisplayName="Target Lord">;
};

struct native H7LevelUpData
{
	var int Level;
	var EStat Stat;
	var int Value;
};

struct native H7AbilityTrackingData
{
	var savegame string AbilityName;
	var savegame string CasterName;
	var savegame int NumberOfCasts;
};

struct native H7MinePlunderCounter
{
	var() savegame H7Mine Mine<DisplayName="Target Mine">;
	var() savegame int Counter<DisplayName="Plunder Count"|ClampMin=1>;
	var savegame EPlayerNumber PlayerID;

	structdefaultproperties
	{
		Counter=1
	}
};

//from H7ResourceSet
// Stores resource type and quantity
struct native ResourceStockpile
{
	/** The type of resource */
	var(Resource) savegame H7Resource Type;
	/** The amount of resource */
	var(Resource) savegame int Quantity;
	/** The income rate */
	var(Resource) int Income;

	structdefaultproperties
	{
		Type = H7Resource'H7Resources.ResourceTypes.A_Resource_Generic';
		Quantity = 0;
		Income = 0;
	}
};

// we have 2 types of heroes: the one that is new and doesnt exist and the one that already exist but was defeated
struct native RecruitHeroData
{
	var savegame int RandomHeroesIndex;					// if IsNew == true
	var savegame int Cost;								// price to recruit the hero
	var savegame H7AdventureArmy Army;					// the army contains the hero
	var savegame bool IsNew;							// true -> is a new hero, false -> the hero lost a battle (defeated, surrender or flee)
	var savegame bool IsAvailable;						// false -> cannot be recruited because the hero just lost the battle (defeated, surrender or flee) in the current day
};

// From H7HallOfHeroesManager
struct native RandomHeroData
{
	var archetype savegame H7EditorHero HeroArchetype;
	var savegame bool IsBeingUsed;
};

struct native PlayerHeroesPoolData
{
	var savegame H7Player PlayerOwner;
	var savegame array<RecruitHeroData> HeroesPool;
};

struct native TownHeroesPoolData
{
	var savegame H7Town TownOwner;
	var savegame array<RecruitHeroData> HeroesPool;
};


struct native ConditionalStatMod
{
	var H7MeModifiesStat StatMod;
	var H7EffectContainer Source;
	var H7IEffectTargetable Target;
};

enum EWindowMode
{
	WM_WINDOW,
	WM_FULLSCREEN,
	WM_BORDERLESS_WINDOW
};


/////////////////////////////////
// Profile 
/////////////////////////////////

enum MapState
{
	MST_NotStarted,
	MST_InProgress,
	MST_Completed
};

// struct that saves the 'best'/'furthest' (tbd?) savegame for each map, that is loaded when I "continue" this map
struct native H7MapSaveMapping
{
	var int mSaveSlotIndex;
	var int mSaveTimeUnix;
	var init string mMapFileName;
	var init string mCampaignID; // archetype name

	// DEPRECATED Don't use
	var init string mSaveFileName; 

	structdefaultproperties
	{
		mSaveSlotIndex = -1
		mSaveTimeUnix = -1
	}
};

struct native BaseMapProgress
{
	// Name of map used as reference
	var string MapFileName;

	// How many times this map was loaded (includes save, resets, new game etc.)
	var int StartTimesCount;

	// Gameplay time (AM+CM) excluding Pause/Cinematics/Matinees cleared every 60s
	var float GameplayTimeSec;

	// Minutes -> Total gameplay time (AM+CM) excluding Pause/Cinematics/Matinees
	var int TotalGameplayTimeMin; 

	// How many times this map was loaded (includes save, resets, new game etc.) until the map was completed first time
	var int StartTimesUntilCompleted;

	// Turns until the map was completed first time
	var int TurnsUntilCompleted;

	var bool WasOnceCompleted;

	structdefaultproperties
	{
		WasOnceCompleted = false
	}
};


struct native MovieData
{
	var string MovieName;

	// If false cinematic was completed
	var bool WasSkipped;
	// Time until it was skipped or completed (secosnds)
	var float PlayTime;
};


struct native CampaignMapProgress extends BaseMapProgress
{
	// Checkpoints are ordered in order they were unlocked, top checkpoint is considered as last one for this mission player unlocked
	var array<int> UnlockedStorypoints; 

	// Enum to help in determinig the state of mission
	var MapState CurrentMapState;

	//  ID of mission in campaignDef list 
	var int MapIndexInCampaign;

	// What was the highest difficulty when map was completed (reseted by ResetCampaign)
	var H7DifficultyParameters HighestDifficulty;

	// Difficulty for the last playthrough
	var H7DifficultyParameters CurrentDifficulty;

	// Last savegame ref -> Valid only for latest map in campaign
	var H7MapSaveMapping LastMapSave;

	structdefaultproperties
	{
		CurrentMapState = MST_NotStarted
		MapIndexInCampaign = -1

		HighestDifficulty = (mStartResources = DSR_AVERAGE, mCritterStartSize = DCSS_AVERAGE, mCritterGrowthRate = DCGR_AVERAGE, mAiEcoStrength = DAIES_AVERAGE)

		CurrentDifficulty = (mStartResources = DSR_AVERAGE, mCritterStartSize = DCSS_AVERAGE, mCritterGrowthRate = DCGR_AVERAGE, mAiEcoStrength = DAIES_AVERAGE)
	}
};

struct native H7RawCampaignData
{
	var int                                 mRevision;
	var init string	                        mName;
	var init string                         mFileName;
	var init string	                        mAuthor;
	var init string	                        mDescription;
	var init array<init string>	            mCampaignMaps;
	var init array<init string>	            mCampaignMapNames;
	var init array<init string>	            mCampaignMapInfoNumbers;   // The numbers of the MapInfo objects inside the maps (needed for loca)
	var init string	                        mContainerObjectName;   // Needed for loca lookup
};

struct native CampaignProgress
{
	// My index on campaign list
	var int CampaignProgressIndex;

	// Used to recreate customCampaign after reboot
	var H7RawCampaignData RawCampaignData;

	// To which campaign this progress belongs
	var H7CampaignDefinition CampaignRef;

	var bool IsCompleted;

	// Completed missions in order they were completed
	var array<CampaignMapProgress> CompletedMaps;

	// Current mission can only have state NotStarted or InProgress, its not part of CompletedMissions list
	var CampaignMapProgress CurrentMap;

	// Temporary data for replayed maps, its used to override data if replay was Successfully completed
	var CampaignMapProgress ReplayMap;

	// Gameplay time (AM+CM) excluding Pause/Cinematics/Matinees cleared every 60s
	var float GameplayTimeSec;

	// Minutes -> Total gameplay time (AM+CM) excluding Pause/Cinematics/Matinees
	var int TotalGameplayTimeMin; // <- @FUNFACT: It will take ~4083 YEARS of gameplay to overflow it :)

	var bool CouncilIntroPlayed;
	var bool CouncilOutroPlayed;
	var bool ProgressScenePlayed;

	// Last savegame ref in 
	var H7MapSaveMapping LastCampaignSave;
};

//from H7Dwelling
struct native H7DwellingCreatureData
{
	/** The type of dwelling creature */
	var() archetype savegame H7Creature Creature         <DisplayName="Creature Type">;
	/** The weekly growth of this creature */
	var() savegame int Income                            <DisplayName="Weekly Growth (daily for Local Guard)"|ClampMin=1>;
	/** The current reserve */
	var() savegame int Reserve                           <DisplayName="Current Amount"|ClampMin=0>;
	/** The maximum reserve */
	var() savegame int Capacity                          <DisplayName="Maximum Amount"|ClampMin=0>;

	var() savegame ECreatureTier CreatureTier                     <DisplayName="Random Creature Tier (if Creature Type == None)">;
};

struct native H7DwellingCreatureDataArray
{
	var() array<H7DwellingCreatureData> Datas<DisplayName=Creature Datas>;
};


/////////////////////////////////
// Achievements 
/////////////////////////////////

enum EAchievementType
{
	ACHT_Combat, // Combat | Siege
	ACHT_Adventure,
	ACHT_Map,
	ACHT_Misc
};

// Converted from UPLAY_WIN_Reward_t for easier access
struct native H7UPlayReward
{
	/** Null terminated UTF-8 string containing the id of the reward. */
	var init string  idUtf8;
	/** Null terminated UTF-8 string containing the name.  */
	var init string  nameUtf8;
	/** Null terminated UTF-8 string containing the description. */
	var init string  descriptionUtf8;
	/** Null terminated UTF-8 string containing the URL of the reward. */
	var init string  urlUtf8;
	/** The unit cost */
	var int		units;
	/** Null terminated UTF-8 string containing the Uplay Game Code of the corresponding game. */
	var init string	gameCodeUtf8;
	/** Null terminated UTF-8 string containing the Uplay Platform Code of the corresponding game. */
	var init string	platformCodeUtf8;
	/** Null terminated UTF-8 string containing the image URL of the reward. */
	var init string	imageUrlUtf8;
	/** Determines whether the reward has been redeemed or not. Valid values are UPLAY_true or UPLAY_false. */
	var bool	redeemed;

	// Is reward enabled by user in game?
	var bool enabled;
};

// Converted from UPLAY_WIN_Action_t for easier access
struct native H7UPlayAction
{
	/** Null terminated UTF-8 string containing the id. */
	var init string  idUtf8;
	/** Null terminated UTF-8 string containing the name.  */
	var init string  nameUtf8;
	/** Null terminated UTF-8 string containing the description. */
	var init string  descriptionUtf8;
	/** Null terminated UTF-8 string containing the image URL. */
	var init string  imageUrlUtf8;
	/** The amount of units the action is worth. */
	var int		units;
	/** Determines whether the action has been completed or not. Valid values are UPLAY_true or UPLAY_false. */
	var bool	completed;

	// Is action synchronized with UPlay? (send)
	var bool synchronized;

	structdefaultproperties
	{
		idUtf8 = ""
	}
};

struct native H7GroupedMeshes
{
	var() string Group<DisplayName="Group">;
	var() array<StaticMesh> Meshes<DisplayName="Meshes">;
};

struct native H7TownGuardModifier
{
	var() EOperationType  mOperation    <DisplayName=Operation>;
	var() int             mValue        <DisplayName=Modifier Value>;
	var() ECreatureTier   mTier         <DisplayName=Creature Tier>;
};

struct native H7GuardCreatureData
{
	var() ECreatureTier mCreatureTier   <DisplayName=Creature Tier>;
	var() int           mAmount         <DisplayName=Amount>;
};



enum EFloatingTextOptions
{
	FTO_AS_DISPLAYED	<DisplayName=Same As Displayed>,
	FTO_SUPPRESS        <DisplayName=Suppress Floating Text>,
	FTO_ALWAYS          <DisplayName=Always Show Floating Text>,
};

enum ELogTextOptions
{
	LTO_AS_DISPLAYED	<DisplayName=Same As Displayed>,
	LTO_SUPPRESS        <DisplayName=Suppress Log Text>,
	LTO_ALWAYS          <DisplayName=Always Show Log Text>,
};

enum EAdventureMapFinishedCondition
{
	E_H7_AMFC_WIN<DisplayName="Current player wins">,
	E_H7_AMFC_LOSE<DisplayName="Current player loses">,
	E_H7_AMFC_ALWAYS<DisplayName="Always">,
};

enum EEditorObjectEditOperation
{
	E_H7_EOO_STARTUP,
	E_H7_EOO_MOVED,
	E_H7_EOO_DELETED,
	E_H7_EOO_ENTRANCECHANGED,
};

// used in flash, inform gui programmer when changed
enum EChatChannel
{
	CHAT_ALL,             
	CHAT_TEAM,            
	CHAT_WHISPER,         // CC_WHISPER + playerNumber = channelIndex | channelIndex - CC_WHISPER = playerNumber
	CHAT_WHISPER_P1,
	CHAT_WHISPER_P2,
	CHAT_WHISPER_P3,
	CHAT_WHISPER_P4,
	CHAT_WHISPER_P5,
	CHAT_WHISPER_P6,
	CHAT_WHISPER_P7,
	CHAT_WHISPER_P8,
};

enum EConditionTimeUnit
{
	CTU_DAYS<DisplayName="days">,
	CTU_WEEKS<DisplayName="weeks">,
};

struct native H7BooleanStruct // because Unreal....
{
	var() bool Allowed;

	structdefaultproperties
	{
		Allowed = true
	}
};

struct native RandomLordDefenseData
{
	var(RandomCreatureStack) bool mUseThis<DisplayName="Use Default Garrison">;
	// Minimal this amount of stacks will be part of this army. Cannot be higher than Max Stack Number.
	var(RandomCreatureStack) int mMinStackNumber<DisplayName="Min Stack Number"|ClampMin=1|ClampMax=7>;
	// Maximal this amount of stacks will be part of this army. Cannot be lower than Min Stack Number.
	var(RandomCreatureStack) int mMaxStackNumber<DisplayName="Max Stack Number"|ClampMin=1|ClampMax=7>;

	// List of all factions to be checked for random picking.
	var(RandomCreatureStack) array<H7Faction> mAllowedFactions<DisplayName="Permitted Factions">;

	// How to resolve the faction of this army.
	var(RandomCreatureStack) ERandomSiteFaction mFactionType<DisplayName="Faction Type">;

	// This stack will take the same faction as the selected building.
	var H7AreaOfControlSiteLord mReferenceLord<DisplayName="Faction as Town/Fort">;
	var(RandomCreatureStack) bool mUseFactionOfLord<DisplayName="Use Same Faction as Town/Fort">;

	// Enables to select a creature level to get the random creature chosen from.
	var(RandomCreatureStack) bool mUseCreatureLevel<DisplayName="Use Creature Level">;
	// Creature level to get the random creature chosen from.
	var(RandomCreatureStack) H7BooleanStruct mAllowedLevels[ECreatureLevel.E_H7_CL_MAX]<DisplayName="Allowed Creature Levels"|EditCondition=mUseCreatureLevel>;

	// Enables to use an amount of xp to define the strength of this army. When unchecked the army will be created from random stacksizes.
	var(RandomCreatureStack) bool mUseXPStrength<DisplayName="Use XP Strength">;
	// This amount of experience points will be divided through the number of stacks and then devided through the single xp of the respective chosen creature to get the stacksizes.
	var(RandomCreatureStack) int mXPStrength<DisplayName="XP Strength"|EditCondition=mUseXPStrength>;
	// Minimal this amount of creatures will be part in stacks. Cannot be higher than Max Stack Size.
	var(RandomCreatureStack) int  mMinStackSize<DisplayName="Min Stack Size"|EditCondition=!mUseXPStrength|ClampMin=1>;
	// Maximal this amount of creatures will be part in stacks. Cannot be lower than Min Stack Size.
	var(RandomCreatureStack) int  mMaxStackSize<DisplayName="Max Stack Size"|EditCondition=!mUseXPStrength|ClampMin=1>;

	// Enables the usage of different Creatures in the various stacks
	var(RandomCreatureStack) bool mChooseRandomCreatures<DisplayName="Choose Random Creatures">;
	// Forces all Creatures to be chosen from the same Faction
	var(RandomCreatureStack) bool mChooseSameFaction<DisplayName="Use Same Faction For All">;
	// Limits the Allowed Creature Levels (Tiers) based on the specified XP Strength
	var(RandomCreatureStack) bool mLimitLevelsFromXP<DisplayName="Limit Allowed Creature Levels from XP Strength"|EditCondition=mUseXPStrength>;

	// Types of possible creature upgrades 
	var(RandomCreatureStack) EArmyCompositionType mCreatureUpgrades<DisplayName="Creature Upgrades">;

	structdefaultproperties
	{
		mUseThis=false
		mUseXPStrength=true
		mUseFactionOfLord=true
		mFactionType=E_H7_RSF_AS_ANOTHER_TOWN
		mXPStrength=3500
		mMinStackNumber=3
		mMaxStackNumber=7
		mChooseRandomCreatures=true
		mChooseSameFaction=true
		mCreatureUpgrades=EACT_ANY
		mUseCreatureLevel=true
		mAllowedLevels[3]={(
                  Allowed=false
               )}
		mAllowedLevels[4]={(
                  Allowed=false
               )}
	}
};

struct native H7TownDwellingOverride
{
	var() savegame H7Town TargetTown;
	var() savegame archetype H7TownDwelling TargetDwelling;
	var() savegame H7DwellingCreatureData CreaturePool;
	var() savegame string Name;
	var() savegame string Description;
	var() savegame string IconPath;
	var() transient Texture2D Icon;
};
