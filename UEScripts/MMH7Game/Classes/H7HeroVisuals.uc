//=============================================================================
// H7HeroVisuals
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroVisuals extends Object 
	native;


// == Visuals ==
var(Visuals) protectedwrite SkeletalMeshComponent			mHeroSkeletalMesh<DisplayName=Hero Skeletal Mesh>;

var(Visuals) protectedwrite SkeletalMeshComponent			mHorseSkeletalMesh<DisplayName=Horse Skeletal Mesh>;
var(Visuals) protected DynamicLightEnvironmentComponent		mDynamicLightEnv<DisplayName=Dynamic Light Environment>;

var(Visuals) StaticMesh                                     mAttachmentMesh<DisplayName="Attachment Mesh">;

/** The scale of this creature when used in an AdventureMap Army */
var(Visuals) float                                          mArmyScale<DisplayName=Army Scale>;

var(Visuals) array<H7HeroEvent>                             mHeroEvents<DisplayName=Hero Events>;

var(Visuals) protected Vector								mHorseRiderOffset<DisplayName=Horse Rider Offset>;

var(Visuals) protected Texture2D							mMinimapIcon<DisplayName=Minimap Icon>;

function SkeletalMeshComponent              GetHeroSkeletalMesh()               { return mHeroSkeletalMesh; }
function SkeletalMeshComponent              GetHorseSkeletalMesh()              { return mHorseSkeletalMesh; }
function DynamicLightEnvironmentComponent   GetDynamicLightEnv()                { return mDynamicLightEnv; }

function array<H7HeroEvent>                 GetHeroEvents()                     { return mHeroEvents; }

function Vector                             GetHorseRiderOffset()               { return mHorseRiderOffset; }
function Texture2D                          GetMinimapIcon()                    { return mMinimapIcon;  }

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

