/*=============================================================================
 * H7CombatObstacleFracturedObject
 * 
 * Base class for combat map obstacles that need to be fractured to be destroyed
 * 
 * Copyright 2013 Limbic Entertainment All Rights Reserved.
 * =============================================================================*/
class H7CombatObstacleFracturedObject extends H7CombatObstacleObject
	native;

var(Fractured) protected archetype FracturedStaticMeshActor_Spawnable mFracturedStaticMeshArchetype;
var(Fractured) protected archetype ParticleSystem mFallingPiecesFXArchetype<DisplayName=Falling pieces FX>;

var protected ParticleSystemComponent				mFallingPiecesFX;
var protected FracturedStaticMeshActor_Spawnable	mSpawnedFracturedMeshActor;
var protected Vector								mLastImpactPos;

var protected float									mImpulseStrength;
var protected float									mImpulseRadiusNormal;		// when gets a normal shot
var protected float									mImpulseRadiusDestroyed;	// when gets the last shot that destroys the obstacle

simulated function Init()
{
	local Vector OffsetLoc;

	super.Init();

	OffsetLoc = TransformVectorByRotation(Rotation, mFracturedStaticMeshArchetype.FracturedStaticMeshComponent.Translation);
	mSpawnedFracturedMeshActor = Spawn( mFracturedStaticMeshArchetype.Class,self,, Location + OffsetLoc, Rotation + mFracturedStaticMeshArchetype.FracturedStaticMeshComponent.Rotation, mFracturedStaticMeshArchetype );
	mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.SetTranslation(Vect(0,0,0));
	mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.SetRotation(Rot(0,0,0));
	mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.SetPhysMaterialOverride(PhysicalMaterial'ENV_BuildingShaders.PM_SiegeBuildings');

	mMesh.SetHidden( true );
	CollisionComponent = none;
}

simulated function vector GetHeightPos( float offset )
{
	return mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.Bounds.Origin + Vect( 0.f, 0.f, 1.f ) * (mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.Bounds.BoxExtent.Z + offset);
}

simulated function float GetHeight()
{
	return mSpawnedFracturedMeshActor.FracturedStaticMeshComponent.Bounds.BoxExtent.Z * 2.f;
}

simulated function ToggleVisibility()
{
	mSpawnedFracturedMeshActor.SetHidden(!mSpawnedFracturedMeshActor.bHidden);
	mFX.SetHidden(!mFX.HiddenGame);
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

simulated function SetVisibility(bool show)
{
	mSpawnedFracturedMeshActor.SetHidden(!show);
	mFX.SetHidden(!show);
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

simulated function Vector GetProjectileImpactPos()
{
	mLastImpactPos = GetMeshCenter();
	if( GetLevel() == OL_DESTROYED )
	{
		mLastImpactPos.Z = GetHeight() * 0.20f;
	}
	else
	{
		mLastImpactPos.Z = GetHeight() * ( 0.3f + ( 0.7f * float(mCurrentHitpoints) / float(mHitpoints) ) );
	}

	return mLastImpactPos;
}

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true )
{
	local FracturedStaticMeshActor_Spawnable damagedActor;
	local float damageStrength, damageRadius;

	super.ApplyDamage( result, resultIdx, isForecast, isRetaliation, raiseEvent );

	// set values for the Radial Impulse and activate it, to destroy the object depending of the damage inflicted
	if( !isForecast )
	{
		GetProjectileImpactPos();

		mLastImpactPos.Z += mImpulseRadiusNormal / 2.f;

		damageStrength = GetLevel() == OL_DESTROYED ? mImpulseStrength : mImpulseStrength/5.f;
		damageRadius = GetLevel() == OL_DESTROYED ? mImpulseRadiusDestroyed : mImpulseRadiusNormal;

		foreach OverlappingActors(class'FracturedStaticMeshActor_Spawnable', damagedActor, damageRadius, mLastImpactPos, true)
		{
			// ignore neighbor gates and towers cause it's misleading
			if( H7CombatMapGate(self) != none || H7CombatMapTower(self) != none || ( H7CombatMapGate(damagedActor.Owner) == none && H7CombatMapTower(damagedActor.Owner) == none ) )
			{
				damagedActor.BreakOffPartsInRadius(mLastImpactPos, damageRadius - 10, damageStrength, true);
				damagedActor.BreakOffPartsInRadius(mLastImpactPos + Vect(0,0,75.0f), damageRadius, damageStrength, true);
				damagedActor.BreakOffPartsInRadius(mLastImpactPos + Vect(0,0,150.0f), damageRadius + 10, damageStrength, true);
			}
		}

		// spawn FX
		mFallingPiecesFX = WorldInfo.MyEmitterPool.SpawnEmitter( mFallingPiecesFXArchetype, mLastImpactPos, Rotation );

		if( GetLevel() == OL_DESTROYED )
		{
			SetTimer( 0.3f, false,nameof(RemoveTopPieces) );

			mFX.DeactivateSystem();
		}
	}
}

simulated function RemoveTopPieces()
{
	local float damageRadius;

	mLastImpactPos = GetMeshCenter();
	mLastImpactPos.Z = GetHeight() * 0.65f;

	if( H7CombatMapGate(self) != none )
	{
		damageRadius = mImpulseRadiusDestroyed * 3.0f;
	}
	else
	{
		damageRadius = mImpulseRadiusDestroyed * 2.0f;
	}
	mSpawnedFracturedMeshActor.BreakOffPartsInRadius(mLastImpactPos, damageRadius, mImpulseStrength, true);
	if (H7CombatMapGate(self) != none)
	{
		H7CombatMapGate(self).GetFracturedStaticMeshLeft().BreakOffPartsInRadius(mLastImpactPos, damageRadius, mImpulseStrength, true);
		H7CombatMapGate(self).GetFracturedStaticMeshRight().BreakOffPartsInRadius(mLastImpactPos, damageRadius, mImpulseStrength, true);
	}
}

