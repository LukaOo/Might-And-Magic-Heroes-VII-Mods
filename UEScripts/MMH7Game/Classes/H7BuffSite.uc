/*=============================================================================
* H7BuffSite
* =============================================================================
* Base class for adventure map objects that provide buffs to heroes.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
*  
*  
*  
* =============================================================================*/

class H7BuffSite extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	dependson(H7ITooltipable)
	hidecategories(Defenses)
	placeable
	native
	savegame;

/** The ability that is triggered when this building is visited */
var(Developer) protected archetype H7BaseAbility mAbility<DisplayName=Ability to trigger>;
/**The costs which are usually taken for the visit are ignored if enabled*/
var(Developer) protected bool mDisablePickupCosts<DisplayName=Disable Pickup Costs>;

var         protected savegame bool      mIsHidden;

native function bool IsHiddenX();

function bool SpendPickupCostsOnVisit(H7AdventureHero visitingHero)
{
	local bool hasAllBuffs;
	if(visitingHero != none)
	{
		hasAllBuffs = HasAllBuffsFromHere( visitingHero );
		// only pay costs if something is actually going to happen
		return !hasAllBuffs;
	}
	
	return false;
}

event InitAdventureObject()
{
	super.InitAdventureObject();

	if( mAbility != none )
	{
		GetAbilityManager().LearnAbility( mAbility );
	}
}

function OnVisit( out H7AdventureHero hero )
{
	local bool hasAllBuffs;
	local array<H7Effect> effects;
	local H7Effect effect;
	local H7SpellStruct spellStruct;
	local Vector offsetVector;
	local string fctMessage;
	//fctTriggered: For multiple effects in one buff. Dont start spaming the FCT more than once
	local bool usePickupCost, canApplyAtLeastOne, fctTriggered;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	usePickupCost = false;
	canApplyAtLeastOne = false;
	hasAllBuffs = HasAllBuffsFromHere( hero );
	if( hasAllBuffs )
	{
		effects = mAbilityManager.GetAbility( mAbility ).GetEffectsOfType( 'H7EffectWithSpells' );
		foreach effects( effect )
		{
			spellStruct = H7EffectWithSpells( effect ).GetData().mSpellStruct;
			if( spellStruct.mSpellOperation == ADD_ABILITY && !fctTriggered)
			{
				fctMessage = class'H7Loca'.static.LocalizeSave("FCT_ALREADY_LEARNED_ABILITY","H7FCT");
				fctMessage = Repl(fctMessage, "%owner", hero.GetName());
				fctMessage = Repl(fctMessage, "%ability", spellStruct.mSpell.GetName());
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, self.Location, hero.GetPlayer(), fctMessage, MakeColor(255,255,0,255) );
				fctTriggered = true;
				offsetVector.Z += 200;
			}
			else if( spellStruct.mSpellOperation == ADD_BUFF && !fctTriggered)
			{
				fctMessage = class'H7Loca'.static.LocalizeSave("FCT_ALREADY_GOT_BUFF","H7FCT");
				fctMessage = Repl(fctMessage, "%owner", hero.GetName());
				fctMessage = Repl(fctMessage, "%buff", spellStruct.mSpell.GetName());
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR, self.Location, hero.GetPlayer(), fctMessage ,MakeColor(255,255,0,255) );
				fctTriggered= true;
				offsetVector.Z += 200;
			}
		}
	}
	else
	{
		effects = mAbilityManager.GetAbility( mAbility ).GetEffectsOfType( 'H7EffectWithSpells' );
		foreach effects( effect )
		{
			spellStruct = H7EffectWithSpells( effect ).GetData().mSpellStruct;
			if( spellStruct.mSpellOperation == ADD_ABILITY )
			{
				if( H7BaseAbility( spellStruct.mSpell ) != none && !hero.GetAbilityManager().HasAbility( H7BaseAbility( spellStruct.mSpell ) ) )
				{
					fctMessage = class'H7Loca'.static.LocalizeSave("FCT_LEARNED_ABILITY","H7FCT");
					fctMessage = Repl(fctMessage, "%owner", hero.GetName());
					fctMessage = Repl(fctMessage, "%ability", spellStruct.mSpell.GetName());
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, self.Location + offsetVector, hero.GetPlayer(), fctMessage ,,spellStruct.mSpell.GetIcon() );
					offsetVector.Z += 200;
					usePickupCost = true;
					canApplyAtLeastOne = true;
				}
			}
			else if( spellStruct.mSpellOperation == ADD_BUFF )
			{
				if( H7BaseBuff( spellStruct.mSpell ) != none
					&& !hero.GetBuffManager().HasBuff( H7BaseBuff( spellStruct.mSpell ), hero, false )
					&& effect.ConditionCheck(H7IEffectTargetable(hero), H7ICaster(self), true ) )
				{
					if(H7BaseBuff( spellStruct.mSpell ).IsDisplayed())
					{
						fctMessage = class'H7Loca'.static.LocalizeSave("FCT_RECIEVED_BUFF","H7FCT");
						fctMessage = Repl(fctMessage, "%owner", hero.GetName());
						fctMessage = Repl(fctMessage, "%buff", spellStruct.mSpell.GetName());
						class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, self.Location + offsetVector, hero.GetPlayer(), fctMessage,,spellStruct.mSpell.GetIcon() );
						offsetVector.Z += 200;
					}
					usePickupCost = true;
					canApplyAtLeastOne = true;
				}
				else if (!effect.ConditionCheck(H7IEffectTargetable(hero), H7ICaster(self), true ) && !fctTriggered)
				{
					fctMessage = class'H7Loca'.static.LocalizeSave("FCT_DONT_VISIT","H7FCT");
					class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, self.Location + offsetVector, hero.GetPlayer(), fctMessage );
					fctTriggered = true;
					offsetVector.Z += 200;
				}
			}
		}
	}

	// only subtract pickup costs if something happened
	if(usePickupCost && !mDisablePickupCosts)
	{
		hero.UseMovementPoints( hero.GetModifiedStatByID( STAT_PICKUP_COST ) );
	}

	if( canApplyAtLeastOne )
	{
		// this gives the buff (only visit if anything is really executed! don't waste buffs that won't have any effect on the visitor)
		super.OnVisit( hero );
	}
}

