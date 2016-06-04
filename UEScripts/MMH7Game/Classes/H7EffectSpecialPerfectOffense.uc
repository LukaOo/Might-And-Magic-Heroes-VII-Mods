//=============================================================================
// H7EffectSpecialPerfectOffense
//
// - special effect for the hero ability "Perfect Offense" (Assailant skill)
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialPerfectOffense extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


/** The buff archetype that will hold the stat modifier. */
var() protected H7BaseBuff mBuff<DisplayName=Buff>;
/** This is the stat that will be modified. */
var() protected EStat mStatToModify<DisplayName=Stat to Modify>;
/** The stat of the enemy that should change the stat to modify. */
var() protected EStat mStatToUse<DisplayName=Stat to Use for the Modification (enemy)>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local float enemyValue, myValue;
	local H7BaseBuff initBuff;
	local H7CreatureStack unit;
	local H7ICaster owner;

	// don't do anything if it's simulated, since SetData of H7EffectOnStats can't
	// handle simulation and might screw up the buff
	if(isSimulated) { return; }

	unit = H7CreatureStack(container.Targetable);
	if( unit == none ) return;
	enemyValue = unit.GetModifiedStatByID(mStatToUse);
	
	owner = effect.GetSource().GetInitiator().GetOriginal();
	if( owner == none ) return;
	unit = H7CreatureStack(owner);
	if( unit == none ) return;
	myValue = unit.GetModifiedStatByID(mStatToUse);

	if(enemyValue > myValue)
	{
		if(!unit.GetBuffManager().HasBuff(mBuff,none,true))
		{
			initBuff = new mBuff.Class(mBuff);
			initBuff.Init(unit, effect.GetSource().GetCaster().GetOriginal(), false);
			AdjustStatModifier(initBuff, enemyValue);
			unit.GetBuffManager().AddBuff(initBuff, effect.GetSource().GetCaster().GetOriginal(), effect.GetSource() );
		}
		else
		{
			initBuff = new mBuff.Class(mBuff);
			initBuff.Init(unit, effect.GetSource().GetCaster().GetOriginal(), false);
			initBuff = unit.GetBuffManager().GetBuff(initBuff);
			AdjustStatModifier(initBuff, enemyValue);
		}
	}
}

function protected AdjustStatModifier( H7BaseBuff buff, float newValue )
{
	local H7StatEffect myStatEffect;
	local array<H7Effect> effects;
	local H7Effect effect;

	effects = buff.GetEffectsOfType( 'H7EffectOnStats' );

	foreach effects( effect )
	{
		myStatEffect = H7EffectOnStats( effect ).GetData();

		if( myStatEffect.mStatMod.mStat == mStatToModify )
		{
			myStatEffect.mStatMod.mModifierValue = newValue;
			H7EffectOnStats(effect).SetData(myStatEffect);

			break;
		}
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_OFFENSE","H7TooltipReplacement");
}
