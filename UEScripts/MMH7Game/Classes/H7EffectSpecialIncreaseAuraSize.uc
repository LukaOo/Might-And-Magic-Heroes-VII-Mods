//=============================================================================
// H7EffectSpecialIncreaseAuraSize
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialIncreaseAuraSize extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var() private IntPoint mAreaGrowth<DisplayName=Growth>;

var private H7Effect                mEffect;
var private H7AuraManager           mAuraManager;
var private array<H7AuraInstance>   mAuraInstances;
var private H7BaseAbility           mSourceAbility;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	if( isSimulated || effect == none || !effect.GetSource().IsA('H7BaseAbility') ) 
	{
		mEffect = none;
		mSourceAbility = none;
		mAuraManager = none;
		mAuraInstances.Length = 0;
		return;
	}

	mEffect = effect;
	mSourceAbility = H7BaseAbility( effect.GetSource() );

	ModifyAuras();

	mEffect = none;
	mSourceAbility = none;
	mAuraManager = none;
	mAuraInstances.Length = 0;
}

function private ModifyAuras()
{
	local int i;

	FindAuraInstances();

	for( i = 0; i < mAuraInstances.Length; ++i )
	{
		if( mAuraInstances[i].mAuraAbility == mSourceAbility )
		{
			mAuraManager.ModifyAuraArea( i, GetIncreasedAuraSize( i ) );
		}
	}
}

function private array<IntPoint> GetIncreasedAuraSize( int index )
{
	local array<IntPoint> auraPoints;
	local array<IntPoint> pointsToAdd, points;
	local H7CombatMapCell cell;
	local int i,j;
	local array<H7Effect> effects;

	auraPoints = mAuraInstances[index].mAffectedCells;

	for( i = 0; i < auraPoints.Length; ++i )
	{
		class'H7Math'.static.GetSpiralIntPointsByDimension( points, auraPoints[i], mAreaGrowth );
		for( j = 0; j < points.Length; ++j )
		{
			pointsToAdd.AddItem( points[j] );
		}
	}

	for( i = 0; i < pointsToAdd.Length; ++i )
	{
		if( !class'H7GameUtility'.static.CellsContainIntPoint( auraPoints, pointsToAdd[i] ) )
		{
			cell = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().GetCellByIntPoint( pointsToAdd[i] );
			if( cell != none )
			{
				effects = mAuraInstances[index].mAuraAbility.GetAllEffects();
				class'H7CombatMapGridController'.static.GetInstance().GetEffectManager().AddToFXQueue( mEffect.GetFx(), effects[0], ,, cell.GetCenterPos(), true );
				auraPoints.AddItem( pointsToAdd[i] );
			}
		}
	}

	return auraPoints;
}

function private FindAuraInstances()
{
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		mAuraManager = class'H7CombatMapGridController'.static.GetInstance().GetAuraManager();
	}
	else
	{
		// adventureMap not handled 
	}

	if( mAuraManager == none ) return;

	mAuraInstances = mAuraManager.GetAuraInstances();
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_INCREASE_SIZE","H7TooltipReplacement");
}

