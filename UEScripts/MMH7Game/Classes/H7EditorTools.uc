class H7EditorTools extends BrushBuilder
	native(Ed);

var(Developer) protected editoronly bool mWeldStaticMeshes<DisplayName="Weld selected StaticMeshes into one (click to activate)">;
var(Developer) protected editoronly bool mLandscapeCropStaticMeshes<DisplayName="Crop StaticMeshes with Landscapes (click to activate)">;
var(Developer) protected editoronly bool mTransformLandscape<DisplayName="Transform Landscapes (click to activate)">;
var(Developer) protected editoronly bool mFullTransformLandscape<DisplayName="Fully Transform Landscapes (click to activate)">;
var(Developer) protected editoronly bool mVertexTransformLandscape<DisplayName="Vertex Transform Landscapes (click to activate)">;
var(Developer) protected editoronly bool mComputeLandscapeMaterials<DisplayName="Compute Landscape Materials (click to activate)">;
var(Developer) protected editoronly bool mStaticMeshesInstantiation<DisplayName="Create local instances for StaticMeshes (click to activate)">;
var(Developer) protected editoronly bool mConvertToH7InterpActor<DisplayName="Convert: InterpActors to H7InterpActor (click to activate)">;
var(Developer) protected editoronly bool mConvertToH7ParticleEmitter<DisplayName="Convert: ParticleEmitter to H7ParticleEmitter (click to activate)">;
var(Visuals) protected editoronly bool mResetArmyMeshes<DisplayName="Reset all Army Meshes (click to activate)">;
var(Data) protected editoronly bool mSetupDefaultCellLayerData<DisplayName="Setup default Cell Layer Data (click to activate)">;
var(Data) protected editoronly bool mClearPathsRebuilt<DisplayName="Clears PATHS NEED TO BE REBUILT for current map">;
var(Asset) protected editoronly prefab mPrefabToClean<DisplayName="Prefab to clean">;

event bool Build()
{
	if (mWeldStaticMeshes)
	{
		WeldStaticMeshes();
		mWeldStaticMeshes = false;
	}
	else if (mLandscapeCropStaticMeshes)
	{
		LandscapeCropStaticMeshes();
		mLandscapeCropStaticMeshes = false;
	}
	else if (mTransformLandscape)
	{
		TransformLandscape();
		mTransformLandscape = false;
	}
	else if (mFullTransformLandscape)
	{
		FullTransformLandscape();
		mFullTransformLandscape = false;
	}
	else if (mVertexTransformLandscape)
	{
		VertexTransformLandscape();
		mVertexTransformLandscape = false;
	}
	else if (mComputeLandscapeMaterials)
	{
		ComputeLandscapeMaterials();
		mComputeLandscapeMaterials = false;
	}
	else if (mStaticMeshesInstantiation)
	{
		StaticMeshesInstantiation();
		mStaticMeshesInstantiation = false;
	}
	else if (mResetArmyMeshes)
	{
		ResetArmyMeshes();
		mResetArmyMeshes = false;
	}
	else if (mSetupDefaultCellLayerData)
	{
		SetupDefaultCellLayerData();
		mSetupDefaultCellLayerData = false;
	}
	else if (mClearPathsRebuilt)
	{
		ClearPathsRebuilt();
		mClearPathsRebuilt = false;
	}
	else if(mConvertToH7InterpActor)
	{
		ConvertInterpActors();
		mConvertToH7InterpActor = false;
	}
	else if(mConvertToH7ParticleEmitter)
	{
		ConvertParticleEmitters();
		mConvertToH7ParticleEmitter = false;
	}
	FilterEditorOnly
	{
		if (mPrefabToClean != none)
		{
			CleanupPrefab();
			mPrefabToClean = none;
		}
	}

    return true;
}

native function WeldStaticMeshes();
native function LandscapeCropStaticMeshes();
native function TransformLandscape();
native function FullTransformLandscape();
native function VertexTransformLandscape();
native function ComputeLandscapeMaterials();
native function StaticMeshesInstantiation();
native function ConvertInterpActors();
native function ConvertParticleEmitters();
native function CleanupPrefab();

function ResetArmyMeshes()
{
	local WorldInfo WI;
	local H7EditorArmy Army;

	WI = class'Engine'.static.GetCurrentWorldInfo();
    foreach WI.AllActors(class'H7EditorArmy', Army)
    {
		Army.UpdateMeshes();
    }
	mResetArmyMeshes = false;
}

native function SetupDefaultCellLayerData();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function ClearPathsRebuilt()
{
	local WorldInfo wi;

	wi = class'Engine'.static.GetCurrentWorldInfo();
	if(wi != none)
	{
		wi.bPathsRebuilt = TRUE;
	}

	mClearPathsRebuilt = false;
}

