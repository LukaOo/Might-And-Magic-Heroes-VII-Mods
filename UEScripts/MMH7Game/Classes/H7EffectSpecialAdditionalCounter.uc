//=============================================================================
// H7EffectSpecialAdditionalCounter
//
// - counts attacks on buffed unit and sends ON_BUFF_EXPIRE if countTo value is reached
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialAdditionalCounter extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var protected int currentCount;

/** Count to this value. If it is reached, call "Buff Expire" event. */
var(AdditionalCounter) protected int countTo<DisplayName=Count to this value (NOTE: works for attacks only!)>;
/** If set, the incoming attack will miss. */
var(AdditionalCounter) protected bool missAttack<DisplayName=Make Attack miss?>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CombatResult currentResult;
	local int currentResultIndex;
	local H7ICaster caster;
	local array<H7IEffectTargetable> targets;


	// even if this thing needs no targets: GetTargets does a ConditionCheck->Attack/CasterConditionCheck
	// might be important to do
	effect.GetTargets(targets);
	if(targets.Length == 0) return;

	if(currentCount < countTo)
	{
		// get the correct combat result
		if(isSimulated)
		{
			currentResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult();
			currentResultIndex = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResultMainId();
		}
		else
		{
			// GetCurrentResult doesn't work anymore, so use the one from the event container
			currentResult = container.Result;
			currentResultIndex = 0;
		}

		caster = currentResult.GetCurrentEffect().GetSource().GetInitiator();
		// only default physical attacks can miss!
		if(!caster.IsDefaultAttackActive())
		{
			return;
		}

		if(missAttack)
		{
			// set miss to true (adjustment of damage etc will be done later)
			currentResult.SetMiss(true, currentResultIndex);
			currentResult.UpdateDamageRange();
		}

		if(!isSimulated)
		{
			currentCount++;

			if(currentCount == countTo && effect.GetSource().IsA('H7BaseBuff'))
			{
				// if source is a buff, expire it
				H7BaseBuff( effect.GetSource() ).OnExpire();
			}
		}
	}
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_ADD_COUNTER","H7TooltipReplacement");
}

function string GetDefaultString()
{
	return string(countTo);
}

