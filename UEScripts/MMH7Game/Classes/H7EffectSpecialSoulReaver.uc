//=============================================================================
// H7EffectSpecialSoulReaver
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialSoulReaver extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var(ManaDrain) protected bool mStealFromEnemy<DisplayName=Steal Mana from Enemy Hero|TooltipText=If set to true, the amount of Mana gained is stolen from the enemy Hero (if there is no Hero, no Mana is gained>;


function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CreatureStack target;
	local int stolenMana, actualAddedMana;
	local H7CombatHero hero, enemyHero;

	if( isSimulated ) 
	{
		return;
	}
	
	target = H7CreatureStack( container.Targetable );

	if( target != none )
	{
		hero = effect.GetSource().GetInitiator().GetCombatArmy().GetHero();
		enemyHero = target.GetCombatArmy().GetHero();
		if(mStealFromEnemy)
		{
			if( enemyHero.IsHero() )
			{
				stolenMana = Clamp( container.Amount, 0, enemyHero.GetCurrentMana() );
				stolenMana = Clamp( stolenMana, 0, hero.GetMagic() );
				actualAddedMana = Clamp( hero.GetCurrentMana() + stolenMana, 0, hero.GetMaxMana() );
			
				class'H7FCTController'.static.GetInstance().startFCT(FCT_STAT_MOD, enemyHero.GetLocation(), hero.GetPlayer(), "-"$stolenMana@Localize("H7General", "TT_MANA", "MMH7Game" ), MakeColor(255,0,0,255));
				if( actualAddedMana - hero.GetCurrentMana() > 0 )
				{
					class'H7FCTController'.static.GetInstance().startFCT(FCT_STAT_MOD, hero.GetLocation(), hero.GetPlayer(), "+"$(actualAddedMana-hero.GetCurrentMana())@Localize("H7General", "TT_MANA", "MMH7Game" ), MakeColor(0,0,255,255));
				}

				enemyHero.SetCurrentMana( enemyHero.GetCurrentMana() - stolenMana );
				hero.SetCurrentMana( actualAddedMana );
			}
		}
		else
		{
			if(container.Amount == 0) { return; }

			actualAddedMana = Clamp( hero.GetCurrentMana() + container.Amount, 0, hero.GetMaxMana() );
			if( actualAddedMana - hero.GetCurrentMana() > 0 )
			{
				class'H7FCTController'.static.GetInstance().startFCT(FCT_STAT_MOD, hero.GetLocation(), hero.GetPlayer(), "+"$(actualAddedMana-hero.GetCurrentMana())@Localize("H7General", "TT_MANA", "MMH7Game" ), MakeColor(0,0,255,255));
			}
			hero.SetCurrentMana( actualAddedMana );
		}
	}
}

function string GetDefaultString()
{
	return "1"; // the "factor" used in the calculation. Since it does not exist, non-existing factor is 1. #Math
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_SOUL_REAVER","H7TooltipReplacement");
}

