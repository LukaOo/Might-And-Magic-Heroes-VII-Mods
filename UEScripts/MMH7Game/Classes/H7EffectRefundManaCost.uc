//=============================================================================
// H7EffectReduceManaCost
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectRefundManaCost extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

Var() float mReduceManaCost <DisplayName=Refund Mana Cost By 0-100%>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster; 
	local H7BaseAbility currentBaseAbility;
	local H7HeroAbility currentSpell;
	local float manaSurge;
	local array<H7IEffectTargetable>  targets;
	local float actualAddedMana;

	if( isSimulated ) return;

	// Entropic Touch get targets with event raise
	// TODO this seems hardcoded
	if( effect.GetTrigger().mTriggerType == ON_ANY_ABILITY_ACTIVATE || 
		effect.GetTrigger().mTriggerType == ON_AFTER_ANY_ABILITY_ACTIVATE )
		effect.GetSource().SetTargets( container.TargetableTargets );

	caster = effect.GetSource().GetCaster().GetOriginal();
	effect.GetTargets( targets );

	// conditioncheck on targets 
	if( targets.Length <= 0 ) 
		return; 
   
	if( caster != none && caster.GetPreparedAbility() != none )
	{
		currentBaseAbility = caster.GetPreparedAbility();

		if( !currentBaseAbility.IsSpell() )
			return;
		
		currentSpell = H7HeroAbility( currentBaseAbility );
		
		// get your mana refund
		manaSurge = currentSpell.GetManaCost() * ( mReduceManaCost ) / 100;
		
		if( caster.IsA('H7EditorHero' )) 
		{
			if( caster.IsA('H7CombatHero') )
			{
				actualAddedMana = H7CombatHero( caster ).AddMana( manaSurge );
			}
			else if ( caster.IsA('H7AdventureHero') )
			{
				actualAddedMana = H7AdventureHero( caster ).AddMana( manaSurge );
			}
			H7EditorHero(caster).DisplayStatChangeLog(STAT_CURRENT_MANA,OP_TYPE_ADD,actualAddedMana,effect.GetSource());
			H7EditorHero(caster).DisplayStatChangeFloat(STAT_CURRENT_MANA,OP_TYPE_ADD,actualAddedMana,effect.GetSource());
		}
	}

}


function String GetTooltipReplacement() 
{ 
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_REFUND_MANA","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%percentage", class'H7GameUtility'.static.FloatToString(mReduceManaCost));

	return ttMessage;
}

function string GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercent(mReduceManaCost);
}
