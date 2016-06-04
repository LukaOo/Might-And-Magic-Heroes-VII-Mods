//=============================================================================
// H7SiegeMapDecoration
//=============================================================================
// 
// Objects used to decorate the siege maps that adapt to the level of the town
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SiegeMapDecoration extends SkeletalMeshActorMAT placeable 
	native;

var instanced AnimNode AnimNodeSeqComp;

var(Visuals) protected StaticMeshComponent mMesh<DisplayName=Mesh>;
var(Visuals) protected ParticleSystemComponent mFX<DisplayName=FX>;

var(Visuals) protected DynamicLightEnvironmentComponent mDynamicLightEnv;

// faction that is used to place all the decoration objects in the siege map (in the editor)
var(Decoration) protected H7Faction mReferenceFaction<DisplayName=Faction>;

function Update( H7SiegeTownData siegeTownData )
{
	local int decorationLevel, i, foundIndex;

	// searching the index of this decoration into the reference faction
	foundIndex = -1;
	for( i=0; i<siegeTownData.SiegeDecorationList.Length; ++i )
	{
		if( siegeTownData.SiegeDecorationList[i].MeshLevel1 == self.ObjectArchetype )
		{
			foundIndex = i;
			break;
		}
	}

	if( foundIndex == -1 )
	{
		;
		return;
	}

	if( foundIndex >= siegeTownData.SiegeDecorationList.Length )
	{
		;
		return;
	}

	// calculate the decoration level
	decorationLevel = siegeTownData.SiegeDecorationList[foundIndex].UseWallLevel ? siegeTownData.WallAndGateLevel : siegeTownData.TownLevel;
	if( decorationLevel == 0 )
	{
		// we dont have decoration
		Destroy();
		return;
	}

	// spawn the right decoration depending of the decorationLevel
	if( decorationLevel <= 1 )
	{
		Spawn( class'H7SiegeMapDecoration', self,, Location, Rotation, siegeTownData.SiegeDecorationList[foundIndex].MeshLevel1 );
	}
	else if( decorationLevel == 2 )
	{
		Spawn( class'H7SiegeMapDecoration', self,, Location, Rotation, siegeTownData.SiegeDecorationList[foundIndex].MeshLevel2 );
	}
	else if( decorationLevel == 3 )
	{
		Spawn( class'H7SiegeMapDecoration', self,, Location, Rotation, siegeTownData.SiegeDecorationList[foundIndex].MeshLevel3 );
	}
	else
	{
		Spawn( class'H7SiegeMapDecoration', self,, Location, Rotation, siegeTownData.SiegeDecorationList[foundIndex].MeshLevel4 );
	}
	Destroy();
}

