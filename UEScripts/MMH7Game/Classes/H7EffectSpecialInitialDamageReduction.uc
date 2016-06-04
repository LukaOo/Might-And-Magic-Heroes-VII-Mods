//=============================================================================
// H7EffectSpecialInitialDamageReduction
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialInitialDamageReduction extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var() float mMultiplier<DisplayName=Damage Multiplier>;
var() bool mMultiplyOnTick<DisplayName=Multiply with every Tick>;

var int mCurrentDamage;
var int mInitialDamage;
var bool mSetDamage;
var H7RangeValue mDamageRange;

/** This is for getting the initial Damage */
function Initialize( H7Effect effect )
{
	
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
		return;
	}

	// since this is Registered By Initialize()
	if( effect.GetSource().GetEventManager().GetCurrentEvent() == ON_GET_DAMAGE  ) // initial pre-calculations (does nothing) for when it's triggered later again
	{
	
		if( mSetDamage )
			return;

		if( container.Result == none ) 
			return;

		mInitialDamage = container.Result.GetDamage();          // previous damage
		mInitialDamage = Round(mInitialDamage * mMultiplier);

		mSetDamage = true;                                      // once set, take iniital damage
		mCurrentDamage = mInitialDamage; 

	}
	else // actual ticking (doing damage) 
	{   
		mDamageRange.MaxValue = mCurrentDamage;
		mDamageRange.MinValue = mCurrentDamage;

		// create a combat result
		result =  new class'H7CombatResult';
		result.SetCurrentEffect( effect );
		effects.AddItem(effect);
		result.SetEffects(effects);
		result.SetAttacker( effect.GetSource().GetInitiator() ); 
		result.SetActionId( ACTION_ABILITY );       // in this case we now this effect will be attached to a buff 
		result.SetBaseDamageRange( mDamageRange );

		effect.GetTargets( targets );

		// add all targets to defender list 
		foreach targets( target )
		{
			result.AddDefender( target );
		}

		class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().ResolveCombat( result, false );

		if(mMultiplyOnTick) mCurrentDamage = Round(mCurrentDamage * mMultiplier);
	}
}

function string GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadableMultiplierAbs(mMultiplier);
}

function string GetValue(int i)
{
	if(i == 1)
	{
		return class'H7GameUtility'.static.FloatToString(mCurrentDamage);
	}
	return "?";
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_INITIAL_DAMAGE_REDUCTION","H7TooltipReplacement");
}
