#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: UnrealEd_functions.h
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
# Functions
# ========================================================================================= #
*/

// Function UnrealEd.BrushBuilder.Build
// [0x00020800] ( FUNC_Event )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UBrushBuilder::eventBuild ( )
{
	static UFunction* pFnBuild = NULL;

	if ( ! pFnBuild )
		pFnBuild = (UFunction*) UObject::GObjObjects()->Data[ 47493 ];

	UBrushBuilder_eventBuild_Parms Build_Parms;

	this->ProcessEvent ( pFnBuild, &Build_Parms, NULL );

	return Build_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.PolyEnd
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UBrushBuilder::PolyEnd ( )
{
	static UFunction* pFnPolyEnd = NULL;

	if ( ! pFnPolyEnd )
		pFnPolyEnd = (UFunction*) UObject::GObjObjects()->Data[ 47497 ];

	UBrushBuilder_execPolyEnd_Parms PolyEnd_Parms;

	pFnPolyEnd->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPolyEnd, &PolyEnd_Parms, NULL );

	pFnPolyEnd->FunctionFlags |= 0x400;
};

// Function UnrealEd.BrushBuilder.Polyi
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            I                              ( CPF_Parm )

void UBrushBuilder::Polyi ( int I )
{
	static UFunction* pFnPolyi = NULL;

	if ( ! pFnPolyi )
		pFnPolyi = (UFunction*) UObject::GObjObjects()->Data[ 47499 ];

	UBrushBuilder_execPolyi_Parms Polyi_Parms;
	Polyi_Parms.I = I;

	pFnPolyi->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPolyi, &Polyi_Parms, NULL );

	pFnPolyi->FunctionFlags |= 0x400;
};

// Function UnrealEd.BrushBuilder.PolyBegin
// [0x00024400] ( FUNC_Native )
// Parameters infos:
// int                            Direction                      ( CPF_Parm )
// struct FName                   ItemName                       ( CPF_OptionalParm | CPF_Parm )

void UBrushBuilder::PolyBegin ( int Direction, struct FName ItemName )
{
	static UFunction* pFnPolyBegin = NULL;

	if ( ! pFnPolyBegin )
		pFnPolyBegin = (UFunction*) UObject::GObjObjects()->Data[ 47500 ];

	UBrushBuilder_execPolyBegin_Parms PolyBegin_Parms;
	PolyBegin_Parms.Direction = Direction;
	memcpy ( &PolyBegin_Parms.ItemName, &ItemName, 0x8 );

	pFnPolyBegin->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPolyBegin, &PolyBegin_Parms, NULL );

	pFnPolyBegin->FunctionFlags |= 0x400;
};

// Function UnrealEd.BrushBuilder.Poly4i
// [0x00024400] ( FUNC_Native )
// Parameters infos:
// int                            Direction                      ( CPF_Parm )
// int                            I                              ( CPF_Parm )
// int                            J                              ( CPF_Parm )
// int                            K                              ( CPF_Parm )
// int                            L                              ( CPF_Parm )
// struct FName                   ItemName                       ( CPF_OptionalParm | CPF_Parm )
// unsigned long                  bIsTwoSidedNonSolid            ( CPF_OptionalParm | CPF_Parm )

void UBrushBuilder::Poly4i ( int Direction, int I, int J, int K, int L, struct FName ItemName, unsigned long bIsTwoSidedNonSolid )
{
	static UFunction* pFnPoly4i = NULL;

	if ( ! pFnPoly4i )
		pFnPoly4i = (UFunction*) UObject::GObjObjects()->Data[ 47502 ];

	UBrushBuilder_execPoly4i_Parms Poly4i_Parms;
	Poly4i_Parms.Direction = Direction;
	Poly4i_Parms.I = I;
	Poly4i_Parms.J = J;
	Poly4i_Parms.K = K;
	Poly4i_Parms.L = L;
	memcpy ( &Poly4i_Parms.ItemName, &ItemName, 0x8 );
	Poly4i_Parms.bIsTwoSidedNonSolid = bIsTwoSidedNonSolid;

	pFnPoly4i->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPoly4i, &Poly4i_Parms, NULL );

	pFnPoly4i->FunctionFlags |= 0x400;
};

// Function UnrealEd.BrushBuilder.Poly3i
// [0x00024400] ( FUNC_Native )
// Parameters infos:
// int                            Direction                      ( CPF_Parm )
// int                            I                              ( CPF_Parm )
// int                            J                              ( CPF_Parm )
// int                            K                              ( CPF_Parm )
// struct FName                   ItemName                       ( CPF_OptionalParm | CPF_Parm )
// unsigned long                  bIsTwoSidedNonSolid            ( CPF_OptionalParm | CPF_Parm )

void UBrushBuilder::Poly3i ( int Direction, int I, int J, int K, struct FName ItemName, unsigned long bIsTwoSidedNonSolid )
{
	static UFunction* pFnPoly3i = NULL;

	if ( ! pFnPoly3i )
		pFnPoly3i = (UFunction*) UObject::GObjObjects()->Data[ 47505 ];

	UBrushBuilder_execPoly3i_Parms Poly3i_Parms;
	Poly3i_Parms.Direction = Direction;
	Poly3i_Parms.I = I;
	Poly3i_Parms.J = J;
	Poly3i_Parms.K = K;
	memcpy ( &Poly3i_Parms.ItemName, &ItemName, 0x8 );
	Poly3i_Parms.bIsTwoSidedNonSolid = bIsTwoSidedNonSolid;

	pFnPoly3i->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPoly3i, &Poly3i_Parms, NULL );

	pFnPoly3i->FunctionFlags |= 0x400;
};

// Function UnrealEd.BrushBuilder.Vertex3f
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// float                          X                              ( CPF_Parm )
// float                          Y                              ( CPF_Parm )
// float                          Z                              ( CPF_Parm )

int UBrushBuilder::Vertex3f ( float X, float Y, float Z )
{
	static UFunction* pFnVertex3f = NULL;

	if ( ! pFnVertex3f )
		pFnVertex3f = (UFunction*) UObject::GObjObjects()->Data[ 47513 ];

	UBrushBuilder_execVertex3f_Parms Vertex3f_Parms;
	Vertex3f_Parms.X = X;
	Vertex3f_Parms.Y = Y;
	Vertex3f_Parms.Z = Z;

	pFnVertex3f->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnVertex3f, &Vertex3f_Parms, NULL );

	pFnVertex3f->FunctionFlags |= 0x400;

	return Vertex3f_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.Vertexv
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FVector                 V                              ( CPF_Parm )

int UBrushBuilder::Vertexv ( struct FVector V )
{
	static UFunction* pFnVertexv = NULL;

	if ( ! pFnVertexv )
		pFnVertexv = (UFunction*) UObject::GObjObjects()->Data[ 47520 ];

	UBrushBuilder_execVertexv_Parms Vertexv_Parms;
	memcpy ( &Vertexv_Parms.V, &V, 0xC );

	pFnVertexv->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnVertexv, &Vertexv_Parms, NULL );

	pFnVertexv->FunctionFlags |= 0x400;

	return Vertexv_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.BadParameters
// [0x00024400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 msg                            ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )

bool UBrushBuilder::BadParameters ( struct FString msg )
{
	static UFunction* pFnBadParameters = NULL;

	if ( ! pFnBadParameters )
		pFnBadParameters = (UFunction*) UObject::GObjObjects()->Data[ 47525 ];

	UBrushBuilder_execBadParameters_Parms BadParameters_Parms;
	memcpy ( &BadParameters_Parms.msg, &msg, 0x10 );

	pFnBadParameters->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnBadParameters, &BadParameters_Parms, NULL );

	pFnBadParameters->FunctionFlags |= 0x400;

	return BadParameters_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.GetPolyCount
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

int UBrushBuilder::GetPolyCount ( )
{
	static UFunction* pFnGetPolyCount = NULL;

	if ( ! pFnGetPolyCount )
		pFnGetPolyCount = (UFunction*) UObject::GObjObjects()->Data[ 47528 ];

	UBrushBuilder_execGetPolyCount_Parms GetPolyCount_Parms;

	pFnGetPolyCount->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetPolyCount, &GetPolyCount_Parms, NULL );

	pFnGetPolyCount->FunctionFlags |= 0x400;

	return GetPolyCount_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.GetVertex
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FVector                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// int                            I                              ( CPF_Parm )

struct FVector UBrushBuilder::GetVertex ( int I )
{
	static UFunction* pFnGetVertex = NULL;

	if ( ! pFnGetVertex )
		pFnGetVertex = (UFunction*) UObject::GObjObjects()->Data[ 47531 ];

	UBrushBuilder_execGetVertex_Parms GetVertex_Parms;
	GetVertex_Parms.I = I;

	pFnGetVertex->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetVertex, &GetVertex_Parms, NULL );

	pFnGetVertex->FunctionFlags |= 0x400;

	return GetVertex_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.GetVertexCount
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

int UBrushBuilder::GetVertexCount ( )
{
	static UFunction* pFnGetVertexCount = NULL;

	if ( ! pFnGetVertexCount )
		pFnGetVertexCount = (UFunction*) UObject::GObjObjects()->Data[ 47533 ];

	UBrushBuilder_execGetVertexCount_Parms GetVertexCount_Parms;

	pFnGetVertexCount->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetVertexCount, &GetVertexCount_Parms, NULL );

	pFnGetVertexCount->FunctionFlags |= 0x400;

	return GetVertexCount_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.EndBrush
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UBrushBuilder::EndBrush ( )
{
	static UFunction* pFnEndBrush = NULL;

	if ( ! pFnEndBrush )
		pFnEndBrush = (UFunction*) UObject::GObjObjects()->Data[ 47536 ];

	UBrushBuilder_execEndBrush_Parms EndBrush_Parms;

	pFnEndBrush->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnEndBrush, &EndBrush_Parms, NULL );

	pFnEndBrush->FunctionFlags |= 0x400;

	return EndBrush_Parms.ReturnValue;
};

// Function UnrealEd.BrushBuilder.BeginBrush
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned long                  InMergeCoplanars               ( CPF_Parm )
// struct FName                   InLayer                        ( CPF_Parm )

void UBrushBuilder::BeginBrush ( unsigned long InMergeCoplanars, struct FName InLayer )
{
	static UFunction* pFnBeginBrush = NULL;

	if ( ! pFnBeginBrush )
		pFnBeginBrush = (UFunction*) UObject::GObjObjects()->Data[ 47538 ];

	UBrushBuilder_execBeginBrush_Parms BeginBrush_Parms;
	BeginBrush_Parms.InMergeCoplanars = InMergeCoplanars;
	memcpy ( &BeginBrush_Parms.InLayer, &InLayer, 0x8 );

	pFnBeginBrush->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnBeginBrush, &BeginBrush_Parms, NULL );

	pFnBeginBrush->FunctionFlags |= 0x400;
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif