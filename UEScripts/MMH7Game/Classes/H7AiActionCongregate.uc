//=============================================================================
// H7AiActionCongregate
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionCongregate extends H7AiActionBase;

var protected H7AiUtilityCongregate         mUCongregate;

function String DebugName()
{
	return "Congregate";
}

function Setup()
{
	mUCongregate = new class'H7AiUtilityCongregate';
	mABID=AID_Congregate;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utCongregate;
	local int               numHeroes;
	local H7AdventureHero   hero;
	local H7AdventureHero   conHero;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local float            tensionValue, aocMod;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigCongregate.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigCongregate.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigCongregate.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigCongregate.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigCongregate.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigCongregate.Mule; break;
		}

		switch(hero.GetAiControlType())
		{
			case HCT_STANDARD:  heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Standard; break;
			case HCT_EXPLORER:  heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Explorer; break;
			case HCT_GATHERER:  heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Gatherer; break;
			case HCT_HOMEGUARD: heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.Homeguard; break;
			case HCT_GENERAL:   heroCfg = cfg.mAiAdvMapConfig.mConfigHeroes2.General; break;
		}
	}

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Congregate);

	mUCongregate.mMovementEffortBias=actionCfg.MovementEffortBias;
	mUCongregate.mReinforcementBias=actionCfg.ReinforcementBias;

	// for all allied heroes that are not MAIN (nor SECONDARY) ...
	// they enforce the trade onto the main hero
	numHeroes=sic.GetOwnHeroesNum();
	if(numHeroes>actionCfg.ProximityTargetLimit) numHeroes=actionCfg.ProximityTargetLimit;
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	for( k = 0; k < numHeroes; k++ )
	{
		conHero=sic.GetOwnHeroes(k);

		if( conHero != None && conHero != hero &&                                           // can't trade with himself
			conHero.GetAdventureArmy().IsGarrisoned() == false &&							// target hero is out in the fields
			hero.GetAiRole() != conHero.GetAiRole() && 
			(hero.GetAiRole() == HRL_SCOUT || hero.GetAiRole() == HRL_SUPPORT || hero.GetAiRole() == HRL_MULE || hero.GetAiRole() == HRL_SECONDARY) &&     // unit needs to be expendable hero
			(conHero.GetAiRole() == HRL_MAIN || conHero.GetAiRole() == HRL_SECONDARY || conHero.GetAiRole() == HRL_GENERAL) )    // target hero we like to boost with our army/items
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

			score.score=0.0f;
			score.dbgString = "Action.Congregate; " $ hero.GetName() $ "-" $ conHero.GetName() $ "; ";

			sic.SetTargetVisSite(None,true);
			sic.SetTargetArmyAdv(conHero.GetAdventureArmy(),true);
			sic.SetTargetCellAdv(conHero.GetAdventureArmy().GetCell());


			mUCongregate.UpdateInput();
			mUCongregate.UpdateOutput();
			utCongregate = mUCongregate.GetOutValues();
			if( utCongregate.Length >= 1 && utCongregate[0] > 0.0f )
			{
				aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetArmy(actionCfg,sic.GetTargetArmyAdv());
				score.score = utCongregate[0] * heroCfg.Congregate * aocMod;
			}

			score.dbgString = score.dbgString $ "heroCfg.Congregate(" $ heroCfg.Congregate $ ") aocMod(" $ aocMod $ ") ";

			if( score.score > actionCfg.Cutoff )
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
				score.tension = actionCfg.Tension.Base;

				score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") " $ mUCongregate.dbgString;

				if(score.score>1.0f) score.score=1.0f;
				score.score  = Lerp( actionCfg.Low, actionCfg.High, score.score );

				score.score *= tensionValue;
				score.dbgString = score.dbgString $ "Tension(" $ tensionValue $ ") FINAL SCORE:" $ score.score;

				scores.AddItem( score );
			}
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7AdventureController ctrl;
	local H7AdventureArmy army;
	local bool perform;
	local H7AdventureHero   hero;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	ctrl = class'H7AdventureController'.static.GetInstance();

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	if( unit!=None && ctrl!=None )
	{
		hero=H7AdventureHero(unit);
		if(hero!=None)
		{
		}

		army = score.params.GetAdventureArmy(APID_1);
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( army!=None )
		{
			perform = ShouldCongregate( unit.GetAdventureArmy(), army );
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			// we have troops to give
			if( perform )
			{
				// try to move to the target
				return class'H7AdventureGridManager'.static.GetInstance().DoTradeWithArmy( army.Location, true, true );
			}
			// no point in trying since no units are left
			return false;
		}
	}
	return false;
}

protected function bool ShouldCongregate( H7AdventureArmy army, H7AdventureArmy receivingArmy )
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local int threshold;
	local float armyStrength, weakestReceiving, strongestPotential, strongestPotentialCandidate, weakestReceivingCandidate;
	local bool hasSlots;
	local bool hasSameStack;

	stacks = army.GetBaseCreatureStacks();
	
	foreach stacks( stack )
	{
		strongestPotentialCandidate = GetStackStrengthGlobal( army.GetPlayer(), stack.GetStackType() );
		if( strongestPotential < strongestPotentialCandidate )
		{
			strongestPotential = strongestPotentialCandidate;
		}
	}
	if( strongestPotential == 0 )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return false;
	}
	hasSlots = receivingArmy.GetFreeSlotCount() > 0;
	stacks = receivingArmy.GetBaseCreatureStacks();
	foreach stacks( stack )
	{
		weakestReceivingCandidate = GetStackStrengthGlobal( army.GetPlayer(), stack.GetStackType() );
		if( weakestReceiving == 0 )
		{
			weakestReceiving = weakestReceivingCandidate;
		}
		else
		{
			if( weakestReceiving > weakestReceivingCandidate && !stack.IsLockedForUpgrade() )
			{
				weakestReceiving = weakestReceivingCandidate;
			}
		}
		if( army.HasStackType( stack ) )
		{
			hasSameStack = true;
		}
	}

	if( strongestPotential <= weakestReceiving && !hasSlots && !hasSameStack )
	{
		return false;
	}


	threshold = class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigHeroCongregationMinArmyPowerThreshold;
	armyStrength = army.GetStrengthValue( false );
	stacks = army.GetBaseCreatureStacks();
	foreach stacks( stack )
	{
		//check if we can 
		if( ( armyStrength - stack.GetStackType().GetCreaturePower() ) > threshold )
		{
			return true;
		}
	}

	return false;
}

static function float GetStackStrengthGlobal( H7Player dasPlayer, H7Creature stackType )
{
	//local array<H7AdventureHero> heroes;
	//local H7AdventureHero hero;
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local float totalStrength;

	//heroes = dasPlayer.GetHeroes();
	armies = dasPlayer.GetArmies();

	foreach armies( army )
	{
		stacks = army.GetBaseCreatureStacks();
		foreach stacks( stack )
		{
			if( stack.GetStackType() == stackType )
			{
				totalStrength += stack.GetCreatureStackStrength();
			}
		}
	}
	//foreach heroes( hero )
	//{
	//	if( !hero.IsDead() )
	//	{
	//		stacks = hero.GetAdventureArmy().GetBaseCreatureStacks();
	//		foreach stacks( stack )
	//		{
	//			if( stack.GetStackType() == stackType )
	//			{
	//				totalStrength += stack.GetCreatureStackStrength();
	//			}
	//		}
	//	}
	//}

	return totalStrength;
}

static function float GetStackSizeGlobal( H7Player dasPlayer, H7Creature stackType )
{
	//local array<H7AdventureHero> heroes;
	//local H7AdventureHero hero;
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local float totalStrength;

	//heroes = dasPlayer.GetHeroes();
	armies = dasPlayer.GetArmies();

	foreach armies( army )
	{
		stacks = army.GetBaseCreatureStacks();
		foreach stacks( stack )
		{
			if( stack.GetStackType() == stackType )
			{
				totalStrength += stack.GetStackSize();
			}
		}
	}
	//foreach heroes( hero )
	//{
	//	if( !hero.IsDead() )
	//	{
	//		stacks = hero.GetAdventureArmy().GetBaseCreatureStacks();
	//		foreach stacks( stack )
	//		{
	//			if( stack.GetStackType() == stackType )
	//			{
	//				totalStrength += stack.GetCreatureStackStrength();
	//			}
	//		}
	//	}
	//}

	return totalStrength;
}
