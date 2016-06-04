class H7EditorScanner extends BrushBuilder
	native(Ed);

var(Developer) protected editoronly bool mRecreateLandscapeColliders<DisplayName="Recreate all Landscape Internal Colliders (click to activate)">;
var(Developer) protected editoronly bool mAllStaticMeshActorToFoliage<DisplayName="Swap all StaticMesh actors to foliage (click to activate)">;
var(Developer) protected editoronly bool mSelectedStaticMeshActorToFoliage<DisplayName="Swap selected StaticMeshe actors to foliage (click to activate)">;

event bool Build()
{
	if (mRecreateLandscapeColliders)
	{
		RecreateLandscapeColliders();
		mRecreateLandscapeColliders = false;
	}
	else if (mAllStaticMeshActorToFoliage)
	{
		StaticMeshActorToFoliage(false);
		mAllStaticMeshActorToFoliage = false;
	}
	else if (mSelectedStaticMeshActorToFoliage)
	{
		StaticMeshActorToFoliage(true);
		mSelectedStaticMeshActorToFoliage = false;
	}
	else
	{
		PerformFullScan();
	}
    return true;
}

native function PerformFullScan();
native function RecreateLandscapeColliders();
native function StaticMeshActorToFoliage(bool onlySelected);

