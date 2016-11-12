#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: OnlineSubsystemUPlay_structs.h
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

// ScriptStruct OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.GameInviteInfo
// 0x00000008
struct FGameInviteInfo
{
//	 vPoperty_Size=1
	struct FPointer                                    SessionInfo;                                      		// 0x0000 (0x0008) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct OnlineSubsystemUPlay.OnlineSubsystemUPlay.WorkshopInstalledItemDef
// 0x00000018
struct FWorkshopInstalledItemDef
{
//	 vPoperty_Size=3
	struct FString                                     Fullpath;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                SizeOnDisk;                                       		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                TimeStamp;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif