//=============================================================================
// H7CreatureStackFX
//=============================================================================
//
// Class to create an aura effect around a selected creature stack.
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackFX extends H7UnitFX;

function CreateFX()
{
	local ParticleSystem selectionFXTemplate;
	local H7Creature creature;
	local Vector unitPos;
	local H7CombatMapCell cell;
	local H7CombatMapGridController gridCntl; 


	gridCntl = class'H7CombatMapGridController'.static.GetInstance();

    if(mUnit.GetEntityType() == UNIT_CREATURESTACK)
	{
		creature = H7CreatureStack(mUnit).GetCreature();
	
		unitPos = gridCntl.GetCellLocation( mUnit.GetGridPosition() );
		cell = gridCntl.GetCell( unitPos );
		
		if( mUnit.IsDead() )
		{
			unitPos = cell.GetCenterPosFor2ndLayer();
		}
		else 
		{
			unitPos = cell.GetCenterPos();
		}
		
		switch(creature.GetBaseSize())
		{
			case CELLSIZE_1x1: selectionFXTemplate = mProperties.SelectionFXTemplate1x1; break;
			case CELLSIZE_2x2: selectionFXTemplate = mProperties.SelectionFXTemplate2x2; break;
		}
		
		mSelectionFX = WorldInfo.MyEmitterPool.SpawnEmitter(selectionFXTemplate, unitPos, , creature);
		class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( mSelectionFX );
	
	}
}
