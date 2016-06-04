//=============================================================================
// H7ItemSet
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ItemSet extends H7EffectContainer
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement/*,Display*/)
	showcategories(Display)
	native;

var() protected array<H7HeroItem> mItems<DisplayName=Items>; // double linked list set<->items
var() protected array<H7SetBonus> mSetBonus<DisplayName=Set Bonus>;

function array<H7HeroItem> GetItems() { return mItems; }
function array<H7SetBonus> GetBonus() { return mSetBonus; }

function String GetName() 
{
	local string setColor;
	setColor = class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mSetColor);
	return "<font color='" $ setColor $ "'>" $ super.GetName() $ "</font>";
}

// seach for the highest bonus available
native function GetBoniForItemAmount( int amount, out array<H7MeModifiesStat> boni );

function string GetTooltip(optional bool extendedVersion,optional string overwriteBaseString,optional ESkillRank considerOnlyEffectsOfRank=SR_ALL_RANKS, optional bool resetRankOverride = true)
{ 
	local String tooltip;
	local String stateColor;
	local int i;
	local H7HeroItem item;
	local H7SetBonus bonus;
	local H7MeModifiesStat modStat;
	local H7HeroAbility ability;
	local string replaceColor;

	replaceColor = class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.UnrealColorToHTMLColor(class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.mReplacementColor);
	
	tooltip = "<font size='#TT_DESCRIPTION#'>"; 
	
	// $ GetTooltipLocalized(GetOwner()); // never use flavor tooltip text for sets
	
	tooltip = tooltip $ class'H7Loca'.static.LocalizeSave("ITEMS_IN_SET","H7Abilities") $ ":";
	foreach mItems(item)
	{
		if(GetOwner() != none)
		{
			if(H7AdventureHero(mOwner).GetEquipment().HasItemEquipped(item))
			{
				stateColor = "00ff00";
			}
			else
			{
				stateColor = "999999"; 
			}
		}
		else
		{
			stateColor = "999999";
		}
		tooltip = tooltip $ "<li><font color='#" $ stateColor $ "'>" $ item.GetName() $ "</font></li>";
	}

	tooltip = tooltip $ "\n" $ class'H7Loca'.static.LocalizeSave("SET_BONI","H7Abilities") $ ":\n";
	foreach mSetBonus(bonus)
	{
		if(mOwner != none)
		{
			if(H7AdventureHero(mOwner).GetEquipment().HasSetItemsEquipped(self) >= bonus.NumberOfItems)
			{
				stateColor = "00ff00";
			}
			else
			{
				stateColor = "999999";
			}
		}
		else
		{
			stateColor = "999999";
		}
		tooltip = tooltip $ "<font color='#" $ stateColor $ "'>" $ Repl(class'H7Loca'.static.LocalizeSave("X_ITEMS","H7Abilities"),"%number",bonus.NumberOfItems);
		
		tooltip = tooltip $ "<li>";
		i = 0;
		foreach bonus.SetBonusStat(modStat,i)
		{
			tooltip = tooltip $ (i==0?"":"\n") $ "<font color='" $ replaceColor $ "'>" $ GetStringForOperation(modStat.mCombineOperation,modStat.mModifierValue) $ "</font>" @ GetLocaNameForStat(modStat.mStat,true);
			i++;
		}
		// show ability.tooltip
		if(bonus.SetBonusAbility != none)
		{
			ability = new class'H7HeroAbility'(bonus.SetBonusAbility);
			ability.SetOwner(GetOwner());
			ability.SetCaster(GetOwner());
			ability.InstanciateEffectsFromStructData();
			tooltip = tooltip $ (i==0?"":"\n") $ Repl(ability.GetTooltip(),"#TT_POINT#","14"); // asuming all point are icons (body-text24 hast point-icons20, so desc-text18 needs 14icon)
			i++;
		}
		tooltip = tooltip $ "</li>";
		
		tooltip = Repl(tooltip,"#TT_BODY#","#TT_DESCRIPTION#");
		tooltip = Repl(tooltip,"#TT_POINT#","#TT_DESCRIPTION#");
		tooltip = tooltip $ "</font></li>";
		
	}

	return tooltip;
}


public function array<H7HeroAbility> GetSetBonusAbilities( int EquippedItems, optional bool Removeable=false ) 
{
	local H7SetBonus bonus;
	local array<H7HeroAbility> abilities;

	foreach mSetBonus( bonus )
	{
		if( !Removeable ) 
		{
			if( bonus.NumberOfItems <= EquippedItems && bonus.SetBonusAbility != none )
			{
				abilities.AddItem( bonus.SetBonusAbility );
			}
		}
		else 
		{
			if( bonus.NumberOfItems > EquippedItems && bonus.SetBonusAbility != none )
			{
				abilities.AddItem( bonus.SetBonusAbility );
			}
		}   
	}

	return abilities;
}
