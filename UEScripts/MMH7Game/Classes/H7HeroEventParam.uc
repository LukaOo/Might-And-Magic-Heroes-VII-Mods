/*=============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/
class H7HeroEventParam extends H7EventParam
	native;

var H7EditorHero mEventHeroTemplate;
var EPlayerNumber mEventPlayerNumber;

// Combat Trigger
var EPlayerNumber mEventEnemyPlayerNumber;

//Hero capture/visit site
var H7VisitableSite mEventSite;

//Hero reach level
var int mEventHeroLevel;
var int mEventOldHeroLevel;

// Hero reach movement points
var int mEventMovementPoints;

//Hero learn skill
var H7Skill mEventSkill;
var ESkillRank mEventSkillRank;
var H7HeroAbility mEventLearnedAbility;

//Hero cast ability
var H7HeroAbility mEventCastedAbility;

//Combat/Collect Army
var H7AdventureArmy mEventTargetArmy;

//Combat
var H7AdventureArmy mEventVictoriousArmy;
var string mCombatMapName;
var H7AdventureMapCell mBeforeBattleCell;
var int mCombatCurrentTurn;
var H7BattleSite mBattleSite;

//Hero enters/leaves ship
var EShipInteraction mShipInteraction;
