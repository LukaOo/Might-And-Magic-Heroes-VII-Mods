//=============================================================================
// H7AiUtilityHeAbilityTsunami
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityTsunami extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellAreaDamage  mUSpellDamage;

function H7CombatMapCell GetOptimalTsunamiTargetCell(H7CombatHero hero, int trows)
{
	local H7CombatMapCell cell;
	local array<H7CreatureStack>    cstacks;
	local H7CreatureStack cstack;
	local array<int> xpos;
	local int c, k, sizex, creatureCount, bestCreatureCount;
	local H7CombatMapGridController gridController;
	local int trowsHalf;

	if(hero==None) return None;
	
	cell=None;

	gridController = class'H7CombatMapGridController'.static.GetInstance();
	sizex=gridController.GetGridSizeX();
	trowsHalf=trows/2;
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
			xpos.AddItem( cstack.GetGridPosition().X );
		}
	}
	
	bestCreatureCount=0;

	for(c=0;c<(sizex-trows);c++)
	{
		creatureCount=0;
		for(k=0;k<xpos.Length;k++)
		{
			if(xpos[k]>=c && xpos[k]<(c+trows))
			{
				creatureCount++;
			}
		}
		if(creatureCount>bestCreatureCount)
		{
			bestCreatureCount=creatureCount;
			cell=gridController.GetCombatGrid().GetCellByPos(c+trowsHalf,0);
		}
	}
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	return cell;
}

/// overrides ...
function UpdateInput()
{
	local array<float>              uDamage;

//	`LOG_AI("Utility.HeAbilityTsunami");

	if(mUSpellDamage==None) { mUSpellDamage = new class'H7AiUtilitySpellAreaDamage'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellDamage.mFBias=0.25f;
	mUSpellDamage.UpdateInput();
	mUSpellDamage.UpdateOutput();
	uDamage = mUSpellDamage.GetOutValues();

	if(uDamage.Length>0 && uDamage[0]>0.0f)
	{
		uDamage[0]=2.0f; // MAKE SURE IT IS CASTED
		mInValues.AddItem(uDamage[0]);
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

