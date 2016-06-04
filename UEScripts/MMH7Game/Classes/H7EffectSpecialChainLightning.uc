//=============================================================================
// H7EffectSpecialChainLightning
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialChainLightning extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);



var( ChainLightning ) int   mBranchAmount<DisplayName=Amount of Branches|ClampMin=1>;
var( ChainLightning ) int   mJumpAmount<DisplayName=Amount of Jumps|ClampMin=1>;
var( ChainLightning ) float mDamageModifierPerJump<DisplayName=Damage modifier per jump|ClampMin=0>;

var private H7CombatResult              mResult;
var private H7IEffectTargetable         mRootTarget;
var private array<H7IEffectTargetable>  mTargets;
var private H7CombatMapGridController   mCombatGridController;
var private array<H7TargetableArray>    mChainTargets;
var private H7Effect                    mEffect;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	// only trigger if triggered by owning EffectContainer, not simulated and on combatmap
	if( isSimulated || effect.GetSource() != container.EffectContainer || !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) 
	{
		mResult = none;
		mRootTarget = none;
		mChainTargets.Length = 0;
		mEffect = none;
		mTargets.Length = 0;
		mCombatGridController = none;
		return; 
	}

	if( mCombatGridController == none )
	{
		mCombatGridController = class'H7CombatMapGridController'.static.GetInstance();
	}

	mResult = container.Result;

	if( mResult == none ) 
	{
		mResult = none;
		mRootTarget = none;
		mChainTargets.Length = 0;
		mEffect = none;
		mTargets.Length = 0;
		mCombatGridController = none;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("No CombatResult carried over with this event! Please use ON_DO_ATTACK",MD_QA_LOG);;
		return;
	}

	// clean up targets
	mTargets.Length = 0;

	effect.GetValidTargets( mTargets, targets, true );
	mTargets = targets;
	mRootTarget = mResult.GetDefender();
	mEffect = effect;

	GatherChainTargets();
	AddTargetsToResult();
	PlayFX();


	mResult = none;
	mRootTarget = none;
	mChainTargets.Length = 0;
	mEffect = none;
	mTargets.Length = 0;
	mCombatGridController = none;

}

function private PlayFX()
{
	local int i, j;

	for( i = 0; i < mChainTargets.Length; ++i )
	{
		if( mChainTargets[i].targets.Length > 0 )
		{
			mRootTarget.GetEffectManager().AddToFXQueue( mEffect.GetFx(), mEffect, true, GetFXPosition( mRootTarget, mEffect.GetFx().mSocketName ), GetFXPosition(mChainTargets[i].targets[0],  mEffect.GetFx().mSocketName), true );
		}

		for( j = 0; j < mChainTargets[i].targets.Length; ++j )
		{
			if( j != mChainTargets[i].targets.Length - 1 )
			{
				mChainTargets[i].targets[j].GetEffectManager().AddToFXQueue( mEffect.GetFx(), mEffect, true, GetFXPosition(mChainTargets[i].targets[j], mEffect.GetFx().mSocketName ), GetFXPosition(mChainTargets[i].targets[j+1],  mEffect.GetFx().mSocketName), true );
			}
		}
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

function private GatherChainTargets()
{
	local array<H7IEffectTargetable> closestTargets;
	local H7IEffectTargetable target;
	local int i, j, r;

	mChainTargets.Length = 0;
	mChainTargets.Add( mBranchAmount );

	for( j = 0; j < mJumpAmount; ++j )
	{
		for( i = 0; i < mBranchAmount; ++i )
		{
			if( mChainTargets[i].targets.Length == 0 )
			{
				target = mRootTarget;
			}
			else
			{
				target = mChainTargets[i].targets[ mChainTargets[i].targets.Length-1 ];
			}

			closestTargets = GetClosestTargets( target );
			if( closestTargets.Length > 1 )
			{
				r = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( closestTargets.Length );

				mChainTargets[i].targets.AddItem( closestTargets[r] );
				//class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Actor( closestTargets[r] ).Location, "Chain:"@(i+1), MakeColor(55*(i+1),70*(i+1),80*(i+1)) );
			}
			else if( closestTargets.Length > 0 )
			{
				mChainTargets[i].targets.AddItem( closestTargets[0] );
				//class'H7FCTController'.static.GetInstance().startFCT(FCT_TEXT, Actor( closestTargets[0] ).Location, "Chain:"@(i+1), MakeColor(55*(i+1),70*(i+1),80*(i+1)) );
			}
		}
	}
}

function private AddTargetsToResult()
{
	local array<H7IEffectTargetable> defender;
	local int i, j;

	defender = mResult.GetDefenders();

	for( i = 0; i < mChainTargets.Length; ++i )
	{
		for( j = 0; j < mChainTargets[i].targets.Length; ++j )
		{
			if( mChainTargets[i].targets[j] != none && defender.Find( mChainTargets[i].targets[j] ) == INDEX_NONE )
			{
				mResult.AddDefender( mChainTargets[i].targets[j] );
				defender.AddItem( mChainTargets[i].targets[j] );

				mResult.AddMultiplier( MT_CHAIN, GetDamageModifier( j ), defender.Find( mChainTargets[i].targets[j] ) );
			}
		}
	}
}

function private float GetDamageModifier( int jumpCount )
{
	local int i;
	local float val;

	val = 1.0f;

	for( i = 0; i < jumpCount + 1; ++i )
	{
		val *= mDamageModifierPerJump;
	}

	return val;
}

function private array<H7IEffectTargetable> GetClosestTargets( H7IEffectTargetable target )
{
	local int i;
	local H7IEffectTargetable bestTarget;
	local float currentDistance, bestDistance;
	local array<H7IEffectTargetable> targets;

	bestDistance = MaxInt;

	for( i = 0; i < mTargets.Length; ++i )
	{
		if( IsProcessed( mTargets[i] ) || mTargets[i] == target || mTargets[i] == mRootTarget ) continue;

		currentDistance = GetDistance( target, mTargets[i] );

		if( currentDistance < bestDistance )
		{
			bestDistance = currentDistance;
			bestTarget = mTargets[i];
		}
	}

	if( bestTarget == none ) return targets;
	targets.AddItem( bestTarget );

	for( i = 0; i < mTargets.Length; ++i )
	{
		if( IsProcessed( mTargets[i] ) || mTargets[i] == target || mTargets[i] == mRootTarget || mTargets[i] == bestTarget ) continue;

		currentDistance = GetDistance( mTargets[i], target );

		if( currentDistance == bestDistance )
		{
			targets.AddItem( mTargets[i] );
		}
	}

	return targets;
}

function private bool IsProcessed( H7IEffectTargetable target ) 
{
	local int i;

	for( i = 0; i < mChainTargets.Length; ++i )
	{
		if( mChainTargets[i].targets.Find( target ) != INDEX_NONE )
		{
			return true;
		}
	}

	return false;
}

function private float GetDistance( H7IEffectTargetable source, H7IEffectTargetable target )
{
	local Vector a, b;

	a = mCombatGridController.GetCombatGrid().GetCellByIntPoint( source.GetGridPosition() ).GetCenterByCreatureDim( GetSize( source ) );
	b = mCombatGridController.GetCombatGrid().GetCellByIntPoint( target.GetGridPosition() ).GetCenterByCreatureDim( GetSize( target ) );

	return FFloor( VSize( a - b ) );
}

function private int GetSize( H7IEffectTargetable target )
{
	if( target.IsA('H7Unit') ) 
	{
		return H7Unit( target ).GetUnitBaseSizeInt();
	}
	return 1;
}

function String GetTooltipReplacement() 
{
	// TTR_LIGHTNING_EFFECT = Damage will make %jumps jumps and branch %branches with %percent loss per jump
	local string tmp;
		
	tmp = class'H7Loca'.static.LocalizeSave("TTR_LIGHTNING_EFFECT","H7TooltipReplacement");
	tmp = Repl(tmp,"%jumps",mJumpAmount);
	tmp = Repl(tmp,"%branches",mBranchAmount);
	tmp = Repl(tmp,"%percent", class'H7GameUtility'.static.FloatToString(mDamageModifierPerJump) );

	return tmp;
}

