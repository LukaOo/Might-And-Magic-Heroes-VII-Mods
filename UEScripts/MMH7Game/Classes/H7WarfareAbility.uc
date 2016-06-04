//=============================================================================
// H7WarfareAbility
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WarfareAbility extends H7BaseAbility
	native(Tussi);

// number of times the ability can be used by the owner (only useful for active abilities)
var(Container, Ability)         protected bool           mHasCharges<DisplayName=Has Charges>;
var(Container, Ability)         protected H7ChargeEffect mCharge<DisplayName=Charges|EditCondition=mHasCharges>;
var(Container, SoundAndVisuals) protected AkEvent mAbilitySound<DisplayName=Ability sound>;

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
	local H7ICaster owner;
	// special cases:

	owner = GetInitiator();
	if(self.IsEqual( H7WarUnit(owner).GetWaitAbility() ))
	{
		// no wait when wait buff
		if(H7WarUnit(owner).IsWaitTurn()) 
		{
			blockReason = "TT_WAIT_INACTIVE_STACK_ALREADY";
			return false;
		}

		if(class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsAWaitingUnit( H7WarUnit(owner)) ) 
		{
			blockReason = "TT_WAIT_INACTIVE_STACK_ALREADY";
			; 
			return false;
		}

	}

	// TODO all caster related tussi conditions

	if( GetNumCharges() > 0 && GetCurrentCharges() <= 0)
	{
		blockReason = "TT_NO_CHARGES_LEFT";
		return false;
	}

	if( mOncePerCombat && mCastedOnce )
	{
		blockReason = "TT_CASTED_ONCE";
		return false;
	}

	if(mCaster != none && !H7Unit(mCaster).CanAttack())
	{
		blockReason = "TT_CAN_NOT_ATTACK";
		return false; 
	}

	return true;
}

function ExecuteCreatureAbility()
{
	if( mAbilitySound != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( Actor(mCaster), mAbilitySound,true,true,Actor(mCaster).Location );
	}

	if( GetNumCharges() > 0 &&  GetCurrentCharges() > 0) 
	{
		;
		mCurrentCharges--;
	}
}

function string GetTooltip(optional bool extendedVersion,optional string overwriteBaseString,optional ESkillRank considerOnlyEffectsOfRank=SR_ALL_RANKS, optional bool resetRankOverride = true)
{
	overwriteBaseString = GetTooltipLocalized( mCaster.GetCombatArmy().GetHero() );
	return super.GetTooltip(extendedVersion,overwriteBaseString,considerOnlyEffectsOfRank);
}

