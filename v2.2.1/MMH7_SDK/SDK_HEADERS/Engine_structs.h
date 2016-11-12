#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: Engine_structs.h
# ========================================================================================= #
# Credits: uNrEaL, Tamimego, SystemFiles, R00T88, _silencer, the1domo, K@N@VEL
# Thanks: HOOAH07, lowHertz
# Forums: www.uc-forum.com, www.gamedeception.net
#############################################################################################
*/

#ifdef _MSC_VER
	#pragma pack ( push, 0x4 )
#endif

/*
# ========================================================================================= #
# Script Structs
# ========================================================================================= #
*/

// ScriptStruct Engine.StaticMesh.StaticMeshLODElement
// 0x00000014
struct FStaticMeshLODElement
{
//	 vPoperty_Size=3
	class UMaterialInterface*                          Material;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bEnableShadowCasting : 1;                         		// 0x0008 (0x0004) [0x0000000000001001] [0x00000001] ( CPF_Edit | CPF_Native )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x000C (0x0004) MISSED OFFSET
	unsigned long                                      bEnableCollision : 1;                             		// 0x0010 (0x0004) [0x0000000000001001] [0x00000001] ( CPF_Edit | CPF_Native )
};

// ScriptStruct Engine.StaticMesh.StaticMeshLODInfo
// 0x00000010
struct FStaticMeshLODInfo
{
//	 vPoperty_Size=1
	TArray< struct FStaticMeshLODElement >             Elements;                                         		// 0x0000 (0x0010) [0x0000000000001041]              ( CPF_Edit | CPF_EditConstArray | CPF_Native )
};

// ScriptStruct Engine.Actor.RigidBodyState
// 0x00000039
struct FRigidBodyState
{
//	 vPoperty_Size=5
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x000C (0x0004) MISSED OFFSET
	struct FQuat                                       Quaternion;                                       		// 0x0010 (0x0010) [0x0000000000000000]              
	struct FVector                                     LinVel;                                           		// 0x0020 (0x000C) [0x0000000000000000]              
	struct FVector                                     AngVel;                                           		// 0x002C (0x000C) [0x0000000000000000]              
	unsigned char                                      bNewData;                                         		// 0x0038 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.Actor.RigidBodyContactInfo
// 0x00000044
struct FRigidBodyContactInfo
{
//	 vPoperty_Size=5
	struct FVector                                     ContactPosition;                                  		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector                                     ContactNormal;                                    		// 0x000C (0x000C) [0x0000000000000000]              
	float                                              ContactPenetration;                               		// 0x0018 (0x0004) [0x0000000000000000]              
	struct FVector                                     ContactVelocity[ 0x2 ];                           		// 0x001C (0x0018) [0x0000000000000000]              
	class UPhysicalMaterial*                           PhysMaterial[ 0x2 ];                              		// 0x0034 (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.Actor.CollisionImpactData
// 0x00000028
struct FCollisionImpactData
{
//	 vPoperty_Size=3
	TArray< struct FRigidBodyContactInfo >             ContactInfos;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FVector                                     TotalNormalForceVector;                           		// 0x0010 (0x000C) [0x0000000000000000]              
	struct FVector                                     TotalFrictionForceVector;                         		// 0x001C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.Actor.PhysEffectInfo
// 0x00000018
struct FPhysEffectInfo
{
//	 vPoperty_Size=4
	float                                              Threshold;                                        		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ReFireDelay;                                      		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UParticleSystem*                             Effect;                                           		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class USoundCue*                                   Sound;                                            		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.Actor.ActorReference
// 0x00000018
struct FActorReference
{
//	 vPoperty_Size=2
	class AActor*                                      Actor;                                            		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FGuid                                       Guid;                                             		// 0x0008 (0x0010) [0x0000000000020003]              ( CPF_Edit | CPF_Const | CPF_EditConst )
};

// ScriptStruct Engine.Actor.NavReference
// 0x00000018
struct FNavReference
{
//	 vPoperty_Size=2
	class ANavigationPoint*                            Nav;                                              		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FGuid                                       Guid;                                             		// 0x0008 (0x0010) [0x0000000000020003]              ( CPF_Edit | CPF_Const | CPF_EditConst )
};

// ScriptStruct Engine.Actor.BasedPosition
// 0x00000038
struct FBasedPosition
{
//	 vPoperty_Size=5
	class AActor*                                      Base;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Position;                                         		// 0x0008 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     CachedBaseLocation;                               		// 0x0014 (0x000C) [0x0000000000000000]              
	struct FRotator                                    CachedBaseRotation;                               		// 0x0020 (0x000C) [0x0000000000000000]              
	struct FVector                                     CachedTransPosition;                              		// 0x002C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.SequenceOp.SeqOpInputLink
// 0x00000038
struct FSeqOpInputLink
{
//	 vPoperty_Size=d
	struct FString                                     LinkDesc;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bHasImpulse : 1;                                  		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                QueuedActivations;                                		// 0x0014 (0x0004) [0x0000000000000000]              
	unsigned long                                      bDisabled : 1;                                    		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bDisabledPIE : 1;                                 		// 0x0018 (0x0004) [0x0000000000000000] [0x00000002] 
	class USequenceOp*                                 LinkedOp;                                         		// 0x001C (0x0008) [0x0000000000000000]              
	int                                                DrawY;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	unsigned long                                      bHidden : 1;                                      		// 0x0028 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              ActivateDelay;                                    		// 0x002C (0x0004) [0x0000000000000000]              
	unsigned long                                      bMoving : 1;                                      		// 0x0030 (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )
	unsigned long                                      bClampedMax : 1;                                  		// 0x0030 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bClampedMin : 1;                                  		// 0x0030 (0x0004) [0x0000000000000000] [0x00000004] 
	int                                                OverrideDelta;                                    		// 0x0034 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Actor.TraceHitInfo
// 0x00000028
struct FTraceHitInfo
{
//	 vPoperty_Size=6
	class UMaterial*                                   Material;                                         		// 0x0000 (0x0008) [0x0000000000100000]              
	class UPhysicalMaterial*                           PhysMaterial;                                     		// 0x0008 (0x0008) [0x0000000000100000]              
	int                                                Item;                                             		// 0x0010 (0x0004) [0x0000000000100000]              
	int                                                LevelIndex;                                       		// 0x0014 (0x0004) [0x0000000000100000]              
	struct FName                                       BoneName;                                         		// 0x0018 (0x0008) [0x0000000000100000]              
	class UPrimitiveComponent*                         HitComponent;                                     		// 0x0020 (0x0008) [0x0000000004180008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
};

// ScriptStruct Engine.Actor.ImpactInfo
// 0x00000060
struct FImpactInfo
{
//	 vPoperty_Size=6
	class AActor*                                      HitActor;                                         		// 0x0000 (0x0008) [0x0000000000100000]              
	struct FVector                                     HitLocation;                                      		// 0x0008 (0x000C) [0x0000000000100000]              
	struct FVector                                     HitNormal;                                        		// 0x0014 (0x000C) [0x0000000000100000]              
	struct FVector                                     RayDir;                                           		// 0x0020 (0x000C) [0x0000000000100000]              
	struct FVector                                     StartTrace;                                       		// 0x002C (0x000C) [0x0000000000100000]              
	struct FTraceHitInfo                               HitInfo;                                          		// 0x0038 (0x0028) [0x0000000000180000]              ( CPF_Component )
};

// ScriptStruct Engine.Actor.AnimSlotDesc
// 0x0000000C
struct FAnimSlotDesc
{
//	 vPoperty_Size=2
	struct FName                                       SlotName;                                         		// 0x0000 (0x0008) [0x0000000000100000]              
	int                                                NumChannels;                                      		// 0x0008 (0x0004) [0x0000000000100000]              
};

// ScriptStruct Engine.Actor.AnimSlotInfo
// 0x00000018
struct FAnimSlotInfo
{
//	 vPoperty_Size=2
	struct FName                                       SlotName;                                         		// 0x0000 (0x0008) [0x0000000000100000]              
	TArray< float >                                    ChannelWeights;                                   		// 0x0008 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.Actor.TimerData
// 0x00000020
struct FTimerData
{
//	 vPoperty_Size=7
	unsigned long                                      bLoop : 1;                                        		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bPaused : 1;                                      		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	struct FName                                       FuncName;                                         		// 0x0004 (0x0008) [0x0000000000000000]              
	float                                              Rate;                                             		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              Count;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              TimerTimeDilation;                                		// 0x0014 (0x0004) [0x0000000000000000]              
	class UObject*                                     TimerObj;                                         		// 0x0018 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.LightComponent.LightingChannelContainer
// 0x00000004
struct FLightingChannelContainer
{
//	 vPoperty_Size=1b
	unsigned long                                      bInitialized : 1;                                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      BSP : 1;                                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      Static : 1;                                       		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      Dynamic : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      CompositeDynamic : 1;                             		// 0x0000 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      Skybox : 1;                                       		// 0x0000 (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      Unnamed : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned long                                      Unnamed01 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000001] [0x00000080] ( CPF_Edit )
	unsigned long                                      Unnamed02 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000001] [0x00000100] ( CPF_Edit )
	unsigned long                                      Unnamed03 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000001] [0x00000200] ( CPF_Edit )
	unsigned long                                      Unnamed04 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000001] [0x00000400] ( CPF_Edit )
	unsigned long                                      Unnamed05 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000001] [0x00000800] ( CPF_Edit )
	unsigned long                                      Cinematic : 1;                                    		// 0x0000 (0x0004) [0x0000000000000001] [0x00001000] ( CPF_Edit )
	unsigned long                                      Cinematic01 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00002000] ( CPF_Edit )
	unsigned long                                      Cinematic02 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00004000] ( CPF_Edit )
	unsigned long                                      Cinematic03 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00008000] ( CPF_Edit )
	unsigned long                                      Cinematic04 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00010000] ( CPF_Edit )
	unsigned long                                      Cinematic05 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00020000] ( CPF_Edit )
	unsigned long                                      Cinematic06 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00040000] ( CPF_Edit )
	unsigned long                                      Cinematic07 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00080000] ( CPF_Edit )
	unsigned long                                      Cinematic08 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00100000] ( CPF_Edit )
	unsigned long                                      Cinematic09 : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00200000] ( CPF_Edit )
	unsigned long                                      Gameplay : 1;                                     		// 0x0000 (0x0004) [0x0000000000000001] [0x00400000] ( CPF_Edit )
	unsigned long                                      Gameplay01 : 1;                                   		// 0x0000 (0x0004) [0x0000000000000001] [0x00800000] ( CPF_Edit )
	unsigned long                                      Gameplay02 : 1;                                   		// 0x0000 (0x0004) [0x0000000000000001] [0x01000000] ( CPF_Edit )
	unsigned long                                      Gameplay03 : 1;                                   		// 0x0000 (0x0004) [0x0000000000000001] [0x02000000] ( CPF_Edit )
	unsigned long                                      Crowd : 1;                                        		// 0x0000 (0x0004) [0x0000000000000001] [0x04000000] ( CPF_Edit )
};

// ScriptStruct Engine.PrimitiveComponent.RBCollisionChannelContainer
// 0x00000004
struct FRBCollisionChannelContainer
{
//	 vPoperty_Size=13
	unsigned long                                      Default : 1;                                      		// 0x0000 (0x0004) [0x0000000000000003] [0x00000001] ( CPF_Edit | CPF_Const )
	unsigned long                                      Nothing : 1;                                      		// 0x0000 (0x0004) [0x0000000000000002] [0x00000002] ( CPF_Const )
	unsigned long                                      Pawn : 1;                                         		// 0x0000 (0x0004) [0x0000000000000003] [0x00000004] ( CPF_Edit | CPF_Const )
	unsigned long                                      Vehicle : 1;                                      		// 0x0000 (0x0004) [0x0000000000000003] [0x00000008] ( CPF_Edit | CPF_Const )
	unsigned long                                      Water : 1;                                        		// 0x0000 (0x0004) [0x0000000000000003] [0x00000010] ( CPF_Edit | CPF_Const )
	unsigned long                                      GameplayPhysics : 1;                              		// 0x0000 (0x0004) [0x0000000000000003] [0x00000020] ( CPF_Edit | CPF_Const )
	unsigned long                                      EffectPhysics : 1;                                		// 0x0000 (0x0004) [0x0000000000000003] [0x00000040] ( CPF_Edit | CPF_Const )
	unsigned long                                      Untitled1 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000003] [0x00000080] ( CPF_Edit | CPF_Const )
	unsigned long                                      Untitled2 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000003] [0x00000100] ( CPF_Edit | CPF_Const )
	unsigned long                                      Untitled3 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000003] [0x00000200] ( CPF_Edit | CPF_Const )
	unsigned long                                      Untitled4 : 1;                                    		// 0x0000 (0x0004) [0x0000000000000003] [0x00000400] ( CPF_Edit | CPF_Const )
	unsigned long                                      Cloth : 1;                                        		// 0x0000 (0x0004) [0x0000000000000003] [0x00000800] ( CPF_Edit | CPF_Const )
	unsigned long                                      FluidDrain : 1;                                   		// 0x0000 (0x0004) [0x0000000000000003] [0x00001000] ( CPF_Edit | CPF_Const )
	unsigned long                                      SoftBody : 1;                                     		// 0x0000 (0x0004) [0x0000000000000003] [0x00002000] ( CPF_Edit | CPF_Const )
	unsigned long                                      FracturedMeshPart : 1;                            		// 0x0000 (0x0004) [0x0000000000000003] [0x00004000] ( CPF_Edit | CPF_Const )
	unsigned long                                      BlockingVolume : 1;                               		// 0x0000 (0x0004) [0x0000000000000003] [0x00008000] ( CPF_Edit | CPF_Const )
	unsigned long                                      DeadPawn : 1;                                     		// 0x0000 (0x0004) [0x0000000000000003] [0x00010000] ( CPF_Edit | CPF_Const )
	unsigned long                                      Clothing : 1;                                     		// 0x0000 (0x0004) [0x0000000000000003] [0x00020000] ( CPF_Edit | CPF_Const )
	unsigned long                                      ClothingCollision : 1;                            		// 0x0000 (0x0004) [0x0000000000000003] [0x00040000] ( CPF_Edit | CPF_Const )
};

// ScriptStruct Engine.PrimitiveComponent.MaterialViewRelevance
// 0x00000004
struct FMaterialViewRelevance
{
//	 vPoperty_Size=6
	unsigned long                                      bOpaque : 1;                                      		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bTranslucent : 1;                                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bDistortion : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bOneLayerDistortionRelevance : 1;                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      bLit : 1;                                         		// 0x0000 (0x0004) [0x0000000000000000] [0x00000010] 
	unsigned long                                      bUsesSceneColor : 1;                              		// 0x0000 (0x0004) [0x0000000000000000] [0x00000020] 
};

// ScriptStruct Engine.Texture.TextureGroupContainer
// 0x00000004
struct FTextureGroupContainer
{
//	 vPoperty_Size=1c
	unsigned long                                      TEXTUREGROUP_World : 1;                           		// 0x0000 (0x0004) [0x0000000000000003] [0x00000001] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_WorldNormalMap : 1;                  		// 0x0000 (0x0004) [0x0000000000000003] [0x00000002] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_WorldSpecular : 1;                   		// 0x0000 (0x0004) [0x0000000000000003] [0x00000004] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Character : 1;                       		// 0x0000 (0x0004) [0x0000000000000003] [0x00000008] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_CharacterNormalMap : 1;              		// 0x0000 (0x0004) [0x0000000000000003] [0x00000010] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_CharacterSpecular : 1;               		// 0x0000 (0x0004) [0x0000000000000003] [0x00000020] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Weapon : 1;                          		// 0x0000 (0x0004) [0x0000000000000003] [0x00000040] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_WeaponNormalMap : 1;                 		// 0x0000 (0x0004) [0x0000000000000003] [0x00000080] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_WeaponSpecular : 1;                  		// 0x0000 (0x0004) [0x0000000000000003] [0x00000100] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Vehicle : 1;                         		// 0x0000 (0x0004) [0x0000000000000003] [0x00000200] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_VehicleNormalMap : 1;                		// 0x0000 (0x0004) [0x0000000000000003] [0x00000400] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_VehicleSpecular : 1;                 		// 0x0000 (0x0004) [0x0000000000000003] [0x00000800] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Cinematic : 1;                       		// 0x0000 (0x0004) [0x0000000000000003] [0x00001000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Effects : 1;                         		// 0x0000 (0x0004) [0x0000000000000003] [0x00002000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_EffectsNotFiltered : 1;              		// 0x0000 (0x0004) [0x0000000000000003] [0x00004000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Skybox : 1;                          		// 0x0000 (0x0004) [0x0000000000000003] [0x00008000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_UI : 1;                              		// 0x0000 (0x0004) [0x0000000000000003] [0x00010000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Lightmap : 1;                        		// 0x0000 (0x0004) [0x0000000000000003] [0x00020000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_RenderTarget : 1;                    		// 0x0000 (0x0004) [0x0000000000000003] [0x00040000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_MobileFlattened : 1;                 		// 0x0000 (0x0004) [0x0000000000000003] [0x00080000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_ProcBuilding_Face : 1;               		// 0x0000 (0x0004) [0x0000000000000003] [0x00100000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_ProcBuilding_LightMap : 1;           		// 0x0000 (0x0004) [0x0000000000000003] [0x00200000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Shadowmap : 1;                       		// 0x0000 (0x0004) [0x0000000000000003] [0x00400000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_ColorLookupTable : 1;                		// 0x0000 (0x0004) [0x0000000000000003] [0x00800000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Terrain_Heightmap : 1;               		// 0x0000 (0x0004) [0x0000000000000003] [0x01000000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Terrain_Weightmap : 1;               		// 0x0000 (0x0004) [0x0000000000000003] [0x02000000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_ImageBasedReflection : 1;            		// 0x0000 (0x0004) [0x0000000000000003] [0x04000000] ( CPF_Edit | CPF_Const )
	unsigned long                                      TEXTUREGROUP_Bokeh : 1;                           		// 0x0000 (0x0004) [0x0000000000000003] [0x08000000] ( CPF_Edit | CPF_Const )
};

// ScriptStruct Engine.Texture2D.Texture2DMipMap
// 0x00000048
struct FTexture2DMipMap
{
//	 vPoperty_Size=3
	struct FUntypedBulkData_Mirror                     Data;                                             		// 0x0000 (0x0040) [0x0000000000001000]              ( CPF_Native )
	int                                                SizeX;                                            		// 0x0040 (0x0004) [0x0000000000001000]              ( CPF_Native )
	int                                                SizeY;                                            		// 0x0044 (0x0004) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct Engine.Texture2D.TextureLinkedListMirror
// 0x00000018
struct FTextureLinkedListMirror
{
//	 vPoperty_Size=3
	struct FPointer                                    Element;                                          		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    Next;                                             		// 0x0008 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    PrevLink;                                         		// 0x0010 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.Info.KeyValuePair
// 0x00000020
struct FKeyValuePair
{
//	 vPoperty_Size=2
	struct FString                                     Key;                                              		// 0x0000 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Value;                                            		// 0x0010 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.Info.PlayerResponseLine
// 0x00000034
struct FPlayerResponseLine
{
//	 vPoperty_Size=7
	int                                                PlayerNum;                                        		// 0x0000 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	int                                                PlayerID;                                         		// 0x0004 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	struct FString                                     PlayerName;                                       		// 0x0008 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                Ping;                                             		// 0x0018 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	int                                                Score;                                            		// 0x001C (0x0004) [0x0000000000100001]              ( CPF_Edit )
	int                                                StatsID;                                          		// 0x0020 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	TArray< struct FKeyValuePair >                     PlayerInfo;                                       		// 0x0024 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.Info.ServerResponseLine
// 0x00000078
struct FServerResponseLine
{
//	 vPoperty_Size=c
	int                                                ServerID;                                         		// 0x0000 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	struct FString                                     IP;                                               		// 0x0004 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                Port;                                             		// 0x0014 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	int                                                QueryPort;                                        		// 0x0018 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	struct FString                                     ServerName;                                       		// 0x001C (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     MapName;                                          		// 0x002C (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     GameType;                                         		// 0x003C (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                CurrentPlayers;                                   		// 0x004C (0x0004) [0x0000000000100001]              ( CPF_Edit )
	int                                                MaxPlayers;                                       		// 0x0050 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	int                                                Ping;                                             		// 0x0054 (0x0004) [0x0000000000100001]              ( CPF_Edit )
	TArray< struct FKeyValuePair >                     ServerInfo;                                       		// 0x0058 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FPlayerResponseLine >               PlayerInfo;                                       		// 0x0068 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.Settings.LocalizedStringSetting
// 0x00000009
struct FLocalizedStringSetting
{
//	 vPoperty_Size=3
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                ValueIndex;                                       		// 0x0004 (0x0004) [0x0000000000000000]              
	unsigned char                                      AdvertisementType;                                		// 0x0008 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.Settings.SettingsData
// 0x00000010
struct FSettingsData
{
//	 vPoperty_Size=3
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000002]              ( CPF_Const )
	int                                                Value1;                                           		// 0x0004 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FPointer                                    Value2;                                           		// 0x0008 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
};

// ScriptStruct Engine.Settings.SettingsProperty
// 0x00000015
struct FSettingsProperty
{
//	 vPoperty_Size=3
	int                                                PropertyId;                                       		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FSettingsData                               Data;                                             		// 0x0004 (0x0010) [0x0000000000000000]              
	unsigned char                                      AdvertisementType;                                		// 0x0014 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.Settings.IdToStringMapping
// 0x0000000C
struct FIdToStringMapping
{
//	 vPoperty_Size=2
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FName                                       Name;                                             		// 0x0004 (0x0008) [0x0000000000008002]              ( CPF_Const | CPF_Localized )
};

// ScriptStruct Engine.Settings.StringIdToStringMapping
// 0x00000010
struct FStringIdToStringMapping
{
//	 vPoperty_Size=3
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FName                                       Name;                                             		// 0x0004 (0x0008) [0x0000000000008002]              ( CPF_Const | CPF_Localized )
	unsigned long                                      bIsWildcard : 1;                                  		// 0x000C (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
};

// ScriptStruct Engine.Settings.LocalizedStringSettingMetaData
// 0x0000002C
struct FLocalizedStringSettingMetaData
{
//	 vPoperty_Size=4
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FName                                       Name;                                             		// 0x0004 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     ColumnHeaderText;                                 		// 0x000C (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	TArray< struct FStringIdToStringMapping >          ValueMappings;                                    		// 0x001C (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
};

// ScriptStruct Engine.Settings.SettingsPropertyPropertyMetaData
// 0x0000004C
struct FSettingsPropertyPropertyMetaData
{
//	 vPoperty_Size=9
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FName                                       Name;                                             		// 0x0004 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     ColumnHeaderText;                                 		// 0x000C (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	unsigned char                                      MappingType;                                      		// 0x001C (0x0001) [0x0000000000000002]              ( CPF_Const )
	TArray< struct FIdToStringMapping >                ValueMappings;                                    		// 0x0020 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< struct FSettingsData >                     PredefinedValues;                                 		// 0x0030 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	float                                              MinVal;                                           		// 0x0040 (0x0004) [0x0000000000000002]              ( CPF_Const )
	float                                              MaxVal;                                           		// 0x0044 (0x0004) [0x0000000000000002]              ( CPF_Const )
	float                                              RangeIncrement;                                   		// 0x0048 (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.OnlineSubsystem.UniqueNetId
// 0x00000008
struct FUniqueNetId
{
//	 vPoperty_Size=1
	struct FQWord                                      Uid;                                              		// 0x0000 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineSubsystem.OnlineRegistrant
// 0x00000008
struct FOnlineRegistrant
{
//	 vPoperty_Size=1
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.OnlineSubsystem.OnlineArbitrationRegistrant
// 0x000C(0x0014 - 0x0008)
struct FOnlineArbitrationRegistrant : FOnlineRegistrant
{
//	 vPoperty_Size=2
	struct FQWord                                      MachineId;                                        		// 0x0008 (0x0008) [0x0000000000000002]              ( CPF_Const )
	int                                                Trustworthiness;                                  		// 0x0010 (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.OnlineSubsystem.NamedSession
// 0x00000038
struct FNamedSession
{
//	 vPoperty_Size=5
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FPointer                                    SessionInfo;                                      		// 0x0008 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	class UOnlineGameSettings*                         GameSettings;                                     		// 0x0010 (0x0008) [0x0000000000000000]              
	TArray< struct FOnlineRegistrant >                 Registrants;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FOnlineArbitrationRegistrant >      ArbitrationRegistrants;                           		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.NamedInterface
// 0x00000010
struct FNamedInterface
{
//	 vPoperty_Size=2
	struct FName                                       InterfaceName;                                    		// 0x0000 (0x0008) [0x0000000000000000]              
	class UObject*                                     InterfaceObject;                                  		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineSubsystem.SocialPostImageFlags
// 0x00000004
struct FSocialPostImageFlags
{
//	 vPoperty_Size=4
	unsigned long                                      bIsUserGeneratedImage : 1;                        		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bIsGameGeneratedImage : 1;                        		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bIsAchievementImage : 1;                          		// 0x0000 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bIsMediaImage : 1;                                		// 0x0000 (0x0004) [0x0000000000000000] [0x00000008] 
};

// ScriptStruct Engine.OnlineSubsystem.SocialPostImageInfo
// 0x00000044
struct FSocialPostImageInfo
{
//	 vPoperty_Size=5
	struct FSocialPostImageFlags                       Flags;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     MessageText;                                      		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     TitleText;                                        		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     PictureCaption;                                   		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     PictureDescription;                               		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.SocialPostLinkInfo
// 0x0020(0x0064 - 0x0044)
struct FSocialPostLinkInfo : FSocialPostImageInfo
{
//	 vPoperty_Size=2
	struct FString                                     TitleURL;                                         		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     PictureURL;                                       		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.SocialPostPrivileges
// 0x00000004
struct FSocialPostPrivileges
{
//	 vPoperty_Size=2
	unsigned long                                      bCanPostImage : 1;                                		// 0x0000 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	unsigned long                                      bCanPostLink : 1;                                 		// 0x0000 (0x0004) [0x0000000000000002] [0x00000002] ( CPF_Const )
};

// ScriptStruct Engine.OnlineSubsystem.OnlinePartyMember
// 0x0000003C
struct FOnlinePartyMember
{
//	 vPoperty_Size=f
	struct FUniqueNetId                                UniqueId;                                         		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     NickName;                                         		// 0x0008 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	unsigned char                                      LocalUserNum;                                     		// 0x0018 (0x0001) [0x0000000000000002]              ( CPF_Const )
	unsigned char                                      NatType;                                          		// 0x0019 (0x0001) [0x0000000000000002]              ( CPF_Const )
	int                                                TitleId;                                          		// 0x001C (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bIsLocal : 1;                                     		// 0x0020 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	unsigned long                                      bIsInPartyVoice : 1;                              		// 0x0020 (0x0004) [0x0000000000000002] [0x00000002] ( CPF_Const )
	unsigned long                                      bIsTalking : 1;                                   		// 0x0020 (0x0004) [0x0000000000000002] [0x00000004] ( CPF_Const )
	unsigned long                                      bIsInGameSession : 1;                             		// 0x0020 (0x0004) [0x0000000000000002] [0x00000008] ( CPF_Const )
	unsigned long                                      bIsPlayingThisGame : 1;                           		// 0x0020 (0x0004) [0x0000000000000002] [0x00000010] ( CPF_Const )
	struct FQWord                                      SessionId;                                        		// 0x0024 (0x0008) [0x0000000000000002]              ( CPF_Const )
	int                                                Data1;                                            		// 0x002C (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                Data2;                                            		// 0x0030 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                Data3;                                            		// 0x0034 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                Data4;                                            		// 0x0038 (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.OnlineSubsystem.AchievementDetails
// 0x00000048
struct FAchievementDetails
{
//	 vPoperty_Size=d
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     AchievementName;                                  		// 0x0004 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FString                                     Description;                                      		// 0x0014 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FString                                     HowTo;                                            		// 0x0024 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	class USurface*                                    Image;                                            		// 0x0034 (0x0008) [0x0000000000000000]              
	unsigned char                                      MonthEarned;                                      		// 0x003C (0x0001) [0x0000000000000002]              ( CPF_Const )
	unsigned char                                      DayEarned;                                        		// 0x003D (0x0001) [0x0000000000000002]              ( CPF_Const )
	unsigned char                                      YearEarned;                                       		// 0x003E (0x0001) [0x0000000000000002]              ( CPF_Const )
	unsigned char                                      DayOfWeekEarned;                                  		// 0x003F (0x0001) [0x0000000000000002]              ( CPF_Const )
	int                                                GamerPoints;                                      		// 0x0040 (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bIsSecret : 1;                                    		// 0x0044 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	unsigned long                                      bWasAchievedOnline : 1;                           		// 0x0044 (0x0004) [0x0000000000000002] [0x00000002] ( CPF_Const )
	unsigned long                                      bWasAchievedOffline : 1;                          		// 0x0044 (0x0004) [0x0000000000000002] [0x00000004] ( CPF_Const )
};

// ScriptStruct Engine.OnlineSubsystem.CommunityContentMetadata
// 0x00000014
struct FCommunityContentMetadata
{
//	 vPoperty_Size=2
	int                                                ContentType;                                      		// 0x0000 (0x0004) [0x0000000000000000]              
	TArray< struct FSettingsProperty >                 MetadataItems;                                    		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.CommunityContentFile
// 0x00000038
struct FCommunityContentFile
{
//	 vPoperty_Size=a
	int                                                ContentId;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                FileId;                                           		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                ContentType;                                      		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                FileSize;                                         		// 0x000C (0x0004) [0x0000000000000000]              
	struct FUniqueNetId                                Owner;                                            		// 0x0010 (0x0008) [0x0000000000000000]              
	int                                                DownloadCount;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	float                                              AverageRating;                                    		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                RatingCount;                                      		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                LastRatingGiven;                                  		// 0x0024 (0x0004) [0x0000000000000000]              
	struct FString                                     LocalFilePath;                                    		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.TitleFile
// 0x00000024
struct FTitleFile
{
//	 vPoperty_Size=3
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      AsyncState;                                       		// 0x0010 (0x0001) [0x0000000000000000]              
	TArray< unsigned char >                            Data;                                             		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.EmsFile
// 0x00000044
struct FEmsFile
{
//	 vPoperty_Size=5
	struct FString                                     Hash;                                             		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0020 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                FileSize;                                         		// 0x0030 (0x0004) [0x0000000000000000]              
	struct FString                                     UploadedDateTime;                                 		// 0x0034 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.NamedInterfaceDef
// 0x00000018
struct FNamedInterfaceDef
{
//	 vPoperty_Size=2
	struct FName                                       InterfaceName;                                    		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     InterfaceClassName;                               		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.OnlineFriendMessage
// 0x0000002C
struct FOnlineFriendMessage
{
//	 vPoperty_Size=7
	struct FUniqueNetId                                SendingPlayerId;                                  		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     SendingPlayerNick;                                		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bIsFriendInvite : 1;                              		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bIsGameInvite : 1;                                		// 0x0018 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bWasAccepted : 1;                                 		// 0x0018 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bWasDenied : 1;                                   		// 0x0018 (0x0004) [0x0000000000000000] [0x00000008] 
	struct FString                                     Message;                                          		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.RemoteTalker
// 0x00000010
struct FRemoteTalker
{
//	 vPoperty_Size=5
	struct FUniqueNetId                                TalkerId;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              LastNotificationTime;                             		// 0x0008 (0x0004) [0x0000000000000000]              
	unsigned long                                      bWasTalking : 1;                                  		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bIsTalking : 1;                                   		// 0x000C (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bIsRegistered : 1;                                		// 0x000C (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct Engine.OnlineSubsystem.LocalTalker
// 0x00000004
struct FLocalTalker
{
//	 vPoperty_Size=6
	unsigned long                                      bHasVoice : 1;                                    		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bHasNetworkedVoice : 1;                           		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bIsRecognizingSpeech : 1;                         		// 0x0000 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bWasTalking : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      bIsTalking : 1;                                   		// 0x0000 (0x0004) [0x0000000000000000] [0x00000010] 
	unsigned long                                      bIsRegistered : 1;                                		// 0x0000 (0x0004) [0x0000000000000000] [0x00000020] 
};

// ScriptStruct Engine.OnlineSubsystem.OnlinePlayerScore
// 0x00000010
struct FOnlinePlayerScore
{
//	 vPoperty_Size=3
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                TeamID;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                Score;                                            		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineSubsystem.SpeechRecognizedWord
// 0x00000018
struct FSpeechRecognizedWord
{
//	 vPoperty_Size=3
	int                                                WordId;                                           		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     WordText;                                         		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              Confidence;                                       		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineSubsystem.OnlineContent
// 0x00000060
struct FOnlineContent
{
//	 vPoperty_Size=a
	unsigned char                                      ContentType;                                      		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned char                                      UserIndex;                                        		// 0x0001 (0x0001) [0x0000000000000000]              
	unsigned long                                      bIsCorrupt : 1;                                   		// 0x0004 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                DeviceID;                                         		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                LicenseMask;                                      		// 0x000C (0x0004) [0x0000000000000000]              
	struct FString                                     FriendlyName;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ContentPath;                                      		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           ContentPackages;                                  		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           ContentFiles;                                     		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineSubsystem.OnlineCrossTitleContent
// 0x0004(0x0064 - 0x0060)
struct FOnlineCrossTitleContent : FOnlineContent
{
//	 vPoperty_Size=1
	int                                                TitleId;                                          		// 0x0060 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineSubsystem.OnlineFriend
// 0x00000038
struct FOnlineFriend
{
//	 vPoperty_Size=c
	struct FUniqueNetId                                UniqueId;                                         		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FQWord                                      SessionId;                                        		// 0x0008 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     NickName;                                         		// 0x0010 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FString                                     PresenceInfo;                                     		// 0x0020 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	unsigned char                                      FriendState;                                      		// 0x0030 (0x0001) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bIsOnline : 1;                                    		// 0x0034 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	unsigned long                                      bIsPlaying : 1;                                   		// 0x0034 (0x0004) [0x0000000000000002] [0x00000002] ( CPF_Const )
	unsigned long                                      bIsPlayingThisGame : 1;                           		// 0x0034 (0x0004) [0x0000000000000002] [0x00000004] ( CPF_Const )
	unsigned long                                      bIsJoinable : 1;                                  		// 0x0034 (0x0004) [0x0000000000000002] [0x00000008] ( CPF_Const )
	unsigned long                                      bHasVoiceSupport : 1;                             		// 0x0034 (0x0004) [0x0000000000000002] [0x00000010] ( CPF_Const )
	unsigned long                                      bHaveInvited : 1;                                 		// 0x0034 (0x0004) [0x0000000000000000] [0x00000020] 
	unsigned long                                      bHasInvitedYou : 1;                               		// 0x0034 (0x0004) [0x0000000000000002] [0x00000040] ( CPF_Const )
};

// ScriptStruct Engine.OnlineSubsystem.FriendsQuery
// 0x0000000C
struct FFriendsQuery
{
//	 vPoperty_Size=2
	struct FUniqueNetId                                UniqueId;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned long                                      bIsFriend : 1;                                    		// 0x0008 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.OnlineAuthInterface.BaseAuthSession
// 0x00000010
struct FBaseAuthSession
{
//	 vPoperty_Size=3
	int                                                EndPointIP;                                       		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                EndPointPort;                                     		// 0x0004 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FUniqueNetId                                EndPointUID;                                      		// 0x0008 (0x0008) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.AccessControl.PendingClientAuth
// 0x00000018
struct FPendingClientAuth
{
//	 vPoperty_Size=4
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FUniqueNetId                                ClientUID;                                        		// 0x0008 (0x0008) [0x0000000000000000]              
	float                                              AuthTimestamp;                                    		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                AuthRetryCount;                                   		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.AccessControl.ServerAuthRetry
// 0x0000000C
struct FServerAuthRetry
{
//	 vPoperty_Size=2
	struct FUniqueNetId                                ClientUID;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                AuthRetryCount;                                   		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineAuthInterface.LocalAuthSession
// 0x0004(0x0014 - 0x0010)
struct FLocalAuthSession : FBaseAuthSession
{
//	 vPoperty_Size=1
	int                                                SessionUID;                                       		// 0x0010 (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.OnlineAuthInterface.AuthSession
// 0x0008(0x0018 - 0x0010)
struct FAuthSession : FBaseAuthSession
{
//	 vPoperty_Size=2
	unsigned char                                      AuthStatus;                                       		// 0x0010 (0x0001) [0x0000000000000002]              ( CPF_Const )
	int                                                AuthTicketUID;                                    		// 0x0014 (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.Controller.VisiblePortalInfo
// 0x00000010
struct FVisiblePortalInfo
{
//	 vPoperty_Size=2
	class AActor*                                      Source;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
	class AActor*                                      Destination;                                      		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.PostProcessVolume.LUTBlender
// 0x00000024
struct FLUTBlender
{
//	 vPoperty_Size=3
	TArray< class UTexture* >                          LUTTextures;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< float >                                    LUTWeights;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bHasChanged : 1;                                  		// 0x0020 (0x0004) [0x0000000000003002] [0x00000001] ( CPF_Const | CPF_Native | CPF_Transient )
};

// ScriptStruct Engine.PostProcessVolume.MobileColorGradingParams
// 0x0000003C
struct FMobileColorGradingParams
{
//	 vPoperty_Size=6
	float                                              TransitionTime;                                   		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Blend;                                            		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Desaturation;                                     		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                HighLights;                                       		// 0x000C (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                MidTones;                                         		// 0x001C (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                Shadows;                                          		// 0x002C (0x0010) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.PostProcessVolume.MobilePostProcessSettings
// 0x00000034
struct FMobilePostProcessSettings
{
//	 vPoperty_Size=12
	unsigned long                                      bOverride_Mobile_BlurAmount : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bOverride_Mobile_TransitionTime : 1;              		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bOverride_Mobile_Bloom_Scale : 1;                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bOverride_Mobile_Bloom_Threshold : 1;             		// 0x0000 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      bOverride_Mobile_Bloom_Tint : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000010] 
	unsigned long                                      bOverride_Mobile_DOF_Distance : 1;                		// 0x0000 (0x0004) [0x0000000000000000] [0x00000020] 
	unsigned long                                      bOverride_Mobile_DOF_MinRange : 1;                		// 0x0000 (0x0004) [0x0000000000000000] [0x00000040] 
	unsigned long                                      bOverride_Mobile_DOF_MaxRange : 1;                		// 0x0000 (0x0004) [0x0000000000000000] [0x00000080] 
	unsigned long                                      bOverride_Mobile_DOF_FarBlurFactor : 1;           		// 0x0000 (0x0004) [0x0000000000000000] [0x00000100] 
	float                                              Mobile_BlurAmount;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mobile_TransitionTime;                            		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mobile_Bloom_Scale;                               		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mobile_Bloom_Threshold;                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                Mobile_Bloom_Tint;                                		// 0x0014 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mobile_DOF_Distance;                              		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mobile_DOF_MinRange;                              		// 0x0028 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mobile_DOF_MaxRange;                              		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mobile_DOF_FarBlurFactor;                         		// 0x0030 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.PostProcessVolume.PostProcessSettings
// 0x00000160
struct FPostProcessSettings
{
//	 vPoperty_Size=54
	unsigned long                                      bOverride_EnableBloom : 1;                        		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bOverride_EnableDOF : 1;                          		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bOverride_EnableMotionBlur : 1;                   		// 0x0000 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bOverride_EnableSceneEffect : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      bOverride_AllowAmbientOcclusion : 1;              		// 0x0000 (0x0004) [0x0000000000000000] [0x00000010] 
	unsigned long                                      bOverride_OverrideRimShaderColor : 1;             		// 0x0000 (0x0004) [0x0000000000000000] [0x00000020] 
	unsigned long                                      bOverride_Bloom_Scale : 1;                        		// 0x0000 (0x0004) [0x0000000000000000] [0x00000040] 
	unsigned long                                      bOverride_Bloom_Threshold : 1;                    		// 0x0000 (0x0004) [0x0000000000000000] [0x00000080] 
	unsigned long                                      bOverride_Bloom_Tint : 1;                         		// 0x0000 (0x0004) [0x0000000000000000] [0x00000100] 
	unsigned long                                      bOverride_Bloom_ScreenBlendThreshold : 1;         		// 0x0000 (0x0004) [0x0000000000000000] [0x00000200] 
	unsigned long                                      bOverride_Bloom_InterpolationDuration : 1;        		// 0x0000 (0x0004) [0x0000000000000000] [0x00000400] 
	unsigned long                                      bOverride_DOF_FalloffExponent : 1;                		// 0x0000 (0x0004) [0x0000000000000000] [0x00000800] 
	unsigned long                                      bOverride_DOF_BlurKernelSize : 1;                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00001000] 
	unsigned long                                      bOverride_DOF_BlurBloomKernelSize : 1;            		// 0x0000 (0x0004) [0x0000000000000000] [0x00002000] 
	unsigned long                                      bOverride_DOF_MaxNearBlurAmount : 1;              		// 0x0000 (0x0004) [0x0000000000000000] [0x00004000] 
	unsigned long                                      bOverride_DOF_MinBlurAmount : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00008000] 
	unsigned long                                      bOverride_DOF_MaxFarBlurAmount : 1;               		// 0x0000 (0x0004) [0x0000000000000000] [0x00010000] 
	unsigned long                                      bOverride_DOF_FocusType : 1;                      		// 0x0000 (0x0004) [0x0000000000000000] [0x00020000] 
	unsigned long                                      bOverride_DOF_FocusInnerRadius : 1;               		// 0x0000 (0x0004) [0x0000000000000000] [0x00040000] 
	unsigned long                                      bOverride_DOF_FocusDistance : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00080000] 
	unsigned long                                      bOverride_DOF_FocusPosition : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00100000] 
	unsigned long                                      bOverride_DOF_InterpolationDuration : 1;          		// 0x0000 (0x0004) [0x0000000000000000] [0x00200000] 
	unsigned long                                      bOverride_DOF_BokehTexture : 1;                   		// 0x0000 (0x0004) [0x0000000000000000] [0x00400000] 
	unsigned long                                      bOverride_MotionBlur_MaxVelocity : 1;             		// 0x0000 (0x0004) [0x0000000000000000] [0x00800000] 
	unsigned long                                      bOverride_MotionBlur_Amount : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x01000000] 
	unsigned long                                      bOverride_MotionBlur_FullMotionBlur : 1;          		// 0x0000 (0x0004) [0x0000000000000000] [0x02000000] 
	unsigned long                                      bOverride_MotionBlur_CameraRotationThreshold : 1; 		// 0x0000 (0x0004) [0x0000000000000000] [0x04000000] 
	unsigned long                                      bOverride_MotionBlur_CameraTranslationThreshold : 1;		// 0x0000 (0x0004) [0x0000000000000000] [0x08000000] 
	unsigned long                                      bOverride_MotionBlur_InterpolationDuration : 1;   		// 0x0000 (0x0004) [0x0000000000000000] [0x10000000] 
	unsigned long                                      bOverride_Scene_Desaturation : 1;                 		// 0x0000 (0x0004) [0x0000000000000000] [0x20000000] 
	unsigned long                                      bOverride_Scene_Colorize : 1;                     		// 0x0000 (0x0004) [0x0000000000000000] [0x40000000] 
	unsigned long                                      bOverride_Scene_TonemapperScale : 1;              		// 0x0000 (0x0004) [0x0000000000000000] [0x80000000] 
	unsigned long                                      bOverride_Scene_ImageGrainScale : 1;              		// 0x0004 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bOverride_Scene_HighLights : 1;                   		// 0x0004 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bOverride_Scene_MidTones : 1;                     		// 0x0004 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bOverride_Scene_Shadows : 1;                      		// 0x0004 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      bOverride_Scene_InterpolationDuration : 1;        		// 0x0004 (0x0004) [0x0000000000000000] [0x00000010] 
	unsigned long                                      bOverride_Scene_ColorGradingLUT : 1;              		// 0x0004 (0x0004) [0x0000000000000000] [0x00000020] 
	unsigned long                                      bOverride_RimShader_Color : 1;                    		// 0x0004 (0x0004) [0x0000000000000000] [0x00000040] 
	unsigned long                                      bOverride_RimShader_InterpolationDuration : 1;    		// 0x0004 (0x0004) [0x0000000000000000] [0x00000080] 
	unsigned long                                      bOverride_MobileColorGrading : 1;                 		// 0x0004 (0x0004) [0x0000000000000000] [0x00000100] 
	unsigned long                                      bEnableBloom : 1;                                 		// 0x0004 (0x0004) [0x0000000000000001] [0x00000200] ( CPF_Edit )
	unsigned long                                      bEnableDOF : 1;                                   		// 0x0004 (0x0004) [0x0000000000000001] [0x00000400] ( CPF_Edit )
	unsigned long                                      bEnableMotionBlur : 1;                            		// 0x0004 (0x0004) [0x0000000000000001] [0x00000800] ( CPF_Edit )
	unsigned long                                      bEnableSceneEffect : 1;                           		// 0x0004 (0x0004) [0x0000000000000001] [0x00001000] ( CPF_Edit )
	unsigned long                                      bAllowAmbientOcclusion : 1;                       		// 0x0004 (0x0004) [0x0000000000000001] [0x00002000] ( CPF_Edit )
	unsigned long                                      bOverrideRimShaderColor : 1;                      		// 0x0004 (0x0004) [0x0000000000000001] [0x00004000] ( CPF_Edit )
	float                                              Bloom_Scale;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Bloom_Threshold;                                  		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      Bloom_Tint;                                       		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Bloom_ScreenBlendThreshold;                       		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Bloom_InterpolationDuration;                      		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_BlurBloomKernelSize;                          		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_FalloffExponent;                              		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_BlurKernelSize;                               		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_MaxNearBlurAmount;                            		// 0x0028 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_MinBlurAmount;                                		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_MaxFarBlurAmount;                             		// 0x0030 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      DOF_FocusType;                                    		// 0x0034 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_FocusInnerRadius;                             		// 0x0038 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_FocusDistance;                                		// 0x003C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     DOF_FocusPosition;                                		// 0x0040 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	float                                              DOF_InterpolationDuration;                        		// 0x004C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UTexture2D*                                  DOF_BokehTexture;                                 		// 0x0050 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              MotionBlur_MaxVelocity;                           		// 0x0058 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MotionBlur_Amount;                                		// 0x005C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      MotionBlur_FullMotionBlur : 1;                    		// 0x0060 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              MotionBlur_CameraRotationThreshold;               		// 0x0064 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MotionBlur_CameraTranslationThreshold;            		// 0x0068 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MotionBlur_InterpolationDuration;                 		// 0x006C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Scene_Desaturation;                               		// 0x0070 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Scene_Colorize;                                   		// 0x0074 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	float                                              Scene_TonemapperScale;                            		// 0x0080 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Scene_ImageGrainScale;                            		// 0x0084 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Scene_HighLights;                                 		// 0x0088 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Scene_MidTones;                                   		// 0x0094 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Scene_Shadows;                                    		// 0x00A0 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	float                                              Scene_InterpolationDuration;                      		// 0x00AC (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                RimShader_Color;                                  		// 0x00B0 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	float                                              RimShader_InterpolationDuration;                  		// 0x00C0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UTexture*                                    ColorGrading_LookupTable;                         		// 0x00C4 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FLUTBlender                                 ColorGradingLUT;                                  		// 0x00CC (0x0024) [0x0000000000402002]              ( CPF_Const | CPF_Transient | CPF_NeedCtorLink )
	struct FMobileColorGradingParams                   MobileColorGrading;                               		// 0x00F0 (0x003C) [0x0000000000000001]              ( CPF_Edit )
	struct FMobilePostProcessSettings                  MobilePostProcess;                                		// 0x012C (0x0034) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.EngineBaseTypes.RenderingPerformanceOverrides
// 0x00000004
struct FRenderingPerformanceOverrides
{
//	 vPoperty_Size=5
	unsigned long                                      bAllowAmbientOcclusion : 1;                       		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bAllowDominantWholeSceneDynamicShadows : 1;       		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bAllowMotionBlurSkinning : 1;                     		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bAllowTemporalAA : 1;                             		// 0x0000 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      bAllowLightShafts : 1;                            		// 0x0000 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
};

// ScriptStruct Engine.Camera.ViewTargetTransitionParams
// 0x00000010
struct FViewTargetTransitionParams
{
//	 vPoperty_Size=4
	float                                              BlendTime;                                        		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      BlendFunction;                                    		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              BlendExp;                                         		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bLockOutgoing : 1;                                		// 0x000C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.Camera.TCameraCache
// 0x00000020
struct FTCameraCache
{
//	 vPoperty_Size=2
	float                                              TimeStamp;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FTPOV                                       POV;                                              		// 0x0004 (0x001C) [0x0000000000000000]              
};

// ScriptStruct Engine.Camera.TViewTarget
// 0x00000038
struct FTViewTarget
{
//	 vPoperty_Size=5
	class AActor*                                      Target;                                           		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AController*                                 Controller;                                       		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FTPOV                                       POV;                                              		// 0x0010 (0x001C) [0x0000000000000001]              ( CPF_Edit )
	float                                              AspectRatio;                                      		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class APlayerReplicationInfo*                      PRI;                                              		// 0x0030 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SequenceOp.SeqOpOutputInputLink
// 0x0000000C
struct FSeqOpOutputInputLink
{
//	 vPoperty_Size=2
	class USequenceOp*                                 LinkedOp;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                InputLinkIdx;                                     		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.SequenceOp.SeqOpOutputLink
// 0x00000044
struct FSeqOpOutputLink
{
//	 vPoperty_Size=f
	TArray< struct FSeqOpOutputInputLink >             Links;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     LinkDesc;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bHasImpulse : 1;                                  		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bDisabled : 1;                                    		// 0x0020 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bDisabledPIE : 1;                                 		// 0x0020 (0x0004) [0x0000000000000000] [0x00000004] 
	class USequenceOp*                                 LinkedOp;                                         		// 0x0024 (0x0008) [0x0000000000000000]              
	float                                              ActivateDelay;                                    		// 0x002C (0x0004) [0x0000000000000000]              
	int                                                DrawY;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
	unsigned long                                      bHidden : 1;                                      		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bMoving : 1;                                      		// 0x0034 (0x0004) [0x0000000000002000] [0x00000002] ( CPF_Transient )
	unsigned long                                      bClampedMax : 1;                                  		// 0x0034 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bClampedMin : 1;                                  		// 0x0034 (0x0004) [0x0000000000000000] [0x00000008] 
	int                                                OverrideDelta;                                    		// 0x0038 (0x0004) [0x0000000000000000]              
	float                                              PIEActivationTime;                                		// 0x003C (0x0004) [0x0000000000002000]              ( CPF_Transient )
	unsigned long                                      bIsActivated : 1;                                 		// 0x0040 (0x0004) [0x0000000001002000] [0x00000001] ( CPF_Transient )
};

// ScriptStruct Engine.SequenceOp.SeqVarLink
// 0x00000058
struct FSeqVarLink
{
//	 vPoperty_Size=12
	class UClass*                                      ExpectedType;                                     		// 0x0000 (0x0008) [0x0000000000000000]              
	TArray< class USequenceVariable* >                 LinkedVariables;                                  		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     LinkDesc;                                         		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FName                                       LinkVar;                                          		// 0x0028 (0x0008) [0x0000000000000000]              
	struct FName                                       PropertyName;                                     		// 0x0030 (0x0008) [0x0000000000000000]              
	unsigned long                                      bWriteable : 1;                                   		// 0x0038 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bSequenceNeverReadsOnlyWritesToThisVar : 1;       		// 0x0038 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bModifiesLinkedObject : 1;                        		// 0x0038 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bHidden : 1;                                      		// 0x0038 (0x0004) [0x0000000000000000] [0x00000008] 
	int                                                MinVars;                                          		// 0x003C (0x0004) [0x0000000000000000]              
	int                                                MaxVars;                                          		// 0x0040 (0x0004) [0x0000000000000000]              
	int                                                DrawX;                                            		// 0x0044 (0x0004) [0x0000000000000000]              
	class UProperty*                                   CachedProperty;                                   		// 0x0048 (0x0008) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
	unsigned long                                      bAllowAnyType : 1;                                		// 0x0050 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bMoving : 1;                                      		// 0x0050 (0x0004) [0x0000000000002000] [0x00000002] ( CPF_Transient )
	unsigned long                                      bClampedMax : 1;                                  		// 0x0050 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bClampedMin : 1;                                  		// 0x0050 (0x0004) [0x0000000000000000] [0x00000008] 
	int                                                OverrideDelta;                                    		// 0x0054 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.SequenceOp.SeqEventLink
// 0x00000034
struct FSeqEventLink
{
//	 vPoperty_Size=9
	class UClass*                                      ExpectedType;                                     		// 0x0000 (0x0008) [0x0000000000000000]              
	TArray< class USequenceEvent* >                    LinkedEvents;                                     		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     LinkDesc;                                         		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                DrawX;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
	unsigned long                                      bHidden : 1;                                      		// 0x002C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bMoving : 1;                                      		// 0x002C (0x0004) [0x0000000000002000] [0x00000002] ( CPF_Transient )
	unsigned long                                      bClampedMax : 1;                                  		// 0x002C (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bClampedMin : 1;                                  		// 0x002C (0x0004) [0x0000000000000000] [0x00000008] 
	int                                                OverrideDelta;                                    		// 0x0030 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineGameSearch.OnlineGameSearchParameter
// 0x0000000E
struct FOnlineGameSearchParameter
{
//	 vPoperty_Size=4
	int                                                EntryId;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FName                                       ObjectPropertyName;                               		// 0x0004 (0x0008) [0x0000000000000000]              
	unsigned char                                      EntryType;                                        		// 0x000C (0x0001) [0x0000000000000000]              
	unsigned char                                      ComparisonType;                                   		// 0x000D (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineGameSearch.OnlineGameSearchORClause
// 0x00000010
struct FOnlineGameSearchORClause
{
//	 vPoperty_Size=1
	TArray< struct FOnlineGameSearchParameter >        OrParams;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineGameSearch.OnlineGameSearchSortClause
// 0x0000000E
struct FOnlineGameSearchSortClause
{
//	 vPoperty_Size=4
	int                                                EntryId;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FName                                       ObjectPropertyName;                               		// 0x0004 (0x0008) [0x0000000000000000]              
	unsigned char                                      EntryType;                                        		// 0x000C (0x0001) [0x0000000000000000]              
	unsigned char                                      SortType;                                         		// 0x000D (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineGameSearch.OnlineGameSearchQuery
// 0x00000020
struct FOnlineGameSearchQuery
{
//	 vPoperty_Size=2
	TArray< struct FOnlineGameSearchORClause >         OrClauses;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FOnlineGameSearchSortClause >       SortClauses;                                      		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineGameSearch.OverrideSkill
// 0x00000034
struct FOverrideSkill
{
//	 vPoperty_Size=4
	int                                                LeaderboardId;                                    		// 0x0000 (0x0004) [0x0000000000000000]              
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FDouble >                           Mus;                                              		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FDouble >                           Sigmas;                                           		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineGameSearch.NamedObjectProperty
// 0x00000018
struct FNamedObjectProperty
{
//	 vPoperty_Size=2
	struct FName                                       ObjectPropertyName;                               		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     ObjectPropertyValue;                              		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineGameSearch.OnlineGameSearchResult
// 0x00000010
struct FOnlineGameSearchResult
{
//	 vPoperty_Size=2
	class UOnlineGameSettings*                         GameSettings;                                     		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FPointer                                    PlatformData;                                     		// 0x0008 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.SkeletalMeshComponent.SkelMeshComponentLODInfo
// 0x0000001C
struct FSkelMeshComponentLODInfo
{
//	 vPoperty_Size=5
	TArray< unsigned long >                            HiddenMaterials;                                  		// 0x0000 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	unsigned long                                      bNeedsInstanceWeightUpdate : 1;                   		// 0x0010 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	unsigned long                                      bAlwaysUseInstanceWeights : 1;                    		// 0x0010 (0x0004) [0x0000000000000002] [0x00000002] ( CPF_Const )
	unsigned char                                      InstanceWeightUsage;                              		// 0x0014 (0x0001) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
	int                                                InstanceWeightIdx;                                		// 0x0018 (0x0004) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
};

// ScriptStruct Engine.AnimNodeBlendBase.AnimBlendChild
// 0x00000020
struct FAnimBlendChild
{
//	 vPoperty_Size=7
	struct FName                                       Name;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UAnimNode*                                   Anim;                                             		// 0x0008 (0x0008) [0x0000000004400008]              ( CPF_ExportObject | CPF_NeedCtorLink | CPF_EditInline )
	float                                              Weight;                                           		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              BlendWeight;                                      		// 0x0014 (0x0004) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
	unsigned long                                      bMirrorSkeleton : 1;                              		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bIsAdditive : 1;                                  		// 0x0018 (0x0004) [0x0000000000000000] [0x00000002] 
	int                                                DrawY;                                            		// 0x001C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.SkeletalMeshComponent.BonePair
// 0x00000010
struct FBonePair
{
//	 vPoperty_Size=1
	struct FName                                       Bones[ 0x2 ];                                     		// 0x0000 (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.SkeletalMeshComponent.Attachment
// 0x00000034
struct FAttachment
{
//	 vPoperty_Size=5
	class UActorComponent*                             Component;                                        		// 0x0000 (0x0008) [0x0000000004080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_EditInline )
	struct FName                                       BoneName;                                         		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     RelativeLocation;                                 		// 0x0010 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FRotator                                    RelativeRotation;                                 		// 0x001C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     RelativeScale;                                    		// 0x0028 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SkeletalMeshComponent.ActiveMorph
// 0x0000000C
struct FActiveMorph
{
//	 vPoperty_Size=2
	class UMorphTarget*                                Target;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              Weight;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.HUD.ConsoleMessage
// 0x00000020
struct FConsoleMessage
{
//	 vPoperty_Size=4
	struct FString                                     Text;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FColor                                      TextColor;                                        		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              MessageLife;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
	class APlayerReplicationInfo*                      PRI;                                              		// 0x0018 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.HUD.HudLocalizedMessage
// 0x00000050
struct FHudLocalizedMessage
{
//	 vPoperty_Size=e
	class UClass*                                      Message;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     StringMessage;                                    		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Switch;                                           		// 0x0018 (0x0004) [0x0000000000000000]              
	float                                              EndOfLife;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	float                                              Lifetime;                                         		// 0x0020 (0x0004) [0x0000000000000000]              
	float                                              PosY;                                             		// 0x0024 (0x0004) [0x0000000000000000]              
	struct FColor                                      DrawColor;                                        		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                FontSize;                                         		// 0x002C (0x0004) [0x0000000000000000]              
	class UFont*                                       StringFont;                                       		// 0x0030 (0x0008) [0x0000000000000000]              
	float                                              DX;                                               		// 0x0038 (0x0004) [0x0000000000000000]              
	float                                              DY;                                               		// 0x003C (0x0004) [0x0000000000000000]              
	unsigned long                                      Drawn : 1;                                        		// 0x0040 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                Count;                                            		// 0x0044 (0x0004) [0x0000000000000000]              
	class UObject*                                     OptionalObject;                                   		// 0x0048 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.HUD.KismetDrawTextInfo
// 0x00000040
struct FKismetDrawTextInfo
{
//	 vPoperty_Size=7
	struct FString                                     MessageText;                                      		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     AppendedText;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UFont*                                       MessageFont;                                      		// 0x0020 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   MessageFontScale;                                 		// 0x0028 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   MessageOffset;                                    		// 0x0030 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      MessageColor;                                     		// 0x0038 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MessageEndTime;                                   		// 0x003C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.PlayerReplicationInfo.AutomatedTestingDatum
// 0x00000008
struct FAutomatedTestingDatum
{
//	 vPoperty_Size=2
	int                                                NumberOfMatchesPlayed;                            		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                NumMapListCyclesDone;                             		// 0x0004 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.PlayerController.DebugTextInfo
// 0x00000054
struct FDebugTextInfo
{
//	 vPoperty_Size=b
	class AActor*                                      SrcActor;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FVector                                     SrcActorOffset;                                   		// 0x0008 (0x000C) [0x0000000000000000]              
	struct FVector                                     SrcActorDesiredOffset;                            		// 0x0014 (0x000C) [0x0000000000000000]              
	struct FString                                     DebugText;                                        		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              TimeRemaining;                                    		// 0x0030 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	float                                              Duration;                                         		// 0x0034 (0x0004) [0x0000000000000000]              
	struct FColor                                      TextColor;                                        		// 0x0038 (0x0004) [0x0000000000000000]              
	unsigned long                                      bAbsoluteLocation : 1;                            		// 0x003C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bKeepAttachedToActor : 1;                         		// 0x003C (0x0004) [0x0000000000000000] [0x00000002] 
	struct FVector                                     OrigActorLocation;                                		// 0x0040 (0x000C) [0x0000000000000000]              
	class UFont*                                       Font;                                             		// 0x004C (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.PlayerController.ConnectedPeerInfo
// 0x00000010
struct FConnectedPeerInfo
{
//	 vPoperty_Size=3
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      NatType;                                          		// 0x0008 (0x0001) [0x0000000000000000]              
	unsigned long                                      bLostConnectionToHost : 1;                        		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.PlayerController.ClientAdjustment
// 0x00000035
struct FClientAdjustment
{
//	 vPoperty_Size=7
	float                                              TimeStamp;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      newPhysics;                                       		// 0x0004 (0x0001) [0x0000000000000000]              
	struct FVector                                     NewLoc;                                           		// 0x0008 (0x000C) [0x0000000000000000]              
	struct FVector                                     NewVel;                                           		// 0x0014 (0x000C) [0x0000000000000000]              
	class AActor*                                      NewBase;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	struct FVector                                     NewFloor;                                         		// 0x0028 (0x000C) [0x0000000000000000]              
	unsigned char                                      bAckGoodMove;                                     		// 0x0034 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.PlayerController.InputEntry
// 0x0000000D
struct FInputEntry
{
//	 vPoperty_Size=4
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000000]              
	float                                              Value;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              TimeDelta;                                        		// 0x0008 (0x0004) [0x0000000000000000]              
	unsigned char                                      Action;                                           		// 0x000C (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.PlayerController.InputMatchRequest
// 0x00000048
struct FInputMatchRequest
{
//	 vPoperty_Size=8
	TArray< struct FInputEntry >                       Inputs;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class AActor*                                      MatchActor;                                       		// 0x0010 (0x0008) [0x0000000000000000]              
	struct FName                                       MatchFuncName;                                    		// 0x0018 (0x0008) [0x0000000000000000]              
	struct FScriptDelegate                             MatchDelegate;                                    		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0024 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FName                                       FailedFuncName;                                   		// 0x0030 (0x0008) [0x0000000000000000]              
	struct FName                                       RequestName;                                      		// 0x0038 (0x0008) [0x0000000000000000]              
	int                                                MatchIdx;                                         		// 0x0040 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	float                                              LastMatchTime;                                    		// 0x0044 (0x0004) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.NavigationPoint.NavigationOctreeObject
// 0x00000039
struct FNavigationOctreeObject
{
//	 vPoperty_Size=5
	struct FBox                                        BoundingBox;                                      		// 0x0000 (0x001C) [0x0000000000000000]              
	struct FVector                                     BoxCenter;                                        		// 0x001C (0x000C) [0x0000000000000000]              
	struct FPointer                                    OctreeNode;                                       		// 0x0028 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	class UObject*                                     Owner;                                            		// 0x0030 (0x0008) [0x0000000000800002]              ( CPF_Const | CPF_NoExport )
	unsigned char                                      OwnerType;                                        		// 0x0038 (0x0001) [0x0000000000800002]              ( CPF_Const | CPF_NoExport )
};

// ScriptStruct Engine.NavigationPoint.DebugNavCost
// 0x00000014
struct FDebugNavCost
{
//	 vPoperty_Size=2
	struct FString                                     Desc;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Cost;                                             		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.NavigationPoint.CheckpointRecord
// 0x00000004
struct ANavigationPoint_FCheckpointRecord
{
//	 vPoperty_Size=2
	unsigned long                                      bDisabled : 1;                                    		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bBlocked : 1;                                     		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct Engine.KMeshProps.KSphereElem
// 0x00000048
struct FKSphereElem
{
//	 vPoperty_Size=4
	struct FMatrix                                     TM;                                               		// 0x0000 (0x0040) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	float                                              Radius;                                           		// 0x0040 (0x0004) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bNoRBCollision : 1;                               		// 0x0044 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bPerPolyShape : 1;                                		// 0x0044 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct Engine.KMeshProps.KBoxElem
// 0x00000050
struct FKBoxElem
{
//	 vPoperty_Size=6
	struct FMatrix                                     TM;                                               		// 0x0000 (0x0040) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	float                                              X;                                                		// 0x0040 (0x0004) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	float                                              Y;                                                		// 0x0044 (0x0004) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	float                                              Z;                                                		// 0x0048 (0x0004) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bNoRBCollision : 1;                               		// 0x004C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bPerPolyShape : 1;                                		// 0x004C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct Engine.KMeshProps.KSphylElem
// 0x0000004C
struct FKSphylElem
{
//	 vPoperty_Size=5
	struct FMatrix                                     TM;                                               		// 0x0000 (0x0040) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	float                                              Radius;                                           		// 0x0040 (0x0004) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	float                                              Length;                                           		// 0x0044 (0x0004) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bNoRBCollision : 1;                               		// 0x0048 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bPerPolyShape : 1;                                		// 0x0048 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct Engine.KMeshProps.KConvexElem
// 0x0000007C
struct FKConvexElem
{
//	 vPoperty_Size=7
	TArray< struct FVector >                           VertexData;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FPlane >                            PermutedVertexData;                               		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< int >                                      FaceTriData;                                      		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FVector >                           EdgeDirections;                                   		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FVector >                           FaceNormalDirections;                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FPlane >                            FacePlaneData;                                    		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FBox                                        ElemBox;                                          		// 0x0060 (0x001C) [0x0000000000000000]              
};

// ScriptStruct Engine.KMeshProps.KAggregateGeom
// 0x0000004C
struct FKAggregateGeom
{
//	 vPoperty_Size=6
	TArray< struct FKSphereElem >                      SphereElems;                                      		// 0x0000 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	TArray< struct FKBoxElem >                         BoxElems;                                         		// 0x0010 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	TArray< struct FKSphylElem >                       SphylElems;                                       		// 0x0020 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	TArray< struct FKConvexElem >                      ConvexElems;                                      		// 0x0030 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	struct FPointer                                    RenderInfo;                                       		// 0x0040 (0x0008) [0x0000000001001000]              ( CPF_Native )
	unsigned long                                      bSkipCloseAndParallelChecks : 1;                  		// 0x0048 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.Pylon.PolyReference
// 0x00000024
struct FPolyReference
{
//	 vPoperty_Size=3
	struct FActorReference                             OwningPylon;                                      		// 0x0000 (0x0018) [0x0000000000000000]              
	int                                                PolyId;                                           		// 0x0018 (0x0004) [0x0000000000000000]              
	struct FPointer                                    CachedPoly;                                       		// 0x001C (0x0008) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct Engine.Scout.PathSizeInfo
// 0x00000015
struct FPathSizeInfo
{
//	 vPoperty_Size=5
	struct FName                                       Desc;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              Radius;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              Height;                                           		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              CrouchHeight;                                     		// 0x0010 (0x0004) [0x0000000000000000]              
	unsigned char                                      PathColor;                                        		// 0x0014 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.BrushComponent.KCachedConvexData_Mirror
// 0x00000010
struct FKCachedConvexData_Mirror
{
//	 vPoperty_Size=1
	TArray< int >                                      CachedConvexElements;                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.Brush.GeomSelection
// 0x0000000C
struct FGeomSelection
{
//	 vPoperty_Size=3
	int                                                Type;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Index;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                SelectionIndex;                                   		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.ReverbVolume.ReverbSettings
// 0x00000010
struct FReverbSettings
{
//	 vPoperty_Size=4
	unsigned long                                      bApplyReverb : 1;                                 		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      ReverbType;                                       		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              Volume;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeTime;                                         		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ReverbVolume.InteriorSettings
// 0x00000024
struct FInteriorSettings
{
//	 vPoperty_Size=9
	unsigned long                                      bIsWorldInfo : 1;                                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              ExteriorVolume;                                   		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ExteriorTime;                                     		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ExteriorLPF;                                      		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ExteriorLPFTime;                                  		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              InteriorVolume;                                   		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              InteriorTime;                                     		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              InteriorLPF;                                      		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              InteriorLPFTime;                                  		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AudioComponent.AudioComponentParam
// 0x00000014
struct FAudioComponentParam
{
//	 vPoperty_Size=3
	struct FName                                       ParamName;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              FloatParam;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class USoundNodeWave*                              WaveParam;                                        		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.EngineTypes.SubtitleCue
// 0x00000014
struct FSubtitleCue
{
//	 vPoperty_Size=2
	struct FString                                     Text;                                             		// 0x0000 (0x0010) [0x0000000000408003]              ( CPF_Edit | CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	float                                              Time;                                             		// 0x0010 (0x0004) [0x0000000000008003]              ( CPF_Edit | CPF_Const | CPF_Localized )
};

// ScriptStruct Engine.AudioDevice.Listener
// 0x00000044
struct FListener
{
//	 vPoperty_Size=6
	class APortalVolume*                               PortalVolume;                                     		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FVector                                     Location;                                         		// 0x0008 (0x000C) [0x0000000000000000]              
	struct FVector                                     Up;                                               		// 0x0014 (0x000C) [0x0000000000000000]              
	struct FVector                                     Right;                                            		// 0x0020 (0x000C) [0x0000000000000000]              
	struct FVector                                     Front;                                            		// 0x002C (0x000C) [0x0000000000000000]              
	struct FVector                                     Velocity;                                         		// 0x0038 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.AudioDevice.AudioClassInfo
// 0x00000010
struct FAudioClassInfo
{
//	 vPoperty_Size=4
	int                                                NumResident;                                      		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                SizeResident;                                     		// 0x0004 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                NumRealTime;                                      		// 0x0008 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                SizeRealTime;                                     		// 0x000C (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.SoundCue.SoundNodeEditorData
// 0x00000008
struct FSoundNodeEditorData
{
//	 vPoperty_Size=2
	int                                                NodePosX;                                         		// 0x0000 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                NodePosY;                                         		// 0x0004 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.SoundNodeAmbient.AmbientSoundSlot
// 0x00000014
struct FAmbientSoundSlot
{
//	 vPoperty_Size=4
	class USoundNodeWave*                              Wave;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              PitchScale;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              VolumeScale;                                      		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Weight;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AmbientSoundSimpleToggleable.CheckpointRecord
// 0x00000004
struct AAmbientSoundSimpleToggleable_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bCurrentlyPlaying : 1;                            		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.SplineAudioComponent.InterpPointOnSpline
// 0x00000014
struct FInterpPointOnSpline
{
//	 vPoperty_Size=3
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	float                                              InVal;                                            		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Length;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SimpleSplineAudioComponent.SplineSoundSlot
// 0x00000034
struct FSplineSoundSlot
{
//	 vPoperty_Size=b
	class USoundNodeWave*                              Wave;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              PitchScale;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              VolumeScale;                                      		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                StartPoint;                                       		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                EndPoint;                                         		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Weight;                                           		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FDouble                                     LastUpdateTime;                                   		// 0x001C (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              SourceInteriorVolume;                             		// 0x0024 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              SourceInteriorLPF;                                		// 0x0028 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              CurrentInteriorVolume;                            		// 0x002C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              CurrentInteriorLPF;                               		// 0x0030 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.MultiCueSplineAudioComponent.MultiCueSplineSoundSlot
// 0x00000034
struct FMultiCueSplineSoundSlot
{
//	 vPoperty_Size=b
	class USoundCue*                                   SoundCue;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              PitchScale;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              VolumeScale;                                      		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                StartPoint;                                       		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                EndPoint;                                         		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FDouble                                     LastUpdateTime;                                   		// 0x0018 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              SourceInteriorVolume;                             		// 0x0020 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              SourceInteriorLPF;                                		// 0x0024 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              CurrentInteriorVolume;                            		// 0x0028 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	float                                              CurrentInteriorLPF;                               		// 0x002C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	unsigned long                                      bPlaying : 1;                                     		// 0x0030 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.PlatformInterfaceBase.PlatformInterfaceData
// 0x0000003C
struct FPlatformInterfaceData
{
//	 vPoperty_Size=7
	struct FName                                       DataName;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      Type;                                             		// 0x0008 (0x0001) [0x0000000000000000]              
	int                                                IntValue;                                         		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              FloatValue;                                       		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FString                                     StringValue;                                      		// 0x0014 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     StringValue2;                                     		// 0x0024 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	class UObject*                                     ObjectValue;                                      		// 0x0034 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.PlatformInterfaceBase.PlatformInterfaceDelegateResult
// 0x00000040
struct FPlatformInterfaceDelegateResult
{
//	 vPoperty_Size=2
	unsigned long                                      bSuccessful : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FPlatformInterfaceData                      Data;                                             		// 0x0004 (0x003C) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.PlatformInterfaceBase.DelegateArray
// 0x00000010
struct FDelegateArray
{
//	 vPoperty_Size=1
	TArray< struct FScriptDelegate >                   Delegates;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnalyticEventsBase.EventStringParam
// 0x00000020
struct FEventStringParam
{
//	 vPoperty_Size=2
	struct FString                                     ParamName;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ParamValue;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimSequence.CompressedTrack
// 0x00000038
struct FCompressedTrack
{
//	 vPoperty_Size=4
	TArray< unsigned char >                            ByteStream;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< float >                                    Times;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              Mins[ 0x3 ];                                      		// 0x0020 (0x000C) [0x0000000000000000]              
	float                                              Ranges[ 0x3 ];                                    		// 0x002C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.AnimSequence.CurveTrack
// 0x00000018
struct FCurveTrack
{
//	 vPoperty_Size=2
	struct FName                                       CurveName;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	TArray< float >                                    CurveWeights;                                     		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimSequence.RotationTrack
// 0x00000020
struct FRotationTrack
{
//	 vPoperty_Size=2
	TArray< struct FQuat >                             RotKeys;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< float >                                    Times;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimSequence.TranslationTrack
// 0x00000020
struct FTranslationTrack
{
//	 vPoperty_Size=2
	TArray< struct FVector >                           PosKeys;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< float >                                    Times;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimSequence.TimeModifier
// 0x00000008
struct FTimeModifier
{
//	 vPoperty_Size=2
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              TargetStrength;                                   		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimSequence.SkelControlModifier
// 0x00000018
struct FSkelControlModifier
{
//	 vPoperty_Size=2
	struct FName                                       SkelControlName;                                  		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FTimeModifier >                     Modifiers;                                        		// 0x0008 (0x0010) [0x0000000004400001]              ( CPF_Edit | CPF_NeedCtorLink | CPF_EditInline )
};

// ScriptStruct Engine.AnimSequence.AnimNotifyEvent
// 0x00000018
struct FAnimNotifyEvent
{
//	 vPoperty_Size=4
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UAnimNotify*                                 Notify;                                           		// 0x0004 (0x0008) [0x0000000004400009]              ( CPF_Edit | CPF_ExportObject | CPF_NeedCtorLink | CPF_EditInline )
	struct FName                                       Comment;                                          		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              Duration;                                         		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimSequence.RawAnimSequenceTrack
// 0x00000020
struct FRawAnimSequenceTrack
{
//	 vPoperty_Size=2
	TArray< struct FVector >                           PosKeys;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FQuat >                             RotKeys;                                          		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimNode.CurveKey
// 0x0000000C
struct FCurveKey
{
//	 vPoperty_Size=2
	struct FName                                       CurveName;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              Weight;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.AnimNode_MultiBlendPerBone.WeightNodeRule
// 0x00000020
struct FWeightNodeRule
{
//	 vPoperty_Size=5
	struct FName                                       NodeName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UAnimNodeBlendBase*                          CachedNode;                                       		// 0x0008 (0x0008) [0x0000000000000000]              
	class UAnimNodeSlot*                               CachedSlotNode;                                   		// 0x0010 (0x0008) [0x0000000000000000]              
	unsigned char                                      WeightCheck;                                      		// 0x0018 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                ChildIndex;                                       		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimNode_MultiBlendPerBone.WeightRule
// 0x00000040
struct FWeightRule
{
//	 vPoperty_Size=2
	struct FWeightNodeRule                             FirstNode;                                        		// 0x0000 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FWeightNodeRule                             SecondNode;                                       		// 0x0020 (0x0020) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimNode_MultiBlendPerBone.BranchInfo
// 0x0000000C
struct FBranchInfo
{
//	 vPoperty_Size=2
	struct FName                                       BoneName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              PerBoneWeightIncrease;                            		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimNode_MultiBlendPerBone.PerBoneMaskInfo
// 0x00000050
struct FPerBoneMaskInfo
{
//	 vPoperty_Size=a
	TArray< struct FBranchInfo >                       BranchList;                                       		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	float                                              DesiredWeight;                                    		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              BlendTimeToGo;                                    		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FWeightRule >                       WeightRuleList;                                   		// 0x0018 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      bWeightBasedOnNodeRules : 1;                      		// 0x0028 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bDisableForNonLocalHumanPlayers : 1;              		// 0x0028 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bPendingBlend : 1;                                		// 0x0028 (0x0004) [0x0000000000002000] [0x00000004] ( CPF_Transient )
	TArray< float >                                    PerBoneWeights;                                   		// 0x002C (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
	TArray< unsigned char >                            TransformReqBone;                                 		// 0x003C (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
	int                                                TransformReqBoneIndex;                            		// 0x004C (0x0004) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.AnimNodeAimOffset.AimTransform
// 0x0000001C
struct FAimTransform
{
//	 vPoperty_Size=2
	struct FQuat                                       Quaternion;                                       		// 0x0000 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Translation;                                      		// 0x0010 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimNodeAimOffset.AimComponent
// 0x00000130
struct FAimComponent
{
//	 vPoperty_Size=a
	struct FName                                       BoneName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0008 (0x0008) MISSED OFFSET
	struct FAimTransform                               LU;                                               		// 0x0010 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               LC;                                               		// 0x0030 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               LD;                                               		// 0x0050 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               CU;                                               		// 0x0070 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               CC;                                               		// 0x0090 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               CD;                                               		// 0x00B0 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               RU;                                               		// 0x00D0 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               RC;                                               		// 0x00F0 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAimTransform                               RD;                                               		// 0x0110 (0x0020) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimNodeAimOffset.AimOffsetProfile
// 0x00000070
struct FAimOffsetProfile
{
//	 vPoperty_Size=d
	struct FName                                       ProfileName;                                      		// 0x0000 (0x0008) [0x0000000000020003]              ( CPF_Edit | CPF_Const | CPF_EditConst )
	struct FVector2D                                   HorizontalRange;                                  		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   VerticalRange;                                    		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FAimComponent >                     AimComponents;                                    		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FName                                       AnimName_LU;                                      		// 0x0028 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_LC;                                      		// 0x0030 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_LD;                                      		// 0x0038 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_CU;                                      		// 0x0040 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_CC;                                      		// 0x0048 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_CD;                                      		// 0x0050 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_RU;                                      		// 0x0058 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_RC;                                      		// 0x0060 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       AnimName_RD;                                      		// 0x0068 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimNodeBlendMultiBone.ChildBoneBlendInfo
// 0x00000038
struct FChildBoneBlendInfo
{
//	 vPoperty_Size=6
	TArray< float >                                    TargetPerBoneWeight;                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FName                                       InitTargetStartBone;                              		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              InitPerBoneIncrease;                              		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       OldStartBone;                                     		// 0x001C (0x0008) [0x0000000000000002]              ( CPF_Const )
	float                                              OldBoneIncrease;                                  		// 0x0024 (0x0004) [0x0000000000000002]              ( CPF_Const )
	TArray< unsigned char >                            TargetRequiredBones;                              		// 0x0028 (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimNodeRandom.RandomAnimInfo
// 0x00000020
struct FRandomAnimInfo
{
//	 vPoperty_Size=8
	float                                              Chance;                                           		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      LoopCountMin;                                     		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      LoopCountMax;                                     		// 0x0005 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              BlendInTime;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   PlayRateRange;                                    		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bStillFrame : 1;                                  		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      LoopCount;                                        		// 0x0018 (0x0001) [0x0000000000002000]              ( CPF_Transient )
	float                                              LastPosition;                                     		// 0x001C (0x0004) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.AnimNodeSequenceBlendBase.AnimInfo
// 0x00000014
struct FAnimInfo
{
//	 vPoperty_Size=3
	struct FName                                       AnimSeqName;                                      		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	class UAnimSequence*                               AnimSeq;                                          		// 0x0008 (0x0008) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
	int                                                AnimLinkupIndex;                                  		// 0x0010 (0x0004) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
};

// ScriptStruct Engine.AnimNodeSequenceBlendBase.AnimBlendInfo
// 0x00000020
struct FAnimBlendInfo
{
//	 vPoperty_Size=3
	struct FName                                       AnimName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FAnimInfo                                   AnimInfo;                                         		// 0x0008 (0x0014) [0x0000000000000000]              
	float                                              Weight;                                           		// 0x001C (0x0004) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.AnimNodeSynch.SynchGroup
// 0x00000028
struct FSynchGroup
{
//	 vPoperty_Size=5
	TArray< class UAnimNodeSequence* >                 SeqNodes;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UAnimNodeSequence*                           MasterNode;                                       		// 0x0010 (0x0008) [0x0000000000002000]              ( CPF_Transient )
	struct FName                                       GroupName;                                        		// 0x0018 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bFireSlaveNotifies : 1;                           		// 0x0020 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              RateScale;                                        		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.EngineTypes.LocalizedSubtitle
// 0x00000024
struct FLocalizedSubtitle
{
//	 vPoperty_Size=5
	struct FString                                     LanguageExt;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FSubtitleCue >                      Subtitles;                                        		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bMature : 1;                                      		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bManualWordWrap : 1;                              		// 0x0020 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bSingleLine : 1;                                  		// 0x0020 (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct Engine.EngineTypes.LightMapRef
// 0x00000008
struct FLightMapRef
{
//	 vPoperty_Size=1
	struct FPointer                                    Reference;                                        		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.EngineTypes.DominantShadowInfo
// 0x000000A4
struct FDominantShadowInfo
{
//	 vPoperty_Size=5
	struct FMatrix                                     WorldToLight;                                     		// 0x0000 (0x0040) [0x0000000000000000]              
	struct FMatrix                                     LightToWorld;                                     		// 0x0040 (0x0040) [0x0000000000000000]              
	struct FBox                                        LightSpaceImportanceBounds;                       		// 0x0080 (0x001C) [0x0000000000000000]              
	int                                                ShadowMapSizeX;                                   		// 0x009C (0x0004) [0x0000000000000000]              
	int                                                ShadowMapSizeY;                                   		// 0x00A0 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.EngineTypes.LightmassLightSettings
// 0x0000000C
struct FLightmassLightSettings
{
//	 vPoperty_Size=3
	float                                              IndirectLightingScale;                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              IndirectLightingSaturation;                       		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ShadowExponent;                                   		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.EngineTypes.LightmassPointLightSettings
// 0x0004(0x0010 - 0x000C)
struct FLightmassPointLightSettings : FLightmassLightSettings
{
//	 vPoperty_Size=1
	float                                              LightSourceRadius;                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.EngineTypes.LightmassDirectionalLightSettings
// 0x0004(0x0010 - 0x000C)
struct FLightmassDirectionalLightSettings : FLightmassLightSettings
{
//	 vPoperty_Size=1
	float                                              LightSourceAngle;                                 		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.EngineTypes.LightmassPrimitiveSettings
// 0x0000001C
struct FLightmassPrimitiveSettings
{
//	 vPoperty_Size=9
	unsigned long                                      bUseTwoSidedLighting : 1;                         		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bShadowIndirectOnly : 1;                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bUseEmissiveForStaticLighting : 1;                		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	float                                              EmissiveLightFalloffExponent;                     		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EmissiveLightExplicitInfluenceRadius;             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EmissiveBoost;                                    		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DiffuseBoost;                                     		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              SpecularBoost;                                    		// 0x0014 (0x0004) [0x0000000000000000]              
	float                                              FullyOccludedSamplesFraction;                     		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.EngineTypes.LightmassDebugOptions
// 0x00000014
struct FLightmassDebugOptions
{
//	 vPoperty_Size=12
	unsigned long                                      bDebugMode : 1;                                   		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bStatsEnabled : 1;                                		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bGatherBSPSurfacesAcrossComponents : 1;           		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	float                                              CoplanarTolerance;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bUseDeterministicLighting : 1;                    		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bUseImmediateImport : 1;                          		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bImmediateProcessMappings : 1;                    		// 0x0008 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bSortMappings : 1;                                		// 0x0008 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      bDumpBinaryFiles : 1;                             		// 0x0008 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      bDebugMaterials : 1;                              		// 0x0008 (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      bPadMappings : 1;                                 		// 0x0008 (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned long                                      bDebugPaddings : 1;                               		// 0x0008 (0x0004) [0x0000000000000001] [0x00000080] ( CPF_Edit )
	unsigned long                                      bOnlyCalcDebugTexelMappings : 1;                  		// 0x0008 (0x0004) [0x0000000000000001] [0x00000100] ( CPF_Edit )
	unsigned long                                      bUseRandomColors : 1;                             		// 0x0008 (0x0004) [0x0000000000000001] [0x00000200] ( CPF_Edit )
	unsigned long                                      bColorBordersGreen : 1;                           		// 0x0008 (0x0004) [0x0000000000000001] [0x00000400] ( CPF_Edit )
	unsigned long                                      bColorByExecutionTime : 1;                        		// 0x0008 (0x0004) [0x0000000000000001] [0x00000800] ( CPF_Edit )
	float                                              ExecutionTimeDivisor;                             		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bInitialized : 1;                                 		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.EngineTypes.SwarmDebugOptions
// 0x00000004
struct FSwarmDebugOptions
{
//	 vPoperty_Size=3
	unsigned long                                      bDistributionEnabled : 1;                         		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bForceContentExport : 1;                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bInitialized : 1;                                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct Engine.EngineTypes.RootMotionCurve
// 0x00000020
struct FRootMotionCurve
{
//	 vPoperty_Size=3
	struct FName                                       AnimName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FInterpCurveVector                          Curve;                                            		// 0x0008 (0x0014) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	float                                              MaxCurveTime;                                     		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.Pawn.ScalarParameterInterpStruct
// 0x00000014
struct FScalarParameterInterpStruct
{
//	 vPoperty_Size=4
	struct FName                                       ParameterName;                                    		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              ParameterValue;                                   		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              InterpTime;                                       		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              WarmupTime;                                       		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimNotify_Trails.TrailSocketSamplePoint
// 0x00000018
struct FTrailSocketSamplePoint
{
//	 vPoperty_Size=2
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector                                     Velocity;                                         		// 0x000C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.AnimNotify_Trails.TrailSamplePoint
// 0x0000004C
struct FTrailSamplePoint
{
//	 vPoperty_Size=4
	float                                              RelativeTime;                                     		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FTrailSocketSamplePoint                     FirstEdgeSample;                                  		// 0x0004 (0x0018) [0x0000000000000000]              
	struct FTrailSocketSamplePoint                     ControlPointSample;                               		// 0x001C (0x0018) [0x0000000000000000]              
	struct FTrailSocketSamplePoint                     SecondEdgeSample;                                 		// 0x0034 (0x0018) [0x0000000000000000]              
};

// ScriptStruct Engine.AnimNotify_Trails.TrailSample
// 0x00000028
struct FTrailSample
{
//	 vPoperty_Size=4
	float                                              RelativeTime;                                     		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FVector                                     FirstEdgeSample;                                  		// 0x0004 (0x000C) [0x0000000000000000]              
	struct FVector                                     ControlPointSample;                               		// 0x0010 (0x000C) [0x0000000000000000]              
	struct FVector                                     SecondEdgeSample;                                 		// 0x001C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.AnimSet.AnimSetMeshLinkup
// 0x00000010
struct FAnimSetMeshLinkup
{
//	 vPoperty_Size=1
	TArray< int >                                      BoneToTrackTable;                                 		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimTree.AnimGroup
// 0x00000030
struct FAnimGroup
{
//	 vPoperty_Size=6
	TArray< class UAnimNodeSequence* >                 SeqNodes;                                         		// 0x0000 (0x0010) [0x0000000000402002]              ( CPF_Const | CPF_Transient | CPF_NeedCtorLink )
	class UAnimNodeSequence*                           SynchMaster;                                      		// 0x0010 (0x0008) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
	class UAnimNodeSequence*                           NotifyMaster;                                     		// 0x0018 (0x0008) [0x0000000000002002]              ( CPF_Const | CPF_Transient )
	struct FName                                       GroupName;                                        		// 0x0020 (0x0008) [0x0000000000000003]              ( CPF_Edit | CPF_Const )
	float                                              RateScale;                                        		// 0x0028 (0x0004) [0x0000000000000003]              ( CPF_Edit | CPF_Const )
	float                                              SynchPctPosition;                                 		// 0x002C (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.AnimTree.SkelControlListHead
// 0x00000014
struct FSkelControlListHead
{
//	 vPoperty_Size=3
	struct FName                                       BoneName;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	class USkelControlBase*                            ControlHead;                                      		// 0x0008 (0x0008) [0x0000000004400008]              ( CPF_ExportObject | CPF_NeedCtorLink | CPF_EditInline )
	int                                                DrawY;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.AnimTree.PreviewSkelMeshStruct
// 0x00000020
struct FPreviewSkelMeshStruct
{
//	 vPoperty_Size=3
	struct FName                                       DisplayName;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class USkeletalMesh*                               PreviewSkelMesh;                                  		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UMorphTargetSet* >                   PreviewMorphSets;                                 		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.AnimTree.PreviewSocketStruct
// 0x00000020
struct FPreviewSocketStruct
{
//	 vPoperty_Size=4
	struct FName                                       DisplayName;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       SocketName;                                       		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class USkeletalMesh*                               PreviewSkelMesh;                                  		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UStaticMesh*                                 PreviewStaticMesh;                                		// 0x0018 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AnimTree.PreviewAnimSetsStruct
// 0x00000018
struct FPreviewAnimSetsStruct
{
//	 vPoperty_Size=2
	struct FName                                       DisplayName;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UAnimSet* >                          PreviewAnimSets;                                  		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ApexClothingAsset.ClothingLodInfo
// 0x00000010
struct FClothingLodInfo
{
//	 vPoperty_Size=1
	TArray< int >                                      LODMaterialMap;                                   		// 0x0000 (0x0010) [0x0000000000500043]              ( CPF_Edit | CPF_Const | CPF_EditConstArray | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ApexDestructibleAsset.NxDestructibleDepthParameters
// 0x00000005
struct FNxDestructibleDepthParameters
{
//	 vPoperty_Size=9
	unsigned long                                      TAKE_IMPACT_DAMAGE : 1;                           		// 0x0000 (0x0004) [0x0000000020000000] [0x00000001] ( CPF_Deprecated )
	unsigned long                                      IGNORE_POSE_UPDATES : 1;                          		// 0x0000 (0x0004) [0x0000000020000000] [0x00000002] ( CPF_Deprecated )
	unsigned long                                      IGNORE_RAYCAST_CALLBACKS : 1;                     		// 0x0000 (0x0004) [0x0000000020000000] [0x00000004] ( CPF_Deprecated )
	unsigned long                                      IGNORE_CONTACT_CALLBACKS : 1;                     		// 0x0000 (0x0004) [0x0000000020000000] [0x00000008] ( CPF_Deprecated )
	unsigned long                                      USER_FLAG : 1;                                    		// 0x0000 (0x0004) [0x0000000020000000] [0x00000010] ( CPF_Deprecated )
	unsigned long                                      USER_FLAG01 : 1;                                  		// 0x0000 (0x0004) [0x0000000020000000] [0x00000020] ( CPF_Deprecated )
	unsigned long                                      USER_FLAG02 : 1;                                  		// 0x0000 (0x0004) [0x0000000020000000] [0x00000040] ( CPF_Deprecated )
	unsigned long                                      USER_FLAG03 : 1;                                  		// 0x0000 (0x0004) [0x0000000020000000] [0x00000080] ( CPF_Deprecated )
	unsigned char                                      ImpactDamageOverride;                             		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ApexDestructibleAsset.NxDestructibleParametersFlag
// 0x00000004
struct FNxDestructibleParametersFlag
{
//	 vPoperty_Size=9
	unsigned long                                      ACCUMULATE_DAMAGE : 1;                            		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      ASSET_DEFINED_SUPPORT : 1;                        		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      WORLD_SUPPORT : 1;                                		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      DEBRIS_TIMEOUT : 1;                               		// 0x0000 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      DEBRIS_MAX_SEPARATION : 1;                        		// 0x0000 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      CRUMBLE_SMALLEST_CHUNKS : 1;                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      ACCURATE_RAYCASTS : 1;                            		// 0x0000 (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned long                                      USE_VALID_BOUNDS : 1;                             		// 0x0000 (0x0004) [0x0000000000000001] [0x00000080] ( CPF_Edit )
	unsigned long                                      FORM_EXTENDED_STRUCTURES : 1;                     		// 0x0000 (0x0004) [0x0000000000000001] [0x00000100] ( CPF_Edit )
};

// ScriptStruct Engine.ApexDestructibleAsset.NxDestructibleDamageParameters
// 0x00000014
struct FNxDestructibleDamageParameters
{
//	 vPoperty_Size=5
	float                                              DamageThreshold;                                  		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DamageSpread;                                     		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ImpactDamage;                                     		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ImpactResistance;                                 		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                DefaultImpactDamageDepth;                         		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ApexDestructibleAsset.NxDestructibleDebrisParameters
// 0x0000002C
struct FNxDestructibleDebrisParameters
{
//	 vPoperty_Size=5
	float                                              DebrisLifetimeMin;                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DebrisLifetimeMax;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DebrisMaxSeparationMin;                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DebrisMaxSeparationMax;                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FBox                                        ValidBounds;                                      		// 0x0010 (0x001C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ApexDestructibleAsset.NxDestructibleAdvancedParameters
// 0x00000018
struct FNxDestructibleAdvancedParameters
{
//	 vPoperty_Size=6
	float                                              DamageCap;                                        		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ImpactVelocityThreshold;                          		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MaxChunkSpeed;                                    		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MassScaleExponent;                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MassScale;                                        		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FractureImpulseScale;                             		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ApexDestructibleAsset.NxDestructibleParameters
// 0x000000F0
struct FNxDestructibleParameters
{
//	 vPoperty_Size=20
	struct FNxDestructibleDamageParameters             DamageParameters;                                 		// 0x0000 (0x0014) [0x0000000000000001]              ( CPF_Edit )
	struct FNxDestructibleDebrisParameters             DebrisParameters;                                 		// 0x0014 (0x002C) [0x0000000000000001]              ( CPF_Edit )
	struct FNxDestructibleAdvancedParameters           AdvancedParameters;                               		// 0x0040 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	float                                              DamageThreshold;                                  		// 0x0058 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              DamageToRadius;                                   		// 0x005C (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              DamageCap;                                        		// 0x0060 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              ForceToDamage;                                    		// 0x0064 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              ImpactVelocityThreshold;                          		// 0x0068 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              MaterialStrength;                                 		// 0x006C (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              DamageToPercentDeformation;                       		// 0x0070 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              DeformationPercentLimit;                          		// 0x0074 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	unsigned long                                      bFormExtendedStructures : 1;                      		// 0x0078 (0x0004) [0x0000000020000000] [0x00000001] ( CPF_Deprecated )
	int                                                SupportDepth;                                     		// 0x007C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                MinimumFractureDepth;                             		// 0x0080 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                DebrisDepth;                                      		// 0x0084 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                EssentialDepth;                                   		// 0x0088 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DebrisLifetimeMin;                                		// 0x008C (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              DebrisLifetimeMax;                                		// 0x0090 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              DebrisMaxSeparationMin;                           		// 0x0094 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              DebrisMaxSeparationMax;                           		// 0x0098 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	struct FBox                                        ValidBounds;                                      		// 0x009C (0x001C) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              MaxChunkSpeed;                                    		// 0x00B8 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              MassScaleExponent;                                		// 0x00BC (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	struct FNxDestructibleParametersFlag               Flags;                                            		// 0x00C0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              GrbVolumeLimit;                                   		// 0x00C4 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              GrbParticleSpacing;                               		// 0x00C8 (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              FractureImpulseScale;                             		// 0x00CC (0x0004) [0x0000000020000000]              ( CPF_Deprecated )
	TArray< struct FNxDestructibleDepthParameters >    DepthParameters;                                  		// 0x00D0 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	int                                                DynamicChunksDominanceGroup;                      		// 0x00E0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseDynamicChunksGroupsMask : 1;                   		// 0x00E4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      DynamicChunksChannel;                             		// 0x00E8 (0x0001) [0x0000000000000003]              ( CPF_Edit | CPF_Const )
	struct FRBCollisionChannelContainer                DynamicChunksCollideWithChannels;                 		// 0x00EC (0x0004) [0x0000000000000003]              ( CPF_Edit | CPF_Const )
};

// ScriptStruct Engine.ApexDestructibleDamageParameters.DamageParameters
// 0x00000010
struct FDamageParameters
{
//	 vPoperty_Size=4
	unsigned char                                      OverrideMode;                                     		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              BaseDamage;                                       		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Radius;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Momentum;                                         		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ApexDestructibleDamageParameters.DamagePair
// 0x00000018
struct FDamagePair
{
//	 vPoperty_Size=2
	struct FName                                       DamageCauserName;                                 		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FDamageParameters                           Params;                                           		// 0x0008 (0x0010) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.AppNotificationsBase.NotificationMessageInfo
// 0x00000020
struct FNotificationMessageInfo
{
//	 vPoperty_Size=2
	struct FString                                     Key;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Value;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AppNotificationsBase.NotificationInfo
// 0x00000028
struct FNotificationInfo
{
//	 vPoperty_Size=4
	unsigned long                                      bIsLocal : 1;                                     		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FString                                     MessageBody;                                      		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                BadgeNumber;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
	TArray< struct FNotificationMessageInfo >          MessageInfo;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.AppNotificationsBase.LaunchNotificationInfo
// 0x0000002C
struct FLaunchNotificationInfo
{
//	 vPoperty_Size=2
	unsigned long                                      bWasLaunchedViaNotification : 1;                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FNotificationInfo                           Notification;                                     		// 0x0004 (0x0028) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.StaticMeshComponent.PaintedVertex
// 0x00000014
struct FPaintedVertex
{
//	 vPoperty_Size=3
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FPackedNormal                               Normal;                                           		// 0x000C (0x0004) [0x0000000000000000]              
	struct FColor                                      Color;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.StaticMeshComponent.StaticMeshComponentLODInfo
// 0x00000040
struct FStaticMeshComponentLODInfo
{
//	 vPoperty_Size=5
	TArray< class UShadowMap2D* >                      ShadowMaps;                                       		// 0x0000 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< class UObject* >                           ShadowVertexBuffers;                              		// 0x0010 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FPointer                                    LightMap;                                         		// 0x0020 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    OverrideVertexColors;                             		// 0x0028 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< struct FPaintedVertex >                    PaintedVertices;                                  		// 0x0030 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
};

// ScriptStruct Engine.CameraShake.FOscillator
// 0x00000009
struct FFOscillator
{
//	 vPoperty_Size=3
	float                                              Amplitude;                                        		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Frequency;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InitialOffset;                                    		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CameraShake.VOscillator
// 0x00000024
struct FVOscillator
{
//	 vPoperty_Size=3
	struct FFOscillator                                X;                                                		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FFOscillator                                Y;                                                		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FFOscillator                                Z;                                                		// 0x0018 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CameraShake.ROscillator
// 0x00000024
struct FROscillator
{
//	 vPoperty_Size=3
	struct FFOscillator                                Pitch;                                            		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FFOscillator                                Yaw;                                              		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FFOscillator                                Roll;                                             		// 0x0018 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CameraModifier_CameraShake.CameraShakeInstance
// 0x00000090
struct FCameraShakeInstance
{
//	 vPoperty_Size=e
	class UCameraShake*                                SourceShake;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FName                                       SourceShakeName;                                  		// 0x0008 (0x0008) [0x0000000000000000]              
	float                                              OscillatorTimeRemaining;                          		// 0x0010 (0x0004) [0x0000000000000000]              
	unsigned long                                      bBlendingIn : 1;                                  		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              CurrentBlendInTime;                               		// 0x0018 (0x0004) [0x0000000000000000]              
	unsigned long                                      bBlendingOut : 1;                                 		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              CurrentBlendOutTime;                              		// 0x0020 (0x0004) [0x0000000000000000]              
	struct FVector                                     LocSinOffset;                                     		// 0x0024 (0x000C) [0x0000000000000000]              
	struct FVector                                     RotSinOffset;                                     		// 0x0030 (0x000C) [0x0000000000000000]              
	float                                              FOVSinOffset;                                     		// 0x003C (0x0004) [0x0000000000000000]              
	float                                              Scale;                                            		// 0x0040 (0x0004) [0x0000000000000000]              
	class UCameraAnimInst*                             AnimInst;                                         		// 0x0044 (0x0008) [0x0000000000000000]              
	unsigned char                                      PlaySpace;                                        		// 0x004C (0x0001) [0x0000000000000000]              
	struct FMatrix                                     UserPlaySpaceMatrix;                              		// 0x0050 (0x0040) [0x0000000000000000]              
};

// ScriptStruct Engine.Canvas.DepthFieldGlowInfo
// 0x00000024
struct FDepthFieldGlowInfo
{
//	 vPoperty_Size=4
	unsigned long                                      bEnableGlow : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FLinearColor                                GlowColor;                                        		// 0x0004 (0x0010) [0x0000000000000000]              
	struct FVector2D                                   GlowOuterRadius;                                  		// 0x0014 (0x0008) [0x0000000000000000]              
	struct FVector2D                                   GlowInnerRadius;                                  		// 0x001C (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.Canvas.MobileDistanceFieldParams
// 0x00000054
struct FMobileDistanceFieldParams
{
//	 vPoperty_Size=9
	float                                              Gamma;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              AlphaRefVal;                                      		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              SmoothWidth;                                      		// 0x0008 (0x0004) [0x0000000000000000]              
	unsigned long                                      EnableShadow : 1;                                 		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
	struct FVector2D                                   ShadowDirection;                                  		// 0x0010 (0x0008) [0x0000000000000000]              
	struct FLinearColor                                ShadowColor;                                      		// 0x0018 (0x0010) [0x0000000000000000]              
	float                                              ShadowSmoothWidth;                                		// 0x0028 (0x0004) [0x0000000000000000]              
	struct FDepthFieldGlowInfo                         GlowInfo;                                         		// 0x002C (0x0024) [0x0000000000001000]              ( CPF_Native )
	int                                                BlendMode;                                        		// 0x0050 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Canvas.FontRenderInfo
// 0x00000028
struct FFontRenderInfo
{
//	 vPoperty_Size=3
	unsigned long                                      bClipText : 1;                                    		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bEnableShadow : 1;                                		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	struct FDepthFieldGlowInfo                         GlowInfo;                                         		// 0x0004 (0x0024) [0x0000000000000000]              
};

// ScriptStruct Engine.Canvas.CanvasUVTri
// 0x00000030
struct FCanvasUVTri
{
//	 vPoperty_Size=6
	struct FVector2D                                   V0_Pos;                                           		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   V0_UV;                                            		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   V1_Pos;                                           		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   V1_UV;                                            		// 0x0018 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   V2_Pos;                                           		// 0x0020 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   V2_UV;                                            		// 0x0028 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.Canvas.TextSizingParameters
// 0x0000002C
struct FTextSizingParameters
{
//	 vPoperty_Size=8
	float                                              DrawX;                                            		// 0x0000 (0x0004) [0x0000000000100000]              
	float                                              DrawY;                                            		// 0x0004 (0x0004) [0x0000000000100000]              
	float                                              DrawXL;                                           		// 0x0008 (0x0004) [0x0000000000100000]              
	float                                              DrawYL;                                           		// 0x000C (0x0004) [0x0000000000100000]              
	struct FVector2D                                   Scaling;                                          		// 0x0010 (0x0008) [0x0000000000100000]              
	class UFont*                                       DrawFont;                                         		// 0x0018 (0x0008) [0x0000000000100000]              
	struct FVector2D                                   SpacingAdjust;                                    		// 0x0020 (0x0008) [0x0000000000100000]              
	float                                              ViewportHeight;                                   		// 0x0028 (0x0004) [0x0000000000100000]              
};

// ScriptStruct Engine.Canvas.WrappedStringElement
// 0x00000018
struct FWrappedStringElement
{
//	 vPoperty_Size=2
	struct FString                                     Value;                                            		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FVector2D                                   LineExtent;                                       		// 0x0010 (0x0008) [0x0000000000100000]              
};

// ScriptStruct Engine.Canvas.CanvasIcon
// 0x00000018
struct FCanvasIcon
{
//	 vPoperty_Size=5
	class UTexture*                                    Texture;                                          		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              U;                                                		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              V;                                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UL;                                               		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              VL;                                               		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CloudSaveSystem.SaveSlotOperation
// 0x00000005
struct FSaveSlotOperation
{
//	 vPoperty_Size=2
	int                                                SlotIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      SlotOperation;                                    		// 0x0004 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.CloudSaveSystem.SetSaveDataCallbackStruct
// 0x00000014
struct FSetSaveDataCallbackStruct
{
//	 vPoperty_Size=2
	int                                                SlotIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FScriptDelegate                             Callback;                                         		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0008 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct Engine.CloudSaveSystem.GetSaveDataCallbackStruct
// 0x00000014
struct FGetSaveDataCallbackStruct
{
//	 vPoperty_Size=2
	int                                                SlotIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FScriptDelegate                             Callback;                                         		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0008 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct Engine.UIRoot.UIRangeData
// 0x00000014
struct FUIRangeData
{
//	 vPoperty_Size=5
	float                                              CurrentValue;                                     		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MinValue;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MaxValue;                                         		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              NudgeValue;                                       		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bIntRange : 1;                                    		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.UIRoot.TextureCoordinates
// 0x00000010
struct FTextureCoordinates
{
//	 vPoperty_Size=4
	float                                              U;                                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              V;                                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UL;                                               		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              VL;                                               		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.UIRoot.InputKeyAction
// 0x0000002C
struct FInputKeyAction
{
//	 vPoperty_Size=4
	struct FName                                       InputKeyName;                                     		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InputKeyState;                                    		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FSeqOpOutputInputLink >             TriggeredOps;                                     		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class USequenceOp* >                       ActionsToExecute;                                 		// 0x001C (0x0010) [0x0000000020400000]              ( CPF_NeedCtorLink | CPF_Deprecated )
};

// ScriptStruct Engine.UIRoot.InputEventParameters
// 0x00000020
struct FInputEventParameters
{
//	 vPoperty_Size=9
	int                                                PlayerIndex;                                      		// 0x0000 (0x0004) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
	int                                                ControllerId;                                     		// 0x0004 (0x0004) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
	struct FName                                       InputKeyName;                                     		// 0x0008 (0x0008) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
	unsigned char                                      EventType;                                        		// 0x0010 (0x0001) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
	float                                              InputDelta;                                       		// 0x0014 (0x0004) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
	float                                              DeltaTime;                                        		// 0x0018 (0x0004) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
	unsigned long                                      bAltPressed : 1;                                  		// 0x001C (0x0004) [0x0000000000102002] [0x00000001] ( CPF_Const | CPF_Transient )
	unsigned long                                      bCtrlPressed : 1;                                 		// 0x001C (0x0004) [0x0000000000102002] [0x00000002] ( CPF_Const | CPF_Transient )
	unsigned long                                      bShiftPressed : 1;                                		// 0x001C (0x0004) [0x0000000000102002] [0x00000004] ( CPF_Const | CPF_Transient )
};

// ScriptStruct Engine.UIRoot.SubscribedInputEventParameters
// 0x0008(0x0028 - 0x0020)
struct FSubscribedInputEventParameters : FInputEventParameters
{
//	 vPoperty_Size=1
	struct FName                                       InputAliasName;                                   		// 0x0020 (0x0008) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
};

// ScriptStruct Engine.UIRoot.UIAxisEmulationDefinition
// 0x00000024
struct FUIAxisEmulationDefinition
{
//	 vPoperty_Size=4
	struct FName                                       AxisInputKey;                                     		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FName                                       AdjacentAxisInputKey;                             		// 0x0008 (0x0008) [0x0000000000000000]              
	unsigned long                                      bEmulateButtonPress : 1;                          		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FName                                       InputKeyToEmulate[ 0x2 ];                         		// 0x0014 (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.UIRoot.RawInputKeyEventData
// 0x00000009
struct FRawInputKeyEventData
{
//	 vPoperty_Size=2
	struct FName                                       InputKeyName;                                     		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      ModifierKeyFlags;                                 		// 0x0008 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.Console.AutoCompleteCommand
// 0x00000020
struct FAutoCompleteCommand
{
//	 vPoperty_Size=2
	struct FString                                     Command;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Desc;                                             		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.Console.AutoCompleteNode
// 0x00000024
struct FAutoCompleteNode
{
//	 vPoperty_Size=3
	int                                                IndexChar;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	TArray< int >                                      AutoCompleteListIndices;                          		// 0x0004 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FPointer >                          ChildNodes;                                       		// 0x0014 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.CoverMeshComponent.CoverMeshes
// 0x00000068
struct FCoverMeshes
{
//	 vPoperty_Size=d
	class UStaticMesh*                                 Base;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 LeanLeft;                                         		// 0x0008 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 LeanRight;                                        		// 0x0010 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 LeanLeftPref;                                     		// 0x0018 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 LeanRightPref;                                    		// 0x0020 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 Climb;                                            		// 0x0028 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 Mantle;                                           		// 0x0030 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 SlipLeft;                                         		// 0x0038 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 SlipRight;                                        		// 0x0040 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 SwatLeft;                                         		// 0x0048 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 SwatRight;                                        		// 0x0050 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 PopUp;                                            		// 0x0058 (0x0008) [0x0000000000000000]              
	class UStaticMesh*                                 PlayerOnly;                                       		// 0x0060 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.CoverLink.FireLinkItem
// 0x00000004
struct FFireLinkItem
{
//	 vPoperty_Size=4
	unsigned char                                      SrcType;                                          		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned char                                      SrcAction;                                        		// 0x0001 (0x0001) [0x0000000000000000]              
	unsigned char                                      DestType;                                         		// 0x0002 (0x0001) [0x0000000000000000]              
	unsigned char                                      DestAction;                                       		// 0x0003 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.CoverLink.FireLink
// 0x00000018
struct FFireLink
{
//	 vPoperty_Size=4
	TArray< unsigned char >                            Interactions;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                PackedProperties_CoverPairRefAndDynamicInfo;      		// 0x0010 (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bFallbackLink : 1;                                		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bDynamicIndexInited : 1;                          		// 0x0014 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct Engine.CoverLink.DynamicLinkInfo
// 0x00000018
struct FDynamicLinkInfo
{
//	 vPoperty_Size=2
	struct FVector                                     LastTargetLocation;                               		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector                                     LastSrcLocation;                                  		// 0x000C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.CoverLink.CoverReference
// 0x0004(0x001C - 0x0018)
struct FCoverReference : FActorReference
{
//	 vPoperty_Size=1
	int                                                SlotIdx;                                          		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CoverLink.ExposedLink
// 0x0000001D
struct FExposedLink
{
//	 vPoperty_Size=2
	struct FCoverReference                             TargetActor;                                      		// 0x0000 (0x001C) [0x0000000000020003]              ( CPF_Edit | CPF_Const | CPF_EditConst )
	unsigned char                                      ExposedScale;                                     		// 0x001C (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CoverLink.SlotMoveRef
// 0x00000060
struct FSlotMoveRef
{
//	 vPoperty_Size=3
	struct FPolyReference                              Poly;                                             		// 0x0000 (0x0024) [0x0000000000000001]              ( CPF_Edit )
	struct FBasedPosition                              Dest;                                             		// 0x0024 (0x0038) [0x0000000000000001]              ( CPF_Edit )
	int                                                Direction;                                        		// 0x005C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CoverLink.CoverInfo
// 0x0000000C
struct FCoverInfo
{
//	 vPoperty_Size=2
	class ACoverLink*                                  Link;                                             		// 0x0000 (0x0008) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	int                                                SlotIdx;                                          		// 0x0008 (0x0004) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
};

// ScriptStruct Engine.CoverLink.CoverSlot
// 0x00000090
struct FCoverSlot
{
//	 vPoperty_Size=26
	class APawn*                                       SlotOwner;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              SlotValidAfterTime;                               		// 0x0008 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	unsigned char                                      ForceCoverType;                                   		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      CoverType;                                        		// 0x000D (0x0001) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	unsigned char                                      LocationDescription;                              		// 0x000E (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     LocationOffset;                                   		// 0x0010 (0x000C) [0x0000000000000000]              
	struct FRotator                                    RotationOffset;                                   		// 0x001C (0x000C) [0x0000000000000000]              
	TArray< unsigned char >                            Actions;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FFireLink >                         FireLinks;                                        		// 0x0038 (0x0010) [0x0000000000420001]              ( CPF_Edit | CPF_EditConst | CPF_NeedCtorLink )
	TArray< struct FFireLink >                         RejectedFireLinks;                                		// 0x0048 (0x0010) [0x0000000000422001]              ( CPF_Edit | CPF_Transient | CPF_EditConst | CPF_NeedCtorLink )
	TArray< int >                                      ExposedCoverPackedProperties;                     		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                TurnTargetPackedProperties;                       		// 0x0068 (0x0004) [0x0000000000000000]              
	TArray< struct FSlotMoveRef >                      SlipRefs;                                         		// 0x006C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FCoverInfo >                        OverlapClaimsList;                                		// 0x007C (0x0010) [0x0000000000420001]              ( CPF_Edit | CPF_EditConst | CPF_NeedCtorLink )
	unsigned long                                      bLeanLeft : 1;                                    		// 0x008C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bLeanRight : 1;                                   		// 0x008C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bForceCanPopUp : 1;                               		// 0x008C (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bCanPopUp : 1;                                    		// 0x008C (0x0004) [0x0000000000020001] [0x00000008] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bCanMantle : 1;                                   		// 0x008C (0x0004) [0x0000000000020001] [0x00000010] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bCanClimbUp : 1;                                  		// 0x008C (0x0004) [0x0000000000020001] [0x00000020] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bForceCanCoverSlip_Left : 1;                      		// 0x008C (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned long                                      bForceCanCoverSlip_Right : 1;                     		// 0x008C (0x0004) [0x0000000000000001] [0x00000080] ( CPF_Edit )
	unsigned long                                      bCanCoverSlip_Left : 1;                           		// 0x008C (0x0004) [0x0000000000020001] [0x00000100] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bCanCoverSlip_Right : 1;                          		// 0x008C (0x0004) [0x0000000000020001] [0x00000200] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bCanSwatTurn_Left : 1;                            		// 0x008C (0x0004) [0x0000000000020001] [0x00000400] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bCanSwatTurn_Right : 1;                           		// 0x008C (0x0004) [0x0000000000020001] [0x00000800] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bEnabled : 1;                                     		// 0x008C (0x0004) [0x0000000000000001] [0x00001000] ( CPF_Edit )
	unsigned long                                      bAllowPopup : 1;                                  		// 0x008C (0x0004) [0x0000000000000001] [0x00002000] ( CPF_Edit )
	unsigned long                                      bAllowMantle : 1;                                 		// 0x008C (0x0004) [0x0000000000000001] [0x00004000] ( CPF_Edit )
	unsigned long                                      bAllowCoverSlip : 1;                              		// 0x008C (0x0004) [0x0000000000000001] [0x00008000] ( CPF_Edit )
	unsigned long                                      bAllowClimbUp : 1;                                		// 0x008C (0x0004) [0x0000000000000001] [0x00010000] ( CPF_Edit )
	unsigned long                                      bAllowSwatTurn : 1;                               		// 0x008C (0x0004) [0x0000000000000001] [0x00020000] ( CPF_Edit )
	unsigned long                                      bForceNoGroundAdjust : 1;                         		// 0x008C (0x0004) [0x0000000000000001] [0x00040000] ( CPF_Edit )
	unsigned long                                      bPlayerOnly : 1;                                  		// 0x008C (0x0004) [0x0000000000000001] [0x00080000] ( CPF_Edit )
	unsigned long                                      bPreferLeanOverPopup : 1;                         		// 0x008C (0x0004) [0x0000000000000001] [0x00100000] ( CPF_Edit )
	unsigned long                                      bDestructible : 1;                                		// 0x008C (0x0004) [0x0000000000002000] [0x00200000] ( CPF_Transient )
	unsigned long                                      bSelected : 1;                                    		// 0x008C (0x0004) [0x0000000000002000] [0x00400000] ( CPF_Transient )
	unsigned long                                      bFailedToFindSurface : 1;                         		// 0x008C (0x0004) [0x0000000000022001] [0x00800000] ( CPF_Edit | CPF_Transient | CPF_EditConst )
};

// ScriptStruct Engine.CoverLink.CovPosInfo
// 0x00000038
struct FCovPosInfo
{
//	 vPoperty_Size=7
	class ACoverLink*                                  Link;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                LtSlotIdx;                                        		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                RtSlotIdx;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              LtToRtPct;                                        		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FVector                                     Location;                                         		// 0x0014 (0x000C) [0x0000000000000000]              
	struct FVector                                     Normal;                                           		// 0x0020 (0x000C) [0x0000000000000000]              
	struct FVector                                     Tangent;                                          		// 0x002C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.CoverReplicator.ManualCoverTypeInfo
// 0x00000002
struct FManualCoverTypeInfo
{
//	 vPoperty_Size=2
	unsigned char                                      SlotIndex;                                        		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned char                                      ManualCoverType;                                  		// 0x0001 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.CoverReplicator.CoverReplicationInfo
// 0x00000048
struct FCoverReplicationInfo
{
//	 vPoperty_Size=5
	class ACoverLink*                                  Link;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	TArray< unsigned char >                            SlotsEnabled;                                     		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            SlotsDisabled;                                    		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            SlotsAdjusted;                                    		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FManualCoverTypeInfo >              SlotsCoverTypeChanged;                            		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.CullDistanceVolume.CullDistanceSizePair
// 0x00000008
struct FCullDistanceSizePair
{
//	 vPoperty_Size=2
	float                                              Size;                                             		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              CullDistance;                                     		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.CurveEdPresetCurve.PresetGeneratedPoint
// 0x00000015
struct FPresetGeneratedPoint
{
//	 vPoperty_Size=6
	float                                              KeyIn;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              KeyOut;                                           		// 0x0004 (0x0004) [0x0000000000000000]              
	unsigned long                                      TangentsValid : 1;                                		// 0x0008 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              TangentIn;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              TangentOut;                                       		// 0x0010 (0x0004) [0x0000000000000000]              
	unsigned char                                      IntepMode;                                        		// 0x0014 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.DataStoreClient.PlayerDataStoreGroup
// 0x00000018
struct FPlayerDataStoreGroup
{
//	 vPoperty_Size=2
	class ULocalPlayer*                                PlayerOwner;                                      		// 0x0000 (0x0008) [0x0000000000102002]              ( CPF_Const | CPF_Transient )
	TArray< class UUIDataStore* >                      DataStores;                                       		// 0x0008 (0x0010) [0x0000000000502002]              ( CPF_Const | CPF_Transient | CPF_NeedCtorLink )
};

// ScriptStruct Engine.DecalComponent.DecalReceiver
// 0x00000010
struct FDecalReceiver
{
//	 vPoperty_Size=2
	class UPrimitiveComponent*                         Component;                                        		// 0x0000 (0x0008) [0x000000000408000A]              ( CPF_Const | CPF_ExportObject | CPF_Component | CPF_EditInline )
	struct FPointer                                    RenderData;                                       		// 0x0008 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.DecalManager.ActiveDecalInfo
// 0x0000000C
struct FActiveDecalInfo
{
//	 vPoperty_Size=2
	class UDecalComponent*                             Decal;                                            		// 0x0000 (0x0008) [0x0000000004080008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
	float                                              LifetimeRemaining;                                		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.MaterialInterface.LightmassMaterialInterfaceSettings
// 0x0000001C
struct FLightmassMaterialInterfaceSettings
{
//	 vPoperty_Size=c
	unsigned long                                      bCastShadowAsMasked : 1;                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              EmissiveBoost;                                    		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DiffuseBoost;                                     		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              SpecularBoost;                                    		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              ExportResolutionScale;                            		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DistanceFieldPenumbraScale;                       		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bOverrideCastShadowAsMasked : 1;                  		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bOverrideEmissiveBoost : 1;                       		// 0x0018 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bOverrideDiffuseBoost : 1;                        		// 0x0018 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bOverrideSpecularBoost : 1;                       		// 0x0018 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      bOverrideExportResolutionScale : 1;               		// 0x0018 (0x0004) [0x0000000000000000] [0x00000010] 
	unsigned long                                      bOverrideDistanceFieldPenumbraScale : 1;          		// 0x0018 (0x0004) [0x0000000000000000] [0x00000020] 
};

// ScriptStruct Engine.Material.MaterialInput
// 0x00000034
struct FMaterialInput
{
//	 vPoperty_Size=9
	class UMaterialExpression*                         Expression;                                       		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                OutputIndex;                                      		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FString                                     InputName;                                        		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Mask;                                             		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                MaskR;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                MaskG;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                MaskB;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                MaskA;                                            		// 0x002C (0x0004) [0x0000000000000000]              
	int                                                GCC64_Padding;                                    		// 0x0030 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Material.ColorMaterialInput
// 0x0008(0x003C - 0x0034)
struct FColorMaterialInput : FMaterialInput
{
//	 vPoperty_Size=2
	unsigned long                                      UseConstant : 1;                                  		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FColor                                      Constant;                                         		// 0x0038 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Material.ScalarMaterialInput
// 0x0008(0x003C - 0x0034)
struct FScalarMaterialInput : FMaterialInput
{
//	 vPoperty_Size=2
	unsigned long                                      UseConstant : 1;                                  		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              Constant;                                         		// 0x0038 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Material.VectorMaterialInput
// 0x0010(0x0044 - 0x0034)
struct FVectorMaterialInput : FMaterialInput
{
//	 vPoperty_Size=2
	unsigned long                                      UseConstant : 1;                                  		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FVector                                     Constant;                                         		// 0x0038 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.Material.Vector2MaterialInput
// 0x000C(0x0040 - 0x0034)
struct FVector2MaterialInput : FMaterialInput
{
//	 vPoperty_Size=3
	unsigned long                                      UseConstant : 1;                                  		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              ConstantX;                                        		// 0x0038 (0x0004) [0x0000000000000000]              
	float                                              ConstantY;                                        		// 0x003C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Material.MaterialFunctionInfo
// 0x00000018
struct FMaterialFunctionInfo
{
//	 vPoperty_Size=2
	struct FGuid                                       StateId;                                          		// 0x0000 (0x0010) [0x0000000000000000]              
	class UMaterialFunction*                           Function;                                         		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.PhysicsVolume.CheckpointRecord
// 0x00000004
struct APhysicsVolume_FCheckpointRecord
{
//	 vPoperty_Size=2
	unsigned long                                      bPainCausing : 1;                                 		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bActive : 1;                                      		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct Engine.DynamicBlockingVolume.CheckpointRecord
// 0x0000001C
struct ADynamicBlockingVolume_FCheckpointRecord
{
//	 vPoperty_Size=5
	struct FVector                                     Location;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FRotator                                    Rotation;                                         		// 0x000C (0x000C) [0x0000000000000000]              
	unsigned long                                      bCollideActors : 1;                               		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bBlockActors : 1;                                 		// 0x0018 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bNeedsReplication : 1;                            		// 0x0018 (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleSysParam
// 0x00000040
struct FParticleSysParam
{
//	 vPoperty_Size=9
	struct FName                                       Name;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      ParamType;                                        		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              Scalar;                                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Scalar_Low;                                       		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Vector;                                           		// 0x0014 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Vector_Low;                                       		// 0x0020 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      Color;                                            		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class AActor*                                      Actor;                                            		// 0x0030 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInterface*                          Material;                                         		// 0x0038 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEventData
// 0x00000034
struct FParticleEventData
{
//	 vPoperty_Size=6
	int                                                Type;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FName                                       EventName;                                        		// 0x0004 (0x0008) [0x0000000000000000]              
	float                                              EmitterTime;                                      		// 0x000C (0x0004) [0x0000000000000000]              
	struct FVector                                     Location;                                         		// 0x0010 (0x000C) [0x0000000000000000]              
	struct FVector                                     Direction;                                        		// 0x001C (0x000C) [0x0000000000000000]              
	struct FVector                                     Velocity;                                         		// 0x0028 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEventSpawnData
// 0x0000(0x0034 - 0x0034)
struct FParticleEventSpawnData : FParticleEventData
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEventDeathData
// 0x0004(0x0038 - 0x0034)
struct FParticleEventDeathData : FParticleEventData
{
//	 vPoperty_Size=1
	float                                              ParticleTime;                                     		// 0x0034 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEventCollideData
// 0x0020(0x0054 - 0x0034)
struct FParticleEventCollideData : FParticleEventData
{
//	 vPoperty_Size=5
	float                                              ParticleTime;                                     		// 0x0034 (0x0004) [0x0000000000000000]              
	struct FVector                                     Normal;                                           		// 0x0038 (0x000C) [0x0000000000000000]              
	float                                              Time;                                             		// 0x0044 (0x0004) [0x0000000000000000]              
	int                                                Item;                                             		// 0x0048 (0x0004) [0x0000000000000000]              
	struct FName                                       BoneName;                                         		// 0x004C (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEventAttractorCollideData
// 0x0000(0x0054 - 0x0054)
struct FParticleEventAttractorCollideData : FParticleEventCollideData
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEventKismetData
// 0x0010(0x0044 - 0x0034)
struct FParticleEventKismetData : FParticleEventData
{
//	 vPoperty_Size=2
	unsigned long                                      UsePSysCompLocation : 1;                          		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FVector                                     Normal;                                           		// 0x0038 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.ParticleSystemComponent.ViewParticleEmitterInstanceMotionBlurInfo
// 0x00000048
struct FViewParticleEmitterInstanceMotionBlurInfo
{
//	 vPoperty_Size=1
	struct FMap_Mirror                                 EmitterInstanceMBInfoMap;                         		// 0x0000 (0x0048) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEmitterInstanceMotionBlurInfo
// 0x00000048
struct FParticleEmitterInstanceMotionBlurInfo
{
//	 vPoperty_Size=1
	struct FMap_Mirror                                 ParticleMBInfoMap;                                		// 0x0000 (0x0048) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
};

// ScriptStruct Engine.ParticleSystemComponent.ParticleEmitterInstance
// 0x00000000
struct FParticleEmitterInstance
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.Emitter.CheckpointRecord
// 0x00000004
struct AEmitter_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bIsActive : 1;                                    		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.EmitterPool.EmitterBaseInfo
// 0x0000002C
struct FEmitterBaseInfo
{
//	 vPoperty_Size=5
	class UParticleSystemComponent*                    PSC;                                              		// 0x0000 (0x0008) [0x0000000004080008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
	class AActor*                                      Base;                                             		// 0x0008 (0x0008) [0x0000000000000000]              
	struct FVector                                     RelativeLocation;                                 		// 0x0010 (0x000C) [0x0000000000000000]              
	struct FRotator                                    RelativeRotation;                                 		// 0x001C (0x000C) [0x0000000000000000]              
	unsigned long                                      bInheritBaseScale : 1;                            		// 0x0028 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.Engine.StatColorMapEntry
// 0x00000008
struct FStatColorMapEntry
{
//	 vPoperty_Size=2
	float                                              In;                                               		// 0x0000 (0x0004) [0x0000000000044000]              ( CPF_Config | CPF_GlobalConfig )
	struct FColor                                      Out;                                              		// 0x0004 (0x0004) [0x0000000000044000]              ( CPF_Config | CPF_GlobalConfig )
};

// ScriptStruct Engine.Engine.StatColorMapping
// 0x00000024
struct FStatColorMapping
{
//	 vPoperty_Size=3
	struct FString                                     StatName;                                         		// 0x0000 (0x0010) [0x0000000000444000]              ( CPF_Config | CPF_GlobalConfig | CPF_NeedCtorLink )
	TArray< struct FStatColorMapEntry >                ColorMap;                                         		// 0x0010 (0x0010) [0x0000000000444000]              ( CPF_Config | CPF_GlobalConfig | CPF_NeedCtorLink )
	unsigned long                                      DisableBlend : 1;                                 		// 0x0020 (0x0004) [0x0000000000044000] [0x00000001] ( CPF_Config | CPF_GlobalConfig )
};

// ScriptStruct Engine.Engine.DropNoteInfo
// 0x00000028
struct FDropNoteInfo
{
//	 vPoperty_Size=3
	struct FVector                                     Location;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FRotator                                    Rotation;                                         		// 0x000C (0x000C) [0x0000000000000000]              
	struct FString                                     Comment;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.EngineTypes.PrimitiveMaterialRef
// 0x0000000C
struct FPrimitiveMaterialRef
{
//	 vPoperty_Size=2
	class UPrimitiveComponent*                         Primitive;                                        		// 0x0000 (0x0008) [0x0000000004080008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
	int                                                MaterialIndex;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.EngineTypes.PostProcessMaterialRef
// 0x00000008
struct FPostProcessMaterialRef
{
//	 vPoperty_Size=1
	class UPostProcessEffect*                          Effect;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.EngineTypes.MaterialReferenceList
// 0x00000028
struct FMaterialReferenceList
{
//	 vPoperty_Size=3
	class UMaterialInterface*                          TargetMaterial;                                   		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FPrimitiveMaterialRef >             AffectedMaterialRefs;                             		// 0x0008 (0x0010) [0x0000000000480000]              ( CPF_Component | CPF_NeedCtorLink )
	TArray< struct FPostProcessMaterialRef >           AffectedPPChainMaterialRefs;                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.EngineTypes.VelocityObstacleStat
// 0x00000020
struct FVelocityObstacleStat
{
//	 vPoperty_Size=4
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector                                     Velocity;                                         		// 0x000C (0x000C) [0x0000000000000000]              
	float                                              Radius;                                           		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                Priority;                                         		// 0x001C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.FacebookIntegration.FacebookFriend
// 0x00000020
struct FFacebookFriend
{
//	 vPoperty_Size=2
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Id;                                               		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.FogVolumeDensityInfo.CheckpointRecord
// 0x00000004
struct AFogVolumeDensityInfo_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bEnabled : 1;                                     		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.FontImportOptions.FontImportOptionsData
// 0x000000A8
struct FFontImportOptionsData
{
//	 vPoperty_Size=1d
	struct FString                                     FontName;                                         		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	float                                              Height;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bEnableAntialiasing : 1;                          		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bEnableBold : 1;                                  		// 0x0014 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bEnableItalic : 1;                                		// 0x0014 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bEnableUnderline : 1;                             		// 0x0014 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      bAlphaOnly : 1;                                   		// 0x0014 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned char                                      CharacterSet;                                     		// 0x0018 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     Chars;                                            		// 0x001C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     UnicodeRange;                                     		// 0x002C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     CharsFilePath;                                    		// 0x003C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     CharsFileWildcard;                                		// 0x004C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      bCreatePrintableOnly : 1;                         		// 0x005C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bIncludeASCIIRange : 1;                           		// 0x005C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	struct FLinearColor                                ForegroundColor;                                  		// 0x0060 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bEnableDropShadow : 1;                            		// 0x0070 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                TexturePageWidth;                                 		// 0x0074 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                TexturePageMaxHeight;                             		// 0x0078 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                XPadding;                                         		// 0x007C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                YPadding;                                         		// 0x0080 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ExtendBoxTop;                                     		// 0x0084 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ExtendBoxBottom;                                  		// 0x0088 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ExtendBoxRight;                                   		// 0x008C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ExtendBoxLeft;                                    		// 0x0090 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bEnableLegacyMode : 1;                            		// 0x0094 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                Kerning;                                          		// 0x0098 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bUseDistanceFieldAlpha : 1;                       		// 0x009C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                DistanceFieldScaleFactor;                         		// 0x00A0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DistanceFieldScanRadiusScale;                     		// 0x00A4 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.Font.FontCharacter
// 0x00000018
struct FFontCharacter
{
//	 vPoperty_Size=6
	int                                                StartU;                                           		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                StartV;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                USize;                                            		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                VSize;                                            		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      TextureIndex;                                     		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                VerticalOffset;                                   		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ForceFeedbackWaveform.WaveformSample
// 0x00000008
struct FWaveformSample
{
//	 vPoperty_Size=5
	unsigned char                                      LeftAmplitude;                                    		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      RightAmplitude;                                   		// 0x0001 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      LeftFunction;                                     		// 0x0002 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      RightFunction;                                    		// 0x0003 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              Duration;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.FracturedStaticMeshComponent.FragmentGroup
// 0x00000014
struct FFragmentGroup
{
//	 vPoperty_Size=2
	TArray< int >                                      FragmentIndices;                                  		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bGroupIsRooted : 1;                               		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.WorldInfo.HostMigrationState
// 0x00000020
struct FHostMigrationState
{
//	 vPoperty_Size=5
	unsigned char                                      HostMigrationProgress;                            		// 0x0000 (0x0001) [0x0000000000000000]              
	float                                              HostMigrationElapsedTime;                         		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              HostMigrationTravelCountdown;                     		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FString                                     HostMigrationTravelURL;                           		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bHostMigrationEnabled : 1;                        		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.MusicTrackDataStructures.MusicTrackStruct
// 0x0000002C
struct FMusicTrackStruct
{
//	 vPoperty_Size=8
	class USoundCue*                                   TheSoundCue;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bAutoPlay : 1;                                    		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bPersistentAcrossLevels : 1;                      		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	float                                              FadeInTime;                                       		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeInVolumeLevel;                                		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeOutTime;                                      		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeOutVolumeLevel;                               		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     MP3Filename;                                      		// 0x001C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.WorldInfo.NavMeshPathGoalEvaluatorCacheDatum
// 0x0000002C
struct FNavMeshPathGoalEvaluatorCacheDatum
{
//	 vPoperty_Size=2
	int                                                ListIdx;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	class UNavMeshPathGoalEvaluator*                   List[ 0x5 ];                                      		// 0x0004 (0x0028) [0x0000000000000000]              
};

// ScriptStruct Engine.WorldInfo.WorldFractureSettings
// 0x0000001C
struct FWorldFractureSettings
{
//	 vPoperty_Size=8
	float                                              ChanceOfPhysicsChunkOverride;                     		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned long                                      bEnableChanceOfPhysicsChunkOverride : 1;          		// 0x0004 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bLimitExplosionChunkSize : 1;                     		// 0x0004 (0x0004) [0x0000000000000000] [0x00000002] 
	float                                              MaxExplosionChunkSize;                            		// 0x0008 (0x0004) [0x0000000000000000]              
	unsigned long                                      bLimitDamageChunkSize : 1;                        		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              MaxDamageChunkSize;                               		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                MaxNumFacturedChunksToSpawnInAFrame;              		// 0x0014 (0x0004) [0x0000000000000000]              
	float                                              FractureExplosionVelScale;                        		// 0x0018 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.WorldInfo.PhysXEmitterVerticalProperties
// 0x00000018
struct FPhysXEmitterVerticalProperties
{
//	 vPoperty_Size=6
	unsigned long                                      bDisableLod : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                ParticlesLodMin;                                  		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ParticlesLodMax;                                  		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                PacketsPerPhysXParticleSystemMax;                 		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bApplyCylindricalPacketCulling : 1;               		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              SpawnLodVsFifoBias;                               		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.WorldInfo.PhysXVerticalProperties
// 0x00000018
struct FPhysXVerticalProperties
{
//	 vPoperty_Size=1
	struct FPhysXEmitterVerticalProperties             Emitters;                                         		// 0x0000 (0x0018) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
};

// ScriptStruct Engine.WorldInfo.NavMeshPathConstraintCacheDatum
// 0x0000002C
struct FNavMeshPathConstraintCacheDatum
{
//	 vPoperty_Size=2
	int                                                ListIdx;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	class UNavMeshPathConstraint*                      List[ 0x5 ];                                      		// 0x0004 (0x0028) [0x0000000000000000]              
};

// ScriptStruct Engine.WorldInfo.LightmassWorldInfoSettings
// 0x00000058
struct FLightmassWorldInfoSettings
{
//	 vPoperty_Size=17
	float                                              StaticLightingLevelScale;                         		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                NumIndirectLightingBounces;                       		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      EnvironmentColor;                                 		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EnvironmentIntensity;                             		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bEnableAdvancedEnvironmentColor : 1;              		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FColor                                      EnvironmentSunColor;                              		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EnvironmentSunIntensity;                          		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EnvironmentLightTerminatorAngle;                  		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     EnvironmentLightDirection;                        		// 0x0020 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	float                                              EmissiveBoost;                                    		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DiffuseBoost;                                     		// 0x0030 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              SpecularBoost;                                    		// 0x0034 (0x0004) [0x0000000000000000]              
	float                                              IndirectNormalInfluenceBoost;                     		// 0x0038 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bUseAmbientOcclusion : 1;                         		// 0x003C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bEnableImageReflectionShadowing : 1;              		// 0x003C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	float                                              DirectIlluminationOcclusionFraction;              		// 0x0040 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              IndirectIlluminationOcclusionFraction;            		// 0x0044 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              OcclusionExponent;                                		// 0x0048 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FullyOccludedSamplesFraction;                     		// 0x004C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MaxOcclusionDistance;                             		// 0x0050 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bVisualizeMaterialDiffuse : 1;                    		// 0x0054 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bVisualizeAmbientOcclusion : 1;                   		// 0x0054 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bCompressShadowmap : 1;                           		// 0x0054 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
};

// ScriptStruct Engine.WorldInfo.ScreenMessageString
// 0x00000024
struct FScreenMessageString
{
//	 vPoperty_Size=5
	struct FQWord                                      Key;                                              		// 0x0000 (0x0008) [0x0000000000102000]              ( CPF_Transient )
	struct FString                                     ScreenMessage;                                    		// 0x0008 (0x0010) [0x0000000000502000]              ( CPF_Transient | CPF_NeedCtorLink )
	struct FColor                                      DisplayColor;                                     		// 0x0018 (0x0004) [0x0000000000102000]              ( CPF_Transient )
	float                                              TimeToDisplay;                                    		// 0x001C (0x0004) [0x0000000000102000]              ( CPF_Transient )
	float                                              CurrentTimeDisplayed;                             		// 0x0020 (0x0004) [0x0000000000102000]              ( CPF_Transient )
};

// ScriptStruct Engine.WorldInfo.ApexModuleDestructibleSettings
// 0x00000014
struct FApexModuleDestructibleSettings
{
//	 vPoperty_Size=5
	int                                                MaxChunkIslandCount;                              		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                MaxShapeCount;                                    		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                MaxRrbActorCount;                                 		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              MaxChunkSeparationLOD;                            		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bOverrideMaxChunkSeparationLOD : 1;               		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.WorldInfo.PhysXSimulationProperties
// 0x0000000C
struct FPhysXSimulationProperties
{
//	 vPoperty_Size=4
	unsigned long                                      bUseHardware : 1;                                 		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bFixedTimeStep : 1;                               		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	float                                              TimeStep;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                MaxSubSteps;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.WorldInfo.PhysXSceneProperties
// 0x0000003C
struct FPhysXSceneProperties
{
//	 vPoperty_Size=5
	struct FPhysXSimulationProperties                  PrimaryScene;                                     		// 0x0000 (0x000C) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
	struct FPhysXSimulationProperties                  CompartmentRigidBody;                             		// 0x000C (0x000C) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
	struct FPhysXSimulationProperties                  CompartmentFluid;                                 		// 0x0018 (0x000C) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
	struct FPhysXSimulationProperties                  CompartmentCloth;                                 		// 0x0024 (0x000C) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
	struct FPhysXSimulationProperties                  CompartmentSoftBody;                              		// 0x0030 (0x000C) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
};

// ScriptStruct Engine.WorldInfo.CompartmentRunList
// 0x00000004
struct FCompartmentRunList
{
//	 vPoperty_Size=4
	unsigned long                                      RigidBody : 1;                                    		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      Fluid : 1;                                        		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      Cloth : 1;                                        		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      SoftBody : 1;                                     		// 0x0000 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
};

// ScriptStruct Engine.WorldInfo.NetViewer
// 0x00000028
struct FNetViewer
{
//	 vPoperty_Size=4
	class APlayerController*                           InViewer;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	class AActor*                                      Viewer;                                           		// 0x0008 (0x0008) [0x0000000000000000]              
	struct FVector                                     ViewLocation;                                     		// 0x0010 (0x000C) [0x0000000000000000]              
	struct FVector                                     ViewDir;                                          		// 0x001C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.FracturedStaticMeshActor.DeferredPartToSpawn
// 0x00000024
struct FDeferredPartToSpawn
{
//	 vPoperty_Size=5
	int                                                ChunkIndex;                                       		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FVector                                     InitialVel;                                       		// 0x0004 (0x000C) [0x0000000000000000]              
	struct FVector                                     InitialAngVel;                                    		// 0x0010 (0x000C) [0x0000000000000000]              
	float                                              RelativeScale;                                    		// 0x001C (0x0004) [0x0000000000000000]              
	unsigned long                                      bExplosion : 1;                                   		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.FracturedStaticMeshActor.CheckpointRecord
// 0x00000014
struct AFracturedStaticMeshActor_FCheckpointRecord
{
//	 vPoperty_Size=2
	unsigned long                                      bIsShutdown : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	TArray< unsigned char >                            FragmentVis;                                      		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.GameEngine.FullyLoadedPackagesInfo
// 0x00000034
struct FFullyLoadedPackagesInfo
{
//	 vPoperty_Size=4
	unsigned char                                      FullyLoadType;                                    		// 0x0000 (0x0001) [0x0000000000000000]              
	struct FString                                     Tag;                                              		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FName >                             PackagesToLoad;                                   		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UObject* >                           LoadedObjects;                                    		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.GameEngine.NamedNetDriver
// 0x00000010
struct FNamedNetDriver
{
//	 vPoperty_Size=2
	struct FName                                       NetDriverName;                                    		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FPointer                                    NetDriver;                                        		// 0x0008 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.GameEngine.AnimTag
// 0x00000020
struct FAnimTag
{
//	 vPoperty_Size=2
	struct FString                                     Tag;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           Contains;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.GameEngine.LevelStreamingStatus
// 0x0000000C
struct FLevelStreamingStatus
{
//	 vPoperty_Size=3
	struct FName                                       PackageName;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned long                                      bShouldBeLoaded : 1;                              		// 0x0008 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bShouldBeVisible : 1;                             		// 0x0008 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct Engine.GameEngine.URL
// 0x00000058
struct FURL
{
//	 vPoperty_Size=7
	struct FString                                     Protocol;                                         		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     Host;                                             		// 0x0010 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                Port;                                             		// 0x0020 (0x0004) [0x0000000000100000]              
	struct FString                                     Map;                                              		// 0x0024 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           Op;                                               		// 0x0034 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     Portal;                                           		// 0x0044 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                Valid;                                            		// 0x0054 (0x0004) [0x0000000000100000]              
};

// ScriptStruct Engine.GameInfo.GameClassShortName
// 0x00000020
struct FGameClassShortName
{
//	 vPoperty_Size=2
	struct FString                                     ShortName;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GameClassName;                                    		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.GameInfo.GameTypePrefix
// 0x00000044
struct FGameTypePrefix
{
//	 vPoperty_Size=5
	struct FString                                     Prefix;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bUsesCommonPackage : 1;                           		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FString                                     GameType;                                         		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           AdditionalGameTypes;                              		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           ForcedObjects;                                    		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.GameplayEvents.GameStatGroup
// 0x00000008
struct FGameStatGroup
{
//	 vPoperty_Size=2
	unsigned char                                      Group;                                            		// 0x0000 (0x0001) [0x0000000000000000]              
	int                                                Level;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.GameplayEvents.GameplayEventsHeader
// 0x00000030
struct FGameplayEventsHeader
{
//	 vPoperty_Size=9
	int                                                EngineVersion;                                    		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                StatsWriterVersion;                               		// 0x0004 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                StreamOffset;                                     		// 0x0008 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                AggregateOffset;                                  		// 0x000C (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                FooterOffset;                                     		// 0x0010 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                TotalStreamSize;                                  		// 0x0014 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                FileSize;                                         		// 0x0018 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     FilterClass;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Flags;                                            		// 0x002C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.GameplayEvents.GameSessionInformation
// 0x00000088
struct FGameSessionInformation
{
//	 vPoperty_Size=f
	int                                                AppTitleID;                                       		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                PlatformType;                                     		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FString                                     Language;                                         		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GameplaySessionTimestamp;                         		// 0x0018 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	float                                              GameplaySessionStartTime;                         		// 0x0028 (0x0004) [0x0000000000000002]              ( CPF_Const )
	float                                              GameplaySessionEndTime;                           		// 0x002C (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bGameplaySessionInProgress : 1;                   		// 0x0030 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	struct FString                                     GameplaySessionID;                                		// 0x0034 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FString                                     GameClassName;                                    		// 0x0044 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FString                                     MapName;                                          		// 0x0054 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FString                                     MapURL;                                           		// 0x0064 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	int                                                SessionInstance;                                  		// 0x0074 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                GameTypeId;                                       		// 0x0078 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FUniqueNetId                                OwningNetId;                                      		// 0x007C (0x0008) [0x0000000000000002]              ( CPF_Const )
	int                                                PlaylistId;                                       		// 0x0084 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.GameplayEvents.TeamInformation
// 0x0000001C
struct FTeamInformation
{
//	 vPoperty_Size=4
	int                                                TeamIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     TeamName;                                         		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FColor                                      TeamColor;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                MaxSize;                                          		// 0x0018 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.GameplayEvents.PlayerInformation
// 0x00000024
struct FPlayerInformation
{
//	 vPoperty_Size=4
	struct FName                                       ControllerName;                                   		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     PlayerName;                                       		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FUniqueNetId                                UniqueId;                                         		// 0x0018 (0x0008) [0x0000000000000000]              
	unsigned long                                      bIsBot : 1;                                       		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.GameplayEvents.GameplayEventMetaData
// 0x00000018
struct FGameplayEventMetaData
{
//	 vPoperty_Size=4
	int                                                EventID;                                          		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FName                                       EventName;                                        		// 0x0004 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FGameStatGroup                              StatGroup;                                        		// 0x000C (0x0008) [0x0000000000000002]              ( CPF_Const )
	int                                                EventDataType;                                    		// 0x0014 (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.GameplayEvents.WeaponClassEventData
// 0x00000008
struct FWeaponClassEventData
{
//	 vPoperty_Size=1
	struct FName                                       WeaponClassName;                                  		// 0x0000 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.GameplayEvents.DamageClassEventData
// 0x00000008
struct FDamageClassEventData
{
//	 vPoperty_Size=1
	struct FName                                       DamageClassName;                                  		// 0x0000 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.GameplayEvents.ProjectileClassEventData
// 0x00000008
struct FProjectileClassEventData
{
//	 vPoperty_Size=1
	struct FName                                       ProjectileClassName;                              		// 0x0000 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.GameplayEvents.PawnClassEventData
// 0x00000008
struct FPawnClassEventData
{
//	 vPoperty_Size=1
	struct FName                                       PawnClassName;                                    		// 0x0000 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.GameViewportClient.PerPlayerSplitscreenData
// 0x00000010
struct FPerPlayerSplitscreenData
{
//	 vPoperty_Size=4
	float                                              SizeX;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              SizeY;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              OriginX;                                          		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              OriginY;                                          		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.GameViewportClient.SplitscreenData
// 0x00000010
struct FSplitscreenData
{
//	 vPoperty_Size=1
	TArray< struct FPerPlayerSplitscreenData >         PlayerData;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.GameViewportClient.DebugDisplayProperty
// 0x00000014
struct FDebugDisplayProperty
{
//	 vPoperty_Size=3
	class UObject*                                     Obj;                                              		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FName                                       PropertyName;                                     		// 0x0008 (0x0008) [0x0000000000000000]              
	unsigned long                                      bSpecialProperty : 1;                             		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.GameViewportClient.TitleSafeZoneArea
// 0x00000010
struct FTitleSafeZoneArea
{
//	 vPoperty_Size=4
	float                                              MaxPercentX;                                      		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              MaxPercentY;                                      		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              RecommendedPercentX;                              		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              RecommendedPercentY;                              		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.GameViewportClient.ShowFlags_Mirror
// 0x00000010
struct FShowFlags_Mirror
{
//	 vPoperty_Size=2
	struct FQWord                                      flags0;                                           		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FQWord                                      flags1;                                           		// 0x0008 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.GameViewportClient.ExportShowFlags_Mirror
// 0x0000(0x0010 - 0x0010)
struct FExportShowFlags_Mirror : FShowFlags_Mirror
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.GoogleIntegration.GoogleFriend
// 0x00000020
struct FGoogleFriend
{
//	 vPoperty_Size=2
	struct FString                                     DisplayName;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Id;                                               		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.GoogleIntegration.YouTubeChannel
// 0x00000030
struct FYouTubeChannel
{
//	 vPoperty_Size=3
	struct FString                                     ChannelId;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ChannelTitle;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Description;                                      		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.H7LightmassEnvironmentSphereInterface.H7LightmassEnvironmentSphereData
// 0x00000018
struct FH7LightmassEnvironmentSphereData
{
//	 vPoperty_Size=4
	struct FVector                                     Center;                                           		// 0x0000 (0x000C) [0x0000000000000000]              
	float                                              Radius;                                           		// 0x000C (0x0004) [0x0000000000000000]              
	struct FColor                                      EnvironmentColor;                                 		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              EnvironmentColorIntensity;                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.HeadTrackingComponent.ActorToLookAt
// 0x0000001C
struct FActorToLookAt
{
//	 vPoperty_Size=6
	class AActor*                                      Actor;                                            		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              Rating;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              EnteredTime;                                      		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              LastKnownDistance;                                		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              StartTimeBeingLookedAt;                           		// 0x0014 (0x0004) [0x0000000000000000]              
	unsigned long                                      CurrentlyBeingLookedAt : 1;                       		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.IniLocPatcher.IniLocFileEntry
// 0x0005(0x0049 - 0x0044)
struct FIniLocFileEntry : FEmsFile
{
//	 vPoperty_Size=2
	unsigned long                                      bIsUnicode : 1;                                   		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      ReadState;                                        		// 0x0048 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.Input.KeyBind
// 0x0000001C
struct FKeyBind
{
//	 vPoperty_Size=8
	struct FName                                       Name;                                             		// 0x0000 (0x0008) [0x0000000000004000]              ( CPF_Config )
	struct FString                                     Command;                                          		// 0x0008 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	unsigned long                                      Control : 1;                                      		// 0x0018 (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
	unsigned long                                      Shift : 1;                                        		// 0x0018 (0x0004) [0x0000000000004000] [0x00000002] ( CPF_Config )
	unsigned long                                      Alt : 1;                                          		// 0x0018 (0x0004) [0x0000000000004000] [0x00000004] ( CPF_Config )
	unsigned long                                      bIgnoreCtrl : 1;                                  		// 0x0018 (0x0004) [0x0000000000004000] [0x00000008] ( CPF_Config )
	unsigned long                                      bIgnoreShift : 1;                                 		// 0x0018 (0x0004) [0x0000000000004000] [0x00000010] ( CPF_Config )
	unsigned long                                      bIgnoreAlt : 1;                                   		// 0x0018 (0x0004) [0x0000000000004000] [0x00000020] ( CPF_Config )
};

// ScriptStruct Engine.Input.TouchTracker
// 0x00000018
struct FTouchTracker
{
//	 vPoperty_Size=5
	int                                                Handle;                                           		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                TouchpadIndex;                                    		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FVector2D                                   Location;                                         		// 0x0008 (0x0008) [0x0000000000000000]              
	unsigned char                                      EventType;                                        		// 0x0010 (0x0001) [0x0000000000000000]              
	unsigned long                                      bTrapInput : 1;                                   		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.InstancedStaticMeshComponent.InstancedStaticMeshInstanceData
// 0x00000050
struct FInstancedStaticMeshInstanceData
{
//	 vPoperty_Size=3
	struct FMatrix                                     Transform;                                        		// 0x0000 (0x0040) [0x0000000000000000]              
	struct FVector2D                                   LightmapUVBias;                                   		// 0x0040 (0x0008) [0x0000000000000000]              
	struct FVector2D                                   ShadowmapUVBias;                                  		// 0x0048 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.InstancedStaticMeshComponent.InstancedStaticMeshMappingInfo
// 0x00000020
struct FInstancedStaticMeshMappingInfo
{
//	 vPoperty_Size=4
	struct FPointer                                    Mapping;                                          		// 0x0000 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    LightMap;                                         		// 0x0008 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UTexture2D*                                  LightmapTexture;                                  		// 0x0010 (0x0008) [0x0000000000000000]              
	class UShadowMap2D*                                ShadowmapTexture;                                 		// 0x0018 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpActor.CheckpointRecord
// 0x00000020
struct AInterpActor_FCheckpointRecord
{
//	 vPoperty_Size=6
	struct FVector                                     Location;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FRotator                                    Rotation;                                         		// 0x000C (0x000C) [0x0000000000000000]              
	unsigned char                                      CollisionType;                                    		// 0x0018 (0x0001) [0x0000000000000000]              
	unsigned long                                      bHidden : 1;                                      		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bIsShutdown : 1;                                  		// 0x001C (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bNeedsPositionReplication : 1;                    		// 0x001C (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct Engine.InterpCurveEdSetup.CurveEdEntry
// 0x00000034
struct FCurveEdEntry
{
//	 vPoperty_Size=9
	class UObject*                                     CurveObject;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FColor                                      CurveColor;                                       		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FString                                     CurveName;                                        		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                bHideCurve;                                       		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                bColorCurve;                                      		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                bFloatingPointColorCurve;                         		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                bClamp;                                           		// 0x0028 (0x0004) [0x0000000000000000]              
	float                                              ClampLow;                                         		// 0x002C (0x0004) [0x0000000000000000]              
	float                                              ClampHigh;                                        		// 0x0030 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpCurveEdSetup.CurveEdTab
// 0x00000030
struct FCurveEdTab
{
//	 vPoperty_Size=6
	struct FString                                     TabName;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FCurveEdEntry >                     Curves;                                           		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              ViewStartInput;                                   		// 0x0020 (0x0004) [0x0000000000000000]              
	float                                              ViewEndInput;                                     		// 0x0024 (0x0004) [0x0000000000000000]              
	float                                              ViewStartOutput;                                  		// 0x0028 (0x0004) [0x0000000000000000]              
	float                                              ViewEndOutput;                                    		// 0x002C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpData.AnimSetBakeAndPruneStatus
// 0x00000014
struct FAnimSetBakeAndPruneStatus
{
//	 vPoperty_Size=4
	struct FString                                     AnimSetName;                                      		// 0x0000 (0x0010) [0x0000000000420001]              ( CPF_Edit | CPF_EditConst | CPF_NeedCtorLink )
	unsigned long                                      bReferencedButUnused : 1;                         		// 0x0010 (0x0004) [0x0000000000020001] [0x00000001] ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bSkipBakeAndPrune : 1;                            		// 0x0010 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bSkipCooking : 1;                                 		// 0x0010 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
};

// ScriptStruct Engine.InterpGroup.InterpEdSelKey
// 0x00000018
struct FInterpEdSelKey
{
//	 vPoperty_Size=4
	class UInterpGroup*                                Group;                                            		// 0x0000 (0x0008) [0x0000000000000000]              
	class UInterpTrack*                                Track;                                            		// 0x0008 (0x0008) [0x0000000000000000]              
	int                                                KeyIndex;                                         		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              UnsnappedPosition;                                		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpGroupCamera.CameraPreviewInfo
// 0x00000040
struct FCameraPreviewInfo
{
//	 vPoperty_Size=6
	class UClass*                                      PawnClass;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UAnimSet* >                          PreviewAnimSets;                                  		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FName                                       AnimSeqName;                                      		// 0x0018 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Location;                                         		// 0x0020 (0x000C) [0x0000000000020000]              ( CPF_EditConst )
	struct FRotator                                    Rotation;                                         		// 0x002C (0x000C) [0x0000000000020000]              ( CPF_EditConst )
	class APawn*                                       PawnInst;                                         		// 0x0038 (0x0008) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.InterpTrack.SupportedSubTrackInfo
// 0x0000001C
struct FSupportedSubTrackInfo
{
//	 vPoperty_Size=3
	class UClass*                                      SupportedClass;                                   		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     SubTrackName;                                     		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                GroupIndex;                                       		// 0x0018 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpTrack.SubTrackGroup
// 0x00000024
struct FSubTrackGroup
{
//	 vPoperty_Size=4
	struct FString                                     GroupName;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< int >                                      TrackIndices;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bIsCollapsed : 1;                                 		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bIsSelected : 1;                                  		// 0x0020 (0x0004) [0x0000000000002000] [0x00000002] ( CPF_Transient )
};

// ScriptStruct Engine.InterpTrackAnimControl.AnimControlTrackKey
// 0x0000001C
struct FAnimControlTrackKey
{
//	 vPoperty_Size=7
	float                                              StartTime;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FName                                       AnimSeqName;                                      		// 0x0004 (0x0008) [0x0000000000000000]              
	float                                              AnimStartOffset;                                  		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              AnimEndOffset;                                    		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              AnimPlayRate;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	unsigned long                                      bLooping : 1;                                     		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bReverse : 1;                                     		// 0x0018 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct Engine.InterpTrackBoolProp.BoolTrackKey
// 0x00000008
struct FBoolTrackKey
{
//	 vPoperty_Size=2
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned long                                      Value : 1;                                        		// 0x0004 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.InterpTrackDirector.DirectorTrackCut
// 0x00000014
struct FDirectorTrackCut
{
//	 vPoperty_Size=4
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              TransitionTime;                                   		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FName                                       TargetCamGroup;                                   		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                ShotNumber;                                       		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpTrackEvent.EventTrackKey
// 0x0000000C
struct FEventTrackKey
{
//	 vPoperty_Size=2
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FName                                       EventName;                                        		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.InterpTrackFaceFX.FaceFXTrackKey
// 0x00000024
struct FFaceFXTrackKey
{
//	 vPoperty_Size=3
	float                                              StartTime;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     FaceFXGroupName;                                  		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     FaceFXSeqName;                                    		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.InterpTrackFaceFX.FaceFXSoundCueKey
// 0x00000010
struct FFaceFXSoundCueKey
{
//	 vPoperty_Size=2
	class USoundCue*                                   FaceFXSoundCue;                                   		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	class UAkEvent*                                    FaceFXAkEvent;                                    		// 0x0008 (0x0008) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.InterpTrackHeadTracking.HeadTrackingKey
// 0x00000005
struct FHeadTrackingKey
{
//	 vPoperty_Size=2
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      Action;                                           		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.InterpTrackInstFloatMaterialParam.FloatMaterialParamMICData
// 0x00000020
struct FFloatMaterialParamMICData
{
//	 vPoperty_Size=2
	TArray< class UMaterialInstanceConstant* >         MICs;                                             		// 0x0000 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< float >                                    MICResetFloats;                                   		// 0x0010 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
};

// ScriptStruct Engine.InterpTrackToggle.ToggleTrackKey
// 0x00000005
struct FToggleTrackKey
{
//	 vPoperty_Size=2
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      ToggleAction;                                     		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.InterpTrackInstVectorMaterialParam.VectorMaterialParamMICData
// 0x00000020
struct FVectorMaterialParamMICData
{
//	 vPoperty_Size=2
	TArray< class UMaterialInstanceConstant* >         MICs;                                             		// 0x0000 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< struct FVector >                           MICResetVectors;                                  		// 0x0010 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
};

// ScriptStruct Engine.InterpTrackVisibility.VisibilityTrackKey
// 0x00000006
struct FVisibilityTrackKey
{
//	 vPoperty_Size=3
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      Action;                                           		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      ActiveCondition;                                  		// 0x0005 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpTrackMove.InterpLookupPoint
// 0x0000000C
struct FInterpLookupPoint
{
//	 vPoperty_Size=2
	struct FName                                       GroupName;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              Time;                                             		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpTrackMove.InterpLookupTrack
// 0x00000010
struct FInterpLookupTrack
{
//	 vPoperty_Size=1
	TArray< struct FInterpLookupPoint >                Points;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.InterpTrackNotify.NotifyTrackKey
// 0x0000000C
struct FNotifyTrackKey
{
//	 vPoperty_Size=2
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	class UAnimNotify*                                 Notify;                                           		// 0x0004 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.InterpTrackParticleReplay.ParticleReplayTrackKey
// 0x0000000C
struct FParticleReplayTrackKey
{
//	 vPoperty_Size=3
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              Duration;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ClipIDNumber;                                     		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.InterpTrackSound.SoundTrackKey
// 0x00000014
struct FSoundTrackKey
{
//	 vPoperty_Size=4
	float                                              Time;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              Volume;                                           		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              Pitch;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
	class USoundCue*                                   Sound;                                            		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.LandscapeProxy.LandscapeWeightmapUsage
// 0x00000020
struct FLandscapeWeightmapUsage
{
//	 vPoperty_Size=1
	class ULandscapeComponent*                         ChannelUsage[ 0x4 ];                              		// 0x0000 (0x0020) [0x0000000004080008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
};

// ScriptStruct Engine.LandscapeProxy.LandscapeLayerStruct
// 0x00000030
struct FLandscapeLayerStruct
{
//	 vPoperty_Size=6
	class ULandscapeLayerInfoObject*                   LayerInfoObj;                                     		// 0x0000 (0x0008) [0x0000000000000000]              
	class UMaterialInstanceConstant*                   ThumbnailMIC;                                     		// 0x0008 (0x0008) [0x0000000000000000]              
	class ALandscapeProxy*                             Owner;                                            		// 0x0010 (0x0008) [0x0000000000000000]              
	int                                                DebugColorChannel;                                		// 0x0018 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	unsigned long                                      bSelected : 1;                                    		// 0x001C (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )
	struct FString                                     SourceFilePath;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.LandscapeProxy.H7CombatListLayerStruct
// 0x0008(0x0038 - 0x0030)
struct FH7CombatListLayerStruct : FLandscapeLayerStruct
{
//	 vPoperty_Size=1
	class UH7CombatListLayerInfoObject*                CombatListLayerInfoObj;                           		// 0x0030 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.LandscapeProxy.H7LandscapeGridInfoStruct
// 0x00000018
struct FH7LandscapeGridInfoStruct
{
//	 vPoperty_Size=4
	int                                                GridSizeX;                                        		// 0x0000 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	int                                                GridSizeY;                                        		// 0x0004 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	int                                                TileSize;                                         		// 0x0008 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	struct FVector                                     GridLocation;                                     		// 0x000C (0x000C) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.Landscape.LandscapeLayerInfo
// 0x00000038
struct FLandscapeLayerInfo
{
//	 vPoperty_Size=8
	struct FName                                       LayerName;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              Hardness;                                         		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bNoWeightBlend : 1;                               		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
	class UPhysicalMaterial*                           PhysMaterial;                                     		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInstanceConstant*                   ThumbnailMIC;                                     		// 0x0018 (0x0008) [0x0000000000000000]              
	unsigned long                                      bSelected : 1;                                    		// 0x0020 (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )
	int                                                DebugColorChannel;                                		// 0x0024 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	struct FString                                     LayerSourceFile;                                  		// 0x0028 (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
};

// ScriptStruct Engine.LandscapeComponent.WeightmapLayerAllocationInfo
// 0x0000000A
struct FWeightmapLayerAllocationInfo
{
//	 vPoperty_Size=3
	struct FName                                       LayerName;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      WeightmapTextureIndex;                            		// 0x0008 (0x0001) [0x0000000000000000]              
	unsigned char                                      WeightmapTextureChannel;                          		// 0x0009 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Engine.MaterialInstanceConstant.FontParameterValue
// 0x00000024
struct FFontParameterValue
{
//	 vPoperty_Size=4
	struct FName                                       ParameterName;                                    		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UFont*                                       FontValue;                                        		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                FontPage;                                         		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FGuid                                       ExpressionGUID;                                   		// 0x0014 (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.MaterialInstanceConstant.ScalarParameterValue
// 0x0000001C
struct FScalarParameterValue
{
//	 vPoperty_Size=3
	struct FName                                       ParameterName;                                    		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              ParameterValue;                                   		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FGuid                                       ExpressionGUID;                                   		// 0x000C (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.MaterialInstanceConstant.TextureParameterValue
// 0x00000020
struct FTextureParameterValue
{
//	 vPoperty_Size=3
	struct FName                                       ParameterName;                                    		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UTexture*                                    ParameterValue;                                   		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FGuid                                       ExpressionGUID;                                   		// 0x0010 (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.MaterialInstanceConstant.VectorParameterValue
// 0x00000028
struct FVectorParameterValue
{
//	 vPoperty_Size=3
	struct FName                                       ParameterName;                                    		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                ParameterValue;                                   		// 0x0008 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FGuid                                       ExpressionGUID;                                   		// 0x0018 (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.LandscapeGizmoActiveActor.GizmoSelectData
// 0x00000050
struct FGizmoSelectData
{
//	 vPoperty_Size=3
	float                                              Ratio;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              HeightData;                                       		// 0x0004 (0x0004) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x48 ];                            		// 0x0008 (0x0048) UNKNOWN PROPERTY: MapProperty Engine.LandscapeGizmoActiveActor.GizmoSelectData.WeightDataMap
};

// ScriptStruct Engine.LandscapeInfo.LandscapeAddCollision
// 0x00000030
struct FLandscapeAddCollision
{
//	 vPoperty_Size=1
	struct FVector                                     Corners[ 0x4 ];                                   		// 0x0000 (0x0030) [0x0000000000000000]              
};

// ScriptStruct Engine.LensFlare.LensFlareElementCurvePair
// 0x00000018
struct FLensFlareElementCurvePair
{
//	 vPoperty_Size=2
	struct FString                                     CurveName;                                        		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	class UObject*                                     CurveObject;                                      		// 0x0010 (0x0008) [0x0000000000100000]              
};

// ScriptStruct Engine.LensFlare.LensFlareElement
// 0x00000198
struct FLensFlareElement
{
//	 vPoperty_Size=13
	struct FName                                       ElementName;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              RayDistance;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bIsEnabled : 1;                                   		// 0x000C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bUseSourceDistance : 1;                           		// 0x000C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bNormalizeRadialDistance : 1;                     		// 0x000C (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bModulateColorBySource : 1;                       		// 0x000C (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	struct FVector                                     Size;                                             		// 0x0010 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UMaterialInterface* >                LFMaterials;                                      		// 0x001C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FRawDistributionFloat                       LFMaterialIndex;                                  		// 0x002C (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionFloat                       Scaling;                                          		// 0x0050 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionVector                      AxisScaling;                                      		// 0x0074 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionFloat                       Rotation;                                         		// 0x0098 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	unsigned long                                      bOrientTowardsSource : 1;                         		// 0x00BC (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FRawDistributionVector                      Color;                                            		// 0x00C0 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionFloat                       Alpha;                                            		// 0x00E4 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionVector                      Offset;                                           		// 0x0108 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionVector                      DistMap_Scale;                                    		// 0x012C (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionVector                      DistMap_Color;                                    		// 0x0150 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	struct FRawDistributionFloat                       DistMap_Alpha;                                    		// 0x0174 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
};

// ScriptStruct Engine.LensFlareComponent.LensFlareElementInstance
// 0x00000000
struct FLensFlareElementInstance
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.LensFlareComponent.LensFlareElementMaterials
// 0x00000010
struct FLensFlareElementMaterials
{
//	 vPoperty_Size=1
	TArray< class UMaterialInterface* >                ElementMaterials;                                 		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.LevelGridVolume.LevelGridCellCoordinate
// 0x0000000C
struct FLevelGridCellCoordinate
{
//	 vPoperty_Size=3
	int                                                X;                                                		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Y;                                                		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                Z;                                                		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.LevelStreamingVolume.CheckpointRecord
// 0x00000004
struct ALevelStreamingVolume_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bDisabled : 1;                                    		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.LocalPlayer.SynchronizedActorVisibilityHistory
// 0x00000010
struct FSynchronizedActorVisibilityHistory
{
//	 vPoperty_Size=2
	struct FPointer                                    State;                                            		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FPointer                                    CriticalSection;                                  		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.LocalPlayer.CurrentPostProcessVolumeInfo
// 0x00000170
struct FCurrentPostProcessVolumeInfo
{
//	 vPoperty_Size=4
	struct FPostProcessSettings                        LastSettings;                                     		// 0x0000 (0x0160) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class APostProcessVolume*                          LastVolumeUsed;                                   		// 0x0160 (0x0008) [0x0000000000000000]              
	float                                              BlendStartTime;                                   		// 0x0168 (0x0004) [0x0000000000000000]              
	float                                              LastBlendTime;                                    		// 0x016C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.LocalPlayer.PostProcessSettingsOverride
// 0x0000018C
struct FPostProcessSettingsOverride
{
//	 vPoperty_Size=9
	struct FPostProcessSettings                        Settings;                                         		// 0x0000 (0x0160) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bBlendingIn : 1;                                  		// 0x0160 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bBlendingOut : 1;                                 		// 0x0160 (0x0004) [0x0000000000000000] [0x00000002] 
	float                                              CurrentBlendInTime;                               		// 0x0164 (0x0004) [0x0000000000000000]              
	float                                              CurrentBlendOutTime;                              		// 0x0168 (0x0004) [0x0000000000000000]              
	float                                              BlendInDuration;                                  		// 0x016C (0x0004) [0x0000000000000000]              
	float                                              BlendOutDuration;                                 		// 0x0170 (0x0004) [0x0000000000000000]              
	float                                              BlendStartTime;                                   		// 0x0174 (0x0004) [0x0000000000000000]              
	struct FInterpCurveFloat                           TimeAlphaCurve;                                   		// 0x0178 (0x0014) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.MaterialExpression.ExpressionInput
// 0x00000034
struct FExpressionInput
{
//	 vPoperty_Size=9
	class UMaterialExpression*                         Expression;                                       		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                OutputIndex;                                      		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FString                                     InputName;                                        		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Mask;                                             		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                MaskR;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                MaskG;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                MaskB;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                MaskA;                                            		// 0x002C (0x0004) [0x0000000000000000]              
	int                                                GCC64_Padding;                                    		// 0x0030 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.MaterialExpression.ExpressionOutput
// 0x00000024
struct FExpressionOutput
{
//	 vPoperty_Size=6
	struct FString                                     OutputName;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Mask;                                             		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                MaskR;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                MaskG;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                MaskB;                                            		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                MaskA;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.MaterialExpressionCustom.CustomInput
// 0x00000044
struct FCustomInput
{
//	 vPoperty_Size=2
	struct FString                                     InputName;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FExpressionInput                            Input;                                            		// 0x0010 (0x0034) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.MaterialExpressionLandscapeLayerBlend.LayerBlendInput
// 0x00000080
struct FLayerBlendInput
{
//	 vPoperty_Size=6
	struct FName                                       LayerName;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      BlendType;                                        		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FExpressionInput                            LayerInput;                                       		// 0x000C (0x0034) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FExpressionInput                            HeightInput;                                      		// 0x0040 (0x0034) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              PreviewWeight;                                    		// 0x0074 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FPointer                                    InstanceOverride;                                 		// 0x0078 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
};

// ScriptStruct Engine.MaterialExpressionMaterialFunctionCall.FunctionExpressionInput
// 0x0000004C
struct FFunctionExpressionInput
{
//	 vPoperty_Size=3
	class UMaterialExpressionFunctionInput*            ExpressionInput;                                  		// 0x0000 (0x0008) [0x0000000000002000]              ( CPF_Transient )
	struct FGuid                                       ExpressionInputId;                                		// 0x0008 (0x0010) [0x0000000000000000]              
	struct FExpressionInput                            Input;                                            		// 0x0018 (0x0034) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.MaterialExpressionMaterialFunctionCall.FunctionExpressionOutput
// 0x0000003C
struct FFunctionExpressionOutput
{
//	 vPoperty_Size=3
	class UMaterialExpressionFunctionOutput*           ExpressionOutput;                                 		// 0x0000 (0x0008) [0x0000000000002000]              ( CPF_Transient )
	struct FGuid                                       ExpressionOutputId;                               		// 0x0008 (0x0010) [0x0000000000000000]              
	struct FExpressionOutput                           Output;                                           		// 0x0018 (0x0024) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.MaterialInstanceTimeVarying.ParameterValueOverTime
// 0x00000030
struct FParameterValueOverTime
{
//	 vPoperty_Size=9
	struct FGuid                                       ExpressionGUID;                                   		// 0x0000 (0x0010) [0x0000000000000000]              
	float                                              StartTime;                                        		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FName                                       ParameterName;                                    		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bLoop : 1;                                        		// 0x001C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bAutoActivate : 1;                                		// 0x001C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	float                                              CycleTime;                                        		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bNormalizeTime : 1;                               		// 0x0024 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              OffsetTime;                                       		// 0x0028 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bOffsetFromEnd : 1;                               		// 0x002C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.MaterialInstanceTimeVarying.FontParameterValueOverTime
// 0x000C(0x003C - 0x0030)
struct FFontParameterValueOverTime : FParameterValueOverTime
{
//	 vPoperty_Size=2
	class UFont*                                       FontValue;                                        		// 0x0030 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                FontPage;                                         		// 0x0038 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.MaterialInstanceTimeVarying.ScalarParameterValueOverTime
// 0x0018(0x0048 - 0x0030)
struct FScalarParameterValueOverTime : FParameterValueOverTime
{
//	 vPoperty_Size=2
	float                                              ParameterValue;                                   		// 0x0030 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FInterpCurveFloat                           ParameterValueCurve;                              		// 0x0034 (0x0014) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.MaterialInstanceTimeVarying.TextureParameterValueOverTime
// 0x0008(0x0038 - 0x0030)
struct FTextureParameterValueOverTime : FParameterValueOverTime
{
//	 vPoperty_Size=1
	class UTexture*                                    ParameterValue;                                   		// 0x0030 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.MaterialInstanceTimeVarying.VectorParameterValueOverTime
// 0x0024(0x0054 - 0x0030)
struct FVectorParameterValueOverTime : FParameterValueOverTime
{
//	 vPoperty_Size=2
	struct FLinearColor                                ParameterValue;                                   		// 0x0030 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FInterpCurveVector                          ParameterValueCurve;                              		// 0x0040 (0x0014) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.MaterialInstanceTimeVarying.LinearColorParameterValueOverTime
// 0x0024(0x0054 - 0x0030)
struct FLinearColorParameterValueOverTime : FParameterValueOverTime
{
//	 vPoperty_Size=2
	struct FLinearColor                                ParameterValue;                                   		// 0x0030 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FInterpCurveLinearColor                     ParameterValueCurve;                              		// 0x0040 (0x0014) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.MicroTransactionBase.PurchaseInfo
// 0x00000050
struct FPurchaseInfo
{
//	 vPoperty_Size=5
	struct FString                                     Identifier;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     DisplayName;                                      		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     DisplayDescription;                               		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     DisplayPrice;                                     		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     CurrencyType;                                     		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.MorphNodeWeightBase.MorphNodeConn
// 0x0000001C
struct FMorphNodeConn
{
//	 vPoperty_Size=3
	TArray< class UMorphNodeBase* >                    ChildNodes;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FName                                       ConnName;                                         		// 0x0010 (0x0008) [0x0000000000000000]              
	int                                                DrawY;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.MorphNodeWeightByBoneAngle.BoneAngleMorph
// 0x00000008
struct FBoneAngleMorph
{
//	 vPoperty_Size=2
	float                                              Angle;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              TargetWeight;                                     		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.NavigationHandle.PolySegmentSpan
// 0x00000020
struct FPolySegmentSpan
{
//	 vPoperty_Size=3
	struct FPointer                                    Poly;                                             		// 0x0000 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FVector                                     P1;                                               		// 0x0008 (0x000C) [0x0000000000000000]              
	struct FVector                                     P2;                                               		// 0x0014 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.NavigationHandle.EdgePointer
// 0x00000008
struct FEdgePointer
{
//	 vPoperty_Size=1
	struct FPointer                                    Dummy;                                            		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.NavigationHandle.PathStore
// 0x00000010
struct FPathStore
{
//	 vPoperty_Size=1
	TArray< struct FEdgePointer >                      EdgeList;                                         		// 0x0000 (0x0010) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct Engine.NavigationHandle.NavMeshPathParams
// 0x00000034
struct FNavMeshPathParams
{
//	 vPoperty_Size=a
	struct FPointer                                    Interface;                                        		// 0x0000 (0x0008) [0x0000000000001000]              ( CPF_Native )
	unsigned long                                      bCanMantle : 1;                                   		// 0x0008 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bNeedsMantleValidityTest : 1;                     		// 0x0008 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bAbleToSearch : 1;                                		// 0x0008 (0x0004) [0x0000000000000000] [0x00000004] 
	struct FVector                                     SearchExtent;                                     		// 0x000C (0x000C) [0x0000000000000000]              
	float                                              SearchLaneMultiplier;                             		// 0x0018 (0x0004) [0x0000000000000000]              
	struct FVector                                     SearchStart;                                      		// 0x001C (0x000C) [0x0000000000000000]              
	float                                              MaxDropHeight;                                    		// 0x0028 (0x0004) [0x0000000000000000]              
	float                                              MinWalkableZ;                                     		// 0x002C (0x0004) [0x0000000000000000]              
	float                                              MaxHoverDistance;                                 		// 0x0030 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.NavMeshPathGoalEvaluator.BiasedGoalActor
// 0x0000000C
struct FBiasedGoalActor
{
//	 vPoperty_Size=2
	class AActor*                                      Goal;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                ExtraCost;                                        		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.NavMeshObstacle.CheckpointRecord
// 0x00000004
struct ANavMeshObstacle_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bEnabled : 1;                                     		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.OnlineMatchmakingStats.MMStats_Timer
// 0x0000000C
struct FMMStats_Timer
{
//	 vPoperty_Size=2
	unsigned long                                      bInProgress : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FDouble                                     MSecs;                                            		// 0x0004 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlinePlayerStorage.OnlineProfileSetting
// 0x0000001C
struct FOnlineProfileSetting
{
//	 vPoperty_Size=2
	unsigned char                                      Owner;                                            		// 0x0000 (0x0001) [0x0000000000000000]              
	struct FSettingsProperty                           ProfileSetting;                                   		// 0x0004 (0x0018) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineRecentPlayersList.RecentParty
// 0x00000018
struct FRecentParty
{
//	 vPoperty_Size=2
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	TArray< struct FUniqueNetId >                      PartyMembers;                                     		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineRecentPlayersList.CurrentPlayerMet
// 0x00000010
struct FCurrentPlayerMet
{
//	 vPoperty_Size=3
	int                                                TeamNum;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Skill;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FUniqueNetId                                NetId;                                            		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineStatsRead.OnlineStatsColumn
// 0x00000014
struct FOnlineStatsColumn
{
//	 vPoperty_Size=2
	int                                                ColumnNo;                                         		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FSettingsData                               StatValue;                                        		// 0x0004 (0x0010) [0x0000000000000000]              
};

// ScriptStruct Engine.OnlineStatsRead.OnlineStatsRow
// 0x00000038
struct FOnlineStatsRow
{
//	 vPoperty_Size=4
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FSettingsData                               Rank;                                             		// 0x0008 (0x0010) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     NickName;                                         		// 0x0018 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< struct FOnlineStatsColumn >                Columns;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.OnlineStatsRead.ColumnMetaData
// 0x0000001C
struct FColumnMetaData
{
//	 vPoperty_Size=3
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FName                                       Name;                                             		// 0x0004 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     ColumnName;                                       		// 0x000C (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ParticleEmitter.ParticleBurst
// 0x0000000C
struct FParticleBurst
{
//	 vPoperty_Size=3
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                CountLow;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Time;                                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ParticleModule.ParticleCurvePair
// 0x00000018
struct FParticleCurvePair
{
//	 vPoperty_Size=2
	struct FString                                     CurveName;                                        		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	class UObject*                                     CurveObject;                                      		// 0x0010 (0x0008) [0x0000000000100000]              
};

// ScriptStruct Engine.ParticleModule.ParticleRandomSeedInfo
// 0x0000001C
struct FParticleRandomSeedInfo
{
//	 vPoperty_Size=6
	struct FName                                       ParameterName;                                    		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bGetSeedFromInstance : 1;                         		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bInstanceSeedIsIndex : 1;                         		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bResetSeedOnEmitterLooping : 1;                   		// 0x0008 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bRandomlySelectSeedArray : 1;                     		// 0x0008 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	TArray< int >                                      RandomSeeds;                                      		// 0x000C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ParticleModuleAttractorBoneSocket.AttractLocationBoneSocketInfo
// 0x00000014
struct FAttractLocationBoneSocketInfo
{
//	 vPoperty_Size=2
	struct FName                                       BoneSocketName;                                   		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Offset;                                           		// 0x0008 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ParticleModuleBeamModifier.BeamModifierOptions
// 0x00000004
struct FBeamModifierOptions
{
//	 vPoperty_Size=3
	unsigned long                                      bModify : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bScale : 1;                                       		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bLock : 1;                                        		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
};

// ScriptStruct Engine.ParticleModuleCollision.ParticleAttractorCollisionAction
// 0x00000014
struct FParticleAttractorCollisionAction
{
//	 vPoperty_Size=2
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     EventName;                                        		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ParticleModuleEventGenerator.ParticleEvent_GenerateInfo
// 0x0000002C
struct FParticleEvent_GenerateInfo
{
//	 vPoperty_Size=9
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                Frequency;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                LowFreq;                                          		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ParticleFrequency;                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      FirstTimeOnly : 1;                                		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      LastTimeOnly : 1;                                 		// 0x0010 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      UseReflectedImpactVector : 1;                     		// 0x0010 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	struct FName                                       CustomName;                                       		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UParticleModuleEventSendToGame* >    ParticleModuleEventsToSendToGame;                 		// 0x001C (0x0010) [0x0000000004400001]              ( CPF_Edit | CPF_NeedCtorLink | CPF_EditInline )
};

// ScriptStruct Engine.ParticleModuleLocationBoneSocket.LocationBoneSocketInfo
// 0x00000014
struct FLocationBoneSocketInfo
{
//	 vPoperty_Size=2
	struct FName                                       BoneSocketName;                                   		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Offset;                                           		// 0x0008 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ParticleModuleOrbit.OrbitOptions
// 0x00000004
struct FOrbitOptions
{
//	 vPoperty_Size=3
	unsigned long                                      bProcessDuringSpawn : 1;                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bProcessDuringUpdate : 1;                         		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bUseEmitterTime : 1;                              		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
};

// ScriptStruct Engine.ParticleModuleParameterDynamic.EmitterDynamicParameter
// 0x00000038
struct FEmitterDynamicParameter
{
//	 vPoperty_Size=6
	struct FName                                       ParamName;                                        		// 0x0000 (0x0008) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	unsigned long                                      bUseEmitterTime : 1;                              		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bSpawnTimeOnly : 1;                               		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      ValueMethod;                                      		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bScaleVelocityByParamValue : 1;                   		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FRawDistributionFloat                       ParamValue;                                       		// 0x0014 (0x0024) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ParticleModuleTypeDataBeam2.BeamTargetData
// 0x0000000C
struct FBeamTargetData
{
//	 vPoperty_Size=2
	struct FName                                       TargetName;                                       		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              TargetPercentage;                                 		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ParticleModuleTypeDataPhysX.PhysXEmitterVerticalLodProperties
// 0x00000010
struct FPhysXEmitterVerticalLodProperties
{
//	 vPoperty_Size=4
	float                                              WeightForFifo;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              WeightForSpawnLod;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              SpawnLodRateVsLifeBias;                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              RelativeFadeoutTime;                              		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ParticleSystem.ParticleSystemLOD
// 0x00000004
struct FParticleSystemLOD
{
//	 vPoperty_Size=1
	unsigned long                                      bLit : 1;                                         		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.ParticleSystem.LODSoloTrack
// 0x00000010
struct FLODSoloTrack
{
//	 vPoperty_Size=1
	TArray< unsigned char >                            SoloEnableSetting;                                		// 0x0000 (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ParticleSystemReplay.ParticleEmitterReplayFrame
// 0x00000010
struct FParticleEmitterReplayFrame
{
//	 vPoperty_Size=3
	int                                                EmitterType;                                      		// 0x0000 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                OriginalEmitterIndex;                             		// 0x0004 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    FrameState;                                       		// 0x0008 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.ParticleSystemReplay.ParticleSystemReplayFrame
// 0x00000010
struct FParticleSystemReplayFrame
{
//	 vPoperty_Size=1
	TArray< struct FParticleEmitterReplayFrame >       Emitters;                                         		// 0x0000 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.PBRuleNodeBase.PBRuleLink
// 0x00000014
struct FPBRuleLink
{
//	 vPoperty_Size=3
	class UPBRuleNodeBase*                             NextRule;                                         		// 0x0000 (0x0008) [0x0000000004400009]              ( CPF_Edit | CPF_ExportObject | CPF_NeedCtorLink | CPF_EditInline )
	struct FName                                       LinkName;                                         		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                DrawY;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.ProcBuilding.PBMaterialParam
// 0x00000018
struct FPBMaterialParam
{
//	 vPoperty_Size=2
	struct FName                                       ParamName;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                Color;                                            		// 0x0008 (0x0010) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.ProcBuildingRuleset.PBParamSwatch
// 0x00000018
struct FPBParamSwatch
{
//	 vPoperty_Size=2
	struct FName                                       SwatchName;                                       		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FPBMaterialParam >                  Params;                                           		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.ProcBuildingRuleset.PBVariationInfo
// 0x0000000C
struct FPBVariationInfo
{
//	 vPoperty_Size=2
	struct FName                                       VariationName;                                    		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bMeshOnTopOfFacePoly : 1;                         		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct Engine.ProcBuilding.PBFracMeshCompInfo
// 0x0000000C
struct FPBFracMeshCompInfo
{
//	 vPoperty_Size=2
	class UFracturedStaticMeshComponent*               FracMeshComp;                                     		// 0x0000 (0x0008) [0x0000000004080008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
	int                                                TopLevelScopeIndex;                               		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.ProcBuilding.PBFaceUVInfo
// 0x00000010
struct FPBFaceUVInfo
{
//	 vPoperty_Size=2
	struct FVector2D                                   Offset;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FVector2D                                   Size;                                             		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.ProcBuilding.PBMemUsageInfo
// 0x0000002C
struct FPBMemUsageInfo
{
//	 vPoperty_Size=9
	class AProcBuilding*                               Building;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	class UProcBuildingRuleset*                        Ruleset;                                          		// 0x0008 (0x0008) [0x0000000000000000]              
	int                                                NumStaticMeshComponent;                           		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                NumInstancedStaticMeshComponents;                 		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                NumInstancedTris;                                 		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                LightmapMemBytes;                                 		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                ShadowmapMemBytes;                                		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                LODDiffuseMemBytes;                               		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                LODLightingMemBytes;                              		// 0x0028 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.ProcBuilding.PBMeshCompInfo
// 0x0000000C
struct FPBMeshCompInfo
{
//	 vPoperty_Size=2
	class UStaticMeshComponent*                        MeshComp;                                         		// 0x0000 (0x0008) [0x0000000004080008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
	int                                                TopLevelScopeIndex;                               		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.ProcBuilding.PBScopeProcessInfo
// 0x0000001C
struct FPBScopeProcessInfo
{
//	 vPoperty_Size=5
	class AProcBuilding*                               OwningBuilding;                                   		// 0x0000 (0x0008) [0x0000000000000000]              
	class UProcBuildingRuleset*                        Ruleset;                                          		// 0x0008 (0x0008) [0x0000000000000000]              
	struct FName                                       RulesetVariation;                                 		// 0x0010 (0x0008) [0x0000000000000000]              
	unsigned long                                      bGenerateLODPoly : 1;                             		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bPartOfNonRect : 1;                               		// 0x0018 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct Engine.ProcBuilding.PBScope2D
// 0x00000048
struct FPBScope2D
{
//	 vPoperty_Size=3
	struct FMatrix                                     ScopeFrame;                                       		// 0x0000 (0x0040) [0x0000000000000000]              
	float                                              DimX;                                             		// 0x0040 (0x0004) [0x0000000000000000]              
	float                                              DimZ;                                             		// 0x0044 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.ProcBuilding.PBEdgeInfo
// 0x0000002C
struct FPBEdgeInfo
{
//	 vPoperty_Size=7
	struct FVector                                     EdgeEnd;                                          		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector                                     EdgeStart;                                        		// 0x000C (0x000C) [0x0000000000000000]              
	int                                                ScopeAIndex;                                      		// 0x0018 (0x0004) [0x0000000000000000]              
	unsigned char                                      ScopeAEdge;                                       		// 0x001C (0x0001) [0x0000000000000000]              
	int                                                ScopeBIndex;                                      		// 0x0020 (0x0004) [0x0000000000000000]              
	unsigned char                                      ScopeBEdge;                                       		// 0x0024 (0x0001) [0x0000000000000000]              
	float                                              EdgeAngle;                                        		// 0x0028 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.PBRuleNodeCorner.RBCornerAngleInfo
// 0x00000008
struct FRBCornerAngleInfo
{
//	 vPoperty_Size=2
	float                                              Angle;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              CornerSize;                                       		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.PBRuleNodeEdgeAngle.RBEdgeAngleInfo
// 0x00000004
struct FRBEdgeAngleInfo
{
//	 vPoperty_Size=1
	float                                              Angle;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.PBRuleNodeMesh.BuildingMatOverrides
// 0x00000010
struct FBuildingMatOverrides
{
//	 vPoperty_Size=1
	TArray< class UMaterialInterface* >                MaterialOptions;                                  		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.PBRuleNodeMesh.BuildingMeshInfo
// 0x0000004C
struct FBuildingMeshInfo
{
//	 vPoperty_Size=b
	class UStaticMesh*                                 Mesh;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              DimX;                                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              DimZ;                                             		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Chance;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UDistributionVector*                         Translation;                                      		// 0x0014 (0x0008) [0x0000000004080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_EditInline )
	class UDistributionVector*                         Rotation;                                         		// 0x001C (0x0008) [0x0000000004080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_EditInline )
	unsigned long                                      bMeshScaleTranslation : 1;                        		// 0x0024 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bOverrideMeshLightMapRes : 1;                     		// 0x0024 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	int                                                OverriddenMeshLightMapRes;                        		// 0x0028 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UMaterialInterface* >                MaterialOverrides;                                		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FBuildingMatOverrides >             SectionOverrides;                                 		// 0x003C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.PBRuleNodeSplit.RBSplitInfo
// 0x00000014
struct FRBSplitInfo
{
//	 vPoperty_Size=4
	unsigned long                                      bFixSize : 1;                                     		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              FixedSize;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ExpandRatio;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       SplitName;                                        		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.PointLightToggleable.CheckpointRecord
// 0x00000004
struct APointLightToggleable_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bEnabled : 1;                                     		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.Sequence.ActivateOp
// 0x00000018
struct FActivateOp
{
//	 vPoperty_Size=4
	class USequenceOp*                                 ActivatorOp;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	class USequenceOp*                                 Op;                                               		// 0x0008 (0x0008) [0x0000000000000000]              
	int                                                InputIdx;                                         		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              RemainingDelay;                                   		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Sequence.QueuedActivationInfo
// 0x0000002C
struct FQueuedActivationInfo
{
//	 vPoperty_Size=5
	class USequenceEvent*                              ActivatedEvent;                                   		// 0x0000 (0x0008) [0x0000000000000000]              
	class AActor*                                      InOriginator;                                     		// 0x0008 (0x0008) [0x0000000000000000]              
	class AActor*                                      InInstigator;                                     		// 0x0010 (0x0008) [0x0000000000000000]              
	TArray< int >                                      ActivateIndices;                                  		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bPushTop : 1;                                     		// 0x0028 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.RB_BodySetup.KCachedConvexDataElement
// 0x00000010
struct FKCachedConvexDataElement
{
//	 vPoperty_Size=1
	TArray< unsigned char >                            ConvexElementData;                                		// 0x0000 (0x0010) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct Engine.RB_BodySetup.KCachedConvexData
// 0x00000010
struct FKCachedConvexData
{
//	 vPoperty_Size=1
	TArray< struct FKCachedConvexDataElement >         CachedConvexElements;                             		// 0x0000 (0x0010) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct Engine.RB_ConstraintSetup.LinearDOFSetup
// 0x00000008
struct FLinearDOFSetup
{
//	 vPoperty_Size=2
	unsigned char                                      bLimited;                                         		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              LimitSize;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SeqAct_Interp.SavedTransform
// 0x00000018
struct FSavedTransform
{
//	 vPoperty_Size=2
	struct FVector                                     Location;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FRotator                                    Rotation;                                         		// 0x000C (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.SeqAct_Interp.CameraCutInfo
// 0x00000010
struct FCameraCutInfo
{
//	 vPoperty_Size=2
	struct FVector                                     Location;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	float                                              TimeStamp;                                        		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.SeqAct_MultiLevelStreaming.LevelStreamingNameCombo
// 0x00000010
struct FLevelStreamingNameCombo
{
//	 vPoperty_Size=2
	class ULevelStreaming*                             Level;                                            		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FName                                       LevelName;                                        		// 0x0008 (0x0008) [0x0000000000000003]              ( CPF_Edit | CPF_Const )
};

// ScriptStruct Engine.SeqAct_RangeSwitch.SwitchRange
// 0x00000008
struct FSwitchRange
{
//	 vPoperty_Size=2
	int                                                Min;                                              		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Max;                                              		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.WorldAttractor.WorldAttractorData
// 0x00000020
struct FWorldAttractorData
{
//	 vPoperty_Size=6
	unsigned long                                      bEnabled : 1;                                     		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FVector                                     Location;                                         		// 0x0004 (0x000C) [0x0000000000000000]              
	unsigned char                                      FalloffType;                                      		// 0x0010 (0x0001) [0x0000000000000000]              
	float                                              FalloffExponent;                                  		// 0x0014 (0x0004) [0x0000000000000000]              
	float                                              Range;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	float                                              Strength;                                         		// 0x001C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.SeqCond_SwitchClass.SwitchClassInfo
// 0x00000009
struct FSwitchClassInfo
{
//	 vPoperty_Size=2
	struct FName                                       ClassName;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      bFallThru;                                        		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SeqCond_SwitchObject.SwitchObjectCase
// 0x0000000C
struct FSwitchObjectCase
{
//	 vPoperty_Size=3
	class UObject*                                     ObjectValue;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bFallThru : 1;                                    		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bDefaultValue : 1;                                		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct Engine.SkeletalMesh.SoftBodySpecialBoneInfo
// 0x0000001C
struct FSoftBodySpecialBoneInfo
{
//	 vPoperty_Size=3
	struct FName                                       BoneName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      BoneType;                                         		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< int >                                      AttachedVertexIndices;                            		// 0x000C (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
};

// ScriptStruct Engine.SkeletalMesh.SoftBodyTetraLink
// 0x00000010
struct FSoftBodyTetraLink
{
//	 vPoperty_Size=2
	int                                                Index;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FVector                                     Bary;                                             		// 0x0004 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.SkeletalMesh.ClothSpecialBoneInfo
// 0x0000001C
struct FClothSpecialBoneInfo
{
//	 vPoperty_Size=3
	struct FName                                       BoneName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      BoneType;                                         		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< int >                                      AttachedVertexIndices;                            		// 0x000C (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
};

// ScriptStruct Engine.SkeletalMesh.SkeletalMeshOptimizationSettings
// 0x00000028
struct FSkeletalMeshOptimizationSettings
{
//	 vPoperty_Size=d
	float                                              MaxDeviationPercentage;                           		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      SilhouetteImportance;                             		// 0x0004 (0x0001) [0x0000000000000000]              
	unsigned char                                      TextureImportance;                                		// 0x0005 (0x0001) [0x0000000000000000]              
	unsigned char                                      ShadingImportance;                                		// 0x0006 (0x0001) [0x0000000000000000]              
	unsigned char                                      SkinningImportance;                               		// 0x0007 (0x0001) [0x0000000000000000]              
	unsigned char                                      NormalMode;                                       		// 0x0008 (0x0001) [0x0000000020000000]              ( CPF_Deprecated )
	float                                              BoneReductionRatio;                               		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                MaxBonesPerVertex;                                		// 0x0010 (0x0004) [0x0000000000000000]              
	unsigned char                                      ReductionMethod;                                  		// 0x0014 (0x0001) [0x0000000000000000]              
	float                                              NumOfTrianglesPercentage;                         		// 0x0018 (0x0004) [0x0000000000000000]              
	float                                              WeldingThreshold;                                 		// 0x001C (0x0004) [0x0000000000000000]              
	unsigned long                                      bRecalcNormals : 1;                               		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              NormalsThreshold;                                 		// 0x0024 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.SkeletalMesh.TriangleSortSettings
// 0x0000000C
struct FTriangleSortSettings
{
//	 vPoperty_Size=3
	unsigned char                                      TriangleSorting;                                  		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      CustomLeftRightAxis;                              		// 0x0001 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       CustomLeftRightBoneName;                          		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SkeletalMesh.SkeletalMeshLODInfo
// 0x0000004C
struct FSkeletalMeshLODInfo
{
//	 vPoperty_Size=8
	float                                              DisplayFactor;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              LODHysteresis;                                    		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< int >                                      LODMaterialMap;                                   		// 0x0008 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	TArray< unsigned long >                            bEnableShadowCasting;                             		// 0x0018 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	TArray< unsigned char >                            TriangleSorting;                                  		// 0x0028 (0x0010) [0x0000000020400000]              ( CPF_NeedCtorLink | CPF_Deprecated )
	TArray< struct FTriangleSortSettings >             TriangleSortSettings;                             		// 0x0038 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	unsigned long                                      bDisableCompressions : 1;                         		// 0x0048 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bHasBeenSimplified : 1;                           		// 0x0048 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct Engine.SkeletalMesh.BoneMirrorExport
// 0x00000011
struct FBoneMirrorExport
{
//	 vPoperty_Size=3
	struct FName                                       BoneName;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       SourceBoneName;                                   		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      BoneFlipAxis;                                     		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SkeletalMesh.BoneMirrorInfo
// 0x00000005
struct FBoneMirrorInfo
{
//	 vPoperty_Size=2
	int                                                SourceIndex;                                      		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      BoneFlipAxis;                                     		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SkeletalMesh.ApexClothingLodInfo
// 0x00000010
struct FApexClothingLodInfo
{
//	 vPoperty_Size=1
	TArray< int >                                      ClothingSectionInfo;                              		// 0x0000 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
};

// ScriptStruct Engine.SkeletalMesh.ApexClothingAssetInfo
// 0x00000018
struct FApexClothingAssetInfo
{
//	 vPoperty_Size=2
	TArray< struct FApexClothingLodInfo >              ClothingLodInfo;                                  		// 0x0000 (0x0010) [0x0000000000400041]              ( CPF_Edit | CPF_EditConstArray | CPF_NeedCtorLink )
	struct FName                                       ClothingAssetName;                                		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.SkeletalMeshActor.CheckpointRecord
// 0x0000001C
struct ASkeletalMeshActor_FCheckpointRecord
{
//	 vPoperty_Size=5
	unsigned long                                      bReplicated : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bHidden : 1;                                      		// 0x0000 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bSavedPosition : 1;                               		// 0x0000 (0x0004) [0x0000000000000000] [0x00000004] 
	struct FVector                                     Location;                                         		// 0x0004 (0x000C) [0x0000000000000000]              
	struct FRotator                                    Rotation;                                         		// 0x0010 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Engine.SkeletalMeshActor.SkelMeshActorControlTarget
// 0x00000010
struct FSkelMeshActorControlTarget
{
//	 vPoperty_Size=2
	struct FName                                       ControlName;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AActor*                                      TargetActor;                                      		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SkeletalMeshActorBasedOnExtremeContent.SkelMaterialSetterDatum
// 0x0000000C
struct FSkelMaterialSetterDatum
{
//	 vPoperty_Size=2
	int                                                MaterialIndex;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInterface*                          TheMaterial;                                      		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SoundClass.SoundClassEditorData
// 0x00000008
struct FSoundClassEditorData
{
//	 vPoperty_Size=2
	int                                                NodePosX;                                         		// 0x0000 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                NodePosY;                                         		// 0x0004 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.SoundClass.SoundClassProperties
// 0x00000020
struct FSoundClassProperties
{
//	 vPoperty_Size=e
	float                                              Volume;                                           		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Pitch;                                            		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              StereoBleed;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              LFEBleed;                                         		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              VoiceCenterChannelVolume;                         		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              RadioFilterVolume;                                		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              RadioFilterVolumeThreshold;                       		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bApplyEffects : 1;                                		// 0x001C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bAlwaysPlay : 1;                                  		// 0x001C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bIsUISound : 1;                                   		// 0x001C (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bIsMusic : 1;                                     		// 0x001C (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      bReverb : 1;                                      		// 0x001C (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      bCenterChannelOnly : 1;                           		// 0x001C (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      bApplyAmbientVolumes : 1;                         		// 0x001C (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
};

// ScriptStruct Engine.SoundMode.AudioEQEffect
// 0x00000024
struct FAudioEQEffect
{
//	 vPoperty_Size=8
	struct FDouble                                     RootTime;                                         		// 0x0000 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	float                                              HFFrequency;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              HFGain;                                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MFCutoffFrequency;                                		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MFBandwidth;                                      		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MFGain;                                           		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              LFFrequency;                                      		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              LFGain;                                           		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SoundMode.SoundClassAdjuster
// 0x0000001C
struct FSoundClassAdjuster
{
//	 vPoperty_Size=6
	unsigned char                                      SoundClassName;                                   		// 0x0000 (0x0001) [0x0000000000002001]              ( CPF_Edit | CPF_Transient )
	struct FName                                       SoundClass;                                       		// 0x0004 (0x0008) [0x0000000000020001]              ( CPF_Edit | CPF_EditConst )
	float                                              VolumeAdjuster;                                   		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              PitchAdjuster;                                    		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bApplyToChildren : 1;                             		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              VoiceCenterChannelVolumeAdjuster;                 		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SoundNodeDistanceCrossFade.DistanceDatum
// 0x0000005C
struct FDistanceDatum
{
//	 vPoperty_Size=7
	float                                              FadeInDistanceStart;                              		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeInDistanceEnd;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeOutDistanceStart;                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeOutDistanceEnd;                               		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Volume;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FRawDistributionFloat                       FadeInDistance;                                   		// 0x0014 (0x0024) [0x0000000020480000]              ( CPF_Component | CPF_NeedCtorLink | CPF_Deprecated )
	struct FRawDistributionFloat                       FadeOutDistance;                                  		// 0x0038 (0x0024) [0x0000000020480000]              ( CPF_Component | CPF_NeedCtorLink | CPF_Deprecated )
};

// ScriptStruct Engine.SpeechRecognition.RecognisableWord
// 0x00000024
struct FRecognisableWord
{
//	 vPoperty_Size=3
	int                                                Id;                                               		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     ReferenceWord;                                    		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     PhoneticWord;                                     		// 0x0014 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct Engine.SpeechRecognition.RecogVocabulary
// 0x00000060
struct FRecogVocabulary
{
//	 vPoperty_Size=6
	TArray< struct FRecognisableWord >                 WhoDictionary;                                    		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FRecognisableWord >                 WhatDictionary;                                   		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FRecognisableWord >                 WhereDictionary;                                  		// 0x0020 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     VocabName;                                        		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            VocabData;                                        		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            WorkingVocabData;                                 		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.SpeechRecognition.RecogUserData
// 0x00000014
struct FRecogUserData
{
//	 vPoperty_Size=2
	int                                                ActiveVocabularies;                               		// 0x0000 (0x0004) [0x0000000000000000]              
	TArray< unsigned char >                            UserData;                                         		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.SpeedTreeComponent.SpeedTreeStaticLight
// 0x00000038
struct FSpeedTreeStaticLight
{
//	 vPoperty_Size=6
	struct FGuid                                       Guid;                                             		// 0x0000 (0x0010) [0x0000000000000002]              ( CPF_Const )
	class UShadowMap1D*                                BranchShadowMap;                                  		// 0x0010 (0x0008) [0x0000000000000002]              ( CPF_Const )
	class UShadowMap1D*                                FrondShadowMap;                                   		// 0x0018 (0x0008) [0x0000000000000002]              ( CPF_Const )
	class UShadowMap1D*                                LeafMeshShadowMap;                                		// 0x0020 (0x0008) [0x0000000000000002]              ( CPF_Const )
	class UShadowMap1D*                                LeafCardShadowMap;                                		// 0x0028 (0x0008) [0x0000000000000002]              ( CPF_Const )
	class UShadowMap1D*                                BillboardShadowMap;                               		// 0x0030 (0x0008) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Engine.SplineActor.SplineConnection
// 0x00000010
struct FSplineConnection
{
//	 vPoperty_Size=2
	class USplineComponent*                            SplineComponent;                                  		// 0x0000 (0x0008) [0x0000000004080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_EditInline )
	class ASplineActor*                                ConnectTo;                                        		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SplineMeshComponent.SplineMeshParams
// 0x00000058
struct FSplineMeshParams
{
//	 vPoperty_Size=a
	struct FVector                                     StartPos;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector                                     StartTangent;                                     		// 0x000C (0x000C) [0x0000000000000000]              
	struct FVector2D                                   StartScale;                                       		// 0x0018 (0x0008) [0x0000000000000000]              
	float                                              StartRoll;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
	struct FVector2D                                   StartOffset;                                      		// 0x0024 (0x0008) [0x0000000000000000]              
	struct FVector                                     EndPos;                                           		// 0x002C (0x000C) [0x0000000000000000]              
	struct FVector                                     EndTangent;                                       		// 0x0038 (0x000C) [0x0000000000000000]              
	struct FVector2D                                   EndScale;                                         		// 0x0044 (0x0008) [0x0000000000000000]              
	float                                              EndRoll;                                          		// 0x004C (0x0004) [0x0000000000000000]              
	struct FVector2D                                   EndOffset;                                        		// 0x0050 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.SpotLightToggleable.CheckpointRecord
// 0x00000004
struct ASpotLightToggleable_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bEnabled : 1;                                     		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.StaticMeshActorBasedOnExtremeContent.SMMaterialSetterDatum
// 0x0000000C
struct FSMMaterialSetterDatum
{
//	 vPoperty_Size=2
	int                                                MaterialIndex;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInterface*                          TheMaterial;                                      		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.SVehicle.VehicleState
// 0x0000004C
struct FVehicleState
{
//	 vPoperty_Size=7
	struct FRigidBodyState                             RBState;                                          		// 0x0000 (0x0040) [0x0000000000000000]              
	unsigned char                                      ServerBrake;                                      		// 0x0040 (0x0001) [0x0000000000000000]              
	unsigned char                                      ServerGas;                                        		// 0x0041 (0x0001) [0x0000000000000000]              
	unsigned char                                      ServerSteering;                                   		// 0x0042 (0x0001) [0x0000000000000000]              
	unsigned char                                      ServerRise;                                       		// 0x0043 (0x0001) [0x0000000000000000]              
	unsigned long                                      bServerHandbrake : 1;                             		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                ServerView;                                       		// 0x0048 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Terrain.TerrainHeight
// 0x00000000
struct FTerrainHeight
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.Terrain.TerrainInfoData
// 0x00000000
struct FTerrainInfoData
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.Terrain.TerrainWeightedMaterial
// 0x00000000
struct ATerrain_FTerrainWeightedMaterial
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.Terrain.TerrainLayer
// 0x00000038
struct FTerrainLayer
{
//	 vPoperty_Size=c
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class UTerrainLayerSetup*                          Setup;                                            		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                AlphaMapIndex;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	unsigned long                                      Highlighted : 1;                                  		// 0x001C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      WireframeHighlighted : 1;                         		// 0x001C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      Hidden : 1;                                       		// 0x001C (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	struct FColor                                      HighlightColor;                                   		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      WireframeColor;                                   		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                MinX;                                             		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                MinY;                                             		// 0x002C (0x0004) [0x0000000000000000]              
	int                                                MaxX;                                             		// 0x0030 (0x0004) [0x0000000000000000]              
	int                                                MaxY;                                             		// 0x0034 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Terrain.AlphaMap
// 0x00000000
struct FAlphaMap
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.Terrain.TerrainDecorationInstance
// 0x00000018
struct FTerrainDecorationInstance
{
//	 vPoperty_Size=5
	class UPrimitiveComponent*                         Component;                                        		// 0x0000 (0x0008) [0x0000000004080008]              ( CPF_ExportObject | CPF_Component | CPF_EditInline )
	float                                              X;                                                		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              Y;                                                		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              Scale;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                Yaw;                                              		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Terrain.TerrainDecoration
// 0x0000002C
struct FTerrainDecoration
{
//	 vPoperty_Size=7
	class UPrimitiveComponentFactory*                  Factory;                                          		// 0x0000 (0x0008) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
	float                                              MinScale;                                         		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MaxScale;                                         		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Density;                                          		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              SlopeRotationBlend;                               		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                RandSeed;                                         		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FTerrainDecorationInstance >        Instances;                                        		// 0x001C (0x0010) [0x0000000000480000]              ( CPF_Component | CPF_NeedCtorLink )
};

// ScriptStruct Engine.Terrain.TerrainDecoLayer
// 0x00000024
struct FTerrainDecoLayer
{
//	 vPoperty_Size=3
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FTerrainDecoration >                Decorations;                                      		// 0x0010 (0x0010) [0x0000000000480001]              ( CPF_Edit | CPF_Component | CPF_NeedCtorLink )
	int                                                AlphaMapIndex;                                    		// 0x0020 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.Terrain.TerrainMaterialResource
// 0x00000000
struct FTerrainMaterialResource
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.Terrain.CachedTerrainMaterialArray
// 0x00000010
struct FCachedTerrainMaterialArray
{
//	 vPoperty_Size=1
	TArray< struct FPointer >                          CachedMaterials;                                  		// 0x0000 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.Terrain.SelectedTerrainVertex
// 0x0000000C
struct FSelectedTerrainVertex
{
//	 vPoperty_Size=3
	int                                                X;                                                		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Y;                                                		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                Weight;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.TerrainComponent.TerrainPatchBounds
// 0x0000000C
struct FTerrainPatchBounds
{
//	 vPoperty_Size=3
	float                                              MinHeight;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              MaxHeight;                                        		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              MaxDisplacement;                                  		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.TerrainComponent.TerrainMaterialMask
// 0x0000000C
struct FTerrainMaterialMask
{
//	 vPoperty_Size=2
	struct FQWord                                      BitMask;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                NumBits;                                          		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Engine.TerrainComponent.TerrainBVTree
// 0x00000010
struct FTerrainBVTree
{
//	 vPoperty_Size=1
	TArray< int >                                      Nodes;                                            		// 0x0000 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Engine.TerrainLayerSetup.FilterLimit
// 0x00000010
struct FFilterLimit
{
//	 vPoperty_Size=4
	unsigned long                                      Enabled : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              Base;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              NoiseScale;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              NoiseAmount;                                      		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.TerrainLayerSetup.TerrainFilteredMaterial
// 0x00000058
struct FTerrainFilteredMaterial
{
//	 vPoperty_Size=9
	unsigned long                                      UseNoise : 1;                                     		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              NoiseScale;                                       		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              NoisePercent;                                     		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FFilterLimit                                MinHeight;                                        		// 0x000C (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FFilterLimit                                MaxHeight;                                        		// 0x001C (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FFilterLimit                                MinSlope;                                         		// 0x002C (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FFilterLimit                                MaxSlope;                                         		// 0x003C (0x0010) [0x0000000000000001]              ( CPF_Edit )
	float                                              Alpha;                                            		// 0x004C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UTerrainMaterial*                            Material;                                         		// 0x0050 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.TerrainWeightMapTexture.TerrainWeightedMaterial
// 0x00000000
struct UTerrainWeightMapTexture_FTerrainWeightedMaterial
{
//	 vPoperty_Size=0
};

// ScriptStruct Engine.Texture2DComposite.SourceTexture2DRegion
// 0x00000020
struct FSourceTexture2DRegion
{
//	 vPoperty_Size=7
	int                                                OffsetX;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                OffsetY;                                          		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                SizeX;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                SizeY;                                            		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                DestOffsetX;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                DestOffsetY;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
	class UTexture2D*                                  Texture2D;                                        		// 0x0018 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.Trigger.CheckpointRecord
// 0x00000004
struct ATrigger_FCheckpointRecord
{
//	 vPoperty_Size=1
	unsigned long                                      bCollideActors : 1;                               		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Engine.TriggerStreamingLevel.LevelStreamingData
// 0x0000000C
struct FLevelStreamingData
{
//	 vPoperty_Size=4
	unsigned long                                      bShouldBeLoaded : 1;                              		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bShouldBeVisible : 1;                             		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bShouldBlockOnLoad : 1;                           		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	class ULevelStreaming*                             Level;                                            		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Engine.UIDataProvider_OnlinePlayerStorage.PlayerStorageArrayProvider
// 0x0000000C
struct FPlayerStorageArrayProvider
{
//	 vPoperty_Size=2
	int                                                PlayerStorageId;                                  		// 0x0000 (0x0004) [0x0000000000000000]              
	class UUIDataProvider_OnlinePlayerStorageArray*    Provider;                                         		// 0x0004 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.UIDataStore_DynamicResource.DynamicResourceProviderDefinition
// 0x00000020
struct FDynamicResourceProviderDefinition
{
//	 vPoperty_Size=3
	struct FName                                       ProviderTag;                                      		// 0x0000 (0x0008) [0x0000000000004000]              ( CPF_Config )
	struct FString                                     ProviderClassName;                                		// 0x0008 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	class UClass*                                      ProviderClass;                                    		// 0x0018 (0x0008) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.UIDataStore_GameResource.GameResourceDataProvider
// 0x00000024
struct FGameResourceDataProvider
{
//	 vPoperty_Size=4
	struct FName                                       ProviderTag;                                      		// 0x0000 (0x0008) [0x0000000000004000]              ( CPF_Config )
	struct FString                                     ProviderClassName;                                		// 0x0008 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	unsigned long                                      bExpandProviders : 1;                             		// 0x0018 (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
	class UClass*                                      ProviderClass;                                    		// 0x001C (0x0008) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct Engine.UIDataStore_InputAlias.UIInputKeyData
// 0x0000001C
struct FUIInputKeyData
{
//	 vPoperty_Size=2
	struct FRawInputKeyEventData                       InputKeyData;                                     		// 0x0000 (0x000C) [0x0000000000004000]              ( CPF_Config )
	struct FString                                     ButtonFontMarkupString;                           		// 0x000C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
};

// ScriptStruct Engine.UIDataStore_InputAlias.UIDataStoreInputAlias
// 0x0000005C
struct FUIDataStoreInputAlias
{
//	 vPoperty_Size=2
	struct FName                                       AliasName;                                        		// 0x0000 (0x0008) [0x0000000000004000]              ( CPF_Config )
	struct FUIInputKeyData                             PlatformInputKeys[ 0x3 ];                         		// 0x0008 (0x0054) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
};

// ScriptStruct Engine.UIDataStore_OnlineGameSearch.GameSearchCfg
// 0x00000030
struct FGameSearchCfg
{
//	 vPoperty_Size=6
	class UClass*                                      GameSearchClass;                                  		// 0x0000 (0x0008) [0x0000000000000000]              
	class UClass*                                      DefaultGameSettingsClass;                         		// 0x0008 (0x0008) [0x0000000000000000]              
	class UClass*                                      SearchResultsProviderClass;                       		// 0x0010 (0x0008) [0x0000000000000000]              
	class UUIDataProvider_Settings*                    DesiredSettingsProvider;                          		// 0x0018 (0x0008) [0x0000000000000000]              
	class UOnlineGameSearch*                           Search;                                           		// 0x0020 (0x0008) [0x0000000000000000]              
	struct FName                                       SearchName;                                       		// 0x0028 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.UIDataStore_OnlineGameSettings.GameSettingsCfg
// 0x00000020
struct FGameSettingsCfg
{
//	 vPoperty_Size=4
	class UClass*                                      GameSettingsClass;                                		// 0x0000 (0x0008) [0x0000000000000000]              
	class UUIDataProvider_Settings*                    Provider;                                         		// 0x0008 (0x0008) [0x0000000000000000]              
	class UOnlineGameSettings*                         GameSettings;                                     		// 0x0010 (0x0008) [0x0000000000000000]              
	struct FName                                       SettingsName;                                     		// 0x0018 (0x0008) [0x0000000000000000]              
};

// ScriptStruct Engine.UIDataStore_OnlineStats.PlayerNickMetaData
// 0x00000018
struct FPlayerNickMetaData
{
//	 vPoperty_Size=2
	struct FName                                       PlayerNickName;                                   		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     PlayerNickColumnName;                             		// 0x0008 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
};

// ScriptStruct Engine.UIDataStore_OnlineStats.RankMetaData
// 0x00000018
struct FRankMetaData
{
//	 vPoperty_Size=2
	struct FName                                       RankName;                                         		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     RankColumnName;                                   		// 0x0008 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
};

// ScriptStruct Engine.UIDataStore_Registry.RegistryKeyValuePair
// 0x00000020
struct FRegistryKeyValuePair
{
//	 vPoperty_Size=2
	struct FString                                     Key;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Value;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.UIDataStore_StringAliasMap.UIMenuInputMap
// 0x00000020
struct FUIMenuInputMap
{
//	 vPoperty_Size=3
	struct FName                                       FieldName;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FName                                       Set;                                              		// 0x0008 (0x0008) [0x0000000000000000]              
	struct FString                                     MappedText;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct Engine.UIInteraction.UIKeyRepeatData
// 0x00000010
struct FUIKeyRepeatData
{
//	 vPoperty_Size=2
	struct FName                                       CurrentRepeatKey;                                 		// 0x0000 (0x0008) [0x0000000000100000]              
	struct FDouble                                     NextRepeatTime;                                   		// 0x0008 (0x0008) [0x0000000000100000]              
};

// ScriptStruct Engine.UIInteraction.UIAxisEmulationData
// 0x0004(0x0014 - 0x0010)
struct FUIAxisEmulationData : FUIKeyRepeatData
{
//	 vPoperty_Size=1
	unsigned long                                      bEnabled : 1;                                     		// 0x0010 (0x0004) [0x0000000000100000] [0x00000001] 
};

// ScriptStruct Engine.UISoundTheme.SoundEventMapping
// 0x00000010
struct FSoundEventMapping
{
//	 vPoperty_Size=2
	struct FName                                       SoundEventName;                                   		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class USoundCue*                                   SoundToPlay;                                      		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif