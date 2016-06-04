//=============================================================================
// H7EffectSpecialModifyStatBoniFromBuffs
//
// - modifies stat boni effects in buffs
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialModifyStatBoniFromBuffs extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);


/** The value the stat boni will be modified with. (0.5 -> halve boni modifier, 2 -> double boni modifier)
 *  NOTE: This special effect works only with triggers "Ability: On Init" (modify all active buffs) and "Unit: On Get Buffed" (modify new buff)
 *  to avoid modifying buffs multiple times. */
var(ModifyStatBoniFromBuffs) float mModifierValue<DisplayName=Modify Stat Boni With This>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local array<H7BaseBuff> buffs;
	local H7BaseBuff buff;

	if(isSimulated) { return; }

	if(container.Result != none && container.Result.GetCurrentEffect().IsA('H7EffectWithSpells') && container.Targetable != none)
	{
		buff = H7BaseBuff(H7EffectWithSpells(container.Result.GetCurrentEffect()).GetData().mSpellStruct.mSpell);
		if(buff.HasStatModEffects())
		{
			ModifyStatMods(buff, container.Targetable);
		}
	}
	else
	{
		effect.GetTargets( targets );
		if(targets.Length == 0) { return; }

		foreach targets(target)
		{
			target.GetBuffManager().GetActiveBuffs(buffs);
			if(buffs.Length == 0) { continue; }

			foreach buffs(buff)
			{
				if(!buff.HasStatModEffects()) { continue; }

				ModifyStatMods(buff, target);
			}
		}
	}
}

function ModifyStatMods(H7BaseBuff buff, H7IEffectTargetable target)
{
	local array<H7Effect> statMods;
	local H7Effect statMod;
	local H7StatEffect data;
	local H7ICaster caster;

	if(buff.IsArchetype())
	{
		buff = target.GetBuffManager().GetBuff(buff);
	}

	caster = buff.GetCaster().GetOriginal();
	if(H7BuffSite( caster ) == none) { return; }

	statMods = buff.GetEffectsOfType('H7EffectOnStats');
	foreach statMods(statMod)
	{
		// not persistent = current values -> don't change
		if(statMod.GetTrigger().mTriggerType != PERSISTENT) { continue; }

		data = H7EffectOnStats(statMod).GetData();

		// was i here before?
		if( data.mStatMod.mInitialModValue != data.mStatMod.mModifierValue ) { continue; }

		if(!data.mStatMod.mUseSpellScaling)
		{
			data.mStatMod.mModifierValue *= mModifierValue;
		}
		else
		{
			data.mStatMod.mScalingModifierValue.mSlope *= mModifierValue;
		}

		H7EffectOnStats(statMod).SetData(data);
	}
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_ADD_COUNTER","H7TooltipReplacement");
}

