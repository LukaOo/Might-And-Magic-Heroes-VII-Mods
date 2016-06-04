//=============================================================================
// H7FracturedMeshActor
//=============================================================================
// Child of H7FracturedMeshActor which handles fractured mesh. This class adds
// the possibility to changes tiles when the fracture event is triggered.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GameplayFracturedMeshActor extends H7FracturedMeshActor
	dependson(H7StructsAndEnumsNative)
	native
	placeable
	savegame;

var(GameplayFractured) editoronly PrimitiveComponent ChangingTerrainArea;

var(Destruction) protected array<H7DestructibleObjectManipulator> mManipulators<DisplayName="Manipulators">;
var(Destruction) protected savegame bool mIsFractured<DisplayName="Is destroyed">;

var(Visuals, Repair) ParticleSystem mRepairEffect<DisplayName="Repair Particle Effect">;
var(Visuals, Repair) protected float mSinkTime;
var(Visuals, Repair) protected float mRepairSpeed;

var(Audio) protected AKEvent mDestroySoundEvent <DisplayName=Destroy AkEvent>;
var(Audio) protected AKEvent mRepairSoundEvent <DisplayName=Repair AkEvent>;
//Prevent playing sounds while the init of the actor
var protected bool mInInit;

var array<H7AdventureMapCell> OnBreak_CellsToChange;
// this array is always mapped 1:1 to OnBreak_CellsToChange!
var array<ECellMovementType> OnBreak_CellsToChangeInitialModifiers;
var ECellMovementType OnBreak_NewMovementModifier; //assigned on save
var protected savegame bool mIsDestroying, mIsSinking, mIsRepairing, mIsFXRepairing;
var protected savegame float mRepairPercent;
var array<MaterialInstanceConstant> mRebuildMats;

function bool IsFractured() { return mIsFractured; }
function SetFractured( bool isFractured ) { mIsFractured = isFractured; }

simulated event PostBeginPlay()
{
	super.PostBeginPlay();

	// fix for pitch-black colors
	SetTickIsDisabled(false);
}

event Init()
{
	local H7DestructibleObjectManipulator manipulator;
	local vector emptyVect;
	local H7AdventureMapCell cell;
	local int i;
	local MaterialInstanceConstant RebuildMat;

	mInInit = true; 

	emptyVect = Vect(0,0,0);

	foreach OnBreak_CellsToChange( cell )
	{
		OnBreak_CellsToChangeInitialModifiers.AddItem( cell.mMovementType );
	}

	if( mIsFractured )
	{
		TakeDamage(100000,none,emptyVect,emptyVect,none);
	}

	foreach mManipulators( manipulator )
	{
		manipulator.AddDestructibleObject( self );
	}

	i = 0;
	while (FracturedStaticMeshComponent.GetMaterial(i) != None)
	{
		RebuildMat = new(self) class'MaterialInstanceConstant';
		RebuildMat.SetParent(FracturedStaticMeshComponent.GetMaterial(i));
		FracturedStaticMeshComponent.SetMaterial(i, RebuildMat);
		mRebuildMats.AddItem(RebuildMat);

		i++;
	}

	mInInit = false;
}

event Tick(float DeltaTime)
{
	local MaterialInstanceConstant RebuildMat;
	local FracturedStaticMeshPart FracPart;

	super.Tick(DeltaTime);

	if (mIsSinking)
	{
		//FracActor.FracturedStaticMeshComponent.SetTranslation(FracActor.FracturedStaticMeshComponent.Translation + Vect(0,0,-300) * DeltaTime);
		if( FracActor != none )
		{
			foreach FracActor.FracParts(FracPart)
			{
				//FracPart.FracturedStaticMeshComponent.SetTranslation(FracPart.FracturedStaticMeshComponent.Translation + Vect(0,0,-300) * DeltaTime);
				FracPart.SetLocation(FracPart.Location + Vect(0,0,-300) * DeltaTime);
			}
		}
	}

	if (mIsFXRepairing)
	{
		mRepairPercent += DeltaTime * mRepairSpeed;
		mRepairPercent = FMin(1.0f, mRepairPercent);

		foreach mRebuildMats(RebuildMat)
		{
			RebuildMat.SetScalarParameterValue('BuiltPercent', mRepairPercent);
		}

		if (mRepairPercent >= 1.0f)
		{
			OnToggle( new class'SeqAct_Toggle' );
			mIsFXRepairing = false;
		}
	}
}

function BlockTiles()
{
	local H7AdventureMapCell CellItem;

	foreach OnBreak_CellsToChange(CellItem)
	{
		// set the cells to the desired modifier after breaking
		CellItem.SetMovementType(MOVTYPE_IMPASSABLE);
	}

	OnBlock();
}

function OnBlock()
{
	local FracturedStaticMeshPart FracPart;
	
	if(mDestroySoundEvent != none && !mInInit)
	{
		self.PlayAkEvent(mDestroySoundEvent,true);
	}

	if( FracActor != none )
	{
		foreach FracActor.FracParts(FracPart)
		{
			FracPart.FracturedStaticMeshComponent.SetBlockRigidBody(true);
		}
	}
}

function UnBlockTiles()
{
	local H7AdventureMapCell CellItem;
	local int i;

	foreach OnBreak_CellsToChange(CellItem,i)
	{
		// set the cells to the initial terrain value
		CellItem.SetMovementType(OnBreak_CellsToChangeInitialModifiers[i]);
	}

	OnUnblock();
}

function OnUnblock()
{
	local FracturedStaticMeshPart FracPart;
	local MaterialInstanceConstant RebuildMat;

	mRepairPercent = 0.0f;
	foreach mRebuildMats(RebuildMat)
	{
		RebuildMat.SetScalarParameterValue('BuiltPercent', mRepairPercent);
	}

	SetHidden(false);
	foreach FracActor.FracParts(FracPart)
	{
		FracPart.FracturedStaticMeshComponent.SetBlockRigidBody(false);
	}

	mIsSinking = true;
	SetTimer(mSinkTime, false, 'RebuildFX');
}

function bool IsArmyOnTiles()
{
	local H7AdventureMapCell cell;

	foreach OnBreak_CellsToChange( cell )
	{
		if( cell.GetArmy() != none )
		{
			return true;
		}
	}
	return false;
}

function RebuildFX()
{
	mIsSinking = false;
	mIsFXRepairing = true;
	
	if(mRepairSoundEvent != none && !mInInit)
	{
		self.PlayAkEvent(mRepairSoundEvent,false);
	}

	WorldInfo.MyEmitterPool.SpawnEmitter(mRepairEffect, Location, Rotation);
}

function bool IsDestroying()                { return mIsDestroying; }
function SetDestroying( bool isDestroying ) { mIsDestroying = isDestroying; }
function bool IsRepairing()                 { return mIsRepairing; }
function SetRepairing( bool isRepairing )   { mIsRepairing = isRepairing; }
function array<H7DestructibleObjectManipulator> GetManipulators() { return mManipulators; }


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/** simplified version of FracturedStaticMeshActor's TakeDamage that fractures all of the chunks **/
simulated event TakeDamage(int Damage, Controller EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
	local int i;
	local H7AdventureMapCell CellItem;

	Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);

	// if Damage > 0 = fracture the object | if Damage <= 0 = repair it.
	
	if (Damage > 0)
	{
		SetFractured( true );

		foreach OnBreak_CellsToChange(CellItem)
		{
			CellItem.SetMovementType(OnBreak_NewMovementModifier);
		}

		OnBlock();
	}
	else
	{
		SetFractured( false );

		foreach OnBreak_CellsToChange(CellItem,i) // set the cells to the initial terrain value
		{
			CellItem.SetMovementType(OnBreak_CellsToChangeInitialModifiers[i]);
		}

		OnUnblock();
	}
}

