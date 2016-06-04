#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: IpDrv_f_structs.h
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

// Function IpDrv.Base64.TestStringVersion
// [0x00022002] 
struct UBase64_execTestStringVersion_Parms
{
	// struct FString                                  ThreeByteString;                                  		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  FourByteString;                                   		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  FiveByteString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  InternetSample;                                   		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  EncodedString;                                    		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  DecodedString;                                    		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.Base64.DecodeString
// [0x00022400] ( FUNC_Native )
struct UBase64_execDecodeString_Parms
{
	struct FString                                     Source;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.Base64.EncodeString
// [0x00022400] ( FUNC_Native )
struct UBase64_execEncodeString_Parms
{
	struct FString                                     Source;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.Base64.Decode
// [0x00422400] ( FUNC_Native )
struct UBase64_execDecode_Parms
{
	struct FString                                     Source;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            Dest;                                             		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.Base64.Encode
// [0x00422400] ( FUNC_Native )
struct UBase64_execEncode_Parms
{
	TArray< unsigned char >                            Source;                                           		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.InternetLink.ResolveFailed
// [0x00020800] ( FUNC_Event )
struct AInternetLink_eventResolveFailed_Parms
{
};

// Function IpDrv.InternetLink.Resolved
// [0x00020800] ( FUNC_Event )
struct AInternetLink_eventResolved_Parms
{
	struct FIpAddr                                     Addr;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.InternetLink.GetLocalIP
// [0x00420400] ( FUNC_Native )
struct AInternetLink_execGetLocalIP_Parms
{
	struct FIpAddr                                     Arg;                                              		// 0x0000 (0x0008) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function IpDrv.InternetLink.StringToIpAddr
// [0x00420400] ( FUNC_Native )
struct AInternetLink_execStringToIpAddr_Parms
{
	struct FString                                     Str;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FIpAddr                                     Addr;                                             		// 0x0010 (0x0008) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.InternetLink.IpAddrToString
// [0x00020400] ( FUNC_Native )
struct AInternetLink_execIpAddrToString_Parms
{
	struct FIpAddr                                     Arg;                                              		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0008 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.InternetLink.GetLastError
// [0x00020400] ( FUNC_Native )
struct AInternetLink_execGetLastError_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.InternetLink.Resolve
// [0x00020400] ( FUNC_Native )
struct AInternetLink_execResolve_Parms
{
	struct FString                                     Domain;                                           		// 0x0000 (0x0010) [0x0000000000400880]              ( CPF_Parm | CPF_CoerceParm | CPF_NeedCtorLink )
};

// Function IpDrv.InternetLink.ParseURL
// [0x00420400] ( FUNC_Native )
struct AInternetLink_execParseURL_Parms
{
	struct FString                                     URL;                                              		// 0x0000 (0x0010) [0x0000000000400880]              ( CPF_Parm | CPF_CoerceParm | CPF_NeedCtorLink )
	struct FString                                     Addr;                                             		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                PortNum;                                          		// 0x0020 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	struct FString                                     LevelName;                                        		// 0x0024 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     EntryName;                                        		// 0x0034 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0044 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.InternetLink.IsDataPending
// [0x00020400] ( FUNC_Native )
struct AInternetLink_execIsDataPending_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.ReceivedBinary
// [0x00020800] ( FUNC_Event )
struct ATcpLink_eventReceivedBinary_Parms
{
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      B[ 0xFF ];                                        		// 0x0004 (0x00FF) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TcpLink.ReceivedLine
// [0x00020800] ( FUNC_Event )
struct ATcpLink_eventReceivedLine_Parms
{
	struct FString                                     Line;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TcpLink.ReceivedText
// [0x00020800] ( FUNC_Event )
struct ATcpLink_eventReceivedText_Parms
{
	struct FString                                     Text;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TcpLink.Closed
// [0x00020800] ( FUNC_Event )
struct ATcpLink_eventClosed_Parms
{
};

// Function IpDrv.TcpLink.Opened
// [0x00020800] ( FUNC_Event )
struct ATcpLink_eventOpened_Parms
{
};

// Function IpDrv.TcpLink.Accepted
// [0x00020800] ( FUNC_Event )
struct ATcpLink_eventAccepted_Parms
{
};

// Function IpDrv.TcpLink.ReadBinary
// [0x00420400] ( FUNC_Native )
struct ATcpLink_execReadBinary_Parms
{
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      B[ 0xFF ];                                        		// 0x0004 (0x00FF) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	int                                                ReturnValue;                                      		// 0x0104 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.ReadText
// [0x00420400] ( FUNC_Native )
struct ATcpLink_execReadText_Parms
{
	struct FString                                     Str;                                              		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.SendBinary
// [0x00020400] ( FUNC_Native )
struct ATcpLink_execSendBinary_Parms
{
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      B[ 0xFF ];                                        		// 0x0004 (0x00FF) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0104 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.SendText
// [0x00020400] ( FUNC_Native )
struct ATcpLink_execSendText_Parms
{
	struct FString                                     Str;                                              		// 0x0000 (0x0010) [0x0000000000400880]              ( CPF_Parm | CPF_CoerceParm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.IsConnected
// [0x00020400] ( FUNC_Native )
struct ATcpLink_execIsConnected_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.Close
// [0x00020400] ( FUNC_Native )
struct ATcpLink_execClose_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.Open
// [0x00020400] ( FUNC_Native )
struct ATcpLink_execOpen_Parms
{
	struct FIpAddr                                     Addr;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.Listen
// [0x00020400] ( FUNC_Native )
struct ATcpLink_execListen_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TcpLink.BindPort
// [0x00024400] ( FUNC_Native )
struct ATcpLink_execBindPort_Parms
{
	int                                                PortNum;                                          		// 0x0000 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bUseNextAvailable : 1;                            		// 0x0004 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0008 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpServiceBase.UnrealDateTimeToServerDateTime
// [0x00020002] 
struct UMcpServiceBase_execUnrealDateTimeToServerDateTime_Parms
{
	struct FString                                     UnrealDateTime;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  ConvertedDateTime;                                		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Time;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Date;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0050 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpServiceBase.ServerDateTimeToUnrealDateTime
// [0x00020002] 
struct UMcpServiceBase_execServerDateTimeToUnrealDateTime_Parms
{
	struct FString                                     ServerDateTime;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  ConvertedDateTime;                                		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Time;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Date;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0050 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpServiceBase.UseGameServiceAuth
// [0x00020002] 
struct UMcpServiceBase_execUseGameServiceAuth_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpServiceBase.CreateHttpRequestGameAuth
// [0x00020002] 
struct UMcpServiceBase_execCreateHttpRequestGameAuth_Parms
{
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0008 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpServiceBase.UseBasicAuth
// [0x00020002] 
struct UMcpServiceBase_execUseBasicAuth_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     UserName;                                         		// 0x0008 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Password;                                         		// 0x0018 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceBase.CreateHttpRequest
// [0x00024002] 
struct UMcpServiceBase_execCreateHttpRequest_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0018 (0x0008) [0x0000000000000000]              
	// class UMcpUserAuthRequestWrapper*               WrappingRequest;                                  		// 0x0020 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpServiceBase.GetEngineVersionToReport
// [0x00020400] ( FUNC_Native )
struct UMcpServiceBase_execGetEngineVersionToReport_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpServiceBase.GetUserAgent
// [0x00020002] 
struct UMcpServiceBase_execGetUserAgent_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceBase.AddUserAuthorization
// [0x00020002] 
struct UMcpServiceBase_execAddUserAuthorization_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     McpId;                                            		// 0x0008 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UMcpUserManagerBase*                      UserManager;                                      		// 0x0018 (0x0008) [0x0000000000000000]              
	// struct FString                                  AuthToken;                                        		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceBase.GetUserAuthURL
// [0x00020002] 
struct UMcpServiceBase_execGetUserAuthURL_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  AuthTicket;                                       		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceBase.GetAppAccessURL
// [0x00020002] 
struct UMcpServiceBase_execGetAppAccessURL_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceBase.IsSuccessCode
// [0x00022002] 
struct UMcpServiceBase_execIsSuccessCode_Parms
{
	int                                                StatusCode;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpServiceBase.GetBaseURL
// [0x00020002] 
struct UMcpServiceBase_execGetBaseURL_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceBase.GetSingleton
// [0x00022401] ( FUNC_Final | FUNC_Native )
struct UMcpServiceBase_execGetSingleton_Parms
{
	class UClass*                                      SingletonClass;                                   		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpServiceBase*                             ReturnValue;                                      		// 0x0008 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpServiceBase.IsProduction
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UMcpServiceBase_execIsProduction_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpServiceBase.Init
// [0x00080802] ( FUNC_Event )
struct UMcpServiceBase_eventInit_Parms
{
	// class UClass*                                   McpConfigClass;                                   		// 0x0000 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.OnlineEventsInterfaceMcp.UploadMatchmakingStats
// [0x00020400] ( FUNC_Native )
struct UOnlineEventsInterfaceMcp_execUploadMatchmakingStats_Parms
{
	struct FUniqueNetId                                UniqueId;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineMatchmakingStats*                     MMStats;                                          		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineEventsInterfaceMcp.UpdatePlaylistPopulation
// [0x00020400] ( FUNC_Native )
struct UOnlineEventsInterfaceMcp_execUpdatePlaylistPopulation_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                NumPlayers;                                       		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineEventsInterfaceMcp.UploadGameplayEventsData
// [0x00420400] ( FUNC_Native )
struct UOnlineEventsInterfaceMcp_execUploadGameplayEventsData_Parms
{
	struct FUniqueNetId                                UniqueId;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< unsigned char >                            Payload;                                          		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineEventsInterfaceMcp.UploadPlayerData
// [0x00020400] ( FUNC_Native )
struct UOnlineEventsInterfaceMcp_execUploadPlayerData_Parms
{
	struct FUniqueNetId                                UniqueId;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     PlayerNick;                                       		// 0x0008 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UOnlineProfileSettings*                      ProfileSettings;                                  		// 0x0018 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlinePlayerStorage*                        PlayerStorage;                                    		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0028 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineNewsInterfaceMcp.GetNews
// [0x00020002] 
struct UOnlineNewsInterfaceMcp_execGetNews_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      NewsType;                                         		// 0x0001 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             NewsIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineNewsInterfaceMcp.ClearReadNewsCompletedDelegate
// [0x00020002] 
struct UOnlineNewsInterfaceMcp_execClearReadNewsCompletedDelegate_Parms
{
	struct FScriptDelegate                             ReadGameNewsDelegate;                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineNewsInterfaceMcp.AddReadNewsCompletedDelegate
// [0x00020002] 
struct UOnlineNewsInterfaceMcp_execAddReadNewsCompletedDelegate_Parms
{
	struct FScriptDelegate                             ReadNewsDelegate;                                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineNewsInterfaceMcp.OnReadNewsCompleted
// [0x00120000] 
struct UOnlineNewsInterfaceMcp_execOnReadNewsCompleted_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned char                                      NewsType;                                         		// 0x0004 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineNewsInterfaceMcp.ReadNews
// [0x00020400] ( FUNC_Native )
struct UOnlineNewsInterfaceMcp_execReadNews_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      NewsType;                                         		// 0x0001 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadBase.GetTitleFileList
// [0x00420000] 
struct UOnlineTitleFileDownloadBase_execGetTitleFileList_Parms
{
	TArray< struct FEmsFile >                          FileList;                                         		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadBase.GetUrlForFile
// [0x00020400] ( FUNC_Native )
struct UOnlineTitleFileDownloadBase_execGetUrlForFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadBase.ClearRequestTitleFileListCompleteDelegate
// [0x00020002] 
struct UOnlineTitleFileDownloadBase_execClearRequestTitleFileListCompleteDelegate_Parms
{
	struct FScriptDelegate                             RequestTitleFileListDelegate;                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineTitleFileDownloadBase.AddRequestTitleFileListCompleteDelegate
// [0x00020002] 
struct UOnlineTitleFileDownloadBase_execAddRequestTitleFileListCompleteDelegate_Parms
{
	struct FScriptDelegate                             RequestTitleFileListDelegate;                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadBase.OnRequestTitleFileListComplete
// [0x00120000] 
struct UOnlineTitleFileDownloadBase_execOnRequestTitleFileListComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ResultStr;                                        		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadBase.RequestTitleFileList
// [0x00020000] 
struct UOnlineTitleFileDownloadBase_execRequestTitleFileList_Parms
{
};

// Function IpDrv.OnlineTitleFileDownloadBase.ClearDownloadedFile
// [0x00020000] 
struct UOnlineTitleFileDownloadBase_execClearDownloadedFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadBase.ClearDownloadedFiles
// [0x00020000] 
struct UOnlineTitleFileDownloadBase_execClearDownloadedFiles_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadBase.GetTitleFileState
// [0x00020000] 
struct UOnlineTitleFileDownloadBase_execGetTitleFileState_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0010 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadBase.GetTitleFileContents
// [0x00420000] 
struct UOnlineTitleFileDownloadBase_execGetTitleFileContents_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadBase.ClearReadTitleFileCompleteDelegate
// [0x00020002] 
struct UOnlineTitleFileDownloadBase_execClearReadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadTitleFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineTitleFileDownloadBase.AddReadTitleFileCompleteDelegate
// [0x00020002] 
struct UOnlineTitleFileDownloadBase_execAddReadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadTitleFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadBase.ReadTitleFile
// [0x00020000] 
struct UOnlineTitleFileDownloadBase_execReadTitleFile_Parms
{
	struct FString                                     FileToRead;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadBase.OnReadTitleFileComplete
// [0x00120000] 
struct UOnlineTitleFileDownloadBase_execOnReadTitleFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadMcp.ClearDownloadedFile
// [0x00020400] ( FUNC_Native )
struct UOnlineTitleFileDownloadMcp_execClearDownloadedFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadMcp.ClearDownloadedFiles
// [0x00020400] ( FUNC_Native )
struct UOnlineTitleFileDownloadMcp_execClearDownloadedFiles_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadMcp.GetTitleFileState
// [0x00020002] 
struct UOnlineTitleFileDownloadMcp_execGetTitleFileState_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0010 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineTitleFileDownloadMcp.GetTitleFileContents
// [0x00420400] ( FUNC_Native )
struct UOnlineTitleFileDownloadMcp_execGetTitleFileContents_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadMcp.ReadTitleFile
// [0x00020400] ( FUNC_Native )
struct UOnlineTitleFileDownloadMcp_execReadTitleFile_Parms
{
	struct FString                                     FileToRead;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.GetUrlForFile
// [0x00020002] 
struct UOnlineTitleFileDownloadWeb_execGetUrlForFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.OnFileListReceived
// [0x00020002] 
struct UOnlineTitleFileDownloadWeb_execOnFileListReceived_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bDidSucceed : 1;                                  		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          RequestTitleFileListDelegate;                     		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseStr;                                      		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bSuccess : 1;                                     		// 0x0038 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.OnlineTitleFileDownloadWeb.RequestTitleFileList
// [0x00020002] 
struct UOnlineTitleFileDownloadWeb_execRequestTitleFileList_Parms
{
	// class UHttpRequestInterface*                    HTTPRequest;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.ClearDownloadedFile
// [0x00020400] ( FUNC_Native )
struct UOnlineTitleFileDownloadWeb_execClearDownloadedFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.ClearDownloadedFiles
// [0x00020400] ( FUNC_Native )
struct UOnlineTitleFileDownloadWeb_execClearDownloadedFiles_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.GetTitleFileState
// [0x00020002] 
struct UOnlineTitleFileDownloadWeb_execGetTitleFileState_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0010 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineTitleFileDownloadWeb.GetTitleFileContents
// [0x00420400] ( FUNC_Native )
struct UOnlineTitleFileDownloadWeb_execGetTitleFileContents_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.TriggerDelegates
// [0x00040401] ( FUNC_Final | FUNC_Native )
struct UOnlineTitleFileDownloadWeb_execTriggerDelegates_Parms
{
	unsigned long                                      bSuccess : 1;                                     		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     FileRead;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.OnFileDownloadComplete
// [0x00040003] ( FUNC_Final )
struct UOnlineTitleFileDownloadWeb_execOnFileDownloadComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bDidSucceed : 1;                                  		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// unsigned long                                   bSuccess : 1;                                     		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             FileIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             Idx;                                              		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  Filename;                                         		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< unsigned char >                         BinaryData;                                       		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  FileCompressionTypeString;                        		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.ReadTitleFile
// [0x00020002] 
struct UOnlineTitleFileDownloadWeb_execReadTitleFile_Parms
{
	struct FString                                     FileToRead;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             Idx;                                              		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.OnlineTitleFileDownloadWeb.UncompressTitleFileContents
// [0x00420400] ( FUNC_Native )
struct UOnlineTitleFileDownloadWeb_execUncompressTitleFileContents_Parms
{
	unsigned char                                      FileCompressionType;                              		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< unsigned char >                            CompressedFileContents;                           		// 0x0004 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	TArray< unsigned char >                            UncompressedFileContents;                         		// 0x0014 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0024 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.DeleteTitleFile
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execDeleteTitleFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.DeleteTitleFiles
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execDeleteTitleFiles_Parms
{
	float                                              MaxAgeSeconds;                                    		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.ClearCachedFile
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execClearCachedFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.ClearCachedFiles
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execClearCachedFiles_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.GetTitleFileLogicalName
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execGetTitleFileLogicalName_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.TitleFileDownloadCache.GetTitleFileHash
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execGetTitleFileHash_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.TitleFileDownloadCache.GetTitleFileState
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execGetTitleFileState_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0010 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.GetTitleFileContents
// [0x00420400] ( FUNC_Native )
struct UTitleFileDownloadCache_execGetTitleFileContents_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.ClearSaveTitleFileCompleteDelegate
// [0x00020002] 
struct UTitleFileDownloadCache_execClearSaveTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             SaveCompleteDelegate;                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TitleFileDownloadCache.AddSaveTitleFileCompleteDelegate
// [0x00020002] 
struct UTitleFileDownloadCache_execAddSaveTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             SaveCompleteDelegate;                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TitleFileDownloadCache.OnSaveTitleFileComplete
// [0x00120000] 
struct UTitleFileDownloadCache_execOnSaveTitleFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TitleFileDownloadCache.SaveTitleFile
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execSaveTitleFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LogicalName;                                      		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TitleFileDownloadCache.ClearLoadTitleFileCompleteDelegate
// [0x00020002] 
struct UTitleFileDownloadCache_execClearLoadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             LoadCompleteDelegate;                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TitleFileDownloadCache.AddLoadTitleFileCompleteDelegate
// [0x00020002] 
struct UTitleFileDownloadCache_execAddLoadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             LoadCompleteDelegate;                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TitleFileDownloadCache.OnLoadTitleFileComplete
// [0x00120000] 
struct UTitleFileDownloadCache_execOnLoadTitleFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TitleFileDownloadCache.LoadTitleFile
// [0x00020400] ( FUNC_Native )
struct UTitleFileDownloadCache_execLoadTitleFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpMessageBase.GetMessageContents
// [0x00420000] 
struct UMcpMessageBase_execGetMessageContents_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            MessageContents;                                  		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpMessageBase.OnQueryMessageContentsComplete
// [0x00120000] 
struct UMcpMessageBase_execOnQueryMessageContentsComplete_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.QueryMessageContents
// [0x00020000] 
struct UMcpMessageBase_execQueryMessageContents_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.GetMessageList
// [0x00420000] 
struct UMcpMessageBase_execGetMessageList_Parms
{
	struct FString                                     ToUniqueUserId;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpMessageList                             MessageList;                                      		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.OnQueryMessagesComplete
// [0x00120000] 
struct UMcpMessageBase_execOnQueryMessagesComplete_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.QueryMessages
// [0x00020000] 
struct UMcpMessageBase_execQueryMessages_Parms
{
	struct FString                                     ToUniqueUserId;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.OnDeleteMessageComplete
// [0x00120000] 
struct UMcpMessageBase_execOnDeleteMessageComplete_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.DeleteMessage
// [0x00020000] 
struct UMcpMessageBase_execDeleteMessage_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.OnCreateMessageComplete
// [0x00120000] 
struct UMcpMessageBase_execOnCreateMessageComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.CreateMessage
// [0x00420000] 
struct UMcpMessageBase_execCreateMessage_Parms
{
	TArray< struct FString >                           ToUniqueUserIds;                                  		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     FromUniqueUserId;                                 		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FromFriendlyName;                                 		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageType;                                      		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PushMessage;                                      		// 0x0040 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ValidUntil;                                       		// 0x0050 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            MessageContents;                                  		// 0x0060 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpMessageBase_execCreateInstance_Parms
{
	class UMcpMessageBase*                             ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpMessageBaseClass;                              		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpMessageBase*                          NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.CacheMessageContents
// [0x00420002] 
struct UMcpMessageManager_execCacheMessageContents_Parms
{
	TArray< unsigned char >                            MessageContents;                                  		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             MessageContentsIndex;                             		// 0x0024 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bWasSuccessful : 1;                               		// 0x0028 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpMessageManager.GetMessageById
// [0x00420002] 
struct UMcpMessageManager_execGetMessageById_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpMessage                                 Message;                                          		// 0x0010 (0x0064) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0074 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             MessageListsSize;                                 		// 0x0078 (0x0004) [0x0000000000000000]              
	// int                                             MessageListsItr;                                  		// 0x007C (0x0004) [0x0000000000000000]              
	// int                                             MessageItr;                                       		// 0x0080 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.CacheMessage
// [0x00820002] 
struct UMcpMessageManager_execCacheMessage_Parms
{
	struct FMcpMessage                                 Message;                                          		// 0x0000 (0x0064) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             AddAt;                                            		// 0x0064 (0x0004) [0x0000000000000000]              
	// int                                             MessageIndex;                                     		// 0x0068 (0x0004) [0x0000000000000000]              
	// int                                             MessageListIndex;                                 		// 0x006C (0x0004) [0x0000000000000000]              
	// struct FMcpMessageList                          UserMessageList;                                  		// 0x0070 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bWasFound : 1;                                    		// 0x0090 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpMessageManager.GetMessageContents
// [0x00420002] 
struct UMcpMessageManager_execGetMessageContents_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            MessageContents;                                  		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// unsigned long                                   bWasSuccessful : 1;                               		// 0x0024 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             MessageContentsIndex;                             		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.OnQueryMessageContentsRequestComplete
// [0x00840003] ( FUNC_Final )
struct UMcpMessageManager_execOnQueryMessageContentsRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// TArray< unsigned char >                         MessageContents;                                  		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MessageId;                                        		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FMcpMessage                              Message;                                          		// 0x0038 (0x0064) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManager.QueryMessageContents
// [0x00020002] 
struct UMcpMessageManager_execQueryMessageContents_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    QueryMessageContentsRequest;                      		// 0x0030 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.GetMessageList
// [0x00420002] 
struct UMcpMessageManager_execGetMessageList_Parms
{
	struct FString                                     ToUniqueUserId;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpMessageList                             MessageList;                                      		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             MessageListIndex;                                 		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.OnQueryMessagesRequestComplete
// [0x00840003] ( FUNC_Final )
struct UMcpMessageManager_execOnQueryMessagesRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JsonString;                                       		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0038 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FMcpMessage                              Message;                                          		// 0x0044 (0x0064) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MessageCompressionTypeString;                     		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManager.QueryMessages
// [0x00020002] 
struct UMcpMessageManager_execQueryMessages_Parms
{
	struct FString                                     ToUniqueUserId;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    QueryMessagesRequest;                             		// 0x0020 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.OnDeleteMessageRequestComplete
// [0x00020002] 
struct UMcpMessageManager_execOnDeleteMessageRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MessageId;                                        		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManager.DeleteMessage
// [0x00020002] 
struct UMcpMessageManager_execDeleteMessage_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    DeleteMessageRequest;                             		// 0x0030 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.OnCreateMessageRequestComplete
// [0x00020002] 
struct UMcpMessageManager_execOnCreateMessageRequestComplete_Parms
{
	class UHttpRequestInterface*                       CreateMessageRequest;                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManager.CreateMessage
// [0x00420002] 
struct UMcpMessageManager_execCreateMessage_Parms
{
	TArray< struct FString >                           ToUniqueUserIds;                                  		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     FromUniqueUserId;                                 		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FromFriendlyName;                                 		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageType;                                      		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PushMessage;                                      		// 0x0040 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ValidUntil;                                       		// 0x0050 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            MessageContents;                                  		// 0x0060 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    CreateMessageRequest;                             		// 0x0080 (0x0008) [0x0000000000000000]              
	// struct FString                                  ToUniqueUserIdsStr;                               		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Idx;                                              		// 0x0098 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManager.FinishedAsyncUncompression
// [0x00420802] ( FUNC_Event )
struct UMcpMessageManager_eventFinishedAsyncUncompression_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	TArray< unsigned char >                            UncompressedMessageContents;                      		// 0x0004 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManager.StartAsyncUncompression
// [0x00420400] ( FUNC_Native )
struct UMcpMessageManager_execStartAsyncUncompression_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      MessageCompressionType;                           		// 0x0010 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< unsigned char >                            MessageContent;                                   		// 0x0014 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0024 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpMessageManager.StartAsyncCompression
// [0x00420400] ( FUNC_Native )
struct UMcpMessageManager_execStartAsyncCompression_Parms
{
	unsigned char                                      MessageCompressionType;                           		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< unsigned char >                            MessageContent;                                   		// 0x0004 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0014 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserCloudFileDownload.GetLastNCloudSaveOwners
// [0x00420000] 
struct UMcpUserCloudFileDownload_execGetLastNCloudSaveOwners_Parms
{
	TArray< struct FString >                           McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.ClearReadLastNCloudSaveOwnersCompleteDelegate
// [0x00020000] 
struct UMcpUserCloudFileDownload_execClearReadLastNCloudSaveOwnersCompleteDelegate_Parms
{
	struct FScriptDelegate                             CompleteDelegate;                                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.AddReadLastNCloudSaveOwnersCompleteDelegate
// [0x00020000] 
struct UMcpUserCloudFileDownload_execAddReadLastNCloudSaveOwnersCompleteDelegate_Parms
{
	struct FScriptDelegate                             CompleteDelegate;                                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnReadLastNCloudSaveOwnersComplete
// [0x00120000] 
struct UMcpUserCloudFileDownload_execOnReadLastNCloudSaveOwnersComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.McpUserCloudFileDownload.ReadLastNCloudSaveOwners
// [0x00024000] 
struct UMcpUserCloudFileDownload_execReadLastNCloudSaveOwners_Parms
{
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.ClearAllDelegates
// [0x00020002] 
struct UMcpUserCloudFileDownload_execClearAllDelegates_Parms
{
};

// Function IpDrv.McpUserCloudFileDownload.ClearDeleteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execClearDeleteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             DeleteUserFileCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileDownload.AddDeleteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execAddDeleteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             DeleteUserFileCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.CallDeleteUserFileCompleteDelegates
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execCallDeleteUserFileCompleteDelegates_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          CallDelegate;                                     		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnDeleteUserFileComplete
// [0x00120000] 
struct UMcpUserCloudFileDownload_execOnDeleteUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnHTTPRequestDeleteUserFileComplete
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execOnHTTPRequestDeleteUserFileComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             EntryIdx;                                         		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  Filename;                                         		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UserId;                                           		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x003C (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileDownload.DeleteUserFile
// [0x00020002] 
struct UMcpUserCloudFileDownload_execDeleteUserFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldCloudDelete : 1;                           		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      bShouldLocallyDelete : 1;                         		// 0x0024 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0028 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             EntryIdx;                                         		// 0x002C (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0030 (0x0004) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bPending : 1;                                     		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileDownload.ClearWriteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execClearWriteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             WriteUserFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileDownload.AddWriteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execAddWriteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             WriteUserFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.CallWriteUserFileCompleteDelegates
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execCallWriteUserFileCompleteDelegates_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          CallDelegate;                                     		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnWriteUserFileComplete
// [0x00120000] 
struct UMcpUserCloudFileDownload_execOnWriteUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnHTTPRequestWriteUserFileComplete
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execOnHTTPRequestWriteUserFileComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             EntryIdx;                                         		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  Filename;                                         		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UserId;                                           		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x003C (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileDownload.GetUserFileIndexForRequest
// [0x00440003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execGetUserFileIndexForRequest_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                UserIdx;                                          		// 0x0008 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	int                                                FileIdx;                                          		// 0x000C (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function IpDrv.McpUserCloudFileDownload.WriteUserFile
// [0x00420002] 
struct UMcpUserCloudFileDownload_execWriteUserFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             EntryIdx;                                         		// 0x0034 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bPending : 1;                                     		// 0x004C (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileDownload.ClearReadUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execClearReadUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadUserFileCompleteDelegate;                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileDownload.AddReadUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execAddReadUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadUserFileCompleteDelegate;                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.CallReadUserFileCompleteDelegates
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execCallReadUserFileCompleteDelegates_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          CallDelegate;                                     		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnReadUserFileComplete
// [0x00120000] 
struct UMcpUserCloudFileDownload_execOnReadUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnHTTPRequestReadUserFileComplete
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execOnHTTPRequestReadUserFileComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             EntryIdx;                                         		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  Filename;                                         		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UserId;                                           		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x003C (0x0004) [0x0000000000000000] [0x00000001] 
	// TArray< unsigned char >                         FileContents;                                     		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.ReadUserFile
// [0x00020002] 
struct UMcpUserCloudFileDownload_execReadUserFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             EntryIdx;                                         		// 0x0024 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0028 (0x0004) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bPending : 1;                                     		// 0x003C (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileDownload.GetUserFileList
// [0x00420002] 
struct UMcpUserCloudFileDownload_execGetUserFileList_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FEmsFile >                          UserFiles;                                        		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             EntryIdx;                                         		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileDownload.ClearEnumerateUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execClearEnumerateUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             EnumerateUserFileCompleteDelegate;                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileDownload.AddEnumerateUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileDownload_execAddEnumerateUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             EnumerateUserFileCompleteDelegate;                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.CallEnumerateUserFileCompleteDelegates
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execCallEnumerateUserFileCompleteDelegates_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          CallDelegate;                                     		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnEnumerateUserFilesComplete
// [0x00120000] 
struct UMcpUserCloudFileDownload_execOnEnumerateUserFilesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileDownload.OnHTTPRequestEnumerateUserFilesComplete
// [0x00040003] ( FUNC_Final )
struct UMcpUserCloudFileDownload_execOnHTTPRequestEnumerateUserFilesComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             EntryIdx;                                         		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             JsonIdx;                                          		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonString;                                       		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UserId;                                           		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x003C (0x0008) [0x0000000000000000]              
	// unsigned long                                   bResult : 1;                                      		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileDownload.EnumerateUserFiles
// [0x00020002] 
struct UMcpUserCloudFileDownload_execEnumerateUserFiles_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             EntryIdx;                                         		// 0x0010 (0x0004) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bPending : 1;                                     		// 0x0024 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileDownload.ClearFile
// [0x00020002] 
struct UMcpUserCloudFileDownload_execClearFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// unsigned long                                   bResult : 1;                                      		// 0x0024 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             EntryIdx;                                         		// 0x0028 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x002C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileDownload.ClearFiles
// [0x00020002] 
struct UMcpUserCloudFileDownload_execClearFiles_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// unsigned long                                   bResult : 1;                                      		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             EntryIdx;                                         		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileDownload.GetFileContents
// [0x00420002] 
struct UMcpUserCloudFileDownload_execGetFileContents_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// unsigned long                                   bResult : 1;                                      		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             EntryIdx;                                         		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x003C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.MeshBeacon.DestroyBeacon
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UMeshBeacon_eventDestroyBeacon_Parms
{
};

// Function IpDrv.MeshBeaconClient.SendHostNewGameSessionResponse
// [0x00420400] ( FUNC_Native )
struct UMeshBeaconClient_execSendHostNewGameSessionResponse_Parms
{
	unsigned long                                      bSuccess : 1;                                     		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x000C (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0014 (0x0050) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0064 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconClient.OnCreateNewSessionRequestReceived
// [0x00520000] 
struct UMeshBeaconClient_execOnCreateNewSessionRequestReceived_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FPlayerMember >                     Players;                                          		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.MeshBeaconClient.OnTravelRequestReceived
// [0x00520000] 
struct UMeshBeaconClient_execOnTravelRequestReceived_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0010 (0x0050) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
};

// Function IpDrv.MeshBeaconClient.OnReceivedBandwidthTestResults
// [0x00520000] 
struct UMeshBeaconClient_execOnReceivedBandwidthTestResults_Parms
{
	unsigned char                                      TestType;                                         		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      TestResult;                                       		// 0x0001 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FConnectionBandwidthStats                   BandwidthStats;                                   		// 0x0004 (0x000C) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
};

// Function IpDrv.MeshBeaconClient.OnReceivedBandwidthTestRequest
// [0x00120000] 
struct UMeshBeaconClient_execOnReceivedBandwidthTestRequest_Parms
{
	unsigned char                                      TestType;                                         		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.MeshBeaconClient.OnConnectionRequestResult
// [0x00120000] 
struct UMeshBeaconClient_execOnConnectionRequestResult_Parms
{
	unsigned char                                      ConnectionResult;                                 		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.MeshBeaconClient.BeginBandwidthTest
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconClient_execBeginBandwidthTest_Parms
{
	unsigned char                                      TestType;                                         		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                TestBufferSize;                                   		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconClient.RequestConnection
// [0x00420400] ( FUNC_Native )
struct UMeshBeaconClient_execRequestConnection_Parms
{
	struct FOnlineGameSearchResult                     DesiredHost;                                      		// 0x0000 (0x0010) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	struct FClientConnectionRequest                    ClientRequest;                                    		// 0x0010 (0x0028) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      bRegisterSecureAddress : 1;                       		// 0x0038 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x003C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconClient.DestroyBeacon
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UMeshBeaconClient_eventDestroyBeacon_Parms
{
};

// Function IpDrv.MeshBeaconHost.OnReceivedClientCreateNewSessionResult
// [0x00520000] 
struct UMeshBeaconHost_execOnReceivedClientCreateNewSessionResult_Parms
{
	unsigned long                                      bSucceeded : 1;                                   		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x000C (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0014 (0x0050) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
};

// Function IpDrv.MeshBeaconHost.RequestClientCreateNewSession
// [0x00420400] ( FUNC_Native )
struct UMeshBeaconHost_execRequestClientCreateNewSession_Parms
{
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FPlayerMember >                     Players;                                          		// 0x0018 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0028 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconHost.TellClientsToTravel
// [0x00420400] ( FUNC_Native )
struct UMeshBeaconHost_execTellClientsToTravel_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0010 (0x0050) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
};

// Function IpDrv.MeshBeaconHost.OnAllPendingPlayersConnected
// [0x00120000] 
struct UMeshBeaconHost_execOnAllPendingPlayersConnected_Parms
{
};

// Function IpDrv.MeshBeaconHost.AllPlayersConnected
// [0x00420400] ( FUNC_Native )
struct UMeshBeaconHost_execAllPlayersConnected_Parms
{
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconHost.GetConnectionIndexForPlayer
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconHost_execGetConnectionIndexForPlayer_Parms
{
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0008 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconHost.SetPendingPlayerConnections
// [0x00420002] 
struct UMeshBeaconHost_execSetPendingPlayerConnections_Parms
{
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.MeshBeaconHost.OnFinishedBandwidthTest
// [0x00520000] 
struct UMeshBeaconHost_execOnFinishedBandwidthTest_Parms
{
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      TestType;                                         		// 0x0008 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      TestResult;                                       		// 0x0009 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FConnectionBandwidthStats                   BandwidthStats;                                   		// 0x000C (0x000C) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
};

// Function IpDrv.MeshBeaconHost.OnStartedBandwidthTest
// [0x00120000] 
struct UMeshBeaconHost_execOnStartedBandwidthTest_Parms
{
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      TestType;                                         		// 0x0008 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.MeshBeaconHost.OnReceivedClientConnectionRequest
// [0x00520000] 
struct UMeshBeaconHost_execOnReceivedClientConnectionRequest_Parms
{
	struct FClientMeshBeaconConnection                 NewClientConnection;                              		// 0x0000 (0x0060) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.MeshBeaconHost.AllowBandwidthTesting
// [0x00020002] 
struct UMeshBeaconHost_execAllowBandwidthTesting_Parms
{
	unsigned long                                      bEnabled : 1;                                     		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.MeshBeaconHost.CancelPendingBandwidthTests
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconHost_execCancelPendingBandwidthTests_Parms
{
};

// Function IpDrv.MeshBeaconHost.HasPendingBandwidthTest
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconHost_execHasPendingBandwidthTest_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconHost.CancelInProgressBandwidthTests
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconHost_execCancelInProgressBandwidthTests_Parms
{
};

// Function IpDrv.MeshBeaconHost.HasInProgressBandwidthTest
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconHost_execHasInProgressBandwidthTest_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconHost.RequestClientBandwidthTest
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconHost_execRequestClientBandwidthTest_Parms
{
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      TestType;                                         		// 0x0008 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                TestBufferSize;                                   		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.MeshBeaconHost.DestroyBeacon
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UMeshBeaconHost_eventDestroyBeacon_Parms
{
};

// Function IpDrv.MeshBeaconHost.InitHostBeacon
// [0x00020400] ( FUNC_Native )
struct UMeshBeaconHost_execInitHostBeacon_Parms
{
	struct FUniqueNetId                                InOwningPlayerId;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineSubsystemCommonImpl.GetRegisteredPlayers
// [0x00420002] 
struct UOnlineSubsystemCommonImpl_execGetRegisteredPlayers_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FUniqueNetId >                      OutRegisteredPlayers;                             		// 0x0008 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Idx;                                              		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             PlayerIdx;                                        		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineSubsystemCommonImpl.IsPlayerInSession
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemCommonImpl_execIsPlayerInSession_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineSubsystemCommonImpl.GetPlayerNicknameFromIndex
// [0x00020800] ( FUNC_Event )
struct UOnlineSubsystemCommonImpl_eventGetPlayerNicknameFromIndex_Parms
{
	int                                                UserIndex;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.GetServerAddr
// [0x00420000] 
struct UOnlineAuthInterfaceImpl_execGetServerAddr_Parms
{
	int                                                OutServerIP;                                      		// 0x0000 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	int                                                OutServerPort;                                    		// 0x0004 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.GetServerUniqueId
// [0x00420000] 
struct UOnlineAuthInterfaceImpl_execGetServerUniqueId_Parms
{
	struct FUniqueNetId                                OutServerUID;                                     		// 0x0000 (0x0008) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.FindLocalServerAuthSession
// [0x00420400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execFindLocalServerAuthSession_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FLocalAuthSession                           OutSessionInfo;                                   		// 0x0008 (0x0014) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.FindServerAuthSession
// [0x00420400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execFindServerAuthSession_Parms
{
	class UPlayer*                                     ServerConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FAuthSession                                OutSessionInfo;                                   		// 0x0008 (0x0018) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.FindLocalClientAuthSession
// [0x00420400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execFindLocalClientAuthSession_Parms
{
	class UPlayer*                                     ServerConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FLocalAuthSession                           OutSessionInfo;                                   		// 0x0008 (0x0014) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.FindClientAuthSession
// [0x00420400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execFindClientAuthSession_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FAuthSession                                OutSessionInfo;                                   		// 0x0008 (0x0018) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.AllLocalServerAuthSessions
// [0x00420404] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execAllLocalServerAuthSessions_Parms
{
	struct FLocalAuthSession                           OutSessionInfo;                                   		// 0x0000 (0x0014) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.AllServerAuthSessions
// [0x00420404] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execAllServerAuthSessions_Parms
{
	struct FAuthSession                                OutSessionInfo;                                   		// 0x0000 (0x0018) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.AllLocalClientAuthSessions
// [0x00420404] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execAllLocalClientAuthSessions_Parms
{
	struct FLocalAuthSession                           OutSessionInfo;                                   		// 0x0000 (0x0014) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.AllClientAuthSessions
// [0x00420404] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execAllClientAuthSessions_Parms
{
	struct FAuthSession                                OutSessionInfo;                                   		// 0x0000 (0x0018) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndAllRemoteServerAuthSessions
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndAllRemoteServerAuthSessions_Parms
{
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndAllLocalServerAuthSessions
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndAllLocalServerAuthSessions_Parms
{
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndRemoteServerAuthSession
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndRemoteServerAuthSession_Parms
{
	struct FUniqueNetId                                ServerUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndLocalServerAuthSession
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndLocalServerAuthSession_Parms
{
	struct FUniqueNetId                                ClientUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.VerifyServerAuthSession
// [0x00020000] 
struct UOnlineAuthInterfaceImpl_execVerifyServerAuthSession_Parms
{
	struct FUniqueNetId                                ServerUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                AuthTicketUID;                                    		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.CreateServerAuthSession
// [0x00420000] 
struct UOnlineAuthInterfaceImpl_execCreateServerAuthSession_Parms
{
	struct FUniqueNetId                                ClientUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientPort;                                       		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                OutAuthTicketUID;                                 		// 0x0010 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndAllRemoteClientAuthSessions
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndAllRemoteClientAuthSessions_Parms
{
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndAllLocalClientAuthSessions
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndAllLocalClientAuthSessions_Parms
{
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndRemoteClientAuthSession
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndRemoteClientAuthSession_Parms
{
	struct FUniqueNetId                                ClientUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.EndLocalClientAuthSession
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UOnlineAuthInterfaceImpl_execEndLocalClientAuthSession_Parms
{
	struct FUniqueNetId                                ServerUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerPort;                                       		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.VerifyClientAuthSession
// [0x00020000] 
struct UOnlineAuthInterfaceImpl_execVerifyClientAuthSession_Parms
{
	struct FUniqueNetId                                ClientUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientPort;                                       		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                AuthTicketUID;                                    		// 0x0010 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.CreateClientAuthSession
// [0x00420000] 
struct UOnlineAuthInterfaceImpl_execCreateClientAuthSession_Parms
{
	struct FUniqueNetId                                ServerUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerPort;                                       		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bSecure : 1;                                      		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	int                                                OutAuthTicketUID;                                 		// 0x0014 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.SendServerAuthRetryRequest
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execSendServerAuthRetryRequest_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.SendClientAuthEndSessionRequest
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execSendClientAuthEndSessionRequest_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.SendServerAuthResponse
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execSendServerAuthResponse_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                AuthTicketUID;                                    		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.SendClientAuthResponse
// [0x00020400] ( FUNC_Native )
struct UOnlineAuthInterfaceImpl_execSendClientAuthResponse_Parms
{
	int                                                AuthTicketUID;                                    		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.SendServerAuthRequest
// [0x00020000] 
struct UOnlineAuthInterfaceImpl_execSendServerAuthRequest_Parms
{
	struct FUniqueNetId                                ServerUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.SendClientAuthRequest
// [0x00020000] 
struct UOnlineAuthInterfaceImpl_execSendClientAuthRequest_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                ClientUID;                                        		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearServerConnectionCloseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearServerConnectionCloseDelegate_Parms
{
	struct FScriptDelegate                             ServerConnectionCloseDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddServerConnectionCloseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddServerConnectionCloseDelegate_Parms
{
	struct FScriptDelegate                             ServerConnectionCloseDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnServerConnectionClose
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnServerConnectionClose_Parms
{
	class UPlayer*                                     ServerConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearClientConnectionCloseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearClientConnectionCloseDelegate_Parms
{
	struct FScriptDelegate                             ClientConnectionCloseDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddClientConnectionCloseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddClientConnectionCloseDelegate_Parms
{
	struct FScriptDelegate                             ClientConnectionCloseDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnClientConnectionClose
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnClientConnectionClose_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearServerAuthRetryRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearServerAuthRetryRequestDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthRetryRequestDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddServerAuthRetryRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddServerAuthRetryRequestDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthRetryRequestDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnServerAuthRetryRequest
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnServerAuthRetryRequest_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearClientAuthEndSessionRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearClientAuthEndSessionRequestDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthEndSessionRequestDelegate;              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddClientAuthEndSessionRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddClientAuthEndSessionRequestDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthEndSessionRequestDelegate;              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnClientAuthEndSessionRequest
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnClientAuthEndSessionRequest_Parms
{
	class UPlayer*                                     ServerConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearServerAuthCompleteDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearServerAuthCompleteDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthCompleteDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddServerAuthCompleteDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddServerAuthCompleteDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthCompleteDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnServerAuthComplete
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnServerAuthComplete_Parms
{
	unsigned long                                      bSuccess : 1;                                     		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FUniqueNetId                                ServerUID;                                        		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UPlayer*                                     ServerConnection;                                 		// 0x000C (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ExtraInfo;                                        		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearClientAuthCompleteDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearClientAuthCompleteDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthCompleteDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddClientAuthCompleteDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddClientAuthCompleteDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthCompleteDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnClientAuthComplete
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnClientAuthComplete_Parms
{
	unsigned long                                      bSuccess : 1;                                     		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FUniqueNetId                                ClientUID;                                        		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UPlayer*                                     ClientConnection;                                 		// 0x000C (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ExtraInfo;                                        		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearServerAuthResponseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearServerAuthResponseDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthResponseDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddServerAuthResponseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddServerAuthResponseDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthResponseDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnServerAuthResponse
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnServerAuthResponse_Parms
{
	struct FUniqueNetId                                ServerUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                AuthTicketUID;                                    		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearClientAuthResponseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearClientAuthResponseDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthResponseDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddClientAuthResponseDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddClientAuthResponseDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthResponseDelegate;                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnClientAuthResponse
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnClientAuthResponse_Parms
{
	struct FUniqueNetId                                ClientUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                AuthTicketUID;                                    		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearServerAuthRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearServerAuthRequestDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthRequestDelegate;                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddServerAuthRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddServerAuthRequestDelegate_Parms
{
	struct FScriptDelegate                             ServerAuthRequestDelegate;                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnServerAuthRequest
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnServerAuthRequest_Parms
{
	class UPlayer*                                     ClientConnection;                                 		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                ClientUID;                                        		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientIP;                                         		// 0x0010 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ClientPort;                                       		// 0x0014 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearClientAuthRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearClientAuthRequestDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthRequestDelegate;                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddClientAuthRequestDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddClientAuthRequestDelegate_Parms
{
	struct FScriptDelegate                             ClientAuthRequestDelegate;                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnClientAuthRequest
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnClientAuthRequest_Parms
{
	struct FUniqueNetId                                ServerUID;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerIP;                                         		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ServerPort;                                       		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bSecure : 1;                                      		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineAuthInterfaceImpl.ClearAuthReadyDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execClearAuthReadyDelegate_Parms
{
	struct FScriptDelegate                             AuthReadyDelegate;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineAuthInterfaceImpl.AddAuthReadyDelegate
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execAddAuthReadyDelegate_Parms
{
	struct FScriptDelegate                             AuthReadyDelegate;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineAuthInterfaceImpl.OnAuthReady
// [0x00120000] 
struct UOnlineAuthInterfaceImpl_execOnAuthReady_Parms
{
};

// Function IpDrv.OnlineAuthInterfaceImpl.IsReady
// [0x00020002] 
struct UOnlineAuthInterfaceImpl_execIsReady_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearQosStatusChangedDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execClearQosStatusChangedDelegate_Parms
{
	struct FScriptDelegate                             QosStatusChangedDelegate;                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.AddQosStatusChangedDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAddQosStatusChangedDelegate_Parms
{
	struct FScriptDelegate                             QosStatusChangedDelegate;                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnQosStatusChanged
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnQosStatusChanged_Parms
{
	int                                                NumComplete;                                      		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                NumTotal;                                         		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.BindPlatformSpecificSessionToSearch
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execBindPlatformSpecificSessionToSearch_Parms
{
	unsigned char                                      SearchingPlayerNum;                               		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameSearch*                           SearchSettings;                                   		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x000C (0x0050) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x005C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ReadPlatformSpecificSessionInfoBySessionName
// [0x00420000] 
struct UOnlineGameInterfaceImpl_execReadPlatformSpecificSessionInfoBySessionName_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0008 (0x0050) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0058 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ReadPlatformSpecificSessionInfo
// [0x00420400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execReadPlatformSpecificSessionInfo_Parms
{
	struct FOnlineGameSearchResult                     DesiredGame;                                      		// 0x0000 (0x0010) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0010 (0x0050) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0060 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.QueryNonAdvertisedData
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execQueryNonAdvertisedData_Parms
{
	int                                                StartAt;                                          		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                NumberToQuery;                                    		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearJoinMigratedOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearJoinMigratedOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             JoinMigratedOnlineGameCompleteDelegate;           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddJoinMigratedOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddJoinMigratedOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             JoinMigratedOnlineGameCompleteDelegate;           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnJoinMigratedOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnJoinMigratedOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.JoinMigratedOnlineGame
// [0x00420000] 
struct UOnlineGameInterfaceImpl_execJoinMigratedOnlineGame_Parms
{
	unsigned char                                      PlayerNum;                                        		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FOnlineGameSearchResult                     DesiredGame;                                      		// 0x000C (0x0010) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearMigrateOnlineGameCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execClearMigrateOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             MigrateOnlineGameCompleteDelegate;                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.AddMigrateOnlineGameCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAddMigrateOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             MigrateOnlineGameCompleteDelegate;                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnMigrateOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnMigrateOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.MigrateOnlineGame
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execMigrateOnlineGame_Parms
{
	unsigned char                                      HostingPlayerNum;                                 		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearRecalculateSkillRatingCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execClearRecalculateSkillRatingCompleteDelegate_Parms
{
	struct FScriptDelegate                             RecalculateSkillRatingGameCompleteDelegate;       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.AddRecalculateSkillRatingCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAddRecalculateSkillRatingCompleteDelegate_Parms
{
	struct FScriptDelegate                             RecalculateSkillRatingCompleteDelegate;           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnRecalculateSkillRatingComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnRecalculateSkillRatingComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.RecalculateSkillRating
// [0x00420000] 
struct UOnlineGameInterfaceImpl_execRecalculateSkillRating_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.AcceptGameInvite
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAcceptGameInvite_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearGameInviteAcceptedDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execClearGameInviteAcceptedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             GameInviteAcceptedDelegate;                       		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.AddGameInviteAcceptedDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAddGameInviteAcceptedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             GameInviteAcceptedDelegate;                       		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnGameInviteAccepted
// [0x00520000] 
struct UOnlineGameInterfaceImpl_execOnGameInviteAccepted_Parms
{
	struct FOnlineGameSearchResult                     InviteResult;                                     		// 0x0000 (0x0010) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.GetArbitratedPlayers
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execGetArbitratedPlayers_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FOnlineArbitrationRegistrant >      ReturnValue;                                      		// 0x0008 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearArbitrationRegistrationCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execClearArbitrationRegistrationCompleteDelegate_Parms
{
	struct FScriptDelegate                             ArbitrationRegistrationCompleteDelegate;          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.AddArbitrationRegistrationCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAddArbitrationRegistrationCompleteDelegate_Parms
{
	struct FScriptDelegate                             ArbitrationRegistrationCompleteDelegate;          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnArbitrationRegistrationComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnArbitrationRegistrationComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.RegisterForArbitration
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execRegisterForArbitration_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearEndOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearEndOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             EndOnlineGameCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddEndOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddEndOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             EndOnlineGameCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnEndOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnEndOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.EndOnlineGame
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execEndOnlineGame_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearStartOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearStartOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             StartOnlineGameCompleteDelegate;                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddStartOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddStartOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             StartOnlineGameCompleteDelegate;                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnStartOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnStartOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.StartOnlineGame
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execStartOnlineGame_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearUnregisterPlayerCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execClearUnregisterPlayerCompleteDelegate_Parms
{
	struct FScriptDelegate                             UnregisterPlayerCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.AddUnregisterPlayerCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAddUnregisterPlayerCompleteDelegate_Parms
{
	struct FScriptDelegate                             UnregisterPlayerCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnUnregisterPlayerComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnUnregisterPlayerComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.UnregisterPlayers
// [0x00420000] 
struct UOnlineGameInterfaceImpl_execUnregisterPlayers_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.UnregisterPlayer
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execUnregisterPlayer_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearRegisterPlayerCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execClearRegisterPlayerCompleteDelegate_Parms
{
	struct FScriptDelegate                             RegisterPlayerCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.AddRegisterPlayerCompleteDelegate
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execAddRegisterPlayerCompleteDelegate_Parms
{
	struct FScriptDelegate                             RegisterPlayerCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnRegisterPlayerComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnRegisterPlayerComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.RegisterPlayers
// [0x00420000] 
struct UOnlineGameInterfaceImpl_execRegisterPlayers_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.RegisterPlayer
// [0x00020000] 
struct UOnlineGameInterfaceImpl_execRegisterPlayer_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasInvited : 1;                                  		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.GetResolvedConnectString
// [0x00420400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execGetResolvedConnectString_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ConnectInfo;                                      		// 0x0008 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearJoinOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearJoinOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             JoinOnlineGameCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddJoinOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddJoinOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             JoinOnlineGameCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnJoinOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnJoinOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.JoinOnlineGame
// [0x00420400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execJoinOnlineGame_Parms
{
	unsigned char                                      PlayerNum;                                        		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FOnlineGameSearchResult                     DesiredGame;                                      		// 0x000C (0x0010) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.FreeSearchResults
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execFreeSearchResults_Parms
{
	class UOnlineGameSearch*                           Search;                                           		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearCancelFindOnlineGamesCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearCancelFindOnlineGamesCompleteDelegate_Parms
{
	struct FScriptDelegate                             CancelFindOnlineGamesCompleteDelegate;            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddCancelFindOnlineGamesCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddCancelFindOnlineGamesCompleteDelegate_Parms
{
	struct FScriptDelegate                             CancelFindOnlineGamesCompleteDelegate;            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnCancelFindOnlineGamesComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnCancelFindOnlineGamesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.CancelFindOnlineGames
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execCancelFindOnlineGames_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearFindOnlineGamesCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearFindOnlineGamesCompleteDelegate_Parms
{
	struct FScriptDelegate                             FindOnlineGamesCompleteDelegate;                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddFindOnlineGamesCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddFindOnlineGamesCompleteDelegate_Parms
{
	struct FScriptDelegate                             FindOnlineGamesCompleteDelegate;                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.FindOnlineGames
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execFindOnlineGames_Parms
{
	unsigned char                                      SearchingPlayerNum;                               		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameSearch*                           SearchSettings;                                   		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearDestroyOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearDestroyOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             DestroyOnlineGameCompleteDelegate;                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddDestroyOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddDestroyOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             DestroyOnlineGameCompleteDelegate;                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnDestroyOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnDestroyOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.DestroyOnlineGame
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execDestroyOnlineGame_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearUpdateOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearUpdateOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             UpdateOnlineGameCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddUpdateOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddUpdateOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             UpdateOnlineGameCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnUpdateOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnUpdateOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.UpdateOnlineGame
// [0x00024000] 
struct UOnlineGameInterfaceImpl_execUpdateOnlineGame_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameSettings*                         UpdatedGameSettings;                              		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bShouldRefreshOnlineData : 1;                     		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.ClearCreateOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execClearCreateOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             CreateOnlineGameCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineGameInterfaceImpl.AddCreateOnlineGameCompleteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execAddCreateOnlineGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             CreateOnlineGameCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnCreateOnlineGameComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnCreateOnlineGameComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlineGameInterfaceImpl.CreateOnlineGame
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceImpl_execCreateOnlineGame_Parms
{
	unsigned char                                      HostingPlayerNum;                                 		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       SessionName;                                      		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameSettings*                         NewGameSettings;                                  		// 0x000C (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.GetGameSearch
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execGetGameSearch_Parms
{
	class UOnlineGameSearch*                           ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.GetGameSettings
// [0x00020002] 
struct UOnlineGameInterfaceImpl_execGetGameSettings_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameSettings*                         ReturnValue;                                      		// 0x0008 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlineGameInterfaceImpl.OnFindOnlineGamesComplete
// [0x00120000] 
struct UOnlineGameInterfaceImpl_execOnFindOnlineGamesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.OnlinePlaylistManager.ParseDataCenterId
// [0x00420400] ( FUNC_Native )
struct UOnlinePlaylistManager_execParseDataCenterId_Parms
{
	TArray< unsigned char >                            Data;                                             		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlinePlaylistManager.OnReadDataCenterIdComplete
// [0x00020002] 
struct UOnlinePlaylistManager_execOnReadDataCenterIdComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< unsigned char >                         FileData;                                         		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.OnlinePlaylistManager.ReadDataCenterId
// [0x00020002] 
struct UOnlinePlaylistManager_execReadDataCenterId_Parms
{
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.SendPlaylistPopulationUpdate
// [0x00020802] ( FUNC_Event )
struct UOnlinePlaylistManager_eventSendPlaylistPopulationUpdate_Parms
{
	int                                                NumPlayers;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// class UOnlineEventsInterface*                   EventsInterface;                                  		// 0x0004 (0x0010) [0x0000000000000000]              
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0014 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetPopulationInfoFromPlaylist
// [0x00420002] 
struct UOnlinePlaylistManager_execGetPopulationInfoFromPlaylist_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                WorldwideTotal;                                   		// 0x0004 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	int                                                RegionTotal;                                      		// 0x0008 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	// int                                             PlaylistIndex;                                    		// 0x000C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.ParsePlaylistPopulationData
// [0x00420400] ( FUNC_Native )
struct UOnlinePlaylistManager_execParsePlaylistPopulationData_Parms
{
	TArray< unsigned char >                            Data;                                             		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.OnlinePlaylistManager.OnPlaylistPopulationDataUpdated
// [0x00120000] 
struct UOnlinePlaylistManager_execOnPlaylistPopulationDataUpdated_Parms
{
};

// Function IpDrv.OnlinePlaylistManager.OnReadPlaylistPopulationComplete
// [0x00020002] 
struct UOnlinePlaylistManager_execOnReadPlaylistPopulationComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< unsigned char >                         FileData;                                         		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.OnlinePlaylistManager.ReadPlaylistPopulation
// [0x00020002] 
struct UOnlinePlaylistManager_execReadPlaylistPopulation_Parms
{
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.Reset
// [0x00020002] 
struct UOnlinePlaylistManager_execReset_Parms
{
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetContentIdsFromPlaylist
// [0x00420002] 
struct UOnlinePlaylistManager_execGetContentIdsFromPlaylist_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< int >                                      ContentIds;                                       		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             PlaylistIndex;                                    		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetInventorySwapFromPlaylist
// [0x00020002] 
struct UOnlinePlaylistManager_execGetInventorySwapFromPlaylist_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SourceInventory;                                  		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      ReturnValue;                                      		// 0x000C (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             PlaylistIndex;                                    		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             SwapIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetMapCycleFromPlaylist
// [0x00420002] 
struct UOnlinePlaylistManager_execGetMapCycleFromPlaylist_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FName >                             MapCycle;                                         		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             PlaylistIndex;                                    		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetUrlFromPlaylist
// [0x00020002] 
struct UOnlinePlaylistManager_execGetUrlFromPlaylist_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             PlaylistIndex;                                    		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetMatchType
// [0x00020002] 
struct UOnlinePlaylistManager_execGetMatchType_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0004 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             PlaylistIndex;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.IsPlaylistArbitrated
// [0x00020002] 
struct UOnlinePlaylistManager_execIsPlaylistArbitrated_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             PlaylistIndex;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetLoadBalanceIdFromPlaylist
// [0x00420002] 
struct UOnlinePlaylistManager_execGetLoadBalanceIdFromPlaylist_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                LoadBalanceId;                                    		// 0x0004 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	// int                                             PlaylistIndex;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetTeamInfoFromPlaylist
// [0x00420002] 
struct UOnlinePlaylistManager_execGetTeamInfoFromPlaylist_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                TeamSize;                                         		// 0x0004 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	int                                                TeamCount;                                        		// 0x0008 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	int                                                MaxPartySize;                                     		// 0x000C (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	// int                                             PlaylistIndex;                                    		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.PlaylistSupportsDedicatedServers
// [0x00020002] 
struct UOnlinePlaylistManager_execPlaylistSupportsDedicatedServers_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             PlaylistIndex;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.HasAnyGameSettings
// [0x00020002] 
struct UOnlinePlaylistManager_execHasAnyGameSettings_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             PlaylistIndex;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
	// int                                             GameIndex;                                        		// 0x000C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.GetGameSettings
// [0x00020002] 
struct UOnlinePlaylistManager_execGetGameSettings_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                GameSettingsId;                                   		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameSettings*                         ReturnValue;                                      		// 0x0008 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             PlaylistIndex;                                    		// 0x0010 (0x0004) [0x0000000000000000]              
	// int                                             GameIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.FinalizePlaylistObjects
// [0x00020400] ( FUNC_Native )
struct UOnlinePlaylistManager_execFinalizePlaylistObjects_Parms
{
};

// Function IpDrv.OnlinePlaylistManager.OnReadTitleFileComplete
// [0x00020002] 
struct UOnlinePlaylistManager_execOnReadTitleFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0014 (0x0008) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.ShouldRefreshPlaylists
// [0x00020400] ( FUNC_Native )
struct UOnlinePlaylistManager_execShouldRefreshPlaylists_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.OnlinePlaylistManager.DetermineFilesToDownload
// [0x00020400] ( FUNC_Native )
struct UOnlinePlaylistManager_execDetermineFilesToDownload_Parms
{
};

// Function IpDrv.OnlinePlaylistManager.DownloadPlaylist
// [0x00020002] 
struct UOnlinePlaylistManager_execDownloadPlaylist_Parms
{
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x0008 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlinePlaylistManager.OnReadPlaylistComplete
// [0x00120000] 
struct UOnlinePlaylistManager_execOnReadPlaylistComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.PartyBeacon.OnDestroyComplete
// [0x00120000] 
struct UPartyBeacon_execOnDestroyComplete_Parms
{
};

// Function IpDrv.PartyBeacon.DestroyBeacon
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UPartyBeacon_eventDestroyBeacon_Parms
{
};

// Function IpDrv.PartyBeaconClient.DestroyBeacon
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UPartyBeaconClient_eventDestroyBeacon_Parms
{
};

// Function IpDrv.PartyBeaconClient.CancelReservation
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconClient_execCancelReservation_Parms
{
	struct FUniqueNetId                                CancellingPartyLeader;                            		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconClient.RequestReservationUpdate
// [0x00420400] ( FUNC_Native )
struct UPartyBeaconClient_execRequestReservationUpdate_Parms
{
	struct FOnlineGameSearchResult                     DesiredHost;                                      		// 0x0000 (0x0010) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	struct FUniqueNetId                                RequestingPartyLeader;                            		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FPlayerReservation >                PlayersToAdd;                                     		// 0x0018 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0028 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconClient.RequestReservation
// [0x00420400] ( FUNC_Native )
struct UPartyBeaconClient_execRequestReservation_Parms
{
	struct FOnlineGameSearchResult                     DesiredHost;                                      		// 0x0000 (0x0010) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	struct FUniqueNetId                                RequestingPartyLeader;                            		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FPlayerReservation >                Players;                                          		// 0x0018 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0028 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconClient.OnHostHasCancelled
// [0x00120000] 
struct UPartyBeaconClient_execOnHostHasCancelled_Parms
{
};

// Function IpDrv.PartyBeaconClient.OnHostIsReady
// [0x00120000] 
struct UPartyBeaconClient_execOnHostIsReady_Parms
{
};

// Function IpDrv.PartyBeaconClient.OnTravelRequestReceived
// [0x00120000] 
struct UPartyBeaconClient_execOnTravelRequestReceived_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0010 (0x0050) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.PartyBeaconClient.OnReservationCountUpdated
// [0x00120000] 
struct UPartyBeaconClient_execOnReservationCountUpdated_Parms
{
	int                                                ReservationRemaining;                             		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.PartyBeaconClient.OnReservationRequestComplete
// [0x00120000] 
struct UPartyBeaconClient_execOnReservationRequestComplete_Parms
{
	unsigned char                                      ReservationResult;                                		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.PartyBeaconHost.GetMaxAvailableTeamSize
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconHost_execGetMaxAvailableTeamSize_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconHost.GetPartyLeaders
// [0x00420002] 
struct UPartyBeaconHost_execGetPartyLeaders_Parms
{
	TArray< struct FUniqueNetId >                      PartyLeaders;                                     		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             PartyIndex;                                       		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.PartyBeaconHost.GetPlayers
// [0x00C20002] 
struct UPartyBeaconHost_execGetPlayers_Parms
{
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             PlayerIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
	// int                                             PartyIndex;                                       		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FPlayerReservation                       PlayerRes;                                        		// 0x0018 (0x0024) [0x0000000000000000]              
};

// Function IpDrv.PartyBeaconHost.AppendReservationSkillsToSearch
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconHost_execAppendReservationSkillsToSearch_Parms
{
	class UOnlineGameSearch*                           Search;                                           		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.PartyBeaconHost.UnregisterParty
// [0x00820802] ( FUNC_Event )
struct UPartyBeaconHost_eventUnregisterParty_Parms
{
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// int                                             PlayerIndex;                                      		// 0x0008 (0x0004) [0x0000000000000000]              
	// int                                             PartyIndex;                                       		// 0x000C (0x0004) [0x0000000000000000]              
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0010 (0x0008) [0x0000000000000000]              
	// struct FPlayerReservation                       PlayerRes;                                        		// 0x0018 (0x0024) [0x0000000000000000]              
};

// Function IpDrv.PartyBeaconHost.UnregisterPartyMembers
// [0x00820802] ( FUNC_Event )
struct UPartyBeaconHost_eventUnregisterPartyMembers_Parms
{
	// int                                             Index;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	// int                                             PartyIndex;                                       		// 0x0004 (0x0004) [0x0000000000000000]              
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0008 (0x0008) [0x0000000000000000]              
	// struct FPlayerReservation                       PlayerRes;                                        		// 0x0010 (0x0024) [0x0000000000000000]              
};

// Function IpDrv.PartyBeaconHost.RegisterPartyMembers
// [0x00820802] ( FUNC_Event )
struct UPartyBeaconHost_eventRegisterPartyMembers_Parms
{
	// int                                             Index;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	// int                                             PartyIndex;                                       		// 0x0004 (0x0004) [0x0000000000000000]              
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UOnlineRecentPlayersList*                 PlayersList;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
	// TArray< struct FUniqueNetId >                   Members;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FPlayerReservation                       PlayerRes;                                        		// 0x0028 (0x0024) [0x0000000000000000]              
};

// Function IpDrv.PartyBeaconHost.AreReservationsFull
// [0x00020002] 
struct UPartyBeaconHost_execAreReservationsFull_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconHost.TellClientsHostHasCancelled
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconHost_execTellClientsHostHasCancelled_Parms
{
};

// Function IpDrv.PartyBeaconHost.TellClientsHostIsReady
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconHost_execTellClientsHostIsReady_Parms
{
};

// Function IpDrv.PartyBeaconHost.TellClientsToTravel
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconHost_execTellClientsToTravel_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UClass*                                      SearchClass;                                      		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      PlatformSpecificInfo[ 0x50 ];                     		// 0x0010 (0x0050) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.PartyBeaconHost.DestroyBeacon
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UPartyBeaconHost_eventDestroyBeacon_Parms
{
};

// Function IpDrv.PartyBeaconHost.OnClientCancellationReceived
// [0x00120000] 
struct UPartyBeaconHost_execOnClientCancellationReceived_Parms
{
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.PartyBeaconHost.OnReservationsFull
// [0x00120000] 
struct UPartyBeaconHost_execOnReservationsFull_Parms
{
};

// Function IpDrv.PartyBeaconHost.OnReservationChange
// [0x00120000] 
struct UPartyBeaconHost_execOnReservationChange_Parms
{
};

// Function IpDrv.PartyBeaconHost.HandlePlayerLogout
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconHost_execHandlePlayerLogout_Parms
{
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bMaintainParty : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.PartyBeaconHost.GetExistingReservation
// [0x00420400] ( FUNC_Native )
struct UPartyBeaconHost_execGetExistingReservation_Parms
{
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0000 (0x0008) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	int                                                ReturnValue;                                      		// 0x0008 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconHost.UpdatePartyReservationEntry
// [0x00420400] ( FUNC_Native )
struct UPartyBeaconHost_execUpdatePartyReservationEntry_Parms
{
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FPlayerReservation >                PlayerMembers;                                    		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0018 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconHost.AddPartyReservationEntry
// [0x00420400] ( FUNC_Native )
struct UPartyBeaconHost_execAddPartyReservationEntry_Parms
{
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FPlayerReservation >                PlayerMembers;                                    		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                TeamNum;                                          		// 0x0018 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bIsHost : 1;                                      		// 0x001C (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0020 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconHost.InitHostBeacon
// [0x00024400] ( FUNC_Native )
struct UPartyBeaconHost_execInitHostBeacon_Parms
{
	int                                                InNumTeams;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                InNumPlayersPerTeam;                              		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                InNumReservations;                                		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FName                                       InSessionName;                                    		// 0x000C (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                InForceTeamNum;                                   		// 0x0014 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.PartyBeaconHost.PauseReservationRequests
// [0x00020400] ( FUNC_Native )
struct UPartyBeaconHost_execPauseReservationRequests_Parms
{
	unsigned long                                      bPause : 1;                                       		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.WebRequest.GetHexDigit
// [0x00020002] 
struct UWebRequest_execGetHexDigit_Parms
{
	struct FString                                     D;                                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebRequest.DecodeFormData
// [0x00020002] 
struct UWebRequest_execDecodeFormData_Parms
{
	struct FString                                     Data;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  Token[ 0x2 ];                                     		// 0x0010 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ch;                                               		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0040 (0x0004) [0x0000000000000000]              
	// int                                             H1;                                               		// 0x0044 (0x0004) [0x0000000000000000]              
	// int                                             H2;                                               		// 0x0048 (0x0004) [0x0000000000000000]              
	// int                                             Limit;                                            		// 0x004C (0x0004) [0x0000000000000000]              
	// int                                             T;                                                		// 0x0050 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.WebRequest.ProcessHeaderString
// [0x00020002] 
struct UWebRequest_execProcessHeaderString_Parms
{
	struct FString                                     S;                                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.WebRequest.Dump
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execDump_Parms
{
};

// Function IpDrv.WebRequest.GetVariables
// [0x00420401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execGetVariables_Parms
{
	TArray< struct FString >                           varNames;                                         		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.GetVariableNumber
// [0x00024401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execGetVariableNumber_Parms
{
	struct FString                                     VariableName;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Number;                                           		// 0x0010 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     DefaultValue;                                     		// 0x0014 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0024 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.GetVariableCount
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execGetVariableCount_Parms
{
	struct FString                                     VariableName;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebRequest.GetVariable
// [0x00024401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execGetVariable_Parms
{
	struct FString                                     VariableName;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DefaultValue;                                     		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.AddVariable
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execAddVariable_Parms
{
	struct FString                                     VariableName;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Value;                                            		// 0x0010 (0x0010) [0x0000000000400880]              ( CPF_Parm | CPF_CoerceParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.GetHeaders
// [0x00420401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execGetHeaders_Parms
{
	TArray< struct FString >                           Headers;                                          		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.GetHeader
// [0x00024401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execGetHeader_Parms
{
	struct FString                                     HeaderName;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DefaultValue;                                     		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.AddHeader
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execAddHeader_Parms
{
	struct FString                                     HeaderName;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Value;                                            		// 0x0010 (0x0010) [0x0000000000400880]              ( CPF_Parm | CPF_CoerceParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.EncodeBase64
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execEncodeBase64_Parms
{
	struct FString                                     Decoded;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebRequest.DecodeBase64
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebRequest_execDecodeBase64_Parms
{
	struct FString                                     Encoded;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.SentResponse
// [0x00020002] 
struct UWebResponse_execSentResponse_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebResponse.SentText
// [0x00020002] 
struct UWebResponse_execSentText_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebResponse.Redirect
// [0x00020002] 
struct UWebResponse_execRedirect_Parms
{
	struct FString                                     URL;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.SendStandardHeaders
// [0x00024002] 
struct UWebResponse_execSendStandardHeaders_Parms
{
	struct FString                                     ContentType;                                      		// 0x0000 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bCache : 1;                                       		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.WebResponse.HTTPError
// [0x00024002] 
struct UWebResponse_execHTTPError_Parms
{
	int                                                ErrorNum;                                         		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     Data;                                             		// 0x0004 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.SendHeaders
// [0x00020002] 
struct UWebResponse_execSendHeaders_Parms
{
	// struct FString                                  hdr;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.AddHeader
// [0x00024002] 
struct UWebResponse_execAddHeader_Parms
{
	struct FString                                     Header;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bReplace : 1;                                     		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// int                                             I;                                                		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             Idx;                                              		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  Part;                                             		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Entry;                                            		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.HTTPHeader
// [0x00020002] 
struct UWebResponse_execHTTPHeader_Parms
{
	struct FString                                     Header;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.HttpResponse
// [0x00020002] 
struct UWebResponse_execHttpResponse_Parms
{
	struct FString                                     Header;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.FailAuthentication
// [0x00020002] 
struct UWebResponse_execFailAuthentication_Parms
{
	struct FString                                     Realm;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.SendCachedFile
// [0x00024002] 
struct UWebResponse_execSendCachedFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ContentType;                                      		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebResponse.SendBinary
// [0x00020802] ( FUNC_Event )
struct UWebResponse_eventSendBinary_Parms
{
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      B[ 0xFF ];                                        		// 0x0004 (0x00FF) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.WebResponse.SendText
// [0x00024802] ( FUNC_Event )
struct UWebResponse_eventSendText_Parms
{
	struct FString                                     Text;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bNoCRLF : 1;                                      		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.WebResponse.Dump
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execDump_Parms
{
};

// Function IpDrv.WebResponse.GetHTTPExpiration
// [0x00024401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execGetHTTPExpiration_Parms
{
	int                                                OffsetSeconds;                                    		// 0x0000 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.LoadParsedUHTM
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execLoadParsedUHTM_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.WebResponse.IncludeBinaryFile
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execIncludeBinaryFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebResponse.IncludeUHTM
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execIncludeUHTM_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebResponse.ClearSubst
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execClearSubst_Parms
{
};

// Function IpDrv.WebResponse.Subst
// [0x00024401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execSubst_Parms
{
	struct FString                                     Variable;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Value;                                            		// 0x0010 (0x0010) [0x0000000000400880]              ( CPF_Parm | CPF_CoerceParm | CPF_NeedCtorLink )
	unsigned long                                      bClear : 1;                                       		// 0x0020 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.WebResponse.FileExists
// [0x00020401] ( FUNC_Final | FUNC_Native )
struct UWebResponse_execFileExists_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.UIDataStore_OnlinePlaylists.GetMatchTypeForPlaylistId
// [0x00020802] ( FUNC_Event )
struct UUIDataStore_OnlinePlaylists_eventGetMatchTypeForPlaylistId_Parms
{
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0004 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.UIDataStore_OnlinePlaylists.GetOnlinePlaylistProvider
// [0x00426002] 
struct UUIDataStore_OnlinePlaylists_execGetOnlinePlaylistProvider_Parms
{
	struct FName                                       ProviderTag;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                PlaylistId;                                       		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                ProviderIndex;                                    		// 0x000C (0x0004) [0x0000000000000190]              ( CPF_OptionalParm | CPF_Parm | CPF_OutParm )
	class UOnlinePlaylistProvider*                     ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UUIDataStore_OnlinePlaylists*             PlaylistDS;                                       		// 0x0018 (0x0008) [0x0000000000000000]              
	// TArray< class UUIResourceDataProvider* >        Providers;                                        		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UOnlinePlaylistProvider*                  OPP;                                              		// 0x0030 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.UIDataStore_OnlinePlaylists.GetPlaylistProvider
// [0x00420401] ( FUNC_Final | FUNC_Native )
struct UUIDataStore_OnlinePlaylists_execGetPlaylistProvider_Parms
{
	struct FName                                       ProviderTag;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ProviderIndex;                                    		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	class UUIResourceDataProvider*                     out_Provider;                                     		// 0x000C (0x0008) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.UIDataStore_OnlinePlaylists.GetResourceProviders
// [0x00420401] ( FUNC_Final | FUNC_Native )
struct UUIDataStore_OnlinePlaylists_execGetResourceProviders_Parms
{
	struct FName                                       ProviderTag;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< class UUIResourceDataProvider* >           out_Providers;                                    		// 0x0008 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.UIDataStore_OnlinePlaylists.Init
// [0x00020802] ( FUNC_Event )
struct UUIDataStore_OnlinePlaylists_eventInit_Parms
{
	// class UOnlineSubsystem*                         OnlineSub;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.WebApplication.PostQuery
// [0x00020000] 
struct UWebApplication_execPostQuery_Parms
{
	class UWebRequest*                                 Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UWebResponse*                                Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.WebApplication.Query
// [0x00020000] 
struct UWebApplication_execQuery_Parms
{
	class UWebRequest*                                 Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UWebResponse*                                Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.WebApplication.PreQuery
// [0x00020002] 
struct UWebApplication_execPreQuery_Parms
{
	class UWebRequest*                                 Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UWebResponse*                                Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebApplication.CleanupApp
// [0x00020002] 
struct UWebApplication_execCleanupApp_Parms
{
};

// Function IpDrv.WebApplication.Cleanup
// [0x00020001] ( FUNC_Final )
struct UWebApplication_execCleanup_Parms
{
};

// Function IpDrv.WebApplication.Init
// [0x00020000] 
struct UWebApplication_execInit_Parms
{
};

// Function IpDrv.WebServer.GetApplication
// [0x00420002] 
struct AWebServer_execGetApplication_Parms
{
	struct FString                                     URI;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SubURI;                                           		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	class UWebApplication*                             ReturnValue;                                      		// 0x0020 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             I;                                                		// 0x0028 (0x0004) [0x0000000000000000]              
	// int                                             L;                                                		// 0x002C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.WebServer.LostChild
// [0x00020802] ( FUNC_Event )
struct AWebServer_eventLostChild_Parms
{
	class AActor*                                      C;                                                		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.WebServer.GainedChild
// [0x00020802] ( FUNC_Event )
struct AWebServer_eventGainedChild_Parms
{
	class AActor*                                      C;                                                		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.WebServer.Destroyed
// [0x00020802] ( FUNC_Event )
struct AWebServer_eventDestroyed_Parms
{
	// int                                             I;                                                		// 0x0000 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.WebServer.PostBeginPlay
// [0x00820002] 
struct AWebServer_execPostBeginPlay_Parms
{
	// int                                             I;                                                		// 0x0000 (0x0004) [0x0000000000000000]              
	// class UClass*                                   ApplicationClass;                                 		// 0x0004 (0x0008) [0x0000000000000000]              
	// struct FIpAddr                                  L;                                                		// 0x000C (0x0008) [0x0000000000000000]              
	// struct FString                                  S;                                                		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.HelloWeb.Query
// [0x00020802] ( FUNC_Event )
struct UHelloWeb_eventQuery_Parms
{
	class UWebRequest*                                 Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UWebResponse*                                Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.HelloWeb.Init
// [0x00020002] 
struct UHelloWeb_execInit_Parms
{
};

// Function IpDrv.ImageServer.Query
// [0x00020802] ( FUNC_Event )
struct UImageServer_eventQuery_Parms
{
	class UWebRequest*                                 Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UWebResponse*                                Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  Image;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceConfig.GetUserAuthTicket
// [0x00020000] 
struct UMcpServiceConfig_execGetUserAuthTicket_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServiceConfig.Init
// [0x00020002] 
struct UMcpServiceConfig_execInit_Parms
{
	unsigned long                                      bIsProduction : 1;                                		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.McpUserAuthRequestWrapper.SetProcessRequestCompleteDelegate
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execSetProcessRequestCompleteDelegate_Parms
{
	struct FScriptDelegate                             ProcessRequestCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserAuthRequestWrapper.WrappedOnProcessRequestComplete
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execWrappedOnProcessRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bDidSucceed : 1;                                  		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.McpUserAuthRequestWrapper.ReportError
// [0x00080002] 
struct UMcpUserAuthRequestWrapper_execReportError_Parms
{
	int                                                ResponseCode;                                     		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ErrorString;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UMcpUserAuthResponseWrapper*              Response;                                         		// 0x0014 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserAuthRequestWrapper.ProcessRequest
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execProcessRequest_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UMcpUserManagerBase*                      UserManager;                                      		// 0x0004 (0x0008) [0x0000000000000000]              
	// struct FString                                  AuthToken;                                        		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserAuthRequestWrapper.SetHeader
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execSetHeader_Parms
{
	struct FString                                     HeaderName;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     HeaderValue;                                      		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0020 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserAuthRequestWrapper.SetContentAsString
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execSetContentAsString_Parms
{
	struct FString                                     ContentString;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserAuthRequestWrapper.SetContent
// [0x00420002] 
struct UMcpUserAuthRequestWrapper_execSetContent_Parms
{
	TArray< unsigned char >                            ContentPayload;                                   		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserAuthRequestWrapper.SetURL
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execSetURL_Parms
{
	struct FString                                     URL;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserAuthRequestWrapper.SetVerb
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execSetVerb_Parms
{
	struct FString                                     Verb;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserAuthRequestWrapper.GetVerb
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execGetVerb_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserAuthRequestWrapper.Init
// [0x00020002] 
struct UMcpUserAuthRequestWrapper_execInit_Parms
{
	struct FString                                     InMcpId;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       RequestObject;                                    		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpUserManagerBase.GetAuthToken
// [0x00020000] 
struct UMcpUserManagerBase_execGetAuthToken_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.OnDeleteUserComplete
// [0x00120000] 
struct UMcpUserManagerBase_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.DeleteUser
// [0x00020000] 
struct UMcpUserManagerBase_execDeleteUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.GetUserExternalAccountId
// [0x00420000] 
struct UMcpUserManagerBase_execGetUserExternalAccountId_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalAccountType;                              		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalAccountId;                                		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserManagerBase.UserHasExternalAccount
// [0x00020000] 
struct UMcpUserManagerBase_execUserHasExternalAccount_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalAccountType;                              		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserManagerBase.GetUser
// [0x00420000] 
struct UMcpUserManagerBase_execGetUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpUserStatus                              User;                                             		// 0x0010 (0x0078) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0088 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserManagerBase.GetUsers
// [0x00420000] 
struct UMcpUserManagerBase_execGetUsers_Parms
{
	TArray< struct FMcpUserStatus >                    Users;                                            		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.OnQueryUsersComplete
// [0x00120000] 
struct UMcpUserManagerBase_execOnQueryUsersComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.QueryUsers
// [0x00420000] 
struct UMcpUserManagerBase_execQueryUsers_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           McpIds;                                           		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.QueryUser
// [0x00024000] 
struct UMcpUserManagerBase_execQueryUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldUpdateLastActive : 1;                      		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpUserManagerBase.InjectUserCredentials
// [0x00020000] 
struct UMcpUserManagerBase_execInjectUserCredentials_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ClientSecret;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.OnAuthenticateUserComplete
// [0x00120000] 
struct UMcpUserManagerBase_execOnAuthenticateUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.AuthenticateUserGameCenter
// [0x00020000] 
struct UMcpUserManagerBase_execAuthenticateUserGameCenter_Parms
{
	struct FString                                     GameCenterId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.AuthenticateUserMcp
// [0x00020000] 
struct UMcpUserManagerBase_execAuthenticateUserMcp_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ClientSecret;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UDID;                                             		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.AuthenticateUserGoogle
// [0x00020000] 
struct UMcpUserManagerBase_execAuthenticateUserGoogle_Parms
{
	struct FString                                     GoogleId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GoogleAuthToken;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.AuthenticateUserFacebook
// [0x00020000] 
struct UMcpUserManagerBase_execAuthenticateUserFacebook_Parms
{
	struct FString                                     FacebookId;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FacebookToken;                                    		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UDID;                                             		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.OnRegisterUserComplete
// [0x00120000] 
struct UMcpUserManagerBase_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.RegisterUserGoogle
// [0x00020000] 
struct UMcpUserManagerBase_execRegisterUserGoogle_Parms
{
	struct FString                                     GoogleId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GoogleAuthToken;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.RegisterUserGameCenter
// [0x00020000] 
struct UMcpUserManagerBase_execRegisterUserGameCenter_Parms
{
	struct FString                                     GameCenterId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.RegisterUserFacebook
// [0x00020000] 
struct UMcpUserManagerBase_execRegisterUserFacebook_Parms
{
	struct FString                                     FacebookId;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FacebookAuthToken;                                		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerBase.RegisterUserGenerated
// [0x00020000] 
struct UMcpUserManagerBase_execRegisterUserGenerated_Parms
{
};

// Function IpDrv.McpUserManagerBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpUserManagerBase_execCreateInstance_Parms
{
	class UMcpUserManagerBase*                         ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpUserManagerBaseClass;                          		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpUserManagerBase*                      NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobBase.UpdateChallengeUserReward
// [0x00020000] 
struct UMcpClashMobBase_execUpdateChallengeUserReward_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                UserReward;                                       		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpClashMobBase.OnUpdateChallengeUserRewardComplete
// [0x00120000] 
struct UMcpClashMobBase_execOnUpdateChallengeUserRewardComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UniqueChallengeId;                                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.UpdateChallengeUserProgress
// [0x00020000] 
struct UMcpClashMobBase_execUpdateChallengeUserProgress_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bDidComplete : 1;                                 		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	int                                                GoalProgress;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpClashMobBase.OnUpdateChallengeUserProgressComplete
// [0x00120000] 
struct UMcpClashMobBase_execOnUpdateChallengeUserProgressComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UniqueChallengeId;                                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.GetChallengeUserStatusForSaveSlot
// [0x00420000] 
struct UMcpClashMobBase_execGetChallengeUserStatusForSaveSlot_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpClashMobChallengeUserStatus             OutChallengeUserStatus;                           		// 0x0030 (0x009C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x00CC (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpClashMobBase.GetChallengeUserStatus
// [0x00420000] 
struct UMcpClashMobBase_execGetChallengeUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeUserStatus >   OutChallengeUserStatuses;                         		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.QueryChallengeMultiUserStatus
// [0x00424000] 
struct UMcpClashMobBase_execQueryChallengeMultiUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           UserIdsToRead;                                    		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                AdditionalParticipantCount;                       		// 0x0030 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bWantsParentChildData : 1;                        		// 0x0034 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpClashMobBase.QueryChallengeUserStatus
// [0x00024000] 
struct UMcpClashMobBase_execQueryChallengeUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWantsParentChildData : 1;                        		// 0x0020 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpClashMobBase.OnQueryChallengeUserStatusComplete
// [0x00120000] 
struct UMcpClashMobBase_execOnQueryChallengeUserStatusComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UniqueChallengeId;                                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.AcceptChallenge
// [0x00024000] 
struct UMcpClashMobBase_execAcceptChallenge_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bLiked : 1;                                       		// 0x0030 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bCommented : 1;                                   		// 0x0034 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bRetweeted : 1;                                   		// 0x0038 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpClashMobBase.OnAcceptChallengeComplete
// [0x00120000] 
struct UMcpClashMobBase_execOnAcceptChallengeComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UniqueChallengeId;                                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.DeleteCachedChallengeFile
// [0x00020000] 
struct UMcpClashMobBase_execDeleteCachedChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.ClearCachedChallengeFile
// [0x00020000] 
struct UMcpClashMobBase_execClearCachedChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.GetChallengeFileContents
// [0x00420000] 
struct UMcpClashMobBase_execGetChallengeFileContents_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            OutFileContents;                                  		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.DownloadChallengeFile
// [0x00020000] 
struct UMcpClashMobBase_execDownloadChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.GetChallengeFileList
// [0x00420000] 
struct UMcpClashMobBase_execGetChallengeFileList_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeFile >         OutChallengeFiles;                                		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.OnDownloadChallengeFileComplete
// [0x00120000] 
struct UMcpClashMobBase_execOnDownloadChallengeFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UniqueChallengeId;                                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0034 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.OnQueryChallengeComplete
// [0x00120000] 
struct UMcpClashMobBase_execOnQueryChallengeComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ChallengeId;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.QueryParentChallenge
// [0x00020000] 
struct UMcpClashMobBase_execQueryParentChallenge_Parms
{
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.QueryChallenge
// [0x00020000] 
struct UMcpClashMobBase_execQueryChallenge_Parms
{
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.GetChallenge
// [0x00420000] 
struct UMcpClashMobBase_execGetChallenge_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpClashMobChallengeEvent                  OutChallengeEvent;                                		// 0x0010 (0x012C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x013C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpClashMobBase.GetChallengeList
// [0x00420000] 
struct UMcpClashMobBase_execGetChallengeList_Parms
{
	TArray< struct FMcpClashMobChallengeEvent >        OutChallengeEvents;                               		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.QueryChallengeList
// [0x00020000] 
struct UMcpClashMobBase_execQueryChallengeList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.OnQueryChallengeListComplete
// [0x00120000] 
struct UMcpClashMobBase_execOnQueryChallengeListComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpClashMobBase_execCreateInstance_Parms
{
	class UMcpClashMobBase*                            ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpClashMobBaseClass;                             		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpClashMobBase*                         NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobFileDownload.GetUrlForFile
// [0x00020002] 
struct UMcpClashMobFileDownload_execGetUrlForFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManager.OnUpdateChallengeUserRewardHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpClashMobManager_execOnUpdateChallengeUserRewardHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  UniqueChallengeId;                                		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UniqueUserId;                                     		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             UserQueryIdx;                                     		// 0x0048 (0x0004) [0x0000000000000000]              
	// int                                             ChallengeQueryIdx;                                		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.UpdateChallengeUserReward
// [0x00020002] 
struct UMcpClashMobManager_execUpdateChallengeUserReward_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                UserReward;                                       		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeQueryIdx;                                		// 0x0054 (0x0004) [0x0000000000000000]              
	// int                                             UserQueryIdx;                                     		// 0x0058 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bPending : 1;                                     		// 0x005C (0x0004) [0x0000000000000000] [0x00000001] 
	// class UHttpRequestInterface*                    Request;                                          		// 0x0060 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.OnUpdateChallengeUserProgressHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpClashMobManager_execOnUpdateChallengeUserProgressHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  UniqueChallengeId;                                		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UniqueUserId;                                     		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             UserQueryIdx;                                     		// 0x0048 (0x0004) [0x0000000000000000]              
	// int                                             ChallengeQueryIdx;                                		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.UpdateChallengeUserProgress
// [0x00020002] 
struct UMcpClashMobManager_execUpdateChallengeUserProgress_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bDidComplete : 1;                                 		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	int                                                GoalProgress;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeQueryIdx;                                		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             UserQueryIdx;                                     		// 0x005C (0x0004) [0x0000000000000000]              
	// unsigned long                                   bPending : 1;                                     		// 0x0060 (0x0004) [0x0000000000000000] [0x00000001] 
	// class UHttpRequestInterface*                    Request;                                          		// 0x0064 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.GetChallengeUserStatus
// [0x00C20002] 
struct UMcpClashMobManager_execGetChallengeUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeUserStatus >   OutChallengeUserStatuses;                         		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             UserStatusIdx;                                    		// 0x0030 (0x0004) [0x0000000000000000]              
	// struct FMcpClashMobChallengeUserStatus          DefaultStatus;                                    		// 0x0034 (0x009C) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManager.OnQueryChallengeMultiStatusHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpClashMobManager_execOnQueryChallengeMultiStatusHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  JSONStr;                                          		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UniqueChallengeId;                                		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UniqueUserId;                                     		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x0054 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             UserQueryIdx;                                     		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             ChallengeQueryIdx;                                		// 0x005C (0x0004) [0x0000000000000000]              
	// int                                             UserStatusIdx;                                    		// 0x0060 (0x0004) [0x0000000000000000]              
	// int                                             TempUserStatusIdx;                                		// 0x0064 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.QueryChallengeMultiUserStatus
// [0x00424002] 
struct UMcpClashMobManager_execQueryChallengeMultiUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           UserIdsToRead;                                    		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                Ignored;                                          		// 0x0030 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      Ignored2 : 1;                                     		// 0x0034 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSONStr;                                          		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeQueryIdx;                                		// 0x0068 (0x0004) [0x0000000000000000]              
	// int                                             UserQueryIdx;                                     		// 0x006C (0x0004) [0x0000000000000000]              
	// int                                             UserIdIdx;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bPending : 1;                                     		// 0x0074 (0x0004) [0x0000000000000000] [0x00000001] 
	// class UHttpRequestInterface*                    Request;                                          		// 0x0078 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.OnQueryChallengeStatusHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpClashMobManager_execOnQueryChallengeStatusHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  JSONStr;                                          		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UniqueChallengeId;                                		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UniqueUserId;                                     		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x0054 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             UserQueryIdx;                                     		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             ChallengeQueryIdx;                                		// 0x005C (0x0004) [0x0000000000000000]              
	// int                                             UserStatusIdx;                                    		// 0x0060 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.QueryChallengeUserStatus
// [0x00024002] 
struct UMcpClashMobManager_execQueryChallengeUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      Ignored : 1;                                      		// 0x0020 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeQueryIdx;                                		// 0x0044 (0x0004) [0x0000000000000000]              
	// int                                             UserQueryIdx;                                     		// 0x0048 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bPending : 1;                                     		// 0x004C (0x0004) [0x0000000000000000] [0x00000001] 
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.OnAcceptChallengeHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpClashMobManager_execOnAcceptChallengeHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  UniqueChallengeId;                                		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  UniqueUserId;                                     		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
	// int                                             UserQueryIdx;                                     		// 0x0048 (0x0004) [0x0000000000000000]              
	// int                                             ChallengeQueryIdx;                                		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.AcceptChallenge
// [0x00024002] 
struct UMcpClashMobManager_execAcceptChallenge_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bLiked : 1;                                       		// 0x0030 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bCommented : 1;                                   		// 0x0034 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bRetweeted : 1;                                   		// 0x0038 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeQueryIdx;                                		// 0x005C (0x0004) [0x0000000000000000]              
	// int                                             UserQueryIdx;                                     		// 0x0060 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bPending : 1;                                     		// 0x0064 (0x0004) [0x0000000000000000] [0x00000001] 
	// class UHttpRequestInterface*                    Request;                                          		// 0x0068 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.DeleteCachedChallengeFile
// [0x00020002] 
struct UMcpClashMobManager_execDeleteCachedChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             ChallengeIdx;                                     		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.ClearCachedChallengeFile
// [0x00020002] 
struct UMcpClashMobManager_execClearCachedChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             ChallengeIdx;                                     		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.GetChallengeFileContents
// [0x00420002] 
struct UMcpClashMobManager_execGetChallengeFileContents_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            OutFileContents;                                  		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             ChallengeIdx;                                     		// 0x0030 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.OnDownloadMcpFileComplete
// [0x00020002] 
struct UMcpClashMobManager_execOnDownloadMcpFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     DLName;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< unsigned char >                         FileContents;                                     		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeIdx;                                     		// 0x0024 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0028 (0x0004) [0x0000000000000000]              
	// struct FString                                  Filename;                                         		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManager.OnLoadCachedFileComplete
// [0x00040003] ( FUNC_Final )
struct UMcpClashMobManager_execOnLoadCachedFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     DLName;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// unsigned long                                   bRequiresDownload : 1;                            		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	// struct FString                                  FileHashCache;                                    		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  FileHashChallenge;                                		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Filename;                                         		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeIdx;                                     		// 0x0048 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x004C (0x0004) [0x0000000000000000]              
	// TArray< unsigned char >                         FileContents;                                     		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManager.DownloadChallengeFile
// [0x00020002] 
struct UMcpClashMobManager_execDownloadChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ChallengeIdx;                                     		// 0x0030 (0x0004) [0x0000000000000000]              
	// int                                             FileIdx;                                          		// 0x0034 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bPending : 1;                                     		// 0x0038 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpClashMobManager.GetChallengeFileList
// [0x00420002] 
struct UMcpClashMobManager_execGetChallengeFileList_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeFile >         OutChallengeFiles;                                		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             ChallengeEventIdx;                                		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManager.GetChallengeList
// [0x00420002] 
struct UMcpClashMobManager_execGetChallengeList_Parms
{
	TArray< struct FMcpClashMobChallengeEvent >        OutChallengeEvents;                               		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManager.OnQueryChallengeListHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpClashMobManager_execOnQueryChallengeListHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  JSONStr;                                          		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpClashMobManager.QueryChallengeList
// [0x00020002] 
struct UMcpClashMobManager_execQueryChallengeList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bPending : 1;                                     		// 0x0030 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpClashMobManager.Init
// [0x00080802] ( FUNC_Event )
struct UMcpClashMobManager_eventInit_Parms
{
};

// Function IpDrv.McpClashMobManagerV3.OnUpdateChallengeUserRewardRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnUpdateChallengeUserRewardRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.UpdateChallengeUserReward
// [0x00020002] 
struct UMcpClashMobManagerV3_execUpdateChallengeUserReward_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                UserReward;                                       		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0044 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.OnUpdateChallengeUserProgressRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnUpdateChallengeUserProgressRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.UpdateChallengeUserProgress
// [0x00020002] 
struct UMcpClashMobManagerV3_execUpdateChallengeUserProgress_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bDidComplete : 1;                                 		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	int                                                GoalProgress;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0048 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0050 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.GetChallengeUserStatusForSaveSlot
// [0x00420002] 
struct UMcpClashMobManagerV3_execGetChallengeUserStatusForSaveSlot_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpClashMobChallengeUserStatus             OutChallengeUserStatus;                           		// 0x0030 (0x009C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x00CC (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Index;                                            		// 0x00D0 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.GetChallengeUserStatus
// [0x00420002] 
struct UMcpClashMobManagerV3_execGetChallengeUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeUserStatus >   OutChallengeUserStatuses;                         		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.ParseUserChallengeStatus
// [0x00020002] 
struct UMcpClashMobManagerV3_execParseUserChallengeStatus_Parms
{
	class UJsonObject*                                 JsonNode;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Index;                                            		// 0x000C (0x0004) [0x0000000000000000]              
	// unsigned long                                   bWasFound : 1;                                    		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
	// struct FString                                  UniqueChallengeId;                                		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MissingKey;                                       		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  SaveSlotId;                                       		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.ParseUserChallengeStatuses
// [0x00020002] 
struct UMcpClashMobManagerV3_execParseUserChallengeStatuses_Parms
{
	struct FString                                     JSON;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0014 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x001C (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.OnQueryChallengeUserStatusRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnQueryChallengeUserStatusRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.QueryChallengeMultiUserStatus
// [0x00424002] 
struct UMcpClashMobManagerV3_execQueryChallengeMultiUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           UserIdsToRead;                                    		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                AdditionalParticipantCount;                       		// 0x0030 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bWantsParentChildData : 1;                        		// 0x0034 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0048 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0050 (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0064 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.QueryChallengeUserStatus
// [0x00024002] 
struct UMcpClashMobManagerV3_execQueryChallengeUserStatus_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWantsParentChildData : 1;                        		// 0x0020 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// TArray< struct FString >                        McpIds;                                           		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.OnAcceptChallengeRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnAcceptChallengeRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.AcceptChallenge
// [0x00024002] 
struct UMcpClashMobManagerV3_execAcceptChallenge_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UniqueUserId;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bLiked : 1;                                       		// 0x0030 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bCommented : 1;                                   		// 0x0034 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bRetweeted : 1;                                   		// 0x0038 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x004C (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.BuildUserChallengeUpdatePath
// [0x00020002] 
struct UMcpClashMobManagerV3_execBuildUserChallengeUpdatePath_Parms
{
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0030 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.BuildUserChallengePath
// [0x00020002] 
struct UMcpClashMobManagerV3_execBuildUserChallengePath_Parms
{
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.DeleteCachedChallengeFile
// [0x00020002] 
struct UMcpClashMobManagerV3_execDeleteCachedChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             FileIndex;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.ClearCachedChallengeFile
// [0x00020002] 
struct UMcpClashMobManagerV3_execClearCachedChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             FileIndex;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.GetChallengeFileContents
// [0x00420002] 
struct UMcpClashMobManagerV3_execGetChallengeFileContents_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            OutFileContents;                                  		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             FileIndex;                                        		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.FindChallengeFileIndex
// [0x00020002] 
struct UMcpClashMobManagerV3_execFindChallengeFileIndex_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0020 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.OnDownloadChallengeFileRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnDownloadChallengeFileRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0028 (0x0004) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x002C (0x0004) [0x0000000000000000]              
	// TArray< unsigned char >                         Data;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.DownloadFile
// [0x00020002] 
struct UMcpClashMobManagerV3_execDownloadFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             RequestIndex;                                     		// 0x0048 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.OnLoadCachedFileComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnLoadCachedFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// unsigned long                                   bNeedsDownloading : 1;                            		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	// struct FString                                  TitleFileHash;                                    		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ClashMobFileHash;                                 		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x003C (0x0004) [0x0000000000000000]              
	// TArray< unsigned char >                         Data;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorString;                                      		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.GetFileHash
// [0x00020002] 
struct UMcpClashMobManagerV3_execGetFileHash_Parms
{
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             ChallengeIndex;                                   		// 0x0030 (0x0004) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.DownloadChallengeFile
// [0x00020002] 
struct UMcpClashMobManagerV3_execDownloadChallengeFile_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             AddAt;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             ChallengeIndex;                                   		// 0x0024 (0x0004) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.GetChallengeFileList
// [0x00420002] 
struct UMcpClashMobManagerV3_execGetChallengeFileList_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeFile >         OutChallengeFiles;                                		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.GetChallenge
// [0x00420002] 
struct UMcpClashMobManagerV3_execGetChallenge_Parms
{
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpClashMobChallengeEvent                  OutChallengeEvent;                                		// 0x0010 (0x012C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x013C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Index;                                            		// 0x0140 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.GetChallengeList
// [0x00420002] 
struct UMcpClashMobManagerV3_execGetChallengeList_Parms
{
	TArray< struct FMcpClashMobChallengeEvent >        OutChallengeEvents;                               		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.ParseChallenge
// [0x00820002] 
struct UMcpClashMobManagerV3_execParseChallenge_Parms
{
	class UJsonObject*                                 JsonNode;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Index;                                            		// 0x000C (0x0004) [0x0000000000000000]              
	// struct FString                                  UniqueChallengeId;                                		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MissingKey;                                       		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              FilesArray;                                       		// 0x0030 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x0038 (0x0008) [0x0000000000000000]              
	// struct FMcpClashMobChallengeFile                File;                                             		// 0x0040 (0x0058) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             JsonIndex;                                        		// 0x0098 (0x0004) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x009C (0x0004) [0x0000000000000000]              
	// struct FMcpChildClashMobEntry                   ChildChallenge;                                   		// 0x00A0 (0x0014) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ChildArray;                                       		// 0x00B4 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.ParseChallenges
// [0x00020002] 
struct UMcpClashMobManagerV3_execParseChallenges_Parms
{
	struct FString                                     JSON;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0014 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x001C (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.OnQueryParentChallengeRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnQueryParentChallengeRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FString                                  ChallengeId;                                      		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.QueryParentChallenge
// [0x00020002] 
struct UMcpClashMobManagerV3_execQueryParentChallenge_Parms
{
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.OnQueryChallengeRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnQueryChallengeRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FString                                  ChallengeId;                                      		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x004C (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.QueryChallenge
// [0x00020002] 
struct UMcpClashMobManagerV3_execQueryChallenge_Parms
{
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.OnQueryChallengeListRequestComplete
// [0x00020002] 
struct UMcpClashMobManagerV3_execOnQueryChallengeListRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpClashMobManagerV3.QueryChallengeList
// [0x00020002] 
struct UMcpClashMobManagerV3_execQueryChallengeList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpClashMobManagerV3.Init
// [0x00080802] ( FUNC_Event )
struct UMcpClashMobManagerV3_eventInit_Parms
{
};

// Function IpDrv.McpGroupsBase.OnAcceptGroupInviteComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnAcceptGroupInviteComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.AcceptGroupInvite
// [0x00020000] 
struct UMcpGroupsBase_execAcceptGroupInvite_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldAccept : 1;                                		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.McpGroupsBase.GetGroupInviteList
// [0x00420000] 
struct UMcpGroupsBase_execGetGroupInviteList_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpGroupList                               InviteList;                                       		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnQueryGroupInvitesComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnQueryGroupInvitesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.QueryGroupInvites
// [0x00020000] 
struct UMcpGroupsBase_execQueryGroupInvites_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnDeleteAllGroupsComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnDeleteAllGroupsComplete_Parms
{
	struct FString                                     RequesterId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.DeleteAllGroups
// [0x00020000] 
struct UMcpGroupsBase_execDeleteAllGroups_Parms
{
	struct FString                                     OwnerId;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnRemoveGroupMembersComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnRemoveGroupMembersComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.RemoveGroupMembers
// [0x00420000] 
struct UMcpGroupsBase_execRemoveGroupMembers_Parms
{
	struct FString                                     OwnerId;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           MemberIds;                                        		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnAddGroupMembersComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnAddGroupMembersComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.AddGroupMembers
// [0x00420000] 
struct UMcpGroupsBase_execAddGroupMembers_Parms
{
	struct FString                                     OwnerId;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           MemberIds;                                        		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      bRequiresAcceptance : 1;                          		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.McpGroupsBase.GetGroupMembers
// [0x00420000] 
struct UMcpGroupsBase_execGetGroupMembers_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpGroupMember >                   GroupMembers;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnQueryGroupMembersComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnQueryGroupMembersComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.QueryGroupMembers
// [0x00020000] 
struct UMcpGroupsBase_execQueryGroupMembers_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.GetGroupList
// [0x00420000] 
struct UMcpGroupsBase_execGetGroupList_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpGroupList                               GroupList;                                        		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnQueryGroupsComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnQueryGroupsComplete_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.QueryGroups
// [0x00020000] 
struct UMcpGroupsBase_execQueryGroups_Parms
{
	struct FString                                     RequesterId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnDeleteGroupComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnDeleteGroupComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.DeleteGroup
// [0x00020000] 
struct UMcpGroupsBase_execDeleteGroup_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.OnCreateGroupComplete
// [0x00120000] 
struct UMcpGroupsBase_execOnCreateGroupComplete_Parms
{
	struct FMcpGroup                                   Group;                                            		// 0x0000 (0x0044) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0044 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0048 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.CreateGroup
// [0x00020000] 
struct UMcpGroupsBase_execCreateGroup_Parms
{
	struct FString                                     OwnerId;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupName;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpGroupsBase_execCreateInstance_Parms
{
	class UMcpGroupsBase*                              ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpGroupsManagerClass;                            		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpGroupsBase*                           NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.CacheGroupMember
// [0x00820002] 
struct UMcpGroupsManager_execCacheGroupMember_Parms
{
	struct FString                                     MemberId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      AcceptState;                                      		// 0x0020 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	// int                                             MemberIndex;                                      		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FMcpGroupList                            GroupList;                                        		// 0x0028 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             GroupListIndex;                                   		// 0x0048 (0x0004) [0x0000000000000000]              
	// struct FMcpGroup                                GroupTemp;                                        		// 0x004C (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x0090 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0094 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.CacheGroup
// [0x00820002] 
struct UMcpGroupsManager_execCacheGroup_Parms
{
	struct FString                                     RequesterId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpGroup                                   Group;                                            		// 0x0010 (0x0044) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             AddAt;                                            		// 0x0054 (0x0004) [0x0000000000000000]              
	// int                                             GroupIndex;                                       		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             GroupListIndex;                                   		// 0x005C (0x0004) [0x0000000000000000]              
	// struct FMcpGroupList                            UserGroupList;                                    		// 0x0060 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bWasFound : 1;                                    		// 0x0080 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpGroupsManager.OnAcceptGroupInviteRequestComplete
// [0x00120002] 
struct UMcpGroupsManager_execOnAcceptGroupInviteRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  GroupID;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.AcceptGroupInvite
// [0x00020002] 
struct UMcpGroupsManager_execAcceptGroupInvite_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldAccept : 1;                                		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    AcceptGroupInviteRequest;                         		// 0x0034 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.OnDeleteAllGroupsRequestComplete
// [0x00020002] 
struct UMcpGroupsManager_execOnDeleteAllGroupsRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  RequesterId;                                      		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.DeleteAllGroups
// [0x00020002] 
struct UMcpGroupsManager_execDeleteAllGroups_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    DeleteGroupRequest;                               		// 0x0020 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.OnRemoveGroupMembersRequestComplete
// [0x00020002] 
struct UMcpGroupsManager_execOnRemoveGroupMembersRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  GroupID;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.RemoveGroupMembers
// [0x00420002] 
struct UMcpGroupsManager_execRemoveGroupMembers_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           MemberIds;                                        		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    RemoveGroupMembersRequest;                        		// 0x0040 (0x0008) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.OnAddGroupMembersRequestComplete
// [0x00120002] 
struct UMcpGroupsManager_execOnAddGroupMembersRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  GroupID;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.AddGroupMembers
// [0x00420002] 
struct UMcpGroupsManager_execAddGroupMembers_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           MemberIds;                                        		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      bRequiresAcceptance : 1;                          		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    AddGroupMembersRequest;                           		// 0x0044 (0x0008) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x005C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.GetGroupMembers
// [0x00C20002] 
struct UMcpGroupsManager_execGetGroupMembers_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpGroupMember >                   GroupMembers;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x0020 (0x0004) [0x0000000000000000]              
	// struct FMcpGroupList                            GroupList;                                        		// 0x0024 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FMcpGroup                                GroupTemp;                                        		// 0x0044 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.OnQueryGroupMembersRequestComplete
// [0x00120002] 
struct UMcpGroupsManager_execOnQueryGroupMembersRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JsonString;                                       		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0038 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0040 (0x0004) [0x0000000000000000]              
	// unsigned char                                   AcceptState;                                      		// 0x0044 (0x0001) [0x0000000000000000]              
	// struct FString                                  MemberId;                                         		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  GroupID;                                          		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.QueryGroupMembers
// [0x00020002] 
struct UMcpGroupsManager_execQueryGroupMembers_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    QueryGroupMembersRequest;                         		// 0x0030 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.GetGroupList
// [0x00420002] 
struct UMcpGroupsManager_execGetGroupList_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpGroupList                               GroupList;                                        		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             GroupListIndex;                                   		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.OnQueryGroupsRequestComplete
// [0x00920002] 
struct UMcpGroupsManager_execOnQueryGroupsRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FMcpGroup                                Group;                                            		// 0x0028 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JsonString;                                       		// 0x006C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x007C (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0084 (0x0004) [0x0000000000000000]              
	// struct FString                                  RequesterId;                                      		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.QueryGroups
// [0x00020002] 
struct UMcpGroupsManager_execQueryGroups_Parms
{
	struct FString                                     RequesterId;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    QueryGroupsRequest;                               		// 0x0020 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.OnDeleteGroupRequestComplete
// [0x00020002] 
struct UMcpGroupsManager_execOnDeleteGroupRequestComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  GroupID;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManager.DeleteGroup
// [0x00020002] 
struct UMcpGroupsManager_execDeleteGroup_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    DeleteGroupRequest;                               		// 0x0030 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.OnCreateGroupRequestComplete
// [0x00820002] 
struct UMcpGroupsManager_execOnCreateGroupRequestComplete_Parms
{
	class UHttpRequestInterface*                       CreateGroupRequest;                               		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      HttpResponse;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Content;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FMcpGroup                                CreatedGroup;                                     		// 0x0028 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JsonString;                                       		// 0x006C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x007C (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManager.CreateGroup
// [0x00820002] 
struct UMcpGroupsManager_execCreateGroup_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupName;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    CreateGroupRequest;                               		// 0x0030 (0x0008) [0x0000000000000000]              
	// struct FMcpGroup                                FailedGroup;                                      		// 0x0038 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManagerV3.AcceptGroupInvite
// [0x00020002] 
struct UMcpGroupsManagerV3_execAcceptGroupInvite_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldAccept : 1;                                		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.McpGroupsManagerV3.OnDeleteAllGroupsRequestComplete
// [0x00020002] 
struct UMcpGroupsManagerV3_execOnDeleteAllGroupsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  McpId;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Error;                                            		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ResponseCode;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             GroupIndex;                                       		// 0x003C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.DeleteAllGroups
// [0x00020002] 
struct UMcpGroupsManagerV3_execDeleteAllGroups_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.OnRemoveGroupMembersRequestComplete
// [0x00020002] 
struct UMcpGroupsManagerV3_execOnRemoveGroupMembersRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  GroupID;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Error;                                            		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MemberId;                                         		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
	// int                                             MemberIndex;                                      		// 0x004C (0x0004) [0x0000000000000000]              
	// int                                             GroupIndex;                                       		// 0x0050 (0x0004) [0x0000000000000000]              
	// int                                             GroupMemberIndex;                                 		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.RemoveGroupMembers
// [0x00420002] 
struct UMcpGroupsManagerV3_execRemoveGroupMembers_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           MemberIds;                                        		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             MemberIndex;                                      		// 0x005C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.OnAddGroupMembersRequestComplete
// [0x00920002] 
struct UMcpGroupsManagerV3_execOnAddGroupMembersRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  GroupID;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FMcpGroupMember                          Member;                                           		// 0x0028 (0x0014) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Error;                                            		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x004C (0x0004) [0x0000000000000000]              
	// int                                             GroupMemberIndex;                                 		// 0x0050 (0x0004) [0x0000000000000000]              
	// int                                             MemberIndex;                                      		// 0x0054 (0x0004) [0x0000000000000000]              
	// int                                             GroupIndex;                                       		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.AddGroupMembers
// [0x00420002] 
struct UMcpGroupsManagerV3_execAddGroupMembers_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           MemberIds;                                        		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      bRequiresAcceptance : 1;                          		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0054 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x005C (0x0004) [0x0000000000000000]              
	// int                                             MemberIndex;                                      		// 0x0060 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.GetGroupMembers
// [0x00420002] 
struct UMcpGroupsManagerV3_execGetGroupMembers_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpGroupMember >                   GroupMembers;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.OnQueryGroupMembersRequestComplete
// [0x00120002] 
struct UMcpGroupsManagerV3_execOnQueryGroupMembersRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonString;                                       		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0028 (0x0008) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FString                                  GroupID;                                          		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManagerV3.QueryGroupMembers
// [0x00020002] 
struct UMcpGroupsManagerV3_execQueryGroupMembers_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.GetGroupList
// [0x00420002] 
struct UMcpGroupsManagerV3_execGetGroupList_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpGroupList                               GroupList;                                        		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.OnQueryGroupsRequestComplete
// [0x00120002] 
struct UMcpGroupsManagerV3_execOnQueryGroupsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JsonString;                                       		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0038 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FString                                  RequesterId;                                      		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.QueryGroups
// [0x00020002] 
struct UMcpGroupsManagerV3_execQueryGroups_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.OnDeleteGroupRequestComplete
// [0x00020002] 
struct UMcpGroupsManagerV3_execOnDeleteGroupRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  GroupID;                                          		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x002C (0x0004) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManagerV3.DeleteGroup
// [0x00020002] 
struct UMcpGroupsManagerV3_execDeleteGroup_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.OnCreateGroupRequestComplete
// [0x00820002] 
struct UMcpGroupsManagerV3_execOnCreateGroupRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FMcpGroup                                CreatedGroup;                                     		// 0x0018 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JsonString;                                       		// 0x005C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x006C (0x0008) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0074 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             GroupIndex;                                       		// 0x0084 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpGroupsManagerV3.ParseGroup
// [0x00880002] 
struct UMcpGroupsManagerV3_execParseGroup_Parms
{
	class UJsonObject*                                 ParsedJson;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0008 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UJsonObject*                              MembersArray;                                     		// 0x000C (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x0014 (0x0008) [0x0000000000000000]              
	// int                                             GroupIndex;                                       		// 0x001C (0x0004) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
	// struct FString                                  GroupID;                                          		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FMcpGroupMember                          Member;                                           		// 0x0034 (0x0014) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManagerV3.CreateGroup
// [0x00820002] 
struct UMcpGroupsManagerV3_execCreateGroup_Parms
{
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GroupName;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// struct FMcpGroup                                FailedGroup;                                      		// 0x0038 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManagerV3.BuildGroupMemberResourcePath
// [0x00020002] 
struct UMcpGroupsManagerV3_execBuildGroupMemberResourcePath_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpGroupsManagerV3.BuildGroupResourcePath
// [0x00020002] 
struct UMcpGroupsManagerV3_execBuildGroupResourcePath_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingBase.GetIdMappings
// [0x00420000] 
struct UMcpIdMappingBase_execGetIdMappings_Parms
{
	struct FString                                     ExternalType;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpIdMapping >                     IDMappings;                                       		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingBase.OnQueryMappingsComplete
// [0x00120000] 
struct UMcpIdMappingBase_execOnQueryMappingsComplete_Parms
{
	struct FString                                     ExternalType;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingBase.QueryMappings
// [0x00420000] 
struct UMcpIdMappingBase_execQueryMappings_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           ExternalIds;                                      		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingBase.OnAddMappingComplete
// [0x00120000] 
struct UMcpIdMappingBase_execOnAddMappingComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0034 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingBase.AddMapping
// [0x00024000] 
struct UMcpIdMappingBase_execAddMapping_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalToken;                                    		// 0x0030 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpIdMappingBase_execCreateInstance_Parms
{
	class UMcpIdMappingBase*                           ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpIdMappingBaseClass;                            		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpIdMappingBase*                        NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpIdMappingManager.GetIdMappings
// [0x00420002] 
struct UMcpIdMappingManager_execGetIdMappings_Parms
{
	struct FString                                     ExternalType;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpIdMapping >                     IDMappings;                                       		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpIdMappingManager.OnQueryMappingsRequestComplete
// [0x00020002] 
struct UMcpIdMappingManager_execOnQueryMappingsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonString;                                       		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             AccountIndex;                                     		// 0x003C (0x0004) [0x0000000000000000]              
	// unsigned long                                   bWasFound : 1;                                    		// 0x0040 (0x0004) [0x0000000000000000] [0x00000001] 
	// struct FString                                  McpId;                                            		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ExternalId;                                       		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ExternalType;                                     		// 0x0064 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingManager.QueryMappings
// [0x00420002] 
struct UMcpIdMappingManager_execQueryMappings_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           ExternalIds;                                      		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x005C (0x0004) [0x0000000000000000]              
	// unsigned long                                   bFirst : 1;                                       		// 0x0060 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpIdMappingManager.OnAddMappingRequestComplete
// [0x00020002] 
struct UMcpIdMappingManager_execOnAddMappingRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpIdMappingManager.AddMapping
// [0x00024002] 
struct UMcpIdMappingManager_execAddMapping_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalToken;                                    		// 0x0030 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpIdMappingManagerV3.GetIdMappings
// [0x00420002] 
struct UMcpIdMappingManagerV3_execGetIdMappings_Parms
{
	struct FString                                     ExternalType;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpIdMapping >                     IDMappings;                                       		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpIdMappingManagerV3.OnQueryMappingsRequestComplete
// [0x00020002] 
struct UMcpIdMappingManagerV3_execOnQueryMappingsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonString;                                       		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             AccountIndex;                                     		// 0x003C (0x0004) [0x0000000000000000]              
	// unsigned long                                   bWasFound : 1;                                    		// 0x0040 (0x0004) [0x0000000000000000] [0x00000001] 
	// struct FString                                  McpId;                                            		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ExternalId;                                       		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ExternalType;                                     		// 0x0064 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              JsonElement;                                      		// 0x0074 (0x0008) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x007C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingManagerV3.QueryMappings
// [0x00420002] 
struct UMcpIdMappingManagerV3_execQueryMappings_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           ExternalIds;                                      		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x005C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpIdMappingManagerV3.OnAddMappingRequestComplete
// [0x00020002] 
struct UMcpIdMappingManagerV3_execOnAddMappingRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpIdMappingManagerV3.AddMapping
// [0x00024002] 
struct UMcpIdMappingManagerV3_execAddMapping_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalToken;                                    		// 0x0030 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
	// struct FString                                  JSON;                                             		// 0x005C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingManagerV3.BuildQueryMappingResourcePath
// [0x00020002] 
struct UMcpIdMappingManagerV3_execBuildQueryMappingResourcePath_Parms
{
	struct FString                                     Type;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpIdMappingManagerV3.BuildAddMappingResourcePath
// [0x00020002] 
struct UMcpIdMappingManagerV3_execBuildAddMappingResourcePath_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.ClearLeaderboardEntriesForMcpId
// [0x00020000] 
struct UMcpLeaderboardsBase_execClearLeaderboardEntriesForMcpId_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.ClearLeaderboardEntriesForLeaderboard
// [0x00020000] 
struct UMcpLeaderboardsBase_execClearLeaderboardEntriesForLeaderboard_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.ClearAllLeaderboardEntries
// [0x00020000] 
struct UMcpLeaderboardsBase_execClearAllLeaderboardEntries_Parms
{
};

// Function IpDrv.McpLeaderboardsBase.GetLeaderboardByColumnByRange
// [0x00420000] 
struct UMcpLeaderboardsBase_execGetLeaderboardByColumnByRange_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0010 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ColumnName;                                       		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Min;                                              		// 0x0024 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                Max;                                              		// 0x0028 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FMcpLeaderboardEntry >              Entries;                                          		// 0x002C (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.ReadLeaderboardColumnByRange
// [0x00020000] 
struct UMcpLeaderboardsBase_execReadLeaderboardColumnByRange_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0010 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ColumnName;                                       		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Min;                                              		// 0x0024 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                Max;                                              		// 0x0028 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                NumToRead;                                        		// 0x002C (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpLeaderboardsBase.OnWriteLeaderboardEntryComplete
// [0x00120000] 
struct UMcpLeaderboardsBase_execOnWriteLeaderboardEntryComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.WriteLeaderboardEntry
// [0x00420000] 
struct UMcpLeaderboardsBase_execWriteLeaderboardEntry_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardColumnEntry >        Columns;                                          		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.GetEntriesForLeaderboard
// [0x00420000] 
struct UMcpLeaderboardsBase_execGetEntriesForLeaderboard_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardEntry >              Entries;                                          		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.GetLeaderboardEntriesForUsers
// [0x00424000] 
struct UMcpLeaderboardsBase_execGetLeaderboardEntriesForUsers_Parms
{
	TArray< struct FString >                           McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardEntry >              Entries;                                          		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.GetLeaderboardEntries
// [0x00424000] 
struct UMcpLeaderboardsBase_execGetLeaderboardEntries_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardEntry >              Entries;                                          		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.OnReadLeaderboardEntriesComplete
// [0x00120000] 
struct UMcpLeaderboardsBase_execOnReadLeaderboardEntriesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0024 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpLeaderboardsBase.ReadLeaderboardEntries
// [0x00424000] 
struct UMcpLeaderboardsBase_execReadLeaderboardEntries_Parms
{
	TArray< struct FString >                           McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0020 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bSkipRankAndPercentile : 1;                       		// 0x0024 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpLeaderboardsBase.GetLeaderboards
// [0x00420000] 
struct UMcpLeaderboardsBase_execGetLeaderboards_Parms
{
	TArray< struct FMcpLeaderboard >                   Leaderboards;                                     		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.OnReadLeaderboardsComplete
// [0x00120000] 
struct UMcpLeaderboardsBase_execOnReadLeaderboardsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsBase.ReadLeaderboards
// [0x00020000] 
struct UMcpLeaderboardsBase_execReadLeaderboards_Parms
{
};

// Function IpDrv.McpLeaderboardsBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpLeaderboardsBase_execCreateInstance_Parms
{
	class UMcpLeaderboardsBase*                        ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpLeaderboardsBaseClass;                         		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpLeaderboardsBase*                     NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.ClearLeaderboardEntriesForMcpId
// [0x00020002] 
struct UMcpLeaderboardsV3_execClearLeaderboardEntriesForMcpId_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.ClearLeaderboardEntriesForLeaderboard
// [0x00020002] 
struct UMcpLeaderboardsV3_execClearLeaderboardEntriesForLeaderboard_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.ClearAllLeaderboardEntries
// [0x00020002] 
struct UMcpLeaderboardsV3_execClearAllLeaderboardEntries_Parms
{
};

// Function IpDrv.McpLeaderboardsV3.GetLeaderboardByColumnByRange
// [0x00420002] 
struct UMcpLeaderboardsV3_execGetLeaderboardByColumnByRange_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0010 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ColumnName;                                       		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Min;                                              		// 0x0024 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                Max;                                              		// 0x0028 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FMcpLeaderboardEntry >              OutEntries;                                       		// 0x002C (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x003C (0x0004) [0x0000000000000000]              
	// int                                             ValueIndex;                                       		// 0x0040 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.ReadLeaderboardColumnByRange
// [0x00020002] 
struct UMcpLeaderboardsV3_execReadLeaderboardColumnByRange_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0010 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ColumnName;                                       		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Min;                                              		// 0x0024 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                Max;                                              		// 0x0028 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                NumToRead;                                        		// 0x002C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.OnWriteLeaderboardEntryRequestComplete
// [0x00020002] 
struct UMcpLeaderboardsV3_execOnWriteLeaderboardEntryRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.WriteLeaderboardEntry
// [0x00420002] 
struct UMcpLeaderboardsV3_execWriteLeaderboardEntry_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardColumnEntry >        Columns;                                          		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x005C (0x0004) [0x0000000000000000]              
	// struct FString                                  Path;                                             		// 0x0060 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsV3.GetEntriesForLeaderboard
// [0x00420002] 
struct UMcpLeaderboardsV3_execGetEntriesForLeaderboard_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardEntry >              OutEntries;                                       		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.GetLeaderboardEntriesForUsers
// [0x00424002] 
struct UMcpLeaderboardsV3_execGetLeaderboardEntriesForUsers_Parms
{
	TArray< struct FString >                           McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardEntry >              OutEntries;                                       		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.GetLeaderboardEntries
// [0x00424002] 
struct UMcpLeaderboardsV3_execGetLeaderboardEntries_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardEntry >              OutEntries;                                       		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.ParseLeaderboardEntryValues
// [0x00040003] ( FUNC_Final )
struct UMcpLeaderboardsV3_execParseLeaderboardEntryValues_Parms
{
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UJsonObject*                                 LeaderboardEntry;                                 		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FMcpLeaderboardColumnEntry >        ReturnValue;                                      		// 0x0018 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             LbIndex;                                          		// 0x0028 (0x0004) [0x0000000000000000]              
	// int                                             ColumnIndex;                                      		// 0x002C (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
	// class UJsonObject*                              ValuesObject;                                     		// 0x0034 (0x0008) [0x0000000000000000]              
	// TArray< struct FMcpLeaderboardColumnEntry >     Values;                                           		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsV3.ParseLeaderboardEntry
// [0x00040003] ( FUNC_Final )
struct UMcpLeaderboardsV3_execParseLeaderboardEntry_Parms
{
	class UJsonObject*                                 LeaderboardObject;                                		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// int                                             Index;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
	// struct FString                                  LeaderboardName;                                  		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned char                                   Timeframe;                                        		// 0x002C (0x0001) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.ParseLeaderboardEntries
// [0x00040003] ( FUNC_Final )
struct UMcpLeaderboardsV3_execParseLeaderboardEntries_Parms
{
	struct FString                                     JSON;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0010 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.OnReadLeaderboardEntriesRequestComplete
// [0x00020002] 
struct UMcpLeaderboardsV3_execOnReadLeaderboardEntriesRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsV3.ReadLeaderboardEntries
// [0x00424002] 
struct UMcpLeaderboardsV3_execReadLeaderboardEntries_Parms
{
	TArray< struct FString >                           McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0020 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bSkipRankAndPercentile : 1;                       		// 0x0024 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0038 (0x0008) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0050 (0x0004) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.TimeframeToString
// [0x00040003] ( FUNC_Final )
struct UMcpLeaderboardsV3_execTimeframeToString_Parms
{
	unsigned char                                      Timeframe;                                        		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsV3.StringToTimeframe
// [0x00040003] ( FUNC_Final )
struct UMcpLeaderboardsV3_execStringToTimeframe_Parms
{
	struct FString                                     Timeframe;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0010 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpLeaderboardsV3.GetLeaderboards
// [0x00420002] 
struct UMcpLeaderboardsV3_execGetLeaderboards_Parms
{
	TArray< struct FMcpLeaderboard >                   OutLeaderboards;                                  		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsV3.ParseLeaderboard
// [0x00040003] ( FUNC_Final )
struct UMcpLeaderboardsV3_execParseLeaderboard_Parms
{
	class UJsonObject*                                 LeaderboardObject;                                		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// int                                             Index;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
	// int                                             ColumnIndex;                                      		// 0x000C (0x0004) [0x0000000000000000]              
	// int                                             TimeframeIndex;                                   		// 0x0010 (0x0004) [0x0000000000000000]              
	// class UJsonObject*                              ColumnObject;                                     		// 0x0014 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              TimeframeObject;                                  		// 0x001C (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.ParseLeaderboards
// [0x00040003] ( FUNC_Final )
struct UMcpLeaderboardsV3_execParseLeaderboards_Parms
{
	struct FString                                     JSON;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0010 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpLeaderboardsV3.OnReadLeaderboardsRequestComplete
// [0x00020002] 
struct UMcpLeaderboardsV3_execOnReadLeaderboardsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpLeaderboardsV3.ReadLeaderboards
// [0x00020002] 
struct UMcpLeaderboardsV3_execReadLeaderboards_Parms
{
	// struct FString                                  URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManagerBase.OnDeleteValueComplete
// [0x00120000] 
struct UMcpManagedValueManagerBase_execOnDeleteValueComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0028 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x002C (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManagerBase.DeleteValue
// [0x00020000] 
struct UMcpManagedValueManagerBase_execDeleteValue_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpManagedValueManagerBase.OnUpdateValueComplete
// [0x00120000] 
struct UMcpManagedValueManagerBase_execOnUpdateValueComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                Value;                                            		// 0x0028 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x002C (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManagerBase.UpdateValue
// [0x00020000] 
struct UMcpManagedValueManagerBase_execUpdateValue_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                Value;                                            		// 0x0028 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpManagedValueManagerBase.GetValue
// [0x00020000] 
struct UMcpManagedValueManagerBase_execGetValue_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0028 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpManagedValueManagerBase.GetValues
// [0x00020000] 
struct UMcpManagedValueManagerBase_execGetValues_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FManagedValue >                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManagerBase.OnReadSaveSlotComplete
// [0x00120000] 
struct UMcpManagedValueManagerBase_execOnReadSaveSlotComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManagerBase.ReadSaveSlot
// [0x00020000] 
struct UMcpManagedValueManagerBase_execReadSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManagerBase.OnCreateSaveSlotComplete
// [0x00120000] 
struct UMcpManagedValueManagerBase_execOnCreateSaveSlotComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManagerBase.CreateSaveSlot
// [0x00020000] 
struct UMcpManagedValueManagerBase_execCreateSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManagerBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpManagedValueManagerBase_execCreateInstance_Parms
{
	class UMcpManagedValueManagerBase*                 ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpManagedValueManagerBaseClass;                  		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpManagedValueManagerBase*              NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.OnDeleteValueRequestComplete
// [0x00020002] 
struct UMcpManagedValueManager_execOnDeleteValueRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x001C (0x0004) [0x0000000000000000]              
	// int                                             ValueIndex;                                       		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.DeleteValue
// [0x00020002] 
struct UMcpManagedValueManager_execDeleteValue_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0038 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0040 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.OnUpdateValueRequestComplete
// [0x00020002] 
struct UMcpManagedValueManager_execOnUpdateValueRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             UpdatedValue;                                     		// 0x002C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.UpdateValue
// [0x00020002] 
struct UMcpManagedValueManager_execUpdateValue_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                Value;                                            		// 0x0028 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x003C (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0044 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.GetValue
// [0x00020002] 
struct UMcpManagedValueManager_execGetValue_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FName                                       ValueId;                                          		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0028 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             SaveSlotIndex;                                    		// 0x002C (0x0004) [0x0000000000000000]              
	// int                                             ValueIndex;                                       		// 0x0030 (0x0004) [0x0000000000000000]              
	// int                                             Value;                                            		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.GetValues
// [0x00020002] 
struct UMcpManagedValueManager_execGetValues_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FManagedValue >                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             SaveSlotIndex;                                    		// 0x0030 (0x0004) [0x0000000000000000]              
	// TArray< struct FManagedValue >                  EmptyArray;                                       		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManager.OnReadSaveSlotRequestComplete
// [0x00020002] 
struct UMcpManagedValueManager_execOnReadSaveSlotRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManager.ReadSaveSlot
// [0x00020002] 
struct UMcpManagedValueManager_execReadSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.ParseValuesForSaveSlot
// [0x00020002] 
struct UMcpManagedValueManager_execParseValuesForSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     JsonPayload;                                      		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x003C (0x0004) [0x0000000000000000]              
	// int                                             ManagedValueIndex;                                		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FName                                    ValueId;                                          		// 0x0044 (0x0008) [0x0000000000000000]              
	// int                                             Value;                                            		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.FindSaveSlotIndex
// [0x00020002] 
struct UMcpManagedValueManager_execFindSaveSlotIndex_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0020 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             SaveSlotIndex;                                    		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpManagedValueManager.OnCreateSaveSlotRequestComplete
// [0x00020002] 
struct UMcpManagedValueManager_execOnCreateSaveSlotRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpManagedValueManager.CreateSaveSlot
// [0x00020002] 
struct UMcpManagedValueManager_execCreateSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManagerV3.GetMessageContents
// [0x00420002] 
struct UMcpMessageManagerV3_execGetMessageContents_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            MessageContents;                                  		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             MessageIndex;                                     		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManagerV3.OnQueryMessageContentsRequestComplete
// [0x00020002] 
struct UMcpMessageManagerV3_execOnQueryMessageContentsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x003C (0x0008) [0x0000000000000000]              
	// int                                             ContentsIndex;                                    		// 0x0044 (0x0004) [0x0000000000000000]              
	// struct FString                                  MessageId;                                        		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< unsigned char >                         TempContents;                                     		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  BodyString;                                       		// 0x0068 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManagerV3.QueryMessageContents
// [0x00020002] 
struct UMcpMessageManagerV3_execQueryMessageContents_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResourcePath;                                     		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManagerV3.GetMessageList
// [0x00420002] 
struct UMcpMessageManagerV3_execGetMessageList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpMessageList                             MessageList;                                      		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             UserIndex;                                        		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManagerV3.OnQueryMessagesRequestComplete
// [0x00020002] 
struct UMcpMessageManagerV3_execOnQueryMessagesRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x003C (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x0044 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x004C (0x0004) [0x0000000000000000]              
	// int                                             ListIndex;                                        		// 0x0050 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManagerV3.ParseMessage
// [0x00080002] 
struct UMcpMessageManagerV3_execParseMessage_Parms
{
	class UJsonObject*                                 ParsedJson;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0008 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             UserIndex;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	// int                                             MessageIndex;                                     		// 0x0010 (0x0004) [0x0000000000000000]              
	// struct FString                                  MessageId;                                        		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManagerV3.QueryMessages
// [0x00020002] 
struct UMcpMessageManagerV3_execQueryMessages_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpMessageManagerV3.OnDeleteMessageRequestComplete
// [0x00020002] 
struct UMcpMessageManagerV3_execOnDeleteMessageRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManagerV3.DeleteMessage
// [0x00020002] 
struct UMcpMessageManagerV3_execDeleteMessage_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageId;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResourcePath;                                     		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManagerV3.OnCreateMessageRequestComplete
// [0x00020002] 
struct UMcpMessageManagerV3_execOnCreateMessageRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpMessageManagerV3.CreateMessage
// [0x00420002] 
struct UMcpMessageManagerV3_execCreateMessage_Parms
{
	TArray< struct FString >                           ToUniqueUserIds;                                  		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     FromUniqueUserId;                                 		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FromFriendlyName;                                 		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     MessageType;                                      		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PushMessage;                                      		// 0x0040 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ValidUntil;                                       		// 0x0050 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            Body;                                             		// 0x0060 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0080 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0088 (0x0004) [0x0000000000000000]              
	// struct FString                                  JSON;                                             		// 0x008C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ToIndex;                                          		// 0x009C (0x0004) [0x0000000000000000]              
	// struct FString                                  BodyString;                                       		// 0x00A0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpRemoteNotificationBase.OnRegisterPushNotificationTokenComplete
// [0x00120000] 
struct UMcpRemoteNotificationBase_execOnRegisterPushNotificationTokenComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     McpId;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PushToken;                                        		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpRemoteNotificationBase.RegisterPushNotificationToken
// [0x00020000] 
struct UMcpRemoteNotificationBase_execRegisterPushNotificationToken_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PushNotificationToken;                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpRemoteNotificationBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpRemoteNotificationBase_execCreateInstance_Parms
{
	class UMcpRemoteNotificationBase*                  ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpRemoteNotificationClass;                       		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpRemoteNotificationBase*               NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpRemoteNotificationV3.OnAssociatePushNotificationTokenRequestComplete
// [0x00020002] 
struct UMcpRemoteNotificationV3_execOnAssociatePushNotificationTokenRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  PushToken;                                        		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpRemoteNotificationV3.AssociatePushNotificationToken
// [0x00020002] 
struct UMcpRemoteNotificationV3_execAssociatePushNotificationToken_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PushNotificationToken;                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpRemoteNotificationV3.OnPushNotificationRequestComplete
// [0x00020002] 
struct UMcpRemoteNotificationV3_execOnPushNotificationRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  PushToken;                                        		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpRemoteNotificationV3.RegisterPushNotificationToken
// [0x00020002] 
struct UMcpRemoteNotificationV3_execRegisterPushNotificationToken_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PushNotificationToken;                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpServerTimeBase.GetLastServerTime
// [0x00020000] 
struct UMcpServerTimeBase_execGetLastServerTime_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServerTimeBase.OnQueryServerTimeComplete
// [0x00120000] 
struct UMcpServerTimeBase_execOnQueryServerTimeComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     DateTimeStr;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServerTimeBase.QueryServerTime
// [0x00020000] 
struct UMcpServerTimeBase_execQueryServerTime_Parms
{
};

// Function IpDrv.McpServerTimeBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpServerTimeBase_execCreateInstance_Parms
{
	class UMcpServerTimeBase*                          ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpServerTimeBaseClass;                           		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpServerTimeBase*                       NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpServerTimeManager.GetLastServerTime
// [0x00020002] 
struct UMcpServerTimeManager_execGetLastServerTime_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServerTimeManager.OnQueryServerTimeHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpServerTimeManager_execOnQueryServerTimeHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  TimeStr;                                          		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseStr;                                      		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Idx;                                              		// 0x0044 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bResult : 1;                                      		// 0x0048 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpServerTimeManager.QueryServerTime
// [0x00020002] 
struct UMcpServerTimeManager_execQueryServerTime_Parms
{
	// struct FString                                  URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bPending : 1;                                     		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpServerTimeManagerV3.GetLastServerTime
// [0x00020002] 
struct UMcpServerTimeManagerV3_execGetLastServerTime_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpServerTimeManagerV3.OnQueryServerTimeHTTPRequestComplete
// [0x00040003] ( FUNC_Final )
struct UMcpServerTimeManagerV3_execOnQueryServerTimeHTTPRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  ResponseString;                                   		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Error;                                            		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bResult : 1;                                      		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpServerTimeManagerV3.QueryServerTime
// [0x00020002] 
struct UMcpServerTimeManagerV3_execQueryServerTime_Parms
{
	// struct FString                                  URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorStr;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bPending : 1;                                     		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpSystemCloudFileManagerV3.GetTitleFileList
// [0x00C20002] 
struct UMcpSystemCloudFileManagerV3_execGetTitleFileList_Parms
{
	TArray< struct FEmsFile >                          FileList;                                         		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             FileIndex;                                        		// 0x0010 (0x0004) [0x0000000000000000]              
	// struct FEmsFile                                 FileData;                                         		// 0x0014 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpSystemCloudFileManagerV3.ClearRequestTitleFileListCompleteDelegate
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execClearRequestTitleFileListCompleteDelegate_Parms
{
	struct FScriptDelegate                             RequestTitleFileListDelegate;                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.AddRequestTitleFileListCompleteDelegate
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execAddRequestTitleFileListCompleteDelegate_Parms
{
	struct FScriptDelegate                             RequestTitleFileListDelegate;                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpSystemCloudFileManagerV3.ParseFile
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execParseFile_Parms
{
	class UJsonObject*                                 JsonNode;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	// struct FString                                  UniqueFileName;                                   		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bHasParseError : 1;                               		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpSystemCloudFileManagerV3.ParseFiles
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execParseFiles_Parms
{
	struct FString                                     JSON;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0014 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x001C (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.OnReadTitleFileListRequestComplete
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execOnReadTitleFileListRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpSystemCloudFileManagerV3.RequestTitleFileList
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execRequestTitleFileList_Parms
{
	// struct FString                                  URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.ClearDownloadedFile
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execClearDownloadedFile_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.GetFileIndex
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execGetFileIndex_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.ClearDownloadedFiles
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execClearDownloadedFiles_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0004 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.GetTitleFileState
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execGetTitleFileState_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0010 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.GetTitleFileContents
// [0x00420002] 
struct UMcpSystemCloudFileManagerV3_execGetTitleFileContents_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.ClearReadTitleFileCompleteDelegate
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execClearReadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadTitleFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.AddReadTitleFileCompleteDelegate
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execAddReadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadTitleFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpSystemCloudFileManagerV3.OnReadTitleFileRequestComplete
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execOnReadTitleFileRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x003C (0x0004) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FString                                  Filename;                                         		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< unsigned char >                         Data;                                             		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpSystemCloudFileManagerV3.ReadTitleFile
// [0x00020002] 
struct UMcpSystemCloudFileManagerV3_execReadTitleFile_Parms
{
	struct FString                                     FileToRead;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0028 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpSystemCloudFileManagerV3.OnReadTitleFileComplete
// [0x00120000] 
struct UMcpSystemCloudFileManagerV3_execOnReadTitleFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpSystemCloudFileManagerV3.OnRequestTitleFileListComplete
// [0x00120000] 
struct UMcpSystemCloudFileManagerV3_execOnRequestTitleFileListComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ResultStr;                                        		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpSystemCloudFileManagerV3.CreateHttpRequest
// [0x00024002] 
struct UMcpSystemCloudFileManagerV3_execCreateHttpRequest_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0018 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatBase.OnDeleteUserDataComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnDeleteUserDataComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     McpId;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.DeleteUserData
// [0x00020000] 
struct UMcpThreadedChatBase_execDeleteUserData_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.VoteDownPost
// [0x00020000] 
struct UMcpThreadedChatBase_execVoteDownPost_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PostId;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.OnVoteOnPostComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnVoteOnPostComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     PostId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.VoteUpPost
// [0x00020000] 
struct UMcpThreadedChatBase_execVoteUpPost_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PostId;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.OnReportPostComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnReportPostComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     PostId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.ReportPost
// [0x00020000] 
struct UMcpThreadedChatBase_execReportPost_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PostId;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.OnPostToThreadComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnPostToThreadComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.PostToThread
// [0x00024000] 
struct UMcpThreadedChatBase_execPostToThread_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     OwnerName;                                        		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Message;                                          		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReplyToMessageId;                                 		// 0x0040 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReplyToOwnerId;                                   		// 0x0050 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReplyToOwnerName;                                 		// 0x0060 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.ClearChatPosts
// [0x00020000] 
struct UMcpThreadedChatBase_execClearChatPosts_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.GetChatPosts
// [0x00420000] 
struct UMcpThreadedChatBase_execGetChatPosts_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpChatPost >                      ChatPosts;                                        		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.GetChatPostsForUser
// [0x00424000] 
struct UMcpThreadedChatBase_execGetChatPostsForUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpChatPost >                      ChatPosts;                                        		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     ThreadId;                                         		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.OnReadChatPostsConcerningUserComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnReadChatPostsConcerningUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.ReadChatPostsConcerningUser
// [0x00024000] 
struct UMcpThreadedChatBase_execReadChatPostsConcerningUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ThreadId;                                         		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	int                                                Start;                                            		// 0x0020 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                Count;                                            		// 0x0024 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpThreadedChatBase.OnReadChatPostsComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnReadChatPostsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.ReadChatPostsByPopularity
// [0x00024000] 
struct UMcpThreadedChatBase_execReadChatPostsByPopularity_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Start;                                            		// 0x0010 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                Count;                                            		// 0x0014 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpThreadedChatBase.ReadChatPostsForUsers
// [0x00424000] 
struct UMcpThreadedChatBase_execReadChatPostsForUsers_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           McpIds;                                           		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                Start;                                            		// 0x0020 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                Count;                                            		// 0x0024 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpThreadedChatBase.ReadChatPostsByTime
// [0x00024000] 
struct UMcpThreadedChatBase_execReadChatPostsByTime_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Before;                                           		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	int                                                Count;                                            		// 0x0020 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
};

// Function IpDrv.McpThreadedChatBase.OnCreateUserChatThreadComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnCreateUserChatThreadComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     McpId;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ThreadName;                                       		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.CreateUserChatThread
// [0x00020000] 
struct UMcpThreadedChatBase_execCreateUserChatThread_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ThreadName;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.GetUserChatThreads
// [0x00420000] 
struct UMcpThreadedChatBase_execGetUserChatThreads_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpUserChatThread >                UserChatThreads;                                  		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.OnReadUserChatThreadsComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnReadUserChatThreadsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     McpId;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.ReadUserChatThreads
// [0x00020000] 
struct UMcpThreadedChatBase_execReadUserChatThreads_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.GetSystemChatThreads
// [0x00420000] 
struct UMcpThreadedChatBase_execGetSystemChatThreads_Parms
{
	TArray< struct FMcpSystemChatThread >              SystemChatThreads;                                		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.OnReadSystemChatThreadsComplete
// [0x00120000] 
struct UMcpThreadedChatBase_execOnReadSystemChatThreadsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatBase.ReadSystemChatThreads
// [0x00020000] 
struct UMcpThreadedChatBase_execReadSystemChatThreads_Parms
{
};

// Function IpDrv.McpThreadedChatBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpThreadedChatBase_execCreateInstance_Parms
{
	class UMcpThreadedChatBase*                        ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpThreadedChatBaseClass;                         		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpThreadedChatBase*                     NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnDeleteUserDataRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnDeleteUserDataRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.DeleteUserData
// [0x00020002] 
struct UMcpThreadedChatV3_execDeleteUserData_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnVoteOnPostRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnVoteOnPostRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.VoteOnPost
// [0x00020002] 
struct UMcpThreadedChatV3_execVoteOnPost_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PostId;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bVoteUp : 1;                                      		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0044 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.VoteDownPost
// [0x00020002] 
struct UMcpThreadedChatV3_execVoteDownPost_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PostId;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.VoteUpPost
// [0x00020002] 
struct UMcpThreadedChatV3_execVoteUpPost_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PostId;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.OnReportPostRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnReportPostRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ReportPost
// [0x00020002] 
struct UMcpThreadedChatV3_execReportPost_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     PostId;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnPostToThreadRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnPostToThreadRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x003C (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.PostToThread
// [0x00024002] 
struct UMcpThreadedChatV3_execPostToThread_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     OwnerName;                                        		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Message;                                          		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReplyToMessageId;                                 		// 0x0040 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReplyToOwnerId;                                   		// 0x0050 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReplyToOwnerName;                                 		// 0x0060 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0080 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0088 (0x0004) [0x0000000000000000]              
	// struct FString                                  JSON;                                             		// 0x008C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ClearChatPosts
// [0x00020002] 
struct UMcpThreadedChatV3_execClearChatPosts_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.GetChatPostsForUser
// [0x00424002] 
struct UMcpThreadedChatV3_execGetChatPostsForUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpChatPost >                      OutChatPosts;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     ThreadId;                                         		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.GetChatPosts
// [0x00420002] 
struct UMcpThreadedChatV3_execGetChatPosts_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpChatPost >                      OutChatPosts;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.ParseChatPost
// [0x00080002] 
struct UMcpThreadedChatV3_execParseChatPost_Parms
{
	class UJsonObject*                                 ParsedJson;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  PostId;                                           		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             PostIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.ParseChatPosts
// [0x00020002] 
struct UMcpThreadedChatV3_execParseChatPosts_Parms
{
	struct FString                                     JsonPayload;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0010 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x0018 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnReadChatPostsConcerningUserRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnReadChatPostsConcerningUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ReadChatPostsConcerningUser
// [0x00024002] 
struct UMcpThreadedChatV3_execReadChatPostsConcerningUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ThreadId;                                         		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	int                                                Start;                                            		// 0x0020 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                Count;                                            		// 0x0024 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0038 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FString                                  Path;                                             		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ReadChatPostsForUsers
// [0x00424002] 
struct UMcpThreadedChatV3_execReadChatPostsForUsers_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           McpIds;                                           		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                Start;                                            		// 0x0020 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                Count;                                            		// 0x0024 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0038 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.ReadChatPostsByPopularity
// [0x00024002] 
struct UMcpThreadedChatV3_execReadChatPostsByPopularity_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Start;                                            		// 0x0010 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                Count;                                            		// 0x0014 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0028 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnReadChatPostsRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnReadChatPostsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ReadChatPostsByTime
// [0x00024002] 
struct UMcpThreadedChatV3_execReadChatPostsByTime_Parms
{
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Before;                                           		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	int                                                Count;                                            		// 0x0020 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0034 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x003C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnCreateUserChatThreadRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnCreateUserChatThreadRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x003C (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.CreateUserChatThread
// [0x00020002] 
struct UMcpThreadedChatV3_execCreateUserChatThread_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ThreadName;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.GetUserChatThreads
// [0x00420002] 
struct UMcpThreadedChatV3_execGetUserChatThreads_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpUserChatThread >                OutUserChatThreads;                               		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnReadUserChatThreadsRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnReadUserChatThreadsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ReadUserChatThreads
// [0x00020002] 
struct UMcpThreadedChatV3_execReadUserChatThreads_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.GetSystemChatThreads
// [0x00420002] 
struct UMcpThreadedChatV3_execGetSystemChatThreads_Parms
{
	TArray< struct FMcpSystemChatThread >              OutSystemChatThreads;                             		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ParseUserChatThread
// [0x00080002] 
struct UMcpThreadedChatV3_execParseUserChatThread_Parms
{
	class UJsonObject*                                 ParsedJson;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  ThreadId;                                         		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ThreadIndex;                                      		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.ParseSystemChatThread
// [0x00080002] 
struct UMcpThreadedChatV3_execParseSystemChatThread_Parms
{
	class UJsonObject*                                 ParsedJson;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  ThreadId;                                         		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ThreadIndex;                                      		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.ParseThreads
// [0x00080002] 
struct UMcpThreadedChatV3_execParseThreads_Parms
{
	struct FString                                     JsonPayload;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bSystemThread : 1;                                		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0014 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x001C (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpThreadedChatV3.OnReadSystemChatThreadsRequestComplete
// [0x00020002] 
struct UMcpThreadedChatV3_execOnReadSystemChatThreadsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpThreadedChatV3.ReadSystemChatThreads
// [0x00020002] 
struct UMcpThreadedChatV3_execReadSystemChatThreads_Parms
{
	// struct FString                                  URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserAuthResponseWrapper.GetContentAsString
// [0x00020002] 
struct UMcpUserAuthResponseWrapper_execGetContentAsString_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserAuthResponseWrapper.GetResponseCode
// [0x00020002] 
struct UMcpUserAuthResponseWrapper_execGetResponseCode_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserAuthResponseWrapper.Init
// [0x00020002] 
struct UMcpUserAuthResponseWrapper_execInit_Parms
{
	int                                                InResponseCode;                                   		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     InErrorString;                                    		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.GetLastNCloudSaveOwners
// [0x00420002] 
struct UMcpUserCloudFileManagerV3_execGetLastNCloudSaveOwners_Parms
{
	TArray< struct FString >                           McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearReadLastNCloudSaveOwnersCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearReadLastNCloudSaveOwnersCompleteDelegate_Parms
{
	struct FScriptDelegate                             CompleteDelegate;                                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.AddReadLastNCloudSaveOwnersCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execAddReadLastNCloudSaveOwnersCompleteDelegate_Parms
{
	struct FScriptDelegate                             CompleteDelegate;                                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.OnReadLastNCloudSaveOwnersRequestComplete
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execOnReadLastNCloudSaveOwnersRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0048 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0050 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0064 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.ReadLastNCloudSaveOwners
// [0x00024002] 
struct UMcpUserCloudFileManagerV3_execReadLastNCloudSaveOwners_Parms
{
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0024 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearDeleteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearDeleteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ClearDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.AddDeleteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execAddDeleteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             AddDelegate;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearWriteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearWriteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ClearDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.AddWriteUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execAddWriteUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             AddDelegate;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearReadUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearReadUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ClearDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.AddReadUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execAddReadUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             AddDelegate;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearEnumerateUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearEnumerateUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ClearDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.AddEnumerateUserFileCompleteDelegate
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execAddEnumerateUserFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             AddDelegate;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearAllDelegates
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearAllDelegates_Parms
{
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearFile
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.ClearFiles
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execClearFiles_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.GetFileContents
// [0x00420002] 
struct UMcpUserCloudFileManagerV3_execGetFileContents_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.GetUserFileList
// [0x00C20002] 
struct UMcpUserCloudFileManagerV3_execGetUserFileList_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FEmsFile >                          UserFiles;                                        		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             FileIndex;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
	// struct FEmsFile                                 File;                                             		// 0x0024 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.FindUserFileIndex
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execFindUserFileIndex_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0020 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.OnWriteUserFileRequestComplete
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execOnWriteUserFileRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x004C (0x0004) [0x0000000000000000]              
	// struct FString                                  URL;                                              		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.WriteUserFile
// [0x00420002] 
struct UMcpUserCloudFileManagerV3_execWriteUserFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0044 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x004C (0x0004) [0x0000000000000000]              
	// int                                             RequestIndex;                                     		// 0x0050 (0x0004) [0x0000000000000000]              
	// class UMcpUserManagerBase*                      UserManager;                                      		// 0x0054 (0x0008) [0x0000000000000000]              
	// struct FString                                  AuthToken;                                        		// 0x005C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x006C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x007C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.OnDeleteUserFileRequestComplete
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execOnDeleteUserFileRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.DeleteUserFile
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execDeleteUserFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldCloudDelete : 1;                           		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      bShouldLocallyDelete : 1;                         		// 0x0024 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0028 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// struct FString                                  URL;                                              		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x003C (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0044 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.OnReadUserFileRequestComplete
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execOnReadUserFileRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< unsigned char >                         Data;                                             		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.ReadUserFile
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execReadUserFile_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// struct FString                                  URL;                                              		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0034 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x003C (0x0004) [0x0000000000000000]              
	// int                                             FileIndex;                                        		// 0x0040 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             DelegateIndex;                                    		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.ParseFile
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execParseFile_Parms
{
	class UJsonObject*                                 JsonNode;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FileIndex;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	// struct FString                                  UniqueFileName;                                   		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bHasParseError : 1;                               		// 0x0030 (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.McpUserCloudFileManagerV3.ParseFiles
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execParseFiles_Parms
{
	struct FString                                     JSON;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0014 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x001C (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.OnEnumerateUserFilesRequestComplete
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execOnEnumerateUserFilesRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             ResponseCode;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          OnRequestComplete;                                		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             RequestIndex;                                     		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.EnumerateUserFiles
// [0x00020002] 
struct UMcpUserCloudFileManagerV3_execEnumerateUserFiles_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.CreateHttpRequest
// [0x00024002] 
struct UMcpUserCloudFileManagerV3_execCreateHttpRequest_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0018 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.BuildFileResourcePath
// [0x00024002] 
struct UMcpUserCloudFileManagerV3_execBuildFileResourcePath_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0040 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserCloudFileManagerV3.OnReadLastNCloudSaveOwnersComplete
// [0x00120000] 
struct UMcpUserCloudFileManagerV3_execOnReadLastNCloudSaveOwnersComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function IpDrv.McpUserCloudFileManagerV3.OnDeleteUserFileComplete
// [0x00120000] 
struct UMcpUserCloudFileManagerV3_execOnDeleteUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.OnWriteUserFileComplete
// [0x00120000] 
struct UMcpUserCloudFileManagerV3_execOnWriteUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.OnReadUserFileComplete
// [0x00120000] 
struct UMcpUserCloudFileManagerV3_execOnReadUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserCloudFileManagerV3.OnEnumerateUserFilesComplete
// [0x00120000] 
struct UMcpUserCloudFileManagerV3_execOnEnumerateUserFilesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.GetIapList
// [0x00420000] 
struct UMcpUserInventoryBase_execGetIapList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpIapList                                 Iaps;                                             		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserInventoryBase.OnQueryIapListComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnQueryIapListComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.QueryIapList
// [0x00020000] 
struct UMcpUserInventoryBase_execQueryIapList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.GetSaveSlot
// [0x00420000] 
struct UMcpUserInventoryBase_execGetSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpInventorySaveSlot                       SaveSlot;                                         		// 0x0020 (0x0030) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0050 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserInventoryBase.OnReadSaveSlotComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnReadSaveSlotComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.ReadSaveSlot
// [0x00020000] 
struct UMcpUserInventoryBase_execReadSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.OnRecordIapComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnRecordIapComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpIapItem >                       UpdatedItems;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0034 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.RecordIap
// [0x00020000] 
struct UMcpUserInventoryBase_execRecordIap_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Vendor;                                           		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Receipt;                                          		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.OnDeleteItemComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnDeleteItemComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0034 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.DeleteItem
// [0x00020000] 
struct UMcpUserInventoryBase_execDeleteItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                StoreVersion;                                     		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpUserInventoryBase.OnConsumeItemComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnConsumeItemComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           UpdatedItemIds;                                   		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0040 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0044 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.ConsumeItem
// [0x00020000] 
struct UMcpUserInventoryBase_execConsumeItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpUserInventoryBase.OnEarnItemComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnEarnItemComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GlobalItemId;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           UpdatedItemIds;                                   		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0040 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0044 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.EarnItem
// [0x00020000] 
struct UMcpUserInventoryBase_execEarnItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GlobalItemId;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpUserInventoryBase.OnSellItemComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnSellItemComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           UpdatedItemIds;                                   		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0040 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0044 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.SellItem
// [0x00424000] 
struct UMcpUserInventoryBase_execSellItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FMcpInventoryItemContainer >        ExpectedResultItems;                              		// 0x0038 (0x0010) [0x0000000000400192]              ( CPF_Const | CPF_OptionalParm | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.OnPurchaseItemComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnPurchaseItemComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GlobalItemId;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           UpdatedItemIds;                                   		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0040 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0044 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.PurchaseItem
// [0x00020000] 
struct UMcpUserInventoryBase_execPurchaseItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GlobalItemId;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           PurchaseItemIds;                                  		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0040 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0044 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	float                                              Scalar;                                           		// 0x0048 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.McpUserInventoryBase.GetInventoryItem
// [0x00420000] 
struct UMcpUserInventoryBase_execGetInventoryItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpInventoryItem                           OutInventoryItem;                                 		// 0x0030 (0x004C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x007C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.McpUserInventoryBase.GetInventoryItems
// [0x00420000] 
struct UMcpUserInventoryBase_execGetInventoryItems_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpInventoryItem >                 OutInventoryItems;                                		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.OnQueryInventoryItemsComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnQueryInventoryItemsComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.QueryInventoryItems
// [0x00020000] 
struct UMcpUserInventoryBase_execQueryInventoryItems_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.OnQuerySaveSlotListComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnQuerySaveSlotListComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.GetSaveSlotList
// [0x00020000] 
struct UMcpUserInventoryBase_execGetSaveSlotList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.QuerySaveSlotList
// [0x00020000] 
struct UMcpUserInventoryBase_execQuerySaveSlotList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.OnDeleteSaveSlotComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnDeleteSaveSlotComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.DeleteSaveSlot
// [0x00020000] 
struct UMcpUserInventoryBase_execDeleteSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.OnCreateSaveSlotComplete
// [0x00120000] 
struct UMcpUserInventoryBase_execOnCreateSaveSlotComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.CreateSaveSlot
// [0x00024000] 
struct UMcpUserInventoryBase_execCreateSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ParentSaveSlotId;                                 		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryBase.CreateInstance
// [0x00022003] ( FUNC_Final )
struct UMcpUserInventoryBase_execCreateInstance_Parms
{
	class UMcpUserInventoryBase*                       ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UClass*                                   McpUserInventoryBaseClass;                        		// 0x0008 (0x0008) [0x0000000000000000]              
	// class UMcpUserInventoryBase*                    NewInstance;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnRecordIapRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnRecordIapRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.RecordIap
// [0x00020002] 
struct UMcpUserInventoryManager_execRecordIap_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Vendor;                                           		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Receipt;                                          		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x005C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnDeleteItemRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnDeleteItemRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ItemIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.DeleteItem
// [0x00020002] 
struct UMcpUserInventoryManager_execDeleteItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                StoreVersion;                                     		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0044 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x004C (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x0050 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnConsumeItemRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnConsumeItemRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< struct FString >                        UpdatedItemIds;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.ConsumeItem
// [0x00020002] 
struct UMcpUserInventoryManager_execConsumeItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0048 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0050 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnEarnItemRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnEarnItemRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< struct FString >                        UpdatedItemIds;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.EarnItem
// [0x00020002] 
struct UMcpUserInventoryManager_execEarnItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GlobalItemId;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0048 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0050 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnSellItemRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnSellItemRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             UpdatedItemIdIndex;                               		// 0x001C (0x0004) [0x0000000000000000]              
	// int                                             FoundItemIndex;                                   		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< struct FString >                        UpdatedItemIds;                                   		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.SellItem
// [0x00424002] 
struct UMcpUserInventoryManager_execSellItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0030 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0034 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FMcpInventoryItemContainer >        ExpectedResultItems;                              		// 0x0038 (0x0010) [0x0000000000400192]              ( CPF_Const | CPF_OptionalParm | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  expectedResultsItemsJson;                         		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0068 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0070 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x0074 (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x0078 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnPurchaseItemRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnPurchaseItemRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             UpdatedItemIdIndex;                               		// 0x001C (0x0004) [0x0000000000000000]              
	// int                                             FoundItemIndex;                                   		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< struct FString >                        UpdatedItemIds;                                   		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.PurchaseItem
// [0x00020002] 
struct UMcpUserInventoryManager_execPurchaseItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GlobalItemId;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           PurchaseItemIds;                                  		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0040 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	int                                                StoreVersion;                                     		// 0x0044 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	float                                              Scalar;                                           		// 0x0048 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	// struct FString                                  URL;                                              		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  paymentItemsJson;                                 		// 0x005C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x006C (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0074 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x0078 (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x007C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.FindItemRequest
// [0x00420002] 
struct UMcpUserInventoryManager_execFindItemRequest_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ItemId;                                           		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FInventoryItemRequestState >        InItemRequests;                                   		// 0x0030 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0040 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Index;                                            		// 0x0044 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.FindSaveSlotRequest
// [0x00420002] 
struct UMcpUserInventoryManager_execFindSaveSlotRequest_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct UMcpUserInventoryManager_FSaveSlotRequestState > InSaveSlotRequests;                               		// 0x0020 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0030 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Index;                                            		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.FindSaveSlotIndex
// [0x00020002] 
struct UMcpUserInventoryManager_execFindSaveSlotIndex_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0020 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             SaveSlotIndex;                                    		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.ParseSaveSlotList
// [0x00020002] 
struct UMcpUserInventoryManager_execParseSaveSlotList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     JsonPayload;                                      		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0028 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x002C (0x0004) [0x0000000000000000]              
	// struct FString                                  SaveSlotId;                                       		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.ParseInventoryForSaveSlot
// [0x00020002] 
struct UMcpUserInventoryManager_execParseInventoryForSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     JsonPayload;                                      		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           ReturnValue;                                      		// 0x0030 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0040 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              ParsedJsonAttrs;                                  		// 0x0048 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0050 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x0054 (0x0004) [0x0000000000000000]              
	// int                                             ItemIndex;                                        		// 0x0058 (0x0004) [0x0000000000000000]              
	// int                                             JsonAttrsIndex;                                   		// 0x005C (0x0004) [0x0000000000000000]              
	// struct FString                                  GlobalItemId;                                     		// 0x0060 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  InstanceItemId;                                   		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< struct FString >                        UpdatedItemIds;                                   		// 0x0080 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< class UJsonObject* >                    ObjectArray;                                      		// 0x0090 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.GetInventoryItem
// [0x00420002] 
struct UMcpUserInventoryManager_execGetInventoryItem_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InstanceItemId;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpInventoryItem                           OutInventoryItem;                                 		// 0x0030 (0x004C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x007C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             SaveSlotIndex;                                    		// 0x0080 (0x0004) [0x0000000000000000]              
	// int                                             ItemIndex;                                        		// 0x0084 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.GetInventoryItems
// [0x00420002] 
struct UMcpUserInventoryManager_execGetInventoryItems_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpInventoryItem >                 OutInventoryItems;                                		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// int                                             SaveSlotIndex;                                    		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnQueryInventoryItemsRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnQueryInventoryItemsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.QueryInventoryItems
// [0x00020002] 
struct UMcpUserInventoryManager_execQueryInventoryItems_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x003C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.GetSaveSlotList
// [0x00020002] 
struct UMcpUserInventoryManager_execGetSaveSlotList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// TArray< struct FString >                        OutSaveSlots;                                     		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             SaveSlotIndex;                                    		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnQuerySaveSlotListRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnQuerySaveSlotListRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.QuerySaveSlotList
// [0x00020002] 
struct UMcpUserInventoryManager_execQuerySaveSlotList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x002C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnDeleteSaveSlotRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnDeleteSaveSlotRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.DeleteSaveSlot
// [0x00020002] 
struct UMcpUserInventoryManager_execDeleteSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x003C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManager.OnCreateSaveSlotRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManager_execOnCreateSaveSlotRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             SaveSlotIndex;                                    		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManager.CreateSaveSlot
// [0x00024002] 
struct UMcpUserInventoryManager_execCreateSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ParentSaveSlotId;                                 		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
	// int                                             ExistingIndex;                                    		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.GetIapList
// [0x00420002] 
struct UMcpUserInventoryManagerV3_execGetIapList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpIapList                                 Iaps;                                             		// 0x0010 (0x0020) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             ListIndex;                                        		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.ParseIapList
// [0x00080002] 
struct UMcpUserInventoryManagerV3_execParseIapList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UJsonObject*                                 ParsedJson;                                       		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// int                                             ListIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             IapIndex;                                         		// 0x001C (0x0004) [0x0000000000000000]              
	// class UJsonObject*                              Element;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.OnQueryIapListRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execOnQueryIapListRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x003C (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.QueryIapList
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execQueryIapList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.GetSaveSlot
// [0x00420002] 
struct UMcpUserInventoryManagerV3_execGetSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpInventorySaveSlot                       SaveSlot;                                         		// 0x0020 (0x0030) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0050 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FoundAt;                                          		// 0x0054 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.ParseSaveSlot
// [0x00080002] 
struct UMcpUserInventoryManagerV3_execParseSaveSlot_Parms
{
	class UJsonObject*                                 ParsedJson;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// int                                             FoundAt;                                          		// 0x0008 (0x0004) [0x0000000000000000]              
	// int                                             SlotIndex;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	// int                                             ItemIndex;                                        		// 0x0010 (0x0004) [0x0000000000000000]              
	// struct FString                                  McpId;                                            		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  SaveSlotId;                                       		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ItemsArray;                                       		// 0x0034 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.OnReadSaveSlotRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execOnReadSaveSlotRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x003C (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.ReadSaveSlot
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execReadSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.GetSaveSlotList
// [0x00020000] 
struct UMcpUserInventoryManagerV3_execGetSaveSlotList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.OnQuerySaveSlotsRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execOnQuerySaveSlotsRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.QuerySaveSlotList
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execQuerySaveSlotList_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.OnRecordIapRequestComplete
// [0x00820002] 
struct UMcpUserInventoryManagerV3_execOnRecordIapRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< struct FMcpIapItem >                    UpdatedItems;                                     		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FMcpIapItem                              Item;                                             		// 0x004C (0x0024) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0070 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x0078 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0080 (0x0004) [0x0000000000000000]              
	// struct FString                                  ActionString;                                     		// 0x0084 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  SaveSlot;                                         		// 0x0094 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UAnalyticEventsBase*                      Analytics;                                        		// 0x00A4 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserInventoryManagerV3.RecordIap
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execRecordIap_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Vendor;                                           		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Receipt;                                          		// 0x0030 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
	// struct FString                                  JSON;                                             		// 0x005C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< struct FMcpIapItem >                    UpdatedItems;                                     		// 0x006C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.OnDeleteSaveSlotRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execOnDeleteSaveSlotRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.DeleteSaveSlot
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execDeleteSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FString                                  JSON;                                             		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.OnCreateSaveSlotRequestComplete
// [0x00020002] 
struct UMcpUserInventoryManagerV3_execOnCreateSaveSlotRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ErrorString;                                      		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ResponseString;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.CreateSaveSlot
// [0x00024002] 
struct UMcpUserInventoryManagerV3_execCreateSaveSlot_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ParentSaveSlotId;                                 		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
	// struct FString                                  JSON;                                             		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.BuildIapResourcePath
// [0x00024002] 
struct UMcpUserInventoryManagerV3_execBuildIapResourcePath_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ProfileId;                                        		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserInventoryManagerV3.BuildProfileResourcePath
// [0x00024002] 
struct UMcpUserInventoryManagerV3_execBuildProfileResourcePath_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ProfileId;                                        		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0020 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  Path;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.OnDeleteUserRequestComplete
// [0x00020002] 
struct UMcpUserManager_execOnDeleteUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.DeleteUser
// [0x00020002] 
struct UMcpUserManager_execDeleteUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.GetUser
// [0x00420002] 
struct UMcpUserManager_execGetUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpUserStatus                              User;                                             		// 0x0010 (0x0078) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0088 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             UserIndex;                                        		// 0x008C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.GetUsers
// [0x00420002] 
struct UMcpUserManager_execGetUsers_Parms
{
	TArray< struct FMcpUserStatus >                    Users;                                            		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.OnQueryUsersRequestComplete
// [0x00020002] 
struct UMcpUserManager_execOnQueryUsersRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.ParseUsers
// [0x00080002] 
struct UMcpUserManager_execParseUsers_Parms
{
	struct FString                                     JsonPayload;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0010 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x0018 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FString                                  McpId;                                            		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.QueryUsers
// [0x00420002] 
struct UMcpUserManager_execQueryUsers_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           McpIds;                                           		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// struct FString                                  JsonPayload;                                      		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x004C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.OnQueryUserRequestComplete
// [0x00020002] 
struct UMcpUserManager_execOnQueryUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.QueryUser
// [0x00024002] 
struct UMcpUserManager_execQueryUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldUpdateLastActive : 1;                      		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0024 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x002C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.OnAuthenticateUserRequestComplete
// [0x00020002] 
struct UMcpUserManager_execOnAuthenticateUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Ticket;                                           		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.AuthenticateUserMcp
// [0x00020002] 
struct UMcpUserManager_execAuthenticateUserMcp_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ClientSecret;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UDID;                                             		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.AuthenticateUserFacebook
// [0x00020002] 
struct UMcpUserManager_execAuthenticateUserFacebook_Parms
{
	struct FString                                     FacebookId;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FacebookToken;                                    		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UDID;                                             		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.OnRegisterUserRequestComplete
// [0x00020002] 
struct UMcpUserManager_execOnRegisterUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.ParseUser
// [0x00080002] 
struct UMcpUserManager_execParseUser_Parms
{
	struct FString                                     JsonPayload;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0014 (0x0008) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  McpId;                                            		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManager.RegisterUserFacebook
// [0x00020002] 
struct UMcpUserManager_execRegisterUserFacebook_Parms
{
	struct FString                                     FacebookId;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FacebookAuthToken;                                		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManager.RegisterUserGenerated
// [0x00020002] 
struct UMcpUserManager_execRegisterUserGenerated_Parms
{
	// struct FString                                  URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.InjectUserCredentials
// [0x00020002] 
struct UMcpUserManagerV3_execInjectUserCredentials_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ClientSecret;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.GetAuthToken
// [0x00020002] 
struct UMcpUserManagerV3_execGetAuthToken_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.OnDeleteUserRequestComplete
// [0x00020002] 
struct UMcpUserManagerV3_execOnDeleteUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x001C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.DeleteUser
// [0x00020002] 
struct UMcpUserManagerV3_execDeleteUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0028 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.GetUserExternalAccountId
// [0x00420002] 
struct UMcpUserManagerV3_execGetUserExternalAccountId_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalAccountType;                              		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalAccountId;                                		// 0x0020 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0030 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             AccountIndex;                                     		// 0x0034 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.UserHasExternalAccount
// [0x00020002] 
struct UMcpUserManagerV3_execUserHasExternalAccount_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalAccountType;                              		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             UserIndex;                                        		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.GetUser
// [0x00420002] 
struct UMcpUserManagerV3_execGetUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FMcpUserStatus                              User;                                             		// 0x0010 (0x0078) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0088 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             UserIndex;                                        		// 0x008C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.GetUsers
// [0x00420002] 
struct UMcpUserManagerV3_execGetUsers_Parms
{
	TArray< struct FMcpUserStatus >                    Users;                                            		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.OnQueryUsersRequestComplete
// [0x00020002] 
struct UMcpUserManagerV3_execOnQueryUsersRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.ParseUsers
// [0x00080002] 
struct UMcpUserManagerV3_execParseUsers_Parms
{
	struct FString                                     JsonPayload;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0010 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              JsonElement;                                      		// 0x0018 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.QueryUsers
// [0x00420002] 
struct UMcpUserManagerV3_execQueryUsers_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FString >                           McpIds;                                           		// 0x0010 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.OnQueryUserRequestComplete
// [0x00020002] 
struct UMcpUserManagerV3_execOnQueryUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.QueryUser
// [0x00024002] 
struct UMcpUserManagerV3_execQueryUser_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bShouldUpdateLastActive : 1;                      		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	// struct FString                                  URL;                                              		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0034 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x003C (0x0004) [0x0000000000000000]              
	// TArray< struct FString >                        Ids;                                              		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.BuildJsonForIds
// [0x00480002] 
struct UMcpUserManagerV3_execBuildJsonForIds_Parms
{
	TArray< struct FString >                           McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// struct FString                                  JsonPayload;                                      		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0030 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.OnAuthenticateUserRequestComplete
// [0x00020002] 
struct UMcpUserManagerV3_execOnAuthenticateUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  Ticket;                                           		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0050 (0x0008) [0x0000000000000000]              
	// struct FString                                  Error;                                            		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.AuthenticateUserMcp
// [0x00020002] 
struct UMcpUserManagerV3_execAuthenticateUserMcp_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ClientSecret;                                     		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UDID;                                             		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.AuthenticateUserGameCenter
// [0x00020002] 
struct UMcpUserManagerV3_execAuthenticateUserGameCenter_Parms
{
	struct FString                                     GameCenterId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.AuthenticateUserGoogle
// [0x00020002] 
struct UMcpUserManagerV3_execAuthenticateUserGoogle_Parms
{
	struct FString                                     GoogleId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GoogleAuthToken;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0040 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.AuthenticateUserFacebook
// [0x00020002] 
struct UMcpUserManagerV3_execAuthenticateUserFacebook_Parms
{
	struct FString                                     FacebookId;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FacebookToken;                                    		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     UDID;                                             		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.OnRegisterUserRequestComplete
// [0x00020002] 
struct UMcpUserManagerV3_execOnRegisterUserRequestComplete_Parms
{
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	// int                                             ResponseCode;                                     		// 0x0018 (0x0004) [0x0000000000000000]              
	// int                                             UserIndex;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	// struct FString                                  ResponseString;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  ErrorString;                                      		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  McpId;                                            		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ParsedJson;                                       		// 0x0050 (0x0008) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.ParseUser
// [0x00080002] 
struct UMcpUserManagerV3_execParseUser_Parms
{
	class UJsonObject*                                 ParsedJson;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                ReturnValue;                                      		// 0x0008 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             UserIndex;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	// struct FString                                  McpId;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UJsonObject*                              ExternalAccounts;                                 		// 0x0020 (0x0008) [0x0000000000000000]              
	// class UJsonObject*                              ExternalAccount;                                  		// 0x0028 (0x0008) [0x0000000000000000]              
	// int                                             JsonIndex;                                        		// 0x0030 (0x0004) [0x0000000000000000]              
	// int                                             AccountIndex;                                     		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.RegisterUserGoogle
// [0x00020002] 
struct UMcpUserManagerV3_execRegisterUserGoogle_Parms
{
	struct FString                                     GoogleId;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     GoogleAuthToken;                                  		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.RegisterUserGameCenter
// [0x00020002] 
struct UMcpUserManagerV3_execRegisterUserGameCenter_Parms
{
	struct FString                                     GameCenterId;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.RegisterUserFacebook
// [0x00020002] 
struct UMcpUserManagerV3_execRegisterUserFacebook_Parms
{
	struct FString                                     FacebookId;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     FacebookAuthToken;                                		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.RegisterExternalUserAccount
// [0x00040003] ( FUNC_Final )
struct UMcpUserManagerV3_execRegisterExternalUserAccount_Parms
{
	struct FString                                     ExternalId;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Type;                                             		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  JSON;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0050 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0058 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.McpUserManagerV3.BuildExternalOnlineAccountJSON
// [0x00020002] 
struct UMcpUserManagerV3_execBuildExternalOnlineAccountJSON_Parms
{
	struct FString                                     Id;                                               		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Type;                                             		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0030 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function IpDrv.McpUserManagerV3.RegisterUserGenerated
// [0x00020002] 
struct UMcpUserManagerV3_execRegisterUserGenerated_Parms
{
	// struct FString                                  URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// class UHttpRequestInterface*                    Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
	// int                                             AddAt;                                            		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineImageDownloaderWeb.DebugDraw
// [0x00020002] 
struct UOnlineImageDownloaderWeb_execDebugDraw_Parms
{
	class UCanvas*                                     Canvas;                                           		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	// float                                           PosX;                                             		// 0x0008 (0x0004) [0x0000000000000000]              
	// float                                           PosY;                                             		// 0x000C (0x0004) [0x0000000000000000]              
	// int                                             Idx;                                              		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineImageDownloaderWeb.OnDownloadComplete
// [0x00040003] ( FUNC_Final )
struct UOnlineImageDownloaderWeb_execOnDownloadComplete_Parms
{
	class UHttpRequestInterface*                       OriginalRequest;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UHttpResponseInterface*                      Response;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bDidSucceed : 1;                                  		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// int                                             FoundIdx;                                         		// 0x0014 (0x0004) [0x0000000000000000]              
	// TArray< unsigned char >                         JPEGData;                                         		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.OnlineImageDownloaderWeb.DownloadNextImage
// [0x00040003] ( FUNC_Final )
struct UOnlineImageDownloaderWeb_execDownloadNextImage_Parms
{
	// int                                             Idx;                                              		// 0x0000 (0x0004) [0x0000000000000000]              
	// int                                             PendingDownloads;                                 		// 0x0004 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineImageDownloaderWeb.ClearAllDownloads
// [0x00020002] 
struct UOnlineImageDownloaderWeb_execClearAllDownloads_Parms
{
};

// Function IpDrv.OnlineImageDownloaderWeb.ClearDownloads
// [0x00020002] 
struct UOnlineImageDownloaderWeb_execClearDownloads_Parms
{
	TArray< struct FString >                           URLs;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Idx;                                              		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineImageDownloaderWeb.GetNumPendingDownloads
// [0x00020002] 
struct UOnlineImageDownloaderWeb_execGetNumPendingDownloads_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Idx;                                              		// 0x0004 (0x0004) [0x0000000000000000]              
	// int                                             Count;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineImageDownloaderWeb.RequestOnlineImages
// [0x00020002] 
struct UOnlineImageDownloaderWeb_execRequestOnlineImages_Parms
{
	TArray< struct FString >                           URLs;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FString                                  URL;                                              		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             FoundIdx;                                         		// 0x0020 (0x0004) [0x0000000000000000]              
	// int                                             Idx;                                              		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineImageDownloaderWeb.GetOnlineImageTexture
// [0x00020002] 
struct UOnlineImageDownloaderWeb_execGetOnlineImageTexture_Parms
{
	struct FString                                     URL;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UTexture*                                    ReturnValue;                                      		// 0x0010 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             FoundIdx;                                         		// 0x0018 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.OnlineImageDownloaderWeb.OnOnlineImageDownloaded
// [0x00120000] 
struct UOnlineImageDownloaderWeb_execOnOnlineImageDownloaded_Parms
{
	struct FOnlineImageDownload                        CachedEntry;                                      		// 0x0000 (0x0028) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.Done
// [0x00120000] 
struct UTestClashMobManager_execDone_Parms
{
};

// Function IpDrv.TestClashMobManager.OnDeleteUserComplete
// [0x00020002] 
struct UTestClashMobManager_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.DeleteUser
// [0x00020002] 
struct UTestClashMobManager_execDeleteUser_Parms
{
};

// Function IpDrv.TestClashMobManager.OnQueryChallengeUserStatusComplete
// [0x00020002] 
struct UTestClashMobManager_execOnQueryChallengeUserStatusComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ChallengeId;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< struct FMcpClashMobChallengeUserStatus > Status;                                           		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             StatusIndex;                                      		// 0x0044 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestClashMobManager.QueryUserStatus
// [0x00020002] 
struct UTestClashMobManager_execQueryUserStatus_Parms
{
};

// Function IpDrv.TestClashMobManager.OnUpdateChallengeUserRewardComplete
// [0x00020002] 
struct UTestClashMobManager_execOnUpdateChallengeUserRewardComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ChallengeId;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.UpdateReward
// [0x00020002] 
struct UTestClashMobManager_execUpdateReward_Parms
{
};

// Function IpDrv.TestClashMobManager.OnUpdateChallengeUserProgressComplete
// [0x00020002] 
struct UTestClashMobManager_execOnUpdateChallengeUserProgressComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ChallengeId;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.UpdateProgress
// [0x00020002] 
struct UTestClashMobManager_execUpdateProgress_Parms
{
};

// Function IpDrv.TestClashMobManager.OnAcceptChallengeComplete
// [0x00020002] 
struct UTestClashMobManager_execOnAcceptChallengeComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ChallengeId;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.AcceptClashMob
// [0x00020002] 
struct UTestClashMobManager_execAcceptClashMob_Parms
{
};

// Function IpDrv.TestClashMobManager.OnDownloadChallengeFileComplete
// [0x00020002] 
struct UTestClashMobManager_execOnDownloadChallengeFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ChallengeId;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ErrorString;                                      		// 0x0034 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.DownloadChallengeFiles
// [0x00020002] 
struct UTestClashMobManager_execDownloadChallengeFiles_Parms
{
	// int                                             FileIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestClashMobManager.OnQueryChallengeListComplete
// [0x00020002] 
struct UTestClashMobManager_execOnQueryChallengeListComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.QueryClashMobs
// [0x00020002] 
struct UTestClashMobManager_execQueryClashMobs_Parms
{
};

// Function IpDrv.TestClashMobManager.OnRegisterUserComplete
// [0x00020002] 
struct UTestClashMobManager_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestClashMobManager.CreateUserForTest
// [0x00020002] 
struct UTestClashMobManager_execCreateUserForTest_Parms
{
};

// Function IpDrv.TestClashMobManager.RunNextTest
// [0x00020002] 
struct UTestClashMobManager_execRunNextTest_Parms
{
};

// Function IpDrv.TestClashMobManager.Init
// [0x00024002] 
struct UTestClashMobManager_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpClashMobBase*                            ClashMobMan;                                      		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     InParentId;                                       		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     InChildId;                                        		// 0x0020 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.Done
// [0x00120000] 
struct UTestMcpGroups_execDone_Parms
{
};

// Function IpDrv.TestMcpGroups.OnDeleteUserComplete
// [0x00020002] 
struct UTestMcpGroups_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.DeleteUsers
// [0x00020002] 
struct UTestMcpGroups_execDeleteUsers_Parms
{
};

// Function IpDrv.TestMcpGroups.OnDeleteGroupComplete
// [0x00020002] 
struct UTestMcpGroups_execOnDeleteGroupComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.DeleteGroup
// [0x00020002] 
struct UTestMcpGroups_execDeleteGroup_Parms
{
};

// Function IpDrv.TestMcpGroups.OnQueryGroupsComplete
// [0x00820002] 
struct UTestMcpGroups_execOnQueryGroupsComplete_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	// struct FMcpGroupList                            GroupList;                                        		// 0x0028 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// unsigned long                                   bFoundTestUser2 : 1;                              		// 0x0048 (0x0004) [0x0000000000000000] [0x00000001] 
	// unsigned long                                   bFoundTestUser3 : 1;                              		// 0x004C (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.TestMcpGroups.QueryGroups
// [0x00020002] 
struct UTestMcpGroups_execQueryGroups_Parms
{
};

// Function IpDrv.TestMcpGroups.OnRemoveGroupMembersComplete
// [0x00020002] 
struct UTestMcpGroups_execOnRemoveGroupMembersComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.RemoveMembers
// [0x00020002] 
struct UTestMcpGroups_execRemoveMembers_Parms
{
	// TArray< struct FString >                        McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.OnQueryGroupMembersComplete
// [0x00020002] 
struct UTestMcpGroups_execOnQueryGroupMembersComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	// unsigned long                                   bFoundTestUser2 : 1;                              		// 0x0028 (0x0004) [0x0000000000000000] [0x00000001] 
	// unsigned long                                   bFoundTestUser3 : 1;                              		// 0x002C (0x0004) [0x0000000000000000] [0x00000001] 
};

// Function IpDrv.TestMcpGroups.QueryGroupMembers
// [0x00020002] 
struct UTestMcpGroups_execQueryGroupMembers_Parms
{
};

// Function IpDrv.TestMcpGroups.OnAddGroupMembersComplete
// [0x00020002] 
struct UTestMcpGroups_execOnAddGroupMembersComplete_Parms
{
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.AddMembers
// [0x00020002] 
struct UTestMcpGroups_execAddMembers_Parms
{
	// TArray< struct FString >                        MemberIds;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.OnCreateGroupComplete
// [0x00020002] 
struct UTestMcpGroups_execOnCreateGroupComplete_Parms
{
	struct FMcpGroup                                   Group;                                            		// 0x0000 (0x0044) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0044 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0048 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.CreateGroup
// [0x00020002] 
struct UTestMcpGroups_execCreateGroup_Parms
{
};

// Function IpDrv.TestMcpGroups.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpGroups_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpGroups.RegisterUsers
// [0x00020002] 
struct UTestMcpGroups_execRegisterUsers_Parms
{
};

// Function IpDrv.TestMcpGroups.RunNextTest
// [0x00020002] 
struct UTestMcpGroups_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpGroups.Init
// [0x00020002] 
struct UTestMcpGroups_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpGroupsBase*                              GroupMan;                                         		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpIdMapping.Done
// [0x00120000] 
struct UTestMcpIdMapping_execDone_Parms
{
};

// Function IpDrv.TestMcpIdMapping.OnDeleteUserComplete
// [0x00020002] 
struct UTestMcpIdMapping_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpIdMapping.DeleteUsers
// [0x00020002] 
struct UTestMcpIdMapping_execDeleteUsers_Parms
{
};

// Function IpDrv.TestMcpIdMapping.OnQueryMappingsComplete
// [0x00020002] 
struct UTestMcpIdMapping_execOnQueryMappingsComplete_Parms
{
	struct FString                                     ExternalType;                                     		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< struct FMcpIdMapping >                  Mappings;                                         		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0034 (0x0004) [0x0000000000000000]              
	// int                                             FoundAt;                                          		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpIdMapping.QueryAccountMappings
// [0x00020002] 
struct UTestMcpIdMapping_execQueryAccountMappings_Parms
{
	// TArray< struct FString >                        ExternalIds;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpIdMapping.OnAddMappingComplete
// [0x00020002] 
struct UTestMcpIdMapping_execOnAddMappingComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0034 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             ValidatedCount;                                   		// 0x0044 (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x0048 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpIdMapping.CreateAccountMappings
// [0x00020002] 
struct UTestMcpIdMapping_execCreateAccountMappings_Parms
{
};

// Function IpDrv.TestMcpIdMapping.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpIdMapping_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpIdMapping.RegisterUsers
// [0x00020002] 
struct UTestMcpIdMapping_execRegisterUsers_Parms
{
};

// Function IpDrv.TestMcpIdMapping.RunNextTest
// [0x00020002] 
struct UTestMcpIdMapping_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpIdMapping.Init
// [0x00020002] 
struct UTestMcpIdMapping_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpIdMappingBase*                           IdMappingMan;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpLeaderboards.OnReadLeaderboardByColumnComplete
// [0x00020002] 
struct UTestMcpLeaderboards_execOnReadLeaderboardByColumnComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0024 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	// TArray< struct FMcpLeaderboardEntry >           Entries;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             ValueIndex;                                       		// 0x003C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpLeaderboards.ReadLeaderboardByColumn
// [0x00020002] 
struct UTestMcpLeaderboards_execReadLeaderboardByColumn_Parms
{
};

// Function IpDrv.TestMcpLeaderboards.OnReadLeaderboardEntriesComplete
// [0x00020002] 
struct UTestMcpLeaderboards_execOnReadLeaderboardEntriesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0024 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	// TArray< struct FMcpLeaderboardEntry >           Entries;                                          		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
	// int                                             ValueIndex;                                       		// 0x003C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpLeaderboards.ReadLeaderboardEntry
// [0x00020002] 
struct UTestMcpLeaderboards_execReadLeaderboardEntry_Parms
{
	// TArray< struct FString >                        Users;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpLeaderboards.OnWriteLeaderboardEntryComplete
// [0x00020002] 
struct UTestMcpLeaderboards_execOnWriteLeaderboardEntryComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpLeaderboards.WriteLeaderboardEntry
// [0x00020002] 
struct UTestMcpLeaderboards_execWriteLeaderboardEntry_Parms
{
	// TArray< struct FMcpLeaderboardColumnEntry >     Columns;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpLeaderboards.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpLeaderboards_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpLeaderboards.CreateUser
// [0x00020002] 
struct UTestMcpLeaderboards_execCreateUser_Parms
{
};

// Function IpDrv.TestMcpLeaderboards.OnReadLeaderboardsComplete
// [0x00020002] 
struct UTestMcpLeaderboards_execOnReadLeaderboardsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< struct FMcpLeaderboard >                Leaderboards;                                     		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	// int                                             ColumnIndex;                                      		// 0x0028 (0x0004) [0x0000000000000000]              
	// int                                             TimeframeIndex;                                   		// 0x002C (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpLeaderboards.ReadLeaderboards
// [0x00020002] 
struct UTestMcpLeaderboards_execReadLeaderboards_Parms
{
};

// Function IpDrv.TestMcpLeaderboards.RunNextTest
// [0x00020002] 
struct UTestMcpLeaderboards_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpLeaderboards.Init
// [0x00020002] 
struct UTestMcpLeaderboards_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpLeaderboardsBase*                        LeaderboardMan;                                   		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpLeaderboards.Done
// [0x00120000] 
struct UTestMcpLeaderboards_execDone_Parms
{
};

// Function IpDrv.TestMcpManager.OnLeaderboardTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnLeaderboardTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunLeaderboardTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunLeaderboardTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnChatTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnChatTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunChatTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunChatTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnClashMobTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnClashMobTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunClashMobTests
// [0x00024202] ( FUNC_Exec )
struct UTestMcpManager_execRunClashMobTests_Parms
{
	struct FString                                     ParentId;                                         		// 0x0000 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ChildId;                                          		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpManager.OnUserFileTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnUserFileTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunUserCloudFileTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunUserCloudFileTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnSystemFileTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnSystemFileTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunSystemCloudFileTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunSystemCloudFileTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnInventoryTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnInventoryTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunInventoryTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunInventoryTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnQueryServerTimeComplete
// [0x00020002] 
struct UTestMcpManager_execOnQueryServerTimeComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     DateTimeStr;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpManager.RunServerTimeTest
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunServerTimeTest_Parms
{
};

// Function IpDrv.TestMcpManager.RunBase64Tests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunBase64Tests_Parms
{
};

// Function IpDrv.TestMcpManager.OnMessagingTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnMessagingTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunMessagingTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunMessagingTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnIdMappingTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnIdMappingTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunIdMappingTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunIdMappingTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnGroupTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnGroupTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunGroupTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunGroupTests_Parms
{
};

// Function IpDrv.TestMcpManager.OnUserTestsComplete
// [0x00020002] 
struct UTestMcpManager_execOnUserTestsComplete_Parms
{
};

// Function IpDrv.TestMcpManager.RunUserTests
// [0x00020202] ( FUNC_Exec )
struct UTestMcpManager_execRunUserTests_Parms
{
};

// Function IpDrv.TestMcpManager.GetLeaderboardManager
// [0x00020002] 
struct UTestMcpManager_execGetLeaderboardManager_Parms
{
	class UMcpLeaderboardsBase*                        ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetChatManager
// [0x00020002] 
struct UTestMcpManager_execGetChatManager_Parms
{
	class UMcpThreadedChatBase*                        ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetClashMobManager
// [0x00020002] 
struct UTestMcpManager_execGetClashMobManager_Parms
{
	class UMcpClashMobBase*                            ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetUserFileManager
// [0x00020002] 
struct UTestMcpManager_execGetUserFileManager_Parms
{
	class UUserCloudFileInterface*                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetTitleFileManager
// [0x00020002] 
struct UTestMcpManager_execGetTitleFileManager_Parms
{
	class UOnlineTitleFileInterface*                   ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetInventoryManager
// [0x00020002] 
struct UTestMcpManager_execGetInventoryManager_Parms
{
	class UMcpUserInventoryBase*                       ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetServerTimeManager
// [0x00020002] 
struct UTestMcpManager_execGetServerTimeManager_Parms
{
	class UMcpServerTimeBase*                          ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetMessagingManager
// [0x00020002] 
struct UTestMcpManager_execGetMessagingManager_Parms
{
	class UMcpMessageBase*                             ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetIdMappingManager
// [0x00020002] 
struct UTestMcpManager_execGetIdMappingManager_Parms
{
	class UMcpIdMappingBase*                           ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetGroupManager
// [0x00020002] 
struct UTestMcpManager_execGetGroupManager_Parms
{
	class UMcpGroupsBase*                              ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpManager.GetUserManager
// [0x00020002] 
struct UTestMcpManager_execGetUserManager_Parms
{
	class UMcpUserManagerBase*                         ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.TestMcpThreadedChat.Done
// [0x00120000] 
struct UTestMcpThreadedChat_execDone_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnDeleteUserDataComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnDeleteUserDataComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     McpId;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpThreadedChat.DeleteUserData
// [0x00020002] 
struct UTestMcpThreadedChat_execDeleteUserData_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnDeleteUserComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpThreadedChat.DeleteUsers
// [0x00020002] 
struct UTestMcpThreadedChat_execDeleteUsers_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnReadUserChatPostsByPopularityComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnReadUserChatPostsByPopularityComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.GetPostsForUserThreadByPopularity
// [0x00020002] 
struct UTestMcpThreadedChat_execGetPostsForUserThreadByPopularity_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnReadUserChatPostsComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnReadUserChatPostsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.GetPostsForUserThread
// [0x00020002] 
struct UTestMcpThreadedChat_execGetPostsForUserThread_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnReadSystemChatPostsByPopularityComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnReadSystemChatPostsByPopularityComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.GetPostsForSystemThreadByPopularity
// [0x00020002] 
struct UTestMcpThreadedChat_execGetPostsForSystemThreadByPopularity_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnReadSystemChatPostsComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnReadSystemChatPostsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.GetPostsForSystemThread
// [0x00020002] 
struct UTestMcpThreadedChat_execGetPostsForSystemThread_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnVoteDownPostComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnVoteDownPostComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     PostId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpThreadedChat.VoteDownPost
// [0x00020002] 
struct UTestMcpThreadedChat_execVoteDownPost_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnPostToUserThreadComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnPostToUserThreadComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.PostToUserThread
// [0x00020002] 
struct UTestMcpThreadedChat_execPostToUserThread_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnCreateUserChatThreadComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnCreateUserChatThreadComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     McpId;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ThreadName;                                       		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.CreateUserThread
// [0x00020002] 
struct UTestMcpThreadedChat_execCreateUserThread_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnReportPostComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnReportPostComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     PostId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpThreadedChat.ReportPost
// [0x00020002] 
struct UTestMcpThreadedChat_execReportPost_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnVoteUpPostComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnVoteUpPostComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     PostId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpThreadedChat.VoteUpPost
// [0x00020002] 
struct UTestMcpThreadedChat_execVoteUpPost_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnPostToThreadComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnPostToThreadComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     ThreadId;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0034 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.PostToSystemChatThread
// [0x00020002] 
struct UTestMcpThreadedChat_execPostToSystemChatThread_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnReadSystemChatThreadsComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnReadSystemChatThreadsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpThreadedChat.ReadSystemChatThreads
// [0x00020002] 
struct UTestMcpThreadedChat_execReadSystemChatThreads_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpThreadedChat_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpThreadedChat.CreateUsersForTest
// [0x00020002] 
struct UTestMcpThreadedChat_execCreateUsersForTest_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.RunNextTest
// [0x00020002] 
struct UTestMcpThreadedChat_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpThreadedChat.Init
// [0x00020002] 
struct UTestMcpThreadedChat_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpThreadedChatBase*                        ChatMan;                                          		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpUserFileManager.Done
// [0x00120000] 
struct UTestMcpUserFileManager_execDone_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.OnDeleteUserComplete
// [0x00020002] 
struct UTestMcpUserFileManager_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserFileManager.DeleteUser
// [0x00020002] 
struct UTestMcpUserFileManager_execDeleteUser_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.OnDeleteUserFileComplete
// [0x00020002] 
struct UTestMcpUserFileManager_execOnDeleteUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserFileManager.DeleteFileForUser
// [0x00020002] 
struct UTestMcpUserFileManager_execDeleteFileForUser_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.OnReadLastNOwnersComplete
// [0x00020002] 
struct UTestMcpUserFileManager_execOnReadLastNOwnersComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	// TArray< struct FString >                        McpIds;                                           		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpUserFileManager.ReadLastNOwners
// [0x00020002] 
struct UTestMcpUserFileManager_execReadLastNOwners_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.OnReadUserFileComplete
// [0x00020002] 
struct UTestMcpUserFileManager_execOnReadUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< unsigned char >                         Contents;                                         		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ErrorAt;                                          		// 0x0034 (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpUserFileManager.ReadFileForUser
// [0x00020002] 
struct UTestMcpUserFileManager_execReadFileForUser_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.OnEnumerateUserFilesComplete
// [0x00020002] 
struct UTestMcpUserFileManager_execOnEnumerateUserFilesComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserFileManager.EnumerateFilesForUser
// [0x00020002] 
struct UTestMcpUserFileManager_execEnumerateFilesForUser_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.OnWriteUserFileComplete
// [0x00020002] 
struct UTestMcpUserFileManager_execOnWriteUserFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     UserId;                                           		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserFileManager.WriteFileForUser
// [0x00020002] 
struct UTestMcpUserFileManager_execWriteFileForUser_Parms
{
	// TArray< unsigned char >                         Contents;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpUserFileManager.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpUserFileManager_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserFileManager.CreateUserForTest
// [0x00020002] 
struct UTestMcpUserFileManager_execCreateUserForTest_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.RunNextTest
// [0x00020002] 
struct UTestMcpUserFileManager_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpUserFileManager.Init
// [0x00020002] 
struct UTestMcpUserFileManager_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UUserCloudFileInterface*                     UserFileMan;                                      		// 0x0008 (0x0010) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpSystemFileManager.Done
// [0x00120000] 
struct UTestMcpSystemFileManager_execDone_Parms
{
};

// Function IpDrv.TestMcpSystemFileManager.OnReadTitleFileComplete
// [0x00020002] 
struct UTestMcpSystemFileManager_execOnReadTitleFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpSystemFileManager.ReadFiles
// [0x00020002] 
struct UTestMcpSystemFileManager_execReadFiles_Parms
{
	// int                                             FileIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpSystemFileManager.OnRequestTitleFileListComplete
// [0x00020002] 
struct UTestMcpSystemFileManager_execOnRequestTitleFileListComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpSystemFileManager.ReadTitleFileList
// [0x00020002] 
struct UTestMcpSystemFileManager_execReadTitleFileList_Parms
{
};

// Function IpDrv.TestMcpSystemFileManager.RunNextTest
// [0x00020002] 
struct UTestMcpSystemFileManager_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpSystemFileManager.Init
// [0x00020002] 
struct UTestMcpSystemFileManager_execInit_Parms
{
	class UOnlineTitleFileInterface*                   SystemFileMan;                                    		// 0x0000 (0x0010) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpUserInventory.Done
// [0x00120000] 
struct UTestMcpUserInventory_execDone_Parms
{
};

// Function IpDrv.TestMcpUserInventory.OnDeleteUserComplete
// [0x00020002] 
struct UTestMcpUserInventory_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserInventory.DeleteUser
// [0x00020002] 
struct UTestMcpUserInventory_execDeleteUser_Parms
{
};

// Function IpDrv.TestMcpUserInventory.OnDeleteSaveSlotComplete
// [0x00020002] 
struct UTestMcpUserInventory_execOnDeleteSaveSlotComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserInventory.DeleteSaveSlot
// [0x00020002] 
struct UTestMcpUserInventory_execDeleteSaveSlot_Parms
{
};

// Function IpDrv.TestMcpUserInventory.OnRecordIapComplete
// [0x00020002] 
struct UTestMcpUserInventory_execOnRecordIapComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FMcpIapItem >                       UpdatedItemIds;                                   		// 0x0020 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0030 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0034 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0044 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpUserInventory.RecordIap
// [0x00020002] 
struct UTestMcpUserInventory_execRecordIap_Parms
{
	// struct FString                                  IapReceipt;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserInventory.OnCreateSaveSlotComplete
// [0x00020002] 
struct UTestMcpUserInventory_execOnCreateSaveSlotComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserInventory.CreateSaveSlot
// [0x00020002] 
struct UTestMcpUserInventory_execCreateSaveSlot_Parms
{
};

// Function IpDrv.TestMcpUserInventory.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpUserInventory_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUserInventory.CreateUserForTest
// [0x00020002] 
struct UTestMcpUserInventory_execCreateUserForTest_Parms
{
};

// Function IpDrv.TestMcpUserInventory.RunNextTest
// [0x00020002] 
struct UTestMcpUserInventory_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpUserInventory.Init
// [0x00020002] 
struct UTestMcpUserInventory_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpUserInventoryBase*                       InventoryMan;                                     		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpMessaging.Done
// [0x00120000] 
struct UTestMcpMessaging_execDone_Parms
{
};

// Function IpDrv.TestMcpMessaging.OnDeleteUserComplete
// [0x00020002] 
struct UTestMcpMessaging_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpMessaging.DeleteUsers
// [0x00020002] 
struct UTestMcpMessaging_execDeleteUsers_Parms
{
};

// Function IpDrv.TestMcpMessaging.OnDeleteMessageComplete
// [0x00020002] 
struct UTestMcpMessaging_execOnDeleteMessageComplete_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpMessaging.DeleteMessage
// [0x00020002] 
struct UTestMcpMessaging_execDeleteMessage_Parms
{
};

// Function IpDrv.TestMcpMessaging.OnQueryMessageContentsComplete
// [0x00020002] 
struct UTestMcpMessaging_execOnQueryMessageContentsComplete_Parms
{
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// TArray< unsigned char >                         Contents;                                         		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             ErrorAt;                                          		// 0x0034 (0x0004) [0x0000000000000000]              
	// int                                             Index;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpMessaging.QueryMessageContents
// [0x00020002] 
struct UTestMcpMessaging_execQueryMessageContents_Parms
{
};

// Function IpDrv.TestMcpMessaging.OnQueryMessagesComplete
// [0x00820002] 
struct UTestMcpMessaging_execOnQueryMessagesComplete_Parms
{
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// struct FMcpMessageList                          MessageList;                                      		// 0x0024 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpMessaging.QueryMessages
// [0x00020002] 
struct UTestMcpMessaging_execQueryMessages_Parms
{
};

// Function IpDrv.TestMcpMessaging.OnCreateMessageComplete
// [0x00020002] 
struct UTestMcpMessaging_execOnCreateMessageComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpMessaging.SendMessage
// [0x00020002] 
struct UTestMcpMessaging_execSendMessage_Parms
{
	// TArray< struct FString >                        ToMcpIds;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// TArray< unsigned char >                         Contents;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// int                                             Index;                                            		// 0x0020 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.TestMcpMessaging.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpMessaging_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpMessaging.CreateUsersForTest
// [0x00020002] 
struct UTestMcpMessaging_execCreateUsersForTest_Parms
{
};

// Function IpDrv.TestMcpMessaging.RunNextTest
// [0x00020002] 
struct UTestMcpMessaging_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpMessaging.Init
// [0x00020002] 
struct UTestMcpMessaging_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UMcpMessageBase*                             MsgMan;                                           		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.TestMcpUser.Done
// [0x00120000] 
struct UTestMcpUser_execDone_Parms
{
};

// Function IpDrv.TestMcpUser.OnDeleteUserComplete
// [0x00020002] 
struct UTestMcpUser_execOnDeleteUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.DeleteUser
// [0x00020002] 
struct UTestMcpUser_execDeleteUser_Parms
{
};

// Function IpDrv.TestMcpUser.OnQueryUsersComplete
// [0x00020002] 
struct UTestMcpUser_execOnQueryUsersComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.QueryUsers
// [0x00020002] 
struct UTestMcpUser_execQueryUsers_Parms
{
	// TArray< struct FString >                        McpIds;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.OnQueryUserComplete
// [0x00020002] 
struct UTestMcpUser_execOnQueryUserComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.QueryUser
// [0x00020002] 
struct UTestMcpUser_execQueryUser_Parms
{
};

// Function IpDrv.TestMcpUser.OnAuthUserGameCenterComplete
// [0x00020002] 
struct UTestMcpUser_execOnAuthUserGameCenterComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.AuthUserGameCenter
// [0x00020002] 
struct UTestMcpUser_execAuthUserGameCenter_Parms
{
};

// Function IpDrv.TestMcpUser.OnRegisterUserGameCenterComplete
// [0x00020002] 
struct UTestMcpUser_execOnRegisterUserGameCenterComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.RegisterUserGameCenter
// [0x00020002] 
struct UTestMcpUser_execRegisterUserGameCenter_Parms
{
};

// Function IpDrv.TestMcpUser.OnAuthUserFacebookComplete
// [0x00020002] 
struct UTestMcpUser_execOnAuthUserFacebookComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.AuthUserFacebook
// [0x00020002] 
struct UTestMcpUser_execAuthUserFacebook_Parms
{
};

// Function IpDrv.TestMcpUser.OnRegisterUserFacebookComplete
// [0x00020002] 
struct UTestMcpUser_execOnRegisterUserFacebookComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.RegisterUserFacebook
// [0x00020002] 
struct UTestMcpUser_execRegisterUserFacebook_Parms
{
};

// Function IpDrv.TestMcpUser.OnAuthUserComplete
// [0x00020002] 
struct UTestMcpUser_execOnAuthUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Token;                                            		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0020 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0024 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.AuthUserGenerated
// [0x00020002] 
struct UTestMcpUser_execAuthUserGenerated_Parms
{
};

// Function IpDrv.TestMcpUser.OnRegisterUserComplete
// [0x00020002] 
struct UTestMcpUser_execOnRegisterUserComplete_Parms
{
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0010 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Error;                                            		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.TestMcpUser.RegisterUserGenerated
// [0x00020002] 
struct UTestMcpUser_execRegisterUserGenerated_Parms
{
};

// Function IpDrv.TestMcpUser.RunNextTest
// [0x00020002] 
struct UTestMcpUser_execRunNextTest_Parms
{
};

// Function IpDrv.TestMcpUser.Init
// [0x00020002] 
struct UTestMcpUser_execInit_Parms
{
	class UMcpUserManagerBase*                         UserMan;                                          		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function IpDrv.WebConnection.IsHanging
// [0x00020003] ( FUNC_Final )
struct AWebConnection_execIsHanging_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function IpDrv.WebConnection.Cleanup
// [0x00020002] 
struct AWebConnection_execCleanup_Parms
{
};

// Function IpDrv.WebConnection.CheckRawBytes
// [0x00020002] 
struct AWebConnection_execCheckRawBytes_Parms
{
};

// Function IpDrv.WebConnection.EndOfHeaders
// [0x00020002] 
struct AWebConnection_execEndOfHeaders_Parms
{
};

// Function IpDrv.WebConnection.CreateResponseObject
// [0x00020002] 
struct AWebConnection_execCreateResponseObject_Parms
{
	// int                                             I;                                                		// 0x0000 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.WebConnection.ProcessPost
// [0x00020002] 
struct AWebConnection_execProcessPost_Parms
{
	struct FString                                     S;                                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.WebConnection.ProcessGet
// [0x00020002] 
struct AWebConnection_execProcessGet_Parms
{
	struct FString                                     S;                                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function IpDrv.WebConnection.ProcessHead
// [0x00020002] 
struct AWebConnection_execProcessHead_Parms
{
	struct FString                                     S;                                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.WebConnection.ReceivedLine
// [0x00020002] 
struct AWebConnection_execReceivedLine_Parms
{
	struct FString                                     S;                                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function IpDrv.WebConnection.ReceivedText
// [0x00020802] ( FUNC_Event )
struct AWebConnection_eventReceivedText_Parms
{
	struct FString                                     Text;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             I;                                                		// 0x0010 (0x0004) [0x0000000000000000]              
	// struct FString                                  S;                                                		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function IpDrv.WebConnection.Timer
// [0x00020802] ( FUNC_Event )
struct AWebConnection_eventTimer_Parms
{
};

// Function IpDrv.WebConnection.Closed
// [0x00020802] ( FUNC_Event )
struct AWebConnection_eventClosed_Parms
{
};

// Function IpDrv.WebConnection.Accepted
// [0x00020802] ( FUNC_Event )
struct AWebConnection_eventAccepted_Parms
{
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif