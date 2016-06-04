//=============================================================================
// H7AiUtilityHeAbilityBlizzard
//=============================================================================
// Creates a Blizzard on a 4x4 area for 3 turns.
// The duration of the blizzard is reduced at the end of each combat round.
// Effect: Every stack starting its turn in the Blizzard`s area gets a debuff 
// until the end of the stack's turn.
// Debuff effect: the creatures movement is reduced by (1) (but not below 1)
//    unskilled: 1
//    novice: 2
//    expert: 3
//    master: 5
// That effect is a movement reduction effect.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityBlizzard extends H7AiUtilityCombiner;

function H7CombatMapCell GetOptimalBlizzardTargetCell(H7CombatHero hero, IntPoint dimension )
{
	local H7CombatMapCell           cell;
	local array<H7CreatureStack>    cstacks, cstacksA;
	local H7CreatureStack           cstack;
	local array<IntPoint>           pos,posA;
	local array<int>                size, sizeA;
	local array<int>                id;
	local int                       x,y,k, creatureCount, bestCreatureCount, creatureCountA;
	local H7CombatMapGridController gridController;
	local int                       dx2, dy2;

	if(hero==None) return None;
	dx2=(dimension.X-1)/2;
	dy2=(dimension.Y-1)/2;
	cell=None;
	gridController = class'H7CombatMapGridController'.static.GetInstance();

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if(hero.IsAttacker()==true) {
		cstacks=class'H7CombatController'.static.GetInstance().GetArmyDefender().GetCreatureStacks();
		cstacksA=class'H7CombatController'.static.GetInstance().GetArmyAttacker().GetCreatureStacks();
	}
	else {
		cstacks=class'H7CombatController'.static.GetInstance().GetArmyAttacker().GetCreatureStacks();
		cstacksA=class'H7CombatController'.static.GetInstance().GetArmyDefender().GetCreatureStacks();
	}

	foreach cstacks(cstack)
	{
		if(cstack!=None && cstack.IsDead()==false && cstack.IsOffGrid()==false && cstack.IsVisible()==true)
		{
			pos.AddItem( cstack.GetGridPosition() );
			size.AddItem(cstack.GetUnitBaseSizeInt()-1);
		}
	}
	foreach cstacksA(cstack)
	{
		if(cstack!=None && cstack.IsDead()==false && cstack.IsOffGrid()==false && cstack.IsVisible()==true)
		{
			posA.AddItem( cstack.GetGridPosition() );
			sizeA.AddItem(cstack.GetUnitBaseSizeInt()-1);
		}
	}
	
	bestCreatureCount=0;
	dx2=dimension.X/2;
	dy2=dimension.Y/2;
	for(x=0;x<(gridController.GetGridSizeX()-dimension.X);x++)
	{
		for(y=0;y<(gridController.GetGridSizeY()-dimension.Y);y++)
		{
			creatureCount=0;
			creatureCountA=0;
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
			for(k=0;k<posA.Length;k++)
			{
				// check if creature base overlaps with spell area
				if( x > (posA[k].X + sizeA[k]) ) continue;
				if( (x + dimension.X) < posA[k].X ) continue;
				if( y > (posA[k].Y + sizeA[k]) ) continue;
				if( (y + dimension.Y) < posA[k].Y ) continue;

				if(id.Find(k)==INDEX_NONE)
				{
					id.AddItem(k);
					creatureCountA++;
				}
			}
			id.Remove(0,id.Length);
			if((creatureCount-creatureCountA)>bestCreatureCount)
			{
				bestCreatureCount=creatureCount-creatureCountA;
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
//	`LOG_AI("Utility.HeAbilityBlizzard");

	mInValues.Remove(0,mInValues.Length);
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

