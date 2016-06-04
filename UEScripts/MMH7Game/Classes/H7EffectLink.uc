//=============================================================================
// H7EffectLink
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectLink extends Object 
	implements(H7IEffectDelegate)
	hidecategories( Object )
	native(Tussi);

/** Share incoming damage with the target creatures */
var( Link ) protected bool	            mIsShieldingEffect  <DisplayName=Is Shielding Effect>;
/** Amount of damage that goes through to the owner of this effect */
var( Link, Shielding ) protected int	mDamageToOwner      <DisplayName=Damage to Source ( Percent )|ClampMin=0|ClampMax=100|EditCondition=mIsShieldingEffect>;
/** Amount of damage that goes through to the targets of this effect */
var( Link, Shielding ) protected int	mDamageToTargets    <DisplayName=Damage to Target ( Percent )|ClampMin=0|ClampMax=100|EditCondition=mIsShieldingEffect>;
/** Avoid "Shield Chains" (ex.: one unit gets damage by shielding another unit and also gets shielded by a third unit) */
var( Link, Shielding ) protected bool	mNoChains           <DisplayName="Don't Apply to Already Shielded Damage">;

var protected H7CombatController mCombatController;
var protected H7AdventureController mAdventureController;

var protected H7Effect mEffect;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable currentTarget;
	local H7Unit unit;
	local H7ICaster caster;
	
	mEffect = effect;
	
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		mCombatController = class'H7CombatController'.static.GetInstance();
	}
	else
	{
		mAdventureController = class'H7AdventureController'.static.GetInstance();
	}
	
	if( mAdventureController == none && mCombatController == none ) return; // shit is getting real 

	effect.GetTargets( targets );

	if( targets.Length <= 0 ) return;

	if( !isSimulated )
	{
		if( effect.GetSource().IsAbility() && H7BaseAbility( effect.GetSource() ).IsPassive() ) 
		{
			H7BaseAbility( effect.GetSource() ).DoParticleFXCaster( effect.GetSource().GetCasterOriginal() );
		}

		if( effect.GetFx().mUseCasterPosition ) 
		{
			effect.GetSource().GetCasterOriginal().GetEffectManager().AddToFXQueue( effect.GetFx(), effect );
		}
		else
		{
			foreach targets( currentTarget )
			{
				unit = H7Unit( currentTarget );
				caster = effect.GetSource().GetCaster().GetOriginal();
				currentTarget.GetEffectManager().AddToFXQueue( effect.GetFx(), effect, !mIsShieldingEffect, GetFXPosition(unit, effect.GetFx().mSocketName ), GetFXPosition(H7Unit(caster),  effect.GetFx().mSocketName), !mIsShieldingEffect );
			}
		}
	}
	
	LinkEffects( targets, container.Result, effect.GetSource().GetTarget() );
}

function protected Vector GetFXPosition( H7Unit unit, string socketName )
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
	if( meshComp != none )
	{
		socket = meshComp.GetSocketByName( name( socketName ) );
		return socket != none ? socket.RelativeLocation + meshComp.GetBoneLocation( socket.BoneName ) : unit.GetTargetLocation();
	}

	return Vect(0,0,0);
}

function protected LinkEffects( array<H7IEffectTargetable> targets, out H7CombatResult result, H7IEffectTargetable target )
{
	local int i;
	local array<H7IEffectTargetable> defenders; 
	local int index;
	local H7Unit source;
	local H7IEffectTargetable tmpTarget;
	local H7ICaster caster;
	local H7TooltipMultiplier multi;
	local H7EffectDamage damageEffect;

	if( result == none ) return;


	tmpTarget = mEffect.GetSource().GetTarget();
	caster = mEffect.GetSource().GetCaster().GetOriginal();
	source = mEffect.GetSource().IsA( 'H7BaseBuff' ) ? H7Unit( caster ) : H7Unit( tmpTarget );

	if( source == none ) return;

	defenders = result.GetDefenders();
	index = defenders.Find( target );
	damageEffect = H7EffectDamage( result.GetCurrentEffect() );

	if( index == INDEX_NONE || result.IsHeal( index ) ||
		damageEffect == none ||
		damageEffect != none && damageEffect.IsHeal() )
	{
		return;
	}

	if( mNoChains )
	{
		multi = result.GetMultiplier( MT_SHIELDER, index );
		if( multi.type != MT_MAX )
		{
			return;
		}
	}

	if( mDamageToTargets > 0 )
	{   
		if( index != INDEX_NONE )
		{
			result.AddMultiplier( MT_SHIELDED, mDamageToTargets * 0.01f, index );
			result.SetTriggerEvents( false, defenders.Length - 1 );
		}
	}
	
	if( mDamageToOwner < 100 )
	{
		for( i = 0; i < targets.Length; ++i )
		{
			AddToResults( targets[i], result, defenders, target );
			defenders = result.GetDefenders();
			index = GetUntaggedDefender( source, defenders, result );
			if( index != INDEX_NONE )
			{
				result.AddMultiplier( MT_SHIELDER, mDamageToOwner * 0.01f, index );
			}
		}
	}
}

function protected AddToResults( H7IEffectTargetable target, out H7CombatResult result, out array<H7IEffectTargetable> defenders, H7IEffectTargetable victim )
{
	local array<H7effect> effects;
	local H7Effect effect;
	local int index;

	result.AddDefender( target,,!mIsShieldingEffect );
	defenders.AddItem( target );

	index = defenders.Find( victim );
	
	// copy all effects from victim over to the shielder
	effects = result.GetTooltipEffects(index);
	foreach effects(effect)
	{
		if( result.GetDefenderCount() > 0 )
		{
			result.AddEffectToTooltip(effect,result.GetDefenderCount()-1);
		}
	}
}

function protected int GetUntaggedDefender( H7IEffectTargetable unit, out array<H7IEffectTargetable> units, out H7CombatResult result )
{
	local int i;

	for( i = 0; i < units.Length; i++ )
	{
		if( units[i] == unit && result.GetTriggerEvents(i) )
		{
			return i;
		}
	}

	return -1;
}

function String GetTooltipReplacement() 
{ 
	return mIsShieldingEffect ? class'H7Loca'.static.LocalizeSave("TTR_SHIELD_LINK_SHARE","H7TooltipReplacement") : class'H7Loca'.static.LocalizeSave("TTR_SHIELD_LINK_DOUBLE","H7TooltipReplacement") ;
}

