#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: IpDrv_structs.h
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

// ScriptStruct IpDrv.InternetLink.IpAddr
// 0x00000008
struct FIpAddr
{
//	 vPoperty_Size=2
	int                                                Addr;                                             		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Port;                                             		// 0x0004 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobBase.McpClashMobChallengeFile
// 0x00000055
struct FMcpClashMobChallengeFile
{
//	 vPoperty_Size=7
	unsigned long                                      should_keep_post_challenge : 1;                   		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FString                                     title_id;                                         		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     file_name;                                        		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     dl_name;                                          		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     hash_code;                                        		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Type;                                             		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      Status;                                           		// 0x0054 (0x0001) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobBase.McpChildClashMobEntry
// 0x00000014
struct FMcpChildClashMobEntry
{
//	 vPoperty_Size=2
	int                                                Order;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     ChildChallengeId;                                 		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpClashMobBase.McpClashMobChallengeEvent
// 0x0000012C
struct FMcpClashMobChallengeEvent
{
//	 vPoperty_Size=24
	struct FString                                     unique_challenge_id;                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     visible_date;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     start_date;                                       		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     end_date;                                         		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     completed_date;                                   		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     purge_date;                                       		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     challenge_type;                                   		// 0x0060 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                num_attempts;                                     		// 0x0070 (0x0004) [0x0000000000000000]              
	int                                                num_successful_attempts;                          		// 0x0074 (0x0004) [0x0000000000000000]              
	int                                                goal_value;                                       		// 0x0078 (0x0004) [0x0000000000000000]              
	int                                                goal_start_value;                                 		// 0x007C (0x0004) [0x0000000000000000]              
	int                                                goal_current_value;                               		// 0x0080 (0x0004) [0x0000000000000000]              
	unsigned long                                      has_started : 1;                                  		// 0x0084 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      is_visible : 1;                                   		// 0x0084 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      has_completed : 1;                                		// 0x0084 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      was_successful : 1;                               		// 0x0084 (0x0004) [0x0000000000000000] [0x00000008] 
	TArray< struct FMcpClashMobChallengeFile >         file_list;                                        		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                facebook_likes;                                   		// 0x0098 (0x0004) [0x0000000000000000]              
	int                                                facebook_comments;                                		// 0x009C (0x0004) [0x0000000000000000]              
	float                                              facebook_like_scaler;                             		// 0x00A0 (0x0004) [0x0000000000000000]              
	float                                              facebook_comment_scaler;                          		// 0x00A4 (0x0004) [0x0000000000000000]              
	int                                                facebook_like_goal_progress;                      		// 0x00A8 (0x0004) [0x0000000000000000]              
	int                                                facebook_comment_goal_progress;                   		// 0x00AC (0x0004) [0x0000000000000000]              
	struct FString                                     facebook_id;                                      		// 0x00B0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                twitter_retweets;                                 		// 0x00C0 (0x0004) [0x0000000000000000]              
	float                                              twitter_retweets_scaler;                          		// 0x00C4 (0x0004) [0x0000000000000000]              
	int                                                twitter_goal_progress;                            		// 0x00C8 (0x0004) [0x0000000000000000]              
	struct FString                                     twitter_id;                                       		// 0x00CC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     StartedAt;                                        		// 0x00DC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ParentChallengeId;                                		// 0x00EC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChildClashMobEntry >            ChildChallengeList;                               		// 0x00FC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ActiveChildChallengeId;                           		// 0x010C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      ChildChallengeGatingType;                         		// 0x011C (0x0001) [0x0000000000000000]              
	float                                              ChildChallengeGatingValue;                        		// 0x0120 (0x0004) [0x0000000000000000]              
	unsigned char                                      ChallengeRatingType;                              		// 0x0124 (0x0001) [0x0000000000000000]              
	int                                                MinChallengeDuration;                             		// 0x0128 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobBase.McpClashMobChallengeUserStatus
// 0x0000009C
struct FMcpClashMobChallengeUserStatus
{
//	 vPoperty_Size=15
	struct FString                                     unique_challenge_id;                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     unique_user_id;                                   		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     save_slot_id;                                     		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                num_attempts;                                     		// 0x0030 (0x0004) [0x0000000000000000]              
	int                                                num_successful_attempts;                          		// 0x0034 (0x0004) [0x0000000000000000]              
	int                                                goal_progress;                                    		// 0x0038 (0x0004) [0x0000000000000000]              
	unsigned long                                      did_complete : 1;                                 		// 0x003C (0x0004) [0x0000000000000000] [0x00000001] 
	struct FString                                     last_update_time;                                 		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                user_award_given;                                 		// 0x0050 (0x0004) [0x0000000000000000]              
	struct FString                                     accept_time;                                      		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      did_preregister : 1;                              		// 0x0064 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FString                                     facebook_like_time;                               		// 0x0068 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      enrolled_via_facebook : 1;                        		// 0x0078 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      liked_via_facebook : 1;                           		// 0x0078 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      commented_via_facebook : 1;                       		// 0x0078 (0x0004) [0x0000000000000000] [0x00000004] 
	struct FString                                     twitter_retweet_time;                             		// 0x007C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      enrolled_via_twitter : 1;                         		// 0x008C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      retweeted : 1;                                    		// 0x008C (0x0004) [0x0000000000000000] [0x00000002] 
	int                                                HighGoalProgress;                                 		// 0x0090 (0x0004) [0x0000000000000000]              
	float                                              PercentRank;                                      		// 0x0094 (0x0004) [0x0000000000000000]              
	int                                                Rank;                                             		// 0x0098 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobBase.McpClashMobPushNotificationParams
// 0x00000004
struct FMcpClashMobPushNotificationParams
{
//	 vPoperty_Size=1
	int                                                bah;                                              		// 0x0000 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobBase.McpClashMobPushNotification
// 0x00000044
struct FMcpClashMobPushNotification
{
//	 vPoperty_Size=5
	TArray< struct FString >                           device_tokens;                                    		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     badge_type;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Sound;                                            		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Message;                                          		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FMcpClashMobPushNotificationParams          Params;                                           		// 0x0040 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.OnlineTitleFileDownloadBase.TitleFileWeb
// 0x0019(0x003D - 0x0024)
struct FTitleFileWeb : FTitleFile
{
//	 vPoperty_Size=3
	struct FString                                     StringData;                                       		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       HTTPRequest;                                      		// 0x0034 (0x0008) [0x0000000000000000]              
	unsigned char                                      FileCompressionType;                              		// 0x003C (0x0001) [0x0000000000000000]              
};

// ScriptStruct IpDrv.OnlineTitleFileDownloadBase.FileNameToURLMapping
// 0x00000010
struct FFileNameToURLMapping
{
//	 vPoperty_Size=2
	struct FName                                       Filename;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FName                                       UrlMapping;                                       		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobManager.McpChallengeRequest
// 0x00000018
struct FMcpChallengeRequest
{
//	 vPoperty_Size=2
	struct FString                                     UniqueChallengeId;                                		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       HTTPRequest;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobManager.McpChallengeUserRequest
// 0x00000050
struct FMcpChallengeUserRequest
{
//	 vPoperty_Size=5
	struct FString                                     UniqueUserId;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChallengeRequest >              ChallengeStatusRequests;                          		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChallengeRequest >              ChallengeAcceptRequests;                          		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChallengeRequest >              ChallengeUpdateProgressRequests;                  		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpChallengeRequest >              ChallengeUpdateRewardRequests;                    		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpClashMobManagerV3.ChallengeRequest
// 0x00000018
struct FChallengeRequest
{
//	 vPoperty_Size=2
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobManagerV3.UserRequest
// 0x0010(0x0028 - 0x0018)
struct UMcpClashMobManagerV3_FUserRequest : FChallengeRequest
{
//	 vPoperty_Size=1
	struct FString                                     McpId;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpClashMobManagerV3.FileRequest
// 0x00000038
struct UMcpClashMobManagerV3_FFileRequest
{
//	 vPoperty_Size=4
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpClashMobManagerV3.ClashMobFileData
// 0x00000040
struct FClashMobFileData
{
//	 vPoperty_Size=4
	struct FString                                     ChallengeId;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     DLName;                                           		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            Data;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpGroupsBase.McpGroupMember
// 0x00000011
struct FMcpGroupMember
{
//	 vPoperty_Size=2
	struct FString                                     MemberId;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      AcceptState;                                      		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpGroupsBase.McpGroup
// 0x00000044
struct FMcpGroup
{
//	 vPoperty_Size=5
	struct FString                                     OwnerId;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GroupName;                                        		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      AccessLevel;                                      		// 0x0030 (0x0001) [0x0000000000000000]              
	TArray< struct FMcpGroupMember >                   Members;                                          		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpGroupsBase.McpGroupList
// 0x00000020
struct FMcpGroupList
{
//	 vPoperty_Size=2
	struct FString                                     RequesterId;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpGroup >                         Groups;                                           		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpGroupsManagerV3.GroupRequest
// 0x00000018
struct FGroupRequest
{
//	 vPoperty_Size=2
	struct FString                                     GroupID;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpGroupsManagerV3.GroupUserRequest
// 0x00000018
struct FGroupUserRequest
{
//	 vPoperty_Size=2
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpGroupsManagerV3.GroupMemberRequest
// 0x00000038
struct FGroupMemberRequest
{
//	 vPoperty_Size=4
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GroupID;                                          		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           Members;                                          		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpIdMappingBase.McpIdMapping
// 0x00000040
struct FMcpIdMapping
{
//	 vPoperty_Size=4
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalToken;                                    		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpIdMappingManager.AddMappingRequest
// 0x00000038
struct UMcpIdMappingManager_FAddMappingRequest
{
//	 vPoperty_Size=4
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0030 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpIdMappingManager.QueryMappingRequest
// 0x00000018
struct UMcpIdMappingManager_FQueryMappingRequest
{
//	 vPoperty_Size=2
	struct FString                                     ExternalType;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpIdMappingManagerV3.AddMappingRequest
// 0x00000078
struct UMcpIdMappingManagerV3_FAddMappingRequest
{
//	 vPoperty_Size=5
	struct FMcpIdMapping                               Mapping;                                          		// 0x0000 (0x0040) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     McpId;                                            		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalId;                                       		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0060 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0070 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpIdMappingManagerV3.QueryMappingRequest
// 0x00000018
struct UMcpIdMappingManagerV3_FQueryMappingRequest
{
//	 vPoperty_Size=2
	struct FString                                     ExternalType;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpLeaderboardsBase.McpLeaderboardColumn
// 0x00000011
struct FMcpLeaderboardColumn
{
//	 vPoperty_Size=2
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      Type;                                             		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpLeaderboardsBase.McpLeaderboardColumnEntry
// 0x00000014
struct FMcpLeaderboardColumnEntry
{
//	 vPoperty_Size=2
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Value;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpLeaderboardsBase.McpLeaderboardEntry
// 0x00000040
struct FMcpLeaderboardEntry
{
//	 vPoperty_Size=7
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     LeaderboardName;                                  		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      Timeframe;                                        		// 0x0020 (0x0001) [0x0000000000000000]              
	TArray< struct FMcpLeaderboardColumnEntry >        Values;                                           		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                RatingValue;                                      		// 0x0034 (0x0004) [0x0000000000000000]              
	int                                                Ranking;                                          		// 0x0038 (0x0004) [0x0000000000000000]              
	int                                                Percentile;                                       		// 0x003C (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpLeaderboardsBase.McpLeaderboard
// 0x00000040
struct FMcpLeaderboard
{
//	 vPoperty_Size=4
	struct FString                                     LeaderboardName;                                  		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpLeaderboardColumn >             Columns;                                          		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     RatingColumn;                                     		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            Timeframes;                                       		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpLeaderboardsV3.LeaderboardRequest
// 0x00000018
struct FLeaderboardRequest
{
//	 vPoperty_Size=2
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     LeaderboardName;                                  		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpLeaderboardsV3.LeaderboardTimeframeRequest
// 0x0001(0x0019 - 0x0018)
struct FLeaderboardTimeframeRequest : FLeaderboardRequest
{
//	 vPoperty_Size=1
	unsigned char                                      Timeframe;                                        		// 0x0018 (0x0001) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpLeaderboardsV3.UserLeaderboardRequest
// 0x0010(0x0028 - 0x0018)
struct FUserLeaderboardRequest : FLeaderboardRequest
{
//	 vPoperty_Size=1
	struct FString                                     McpId;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpManagedValueManagerBase.ManagedValue
// 0x0000000C
struct FManagedValue
{
//	 vPoperty_Size=2
	struct FName                                       ValueId;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                Value;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpManagedValueManagerBase.ManagedValueSaveSlot
// 0x00000030
struct FManagedValueSaveSlot
{
//	 vPoperty_Size=3
	struct FString                                     OwningMcpId;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FManagedValue >                     Values;                                           		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpManagedValueManager.SaveSlotRequestState
// 0x00000028
struct UMcpManagedValueManager_FSaveSlotRequestState
{
//	 vPoperty_Size=3
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     SaveSlot;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpManagedValueManager.ValueRequestState
// 0x0008(0x0030 - 0x0028)
struct FValueRequestState : UMcpManagedValueManager_FSaveSlotRequestState
{
//	 vPoperty_Size=1
	struct FName                                       ValueId;                                          		// 0x0028 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpMessageBase.McpMessage
// 0x00000061
struct FMcpMessage
{
//	 vPoperty_Size=7
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ToUniqueUserId;                                   		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     FromUniqueUserId;                                 		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     FromFriendlyName;                                 		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     MessageType;                                      		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ValidUntil;                                       		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      MessageCompressionType;                           		// 0x0060 (0x0001) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpMessageBase.McpMessageList
// 0x00000020
struct FMcpMessageList
{
//	 vPoperty_Size=2
	struct FString                                     ToUniqueUserId;                                   		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpMessage >                       Messages;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpMessageBase.McpMessageContents
// 0x00000020
struct FMcpMessageContents
{
//	 vPoperty_Size=2
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            MessageContents;                                  		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpMessageManager.McpCompressMessageRequest
// 0x00000034
struct FMcpCompressMessageRequest
{
//	 vPoperty_Size=5
	TArray< unsigned char >                            SourceBuffer;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            DestBuffer;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                OutCompressedSize;                                		// 0x0020 (0x0004) [0x0000000000000000]              
	class UHttpRequestInterface*                       Request;                                          		// 0x0024 (0x0008) [0x0000000000000000]              
	struct FPointer                                    CompressionWorker;                                		// 0x002C (0x0008) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct IpDrv.McpMessageManager.McpUncompressMessageRequest
// 0x0000003C
struct FMcpUncompressMessageRequest
{
//	 vPoperty_Size=5
	struct FString                                     MessageId;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            SourceBuffer;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< unsigned char >                            DestBuffer;                                       		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                OutUncompressedSize;                              		// 0x0030 (0x0004) [0x0000000000000000]              
	struct FPointer                                    UncompressionWorker;                              		// 0x0034 (0x0008) [0x0000000000001000]              ( CPF_Native )
};

// ScriptStruct IpDrv.McpMessageManagerV3.UserBasedRequest
// 0x00000018
struct FUserBasedRequest
{
//	 vPoperty_Size=2
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     McpId;                                            		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpMessageManagerV3.MessageBasedRequest
// 0x00000018
struct FMessageBasedRequest
{
//	 vPoperty_Size=2
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     MessageId;                                        		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpRemoteNotificationV3.UserRequest
// 0x00000028
struct UMcpRemoteNotificationV3_FUserRequest
{
//	 vPoperty_Size=3
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     PushNotificationToken;                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpSystemCloudFileManagerV3.Ems3File
// 0x0000004C
struct FEms3File
{
//	 vPoperty_Size=7
	struct FString                                     UniqueFileName;                                   		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Hash;                                             		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Length;                                           		// 0x0030 (0x0004) [0x0000000000000000]              
	unsigned long                                      bCanCache : 1;                                    		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      ReadState;                                        		// 0x0038 (0x0001) [0x0000000000000000]              
	TArray< unsigned char >                            Data;                                             		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpSystemCloudFileManagerV3.FileRequest
// 0x00000018
struct UMcpSystemCloudFileManagerV3_FFileRequest
{
//	 vPoperty_Size=2
	struct FString                                     FileToRead;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpThreadedChatBase.McpSystemChatThread
// 0x00000020
struct FMcpSystemChatThread
{
//	 vPoperty_Size=2
	struct FString                                     ThreadName;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ThreadId;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpThreadedChatBase.McpUserChatThread
// 0x0010(0x0030 - 0x0020)
struct FMcpUserChatThread : FMcpSystemChatThread
{
//	 vPoperty_Size=1
	struct FString                                     OwnerId;                                          		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpThreadedChatBase.McpChatPost
// 0x000000A4
struct FMcpChatPost
{
//	 vPoperty_Size=f
	struct FString                                     PostId;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ThreadId;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     OwnerId;                                          		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     OwnerName;                                        		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              ownerRank;                                        		// 0x0040 (0x0004) [0x0000000000000000]              
	struct FString                                     Message;                                          		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      bProfanityChecked : 1;                            		// 0x0054 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      bReported : 1;                                    		// 0x0054 (0x0004) [0x0000000000000000] [0x00000002] 
	int                                                VoteUpCount;                                      		// 0x0058 (0x0004) [0x0000000000000000]              
	int                                                VoteDownCount;                                    		// 0x005C (0x0004) [0x0000000000000000]              
	int                                                Popularity;                                       		// 0x0060 (0x0004) [0x0000000000000000]              
	struct FString                                     TimeStamp;                                        		// 0x0064 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ReplyToOwnerId;                                   		// 0x0074 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ReplyToOwnerName;                                 		// 0x0084 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ReplyToPostId;                                    		// 0x0094 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpThreadedChatV3.UserRequest
// 0x00000018
struct UMcpThreadedChatV3_FUserRequest
{
//	 vPoperty_Size=2
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpThreadedChatV3.UserThreadNameRequest
// 0x0010(0x0028 - 0x0018)
struct FUserThreadNameRequest : UMcpThreadedChatV3_FUserRequest
{
//	 vPoperty_Size=1
	struct FString                                     ThreadName;                                       		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpThreadedChatV3.ThreadRequest
// 0x00000018
struct FThreadRequest
{
//	 vPoperty_Size=2
	struct FString                                     ThreadId;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpThreadedChatV3.UserThreadRequest
// 0x0010(0x0028 - 0x0018)
struct FUserThreadRequest : FThreadRequest
{
//	 vPoperty_Size=1
	struct FString                                     McpId;                                            		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpThreadedChatV3.PostRequest
// 0x00000018
struct FPostRequest
{
//	 vPoperty_Size=2
	struct FString                                     PostId;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserCloudFileDownload.McpUserCloudFileInfo
// 0x0030(0x0074 - 0x0044)
struct FMcpUserCloudFileInfo : FEmsFile
{
//	 vPoperty_Size=3
	struct FString                                     CreationDate;                                     		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     LastUpdateDate;                                   		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     CompressionType;                                  		// 0x0064 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserCloudFileDownload.McpUserCloudFilesEntry
// 0x00000038
struct FMcpUserCloudFilesEntry
{
//	 vPoperty_Size=4
	struct FString                                     UserId;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FTitleFileWeb >                     DownloadedFiles;                                  		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpUserCloudFileInfo >             EnumeratedFiles;                                  		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       HTTPRequestEnumerateFiles;                        		// 0x0030 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserCloudFileManagerV3.EmsUserFile
// 0x0024(0x0068 - 0x0044)
struct FEmsUserFile : FEmsFile
{
//	 vPoperty_Size=3
	struct FString                                     McpId;                                            		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      ReadState;                                        		// 0x0054 (0x0001) [0x0000000000000000]              
	TArray< unsigned char >                            Data;                                             		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserCloudFileManagerV3.FileRequest
// 0x00000018
struct UMcpUserCloudFileManagerV3_FFileRequest
{
//	 vPoperty_Size=2
	struct FString                                     FileToRead;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserCloudFileManagerV3.UserRequest
// 0x00000018
struct UMcpUserCloudFileManagerV3_FUserRequest
{
//	 vPoperty_Size=2
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserCloudFileManagerV3.UserFileRequest
// 0x00000030
struct FUserFileRequest
{
//	 vPoperty_Size=5
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Filename;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
	int                                                StartTime;                                        		// 0x0028 (0x0004) [0x0000000000000000]              
	unsigned long                                      bIsWrite : 1;                                     		// 0x002C (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct IpDrv.McpUserInventoryBase.McpInventoryItemAttribute
// 0x00000014
struct FMcpInventoryItemAttribute
{
//	 vPoperty_Size=2
	struct FString                                     AttributeId;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Value;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserInventoryBase.McpInventoryItem
// 0x0000004C
struct FMcpInventoryItem
{
//	 vPoperty_Size=7
	struct FString                                     InstanceItemId;                                   		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GlobalItemId;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                QuantityIAP;                                      		// 0x0024 (0x0004) [0x0000000000000000]              
	float                                              Scalar;                                           		// 0x0028 (0x0004) [0x0000000000000000]              
	struct FString                                     LastUpdateTime;                                   		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpInventoryItemAttribute >        Attributes;                                       		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserInventoryBase.McpInventoryItemContainer
// 0x00000014
struct FMcpInventoryItemContainer
{
//	 vPoperty_Size=2
	struct FString                                     GlobalItemId;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserInventoryBase.McpIapItem
// 0x00000024
struct FMcpIapItem
{
//	 vPoperty_Size=3
	struct FString                                     ItemId;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FString                                     SaveSlotId;                                       		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserInventoryBase.McpIapList
// 0x00000020
struct FMcpIapList
{
//	 vPoperty_Size=2
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpIapItem >                       Iaps;                                             		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserInventoryBase.McpInventorySaveSlot
// 0x00000030
struct FMcpInventorySaveSlot
{
//	 vPoperty_Size=3
	struct FString                                     OwningMcpId;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FMcpInventoryItem >                 Items;                                            		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserInventoryManager.SaveSlotRequestState
// 0x00000028
struct UMcpUserInventoryManager_FSaveSlotRequestState
{
//	 vPoperty_Size=3
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     SaveSlotId;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserInventoryManager.InventoryItemRequestState
// 0x0010(0x0038 - 0x0028)
struct FInventoryItemRequestState : UMcpUserInventoryManager_FSaveSlotRequestState
{
//	 vPoperty_Size=1
	struct FString                                     ItemId;                                           		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserInventoryManagerV3.UserRequest
// 0x00000018
struct UMcpUserInventoryManagerV3_FUserRequest
{
//	 vPoperty_Size=2
	class UHttpRequestInterface*                       Request;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     McpId;                                            		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserInventoryManagerV3.SaveSlotRequest
// 0x0010(0x0028 - 0x0018)
struct FSaveSlotRequest : UMcpUserInventoryManagerV3_FUserRequest
{
//	 vPoperty_Size=1
	struct FString                                     SaveSlotId;                                       		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserManagerBase.McpExternalAccount
// 0x00000020
struct FMcpExternalAccount
{
//	 vPoperty_Size=2
	struct FString                                     ExternalId;                                       		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ExternalType;                                     		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserManagerBase.McpUserStatus
// 0x00000078
struct FMcpUserStatus
{
//	 vPoperty_Size=9
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     SecretKey;                                        		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Ticket;                                           		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     UDID;                                             		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     RegisteredDate;                                   		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     LastActiveDate;                                   		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                DaysInactive;                                     		// 0x0060 (0x0004) [0x0000000000000000]              
	unsigned long                                      bIsBanned : 1;                                    		// 0x0064 (0x0004) [0x0000000000000000] [0x00000001] 
	TArray< struct FMcpExternalAccount >               ExternalAccounts;                                 		// 0x0068 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.McpUserManager.UserRequest
// 0x00000018
struct UMcpUserManager_FUserRequest
{
//	 vPoperty_Size=2
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.McpUserManagerV3.UserRequest
// 0x00000018
struct UMcpUserManagerV3_FUserRequest
{
//	 vPoperty_Size=2
	struct FString                                     McpId;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       Request;                                          		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.MeshBeacon.ConnectionBandwidthStats
// 0x0000000C
struct FConnectionBandwidthStats
{
//	 vPoperty_Size=3
	int                                                UpstreamRate;                                     		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                DownstreamRate;                                   		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                RoundtripLatency;                                 		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.MeshBeacon.PlayerMember
// 0x00000010
struct FPlayerMember
{
//	 vPoperty_Size=3
	int                                                TeamNum;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Skill;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FUniqueNetId                                NetId;                                            		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.MeshBeaconClient.ClientConnectionRequest
// 0x00000028
struct FClientConnectionRequest
{
//	 vPoperty_Size=6
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      NatType;                                          		// 0x0008 (0x0001) [0x0000000000000000]              
	unsigned long                                      bCanHostVs : 1;                                   		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              GoodHostRatio;                                    		// 0x0010 (0x0004) [0x0000000000000000]              
	TArray< struct FConnectionBandwidthStats >         BandwidthHistory;                                 		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                MinutesSinceLastTest;                             		// 0x0024 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.MeshBeaconClient.ClientBandwidthTestData
// 0x00000014
struct FClientBandwidthTestData
{
//	 vPoperty_Size=6
	unsigned char                                      TestType;                                         		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned char                                      CurrentState;                                     		// 0x0001 (0x0001) [0x0000000000000000]              
	int                                                NumBytesToSendTotal;                              		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                NumBytesSentTotal;                                		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                NumBytesSentLast;                                 		// 0x000C (0x0004) [0x0000000000000000]              
	float                                              ElapsedTestTime;                                  		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.MeshBeaconHost.ClientConnectionBandwidthTestData
// 0x00000028
struct FClientConnectionBandwidthTestData
{
//	 vPoperty_Size=7
	unsigned char                                      CurrentState;                                     		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned char                                      TestType;                                         		// 0x0001 (0x0001) [0x0000000000000000]              
	int                                                BytesTotalNeeded;                                 		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                BytesReceived;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FDouble                                     RequestTestStartTime;                             		// 0x000C (0x0008) [0x0000000000000000]              
	struct FDouble                                     TestStartTime;                                    		// 0x0014 (0x0008) [0x0000000000000000]              
	struct FConnectionBandwidthStats                   BandwidthStats;                                   		// 0x001C (0x000C) [0x0000000000000000]              
};

// ScriptStruct IpDrv.MeshBeaconHost.ClientMeshBeaconConnection
// 0x00000060
struct FClientMeshBeaconConnection
{
//	 vPoperty_Size=a
	struct FUniqueNetId                                PlayerNetId;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              ElapsedHeartbeatTime;                             		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FPointer                                    Socket;                                           		// 0x000C (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	unsigned long                                      bConnectionAccepted : 1;                          		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FClientConnectionBandwidthTestData          BandwidthTest;                                    		// 0x0018 (0x0028) [0x0000000000000000]              
	unsigned char                                      NatType;                                          		// 0x0040 (0x0001) [0x0000000000000000]              
	unsigned long                                      bCanHostVs : 1;                                   		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              GoodHostRatio;                                    		// 0x0048 (0x0004) [0x0000000000000000]              
	TArray< struct FConnectionBandwidthStats >         BandwidthHistory;                                 		// 0x004C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                MinutesSinceLastTest;                             		// 0x005C (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.OnlineEventsInterfaceMcp.EventUploadConfig
// 0x0000001C
struct FEventUploadConfig
{
//	 vPoperty_Size=4
	unsigned char                                      UploadType;                                       		// 0x0000 (0x0001) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     UploadUrl;                                        		// 0x0004 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	float                                              TimeOut;                                          		// 0x0014 (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bUseCompression : 1;                              		// 0x0018 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
};

// ScriptStruct IpDrv.OnlineImageDownloaderWeb.OnlineImageDownload
// 0x00000028
struct FOnlineImageDownload
{
//	 vPoperty_Size=5
	struct FString                                     URL;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UHttpRequestInterface*                       HTTPRequest;                                      		// 0x0010 (0x0008) [0x0000000000000000]              
	unsigned char                                      State;                                            		// 0x0018 (0x0001) [0x0000000000000000]              
	unsigned long                                      bPendingRemoval : 1;                              		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
	class UTexture2DDynamic*                           Texture;                                          		// 0x0020 (0x0008) [0x0000000000000000]              
};

// ScriptStruct IpDrv.OnlineNewsInterfaceMcp.NewsCacheEntry
// 0x00000034
struct FNewsCacheEntry
{
//	 vPoperty_Size=7
	struct FString                                     NewsUrl;                                          		// 0x0000 (0x0010) [0x0000000000400002]              ( CPF_Const | CPF_NeedCtorLink )
	unsigned char                                      ReadState;                                        		// 0x0010 (0x0001) [0x0000000000000000]              
	unsigned char                                      NewsType;                                         		// 0x0011 (0x0001) [0x0000000000000002]              ( CPF_Const )
	struct FString                                     NewsItem;                                         		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              TimeOut;                                          		// 0x0024 (0x0004) [0x0000000000000002]              ( CPF_Const )
	unsigned long                                      bIsUnicode : 1;                                   		// 0x0028 (0x0004) [0x0000000000000002] [0x00000001] ( CPF_Const )
	struct FPointer                                    HttpDownloader;                                   		// 0x002C (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct IpDrv.OnlinePlaylistManager.ConfiguredGameSetting
// 0x0000002C
struct FConfiguredGameSetting
{
//	 vPoperty_Size=4
	int                                                GameSettingId;                                    		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     GameSettingsClassName;                            		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     URL;                                              		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UOnlineGameSettings*                         GameSettings;                                     		// 0x0024 (0x0008) [0x0000000000002000]              ( CPF_Transient )
};

// ScriptStruct IpDrv.OnlinePlaylistManager.InventorySwap
// 0x00000018
struct FInventorySwap
{
//	 vPoperty_Size=2
	struct FName                                       Original;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     SwapTo;                                           		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.OnlinePlaylistManager.Playlist
// 0x0000008C
struct FPlaylist
{
//	 vPoperty_Size=e
	TArray< struct FConfiguredGameSetting >            ConfiguredGames;                                  		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                PlaylistId;                                       		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                LoadBalanceId;                                    		// 0x0014 (0x0004) [0x0000000000000000]              
	struct FString                                     LocalizationString;                               		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< int >                                      ContentIds;                                       		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                TeamSize;                                         		// 0x0038 (0x0004) [0x0000000000000000]              
	int                                                TeamCount;                                        		// 0x003C (0x0004) [0x0000000000000000]              
	int                                                MaxPartySize;                                     		// 0x0040 (0x0004) [0x0000000000000000]              
	struct FString                                     Name;                                             		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     URL;                                              		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                MatchType;                                        		// 0x0064 (0x0004) [0x0000000000000000]              
	unsigned long                                      bDisableDedicatedServerSearches : 1;              		// 0x0068 (0x0004) [0x0000000000000000] [0x00000001] 
	TArray< struct FName >                             MapCycle;                                         		// 0x006C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FInventorySwap >                    InventorySwaps;                                   		// 0x007C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.OnlinePlaylistManager.PlaylistPopulation
// 0x0000000C
struct FPlaylistPopulation
{
//	 vPoperty_Size=3
	int                                                PlaylistId;                                       		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                WorldwideTotal;                                   		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                RegionTotal;                                      		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.OnlineTitleFileDownloadMcp.TitleFileMcp
// 0x0008(0x002C - 0x0024)
struct FTitleFileMcp : FTitleFile
{
//	 vPoperty_Size=1
	struct FPointer                                    HttpDownloader;                                   		// 0x0024 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};

// ScriptStruct IpDrv.PartyBeacon.PlayerReservation
// 0x00000024
struct FPlayerReservation
{
//	 vPoperty_Size=6
	struct FUniqueNetId                                NetId;                                            		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                Skill;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                XpLevel;                                          		// 0x000C (0x0004) [0x0000000000000000]              
	struct FDouble                                     Mu;                                               		// 0x0010 (0x0008) [0x0000000000000000]              
	struct FDouble                                     Sigma;                                            		// 0x0018 (0x0008) [0x0000000000000000]              
	float                                              ElapsedSessionTime;                               		// 0x0020 (0x0004) [0x0000000000000000]              
};

// ScriptStruct IpDrv.PartyBeacon.PartyReservation
// 0x0000001C
struct FPartyReservation
{
//	 vPoperty_Size=3
	int                                                TeamNum;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0004 (0x0008) [0x0000000000000000]              
	TArray< struct FPlayerReservation >                PartyMembers;                                     		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct IpDrv.PartyBeaconHost.ClientBeaconConnection
// 0x00000014
struct FClientBeaconConnection
{
//	 vPoperty_Size=3
	struct FUniqueNetId                                PartyLeader;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              ElapsedHeartbeatTime;                             		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FPointer                                    Socket;                                           		// 0x000C (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
};

// ScriptStruct IpDrv.TitleFileDownloadCache.TitleFileCacheEntry
// 0x002C(0x0050 - 0x0024)
struct FTitleFileCacheEntry : FTitleFile
{
//	 vPoperty_Size=4
	struct FString                                     LogicalName;                                      		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Hash;                                             		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      FileOp;                                           		// 0x0044 (0x0001) [0x0000000000000000]              
	struct FPointer                                    Ar;                                               		// 0x0048 (0x0008) [0x0000000000001002]              ( CPF_Const | CPF_Native )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif