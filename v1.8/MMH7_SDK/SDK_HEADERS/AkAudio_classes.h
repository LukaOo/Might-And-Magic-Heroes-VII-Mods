#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: AkAudio_classes.h
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

// Class AkAudio.ActorFactoryAkAmbientSound ( Property size: 1 iter: 1) 
// Class name index: 7780 
// 0x0008 (0x00A4 - 0x009C)
class UActorFactoryAkAmbientSound : public UActorFactory
{
public:
	class UAkEvent*                                    AmbientEvent;                                     		// 0x009C (0x0008) [0x0000000000000001]              ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3027 ];

		return pClassPointer;
	};

};



// Class AkAudio.AkAmbientSound ( Property size: 4 iter: 6) 
// Class name index: 7782 
// 0x000C (0x0254 - 0x0248)
class AAkAmbientSound : public AKeypoint
{
public:
	unsigned long                                      bAutoPlay : 1;                                    		// 0x0248 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      StopWhenOwnerIsDestroyed : 1;                     		// 0x0248 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bIsPlaying : 1;                                   		// 0x0248 (0x0004) [0x0000000000002000] [0x00000004] ( CPF_Transient )
	class UAkEvent*                                    PlayEvent;                                        		// 0x024C (0x0008) [0x0000000000000001]              ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3029 ];

		return pClassPointer;
	};

	void StopPlayback ( );
	void StartPlayback ( );
};



// Class AkAudio.AkAudioDevice ( Property size: 0 iter: 0) 
// Class name index: 7784 
// 0x0010 (0x0078 - 0x0068)
class UAkAudioDevice : public USubsystem
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
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3031 ];

		return pClassPointer;
	};

};



// Class AkAudio.AkComponent ( Property size: 3 iter: 3) 
// Class name index: 7786 
// 0x0017 (0x009C - 0x0085)
class UAkComponent : public UActorComponent
{
public:
	struct FName                                       BoneName;                                         		// 0x0088 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UAkEvent*                                    AutoPlayEvent;                                    		// 0x0090 (0x0008) [0x0000000000000000]              
	unsigned long                                      bStopWhenOwnerDestroyed : 1;                      		// 0x0098 (0x0004) [0x0000000000000000] [0x00000001] 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3033 ];

		return pClassPointer;
	};

};



// Class AkAudio.InterpTrackAkEvent ( Property size: 1 iter: 2) 
// Class name index: 7788 
// 0x0010 (0x00D0 - 0x00C0)
class UInterpTrackAkEvent : public UInterpTrack
{
public:
	TArray< struct FAkEventTrackKey >                  AkEvents;                                         		// 0x00C0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3035 ];

		return pClassPointer;
	};

};



// Class AkAudio.InterpTrackAkRTPC ( Property size: 1 iter: 1) 
// Class name index: 7790 
// 0x0010 (0x00E8 - 0x00D8)
class UInterpTrackAkRTPC : public UInterpTrackFloatBase
{
public:
	struct FString                                     Param;                                            		// 0x00D8 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3037 ];

		return pClassPointer;
	};

};



// Class AkAudio.InterpTrackInstAkEvent ( Property size: 2 iter: 2) 
// Class name index: 7792 
// 0x0008 (0x0068 - 0x0060)
class UInterpTrackInstAkEvent : public UInterpTrackInst
{
public:
	float                                              LastUpdatePosition;                               		// 0x0060 (0x0004) [0x0000000000000000]              
	unsigned long                                      WaitsForCallBack : 1;                             		// 0x0064 (0x0004) [0x0000000000000000] [0x00000001] 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3039 ];

		return pClassPointer;
	};

};



// Class AkAudio.InterpTrackInstAkRTPC ( Property size: 0 iter: 0) 
// Class name index: 7794 
// 0x0000 (0x0060 - 0x0060)
class UInterpTrackInstAkRTPC : public UInterpTrackInst
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3041 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkClearBanks ( Property size: 0 iter: 0) 
// Class name index: 7796 
// 0x0000 (0x0154 - 0x0154)
class USeqAct_AkClearBanks : public USequenceAction
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3043 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkLoadBank ( Property size: 4 iter: 4) 
// Class name index: 7798 
// 0x0010 (0x017C - 0x016C)
class USeqAct_AkLoadBank : public USeqAct_Latent
{
public:
	unsigned long                                      Async : 1;                                        		// 0x016C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bWaitingCallback : 1;                             		// 0x016C (0x0004) [0x0000000000002000] [0x00000002] ( CPF_Transient )
	class UAkBank*                                     Bank;                                             		// 0x0170 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Signal;                                           		// 0x0178 (0x0004) [0x0000000000002000]              ( CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3045 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkPostEvent ( Property size: 2 iter: 2) 
// Class name index: 7800 
// 0x000C (0x0178 - 0x016C)
class USeqAct_AkPostEvent : public USeqAct_Latent
{
public:
	int                                                Signal;                                           		// 0x016C (0x0004) [0x0000000000002000]              ( CPF_Transient )
	class UAkEvent*                                    Event;                                            		// 0x0170 (0x0008) [0x0000000000000001]              ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3047 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkPostTrigger ( Property size: 1 iter: 1) 
// Class name index: 7802 
// 0x0010 (0x0164 - 0x0154)
class USeqAct_AkPostTrigger : public USequenceAction
{
public:
	struct FString                                     Trigger;                                          		// 0x0154 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3049 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkSetRTPCValue ( Property size: 3 iter: 3) 
// Class name index: 7804 
// 0x0018 (0x0184 - 0x016C)
class USeqAct_AkSetRTPCValue : public USeqAct_Latent
{
public:
	struct FString                                     Param;                                            		// 0x016C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	float                                              Value;                                            		// 0x017C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      Running : 1;                                      		// 0x0180 (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3051 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkSetRTPCValueBus ( Property size: 3 iter: 3) 
// Class name index: 7806 
// 0x0018 (0x0184 - 0x016C)
class USeqAct_AkSetRTPCValueBus : public USeqAct_Latent
{
public:
	struct FString                                     Param;                                            		// 0x016C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	float                                              Value;                                            		// 0x017C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      Running : 1;                                      		// 0x0180 (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3053 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkSetState ( Property size: 2 iter: 2) 
// Class name index: 7808 
// 0x0020 (0x0174 - 0x0154)
class USeqAct_AkSetState : public USequenceAction
{
public:
	struct FString                                     StateGroup;                                       		// 0x0154 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     State;                                            		// 0x0164 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3055 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkSetSwitch ( Property size: 2 iter: 2) 
// Class name index: 7810 
// 0x0020 (0x0174 - 0x0154)
class USeqAct_AkSetSwitch : public USequenceAction
{
public:
	struct FString                                     SwitchGroup;                                      		// 0x0154 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Switch;                                           		// 0x0164 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3057 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkStartAmbientSound ( Property size: 0 iter: 0) 
// Class name index: 7812 
// 0x0000 (0x0154 - 0x0154)
class USeqAct_AkStartAmbientSound : public USequenceAction
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3059 ];

		return pClassPointer;
	};

};



// Class AkAudio.SeqAct_AkStopAll ( Property size: 0 iter: 0) 
// Class name index: 7814 
// 0x0000 (0x0154 - 0x0154)
class USeqAct_AkStopAll : public USequenceAction
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3061 ];

		return pClassPointer;
	};

};




#ifdef _MSC_VER
	#pragma pack ( pop )
#endif