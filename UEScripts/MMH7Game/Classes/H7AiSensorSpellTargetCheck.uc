//=============================================================================
// H7AiSensorSpellTargetCheck
//=============================================================================
// Checks the receptivity of the target for a given spell
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorSpellTargetCheck extends H7AiSensorBase;

var H7AiCombatMapConfig mCombatMapCfg;

function float QueryValue( ETargetStat stat, int categoryIdx )
{
	local AiReceptivityEntry rec;

	if(mCombatMapCfg==None) mCombatMapCfg=class'H7CombatController'.static.GetInstance().GetCombatConfiguration().mAiCombatMapConfig;

	switch(categoryIdx)
	{
		case CREATUREC_FIGHTER:     rec=mCombatMapCfg.mReceptivityTable.recEntryFighter; break;
		case CREATUREC_ROGUE:       rec=mCombatMapCfg.mReceptivityTable.recEntryRogue; break;
		case CREATUREC_MAGE:        rec=mCombatMapCfg.mReceptivityTable.recEntryMage; break;
		case CREATUREC_SHOOTER:     rec=mCombatMapCfg.mReceptivityTable.recEntryShooter; break;
		default: return 0.0f;
	}

	switch(stat)
	{
		case TS_STAT_NONE:          return 0.0f;
		case TS_STAT_HITPOINTS:     return rec.statHitpoints;
		case TS_STAT_INITIATIVE:    return rec.statInitiative;
		case TS_STAT_ATTACK:        return rec.statAttack;
		case TS_STAT_DEFENSE:       return rec.statDefense;
		case TS_STAT_LEADERSHIP:    return rec.statLeadership;
		case TS_STAT_DESTINY:       return rec.statDestiny;
		case TS_STAT_DAMAGE:        return rec.statDamage;
		case TS_STAT_MOVEMENT:      return rec.statMovement;
	}
	return 0.0f;
}

/// overrides ...
function float GetValue2( H7AiSensorParam param0, H7AiSensorParam param1 )
{
	local H7Unit unit;
	local H7Creature creature;
	local H7HeroAbility abilityHero;
	local H7CreatureAbility abilityCreature;
	local int categoryIdx;
	local array<H7BaseBuff> buffs;
	local float util;

	if( param0.GetPType() == SP_UNIT )
	{
		unit = param0.GetUnit();
		if( unit == None )	return 0.0f;
		if( unit.GetEntityType() != UNIT_CREATURESTACK ) return 0.0f;
	
		creature = H7CreatureStack(unit).GetCreature();
		if(creature==None) return 0.0f;
		
		if( param1.GetPType()==SP_HEROABILITY )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;	

			abilityHero = param1.GetHeroAbility();
			if(abilityHero==None) return 0.0f;

			// check if buff is already applied
			unit.GetBuffManager().GetBuffsFromSource(buffs,abilityHero);
			if(buffs.Length>=1)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				return 0.0f;
			}

			categoryIdx = creature.GetCreatureCategory();
			util = (QueryValue(abilityHero.GetAiTargetStatPrimary(),categoryIdx) * 2.0f + QueryValue(abilityHero.GetAiTargetStatSecondary(),categoryIdx)) / 3.0f;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;	
			return util;
		}
		else if( param1.GetPType() == SP_CREATUREABILITY )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

			abilityCreature = param1.GetCreatureAbility();
			if( abilityCreature == None ) return 0.0f;

			// check if buff is already applied
			unit.GetBuffManager().GetBuffsFromSource(buffs,abilityCreature);
			if(buffs.Length>=1)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				return 0.0f;
			}

			categoryIdx = creature.GetCreatureCategory();
			util = (QueryValue(abilityCreature.GetAiTargetStatPrimary(),categoryIdx) * 2.0f + QueryValue(abilityCreature.GetAiTargetStatSecondary(),categoryIdx)) / 3.0f;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;	
			return util;
		}
	}
	// wrong parameter type
	return 0.0f;
}

