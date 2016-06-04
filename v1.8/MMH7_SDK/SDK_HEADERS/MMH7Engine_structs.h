#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: MMH7Engine_structs.h
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

// ScriptStruct MMH7Engine.H7MapDataHolderCommon.H7TextureRawDataOutput
// 0x0000001C
struct FH7TextureRawDataOutput
{
//	 vPoperty_Size=6
	int                                                SizeX;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                SizeY;                                            		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                BulkDataOffsetInFile;                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                BulkDataSizeOnDisk;                               		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ElementCount;                                     		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       TextureFormat;                                    		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Engine.H7CampaignDataHolder.H7CampaignData
// 0x000000B0
struct FH7CampaignData
{
//	 vPoperty_Size=d
	int                                                mRevision;                                        		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     mName;                                            		// 0x0004 (0x0010) [0x0000000000508003]              ( CPF_Edit | CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	struct FString                                     mFileName;                                        		// 0x0014 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     mAuthor;                                          		// 0x0024 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     mDescription;                                     		// 0x0034 (0x0010) [0x0000000000508003]              ( CPF_Edit | CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	TArray< struct FString >                           mCampaignMaps;                                    		// 0x0044 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FString >                           mCampaignMapNames;                                		// 0x0054 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FName                                       mThumbnailTextureName;                            		// 0x0064 (0x0008) [0x0000000000100001]              ( CPF_Edit )
	unsigned long                                      mIsThumbnailDataAvailable : 1;                    		// 0x006C (0x0004) [0x0000000000002001] [0x00000001] ( CPF_Edit | CPF_Transient )
	struct FH7TextureRawDataOutput                     mThumbnailData;                                   		// 0x0070 (0x001C) [0x0000000000002001]              ( CPF_Edit | CPF_Transient )
	struct FString                                     mContainerObjectName;                             		// 0x008C (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FString >                           mCampaignMapInfoNumbers;                          		// 0x009C (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mEnding;                                          		// 0x00AC (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Engine.H7CombatMapDataHolder.H7CombatMapData
// 0x0000006C
struct FH7CombatMapData
{
//	 vPoperty_Size=c
	unsigned long                                      mIsMapVisibleInDuelBrowser : 1;                   		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FString                                     mMapDescription;                                  		// 0x0004 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FName                                       mThumbnailTextureName;                            		// 0x0014 (0x0008) [0x0000000000100001]              ( CPF_Edit )
	struct FString                                     mMapName;                                         		// 0x001C (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mIsOfficial : 1;                                  		// 0x002C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FString                                     mMapInfoObjectName;                               		// 0x0030 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mMapSizeX;                                        		// 0x0040 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMapSizeY;                                        		// 0x0044 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mMapSiege : 1;                                    		// 0x0048 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mIsThumbnailDataAvailable : 1;                    		// 0x0048 (0x0004) [0x0000000000002001] [0x00000002] ( CPF_Edit | CPF_Transient )
	struct FH7TextureRawDataOutput                     mThumbnailData;                                   		// 0x004C (0x001C) [0x0000000000002001]              ( CPF_Edit | CPF_Transient )
	int                                                mEnding;                                          		// 0x0068 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Engine.H7MapDataHolder.H7LocaParams
// 0x00000040
struct FH7LocaParams
{
//	 vPoperty_Size=4
	struct FString                                     File;                                             		// 0x0000 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Section;                                          		// 0x0010 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Key;                                              		// 0x0020 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Fallback;                                         		// 0x0030 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Engine.H7MapDataHolder.H7MapHeaderResourceQuantity
// 0x00000044
struct FH7MapHeaderResourceQuantity
{
//	 vPoperty_Size=2
	struct FH7LocaParams                               Type;                                             		// 0x0000 (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                Quantity;                                         		// 0x0040 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Engine.H7MapDataHolder.H7MapHeaderPlayerInfoProperty
// 0x00000088
struct FH7MapHeaderPlayerInfoProperty
{
//	 vPoperty_Size=a
	int                                                Position;                                         		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Slot;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FH7LocaParams                               Name;                                             		// 0x0008 (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                Team;                                             		// 0x0048 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Color;                                            		// 0x004C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FString >                           ForbiddenFactions;                                		// 0x0050 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FString >                           ForbiddenHeroes;                                  		// 0x0060 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                AIDifficulty;                                     		// 0x0070 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      PlayerStartAvailable : 1;                         		// 0x0074 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FString                                     StartFaction;                                     		// 0x0078 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Engine.H7MapDataHolder.H7MapData
// 0x000002F8
struct FH7MapData
{
//	 vPoperty_Size=20
	int                                                mPlayerAmount;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     mMapDescription;                                  		// 0x0004 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mMapType;                                         		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMapSize;                                         		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FName                                       mThumbnailTextureName;                            		// 0x001C (0x0008) [0x0000000000100001]              ( CPF_Edit )
	TArray< int >                                      mAvailableVictoryConditions;                      		// 0x0024 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mWinConditionType;                                		// 0x0034 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mIncludeStandardWinConditions : 1;                		// 0x0038 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FH7LocaParams                               mWinConditionArmyToDefeat;                        		// 0x003C (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7LocaParams                               mWinConditionHeroToDefeat;                        		// 0x007C (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7LocaParams                               mWinConditionArtifactToAcquire;                   		// 0x00BC (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FH7MapHeaderResourceQuantity >      mWinConditionResourcesToCollect;                  		// 0x00FC (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7LocaParams                               mWinConditionTownToCapture;                       		// 0x010C (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7LocaParams                               mWinConditionArtifactToTransfer;                  		// 0x014C (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7LocaParams                               mWinConditionArtifactTransferTown;                		// 0x018C (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7LocaParams                               mWinConditionAccumulateCreatureTier;              		// 0x01CC (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mWinConditionAccumulateCreatureAmount;            		// 0x020C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mLoseConditionType;                               		// 0x0210 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FH7LocaParams                               mLoseConditionTownToLose;                         		// 0x0214 (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7LocaParams                               mLoseConditionHeroToLose;                         		// 0x0254 (0x0040) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mLoseConditionWeekTimeLimit;                      		// 0x0294 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     mMapInfoObjectName;                               		// 0x0298 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     mMapName;                                         		// 0x02A8 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FH7MapHeaderPlayerInfoProperty >    mPlayerInfoProperties;                            		// 0x02B8 (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mRandomStartPositionAvailable : 1;                		// 0x02C8 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mIsOfficial : 1;                                  		// 0x02C8 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mIsThumbnailDataAvailable : 1;                    		// 0x02C8 (0x0004) [0x0000000000002001] [0x00000004] ( CPF_Edit | CPF_Transient )
	struct FH7TextureRawDataOutput                     mThumbnailData;                                   		// 0x02CC (0x001C) [0x0000000000002001]              ( CPF_Edit | CPF_Transient )
	unsigned long                                      mNeedsPrivileg : 1;                               		// 0x02E8 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                mPrivilegID;                                      		// 0x02EC (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mIsValid : 1;                                     		// 0x02F0 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                mEnding;                                          		// 0x02F4 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Engine.H7ContentScanner.H7ContentScannerAdventureMapData
// 0x0000031C
struct FH7ContentScannerAdventureMapData
{
//	 vPoperty_Size=4
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Fullpath;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      LocationTag;                                      		// 0x0020 (0x0001) [0x0000000000000000]              
	struct FH7MapData                                  AdventureMapData;                                 		// 0x0024 (0x02F8) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Engine.H7ContentScanner.H7ContentScannerCombatMapData
// 0x00000090
struct FH7ContentScannerCombatMapData
{
//	 vPoperty_Size=4
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Fullpath;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      LocationTag;                                      		// 0x0020 (0x0001) [0x0000000000000000]              
	struct FH7CombatMapData                            CombatMapData;                                    		// 0x0024 (0x006C) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Engine.H7ContentScanner.H7ContentScannerCampaignData
// 0x000000D4
struct FH7ContentScannerCampaignData
{
//	 vPoperty_Size=4
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Fullpath;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      LocationTag;                                      		// 0x0020 (0x0001) [0x0000000000000000]              
	struct FH7CampaignData                             CampaignData;                                     		// 0x0024 (0x00B0) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Engine.H7GraphicsController.FullscreenResolution
// 0x00000008
struct FFullscreenResolution
{
//	 vPoperty_Size=2
	int                                                Width;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Height;                                           		// 0x0004 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Engine.H7ListingCampaign.H7ListingCampaignData
// 0x000000C0
struct FH7ListingCampaignData
{
//	 vPoperty_Size=2
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FH7CampaignData                             CampaignData;                                     		// 0x0010 (0x00B0) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Engine.H7ListingCombatMap.H7ListingCombatMapData
// 0x0000007C
struct FH7ListingCombatMapData
{
//	 vPoperty_Size=2
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FH7CombatMapData                            MapData;                                          		// 0x0010 (0x006C) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Engine.H7ListingMap.H7ListingMapData
// 0x00000308
struct FH7ListingMapData
{
//	 vPoperty_Size=2
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FH7MapData                                  MapData;                                          		// 0x0010 (0x02F8) [0x0000000000400000]              ( CPF_NeedCtorLink )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif