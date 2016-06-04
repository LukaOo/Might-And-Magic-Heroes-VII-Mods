//=============================================================================
// H7EffectSpecialModifiedDamageOverTime
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialModifiedDamageOverTime extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);


var() int                   mInitialDamage              <DisplayName=Initial Damage>;

/**Adding this value to the initial value on every event call*/
var() int                   mDamageModifierOverTime     <DisplayName=Damage Modifier>;
var() bool                  mUseStackSize               <DisplayName=Use Stacksize in Damage Calculation>;

var int mCurrentDamage;
var int mInitialStackSize;
var H7ICaster mCaster;
var bool mSetDamage;
var H7RangeValue mDamageRange;
var int mEstimatedDamage;

/** This is for getting the initial Damage */
function Initialize( H7Effect effect )
{
	effect.GetRegistrator().GetEventManager().RegisterListener( effect, ON_GET_DAMAGE );
	mCaster = effect.GetSource().GetInitiator();
	if(H7CreatureStack( mCaster ) != none)
	{
		mInitialStackSize = H7CreatureStack( mCaster ).GetStackSize();
	}
	else
	{
		mInitialStackSize = 1;
	}

	if( mUseStackSize )
		mEstimatedDamage = mInitialDamage * mInitialStackSize;
	else
		mEstimatedDamage = mInitialDamage * mDamageModifierOverTime;
}

/** This will be executed by 2 Triggers ( Events )*/
function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CombatResult result;
	local array<H7Effect> effects;
	local H7IEffectTargetable target;
	local array<H7IEffectTargetable> targets;

	if(isSimulated) 
	{
		mCaster = none;
		return;
	}
	mCaster = effect.GetSource().GetInitiator();

	if( effect.GetSource().GetEventManager().GetCurrentEvent() == ON_GET_DAMAGE && !mSetDamage ) 
	{
		effect.GetRegistrator().GetEventManager().UnregisterListener( effect, ON_GET_DAMAGE );
		mSetDamage = true; // once set, take initial damage
		mCurrentDamage = mInitialDamage; 
		mCaster = container.Result.GetAttacker();
	}
	else if (effect.GetSource().GetEventManager().GetCurrentEvent() == ON_GET_DAMAGE && !mSetDamage)
	{
		mCaster = none;
		return;
	}
	else 
	{   
		if( mUseStackSize )
		{
			mDamageRange.MaxValue = mCurrentDamage * mInitialStackSize;
			mDamageRange.MinValue = mCurrentDamage * mInitialStackSize;
		}
		else 
		{
			mDamageRange.MaxValue = mCurrentDamage;
			mDamageRange.MinValue = mCurrentDamage;
		}

		// create a combat result
		result =  new class'H7CombatResult';
		result.SetCurrentEffect( effect );
		effects.AddItem(effect);
		result.SetEffects(effects);
		result.SetAttacker( mCaster ); 
		result.SetActionId( ACTION_ABILITY );       // in this case we now this effect will be attached to a buff 
		result.SetBaseDamageRange( mDamageRange );

		effect.GetTargets( targets );

		// add all targets to defender list 
		foreach targets( target )
		{
			result.AddDefender( target );
		}
		
		class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().ResolveCombat( result, false );
		
		mCurrentDamage += mDamageModifierOverTime;

		mEstimatedDamage = mUseStackSize ? mCurrentDamage * mInitialStackSize : mCurrentDamage;
	}

	mCaster = none;
}

function string GetDefaultString()
{
	return string(mEstimatedDamage); // next applied damage
}

function string GetValue(int nr)
{
	if(nr == 1)
	{
		return class'H7GameUtility'.static.FloatToString(mEstimatedDamage);
	}
	else if(nr == 2)
	{
		return class'H7GameUtility'.static.FloatToString(Abs(mDamageModifierOverTime));
	}
	return "?";
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_MODIFIED_DAMAGE_OVER_TIME","H7TooltipReplacement");
}
