//=============================================================================
// H7AiAdventureMapConfig
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiAdventureMapConfig extends Object
	HideCategories(Object)
	native;

var(Hero) const H7AiActionConfig    mConfigAttackArmy<DisplayName=Attack Army>;
var(Hero) const H7AiActionConfig    mConfigAttackBorderArmy<DisplayName=Attack Border Army>;
var(Hero) const H7AiActionConfig    mConfigAttackEnemy<DisplayName=Attack Enemy>;
var(Hero) const H7AiActionConfig    mConfigAttackAoC<DisplayName=Attack AoC Building>;
var(Hero) const H7AiActionConfig    mConfigAttackCity<DisplayName=Attack City>;
var(Hero) const H7AiActionConfig    mConfigPickup<DisplayName=Pickup>;
var(Hero) const H7AiActionConfig    mConfigGather<DisplayName=Gather>;
var(Hero) const H7AiActionConfig    mConfigReinforce<DisplayName=Reinforce>;
var(Hero) const H7AiActionConfig    mConfigExplore<DisplayName=Explore>;
var(Hero) const H7AiActionConfig    mConfigRepair<DisplayName=Repair>;
var(Hero) const H7AiActionConfig    mConfigGuarding<DisplayName=Guarding>;
var(Hero) const H7AiActionConfig    mConfigFlee<DisplayName=Flee>;
var(Hero) const H7AiActionConfig    mConfigChill<DisplayName=Chill>;
var(Hero) const H7AiActionConfig    mConfigPlunder<DisplayName=Plunder>;
var(Hero) const H7AiActionConfig    mConfigUseSite<DisplayName=Use Site>;
var(Hero) const H7AiActionConfig    mConfigUseSiteBoost<DisplayName=Use Site Boost>;
var(Hero) const H7AiActionConfig    mConfigUseSiteCommission<DisplayName=Use Site Commisssion>;
var(Hero) const H7AiActionConfig    mConfigUseSiteExercise<DisplayName=Use Site Exercise>;
var(Hero) const H7AiActionConfig    mConfigUseSiteObserve<DisplayName=Use Site Observe>;
var(Hero) const H7AiActionConfig    mConfigUseSiteShop<DisplayName=Use Site Shop>;
var(Hero) const H7AiActionConfig    mConfigUseSiteStudy<DisplayName=Use Site Study>;
var(Hero) const H7AiActionConfig    mConfigUseSiteKeymaster<DisplayName=Use Site Keymaster>;
var(Hero) const H7AiActionConfig    mConfigUseSiteObelisk<DisplayName=Use Site Obelisk>;
var(Hero) const H7AiActionConfig    mConfigCongregate<DisplayName=Congregate>;
var(Hero) const H7AiActionConfig    mConfigReplenish<DisplayName=Replenish>;

var(Hero) const H7AiHeroConfig      mConfigHeroes<DisplayName=Hero Persona>;
var(Hero) const H7AiHeroConfig2     mConfigHeroes2<DisplayName=Hero Persona Ex>;

var(Hero) const H7AiActionParameter mConfigAttackBorderArmy_PowerFactorPlayer<DisplayName=Attack Border Army - power factor player>;

var(Hero) const float               mConfigDiscoveryScoutingThreshold<DisplayName=Discovery Scouting Threshold>;
var(Hero) const float               mConfigZoneOfDeathThreshold<DisplayName=Zone Of Death Threshold>;

var(Town) const int                 mConfigMaxHireHero<DisplayName=Maximum heroes>;
var(Town) const float               mConfigHireHeroSpending<DisplayName=Hire hero spending>;
var(Town) const int                 mConfigHireHeroSpendingMaxCurrency<DisplayName=Hire hero spending max currency>;
var(Town) const int                 mConfigTradingTurnStart<DisplayName=Trading starting turn>;
var(Town) const float               mConfigTradingFrequency<DisplayName=Trading frequency>;
var(Town) const int                 mConfigDevelopmentTurnStart<DisplayName=Development starting turn>;
var(Town) const float               mConfigDevelopmentFrequency<DisplayName=Development frequency>;
var(Town) const float               mConfigDevelopmentSpending<DisplayName=Development spending>;
var(Town) const int                 mConfigDevelopmentSpendingMaxCurrency<DisplayName=Development spending max currency>;
var(Town) const int                 mConfigRecruitTurnStart<DisplayName=Recruitment starting turn>;
var(Town) const float               mConfigRecruitSpending<DisplayName=Recruitment spending>;
var(Town) const int                 mConfigRecruitSpendingMaxCurrency<DisplayName=Recruit spending max currency>;
var(Town) const int                 mConfigHeroCongregationMinArmyPowerThreshold<DisplayName="Preserved army power for reinforce">;
var(Town) const float               mConfigUpgradeCreaturesSpending<DisplayName=Upgrade Creatures spending>;
var(Town) const int                 mConfigUpgradeCreaturesMaxCurrency<DisplayName=Upgrade Creatures spending max currency>;
var(Town) const int                 mConfigRecruitmentInterval<DisplayName="Recruitment interval">;

var(Town) const H7AiTownConfig      mConfigTechTrees<DisplayName=Faction Tech Trees>;

var(Hero) const float               mConfigHPBoostVsNeutralMultiplier<DisplayName="HP Boost vs Neutral multiplier">;


var(Debug) const bool               mConfigOutputToLog<DisplayName="Output AI log">;
var(Debug) const bool               mConfigVisualiseReachability<DisplayName="Visualise Reachability">;

// Default properties block
