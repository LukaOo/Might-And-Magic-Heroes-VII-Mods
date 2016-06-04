//=============================================================================
// H7AiUtilityHeAbilityFireBall
//=============================================================================
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityFireBall extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellAreaDamage  mUSpellDamage;

function H7CombatMapCell GetOptimalFireBallTargetCell(H7CombatHero hero, IntPoint dimension )
{
	local H7CombatMapCell           cell;
	local array<H7CreatureStack>    cstacks;
	local H7CreatureStack           cstack;
	local array<IntPoint>           pos;
	local array<int>                size;
	local array<int>                id;
	local int                       x,y,k, creatureCount, bestCreatureCount;
	local H7CombatMapGridController gridController;
	local int                       dx2, dy2;

	if(hero==None) return None;
	
	gridController = class'H7CombatMapGridController'.static.GetInstance();
	cell=None;
	dx2=(dimension.X-1)/2;
	dy2=(dimension.Y-1)/2;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

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
			pos.AddItem(cstack.GetGridPosition());
			size.AddItem(cstack.GetUnitBaseSizeInt()-1);
		}
	}
	
	bestCreatureCount=0;
	for(x=0;x<gridController.GetGridSizeX();x++)
	{
		for(y=0;y<gridController.GetGridSizeY();y++)
		{
			creatureCount=0;
			for(k=0;k<pos.Length;k++)
			{
				// check if creature base overlaps with spell area
				if( x > (pos[k].X + size[k]) ) continue;
				if( (x + dimension.X) < pos[k].X ) continue;
				if( y > (pos[k].Y + size[k]) ) continue;
				if( (y + dimension.Y) < pos[k].Y ) continue;

				if(id.Find(k)==INDEX_NONE)
				{
					id.AddItem(k);
					creatureCount++;
				}
			}
			id.Remove(0,id.Length);
			if(creatureCount>bestCreatureCount)
			{
				bestCreatureCount=creatureCount;
				cell=gridController.GetCombatGrid().GetCellByPos(x+dx2,y+dy2);
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

//	`LOG_AI("Utility.HeAbilityFireBall");

	if(mUSpellDamage==None) { mUSpellDamage = new class'H7AiUtilitySpellAreaDamage'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellDamage.mFBias=0.25f;
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

