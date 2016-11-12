#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: UnrealEd_f_structs.h
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
# Function Structs
# ========================================================================================= #
*/

// Function UnrealEd.BrushBuilder.Build
// [0x00020800] ( FUNC_Event )
struct UBrushBuilder_eventBuild_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.PolyEnd
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execPolyEnd_Parms
{
};

// Function UnrealEd.BrushBuilder.Polyi
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execPolyi_Parms
{
	int                                                I;                                                		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function UnrealEd.BrushBuilder.PolyBegin
// [0x00024400] ( FUNC_Native )
struct UBrushBuilder_execPolyBegin_Parms
{
	int                                                Direction;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       ItemName;                                         		// 0x0004 (0x0008) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
};

// Function UnrealEd.BrushBuilder.Poly4i
// [0x00024400] ( FUNC_Native )
struct UBrushBuilder_execPoly4i_Parms
{
	int                                                Direction;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                I;                                                		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                J;                                                		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                K;                                                		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                L;                                                		// 0x0010 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       ItemName;                                         		// 0x0014 (0x0008) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bIsTwoSidedNonSolid : 1;                          		// 0x001C (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function UnrealEd.BrushBuilder.Poly3i
// [0x00024400] ( FUNC_Native )
struct UBrushBuilder_execPoly3i_Parms
{
	int                                                Direction;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                I;                                                		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                J;                                                		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                K;                                                		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       ItemName;                                         		// 0x0010 (0x0008) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bIsTwoSidedNonSolid : 1;                          		// 0x0018 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function UnrealEd.BrushBuilder.Vertex3f
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execVertex3f_Parms
{
	float                                              X;                                                		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	float                                              Y;                                                		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	float                                              Z;                                                		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x000C (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.Vertexv
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execVertexv_Parms
{
	struct FVector                                     V;                                                		// 0x0000 (0x000C) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x000C (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.BadParameters
// [0x00024400] ( FUNC_Native )
struct UBrushBuilder_execBadParameters_Parms
{
	struct FString                                     msg;                                              		// 0x0000 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.GetPolyCount
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execGetPolyCount_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.GetVertex
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execGetVertex_Parms
{
	int                                                I;                                                		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FVector                                     ReturnValue;                                      		// 0x0004 (0x000C) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.GetVertexCount
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execGetVertexCount_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.EndBrush
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execEndBrush_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function UnrealEd.BrushBuilder.BeginBrush
// [0x00020400] ( FUNC_Native )
struct UBrushBuilder_execBeginBrush_Parms
{
	unsigned long                                      InMergeCoplanars : 1;                             		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FName                                       InLayer;                                          		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif