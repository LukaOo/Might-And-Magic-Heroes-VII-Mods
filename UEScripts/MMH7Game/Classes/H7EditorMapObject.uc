//=============================================================================
// H7EditorMapObject
//=============================================================================
// Base class for editor map objects
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorMapObject extends SkeletalMeshActorMAT
	implements(H7IThumbnailable)
	dependson(H7EditorMapGrid, H7StructsAndEnumsNative)
	native
	placeable
	hideCategories( Attachment, Physics, Debug, Mobile, Collision );

const CELL_SIZE = 192.0f;

var instanced AnimNode AnimNodeSeqComp;

var(Mesh) protected StaticMeshComponent mMesh<DisplayName=Mesh>;
var(Mesh) protected ParticleSystemComponent mFX<DisplayName=FX>;

var(Visuals) protected DynamicLightEnvironmentComponent mDynamicLightEnv<DisplayName=Dynamic Light Environment>;

/** How this object snaps to the ground */
var(Editor) protected editoronly ESnapVerticalType mSnapToGroundType<DisplayName=Snap Vertical Type>;
/** How this object snaps to the grid */
var(Editor) protected editoronly ESnapType mSnapType<DisplayName=Snap Type>;
var(Developer) protected editoronly int mTerrainOffset<DisplayName=RMG Terrain Height Offset>;

var protected savegame bool mHideMeshAndFX;

function StaticMesh GetMesh()               { return mMesh.StaticMesh; }
function StaticMeshComponent GetMeshComp()  { return mMesh; }
function SetMesh( StaticMesh dasMesh )      { mMesh.SetStaticMesh( dasMesh ); }

function SetShouldHideMeshAndFX(bool newValue) { mHideMeshAndFX = newValue; }

function ToggleVisibility()
{
	mMesh.SetHidden(!mMesh.HiddenGame);
	mFX.SetHidden(!mFX.HiddenGame);
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function SetVisibility(bool show)
{
	mMesh.SetHidden(!show);
	mFX.SetHidden(!show);
	SetHidden(!show);
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function ParticleSystemComponent GetFX() 
{
	return mFX;
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

