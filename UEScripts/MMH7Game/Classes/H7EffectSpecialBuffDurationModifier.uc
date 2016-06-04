//=============================================================================
// H7EffectSpecialBuffDurationModifier
//
// - modifies buff durations for other units
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialBuffDurationModifier extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);


/** To increase duration, use positive values, to decrease, use negative ones. (for duration modification during buff initilatization, use H7EffectModifyBuffDuration) */
var(BuffDurationModifier) protected int mModifierValue<DisplayName=Modify Duration this way>;
/** If true, modify debuffs. If "Modify Buffs" is false, only debuffs will be modified. If both are true, all buffs will be modified. */
var(BuffDurationModifier) protected bool mModifyDebuffs<DisplayName=Modify Debuffs>;
/** If true, modify buffs. If "Modify Debuffs" is false, only buffs, not debuffs, will be modified. If both are true, all buffs will be modified. */
var(BuffDurationModifier) protected bool mModifyBuffs<DisplayName=Modify Buffs>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local array<H7BaseBuff> buffs;

	effect.GetTargets( targets );

	foreach targets(target)
	{
		if(H7Unit(target) != none)
		{
			H7Unit(target).GetBuffManager().GetActiveBuffs(buffs);

			ModifyBuffs( buffs, H7Unit(target) );
		}
	}
}

function ModifyBuffs(array<H7BaseBuff> buffs, H7Unit unit)
{
	local H7BaseBuff buff;
	local int currentDuration;

	foreach buffs(buff)
	{
		if(!buff.IsFromMagicSource()) { continue; }

		currentDuration = buff.GetCurrentDuration();

		if(mModifyBuffs && !mModifyDebuffs && buff.IsDebuff()       // modify only buffs and current buff is a debuff -> don't modify
			|| !mModifyBuffs && mModifyDebuffs && !buff.IsDebuff()) // modify only debuffs and current buff is a buff -> don't modify
		{
			continue;
		}

		// if mModifierValue is negative, check if buff will expire
		if(currentDuration + mModifierValue <= 0)
		{
			unit.GetBuffManager().RemoveBuff(buff);
		}
		else
		{
			buff.SetCurrentDuration(currentDuration + mModifierValue);
		}
	}
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_BUFF_DURATION","H7TooltipReplacement");
}

function string GetDefaultString()
{
	return string(mModifierValue);
}

