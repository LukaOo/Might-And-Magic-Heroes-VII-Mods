//=============================================================================
// H7EffectDivergeEnemyHeroManaCost
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectDivergeEnemyHeroManaCost extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() float mDivergeManaGainModifier <DisplayName=Diverge modifier which is divided with the enemy mana consumption>; // enemy spends x mana, I get 1

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster; 
	local H7BaseAbility currentBaseAbility;
	local H7HeroAbility currentSpell;
	local float manaSurge;
	local array<H7IEffectTargetable>  targets;
	local float actualAddedMana;
	local H7CombatHero opponentHero;

	if( isSimulated ) return;

	if( effect.GetTrigger().mTriggerType == ON_ANY_ABILITY_ACTIVATE || 
		effect.GetTrigger().mTriggerType == ON_AFTER_ANY_ABILITY_ACTIVATE )
		effect.GetSource().SetTargets( container.TargetableTargets );

	caster = effect.GetSource().GetCaster().GetOriginal();
	effect.GetTargets( targets );

	// conditioncheck on targets 
	if( targets.Length <= 0 ) 
		return; 

	opponentHero = class'H7CombatController'.static.GetInstance().GetOpponentArmy( H7CombatHero (caster).GetCombatArmy() ).GetPlayer().GetHeroInCombat();

	currentBaseAbility = opponentHero.GetPreparedAbility();

	if(currentBaseAbility == none)
	{
		return;
	}

	if( caster != none && caster.GetAbilityManager() != none && caster.IsA('H7CombatHero') )
	{
		currentSpell = H7HeroAbility( currentBaseAbility );
		
		// get your mana refund
		manaSurge = currentSpell.GetManaCost() / mDivergeManaGainModifier;

		if(manaSurge > 0.f)
		{
			actualAddedMana = H7CombatHero(caster).AddMana( manaSurge );
		
			H7CombatHero(caster).DisplayStatChangeLog(STAT_CURRENT_MANA,OP_TYPE_ADD,actualAddedMana,effect.GetSource());
			H7CombatHero(caster).DisplayStatChangeFloat(STAT_CURRENT_MANA,OP_TYPE_ADD,actualAddedMana,effect.GetSource());
		}
	}
}


function String GetTooltipReplacement() 
{ 
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_MANA_DIVERGENCE","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%value", class'H7GameUtility'.static.FloatToString(mDivergeManaGainModifier));

	return ttMessage;
}

function String GetDefaultString()
{
	return class'H7GameUtility'.static.FloatToString( mDivergeManaGainModifier );
}

function Texture2d GetIcon()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIconsInText.GetStatIcon(STAT_MANA);
}
