#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: UnrealEd_classes.h
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
# Constants
# ========================================================================================= #
*/


/*
# ========================================================================================= #
# Enums
# ========================================================================================= #
*/


/*
# ========================================================================================= #
# Classes
# ========================================================================================= #
*/

// Class UnrealEd.BrushBuilder ( Property size: 7 iter: 22) 
// Class name index: 7944 
// 0x0054 (0x00B4 - 0x0060)
class UBrushBuilder : public UObject
{
public:
	struct FString                                     BitmapFilename;                                   		// 0x0060 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     ToolTip;                                          		// 0x0070 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FVector >                           Vertices;                                         		// 0x0080 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FBuilderPoly >                      Polys;                                            		// 0x0090 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FName                                       Group;                                            		// 0x00A0 (0x0008) [0x0000000020000000]              ( CPF_Deprecated )
	struct FName                                       Layer;                                            		// 0x00A8 (0x0008) [0x0000000000000000]              
	unsigned long                                      MergeCoplanars : 1;                               		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000001] 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3131 ];

		return pClassPointer;
	};

	bool eventBuild ( );
	void PolyEnd ( );
	void Polyi ( int I );
	void PolyBegin ( int Direction, struct FName ItemName );
	void Poly4i ( int Direction, int I, int J, int K, int L, struct FName ItemName, unsigned long bIsTwoSidedNonSolid );
	void Poly3i ( int Direction, int I, int J, int K, struct FName ItemName, unsigned long bIsTwoSidedNonSolid );
	int Vertex3f ( float X, float Y, float Z );
	int Vertexv ( struct FVector V );
	bool BadParameters ( struct FString msg );
	int GetPolyCount ( );
	struct FVector GetVertex ( int I );
	int GetVertexCount ( );
	bool EndBrush ( );
	void BeginBrush ( unsigned long InMergeCoplanars, struct FName InLayer );
};




#ifdef _MSC_VER
	#pragma pack ( pop )
#endif