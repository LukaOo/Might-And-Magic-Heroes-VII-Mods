#pragma once 

/*
#############################################################################################
# Might and Magic Heroes 7 (1.0.8364.0) SDK
# Generated with TheFeckless UE3 SDK Generator v1.4_Beta-Rev.51 x64
# ========================================================================================= #
# File: SdkHeaders.h
# ========================================================================================= #
# Credits: uNrEaL, Tamimego, SystemFiles, R00T88, _silencer, the1domo, K@N@VEL
# Thanks: HOOAH07, lowHertz
# Forums: www.uc-forum.com, www.gamedeception.net
#############################################################################################
*/
#include "SdkBase.h"
/*
# ========================================================================================= #
# Includes
# ========================================================================================= #
*/

#include "SDK_HEADERS\Core_structs.h"
#include "SDK_HEADERS\Core_classes.h"
#include "SDK_HEADERS\Core_f_structs.h"
#include "SDK_HEADERS\Core_functions.h"
#include "SDK_HEADERS\Engine_structs.h"
#include "SDK_HEADERS\Engine_classes.h"
#include "SDK_HEADERS\Engine_f_structs.h"
#include "SDK_HEADERS\Engine_functions.h"
#include "SDK_HEADERS\GameFramework_structs.h"
#include "SDK_HEADERS\GameFramework_classes.h"
#include "SDK_HEADERS\GameFramework_f_structs.h"
#include "SDK_HEADERS\GameFramework_functions.h"
#include "SDK_HEADERS\IpDrv_structs.h"
#include "SDK_HEADERS\IpDrv_classes.h"
#include "SDK_HEADERS\IpDrv_f_structs.h"
#include "SDK_HEADERS\IpDrv_functions.h"
#include "SDK_HEADERS\XAudio2_structs.h"
#include "SDK_HEADERS\XAudio2_classes.h"
#include "SDK_HEADERS\XAudio2_f_structs.h"
#include "SDK_HEADERS\XAudio2_functions.h"
#include "SDK_HEADERS\GFxUI_structs.h"
#include "SDK_HEADERS\GFxUI_classes.h"
#include "SDK_HEADERS\GFxUI_f_structs.h"
#include "SDK_HEADERS\GFxUI_functions.h"
#include "SDK_HEADERS\AkAudio_structs.h"
#include "SDK_HEADERS\AkAudio_classes.h"
#include "SDK_HEADERS\AkAudio_f_structs.h"
#include "SDK_HEADERS\AkAudio_functions.h"
#include "SDK_HEADERS\WinDrv_structs.h"
#include "SDK_HEADERS\WinDrv_classes.h"
#include "SDK_HEADERS\WinDrv_f_structs.h"
#include "SDK_HEADERS\WinDrv_functions.h"
#include "SDK_HEADERS\OnlineSubsystemUPlay_structs.h"
#include "SDK_HEADERS\OnlineSubsystemUPlay_classes.h"
#include "SDK_HEADERS\OnlineSubsystemUPlay_f_structs.h"
#include "SDK_HEADERS\OnlineSubsystemUPlay_functions.h"
#include "SDK_HEADERS\UnrealEd_structs.h"
#include "SDK_HEADERS\UnrealEd_classes.h"
#include "SDK_HEADERS\UnrealEd_f_structs.h"
#include "SDK_HEADERS\UnrealEd_functions.h"
#include "SDK_HEADERS\MMH7Engine_structs.h"
#include "SDK_HEADERS\MMH7Engine_classes.h"
#include "SDK_HEADERS\MMH7Engine_f_structs.h"
#include "SDK_HEADERS\MMH7Engine_functions.h"
#include "SDK_HEADERS\MMH7Game_structs.h"
#include "SDK_HEADERS\MMH7Game_classes.h"
#include "SDK_HEADERS\MMH7Game_f_structs.h"
#include "SDK_HEADERS\MMH7Game_functions.h"

/*
# ========================================================================================= #
# Statics initializations
# ========================================================================================= #
*/

UClass* UObject::pClassPointer = NULL;

UClass* UTextBuffer::pClassPointer = NULL;

UClass* USubsystem::pClassPointer = NULL;

UClass* USystem::pClassPointer = NULL;

UClass* UPackageMap::pClassPointer = NULL;

UClass* UObjectSerializer::pClassPointer = NULL;

UClass* UObjectRedirector::pClassPointer = NULL;

UClass* UMetaData::pClassPointer = NULL;

UClass* ULinker::pClassPointer = NULL;

UClass* ULinkerSave::pClassPointer = NULL;

UClass* ULinkerLoad::pClassPointer = NULL;

UClass* UInterface::pClassPointer = NULL;

UClass* UField::pClassPointer = NULL;

UClass* UStruct::pClassPointer = NULL;

UClass* UScriptStruct::pClassPointer = NULL;

UClass* UFunction::pClassPointer = NULL;

UClass* UProperty::pClassPointer = NULL;

UClass* UStructProperty::pClassPointer = NULL;

UClass* UStrProperty::pClassPointer = NULL;

UClass* UObjectProperty::pClassPointer = NULL;

UClass* UDynLoadObjectProperty::pClassPointer = NULL;

UClass* UComponentProperty::pClassPointer = NULL;

UClass* UClassProperty::pClassPointer = NULL;

UClass* UNameProperty::pClassPointer = NULL;

UClass* UMapProperty::pClassPointer = NULL;

UClass* UIntProperty::pClassPointer = NULL;

UClass* UInterfaceProperty::pClassPointer = NULL;

UClass* UFloatProperty::pClassPointer = NULL;

UClass* UDelegateProperty::pClassPointer = NULL;

UClass* UByteProperty::pClassPointer = NULL;

UClass* UBoolProperty::pClassPointer = NULL;

UClass* UArrayProperty::pClassPointer = NULL;

UClass* UEnum::pClassPointer = NULL;

UClass* UConst::pClassPointer = NULL;

UClass* UFactory::pClassPointer = NULL;

UClass* UTextBufferFactory::pClassPointer = NULL;

UClass* UExporter::pClassPointer = NULL;

UClass* UComponent::pClassPointer = NULL;

UClass* UDistributionVector::pClassPointer = NULL;

UClass* UDistributionFloat::pClassPointer = NULL;

UClass* UCommandlet::pClassPointer = NULL;

UClass* UHelpCommandlet::pClassPointer = NULL;

UClass* UState::pClassPointer = NULL;

UClass* UPackage::pClassPointer = NULL;

UClass* UClass::pClassPointer = NULL;

UClass* AActor::pClassPointer = NULL;

UClass* AInfo::pClassPointer = NULL;

UClass* AZoneInfo::pClassPointer = NULL;

UClass* AWorldInfo::pClassPointer = NULL;

UClass* UDownloadableContentEnumerator::pClassPointer = NULL;

UClass* UDownloadableContentManager::pClassPointer = NULL;

UClass* UEngine::pClassPointer = NULL;

UClass* UGameEngine::pClassPointer = NULL;

UClass* UEngineBaseTypes::pClassPointer = NULL;

UClass* ABrush::pClassPointer = NULL;

UClass* ABrushShape::pClassPointer = NULL;

UClass* AVolume::pClassPointer = NULL;

UClass* ABlockingVolume::pClassPointer = NULL;

UClass* ADynamicBlockingVolume::pClassPointer = NULL;

UClass* ACullDistanceVolume::pClassPointer = NULL;

UClass* AH7LightmassEnvironmentSphere::pClassPointer = NULL;

UClass* ALevelGridVolume::pClassPointer = NULL;

UClass* ALevelStreamingVolume::pClassPointer = NULL;

UClass* ALightmassCharacterIndirectDetailVolume::pClassPointer = NULL;

UClass* ALightmassImportanceVolume::pClassPointer = NULL;

UClass* AMassiveLODOverrideVolume::pClassPointer = NULL;

UClass* APathBlockingVolume::pClassPointer = NULL;

UClass* APhysicsVolume::pClassPointer = NULL;

UClass* ADefaultPhysicsVolume::pClassPointer = NULL;

UClass* AGravityVolume::pClassPointer = NULL;

UClass* ALadderVolume::pClassPointer = NULL;

UClass* APortalVolume::pClassPointer = NULL;

UClass* APostProcessVolume::pClassPointer = NULL;

UClass* APrecomputedVisibilityOverrideVolume::pClassPointer = NULL;

UClass* APrecomputedVisibilityVolume::pClassPointer = NULL;

UClass* AReverbVolume::pClassPointer = NULL;

UClass* ATriggerVolume::pClassPointer = NULL;

UClass* ADroppedPickup::pClassPointer = NULL;

UClass* ADynamicSMActor::pClassPointer = NULL;

UClass* ADynamicSMActor_Spawnable::pClassPointer = NULL;

UClass* AInterpActor::pClassPointer = NULL;

UClass* AEmitter::pClassPointer = NULL;

UClass* AEmitterPool::pClassPointer = NULL;

UClass* AH7UnrealObjectCellMarker::pClassPointer = NULL;

UClass* AHUD::pClassPointer = NULL;

UClass* AAutoTestManager::pClassPointer = NULL;

UClass* ACoverGroup::pClassPointer = NULL;

UClass* AFileWriter::pClassPointer = NULL;

UClass* AFileLog::pClassPointer = NULL;

UClass* AGameInfo::pClassPointer = NULL;

UClass* AMutator::pClassPointer = NULL;

UClass* APotentialClimbWatcher::pClassPointer = NULL;

UClass* ARoute::pClassPointer = NULL;

UClass* AWindPointSource::pClassPointer = NULL;

UClass* AInventory::pClassPointer = NULL;

UClass* AWeapon::pClassPointer = NULL;

UClass* AInventoryManager::pClassPointer = NULL;

UClass* AKeypoint::pClassPointer = NULL;

UClass* ATargetPoint::pClassPointer = NULL;

UClass* AMaterialInstanceActor::pClassPointer = NULL;

UClass* AMatineeActor::pClassPointer = NULL;

UClass* ANavigationPoint::pClassPointer = NULL;

UClass* ACoverLink::pClassPointer = NULL;

UClass* ADoorMarker::pClassPointer = NULL;

UClass* ADynamicAnchor::pClassPointer = NULL;

UClass* ALadder::pClassPointer = NULL;

UClass* AAutoLadder::pClassPointer = NULL;

UClass* ALiftCenter::pClassPointer = NULL;

UClass* ALiftExit::pClassPointer = NULL;

UClass* APathNode::pClassPointer = NULL;

UClass* AVolumePathNode::pClassPointer = NULL;

UClass* APickupFactory::pClassPointer = NULL;

UClass* APlayerStart::pClassPointer = NULL;

UClass* APortalMarker::pClassPointer = NULL;

UClass* APylon::pClassPointer = NULL;

UClass* AAISwitchablePylon::pClassPointer = NULL;

UClass* ADynamicPylon::pClassPointer = NULL;

UClass* ATeleporter::pClassPointer = NULL;

UClass* ANote::pClassPointer = NULL;

UClass* AProjectile::pClassPointer = NULL;

UClass* ARigidBodyBase::pClassPointer = NULL;

UClass* ASceneCaptureActor::pClassPointer = NULL;

UClass* ASceneCapture2DActor::pClassPointer = NULL;

UClass* ASceneCapture2DSpecificActor::pClassPointer = NULL;

UClass* ASceneCaptureCubeMapActor::pClassPointer = NULL;

UClass* ASceneCaptureReflectActor::pClassPointer = NULL;

UClass* ASceneCapturePortalActor::pClassPointer = NULL;

UClass* APortalTeleporter::pClassPointer = NULL;

UClass* AStaticMeshActorBase::pClassPointer = NULL;

UClass* AStaticMeshActor::pClassPointer = NULL;

UClass* AStaticMeshCollectionActor::pClassPointer = NULL;

UClass* AStaticMeshActorBasedOnExtremeContent::pClassPointer = NULL;

UClass* ATrigger::pClassPointer = NULL;

UClass* ATrigger_PawnsOnly::pClassPointer = NULL;

UClass* UActorComponent::pClassPointer = NULL;

UClass* UAudioComponent::pClassPointer = NULL;

UClass* USplineAudioComponent::pClassPointer = NULL;

UClass* UMultiCueSplineAudioComponent::pClassPointer = NULL;

UClass* USimpleSplineAudioComponent::pClassPointer = NULL;

UClass* USimpleSplineNonLoopAudioComponent::pClassPointer = NULL;

UClass* UHeightFogComponent::pClassPointer = NULL;

UClass* UPrimitiveComponent::pClassPointer = NULL;

UClass* UArrowComponent::pClassPointer = NULL;

UClass* UBrushComponent::pClassPointer = NULL;

UClass* UCameraConeComponent::pClassPointer = NULL;

UClass* UCylinderComponent::pClassPointer = NULL;

UClass* UDrawBoxComponent::pClassPointer = NULL;

UClass* UDrawCapsuleComponent::pClassPointer = NULL;

UClass* UDrawConeComponent::pClassPointer = NULL;

UClass* UDrawCylinderComponent::pClassPointer = NULL;

UClass* UDrawFrustumComponent::pClassPointer = NULL;

UClass* UDrawQuadComponent::pClassPointer = NULL;

UClass* UDrawSphereComponent::pClassPointer = NULL;

UClass* UDrawPylonRadiusComponent::pClassPointer = NULL;

UClass* UDrawSoundRadiusComponent::pClassPointer = NULL;

UClass* ULevelGridVolumeRenderingComponent::pClassPointer = NULL;

UClass* ULineBatchComponent::pClassPointer = NULL;

UClass* UModelComponent::pClassPointer = NULL;

UClass* USpriteComponent::pClassPointer = NULL;

UClass* URadialBlurComponent::pClassPointer = NULL;

UClass* USceneCaptureComponent::pClassPointer = NULL;

UClass* USceneCapture2DComponent::pClassPointer = NULL;

UClass* USceneCapture2DSpecificComponent::pClassPointer = NULL;

UClass* USceneCapture2DHitMaskComponent::pClassPointer = NULL;

UClass* USceneCaptureCubeMapComponent::pClassPointer = NULL;

UClass* USceneCapturePortalComponent::pClassPointer = NULL;

UClass* USceneCaptureReflectComponent::pClassPointer = NULL;

UClass* UWindDirectionalSourceComponent::pClassPointer = NULL;

UClass* UWindPointSourceComponent::pClassPointer = NULL;

UClass* UActorFactory::pClassPointer = NULL;

UClass* UActorFactoryActor::pClassPointer = NULL;

UClass* UActorFactoryAI::pClassPointer = NULL;

UClass* UActorFactoryAmbientSound::pClassPointer = NULL;

UClass* UActorFactoryAmbientSoundMovable::pClassPointer = NULL;

UClass* UActorFactoryAmbientSoundSimple::pClassPointer = NULL;

UClass* UActorFactoryAmbientSoundNonLoop::pClassPointer = NULL;

UClass* UActorFactoryAmbientSoundSimpleToggleable::pClassPointer = NULL;

UClass* UActorFactoryAmbientSoundNonLoopingToggleable::pClassPointer = NULL;

UClass* UActorFactoryApexDestructible::pClassPointer = NULL;

UClass* UActorFactoryArchetype::pClassPointer = NULL;

UClass* UActorFactoryCoverLink::pClassPointer = NULL;

UClass* UActorFactoryDominantDirectionalLight::pClassPointer = NULL;

UClass* UActorFactoryDominantDirectionalLightMovable::pClassPointer = NULL;

UClass* UActorFactoryDynamicSM::pClassPointer = NULL;

UClass* UActorFactoryMover::pClassPointer = NULL;

UClass* UActorFactoryRigidBody::pClassPointer = NULL;

UClass* UActorFactoryEmitter::pClassPointer = NULL;

UClass* UActorFactoryFracturedStaticMesh::pClassPointer = NULL;

UClass* UActorFactoryLensFlare::pClassPointer = NULL;

UClass* UActorFactoryLight::pClassPointer = NULL;

UClass* UActorFactoryPathNode::pClassPointer = NULL;

UClass* UActorFactoryPhysicsAsset::pClassPointer = NULL;

UClass* UActorFactoryPlayerStart::pClassPointer = NULL;

UClass* UActorFactoryPylon::pClassPointer = NULL;

UClass* UActorFactorySkeletalMesh::pClassPointer = NULL;

UClass* UActorFactoryStaticMesh::pClassPointer = NULL;

UClass* UActorFactoryTrigger::pClassPointer = NULL;

UClass* UActorFactoryVehicle::pClassPointer = NULL;

UClass* UAkBank::pClassPointer = NULL;

UClass* UAkBaseSoundObject::pClassPointer = NULL;

UClass* UAkEvent::pClassPointer = NULL;

UClass* USoundCue::pClassPointer = NULL;

UClass* UBookMark::pClassPointer = NULL;

UClass* UBookMark2D::pClassPointer = NULL;

UClass* UKismetBookMark::pClassPointer = NULL;

UClass* UCanvas::pClassPointer = NULL;

UClass* UChannel::pClassPointer = NULL;

UClass* UActorChannel::pClassPointer = NULL;

UClass* UControlChannel::pClassPointer = NULL;

UClass* UFileChannel::pClassPointer = NULL;

UClass* UVoiceChannel::pClassPointer = NULL;

UClass* AController::pClassPointer = NULL;

UClass* APlayerController::pClassPointer = NULL;

UClass* UCheatManager::pClassPointer = NULL;

UClass* UClient::pClassPointer = NULL;

UClass* UClipPadEntry::pClassPointer = NULL;

UClass* UCloudSaveSystem::pClassPointer = NULL;

UClass* UCodecMovie::pClassPointer = NULL;

UClass* UCodecMovieBink::pClassPointer = NULL;

UClass* UCodecMovieFallback::pClassPointer = NULL;

UClass* UCurveEdPresetCurve::pClassPointer = NULL;

UClass* UCustomPropertyItemHandler::pClassPointer = NULL;

UClass* UDamageType::pClassPointer = NULL;

UClass* UKillZDamageType::pClassPointer = NULL;

UClass* UDistributionFloatConstant::pClassPointer = NULL;

UClass* UDistributionFloatParameterBase::pClassPointer = NULL;

UClass* UDistributionFloatConstantCurve::pClassPointer = NULL;

UClass* UDistributionFloatUniform::pClassPointer = NULL;

UClass* UDistributionFloatUniformCurve::pClassPointer = NULL;

UClass* UDistributionFloatUniformRange::pClassPointer = NULL;

UClass* UDistributionVectorConstant::pClassPointer = NULL;

UClass* UDistributionVectorParameterBase::pClassPointer = NULL;

UClass* UDistributionVectorConstantCurve::pClassPointer = NULL;

UClass* UDistributionVectorUniform::pClassPointer = NULL;

UClass* UDistributionVectorUniformCurve::pClassPointer = NULL;

UClass* UDistributionVectorUniformRange::pClassPointer = NULL;

UClass* UDownload::pClassPointer = NULL;

UClass* UChannelDownload::pClassPointer = NULL;

UClass* UEdCoordSystem::pClassPointer = NULL;

UClass* UEditorLinkSelectionInterface::pClassPointer = NULL;

UClass* UEngineTypes::pClassPointer = NULL;

UClass* UFaceFXAnimSet::pClassPointer = NULL;

UClass* UFaceFXAsset::pClassPointer = NULL;

UClass* UFont::pClassPointer = NULL;

UClass* UMultiFont::pClassPointer = NULL;

UClass* UFontImportOptions::pClassPointer = NULL;

UClass* UForceFeedbackManager::pClassPointer = NULL;

UClass* UForceFeedbackWaveform::pClassPointer = NULL;

UClass* UGameplayEvents::pClassPointer = NULL;

UClass* UGameplayEventsReader::pClassPointer = NULL;

UClass* UGameplayEventsWriterBase::pClassPointer = NULL;

UClass* UGameplayEventsUploadAnalytics::pClassPointer = NULL;

UClass* UGameplayEventsWriter::pClassPointer = NULL;

UClass* UGameplayEventsHandler::pClassPointer = NULL;

UClass* UGenericParamListStatEntry::pClassPointer = NULL;

UClass* UGuidCache::pClassPointer = NULL;

UClass* UH7LightmassEnvironmentSphereInterface::pClassPointer = NULL;

UClass* UHttpBaseInterface::pClassPointer = NULL;

UClass* UHttpRequestInterface::pClassPointer = NULL;

UClass* UHttpResponseInterface::pClassPointer = NULL;

UClass* UIniLocPatcher::pClassPointer = NULL;

UClass* UInterface_NavigationHandle::pClassPointer = NULL;

UClass* UInterface_Speaker::pClassPointer = NULL;

UClass* UInterpCurveEdSetup::pClassPointer = NULL;

UClass* UInterpTrack::pClassPointer = NULL;

UClass* UJsonObject::pClassPointer = NULL;

UClass* UKMeshProps::pClassPointer = NULL;

UClass* ULevelBase::pClassPointer = NULL;

UClass* ULevel::pClassPointer = NULL;

UClass* UPendingLevel::pClassPointer = NULL;

UClass* UDemoPlayPendingLevel::pClassPointer = NULL;

UClass* UNetPendingLevel::pClassPointer = NULL;

UClass* ULevelStreaming::pClassPointer = NULL;

UClass* ULevelStreamingAlwaysLoaded::pClassPointer = NULL;

UClass* ULevelStreamingDistance::pClassPointer = NULL;

UClass* ULevelStreamingKismet::pClassPointer = NULL;

UClass* ULevelStreamingPersistent::pClassPointer = NULL;

UClass* ULightmappedSurfaceCollection::pClassPointer = NULL;

UClass* ULightmassLevelSettings::pClassPointer = NULL;

UClass* ULightmassPrimitiveSettingsObject::pClassPointer = NULL;

UClass* UMapInfo::pClassPointer = NULL;

UClass* UModel::pClassPointer = NULL;

UClass* UMusicTrackDataStructures::pClassPointer = NULL;

UClass* UNavigationMeshBase::pClassPointer = NULL;

UClass* UNetDriver::pClassPointer = NULL;

UClass* UDemoRecDriver::pClassPointer = NULL;

UClass* UObjectReferencer::pClassPointer = NULL;

UClass* UOnlineAuthInterface::pClassPointer = NULL;

UClass* UOnlineMatchmakingStats::pClassPointer = NULL;

UClass* UOnlinePlayerStorage::pClassPointer = NULL;

UClass* UOnlineProfileSettings::pClassPointer = NULL;

UClass* UOnlineStats::pClassPointer = NULL;

UClass* UOnlineStatsRead::pClassPointer = NULL;

UClass* UOnlineStatsWrite::pClassPointer = NULL;

UClass* UOnlineSubsystem::pClassPointer = NULL;

UClass* UPackageMapLevel::pClassPointer = NULL;

UClass* UPackageMapSeekFree::pClassPointer = NULL;

UClass* UPatchScriptCommandlet::pClassPointer = NULL;

UClass* UPlatformInterfaceBase::pClassPointer = NULL;

UClass* UMicroTransactionBase::pClassPointer = NULL;

UClass* UMicroTransactionProxy::pClassPointer = NULL;

UClass* UPlayer::pClassPointer = NULL;

UClass* ULocalPlayer::pClassPointer = NULL;

UClass* UNetConnection::pClassPointer = NULL;

UClass* UChildConnection::pClassPointer = NULL;

UClass* UDemoRecConnection::pClassPointer = NULL;

UClass* UPolys::pClassPointer = NULL;

UClass* UPostProcessChain::pClassPointer = NULL;

UClass* UPostProcessEffect::pClassPointer = NULL;

UClass* UAmbientOcclusionEffect::pClassPointer = NULL;

UClass* UBlurEffect::pClassPointer = NULL;

UClass* UDOFEffect::pClassPointer = NULL;

UClass* UDOFAndBloomEffect::pClassPointer = NULL;

UClass* UDOFBloomMotionBlurEffect::pClassPointer = NULL;

UClass* UUberPostProcessEffect::pClassPointer = NULL;

UClass* UDwTriovizImplEffect::pClassPointer = NULL;

UClass* UMaterialEffect::pClassPointer = NULL;

UClass* UMotionBlurEffect::pClassPointer = NULL;

UClass* UPrimitiveComponentFactory::pClassPointer = NULL;

UClass* UMeshComponentFactory::pClassPointer = NULL;

UClass* UStaticMeshComponentFactory::pClassPointer = NULL;

UClass* UReachSpec::pClassPointer = NULL;

UClass* UAdvancedReachSpec::pClassPointer = NULL;

UClass* UCeilingReachSpec::pClassPointer = NULL;

UClass* UForcedReachSpec::pClassPointer = NULL;

UClass* UCoverSlipReachSpec::pClassPointer = NULL;

UClass* UFloorToCeilingReachSpec::pClassPointer = NULL;

UClass* UMantleReachSpec::pClassPointer = NULL;

UClass* USlotToSlotReachSpec::pClassPointer = NULL;

UClass* USwatTurnReachSpec::pClassPointer = NULL;

UClass* UWallTransReachSpec::pClassPointer = NULL;

UClass* ULadderReachSpec::pClassPointer = NULL;

UClass* UProscribedReachSpec::pClassPointer = NULL;

UClass* UTeleportReachSpec::pClassPointer = NULL;

UClass* USavedMove::pClassPointer = NULL;

UClass* USaveGameSummary::pClassPointer = NULL;

UClass* UScriptViewportClient::pClassPointer = NULL;

UClass* UGameViewportClient::pClassPointer = NULL;

UClass* USelection::pClassPointer = NULL;

UClass* UServerCommandlet::pClassPointer = NULL;

UClass* USettings::pClassPointer = NULL;

UClass* UOnlineGameSearch::pClassPointer = NULL;

UClass* UOnlineGameSettings::pClassPointer = NULL;

UClass* UShaderCache::pClassPointer = NULL;

UClass* UShadowMap1D::pClassPointer = NULL;

UClass* UShadowMap2D::pClassPointer = NULL;

UClass* USmokeTestCommandlet::pClassPointer = NULL;

UClass* USpeechRecognition::pClassPointer = NULL;

UClass* UStaticMesh::pClassPointer = NULL;

UClass* USurface::pClassPointer = NULL;

UClass* UMaterialInterface::pClassPointer = NULL;

UClass* URB_BodySetup::pClassPointer = NULL;

UClass* UInstancedFoliageSettings::pClassPointer = NULL;

UClass* UFracturedStaticMesh::pClassPointer = NULL;

UClass* UParticleSystem::pClassPointer = NULL;

UClass* UTexture::pClassPointer = NULL;

UClass* UTexture2D::pClassPointer = NULL;

UClass* ULightMapTexture2D::pClassPointer = NULL;

UClass* UShadowMapTexture2D::pClassPointer = NULL;

UClass* UTranslationContext::pClassPointer = NULL;

UClass* UTranslatorTag::pClassPointer = NULL;

UClass* UStringsTag::pClassPointer = NULL;

UClass* UUIRoot::pClassPointer = NULL;

UClass* UInteraction::pClassPointer = NULL;

UClass* UUIInteraction::pClassPointer = NULL;

UClass* UUIManager::pClassPointer = NULL;

UClass* UWaveFormBase::pClassPointer = NULL;

UClass* UWorld::pClassPointer = NULL;

UClass* AEnvironmentVolume::pClassPointer = NULL;

UClass* ATestSplittingVolume::pClassPointer = NULL;

UClass* AAIController::pClassPointer = NULL;

UClass* ACrowdAgentBase::pClassPointer = NULL;

UClass* ACrowdPopulationManagerBase::pClassPointer = NULL;

UClass* APathTargetPoint::pClassPointer = NULL;

UClass* ANavMeshObstacle::pClassPointer = NULL;

UClass* APylonSeed::pClassPointer = NULL;

UClass* UCoverGroupRenderingComponent::pClassPointer = NULL;

UClass* UMeshComponent::pClassPointer = NULL;

UClass* UStaticMeshComponent::pClassPointer = NULL;

UClass* UCoverMeshComponent::pClassPointer = NULL;

UClass* UNavMeshRenderingComponent::pClassPointer = NULL;

UClass* UPathRenderingComponent::pClassPointer = NULL;

UClass* URouteRenderingComponent::pClassPointer = NULL;

UClass* UAICommandBase::pClassPointer = NULL;

UClass* UAutoNavMeshPathObstacleUnregister::pClassPointer = NULL;

UClass* UInterface_NavMeshPathObject::pClassPointer = NULL;

UClass* UInterface_NavMeshPathSwitch::pClassPointer = NULL;

UClass* UInterface_NavMeshPathObstacle::pClassPointer = NULL;

UClass* UInterface_PylonGeometryProvider::pClassPointer = NULL;

UClass* UInterface_RVO::pClassPointer = NULL;

UClass* UNavigationHandle::pClassPointer = NULL;

UClass* UNavMeshGoal_Filter::pClassPointer = NULL;

UClass* UNavMeshGoalFilter_MinPathDistance::pClassPointer = NULL;

UClass* UNavMeshGoalFilter_NotNearOtherAI::pClassPointer = NULL;

UClass* UNavMeshGoalFilter_OutOfViewFrom::pClassPointer = NULL;

UClass* UNavMeshGoalFilter_OutSideOfDotProductWedge::pClassPointer = NULL;

UClass* UNavMeshGoalFilter_PolyEncompassesAI::pClassPointer = NULL;

UClass* UNavMeshPathConstraint::pClassPointer = NULL;

UClass* UNavMeshPath_AlongLine::pClassPointer = NULL;

UClass* UNavMeshPath_EnforceTwoWayEdges::pClassPointer = NULL;

UClass* UNavMeshPath_MinDistBetweenSpecsOfType::pClassPointer = NULL;

UClass* UNavMeshPath_SameCoverLink::pClassPointer = NULL;

UClass* UNavMeshPath_Toward::pClassPointer = NULL;

UClass* UNavMeshPath_WithinDistanceEnvelope::pClassPointer = NULL;

UClass* UNavMeshPath_WithinTraversalDist::pClassPointer = NULL;

UClass* UNavMeshPathGoalEvaluator::pClassPointer = NULL;

UClass* UNavMeshGoal_At::pClassPointer = NULL;

UClass* UNavMeshGoal_ClosestActorInList::pClassPointer = NULL;

UClass* UNavMeshGoal_GenericFilterContainer::pClassPointer = NULL;

UClass* UNavMeshGoal_Null::pClassPointer = NULL;

UClass* UNavMeshGoal_PolyEncompassesAI::pClassPointer = NULL;

UClass* UNavMeshGoal_Random::pClassPointer = NULL;

UClass* UNavMeshGoal_WithinDistanceEnvelope::pClassPointer = NULL;

UClass* UPathConstraint::pClassPointer = NULL;

UClass* UPath_AlongLine::pClassPointer = NULL;

UClass* UPath_AvoidInEscapableNodes::pClassPointer = NULL;

UClass* UPath_MinDistBetweenSpecsOfType::pClassPointer = NULL;

UClass* UPath_TowardGoal::pClassPointer = NULL;

UClass* UPath_TowardPoint::pClassPointer = NULL;

UClass* UPath_WithinDistanceEnvelope::pClassPointer = NULL;

UClass* UPath_WithinTraversalDist::pClassPointer = NULL;

UClass* UPathGoalEvaluator::pClassPointer = NULL;

UClass* UGoal_AtActor::pClassPointer = NULL;

UClass* UGoal_Null::pClassPointer = NULL;

UClass* ASkeletalMeshActor::pClassPointer = NULL;

UClass* ASkeletalMeshActorBasedOnExtremeContent::pClassPointer = NULL;

UClass* ASkeletalMeshActorSpawnable::pClassPointer = NULL;

UClass* ASkeletalMeshCinematicActor::pClassPointer = NULL;

UClass* ASkeletalMeshActorMAT::pClassPointer = NULL;

UClass* UHeadTrackingComponent::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_Automatic::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_BitwiseCompressOnly::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_LeastDestructive::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_RemoveEverySecondKey::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_RemoveLinearKeys::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_PerTrackCompression::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_RemoveTrivialKeys::pClassPointer = NULL;

UClass* UAnimationCompressionAlgorithm_RevertToRaw::pClassPointer = NULL;

UClass* UAnimMetaData::pClassPointer = NULL;

UClass* UAnimMetaData_SkelControl::pClassPointer = NULL;

UClass* UAnimMetaData_SkelControlKeyFrame::pClassPointer = NULL;

UClass* UAnimNotify::pClassPointer = NULL;

UClass* UAnimNotify_AkEvent::pClassPointer = NULL;

UClass* UAnimNotify_CameraEffect::pClassPointer = NULL;

UClass* UAnimNotify_ClothingMaxDistanceScale::pClassPointer = NULL;

UClass* UAnimNotify_Footstep::pClassPointer = NULL;

UClass* UAnimNotify_ForceField::pClassPointer = NULL;

UClass* UAnimNotify_Kismet::pClassPointer = NULL;

UClass* UAnimNotify_PlayParticleEffect::pClassPointer = NULL;

UClass* UAnimNotify_Rumble::pClassPointer = NULL;

UClass* UAnimNotify_Script::pClassPointer = NULL;

UClass* UAnimNotify_Scripted::pClassPointer = NULL;

UClass* UAnimNotify_PawnMaterialParam::pClassPointer = NULL;

UClass* UAnimNotify_ViewShake::pClassPointer = NULL;

UClass* UAnimNotify_Sound::pClassPointer = NULL;

UClass* UAnimNotify_Trails::pClassPointer = NULL;

UClass* UAnimObject::pClassPointer = NULL;

UClass* UAnimNode::pClassPointer = NULL;

UClass* UAnimNodeBlendBase::pClassPointer = NULL;

UClass* UAnimNode_MultiBlendPerBone::pClassPointer = NULL;

UClass* UAnimNodeAimOffset::pClassPointer = NULL;

UClass* UAnimNodeBlend::pClassPointer = NULL;

UClass* UAnimNodeAdditiveBlending::pClassPointer = NULL;

UClass* UAnimNodeBlendPerBone::pClassPointer = NULL;

UClass* UAnimNodeCrossfader::pClassPointer = NULL;

UClass* UAnimNodePlayCustomAnim::pClassPointer = NULL;

UClass* UAnimNodeBlendDirectional::pClassPointer = NULL;

UClass* UAnimNodeBlendList::pClassPointer = NULL;

UClass* UAnimNodeBlendByBase::pClassPointer = NULL;

UClass* UAnimNodeBlendByPhysics::pClassPointer = NULL;

UClass* UAnimNodeBlendByPosture::pClassPointer = NULL;

UClass* UAnimNodeBlendByProperty::pClassPointer = NULL;

UClass* UAnimNodeBlendBySpeed::pClassPointer = NULL;

UClass* UAnimNodeRandom::pClassPointer = NULL;

UClass* UAnimNodeBlendMultiBone::pClassPointer = NULL;

UClass* UAnimNodeMirror::pClassPointer = NULL;

UClass* UAnimNodeScalePlayRate::pClassPointer = NULL;

UClass* UAnimNodeScaleRateBySpeed::pClassPointer = NULL;

UClass* UAnimNodeSlot::pClassPointer = NULL;

UClass* UAnimNodeSynch::pClassPointer = NULL;

UClass* UAnimTree::pClassPointer = NULL;

UClass* UAnimNodeSequence::pClassPointer = NULL;

UClass* UAnimNodeSequenceBlendBase::pClassPointer = NULL;

UClass* UAnimNodeSequenceBlendByAim::pClassPointer = NULL;

UClass* UAnimNodeFrame::pClassPointer = NULL;

UClass* UMorphNodeBase::pClassPointer = NULL;

UClass* UMorphNodeMultiPose::pClassPointer = NULL;

UClass* UMorphNodePose::pClassPointer = NULL;

UClass* UMorphNodeWeightBase::pClassPointer = NULL;

UClass* UMorphNodeWeight::pClassPointer = NULL;

UClass* UMorphNodeWeightByBoneAngle::pClassPointer = NULL;

UClass* UMorphNodeWeightByBoneRotation::pClassPointer = NULL;

UClass* USkelControlBase::pClassPointer = NULL;

UClass* USkelControl_CCD_IK::pClassPointer = NULL;

UClass* USkelControl_Multiply::pClassPointer = NULL;

UClass* USkelControl_TwistBone::pClassPointer = NULL;

UClass* USkelControlLimb::pClassPointer = NULL;

UClass* USkelControlFootPlacement::pClassPointer = NULL;

UClass* USkelControlLookAt::pClassPointer = NULL;

UClass* USkelControlSingleBone::pClassPointer = NULL;

UClass* USkelControlHandlebars::pClassPointer = NULL;

UClass* USkelControlWheel::pClassPointer = NULL;

UClass* USkelControlSpline::pClassPointer = NULL;

UClass* USkelControlTrail::pClassPointer = NULL;

UClass* UAnimSequence::pClassPointer = NULL;

UClass* UAnimSet::pClassPointer = NULL;

UClass* UMorphTarget::pClassPointer = NULL;

UClass* UMorphTargetSet::pClassPointer = NULL;

UClass* UMorphWeightSequence::pClassPointer = NULL;

UClass* ADecalActorBase::pClassPointer = NULL;

UClass* ADecalActor::pClassPointer = NULL;

UClass* ADecalActorMovable::pClassPointer = NULL;

UClass* ADecalManager::pClassPointer = NULL;

UClass* UDecalComponent::pClassPointer = NULL;

UClass* UActorFactoryDecal::pClassPointer = NULL;

UClass* UActorFactoryDecalMovable::pClassPointer = NULL;

UClass* UMaterial::pClassPointer = NULL;

UClass* UDecalMaterial::pClassPointer = NULL;

UClass* AFogVolumeDensityInfo::pClassPointer = NULL;

UClass* AFogVolumeConeDensityInfo::pClassPointer = NULL;

UClass* AFogVolumeConstantDensityInfo::pClassPointer = NULL;

UClass* AFogVolumeLinearHalfspaceDensityInfo::pClassPointer = NULL;

UClass* AFogVolumeSphericalDensityInfo::pClassPointer = NULL;

UClass* UExponentialHeightFogComponent::pClassPointer = NULL;

UClass* UFogVolumeDensityComponent::pClassPointer = NULL;

UClass* UFogVolumeConeDensityComponent::pClassPointer = NULL;

UClass* UFogVolumeConstantDensityComponent::pClassPointer = NULL;

UClass* UFogVolumeLinearHalfspaceDensityComponent::pClassPointer = NULL;

UClass* UFogVolumeSphericalDensityComponent::pClassPointer = NULL;

UClass* UActorFactoryFogVolumeConstantDensityInfo::pClassPointer = NULL;

UClass* UActorFactoryFogVolumeLinearHalfspaceDensityInfo::pClassPointer = NULL;

UClass* UActorFactoryFogVolumeSphericalDensityInfo::pClassPointer = NULL;

UClass* AApexDestructibleActor::pClassPointer = NULL;

UClass* AFracturedStaticMeshActor::pClassPointer = NULL;

UClass* AFracturedStaticMeshPart::pClassPointer = NULL;

UClass* AFractureManager::pClassPointer = NULL;

UClass* AImageReflection::pClassPointer = NULL;

UClass* AImageReflectionSceneCapture::pClassPointer = NULL;

UClass* AImageReflectionShadowPlane::pClassPointer = NULL;

UClass* UImageReflectionComponent::pClassPointer = NULL;

UClass* UImageReflectionShadowPlaneComponent::pClassPointer = NULL;

UClass* UApexComponentBase::pClassPointer = NULL;

UClass* UApexDynamicComponent::pClassPointer = NULL;

UClass* UApexStaticComponent::pClassPointer = NULL;

UClass* UApexStaticDestructibleComponent::pClassPointer = NULL;

UClass* UFracturedBaseComponent::pClassPointer = NULL;

UClass* UFracturedSkinnedMeshComponent::pClassPointer = NULL;

UClass* UFracturedStaticMeshComponent::pClassPointer = NULL;

UClass* UImageBasedReflectionComponent::pClassPointer = NULL;

UClass* UInstancedStaticMeshComponent::pClassPointer = NULL;

UClass* USplineMeshComponent::pClassPointer = NULL;

UClass* UApexAsset::pClassPointer = NULL;

UClass* UApexClothingAsset::pClassPointer = NULL;

UClass* UApexDestructibleAsset::pClassPointer = NULL;

UClass* UApexGenericAsset::pClassPointer = NULL;

UClass* UInterpFilter::pClassPointer = NULL;

UClass* UInterpFilter_Classes::pClassPointer = NULL;

UClass* UInterpFilter_Custom::pClassPointer = NULL;

UClass* UInterpGroup::pClassPointer = NULL;

UClass* UInterpGroupAI::pClassPointer = NULL;

UClass* UInterpGroupCamera::pClassPointer = NULL;

UClass* UInterpGroupDirector::pClassPointer = NULL;

UClass* UInterpGroupInst::pClassPointer = NULL;

UClass* UInterpGroupInstAI::pClassPointer = NULL;

UClass* UInterpGroupInstCamera::pClassPointer = NULL;

UClass* UInterpGroupInstDirector::pClassPointer = NULL;

UClass* UInterpTrackBoolProp::pClassPointer = NULL;

UClass* UInterpTrackDirector::pClassPointer = NULL;

UClass* UInterpTrackEvent::pClassPointer = NULL;

UClass* UInterpTrackFaceFX::pClassPointer = NULL;

UClass* UInterpTrackFloatBase::pClassPointer = NULL;

UClass* UInterpTrackAnimControl::pClassPointer = NULL;

UClass* UInterpTrackFade::pClassPointer = NULL;

UClass* UInterpTrackFloatMaterialParam::pClassPointer = NULL;

UClass* UInterpTrackFloatParticleParam::pClassPointer = NULL;

UClass* UInterpTrackFloatProp::pClassPointer = NULL;

UClass* UInterpTrackMorphWeight::pClassPointer = NULL;

UClass* UInterpTrackMoveAxis::pClassPointer = NULL;

UClass* UInterpTrackSkelControlScale::pClassPointer = NULL;

UClass* UInterpTrackSkelControlStrength::pClassPointer = NULL;

UClass* UInterpTrackSlomo::pClassPointer = NULL;

UClass* UInterpTrackHeadTracking::pClassPointer = NULL;

UClass* UInterpTrackLinearColorBase::pClassPointer = NULL;

UClass* UInterpTrackLinearColorProp::pClassPointer = NULL;

UClass* UInterpTrackMove::pClassPointer = NULL;

UClass* UInterpTrackNotify::pClassPointer = NULL;

UClass* UInterpTrackParticleReplay::pClassPointer = NULL;

UClass* UInterpTrackToggle::pClassPointer = NULL;

UClass* UInterpTrackVectorBase::pClassPointer = NULL;

UClass* UInterpTrackAudioMaster::pClassPointer = NULL;

UClass* UInterpTrackColorProp::pClassPointer = NULL;

UClass* UInterpTrackColorScale::pClassPointer = NULL;

UClass* UInterpTrackSound::pClassPointer = NULL;

UClass* UInterpTrackVectorMaterialParam::pClassPointer = NULL;

UClass* UInterpTrackVectorProp::pClassPointer = NULL;

UClass* UInterpTrackVisibility::pClassPointer = NULL;

UClass* UInterpTrackInst::pClassPointer = NULL;

UClass* UInterpTrackInstAnimControl::pClassPointer = NULL;

UClass* UInterpTrackInstAudioMaster::pClassPointer = NULL;

UClass* UInterpTrackInstColorScale::pClassPointer = NULL;

UClass* UInterpTrackInstDirector::pClassPointer = NULL;

UClass* UInterpTrackInstEvent::pClassPointer = NULL;

UClass* UInterpTrackInstFaceFX::pClassPointer = NULL;

UClass* UInterpTrackInstFade::pClassPointer = NULL;

UClass* UInterpTrackInstFloatMaterialParam::pClassPointer = NULL;

UClass* UInterpTrackInstFloatParticleParam::pClassPointer = NULL;

UClass* UInterpTrackInstHeadTracking::pClassPointer = NULL;

UClass* UInterpTrackInstMorphWeight::pClassPointer = NULL;

UClass* UInterpTrackInstMove::pClassPointer = NULL;

UClass* UInterpTrackInstNotify::pClassPointer = NULL;

UClass* UInterpTrackInstParticleReplay::pClassPointer = NULL;

UClass* UInterpTrackInstProperty::pClassPointer = NULL;

UClass* UInterpTrackInstBoolProp::pClassPointer = NULL;

UClass* UInterpTrackInstColorProp::pClassPointer = NULL;

UClass* UInterpTrackInstFloatProp::pClassPointer = NULL;

UClass* UInterpTrackInstLinearColorProp::pClassPointer = NULL;

UClass* UInterpTrackInstVectorProp::pClassPointer = NULL;

UClass* UInterpTrackInstSkelControlScale::pClassPointer = NULL;

UClass* UInterpTrackInstSkelControlStrength::pClassPointer = NULL;

UClass* UInterpTrackInstSlomo::pClassPointer = NULL;

UClass* UInterpTrackInstSound::pClassPointer = NULL;

UClass* UInterpTrackInstToggle::pClassPointer = NULL;

UClass* UInterpTrackInstVectorMaterialParam::pClassPointer = NULL;

UClass* UInterpTrackInstVisibility::pClassPointer = NULL;

UClass* UMaterialExpression::pClassPointer = NULL;

UClass* UMaterialExpressionAbs::pClassPointer = NULL;

UClass* UMaterialExpressionActorWorldPosition::pClassPointer = NULL;

UClass* UMaterialExpressionAdd::pClassPointer = NULL;

UClass* UMaterialExpressionAppendVector::pClassPointer = NULL;

UClass* UMaterialExpressionBumpOffset::pClassPointer = NULL;

UClass* UMaterialExpressionCameraVector::pClassPointer = NULL;

UClass* UMaterialExpressionCameraWorldPosition::pClassPointer = NULL;

UClass* UMaterialExpressionCeil::pClassPointer = NULL;

UClass* UMaterialExpressionClamp::pClassPointer = NULL;

UClass* UMaterialExpressionComment::pClassPointer = NULL;

UClass* UMaterialExpressionComponentMask::pClassPointer = NULL;

UClass* UMaterialExpressionConstant::pClassPointer = NULL;

UClass* UMaterialExpressionConstant2Vector::pClassPointer = NULL;

UClass* UMaterialExpressionConstant3Vector::pClassPointer = NULL;

UClass* UMaterialExpressionConstant4Vector::pClassPointer = NULL;

UClass* UMaterialExpressionConstantBiasScale::pClassPointer = NULL;

UClass* UMaterialExpressionConstantClamp::pClassPointer = NULL;

UClass* UMaterialExpressionCosine::pClassPointer = NULL;

UClass* UMaterialExpressionCrossProduct::pClassPointer = NULL;

UClass* UMaterialExpressionCustom::pClassPointer = NULL;

UClass* UMaterialExpressionCustomTexture::pClassPointer = NULL;

UClass* UMaterialExpressionDepthBiasedAlpha::pClassPointer = NULL;

UClass* UMaterialExpressionDepthBiasedBlend::pClassPointer = NULL;

UClass* UMaterialExpressionDepthOfFieldFunction::pClassPointer = NULL;

UClass* UMaterialExpressionDeriveNormalZ::pClassPointer = NULL;

UClass* UMaterialExpressionDesaturation::pClassPointer = NULL;

UClass* UMaterialExpressionDestColor::pClassPointer = NULL;

UClass* UMaterialExpressionDestDepth::pClassPointer = NULL;

UClass* UMaterialExpressionDistance::pClassPointer = NULL;

UClass* UMaterialExpressionDivide::pClassPointer = NULL;

UClass* UMaterialExpressionDotProduct::pClassPointer = NULL;

UClass* UMaterialExpressionDynamicParameter::pClassPointer = NULL;

UClass* UMaterialExpressionMeshEmitterDynamicParameter::pClassPointer = NULL;

UClass* UMaterialExpressionFloor::pClassPointer = NULL;

UClass* UMaterialExpressionFluidNormal::pClassPointer = NULL;

UClass* UMaterialExpressionFmod::pClassPointer = NULL;

UClass* UMaterialExpressionFoliageImpulseDirection::pClassPointer = NULL;

UClass* UMaterialExpressionFoliageNormalizedRotationAxisAndAngle::pClassPointer = NULL;

UClass* UMaterialExpressionFontSample::pClassPointer = NULL;

UClass* UMaterialExpressionFontSampleParameter::pClassPointer = NULL;

UClass* UMaterialExpressionFrac::pClassPointer = NULL;

UClass* UMaterialExpressionFresnel::pClassPointer = NULL;

UClass* UMaterialExpressionFunctionInput::pClassPointer = NULL;

UClass* UMaterialExpressionFunctionOutput::pClassPointer = NULL;

UClass* UMaterialExpressionIf::pClassPointer = NULL;

UClass* UMaterialExpressionLandscapeLayerBlend::pClassPointer = NULL;

UClass* UMaterialExpressionLensFlareIntensity::pClassPointer = NULL;

UClass* UMaterialExpressionLensFlareOcclusion::pClassPointer = NULL;

UClass* UMaterialExpressionLensFlareRadialDistance::pClassPointer = NULL;

UClass* UMaterialExpressionLensFlareRayDistance::pClassPointer = NULL;

UClass* UMaterialExpressionLensFlareSourceDistance::pClassPointer = NULL;

UClass* UMaterialExpressionLightmapUVs::pClassPointer = NULL;

UClass* UMaterialExpressionLightmassReplace::pClassPointer = NULL;

UClass* UMaterialExpressionLightVector::pClassPointer = NULL;

UClass* UMaterialExpressionLinearInterpolate::pClassPointer = NULL;

UClass* UMaterialExpressionMaterialFunctionCall::pClassPointer = NULL;

UClass* UMaterialExpressionMeshEmitterVertexColor::pClassPointer = NULL;

UClass* UMaterialExpressionMultiply::pClassPointer = NULL;

UClass* UMaterialExpressionNormalize::pClassPointer = NULL;

UClass* UMaterialExpressionObjectOrientation::pClassPointer = NULL;

UClass* UMaterialExpressionObjectRadius::pClassPointer = NULL;

UClass* UMaterialExpressionObjectWorldPosition::pClassPointer = NULL;

UClass* UMaterialExpressionOcclusionPercentage::pClassPointer = NULL;

UClass* UMaterialExpressionOneMinus::pClassPointer = NULL;

UClass* UMaterialExpressionPanner::pClassPointer = NULL;

UClass* UMaterialExpressionParameter::pClassPointer = NULL;

UClass* UMaterialExpressionScalarParameter::pClassPointer = NULL;

UClass* UMaterialExpressionStaticBoolParameter::pClassPointer = NULL;

UClass* UMaterialExpressionStaticSwitchParameter::pClassPointer = NULL;

UClass* UMaterialExpressionStaticComponentMaskParameter::pClassPointer = NULL;

UClass* UMaterialExpressionVectorParameter::pClassPointer = NULL;

UClass* UMaterialExpressionParticleMacroUV::pClassPointer = NULL;

UClass* UMaterialExpressionPerInstanceRandom::pClassPointer = NULL;

UClass* UMaterialExpressionPinkConstant::pClassPointer = NULL;

UClass* UMaterialExpressionPixelDepth::pClassPointer = NULL;

UClass* UMaterialExpressionPower::pClassPointer = NULL;

UClass* UMaterialExpressionQualitySwitch::pClassPointer = NULL;

UClass* UMaterialExpressionReflectionVector::pClassPointer = NULL;

UClass* UMaterialExpressionRotateAboutAxis::pClassPointer = NULL;

UClass* UMaterialExpressionRotator::pClassPointer = NULL;

UClass* UMaterialExpressionSceneDepth::pClassPointer = NULL;

UClass* UMaterialExpressionSceneTexture::pClassPointer = NULL;

UClass* UMaterialExpressionScreenPosition::pClassPointer = NULL;

UClass* UMaterialExpressionScreenSize::pClassPointer = NULL;

UClass* UMaterialExpressionSine::pClassPointer = NULL;

UClass* UMaterialExpressionSphereMask::pClassPointer = NULL;

UClass* UMaterialExpressionSquareRoot::pClassPointer = NULL;

UClass* UMaterialExpressionStaticBool::pClassPointer = NULL;

UClass* UMaterialExpressionStaticSwitch::pClassPointer = NULL;

UClass* UMaterialExpressionSubtract::pClassPointer = NULL;

UClass* UMaterialExpressionTerrainLayerCoords::pClassPointer = NULL;

UClass* UMaterialExpressionTerrainLayerSwitch::pClassPointer = NULL;

UClass* UMaterialExpressionTerrainLayerWeight::pClassPointer = NULL;

UClass* UMaterialExpressionTexelSize::pClassPointer = NULL;

UClass* UMaterialExpressionTextureCoordinate::pClassPointer = NULL;

UClass* UMaterialExpressionTextureObject::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSample::pClassPointer = NULL;

UClass* UMaterialExpressionDepthBiasBlend::pClassPointer = NULL;

UClass* UMaterialExpressionFlipBookSample::pClassPointer = NULL;

UClass* UMaterialExpressionMeshSubUV::pClassPointer = NULL;

UClass* UMaterialExpressionMeshSubUVBlend::pClassPointer = NULL;

UClass* UMaterialExpressionParticleSubUV::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameter::pClassPointer = NULL;

UClass* UMaterialExpressionTextureObjectParameter::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameter2D::pClassPointer = NULL;

UClass* UMaterialExpressionAntialiasedTextureMask::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameterFlipbook::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameterMeshSubUV::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameterMeshSubUVBlend::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameterSubUV::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameterCube::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameterMovie::pClassPointer = NULL;

UClass* UMaterialExpressionTextureSampleParameterNormal::pClassPointer = NULL;

UClass* UMaterialExpressionTime::pClassPointer = NULL;

UClass* UMaterialExpressionTransform::pClassPointer = NULL;

UClass* UMaterialExpressionTransformPosition::pClassPointer = NULL;

UClass* UMaterialExpressionTwoSidedSign::pClassPointer = NULL;

UClass* UMaterialExpressionVertexCameraVector::pClassPointer = NULL;

UClass* UMaterialExpressionVertexColor::pClassPointer = NULL;

UClass* UMaterialExpressionWindDirectionAndSpeed::pClassPointer = NULL;

UClass* UMaterialExpressionWorldNormal::pClassPointer = NULL;

UClass* UMaterialExpressionWorldPosition::pClassPointer = NULL;

UClass* UMaterialFunction::pClassPointer = NULL;

UClass* UMaterialInstance::pClassPointer = NULL;

UClass* UMaterialInstanceConstant::pClassPointer = NULL;

UClass* ULandscapeMaterialInstanceConstant::pClassPointer = NULL;

UClass* UMaterialInstanceTimeVarying::pClassPointer = NULL;

UClass* AEmitterCameraLensEffectBase::pClassPointer = NULL;

UClass* AParticleEventManager::pClassPointer = NULL;

UClass* UParticleSystemComponent::pClassPointer = NULL;

UClass* UDistributionFloatParticleParameter::pClassPointer = NULL;

UClass* UDistributionVectorParticleParameter::pClassPointer = NULL;

UClass* UParticleEmitter::pClassPointer = NULL;

UClass* UParticleSpriteEmitter::pClassPointer = NULL;

UClass* UParticleLODLevel::pClassPointer = NULL;

UClass* UParticleModule::pClassPointer = NULL;

UClass* UParticleModuleAccelerationBase::pClassPointer = NULL;

UClass* UParticleModuleAcceleration::pClassPointer = NULL;

UClass* UParticleModuleAccelerationOverLifetime::pClassPointer = NULL;

UClass* UParticleModuleAttractorBase::pClassPointer = NULL;

UClass* UParticleModuleAttractorBoneSocket::pClassPointer = NULL;

UClass* UParticleModuleAttractorLine::pClassPointer = NULL;

UClass* UParticleModuleAttractorParticle::pClassPointer = NULL;

UClass* UParticleModuleAttractorPoint::pClassPointer = NULL;

UClass* UParticleModuleAttractorSkelVertSurface::pClassPointer = NULL;

UClass* UParticleModuleBeamBase::pClassPointer = NULL;

UClass* UParticleModuleBeamModifier::pClassPointer = NULL;

UClass* UParticleModuleBeamNoise::pClassPointer = NULL;

UClass* UParticleModuleBeamSource::pClassPointer = NULL;

UClass* UParticleModuleBeamTarget::pClassPointer = NULL;

UClass* UParticleModuleCameraBase::pClassPointer = NULL;

UClass* UParticleModuleCameraOffset::pClassPointer = NULL;

UClass* UParticleModuleCollisionBase::pClassPointer = NULL;

UClass* UParticleModuleCollision::pClassPointer = NULL;

UClass* UParticleModuleCollisionActor::pClassPointer = NULL;

UClass* UParticleModuleColorBase::pClassPointer = NULL;

UClass* UParticleModuleColor::pClassPointer = NULL;

UClass* UParticleModuleColor_Seeded::pClassPointer = NULL;

UClass* UParticleModuleColorByParameter::pClassPointer = NULL;

UClass* UParticleModuleColorOverLife::pClassPointer = NULL;

UClass* UParticleModuleColorScaleOverDensity::pClassPointer = NULL;

UClass* UParticleModuleColorScaleOverLife::pClassPointer = NULL;

UClass* UParticleModuleEventBase::pClassPointer = NULL;

UClass* UParticleModuleEventGenerator::pClassPointer = NULL;

UClass* UParticleModuleEventReceiverBase::pClassPointer = NULL;

UClass* UParticleModuleEventReceiverKillParticles::pClassPointer = NULL;

UClass* UParticleModuleEventReceiverSpawn::pClassPointer = NULL;

UClass* UParticleModuleKillBase::pClassPointer = NULL;

UClass* UParticleModuleKillBox::pClassPointer = NULL;

UClass* UParticleModuleKillHeight::pClassPointer = NULL;

UClass* UParticleModuleLifetimeBase::pClassPointer = NULL;

UClass* UParticleModuleLifetime::pClassPointer = NULL;

UClass* UParticleModuleLifetime_Seeded::pClassPointer = NULL;

UClass* UParticleModuleLocationBase::pClassPointer = NULL;

UClass* UParticleModuleLocation::pClassPointer = NULL;

UClass* UParticleModuleLocation_Seeded::pClassPointer = NULL;

UClass* UParticleModuleLocationWorldOffset::pClassPointer = NULL;

UClass* UParticleModuleLocationWorldOffset_Seeded::pClassPointer = NULL;

UClass* UParticleModuleLocationBoneSocket::pClassPointer = NULL;

UClass* UParticleModuleLocationDirect::pClassPointer = NULL;

UClass* UParticleModuleLocationEmitter::pClassPointer = NULL;

UClass* UParticleModuleLocationEmitterDirect::pClassPointer = NULL;

UClass* UParticleModuleLocationPrimitiveBase::pClassPointer = NULL;

UClass* UParticleModuleLocationPrimitiveCylinder::pClassPointer = NULL;

UClass* UParticleModuleLocationPrimitiveCylinder_Seeded::pClassPointer = NULL;

UClass* UParticleModuleLocationPrimitiveSphere::pClassPointer = NULL;

UClass* UParticleModuleLocationPrimitiveSphere_Seeded::pClassPointer = NULL;

UClass* UParticleModuleLocationSkelVertSurface::pClassPointer = NULL;

UClass* UParticleModuleLocationStaticVertSurface::pClassPointer = NULL;

UClass* UParticleModuleSourceMovement::pClassPointer = NULL;

UClass* UParticleModuleMaterialBase::pClassPointer = NULL;

UClass* UParticleModuleMaterialByParameter::pClassPointer = NULL;

UClass* UParticleModuleMeshMaterial::pClassPointer = NULL;

UClass* UParticleModuleOrbitBase::pClassPointer = NULL;

UClass* UParticleModuleOrbit::pClassPointer = NULL;

UClass* UParticleModuleOrientationBase::pClassPointer = NULL;

UClass* UParticleModuleOrientationAxisLock::pClassPointer = NULL;

UClass* UParticleModuleParameterBase::pClassPointer = NULL;

UClass* UParticleModuleParameterDynamic::pClassPointer = NULL;

UClass* UParticleModuleParameterDynamic_Seeded::pClassPointer = NULL;

UClass* UParticleModuleRequired::pClassPointer = NULL;

UClass* UParticleModuleRotationBase::pClassPointer = NULL;

UClass* UParticleModuleMeshRotation::pClassPointer = NULL;

UClass* UParticleModuleMeshRotation_Seeded::pClassPointer = NULL;

UClass* UParticleModuleRotation::pClassPointer = NULL;

UClass* UParticleModuleRotation_Seeded::pClassPointer = NULL;

UClass* UParticleModuleRotationOverLifetime::pClassPointer = NULL;

UClass* UParticleModuleRotationRateBase::pClassPointer = NULL;

UClass* UParticleModuleMeshRotationRate::pClassPointer = NULL;

UClass* UParticleModuleMeshRotationRate_Seeded::pClassPointer = NULL;

UClass* UParticleModuleMeshRotationRateMultiplyLife::pClassPointer = NULL;

UClass* UParticleModuleMeshRotationRateOverLife::pClassPointer = NULL;

UClass* UParticleModuleRotationRate::pClassPointer = NULL;

UClass* UParticleModuleRotationRate_Seeded::pClassPointer = NULL;

UClass* UParticleModuleRotationRateMultiplyLife::pClassPointer = NULL;

UClass* UParticleModuleSizeBase::pClassPointer = NULL;

UClass* UParticleModuleSize::pClassPointer = NULL;

UClass* UParticleModuleSize_Seeded::pClassPointer = NULL;

UClass* UParticleModuleSizeMultiplyLife::pClassPointer = NULL;

UClass* UParticleModuleSizeMultiplyVelocity::pClassPointer = NULL;

UClass* UParticleModuleSizeScale::pClassPointer = NULL;

UClass* UParticleModuleSizeScaleByTime::pClassPointer = NULL;

UClass* UParticleModuleSizeScaleOverDensity::pClassPointer = NULL;

UClass* UParticleModuleSpawnBase::pClassPointer = NULL;

UClass* UParticleModuleSpawn::pClassPointer = NULL;

UClass* UParticleModuleSpawnPerUnit::pClassPointer = NULL;

UClass* UParticleModuleStoreSpawnTimeBase::pClassPointer = NULL;

UClass* UParticleModuleStoreSpawnTime::pClassPointer = NULL;

UClass* UParticleModuleSubUVBase::pClassPointer = NULL;

UClass* UParticleModuleSubUV::pClassPointer = NULL;

UClass* UParticleModuleSubUVMovie::pClassPointer = NULL;

UClass* UParticleModuleSubUVDirect::pClassPointer = NULL;

UClass* UParticleModuleSubUVSelect::pClassPointer = NULL;

UClass* UParticleModuleTrailBase::pClassPointer = NULL;

UClass* UParticleModuleTrailSource::pClassPointer = NULL;

UClass* UParticleModuleTrailSpawn::pClassPointer = NULL;

UClass* UParticleModuleTrailTaper::pClassPointer = NULL;

UClass* UParticleModuleTypeDataBase::pClassPointer = NULL;

UClass* UParticleModuleTypeDataAnimTrail::pClassPointer = NULL;

UClass* UParticleModuleTypeDataApex::pClassPointer = NULL;

UClass* UParticleModuleTypeDataBeam::pClassPointer = NULL;

UClass* UParticleModuleTypeDataBeam2::pClassPointer = NULL;

UClass* UParticleModuleTypeDataMesh::pClassPointer = NULL;

UClass* UParticleModuleTypeDataMeshPhysX::pClassPointer = NULL;

UClass* UParticleModuleTypeDataPhysX::pClassPointer = NULL;

UClass* UParticleModuleTypeDataRibbon::pClassPointer = NULL;

UClass* UParticleModuleTypeDataTrail::pClassPointer = NULL;

UClass* UParticleModuleTypeDataTrail2::pClassPointer = NULL;

UClass* UParticleModuleUberBase::pClassPointer = NULL;

UClass* UParticleModuleUberLTISIVCL::pClassPointer = NULL;

UClass* UParticleModuleUberLTISIVCLIL::pClassPointer = NULL;

UClass* UParticleModuleUberLTISIVCLILIRSSBLIRR::pClassPointer = NULL;

UClass* UParticleModuleUberRainDrops::pClassPointer = NULL;

UClass* UParticleModuleUberRainImpacts::pClassPointer = NULL;

UClass* UParticleModuleUberRainSplashA::pClassPointer = NULL;

UClass* UParticleModuleUberRainSplashB::pClassPointer = NULL;

UClass* UParticleModuleVelocityBase::pClassPointer = NULL;

UClass* UParticleModuleVelocity::pClassPointer = NULL;

UClass* UParticleModuleVelocity_Seeded::pClassPointer = NULL;

UClass* UParticleModuleVelocityCone::pClassPointer = NULL;

UClass* UParticleModuleVelocityInheritParent::pClassPointer = NULL;

UClass* UParticleModuleVelocityOverLifetime::pClassPointer = NULL;

UClass* UParticleModuleWorldForcesBase::pClassPointer = NULL;

UClass* UParticleModulePhysicsVolumes::pClassPointer = NULL;

UClass* UParticleModuleWorldAttractor::pClassPointer = NULL;

UClass* UParticleModuleEventSendToGame::pClassPointer = NULL;

UClass* UParticleSystemReplay::pClassPointer = NULL;

UClass* UPhysXParticleSystem::pClassPointer = NULL;

UClass* AKActor::pClassPointer = NULL;

UClass* AKActorFromStatic::pClassPointer = NULL;

UClass* AKActorSpawnable::pClassPointer = NULL;

UClass* AKAsset::pClassPointer = NULL;

UClass* APawn::pClassPointer = NULL;

UClass* AVehicle::pClassPointer = NULL;

UClass* ASVehicle::pClassPointer = NULL;

UClass* ARB_ConstraintActor::pClassPointer = NULL;

UClass* ARB_LineImpulseActor::pClassPointer = NULL;

UClass* ARB_RadialImpulseActor::pClassPointer = NULL;

UClass* ARB_Thruster::pClassPointer = NULL;

UClass* AWorldAttractor::pClassPointer = NULL;

UClass* URB_ConstraintDrawComponent::pClassPointer = NULL;

UClass* URB_RadialImpulseComponent::pClassPointer = NULL;

UClass* URB_Handle::pClassPointer = NULL;

UClass* URB_Spring::pClassPointer = NULL;

UClass* USVehicleSimBase::pClassPointer = NULL;

UClass* USVehicleSimCar::pClassPointer = NULL;

UClass* USVehicleSimTank::pClassPointer = NULL;

UClass* UActorFactoryApexClothing::pClassPointer = NULL;

UClass* UApexDestructibleDamageParameters::pClassPointer = NULL;

UClass* UFractureMaterial::pClassPointer = NULL;

UClass* UPhysicalMaterial::pClassPointer = NULL;

UClass* UPhysicalMaterialPropertyBase::pClassPointer = NULL;

UClass* UPhysicsAsset::pClassPointer = NULL;

UClass* UPhysicsAssetInstance::pClassPointer = NULL;

UClass* UPhysicsLODVerticalEmitter::pClassPointer = NULL;

UClass* URB_BodyInstance::pClassPointer = NULL;

UClass* URB_ConstraintInstance::pClassPointer = NULL;

UClass* URB_ConstraintSetup::pClassPointer = NULL;

UClass* URB_BSJointSetup::pClassPointer = NULL;

UClass* URB_DistanceJointSetup::pClassPointer = NULL;

UClass* URB_HingeSetup::pClassPointer = NULL;

UClass* URB_PrismaticSetup::pClassPointer = NULL;

UClass* URB_PulleyJointSetup::pClassPointer = NULL;

UClass* URB_SkelJointSetup::pClassPointer = NULL;

UClass* URB_StayUprightSetup::pClassPointer = NULL;

UClass* USVehicleWheel::pClassPointer = NULL;

UClass* ANxGenericForceFieldBrush::pClassPointer = NULL;

UClass* ARB_ForceFieldExcludeVolume::pClassPointer = NULL;

UClass* ANxForceField::pClassPointer = NULL;

UClass* ANxCylindricalForceField::pClassPointer = NULL;

UClass* ANxCylindricalForceFieldCapsule::pClassPointer = NULL;

UClass* ANxForceFieldGeneric::pClassPointer = NULL;

UClass* ANxForceFieldRadial::pClassPointer = NULL;

UClass* ANxForceFieldTornado::pClassPointer = NULL;

UClass* ANxGenericForceField::pClassPointer = NULL;

UClass* ANxGenericForceFieldBox::pClassPointer = NULL;

UClass* ANxGenericForceFieldCapsule::pClassPointer = NULL;

UClass* ANxRadialForceField::pClassPointer = NULL;

UClass* ANxRadialCustomForceField::pClassPointer = NULL;

UClass* ANxTornadoAngularForceField::pClassPointer = NULL;

UClass* ANxTornadoAngularForceFieldCapsule::pClassPointer = NULL;

UClass* ANxTornadoForceField::pClassPointer = NULL;

UClass* ANxTornadoForceFieldCapsule::pClassPointer = NULL;

UClass* ANxForceFieldSpawnable::pClassPointer = NULL;

UClass* ARB_CylindricalForceActor::pClassPointer = NULL;

UClass* ARB_RadialForceActor::pClassPointer = NULL;

UClass* UNxForceFieldComponent::pClassPointer = NULL;

UClass* UNxForceFieldCylindricalComponent::pClassPointer = NULL;

UClass* UNxForceFieldGenericComponent::pClassPointer = NULL;

UClass* UNxForceFieldRadialComponent::pClassPointer = NULL;

UClass* UNxForceFieldTornadoComponent::pClassPointer = NULL;

UClass* UForceFieldShape::pClassPointer = NULL;

UClass* UForceFieldShapeBox::pClassPointer = NULL;

UClass* UForceFieldShapeCapsule::pClassPointer = NULL;

UClass* UForceFieldShapeSphere::pClassPointer = NULL;

UClass* APrefabInstance::pClassPointer = NULL;

UClass* UPrefab::pClassPointer = NULL;

UClass* USequenceObject::pClassPointer = NULL;

UClass* USequenceFrame::pClassPointer = NULL;

UClass* USequenceFrameWrapped::pClassPointer = NULL;

UClass* USequenceOp::pClassPointer = NULL;

UClass* USequence::pClassPointer = NULL;

UClass* UPrefabSequence::pClassPointer = NULL;

UClass* UPrefabSequenceContainer::pClassPointer = NULL;

UClass* USequenceAction::pClassPointer = NULL;

UClass* USeqAct_ActivateRemoteEvent::pClassPointer = NULL;

UClass* USeqAct_AndGate::pClassPointer = NULL;

UClass* USeqAct_ApplySoundNode::pClassPointer = NULL;

UClass* USeqAct_AttachToEvent::pClassPointer = NULL;

UClass* USeqAct_CameraFade::pClassPointer = NULL;

UClass* USeqAct_CameraLookAt::pClassPointer = NULL;

UClass* USeqAct_CameraShake::pClassPointer = NULL;

UClass* USeqAct_ChangeCollision::pClassPointer = NULL;

UClass* USeqAct_CommitMapChange::pClassPointer = NULL;

UClass* USeqAct_ConvertToString::pClassPointer = NULL;

UClass* USeqAct_DrawText::pClassPointer = NULL;

UClass* USeqAct_FinishSequence::pClassPointer = NULL;

UClass* USeqAct_Gate::pClassPointer = NULL;

UClass* USeqAct_GetDistance::pClassPointer = NULL;

UClass* USeqAct_GetLocationAndRotation::pClassPointer = NULL;

UClass* USeqAct_GetProperty::pClassPointer = NULL;

UClass* USeqAct_GetVectorComponents::pClassPointer = NULL;

UClass* USeqAct_GetVelocity::pClassPointer = NULL;

UClass* USeqAct_HeadTrackingControl::pClassPointer = NULL;

UClass* USeqAct_IsInObjectList::pClassPointer = NULL;

UClass* USeqAct_Latent::pClassPointer = NULL;

UClass* USeqAct_ActorFactory::pClassPointer = NULL;

UClass* USeqAct_ActorFactoryEx::pClassPointer = NULL;

UClass* USeqAct_ProjectileFactory::pClassPointer = NULL;

UClass* USeqAct_AIMoveToActor::pClassPointer = NULL;

UClass* USeqAct_Delay::pClassPointer = NULL;

UClass* USeqAct_DelaySwitch::pClassPointer = NULL;

UClass* USeqAct_ForceGarbageCollection::pClassPointer = NULL;

UClass* USeqAct_Interp::pClassPointer = NULL;

UClass* USeqAct_LevelStreamingBase::pClassPointer = NULL;

UClass* USeqAct_LevelStreaming::pClassPointer = NULL;

UClass* USeqAct_MultiLevelStreaming::pClassPointer = NULL;

UClass* USeqAct_LevelVisibility::pClassPointer = NULL;

UClass* USeqAct_PlaySound::pClassPointer = NULL;

UClass* USeqAct_PrepareMapChange::pClassPointer = NULL;

UClass* USeqAct_SetDOFParams::pClassPointer = NULL;

UClass* USeqAct_SetMotionBlurParams::pClassPointer = NULL;

UClass* USeqAct_StreamInTextures::pClassPointer = NULL;

UClass* USeqAct_WaitForLevelsVisible::pClassPointer = NULL;

UClass* USeqAct_Log::pClassPointer = NULL;

UClass* USeqAct_FeatureTest::pClassPointer = NULL;

UClass* USeqAct_ModifyCover::pClassPointer = NULL;

UClass* USeqAct_ModifyHealth::pClassPointer = NULL;

UClass* USeqAct_ParticleEventGenerator::pClassPointer = NULL;

UClass* USeqAct_PlayCameraAnim::pClassPointer = NULL;

UClass* USeqAct_PlayFaceFXAnim::pClassPointer = NULL;

UClass* USeqAct_PlayMusicTrack::pClassPointer = NULL;

UClass* USeqAct_Possess::pClassPointer = NULL;

UClass* USeqAct_RangeSwitch::pClassPointer = NULL;

UClass* USeqAct_SetActiveAnimChild::pClassPointer = NULL;

UClass* USeqAct_SetApexClothingParam::pClassPointer = NULL;

UClass* USeqAct_SetBlockRigidBody::pClassPointer = NULL;

UClass* USeqAct_SetCameraTarget::pClassPointer = NULL;

UClass* USeqAct_SetMaterial::pClassPointer = NULL;

UClass* USeqAct_SetMatInstScalarParam::pClassPointer = NULL;

UClass* USeqAct_SetMesh::pClassPointer = NULL;

UClass* USeqAct_SetPhysics::pClassPointer = NULL;

UClass* USeqAct_SetRigidBodyIgnoreVehicles::pClassPointer = NULL;

UClass* USeqAct_SetSequenceVariable::pClassPointer = NULL;

UClass* USeqAct_AccessObjectList::pClassPointer = NULL;

UClass* USeqAct_AddFloat::pClassPointer = NULL;

UClass* USeqAct_AddInt::pClassPointer = NULL;

UClass* USeqAct_CastToFloat::pClassPointer = NULL;

UClass* USeqAct_CastToInt::pClassPointer = NULL;

UClass* USeqAct_DivideFloat::pClassPointer = NULL;

UClass* USeqAct_DivideInt::pClassPointer = NULL;

UClass* USeqAct_ModifyObjectList::pClassPointer = NULL;

UClass* USeqAct_MultiplyFloat::pClassPointer = NULL;

UClass* USeqAct_MultiplyInt::pClassPointer = NULL;

UClass* USeqAct_SetBool::pClassPointer = NULL;

UClass* USeqAct_SetFloat::pClassPointer = NULL;

UClass* USeqAct_SetInt::pClassPointer = NULL;

UClass* USeqAct_SetLocation::pClassPointer = NULL;

UClass* USeqAct_SetObject::pClassPointer = NULL;

UClass* USeqAct_SetString::pClassPointer = NULL;

UClass* USeqAct_SubtractFloat::pClassPointer = NULL;

UClass* USeqAct_SubtractInt::pClassPointer = NULL;

UClass* USeqAct_SetVectorComponents::pClassPointer = NULL;

UClass* USeqAct_SetWorldAttractorParam::pClassPointer = NULL;

UClass* USeqAct_Switch::pClassPointer = NULL;

UClass* USeqAct_RandomSwitch::pClassPointer = NULL;

UClass* USeqAct_Timer::pClassPointer = NULL;

UClass* USeqAct_Toggle::pClassPointer = NULL;

UClass* USeqAct_Trace::pClassPointer = NULL;

UClass* USequenceCondition::pClassPointer = NULL;

UClass* USeqCond_CompareBool::pClassPointer = NULL;

UClass* USeqCond_CompareFloat::pClassPointer = NULL;

UClass* USeqCond_CompareInt::pClassPointer = NULL;

UClass* USeqCond_CompareObject::pClassPointer = NULL;

UClass* USeqCond_GetServerType::pClassPointer = NULL;

UClass* USeqCond_Increment::pClassPointer = NULL;

UClass* USeqCond_IncrementFloat::pClassPointer = NULL;

UClass* USeqCond_IsAlive::pClassPointer = NULL;

UClass* USeqCond_IsBenchmarking::pClassPointer = NULL;

UClass* USeqCond_IsConsole::pClassPointer = NULL;

UClass* USeqCond_IsInCombat::pClassPointer = NULL;

UClass* USeqCond_IsLoggedIn::pClassPointer = NULL;

UClass* USeqCond_IsPIE::pClassPointer = NULL;

UClass* USeqCond_IsSameTeam::pClassPointer = NULL;

UClass* USeqCond_MatureLanguage::pClassPointer = NULL;

UClass* USeqCond_ShowGore::pClassPointer = NULL;

UClass* USeqCond_SwitchBase::pClassPointer = NULL;

UClass* USeqCond_SwitchClass::pClassPointer = NULL;

UClass* USeqCond_SwitchObject::pClassPointer = NULL;

UClass* USeqCond_SwitchPlatform::pClassPointer = NULL;

UClass* USequenceEvent::pClassPointer = NULL;

UClass* USeqEvent_AISeeEnemy::pClassPointer = NULL;

UClass* USeqEvent_AnalogInput::pClassPointer = NULL;

UClass* USeqEvent_AnimNotify::pClassPointer = NULL;

UClass* USeqEvent_Console::pClassPointer = NULL;

UClass* USeqEvent_ConstraintBroken::pClassPointer = NULL;

UClass* USeqEvent_Destroyed::pClassPointer = NULL;

UClass* USeqEvent_GetInventory::pClassPointer = NULL;

UClass* USeqEvent_Input::pClassPointer = NULL;

UClass* USeqEvent_LevelBeginning::pClassPointer = NULL;

UClass* USeqEvent_LevelLoaded::pClassPointer = NULL;

UClass* USeqEvent_LevelStartup::pClassPointer = NULL;

UClass* USeqEvent_Mover::pClassPointer = NULL;

UClass* USeqEvent_ParticleEvent::pClassPointer = NULL;

UClass* USeqEvent_ProjectileLanded::pClassPointer = NULL;

UClass* USeqEvent_RemoteEvent::pClassPointer = NULL;

UClass* USeqEvent_RigidBodyCollision::pClassPointer = NULL;

UClass* USeqEvent_SeeDeath::pClassPointer = NULL;

UClass* USeqEvent_SequenceActivated::pClassPointer = NULL;

UClass* USeqEvent_TakeDamage::pClassPointer = NULL;

UClass* USeqEvent_Touch::pClassPointer = NULL;

UClass* USeqEvent_TouchInput::pClassPointer = NULL;

UClass* USeqEvent_Used::pClassPointer = NULL;

UClass* USequenceVariable::pClassPointer = NULL;

UClass* UInterpData::pClassPointer = NULL;

UClass* USeqVar_Bool::pClassPointer = NULL;

UClass* USeqVar_External::pClassPointer = NULL;

UClass* USeqVar_Float::pClassPointer = NULL;

UClass* USeqVar_RandomFloat::pClassPointer = NULL;

UClass* USeqVar_Int::pClassPointer = NULL;

UClass* USeqVar_RandomInt::pClassPointer = NULL;

UClass* USeqVar_Named::pClassPointer = NULL;

UClass* USeqVar_Object::pClassPointer = NULL;

UClass* USeqVar_Character::pClassPointer = NULL;

UClass* USeqVar_Group::pClassPointer = NULL;

UClass* USeqVar_ObjectList::pClassPointer = NULL;

UClass* USeqVar_ObjectVolume::pClassPointer = NULL;

UClass* USeqVar_Player::pClassPointer = NULL;

UClass* USeqVar_String::pClassPointer = NULL;

UClass* USeqVar_Vector::pClassPointer = NULL;

UClass* AAmbientSound::pClassPointer = NULL;

UClass* AAmbientSoundMovable::pClassPointer = NULL;

UClass* AAmbientSoundSimple::pClassPointer = NULL;

UClass* AAmbientSoundNonLoop::pClassPointer = NULL;

UClass* AAmbientSoundSimpleToggleable::pClassPointer = NULL;

UClass* AAmbientSoundNonLoopingToggleable::pClassPointer = NULL;

UClass* AAmbientSoundSpline::pClassPointer = NULL;

UClass* AAmbientSoundSimpleSpline::pClassPointer = NULL;

UClass* AAmbientSoundSplineMultiCue::pClassPointer = NULL;

UClass* UDistributionFloatSoundParameter::pClassPointer = NULL;

UClass* USoundNode::pClassPointer = NULL;

UClass* UForcedLoopSoundNode::pClassPointer = NULL;

UClass* USoundNodeAmbient::pClassPointer = NULL;

UClass* USoundNodeAmbientNonLoop::pClassPointer = NULL;

UClass* USoundNodeAmbientNonLoopToggle::pClassPointer = NULL;

UClass* USoundNodeAttenuation::pClassPointer = NULL;

UClass* USoundNodeAttenuationAndGain::pClassPointer = NULL;

UClass* USoundNodeConcatenator::pClassPointer = NULL;

UClass* USoundNodeConcatenatorRadio::pClassPointer = NULL;

UClass* USoundNodeDelay::pClassPointer = NULL;

UClass* USoundNodeDistanceCrossFade::pClassPointer = NULL;

UClass* USoundNodeDoppler::pClassPointer = NULL;

UClass* USoundNodeEnveloper::pClassPointer = NULL;

UClass* USoundNodeLooping::pClassPointer = NULL;

UClass* USoundNodeMature::pClassPointer = NULL;

UClass* USoundNodeMixer::pClassPointer = NULL;

UClass* USoundNodeModulator::pClassPointer = NULL;

UClass* USoundNodeModulatorContinuous::pClassPointer = NULL;

UClass* USoundNodeOscillator::pClassPointer = NULL;

UClass* USoundNodeRandom::pClassPointer = NULL;

UClass* USoundNodeWave::pClassPointer = NULL;

UClass* USoundNodeWaveStreaming::pClassPointer = NULL;

UClass* USoundNodeWaveParam::pClassPointer = NULL;

UClass* ALandscapeProxy::pClassPointer = NULL;

UClass* ALandscape::pClassPointer = NULL;

UClass* ATerrain::pClassPointer = NULL;

UClass* ALandscapeGizmoActor::pClassPointer = NULL;

UClass* ALandscapeGizmoActiveActor::pClassPointer = NULL;

UClass* ULandscapeComponent::pClassPointer = NULL;

UClass* ULandscapeGizmoRenderComponent::pClassPointer = NULL;

UClass* ULandscapeHeightfieldCollisionComponent::pClassPointer = NULL;

UClass* UTerrainComponent::pClassPointer = NULL;

UClass* UH7CombatListLayerInfoObject::pClassPointer = NULL;

UClass* UH7LandscapeGameLayerInfoData::pClassPointer = NULL;

UClass* ULandscapeInfo::pClassPointer = NULL;

UClass* ULandscapeLayerInfoObject::pClassPointer = NULL;

UClass* UTerrainWeightMapTexture::pClassPointer = NULL;

UClass* UTerrainLayerSetup::pClassPointer = NULL;

UClass* UTerrainMaterial::pClassPointer = NULL;

UClass* UDataStoreClient::pClassPointer = NULL;

UClass* UConsole::pClassPointer = NULL;

UClass* UInput::pClassPointer = NULL;

UClass* UPlayerInput::pClassPointer = NULL;

UClass* UPlayerManagerInteraction::pClassPointer = NULL;

UClass* UUISceneClient::pClassPointer = NULL;

UClass* UUISoundTheme::pClassPointer = NULL;

UClass* UUIDataStoreSubscriber::pClassPointer = NULL;

UClass* UUIDataStorePublisher::pClassPointer = NULL;

UClass* UUIDataProvider::pClassPointer = NULL;

UClass* UUIDataProvider_OnlinePlayerDataBase::pClassPointer = NULL;

UClass* UUIDataProvider_OnlineFriendMessages::pClassPointer = NULL;

UClass* UUIDataProvider_OnlineFriends::pClassPointer = NULL;

UClass* UUIDataProvider_OnlinePartyChatList::pClassPointer = NULL;

UClass* UUIDataProvider_OnlinePlayerStorage::pClassPointer = NULL;

UClass* UUIDataProvider_OnlineProfileSettings::pClassPointer = NULL;

UClass* UUIDataProvider_PlayerAchievements::pClassPointer = NULL;

UClass* UUIDataProvider_OnlinePlayerStorageArray::pClassPointer = NULL;

UClass* UUIDataProvider_SettingsArray::pClassPointer = NULL;

UClass* UUIDataStore::pClassPointer = NULL;

UClass* UUIDataStore_DynamicResource::pClassPointer = NULL;

UClass* UUIDataStore_Fonts::pClassPointer = NULL;

UClass* UUIDataStore_GameResource::pClassPointer = NULL;

UClass* UUIDataStore_MenuItems::pClassPointer = NULL;

UClass* UUIDataStore_GameState::pClassPointer = NULL;

UClass* UUIDataStore_Registry::pClassPointer = NULL;

UClass* UUIDataStore_Remote::pClassPointer = NULL;

UClass* UUIDataStore_OnlineGameSearch::pClassPointer = NULL;

UClass* UUIDataStore_OnlinePlayerData::pClassPointer = NULL;

UClass* UUIDataStore_OnlineStats::pClassPointer = NULL;

UClass* UUIDataStore_Settings::pClassPointer = NULL;

UClass* UUIDataStore_OnlineGameSettings::pClassPointer = NULL;

UClass* UUIDataStore_StringBase::pClassPointer = NULL;

UClass* UUIDataStore_InputAlias::pClassPointer = NULL;

UClass* UUIDataStore_StringAliasMap::pClassPointer = NULL;

UClass* UUIPropertyDataProvider::pClassPointer = NULL;

UClass* UUIDataProvider_Settings::pClassPointer = NULL;

UClass* UUIResourceDataProvider::pClassPointer = NULL;

UClass* UUIDataProvider_MenuItem::pClassPointer = NULL;

UClass* UUIResourceCombinationProvider::pClassPointer = NULL;

UClass* UGameUISceneClient::pClassPointer = NULL;

UClass* UScene::pClassPointer = NULL;

UClass* AInstancedFoliageActor::pClassPointer = NULL;

UClass* AInteractiveFoliageActor::pClassPointer = NULL;

UClass* UInteractiveFoliageComponent::pClassPointer = NULL;

UClass* UActorFactoryInteractiveFoliage::pClassPointer = NULL;

UClass* AFluidInfluenceActor::pClassPointer = NULL;

UClass* AFluidSurfaceActor::pClassPointer = NULL;

UClass* AFluidSurfaceActorMovable::pClassPointer = NULL;

UClass* UFluidInfluenceComponent::pClassPointer = NULL;

UClass* UFluidSurfaceComponent::pClassPointer = NULL;

UClass* ASpeedTreeActor::pClassPointer = NULL;

UClass* USpeedTreeComponent::pClassPointer = NULL;

UClass* USpeedTreeActorFactory::pClassPointer = NULL;

UClass* USpeedTreeComponentFactory::pClassPointer = NULL;

UClass* USpeedTree::pClassPointer = NULL;

UClass* ALensFlareSource::pClassPointer = NULL;

UClass* ULensFlareComponent::pClassPointer = NULL;

UClass* ULensFlare::pClassPointer = NULL;

UClass* UTextureFlipBook::pClassPointer = NULL;

UClass* UTexture2DComposite::pClassPointer = NULL;

UClass* UTexture2DDynamic::pClassPointer = NULL;

UClass* UTextureCube::pClassPointer = NULL;

UClass* UTextureMovie::pClassPointer = NULL;

UClass* UTextureRenderTarget::pClassPointer = NULL;

UClass* UTextureRenderTarget2D::pClassPointer = NULL;

UClass* UScriptedTexture::pClassPointer = NULL;

UClass* UTextureRenderTargetCube::pClassPointer = NULL;

UClass* UTextureRenderTarget2DEngine::pClassPointer = NULL;

UClass* UAudioDevice::pClassPointer = NULL;

UClass* USoundClass::pClassPointer = NULL;

UClass* USoundMode::pClassPointer = NULL;

UClass* AMatineePawn::pClassPointer = NULL;

UClass* AScout::pClassPointer = NULL;

UClass* ALight::pClassPointer = NULL;

UClass* ADirectionalLight::pClassPointer = NULL;

UClass* ADirectionalLightToggleable::pClassPointer = NULL;

UClass* ADominantDirectionalLight::pClassPointer = NULL;

UClass* ADominantDirectionalLightMovable::pClassPointer = NULL;

UClass* APointLight::pClassPointer = NULL;

UClass* ADominantPointLight::pClassPointer = NULL;

UClass* APointLightMovable::pClassPointer = NULL;

UClass* APointLightToggleable::pClassPointer = NULL;

UClass* ASkyLight::pClassPointer = NULL;

UClass* ASkyLightToggleable::pClassPointer = NULL;

UClass* ASpotLight::pClassPointer = NULL;

UClass* ADominantSpotLight::pClassPointer = NULL;

UClass* AGeneratedMeshAreaLight::pClassPointer = NULL;

UClass* ASpotLightMovable::pClassPointer = NULL;

UClass* ASpotLightToggleable::pClassPointer = NULL;

UClass* AStaticLightCollectionActor::pClassPointer = NULL;

UClass* ULightComponent::pClassPointer = NULL;

UClass* UDirectionalLightComponent::pClassPointer = NULL;

UClass* UDominantDirectionalLightComponent::pClassPointer = NULL;

UClass* UPointLightComponent::pClassPointer = NULL;

UClass* UDominantPointLightComponent::pClassPointer = NULL;

UClass* USpotLightComponent::pClassPointer = NULL;

UClass* UDominantSpotLightComponent::pClassPointer = NULL;

UClass* USkyLightComponent::pClassPointer = NULL;

UClass* USphericalHarmonicLightComponent::pClassPointer = NULL;

UClass* ULightEnvironmentComponent::pClassPointer = NULL;

UClass* UDynamicLightEnvironmentComponent::pClassPointer = NULL;

UClass* UParticleLightEnvironmentComponent::pClassPointer = NULL;

UClass* UDrawLightConeComponent::pClassPointer = NULL;

UClass* UDrawLightRadiusComponent::pClassPointer = NULL;

UClass* ULightFunction::pClassPointer = NULL;

UClass* USkeletalMeshComponent::pClassPointer = NULL;

UClass* USkeletalMesh::pClassPointer = NULL;

UClass* USkeletalMeshSocket::pClassPointer = NULL;

UClass* ASplineActor::pClassPointer = NULL;

UClass* ASplineLoftActor::pClassPointer = NULL;

UClass* ASplineLoftActorMovable::pClassPointer = NULL;

UClass* USplineComponent::pClassPointer = NULL;

UClass* AProcBuilding::pClassPointer = NULL;

UClass* AProcBuilding_SimpleLODActor::pClassPointer = NULL;

UClass* UPBRuleNodeBase::pClassPointer = NULL;

UClass* UPBRuleNodeAlternate::pClassPointer = NULL;

UClass* UPBRuleNodeComment::pClassPointer = NULL;

UClass* UPBRuleNodeCorner::pClassPointer = NULL;

UClass* UPBRuleNodeCycle::pClassPointer = NULL;

UClass* UPBRuleNodeEdgeAngle::pClassPointer = NULL;

UClass* UPBRuleNodeEdgeMesh::pClassPointer = NULL;

UClass* UPBRuleNodeExtractTopBottom::pClassPointer = NULL;

UClass* UPBRuleNodeLODQuad::pClassPointer = NULL;

UClass* UPBRuleNodeMesh::pClassPointer = NULL;

UClass* UPBRuleNodeOcclusion::pClassPointer = NULL;

UClass* UPBRuleNodeQuad::pClassPointer = NULL;

UClass* UPBRuleNodeRandom::pClassPointer = NULL;

UClass* UPBRuleNodeRepeat::pClassPointer = NULL;

UClass* UPBRuleNodeSize::pClassPointer = NULL;

UClass* UPBRuleNodeSplit::pClassPointer = NULL;

UClass* UPBRuleNodeSubRuleset::pClassPointer = NULL;

UClass* UPBRuleNodeTransform::pClassPointer = NULL;

UClass* UPBRuleNodeVariation::pClassPointer = NULL;

UClass* UPBRuleNodeWindowWall::pClassPointer = NULL;

UClass* UProcBuildingRuleset::pClassPointer = NULL;

UClass* AReplicationInfo::pClassPointer = NULL;

UClass* AGameReplicationInfo::pClassPointer = NULL;

UClass* APlayerReplicationInfo::pClassPointer = NULL;

UClass* ATeamInfo::pClassPointer = NULL;

UClass* ACamera::pClassPointer = NULL;

UClass* ACameraActor::pClassPointer = NULL;

UClass* ADynamicCameraActor::pClassPointer = NULL;

UClass* UCameraAnim::pClassPointer = NULL;

UClass* UCameraAnimInst::pClassPointer = NULL;

UClass* UCameraModifier::pClassPointer = NULL;

UClass* UCameraModifier_CameraShake::pClassPointer = NULL;

UClass* UCameraShake::pClassPointer = NULL;

UClass* UCloudStorageUpgradeHelper::pClassPointer = NULL;

UClass* UAnalyticEventsBase::pClassPointer = NULL;

UClass* UMultiProviderAnalytics::pClassPointer = NULL;

UClass* UAppNotificationsBase::pClassPointer = NULL;

UClass* UCloudStorageBase::pClassPointer = NULL;

UClass* UFacebookIntegration::pClassPointer = NULL;

UClass* UGoogleIntegration::pClassPointer = NULL;

UClass* UInAppMessageBase::pClassPointer = NULL;

UClass* UInGameAdManager::pClassPointer = NULL;

UClass* UTwitterIntegrationBase::pClassPointer = NULL;

UClass* UPlatformInterfaceWebResponse::pClassPointer = NULL;

UClass* USeqEvent_MobileTouch::pClassPointer = NULL;

UClass* USeqAct_AttachToActor::pClassPointer = NULL;

UClass* USeqAct_ToggleHidden::pClassPointer = NULL;

UClass* USeqAct_SetVelocity::pClassPointer = NULL;

UClass* USeqAct_Teleport::pClassPointer = NULL;

UClass* USeqAct_Destroy::pClassPointer = NULL;

UClass* ULocalMessage::pClassPointer = NULL;

UClass* USeqEvent_HitWall::pClassPointer = NULL;

UClass* UOnlinePlayerInterface::pClassPointer = NULL;

UClass* USharedCloudFileInterface::pClassPointer = NULL;

UClass* UUserCloudFileInterface::pClassPointer = NULL;

UClass* UOnlineSocialInterface::pClassPointer = NULL;

UClass* UOnlineTitleFileCacheInterface::pClassPointer = NULL;

UClass* UOnlineTitleFileInterface::pClassPointer = NULL;

UClass* UOnlinePartyChatInterface::pClassPointer = NULL;

UClass* UOnlineNewsInterface::pClassPointer = NULL;

UClass* UOnlineStatsInterface::pClassPointer = NULL;

UClass* UOnlineVoiceInterface::pClassPointer = NULL;

UClass* UOnlineContentInterface::pClassPointer = NULL;

UClass* UOnlineGameInterface::pClassPointer = NULL;

UClass* UOnlineSystemInterface::pClassPointer = NULL;

UClass* UOnlinePlayerInterfaceEx::pClassPointer = NULL;

UClass* UOnlineAccountInterface::pClassPointer = NULL;

UClass* AAccessControl::pClassPointer = NULL;

UClass* AAdmin::pClassPointer = NULL;

UClass* AApexDestructibleActorSpawnable::pClassPointer = NULL;

UClass* AEmitterSpawnable::pClassPointer = NULL;

UClass* AKAssetSpawnable::pClassPointer = NULL;

UClass* UActorFactorySkeletalMeshCinematic::pClassPointer = NULL;

UClass* UActorFactorySkeletalMeshMAT::pClassPointer = NULL;

UClass* USeqAct_ToggleGodMode::pClassPointer = NULL;

UClass* USeqEvent_Death::pClassPointer = NULL;

UClass* USeqAct_ControlMovieTexture::pClassPointer = NULL;

UClass* USeqAct_SetSoundMode::pClassPointer = NULL;

UClass* USeqAct_FlyThroughHasEnded::pClassPointer = NULL;

UClass* USeqAct_ConsoleCommand::pClassPointer = NULL;

UClass* USeqAct_ToggleCinematicMode::pClassPointer = NULL;

UClass* USeqAct_ForceFeedback::pClassPointer = NULL;

UClass* USeqAct_ToggleHUD::pClassPointer = NULL;

UClass* USeqAct_ToggleInput::pClassPointer = NULL;

UClass* UDmgType_Suicided::pClassPointer = NULL;

UClass* UGameMessage::pClassPointer = NULL;

UClass* ACoverReplicator::pClassPointer = NULL;

UClass* USplineComponentSimplified::pClassPointer = NULL;

UClass* AAmbientSoundSimpleSplineNonLoop::pClassPointer = NULL;

UClass* UAnimNotify_PlayFaceFXAnim::pClassPointer = NULL;

UClass* ABroadcastHandler::pClassPointer = NULL;

UClass* UHttpFactory::pClassPointer = NULL;

UClass* UCloudSaveSystemKVSInterface::pClassPointer = NULL;

UClass* UCloudSaveSystemDataBlobStoreInterface::pClassPointer = NULL;

UClass* UCloudStorageBaseCloudSaveSystemKVS::pClassPointer = NULL;

UClass* AColorScaleVolume::pClassPointer = NULL;

UClass* USeqAct_SetDamageInstigator::pClassPointer = NULL;

UClass* AVolumeTimer::pClassPointer = NULL;

UClass* UDmgType_Crushed::pClassPointer = NULL;

UClass* UDmgType_Fell::pClassPointer = NULL;

UClass* UDmgType_Telefragged::pClassPointer = NULL;

UClass* ADynamicPhysicsVolume::pClassPointer = NULL;

UClass* ADynamicTriggerVolume::pClassPointer = NULL;

UClass* USeqAct_SetParticleSysParam::pClassPointer = NULL;

UClass* AExponentialHeightFog::pClassPointer = NULL;

UClass* UFailedConnect::pClassPointer = NULL;

UClass* AFracturedSMActorSpawnable::pClassPointer = NULL;

UClass* AFracturedStaticMeshActor_Spawnable::pClassPointer = NULL;

UClass* USeqEvent_PlayerSpawned::pClassPointer = NULL;

UClass* AHeightFog::pClassPointer = NULL;

UClass* AInterpActor_ForCinematic::pClassPointer = NULL;

UClass* AMaterialInstanceTimeVaryingActor::pClassPointer = NULL;

UClass* USeqAct_GiveInventory::pClassPointer = NULL;

UClass* USeqAct_AssignController::pClassPointer = NULL;

UClass* ANavMeshBoundsVolume::pClassPointer = NULL;

UClass* UOnlineCommunityContentInterface::pClassPointer = NULL;

UClass* UOnlineEventsInterface::pClassPointer = NULL;

UClass* UOnlinePlaylistGameTypeProvider::pClassPointer = NULL;

UClass* UOnlineRecentPlayersList::pClassPointer = NULL;

UClass* UOnlineSuppliedUIInterface::pClassPointer = NULL;

UClass* APathNode_Dynamic::pClassPointer = NULL;

UClass* USeqEvent_AIReachedRouteActor::pClassPointer = NULL;

UClass* USeqEvent_PickupStatusChange::pClassPointer = NULL;

UClass* ARadialBlurActor::pClassPointer = NULL;

UClass* USeqAct_ToggleConstraintDrive::pClassPointer = NULL;

UClass* ARB_BSJointActor::pClassPointer = NULL;

UClass* ARB_ConstraintActorSpawnable::pClassPointer = NULL;

UClass* ARB_HingeActor::pClassPointer = NULL;

UClass* ARB_PrismaticActor::pClassPointer = NULL;

UClass* ARB_PulleyJointActor::pClassPointer = NULL;

UClass* AReverbVolumeToggleable::pClassPointer = NULL;

UClass* USeqAct_AddRemoveFaceFXAnimSet::pClassPointer = NULL;

UClass* USeqAct_AIAbortMoveToActor::pClassPointer = NULL;

UClass* USeqAct_MITV_Activate::pClassPointer = NULL;

UClass* USeqAct_SetMatInstTexParam::pClassPointer = NULL;

UClass* USeqAct_SetMatInstVectorParam::pClassPointer = NULL;

UClass* USeqAct_SetSkelControlTarget::pClassPointer = NULL;

UClass* USeqAct_SetVector::pClassPointer = NULL;

UClass* USeqAct_ToggleAffectedByHitEffects::pClassPointer = NULL;

UClass* USeqAct_UpdatePhysBonesFromAnim::pClassPointer = NULL;

UClass* USeqEvent_LOS::pClassPointer = NULL;

UClass* USeqVar_Byte::pClassPointer = NULL;

UClass* USeqVar_Name::pClassPointer = NULL;

UClass* USeqVar_Union::pClassPointer = NULL;

UClass* ASkeletalMeshActorMATSpawnable::pClassPointer = NULL;

UClass* ASkeletalMeshActorMATWalkable::pClassPointer = NULL;

UClass* ATrigger_Dynamic::pClassPointer = NULL;

UClass* ATrigger_LOS::pClassPointer = NULL;

UClass* ATriggeredPath::pClassPointer = NULL;

UClass* ATriggerStreamingLevel::pClassPointer = NULL;

UClass* UUICharacterSummary::pClassPointer = NULL;

UClass* UUIGameInfoSummary::pClassPointer = NULL;

UClass* UUIMapSummary::pClassPointer = NULL;

UClass* UUIWeaponSummary::pClassPointer = NULL;

UClass* UUserCloudFileCloudSaveSystemDataBlobStore::pClassPointer = NULL;

UClass* AWaterVolume::pClassPointer = NULL;

UClass* AWindDirectionalSource::pClassPointer = NULL;

UClass* UDynamicSpriteComponent::pClassPointer = NULL;

UClass* AFrameworkGame::pClassPointer = NULL;

UClass* AGameAIController::pClassPointer = NULL;

UClass* UGameAICommand::pClassPointer = NULL;

UClass* AGameCameraBlockingVolume::pClassPointer = NULL;

UClass* AGamePlayerController::pClassPointer = NULL;

UClass* UGameCheatManager::pClassPointer = NULL;

UClass* AGameCrowdAgent::pClassPointer = NULL;

UClass* AGameCrowdAgentSkeletal::pClassPointer = NULL;

UClass* AGameCrowdAgentSM::pClassPointer = NULL;

UClass* UGameCrowdAgentBehavior::pClassPointer = NULL;

UClass* UGameCrowdBehavior_PlayAnimation::pClassPointer = NULL;

UClass* UGameCrowdBehavior_RunFromPanic::pClassPointer = NULL;

UClass* UGameCrowdBehavior_WaitForGroup::pClassPointer = NULL;

UClass* UGameCrowdBehavior_WaitInQueue::pClassPointer = NULL;

UClass* UGameCrowdGroup::pClassPointer = NULL;

UClass* AGameCrowdInfoVolume::pClassPointer = NULL;

UClass* AGameCrowdInteractionPoint::pClassPointer = NULL;

UClass* AGameCrowdBehaviorPoint::pClassPointer = NULL;

UClass* AGameCrowdDestination::pClassPointer = NULL;

UClass* AGameCrowdDestinationQueuePoint::pClassPointer = NULL;

UClass* AGameCrowdPopulationManager::pClassPointer = NULL;

UClass* AGameCrowdReplicationActor::pClassPointer = NULL;

UClass* AGameCrowdSpawnRelativeActor::pClassPointer = NULL;

UClass* UGameDestinationConnRenderingComponent::pClassPointer = NULL;

UClass* UGameExplosion::pClassPointer = NULL;

UClass* AGameExplosionActor::pClassPointer = NULL;

UClass* AGamePawn::pClassPointer = NULL;

UClass* ADebugCameraController::pClassPointer = NULL;

UClass* UGameTypes::pClassPointer = NULL;

UClass* AMobileHUD::pClassPointer = NULL;

UClass* UMobileInputZone::pClassPointer = NULL;

UClass* UMobileMenuObject::pClassPointer = NULL;

UClass* UMobileMenuImage::pClassPointer = NULL;

UClass* UMobileMenuScene::pClassPointer = NULL;

UClass* UMobilePlayerInput::pClassPointer = NULL;

UClass* UNavMeshGoal_OutOfViewFrom::pClassPointer = NULL;

UClass* UNavMeshPath_BiasAgainstPolysWithinDistanceOfLocations::pClassPointer = NULL;

UClass* USecondaryViewportClient::pClassPointer = NULL;

UClass* UMobileSecondaryViewportClient::pClassPointer = NULL;

UClass* USeqAct_ControlGameMovie::pClassPointer = NULL;

UClass* USeqAct_Deproject::pClassPointer = NULL;

UClass* USeqAct_GameCrowdPopulationManagerToggle::pClassPointer = NULL;

UClass* USeqAct_GameCrowdSpawner::pClassPointer = NULL;

UClass* USeqAct_MobileAddInputZones::pClassPointer = NULL;

UClass* USeqAct_MobileClearInputZones::pClassPointer = NULL;

UClass* USeqAct_MobileRemoveInputZone::pClassPointer = NULL;

UClass* USeqAct_MobileSaveLoadValue::pClassPointer = NULL;

UClass* USeqAct_ModifyProperty::pClassPointer = NULL;

UClass* USeqAct_PlayAgentAnimation::pClassPointer = NULL;

UClass* USeqEvent_CrowdAgentReachedDestination::pClassPointer = NULL;

UClass* USeqEvent_HudRender::pClassPointer = NULL;

UClass* USeqEvent_MobileBase::pClassPointer = NULL;

UClass* USeqEvent_MobileMotion::pClassPointer = NULL;

UClass* USeqEvent_MobileZoneBase::pClassPointer = NULL;

UClass* USeqEvent_MobileButton::pClassPointer = NULL;

UClass* USeqEvent_MobileInput::pClassPointer = NULL;

UClass* USeqEvent_MobileLook::pClassPointer = NULL;

UClass* USeqEvent_MobileRawInput::pClassPointer = NULL;

UClass* USeqEvent_MobileObjectPicker::pClassPointer = NULL;

UClass* USeqEvent_MobileSwipe::pClassPointer = NULL;

UClass* UGameSkelCtrl_Recoil::pClassPointer = NULL;

UClass* UGameCameraBase::pClassPointer = NULL;

UClass* UGameThirdPersonCamera::pClassPointer = NULL;

UClass* AGamePlayerCamera::pClassPointer = NULL;

UClass* UGameThirdPersonCameraMode::pClassPointer = NULL;

UClass* UGameThirdPersonCameraMode_Default::pClassPointer = NULL;

UClass* UGameSpecialMove::pClassPointer = NULL;

UClass* UGameStateObject::pClassPointer = NULL;

UClass* UGameStatsAggregator::pClassPointer = NULL;

UClass* UGameWaveForms::pClassPointer = NULL;

UClass* USeqAct_ToggleMouseCursor::pClassPointer = NULL;

UClass* ADebugCameraHUD::pClassPointer = NULL;

UClass* UDebugCameraInput::pClassPointer = NULL;

UClass* UGameCrowdSpawnInterface::pClassPointer = NULL;

UClass* ADynamicGameCrowdDestination::pClassPointer = NULL;

UClass* UGameAICmd_Hover_MoveToGoal::pClassPointer = NULL;

UClass* UGameAICmd_Hover_MoveToGoal_Mesh::pClassPointer = NULL;

UClass* UGameCrowd_ListOfAgents::pClassPointer = NULL;

UClass* UGameCrowdSpawnerInterface::pClassPointer = NULL;

UClass* AGameCrowdInteractionDestination::pClassPointer = NULL;

UClass* UGameExplosionContent::pClassPointer = NULL;

UClass* UGameFixedCamera::pClassPointer = NULL;

UClass* AGameKActorSpawnableEffect::pClassPointer = NULL;

UClass* AMobileDebugCameraController::pClassPointer = NULL;

UClass* UMobileDebugCameraInput::pClassPointer = NULL;

UClass* AMobileDebugCameraHUD::pClassPointer = NULL;

UClass* UMobileMenuBar::pClassPointer = NULL;

UClass* UMobileMenuBarItem::pClassPointer = NULL;

UClass* UMobileMenuButton::pClassPointer = NULL;

UClass* UMobileMenuElement::pClassPointer = NULL;

UClass* AMobileMenuGame::pClassPointer = NULL;

UClass* AMobileMenuPlayerController::pClassPointer = NULL;

UClass* UMobileMenuInventory::pClassPointer = NULL;

UClass* UMobileMenuLabel::pClassPointer = NULL;

UClass* UMobileMenuList::pClassPointer = NULL;

UClass* UMobileMenuListItem::pClassPointer = NULL;

UClass* UMobileMenuObjectProxy::pClassPointer = NULL;

UClass* AMobileTouchInputVolume::pClassPointer = NULL;

UClass* USeqEvent_MobileTouchInputVolume::pClassPointer = NULL;

UClass* UTouchableElement3D::pClassPointer = NULL;

UClass* APlayerCollectorGame::pClassPointer = NULL;

UClass* UPMESTG_LeaveADecalBase::pClassPointer = NULL;

UClass* USeqEvent_HudRenderImage::pClassPointer = NULL;

UClass* USeqEvent_HudRenderText::pClassPointer = NULL;

UClass* UBase64::pClassPointer = NULL;

UClass* UClientBeaconAddressResolver::pClassPointer = NULL;

UClass* UHTTPDownload::pClassPointer = NULL;

UClass* AInternetLink::pClassPointer = NULL;

UClass* ATcpLink::pClassPointer = NULL;

UClass* UMcpServiceBase::pClassPointer = NULL;

UClass* UMCPBase::pClassPointer = NULL;

UClass* UOnlineEventsInterfaceMcp::pClassPointer = NULL;

UClass* UOnlineNewsInterfaceMcp::pClassPointer = NULL;

UClass* UOnlineTitleFileDownloadBase::pClassPointer = NULL;

UClass* UOnlineTitleFileDownloadMcp::pClassPointer = NULL;

UClass* UOnlineTitleFileDownloadWeb::pClassPointer = NULL;

UClass* UTitleFileDownloadCache::pClassPointer = NULL;

UClass* UMcpMessageBase::pClassPointer = NULL;

UClass* UMcpMessageManager::pClassPointer = NULL;

UClass* UMcpUserCloudFileDownload::pClassPointer = NULL;

UClass* UMeshBeacon::pClassPointer = NULL;

UClass* UMeshBeaconClient::pClassPointer = NULL;

UClass* UMeshBeaconHost::pClassPointer = NULL;

UClass* UOnlineSubsystemCommonImpl::pClassPointer = NULL;

UClass* UOnlineAuthInterfaceImpl::pClassPointer = NULL;

UClass* UOnlineGameInterfaceImpl::pClassPointer = NULL;

UClass* UOnlinePlaylistManager::pClassPointer = NULL;

UClass* UPartyBeacon::pClassPointer = NULL;

UClass* UPartyBeaconClient::pClassPointer = NULL;

UClass* UPartyBeaconHost::pClassPointer = NULL;

UClass* UTcpipConnection::pClassPointer = NULL;

UClass* UTcpNetDriver::pClassPointer = NULL;

UClass* UWebRequest::pClassPointer = NULL;

UClass* UWebResponse::pClassPointer = NULL;

UClass* UOnlinePlaylistProvider::pClassPointer = NULL;

UClass* UUIDataStore_OnlinePlaylists::pClassPointer = NULL;

UClass* UWebApplication::pClassPointer = NULL;

UClass* AWebServer::pClassPointer = NULL;

UClass* UHelloWeb::pClassPointer = NULL;

UClass* UImageServer::pClassPointer = NULL;

UClass* UMcpServiceConfig::pClassPointer = NULL;

UClass* UMcpUserAuthRequestWrapper::pClassPointer = NULL;

UClass* UMcpUserManagerBase::pClassPointer = NULL;

UClass* UMcpClashMobBase::pClassPointer = NULL;

UClass* UMcpClashMobFileDownload::pClassPointer = NULL;

UClass* UMcpClashMobManager::pClassPointer = NULL;

UClass* UMcpClashMobManagerV3::pClassPointer = NULL;

UClass* UMcpGroupsBase::pClassPointer = NULL;

UClass* UMcpGroupsManager::pClassPointer = NULL;

UClass* UMcpGroupsManagerV3::pClassPointer = NULL;

UClass* UMcpIdMappingBase::pClassPointer = NULL;

UClass* UMcpIdMappingManager::pClassPointer = NULL;

UClass* UMcpIdMappingManagerV3::pClassPointer = NULL;

UClass* UMcpLeaderboardsBase::pClassPointer = NULL;

UClass* UMcpLeaderboardsV3::pClassPointer = NULL;

UClass* UMcpManagedValueManagerBase::pClassPointer = NULL;

UClass* UMcpManagedValueManager::pClassPointer = NULL;

UClass* UMcpMessageManagerV3::pClassPointer = NULL;

UClass* UMcpRemoteNotificationBase::pClassPointer = NULL;

UClass* UMcpRemoteNotificationV3::pClassPointer = NULL;

UClass* UMcpServerTimeBase::pClassPointer = NULL;

UClass* UMcpServerTimeManager::pClassPointer = NULL;

UClass* UMcpServerTimeManagerV3::pClassPointer = NULL;

UClass* UMcpSystemCloudFileManagerV3::pClassPointer = NULL;

UClass* UMcpThreadedChatBase::pClassPointer = NULL;

UClass* UMcpThreadedChatV3::pClassPointer = NULL;

UClass* UMcpUserAuthResponseWrapper::pClassPointer = NULL;

UClass* UMcpUserCloudFileManagerV3::pClassPointer = NULL;

UClass* UMcpUserInventoryBase::pClassPointer = NULL;

UClass* UMcpUserInventoryManager::pClassPointer = NULL;

UClass* UMcpUserInventoryManagerV3::pClassPointer = NULL;

UClass* UMcpUserManager::pClassPointer = NULL;

UClass* UMcpUserManagerV3::pClassPointer = NULL;

UClass* UOnlineImageDownloaderWeb::pClassPointer = NULL;

UClass* UTestClashMobManager::pClassPointer = NULL;

UClass* UTestMcpGroups::pClassPointer = NULL;

UClass* UTestMcpIdMapping::pClassPointer = NULL;

UClass* UTestMcpLeaderboards::pClassPointer = NULL;

UClass* UTestMcpManager::pClassPointer = NULL;

UClass* UTestMcpThreadedChat::pClassPointer = NULL;

UClass* UTestMcpUserFileManager::pClassPointer = NULL;

UClass* UTestMcpSystemFileManager::pClassPointer = NULL;

UClass* UTestMcpUserInventory::pClassPointer = NULL;

UClass* UTestMcpMessaging::pClassPointer = NULL;

UClass* UTestMcpUser::pClassPointer = NULL;

UClass* AWebConnection::pClassPointer = NULL;

UClass* UXAudio2Device::pClassPointer = NULL;

UClass* UGFxEngine::pClassPointer = NULL;

UClass* UGFxFSCmdHandler::pClassPointer = NULL;

UClass* UGFxInteraction::pClassPointer = NULL;

UClass* UGFxMoviePlayer::pClassPointer = NULL;

UClass* UGFxObject::pClassPointer = NULL;

UClass* UGFxRawData::pClassPointer = NULL;

UClass* USwfMovie::pClassPointer = NULL;

UClass* UFlashMovie::pClassPointer = NULL;

UClass* UGFxAction_CloseMovie::pClassPointer = NULL;

UClass* UGFxAction_GetVariable::pClassPointer = NULL;

UClass* UGFxAction_Invoke::pClassPointer = NULL;

UClass* UGFxAction_OpenMovie::pClassPointer = NULL;

UClass* UGFxAction_SetCaptureKeys::pClassPointer = NULL;

UClass* UGFxAction_SetVariable::pClassPointer = NULL;

UClass* UGFxEvent_FSCommand::pClassPointer = NULL;

UClass* UGFxFSCmdHandler_Kismet::pClassPointer = NULL;

UClass* UGFxClikWidget::pClassPointer = NULL;

UClass* UActorFactoryAkAmbientSound::pClassPointer = NULL;

UClass* AAkAmbientSound::pClassPointer = NULL;

UClass* UAkAudioDevice::pClassPointer = NULL;

UClass* UAkComponent::pClassPointer = NULL;

UClass* UInterpTrackAkEvent::pClassPointer = NULL;

UClass* UInterpTrackAkRTPC::pClassPointer = NULL;

UClass* UInterpTrackInstAkEvent::pClassPointer = NULL;

UClass* UInterpTrackInstAkRTPC::pClassPointer = NULL;

UClass* USeqAct_AkClearBanks::pClassPointer = NULL;

UClass* USeqAct_AkLoadBank::pClassPointer = NULL;

UClass* USeqAct_AkPostEvent::pClassPointer = NULL;

UClass* USeqAct_AkPostTrigger::pClassPointer = NULL;

UClass* USeqAct_AkSetRTPCValue::pClassPointer = NULL;

UClass* USeqAct_AkSetRTPCValueBus::pClassPointer = NULL;

UClass* USeqAct_AkSetState::pClassPointer = NULL;

UClass* USeqAct_AkSetSwitch::pClassPointer = NULL;

UClass* USeqAct_AkStartAmbientSound::pClassPointer = NULL;

UClass* USeqAct_AkStopAll::pClassPointer = NULL;

UClass* UFacebookWindows::pClassPointer = NULL;

UClass* UHttpRequestWindows::pClassPointer = NULL;

UClass* UHttpResponseWindows::pClassPointer = NULL;

UClass* USwrveAnalyticsWindows::pClassPointer = NULL;

UClass* UWindowsClient::pClassPointer = NULL;

UClass* UXnaForceFeedbackManager::pClassPointer = NULL;

UClass* UHttpRequestWindowsMcp::pClassPointer = NULL;

UClass* UOnlineGameInterfaceUPlay::pClassPointer = NULL;

UClass* UOnlineSubsystemUPlay::pClassPointer = NULL;

UClass* URDVAsyncTask::pClassPointer = NULL;

UClass* URDVAsyncTaskManager::pClassPointer = NULL;

UClass* URDVManager::pClassPointer = NULL;

UClass* UStormManager::pClassPointer = NULL;

UClass* UUbiservicesManager::pClassPointer = NULL;

UClass* UUPlayEventManager::pClassPointer = NULL;

UClass* UWorkshopControllerInterfaceUPlay::pClassPointer = NULL;

UClass* UIpNetDriverStorm::pClassPointer = NULL;

UClass* UIpNetConnectionStorm::pClassPointer = NULL;

UClass* UBinDiffPkgCommandlet::pClassPointer = NULL;

UClass* UDynamicMaterialEffect::pClassPointer = NULL;

UClass* ADynamicMaterialEffectVolume::pClassPointer = NULL;

UClass* AH7AtmosphericEffectVolume::pClassPointer = NULL;

UClass* UH7CampaignDataHolder::pClassPointer = NULL;

UClass* UH7CombatMapDataHolder::pClassPointer = NULL;

UClass* UH7ContentScanner::pClassPointer = NULL;

UClass* UH7ContentScannerListener::pClassPointer = NULL;

UClass* UH7DrawBoxComponent::pClassPointer = NULL;

UClass* UH7EngineUtility::pClassPointer = NULL;

UClass* AH7ErosionMapCapture::pClassPointer = NULL;

UClass* UH7GraphicsController::pClassPointer = NULL;

UClass* UH7LandscapeEditorTools::pClassPointer = NULL;

UClass* UH7ListingCampaign::pClassPointer = NULL;

UClass* UH7ListingCombatMap::pClassPointer = NULL;

UClass* UH7ListingMap::pClassPointer = NULL;

UClass* UH7MapDataHolder::pClassPointer = NULL;

UClass* UH7MapDataHolderCommon::pClassPointer = NULL;

UClass* UH7ObjectEditorTools::pClassPointer = NULL;

UClass* UImportAkEventsCommandlet::pClassPointer = NULL;

UClass* UInterpTrackVectorMaterialParamFromLocation::pClassPointer = NULL;

UClass* UMemLeakCheckEmptyCommandlet::pClassPointer = NULL;

UClass* URegenerateAllSoundbanksCommandlet::pClassPointer = NULL;

UClass* URenderTargetMaterialEffect::pClassPointer = NULL;

UClass* UTransferDataFromFXStructsToFXObjectsCommandlet::pClassPointer = NULL;

UClass* AH7RadiusDirectionalLight::pClassPointer = NULL;

UClass* UH7RadiusDirectionalLightComponent::pClassPointer = NULL;

UClass* AH7RadiusDominantDirectionalLight::pClassPointer = NULL;

UClass* UH7RadiusDominantDirectionalLightComponent::pClassPointer = NULL;

UClass* AH7RadiusSkylight::pClassPointer = NULL;

UClass* UH7RadiusSkylightComponent::pClassPointer = NULL;

UClass* UH7Texture2DStreamLoad::pClassPointer = NULL;

UClass* UBrushBuilder::pClassPointer = NULL;

UClass* UH7StructsAndEnumsNative::pClassPointer = NULL;

UClass* UH7AdventureLayerCellProperty::pClassPointer = NULL;

UClass* UH7CombatMapGridDecalComponent::pClassPointer = NULL;

UClass* UH7LandscapeFilteredDecalComponent::pClassPointer = NULL;

UClass* UH7ListingSavegame::pClassPointer = NULL;

UClass* UH7SavegameController::pClassPointer = NULL;

UClass* UH7SavegameDataHolder::pClassPointer = NULL;

UClass* UH7SavegameTask_Base::pClassPointer = NULL;

UClass* UH7SavegameTask_Checking::pClassPointer = NULL;

UClass* UH7SavegameTask_Delete::pClassPointer = NULL;

UClass* UH7SavegameTask_Loading::pClassPointer = NULL;

UClass* UH7SavegameTask_Saving::pClassPointer = NULL;

UClass* UH7SavegameTaskSlotManager::pClassPointer = NULL;

UClass* ASaveGameStatePlayerController::pClassPointer = NULL;

UClass* UH7ActorFactory::pClassPointer = NULL;

UClass* AH7CameraHeightVolume::pClassPointer = NULL;

UClass* AH7CellChangerActor::pClassPointer = NULL;

UClass* UH7EditorCameraHeightTool::pClassPointer = NULL;

UClass* UH7EditorCellOverlayComponent::pClassPointer = NULL;

UClass* AH7EditorDummyMapObject::pClassPointer = NULL;

UClass* UH7EditorItemType::pClassPointer = NULL;

UClass* UH7EditorScanner::pClassPointer = NULL;

UClass* UH7EditorTools::pClassPointer = NULL;

UClass* UH7IAdventureMapCellInteractor::pClassPointer = NULL;

UClass* UH7IEditorTerrainScan::pClassPointer = NULL;

UClass* UH7KismetHeroReplacer::pClassPointer = NULL;

UClass* UH7LandscapeGenerator::pClassPointer = NULL;

UClass* UH7ObjectLayerFilterConfig::pClassPointer = NULL;

UClass* UH7ObjectLayerFilterConfig_Artifacts::pClassPointer = NULL;

UClass* UH7ObjectLayerFilterConfig_Buildings::pClassPointer = NULL;

UClass* UH7ObjectLayerFilterConfig_Creatures::pClassPointer = NULL;

UClass* UH7ObjectLayerFilterConfig_Misc::pClassPointer = NULL;

UClass* UH7ObjectLayerFilterConfig_Resources::pClassPointer = NULL;

UClass* UH7ObjectLayerFilterConfig_Towns::pClassPointer = NULL;

UClass* ADecalActorSpawnable::pClassPointer = NULL;

UClass* UH7AchievementManager::pClassPointer = NULL;

UClass* AH7AdventureCellMarker::pClassPointer = NULL;

UClass* AH7CellFoWMarker::pClassPointer = NULL;

UClass* AH7CellTriggerArmy::pClassPointer = NULL;

UClass* AH7TileMarker::pClassPointer = NULL;

UClass* AH7TreasureMarker::pClassPointer = NULL;

UClass* AH7AdventureConfiguration::pClassPointer = NULL;

UClass* UH7AdventureMapPathfinder::pClassPointer = NULL;

UClass* AH7AiAdventureMap::pClassPointer = NULL;

UClass* UH7AiAdventureMapConfig::pClassPointer = NULL;

UClass* UH7AiSensorBase::pClassPointer = NULL;

UClass* UH7AiSensorAdvTargetThreat::pClassPointer = NULL;

UClass* UH7AiSensorInputConst::pClassPointer = NULL;

UClass* UH7BaseCell::pClassPointer = NULL;

UClass* UH7CombatMapCell::pClassPointer = NULL;

UClass* UH7EditorAdventureTile::pClassPointer = NULL;

UClass* UH7AdventureMapCell::pClassPointer = NULL;

UClass* UH7BaseCreatureStack::pClassPointer = NULL;

UClass* AH7BaseGameController::pClassPointer = NULL;

UClass* AH7AdventureController::pClassPointer = NULL;

UClass* AH7CombatController::pClassPointer = NULL;

UClass* UH7Calendar::pClassPointer = NULL;

UClass* AH7Camera::pClassPointer = NULL;

UClass* UH7CameraProperties::pClassPointer = NULL;

UClass* UH7CampaignDefinition::pClassPointer = NULL;

UClass* UH7CombatAction::pClassPointer = NULL;

UClass* UH7CombatResult::pClassPointer = NULL;

UClass* AH7CombatConfiguration::pClassPointer = NULL;

UClass* UH7CombatMapGrid::pClassPointer = NULL;

UClass* UH7CombatMapPathfinder::pClassPointer = NULL;

UClass* UH7Command::pClassPointer = NULL;

UClass* UH7CommandQueue::pClassPointer = NULL;

UClass* AH7ControllerManager::pClassPointer = NULL;

UClass* AH7CreatureStackBaseMover::pClassPointer = NULL;

UClass* AH7CreatureStackMovementControl::pClassPointer = NULL;

UClass* UH7CreatureVisuals::pClassPointer = NULL;

UClass* UH7DynGridObjInterface::pClassPointer = NULL;

UClass* AH7EditorAdventureGridManager::pClassPointer = NULL;

UClass* AH7AdventureGridManager::pClassPointer = NULL;

UClass* UH7EditorContent::pClassPointer = NULL;

UClass* AH7EditorMapGrid::pClassPointer = NULL;

UClass* AH7EditorAdventureGrid::pClassPointer = NULL;

UClass* AH7AdventureMapGridController::pClassPointer = NULL;

UClass* AH7EditorCombatGrid::pClassPointer = NULL;

UClass* AH7CombatMapGridController::pClassPointer = NULL;

UClass* AH7EditorMapObject::pClassPointer = NULL;

UClass* AH7AdventureObject::pClassPointer = NULL;

UClass* AH7RandomCreatureStack::pClassPointer = NULL;

UClass* AH7TargetableSite::pClassPointer = NULL;

UClass* AH7VisitableSite::pClassPointer = NULL;

UClass* AH7AreaOfControlSite::pClassPointer = NULL;

UClass* AH7AreaOfControlSiteLord::pClassPointer = NULL;

UClass* AH7Fort::pClassPointer = NULL;

UClass* AH7RandomFort::pClassPointer = NULL;

UClass* AH7Town::pClassPointer = NULL;

UClass* AH7RandomTown::pClassPointer = NULL;

UClass* AH7AreaOfControlSiteVassal::pClassPointer = NULL;

UClass* AH7AreaOfControlBuffSite::pClassPointer = NULL;

UClass* AH7Dwelling::pClassPointer = NULL;

UClass* AH7CustomNeutralDwelling::pClassPointer = NULL;

UClass* AH7RandomDwelling::pClassPointer = NULL;

UClass* AH7Mine::pClassPointer = NULL;

UClass* AH7AbandonedMine::pClassPointer = NULL;

UClass* AH7CaravanOutpost::pClassPointer = NULL;

UClass* AH7Garrison::pClassPointer = NULL;

UClass* AH7ItemPile::pClassPointer = NULL;

UClass* AH7RandomArtifact::pClassPointer = NULL;

UClass* AH7Keymaster::pClassPointer = NULL;

UClass* AH7KeymasterGate::pClassPointer = NULL;

UClass* AH7NeutralSite::pClassPointer = NULL;

UClass* AH7ArcaneAcademy::pClassPointer = NULL;

UClass* AH7ArcaneLibrary::pClassPointer = NULL;

UClass* AH7BattleSite::pClassPointer = NULL;

UClass* AH7CrusaderCommandery::pClassPointer = NULL;

UClass* AH7Prison::pClassPointer = NULL;

UClass* AH7BlindBrotherMonastery::pClassPointer = NULL;

UClass* AH7BuffSite::pClassPointer = NULL;

UClass* AH7Cartographer::pClassPointer = NULL;

UClass* AH7DenOfThieves::pClassPointer = NULL;

UClass* AH7DestructibleObjectManipulator::pClassPointer = NULL;

UClass* AH7FortuneTeller::pClassPointer = NULL;

UClass* AH7Merchant::pClassPointer = NULL;

UClass* AH7Observatory::pClassPointer = NULL;

UClass* AH7ObservatoryHQ::pClassPointer = NULL;

UClass* AH7PermanentBonusSite::pClassPointer = NULL;

UClass* AH7RandomItemSite::pClassPointer = NULL;

UClass* AH7ResourceDepot::pClassPointer = NULL;

UClass* AH7SchoolOfWar::pClassPointer = NULL;

UClass* AH7Shelter::pClassPointer = NULL;

UClass* AH7Shipyard::pClassPointer = NULL;

UClass* AH7SignPostBuoy::pClassPointer = NULL;

UClass* AH7Teleporter::pClassPointer = NULL;

UClass* AH7DimensionChannel::pClassPointer = NULL;

UClass* AH7DimensionChannelExit::pClassPointer = NULL;

UClass* AH7DimensionPortal::pClassPointer = NULL;

UClass* AH7Stairway::pClassPointer = NULL;

UClass* AH7Whirlpool::pClassPointer = NULL;

UClass* AH7TrainingGrounds::pClassPointer = NULL;

UClass* AH7Obelisk::pClassPointer = NULL;

UClass* AH7ResourcePile::pClassPointer = NULL;

UClass* AH7RandomResource::pClassPointer = NULL;

UClass* AH7PickableRandomResource::pClassPointer = NULL;

UClass* AH7RandomCampfire::pClassPointer = NULL;

UClass* AH7PickableCampfire::pClassPointer = NULL;

UClass* AH7RandomTreasureChest::pClassPointer = NULL;

UClass* AH7PickableChest::pClassPointer = NULL;

UClass* AH7RunicBox::pClassPointer = NULL;

UClass* AH7RunicGate::pClassPointer = NULL;

UClass* AH7Ship::pClassPointer = NULL;

UClass* AH7VisitingShell::pClassPointer = NULL;

UClass* AH7Area::pClassPointer = NULL;

UClass* AH7CombatObstacleObject::pClassPointer = NULL;

UClass* AH7CombatMapMoat::pClassPointer = NULL;

UClass* AH7CombatMapTrap::pClassPointer = NULL;

UClass* AH7CombatObstacleFracturedObject::pClassPointer = NULL;

UClass* AH7CombatMapGate::pClassPointer = NULL;

UClass* AH7CombatMapTower::pClassPointer = NULL;

UClass* AH7CombatMapWall::pClassPointer = NULL;

UClass* AH7EditorArmy::pClassPointer = NULL;

UClass* AH7AdventureArmy::pClassPointer = NULL;

UClass* AH7CaravanArmy::pClassPointer = NULL;

UClass* AH7CombatArmy::pClassPointer = NULL;

UClass* AH7PlayerStart::pClassPointer = NULL;

UClass* UH7EffectContainer::pClassPointer = NULL;

UClass* UH7BaseAbility::pClassPointer = NULL;

UClass* UH7CreatureAbility::pClassPointer = NULL;

UClass* UH7HeroItem::pClassPointer = NULL;

UClass* UH7TearOfAsha::pClassPointer = NULL;

UClass* UH7ItemSet::pClassPointer = NULL;

UClass* UH7EffectManager::pClassPointer = NULL;

UClass* UH7EnumDisplayNameHelper::pClassPointer = NULL;

UClass* UH7EventManager::pClassPointer = NULL;

UClass* UH7EventParam::pClassPointer = NULL;

UClass* UH7HeroEventParam::pClassPointer = NULL;

UClass* UH7MapEventParam::pClassPointer = NULL;

UClass* UH7PlayerEventParam::pClassPointer = NULL;

UClass* UH7TimerEventParam::pClassPointer = NULL;

UClass* UH7Faction::pClassPointer = NULL;

UClass* AH7FCTController::pClassPointer = NULL;

UClass* AH7Flag::pClassPointer = NULL;

UClass* UH7FlashMovieCntl::pClassPointer = NULL;

UClass* UH7DuelSetupWindowCntl::pClassPointer = NULL;

UClass* UH7MapSelectCntl::pClassPointer = NULL;

UClass* AH7FOWController::pClassPointer = NULL;

UClass* AH7FracturedMeshActor::pClassPointer = NULL;

UClass* AH7GameplayFracturedMeshActor::pClassPointer = NULL;

UClass* AH7FracturedWalkableObject::pClassPointer = NULL;

UClass* UH7FXObject::pClassPointer = NULL;

UClass* UH7GameData::pClassPointer = NULL;

UClass* UH7GameProcessor::pClassPointer = NULL;

UClass* UH7GameTypes::pClassPointer = NULL;

UClass* UH7GameUtility::pClassPointer = NULL;

UClass* UH7GameViewportClient::pClassPointer = NULL;

UClass* UH7GlobalName::pClassPointer = NULL;

UClass* UH7GUIGeneralProperties::pClassPointer = NULL;

UClass* UH7HallOfHeroesManager::pClassPointer = NULL;

UClass* UH7HashRandom::pClassPointer = NULL;

UClass* AH7HeroAnimControl::pClassPointer = NULL;

UClass* UH7HeroClass::pClassPointer = NULL;

UClass* UH7HeroEquipment::pClassPointer = NULL;

UClass* UH7HeroProgress::pClassPointer = NULL;

UClass* UH7HeroVisuals::pClassPointer = NULL;

UClass* UH7IActionable::pClassPointer = NULL;

UClass* UH7IAliasable::pClassPointer = NULL;

UClass* UH7IConditionable::pClassPointer = NULL;

UClass* UH7IDefendable::pClassPointer = NULL;

UClass* UH7IDestructible::pClassPointer = NULL;

UClass* UH7IEventManagingObject::pClassPointer = NULL;

UClass* UH7ICaster::pClassPointer = NULL;

UClass* UH7IEffectTargetable::pClassPointer = NULL;

UClass* UH7IHeroReplaceable::pClassPointer = NULL;

UClass* UH7IHideable::pClassPointer = NULL;

UClass* UH7ILocaParamizable::pClassPointer = NULL;

UClass* UH7InitiativeQueue::pClassPointer = NULL;

UClass* AH7InterpActor::pClassPointer = NULL;

UClass* UH7Inventory::pClassPointer = NULL;

UClass* UH7IOwnable::pClassPointer = NULL;

UClass* UH7IPickable::pClassPointer = NULL;

UClass* UH7IQuestTarget::pClassPointer = NULL;

UClass* UH7IRandomPropertyOwner::pClassPointer = NULL;

UClass* UH7IRandomSpawnable::pClassPointer = NULL;

UClass* UH7IStackContainer::pClassPointer = NULL;

UClass* UH7IThumbnailable::pClassPointer = NULL;

UClass* UH7ITriggerable::pClassPointer = NULL;

UClass* UH7IVoiceable::pClassPointer = NULL;

UClass* UH7KeybindManager::pClassPointer = NULL;

UClass* UH7Loca::pClassPointer = NULL;

UClass* UH7MapInfoBase::pClassPointer = NULL;

UClass* UH7MapInfo::pClassPointer = NULL;

UClass* UH7MapInfoCombat::pClassPointer = NULL;

UClass* UH7MapInfoCouncil::pClassPointer = NULL;

UClass* UH7Math::pClassPointer = NULL;

UClass* UH7MatineeManager::pClassPointer = NULL;

UClass* UH7MinimapNative::pClassPointer = NULL;

UClass* UH7Month::pClassPointer = NULL;

UClass* UH7OptionsManager::pClassPointer = NULL;

UClass* AH7ParticleEmitter::pClassPointer = NULL;

UClass* UH7PathList::pClassPointer = NULL;

UClass* AH7Player::pClassPointer = NULL;

UClass* UH7PlayerProfile::pClassPointer = NULL;

UClass* AH7PlayerReplicationInfo::pClassPointer = NULL;

UClass* UH7QuestController::pClassPointer = NULL;

UClass* AH7ReplicationInfo::pClassPointer = NULL;

UClass* UH7Resource::pClassPointer = NULL;

UClass* UH7ResourceSet::pClassPointer = NULL;

UClass* UH7RndSkillManager::pClassPointer = NULL;

UClass* AH7SceneCaptureMinimapActor::pClassPointer = NULL;

UClass* UH7SceneCaptureMinimapComponent::pClassPointer = NULL;

UClass* AH7ScriptingController::pClassPointer = NULL;

UClass* UH7SeqAct_ActivateEvent::pClassPointer = NULL;

UClass* UH7SeqAct_ActivateNpcScene::pClassPointer = NULL;

UClass* UH7SeqAct_ActivateQuest_New::pClassPointer = NULL;

UClass* UH7SeqAct_AdvanceQuestStage::pClassPointer = NULL;

UClass* UH7SeqAct_AMEventCameraAction::pClassPointer = NULL;

UClass* UH7SeqAct_Audio::pClassPointer = NULL;

UClass* UH7SeqAct_CellChange::pClassPointer = NULL;

UClass* UH7SeqAct_CellLayerDataChange::pClassPointer = NULL;

UClass* UH7SeqAct_ChangeLayerVisibility::pClassPointer = NULL;

UClass* UH7SeqAct_ChangeObjectCollision::pClassPointer = NULL;

UClass* UH7SeqAct_ChangeObjectVisibility::pClassPointer = NULL;

UClass* UH7SeqAct_ChangeSiteOwner::pClassPointer = NULL;

UClass* UH7SeqAct_ChangeTownAiSettings::pClassPointer = NULL;

UClass* UH7SeqAct_CompleteQuestObjective::pClassPointer = NULL;

UClass* UH7SeqAct_DeactivateEvent::pClassPointer = NULL;

UClass* UH7SeqAct_DestroyMine::pClassPointer = NULL;

UClass* UH7SeqAct_EndCurrentTurn::pClassPointer = NULL;

UClass* UH7SeqAct_EndNpcScene::pClassPointer = NULL;

UClass* UH7SeqAct_FailQuest::pClassPointer = NULL;

UClass* UH7SeqAct_FailQuestObjective::pClassPointer = NULL;

UClass* UH7SeqAct_FinalChoice::pClassPointer = NULL;

UClass* UH7SeqAct_FinishHeroTurn::pClassPointer = NULL;

UClass* UH7SeqAct_FireEvent::pClassPointer = NULL;

UClass* UH7SeqAct_FlagBuilding::pClassPointer = NULL;

UClass* UH7SeqAct_FocusCamera::pClassPointer = NULL;

UClass* UH7SeqAct_FortressChoice::pClassPointer = NULL;

UClass* UH7SeqAct_FullScreenMovieSetInputEnable::pClassPointer = NULL;

UClass* UH7SeqAct_GetExecutableParam::pClassPointer = NULL;

UClass* UH7SeqAct_GiveTakeCameraControl::pClassPointer = NULL;

UClass* UH7SeqAct_Hide_Reveal::pClassPointer = NULL;

UClass* UH7SeqAct_InterruptAction::pClassPointer = NULL;

UClass* UH7SeqAct_StartNpcScene::pClassPointer = NULL;

UClass* UH7SeqAct_LatentArmyAction::pClassPointer = NULL;

UClass* UH7SeqAct_AttackArmy::pClassPointer = NULL;

UClass* UH7SeqAct_InteractWithBuilding::pClassPointer = NULL;

UClass* UH7SeqAct_MoveTo::pClassPointer = NULL;

UClass* UH7SeqAct_MoveToArmy::pClassPointer = NULL;

UClass* UH7SeqAct_MoveToBuilding::pClassPointer = NULL;

UClass* UH7SeqAct_MoveToTile::pClassPointer = NULL;

UClass* UH7SeqAct_RotateArmy::pClassPointer = NULL;

UClass* UH7SeqAct_LoseMap::pClassPointer = NULL;

UClass* UH7SeqAct_ManipulateDestructibleState::pClassPointer = NULL;

UClass* UH7SeqAct_ManipulateHero::pClassPointer = NULL;

UClass* UH7SeqAct_AddRandomHeroItem::pClassPointer = NULL;

UClass* UH7SeqAct_BaseHeroItems::pClassPointer = NULL;

UClass* UH7SeqAct_ModHeroItems::pClassPointer = NULL;

UClass* UH7SeqAct_TransferHeroItems::pClassPointer = NULL;

UClass* UH7SeqAct_ClearHeroUnits::pClassPointer = NULL;

UClass* UH7SeqAct_ModHeroBuffs::pClassPointer = NULL;

UClass* UH7SeqAct_ModHeroSkills::pClassPointer = NULL;

UClass* UH7SeqAct_ModHeroSpells::pClassPointer = NULL;

UClass* UH7SeqAct_ModHeroStacksize::pClassPointer = NULL;

UClass* UH7SeqAct_ModHeroUnits::pClassPointer = NULL;

UClass* UH7SeqAct_ModHeroXP::pClassPointer = NULL;

UClass* UH7SeqAct_SelectHeroOfCurrentPlayer::pClassPointer = NULL;

UClass* UH7SeqAct_SetHeroMovementPoint::pClassPointer = NULL;

UClass* UH7SeqAct_TransferHeroUnits::pClassPointer = NULL;

UClass* UH7SeqAct_ManipulateHeroes::pClassPointer = NULL;

UClass* UH7SeqAct_ChangeHeroAggressiveness::pClassPointer = NULL;

UClass* UH7SeqAct_ChangeHeroOwner::pClassPointer = NULL;

UClass* UH7SeqAct_RemoveHero::pClassPointer = NULL;

UClass* UH7SeqAct_SetHeroHibernationState::pClassPointer = NULL;

UClass* UH7SeqAct_ManipulateTownBuilding::pClassPointer = NULL;

UClass* UH7SeqAct_ModBuildingBuffs::pClassPointer = NULL;

UClass* UH7SeqAct_ModPlayerBuffs::pClassPointer = NULL;

UClass* UH7SeqAct_Narration::pClassPointer = NULL;

UClass* UH7SeqAct_BaseDialogue::pClassPointer = NULL;

UClass* UH7SeqAct_ShowDialogue::pClassPointer = NULL;

UClass* UH7SeqAct_StartShowDialogue::pClassPointer = NULL;

UClass* UH7SeqAct_BaseText::pClassPointer = NULL;

UClass* UH7SeqAct_ShowText::pClassPointer = NULL;

UClass* UH7SeqAct_StartShowText::pClassPointer = NULL;

UClass* UH7SeqAct_HighlightGUIElement::pClassPointer = NULL;

UClass* UH7SeqAct_ShowCouncilDialogue::pClassPointer = NULL;

UClass* UH7SeqAct_ShowNote::pClassPointer = NULL;

UClass* UH7SeqAct_ObjectActivator::pClassPointer = NULL;

UClass* UH7SeqAct_ObjectiveAndGate::pClassPointer = NULL;

UClass* UH7SeqAct_ObjectiveAndGateStatus::pClassPointer = NULL;

UClass* UH7SeqAct_OperateFogOfWar::pClassPointer = NULL;

UClass* UH7SeqAct_OverwriteHeroIcon::pClassPointer = NULL;

UClass* UH7SeqAct_PauseCurrentCombat::pClassPointer = NULL;

UClass* UH7SeqAct_Quest_NewNode::pClassPointer = NULL;

UClass* UH7SeqAct_QuestGroup::pClassPointer = NULL;

UClass* UH7SeqAct_QuestObjective::pClassPointer = NULL;

UClass* UH7SeqAct_RemoveCaravans::pClassPointer = NULL;

UClass* UH7SeqAct_RemoveMinimapTrackingObject::pClassPointer = NULL;

UClass* UH7SeqAct_ResumeCurrentCombat::pClassPointer = NULL;

UClass* UH7SeqAct_RevealFogOfWar::pClassPointer = NULL;

UClass* UH7SeqAct_RevertAudioSettings::pClassPointer = NULL;

UClass* UH7SeqAct_SetAkAmbientNode::pClassPointer = NULL;

UClass* UH7SeqAct_SetAudioSettings::pClassPointer = NULL;

UClass* UH7SeqAct_SetCombatCoolCamAllowed::pClassPointer = NULL;

UClass* UH7SeqAct_SetDiplomacy::pClassPointer = NULL;

UClass* UH7SeqAct_SetDwellingCreaturesPool::pClassPointer = NULL;

UClass* UH7SeqAct_SetListenerCinematic::pClassPointer = NULL;

UClass* UH7SeqAct_SetNPCProperties::pClassPointer = NULL;

UClass* UH7SeqAct_SetResource::pClassPointer = NULL;

UClass* UH7SeqAct_SetShellState::pClassPointer = NULL;

UClass* UH7SeqAct_SetSurrenderFlee::pClassPointer = NULL;

UClass* UH7SeqAct_SetTownDwellingCreaturePool::pClassPointer = NULL;

UClass* UH7SeqAct_SetUnitAIControl::pClassPointer = NULL;

UClass* UH7SeqAct_ShowFloatingText::pClassPointer = NULL;

UClass* UH7SeqAct_SpawnAdventureObject::pClassPointer = NULL;

UClass* UH7SeqAct_SpawnArmy::pClassPointer = NULL;

UClass* UH7SeqAct_SpawnCaravan::pClassPointer = NULL;

UClass* UH7SeqAct_StartTimer::pClassPointer = NULL;

UClass* UH7SeqAct_ToggleCutscene::pClassPointer = NULL;

UClass* UH7SeqAct_UnlockStorypoint::pClassPointer = NULL;

UClass* UH7SeqAct_VisitAndGarrison::pClassPointer = NULL;

UClass* UH7SeqAct_WinMap::pClassPointer = NULL;

UClass* UH7SeqCon_Condition::pClassPointer = NULL;

UClass* UH7SeqCon_ArmiesDefeated::pClassPointer = NULL;

UClass* UH7SeqCon_MinesDestroyed::pClassPointer = NULL;

UClass* UH7SeqCon_TimePassed::pClassPointer = NULL;

UClass* UH7SeqCon_ArmyHas::pClassPointer = NULL;

UClass* UH7SeqCon_ArmyHasCreatures::pClassPointer = NULL;

UClass* UH7SeqCon_ArmyHasCreaturesFromFaction::pClassPointer = NULL;

UClass* UH7SeqCon_ArmyHasHero::pClassPointer = NULL;

UClass* UH7SeqCon_ArmyHasHeroFromFaction::pClassPointer = NULL;

UClass* UH7SeqCon_ArmyHasPlayer::pClassPointer = NULL;

UClass* UH7SeqCon_ArmyHasPlayerFromFaction::pClassPointer = NULL;

UClass* UH7SeqCon_BuildingIsFromFaction::pClassPointer = NULL;

UClass* UH7SeqCon_DestructibleObjectIs::pClassPointer = NULL;

UClass* UH7SeqCon_EventIs::pClassPointer = NULL;

UClass* UH7SeqCon_Player::pClassPointer = NULL;

UClass* UH7SeqCon_CanReachHero::pClassPointer = NULL;

UClass* UH7SeqCon_CheckArmyStrength::pClassPointer = NULL;

UClass* UH7SeqCon_CollectedSouls::pClassPointer = NULL;

UClass* UH7SeqCon_DaysPassedWithNoTown::pClassPointer = NULL;

UClass* UH7SeqCon_DefeatAmountOfArmies::pClassPointer = NULL;

UClass* UH7SeqCon_GatherResources::pClassPointer = NULL;

UClass* UH7SeqCon_GovernorOfTown::pClassPointer = NULL;

UClass* UH7SeqCon_HasBuilding::pClassPointer = NULL;

UClass* UH7SeqCon_HasBuiltTearOfAsha::pClassPointer = NULL;

UClass* UH7SeqCon_HasCollectedArmies::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWith::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroFromFaction::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroOfClass::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithAbility::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithAffinity::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithArtifact::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithSkill::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithSpecialization::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithSpell::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithStat::pClassPointer = NULL;

UClass* UH7SeqCon_HasHeroWithItem::pClassPointer = NULL;

UClass* UH7SeqCon_HasNoEnemyPlayer::pClassPointer = NULL;

UClass* UH7SeqCon_HasNoHero::pClassPointer = NULL;

UClass* UH7SeqCon_HasNoTown::pClassPointer = NULL;

UClass* UH7SeqCon_HasPlunderedMines::pClassPointer = NULL;

UClass* UH7SeqCon_HasResourcePercentage::pClassPointer = NULL;

UClass* UH7SeqCon_HasTownLevel::pClassPointer = NULL;

UClass* UH7SeqCon_HasVisitedSite::pClassPointer = NULL;

UClass* UH7SeqCon_HasVisitedTownBuilding::pClassPointer = NULL;

UClass* UH7SeqCon_HeroDefeated::pClassPointer = NULL;

UClass* UH7SeqCon_HoldCreatures::pClassPointer = NULL;

UClass* UH7SeqCon_HoldCreaturesByTier::pClassPointer = NULL;

UClass* UH7SeqCon_LostCreatures::pClassPointer = NULL;

UClass* UH7SeqCon_OwnSite::pClassPointer = NULL;

UClass* UH7SeqCon_PlayerIsFromFaction::pClassPointer = NULL;

UClass* UH7SeqCon_ReachLvl::pClassPointer = NULL;

UClass* UH7SeqCon_SitesVisited::pClassPointer = NULL;

UClass* UH7SeqCon_TimeUp::pClassPointer = NULL;

UClass* UH7SeqCon_QuestIs::pClassPointer = NULL;

UClass* UH7SeqCon_TimerReachedCount::pClassPointer = NULL;

UClass* UH7SeqCon_Event::pClassPointer = NULL;

UClass* UH7SeqCon_HasPrivileg::pClassPointer = NULL;

UClass* UH7SeqCon_VictoryConditionGate::pClassPointer = NULL;

UClass* UH7SeqEvent::pClassPointer = NULL;

UClass* UH7SeqEvent_DestructibleObjectUsed::pClassPointer = NULL;

UClass* UH7SeqEvent_CompletesDestruction::pClassPointer = NULL;

UClass* UH7SeqEvent_CompletesReparation::pClassPointer = NULL;

UClass* UH7SeqEvent_StartsDestruction::pClassPointer = NULL;

UClass* UH7SeqEvent_StartsReparation::pClassPointer = NULL;

UClass* UH7SeqEvent_HeroEvent::pClassPointer = NULL;

UClass* UH7SeqEvent_Battlesite::pClassPointer = NULL;

UClass* UH7SeqEvent_BattlesiteLost::pClassPointer = NULL;

UClass* UH7SeqEvent_BattlesiteWon::pClassPointer = NULL;

UClass* UH7SeqEvent_CollectArmy::pClassPointer = NULL;

UClass* UH7SeqEvent_CollectSpecificArmy::pClassPointer = NULL;

UClass* UH7SeqEvent_CombatTrigger::pClassPointer = NULL;

UClass* UH7SeqEvent_Combat::pClassPointer = NULL;

UClass* UH7SeqEvent_CombatMapEnd::pClassPointer = NULL;

UClass* UH7SeqEvent_CombatMapStarted::pClassPointer = NULL;

UClass* UH7SeqEvent_EnterLeaveShip::pClassPointer = NULL;

UClass* UH7SeqEvent_HasMoved::pClassPointer = NULL;

UClass* UH7SeqEvent_LearnAbility::pClassPointer = NULL;

UClass* UH7SeqEvent_LearnSkill::pClassPointer = NULL;

UClass* UH7SeqEvent_LearnSpell::pClassPointer = NULL;

UClass* UH7SeqEvent_Loot::pClassPointer = NULL;

UClass* UH7SeqEvent_PlunderedMine::pClassPointer = NULL;

UClass* UH7SeqEvent_ReachLevel::pClassPointer = NULL;

UClass* UH7SeqEvent_SiteCaptured::pClassPointer = NULL;

UClass* UH7SeqEvent_TalkedToNPC::pClassPointer = NULL;

UClass* UH7SeqEvent_VisitDwellingMine::pClassPointer = NULL;

UClass* UH7SeqEvent_VisitNeutralBuilding::pClassPointer = NULL;

UClass* UH7SeqEvent_VisitShell::pClassPointer = NULL;

UClass* UH7SeqEvent_VisitTown::pClassPointer = NULL;

UClass* UH7SeqEvent_MapFinished::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerEvent::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerGetsVisibilityOf::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerGetsVisibilityOfArmy::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerGetsVisibilityOfBuilding::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerGetsVisibilityOfTile::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerTurn::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerVisitsTownBuilding::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerWinLoseGame::pClassPointer = NULL;

UClass* UH7SeqEvent_TimerExpired::pClassPointer = NULL;

UClass* UH7SeqEvent_AdvCombatTransition::pClassPointer = NULL;

UClass* UH7SeqEvent_CellEventArmy::pClassPointer = NULL;

UClass* UH7SeqEvent_MapLoaded::pClassPointer = NULL;

UClass* AH7SiegeMapDecoration::pClassPointer = NULL;

UClass* UH7SoundController::pClassPointer = NULL;

UClass* AH7SoundManager::pClassPointer = NULL;

UClass* AH7SynchRNG::pClassPointer = NULL;

UClass* UH7TeamManager::pClassPointer = NULL;

UClass* AH7TestCaseThreadTaskActor::pClassPointer = NULL;

UClass* AH7TextureLoader::pClassPointer = NULL;

UClass* AH7TownAsset::pClassPointer = NULL;

UClass* UH7TownBuilding::pClassPointer = NULL;

UClass* UH7BlackMarket::pClassPointer = NULL;

UClass* UH7Inscriber::pClassPointer = NULL;

UClass* UH7TownCastingStage::pClassPointer = NULL;

UClass* UH7TownDwelling::pClassPointer = NULL;

UClass* UH7TownFortificationEnhancer::pClassPointer = NULL;

UClass* UH7TownGrowthEnhancer::pClassPointer = NULL;

UClass* UH7TownGuardGrowthEnhancer::pClassPointer = NULL;

UClass* UH7TownHall::pClassPointer = NULL;

UClass* UH7TownMagicGuild::pClassPointer = NULL;

UClass* UH7TownPortal::pClassPointer = NULL;

UClass* UH7TownTearOfAsha::pClassPointer = NULL;

UClass* UH7TownThiefGuild::pClassPointer = NULL;

UClass* UH7TransitionData::pClassPointer = NULL;

UClass* AH7Unit::pClassPointer = NULL;

UClass* AH7Creature::pClassPointer = NULL;

UClass* AH7CreatureStack::pClassPointer = NULL;

UClass* AH7EditorHero::pClassPointer = NULL;

UClass* AH7AdventureHero::pClassPointer = NULL;

UClass* AH7CombatHero::pClassPointer = NULL;

UClass* AH7EditorRuneUnit::pClassPointer = NULL;

UClass* AH7EditorWarUnit::pClassPointer = NULL;

UClass* AH7RuneUnit::pClassPointer = NULL;

UClass* AH7TowerUnit::pClassPointer = NULL;

UClass* AH7WarUnit::pClassPointer = NULL;

UClass* UH7UnitCoverManager::pClassPointer = NULL;

UClass* AH7UnitFX::pClassPointer = NULL;

UClass* AH7HeroFX::pClassPointer = NULL;

UClass* UH7UnitSlotFXProperties::pClassPointer = NULL;

UClass* UH7UPlayTask::pClassPointer = NULL;

UClass* UH7AchievementTask::pClassPointer = NULL;

UClass* UH7ActionTask::pClassPointer = NULL;

UClass* UH7RewardTask::pClassPointer = NULL;

UClass* UH7WalkableInterface::pClassPointer = NULL;

UClass* AH7WalkableObject::pClassPointer = NULL;

UClass* UH7WeekManager::pClassPointer = NULL;

UClass* AH7PlayerController::pClassPointer = NULL;

UClass* AH7CombatPlayerController::pClassPointer = NULL;

UClass* AH7AdventurePlayerController::pClassPointer = NULL;

UClass* UH7AbilityManager::pClassPointer = NULL;

UClass* UH7AuraManager::pClassPointer = NULL;

UClass* UH7BuffManager::pClassPointer = NULL;

UClass* UH7Effect::pClassPointer = NULL;

UClass* UH7EffectAudioVisual::pClassPointer = NULL;

UClass* UH7EffectCharges::pClassPointer = NULL;

UClass* UH7EffectCommand::pClassPointer = NULL;

UClass* UH7EffectDamage::pClassPointer = NULL;

UClass* UH7EffectDestroyAura::pClassPointer = NULL;

UClass* UH7EffectDuration::pClassPointer = NULL;

UClass* UH7EffectDurationModifier::pClassPointer = NULL;

UClass* UH7EffectInitAura::pClassPointer = NULL;

UClass* UH7EffectOnResistance::pClassPointer = NULL;

UClass* UH7EffectOnStats::pClassPointer = NULL;

UClass* UH7EffectSpecial::pClassPointer = NULL;

UClass* UH7EffectWithSpells::pClassPointer = NULL;

UClass* UH7EffectAddRandomBuffFromList::pClassPointer = NULL;

UClass* UH7EffectCharge::pClassPointer = NULL;

UClass* UH7HeroAbility::pClassPointer = NULL;

UClass* UH7RuneAbility::pClassPointer = NULL;

UClass* UH7WarfareAbility::pClassPointer = NULL;

UClass* UH7BaseBuff::pClassPointer = NULL;

UClass* UH7BuffHeroArmyBonus::pClassPointer = NULL;

UClass* UH7Skill::pClassPointer = NULL;

UClass* UH7Week::pClassPointer = NULL;

UClass* UH7EffectDelegateRevealMap::pClassPointer = NULL;

UClass* UH7EffectDivergeEnemyHeroManaCost::pClassPointer = NULL;

UClass* UH7EffectFlanking::pClassPointer = NULL;

UClass* UH7EffectLearnSpell::pClassPointer = NULL;

UClass* UH7EffectLink::pClassPointer = NULL;

UClass* UH7EffectLuck::pClassPointer = NULL;

UClass* UH7EffectMagicAbsorption::pClassPointer = NULL;

UClass* UH7EffectModifyBuffDuration::pClassPointer = NULL;

UClass* UH7EffectModifySpellRank::pClassPointer = NULL;

UClass* UH7EffectOverrideHeroNegotiation::pClassPointer = NULL;

UClass* UH7EffectPortalOfAsha::pClassPointer = NULL;

UClass* UH7EffectRefundManaCost::pClassPointer = NULL;

UClass* UH7EffectResetRandomBuffDuration::pClassPointer = NULL;

UClass* UH7EffectSpecialAdditionalCounter::pClassPointer = NULL;

UClass* UH7EffectSpecialAddResources::pClassPointer = NULL;

UClass* UH7EffectSpecialAddResourcesToTarget::pClassPointer = NULL;

UClass* UH7EffectSpecialAddRuneUnit::pClassPointer = NULL;

UClass* UH7EffectSpecialAllowAlliedMoveThrough::pClassPointer = NULL;

UClass* UH7EffectSpecialAuraMutator::pClassPointer = NULL;

UClass* UH7EffectSpecialBuffDurationModifier::pClassPointer = NULL;

UClass* UH7EffectSpecialBuffJump::pClassPointer = NULL;

UClass* UH7EffectSpecialCapStat::pClassPointer = NULL;

UClass* UH7EffectSpecialCastOnEffectTarget::pClassPointer = NULL;

UClass* UH7EffectSpecialCastOnRandomTarget::pClassPointer = NULL;

UClass* UH7EffectSpecialChainLightning::pClassPointer = NULL;

UClass* UH7EffectSpecialChangeAnimationAndMoveSpeed::pClassPointer = NULL;

UClass* UH7EffectSpecialChangeFlankability::pClassPointer = NULL;

UClass* UH7EffectSpecialChangeMovementType::pClassPointer = NULL;

UClass* UH7EffectSpecialCollapseAbility::pClassPointer = NULL;

UClass* UH7EffectSpecialConditionalStatMod::pClassPointer = NULL;

UClass* UH7EffectSpecialCreaturePoolModify::pClassPointer = NULL;

UClass* UH7EffectSpecialCreatureTeleport::pClassPointer = NULL;

UClass* UH7EffectSpecialCreatureUpgradeCostModifier::pClassPointer = NULL;

UClass* UH7EffectSpecialDamageMultiplier::pClassPointer = NULL;

UClass* UH7EffectSpecialDamageMultiplierPerTarget::pClassPointer = NULL;

UClass* UH7EffectSpecialDeathMarch::pClassPointer = NULL;

UClass* UH7EffectSpecialDecreaseBuildingCosts::pClassPointer = NULL;

UClass* UH7EffectSpecialDecreaseRecruitingCosts::pClassPointer = NULL;

UClass* UH7EffectSpecialDisableFleeSurrender::pClassPointer = NULL;

UClass* UH7EffectSpecialEnableScouting::pClassPointer = NULL;

UClass* UH7EffectSpecialExpandGrowthEffects::pClassPointer = NULL;

UClass* UH7EffectSpecialFaceOfFear::pClassPointer = NULL;

UClass* UH7EffectSpecialFamiliarTerrain::pClassPointer = NULL;

UClass* UH7EffectSpecialGlobalRuler::pClassPointer = NULL;

UClass* UH7EffectSpecialGlobalTradeModifier::pClassPointer = NULL;

UClass* UH7EffectSpecialImplosion::pClassPointer = NULL;

UClass* UH7EffectSpecialIncreaseAuraSize::pClassPointer = NULL;

UClass* UH7EffectSpecialIncreaseBuildingAmountPerDay::pClassPointer = NULL;

UClass* UH7EffectSpecialInitialDamageReduction::pClassPointer = NULL;

UClass* UH7EffectSpecialInstantReinforcements::pClassPointer = NULL;

UClass* UH7EffectSpecialKill::pClassPointer = NULL;

UClass* UH7EffectSpecialKillCreaturesOnHeroArmy::pClassPointer = NULL;

UClass* UH7EffectSpecialKillTopCreature::pClassPointer = NULL;

UClass* UH7EffectSpecialLifeDrain::pClassPointer = NULL;

UClass* UH7EffectSpecialLimitKills::pClassPointer = NULL;

UClass* UH7EffectSpecialLoseAction::pClassPointer = NULL;

UClass* UH7EffectSpecialManeuver::pClassPointer = NULL;

UClass* UH7EffectSpecialModifiedDamageOverTime::pClassPointer = NULL;

UClass* UH7EffectSpecialModifyManaCost::pClassPointer = NULL;

UClass* UH7EffectSpecialModifyStackSize::pClassPointer = NULL;

UClass* UH7EffectSpecialModifyStatBoniFromBuffs::pClassPointer = NULL;

UClass* UH7EffectSpecialModifyTargetType::pClassPointer = NULL;

UClass* UH7EffectSpecialModifyTerrainMovementCost::pClassPointer = NULL;

UClass* UH7EffectSpecialMoveObstacle::pClassPointer = NULL;

UClass* UH7EffectSpecialNecromancy::pClassPointer = NULL;

UClass* UH7EffectSpecialNeutralGrowthMultiplier::pClassPointer = NULL;

UClass* UH7EffectSpecialOverrideMinimumRank::pClassPointer = NULL;

UClass* UH7EffectSpecialPerfectOffense::pClassPointer = NULL;

UClass* UH7EffectSpecialProvideCover::pClassPointer = NULL;

UClass* UH7EffectSpecialPushAway::pClassPointer = NULL;

UClass* UH7EffectSpecialPushback::pClassPointer = NULL;

UClass* UH7EffectSpecialReappearCreatureOnGrid::pClassPointer = NULL;

UClass* UH7EffectSpecialRecruitersOutpost::pClassPointer = NULL;

UClass* UH7EffectSpecialRedirectDamage::pClassPointer = NULL;

UClass* UH7EffectSpecialRefundResourceCost::pClassPointer = NULL;

UClass* UH7EffectSpecialRemoveBuffs::pClassPointer = NULL;

UClass* UH7EffectSpecialRemoveCreatureFromGrid::pClassPointer = NULL;

UClass* UH7EffectSpecialReplaceTargets::pClassPointer = NULL;

UClass* UH7EffectSpecialResetIdolOfFertility::pClassPointer = NULL;

UClass* UH7EffectSpecialRetrieveTearOfAsha::pClassPointer = NULL;

UClass* UH7EffectSpecialReturnToPosition::pClassPointer = NULL;

UClass* UH7EffectSpecialSetErraticCellCover::pClassPointer = NULL;

UClass* UH7EffectSpecialShadowOfDeath::pClassPointer = NULL;

UClass* UH7EffectSpecialShieldEffect::pClassPointer = NULL;

UClass* UH7EffectSpecialSoulReaver::pClassPointer = NULL;

UClass* UH7EffectSpecialSpreadBuff::pClassPointer = NULL;

UClass* UH7EffectSpecialStackRegeneration::pClassPointer = NULL;

UClass* UH7EffectSpecialStasis::pClassPointer = NULL;

UClass* UH7EffectSpecialStormLord::pClassPointer = NULL;

UClass* UH7EffectSpecialSummonCreatureStack::pClassPointer = NULL;

UClass* UH7EffectSpecialSummonObstacle::pClassPointer = NULL;

UClass* UH7EffectSpecialSummonShip::pClassPointer = NULL;

UClass* UH7EffectSpecialSummonWarfareUnit::pClassPointer = NULL;

UClass* UH7EffectSpecialTeleport::pClassPointer = NULL;

UClass* UH7EffectSpecialTsunami::pClassPointer = NULL;

UClass* UH7EffectSpecialWait::pClassPointer = NULL;

UClass* UH7EffectTeachExperience::pClassPointer = NULL;

UClass* UH7EffectTeachSpells::pClassPointer = NULL;

UClass* UH7EffectWarunitControl::pClassPointer = NULL;

UClass* UH7IEffectDelegate::pClassPointer = NULL;

UClass* UH7SkillManager::pClassPointer = NULL;

UClass* UH7UnitSnapShot::pClassPointer = NULL;

UClass* UGenerateRMGDataCommandlet::pClassPointer = NULL;

UClass* UH7RMGAreaTemplateBuilder::pClassPointer = NULL;

UClass* UH7RMGBuilding::pClassPointer = NULL;

UClass* UH7RMGResourceCluster::pClassPointer = NULL;

UClass* UH7RMGTeleporter::pClassPointer = NULL;

UClass* UH7RMGTreasureMarker::pClassPointer = NULL;

UClass* UH7RMGCell::pClassPointer = NULL;

UClass* UH7RMGCirclePacker::pClassPointer = NULL;

UClass* UH7RMGConnectionPrefab::pClassPointer = NULL;

UClass* UH7RMGData::pClassPointer = NULL;

UClass* UH7RMGFoliageTool::pClassPointer = NULL;

UClass* UH7RMGGrid::pClassPointer = NULL;

UClass* UH7RMGHeightmapBuilder::pClassPointer = NULL;

UClass* UH7RMGHeightSetup::pClassPointer = NULL;

UClass* AH7RMGInGameGenerator::pClassPointer = NULL;

UClass* UH7RMGInGameProperties::pClassPointer = NULL;

UClass* UH7RMGKamadaKawaiLayout::pClassPointer = NULL;

UClass* UH7RMGKawaiiUtil::pClassPointer = NULL;

UClass* UH7RMGLandscapeBuilder::pClassPointer = NULL;

UClass* UH7RMGLandscapeThemes::pClassPointer = NULL;

UClass* UH7RMGMain::pClassPointer = NULL;

UClass* UH7RMGMinimalSpanningTree::pClassPointer = NULL;

UClass* UH7RMGPathfinder::pClassPointer = NULL;

UClass* UH7RMGPerlinNoise::pClassPointer = NULL;

UClass* UH7RMGRandom::pClassPointer = NULL;

UClass* UH7RMGRoadConnector::pClassPointer = NULL;

UClass* UH7RMGStructsAndEnums::pClassPointer = NULL;

UClass* UH7RMGTemplateSpawner::pClassPointer = NULL;

UClass* UH7RMGTopologySetup::pClassPointer = NULL;

UClass* UH7RMGWaterSetup::pClassPointer = NULL;

UClass* UH7RMGWeightmapBuilder::pClassPointer = NULL;

UClass* UH7RMGZoneGraphBuilder::pClassPointer = NULL;

UClass* UH7RMGZoneTemplate::pClassPointer = NULL;

UClass* UGFxInputField::pClassPointer = NULL;

UClass* UH7AiActionBase::pClassPointer = NULL;

UClass* UH7AiActionParam::pClassPointer = NULL;

UClass* AH7GameInfo::pClassPointer = NULL;

UClass* UH7MultiplayerGameManager::pClassPointer = NULL;

UClass* UH7OnlineGameSettings::pClassPointer = NULL;

UClass* AH7AdventureMapInfo::pClassPointer = NULL;

UClass* AH7Hud::pClassPointer = NULL;

UClass* AH7CombatHud::pClassPointer = NULL;

UClass* AH7AdventureHud::pClassPointer = NULL;

UClass* AH73PGameInfo::pClassPointer = NULL;

UClass* AH73PPlayerController::pClassPointer = NULL;

UClass* UH7StructsAndEnums::pClassPointer = NULL;

UClass* UH7MessageCallbacks::pClassPointer = NULL;

UClass* UH7FlashMoviePopupCntl::pClassPointer = NULL;

UClass* UH7FlashMovieBlockPopupCntl::pClassPointer = NULL;

UClass* UH7LoadSaveWindowCntl::pClassPointer = NULL;

UClass* UPlayerProfileState::pClassPointer = NULL;

UClass* UH7SaveGameHeaderManager::pClassPointer = NULL;

UClass* UH7RequestPopupCntl::pClassPointer = NULL;

UClass* UH7InstantCommandBase::pClassPointer = NULL;

UClass* UH7InstantCommandSaveGame::pClassPointer = NULL;

UClass* UH7InstantCommandManager::pClassPointer = NULL;

UClass* UH7GFxListener::pClassPointer = NULL;

UClass* UH7GFxUIContainer::pClassPointer = NULL;

UClass* UH7GUIOverlaySystemCntl::pClassPointer = NULL;

UClass* UH7CombatHudCntl::pClassPointer = NULL;

UClass* AH7PostprocessManager::pClassPointer = NULL;

UClass* AH7MainMenuHud::pClassPointer = NULL;

UClass* UH7LogSystemCntl::pClassPointer = NULL;

UClass* UH7SkirmishSetupWindowCntl::pClassPointer = NULL;

UClass* UH7TownHudCntl::pClassPointer = NULL;

UClass* UH7SpellbookCntl::pClassPointer = NULL;

UClass* UH7MessageSystem::pClassPointer = NULL;

UClass* AH7CouncilManager::pClassPointer = NULL;

UClass* UH7PauseMenuCntl::pClassPointer = NULL;

UClass* UH7HeropediaCntl::pClassPointer = NULL;

UClass* UH7TownAssetLoader::pClassPointer = NULL;

UClass* UH7PatchingController::pClassPointer = NULL;

UClass* UH7MessageMapping::pClassPointer = NULL;

UClass* UH7Message::pClassPointer = NULL;

UClass* UH7AdventureHudCntl::pClassPointer = NULL;

UClass* UH7MultiplayerCommandManager::pClassPointer = NULL;

UClass* UH7IOffGridDeployable::pClassPointer = NULL;

UClass* UH7InstantCommandSynchUp::pClassPointer = NULL;

UClass* AH7CameraActionController::pClassPointer = NULL;

UClass* UH7OverlaySystemCntl::pClassPointer = NULL;

UClass* UH7SpectatorHUDCntl::pClassPointer = NULL;

UClass* UH7OptionsMenuCntl::pClassPointer = NULL;

UClass* UH7GUISoundPlayer::pClassPointer = NULL;

UClass* UH7CombatUnitInfoCntl::pClassPointer = NULL;

UClass* UH7GFxDamageTooltipSystem::pClassPointer = NULL;

UClass* UH7InstantCommandBuildAll::pClassPointer = NULL;

UClass* UH7InstantCommandIncreaseResource::pClassPointer = NULL;

UClass* UH7InstantCommandHeroAddXp::pClassPointer = NULL;

UClass* UH7InstantCommandBuildCaravanOutpost::pClassPointer = NULL;

UClass* UH7InstantCommandDoubleArmy::pClassPointer = NULL;

UClass* UH7GFxOptionsMenu::pClassPointer = NULL;

UClass* UH7FlashMovieTownPopupCntl::pClassPointer = NULL;

UClass* UH7ThievesGuildPopupCntl::pClassPointer = NULL;

UClass* UH7GFxMinimap::pClassPointer = NULL;

UClass* UH7TownRecruitmentPopupCntl::pClassPointer = NULL;

UClass* UH7GFxHeroHUD::pClassPointer = NULL;

UClass* AH7CouncilInteractive::pClassPointer = NULL;

UClass* AH7CouncilFlagActor::pClassPointer = NULL;

UClass* AH7CouncilMapManager::pClassPointer = NULL;

UClass* UH7ListeningManager::pClassPointer = NULL;

UClass* UH7IGUIListenable::pClassPointer = NULL;

UClass* UH7TreasureHuntCntl::pClassPointer = NULL;

UClass* UH7InstantCommandPlunder::pClassPointer = NULL;

UClass* UH7ITooltipable::pClassPointer = NULL;

UClass* AH7CameraAction::pClassPointer = NULL;

UClass* AH7AbilityCastCameraAction::pClassPointer = NULL;

UClass* UH7InstantCommandLearnSpell::pClassPointer = NULL;

UClass* UH7ActorFactoryAdventureArmy::pClassPointer = NULL;

UClass* UH7ActorFactoryArea::pClassPointer = NULL;

UClass* UH7ActorFactoryCellChangerActor::pClassPointer = NULL;

UClass* UH7ActorFactoryCellFoWMarker::pClassPointer = NULL;

UClass* UH7ActorFactoryCellTrigger_Army::pClassPointer = NULL;

UClass* UH7ActorFactoryDeploymentArea::pClassPointer = NULL;

UClass* AH7DeploymentArea::pClassPointer = NULL;

UClass* UH7ActorFactoryDestructibleObjectManipulator::pClassPointer = NULL;

UClass* UH7ActorFactoryTileMarker::pClassPointer = NULL;

UClass* UH7ActorFactoryTreasureMarker::pClassPointer = NULL;

UClass* AH7EmitterSpawnable::pClassPointer = NULL;

UClass* UH7InstantCommandSplitCreatureStack::pClassPointer = NULL;

UClass* UH7Deployment::pClassPointer = NULL;

UClass* UH7TownUtilityUnitDwelling::pClassPointer = NULL;

UClass* UH7AiActionCongregate::pClassPointer = NULL;

UClass* UH7InstantCommandMergeArmiesAI::pClassPointer = NULL;

UClass* UH7InstantCommandJoinArmy::pClassPointer = NULL;

UClass* UH7InstantCommandDismissCreatureStack::pClassPointer = NULL;

UClass* UH7ItemSlotMovieCntl::pClassPointer = NULL;

UClass* UH7HeroTradeWindowCntl::pClassPointer = NULL;

UClass* UH7InstantCommandUnifyStacks::pClassPointer = NULL;

UClass* AH7Caravan::pClassPointer = NULL;

UClass* AH7AdventureArmySpawnable::pClassPointer = NULL;

UClass* AH7ZoomInCameraAction::pClassPointer = NULL;

UClass* AH7ZoomOutCameraAction::pClassPointer = NULL;

UClass* AH7AMEventCameraAction::pClassPointer = NULL;

UClass* AH7WaypointBasedCameraAction::pClassPointer = NULL;

UClass* AH7PresentArmyCameraAction::pClassPointer = NULL;

UClass* AH7AttackCameraAction::pClassPointer = NULL;

UClass* AH7CouncilPlayerController::pClassPointer = NULL;

UClass* AH7IntroduceHeroCameraAction::pClassPointer = NULL;

UClass* AH7ArmyVictoryCameraAction::pClassPointer = NULL;

UClass* UH7CombatPopUpCntl::pClassPointer = NULL;

UClass* UH7WindowWeeklyCntl::pClassPointer = NULL;

UClass* UH7TradeResultCntl::pClassPointer = NULL;

UClass* UH7InstantCommandEndturn::pClassPointer = NULL;

UClass* UH7InstantCommandDoCombat::pClassPointer = NULL;

UClass* UH7InstantCommandLetEnemyFlee::pClassPointer = NULL;

UClass* UH7AdventureCursor::pClassPointer = NULL;

UClass* UH7AiAdventureSensors::pClassPointer = NULL;

UClass* UH7DialogCntl::pClassPointer = NULL;

UClass* UH7InstantCommandFinishCombat::pClassPointer = NULL;

UClass* UH7CheatWindowCntl::pClassPointer = NULL;

UClass* AH7BasePathPreviewer::pClassPointer = NULL;

UClass* AH7AdventureMapPathPreviewer::pClassPointer = NULL;

UClass* USaveGameState::pClassPointer = NULL;

UClass* UH7StatIcons::pClassPointer = NULL;

UClass* AH7Wave::pClassPointer = NULL;

UClass* UH7HeroClassProgress::pClassPointer = NULL;

UClass* UH7HeroBioData::pClassPointer = NULL;

UClass* AH7AiPatrolController::pClassPointer = NULL;

UClass* UH7MagicSchoolIcons::pClassPointer = NULL;

UClass* AH7CouncilMapping::pClassPointer = NULL;

UClass* UH7ButtonIcons::pClassPointer = NULL;

UClass* AH7APRColorMapping::pClassPointer = NULL;

UClass* UH7GFxLog::pClassPointer = NULL;

UClass* UH7CheatData::pClassPointer = NULL;

UClass* UH7TextColors::pClassPointer = NULL;

UClass* UH7JoinGameMenuCntl::pClassPointer = NULL;

UClass* UH7RandomMapWindowCntl::pClassPointer = NULL;

UClass* UH7MainMenuCntl::pClassPointer = NULL;

UClass* UH7GFxFlashController::pClassPointer = NULL;

UClass* UH7MouseCntl::pClassPointer = NULL;

UClass* UH7GFxMouse::pClassPointer = NULL;

UClass* UH7SeqEvent_PathSet::pClassPointer = NULL;

UClass* UH7SeqEvent_PopupChange::pClassPointer = NULL;

UClass* UH7BackgroundImageCntl::pClassPointer = NULL;

UClass* UH7BackgroundImageProperties::pClassPointer = NULL;

UClass* UH7LoadingScreenCntl::pClassPointer = NULL;

UClass* AH7CombatMapStatusBarController::pClassPointer = NULL;

UClass* AH7CreatureStackPlateController::pClassPointer = NULL;

UClass* UH7CombatMapTestCntl::pClassPointer = NULL;

UClass* UH7GFxTreasureHunt::pClassPointer = NULL;

UClass* UH7HeroWindowCntl::pClassPointer = NULL;

UClass* UH7QuestLogCntl::pClassPointer = NULL;

UClass* UH7SkillwheelCntl::pClassPointer = NULL;

UClass* UH7TurnOverCntl::pClassPointer = NULL;

UClass* UH7QuestCompleteCntl::pClassPointer = NULL;

UClass* UH7TownBuildingPopupCntl::pClassPointer = NULL;

UClass* UH7MarketPlacePopupCntl::pClassPointer = NULL;

UClass* UH7HallOfHerosPopupCntl::pClassPointer = NULL;

UClass* UH7TownFurnacePopUpCntl::pClassPointer = NULL;

UClass* UH7TownWarfarePopupCntl::pClassPointer = NULL;

UClass* UH7TownCaravanPopupCntl::pClassPointer = NULL;

UClass* UH7MagicGuildPopupCntl::pClassPointer = NULL;

UClass* UH7TownGuardPopupCntl::pClassPointer = NULL;

UClass* UH7GateGuardPopupCntl::pClassPointer = NULL;

UClass* UH7ArtifactRecyclerPopupCntl::pClassPointer = NULL;

UClass* UH7InscriberPopupCntl::pClassPointer = NULL;

UClass* UH7ContainerCntl::pClassPointer = NULL;

UClass* UH7AltarOfSacrificeCntl::pClassPointer = NULL;

UClass* UH7MerchantPopUpCntl::pClassPointer = NULL;

UClass* UH7RunicForgePopUpCntl::pClassPointer = NULL;

UClass* UH7RandomSkillingPopUpCntl::pClassPointer = NULL;

UClass* UH7TrainingGroundsPopUpCntl::pClassPointer = NULL;

UClass* UH7GFxCommandPanel::pClassPointer = NULL;

UClass* UH7GFxSimTurnInfo::pClassPointer = NULL;

UClass* UH7GFxTopBar::pClassPointer = NULL;

UClass* UH7GFxActorTooltip::pClassPointer = NULL;

UClass* UH7GFxTownList::pClassPointer = NULL;

UClass* UH7GFxPlayerBuffs::pClassPointer = NULL;

UClass* UH7GFxSideBar::pClassPointer = NULL;

UClass* AH7PathDot::pClassPointer = NULL;

UClass* UH7AiCombatSensors::pClassPointer = NULL;

UClass* UH7AiActionActivateRune::pClassPointer = NULL;

UClass* UH7AiUtilityBase::pClassPointer = NULL;

UClass* UH7AiUtilitySensor::pClassPointer = NULL;

UClass* UH7AiUtilityActivateDefensiveRune::pClassPointer = NULL;

UClass* UH7AiUtilityActivateOffensiveRune::pClassPointer = NULL;

UClass* UH7AiActionAttackCreatureStack::pClassPointer = NULL;

UClass* UH7AiUtilityHasAnyAdjacentEnemy::pClassPointer = NULL;

UClass* UH7AiUtilityHasAdjacentEnemy::pClassPointer = NULL;

UClass* UH7AiUtilityRangeCasualityCount::pClassPointer = NULL;

UClass* UH7AiUtilityRangeCreatureDamage::pClassPointer = NULL;

UClass* UH7AiUtilityInflictedGoldLoss::pClassPointer = NULL;

UClass* UH7AiActionAttackHero::pClassPointer = NULL;

UClass* UH7AiUtilityKillScale::pClassPointer = NULL;

UClass* UH7AiActionAttackTargetAoC::pClassPointer = NULL;

UClass* UH7AiUtilityCombiner::pClassPointer = NULL;

UClass* UH7AiUtilityAttackTargetScore::pClassPointer = NULL;

UClass* UH7AiUtilitySiteAvailable::pClassPointer = NULL;

UClass* UH7AiActionAttackTargetArmy::pClassPointer = NULL;

UClass* UH7AiActionAttackTargetBorderArmy::pClassPointer = NULL;

UClass* UH7AiActionAttackTargetCity::pClassPointer = NULL;

UClass* UH7AiUtilitySuicideAttackTargetScore::pClassPointer = NULL;

UClass* UH7AiActionAttackTargetEnemy::pClassPointer = NULL;

UClass* UH7AiActionCastSpellHero::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityTsunami::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityCircleOfWinter::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFireBall::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilitySoulConflagration::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityCyclone::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityBlizzard::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityStoneSpikes::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityCelestialArmour::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityRetribution::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityInnerFire::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityArmageddon::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityBurningDetermination::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityPoisonCloud::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityEarthquake::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityRegeneration::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityStoneSkin::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFortune::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityWeakness::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityDespair::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityStormArrows::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilitySunBurst::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFireWall::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityTimeControl::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityDispelMagic::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilitySummonElemental::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFireSentry::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFreezingOrb::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityAgony::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityHauntingPlague::pClassPointer = NULL;

UClass* UH7AiUtilitySpellTargetCheck::pClassPointer = NULL;

UClass* UH7AiUtilitySpellSingleDamage::pClassPointer = NULL;

UClass* UH7AiUtilitySpellMultiDamage::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityLightningBurst::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityHeal::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityLightningBolt::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityChainLightning::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFireBolt::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFrostBolt::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilitySunBeam::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityIceStrike::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityLiquidMembrane::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityResurrection::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFogShroud::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFrenzy::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityPoisonSpray::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityEntangle::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityTimeStasis::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityImplosion::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityShadowCloak::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityLightningReflexes::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityCleansingLight::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityTeleport::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityGustOfWind::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityAdvance::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityHoldPositions::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityEngage::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityOpenFire::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityAttention::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityPurge::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityFaceOfFear::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityShadowImage::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityWaspSwarm::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityMartyr::pClassPointer = NULL;

UClass* UH7AiUtilityHeAbilityErraticStorm::pClassPointer = NULL;

UClass* UH7AiActionChillAroundTown::pClassPointer = NULL;

UClass* UH7InstantCommandTeleportToTown::pClassPointer = NULL;

UClass* UH7AiUtilityChillScore::pClassPointer = NULL;

UClass* UH7AiUtilityCongregate::pClassPointer = NULL;

UClass* UH7AiActionDefend::pClassPointer = NULL;

UClass* UH7AiActionDestroyTarget::pClassPointer = NULL;

UClass* UH7AiActionDestroyTargetMine::pClassPointer = NULL;

UClass* UH7AiActionDevelopTownBuilding::pClassPointer = NULL;

UClass* UH7AiActionExplore::pClassPointer = NULL;

UClass* UH7AiUtilityExplore::pClassPointer = NULL;

UClass* UH7AiUtilityTeleportInterest::pClassPointer = NULL;

UClass* UH7AiActionFlee::pClassPointer = NULL;

UClass* UH7AiUtilityFleeScore::pClassPointer = NULL;

UClass* UH7AiActionFleeSurrenderCombat::pClassPointer = NULL;

UClass* UH7InstantCommandFleeOrSurrender::pClassPointer = NULL;

UClass* UH7AiUtilityFleeSurrenderCheck::pClassPointer = NULL;

UClass* UH7AiActionGarrisonTown::pClassPointer = NULL;

UClass* UH7AiUtilityGarrisonScore::pClassPointer = NULL;

UClass* UH7AiActionGather::pClassPointer = NULL;

UClass* UH7AiActionHireHero::pClassPointer = NULL;

UClass* UH7AiUtilityTownArmyCount::pClassPointer = NULL;

UClass* UH7AiActionMoveAttackCreatureStack::pClassPointer = NULL;

UClass* UH7AiUtilityCanMoveAttack::pClassPointer = NULL;

UClass* UH7AiActionMoveCreatureStack::pClassPointer = NULL;

UClass* UH7AiUtilityStackReachesTileIn1Turn::pClassPointer = NULL;

UClass* UH7AiUtilityThreatLevel::pClassPointer = NULL;

UClass* UH7AiUtilityOpportunity::pClassPointer = NULL;

UClass* UH7AiUtilityEnemyDistance::pClassPointer = NULL;

UClass* UH7AiUtilityStackMoveDistance::pClassPointer = NULL;

UClass* UH7AiActionMoveRune::pClassPointer = NULL;

UClass* UH7AiUtilityRunePlacement::pClassPointer = NULL;

UClass* UH7AiActionPickup::pClassPointer = NULL;

UClass* UH7AiActionPlunder::pClassPointer = NULL;

UClass* UH7AiActionRangeAttackCreatureStack::pClassPointer = NULL;

UClass* UH7AiActionRecruitment::pClassPointer = NULL;

UClass* UH7AiUtilityRecruitmentScore::pClassPointer = NULL;

UClass* UH7AiActionReinforce::pClassPointer = NULL;

UClass* UH7AiUtilityReinforceScore::pClassPointer = NULL;

UClass* UH7AiActionRepairTarget::pClassPointer = NULL;

UClass* UH7AiActionReplenish::pClassPointer = NULL;

UClass* UH7AiUtilityReplenishScore::pClassPointer = NULL;

UClass* UH7AiActionRetrieveTearOfAsha::pClassPointer = NULL;

UClass* UH7AiActionTrade::pClassPointer = NULL;

UClass* UH7AiUtilityTrade::pClassPointer = NULL;

UClass* UH7TownMarketplace::pClassPointer = NULL;

UClass* UH7AiActionUpgradeCreatures::pClassPointer = NULL;

UClass* UH7AiUtilityUpgradeCreatureScore::pClassPointer = NULL;

UClass* UH7AiActionUseAbilityCreature::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityAcidBreath::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilitySolderingHands::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityMagicAbsorption::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityResurrection::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityPiercingShot::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityFeralCharge::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityBackstab::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityCharge::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityEntanglingRoots::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityFatalStrike::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityFieryEye::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityInspiringPresence::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityLeafDaggers::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityLifeDrain::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityLivingShelter::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityMightyPounce::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityNova::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityPoisonedBlades::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilitySixHeaded::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilitySplash::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilitySoulFlayingBreath::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilitySoulReaver::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityStrikeAndReturn::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityStrikeAndReturnMelee::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilitySweepingBash::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityThorns::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityWitheringBreath::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityWitheringVenom::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityDivingAttack::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityFireNova::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityWhirlingDeath::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityArmourPiercing::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityBreathOfLight::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityRuneTeleport::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityThrowingHammer::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityRage::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityMagmaPond::pClassPointer = NULL;

UClass* UH7AiActionUseAbilityHero::pClassPointer = NULL;

UClass* UH7AiUtilityCanCastSpellHero::pClassPointer = NULL;

UClass* UH7AiUtilityCanRangeAttack::pClassPointer = NULL;

UClass* UH7AiActionUseSite::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Boost::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Commission::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Exercise::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Keymaster::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Obelisk::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Observe::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Shop::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Study::pClassPointer = NULL;

UClass* UH7AiActionUseSite_Teleporter::pClassPointer = NULL;

UClass* UH7AiActionWaitCreature::pClassPointer = NULL;

UClass* UH7AiUtilityGoodTimeToWait::pClassPointer = NULL;

UClass* UH7AiActionWaitHero::pClassPointer = NULL;

UClass* UH7AiUtilityHasGreaterDamage::pClassPointer = NULL;

UClass* UH7InstantCommandIncreaseSkill::pClassPointer = NULL;

UClass* UH7InstantCommandLearnAbility::pClassPointer = NULL;

UClass* UH7AiSensorParam::pClassPointer = NULL;

UClass* UH7AiSensorArmyStrength::pClassPointer = NULL;

UClass* UH7AiSensorArmyStrengthCombined::pClassPointer = NULL;

UClass* UH7AiSensorDistanceToTarget::pClassPointer = NULL;

UClass* UH7AiSensorTargetInterest::pClassPointer = NULL;

UClass* UH7AiSensorArmyStrengthCombinedNoHero::pClassPointer = NULL;

UClass* UH7AiSensorHeroCount::pClassPointer = NULL;

UClass* UH7AiSensorGameProgress::pClassPointer = NULL;

UClass* UH7AiSensorTownDistance::pClassPointer = NULL;

UClass* UH7AiSensorPlayerArmiesCompare::pClassPointer = NULL;

UClass* UH7AiSensorPoolGarrison::pClassPointer = NULL;

UClass* UH7AiSensorTownBuilding::pClassPointer = NULL;

UClass* UH7AiSensorGameDayOfWeek::pClassPointer = NULL;

UClass* UH7AiSensorTradeResource::pClassPointer = NULL;

UClass* UH7AiSensorResourceStockpile::pClassPointer = NULL;

UClass* UH7AiSensorTownDefense::pClassPointer = NULL;

UClass* UH7AiSensorTownArmyCount::pClassPointer = NULL;

UClass* UH7AiSensorHireHeroCount::pClassPointer = NULL;

UClass* UH7AiSensorSiteAvailable::pClassPointer = NULL;

UClass* UH7AiSensorRecall::pClassPointer = NULL;

UClass* UH7AiSensorTeleportInterest::pClassPointer = NULL;

UClass* UH7AiSensorCanUpgrade::pClassPointer = NULL;

UClass* UH7AiSensorArmyStrengthCombinedReverse::pClassPointer = NULL;

UClass* UH7AiSensorUpgradeStrength::pClassPointer = NULL;

UClass* UH7AiSensorTownThreat::pClassPointer = NULL;

UClass* UH7AiSensorTargetCutoffRange::pClassPointer = NULL;

UClass* UH7AiSensorArmyStrengthCombinedGlobal::pClassPointer = NULL;

UClass* UH7AiSensorArmyStrengthCombinedGlobalReverse::pClassPointer = NULL;

UClass* AH7AiCombatMap::pClassPointer = NULL;

UClass* UH7AiSensorSpellMultiDamage::pClassPointer = NULL;

UClass* UH7AiSensorSpellTargetCheck::pClassPointer = NULL;

UClass* UH7AiSensorGoodTimeToWait::pClassPointer = NULL;

UClass* UH7AiCombatMapConfig::pClassPointer = NULL;

UClass* UH7AiSensorArmyHasRangeAttack::pClassPointer = NULL;

UClass* UH7AiSensorGridCellReachable::pClassPointer = NULL;

UClass* UH7AiSensorGeomDistance::pClassPointer = NULL;

UClass* UH7AiSensorCanRangeAttack::pClassPointer = NULL;

UClass* UH7AiSensorCanRetaliate::pClassPointer = NULL;

UClass* UH7AiSensorThreatLevel::pClassPointer = NULL;

UClass* UH7AiSensorHasAdjacentEnemy::pClassPointer = NULL;

UClass* UH7AiSensorHasAdjacentAlly::pClassPointer = NULL;

UClass* UH7AiSensorHPPercentLossAttack::pClassPointer = NULL;

UClass* UH7AiSensorHPPercentLossRetaliation::pClassPointer = NULL;

UClass* UH7AiSensorCanMoveAttack::pClassPointer = NULL;

UClass* UH7AiSensorHasGreaterDamage::pClassPointer = NULL;

UClass* UH7AiSensorCanCastBuff::pClassPointer = NULL;

UClass* UH7AiSensorMeleeCasualityCount::pClassPointer = NULL;

UClass* UH7AiSensorMeleeCreatureDamage::pClassPointer = NULL;

UClass* UH7AiSensorRangeCasualityCount::pClassPointer = NULL;

UClass* UH7AiSensorRangeCreatureDamage::pClassPointer = NULL;

UClass* UH7AiSensorManaCost::pClassPointer = NULL;

UClass* UH7AiSensorHealingPercentage::pClassPointer = NULL;

UClass* UH7AiSensorAbilityCasualityCount::pClassPointer = NULL;

UClass* UH7AiSensorAbilityCreatureDamage::pClassPointer = NULL;

UClass* UH7AiSensorOpportunity::pClassPointer = NULL;

UClass* UH7AiSensorSpellSingleDamage::pClassPointer = NULL;

UClass* UH7AiSensorSpellSingleHeal::pClassPointer = NULL;

UClass* UH7AiSensorSpellMultiHeal::pClassPointer = NULL;

UClass* UH7AiSensorCreatureCount::pClassPointer = NULL;

UClass* UH7AiSensorCreatureStrength::pClassPointer = NULL;

UClass* UH7AiSensorStackMoveDistance::pClassPointer = NULL;

UClass* UH7AiSensorCreatureStat::pClassPointer = NULL;

UClass* UH7AiSensorCreatureIsRanged::pClassPointer = NULL;

UClass* UH7AiSensorCreatureAdjacentToEnemy::pClassPointer = NULL;

UClass* UH7AiSensorCreatureAdjacentToAlly::pClassPointer = NULL;

UClass* UH7AiSensorCreatureTier::pClassPointer = NULL;

UClass* UH7AiSensorCreatureCanAttack::pClassPointer = NULL;

UClass* UH7AiSensorCreatureCanBeAttacked::pClassPointer = NULL;

UClass* UH7AiSensorRangedCreatureCount::pClassPointer = NULL;

UClass* UH7AiSensorRunePlacement::pClassPointer = NULL;

UClass* UH7AiSensorDefensiveRuneOpportunity::pClassPointer = NULL;

UClass* UH7AiSensorOffensiveRuneOpportunity::pClassPointer = NULL;

UClass* UH7AiSensorTargetCoverage::pClassPointer = NULL;

UClass* UH7AiSensorGoodTimeToFleeSurrender::pClassPointer = NULL;

UClass* UH7AiSensorWarcryBenefit::pClassPointer = NULL;

UClass* UH7AiSensorInflictedGoldLoss::pClassPointer = NULL;

UClass* AH7RunicForge::pClassPointer = NULL;

UClass* UH7AiSensorStackDamage::pClassPointer = NULL;

UClass* UH7AiUtilityAdvTargetThreat::pClassPointer = NULL;

UClass* UH7AiUtilityGeneralEffort::pClassPointer = NULL;

UClass* UH7AiUtilityTargetInterest::pClassPointer = NULL;

UClass* UH7AiUtilityCanUpgrade::pClassPointer = NULL;

UClass* UH7AiUtilityMovementEffortCell::pClassPointer = NULL;

UClass* UH7AiUtilityRecall::pClassPointer = NULL;

UClass* UH7AiUtilityMovementEffort::pClassPointer = NULL;

UClass* UH7AiUtilityReinforcementGain::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityCasualityCount::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityCreatureDamage::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityFireTrail::pClassPointer = NULL;

UClass* UH7AiUtilityHasAnyAdjacentAlly::pClassPointer = NULL;

UClass* UH7AiUtilityCrAbilityTargetCheck::pClassPointer = NULL;

UClass* UH7AiUtilityHealingPercentage::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureAdjacentToAlly::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureAdjacentToEnemy::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureCanAttack::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureCanBeAttacked::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureCount::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureIsRanged::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureStat::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureStrength::pClassPointer = NULL;

UClass* UH7AiUtilityCreatureTier::pClassPointer = NULL;

UClass* UH7AiUtilityDamagePotentialReduction::pClassPointer = NULL;

UClass* UH7AiUtilityMeleeCreatureDamage::pClassPointer = NULL;

UClass* UH7AiUtilityMeleeCasualityCount::pClassPointer = NULL;

UClass* UH7AiUtilityMeleeCreatureDamageRet::pClassPointer = NULL;

UClass* UH7AiUtilityMeleeCasualityCountRet::pClassPointer = NULL;

UClass* UH7AiUtilityFightingEffort::pClassPointer = NULL;

UClass* UH7AiUtilityMovementReach::pClassPointer = NULL;

UClass* UH7AiUtilityMovementEffortRe::pClassPointer = NULL;

UClass* UH7AiUtilityMovementEffortAllied::pClassPointer = NULL;

UClass* UH7AiUtilityTownThreat::pClassPointer = NULL;

UClass* UH7AiUtilityTargetCutoffRange::pClassPointer = NULL;

UClass* UH7AiUtilityGameDayOfWeek::pClassPointer = NULL;

UClass* UH7AiUtilityGameProgress::pClassPointer = NULL;

UClass* UH7AiUtilityTownDefense::pClassPointer = NULL;

UClass* UH7AiUtilityWarcryBenefit::pClassPointer = NULL;

UClass* UH7AiUtilitySpellAreaDamage::pClassPointer = NULL;

UClass* UH7AiUtilitySpellSingleHeal::pClassPointer = NULL;

UClass* UH7AiUtilityHeroCount::pClassPointer = NULL;

UClass* UH7AiUtilityHireHeroCount::pClassPointer = NULL;

UClass* UH7AiUtilityKillScaleRetaliation::pClassPointer = NULL;

UClass* UH7AiUtilityManaCost::pClassPointer = NULL;

UClass* UH7AiUtilityPlayerArmiesCompare::pClassPointer = NULL;

UClass* UH7AiUtilityPoolGarrison::pClassPointer = NULL;

UClass* UH7AiUtilityRangedCreatureCount::pClassPointer = NULL;

UClass* UH7AiUtilityTownDistanceCombined::pClassPointer = NULL;

UClass* UH7AiUtilityReinforcementGainReverse::pClassPointer = NULL;

UClass* UH7AiUtilityUpgradeGain::pClassPointer = NULL;

UClass* UH7AiUtilityResourceStockpile::pClassPointer = NULL;

UClass* UH7AiUtilitySpellAreaHeal::pClassPointer = NULL;

UClass* UH7AiUtilitySpellMultiHeal::pClassPointer = NULL;

UClass* UH7AiUtilitySuicideGeneralEffort::pClassPointer = NULL;

UClass* UH7AiUtilitySuicideFightingEffort::pClassPointer = NULL;

UClass* UH7AiUtilityTargetCoverage::pClassPointer = NULL;

UClass* UH7AiUtilityTargetScore::pClassPointer = NULL;

UClass* UH7AiUtilityTownBuilding::pClassPointer = NULL;

UClass* UH7AiUtilityTownDistance::pClassPointer = NULL;

UClass* UH7AiUtilityTownDistanceMax::pClassPointer = NULL;

UClass* UH7AiUtilityTradeResource::pClassPointer = NULL;

UClass* AH7AKAmbientNode::pClassPointer = NULL;

UClass* AH7AkEventActorDummy::pClassPointer = NULL;

UClass* UH7PopupKeybindings::pClassPointer = NULL;

UClass* UH7IQueueable::pClassPointer = NULL;

UClass* UH7InstantCommandSacrifice::pClassPointer = NULL;

UClass* UH7TownUnitConverter::pClassPointer = NULL;

UClass* UH7GFxTownPopup::pClassPointer = NULL;

UClass* UH7GFxAltarOfSacrifice::pClassPointer = NULL;

UClass* UH7INeutralable::pClassPointer = NULL;

UClass* UH7TownGuardBuilding::pClassPointer = NULL;

UClass* UH7InstantCommandUnloadCaravans::pClassPointer = NULL;

UClass* UH7InstantCommandUnloadCaravan::pClassPointer = NULL;

UClass* UH7InstantCommandUpgradeUnit::pClassPointer = NULL;

UClass* UH7InstantCommandRecruit::pClassPointer = NULL;

UClass* UH7InstantCommandMergeArmiesLord::pClassPointer = NULL;

UClass* UH7InstantCommandTransferHero::pClassPointer = NULL;

UClass* UH7InstantCommandCreateEmptyGarrison::pClassPointer = NULL;

UClass* UH7ArtifactRecycler::pClassPointer = NULL;

UClass* UH7ArtifactRecyclingTable::pClassPointer = NULL;

UClass* UH7InstantCommandRecycleArtifact::pClassPointer = NULL;

UClass* UH7GFxArtifactRecyclerPopup::pClassPointer = NULL;

UClass* UH7GFxBackgroundImage::pClassPointer = NULL;

UClass* AH7USSProjectile::pClassPointer = NULL;

UClass* UH7SeqEvent_HeroAbilityCasted::pClassPointer = NULL;

UClass* UH7CampaignTransitionManager::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerStartsCaravan::pClassPointer = NULL;

UClass* UH7InstantCommandStartCaravan::pClassPointer = NULL;

UClass* UH7InstantCommandDestroyCaravanOutpost::pClassPointer = NULL;

UClass* UH7InstantCommandCheatSetNextWeek::pClassPointer = NULL;

UClass* UH7InstantCommandCheatTeleport::pClassPointer = NULL;

UClass* UH7InstantCommandCheatStatChange::pClassPointer = NULL;

UClass* UH7InstantCommandCheatWinLose::pClassPointer = NULL;

UClass* UH7GFxCheatWindow::pClassPointer = NULL;

UClass* AH7CinematicGameInfo::pClassPointer = NULL;

UClass* UH7SeqEvent_CombatTurn::pClassPointer = NULL;

UClass* AH7CreatureAnimControl::pClassPointer = NULL;

UClass* UH7SeqEvent_CombatDeploymentPhaseStart::pClassPointer = NULL;

UClass* UH7CombatMapCursor::pClassPointer = NULL;

UClass* AH7CoverManager::pClassPointer = NULL;

UClass* UH7GFxUnitInfo::pClassPointer = NULL;

UClass* UH7InstantCommandSetAutoCombat::pClassPointer = NULL;

UClass* UH7GFxInitiativeList::pClassPointer = NULL;

UClass* UH7GFxCombatMenu::pClassPointer = NULL;

UClass* UH7GFxCreatureAbilityButtonPanel::pClassPointer = NULL;

UClass* UH7GFxTacticsBanner::pClassPointer = NULL;

UClass* UH7GFxArmyRow::pClassPointer = NULL;

UClass* UH7GFxDeploymentBar::pClassPointer = NULL;

UClass* UH7GFxDeploymentOffGridMenu::pClassPointer = NULL;

UClass* AH7FracturedDynMeshActor::pClassPointer = NULL;

UClass* UH7CombatMapFCT::pClassPointer = NULL;

UClass* UH7CombatMapGridDebug::pClassPointer = NULL;

UClass* AH7CombatMapPathPreviewer::pClassPointer = NULL;

UClass* UH7TownMoat::pClassPointer = NULL;

UClass* UH7TownTower::pClassPointer = NULL;

UClass* AH7CombatMapInfo::pClassPointer = NULL;

UClass* UH7GFxStatusBarSystem::pClassPointer = NULL;

UClass* AH7CombatPlayerReplicationInfo::pClassPointer = NULL;

UClass* UH7InstantCommandResetReinforcement::pClassPointer = NULL;

UClass* UH7InstantCommandConfirmReinforcement::pClassPointer = NULL;

UClass* UH7InstantCommandAcceptMerge::pClassPointer = NULL;

UClass* UH7InstantCommandTranferStackFromMergePool::pClassPointer = NULL;

UClass* UH7GFxCombatPopUp::pClassPointer = NULL;

UClass* UH7GFxArmyMergePopup::pClassPointer = NULL;

UClass* UH7GFxObstacleInfo::pClassPointer = NULL;

UClass* AH7WarUnitAnimControl::pClassPointer = NULL;

UClass* UH7GFxLoaderManager::pClassPointer = NULL;

UClass* AH7MainMenuController::pClassPointer = NULL;

UClass* AH7CouncilCamera::pClassPointer = NULL;

UClass* AH7MainMenuInfo::pClassPointer = NULL;

UClass* AH7CouncilGameInfo::pClassPointer = NULL;

UClass* AH7CouncilHeropediaActor::pClassPointer = NULL;

UClass* AH7CouncilLampActor::pClassPointer = NULL;

UClass* AH7CouncilMapCameraAction::pClassPointer = NULL;

UClass* AH7CouncilScrollActor::pClassPointer = NULL;

UClass* UH7GFxCouncilorWindow::pClassPointer = NULL;

UClass* UH7ReplayWindowCntl::pClassPointer = NULL;

UClass* UH7GfxMainMenu::pClassPointer = NULL;

UClass* AH7CouncilStatueActor::pClassPointer = NULL;

UClass* UH7CreatureFX::pClassPointer = NULL;

UClass* AH7CreatureStackFX::pClassPointer = NULL;

UClass* UH7FCTElement::pClassPointer = NULL;

UClass* AH7CreatureStackFlyer::pClassPointer = NULL;

UClass* AH7CreatureStackMover::pClassPointer = NULL;

UClass* AH7CreatureStackGhostWalker::pClassPointer = NULL;

UClass* AH7CreatureStackJumper::pClassPointer = NULL;

UClass* AH7CreatureStackTeleporter::pClassPointer = NULL;

UClass* UH7GFxStackPlateSystem::pClassPointer = NULL;

UClass* UH7InstantCommandRecruitDirect::pClassPointer = NULL;

UClass* UH7InstantCommandUpgradeDwelling::pClassPointer = NULL;

UClass* UH7InstantCommandStartDestructionOrReparation::pClassPointer = NULL;

UClass* UH7GFxDialog::pClassPointer = NULL;

UClass* UH7GFxCouncilDialog::pClassPointer = NULL;

UClass* UH7GFxNarrationDialog::pClassPointer = NULL;

UClass* UH7GFxMapControls::pClassPointer = NULL;

UClass* AH7DragonUtopia::pClassPointer = NULL;

UClass* UH7GFxDuelSetupWindow::pClassPointer = NULL;

UClass* UH7GFxHeroSelection::pClassPointer = NULL;

UClass* UH7Log::pClassPointer = NULL;

UClass* UH7WarfareVisuals::pClassPointer = NULL;

UClass* UH7TownIdolOfFertility::pClassPointer = NULL;

UClass* AH7Entry::pClassPointer = NULL;

UClass* AH7EvokeFX::pClassPointer = NULL;

UClass* AH7FCTMappingProperties::pClassPointer = NULL;

UClass* UH7GFxFloatingSystem::pClassPointer = NULL;

UClass* UH7ForceCookingAssets::pClassPointer = NULL;

UClass* UH7InstantCommandRebuildFort::pClassPointer = NULL;

UClass* USaveGameStateInterface::pClassPointer = NULL;

UClass* AH7FracturedWalkableObjectSpawnable::pClassPointer = NULL;

UClass* UH7GenericTownNames::pClassPointer = NULL;

UClass* UH7GeneralLoreEntry::pClassPointer = NULL;

UClass* UH7LoadingHints::pClassPointer = NULL;

UClass* UH7GFxTownGuardPopup::pClassPointer = NULL;

UClass* UH7GFxCampaignCompleteTooltip::pClassPointer = NULL;

UClass* UH7GFxCouncilorTooltip::pClassPointer = NULL;

UClass* UH7GFxDataObject::pClassPointer = NULL;

UClass* UH7GFxSkirmishSetupWindow::pClassPointer = NULL;

UClass* UH7GFxFCTField::pClassPointer = NULL;

UClass* UH7GFxFrontEnd_MapSelect::pClassPointer = NULL;

UClass* UH7UIDataProvider_Mapinfo::pClassPointer = NULL;

UClass* UH7GFxHallOfHerosPopup::pClassPointer = NULL;

UClass* UH7GFxHeroEquip::pClassPointer = NULL;

UClass* UH7GFxHeroInfo::pClassPointer = NULL;

UClass* UH7GFxHeropedia::pClassPointer = NULL;

UClass* UH7GFxHeropediaTooltip::pClassPointer = NULL;

UClass* UH7GFxHeroTradeWindow::pClassPointer = NULL;

UClass* UH7GFxHeroWindow::pClassPointer = NULL;

UClass* UH7GFxInscriberPopup::pClassPointer = NULL;

UClass* UH7GFxInventory::pClassPointer = NULL;

UClass* UH7GFxJoinGameMenu::pClassPointer = NULL;

UClass* UH7GFxLoadingScreen::pClassPointer = NULL;

UClass* UH7GFxLoadSaveWindow::pClassPointer = NULL;

UClass* UH7GFxLockTooltip::pClassPointer = NULL;

UClass* UH7GFxLogChat::pClassPointer = NULL;

UClass* UH7GFxLogQA::pClassPointer = NULL;

UClass* UH7GFxMagicGuildPopup::pClassPointer = NULL;

UClass* UH7TownArcaneLibrary::pClassPointer = NULL;

UClass* UH7GfxMapList::pClassPointer = NULL;

UClass* UH7GFxMapResultPopUp::pClassPointer = NULL;

UClass* UH7GFxMarketPlacePopup::pClassPointer = NULL;

UClass* UH7TradingTable::pClassPointer = NULL;

UClass* AH7TradingPost::pClassPointer = NULL;

UClass* UH7GFxMerchantPopUp::pClassPointer = NULL;

UClass* UH7GFxMiddleHUD::pClassPointer = NULL;

UClass* UH7ThievesGuildManager::pClassPointer = NULL;

UClass* UH7GFxMultiplayerLobby::pClassPointer = NULL;

UClass* UH7GFxObject::pClassPointer = NULL;

UClass* UH7GfxOnlineLobby::pClassPointer = NULL;

UClass* UH7GFxPauseMenu::pClassPointer = NULL;

UClass* UH7GFxQuestComplete::pClassPointer = NULL;

UClass* UH7GFxQuestLog::pClassPointer = NULL;

UClass* UH7GFxQuickBar::pClassPointer = NULL;

UClass* UH7GFxRandomMapWindow::pClassPointer = NULL;

UClass* UH7GfxRandomSkillingPopUp::pClassPointer = NULL;

UClass* UH7GFxReplayWindow::pClassPointer = NULL;

UClass* UH7GFxRequestPopup::pClassPointer = NULL;

UClass* UH7GFxResultWindow::pClassPointer = NULL;

UClass* UH7GFxRMGMinimapIconLayer::pClassPointer = NULL;

UClass* UH7GFxRunicForgePopUp::pClassPointer = NULL;

UClass* UH7SideBar::pClassPointer = NULL;

UClass* UH7GFxSkillwheel::pClassPointer = NULL;

UClass* UH7GFxSpecatorHUD::pClassPointer = NULL;

UClass* UH7GFxSpellbook::pClassPointer = NULL;

UClass* UH7GFxThievesGuildPopup::pClassPointer = NULL;

UClass* UH7TownSpiesGuild::pClassPointer = NULL;

UClass* UH7TownHallOfIntrigue::pClassPointer = NULL;

UClass* UH7GFxTownBuildingPopup::pClassPointer = NULL;

UClass* UH7GFxTownCaravanPopup::pClassPointer = NULL;

UClass* UH7GFxTownContainer::pClassPointer = NULL;

UClass* UH7GFxTownFurnace::pClassPointer = NULL;

UClass* UH7TownFurnace::pClassPointer = NULL;

UClass* UH7GFxTownInfo::pClassPointer = NULL;

UClass* UH7GFxTownRecruitmentPopup::pClassPointer = NULL;

UClass* UH7GFxTownWarfarePopup::pClassPointer = NULL;

UClass* UH7GFxTradeResult::pClassPointer = NULL;

UClass* UH7GFxTrainingGroundsPopUp::pClassPointer = NULL;

UClass* UH7GFxTurnOver::pClassPointer = NULL;

UClass* UH7GFxUplayNote::pClassPointer = NULL;

UClass* UH7GFxWarfareUnitRow::pClassPointer = NULL;

UClass* UH7GFxWindowWeeklyEffect::pClassPointer = NULL;

UClass* UH7GUIConnector::pClassPointer = NULL;

UClass* UH7SeqEvent_PlayerRecruitHero::pClassPointer = NULL;

UClass* UH7InstantCommandInventoryAction::pClassPointer = NULL;

UClass* UH7InstantCommandTransferWarUnit::pClassPointer = NULL;

UClass* UH7InstantCommandMergeArmiesAdventure::pClassPointer = NULL;

UClass* UH7InstantCommandDismissHero::pClassPointer = NULL;

UClass* UH7IInteractable::pClassPointer = NULL;

UClass* UH7InstantCommandBuyScroll::pClassPointer = NULL;

UClass* UH7InstantCommandBeginTurn::pClassPointer = NULL;

UClass* UH7InstantCommandBuildBuilding::pClassPointer = NULL;

UClass* UH7InstantCommandBuildShip::pClassPointer = NULL;

UClass* UH7InstantCommandBuyArtifactBlackMarket::pClassPointer = NULL;

UClass* UH7InstantCommandBuyArtifactMerchant::pClassPointer = NULL;

UClass* UH7InstantCommandCreateNewCaravan::pClassPointer = NULL;

UClass* UH7InstantCommandDestroyTownBuildings::pClassPointer = NULL;

UClass* UH7InstantCommandEnterLeaveShelter::pClassPointer = NULL;

UClass* UH7InstantCommandFinishOngoingStartCombat::pClassPointer = NULL;

UClass* UH7InstantCommandGenerateNewRandomSkillBatch::pClassPointer = NULL;

UClass* UH7InstantCommandIncreaseHeroStat::pClassPointer = NULL;

UClass* UH7InstantCommandInvokeRandomSkillPopup::pClassPointer = NULL;

UClass* UH7InstantCommandTransferResource::pClassPointer = NULL;

UClass* UH7InstantCommandRecruitHero::pClassPointer = NULL;

UClass* UH7InstantCommandSetGovernor::pClassPointer = NULL;

UClass* UH7InstantCommandOverwriteSkill::pClassPointer = NULL;

UClass* UH7InstantCommandRecruitWarfare::pClassPointer = NULL;

UClass* UH7InstantCommandSelectSpecialisation::pClassPointer = NULL;

UClass* UH7InstantCommandSabotage::pClassPointer = NULL;

UClass* UH7InstantCommandThievesGuildPlunder::pClassPointer = NULL;

UClass* UH7InstantCommandSellArtifact::pClassPointer = NULL;

UClass* UH7InstantCommandUseFertilityIdol::pClassPointer = NULL;

UClass* UH7InstantCommandRandomItemSIte::pClassPointer = NULL;

UClass* UH7IProgressable::pClassPointer = NULL;

UClass* UH7ItemController::pClassPointer = NULL;

UClass* UH7LANSearch::pClassPointer = NULL;

UClass* AH7MainMenuConfiguration::pClassPointer = NULL;

UClass* UH7MeshBeaconClient::pClassPointer = NULL;

UClass* UH7MeshBeaconHost::pClassPointer = NULL;

UClass* UH7ObjectListenable::pClassPointer = NULL;

UClass* AH7PickableGold::pClassPointer = NULL;

UClass* AH7PickableResource::pClassPointer = NULL;

UClass* UH7TownBank::pClassPointer = NULL;

UClass* UH7PopupManager::pClassPointer = NULL;

UClass* UH7SeqEvent_GameEndPopupClosed::pClassPointer = NULL;

UClass* AH7ResourcePileSpawnable::pClassPointer = NULL;

UClass* UH7SeqAct_AddHeroToHallOfHeroes::pClassPointer = NULL;

UClass* UH7SeqAct_CameraProperty::pClassPointer = NULL;

UClass* UH7SeqAct_CastHeroAbility::pClassPointer = NULL;

UClass* UH7SeqAct_CloseAllPopups::pClassPointer = NULL;

UClass* UH7SeqAct_DisableTacticsPhase::pClassPointer = NULL;

UClass* UH7SeqAct_DoEndGameAction::pClassPointer = NULL;

UClass* UH7SeqAct_FadeToBlack::pClassPointer = NULL;

UClass* UH7SeqAct_GetCamera::pClassPointer = NULL;

UClass* UH7SeqAct_GetSelectedArmy::pClassPointer = NULL;

UClass* UH7SeqAct_IntroHeroCameraAction::pClassPointer = NULL;

UClass* UH7SeqAct_LoadBackground::pClassPointer = NULL;

UClass* UH7SeqAct_LockCamera::pClassPointer = NULL;

UClass* UH7SeqAct_PresentArmyCameraAction::pClassPointer = NULL;

UClass* UH7SeqAct_SetAIPlayerStatus::pClassPointer = NULL;

UClass* UH7SeqAct_SetArmyFXVisibility::pClassPointer = NULL;

UClass* UH7SeqAct_SetPlayerInputEnabled::pClassPointer = NULL;

UClass* UH7SeqAct_SetPlayerTeamNumber::pClassPointer = NULL;

UClass* UH7SeqAct_SkipEndGameAction::pClassPointer = NULL;

UClass* UH7SeqAct_SupressAutoSave::pClassPointer = NULL;

UClass* UH7SeqAct_ToggleFlythroughMode::pClassPointer = NULL;

UClass* UH7SeqAct_UnlockCamera::pClassPointer = NULL;

UClass* UH7SeqCon_FinishedCampaigns::pClassPointer = NULL;

UClass* UH7SeqCon_Objective::pClassPointer = NULL;

UClass* UH7SeqCon_PrivilegeState::pClassPointer = NULL;

UClass* UH7SimTurnBaseCommand::pClassPointer = NULL;

UClass* UH7SimTurnCommandManager::pClassPointer = NULL;

UClass* UH7SimTurnInstantCommand::pClassPointer = NULL;

UClass* UH7SimTurnNormalCommand::pClassPointer = NULL;

UClass* UH7StartScreenController::pClassPointer = NULL;

UClass* UH7TownCommerceBuilding::pClassPointer = NULL;

UClass* UH7TownEmbassy::pClassPointer = NULL;

UClass* AH7TownScreenLight::pClassPointer = NULL;

UClass* UH7TownSiloBuilding::pClassPointer = NULL;

UClass* AH7TransitionActor::pClassPointer = NULL;

UClass* UH7UIDataStore_MenuItems::pClassPointer = NULL;

UClass* AH7WarUnitFX::pClassPointer = NULL;

UClass* USaveGameState_SeqEvent_SavedGameStateLoaded::pClassPointer = NULL;

UClass* USaveGameTransition::pClassPointer = NULL;

