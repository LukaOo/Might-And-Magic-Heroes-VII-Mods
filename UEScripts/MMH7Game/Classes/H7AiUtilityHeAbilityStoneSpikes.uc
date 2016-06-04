//=============================================================================
// H7AiUtilityHeAbilityStoneSpikes
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityStoneSpikes extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellAreaDamage  mUSpellDamage;

function H7CombatMapCell GetOptimalStoneSpikeTargetCell(H7CombatHero hero)
{
	local H7CombatMapCell           cell;
	local array<H7CreatureStack>    cstacks;
	local H7CreatureStack           cstack;
	local array<IntPoint>           pos;
	local int                       x,y,k, creatureCount, bestCreatureCount;
	local H7CombatMapGridController gridController;

	if(hero==None) return None;
	
	cell=None;
	gridController = class'H7CombatMapGridController'.static.GetInstance();
	if(hero.IsAttacker()==true) {
		cstacks=class'H7CombatController'.static.GetInstance().GetArmyDefender().GetCreatureStacks();
	}
	else {
		cstacks=class'H7CombatController'.static.GetInstance().GetArmyAttacker().GetCreatureStacks();
	}
	foreach cstacks(cstack)
	{
		if(cstack!=None && cstack.IsDead()==false && cstack.IsOffGrid()==false && cstack.IsVisible()==true)
		{
			pos.AddItem( cstack.GetGridPosition() );
		}
	}
	
	bestCreatureCount=0;
	for(x=1;x<(gridController.GetGridSizeX()-2);x++)
	{
		for(y=1;y<(gridController.GetGridSizeY()-2);y++)
		{
			creatureCount=0;
			for(k=0;k<pos.Length;k++)
			{
				if( pos[k].X==(x+0) && pos[k].Y==(y+1) ||
					pos[k].X==(x+1) && pos[k].Y==(y+1) ||
					pos[k].X==(x+2) && pos[k].Y==(y+1) ||
					pos[k].X==(x+1) && pos[k].Y==(y+0) ||
					pos[k].X==(x+1) && pos[k].Y==(y+2) )
				{
					creatureCount++;
				}
			}
			if(creatureCount>bestCreatureCount)
			{
				bestCreatureCount=creatureCount;
				cell=gridController.GetCombatGrid().GetCellByPos(x+1,y+1);
			}
		}
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	return cell;
}

/// overrides ...
function UpdateInput()
{
	local array<float>              uDamage;

//	`LOG_AI("Utility.HeAbilityStoneSpike");

	if(mUSpellDamage==None) { mUSpellDamage = new class'H7AiUtilitySpellAreaDamage'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellDamage.mFBias=0.4f;
	mUSpellDamage.UpdateInput();
	mUSpellDamage.UpdateOutput();
	uDamage = mUSpellDamage.GetOutValues();

	if(uDamage.Length>0 && uDamage[0]>0.0f)
	{
		mInValues.AddItem(uDamage[0]);
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

