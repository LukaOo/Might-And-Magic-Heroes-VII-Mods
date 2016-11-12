#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: MMH7Engine_f_structs.h
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

// Function MMH7Engine.BinDiffPkgCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UBinDiffPkgCommandlet_eventMain_Parms
{
	struct FString                                     Params;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.DynamicMaterialEffectVolume.OnToggle
// [0x00020102] 
struct ADynamicMaterialEffectVolume_execOnToggle_Parms
{
	class USeqAct_Toggle*                              Action;                                           		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
};

// Function MMH7Engine.H7ContentScanner.OnWorkshopItemInstalled
// [0x00420400] ( FUNC_Native )
struct UH7ContentScanner_execOnWorkshopItemInstalled_Parms
{
	struct FWorkshopInstalledItemDef                   def;                                              		// 0x0000 (0x0018) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7ContentScanner.Stop
// [0x00020400] ( FUNC_Native )
struct UH7ContentScanner_execStop_Parms
{
};

// Function MMH7Engine.H7ContentScanner.ComputeTick
// [0x00020400] ( FUNC_Native )
struct UH7ContentScanner_execComputeTick_Parms
{
};

// Function MMH7Engine.H7ContentScanner.TriggerListing
// [0x00020400] ( FUNC_Native )
struct UH7ContentScanner_execTriggerListing_Parms
{
	unsigned long                                      bListingAdventure : 1;                            		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      bListingCombat : 1;                               		// 0x0004 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
	unsigned long                                      bListingCampaign : 1;                             		// 0x0008 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function MMH7Engine.H7ContentScanner.Initialize
// [0x00020400] ( FUNC_Native )
struct UH7ContentScanner_execInitialize_Parms
{
};

// Function MMH7Engine.H7ContentScannerListener.OnScanned_Campaign
// [0x00420800] ( FUNC_Event )
struct UH7ContentScannerListener_eventOnScanned_Campaign_Parms
{
	struct FH7ContentScannerCampaignData               CampaignData;                                     		// 0x0000 (0x00D4) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7ContentScannerListener.OnScanned_CombatMap
// [0x00420800] ( FUNC_Event )
struct UH7ContentScannerListener_eventOnScanned_CombatMap_Parms
{
	struct FH7ContentScannerCombatMapData              CombatData;                                       		// 0x0000 (0x0090) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7ContentScannerListener.OnScanned_AdventureMap
// [0x00420800] ( FUNC_Event )
struct UH7ContentScannerListener_eventOnScanned_AdventureMap_Parms
{
	struct FH7ContentScannerAdventureMapData           AdvData;                                          		// 0x0000 (0x0330) [0x0000000000400182]              ( CPF_Const | CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7EngineUtility.KeyMapNameToVirtualKey
// [0x00422400] ( FUNC_Native )
struct UH7EngineUtility_execKeyMapNameToVirtualKey_Parms
{
	struct FName                                       keymapname;                                       		// 0x0000 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	int                                                virtualkey;                                       		// 0x0008 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x000C (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7EngineUtility.VirtualKeyToChar
// [0x00422400] ( FUNC_Native )
struct UH7EngineUtility_execVirtualKeyToChar_Parms
{
	int                                                keycode;                                          		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
	struct FString                                     resultingString;                                  		// 0x0004 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0014 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7EngineUtility.ForceReattachAllComponents
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execForceReattachAllComponents_Parms
{
	TArray< class AActor* >                            actorsToReattach;                                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7EngineUtility.UpdateTextureFromFile
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execUpdateTextureFromFile_Parms
{
	struct FString                                     Path;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UTexture2D*                                  Tex;                                              		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7EngineUtility.LoadTextureFromFile
// [0x00026400] ( FUNC_Native )
struct UH7EngineUtility_execLoadTextureFromFile_Parms
{
	struct FString                                     Path;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     TextureName;                                      		// 0x0010 (0x0010) [0x0000000000400090]              ( CPF_OptionalParm | CPF_Parm | CPF_NeedCtorLink )
	class UTexture2D*                                  ReturnValue;                                      		// 0x0020 (0x0008) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7EngineUtility.SaveTextureToFile
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execSaveTextureToFile_Parms
{
	struct FString                                     Path;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UTexture2D*                                  Tex;                                              		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7EngineUtility.SaveRenderTargetToFile
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execSaveRenderTargetToFile_Parms
{
	struct FString                                     Path;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	class UTextureRenderTarget2D*                      RenderTarget;                                     		// 0x0010 (0x0008) [0x0000000000000080]              ( CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7EngineUtility.QuitGame
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execQuitGame_Parms
{
};

// Function MMH7Engine.H7EngineUtility.SetVoiceVolumeSetting
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execSetVoiceVolumeSetting_Parms
{
	float                                              Volume;                                           		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function MMH7Engine.H7EngineUtility.SetMusicVolumeSetting
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execSetMusicVolumeSetting_Parms
{
	float                                              Volume;                                           		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function MMH7Engine.H7EngineUtility.GetGameSubtitleEnabled
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execGetGameSubtitleEnabled_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7EngineUtility.SetGameSubtitleEnabled
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execSetGameSubtitleEnabled_Parms
{
	unsigned long                                      val : 1;                                          		// 0x0000 (0x0004) [0x0000000000000080] [0x00000001] ( CPF_Parm )
};

// Function MMH7Engine.H7EngineUtility.GetGameAudioLanguageExt
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execGetGameAudioLanguageExt_Parms
{
	struct FString                                     ReturnValue;                                      		// 0x0000 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7EngineUtility.SetGameAudioLanguageExt
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execSetGameAudioLanguageExt_Parms
{
	struct FString                                     ext;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7EngineUtility.SetGameLanguageExt
// [0x00022400] ( FUNC_Native )
struct UH7EngineUtility_execSetGameLanguageExt_Parms
{
	struct FString                                     ext;                                              		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
};

// Function MMH7Engine.H7ErosionMapCapture.Destroyed
// [0x00020802] ( FUNC_Event )
struct AH7ErosionMapCapture_eventDestroyed_Parms
{
};

// Function MMH7Engine.H7ErosionMapCapture.Tick
// [0x00020802] ( FUNC_Event )
struct AH7ErosionMapCapture_eventTick_Parms
{
	float                                              DeltaTime;                                        		// 0x0000 (0x0004) [0x0000000000000080]              ( CPF_Parm )
};

// Function MMH7Engine.H7GraphicsController.GetCurrentAdapterIndex
// [0x00422400] ( FUNC_Native )
struct UH7GraphicsController_execGetCurrentAdapterIndex_Parms
{
	int                                                adapterindex;                                     		// 0x0000 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7GraphicsController.GetAdapterCount
// [0x00422400] ( FUNC_Native )
struct UH7GraphicsController_execGetAdapterCount_Parms
{
	int                                                adaptercount;                                     		// 0x0000 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0004 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7GraphicsController.GetAdapterName
// [0x00422400] ( FUNC_Native )
struct UH7GraphicsController_execGetAdapterName_Parms
{
	struct FString                                     adaptername;                                      		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7GraphicsController.GetAvailableBorderlessResolutions
// [0x00422400] ( FUNC_Native )
struct UH7GraphicsController_execGetAvailableBorderlessResolutions_Parms
{
	TArray< struct FFullscreenResolution >             AvailableResolutions;                             		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7GraphicsController.GetAvailableWindowedResolutions
// [0x00422400] ( FUNC_Native )
struct UH7GraphicsController_execGetAvailableWindowedResolutions_Parms
{
	TArray< struct FFullscreenResolution >             AvailableResolutions;                             		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7GraphicsController.GetAvailableFullscreenResolutions
// [0x00422400] ( FUNC_Native )
struct UH7GraphicsController_execGetAvailableFullscreenResolutions_Parms
{
	TArray< struct FFullscreenResolution >             AvailableResolutions;                             		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0010 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7LandscapeEditorTools.Sculpt_CarveLandscape
// [0x00020400] ( FUNC_Native )
struct UH7LandscapeEditorTools_execSculpt_CarveLandscape_Parms
{
};

// Function MMH7Engine.H7LandscapeEditorTools.Sculpt_RaiseLandscape
// [0x00020400] ( FUNC_Native )
struct UH7LandscapeEditorTools_execSculpt_RaiseLandscape_Parms
{
};

// Function MMH7Engine.H7LandscapeEditorTools.Build
// [0x00020802] ( FUNC_Event )
struct UH7LandscapeEditorTools_eventBuild_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7ListingCampaign.Stop
// [0x00020400] ( FUNC_Native )
struct UH7ListingCampaign_execStop_Parms
{
};

// Function MMH7Engine.H7ListingCampaign.Poll
// [0x00420400] ( FUNC_Native )
struct UH7ListingCampaign_execPoll_Parms
{
	TArray< struct FH7ListingCampaignData >            outData;                                          		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                isPollingOver;                                    		// 0x0010 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function MMH7Engine.H7ListingCampaign.Start
// [0x00020400] ( FUNC_Native )
struct UH7ListingCampaign_execStart_Parms
{
};

// Function MMH7Engine.H7ListingCombatMap.ScanCombatMapHeader
// [0x00426400] ( FUNC_Native )
struct UH7ListingCombatMap_execScanCombatMapHeader_Parms
{
	struct FString                                     MapFilename;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FH7CombatMapData                            outMapDataStruct;                                 		// 0x0010 (0x006C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      gatherThumbnailData : 1;                          		// 0x007C (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0080 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7ListingCombatMap.GetMapName
// [0x00022002] 
struct UH7ListingCombatMap_execGetMapName_Parms
{
	struct FString                                     filepath;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             lastSlashIndex;                                   		// 0x0020 (0x0004) [0x0000000000000000]              
	// struct FString                                  Slash;                                            		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MapName;                                          		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function MMH7Engine.H7ListingCombatMap.Stop
// [0x00020400] ( FUNC_Native )
struct UH7ListingCombatMap_execStop_Parms
{
};

// Function MMH7Engine.H7ListingCombatMap.Poll
// [0x00420400] ( FUNC_Native )
struct UH7ListingCombatMap_execPoll_Parms
{
	TArray< struct FH7ListingCombatMapData >           outData;                                          		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                isPollingOver;                                    		// 0x0010 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function MMH7Engine.H7ListingCombatMap.Start
// [0x00020400] ( FUNC_Native )
struct UH7ListingCombatMap_execStart_Parms
{
};

// Function MMH7Engine.H7ListingMap.ScanMapHeader
// [0x00426400] ( FUNC_Native )
struct UH7ListingMap_execScanMapHeader_Parms
{
	struct FString                                     MapFilename;                                      		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FH7MapData                                  outMapDataStruct;                                 		// 0x0010 (0x030C) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	unsigned long                                      gatherThumbnailData : 1;                          		// 0x031C (0x0004) [0x0000000000000090] [0x00000001] ( CPF_OptionalParm | CPF_Parm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0320 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7ListingMap.GetMapName
// [0x00022002] 
struct UH7ListingMap_execGetMapName_Parms
{
	struct FString                                     filepath;                                         		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FString                                     ReturnValue;                                      		// 0x0010 (0x0010) [0x0000000000400580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm | CPF_NeedCtorLink )
	// int                                             lastSlashIndex;                                   		// 0x0020 (0x0004) [0x0000000000000000]              
	// struct FString                                  Slash;                                            		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	// struct FString                                  MapName;                                          		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// Function MMH7Engine.H7ListingMap.Stop
// [0x00020400] ( FUNC_Native )
struct UH7ListingMap_execStop_Parms
{
};

// Function MMH7Engine.H7ListingMap.Poll
// [0x00420400] ( FUNC_Native )
struct UH7ListingMap_execPoll_Parms
{
	TArray< struct FH7ListingMapData >                 outData;                                          		// 0x0000 (0x0010) [0x0000000000400180]              ( CPF_Parm | CPF_OutParm | CPF_NeedCtorLink )
	int                                                isPollingOver;                                    		// 0x0010 (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};

// Function MMH7Engine.H7ListingMap.Start
// [0x00020400] ( FUNC_Native )
struct UH7ListingMap_execStart_Parms
{
};

// Function MMH7Engine.H7ObjectEditorTools.Build
// [0x00020802] ( FUNC_Event )
struct UH7ObjectEditorTools_eventBuild_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7ObjectEditorTools.ChangeSelectedObjectsArchetype
// [0x00020400] ( FUNC_Native )
struct UH7ObjectEditorTools_execChangeSelectedObjectsArchetype_Parms
{
};

// Function MMH7Engine.H7ObjectEditorTools.ChangeObjectArchetype
// [0x00020400] ( FUNC_Native )
struct UH7ObjectEditorTools_execChangeObjectArchetype_Parms
{
};

// Function MMH7Engine.ImportAkEventsCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UImportAkEventsCommandlet_eventMain_Parms
{
	struct FString                                     args;                                             		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.MemLeakCheckEmptyCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UMemLeakCheckEmptyCommandlet_eventMain_Parms
{
	struct FString                                     Params;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.RegenerateAllSoundbanksCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct URegenerateAllSoundbanksCommandlet_eventMain_Parms
{
	struct FString                                     Params;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.TransferDataFromFXStructsToFXObjectsCommandlet.Main
// [0x00020C00] ( FUNC_Event | FUNC_Native )
struct UTransferDataFromFXStructsToFXObjectsCommandlet_eventMain_Parms
{
	struct FString                                     Params;                                           		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	int                                                ReturnValue;                                      		// 0x0010 (0x0004) [0x0000000000000580]              ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7RadiusDirectionalLight.GetLightmassData
// [0x00420400] ( FUNC_Native )
struct AH7RadiusDirectionalLight_execGetLightmassData_Parms
{
	struct FH7LightmassEnvironmentSphereData           Data;                                             		// 0x0000 (0x0018) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7RadiusDominantDirectionalLight.GetLightmassData
// [0x00420400] ( FUNC_Native )
struct AH7RadiusDominantDirectionalLight_execGetLightmassData_Parms
{
	struct FH7LightmassEnvironmentSphereData           Data;                                             		// 0x0000 (0x0018) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
	unsigned long                                      ReturnValue : 1;                                  		// 0x0018 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7Texture2DStreamLoad.IsTextureReady
// [0x00020400] ( FUNC_Native )
struct UH7Texture2DStreamLoad_execIsTextureReady_Parms
{
	unsigned long                                      ReturnValue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000580] [0x00000001] ( CPF_Parm | CPF_OutParm | CPF_ReturnParm )
};

// Function MMH7Engine.H7Texture2DStreamLoad.PerformUpdate
// [0x00020400] ( FUNC_Native )
struct UH7Texture2DStreamLoad_execPerformUpdate_Parms
{
};

// Function MMH7Engine.H7Texture2DStreamLoad.SwitchStreamingTo
// [0x00420400] ( FUNC_Native )
struct UH7Texture2DStreamLoad_execSwitchStreamingTo_Parms
{
	struct FString                                     packageOwnerName;                                 		// 0x0000 (0x0010) [0x0000000000400080]              ( CPF_Parm | CPF_NeedCtorLink )
	struct FH7TextureRawDataOutput                     texRawData;                                       		// 0x0010 (0x001C) [0x0000000000000182]              ( CPF_Const | CPF_Parm | CPF_OutParm )
	int                                                isTextureReinitialized;                           		// 0x002C (0x0004) [0x0000000000000180]              ( CPF_Parm | CPF_OutParm )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif