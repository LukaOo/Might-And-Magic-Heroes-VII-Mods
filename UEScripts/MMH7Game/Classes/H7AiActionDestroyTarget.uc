//=============================================================================
// H7AiActionDestroyTarget
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionDestroyTarget extends H7AiActionBase;

var protected H7AiUtilityAttackTargetScore mUAttackTarget;

function String DebugName()
{
	return "Destroy Target";
}


function Setup()
{
	mUAttackTarget = new class'H7AiUtilityAttackTargetScore';
	mABID=__AID_MAX;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utOut;
	local float             W;
	local bool              validTarget;             
	local int               numSites;
	local H7AdventureHero   hero;
	local H7VisitableSite   targetSite;
	local H7DestructibleObjectManipulator dom;
	local H7Fort            fort;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);

	// for all site targets (that may have an defending army) ...
	numSites=sic.GetVisSiteNum();
	if(numSites>30) numSites=30;
	for( k = 0; k < numSites; k++ )
	{
		score.params = new () class'H7AiActionParam';
		score.params.Clear();

		targetSite = sic.GetVisSite(k);
		if( targetSite.IsA( 'H7Fort' ) )
		{
			fort=H7Fort(targetSite);
			if(fort!=None && fort.IsRuined()==false)
			{
				validTarget=true;
			}
		}
		else if( targetSite.IsA( 'H7DestructibleObjectManipulator' ) )
		{
			dom=H7DestructibleObjectManipulator(targetSite);
			if(dom!=None && dom.CanBeDestroyed(hero)==true)
			{
				validTarget=true;
			}
		}

		if(validTarget==true)
		{
			sic.SetTargetVisSite(sic.GetVisSite(k)); // that sets internally the targetArmy to

			mUAttackTarget.mFightingEffortModifier = hero.GetPlayer().mDifficultyAIAggressivenessMultiplier;
			mUAttackTarget.UpdateInput();
			mUAttackTarget.UpdateOutput();
			utOut = mUAttackTarget.GetOutValues();

			if( utOut.Length >= 1 )
			{
				W = utOut[0];
			}
			else
			{
				W = 0.0f;
			}
			utOut.Remove( 0, utOut.Length );

			score.score = W;
			if( score.score != 0.0f )
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetAdventureArmy( APID_1, sic.GetTargetArmyAdv() );
				score.params.SetVisSite( APID_2, sic.GetTargetVisSite( ) );
				scores.AddItem( score );
			}
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7AdventureController ctrl;
	local H7AdventureGridManager gridManager;
	local H7AdventureArmy army;
	local H7VisitableSite site;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	ctrl = class'H7AdventureController'.static.GetInstance();
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	if( unit != None && ctrl != None )
	{
		army = score.params.GetAdventureArmy(APID_1);
		site = score.params.GetVisSite(APID_2);
		if( army != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoAttackArmy( army.Location, true, true );
		}
		if( site != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			return gridManager.DoVisit( site, true, true );
		}
	}
	return false;
}