function bool HasAllBuffsFromHere( H7AdventureHero hero )
{
	local array<H7Effect> effects;
	local H7Effect effect;
	local H7SpellStruct spellStruct;

	effects = mAbilityManager.GetAbility( mAbility ).GetEffectsOfType( 'H7EffectWithSpells' );
	foreach effects( effect )
	{
		spellStruct = H7EffectWithSpells( effect ).GetData().mSpellStruct;
		if( spellStruct.mSpellOperation == ADD_ABILITY )
		{
			if( H7BaseAbility( spellStruct.mSpell ) != none && !hero.GetAbilityManager().HasAbility( H7BaseAbility( spellStruct.mSpell ) ) )
			{
				return false;
			}
		}
		else if( spellStruct.mSpellOperation == ADD_BUFF )
		{
			if( H7BaseBuff( spellStruct.mSpell ) != none && !hero.GetBuffManager().HasBuff( H7BaseBuff( spellStruct.mSpell ), hero, false ) && effect.ConditionCheck(H7IEffectTargetable(hero), H7ICaster(self), true ) && effect.ConditionCheck(H7IEffectTargetable(hero), H7ICaster(self), true ))
			{
				return false;
			}
		}
	}
	return true;
}

function array<H7EffectContainer> GetBuffArchetypes()
{
	local array<H7SpellEffect> spellEffects;
	local H7SpellEffect spellEffect;
	local array<H7EffectContainer> buffs;

	spellEffects = mAbility.GetSpellEffects();
	foreach spellEffects( spellEffect )
	{
		if( H7BaseBuff( spellEffect.mSpellStruct.mSpell ) != none )
		{
			buffs.AddItem(spellEffect.mSpellStruct.mSpell);
		}
	}
	return buffs;
}

function H7TooltipData GetTooltipData(optional bool extended)
{
	local H7TooltipData data;
	local string showName,description;

	if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none )
	{
		if( HasAllBuffsFromHere( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero() ) )
			data.Visited = GetVisitString(true);
		else
			data.Visited = GetVisitString(false);
	}
	
	data.type = TT_TYPE_STRING;

	if(mAbility != none)
	{
		// show tooltip of the ability as tooltip of the building
		showName = GetName(); //mAbilityManager.GetAbility( mAbility ).GetName();
		description = mAbilityManager.GetAbility( mAbility ).GetTooltip();
	}
	else
	{
		showName = class'H7Loca'.static.LocalizeSave("TT_NOTHING","H7AdventureBuildings");
		description = class'H7Loca'.static.LocalizeSave("TT_NOTHING","H7AdventureBuildings");
	}
	
	data.Title = showName;
	data.Description = "<font size='#TT_BODY#'>" $ description $ "</font>";

	return data;
}

function Color GetColor()
{
	if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none && HasAllBuffsFromHere( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero() ) )
	{
		return GetVisitedColor();
	}
	else
	{
		return GetNotVisitedColor();
	}
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
