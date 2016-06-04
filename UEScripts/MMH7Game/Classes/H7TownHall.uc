/*=============================================================================
* H7TownHall
* =============================================================================
*  Class for the Town Hall.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownHall extends H7TownBuilding
	native;

var (Properties) protected StaticMesh   mMesh<DisplayName=Mesh>;
var (Properties) protected bool         mIsCapitol<DisplayName=Is Capitol>;

function StaticMesh GetMesh()   { return mMesh; }
function bool IsCapitol()       { return mIsCapitol; }
