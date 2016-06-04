//=============================================================================
// H7AiActionChillAroundTown
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionChillAroundTown extends H7AiActionBase;

var protected H7AiUtilityChillScore          mUChillScore;

function String DebugName()
{
	return "Chill";
}

function Setup()
{
	mUChillScore = new class'H7AiUtilityChillScore';
	mABID=AID_Chill;
}

/// override function(s)

function RunScoresAdv( H7AiAdventureSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, optional H7AdventureConfiguration cfg )
{
	local int               k,l;
	local AiActionScore     score;
	local H7AiSensorInputConst    sic;
	local array<float>      utChill;
	local int               numTowns;
	local H7AdventureHero   hero;
	local H7Town            town;
	local H7AiConfigCompound  actionCfg;
	local H7AiHeroAgCompound2  heroCfg;
	local array<H7HeroAbility>      spells;
	local H7HeroAbility             spell;
	local float            tensionValue, aocMod;

//	`LOG_AI("Action.Chill");

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;
	
	hero=H7AdventureHero(currentUnit);
	if(hero!=None)
	{
		switch(hero.GetAiRole())
		{
			case HRL_GENERAL:   actionCfg = cfg.mAiAdvMapConfig.mConfigChill.General; break;
			case HRL_MAIN:      actionCfg = cfg.mAiAdvMapConfig.mConfigChill.Main; break;
			case HRL_SECONDARY: actionCfg = cfg.mAiAdvMapConfig.mConfigChill.Secondary; break;
			case HRL_SCOUT:     actionCfg = cfg.mAiAdvMapConfig.mConfigChill.Scout; break;
			case HRL_SUPPORT:   actionCfg = cfg.mAiAdvMapConfig.mConfigChill.Support; break;
			case HRL_MULE:      actionCfg = cfg.mAiAdvMapConfig.mConfigChill.Mule; break;
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

	

	// look for recall spell
	hero.GetSpells(spells);
	foreach spells(spell)
	{
		if( spell.GetArchetypeID() == "A_InstantRecall" )
		{
			sic.SetUseHeroAbility(spell);
		}
	}

	tensionValue = hero.GetAdventureArmy().GetAiTensionValue(AID_Chill);

	numTowns=sic.GetTownsNum();
//	`LOG_AI("Num Towns:" @ numTowns );
	for( k = 0; k < numTowns; k++ )
	{
		// for all owned towns
		for( l=0; l<numTowns; l++ )
		{
			town=sic.GetTown(l);
			sic.SetTargetCellAdv( GetRandomCellAroundSite( town ) );
//			`LOG_AI("    Town" @ town @ town.GetName() );

			score.score =0.0f;
			score.dbgString = "Action.Chill; " $ town.GetName() $ "; ";

			sic.SetTargetVisSite(town,true);

			mUChillScore.UpdateInput();
			mUChillScore.UpdateOutput();
			utChill = mUChillScore.GetOutValues();
			if( utChill.Length >= 1 && utChill[0] > 0.0f )
			{
				aocMod=hero.GetPlayer().CalcAiAoCModifierFromTargetSite(actionCfg,town);
				score.score = utChill[0] * heroCfg.Chill;
			}

			score.dbgString = score.dbgString $ "heroCfg.Chill(" $ heroCfg.Chill $ ") aocMod(" $ aocMod $ ") ";

			if( score.score > actionCfg.Cutoff )
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetVisSite( APID_1, sic.GetTargetVisSite( ) );
				if( mUChillScore.usedRecall==true )
				{
					score.params.SetAbility( APID_2, sic.GetUseHeroAbility() );
					score.dbgString = score.dbgString $ "(recall) ";
				}
				score.tension = actionCfg.Tension.Base;

				score.dbgString = score.dbgString $ "actionCfg.Cutoff(" $ actionCfg.Cutoff $ ") " $ "actionCfg.Low-High(" $ actionCfg.Low $ ":" $ actionCfg.High $ ") ";

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
	local H7AdventureGridManager gridManager;
	local H7VisitableSite site;
	local H7HeroAbility spell;
	local H7InstantCommandTeleportToTown command;
	local H7AdventureMapCell cell;
	local H7AdventureHero   hero;
	local H7Town town;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	ctrl = class'H7AdventureController'.static.GetInstance();
	gridManager = class'H7AdventureGridManager'.static.GetInstance();

	if( unit != None && ctrl != None )
	{
		hero=H7AdventureHero(unit);
		if(hero!=None)
		{
		}

		site = score.params.GetVisSite(APID_1);
		town = H7Town( site );
		spell = H7HeroAbility(score.params.GetAbility(APID_2));
		if(site!=None)
		{
			if( spell != none && 
				town.IsBuildingBuiltByClass(class'H7TownPortal') && 
				town.GetEntranceCell().GetArmy() == none && 
				town.GetEntranceCell().GetGridOwner() == hero.GetAdventureArmy().GetCell().GetGridOwner() )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

				command = new class'H7InstantCommandTeleportToTown';
				command.Init(town, hero, spell.GetManaCost());
				class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
				if( hero.GetAdventureArmy().GetCell() == site.GetEntranceCell() )
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				cell = GetRandomCellAroundSite( site );
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				
				if( cell != none )
				{
					hero.GetAdventureArmy().SetChilling( true );
					return gridManager.DoMoveToCell( cell, true, true );
				}
				return false;
			}
		}
	}
	return false;
}

function H7AdventureMapCell GetRandomCellAroundSite( H7VisitableSite site )
{
	local IntPoint dim;
	local array<H7AdventureMapCell> cells, neighbours, cellsOut;
	local H7AdventureMapCell cell;
	local bool dropCell;
	local int i;

	dim.X = 5;
	dim.Y = 5;
	
	site.GetEntranceCell().GetGridOwner().GetCellsFromDimensions( site.GetEntranceCell(), dim, cells,, true );

	for( i = cells.Length-1; i >= 0; --i )
	{
		dropCell=false;

		if( cells[i].mMovementType == MOVTYPE_IMPASSABLE || 
			cells[i].GetMovementCost() == INDEX_NONE || 
			cells[i].GetVisitableSite() != none && cells[i].GetVisitableSite().GetEntranceCell() == cells[i] || cells[i].HasHostileArmy( site.GetPlayer() ) )
		{
			//cells.Remove( i, 1 );
			dropCell=true;
			continue;
		}
		neighbours = cells[i].GetNeighbours();
		foreach neighbours( cell )
		{
			if( cell.GetVisitableSite() != none && cell.GetVisitableSite().GetEntranceCell() == cell || cell.HasHostileArmy( site.GetPlayer() ) )
			{
				// removing a cell at index multiple times and continue iterating ... bad idea!
				//cells.Remove( i, 1 );
				dropCell=true;
			}
		}
		if(dropCell==false)
		{
			cellsOut.AddItem(cells[i]);
		}
	}
	if( cellsOut.Length > 0 )
	{
		return cellsOut[ Rand(cellsOut.Length-1) ];
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return none;
	}
}
