#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: WinDrv_classes.h
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

// Class WinDrv.FacebookWindows ( Property size: 3 iter: 14) 
// Class name index: 7817 
// 0x0020 (0x0100 - 0x00E0)
class UFacebookWindows : public UFacebookIntegration
{
public:
	struct FPointer                                    VfTable_FTickableObject;                          		// 0x00E0 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	struct FString                                     PreviousAccessToken;                              		// 0x00E8 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FPointer                                    ChildProcHandle;                                  		// 0x00F8 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3064 ];

		return pClassPointer;
	};

	void OnFacebookFriendsRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* Response, unsigned long bDidSucceed );
	void eventRequestFacebookFriends ( );
	void OnFacebookMeRequestComplete ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* Response, unsigned long bDidSucceed );
	void eventRequestFacebookMeInfo ( );
	void FacebookRequestCallback ( class UHttpRequestInterface* OriginalRequest, class UHttpResponseInterface* Response, unsigned long bDidSucceed );
	void ProcessFacebookRequest ( struct FString Payload, int ResponseCode );
	void FacebookRequest ( struct FString GraphRequest );
	void Disconnect ( );
	bool IsAuthorized ( );
	bool Authorize ( );
	bool Init ( );
};



// Class WinDrv.HttpRequestWindows ( Property size: 4 iter: 18) 
// Class name index: 7819 
// 0x0030 (0x00A0 - 0x0070)
class UHttpRequestWindows : public UHttpRequestInterface
{
public:
	struct FPointer                                    Request;                                          		// 0x0070 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	struct FString                                     RequestVerb;                                      		// 0x0078 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	struct FPointer                                    RequestURL;                                       		// 0x0088 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	TArray< unsigned char >                            Payload;                                          		// 0x0090 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3066 ];

		return pClassPointer;
	};

	bool ProcessRequest ( );
	class UHttpRequestInterface* SetHeader ( struct FString HeaderName, struct FString HeaderValue );
	class UHttpRequestInterface* SetContentAsString ( struct FString ContentString );
	class UHttpRequestInterface* SetContent ( TArray< unsigned char >* ContentPayload );
	class UHttpRequestInterface* SetURL ( struct FString URL );
	class UHttpRequestInterface* SetVerb ( struct FString Verb );
	struct FString GetVerb ( );
	void GetContent ( TArray< unsigned char >* Content );
	struct FString GetURL ( );
	int GetContentLength ( );
	struct FString GetContentType ( );
	struct FString GetURLParameter ( struct FString ParameterName );
	TArray< struct FString > GetHeaders ( );
	struct FString GetHeader ( struct FString HeaderName );
};



// Class WinDrv.HttpResponseWindows ( Property size: 2 iter: 11) 
// Class name index: 7821 
// 0x0018 (0x0078 - 0x0060)
class UHttpResponseWindows : public UHttpResponseInterface
{
public:
	struct FPointer                                    Response;                                         		// 0x0060 (0x0008) [0x0000000000003002]              ( CPF_Const | CPF_Native | CPF_Transient )
	TArray< unsigned char >                            Payload;                                          		// 0x0068 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3068 ];

		return pClassPointer;
	};

	int GetResponseCode ( );
	struct FString GetContentAsString ( );
	void GetContent ( TArray< unsigned char >* Content );
	struct FString GetURL ( );
	int GetContentLength ( );
	struct FString GetContentType ( );
	struct FString GetURLParameter ( struct FString ParameterName );
	TArray< struct FString > GetHeaders ( );
	struct FString GetHeader ( struct FString HeaderName );
};



// Class WinDrv.SwrveAnalyticsWindows ( Property size: 0 iter: 0) 
// Class name index: 7823 
// 0x0048 (0x00E0 - 0x0098)
class USwrveAnalyticsWindows : public UAnalyticEventsBase
{
public:
//	 LastOffset: 98
//	 Class Propsize: e0
	unsigned char                                      UnknownData00[ 0x48 ];                            		// 0x0098 (0x0048) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3070 ];

		return pClassPointer;
	};

};



// Class WinDrv.WindowsClient ( Property size: 2 iter: 2) 
// Class name index: 7825 
// 0x01C0 (0x0238 - 0x0078)
class UWindowsClient : public UClient
{
public:
	unsigned char                                      UnknownData00[ 0x16C ];                           		// 0x0078 (0x016C) MISSED OFFSET
	class UClass*                                      AudioDeviceClass;                                 		// 0x01E4 (0x0008) [0x0000000000004000]              ( CPF_Config )
	unsigned char                                      UnknownData01[ 0x38 ];                            		// 0x01EC (0x0038) MISSED OFFSET
	int                                                AllowJoystickInput;                               		// 0x0224 (0x0004) [0x0000000000004000]              ( CPF_Config )
//	 LastOffset: 228
//	 Class Propsize: 238
	unsigned char                                      UnknownData02[ 0x10 ];                            		// 0x0228 (0x0010) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3072 ];

		return pClassPointer;
	};

};



// Class WinDrv.XnaForceFeedbackManager ( Property size: 0 iter: 0) 
// Class name index: 7828 
// 0x0000 (0x0080 - 0x0080)
class UXnaForceFeedbackManager : public UForceFeedbackManager
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3076 ];

		return pClassPointer;
	};

};



// Class WinDrv.HttpRequestWindowsMcp ( Property size: 2 iter: 3) 
// Class name index: 31460 
// 0x0020 (0x00C0 - 0x00A0)
class UHttpRequestWindowsMcp : public UHttpRequestWindows
{
public:
	struct FString                                     AppID;                                            		// 0x00A0 (0x0010) [0x0000000000404002]              ( CPF_Const | CPF_Config | CPF_NeedCtorLink )
	struct FString                                     AppSecret;                                        		// 0x00B0 (0x0010) [0x0000000000404002]              ( CPF_Const | CPF_Config | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 42610 ];

		return pClassPointer;
	};

	bool ProcessRequest ( );
};




#ifdef _MSC_VER
	#pragma pack ( pop )
#endif