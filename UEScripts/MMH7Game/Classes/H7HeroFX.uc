//=============================================================================
// H7HeroFX
//=============================================================================
//
// Class to create an aura effect around the currently active hero.
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroFX extends H7UnitFX
	native;

var protected DecalActorSpawnable   mDecalFXActor;
var protected bool                  mIsDecalHidden;

function bool IsDecalHidden() { return mIsDecalHidden; }

event InitFX(H7Unit unit) 
{
	super.InitFX(unit);
	CreateFX();	
}

function CreateFX()
{
	local MaterialInstanceConstant DecalMaterialInstanceConstant;
	local Landscape filterLandscape;
	local LinearColor linCol;
	local array<Landscape> landscapes;

	;

	// this FX is only for the combat heros
	if (mProperties.SelectionFXTemplateHero != None && mUnit.IsA('H7CombatHero') && mSelectionFX == none )
	{
		mSelectionFX = WorldInfo.MyEmitterPool.SpawnEmitter(mProperties.SelectionFXTemplateHero, mUnit.Location, , mUnit , );
		mSelectionFX.SetHidden( true );
		class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( mSelectionFX );
	}


	UpdateTargetColor( mProperties.ActiveTargetColor );

	if (mProperties.SelectionFXTemplateHeroDecal != None && mDecalFXActor == None && mUnit != none && mUnit.Location != Vect(0,0,0) && !mIsDecalHidden && !mUnit.IsA('H7CombatHero') )
	{
		mDecalFXActor = Spawn(class'DecalActorSpawnable', self,, mUnit.Location + Vect(0,0,200), Rot(49152, 0, 0));
		if (mDecalFXActor != None)
		{
			DecalMaterialInstanceConstant = new class'MaterialInstanceConstant';
			if (DecalMaterialInstanceConstant != none)
			{
				DecalMaterialInstanceConstant.SetParent(mProperties.SelectionFXTemplateHeroDecal);
				if( mUnit.GetPlayer() != none && mUnit.GetPlayer().GetFaction() != none )
				{
					linCol = MakeLinearColor( mUnit.GetPlayer().GetColor().R / 255.f, mUnit.GetPlayer().GetColor().G / 255.f, mUnit.GetPlayer().GetColor().B / 255.f, mUnit.GetPlayer().GetColor().A / 255.f );
					DecalMaterialInstanceConstant.SetVectorParameterValue( 'AuraColor', linCol );
					DecalMaterialInstanceConstant.SetTextureParameterValue( 'DecalTexture2', H7EditorHero( mUnit ).GetFactionAuraInnerDecalTexture() );
					DecalMaterialInstanceConstant.SetTextureParameterValue( 'DecalTexture1', H7EditorHero( mUnit ).GetFactionAuraOuterDecalTexture() );
				}
				mDecalFXActor.Decal.SetDecalMaterial(DecalMaterialInstanceConstant);
				mDecalFXActor.Decal.Width = 800.0f;
				mDecalFXActor.Decal.Height = 800.0f;
				mDecalFXActor.Decal.FarPlane = 300.0f;
				mDecalFXActor.Decal.BackfaceAngle = 0.75f;

				mDecalFXActor.Decal.FilterMode = FM_Ignore;
				// find water landscapes to filter them out of the decal
				if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
				{
					landscapes = class'H7AdventureController'.static.GetInstance().GetLandscapes();
					foreach landscapes( filterLandscape )
					{
						if( filterLandscape.LandscapeType == LT_Water )
						{
							mDecalFXActor.Decal.Filter.AddItem( filterLandscape );
						}
					}
				}
			}
			mDecalFXActor.SetHardAttach(true);
			mDecalFXActor.bIgnoreBaseRotation = true;
			if (H7AdventureHero(mUnit) != None)
			{
				mDecalFXActor.SetBase(H7AdventureHero(mUnit).GetAdventureArmy());
			}
			else
			{
				mDecalFXActor.SetBase(mUnit);
			}
		}
	}
}

function ShowFX()
{
	super.ShowFX();

	mIsActive = true;
	ShowDecalFX();
}

function HideFX()
{
	super.HideFX();

	mIsActive = false;
	HideDecalFX();
}

function HideDecalFX()
{
	mIsDecalHidden = true;
	if( mDecalFXActor != none )
	{
		mDecalFXActor.Destroy();
		mDecalFXActor = none;
	}
}

function ShowDecalFX()
{
	mIsDecalHidden = false;
	if( mDecalFXActor != none )
	{
		mDecalFXActor.SetHidden( false );
	}
	else
	{
		CreateFX();
	}
}

simulated event Destroyed()
{
	if( mDecalFXActor != none )
	{
		mDecalFXActor.Destroy();
	}
	super.Destroyed();
}

function UpdateFXPosition()
{
	local bool oldState;
	oldState = mIsActive; 


	if(oldState) 
	{
		;
		ShowFX();
	}
	else
	{
		HideFX();
		;
	}
}

function UpdateTargetColor( Color targetColor )
{
	if( mSelectionFX != none )
	{
		mSelectionFX.SetColorParameter( 'Target', targetColor );
	}
}


