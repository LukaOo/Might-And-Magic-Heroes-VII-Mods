#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: Core_structs.h
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

// ScriptStruct Core.Object.Guid
// 0x00000010
struct FGuid
{
//	 vPoperty_Size=4
	int                                                A;                                                		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                B;                                                		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                C;                                                		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                D;                                                		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Core.Object.Pointer
// 0x00000008
struct FPointer
{
//	 vPoperty_Size=1
	int                                                Dummy;                                            		// 0x0000 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0004 (0x0004) MISSED OFFSET
};

// ScriptStruct Core.Object.Array_Mirror
// 0x00000010
struct FArray_Mirror
{
//	 vPoperty_Size=3
	struct FPointer                                    Data;                                             		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                ArrayNum;                                         		// 0x0008 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                ArrayMax;                                         		// 0x000C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.InlinePointerArray_Mirror
// 0x00000018
struct FInlinePointerArray_Mirror
{
//	 vPoperty_Size=2
	struct FPointer                                    InlineData;                                       		// 0x0000 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FArray_Mirror                               SecondaryData;                                    		// 0x0008 (0x0010) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Core.Object.Rotator
// 0x0000000C
struct FRotator
{
//	 vPoperty_Size=3
	int                                                Pitch;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Yaw;                                              		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Roll;                                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.Vector
// 0x0000000C
struct FVector
{
//	 vPoperty_Size=3
	float                                              X;                                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Y;                                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Z;                                                		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.Plane
// 0x0004(0x0010 - 0x000C)
struct FPlane : FVector
{
//	 vPoperty_Size=1
	float                                              W;                                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.Vector2D
// 0x00000008
struct FVector2D
{
//	 vPoperty_Size=2
	float                                              X;                                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Y;                                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.Vector4
// 0x00000010
struct FVector4
{
//	 vPoperty_Size=4
	float                                              X;                                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Y;                                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Z;                                                		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              W;                                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.LinearColor
// 0x00000010
struct FLinearColor
{
//	 vPoperty_Size=4
	float                                              R;                                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              G;                                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              B;                                                		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              A;                                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.Color
// 0x00000004
struct FColor
{
//	 vPoperty_Size=4
	unsigned char                                      B;                                                		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      G;                                                		// 0x0001 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      R;                                                		// 0x0002 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      A;                                                		// 0x0003 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.InterpCurvePointVector2D
// 0x0000001D
struct FInterpCurvePointVector2D
{
//	 vPoperty_Size=5
	float                                              InVal;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   OutVal;                                           		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   ArriveTangent;                                    		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   LeaveTangent;                                     		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InterpMode;                                       		// 0x001C (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.InterpCurveVector2D
// 0x00000011
struct FInterpCurveVector2D
{
//	 vPoperty_Size=2
	TArray< struct FInterpCurvePointVector2D >         Points;                                           		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      InterpMethod;                                     		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Core.Object.InterpCurvePointFloat
// 0x00000011
struct FInterpCurvePointFloat
{
//	 vPoperty_Size=5
	float                                              InVal;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              OutVal;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ArriveTangent;                                    		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              LeaveTangent;                                     		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InterpMode;                                       		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.InterpCurveFloat
// 0x00000011
struct FInterpCurveFloat
{
//	 vPoperty_Size=2
	TArray< struct FInterpCurvePointFloat >            Points;                                           		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      InterpMethod;                                     		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Core.Object.Cylinder
// 0x00000008
struct FCylinder
{
//	 vPoperty_Size=2
	float                                              Radius;                                           		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              Height;                                           		// 0x0004 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Core.Object.InterpCurvePointVector
// 0x00000029
struct FInterpCurvePointVector
{
//	 vPoperty_Size=5
	float                                              InVal;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     OutVal;                                           		// 0x0004 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     ArriveTangent;                                    		// 0x0010 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     LeaveTangent;                                     		// 0x001C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InterpMode;                                       		// 0x0028 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.InterpCurveVector
// 0x00000011
struct FInterpCurveVector
{
//	 vPoperty_Size=2
	TArray< struct FInterpCurvePointVector >           Points;                                           		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      InterpMethod;                                     		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Core.Object.Quat
// 0x00000010
struct FQuat
{
//	 vPoperty_Size=4
	float                                              X;                                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Y;                                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Z;                                                		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              W;                                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.Matrix
// 0x00000040
struct FMatrix
{
//	 vPoperty_Size=4
	struct FPlane                                      XPlane;                                           		// 0x0000 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FPlane                                      YPlane;                                           		// 0x0010 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FPlane                                      ZPlane;                                           		// 0x0020 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FPlane                                      WPlane;                                           		// 0x0030 (0x0010) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.BoxSphereBounds
// 0x0000001C
struct FBoxSphereBounds
{
//	 vPoperty_Size=3
	struct FVector                                     Origin;                                           		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     BoxExtent;                                        		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	float                                              SphereRadius;                                     		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.TwoVectors
// 0x00000018
struct FTwoVectors
{
//	 vPoperty_Size=2
	struct FVector                                     v1;                                               		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     v2;                                               		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.TAlphaBlend
// 0x00000015
struct FTAlphaBlend
{
//	 vPoperty_Size=6
	float                                              AlphaIn;                                          		// 0x0000 (0x0004) [0x0000000000000002]              ( CPF_Const )
	float                                              AlphaOut;                                         		// 0x0004 (0x0004) [0x0000000000000002]              ( CPF_Const )
	float                                              AlphaTarget;                                      		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              BlendTime;                                        		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              BlendTimeToGo;                                    		// 0x0010 (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned char                                      BlendType;                                        		// 0x0014 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.BoneAtom
// 0x00000020
struct FBoneAtom
{
//	 vPoperty_Size=3
	struct FQuat                                       Rotation;                                         		// 0x0000 (0x0010) [0x0000000000000000]              
	struct FVector                                     Translation;                                      		// 0x0010 (0x000C) [0x0000000000000000]              
	float                                              Scale;                                            		// 0x001C (0x0004) [0x0000000000000000]              
};

// ScriptStruct Core.Object.OctreeElementId
// 0x0000000C
struct FOctreeElementId
{
//	 vPoperty_Size=2
	struct FPointer                                    Node;                                             		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                ElementIndex;                                     		// 0x0008 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.RenderCommandFence
// 0x00000004
struct FRenderCommandFence
{
//	 vPoperty_Size=1
	int                                                NumPendingFences;                                 		// 0x0000 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.RawDistribution
// 0x0000001C
struct FRawDistribution
{
//	 vPoperty_Size=7
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned char                                      Op;                                               		// 0x0001 (0x0001) [0x0000000000000000]              
	unsigned char                                      LookupTableNumElements;                           		// 0x0002 (0x0001) [0x0000000000000000]              
	unsigned char                                      LookupTableChunkSize;                             		// 0x0003 (0x0001) [0x0000000000000000]              
	TArray< float >                                    LookupTable;                                      		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              LookupTableTimeScale;                             		// 0x0014 (0x0004) [0x0000000000000000]              
	float                                              LookupTableStartTime;                             		// 0x0018 (0x0004) [0x0000000000000000]              
};

// ScriptStruct Core.Object.InterpCurvePointLinearColor
// 0x00000035
struct FInterpCurvePointLinearColor
{
//	 vPoperty_Size=5
	float                                              InVal;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                OutVal;                                           		// 0x0004 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                ArriveTangent;                                    		// 0x0014 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                LeaveTangent;                                     		// 0x0024 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InterpMode;                                       		// 0x0034 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.InterpCurveLinearColor
// 0x00000011
struct FInterpCurveLinearColor
{
//	 vPoperty_Size=2
	TArray< struct FInterpCurvePointLinearColor >      Points;                                           		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      InterpMethod;                                     		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Core.Object.InterpCurvePointQuat
// 0x00000041
struct FInterpCurvePointQuat
{
//	 vPoperty_Size=5
	float                                              InVal;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnknownData00[ 0xC ];                             		// 0x0004 (0x000C) MISSED OFFSET
	struct FQuat                                       OutVal;                                           		// 0x0010 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FQuat                                       ArriveTangent;                                    		// 0x0020 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	struct FQuat                                       LeaveTangent;                                     		// 0x0030 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InterpMode;                                       		// 0x0040 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.InterpCurveQuat
// 0x00000011
struct FInterpCurveQuat
{
//	 vPoperty_Size=2
	TArray< struct FInterpCurvePointQuat >             Points;                                           		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      InterpMethod;                                     		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Core.Object.InterpCurvePointTwoVectors
// 0x0000004D
struct FInterpCurvePointTwoVectors
{
//	 vPoperty_Size=5
	float                                              InVal;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FTwoVectors                                 OutVal;                                           		// 0x0004 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	struct FTwoVectors                                 ArriveTangent;                                    		// 0x001C (0x0018) [0x0000000000000001]              ( CPF_Edit )
	struct FTwoVectors                                 LeaveTangent;                                     		// 0x0034 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      InterpMode;                                       		// 0x004C (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.InterpCurveTwoVectors
// 0x00000011
struct FInterpCurveTwoVectors
{
//	 vPoperty_Size=2
	TArray< struct FInterpCurvePointTwoVectors >       Points;                                           		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      InterpMethod;                                     		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Core.Object.Box
// 0x00000019
struct FBox
{
//	 vPoperty_Size=3
	struct FVector                                     Min;                                              		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Max;                                              		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      IsValid;                                          		// 0x0018 (0x0001) [0x0000000000000000]              
};

// ScriptStruct Core.Object.TPOV
// 0x0000001C
struct FTPOV
{
//	 vPoperty_Size=3
	struct FVector                                     Location;                                         		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FRotator                                    Rotation;                                         		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	float                                              FOV;                                              		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.SHVector
// 0x00000030
struct FSHVector
{
//	 vPoperty_Size=2
	float                                              V[ 0x9 ];                                         		// 0x0000 (0x0024) [0x0000000000000001]              ( CPF_Edit )
	float                                              Padding[ 0x3 ];                                   		// 0x0024 (0x000C) [0x0000000000000000]              
};

// ScriptStruct Core.Object.SHVectorRGB
// 0x00000090
struct FSHVectorRGB
{
//	 vPoperty_Size=3
	struct FSHVector                                   R;                                                		// 0x0000 (0x0030) [0x0000000000000001]              ( CPF_Edit )
	struct FSHVector                                   G;                                                		// 0x0030 (0x0030) [0x0000000000000001]              ( CPF_Edit )
	struct FSHVector                                   B;                                                		// 0x0060 (0x0030) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.IntPoint
// 0x00000008
struct FIntPoint
{
//	 vPoperty_Size=2
	int                                                X;                                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Y;                                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.PackedNormal
// 0x00000004
struct FPackedNormal
{
//	 vPoperty_Size=4
	unsigned char                                      X;                                                		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Y;                                                		// 0x0001 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Z;                                                		// 0x0002 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      W;                                                		// 0x0003 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct Core.Object.IndirectArray_Mirror
// 0x00000010
struct FIndirectArray_Mirror
{
//	 vPoperty_Size=3
	struct FPointer                                    Data;                                             		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                ArrayNum;                                         		// 0x0008 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                ArrayMax;                                         		// 0x000C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.FColorVertexBuffer_Mirror
// 0x0000001C
struct FFColorVertexBuffer_Mirror
{
//	 vPoperty_Size=5
	struct FPointer                                    VfTable;                                          		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    VertexData;                                       		// 0x0008 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                Data;                                             		// 0x0010 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                Stride;                                           		// 0x0014 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                NumVertices;                                      		// 0x0018 (0x0004) [0x0000000000000002]              ( CPF_Const )
};

// ScriptStruct Core.Object.RenderCommandFence_Mirror
// 0x00000004
struct FRenderCommandFence_Mirror
{
//	 vPoperty_Size=1
	int                                                NumPendingFences;                                 		// 0x0000 (0x0004) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
};

// ScriptStruct Core.Object.UntypedBulkData_Mirror
// 0x00000040
struct FUntypedBulkData_Mirror
{
//	 vPoperty_Size=d
	struct FPointer                                    VfTable;                                          		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                BulkDataFlags;                                    		// 0x0008 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                ElementCount;                                     		// 0x000C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                BulkDataOffsetInFile;                             		// 0x0010 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                BulkDataSizeOnDisk;                               		// 0x0014 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                SavedBulkDataFlags;                               		// 0x0018 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                SavedElementCount;                                		// 0x001C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                SavedBulkDataOffsetInFile;                        		// 0x0020 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                SavedBulkDataSizeOnDisk;                          		// 0x0024 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    BulkData;                                         		// 0x0028 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                LockStatus;                                       		// 0x0030 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    AttachedAr;                                       		// 0x0034 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                bShouldFreeOnEmpty;                               		// 0x003C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.BitArray_Mirror
// 0x00000020
struct FBitArray_Mirror
{
//	 vPoperty_Size=4
	struct FPointer                                    IndirectData;                                     		// 0x0000 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                InlineData[ 0x4 ];                                		// 0x0008 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                NumBits;                                          		// 0x0018 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                MaxBits;                                          		// 0x001C (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.SparseArray_Mirror
// 0x00000038
struct FSparseArray_Mirror
{
//	 vPoperty_Size=4
	TArray< int >                                      Elements;                                         		// 0x0000 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FBitArray_Mirror                            AllocationFlags;                                  		// 0x0010 (0x0020) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                FirstFreeIndex;                                   		// 0x0030 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                NumFreeIndices;                                   		// 0x0034 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.Set_Mirror
// 0x00000048
struct FSet_Mirror
{
//	 vPoperty_Size=4
	struct FSparseArray_Mirror                         Elements;                                         		// 0x0000 (0x0038) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                InlineHash;                                       		// 0x0038 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    Hash;                                             		// 0x003C (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                HashSize;                                         		// 0x0044 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.MultiMap_Mirror
// 0x00000048
struct FMultiMap_Mirror
{
//	 vPoperty_Size=1
	struct FSet_Mirror                                 Pairs;                                            		// 0x0000 (0x0048) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.Map_Mirror
// 0x00000048
struct FMap_Mirror
{
//	 vPoperty_Size=1
	struct FSet_Mirror                                 Pairs;                                            		// 0x0000 (0x0048) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.ThreadSafeCounter
// 0x00000004
struct FThreadSafeCounter
{
//	 vPoperty_Size=1
	int                                                Value;                                            		// 0x0000 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.Double
// 0x00000008
struct FDouble
{
//	 vPoperty_Size=2
	int                                                A;                                                		// 0x0000 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                B;                                                		// 0x0004 (0x0004) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct Core.Object.QWord
// 0x00000008
struct FQWord
{
//	 vPoperty_Size=2
	int                                                A;                                                		// 0x0000 (0x0004) [0x0000000000001001]              ( CPF_Edit | CPF_Native )
	int                                                B;                                                		// 0x0004 (0x0004) [0x0000000000001001]              ( CPF_Edit | CPF_Native )
};

// ScriptStruct Core.DistributionFloat.RawDistributionFloat
// 0x0008(0x0024 - 0x001C)
struct FRawDistributionFloat : FRawDistribution
{
//	 vPoperty_Size=1
	class UDistributionFloat*                          Distribution;                                     		// 0x001C (0x0008) [0x0000000006080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_NoClear | CPF_EditInline )
};

// ScriptStruct Core.DistributionFloat.MatineeRawDistributionFloat
// 0x0008(0x002C - 0x0024)
struct FMatineeRawDistributionFloat : FRawDistributionFloat
{
//	 vPoperty_Size=2
	float                                              MatineeValue;                                     		// 0x0024 (0x0004) [0x0000000000000000]              
	unsigned long                                      bInMatinee : 1;                                   		// 0x0028 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct Core.DistributionVector.RawDistributionVector
// 0x0008(0x0024 - 0x001C)
struct FRawDistributionVector : FRawDistribution
{
//	 vPoperty_Size=1
	class UDistributionVector*                         Distribution;                                     		// 0x001C (0x0008) [0x0000000006080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_NoClear | CPF_EditInline )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif