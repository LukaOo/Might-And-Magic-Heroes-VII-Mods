#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: UnrealEd_structs.h
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

// ScriptStruct UnrealEd.BrushBuilder.BuilderPoly
// 0x00000020
struct FBuilderPoly
{
//	 vPoperty_Size=4
	TArray< int >                                      VertexIndices;                                    		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Direction;                                        		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FName                                       Item;                                             		// 0x0014 (0x0008) [0x0000000000000000]              
	int                                                PolyFlags;                                        		// 0x001C (0x0004) [0x0000000000000000]              
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif