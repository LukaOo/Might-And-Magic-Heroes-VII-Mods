#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: MMH7Engine_functions.h
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

// Function MMH7Engine.BinDiffPkgCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Params                         ( CPF_Parm | CPF_NeedCtorLink )

int UBinDiffPkgCommandlet::eventMain ( struct FString Params )
{
	static UFunction* pFnMain = NULL;

	if ( ! pFnMain )
		pFnMain = (UFunction*) UObject::GObjObjects()->Data[ 47231 ];

	UBinDiffPkgCommandlet_eventMain_Parms Main_Parms;
	memcpy ( &Main_Parms.Params, &Params, 0x10 );

	pFnMain->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnMain, &Main_Parms, NULL );

	pFnMain->FunctionFlags |= 0x400;

	return Main_Parms.ReturnValue;
};

// Function MMH7Engine.DynamicMaterialEffectVolume.OnToggle
// [0x00020102] 
// Parameters infos:
// class USeqAct_Toggle*          Action                         ( CPF_Parm )

void ADynamicMaterialEffectVolume::OnToggle ( class USeqAct_Toggle* Action )
{
	static UFunction* pFnOnToggle = NULL;

	if ( ! pFnOnToggle )
		pFnOnToggle = (UFunction*) UObject::GObjObjects()->Data[ 47244 ];

	ADynamicMaterialEffectVolume_execOnToggle_Parms OnToggle_Parms;
	OnToggle_Parms.Action = Action;

	this->ProcessEvent ( pFnOnToggle, &OnToggle_Parms, NULL );
};

// Function MMH7Engine.H7ContentScanner.OnWorkshopItemInstalled
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// struct FWorkshopInstalledItemDef def                            ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UH7ContentScanner::OnWorkshopItemInstalled ( struct FWorkshopInstalledItemDef* def )
{
	static UFunction* pFnOnWorkshopItemInstalled = NULL;

	if ( ! pFnOnWorkshopItemInstalled )
		pFnOnWorkshopItemInstalled = (UFunction*) UObject::GObjObjects()->Data[ 47380 ];

	UH7ContentScanner_execOnWorkshopItemInstalled_Parms OnWorkshopItemInstalled_Parms;

	pFnOnWorkshopItemInstalled->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnOnWorkshopItemInstalled, &OnWorkshopItemInstalled_Parms, NULL );

	pFnOnWorkshopItemInstalled->FunctionFlags |= 0x400;

	if ( def )
		memcpy ( def, &OnWorkshopItemInstalled_Parms.def, 0x18 );
};

// Function MMH7Engine.H7ContentScanner.Stop
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ContentScanner::Stop ( )
{
	static UFunction* pFnStop = NULL;

	if ( ! pFnStop )
		pFnStop = (UFunction*) UObject::GObjObjects()->Data[ 47379 ];

	UH7ContentScanner_execStop_Parms Stop_Parms;

	pFnStop->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStop, &Stop_Parms, NULL );

	pFnStop->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ContentScanner.ComputeTick
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ContentScanner::ComputeTick ( )
{
	static UFunction* pFnComputeTick = NULL;

	if ( ! pFnComputeTick )
		pFnComputeTick = (UFunction*) UObject::GObjObjects()->Data[ 47378 ];

	UH7ContentScanner_execComputeTick_Parms ComputeTick_Parms;

	pFnComputeTick->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnComputeTick, &ComputeTick_Parms, NULL );

	pFnComputeTick->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ContentScanner.TriggerListing
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// unsigned long                  bListingAdventure              ( CPF_Parm )
// unsigned long                  bListingCombat                 ( CPF_Parm )
// unsigned long                  bListingCampaign               ( CPF_Parm )

void UH7ContentScanner::TriggerListing ( unsigned long bListingAdventure, unsigned long bListingCombat, unsigned long bListingCampaign )
{
	static UFunction* pFnTriggerListing = NULL;

	if ( ! pFnTriggerListing )
		pFnTriggerListing = (UFunction*) UObject::GObjObjects()->Data[ 47374 ];

	UH7ContentScanner_execTriggerListing_Parms TriggerListing_Parms;
	TriggerListing_Parms.bListingAdventure = bListingAdventure;
	TriggerListing_Parms.bListingCombat = bListingCombat;
	TriggerListing_Parms.bListingCampaign = bListingCampaign;

	pFnTriggerListing->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnTriggerListing, &TriggerListing_Parms, NULL );

	pFnTriggerListing->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ContentScanner.Initialize
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ContentScanner::Initialize ( )
{
	static UFunction* pFnInitialize = NULL;

	if ( ! pFnInitialize )
		pFnInitialize = (UFunction*) UObject::GObjObjects()->Data[ 47373 ];

	UH7ContentScanner_execInitialize_Parms Initialize_Parms;

	pFnInitialize->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnInitialize, &Initialize_Parms, NULL );

	pFnInitialize->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ContentScannerListener.OnScanned_Campaign
// [0x00420800] ( FUNC_Event )
// Parameters infos:
// struct FH7ContentScannerCampaignData CampaignData                   ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UH7ContentScannerListener::eventOnScanned_Campaign ( struct FH7ContentScannerCampaignData* CampaignData )
{
	static UFunction* pFnOnScanned_Campaign = NULL;

	if ( ! pFnOnScanned_Campaign )
		pFnOnScanned_Campaign = (UFunction*) UObject::GObjObjects()->Data[ 47404 ];

	UH7ContentScannerListener_eventOnScanned_Campaign_Parms OnScanned_Campaign_Parms;

	this->ProcessEvent ( pFnOnScanned_Campaign, &OnScanned_Campaign_Parms, NULL );

	if ( CampaignData )
		memcpy ( CampaignData, &OnScanned_Campaign_Parms.CampaignData, 0xD4 );
};

// Function MMH7Engine.H7ContentScannerListener.OnScanned_CombatMap
// [0x00420800] ( FUNC_Event )
// Parameters infos:
// struct FH7ContentScannerCombatMapData CombatData                     ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UH7ContentScannerListener::eventOnScanned_CombatMap ( struct FH7ContentScannerCombatMapData* CombatData )
{
	static UFunction* pFnOnScanned_CombatMap = NULL;

	if ( ! pFnOnScanned_CombatMap )
		pFnOnScanned_CombatMap = (UFunction*) UObject::GObjObjects()->Data[ 47402 ];

	UH7ContentScannerListener_eventOnScanned_CombatMap_Parms OnScanned_CombatMap_Parms;

	this->ProcessEvent ( pFnOnScanned_CombatMap, &OnScanned_CombatMap_Parms, NULL );

	if ( CombatData )
		memcpy ( CombatData, &OnScanned_CombatMap_Parms.CombatData, 0x90 );
};

// Function MMH7Engine.H7ContentScannerListener.OnScanned_AdventureMap
// [0x00420800] ( FUNC_Event )
// Parameters infos:
// struct FH7ContentScannerAdventureMapData AdvData                        ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

void UH7ContentScannerListener::eventOnScanned_AdventureMap ( struct FH7ContentScannerAdventureMapData* AdvData )
{
	static UFunction* pFnOnScanned_AdventureMap = NULL;

	if ( ! pFnOnScanned_AdventureMap )
		pFnOnScanned_AdventureMap = (UFunction*) UObject::GObjObjects()->Data[ 47400 ];

	UH7ContentScannerListener_eventOnScanned_AdventureMap_Parms OnScanned_AdventureMap_Parms;

	this->ProcessEvent ( pFnOnScanned_AdventureMap, &OnScanned_AdventureMap_Parms, NULL );

	if ( AdvData )
		memcpy ( AdvData, &OnScanned_AdventureMap_Parms.AdvData, 0x330 );
};

// Function MMH7Engine.H7EngineUtility.KeyMapNameToVirtualKey
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FName                   keymapname                     ( CPF_Parm )
// int                            virtualkey                     ( CPF_Parm | CPF_OutParm )

bool UH7EngineUtility::KeyMapNameToVirtualKey ( struct FName keymapname, int* virtualkey )
{
	static UFunction* pFnKeyMapNameToVirtualKey = NULL;

	if ( ! pFnKeyMapNameToVirtualKey )
		pFnKeyMapNameToVirtualKey = (UFunction*) UObject::GObjObjects()->Data[ 47450 ];

	UH7EngineUtility_execKeyMapNameToVirtualKey_Parms KeyMapNameToVirtualKey_Parms;
	memcpy ( &KeyMapNameToVirtualKey_Parms.keymapname, &keymapname, 0x8 );

	pFnKeyMapNameToVirtualKey->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnKeyMapNameToVirtualKey, &KeyMapNameToVirtualKey_Parms, NULL );

	pFnKeyMapNameToVirtualKey->FunctionFlags |= 0x400;

	if ( virtualkey )
		*virtualkey = KeyMapNameToVirtualKey_Parms.virtualkey;

	return KeyMapNameToVirtualKey_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.VirtualKeyToChar
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// int                            keycode                        ( CPF_Parm )
// struct FString                 resultingString                ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UH7EngineUtility::VirtualKeyToChar ( int keycode, struct FString* resultingString )
{
	static UFunction* pFnVirtualKeyToChar = NULL;

	if ( ! pFnVirtualKeyToChar )
		pFnVirtualKeyToChar = (UFunction*) UObject::GObjObjects()->Data[ 47446 ];

	UH7EngineUtility_execVirtualKeyToChar_Parms VirtualKeyToChar_Parms;
	VirtualKeyToChar_Parms.keycode = keycode;

	pFnVirtualKeyToChar->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnVirtualKeyToChar, &VirtualKeyToChar_Parms, NULL );

	pFnVirtualKeyToChar->FunctionFlags |= 0x400;

	if ( resultingString )
		memcpy ( resultingString, &VirtualKeyToChar_Parms.resultingString, 0x10 );

	return VirtualKeyToChar_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.ForceReattachAllComponents
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// TArray< class AActor* >        actorsToReattach               ( CPF_Parm | CPF_NeedCtorLink )

void UH7EngineUtility::ForceReattachAllComponents ( TArray< class AActor* > actorsToReattach )
{
	static UFunction* pFnForceReattachAllComponents = NULL;

	if ( ! pFnForceReattachAllComponents )
		pFnForceReattachAllComponents = (UFunction*) UObject::GObjObjects()->Data[ 47443 ];

	UH7EngineUtility_execForceReattachAllComponents_Parms ForceReattachAllComponents_Parms;
	memcpy ( &ForceReattachAllComponents_Parms.actorsToReattach, &actorsToReattach, 0x10 );

	pFnForceReattachAllComponents->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnForceReattachAllComponents, &ForceReattachAllComponents_Parms, NULL );

	pFnForceReattachAllComponents->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7EngineUtility.UpdateTextureFromFile
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Path                           ( CPF_Parm | CPF_NeedCtorLink )
// class UTexture2D*              Tex                            ( CPF_Parm )

bool UH7EngineUtility::UpdateTextureFromFile ( struct FString Path, class UTexture2D* Tex )
{
	static UFunction* pFnUpdateTextureFromFile = NULL;

	if ( ! pFnUpdateTextureFromFile )
		pFnUpdateTextureFromFile = (UFunction*) UObject::GObjObjects()->Data[ 47439 ];

	UH7EngineUtility_execUpdateTextureFromFile_Parms UpdateTextureFromFile_Parms;
	memcpy ( &UpdateTextureFromFile_Parms.Path, &Path, 0x10 );
	UpdateTextureFromFile_Parms.Tex = Tex;

	pFnUpdateTextureFromFile->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnUpdateTextureFromFile, &UpdateTextureFromFile_Parms, NULL );

	pFnUpdateTextureFromFile->FunctionFlags |= 0x400;

	return UpdateTextureFromFile_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.LoadTextureFromFile
// [0x00026400] ( FUNC_Native )
// Parameters infos:
// class UTexture2D*              ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Path                           ( CPF_Parm | CPF_NeedCtorLink )
// struct FString                 TextureName                    ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )

class UTexture2D* UH7EngineUtility::LoadTextureFromFile ( struct FString Path, struct FString TextureName )
{
	static UFunction* pFnLoadTextureFromFile = NULL;

	if ( ! pFnLoadTextureFromFile )
		pFnLoadTextureFromFile = (UFunction*) UObject::GObjObjects()->Data[ 47435 ];

	UH7EngineUtility_execLoadTextureFromFile_Parms LoadTextureFromFile_Parms;
	memcpy ( &LoadTextureFromFile_Parms.Path, &Path, 0x10 );
	memcpy ( &LoadTextureFromFile_Parms.TextureName, &TextureName, 0x10 );

	pFnLoadTextureFromFile->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnLoadTextureFromFile, &LoadTextureFromFile_Parms, NULL );

	pFnLoadTextureFromFile->FunctionFlags |= 0x400;

	return LoadTextureFromFile_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.SaveTextureToFile
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Path                           ( CPF_Parm | CPF_NeedCtorLink )
// class UTexture2D*              Tex                            ( CPF_Parm )

bool UH7EngineUtility::SaveTextureToFile ( struct FString Path, class UTexture2D* Tex )
{
	static UFunction* pFnSaveTextureToFile = NULL;

	if ( ! pFnSaveTextureToFile )
		pFnSaveTextureToFile = (UFunction*) UObject::GObjObjects()->Data[ 47431 ];

	UH7EngineUtility_execSaveTextureToFile_Parms SaveTextureToFile_Parms;
	memcpy ( &SaveTextureToFile_Parms.Path, &Path, 0x10 );
	SaveTextureToFile_Parms.Tex = Tex;

	pFnSaveTextureToFile->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSaveTextureToFile, &SaveTextureToFile_Parms, NULL );

	pFnSaveTextureToFile->FunctionFlags |= 0x400;

	return SaveTextureToFile_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.SaveRenderTargetToFile
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Path                           ( CPF_Parm | CPF_NeedCtorLink )
// class UTextureRenderTarget2D*  RenderTarget                   ( CPF_Parm )

bool UH7EngineUtility::SaveRenderTargetToFile ( struct FString Path, class UTextureRenderTarget2D* RenderTarget )
{
	static UFunction* pFnSaveRenderTargetToFile = NULL;

	if ( ! pFnSaveRenderTargetToFile )
		pFnSaveRenderTargetToFile = (UFunction*) UObject::GObjObjects()->Data[ 47427 ];

	UH7EngineUtility_execSaveRenderTargetToFile_Parms SaveRenderTargetToFile_Parms;
	memcpy ( &SaveRenderTargetToFile_Parms.Path, &Path, 0x10 );
	SaveRenderTargetToFile_Parms.RenderTarget = RenderTarget;

	pFnSaveRenderTargetToFile->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSaveRenderTargetToFile, &SaveRenderTargetToFile_Parms, NULL );

	pFnSaveRenderTargetToFile->FunctionFlags |= 0x400;

	return SaveRenderTargetToFile_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.QuitGame
// [0x00022400] ( FUNC_Native )
// Parameters infos:

void UH7EngineUtility::QuitGame ( )
{
	static UFunction* pFnQuitGame = NULL;

	if ( ! pFnQuitGame )
		pFnQuitGame = (UFunction*) UObject::GObjObjects()->Data[ 47426 ];

	UH7EngineUtility_execQuitGame_Parms QuitGame_Parms;

	pFnQuitGame->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnQuitGame, &QuitGame_Parms, NULL );

	pFnQuitGame->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7EngineUtility.SetVoiceVolumeSetting
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// float                          Volume                         ( CPF_Parm )

void UH7EngineUtility::SetVoiceVolumeSetting ( float Volume )
{
	static UFunction* pFnSetVoiceVolumeSetting = NULL;

	if ( ! pFnSetVoiceVolumeSetting )
		pFnSetVoiceVolumeSetting = (UFunction*) UObject::GObjObjects()->Data[ 47424 ];

	UH7EngineUtility_execSetVoiceVolumeSetting_Parms SetVoiceVolumeSetting_Parms;
	SetVoiceVolumeSetting_Parms.Volume = Volume;

	pFnSetVoiceVolumeSetting->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetVoiceVolumeSetting, &SetVoiceVolumeSetting_Parms, NULL );

	pFnSetVoiceVolumeSetting->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7EngineUtility.SetMusicVolumeSetting
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// float                          Volume                         ( CPF_Parm )

void UH7EngineUtility::SetMusicVolumeSetting ( float Volume )
{
	static UFunction* pFnSetMusicVolumeSetting = NULL;

	if ( ! pFnSetMusicVolumeSetting )
		pFnSetMusicVolumeSetting = (UFunction*) UObject::GObjObjects()->Data[ 47422 ];

	UH7EngineUtility_execSetMusicVolumeSetting_Parms SetMusicVolumeSetting_Parms;
	SetMusicVolumeSetting_Parms.Volume = Volume;

	pFnSetMusicVolumeSetting->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetMusicVolumeSetting, &SetMusicVolumeSetting_Parms, NULL );

	pFnSetMusicVolumeSetting->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7EngineUtility.GetGameSubtitleEnabled
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UH7EngineUtility::GetGameSubtitleEnabled ( )
{
	static UFunction* pFnGetGameSubtitleEnabled = NULL;

	if ( ! pFnGetGameSubtitleEnabled )
		pFnGetGameSubtitleEnabled = (UFunction*) UObject::GObjObjects()->Data[ 47420 ];

	UH7EngineUtility_execGetGameSubtitleEnabled_Parms GetGameSubtitleEnabled_Parms;

	pFnGetGameSubtitleEnabled->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetGameSubtitleEnabled, &GetGameSubtitleEnabled_Parms, NULL );

	pFnGetGameSubtitleEnabled->FunctionFlags |= 0x400;

	return GetGameSubtitleEnabled_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.SetGameSubtitleEnabled
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// unsigned long                  val                            ( CPF_Parm )

void UH7EngineUtility::SetGameSubtitleEnabled ( unsigned long val )
{
	static UFunction* pFnSetGameSubtitleEnabled = NULL;

	if ( ! pFnSetGameSubtitleEnabled )
		pFnSetGameSubtitleEnabled = (UFunction*) UObject::GObjObjects()->Data[ 47418 ];

	UH7EngineUtility_execSetGameSubtitleEnabled_Parms SetGameSubtitleEnabled_Parms;
	SetGameSubtitleEnabled_Parms.val = val;

	pFnSetGameSubtitleEnabled->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetGameSubtitleEnabled, &SetGameSubtitleEnabled_Parms, NULL );

	pFnSetGameSubtitleEnabled->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7EngineUtility.GetGameAudioLanguageExt
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )

struct FString UH7EngineUtility::GetGameAudioLanguageExt ( )
{
	static UFunction* pFnGetGameAudioLanguageExt = NULL;

	if ( ! pFnGetGameAudioLanguageExt )
		pFnGetGameAudioLanguageExt = (UFunction*) UObject::GObjObjects()->Data[ 47416 ];

	UH7EngineUtility_execGetGameAudioLanguageExt_Parms GetGameAudioLanguageExt_Parms;

	pFnGetGameAudioLanguageExt->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetGameAudioLanguageExt, &GetGameAudioLanguageExt_Parms, NULL );

	pFnGetGameAudioLanguageExt->FunctionFlags |= 0x400;

	return GetGameAudioLanguageExt_Parms.ReturnValue;
};

// Function MMH7Engine.H7EngineUtility.SetGameAudioLanguageExt
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// struct FString                 ext                            ( CPF_Parm | CPF_NeedCtorLink )

void UH7EngineUtility::SetGameAudioLanguageExt ( struct FString ext )
{
	static UFunction* pFnSetGameAudioLanguageExt = NULL;

	if ( ! pFnSetGameAudioLanguageExt )
		pFnSetGameAudioLanguageExt = (UFunction*) UObject::GObjObjects()->Data[ 47414 ];

	UH7EngineUtility_execSetGameAudioLanguageExt_Parms SetGameAudioLanguageExt_Parms;
	memcpy ( &SetGameAudioLanguageExt_Parms.ext, &ext, 0x10 );

	pFnSetGameAudioLanguageExt->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetGameAudioLanguageExt, &SetGameAudioLanguageExt_Parms, NULL );

	pFnSetGameAudioLanguageExt->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7EngineUtility.SetGameLanguageExt
// [0x00022400] ( FUNC_Native )
// Parameters infos:
// struct FString                 ext                            ( CPF_Parm | CPF_NeedCtorLink )

void UH7EngineUtility::SetGameLanguageExt ( struct FString ext )
{
	static UFunction* pFnSetGameLanguageExt = NULL;

	if ( ! pFnSetGameLanguageExt )
		pFnSetGameLanguageExt = (UFunction*) UObject::GObjObjects()->Data[ 47412 ];

	UH7EngineUtility_execSetGameLanguageExt_Parms SetGameLanguageExt_Parms;
	memcpy ( &SetGameLanguageExt_Parms.ext, &ext, 0x10 );

	pFnSetGameLanguageExt->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSetGameLanguageExt, &SetGameLanguageExt_Parms, NULL );

	pFnSetGameLanguageExt->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ErosionMapCapture.Destroyed
// [0x00020802] ( FUNC_Event )
// Parameters infos:

void AH7ErosionMapCapture::eventDestroyed ( )
{
	static UFunction* pFnDestroyed = NULL;

	if ( ! pFnDestroyed )
		pFnDestroyed = (UFunction*) UObject::GObjObjects()->Data[ 47462 ];

	AH7ErosionMapCapture_eventDestroyed_Parms Destroyed_Parms;

	this->ProcessEvent ( pFnDestroyed, &Destroyed_Parms, NULL );
};

// Function MMH7Engine.H7ErosionMapCapture.Tick
// [0x00020802] ( FUNC_Event )
// Parameters infos:
// float                          DeltaTime                      ( CPF_Parm )

void AH7ErosionMapCapture::eventTick ( float DeltaTime )
{
	static UFunction* pFnTick = NULL;

	if ( ! pFnTick )
		pFnTick = (UFunction*) UObject::GObjObjects()->Data[ 47460 ];

	AH7ErosionMapCapture_eventTick_Parms Tick_Parms;
	Tick_Parms.DeltaTime = DeltaTime;

	this->ProcessEvent ( pFnTick, &Tick_Parms, NULL );
};

// Function MMH7Engine.H7GraphicsController.GetCurrentAdapterIndex
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// int                            adapterindex                   ( CPF_Parm | CPF_OutParm )

bool UH7GraphicsController::GetCurrentAdapterIndex ( int* adapterindex )
{
	static UFunction* pFnGetCurrentAdapterIndex = NULL;

	if ( ! pFnGetCurrentAdapterIndex )
		pFnGetCurrentAdapterIndex = (UFunction*) UObject::GObjObjects()->Data[ 47486 ];

	UH7GraphicsController_execGetCurrentAdapterIndex_Parms GetCurrentAdapterIndex_Parms;

	pFnGetCurrentAdapterIndex->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetCurrentAdapterIndex, &GetCurrentAdapterIndex_Parms, NULL );

	pFnGetCurrentAdapterIndex->FunctionFlags |= 0x400;

	if ( adapterindex )
		*adapterindex = GetCurrentAdapterIndex_Parms.adapterindex;

	return GetCurrentAdapterIndex_Parms.ReturnValue;
};

// Function MMH7Engine.H7GraphicsController.GetAdapterCount
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// int                            adaptercount                   ( CPF_Parm | CPF_OutParm )

bool UH7GraphicsController::GetAdapterCount ( int* adaptercount )
{
	static UFunction* pFnGetAdapterCount = NULL;

	if ( ! pFnGetAdapterCount )
		pFnGetAdapterCount = (UFunction*) UObject::GObjObjects()->Data[ 47483 ];

	UH7GraphicsController_execGetAdapterCount_Parms GetAdapterCount_Parms;

	pFnGetAdapterCount->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetAdapterCount, &GetAdapterCount_Parms, NULL );

	pFnGetAdapterCount->FunctionFlags |= 0x400;

	if ( adaptercount )
		*adaptercount = GetAdapterCount_Parms.adaptercount;

	return GetAdapterCount_Parms.ReturnValue;
};

// Function MMH7Engine.H7GraphicsController.GetAdapterName
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 adaptername                    ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UH7GraphicsController::GetAdapterName ( struct FString* adaptername )
{
	static UFunction* pFnGetAdapterName = NULL;

	if ( ! pFnGetAdapterName )
		pFnGetAdapterName = (UFunction*) UObject::GObjObjects()->Data[ 47480 ];

	UH7GraphicsController_execGetAdapterName_Parms GetAdapterName_Parms;

	pFnGetAdapterName->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetAdapterName, &GetAdapterName_Parms, NULL );

	pFnGetAdapterName->FunctionFlags |= 0x400;

	if ( adaptername )
		memcpy ( adaptername, &GetAdapterName_Parms.adaptername, 0x10 );

	return GetAdapterName_Parms.ReturnValue;
};

// Function MMH7Engine.H7GraphicsController.GetAvailableBorderlessResolutions
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// TArray< struct FFullscreenResolution > AvailableResolutions           ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UH7GraphicsController::GetAvailableBorderlessResolutions ( TArray< struct FFullscreenResolution >* AvailableResolutions )
{
	static UFunction* pFnGetAvailableBorderlessResolutions = NULL;

	if ( ! pFnGetAvailableBorderlessResolutions )
		pFnGetAvailableBorderlessResolutions = (UFunction*) UObject::GObjObjects()->Data[ 47476 ];

	UH7GraphicsController_execGetAvailableBorderlessResolutions_Parms GetAvailableBorderlessResolutions_Parms;

	pFnGetAvailableBorderlessResolutions->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetAvailableBorderlessResolutions, &GetAvailableBorderlessResolutions_Parms, NULL );

	pFnGetAvailableBorderlessResolutions->FunctionFlags |= 0x400;

	if ( AvailableResolutions )
		memcpy ( AvailableResolutions, &GetAvailableBorderlessResolutions_Parms.AvailableResolutions, 0x10 );

	return GetAvailableBorderlessResolutions_Parms.ReturnValue;
};

// Function MMH7Engine.H7GraphicsController.GetAvailableWindowedResolutions
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// TArray< struct FFullscreenResolution > AvailableResolutions           ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UH7GraphicsController::GetAvailableWindowedResolutions ( TArray< struct FFullscreenResolution >* AvailableResolutions )
{
	static UFunction* pFnGetAvailableWindowedResolutions = NULL;

	if ( ! pFnGetAvailableWindowedResolutions )
		pFnGetAvailableWindowedResolutions = (UFunction*) UObject::GObjObjects()->Data[ 47472 ];

	UH7GraphicsController_execGetAvailableWindowedResolutions_Parms GetAvailableWindowedResolutions_Parms;

	pFnGetAvailableWindowedResolutions->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetAvailableWindowedResolutions, &GetAvailableWindowedResolutions_Parms, NULL );

	pFnGetAvailableWindowedResolutions->FunctionFlags |= 0x400;

	if ( AvailableResolutions )
		memcpy ( AvailableResolutions, &GetAvailableWindowedResolutions_Parms.AvailableResolutions, 0x10 );

	return GetAvailableWindowedResolutions_Parms.ReturnValue;
};

// Function MMH7Engine.H7GraphicsController.GetAvailableFullscreenResolutions
// [0x00422400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// TArray< struct FFullscreenResolution > AvailableResolutions           ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UH7GraphicsController::GetAvailableFullscreenResolutions ( TArray< struct FFullscreenResolution >* AvailableResolutions )
{
	static UFunction* pFnGetAvailableFullscreenResolutions = NULL;

	if ( ! pFnGetAvailableFullscreenResolutions )
		pFnGetAvailableFullscreenResolutions = (UFunction*) UObject::GObjObjects()->Data[ 47468 ];

	UH7GraphicsController_execGetAvailableFullscreenResolutions_Parms GetAvailableFullscreenResolutions_Parms;

	pFnGetAvailableFullscreenResolutions->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetAvailableFullscreenResolutions, &GetAvailableFullscreenResolutions_Parms, NULL );

	pFnGetAvailableFullscreenResolutions->FunctionFlags |= 0x400;

	if ( AvailableResolutions )
		memcpy ( AvailableResolutions, &GetAvailableFullscreenResolutions_Parms.AvailableResolutions, 0x10 );

	return GetAvailableFullscreenResolutions_Parms.ReturnValue;
};

// Function MMH7Engine.H7LandscapeEditorTools.Sculpt_CarveLandscape
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7LandscapeEditorTools::Sculpt_CarveLandscape ( )
{
	static UFunction* pFnSculpt_CarveLandscape = NULL;

	if ( ! pFnSculpt_CarveLandscape )
		pFnSculpt_CarveLandscape = (UFunction*) UObject::GObjObjects()->Data[ 47496 ];

	UH7LandscapeEditorTools_execSculpt_CarveLandscape_Parms Sculpt_CarveLandscape_Parms;

	pFnSculpt_CarveLandscape->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSculpt_CarveLandscape, &Sculpt_CarveLandscape_Parms, NULL );

	pFnSculpt_CarveLandscape->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7LandscapeEditorTools.Sculpt_RaiseLandscape
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7LandscapeEditorTools::Sculpt_RaiseLandscape ( )
{
	static UFunction* pFnSculpt_RaiseLandscape = NULL;

	if ( ! pFnSculpt_RaiseLandscape )
		pFnSculpt_RaiseLandscape = (UFunction*) UObject::GObjObjects()->Data[ 47495 ];

	UH7LandscapeEditorTools_execSculpt_RaiseLandscape_Parms Sculpt_RaiseLandscape_Parms;

	pFnSculpt_RaiseLandscape->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSculpt_RaiseLandscape, &Sculpt_RaiseLandscape_Parms, NULL );

	pFnSculpt_RaiseLandscape->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7LandscapeEditorTools.Build
// [0x00020802] ( FUNC_Event )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UH7LandscapeEditorTools::eventBuild ( )
{
	static UFunction* pFnBuild = NULL;

	if ( ! pFnBuild )
		pFnBuild = (UFunction*) UObject::GObjObjects()->Data[ 47491 ];

	UH7LandscapeEditorTools_eventBuild_Parms Build_Parms;

	this->ProcessEvent ( pFnBuild, &Build_Parms, NULL );

	return Build_Parms.ReturnValue;
};

// Function MMH7Engine.H7ListingCampaign.Stop
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ListingCampaign::Stop ( )
{
	static UFunction* pFnStop = NULL;

	if ( ! pFnStop )
		pFnStop = (UFunction*) UObject::GObjObjects()->Data[ 47567 ];

	UH7ListingCampaign_execStop_Parms Stop_Parms;

	pFnStop->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStop, &Stop_Parms, NULL );

	pFnStop->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ListingCampaign.Poll
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// TArray< struct FH7ListingCampaignData > outData                        ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
// int                            isPollingOver                  ( CPF_Parm | CPF_OutParm )

void UH7ListingCampaign::Poll ( TArray< struct FH7ListingCampaignData >* outData, int* isPollingOver )
{
	static UFunction* pFnPoll = NULL;

	if ( ! pFnPoll )
		pFnPoll = (UFunction*) UObject::GObjObjects()->Data[ 47563 ];

	UH7ListingCampaign_execPoll_Parms Poll_Parms;

	pFnPoll->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPoll, &Poll_Parms, NULL );

	pFnPoll->FunctionFlags |= 0x400;

	if ( outData )
		memcpy ( outData, &Poll_Parms.outData, 0x10 );

	if ( isPollingOver )
		*isPollingOver = Poll_Parms.isPollingOver;
};

// Function MMH7Engine.H7ListingCampaign.Start
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ListingCampaign::Start ( )
{
	static UFunction* pFnStart = NULL;

	if ( ! pFnStart )
		pFnStart = (UFunction*) UObject::GObjObjects()->Data[ 47562 ];

	UH7ListingCampaign_execStart_Parms Start_Parms;

	pFnStart->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStart, &Start_Parms, NULL );

	pFnStart->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ListingCombatMap.ScanCombatMapHeader
// [0x00426400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 MapFilename                    ( CPF_Parm | CPF_NeedCtorLink )
// unsigned long                  gatherThumbnailData            ( CPF_OptionalParm | CPF_Parm )
// struct FH7CombatMapData        outMapDataStruct               ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UH7ListingCombatMap::ScanCombatMapHeader ( struct FString MapFilename, unsigned long gatherThumbnailData, struct FH7CombatMapData* outMapDataStruct )
{
	static UFunction* pFnScanCombatMapHeader = NULL;

	if ( ! pFnScanCombatMapHeader )
		pFnScanCombatMapHeader = (UFunction*) UObject::GObjObjects()->Data[ 47585 ];

	UH7ListingCombatMap_execScanCombatMapHeader_Parms ScanCombatMapHeader_Parms;
	memcpy ( &ScanCombatMapHeader_Parms.MapFilename, &MapFilename, 0x10 );
	ScanCombatMapHeader_Parms.gatherThumbnailData = gatherThumbnailData;

	pFnScanCombatMapHeader->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnScanCombatMapHeader, &ScanCombatMapHeader_Parms, NULL );

	pFnScanCombatMapHeader->FunctionFlags |= 0x400;

	if ( outMapDataStruct )
		memcpy ( outMapDataStruct, &ScanCombatMapHeader_Parms.outMapDataStruct, 0x6C );

	return ScanCombatMapHeader_Parms.ReturnValue;
};

// Function MMH7Engine.H7ListingCombatMap.GetMapName
// [0x00022002] 
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
// struct FString                 filepath                       ( CPF_Parm | CPF_NeedCtorLink )

struct FString UH7ListingCombatMap::GetMapName ( struct FString filepath )
{
	static UFunction* pFnGetMapName = NULL;

	if ( ! pFnGetMapName )
		pFnGetMapName = (UFunction*) UObject::GObjObjects()->Data[ 47579 ];

	UH7ListingCombatMap_execGetMapName_Parms GetMapName_Parms;
	memcpy ( &GetMapName_Parms.filepath, &filepath, 0x10 );

	this->ProcessEvent ( pFnGetMapName, &GetMapName_Parms, NULL );

	return GetMapName_Parms.ReturnValue;
};

// Function MMH7Engine.H7ListingCombatMap.Stop
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ListingCombatMap::Stop ( )
{
	static UFunction* pFnStop = NULL;

	if ( ! pFnStop )
		pFnStop = (UFunction*) UObject::GObjObjects()->Data[ 47578 ];

	UH7ListingCombatMap_execStop_Parms Stop_Parms;

	pFnStop->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStop, &Stop_Parms, NULL );

	pFnStop->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ListingCombatMap.Poll
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// TArray< struct FH7ListingCombatMapData > outData                        ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
// int                            isPollingOver                  ( CPF_Parm | CPF_OutParm )

void UH7ListingCombatMap::Poll ( TArray< struct FH7ListingCombatMapData >* outData, int* isPollingOver )
{
	static UFunction* pFnPoll = NULL;

	if ( ! pFnPoll )
		pFnPoll = (UFunction*) UObject::GObjObjects()->Data[ 47574 ];

	UH7ListingCombatMap_execPoll_Parms Poll_Parms;

	pFnPoll->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPoll, &Poll_Parms, NULL );

	pFnPoll->FunctionFlags |= 0x400;

	if ( outData )
		memcpy ( outData, &Poll_Parms.outData, 0x10 );

	if ( isPollingOver )
		*isPollingOver = Poll_Parms.isPollingOver;
};

// Function MMH7Engine.H7ListingCombatMap.Start
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ListingCombatMap::Start ( )
{
	static UFunction* pFnStart = NULL;

	if ( ! pFnStart )
		pFnStart = (UFunction*) UObject::GObjObjects()->Data[ 47573 ];

	UH7ListingCombatMap_execStart_Parms Start_Parms;

	pFnStart->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStart, &Start_Parms, NULL );

	pFnStart->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ListingMap.ScanMapHeader
// [0x00426400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 MapFilename                    ( CPF_Parm | CPF_NeedCtorLink )
// unsigned long                  gatherThumbnailData            ( CPF_OptionalParm | CPF_Parm )
// struct FH7MapData              outMapDataStruct               ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )

bool UH7ListingMap::ScanMapHeader ( struct FString MapFilename, unsigned long gatherThumbnailData, struct FH7MapData* outMapDataStruct )
{
	static UFunction* pFnScanMapHeader = NULL;

	if ( ! pFnScanMapHeader )
		pFnScanMapHeader = (UFunction*) UObject::GObjObjects()->Data[ 47607 ];

	UH7ListingMap_execScanMapHeader_Parms ScanMapHeader_Parms;
	memcpy ( &ScanMapHeader_Parms.MapFilename, &MapFilename, 0x10 );
	ScanMapHeader_Parms.gatherThumbnailData = gatherThumbnailData;

	pFnScanMapHeader->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnScanMapHeader, &ScanMapHeader_Parms, NULL );

	pFnScanMapHeader->FunctionFlags |= 0x400;

	if ( outMapDataStruct )
		memcpy ( outMapDataStruct, &ScanMapHeader_Parms.outMapDataStruct, 0x30C );

	return ScanMapHeader_Parms.ReturnValue;
};

// Function MMH7Engine.H7ListingMap.GetMapName
// [0x00022002] 
// Parameters infos:
// struct FString                 ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
// struct FString                 filepath                       ( CPF_Parm | CPF_NeedCtorLink )

struct FString UH7ListingMap::GetMapName ( struct FString filepath )
{
	static UFunction* pFnGetMapName = NULL;

	if ( ! pFnGetMapName )
		pFnGetMapName = (UFunction*) UObject::GObjObjects()->Data[ 47601 ];

	UH7ListingMap_execGetMapName_Parms GetMapName_Parms;
	memcpy ( &GetMapName_Parms.filepath, &filepath, 0x10 );

	this->ProcessEvent ( pFnGetMapName, &GetMapName_Parms, NULL );

	return GetMapName_Parms.ReturnValue;
};

// Function MMH7Engine.H7ListingMap.Stop
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ListingMap::Stop ( )
{
	static UFunction* pFnStop = NULL;

	if ( ! pFnStop )
		pFnStop = (UFunction*) UObject::GObjObjects()->Data[ 47600 ];

	UH7ListingMap_execStop_Parms Stop_Parms;

	pFnStop->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStop, &Stop_Parms, NULL );

	pFnStop->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ListingMap.Poll
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// TArray< struct FH7ListingMapData > outData                        ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
// int                            isPollingOver                  ( CPF_Parm | CPF_OutParm )

void UH7ListingMap::Poll ( TArray< struct FH7ListingMapData >* outData, int* isPollingOver )
{
	static UFunction* pFnPoll = NULL;

	if ( ! pFnPoll )
		pFnPoll = (UFunction*) UObject::GObjObjects()->Data[ 47596 ];

	UH7ListingMap_execPoll_Parms Poll_Parms;

	pFnPoll->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPoll, &Poll_Parms, NULL );

	pFnPoll->FunctionFlags |= 0x400;

	if ( outData )
		memcpy ( outData, &Poll_Parms.outData, 0x10 );

	if ( isPollingOver )
		*isPollingOver = Poll_Parms.isPollingOver;
};

// Function MMH7Engine.H7ListingMap.Start
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ListingMap::Start ( )
{
	static UFunction* pFnStart = NULL;

	if ( ! pFnStart )
		pFnStart = (UFunction*) UObject::GObjObjects()->Data[ 47595 ];

	UH7ListingMap_execStart_Parms Start_Parms;

	pFnStart->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnStart, &Start_Parms, NULL );

	pFnStart->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ObjectEditorTools.Build
// [0x00020802] ( FUNC_Event )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UH7ObjectEditorTools::eventBuild ( )
{
	static UFunction* pFnBuild = NULL;

	if ( ! pFnBuild )
		pFnBuild = (UFunction*) UObject::GObjObjects()->Data[ 47617 ];

	UH7ObjectEditorTools_eventBuild_Parms Build_Parms;

	this->ProcessEvent ( pFnBuild, &Build_Parms, NULL );

	return Build_Parms.ReturnValue;
};

// Function MMH7Engine.H7ObjectEditorTools.ChangeSelectedObjectsArchetype
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ObjectEditorTools::ChangeSelectedObjectsArchetype ( )
{
	static UFunction* pFnChangeSelectedObjectsArchetype = NULL;

	if ( ! pFnChangeSelectedObjectsArchetype )
		pFnChangeSelectedObjectsArchetype = (UFunction*) UObject::GObjObjects()->Data[ 47616 ];

	UH7ObjectEditorTools_execChangeSelectedObjectsArchetype_Parms ChangeSelectedObjectsArchetype_Parms;

	pFnChangeSelectedObjectsArchetype->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnChangeSelectedObjectsArchetype, &ChangeSelectedObjectsArchetype_Parms, NULL );

	pFnChangeSelectedObjectsArchetype->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7ObjectEditorTools.ChangeObjectArchetype
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7ObjectEditorTools::ChangeObjectArchetype ( )
{
	static UFunction* pFnChangeObjectArchetype = NULL;

	if ( ! pFnChangeObjectArchetype )
		pFnChangeObjectArchetype = (UFunction*) UObject::GObjObjects()->Data[ 47615 ];

	UH7ObjectEditorTools_execChangeObjectArchetype_Parms ChangeObjectArchetype_Parms;

	pFnChangeObjectArchetype->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnChangeObjectArchetype, &ChangeObjectArchetype_Parms, NULL );

	pFnChangeObjectArchetype->FunctionFlags |= 0x400;
};

// Function MMH7Engine.ImportAkEventsCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 args                           ( CPF_Parm | CPF_NeedCtorLink )

int UImportAkEventsCommandlet::eventMain ( struct FString args )
{
	static UFunction* pFnMain = NULL;

	if ( ! pFnMain )
		pFnMain = (UFunction*) UObject::GObjObjects()->Data[ 47650 ];

	UImportAkEventsCommandlet_eventMain_Parms Main_Parms;
	memcpy ( &Main_Parms.args, &args, 0x10 );

	pFnMain->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnMain, &Main_Parms, NULL );

	pFnMain->FunctionFlags |= 0x400;

	return Main_Parms.ReturnValue;
};

// Function MMH7Engine.MemLeakCheckEmptyCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Params                         ( CPF_Parm | CPF_NeedCtorLink )

int UMemLeakCheckEmptyCommandlet::eventMain ( struct FString Params )
{
	static UFunction* pFnMain = NULL;

	if ( ! pFnMain )
		pFnMain = (UFunction*) UObject::GObjObjects()->Data[ 47654 ];

	UMemLeakCheckEmptyCommandlet_eventMain_Parms Main_Parms;
	memcpy ( &Main_Parms.Params, &Params, 0x10 );

	pFnMain->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnMain, &Main_Parms, NULL );

	pFnMain->FunctionFlags |= 0x400;

	return Main_Parms.ReturnValue;
};

// Function MMH7Engine.RegenerateAllSoundbanksCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Params                         ( CPF_Parm | CPF_NeedCtorLink )

int URegenerateAllSoundbanksCommandlet::eventMain ( struct FString Params )
{
	static UFunction* pFnMain = NULL;

	if ( ! pFnMain )
		pFnMain = (UFunction*) UObject::GObjObjects()->Data[ 47657 ];

	URegenerateAllSoundbanksCommandlet_eventMain_Parms Main_Parms;
	memcpy ( &Main_Parms.Params, &Params, 0x10 );

	pFnMain->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnMain, &Main_Parms, NULL );

	pFnMain->FunctionFlags |= 0x400;

	return Main_Parms.ReturnValue;
};

// Function MMH7Engine.TransferDataFromFXStructsToFXObjectsCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
// Parameters infos:
// int                            ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FString                 Params                         ( CPF_Parm | CPF_NeedCtorLink )

int UTransferDataFromFXStructsToFXObjectsCommandlet::eventMain ( struct FString Params )
{
	static UFunction* pFnMain = NULL;

	if ( ! pFnMain )
		pFnMain = (UFunction*) UObject::GObjObjects()->Data[ 47663 ];

	UTransferDataFromFXStructsToFXObjectsCommandlet_eventMain_Parms Main_Parms;
	memcpy ( &Main_Parms.Params, &Params, 0x10 );

	pFnMain->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnMain, &Main_Parms, NULL );

	pFnMain->FunctionFlags |= 0x400;

	return Main_Parms.ReturnValue;
};

// Function MMH7Engine.H7RadiusDirectionalLight.GetLightmassData
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FH7LightmassEnvironmentSphereData Data                           ( CPF_Parm | CPF_OutParm )

bool AH7RadiusDirectionalLight::GetLightmassData ( struct FH7LightmassEnvironmentSphereData* Data )
{
	static UFunction* pFnGetLightmassData = NULL;

	if ( ! pFnGetLightmassData )
		pFnGetLightmassData = (UFunction*) UObject::GObjObjects()->Data[ 47624 ];

	AH7RadiusDirectionalLight_execGetLightmassData_Parms GetLightmassData_Parms;

	pFnGetLightmassData->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetLightmassData, &GetLightmassData_Parms, NULL );

	pFnGetLightmassData->FunctionFlags |= 0x400;

	if ( Data )
		memcpy ( Data, &GetLightmassData_Parms.Data, 0x18 );

	return GetLightmassData_Parms.ReturnValue;
};

// Function MMH7Engine.H7RadiusDominantDirectionalLight.GetLightmassData
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
// struct FH7LightmassEnvironmentSphereData Data                           ( CPF_Parm | CPF_OutParm )

bool AH7RadiusDominantDirectionalLight::GetLightmassData ( struct FH7LightmassEnvironmentSphereData* Data )
{
	static UFunction* pFnGetLightmassData = NULL;

	if ( ! pFnGetLightmassData )
		pFnGetLightmassData = (UFunction*) UObject::GObjObjects()->Data[ 47633 ];

	AH7RadiusDominantDirectionalLight_execGetLightmassData_Parms GetLightmassData_Parms;

	pFnGetLightmassData->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnGetLightmassData, &GetLightmassData_Parms, NULL );

	pFnGetLightmassData->FunctionFlags |= 0x400;

	if ( Data )
		memcpy ( Data, &GetLightmassData_Parms.Data, 0x18 );

	return GetLightmassData_Parms.ReturnValue;
};

// Function MMH7Engine.H7Texture2DStreamLoad.IsTextureReady
// [0x00020400] ( FUNC_Native )
// Parameters infos:
// bool                           ReturnValue                    ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )

bool UH7Texture2DStreamLoad::IsTextureReady ( )
{
	static UFunction* pFnIsTextureReady = NULL;

	if ( ! pFnIsTextureReady )
		pFnIsTextureReady = (UFunction*) UObject::GObjObjects()->Data[ 47648 ];

	UH7Texture2DStreamLoad_execIsTextureReady_Parms IsTextureReady_Parms;

	pFnIsTextureReady->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnIsTextureReady, &IsTextureReady_Parms, NULL );

	pFnIsTextureReady->FunctionFlags |= 0x400;

	return IsTextureReady_Parms.ReturnValue;
};

// Function MMH7Engine.H7Texture2DStreamLoad.PerformUpdate
// [0x00020400] ( FUNC_Native )
// Parameters infos:

void UH7Texture2DStreamLoad::PerformUpdate ( )
{
	static UFunction* pFnPerformUpdate = NULL;

	if ( ! pFnPerformUpdate )
		pFnPerformUpdate = (UFunction*) UObject::GObjObjects()->Data[ 47647 ];

	UH7Texture2DStreamLoad_execPerformUpdate_Parms PerformUpdate_Parms;

	pFnPerformUpdate->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnPerformUpdate, &PerformUpdate_Parms, NULL );

	pFnPerformUpdate->FunctionFlags |= 0x400;
};

// Function MMH7Engine.H7Texture2DStreamLoad.SwitchStreamingTo
// [0x00420400] ( FUNC_Native )
// Parameters infos:
// struct FString                 packageOwnerName               ( CPF_Parm | CPF_NeedCtorLink )
// struct FH7TextureRawDataOutput texRawData                     ( CPF_Const | CPF_Parm | CPF_OutParm )
// int                            isTextureReinitialized         ( CPF_Parm | CPF_OutParm )

void UH7Texture2DStreamLoad::SwitchStreamingTo ( struct FString packageOwnerName, struct FH7TextureRawDataOutput* texRawData, int* isTextureReinitialized )
{
	static UFunction* pFnSwitchStreamingTo = NULL;

	if ( ! pFnSwitchStreamingTo )
		pFnSwitchStreamingTo = (UFunction*) UObject::GObjObjects()->Data[ 47643 ];

	UH7Texture2DStreamLoad_execSwitchStreamingTo_Parms SwitchStreamingTo_Parms;
	memcpy ( &SwitchStreamingTo_Parms.packageOwnerName, &packageOwnerName, 0x10 );

	pFnSwitchStreamingTo->FunctionFlags |= ~0x400;

	this->ProcessEvent ( pFnSwitchStreamingTo, &SwitchStreamingTo_Parms, NULL );

	pFnSwitchStreamingTo->FunctionFlags |= 0x400;

	if ( texRawData )
		memcpy ( texRawData, &SwitchStreamingTo_Parms.texRawData, 0x1C );

	if ( isTextureReinitialized )
		*isTextureReinitialized = SwitchStreamingTo_Parms.isTextureReinitialized;
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif