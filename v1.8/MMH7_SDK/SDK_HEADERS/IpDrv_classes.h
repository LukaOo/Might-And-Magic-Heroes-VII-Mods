#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: IpDrv_classes.h
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

#define CONST_PLAYER_MATCH                                       0
#define CONST_RANKED_MATCH                                       1
#define CONST_REC_MATCH                                          2
#define CONST_PRIVATE_MATCH                                      3
#define CONST_RANKEDPROVIDERTAG                                  "PlaylistsRanked"
#define CONST_UNRANKEDPROVIDERTAG                                "PlaylistsUnranked"
#define CONST_RECMODEPROVIDERTAG                                 "PlaylistsRecMode"
#define CONST_PRIVATEPROVIDERTAG                                 "PlaylistsPrivate"

/*
# ========================================================================================= #
# Enums
# ========================================================================================= #
*/

// Enum IpDrv.InternetLink.ELinkMode
/*enum ELinkMode
{
	MODE_Text                                          = 0,
	MODE_Line                                          = 1,
	MODE_Binary                                        = 2,
	MODE_MAX                                           = 3
};*/

// Enum IpDrv.InternetLink.ELineMode
/*enum ELineMode
{
	LMODE_auto                                         = 0,
	LMODE_DOS                                          = 1,
	LMODE_UNIX                                         = 2,
	LMODE_MAC                                          = 3,
	LMODE_MAX                                          = 4
};*/

// Enum IpDrv.InternetLink.EReceiveMode
/*enum EReceiveMode
{
	RMODE_Manual                                       = 0,
	RMODE_Event                                        = 1,
	RMODE_MAX                                          = 2
};*/

// Enum IpDrv.McpClashMobBase.McpChildChallengeGatingType
/*enum McpChildChallengeGatingType
{
	MCCGT_NONE                                         = 0,
	MCCGT_SUCCESS                                      = 1,
	MCCGT_RAW_SCORE                                    = 2,
	MCCGT_TOP_N_PERCENT                                = 3,
	MCCGT_TOP_N_ENTRIES                                = 4,
	MCCGT_MAX                                          = 5
};*/

// Enum IpDrv.McpClashMobBase.McpChallengeRatingType
/*enum McpChallengeRatingType
{
	MCRT_NOT_RATED                                     = 0,
	MCRT_TOTAL_PROGRESS                                = 1,
	MCRT_HIGH_PROGRESS                                 = 2,
	MCRT_MAX                                           = 3
};*/

// Enum IpDrv.McpClashMobBase.McpChallengeFileStatus
/*enum McpChallengeFileStatus
{
	MCFS_NotStarted                                    = 0,
	MCFS_Pending                                       = 1,
	MCFS_Success                                       = 2,
	MCFS_Failed                                        = 3,
	MCFS_MAX                                           = 4
};*/

// Enum IpDrv.OnlineTitleFileDownloadBase.EMcpFileCompressionType
/*enum EMcpFileCompressionType
{
	MFCT_NONE                                          = 0,
	MFCT_ZLIB                                          = 1,
	MFCT_MAX                                           = 2
};*/

// Enum IpDrv.McpGroupsBase.EMcpGroupAccessLevel
/*enum EMcpGroupAccessLevel
{
	MGAL_Owner                                         = 0,
	MGAL_Member                                        = 1,
	MGAL_Public                                        = 2,
	MGAL_MAX                                           = 3
};*/

// Enum IpDrv.McpGroupsBase.EMcpGroupAcceptState
/*enum EMcpGroupAcceptState
{
	MGAS_Error                                         = 0,
	MGAS_Pending                                       = 1,
	MGAS_Accepted                                      = 2,
	MGAS_MAX                                           = 3
};*/

// Enum IpDrv.McpLeaderboardsBase.McpLeaderboardTimeframe
/*enum McpLeaderboardTimeframe
{
	MLT_ALL_TIME                                       = 0,
	MLT_DAILY                                          = 1,
	MLT_WEEKLY                                         = 2,
	MLT_MONTHLY                                        = 3,
	MLT_MAX                                            = 4
};*/

// Enum IpDrv.McpLeaderboardsBase.McpLeaderboardColumnType
/*enum McpLeaderboardColumnType
{
	MLCT_SUM                                           = 0,
	MLCT_MAX_VAL                                       = 1,
	MLCT_MIN_VAL                                       = 2,
	MLCT_LAST                                          = 3,
	MLCT_MAX                                           = 4
};*/

// Enum IpDrv.McpMessageBase.EMcpMessageCompressionType
/*enum EMcpMessageCompressionType
{
	MMCT_NONE                                          = 0,
	MMCT_LZO                                           = 1,
	MMCT_ZLIB                                          = 2,
	MMCT_MAX                                           = 3
};*/

// Enum IpDrv.MeshBeacon.EMeshBeaconPacketType
/*enum EMeshBeaconPacketType
{
	MB_Packet_UnknownType                              = 0,
	MB_Packet_ClientNewConnectionRequest               = 1,
	MB_Packet_ClientBeginBandwidthTest                 = 2,
	MB_Packet_ClientCreateNewSessionResponse           = 3,
	MB_Packet_HostNewConnectionResponse                = 4,
	MB_Packet_HostBandwidthTestRequest                 = 5,
	MB_Packet_HostCompletedBandwidthTest               = 6,
	MB_Packet_HostTravelRequest                        = 7,
	MB_Packet_HostCreateNewSessionRequest              = 8,
	MB_Packet_DummyData                                = 9,
	MB_Packet_Heartbeat                                = 10,
	MB_Packet_MAX                                      = 11
};*/

// Enum IpDrv.MeshBeacon.EMeshBeaconConnectionResult
/*enum EMeshBeaconConnectionResult
{
	MB_ConnectionResult_Succeeded                      = 0,
	MB_ConnectionResult_Duplicate                      = 1,
	MB_ConnectionResult_Timeout                        = 2,
	MB_ConnectionResult_Error                          = 3,
	MB_ConnectionResult_MAX                            = 4
};*/

// Enum IpDrv.MeshBeacon.EMeshBeaconBandwidthTestState
/*enum EMeshBeaconBandwidthTestState
{
	MB_BandwidthTestState_NotStarted                   = 0,
	MB_BandwidthTestState_RequestPending               = 1,
	MB_BandwidthTestState_StartPending                 = 2,
	MB_BandwidthTestState_InProgress                   = 3,
	MB_BandwidthTestState_Completed                    = 4,
	MB_BandwidthTestState_Incomplete                   = 5,
	MB_BandwidthTestState_Timeout                      = 6,
	MB_BandwidthTestState_Error                        = 7,
	MB_BandwidthTestState_MAX                          = 8
};*/

// Enum IpDrv.MeshBeacon.EMeshBeaconBandwidthTestResult
/*enum EMeshBeaconBandwidthTestResult
{
	MB_BandwidthTestResult_Succeeded                   = 0,
	MB_BandwidthTestResult_Timeout                     = 1,
	MB_BandwidthTestResult_Error                       = 2,
	MB_BandwidthTestResult_MAX                         = 3
};*/

// Enum IpDrv.MeshBeacon.EMeshBeaconBandwidthTestType
/*enum EMeshBeaconBandwidthTestType
{
	MB_BandwidthTestType_Upstream                      = 0,
	MB_BandwidthTestType_Downstream                    = 1,
	MB_BandwidthTestType_RoundtripLatency              = 2,
	MB_BandwidthTestType_MAX                           = 3
};*/

// Enum IpDrv.MeshBeaconClient.EMeshBeaconClientState
/*enum EMeshBeaconClientState
{
	MBCS_None                                          = 0,
	MBCS_Connecting                                    = 1,
	MBCS_Connected                                     = 2,
	MBCS_ConnectionFailed                              = 3,
	MBCS_AwaitingResponse                              = 4,
	MBCS_Closed                                        = 5,
	MBCS_MAX                                           = 6
};*/

// Enum IpDrv.OnlineEventsInterfaceMcp.EEventUploadType
/*enum EEventUploadType
{
	EUT_GenericStats                                   = 0,
	EUT_ProfileData                                    = 1,
	EUT_MatchmakingData                                = 2,
	EUT_PlaylistPopulation                             = 3,
	EUT_MAX                                            = 4
};*/

// Enum IpDrv.OnlineImageDownloaderWeb.EOnlineImageDownloadState
/*enum EOnlineImageDownloadState
{
	PIDS_NotStarted                                    = 0,
	PIDS_Downloading                                   = 1,
	PIDS_Succeeded                                     = 2,
	PIDS_Failed                                        = 3,
	PIDS_MAX                                           = 4
};*/

// Enum IpDrv.PartyBeacon.EReservationPacketType
/*enum EReservationPacketType
{
	RPT_UnknownPacketType                              = 0,
	RPT_ClientReservationRequest                       = 1,
	RPT_ClientReservationUpdateRequest                 = 2,
	RPT_ClientCancellationRequest                      = 3,
	RPT_HostReservationResponse                        = 4,
	RPT_HostReservationCountUpdate                     = 5,
	RPT_HostTravelRequest                              = 6,
	RPT_HostIsReady                                    = 7,
	RPT_HostHasCancelled                               = 8,
	RPT_Heartbeat                                      = 9,
	RPT_MAX                                            = 10
};*/

// Enum IpDrv.PartyBeacon.EPartyReservationResult
/*enum EPartyReservationResult
{
	PRR_GeneralError                                   = 0,
	PRR_PartyLimitReached                              = 1,
	PRR_IncorrectPlayerCount                           = 2,
	PRR_RequestTimedOut                                = 3,
	PRR_ReservationDuplicate                           = 4,
	PRR_ReservationNotFound                            = 5,
	PRR_ReservationAccepted                            = 6,
	PRR_ReservationDenied                              = 7,
	PRR_MAX                                            = 8
};*/

// Enum IpDrv.PartyBeaconClient.EPartyBeaconClientState
/*enum EPartyBeaconClientState
{
	PBCS_None                                          = 0,
	PBCS_Connecting                                    = 1,
	PBCS_Connected                                     = 2,
	PBCS_ConnectionFailed                              = 3,
	PBCS_AwaitingResponse                              = 4,
	PBCS_Closed                                        = 5,
	PBCS_MAX                                           = 6
};*/

// Enum IpDrv.PartyBeaconClient.EPartyBeaconClientRequest
/*enum EPartyBeaconClientRequest
{
	PBClientRequest_NewReservation                     = 0,
	PBClientRequest_UpdateReservation                  = 1,
	PBClientRequest_MAX                                = 2
};*/

// Enum IpDrv.PartyBeaconHost.EPartyBeaconHostState
/*enum EPartyBeaconHostState
{
	PBHS_AllowReservations                             = 0,
	PBHS_DenyReservations                              = 1,
	PBHS_MAX                                           = 2
};*/

// Enum IpDrv.TcpLink.ELinkState
/*enum ELinkState
{
	STATE_Initialized                                  = 0,
	STATE_Ready                                        = 1,
	STATE_Listening                                    = 2,
	STATE_Connecting                                   = 3,
	STATE_Connected                                    = 4,
	STATE_ListenClosePending                           = 5,
	STATE_ConnectClosePending                          = 6,
	STATE_ListenClosing                                = 7,
	STATE_ConnectClosing                               = 8,
	STATE_MAX                                          = 9
};*/

// Enum IpDrv.TitleFileDownloadCache.ETitleFileFileOp
/*enum ETitleFileFileOp
{
	TitleFile_None                                     = 0,
	TitleFile_Save                                     = 1,
	TitleFile_Load                                     = 2,
	TitleFile_MAX                                      = 3
};*/

// Enum IpDrv.WebRequest.ERequestType
/*enum ERequestType
{
	Request_GET                                        = 0,
	Request_POST                                       = 1,
	Request_MAX                                        = 2
};*/


/*
# ========================================================================================= #
# Classes
# ========================================================================================= #
*/

// Class IpDrv.Base64 ( Property size: 0 iter: 5) 
// Class name index: 7670 
// 0x0000 (0x0060 - 0x0060)
class UBase64 : public UObject
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2918 ];

		return pClassPointer;
	};

	void TestStringVersion ( );
	struct FString DecodeString ( struct FString Source );
	struct FString EncodeString ( struct FString Source );
	void Decode ( struct FString Source, TArray< unsigned char >* Dest );
	struct FString Encode ( TArray< unsigned char >* Source );
};



// Class IpDrv.ClientBeaconAddressResolver ( Property size: 2 iter: 2) 
// Class name index: 7672 
// 0x000C (0x006C - 0x0060)
class UClientBeaconAddressResolver : public UObject
{
public:
	int                                                BeaconPort;                                       		// 0x0060 (0x0004) [0x0000000000000000]              
	struct FName                                       BeaconName;                                       		// 0x0064 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2920 ];

		return pClassPointer;
	};

};



// Class IpDrv.HTTPDownload ( Property size: 4 iter: 6) 
// Class name index: 7674 
// 0x0128 (0x0BCC - 0x0AA4)
class UHTTPDownload : public UDownload
{
public:
	struct FString                                     ProxyServerHost;                                  		// 0x0AA4 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	int                                                ProxyServerPort;                                  		// 0x0AB4 (0x0004) [0x0000000000004000]              ( CPF_Config )
	unsigned long                                      MaxRedirection : 1;                               		// 0x0AB8 (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
	float                                              ConnectionTimeout;                                		// 0x0ABC (0x0004) [0x0000000000004000]              ( CPF_Config )
//	 LastOffset: ac0
//	 Class Propsize: bcc
	unsigned char                                      UnknownData00[ 0x10C ];                           		// 0x0AC0 (0x010C) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2922 ];

		return pClassPointer;
	};

};



// Class IpDrv.InternetLink ( Property size: 9 iter: 22) 
// Class name index: 7681 
// 0x0024 (0x0264 - 0x0240)
class AInternetLink : public AInfo
{
public:
	unsigned char                                      LinkMode;                                         		// 0x0240 (0x0001) [0x0000000000000000]              
	unsigned char                                      InLineMode;                                       		// 0x0241 (0x0001) [0x0000000000000000]              
	unsigned char                                      OutLineMode;                                      		// 0x0242 (0x0001) [0x0000000000000000]              
	unsigned char                                      ReceiveMode;                                      		// 0x0243 (0x0001) [0x0000000000000000]              
	struct FPointer                                    Socket;                                           		// 0x0244 (0x0008) [0x0000000000000002]              ( CPF_Const )
	int                                                Port;                                             		// 0x024C (0x0004) [0x0000000000000002]              ( CPF_Const )
	struct FPointer                                    RemoteSocket;                                     		// 0x0250 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FPointer                                    PrivateResolveInfo;                               		// 0x0258 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	int                                                DataPending;                                      		// 0x0260 (0x0004) [0x0000000000000002]              ( CPF_Const )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2930 ];

		return pClassPointer;
	};

	void eventResolveFailed ( );
	void eventResolved ( struct FIpAddr Addr );
	void GetLocalIP ( struct FIpAddr* Arg );
	bool StringToIpAddr ( struct FString Str, struct FIpAddr* Addr );
	struct FString IpAddrToString ( struct FIpAddr Arg );
	int GetLastError ( );
	void Resolve ( struct FString Domain );
	bool ParseURL ( struct FString URL, struct FString* Addr, int* PortNum, struct FString* LevelName, struct FString* EntryName );
	bool IsDataPending ( );
};



// Class IpDrv.TcpLink ( Property size: 5 iter: 21) 
// Class name index: 7683 
// 0x0034 (0x0298 - 0x0264)
class ATcpLink : public AInternetLink
{
public:
	unsigned char                                      LinkState;                                        		// 0x0264 (0x0001) [0x0000000000000000]              
	struct FIpAddr                                     RemoteAddr;                                       		// 0x0268 (0x0008) [0x0000000000000000]              
	class UClass*                                      AcceptClass;                                      		// 0x0270 (0x0008) [0x0000000000000000]              
	TArray< unsigned char >                            SendFIFO;                                         		// 0x0278 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FString                                     RecvBuf;                                          		// 0x0288 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2932 ];

		return pClassPointer;
	};

	void eventReceivedBinary ( int Count, unsigned char* B );
	void eventReceivedLine ( struct FString Line );
	void eventReceivedText ( struct FString Text );
	void eventClosed ( );
	void eventOpened ( );
	void eventAccepted ( );
	int ReadBinary ( int Count, unsigned char* B );
	int ReadText ( struct FString* Str );
	int SendBinary ( int Count, unsigned char* B );
	int SendText ( struct FString Str );
	bool IsConnected ( );
	bool Close ( );
	bool Open ( struct FIpAddr Addr );
	bool Listen ( );
	int BindPort ( int PortNum, unsigned long bUseNextAvailable );
};



// Class IpDrv.McpServiceBase ( Property size: 2 iter: 18) 
// Class name index: 7685 
// 0x0018 (0x0078 - 0x0060)
class UMcpServiceBase : public UObject
{
public:
	struct FString                                     McpConfigClassName;                               		// 0x0060 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	class UMcpServiceConfig*                           McpConfig;                                        		// 0x0070 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2934 ];

		return pClassPointer;
	};

	struct FString UnrealDateTimeToServerDateTime ( struct FString UnrealDateTime );
	struct FString ServerDateTimeToUnrealDateTime ( struct FString ServerDateTime );
	void UseGameServiceAuth ( class UHttpRequestInterface* Request );
	class UHttpRequestInterface* CreateHttpRequestGameAuth ( );
	void UseBasicAuth ( class UHttpRequestInterface* Request, struct FString UserName, struct FString Password );
	class UHttpRequestInterface* CreateHttpRequest ( struct FString McpId );
	int GetEngineVersionToReport ( );
	struct FString GetUserAgent ( );
	void AddUserAuthorization ( class UHttpRequestInterface* Request, struct FString McpId );
	struct FString GetUserAuthURL ( struct FString McpId );
	struct FString GetAppAccessURL ( );
	bool IsSuccessCode ( int StatusCode );
	struct FString GetBaseURL ( );
	class UMcpServiceBase* GetSingleton ( class UClass* SingletonClass );
	bool IsProduction ( );
	void eventInit ( );
};



// Class IpDrv.MCPBase ( Property size: 1 iter: 1) 
// Class name index: 7687 
// 0x0008 (0x0080 - 0x0078)
class UMCPBase : public UMcpServiceBase
{
public:
	struct FPointer                                    VfTable_FTickableObject;                          		// 0x0078 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2936 ];

		return pClassPointer;
	};

};



// Class IpDrv.OnlineEventsInterfaceMcp ( Property size: 4 iter: 10) 
// Class name index: 7689 
// 0x0034 (0x00B4 - 0x0080)
class UOnlineEventsInterfaceMcp : public UMCPBase
{
public:
	TArray< struct FEventUploadConfig >                EventUploadConfigs;                               		// 0x0080 (0x0010) [0x0000000000404002]              ( CPF_Const | CPF_Config | CPF_NeedCtorLink )
	TArray< struct FPointer >                          MCPEventPostObjects;                              		// 0x0090 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< unsigned char >                            DisabledUploadTypes;                              		// 0x00A0 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	unsigned long                                      bBinaryStats : 1;                                 		// 0x00B0 (0x0004) [0x0000000000004002] [0x00000001] ( CPF_Const | CPF_Config )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2938 ];

		return pClassPointer;
	};

	bool UploadMatchmakingStats ( struct FUniqueNetId UniqueId, class UOnlineMatchmakingStats* MMStats );
	bool UpdatePlaylistPopulation ( int PlaylistId, int NumPlayers );
	bool UploadGameplayEventsData ( struct FUniqueNetId UniqueId, TArray< unsigned char >* Payload );
	bool UploadPlayerData ( struct FUniqueNetId UniqueId, struct FString PlayerNick, class UOnlineProfileSettings* ProfileSettings, class UOnlinePlayerStorage* PlayerStorage );
};



// Class IpDrv.OnlineNewsInterfaceMcp ( Property size: 4 iter: 10) 
// Class name index: 7691 
// 0x0034 (0x00B4 - 0x0080)
class UOnlineNewsInterfaceMcp : public UMCPBase
{
public:
	TArray< struct FNewsCacheEntry >                   NewsItems;                                        		// 0x0080 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ReadNewsDelegates;                                		// 0x0090 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bNeedsTicking : 1;                                		// 0x00A0 (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )
	struct FScriptDelegate                             __OnReadNewsCompleted__Delegate;                  		// 0x00A4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00A8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2940 ];

		return pClassPointer;
	};

	struct FString GetNews ( unsigned char LocalUserNum, unsigned char NewsType );
	void ClearReadNewsCompletedDelegate ( struct FScriptDelegate ReadGameNewsDelegate );
	void AddReadNewsCompletedDelegate ( struct FScriptDelegate ReadNewsDelegate );
	void OnReadNewsCompleted ( unsigned long bWasSuccessful, unsigned char NewsType );
	bool ReadNews ( unsigned char LocalUserNum, unsigned char NewsType );
};



// Class IpDrv.OnlineTitleFileDownloadBase ( Property size: 9 iter: 26) 
// Class name index: 7693 
// 0x0084 (0x0104 - 0x0080)
class UOnlineTitleFileDownloadBase : public UMCPBase
{
public:
	TArray< struct FScriptDelegate >                   ReadTitleFileCompleteDelegates;                   		// 0x0080 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   RequestTitleFileListCompleteDelegates;            		// 0x0090 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     BaseUrl;                                          		// 0x00A0 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     RequestFileListURL;                               		// 0x00B0 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     RequestFileURL;                                   		// 0x00C0 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	float                                              TimeOut;                                          		// 0x00D0 (0x0004) [0x0000000000004000]              ( CPF_Config )
	TArray< struct FFileNameToURLMapping >             FilesToUrls;                                      		// 0x00D4 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnReadTitleFileComplete__Delegate;              		// 0x00E4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00E8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnRequestTitleFileListComplete__Delegate;       		// 0x00F4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x00F8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2942 ];

		return pClassPointer;
	};

	void GetTitleFileList ( TArray< struct FEmsFile >* FileList );
	struct FString GetUrlForFile ( struct FString Filename );
	void ClearRequestTitleFileListCompleteDelegate ( struct FScriptDelegate RequestTitleFileListDelegate );
	void AddRequestTitleFileListCompleteDelegate ( struct FScriptDelegate RequestTitleFileListDelegate );
	void OnRequestTitleFileListComplete ( unsigned long bWasSuccessful, struct FString ResultStr );
	void RequestTitleFileList ( );
	bool ClearDownloadedFile ( struct FString Filename );
	bool ClearDownloadedFiles ( );
	unsigned char GetTitleFileState ( struct FString Filename );
	bool GetTitleFileContents ( struct FString Filename, TArray< unsigned char >* FileContents );
	void ClearReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate );
	void AddReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate );
	bool ReadTitleFile ( struct FString FileToRead );
	void OnReadTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
};



// Class IpDrv.OnlineTitleFileDownloadMcp ( Property size: 2 iter: 8) 
// Class name index: 7695 
// 0x0014 (0x0118 - 0x0104)
class UOnlineTitleFileDownloadMcp : public UOnlineTitleFileDownloadBase
{
public:
	TArray< struct FTitleFileMcp >                     TitleFiles;                                       		// 0x0104 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                DownloadCount;                                    		// 0x0114 (0x0004) [0x0000000000002000]              ( CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2944 ];

		return pClassPointer;
	};

	bool ClearDownloadedFile ( struct FString Filename );
	bool ClearDownloadedFiles ( );
	unsigned char GetTitleFileState ( struct FString Filename );
	bool GetTitleFileContents ( struct FString Filename, TArray< unsigned char >* FileContents );
	bool ReadTitleFile ( struct FString FileToRead );
};



// Class IpDrv.OnlineTitleFileDownloadWeb ( Property size: 1 iter: 12) 
// Class name index: 7697 
// 0x0010 (0x0114 - 0x0104)
class UOnlineTitleFileDownloadWeb : public UOnlineTitleFileDownloadBase
{
public:
	TArray< struct FTitleFileWeb >                     TitleFiles;                                       		// 0x0104 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2946 ];

		return pClassPointer;
	};

	struct FString GetUrlForFile ( struct FString Filename );
	void OnFileListReceived ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bDidSucceed );
	void RequestTitleFileList ( );
	bool ClearDownloadedFile ( struct FString Filename );
	bool ClearDownloadedFiles ( );
	unsigned char GetTitleFileState ( struct FString Filename );
	bool GetTitleFileContents ( struct FString Filename, TArray< unsigned char >* FileContents );
	void TriggerDelegates ( unsigned long bSuccess, struct FString FileRead );
	void OnFileDownloadComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bDidSucceed );
	bool ReadTitleFile ( struct FString FileToRead );
	bool UncompressTitleFileContents ( unsigned char FileCompressionType, TArray< unsigned char >* CompressedFileContents, TArray< unsigned char >* UncompressedFileContents );
};



// Class IpDrv.TitleFileDownloadCache ( Property size: 5 iter: 23) 
// Class name index: 7699 
// 0x0050 (0x00D0 - 0x0080)
class UTitleFileDownloadCache : public UMCPBase
{
public:
	TArray< struct FTitleFileCacheEntry >              TitleFiles;                                       		// 0x0080 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   LoadCompleteDelegates;                            		// 0x0090 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   SaveCompleteDelegates;                            		// 0x00A0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnLoadTitleFileComplete__Delegate;              		// 0x00B0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00B4 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnSaveTitleFileComplete__Delegate;              		// 0x00C0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x00C4 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2948 ];

		return pClassPointer;
	};

	bool DeleteTitleFile ( struct FString Filename );
	bool DeleteTitleFiles ( float MaxAgeSeconds );
	bool ClearCachedFile ( struct FString Filename );
	bool ClearCachedFiles ( );
	struct FString GetTitleFileLogicalName ( struct FString Filename );
	struct FString GetTitleFileHash ( struct FString Filename );
	unsigned char GetTitleFileState ( struct FString Filename );
	bool GetTitleFileContents ( struct FString Filename, TArray< unsigned char >* FileContents );
	void ClearSaveTitleFileCompleteDelegate ( struct FScriptDelegate SaveCompleteDelegate );
	void AddSaveTitleFileCompleteDelegate ( struct FScriptDelegate SaveCompleteDelegate );
	void OnSaveTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
	bool SaveTitleFile ( struct FString Filename, struct FString LogicalName, TArray< unsigned char > FileContents );
	void ClearLoadTitleFileCompleteDelegate ( struct FScriptDelegate LoadCompleteDelegate );
	void AddLoadTitleFileCompleteDelegate ( struct FScriptDelegate LoadCompleteDelegate );
	void OnLoadTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
	bool LoadTitleFile ( struct FString Filename );
};



// Class IpDrv.McpMessageBase ( Property size: 8 iter: 23) 
// Class name index: 7701 
// 0x0074 (0x00EC - 0x0078)
class UMcpMessageBase : public UMcpServiceBase
{
public:
	struct FString                                     McpMessageManagerClassName;                       		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	unsigned char                                      CompressionType;                                  		// 0x0088 (0x0001) [0x0000000000004000]              ( CPF_Config )
	TArray< struct FMcpMessageContents >               MessageContentsList;                              		// 0x008C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpMessageList >                   MessageLists;                                     		// 0x009C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnCreateMessageComplete__Delegate;              		// 0x00AC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00B0 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteMessageComplete__Delegate;              		// 0x00BC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x00C0 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryMessagesComplete__Delegate;              		// 0x00CC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00D0 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryMessageContentsComplete__Delegate;       		// 0x00DC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x00E0 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2950 ];

		return pClassPointer;
	};

	bool GetMessageContents ( struct FString MessageId, TArray< unsigned char >* MessageContents );
	void OnQueryMessageContentsComplete ( struct FString MessageId, unsigned long bWasSuccessful, struct FString Error );
	void QueryMessageContents ( struct FString McpId, struct FString MessageId );
	void GetMessageList ( struct FString ToUniqueUserId, struct FMcpMessageList* MessageList );
	void OnQueryMessagesComplete ( struct FString UserId, unsigned long bWasSuccessful, struct FString Error );
	void QueryMessages ( struct FString ToUniqueUserId );
	void OnDeleteMessageComplete ( struct FString MessageId, unsigned long bWasSuccessful, struct FString Error );
	void DeleteMessage ( struct FString McpId, struct FString MessageId );
	void OnCreateMessageComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void CreateMessage ( struct FString FromUniqueUserId, struct FString FromFriendlyName, struct FString MessageType, struct FString PushMessage, struct FString ValidUntil, TArray< struct FString >* ToUniqueUserIds, TArray< unsigned char >* MessageContents );
	class UMcpMessageBase* CreateInstance ( );
};



// Class IpDrv.McpMessageManager ( Property size: 8 iter: 26) 
// Class name index: 7703 
// 0x0078 (0x0164 - 0x00EC)
class UMcpMessageManager : public UMcpMessageBase
{
public:
	struct FPointer                                    VfTable_FTickableObject;                          		// 0x00EC (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	struct FString                                     CreateMessageUrl;                                 		// 0x00F4 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteMessageUrl;                                 		// 0x0104 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryMessagesUrl;                                 		// 0x0114 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryMessageContentsUrl;                          		// 0x0124 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteAllMessagesUrl;                             		// 0x0134 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FMcpCompressMessageRequest >        CompressMessageRequests;                          		// 0x0144 (0x0010) [0x0000000000001000]              ( CPF_Native )
	TArray< struct FMcpUncompressMessageRequest >      UncompressMessageRequests;                        		// 0x0154 (0x0010) [0x0000000000001000]              ( CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2952 ];

		return pClassPointer;
	};

	bool CacheMessageContents ( struct FString MessageId, TArray< unsigned char >* MessageContents );
	bool GetMessageById ( struct FString MessageId, struct FMcpMessage* Message );
	void CacheMessage ( struct FMcpMessage Message );
	bool GetMessageContents ( struct FString MessageId, TArray< unsigned char >* MessageContents );
	void OnQueryMessageContentsRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void QueryMessageContents ( struct FString McpId, struct FString MessageId );
	void GetMessageList ( struct FString ToUniqueUserId, struct FMcpMessageList* MessageList );
	void OnQueryMessagesRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void QueryMessages ( struct FString ToUniqueUserId );
	void OnDeleteMessageRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void DeleteMessage ( struct FString McpId, struct FString MessageId );
	void OnCreateMessageRequestComplete ( class UHttpRequestInterface* CreateMessageRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void CreateMessage ( struct FString FromUniqueUserId, struct FString FromFriendlyName, struct FString MessageType, struct FString PushMessage, struct FString ValidUntil, TArray< struct FString >* ToUniqueUserIds, TArray< unsigned char >* MessageContents );
	void eventFinishedAsyncUncompression ( unsigned long bWasSuccessful, struct FString MessageId, TArray< unsigned char >* UncompressedMessageContents );
	bool StartAsyncUncompression ( struct FString MessageId, unsigned char MessageCompressionType, TArray< unsigned char >* MessageContent );
	bool StartAsyncCompression ( unsigned char MessageCompressionType, class UHttpRequestInterface* Request, TArray< unsigned char >* MessageContent );
};



// Class IpDrv.McpUserCloudFileDownload ( Property size: 14 iter: 51) 
// Class name index: 7705 
// 0x00E0 (0x0158 - 0x0078)
class UMcpUserCloudFileDownload : public UMcpServiceBase
{
public:
	struct FString                                     EnumerateCloudFilesUrl;                           		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ReadCloudFileUrl;                                 		// 0x0088 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     WriteCloudFileUrl;                                		// 0x0098 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteCloudFileUrl;                               		// 0x00A8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FMcpUserCloudFilesEntry >           UserCloudFileRequests;                            		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   EnumerateUserFilesCompleteDelegates;              		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ReadUserFileCompleteDelegates;                    		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   WriteUserFileCompleteDelegates;                   		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   DeleteUserFileCompleteDelegates;                  		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnEnumerateUserFilesComplete__Delegate;         		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x010C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadUserFileComplete__Delegate;               		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x011C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnWriteUserFileComplete__Delegate;              		// 0x0128 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x012C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteUserFileComplete__Delegate;             		// 0x0138 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x013C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadLastNCloudSaveOwnersComplete__Delegate;   		// 0x0148 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x014C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2954 ];

		return pClassPointer;
	};

	void GetLastNCloudSaveOwners ( TArray< struct FString >* McpIds );
	void ClearReadLastNCloudSaveOwnersCompleteDelegate ( struct FScriptDelegate CompleteDelegate );
	void AddReadLastNCloudSaveOwnersCompleteDelegate ( struct FScriptDelegate CompleteDelegate );
	void OnReadLastNCloudSaveOwnersComplete ( unsigned long bWasSuccessful );
	void ReadLastNCloudSaveOwners ( int Count, struct FString Filename );
	void ClearAllDelegates ( );
	void ClearDeleteUserFileCompleteDelegate ( struct FScriptDelegate DeleteUserFileCompleteDelegate );
	void AddDeleteUserFileCompleteDelegate ( struct FScriptDelegate DeleteUserFileCompleteDelegate );
	void CallDeleteUserFileCompleteDelegates ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnDeleteUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnHTTPRequestDeleteUserFileComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	bool DeleteUserFile ( struct FString UserId, struct FString Filename, unsigned long bShouldCloudDelete, unsigned long bShouldLocallyDelete );
	void ClearWriteUserFileCompleteDelegate ( struct FScriptDelegate WriteUserFileCompleteDelegate );
	void AddWriteUserFileCompleteDelegate ( struct FScriptDelegate WriteUserFileCompleteDelegate );
	void CallWriteUserFileCompleteDelegates ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnWriteUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnHTTPRequestWriteUserFileComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void GetUserFileIndexForRequest ( class UHttpRequestInterface* Request, int* UserIdx, int* FileIdx );
	bool WriteUserFile ( struct FString UserId, struct FString Filename, TArray< unsigned char >* FileContents );
	void ClearReadUserFileCompleteDelegate ( struct FScriptDelegate ReadUserFileCompleteDelegate );
	void AddReadUserFileCompleteDelegate ( struct FScriptDelegate ReadUserFileCompleteDelegate );
	void CallReadUserFileCompleteDelegates ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnReadUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnHTTPRequestReadUserFileComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	bool ReadUserFile ( struct FString UserId, struct FString Filename );
	void GetUserFileList ( struct FString UserId, TArray< struct FEmsFile >* UserFiles );
	void ClearEnumerateUserFileCompleteDelegate ( struct FScriptDelegate EnumerateUserFileCompleteDelegate );
	void AddEnumerateUserFileCompleteDelegate ( struct FScriptDelegate EnumerateUserFileCompleteDelegate );
	void CallEnumerateUserFileCompleteDelegates ( unsigned long bWasSuccessful, struct FString UserId );
	void OnEnumerateUserFilesComplete ( unsigned long bWasSuccessful, struct FString UserId );
	void OnHTTPRequestEnumerateUserFilesComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void EnumerateUserFiles ( struct FString UserId );
	bool ClearFile ( struct FString UserId, struct FString Filename );
	bool ClearFiles ( struct FString UserId );
	bool GetFileContents ( struct FString UserId, struct FString Filename, TArray< unsigned char >* FileContents );
};



// Class IpDrv.MeshBeacon ( Property size: 17 iter: 25) 
// Class name index: 7707 
// 0x0044 (0x00A4 - 0x0060)
class UMeshBeacon : public UObject
{
public:
	struct FPointer                                    VfTable_FTickableObject;                          		// 0x0060 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	int                                                MeshBeaconPort;                                   		// 0x0068 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FPointer                                    Socket;                                           		// 0x006C (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	unsigned long                                      bIsInTick : 1;                                    		// 0x0074 (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )
	unsigned long                                      bWantsDeferredDestroy : 1;                        		// 0x0074 (0x0004) [0x0000000000002000] [0x00000002] ( CPF_Transient )
	unsigned long                                      bShouldTick : 1;                                  		// 0x0074 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      UDP_Socket : 1;                                   		// 0x0074 (0x0004) [0x0000000000000000] [0x00000008] 
	float                                              HeartbeatTimeout;                                 		// 0x0078 (0x0004) [0x0000000000004000]              ( CPF_Config )
	float                                              ElapsedHeartbeatTime;                             		// 0x007C (0x0004) [0x0000000000000000]              
	struct FName                                       BeaconName;                                       		// 0x0080 (0x0008) [0x0000000000000000]              
	int                                                SocketSendBufferSize;                             		// 0x0088 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                SocketReceiveBufferSize;                          		// 0x008C (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MaxBandwidthTestBufferSize;                       		// 0x0090 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MinBandwidthTestBufferSize;                       		// 0x0094 (0x0004) [0x0000000000004000]              ( CPF_Config )
	float                                              MaxBandwidthTestSendTime;                         		// 0x0098 (0x0004) [0x0000000000004000]              ( CPF_Config )
	float                                              MaxBandwidthTestReceiveTime;                      		// 0x009C (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MaxBandwidthHistoryEntries;                       		// 0x00A0 (0x0004) [0x0000000000004000]              ( CPF_Config )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2956 ];

		return pClassPointer;
	};

	void eventDestroyBeacon ( );
};



// Class IpDrv.MeshBeaconClient ( Property size: 16 iter: 28) 
// Class name index: 7709 
// 0x00CC (0x0170 - 0x00A4)
class UMeshBeaconClient : public UMeshBeacon
{
public:
	struct FOnlineGameSearchResult                     HostPendingRequest;                               		// 0x00A4 (0x0010) [0x0000000000000002]              ( CPF_Const )
	struct FClientConnectionRequest                    ClientPendingRequest;                             		// 0x00B4 (0x0028) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FClientBandwidthTestData                    CurrentBandwidthTest;                             		// 0x00DC (0x0014) [0x0000000000000000]              
	unsigned char                                      ClientBeaconState;                                		// 0x00F0 (0x0001) [0x0000000000000000]              
	unsigned char                                      ClientBeaconRequestType;                          		// 0x00F1 (0x0001) [0x0000000000000000]              
	float                                              ConnectionRequestTimeout;                         		// 0x00F4 (0x0004) [0x0000000000004000]              ( CPF_Config )
	float                                              ConnectionRequestElapsedTime;                     		// 0x00F8 (0x0004) [0x0000000000000000]              
	struct FString                                     ResolverClassName;                                		// 0x00FC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	class UClass*                                      ResolverClass;                                    		// 0x010C (0x0008) [0x0000000000000000]              
	class UClientBeaconAddressResolver*                Resolver;                                         		// 0x0114 (0x0008) [0x0000000000000000]              
	unsigned long                                      bUsingRegisteredAddr : 1;                         		// 0x011C (0x0004) [0x0000000000002000] [0x00000001] ( CPF_Transient )
	struct FScriptDelegate                             __OnConnectionRequestResult__Delegate;            		// 0x0120 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0124 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReceivedBandwidthTestRequest__Delegate;       		// 0x0130 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0134 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReceivedBandwidthTestResults__Delegate;       		// 0x0140 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0144 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnTravelRequestReceived__Delegate;              		// 0x0150 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x0154 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnCreateNewSessionRequestReceived__Delegate;    		// 0x0160 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x0164 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2958 ];

		return pClassPointer;
	};

	bool SendHostNewGameSessionResponse ( unsigned long bSuccess, struct FName SessionName, class UClass* SearchClass, unsigned char* PlatformSpecificInfo );
	void OnCreateNewSessionRequestReceived ( struct FName SessionName, class UClass* SearchClass, TArray< struct FPlayerMember >* Players );
	void OnTravelRequestReceived ( struct FName SessionName, class UClass* SearchClass, unsigned char* PlatformSpecificInfo );
	void OnReceivedBandwidthTestResults ( unsigned char TestType, unsigned char TestResult, struct FConnectionBandwidthStats* BandwidthStats );
	void OnReceivedBandwidthTestRequest ( unsigned char TestType );
	void OnConnectionRequestResult ( unsigned char ConnectionResult );
	bool BeginBandwidthTest ( unsigned char TestType, int TestBufferSize );
	bool RequestConnection ( unsigned long bRegisterSecureAddress, struct FOnlineGameSearchResult* DesiredHost, struct FClientConnectionRequest* ClientRequest );
	void eventDestroyBeacon ( );
};



// Class IpDrv.MeshBeaconHost ( Property size: 10 iter: 30) 
// Class name index: 7711 
// 0x0080 (0x0124 - 0x00A4)
class UMeshBeaconHost : public UMeshBeacon
{
public:
	TArray< struct FClientMeshBeaconConnection >       ClientConnections;                                		// 0x00A4 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< struct FUniqueNetId >                      PendingPlayerConnections;                         		// 0x00B4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FUniqueNetId                                OwningPlayerId;                                   		// 0x00C4 (0x0008) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bAllowBandwidthTesting : 1;                       		// 0x00CC (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                ConnectionBacklog;                                		// 0x00D0 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FScriptDelegate                             __OnReceivedClientConnectionRequest__Delegate;    		// 0x00D4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00D8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnStartedBandwidthTest__Delegate;               		// 0x00E4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x00E8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnFinishedBandwidthTest__Delegate;              		// 0x00F4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00F8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAllPendingPlayersConnected__Delegate;         		// 0x0104 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x0108 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReceivedClientCreateNewSessionResult__Delegate;		// 0x0114 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x0118 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2960 ];

		return pClassPointer;
	};

	void OnReceivedClientCreateNewSessionResult ( unsigned long bSucceeded, struct FName SessionName, class UClass* SearchClass, unsigned char* PlatformSpecificInfo );
	bool RequestClientCreateNewSession ( struct FUniqueNetId PlayerNetId, struct FName SessionName, class UClass* SearchClass, TArray< struct FPlayerMember >* Players );
	void TellClientsToTravel ( struct FName SessionName, class UClass* SearchClass, unsigned char* PlatformSpecificInfo );
	void OnAllPendingPlayersConnected ( );
	bool AllPlayersConnected ( TArray< struct FUniqueNetId >* Players );
	int GetConnectionIndexForPlayer ( struct FUniqueNetId PlayerNetId );
	void SetPendingPlayerConnections ( TArray< struct FUniqueNetId >* Players );
	void OnFinishedBandwidthTest ( struct FUniqueNetId PlayerNetId, unsigned char TestType, unsigned char TestResult, struct FConnectionBandwidthStats* BandwidthStats );
	void OnStartedBandwidthTest ( struct FUniqueNetId PlayerNetId, unsigned char TestType );
	void OnReceivedClientConnectionRequest ( struct FClientMeshBeaconConnection* NewClientConnection );
	void AllowBandwidthTesting ( unsigned long bEnabled );
	void CancelPendingBandwidthTests ( );
	bool HasPendingBandwidthTest ( );
	void CancelInProgressBandwidthTests ( );
	bool HasInProgressBandwidthTest ( );
	bool RequestClientBandwidthTest ( struct FUniqueNetId PlayerNetId, unsigned char TestType, int TestBufferSize );
	void eventDestroyBeacon ( );
	bool InitHostBeacon ( struct FUniqueNetId InOwningPlayerId );
};



// Class IpDrv.OnlineSubsystemCommonImpl ( Property size: 6 iter: 9) 
// Class name index: 7713 
// 0x0024 (0x01E0 - 0x01BC)
class UOnlineSubsystemCommonImpl : public UOnlineSubsystem
{
public:
	struct FPointer                                    VoiceEngine;                                      		// 0x01BC (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	int                                                MaxLocalTalkers;                                  		// 0x01C4 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MaxRemoteTalkers;                                 		// 0x01C8 (0x0004) [0x0000000000004000]              ( CPF_Config )
	unsigned long                                      bIsUsingSpeechRecognition : 1;                    		// 0x01CC (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
	class UOnlineGameInterfaceImpl*                    GameInterfaceImpl;                                		// 0x01D0 (0x0008) [0x0000000000000000]              
	class UOnlineAuthInterfaceImpl*                    AuthInterfaceImpl;                                		// 0x01D8 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2962 ];

		return pClassPointer;
	};

	void GetRegisteredPlayers ( struct FName SessionName, TArray< struct FUniqueNetId >* OutRegisteredPlayers );
	bool IsPlayerInSession ( struct FName SessionName, struct FUniqueNetId PlayerID );
	struct FString eventGetPlayerNicknameFromIndex ( int UserIndex );
};



// Class IpDrv.OnlineAuthInterfaceImpl ( Property size: 31 iter: 93) 
// Class name index: 7715 
// 0x02C4 (0x0324 - 0x0060)
class UOnlineAuthInterfaceImpl : public UObject
{
public:
	struct FPointer                                    VfTable_IOnlineAuthInterface;                     		// 0x0060 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	class UOnlineSubsystemCommonImpl*                  OwningSubsystem;                                  		// 0x0068 (0x0008) [0x0000000000000000]              
	unsigned long                                      bAuthReady : 1;                                   		// 0x0070 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	struct FSparseArray_Mirror                         ClientAuthSessions;                               		// 0x0074 (0x0038) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FSparseArray_Mirror                         ServerAuthSessions;                               		// 0x00AC (0x0038) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FSparseArray_Mirror                         PeerAuthSessions;                                 		// 0x00E4 (0x0038) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FSparseArray_Mirror                         LocalClientAuthSessions;                          		// 0x011C (0x0038) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FSparseArray_Mirror                         LocalServerAuthSessions;                          		// 0x0154 (0x0038) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FSparseArray_Mirror                         LocalPeerAuthSessions;                            		// 0x018C (0x0038) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< struct FScriptDelegate >                   AuthReadyDelegates;                               		// 0x01C4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ClientAuthRequestDelegates;                       		// 0x01D4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ServerAuthRequestDelegates;                       		// 0x01E4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ClientAuthResponseDelegates;                      		// 0x01F4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ServerAuthResponseDelegates;                      		// 0x0204 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ClientAuthCompleteDelegates;                      		// 0x0214 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ServerAuthCompleteDelegates;                      		// 0x0224 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ClientAuthEndSessionRequestDelegates;             		// 0x0234 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ServerAuthRetryRequestDelegates;                  		// 0x0244 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ClientConnectionCloseDelegates;                   		// 0x0254 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ServerConnectionCloseDelegates;                   		// 0x0264 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnAuthReady__Delegate;                          		// 0x0274 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0278 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnClientAuthRequest__Delegate;                  		// 0x0284 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0288 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnServerAuthRequest__Delegate;                  		// 0x0294 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0298 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnClientAuthResponse__Delegate;                 		// 0x02A4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x02A8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnServerAuthResponse__Delegate;                 		// 0x02B4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x02B8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnClientAuthComplete__Delegate;                 		// 0x02C4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData05[ 0x4 ];                             		// 0x02C8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnServerAuthComplete__Delegate;                 		// 0x02D4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData06[ 0x4 ];                             		// 0x02D8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnClientAuthEndSessionRequest__Delegate;        		// 0x02E4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData07[ 0x4 ];                             		// 0x02E8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnServerAuthRetryRequest__Delegate;             		// 0x02F4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData08[ 0x4 ];                             		// 0x02F8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnClientConnectionClose__Delegate;              		// 0x0304 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData09[ 0x4 ];                             		// 0x0308 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnServerConnectionClose__Delegate;              		// 0x0314 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData10[ 0x4 ];                             		// 0x0318 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2964 ];

		return pClassPointer;
	};

	bool GetServerAddr ( int* OutServerIP, int* OutServerPort );
	bool GetServerUniqueId ( struct FUniqueNetId* OutServerUID );
	bool FindLocalServerAuthSession ( class UPlayer* ClientConnection, struct FLocalAuthSession* OutSessionInfo );
	bool FindServerAuthSession ( class UPlayer* ServerConnection, struct FAuthSession* OutSessionInfo );
	bool FindLocalClientAuthSession ( class UPlayer* ServerConnection, struct FLocalAuthSession* OutSessionInfo );
	bool FindClientAuthSession ( class UPlayer* ClientConnection, struct FAuthSession* OutSessionInfo );
	void AllLocalServerAuthSessions ( struct FLocalAuthSession* OutSessionInfo );
	void AllServerAuthSessions ( struct FAuthSession* OutSessionInfo );
	void AllLocalClientAuthSessions ( struct FLocalAuthSession* OutSessionInfo );
	void AllClientAuthSessions ( struct FAuthSession* OutSessionInfo );
	void EndAllRemoteServerAuthSessions ( );
	void EndAllLocalServerAuthSessions ( );
	void EndRemoteServerAuthSession ( struct FUniqueNetId ServerUID, int ServerIP );
	void EndLocalServerAuthSession ( struct FUniqueNetId ClientUID, int ClientIP );
	bool VerifyServerAuthSession ( struct FUniqueNetId ServerUID, int ServerIP, int AuthTicketUID );
	bool CreateServerAuthSession ( struct FUniqueNetId ClientUID, int ClientIP, int ClientPort, int* OutAuthTicketUID );
	void EndAllRemoteClientAuthSessions ( );
	void EndAllLocalClientAuthSessions ( );
	void EndRemoteClientAuthSession ( struct FUniqueNetId ClientUID, int ClientIP );
	void EndLocalClientAuthSession ( struct FUniqueNetId ServerUID, int ServerIP, int ServerPort );
	bool VerifyClientAuthSession ( struct FUniqueNetId ClientUID, int ClientIP, int ClientPort, int AuthTicketUID );
	bool CreateClientAuthSession ( struct FUniqueNetId ServerUID, int ServerIP, int ServerPort, unsigned long bSecure, int* OutAuthTicketUID );
	bool SendServerAuthRetryRequest ( );
	bool SendClientAuthEndSessionRequest ( class UPlayer* ClientConnection );
	bool SendServerAuthResponse ( class UPlayer* ClientConnection, int AuthTicketUID );
	bool SendClientAuthResponse ( int AuthTicketUID );
	bool SendServerAuthRequest ( struct FUniqueNetId ServerUID );
	bool SendClientAuthRequest ( class UPlayer* ClientConnection, struct FUniqueNetId ClientUID );
	void ClearServerConnectionCloseDelegate ( struct FScriptDelegate ServerConnectionCloseDelegate );
	void AddServerConnectionCloseDelegate ( struct FScriptDelegate ServerConnectionCloseDelegate );
	void OnServerConnectionClose ( class UPlayer* ServerConnection );
	void ClearClientConnectionCloseDelegate ( struct FScriptDelegate ClientConnectionCloseDelegate );
	void AddClientConnectionCloseDelegate ( struct FScriptDelegate ClientConnectionCloseDelegate );
	void OnClientConnectionClose ( class UPlayer* ClientConnection );
	void ClearServerAuthRetryRequestDelegate ( struct FScriptDelegate ServerAuthRetryRequestDelegate );
	void AddServerAuthRetryRequestDelegate ( struct FScriptDelegate ServerAuthRetryRequestDelegate );
	void OnServerAuthRetryRequest ( class UPlayer* ClientConnection );
	void ClearClientAuthEndSessionRequestDelegate ( struct FScriptDelegate ClientAuthEndSessionRequestDelegate );
	void AddClientAuthEndSessionRequestDelegate ( struct FScriptDelegate ClientAuthEndSessionRequestDelegate );
	void OnClientAuthEndSessionRequest ( class UPlayer* ServerConnection );
	void ClearServerAuthCompleteDelegate ( struct FScriptDelegate ServerAuthCompleteDelegate );
	void AddServerAuthCompleteDelegate ( struct FScriptDelegate ServerAuthCompleteDelegate );
	void OnServerAuthComplete ( unsigned long bSuccess, struct FUniqueNetId ServerUID, class UPlayer* ServerConnection, struct FString ExtraInfo );
	void ClearClientAuthCompleteDelegate ( struct FScriptDelegate ClientAuthCompleteDelegate );
	void AddClientAuthCompleteDelegate ( struct FScriptDelegate ClientAuthCompleteDelegate );
	void OnClientAuthComplete ( unsigned long bSuccess, struct FUniqueNetId ClientUID, class UPlayer* ClientConnection, struct FString ExtraInfo );
	void ClearServerAuthResponseDelegate ( struct FScriptDelegate ServerAuthResponseDelegate );
	void AddServerAuthResponseDelegate ( struct FScriptDelegate ServerAuthResponseDelegate );
	void OnServerAuthResponse ( struct FUniqueNetId ServerUID, int ServerIP, int AuthTicketUID );
	void ClearClientAuthResponseDelegate ( struct FScriptDelegate ClientAuthResponseDelegate );
	void AddClientAuthResponseDelegate ( struct FScriptDelegate ClientAuthResponseDelegate );
	void OnClientAuthResponse ( struct FUniqueNetId ClientUID, int ClientIP, int AuthTicketUID );
	void ClearServerAuthRequestDelegate ( struct FScriptDelegate ServerAuthRequestDelegate );
	void AddServerAuthRequestDelegate ( struct FScriptDelegate ServerAuthRequestDelegate );
	void OnServerAuthRequest ( class UPlayer* ClientConnection, struct FUniqueNetId ClientUID, int ClientIP, int ClientPort );
	void ClearClientAuthRequestDelegate ( struct FScriptDelegate ClientAuthRequestDelegate );
	void AddClientAuthRequestDelegate ( struct FScriptDelegate ClientAuthRequestDelegate );
	void OnClientAuthRequest ( struct FUniqueNetId ServerUID, int ServerIP, int ServerPort, unsigned long bSecure );
	void ClearAuthReadyDelegate ( struct FScriptDelegate AuthReadyDelegate );
	void AddAuthReadyDelegate ( struct FScriptDelegate AuthReadyDelegate );
	void OnAuthReady ( );
	bool IsReady ( );
};



// Class IpDrv.OnlineGameInterfaceImpl ( Property size: 39 iter: 113) 
// Class name index: 7717 
// 0x01F8 (0x0258 - 0x0060)
class UOnlineGameInterfaceImpl : public UObject
{
public:
	class UOnlineSubsystemCommonImpl*                  OwningSubsystem;                                  		// 0x0060 (0x0008) [0x0000000000000000]              
	class UOnlineGameSettings*                         GameSettings;                                     		// 0x0068 (0x0008) [0x0000000000000002]              ( CPF_Const )
	class UOnlineGameSearch*                           GameSearch;                                       		// 0x0070 (0x0008) [0x0000000000000002]              ( CPF_Const )
	TArray< struct FScriptDelegate >                   CreateOnlineGameCompleteDelegates;                		// 0x0078 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   UpdateOnlineGameCompleteDelegates;                		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   DestroyOnlineGameCompleteDelegates;               		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   JoinOnlineGameCompleteDelegates;                  		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   MigrateOnlineGameCompleteDelegates;               		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   JoinMigratedOnlineGameCompleteDelegates;          		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   RecalculateSkillRatingCompleteDelegates;          		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   StartOnlineGameCompleteDelegates;                 		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   EndOnlineGameCompleteDelegates;                   		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   FindOnlineGamesCompleteDelegates;                 		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   CancelFindOnlineGamesCompleteDelegates;           		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      LanBeaconState;                                   		// 0x0128 (0x0001) [0x0000000000000002]              ( CPF_Const )
	unsigned char                                      LanNonce[ 0x8 ];                                  		// 0x0129 (0x0008) [0x0000000000000002]              ( CPF_Const )
	int                                                LanAnnouncePort;                                  		// 0x0134 (0x0004) [0x0000000000004002]              ( CPF_Const | CPF_Config )
	int                                                LanGameUniqueId;                                  		// 0x0138 (0x0004) [0x0000000000004002]              ( CPF_Const | CPF_Config )
	int                                                LanPacketPlatformMask;                            		// 0x013C (0x0004) [0x0000000000004002]              ( CPF_Const | CPF_Config )
	float                                              LanQueryTimeLeft;                                 		// 0x0140 (0x0004) [0x0000000000000000]              
	float                                              LanQueryTimeout;                                  		// 0x0144 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FPointer                                    LanBeacon;                                        		// 0x0148 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	struct FPointer                                    SessionInfo;                                      		// 0x0150 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	struct FScriptDelegate                             __OnFindOnlineGamesComplete__Delegate;            		// 0x0158 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x015C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnCreateOnlineGameComplete__Delegate;           		// 0x0168 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x016C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnUpdateOnlineGameComplete__Delegate;           		// 0x0178 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x017C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDestroyOnlineGameComplete__Delegate;          		// 0x0188 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x018C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnCancelFindOnlineGamesComplete__Delegate;      		// 0x0198 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x019C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnJoinOnlineGameComplete__Delegate;             		// 0x01A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData05[ 0x4 ];                             		// 0x01AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnRegisterPlayerComplete__Delegate;             		// 0x01B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData06[ 0x4 ];                             		// 0x01BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnUnregisterPlayerComplete__Delegate;           		// 0x01C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData07[ 0x4 ];                             		// 0x01CC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnStartOnlineGameComplete__Delegate;            		// 0x01D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData08[ 0x4 ];                             		// 0x01DC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnEndOnlineGameComplete__Delegate;              		// 0x01E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData09[ 0x4 ];                             		// 0x01EC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnArbitrationRegistrationComplete__Delegate;    		// 0x01F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData10[ 0x4 ];                             		// 0x01FC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnGameInviteAccepted__Delegate;                 		// 0x0208 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData11[ 0x4 ];                             		// 0x020C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnRecalculateSkillRatingComplete__Delegate;     		// 0x0218 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData12[ 0x4 ];                             		// 0x021C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnMigrateOnlineGameComplete__Delegate;          		// 0x0228 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData13[ 0x4 ];                             		// 0x022C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnJoinMigratedOnlineGameComplete__Delegate;     		// 0x0238 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData14[ 0x4 ];                             		// 0x023C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQosStatusChanged__Delegate;                   		// 0x0248 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData15[ 0x4 ];                             		// 0x024C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2966 ];

		return pClassPointer;
	};

	void ClearQosStatusChangedDelegate ( struct FScriptDelegate QosStatusChangedDelegate );
	void AddQosStatusChangedDelegate ( struct FScriptDelegate QosStatusChangedDelegate );
	void OnQosStatusChanged ( int NumComplete, int NumTotal );
	bool BindPlatformSpecificSessionToSearch ( unsigned char SearchingPlayerNum, class UOnlineGameSearch* SearchSettings, unsigned char* PlatformSpecificInfo );
	bool ReadPlatformSpecificSessionInfoBySessionName ( struct FName SessionName, unsigned char* PlatformSpecificInfo );
	bool ReadPlatformSpecificSessionInfo ( struct FOnlineGameSearchResult* DesiredGame, unsigned char* PlatformSpecificInfo );
	bool QueryNonAdvertisedData ( int StartAt, int NumberToQuery );
	void ClearJoinMigratedOnlineGameCompleteDelegate ( struct FScriptDelegate JoinMigratedOnlineGameCompleteDelegate );
	void AddJoinMigratedOnlineGameCompleteDelegate ( struct FScriptDelegate JoinMigratedOnlineGameCompleteDelegate );
	void OnJoinMigratedOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool JoinMigratedOnlineGame ( unsigned char PlayerNum, struct FName SessionName, struct FOnlineGameSearchResult* DesiredGame );
	void ClearMigrateOnlineGameCompleteDelegate ( struct FScriptDelegate MigrateOnlineGameCompleteDelegate );
	void AddMigrateOnlineGameCompleteDelegate ( struct FScriptDelegate MigrateOnlineGameCompleteDelegate );
	void OnMigrateOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool MigrateOnlineGame ( unsigned char HostingPlayerNum, struct FName SessionName );
	void ClearRecalculateSkillRatingCompleteDelegate ( struct FScriptDelegate RecalculateSkillRatingGameCompleteDelegate );
	void AddRecalculateSkillRatingCompleteDelegate ( struct FScriptDelegate RecalculateSkillRatingCompleteDelegate );
	void OnRecalculateSkillRatingComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool RecalculateSkillRating ( struct FName SessionName, TArray< struct FUniqueNetId >* Players );
	bool AcceptGameInvite ( unsigned char LocalUserNum, struct FName SessionName );
	void ClearGameInviteAcceptedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate GameInviteAcceptedDelegate );
	void AddGameInviteAcceptedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate GameInviteAcceptedDelegate );
	void OnGameInviteAccepted ( struct FOnlineGameSearchResult* InviteResult );
	TArray< struct FOnlineArbitrationRegistrant > GetArbitratedPlayers ( struct FName SessionName );
	void ClearArbitrationRegistrationCompleteDelegate ( struct FScriptDelegate ArbitrationRegistrationCompleteDelegate );
	void AddArbitrationRegistrationCompleteDelegate ( struct FScriptDelegate ArbitrationRegistrationCompleteDelegate );
	void OnArbitrationRegistrationComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool RegisterForArbitration ( struct FName SessionName );
	void ClearEndOnlineGameCompleteDelegate ( struct FScriptDelegate EndOnlineGameCompleteDelegate );
	void AddEndOnlineGameCompleteDelegate ( struct FScriptDelegate EndOnlineGameCompleteDelegate );
	void OnEndOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool EndOnlineGame ( struct FName SessionName );
	void ClearStartOnlineGameCompleteDelegate ( struct FScriptDelegate StartOnlineGameCompleteDelegate );
	void AddStartOnlineGameCompleteDelegate ( struct FScriptDelegate StartOnlineGameCompleteDelegate );
	void OnStartOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool StartOnlineGame ( struct FName SessionName );
	void ClearUnregisterPlayerCompleteDelegate ( struct FScriptDelegate UnregisterPlayerCompleteDelegate );
	void AddUnregisterPlayerCompleteDelegate ( struct FScriptDelegate UnregisterPlayerCompleteDelegate );
	void OnUnregisterPlayerComplete ( struct FName SessionName, struct FUniqueNetId PlayerID, unsigned long bWasSuccessful );
	bool UnregisterPlayers ( struct FName SessionName, TArray< struct FUniqueNetId >* Players );
	bool UnregisterPlayer ( struct FName SessionName, struct FUniqueNetId PlayerID );
	void ClearRegisterPlayerCompleteDelegate ( struct FScriptDelegate RegisterPlayerCompleteDelegate );
	void AddRegisterPlayerCompleteDelegate ( struct FScriptDelegate RegisterPlayerCompleteDelegate );
	void OnRegisterPlayerComplete ( struct FName SessionName, struct FUniqueNetId PlayerID, unsigned long bWasSuccessful );
	bool RegisterPlayers ( struct FName SessionName, TArray< struct FUniqueNetId >* Players );
	bool RegisterPlayer ( struct FName SessionName, struct FUniqueNetId PlayerID, unsigned long bWasInvited );
	bool GetResolvedConnectString ( struct FName SessionName, struct FString* ConnectInfo );
	void ClearJoinOnlineGameCompleteDelegate ( struct FScriptDelegate JoinOnlineGameCompleteDelegate );
	void AddJoinOnlineGameCompleteDelegate ( struct FScriptDelegate JoinOnlineGameCompleteDelegate );
	void OnJoinOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool JoinOnlineGame ( unsigned char PlayerNum, struct FName SessionName, struct FOnlineGameSearchResult* DesiredGame );
	bool FreeSearchResults ( class UOnlineGameSearch* Search );
	void ClearCancelFindOnlineGamesCompleteDelegate ( struct FScriptDelegate CancelFindOnlineGamesCompleteDelegate );
	void AddCancelFindOnlineGamesCompleteDelegate ( struct FScriptDelegate CancelFindOnlineGamesCompleteDelegate );
	void OnCancelFindOnlineGamesComplete ( unsigned long bWasSuccessful );
	bool CancelFindOnlineGames ( );
	void ClearFindOnlineGamesCompleteDelegate ( struct FScriptDelegate FindOnlineGamesCompleteDelegate );
	void AddFindOnlineGamesCompleteDelegate ( struct FScriptDelegate FindOnlineGamesCompleteDelegate );
	bool FindOnlineGames ( unsigned char SearchingPlayerNum, class UOnlineGameSearch* SearchSettings );
	void ClearDestroyOnlineGameCompleteDelegate ( struct FScriptDelegate DestroyOnlineGameCompleteDelegate );
	void AddDestroyOnlineGameCompleteDelegate ( struct FScriptDelegate DestroyOnlineGameCompleteDelegate );
	void OnDestroyOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool DestroyOnlineGame ( struct FName SessionName );
	void ClearUpdateOnlineGameCompleteDelegate ( struct FScriptDelegate UpdateOnlineGameCompleteDelegate );
	void AddUpdateOnlineGameCompleteDelegate ( struct FScriptDelegate UpdateOnlineGameCompleteDelegate );
	void OnUpdateOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool UpdateOnlineGame ( struct FName SessionName, class UOnlineGameSettings* UpdatedGameSettings, unsigned long bShouldRefreshOnlineData );
	void ClearCreateOnlineGameCompleteDelegate ( struct FScriptDelegate CreateOnlineGameCompleteDelegate );
	void AddCreateOnlineGameCompleteDelegate ( struct FScriptDelegate CreateOnlineGameCompleteDelegate );
	void OnCreateOnlineGameComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool CreateOnlineGame ( unsigned char HostingPlayerNum, struct FName SessionName, class UOnlineGameSettings* NewGameSettings );
	class UOnlineGameSearch* GetGameSearch ( );
	class UOnlineGameSettings* GetGameSettings ( struct FName SessionName );
	void OnFindOnlineGamesComplete ( unsigned long bWasSuccessful );
};



// Class IpDrv.OnlinePlaylistManager ( Property size: 23 iter: 58) 
// Class name index: 7719 
// 0x00D0 (0x0130 - 0x0060)
class UOnlinePlaylistManager : public UObject
{
public:
	struct FPointer                                    VfTable_FTickableObject;                          		// 0x0060 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	TArray< struct FPlaylist >                         Playlists;                                        		// 0x0068 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FString >                           PlaylistFileNames;                                		// 0x0078 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FName >                             DatastoresToRefresh;                              		// 0x0088 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	int                                                DownloadCount;                                    		// 0x0098 (0x0004) [0x0000000000000000]              
	int                                                SuccessfulCount;                                  		// 0x009C (0x0004) [0x0000000000000000]              
	int                                                VersionNumber;                                    		// 0x00A0 (0x0004) [0x0000000000004000]              ( CPF_Config )
	TArray< struct FPlaylistPopulation >               PopulationData;                                   		// 0x00A4 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	int                                                WorldwideTotalPlayers;                            		// 0x00B4 (0x0004) [0x0000000000000000]              
	int                                                RegionTotalPlayers;                               		// 0x00B8 (0x0004) [0x0000000000000000]              
	class UOnlineTitleFileInterface*                   TitleFileInterface;                               		// 0x00BC (0x0010) [0x0000000000002000]              ( CPF_Transient )
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x00C4 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FString                                     PopulationFileName;                               		// 0x00CC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              NextPlaylistPopulationUpdateTime;                 		// 0x00DC (0x0004) [0x0000000000002000]              ( CPF_Transient )
	float                                              PlaylistPopulationUpdateInterval;                 		// 0x00E0 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MinPlaylistIdToReport;                            		// 0x00E4 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                CurrentPlaylistId;                                		// 0x00E8 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	struct FName                                       EventsInterfaceName;                              		// 0x00EC (0x0008) [0x0000000000004000]              ( CPF_Config )
	int                                                DataCenterId;                                     		// 0x00F4 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FString                                     DataCenterFileName;                               		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              LastPlaylistDownloadTime;                         		// 0x0108 (0x0004) [0x0000000000002000]              ( CPF_Transient )
	float                                              PlaylistRefreshInterval;                          		// 0x010C (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FScriptDelegate                             __OnReadPlaylistComplete__Delegate;               		// 0x0110 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0114 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnPlaylistPopulationDataUpdated__Delegate;      		// 0x0120 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0124 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2968 ];

		return pClassPointer;
	};

	void ParseDataCenterId ( TArray< unsigned char >* Data );
	void OnReadDataCenterIdComplete ( unsigned long bWasSuccessful, struct FString Filename );
	void ReadDataCenterId ( );
	void eventSendPlaylistPopulationUpdate ( int NumPlayers );
	void GetPopulationInfoFromPlaylist ( int PlaylistId, int* WorldwideTotal, int* RegionTotal );
	void ParsePlaylistPopulationData ( TArray< unsigned char >* Data );
	void OnPlaylistPopulationDataUpdated ( );
	void OnReadPlaylistPopulationComplete ( unsigned long bWasSuccessful, struct FString Filename );
	void ReadPlaylistPopulation ( );
	void Reset ( );
	void GetContentIdsFromPlaylist ( int PlaylistId, TArray< int >* ContentIds );
	class UClass* GetInventorySwapFromPlaylist ( int PlaylistId, class UClass* SourceInventory );
	void GetMapCycleFromPlaylist ( int PlaylistId, TArray< struct FName >* MapCycle );
	struct FString GetUrlFromPlaylist ( int PlaylistId );
	int GetMatchType ( int PlaylistId );
	bool IsPlaylistArbitrated ( int PlaylistId );
	void GetLoadBalanceIdFromPlaylist ( int PlaylistId, int* LoadBalanceId );
	void GetTeamInfoFromPlaylist ( int PlaylistId, int* TeamSize, int* TeamCount, int* MaxPartySize );
	bool PlaylistSupportsDedicatedServers ( int PlaylistId );
	bool HasAnyGameSettings ( int PlaylistId );
	class UOnlineGameSettings* GetGameSettings ( int PlaylistId, int GameSettingsId );
	void FinalizePlaylistObjects ( );
	void OnReadTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
	bool ShouldRefreshPlaylists ( );
	void DetermineFilesToDownload ( );
	void DownloadPlaylist ( );
	void OnReadPlaylistComplete ( unsigned long bWasSuccessful );
};



// Class IpDrv.PartyBeacon ( Property size: 10 iter: 16) 
// Class name index: 7722 
// 0x0038 (0x0098 - 0x0060)
class UPartyBeacon : public UObject
{
public:
	struct FPointer                                    VfTable_FTickableObject;                          		// 0x0060 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	int                                                PartyBeaconPort;                                  		// 0x0068 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FPointer                                    Socket;                                           		// 0x006C (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	unsigned long                                      bIsInTick : 1;                                    		// 0x0074 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bWantsDeferredDestroy : 1;                        		// 0x0074 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      bShouldTick : 1;                                  		// 0x0074 (0x0004) [0x0000000000000000] [0x00000004] 
	float                                              HeartbeatTimeout;                                 		// 0x0078 (0x0004) [0x0000000000004000]              ( CPF_Config )
	float                                              ElapsedHeartbeatTime;                             		// 0x007C (0x0004) [0x0000000000000000]              
	struct FName                                       BeaconName;                                       		// 0x0080 (0x0008) [0x0000000000000000]              
	struct FScriptDelegate                             __OnDestroyComplete__Delegate;                    		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2970 ];

		return pClassPointer;
	};

	void OnDestroyComplete ( );
	void eventDestroyBeacon ( );
};



// Class IpDrv.PartyBeaconClient ( Property size: 14 iter: 25) 
// Class name index: 7724 
// 0x00A8 (0x0140 - 0x0098)
class UPartyBeaconClient : public UPartyBeacon
{
public:
	struct FOnlineGameSearchResult                     HostPendingRequest;                               		// 0x0098 (0x0010) [0x0000000000000002]              ( CPF_Const )
	struct FPartyReservation                           PendingRequest;                                   		// 0x00A8 (0x001C) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      ClientBeaconState;                                		// 0x00C4 (0x0001) [0x0000000000000000]              
	unsigned char                                      ClientBeaconRequestType;                          		// 0x00C5 (0x0001) [0x0000000000000000]              
	float                                              ReservationRequestTimeout;                        		// 0x00C8 (0x0004) [0x0000000000004000]              ( CPF_Config )
	float                                              ReservationRequestElapsedTime;                    		// 0x00CC (0x0004) [0x0000000000000000]              
	struct FString                                     ResolverClassName;                                		// 0x00D0 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	class UClass*                                      ResolverClass;                                    		// 0x00E0 (0x0008) [0x0000000000000000]              
	class UClientBeaconAddressResolver*                Resolver;                                         		// 0x00E8 (0x0008) [0x0000000000000000]              
	struct FScriptDelegate                             __OnReservationRequestComplete__Delegate;         		// 0x00F0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00F4 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReservationCountUpdated__Delegate;            		// 0x0100 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0104 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnTravelRequestReceived__Delegate;              		// 0x0110 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0114 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnHostIsReady__Delegate;                        		// 0x0120 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x0124 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnHostHasCancelled__Delegate;                   		// 0x0130 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x0134 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2972 ];

		return pClassPointer;
	};

	void eventDestroyBeacon ( );
	bool CancelReservation ( struct FUniqueNetId CancellingPartyLeader );
	bool RequestReservationUpdate ( struct FUniqueNetId RequestingPartyLeader, struct FOnlineGameSearchResult* DesiredHost, TArray< struct FPlayerReservation >* PlayersToAdd );
	bool RequestReservation ( struct FUniqueNetId RequestingPartyLeader, struct FOnlineGameSearchResult* DesiredHost, TArray< struct FPlayerReservation >* Players );
	void OnHostHasCancelled ( );
	void OnHostIsReady ( );
	void OnTravelRequestReceived ( struct FName SessionName, class UClass* SearchClass, unsigned char* PlatformSpecificInfo );
	void OnReservationCountUpdated ( int ReservationRemaining );
	void OnReservationRequestComplete ( unsigned char ReservationResult );
};



// Class IpDrv.PartyBeaconHost ( Property size: 15 iter: 38) 
// Class name index: 7726 
// 0x007C (0x0114 - 0x0098)
class UPartyBeaconHost : public UPartyBeacon
{
public:
	TArray< struct FClientBeaconConnection >           Clients;                                          		// 0x0098 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	int                                                NumTeams;                                         		// 0x00A8 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                NumPlayersPerTeam;                                		// 0x00AC (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                NumReservations;                                  		// 0x00B0 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                NumConsumedReservations;                          		// 0x00B4 (0x0004) [0x0000000000000002]              ( CPF_Const )
	TArray< struct FPartyReservation >                 Reservations;                                     		// 0x00B8 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FName                                       OnlineSessionName;                                		// 0x00C8 (0x0008) [0x0000000000000000]              
	int                                                ConnectionBacklog;                                		// 0x00D0 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                ForceTeamNum;                                     		// 0x00D4 (0x0004) [0x0000000000000002]              ( CPF_Const )
	int                                                ReservedHostTeamNum;                              		// 0x00D8 (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bBestFitTeamAssignment : 1;                       		// 0x00DC (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      BeaconState;                                      		// 0x00E0 (0x0001) [0x0000000000000002]              ( CPF_Const )
	struct FScriptDelegate                             __OnReservationChange__Delegate;                  		// 0x00E4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00E8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReservationsFull__Delegate;                   		// 0x00F4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x00F8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnClientCancellationReceived__Delegate;         		// 0x0104 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0108 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2974 ];

		return pClassPointer;
	};

	int GetMaxAvailableTeamSize ( );
	void GetPartyLeaders ( TArray< struct FUniqueNetId >* PartyLeaders );
	void GetPlayers ( TArray< struct FUniqueNetId >* Players );
	void AppendReservationSkillsToSearch ( class UOnlineGameSearch* Search );
	void eventUnregisterParty ( struct FUniqueNetId PartyLeader );
	void eventUnregisterPartyMembers ( );
	void eventRegisterPartyMembers ( );
	bool AreReservationsFull ( );
	void TellClientsHostHasCancelled ( );
	void TellClientsHostIsReady ( );
	void TellClientsToTravel ( struct FName SessionName, class UClass* SearchClass, unsigned char* PlatformSpecificInfo );
	void eventDestroyBeacon ( );
	void OnClientCancellationReceived ( struct FUniqueNetId PartyLeader );
	void OnReservationsFull ( );
	void OnReservationChange ( );
	void HandlePlayerLogout ( struct FUniqueNetId PlayerID, unsigned long bMaintainParty );
	int GetExistingReservation ( struct FUniqueNetId* PartyLeader );
	unsigned char UpdatePartyReservationEntry ( struct FUniqueNetId PartyLeader, TArray< struct FPlayerReservation >* PlayerMembers );
	unsigned char AddPartyReservationEntry ( struct FUniqueNetId PartyLeader, int TeamNum, unsigned long bIsHost, TArray< struct FPlayerReservation >* PlayerMembers );
	bool InitHostBeacon ( int InNumTeams, int InNumPlayersPerTeam, int InNumReservations, struct FName InSessionName, int InForceTeamNum );
	void PauseReservationRequests ( unsigned long bPause );
};



// Class IpDrv.TcpipConnection ( Property size: 0 iter: 0) 
// Class name index: 7728 
// 0x0024 (0xB0E4 - 0xB0C0)
class UTcpipConnection : public UNetConnection
{
public:
//	 LastOffset: b0c0
//	 Class Propsize: b0e4
	unsigned char                                      UnknownData00[ 0x24 ];                            		// 0xB0C0 (0x0024) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2976 ];

		return pClassPointer;
	};

};



// Class IpDrv.TcpNetDriver ( Property size: 2 iter: 2) 
// Class name index: 7730 
// 0x0020 (0x0210 - 0x01F0)
class UTcpNetDriver : public UNetDriver
{
public:
	unsigned long                                      AllowPlayerPortUnreach : 1;                       		// 0x01F0 (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
	unsigned long                                      LogPortUnreach : 1;                               		// 0x01F4 (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
//	 LastOffset: 1f8
//	 Class Propsize: 210
	unsigned char                                      UnknownData00[ 0x18 ];                            		// 0x01F8 (0x0018) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2978 ];

		return pClassPointer;
	};

};



// Class IpDrv.WebRequest ( Property size: 9 iter: 24) 
// Class name index: 7734 
// 0x00E8 (0x0148 - 0x0060)
class UWebRequest : public UObject
{
public:
	struct FString                                     RemoteAddr;                                       		// 0x0060 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     URI;                                              		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     UserName;                                         		// 0x0080 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Password;                                         		// 0x0090 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                ContentLength;                                    		// 0x00A0 (0x0004) [0x0000000000000000]              
	struct FString                                     ContentType;                                      		// 0x00A4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      RequestType;                                      		// 0x00B4 (0x0001) [0x0000000000000000]              
	struct FMap_Mirror                                 HeaderMap;                                        		// 0x00B8 (0x0048) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FMap_Mirror                                 VariableMap;                                      		// 0x0100 (0x0048) [0x0000000000001002]              ( CPF_Const | CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2982 ];

		return pClassPointer;
	};

	int GetHexDigit ( struct FString D );
	void DecodeFormData ( struct FString Data );
	void ProcessHeaderString ( struct FString S );
	void Dump ( );
	void GetVariables ( TArray< struct FString >* varNames );
	struct FString GetVariableNumber ( struct FString VariableName, int Number, struct FString DefaultValue );
	int GetVariableCount ( struct FString VariableName );
	struct FString GetVariable ( struct FString VariableName, struct FString DefaultValue );
	void AddVariable ( struct FString VariableName, struct FString Value );
	void GetHeaders ( TArray< struct FString >* Headers );
	struct FString GetHeader ( struct FString HeaderName, struct FString DefaultValue );
	void AddHeader ( struct FString HeaderName, struct FString Value );
	struct FString EncodeBase64 ( struct FString Decoded );
	struct FString DecodeBase64 ( struct FString Encoded );
};



// Class IpDrv.WebResponse ( Property size: 7 iter: 28) 
// Class name index: 7736 
// 0x0084 (0x00E4 - 0x0060)
class UWebResponse : public UObject
{
public:
	TArray< struct FString >                           Headers;                                          		// 0x0060 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMap_Mirror                                 ReplacementMap;                                   		// 0x0070 (0x0048) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FString                                     IncludePath;                                      		// 0x00B8 (0x0010) [0x0000000000404002]              ( CPF_Const | CPF_Config | CPF_NeedCtorLink )
	struct FString                                     CharSet;                                          		// 0x00C8 (0x0010) [0x0000000000408002]              ( CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	class AWebConnection*                              Connection;                                       		// 0x00D8 (0x0008) [0x0000000000000000]              
	unsigned long                                      bSentText : 1;                                    		// 0x00E0 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bSentResponse : 1;                                		// 0x00E0 (0x0004) [0x0000000000000000] [0x00000002] 

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2984 ];

		return pClassPointer;
	};

	bool SentResponse ( );
	bool SentText ( );
	void Redirect ( struct FString URL );
	void SendStandardHeaders ( struct FString ContentType, unsigned long bCache );
	void HTTPError ( int ErrorNum, struct FString Data );
	void SendHeaders ( );
	void AddHeader ( struct FString Header, unsigned long bReplace );
	void HTTPHeader ( struct FString Header );
	void HttpResponse ( struct FString Header );
	void FailAuthentication ( struct FString Realm );
	bool SendCachedFile ( struct FString Filename, struct FString ContentType );
	void eventSendBinary ( int Count, unsigned char* B );
	void eventSendText ( struct FString Text, unsigned long bNoCRLF );
	void Dump ( );
	struct FString GetHTTPExpiration ( int OffsetSeconds );
	struct FString LoadParsedUHTM ( struct FString Filename );
	bool IncludeBinaryFile ( struct FString Filename );
	bool IncludeUHTM ( struct FString Filename );
	void ClearSubst ( );
	void Subst ( struct FString Variable, struct FString Value, unsigned long bClear );
	bool FileExists ( struct FString Filename );
};



// Class IpDrv.OnlinePlaylistProvider ( Property size: 4 iter: 4) 
// Class name index: 7739 
// 0x0028 (0x00BC - 0x0094)
class UOnlinePlaylistProvider : public UUIResourceDataProvider
{
public:
	int                                                PlaylistId;                                       		// 0x0094 (0x0004) [0x0000000000004000]              ( CPF_Config )
	TArray< struct FName >                             PlaylistGameTypeNames;                            		// 0x0098 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DisplayName;                                      		// 0x00A8 (0x0010) [0x000000000040C002]              ( CPF_Const | CPF_Config | CPF_Localized | CPF_NeedCtorLink )
	int                                                Priority;                                         		// 0x00B8 (0x0004) [0x0000000000004000]              ( CPF_Config )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2986 ];

		return pClassPointer;
	};

};



// Class IpDrv.UIDataStore_OnlinePlaylists ( Property size: 7 iter: 16) 
// Class name index: 7741 
// 0x0060 (0x00F8 - 0x0098)
class UUIDataStore_OnlinePlaylists : public UUIDataStore
{
public:
	struct FString                                     ProviderClassName;                                		// 0x0098 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	class UClass*                                      ProviderClass;                                    		// 0x00A8 (0x0008) [0x0000000000002000]              ( CPF_Transient )
	TArray< class UUIResourceDataProvider* >           RankedDataProviders;                              		// 0x00B0 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< class UUIResourceDataProvider* >           UnrankedDataProviders;                            		// 0x00C0 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< class UUIResourceDataProvider* >           RecModeDataProviders;                             		// 0x00D0 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	TArray< class UUIResourceDataProvider* >           PrivateDataProviders;                             		// 0x00E0 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	class UOnlinePlaylistManager*                      PlaylistMan;                                      		// 0x00F0 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 2988 ];

		return pClassPointer;
	};

	int eventGetMatchTypeForPlaylistId ( int PlaylistId );
	class UOnlinePlaylistProvider* GetOnlinePlaylistProvider ( struct FName ProviderTag, int PlaylistId, int* ProviderIndex );
	bool GetPlaylistProvider ( struct FName ProviderTag, int ProviderIndex, class UUIResourceDataProvider** out_Provider );
	bool GetResourceProviders ( struct FName ProviderTag, TArray< class UUIResourceDataProvider* >* out_Providers );
	void eventInit ( );
};



// Class IpDrv.WebApplication ( Property size: 3 iter: 9) 
// Class name index: 31444 
// 0x0020 (0x0080 - 0x0060)
class UWebApplication : public UObject
{
public:
	class AWorldInfo*                                  WorldInfo;                                        		// 0x0060 (0x0008) [0x0000000000000000]              
	class AWebServer*                                  WebServer;                                        		// 0x0068 (0x0008) [0x0000000000000000]              
	struct FString                                     Path;                                             		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 35875 ];

		return pClassPointer;
	};

	void PostQuery ( class UWebRequest* Request, class UWebResponse* Response );
	void Query ( class UWebRequest* Request, class UWebResponse* Response );
	bool PreQuery ( class UWebRequest* Request, class UWebResponse* Response );
	void CleanupApp ( );
	void Cleanup ( );
	void Init ( );
};



// Class IpDrv.WebServer ( Property size: 12 iter: 17) 
// Class name index: 31446 
// 0x01CC (0x0464 - 0x0298)
class AWebServer : public ATcpLink
{
public:
	struct FString                                     ServerName;                                       		// 0x0298 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     Applications[ 0xA ];                              		// 0x02A8 (0x00A0) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ApplicationPaths[ 0xA ];                          		// 0x0348 (0x00A0) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	unsigned long                                      bEnabled : 1;                                     		// 0x03E8 (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
	int                                                ListenPort;                                       		// 0x03EC (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MaxConnections;                                   		// 0x03F0 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                DefaultApplication;                               		// 0x03F4 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                ExpirationSeconds;                                		// 0x03F8 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FString                                     ServerURL;                                        		// 0x03FC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UWebApplication*                             ApplicationObjects[ 0xA ];                        		// 0x040C (0x0050) [0x0000000000000000]              
	int                                                ConnectionCount;                                  		// 0x045C (0x0004) [0x0000000000000000]              
	int                                                ConnID;                                           		// 0x0460 (0x0004) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 35892 ];

		return pClassPointer;
	};

	class UWebApplication* GetApplication ( struct FString URI, struct FString* SubURI );
	void eventLostChild ( class AActor* C );
	void eventGainedChild ( class AActor* C );
	void eventDestroyed ( );
	void PostBeginPlay ( );
};



// Class IpDrv.HelloWeb ( Property size: 0 iter: 2) 
// Class name index: 30410 
// 0x0000 (0x0080 - 0x0080)
class UHelloWeb : public UWebApplication
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 35894 ];

		return pClassPointer;
	};

	void eventQuery ( class UWebRequest* Request, class UWebResponse* Response );
	void Init ( );
};



// Class IpDrv.ImageServer ( Property size: 0 iter: 1) 
// Class name index: 30430 
// 0x0000 (0x0080 - 0x0080)
class UImageServer : public UWebApplication
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 35913 ];

		return pClassPointer;
	};

	void eventQuery ( class UWebRequest* Request, class UWebResponse* Response );
};



// Class IpDrv.McpServiceConfig ( Property size: 12 iter: 14) 
// Class name index: 30652 
// 0x00C0 (0x0120 - 0x0060)
class UMcpServiceConfig : public UObject
{
public:
	struct FString                                     DevProtocol;                                      		// 0x0060 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ProdProtocol;                                     		// 0x0070 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DevDomain;                                        		// 0x0080 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ProdDomain;                                       		// 0x0090 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     Domain;                                           		// 0x00A0 (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
	struct FString                                     Protocol;                                         		// 0x00B0 (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
	struct FString                                     AppKey;                                           		// 0x00C0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     AppSecret;                                        		// 0x00D0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GameName;                                         		// 0x00E0 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ServiceName;                                      		// 0x00F0 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     GameUser;                                         		// 0x0100 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GamePassword;                                     		// 0x0110 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36021 ];

		return pClassPointer;
	};

	struct FString GetUserAuthTicket ( struct FString McpId );
	void Init ( unsigned long bIsProduction );
};



// Class IpDrv.McpUserAuthRequestWrapper ( Property size: 2 iter: 13) 
// Class name index: 30660 
// 0x0018 (0x0088 - 0x0070)
class UMcpUserAuthRequestWrapper : public UHttpRequestInterface
{
public:
	struct FString                                     McpId;                                            		// 0x0070 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       WrappedObject;                                    		// 0x0080 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36024 ];

		return pClassPointer;
	};

	class UHttpRequestInterface* SetProcessRequestCompleteDelegate ( struct FScriptDelegate ProcessRequestCompleteDelegate );
	void WrappedOnProcessRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* Response, unsigned long bDidSucceed );
	void ReportError ( int ResponseCode, struct FString ErrorString );
	bool ProcessRequest ( );
	class UHttpRequestInterface* SetHeader ( struct FString HeaderName, struct FString HeaderValue );
	class UHttpRequestInterface* SetContentAsString ( struct FString ContentString );
	class UHttpRequestInterface* SetContent ( TArray< unsigned char >* ContentPayload );
	class UHttpRequestInterface* SetURL ( struct FString URL );
	class UHttpRequestInterface* SetVerb ( struct FString Verb );
	struct FString GetVerb ( );
	void Init ( struct FString InMcpId, class UHttpRequestInterface* RequestObject );
};



// Class IpDrv.McpUserManagerBase ( Property size: 5 iter: 29) 
// Class name index: 30671 
// 0x0050 (0x00C8 - 0x0078)
class UMcpUserManagerBase : public UMcpServiceBase
{
public:
	struct FString                                     McpUserManagerClassName;                          		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnRegisterUserComplete__Delegate;               		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAuthenticateUserComplete__Delegate;           		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryUsersComplete__Delegate;                 		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteUserComplete__Delegate;                 		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x00BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36026 ];

		return pClassPointer;
	};

	struct FString GetAuthToken ( struct FString McpId );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUser ( struct FString McpId );
	bool GetUserExternalAccountId ( struct FString McpId, struct FString ExternalAccountType, struct FString* ExternalAccountId );
	bool UserHasExternalAccount ( struct FString McpId, struct FString ExternalAccountType );
	bool GetUser ( struct FString McpId, struct FMcpUserStatus* User );
	void GetUsers ( TArray< struct FMcpUserStatus >* Users );
	void OnQueryUsersComplete ( unsigned long bWasSuccessful, struct FString Error );
	void QueryUsers ( struct FString McpId, TArray< struct FString >* McpIds );
	void QueryUser ( struct FString McpId, unsigned long bShouldUpdateLastActive );
	void InjectUserCredentials ( struct FString McpId, struct FString ClientSecret, struct FString Token );
	void OnAuthenticateUserComplete ( struct FString McpId, struct FString Token, unsigned long bWasSuccessful, struct FString Error );
	void AuthenticateUserGameCenter ( struct FString GameCenterId );
	void AuthenticateUserMcp ( struct FString McpId, struct FString ClientSecret, struct FString UDID );
	void AuthenticateUserGoogle ( struct FString GoogleId, struct FString GoogleAuthToken );
	void AuthenticateUserFacebook ( struct FString FacebookId, struct FString FacebookToken, struct FString UDID );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void RegisterUserGoogle ( struct FString GoogleId, struct FString GoogleAuthToken );
	void RegisterUserGameCenter ( struct FString GameCenterId );
	void RegisterUserFacebook ( struct FString FacebookId, struct FString FacebookAuthToken );
	void RegisterUserGenerated ( );
	class UMcpUserManagerBase* CreateInstance ( );
};



// Class IpDrv.McpClashMobBase ( Property size: 8 iter: 42) 
// Class name index: 30593 
// 0x0080 (0x00F8 - 0x0078)
class UMcpClashMobBase : public UMcpServiceBase
{
public:
	struct FString                                     McpClashMobClassName;                             		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnQueryChallengeListComplete__Delegate;         		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryChallengeComplete__Delegate;             		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDownloadChallengeFileComplete__Delegate;      		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAcceptChallengeComplete__Delegate;            		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x00BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryChallengeUserStatusComplete__Delegate;   		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x00CC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnUpdateChallengeUserProgressComplete__Delegate;		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData05[ 0x4 ];                             		// 0x00DC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnUpdateChallengeUserRewardComplete__Delegate;  		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData06[ 0x4 ];                             		// 0x00EC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36039 ];

		return pClassPointer;
	};

	void UpdateChallengeUserReward ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, int UserReward );
	void OnUpdateChallengeUserRewardComplete ( unsigned long bWasSuccessful, struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString Error );
	void UpdateChallengeUserProgress ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, unsigned long bDidComplete, int GoalProgress );
	void OnUpdateChallengeUserProgressComplete ( unsigned long bWasSuccessful, struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString Error );
	bool GetChallengeUserStatusForSaveSlot ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, struct FMcpClashMobChallengeUserStatus* OutChallengeUserStatus );
	void GetChallengeUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, TArray< struct FMcpClashMobChallengeUserStatus >* OutChallengeUserStatuses );
	void QueryChallengeMultiUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, int AdditionalParticipantCount, unsigned long bWantsParentChildData, TArray< struct FString >* UserIdsToRead );
	void QueryChallengeUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, unsigned long bWantsParentChildData );
	void OnQueryChallengeUserStatusComplete ( unsigned long bWasSuccessful, struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString Error );
	void AcceptChallenge ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, unsigned long bLiked, unsigned long bCommented, unsigned long bRetweeted );
	void OnAcceptChallengeComplete ( unsigned long bWasSuccessful, struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString Error );
	void DeleteCachedChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void ClearCachedChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void GetChallengeFileContents ( struct FString UniqueChallengeId, struct FString DLName, TArray< unsigned char >* OutFileContents );
	void DownloadChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void GetChallengeFileList ( struct FString UniqueChallengeId, TArray< struct FMcpClashMobChallengeFile >* OutChallengeFiles );
	void OnDownloadChallengeFileComplete ( unsigned long bWasSuccessful, struct FString UniqueChallengeId, struct FString DLName, struct FString Filename, struct FString Error );
	void OnQueryChallengeComplete ( unsigned long bWasSuccessful, struct FString ChallengeId, struct FString Error );
	void QueryParentChallenge ( struct FString ChallengeId );
	void QueryChallenge ( struct FString ChallengeId );
	bool GetChallenge ( struct FString UniqueChallengeId, struct FMcpClashMobChallengeEvent* OutChallengeEvent );
	void GetChallengeList ( TArray< struct FMcpClashMobChallengeEvent >* OutChallengeEvents );
	void QueryChallengeList ( struct FString McpId );
	void OnQueryChallengeListComplete ( unsigned long bWasSuccessful, struct FString Error );
	class UMcpClashMobBase* CreateInstance ( );
};



// Class IpDrv.McpClashMobFileDownload ( Property size: 0 iter: 1) 
// Class name index: 30598 
// 0x0000 (0x0114 - 0x0114)
class UMcpClashMobFileDownload : public UOnlineTitleFileDownloadWeb
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36358 ];

		return pClassPointer;
	};

	struct FString GetUrlForFile ( struct FString Filename );
};



// Class IpDrv.McpClashMobManager ( Property size: 14 iter: 38) 
// Class name index: 30599 
// 0x015C (0x0254 - 0x00F8)
class UMcpClashMobManager : public UMcpClashMobBase
{
public:
	struct FString                                     ChallengeListUrl;                                 		// 0x00F8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ChallengeStatusUrl;                               		// 0x0108 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ChallengeMultiStatusUrl;                          		// 0x0118 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     AcceptChallengeUrl;                               		// 0x0128 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     UpdateChallengeProgressUrl;                       		// 0x0138 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     UpdateRewardProgressUrl;                          		// 0x0148 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	class UHttpRequestInterface*                       HTTPRequestChallengeList;                         		// 0x0158 (0x0008) [0x0000000000000000]              
	TArray< struct FMcpChallengeUserRequest >          ChallengeUserRequests;                            		// 0x0160 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeEvent >        ChallengeEvents;                                  		// 0x0170 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeUserStatus >   ChallengeUserStatus;                              		// 0x0180 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpClashMobChallengeUserStatus             TempChallengeUserStatus;                          		// 0x0190 (0x009C) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeUserStatus >   TempChallengeUserStatusArray;                     		// 0x022C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UOnlineTitleFileCacheInterface*              FileCache;                                        		// 0x023C (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0244 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	class UMcpClashMobFileDownload*                    FileDownloader;                                   		// 0x024C (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36364 ];

		return pClassPointer;
	};

	void OnUpdateChallengeUserRewardHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void UpdateChallengeUserReward ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, int UserReward );
	void OnUpdateChallengeUserProgressHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void UpdateChallengeUserProgress ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, unsigned long bDidComplete, int GoalProgress );
	void GetChallengeUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, TArray< struct FMcpClashMobChallengeUserStatus >* OutChallengeUserStatuses );
	void OnQueryChallengeMultiStatusHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryChallengeMultiUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, int Ignored, unsigned long Ignored2, TArray< struct FString >* UserIdsToRead );
	void OnQueryChallengeStatusHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryChallengeUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, unsigned long Ignored );
	void OnAcceptChallengeHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AcceptChallenge ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, unsigned long bLiked, unsigned long bCommented, unsigned long bRetweeted );
	void DeleteCachedChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void ClearCachedChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void GetChallengeFileContents ( struct FString UniqueChallengeId, struct FString DLName, TArray< unsigned char >* OutFileContents );
	void OnDownloadMcpFileComplete ( unsigned long bWasSuccessful, struct FString DLName );
	void OnLoadCachedFileComplete ( unsigned long bWasSuccessful, struct FString DLName );
	void DownloadChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void GetChallengeFileList ( struct FString UniqueChallengeId, TArray< struct FMcpClashMobChallengeFile >* OutChallengeFiles );
	void GetChallengeList ( TArray< struct FMcpClashMobChallengeEvent >* OutChallengeEvents );
	void OnQueryChallengeListHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryChallengeList ( struct FString McpId );
	void eventInit ( );
};



// Class IpDrv.McpClashMobManagerV3 ( Property size: 11 iter: 51) 
// Class name index: 30600 
// 0x00B0 (0x01A8 - 0x00F8)
class UMcpClashMobManagerV3 : public UMcpClashMobBase
{
public:
	struct FString                                     ChallengePath;                                    		// 0x00F8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     UserChallengePath;                                		// 0x0108 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     UserChallengeUpdatePath;                          		// 0x0118 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ChallengeFilePath;                                		// 0x0128 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeEvent >        ChallengeEvents;                                  		// 0x0138 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeUserStatus >   ChallengeStatuses;                                		// 0x0148 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FChallengeRequest >                 ChallengeRequests;                                		// 0x0158 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpClashMobManagerV3_FUserRequest > UserRequests;                                     		// 0x0168 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpClashMobManagerV3_FFileRequest > FileRequests;                                     		// 0x0178 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FClashMobFileData >                 ChallengeFiles;                                   		// 0x0188 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UOnlineTitleFileCacheInterface*              FileCache;                                        		// 0x0198 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x01A0 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36584 ];

		return pClassPointer;
	};

	void OnUpdateChallengeUserRewardRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void UpdateChallengeUserReward ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, int UserReward );
	void OnUpdateChallengeUserProgressRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void UpdateChallengeUserProgress ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, unsigned long bDidComplete, int GoalProgress );
	bool GetChallengeUserStatusForSaveSlot ( struct FString UniqueChallengeId, struct FString McpId, struct FString SaveSlotId, struct FMcpClashMobChallengeUserStatus* OutChallengeUserStatus );
	void GetChallengeUserStatus ( struct FString UniqueChallengeId, struct FString McpId, TArray< struct FMcpClashMobChallengeUserStatus >* OutChallengeUserStatuses );
	bool ParseUserChallengeStatus ( class UJsonObject* JsonNode );
	bool ParseUserChallengeStatuses ( struct FString JSON );
	void OnQueryChallengeUserStatusRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryChallengeMultiUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, int AdditionalParticipantCount, unsigned long bWantsParentChildData, TArray< struct FString >* UserIdsToRead );
	void QueryChallengeUserStatus ( struct FString UniqueChallengeId, struct FString UniqueUserId, unsigned long bWantsParentChildData );
	void OnAcceptChallengeRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AcceptChallenge ( struct FString UniqueChallengeId, struct FString UniqueUserId, struct FString SaveSlotId, unsigned long bLiked, unsigned long bCommented, unsigned long bRetweeted );
	struct FString BuildUserChallengeUpdatePath ( struct FString ChallengeId, struct FString McpId, struct FString SaveSlotId );
	struct FString BuildUserChallengePath ( struct FString ChallengeId );
	void DeleteCachedChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void ClearCachedChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void GetChallengeFileContents ( struct FString UniqueChallengeId, struct FString DLName, TArray< unsigned char >* OutFileContents );
	int FindChallengeFileIndex ( struct FString UniqueChallengeId, struct FString DLName );
	void OnDownloadChallengeFileRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DownloadFile ( struct FString UniqueChallengeId, struct FString DLName );
	void OnLoadCachedFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
	struct FString GetFileHash ( struct FString ChallengeId, struct FString DLName );
	void DownloadChallengeFile ( struct FString UniqueChallengeId, struct FString DLName );
	void GetChallengeFileList ( struct FString UniqueChallengeId, TArray< struct FMcpClashMobChallengeFile >* OutChallengeFiles );
	bool GetChallenge ( struct FString UniqueChallengeId, struct FMcpClashMobChallengeEvent* OutChallengeEvent );
	void GetChallengeList ( TArray< struct FMcpClashMobChallengeEvent >* OutChallengeEvents );
	bool ParseChallenge ( class UJsonObject* JsonNode );
	bool ParseChallenges ( struct FString JSON );
	void OnQueryParentChallengeRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryParentChallenge ( struct FString ChallengeId );
	void OnQueryChallengeRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryChallenge ( struct FString ChallengeId );
	void OnQueryChallengeListRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryChallengeList ( struct FString McpId );
	void eventInit ( );
};



// Class IpDrv.McpGroupsBase ( Property size: 10 iter: 37) 
// Class name index: 30611 
// 0x00A0 (0x0118 - 0x0078)
class UMcpGroupsBase : public UMcpServiceBase
{
public:
	struct FString                                     McpGroupsManagerClassName;                        		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnCreateGroupComplete__Delegate;                		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteGroupComplete__Delegate;                		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryGroupsComplete__Delegate;                		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryGroupMembersComplete__Delegate;          		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x00BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAddGroupMembersComplete__Delegate;            		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x00CC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnRemoveGroupMembersComplete__Delegate;         		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData05[ 0x4 ];                             		// 0x00DC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteAllGroupsComplete__Delegate;            		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData06[ 0x4 ];                             		// 0x00EC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryGroupInvitesComplete__Delegate;          		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData07[ 0x4 ];                             		// 0x00FC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAcceptGroupInviteComplete__Delegate;          		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData08[ 0x4 ];                             		// 0x010C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36867 ];

		return pClassPointer;
	};

	void OnAcceptGroupInviteComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void AcceptGroupInvite ( struct FString UniqueUserId, struct FString GroupID, unsigned long bShouldAccept );
	void GetGroupInviteList ( struct FString UserId, struct FMcpGroupList* InviteList );
	void OnQueryGroupInvitesComplete ( unsigned long bWasSuccessful, struct FString Error );
	void QueryGroupInvites ( struct FString UniqueUserId );
	void OnDeleteAllGroupsComplete ( struct FString RequesterId, unsigned long bWasSuccessful, struct FString Error );
	void DeleteAllGroups ( struct FString OwnerId );
	void OnRemoveGroupMembersComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void RemoveGroupMembers ( struct FString OwnerId, struct FString GroupID, TArray< struct FString >* MemberIds );
	void OnAddGroupMembersComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void AddGroupMembers ( struct FString OwnerId, struct FString GroupID, unsigned long bRequiresAcceptance, TArray< struct FString >* MemberIds );
	void GetGroupMembers ( struct FString GroupID, TArray< struct FMcpGroupMember >* GroupMembers );
	void OnQueryGroupMembersComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void QueryGroupMembers ( struct FString UniqueUserId, struct FString GroupID );
	void GetGroupList ( struct FString UserId, struct FMcpGroupList* GroupList );
	void OnQueryGroupsComplete ( struct FString UserId, unsigned long bWasSuccessful, struct FString Error );
	void QueryGroups ( struct FString RequesterId );
	void OnDeleteGroupComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void DeleteGroup ( struct FString UniqueUserId, struct FString GroupID );
	void OnCreateGroupComplete ( struct FMcpGroup Group, unsigned long bWasSuccessful, struct FString Error );
	void CreateGroup ( struct FString OwnerId, struct FString GroupName );
	class UMcpGroupsBase* CreateInstance ( );
};



// Class IpDrv.McpGroupsManager ( Property size: 14 iter: 34) 
// Class name index: 30612 
// 0x00E0 (0x01F8 - 0x0118)
class UMcpGroupsManager : public UMcpGroupsBase
{
public:
	struct FString                                     CreateGroupUrl;                                   		// 0x0118 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteGroupUrl;                                   		// 0x0128 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryGroupsUrl;                                   		// 0x0138 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryGroupMembersUrl;                             		// 0x0148 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     AddGroupMembersUrl;                               		// 0x0158 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     RemoveGroupMembersUrl;                            		// 0x0168 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteAllGroupsUrl;                               		// 0x0178 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     AcceptGroupInviteUrl;                             		// 0x0188 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     RejectGroupInviteUrl;                             		// 0x0198 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FMcpGroupList >                     GroupLists;                                       		// 0x01A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnQueryGroupsRequestComplete__Delegate;         		// 0x01B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x01BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryGroupMembersRequestComplete__Delegate;   		// 0x01C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x01CC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAddGroupMembersRequestComplete__Delegate;     		// 0x01D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x01DC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAcceptGroupInviteRequestComplete__Delegate;   		// 0x01E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x01EC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 36974 ];

		return pClassPointer;
	};

	void CacheGroupMember ( struct FString MemberId, struct FString GroupID, unsigned char AcceptState );
	void CacheGroup ( struct FString RequesterId, struct FMcpGroup Group );
	void OnAcceptGroupInviteRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void AcceptGroupInvite ( struct FString UniqueUserId, struct FString GroupID, unsigned long bShouldAccept );
	void OnDeleteAllGroupsRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void DeleteAllGroups ( struct FString UniqueUserId );
	void OnRemoveGroupMembersRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void RemoveGroupMembers ( struct FString UniqueUserId, struct FString GroupID, TArray< struct FString >* MemberIds );
	void OnAddGroupMembersRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void AddGroupMembers ( struct FString UniqueUserId, struct FString GroupID, unsigned long bRequiresAcceptance, TArray< struct FString >* MemberIds );
	void GetGroupMembers ( struct FString GroupID, TArray< struct FMcpGroupMember >* GroupMembers );
	void OnQueryGroupMembersRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void QueryGroupMembers ( struct FString UniqueUserId, struct FString GroupID );
	void GetGroupList ( struct FString UserId, struct FMcpGroupList* GroupList );
	void OnQueryGroupsRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void QueryGroups ( struct FString RequesterId );
	void OnDeleteGroupRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void DeleteGroup ( struct FString UniqueUserId, struct FString GroupID );
	void OnCreateGroupRequestComplete ( class UHttpRequestInterface* CreateGroupRequest, class UHttpResponseInterface* HttpResponse, unsigned long bWasSuccessful );
	void CreateGroup ( struct FString UniqueUserId, struct FString GroupName );
};



// Class IpDrv.McpGroupsManagerV3 ( Property size: 9 iter: 32) 
// Class name index: 30614 
// 0x0090 (0x01A8 - 0x0118)
class UMcpGroupsManagerV3 : public UMcpGroupsBase
{
public:
	struct FString                                     GroupsUrl;                                        		// 0x0118 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     GroupMembersUrl;                                  		// 0x0128 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FMcpGroup >                         Groups;                                           		// 0x0138 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FGroupRequest >                     DeleteGroupRequests;                              		// 0x0148 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FGroupUserRequest >                 DeleteAllRequests;                                		// 0x0158 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FGroupMemberRequest >               GroupMemberRequests;                              		// 0x0168 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnQueryGroupsRequestComplete__Delegate;         		// 0x0178 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x017C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryGroupMembersRequestComplete__Delegate;   		// 0x0188 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x018C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAddGroupMembersRequestComplete__Delegate;     		// 0x0198 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x019C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37136 ];

		return pClassPointer;
	};

	void AcceptGroupInvite ( struct FString UniqueUserId, struct FString GroupID, unsigned long bShouldAccept );
	void OnDeleteAllGroupsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteAllGroups ( struct FString UniqueUserId );
	void OnRemoveGroupMembersRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void RemoveGroupMembers ( struct FString UniqueUserId, struct FString GroupID, TArray< struct FString >* MemberIds );
	void OnAddGroupMembersRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AddGroupMembers ( struct FString UniqueUserId, struct FString GroupID, unsigned long bRequiresAcceptance, TArray< struct FString >* MemberIds );
	void GetGroupMembers ( struct FString GroupID, TArray< struct FMcpGroupMember >* GroupMembers );
	void OnQueryGroupMembersRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryGroupMembers ( struct FString UniqueUserId, struct FString GroupID );
	void GetGroupList ( struct FString UserId, struct FMcpGroupList* GroupList );
	void OnQueryGroupsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryGroups ( struct FString UniqueUserId );
	void OnDeleteGroupRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteGroup ( struct FString UniqueUserId, struct FString GroupID );
	void OnCreateGroupRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	int ParseGroup ( class UJsonObject* ParsedJson );
	void CreateGroup ( struct FString UniqueUserId, struct FString GroupName );
	struct FString BuildGroupMemberResourcePath ( struct FString GroupID, struct FString McpId );
	struct FString BuildGroupResourcePath ( struct FString McpId );
};



// Class IpDrv.McpIdMappingBase ( Property size: 3 iter: 10) 
// Class name index: 30619 
// 0x0030 (0x00A8 - 0x0078)
class UMcpIdMappingBase : public UMcpServiceBase
{
public:
	struct FString                                     McpIdMappingClassName;                            		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnAddMappingComplete__Delegate;                 		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryMappingsComplete__Delegate;              		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37313 ];

		return pClassPointer;
	};

	void GetIdMappings ( struct FString ExternalType, TArray< struct FMcpIdMapping >* IDMappings );
	void OnQueryMappingsComplete ( struct FString ExternalType, unsigned long bWasSuccessful, struct FString Error );
	void QueryMappings ( struct FString McpId, struct FString ExternalType, TArray< struct FString >* ExternalIds );
	void OnAddMappingComplete ( struct FString McpId, struct FString ExternalId, struct FString ExternalType, unsigned long bWasSuccessful, struct FString Error );
	void AddMapping ( struct FString McpId, struct FString ExternalId, struct FString ExternalType, struct FString ExternalToken );
	class UMcpIdMappingBase* CreateInstance ( );
};



// Class IpDrv.McpIdMappingManager ( Property size: 5 iter: 12) 
// Class name index: 30621 
// 0x0050 (0x00F8 - 0x00A8)
class UMcpIdMappingManager : public UMcpIdMappingBase
{
public:
	TArray< struct FMcpIdMapping >                     AccountMappings;                                  		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     AddMappingUrl;                                    		// 0x00B8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryMappingUrl;                                  		// 0x00C8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct UMcpIdMappingManager_FAddMappingRequest > AddMappingRequests;                               		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpIdMappingManager_FQueryMappingRequest > QueryMappingRequests;                             		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37351 ];

		return pClassPointer;
	};

	void GetIdMappings ( struct FString ExternalType, TArray< struct FMcpIdMapping >* IDMappings );
	void OnQueryMappingsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryMappings ( struct FString McpId, struct FString ExternalType, TArray< struct FString >* ExternalIds );
	void OnAddMappingRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AddMapping ( struct FString McpId, struct FString ExternalId, struct FString ExternalType, struct FString ExternalToken );
};



// Class IpDrv.McpIdMappingManagerV3 ( Property size: 5 iter: 14) 
// Class name index: 30622 
// 0x0050 (0x00F8 - 0x00A8)
class UMcpIdMappingManagerV3 : public UMcpIdMappingBase
{
public:
	TArray< struct FMcpIdMapping >                     AccountMappings;                                  		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     AddMappingUrl;                                    		// 0x00B8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryMappingUrl;                                  		// 0x00C8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct UMcpIdMappingManagerV3_FAddMappingRequest > AddMappingRequests;                               		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpIdMappingManagerV3_FQueryMappingRequest > QueryMappingRequests;                             		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37416 ];

		return pClassPointer;
	};

	void GetIdMappings ( struct FString ExternalType, TArray< struct FMcpIdMapping >* IDMappings );
	void OnQueryMappingsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryMappings ( struct FString McpId, struct FString ExternalType, TArray< struct FString >* ExternalIds );
	void OnAddMappingRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AddMapping ( struct FString McpId, struct FString ExternalId, struct FString ExternalType, struct FString ExternalToken );
	struct FString BuildQueryMappingResourcePath ( struct FString Type );
	struct FString BuildAddMappingResourcePath ( struct FString McpId );
};



// Class IpDrv.McpLeaderboardsBase ( Property size: 4 iter: 26) 
// Class name index: 30632 
// 0x0040 (0x00B8 - 0x0078)
class UMcpLeaderboardsBase : public UMcpServiceBase
{
public:
	struct FString                                     McpLeaderboardsClassName;                         		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnReadLeaderboardsComplete__Delegate;           		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadLeaderboardEntriesComplete__Delegate;     		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnWriteLeaderboardEntryComplete__Delegate;      		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37491 ];

		return pClassPointer;
	};

	void ClearLeaderboardEntriesForMcpId ( struct FString McpId );
	void ClearLeaderboardEntriesForLeaderboard ( struct FString LeaderboardName );
	void ClearAllLeaderboardEntries ( );
	void GetLeaderboardByColumnByRange ( struct FString LeaderboardName, unsigned char Timeframe, struct FString ColumnName, int Min, int Max, TArray< struct FMcpLeaderboardEntry >* Entries );
	void ReadLeaderboardColumnByRange ( struct FString LeaderboardName, unsigned char Timeframe, struct FString ColumnName, int Min, int Max, int NumToRead );
	void OnWriteLeaderboardEntryComplete ( unsigned long bWasSuccessful, struct FString Error, struct FString McpId, struct FString LeaderboardName );
	void WriteLeaderboardEntry ( struct FString McpId, struct FString LeaderboardName, TArray< struct FMcpLeaderboardColumnEntry >* Columns );
	void GetEntriesForLeaderboard ( struct FString LeaderboardName, TArray< struct FMcpLeaderboardEntry >* Entries );
	void GetLeaderboardEntriesForUsers ( struct FString LeaderboardName, TArray< struct FString >* McpIds, TArray< struct FMcpLeaderboardEntry >* Entries );
	void GetLeaderboardEntries ( struct FString McpId, struct FString LeaderboardName, TArray< struct FMcpLeaderboardEntry >* Entries );
	void OnReadLeaderboardEntriesComplete ( unsigned long bWasSuccessful, struct FString Error, struct FString LeaderboardName, unsigned char Timeframe );
	void ReadLeaderboardEntries ( struct FString LeaderboardName, unsigned char Timeframe, unsigned long bSkipRankAndPercentile, TArray< struct FString >* McpIds );
	void GetLeaderboards ( TArray< struct FMcpLeaderboard >* Leaderboards );
	void OnReadLeaderboardsComplete ( unsigned long bWasSuccessful, struct FString Error );
	void ReadLeaderboards ( );
	class UMcpLeaderboardsBase* CreateInstance ( );
};



// Class IpDrv.McpLeaderboardsV3 ( Property size: 8 iter: 33) 
// Class name index: 30634 
// 0x0080 (0x0138 - 0x00B8)
class UMcpLeaderboardsV3 : public UMcpLeaderboardsBase
{
public:
	struct FString                                     LeaderboardEntriesPath;                           		// 0x00B8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     BaseLeaderboardPath;                              		// 0x00C8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     LeaderboardEntryPath;                             		// 0x00D8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     LeaderboardEntriesByColumnRangePath;              		// 0x00E8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FLeaderboardTimeframeRequest >      LeaderboardTimeframeRequests;                     		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FUserLeaderboardRequest >           UserLeaderboardRequests;                          		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboard >                   Leaderboards;                                     		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardEntry >              Entries;                                          		// 0x0128 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37588 ];

		return pClassPointer;
	};

	void ClearLeaderboardEntriesForMcpId ( struct FString McpId );
	void ClearLeaderboardEntriesForLeaderboard ( struct FString LeaderboardName );
	void ClearAllLeaderboardEntries ( );
	void GetLeaderboardByColumnByRange ( struct FString LeaderboardName, unsigned char Timeframe, struct FString ColumnName, int Min, int Max, TArray< struct FMcpLeaderboardEntry >* OutEntries );
	void ReadLeaderboardColumnByRange ( struct FString LeaderboardName, unsigned char Timeframe, struct FString ColumnName, int Min, int Max, int NumToRead );
	void OnWriteLeaderboardEntryRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void WriteLeaderboardEntry ( struct FString McpId, struct FString LeaderboardName, TArray< struct FMcpLeaderboardColumnEntry >* Columns );
	void GetEntriesForLeaderboard ( struct FString LeaderboardName, TArray< struct FMcpLeaderboardEntry >* OutEntries );
	void GetLeaderboardEntriesForUsers ( struct FString LeaderboardName, TArray< struct FString >* McpIds, TArray< struct FMcpLeaderboardEntry >* OutEntries );
	void GetLeaderboardEntries ( struct FString McpId, struct FString LeaderboardName, TArray< struct FMcpLeaderboardEntry >* OutEntries );
	TArray< struct FMcpLeaderboardColumnEntry > ParseLeaderboardEntryValues ( struct FString LeaderboardName, class UJsonObject* LeaderboardEntry );
	void ParseLeaderboardEntry ( class UJsonObject* LeaderboardObject );
	void ParseLeaderboardEntries ( struct FString JSON );
	void OnReadLeaderboardEntriesRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadLeaderboardEntries ( struct FString LeaderboardName, unsigned char Timeframe, unsigned long bSkipRankAndPercentile, TArray< struct FString >* McpIds );
	struct FString TimeframeToString ( unsigned char Timeframe );
	unsigned char StringToTimeframe ( struct FString Timeframe );
	void GetLeaderboards ( TArray< struct FMcpLeaderboard >* OutLeaderboards );
	void ParseLeaderboard ( class UJsonObject* LeaderboardObject );
	void ParseLeaderboards ( struct FString JSON );
	void OnReadLeaderboardsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadLeaderboards ( );
};



// Class IpDrv.McpManagedValueManagerBase ( Property size: 5 iter: 18) 
// Class name index: 30637 
// 0x0050 (0x00C8 - 0x0078)
class UMcpManagedValueManagerBase : public UMcpServiceBase
{
public:
	struct FString                                     McpManagedValueManagerClassName;                  		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnCreateSaveSlotComplete__Delegate;             		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadSaveSlotComplete__Delegate;               		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnUpdateValueComplete__Delegate;                		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteValueComplete__Delegate;                		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x00BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37743 ];

		return pClassPointer;
	};

	void OnDeleteValueComplete ( struct FString McpId, struct FString SaveSlot, struct FName ValueId, unsigned long bWasSuccessful, struct FString Error );
	void DeleteValue ( struct FString McpId, struct FString SaveSlot, struct FName ValueId );
	void OnUpdateValueComplete ( struct FString McpId, struct FString SaveSlot, struct FName ValueId, int Value, unsigned long bWasSuccessful, struct FString Error );
	void UpdateValue ( struct FString McpId, struct FString SaveSlot, struct FName ValueId, int Value );
	int GetValue ( struct FString McpId, struct FString SaveSlot, struct FName ValueId );
	TArray< struct FManagedValue > GetValues ( struct FString McpId, struct FString SaveSlot );
	void OnReadSaveSlotComplete ( struct FString McpId, struct FString SaveSlot, unsigned long bWasSuccessful, struct FString Error );
	void ReadSaveSlot ( struct FString McpId, struct FString SaveSlot );
	void OnCreateSaveSlotComplete ( struct FString McpId, struct FString SaveSlot, unsigned long bWasSuccessful, struct FString Error );
	void CreateSaveSlot ( struct FString McpId, struct FString SaveSlot );
	class UMcpManagedValueManagerBase* CreateInstance ( );
};



// Class IpDrv.McpManagedValueManager ( Property size: 9 iter: 23) 
// Class name index: 30636 
// 0x0090 (0x0158 - 0x00C8)
class UMcpManagedValueManager : public UMcpManagedValueManagerBase
{
public:
	struct FString                                     CreateSaveSlotUrl;                                		// 0x00C8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ReadSaveSlotUrl;                                  		// 0x00D8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     UpdateValueUrl;                                   		// 0x00E8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteValueUrl;                                   		// 0x00F8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FManagedValueSaveSlot >             SaveSlots;                                        		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpManagedValueManager_FSaveSlotRequestState > CreateSaveSlotRequests;                           		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpManagedValueManager_FSaveSlotRequestState > ReadSaveSlotRequests;                             		// 0x0128 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FValueRequestState >                UpdateValueRequests;                              		// 0x0138 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FValueRequestState >                DeleteValueRequests;                              		// 0x0148 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 37810 ];

		return pClassPointer;
	};

	void OnDeleteValueRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteValue ( struct FString McpId, struct FString SaveSlot, struct FName ValueId );
	void OnUpdateValueRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void UpdateValue ( struct FString McpId, struct FString SaveSlot, struct FName ValueId, int Value );
	int GetValue ( struct FString McpId, struct FString SaveSlot, struct FName ValueId );
	TArray< struct FManagedValue > GetValues ( struct FString McpId, struct FString SaveSlot );
	void OnReadSaveSlotRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadSaveSlot ( struct FString McpId, struct FString SaveSlot );
	void ParseValuesForSaveSlot ( struct FString McpId, struct FString SaveSlot, struct FString JsonPayload );
	int FindSaveSlotIndex ( struct FString McpId, struct FString SaveSlot );
	void OnCreateSaveSlotRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void CreateSaveSlot ( struct FString McpId, struct FString SaveSlot );
};



// Class IpDrv.McpMessageManagerV3 ( Property size: 7 iter: 20) 
// Class name index: 30643 
// 0x0070 (0x015C - 0x00EC)
class UMcpMessageManagerV3 : public UMcpMessageBase
{
public:
	struct FString                                     OutboxPath;                                       		// 0x00EC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     InboxPath;                                        		// 0x00FC (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     HeaderPath;                                       		// 0x010C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     MessagePath;                                      		// 0x011C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FUserBasedRequest >                 UserBasedRequests;                                		// 0x012C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMessageBasedRequest >              MessageBasedRequests;                             		// 0x013C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpMessageContents >               Contents;                                         		// 0x014C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38129 ];

		return pClassPointer;
	};

	bool GetMessageContents ( struct FString MessageId, TArray< unsigned char >* MessageContents );
	void OnQueryMessageContentsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryMessageContents ( struct FString McpId, struct FString MessageId );
	void GetMessageList ( struct FString McpId, struct FMcpMessageList* MessageList );
	void OnQueryMessagesRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	int ParseMessage ( class UJsonObject* ParsedJson );
	void QueryMessages ( struct FString McpId );
	void OnDeleteMessageRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteMessage ( struct FString McpId, struct FString MessageId );
	void OnCreateMessageRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void CreateMessage ( struct FString FromUniqueUserId, struct FString FromFriendlyName, struct FString MessageType, struct FString PushMessage, struct FString ValidUntil, TArray< struct FString >* ToUniqueUserIds, TArray< unsigned char >* Body );
};



// Class IpDrv.McpRemoteNotificationBase ( Property size: 2 iter: 5) 
// Class name index: 30644 
// 0x0020 (0x0098 - 0x0078)
class UMcpRemoteNotificationBase : public UMcpServiceBase
{
public:
	struct FString                                     McpRemoteNotificationClassName;                   		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnRegisterPushNotificationTokenComplete__Delegate;		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38241 ];

		return pClassPointer;
	};

	void OnRegisterPushNotificationTokenComplete ( unsigned long bWasSuccessful, struct FString McpId, struct FString PushToken );
	void RegisterPushNotificationToken ( struct FString McpId, struct FString PushNotificationToken );
	class UMcpRemoteNotificationBase* CreateInstance ( );
};



// Class IpDrv.McpRemoteNotificationV3 ( Property size: 2 iter: 7) 
// Class name index: 30647 
// 0x0020 (0x00B8 - 0x0098)
class UMcpRemoteNotificationV3 : public UMcpRemoteNotificationBase
{
public:
	struct FString                                     PushNotificationPath;                             		// 0x0098 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct UMcpRemoteNotificationV3_FUserRequest > UserRequests;                                     		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38256 ];

		return pClassPointer;
	};

	void OnAssociatePushNotificationTokenRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AssociatePushNotificationToken ( struct FString McpId, struct FString PushNotificationToken );
	void OnPushNotificationRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void RegisterPushNotificationToken ( struct FString McpId, struct FString PushNotificationToken );
};



// Class IpDrv.McpServerTimeBase ( Property size: 2 iter: 6) 
// Class name index: 30648 
// 0x0020 (0x0098 - 0x0078)
class UMcpServerTimeBase : public UMcpServiceBase
{
public:
	struct FString                                     McpServerTimeClassName;                           		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnQueryServerTimeComplete__Delegate;            		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38297 ];

		return pClassPointer;
	};

	struct FString GetLastServerTime ( );
	void OnQueryServerTimeComplete ( unsigned long bWasSuccessful, struct FString DateTimeStr, struct FString Error );
	void QueryServerTime ( );
	class UMcpServerTimeBase* CreateInstance ( );
};



// Class IpDrv.McpServerTimeManager ( Property size: 3 iter: 6) 
// Class name index: 30650 
// 0x0028 (0x00C0 - 0x0098)
class UMcpServerTimeManager : public UMcpServerTimeBase
{
public:
	struct FString                                     TimeStampUrl;                                     		// 0x0098 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     LastTimeStamp;                                    		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       HTTPRequestServerTime;                            		// 0x00B8 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38312 ];

		return pClassPointer;
	};

	struct FString GetLastServerTime ( );
	void OnQueryServerTimeHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryServerTime ( );
};



// Class IpDrv.McpServerTimeManagerV3 ( Property size: 3 iter: 6) 
// Class name index: 30651 
// 0x0028 (0x00C0 - 0x0098)
class UMcpServerTimeManagerV3 : public UMcpServerTimeBase
{
public:
	struct FString                                     TimeStampUrl;                                     		// 0x0098 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     LastTimeStamp;                                    		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       HTTPRequestServerTime;                            		// 0x00B8 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38332 ];

		return pClassPointer;
	};

	struct FString GetLastServerTime ( );
	void OnQueryServerTimeHTTPRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryServerTime ( );
};



// Class IpDrv.McpSystemCloudFileManagerV3 ( Property size: 7 iter: 28) 
// Class name index: 30654 
// 0x0070 (0x00E8 - 0x0078)
class UMcpSystemCloudFileManagerV3 : public UMcpServiceBase
{
public:
	TArray< struct FScriptDelegate >                   ReadTitleFileCompleteDelegates;                   		// 0x0078 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   RequestTitleFileListCompleteDelegates;            		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     FileResourcePath;                                 		// 0x0098 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FEms3File >                         EmsFiles;                                         		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpSystemCloudFileManagerV3_FFileRequest > FileRequests;                                     		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnRequestTitleFileListComplete__Delegate;       		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00CC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadTitleFileComplete__Delegate;              		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x00DC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38358 ];

		return pClassPointer;
	};

	void GetTitleFileList ( TArray< struct FEmsFile >* FileList );
	void ClearRequestTitleFileListCompleteDelegate ( struct FScriptDelegate RequestTitleFileListDelegate );
	void AddRequestTitleFileListCompleteDelegate ( struct FScriptDelegate RequestTitleFileListDelegate );
	bool ParseFile ( class UJsonObject* JsonNode );
	bool ParseFiles ( struct FString JSON );
	void OnReadTitleFileListRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void RequestTitleFileList ( );
	bool ClearDownloadedFile ( struct FString Filename );
	int GetFileIndex ( struct FString Filename );
	bool ClearDownloadedFiles ( );
	unsigned char GetTitleFileState ( struct FString Filename );
	bool GetTitleFileContents ( struct FString Filename, TArray< unsigned char >* FileContents );
	void ClearReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate );
	void AddReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate );
	void OnReadTitleFileRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	bool ReadTitleFile ( struct FString FileToRead );
	void OnReadTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
	void OnRequestTitleFileListComplete ( unsigned long bWasSuccessful, struct FString ResultStr );
	class UHttpRequestInterface* CreateHttpRequest ( struct FString McpId );
};



// Class IpDrv.McpThreadedChatBase ( Property size: 10 iter: 40) 
// Class name index: 30655 
// 0x00A0 (0x0118 - 0x0078)
class UMcpThreadedChatBase : public UMcpServiceBase
{
public:
	struct FString                                     McpThreadedChatClassName;                         		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnReadSystemChatThreadsComplete__Delegate;      		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadUserChatThreadsComplete__Delegate;        		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnCreateUserChatThreadComplete__Delegate;       		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadChatPostsComplete__Delegate;              		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x00BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadChatPostsConcerningUserComplete__Delegate;		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x00CC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnPostToThreadComplete__Delegate;               		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData05[ 0x4 ];                             		// 0x00DC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReportPostComplete__Delegate;                 		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData06[ 0x4 ];                             		// 0x00EC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnVoteOnPostComplete__Delegate;                 		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData07[ 0x4 ];                             		// 0x00FC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteUserDataComplete__Delegate;             		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData08[ 0x4 ];                             		// 0x010C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38473 ];

		return pClassPointer;
	};

	void OnDeleteUserDataComplete ( unsigned long bWasSuccessful, struct FString McpId, struct FString Error );
	void DeleteUserData ( struct FString McpId );
	void VoteDownPost ( struct FString ThreadId, struct FString PostId, struct FString McpId );
	void OnVoteOnPostComplete ( unsigned long bWasSuccessful, struct FString PostId, struct FString Error );
	void VoteUpPost ( struct FString ThreadId, struct FString PostId, struct FString McpId );
	void OnReportPostComplete ( unsigned long bWasSuccessful, struct FString PostId, struct FString Error );
	void ReportPost ( struct FString ThreadId, struct FString PostId, struct FString McpId );
	void OnPostToThreadComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString McpId, struct FString Error );
	void PostToThread ( struct FString ThreadId, struct FString McpId, struct FString OwnerName, struct FString Message, struct FString ReplyToMessageId, struct FString ReplyToOwnerId, struct FString ReplyToOwnerName );
	void ClearChatPosts ( struct FString ThreadId );
	void GetChatPosts ( struct FString ThreadId, TArray< struct FMcpChatPost >* ChatPosts );
	void GetChatPostsForUser ( struct FString McpId, struct FString ThreadId, TArray< struct FMcpChatPost >* ChatPosts );
	void OnReadChatPostsConcerningUserComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString McpId, struct FString Error );
	void ReadChatPostsConcerningUser ( struct FString McpId, struct FString ThreadId, int Start, int Count );
	void OnReadChatPostsComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString Error );
	void ReadChatPostsByPopularity ( struct FString ThreadId, int Start, int Count );
	void ReadChatPostsForUsers ( struct FString ThreadId, int Start, int Count, TArray< struct FString >* McpIds );
	void ReadChatPostsByTime ( struct FString ThreadId, struct FString Before, int Count );
	void OnCreateUserChatThreadComplete ( unsigned long bWasSuccessful, struct FString McpId, struct FString ThreadName, struct FString Error );
	void CreateUserChatThread ( struct FString McpId, struct FString ThreadName );
	void GetUserChatThreads ( struct FString McpId, TArray< struct FMcpUserChatThread >* UserChatThreads );
	void OnReadUserChatThreadsComplete ( unsigned long bWasSuccessful, struct FString McpId, struct FString Error );
	void ReadUserChatThreads ( struct FString McpId );
	void GetSystemChatThreads ( TArray< struct FMcpSystemChatThread >* SystemChatThreads );
	void OnReadSystemChatThreadsComplete ( unsigned long bWasSuccessful, struct FString Error );
	void ReadSystemChatThreads ( );
	class UMcpThreadedChatBase* CreateInstance ( );
};



// Class IpDrv.McpThreadedChatV3 ( Property size: 13 iter: 50) 
// Class name index: 30658 
// 0x00C4 (0x01DC - 0x0118)
class UMcpThreadedChatV3 : public UMcpThreadedChatBase
{
public:
	struct FString                                     ChatThreadResource;                               		// 0x0118 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ChatThreadResourceConcerningUser;                 		// 0x0128 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ChatPostsResourceConcerningUser;                  		// 0x0138 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ChatPostsResourceForUsers;                        		// 0x0148 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	unsigned long                                      bWantsRepliesForUsers : 1;                        		// 0x0158 (0x0004) [0x0000000000004000] [0x00000001] ( CPF_Config )
	TArray< struct FMcpSystemChatThread >              SystemChatThreads;                                		// 0x015C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpUserChatThread >                UserChatThreads;                                  		// 0x016C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChatPost >                      ChatPosts;                                        		// 0x017C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpThreadedChatV3_FUserRequest >   UserRequests;                                     		// 0x018C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FUserThreadNameRequest >            UserThreadNameRequests;                           		// 0x019C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FThreadRequest >                    ThreadRequests;                                   		// 0x01AC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FUserThreadRequest >                UserThreadRequests;                               		// 0x01BC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FPostRequest >                      PostRequests;                                     		// 0x01CC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38613 ];

		return pClassPointer;
	};

	void OnDeleteUserDataRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteUserData ( struct FString McpId );
	void OnVoteOnPostRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void VoteOnPost ( struct FString ThreadId, struct FString PostId, struct FString McpId, unsigned long bVoteUp );
	void VoteDownPost ( struct FString ThreadId, struct FString PostId, struct FString McpId );
	void VoteUpPost ( struct FString ThreadId, struct FString PostId, struct FString McpId );
	void OnReportPostRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReportPost ( struct FString ThreadId, struct FString PostId, struct FString McpId );
	void OnPostToThreadRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void PostToThread ( struct FString ThreadId, struct FString McpId, struct FString OwnerName, struct FString Message, struct FString ReplyToMessageId, struct FString ReplyToOwnerId, struct FString ReplyToOwnerName );
	void ClearChatPosts ( struct FString ThreadId );
	void GetChatPostsForUser ( struct FString McpId, struct FString ThreadId, TArray< struct FMcpChatPost >* OutChatPosts );
	void GetChatPosts ( struct FString ThreadId, TArray< struct FMcpChatPost >* OutChatPosts );
	void ParseChatPost ( class UJsonObject* ParsedJson );
	void ParseChatPosts ( struct FString JsonPayload );
	void OnReadChatPostsConcerningUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadChatPostsConcerningUser ( struct FString McpId, struct FString ThreadId, int Start, int Count );
	void ReadChatPostsForUsers ( struct FString ThreadId, int Start, int Count, TArray< struct FString >* McpIds );
	void ReadChatPostsByPopularity ( struct FString ThreadId, int Start, int Count );
	void OnReadChatPostsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadChatPostsByTime ( struct FString ThreadId, struct FString Before, int Count );
	void OnCreateUserChatThreadRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void CreateUserChatThread ( struct FString McpId, struct FString ThreadName );
	void GetUserChatThreads ( struct FString McpId, TArray< struct FMcpUserChatThread >* OutUserChatThreads );
	void OnReadUserChatThreadsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadUserChatThreads ( struct FString McpId );
	void GetSystemChatThreads ( TArray< struct FMcpSystemChatThread >* OutSystemChatThreads );
	void ParseUserChatThread ( class UJsonObject* ParsedJson );
	void ParseSystemChatThread ( class UJsonObject* ParsedJson );
	void ParseThreads ( struct FString JsonPayload, unsigned long bSystemThread );
	void OnReadSystemChatThreadsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadSystemChatThreads ( );
};



// Class IpDrv.McpUserAuthResponseWrapper ( Property size: 2 iter: 5) 
// Class name index: 30661 
// 0x0014 (0x0074 - 0x0060)
class UMcpUserAuthResponseWrapper : public UHttpResponseInterface
{
public:
	int                                                ResponseCode;                                     		// 0x0060 (0x0004) [0x0000000000000000]              
	struct FString                                     ErrorString;                                      		// 0x0064 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 38894 ];

		return pClassPointer;
	};

	struct FString GetContentAsString ( );
	int GetResponseCode ( );
	void Init ( int InResponseCode, struct FString InErrorString );
};



// Class IpDrv.McpUserCloudFileManagerV3 ( Property size: 17 iter: 57) 
// Class name index: 30664 
// 0x0110 (0x0188 - 0x0078)
class UMcpUserCloudFileManagerV3 : public UMcpServiceBase
{
public:
	struct FString                                     FileResourcePath;                                 		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     LastNResourcePath;                                		// 0x0088 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FEmsUserFile >                      EmsFiles;                                         		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           LastNCloudSaveOwners;                             		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserCloudFileManagerV3_FFileRequest > FileRequests;                                     		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserCloudFileManagerV3_FUserRequest > UserRequests;                                     		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FUserFileRequest >                  UserFileRequests;                                 		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   EnumerateUserFilesCompleteDelegates;              		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ReadUserFileCompleteDelegates;                    		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   WriteUserFileCompleteDelegates;                   		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   DeleteUserFileCompleteDelegates;                  		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ReadLastNCloudSaveOwnersCompleteDelegates;        		// 0x0128 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnEnumerateUserFilesComplete__Delegate;         		// 0x0138 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x013C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadUserFileComplete__Delegate;               		// 0x0148 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x014C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnWriteUserFileComplete__Delegate;              		// 0x0158 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x015C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteUserFileComplete__Delegate;             		// 0x0168 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x016C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadLastNCloudSaveOwnersComplete__Delegate;   		// 0x0178 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x017C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 39111 ];

		return pClassPointer;
	};

	void GetLastNCloudSaveOwners ( TArray< struct FString >* McpIds );
	void ClearReadLastNCloudSaveOwnersCompleteDelegate ( struct FScriptDelegate CompleteDelegate );
	void AddReadLastNCloudSaveOwnersCompleteDelegate ( struct FScriptDelegate CompleteDelegate );
	void OnReadLastNCloudSaveOwnersRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadLastNCloudSaveOwners ( int Count, struct FString Filename );
	void ClearDeleteUserFileCompleteDelegate ( struct FScriptDelegate ClearDelegate );
	void AddDeleteUserFileCompleteDelegate ( struct FScriptDelegate AddDelegate );
	void ClearWriteUserFileCompleteDelegate ( struct FScriptDelegate ClearDelegate );
	void AddWriteUserFileCompleteDelegate ( struct FScriptDelegate AddDelegate );
	void ClearReadUserFileCompleteDelegate ( struct FScriptDelegate ClearDelegate );
	void AddReadUserFileCompleteDelegate ( struct FScriptDelegate AddDelegate );
	void ClearEnumerateUserFileCompleteDelegate ( struct FScriptDelegate ClearDelegate );
	void AddEnumerateUserFileCompleteDelegate ( struct FScriptDelegate AddDelegate );
	void ClearAllDelegates ( );
	bool ClearFile ( struct FString UserId, struct FString Filename );
	bool ClearFiles ( struct FString UserId );
	bool GetFileContents ( struct FString UserId, struct FString Filename, TArray< unsigned char >* FileContents );
	void GetUserFileList ( struct FString UserId, TArray< struct FEmsFile >* UserFiles );
	int FindUserFileIndex ( struct FString McpId, struct FString Filename );
	void OnWriteUserFileRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	bool WriteUserFile ( struct FString UserId, struct FString Filename, TArray< unsigned char >* FileContents );
	void OnDeleteUserFileRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	bool DeleteUserFile ( struct FString UserId, struct FString Filename, unsigned long bShouldCloudDelete, unsigned long bShouldLocallyDelete );
	void OnReadUserFileRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	bool ReadUserFile ( struct FString UserId, struct FString Filename );
	bool ParseFile ( class UJsonObject* JsonNode );
	bool ParseFiles ( struct FString JSON );
	void OnEnumerateUserFilesRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void EnumerateUserFiles ( struct FString UserId );
	class UHttpRequestInterface* CreateHttpRequest ( struct FString McpId );
	struct FString BuildFileResourcePath ( struct FString McpId, struct FString Filename );
	void OnReadLastNCloudSaveOwnersComplete ( unsigned long bWasSuccessful );
	void OnDeleteUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnWriteUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnReadUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void OnEnumerateUserFilesComplete ( unsigned long bWasSuccessful, struct FString UserId );
};



// Class IpDrv.McpUserInventoryBase ( Property size: 13 iter: 49) 
// Class name index: 30666 
// 0x00D0 (0x0148 - 0x0078)
class UMcpUserInventoryBase : public UMcpServiceBase
{
public:
	struct FString                                     McpUserInventoryClassName;                        		// 0x0078 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnCreateSaveSlotComplete__Delegate;             		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteSaveSlotComplete__Delegate;             		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x009C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQuerySaveSlotListComplete__Delegate;          		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x00AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryInventoryItemsComplete__Delegate;        		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x00BC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnPurchaseItemComplete__Delegate;               		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x00CC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnSellItemComplete__Delegate;                   		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData05[ 0x4 ];                             		// 0x00DC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnEarnItemComplete__Delegate;                   		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData06[ 0x4 ];                             		// 0x00EC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnConsumeItemComplete__Delegate;                		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData07[ 0x4 ];                             		// 0x00FC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnDeleteItemComplete__Delegate;                 		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData08[ 0x4 ];                             		// 0x010C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnRecordIapComplete__Delegate;                  		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData09[ 0x4 ];                             		// 0x011C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadSaveSlotComplete__Delegate;               		// 0x0128 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData10[ 0x4 ];                             		// 0x012C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnQueryIapListComplete__Delegate;               		// 0x0138 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData11[ 0x4 ];                             		// 0x013C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 39350 ];

		return pClassPointer;
	};

	bool GetIapList ( struct FString McpId, struct FMcpIapList* Iaps );
	void OnQueryIapListComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void QueryIapList ( struct FString McpId );
	bool GetSaveSlot ( struct FString McpId, struct FString SaveSlotId, struct FMcpInventorySaveSlot* SaveSlot );
	void OnReadSaveSlotComplete ( struct FString McpId, struct FString SaveSlotId, unsigned long bWasSuccessful, struct FString Error );
	void ReadSaveSlot ( struct FString McpId, struct FString SaveSlotId );
	void OnRecordIapComplete ( struct FString McpId, struct FString SaveSlotId, TArray< struct FMcpIapItem > UpdatedItems, unsigned long bWasSuccessful, struct FString Error );
	void RecordIap ( struct FString McpId, struct FString SaveSlotId, struct FString Vendor, struct FString Receipt );
	void OnDeleteItemComplete ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, unsigned long bWasSuccessful, struct FString Error );
	void DeleteItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, int StoreVersion );
	void OnConsumeItemComplete ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, TArray< struct FString > UpdatedItemIds, unsigned long bWasSuccessful, struct FString Error );
	void ConsumeItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, int Quantity, int StoreVersion );
	void OnEarnItemComplete ( struct FString McpId, struct FString SaveSlotId, struct FString GlobalItemId, TArray< struct FString > UpdatedItemIds, unsigned long bWasSuccessful, struct FString Error );
	void EarnItem ( struct FString McpId, struct FString SaveSlotId, struct FString GlobalItemId, int Quantity, int StoreVersion );
	void OnSellItemComplete ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, TArray< struct FString > UpdatedItemIds, unsigned long bWasSuccessful, struct FString Error );
	void SellItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, int Quantity, int StoreVersion, TArray< struct FMcpInventoryItemContainer >* ExpectedResultItems );
	void OnPurchaseItemComplete ( struct FString McpId, struct FString SaveSlotId, struct FString GlobalItemId, TArray< struct FString > UpdatedItemIds, unsigned long bWasSuccessful, struct FString Error );
	void PurchaseItem ( struct FString McpId, struct FString SaveSlotId, struct FString GlobalItemId, TArray< struct FString > PurchaseItemIds, int Quantity, int StoreVersion, float Scalar );
	bool GetInventoryItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, struct FMcpInventoryItem* OutInventoryItem );
	void GetInventoryItems ( struct FString McpId, struct FString SaveSlotId, TArray< struct FMcpInventoryItem >* OutInventoryItems );
	void OnQueryInventoryItemsComplete ( struct FString McpId, struct FString SaveSlotId, unsigned long bWasSuccessful, struct FString Error );
	void QueryInventoryItems ( struct FString McpId, struct FString SaveSlotId );
	void OnQuerySaveSlotListComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	TArray< struct FString > GetSaveSlotList ( struct FString McpId );
	void QuerySaveSlotList ( struct FString McpId );
	void OnDeleteSaveSlotComplete ( struct FString McpId, struct FString SaveSlotId, unsigned long bWasSuccessful, struct FString Error );
	void DeleteSaveSlot ( struct FString McpId, struct FString SaveSlotId );
	void OnCreateSaveSlotComplete ( struct FString McpId, struct FString SaveSlotId, unsigned long bWasSuccessful, struct FString Error );
	void CreateSaveSlot ( struct FString McpId, struct FString SaveSlotId, struct FString ParentSaveSlotId );
	class UMcpUserInventoryBase* CreateInstance ( );
};



// Class IpDrv.McpUserInventoryManager ( Property size: 15 iter: 45) 
// Class name index: 30668 
// 0x00F0 (0x0238 - 0x0148)
class UMcpUserInventoryManager : public UMcpUserInventoryBase
{
public:
	struct FString                                     CreateSaveSlotUrl;                                		// 0x0148 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteSaveSlotUrl;                                		// 0x0158 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ListSaveSlotUrl;                                  		// 0x0168 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ListItemsUrl;                                     		// 0x0178 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     PurchaseItemUrl;                                  		// 0x0188 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     SellItemUrl;                                      		// 0x0198 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     EarnItemUrl;                                      		// 0x01A8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ConsumeItemUrl;                                   		// 0x01B8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteItemUrl;                                    		// 0x01C8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     IapRecordUrl;                                     		// 0x01D8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FMcpInventorySaveSlot >             SaveSlots;                                        		// 0x01E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserInventoryManager_FSaveSlotRequestState > SaveSlotRequests;                                 		// 0x01F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserInventoryManager_FSaveSlotRequestState > ListSaveSlotRequests;                             		// 0x0208 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserInventoryManager_FSaveSlotRequestState > ListItemsRequests;                                		// 0x0218 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FInventoryItemRequestState >        ItemRequests;                                     		// 0x0228 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 39550 ];

		return pClassPointer;
	};

	void OnRecordIapRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void RecordIap ( struct FString McpId, struct FString SaveSlotId, struct FString Vendor, struct FString Receipt );
	void OnDeleteItemRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, int StoreVersion );
	void OnConsumeItemRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ConsumeItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, int Quantity, int StoreVersion );
	void OnEarnItemRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void EarnItem ( struct FString McpId, struct FString SaveSlotId, struct FString GlobalItemId, int Quantity, int StoreVersion );
	void OnSellItemRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void SellItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, int Quantity, int StoreVersion, TArray< struct FMcpInventoryItemContainer >* ExpectedResultItems );
	void OnPurchaseItemRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void PurchaseItem ( struct FString McpId, struct FString SaveSlotId, struct FString GlobalItemId, TArray< struct FString > PurchaseItemIds, int Quantity, int StoreVersion, float Scalar );
	int FindItemRequest ( struct FString McpId, struct FString SaveSlotId, struct FString ItemId, TArray< struct FInventoryItemRequestState >* InItemRequests );
	int FindSaveSlotRequest ( struct FString McpId, struct FString SaveSlotId, TArray< struct UMcpUserInventoryManager_FSaveSlotRequestState >* InSaveSlotRequests );
	int FindSaveSlotIndex ( struct FString McpId, struct FString SaveSlotId );
	void ParseSaveSlotList ( struct FString McpId, struct FString JsonPayload );
	TArray< struct FString > ParseInventoryForSaveSlot ( struct FString McpId, struct FString SaveSlotId, struct FString JsonPayload );
	bool GetInventoryItem ( struct FString McpId, struct FString SaveSlotId, struct FString InstanceItemId, struct FMcpInventoryItem* OutInventoryItem );
	void GetInventoryItems ( struct FString McpId, struct FString SaveSlotId, TArray< struct FMcpInventoryItem >* OutInventoryItems );
	void OnQueryInventoryItemsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryInventoryItems ( struct FString McpId, struct FString SaveSlotId );
	TArray< struct FString > GetSaveSlotList ( struct FString McpId );
	void OnQuerySaveSlotListRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QuerySaveSlotList ( struct FString McpId );
	void OnDeleteSaveSlotRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteSaveSlot ( struct FString McpId, struct FString SaveSlotId );
	void OnCreateSaveSlotRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void CreateSaveSlot ( struct FString McpId, struct FString SaveSlotId, struct FString ParentSaveSlotId );
};



// Class IpDrv.McpUserInventoryManagerV3 ( Property size: 8 iter: 29) 
// Class name index: 30669 
// 0x0080 (0x01C8 - 0x0148)
class UMcpUserInventoryManagerV3 : public UMcpUserInventoryBase
{
public:
	struct FString                                     ProcessCommandUrl;                                		// 0x0148 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ProfileResourcePath;                              		// 0x0158 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     IapResourcePath;                                  		// 0x0168 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ProfileTemplateId;                                		// 0x0178 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FSaveSlotRequest >                  SaveSlotRequests;                                 		// 0x0188 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserInventoryManagerV3_FUserRequest > UserRequests;                                     		// 0x0198 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpInventorySaveSlot >             SaveSlots;                                        		// 0x01A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpIapList >                       IapLists;                                         		// 0x01B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 39825 ];

		return pClassPointer;
	};

	bool GetIapList ( struct FString McpId, struct FMcpIapList* Iaps );
	void ParseIapList ( struct FString McpId, class UJsonObject* ParsedJson );
	void OnQueryIapListRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryIapList ( struct FString McpId );
	bool GetSaveSlot ( struct FString McpId, struct FString SaveSlotId, struct FMcpInventorySaveSlot* SaveSlot );
	void ParseSaveSlot ( class UJsonObject* ParsedJson );
	void OnReadSaveSlotRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ReadSaveSlot ( struct FString McpId, struct FString SaveSlotId );
	TArray< struct FString > GetSaveSlotList ( struct FString McpId );
	void OnQuerySaveSlotsRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QuerySaveSlotList ( struct FString McpId );
	void OnRecordIapRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void RecordIap ( struct FString McpId, struct FString SaveSlotId, struct FString Vendor, struct FString Receipt );
	void OnDeleteSaveSlotRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteSaveSlot ( struct FString McpId, struct FString SaveSlotId );
	void OnCreateSaveSlotRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void CreateSaveSlot ( struct FString McpId, struct FString SaveSlotId, struct FString ParentSaveSlotId );
	struct FString BuildIapResourcePath ( struct FString McpId, struct FString ProfileId );
	struct FString BuildProfileResourcePath ( struct FString McpId, struct FString ProfileId );
};



// Class IpDrv.McpUserManager ( Property size: 12 iter: 29) 
// Class name index: 30670 
// 0x00C0 (0x0188 - 0x00C8)
class UMcpUserManager : public UMcpUserManagerBase
{
public:
	TArray< struct FMcpUserStatus >                    UserStatuses;                                     		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     RegisterUserMcpUrl;                               		// 0x00D8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     RegisterUserFacebookUrl;                          		// 0x00E8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryUserUrl;                                     		// 0x00F8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryUsersUrl;                                    		// 0x0108 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     DeleteUserUrl;                                    		// 0x0118 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     FacebookAuthUrl;                                  		// 0x0128 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     McpAuthUrl;                                       		// 0x0138 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< class UHttpRequestInterface* >             RegisterUserRequests;                             		// 0x0148 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UHttpRequestInterface* >             QueryUsersRequests;                               		// 0x0158 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserManager_FUserRequest >      DeleteUserRequests;                               		// 0x0168 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UHttpRequestInterface* >             AuthUserRequests;                                 		// 0x0178 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 40073 ];

		return pClassPointer;
	};

	void OnDeleteUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteUser ( struct FString McpId );
	bool GetUser ( struct FString McpId, struct FMcpUserStatus* User );
	void GetUsers ( TArray< struct FMcpUserStatus >* Users );
	void OnQueryUsersRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ParseUsers ( struct FString JsonPayload );
	void QueryUsers ( struct FString McpId, TArray< struct FString >* McpIds );
	void OnQueryUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryUser ( struct FString McpId, unsigned long bShouldUpdateLastActive );
	void OnAuthenticateUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AuthenticateUserMcp ( struct FString McpId, struct FString ClientSecret, struct FString UDID );
	void AuthenticateUserFacebook ( struct FString FacebookId, struct FString FacebookToken, struct FString UDID );
	void OnRegisterUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	int ParseUser ( struct FString JsonPayload );
	void RegisterUserFacebook ( struct FString FacebookId, struct FString FacebookAuthToken );
	void RegisterUserGenerated ( );
};



// Class IpDrv.McpUserManagerV3 ( Property size: 8 iter: 36) 
// Class name index: 30673 
// 0x0080 (0x0148 - 0x00C8)
class UMcpUserManagerV3 : public UMcpUserManagerBase
{
public:
	TArray< struct FMcpUserStatus >                    UserStatuses;                                     		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     AccountUrl;                                       		// 0x00D8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     AuthUrl;                                          		// 0x00E8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     QueryUrl;                                         		// 0x00F8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< class UHttpRequestInterface* >             RegisterUserRequests;                             		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UHttpRequestInterface* >             QueryUsersRequests;                               		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct UMcpUserManagerV3_FUserRequest >    DeleteUserRequests;                               		// 0x0128 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UHttpRequestInterface* >             AuthUserRequests;                                 		// 0x0138 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 40201 ];

		return pClassPointer;
	};

	void InjectUserCredentials ( struct FString McpId, struct FString ClientSecret, struct FString Token );
	struct FString GetAuthToken ( struct FString McpId );
	void OnDeleteUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void DeleteUser ( struct FString McpId );
	bool GetUserExternalAccountId ( struct FString McpId, struct FString ExternalAccountType, struct FString* ExternalAccountId );
	bool UserHasExternalAccount ( struct FString McpId, struct FString ExternalAccountType );
	bool GetUser ( struct FString McpId, struct FMcpUserStatus* User );
	void GetUsers ( TArray< struct FMcpUserStatus >* Users );
	void OnQueryUsersRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void ParseUsers ( struct FString JsonPayload );
	void QueryUsers ( struct FString McpId, TArray< struct FString >* McpIds );
	void OnQueryUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void QueryUser ( struct FString McpId, unsigned long bShouldUpdateLastActive );
	struct FString BuildJsonForIds ( TArray< struct FString >* McpIds );
	void OnAuthenticateUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	void AuthenticateUserMcp ( struct FString McpId, struct FString ClientSecret, struct FString UDID );
	void AuthenticateUserGameCenter ( struct FString GameCenterId );
	void AuthenticateUserGoogle ( struct FString GoogleId, struct FString GoogleAuthToken );
	void AuthenticateUserFacebook ( struct FString FacebookId, struct FString FacebookToken, struct FString UDID );
	void OnRegisterUserRequestComplete ( class UHttpRequestInterface* Request, class UHttpResponseInterface* Response, unsigned long bWasSuccessful );
	int ParseUser ( class UJsonObject* ParsedJson );
	void RegisterUserGoogle ( struct FString GoogleId, struct FString GoogleAuthToken );
	void RegisterUserGameCenter ( struct FString GameCenterId );
	void RegisterUserFacebook ( struct FString FacebookId, struct FString FacebookAuthToken );
	void RegisterExternalUserAccount ( struct FString ExternalId, struct FString Token, struct FString Type );
	struct FString BuildExternalOnlineAccountJSON ( struct FString Id, struct FString Type, struct FString Token );
	void RegisterUserGenerated ( );
};



// Class IpDrv.OnlineImageDownloaderWeb ( Property size: 3 iter: 14) 
// Class name index: 30816 
// 0x0024 (0x0084 - 0x0060)
class UOnlineImageDownloaderWeb : public UObject
{
public:
	TArray< struct FOnlineImageDownload >              DownloadImages;                                   		// 0x0060 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                MaxSimultaneousDownloads;                         		// 0x0070 (0x0004) [0x0000000000004000]              ( CPF_Config )
	struct FScriptDelegate                             __OnOnlineImageDownloaded__Delegate;              		// 0x0074 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0078 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41104 ];

		return pClassPointer;
	};

	void DebugDraw ( class UCanvas* Canvas );
	void OnDownloadComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* Response, unsigned long bDidSucceed );
	void DownloadNextImage ( );
	void ClearAllDownloads ( );
	void ClearDownloads ( TArray< struct FString > URLs );
	int GetNumPendingDownloads ( );
	void RequestOnlineImages ( TArray< struct FString > URLs );
	class UTexture* GetOnlineImageTexture ( struct FString URL );
	void OnOnlineImageDownloaded ( struct FOnlineImageDownload CachedEntry );
};



// Class IpDrv.TestClashMobManager ( Property size: 9 iter: 28) 
// Class name index: 31295 
// 0x00D0 (0x0130 - 0x0060)
class UTestClashMobManager : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UMcpClashMobBase*                            ClashMobManager;                                  		// 0x0068 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              TestUser;                                         		// 0x0074 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpClashMobChallengeEvent >        ChallengeEvents;                                  		// 0x00EC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                FileCount;                                        		// 0x00FC (0x0004) [0x0000000000000000]              
	struct FString                                     ParentId;                                         		// 0x0100 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ChildId;                                          		// 0x0110 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x0120 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0124 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41598 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUser ( );
	void OnQueryChallengeUserStatusComplete ( unsigned long bWasSuccessful, struct FString ChallengeId, struct FString McpId, struct FString Error );
	void QueryUserStatus ( );
	void OnUpdateChallengeUserRewardComplete ( unsigned long bWasSuccessful, struct FString ChallengeId, struct FString McpId, struct FString Error );
	void UpdateReward ( );
	void OnUpdateChallengeUserProgressComplete ( unsigned long bWasSuccessful, struct FString ChallengeId, struct FString McpId, struct FString Error );
	void UpdateProgress ( );
	void OnAcceptChallengeComplete ( unsigned long bWasSuccessful, struct FString ChallengeId, struct FString McpId, struct FString Error );
	void AcceptClashMob ( );
	void OnDownloadChallengeFileComplete ( unsigned long bWasSuccessful, struct FString ChallengeId, struct FString DLName, struct FString Filename, struct FString ErrorString );
	void DownloadChallengeFiles ( );
	void OnQueryChallengeListComplete ( unsigned long bWasSuccessful, struct FString Error );
	void QueryClashMobs ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void CreateUserForTest ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UMcpClashMobBase* ClashMobMan, struct FString InParentId, struct FString InChildId );
};



// Class IpDrv.TestMcpGroups ( Property size: 9 iter: 28) 
// Class name index: 31298 
// 0x01D4 (0x0234 - 0x0060)
class UTestMcpGroups : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UMcpGroupsBase*                              GroupManager;                                     		// 0x0068 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              TestUser1;                                        		// 0x0074 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpUserStatus                              TestUser2;                                        		// 0x00EC (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpUserStatus                              TestUser3;                                        		// 0x0164 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                UserCreatedCount;                                 		// 0x01DC (0x0004) [0x0000000000000000]              
	struct FMcpGroup                                   TestGroup;                                        		// 0x01E0 (0x0044) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x0224 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0228 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41665 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUsers ( );
	void OnDeleteGroupComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void DeleteGroup ( );
	void OnQueryGroupsComplete ( struct FString UserId, unsigned long bWasSuccessful, struct FString Error );
	void QueryGroups ( );
	void OnRemoveGroupMembersComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void RemoveMembers ( );
	void OnQueryGroupMembersComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void QueryGroupMembers ( );
	void OnAddGroupMembersComplete ( struct FString GroupID, unsigned long bWasSuccessful, struct FString Error );
	void AddMembers ( );
	void OnCreateGroupComplete ( struct FMcpGroup Group, unsigned long bWasSuccessful, struct FString Error );
	void CreateGroup ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void RegisterUsers ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UMcpGroupsBase* GroupMan );
};



// Class IpDrv.TestMcpIdMapping ( Property size: 11 iter: 22) 
// Class name index: 31299 
// 0x0258 (0x02B8 - 0x0060)
class UTestMcpIdMapping : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UMcpIdMappingBase*                           IdMappingManager;                                 		// 0x0068 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              TestUser1;                                        		// 0x0074 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpUserStatus                              TestUser2;                                        		// 0x00EC (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpUserStatus                              TestUser3;                                        		// 0x0164 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                UserCreatedCount;                                 		// 0x01DC (0x0004) [0x0000000000000000]              
	struct FMcpIdMapping                               TestMapping[ 0x3 ];                               		// 0x01E0 (0x00C0) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                MappingsCreatedCount;                             		// 0x02A0 (0x0004) [0x0000000000000000]              
	int                                                MappingsQueriedCount;                             		// 0x02A4 (0x0004) [0x0000000000000000]              
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x02A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x02AC (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41731 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUsers ( );
	void OnQueryMappingsComplete ( struct FString ExternalType, unsigned long bWasSuccessful, struct FString Error );
	void QueryAccountMappings ( );
	void OnAddMappingComplete ( struct FString McpId, struct FString ExternalId, struct FString ExternalType, unsigned long bWasSuccessful, struct FString Error );
	void CreateAccountMappings ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void RegisterUsers ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UMcpIdMappingBase* IdMappingMan );
};



// Class IpDrv.TestMcpLeaderboards ( Property size: 5 iter: 18) 
// Class name index: 31300 
// 0x009C (0x00FC - 0x0060)
class UTestMcpLeaderboards : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UMcpLeaderboardsBase*                        LeaderboardManager;                               		// 0x0068 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              InternalAuthUser;                                 		// 0x0074 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x00EC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00F0 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41779 ];

		return pClassPointer;
	};

	void OnReadLeaderboardByColumnComplete ( unsigned long bWasSuccessful, struct FString Error, struct FString LeaderboardName, unsigned char Timeframe );
	void ReadLeaderboardByColumn ( );
	void OnReadLeaderboardEntriesComplete ( unsigned long bWasSuccessful, struct FString Error, struct FString LeaderboardName, unsigned char Timeframe );
	void ReadLeaderboardEntry ( );
	void OnWriteLeaderboardEntryComplete ( unsigned long bWasSuccessful, struct FString Error, struct FString McpId, struct FString LeaderboardName );
	void WriteLeaderboardEntry ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void CreateUser ( );
	void OnReadLeaderboardsComplete ( unsigned long bWasSuccessful, struct FString Error );
	void ReadLeaderboards ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UMcpLeaderboardsBase* LeaderboardMan );
	void Done ( );
};



// Class IpDrv.TestMcpManager ( Property size: 21 iter: 55) 
// Class name index: 31301 
// 0x00B8 (0x0138 - 0x0080)
class UTestMcpManager : public UCheatManager
{
public:
	class UTestMcpUser*                                UserTest;                                         		// 0x0080 (0x0008) [0x0000000000000000]              
	class UTestMcpGroups*                              GroupsTest;                                       		// 0x0088 (0x0008) [0x0000000000000000]              
	class UTestMcpIdMapping*                           IdMappingTest;                                    		// 0x0090 (0x0008) [0x0000000000000000]              
	class UTestMcpMessaging*                           MessagingTest;                                    		// 0x0098 (0x0008) [0x0000000000000000]              
	class UTestMcpUserInventory*                       InventoryTest;                                    		// 0x00A0 (0x0008) [0x0000000000000000]              
	class UTestMcpSystemFileManager*                   SystemFileTest;                                   		// 0x00A8 (0x0008) [0x0000000000000000]              
	class UTestMcpUserFileManager*                     UserFileTest;                                     		// 0x00B0 (0x0008) [0x0000000000000000]              
	class UTestClashMobManager*                        ClashMobTest;                                     		// 0x00B8 (0x0008) [0x0000000000000000]              
	class UTestMcpThreadedChat*                        ChatTest;                                         		// 0x00C0 (0x0008) [0x0000000000000000]              
	class UTestMcpLeaderboards*                        LeaderboardsTest;                                 		// 0x00C8 (0x0008) [0x0000000000000000]              
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x00D0 (0x0008) [0x0000000000000000]              
	class UMcpGroupsBase*                              GroupManager;                                     		// 0x00D8 (0x0008) [0x0000000000000000]              
	class UMcpIdMappingBase*                           IdManagerManager;                                 		// 0x00E0 (0x0008) [0x0000000000000000]              
	class UMcpMessageBase*                             MessagingManager;                                 		// 0x00E8 (0x0008) [0x0000000000000000]              
	class UMcpServerTimeBase*                          ServerTimeManager;                                		// 0x00F0 (0x0008) [0x0000000000000000]              
	class UMcpUserInventoryBase*                       InventoryManager;                                 		// 0x00F8 (0x0008) [0x0000000000000000]              
	class UOnlineTitleFileInterface*                   TitleFileManager;                                 		// 0x0100 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0108 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	class UUserCloudFileInterface*                     UserFileManager;                                  		// 0x0110 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData01[ 0x8 ];                             		// 0x0118 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	class UMcpClashMobBase*                            ClashMobManager;                                  		// 0x0120 (0x0008) [0x0000000000000000]              
	class UMcpThreadedChatBase*                        ChatManager;                                      		// 0x0128 (0x0008) [0x0000000000000000]              
	class UMcpLeaderboardsBase*                        LeaderboardManager;                               		// 0x0130 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41836 ];

		return pClassPointer;
	};

	void OnLeaderboardTestsComplete ( );
	void RunLeaderboardTests ( );
	void OnChatTestsComplete ( );
	void RunChatTests ( );
	void OnClashMobTestsComplete ( );
	void RunClashMobTests ( struct FString ParentId, struct FString ChildId );
	void OnUserFileTestsComplete ( );
	void RunUserCloudFileTests ( );
	void OnSystemFileTestsComplete ( );
	void RunSystemCloudFileTests ( );
	void OnInventoryTestsComplete ( );
	void RunInventoryTests ( );
	void OnQueryServerTimeComplete ( unsigned long bWasSuccessful, struct FString DateTimeStr, struct FString Error );
	void RunServerTimeTest ( );
	void RunBase64Tests ( );
	void OnMessagingTestsComplete ( );
	void RunMessagingTests ( );
	void OnIdMappingTestsComplete ( );
	void RunIdMappingTests ( );
	void OnGroupTestsComplete ( );
	void RunGroupTests ( );
	void OnUserTestsComplete ( );
	void RunUserTests ( );
	class UMcpLeaderboardsBase* GetLeaderboardManager ( );
	class UMcpThreadedChatBase* GetChatManager ( );
	class UMcpClashMobBase* GetClashMobManager ( );
	class UUserCloudFileInterface* GetUserFileManager ( );
	class UOnlineTitleFileInterface* GetTitleFileManager ( );
	class UMcpUserInventoryBase* GetInventoryManager ( );
	class UMcpServerTimeBase* GetServerTimeManager ( );
	class UMcpMessageBase* GetMessagingManager ( );
	class UMcpIdMappingBase* GetIdMappingManager ( );
	class UMcpGroupsBase* GetGroupManager ( );
	class UMcpUserManagerBase* GetUserManager ( );
};



// Class IpDrv.TestMcpThreadedChat ( Property size: 15 iter: 46) 
// Class name index: 31304 
// 0x0224 (0x0284 - 0x0060)
class UTestMcpThreadedChat : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UMcpThreadedChatBase*                        ChatManager;                                      		// 0x0068 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              TestUsers[ 0x3 ];                                 		// 0x0074 (0x0168) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                UserCreatedCount;                                 		// 0x01DC (0x0004) [0x0000000000000000]              
	TArray< struct FMcpSystemChatThread >              SystemChatThreads;                                		// 0x01E0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     SystemThreadId;                                   		// 0x01F0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     SystemPostId[ 0x2 ];                              		// 0x0200 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                SystemPostCount;                                  		// 0x0220 (0x0004) [0x0000000000000000]              
	TArray< struct FMcpUserChatThread >                UserChatThreads;                                  		// 0x0224 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     UserThreadId;                                     		// 0x0234 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     UserPostId;                                       		// 0x0244 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChatPost >                      SystemChatPosts;                                  		// 0x0254 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChatPost >                      UserChatPosts;                                    		// 0x0264 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x0274 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0278 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41908 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserDataComplete ( unsigned long bWasSuccessful, struct FString McpId, struct FString Error );
	void DeleteUserData ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUsers ( );
	void OnReadUserChatPostsByPopularityComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString Error );
	void GetPostsForUserThreadByPopularity ( );
	void OnReadUserChatPostsComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString Error );
	void GetPostsForUserThread ( );
	void OnReadSystemChatPostsByPopularityComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString Error );
	void GetPostsForSystemThreadByPopularity ( );
	void OnReadSystemChatPostsComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString Error );
	void GetPostsForSystemThread ( );
	void OnVoteDownPostComplete ( unsigned long bWasSuccessful, struct FString PostId, struct FString Error );
	void VoteDownPost ( );
	void OnPostToUserThreadComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString McpId, struct FString Error );
	void PostToUserThread ( );
	void OnCreateUserChatThreadComplete ( unsigned long bWasSuccessful, struct FString McpId, struct FString ThreadName, struct FString Error );
	void CreateUserThread ( );
	void OnReportPostComplete ( unsigned long bWasSuccessful, struct FString PostId, struct FString Error );
	void ReportPost ( );
	void OnVoteUpPostComplete ( unsigned long bWasSuccessful, struct FString PostId, struct FString Error );
	void VoteUpPost ( );
	void OnPostToThreadComplete ( unsigned long bWasSuccessful, struct FString ThreadId, struct FString McpId, struct FString Error );
	void PostToSystemChatThread ( );
	void OnReadSystemChatThreadsComplete ( unsigned long bWasSuccessful, struct FString Error );
	void ReadSystemChatThreads ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void CreateUsersForTest ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UMcpThreadedChatBase* ChatMan );
};



// Class IpDrv.TestMcpUserFileManager ( Property size: 6 iter: 23) 
// Class name index: 31306 
// 0x00B4 (0x0114 - 0x0060)
class UTestMcpUserFileManager : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UUserCloudFileInterface*                     UserFileManager;                                  		// 0x0068 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0070 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	int                                                TestState;                                        		// 0x0078 (0x0004) [0x0000000000000000]              
	TArray< struct FEmsFile >                          UserFiles;                                        		// 0x007C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpUserStatus                              TestUser;                                         		// 0x008C (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x0104 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0108 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41910 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUser ( );
	void OnDeleteUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void DeleteFileForUser ( );
	void OnReadLastNOwnersComplete ( unsigned long bWasSuccessful );
	void ReadLastNOwners ( );
	void OnReadUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void ReadFileForUser ( );
	void OnEnumerateUserFilesComplete ( unsigned long bWasSuccessful, struct FString UserId );
	void EnumerateFilesForUser ( );
	void OnWriteUserFileComplete ( unsigned long bWasSuccessful, struct FString UserId, struct FString Filename );
	void WriteFileForUser ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void CreateUserForTest ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UUserCloudFileInterface* UserFileMan );
};



// Class IpDrv.TestMcpSystemFileManager ( Property size: 5 iter: 12) 
// Class name index: 31303 
// 0x0038 (0x0098 - 0x0060)
class UTestMcpSystemFileManager : public UObject
{
public:
	class UOnlineTitleFileInterface*                   SystemFileManager;                                		// 0x0060 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0068 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	TArray< struct FEmsFile >                          FileList;                                         		// 0x0074 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                FilesRead;                                        		// 0x0084 (0x0004) [0x0000000000000000]              
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x008C (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41912 ];

		return pClassPointer;
	};

	void Done ( );
	void OnReadTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
	void ReadFiles ( );
	void OnRequestTitleFileListComplete ( unsigned long bWasSuccessful, struct FString Error );
	void ReadTitleFileList ( );
	void RunNextTest ( );
	void Init ( class UOnlineTitleFileInterface* SystemFileMan );
};



// Class IpDrv.TestMcpUserInventory ( Property size: 5 iter: 18) 
// Class name index: 31307 
// 0x009C (0x00FC - 0x0060)
class UTestMcpUserInventory : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UMcpUserInventoryBase*                       InventoryManager;                                 		// 0x0068 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              TestUser;                                         		// 0x0074 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x00EC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x00F0 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41914 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUser ( );
	void OnDeleteSaveSlotComplete ( struct FString McpId, struct FString SaveSlotId, unsigned long bWasSuccessful, struct FString Error );
	void DeleteSaveSlot ( );
	void OnRecordIapComplete ( struct FString McpId, struct FString SaveSlotId, TArray< struct FMcpIapItem > UpdatedItemIds, unsigned long bWasSuccessful, struct FString Error );
	void RecordIap ( );
	void OnCreateSaveSlotComplete ( struct FString McpId, struct FString SaveSlotId, unsigned long bWasSuccessful, struct FString Error );
	void CreateSaveSlot ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void CreateUserForTest ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UMcpUserInventoryBase* InventoryMan );
};



// Class IpDrv.TestMcpMessaging ( Property size: 7 iter: 22) 
// Class name index: 31302 
// 0x01F4 (0x0254 - 0x0060)
class UTestMcpMessaging : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	class UMcpMessageBase*                             MsgManager;                                       		// 0x0068 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0070 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              TestUsers[ 0x3 ];                                 		// 0x0074 (0x0168) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                UserCreatedCount;                                 		// 0x01DC (0x0004) [0x0000000000000000]              
	struct FMcpMessage                                 TestMessage;                                      		// 0x01E0 (0x0064) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x0244 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0248 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41916 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUsers ( );
	void OnDeleteMessageComplete ( struct FString MessageId, unsigned long bWasSuccessful, struct FString Error );
	void DeleteMessage ( );
	void OnQueryMessageContentsComplete ( struct FString MessageId, unsigned long bWasSuccessful, struct FString Error );
	void QueryMessageContents ( );
	void OnQueryMessagesComplete ( struct FString UserId, unsigned long bWasSuccessful, struct FString Error );
	void QueryMessages ( );
	void OnCreateMessageComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void SendMessage ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void CreateUsersForTest ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan, class UMcpMessageBase* MsgMan );
};



// Class IpDrv.TestMcpUser ( Property size: 8 iter: 29) 
// Class name index: 31305 
// 0x013C (0x019C - 0x0060)
class UTestMcpUser : public UObject
{
public:
	class UMcpUserManagerBase*                         UserManager;                                      		// 0x0060 (0x0008) [0x0000000000000000]              
	int                                                TestState;                                        		// 0x0068 (0x0004) [0x0000000000000000]              
	struct FMcpUserStatus                              InternalAuthUser;                                 		// 0x006C (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpUserStatus                              ExternalAuthUser;                                 		// 0x00E4 (0x0078) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     FacebookId;                                       		// 0x015C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     FacebookToken;                                    		// 0x016C (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     GameCenterId;                                     		// 0x017C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __Done__Delegate;                                 		// 0x018C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0190 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 41918 ];

		return pClassPointer;
	};

	void Done ( );
	void OnDeleteUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void DeleteUser ( );
	void OnQueryUsersComplete ( unsigned long bWasSuccessful, struct FString Error );
	void QueryUsers ( );
	void OnQueryUserComplete ( unsigned long bWasSuccessful, struct FString Error );
	void QueryUser ( );
	void OnAuthUserGameCenterComplete ( struct FString McpId, struct FString Token, unsigned long bWasSuccessful, struct FString Error );
	void AuthUserGameCenter ( );
	void OnRegisterUserGameCenterComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void RegisterUserGameCenter ( );
	void OnAuthUserFacebookComplete ( struct FString McpId, struct FString Token, unsigned long bWasSuccessful, struct FString Error );
	void AuthUserFacebook ( );
	void OnRegisterUserFacebookComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void RegisterUserFacebook ( );
	void OnAuthUserComplete ( struct FString McpId, struct FString Token, unsigned long bWasSuccessful, struct FString Error );
	void AuthUserGenerated ( );
	void OnRegisterUserComplete ( struct FString McpId, unsigned long bWasSuccessful, struct FString Error );
	void RegisterUserGenerated ( );
	void RunNextTest ( );
	void Init ( class UMcpUserManagerBase* UserMan );
};



// Class IpDrv.WebConnection ( Property size: 10 iter: 23) 
// Class name index: 31445 
// 0x0044 (0x02DC - 0x0298)
class AWebConnection : public ATcpLink
{
public:
	class AWebServer*                                  WebServer;                                        		// 0x0298 (0x0008) [0x0000000000000000]              
	struct FString                                     ReceivedData;                                     		// 0x02A0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UWebRequest*                                 Request;                                          		// 0x02B0 (0x0008) [0x0000000000000000]              
	class UWebResponse*                                Response;                                         		// 0x02B8 (0x0008) [0x0000000000000000]              
	class UWebApplication*                             Application;                                      		// 0x02C0 (0x0008) [0x0000000000000000]              
	unsigned long                                      bDelayCleanup : 1;                                		// 0x02C8 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                RawBytesExpecting;                                		// 0x02CC (0x0004) [0x0000000000000000]              
	int                                                MaxValueLength;                                   		// 0x02D0 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                MaxLineLength;                                    		// 0x02D4 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                ConnID;                                           		// 0x02D8 (0x0004) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 42350 ];

		return pClassPointer;
	};

	bool IsHanging ( );
	void Cleanup ( );
	void CheckRawBytes ( );
	void EndOfHeaders ( );
	void CreateResponseObject ( );
	void ProcessPost ( struct FString S );
	void ProcessGet ( struct FString S );
	void ProcessHead ( struct FString S );
	void ReceivedLine ( struct FString S );
	void eventReceivedText ( struct FString Text );
	void eventTimer ( );
	void eventClosed ( );
	void eventAccepted ( );
};




#ifdef _MSC_VER
	#pragma pack ( pop )
#endif