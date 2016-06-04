#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: OnlineSubsystemUPlay_f_structs.h
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

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.UpdateOnlineGame
// [0x00024400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execUpdateOnlineGame_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameSettings*                         UpdatedGameSettings;                              		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bShouldRefreshOnlineData : 1;                     		// 0x0010 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.TriggerServicesUnavailable
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execTriggerServicesUnavailable_Parms
{
	unsigned long                                      showMessage : 1;                                  		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.LeaveOnlineGameCompleted
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execLeaveOnlineGameCompleted_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.LeaveOnlineGame
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execLeaveOnlineGame_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.DestroyInternetGameCompleted
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execDestroyInternetGameCompleted_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.UpdateSessionCompleted
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execUpdateSessionCompleted_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.JoinInternetGameByInvite
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execJoinInternetGameByInvite_Parms
{
	int                                                SessionId;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.JoinInternetGameCompleted
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execJoinInternetGameCompleted_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.SearchSessionsCompleted
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execSearchSessionsCompleted_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnAddHostParticipantCompleted
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execOnAddHostParticipantCompleted_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnCreateSessionCompleted
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execOnCreateSessionCompleted_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.Init
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execInit_Parms
{
	struct FPointer                                    gameSessionClient;                                		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class URDVAsyncTaskManager*                        asyncTaskManager;                                 		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.ShowUPlayMessage
// [0x00020400] ( FUNC_Native )
struct UOnlineGameInterfaceUPlay_execShowUPlayMessage_Parms
{
	unsigned char                                      MessageType;                                      		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.ClearUPlayInviteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceUPlay_execClearUPlayInviteDelegate_Parms
{
	struct FScriptDelegate                             UplayInviteDelegate;                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.AddUPlayInviteDelegate
// [0x00020002] 
struct UOnlineGameInterfaceUPlay_execAddUPlayInviteDelegate_Parms
{
	struct FScriptDelegate                             UplayInviteDelegate;                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.ClearUPlayMessageDelegate
// [0x00020002] 
struct UOnlineGameInterfaceUPlay_execClearUPlayMessageDelegate_Parms
{
	struct FScriptDelegate                             UplayMessageDelegate;                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.AddUPlayMessageDelegate
// [0x00020002] 
struct UOnlineGameInterfaceUPlay_execAddUPlayMessageDelegate_Parms
{
	struct FScriptDelegate                             UplayMessageDelegate;                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnUPlayInvite
// [0x00120000] 
struct UOnlineGameInterfaceUPlay_execOnUPlayInvite_Parms
{
	int                                                SessionId;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnUPlayMessage
// [0x00120000] 
struct UOnlineGameInterfaceUPlay_execOnUPlayMessage_Parms
{
	unsigned char                                      MessageType;                                      		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ConvertLangToUPlay
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execConvertLangToUPlay_Parms
{
	struct FString                                     lang;                                             		// 0x0000 (0x0010) [0x0000000000400082]              ( CPF_Const | CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.HasPrivilege
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execHasPrivilege_Parms
{
	int                                                privilegeId;                                      		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetAchievements
// [0x00424000] 
struct UOnlineSubsystemUPlay_execGetAchievements_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FAchievementDetails >               Achievements;                                     		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                TitleId;                                          		// 0x0014 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0018 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadAchievementsCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearReadAchievementsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadAchievementsCompleteDelegate;                 		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadAchievementsCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddReadAchievementsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadAchievementsCompleteDelegate;                 		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadAchievementsComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReadAchievementsComplete_Parms
{
	int                                                TitleId;                                          		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadAchievements
// [0x00024000] 
struct UOnlineSubsystemUPlay_execReadAchievements_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                TitleId;                                          		// 0x0004 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bShouldReadText : 1;                              		// 0x0008 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bShouldReadImages : 1;                            		// 0x000C (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearUnlockAchievementCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearUnlockAchievementCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             UnlockAchievementCompleteDelegate;                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddUnlockAchievementCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddUnlockAchievementCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             UnlockAchievementCompleteDelegate;                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnUnlockAchievementComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnUnlockAchievementComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnlockAchievement
// [0x00024000] 
struct UOnlineSubsystemUPlay_execUnlockAchievement_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                AchievementId;                                    		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	float                                              PercentComplete;                                  		// 0x0008 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.DeleteMessage
// [0x00020000] 
struct UOnlineSubsystemUPlay_execDeleteMessage_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                MessageIndex;                                     		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnmuteAll
// [0x00020000] 
struct UOnlineSubsystemUPlay_execUnmuteAll_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.MuteAll
// [0x00020000] 
struct UOnlineSubsystemUPlay_execMuteAll_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bAllowFriends : 1;                                		// 0x0004 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFriendMessageReceivedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearFriendMessageReceivedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             MessageDelegate;                                  		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendMessageReceivedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddFriendMessageReceivedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             MessageDelegate;                                  		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFriendMessageReceived
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnFriendMessageReceived_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                SendingPlayer;                                    		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     SendingNick;                                      		// 0x000C (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Message;                                          		// 0x001C (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetFriendMessages
// [0x00420000] 
struct UOnlineSubsystemUPlay_execGetFriendMessages_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FOnlineFriendMessage >              FriendMessages;                                   		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearJoinFriendGameCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearJoinFriendGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             JoinFriendGameCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddJoinFriendGameCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddJoinFriendGameCompleteDelegate_Parms
{
	struct FScriptDelegate                             JoinFriendGameCompleteDelegate;                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnJoinFriendGameComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnJoinFriendGameComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.JoinFriendGame
// [0x00020000] 
struct UOnlineSubsystemUPlay_execJoinFriendGame_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                Friend;                                           		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReceivedGameInviteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearReceivedGameInviteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReceivedGameInviteDelegate;                       		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReceivedGameInviteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddReceivedGameInviteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReceivedGameInviteDelegate;                       		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReceivedGameInvite
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReceivedGameInvite_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     InviterName;                                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SendGameInviteToFriends
// [0x00024000] 
struct UOnlineSubsystemUPlay_execSendGameInviteToFriends_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FUniqueNetId >                      Friends;                                          		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Text;                                             		// 0x0014 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0024 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SendGameInviteToFriend
// [0x00024000] 
struct UOnlineSubsystemUPlay_execSendGameInviteToFriend_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                Friend;                                           		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     Text;                                             		// 0x000C (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SendMessageToFriend
// [0x00020000] 
struct UOnlineSubsystemUPlay_execSendMessageToFriend_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                Friend;                                           		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     Message;                                          		// 0x000C (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFriendInviteReceivedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearFriendInviteReceivedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             InviteDelegate;                                   		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendInviteReceivedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddFriendInviteReceivedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             InviteDelegate;                                   		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFriendInviteReceived
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnFriendInviteReceived_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                RequestingPlayer;                                 		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     RequestingNick;                                   		// 0x000C (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Message;                                          		// 0x001C (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RemoveFriend
// [0x00020000] 
struct UOnlineSubsystemUPlay_execRemoveFriend_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                FormerFriend;                                     		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.DenyFriendInvite
// [0x00020000] 
struct UOnlineSubsystemUPlay_execDenyFriendInvite_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                RequestingPlayer;                                 		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AcceptFriendInvite
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAcceptFriendInvite_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                RequestingPlayer;                                 		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearAddFriendByNameCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearAddFriendByNameCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             FriendDelegate;                                   		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddAddFriendByNameCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddAddFriendByNameCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             FriendDelegate;                                   		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnAddFriendByNameComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnAddFriendByNameComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendByName
// [0x00024000] 
struct UOnlineSubsystemUPlay_execAddFriendByName_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     FriendName;                                       		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Message;                                          		// 0x0014 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0024 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriend
// [0x00024000] 
struct UOnlineSubsystemUPlay_execAddFriend_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                NewFriend;                                        		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     Message;                                          		// 0x000C (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearWritePlayerStorageCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearWritePlayerStorageCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             WritePlayerStorageCompleteDelegate;               		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WritePlayerStorage
// [0x00024000] 
struct UOnlineSubsystemUPlay_execWritePlayerStorage_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlinePlayerStorage*                        PlayerStorage;                                    		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                DeviceID;                                         		// 0x000C (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetPlayerStorage
// [0x00020002] 
struct UOnlineSubsystemUPlay_execGetPlayerStorage_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlinePlayerStorage*                        ReturnValue;                                      		// 0x0004 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadPlayerStorageCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearReadPlayerStorageCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadPlayerStorageCompleteDelegate;                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadPlayerStorageCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddReadPlayerStorageCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadPlayerStorageCompleteDelegate;                		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadPlayerStorageComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReadPlayerStorageComplete_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0004 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadPlayerStorage
// [0x00024000] 
struct UOnlineSubsystemUPlay_execReadPlayerStorage_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlinePlayerStorage*                        PlayerStorage;                                    		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                DeviceID;                                         		// 0x000C (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadPlayerStorageForNetIdCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearReadPlayerStorageForNetIdCompleteDelegate_Parms
{
	struct FUniqueNetId                                NetId;                                            		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadPlayerStorageForNetIdCompleteDelegate;        		// 0x0008 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadPlayerStorageForNetId
// [0x00020000] 
struct UOnlineSubsystemUPlay_execReadPlayerStorageForNetId_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                NetId;                                            		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlinePlayerStorage*                        PlayerStorage;                                    		// 0x000C (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadPlayerStorageForNetIdCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddReadPlayerStorageForNetIdCompleteDelegate_Parms
{
	struct FUniqueNetId                                NetId;                                            		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadPlayerStorageForNetIdCompleteDelegate;        		// 0x0008 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadPlayerStorageForNetIdComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReadPlayerStorageForNetIdComplete_Parms
{
	struct FUniqueNetId                                NetId;                                            		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddWritePlayerStorageCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddWritePlayerStorageCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             WritePlayerStorageCompleteDelegate;               		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnWritePlayerStorageComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnWritePlayerStorageComplete_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0004 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetKeyboardInputResults
// [0x00420000] 
struct UOnlineSubsystemUPlay_execGetKeyboardInputResults_Parms
{
	unsigned char                                      bWasCanceled;                                     		// 0x0000 (0x0001) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearKeyboardInputDoneDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearKeyboardInputDoneDelegate_Parms
{
	struct FScriptDelegate                             InputDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddKeyboardInputDoneDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddKeyboardInputDoneDelegate_Parms
{
	struct FScriptDelegate                             InputDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnKeyboardInputComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnKeyboardInputComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowKeyboardUI
// [0x00024000] 
struct UOnlineSubsystemUPlay_execShowKeyboardUI_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     TitleText;                                        		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     DescriptionText;                                  		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bIsPassword : 1;                                  		// 0x0024 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      bShouldValidate : 1;                              		// 0x0028 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	struct FString                                     DefaultText;                                      		// 0x002C (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	int                                                MaxResultLength;                                  		// 0x003C (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0040 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetOnlineStatus
// [0x00420000] 
struct UOnlineSubsystemUPlay_execSetOnlineStatus_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                StatusId;                                         		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FLocalizedStringSetting >           LocalizedStringSettings;                          		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	TArray< struct FSettingsProperty >                 Properties;                                       		// 0x0018 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearStorageDeviceChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearStorageDeviceChangeDelegate_Parms
{
	struct FScriptDelegate                             StorageDeviceChangeDelegate;                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddStorageDeviceChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddStorageDeviceChangeDelegate_Parms
{
	struct FScriptDelegate                             StorageDeviceChangeDelegate;                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnStorageDeviceChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnStorageDeviceChange_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetLocale
// [0x00020002] 
struct UOnlineSubsystemUPlay_execGetLocale_Parms
{
	int                                                ReturnValue;                                      		// 0x0000 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetNATType
// [0x00020002] 
struct UOnlineSubsystemUPlay_execGetNATType_Parms
{
	unsigned char                                      ReturnValue;                                      		// 0x0000 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearConnectionStatusChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearConnectionStatusChangeDelegate_Parms
{
	struct FScriptDelegate                             ConnectionStatusDelegate;                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddConnectionStatusChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddConnectionStatusChangeDelegate_Parms
{
	struct FScriptDelegate                             ConnectionStatusDelegate;                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnConnectionStatusChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnConnectionStatusChange_Parms
{
	unsigned char                                      ConnectionStatus;                                 		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsControllerConnected
// [0x00020002] 
struct UOnlineSubsystemUPlay_execIsControllerConnected_Parms
{
	int                                                ControllerId;                                     		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearControllerChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearControllerChangeDelegate_Parms
{
	struct FScriptDelegate                             ControllerChangeDelegate;                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddControllerChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddControllerChangeDelegate_Parms
{
	struct FScriptDelegate                             ControllerChangeDelegate;                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnControllerChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnControllerChange_Parms
{
	int                                                ControllerId;                                     		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bIsConnected : 1;                                 		// 0x0004 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetNetworkNotificationPosition
// [0x00020000] 
struct UOnlineSubsystemUPlay_execSetNetworkNotificationPosition_Parms
{
	unsigned char                                      NewPos;                                           		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetNetworkNotificationPosition
// [0x00020000] 
struct UOnlineSubsystemUPlay_execGetNetworkNotificationPosition_Parms
{
	unsigned char                                      ReturnValue;                                      		// 0x0000 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearExternalUIChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearExternalUIChangeDelegate_Parms
{
	struct FScriptDelegate                             ExternalUIDelegate;                               		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddExternalUIChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddExternalUIChangeDelegate_Parms
{
	struct FScriptDelegate                             ExternalUIDelegate;                               		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnExternalUIChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnExternalUIChange_Parms
{
	unsigned long                                      bIsOpening : 1;                                   		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLinkStatusChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearLinkStatusChangeDelegate_Parms
{
	struct FScriptDelegate                             LinkStatusDelegate;                               		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLinkStatusChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddLinkStatusChangeDelegate_Parms
{
	struct FScriptDelegate                             LinkStatusDelegate;                               		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLinkStatusChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnLinkStatusChange_Parms
{
	unsigned long                                      bIsConnected : 1;                                 		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.HasLinkConnection
// [0x00020002] 
struct UOnlineSubsystemUPlay_execHasLinkConnection_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetPlayerNicknameFromIndex
// [0x00020802] ( FUNC_Event )
struct UOnlineSubsystemUPlay_eventGetPlayerNicknameFromIndex_Parms
{
	int                                                UserIndex;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CalcAggregateSkill
// [0x00420000] 
struct UOnlineSubsystemUPlay_execCalcAggregateSkill_Parms
{
	TArray< struct FDouble >                           Mus;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< struct FDouble >                           Sigmas;                                           		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FDouble                                     OutAggregateMu;                                   		// 0x0020 (0x0008) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	struct FDouble                                     OutAggregateSigma;                                		// 0x0028 (0x0008) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterStatGuid
// [0x00420000] 
struct UOnlineSubsystemUPlay_execRegisterStatGuid_Parms
{
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ClientStatGuid;                                   		// 0x0008 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetClientStatGuid
// [0x00020000] 
struct UOnlineSubsystemUPlay_execGetClientStatGuid_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearRegisterHostStatGuidCompleteDelegateDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearRegisterHostStatGuidCompleteDelegateDelegate_Parms
{
	struct FScriptDelegate                             RegisterHostStatGuidCompleteDelegate;             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddRegisterHostStatGuidCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddRegisterHostStatGuidCompleteDelegate_Parms
{
	struct FScriptDelegate                             RegisterHostStatGuidCompleteDelegate;             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnRegisterHostStatGuidComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnRegisterHostStatGuidComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterHostStatGuid
// [0x00420000] 
struct UOnlineSubsystemUPlay_execRegisterHostStatGuid_Parms
{
	struct FString                                     HostStatGuid;                                     		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetHostStatGuid
// [0x00020000] 
struct UOnlineSubsystemUPlay_execGetHostStatGuid_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WriteOnlinePlayerScores
// [0x00420000] 
struct UOnlineSubsystemUPlay_execWriteOnlinePlayerScores_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                LeaderboardId;                                    		// 0x0008 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FOnlinePlayerScore >                PlayerScores;                                     		// 0x000C (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x001C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFlushOnlineStatsCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearFlushOnlineStatsCompleteDelegate_Parms
{
	struct FScriptDelegate                             FlushOnlineStatsCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFlushOnlineStatsCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddFlushOnlineStatsCompleteDelegate_Parms
{
	struct FScriptDelegate                             FlushOnlineStatsCompleteDelegate;                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFlushOnlineStatsComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnFlushOnlineStatsComplete_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.FlushOnlineStats
// [0x00020000] 
struct UOnlineSubsystemUPlay_execFlushOnlineStats_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WriteOnlineStats
// [0x00020000] 
struct UOnlineSubsystemUPlay_execWriteOnlineStats_Parms
{
	struct FName                                       SessionName;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                Player;                                           		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineStatsWrite*                           StatsWrite;                                       		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.FreeStats
// [0x00020000] 
struct UOnlineSubsystemUPlay_execFreeStats_Parms
{
	class UOnlineStatsRead*                            StatsRead;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadOnlineStatsCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearReadOnlineStatsCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadOnlineStatsCompleteDelegate;                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadOnlineStatsCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddReadOnlineStatsCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadOnlineStatsCompleteDelegate;                  		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStatsByRankAroundPlayer
// [0x00024000] 
struct UOnlineSubsystemUPlay_execReadOnlineStatsByRankAroundPlayer_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineStatsRead*                            StatsRead;                                        		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                NumRows;                                          		// 0x000C (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStatsByRank
// [0x00024000] 
struct UOnlineSubsystemUPlay_execReadOnlineStatsByRank_Parms
{
	class UOnlineStatsRead*                            StatsRead;                                        		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                StartIndex;                                       		// 0x0008 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                NumToRead;                                        		// 0x000C (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStatsForFriends
// [0x00020000] 
struct UOnlineSubsystemUPlay_execReadOnlineStatsForFriends_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineStatsRead*                            StatsRead;                                        		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStats
// [0x00420000] 
struct UOnlineSubsystemUPlay_execReadOnlineStats_Parms
{
	TArray< struct FUniqueNetId >                      Players;                                          		// 0x0000 (0x0010) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	class UOnlineStatsRead*                            StatsRead;                                        		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadOnlineStatsComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReadOnlineStatsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetSpeechRecognitionObject
// [0x00020000] 
struct UOnlineSubsystemUPlay_execSetSpeechRecognitionObject_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class USpeechRecognition*                          SpeechRecogObj;                                   		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SelectVocabulary
// [0x00020000] 
struct UOnlineSubsystemUPlay_execSelectVocabulary_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                VocabularyId;                                     		// 0x0004 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearRecognitionCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execClearRecognitionCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             RecognitionDelegate;                              		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddRecognitionCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execAddRecognitionCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             RecognitionDelegate;                              		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnRecognitionComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnRecognitionComplete_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetRecognitionResults
// [0x00420000] 
struct UOnlineSubsystemUPlay_execGetRecognitionResults_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FSpeechRecognizedWord >             Words;                                            		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StopSpeechRecognition
// [0x00020000] 
struct UOnlineSubsystemUPlay_execStopSpeechRecognition_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StartSpeechRecognition
// [0x00020000] 
struct UOnlineSubsystemUPlay_execStartSpeechRecognition_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StopNetworkedVoice
// [0x00020000] 
struct UOnlineSubsystemUPlay_execStopNetworkedVoice_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StartNetworkedVoice
// [0x00020000] 
struct UOnlineSubsystemUPlay_execStartNetworkedVoice_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnmuteRemoteTalker
// [0x00024000] 
struct UOnlineSubsystemUPlay_execUnmuteRemoteTalker_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bIsSystemWide : 1;                                		// 0x000C (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.MuteRemoteTalker
// [0x00024000] 
struct UOnlineSubsystemUPlay_execMuteRemoteTalker_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bIsSystemWide : 1;                                		// 0x000C (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetRemoteTalkerPriority
// [0x00020000] 
struct UOnlineSubsystemUPlay_execSetRemoteTalkerPriority_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                Priority;                                         		// 0x000C (0x0004) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsHeadsetPresent
// [0x00020000] 
struct UOnlineSubsystemUPlay_execIsHeadsetPresent_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsRemotePlayerTalking
// [0x00020000] 
struct UOnlineSubsystemUPlay_execIsRemotePlayerTalking_Parms
{
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsLocalPlayerTalking
// [0x00020000] 
struct UOnlineSubsystemUPlay_execIsLocalPlayerTalking_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnregisterRemoteTalker
// [0x00020000] 
struct UOnlineSubsystemUPlay_execUnregisterRemoteTalker_Parms
{
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterRemoteTalker
// [0x00020000] 
struct UOnlineSubsystemUPlay_execRegisterRemoteTalker_Parms
{
	struct FUniqueNetId                                PlayerID;                                         		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0008 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnregisterLocalTalker
// [0x00020000] 
struct UOnlineSubsystemUPlay_execUnregisterLocalTalker_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterLocalTalker
// [0x00020000] 
struct UOnlineSubsystemUPlay_execRegisterLocalTalker_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetFriendsList
// [0x00424000] 
struct UOnlineSubsystemUPlay_execGetFriendsList_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FOnlineFriend >                     Friends;                                          		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                Count;                                            		// 0x0014 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                StartingAt;                                       		// 0x0018 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x001C (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadFriendsCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execClearReadFriendsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadFriendsCompleteDelegate;                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadFriendsCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execAddReadFriendsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadFriendsCompleteDelegate;                      		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadFriendsList
// [0x00024002] 
struct UOnlineSubsystemUPlay_execReadFriendsList_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	int                                                Count;                                            		// 0x0004 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	int                                                StartingAt;                                       		// 0x0008 (0x0004) [0x0000000000000090]              ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
	// int                                             Index;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
	// struct FScriptDelegate                          CallDelegate;                                     		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadFriendsComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReadFriendsComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginStatusChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearLoginStatusChangeDelegate_Parms
{
	struct FScriptDelegate                             LoginStatusDelegate;                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      LocalUserNum;                                     		// 0x0010 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginStatusChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddLoginStatusChangeDelegate_Parms
{
	struct FScriptDelegate                             LoginStatusDelegate;                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      LocalUserNum;                                     		// 0x0010 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginStatusChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnLoginStatusChange_Parms
{
	unsigned char                                      NewStatus;                                        		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                NewId;                                            		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearWriteProfileSettingsCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execClearWriteProfileSettingsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             WriteProfileSettingsCompleteDelegate;             		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddWriteProfileSettingsCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execAddWriteProfileSettingsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             WriteProfileSettingsCompleteDelegate;             		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnWriteProfileSettingsComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnWriteProfileSettingsComplete_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0004 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WriteProfileSettings
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execWriteProfileSettings_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineProfileSettings*                      ProfileSettings;                                  		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetProfileSettings
// [0x00020002] 
struct UOnlineSubsystemUPlay_execGetProfileSettings_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineProfileSettings*                      ReturnValue;                                      		// 0x0004 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadProfileSettingsCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execClearReadProfileSettingsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadProfileSettingsCompleteDelegate;              		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadProfileSettingsCompleteDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execAddReadProfileSettingsCompleteDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             ReadProfileSettingsCompleteDelegate;              		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadProfileSettingsComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReadProfileSettingsComplete_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0004 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadProfileSettings
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execReadProfileSettings_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineProfileSettings*                      ProfileSettings;                                  		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFriendsChangeDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execClearFriendsChangeDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             FriendsDelegate;                                  		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendsChangeDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execAddFriendsChangeDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             FriendsDelegate;                                  		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearMutingChangeDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execClearMutingChangeDelegate_Parms
{
	struct FScriptDelegate                             MutingDelegate;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	// int                                             RemoveIndex;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddMutingChangeDelegate
// [0x00020002] 
struct UOnlineSubsystemUPlay_execAddMutingChangeDelegate_Parms
{
	struct FScriptDelegate                             MutingDelegate;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsGuestLogin
// [0x00020000] 
struct UOnlineSubsystemUPlay_execIsGuestLogin_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsLocalLogin
// [0x00020000] 
struct UOnlineSubsystemUPlay_execIsLocalLogin_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginCancelledDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearLoginCancelledDelegate_Parms
{
	struct FScriptDelegate                             CancelledDelegate;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginCancelledDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddLoginCancelledDelegate_Parms
{
	struct FScriptDelegate                             CancelledDelegate;                                		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearLoginChangeDelegate_Parms
{
	struct FScriptDelegate                             LoginDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginChangeDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddLoginChangeDelegate_Parms
{
	struct FScriptDelegate                             LoginDelegate;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowFriendsUI
// [0x00020000] 
struct UOnlineSubsystemUPlay_execShowFriendsUI_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsMuted
// [0x00020000] 
struct UOnlineSubsystemUPlay_execIsMuted_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AreAnyFriends
// [0x00420000] 
struct UOnlineSubsystemUPlay_execAreAnyFriends_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	TArray< struct FFriendsQuery >                     Query;                                            		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsFriend
// [0x00020000] 
struct UOnlineSubsystemUPlay_execIsFriend_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0004 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanShowPresenceInformation
// [0x00020000] 
struct UOnlineSubsystemUPlay_execCanShowPresenceInformation_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0001 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanViewPlayerProfiles
// [0x00020000] 
struct UOnlineSubsystemUPlay_execCanViewPlayerProfiles_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0001 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanPurchaseContent
// [0x00020000] 
struct UOnlineSubsystemUPlay_execCanPurchaseContent_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0001 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanDownloadUserContent
// [0x00020000] 
struct UOnlineSubsystemUPlay_execCanDownloadUserContent_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0001 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanCommunicate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execCanCommunicate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0001 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanPlayOnline
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execCanPlayOnline_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0001 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetPlayerNickname
// [0x00020002] 
struct UOnlineSubsystemUPlay_execGetPlayerNickname_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     ReturnValue;                                      		// 0x0004 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetUniquePlayerId
// [0x00420002] 
struct UOnlineSubsystemUPlay_execGetUniquePlayerId_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FUniqueNetId                                PlayerID;                                         		// 0x0004 (0x0008) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsStormDataAvailable
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execIsStormDataAvailable_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsInOfflineMode
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execIsInOfflineMode_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetLoginStatus
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execGetLoginStatus_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ReturnValue;                                      		// 0x0001 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLogoutCompletedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearLogoutCompletedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             LogoutDelegate;                                   		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLogoutCompletedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddLogoutCompletedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             LogoutDelegate;                                   		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLogoutCompleted
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnLogoutCompleted_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Logout
// [0x00020000] 
struct UOnlineSubsystemUPlay_execLogout_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginFailedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearLoginFailedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             LoginDelegate;                                    		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginFailedDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddLoginFailedDelegate_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FScriptDelegate                             LoginDelegate;                                    		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginFailed
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnLoginFailed_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	unsigned char                                      ErrorCode;                                        		// 0x0001 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AutoLogin
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAutoLogin_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Login
// [0x00024000] 
struct UOnlineSubsystemUPlay_execLogin_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     LoginName;                                        		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     Password;                                         		// 0x0014 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      bWantsLocalOnly : 1;                              		// 0x0024 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0028 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowLoginUI
// [0x00024000] 
struct UOnlineSubsystemUPlay_execShowLoginUI_Parms
{
	unsigned long                                      bShowOnlineOnly : 1;                              		// 0x0000 (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFriendsChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnFriendsChange_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearPlayerTalkingDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearPlayerTalkingDelegate_Parms
{
	struct FScriptDelegate                             TalkerDelegate;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddPlayerTalkingDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddPlayerTalkingDelegate_Parms
{
	struct FScriptDelegate                             TalkerDelegate;                                   		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnPlayerTalkingStateChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnPlayerTalkingStateChange_Parms
{
	struct FUniqueNetId                                Player;                                           		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      bIsTalking : 1;                                   		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetTitleFileState
// [0x00020000] 
struct UOnlineSubsystemUPlay_execGetTitleFileState_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned char                                      ReturnValue;                                      		// 0x0010 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetTitleFileContents
// [0x00420000] 
struct UOnlineSubsystemUPlay_execGetTitleFileContents_Parms
{
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	TArray< unsigned char >                            FileContents;                                     		// 0x0010 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0020 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadTitleFileCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execClearReadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadTitleFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadTitleFileCompleteDelegate
// [0x00020000] 
struct UOnlineSubsystemUPlay_execAddReadTitleFileCompleteDelegate_Parms
{
	struct FScriptDelegate                             ReadTitleFileCompleteDelegate;                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadTitleFile
// [0x00020000] 
struct UOnlineSubsystemUPlay_execReadTitleFile_Parms
{
	struct FString                                     FileToRead;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadTitleFileComplete
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnReadTitleFileComplete_Parms
{
	unsigned long                                      bWasSuccessful : 1;                               		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	struct FString                                     Filename;                                         		// 0x0004 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnMutingChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnMutingChange_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginCancelled
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnLoginCancelled_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginChange
// [0x00120000] 
struct UOnlineSubsystemUPlay_execOnLoginChange_Parms
{
	unsigned char                                      LocalUserNum;                                     		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearTemporaryPrivileges
// [0x00020002] 
struct UOnlineSubsystemUPlay_execClearTemporaryPrivileges_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetTemporaryPrivileges
// [0x00020002] 
struct UOnlineSubsystemUPlay_execSetTemporaryPrivileges_Parms
{
	TArray< int >                                      privileges;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.PushEvent
// [0x00020002] 
struct UOnlineSubsystemUPlay_execPushEvent_Parms
{
	struct FString                                     EventType;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     EventName;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UJsonObject*                                 Event;                                            		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetForceQuitMessageDisplayed
// [0x00020002] 
struct UOnlineSubsystemUPlay_execGetForceQuitMessageDisplayed_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetCurrentUPlayMessage
// [0x00020002] 
struct UOnlineSubsystemUPlay_execGetCurrentUPlayMessage_Parms
{
	unsigned char                                      ReturnValue;                                      		// 0x0000 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetWaitingForStormData
// [0x00020002] 
struct UOnlineSubsystemUPlay_execSetWaitingForStormData_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetInstalledWorkshopItemsDef
// [0x00420400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execGetInstalledWorkshopItemsDef_Parms
{
	TArray< struct FWorkshopInstalledItemDef >         outArray;                                         		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ResetAllUSteamAchievements
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execResetAllUSteamAchievements_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnlockUSteamAchievement
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execUnlockUSteamAchievement_Parms
{
	struct FString                                     AchievementId;                                    		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowUPlayRedeem
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execShowUPlayRedeem_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowUPlayOverlay
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execShowUPlayOverlay_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsActive
// [0x00020400] ( FUNC_Native )
struct UOnlineSubsystemUPlay_execIsActive_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Exit
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UOnlineSubsystemUPlay_eventExit_Parms
{
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Init
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UOnlineSubsystemUPlay_eventInit_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.SetCredentials
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTask_execSetCredentials_Parms
{
	struct FPointer                                    credentials;                                      		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.LogResult
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTask_execLogResult_Parms
{
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.GetTaskType
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTask_execGetTaskType_Parms
{
	unsigned char                                      ReturnValue;                                      		// 0x0000 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.WasSuccessfull
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTask_execWasSuccessfull_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.IsTaskFinished
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTask_execIsTaskFinished_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.Cleanup
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTask_execCleanup_Parms
{
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.Init
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTask_execInit_Parms
{
	unsigned char                                      taskType;                                         		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.FinishAsyncTask
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTaskManager_execFinishAsyncTask_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.GetNextFinishedTask
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTaskManager_execGetNextFinishedTask_Parms
{
	class URDVAsyncTask*                               ReturnValue;                                      		// 0x0000 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.StartAsyncTask
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTaskManager_execStartAsyncTask_Parms
{
	unsigned char                                      taskType;                                         		// 0x0000 (0x0001) [0x0000000000000080]              ( CPF_Parm )
	class URDVAsyncTask*                               ReturnValue;                                      		// 0x0004 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.Init
// [0x00020400] ( FUNC_Native )
struct URDVAsyncTaskManager_execInit_Parms
{
	struct FPointer                                    facade;                                           		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.RDVManager.UpdateGUILoginSuccesfullRDV
// [0x00020800] ( FUNC_Event )
struct URDVManager_eventUpdateGUILoginSuccesfullRDV_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.UpdateGUILoginFailedRDV
// [0x00020800] ( FUNC_Event )
struct URDVManager_eventUpdateGUILoginFailedRDV_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.JoinGameByInvite
// [0x00020400] ( FUNC_Native )
struct URDVManager_execJoinGameByInvite_Parms
{
	struct FPointer                                    invite;                                           		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.RDVManager.SetDisconnected
// [0x00020400] ( FUNC_Native )
struct URDVManager_execSetDisconnected_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.Cleanup
// [0x00020400] ( FUNC_Native )
struct URDVManager_execCleanup_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.Logout
// [0x00020400] ( FUNC_Native )
struct URDVManager_execLogout_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.RegisterUrlTaskDone
// [0x00020400] ( FUNC_Native )
struct URDVManager_execRegisterUrlTaskDone_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.RDVManager.LoginTaskDone
// [0x00020400] ( FUNC_Native )
struct URDVManager_execLoginTaskDone_Parms
{
	class URDVAsyncTask*                               task;                                             		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.RDVManager.Tick
// [0x00020400] ( FUNC_Native )
struct URDVManager_execTick_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.Login
// [0x00020400] ( FUNC_Native )
struct URDVManager_execLogin_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.ShowDisconnectMessage
// [0x00020400] ( FUNC_Native )
struct URDVManager_execShowDisconnectMessage_Parms
{
};

// Function OnlineSubsystemUPlay.RDVManager.Init
// [0x00020400] ( FUNC_Native )
struct URDVManager_execInit_Parms
{
	class UUbiservicesManager*                         ubiManager;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UOnlineGameInterfaceUPlay*                   GameInterface;                                    		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.StormManager.FormatPeerDataForCommand
// [0x00020400] ( FUNC_Native )
struct UStormManager_execFormatPeerDataForCommand_Parms
{
	struct FString                                     inPeerData;                                       		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function OnlineSubsystemUPlay.StormManager.Storm_Tick
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_Tick_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_Shutdown
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_Shutdown_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_TriggerError
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_TriggerError_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_WarnPendingRegistrationStormNetDriver
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_WarnPendingRegistrationStormNetDriver_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnTraversalStarted
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_OnTraversalStarted_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_StartTraversal
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_StartTraversal_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnNatDetermined
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_OnNatDetermined_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnUPnPMappingDone
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_OnUPnPMappingDone_Parms
{
	int                                                Port;                                             		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnClientInitialized
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_OnClientInitialized_Parms
{
};

// Function OnlineSubsystemUPlay.StormManager.Storm_Init
// [0x00020400] ( FUNC_Native )
struct UStormManager_execStorm_Init_Parms
{
	class URDVManager*                                 rdvManagerOwner;                                  		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.UbiservicesManager.UpdateGUILoginFailedUbiservices
// [0x00020800] ( FUNC_Event )
struct UUbiservicesManager_eventUpdateGUILoginFailedUbiservices_Parms
{
};

// Function OnlineSubsystemUPlay.UbiservicesManager.CheckForReLogin
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execCheckForReLogin_Parms
{
};

// Function OnlineSubsystemUPlay.UbiservicesManager.SetDisconnected
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execSetDisconnected_Parms
{
};

// Function OnlineSubsystemUPlay.UbiservicesManager.DoesNeedReconnect
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execDoesNeedReconnect_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.UbiservicesManager.PushEvent
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execPushEvent_Parms
{
	struct FString                                     EventType;                                        		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     EventName;                                        		// 0x0010 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UJsonObject*                                 Event;                                            		// 0x0020 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Cleanup
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execCleanup_Parms
{
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Logout
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execLogout_Parms
{
};

// Function OnlineSubsystemUPlay.UbiservicesManager.TickAsyncTasks
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execTickAsyncTasks_Parms
{
};

// Function OnlineSubsystemUPlay.UbiservicesManager.IsSessionValid
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execIsSessionValid_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Login
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execLogin_Parms
{
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Init
// [0x00020400] ( FUNC_Native )
struct UUbiservicesManager_execInit_Parms
{
	class URDVManager*                                 RDVManager;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.UPlayEventManager.Update
// [0x00020400] ( FUNC_Native )
struct UUPlayEventManager_execUpdate_Parms
{
};

// Function OnlineSubsystemUPlay.UPlayEventManager.Init
// [0x00020400] ( FUNC_Native )
struct UUPlayEventManager_execInit_Parms
{
	class UOnlineGameInterfaceUPlay*                   OnlineGameInterface;                              		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class URDVManager*                                 RDVManager;                                       		// 0x0008 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	class UUbiservicesManager*                         ubiManager;                                       		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function OnlineSubsystemUPlay.UPlayEventManager.GetForceQuitMessageDisplayed
// [0x00020002] 
struct UUPlayEventManager_execGetForceQuitMessageDisplayed_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.UPlayEventManager.GetCurrentUPlayMessage
// [0x00020002] 
struct UUPlayEventManager_execGetCurrentUPlayMessage_Parms
{
	unsigned char                                      ReturnValue;                                      		// 0x0000 (0x0001) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function OnlineSubsystemUPlay.WorkshopControllerInterfaceUPlay.OnWorkshopItemInstalled
// [0x00420400] ( FUNC_Native )
struct UWorkshopControllerInterfaceUPlay_execOnWorkshopItemInstalled_Parms
{
	struct FWorkshopInstalledItemDef                   def;                                              		// 0x0000 (0x0018) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif