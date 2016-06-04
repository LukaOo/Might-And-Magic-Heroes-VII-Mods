//=============================================================================
// H7GFxCreatureAbilityButtonPanel
//
// Wrapper for H7GFcCreatureAbilityButtonPanel.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxCreatureAbilityButtonPanel extends H7GFxUIContainer;

function SetData(array<H7BaseAbility> abilities,bool sameUnit=false)
{
	local GFxObject data, tempObj;
	local H7BaseAbility ability;
	local int i;
	local bool canCast;
	local String blockReason;
	//local string infoBox;

	i = 0;
	SelectAbilityButton(-1);

	//`log_gui("Button Panel SetData");

	data = CreateArray();
	
	foreach abilities(ability)
	{
		canCast = ability.CanCast(blockReason);
		//infoBox = `localize("H7Abilities","ACTION_ABILITY");

		tempObj = CreateObject("Object");
		tempObj.SetInt( "AbilityID", ability.GetID() );
		tempObj.SetString( "AbilityName", ability.GetName() ); 
		tempObj.SetString( "AbilityIcon", ability.GetFlashIconPath() ); // for creature ability icon in button panel
		tempObj.SetString( "AbilityIconPath", ability.GetFlashIconPath() ); // for creature ability icon in tooltip (using spell tooltip atm)
		//tempObj.SetString( "CasterRank" , infoBox );
		tempObj.SetString( "AbilityDesc", ability.GetTooltip() );
		tempObj.SetBool( "AbilityDefault", ability.HasTag(TAG_DAMAGE_DIRECT) );
		tempObj.SetString( "School", class'H7EffectContainer'.static.GetSchoolName( ability.GetSchool() ) );
		tempObj.SetString( "SchoolIconPath", class'H7EffectContainer'.static.GetSchoolFlashPath( ability.GetSchool() ) );
		
		// OPTIONAL give base ability one function that everybody uses?
		if(ability.IsA('H7CreatureAbility'))
		{
			tempObj.SetInt( "Charges", H7CreatureAbility(ability).GetNumCharges());
		}
		else if(ability.IsA('H7WarfareAbility'))
		{
			tempObj.SetInt( "Charges", 1); // H7WarfareAbility(ability).GetCurrentCharge());
		}
		else
		{
			tempObj.SetInt( "Charges", 1);
		}
		tempObj.SetBool( "CanCast", canCast );
		if(!canCast)
		{
			tempObj.SetString( "BlockReason", blockReason ); 
		}
		data.SetElementObject(i, tempObj);
		i++;
	}

	//even though a hero might be active, still call update to hide the ability buttons
	SetObject("mData", data);
	Update(sameUnit);
}

function Update(bool sameUnit=false)
{
	//return;
	ActionScriptVoid("Update");
}

function SelectAbilityButton(int id) // also deselects all != id // -1 to deselect all
{
	//return;
	ActionScriptVoid("SelectAbilityButton");
}

// block/unblock panel when AI,otherplayer is active
function EnableTurn( bool val )
{
	//return;
	ActionscriptVoid("EnableTurn");
}

// to hide the panel when combat ends
function Hide()
{
	//return;
	ActionScriptVoid("Hide");
}
