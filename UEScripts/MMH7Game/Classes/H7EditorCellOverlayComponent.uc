class H7EditorCellOverlayComponent extends PrimitiveComponent
	native(Ed)
	collapsecategories
	hidecategories(Object)
	editinlinenew;

var()	MaterialInstance	Material;
var()	float	            Offset;

var private native transient boxspherebounds ComputedBounds;

struct native CellOverlay_VertexData
{
	var vector Position;
	var vector2d UV;
	var vector TangentX, TangentY, TangentZ;
	var color Color;

	structcpptext { }
	structdefaultproperties { }
};
var private editoronly native transient array<CellOverlay_VertexData> VertexData;

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

