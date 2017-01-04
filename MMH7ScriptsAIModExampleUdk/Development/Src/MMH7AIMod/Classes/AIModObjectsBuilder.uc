class AIModObjectsBuilder extends H7BaseGameController;

function AIModH7AiCombatMap createCombatAI(H7BaseGameController controller)
{
	return Spawn(class'AIModH7AiCombatMap', controller);
}

function array<H7AiSensorBase> createAdventureAISensors()
{
	local array<H7AiSensorBase>     mSensors;
	mSensors.InsertItem(AAS_ArmyStrength,new class 'H7AiSensorArmyStrength');
	mSensors.InsertItem(AAS_ArmyStrengthCombined,new class 'H7AiSensorArmyStrengthCombined');
	mSensors.InsertItem(AAS_DistanceToTarget,new class 'H7AiSensorDistanceToTarget');
	mSensors.InsertItem(AAS_TargetInterest,new class 'H7AiSensorTargetInterest');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedNoHero,new class 'H7AiSensorArmyStrengthCombinedNoHero');
	mSensors.InsertItem(AAS_HeroCount,new class 'H7AiSensorHeroCount');
	mSensors.InsertItem(AAS_GameProgress,new class 'H7AiSensorGameProgress');
	mSensors.InsertItem(AAS_TownDistance,new class 'H7AiSensorTownDistance');
	mSensors.InsertItem(AAS_PlayerArmiesCompare,new class 'H7AiSensorPlayerArmiesCompare');
	mSensors.InsertItem(AAS_PoolGarrison,new class 'H7AiSensorPoolGarrison');
	mSensors.InsertItem(AAS_TownBuilding,new class 'H7AiSensorTownBuilding');
	mSensors.InsertItem(AAS_GameDayOfWeek,new class 'H7AiSensorGameDayOfWeek');
	mSensors.InsertItem(AAS_TradeResource,new class 'H7AiSensorTradeResource');
	mSensors.InsertItem(AAS_ResourceStockpile,new class 'H7AiSensorResourceStockpile');
	mSensors.InsertItem(AAS_TownDefense,new class 'H7AiSensorTownDefense');
	mSensors.InsertItem(AAS_TownArmyCount,new class 'H7AiSensorTownArmyCount');
	mSensors.InsertItem(AAS_HireHeroCount,new class 'H7AiSensorHireHeroCount');
	mSensors.InsertItem(AAS_SiteAvailable,new class 'H7AiSensorSiteAvailable');
	mSensors.InsertItem(AAS_InstantRecall,new class 'H7AiSensorRecall');
	mSensors.InsertItem(AAS_TeleportInterest,new class 'H7AiSensorTeleportInterest');
	mSensors.InsertItem(AAS_CanUpgrade,new class 'H7AiSensorCanUpgrade');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedReverse,new class 'H7AiSensorArmyStrengthCombinedReverse');
	mSensors.InsertItem(AAS_UpgradeStrength,new class 'H7AiSensorUpgradeStrength');
	mSensors.InsertItem(AAS_TownThreat,new class 'H7AiSensorTownThreat');
	mSensors.InsertItem(AAS_TargetThreat,new class 'H7AiSensorAdvTargetThreat');
	mSensors.InsertItem(AAS_TargetCutoffRange, new class 'H7AiSensorTargetCutoffRange');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedGlobal,new class 'H7AiSensorArmyStrengthCombinedGlobal');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedGlobalReverse,new class 'H7AiSensorArmyStrengthCombinedGlobalReverse');
	return mSensors;
}

function array<H7AiSensorBase> createCombatAISensors()
{
	local array<H7AiSensorBase>     mSensors;
	mSensors.InsertItem(ACS_ArmyHasRangeAttack,new class 'H7AiSensorArmyHasRangeAttack');
	mSensors.InsertItem(ACS_GridCellReachable,new class 'H7AiSensorGridCellReachable');
	mSensors.InsertItem(ACS_GeomDistance,new class 'H7AiSensorGeomDistance');
	mSensors.InsertItem(ACS_CanRangeAttack, new class 'H7AiSensorCanRangeAttack');
	mSensors.InsertItem(ACS_CanRetaliate, new class 'H7AiSensorCanRetaliate' );
	mSensors.InsertItem(ACS_ThreatLevel, new class 'H7AiSensorThreatLevel' );
	mSensors.InsertItem(ACS_HasAdjacentEnemy, new class 'H7AiSensorHasAdjacentEnemy' );
	mSensors.InsertItem(ACS_HasAdjacentAlly, new class 'H7AiSensorHasAdjacentAlly' );
	mSensors.InsertItem(ACS_HPPercentLoss, new class 'H7AiSensorHPPercentLossAttack' );
	mSensors.InsertItem(ACS_HPPercentLossRetaliate, new class 'H7AiSensorHPPercentLossRetaliation' );
	mSensors.InsertItem(ACS_CanMoveAttack, new class 'H7AiSensorCanMoveAttack' );
	mSensors.InsertItem(ACS_HasGreaterDamage, new class 'H7AiSensorHasGreaterDamage' );
	mSensors.InsertItem(ACS_CanCastBuff, new class 'H7AiSensorCanCastBuff' );
	mSensors.InsertItem(ACS_MeleeCasualityCount, new class 'H7AiSensorMeleeCasualityCount' );
	mSensors.InsertItem(ACS_MeleeCreatureDamage, new class 'H7AiSensorMeleeCreatureDamage' );
	mSensors.InsertItem(ACS_RangeCasualityCount, new class 'H7AiSensorRangeCasualityCount' );
	mSensors.InsertItem(ACS_RangeCreatureDamage, new class 'H7AiSensorRangeCreatureDamage' );
	mSensors.InsertItem(ACS_ManaCost, new class 'H7AiSensorManaCost' );
	mSensors.InsertItem(ACS_SpellTargetCheck, new class 'H7AiSensorSpellTargetCheck' );
	mSensors.InsertItem(ACS_HealingPercentage, new class 'H7AiSensorHealingPercentage' );
	mSensors.InsertItem(ACS_AbilityCasualityCount, new class 'H7AiSensorAbilityCasualityCount' );
	mSensors.InsertItem(ACS_AbilityCreatureDamage, new class 'H7AiSensorAbilityCreatureDamage' );
	mSensors.InsertItem(ACS_Opportunity, new class 'H7AiSensorOpportunity' );
	mSensors.InsertItem(ACS_SpellSingleDamage, new class 'H7AiSensorSpellSingleDamage' );
	mSensors.InsertItem(ACS_SpellMultiDamage, new class 'H7AiSensorSpellMultiDamage' );
	mSensors.InsertItem(ACS_SpellSingleHeal, new class 'H7AiSensorSpellSingleHeal' );
	mSensors.InsertItem(ACS_SpellMultiHeal, new class 'H7AiSensorSpellMultiHeal' );
	mSensors.InsertItem(ACS_CreatureCount, new class 'H7AiSensorCreatureCount' );
	mSensors.InsertItem(ACS_CreatureStrength, new class 'H7AiSensorCreatureStrength' );
	mSensors.InsertItem(ACS_MoveDistance, new class 'H7AiSensorStackMoveDistance' );
	mSensors.InsertItem(ACS_CreatureStat, new class 'H7AiSensorCreatureStat' );
	mSensors.InsertItem(ACS_CreatureIsRanged, new class 'H7AiSensorCreatureIsRanged' );
	mSensors.InsertItem(ACS_CreatureAdjacentToEnemy, new class 'H7AiSensorCreatureAdjacentToEnemy' );
	mSensors.InsertItem(ACS_CreatureAdjacentToAlly, new class 'H7AiSensorCreatureAdjacentToAlly' );
	mSensors.InsertItem(ACS_CreatureTier, new class 'H7AiSensorCreatureTier' );
	mSensors.InsertItem(ACS_CreatureCanAttack, new class 'H7AiSensorCreatureCanAttack' );
	mSensors.InsertItem(ACS_CreatureCanBeAttacked, new class 'H7AiSensorCreatureCanBeAttacked' );
	mSensors.InsertItem(ACS_RangedCreatureCount, new class 'H7AiSensorRangedCreatureCount' );
	mSensors.InsertItem(ACS_GoodTimeToWait, new class 'MyH7AiSensorGoodTimeToWait' );
	mSensors.InsertItem(ACS_RunePlacement, new class 'H7AiSensorRunePlacement' );
	mSensors.InsertItem(ACS_DefensiveRuneImpact, new class 'H7AiSensorDefensiveRuneOpportunity' );
	mSensors.InsertItem(ACS_OffensiveRuneImpact, new class 'H7AiSensorOffensiveRuneOpportunity' );
	mSensors.InsertItem(ACS_TargetCoverage, new class 'H7AiSensorTargetCoverage' );
	mSensors.InsertItem(ACS_GoodTimeToFleeSurrender, new class 'H7AiSensorGoodTimeToFleeSurrender' );
	mSensors.InsertItem(ACS_WarcryBenefit, new class 'H7AiSensorWarcryBenefit' );
	mSensors.InsertItem(ACS_GoldLoss, new class 'H7AiSensorInflictedGoldLoss' );
	return mSensors;
}
