#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: Core_classes.h
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

#define CONST_InvAspectRatio16x9                                 0.56249
#define CONST_InvAspectRatio5x4                                  0.8
#define CONST_InvAspectRatio4x3                                  0.75
#define CONST_AspectRatio16x9                                    1.77778
#define CONST_AspectRatio5x4                                     1.25
#define CONST_AspectRatio4x3                                     1.33333
#define CONST_INDEX_NONE                                         -1
#define CONST_UnrRotToDeg                                        0.00549316540360483
#define CONST_DegToUnrRot                                        182.0444
#define CONST_RadToUnrRot                                        10430.3783504704527
#define CONST_UnrRotToRad                                        0.00009587379924285
#define CONST_DegToRad                                           0.017453292519943296
#define CONST_RadToDeg                                           57.295779513082321600
#define CONST_Pi                                                 3.1415926535897932
#define CONST_MaxInt                                             0x7fffffff

/*
# ========================================================================================= #
# Enums
# ========================================================================================= #
*/

// Enum Core.Object.EDebugBreakType
/*enum EDebugBreakType
{
	DEBUGGER_NativeOnly                                = 0,
	DEBUGGER_ScriptOnly                                = 1,
	DEBUGGER_Both                                      = 2,
	DEBUGGER_MAX                                       = 3
};*/

// Enum Core.Object.EAutomatedRunResult
/*enum EAutomatedRunResult
{
	ARR_Unknown                                        = 0,
	ARR_OOM                                            = 1,
	ARR_Passed                                         = 2,
	ARR_MAX                                            = 3
};*/

// Enum Core.Object.EAspectRatioAxisConstraint
/*enum EAspectRatioAxisConstraint
{
	AspectRatio_MaintainYFOV                           = 0,
	AspectRatio_MaintainXFOV                           = 1,
	AspectRatio_MajorAxisFOV                           = 2,
	AspectRatio_MAX                                    = 3
};*/

// Enum Core.Object.EInterpCurveMode
/*enum EInterpCurveMode
{
	CIM_Linear                                         = 0,
	CIM_CurveAuto                                      = 1,
	CIM_Constant                                       = 2,
	CIM_CurveUser                                      = 3,
	CIM_CurveBreak                                     = 4,
	CIM_CurveAutoClamped                               = 5,
	CIM_MAX                                            = 6
};*/

// Enum Core.Object.EInterpMethodType
/*enum EInterpMethodType
{
	IMT_UseFixedTangentEvalAndNewAutoTangents          = 0,
	IMT_UseFixedTangentEval                            = 1,
	IMT_UseBrokenTangentEval                           = 2,
	IMT_MAX                                            = 3
};*/

// Enum Core.Object.EAxis
/*enum EAxis
{
	AXIS_NONE                                          = 0,
	AXIS_X                                             = 1,
	AXIS_Y                                             = 2,
	AXIS_BLANK                                         = 3,
	AXIS_Z                                             = 4,
	AXIS_MAX                                           = 5
};*/

// Enum Core.Object.ETickingGroup
/*enum ETickingGroup
{
	TG_PreAsyncWork                                    = 0,
	TG_DuringAsyncWork                                 = 1,
	TG_PostAsyncWork                                   = 2,
	TG_PostUpdateWork                                  = 3,
	TG_EffectsUpdateWork                               = 4,
	TG_MAX                                             = 5
};*/

// Enum Core.Object.EInputEvent
/*enum EInputEvent
{
	IE_Pressed                                         = 0,
	IE_Released                                        = 1,
	IE_Repeat                                          = 2,
	IE_DoubleClick                                     = 3,
	IE_Axis                                            = 4,
	IE_MAX                                             = 5
};*/

// Enum Core.Object.AlphaBlendType
/*enum AlphaBlendType
{
	ABT_Linear                                         = 0,
	ABT_Cubic                                          = 1,
	ABT_Sinusoidal                                     = 2,
	ABT_EaseInOutExponent2                             = 3,
	ABT_EaseInOutExponent3                             = 4,
	ABT_EaseInOutExponent4                             = 5,
	ABT_EaseInOutExponent5                             = 6,
	ABT_MAX                                            = 7
};*/

// Enum Core.DistributionVector.EDistributionVectorLockFlags
/*enum EDistributionVectorLockFlags
{
	EDVLF_None                                         = 0,
	EDVLF_XY                                           = 1,
	EDVLF_XZ                                           = 2,
	EDVLF_YZ                                           = 3,
	EDVLF_XYZ                                          = 4,
	EDVLF_MAX                                          = 5
};*/

// Enum Core.DistributionVector.EDistributionVectorMirrorFlags
/*enum EDistributionVectorMirrorFlags
{
	EDVMF_Same                                         = 0,
	EDVMF_Different                                    = 1,
	EDVMF_Mirror                                       = 2,
	EDVMF_MAX                                          = 3
};*/


/*
# ========================================================================================= #
# Classes
# ========================================================================================= #
*/

// Class Core.Object ( Property size: 13 iter: 394) 
// Class name index: 151 
// 0x0060
class UObject
{
public:
	// struct FPointer                                    VfTableObject;                                    		// 0x0000 (0x0008) [0x0000000000821002]              ( CPF_Const | CPF_Native | CPF_EditConst | CPF_NoExport )
	struct FPointer                                    HashNext;                                         		// 0x0008 (0x0008) [0x0000000000021002]              ( CPF_Const | CPF_Native | CPF_EditConst )
	struct FQWord                                      ObjectFlags;                                      		// 0x0010 (0x0008) [0x0000000000021002]              ( CPF_Const | CPF_Native | CPF_EditConst )
	struct FPointer                                    HashOuterNext;                                    		// 0x0018 (0x0008) [0x0000000000021002]              ( CPF_Const | CPF_Native | CPF_EditConst )
	struct FPointer                                    StateFrame;                                       		// 0x0020 (0x0008) [0x0000000000021002]              ( CPF_Const | CPF_Native | CPF_EditConst )
	class UObject*                                     Linker;                                           		// 0x0028 (0x0008) [0x0000000000821002]              ( CPF_Const | CPF_Native | CPF_EditConst | CPF_NoExport )
	struct FPointer                                    LinkerIndex;                                      		// 0x0030 (0x0008) [0x0000000000821002]              ( CPF_Const | CPF_Native | CPF_EditConst | CPF_NoExport )
	int                                                ObjectInternalInteger;                            		// 0x0038 (0x0004) [0x0000000000821002]              ( CPF_Const | CPF_Native | CPF_EditConst | CPF_NoExport )
	int                                                NetIndex;                                         		// 0x003C (0x0004) [0x0000000000821002]              ( CPF_Const | CPF_Native | CPF_EditConst | CPF_NoExport )
	class UObject*                                     Outer;                                            		// 0x0040 (0x0008) [0x0000000000021002]              ( CPF_Const | CPF_Native | CPF_EditConst )
	struct FName                                       Name;                                             		// 0x0048 (0x0008) [0x0000000000021003]              ( CPF_Edit | CPF_Const | CPF_Native | CPF_EditConst )
	class UClass*                                      Class;                                            		// 0x0050 (0x0008) [0x0000000000021002]              ( CPF_Const | CPF_Native | CPF_EditConst )
	class UObject*                                     ObjectArchetype;                                  		// 0x0058 (0x0008) [0x0000000000021003]              ( CPF_Edit | CPF_Const | CPF_Native | CPF_EditConst )

private:
	static UClass* pClassPointer;

public:
	static TArray< UObject* >* GObjObjects(); 

	char* GetName(); 
	char* GetNameCPP(); 
	char* GetFullName(); 

	template< class T > static T* FindObject ( char* ObjectFullName ); 
	static UClass* FindClass ( char* ClassFullName ); 

	bool IsA ( UClass* pClass ); 

	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2 ];

		return pClassPointer;
	};

	void ProfNodeEvent ( struct FString EventName );
	void ProfNodeSetDepthThreshold ( int Depth );
	void ProfNodeSetTimeThresholdSeconds ( float Threshold );
	void ProfNodeStop ( int AssumedTimerIndex );
	int ProfNodeStart ( struct FString TimerName );
	struct FString GetStringFromGuid ( struct FGuid* InGuid );
	struct FGuid GetGuidFromString ( struct FString* InGuidString );
	struct FGuid CreateGuid ( );
	bool IsGuidValid ( struct FGuid* InGuid );
	void InvalidateGuid ( struct FGuid* InGuid );
	struct FString GetLanguage ( );
	int GetRandomOptionSumFrequency ( TArray< float >* FreqList );
	int GetBuildChangelistNumber ( );
	int GetEngineVersion ( );
	void GetSystemTime ( int* Year, int* Month, int* DayOfWeek, int* Day, int* Hour, int* Min, int* Sec, int* MSec );
	struct FString TimeStamp ( );
	struct FVector TransformVectorByRotation ( struct FRotator SourceRotation, struct FVector SourceVector, unsigned long bInverse );
	struct FName GetPackageName ( );
	bool IsPendingKill ( );
	float ByteToFloat ( unsigned char inputByte, unsigned long bSigned );
	unsigned char FloatToByte ( float inputFloat, unsigned long bSigned );
	float UnwindHeading ( float A );
	float FindDeltaAngle ( float A1, float A2 );
	float GetHeadingAngle ( struct FVector Dir );
	void GetAngularDegreesFromRadians ( struct FVector2D* OutFOV );
	void GetAngularFromDotDist ( struct FVector2D DotDist, struct FVector2D* OutAngDist );
	bool GetAngularDistance ( struct FVector Direction, struct FVector AxisX, struct FVector AxisY, struct FVector AxisZ, struct FVector2D* OutAngularDist );
	bool GetDotDistance ( struct FVector Direction, struct FVector AxisX, struct FVector AxisY, struct FVector AxisZ, struct FVector2D* OutDotDist );
	struct FVector PointProjectToPlane ( struct FVector Point, struct FVector A, struct FVector B, struct FVector C );
	float PointDistToPlane ( struct FVector Point, struct FRotator Orientation, struct FVector Origin, struct FVector* out_ClosestPoint );
	float PointDistToSegment ( struct FVector Point, struct FVector StartPoint, struct FVector EndPoint, struct FVector* OutClosestPoint );
	float PointDistToLine ( struct FVector Point, struct FVector Line, struct FVector Origin, struct FVector* OutClosestPoint );
	bool GetPerObjectConfigSections ( class UClass* SearchClass, class UObject* ObjectOuter, int MaxResults, TArray< struct FString >* out_SectionNames );
	void ImportJSON ( struct FString PropertyName, struct FString* JSON );
	void StaticSaveConfig ( );
	void SaveConfig ( );
	void DynLoadObjectArrayProperty ( struct FName PropertyName );
	void DynLoadObjectProperty ( struct FName PropertyName );
	class UObject* FindObject ( struct FString ObjectName, class UClass* ObjectClass );
	class UObject* DynamicLoadObject ( struct FString ObjectName, class UClass* ObjectClass, unsigned long MayFail );
	int EnumFromString ( class UObject* E, struct FName ValueName );
	struct FName GetEnum ( class UObject* E, int I );
	void Disable ( struct FName ProbeFunc );
	void Enable ( struct FName ProbeFunc );
	void eventContinuedState ( );
	void eventPausedState ( );
	void eventPoppedState ( );
	void eventPushedState ( );
	void eventEndState ( struct FName NextStateName );
	void eventBeginState ( struct FName PreviousStateName );
	void DumpStateStack ( );
	void PopState ( unsigned long bPopAll );
	void PushState ( struct FName NewState, struct FName NewLabel );
	struct FName GetStateName ( );
	bool IsChildState ( struct FName TestState, struct FName TestParentState );
	bool IsInState ( struct FName TestState, unsigned long bTestStateStack );
	void GotoState ( struct FName NewState, struct FName Label, unsigned long bForceEvents, unsigned long bKeepStack );
	bool IsUTracing ( );
	void SetUTracing ( unsigned long bShouldUTrace );
	struct FName GetFuncName ( );
	void DebugBreak ( int UserFlags, unsigned char DebuggerType );
	struct FString GetScriptTrace ( );
	void ScriptTrace ( );
	struct FString ParseLocalizedPropertyPath ( struct FString PathName );
	struct FString Localize ( struct FString SectionName, struct FString KeyName, struct FString PackageName );
	void WarnInternal ( struct FString S );
	void LogInternal ( struct FString S, struct FName Tag );
	struct FLinearColor Subtract_LinearColorLinearColor ( struct FLinearColor A, struct FLinearColor B );
	struct FLinearColor Multiply_LinearColorFloat ( struct FLinearColor LC, float Mult );
	struct FLinearColor ColorToLinearColor ( struct FColor OldColor );
	struct FLinearColor MakeLinearColor ( float R, float G, float B, float A );
	struct FColor LerpColor ( struct FColor A, struct FColor B, float Alpha );
	struct FColor MakeColor ( unsigned char R, unsigned char G, unsigned char B, unsigned char A );
	struct FColor Add_ColorColor ( struct FColor A, struct FColor B );
	struct FColor Multiply_ColorFloat ( struct FColor A, float B );
	struct FColor Multiply_FloatColor ( float A, struct FColor B );
	struct FColor Subtract_ColorColor ( struct FColor A, struct FColor B );
	struct FVector2D EvalInterpCurveVector2D ( float InVal, struct FInterpCurveVector2D* Vector2DCurve );
	struct FVector EvalInterpCurveVector ( float InVal, struct FInterpCurveVector* VectorCurve );
	float EvalInterpCurveFloat ( float InVal, struct FInterpCurveFloat* FloatCurve );
	struct FVector2D vect2d ( float InX, float InY );
	float GetMappedRangeValue ( struct FVector2D InputRange, struct FVector2D OutputRange, float Value );
	float GetRangePctByValue ( struct FVector2D Range, float Value );
	float GetRangeValueByPct ( struct FVector2D Range, float Pct );
	struct FVector2D SubtractEqual_Vector2DVector2D ( struct FVector2D B, struct FVector2D* A );
	struct FVector2D AddEqual_Vector2DVector2D ( struct FVector2D B, struct FVector2D* A );
	struct FVector2D DivideEqual_Vector2DFloat ( float B, struct FVector2D* A );
	struct FVector2D MultiplyEqual_Vector2DFloat ( float B, struct FVector2D* A );
	struct FVector2D Divide_Vector2DFloat ( struct FVector2D A, float B );
	struct FVector2D Multiply_Vector2DFloat ( struct FVector2D A, float B );
	struct FVector2D Subtract_Vector2DVector2D ( struct FVector2D A, struct FVector2D B );
	struct FVector2D Add_Vector2DVector2D ( struct FVector2D A, struct FVector2D B );
	struct FQuat Subtract_QuatQuat ( struct FQuat A, struct FQuat B );
	struct FQuat Add_QuatQuat ( struct FQuat A, struct FQuat B );
	struct FQuat QuatSlerp ( struct FQuat A, struct FQuat B, float Alpha, unsigned long bShortestPath );
	struct FRotator QuatToRotator ( struct FQuat A );
	struct FQuat QuatFromRotator ( struct FRotator A );
	struct FQuat QuatFromAxisAndAngle ( struct FVector Axis, float Angle );
	struct FQuat QuatFindBetween ( struct FVector A, struct FVector B );
	struct FVector QuatRotateVector ( struct FQuat A, struct FVector B );
	struct FQuat QuatInvert ( struct FQuat A );
	float QuatDot ( struct FQuat A, struct FQuat B );
	struct FQuat QuatProduct ( struct FQuat A, struct FQuat B );
	struct FVector MatrixGetAxis ( struct FMatrix TM, unsigned char Axis );
	struct FVector MatrixGetOrigin ( struct FMatrix TM );
	struct FRotator MatrixGetRotator ( struct FMatrix TM );
	struct FMatrix MakeRotationMatrix ( struct FRotator Rotation );
	struct FMatrix MakeRotationTranslationMatrix ( struct FVector Translation, struct FRotator Rotation );
	struct FVector InverseTransformNormal ( struct FMatrix TM, struct FVector A );
	struct FVector TransformNormal ( struct FMatrix TM, struct FVector A );
	struct FVector InverseTransformVector ( struct FMatrix TM, struct FVector A );
	struct FVector TransformVector ( struct FMatrix TM, struct FVector A );
	struct FMatrix Multiply_MatrixMatrix ( struct FMatrix A, struct FMatrix B );
	bool NotEqual_NameName ( struct FName A, struct FName B );
	bool EqualEqual_NameName ( struct FName A, struct FName B );
	bool IsA ( struct FName ClassName );
	bool ClassIsChildOf ( class UClass* TestClass, class UClass* ParentClass );
	bool NotEqual_InterfaceInterface ( class UInterface* A, class UInterface* B );
	bool EqualEqual_InterfaceInterface ( class UInterface* A, class UInterface* B );
	bool NotEqual_ObjectObject ( class UObject* A, class UObject* B );
	bool EqualEqual_ObjectObject ( class UObject* A, class UObject* B );
	struct FString PathName ( class UObject* CheckObject );
	TArray< struct FString > SplitString ( struct FString Source, struct FString Delimiter, unsigned long bCullEmpty );
	void ParseStringIntoArray ( struct FString BaseString, struct FString delim, unsigned long bCullEmpty, TArray< struct FString >* Pieces );
	void JoinArray ( TArray< struct FString > StringArray, struct FString delim, unsigned long bIgnoreBlanks, struct FString* out_Result );
	struct FString GetRightMost ( struct FString Text );
	struct FString Split ( struct FString Text, struct FString SplitStr, unsigned long bOmitSplitStr );
	struct FString Repl ( struct FString Src, struct FString Match, struct FString With, unsigned long bCaseSensitive );
	int Asc ( struct FString S );
	struct FString Chr ( int I );
	struct FString Locs ( struct FString S );
	struct FString Caps ( struct FString S );
	struct FString Right ( struct FString S, int I );
	struct FString Left ( struct FString S, int I );
	struct FString Mid ( struct FString S, int I, int J );
	int InStr ( struct FString S, struct FString T, unsigned long bSearchFromRight, unsigned long bIgnoreCase, int StartPos );
	int Len ( struct FString S );
	struct FString SubtractEqual_StrStr ( struct FString B, struct FString* A );
	struct FString AtEqual_StrStr ( struct FString B, struct FString* A );
	struct FString ConcatEqual_StrStr ( struct FString B, struct FString* A );
	bool ComplementEqual_StrStr ( struct FString A, struct FString B );
	bool NotEqual_StrStr ( struct FString A, struct FString B );
	bool EqualEqual_StrStr ( struct FString A, struct FString B );
	bool GreaterEqual_StrStr ( struct FString A, struct FString B );
	bool LessEqual_StrStr ( struct FString A, struct FString B );
	bool Greater_StrStr ( struct FString A, struct FString B );
	bool Less_StrStr ( struct FString A, struct FString B );
	struct FString At_StrStr ( struct FString A, struct FString B );
	struct FString Concat_StrStr ( struct FString A, struct FString B );
	struct FRotator MakeRotator ( int Pitch, int Yaw, int Roll );
	bool SClampRotAxis ( float DeltaTime, int ViewAxis, int MaxLimit, int MinLimit, float InterpolationSpeed, int* out_DeltaViewAxis );
	int ClampRotAxisFromRange ( int Current, int Min, int Max );
	int ClampRotAxisFromBase ( int Current, int Center, int MaxDelta );
	void ClampRotAxis ( int ViewAxis, int MaxLimit, int MinLimit, int* out_DeltaViewAxis );
	float RSize ( struct FRotator R );
	float RDiff ( struct FRotator A, struct FRotator B );
	int NormalizeRotAxis ( int Angle );
	struct FRotator RInterpTo ( struct FRotator Current, struct FRotator Target, float DeltaTime, float InterpSpeed, unsigned long bConstantInterpSpeed );
	struct FRotator RTransform ( struct FRotator R, struct FRotator RBasis );
	struct FRotator RLerp ( struct FRotator A, struct FRotator B, float Alpha, unsigned long bShortestPath );
	struct FRotator Normalize ( struct FRotator Rot );
	struct FRotator OrthoRotation ( struct FVector X, struct FVector Y, struct FVector Z );
	struct FRotator RotRand ( unsigned long bRoll );
	struct FVector GetRotatorAxis ( struct FRotator A, int Axis );
	void GetUnAxes ( struct FRotator A, struct FVector* X, struct FVector* Y, struct FVector* Z );
	void GetAxes ( struct FRotator A, struct FVector* X, struct FVector* Y, struct FVector* Z );
	bool ClockwiseFrom_IntInt ( int A, int B );
	struct FRotator SubtractEqual_RotatorRotator ( struct FRotator B, struct FRotator* A );
	struct FRotator AddEqual_RotatorRotator ( struct FRotator B, struct FRotator* A );
	struct FRotator Subtract_RotatorRotator ( struct FRotator A, struct FRotator B );
	struct FRotator Add_RotatorRotator ( struct FRotator A, struct FRotator B );
	struct FRotator DivideEqual_RotatorFloat ( float B, struct FRotator* A );
	struct FRotator MultiplyEqual_RotatorFloat ( float B, struct FRotator* A );
	struct FRotator Divide_RotatorFloat ( struct FRotator A, float B );
	struct FRotator Multiply_FloatRotator ( float A, struct FRotator B );
	struct FRotator Multiply_RotatorFloat ( struct FRotator A, float B );
	bool NotEqual_RotatorRotator ( struct FRotator A, struct FRotator B );
	bool EqualEqual_RotatorRotator ( struct FRotator A, struct FRotator B );
	bool InCylinder ( struct FVector Origin, struct FRotator Dir, float Width, struct FVector A, unsigned long bIgnoreZ );
	float NoZDot ( struct FVector A, struct FVector B );
	struct FVector ClampLength ( struct FVector V, float MaxLength );
	struct FVector VInterpTo ( struct FVector Current, struct FVector Target, float DeltaTime, float InterpSpeed );
	bool IsZero ( struct FVector A );
	struct FVector ProjectOnTo ( struct FVector X, struct FVector Y );
	struct FVector MirrorVectorByNormal ( struct FVector InVect, struct FVector InNormal );
	struct FVector VRandCone2 ( struct FVector Dir, float HorizontalConeHalfAngleRadians, float VerticalConeHalfAngleRadians );
	struct FVector VRandCone ( struct FVector Dir, float ConeHalfAngleRadians );
	struct FVector VRand ( );
	struct FVector VLerp ( struct FVector A, struct FVector B, float Alpha );
	struct FVector Normal2D ( struct FVector A );
	struct FVector Normal ( struct FVector A );
	float VSizeSq2D ( struct FVector A );
	float VSizeSq ( struct FVector A );
	float VSize2D ( struct FVector A );
	float VSize ( struct FVector A );
	struct FVector SubtractEqual_VectorVector ( struct FVector B, struct FVector* A );
	struct FVector AddEqual_VectorVector ( struct FVector B, struct FVector* A );
	struct FVector DivideEqual_VectorFloat ( float B, struct FVector* A );
	struct FVector MultiplyEqual_VectorVector ( struct FVector B, struct FVector* A );
	struct FVector MultiplyEqual_VectorFloat ( float B, struct FVector* A );
	struct FVector Cross_VectorVector ( struct FVector A, struct FVector B );
	float Dot_VectorVector ( struct FVector A, struct FVector B );
	bool NotEqual_VectorVector ( struct FVector A, struct FVector B );
	bool EqualEqual_VectorVector ( struct FVector A, struct FVector B );
	struct FVector GreaterGreater_VectorRotator ( struct FVector A, struct FRotator B );
	struct FVector LessLess_VectorRotator ( struct FVector A, struct FRotator B );
	struct FVector Subtract_VectorVector ( struct FVector A, struct FVector B );
	struct FVector Add_VectorVector ( struct FVector A, struct FVector B );
	struct FVector Divide_VectorFloat ( struct FVector A, float B );
	struct FVector Multiply_VectorVector ( struct FVector A, struct FVector B );
	struct FVector Multiply_FloatVector ( float A, struct FVector B );
	struct FVector Multiply_VectorFloat ( struct FVector A, float B );
	struct FVector Subtract_PreVector ( struct FVector A );
	float FInterpConstantTo ( float Current, float Target, float DeltaTime, float InterpSpeed );
	float FInterpTo ( float Current, float Target, float DeltaTime, float InterpSpeed );
	float FPctByRange ( float Value, float InMin, float InMax );
	float RandRange ( float InMin, float InMax );
	float FInterpEaseInOut ( float A, float B, float Alpha, float Exp );
	float FInterpEaseOut ( float A, float B, float Alpha, float Exp );
	float FInterpEaseIn ( float A, float B, float Alpha, float Exp );
	float FCubicInterp ( float P0, float T0, float P1, float T1, float A );
	int FCeil ( float A );
	int FFloor ( float A );
	int Round ( float A );
	float Lerp ( float A, float B, float Alpha );
	float FClamp ( float V, float A, float B );
	float FMax ( float A, float B );
	float FMin ( float A, float B );
	float FRand ( );
	float Square ( float A );
	float Sqrt ( float A );
	float Loge ( float A );
	float Exp ( float A );
	float Atan2 ( float A, float B );
	float Atan ( float A );
	float Tan ( float A );
	float Acos ( float A );
	float Cos ( float A );
	float Asin ( float A );
	float Sin ( float A );
	float Abs ( float A );
	float SubtractEqual_FloatFloat ( float B, float* A );
	float AddEqual_FloatFloat ( float B, float* A );
	float DivideEqual_FloatFloat ( float B, float* A );
	float MultiplyEqual_FloatFloat ( float B, float* A );
	bool NotEqual_FloatFloat ( float A, float B );
	bool ComplementEqual_FloatFloat ( float A, float B );
	bool EqualEqual_FloatFloat ( float A, float B );
	bool GreaterEqual_FloatFloat ( float A, float B );
	bool LessEqual_FloatFloat ( float A, float B );
	bool Greater_FloatFloat ( float A, float B );
	bool Less_FloatFloat ( float A, float B );
	float Subtract_FloatFloat ( float A, float B );
	float Add_FloatFloat ( float A, float B );
	float Percent_FloatFloat ( float A, float B );
	float Divide_FloatFloat ( float A, float B );
	float Multiply_FloatFloat ( float A, float B );
	float MultiplyMultiply_FloatFloat ( float Base, float Exp );
	float Subtract_PreFloat ( float A );
	struct FString ToHex ( int A );
	int Clamp ( int V, int A, int B );
	int Max ( int A, int B );
	int Min ( int A, int B );
	int Rand ( int Max );
	int SubtractSubtract_Int ( int* A );
	int AddAdd_Int ( int* A );
	int SubtractSubtract_PreInt ( int* A );
	int AddAdd_PreInt ( int* A );
	int SubtractEqual_IntInt ( int B, int* A );
	int AddEqual_IntInt ( int B, int* A );
	int DivideEqual_IntFloat ( float B, int* A );
	int MultiplyEqual_IntFloat ( float B, int* A );
	int Or_IntInt ( int A, int B );
	int Xor_IntInt ( int A, int B );
	int And_IntInt ( int A, int B );
	bool NotEqual_IntInt ( int A, int B );
	bool EqualEqual_IntInt ( int A, int B );
	bool GreaterEqual_IntInt ( int A, int B );
	bool LessEqual_IntInt ( int A, int B );
	bool Greater_IntInt ( int A, int B );
	bool Less_IntInt ( int A, int B );
	int GreaterGreaterGreater_IntInt ( int A, int B );
	int GreaterGreater_IntInt ( int A, int B );
	int LessLess_IntInt ( int A, int B );
	int Subtract_IntInt ( int A, int B );
	int Add_IntInt ( int A, int B );
	int Percent_IntInt ( int A, int B );
	int Divide_IntInt ( int A, int B );
	int Multiply_IntInt ( int A, int B );
	int Subtract_PreInt ( int A );
	int Complement_PreInt ( int A );
	unsigned char SubtractSubtract_Byte ( unsigned char* A );
	unsigned char AddAdd_Byte ( unsigned char* A );
	unsigned char SubtractSubtract_PreByte ( unsigned char* A );
	unsigned char AddAdd_PreByte ( unsigned char* A );
	unsigned char SubtractEqual_ByteByte ( unsigned char B, unsigned char* A );
	unsigned char AddEqual_ByteByte ( unsigned char B, unsigned char* A );
	unsigned char DivideEqual_ByteByte ( unsigned char B, unsigned char* A );
	unsigned char MultiplyEqual_ByteFloat ( float B, unsigned char* A );
	unsigned char MultiplyEqual_ByteByte ( unsigned char B, unsigned char* A );
	bool OrOr_BoolBool ( unsigned long A, unsigned long B );
	bool XorXor_BoolBool ( unsigned long A, unsigned long B );
	bool AndAnd_BoolBool ( unsigned long A, unsigned long B );
	bool NotEqual_BoolBool ( unsigned long A, unsigned long B );
	bool EqualEqual_BoolBool ( unsigned long A, unsigned long B );
	bool Not_PreBool ( unsigned long A );

	// Virtual Functions  (0x14098EE00)
	virtual void VirtualFunction00 ( );																			// 0x13F27C440 (0x00)
	virtual void VirtualFunction01 ( );																			// 0x13F160D10 (0x08)
	virtual void VirtualFunction02 ( );																			// 0x13F15EBC0 (0x10)
	virtual void VirtualFunction03 ( );																			// 0x13F27C440 (0x18)
	virtual void VirtualFunction04 ( );																			// 0x13FCCF5D0 (0x20)
	virtual void VirtualFunction05 ( );																			// 0x13FCCF5D0 (0x28)
	virtual void VirtualFunction06 ( );																			// 0x13F1AF270 (0x30)
	virtual void VirtualFunction07 ( );																			// 0x13F1AF2D0 (0x38)
	virtual void VirtualFunction08 ( );																			// 0x13F1316E0 (0x40)
	virtual void VirtualFunction09 ( );																			// 0x13F1B5860 (0x48)
	virtual void VirtualFunction10 ( );																			// 0x13F27C440 (0x50)
	virtual void VirtualFunction11 ( );																			// 0x13F1A23E0 (0x58)
	virtual void VirtualFunction12 ( );																			// 0x13F152CB0 (0x60)
	virtual void VirtualFunction13 ( );																			// 0x13F15CF90 (0x68)
	virtual void VirtualFunction14 ( );																			// 0x13F11B260 (0x70)
	virtual void VirtualFunction15 ( );																			// 0x13FCCF5D0 (0x78)
	virtual void VirtualFunction16 ( );																			// 0x13F1A9620 (0x80)
	virtual void VirtualFunction17 ( );																			// 0x13F1A0E90 (0x88)
	virtual void VirtualFunction18 ( );																			// 0x13F1AEFA0 (0x90)
	virtual void VirtualFunction19 ( );																			// 0x13F1A96F0 (0x98)
	virtual void VirtualFunction20 ( );																			// 0x13F1A1660 (0xA0)
	virtual void VirtualFunction21 ( );																			// 0x13F1A0EB0 (0xA8)
	virtual void VirtualFunction22 ( );																			// 0x13F1A1670 (0xB0)
	virtual void VirtualFunction23 ( );																			// 0x13FCCF5D0 (0xB8)
	virtual void VirtualFunction24 ( );																			// 0x13FCCF5D0 (0xC0)
	virtual void VirtualFunction25 ( );																			// 0x13FCCF5D0 (0xC8)
	virtual void VirtualFunction26 ( );																			// 0x13FCCF5D0 (0xD0)
	virtual void VirtualFunction27 ( );																			// 0x13FCCF5D0 (0xD8)
	virtual void VirtualFunction28 ( );																			// 0x13FCCF5D0 (0xE0)
	virtual void VirtualFunction29 ( );																			// 0x13F1A0EA0 (0xE8)
	virtual void VirtualFunction30 ( );																			// 0x13F1A0EB0 (0xF0)
	virtual void VirtualFunction31 ( );																			// 0x13F1A1670 (0xF8)
	virtual void VirtualFunction32 ( );																			// 0x13F1A0EB0 (0x100)
	virtual void VirtualFunction33 ( );																			// 0x13F1A1670 (0x108)
	virtual void VirtualFunction34 ( );																			// 0x13F1AB210 (0x110)
	virtual void VirtualFunction35 ( );																			// 0x13F1A97F0 (0x118)
	virtual void VirtualFunction36 ( );																			// 0x13F1A9A20 (0x120)
	virtual void VirtualFunction37 ( );																			// 0x13FCCF5D0 (0x128)
	virtual void VirtualFunction38 ( );																			// 0x13F14CFF0 (0x130)
	virtual void VirtualFunction39 ( );																			// 0x13FCCF5D0 (0x138)
	virtual void VirtualFunction40 ( );																			// 0x13F0E5940 (0x140)
	virtual void VirtualFunction41 ( );																			// 0x13F0E5960 (0x148)
	virtual void VirtualFunction42 ( );																			// 0x13F0E5980 (0x150)
	virtual void VirtualFunction43 ( );																			// 0x13FC85FF0 (0x158)
	virtual void VirtualFunction44 ( );																			// 0x13F0E6FC0 (0x160)
	virtual void VirtualFunction45 ( );																			// 0x13FC85FF0 (0x168)
	virtual void VirtualFunction46 ( );																			// 0x13FCCF5D0 (0x170)
	virtual void VirtualFunction47 ( );																			// 0x13FCCF5D0 (0x178)
	virtual void VirtualFunction48 ( );																			// 0x13FCCF5D0 (0x180)
	virtual void VirtualFunction49 ( );																			// 0x13FC85FF0 (0x188)
	virtual void VirtualFunction50 ( );																			// 0x13F719E00 (0x190)
	virtual void VirtualFunction51 ( );																			// 0x13F720CF0 (0x198)
	virtual void VirtualFunction52 ( );																			// 0x13F14D070 (0x1A0)
	virtual void VirtualFunction53 ( );																			// 0x13F156FD0 (0x1A8)
	virtual void VirtualFunction54 ( );																			// 0x13FCCF5D0 (0x1B0)
	virtual void VirtualFunction55 ( );																			// 0x13FCCF5D0 (0x1B8)
	virtual void VirtualFunction56 ( );																			// 0x13F1314E0 (0x1C0)
	virtual void VirtualFunction57 ( );																			// 0x13F15E9A0 (0x1C8)
	virtual void VirtualFunction58 ( );																			// 0x13F1A2E10 (0x1D0)
	virtual void VirtualFunction59 ( );																			// 0x13FC85FF0 (0x1D8)
	virtual void VirtualFunction60 ( );																			// 0x13F1A1650 (0x1E0)
	virtual void VirtualFunction61 ( );																			// 0x13F1B22A0 (0x1E8)
	virtual void VirtualFunction62 ( );																			// 0x13F118940 (0x1F0)
	virtual void VirtualFunction63 ( );																			// 0x13F1BD530 (0x1F8)
	virtual void VirtualFunction64 ( );																			// 0x13FC85FF0 (0x200)
	virtual void VirtualFunction65 ( );																			// 0x13F0E4370 (0x208)
	virtual void VirtualFunction66 ( );																			// 0x13F0E43A0 (0x210)
	virtual void VirtualFunction67 ( );																			// 0x13F1C43C0 (0x218)
	virtual void VirtualFunction68 ( );																			// 0x13F1A0EE0 (0x220)
	virtual void VirtualFunction69 ( );																			// 0x13F15B520 (0x228)
	virtual void ProcessEvent ( class UFunction* pFunction, void* pParms, void* pResult = NULL );				// 0x13F151BC0 (0x230)
};



// Class Core.TextBuffer ( Property size: 0 iter: 0) 
// Class name index: 152 
// 0x002C (0x008C - 0x0060)
class UTextBuffer : public UObject
{
public:
//	 LastOffset: 60
//	 Class Propsize: 8c
	unsigned char                                      UnknownData00[ 0x2C ];                            		// 0x0060 (0x002C) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 1 ];

		return pClassPointer;
	};

};



// Class Core.Subsystem ( Property size: 1 iter: 1) 
// Class name index: 156 
// 0x0008 (0x0068 - 0x0060)
class USubsystem : public UObject
{
public:
	struct FPointer                                    VfTable_FExec;                                    		// 0x0060 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 6 ];

		return pClassPointer;
	};

};



// Class Core.System ( Property size: 20 iter: 20) 
// Class name index: 744 
// 0x0104 (0x016C - 0x0068)
class USystem : public USubsystem
{
public:
	int                                                StaleCacheDays;                                   		// 0x0068 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MaxStaleCacheSize;                                		// 0x006C (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MaxOverallCacheSize;                              		// 0x0070 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                PackageSizeSoftLimit;                             		// 0x0074 (0x0004) [0x0000000000004000]              ( CPF_Config )
	float                                              AsyncIOBandwidthLimit;                            		// 0x0078 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FString                                     SavePath;                                         		// 0x007C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     CachePath;                                        		// 0x008C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     CacheExt;                                         		// 0x009C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           Paths;                                            		// 0x00AC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           SeekFreePCPaths;                                  		// 0x00BC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           H7DataPaths;                                      		// 0x00CC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           ScriptPaths;                                      		// 0x00DC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           FRScriptPaths;                                    		// 0x00EC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           CutdownPaths;                                     		// 0x00FC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FName >                             Suppress;                                         		// 0x010C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           Extensions;                                       		// 0x011C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           SeekFreePCExtensions;                             		// 0x012C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           LocalizationPaths;                                		// 0x013C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           KnownLanguageLocalizationPaths;                   		// 0x014C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     TextureFileCacheExtension;                        		// 0x015C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 5 ];

		return pClassPointer;
	};

};



// Class Core.PackageMap ( Property size: 0 iter: 0) 
// Class name index: 4760 
// 0x00A0 (0x0100 - 0x0060)
class UPackageMap : public UObject
{
public:
//	 LastOffset: 60
//	 Class Propsize: 100
	unsigned char                                      UnknownData00[ 0xA0 ];                            		// 0x0060 (0x00A0) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 40 ];

		return pClassPointer;
	};

};



// Class Core.ObjectSerializer ( Property size: 0 iter: 0) 
// Class name index: 4762 
// 0x0010 (0x0070 - 0x0060)
class UObjectSerializer : public UObject
{
public:
//	 LastOffset: 60
//	 Class Propsize: 70
	unsigned char                                      UnknownData00[ 0x10 ];                            		// 0x0060 (0x0010) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 42 ];

		return pClassPointer;
	};

};



// Class Core.ObjectRedirector ( Property size: 0 iter: 0) 
// Class name index: 165 
// 0x0008 (0x0068 - 0x0060)
class UObjectRedirector : public UObject
{
public:
//	 LastOffset: 60
//	 Class Propsize: 68
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0060 (0x0008) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 44 ];

		return pClassPointer;
	};

};



// Class Core.MetaData ( Property size: 0 iter: 0) 
// Class name index: 4765 
// 0x0048 (0x00A8 - 0x0060)
class UMetaData : public UObject
{
public:
//	 LastOffset: 60
//	 Class Propsize: a8
	unsigned char                                      UnknownData00[ 0x48 ];                            		// 0x0060 (0x0048) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 46 ];

		return pClassPointer;
	};

};



// Class Core.Linker ( Property size: 0 iter: 0) 
// Class name index: 153 
// 0x0168 (0x01C8 - 0x0060)
class ULinker : public UObject
{
public:
//	 LastOffset: 60
//	 Class Propsize: 1c8
	unsigned char                                      UnknownData00[ 0x168 ];                           		// 0x0060 (0x0168) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 49 ];

		return pClassPointer;
	};

};



// Class Core.LinkerSave ( Property size: 0 iter: 0) 
// Class name index: 155 
// 0x00B4 (0x027C - 0x01C8)
class ULinkerSave : public ULinker
{
public:
//	 LastOffset: 1c8
//	 Class Propsize: 27c
	unsigned char                                      UnknownData00[ 0xB4 ];                            		// 0x01C8 (0x00B4) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 48 ];

		return pClassPointer;
	};

};



// Class Core.LinkerLoad ( Property size: 0 iter: 0) 
// Class name index: 154 
// 0x0604 (0x07CC - 0x01C8)
class ULinkerLoad : public ULinker
{
public:
//	 LastOffset: 1c8
//	 Class Propsize: 7cc
	unsigned char                                      UnknownData00[ 0x604 ];                           		// 0x01C8 (0x0604) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 52 ];

		return pClassPointer;
	};

};



// Class Core.Interface ( Property size: 0 iter: 0) 
// Class name index: 951 
// 0x0000 (0x0060 - 0x0060)
class UInterface : public UObject
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 54 ];

		return pClassPointer;
	};

};



// Class Core.Field ( Property size: 0 iter: 0) 
// Class name index: 150 
// 0x0008 (0x0068 - 0x0060)
class UField : public UObject
{
public:
	class UField*                                      Next;                                             		// NOT AUTO-GENERATED PROPERTY 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 58 ];

		return pClassPointer;
	};

};



// Class Core.Struct ( Property size: 0 iter: 0) 
// Class name index: 86 
// 0x0068 (0x00D0 - 0x0068)
class UStruct : public UField
{
public:
	unsigned char                                      UnknownData00[ 0x10 ];                                    // NOT AUTO-GENERATED PROPERTY 
	class UField*                                      SuperField;                                              // NOT AUTO-GENERATED PROPERTY 
	class UField*                                      Children;                                                // NOT AUTO-GENERATED PROPERTY 
	unsigned long                                      PropertySize;                                            // NOT AUTO-GENERATED PROPERTY 
	unsigned char                                      UnknownData01[ 0x44 ];                                   // NOT AUTO-GENERATED PROPERTY 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 57 ];

		return pClassPointer;
	};

};



// Class Core.ScriptStruct ( Property size: 0 iter: 0) 
// Class name index: 4771 
// 0x0024 (0x00F4 - 0x00D0)
class UScriptStruct : public UStruct
{
public:
//	 LastOffset: d0
//	 Class Propsize: f4
	unsigned char                                      UnknownData00[ 0x24 ];                            		// 0x00D0 (0x0024) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 56 ];

		return pClassPointer;
	};

};



// Class Core.Function ( Property size: 0 iter: 0) 
// Class name index: 103 
// 0x0028 (0x00F8 - 0x00D0)
class UFunction : public UStruct
{
public:
	unsigned long		FunctionFlags;								// 0x0090 (0x04)  // 0x00D0                // NOT AUTO-GENERATED PROPERTY 
	unsigned short		iNative;									// 0x0094 (0x02)  // 0x00D4                // NOT AUTO-GENERATED PROPERTY 
	unsigned short		RepOffset;									// 0x0096 (0x02)  // 0x00D6                // NOT AUTO-GENERATED PROPERTY 
	struct FName		FriendlyName;								// 0x0098 (0x08)  // 0x00D8                // NOT AUTO-GENERATED PROPERTY 
	unsigned char       UnkByte;                                     // 0x00A0 (0x02) // 0x00E0  (0x01)        // NOT AUTO-GENERATED PROPERTY 
	unsigned char		NumParms;								    //                // 0x00E1  (0x01)        // NOT AUTO-GENERATED PROPERTY 
	unsigned short		ParmsSize;									// 0x00A2 (0x02)  // 0x00E2                // NOT AUTO-GENERATED PROPERTY 
	unsigned long		ReturnValueOffset;							// 0x00A4 (0x04)  // 0x00E4                // NOT AUTO-GENERATED PROPERTY 
	unsigned char		UnknownData00[ 0x8 ];						// 0x00A8 (0x04)  // 0x00E8  (0x08)        // NOT AUTO-GENERATED PROPERTY 
	void*				Func;									    // 0x00AC (0x04)  // 0x00F0                // NOT AUTO-GENERATED PROPERTY 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 62 ];

		return pClassPointer;
	};

};



// Class Core.Property ( Property size: 0 iter: 0) 
// Class name index: 161 
// 0x0040 (0x00A8 - 0x0068)
class UProperty : public UField
{
public:
                                                                    // x32           // x64    unsigned long		ArrayDim;									// 0x0040 (0x04) // 0x0068					// NOT AUTO-GENERATED PROPERTY 
   unsigned long		ElementSize;								// 0x0044 (0x04) // 0x006C                  // NOT AUTO-GENERATED PROPERTY 
   FQWord				PropertyFlags;								// 0x0048 (0x08) // 0x0070                  // NOT AUTO-GENERATED PROPERTY 
   unsigned char		UnknownData00[ 0x14 ];						// 0x0050 (0x10) // 0x0078  //0x14          // NOT AUTO-GENERATED PROPERTY 
   unsigned long		Offset;										// 0x0060 (0x04) // 0x008C                  // NOT AUTO-GENERATED PROPERTY 
   unsigned char		UnknownData01[ 0x18 ];						// 0x0064 (0x1C) // 0x0090 //0x18           // NOT AUTO-GENERATED PROPERTY 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 65 ];

		return pClassPointer;
	};

};



// Class Core.StructProperty ( Property size: 0 iter: 0) 
// Class name index: 10 
// 0x0008 (0x00B0 - 0x00A8)
class UStructProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: b0
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x00A8 (0x0008) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 64 ];

		return pClassPointer;
	};

};



// Class Core.StrProperty ( Property size: 0 iter: 0) 
// Class name index: 13 
// 0x0000 (0x00A8 - 0x00A8)
class UStrProperty : public UProperty
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 68 ];

		return pClassPointer;
	};

};



// Class Core.ObjectProperty ( Property size: 0 iter: 0) 
// Class name index: 5 
// 0x0008 (0x00B0 - 0x00A8)
class UObjectProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: b0
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x00A8 (0x0008) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 71 ];

		return pClassPointer;
	};

};



// Class Core.DynLoadObjectProperty ( Property size: 0 iter: 0) 
// Class name index: 4779 
// 0x0000 (0x00B0 - 0x00B0)
class UDynLoadObjectProperty : public UObjectProperty
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 70 ];

		return pClassPointer;
	};

};



// Class Core.ComponentProperty ( Property size: 0 iter: 0) 
// Class name index: 4782 
// 0x0000 (0x00B0 - 0x00B0)
class UComponentProperty : public UObjectProperty
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 74 ];

		return pClassPointer;
	};

};



// Class Core.ClassProperty ( Property size: 0 iter: 0) 
// Class name index: 8 
// 0x0008 (0x00B8 - 0x00B0)
class UClassProperty : public UObjectProperty
{
public:
//	 LastOffset: b0
//	 Class Propsize: b8
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x00B0 (0x0008) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 76 ];

		return pClassPointer;
	};

};



// Class Core.NameProperty ( Property size: 0 iter: 0) 
// Class name index: 6 
// 0x0000 (0x00A8 - 0x00A8)
class UNameProperty : public UProperty
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 78 ];

		return pClassPointer;
	};

};



// Class Core.MapProperty ( Property size: 0 iter: 0) 
// Class name index: 14 
// 0x0010 (0x00B8 - 0x00A8)
class UMapProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: b8
	unsigned char                                      UnknownData00[ 0x10 ];                            		// 0x00A8 (0x0010) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 80 ];

		return pClassPointer;
	};

};



// Class Core.IntProperty ( Property size: 0 iter: 0) 
// Class name index: 2 
// 0x0000 (0x00A8 - 0x00A8)
class UIntProperty : public UProperty
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 82 ];

		return pClassPointer;
	};

};



// Class Core.InterfaceProperty ( Property size: 0 iter: 0) 
// Class name index: 15 
// 0x0008 (0x00B0 - 0x00A8)
class UInterfaceProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: b0
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x00A8 (0x0008) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 84 ];

		return pClassPointer;
	};

};



// Class Core.FloatProperty ( Property size: 0 iter: 0) 
// Class name index: 4 
// 0x0000 (0x00A8 - 0x00A8)
class UFloatProperty : public UProperty
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 86 ];

		return pClassPointer;
	};

};



// Class Core.DelegateProperty ( Property size: 0 iter: 0) 
// Class name index: 7 
// 0x0010 (0x00B8 - 0x00A8)
class UDelegateProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: b8
	unsigned char                                      UnknownData00[ 0x10 ];                            		// 0x00A8 (0x0010) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 88 ];

		return pClassPointer;
	};

};



// Class Core.ByteProperty ( Property size: 0 iter: 0) 
// Class name index: 1 
// 0x0008 (0x00B0 - 0x00A8)
class UByteProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: b0
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x00A8 (0x0008) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 90 ];

		return pClassPointer;
	};

};



// Class Core.BoolProperty ( Property size: 0 iter: 0) 
// Class name index: 3 
// 0x0004 (0x00AC - 0x00A8)
class UBoolProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: ac
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00A8 (0x0004) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 92 ];

		return pClassPointer;
	};

};



// Class Core.ArrayProperty ( Property size: 0 iter: 0) 
// Class name index: 9 
// 0x0008 (0x00B0 - 0x00A8)
class UArrayProperty : public UProperty
{
public:
//	 LastOffset: a8
//	 Class Propsize: b0
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x00A8 (0x0008) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 94 ];

		return pClassPointer;
	};

};



// Class Core.Enum ( Property size: 0 iter: 0) 
// Class name index: 117 
// 0x0010 (0x0078 - 0x0068)
class UEnum : public UField
{
public:
//	 LastOffset: 68
//	 Class Propsize: 78
	unsigned char                                      UnknownData00[ 0x10 ];                            		// 0x0068 (0x0010) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 96 ];

		return pClassPointer;
	};

};



// Class Core.Const ( Property size: 0 iter: 0) 
// Class name index: 641 
// 0x0010 (0x0078 - 0x0068)
class UConst : public UField
{
public:
//	 LastOffset: 68
//	 Class Propsize: 78
	unsigned char                                      UnknownData00[ 0x10 ];                            		// 0x0068 (0x0010) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 98 ];

		return pClassPointer;
	};

};



// Class Core.Factory ( Property size: 10 iter: 10) 
// Class name index: 157 
// 0x0048 (0x00A8 - 0x0060)
class UFactory : public UObject
{
public:
	class UClass*                                      SupportedClass;                                   		// 0x0060 (0x0008) [0x0000000000000000]              
	class UClass*                                      ContextClass;                                     		// 0x0068 (0x0008) [0x0000000000000000]              
	struct FString                                     Description;                                      		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           Formats;                                          		// 0x0080 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bCreateNew : 1;                                   		// 0x0090 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bEditAfterNew : 1;                                		// 0x0090 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bEditorImport : 1;                                		// 0x0090 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      bText : 1;                                        		// 0x0090 (0x0004) [0x0000000000000000] [0x00000008] 
	int                                                AutoPriority;                                     		// 0x0094 (0x0004) [0x0000000000000000]              
	TArray< struct FString >                           ValidGameNames;                                   		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 101 ];

		return pClassPointer;
	};

};



// Class Core.TextBufferFactory ( Property size: 0 iter: 0) 
// Class name index: 158 
// 0x0000 (0x00A8 - 0x00A8)
class UTextBufferFactory : public UFactory
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 100 ];

		return pClassPointer;
	};

};



// Class Core.Exporter ( Property size: 2 iter: 2) 
// Class name index: 159 
// 0x0034 (0x0094 - 0x0060)
class UExporter : public UObject
{
public:
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0060 (0x0008) MISSED OFFSET
	TArray< struct FString >                           FormatExtension;                                  		// 0x0068 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           FormatDescription;                                		// 0x0078 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
//	 LastOffset: 88
//	 Class Propsize: 94
	unsigned char                                      UnknownData01[ 0xC ];                             		// 0x0088 (0x000C) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 104 ];

		return pClassPointer;
	};

};



// Class Core.Component ( Property size: 2 iter: 2) 
// Class name index: 693 
// 0x0010 (0x0070 - 0x0060)
class UComponent : public UObject
{
public:
	class UClass*                                      TemplateOwnerClass;                               		// 0x0060 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FName                                       TemplateName;                                     		// 0x0068 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 111 ];

		return pClassPointer;
	};

};



// Class Core.DistributionVector ( Property size: 3 iter: 7) 
// Class name index: 4751 
// 0x000C (0x007C - 0x0070)
class UDistributionVector : public UComponent
{
public:
	struct FPointer                                    VfTable_FCurveEdInterface;                        		// 0x0070 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	unsigned long                                      bCanBeBaked : 1;                                  		// 0x0078 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bIsDirty : 1;                                     		// 0x0078 (0x0004) [0x0000000000000000] [0x00000002] 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 110 ];

		return pClassPointer;
	};

	struct FVector GetVectorValue ( float F, int LastExtreme );
};



// Class Core.DistributionFloat ( Property size: 3 iter: 6) 
// Class name index: 4750 
// 0x000C (0x007C - 0x0070)
class UDistributionFloat : public UComponent
{
public:
	struct FPointer                                    VfTable_FCurveEdInterface;                        		// 0x0070 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	unsigned long                                      bCanBeBaked : 1;                                  		// 0x0078 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bIsDirty : 1;                                     		// 0x0078 (0x0004) [0x0000000000000000] [0x00000002] 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 114 ];

		return pClassPointer;
	};

	float GetFloatValue ( float F );
};



// Class Core.Commandlet ( Property size: 10 iter: 11) 
// Class name index: 4805 
// 0x0054 (0x00B4 - 0x0060)
class UCommandlet : public UObject
{
public:
	struct FString                                     HelpDescription;                                  		// 0x0060 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	struct FString                                     HelpUsage;                                        		// 0x0070 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	struct FString                                     HelpWebLink;                                      		// 0x0080 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	TArray< struct FString >                           HelpParamNames;                                   		// 0x0090 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	TArray< struct FString >                           HelpParamDescriptions;                            		// 0x00A0 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	unsigned long                                      IsServer : 1;                                     		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      IsClient : 1;                                     		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      IsEditor : 1;                                     		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      LogToConsole : 1;                                 		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      ShowErrorCount : 1;                               		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000010] 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 117 ];

		return pClassPointer;
	};

	int eventMain ( struct FString Params );
};



// Class Core.HelpCommandlet ( Property size: 0 iter: 1) 
// Class name index: 4804 
// 0x0000 (0x00B4 - 0x00B4)
class UHelpCommandlet : public UCommandlet
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 116 ];

		return pClassPointer;
	};

	int eventMain ( struct FString Params );
};



// Class Core.State ( Property size: 0 iter: 0) 
// Class name index: 102 
// 0x0054 (0x0124 - 0x00D0)
class UState : public UStruct
{
public:
//	 LastOffset: d0
//	 Class Propsize: 124
	unsigned char                                      UnknownData00[ 0x54 ];                            		// 0x00D0 (0x0054) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 120 ];

		return pClassPointer;
	};

};



// Class Core.Package ( Property size: 0 iter: 0) 
// Class name index: 674 
// 0x00D4 (0x0134 - 0x0060)
class UPackage : public UObject
{
public:
//	 LastOffset: 60
//	 Class Propsize: 134
	unsigned char                                      UnknownData00[ 0xD4 ];                            		// 0x0060 (0x00D4) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 122 ];

		return pClassPointer;
	};

};



// Class Core.Class ( Property size: 0 iter: 0) 
// Class name index: 677 
// 0x014C (0x0270 - 0x0124)
class UClass : public UState
{
public:
//	 LastOffset: 124
//	 Class Propsize: 270
	unsigned char                                      UnknownData00[ 0x14C ];                           		// 0x0124 (0x014C) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 124 ];

		return pClassPointer;
	};

};




#ifdef _MSC_VER
	#pragma pack ( pop )
#endif