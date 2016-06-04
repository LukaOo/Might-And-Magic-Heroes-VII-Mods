//=============================================================================
// H7GFxQuickBar
//
// Wrapper for H7GFxSpellbook.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxQuickBar extends H7GFxUIContainer
	dependson(H7StructsAndEnumsNative);

function SetSpellbookOpen(bool val)
{
	ActionscriptVoid("SetSpellbookOpen");
}

function Update( )
{
	ActionscriptVoid("Update");
}

function SelectSpell(int spellID)
{
	ActionscriptVoid("SelectSpell");
}

function UnSelectSpell()
{
	ActionscriptVoid("UnSelectSpell");
}

function PushDown(int slotIndex,optional bool val=true)
{
	ActionscriptVoid("PushDown");
}

function SetData(H7EditorHero hero, bool onCombatMap)
{
	local GFxObject data;

	data = CreateObject("Object");
	
	CreateScreenObject( hero, data, onCombatMap );
	SetObject( "mData" , data);

	Update();

	if(GetHud().GetHUDMode() == HM_NORMAL)
	{
		if(GetHud().IsA('H7AdventureHud') && H7AdventureHud(GetHud()).GetTownHudCntl().IsInAnyScreen()) return;
		SetVisibleSave(true);
	}
}

function CreateScreenObject( H7EditorHero hero , out GFxObject object, bool onCombatMap )
{
	
	local GFxObject spellListObject;
	local array<H7HeroAbility> spells;
	spells = hero.GetQuickBarSpells( onCombatMap );

	//`log_gui(hero @ "quickbar gets " @ spells.Length @ "spells");

	spellListObject = CreateArray();
	CreateSpellList( spells, spellListObject,,hero );
	
	
	/// basic localization + Text 
	object.SetBool("OnCombatMap", onCombatMap);
	object.SetObject( "SpellList" , spellListObject );
	object.SetInt( "CurrentHeroMana", hero.GetCurrentMana()  );
	object.SetInt( "MaxMana", hero.GetMaxMana() );
	//`log_gui("Quickbar" @ object @ spellListObject );

}

// OPTIONAL combine with spellbook
protected function CreateSpellList( array<H7HeroAbility> spells, out GfxObject object, optional int i, optional H7EditorHero caster )
{
	local GFxObject tempObj; 
	local H7HeroAbility spell;
	local string blockReason;
	
	for(i=0;i<spells.Length;i++) 
	{
		if(spells[i] != none)
		{
			spell = spells[i];
			tempObj = CreateObject( "Object" );
			tempObj.SetInt( "AbilityId", spell.GetID() );
			tempObj.SetBool( "IsCombatAbility", spell.IsCombatAbility());
			tempObj.SetBool( "IsActive", caster.HasBuffFromAbility( spell ));
			tempObj.SetBool( "DamageFilter", spell.IsDamageFilter() );
			tempObj.SetBool("UtilityFilter", spell.IsUtilityFilter());
			tempObj.SetString("School", String(spell.GetSchool()));
			tempObj.SetString ( "AbilityIconPath", spell.GetFlashIconPath() );
			tempObj.SetString ( "SchoolIconPath", spell.GetSchoolFlashPath(spell.GetSchool()) );
			if(caster == none)
			{
				tempObj.SetString ( "AbilityDesc", spell.GetTooltip() );
			}
			else
			{
				tempObj.SetString( "AbilityDesc", spell.GetTooltipForCaster(caster) );
			}
			tempObj.SetString( "AbilityName", spell.GetName() );
			tempObj.SetInt( "AbilityManaCost", spell.GetManaCost() );
			tempObj.SetBool( "AbilityCanCast", spell.CanCast(blockReason) );
			tempObj.SetString( "BlockReason", blockReason);
			tempObj.SetInt("PassedCooldown", spell.GetCooldownTimerCurrent());
			tempObj.SetInt("MaxCooldown", spell.GetCooldownTimer());
			if(caster.HasBuffFromAbility( spell ))
			{
				tempObj.SetString( "Note", "<font size='#TT_BODY#' color='#ff0000'>" $ class'H7Loca'.static.LocalizeSave("TT_ONLY_REFRESH","H7Abilities") $ "</font>");
			}
			object.SetElementObject(i, tempObj);
			;
		}
		else
		{
			;
		}
	}
}


// Default properties block
