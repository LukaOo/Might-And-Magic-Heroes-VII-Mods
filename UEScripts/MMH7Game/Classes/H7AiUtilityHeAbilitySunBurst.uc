//=============================================================================
// H7AiUtilityHeAbilitySunBurst
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilitySunBurst extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellAreaDamage  mUSpellDamage;

function H7CombatMapCell GetOptimalSunBurstTargetCell(H7CombatHero hero )
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
	for(x=3;x<(gridController.GetGridSizeX()-3);x++)
	{
		for(y=3;y<(gridController.GetGridSizeY()-3);y++)
		{
			creatureCount=0;
			for(k=0;k<pos.Length;k++)
			{
				if( pos[k].X==x || pos[k].Y==y || abs(pos[k].X-x) == abs(pos[k].Y-y) )
				{
					creatureCount++;
				}
			}
			if(creatureCount>bestCreatureCount)
			{
				bestCreatureCount=creatureCount;
				cell=gridController.GetCombatGrid().GetCellByPos(x,y);
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

//	`LOG_AI("Utility.HeAbilitySunBurst");

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

