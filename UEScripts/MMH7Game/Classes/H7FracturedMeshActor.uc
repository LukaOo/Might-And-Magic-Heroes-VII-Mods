//=============================================================================
// H7FracturedMeshActor
//=============================================================================
// FracturedStaticMeshActor that gets destroyed uniformly
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7FracturedMeshActor extends FracturedStaticMeshActor
	native
	savegame;

var array<FracturedStaticMeshPart> FracParts;

var savegame H7FracturedMeshActor FracActor;

var protected savegame bool mIsClone;

var() DynamicLightEnvironmentComponent mLightEnv;

var protected savegame vector mOriginalMeshLoc;
var protected savegame rotator mOriginalMeshRot;

function bool IsClone() { return mIsClone; }
function SetIsClone( bool isClone ) { mIsClone = isClone; }

function SetOriginalTransform(vector newLocation, rotator newRotation)
{
	mOriginalMeshLoc = newLocation;
	mOriginalMeshRot = newRotation;
}

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	// fix for pitch-black colors and moveability
	SetTickIsDisabled(false);
}

/** simplified version of FracturedStaticMeshActor's TakeDamage that fractures all of the chunks **/
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	// call Actor's version to handle any SeqEvent_TakeDamage for scripting
	Super(Actor).TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);



	if( FracActor == none )
	{
		FracActor = Spawn(self.Class, self, , Location, Rotation, self, true);
		FracActor.SetOriginalTransform(Location, Rotation);
		FracActor.SetDrawScale( DrawScale );
		FracActor.SetDrawScale3D( DrawScale3D );
		FracActor.FracturedStaticMeshComponent.SetScale(FracturedStaticMeshComponent.Scale);
		FracActor.FracturedStaticMeshComponent.SetScale3D(FracturedStaticMeshComponent.Scale3D);
		FracActor.SetIsClone( true );
		FracActor.SetDrawScale(FracActor.DrawScale * 0.995f);
	}

	if (FracActor != None)
	{
		SetHidden(true);
		FracActor.SetHidden(false);
		FracActor.SetOriginalTransform(Location, Rotation);
		FracActor.FracturedStaticMeshComponent.SetBlockRigidBody(false);
		FracActor.FracturedStaticMeshComponent.SetActorCollision(false, false);
		FracActor.FracturedStaticMeshComponent.SetTraceBlocking(false, false);
		FracActor.SetCollisionType(COLLIDE_NoCollision);
		FracActor.Fracture(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
	}
}

simulated event Fracture(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local array<byte> FragmentVis;
	local vector ChunkDir, MomentumDir;
	local FracturedStaticMesh FracMesh;
	local FracturedStaticMeshPart FracPart;
	local array<FracturedStaticMeshPart> NoCollParts;
	local int TotalVisible, i;
	local array<int> IgnoreFrags;
	local box ChunkBox;
	local ParticleSystem EffectPSys;
	local float PhysChance, PartScale;
	local byte bWantPhysChunksAndParticles;
	local Pawn InstigatorPawn;
	local WorldFractureSettings FractureSettings;
	local vector NewHitLocation, HitNormal;

	if ( HitInfo.HitComponent == None )
	{
		// Perform trace to retrieve hit info
		if ( Momentum == vect(0,0,0) )
		{
			Momentum = Location - HitLocation;
		}
		TraceComponent(NewHitLocation, HitNormal, FracturedStaticMeshComponent, HitLocation + Normal(Momentum) * 100.0f, HitLocation,, HitInfo, true);
	}

	for (i = 0; i < ChunkHealth.Length; i++)
	{
		// do it for every chunk
		HitInfo.Item = i;

		// skip core, invisible and non-destroyable chunk
		if ( HitInfo.Item == FracturedStaticMeshComponent.GetCoreFragmentIndex() ||
		!FracturedStaticMeshComponent.IsFragmentVisible(HitInfo.Item) ||
		!FracturedStaticMeshComponent.IsFragmentDestroyable(HitInfo.Item) )
		{
			continue;
		}

		// Make sure the impacted fractured mesh is visually relevant
		if (EventInstigator != None)
		{
			InstigatorPawn = EventInstigator.Pawn;
		}
		else if (DamageCauser != None)
		{
			InstigatorPawn = DamageCauser.Instigator;
		}
		if (!FractureEffectIsRelevant(false, InstigatorPawn, bWantPhysChunksAndParticles))
		{
			;
			return;
		}

		// Take away from chunks health - if scripted, force to zero.
		//if( RB_LineImpulseActor(DamageCauser) != None )
		//{
			ChunkHealth[HitInfo.Item] = 0.0;
		//}

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
	}
}

simulated function OnToggle(SeqAct_Toggle Action)
{
	ResetHealth();
	ResetVisibility();

	if (FracActor != None)
	{
		SetHidden(false);
		FracActor.SetHidden(true);
		FracActor.ResetHealth();
		FracActor.ResetVisibility();
	}
}

event Destroyed()
{
	super.Destroyed();

	if( FracActor != none )
	{
		FracActor.Destroy();
		FracActor = None;
	}
}

event RestoreTransform()
{
	if(IsClone())
	{
		SetLocation(mOriginalMeshLoc);
		SetRotation(mOriginalMeshRot);
	}
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

