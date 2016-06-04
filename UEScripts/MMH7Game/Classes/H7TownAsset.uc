//=============================================================================
// H7TownAsset
//=============================================================================
// Base class for townscreen planes
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TownAsset extends DynamicSMActor_Spawnable
	implements(H7ITooltipable)
	placeable
	native;

struct native H7TownAssetMaterial
{
	var() MaterialInterface materialHovered<DisplayName=MaterialHovered>;
	var() MaterialInterface materialUnhovered<DisplayName=MaterialUnhovered>;
};

var( TownAsset ) protected string   mType<DisplayName=Type>;
var( TownAsset ) protected array<H7TownAssetMaterial> mMaterials<DisplayName=Town Materials>;
var( TownAsset ) protected ParticleSystemComponent mFX<DisplayName=FX>;

var protected MaterialInstanceConstant MatHovered;
var protected MaterialInstanceConstant MatUnhovered;

var(Sounds) protected AkEvent mOnHoverSound<DisplayName=On hover sound>;
var(Sounds) protected AkEvent mOnClickSound<DisplayName=On click sound>;
var protected bool mSoundPause;

var protected int mBuildingLevel;               
var protected bool mZoomedIn;
var protected bool mIsHovered;
var protected MaterialInstanceConstant mMatInst;
var protected PhysicalMaterial mPassMaterial;
var protected PhysicalMaterial mBlockMaterial;
var protected ParticleSystemComponent mParticleSystem;

var protected bool mZoomEnabled;
var protected H7PlayerController mPlayerController;

/** Current Fade in for this asset */
var protected float mCurrFade;
/** Speed of fading (multiplied with DeltaTime) */
var protected float mFadeAmt;
var protected array<MaterialInstanceConstant> mParticleFadingMats;
var protected array<MaterialInstanceConstant> mSavedParticleMats;

function array<H7TownAssetMaterial> GetMaterials() { return mMaterials; }
function SetMaterials( array<H7TownAssetMaterial> materials ) { mMaterials = materials; }

function int  GetBuildingLevel() { return mBuildingLevel; }
function bool IsHovered()        { return mIsHovered;   }
function bool IsZoomEnabled()       { return mZoomEnabled;   }
function string GetType()        { return mType;        } // needed for, matching with itself! (TODO refactor)

function SetHovered()
{	
	if( mMaterials.Length != 0 )
	{
		mIsHovered = true;
		RemovePhysics( MatHovered );
		StaticMeshComponent.SetMaterial( 0, MatHovered );
		AddPhysics( MatHovered );
	}

	if(!mSoundPause)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor(self, mOnHoverSound,true,true, self.Location );
		mSoundPause = true;
		SetTimer(1);
	}
}

function Timer()
{
	mSoundPause = false;
}

function SetUnhovered()
{
	if( mMaterials.Length != 0 )
	{
		mIsHovered = false;
		RemovePhysics( MatUnhovered );
		StaticMeshComponent.SetMaterial( 0, MatUnhovered );
		AddPhysics( MatUnhovered );
	}
}

function RemovePhysics( MaterialInstanceConstant mat )
{
	mat.BlackPhysicalMaterial = none;
	mat.WhitePhysicalMaterial = none;
	mat.PhysMaterial = none;
}

function AddPhysics( MaterialInstanceConstant mat )
{
	mat.BlackPhysicalMaterial = mPassMaterial;
	mat.WhitePhysicalMaterial = mBlockMaterial;
	mat.PhysMaterial = mBlockMaterial;
}

function SetBuildingLevel( int lvl )
{
	mBuildingLevel = FClamp( lvl, 0, mMaterials.Length-1 );
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local H7TownBuilding building;
	
	building = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetTown().GetBuildingByAssetType(self.GetType());

	data.addRightMouseIcon = true;
	data.type = TT_TYPE_STRING;
	data.Title = building.GetName();
	
	if(extendedVersion)
	{
		data.Description = "<font size='#TT_SUBTITLE#'>" $ building.GetDesc() $ "</font>";
	}

	SetHoverEffect(true);

	return data;
}

native function PhysicalMaterial GetPhysicalPassMaterial();

function bool IsZoomedIn()
{
	return mZoomedIn;
}

function SetZoomedIn(bool val)
{
	mZoomedIn = val;
}

function Click()
{
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().AssetClicked(self);
	class'H7SoundManager'.static.PlayAkEventOnActor(self, mOnClickSound,true,true, self.Location );
}

function DoZoom()
{
	if( mPlayerController == none ) mPlayerController = class'H7PlayerController'.static.GetPlayerController();

	if( !mZoomedIn )
	{
		;
		mPlayerController.GetAdventureHud().GetTownHudCntl().ZoomInStart(self);
		if( mPlayerController.GetAdventureHud().GetTownHudCntl().GetZoomedInAsset() != none && class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetZoomedInAsset() != self )
		{
			mPlayerController.GetAdventureHud().GetTownHudCntl().GetZoomedInAsset().SetZoomedIn(false);
		}
		mZoomedIn = true;
		
		if( mZoomEnabled )
		{
			//class'H7CameraActionController'.static.GetInstance().StartZoomInAction( Location, -1, -1, 2, ZoomInComplete );
		}
		else
		{
			ZoomInComplete();
		}
	}
	else
	{
		;
		mPlayerController.GetAdventureHud().GetTownHudCntl().ZoomOutStart(self);
		mZoomedIn = false;

		if( mZoomEnabled )
		{
			//class'H7CameraActionController'.static.GetInstance().StartZoomOutAction( true, -1, -1, 2, ZoomOutComplete );
		}
		else
		{
			ZoomOutComplete();
		}
	}
	
}

