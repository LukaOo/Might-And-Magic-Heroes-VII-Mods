//=============================================================================
// H7PathDot
//
// Visual representation of adventure map path icons
//
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7PathDot extends DecalActorSpawnable
		placeable;

const MAT_PARAMNAME = 'DecalRotation';

const DEFAULT_HEIGHT = 32;
const DEFAULT_WIDTH = 32;
const DEFAULT_FARPLANE = 600;

var protected MaterialInterface mMaterial;
var protected H7LandscapeFilteredDecalComponent mFilteredDecal;

var bool mLookAtView;

event Tick( float DeltaTime )
{
	Super.Tick(DeltaTime);

	if (mLookAtView == true && mMaterial != None && MaterialInstanceConstant(mMaterial) != None)
	{
		MaterialInstanceConstant(mMaterial).SetScalarParameterValue(MAT_PARAMNAME, float(class'H7Camera'.static.GetInstance().Rotation.Yaw) / 65536);
	}
}

function SetMaterial( MaterialInterface newMaterial ) 
{
	mMaterial = newMaterial; 
	Decal.SetDecalMaterial( mMaterial );
}

function SetDimensions( optional int newWidth = DEFAULT_WIDTH, optional int newHeight = DEFAULT_HEIGHT, optional int farPlane = DEFAULT_FARPLANE )
{
	Decal.Width = newWidth;
	Decal.Height = newHeight;
	Decal.FarPlane = farPlane;
}

function SetProjectOnAll()
{
	GetDecal().mIsLandscapeFilteringActive = false;
}

function SetIsWater( bool isWater )
{
	if( isWater )
	{
		GetDecal().mLandscapeToProjectOn = LT_Water;
	}
	else
	{
		GetDecal().mLandscapeToProjectOn = LT_Ground;
	}
	GetDecal().mIsLandscapeFilteringActive = true;
}

function MaterialInterface GetMaterial()                { return mMaterial; }
function H7LandscapeFilteredDecalComponent GetDecal()   
{ 
	if( mFilteredDecal == none )
	{
		mFilteredDecal = H7LandscapeFilteredDecalComponent( Decal );
	}

	if( mFilteredDecal != none ) 
	{
		return mFilteredDecal;
	}
	else
	{
		return H7LandscapeFilteredDecalComponent( Decal ); 
	}
}

