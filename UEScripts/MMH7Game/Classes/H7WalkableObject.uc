/*=============================================================================
* H7WalkableObject
* =============================================================================
*  Done by the CCU. Handle with care!
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7WalkableObject extends StaticMeshActor
	implements(H7WalkableInterface, H7IHideable, H7IThumbnailable)
	native
	placeable;

var(ScanOverride) editoronly PrimitiveComponent ScanOverride_Collider;
var(ScanOverride) editoronly H7AdventureLayerCellProperty ScanOverride_LayerCellModifier;

var protected savegame bool mIsHidden;

function native PrimitiveComponent GetScanOverrideCollider() const; //override H7WalkableInterface
function native H7AdventureLayerCellProperty GetScanOverrideModifier() const; //override H7WalkableInterface

native function bool IsHiddenX();

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
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

