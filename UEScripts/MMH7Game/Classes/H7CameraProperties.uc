//=============================================================================
// H7CameraProperties
//
// Camera properties used by the camera. Stored here to allow easy manipulation
// from within Unreal Editor.
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CameraProperties extends Object
	native
	HideCategories(Object);

// Distance of camera from Look-At-Position 
var(Camera) const float ViewingDistance;
// Distance of camera from Look-At-Position for 4 x 3 aspect Ratio
var(Camera) const float ViewingDistance4x3;
// Field of View of camera at the default ViewingDistance
var(Camera) const float FieldOfView;
// Constant camera rotation
var(Camera) const Rotator Rotation;// Speed at which the camera moves from current to target position (the higher the value the faster)
var(Camera) const float PanBlendSpeed;
// Speed at which the camera alignes with target rotation (the higher the value the faster)
var(Camera) const float RotationBlendSpeed;
// Speed at which the camera closes in or out of target (the higher the value the faster)
var(Camera) const float DollyBlendSpeed;
// Speed the camera moves on input
var(Camera) const float PanVelocity;
// Initial pan offset
var(Camera) const float PanXOffset;
var(Camera) const float PanYOffset;
var(Camera) const float PanZOffset;
var(Camera) const float PanYOffsetCloseZoom;

// Speed the camera rotates on input
var(Camera) const float RotationVelocity;
// Speed the camera moves towards/from target
var(Camera) const float DollyVelocity;
// Speed the camera moves towards/from target using the mouse wheel
var(Camera) const float DollyMouseScrollVelocity;
// Limits the camera rotation within the range Rotation.Yaw ? RotationLimit [degrees]
var(Camera) const float RotationLimit;
// limits the camera movement to the gridsize + GridBorderVerticalSize in the vertical axis
var(Camera) const float GridBorderVerticalSizeMin;
var(Camera) const float GridBorderVerticalSizeMax;
// limits the camera movement to the gridsize + GridBorderHorizontalSize in the horizontal axis
var(Camera) const float GridBorderHorizontalSizeMin;
var(Camera) const float GridBorderHorizontalSizeMax;
// limit the dolly to the minimum distance
var(Camera) const float ViewDistanceMinimum;
// limit the dolly to the maximum distance
var(Camera) const float ViewDistanceMaximum;
// limit the amount of extra Distance which can be applied, if the max threshold is reached
var(Camera) const float ViewDistanceMaximumCache;
// limit the FOV to the minimum distance
var(Camera) const float FOVMinimum;
// limit the FOV to the maximum distance
var(Camera) const float FOVMaximum;
// target pitch value at maximum viewing distance
var(Camera) const float HighPitch;
// target pitch value at minimum viewing distance
var(Camera) const float LowPitch;
// percentage value the camera should start to adapt the pitch value getting close to target
var(Camera) const float PitchBlendStart;
// rate at which the camera shakes when shake function is called, in seconds
var(Camera) const float ShakeRate;

// the grid size which fits on the screen with the default ViewingDistance
var(Combat) const Vector2D BaseGridSize;
// the increase of the viewingDistance per Cell for bigger/smaller grids
var(Combat) const Vector2D ViewingDistanceIncreasePerCell;
var(Combat) const Vector2D PanYOffsetPerCell;
var(Combat) const Vector2D BorderGridSizePerCell;
 
// Default properties block
