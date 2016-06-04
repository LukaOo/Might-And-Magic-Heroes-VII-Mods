//=============================================================================
// H7EffectSpecialLifeDrain
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialLifeDrain extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);


var() float mPercentDamageToHeal <DisplayName=Heal % of Damage>;

var int CurrentDamage;
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
	local H7ICaster caster;
	local array<H7IEffectTargetable> targets;


	// use this to do a Target Condition check (Life Drain doesn't work on constructs/undead creatures)
	effect.GetTargets( targets );
	if(targets.Length == 0)
	{
		return;
	}

	mDamageRange.MaxValue = container.Result.GetDamage() * mPercentDamageToHeal;
	mDamageRange.MinValue = container.Result.GetDamage() * mPercentDamageToHeal;
		
	caster = effect.GetSource().GetInitiator();
	target = H7IEffectTargetable(caster);

	// create a combat result
	result =  new class'H7CombatResult';
	result.SetCurrentEffect( effect );
	effects.AddItem(effect);
	result.SetEffects(effects);
	result.AddDefender( target );               // caster of this effect is always the healing target
	result.SetAttacker( caster );
	result.AddEffectToTooltip(effect, 0);
	result.SetActionId( ACTION_ABILITY );       // in this case we now this effect will be attached to a buff 
	result.SetBaseDamageRange( mDamageRange );

	class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().ResolveCombat( result, isSimulated );
}

function String GetTooltipReplacement() 
{
	return repl(class'H7Loca'.static.LocalizeSave("TTR_LIFE_DRAIN","H7TooltipReplacement"), "%heal", mDamageRange.MaxValue );
}
