//=============================================================================
// H7EffectSpecialStormLord
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialStormLord extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);



var() private int mMaxDistance<DisplayName=Maximal distance to connect|ClampMin=1>;

var private array<H7ChainEffectPair>    mChainPairs;
var private array<H7ChainEffectPair>    mAllPairDistances;
var private array<H7CreatureStack>      mTargets;
var private H7Effect                    mEffect;
var private H7AuraManager               mAuraManager;

function Initialize( H7Effect effect ) 
{
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;

	if( isSimulated ) 
	{
		mChainPairs.Length = 0;
		mAllPairDistances.Length = 0;
		mTargets.Length = 0;
		mEffect = none;
		mAuraManager = none;
		return;
	}
	if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) 
	{
		mChainPairs.Length = 0;
		mAllPairDistances.Length = 0;
		mTargets.Length = 0;
		mEffect = none;
		mAuraManager = none;
		return;
	}

	mEffect = effect;

	if( mAuraManager == none )
	{
		mAuraManager = class'H7CombatMapGridController'.static.GetInstance().GetAuraManager();
	}

	effect.GetTargets( targets );

	if( targets.Length < 2 ) 
	{
		mChainPairs.Length = 0;
		mAllPairDistances.Length = 0;
		mTargets.Length = 0;
		mEffect = none;
		mAuraManager = none;
		return;
	}

	HandleChainEffect( targets );

	mChainPairs.Length = 0;
	mAllPairDistances.Length = 0;
	mTargets.Length = 0;
	mEffect = none;
	mAuraManager = none;
}

function private HandleChainEffect( array<H7IEffectTargetable> targets )
{
	local array<H7CreatureStack> stacks;
	local string spam;
	local int i;

	for( i = 0; i < targets.Length; ++i )
	{
		if( H7CreatureStack( targets[i] ) != none )
		{
			stacks.AddItem( H7CreatureStack( targets[i] ) );
		}
	}

	if( stacks.Length < 2 ) return;

	CalculateAllDistances( stacks );

	DestroyFX();

	ConnectClosestPairs();

	InitAuras();

	SpawnFX();

	for( i = 0; i < mChainPairs.Length; ++i )
	{
		spam = spam$"Pair"@i+1@"\n";
		spam = spam$"  A:"@mChainPairs[i].A.GetName()@"\n";
		spam = spam$"  B:"@mChainPairs[i].B.GetName()@"\n";
		spam = spam$"  Distance:"@mChainPairs[i].Distance;

		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(spam,MD_SIDE_BAR);;
		spam = "";
	}
}

function private InitAuras()
{
	local array<H7CombatMapCell> cells;
	local array<IntPoint> cellPoints;
	local int i, j;

	DestroyAuras();

	cellPoints = cellPoints; // to avoid warnings
	
	for( i = 0; i < mChainPairs.Length; ++i )
	{
		class'H7Math'.static.GetLineCellsBresenham( cells, mChainPairs[i].A.GetCell().GetGridPosition(), mChainPairs[i].B.GetCell().GetGridPosition() );

		for( j = 0; j < cells.Length; ++j )
		{
			if( !class'H7GameUtility'.static.CellsContainIntPoint( cellPoints, cells[j].GetGridPosition() ) )
			{
				cellPoints.AddItem( cells[j].GetGridPosition() );
			}
		}
	}

	if( mEffect.GetSource().IsA('H7BaseAbility') )
	{
		mAuraManager.AddAura( class'H7AuraManager'.static.CreateAuraInstance( H7BaseAbility( mEffect.GetSource() ), cellPoints ), H7BaseAbility( mEffect.GetSource() ).GetAuraProperties().mUpdateOnStep );
	}
}

function private DestroyAuras()
{
	mAuraManager.RemoveAuraFromSource( mEffect.GetSource() );
}

function private SpawnFX()
{
	local int i;

	for( i = 0; i < mChainPairs.Length; ++i )
	{
		if( mChainPairs[i].A != none && mChainPairs[i].B != none )
		{
			mChainPairs[i].A.GetEffectManager().AddToFXQueue( mEffect.GetFx(), mEffect, true, GetFXPosition( mChainPairs[i].A, mEffect.GetFx().mSocketName ), GetFXPosition(mChainPairs[i].B,  mEffect.GetFx().mSocketName), true );
		}
	}
}

function private DestroyFX()
{
	local int i;

	for( i = 0; i < mChainPairs.Length; ++i )
	{
		mChainPairs[i].A.GetEffectManager().RemovePermanentFXByEffect( mEffect );
		mChainPairs[i].B.GetEffectManager().RemovePermanentFXByEffect( mEffect );
	}
}

function private Vector GetFXPosition( H7IEffectTargetable unit, string socketName )
{
	local SkeletalMeshSocket socket;
	local SkeletalMeshComponent meshComp;

	if( unit.IsA('H7CreatureStack' ) )
	{   
		meshComp = H7CreatureStack( unit ).GetCreature().GetSkeletalMesh();
	}
	else if( unit.IsA('H7EditorHero') )
	{
		meshComp = H7EditorHero( unit ).mHeroSkeletalMesh;
	}
	else if( unit.IsA('H7Unit') )
	{
		return H7Unit( unit ).GetMeshCenter();
	}

	if( meshComp != none )
	{
		socket = meshComp.GetSocketByName( name( socketName ) );
		return socket != none ? socket.RelativeLocation + meshComp.GetBoneLocation( socket.BoneName ) : H7Unit( unit ).GetMeshCenter();
	}

	return Vect(0,0,0);
}

function private CalculateAllDistances( array<H7CreatureStack> stacks )
{
	local int i, j, distance;
	
	mAllPairDistances.Length = 0;

	for( i = 0; i < stacks.Length - 1; ++i )
	{
		for( j = i + 1; j < stacks.Length; ++j )
		{
			distance = stacks[i].GetCellDistanceToCreature( stacks[j], false );
			
			if( distance <= mMaxDistance )
			{
				CreateAndAddPair( stacks[i], stacks[j], distance );
			}
		}
	}

	mAllPairDistances.Sort( SortFunction );
}

function private int SortFunction( H7ChainEffectPair a, H7ChainEffectPair b )
{
	return ( a.Distance - b.Distance ) * (-1); // ascending
}

function private ConnectClosestPairs()
{
	local array<H7ChainEffectPair> currentPairs;
	local H7SynchRNG rng;
	local int random;

	mChainPairs.Length = 0;

	rng =  class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG();

	currentPairs = GetNextClosestPairs();

	while( currentPairs.Length > 0 )
	{
		if( currentPairs.Length > 1 )
		{
			random = rng.GetRandomInt( currentPairs.Length );
			AddToFinalPairs( currentPairs[random] );
		}
		else
		{
			AddToFinalPairs( currentPairs[0] );
		}

		currentPairs = GetNextClosestPairs();
	}
}

function private array<H7ChainEffectPair> GetNextClosestPairs()
{
	local int i, distance;
	local array<H7ChainEffectPair> pairs;

	distance = -1;
	for( i = 0; i < mAllPairDistances.Length; ++i )
	{
		if( IsInChain( mAllPairDistances[i] ) ) continue;

		if( distance == -1 )
		{
			distance = mAllPairDistances[i].Distance;
		}
		else if( mAllPairDistances[i].Distance != distance )
		{
			break;
		}

		pairs.AddItem( mAllPairDistances[i] );
	}

	return pairs;
}

function private CreateAndAddPair( H7CreatureStack A, H7CreatureStack B, int distance )
{
	local H7ChainEffectPair pair;

	pair.A = A;
	pair.B = B;
	pair.Distance = distance;

	mAllPairDistances.AddItem( pair );
}

function private AddToFinalPairs( H7ChainEffectPair pair )
{
	if( mChainPairs.Find( 'A', pair.A ) == INDEX_NONE && mChainPairs.Find( 'B', pair.A ) == INDEX_NONE &&
		mChainPairs.Find( 'A', pair.B ) == INDEX_NONE && mChainPairs.Find( 'B', pair.B ) == INDEX_NONE )
	{
		mChainPairs.AddItem( pair );
	}
}

function private bool IsInChain( H7ChainEffectPair pair )
{
	local int i;

	for( i = 0; i < mChainPairs.Length; ++i )
	{
		if( mChainPairs[i].A == pair.A || mChainPairs[i].B == pair.A ) return true;
		if( mChainPairs[i].A == pair.B || mChainPairs[i].B == pair.B ) return true;
	}
	
	return false;
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_STORM_LORD","H7TooltipReplacement");
}

