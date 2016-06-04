//=============================================================================
// H7AiUtilityHeAbilitySummonElemental
//=============================================================================
// Instant: summon a stack of random elemental units (Earth, Air, Light, Dark, Water or Fire).
// If the summoned creature is only 1x1 summon it randomly on one of the 4 available tiles. (currently all elementals are 2x2)
// The stack size depends on the the caster's magic and his prime rank.
//    Unskilled: 0.15 * Magic +2 creatures
//    Novice: 0.2 * Magic +2 creatures
//    Expert: 0.3 * Magic +2 creatures
//    Master: 0.6 * Magic +2 creatures
// All numbers rounded down.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilitySummonElemental extends H7AiUtilityCombiner;

var array<H7CombatMapCell>    mPossibleCells;

function H7CombatMapCell GetOptimalSummonElementalTargetCell(H7CombatHero hero )
{
	local H7CombatMapCell           cell;
	local H7CombatMapGrid           grid;
	local array<H7CreatureStack>    cstacks, cstacksA;
	local H7CreatureStack           cstack;
	local array<IntPoint>           pos,posA;
	local array<int>                size,sizeA;
	local int                       x,y,x2,y2,k, creatureCount, creatureCountA;
	local H7CombatMapGridController gridController;
	local IntPoint                  dimension;
	local int                       dx2, dy2;
	local bool                      invalid;

	if(hero==None) return None;

	dimension.X = 5;
	dimension.Y = 5;
	dx2=(dimension.X-1)/2;
	dy2=(dimension.Y-1)/2;

	mPossibleCells.Remove(0,mPossibleCells.Length);
	
	cell=None;
	gridController = class'H7CombatMapGridController'.static.GetInstance();
	grid = gridController.GetCombatGrid();
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
			size.AddItem( cstack.GetUnitBaseSizeInt());
		}
	}
	foreach cstacksA(cstack)
	{
		if(cstack!=None && cstack.IsDead()==false && cstack.IsOffGrid()==false && cstack.IsVisible()==true)
		{
			posA.AddItem( cstack.GetGridPosition() );
			sizeA.AddItem( cstack.GetUnitBaseSizeInt());
		}
	}
	
	for(x=3;x<(gridController.GetGridSizeX()-3);x++)
	{
		for(y=0;y<(gridController.GetGridSizeY()-3);y++)
		{
			creatureCount=0;
			creatureCountA=0;
			for(k=0;k<pos.Length;k++)
			{
				if( x > (pos[k].X + size[k]) ) continue;
				if( (x + dimension.X) < pos[k].X ) continue;
				if( y > (pos[k].Y + size[k]) ) continue;
				if( (y + dimension.Y) < pos[k].Y ) continue;
				creatureCount++;
			}
			for(k=0;k<posA.Length;k++)
			{
				if( x > (posA[k].X + sizeA[k]) ) continue;
				if( (x + dimension.X) < posA[k].X ) continue;
				if( y > (posA[k].Y + sizeA[k]) ) continue;
				if( (y + dimension.Y) < posA[k].Y ) continue;
				creatureCountA++;
			}
			if((creatureCount+creatureCountA)==0)
			{
				invalid=false;
				// check for obstacles and blocking 
				for(x2=x;x2<(x+dimension.X);x2++)
				{
					for(y2=y;y2<(y+dimension.Y);y2++)
					{
						if( grid.GetCellFast(x2,y2).HasObstacle()==true ||
							grid.GetCellFast(x2,y2).IsBlocked(None)==true ) 
						{
							invalid=true;
						}
					}
				}
				if(invalid==false)
				{
					mPossibleCells.AddItem( gridController.GetCombatGrid().GetCellByPos(x+dx2,y+dy2) );
				}
			}
		}
	}

	if(mPossibleCells.Length>0)
	{
		cell=mPossibleCells[ Rand(mPossibleCells.Length-1) ];
	}
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	return cell;
}

/// overrides ...
function UpdateInput()
{
//	`LOG_AI("Utility.HeAbilitySummonElemental");

	mInValues.Remove(0,mInValues.Length);

	if(mPossibleCells.Length>0)
	{
		mInValues.AddItem(0.5f);
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

