//=============================================================================
// H7CombatHero
//=============================================================================
// Hero used in the combat map
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatHero extends H7EditorHero
	implements(H7IGUIListenable)
	native;

var protected bool mHasDataChanged;

function Init( optional bool fromSave )
{
	super.Init( fromSave );

	if( IsHero() )
	{
		SetTimer( 2.f, false, NameOf( CreateGUIOverlay) );
	}

	if( mHeroSkeletalMesh == none )
	{
		mHeroSkeletalMesh = new class'SkeletalMeshComponent'();
		mHeroSkeletalMesh.SetLightEnvironment( LightEnvironment );
		mHeroSkeletalMesh.SetActorCollision( false, false, false );
		mHeroSkeletalMesh.SetTraceBlocking( false, false );
		AttachComponent( mHeroSkeletalMesh );
	}

	if( mHorseSkeletalMesh == none )
	{
		mHorseSkeletalMesh = new class'SkeletalMeshComponent'();
		mHorseSkeletalMesh.SetLightEnvironment( LightEnvironment );
		mHorseSkeletalMesh.SetActorCollision( false, false, false );
		mHorseSkeletalMesh.SetTraceBlocking( false, false );
		AttachComponent( mHorseSkeletalMesh );
	}

	SetCollisionType( COLLIDE_NoCollision );

	AssignMaterials();
}

function AssignMaterials()
{
	local Color playerColor;
	local LinearColor playerLinearColor;
	local MaterialInstanceConstant MatInst;
	local int i;

	if( ( mHeroSkeletalMesh.SkeletalMesh == None && mHorseSkeletalMesh.SkeletalMesh == None ) || class'H7CombatController'.static.GetInstance() == none )
	{
		SetTimer(0.5f, false, 'AssignMaterials');
		return;
	}

	// load and set the materials into memory so we can control them at runtime
	if (mHeroSkeletalMesh != None && mHeroSkeletalMesh.SkeletalMesh != None)
	{
		for (i = 0; i < mHeroSkeletalMesh.SkeletalMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mHeroSkeletalMesh.GetMaterial(i));
			mHeroSkeletalMesh.SetMaterial(i, MatInst);
			HeroMaterials.AddItem(MatInst);
		}
	}
	if (mHorseSkeletalMesh != None && mHorseSkeletalMesh.SkeletalMesh != None)
	{
		for (i = 0; i < mHorseSkeletalMesh.SkeletalMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mHorseSkeletalMesh.GetMaterial(i));
			mHorseSkeletalMesh.SetMaterial(i, MatInst);
			HeroMaterials.AddItem(MatInst);
		}
	}
	if (mWeaponMesh != None && mWeaponMesh.StaticMesh != None)
	{
		for (i = 0; i < mWeaponMesh.Materials.Length; i++)
		{
			MatInst = new(self) Class'MaterialInstanceConstant';
			MatInst.SetParent(mWeaponMesh.GetMaterial(i));
			mWeaponMesh.SetMaterial(i, MatInst);
			HeroMaterials.AddItem(MatInst);
		}
	}

	// apply player color to the hero if needed
	if (class'H7GUIGeneralProperties'.static.GetInstance().IsUsingModelColoring())
	{
		playerColor = GetPlayer().GetColor();
		playerLinearColor.R = float(playerColor.R) / 255;
		playerLinearColor.G = float(playerColor.G) / 255;
		playerLinearColor.B = float(playerColor.B) / 255;
		foreach HeroMaterials(MatInst)
		{
			MatInst.SetScalarParameterValue('bUseFactionColor', 1.0f);
			MatInst.SetVectorParameterValue('FactionColor', playerLinearColor);
		}
	}

	InitFX();
}

function CreateGUIOverlay()
{
	// Not needed, the mana is in the portrait of the heroes
	//if( class'H7CombatMapStatusBarController'.static.GetInstance() != none && mIsHero)
	//{
	//	class'H7CombatMapStatusBarController'.static.GetInstance().CreateManaBar( self, (float(mCurrentMana) / GetMaxMana()) * 100);
	//}
}

// implementation
function Think()
{
	local H7CombatArmy armyOpponent;
	local array<H7CreatureStack> csOpponent;
	local H7CreatureStack creatureStack;

	// might attack random 'not dead' enemy stack
	
	// get opponent army
	armyOpponent = class'H7CombatController'.static.GetInstance().GetOpponentArmy( GetCombatArmy() );
	armyOpponent.GetSurvivingCreatureStacks( csOpponent );
	foreach csOpponent( creatureStack )
	{
		class'H7CombatController'.static.GetInstance().GetActiveUnit().GetPreparedAbility().Activate( creatureStack, true );
		return;
	}
}

// 
function RegenMana()
{
	super.RegenMana();
}

function float AddMana(int amount)
{
	return super.AddMana(amount);
}

// UsaMana in EditorHero

function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory) 
{

}

function GUIAddListener(GFxObject data,optional H7ListenFocus focus)
{
	class'H7ListeningManager'.static.GetInstance().AddListener(self,data);
}

function DataChanged(optional String cause)
{
	mHasDataChanged = true;
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

function bool HasDataChanged() // for status bars
{
	return mHasDataChanged;
}

function ResetHasDataChanged()
{
	mHasDataChanged = false;
}

protected function DebugLogSelf()
{
	;
}