function ZoomInComplete()
{
	//`log_dui("Asset.ZoomInComplete");
	ClearTimer('ZoomInComplete');
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().ZoomInComplete(self);
}

function ZoomOutComplete()
{
	//`log_dui("Asset.ZoomOutComplete");
	ClearTimer('ZoomOutComplete');
	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().ZoomOutComplete(self);
}

function init()
{
	if( mMaterials.Length != 0 )
	{
		MatHovered = new(self) class'MaterialInstanceConstant';
		MatHovered.SetParent( mMaterials[mBuildingLevel].materialHovered );
		MatHovered.BlackPhysicalMaterial = mPassMaterial;
		MatHovered.WhitePhysicalMaterial = mBlockMaterial;
		MatHovered.PhysMaterial = mBlockMaterial;

		MatUnhovered = new(self) class'MaterialInstanceConstant';
		MatUnhovered.SetParent(mMaterials[mBuildingLevel].materialUnhovered);
		MatUnhovered.BlackPhysicalMaterial = mPassMaterial;
		MatUnhovered.WhitePhysicalMaterial = mBlockMaterial;
		MatUnhovered.PhysMaterial = mBlockMaterial;
	
		StaticMeshComponent.LightEnvironment.SetEnabled(false);

		SetHovered();
		SetUnhovered(); 
	}

}

function SetHoverEffect(bool hover)
{
	/* no time to implement, other bugs came in
	if(hover) 
	{
		StartFadeIn();
		mCurrFade = -1.0f;

		MatHovered.SetScalarParameterValue('OpacityGlobal', opacityFade);
		MatUnhovered.SetScalarParameterValue('OpacityGlobal', opacityFade);

		MatHovered.SetScalarParameterValue('ColorFadeGlobal', 1 - mCurrFade);
		MatUnhovered.SetScalarParameterValue('ColorFadeGlobal', 1 - mCurrFade);

		foreach mParticleFadingMats(theFXMat)
		{
			theFXMat.SetScalarParameterValue('Opacity_Amt', opacityFade);
			theFXMat.SetScalarParameterValue('ColorFadeGlobal', 1 - mCurrFade);
		}
	}
	else
	{
		mCurrFade = 999999.0f;
	}
	*/
}

function StartFadeIn()
{
	local ParticleEmitter theFXEmitter;
	local MaterialInstanceConstant theFXMat, theNewMat;
	local float theParam;
	local ParticleLODLevel theLOD;
	local bool needsReplace;

	mCurrFade = 0.0f;

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ADD_BUILDING");

	// initialize a copy of all particles that need highlighting
	if (mFX != None && mFX.Template != None)
	{
		foreach mFX.Template.Emitters(theFXEmitter)
		{
			theFXMat = MaterialInstanceConstant(theFXEmitter.LODLevels[0].RequiredModule.Material);
			if (theFXMat != None && theFXMat.GetScalarParameterValue('OpacityGlobal', theParam))
			{
				needsReplace = true;
				break;
			}
		}
		if (needsReplace)
		{
			foreach mFX.Template.Emitters(theFXEmitter)
			{
				theFXMat = MaterialInstanceConstant(theFXEmitter.LODLevels[0].RequiredModule.Material);
				if (theFXMat != None && theFXMat.GetScalarParameterValue('OpacityGlobal', theParam))
				{
					mSavedParticleMats.AddItem(theFXMat);
					theNewMat = new(self) class'MaterialInstanceConstant';
					theNewMat.SetParent(theFXMat);
					foreach theFXEmitter.LODLevels(theLOD)
					{
						theLOD.RequiredModule.Material = theNewMat;
					}
					mParticleFadingMats.AddItem(theNewMat);
				}
			}
		}
	}
}

event Tick(float DeltaTime)
{
	local float opacityFade;
	local MaterialInstanceConstant theFXMat;

	Super.Tick(DeltaTime);

	if (mCurrFade > -1.0f)
	{
		mCurrFade += mFadeAmt * DeltaTime;
		mCurrFade = FMin(1.0f, mCurrFade);

		opacityFade = FMin(1.0f, mCurrFade * 3.0f);
		MatHovered.SetScalarParameterValue('OpacityGlobal', opacityFade);
		MatUnhovered.SetScalarParameterValue('OpacityGlobal', opacityFade);

		MatHovered.SetScalarParameterValue('ColorFadeGlobal', 1 - mCurrFade);
		MatUnhovered.SetScalarParameterValue('ColorFadeGlobal', 1 - mCurrFade);

		foreach mParticleFadingMats(theFXMat)
		{
			theFXMat.SetScalarParameterValue('Opacity_Amt', opacityFade);
			theFXMat.SetScalarParameterValue('ColorFadeGlobal', 1 - mCurrFade);
		}

		if (mCurrFade >= 1.0f)
		{
			mCurrFade = -1.0f;
		}
	}
}

event Destroyed()
{
	local int i, j;
	local MaterialInstanceConstant theFXMat;
	local ParticleLODLevel theLOD;
	local float theParam;

	// clean up all particles
	mParticleFadingMats.Length = 0;
	if (mFX != None && mFX.Template != None)
	{
		for (i = 0; i < mFX.Template.Emitters.Length; i++)
		{
			theFXMat = MaterialInstanceConstant(mFX.Template.Emitters[i].LODLevels[0].RequiredModule.Material);
			if (theFXMat != None && theFXMat.GetScalarParameterValue('OpacityGlobal', theParam))
			{
				foreach mFX.Template.Emitters[i].LODLevels(theLOD)
				{
					if (j < mSavedParticleMats.Length)
					{
						theLOD.RequiredModule.Material = mSavedParticleMats[j];
					}
					j++;
				}
			}
		}
	}
	mSavedParticleMats.Length = 0;

	Super.Destroyed();
}

