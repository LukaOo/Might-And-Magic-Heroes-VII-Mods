//=============================================================================
// H7AiActionUpgradeCreatures
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionUpgradeCreatures extends H7AiActionBase;

var protected H7AiUtilityUpgradeCreatureScore   mUUpgradeCreatureScore;

function String DebugName()
{
	return "Upgrade Creatures";
}

function Setup()
{
	mUUpgradeCreatureScore = new class'H7AiUtilityUpgradeCreatureScore';
	mABID=__AID_MAX;
}

/// override function(s)

function RunScoresTown( H7AiAdventureSensors sensors, H7AreaOfControlSiteLord currentControlSite, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local AiActionScore         score;
	local H7AiSensorInputConst  sic;
	local H7Town                town;
	local array<float>          utUpgradeCreature;
	local int                   k;
	local H7AdventureArmy       garArmy, visArmy;
	local array<H7BaseCreatureStack>    crStack;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	town=H7Town(currentControlSite);
	if(town==None) return; // should never be called if site is not a town so ..

	sic.SetTargetVisSite(currentControlSite,true);
	sic.SetTargetCellAdv(currentControlSite.GetEntranceCell());

	garArmy = town.GetGarrisonArmy();
	visArmy = town.GetVisitingArmy();
	if((garArmy!=None && garArmy.GetNumberOfFilledSlots()>=1) || (visArmy!=None && visArmy.GetNumberOfFilledSlots()>=1))
	{
		// collect army creatures
		if(garArmy!=None)
		{
			crStack=garArmy.GetBaseCreatureStacks();
//			`LOG_AI("Garrison Army present" @ garArmy @ "with" @ crStack.Length @ "creature stacks.");
		}

		sic.SetTargetArmyAdv(garArmy,true);

		for(k=0;k<crStack.Length;k++)
		{
			if(crStack[k]!=None && crStack[k].GetStackSize()>0)
			{
				score.score = 0.0f;
				score.dbgString = "Action.UpgradeCreatures; " $ town.GetName() $ "-" $ garArmy $ "-" $ crStack[k].GetStackType().GetName() $ "; ";

				sic.SetTargetBaseCreatureStack(crStack[k]);

				mUUpgradeCreatureScore.UpdateInput();
				mUUpgradeCreatureScore.UpdateOutput();
				utUpgradeCreature = mUUpgradeCreatureScore.GetOutValues();
				if(utUpgradeCreature.Length>0)
				{
					score.score = utUpgradeCreature[0];
				}

				if(score.score>0.0f)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetVisSite(APID_1,sic.GetTargetVisSite());
					score.params.SetAdventureArmy(APID_2,sic.GetTargetArmyAdv());
					score.params.SetBaseCreatureStack(APID_3,sic.GetTargetBaseCreatureStack());

					score.dbgString = score.dbgString $ "; ";

					scores.AddItem(score);
				}
			}
		}

		// collect army creatures
		crStack.Remove(0,crStack.Length);
		if(visArmy!=None)
		{
			crStack=visArmy.GetBaseCreatureStacks();
//			`LOG_AI("Visiting Army present" @ visArmy @ "with" @ crStack.Length @ "creature stacks.");
		}

		sic.SetTargetArmyAdv(visArmy,true);

		for(k=0;k<crStack.Length;k++)
		{
			if(crStack[k]!=None && crStack[k].GetStackSize()>0)
			{
				score.score = 0.0f;
				score.dbgString = "Action.UpgradeCreatures; " $ town.GetName() $ "-" $ visArmy $ "-" $ crStack[k].GetStackType().GetName() $ "; ";

				sic.SetTargetBaseCreatureStack(crStack[k]);

				mUUpgradeCreatureScore.UpdateInput();
				mUUpgradeCreatureScore.UpdateOutput();
				utUpgradeCreature = mUUpgradeCreatureScore.GetOutValues();
				if(utUpgradeCreature.Length>0)
				{
					score.score = utUpgradeCreature[0];
				}

				if(score.score>0.0f)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetVisSite(APID_1,sic.GetTargetVisSite());
					score.params.SetAdventureArmy(APID_2,sic.GetTargetArmyAdv());
					score.params.SetBaseCreatureStack(APID_3,sic.GetTargetBaseCreatureStack());

					score.dbgString = score.dbgString $ "; ";

					scores.AddItem(score);
				}
			}
		}
	}
}

function bool PerformActionTown( H7AreaOfControlSiteLord site, AiActionScore score )
{
	local H7Town            town;
	local H7AdventureArmy   army;
	local H7BaseCreatureStack   crStack;

	town = H7Town(score.params.GetVisSite(APID_1));
	army = score.params.GetAdventureArmy(APID_2);
	crStack = score.params.GetBaseCreatureStack(APID_3);
	if(town!=None && army!=None && crStack!=None)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return town.UpgradeUnitAI(army,crStack);
	}
	return false;
}
