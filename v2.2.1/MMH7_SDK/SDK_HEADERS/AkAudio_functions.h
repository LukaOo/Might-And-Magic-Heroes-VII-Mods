#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: AkAudio_functions.h
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

// Function AkAudio.AkAmbientSound.StopPlayback
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void AAkAmbientSound::StopPlayback ( )
{
	static UFunction* pFnStopPlayback = NULL;

	if ( ! pFnStopPlayback )
		pFnStopPlayback = (UFunction*) UObject::GObjObjects()->Data[ 47201 ];

	AAkAmbientSound_execStopPlayback_Parms StopPlayback_Parms;

	pFnStopPlayback->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStopPlayback, &StopPlayback_Parms, NULL );

	pFnStopPlayback->FunctionFlags |= 0x400;
};

// Function AkAudio.AkAmbientSound.StartPlayback
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void AAkAmbientSound::StartPlayback ( )
{
	static UFunction* pFnStartPlayback = NULL;

	if ( ! pFnStartPlayback )
		pFnStartPlayback = (UFunction*) UObject::GObjObjects()->Data[ 47200 ];

	AAkAmbientSound_execStartPlayback_Parms StartPlayback_Parms;

	pFnStartPlayback->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStartPlayback, &StartPlayback_Parms, NULL );

	pFnStartPlayback->FunctionFlags |= 0x400;
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif