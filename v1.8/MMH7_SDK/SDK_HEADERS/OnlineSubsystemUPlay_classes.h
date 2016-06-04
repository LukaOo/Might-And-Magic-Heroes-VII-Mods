#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: OnlineSubsystemUPlay_classes.h
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

// Enum OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.UPlayMessageType
/*enum UPlayMessageType
{
	UPlay_Message_UserConnectionLost                   = 0,
	UPlay_Message_UserAccountSharing                   = 1,
	UPlay_Message_ServerConnectionLost                 = 2,
	UPlay_Message_ServicesConnectionLost               = 3,
	UPlay_Event_Exit                                   = 4,
	UPlay_MAX                                          = 5
};*/

// Enum OnlineSubsystemUPlay.StormManager.NatTypeFriendly
/*enum NatTypeFriendly
{
	NTF_UNKNOWN                                        = 0,
	NTF_STRICT                                         = 1,
	NTF_MODERATE                                       = 2,
	NTF_OPEN                                           = 3,
	NTF_MAX                                            = 4
};*/

// Enum OnlineSubsystemUPlay.RDVAsyncTask.ERDVTaskType
/*enum ERDVTaskType
{
	ERDVTaskType_Login                                 = 0,
	ERDVTaskType_RegisterURLs                          = 1,
	ERDVTaskType_CreateSession                         = 2,
	ERDVTaskType_SearchSessions                        = 3,
	ERDVTaskType_Join                                  = 4,
	ERDVTaskType_AddParticipants                       = 5,
	ERDVTaskType_Leave                                 = 6,
	ERDVTaskType_RemoveParticipants                    = 7,
	ERDVTaskType_AbandonSession                        = 8,
	ERDVTaskType_UpdateSession                         = 9,
	ERDVTaskType_MAX                                   = 10
};*/


/*
# ========================================================================================= #
# Classes
# ========================================================================================= #
*/

// Class OnlineSubsystemUPlay.OnlineGameInterfaceUPlay ( Property size: 12 iter: 33) 
// Class name index: 7831 
// 0x0078 (0x02D0 - 0x0258)
class UOnlineGameInterfaceUPlay : public UOnlineGameInterfaceImpl
{
public:
	class UOnlineGameSettings*                         PreparedGameSettings;                             		// 0x0258 (0x0008) [0x0000000000000000]              
	struct FPointer                                    mGameSessionClient;                               		// 0x0260 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class URDVAsyncTaskManager*                        mAsyncTaskManager;                                		// 0x0268 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mGameSessionKey;                                  		// 0x0270 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mSearchResults;                                   		// 0x0278 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FName                                       mSessionName;                                     		// 0x0280 (0x0008) [0x0000000000001000]              ( CPF_Native )
	unsigned long                                      mRDVSessionPublished : 1;                         		// 0x0288 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      mCurrentPublishedNatType;                         		// 0x028C (0x0001) [0x0000000000001000]              ( CPF_Native )
	TArray< struct FScriptDelegate >                   UPlayMessageDelegates;                            		// 0x0290 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   UPlayInviteDelegates;                             		// 0x02A0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnUPlayMessage__Delegate;                       		// 0x02B0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x02B4 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnUPlayInvite__Delegate;                        		// 0x02C0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x02C4 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3079 ];

		return pClassPointer;
	};

	bool UpdateOnlineGame ( struct FName SessionName, class UOnlineGameSettings* UpdatedGameSettings, unsigned long bShouldRefreshOnlineData );
	void TriggerServicesUnavailable ( unsigned long showMessage );
	void LeaveOnlineGameCompleted ( class URDVAsyncTask* task );
	void LeaveOnlineGame ( struct FName SessionName );
	void DestroyInternetGameCompleted ( class URDVAsyncTask* task );
	void UpdateSessionCompleted ( class URDVAsyncTask* task );
	void JoinInternetGameByInvite ( int SessionId );
	void JoinInternetGameCompleted ( class URDVAsyncTask* task );
	void SearchSessionsCompleted ( class URDVAsyncTask* task );
	void OnAddHostParticipantCompleted ( class URDVAsyncTask* task );
	void OnCreateSessionCompleted ( class URDVAsyncTask* task );
	void Init ( struct FPointer gameSessionClient, class URDVAsyncTaskManager* asyncTaskManager );
	void ShowUPlayMessage ( unsigned char MessageType );
	void ClearUPlayInviteDelegate ( struct FScriptDelegate UplayInviteDelegate );
	void AddUPlayInviteDelegate ( struct FScriptDelegate UplayInviteDelegate );
	void ClearUPlayMessageDelegate ( struct FScriptDelegate UplayMessageDelegate );
	void AddUPlayMessageDelegate ( struct FScriptDelegate UplayMessageDelegate );
	void OnUPlayInvite ( int SessionId );
	void OnUPlayMessage ( unsigned char MessageType );
};



// Class OnlineSubsystemUPlay.OnlineSubsystemUPlay ( Property size: 59 iter: 261) 
// Class name index: 7830 
// 0x0334 (0x0514 - 0x01E0)
class UOnlineSubsystemUPlay : public UOnlineSubsystemCommonImpl
{
public:
	unsigned long                                      InviteDelayed : 1;                                		// 0x01E0 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      IsWaitingForStormData : 1;                        		// 0x01E0 (0x0004) [0x0000000000000000] [0x00000002] 
	int                                                InviteGameId;                                     		// 0x01E4 (0x0004) [0x0000000000000000]              
	class UUbiservicesManager*                         mUbiManager;                                      		// 0x01E8 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class URDVManager*                                 mRDVManager;                                      		// 0x01F0 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UUPlayEventManager*                          mEventManager;                                    		// 0x01F8 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UOnlineGameInterfaceUPlay*                   mCachedGameInterface;                             		// 0x0200 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mOverlayOverlapped;                               		// 0x0208 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mUSteamAchievementManager;                        		// 0x0210 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mUSteamWorkshopManager;                           		// 0x0218 (0x0008) [0x0000000000001000]              ( CPF_Native )
	TArray< int >                                      mTemporaryPrivileges;                             		// 0x0220 (0x0010) [0x0000000000001000]              ( CPF_Native )
	struct FString                                     LoggedInPlayerName;                               		// 0x0230 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	struct FUniqueNetId                                LoggedInPlayerId;                                 		// 0x0240 (0x0008) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     ProfileDataDirectory;                             		// 0x0248 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     ProfileDataExtension;                             		// 0x0258 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ReadProfileSettingsDelegates;                     		// 0x0268 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   WriteProfileSettingsDelegates;                    		// 0x0278 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UOnlineProfileSettings*                      CachedProfile;                                    		// 0x0288 (0x0008) [0x0000000000000000]              
	TArray< struct FScriptDelegate >                   SpeechRecognitionCompleteDelegates;               		// 0x0290 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   ReadFriendsDelegates;                             		// 0x02A0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   FriendsChangeDelegates;                           		// 0x02B0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FScriptDelegate >                   MutingChangeDelegates;                            		// 0x02C0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UWorkshopControllerInterfaceUPlay* > WorkshopItemControllers;                          		// 0x02D0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      LoggedInStatus;                                   		// 0x02E0 (0x0001) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     TitleFileClassName;                               		// 0x02E4 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     TitleFileCacheClassName;                          		// 0x02F4 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FString                                     UserCloudFileClassName;                           		// 0x0304 (0x0010) [0x0000000000404000]              ( CPF_Config | CPF_NeedCtorLink )
	struct FScriptDelegate                             __OnLoginChange__Delegate;                        		// 0x0314 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0318 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnLoginCancelled__Delegate;                     		// 0x0324 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0328 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnMutingChange__Delegate;                       		// 0x0334 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0338 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadTitleFileComplete__Delegate;              		// 0x0344 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData03[ 0x4 ];                             		// 0x0348 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnPlayerTalkingStateChange__Delegate;           		// 0x0354 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData04[ 0x4 ];                             		// 0x0358 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnFriendsChange__Delegate;                      		// 0x0364 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData05[ 0x4 ];                             		// 0x0368 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnLoginFailed__Delegate;                        		// 0x0374 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData06[ 0x4 ];                             		// 0x0378 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnLogoutCompleted__Delegate;                    		// 0x0384 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData07[ 0x4 ];                             		// 0x0388 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadProfileSettingsComplete__Delegate;        		// 0x0394 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData08[ 0x4 ];                             		// 0x0398 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnWriteProfileSettingsComplete__Delegate;       		// 0x03A4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData09[ 0x4 ];                             		// 0x03A8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnLoginStatusChange__Delegate;                  		// 0x03B4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData10[ 0x4 ];                             		// 0x03B8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadFriendsComplete__Delegate;                		// 0x03C4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData11[ 0x4 ];                             		// 0x03C8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnRecognitionComplete__Delegate;                		// 0x03D4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData12[ 0x4 ];                             		// 0x03D8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadOnlineStatsComplete__Delegate;            		// 0x03E4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData13[ 0x4 ];                             		// 0x03E8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnFlushOnlineStatsComplete__Delegate;           		// 0x03F4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData14[ 0x4 ];                             		// 0x03F8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnRegisterHostStatGuidComplete__Delegate;       		// 0x0404 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData15[ 0x4 ];                             		// 0x0408 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnLinkStatusChange__Delegate;                   		// 0x0414 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData16[ 0x4 ];                             		// 0x0418 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnExternalUIChange__Delegate;                   		// 0x0424 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData17[ 0x4 ];                             		// 0x0428 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnControllerChange__Delegate;                   		// 0x0434 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData18[ 0x4 ];                             		// 0x0438 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnConnectionStatusChange__Delegate;             		// 0x0444 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData19[ 0x4 ];                             		// 0x0448 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnStorageDeviceChange__Delegate;                		// 0x0454 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData20[ 0x4 ];                             		// 0x0458 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnKeyboardInputComplete__Delegate;              		// 0x0464 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData21[ 0x4 ];                             		// 0x0468 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnWritePlayerStorageComplete__Delegate;         		// 0x0474 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData22[ 0x4 ];                             		// 0x0478 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadPlayerStorageForNetIdComplete__Delegate;  		// 0x0484 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData23[ 0x4 ];                             		// 0x0488 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadPlayerStorageComplete__Delegate;          		// 0x0494 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData24[ 0x4 ];                             		// 0x0498 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnAddFriendByNameComplete__Delegate;            		// 0x04A4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData25[ 0x4 ];                             		// 0x04A8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnFriendInviteReceived__Delegate;               		// 0x04B4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData26[ 0x4 ];                             		// 0x04B8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReceivedGameInvite__Delegate;                 		// 0x04C4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData27[ 0x4 ];                             		// 0x04C8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnJoinFriendGameComplete__Delegate;             		// 0x04D4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData28[ 0x4 ];                             		// 0x04D8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnFriendMessageReceived__Delegate;              		// 0x04E4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData29[ 0x4 ];                             		// 0x04E8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnUnlockAchievementComplete__Delegate;          		// 0x04F4 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData30[ 0x4 ];                             		// 0x04F8 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             __OnReadAchievementsComplete__Delegate;           		// 0x0504 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData31[ 0x4 ];                             		// 0x0508 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3081 ];

		return pClassPointer;
	};

	int ConvertLangToUPlay ( struct FString lang );
	bool HasPrivilege ( int privilegeId );
	unsigned char GetAchievements ( unsigned char LocalUserNum, int TitleId, TArray< struct FAchievementDetails >* Achievements );
	void ClearReadAchievementsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadAchievementsCompleteDelegate );
	void AddReadAchievementsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadAchievementsCompleteDelegate );
	void OnReadAchievementsComplete ( int TitleId );
	bool ReadAchievements ( unsigned char LocalUserNum, int TitleId, unsigned long bShouldReadText, unsigned long bShouldReadImages );
	void ClearUnlockAchievementCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate UnlockAchievementCompleteDelegate );
	void AddUnlockAchievementCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate UnlockAchievementCompleteDelegate );
	void OnUnlockAchievementComplete ( unsigned long bWasSuccessful );
	bool UnlockAchievement ( unsigned char LocalUserNum, int AchievementId, float PercentComplete );
	bool DeleteMessage ( unsigned char LocalUserNum, int MessageIndex );
	bool UnmuteAll ( unsigned char LocalUserNum );
	bool MuteAll ( unsigned char LocalUserNum, unsigned long bAllowFriends );
	void ClearFriendMessageReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate MessageDelegate );
	void AddFriendMessageReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate MessageDelegate );
	void OnFriendMessageReceived ( unsigned char LocalUserNum, struct FUniqueNetId SendingPlayer, struct FString SendingNick, struct FString Message );
	void GetFriendMessages ( unsigned char LocalUserNum, TArray< struct FOnlineFriendMessage >* FriendMessages );
	void ClearJoinFriendGameCompleteDelegate ( struct FScriptDelegate JoinFriendGameCompleteDelegate );
	void AddJoinFriendGameCompleteDelegate ( struct FScriptDelegate JoinFriendGameCompleteDelegate );
	void OnJoinFriendGameComplete ( unsigned long bWasSuccessful );
	bool JoinFriendGame ( unsigned char LocalUserNum, struct FUniqueNetId Friend );
	void ClearReceivedGameInviteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReceivedGameInviteDelegate );
	void AddReceivedGameInviteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReceivedGameInviteDelegate );
	void OnReceivedGameInvite ( unsigned char LocalUserNum, struct FString InviterName );
	bool SendGameInviteToFriends ( unsigned char LocalUserNum, TArray< struct FUniqueNetId > Friends, struct FString Text );
	bool SendGameInviteToFriend ( unsigned char LocalUserNum, struct FUniqueNetId Friend, struct FString Text );
	bool SendMessageToFriend ( unsigned char LocalUserNum, struct FUniqueNetId Friend, struct FString Message );
	void ClearFriendInviteReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate InviteDelegate );
	void AddFriendInviteReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate InviteDelegate );
	void OnFriendInviteReceived ( unsigned char LocalUserNum, struct FUniqueNetId RequestingPlayer, struct FString RequestingNick, struct FString Message );
	bool RemoveFriend ( unsigned char LocalUserNum, struct FUniqueNetId FormerFriend );
	bool DenyFriendInvite ( unsigned char LocalUserNum, struct FUniqueNetId RequestingPlayer );
	bool AcceptFriendInvite ( unsigned char LocalUserNum, struct FUniqueNetId RequestingPlayer );
	void ClearAddFriendByNameCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendDelegate );
	void AddAddFriendByNameCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendDelegate );
	void OnAddFriendByNameComplete ( unsigned long bWasSuccessful );
	bool AddFriendByName ( unsigned char LocalUserNum, struct FString FriendName, struct FString Message );
	bool AddFriend ( unsigned char LocalUserNum, struct FUniqueNetId NewFriend, struct FString Message );
	void ClearWritePlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WritePlayerStorageCompleteDelegate );
	bool WritePlayerStorage ( unsigned char LocalUserNum, class UOnlinePlayerStorage* PlayerStorage, int DeviceID );
	class UOnlinePlayerStorage* GetPlayerStorage ( unsigned char LocalUserNum );
	void ClearReadPlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadPlayerStorageCompleteDelegate );
	void AddReadPlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadPlayerStorageCompleteDelegate );
	void OnReadPlayerStorageComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful );
	bool ReadPlayerStorage ( unsigned char LocalUserNum, class UOnlinePlayerStorage* PlayerStorage, int DeviceID );
	void ClearReadPlayerStorageForNetIdCompleteDelegate ( struct FUniqueNetId NetId, struct FScriptDelegate ReadPlayerStorageForNetIdCompleteDelegate );
	bool ReadPlayerStorageForNetId ( unsigned char LocalUserNum, struct FUniqueNetId NetId, class UOnlinePlayerStorage* PlayerStorage );
	void AddReadPlayerStorageForNetIdCompleteDelegate ( struct FUniqueNetId NetId, struct FScriptDelegate ReadPlayerStorageForNetIdCompleteDelegate );
	void OnReadPlayerStorageForNetIdComplete ( struct FUniqueNetId NetId, unsigned long bWasSuccessful );
	void AddWritePlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WritePlayerStorageCompleteDelegate );
	void OnWritePlayerStorageComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful );
	struct FString GetKeyboardInputResults ( unsigned char* bWasCanceled );
	void ClearKeyboardInputDoneDelegate ( struct FScriptDelegate InputDelegate );
	void AddKeyboardInputDoneDelegate ( struct FScriptDelegate InputDelegate );
	void OnKeyboardInputComplete ( unsigned long bWasSuccessful );
	bool ShowKeyboardUI ( unsigned char LocalUserNum, struct FString TitleText, struct FString DescriptionText, unsigned long bIsPassword, unsigned long bShouldValidate, struct FString DefaultText, int MaxResultLength );
	void SetOnlineStatus ( unsigned char LocalUserNum, int StatusId, TArray< struct FLocalizedStringSetting >* LocalizedStringSettings, TArray< struct FSettingsProperty >* Properties );
	void ClearStorageDeviceChangeDelegate ( struct FScriptDelegate StorageDeviceChangeDelegate );
	void AddStorageDeviceChangeDelegate ( struct FScriptDelegate StorageDeviceChangeDelegate );
	void OnStorageDeviceChange ( );
	int GetLocale ( );
	unsigned char GetNATType ( );
	void ClearConnectionStatusChangeDelegate ( struct FScriptDelegate ConnectionStatusDelegate );
	void AddConnectionStatusChangeDelegate ( struct FScriptDelegate ConnectionStatusDelegate );
	void OnConnectionStatusChange ( unsigned char ConnectionStatus );
	bool IsControllerConnected ( int ControllerId );
	void ClearControllerChangeDelegate ( struct FScriptDelegate ControllerChangeDelegate );
	void AddControllerChangeDelegate ( struct FScriptDelegate ControllerChangeDelegate );
	void OnControllerChange ( int ControllerId, unsigned long bIsConnected );
	void SetNetworkNotificationPosition ( unsigned char NewPos );
	unsigned char GetNetworkNotificationPosition ( );
	void ClearExternalUIChangeDelegate ( struct FScriptDelegate ExternalUIDelegate );
	void AddExternalUIChangeDelegate ( struct FScriptDelegate ExternalUIDelegate );
	void OnExternalUIChange ( unsigned long bIsOpening );
	void ClearLinkStatusChangeDelegate ( struct FScriptDelegate LinkStatusDelegate );
	void AddLinkStatusChangeDelegate ( struct FScriptDelegate LinkStatusDelegate );
	void OnLinkStatusChange ( unsigned long bIsConnected );
	bool HasLinkConnection ( );
	struct FString eventGetPlayerNicknameFromIndex ( int UserIndex );
	void CalcAggregateSkill ( TArray< struct FDouble > Mus, TArray< struct FDouble > Sigmas, struct FDouble* OutAggregateMu, struct FDouble* OutAggregateSigma );
	bool RegisterStatGuid ( struct FUniqueNetId PlayerID, struct FString* ClientStatGuid );
	struct FString GetClientStatGuid ( );
	void ClearRegisterHostStatGuidCompleteDelegateDelegate ( struct FScriptDelegate RegisterHostStatGuidCompleteDelegate );
	void AddRegisterHostStatGuidCompleteDelegate ( struct FScriptDelegate RegisterHostStatGuidCompleteDelegate );
	void OnRegisterHostStatGuidComplete ( unsigned long bWasSuccessful );
	bool RegisterHostStatGuid ( struct FString* HostStatGuid );
	struct FString GetHostStatGuid ( );
	bool WriteOnlinePlayerScores ( struct FName SessionName, int LeaderboardId, TArray< struct FOnlinePlayerScore >* PlayerScores );
	void ClearFlushOnlineStatsCompleteDelegate ( struct FScriptDelegate FlushOnlineStatsCompleteDelegate );
	void AddFlushOnlineStatsCompleteDelegate ( struct FScriptDelegate FlushOnlineStatsCompleteDelegate );
	void OnFlushOnlineStatsComplete ( struct FName SessionName, unsigned long bWasSuccessful );
	bool FlushOnlineStats ( struct FName SessionName );
	bool WriteOnlineStats ( struct FName SessionName, struct FUniqueNetId Player, class UOnlineStatsWrite* StatsWrite );
	void FreeStats ( class UOnlineStatsRead* StatsRead );
	void ClearReadOnlineStatsCompleteDelegate ( struct FScriptDelegate ReadOnlineStatsCompleteDelegate );
	void AddReadOnlineStatsCompleteDelegate ( struct FScriptDelegate ReadOnlineStatsCompleteDelegate );
	bool ReadOnlineStatsByRankAroundPlayer ( unsigned char LocalUserNum, class UOnlineStatsRead* StatsRead, int NumRows );
	bool ReadOnlineStatsByRank ( class UOnlineStatsRead* StatsRead, int StartIndex, int NumToRead );
	bool ReadOnlineStatsForFriends ( unsigned char LocalUserNum, class UOnlineStatsRead* StatsRead );
	bool ReadOnlineStats ( class UOnlineStatsRead* StatsRead, TArray< struct FUniqueNetId >* Players );
	void OnReadOnlineStatsComplete ( unsigned long bWasSuccessful );
	bool SetSpeechRecognitionObject ( unsigned char LocalUserNum, class USpeechRecognition* SpeechRecogObj );
	bool SelectVocabulary ( unsigned char LocalUserNum, int VocabularyId );
	void ClearRecognitionCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate RecognitionDelegate );
	void AddRecognitionCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate RecognitionDelegate );
	void OnRecognitionComplete ( );
	bool GetRecognitionResults ( unsigned char LocalUserNum, TArray< struct FSpeechRecognizedWord >* Words );
	bool StopSpeechRecognition ( unsigned char LocalUserNum );
	bool StartSpeechRecognition ( unsigned char LocalUserNum );
	void StopNetworkedVoice ( unsigned char LocalUserNum );
	void StartNetworkedVoice ( unsigned char LocalUserNum );
	bool UnmuteRemoteTalker ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID, unsigned long bIsSystemWide );
	bool MuteRemoteTalker ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID, unsigned long bIsSystemWide );
	bool SetRemoteTalkerPriority ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID, int Priority );
	bool IsHeadsetPresent ( unsigned char LocalUserNum );
	bool IsRemotePlayerTalking ( struct FUniqueNetId PlayerID );
	bool IsLocalPlayerTalking ( unsigned char LocalUserNum );
	bool UnregisterRemoteTalker ( struct FUniqueNetId PlayerID );
	bool RegisterRemoteTalker ( struct FUniqueNetId PlayerID );
	bool UnregisterLocalTalker ( unsigned char LocalUserNum );
	bool RegisterLocalTalker ( unsigned char LocalUserNum );
	unsigned char GetFriendsList ( unsigned char LocalUserNum, int Count, int StartingAt, TArray< struct FOnlineFriend >* Friends );
	void ClearReadFriendsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadFriendsCompleteDelegate );
	void AddReadFriendsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadFriendsCompleteDelegate );
	bool ReadFriendsList ( unsigned char LocalUserNum, int Count, int StartingAt );
	void OnReadFriendsComplete ( unsigned long bWasSuccessful );
	void ClearLoginStatusChangeDelegate ( struct FScriptDelegate LoginStatusDelegate, unsigned char LocalUserNum );
	void AddLoginStatusChangeDelegate ( struct FScriptDelegate LoginStatusDelegate, unsigned char LocalUserNum );
	void OnLoginStatusChange ( unsigned char NewStatus, struct FUniqueNetId NewId );
	void ClearWriteProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WriteProfileSettingsCompleteDelegate );
	void AddWriteProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WriteProfileSettingsCompleteDelegate );
	void OnWriteProfileSettingsComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful );
	bool WriteProfileSettings ( unsigned char LocalUserNum, class UOnlineProfileSettings* ProfileSettings );
	class UOnlineProfileSettings* GetProfileSettings ( unsigned char LocalUserNum );
	void ClearReadProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadProfileSettingsCompleteDelegate );
	void AddReadProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadProfileSettingsCompleteDelegate );
	void OnReadProfileSettingsComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful );
	bool ReadProfileSettings ( unsigned char LocalUserNum, class UOnlineProfileSettings* ProfileSettings );
	void ClearFriendsChangeDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendsDelegate );
	void AddFriendsChangeDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendsDelegate );
	void ClearMutingChangeDelegate ( struct FScriptDelegate MutingDelegate );
	void AddMutingChangeDelegate ( struct FScriptDelegate MutingDelegate );
	bool IsGuestLogin ( unsigned char LocalUserNum );
	bool IsLocalLogin ( unsigned char LocalUserNum );
	void ClearLoginCancelledDelegate ( struct FScriptDelegate CancelledDelegate );
	void AddLoginCancelledDelegate ( struct FScriptDelegate CancelledDelegate );
	void ClearLoginChangeDelegate ( struct FScriptDelegate LoginDelegate );
	void AddLoginChangeDelegate ( struct FScriptDelegate LoginDelegate );
	bool ShowFriendsUI ( unsigned char LocalUserNum );
	bool IsMuted ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID );
	bool AreAnyFriends ( unsigned char LocalUserNum, TArray< struct FFriendsQuery >* Query );
	bool IsFriend ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID );
	unsigned char CanShowPresenceInformation ( unsigned char LocalUserNum );
	unsigned char CanViewPlayerProfiles ( unsigned char LocalUserNum );
	unsigned char CanPurchaseContent ( unsigned char LocalUserNum );
	unsigned char CanDownloadUserContent ( unsigned char LocalUserNum );
	unsigned char CanCommunicate ( unsigned char LocalUserNum );
	unsigned char CanPlayOnline ( unsigned char LocalUserNum );
	struct FString GetPlayerNickname ( unsigned char LocalUserNum );
	bool GetUniquePlayerId ( unsigned char LocalUserNum, struct FUniqueNetId* PlayerID );
	bool IsStormDataAvailable ( );
	bool IsInOfflineMode ( );
	unsigned char GetLoginStatus ( unsigned char LocalUserNum );
	void ClearLogoutCompletedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LogoutDelegate );
	void AddLogoutCompletedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LogoutDelegate );
	void OnLogoutCompleted ( unsigned long bWasSuccessful );
	bool Logout ( unsigned char LocalUserNum );
	void ClearLoginFailedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LoginDelegate );
	void AddLoginFailedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LoginDelegate );
	void OnLoginFailed ( unsigned char LocalUserNum, unsigned char ErrorCode );
	bool AutoLogin ( );
	bool Login ( unsigned char LocalUserNum, struct FString LoginName, struct FString Password, unsigned long bWantsLocalOnly );
	bool ShowLoginUI ( unsigned long bShowOnlineOnly );
	void OnFriendsChange ( );
	void ClearPlayerTalkingDelegate ( struct FScriptDelegate TalkerDelegate );
	void AddPlayerTalkingDelegate ( struct FScriptDelegate TalkerDelegate );
	void OnPlayerTalkingStateChange ( struct FUniqueNetId Player, unsigned long bIsTalking );
	unsigned char GetTitleFileState ( struct FString Filename );
	bool GetTitleFileContents ( struct FString Filename, TArray< unsigned char >* FileContents );
	void ClearReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate );
	void AddReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate );
	bool ReadTitleFile ( struct FString FileToRead );
	void OnReadTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename );
	void OnMutingChange ( );
	void OnLoginCancelled ( );
	void OnLoginChange ( unsigned char LocalUserNum );
	void ClearTemporaryPrivileges ( );
	void SetTemporaryPrivileges ( TArray< int > privileges );
	void PushEvent ( struct FString EventType, struct FString EventName, class UJsonObject* Event );
	bool GetForceQuitMessageDisplayed ( );
	unsigned char GetCurrentUPlayMessage ( );
	void SetWaitingForStormData ( );
	void GetInstalledWorkshopItemsDef ( TArray< struct FWorkshopInstalledItemDef >* outArray );
	void ResetAllUSteamAchievements ( );
	bool UnlockUSteamAchievement ( struct FString AchievementId );
	void ShowUPlayRedeem ( );
	void ShowUPlayOverlay ( );
	bool IsActive ( );
	void eventExit ( );
	bool eventInit ( );
};



// Class OnlineSubsystemUPlay.RDVAsyncTask ( Property size: 2 iter: 10) 
// Class name index: 7834 
// 0x0009 (0x0069 - 0x0060)
class URDVAsyncTask : public UObject
{
public:
	struct FPointer                                    mCallContext;                                     		// 0x0060 (0x0008) [0x0000000000001000]              ( CPF_Native )
	unsigned char                                      mTaskType;                                        		// 0x0068 (0x0001) [0x0000000000001000]              ( CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3083 ];

		return pClassPointer;
	};

	void SetCredentials ( struct FPointer credentials );
	void LogResult ( );
	unsigned char GetTaskType ( );
	bool WasSuccessfull ( );
	bool IsTaskFinished ( );
	void Cleanup ( );
	void Init ( unsigned char taskType );
};



// Class OnlineSubsystemUPlay.RDVAsyncTaskManager ( Property size: 2 iter: 6) 
// Class name index: 7836 
// 0x0018 (0x0078 - 0x0060)
class URDVAsyncTaskManager : public UObject
{
public:
	struct FPointer                                    mFacade;                                          		// 0x0060 (0x0008) [0x0000000000001000]              ( CPF_Native )
	TArray< class URDVAsyncTask* >                     mAsyncTasks;                                      		// 0x0068 (0x0010) [0x0000000000001000]              ( CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3085 ];

		return pClassPointer;
	};

	void FinishAsyncTask ( class URDVAsyncTask* task );
	class URDVAsyncTask* GetNextFinishedTask ( );
	class URDVAsyncTask* StartAsyncTask ( unsigned char taskType );
	void Init ( struct FPointer facade );
};



// Class OnlineSubsystemUPlay.RDVManager ( Property size: 7 iter: 19) 
// Class name index: 7838 
// 0x002C (0x008C - 0x0060)
class URDVManager : public UObject
{
public:
	struct FPointer                                    mRendezVousFacade;                                		// 0x0060 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class URDVAsyncTaskManager*                        mAsyncTaskManager;                                		// 0x0068 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UUbiservicesManager*                         mUbiManager;                                      		// 0x0070 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UOnlineGameInterfaceUPlay*                   mGameInterface;                                   		// 0x0078 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UStormManager*                               mStormManager;                                    		// 0x0080 (0x0008) [0x0000000000001000]              ( CPF_Native )
	unsigned long                                      mIsInitialized : 1;                               		// 0x0088 (0x0004) [0x0000000000001000] [0x00000001] ( CPF_Native )
	unsigned long                                      mDisplayedDisconnectMessage : 1;                  		// 0x0088 (0x0004) [0x0000000000001000] [0x00000002] ( CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3087 ];

		return pClassPointer;
	};

	void eventUpdateGUILoginSuccesfullRDV ( );
	void eventUpdateGUILoginFailedRDV ( );
	void JoinGameByInvite ( struct FPointer invite );
	void SetDisconnected ( );
	void Cleanup ( );
	void Logout ( );
	void RegisterUrlTaskDone ( class URDVAsyncTask* task );
	void LoginTaskDone ( class URDVAsyncTask* task );
	void Tick ( );
	void Login ( );
	void ShowDisconnectMessage ( );
	void Init ( class UUbiservicesManager* ubiManager, class UOnlineGameInterfaceUPlay* GameInterface );
};



// Class OnlineSubsystemUPlay.StormManager ( Property size: 14 iter: 26) 
// Class name index: 7840 
// 0x0069 (0x00C9 - 0x0060)
class UStormManager : public UObject
{
public:
	class URDVManager*                                 mOwnerRdvManager;                                 		// 0x0060 (0x0008) [0x0000000000000000]              
	struct FPointer                                    mStormCore;                                       		// 0x0068 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mStormGeneralHandler;                             		// 0x0070 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mStormPunchClient;                                		// 0x0078 (0x0008) [0x0000000000001000]              ( CPF_Native )
	TArray< struct FPointer >                          mPendingRegistrationStormNetDriver;               		// 0x0080 (0x0010) [0x0000000000001000]              ( CPF_Native )
	TArray< int >                                      mPortToOpenWithUPnP;                              		// 0x0090 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     mNatDetailedStr;                                  		// 0x00A0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      mStorm_IsStormCoreReady : 1;                      		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mIsLocalPeerDataComplete : 1;                     		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      mIsErrorTriggered : 1;                            		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      mIsUPnPMappingDone : 1;                           		// 0x00B0 (0x0004) [0x0000000000000000] [0x00000008] 
	int                                                mStorm_TraversalStatus;                           		// 0x00B4 (0x0004) [0x0000000000000000]              
	struct FString                                     mLocalStormPeerData;                              		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      mNatType;                                         		// 0x00C8 (0x0001) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3089 ];

		return pClassPointer;
	};

	struct FString FormatPeerDataForCommand ( struct FString inPeerData );
	void Storm_Tick ( );
	void Storm_Shutdown ( );
	void Storm_TriggerError ( );
	void Storm_WarnPendingRegistrationStormNetDriver ( );
	void Storm_OnTraversalStarted ( );
	void Storm_StartTraversal ( );
	void Storm_OnNatDetermined ( );
	void Storm_OnUPnPMappingDone ( int Port );
	void Storm_OnClientInitialized ( );
	void Storm_Init ( class URDVManager* rdvManagerOwner );
};



// Class OnlineSubsystemUPlay.UbiservicesManager ( Property size: 6 iter: 17) 
// Class name index: 7842 
// 0x0024 (0x0084 - 0x0060)
class UUbiservicesManager : public UObject
{
public:
	struct FPointer                                    mUbiservicesFacade;                               		// 0x0060 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mUbiservicesLoginTask;                            		// 0x0068 (0x0008) [0x0000000000001000]              ( CPF_Native )
	struct FPointer                                    mPlayerCredentials;                               		// 0x0070 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class URDVManager*                                 mRDVManager;                                      		// 0x0078 (0x0008) [0x0000000000001000]              ( CPF_Native )
	unsigned long                                      mIsInitialized : 1;                               		// 0x0080 (0x0004) [0x0000000000001000] [0x00000001] ( CPF_Native )
	unsigned long                                      mIsLoggingIn : 1;                                 		// 0x0080 (0x0004) [0x0000000000001000] [0x00000002] ( CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3091 ];

		return pClassPointer;
	};

	void eventUpdateGUILoginFailedUbiservices ( );
	void CheckForReLogin ( );
	void SetDisconnected ( );
	bool DoesNeedReconnect ( );
	void PushEvent ( struct FString EventType, struct FString EventName, class UJsonObject* Event );
	void Cleanup ( );
	void Logout ( );
	void TickAsyncTasks ( );
	bool IsSessionValid ( );
	void Login ( );
	void Init ( class URDVManager* RDVManager );
};



// Class OnlineSubsystemUPlay.UPlayEventManager ( Property size: 6 iter: 10) 
// Class name index: 7844 
// 0x001D (0x007D - 0x0060)
class UUPlayEventManager : public UObject
{
public:
	unsigned long                                      mShowedUplayStoppedWorking : 1;                   		// 0x0060 (0x0004) [0x0000000000001000] [0x00000001] ( CPF_Native )
	unsigned long                                      mForceQuitMessageDisplayed : 1;                   		// 0x0060 (0x0004) [0x0000000000001000] [0x00000002] ( CPF_Native )
	class URDVManager*                                 mRDVManager;                                      		// 0x0064 (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UUbiservicesManager*                         mUbiManager;                                      		// 0x006C (0x0008) [0x0000000000001000]              ( CPF_Native )
	class UOnlineGameInterfaceUPlay*                   mOnlineGameInterface;                             		// 0x0074 (0x0008) [0x0000000000001000]              ( CPF_Native )
	unsigned char                                      mCurrentUPlayMessage;                             		// 0x007C (0x0001) [0x0000000000001000]              ( CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3093 ];

		return pClassPointer;
	};

	void Update ( );
	void Init ( class UOnlineGameInterfaceUPlay* OnlineGameInterface, class URDVManager* RDVManager, class UUbiservicesManager* ubiManager );
	bool GetForceQuitMessageDisplayed ( );
	unsigned char GetCurrentUPlayMessage ( );
};



// Class OnlineSubsystemUPlay.WorkshopControllerInterfaceUPlay ( Property size: 0 iter: 1) 
// Class name index: 7846 
// 0x0000 (0x0060 - 0x0060)
class UWorkshopControllerInterfaceUPlay : public UInterface
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3095 ];

		return pClassPointer;
	};

	void OnWorkshopItemInstalled ( struct FWorkshopInstalledItemDef* def );
};



// Class OnlineSubsystemUPlay.IpNetDriverStorm ( Property size: 2 iter: 4) 
// Class name index: 7848 
// 0x0088 (0x0298 - 0x0210)
class UIpNetDriverStorm : public UTcpNetDriver
{
public:
	int                                                mClientLocalPort;                                 		// 0x0210 (0x0004) [0x0000000000004000]              ( CPF_Config )
	int                                                mStormConnectEndPointTimeout;                     		// 0x0214 (0x0004) [0x0000000000004000]              ( CPF_Config )
//	 LastOffset: 218
//	 Class Propsize: 298
	unsigned char                                      UnknownData00[ 0x80 ];                            		// 0x0218 (0x0080) MISSED OFFSET

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3097 ];

		return pClassPointer;
	};

};



// Class OnlineSubsystemUPlay.IpNetConnectionStorm ( Property size: 0 iter: 0) 
// Class name index: 7851 
// 0x0000 (0xB0E4 - 0xB0E4)
class UIpNetConnectionStorm : public UTcpipConnection
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3103 ];

		return pClassPointer;
	};

};




#ifdef _MSC_VER
	#pragma pack ( pop )
#endif