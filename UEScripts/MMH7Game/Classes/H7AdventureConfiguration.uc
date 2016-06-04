//=============================================================================
// H7AdventureConfiguration
//=============================================================================
// 
// class for configurations on the adventure map
// Contains all the values that can be changed for balancing the gameplay of the adventure map
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7AdventureConfiguration extends actor
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	native
	savegame;

// Lost hero total cost = BaseHeroCost + heroLevel * PerLevelHeroCost (Lost hero = hero that already died)
var(HallOfHeroes) protectedwrite int mBaseLostHeroCost<DisplayName=Base Lost hero cost>;
var(HallOfHeroes) protectedwrite int mPerLevelLostHeroCost<DisplayName=Per level Lost hero cost>;
// New hero total cost = mBaseNewHeroCost + (number of heroes tha player owns) * mPerNumHeroesNewHeroCost
var(HallOfHeroes) protectedwrite int mBaseNewHeroCost<DisplayName=Base New hero cost>;
var(HallOfHeroes) protectedwrite int mPerNumHeroesNewHeroCost<DisplayName=Per level New hero cost>;
var(HallOfHeroes) protectedwrite int mNumHeroesSameFaction<DisplayName=Number of heroes of the same player faction that will be added weekly>;
var(HallOfHeroes) protectedwrite int mNumHeroesOtherFactions<DisplayName=Number of heroes of the other factions that will be added weekly>;

// SkillWheel
/** Random Skills*/
var(SkillWheel) protectedwrite int mMaxSkillSlot<DisplayName="Number Of Maximum Skill Slots In Random Skill Window">;
/** Random Skills*/
var(SkillWheel) protectedwrite int mSkillSlot<DisplayName="Number Of Skill Slots In Random Skill Window">;
/** Random Skills*/
var(SkillWheel) protectedwrite int mAbilitySlot<DisplayName="Number Of Ability Slots In Random Skill Window">;
var(SkillWheel) protectedwrite bool mOptionalAbility<DisplayName="Each Ability Differs From Each Other">;
/** Random Skills*/
var(SkillWheel) protectedwrite H7RelativeWeightData mWeightData<DisplayName="Skill/Ability Weight Table">;

var(Gameplay) protectedwrite bool mEnableDailyGrowth<DisplayName=Check to have Daily creature growth instead of Weekly>;
var(Gameplay) protectedwrite int mCaravanMaxMovementPoints<DisplayName=Maximum default movement points of a caravan>;
var(Gameplay) protectedwrite ParticleSystem mHighlightParticle<DisplayName=Interactive Object Highlight Particle>;
var(Gameplay) protectedwrite int mCostPerInformation<DisplayName=Cost per Information in Thieves Guild>;
// HeroSpirit x ManaRegenMultiplier = DailyManaRegen
var(Gameplay) protectedwrite int mManaRegenMultiplier<DisplayName=Multiplier used for calculation of Daily Mana Regen>;
var(Gameplay) protectedwrite archetype H7Ship mShip<DisplayName ="Default Ship">;

var(Gameplay) int mArcaneKnowledgeTiers[4]<DisplayName=Arcane Knowledge Tiers (Minimum Values)>;

var(Negotiation) protectedwrite float mAPRLevels[6]<DisplayName=Army Power Relation caps for negotiation (Trivial-Deadly)>;
var(Negotiation) protectedwrite float mNegotiationBaseChances[7]<DisplayName=Negotiation Base Chances (Trivial-Deadly)>;
var(Negotiation) protectedwrite float mNegotiationImpressionMods[7]<DisplayName=Negotiation Impression Modifiers (Trivial-Deadly)>;

var(Calendar) protectedwrite string mDefaultStartingWeek<DisplayName=Default Starting Week>;
var(Calendar) protectedwrite array<string> mWeeks<DisplayName=Weeks>;
var(Calendar) protectedwrite array<string> mMonth<DisplayName=Month>;
var(Calendar) protectedwrite int mMaxDayPerWeek<DisplayName=Max Days Per Week>;
var(Calendar) protectedwrite int mMaxWeeksPerMonth<DisplayName=Max Weeks Per Month>;
var(Calendar) protectedwrite int mMaxMonthPerYear<DisplayName=Max Month Per Year>;

var(Difficulty) protectedwrite float                    mDifficultyPlayerStartResourcesMultiplier[EDifficultyStartResources.DSR_MAX]    <DisplayName="Player Start Resources Multiplier">;
var(Difficulty) protectedwrite float                    mDifficultyCritterStartSizeMultiplier[EDifficultyCritterStartSize.DCSS_MAX]     <DisplayName="Critter Start Size Multiplier">;
var(Difficulty) protectedwrite float                    mDifficultyCritterGrowthRateMultiplier[EDifficultyCritterGrowthRate.DCGR_MAX]   <DisplayName="Critter Growth Rate Multiplier">;
var(Difficulty) protectedwrite float                    mDifficultyAIStartResourcesMultiplier[EDifficultyAIEcoStrength.DAIES_MAX]       <DisplayName="AI Start Resources Multiplier">;
var(Difficulty) protectedwrite float                    mDifficultyAICreatureGrowthRateMultiplier[EDifficultyAIEcoStrength.DAIES_MAX]   <DisplayName="AI Creature Growth Multiplier">;
var(Difficulty) protectedwrite float                    mDifficultyAIResourceIncomeMultiplier[EDifficultyAIEcoStrength.DAIES_MAX]       <DisplayName="AI Resource Income Multiplier">;
var(Difficulty) protectedwrite float                    mDifficultyAIAggressivenessMultiplier[EDifficultyAIAggressiveness.DAIA_MAX]     <DisplayName="AI Aggressiveness Multiplier (Skirmish + Campaign)">;

var(Difficulty) protectedwrite float                    mDifficultyPlayerStartResourcesMultiplierCampaign[EDifficultyStartResources.DSR_MAX]    <DisplayName="Player Start Resources Multiplier (Campaign)">;
var(Difficulty) protectedwrite float                    mDifficultyCritterStartSizeMultiplierCampaign[EDifficultyCritterStartSize.DCSS_MAX]     <DisplayName="Critter Start Size Multiplier (Campaign)">;
var(Difficulty) protectedwrite float                    mDifficultyCritterGrowthRateMultiplierCampaign[EDifficultyCritterGrowthRate.DCGR_MAX]   <DisplayName="Critter Growth Rate Multiplier (Campaign)">;
var(Difficulty) protectedwrite float                    mDifficultyAIStartResourcesMultiplierCampaign[EDifficultyAIEcoStrength.DAIES_MAX]       <DisplayName="AI Start Resources Multiplier (Campaign)">;
var(Difficulty) protectedwrite float                    mDifficultyAICreatureGrowthRateMultiplierCampaign[EDifficultyAIEcoStrength.DAIES_MAX]   <DisplayName="AI Creature Growth Multiplier (Campaign)">;
var(Difficulty) protectedwrite float                    mDifficultyAIResourceIncomeMultiplierCampaign[EDifficultyAIEcoStrength.DAIES_MAX]       <DisplayName="AI Resource Income Multiplier (Campaign)">;

var(QuickCombat) protectedwrite int						mQuickCombatMapWidth                        <DisplayName="Map Width">;
var(QuickCombat) protectedwrite float					mQuickCombatMoraleLuckInitBonusFactor       <DisplayName="Morale/Luck/Init Bonus Factor">;
var(QuickCombat) protectedwrite float					mQuickCombatMovementFactor                  <DisplayName="Movement Factor">;
var(QuickCombat) protectedwrite float					mQuickCombatHeroDamageFactor                <DisplayName="Hero Damage Factor">;
var(QuickCombat) protectedwrite float					mQuickCombatAttackDefenseMightMagicFactor   <DisplayName="Attack/Defense/Might/Magic Factor">;
var(QuickCombat) protectedwrite bool					mQuickCombatAllowSpellCast					<DisplayName="Allow Spell Cast">;
var(QuickCombat) protectedwrite float					mQuickCombatSpellSubBaseValue				<DisplayName="Spell Substitute Base Value">;
var(QuickCombat) protectedwrite float					mQuickCombatSpellSubFactor					<DisplayName="Spell Substitute Value Factor">;
var(QuickCombat) protectedwrite float					mQuickCombatSpellExponentBaseRank			<DisplayName="Spell Substitute Rank Exponent Base">;
var(QuickCombat) protectedwrite float					mQuickCombatSpellExponentBaseTier			<DisplayName="Spell Substitute Tier Exponent Base">;
var(QuickCombat) protectedwrite float					mQuickCombatArmyRelationThreshold			<DisplayName="Army Relation Threshold">;
var(QuickCombat) protectedwrite float	                mQuickCombatWarcryAttackBonusFactor			<DisplayName="Warcry attack bonus factor">;
var(QuickCombat) protectedwrite float	                mQuickCombatWarcryAttackBonusMultiplier		<DisplayName="Warcry attack bonus multiplier (connected to the Warcry buff)">;
var(QuickCombat) protectedwrite array<H7BaseAbility>	mQuickCombatMoraleImmunityCriteria			<DisplayName="Morale Immunity Criteria (Creatures with these abilities cannot get a morale turn)">;
var(QuickCombat) protectedwrite H7Skill	                mQuickCombatWarcrySkillReference			<DisplayName="Skill to compare the Warcry rank to">;
var(QuickCombat) protectedwrite H7BaseAbility	        mQuickCombatSiegeAbilityReference			<DisplayName="Ability to check for Siege buff">;
var(QuickCombat) protectedwrite H7BaseAbility	        mQuickCombatWarcryAbilityReference			<DisplayName="Ability to check for Warcry buff">;
var(QuickCombat) protectedwrite H7BaseAbility	        mQuickCombatWarfareAbilityReference			<DisplayName="Ability to check for Warfare unit buff">;
var(QuickCombat) protectedwrite H7BaseAbility	        mQuickCombatAttackWarfareReference			<DisplayName="Ability to check for attack Warfare unit buff">;
var(QuickCombat) protectedwrite bool					mQuickCombatOutputToLog			            <DisplayName="DEBUG: Output to Log">;
var(QuickCombat) protectedwrite bool					mQuickCombatIgnoreHeroes		            <DisplayName="DEBUG: Ignore Heroes">;

var(Dungeon)     protectedwrite int                     mPlunderCost                                <DisplayName="Plunder Cost">;
var(Dungeon)     protectedwrite int                     mSabotageCost                               <DisplayName="Sabotage Cost">;

var(CreatureRecruitment) protectedwrite float           mCreatureUpgradeCostModifier                <DisplayName="Creature Upgrade Gold Cost Modifier">;

var(AI) protectedwrite H7AiAdventureMapConfig           mAiAdvMapConfig;

var(Visuals) protectedwrite ParticleSystem              mPickUpParticle                             <DisplayName="Particle effect for pickups">;
var(Visuals) protectedwrite ParticleSystem              mLevelUpParticle                            <DisplayName="Particle effect for levelups">;

var(Visuals) protectedwrite Texture2D                   mNPCSymbol                                  <DisplayName="NPC Symbol">;
var(Visuals) protectedwrite Texture2D                   mQuestObjectSymbol                          <DisplayName="Quest Object Symbol">;
var(Visuals) protectedwrite Texture2D                   mFlagCrestTexture                           <DisplayName="Flag Crest Texture">;
var(Visuals) protectedwrite Texture2D                   mTownFlagIconTexture						<DisplayName="Town Flag Icon Texture">;
var(Visuals) protectedwrite Texture2D                   mFortFlagIconTexture						<DisplayName="Fort Flag Icon Texture">;
var(Visuals) protectedwrite Texture2D                   mMineFlagIconTexture						<DisplayName="Mine Flag Icon Texture">;
var(Visuals) protectedwrite Texture2D                   mGarrisonFlagIconTexture					<DisplayName="Garrison Flag Icon Texture">;
var(Visuals) protectedwrite Texture2D                   mDwellingFlagIconTexture                    <DisplayName="Dwelling Flag Icon Texture">;
var(Visuals) protectedwrite Texture2D                   mPlunderFlagIconTexture                     <DisplayName="Plundered Mine Flag Icon Texture">;
var(Visuals) protectedwrite ParticleSystem              mRevealFogParticle                          <DisplayName="Fog Reveal Preview Particle">;

