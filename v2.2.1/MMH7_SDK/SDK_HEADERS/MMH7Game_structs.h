#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: MMH7Game_structs.h
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

// ScriptStruct MMH7Game.GenerateRMGDataCommandlet.GenerateRMGDataCompilationTask
// 0x00000018
struct FGenerateRMGDataCompilationTask
{
//	 vPoperty_Size=3
	class UObject*                                     mTargetShaderCache;                               		// 0x0000 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	class UMaterialInstanceConstant*                   mTargetMat;                                       		// 0x0008 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
	struct FPointer                                    mStaticParameterSet;                              		// 0x0010 (0x0008) [0x0000000000003000]              ( CPF_Native | CPF_Transient )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.NecromancyEffectRatePair
// 0x0000000C
struct FNecromancyEffectRatePair
{
//	 vPoperty_Size=2
	class UH7EffectSpecialNecromancy*                  Effect;                                           		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              Rate;                                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.CreatureLossPair
// 0x0000000C
struct FCreatureLossPair
{
//	 vPoperty_Size=2
	class AH7Creature*                                 Creature;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                Losses;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.AiActionScore
// 0x00000028
struct FAiActionScore
{
//	 vPoperty_Size=5
	float                                              Score;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	class UH7AiActionBase*                             Action;                                           		// 0x0004 (0x0008) [0x0000000000000000]              
	class UH7AiActionParam*                            Params;                                           		// 0x000C (0x0008) [0x0000000000000000]              
	struct FString                                     dbgString;                                        		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              Tension;                                          		// 0x0024 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SoundSettings
// 0x00000004
struct FH7SoundSettings
{
//	 vPoperty_Size=4
	unsigned long                                      EnableAmbientChannel : 1;                         		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      EnableMusicChannel : 1;                           		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      EnableSoundChannel : 1;                           		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      EnableVoiceChannel : 1;                           		// 0x0000 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.PathCostAoCArray
// 0x00000020
struct FPathCostAoCArray
{
//	 vPoperty_Size=2
	TArray< float >                                    Costs;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7AdventureLayerCellProperty* >     Terrains;                                         		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiSpellEvaluation
// 0x0000001C
struct FH7AiSpellEvaluation
{
//	 vPoperty_Size=3
	float                                              Damage;                                           		// 0x0000 (0x0004) [0x0000000000000000]              
	class UH7IEffectTargetable*                        Target;                                           		// 0x0004 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x000C (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	class UH7HeroAbility*                              Spell;                                            		// 0x0014 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7PathfinderArrayContainer
// 0x00000010
struct FH7PathfinderArrayContainer
{
//	 vPoperty_Size=1
	TArray< class UH7CombatMapCell* >                  CellsReachableInXTurns;                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiCombatInstructionEvaluation
// 0x0000003D
struct FH7AiCombatInstructionEvaluation
{
//	 vPoperty_Size=a
	class AH7CreatureStack*                            Subordinate;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	class AH7CreatureStack*                            Target;                                           		// 0x0008 (0x0008) [0x0000000000000000]              
	float                                              DamagePotentialReduction;                         		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                TurnsToReach;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                KillCount;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                SubordinateIniQueuePosition;                      		// 0x001C (0x0004) [0x0000000000000000]              
	unsigned long                                      TargetActsAfterSubordinate : 1;                   		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
	class UH7CombatMapCell*                            HitCell;                                          		// 0x0024 (0x0008) [0x0000000000000000]              
	TArray< class UH7CombatMapCell* >                  Path;                                             		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      AttackDir;                                        		// 0x003C (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiCombatInstruction
// 0x0000004C
struct FH7AiCombatInstruction
{
//	 vPoperty_Size=3
	unsigned char                                      InstructionType;                                  		// 0x0000 (0x0001) [0x0000000000000000]              
	struct FH7AiCombatInstructionEvaluation            Evaluation;                                       		// 0x0004 (0x0040) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class AH7CreatureStack*                            InstructionOwner;                                 		// 0x0044 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiObjectivePair
// 0x00000011
struct FH7AiObjectivePair
{
//	 vPoperty_Size=3
	class AH7AdventureArmy*                            Subordinate;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7EditorMapObject*                          Target;                                           		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      ActionType;                                       		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ClassSkillWeight
// 0x0000000C
struct FH7ClassSkillWeight
{
//	 vPoperty_Size=2
	class UH7Skill*                                    mSkill;                                           		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                mWeight;                                          		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiActionParameter
// 0x00000018
struct FH7AiActionParameter
{
//	 vPoperty_Size=6
	float                                              General;                                          		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Main;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Secondary;                                        		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Scout;                                            		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Support;                                          		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Mule;                                             		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ClassSkillWeightRef
// 0x00000014
struct FH7ClassSkillWeightRef
{
//	 vPoperty_Size=2
	struct FString                                     mSkillRef;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mWeight;                                          		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RuneAbilityReplacement
// 0x00000010
struct FH7RuneAbilityReplacement
{
//	 vPoperty_Size=2
	class UH7RuneAbility*                              mRuneAbility;                                     		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseAbility*                              mBaseAbility;                                     		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AbandonedMineResource
// 0x00000018
struct FH7AbandonedMineResource
{
//	 vPoperty_Size=4
	class UH7Resource*                                 Type;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UStaticMesh*                                 MeshOverride;                                     		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Income;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      Enabled : 1;                                      		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RunicBoxReward
// 0x00000004
struct FH7RunicBoxReward
{
//	 vPoperty_Size=1
	int                                                Dummy;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CreatureReward
// 0x0025(0x0029 - 0x0004)
struct FH7CreatureReward : FH7RunicBoxReward
{
//	 vPoperty_Size=7
	int                                                Amount;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class AH7Creature*                                 Type;                                             		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7Faction* >                        PermittedFactions;                                		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      MinLevel;                                         		// 0x0020 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      MaxLevel;                                         		// 0x0021 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                Strength;                                         		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UpgradeType;                                      		// 0x0028 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TearOfAshaReward
// 0x00000014
struct FH7TearOfAshaReward
{
//	 vPoperty_Size=2
	int                                                ItemCount;                                        		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7HeroItem* >                       ItemRewards;                                      		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ArtifactReward
// 0x0020(0x0024 - 0x0004)
struct FH7ArtifactReward : FH7RunicBoxReward
{
//	 vPoperty_Size=4
	class UH7HeroItem*                                 Type;                                             		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Amount;                                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      RandomType;                                       		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7HeroItem* >                       Types;                                            		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ExperienceReward
// 0x0004(0x0008 - 0x0004)
struct FH7ExperienceReward : FH7RunicBoxReward
{
//	 vPoperty_Size=1
	int                                                Amount;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ResourceReward
// 0x000C(0x0010 - 0x0004)
struct FH7ResourceReward : FH7RunicBoxReward
{
//	 vPoperty_Size=2
	int                                                Amount;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UH7Resource*                                 Type;                                             		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ManaReward
// 0x0004(0x0008 - 0x0004)
struct FH7ManaReward : FH7RunicBoxReward
{
//	 vPoperty_Size=1
	int                                                Amount;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AttributeReward
// 0x0005(0x0009 - 0x0004)
struct FH7AttributeReward : FH7RunicBoxReward
{
//	 vPoperty_Size=2
	int                                                Amount;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Type;                                             		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TerrainCostModifier
// 0x00000018
struct FH7TerrainCostModifier
{
//	 vPoperty_Size=4
	struct FName                                       TileTypeName;                                     		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UH7PathList*                                 TileTypeNames;                                    		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      OperationType;                                    		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              Modifier;                                         		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RunicForgeItem
// 0x00000010
struct FH7RunicForgeItem
{
//	 vPoperty_Size=2
	class UH7ItemSet*                                  ItemSet;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	class UH7HeroItem*                                 Artifact;                                         		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7DwellingCreatureData
// 0x00000015
struct FH7DwellingCreatureData
{
//	 vPoperty_Size=5
	class AH7Creature*                                 Creature;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Income;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Reserve;                                          		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Capacity;                                         		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      CreatureTier;                                     		// 0x0014 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TownDwellingOverride
// 0x00000060
struct FH7TownDwellingOverride
{
//	 vPoperty_Size=7
	class AH7Town*                                     TargetTown;                                       		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UH7TownDwelling*                             TargetDwelling;                                   		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FH7DwellingCreatureData                     CreaturePool;                                     		// 0x0010 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     Name;                                             		// 0x0028 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Description;                                      		// 0x0038 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     IconPath;                                         		// 0x0048 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class UTexture2D*                                  Icon;                                             		// 0x0058 (0x0008) [0x0000000000002001]              ( CPF_Edit | CPF_Transient )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7BooleanStruct
// 0x00000004
struct FH7BooleanStruct
{
//	 vPoperty_Size=1
	unsigned long                                      Allowed : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.RandomLordDefenseData
// 0x00000055
struct FRandomLordDefenseData
{
//	 vPoperty_Size=11
	unsigned long                                      mUseThis : 1;                                     		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                mMinStackNumber;                                  		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMaxStackNumber;                                  		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7Faction* >                        mAllowedFactions;                                 		// 0x000C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      mFactionType;                                     		// 0x001C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class AH7AreaOfControlSiteLord*                    mReferenceLord;                                   		// 0x0020 (0x0008) [0x0000000000000000]              
	unsigned long                                      mUseFactionOfLord : 1;                            		// 0x0028 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mUseCreatureLevel : 1;                            		// 0x0028 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	struct FH7BooleanStruct                            mAllowedLevels[ 0x5 ];                            		// 0x002C (0x0014) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mUseXPStrength : 1;                               		// 0x0040 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                mXPStrength;                                      		// 0x0044 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMinStackSize;                                    		// 0x0048 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMaxStackSize;                                    		// 0x004C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mChooseRandomCreatures : 1;                       		// 0x0050 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mChooseSameFaction : 1;                           		// 0x0050 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mLimitLevelsFromXP : 1;                           		// 0x0050 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned char                                      mCreatureUpgrades;                                		// 0x0054 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RawCampaignData
// 0x00000084
struct FH7RawCampaignData
{
//	 vPoperty_Size=9
	int                                                mRevision;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     mName;                                            		// 0x0004 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mFileName;                                        		// 0x0014 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mAuthor;                                          		// 0x0024 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mDescription;                                     		// 0x0034 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           mCampaignMaps;                                    		// 0x0044 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           mCampaignMapNames;                                		// 0x0054 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           mCampaignMapInfoNumbers;                          		// 0x0064 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mContainerObjectName;                             		// 0x0074 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.BaseMapProgress
// 0x00000028
struct FBaseMapProgress
{
//	 vPoperty_Size=7
	struct FString                                     MapFilename;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                StartTimesCount;                                  		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              GameplayTimeSec;                                  		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                TotalGameplayTimeMin;                             		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                StartTimesUntilCompleted;                         		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                TurnsUntilCompleted;                              		// 0x0020 (0x0004) [0x0000000000000000]              
	unsigned long                                      WasOnceCompleted : 1;                             		// 0x0024 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7DifficultyParameters
// 0x00000004
struct FH7DifficultyParameters
{
//	 vPoperty_Size=4
	unsigned char                                      mStartResources;                                  		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned char                                      mCritterStartSize;                                		// 0x0001 (0x0001) [0x0000000000000000]              
	unsigned char                                      mCritterGrowthRate;                               		// 0x0002 (0x0001) [0x0000000000000000]              
	unsigned char                                      mAiEcoStrength;                                   		// 0x0003 (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7MapSaveMapping
// 0x00000038
struct FH7MapSaveMapping
{
//	 vPoperty_Size=5
	int                                                mSaveSlotIndex;                                   		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                mSaveTimeUnix;                                    		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FString                                     mMapFileName;                                     		// 0x0008 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mCampaignID;                                      		// 0x0018 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mSaveFileName;                                    		// 0x0028 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.CampaignMapProgress
// 0x0058(0x0080 - 0x0028)
struct FCampaignMapProgress : FBaseMapProgress
{
//	 vPoperty_Size=6
	TArray< int >                                      UnlockedStorypoints;                              		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      CurrentMapState;                                  		// 0x0038 (0x0001) [0x0000000000000000]              
	int                                                MapIndexInCampaign;                               		// 0x003C (0x0004) [0x0000000000000000]              
	struct FH7DifficultyParameters                     HighestDifficulty;                                		// 0x0040 (0x0004) [0x0000000000000000]              
	struct FH7DifficultyParameters                     CurrentDifficulty;                                		// 0x0044 (0x0004) [0x0000000000000000]              
	struct FH7MapSaveMapping                           LastMapSave;                                      		// 0x0048 (0x0038) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.CampaignProgress
// 0x000001E8
struct FCampaignProgress
{
//	 vPoperty_Size=d
	int                                                CampaignProgressIndex;                            		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FH7RawCampaignData                          RawCampaignData;                                  		// 0x0004 (0x0084) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UH7CampaignDefinition*                       CampaignRef;                                      		// 0x0088 (0x0008) [0x0000000000000000]              
	unsigned long                                      IsCompleted : 1;                                  		// 0x0090 (0x0004) [0x0000000000000000] [0x00000001] 
	TArray< struct FCampaignMapProgress >              CompletedMaps;                                    		// 0x0094 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FCampaignMapProgress                        CurrentMap;                                       		// 0x00A4 (0x0080) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FCampaignMapProgress                        ReplayMap;                                        		// 0x0124 (0x0080) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              GameplayTimeSec;                                  		// 0x01A4 (0x0004) [0x0000000000000000]              
	int                                                TotalGameplayTimeMin;                             		// 0x01A8 (0x0004) [0x0000000000000000]              
	unsigned long                                      CouncilIntroPlayed : 1;                           		// 0x01AC (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      CouncilOutroPlayed : 1;                           		// 0x01AC (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      ProgressScenePlayed : 1;                          		// 0x01AC (0x0004) [0x0000000000000000] [0x00000004] 
	struct FH7MapSaveMapping                           LastCampaignSave;                                 		// 0x01B0 (0x0038) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7GuardCreatureData
// 0x00000008
struct FH7GuardCreatureData
{
//	 vPoperty_Size=2
	unsigned char                                      mCreatureTier;                                    		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                mAmount;                                          		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TownGuardModifier
// 0x00000009
struct FH7TownGuardModifier
{
//	 vPoperty_Size=3
	unsigned char                                      mOperation;                                       		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                mValue;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mTier;                                            		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7GroupedMeshes
// 0x00000020
struct FH7GroupedMeshes
{
//	 vPoperty_Size=2
	struct FString                                     Group;                                            		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class UStaticMesh* >                       Meshes;                                           		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TooltipModifierInfo
// 0x00000024
struct FH7TooltipModifierInfo
{
//	 vPoperty_Size=3
	int                                                Value;                                            		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     Category;                                         		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Source;                                           		// 0x0014 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7UPlayAction
// 0x00000048
struct FH7UPlayAction
{
//	 vPoperty_Size=7
	struct FString                                     idUtf8;                                           		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     nameUtf8;                                         		// 0x0010 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     descriptionUtf8;                                  		// 0x0020 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     imageUrlUtf8;                                     		// 0x0030 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                units;                                            		// 0x0040 (0x0004) [0x0000000000000000]              
	unsigned long                                      completed : 1;                                    		// 0x0044 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      synchronized : 1;                                 		// 0x0044 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7UPlayReward
// 0x00000078
struct FH7UPlayReward
{
//	 vPoperty_Size=a
	struct FString                                     idUtf8;                                           		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     nameUtf8;                                         		// 0x0010 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     descriptionUtf8;                                  		// 0x0020 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     urlUtf8;                                          		// 0x0030 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                units;                                            		// 0x0040 (0x0004) [0x0000000000000000]              
	struct FString                                     gameCodeUtf8;                                     		// 0x0044 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     platformCodeUtf8;                                 		// 0x0054 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     imageUrlUtf8;                                     		// 0x0064 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned long                                      redeemed : 1;                                     		// 0x0074 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      Enabled : 1;                                      		// 0x0074 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7DwellingCreatureDataArray
// 0x00000010
struct FH7DwellingCreatureDataArray
{
//	 vPoperty_Size=1
	TArray< struct FH7DwellingCreatureData >           Datas;                                            		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.MovieData
// 0x00000018
struct FMovieData
{
//	 vPoperty_Size=3
	struct FString                                     MovieName;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      WasSkipped : 1;                                   		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              PlayTime;                                         		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7LobbyDataMapSettings
// 0x00000020
struct FH7LobbyDataMapSettings
{
//	 vPoperty_Size=7
	struct FString                                     mMapFileName;                                     		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned char                                      mVictoryCondition;                                		// 0x0010 (0x0001) [0x0000000000000000]              
	unsigned long                                      mCanUseStartBonus : 1;                            		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      mTeamSetup;                                       		// 0x0018 (0x0001) [0x0000000000000000]              
	unsigned long                                      mUseRandomStartPosition : 1;                      		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mUseDefaults : 1;                                 		// 0x001C (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      mIsRandomMapPreviewAvailable : 1;                 		// 0x001C (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SpellScaling
// 0x00000014
struct FH7SpellScaling
{
//	 vPoperty_Size=5
	unsigned long                                      mUseCap : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                mMinCap;                                          		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMaxCap;                                          		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mSlope;                                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mIntercept;                                       		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7LevelScalingRange
// 0x0000000C
struct FH7LevelScalingRange
{
//	 vPoperty_Size=3
	int                                                mMin;                                             		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMax;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mAmount;                                          		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ResourceQuantity
// 0x00000018
struct FH7ResourceQuantity
{
//	 vPoperty_Size=5
	class UH7Resource*                                 Type;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Quantity;                                         		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                RandomQuantityMin;                                		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                RandomQuantityMax;                                		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                RandomQuantityMultiplier;                         		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7PurchaseAbleStatModCosts
// 0x0000002C
struct FH7PurchaseAbleStatModCosts
{
//	 vPoperty_Size=3
	unsigned long                                      mUseLevelScalingCosts : 1;                        		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FH7ResourceQuantity                         mCosts;                                           		// 0x0004 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FH7LevelScalingRange >              mLevelRanges;                                     		// 0x001C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7MeModifiesStat
// 0x00000070
struct FH7MeModifiesStat
{
//	 vPoperty_Size=1a
	unsigned char                                      mStat;                                            		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mCombineOperation;                                		// 0x0001 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              mModifierValue;                                   		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mShowFloatingText : 1;                            		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mUseSpellScaling : 1;                             		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mUseLevelScaling : 1;                             		// 0x0008 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned char                                      mLevelOperation;                                  		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              mLevelScalingMultiplier;                          		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mUseBattleRageValue : 1;                          		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mMultiplyWithBattleRage : 1;                      		// 0x0014 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mUseMetamagicValue : 1;                           		// 0x0014 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      mMultiplyWithMetamagic : 1;                       		// 0x0014 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      mUseRunePowerValue : 1;                           		// 0x0014 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      mMultiplyWithRunePower : 1;                       		// 0x0014 (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	struct FH7SpellScaling                             mScalingModifierValue;                            		// 0x0018 (0x0014) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FH7LevelScalingRange >              mStatModLevelScalingValue;                        		// 0x002C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FH7PurchaseAbleStatModCosts >       mStatModCosts;                                    		// 0x003C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mMultiplyWithPathLength : 1;                      		// 0x004C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mShirneSeventhDragon : 1;                         		// 0x004C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mOverrideWithAnotherStat : 1;                     		// 0x004C (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned char                                      mStatToOverrideWith;                              		// 0x0050 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mModifyStatForCreature : 1;                       		// 0x0054 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class AH7Creature*                                 mModifyThatCreature;                              		// 0x0058 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mModifyCreatureVersions : 1;                      		// 0x0060 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class UH7EffectContainer*                          mSource;                                          		// 0x0064 (0x0008) [0x0000000000000000]              
	float                                              mInitialModValue;                                 		// 0x006C (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.ConditionalStatMod
// 0x00000088
struct FConditionalStatMod
{
//	 vPoperty_Size=3
	struct FH7MeModifiesStat                           StatMod;                                          		// 0x0000 (0x0070) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UH7EffectContainer*                          Source;                                           		// 0x0070 (0x0008) [0x0000000000000000]              
	class UH7IEffectTargetable*                        Target;                                           		// 0x0078 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0080 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.RecruitHeroData
// 0x00000014
struct FRecruitHeroData
{
//	 vPoperty_Size=5
	int                                                RandomHeroesIndex;                                		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Cost;                                             		// 0x0004 (0x0004) [0x0000000000000000]              
	class AH7AdventureArmy*                            Army;                                             		// 0x0008 (0x0008) [0x0000000000000000]              
	unsigned long                                      IsNew : 1;                                        		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      IsAvailable : 1;                                  		// 0x0010 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.TownHeroesPoolData
// 0x00000018
struct FTownHeroesPoolData
{
//	 vPoperty_Size=2
	class AH7Town*                                     TownOwner;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	TArray< struct FRecruitHeroData >                  HeroesPool;                                       		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7PlayerProperties
// 0x00000009
struct FH7PlayerProperties
{
//	 vPoperty_Size=2
	class AH7Player*                                   mPlayer;                                          		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mTeam;                                            		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.AiReceptivityEntry
// 0x00000020
struct FAiReceptivityEntry
{
//	 vPoperty_Size=8
	float                                              statHitpoints;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              statInitiative;                                   		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              statAttack;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              statDefense;                                      		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              statLeadership;                                   		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              statDestiny;                                      		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              statDamage;                                       		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              statMovement;                                     		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.AiReceptivityTable
// 0x00000080
struct FAiReceptivityTable
{
//	 vPoperty_Size=4
	struct FAiReceptivityEntry                         recEntryFighter;                                  		// 0x0000 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAiReceptivityEntry                         recEntryRogue;                                    		// 0x0020 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAiReceptivityEntry                         recEntryShooter;                                  		// 0x0040 (0x0020) [0x0000000000000001]              ( CPF_Edit )
	struct FAiReceptivityEntry                         recEntryMage;                                     		// 0x0060 (0x0020) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.PlayerHeroesPoolData
// 0x00000018
struct FPlayerHeroesPoolData
{
//	 vPoperty_Size=2
	class AH7Player*                                   PlayerOwner;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	TArray< struct FRecruitHeroData >                  HeroesPool;                                       		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.ResourceStockpile
// 0x00000010
struct FResourceStockpile
{
//	 vPoperty_Size=3
	class UH7Resource*                                 Type;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Quantity;                                         		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Income;                                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.RandomHeroData
// 0x0000000C
struct FRandomHeroData
{
//	 vPoperty_Size=2
	class AH7EditorHero*                               HeroArchetype;                                    		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned long                                      IsBeingUsed : 1;                                  		// 0x0008 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7MinePlunderCounter
// 0x0000000D
struct FH7MinePlunderCounter
{
//	 vPoperty_Size=3
	class AH7Mine*                                     Mine;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Counter;                                          		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      PlayerID;                                         		// 0x000C (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AbilityTrackingData
// 0x00000038
struct FH7AbilityTrackingData
{
//	 vPoperty_Size=5
	struct FString                                     AbilityName;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     CasterName;                                       		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                NumberOfCasts;                                    		// 0x0020 (0x0004) [0x0000000000000000]              
	struct FString                                     CasterPlayerFaction;                              		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                CasterPlayerPosition;                             		// 0x0034 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7LevelUpData
// 0x0000000C
struct FH7LevelUpData
{
//	 vPoperty_Size=3
	int                                                Level;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      Stat;                                             		// 0x0004 (0x0001) [0x0000000000000000]              
	int                                                Value;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CaravanRoute
// 0x00000010
struct FH7CaravanRoute
{
//	 vPoperty_Size=2
	class AH7AreaOfControlSiteLord*                    sourceLord;                                       		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7AreaOfControlSiteLord*                    targetLord;                                       		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TownBuffToAoCData
// 0x00000018
struct FH7TownBuffToAoCData
{
//	 vPoperty_Size=3
	class UH7TownBuilding*                             mBuilding;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseBuff*                                 mBuff;                                            		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7Creature*                                 mCreature;                                        		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SiteVisitData
// 0x00000009
struct FH7SiteVisitData
{
//	 vPoperty_Size=2
	class AH7VisitableSite*                            Site;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      PlayerID;                                         		// 0x0008 (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TownBuildingVisitData
// 0x00000011
struct FH7TownBuildingVisitData
{
//	 vPoperty_Size=3
	class UH7TownBuilding*                             Building;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	class AH7Town*                                     Town;                                             		// 0x0008 (0x0008) [0x0000000000000000]              
	unsigned char                                      PlayerID;                                         		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RewardData
// 0x00000010
struct FH7RewardData
{
//	 vPoperty_Size=4
	class UH7HeroItem*                                 Item;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      ItemTier;                                         		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      ItemType;                                         		// 0x0009 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UniqueOffering : 1;                               		// 0x000C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7MultiRewardData
// 0x00000010
struct FH7MultiRewardData
{
//	 vPoperty_Size=1
	TArray< struct FH7RewardData >                     RewardData;                                       		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CreatureArray
// 0x00000010
struct FH7CreatureArray
{
//	 vPoperty_Size=1
	TArray< class AH7Creature* >                       Creatures;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CreatureList
// 0x00000050
struct FH7CreatureList
{
//	 vPoperty_Size=1
	struct FH7CreatureArray                            Creatures[ 0x5 ];                                 		// 0x0000 (0x0050) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7FactionCreatureData
// 0x00000058
struct FH7FactionCreatureData
{
//	 vPoperty_Size=2
	class UH7Faction*                                  Faction;                                          		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FH7CreatureList                             CreatureList;                                     		// 0x0008 (0x0050) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.SavegameBuffStruct
// 0x00000028
struct FSavegameBuffStruct
{
//	 vPoperty_Size=4
	struct FString                                     BuffReference;                                    		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                CasterReferenceID;                                		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FString                                     SourceReference;                                  		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                RemainingDuration;                                		// 0x0024 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SkillProxy
// 0x00000024
struct FH7SkillProxy
{
//	 vPoperty_Size=5
	struct FString                                     SkillArchRef;                                     		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	class UH7Skill*                                    SkillArch;                                        		// 0x0010 (0x0008) [0x0000000000000000]              
	int                                                SkillRank;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	unsigned long                                      UltimateRequirment : 1;                           		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                SkillID;                                          		// 0x0020 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.AdventureMapCellCoords
// 0x0000000C
struct FAdventureMapCellCoords
{
//	 vPoperty_Size=2
	struct FIntPoint                                   Coordinates;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                GridIndex;                                        		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.SavegameHeroStruct
// 0x000001C0
struct FSavegameHeroStruct
{
//	 vPoperty_Size=38
	unsigned long                                      HasData : 1;                                      		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                Level;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                XP;                                               		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                Spirit;                                           		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                Magic;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                AttackBase;                                       		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                DefenseBase;                                      		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                ArcaneKnowledgeBase;                              		// 0x001C (0x0004) [0x0000000000000000]              
	float                                              CurrentMovementPoints;                            		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                CurrentMana;                                      		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                MaxManaBonus;                                     		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                ManaRegenBase;                                    		// 0x002C (0x0004) [0x0000000000000000]              
	int                                                SkillPoints;                                      		// 0x0030 (0x0004) [0x0000000000000000]              
	unsigned long                                      IsHero : 1;                                       		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                PlayerNumber;                                     		// 0x0038 (0x0004) [0x0000000000000000]              
	int                                                Id;                                               		// 0x003C (0x0004) [0x0000000000000000]              
	unsigned long                                      HasTearOfAsha : 1;                                		// 0x0040 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      HasFinishedTurn : 1;                              		// 0x0040 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      HasCastedSpellThisTurn : 1;                       		// 0x0040 (0x0004) [0x0000000000000000] [0x00000004] 
	class UH7HeroEquipment*                            Equipment;                                        		// 0x0044 (0x0008) [0x0000000000000000]              
	class UH7Inventory*                                Inventory;                                        		// 0x004C (0x0008) [0x0000000000000000]              
	TArray< struct FH7SkillProxy >                     SkillRefs;                                        		// 0x0054 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                SkillPointsSpend;                                 		// 0x0064 (0x0004) [0x0000000000000000]              
	TArray< struct FString >                           LearnedAbilityRefs;                               		// 0x0068 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned long                                      RandomIsReset : 1;                                		// 0x0078 (0x0004) [0x0000000000000000] [0x00000001] 
	TArray< struct FString >                           RandomPickedSkillRefs;                            		// 0x007C (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           RandomPickedAbilityRefs;                          		// 0x008C (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           PickableSkillPoolRefs;                            		// 0x009C (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< int >                                      WeightForSkills;                                  		// 0x00AC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           PickableAbilityPoolRefs;                          		// 0x00BC (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< int >                                      WeightForAbilities;                               		// 0x00CC (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UH7BuffManager*                              BuffManager;                                      		// 0x00DC (0x0008) [0x0000000000000000]              
	TArray< struct FString >                           QuickBarCombatRefs;                               		// 0x00E4 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           QuickBarAdventureRefs;                            		// 0x00F4 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	class AH7Town*                                     GovernedTown;                                     		// 0x0104 (0x0008) [0x0000000000000000]              
	unsigned long                                      AiHibernation : 1;                                		// 0x010C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      AiAggressiveness;                                 		// 0x0110 (0x0001) [0x0000000000000000]              
	unsigned char                                      ScriptedBehaviour;                                		// 0x0111 (0x0001) [0x0000000000000000]              
	unsigned char                                      ControlType;                                      		// 0x0112 (0x0001) [0x0000000000000000]              
	unsigned char                                      HeroAiRole;                                       		// 0x0113 (0x0001) [0x0000000000000000]              
	class AH7VisitableSite*                            HomeSite;                                         		// 0x0114 (0x0008) [0x0000000000000000]              
	unsigned long                                      IsPendingLevel : 1;                               		// 0x011C (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                ScoutingRadius;                                   		// 0x0120 (0x0004) [0x0000000000000000]              
	unsigned long                                      CanScout : 1;                                     		// 0x0124 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      IsAlliedWithEverybody : 1;                        		// 0x0124 (0x0004) [0x0000000000000000] [0x00000002] 
	float                                              TerrainCostModifier;                              		// 0x0128 (0x0004) [0x0000000000000000]              
	TArray< struct FAdventureMapCellCoords >           CurrentPath;                                      		// 0x012C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FAdventureMapCellCoords                     LastCellMovement;                                 		// 0x013C (0x000C) [0x0000000000000000]              
	class UH7AbilityManager*                           AbilityManager;                                   		// 0x0148 (0x0008) [0x0000000000000000]              
	TArray< struct FString >                           HeroSpellArchetypeReferences;                     		// 0x0150 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< int >                                      HeroSpellIDs;                                     		// 0x0160 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           HeroVolatileSpellArchetypeReferences;             		// 0x0170 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< int >                                      HeroVolatileSpellIDs;                             		// 0x0180 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           HeroAbilityArchetypeReferences;                   		// 0x0190 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	TArray< int >                                      HeroAbilityIDs;                                   		// 0x01A0 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     OverwriteIconRef;                                 		// 0x01B0 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.SkillReference
// 0x00000011
struct FSkillReference
{
//	 vPoperty_Size=2
	struct FString                                     PathName;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      SkillRank;                                        		// 0x0010 (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RelativeWeightData
// 0x0000001C
struct FH7RelativeWeightData
{
//	 vPoperty_Size=7
	int                                                SkillWeightNovice;                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                SkillWeightExpert;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                SkillWeightMaster;                                		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                AbilityWeightNovice;                              		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                AbilityWeightExpert;                              		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                AbilityWeightMaster;                              		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                AbilityWeightGrandmaster;                         		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7LobbyDataGameSettings
// 0x00000029
struct FH7LobbyDataGameSettings
{
//	 vPoperty_Size=c
	unsigned long                                      mSpectatorMode : 1;                               		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	float                                              mGameSpeedAdventure;                              		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              mGameSpeedAdventureAI;                            		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              mGameSpeedCombat;                                 		// 0x000C (0x0004) [0x0000000000000000]              
	unsigned char                                      mTimerCombat;                                     		// 0x0010 (0x0001) [0x0000000000000000]              
	unsigned long                                      mSimTurns : 1;                                    		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      mForceQuickCombat;                                		// 0x0018 (0x0001) [0x0000000000000000]              
	unsigned long                                      mUseRandomSkillSystem : 1;                        		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mTeamsCanTrade : 1;                               		// 0x001C (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned char                                      mDifficulty;                                      		// 0x0020 (0x0001) [0x0000000000000000]              
	struct FH7DifficultyParameters                     mDifficultyParameters;                            		// 0x0024 (0x0004) [0x0000000000000000]              
	unsigned char                                      mTimerAdv;                                        		// 0x0028 (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.PlayerLobbySelectedSettings
// 0x00000060
struct FPlayerLobbySelectedSettings
{
//	 vPoperty_Size=d
	unsigned char                                      mSlotState;                                       		// 0x0000 (0x0001) [0x0000000000000000]              
	struct FString                                     mName;                                            		// 0x0004 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned char                                      mAIDifficulty;                                    		// 0x0014 (0x0001) [0x0000000000000000]              
	unsigned char                                      mTeam;                                            		// 0x0015 (0x0001) [0x0000000000000000]              
	class AH7EditorHero*                               mStartHero;                                       		// 0x0018 (0x0008) [0x0000000000000000]              
	struct FString                                     mStartHeroRef;                                    		// 0x0020 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned char                                      mColor;                                           		// 0x0030 (0x0001) [0x0000000000000000]              
	class UH7Faction*                                  mFaction;                                         		// 0x0034 (0x0008) [0x0000000000000000]              
	struct FString                                     mFactionRef;                                      		// 0x003C (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                mStartBonusIndex;                                 		// 0x004C (0x0004) [0x0000000000000000]              
	unsigned char                                      mPosition;                                        		// 0x0050 (0x0001) [0x0000000000000000]              
	unsigned long                                      mIsReady : 1;                                     		// 0x0054 (0x0004) [0x0000000000000000] [0x00000001] 
	class AH7EditorArmy*                               mArmy;                                            		// 0x0058 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7LobbyData
// 0x00000374
struct FH7LobbyData
{
//	 vPoperty_Size=8
	struct FH7LobbyDataMapSettings                     mMapSettings;                                     		// 0x0000 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FH7LobbyDataGameSettings                    mGameSettings;                                    		// 0x0020 (0x002C) [0x0000000000000000]              
	struct FPlayerLobbySelectedSettings                mPlayers[ 0x8 ];                                  		// 0x004C (0x0300) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     mSaveGameFileName;                                		// 0x034C (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mSaveGameUserName;                                		// 0x035C (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                mSaveGameCheckSum;                                		// 0x036C (0x0004) [0x0000000000000000]              
	unsigned long                                      mIsInitialized : 1;                               		// 0x0370 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mIsDuel : 1;                                      		// 0x0370 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CustomResource
// 0x0000000C
struct FH7CustomResource
{
//	 vPoperty_Size=2
	class UH7Resource*                                 Type;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Amount;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.MapInfoPlayerProperty
// 0x000000C0
struct FMapInfoPlayerProperty
{
//	 vPoperty_Size=18
	unsigned char                                      mSlot;                                            		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     mName;                                            		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mUseCustomName : 1;                               		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class UH7GlobalName*                               mGlobalName;                                      		// 0x0018 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mAIType;                                          		// 0x0020 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mAIDifficulty;                                    		// 0x0021 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mInitActive : 1;                                  		// 0x0024 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      mTeam;                                            		// 0x0028 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class AH7EditorHero*                               mStartHero;                                       		// 0x002C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMaxLevel;                                        		// 0x0034 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mColor;                                           		// 0x0038 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mDiscoveredFromStart : 1;                         		// 0x003C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mUseCustomStartingResource : 1;                   		// 0x003C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	struct FH7CustomResource                           mCustomStartingGold;                              		// 0x0040 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7CustomResource                           mCustomStartingWood;                              		// 0x004C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7CustomResource                           mCustomStartingOre;                               		// 0x0058 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7CustomResource                           mCustomStartingDragonSteel;                       		// 0x0064 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7CustomResource                           mCustomStartingShadowSteel;                       		// 0x0070 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7CustomResource                           mCustomStartingStarSilver;                        		// 0x007C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7CustomResource                           mCustomStartingDragonBloodCrystal;                		// 0x0088 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7Faction* >                        mForbiddenFactions;                               		// 0x0094 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class AH7EditorHero* >                     mForbiddenHeroes;                                 		// 0x00A4 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mPlayerStartAvailable : 1;                        		// 0x00B4 (0x0004) [0x0000000000020001] [0x00000001] ( CPF_Edit | CPF_EditConst )
	class UH7Faction*                                  mEditorFaction;                                   		// 0x00B8 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7BattleSiteArmySetupData
// 0x0000001C
struct FH7BattleSiteArmySetupData
{
//	 vPoperty_Size=5
	class AH7Creature*                                 Creature;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Income;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Reserve;                                          		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Capacity;                                         		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector2D                                   Position;                                         		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7MultiArmySetupData
// 0x00000010
struct FH7MultiArmySetupData
{
//	 vPoperty_Size=1
	TArray< struct FH7BattleSiteArmySetupData >        FactionArmy;                                      		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.MapSizeDefinition
// 0x0000000C
struct FMapSizeDefinition
{
//	 vPoperty_Size=3
	unsigned char                                      MapSize;                                          		// 0x0000 (0x0001) [0x0000000000000000]              
	int                                                Width;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                Height;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.QuickCombatImpact
// 0x0000000C
struct FQuickCombatImpact
{
//	 vPoperty_Size=4
	unsigned char                                      Substitute;                                       		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                Intensity;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      IsUpgraded : 1;                                   		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      IsNegative : 1;                                   		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7QuickCombatHero
// 0x00000060
struct FH7QuickCombatHero
{
//	 vPoperty_Size=16
	unsigned long                                      IsHero : 1;                                       		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                DamageMin;                                        		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                DamageMax;                                        		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                Attack;                                           		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                Defense;                                          		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                Luck;                                             		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                Morale;                                           		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                Mana;                                             		// 0x001C (0x0004) [0x0000000000000000]              
	unsigned long                                      MadeTurn : 1;                                     		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      AllowedToCast : 1;                                		// 0x0020 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      HasWarcry : 1;                                    		// 0x0020 (0x0004) [0x0000000000000000] [0x00000004] 
	int                                                WarcryRank;                                       		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                WarfareRank;                                      		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                AmountOfWarcries;                                 		// 0x002C (0x0004) [0x0000000000000000]              
	unsigned long                                      HasWarlord : 1;                                   		// 0x0030 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      HasArtilleryBarrage : 1;                          		// 0x0030 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      HasPerfectWarfare : 1;                            		// 0x0030 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      HasSiegeWarfare : 1;                              		// 0x0030 (0x0004) [0x0000000000000000] [0x00000008] 
	TArray< class UH7HeroAbility* >                    Spells;                                           		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< float >                                    SpellValues;                                      		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              SumSpellValue;                                    		// 0x0054 (0x0004) [0x0000000000000000]              
	class AH7EditorHero*                               Hero;                                             		// 0x0058 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7QuickCombatStack
// 0x00000054
struct FH7QuickCombatStack
{
//	 vPoperty_Size=1a
	unsigned char                                      StackType;                                        		// 0x0000 (0x0001) [0x0000000000000000]              
	unsigned long                                      HybridSupportDone : 1;                            		// 0x0004 (0x0004) [0x0000000000000000] [0x00000001] 
	class AH7EditorWarUnit*                            BaseWarUnit;                                      		// 0x0008 (0x0008) [0x0000000000000000]              
	class UH7BaseCreatureStack*                        BaseStack;                                        		// 0x0010 (0x0008) [0x0000000000000000]              
	int                                                StackSize;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                HitPoints;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                HitPointsSingle;                                  		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                Initiative;                                       		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                DamageMin;                                        		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                DamageMax;                                        		// 0x002C (0x0004) [0x0000000000000000]              
	int                                                Attack;                                           		// 0x0030 (0x0004) [0x0000000000000000]              
	int                                                Defense;                                          		// 0x0034 (0x0004) [0x0000000000000000]              
	unsigned char                                      Range;                                            		// 0x0038 (0x0001) [0x0000000000000000]              
	int                                                Luck;                                             		// 0x003C (0x0004) [0x0000000000000000]              
	int                                                Morale;                                           		// 0x0040 (0x0004) [0x0000000000000000]              
	int                                                Movement;                                         		// 0x0044 (0x0004) [0x0000000000000000]              
	int                                                MovedTiles;                                       		// 0x0048 (0x0004) [0x0000000000000000]              
	unsigned char                                      MovementType;                                     		// 0x004C (0x0001) [0x0000000000000000]              
	unsigned long                                      HasMeleePenalty : 1;                              		// 0x0050 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      IsMoraleTurn : 1;                                 		// 0x0050 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      IsAllowedToMorale : 1;                            		// 0x0050 (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned long                                      CanMorale : 1;                                    		// 0x0050 (0x0004) [0x0000000000000000] [0x00000008] 
	unsigned long                                      CanRetaliate : 1;                                 		// 0x0050 (0x0004) [0x0000000000000000] [0x00000010] 
	unsigned long                                      IsDead : 1;                                       		// 0x0050 (0x0004) [0x0000000000000000] [0x00000020] 
	unsigned long                                      IsAttacker : 1;                                   		// 0x0050 (0x0004) [0x0000000000000000] [0x00000040] 
	unsigned long                                      HitByMelee : 1;                                   		// 0x0050 (0x0004) [0x0000000000000000] [0x00000080] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ArtifactCollection
// 0x00000010
struct FH7ArtifactCollection
{
//	 vPoperty_Size=1
	TArray< class UH7HeroItem* >                       Artifacts;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ConditionProgress
// 0x00000018
struct FH7ConditionProgress
{
//	 vPoperty_Size=3
	float                                              CurrentProgress;                                  		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              MaximumProgress;                                  		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FString                                     ProgressText;                                     		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.NegotiationData
// 0x0000000C
struct FNegotiationData
{
//	 vPoperty_Size=2
	class AH7AdventureArmy*                            Army;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                NegotiationResult;                                		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.MapInfoArtifactMapData
// 0x0000000C
struct FMapInfoArtifactMapData
{
//	 vPoperty_Size=2
	class UH7HeroItem*                                 mHeroItem;                                        		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mIsEnabled : 1;                                   		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ChainEffectPair
// 0x00000014
struct FH7ChainEffectPair
{
//	 vPoperty_Size=3
	class AH7CreatureStack*                            A;                                                		// 0x0000 (0x0008) [0x0000000000000000]              
	class AH7CreatureStack*                            B;                                                		// 0x0008 (0x0008) [0x0000000000000000]              
	int                                                Distance;                                         		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TargetableArray
// 0x00000010
struct FH7TargetableArray
{
//	 vPoperty_Size=1
	TArray< class UH7IEffectTargetable* >              Targets;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.SkillListData
// 0x00000020
struct FSkillListData
{
//	 vPoperty_Size=2
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     ref;                                              		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.SpellListData
// 0x00000020
struct FSpellListData
{
//	 vPoperty_Size=2
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     ref;                                              		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AffectedPlayers
// 0x00000004
struct FH7AffectedPlayers
{
//	 vPoperty_Size=8
	unsigned long                                      Player1 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      Player2 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      Player3 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      Player4 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      Player5 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      Player6 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      Player7 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned long                                      Player8 : 1;                                      		// 0x0000 (0x0004) [0x0000000000000001] [0x00000080] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7StackStrengthParams
// 0x00000014
struct FH7StackStrengthParams
{
//	 vPoperty_Size=4
	int                                                StackSize;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              CreaturePower;                                    		// 0x0004 (0x0004) [0x0000000000000000]              
	unsigned long                                      IsUpgrade : 1;                                    		// 0x0008 (0x0004) [0x0000000000000000] [0x00000001] 
	class UH7Faction*                                  Faction;                                          		// 0x000C (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ArmyStrengthParams
// 0x00000020
struct FH7ArmyStrengthParams
{
//	 vPoperty_Size=4
	int                                                HeroLevel;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	class UH7Faction*                                  HeroFaction;                                      		// 0x0004 (0x0008) [0x0000000000000000]              
	unsigned char                                      PlayerID;                                         		// 0x000C (0x0001) [0x0000000000000000]              
	TArray< struct FH7StackStrengthParams >            StackStrengths;                                   		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CreatureCounter
// 0x0000000E
struct FH7CreatureCounter
{
//	 vPoperty_Size=4
	int                                                Counter;                                          		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class AH7Creature*                                 Creature;                                         		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      PlayerID;                                         		// 0x000C (0x0001) [0x0000000000000000]              
	unsigned char                                      EnemyID;                                          		// 0x000D (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7UnitCounter
// 0x0000000C
struct FH7UnitCounter
{
//	 vPoperty_Size=2
	int                                                Counter;                                          		// 0x0000 (0x0004) [0x0000000000000000]              
	class AH7Unit*                                     Unit;                                             		// 0x0004 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SetBonus
// 0x0000001C
struct FH7SetBonus
{
//	 vPoperty_Size=3
	int                                                NumberOfItems;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FH7MeModifiesStat >                 SetBonusStat;                                     		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class UH7HeroAbility*                              SetBonusAbility;                                  		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7EditorSiegeDecoration
// 0x00000024
struct FH7EditorSiegeDecoration
{
//	 vPoperty_Size=5
	unsigned long                                      UseWallLevel : 1;                                 		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class AH7SiegeMapDecoration*                       MeshLevel1;                                       		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7SiegeMapDecoration*                       MeshLevel2;                                       		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7SiegeMapDecoration*                       MeshLevel3;                                       		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7SiegeMapDecoration*                       MeshLevel4;                                       		// 0x001C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SiegeTownData
// 0x00000044
struct FH7SiegeTownData
{
//	 vPoperty_Size=a
	class UH7Faction*                                  Faction;                                          		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      HasShootingTowers : 1;                            		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      HasMoats : 1;                                     		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	int                                                WallAndGateLevel;                                 		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                TownLevel;                                        		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class AH7CombatMapTower*                           SiegeObstacleTower;                               		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7CombatMapWall*                            SiegeObstacleWall;                                		// 0x001C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7CombatMapMoat*                            SiegeObstacleMoat;                                		// 0x0024 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7CombatMapGate*                            SiegeObstacleGate;                                		// 0x002C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FH7EditorSiegeDecoration >          SiegeDecorationList;                              		// 0x0034 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TooltipMultiplier
// 0x0000001C
struct FH7TooltipMultiplier
{
//	 vPoperty_Size=4
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000000]              
	struct FString                                     Name;                                             		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              Value;                                            		// 0x0014 (0x0004) [0x0000000000000000]              
	unsigned long                                      addToFinal : 1;                                   		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.CRData
// 0x00000078
struct FCRData
{
//	 vPoperty_Size=16
	float                                              mDamageLow;                                       		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              mDamageHigh;                                      		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                mDamage;                                          		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                mRedirectedDamage;                                		// 0x000C (0x0004) [0x0000000000000000]              
	unsigned long                                      mIsRedirect : 1;                                  		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mIsFakeRedirect : 1;                              		// 0x0010 (0x0004) [0x0000000000000000] [0x00000002] 
	float                                              mDamageModifier;                                  		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                mKillsLow;                                        		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                mKillsHigh;                                       		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                mKills;                                           		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                mAttackPower;                                     		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                mDefensePower;                                    		// 0x0028 (0x0004) [0x0000000000000000]              
	unsigned long                                      mIsCovered : 1;                                   		// 0x002C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mMissed : 1;                                      		// 0x002C (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      mTriggerEvents : 1;                               		// 0x002C (0x0004) [0x0000000000000000] [0x00000004] 
	unsigned char                                      mSchoolType;                                      		// 0x0030 (0x0001) [0x0000000000000000]              
	unsigned long                                      mSchoolTypeSet : 1;                               		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mConstDamageRange : 1;                            		// 0x0034 (0x0004) [0x0000000000000000] [0x00000002] 
	TArray< struct FH7TooltipMultiplier >              mMultipliers;                                     		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7Effect* >                         mEffects;                                         		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7Effect* >                         mTriggeredEffects;                                		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< int >                                      mRedirectLinks;                                   		// 0x0068 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SimDuration
// 0x0000000C
struct FH7SimDuration
{
//	 vPoperty_Size=2
	class UH7Effect*                                   Effect;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                NewDuration;                                      		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CellPathData
// 0x00000010
struct FH7CellPathData
{
//	 vPoperty_Size=4
	float                                              mPathfinderDistance;                              		// 0x0000 (0x0004) [0x0000000000000000]              
	class UH7CombatMapCell*                            mPathfinderPrevious;                              		// 0x0004 (0x0008) [0x0000000000000000]              
	unsigned long                                      IsClosed : 1;                                     		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      CalculatedOnce : 1;                               		// 0x000C (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7PathfinerGridColumns
// 0x00000010
struct FH7PathfinerGridColumns
{
//	 vPoperty_Size=1
	TArray< struct FH7CellPathData >                   Row;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ResourceProbability
// 0x0000001C
struct FH7ResourceProbability
{
//	 vPoperty_Size=2
	struct FH7ResourceQuantity                         mResource;                                        		// 0x0000 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	int                                                mProbability;                                     		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AuraInstance
// 0x00000030
struct FH7AuraInstance
{
//	 vPoperty_Size=4
	class UH7BaseAbility*                              mAuraAbility;                                     		// 0x0000 (0x0008) [0x0000000000000000]              
	class UH7UnitSnapShot*                             mAuraCaster;                                      		// 0x0008 (0x0008) [0x0000000000000000]              
	TArray< struct FIntPoint >                         mAffectedCells;                                   		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7IEffectTargetable* >              mAffectedTargets;                                 		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ConeStruct
// 0x00000014
struct FH7ConeStruct
{
//	 vPoperty_Size=4
	float                                              mAngle;                                           		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mRange;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UStaticMeshComponent*                        mPreview;                                         		// 0x0008 (0x0008) [0x0000000004080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_EditInline )
	unsigned long                                      mDebug : 1;                                       		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TriggerStruct
// 0x0000000C
struct FH7TriggerStruct
{
//	 vPoperty_Size=3
	unsigned char                                      mTriggerType;                                     		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                mChance;                                          		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mUseLuckRoll : 1;                                 		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CasterConditionStruct
// 0x000000BC
struct FH7CasterConditionStruct
{
//	 vPoperty_Size=2a
	unsigned long                                      UseUnitType : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      UOperation;                                       		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnitType;                                         		// 0x0005 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      CasterIsOnCombatMap : 1;                          		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      CheckCausOfEvent : 1;                             		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      CasterIsCauserOfEvent : 1;                        		// 0x0008 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      UseHasAbility : 1;                                		// 0x0008 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned char                                      AbilityOp;                                        		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseAbility*                              HasAbility;                                       		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseHasBuff : 1;                                   		// 0x0018 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      BuffOp;                                           		// 0x001C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseBuff*                                 HasBuff;                                          		// 0x0020 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseOwner : 1;                                     		// 0x0028 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseHasBuffs : 1;                                  		// 0x0028 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      BuffsOp;                                          		// 0x002C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7BaseBuff* >                       HasBuffs;                                         		// 0x0030 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseBuffsOwner : 1;                                		// 0x0040 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseHasKill : 1;                                   		// 0x0040 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      KillOp;                                           		// 0x0044 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                Kills;                                            		// 0x0048 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseWhenDead : 1;                                  		// 0x004C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseCHHasAbility : 1;                              		// 0x004C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      CHAbilityOp;                                      		// 0x0050 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseAbility*                              HasCHAbilty;                                      		// 0x0054 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseCanSummonShip : 1;                             		// 0x005C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseCheckCasterIsDead : 1;                         		// 0x005C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      ShouldCasterBeDead : 1;                           		// 0x005C (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      UseCheckCasterMoved : 1;                          		// 0x005C (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      ShouldCasterHaveMoved : 1;                        		// 0x005C (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      UseCheckPreparedAbility : 1;                      		// 0x005C (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned char                                      UPAOperation;                                     		// 0x0060 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7BaseAbility* >                    UPAAbilities;                                     		// 0x0064 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseCheckPreparedAbilitySchool : 1;                		// 0x0074 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      UPASOperation;                                    		// 0x0078 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            UPASSchools;                                      		// 0x007C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UsePreparedAbilityTags : 1;                       		// 0x008C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      PATagOperation;                                   		// 0x0090 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            PAAttackTags;                                     		// 0x0094 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseCheckTownPortalReady : 1;                      		// 0x00A4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseCheckCasterTile : 1;                           		// 0x00A4 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      CCTileOperation;                                  		// 0x00A8 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FName >                             CCTileTypes;                                      		// 0x00AC (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7StatCondition
// 0x0000000D
struct FH7StatCondition
{
//	 vPoperty_Size=5
	unsigned char                                      Stat1;                                            		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      OperationType;                                    		// 0x0001 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      WithValue : 1;                                    		// 0x0004 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              Value;                                            		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Stat2;                                            		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ConditionStructExtendedTarget
// 0x00000118
struct FH7ConditionStructExtendedTarget
{
//	 vPoperty_Size=47
	unsigned long                                      NextUnitInQueue : 1;                              		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseUnitType : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      UOperation;                                       		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnitType;                                         		// 0x0005 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseUnitTypes : 1;                                 		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      UTOperation;                                      		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            UnitTypes;                                        		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseUnit : 1;                                      		// 0x0020 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      UAOperation;                                      		// 0x0024 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UAAlignment;                                      		// 0x0025 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseCreatureTier : 1;                              		// 0x0028 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      CTTOperation;                                     		// 0x002C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      CTTier;                                           		// 0x002D (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseCreatureSize : 1;                              		// 0x0030 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      CSOperation;                                      		// 0x0034 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      CSSize;                                           		// 0x0035 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseMovementType : 1;                              		// 0x0038 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      MovementOp;                                       		// 0x003C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      MovementType;                                     		// 0x003D (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseMagicSchool : 1;                               		// 0x0040 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      UMagicSchoolOp;                                   		// 0x0044 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UMagicSchoolType;                                 		// 0x0045 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UnitIsRanged : 1;                                 		// 0x0048 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UnitHasRange : 1;                                 		// 0x0048 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      UnitHasBuff : 1;                                  		// 0x0048 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned char                                      BuffOp;                                           		// 0x004C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseBuff*                                 CTBuff;                                           		// 0x0050 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UnitHasBuffs : 1;                                 		// 0x0058 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      BuffsOp;                                          		// 0x005C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7BaseBuff* >                       CTBuffs;                                          		// 0x0060 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseConditionStat : 1;                             		// 0x0070 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FH7StatCondition                            StatCondition;                                    		// 0x0074 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseHasAbility : 1;                                		// 0x0084 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      AbilityOp;                                        		// 0x0088 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseAbility*                              HasAbility;                                       		// 0x008C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseHasAbilities : 1;                              		// 0x0094 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      AbilitiesOp;                                      		// 0x0098 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      AbilitiesLogic;                                   		// 0x0099 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7BaseAbility* >                    HasAbilities;                                     		// 0x009C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseTHHasSkill : 1;                                		// 0x00AC (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      THSkillOp;                                        		// 0x00B0 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      THHasSkill;                                       		// 0x00B1 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      CheckForBuilding : 1;                             		// 0x00B4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      BuildingIsBuilt : 1;                              		// 0x00B4 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	class UH7TownBuilding*                             ThisBuilding;                                     		// 0x00B8 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      ProducesResources : 1;                            		// 0x00C0 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class UH7Resource*                                 Resource;                                         		// 0x00C4 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      ProducesUnits : 1;                                		// 0x00CC (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class AH7Unit*                                     Unit;                                             		// 0x00D0 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      ProducesTier : 1;                                 		// 0x00D8 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      Tier;                                             		// 0x00DC (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      ExcludeOwner : 1;                                 		// 0x00E0 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      TargetDead : 1;                                   		// 0x00E0 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      CasterMustBeAdjacent : 1;                         		// 0x00E0 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      CasterMustBeUnder : 1;                            		// 0x00E0 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      OwnerMustBeAdjacent : 1;                          		// 0x00E0 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      HPTargetDamaged : 1;                              		// 0x00E0 (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      HPCheckForPercentage : 1;                         		// 0x00E0 (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned char                                      HPPercentageOperator;                             		// 0x00E4 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                HPDamagePercentage;                               		// 0x00E8 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      MagicSynergy : 1;                                 		// 0x00EC (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      TargetHasAdjacentCreatures : 1;                   		// 0x00EC (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      CheckAdjacentCreatureAlignment : 1;               		// 0x00EC (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned char                                      AdjacentCreatureAlignmentOp;                      		// 0x00F0 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      AdjacentCreatureAlignment;                        		// 0x00F1 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseCreatureTypes : 1;                             		// 0x00F4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	TArray< class AH7Creature* >                       CreatureTypes;                                    		// 0x00F8 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseTargetAreaUnoccupied : 1;                      		// 0x0108 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FIntPoint                                   TargetDimensions;                                 		// 0x010C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      CheckSameAoc : 1;                                 		// 0x0114 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      IsInSameAoc : 1;                                  		// 0x0114 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ConditionStructExtendAttack
// 0x000000A4
struct FH7ConditionStructExtendAttack
{
//	 vPoperty_Size=29
	unsigned long                                      UseAttackerUnitType : 1;                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      AUTOperation;                                     		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            AUTUnitTypes;                                     		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseAttackType : 1;                                		// 0x0018 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      ATOperation;                                      		// 0x001C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      ATSpellSchool;                                    		// 0x001D (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseAttackerSize : 1;                              		// 0x0020 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseDefenderInstead : 1;                           		// 0x0020 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      ASOperation;                                      		// 0x0024 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      ASize;                                            		// 0x0025 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseFlankingType : 1;                              		// 0x0028 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      FlankingOperation;                                		// 0x002C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      FlankingType;                                     		// 0x002D (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseAttackTag : 1;                                 		// 0x0030 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      AttackTagOperation;                               		// 0x0034 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            ATAttackTag;                                      		// 0x0038 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseAttackAction : 1;                              		// 0x0048 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      Action;                                           		// 0x004C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseAttackActions : 1;                             		// 0x0050 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	TArray< unsigned char >                            Actions;                                          		// 0x0054 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseAttackInitiator : 1;                           		// 0x0064 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      InitiatorIsSelf : 1;                              		// 0x0064 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      UseAttackInitiatorBuff : 1;                       		// 0x0064 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      InitiatorIsBuffOwner : 1;                         		// 0x0064 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      CheckIfDirectAttack : 1;                          		// 0x0064 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      IsDirectAttack : 1;                               		// 0x0064 (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      UseAttackerAlignment : 1;                         		// 0x0064 (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned char                                      UAOperation;                                      		// 0x0068 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UAAlignment;                                      		// 0x0069 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseDefenderAlignment : 1;                         		// 0x006C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      UDOperation;                                      		// 0x0070 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UDAlignment;                                      		// 0x0071 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      UseRetaliation : 1;                               		// 0x0074 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      WillRetaliate : 1;                                		// 0x0074 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      UnitHasBuffs : 1;                                 		// 0x0074 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned char                                      BuffsOp;                                          		// 0x0078 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7BaseBuff* >                       CTBuffs;                                          		// 0x007C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      UseHasAbilities : 1;                              		// 0x008C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      AbilitiesOp;                                      		// 0x0090 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      AbilitiesLogic;                                   		// 0x0091 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7BaseAbility* >                    HasAbilities;                                     		// 0x0094 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ConditionStruct
// 0x0000027C
struct FH7ConditionStruct
{
//	 vPoperty_Size=6
	struct FH7CasterConditionStruct                    mExtededAbilityParameters;                        		// 0x0000 (0x00BC) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7ConditionStructExtendedTarget            mExtendedTargetParameters;                        		// 0x00BC (0x0118) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7ConditionStructExtendAttack              mExtendedAttackParameters;                        		// 0x01D4 (0x00A4) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mConditionTarget : 1;                             		// 0x0278 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mConditionAttack : 1;                             		// 0x0278 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      mConditionAbility : 1;                            		// 0x0278 (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7EffectProperties
// 0x000002C4
struct FH7EffectProperties
{
//	 vPoperty_Size=a
	struct FString                                     mEffectID;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mGroup;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mRank;                                            		// 0x0014 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            mTags;                                            		// 0x0018 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      mTarget;                                          		// 0x0028 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                mTargetLimit;                                     		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FH7TriggerStruct                            mTrigger;                                         		// 0x0030 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7ConditionStruct                          mConditions;                                      		// 0x003C (0x027C) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class UH7FXObject*                                 mFXS;                                             		// 0x02B8 (0x0008) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
	unsigned long                                      mDontShowInTooltip : 1;                           		// 0x02C0 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RangeValue
// 0x00000028
struct FH7RangeValue
{
//	 vPoperty_Size=4
	int                                                MinValue;                                         		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                MaxValue;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     MinValueFormular;                                 		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     MaxValueFormular;                                 		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7DurationEffect
// 0x0040(0x0304 - 0x02C4)
struct FH7DurationEffect : FH7EffectProperties
{
//	 vPoperty_Size=3
	struct FH7RangeValue                               mDuration;                                        		// 0x02C4 (0x0028) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mUseSpellScaling : 1;                             		// 0x02EC (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FH7SpellScaling                             mDurationScaling;                                 		// 0x02F0 (0x0014) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7DurationModifierEffect
// 0x0008(0x02CC - 0x02C4)
struct FH7DurationModifierEffect : FH7EffectProperties
{
//	 vPoperty_Size=2
	unsigned char                                      mCombineOperation;                                		// 0x02C4 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                mModifierValue;                                   		// 0x02C8 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AuraStructProperties
// 0x00000048
struct FH7AuraStructProperties
{
//	 vPoperty_Size=9
	int                                                mCurrentDuration;                                 		// 0x0000 (0x0004) [0x0000000000000000]              
	TArray< struct FH7EffectProperties >               mInitAuraEffects;                                 		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FH7EffectProperties >               mDestroyAuraEffects;                              		// 0x0014 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FH7DurationEffect >                 mDuration;                                        		// 0x0024 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FH7DurationModifierEffect >         mDurationModifier;                                		// 0x0034 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mUpdateOnStep : 1;                                		// 0x0044 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mForceReapply : 1;                                		// 0x0044 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mIgnoreBlocked : 1;                               		// 0x0044 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      mCanHaveCellsAsTargets : 1;                       		// 0x0044 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AuraStruct
// 0x0000004C
struct FH7AuraStruct
{
//	 vPoperty_Size=2
	struct FH7AuraStructProperties                     mAuraProperties;                                  		// 0x0000 (0x0048) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mIsAura : 1;                                      		// 0x0048 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ClassSkillData
// 0x0000000C
struct FH7ClassSkillData
{
//	 vPoperty_Size=2
	unsigned char                                      Tier;                                             		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7Skill*                                    Skill;                                            		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SpellStruct
// 0x00000010
struct FH7SpellStruct
{
//	 vPoperty_Size=4
	unsigned char                                      mSpellOperation;                                  		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mDefaultAbility;                                  		// 0x0001 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7EffectContainer*                          mSpell;                                           		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mAssociateWithSkill : 1;                          		// 0x000C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ResistanceStruct
// 0x0000001C
struct FH7ResistanceStruct
{
//	 vPoperty_Size=6
	unsigned char                                      school;                                           		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            tags;                                             		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	float                                              damageMultiplier;                                 		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      MultiplyResByMetamagic : 1;                       		// 0x0018 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      ResistOnlyBuffs : 1;                              		// 0x0018 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      IsForcedResistance : 1;                           		// 0x0018 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SpecialEffect
// 0x0014(0x02D8 - 0x02C4)
struct FH7SpecialEffect : FH7EffectProperties
{
//	 vPoperty_Size=3
	class UH7IEffectDelegate*                          mFunctionProvider;                                		// 0x02C4 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x02CC (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	unsigned long                                      mDoesDamage : 1;                                  		// 0x02D4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mUseResist : 1;                                   		// 0x02D4 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ManaCostModifier
// 0x00000015
struct FH7ManaCostModifier
{
//	 vPoperty_Size=5
	unsigned long                                      mUseForSchool : 1;                                		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      mCombineOperation;                                		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              mModifierValue;                                   		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UH7HeroAbility*                              mAbility;                                         		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mAbilitySchool;                                   		// 0x0014 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ChargeEffect
// 0x0005(0x02C9 - 0x02C4)
struct FH7ChargeEffect : FH7EffectProperties
{
//	 vPoperty_Size=2
	int                                                mChargeCounter;                                   		// 0x02C4 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mOp;                                              		// 0x02C8 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7EventContainerStruct
// 0x0000005C
struct FH7EventContainerStruct
{
//	 vPoperty_Size=9
	class UH7IEffectTargetable*                        Targetable;                                       		// 0x0000 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0008 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	TArray< class UH7IEffectTargetable* >              TargetableTargets;                                		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< unsigned char >                            ActionTag;                                        		// 0x0020 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      ActionSchool;                                     		// 0x0030 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7EffectContainer*                          EffectContainer;                                  		// 0x0034 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Action;                                           		// 0x003C (0x0001) [0x0000000000000000]              
	TArray< class UH7BaseCell* >                       Path;                                             		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UH7CombatResult*                             Result;                                           		// 0x0050 (0x0008) [0x0000000000000000]              
	int                                                Amount;                                           		// 0x0058 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CommandEffect
// 0x0134(0x03F8 - 0x02C4)
struct FH7CommandEffect : FH7EffectProperties
{
//	 vPoperty_Size=7
	unsigned char                                      mCommandTag;                                      		// 0x02C4 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mInsertHead : 1;                                  		// 0x02C8 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                mAmount;                                          		// 0x02CC (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UH7BaseAbility*                              mAbility;                                         		// 0x02D0 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mCommandRecipient;                                		// 0x02D8 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FH7ConditionStructExtendedTarget            mRecipientConditions;                             		// 0x02DC (0x0118) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mIgnoreAllegiance : 1;                            		// 0x03F4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AudioVisualEffect
// 0x0005(0x02C9 - 0x02C4)
struct FH7AudioVisualEffect : FH7EffectProperties
{
//	 vPoperty_Size=2
	unsigned long                                      mOverrideAoE : 1;                                 		// 0x02C4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      mCreatureAnim;                                    		// 0x02C8 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7HeroLevelScale
// 0x00000005
struct FH7HeroLevelScale
{
//	 vPoperty_Size=2
	float                                              mHeroLevelMulti;                                  		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mHeroLevelOperation;                              		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7DamageEffect
// 0x0090(0x0354 - 0x02C4)
struct FH7DamageEffect : FH7EffectProperties
{
//	 vPoperty_Size=1c
	struct FH7RangeValue                               mDamage;                                          		// 0x02C4 (0x0028) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mUseDefaultDamage : 1;                            		// 0x02EC (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mUseRandomSchool : 1;                             		// 0x02EC (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      mUseMagicAbs : 1;                                 		// 0x02EC (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      mUseDefaultSchool : 1;                            		// 0x02EC (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      mUseAttackPower : 1;                              		// 0x02EC (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned long                                      mUseDefensePower : 1;                             		// 0x02EC (0x0004) [0x0000000000000001] [0x00000020] ( CPF_Edit )
	unsigned long                                      mUseResist : 1;                                   		// 0x02EC (0x0004) [0x0000000000000001] [0x00000040] ( CPF_Edit )
	unsigned long                                      mIgnoreCover : 1;                                 		// 0x02EC (0x0004) [0x0000000000000001] [0x00000080] ( CPF_Edit )
	unsigned long                                      mUseStackSize : 1;                                		// 0x02EC (0x0004) [0x0000000000000001] [0x00000100] ( CPF_Edit )
	unsigned long                                      mMultiplyByMetamagic : 1;                         		// 0x02EC (0x0004) [0x0000000000000001] [0x00000200] ( CPF_Edit )
	unsigned long                                      mUseStackSizeTarget : 1;                          		// 0x02EC (0x0004) [0x0000000000000001] [0x00000400] ( CPF_Edit )
	unsigned long                                      mUsePathLength : 1;                               		// 0x02EC (0x0004) [0x0000000000000001] [0x00000800] ( CPF_Edit )
	int                                                mMightBonusPerPathStep;                           		// 0x02F0 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mUseSpellScaling : 1;                             		// 0x02F4 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FH7SpellScaling                             mMinDamage;                                       		// 0x02F8 (0x0014) [0x0000000000000001]              ( CPF_Edit )
	struct FH7SpellScaling                             mMaxDamage;                                       		// 0x030C (0x0014) [0x0000000000000001]              ( CPF_Edit )
	TArray< float >                                    mDistanceDamageReduction;                         		// 0x0320 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mUsePercentStackDamage : 1;                       		// 0x0330 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              mPercentStackDamage;                              		// 0x0334 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mAddPercentStackDamage;                           		// 0x0338 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              mPercentStackDamageCap;                           		// 0x033C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mPercentUseCasterSpellPower : 1;                  		// 0x0340 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mOverrideDamageFromEvent : 1;                     		// 0x0340 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	float                                              mOverriddenDamageMultiplier;                      		// 0x0344 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      mSpreadDamageEvenly : 1;                          		// 0x0348 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      mUseHeroLevel : 1;                                		// 0x0348 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	struct FH7HeroLevelScale                           mHeroLevelScale;                                  		// 0x034C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ResistanceEffect
// 0x001C(0x02E0 - 0x02C4)
struct FH7ResistanceEffect : FH7EffectProperties
{
//	 vPoperty_Size=1
	struct FH7ResistanceStruct                         mResistance;                                      		// 0x02C4 (0x001C) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SpellEffect
// 0x0010(0x02D4 - 0x02C4)
struct FH7SpellEffect : FH7EffectProperties
{
//	 vPoperty_Size=1
	struct FH7SpellStruct                              mSpellStruct;                                     		// 0x02C4 (0x0010) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7StatEffect
// 0x0074(0x0338 - 0x02C4)
struct FH7StatEffect : FH7EffectProperties
{
//	 vPoperty_Size=2
	struct FH7MeModifiesStat                           mStatMod;                                         		// 0x02C4 (0x0070) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      mUseAmount : 1;                                   		// 0x0334 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7SpellValue
// 0x000000A0
struct FH7SpellValue
{
//	 vPoperty_Size=4
	struct FH7RangeValue                               mUnskilled;                                       		// 0x0000 (0x0028) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7RangeValue                               mNovice;                                          		// 0x0028 (0x0028) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7RangeValue                               mExpert;                                          		// 0x0050 (0x0028) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7RangeValue                               mMaster;                                          		// 0x0078 (0x0028) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7StatModSource
// 0x00000088
struct FH7StatModSource
{
//	 vPoperty_Size=3
	struct FH7MeModifiesStat                           mMod;                                             		// 0x0000 (0x0070) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UH7EffectContainer*                          mSource;                                          		// 0x0070 (0x0008) [0x0000000000000000]              
	struct FString                                     mSourceName;                                      		// 0x0078 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.AnimationData
// 0x00000018
struct FAnimationData
{
//	 vPoperty_Size=3
	class UAnimNodePlayCustomAnim*                     AnimNode;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FName                                       AnimName;                                         		// 0x0008 (0x0008) [0x0000000000000000]              
	struct FName                                       StateName;                                        		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.CreaturePositon
// 0x00000030
struct FCreaturePositon
{
//	 vPoperty_Size=5
	class AH7CreatureStack*                            Stack;                                            		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FIntPoint                                   ToGridPosition;                                   		// 0x0008 (0x0008) [0x0000000000000000]              
	struct FIntPoint                                   FromGridPosition;                                 		// 0x0010 (0x0008) [0x0000000000000000]              
	struct FIntPoint                                   MasterCellPosition;                               		// 0x0018 (0x0008) [0x0000000000000000]              
	TArray< struct FIntPoint >                         ShiftCells;                                       		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.GridColumns
// 0x00000010
struct FGridColumns
{
//	 vPoperty_Size=1
	TArray< class UH7CombatMapCell* >                  Row;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ResourceGatherData
// 0x0000000C
struct FH7ResourceGatherData
{
//	 vPoperty_Size=2
	class UH7Resource*                                 Resource;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Amount;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7MergePool
// 0x00000020
struct FH7MergePool
{
//	 vPoperty_Size=2
	struct FString                                     PoolKey;                                          		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class UH7BaseCreatureStack* >              PoolStacks;                                       		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7Obstacle
// 0x00000010
struct FH7Obstacle
{
//	 vPoperty_Size=2
	struct FIntPoint                                   gridPos;                                          		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7CombatObstacleObject*                     OBSTACLE;                                         		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.CreatureStackProperties
// 0x00000014
struct FCreatureStackProperties
{
//	 vPoperty_Size=4
	class AH7Creature*                                 Creature;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Size;                                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                CustomPositionX;                                  		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                CustomPositionY;                                  		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.FH7FlyTimePoint
// 0x00000009
struct FFH7FlyTimePoint
{
//	 vPoperty_Size=3
	float                                              TargetTime;                                       		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FlyHeight;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      PointInterp;                                      		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ParticleAttachment
// 0x00000014
struct FH7ParticleAttachment
{
//	 vPoperty_Size=3
	class UParticleSystemComponent*                    ParticleSystem;                                   		// 0x0000 (0x0008) [0x0000000004080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_EditInline )
	unsigned long                                      IsSocketAttached : 1;                             		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FName                                       SocketAttachName;                                 		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7WeaponAttachment
// 0x00000014
struct FH7WeaponAttachment
{
//	 vPoperty_Size=4
	class USkeletalMeshComponent*                      WeaponSkeletalMesh;                               		// 0x0000 (0x0008) [0x0000000004080009]              ( CPF_Edit | CPF_ExportObject | CPF_Component | CPF_EditInline )
	unsigned long                                      IsProjectile : 1;                                 		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      IsSocketAttached : 1;                             		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	struct FName                                       SocketAttachName;                                 		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7MaterialEffect
// 0x00000030
struct FH7MaterialEffect
{
//	 vPoperty_Size=9
	unsigned long                                      GotMaterialFX : 1;                                		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      MaterialParamName;                                		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeOutEffectLength;                              		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeOutEffectStartingTime;                        		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeInEffectLength;                               		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FadeInEffectStartingtime;                         		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              SteadyEffectTime;                                 		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MaxEffectImpact;                                  		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                ColorManipulationMax;                             		// 0x0020 (0x0010) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7DeathMaterialEffect
// 0x00000010
struct FH7DeathMaterialEffect
{
//	 vPoperty_Size=4
	unsigned char                                      MaterialParamName;                                		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              EffectTime;                                       		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EffectLength;                                     		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              EffectStartingTime;                               		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7HeroEvent
// 0x00000010
struct FH7HeroEvent
{
//	 vPoperty_Size=3
	unsigned char                                      EventType;                                        		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              Time;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UCameraShake*                                CameraShake;                                      		// 0x0008 (0x0008) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7WarfareEvent
// 0x00000010
struct FH7WarfareEvent
{
//	 vPoperty_Size=3
	unsigned char                                      EventType;                                        		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              Time;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UCameraShake*                                CameraShake;                                      		// 0x0008 (0x0008) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7CreatureEvent
// 0x00000010
struct FH7CreatureEvent
{
//	 vPoperty_Size=3
	unsigned char                                      EventType;                                        		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	float                                              Time;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UCameraShake*                                CameraShake;                                      		// 0x0008 (0x0008) [0x0000000004000001]              ( CPF_Edit | CPF_EditInline )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7HeroSkill
// 0x0000001C
struct FH7HeroSkill
{
//	 vPoperty_Size=4
	class UH7Skill*                                    Skill;                                            		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Tier;                                             		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Rank;                                             		// 0x0009 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7HeroAbility* >                    LearnedAbilities;                                 		// 0x000C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TeleportCosts
// 0x00000010
struct FH7TeleportCosts
{
//	 vPoperty_Size=4
	unsigned char                                      HeroRank;                                         		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                CoreCreatureCosts;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                EliteCreatureCosts;                               		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                ChampionCreatureCosts;                            		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7PlayerSpyInfo
// 0x00000018
struct FH7PlayerSpyInfo
{
//	 vPoperty_Size=c
	int                                                PlayerID;                                         		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      PlayerName;                                       		// 0x0004 (0x0001) [0x0000000000000000]              
	unsigned char                                      Towns;                                            		// 0x0005 (0x0001) [0x0000000000000000]              
	unsigned char                                      Heroes;                                           		// 0x0006 (0x0001) [0x0000000000000000]              
	unsigned char                                      BestHero;                                         		// 0x0007 (0x0001) [0x0000000000000000]              
	unsigned char                                      Gold;                                             		// 0x0008 (0x0001) [0x0000000000000000]              
	unsigned char                                      CommonResourceIncome;                             		// 0x0009 (0x0001) [0x0000000000000000]              
	unsigned char                                      RareResourceIncome;                               		// 0x000A (0x0001) [0x0000000000000000]              
	unsigned char                                      MapDiscovery;                                     		// 0x000B (0x0001) [0x0000000000000000]              
	unsigned char                                      TearOfAshan;                                      		// 0x000C (0x0001) [0x0000000000000000]              
	int                                                PlunderCount;                                     		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                SabotageCount;                                    		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7RecruitmentInfo
// 0x0000002C
struct FH7RecruitmentInfo
{
//	 vPoperty_Size=5
	class AH7Creature*                                 Creature;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Count;                                            		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FH7ResourceQuantity >               Costs;                                            		// 0x000C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class AH7Dwelling*                                 OriginDwelling;                                   		// 0x001C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7CustomNeutralDwelling*                    OriginCostumeDwelling;                            		// 0x0024 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7ResourceQuantities
// 0x00000010
struct FH7ResourceQuantities
{
//	 vPoperty_Size=1
	TArray< struct FH7ResourceQuantity >               Costs;                                            		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiTownDevelopment
// 0x00000030
struct FH7AiTownDevelopment
{
//	 vPoperty_Size=3
	TArray< class UH7TownBuilding* >                   Economy;                                          		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class UH7TownBuilding* >                   Defensive;                                        		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class UH7TownBuilding* >                   Military;                                         		// 0x0020 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiTownConfig
// 0x000001B0
struct FH7AiTownConfig
{
//	 vPoperty_Size=9
	struct FH7AiTownDevelopment                        Haven;                                            		// 0x0000 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Academy;                                          		// 0x0030 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Stronghold;                                       		// 0x0060 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Necropolis;                                       		// 0x0090 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Sylvan;                                           		// 0x00C0 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Dungeon;                                          		// 0x00F0 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Fortress;                                         		// 0x0120 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Inferno;                                          		// 0x0150 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FH7AiTownDevelopment                        Sanctuary;                                        		// 0x0180 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiHeroAgCompound2
// 0x00000054
struct FH7AiHeroAgCompound2
{
//	 vPoperty_Size=15
	float                                              Explore;                                          		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Repair;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Pickup;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Gather;                                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Guard;                                            		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Reinforce;                                        		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Flee;                                             		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Chill;                                            		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSite;                                          		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Congregate;                                       		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteBoost;                                     		// 0x0028 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteCommission;                                		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteExercise;                                  		// 0x0030 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteObserve;                                   		// 0x0034 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteTeleporter;                                		// 0x0038 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteShop;                                      		// 0x003C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteStudy;                                     		// 0x0040 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteKeymaster;                                 		// 0x0044 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              UseSiteObelisk;                                   		// 0x0048 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              RetrieveTearOfAsha;                               		// 0x004C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Replenish;                                        		// 0x0050 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiHeroConfig2
// 0x000001A4
struct FH7AiHeroConfig2
{
//	 vPoperty_Size=5
	struct FH7AiHeroAgCompound2                        Standard;                                         		// 0x0000 (0x0054) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound2                        Explorer;                                         		// 0x0054 (0x0054) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound2                        Gatherer;                                         		// 0x00A8 (0x0054) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound2                        Homeguard;                                        		// 0x00FC (0x0054) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound2                        General;                                          		// 0x0150 (0x0054) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiHeroAgCompound
// 0x00000018
struct FH7AiHeroAgCompound
{
//	 vPoperty_Size=6
	float                                              AttackArmy;                                       		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              AttackBorderArmy;                                 		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              AttackAoC;                                        		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              AttackCity;                                       		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              AttackEnemy;                                      		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Plunder;                                          		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiHeroConfig
// 0x00000078
struct FH7AiHeroConfig
{
//	 vPoperty_Size=5
	struct FH7AiHeroAgCompound                         Sheep;                                            		// 0x0000 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound                         Contained;                                        		// 0x0018 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound                         Balanced;                                         		// 0x0030 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound                         Hostile;                                          		// 0x0048 (0x0018) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiHeroAgCompound                         Nefarious;                                        		// 0x0060 (0x0018) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiTensionParameter
// 0x0000000C
struct FH7AiTensionParameter
{
//	 vPoperty_Size=3
	float                                              Base;                                             		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Gain;                                             		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Cap;                                              		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiAoCModifier
// 0x0000000C
struct FH7AiAoCModifier
{
//	 vPoperty_Size=3
	float                                              PBWeak;                                           		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              PBStrong;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              PBBalanced;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiAoCCompound
// 0x00000024
struct FH7AiAoCCompound
{
//	 vPoperty_Size=3
	struct FH7AiAoCModifier                            OwnAoC;                                           		// 0x0000 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiAoCModifier                            AlliedAoC;                                        		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiAoCModifier                            HostileAoC;                                       		// 0x0018 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiConfigCompound
// 0x0000004C
struct FH7AiConfigCompound
{
//	 vPoperty_Size=9
	float                                              Cutoff;                                           		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Low;                                              		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              High;                                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiTensionParameter                       Tension;                                          		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	int                                                ProximityTargetLimit;                             		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MovementEffortBias;                               		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              FightingEffortBias;                               		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              ReinforcementBias;                                		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiAoCCompound                            AoCMod;                                           		// 0x0028 (0x0024) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AiActionConfig
// 0x000001C8
struct FH7AiActionConfig
{
//	 vPoperty_Size=6
	struct FH7AiConfigCompound                         General;                                          		// 0x0000 (0x004C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiConfigCompound                         Main;                                             		// 0x004C (0x004C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiConfigCompound                         Secondary;                                        		// 0x0098 (0x004C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiConfigCompound                         Scout;                                            		// 0x00E4 (0x004C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiConfigCompound                         Support;                                          		// 0x0130 (0x004C) [0x0000000000000001]              ( CPF_Edit )
	struct FH7AiConfigCompound                         Mule;                                             		// 0x017C (0x004C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TownBuildingData
// 0x0000000C
struct FH7TownBuildingData
{
//	 vPoperty_Size=3
	class UH7TownBuilding*                             Building;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      IsBuilt : 1;                                      		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      IsBlocked : 1;                                    		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7AreaOfControlCells
// 0x00000024
struct FH7AreaOfControlCells
{
//	 vPoperty_Size=3
	TArray< class UH7AdventureMapCell* >               Cells;                                            		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7AdventureMapCell* >               BorderCells;                                      		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                AreaOfControlIndex;                               		// 0x0020 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.AdvGridColumns
// 0x00000010
struct FAdvGridColumns
{
//	 vPoperty_Size=1
	TArray< class UH7AdventureMapCell* >               Row;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7Rect
// 0x00000010
struct FH7Rect
{
//	 vPoperty_Size=4
	int                                                X;                                                		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                Y;                                                		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                Width;                                            		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                Height;                                           		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.PlayerFogInfo
// 0x00000054
struct FPlayerFogInfo
{
//	 vPoperty_Size=6
	TArray< int >                                      visibleTiles;                                     		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< int >                                      exploredTiles;                                    		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UStaticMeshComponent* >              visibleStaticMeshComponents;                      		// 0x0020 (0x0010) [0x0000000004480008]              ( CPF_ExportObject | CPF_Component | CPF_NeedCtorLink | CPF_EditInline )
	TArray< class UParticleSystemComponent* >          visibleParticleSystems;                           		// 0x0030 (0x0010) [0x0000000004480008]              ( CPF_ExportObject | CPF_Component | CPF_NeedCtorLink | CPF_EditInline )
	int                                                PlayerNumber;                                     		// 0x0040 (0x0004) [0x0000000000000000]              
	TArray< int >                                      handledTiles;                                     		// 0x0044 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.ArrivedCaravan
// 0x00000024
struct FArrivedCaravan
{
//	 vPoperty_Size=4
	int                                                Index;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	class AH7AreaOfControlSiteLord*                    sourceLord;                                       		// 0x0004 (0x0008) [0x0000000000000000]              
	class AH7AreaOfControlSite*                        targetLord;                                       		// 0x000C (0x0008) [0x0000000000000000]              
	TArray< class UH7BaseCreatureStack* >              stacks;                                           		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TooltipLogEntry
// 0x00000008
struct FH7TooltipLogEntry
{
//	 vPoperty_Size=2
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000000]              
	float                                              Value;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.H7TooltipReplacementEntry
// 0x00000020
struct FH7TooltipReplacementEntry
{
//	 vPoperty_Size=2
	struct FString                                     placeholder;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Value;                                            		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnumsNative.PrivilegesContainer
// 0x00000014
struct FPrivilegesContainer
{
//	 vPoperty_Size=2
	int                                                PlayerIndex;                                      		// 0x0000 (0x0004) [0x0000000000000000]              
	TArray< int >                                      privileges;                                       		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7SavegameDataHolder.H7SavegameData
// 0x000000E8
struct FH7SavegameData
{
//	 vPoperty_Size=11
	struct FString                                     mName;                                            		// 0x0000 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                mSaveTimeUnix;                                    		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FString                                     mSaveTime;                                        		// 0x0014 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned char                                      mSaveType;                                        		// 0x0024 (0x0001) [0x0000000000000000]              
	int                                                mSaveGameCheckSum;                                		// 0x0028 (0x0004) [0x0000000000000000]              
	unsigned char                                      mGameMode;                                        		// 0x002C (0x0001) [0x0000000000000000]              
	int                                                mTurnCounter;                                     		// 0x0030 (0x0004) [0x0000000000000000]              
	struct FString                                     mCampaignID;                                      		// 0x0034 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FH7LobbyDataMapSettings                     mMapSettings;                                     		// 0x0044 (0x0020) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FH7LobbyDataGameSettings                    mGameSettings;                                    		// 0x0064 (0x002C) [0x0000000000000000]              
	TArray< struct FPlayerLobbySelectedSettings >      mPlayersSettings;                                 		// 0x0090 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mMapFilePath;                                     		// 0x00A0 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mMapFileName;                                     		// 0x00B0 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned char                                      mMapType;                                         		// 0x00C0 (0x0001) [0x0000000000000000]              
	struct FString                                     mMapInfo;                                         		// 0x00C4 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	struct FString                                     mMapName;                                         		// 0x00D4 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	int                                                mEnding;                                          		// 0x00E4 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7ListingSavegame.H7ListingSavegameDataScene
// 0x00000100
struct FH7ListingSavegameDataScene
{
//	 vPoperty_Size=4
	int                                                SlotIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     Name;                                             		// 0x0004 (0x0010) [0x0000000000500000]              ( CPF_NeedCtorLink )
	unsigned char                                      HealthStatus;                                     		// 0x0014 (0x0001) [0x0000000000000000]              
	struct FH7SavegameData                             SaveGameData;                                     		// 0x0018 (0x00E8) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7PopupParameters
// 0x00000024
struct FH7PopupParameters
{
//	 vPoperty_Size=6
	class UObject*                                     param1;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
	class UObject*                                     param2;                                           		// 0x0008 (0x0008) [0x0000000000000000]              
	class UObject*                                     param3;                                           		// 0x0010 (0x0008) [0x0000000000000000]              
	class UObject*                                     param4;                                           		// 0x0018 (0x0008) [0x0000000000000000]              
	unsigned long                                      paramBool1 : 1;                                   		// 0x0020 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      paramBool2 : 1;                                   		// 0x0020 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7MessageSettings
// 0x00000074
struct FH7MessageSettings
{
//	 vPoperty_Size=10
	class UTexture2D*                                  Icon;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      deleteWhenClicked : 1;                            		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      allowDestroy : 1;                                 		// 0x0008 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned char                                      Action;                                           		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                actionDuration;                                   		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UObject*                                     referenceObject;                                  		// 0x0014 (0x0008) [0x0000000000000000]              
	class UObject*                                     referenceWindowCntl;                              		// 0x001C (0x0008) [0x0000000000000000]              
	struct FH7PopupParameters                          popupParams;                                      		// 0x0024 (0x0024) [0x0000000000000000]              
	class UH7MessageCallbacks*                         callbacks;                                        		// 0x0048 (0x0008) [0x0000000000000000]              
	unsigned char                                      floatingType;                                     		// 0x0050 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      Color;                                            		// 0x0054 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      preventHTML : 1;                                  		// 0x0058 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FVector                                     floatingLocation;                                 		// 0x005C (0x000C) [0x0000000000000000]              
	unsigned long                                      hideGui : 1;                                      		// 0x0068 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                Priority;                                         		// 0x006C (0x0004) [0x0000000000000000]              
	float                                              fadeOutAfterXSeconds;                             		// 0x0070 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7CombatResultSignature
// 0x00000034
struct FH7CombatResultSignature
{
//	 vPoperty_Size=6
	class UH7EffectContainer*                          Ability;                                          		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7IEffectTargetable* >              Targets;                                          		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class UH7IEffectTargetable*                        mainTarget;                                       		// 0x0018 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0020 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	unsigned char                                      cursorDirection;                                  		// 0x0028 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                cursorAngle;                                      		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      extendedVersion : 1;                              		// 0x0030 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7LocalGuardData
// 0x00000020
struct FH7LocalGuardData
{
//	 vPoperty_Size=8
	int                                                mCapacityCoreFoot;                                		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mCapacityCoreRange;                               		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mCapacityEliteFoot;                               		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mCapacityEliteRange;                              		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mCapacityChampion;                                		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mProductionCore;                                  		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mProductionElite;                                 		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mProductionChampion;                              		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7StackDeployment
// 0x00000034
struct FH7StackDeployment
{
//	 vPoperty_Size=8
	struct FCreatureStackProperties                    StackInfo;                                        		// 0x0000 (0x0014) [0x0000000000000001]              ( CPF_Edit )
	class AH7CreatureStack*                            CreatureStackRef;                                 		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                SourceSlotId;                                     		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                DistanceSide;                                     		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                DistanceTop;                                      		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Ordinal;                                          		// 0x0028 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                SpacingTop;                                       		// 0x002C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                SpacingBottom;                                    		// 0x0030 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7DeploymentData
// 0x00000030
struct FH7DeploymentData
{
//	 vPoperty_Size=6
	unsigned long                                      ForceAutodeployment : 1;                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                OriginalMapHeight;                                		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                NumberOfDeployedStacks;                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                NumberOfStacksToDeploy;                           		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FH7StackDeployment >                StackDeployments;                                 		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class AH7Unit* >                           UnDeployedOffGridUnits;                           		// 0x0020 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPDamageApply
// 0x00000010
struct FMPDamageApply
{
//	 vPoperty_Size=4
	int                                                CreatureStackId;                                  		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                StackSize;                                        		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                TopCreatureHealth;                                		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              ExpirationTime;                                   		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPOutOfSynchData
// 0x0000001C
struct FMPOutOfSynchData
{
//	 vPoperty_Size=7
	int                                                PlayerNumber;                                     		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                UnitActionsCounter;                               		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                SynchRNG;                                         		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                IDCounter;                                        		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                UnitsCount;                                       		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                ResCount;                                         		// 0x0014 (0x0004) [0x0000000000000000]              
	unsigned long                                      IsCombat : 1;                                     		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPSimTurnOngoingStartCombat
// 0x0000001C
struct FMPSimTurnOngoingStartCombat
{
//	 vPoperty_Size=5
	class AH7AdventureHero*                            Source;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      SourceAnswer;                                     		// 0x0008 (0x0001) [0x0000000000000000]              
	class AH7AdventureHero*                            Target;                                           		// 0x000C (0x0008) [0x0000000000000000]              
	unsigned char                                      TargetAnswer;                                     		// 0x0014 (0x0001) [0x0000000000000000]              
	float                                              StartTimer;                                       		// 0x0018 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPSimTurnOngoingTrade
// 0x00000010
struct FMPSimTurnOngoingTrade
{
//	 vPoperty_Size=2
	class AH7AdventureHero*                            Source;                                           		// 0x0000 (0x0008) [0x0000000000000000]              
	class AH7AdventureHero*                            Target;                                           		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPInstantCommand
// 0x00000040
struct FMPInstantCommand
{
//	 vPoperty_Size=8
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000000]              
	int                                                UnitActionsCounter;                               		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                CurrentPlayer;                                    		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                IntParameters[ 0x8 ];                             		// 0x000C (0x0020) [0x0000000000000000]              
	struct FString                                     StringParameter;                                  		// 0x002C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      ignoreOOSCheck : 1;                               		// 0x003C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      IsCombatCommand : 1;                              		// 0x003C (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      IsTactics : 1;                                    		// 0x003C (0x0004) [0x0000000000000000] [0x00000004] 
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPCommandSendData
// 0x0000004C
struct FMPCommandSendData
{
//	 vPoperty_Size=2
	int                                                Parameters[ 0xF ];                                		// 0x0000 (0x003C) [0x0000000000000000]              
	TArray< class UH7BaseCell* >                       convertedPath;                                    		// 0x003C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.SynchUpCombatData
// 0x00000010
struct FSynchUpCombatData
{
//	 vPoperty_Size=4
	int                                                UnitActionsCounter;                               		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                StackId;                                          		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                StackCount;                                       		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                TopCreatureHealth;                                		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.SynchUpUnitData
// 0x00000038
struct FSynchUpUnitData
{
//	 vPoperty_Size=5
	int                                                UnitActionsCounter;                               		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                heroId;                                           		// 0x0004 (0x0004) [0x0000000000000000]              
	struct FString                                     stackIDStrings;                                   		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                stackCounts[ 0x7 ];                               		// 0x0018 (0x001C) [0x0000000000000000]              
	unsigned long                                      IsCombat : 1;                                     		// 0x0034 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnums.SynchUpData
// 0x00000010
struct FSynchUpData
{
//	 vPoperty_Size=4
	int                                                UnitActionsCounter;                               		// 0x0000 (0x0004) [0x0000000000000000]              
	int                                                RNGCounter;                                       		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                IDCounter;                                        		// 0x0008 (0x0004) [0x0000000000000000]              
	unsigned long                                      IsCombat : 1;                                     		// 0x000C (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPCommand
// 0x00000064
struct FMPCommand
{
//	 vPoperty_Size=13
	int                                                UnitActionsCounter;                               		// 0x0000 (0x0004) [0x0000000000000000]              
	unsigned char                                      CommandType;                                      		// 0x0004 (0x0001) [0x0000000000000000]              
	unsigned char                                      CommandTag;                                       		// 0x0005 (0x0001) [0x0000000000000000]              
	class UH7ICaster*                                  CommandSource;                                    		// 0x0008 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0010 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	int                                                Target;                                           		// 0x0018 (0x0004) [0x0000000000000000]              
	TArray< class UH7BaseCell* >                       Path;                                             		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class UH7BaseAbility*                              Ability;                                          		// 0x002C (0x0008) [0x0000000000000000]              
	unsigned char                                      Direction;                                        		// 0x0034 (0x0001) [0x0000000000000000]              
	unsigned long                                      ReplaceFakeAttacker : 1;                          		// 0x0038 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      InsertHead : 1;                                   		// 0x0038 (0x0004) [0x0000000000000000] [0x00000002] 
	int                                                UnitTurnCounter;                                  		// 0x003C (0x0004) [0x0000000000000000]              
	int                                                TeleportTarget;                                   		// 0x0040 (0x0004) [0x0000000000000000]              
	int                                                CurrentPlayer;                                    		// 0x0044 (0x0004) [0x0000000000000000]              
	class UH7CombatMapCell*                            TrueHitCell;                                      		// 0x0048 (0x0008) [0x0000000000000000]              
	unsigned long                                      doOOSCheck : 1;                                   		// 0x0050 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                movementPoints;                                   		// 0x0054 (0x0004) [0x0000000000000000]              
	float                                              CreationTime;                                     		// 0x0058 (0x0004) [0x0000000000000000]              
	unsigned long                                      IsCombatCommand : 1;                              		// 0x005C (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                ToPlayer;                                         		// 0x0060 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.BoundingPoint
// 0x0000000C
struct FBoundingPoint
{
//	 vPoperty_Size=2
	struct FVector2D                                   pixel;                                            		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      Hit : 1;                                          		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.FCTMappingEntry
// 0x0000000C
struct FFCTMappingEntry
{
//	 vPoperty_Size=2
	unsigned char                                      mType;                                            		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UTexture2D*                                  mIcon;                                            		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.Plate
// 0x00000020
struct FPlate
{
//	 vPoperty_Size=8
	class AH7CreatureStack*                            Stack;                                            		// 0x0000 (0x0008) [0x0000000000000000]              
	int                                                flashID;                                          		// 0x0008 (0x0004) [0x0000000000000000]              
	unsigned char                                      Orientation;                                      		// 0x000C (0x0001) [0x0000000000000000]              
	int                                                oldX;                                             		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                oldY;                                             		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                oldSize;                                          		// 0x0018 (0x0004) [0x0000000000000000]              
	unsigned long                                      oldVisible : 1;                                   		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      oldIsActive : 1;                                  		// 0x001C (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7StructsAndEnums.Bar
// 0x00000020
struct FBar
{
//	 vPoperty_Size=7
	class AH7Unit*                                     Unit;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	unsigned char                                      Type;                                             		// 0x0008 (0x0001) [0x0000000000000000]              
	int                                                flashID;                                          		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                oldX;                                             		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                oldY;                                             		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                oldPercent;                                       		// 0x0018 (0x0004) [0x0000000000000000]              
	unsigned long                                      oldVisible : 1;                                   		// 0x001C (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7StructsAndEnums.MPUnitsPos
// 0x0000000C
struct FMPUnitsPos
{
//	 vPoperty_Size=2
	int                                                UnitId;                                           		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FIntPoint                                   UnitPos;                                          		// 0x0004 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7StackCount
// 0x0000000C
struct FH7StackCount
{
//	 vPoperty_Size=2
	int                                                Count;                                            		// 0x0000 (0x0004) [0x0000000000000000]              
	class AH7Creature*                                 Type;                                             		// 0x0004 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7AlliedTradeData
// 0x00000058
struct FH7AlliedTradeData
{
//	 vPoperty_Size=7
	int                                                receivingHeroID;                                  		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     receivingHeroName;                                		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                givingHeroID;                                     		// 0x0014 (0x0004) [0x0000000000000000]              
	struct FString                                     givingHeroName;                                   		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7HeroItem* >                       receivedItems;                                    		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FH7StackCount >                     receivedCreatures;                                		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class AH7EditorWarUnit* >                  receivedWarfareUnit;                              		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7NumberAndIcon
// 0x00000014
struct FH7NumberAndIcon
{
//	 vPoperty_Size=2
	int                                                Number;                                           		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FString                                     IconPath;                                         		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.AiWaypoint
// 0x00000010
struct FAiWaypoint
{
//	 vPoperty_Size=3
	class AH7AdventureCellMarker*                      cell;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Cmd;                                              		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                cmdTurns;                                         		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.AiTargetValue
// 0x00000018
struct FAiTargetValue
{
//	 vPoperty_Size=3
	struct FString                                     TargetClass;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	float                                              utilityOwnFaction;                                		// 0x0010 (0x0004) [0x0000000000000000]              
	float                                              utilityOtherFaction;                              		// 0x0014 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7StructsAndEnums.TradingTableEntry
// 0x00000010
struct FTradingTableEntry
{
//	 vPoperty_Size=3
	class UH7Resource*                                 Resource;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                BuyValue;                                         		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                SellValue;                                        		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7StructsAndEnums.H7TooltipData
// 0x00000050
struct FH7TooltipData
{
//	 vPoperty_Size=7
	unsigned char                                      Type;                                             		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UGFxObject*                                  objData;                                          		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     Title;                                            		// 0x000C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Description;                                      		// 0x001C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     Visited;                                          		// 0x002C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     strData;                                          		// 0x003C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      addRightMouseIcon : 1;                            		// 0x004C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.SaveGameStatePlayerController.H7SaveGameEntry
// 0x00000024
struct FH7SaveGameEntry
{
//	 vPoperty_Size=3
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Time;                                             		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FString                                     humanTime;                                        		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CampaignDefinition.H7MapEntry
// 0x0000004C
struct FH7MapEntry
{
//	 vPoperty_Size=7
	struct FString                                     mFileName;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	int                                                mYear;                                            		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mPixel;                                           		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                mMapInfoNumber;                                   		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     mFallbackName;                                    		// 0x001C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FString >                           mUnlockCutscenes;                                 		// 0x002C (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     mNameInst;                                        		// 0x003C (0x0010) [0x0000000000402000]              ( CPF_Transient | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7WaypointBasedCameraAction.H7CameraWaypoint
// 0x0000003C
struct FH7CameraWaypoint
{
//	 vPoperty_Size=b
	struct FVector                                     targetPos;                                        		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FRotator                                    targetRot;                                        		// 0x000C (0x000C) [0x0000000000000000]              
	float                                              TargetViewDistance;                               		// 0x0018 (0x0004) [0x0000000000000000]              
	float                                              TargetFoV;                                        		// 0x001C (0x0004) [0x0000000000000000]              
	unsigned char                                      InterpType;                                       		// 0x0020 (0x0001) [0x0000000000000000]              
	float                                              Duration;                                         		// 0x0024 (0x0004) [0x0000000000000000]              
	class AH7Unit*                                     targetUnit;                                       		// 0x0028 (0x0008) [0x0000000000000000]              
	unsigned char                                      CreatureAnim;                                     		// 0x0030 (0x0001) [0x0000000000000000]              
	unsigned char                                      HeroAnim;                                         		// 0x0031 (0x0001) [0x0000000000000000]              
	float                                              FadeDuration;                                     		// 0x0034 (0x0004) [0x0000000000000000]              
	float                                              FadeStartPrec;                                    		// 0x0038 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7CameraActionController.AMEventAction
// 0x00000038
struct FAMEventAction
{
//	 vPoperty_Size=5
	class AActor*                                      startTarget;                                      		// 0x0000 (0x0008) [0x0000000000000000]              
	class AActor*                                      endTarget;                                        		// 0x0008 (0x0008) [0x0000000000000000]              
	struct FScriptDelegate                             actionCompletedFunction;                          		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0014 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             midActionFunction;                                		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0024 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	class AH7AMEventCameraAction*                      amEventTemplate;                                  		// 0x0030 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7CouncilMapping.H7CouncilMappingEntry
// 0x00000014
struct FH7CouncilMappingEntry
{
//	 vPoperty_Size=3
	unsigned char                                      councilorEnum;                                    		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class AH7EditorHero*                               councilorHero;                                    		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UTexture2D*                                  paperCouncillorIcon;                              		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7APRColorMapping.H7APRColorMappingEntry
// 0x00000008
struct FH7APRColorMappingEntry
{
//	 vPoperty_Size=2
	unsigned char                                      mThreatLEvel;                                     		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      mColor;                                           		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7GUIGeneralProperties.H7MinimapOption
// 0x00000014
struct FH7MinimapOption
{
//	 vPoperty_Size=2
	struct FString                                     mCategoryID;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      mVisible : 1;                                     		// 0x0010 (0x0004) [0x0000000000000000] [0x00000001] 
};

// ScriptStruct MMH7Game.H7Hud.H7StartupEntry
// 0x00000014
struct FH7StartupEntry
{
//	 vPoperty_Size=2
	struct FString                                     MovieName;                                        		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Duration;                                         		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7Hud.H7TutorialClickListener
// 0x00000028
struct FH7TutorialClickListener
{
//	 vPoperty_Size=3
	class UH7SeqAct_HighlightGUIElement*               Node;                                             		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     containerName;                                    		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ElementName;                                      		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7Hud.H7FrameTimer
// 0x00000014
struct FH7FrameTimer
{
//	 vPoperty_Size=2
	int                                                framesToWait;                                     		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FScriptDelegate                             callbackFunction;                                 		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0008 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.H7Hud.H7SecondsTimer
// 0x00000014
struct FH7SecondsTimer
{
//	 vPoperty_Size=2
	float                                              secondsToWait;                                    		// 0x0000 (0x0004) [0x0000000000000000]              
	struct FScriptDelegate                             callbackFunction;                                 		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0008 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.H7AdventureMapCell.CellPathfinderData
// 0x00000024
struct FCellPathfinderData
{
//	 vPoperty_Size=a
	float                                              aiDistance;                                       		// 0x0000 (0x0004) [0x0000000000000000]              
	float                                              GScore;                                           		// 0x0004 (0x0004) [0x0000000000000000]              
	float                                              FScore;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                canMoveLand;                                      		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                canMoveWater;                                     		// 0x0010 (0x0004) [0x0000000000000000]              
	unsigned long                                      isAccessibleByShip : 1;                           		// 0x0014 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      IsClosed : 1;                                     		// 0x0014 (0x0004) [0x0000000000000000] [0x00000002] 
	unsigned long                                      Opened : 1;                                       		// 0x0014 (0x0004) [0x0000000000000000] [0x00000004] 
	class UH7AdventureMapCell*                         previousCell;                                     		// 0x0018 (0x0008) [0x0000000000000000]              
	int                                                openListCellIndex;                                		// 0x0020 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7KeybindManager.H7Keybind
// 0x00000050
struct FH7Keybind
{
//	 vPoperty_Size=5
	struct FKeyBind                                    KeyBind;                                          		// 0x0000 (0x001C) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FKeyBind                                    secondaryKeybind;                                 		// 0x001C (0x001C) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      Category;                                         		// 0x0038 (0x0001) [0x0000000000100001]              ( CPF_Edit )
	struct FScriptDelegate                             keybindFunction;                                  		// 0x003C (0x0010) [0x0000000000500001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0040 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	int                                                Dummy;                                            		// 0x004C (0x0004) [0x0000000000100001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7PopupKeybindings.KeyCommand
// 0x00000048
struct FKeyCommand
{
//	 vPoperty_Size=3
	struct FString                                     Command;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FKeyBind                                    keyPrimary;                                       		// 0x0010 (0x001C) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FKeyBind                                    keySecondary;                                     		// 0x002C (0x001C) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CampaignTransitionManager.H7InventoryItem
// 0x00000018
struct FH7InventoryItem
{
//	 vPoperty_Size=2
	struct FString                                     ItemArchRef;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FIntPoint                                   InventoryPos;                                     		// 0x0010 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7CampaignTransitionManager.H7TransitionHero
// 0x00000128
struct FH7TransitionHero
{
//	 vPoperty_Size=1d
	struct FString                                     HeroArchRef;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Level;                                            		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                SkillPoints;                                      		// 0x0014 (0x0004) [0x0000000000000000]              
	int                                                XP;                                               		// 0x0018 (0x0004) [0x0000000000000000]              
	int                                                MIGHT;                                            		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                Defence;                                          		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                Magic;                                            		// 0x0024 (0x0004) [0x0000000000000000]              
	int                                                Spirit;                                           		// 0x0028 (0x0004) [0x0000000000000000]              
	int                                                leadership;                                       		// 0x002C (0x0004) [0x0000000000000000]              
	int                                                destiny;                                          		// 0x0030 (0x0004) [0x0000000000000000]              
	int                                                minDamage;                                        		// 0x0034 (0x0004) [0x0000000000000000]              
	int                                                maxDamage;                                        		// 0x0038 (0x0004) [0x0000000000000000]              
	int                                                MaxManaBouns;                                     		// 0x003C (0x0004) [0x0000000000000000]              
	int                                                Movement;                                         		// 0x0040 (0x0004) [0x0000000000000000]              
	int                                                ArcaneKnowledgeBase;                              		// 0x0044 (0x0004) [0x0000000000000000]              
	TArray< struct FH7InventoryItem >                  Inventory;                                        		// 0x0048 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     HelmetArchRef;                                    		// 0x0058 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     WeaponArchRef;                                    		// 0x0068 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ChestArmorArchRef;                                		// 0x0078 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     GlovesArchRef;                                    		// 0x0088 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     ShoesArchRef;                                     		// 0x0098 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     NecklaceArchRef;                                  		// 0x00A8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Ring1ArchRef;                                     		// 0x00B8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     CapeArchRef;                                      		// 0x00C8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FH7SkillProxy >                     SkillRefs;                                        		// 0x00D8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           AbilityRefs;                                      		// 0x00E8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7HeroAbility* >                    AbilityArchs;                                     		// 0x00F8 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           SpellArchRefs;                                    		// 0x0108 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7BaseAbility* >                    SpellArchs;                                       		// 0x0118 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CampaignTransitionManager.H7TransistionMap
// 0x00000024
struct FH7TransistionMap
{
//	 vPoperty_Size=3
	unsigned long                                      Sealed : 1;                                       		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FString                                     MapFilename;                                      		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FH7TransitionHero >                 TransitionHeros;                                  		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7SkirmishSetupWindowCntl.H7DropDownEntry
// 0x00000048
struct FH7DropDownEntry
{
//	 vPoperty_Size=6
	struct FString                                     Caption;                                          		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Data;                                             		// 0x0010 (0x0004) [0x0000000000000000]              
	struct FString                                     strData;                                          		// 0x0014 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      Enabled : 1;                                      		// 0x0024 (0x0004) [0x0000000000000000] [0x00000001] 
	struct FString                                     Icon;                                             		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     Color;                                            		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CombatArmy.SClockwiseCircleDetectionPoint
// 0x00000014
struct FSClockwiseCircleDetectionPoint
{
//	 vPoperty_Size=3
	struct FIntPoint                                   coord;                                            		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              distanceSq;                                       		// 0x0008 (0x0004) [0x0000000000000000]              
	struct FVector2D                                   relativeCoordToCenter;                            		// 0x000C (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7CombatArmy.SAmbushDeploymentCircle
// 0x00000010
struct FSAmbushDeploymentCircle
{
//	 vPoperty_Size=1
	TArray< struct FIntPoint >                         Points;                                           		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CouncilGameInfo.CouncilTable
// 0x00000020
struct FCouncilTable
{
//	 vPoperty_Size=2
	struct FString                                     matineeName;                                      		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class AActor* >                            tableMeshes;                                      		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CouncilGameInfo.CampaignsMapData
// 0x00000018
struct FCampaignsMapData
{
//	 vPoperty_Size=2
	class UH7CampaignDefinition*                       campaignDef;                                      		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class AH7CouncilFlagActor* >               campaignFlags;                                    		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CouncilGameInfo.CampaignMapCameraZoom
// 0x00000030
struct FCampaignMapCameraZoom
{
//	 vPoperty_Size=6
	class AStaticMeshActor*                            StaticMesh;                                       		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      useFocusPoint : 1;                                		// 0x0008 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FVector                                     cameraFocusPoint;                                 		// 0x000C (0x000C) [0x0000000000000001]              ( CPF_Edit )
	class UH7CameraProperties*                         cameraProperty;                                   		// 0x0018 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AEmitter*                                    campaignPin;                                      		// 0x0020 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInstanceConstant*                   campaignSelectableMat;                            		// 0x0028 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7CouncilGameInfo.H7CouncilMapLight
// 0x0000000C
struct FH7CouncilMapLight
{
//	 vPoperty_Size=2
	class ALight*                                      mLight;                                           		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	float                                              mLightBrightness;                                 		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7CouncilGameInfo.CouncillorData
// 0x000000BC
struct FCouncillorData
{
//	 vPoperty_Size=e
	class UH7CampaignDefinition*                       councillorCampaign;                               		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FCampaignMapCameraZoom                      campaignSelectable;                               		// 0x0008 (0x0030) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     matineeName;                                      		// 0x0038 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned long                                      isIvan : 1;                                       		// 0x0048 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class UAkEvent*                                    StartCampaignVoiceOver;                           		// 0x004C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UAkEvent*                                    ContinueCampaignVoiceOver;                        		// 0x0054 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UAkEvent*                                    RestartCampaignVoiceOver;                         		// 0x005C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UAkEvent* >                          StartCampaignConfirmEvent;                        		// 0x0064 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class UAkEvent* >                          ContinueCampaignConfirmEvent;                     		// 0x0074 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class UAkEvent* >                          RestartCampaignConfirmEvent;                      		// 0x0084 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< class UAkEvent* >                          IvanCampaignSelectEvent;                          		// 0x0094 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FColor                                      mOutlineColor;                                    		// 0x00A4 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      mHoverColor;                                      		// 0x00A8 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< struct FH7CouncilMapLight >                mMapLights;                                       		// 0x00AC (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7CreatureStackBaseMover.H7PathPosition
// 0x00000014
struct FH7PathPosition
{
//	 vPoperty_Size=2
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	class UH7BaseCell*                                 cell;                                             		// 0x000C (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7EditorCameraHeightTool.CamHeight_VertexData
// 0x0000003C
struct FCamHeight_VertexData
{
//	 vPoperty_Size=6
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector2D                                   UV;                                               		// 0x000C (0x0008) [0x0000000000000000]              
	struct FVector                                     TangentX;                                         		// 0x0014 (0x000C) [0x0000000000000000]              
	struct FVector                                     TangentY;                                         		// 0x0020 (0x000C) [0x0000000000000000]              
	struct FVector                                     TangentZ;                                         		// 0x002C (0x000C) [0x0000000000000000]              
	struct FColor                                      Color;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7EditorCellOverlayComponent.CellOverlay_VertexData
// 0x0000003C
struct FCellOverlay_VertexData
{
//	 vPoperty_Size=6
	struct FVector                                     Position;                                         		// 0x0000 (0x000C) [0x0000000000000000]              
	struct FVector2D                                   UV;                                               		// 0x000C (0x0008) [0x0000000000000000]              
	struct FVector                                     TangentX;                                         		// 0x0014 (0x000C) [0x0000000000000000]              
	struct FVector                                     TangentY;                                         		// 0x0020 (0x000C) [0x0000000000000000]              
	struct FVector                                     TangentZ;                                         		// 0x002C (0x000C) [0x0000000000000000]              
	struct FColor                                      Color;                                            		// 0x0038 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7GFxSkirmishSetupWindow.PlayerLobbySelectedSettingsGUI
// 0x00000088
struct FPlayerLobbySelectedSettingsGUI
{
//	 vPoperty_Size=12
	unsigned char                                      mSlotState;                                       		// 0x0000 (0x0001) [0x0000000000000000]              
	struct FString                                     mName;                                            		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      mAIDifficulty;                                    		// 0x0014 (0x0001) [0x0000000000000000]              
	unsigned char                                      mTeam;                                            		// 0x0015 (0x0001) [0x0000000000000000]              
	struct FString                                     mStartHero;                                       		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     mStartHeroIcon;                                   		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     mStartHeroName;                                   		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      mStartHeroIsMight : 1;                            		// 0x0048 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                mStartHeroLevel;                                  		// 0x004C (0x0004) [0x0000000000000000]              
	struct FString                                     mStartHeroArchetypeID;                            		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned long                                      mHeropediaAvailable : 1;                          		// 0x0060 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned char                                      mColor;                                           		// 0x0064 (0x0001) [0x0000000000000000]              
	struct FString                                     mFaction;                                         		// 0x0068 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                mStartBonusIndex;                                 		// 0x0078 (0x0004) [0x0000000000000000]              
	unsigned char                                      mPosition;                                        		// 0x007C (0x0001) [0x0000000000000000]              
	int                                                mArmyIndex;                                       		// 0x0080 (0x0004) [0x0000000000000000]              
	unsigned long                                      mIsReady : 1;                                     		// 0x0084 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mPlayerStartAvailable : 1;                        		// 0x0084 (0x0004) [0x0000000000000000] [0x00000002] 
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGLandscapeTheme
// 0x00000018
struct FH7RMGLandscapeTheme
{
//	 vPoperty_Size=2
	struct FString                                     Name;                                             		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class UH7RMGTopologySetup*                         Setup;                                            		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGTemplateConnections
// 0x00000018
struct FH7RMGTemplateConnections
{
//	 vPoperty_Size=2
	class UH7RMGZoneTemplate*                          ZoneTemplate;                                     		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< int >                                      ConnectedIndexes;                                 		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGBuildingLight
// 0x00000014
struct FH7RMGBuildingLight
{
//	 vPoperty_Size=2
	class APointLight*                                 Light;                                            		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Offset;                                           		// 0x0008 (0x000C) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGLandscapeProperties
// 0x00000028
struct FH7RMGLandscapeProperties
{
//	 vPoperty_Size=6
	struct FIntPoint                                   GridSize;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	struct FIntPoint                                   QuadCount;                                        		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                ComponentSizeQuads;                               		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                SubsectionSizeQuads;                              		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FVector                                     Scale3D;                                          		// 0x0018 (0x000C) [0x0000000000000001]              ( CPF_Edit )
	int                                                AverageZoneSize;                                  		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGPathCells
// 0x00000010
struct FH7RMGPathCells
{
//	 vPoperty_Size=1
	TArray< class UH7RMGCell* >                        Path;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGPath
// 0x00000010
struct FH7RMGPath
{
//	 vPoperty_Size=1
	TArray< struct FVector2D >                         Path;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGShareBuildings
// 0x00000018
struct FH7RMGShareBuildings
{
//	 vPoperty_Size=7
	unsigned long                                      UseRichness : 1;                                  		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseBuildingDensity : 1;                           		// 0x0000 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      OnlyOneOfEach : 1;                                		// 0x0000 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      UniformDistribution : 1;                          		// 0x0000 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
	unsigned long                                      MostExpensiveFirst : 1;                           		// 0x0000 (0x0004) [0x0000000000000001] [0x00000010] ( CPF_Edit )
	unsigned char                                      ShareType;                                        		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7RMGBuilding* >                    Objects;                                          		// 0x0008 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGZoneTemplates
// 0x00000010
struct FH7RMGZoneTemplates
{
//	 vPoperty_Size=1
	TArray< class UH7RMGZoneTemplate* >                Templates;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGBuildingData
// 0x0000000C
struct FH7RMGBuildingData
{
//	 vPoperty_Size=2
	class UH7RMGBuilding*                              Building;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Amount;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGCreatureArray
// 0x00000010
struct FH7RMGCreatureArray
{
//	 vPoperty_Size=1
	TArray< class AH7Creature* >                       Creatures;                                        		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGFactionData
// 0x00000088
struct FH7RMGFactionData
{
//	 vPoperty_Size=5
	class UH7Faction*                                  Faction;                                          		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UH7RMGBuilding*                              Towns[ 0x4 ];                                     		// 0x0008 (0x0020) [0x0000000000000000]              
	class UH7RMGBuilding*                              Forts[ 0x3 ];                                     		// 0x0028 (0x0018) [0x0000000000000000]              
	class UH7RMGBuilding*                              Dwellings[ 0x3 ];                                 		// 0x0040 (0x0018) [0x0000000000000000]              
	struct FH7RMGCreatureArray                         Creatures[ 0x3 ];                                 		// 0x0058 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGRandomCreatureArray
// 0x00000010
struct FH7RMGRandomCreatureArray
{
//	 vPoperty_Size=1
	TArray< class AH7RandomCreatureStack* >            RandomCreatures;                                  		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGZoneInfluence
// 0x0000000C
struct FH7RMGZoneInfluence
{
//	 vPoperty_Size=2
	class UH7RMGZoneTemplate*                          ZoneTemplate;                                     		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              InfluenceValue;                                   		// 0x0008 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGCellPathfinderData
// 0x00000010
struct FH7RMGCellPathfinderData
{
//	 vPoperty_Size=3
	class UH7RMGCell*                                  Previous;                                         		// 0x0000 (0x0008) [0x0000000000000000]              
	float                                              GScore;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
	float                                              FScore;                                           		// 0x000C (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGGridColumns
// 0x00000010
struct FH7RMGGridColumns
{
//	 vPoperty_Size=1
	TArray< class UH7RMGCell* >                        Row;                                              		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGGridPart
// 0x00000010
struct FH7RMGGridPart
{
//	 vPoperty_Size=1
	TArray< struct FH7RMGGridColumns >                 Part;                                             		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGZoneTemplateRule
// 0x00000008
struct FH7RMGZoneTemplateRule
{
//	 vPoperty_Size=2
	unsigned char                                      LordType;                                         		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                MaxAmount;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGCellPair
// 0x00000010
struct FH7RMGCellPair
{
//	 vPoperty_Size=2
	class UH7RMGCell*                                  A;                                                		// 0x0000 (0x0008) [0x0000000000000000]              
	class UH7RMGCell*                                  B;                                                		// 0x0008 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGAtmosphericSetup
// 0x00000048
struct FH7RMGAtmosphericSetup
{
//	 vPoperty_Size=f
	unsigned long                                      OverrideAtmospherics : 1;                         		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              LightBrightness;                                  		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      LightColor;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      LightEnvironmentColor;                            		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              LightEnvironmentIntensity;                        		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              CloudShadowsDensity;                              		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              AtmosphericFogDensity;                            		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              AtmosphericFogBrightness;                         		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              AtmosphericFogHeightFalloff;                      		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FLinearColor                                AtmosphericFogColor;                              		// 0x0024 (0x0010) [0x0000000000000001]              ( CPF_Edit )
	float                                              AtmosphericFogHeightOffset;                       		// 0x0034 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              LightBrightnessMultiplierInGame;                  		// 0x0038 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              SkyLightBrightness;                               		// 0x003C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      SkyLightColor;                                    		// 0x0040 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FColor                                      SkyLightLowerColor;                               		// 0x0044 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGInGamePropertiesData
// 0x0000001C
struct FH7RMGInGamePropertiesData
{
//	 vPoperty_Size=a
	int                                                PlayerNumber;                                     		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      MapSize;                                          		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	int                                                Seed;                                             		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Richness;                                         		// 0x000C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      NeutralArmyStrength;                              		// 0x000D (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      WithTearOfAsha : 1;                               		// 0x0010 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      OverTile;                                         		// 0x0014 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnderTile;                                        		// 0x0015 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      WaterContent;                                     		// 0x0016 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      IsWaterContentRandom : 1;                         		// 0x0018 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGProperties
// 0x00000096
struct FH7RMGProperties
{
//	 vPoperty_Size=17
	unsigned char                                      MapSize;                                          		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      WithUnderground : 1;                              		// 0x0004 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                UndergroundPercentage;                            		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      LoadMap : 1;                                      		// 0x000C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                PlayerNumber;                                     		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Seed;                                             		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Richness;                                         		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              BuildingDensity;                                  		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                BaseCritterStrength;                              		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	TArray< class UH7RMGTopologySetup* >               SurfaceTopologySetup;                             		// 0x0024 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7RMGTopologySetup* >               UndergroundTopologySetup;                         		// 0x0034 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< struct FString >                           SurfaceTopologySetupPath;                         		// 0x0044 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	TArray< struct FString >                           UndergroundTopologySetupPath;                     		// 0x0054 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FString                                     DataPath;                                         		// 0x0064 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	class UH7RMGData*                                  Data;                                             		// 0x0074 (0x0008) [0x0000000000000000]              
	unsigned long                                      WithTearOfAsha : 1;                               		// 0x007C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      UseTemplate : 1;                                  		// 0x007C (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	class UH7RMGConnectionPrefab*                      ConnectionTemplate;                               		// 0x0080 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      SkipGameplayObjects : 1;                          		// 0x0088 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      WaterContent;                                     		// 0x008C (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      IsMinimapPreview : 1;                             		// 0x0090 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned char                                      OverTile;                                         		// 0x0094 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      UnderTile;                                        		// 0x0095 (0x0001) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGFoliageProperties
// 0x00000028
struct FH7RMGFoliageProperties
{
//	 vPoperty_Size=a
	unsigned long                                      DisableFoliage : 1;                               		// 0x0000 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	TArray< class UStaticMesh* >                       FoliageMeshes;                                    		// 0x0004 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	float                                              FoliageDensity;                                   		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                MaxClusterSize;                                   		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MinScale;                                         		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              MaxScale;                                         		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      AllignToNormal : 1;                               		// 0x0024 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	unsigned long                                      RandomYaw : 1;                                    		// 0x0024 (0x0004) [0x0000000000000001] [0x00000002] ( CPF_Edit )
	unsigned long                                      BlockActors : 1;                                  		// 0x0024 (0x0004) [0x0000000000000001] [0x00000004] ( CPF_Edit )
	unsigned long                                      CollideActors : 1;                                		// 0x0024 (0x0004) [0x0000000000000001] [0x00000008] ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGPreviewBuilding
// 0x0000001C
struct FH7RMGPreviewBuilding
{
//	 vPoperty_Size=5
	unsigned char                                      BuildingType;                                     		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FIntPoint                                   gridPos;                                          		// 0x0004 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UTexture2D*                                  MinimapIcon;                                      		// 0x000C (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      IsUnderground : 1;                                		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                PlayerPosNum;                                     		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGLayerInfo
// 0x0000002C
struct FH7RMGLayerInfo
{
//	 vPoperty_Size=6
	unsigned char                                      LayerType;                                        		// 0x0000 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      NoBlend : 1;                                      		// 0x0004 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FName                                       LayerName;                                        		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Position;                                         		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	class UH7LandscapeGameLayerInfoData*               LayerGameData;                                    		// 0x0014 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	TArray< unsigned char >                            Data;                                             		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGLayerInfos
// 0x00000010
struct FH7RMGLayerInfos
{
//	 vPoperty_Size=1
	TArray< struct FH7RMGLayerInfo >                   Infos;                                            		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7PerlinNoiseProperties
// 0x00000038
struct FH7PerlinNoiseProperties
{
//	 vPoperty_Size=e
	int                                                Iterations;                                       		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Amplitude;                                        		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Frequency;                                        		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              Persitency;                                       		// 0x000C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Octaves;                                          		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              HeightMod1;                                       		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              HeightMod2;                                       		// 0x0018 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              PeturbationModifer;                               		// 0x001C (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      IncludeMapBorder : 1;                             		// 0x0020 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                GlobalRaiseLower;                                 		// 0x0024 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              GlobalRaiseLowerThreshold;                        		// 0x0028 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      ClampNoiseResult : 1;                             		// 0x002C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	float                                              NoiseClampMin;                                    		// 0x0030 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              NoiseClampMax;                                    		// 0x0034 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGWeightmapProperties
// 0x00000040
struct FH7RMGWeightmapProperties
{
//	 vPoperty_Size=3
	int                                                MaxCliffSlope;                                    		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	float                                              CoastHeightMod;                                   		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	struct FH7PerlinNoiseProperties                    DecoNoise;                                        		// 0x0008 (0x0038) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7RMGStructsAndEnums.H7RMGErosionProperties
// 0x0000000C
struct FH7RMGErosionProperties
{
//	 vPoperty_Size=3
	int                                                Iterations;                                       		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Treshold;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Smoothness;                                       		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7GFxLoaderManager.LoaderEntry
// 0x00000030
struct FLoaderEntry
{
//	 vPoperty_Size=4
	struct FString                                     Filename;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	class USwfMovie*                                   Movie;                                            		// 0x0010 (0x0008) [0x0000000000000000]              
	class UH7FlashMovieCntl*                           Controller;                                       		// 0x0018 (0x0008) [0x0000000000000000]              
	struct FScriptDelegate                             callbackFunction;                                 		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0024 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.H7OptionsManager.OptionBoolStruct
// 0x00000020
struct FOptionBoolStruct
{
//	 vPoperty_Size=2
	struct FScriptDelegate                             SetFunction;                                      		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0004 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             GetFunction;                                      		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0014 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.H7OptionsManager.OptionFloatStruct
// 0x00000030
struct FOptionFloatStruct
{
//	 vPoperty_Size=3
	struct FScriptDelegate                             SetFunction;                                      		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0004 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             GetFunction;                                      		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0014 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             GetConstraintsFunction;                           		// 0x0020 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0024 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.H7OptionsManager.OptionEnumStruct
// 0x00000030
struct FOptionEnumStruct
{
//	 vPoperty_Size=3
	struct FScriptDelegate                             SetFunction;                                      		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData00[ 0x4 ];                             		// 0x0004 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             GetFunction;                                      		// 0x0010 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData01[ 0x4 ];                             		// 0x0014 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	struct FScriptDelegate                             GetListFunction;                                  		// 0x0020 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      UnknownData02[ 0x4 ];                             		// 0x0024 (0x0004) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.H7OptionsManager.OptionKeyStruct
// 0x00000050
struct FOptionKeyStruct
{
//	 vPoperty_Size=1
	struct FH7Keybind                                  KeyBind;                                          		// 0x0000 (0x0050) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7OptionsManager.OptionStruct
// 0x000000E8
struct FOptionStruct
{
//	 vPoperty_Size=9
	struct FString                                     IDkey;                                            		// 0x0000 (0x0010) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	unsigned char                                      Category;                                         		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Type;                                             		// 0x0011 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Mode;                                             		// 0x0012 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      Enabled : 1;                                      		// 0x0014 (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	struct FOptionBoolStruct                           boolFunctions;                                    		// 0x0018 (0x0020) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FOptionFloatStruct                          floatFunctions;                                   		// 0x0038 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FOptionEnumStruct                           enumFunctions;                                    		// 0x0068 (0x0030) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
	struct FOptionKeyStruct                            keybindFunctions;                                 		// 0x0098 (0x0050) [0x0000000000400001]              ( CPF_Edit | CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7GfxRandomSkillingPopUp.H7RandomSkillData
// 0x00000000
struct FH7RandomSkillData
{
//	 vPoperty_Size=0
};

// ScriptStruct MMH7Game.H7GfxRandomSkillingPopUp.H7SkillAbilityData
// 0x00000060
struct FH7SkillAbilityData
{
//	 vPoperty_Size=a
	struct FString                                     AbilityName;                                      		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                abilityRank;                                      		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                skillLevel;                                       		// 0x0014 (0x0004) [0x0000000000000000]              
	struct FString                                     skillLevelStr;                                    		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     IconPath;                                         		// 0x0028 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     abilityID;                                        		// 0x0038 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                SkillID;                                          		// 0x0048 (0x0004) [0x0000000000000000]              
	unsigned long                                      learned : 1;                                      		// 0x004C (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      isUltimate : 1;                                   		// 0x004C (0x0004) [0x0000000000000000] [0x00000002] 
	struct FString                                     skillname;                                        		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7GFxUplayNote.H7UplayData
// 0x00000028
struct FH7UplayData
{
//	 vPoperty_Size=4
	struct FString                                     headline;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     subline;                                          		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                Currency;                                         		// 0x0020 (0x0004) [0x0000000000000000]              
	int                                                XP;                                               		// 0x0024 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7HeroItem.CustomArtefactBonusEffectInfo
// 0x00000028
struct FCustomArtefactBonusEffectInfo
{
//	 vPoperty_Size=4
	struct FString                                     effectId;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	int                                                GroupID;                                          		// 0x0010 (0x0004) [0x0000000000000000]              
	int                                                bonusIndex;                                       		// 0x0014 (0x0004) [0x0000000000000000]              
	struct FString                                     ToolTip;                                          		// 0x0018 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7LandscapeGenerator.LandscapeGeneratorMapSizePreference
// 0x00000014
struct FLandscapeGeneratorMapSizePreference
{
//	 vPoperty_Size=5
	unsigned char                                      MapSize;                                          		// 0x0000 (0x0001) [0x0000000000000000]              
	int                                                Width;                                            		// 0x0004 (0x0004) [0x0000000000000000]              
	int                                                Height;                                           		// 0x0008 (0x0004) [0x0000000000000000]              
	int                                                SubsectionSizeQuads;                              		// 0x000C (0x0004) [0x0000000000000000]              
	int                                                NumSubsections;                                   		// 0x0010 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7LandscapeGenerator.LandscapeGeneratorTypePreference
// 0x00000034
struct FLandscapeGeneratorTypePreference
{
//	 vPoperty_Size=5
	unsigned char                                      LandscapeType;                                    		// 0x0000 (0x0001) [0x0000000000000000]              
	class UMaterialInterface*                          Material;                                         		// 0x0004 (0x0008) [0x0000000000000000]              
	TArray< struct FName >                             LayerNames;                                       		// 0x000C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	TArray< class UH7LandscapeGameLayerInfoData* >     gameData;                                         		// 0x001C (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FName                                       DefaultLayer;                                     		// 0x002C (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7ListeningManager.H7ListeningEntry
// 0x00000021
struct FH7ListeningEntry
{
//	 vPoperty_Size=4
	class UGFxObject*                                  mListener;                                        		// 0x0000 (0x0008) [0x0000000000000000]              
	class UH7GUIConnector*                             mListener2;                                       		// 0x0008 (0x0008) [0x0000000000000000]              
	class UH7IGUIListenable*                           mListenee;                                        		// 0x0010 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0018 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
	unsigned char                                      mFocus;                                           		// 0x0020 (0x0001) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7ObjectLayerFilterConfig.ObjectLayerFilter
// 0x00000060
struct FObjectLayerFilter
{
//	 vPoperty_Size=6
	struct FString                                     RootPath;                                         		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     MatchedPrefix;                                    		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     MatchedPackage;                                   		// 0x0020 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     IgnoredPackage;                                   		// 0x0030 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     MatchedClass;                                     		// 0x0040 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     IgnoredAsset;                                     		// 0x0050 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7RandomTreasureChest.H7TreasureChestRewards
// 0x00000008
struct FH7TreasureChestRewards
{
//	 vPoperty_Size=2
	int                                                GoldAmount;                                       		// 0x0000 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                xpAmount;                                         		// 0x0004 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7SavegameTaskSlotManager.H7SavegameTask_SlotLocking
// 0x0000000C
struct FH7SavegameTask_SlotLocking
{
//	 vPoperty_Size=2
	int                                                SlotIndex;                                        		// 0x0000 (0x0004) [0x0000000000000000]              
	class UH7SavegameTask_Base*                        AssociatedTask;                                   		// 0x0004 (0x0008) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7SeqAct_BaseDialogue.H7DialogueLine
// 0x00000040
struct FH7DialogueLine
{
//	 vPoperty_Size=b
	unsigned long                                      mIsDialogue : 1;                                  		// 0x0000 (0x0004) [0x0000000000000000] [0x00000001] 
	unsigned long                                      mIsSpeakerEnabled : 1;                            		// 0x0000 (0x0004) [0x0000000000022000] [0x00000002] ( CPF_Transient | CPF_EditConst )
	unsigned long                                      mIsPositionEnabled : 1;                           		// 0x0000 (0x0004) [0x0000000000022000] [0x00000004] ( CPF_Transient | CPF_EditConst )
	unsigned char                                      SpeakerType;                                      		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class AH7EditorHero*                               speaker;                                          		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      Position;                                         		// 0x0010 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	struct FString                                     Content;                                          		// 0x0014 (0x0010) [0x0000000000408003]              ( CPF_Edit | CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	class AH7EditorHero*                               Listener;                                         		// 0x0024 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      activeHeroListens : 1;                            		// 0x002C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	class UAkEvent*                                    mStartVoiceOver;                                  		// 0x0030 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UAkEvent*                                    mStopVoiceOver;                                   		// 0x0038 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7SeqAct_Quest_NewNode.H7QuestReward
// 0x00000024
struct FH7QuestReward
{
//	 vPoperty_Size=a
	unsigned long                                      bRewardResource : 1;                              		// 0x0000 (0x0004) [0x0000000000022000] [0x00000001] ( CPF_Transient | CPF_EditConst )
	unsigned long                                      bRewardAttribute : 1;                             		// 0x0000 (0x0004) [0x0000000000022000] [0x00000002] ( CPF_Transient | CPF_EditConst )
	unsigned long                                      bRewardArtifact : 1;                              		// 0x0000 (0x0004) [0x0000000000022000] [0x00000004] ( CPF_Transient | CPF_EditConst )
	unsigned long                                      bRewardCreature : 1;                              		// 0x0000 (0x0004) [0x0000000000022000] [0x00000008] ( CPF_Transient | CPF_EditConst )
	unsigned char                                      RewardType;                                       		// 0x0004 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      RewardAttribute;                                  		// 0x0005 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	class UH7HeroItem*                                 RewardArtifact;                                   		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class AH7Creature*                                 RewardCreature;                                   		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UH7Resource*                                 RewardResource;                                   		// 0x0018 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                RewardValue;                                      		// 0x0020 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7SeqAct_Quest_NewNode.H7ObjectiveBufferEntry
// 0x00000014
struct FH7ObjectiveBufferEntry
{
//	 vPoperty_Size=2
	unsigned char                                      NewStatus;                                        		// 0x0000 (0x0001) [0x0000000000000000]              
	struct FString                                     Line;                                             		// 0x0004 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.H7SeqAct_ShowCouncilDialogue.H7CouncilDialogueLine
// 0x00000018
struct FH7CouncilDialogueLine
{
//	 vPoperty_Size=2
	struct FString                                     Content;                                          		// 0x0000 (0x0010) [0x0000000000408003]              ( CPF_Edit | CPF_Const | CPF_Localized | CPF_NeedCtorLink )
	class UAkEvent*                                    mStopVoiceOver;                                   		// 0x0010 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7SeqCon_HasResourcePercentage.H7ResourceAmount
// 0x0000000C
struct FH7ResourceAmount
{
//	 vPoperty_Size=2
	class UH7Resource*                                 Type;                                             		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	int                                                Amount;                                           		// 0x0008 (0x0004) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.H7SeqCon_HoldCreatures.H7CreatureDat
// 0x00000024
struct FH7CreatureDat
{
//	 vPoperty_Size=8
	class AH7Creature*                                 Creature;                                         		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	unsigned char                                      mOper;                                            		// 0x0008 (0x0001) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      usePercent : 1;                                   		// 0x000C (0x0004) [0x0000000000000001] [0x00000001] ( CPF_Edit )
	int                                                Amount;                                           		// 0x0010 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	int                                                Percent;                                          		// 0x0014 (0x0004) [0x0000000000000001]              ( CPF_Edit )
	unsigned long                                      InitedArmyCreatureAmount : 1;                     		// 0x0018 (0x0004) [0x0000000000000000] [0x00000001] 
	int                                                InitAmount;                                       		// 0x001C (0x0004) [0x0000000000000000]              
	int                                                PreviousAmount;                                   		// 0x0020 (0x0004) [0x0000000000000000]              
};

// ScriptStruct MMH7Game.H7TownAsset.H7TownAssetMaterial
// 0x00000010
struct FH7TownAssetMaterial
{
//	 vPoperty_Size=2
	class UMaterialInterface*                          materialHovered;                                  		// 0x0000 (0x0008) [0x0000000000000001]              ( CPF_Edit )
	class UMaterialInterface*                          materialUnhovered;                                		// 0x0008 (0x0008) [0x0000000000000001]              ( CPF_Edit )
};

// ScriptStruct MMH7Game.PlayerProfileState.HeroTransitionSaveStruct
// 0x00000020
struct FHeroTransitionSaveStruct
{
//	 vPoperty_Size=2
	struct FString                                     mHeroArchetypeName;                               		// 0x0000 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
	struct FString                                     mSerializedHeroes;                                		// 0x0010 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};

// ScriptStruct MMH7Game.SaveGameState.DeserializeData
// 0x00000018
struct FDeserializeData
{
//	 vPoperty_Size=2
	class UJsonObject*                                 JsonObj;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	class USaveGameStateInterface*                     ActorInterface;                                   		// 0x0008 (0x0010) [0x0000000000000000]              
	unsigned char                                      UnknownData00[ 0x8 ];                             		// 0x0010 (0x0008) FIX WRONG TYPE SIZE OF PREVIUS PROPERTY
};

// ScriptStruct MMH7Game.SaveGameState.KismetDeserializeData
// 0x00000018
struct FKismetDeserializeData
{
//	 vPoperty_Size=2
	class UJsonObject*                                 JsonObj;                                          		// 0x0000 (0x0008) [0x0000000000000000]              
	struct FString                                     KismetObjectName;                                 		// 0x0008 (0x0010) [0x0000000000400000]              ( CPF_NeedCtorLink )
};


#ifdef _MSC_VER
	#pragma pack ( pop )
#endif