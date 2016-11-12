#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: OnlineSubsystemUPlay_functions.h
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

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.UpdateOnlineGame
// [0x00024400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FName                   SessionName                    ( CPF_Parm )
// class UOnlineGameSettings*     UpdatedGameSettings            ( CPF_Parm )
// unsigned long                  bShouldRefreshOnlineData       ( CPF_OptionalParm | CPF_Parm )

bool UOnlineGameInterfaceUPlay::UpdateOnlineGame ( struct FName SessionName, class UOnlineGameSettings* UpdatedGameSettings, unsigned long bShouldRefreshOnlineData )
{
	static UFunction* pFnUpdateOnlineGame = NULL;

	if ( ! pFnUpdateOnlineGame )
		pFnUpdateOnlineGame = (UFunction*) UObject::GObjObjects()->Data[ 46398 ];

	UOnlineGameInterfaceUPlay_execUpdateOnlineGame_Parms UpdateOnlineGame_Parms;
	memcpy ( &UpdateOnlineGame_Parms.SessionName, &SessionName, 0x8 );
	UpdateOnlineGame_Parms.UpdatedGameSettings = UpdatedGameSettings;
	UpdateOnlineGame_Parms.bShouldRefreshOnlineData = bShouldRefreshOnlineData;

	pFnUpdateOnlineGame->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnUpdateOnlineGame, &UpdateOnlineGame_Parms, NULL );

	pFnUpdateOnlineGame->FunctionFlags |= 0x400;

	return UpdateOnlineGame_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.GetUPlayUserID
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// struct FString                 UserId                         ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UOnlineGameInterfaceUPlay::GetUPlayUserID ( struct FString* UserId )
{
	static UFunction* pFnGetUPlayUserID = NULL;

	if ( ! pFnGetUPlayUserID )
		pFnGetUPlayUserID = (UFunction*) UObject::GObjObjects()->Data[ 46396 ];

	UOnlineGameInterfaceUPlay_execGetUPlayUserID_Parms GetUPlayUserID_Parms;

	pFnGetUPlayUserID->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetUPlayUserID, &GetUPlayUserID_Parms, NULL );

	pFnGetUPlayUserID->FunctionFlags |= 0x400;

	if ( UserId )
		memcpy ( UserId, &GetUPlayUserID_Parms.UserId, 0x10 );
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.TriggerServicesUnavailable
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned long                  showMessage                    ( CPF_Parm )

void UOnlineGameInterfaceUPlay::TriggerServicesUnavailable ( unsigned long showMessage )
{
	static UFunction* pFnTriggerServicesUnavailable = NULL;

	if ( ! pFnTriggerServicesUnavailable )
		pFnTriggerServicesUnavailable = (UFunction*) UObject::GObjObjects()->Data[ 46394 ];

	UOnlineGameInterfaceUPlay_execTriggerServicesUnavailable_Parms TriggerServicesUnavailable_Parms;
	TriggerServicesUnavailable_Parms.showMessage = showMessage;

	pFnTriggerServicesUnavailable->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnTriggerServicesUnavailable, &TriggerServicesUnavailable_Parms, NULL );

	pFnTriggerServicesUnavailable->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.LeaveOnlineGameCompleted
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void UOnlineGameInterfaceUPlay::LeaveOnlineGameCompleted ( class URDVAsyncTask* task )
{
	static UFunction* pFnLeaveOnlineGameCompleted = NULL;

	if ( ! pFnLeaveOnlineGameCompleted )
		pFnLeaveOnlineGameCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46392 ];

	UOnlineGameInterfaceUPlay_execLeaveOnlineGameCompleted_Parms LeaveOnlineGameCompleted_Parms;
	LeaveOnlineGameCompleted_Parms.task = task;

	pFnLeaveOnlineGameCompleted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLeaveOnlineGameCompleted, &LeaveOnlineGameCompleted_Parms, NULL );

	pFnLeaveOnlineGameCompleted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.LeaveOnlineGame
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FName                   SessionName                    ( CPF_Parm )

void UOnlineGameInterfaceUPlay::LeaveOnlineGame ( struct FName SessionName )
{
	static UFunction* pFnLeaveOnlineGame = NULL;

	if ( ! pFnLeaveOnlineGame )
		pFnLeaveOnlineGame = (UFunction*) UObject::GObjObjects()->Data[ 46390 ];

	UOnlineGameInterfaceUPlay_execLeaveOnlineGame_Parms LeaveOnlineGame_Parms;
	memcpy ( &LeaveOnlineGame_Parms.SessionName, &SessionName, 0x8 );

	pFnLeaveOnlineGame->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLeaveOnlineGame, &LeaveOnlineGame_Parms, NULL );

	pFnLeaveOnlineGame->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.DestroyInternetGameCompleted
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void UOnlineGameInterfaceUPlay::DestroyInternetGameCompleted ( class URDVAsyncTask* task )
{
	static UFunction* pFnDestroyInternetGameCompleted = NULL;

	if ( ! pFnDestroyInternetGameCompleted )
		pFnDestroyInternetGameCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46388 ];

	UOnlineGameInterfaceUPlay_execDestroyInternetGameCompleted_Parms DestroyInternetGameCompleted_Parms;
	DestroyInternetGameCompleted_Parms.task = task;

	pFnDestroyInternetGameCompleted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnDestroyInternetGameCompleted, &DestroyInternetGameCompleted_Parms, NULL );

	pFnDestroyInternetGameCompleted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.UpdateSessionCompleted
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void UOnlineGameInterfaceUPlay::UpdateSessionCompleted ( class URDVAsyncTask* task )
{
	static UFunction* pFnUpdateSessionCompleted = NULL;

	if ( ! pFnUpdateSessionCompleted )
		pFnUpdateSessionCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46386 ];

	UOnlineGameInterfaceUPlay_execUpdateSessionCompleted_Parms UpdateSessionCompleted_Parms;
	UpdateSessionCompleted_Parms.task = task;

	pFnUpdateSessionCompleted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnUpdateSessionCompleted, &UpdateSessionCompleted_Parms, NULL );

	pFnUpdateSessionCompleted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.JoinInternetGameByInvite
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            SessionId                      ( CPF_Parm )

void UOnlineGameInterfaceUPlay::JoinInternetGameByInvite ( int SessionId )
{
	static UFunction* pFnJoinInternetGameByInvite = NULL;

	if ( ! pFnJoinInternetGameByInvite )
		pFnJoinInternetGameByInvite = (UFunction*) UObject::GObjObjects()->Data[ 46384 ];

	UOnlineGameInterfaceUPlay_execJoinInternetGameByInvite_Parms JoinInternetGameByInvite_Parms;
	JoinInternetGameByInvite_Parms.SessionId = SessionId;

	pFnJoinInternetGameByInvite->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnJoinInternetGameByInvite, &JoinInternetGameByInvite_Parms, NULL );

	pFnJoinInternetGameByInvite->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.JoinInternetGameCompleted
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void UOnlineGameInterfaceUPlay::JoinInternetGameCompleted ( class URDVAsyncTask* task )
{
	static UFunction* pFnJoinInternetGameCompleted = NULL;

	if ( ! pFnJoinInternetGameCompleted )
		pFnJoinInternetGameCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46382 ];

	UOnlineGameInterfaceUPlay_execJoinInternetGameCompleted_Parms JoinInternetGameCompleted_Parms;
	JoinInternetGameCompleted_Parms.task = task;

	pFnJoinInternetGameCompleted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnJoinInternetGameCompleted, &JoinInternetGameCompleted_Parms, NULL );

	pFnJoinInternetGameCompleted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.SearchSessionsCompleted
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void UOnlineGameInterfaceUPlay::SearchSessionsCompleted ( class URDVAsyncTask* task )
{
	static UFunction* pFnSearchSessionsCompleted = NULL;

	if ( ! pFnSearchSessionsCompleted )
		pFnSearchSessionsCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46380 ];

	UOnlineGameInterfaceUPlay_execSearchSessionsCompleted_Parms SearchSessionsCompleted_Parms;
	SearchSessionsCompleted_Parms.task = task;

	pFnSearchSessionsCompleted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSearchSessionsCompleted, &SearchSessionsCompleted_Parms, NULL );

	pFnSearchSessionsCompleted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnAddHostParticipantCompleted
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void UOnlineGameInterfaceUPlay::OnAddHostParticipantCompleted ( class URDVAsyncTask* task )
{
	static UFunction* pFnOnAddHostParticipantCompleted = NULL;

	if ( ! pFnOnAddHostParticipantCompleted )
		pFnOnAddHostParticipantCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46378 ];

	UOnlineGameInterfaceUPlay_execOnAddHostParticipantCompleted_Parms OnAddHostParticipantCompleted_Parms;
	OnAddHostParticipantCompleted_Parms.task = task;

	pFnOnAddHostParticipantCompleted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnOnAddHostParticipantCompleted, &OnAddHostParticipantCompleted_Parms, NULL );

	pFnOnAddHostParticipantCompleted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnCreateSessionCompleted
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void UOnlineGameInterfaceUPlay::OnCreateSessionCompleted ( class URDVAsyncTask* task )
{
	static UFunction* pFnOnCreateSessionCompleted = NULL;

	if ( ! pFnOnCreateSessionCompleted )
		pFnOnCreateSessionCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46376 ];

	UOnlineGameInterfaceUPlay_execOnCreateSessionCompleted_Parms OnCreateSessionCompleted_Parms;
	OnCreateSessionCompleted_Parms.task = task;

	pFnOnCreateSessionCompleted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnOnCreateSessionCompleted, &OnCreateSessionCompleted_Parms, NULL );

	pFnOnCreateSessionCompleted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.Init
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FPointer                gameSessionClient              ( CPF_Parm )
// class URDVAsyncTaskManager*    asyncTaskManager               ( CPF_Parm )

void UOnlineGameInterfaceUPlay::Init ( struct FPointer gameSessionClient, class URDVAsyncTaskManager* asyncTaskManager )
{
	static UFunction* pFnInit = NULL;

	if ( ! pFnInit )
		pFnInit = (UFunction*) UObject::GObjObjects()->Data[ 46373 ];

	UOnlineGameInterfaceUPlay_execInit_Parms Init_Parms;
	memcpy ( &Init_Parms.gameSessionClient, &gameSessionClient, 0x8 );
	Init_Parms.asyncTaskManager = asyncTaskManager;

	pFnInit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInit, &Init_Parms, NULL );

	pFnInit->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.ShowUPlayMessage
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned char                  MessageType                    ( CPF_Parm )

void UOnlineGameInterfaceUPlay::ShowUPlayMessage ( unsigned char MessageType )
{
	static UFunction* pFnShowUPlayMessage = NULL;

	if ( ! pFnShowUPlayMessage )
		pFnShowUPlayMessage = (UFunction*) UObject::GObjObjects()->Data[ 46371 ];

	UOnlineGameInterfaceUPlay_execShowUPlayMessage_Parms ShowUPlayMessage_Parms;
	ShowUPlayMessage_Parms.MessageType = MessageType;

	pFnShowUPlayMessage->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnShowUPlayMessage, &ShowUPlayMessage_Parms, NULL );

	pFnShowUPlayMessage->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.ClearUPlayInviteDelegate
// [0x00020002] 
// Parameters infos:
// struct FScriptDelegate         UplayInviteDelegate            ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineGameInterfaceUPlay::ClearUPlayInviteDelegate ( struct FScriptDelegate UplayInviteDelegate )
{
	static UFunction* pFnClearUPlayInviteDelegate = NULL;

	if ( ! pFnClearUPlayInviteDelegate )
		pFnClearUPlayInviteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46368 ];

	UOnlineGameInterfaceUPlay_execClearUPlayInviteDelegate_Parms ClearUPlayInviteDelegate_Parms;
	memcpy ( &ClearUPlayInviteDelegate_Parms.UplayInviteDelegate, &UplayInviteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearUPlayInviteDelegate, &ClearUPlayInviteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.AddUPlayInviteDelegate
// [0x00020002] 
// Parameters infos:
// struct FScriptDelegate         UplayInviteDelegate            ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineGameInterfaceUPlay::AddUPlayInviteDelegate ( struct FScriptDelegate UplayInviteDelegate )
{
	static UFunction* pFnAddUPlayInviteDelegate = NULL;

	if ( ! pFnAddUPlayInviteDelegate )
		pFnAddUPlayInviteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46366 ];

	UOnlineGameInterfaceUPlay_execAddUPlayInviteDelegate_Parms AddUPlayInviteDelegate_Parms;
	memcpy ( &AddUPlayInviteDelegate_Parms.UplayInviteDelegate, &UplayInviteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddUPlayInviteDelegate, &AddUPlayInviteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.ClearUPlayMessageDelegate
// [0x00020002] 
// Parameters infos:
// struct FScriptDelegate         UplayMessageDelegate           ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineGameInterfaceUPlay::ClearUPlayMessageDelegate ( struct FScriptDelegate UplayMessageDelegate )
{
	static UFunction* pFnClearUPlayMessageDelegate = NULL;

	if ( ! pFnClearUPlayMessageDelegate )
		pFnClearUPlayMessageDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46363 ];

	UOnlineGameInterfaceUPlay_execClearUPlayMessageDelegate_Parms ClearUPlayMessageDelegate_Parms;
	memcpy ( &ClearUPlayMessageDelegate_Parms.UplayMessageDelegate, &UplayMessageDelegate, 0x10 );

	this->ProcessEvent ( pFnClearUPlayMessageDelegate, &ClearUPlayMessageDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.AddUPlayMessageDelegate
// [0x00020002] 
// Parameters infos:
// struct FScriptDelegate         UplayMessageDelegate           ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineGameInterfaceUPlay::AddUPlayMessageDelegate ( struct FScriptDelegate UplayMessageDelegate )
{
	static UFunction* pFnAddUPlayMessageDelegate = NULL;

	if ( ! pFnAddUPlayMessageDelegate )
		pFnAddUPlayMessageDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46361 ];

	UOnlineGameInterfaceUPlay_execAddUPlayMessageDelegate_Parms AddUPlayMessageDelegate_Parms;
	memcpy ( &AddUPlayMessageDelegate_Parms.UplayMessageDelegate, &UplayMessageDelegate, 0x10 );

	this->ProcessEvent ( pFnAddUPlayMessageDelegate, &AddUPlayMessageDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnUPlayInvite
// [0x00120000] 
// Parameters infos:
// int                            SessionId                      ( CPF_Parm )

void UOnlineGameInterfaceUPlay::OnUPlayInvite ( int SessionId )
{
	static UFunction* pFnOnUPlayInvite = NULL;

	if ( ! pFnOnUPlayInvite )
		pFnOnUPlayInvite = (UFunction*) UObject::GObjObjects()->Data[ 46359 ];

	UOnlineGameInterfaceUPlay_execOnUPlayInvite_Parms OnUPlayInvite_Parms;
	OnUPlayInvite_Parms.SessionId = SessionId;

	this->ProcessEvent ( pFnOnUPlayInvite, &OnUPlayInvite_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineGameInterfaceUPlay.OnUPlayMessage
// [0x00120000] 
// Parameters infos:
// unsigned char                  MessageType                    ( CPF_Parm )

void UOnlineGameInterfaceUPlay::OnUPlayMessage ( unsigned char MessageType )
{
	static UFunction* pFnOnUPlayMessage = NULL;

	if ( ! pFnOnUPlayMessage )
		pFnOnUPlayMessage = (UFunction*) UObject::GObjObjects()->Data[ 46357 ];

	UOnlineGameInterfaceUPlay_execOnUPlayMessage_Parms OnUPlayMessage_Parms;
	OnUPlayMessage_Parms.MessageType = MessageType;

	this->ProcessEvent ( pFnOnUPlayMessage, &OnUPlayMessage_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ConvertLangToUPlay
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 lang                           ( CPF_Const | CPF_Parm | CPF_NeedCtorLink )

int UOnlineSubsystemUPlay::ConvertLangToUPlay ( struct FString lang )
{
	static UFunction* pFnConvertLangToUPlay = NULL;

	if ( ! pFnConvertLangToUPlay )
		pFnConvertLangToUPlay = (UFunction*) UObject::GObjObjects()->Data[ 47097 ];

	UOnlineSubsystemUPlay_execConvertLangToUPlay_Parms ConvertLangToUPlay_Parms;
	memcpy ( &ConvertLangToUPlay_Parms.lang, &lang, 0x10 );

	pFnConvertLangToUPlay->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnConvertLangToUPlay, &ConvertLangToUPlay_Parms, NULL );

	pFnConvertLangToUPlay->FunctionFlags |= 0x400;

	return ConvertLangToUPlay_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.HasPrivilege
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// int                            privilegeId                    ( CPF_Parm )

bool UOnlineSubsystemUPlay::HasPrivilege ( int privilegeId )
{
	static UFunction* pFnHasPrivilege = NULL;

	if ( ! pFnHasPrivilege )
		pFnHasPrivilege = (UFunction*) UObject::GObjObjects()->Data[ 47094 ];

	UOnlineSubsystemUPlay_execHasPrivilege_Parms HasPrivilege_Parms;
	HasPrivilege_Parms.privilegeId = privilegeId;

	pFnHasPrivilege->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnHasPrivilege, &HasPrivilege_Parms, NULL );

	pFnHasPrivilege->FunctionFlags |= 0x400;

	return HasPrivilege_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetAchievements
// [0x00424000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            TitleId                        ( CPF_OptionalParm | CPF_Parm )
// TArray< struct FAchievementDetails > Achievements                   ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

unsigned char UOnlineSubsystemUPlay::GetAchievements ( unsigned char LocalUserNum, int TitleId, TArray< struct FAchievementDetails >* Achievements )
{
	static UFunction* pFnGetAchievements = NULL;

	if ( ! pFnGetAchievements )
		pFnGetAchievements = (UFunction*) UObject::GObjObjects()->Data[ 47088 ];

	UOnlineSubsystemUPlay_execGetAchievements_Parms GetAchievements_Parms;
	GetAchievements_Parms.LocalUserNum = LocalUserNum;
	GetAchievements_Parms.TitleId = TitleId;

	this->ProcessEvent ( pFnGetAchievements, &GetAchievements_Parms, NULL );

	if ( Achievements )
		memcpy ( Achievements, &GetAchievements_Parms.Achievements, 0x10 );

	return GetAchievements_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadAchievementsCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadAchievementsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReadAchievementsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadAchievementsCompleteDelegate )
{
	static UFunction* pFnClearReadAchievementsCompleteDelegate = NULL;

	if ( ! pFnClearReadAchievementsCompleteDelegate )
		pFnClearReadAchievementsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47085 ];

	UOnlineSubsystemUPlay_execClearReadAchievementsCompleteDelegate_Parms ClearReadAchievementsCompleteDelegate_Parms;
	ClearReadAchievementsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearReadAchievementsCompleteDelegate_Parms.ReadAchievementsCompleteDelegate, &ReadAchievementsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReadAchievementsCompleteDelegate, &ClearReadAchievementsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadAchievementsCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadAchievementsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReadAchievementsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadAchievementsCompleteDelegate )
{
	static UFunction* pFnAddReadAchievementsCompleteDelegate = NULL;

	if ( ! pFnAddReadAchievementsCompleteDelegate )
		pFnAddReadAchievementsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47082 ];

	UOnlineSubsystemUPlay_execAddReadAchievementsCompleteDelegate_Parms AddReadAchievementsCompleteDelegate_Parms;
	AddReadAchievementsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddReadAchievementsCompleteDelegate_Parms.ReadAchievementsCompleteDelegate, &ReadAchievementsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReadAchievementsCompleteDelegate, &AddReadAchievementsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadAchievementsComplete
// [0x00120000] 
// Parameters infos:
// int                            TitleId                        ( CPF_Parm )

void UOnlineSubsystemUPlay::OnReadAchievementsComplete ( int TitleId )
{
	static UFunction* pFnOnReadAchievementsComplete = NULL;

	if ( ! pFnOnReadAchievementsComplete )
		pFnOnReadAchievementsComplete = (UFunction*) UObject::GObjObjects()->Data[ 47080 ];

	UOnlineSubsystemUPlay_execOnReadAchievementsComplete_Parms OnReadAchievementsComplete_Parms;
	OnReadAchievementsComplete_Parms.TitleId = TitleId;

	this->ProcessEvent ( pFnOnReadAchievementsComplete, &OnReadAchievementsComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadAchievements
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            TitleId                        ( CPF_OptionalParm | CPF_Parm )
// unsigned long                  bShouldReadText                ( CPF_OptionalParm | CPF_Parm )
// unsigned long                  bShouldReadImages              ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::ReadAchievements ( unsigned char LocalUserNum, int TitleId, unsigned long bShouldReadText, unsigned long bShouldReadImages )
{
	static UFunction* pFnReadAchievements = NULL;

	if ( ! pFnReadAchievements )
		pFnReadAchievements = (UFunction*) UObject::GObjObjects()->Data[ 47074 ];

	UOnlineSubsystemUPlay_execReadAchievements_Parms ReadAchievements_Parms;
	ReadAchievements_Parms.LocalUserNum = LocalUserNum;
	ReadAchievements_Parms.TitleId = TitleId;
	ReadAchievements_Parms.bShouldReadText = bShouldReadText;
	ReadAchievements_Parms.bShouldReadImages = bShouldReadImages;

	this->ProcessEvent ( pFnReadAchievements, &ReadAchievements_Parms, NULL );

	return ReadAchievements_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearUnlockAchievementCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         UnlockAchievementCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearUnlockAchievementCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate UnlockAchievementCompleteDelegate )
{
	static UFunction* pFnClearUnlockAchievementCompleteDelegate = NULL;

	if ( ! pFnClearUnlockAchievementCompleteDelegate )
		pFnClearUnlockAchievementCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47071 ];

	UOnlineSubsystemUPlay_execClearUnlockAchievementCompleteDelegate_Parms ClearUnlockAchievementCompleteDelegate_Parms;
	ClearUnlockAchievementCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearUnlockAchievementCompleteDelegate_Parms.UnlockAchievementCompleteDelegate, &UnlockAchievementCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearUnlockAchievementCompleteDelegate, &ClearUnlockAchievementCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddUnlockAchievementCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         UnlockAchievementCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddUnlockAchievementCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate UnlockAchievementCompleteDelegate )
{
	static UFunction* pFnAddUnlockAchievementCompleteDelegate = NULL;

	if ( ! pFnAddUnlockAchievementCompleteDelegate )
		pFnAddUnlockAchievementCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47068 ];

	UOnlineSubsystemUPlay_execAddUnlockAchievementCompleteDelegate_Parms AddUnlockAchievementCompleteDelegate_Parms;
	AddUnlockAchievementCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddUnlockAchievementCompleteDelegate_Parms.UnlockAchievementCompleteDelegate, &UnlockAchievementCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddUnlockAchievementCompleteDelegate, &AddUnlockAchievementCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnUnlockAchievementComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnUnlockAchievementComplete ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnUnlockAchievementComplete = NULL;

	if ( ! pFnOnUnlockAchievementComplete )
		pFnOnUnlockAchievementComplete = (UFunction*) UObject::GObjObjects()->Data[ 47066 ];

	UOnlineSubsystemUPlay_execOnUnlockAchievementComplete_Parms OnUnlockAchievementComplete_Parms;
	OnUnlockAchievementComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnUnlockAchievementComplete, &OnUnlockAchievementComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnlockAchievement
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            AchievementId                  ( CPF_Parm )
// float                          PercentComplete                ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::UnlockAchievement ( unsigned char LocalUserNum, int AchievementId, float PercentComplete )
{
	static UFunction* pFnUnlockAchievement = NULL;

	if ( ! pFnUnlockAchievement )
		pFnUnlockAchievement = (UFunction*) UObject::GObjObjects()->Data[ 47061 ];

	UOnlineSubsystemUPlay_execUnlockAchievement_Parms UnlockAchievement_Parms;
	UnlockAchievement_Parms.LocalUserNum = LocalUserNum;
	UnlockAchievement_Parms.AchievementId = AchievementId;
	UnlockAchievement_Parms.PercentComplete = PercentComplete;

	this->ProcessEvent ( pFnUnlockAchievement, &UnlockAchievement_Parms, NULL );

	return UnlockAchievement_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.DeleteMessage
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            MessageIndex                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::DeleteMessage ( unsigned char LocalUserNum, int MessageIndex )
{
	static UFunction* pFnDeleteMessage = NULL;

	if ( ! pFnDeleteMessage )
		pFnDeleteMessage = (UFunction*) UObject::GObjObjects()->Data[ 47057 ];

	UOnlineSubsystemUPlay_execDeleteMessage_Parms DeleteMessage_Parms;
	DeleteMessage_Parms.LocalUserNum = LocalUserNum;
	DeleteMessage_Parms.MessageIndex = MessageIndex;

	this->ProcessEvent ( pFnDeleteMessage, &DeleteMessage_Parms, NULL );

	return DeleteMessage_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnmuteAll
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::UnmuteAll ( unsigned char LocalUserNum )
{
	static UFunction* pFnUnmuteAll = NULL;

	if ( ! pFnUnmuteAll )
		pFnUnmuteAll = (UFunction*) UObject::GObjObjects()->Data[ 47054 ];

	UOnlineSubsystemUPlay_execUnmuteAll_Parms UnmuteAll_Parms;
	UnmuteAll_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnUnmuteAll, &UnmuteAll_Parms, NULL );

	return UnmuteAll_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.MuteAll
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// unsigned long                  bAllowFriends                  ( CPF_Parm )

bool UOnlineSubsystemUPlay::MuteAll ( unsigned char LocalUserNum, unsigned long bAllowFriends )
{
	static UFunction* pFnMuteAll = NULL;

	if ( ! pFnMuteAll )
		pFnMuteAll = (UFunction*) UObject::GObjObjects()->Data[ 47050 ];

	UOnlineSubsystemUPlay_execMuteAll_Parms MuteAll_Parms;
	MuteAll_Parms.LocalUserNum = LocalUserNum;
	MuteAll_Parms.bAllowFriends = bAllowFriends;

	this->ProcessEvent ( pFnMuteAll, &MuteAll_Parms, NULL );

	return MuteAll_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFriendMessageReceivedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         MessageDelegate                ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearFriendMessageReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate MessageDelegate )
{
	static UFunction* pFnClearFriendMessageReceivedDelegate = NULL;

	if ( ! pFnClearFriendMessageReceivedDelegate )
		pFnClearFriendMessageReceivedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47047 ];

	UOnlineSubsystemUPlay_execClearFriendMessageReceivedDelegate_Parms ClearFriendMessageReceivedDelegate_Parms;
	ClearFriendMessageReceivedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearFriendMessageReceivedDelegate_Parms.MessageDelegate, &MessageDelegate, 0x10 );

	this->ProcessEvent ( pFnClearFriendMessageReceivedDelegate, &ClearFriendMessageReceivedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendMessageReceivedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         MessageDelegate                ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddFriendMessageReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate MessageDelegate )
{
	static UFunction* pFnAddFriendMessageReceivedDelegate = NULL;

	if ( ! pFnAddFriendMessageReceivedDelegate )
		pFnAddFriendMessageReceivedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47044 ];

	UOnlineSubsystemUPlay_execAddFriendMessageReceivedDelegate_Parms AddFriendMessageReceivedDelegate_Parms;
	AddFriendMessageReceivedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddFriendMessageReceivedDelegate_Parms.MessageDelegate, &MessageDelegate, 0x10 );

	this->ProcessEvent ( pFnAddFriendMessageReceivedDelegate, &AddFriendMessageReceivedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFriendMessageReceived
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            SendingPlayer                  ( CPF_Parm )
// struct FString                 SendingNick                    ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 Message                        ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::OnFriendMessageReceived ( unsigned char LocalUserNum, struct FUniqueNetId SendingPlayer, struct FString SendingNick, struct FString Message )
{
	static UFunction* pFnOnFriendMessageReceived = NULL;

	if ( ! pFnOnFriendMessageReceived )
		pFnOnFriendMessageReceived = (UFunction*) UObject::GObjObjects()->Data[ 47039 ];

	UOnlineSubsystemUPlay_execOnFriendMessageReceived_Parms OnFriendMessageReceived_Parms;
	OnFriendMessageReceived_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &OnFriendMessageReceived_Parms.SendingPlayer, &SendingPlayer, 0x8 );
	memcpy ( &OnFriendMessageReceived_Parms.SendingNick, &SendingNick, 0x10 );
	memcpy ( &OnFriendMessageReceived_Parms.Message, &Message, 0x10 );

	this->ProcessEvent ( pFnOnFriendMessageReceived, &OnFriendMessageReceived_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetFriendMessages
// [0x00420000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// TArray< struct FOnlineFriendMessage > FriendMessages                 ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::GetFriendMessages ( unsigned char LocalUserNum, TArray< struct FOnlineFriendMessage >* FriendMessages )
{
	static UFunction* pFnGetFriendMessages = NULL;

	if ( ! pFnGetFriendMessages )
		pFnGetFriendMessages = (UFunction*) UObject::GObjObjects()->Data[ 47035 ];

	UOnlineSubsystemUPlay_execGetFriendMessages_Parms GetFriendMessages_Parms;
	GetFriendMessages_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnGetFriendMessages, &GetFriendMessages_Parms, NULL );

	if ( FriendMessages )
		memcpy ( FriendMessages, &GetFriendMessages_Parms.FriendMessages, 0x10 );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearJoinFriendGameCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         JoinFriendGameCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearJoinFriendGameCompleteDelegate ( struct FScriptDelegate JoinFriendGameCompleteDelegate )
{
	static UFunction* pFnClearJoinFriendGameCompleteDelegate = NULL;

	if ( ! pFnClearJoinFriendGameCompleteDelegate )
		pFnClearJoinFriendGameCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47033 ];

	UOnlineSubsystemUPlay_execClearJoinFriendGameCompleteDelegate_Parms ClearJoinFriendGameCompleteDelegate_Parms;
	memcpy ( &ClearJoinFriendGameCompleteDelegate_Parms.JoinFriendGameCompleteDelegate, &JoinFriendGameCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearJoinFriendGameCompleteDelegate, &ClearJoinFriendGameCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddJoinFriendGameCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         JoinFriendGameCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddJoinFriendGameCompleteDelegate ( struct FScriptDelegate JoinFriendGameCompleteDelegate )
{
	static UFunction* pFnAddJoinFriendGameCompleteDelegate = NULL;

	if ( ! pFnAddJoinFriendGameCompleteDelegate )
		pFnAddJoinFriendGameCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47031 ];

	UOnlineSubsystemUPlay_execAddJoinFriendGameCompleteDelegate_Parms AddJoinFriendGameCompleteDelegate_Parms;
	memcpy ( &AddJoinFriendGameCompleteDelegate_Parms.JoinFriendGameCompleteDelegate, &JoinFriendGameCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddJoinFriendGameCompleteDelegate, &AddJoinFriendGameCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnJoinFriendGameComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnJoinFriendGameComplete ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnJoinFriendGameComplete = NULL;

	if ( ! pFnOnJoinFriendGameComplete )
		pFnOnJoinFriendGameComplete = (UFunction*) UObject::GObjObjects()->Data[ 47029 ];

	UOnlineSubsystemUPlay_execOnJoinFriendGameComplete_Parms OnJoinFriendGameComplete_Parms;
	OnJoinFriendGameComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnJoinFriendGameComplete, &OnJoinFriendGameComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.JoinFriendGame
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            Friend                         ( CPF_Parm )

bool UOnlineSubsystemUPlay::JoinFriendGame ( unsigned char LocalUserNum, struct FUniqueNetId Friend )
{
	static UFunction* pFnJoinFriendGame = NULL;

	if ( ! pFnJoinFriendGame )
		pFnJoinFriendGame = (UFunction*) UObject::GObjObjects()->Data[ 47025 ];

	UOnlineSubsystemUPlay_execJoinFriendGame_Parms JoinFriendGame_Parms;
	JoinFriendGame_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &JoinFriendGame_Parms.Friend, &Friend, 0x8 );

	this->ProcessEvent ( pFnJoinFriendGame, &JoinFriendGame_Parms, NULL );

	return JoinFriendGame_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReceivedGameInviteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReceivedGameInviteDelegate     ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReceivedGameInviteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReceivedGameInviteDelegate )
{
	static UFunction* pFnClearReceivedGameInviteDelegate = NULL;

	if ( ! pFnClearReceivedGameInviteDelegate )
		pFnClearReceivedGameInviteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47022 ];

	UOnlineSubsystemUPlay_execClearReceivedGameInviteDelegate_Parms ClearReceivedGameInviteDelegate_Parms;
	ClearReceivedGameInviteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearReceivedGameInviteDelegate_Parms.ReceivedGameInviteDelegate, &ReceivedGameInviteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReceivedGameInviteDelegate, &ClearReceivedGameInviteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReceivedGameInviteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReceivedGameInviteDelegate     ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReceivedGameInviteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReceivedGameInviteDelegate )
{
	static UFunction* pFnAddReceivedGameInviteDelegate = NULL;

	if ( ! pFnAddReceivedGameInviteDelegate )
		pFnAddReceivedGameInviteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 47019 ];

	UOnlineSubsystemUPlay_execAddReceivedGameInviteDelegate_Parms AddReceivedGameInviteDelegate_Parms;
	AddReceivedGameInviteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddReceivedGameInviteDelegate_Parms.ReceivedGameInviteDelegate, &ReceivedGameInviteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReceivedGameInviteDelegate, &AddReceivedGameInviteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReceivedGameInvite
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FString                 InviterName                    ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::OnReceivedGameInvite ( unsigned char LocalUserNum, struct FString InviterName )
{
	static UFunction* pFnOnReceivedGameInvite = NULL;

	if ( ! pFnOnReceivedGameInvite )
		pFnOnReceivedGameInvite = (UFunction*) UObject::GObjObjects()->Data[ 47016 ];

	UOnlineSubsystemUPlay_execOnReceivedGameInvite_Parms OnReceivedGameInvite_Parms;
	OnReceivedGameInvite_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &OnReceivedGameInvite_Parms.InviterName, &InviterName, 0x10 );

	this->ProcessEvent ( pFnOnReceivedGameInvite, &OnReceivedGameInvite_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SendGameInviteToFriends
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// TArray< struct FUniqueNetId >  Friends                        ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 Text                           ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::SendGameInviteToFriends ( unsigned char LocalUserNum, TArray< struct FUniqueNetId > Friends, struct FString Text )
{
	static UFunction* pFnSendGameInviteToFriends = NULL;

	if ( ! pFnSendGameInviteToFriends )
		pFnSendGameInviteToFriends = (UFunction*) UObject::GObjObjects()->Data[ 47010 ];

	UOnlineSubsystemUPlay_execSendGameInviteToFriends_Parms SendGameInviteToFriends_Parms;
	SendGameInviteToFriends_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &SendGameInviteToFriends_Parms.Friends, &Friends, 0x10 );
	memcpy ( &SendGameInviteToFriends_Parms.Text, &Text, 0x10 );

	this->ProcessEvent ( pFnSendGameInviteToFriends, &SendGameInviteToFriends_Parms, NULL );

	return SendGameInviteToFriends_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SendGameInviteToFriend
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            Friend                         ( CPF_Parm )
// struct FString                 Text                           ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::SendGameInviteToFriend ( unsigned char LocalUserNum, struct FUniqueNetId Friend, struct FString Text )
{
	static UFunction* pFnSendGameInviteToFriend = NULL;

	if ( ! pFnSendGameInviteToFriend )
		pFnSendGameInviteToFriend = (UFunction*) UObject::GObjObjects()->Data[ 47005 ];

	UOnlineSubsystemUPlay_execSendGameInviteToFriend_Parms SendGameInviteToFriend_Parms;
	SendGameInviteToFriend_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &SendGameInviteToFriend_Parms.Friend, &Friend, 0x8 );
	memcpy ( &SendGameInviteToFriend_Parms.Text, &Text, 0x10 );

	this->ProcessEvent ( pFnSendGameInviteToFriend, &SendGameInviteToFriend_Parms, NULL );

	return SendGameInviteToFriend_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SendMessageToFriend
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            Friend                         ( CPF_Parm )
// struct FString                 Message                        ( CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::SendMessageToFriend ( unsigned char LocalUserNum, struct FUniqueNetId Friend, struct FString Message )
{
	static UFunction* pFnSendMessageToFriend = NULL;

	if ( ! pFnSendMessageToFriend )
		pFnSendMessageToFriend = (UFunction*) UObject::GObjObjects()->Data[ 47000 ];

	UOnlineSubsystemUPlay_execSendMessageToFriend_Parms SendMessageToFriend_Parms;
	SendMessageToFriend_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &SendMessageToFriend_Parms.Friend, &Friend, 0x8 );
	memcpy ( &SendMessageToFriend_Parms.Message, &Message, 0x10 );

	this->ProcessEvent ( pFnSendMessageToFriend, &SendMessageToFriend_Parms, NULL );

	return SendMessageToFriend_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFriendInviteReceivedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         InviteDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearFriendInviteReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate InviteDelegate )
{
	static UFunction* pFnClearFriendInviteReceivedDelegate = NULL;

	if ( ! pFnClearFriendInviteReceivedDelegate )
		pFnClearFriendInviteReceivedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46997 ];

	UOnlineSubsystemUPlay_execClearFriendInviteReceivedDelegate_Parms ClearFriendInviteReceivedDelegate_Parms;
	ClearFriendInviteReceivedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearFriendInviteReceivedDelegate_Parms.InviteDelegate, &InviteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearFriendInviteReceivedDelegate, &ClearFriendInviteReceivedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendInviteReceivedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         InviteDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddFriendInviteReceivedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate InviteDelegate )
{
	static UFunction* pFnAddFriendInviteReceivedDelegate = NULL;

	if ( ! pFnAddFriendInviteReceivedDelegate )
		pFnAddFriendInviteReceivedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46994 ];

	UOnlineSubsystemUPlay_execAddFriendInviteReceivedDelegate_Parms AddFriendInviteReceivedDelegate_Parms;
	AddFriendInviteReceivedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddFriendInviteReceivedDelegate_Parms.InviteDelegate, &InviteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddFriendInviteReceivedDelegate, &AddFriendInviteReceivedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFriendInviteReceived
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            RequestingPlayer               ( CPF_Parm )
// struct FString                 RequestingNick                 ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 Message                        ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::OnFriendInviteReceived ( unsigned char LocalUserNum, struct FUniqueNetId RequestingPlayer, struct FString RequestingNick, struct FString Message )
{
	static UFunction* pFnOnFriendInviteReceived = NULL;

	if ( ! pFnOnFriendInviteReceived )
		pFnOnFriendInviteReceived = (UFunction*) UObject::GObjObjects()->Data[ 46989 ];

	UOnlineSubsystemUPlay_execOnFriendInviteReceived_Parms OnFriendInviteReceived_Parms;
	OnFriendInviteReceived_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &OnFriendInviteReceived_Parms.RequestingPlayer, &RequestingPlayer, 0x8 );
	memcpy ( &OnFriendInviteReceived_Parms.RequestingNick, &RequestingNick, 0x10 );
	memcpy ( &OnFriendInviteReceived_Parms.Message, &Message, 0x10 );

	this->ProcessEvent ( pFnOnFriendInviteReceived, &OnFriendInviteReceived_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RemoveFriend
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            FormerFriend                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::RemoveFriend ( unsigned char LocalUserNum, struct FUniqueNetId FormerFriend )
{
	static UFunction* pFnRemoveFriend = NULL;

	if ( ! pFnRemoveFriend )
		pFnRemoveFriend = (UFunction*) UObject::GObjObjects()->Data[ 46985 ];

	UOnlineSubsystemUPlay_execRemoveFriend_Parms RemoveFriend_Parms;
	RemoveFriend_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &RemoveFriend_Parms.FormerFriend, &FormerFriend, 0x8 );

	this->ProcessEvent ( pFnRemoveFriend, &RemoveFriend_Parms, NULL );

	return RemoveFriend_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.DenyFriendInvite
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            RequestingPlayer               ( CPF_Parm )

bool UOnlineSubsystemUPlay::DenyFriendInvite ( unsigned char LocalUserNum, struct FUniqueNetId RequestingPlayer )
{
	static UFunction* pFnDenyFriendInvite = NULL;

	if ( ! pFnDenyFriendInvite )
		pFnDenyFriendInvite = (UFunction*) UObject::GObjObjects()->Data[ 46981 ];

	UOnlineSubsystemUPlay_execDenyFriendInvite_Parms DenyFriendInvite_Parms;
	DenyFriendInvite_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &DenyFriendInvite_Parms.RequestingPlayer, &RequestingPlayer, 0x8 );

	this->ProcessEvent ( pFnDenyFriendInvite, &DenyFriendInvite_Parms, NULL );

	return DenyFriendInvite_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AcceptFriendInvite
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            RequestingPlayer               ( CPF_Parm )

bool UOnlineSubsystemUPlay::AcceptFriendInvite ( unsigned char LocalUserNum, struct FUniqueNetId RequestingPlayer )
{
	static UFunction* pFnAcceptFriendInvite = NULL;

	if ( ! pFnAcceptFriendInvite )
		pFnAcceptFriendInvite = (UFunction*) UObject::GObjObjects()->Data[ 46977 ];

	UOnlineSubsystemUPlay_execAcceptFriendInvite_Parms AcceptFriendInvite_Parms;
	AcceptFriendInvite_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AcceptFriendInvite_Parms.RequestingPlayer, &RequestingPlayer, 0x8 );

	this->ProcessEvent ( pFnAcceptFriendInvite, &AcceptFriendInvite_Parms, NULL );

	return AcceptFriendInvite_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearAddFriendByNameCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         FriendDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearAddFriendByNameCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendDelegate )
{
	static UFunction* pFnClearAddFriendByNameCompleteDelegate = NULL;

	if ( ! pFnClearAddFriendByNameCompleteDelegate )
		pFnClearAddFriendByNameCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46974 ];

	UOnlineSubsystemUPlay_execClearAddFriendByNameCompleteDelegate_Parms ClearAddFriendByNameCompleteDelegate_Parms;
	ClearAddFriendByNameCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearAddFriendByNameCompleteDelegate_Parms.FriendDelegate, &FriendDelegate, 0x10 );

	this->ProcessEvent ( pFnClearAddFriendByNameCompleteDelegate, &ClearAddFriendByNameCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddAddFriendByNameCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         FriendDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddAddFriendByNameCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendDelegate )
{
	static UFunction* pFnAddAddFriendByNameCompleteDelegate = NULL;

	if ( ! pFnAddAddFriendByNameCompleteDelegate )
		pFnAddAddFriendByNameCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46971 ];

	UOnlineSubsystemUPlay_execAddAddFriendByNameCompleteDelegate_Parms AddAddFriendByNameCompleteDelegate_Parms;
	AddAddFriendByNameCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddAddFriendByNameCompleteDelegate_Parms.FriendDelegate, &FriendDelegate, 0x10 );

	this->ProcessEvent ( pFnAddAddFriendByNameCompleteDelegate, &AddAddFriendByNameCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnAddFriendByNameComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnAddFriendByNameComplete ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnAddFriendByNameComplete = NULL;

	if ( ! pFnOnAddFriendByNameComplete )
		pFnOnAddFriendByNameComplete = (UFunction*) UObject::GObjObjects()->Data[ 46969 ];

	UOnlineSubsystemUPlay_execOnAddFriendByNameComplete_Parms OnAddFriendByNameComplete_Parms;
	OnAddFriendByNameComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnAddFriendByNameComplete, &OnAddFriendByNameComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendByName
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FString                 FriendName                     ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 Message                        ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::AddFriendByName ( unsigned char LocalUserNum, struct FString FriendName, struct FString Message )
{
	static UFunction* pFnAddFriendByName = NULL;

	if ( ! pFnAddFriendByName )
		pFnAddFriendByName = (UFunction*) UObject::GObjObjects()->Data[ 46964 ];

	UOnlineSubsystemUPlay_execAddFriendByName_Parms AddFriendByName_Parms;
	AddFriendByName_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddFriendByName_Parms.FriendName, &FriendName, 0x10 );
	memcpy ( &AddFriendByName_Parms.Message, &Message, 0x10 );

	this->ProcessEvent ( pFnAddFriendByName, &AddFriendByName_Parms, NULL );

	return AddFriendByName_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriend
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            NewFriend                      ( CPF_Parm )
// struct FString                 Message                        ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::AddFriend ( unsigned char LocalUserNum, struct FUniqueNetId NewFriend, struct FString Message )
{
	static UFunction* pFnAddFriend = NULL;

	if ( ! pFnAddFriend )
		pFnAddFriend = (UFunction*) UObject::GObjObjects()->Data[ 46959 ];

	UOnlineSubsystemUPlay_execAddFriend_Parms AddFriend_Parms;
	AddFriend_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddFriend_Parms.NewFriend, &NewFriend, 0x8 );
	memcpy ( &AddFriend_Parms.Message, &Message, 0x10 );

	this->ProcessEvent ( pFnAddFriend, &AddFriend_Parms, NULL );

	return AddFriend_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearWritePlayerStorageCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         WritePlayerStorageCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearWritePlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WritePlayerStorageCompleteDelegate )
{
	static UFunction* pFnClearWritePlayerStorageCompleteDelegate = NULL;

	if ( ! pFnClearWritePlayerStorageCompleteDelegate )
		pFnClearWritePlayerStorageCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46956 ];

	UOnlineSubsystemUPlay_execClearWritePlayerStorageCompleteDelegate_Parms ClearWritePlayerStorageCompleteDelegate_Parms;
	ClearWritePlayerStorageCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearWritePlayerStorageCompleteDelegate_Parms.WritePlayerStorageCompleteDelegate, &WritePlayerStorageCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearWritePlayerStorageCompleteDelegate, &ClearWritePlayerStorageCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WritePlayerStorage
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// class UOnlinePlayerStorage*    PlayerStorage                  ( CPF_Parm )
// int                            DeviceID                       ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::WritePlayerStorage ( unsigned char LocalUserNum, class UOnlinePlayerStorage* PlayerStorage, int DeviceID )
{
	static UFunction* pFnWritePlayerStorage = NULL;

	if ( ! pFnWritePlayerStorage )
		pFnWritePlayerStorage = (UFunction*) UObject::GObjObjects()->Data[ 46951 ];

	UOnlineSubsystemUPlay_execWritePlayerStorage_Parms WritePlayerStorage_Parms;
	WritePlayerStorage_Parms.LocalUserNum = LocalUserNum;
	WritePlayerStorage_Parms.PlayerStorage = PlayerStorage;
	WritePlayerStorage_Parms.DeviceID = DeviceID;

	this->ProcessEvent ( pFnWritePlayerStorage, &WritePlayerStorage_Parms, NULL );

	return WritePlayerStorage_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetPlayerStorage
// [0x00020002] 
// Parameters infos:
// class UOnlinePlayerStorage*    ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

class UOnlinePlayerStorage* UOnlineSubsystemUPlay::GetPlayerStorage ( unsigned char LocalUserNum )
{
	static UFunction* pFnGetPlayerStorage = NULL;

	if ( ! pFnGetPlayerStorage )
		pFnGetPlayerStorage = (UFunction*) UObject::GObjObjects()->Data[ 46948 ];

	UOnlineSubsystemUPlay_execGetPlayerStorage_Parms GetPlayerStorage_Parms;
	GetPlayerStorage_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnGetPlayerStorage, &GetPlayerStorage_Parms, NULL );

	return GetPlayerStorage_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadPlayerStorageCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadPlayerStorageCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReadPlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadPlayerStorageCompleteDelegate )
{
	static UFunction* pFnClearReadPlayerStorageCompleteDelegate = NULL;

	if ( ! pFnClearReadPlayerStorageCompleteDelegate )
		pFnClearReadPlayerStorageCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46945 ];

	UOnlineSubsystemUPlay_execClearReadPlayerStorageCompleteDelegate_Parms ClearReadPlayerStorageCompleteDelegate_Parms;
	ClearReadPlayerStorageCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearReadPlayerStorageCompleteDelegate_Parms.ReadPlayerStorageCompleteDelegate, &ReadPlayerStorageCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReadPlayerStorageCompleteDelegate, &ClearReadPlayerStorageCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadPlayerStorageCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadPlayerStorageCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReadPlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadPlayerStorageCompleteDelegate )
{
	static UFunction* pFnAddReadPlayerStorageCompleteDelegate = NULL;

	if ( ! pFnAddReadPlayerStorageCompleteDelegate )
		pFnAddReadPlayerStorageCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46942 ];

	UOnlineSubsystemUPlay_execAddReadPlayerStorageCompleteDelegate_Parms AddReadPlayerStorageCompleteDelegate_Parms;
	AddReadPlayerStorageCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddReadPlayerStorageCompleteDelegate_Parms.ReadPlayerStorageCompleteDelegate, &ReadPlayerStorageCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReadPlayerStorageCompleteDelegate, &AddReadPlayerStorageCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadPlayerStorageComplete
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnReadPlayerStorageComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful )
{
	static UFunction* pFnOnReadPlayerStorageComplete = NULL;

	if ( ! pFnOnReadPlayerStorageComplete )
		pFnOnReadPlayerStorageComplete = (UFunction*) UObject::GObjObjects()->Data[ 46939 ];

	UOnlineSubsystemUPlay_execOnReadPlayerStorageComplete_Parms OnReadPlayerStorageComplete_Parms;
	OnReadPlayerStorageComplete_Parms.LocalUserNum = LocalUserNum;
	OnReadPlayerStorageComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnReadPlayerStorageComplete, &OnReadPlayerStorageComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadPlayerStorage
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// class UOnlinePlayerStorage*    PlayerStorage                  ( CPF_Parm )
// int                            DeviceID                       ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::ReadPlayerStorage ( unsigned char LocalUserNum, class UOnlinePlayerStorage* PlayerStorage, int DeviceID )
{
	static UFunction* pFnReadPlayerStorage = NULL;

	if ( ! pFnReadPlayerStorage )
		pFnReadPlayerStorage = (UFunction*) UObject::GObjObjects()->Data[ 46934 ];

	UOnlineSubsystemUPlay_execReadPlayerStorage_Parms ReadPlayerStorage_Parms;
	ReadPlayerStorage_Parms.LocalUserNum = LocalUserNum;
	ReadPlayerStorage_Parms.PlayerStorage = PlayerStorage;
	ReadPlayerStorage_Parms.DeviceID = DeviceID;

	this->ProcessEvent ( pFnReadPlayerStorage, &ReadPlayerStorage_Parms, NULL );

	return ReadPlayerStorage_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadPlayerStorageForNetIdCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FUniqueNetId            NetId                          ( CPF_Parm )
// struct FScriptDelegate         ReadPlayerStorageForNetIdCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReadPlayerStorageForNetIdCompleteDelegate ( struct FUniqueNetId NetId, struct FScriptDelegate ReadPlayerStorageForNetIdCompleteDelegate )
{
	static UFunction* pFnClearReadPlayerStorageForNetIdCompleteDelegate = NULL;

	if ( ! pFnClearReadPlayerStorageForNetIdCompleteDelegate )
		pFnClearReadPlayerStorageForNetIdCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46931 ];

	UOnlineSubsystemUPlay_execClearReadPlayerStorageForNetIdCompleteDelegate_Parms ClearReadPlayerStorageForNetIdCompleteDelegate_Parms;
	memcpy ( &ClearReadPlayerStorageForNetIdCompleteDelegate_Parms.NetId, &NetId, 0x8 );
	memcpy ( &ClearReadPlayerStorageForNetIdCompleteDelegate_Parms.ReadPlayerStorageForNetIdCompleteDelegate, &ReadPlayerStorageForNetIdCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReadPlayerStorageForNetIdCompleteDelegate, &ClearReadPlayerStorageForNetIdCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadPlayerStorageForNetId
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            NetId                          ( CPF_Parm )
// class UOnlinePlayerStorage*    PlayerStorage                  ( CPF_Parm )

bool UOnlineSubsystemUPlay::ReadPlayerStorageForNetId ( unsigned char LocalUserNum, struct FUniqueNetId NetId, class UOnlinePlayerStorage* PlayerStorage )
{
	static UFunction* pFnReadPlayerStorageForNetId = NULL;

	if ( ! pFnReadPlayerStorageForNetId )
		pFnReadPlayerStorageForNetId = (UFunction*) UObject::GObjObjects()->Data[ 46926 ];

	UOnlineSubsystemUPlay_execReadPlayerStorageForNetId_Parms ReadPlayerStorageForNetId_Parms;
	ReadPlayerStorageForNetId_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ReadPlayerStorageForNetId_Parms.NetId, &NetId, 0x8 );
	ReadPlayerStorageForNetId_Parms.PlayerStorage = PlayerStorage;

	this->ProcessEvent ( pFnReadPlayerStorageForNetId, &ReadPlayerStorageForNetId_Parms, NULL );

	return ReadPlayerStorageForNetId_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadPlayerStorageForNetIdCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FUniqueNetId            NetId                          ( CPF_Parm )
// struct FScriptDelegate         ReadPlayerStorageForNetIdCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReadPlayerStorageForNetIdCompleteDelegate ( struct FUniqueNetId NetId, struct FScriptDelegate ReadPlayerStorageForNetIdCompleteDelegate )
{
	static UFunction* pFnAddReadPlayerStorageForNetIdCompleteDelegate = NULL;

	if ( ! pFnAddReadPlayerStorageForNetIdCompleteDelegate )
		pFnAddReadPlayerStorageForNetIdCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46923 ];

	UOnlineSubsystemUPlay_execAddReadPlayerStorageForNetIdCompleteDelegate_Parms AddReadPlayerStorageForNetIdCompleteDelegate_Parms;
	memcpy ( &AddReadPlayerStorageForNetIdCompleteDelegate_Parms.NetId, &NetId, 0x8 );
	memcpy ( &AddReadPlayerStorageForNetIdCompleteDelegate_Parms.ReadPlayerStorageForNetIdCompleteDelegate, &ReadPlayerStorageForNetIdCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReadPlayerStorageForNetIdCompleteDelegate, &AddReadPlayerStorageForNetIdCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadPlayerStorageForNetIdComplete
// [0x00120000] 
// Parameters infos:
// struct FUniqueNetId            NetId                          ( CPF_Parm )
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnReadPlayerStorageForNetIdComplete ( struct FUniqueNetId NetId, unsigned long bWasSuccessful )
{
	static UFunction* pFnOnReadPlayerStorageForNetIdComplete = NULL;

	if ( ! pFnOnReadPlayerStorageForNetIdComplete )
		pFnOnReadPlayerStorageForNetIdComplete = (UFunction*) UObject::GObjObjects()->Data[ 46920 ];

	UOnlineSubsystemUPlay_execOnReadPlayerStorageForNetIdComplete_Parms OnReadPlayerStorageForNetIdComplete_Parms;
	memcpy ( &OnReadPlayerStorageForNetIdComplete_Parms.NetId, &NetId, 0x8 );
	OnReadPlayerStorageForNetIdComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnReadPlayerStorageForNetIdComplete, &OnReadPlayerStorageForNetIdComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddWritePlayerStorageCompleteDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         WritePlayerStorageCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddWritePlayerStorageCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WritePlayerStorageCompleteDelegate )
{
	static UFunction* pFnAddWritePlayerStorageCompleteDelegate = NULL;

	if ( ! pFnAddWritePlayerStorageCompleteDelegate )
		pFnAddWritePlayerStorageCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46917 ];

	UOnlineSubsystemUPlay_execAddWritePlayerStorageCompleteDelegate_Parms AddWritePlayerStorageCompleteDelegate_Parms;
	AddWritePlayerStorageCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddWritePlayerStorageCompleteDelegate_Parms.WritePlayerStorageCompleteDelegate, &WritePlayerStorageCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddWritePlayerStorageCompleteDelegate, &AddWritePlayerStorageCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnWritePlayerStorageComplete
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnWritePlayerStorageComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful )
{
	static UFunction* pFnOnWritePlayerStorageComplete = NULL;

	if ( ! pFnOnWritePlayerStorageComplete )
		pFnOnWritePlayerStorageComplete = (UFunction*) UObject::GObjObjects()->Data[ 46914 ];

	UOnlineSubsystemUPlay_execOnWritePlayerStorageComplete_Parms OnWritePlayerStorageComplete_Parms;
	OnWritePlayerStorageComplete_Parms.LocalUserNum = LocalUserNum;
	OnWritePlayerStorageComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnWritePlayerStorageComplete, &OnWritePlayerStorageComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetKeyboardInputResults
// [0x00420000] 
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
// unsigned char                  bWasCanceled                   ( CPF_Parm | CPF_OutParm )

struct FString UOnlineSubsystemUPlay::GetKeyboardInputResults ( unsigned char* bWasCanceled )
{
	static UFunction* pFnGetKeyboardInputResults = NULL;

	if ( ! pFnGetKeyboardInputResults )
		pFnGetKeyboardInputResults = (UFunction*) UObject::GObjObjects()->Data[ 46911 ];

	UOnlineSubsystemUPlay_execGetKeyboardInputResults_Parms GetKeyboardInputResults_Parms;

	this->ProcessEvent ( pFnGetKeyboardInputResults, &GetKeyboardInputResults_Parms, NULL );

	if ( bWasCanceled )
		*bWasCanceled = GetKeyboardInputResults_Parms.bWasCanceled;

	return GetKeyboardInputResults_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearKeyboardInputDoneDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         InputDelegate                  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearKeyboardInputDoneDelegate ( struct FScriptDelegate InputDelegate )
{
	static UFunction* pFnClearKeyboardInputDoneDelegate = NULL;

	if ( ! pFnClearKeyboardInputDoneDelegate )
		pFnClearKeyboardInputDoneDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46909 ];

	UOnlineSubsystemUPlay_execClearKeyboardInputDoneDelegate_Parms ClearKeyboardInputDoneDelegate_Parms;
	memcpy ( &ClearKeyboardInputDoneDelegate_Parms.InputDelegate, &InputDelegate, 0x10 );

	this->ProcessEvent ( pFnClearKeyboardInputDoneDelegate, &ClearKeyboardInputDoneDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddKeyboardInputDoneDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         InputDelegate                  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddKeyboardInputDoneDelegate ( struct FScriptDelegate InputDelegate )
{
	static UFunction* pFnAddKeyboardInputDoneDelegate = NULL;

	if ( ! pFnAddKeyboardInputDoneDelegate )
		pFnAddKeyboardInputDoneDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46907 ];

	UOnlineSubsystemUPlay_execAddKeyboardInputDoneDelegate_Parms AddKeyboardInputDoneDelegate_Parms;
	memcpy ( &AddKeyboardInputDoneDelegate_Parms.InputDelegate, &InputDelegate, 0x10 );

	this->ProcessEvent ( pFnAddKeyboardInputDoneDelegate, &AddKeyboardInputDoneDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnKeyboardInputComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnKeyboardInputComplete ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnKeyboardInputComplete = NULL;

	if ( ! pFnOnKeyboardInputComplete )
		pFnOnKeyboardInputComplete = (UFunction*) UObject::GObjObjects()->Data[ 46905 ];

	UOnlineSubsystemUPlay_execOnKeyboardInputComplete_Parms OnKeyboardInputComplete_Parms;
	OnKeyboardInputComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnKeyboardInputComplete, &OnKeyboardInputComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowKeyboardUI
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FString                 TitleText                      ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 DescriptionText                ( CPF_Parm | CPF_NeedCtorLink )
// unsigned long                  bIsPassword                    ( CPF_OptionalParm | CPF_Parm )
// unsigned long                  bShouldValidate                ( CPF_OptionalParm | CPF_Parm )
// struct FString                 DefaultText                    ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
// int                            MaxResultLength                ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::ShowKeyboardUI ( unsigned char LocalUserNum, struct FString TitleText, struct FString DescriptionText, unsigned long bIsPassword, unsigned long bShouldValidate, struct FString DefaultText, int MaxResultLength )
{
	static UFunction* pFnShowKeyboardUI = NULL;

	if ( ! pFnShowKeyboardUI )
		pFnShowKeyboardUI = (UFunction*) UObject::GObjObjects()->Data[ 46896 ];

	UOnlineSubsystemUPlay_execShowKeyboardUI_Parms ShowKeyboardUI_Parms;
	ShowKeyboardUI_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ShowKeyboardUI_Parms.TitleText, &TitleText, 0x10 );
	memcpy ( &ShowKeyboardUI_Parms.DescriptionText, &DescriptionText, 0x10 );
	ShowKeyboardUI_Parms.bIsPassword = bIsPassword;
	ShowKeyboardUI_Parms.bShouldValidate = bShouldValidate;
	memcpy ( &ShowKeyboardUI_Parms.DefaultText, &DefaultText, 0x10 );
	ShowKeyboardUI_Parms.MaxResultLength = MaxResultLength;

	this->ProcessEvent ( pFnShowKeyboardUI, &ShowKeyboardUI_Parms, NULL );

	return ShowKeyboardUI_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetOnlineStatus
// [0x00420000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            StatusId                       ( CPF_Parm )
// TArray< struct FLocalizedStringSetting > LocalizedStringSettings        ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
// TArray< struct FSettingsProperty > Properties                     ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::SetOnlineStatus ( unsigned char LocalUserNum, int StatusId, TArray< struct FLocalizedStringSetting >* LocalizedStringSettings, TArray< struct FSettingsProperty >* Properties )
{
	static UFunction* pFnSetOnlineStatus = NULL;

	if ( ! pFnSetOnlineStatus )
		pFnSetOnlineStatus = (UFunction*) UObject::GObjObjects()->Data[ 46889 ];

	UOnlineSubsystemUPlay_execSetOnlineStatus_Parms SetOnlineStatus_Parms;
	SetOnlineStatus_Parms.LocalUserNum = LocalUserNum;
	SetOnlineStatus_Parms.StatusId = StatusId;

	this->ProcessEvent ( pFnSetOnlineStatus, &SetOnlineStatus_Parms, NULL );

	if ( LocalizedStringSettings )
		memcpy ( LocalizedStringSettings, &SetOnlineStatus_Parms.LocalizedStringSettings, 0x10 );

	if ( Properties )
		memcpy ( Properties, &SetOnlineStatus_Parms.Properties, 0x10 );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearStorageDeviceChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         StorageDeviceChangeDelegate    ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearStorageDeviceChangeDelegate ( struct FScriptDelegate StorageDeviceChangeDelegate )
{
	static UFunction* pFnClearStorageDeviceChangeDelegate = NULL;

	if ( ! pFnClearStorageDeviceChangeDelegate )
		pFnClearStorageDeviceChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46887 ];

	UOnlineSubsystemUPlay_execClearStorageDeviceChangeDelegate_Parms ClearStorageDeviceChangeDelegate_Parms;
	memcpy ( &ClearStorageDeviceChangeDelegate_Parms.StorageDeviceChangeDelegate, &StorageDeviceChangeDelegate, 0x10 );

	this->ProcessEvent ( pFnClearStorageDeviceChangeDelegate, &ClearStorageDeviceChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddStorageDeviceChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         StorageDeviceChangeDelegate    ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddStorageDeviceChangeDelegate ( struct FScriptDelegate StorageDeviceChangeDelegate )
{
	static UFunction* pFnAddStorageDeviceChangeDelegate = NULL;

	if ( ! pFnAddStorageDeviceChangeDelegate )
		pFnAddStorageDeviceChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46885 ];

	UOnlineSubsystemUPlay_execAddStorageDeviceChangeDelegate_Parms AddStorageDeviceChangeDelegate_Parms;
	memcpy ( &AddStorageDeviceChangeDelegate_Parms.StorageDeviceChangeDelegate, &StorageDeviceChangeDelegate, 0x10 );

	this->ProcessEvent ( pFnAddStorageDeviceChangeDelegate, &AddStorageDeviceChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnStorageDeviceChange
// [0x00120000] 
// Parameters infos:

void UOnlineSubsystemUPlay::OnStorageDeviceChange ( )
{
	static UFunction* pFnOnStorageDeviceChange = NULL;

	if ( ! pFnOnStorageDeviceChange )
		pFnOnStorageDeviceChange = (UFunction*) UObject::GObjObjects()->Data[ 46884 ];

	UOnlineSubsystemUPlay_execOnStorageDeviceChange_Parms OnStorageDeviceChange_Parms;

	this->ProcessEvent ( pFnOnStorageDeviceChange, &OnStorageDeviceChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetLocale
// [0x00020002] 
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

int UOnlineSubsystemUPlay::GetLocale ( )
{
	static UFunction* pFnGetLocale = NULL;

	if ( ! pFnGetLocale )
		pFnGetLocale = (UFunction*) UObject::GObjObjects()->Data[ 46882 ];

	UOnlineSubsystemUPlay_execGetLocale_Parms GetLocale_Parms;

	this->ProcessEvent ( pFnGetLocale, &GetLocale_Parms, NULL );

	return GetLocale_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetNATType
// [0x00020002] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

unsigned char UOnlineSubsystemUPlay::GetNATType ( )
{
	static UFunction* pFnGetNATType = NULL;

	if ( ! pFnGetNATType )
		pFnGetNATType = (UFunction*) UObject::GObjObjects()->Data[ 46880 ];

	UOnlineSubsystemUPlay_execGetNATType_Parms GetNATType_Parms;

	this->ProcessEvent ( pFnGetNATType, &GetNATType_Parms, NULL );

	return GetNATType_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearConnectionStatusChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ConnectionStatusDelegate       ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearConnectionStatusChangeDelegate ( struct FScriptDelegate ConnectionStatusDelegate )
{
	static UFunction* pFnClearConnectionStatusChangeDelegate = NULL;

	if ( ! pFnClearConnectionStatusChangeDelegate )
		pFnClearConnectionStatusChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46878 ];

	UOnlineSubsystemUPlay_execClearConnectionStatusChangeDelegate_Parms ClearConnectionStatusChangeDelegate_Parms;
	memcpy ( &ClearConnectionStatusChangeDelegate_Parms.ConnectionStatusDelegate, &ConnectionStatusDelegate, 0x10 );

	this->ProcessEvent ( pFnClearConnectionStatusChangeDelegate, &ClearConnectionStatusChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddConnectionStatusChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ConnectionStatusDelegate       ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddConnectionStatusChangeDelegate ( struct FScriptDelegate ConnectionStatusDelegate )
{
	static UFunction* pFnAddConnectionStatusChangeDelegate = NULL;

	if ( ! pFnAddConnectionStatusChangeDelegate )
		pFnAddConnectionStatusChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46876 ];

	UOnlineSubsystemUPlay_execAddConnectionStatusChangeDelegate_Parms AddConnectionStatusChangeDelegate_Parms;
	memcpy ( &AddConnectionStatusChangeDelegate_Parms.ConnectionStatusDelegate, &ConnectionStatusDelegate, 0x10 );

	this->ProcessEvent ( pFnAddConnectionStatusChangeDelegate, &AddConnectionStatusChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnConnectionStatusChange
// [0x00120000] 
// Parameters infos:
// unsigned char                  ConnectionStatus               ( CPF_Parm )

void UOnlineSubsystemUPlay::OnConnectionStatusChange ( unsigned char ConnectionStatus )
{
	static UFunction* pFnOnConnectionStatusChange = NULL;

	if ( ! pFnOnConnectionStatusChange )
		pFnOnConnectionStatusChange = (UFunction*) UObject::GObjObjects()->Data[ 46874 ];

	UOnlineSubsystemUPlay_execOnConnectionStatusChange_Parms OnConnectionStatusChange_Parms;
	OnConnectionStatusChange_Parms.ConnectionStatus = ConnectionStatus;

	this->ProcessEvent ( pFnOnConnectionStatusChange, &OnConnectionStatusChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsControllerConnected
// [0x00020002] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// int                            ControllerId                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsControllerConnected ( int ControllerId )
{
	static UFunction* pFnIsControllerConnected = NULL;

	if ( ! pFnIsControllerConnected )
		pFnIsControllerConnected = (UFunction*) UObject::GObjObjects()->Data[ 46871 ];

	UOnlineSubsystemUPlay_execIsControllerConnected_Parms IsControllerConnected_Parms;
	IsControllerConnected_Parms.ControllerId = ControllerId;

	this->ProcessEvent ( pFnIsControllerConnected, &IsControllerConnected_Parms, NULL );

	return IsControllerConnected_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearControllerChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ControllerChangeDelegate       ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearControllerChangeDelegate ( struct FScriptDelegate ControllerChangeDelegate )
{
	static UFunction* pFnClearControllerChangeDelegate = NULL;

	if ( ! pFnClearControllerChangeDelegate )
		pFnClearControllerChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46869 ];

	UOnlineSubsystemUPlay_execClearControllerChangeDelegate_Parms ClearControllerChangeDelegate_Parms;
	memcpy ( &ClearControllerChangeDelegate_Parms.ControllerChangeDelegate, &ControllerChangeDelegate, 0x10 );

	this->ProcessEvent ( pFnClearControllerChangeDelegate, &ClearControllerChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddControllerChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ControllerChangeDelegate       ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddControllerChangeDelegate ( struct FScriptDelegate ControllerChangeDelegate )
{
	static UFunction* pFnAddControllerChangeDelegate = NULL;

	if ( ! pFnAddControllerChangeDelegate )
		pFnAddControllerChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46867 ];

	UOnlineSubsystemUPlay_execAddControllerChangeDelegate_Parms AddControllerChangeDelegate_Parms;
	memcpy ( &AddControllerChangeDelegate_Parms.ControllerChangeDelegate, &ControllerChangeDelegate, 0x10 );

	this->ProcessEvent ( pFnAddControllerChangeDelegate, &AddControllerChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnControllerChange
// [0x00120000] 
// Parameters infos:
// int                            ControllerId                   ( CPF_Parm )
// unsigned long                  bIsConnected                   ( CPF_Parm )

void UOnlineSubsystemUPlay::OnControllerChange ( int ControllerId, unsigned long bIsConnected )
{
	static UFunction* pFnOnControllerChange = NULL;

	if ( ! pFnOnControllerChange )
		pFnOnControllerChange = (UFunction*) UObject::GObjObjects()->Data[ 46864 ];

	UOnlineSubsystemUPlay_execOnControllerChange_Parms OnControllerChange_Parms;
	OnControllerChange_Parms.ControllerId = ControllerId;
	OnControllerChange_Parms.bIsConnected = bIsConnected;

	this->ProcessEvent ( pFnOnControllerChange, &OnControllerChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetNetworkNotificationPosition
// [0x00020000] 
// Parameters infos:
// unsigned char                  NewPos                         ( CPF_Parm )

void UOnlineSubsystemUPlay::SetNetworkNotificationPosition ( unsigned char NewPos )
{
	static UFunction* pFnSetNetworkNotificationPosition = NULL;

	if ( ! pFnSetNetworkNotificationPosition )
		pFnSetNetworkNotificationPosition = (UFunction*) UObject::GObjObjects()->Data[ 46862 ];

	UOnlineSubsystemUPlay_execSetNetworkNotificationPosition_Parms SetNetworkNotificationPosition_Parms;
	SetNetworkNotificationPosition_Parms.NewPos = NewPos;

	this->ProcessEvent ( pFnSetNetworkNotificationPosition, &SetNetworkNotificationPosition_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetNetworkNotificationPosition
// [0x00020000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

unsigned char UOnlineSubsystemUPlay::GetNetworkNotificationPosition ( )
{
	static UFunction* pFnGetNetworkNotificationPosition = NULL;

	if ( ! pFnGetNetworkNotificationPosition )
		pFnGetNetworkNotificationPosition = (UFunction*) UObject::GObjObjects()->Data[ 46860 ];

	UOnlineSubsystemUPlay_execGetNetworkNotificationPosition_Parms GetNetworkNotificationPosition_Parms;

	this->ProcessEvent ( pFnGetNetworkNotificationPosition, &GetNetworkNotificationPosition_Parms, NULL );

	return GetNetworkNotificationPosition_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearExternalUIChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ExternalUIDelegate             ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearExternalUIChangeDelegate ( struct FScriptDelegate ExternalUIDelegate )
{
	static UFunction* pFnClearExternalUIChangeDelegate = NULL;

	if ( ! pFnClearExternalUIChangeDelegate )
		pFnClearExternalUIChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46858 ];

	UOnlineSubsystemUPlay_execClearExternalUIChangeDelegate_Parms ClearExternalUIChangeDelegate_Parms;
	memcpy ( &ClearExternalUIChangeDelegate_Parms.ExternalUIDelegate, &ExternalUIDelegate, 0x10 );

	this->ProcessEvent ( pFnClearExternalUIChangeDelegate, &ClearExternalUIChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddExternalUIChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ExternalUIDelegate             ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddExternalUIChangeDelegate ( struct FScriptDelegate ExternalUIDelegate )
{
	static UFunction* pFnAddExternalUIChangeDelegate = NULL;

	if ( ! pFnAddExternalUIChangeDelegate )
		pFnAddExternalUIChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46856 ];

	UOnlineSubsystemUPlay_execAddExternalUIChangeDelegate_Parms AddExternalUIChangeDelegate_Parms;
	memcpy ( &AddExternalUIChangeDelegate_Parms.ExternalUIDelegate, &ExternalUIDelegate, 0x10 );

	this->ProcessEvent ( pFnAddExternalUIChangeDelegate, &AddExternalUIChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnExternalUIChange
// [0x00120000] 
// Parameters infos:
// unsigned long                  bIsOpening                     ( CPF_Parm )

void UOnlineSubsystemUPlay::OnExternalUIChange ( unsigned long bIsOpening )
{
	static UFunction* pFnOnExternalUIChange = NULL;

	if ( ! pFnOnExternalUIChange )
		pFnOnExternalUIChange = (UFunction*) UObject::GObjObjects()->Data[ 46854 ];

	UOnlineSubsystemUPlay_execOnExternalUIChange_Parms OnExternalUIChange_Parms;
	OnExternalUIChange_Parms.bIsOpening = bIsOpening;

	this->ProcessEvent ( pFnOnExternalUIChange, &OnExternalUIChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLinkStatusChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         LinkStatusDelegate             ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearLinkStatusChangeDelegate ( struct FScriptDelegate LinkStatusDelegate )
{
	static UFunction* pFnClearLinkStatusChangeDelegate = NULL;

	if ( ! pFnClearLinkStatusChangeDelegate )
		pFnClearLinkStatusChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46852 ];

	UOnlineSubsystemUPlay_execClearLinkStatusChangeDelegate_Parms ClearLinkStatusChangeDelegate_Parms;
	memcpy ( &ClearLinkStatusChangeDelegate_Parms.LinkStatusDelegate, &LinkStatusDelegate, 0x10 );

	this->ProcessEvent ( pFnClearLinkStatusChangeDelegate, &ClearLinkStatusChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLinkStatusChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         LinkStatusDelegate             ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddLinkStatusChangeDelegate ( struct FScriptDelegate LinkStatusDelegate )
{
	static UFunction* pFnAddLinkStatusChangeDelegate = NULL;

	if ( ! pFnAddLinkStatusChangeDelegate )
		pFnAddLinkStatusChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46850 ];

	UOnlineSubsystemUPlay_execAddLinkStatusChangeDelegate_Parms AddLinkStatusChangeDelegate_Parms;
	memcpy ( &AddLinkStatusChangeDelegate_Parms.LinkStatusDelegate, &LinkStatusDelegate, 0x10 );

	this->ProcessEvent ( pFnAddLinkStatusChangeDelegate, &AddLinkStatusChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLinkStatusChange
// [0x00120000] 
// Parameters infos:
// unsigned long                  bIsConnected                   ( CPF_Parm )

void UOnlineSubsystemUPlay::OnLinkStatusChange ( unsigned long bIsConnected )
{
	static UFunction* pFnOnLinkStatusChange = NULL;

	if ( ! pFnOnLinkStatusChange )
		pFnOnLinkStatusChange = (UFunction*) UObject::GObjObjects()->Data[ 46848 ];

	UOnlineSubsystemUPlay_execOnLinkStatusChange_Parms OnLinkStatusChange_Parms;
	OnLinkStatusChange_Parms.bIsConnected = bIsConnected;

	this->ProcessEvent ( pFnOnLinkStatusChange, &OnLinkStatusChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.HasLinkConnection
// [0x00020002] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::HasLinkConnection ( )
{
	static UFunction* pFnHasLinkConnection = NULL;

	if ( ! pFnHasLinkConnection )
		pFnHasLinkConnection = (UFunction*) UObject::GObjObjects()->Data[ 46846 ];

	UOnlineSubsystemUPlay_execHasLinkConnection_Parms HasLinkConnection_Parms;

	this->ProcessEvent ( pFnHasLinkConnection, &HasLinkConnection_Parms, NULL );

	return HasLinkConnection_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetPlayerNicknameFromIndex
// [0x00020802] ( FUNC_Event )
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
// int                            UserIndex                      ( CPF_Parm )

struct FString UOnlineSubsystemUPlay::eventGetPlayerNicknameFromIndex ( int UserIndex )
{
	static UFunction* pFnGetPlayerNicknameFromIndex = NULL;

	if ( ! pFnGetPlayerNicknameFromIndex )
		pFnGetPlayerNicknameFromIndex = (UFunction*) UObject::GObjObjects()->Data[ 46843 ];

	UOnlineSubsystemUPlay_eventGetPlayerNicknameFromIndex_Parms GetPlayerNicknameFromIndex_Parms;
	GetPlayerNicknameFromIndex_Parms.UserIndex = UserIndex;

	this->ProcessEvent ( pFnGetPlayerNicknameFromIndex, &GetPlayerNicknameFromIndex_Parms, NULL );

	return GetPlayerNicknameFromIndex_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CalcAggregateSkill
// [0x00420000] 
// Parameters infos:
// TArray< struct FDouble >       Mus                            ( CPF_Parm | CPF_NeedCtorLink )
// TArray< struct FDouble >       Sigmas                         ( CPF_Parm | CPF_NeedCtorLink )
// struct FDouble                 OutAggregateMu                 ( CPF_Parm | CPF_OutParm )
// struct FDouble                 OutAggregateSigma              ( CPF_Parm | CPF_OutParm )

void UOnlineSubsystemUPlay::CalcAggregateSkill ( TArray< struct FDouble > Mus, TArray< struct FDouble > Sigmas, struct FDouble* OutAggregateMu, struct FDouble* OutAggregateSigma )
{
	static UFunction* pFnCalcAggregateSkill = NULL;

	if ( ! pFnCalcAggregateSkill )
		pFnCalcAggregateSkill = (UFunction*) UObject::GObjObjects()->Data[ 46836 ];

	UOnlineSubsystemUPlay_execCalcAggregateSkill_Parms CalcAggregateSkill_Parms;
	memcpy ( &CalcAggregateSkill_Parms.Mus, &Mus, 0x10 );
	memcpy ( &CalcAggregateSkill_Parms.Sigmas, &Sigmas, 0x10 );

	this->ProcessEvent ( pFnCalcAggregateSkill, &CalcAggregateSkill_Parms, NULL );

	if ( OutAggregateMu )
		memcpy ( OutAggregateMu, &CalcAggregateSkill_Parms.OutAggregateMu, 0x8 );

	if ( OutAggregateSigma )
		memcpy ( OutAggregateSigma, &CalcAggregateSkill_Parms.OutAggregateSigma, 0x8 );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterStatGuid
// [0x00420000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )
// struct FString                 ClientStatGuid                 ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::RegisterStatGuid ( struct FUniqueNetId PlayerID, struct FString* ClientStatGuid )
{
	static UFunction* pFnRegisterStatGuid = NULL;

	if ( ! pFnRegisterStatGuid )
		pFnRegisterStatGuid = (UFunction*) UObject::GObjObjects()->Data[ 46832 ];

	UOnlineSubsystemUPlay_execRegisterStatGuid_Parms RegisterStatGuid_Parms;
	memcpy ( &RegisterStatGuid_Parms.PlayerID, &PlayerID, 0x8 );

	this->ProcessEvent ( pFnRegisterStatGuid, &RegisterStatGuid_Parms, NULL );

	if ( ClientStatGuid )
		memcpy ( ClientStatGuid, &RegisterStatGuid_Parms.ClientStatGuid, 0x10 );

	return RegisterStatGuid_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetClientStatGuid
// [0x00020000] 
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )

struct FString UOnlineSubsystemUPlay::GetClientStatGuid ( )
{
	static UFunction* pFnGetClientStatGuid = NULL;

	if ( ! pFnGetClientStatGuid )
		pFnGetClientStatGuid = (UFunction*) UObject::GObjObjects()->Data[ 46830 ];

	UOnlineSubsystemUPlay_execGetClientStatGuid_Parms GetClientStatGuid_Parms;

	this->ProcessEvent ( pFnGetClientStatGuid, &GetClientStatGuid_Parms, NULL );

	return GetClientStatGuid_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearRegisterHostStatGuidCompleteDelegateDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         RegisterHostStatGuidCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearRegisterHostStatGuidCompleteDelegateDelegate ( struct FScriptDelegate RegisterHostStatGuidCompleteDelegate )
{
	static UFunction* pFnClearRegisterHostStatGuidCompleteDelegateDelegate = NULL;

	if ( ! pFnClearRegisterHostStatGuidCompleteDelegateDelegate )
		pFnClearRegisterHostStatGuidCompleteDelegateDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46828 ];

	UOnlineSubsystemUPlay_execClearRegisterHostStatGuidCompleteDelegateDelegate_Parms ClearRegisterHostStatGuidCompleteDelegateDelegate_Parms;
	memcpy ( &ClearRegisterHostStatGuidCompleteDelegateDelegate_Parms.RegisterHostStatGuidCompleteDelegate, &RegisterHostStatGuidCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearRegisterHostStatGuidCompleteDelegateDelegate, &ClearRegisterHostStatGuidCompleteDelegateDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddRegisterHostStatGuidCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         RegisterHostStatGuidCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddRegisterHostStatGuidCompleteDelegate ( struct FScriptDelegate RegisterHostStatGuidCompleteDelegate )
{
	static UFunction* pFnAddRegisterHostStatGuidCompleteDelegate = NULL;

	if ( ! pFnAddRegisterHostStatGuidCompleteDelegate )
		pFnAddRegisterHostStatGuidCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46826 ];

	UOnlineSubsystemUPlay_execAddRegisterHostStatGuidCompleteDelegate_Parms AddRegisterHostStatGuidCompleteDelegate_Parms;
	memcpy ( &AddRegisterHostStatGuidCompleteDelegate_Parms.RegisterHostStatGuidCompleteDelegate, &RegisterHostStatGuidCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddRegisterHostStatGuidCompleteDelegate, &AddRegisterHostStatGuidCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnRegisterHostStatGuidComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnRegisterHostStatGuidComplete ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnRegisterHostStatGuidComplete = NULL;

	if ( ! pFnOnRegisterHostStatGuidComplete )
		pFnOnRegisterHostStatGuidComplete = (UFunction*) UObject::GObjObjects()->Data[ 46824 ];

	UOnlineSubsystemUPlay_execOnRegisterHostStatGuidComplete_Parms OnRegisterHostStatGuidComplete_Parms;
	OnRegisterHostStatGuidComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnRegisterHostStatGuidComplete, &OnRegisterHostStatGuidComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterHostStatGuid
// [0x00420000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 HostStatGuid                   ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::RegisterHostStatGuid ( struct FString* HostStatGuid )
{
	static UFunction* pFnRegisterHostStatGuid = NULL;

	if ( ! pFnRegisterHostStatGuid )
		pFnRegisterHostStatGuid = (UFunction*) UObject::GObjObjects()->Data[ 46821 ];

	UOnlineSubsystemUPlay_execRegisterHostStatGuid_Parms RegisterHostStatGuid_Parms;

	this->ProcessEvent ( pFnRegisterHostStatGuid, &RegisterHostStatGuid_Parms, NULL );

	if ( HostStatGuid )
		memcpy ( HostStatGuid, &RegisterHostStatGuid_Parms.HostStatGuid, 0x10 );

	return RegisterHostStatGuid_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetHostStatGuid
// [0x00020000] 
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )

struct FString UOnlineSubsystemUPlay::GetHostStatGuid ( )
{
	static UFunction* pFnGetHostStatGuid = NULL;

	if ( ! pFnGetHostStatGuid )
		pFnGetHostStatGuid = (UFunction*) UObject::GObjObjects()->Data[ 46819 ];

	UOnlineSubsystemUPlay_execGetHostStatGuid_Parms GetHostStatGuid_Parms;

	this->ProcessEvent ( pFnGetHostStatGuid, &GetHostStatGuid_Parms, NULL );

	return GetHostStatGuid_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WriteOnlinePlayerScores
// [0x00420000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FName                   SessionName                    ( CPF_Parm )
// int                            LeaderboardId                  ( CPF_Parm )
// TArray< struct FOnlinePlayerScore > PlayerScores                   ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::WriteOnlinePlayerScores ( struct FName SessionName, int LeaderboardId, TArray< struct FOnlinePlayerScore >* PlayerScores )
{
	static UFunction* pFnWriteOnlinePlayerScores = NULL;

	if ( ! pFnWriteOnlinePlayerScores )
		pFnWriteOnlinePlayerScores = (UFunction*) UObject::GObjObjects()->Data[ 46813 ];

	UOnlineSubsystemUPlay_execWriteOnlinePlayerScores_Parms WriteOnlinePlayerScores_Parms;
	memcpy ( &WriteOnlinePlayerScores_Parms.SessionName, &SessionName, 0x8 );
	WriteOnlinePlayerScores_Parms.LeaderboardId = LeaderboardId;

	this->ProcessEvent ( pFnWriteOnlinePlayerScores, &WriteOnlinePlayerScores_Parms, NULL );

	if ( PlayerScores )
		memcpy ( PlayerScores, &WriteOnlinePlayerScores_Parms.PlayerScores, 0x10 );

	return WriteOnlinePlayerScores_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFlushOnlineStatsCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         FlushOnlineStatsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearFlushOnlineStatsCompleteDelegate ( struct FScriptDelegate FlushOnlineStatsCompleteDelegate )
{
	static UFunction* pFnClearFlushOnlineStatsCompleteDelegate = NULL;

	if ( ! pFnClearFlushOnlineStatsCompleteDelegate )
		pFnClearFlushOnlineStatsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46811 ];

	UOnlineSubsystemUPlay_execClearFlushOnlineStatsCompleteDelegate_Parms ClearFlushOnlineStatsCompleteDelegate_Parms;
	memcpy ( &ClearFlushOnlineStatsCompleteDelegate_Parms.FlushOnlineStatsCompleteDelegate, &FlushOnlineStatsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearFlushOnlineStatsCompleteDelegate, &ClearFlushOnlineStatsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFlushOnlineStatsCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         FlushOnlineStatsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddFlushOnlineStatsCompleteDelegate ( struct FScriptDelegate FlushOnlineStatsCompleteDelegate )
{
	static UFunction* pFnAddFlushOnlineStatsCompleteDelegate = NULL;

	if ( ! pFnAddFlushOnlineStatsCompleteDelegate )
		pFnAddFlushOnlineStatsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46809 ];

	UOnlineSubsystemUPlay_execAddFlushOnlineStatsCompleteDelegate_Parms AddFlushOnlineStatsCompleteDelegate_Parms;
	memcpy ( &AddFlushOnlineStatsCompleteDelegate_Parms.FlushOnlineStatsCompleteDelegate, &FlushOnlineStatsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddFlushOnlineStatsCompleteDelegate, &AddFlushOnlineStatsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFlushOnlineStatsComplete
// [0x00120000] 
// Parameters infos:
// struct FName                   SessionName                    ( CPF_Parm )
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnFlushOnlineStatsComplete ( struct FName SessionName, unsigned long bWasSuccessful )
{
	static UFunction* pFnOnFlushOnlineStatsComplete = NULL;

	if ( ! pFnOnFlushOnlineStatsComplete )
		pFnOnFlushOnlineStatsComplete = (UFunction*) UObject::GObjObjects()->Data[ 46806 ];

	UOnlineSubsystemUPlay_execOnFlushOnlineStatsComplete_Parms OnFlushOnlineStatsComplete_Parms;
	memcpy ( &OnFlushOnlineStatsComplete_Parms.SessionName, &SessionName, 0x8 );
	OnFlushOnlineStatsComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnFlushOnlineStatsComplete, &OnFlushOnlineStatsComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.FlushOnlineStats
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FName                   SessionName                    ( CPF_Parm )

bool UOnlineSubsystemUPlay::FlushOnlineStats ( struct FName SessionName )
{
	static UFunction* pFnFlushOnlineStats = NULL;

	if ( ! pFnFlushOnlineStats )
		pFnFlushOnlineStats = (UFunction*) UObject::GObjObjects()->Data[ 46803 ];

	UOnlineSubsystemUPlay_execFlushOnlineStats_Parms FlushOnlineStats_Parms;
	memcpy ( &FlushOnlineStats_Parms.SessionName, &SessionName, 0x8 );

	this->ProcessEvent ( pFnFlushOnlineStats, &FlushOnlineStats_Parms, NULL );

	return FlushOnlineStats_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WriteOnlineStats
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FName                   SessionName                    ( CPF_Parm )
// struct FUniqueNetId            Player                         ( CPF_Parm )
// class UOnlineStatsWrite*       StatsWrite                     ( CPF_Parm )

bool UOnlineSubsystemUPlay::WriteOnlineStats ( struct FName SessionName, struct FUniqueNetId Player, class UOnlineStatsWrite* StatsWrite )
{
	static UFunction* pFnWriteOnlineStats = NULL;

	if ( ! pFnWriteOnlineStats )
		pFnWriteOnlineStats = (UFunction*) UObject::GObjObjects()->Data[ 46798 ];

	UOnlineSubsystemUPlay_execWriteOnlineStats_Parms WriteOnlineStats_Parms;
	memcpy ( &WriteOnlineStats_Parms.SessionName, &SessionName, 0x8 );
	memcpy ( &WriteOnlineStats_Parms.Player, &Player, 0x8 );
	WriteOnlineStats_Parms.StatsWrite = StatsWrite;

	this->ProcessEvent ( pFnWriteOnlineStats, &WriteOnlineStats_Parms, NULL );

	return WriteOnlineStats_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.FreeStats
// [0x00020000] 
// Parameters infos:
// class UOnlineStatsRead*        StatsRead                      ( CPF_Parm )

void UOnlineSubsystemUPlay::FreeStats ( class UOnlineStatsRead* StatsRead )
{
	static UFunction* pFnFreeStats = NULL;

	if ( ! pFnFreeStats )
		pFnFreeStats = (UFunction*) UObject::GObjObjects()->Data[ 46796 ];

	UOnlineSubsystemUPlay_execFreeStats_Parms FreeStats_Parms;
	FreeStats_Parms.StatsRead = StatsRead;

	this->ProcessEvent ( pFnFreeStats, &FreeStats_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadOnlineStatsCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ReadOnlineStatsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReadOnlineStatsCompleteDelegate ( struct FScriptDelegate ReadOnlineStatsCompleteDelegate )
{
	static UFunction* pFnClearReadOnlineStatsCompleteDelegate = NULL;

	if ( ! pFnClearReadOnlineStatsCompleteDelegate )
		pFnClearReadOnlineStatsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46794 ];

	UOnlineSubsystemUPlay_execClearReadOnlineStatsCompleteDelegate_Parms ClearReadOnlineStatsCompleteDelegate_Parms;
	memcpy ( &ClearReadOnlineStatsCompleteDelegate_Parms.ReadOnlineStatsCompleteDelegate, &ReadOnlineStatsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReadOnlineStatsCompleteDelegate, &ClearReadOnlineStatsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadOnlineStatsCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ReadOnlineStatsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReadOnlineStatsCompleteDelegate ( struct FScriptDelegate ReadOnlineStatsCompleteDelegate )
{
	static UFunction* pFnAddReadOnlineStatsCompleteDelegate = NULL;

	if ( ! pFnAddReadOnlineStatsCompleteDelegate )
		pFnAddReadOnlineStatsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46792 ];

	UOnlineSubsystemUPlay_execAddReadOnlineStatsCompleteDelegate_Parms AddReadOnlineStatsCompleteDelegate_Parms;
	memcpy ( &AddReadOnlineStatsCompleteDelegate_Parms.ReadOnlineStatsCompleteDelegate, &ReadOnlineStatsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReadOnlineStatsCompleteDelegate, &AddReadOnlineStatsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStatsByRankAroundPlayer
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// class UOnlineStatsRead*        StatsRead                      ( CPF_Parm )
// int                            NumRows                        ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::ReadOnlineStatsByRankAroundPlayer ( unsigned char LocalUserNum, class UOnlineStatsRead* StatsRead, int NumRows )
{
	static UFunction* pFnReadOnlineStatsByRankAroundPlayer = NULL;

	if ( ! pFnReadOnlineStatsByRankAroundPlayer )
		pFnReadOnlineStatsByRankAroundPlayer = (UFunction*) UObject::GObjObjects()->Data[ 46787 ];

	UOnlineSubsystemUPlay_execReadOnlineStatsByRankAroundPlayer_Parms ReadOnlineStatsByRankAroundPlayer_Parms;
	ReadOnlineStatsByRankAroundPlayer_Parms.LocalUserNum = LocalUserNum;
	ReadOnlineStatsByRankAroundPlayer_Parms.StatsRead = StatsRead;
	ReadOnlineStatsByRankAroundPlayer_Parms.NumRows = NumRows;

	this->ProcessEvent ( pFnReadOnlineStatsByRankAroundPlayer, &ReadOnlineStatsByRankAroundPlayer_Parms, NULL );

	return ReadOnlineStatsByRankAroundPlayer_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStatsByRank
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// class UOnlineStatsRead*        StatsRead                      ( CPF_Parm )
// int                            StartIndex                     ( CPF_OptionalParm | CPF_Parm )
// int                            NumToRead                      ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::ReadOnlineStatsByRank ( class UOnlineStatsRead* StatsRead, int StartIndex, int NumToRead )
{
	static UFunction* pFnReadOnlineStatsByRank = NULL;

	if ( ! pFnReadOnlineStatsByRank )
		pFnReadOnlineStatsByRank = (UFunction*) UObject::GObjObjects()->Data[ 46782 ];

	UOnlineSubsystemUPlay_execReadOnlineStatsByRank_Parms ReadOnlineStatsByRank_Parms;
	ReadOnlineStatsByRank_Parms.StatsRead = StatsRead;
	ReadOnlineStatsByRank_Parms.StartIndex = StartIndex;
	ReadOnlineStatsByRank_Parms.NumToRead = NumToRead;

	this->ProcessEvent ( pFnReadOnlineStatsByRank, &ReadOnlineStatsByRank_Parms, NULL );

	return ReadOnlineStatsByRank_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStatsForFriends
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// class UOnlineStatsRead*        StatsRead                      ( CPF_Parm )

bool UOnlineSubsystemUPlay::ReadOnlineStatsForFriends ( unsigned char LocalUserNum, class UOnlineStatsRead* StatsRead )
{
	static UFunction* pFnReadOnlineStatsForFriends = NULL;

	if ( ! pFnReadOnlineStatsForFriends )
		pFnReadOnlineStatsForFriends = (UFunction*) UObject::GObjObjects()->Data[ 46778 ];

	UOnlineSubsystemUPlay_execReadOnlineStatsForFriends_Parms ReadOnlineStatsForFriends_Parms;
	ReadOnlineStatsForFriends_Parms.LocalUserNum = LocalUserNum;
	ReadOnlineStatsForFriends_Parms.StatsRead = StatsRead;

	this->ProcessEvent ( pFnReadOnlineStatsForFriends, &ReadOnlineStatsForFriends_Parms, NULL );

	return ReadOnlineStatsForFriends_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadOnlineStats
// [0x00420000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// class UOnlineStatsRead*        StatsRead                      ( CPF_Parm )
// TArray< struct FUniqueNetId >  Players                        ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::ReadOnlineStats ( class UOnlineStatsRead* StatsRead, TArray< struct FUniqueNetId >* Players )
{
	static UFunction* pFnReadOnlineStats = NULL;

	if ( ! pFnReadOnlineStats )
		pFnReadOnlineStats = (UFunction*) UObject::GObjObjects()->Data[ 46773 ];

	UOnlineSubsystemUPlay_execReadOnlineStats_Parms ReadOnlineStats_Parms;
	ReadOnlineStats_Parms.StatsRead = StatsRead;

	this->ProcessEvent ( pFnReadOnlineStats, &ReadOnlineStats_Parms, NULL );

	if ( Players )
		memcpy ( Players, &ReadOnlineStats_Parms.Players, 0x10 );

	return ReadOnlineStats_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadOnlineStatsComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnReadOnlineStatsComplete ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnReadOnlineStatsComplete = NULL;

	if ( ! pFnOnReadOnlineStatsComplete )
		pFnOnReadOnlineStatsComplete = (UFunction*) UObject::GObjObjects()->Data[ 46771 ];

	UOnlineSubsystemUPlay_execOnReadOnlineStatsComplete_Parms OnReadOnlineStatsComplete_Parms;
	OnReadOnlineStatsComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnReadOnlineStatsComplete, &OnReadOnlineStatsComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetSpeechRecognitionObject
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// class USpeechRecognition*      SpeechRecogObj                 ( CPF_Parm )

bool UOnlineSubsystemUPlay::SetSpeechRecognitionObject ( unsigned char LocalUserNum, class USpeechRecognition* SpeechRecogObj )
{
	static UFunction* pFnSetSpeechRecognitionObject = NULL;

	if ( ! pFnSetSpeechRecognitionObject )
		pFnSetSpeechRecognitionObject = (UFunction*) UObject::GObjObjects()->Data[ 46767 ];

	UOnlineSubsystemUPlay_execSetSpeechRecognitionObject_Parms SetSpeechRecognitionObject_Parms;
	SetSpeechRecognitionObject_Parms.LocalUserNum = LocalUserNum;
	SetSpeechRecognitionObject_Parms.SpeechRecogObj = SpeechRecogObj;

	this->ProcessEvent ( pFnSetSpeechRecognitionObject, &SetSpeechRecognitionObject_Parms, NULL );

	return SetSpeechRecognitionObject_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SelectVocabulary
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            VocabularyId                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::SelectVocabulary ( unsigned char LocalUserNum, int VocabularyId )
{
	static UFunction* pFnSelectVocabulary = NULL;

	if ( ! pFnSelectVocabulary )
		pFnSelectVocabulary = (UFunction*) UObject::GObjObjects()->Data[ 46763 ];

	UOnlineSubsystemUPlay_execSelectVocabulary_Parms SelectVocabulary_Parms;
	SelectVocabulary_Parms.LocalUserNum = LocalUserNum;
	SelectVocabulary_Parms.VocabularyId = VocabularyId;

	this->ProcessEvent ( pFnSelectVocabulary, &SelectVocabulary_Parms, NULL );

	return SelectVocabulary_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearRecognitionCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         RecognitionDelegate            ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearRecognitionCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate RecognitionDelegate )
{
	static UFunction* pFnClearRecognitionCompleteDelegate = NULL;

	if ( ! pFnClearRecognitionCompleteDelegate )
		pFnClearRecognitionCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46759 ];

	UOnlineSubsystemUPlay_execClearRecognitionCompleteDelegate_Parms ClearRecognitionCompleteDelegate_Parms;
	ClearRecognitionCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearRecognitionCompleteDelegate_Parms.RecognitionDelegate, &RecognitionDelegate, 0x10 );

	this->ProcessEvent ( pFnClearRecognitionCompleteDelegate, &ClearRecognitionCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddRecognitionCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         RecognitionDelegate            ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddRecognitionCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate RecognitionDelegate )
{
	static UFunction* pFnAddRecognitionCompleteDelegate = NULL;

	if ( ! pFnAddRecognitionCompleteDelegate )
		pFnAddRecognitionCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46756 ];

	UOnlineSubsystemUPlay_execAddRecognitionCompleteDelegate_Parms AddRecognitionCompleteDelegate_Parms;
	AddRecognitionCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddRecognitionCompleteDelegate_Parms.RecognitionDelegate, &RecognitionDelegate, 0x10 );

	this->ProcessEvent ( pFnAddRecognitionCompleteDelegate, &AddRecognitionCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnRecognitionComplete
// [0x00120000] 
// Parameters infos:

void UOnlineSubsystemUPlay::OnRecognitionComplete ( )
{
	static UFunction* pFnOnRecognitionComplete = NULL;

	if ( ! pFnOnRecognitionComplete )
		pFnOnRecognitionComplete = (UFunction*) UObject::GObjObjects()->Data[ 46755 ];

	UOnlineSubsystemUPlay_execOnRecognitionComplete_Parms OnRecognitionComplete_Parms;

	this->ProcessEvent ( pFnOnRecognitionComplete, &OnRecognitionComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetRecognitionResults
// [0x00420000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// TArray< struct FSpeechRecognizedWord > Words                          ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::GetRecognitionResults ( unsigned char LocalUserNum, TArray< struct FSpeechRecognizedWord >* Words )
{
	static UFunction* pFnGetRecognitionResults = NULL;

	if ( ! pFnGetRecognitionResults )
		pFnGetRecognitionResults = (UFunction*) UObject::GObjObjects()->Data[ 46750 ];

	UOnlineSubsystemUPlay_execGetRecognitionResults_Parms GetRecognitionResults_Parms;
	GetRecognitionResults_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnGetRecognitionResults, &GetRecognitionResults_Parms, NULL );

	if ( Words )
		memcpy ( Words, &GetRecognitionResults_Parms.Words, 0x10 );

	return GetRecognitionResults_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StopSpeechRecognition
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::StopSpeechRecognition ( unsigned char LocalUserNum )
{
	static UFunction* pFnStopSpeechRecognition = NULL;

	if ( ! pFnStopSpeechRecognition )
		pFnStopSpeechRecognition = (UFunction*) UObject::GObjObjects()->Data[ 46747 ];

	UOnlineSubsystemUPlay_execStopSpeechRecognition_Parms StopSpeechRecognition_Parms;
	StopSpeechRecognition_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnStopSpeechRecognition, &StopSpeechRecognition_Parms, NULL );

	return StopSpeechRecognition_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StartSpeechRecognition
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::StartSpeechRecognition ( unsigned char LocalUserNum )
{
	static UFunction* pFnStartSpeechRecognition = NULL;

	if ( ! pFnStartSpeechRecognition )
		pFnStartSpeechRecognition = (UFunction*) UObject::GObjObjects()->Data[ 46744 ];

	UOnlineSubsystemUPlay_execStartSpeechRecognition_Parms StartSpeechRecognition_Parms;
	StartSpeechRecognition_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnStartSpeechRecognition, &StartSpeechRecognition_Parms, NULL );

	return StartSpeechRecognition_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StopNetworkedVoice
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )

void UOnlineSubsystemUPlay::StopNetworkedVoice ( unsigned char LocalUserNum )
{
	static UFunction* pFnStopNetworkedVoice = NULL;

	if ( ! pFnStopNetworkedVoice )
		pFnStopNetworkedVoice = (UFunction*) UObject::GObjObjects()->Data[ 46742 ];

	UOnlineSubsystemUPlay_execStopNetworkedVoice_Parms StopNetworkedVoice_Parms;
	StopNetworkedVoice_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnStopNetworkedVoice, &StopNetworkedVoice_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.StartNetworkedVoice
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )

void UOnlineSubsystemUPlay::StartNetworkedVoice ( unsigned char LocalUserNum )
{
	static UFunction* pFnStartNetworkedVoice = NULL;

	if ( ! pFnStartNetworkedVoice )
		pFnStartNetworkedVoice = (UFunction*) UObject::GObjObjects()->Data[ 46740 ];

	UOnlineSubsystemUPlay_execStartNetworkedVoice_Parms StartNetworkedVoice_Parms;
	StartNetworkedVoice_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnStartNetworkedVoice, &StartNetworkedVoice_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnmuteRemoteTalker
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )
// unsigned long                  bIsSystemWide                  ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::UnmuteRemoteTalker ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID, unsigned long bIsSystemWide )
{
	static UFunction* pFnUnmuteRemoteTalker = NULL;

	if ( ! pFnUnmuteRemoteTalker )
		pFnUnmuteRemoteTalker = (UFunction*) UObject::GObjObjects()->Data[ 46735 ];

	UOnlineSubsystemUPlay_execUnmuteRemoteTalker_Parms UnmuteRemoteTalker_Parms;
	UnmuteRemoteTalker_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &UnmuteRemoteTalker_Parms.PlayerID, &PlayerID, 0x8 );
	UnmuteRemoteTalker_Parms.bIsSystemWide = bIsSystemWide;

	this->ProcessEvent ( pFnUnmuteRemoteTalker, &UnmuteRemoteTalker_Parms, NULL );

	return UnmuteRemoteTalker_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.MuteRemoteTalker
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )
// unsigned long                  bIsSystemWide                  ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::MuteRemoteTalker ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID, unsigned long bIsSystemWide )
{
	static UFunction* pFnMuteRemoteTalker = NULL;

	if ( ! pFnMuteRemoteTalker )
		pFnMuteRemoteTalker = (UFunction*) UObject::GObjObjects()->Data[ 46730 ];

	UOnlineSubsystemUPlay_execMuteRemoteTalker_Parms MuteRemoteTalker_Parms;
	MuteRemoteTalker_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &MuteRemoteTalker_Parms.PlayerID, &PlayerID, 0x8 );
	MuteRemoteTalker_Parms.bIsSystemWide = bIsSystemWide;

	this->ProcessEvent ( pFnMuteRemoteTalker, &MuteRemoteTalker_Parms, NULL );

	return MuteRemoteTalker_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetRemoteTalkerPriority
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )
// int                            Priority                       ( CPF_Parm )

bool UOnlineSubsystemUPlay::SetRemoteTalkerPriority ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID, int Priority )
{
	static UFunction* pFnSetRemoteTalkerPriority = NULL;

	if ( ! pFnSetRemoteTalkerPriority )
		pFnSetRemoteTalkerPriority = (UFunction*) UObject::GObjObjects()->Data[ 46725 ];

	UOnlineSubsystemUPlay_execSetRemoteTalkerPriority_Parms SetRemoteTalkerPriority_Parms;
	SetRemoteTalkerPriority_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &SetRemoteTalkerPriority_Parms.PlayerID, &PlayerID, 0x8 );
	SetRemoteTalkerPriority_Parms.Priority = Priority;

	this->ProcessEvent ( pFnSetRemoteTalkerPriority, &SetRemoteTalkerPriority_Parms, NULL );

	return SetRemoteTalkerPriority_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsHeadsetPresent
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsHeadsetPresent ( unsigned char LocalUserNum )
{
	static UFunction* pFnIsHeadsetPresent = NULL;

	if ( ! pFnIsHeadsetPresent )
		pFnIsHeadsetPresent = (UFunction*) UObject::GObjObjects()->Data[ 46722 ];

	UOnlineSubsystemUPlay_execIsHeadsetPresent_Parms IsHeadsetPresent_Parms;
	IsHeadsetPresent_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnIsHeadsetPresent, &IsHeadsetPresent_Parms, NULL );

	return IsHeadsetPresent_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsRemotePlayerTalking
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsRemotePlayerTalking ( struct FUniqueNetId PlayerID )
{
	static UFunction* pFnIsRemotePlayerTalking = NULL;

	if ( ! pFnIsRemotePlayerTalking )
		pFnIsRemotePlayerTalking = (UFunction*) UObject::GObjObjects()->Data[ 46719 ];

	UOnlineSubsystemUPlay_execIsRemotePlayerTalking_Parms IsRemotePlayerTalking_Parms;
	memcpy ( &IsRemotePlayerTalking_Parms.PlayerID, &PlayerID, 0x8 );

	this->ProcessEvent ( pFnIsRemotePlayerTalking, &IsRemotePlayerTalking_Parms, NULL );

	return IsRemotePlayerTalking_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsLocalPlayerTalking
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsLocalPlayerTalking ( unsigned char LocalUserNum )
{
	static UFunction* pFnIsLocalPlayerTalking = NULL;

	if ( ! pFnIsLocalPlayerTalking )
		pFnIsLocalPlayerTalking = (UFunction*) UObject::GObjObjects()->Data[ 46716 ];

	UOnlineSubsystemUPlay_execIsLocalPlayerTalking_Parms IsLocalPlayerTalking_Parms;
	IsLocalPlayerTalking_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnIsLocalPlayerTalking, &IsLocalPlayerTalking_Parms, NULL );

	return IsLocalPlayerTalking_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnregisterRemoteTalker
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )

bool UOnlineSubsystemUPlay::UnregisterRemoteTalker ( struct FUniqueNetId PlayerID )
{
	static UFunction* pFnUnregisterRemoteTalker = NULL;

	if ( ! pFnUnregisterRemoteTalker )
		pFnUnregisterRemoteTalker = (UFunction*) UObject::GObjObjects()->Data[ 46713 ];

	UOnlineSubsystemUPlay_execUnregisterRemoteTalker_Parms UnregisterRemoteTalker_Parms;
	memcpy ( &UnregisterRemoteTalker_Parms.PlayerID, &PlayerID, 0x8 );

	this->ProcessEvent ( pFnUnregisterRemoteTalker, &UnregisterRemoteTalker_Parms, NULL );

	return UnregisterRemoteTalker_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterRemoteTalker
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )

bool UOnlineSubsystemUPlay::RegisterRemoteTalker ( struct FUniqueNetId PlayerID )
{
	static UFunction* pFnRegisterRemoteTalker = NULL;

	if ( ! pFnRegisterRemoteTalker )
		pFnRegisterRemoteTalker = (UFunction*) UObject::GObjObjects()->Data[ 46710 ];

	UOnlineSubsystemUPlay_execRegisterRemoteTalker_Parms RegisterRemoteTalker_Parms;
	memcpy ( &RegisterRemoteTalker_Parms.PlayerID, &PlayerID, 0x8 );

	this->ProcessEvent ( pFnRegisterRemoteTalker, &RegisterRemoteTalker_Parms, NULL );

	return RegisterRemoteTalker_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnregisterLocalTalker
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::UnregisterLocalTalker ( unsigned char LocalUserNum )
{
	static UFunction* pFnUnregisterLocalTalker = NULL;

	if ( ! pFnUnregisterLocalTalker )
		pFnUnregisterLocalTalker = (UFunction*) UObject::GObjObjects()->Data[ 46707 ];

	UOnlineSubsystemUPlay_execUnregisterLocalTalker_Parms UnregisterLocalTalker_Parms;
	UnregisterLocalTalker_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnUnregisterLocalTalker, &UnregisterLocalTalker_Parms, NULL );

	return UnregisterLocalTalker_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.RegisterLocalTalker
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::RegisterLocalTalker ( unsigned char LocalUserNum )
{
	static UFunction* pFnRegisterLocalTalker = NULL;

	if ( ! pFnRegisterLocalTalker )
		pFnRegisterLocalTalker = (UFunction*) UObject::GObjObjects()->Data[ 46704 ];

	UOnlineSubsystemUPlay_execRegisterLocalTalker_Parms RegisterLocalTalker_Parms;
	RegisterLocalTalker_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnRegisterLocalTalker, &RegisterLocalTalker_Parms, NULL );

	return RegisterLocalTalker_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetFriendsList
// [0x00424000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            Count                          ( CPF_OptionalParm | CPF_Parm )
// int                            StartingAt                     ( CPF_OptionalParm | CPF_Parm )
// TArray< struct FOnlineFriend > Friends                        ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

unsigned char UOnlineSubsystemUPlay::GetFriendsList ( unsigned char LocalUserNum, int Count, int StartingAt, TArray< struct FOnlineFriend >* Friends )
{
	static UFunction* pFnGetFriendsList = NULL;

	if ( ! pFnGetFriendsList )
		pFnGetFriendsList = (UFunction*) UObject::GObjObjects()->Data[ 46697 ];

	UOnlineSubsystemUPlay_execGetFriendsList_Parms GetFriendsList_Parms;
	GetFriendsList_Parms.LocalUserNum = LocalUserNum;
	GetFriendsList_Parms.Count = Count;
	GetFriendsList_Parms.StartingAt = StartingAt;

	this->ProcessEvent ( pFnGetFriendsList, &GetFriendsList_Parms, NULL );

	if ( Friends )
		memcpy ( Friends, &GetFriendsList_Parms.Friends, 0x10 );

	return GetFriendsList_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadFriendsCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadFriendsCompleteDelegate    ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReadFriendsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadFriendsCompleteDelegate )
{
	static UFunction* pFnClearReadFriendsCompleteDelegate = NULL;

	if ( ! pFnClearReadFriendsCompleteDelegate )
		pFnClearReadFriendsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46693 ];

	UOnlineSubsystemUPlay_execClearReadFriendsCompleteDelegate_Parms ClearReadFriendsCompleteDelegate_Parms;
	ClearReadFriendsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearReadFriendsCompleteDelegate_Parms.ReadFriendsCompleteDelegate, &ReadFriendsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReadFriendsCompleteDelegate, &ClearReadFriendsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadFriendsCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadFriendsCompleteDelegate    ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReadFriendsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadFriendsCompleteDelegate )
{
	static UFunction* pFnAddReadFriendsCompleteDelegate = NULL;

	if ( ! pFnAddReadFriendsCompleteDelegate )
		pFnAddReadFriendsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46690 ];

	UOnlineSubsystemUPlay_execAddReadFriendsCompleteDelegate_Parms AddReadFriendsCompleteDelegate_Parms;
	AddReadFriendsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddReadFriendsCompleteDelegate_Parms.ReadFriendsCompleteDelegate, &ReadFriendsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReadFriendsCompleteDelegate, &AddReadFriendsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadFriendsList
// [0x00024002] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// int                            Count                          ( CPF_OptionalParm | CPF_Parm )
// int                            StartingAt                     ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::ReadFriendsList ( unsigned char LocalUserNum, int Count, int StartingAt )
{
	static UFunction* pFnReadFriendsList = NULL;

	if ( ! pFnReadFriendsList )
		pFnReadFriendsList = (UFunction*) UObject::GObjObjects()->Data[ 46683 ];

	UOnlineSubsystemUPlay_execReadFriendsList_Parms ReadFriendsList_Parms;
	ReadFriendsList_Parms.LocalUserNum = LocalUserNum;
	ReadFriendsList_Parms.Count = Count;
	ReadFriendsList_Parms.StartingAt = StartingAt;

	this->ProcessEvent ( pFnReadFriendsList, &ReadFriendsList_Parms, NULL );

	return ReadFriendsList_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadFriendsComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnReadFriendsComplete ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnReadFriendsComplete = NULL;

	if ( ! pFnOnReadFriendsComplete )
		pFnOnReadFriendsComplete = (UFunction*) UObject::GObjObjects()->Data[ 46681 ];

	UOnlineSubsystemUPlay_execOnReadFriendsComplete_Parms OnReadFriendsComplete_Parms;
	OnReadFriendsComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnReadFriendsComplete, &OnReadFriendsComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginStatusChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         LoginStatusDelegate            ( CPF_Parm | CPF_NeedCtorLink )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

void UOnlineSubsystemUPlay::ClearLoginStatusChangeDelegate ( struct FScriptDelegate LoginStatusDelegate, unsigned char LocalUserNum )
{
	static UFunction* pFnClearLoginStatusChangeDelegate = NULL;

	if ( ! pFnClearLoginStatusChangeDelegate )
		pFnClearLoginStatusChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46678 ];

	UOnlineSubsystemUPlay_execClearLoginStatusChangeDelegate_Parms ClearLoginStatusChangeDelegate_Parms;
	memcpy ( &ClearLoginStatusChangeDelegate_Parms.LoginStatusDelegate, &LoginStatusDelegate, 0x10 );
	ClearLoginStatusChangeDelegate_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnClearLoginStatusChangeDelegate, &ClearLoginStatusChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginStatusChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         LoginStatusDelegate            ( CPF_Parm | CPF_NeedCtorLink )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

void UOnlineSubsystemUPlay::AddLoginStatusChangeDelegate ( struct FScriptDelegate LoginStatusDelegate, unsigned char LocalUserNum )
{
	static UFunction* pFnAddLoginStatusChangeDelegate = NULL;

	if ( ! pFnAddLoginStatusChangeDelegate )
		pFnAddLoginStatusChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46675 ];

	UOnlineSubsystemUPlay_execAddLoginStatusChangeDelegate_Parms AddLoginStatusChangeDelegate_Parms;
	memcpy ( &AddLoginStatusChangeDelegate_Parms.LoginStatusDelegate, &LoginStatusDelegate, 0x10 );
	AddLoginStatusChangeDelegate_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnAddLoginStatusChangeDelegate, &AddLoginStatusChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginStatusChange
// [0x00120000] 
// Parameters infos:
// unsigned char                  NewStatus                      ( CPF_Parm )
// struct FUniqueNetId            NewId                          ( CPF_Parm )

void UOnlineSubsystemUPlay::OnLoginStatusChange ( unsigned char NewStatus, struct FUniqueNetId NewId )
{
	static UFunction* pFnOnLoginStatusChange = NULL;

	if ( ! pFnOnLoginStatusChange )
		pFnOnLoginStatusChange = (UFunction*) UObject::GObjObjects()->Data[ 46672 ];

	UOnlineSubsystemUPlay_execOnLoginStatusChange_Parms OnLoginStatusChange_Parms;
	OnLoginStatusChange_Parms.NewStatus = NewStatus;
	memcpy ( &OnLoginStatusChange_Parms.NewId, &NewId, 0x8 );

	this->ProcessEvent ( pFnOnLoginStatusChange, &OnLoginStatusChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearWriteProfileSettingsCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         WriteProfileSettingsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearWriteProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WriteProfileSettingsCompleteDelegate )
{
	static UFunction* pFnClearWriteProfileSettingsCompleteDelegate = NULL;

	if ( ! pFnClearWriteProfileSettingsCompleteDelegate )
		pFnClearWriteProfileSettingsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46668 ];

	UOnlineSubsystemUPlay_execClearWriteProfileSettingsCompleteDelegate_Parms ClearWriteProfileSettingsCompleteDelegate_Parms;
	ClearWriteProfileSettingsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearWriteProfileSettingsCompleteDelegate_Parms.WriteProfileSettingsCompleteDelegate, &WriteProfileSettingsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearWriteProfileSettingsCompleteDelegate, &ClearWriteProfileSettingsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddWriteProfileSettingsCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         WriteProfileSettingsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddWriteProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate WriteProfileSettingsCompleteDelegate )
{
	static UFunction* pFnAddWriteProfileSettingsCompleteDelegate = NULL;

	if ( ! pFnAddWriteProfileSettingsCompleteDelegate )
		pFnAddWriteProfileSettingsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46665 ];

	UOnlineSubsystemUPlay_execAddWriteProfileSettingsCompleteDelegate_Parms AddWriteProfileSettingsCompleteDelegate_Parms;
	AddWriteProfileSettingsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddWriteProfileSettingsCompleteDelegate_Parms.WriteProfileSettingsCompleteDelegate, &WriteProfileSettingsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddWriteProfileSettingsCompleteDelegate, &AddWriteProfileSettingsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnWriteProfileSettingsComplete
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnWriteProfileSettingsComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful )
{
	static UFunction* pFnOnWriteProfileSettingsComplete = NULL;

	if ( ! pFnOnWriteProfileSettingsComplete )
		pFnOnWriteProfileSettingsComplete = (UFunction*) UObject::GObjObjects()->Data[ 46662 ];

	UOnlineSubsystemUPlay_execOnWriteProfileSettingsComplete_Parms OnWriteProfileSettingsComplete_Parms;
	OnWriteProfileSettingsComplete_Parms.LocalUserNum = LocalUserNum;
	OnWriteProfileSettingsComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnWriteProfileSettingsComplete, &OnWriteProfileSettingsComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.WriteProfileSettings
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// class UOnlineProfileSettings*  ProfileSettings                ( CPF_Parm )

bool UOnlineSubsystemUPlay::WriteProfileSettings ( unsigned char LocalUserNum, class UOnlineProfileSettings* ProfileSettings )
{
	static UFunction* pFnWriteProfileSettings = NULL;

	if ( ! pFnWriteProfileSettings )
		pFnWriteProfileSettings = (UFunction*) UObject::GObjObjects()->Data[ 46658 ];

	UOnlineSubsystemUPlay_execWriteProfileSettings_Parms WriteProfileSettings_Parms;
	WriteProfileSettings_Parms.LocalUserNum = LocalUserNum;
	WriteProfileSettings_Parms.ProfileSettings = ProfileSettings;

	pFnWriteProfileSettings->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnWriteProfileSettings, &WriteProfileSettings_Parms, NULL );

	pFnWriteProfileSettings->FunctionFlags |= 0x400;

	return WriteProfileSettings_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetProfileSettings
// [0x00020002] 
// Parameters infos:
// class UOnlineProfileSettings*  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

class UOnlineProfileSettings* UOnlineSubsystemUPlay::GetProfileSettings ( unsigned char LocalUserNum )
{
	static UFunction* pFnGetProfileSettings = NULL;

	if ( ! pFnGetProfileSettings )
		pFnGetProfileSettings = (UFunction*) UObject::GObjObjects()->Data[ 46655 ];

	UOnlineSubsystemUPlay_execGetProfileSettings_Parms GetProfileSettings_Parms;
	GetProfileSettings_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnGetProfileSettings, &GetProfileSettings_Parms, NULL );

	return GetProfileSettings_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadProfileSettingsCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadProfileSettingsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReadProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadProfileSettingsCompleteDelegate )
{
	static UFunction* pFnClearReadProfileSettingsCompleteDelegate = NULL;

	if ( ! pFnClearReadProfileSettingsCompleteDelegate )
		pFnClearReadProfileSettingsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46651 ];

	UOnlineSubsystemUPlay_execClearReadProfileSettingsCompleteDelegate_Parms ClearReadProfileSettingsCompleteDelegate_Parms;
	ClearReadProfileSettingsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearReadProfileSettingsCompleteDelegate_Parms.ReadProfileSettingsCompleteDelegate, &ReadProfileSettingsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReadProfileSettingsCompleteDelegate, &ClearReadProfileSettingsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadProfileSettingsCompleteDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         ReadProfileSettingsCompleteDelegate ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReadProfileSettingsCompleteDelegate ( unsigned char LocalUserNum, struct FScriptDelegate ReadProfileSettingsCompleteDelegate )
{
	static UFunction* pFnAddReadProfileSettingsCompleteDelegate = NULL;

	if ( ! pFnAddReadProfileSettingsCompleteDelegate )
		pFnAddReadProfileSettingsCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46648 ];

	UOnlineSubsystemUPlay_execAddReadProfileSettingsCompleteDelegate_Parms AddReadProfileSettingsCompleteDelegate_Parms;
	AddReadProfileSettingsCompleteDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddReadProfileSettingsCompleteDelegate_Parms.ReadProfileSettingsCompleteDelegate, &ReadProfileSettingsCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReadProfileSettingsCompleteDelegate, &AddReadProfileSettingsCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadProfileSettingsComplete
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnReadProfileSettingsComplete ( unsigned char LocalUserNum, unsigned long bWasSuccessful )
{
	static UFunction* pFnOnReadProfileSettingsComplete = NULL;

	if ( ! pFnOnReadProfileSettingsComplete )
		pFnOnReadProfileSettingsComplete = (UFunction*) UObject::GObjObjects()->Data[ 46645 ];

	UOnlineSubsystemUPlay_execOnReadProfileSettingsComplete_Parms OnReadProfileSettingsComplete_Parms;
	OnReadProfileSettingsComplete_Parms.LocalUserNum = LocalUserNum;
	OnReadProfileSettingsComplete_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnReadProfileSettingsComplete, &OnReadProfileSettingsComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadProfileSettings
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// class UOnlineProfileSettings*  ProfileSettings                ( CPF_Parm )

bool UOnlineSubsystemUPlay::ReadProfileSettings ( unsigned char LocalUserNum, class UOnlineProfileSettings* ProfileSettings )
{
	static UFunction* pFnReadProfileSettings = NULL;

	if ( ! pFnReadProfileSettings )
		pFnReadProfileSettings = (UFunction*) UObject::GObjObjects()->Data[ 46641 ];

	UOnlineSubsystemUPlay_execReadProfileSettings_Parms ReadProfileSettings_Parms;
	ReadProfileSettings_Parms.LocalUserNum = LocalUserNum;
	ReadProfileSettings_Parms.ProfileSettings = ProfileSettings;

	pFnReadProfileSettings->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnReadProfileSettings, &ReadProfileSettings_Parms, NULL );

	pFnReadProfileSettings->FunctionFlags |= 0x400;

	return ReadProfileSettings_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearFriendsChangeDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         FriendsDelegate                ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearFriendsChangeDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendsDelegate )
{
	static UFunction* pFnClearFriendsChangeDelegate = NULL;

	if ( ! pFnClearFriendsChangeDelegate )
		pFnClearFriendsChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46637 ];

	UOnlineSubsystemUPlay_execClearFriendsChangeDelegate_Parms ClearFriendsChangeDelegate_Parms;
	ClearFriendsChangeDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearFriendsChangeDelegate_Parms.FriendsDelegate, &FriendsDelegate, 0x10 );

	this->ProcessEvent ( pFnClearFriendsChangeDelegate, &ClearFriendsChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddFriendsChangeDelegate
// [0x00020002] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         FriendsDelegate                ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddFriendsChangeDelegate ( unsigned char LocalUserNum, struct FScriptDelegate FriendsDelegate )
{
	static UFunction* pFnAddFriendsChangeDelegate = NULL;

	if ( ! pFnAddFriendsChangeDelegate )
		pFnAddFriendsChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46634 ];

	UOnlineSubsystemUPlay_execAddFriendsChangeDelegate_Parms AddFriendsChangeDelegate_Parms;
	AddFriendsChangeDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddFriendsChangeDelegate_Parms.FriendsDelegate, &FriendsDelegate, 0x10 );

	this->ProcessEvent ( pFnAddFriendsChangeDelegate, &AddFriendsChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearMutingChangeDelegate
// [0x00020002] 
// Parameters infos:
// struct FScriptDelegate         MutingDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearMutingChangeDelegate ( struct FScriptDelegate MutingDelegate )
{
	static UFunction* pFnClearMutingChangeDelegate = NULL;

	if ( ! pFnClearMutingChangeDelegate )
		pFnClearMutingChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46631 ];

	UOnlineSubsystemUPlay_execClearMutingChangeDelegate_Parms ClearMutingChangeDelegate_Parms;
	memcpy ( &ClearMutingChangeDelegate_Parms.MutingDelegate, &MutingDelegate, 0x10 );

	this->ProcessEvent ( pFnClearMutingChangeDelegate, &ClearMutingChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddMutingChangeDelegate
// [0x00020002] 
// Parameters infos:
// struct FScriptDelegate         MutingDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddMutingChangeDelegate ( struct FScriptDelegate MutingDelegate )
{
	static UFunction* pFnAddMutingChangeDelegate = NULL;

	if ( ! pFnAddMutingChangeDelegate )
		pFnAddMutingChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46629 ];

	UOnlineSubsystemUPlay_execAddMutingChangeDelegate_Parms AddMutingChangeDelegate_Parms;
	memcpy ( &AddMutingChangeDelegate_Parms.MutingDelegate, &MutingDelegate, 0x10 );

	this->ProcessEvent ( pFnAddMutingChangeDelegate, &AddMutingChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsGuestLogin
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsGuestLogin ( unsigned char LocalUserNum )
{
	static UFunction* pFnIsGuestLogin = NULL;

	if ( ! pFnIsGuestLogin )
		pFnIsGuestLogin = (UFunction*) UObject::GObjObjects()->Data[ 46626 ];

	UOnlineSubsystemUPlay_execIsGuestLogin_Parms IsGuestLogin_Parms;
	IsGuestLogin_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnIsGuestLogin, &IsGuestLogin_Parms, NULL );

	return IsGuestLogin_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsLocalLogin
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsLocalLogin ( unsigned char LocalUserNum )
{
	static UFunction* pFnIsLocalLogin = NULL;

	if ( ! pFnIsLocalLogin )
		pFnIsLocalLogin = (UFunction*) UObject::GObjObjects()->Data[ 46623 ];

	UOnlineSubsystemUPlay_execIsLocalLogin_Parms IsLocalLogin_Parms;
	IsLocalLogin_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnIsLocalLogin, &IsLocalLogin_Parms, NULL );

	return IsLocalLogin_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginCancelledDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         CancelledDelegate              ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearLoginCancelledDelegate ( struct FScriptDelegate CancelledDelegate )
{
	static UFunction* pFnClearLoginCancelledDelegate = NULL;

	if ( ! pFnClearLoginCancelledDelegate )
		pFnClearLoginCancelledDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46621 ];

	UOnlineSubsystemUPlay_execClearLoginCancelledDelegate_Parms ClearLoginCancelledDelegate_Parms;
	memcpy ( &ClearLoginCancelledDelegate_Parms.CancelledDelegate, &CancelledDelegate, 0x10 );

	this->ProcessEvent ( pFnClearLoginCancelledDelegate, &ClearLoginCancelledDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginCancelledDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         CancelledDelegate              ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddLoginCancelledDelegate ( struct FScriptDelegate CancelledDelegate )
{
	static UFunction* pFnAddLoginCancelledDelegate = NULL;

	if ( ! pFnAddLoginCancelledDelegate )
		pFnAddLoginCancelledDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46619 ];

	UOnlineSubsystemUPlay_execAddLoginCancelledDelegate_Parms AddLoginCancelledDelegate_Parms;
	memcpy ( &AddLoginCancelledDelegate_Parms.CancelledDelegate, &CancelledDelegate, 0x10 );

	this->ProcessEvent ( pFnAddLoginCancelledDelegate, &AddLoginCancelledDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         LoginDelegate                  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearLoginChangeDelegate ( struct FScriptDelegate LoginDelegate )
{
	static UFunction* pFnClearLoginChangeDelegate = NULL;

	if ( ! pFnClearLoginChangeDelegate )
		pFnClearLoginChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46617 ];

	UOnlineSubsystemUPlay_execClearLoginChangeDelegate_Parms ClearLoginChangeDelegate_Parms;
	memcpy ( &ClearLoginChangeDelegate_Parms.LoginDelegate, &LoginDelegate, 0x10 );

	this->ProcessEvent ( pFnClearLoginChangeDelegate, &ClearLoginChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginChangeDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         LoginDelegate                  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddLoginChangeDelegate ( struct FScriptDelegate LoginDelegate )
{
	static UFunction* pFnAddLoginChangeDelegate = NULL;

	if ( ! pFnAddLoginChangeDelegate )
		pFnAddLoginChangeDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46615 ];

	UOnlineSubsystemUPlay_execAddLoginChangeDelegate_Parms AddLoginChangeDelegate_Parms;
	memcpy ( &AddLoginChangeDelegate_Parms.LoginDelegate, &LoginDelegate, 0x10 );

	this->ProcessEvent ( pFnAddLoginChangeDelegate, &AddLoginChangeDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowFriendsUI
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::ShowFriendsUI ( unsigned char LocalUserNum )
{
	static UFunction* pFnShowFriendsUI = NULL;

	if ( ! pFnShowFriendsUI )
		pFnShowFriendsUI = (UFunction*) UObject::GObjObjects()->Data[ 46612 ];

	UOnlineSubsystemUPlay_execShowFriendsUI_Parms ShowFriendsUI_Parms;
	ShowFriendsUI_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnShowFriendsUI, &ShowFriendsUI_Parms, NULL );

	return ShowFriendsUI_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsMuted
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsMuted ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID )
{
	static UFunction* pFnIsMuted = NULL;

	if ( ! pFnIsMuted )
		pFnIsMuted = (UFunction*) UObject::GObjObjects()->Data[ 46608 ];

	UOnlineSubsystemUPlay_execIsMuted_Parms IsMuted_Parms;
	IsMuted_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &IsMuted_Parms.PlayerID, &PlayerID, 0x8 );

	this->ProcessEvent ( pFnIsMuted, &IsMuted_Parms, NULL );

	return IsMuted_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AreAnyFriends
// [0x00420000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// TArray< struct FFriendsQuery > Query                          ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::AreAnyFriends ( unsigned char LocalUserNum, TArray< struct FFriendsQuery >* Query )
{
	static UFunction* pFnAreAnyFriends = NULL;

	if ( ! pFnAreAnyFriends )
		pFnAreAnyFriends = (UFunction*) UObject::GObjObjects()->Data[ 46603 ];

	UOnlineSubsystemUPlay_execAreAnyFriends_Parms AreAnyFriends_Parms;
	AreAnyFriends_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnAreAnyFriends, &AreAnyFriends_Parms, NULL );

	if ( Query )
		memcpy ( Query, &AreAnyFriends_Parms.Query, 0x10 );

	return AreAnyFriends_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsFriendUPlay
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 PlayerID                       ( CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::IsFriendUPlay ( struct FString PlayerID )
{
	static UFunction* pFnIsFriendUPlay = NULL;

	if ( ! pFnIsFriendUPlay )
		pFnIsFriendUPlay = (UFunction*) UObject::GObjObjects()->Data[ 46600 ];

	UOnlineSubsystemUPlay_execIsFriendUPlay_Parms IsFriendUPlay_Parms;
	memcpy ( &IsFriendUPlay_Parms.PlayerID, &PlayerID, 0x10 );

	pFnIsFriendUPlay->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnIsFriendUPlay, &IsFriendUPlay_Parms, NULL );

	pFnIsFriendUPlay->FunctionFlags |= 0x400;

	return IsFriendUPlay_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsFriend
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm )

bool UOnlineSubsystemUPlay::IsFriend ( unsigned char LocalUserNum, struct FUniqueNetId PlayerID )
{
	static UFunction* pFnIsFriend = NULL;

	if ( ! pFnIsFriend )
		pFnIsFriend = (UFunction*) UObject::GObjObjects()->Data[ 46596 ];

	UOnlineSubsystemUPlay_execIsFriend_Parms IsFriend_Parms;
	IsFriend_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &IsFriend_Parms.PlayerID, &PlayerID, 0x8 );

	this->ProcessEvent ( pFnIsFriend, &IsFriend_Parms, NULL );

	return IsFriend_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanShowPresenceInformation
// [0x00020000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

unsigned char UOnlineSubsystemUPlay::CanShowPresenceInformation ( unsigned char LocalUserNum )
{
	static UFunction* pFnCanShowPresenceInformation = NULL;

	if ( ! pFnCanShowPresenceInformation )
		pFnCanShowPresenceInformation = (UFunction*) UObject::GObjObjects()->Data[ 46593 ];

	UOnlineSubsystemUPlay_execCanShowPresenceInformation_Parms CanShowPresenceInformation_Parms;
	CanShowPresenceInformation_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnCanShowPresenceInformation, &CanShowPresenceInformation_Parms, NULL );

	return CanShowPresenceInformation_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanViewPlayerProfiles
// [0x00020000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

unsigned char UOnlineSubsystemUPlay::CanViewPlayerProfiles ( unsigned char LocalUserNum )
{
	static UFunction* pFnCanViewPlayerProfiles = NULL;

	if ( ! pFnCanViewPlayerProfiles )
		pFnCanViewPlayerProfiles = (UFunction*) UObject::GObjObjects()->Data[ 46590 ];

	UOnlineSubsystemUPlay_execCanViewPlayerProfiles_Parms CanViewPlayerProfiles_Parms;
	CanViewPlayerProfiles_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnCanViewPlayerProfiles, &CanViewPlayerProfiles_Parms, NULL );

	return CanViewPlayerProfiles_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanPurchaseContent
// [0x00020000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

unsigned char UOnlineSubsystemUPlay::CanPurchaseContent ( unsigned char LocalUserNum )
{
	static UFunction* pFnCanPurchaseContent = NULL;

	if ( ! pFnCanPurchaseContent )
		pFnCanPurchaseContent = (UFunction*) UObject::GObjObjects()->Data[ 46587 ];

	UOnlineSubsystemUPlay_execCanPurchaseContent_Parms CanPurchaseContent_Parms;
	CanPurchaseContent_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnCanPurchaseContent, &CanPurchaseContent_Parms, NULL );

	return CanPurchaseContent_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanDownloadUserContent
// [0x00020000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

unsigned char UOnlineSubsystemUPlay::CanDownloadUserContent ( unsigned char LocalUserNum )
{
	static UFunction* pFnCanDownloadUserContent = NULL;

	if ( ! pFnCanDownloadUserContent )
		pFnCanDownloadUserContent = (UFunction*) UObject::GObjObjects()->Data[ 46584 ];

	UOnlineSubsystemUPlay_execCanDownloadUserContent_Parms CanDownloadUserContent_Parms;
	CanDownloadUserContent_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnCanDownloadUserContent, &CanDownloadUserContent_Parms, NULL );

	return CanDownloadUserContent_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanCommunicate
// [0x00020000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

unsigned char UOnlineSubsystemUPlay::CanCommunicate ( unsigned char LocalUserNum )
{
	static UFunction* pFnCanCommunicate = NULL;

	if ( ! pFnCanCommunicate )
		pFnCanCommunicate = (UFunction*) UObject::GObjObjects()->Data[ 46581 ];

	UOnlineSubsystemUPlay_execCanCommunicate_Parms CanCommunicate_Parms;
	CanCommunicate_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnCanCommunicate, &CanCommunicate_Parms, NULL );

	return CanCommunicate_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.CanPlayOnline
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

unsigned char UOnlineSubsystemUPlay::CanPlayOnline ( unsigned char LocalUserNum )
{
	static UFunction* pFnCanPlayOnline = NULL;

	if ( ! pFnCanPlayOnline )
		pFnCanPlayOnline = (UFunction*) UObject::GObjObjects()->Data[ 46578 ];

	UOnlineSubsystemUPlay_execCanPlayOnline_Parms CanPlayOnline_Parms;
	CanPlayOnline_Parms.LocalUserNum = LocalUserNum;

	pFnCanPlayOnline->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnCanPlayOnline, &CanPlayOnline_Parms, NULL );

	pFnCanPlayOnline->FunctionFlags |= 0x400;

	return CanPlayOnline_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetPlayerNickname
// [0x00020002] 
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

struct FString UOnlineSubsystemUPlay::GetPlayerNickname ( unsigned char LocalUserNum )
{
	static UFunction* pFnGetPlayerNickname = NULL;

	if ( ! pFnGetPlayerNickname )
		pFnGetPlayerNickname = (UFunction*) UObject::GObjObjects()->Data[ 46575 ];

	UOnlineSubsystemUPlay_execGetPlayerNickname_Parms GetPlayerNickname_Parms;
	GetPlayerNickname_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnGetPlayerNickname, &GetPlayerNickname_Parms, NULL );

	return GetPlayerNickname_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetUniquePlayerId
// [0x00420002] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FUniqueNetId            PlayerID                       ( CPF_Parm | CPF_OutParm )

bool UOnlineSubsystemUPlay::GetUniquePlayerId ( unsigned char LocalUserNum, struct FUniqueNetId* PlayerID )
{
	static UFunction* pFnGetUniquePlayerId = NULL;

	if ( ! pFnGetUniquePlayerId )
		pFnGetUniquePlayerId = (UFunction*) UObject::GObjObjects()->Data[ 46571 ];

	UOnlineSubsystemUPlay_execGetUniquePlayerId_Parms GetUniquePlayerId_Parms;
	GetUniquePlayerId_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnGetUniquePlayerId, &GetUniquePlayerId_Parms, NULL );

	if ( PlayerID )
		memcpy ( PlayerID, &GetUniquePlayerId_Parms.PlayerID, 0x8 );

	return GetUniquePlayerId_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsStormDataAvailable
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::IsStormDataAvailable ( )
{
	static UFunction* pFnIsStormDataAvailable = NULL;

	if ( ! pFnIsStormDataAvailable )
		pFnIsStormDataAvailable = (UFunction*) UObject::GObjObjects()->Data[ 46569 ];

	UOnlineSubsystemUPlay_execIsStormDataAvailable_Parms IsStormDataAvailable_Parms;

	pFnIsStormDataAvailable->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnIsStormDataAvailable, &IsStormDataAvailable_Parms, NULL );

	pFnIsStormDataAvailable->FunctionFlags |= 0x400;

	return IsStormDataAvailable_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsInOfflineMode
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::IsInOfflineMode ( )
{
	static UFunction* pFnIsInOfflineMode = NULL;

	if ( ! pFnIsInOfflineMode )
		pFnIsInOfflineMode = (UFunction*) UObject::GObjObjects()->Data[ 46567 ];

	UOnlineSubsystemUPlay_execIsInOfflineMode_Parms IsInOfflineMode_Parms;

	pFnIsInOfflineMode->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnIsInOfflineMode, &IsInOfflineMode_Parms, NULL );

	pFnIsInOfflineMode->FunctionFlags |= 0x400;

	return IsInOfflineMode_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetLoginStatus
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

unsigned char UOnlineSubsystemUPlay::GetLoginStatus ( unsigned char LocalUserNum )
{
	static UFunction* pFnGetLoginStatus = NULL;

	if ( ! pFnGetLoginStatus )
		pFnGetLoginStatus = (UFunction*) UObject::GObjObjects()->Data[ 46564 ];

	UOnlineSubsystemUPlay_execGetLoginStatus_Parms GetLoginStatus_Parms;
	GetLoginStatus_Parms.LocalUserNum = LocalUserNum;

	pFnGetLoginStatus->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetLoginStatus, &GetLoginStatus_Parms, NULL );

	pFnGetLoginStatus->FunctionFlags |= 0x400;

	return GetLoginStatus_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLogoutCompletedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         LogoutDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearLogoutCompletedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LogoutDelegate )
{
	static UFunction* pFnClearLogoutCompletedDelegate = NULL;

	if ( ! pFnClearLogoutCompletedDelegate )
		pFnClearLogoutCompletedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46561 ];

	UOnlineSubsystemUPlay_execClearLogoutCompletedDelegate_Parms ClearLogoutCompletedDelegate_Parms;
	ClearLogoutCompletedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearLogoutCompletedDelegate_Parms.LogoutDelegate, &LogoutDelegate, 0x10 );

	this->ProcessEvent ( pFnClearLogoutCompletedDelegate, &ClearLogoutCompletedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLogoutCompletedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         LogoutDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddLogoutCompletedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LogoutDelegate )
{
	static UFunction* pFnAddLogoutCompletedDelegate = NULL;

	if ( ! pFnAddLogoutCompletedDelegate )
		pFnAddLogoutCompletedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46558 ];

	UOnlineSubsystemUPlay_execAddLogoutCompletedDelegate_Parms AddLogoutCompletedDelegate_Parms;
	AddLogoutCompletedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddLogoutCompletedDelegate_Parms.LogoutDelegate, &LogoutDelegate, 0x10 );

	this->ProcessEvent ( pFnAddLogoutCompletedDelegate, &AddLogoutCompletedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLogoutCompleted
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )

void UOnlineSubsystemUPlay::OnLogoutCompleted ( unsigned long bWasSuccessful )
{
	static UFunction* pFnOnLogoutCompleted = NULL;

	if ( ! pFnOnLogoutCompleted )
		pFnOnLogoutCompleted = (UFunction*) UObject::GObjObjects()->Data[ 46556 ];

	UOnlineSubsystemUPlay_execOnLogoutCompleted_Parms OnLogoutCompleted_Parms;
	OnLogoutCompleted_Parms.bWasSuccessful = bWasSuccessful;

	this->ProcessEvent ( pFnOnLogoutCompleted, &OnLogoutCompleted_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Logout
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )

bool UOnlineSubsystemUPlay::Logout ( unsigned char LocalUserNum )
{
	static UFunction* pFnLogout = NULL;

	if ( ! pFnLogout )
		pFnLogout = (UFunction*) UObject::GObjObjects()->Data[ 46553 ];

	UOnlineSubsystemUPlay_execLogout_Parms Logout_Parms;
	Logout_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnLogout, &Logout_Parms, NULL );

	return Logout_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearLoginFailedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         LoginDelegate                  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearLoginFailedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LoginDelegate )
{
	static UFunction* pFnClearLoginFailedDelegate = NULL;

	if ( ! pFnClearLoginFailedDelegate )
		pFnClearLoginFailedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46550 ];

	UOnlineSubsystemUPlay_execClearLoginFailedDelegate_Parms ClearLoginFailedDelegate_Parms;
	ClearLoginFailedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &ClearLoginFailedDelegate_Parms.LoginDelegate, &LoginDelegate, 0x10 );

	this->ProcessEvent ( pFnClearLoginFailedDelegate, &ClearLoginFailedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddLoginFailedDelegate
// [0x00020000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FScriptDelegate         LoginDelegate                  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddLoginFailedDelegate ( unsigned char LocalUserNum, struct FScriptDelegate LoginDelegate )
{
	static UFunction* pFnAddLoginFailedDelegate = NULL;

	if ( ! pFnAddLoginFailedDelegate )
		pFnAddLoginFailedDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46547 ];

	UOnlineSubsystemUPlay_execAddLoginFailedDelegate_Parms AddLoginFailedDelegate_Parms;
	AddLoginFailedDelegate_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &AddLoginFailedDelegate_Parms.LoginDelegate, &LoginDelegate, 0x10 );

	this->ProcessEvent ( pFnAddLoginFailedDelegate, &AddLoginFailedDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginFailed
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// unsigned char                  ErrorCode                      ( CPF_Parm )

void UOnlineSubsystemUPlay::OnLoginFailed ( unsigned char LocalUserNum, unsigned char ErrorCode )
{
	static UFunction* pFnOnLoginFailed = NULL;

	if ( ! pFnOnLoginFailed )
		pFnOnLoginFailed = (UFunction*) UObject::GObjObjects()->Data[ 46544 ];

	UOnlineSubsystemUPlay_execOnLoginFailed_Parms OnLoginFailed_Parms;
	OnLoginFailed_Parms.LocalUserNum = LocalUserNum;
	OnLoginFailed_Parms.ErrorCode = ErrorCode;

	this->ProcessEvent ( pFnOnLoginFailed, &OnLoginFailed_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AutoLogin
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::AutoLogin ( )
{
	static UFunction* pFnAutoLogin = NULL;

	if ( ! pFnAutoLogin )
		pFnAutoLogin = (UFunction*) UObject::GObjObjects()->Data[ 46542 ];

	UOnlineSubsystemUPlay_execAutoLogin_Parms AutoLogin_Parms;

	this->ProcessEvent ( pFnAutoLogin, &AutoLogin_Parms, NULL );

	return AutoLogin_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Login
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  LocalUserNum                   ( CPF_Parm )
// struct FString                 LoginName                      ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 Password                       ( CPF_Parm | CPF_NeedCtorLink )
// unsigned long                  bWantsLocalOnly                ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::Login ( unsigned char LocalUserNum, struct FString LoginName, struct FString Password, unsigned long bWantsLocalOnly )
{
	static UFunction* pFnLogin = NULL;

	if ( ! pFnLogin )
		pFnLogin = (UFunction*) UObject::GObjObjects()->Data[ 46536 ];

	UOnlineSubsystemUPlay_execLogin_Parms Login_Parms;
	Login_Parms.LocalUserNum = LocalUserNum;
	memcpy ( &Login_Parms.LoginName, &LoginName, 0x10 );
	memcpy ( &Login_Parms.Password, &Password, 0x10 );
	Login_Parms.bWantsLocalOnly = bWantsLocalOnly;

	this->ProcessEvent ( pFnLogin, &Login_Parms, NULL );

	return Login_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowLoginUI
// [0x00024000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned long                  bShowOnlineOnly                ( CPF_OptionalParm | CPF_Parm )

bool UOnlineSubsystemUPlay::ShowLoginUI ( unsigned long bShowOnlineOnly )
{
	static UFunction* pFnShowLoginUI = NULL;

	if ( ! pFnShowLoginUI )
		pFnShowLoginUI = (UFunction*) UObject::GObjObjects()->Data[ 46533 ];

	UOnlineSubsystemUPlay_execShowLoginUI_Parms ShowLoginUI_Parms;
	ShowLoginUI_Parms.bShowOnlineOnly = bShowOnlineOnly;

	this->ProcessEvent ( pFnShowLoginUI, &ShowLoginUI_Parms, NULL );

	return ShowLoginUI_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnFriendsChange
// [0x00120000] 
// Parameters infos:

void UOnlineSubsystemUPlay::OnFriendsChange ( )
{
	static UFunction* pFnOnFriendsChange = NULL;

	if ( ! pFnOnFriendsChange )
		pFnOnFriendsChange = (UFunction*) UObject::GObjObjects()->Data[ 46532 ];

	UOnlineSubsystemUPlay_execOnFriendsChange_Parms OnFriendsChange_Parms;

	this->ProcessEvent ( pFnOnFriendsChange, &OnFriendsChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearPlayerTalkingDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         TalkerDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearPlayerTalkingDelegate ( struct FScriptDelegate TalkerDelegate )
{
	static UFunction* pFnClearPlayerTalkingDelegate = NULL;

	if ( ! pFnClearPlayerTalkingDelegate )
		pFnClearPlayerTalkingDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46530 ];

	UOnlineSubsystemUPlay_execClearPlayerTalkingDelegate_Parms ClearPlayerTalkingDelegate_Parms;
	memcpy ( &ClearPlayerTalkingDelegate_Parms.TalkerDelegate, &TalkerDelegate, 0x10 );

	this->ProcessEvent ( pFnClearPlayerTalkingDelegate, &ClearPlayerTalkingDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddPlayerTalkingDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         TalkerDelegate                 ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddPlayerTalkingDelegate ( struct FScriptDelegate TalkerDelegate )
{
	static UFunction* pFnAddPlayerTalkingDelegate = NULL;

	if ( ! pFnAddPlayerTalkingDelegate )
		pFnAddPlayerTalkingDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46528 ];

	UOnlineSubsystemUPlay_execAddPlayerTalkingDelegate_Parms AddPlayerTalkingDelegate_Parms;
	memcpy ( &AddPlayerTalkingDelegate_Parms.TalkerDelegate, &TalkerDelegate, 0x10 );

	this->ProcessEvent ( pFnAddPlayerTalkingDelegate, &AddPlayerTalkingDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnPlayerTalkingStateChange
// [0x00120000] 
// Parameters infos:
// struct FUniqueNetId            Player                         ( CPF_Parm )
// unsigned long                  bIsTalking                     ( CPF_Parm )

void UOnlineSubsystemUPlay::OnPlayerTalkingStateChange ( struct FUniqueNetId Player, unsigned long bIsTalking )
{
	static UFunction* pFnOnPlayerTalkingStateChange = NULL;

	if ( ! pFnOnPlayerTalkingStateChange )
		pFnOnPlayerTalkingStateChange = (UFunction*) UObject::GObjObjects()->Data[ 46525 ];

	UOnlineSubsystemUPlay_execOnPlayerTalkingStateChange_Parms OnPlayerTalkingStateChange_Parms;
	memcpy ( &OnPlayerTalkingStateChange_Parms.Player, &Player, 0x8 );
	OnPlayerTalkingStateChange_Parms.bIsTalking = bIsTalking;

	this->ProcessEvent ( pFnOnPlayerTalkingStateChange, &OnPlayerTalkingStateChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetTitleFileState
// [0x00020000] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Filename                       ( CPF_Parm | CPF_NeedCtorLink )

unsigned char UOnlineSubsystemUPlay::GetTitleFileState ( struct FString Filename )
{
	static UFunction* pFnGetTitleFileState = NULL;

	if ( ! pFnGetTitleFileState )
		pFnGetTitleFileState = (UFunction*) UObject::GObjObjects()->Data[ 46522 ];

	UOnlineSubsystemUPlay_execGetTitleFileState_Parms GetTitleFileState_Parms;
	memcpy ( &GetTitleFileState_Parms.Filename, &Filename, 0x10 );

	this->ProcessEvent ( pFnGetTitleFileState, &GetTitleFileState_Parms, NULL );

	return GetTitleFileState_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetTitleFileContents
// [0x00420000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Filename                       ( CPF_Parm | CPF_NeedCtorLink )
// TArray< unsigned char >        FileContents                   ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::GetTitleFileContents ( struct FString Filename, TArray< unsigned char >* FileContents )
{
	static UFunction* pFnGetTitleFileContents = NULL;

	if ( ! pFnGetTitleFileContents )
		pFnGetTitleFileContents = (UFunction*) UObject::GObjObjects()->Data[ 46517 ];

	UOnlineSubsystemUPlay_execGetTitleFileContents_Parms GetTitleFileContents_Parms;
	memcpy ( &GetTitleFileContents_Parms.Filename, &Filename, 0x10 );

	this->ProcessEvent ( pFnGetTitleFileContents, &GetTitleFileContents_Parms, NULL );

	if ( FileContents )
		memcpy ( FileContents, &GetTitleFileContents_Parms.FileContents, 0x10 );

	return GetTitleFileContents_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearReadTitleFileCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ReadTitleFileCompleteDelegate  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::ClearReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate )
{
	static UFunction* pFnClearReadTitleFileCompleteDelegate = NULL;

	if ( ! pFnClearReadTitleFileCompleteDelegate )
		pFnClearReadTitleFileCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46515 ];

	UOnlineSubsystemUPlay_execClearReadTitleFileCompleteDelegate_Parms ClearReadTitleFileCompleteDelegate_Parms;
	memcpy ( &ClearReadTitleFileCompleteDelegate_Parms.ReadTitleFileCompleteDelegate, &ReadTitleFileCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnClearReadTitleFileCompleteDelegate, &ClearReadTitleFileCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.AddReadTitleFileCompleteDelegate
// [0x00020000] 
// Parameters infos:
// struct FScriptDelegate         ReadTitleFileCompleteDelegate  ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::AddReadTitleFileCompleteDelegate ( struct FScriptDelegate ReadTitleFileCompleteDelegate )
{
	static UFunction* pFnAddReadTitleFileCompleteDelegate = NULL;

	if ( ! pFnAddReadTitleFileCompleteDelegate )
		pFnAddReadTitleFileCompleteDelegate = (UFunction*) UObject::GObjObjects()->Data[ 46513 ];

	UOnlineSubsystemUPlay_execAddReadTitleFileCompleteDelegate_Parms AddReadTitleFileCompleteDelegate_Parms;
	memcpy ( &AddReadTitleFileCompleteDelegate_Parms.ReadTitleFileCompleteDelegate, &ReadTitleFileCompleteDelegate, 0x10 );

	this->ProcessEvent ( pFnAddReadTitleFileCompleteDelegate, &AddReadTitleFileCompleteDelegate_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ReadTitleFile
// [0x00020000] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 FileToRead                     ( CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::ReadTitleFile ( struct FString FileToRead )
{
	static UFunction* pFnReadTitleFile = NULL;

	if ( ! pFnReadTitleFile )
		pFnReadTitleFile = (UFunction*) UObject::GObjObjects()->Data[ 46510 ];

	UOnlineSubsystemUPlay_execReadTitleFile_Parms ReadTitleFile_Parms;
	memcpy ( &ReadTitleFile_Parms.FileToRead, &FileToRead, 0x10 );

	this->ProcessEvent ( pFnReadTitleFile, &ReadTitleFile_Parms, NULL );

	return ReadTitleFile_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnReadTitleFileComplete
// [0x00120000] 
// Parameters infos:
// unsigned long                  bWasSuccessful                 ( CPF_Parm )
// struct FString                 Filename                       ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::OnReadTitleFileComplete ( unsigned long bWasSuccessful, struct FString Filename )
{
	static UFunction* pFnOnReadTitleFileComplete = NULL;

	if ( ! pFnOnReadTitleFileComplete )
		pFnOnReadTitleFileComplete = (UFunction*) UObject::GObjObjects()->Data[ 46507 ];

	UOnlineSubsystemUPlay_execOnReadTitleFileComplete_Parms OnReadTitleFileComplete_Parms;
	OnReadTitleFileComplete_Parms.bWasSuccessful = bWasSuccessful;
	memcpy ( &OnReadTitleFileComplete_Parms.Filename, &Filename, 0x10 );

	this->ProcessEvent ( pFnOnReadTitleFileComplete, &OnReadTitleFileComplete_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnMutingChange
// [0x00120000] 
// Parameters infos:

void UOnlineSubsystemUPlay::OnMutingChange ( )
{
	static UFunction* pFnOnMutingChange = NULL;

	if ( ! pFnOnMutingChange )
		pFnOnMutingChange = (UFunction*) UObject::GObjObjects()->Data[ 46506 ];

	UOnlineSubsystemUPlay_execOnMutingChange_Parms OnMutingChange_Parms;

	this->ProcessEvent ( pFnOnMutingChange, &OnMutingChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginCancelled
// [0x00120000] 
// Parameters infos:

void UOnlineSubsystemUPlay::OnLoginCancelled ( )
{
	static UFunction* pFnOnLoginCancelled = NULL;

	if ( ! pFnOnLoginCancelled )
		pFnOnLoginCancelled = (UFunction*) UObject::GObjObjects()->Data[ 46505 ];

	UOnlineSubsystemUPlay_execOnLoginCancelled_Parms OnLoginCancelled_Parms;

	this->ProcessEvent ( pFnOnLoginCancelled, &OnLoginCancelled_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.OnLoginChange
// [0x00120000] 
// Parameters infos:
// unsigned char                  LocalUserNum                   ( CPF_Parm )

void UOnlineSubsystemUPlay::OnLoginChange ( unsigned char LocalUserNum )
{
	static UFunction* pFnOnLoginChange = NULL;

	if ( ! pFnOnLoginChange )
		pFnOnLoginChange = (UFunction*) UObject::GObjObjects()->Data[ 46503 ];

	UOnlineSubsystemUPlay_execOnLoginChange_Parms OnLoginChange_Parms;
	OnLoginChange_Parms.LocalUserNum = LocalUserNum;

	this->ProcessEvent ( pFnOnLoginChange, &OnLoginChange_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ClearTemporaryPrivileges
// [0x00020002] 
// Parameters infos:

void UOnlineSubsystemUPlay::ClearTemporaryPrivileges ( )
{
	static UFunction* pFnClearTemporaryPrivileges = NULL;

	if ( ! pFnClearTemporaryPrivileges )
		pFnClearTemporaryPrivileges = (UFunction*) UObject::GObjObjects()->Data[ 46502 ];

	UOnlineSubsystemUPlay_execClearTemporaryPrivileges_Parms ClearTemporaryPrivileges_Parms;

	this->ProcessEvent ( pFnClearTemporaryPrivileges, &ClearTemporaryPrivileges_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetTemporaryPrivileges
// [0x00020002] 
// Parameters infos:
// TArray< int >                  privileges                     ( CPF_Parm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::SetTemporaryPrivileges ( TArray< int > privileges )
{
	static UFunction* pFnSetTemporaryPrivileges = NULL;

	if ( ! pFnSetTemporaryPrivileges )
		pFnSetTemporaryPrivileges = (UFunction*) UObject::GObjObjects()->Data[ 46499 ];

	UOnlineSubsystemUPlay_execSetTemporaryPrivileges_Parms SetTemporaryPrivileges_Parms;
	memcpy ( &SetTemporaryPrivileges_Parms.privileges, &privileges, 0x10 );

	this->ProcessEvent ( pFnSetTemporaryPrivileges, &SetTemporaryPrivileges_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.PushEvent
// [0x00020002] 
// Parameters infos:
// struct FString                 EventType                      ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 EventName                      ( CPF_Parm | CPF_NeedCtorLink )
// class UJsonObject*             Event                          ( CPF_Parm )

void UOnlineSubsystemUPlay::PushEvent ( struct FString EventType, struct FString EventName, class UJsonObject* Event )
{
	static UFunction* pFnPushEvent = NULL;

	if ( ! pFnPushEvent )
		pFnPushEvent = (UFunction*) UObject::GObjObjects()->Data[ 46495 ];

	UOnlineSubsystemUPlay_execPushEvent_Parms PushEvent_Parms;
	memcpy ( &PushEvent_Parms.EventType, &EventType, 0x10 );
	memcpy ( &PushEvent_Parms.EventName, &EventName, 0x10 );
	PushEvent_Parms.Event = Event;

	this->ProcessEvent ( pFnPushEvent, &PushEvent_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetForceQuitMessageDisplayed
// [0x00020002] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::GetForceQuitMessageDisplayed ( )
{
	static UFunction* pFnGetForceQuitMessageDisplayed = NULL;

	if ( ! pFnGetForceQuitMessageDisplayed )
		pFnGetForceQuitMessageDisplayed = (UFunction*) UObject::GObjObjects()->Data[ 46493 ];

	UOnlineSubsystemUPlay_execGetForceQuitMessageDisplayed_Parms GetForceQuitMessageDisplayed_Parms;

	this->ProcessEvent ( pFnGetForceQuitMessageDisplayed, &GetForceQuitMessageDisplayed_Parms, NULL );

	return GetForceQuitMessageDisplayed_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetCurrentUPlayMessage
// [0x00020002] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

unsigned char UOnlineSubsystemUPlay::GetCurrentUPlayMessage ( )
{
	static UFunction* pFnGetCurrentUPlayMessage = NULL;

	if ( ! pFnGetCurrentUPlayMessage )
		pFnGetCurrentUPlayMessage = (UFunction*) UObject::GObjObjects()->Data[ 46491 ];

	UOnlineSubsystemUPlay_execGetCurrentUPlayMessage_Parms GetCurrentUPlayMessage_Parms;

	this->ProcessEvent ( pFnGetCurrentUPlayMessage, &GetCurrentUPlayMessage_Parms, NULL );

	return GetCurrentUPlayMessage_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.SetWaitingForStormData
// [0x00020002] 
// Parameters infos:

void UOnlineSubsystemUPlay::SetWaitingForStormData ( )
{
	static UFunction* pFnSetWaitingForStormData = NULL;

	if ( ! pFnSetWaitingForStormData )
		pFnSetWaitingForStormData = (UFunction*) UObject::GObjObjects()->Data[ 46490 ];

	UOnlineSubsystemUPlay_execSetWaitingForStormData_Parms SetWaitingForStormData_Parms;

	this->ProcessEvent ( pFnSetWaitingForStormData, &SetWaitingForStormData_Parms, NULL );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsOverlayOpen
// [0x00020002] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::IsOverlayOpen ( )
{
	static UFunction* pFnIsOverlayOpen = NULL;

	if ( ! pFnIsOverlayOpen )
		pFnIsOverlayOpen = (UFunction*) UObject::GObjObjects()->Data[ 46488 ];

	UOnlineSubsystemUPlay_execIsOverlayOpen_Parms IsOverlayOpen_Parms;

	this->ProcessEvent ( pFnIsOverlayOpen, &IsOverlayOpen_Parms, NULL );

	return IsOverlayOpen_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.GetInstalledWorkshopItemsDef
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// TArray< struct FWorkshopInstalledItemDef > outArray                       ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UOnlineSubsystemUPlay::GetInstalledWorkshopItemsDef ( TArray< struct FWorkshopInstalledItemDef >* outArray )
{
	static UFunction* pFnGetInstalledWorkshopItemsDef = NULL;

	if ( ! pFnGetInstalledWorkshopItemsDef )
		pFnGetInstalledWorkshopItemsDef = (UFunction*) UObject::GObjObjects()->Data[ 46485 ];

	UOnlineSubsystemUPlay_execGetInstalledWorkshopItemsDef_Parms GetInstalledWorkshopItemsDef_Parms;

	pFnGetInstalledWorkshopItemsDef->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetInstalledWorkshopItemsDef, &GetInstalledWorkshopItemsDef_Parms, NULL );

	pFnGetInstalledWorkshopItemsDef->FunctionFlags |= 0x400;

	if ( outArray )
		memcpy ( outArray, &GetInstalledWorkshopItemsDef_Parms.outArray, 0x10 );
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ResetAllUSteamAchievements
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UOnlineSubsystemUPlay::ResetAllUSteamAchievements ( )
{
	static UFunction* pFnResetAllUSteamAchievements = NULL;

	if ( ! pFnResetAllUSteamAchievements )
		pFnResetAllUSteamAchievements = (UFunction*) UObject::GObjObjects()->Data[ 46484 ];

	UOnlineSubsystemUPlay_execResetAllUSteamAchievements_Parms ResetAllUSteamAchievements_Parms;

	pFnResetAllUSteamAchievements->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnResetAllUSteamAchievements, &ResetAllUSteamAchievements_Parms, NULL );

	pFnResetAllUSteamAchievements->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.UnlockUSteamAchievement
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 AchievementId                  ( CPF_Parm | CPF_NeedCtorLink )

bool UOnlineSubsystemUPlay::UnlockUSteamAchievement ( struct FString AchievementId )
{
	static UFunction* pFnUnlockUSteamAchievement = NULL;

	if ( ! pFnUnlockUSteamAchievement )
		pFnUnlockUSteamAchievement = (UFunction*) UObject::GObjObjects()->Data[ 46481 ];

	UOnlineSubsystemUPlay_execUnlockUSteamAchievement_Parms UnlockUSteamAchievement_Parms;
	memcpy ( &UnlockUSteamAchievement_Parms.AchievementId, &AchievementId, 0x10 );

	pFnUnlockUSteamAchievement->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnUnlockUSteamAchievement, &UnlockUSteamAchievement_Parms, NULL );

	pFnUnlockUSteamAchievement->FunctionFlags |= 0x400;

	return UnlockUSteamAchievement_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowUPlayRedeem
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UOnlineSubsystemUPlay::ShowUPlayRedeem ( )
{
	static UFunction* pFnShowUPlayRedeem = NULL;

	if ( ! pFnShowUPlayRedeem )
		pFnShowUPlayRedeem = (UFunction*) UObject::GObjObjects()->Data[ 46480 ];

	UOnlineSubsystemUPlay_execShowUPlayRedeem_Parms ShowUPlayRedeem_Parms;

	pFnShowUPlayRedeem->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnShowUPlayRedeem, &ShowUPlayRedeem_Parms, NULL );

	pFnShowUPlayRedeem->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.ShowUPlayOverlay
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UOnlineSubsystemUPlay::ShowUPlayOverlay ( )
{
	static UFunction* pFnShowUPlayOverlay = NULL;

	if ( ! pFnShowUPlayOverlay )
		pFnShowUPlayOverlay = (UFunction*) UObject::GObjObjects()->Data[ 46479 ];

	UOnlineSubsystemUPlay_execShowUPlayOverlay_Parms ShowUPlayOverlay_Parms;

	pFnShowUPlayOverlay->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnShowUPlayOverlay, &ShowUPlayOverlay_Parms, NULL );

	pFnShowUPlayOverlay->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.IsActive
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::IsActive ( )
{
	static UFunction* pFnIsActive = NULL;

	if ( ! pFnIsActive )
		pFnIsActive = (UFunction*) UObject::GObjObjects()->Data[ 46477 ];

	UOnlineSubsystemUPlay_execIsActive_Parms IsActive_Parms;

	pFnIsActive->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnIsActive, &IsActive_Parms, NULL );

	pFnIsActive->FunctionFlags |= 0x400;

	return IsActive_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Exit
// [0x00020C00] ( FUNC_Event | FUNC_Native )
// Parameters infos:

void UOnlineSubsystemUPlay::eventExit ( )
{
	static UFunction* pFnExit = NULL;

	if ( ! pFnExit )
		pFnExit = (UFunction*) UObject::GObjObjects()->Data[ 46476 ];

	UOnlineSubsystemUPlay_eventExit_Parms Exit_Parms;

	pFnExit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnExit, &Exit_Parms, NULL );

	pFnExit->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.OnlineSubsystemUPlay.Init
// [0x00020C00] ( FUNC_Event | FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UOnlineSubsystemUPlay::eventInit ( )
{
	static UFunction* pFnInit = NULL;

	if ( ! pFnInit )
		pFnInit = (UFunction*) UObject::GObjObjects()->Data[ 46474 ];

	UOnlineSubsystemUPlay_eventInit_Parms Init_Parms;

	pFnInit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInit, &Init_Parms, NULL );

	pFnInit->FunctionFlags |= 0x400;

	return Init_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.SetCredentials
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FPointer                credentials                    ( CPF_Parm )

void URDVAsyncTask::SetCredentials ( struct FPointer credentials )
{
	static UFunction* pFnSetCredentials = NULL;

	if ( ! pFnSetCredentials )
		pFnSetCredentials = (UFunction*) UObject::GObjObjects()->Data[ 47119 ];

	URDVAsyncTask_execSetCredentials_Parms SetCredentials_Parms;
	memcpy ( &SetCredentials_Parms.credentials, &credentials, 0x8 );

	pFnSetCredentials->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetCredentials, &SetCredentials_Parms, NULL );

	pFnSetCredentials->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.LogResult
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVAsyncTask::LogResult ( )
{
	static UFunction* pFnLogResult = NULL;

	if ( ! pFnLogResult )
		pFnLogResult = (UFunction*) UObject::GObjObjects()->Data[ 47118 ];

	URDVAsyncTask_execLogResult_Parms LogResult_Parms;

	pFnLogResult->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLogResult, &LogResult_Parms, NULL );

	pFnLogResult->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.GetTaskType
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

unsigned char URDVAsyncTask::GetTaskType ( )
{
	static UFunction* pFnGetTaskType = NULL;

	if ( ! pFnGetTaskType )
		pFnGetTaskType = (UFunction*) UObject::GObjObjects()->Data[ 47116 ];

	URDVAsyncTask_execGetTaskType_Parms GetTaskType_Parms;

	pFnGetTaskType->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetTaskType, &GetTaskType_Parms, NULL );

	pFnGetTaskType->FunctionFlags |= 0x400;

	return GetTaskType_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.WasSuccessfull
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool URDVAsyncTask::WasSuccessfull ( )
{
	static UFunction* pFnWasSuccessfull = NULL;

	if ( ! pFnWasSuccessfull )
		pFnWasSuccessfull = (UFunction*) UObject::GObjObjects()->Data[ 47114 ];

	URDVAsyncTask_execWasSuccessfull_Parms WasSuccessfull_Parms;

	pFnWasSuccessfull->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnWasSuccessfull, &WasSuccessfull_Parms, NULL );

	pFnWasSuccessfull->FunctionFlags |= 0x400;

	return WasSuccessfull_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.IsTaskFinished
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool URDVAsyncTask::IsTaskFinished ( )
{
	static UFunction* pFnIsTaskFinished = NULL;

	if ( ! pFnIsTaskFinished )
		pFnIsTaskFinished = (UFunction*) UObject::GObjObjects()->Data[ 47112 ];

	URDVAsyncTask_execIsTaskFinished_Parms IsTaskFinished_Parms;

	pFnIsTaskFinished->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnIsTaskFinished, &IsTaskFinished_Parms, NULL );

	pFnIsTaskFinished->FunctionFlags |= 0x400;

	return IsTaskFinished_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.Cleanup
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVAsyncTask::Cleanup ( )
{
	static UFunction* pFnCleanup = NULL;

	if ( ! pFnCleanup )
		pFnCleanup = (UFunction*) UObject::GObjObjects()->Data[ 47111 ];

	URDVAsyncTask_execCleanup_Parms Cleanup_Parms;

	pFnCleanup->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnCleanup, &Cleanup_Parms, NULL );

	pFnCleanup->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVAsyncTask.Init
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned char                  taskType                       ( CPF_Parm )

void URDVAsyncTask::Init ( unsigned char taskType )
{
	static UFunction* pFnInit = NULL;

	if ( ! pFnInit )
		pFnInit = (UFunction*) UObject::GObjObjects()->Data[ 47109 ];

	URDVAsyncTask_execInit_Parms Init_Parms;
	Init_Parms.taskType = taskType;

	pFnInit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInit, &Init_Parms, NULL );

	pFnInit->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.FinishAsyncTask
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void URDVAsyncTaskManager::FinishAsyncTask ( class URDVAsyncTask* task )
{
	static UFunction* pFnFinishAsyncTask = NULL;

	if ( ! pFnFinishAsyncTask )
		pFnFinishAsyncTask = (UFunction*) UObject::GObjObjects()->Data[ 47131 ];

	URDVAsyncTaskManager_execFinishAsyncTask_Parms FinishAsyncTask_Parms;
	FinishAsyncTask_Parms.task = task;

	pFnFinishAsyncTask->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnFinishAsyncTask, &FinishAsyncTask_Parms, NULL );

	pFnFinishAsyncTask->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.GetNextFinishedTask
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

class URDVAsyncTask* URDVAsyncTaskManager::GetNextFinishedTask ( )
{
	static UFunction* pFnGetNextFinishedTask = NULL;

	if ( ! pFnGetNextFinishedTask )
		pFnGetNextFinishedTask = (UFunction*) UObject::GObjObjects()->Data[ 47129 ];

	URDVAsyncTaskManager_execGetNextFinishedTask_Parms GetNextFinishedTask_Parms;

	pFnGetNextFinishedTask->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetNextFinishedTask, &GetNextFinishedTask_Parms, NULL );

	pFnGetNextFinishedTask->FunctionFlags |= 0x400;

	return GetNextFinishedTask_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.StartAsyncTask
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// unsigned char                  taskType                       ( CPF_Parm )

class URDVAsyncTask* URDVAsyncTaskManager::StartAsyncTask ( unsigned char taskType )
{
	static UFunction* pFnStartAsyncTask = NULL;

	if ( ! pFnStartAsyncTask )
		pFnStartAsyncTask = (UFunction*) UObject::GObjObjects()->Data[ 47126 ];

	URDVAsyncTaskManager_execStartAsyncTask_Parms StartAsyncTask_Parms;
	StartAsyncTask_Parms.taskType = taskType;

	pFnStartAsyncTask->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStartAsyncTask, &StartAsyncTask_Parms, NULL );

	pFnStartAsyncTask->FunctionFlags |= 0x400;

	return StartAsyncTask_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.RDVAsyncTaskManager.Init
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FPointer                facade                         ( CPF_Parm )

void URDVAsyncTaskManager::Init ( struct FPointer facade )
{
	static UFunction* pFnInit = NULL;

	if ( ! pFnInit )
		pFnInit = (UFunction*) UObject::GObjObjects()->Data[ 47124 ];

	URDVAsyncTaskManager_execInit_Parms Init_Parms;
	memcpy ( &Init_Parms.facade, &facade, 0x8 );

	pFnInit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInit, &Init_Parms, NULL );

	pFnInit->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.UpdateGUILoginSuccesfullRDV
// [0x00020800] ( FUNC_Event )
// Parameters infos:

void URDVManager::eventUpdateGUILoginSuccesfullRDV ( )
{
	static UFunction* pFnUpdateGUILoginSuccesfullRDV = NULL;

	if ( ! pFnUpdateGUILoginSuccesfullRDV )
		pFnUpdateGUILoginSuccesfullRDV = (UFunction*) UObject::GObjObjects()->Data[ 47156 ];

	URDVManager_eventUpdateGUILoginSuccesfullRDV_Parms UpdateGUILoginSuccesfullRDV_Parms;

	this->ProcessEvent ( pFnUpdateGUILoginSuccesfullRDV, &UpdateGUILoginSuccesfullRDV_Parms, NULL );
};

// Function OnlineSubsystemUPlay.RDVManager.UpdateGUILoginFailedRDV
// [0x00020800] ( FUNC_Event )
// Parameters infos:

void URDVManager::eventUpdateGUILoginFailedRDV ( )
{
	static UFunction* pFnUpdateGUILoginFailedRDV = NULL;

	if ( ! pFnUpdateGUILoginFailedRDV )
		pFnUpdateGUILoginFailedRDV = (UFunction*) UObject::GObjObjects()->Data[ 47155 ];

	URDVManager_eventUpdateGUILoginFailedRDV_Parms UpdateGUILoginFailedRDV_Parms;

	this->ProcessEvent ( pFnUpdateGUILoginFailedRDV, &UpdateGUILoginFailedRDV_Parms, NULL );
};

// Function OnlineSubsystemUPlay.RDVManager.JoinGameByInvite
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FPointer                invite                         ( CPF_Parm )

void URDVManager::JoinGameByInvite ( struct FPointer invite )
{
	static UFunction* pFnJoinGameByInvite = NULL;

	if ( ! pFnJoinGameByInvite )
		pFnJoinGameByInvite = (UFunction*) UObject::GObjObjects()->Data[ 47153 ];

	URDVManager_execJoinGameByInvite_Parms JoinGameByInvite_Parms;
	memcpy ( &JoinGameByInvite_Parms.invite, &invite, 0x8 );

	pFnJoinGameByInvite->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnJoinGameByInvite, &JoinGameByInvite_Parms, NULL );

	pFnJoinGameByInvite->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.SetDisconnected
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVManager::SetDisconnected ( )
{
	static UFunction* pFnSetDisconnected = NULL;

	if ( ! pFnSetDisconnected )
		pFnSetDisconnected = (UFunction*) UObject::GObjObjects()->Data[ 47152 ];

	URDVManager_execSetDisconnected_Parms SetDisconnected_Parms;

	pFnSetDisconnected->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetDisconnected, &SetDisconnected_Parms, NULL );

	pFnSetDisconnected->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.Cleanup
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVManager::Cleanup ( )
{
	static UFunction* pFnCleanup = NULL;

	if ( ! pFnCleanup )
		pFnCleanup = (UFunction*) UObject::GObjObjects()->Data[ 47151 ];

	URDVManager_execCleanup_Parms Cleanup_Parms;

	pFnCleanup->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnCleanup, &Cleanup_Parms, NULL );

	pFnCleanup->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.Logout
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVManager::Logout ( )
{
	static UFunction* pFnLogout = NULL;

	if ( ! pFnLogout )
		pFnLogout = (UFunction*) UObject::GObjObjects()->Data[ 47150 ];

	URDVManager_execLogout_Parms Logout_Parms;

	pFnLogout->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLogout, &Logout_Parms, NULL );

	pFnLogout->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.RegisterUrlTaskDone
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void URDVManager::RegisterUrlTaskDone ( class URDVAsyncTask* task )
{
	static UFunction* pFnRegisterUrlTaskDone = NULL;

	if ( ! pFnRegisterUrlTaskDone )
		pFnRegisterUrlTaskDone = (UFunction*) UObject::GObjObjects()->Data[ 47148 ];

	URDVManager_execRegisterUrlTaskDone_Parms RegisterUrlTaskDone_Parms;
	RegisterUrlTaskDone_Parms.task = task;

	pFnRegisterUrlTaskDone->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnRegisterUrlTaskDone, &RegisterUrlTaskDone_Parms, NULL );

	pFnRegisterUrlTaskDone->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.LoginTaskDone
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVAsyncTask*           task                           ( CPF_Parm )

void URDVManager::LoginTaskDone ( class URDVAsyncTask* task )
{
	static UFunction* pFnLoginTaskDone = NULL;

	if ( ! pFnLoginTaskDone )
		pFnLoginTaskDone = (UFunction*) UObject::GObjObjects()->Data[ 47146 ];

	URDVManager_execLoginTaskDone_Parms LoginTaskDone_Parms;
	LoginTaskDone_Parms.task = task;

	pFnLoginTaskDone->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLoginTaskDone, &LoginTaskDone_Parms, NULL );

	pFnLoginTaskDone->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.Tick
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVManager::Tick ( )
{
	static UFunction* pFnTick = NULL;

	if ( ! pFnTick )
		pFnTick = (UFunction*) UObject::GObjObjects()->Data[ 47145 ];

	URDVManager_execTick_Parms Tick_Parms;

	pFnTick->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnTick, &Tick_Parms, NULL );

	pFnTick->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.Login
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVManager::Login ( )
{
	static UFunction* pFnLogin = NULL;

	if ( ! pFnLogin )
		pFnLogin = (UFunction*) UObject::GObjObjects()->Data[ 47144 ];

	URDVManager_execLogin_Parms Login_Parms;

	pFnLogin->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLogin, &Login_Parms, NULL );

	pFnLogin->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.ShowDisconnectMessage
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void URDVManager::ShowDisconnectMessage ( )
{
	static UFunction* pFnShowDisconnectMessage = NULL;

	if ( ! pFnShowDisconnectMessage )
		pFnShowDisconnectMessage = (UFunction*) UObject::GObjObjects()->Data[ 47143 ];

	URDVManager_execShowDisconnectMessage_Parms ShowDisconnectMessage_Parms;

	pFnShowDisconnectMessage->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnShowDisconnectMessage, &ShowDisconnectMessage_Parms, NULL );

	pFnShowDisconnectMessage->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.RDVManager.Init
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class UUbiservicesManager*     ubiManager                     ( CPF_Parm )
// class UOnlineGameInterfaceUPlay* GameInterface                  ( CPF_Parm )

void URDVManager::Init ( class UUbiservicesManager* ubiManager, class UOnlineGameInterfaceUPlay* GameInterface )
{
	static UFunction* pFnInit = NULL;

	if ( ! pFnInit )
		pFnInit = (UFunction*) UObject::GObjObjects()->Data[ 47140 ];

	URDVManager_execInit_Parms Init_Parms;
	Init_Parms.ubiManager = ubiManager;
	Init_Parms.GameInterface = GameInterface;

	pFnInit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInit, &Init_Parms, NULL );

	pFnInit->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.FormatPeerDataForCommand
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
// struct FString                 inPeerData                     ( CPF_Parm | CPF_NeedCtorLink )

struct FString UStormManager::FormatPeerDataForCommand ( struct FString inPeerData )
{
	static UFunction* pFnFormatPeerDataForCommand = NULL;

	if ( ! pFnFormatPeerDataForCommand )
		pFnFormatPeerDataForCommand = (UFunction*) UObject::GObjObjects()->Data[ 46337 ];

	UStormManager_execFormatPeerDataForCommand_Parms FormatPeerDataForCommand_Parms;
	memcpy ( &FormatPeerDataForCommand_Parms.inPeerData, &inPeerData, 0x10 );

	pFnFormatPeerDataForCommand->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnFormatPeerDataForCommand, &FormatPeerDataForCommand_Parms, NULL );

	pFnFormatPeerDataForCommand->FunctionFlags |= 0x400;

	return FormatPeerDataForCommand_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_Tick
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_Tick ( )
{
	static UFunction* pFnStorm_Tick = NULL;

	if ( ! pFnStorm_Tick )
		pFnStorm_Tick = (UFunction*) UObject::GObjObjects()->Data[ 46336 ];

	UStormManager_execStorm_Tick_Parms Storm_Tick_Parms;

	pFnStorm_Tick->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_Tick, &Storm_Tick_Parms, NULL );

	pFnStorm_Tick->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_Shutdown
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_Shutdown ( )
{
	static UFunction* pFnStorm_Shutdown = NULL;

	if ( ! pFnStorm_Shutdown )
		pFnStorm_Shutdown = (UFunction*) UObject::GObjObjects()->Data[ 46335 ];

	UStormManager_execStorm_Shutdown_Parms Storm_Shutdown_Parms;

	pFnStorm_Shutdown->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_Shutdown, &Storm_Shutdown_Parms, NULL );

	pFnStorm_Shutdown->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_TriggerError
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_TriggerError ( )
{
	static UFunction* pFnStorm_TriggerError = NULL;

	if ( ! pFnStorm_TriggerError )
		pFnStorm_TriggerError = (UFunction*) UObject::GObjObjects()->Data[ 46334 ];

	UStormManager_execStorm_TriggerError_Parms Storm_TriggerError_Parms;

	pFnStorm_TriggerError->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_TriggerError, &Storm_TriggerError_Parms, NULL );

	pFnStorm_TriggerError->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_WarnPendingRegistrationStormNetDriver
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_WarnPendingRegistrationStormNetDriver ( )
{
	static UFunction* pFnStorm_WarnPendingRegistrationStormNetDriver = NULL;

	if ( ! pFnStorm_WarnPendingRegistrationStormNetDriver )
		pFnStorm_WarnPendingRegistrationStormNetDriver = (UFunction*) UObject::GObjObjects()->Data[ 46333 ];

	UStormManager_execStorm_WarnPendingRegistrationStormNetDriver_Parms Storm_WarnPendingRegistrationStormNetDriver_Parms;

	pFnStorm_WarnPendingRegistrationStormNetDriver->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_WarnPendingRegistrationStormNetDriver, &Storm_WarnPendingRegistrationStormNetDriver_Parms, NULL );

	pFnStorm_WarnPendingRegistrationStormNetDriver->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnTraversalStarted
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_OnTraversalStarted ( )
{
	static UFunction* pFnStorm_OnTraversalStarted = NULL;

	if ( ! pFnStorm_OnTraversalStarted )
		pFnStorm_OnTraversalStarted = (UFunction*) UObject::GObjObjects()->Data[ 46332 ];

	UStormManager_execStorm_OnTraversalStarted_Parms Storm_OnTraversalStarted_Parms;

	pFnStorm_OnTraversalStarted->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_OnTraversalStarted, &Storm_OnTraversalStarted_Parms, NULL );

	pFnStorm_OnTraversalStarted->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_StartTraversal
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_StartTraversal ( )
{
	static UFunction* pFnStorm_StartTraversal = NULL;

	if ( ! pFnStorm_StartTraversal )
		pFnStorm_StartTraversal = (UFunction*) UObject::GObjObjects()->Data[ 46331 ];

	UStormManager_execStorm_StartTraversal_Parms Storm_StartTraversal_Parms;

	pFnStorm_StartTraversal->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_StartTraversal, &Storm_StartTraversal_Parms, NULL );

	pFnStorm_StartTraversal->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnNatDetermined
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_OnNatDetermined ( )
{
	static UFunction* pFnStorm_OnNatDetermined = NULL;

	if ( ! pFnStorm_OnNatDetermined )
		pFnStorm_OnNatDetermined = (UFunction*) UObject::GObjObjects()->Data[ 46330 ];

	UStormManager_execStorm_OnNatDetermined_Parms Storm_OnNatDetermined_Parms;

	pFnStorm_OnNatDetermined->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_OnNatDetermined, &Storm_OnNatDetermined_Parms, NULL );

	pFnStorm_OnNatDetermined->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnUPnPMappingDone
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// int                            Port                           ( CPF_Parm )

void UStormManager::Storm_OnUPnPMappingDone ( int Port )
{
	static UFunction* pFnStorm_OnUPnPMappingDone = NULL;

	if ( ! pFnStorm_OnUPnPMappingDone )
		pFnStorm_OnUPnPMappingDone = (UFunction*) UObject::GObjObjects()->Data[ 46328 ];

	UStormManager_execStorm_OnUPnPMappingDone_Parms Storm_OnUPnPMappingDone_Parms;
	Storm_OnUPnPMappingDone_Parms.Port = Port;

	pFnStorm_OnUPnPMappingDone->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_OnUPnPMappingDone, &Storm_OnUPnPMappingDone_Parms, NULL );

	pFnStorm_OnUPnPMappingDone->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_OnClientInitialized
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UStormManager::Storm_OnClientInitialized ( )
{
	static UFunction* pFnStorm_OnClientInitialized = NULL;

	if ( ! pFnStorm_OnClientInitialized )
		pFnStorm_OnClientInitialized = (UFunction*) UObject::GObjObjects()->Data[ 46327 ];

	UStormManager_execStorm_OnClientInitialized_Parms Storm_OnClientInitialized_Parms;

	pFnStorm_OnClientInitialized->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_OnClientInitialized, &Storm_OnClientInitialized_Parms, NULL );

	pFnStorm_OnClientInitialized->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.StormManager.Storm_Init
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVManager*             rdvManagerOwner                ( CPF_Parm )

void UStormManager::Storm_Init ( class URDVManager* rdvManagerOwner )
{
	static UFunction* pFnStorm_Init = NULL;

	if ( ! pFnStorm_Init )
		pFnStorm_Init = (UFunction*) UObject::GObjObjects()->Data[ 46325 ];

	UStormManager_execStorm_Init_Parms Storm_Init_Parms;
	Storm_Init_Parms.rdvManagerOwner = rdvManagerOwner;

	pFnStorm_Init->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStorm_Init, &Storm_Init_Parms, NULL );

	pFnStorm_Init->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.UpdateGUILoginFailedUbiservices
// [0x00020800] ( FUNC_Event )
// Parameters infos:

void UUbiservicesManager::eventUpdateGUILoginFailedUbiservices ( )
{
	static UFunction* pFnUpdateGUILoginFailedUbiservices = NULL;

	if ( ! pFnUpdateGUILoginFailedUbiservices )
		pFnUpdateGUILoginFailedUbiservices = (UFunction*) UObject::GObjObjects()->Data[ 47180 ];

	UUbiservicesManager_eventUpdateGUILoginFailedUbiservices_Parms UpdateGUILoginFailedUbiservices_Parms;

	this->ProcessEvent ( pFnUpdateGUILoginFailedUbiservices, &UpdateGUILoginFailedUbiservices_Parms, NULL );
};

// Function OnlineSubsystemUPlay.UbiservicesManager.CheckForReLogin
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UUbiservicesManager::CheckForReLogin ( )
{
	static UFunction* pFnCheckForReLogin = NULL;

	if ( ! pFnCheckForReLogin )
		pFnCheckForReLogin = (UFunction*) UObject::GObjObjects()->Data[ 47179 ];

	UUbiservicesManager_execCheckForReLogin_Parms CheckForReLogin_Parms;

	pFnCheckForReLogin->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnCheckForReLogin, &CheckForReLogin_Parms, NULL );

	pFnCheckForReLogin->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.SetDisconnected
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UUbiservicesManager::SetDisconnected ( )
{
	static UFunction* pFnSetDisconnected = NULL;

	if ( ! pFnSetDisconnected )
		pFnSetDisconnected = (UFunction*) UObject::GObjObjects()->Data[ 47178 ];

	UUbiservicesManager_execSetDisconnected_Parms SetDisconnected_Parms;

	pFnSetDisconnected->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetDisconnected, &SetDisconnected_Parms, NULL );

	pFnSetDisconnected->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.DoesNeedReconnect
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UUbiservicesManager::DoesNeedReconnect ( )
{
	static UFunction* pFnDoesNeedReconnect = NULL;

	if ( ! pFnDoesNeedReconnect )
		pFnDoesNeedReconnect = (UFunction*) UObject::GObjObjects()->Data[ 47176 ];

	UUbiservicesManager_execDoesNeedReconnect_Parms DoesNeedReconnect_Parms;

	pFnDoesNeedReconnect->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnDoesNeedReconnect, &DoesNeedReconnect_Parms, NULL );

	pFnDoesNeedReconnect->FunctionFlags |= 0x400;

	return DoesNeedReconnect_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.PushEvent
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// struct FString                 EventType                      ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 EventName                      ( CPF_Parm | CPF_NeedCtorLink )
// class UJsonObject*             Event                          ( CPF_Parm )

void UUbiservicesManager::PushEvent ( struct FString EventType, struct FString EventName, class UJsonObject* Event )
{
	static UFunction* pFnPushEvent = NULL;

	if ( ! pFnPushEvent )
		pFnPushEvent = (UFunction*) UObject::GObjObjects()->Data[ 47172 ];

	UUbiservicesManager_execPushEvent_Parms PushEvent_Parms;
	memcpy ( &PushEvent_Parms.EventType, &EventType, 0x10 );
	memcpy ( &PushEvent_Parms.EventName, &EventName, 0x10 );
	PushEvent_Parms.Event = Event;

	pFnPushEvent->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPushEvent, &PushEvent_Parms, NULL );

	pFnPushEvent->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Cleanup
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UUbiservicesManager::Cleanup ( )
{
	static UFunction* pFnCleanup = NULL;

	if ( ! pFnCleanup )
		pFnCleanup = (UFunction*) UObject::GObjObjects()->Data[ 47171 ];

	UUbiservicesManager_execCleanup_Parms Cleanup_Parms;

	pFnCleanup->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnCleanup, &Cleanup_Parms, NULL );

	pFnCleanup->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Logout
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UUbiservicesManager::Logout ( )
{
	static UFunction* pFnLogout = NULL;

	if ( ! pFnLogout )
		pFnLogout = (UFunction*) UObject::GObjObjects()->Data[ 47170 ];

	UUbiservicesManager_execLogout_Parms Logout_Parms;

	pFnLogout->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLogout, &Logout_Parms, NULL );

	pFnLogout->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.TickAsyncTasks
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UUbiservicesManager::TickAsyncTasks ( )
{
	static UFunction* pFnTickAsyncTasks = NULL;

	if ( ! pFnTickAsyncTasks )
		pFnTickAsyncTasks = (UFunction*) UObject::GObjObjects()->Data[ 47169 ];

	UUbiservicesManager_execTickAsyncTasks_Parms TickAsyncTasks_Parms;

	pFnTickAsyncTasks->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnTickAsyncTasks, &TickAsyncTasks_Parms, NULL );

	pFnTickAsyncTasks->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.IsSessionValid
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UUbiservicesManager::IsSessionValid ( )
{
	static UFunction* pFnIsSessionValid = NULL;

	if ( ! pFnIsSessionValid )
		pFnIsSessionValid = (UFunction*) UObject::GObjObjects()->Data[ 47167 ];

	UUbiservicesManager_execIsSessionValid_Parms IsSessionValid_Parms;

	pFnIsSessionValid->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnIsSessionValid, &IsSessionValid_Parms, NULL );

	pFnIsSessionValid->FunctionFlags |= 0x400;

	return IsSessionValid_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Login
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UUbiservicesManager::Login ( )
{
	static UFunction* pFnLogin = NULL;

	if ( ! pFnLogin )
		pFnLogin = (UFunction*) UObject::GObjObjects()->Data[ 47166 ];

	UUbiservicesManager_execLogin_Parms Login_Parms;

	pFnLogin->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLogin, &Login_Parms, NULL );

	pFnLogin->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UbiservicesManager.Init
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class URDVManager*             RDVManager                     ( CPF_Parm )

void UUbiservicesManager::Init ( class URDVManager* RDVManager )
{
	static UFunction* pFnInit = NULL;

	if ( ! pFnInit )
		pFnInit = (UFunction*) UObject::GObjObjects()->Data[ 47164 ];

	UUbiservicesManager_execInit_Parms Init_Parms;
	Init_Parms.RDVManager = RDVManager;

	pFnInit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInit, &Init_Parms, NULL );

	pFnInit->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UPlayEventManager.Update
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UUPlayEventManager::Update ( )
{
	static UFunction* pFnUpdate = NULL;

	if ( ! pFnUpdate )
		pFnUpdate = (UFunction*) UObject::GObjObjects()->Data[ 47191 ];

	UUPlayEventManager_execUpdate_Parms Update_Parms;

	pFnUpdate->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnUpdate, &Update_Parms, NULL );

	pFnUpdate->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UPlayEventManager.Init
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// class UOnlineGameInterfaceUPlay* OnlineGameInterface            ( CPF_Parm )
// class URDVManager*             RDVManager                     ( CPF_Parm )
// class UUbiservicesManager*     ubiManager                     ( CPF_Parm )

void UUPlayEventManager::Init ( class UOnlineGameInterfaceUPlay* OnlineGameInterface, class URDVManager* RDVManager, class UUbiservicesManager* ubiManager )
{
	static UFunction* pFnInit = NULL;

	if ( ! pFnInit )
		pFnInit = (UFunction*) UObject::GObjObjects()->Data[ 47187 ];

	UUPlayEventManager_execInit_Parms Init_Parms;
	Init_Parms.OnlineGameInterface = OnlineGameInterface;
	Init_Parms.RDVManager = RDVManager;
	Init_Parms.ubiManager = ubiManager;

	pFnInit->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInit, &Init_Parms, NULL );

	pFnInit->FunctionFlags |= 0x400;
};

// Function OnlineSubsystemUPlay.UPlayEventManager.GetForceQuitMessageDisplayed
// [0x00020002] 
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UUPlayEventManager::GetForceQuitMessageDisplayed ( )
{
	static UFunction* pFnGetForceQuitMessageDisplayed = NULL;

	if ( ! pFnGetForceQuitMessageDisplayed )
		pFnGetForceQuitMessageDisplayed = (UFunction*) UObject::GObjObjects()->Data[ 47100 ];

	UUPlayEventManager_execGetForceQuitMessageDisplayed_Parms GetForceQuitMessageDisplayed_Parms;

	this->ProcessEvent ( pFnGetForceQuitMessageDisplayed, &GetForceQuitMessageDisplayed_Parms, NULL );

	return GetForceQuitMessageDisplayed_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.UPlayEventManager.GetCurrentUPlayMessage
// [0x00020002] 
// Parameters infos:
// unsigned char                  ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

unsigned char UUPlayEventManager::GetCurrentUPlayMessage ( )
{
	static UFunction* pFnGetCurrentUPlayMessage = NULL;

	if ( ! pFnGetCurrentUPlayMessage )
		pFnGetCurrentUPlayMessage = (UFunction*) UObject::GObjObjects()->Data[ 47102 ];

	UUPlayEventManager_execGetCurrentUPlayMessage_Parms GetCurrentUPlayMessage_Parms;

	this->ProcessEvent ( pFnGetCurrentUPlayMessage, &GetCurrentUPlayMessage_Parms, NULL );

	return GetCurrentUPlayMessage_Parms.ReturnValue;
};

// Function OnlineSubsystemUPlay.WorkshopControllerInterfaceUPlay.OnWorkshopItemInstalled
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// struct FWorkshopInstalledItemDef def                            ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UWorkshopControllerInterfaceUPlay::OnWorkshopItemInstalled ( struct FWorkshopInstalledItemDef* def )
{
	static UFunction* pFnOnWorkshopItemInstalled = NULL;

	if ( ! pFnOnWorkshopItemInstalled )
		pFnOnWorkshopItemInstalled = (UFunction*) UObject::GObjObjects()->Data[ 47192 ];

	UWorkshopControllerInterfaceUPlay_execOnWorkshopItemInstalled_Parms OnWorkshopItemInstalled_Parms;

	pFnOnWorkshopItemInstalled->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnOnWorkshopItemInstalled, &OnWorkshopItemInstalled_Parms, NULL );

	pFnOnWorkshopItemInstalled->FunctionFlags |= 0x400;

	if ( def )
		memcpy ( def, &OnWorkshopItemInstalled_Parms.def, 0x18 );
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif