#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: MMH7Engine_classes.h
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

// Enum MMH7Engine.H7ContentScanner.ContentLocationTag
/*enum ContentLocationTag
{
	CLT_UNDEFINED                                      = 0,
	CLT_USERFOLDER                                     = 1,
	CLT_STEAMWORKSHOP                                  = 2,
	CLT_MAX                                            = 3
};*/


/*
# ========================================================================================= #
# Classes
# ========================================================================================= #
*/

// Class MMH7Engine.BinDiffPkgCommandlet ( Property size: 0 iter: 1) 
// Class name index: 7919 
// 0x0000 (0x00B4 - 0x00B4)
class UBinDiffPkgCommandlet : public UCommandlet
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3106 ];

		return pClassPointer;
	};

	int eventMain ( struct FString Params );
};



// Class MMH7Engine.DynamicMaterialEffect ( Property size: 3 iter: 3) 
// Class name index: 7921 
// 0x0017 (0x009C - 0x0085)
class UDynamicMaterialEffect : public UPostProcessEffect
{
public:
	unsigned long                                      InjectWindDirParam : 1;                           		// 0x0088 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class UMaterialInterface*                          ProcessMaterial;                                  		// 0x008C (0x0008) [0x0000000000002000]              ( CPF_Transient )
	class ADynamicMaterialEffectVolume*                HighestPriorityVolume;                            		// 0x0094 (0x0008) [0x0000000001002002]              ( CPF_Const | CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3108 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.DynamicMaterialEffectVolume ( Property size: 7 iter: 8) 
// Class name index: 7923 
// 0x0030 (0x02AC - 0x027C)
class ADynamicMaterialEffectVolume : public AVolume
{
public:
	class UMaterialInterface*                          mParentDynamicMaterialEffect;                     		// 0x027C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInstanceConstant*                   mCurrentDynamicMaterialEffect;                    		// 0x0284 (0x0008) [0x0000000000002000]              ( CPF_Transient )
	struct FName                                       mChainMaterialEffectName;                         		// 0x028C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              Priority;                                         		// 0x0294 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class ADynamicMaterialEffectVolume*                NextLowerPriorityVolume;                          		// 0x0298 (0x0008) [0x0000000001002002]              ( CPF_Const | CPF_Transient )
	unsigned long                                      bEnabled : 1;                                     		// 0x02A0 (0x0004) [0x0000000000000021] [0x00000001] ( CPF_Edit | CPF_Net )
	class ADynamicMaterialEffectVolume*                ChoosenVolume;                                    		// 0x02A4 (0x0008) [0x0000000001002002]              ( CPF_Const | CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3110 ];

		return pClassPointer;
	};

	void OnToggle ( class USeqAct_Toggle* Action );
};



// Class MMH7Engine.H7AtmosphericEffectVolume ( Property size: 8 iter: 8) 
// Class name index: 7925 
// 0x002C (0x02D8 - 0x02AC)
class AH7AtmosphericEffectVolume : public ADynamicMaterialEffectVolume
{
public:
	float                                              mCloudShadowsIntensity;                           		// 0x02AC (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mFogDensity;                                      		// 0x02B0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mFogHeightFalloff;                                		// 0x02B4 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mFogOpacity;                                      		// 0x02B8 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mFogStartDistance;                                		// 0x02BC (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mFogBrightness;                                   		// 0x02C0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                mFogColor;                                        		// 0x02C4 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mUsedAsLayer : 1;                                 		// 0x02D4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3112 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7CampaignDataHolder ( Property size: 1 iter: 2) 
// Class name index: 7927 
// 0x00B0 (0x0110 - 0x0060)
class UH7CampaignDataHolder : public UObject
{
public:
	struct FH7CampaignData                             mCampaignData;                                    		// 0x0060 (0x00B0) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3114 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7CombatMapDataHolder ( Property size: 0 iter: 1) 
// Class name index: 7929 
// 0x0000 (0x0060 - 0x0060)
class UH7CombatMapDataHolder : public UObject
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3116 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7ContentScanner ( Property size: 11 iter: 20) 
// Class name index: 7931 
// 0x008C (0x00EC - 0x0060)
class UH7ContentScanner : public UObject
{
public:
	struct FPointer                                    VfTable_IWorkshopControllerInterfaceUPlay;        		// 0x0060 (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )
	TArray< struct FH7ContentScannerAdventureMapData > mCollection_AdventureData;                        		// 0x0068 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< struct FH7ContentScannerCombatMapData >    mCollection_CombatData;                           		// 0x0078 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< struct FH7ContentScannerCampaignData >     mCollection_CampaignData;                         		// 0x0088 (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< class UH7ContentScannerListener* >         mListeners;                                       		// 0x0098 (0x0010) [0x0000000000001000]              ( CPF_Native )
	unsigned long                                      mIsListing : 1;                                   		// 0x00A8 (0x0004) [0x0000000000001002] [0x00000001] ( CPF_Const | CPF_Native )
	struct FPointer                                    mThread;                                          		// 0x00AC (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	struct FPointer                                    mRunnable;                                        		// 0x00B4 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	TArray< struct FH7ContentScannerAdventureMapData > mIntermediate_AdventureData;                      		// 0x00BC (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< struct FH7ContentScannerCombatMapData >    mIntermediate_CombatData;                         		// 0x00CC (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )
	TArray< struct FH7ContentScannerCampaignData >     mIntermediate_CampaignData;                       		// 0x00DC (0x0010) [0x0000000000001002]              ( CPF_Const | CPF_Native )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3118 ];

		return pClassPointer;
	};

	void OnWorkshopItemInstalled ( struct FWorkshopInstalledItemDef* def );
	void Stop ( );
	void ComputeTick ( );
	void TriggerListing ( unsigned long bListingAdventure, unsigned long bListingCombat, unsigned long bListingCampaign );
	void Initialize ( );
};



// Class MMH7Engine.H7ContentScannerListener ( Property size: 0 iter: 3) 
// Class name index: 7933 
// 0x0000 (0x0060 - 0x0060)
class UH7ContentScannerListener : public UInterface
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3120 ];

		return pClassPointer;
	};

	void eventOnScanned_Campaign ( struct FH7ContentScannerCampaignData* CampaignData );
	void eventOnScanned_CombatMap ( struct FH7ContentScannerCombatMapData* CombatData );
	void eventOnScanned_AdventureMap ( struct FH7ContentScannerAdventureMapData* AdvData );
};



// Class MMH7Engine.H7DrawBoxComponent ( Property size: 6 iter: 6) 
// Class name index: 7935 
// 0x001C (0x0254 - 0x0238)
class UH7DrawBoxComponent : public UPrimitiveComponent
{
public:
	struct FColor                                      BoxColor;                                         		// 0x0238 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInterface*                          BoxMaterial;                                      		// 0x023C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     BoxExtent;                                        		// 0x0244 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      bDrawWireBox : 1;                                 		// 0x0250 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      bDrawMatBox : 1;                                  		// 0x0250 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      bDrawOnlyIfSelected : 1;                          		// 0x0250 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3122 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7EngineUtility ( Property size: 0 iter: 15) 
// Class name index: 7937 
// 0x0000 (0x0060 - 0x0060)
class UH7EngineUtility : public UObject
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3124 ];

		return pClassPointer;
	};

	bool KeyMapNameToVirtualKey ( struct FName keymapname, int* virtualkey );
	bool VirtualKeyToChar ( int keycode, struct FString* resultingString );
	void ForceReattachAllComponents ( TArray< class AActor* > actorsToReattach );
	bool UpdateTextureFromFile ( struct FString Path, class UTexture2D* Tex );
	class UTexture2D* LoadTextureFromFile ( struct FString Path, struct FString TextureName );
	bool SaveTextureToFile ( struct FString Path, class UTexture2D* Tex );
	bool SaveRenderTargetToFile ( struct FString Path, class UTextureRenderTarget2D* RenderTarget );
	void QuitGame ( );
	void SetVoiceVolumeSetting ( float Volume );
	void SetMusicVolumeSetting ( float Volume );
	bool GetGameSubtitleEnabled ( );
	void SetGameSubtitleEnabled ( unsigned long val );
	struct FString GetGameAudioLanguageExt ( );
	void SetGameAudioLanguageExt ( struct FString ext );
	void SetGameLanguageExt ( struct FString ext );
};



// Class MMH7Engine.H7ErosionMapCapture ( Property size: 6 iter: 8) 
// Class name index: 7939 
// 0x0010 (0x0260 - 0x0250)
class AH7ErosionMapCapture : public ASceneCapture2DSpecificActor
{
public:
	unsigned long                                      mIsSetup : 1;                                     		// 0x0250 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mFinishSetup : 1;                                 		// 0x0250 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mTimedFinishSetup : 1;                            		// 0x0250 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      bEnableMaterial : 1;                              		// 0x0250 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	float                                              mSetupTimer;                                      		// 0x0254 (0x0004) [0x0000000000000000]              
	class ALandscape*                                  AffectedLand;                                     		// 0x0258 (0x0008) [0x0000000000000000]              

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3126 ];

		return pClassPointer;
	};

	void eventDestroyed ( );
	void eventTick ( float DeltaTime );
};



// Class MMH7Engine.H7GraphicsController ( Property size: 0 iter: 7) 
// Class name index: 7941 
// 0x0000 (0x0060 - 0x0060)
class UH7GraphicsController : public UObject
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3128 ];

		return pClassPointer;
	};

	bool GetCurrentAdapterIndex ( int* adapterindex );
	bool GetAdapterCount ( int* adaptercount );
	bool GetAdapterName ( struct FString* adaptername );
	bool GetAvailableBorderlessResolutions ( TArray< struct FFullscreenResolution >* AvailableResolutions );
	bool GetAvailableWindowedResolutions ( TArray< struct FFullscreenResolution >* AvailableResolutions );
	bool GetAvailableFullscreenResolutions ( TArray< struct FFullscreenResolution >* AvailableResolutions );
};



// Class MMH7Engine.H7LandscapeEditorTools ( Property size: 2 iter: 5) 
// Class name index: 7946 
// 0x0004 (0x00B8 - 0x00B4)
class UH7LandscapeEditorTools : public UBrushBuilder
{
public:
	unsigned long                                      mSculpt_RaiseLandscape : 1;                       		// 0x00B4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mSculpt_CarveLandscape : 1;                       		// 0x00B4 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3133 ];

		return pClassPointer;
	};

	void Sculpt_CarveLandscape ( );
	void Sculpt_RaiseLandscape ( );
	bool eventBuild ( );
};



// Class MMH7Engine.H7ListingCampaign ( Property size: 2 iter: 6) 
// Class name index: 7948 
// 0x0010 (0x0070 - 0x0060)
class UH7ListingCampaign : public UObject
{
public:
	struct FPointer                                    mThread;                                          		// 0x0060 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	struct FPointer                                    mRunnable;                                        		// 0x0068 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3135 ];

		return pClassPointer;
	};

	void Stop ( );
	void Poll ( TArray< struct FH7ListingCampaignData >* outData, int* isPollingOver );
	void Start ( );
};



// Class MMH7Engine.H7ListingCombatMap ( Property size: 2 iter: 8) 
// Class name index: 7950 
// 0x0010 (0x0070 - 0x0060)
class UH7ListingCombatMap : public UObject
{
public:
	struct FPointer                                    mThread;                                          		// 0x0060 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	struct FPointer                                    mRunnable;                                        		// 0x0068 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3137 ];

		return pClassPointer;
	};

	bool ScanCombatMapHeader ( struct FString MapFilename, unsigned long gatherThumbnailData, struct FH7CombatMapData* outMapDataStruct );
	struct FString GetMapName ( struct FString filepath );
	void Stop ( );
	void Poll ( TArray< struct FH7ListingCombatMapData >* outData, int* isPollingOver );
	void Start ( );
};



// Class MMH7Engine.H7ListingMap ( Property size: 2 iter: 8) 
// Class name index: 7952 
// 0x0010 (0x0070 - 0x0060)
class UH7ListingMap : public UObject
{
public:
	struct FPointer                                    mThread;                                          		// 0x0060 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	struct FPointer                                    mRunnable;                                        		// 0x0068 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3139 ];

		return pClassPointer;
	};

	bool ScanMapHeader ( struct FString MapFilename, unsigned long gatherThumbnailData, struct FH7MapData* outMapDataStruct );
	struct FString GetMapName ( struct FString filepath );
	void Stop ( );
	void Poll ( TArray< struct FH7ListingMapData >* outData, int* isPollingOver );
	void Start ( );
};



// Class MMH7Engine.H7MapDataHolder ( Property size: 0 iter: 4) 
// Class name index: 7954 
// 0x0000 (0x0060 - 0x0060)
class UH7MapDataHolder : public UObject
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3141 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7MapDataHolderCommon ( Property size: 0 iter: 1) 
// Class name index: 7956 
// 0x0000 (0x0060 - 0x0060)
class UH7MapDataHolderCommon : public UObject
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3143 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7ObjectEditorTools ( Property size: 3 iter: 6) 
// Class name index: 7958 
// 0x0018 (0x00CC - 0x00B4)
class UH7ObjectEditorTools : public UBrushBuilder
{
public:
	class UObject*                                     mObjectToChange;                                  		// 0x00B4 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UObject*                                     mNewObjectArchetype;                              		// 0x00BC (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UObject*                                     mNewSelectedObjectArchetype;                      		// 0x00C4 (0x0008) [0x0000000000000001]              ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3145 ];

		return pClassPointer;
	};

	bool eventBuild ( );
	void ChangeSelectedObjectsArchetype ( );
	void ChangeObjectArchetype ( );
};



// Class MMH7Engine.ImportAkEventsCommandlet ( Property size: 0 iter: 1) 
// Class name index: 7960 
// 0x0000 (0x00B4 - 0x00B4)
class UImportAkEventsCommandlet : public UCommandlet
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3147 ];

		return pClassPointer;
	};

	int eventMain ( struct FString args );
};



// Class MMH7Engine.InterpTrackVectorMaterialParamFromLocation ( Property size: 1 iter: 1) 
// Class name index: 7962 
// 0x0008 (0x0114 - 0x010C)
class UInterpTrackVectorMaterialParamFromLocation : public UInterpTrackVectorMaterialParam
{
public:
	class AActor*                                      ActorUsedForLocation;                             		// 0x010C (0x0008) [0x0000000000000001]              ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3149 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.MemLeakCheckEmptyCommandlet ( Property size: 0 iter: 1) 
// Class name index: 7964 
// 0x0000 (0x00B4 - 0x00B4)
class UMemLeakCheckEmptyCommandlet : public UCommandlet
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3151 ];

		return pClassPointer;
	};

	int eventMain ( struct FString Params );
};



// Class MMH7Engine.RegenerateAllSoundbanksCommandlet ( Property size: 0 iter: 1) 
// Class name index: 7966 
// 0x0000 (0x00B4 - 0x00B4)
class URegenerateAllSoundbanksCommandlet : public UCommandlet
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3153 ];

		return pClassPointer;
	};

	int eventMain ( struct FString Params );
};



// Class MMH7Engine.RenderTargetMaterialEffect ( Property size: 3 iter: 3) 
// Class name index: 7968 
// 0x0017 (0x009C - 0x0085)
class URenderTargetMaterialEffect : public UPostProcessEffect
{
public:
	class UMaterialInterface*                          ProcessMaterial;                                  		// 0x0088 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UTextureRenderTarget2D*                      RenderTarget;                                     		// 0x0090 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              RenderTargetRatioSize;                            		// 0x0098 (0x0004) [0x0000000000000001]              ( CPF_Edit )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3155 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.TransferDataFromFXStructsToFXObjectsCommandlet ( Property size: 0 iter: 1) 
// Class name index: 7970 
// 0x0000 (0x00B4 - 0x00B4)
class UTransferDataFromFXStructsToFXObjectsCommandlet : public UCommandlet
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3157 ];

		return pClassPointer;
	};

	int eventMain ( struct FString Params );
};



// Class MMH7Engine.H7RadiusDirectionalLight ( Property size: 1 iter: 2) 
// Class name index: 7972 
// 0x0008 (0x0254 - 0x024C)
class AH7RadiusDirectionalLight : public ADirectionalLight
{
public:
	struct FPointer                                    VfTable_IH7LightmassEnvironmentSphereInterface;   		// 0x024C (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3159 ];

		return pClassPointer;
	};

	bool GetLightmassData ( struct FH7LightmassEnvironmentSphereData* Data );
};



// Class MMH7Engine.H7RadiusDirectionalLightComponent ( Property size: 4 iter: 4) 
// Class name index: 7974 
// 0x0014 (0x01D4 - 0x01C0)
class UH7RadiusDirectionalLightComponent : public UDirectionalLightComponent
{
public:
	float                                              Radius;                                           		// 0x01C0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      EnvironmentColor;                                 		// 0x01C4 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EnvironmentColorIntensity;                        		// 0x01C8 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UDrawLightRadiusComponent*                   PreviewLightRadius;                               		// 0x01CC (0x0008) [0x000000000408000A]              ( CPF_Const | CPF_ExportObject | CPF_Component | CPF_EditInline )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3161 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7RadiusDominantDirectionalLight ( Property size: 1 iter: 2) 
// Class name index: 7976 
// 0x0008 (0x0254 - 0x024C)
class AH7RadiusDominantDirectionalLight : public ADominantDirectionalLight
{
public:
	struct FPointer                                    VfTable_IH7LightmassEnvironmentSphereInterface;   		// 0x024C (0x0008) [0x0000000000801002]              ( CPF_Const | CPF_Native | CPF_NoExport )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3163 ];

		return pClassPointer;
	};

	bool GetLightmassData ( struct FH7LightmassEnvironmentSphereData* Data );
};



// Class MMH7Engine.H7RadiusDominantDirectionalLightComponent ( Property size: 4 iter: 4) 
// Class name index: 7978 
// 0x0014 (0x0294 - 0x0280)
class UH7RadiusDominantDirectionalLightComponent : public UDominantDirectionalLightComponent
{
public:
	float                                              Radius;                                           		// 0x0280 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      EnvironmentColor;                                 		// 0x0284 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EnvironmentColorIntensity;                        		// 0x0288 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UDrawLightRadiusComponent*                   PreviewLightRadius;                               		// 0x028C (0x0008) [0x000000000408000A]              ( CPF_Const | CPF_ExportObject | CPF_Component | CPF_EditInline )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3165 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7RadiusSkylight ( Property size: 0 iter: 0) 
// Class name index: 7980 
// 0x0000 (0x024C - 0x024C)
class AH7RadiusSkylight : public ASkyLight
{
public:

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3167 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7RadiusSkylightComponent ( Property size: 2 iter: 2) 
// Class name index: 7982 
// 0x000C (0x01B4 - 0x01A8)
class UH7RadiusSkylightComponent : public USkyLightComponent
{
public:
	float                                              Radius;                                           		// 0x01A8 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UDrawLightRadiusComponent*                   PreviewLightRadius;                               		// 0x01AC (0x0008) [0x000000000408000A]              ( CPF_Const | CPF_ExportObject | CPF_Component | CPF_EditInline )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3169 ];

		return pClassPointer;
	};

};



// Class MMH7Engine.H7Texture2DStreamLoad ( Property size: 3 iter: 6) 
// Class name index: 7984 
// 0x0014 (0x0154 - 0x0140)
class UH7Texture2DStreamLoad : public UTexture2DDynamic
{
public:
	unsigned long                                      mHasBeenAlreadyInitialized : 1;                   		// 0x0140 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FPointer                                    mThread;                                          		// 0x0144 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	struct FPointer                                    mRunnable;                                        		// 0x014C (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )

private:
	static UClass* pClassPointer;

public:
	static UClass* StaticClass()
	{
		if ( ! pClassPointer )
			pClassPointer = (UClass*) UObject::GObjObjects()->Data[ 3171 ];

		return pClassPointer;
	};

	bool IsTextureReady ( );
	void PerformUpdate ( );
	void SwitchStreamingTo ( struct FString packageOwnerName, struct FH7TextureRawDataOutput* texRawData, int* isTextureReinitialized );
};




#ifdef _MSC_VER
	#pragma pack ( pop )
#endif