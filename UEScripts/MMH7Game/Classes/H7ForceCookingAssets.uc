//=============================================================================
// H7ForceCookingAssets
// All assets referenced in this file will make a script-linking to the asset so the unreal cooker with include them in the cooking process.
// This is mostly usefull for assets that are only referenced and loaded by the unrealscript code.
//
// Copyright 2013-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ForceCookingAssets extends Object;

function Dummy() // this function is never called (and why on earth it should ever be).
{
	local MaterialInterface matinst;
	local MaterialInstanceConstant matinstconst;
	local Texture2D tex2D;
	local StaticMesh sm;
	local string str;

	// Pathfinder / FX_Units.upk
	matinst	        = MaterialInterface         'FX_Units.Adventure.M_PathSpot';
	matinstconst	= MaterialInstanceConstant  'FX_Units.Adventure.M_PathTarget';
	matinstconst	= MaterialInstanceConstant  'FX_Units.Adventure.M_PathWaypoint';
	matinstconst	= MaterialInstanceConstant  'FX_Units.Adventure.M_PathWaypointTurn';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn0';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn1';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn2';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn3';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn4';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn5';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn6';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn7';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn8';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWaypointTurn9';
	tex2D			= Texture2D					'FX_Units.Adventure.T_PathWayPointTurnMore';

	// Engine / EditorMeshes.upk
	sm              = StaticMesh				'EditorMeshes.TexPropCube';
	sm				= StaticMesh				'EditorMeshes.TexPropSphere';
	sm				= StaticMesh				'EditorMeshes.TexPropPlane';
	sm				= StaticMesh				'EditorMeshes.TexPropCylinder';

	// module / package.upk


	// Fake operation to avoid "non-used local variable" warning
	str $= matinst.name;
	str $= matinstconst.name;
	str $= tex2D.name;
	str $= sm.name;
	matinstconst.SetScalarParameterValue('this trick is stupid', Len(str) + 1);
}
