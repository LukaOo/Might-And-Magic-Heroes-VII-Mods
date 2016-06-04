class H7EditorCameraHeightTool extends PrimitiveComponent
	dependson(H7CameraHeightVolume)
	native(Ed);

var()	MaterialInstance	Material;

var private native transient boxspherebounds ComputedBounds;

struct native CamHeight_VertexData
{
	var vector Position;
	var vector2d UV;
	var vector TangentX, TangentY, TangentZ;
	var color Color;

	structcpptext { }
	structdefaultproperties { }
};
var private editoronly native transient array<CamHeight_VertexData> VertexData;

var private editoronly native transient array<INT> IndiceData;

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

