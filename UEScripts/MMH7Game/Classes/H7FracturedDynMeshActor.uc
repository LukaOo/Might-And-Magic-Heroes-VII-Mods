//=============================================================================
// H7FracturedDynMeshActor
//=============================================================================
// FracturedStaticMeshActor for use with dynamic objects
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FracturedDynMeshActor extends H7FracturedMeshActor;

var vector FracHitLocation, FracMomentum;
var class<DamageType> FracDmgType;
var TraceHitInfo FracHitInfo;
var int FracCurrChunk;

simulated function bool IsFracturedByDamageType(class<DamageType> DmgType)
{
	return true;
}

/** Fracture this mesh interpolated in time */
simulated event FractureInterpolated(float InterpTime, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local float fracTime;

	FracHitLocation = HitLocation;
	FracMomentum = Momentum;
	FracDmgType = DamageType;
	FracHitInfo = HitInfo;

	FracCurrChunk = 0;

	fracTime = InterpTime / ChunkHealth.Length;

	FractureGroup();
	SetTimer(fracTime, true, 'FractureGroup');
}

simulated event FractureGroup()
{
	local array<byte> FragmentVis;
	local vector ChunkDir, MomentumDir;
	local FracturedStaticMesh FracMesh;
	local FracturedStaticMeshPart FracPart;
	local array<FracturedStaticMeshPart> NoCollParts;
	local int TotalVisible/*, i*/;
	local array<int> IgnoreFrags;
	local box ChunkBox;
	local ParticleSystem EffectPSys;
	local float PhysChance, PartScale;
	local byte bWantPhysChunksAndParticles;
	local WorldFractureSettings FractureSettings;
	local vector NewHitLocation, HitNormal;

	local vector HitLocation, Momentum;
	local TraceHitInfo HitInfo;

	bWantPhysChunksAndParticles = 1;

	if ( HitInfo.HitComponent == None )
	{
		// Perform trace to retrieve hit info
		if ( Momentum == vect(0,0,0) )
		{
			Momentum = Location - HitLocation;
		}
		TraceComponent(NewHitLocation, HitNormal, FracturedStaticMeshComponent, HitLocation + Normal(Momentum) * 100.0f, HitLocation,, HitInfo, true);
	}

	if (FracCurrChunk >= ChunkHealth.Length)
	{
		ClearTimer('FractureGroup');
		return;
	}


	// do it for every chunk
	// do it for one chunk this time
	HitInfo.Item = FracCurrChunk;

	// skip core, invisible and non-destroyable chunk
	if ( HitInfo.Item == FracturedStaticMeshComponent.GetCoreFragmentIndex() ||
	!FracturedStaticMeshComponent.IsFragmentVisible(HitInfo.Item) ||
	!FracturedStaticMeshComponent.IsFragmentDestroyable(HitInfo.Item) )
	{
		FracCurrChunk++;
		return;
	}

	// Take away from chunks health - if scripted, force to zero.
	ChunkHealth[HitInfo.Item] = 0.0;

	// If its hit zero health, hide part and spawn part.
	if(ChunkHealth[HitInfo.Item] <= 0)
	{
		FracMesh = FracturedStaticMesh(FracturedStaticMeshComponent.StaticMesh);

		// Get fracture settings from relevant WorldInfo.
		FractureSettings = WorldInfo.GetWorldFractureSettings();

		FragmentVis = FracturedStaticMeshComponent.GetVisibleFragments();
		TotalVisible = FracturedStaticMeshComponent.GetNumVisibleFragments();

		// If physics object - ignore hits if you are the last part
		if(Physics == PHYS_RigidBody)
		{
			if(TotalVisible == 1)
			{
				FracCurrChunk++;
				return;
			}
		}

		// If we are losing the first chunk, change exterior material (if replacement is defined).
		if(TotalVisible == FragmentVis.length)
		{
			SetLoseChunkReplacementMaterial();
		}

		FragmentVis[HitInfo.Item] = 0;

		// Start with average exterior normal of chunk
		ChunkDir = FracturedStaticMeshComponent.GetFragmentAverageExteriorNormal(HitInfo.Item);

		// If bad normal, or its pointing away from us, add in the shot momentum
		MomentumDir = Normal(Momentum);
		if((VSize(ChunkDir) < 0.01) || (MomentumDir Dot ChunkDir > -0.2))
		{
			ChunkDir += MomentumDir;
		}

		// Take out any downwards force
		ChunkDir.Z = Max(ChunkDir.Z, 0.0);
		// Reduce Z vel
		ChunkDir.Z /= FracMesh.ChunkLinHorizontalScale;
		// Normalize
		ChunkDir = Normal(ChunkDir);

		// See if we want to spawn physics chunks, and take into account chance of it happening
		if ( WorldInfo.NetMode != NM_DedicatedServer )
		{
			PhysChance = FractureSettings.bEnableChanceOfPhysicsChunkOverride ? FractureSettings.ChanceOfPhysicsChunkOverride : FracMesh.ChanceOfPhysicsChunk;
			PhysChance *= WorldInfo.MyFractureManager.GetFSMDirectSpawnChanceScale();
			if( bWantPhysChunksAndParticles == 1 &&
				FracMesh.bSpawnPhysicsChunks &&
				(FRand() < PhysChance) &&
				!FracturedStaticMeshComponent.IsNoPhysFragment(HitInfo.Item) )
			{
				PartScale = FracMesh.NormalPhysicsChunkScaleMin + FRand() * (FracMesh.NormalPhysicsChunkScaleMax - FracMesh.NormalPhysicsChunkScaleMin);
				// Spawn part moving from center of mesh
				FracPart = SpawnPart(HitInfo.Item, (ChunkDir * FracMesh.ChunkLinVel) + Velocity, VRand() * FracMesh.ChunkAngVel, PartScale, FALSE);
				//RemoveDecals( HitInfo.Item );

				if (FracPart != None)
				{
					FracParts.AddItem(FracPart);

					// Disable collision between spawned part and this mesh.
					FracPart.FracturedStaticMeshComponent.DisableRBCollisionWithSMC(FracturedStaticMeshComponent, TRUE);
					FracPart.FracturedStaticMeshComponent.SetRBCollidesWithChannel(RBCC_FracturedMeshPart, false);
				}
			}

			// Assign effect if there is one.
			if( bWantPhysChunksAndParticles == 1 )
			{
				// Look for override first
				if(OverrideFragmentDestroyEffects.length > 0)
				{
					// Pick randomly
					EffectPSys = OverrideFragmentDestroyEffects[Rand(OverrideFragmentDestroyEffects.length)];
				}
				// No override array, try the mesh
				else if(FracMesh.FragmentDestroyEffects.length > 0)
				{
					EffectPSys = FracMesh.FragmentDestroyEffects[Rand(FracMesh.FragmentDestroyEffects.length)];
				}

				// If we have an effect and a manager - spawn it
				if(EffectPSys != None && WorldInfo.MyFractureManager != None)
				{
					ChunkBox = FracturedStaticMeshComponent.GetFragmentBox(HitInfo.Item);
					WorldInfo.MyFractureManager.SpawnChunkDestroyEffect(EffectPSys, ChunkBox, ChunkDir, FracMesh.FragmentDestroyEffectScale);
				}
			}
		}

		// If no core (or 'always break off isolated parts'), and not overriding - we have to look for un-rooted 'islands'
		if((FracMesh.bAlwaysBreakOffIsolatedIslands || FracturedStaticMeshComponent.GetCoreFragmentIndex() == INDEX_NONE) && !FracMesh.bFixIsolatedChunks)
		{
			IgnoreFrags[0] = HitInfo.Item;
			if(FracPart != None)
			{
				NoCollParts[0] = FracPart;
			}
			BreakOffIsolatedIslands(
				FragmentVis,
				IgnoreFrags,
				ChunkDir,
				NoCollParts,
				bWantPhysChunksAndParticles == 1 );
		}

		// Right at the end, change fragment visibility
		FracturedStaticMeshComponent.SetVisibleFragments(FragmentVis);

		// If this is a physical part - reset physics state, to take notice of new hidden parts.
		if (Physics == PHYS_RigidBody)
		{
			FracturedStaticMeshComponent.RecreatePhysState();
		}
	}

	FracCurrChunk++;
	
}

