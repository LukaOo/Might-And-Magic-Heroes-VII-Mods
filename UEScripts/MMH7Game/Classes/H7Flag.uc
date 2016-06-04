//=============================================================================
// H7Flag
//=============================================================================
//
// Attachable flag to represent player ownership and coat of arms 
// (color & symbol) in adventure map
// 

//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7Flag extends Actor
	native;

const GROW_SIZE = 2.5f;
const GROW_SIZE_PERM = 1.7f;
const SPEED_MOD_PERM = 0.3f;

var protected H7AdventureController mAdventureController;

var protected ParticleSystemComponent mFlagEmitter;
var protected ParticleSystem mFlagParticleSystem;
var protected MaterialInstanceConstant mFlagMat;
var() protected CylinderComponent mCollider;
var protected float mColliderRadius, mColliderHeight;

var protected float mScale;
var protected float mCurrentScale;
var protected float mDefaultScale;
var protected float mTimer;
var protected EZoomDirection mZoomDir;
var protected float mRatio;
var protected Vector mOriginalRelativeLocation;
var protected float mCurrentZoom;
var protected bool mIsMainFlag;
var protected H7Player mLocalPlayer, mOwningPlayer;
var protected H7AdventureArmy mOwningArmy;
var protected H7VisitableSite mOwningSite;
var protected H7PlayerController mPlayerController;

var protected bool mPlayAnim;

var protected bool mForceHide;

var protected H7Camera      mCamera;

var protected H7BaseBuff    mBuff;

function ForceFlagHide( bool hidden ) { mForceHide = hidden; }

function H7BaseBuff GetBuff()
{
	return mBuff;
}

function SetOwningPlayer( H7Player newPlayer )
{
	mOwningPlayer = newPlayer;
	SetFaction( newPlayer.GetFaction() );
}

function SetMainFlag( bool isMainFlag )
{
	mIsMainFlag = isMainFlag;
}

function bool GetMainFlag()
{
	return mIsMainFlag;
}

function InitLocation( Vector newLocation )
{
	mOriginalRelativeLocation = newLocation;
	SetRelativeLocation( newLocation );
}

function InitAsNPCFlag()
{
	//mFlagMat = new(None) Class'MaterialInstanceConstant';
	//mFlagMat.SetParent(MaterialInterface'H7FactionRegalia.Materials.H7FullFlagMaterial_Quest');

	if( class'H7AdventureController'.static.GetInstance().GetConfig().mNPCSymbol != none )
	{
		mFlagMat.SetTextureParameterValue( 'FlagBannerTextureSampleParameter', class'H7AdventureController'.static.GetInstance().GetConfig().mNPCSymbol );
	}
	mFlagMat.SetTextureParameterValue( 'FlagCrestTextureSampleParameter', none );
	mFlagMat.SetTextureParameterValue( 'FlagBannerStripesTextureSampleParameter', none );
	mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', none );
	mIsMainFlag = true;
}

function InitAsQuestTargetFlag()
{
	mFlagMat = new(None) Class'MaterialInstanceConstant';
	mFlagMat.SetParent(MaterialInterface'H7FactionRegalia.Materials.H7FullFlagMaterial_Quest');

	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuestObjectSymbol != none )
	{
		mFlagMat.SetTextureParameterValue( 'FlagBannerTextureSampleParameter', class'H7AdventureController'.static.GetInstance().GetConfig().mQuestObjectSymbol );
	}
	mFlagMat.SetTextureParameterValue( 'FlagCrestTextureSampleParameter', none );
	mFlagMat.SetTextureParameterValue( 'FlagBannerStripesTextureSampleParameter', none );
	mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', none );
	mFlagEmitter.SetMaterialParameter( 'Color', mFlagMat );
	mIsMainFlag = true;
}

function InitAsBuffIcon( H7BaseBuff buff )
{
	mFlagMat = new(None) Class'MaterialInstanceConstant';
	mFlagMat.SetParent(MaterialInterface'H7FactionRegalia.Materials.H7FullFlagMaterial');

	mBuff = buff;
	if( mBuff.GetIcon() != none )
	{
		mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', mBuff.GetIcon() );
	}
	mFlagMat.SetTextureParameterValue( 'FlagCrestTextureSampleParameter', class'H7AdventureController'.static.GetInstance().GetConfig().mFlagCrestTexture );
	mFlagEmitter.SetMaterialParameter( 'Color', mFlagMat );
}

function SetSymbol( Texture2D icon )
{
	mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', icon );
	mFlagEmitter.SetMaterialParameter( 'Color', mFlagMat );
}

