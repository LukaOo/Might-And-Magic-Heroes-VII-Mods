//=============================================================================
// H7CellChangeActor
//=============================================================================
// H7CellChangeActor that change the cells the collider component
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CellChangerActor extends StaticMeshActor
	native(Ed)
	placeable
	savegame;

var protected array<H7AdventureMapCell> mCellsToChange; //assigned on save

var(Visuals) protected ParticleSystemComponent mFX<DisplayName=FX>;

var private savegame int mLastCellChange;

event ProcessCellChange(ECellMovementType cellMovementType)
{
	local H7AdventureMapCell cellItem;
	
	if(cellMovementType == MOVTYPE_IMPASSABLE)
	{
		SetCollisionType(COLLIDE_BlockAll);
	}
	else
	{
		SetCollisionType(COLLIDE_NoCollision);
	}


	foreach mCellsToChange(cellItem)
	{
		cellItem.SetMovementType(cellMovementType);
	}
	
	mLastCellChange = cellMovementType;
}

event PostSerialize()
{
	if(mLastCellChange >= 0)
	{
		ProcessCellChange(ECellMovementType(mLastCellChange));
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

