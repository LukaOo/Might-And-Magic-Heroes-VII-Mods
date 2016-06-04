//=============================================================================
// H7WarfareVisuals
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WarfareVisuals extends Object;

var(Visuals) protected SkeletalMeshComponent		        mSkeletalMesh<DisplayName=Skeletal Mesh>;
var(Visuals) protected SkeletalMeshComponent				mAimingSkeletalMesh<DisplayName=Aiming Skeletal Mesh>;

var(Visuals) protected array<H7WarfareEvent>	            mWUEvents<DisplayName=Warfare Unit Events>;

var(Visuals) Array<H7DeathMaterialEffect>                   mDeathMaterialEffects<DisplayName=Material Death Effects>;

var protected DynamicLightEnvironmentComponent		        mDynamicLightEnv<DisplayName=Dynamic Light Env>;

function array<H7DeathMaterialEffect>           GetDeathMaterialEffects()   { return mDeathMaterialEffects; }
function SkeletalMeshComponent                  GetSkeletalMesh()           { return mSkeletalMesh; }
function SkeletalMeshComponent                  GetAimingSkeletalMesh()     { return mAimingSkeletalMesh; }
function DynamicLightEnvironmentComponent       GetDynamicLightEnv()        { return mDynamicLightEnv; }
function array<H7WarfareEvent>                  GetWUEvents()               { return mWUEvents; }

