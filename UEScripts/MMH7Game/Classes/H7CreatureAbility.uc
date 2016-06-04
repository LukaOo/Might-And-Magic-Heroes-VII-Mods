//=============================================================================
// H7CreatureAbility
//=============================================================================
//
// ...
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureAbility extends H7BaseAbility
	native;

// number of times the ability can be used by the owner (only useful for active abilities)
var(Container, Ability)         protected bool           mHasCharges<DisplayName=Has Charges>;
var(Container, Ability)         protected H7ChargeEffect mCharge<DisplayName=Charges|EditCondition=mHasCharges>;
var(Container, SoundAndVisuals) protected AkEvent        mAbilitySound<DisplayName=Ability sound>;
var(Container,Ability )         protected bool           mAlwaysCastable<DisplayName=AlwaysCastable>;

function OnInit( H7ICaster caster, optional H7EventContainerStruct container, optional int abilityID )
{
	local H7Effect effect;

	super.OnInit( caster, container, abilityID );
	if( mHasCharges)
	{ 
		effect =  new class'H7EffectCharges';
		H7EffectCharges(effect).InitSpecific(mCharge,self);
		mInstanciatedEffects.AddItem( effect );
	}
	else 
	{
		mNumCharges = 0;
	}
}

function bool CanCast(optional out String blockReason)
{
	local array<H7CombatMapCell> dummyArray;
	local H7ICaster owner;
	// special cases:

	dummyArray.Length = 0;
	owner = GetInitiator();
	if( owner == none || IsArchetype() ) // don't try casting archetypes or abilities without caster
	{
		return false;
	}
	if(self.IsEqual( H7CreatureStack(owner).GetWaitAbility() ))
	{
		// no wait when wait buff
		if(H7CreatureStack(owner).IsWaitTurn()) 
		{
			blockReason = "TT_WAIT_INACTIVE_STACK_ALREADY";
			return false;
		}

		if(class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsAWaitingUnit(H7CreatureStack(owner)) ) 
		{
			blockReason = "TT_WAIT_INACTIVE_STACK_ALREADY";
			return false;
		}

		// no wait when in moral turn
		if(H7CreatureStack(owner).IsMoralTurn()) 
		{
			blockReason = "TT_WAIT_INACTIVE_STACK_MORAL";
			return false;
		}

		if( !H7CreatureStack( owner ).HasFullAction() )
		{
			blockReason = "TT_NO_FULL_TURN";
			return false;
		}
	}

	if(self.IsEqual( H7CreatureStack(owner).GetDefendAbility() ))
	{
		if( !H7CreatureStack( owner ).HasFullAction() )
		{
			blockReason = "TT_NO_FULL_TURN";
			return false;
		}
	}
	else if(H7CreatureStack(owner).IsMoralTurn() && !HasTag(TAG_DAMAGE_DIRECT, false)) // TAG_DAMAGE_DIRECT -> Default Ability
	{
		blockReason = "TT_CANT_USE_ABILITY_ON_MORAL_TURN";
		return false;
	}

	// TODO all caster related tussi conditions

	if( mAlwaysCastable )
		return true;

	if( mOncePerCombat && mCastedOnce )
	{
		blockReason = "TT_CASTED_ONCE";
		return false;
	}

	if( GetNumCharges() > 0 && GetCurrentCharges() <= 0)
	{
		blockReason = "TT_NO_CHARGES_LEFT";
		return false;
	}

	if(mCaster != none && !H7Unit(mCaster).CanAttack())
	{
		blockReason = "TT_CAN_NOT_ATTACK";
		return false; 
	}

	if( mIsRanged && !mIsHeal && // exclude healing abilities from this
		( class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid().HasAdjacentCreature( H7Unit(owner), none, true, dummyArray ) ||
		H7CreatureStack( owner ).GetAttackRange() == CATTACKRANGE_ZERO ) )
	{
		blockReason = "TT_CANT_CAST";
		return false;
	}

	if(IsSuppressed())
	{
		blockReason = "TT_CANT_CAST";
		return false;
	}

	return true;
}

function ExecuteCreatureAbility()
{
	if( mAbilitySound != none  && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( Actor(mCaster), mAbilitySound,true,true, Actor(mCaster).Location );
	}

	if( GetNumCharges() > 0 ) 
	{
		;
		mCurrentCharges--;
	}
}

