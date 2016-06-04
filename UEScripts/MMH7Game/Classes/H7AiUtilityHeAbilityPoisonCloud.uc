//=============================================================================
// H7AiUtilityHeAbilityPoisonCloud
//=============================================================================
// Creates a poison cloud on a 3x3 area for 3 turns. At the beginning of a 
// combat turn the poison cloud expands by 1 tile in each direction. (5v5, 7x7)
// On casting each creature standing in the target area is dealt earth damage. 
// "Undead" and "Construct" creatures are immune.
// Whenever a creature moves onto a tile of the poison cloud, it is dealt earth 
// damage, but it can continue its movement. Any creature that starts its turn 
// while standing in the poison cloud receives the same damage. Each stack is 
// only damaged once per combat turn from this effect. "Undead" and "Construct"
// creatures are immune.
//        Unskilled: 6 * Magic + 30
//        Novice: 9 * Magic + 45
//        Expert: 18 * Magic + 90
//        Master: 30 * Magic + 150
// Duration is reduced by 1 at the end of each combat turn.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityHeAbilityPoisonCloud extends H7AiUtilityCombiner;

var protected H7AiUtilitySpellAreaDamage  mUSpellDamage;

function H7CombatMapCell GetOptimalPoisonCloudTargetCell(H7CombatHero hero, IntPoint dimension )
{
	local H7CombatMapCell           cell;
	local array<H7CreatureStack>    cstacks, cstacksA;
	local H7CreatureStack           cstack;
	local array<IntPoint>           pos,posA;
	local array<int>                size, sizeA;
	local array<int>                id;
	local array<bool>               range;
	local int                       x,y,k, creatureCount, bestCreatureCount, creatureCountA;
	local H7CombatMapGridController gridController;
	local int                       dx2, dy2;
	local bool                      hasRangeCreature;

	if(hero==None) return None;
	
	cell=None;
	gridController = class'H7CombatMapGridController'.static.GetInstance();
	dx2=(dimension.X-1)/2;
	dy2=(dimension.Y-1)/2;

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
			range.AddItem(cstack.IsRanged());
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
	for(x=0;x<(gridController.GetGridSizeX()-dimension.X);x++)
	{
		for(y=0;y<(gridController.GetGridSizeY()-dimension.Y);y++)
		{
			creatureCount=0;
			creatureCountA=0;
			hasRangeCreature=false;
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
					if(range[k]==true) hasRangeCreature=true;
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
			if( creatureCount>bestCreatureCount && creatureCountA<=0 && hasRangeCreature==true)
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
	local array<float>              uDamage;

//	`LOG_AI("Utility.HeAbilityPoisonCloud");

	if(mUSpellDamage==None) { mUSpellDamage = new class'H7AiUtilitySpellAreaDamage'; }

	mInValues.Remove(0,mInValues.Length);

	mUSpellDamage.mFBias=0.5f;
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

