//=============================================================================
// H7CheatData
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CheatData extends Object;


var(Spells) array<SpellListData> Spells<DisplayName=All Available Spells>;
var(Skills) array<SkillListData> Skills<DisplayName=All Available Skills>;

/**
 *  Returns a List of all spall names 
 * */
function array<string> GetSpellNames()
{
	local int i;
	local array<string> names;

	for( i=0; i<Spells.Length; ++i )
	{
		names.AddItem( Spells[i].name);
	}

	return names;
}

/**
 *  Returns a List of all spall names 
 * */
function array<string> GetSkillNames()
{
	local int i;
	local array<string> names;

	for( i=0; i<Skills.Length; ++i )
	{
		names.AddItem( Skills[i].name);
	}

	return names;
}
/**
 *  Returns the HeroAbility(Spell) or none if it cant be found by name
 **/
function H7HeroAbility GetSpellByName( string spellName )
{
	local string ref;

	ref =  GetSpellRefByName( spellName );

	if( ref == "none" )
		return none;

	return H7HeroAbility(DynamicLoadObject(ref, class'H7HeroAbility' ));
}

/**
 *  Returns the HeroAbility(Spell) or none if it cant be found by name
 **/
function H7Skill GetSkillByName( string skillname )
{
	local string ref;

	ref =  GetSkillRefByName( skillname );

	if( ref == "none" )
		return none;

	return  H7Skill(DynamicLoadObject(ref, class'H7Skill' ));
}

/**
 *  Returns the Archetype ref or "none" as a String
 * */
function string GetSpellRefByName( string spellName ) 
{
	local int i;

	for(i=0; i<Spells.Length; ++i)
	{
		if( Spells[i].name == spellName )
			return Spells[i].ref;
	}
	
	return "none";
}

/**
 *  Returns the Archetype ref or "none" as a String
 * */
function string GetSkillRefByName( string skillname ) 
{
	local int i;

	for(i=0; i<Skills.Length; ++i)
	{
		if( Skills[i].name == skillname )
			return Skills[i].ref;
	}
	
	return "none";
}
