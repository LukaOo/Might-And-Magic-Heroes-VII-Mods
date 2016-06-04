//=============================================================================
// H7CreatureStackFX
//=============================================================================
//
// Class to create an aura effect around a selected creature stack.
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WarUnitFX extends H7UnitFX;

var protected SkeletalMeshComponent mMesh;
var protected SkeletalMeshComponent mAimingMesh;

function InitFX( H7Unit unit) 
{
	super.InitFX( unit );
	
	mMesh = H7WarUnit( unit ).mSkeletalMesh;
	mMesh.SetOutlined( false );

	mAimingMesh = H7WarUnit( unit ).mAimingSkeletalMesh;
	mAimingMesh.SetOutlined( false );
}

function SetIsHovering(bool isHovering)
{
	if(mMesh != none)
	{
		mMesh.SetOutlined(isHovering);
	}
	if(mAimingMesh != none)
	{
		mAimingMesh.SetOutlined(isHovering);
	}
}

function CreateFX()
{
	local ParticleSystem selectionFXTemplate;
	local Vector unitPos;
	local H7CombatMapCell cell;
	local H7CombatMapGridController gridCntl; 

	gridCntl = class'H7CombatMapGridController'.static.GetInstance();

	if( mUnit.GetEntityType() == UNIT_WARUNIT )
	{
		cell = gridCntl.GetCombatGrid().GetCellByIntPoint( mUnit.GetGridPosition() );
		if( mUnit.IsDead() )
		{
			unitPos = cell.GetCenterPosFor2ndLayer();
		}
		else 
		{
			unitPos = cell.GetCenterPos();
		}
		
		selectionFXTemplate = mProperties.SelectionFXTemplateWarUnit;
		
		mSelectionFX = WorldInfo.MyEmitterPool.SpawnEmitter( selectionFXTemplate, unitPos, , mUnit );
		class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( mSelectionFX );
	}
}