function SetFaction( H7Faction faction )
{
	local H7AdventureConfiguration conf;

	conf = class'H7AdventureController'.static.GetInstance().GetConfig();
	if( faction != none )
	{
		mFlagMat = new(None) Class'MaterialInstanceConstant';
		mFlagMat.SetParent(MaterialInterface'H7FactionRegalia.Materials.H7FullFlagMaterial');

		if( GetBuff() != none && GetBuff().GetIcon() != none )
		{
			mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', GetBuff().GetIcon() );
		}
		else
		{
			if( mOwningArmy != none )
			{
				if( mOwningArmy != none && mOwningPlayer != none && mOwningPlayer.GetPlayerNumber() == PN_NEUTRAL_PLAYER )
				{
					mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', none );
				}
				else
				{
					mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', faction.GetFactionSepiaIcon() );
				}
			}
			else if( H7Town( mOwningSite ) != none )
			{
				mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', conf.mTownFlagIconTexture );
			}
			else if( H7Fort( mOwningSite ) != none )
			{
				mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', conf.mFortFlagIconTexture );
			}
			else if( H7Mine( mOwningSite ) != none )
			{
				mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', conf.mMineFlagIconTexture );
			}
			else if( H7Dwelling( mOwningSite ) != none )
			{
				mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', conf.mDwellingFlagIconTexture );
			}
			else if( H7Garrison( mOwningSite ) != none )
			{
				mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', conf.mGarrisonFlagIconTexture );
			}
			else 
			{
				mFlagMat.SetTextureParameterValue( 'FlagSymbolTextureSampleParameter', none );
			}
		}
		mFlagMat.SetTextureParameterValue( 'FlagBannerTextureSampleParameter', faction.GetFactionBanner() );
		mFlagMat.SetTextureParameterValue( 'FlagBannerStripesTextureSampleParameter', faction.GetFactionBannerStripes() );
		mFlagMat.SetTextureParameterValue( 'FlagCrestTextureSampleParameter', class'H7AdventureController'.static.GetInstance().GetConfig().mFlagCrestTexture );
		SetColor( mOwningPlayer.GetColor() );
		mFlagEmitter.SetMaterialParameter( 'Color', mFlagMat );

	} 
	else 
	{
		if( class'H7AdventureController'.static.GetInstance().GetNeutralPlayer().GetFaction() != none )
		{
			SetFaction( class'H7AdventureController'.static.GetInstance().GetNeutralPlayer().GetFaction() );
		}
		else
		{
			;
		}
	}
}

function SetColor(Color playerColor)
{
	local float colorCoefficient;
	local LinearColor LC;
	colorCoefficient = 255.0f;
	LC.R = playerColor.R / colorCoefficient;
	LC.G = playerColor.G / colorCoefficient;
	LC.B = playerColor.B / colorCoefficient;
	LC.A = playerColor.A / colorCoefficient;
	mFlagMat.SetVectorParameterValue('playerColor', LC);
	mFlagEmitter.SetMaterialParameter('Color', mFlagMat);
}

function SetScale( float scale )
{
	mScale = scale;
}

// attach emitter to flag actor, if successfully spawned
function PostBeginPlay()
{
	super.PostBeginPlay();
	mFlagEmitter = WorldInfo.MyEmitterPool.SpawnEmitter( ParticleSystem'H7FactionRegalia.ParticleSystems.H7FlagBaseParticle', Location, Rotation, self ); // WHYYYYYY emiter pool TODO
	mFlagEmitter.SetDepthPriorityGroup(SDPG_Foreground);

	mAdventureController = class'H7AdventureController'.static.GetInstance();
	mPlayerController = class'H7PlayerController'.static.GetPlayerController();
	
	mOwningArmy = H7AdventureArmy( Owner );
	mOwningSite = H7VisitableSite( Owner );
	if( H7Flag( Owner ) != none )
	{
		mOwningPlayer = H7VisitableSite( H7Flag( Owner ).Owner ).GetPlayer();
	}
	else
	{
		mOwningPlayer = mOwningArmy != none ? mOwningArmy.GetPlayer() : H7VisitableSite( Owner ).GetPlayer();
	}
	
	
	if( mFlagEmitter != none)
	{
		AttachComponent(mFlagEmitter);

		mFlagMat = new(None) Class'MaterialInstanceConstant';
		mFlagMat.SetParent(MaterialInterface'H7FactionRegalia.Materials.H7FullFlagMaterial');
	}
	else
	{
		;
	}

	mCamera = class'H7Camera'.static.GetInstance();
	mRatio = mCamera.GetActiveProperties().ViewDistanceMinimum / mCamera.GetActiveProperties().ViewDistanceMaximum;
	mOriginalRelativeLocation = RelativeLocation;
	
	mZoomDir = ZD_NONE;
}


native function protected AdaptFlagSizeAndHeight();

event protected PlayAnim( float DeltaTime, float growSize )
{
	if( mZoomDir == ZD_NONE ) return;

	mTimer += DeltaTime/10 * ( mPlayAnim ? SPEED_MOD_PERM : 1.0f ); 

	if( mZoomDir == ZD_ZOOM_IN )
	{
		mCurrentScale = ( FInterpEaseOut( mFlagEmitter.Scale, mDefaultScale * growSize, mTimer, 1.5f ) );
	}
	else if( mZoomDir == ZD_ZOOM_OUT )
	{
		mCurrentScale = ( FInterpEaseOut( mFlagEmitter.Scale, mDefaultScale, mTimer, 1.5f ) );
	}

	if( mFlagEmitter.Scale >= ( (mDefaultScale * growSize) - ( mDefaultScale * growSize / 10 ) ) ) 
	{ 
		mZoomDir = ZD_ZOOM_OUT; 
		mTimer = 0.0f; 
	}
	
	if( ( Abs( mFlagEmitter.Scale - mDefaultScale ) < 0.1f ) && mZoomDir == ZD_ZOOM_OUT ) 
	{ 
		mFlagEmitter.SetScale( mDefaultScale );

		if( mPlayAnim )
		{
			mZoomDir = ZD_ZOOM_IN;
		}
		else
		{
			mZoomDir = ZD_NONE;
		}
		mTimer = 0.0f; 
	}
}

function StopAnim()
{
	mCurrentScale = mDefaultScale;
	mZoomDir = ZD_NONE;
	mPlayAnim = false;
}

function ShowAnim( optional bool permanent = false ) 
{ 
	if( !mPlayAnim )
	{
		mPlayAnim = permanent;
		mZoomDir = ZD_ZOOM_IN;  
		mTimer = 0.0f;
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

