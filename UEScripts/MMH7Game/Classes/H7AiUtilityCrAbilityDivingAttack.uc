//=============================================================================
// H7AiUtilityCrAbilityDivingAttack
//=============================================================================
// (ACTIVE)
// The creature attacks a 2x2 area on the battlefield with a +10 attack bonus.
//
// When the ability is activated and a target area 2x2 is selected the griffin 
// leaves the combat map and is not shown in the inititiative bar anymore. 
// Positive morale cannot happen.
//
// While the griffin is away from the battlefield it cannot be targeted or 
// affected by any spells or effects. 
//
// When it is the next turn of the griffin it attacks the 2x2 area that was 
// previously targeted. Both friendly and enemy creatures take damage. The 
// diving attack does not trigger retaliation.
//
// After the attack the griffin lands on a random position as close as possible 
// to the targeted area and ends its turn.
//
// The Griffin also returns to the initiative bar. Positive morale can trigger 
// for this attack.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityCrAbilityDivingAttack extends H7AiUtilityCombiner;

var protected H7AiUtilityCrAbilityCasualityCount    mInUCasualityCount;
var protected H7AiUtilityCrAbilityCreatureDamage    mInUCreatureDamage;
var protected H7AiUtilityHasAnyAdjacentEnemy        mInUHasAdjEnemy;

var array<H7CombatMapCell>      mPossibleCells;
var H7CombatMapCell             mTargetCell;

function H7CombatMapCell GetOptimalDivingAttackTargetCell( H7CombatHero hero )
{
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

	mTargetCell=None;
	mPossibleCells.Remove(0,mPossibleCells.Length);

	if(hero==None) return None;

	dimension.X = 2;
	dimension.Y = 2;
	dx2=0;
	dy2=0;
	
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
			if(creatureCount>=1 && creatureCountA==0)
			{
				invalid=false;
				// check for obstacles and blocking 
				for(x2=x;x2<(x+dimension.X);x2++)
				{
					for(y2=y;y2<(y+dimension.Y);y2++)
					{
						if( grid.GetCellFast(x2,y2).HasObstacle()==true ||
							grid.GetCellFast(x2,y2).IsBlocked(cstacks[0])==true ||
							grid.GetCellFast(x2,y2).GetThreat() < 0.5f ) 
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

	//if(mPossibleCells.Length>0)
	//{
	//	mTargetCell=mPossibleCells[ Rand(mPossibleCells.Length-1) ];
	//}
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	return mTargetCell;
}

/// overrides ...
function UpdateInput()
{
	local array<float> hasAdjEnemy;
	//local array<float> casualityCount;
	//local array<float> creatureDamage;
	//local float coUtil;
	
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mInUCasualityCount == None ) { mInUCasualityCount = new class 'H7AiUtilityCrAbilityCasualityCount'; }
	if( mInUCreatureDamage == None ) { mInUCreatureDamage = new class 'H7AiUtilityCrAbilityCreatureDamage'; }
	if( mInUHasAdjEnemy == None ) { mInUHasAdjEnemy = new class 'H7AiUtilityHasAnyAdjacentEnemy'; }

	mInValues.Remove(0,mInValues.Length);

	if(mTargetCell==None)
	{
		return;
	}

	// we only use the ability if the unit is not suppressed by enemies
	mInUHasAdjEnemy.UpdateInput();
	mInUHasAdjEnemy.UpdateOutput();
	hasAdjEnemy = mInUHasAdjEnemy.GetOutValues();

	if( hasAdjEnemy.Length>=1 && hasAdjEnemy[0]<=0.0f )
	{
		mInValues.AddItem(0.5f);

		//mInUCasualityCount.UpdateInput();
		//mInUCasualityCount.UpdateOutput();
		//casualityCount = mInUCasualityCount.GetOutValues();

		//mInUCreatureDamage.UpdateInput();
		//mInUCreatureDamage.UpdateOutput();
		//creatureDamage = mInUCreatureDamage.GetOutValues();

		//if(casualityCount.Length>=1 && creatureDamage.Length>=1)
		//{
		//	coUtil=casualityCount[0]*creatureDamage[0];
		//	`LOG_AI("  *Score" @ coUtil @ "CCnt" @ casualityCount[0] @ "CDmg" @ creatureDamage[0] );
		//	if(coUtil>0.0f)
		//	{
		//		mInValues.AddItem(coUtil);
		//	}
		//}
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

