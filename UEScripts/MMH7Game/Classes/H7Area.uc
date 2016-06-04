/*=============================================================================
 * H7Area
 * 
 * An area of gridcell positions that can be referenced by triggers
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7Area extends H7EditorMapObject
	native;

/** The name of the area, not shown ingame */
var(Properties) protected String mName<DisplayName=Name>;
/** X size in tiles */
var(Area) protected int mSizeX<DisplayName=Tiles X|ClampMin=0|ClampMax=399>;
/** Y size in tiles */
var(Area) protected int mSizeY<DisplayName=Tiles Y|ClampMin=0|ClampMax=399>;
/** Height in tiles */
var(Area) protected int mSizeZ<DisplayName=Tiles Z|ClampMin=1>;

var protected DrawBoxComponent mPreviewBox;
var protected StaticMeshComponent mPreviewStaticMeshComponent;

function bool IsInside(Vector loc)
{
	return loc.X > location.X - mSizeX * 0.5f
		&& loc.X < location.X + mSizeX * 0.5f
		&& loc.Y > location.Y - mSizeY * 0.5f
		&& loc.Y < location.Y + mSizeY * 0.5f
		&& loc.Z > location.Z - mSizeZ * 0.5f
		&& loc.Z < location.Z + mSizeZ * 0.5f;
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

