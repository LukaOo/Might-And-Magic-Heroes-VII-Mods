//=============================================================================
// H7GfxDamageTooltipSystem
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxDamageTooltipSystem extends GFxClikWidget
	dependson(H7StructsAndEnumsNative);

var protected int mRightMouseDownSince;
var protected bool mFlashShowsBar;
var protected bool mVisible;

function bool ShowAbilityPreview( H7CombatResult result )
{
	local int i;
	local GFxObject dataProvider,TempObj;
	local H7IEffectTargetable target;
	local array<H7Effect> effects;
	local H7Effect effect;
	local bool showsSomething,somebodyShowsSomething;

	;

	if(result == none)
	{
		ShowTooltip(false);
		return false;
	}

	;

	if(result.GetDefenderCount() == 0) // why is a result with 0 defender arriving here anyway, check who sends it
	{
		ShowTooltip(false);
		return false;
	}
	
	dataProvider = CreateArray();
	
	for( i=0; i<result.GetDefenderCount(); ++i )
	{
		//--
		effects = result.GetTriggeredEffects(i);
		foreach effects(effect)
		{
			;
		}
		//--

		target = result.GetDefender( i );
		
		if( target.IsA('H7CreatureStack') || target.IsA('H7CombatObstacleObject') || target.IsA('H7WarUnit'))
		{
			TempObj = CreateObject("Object");

			// Damage & other Effects done onto this unit
			showsSomething = AddDamageAndEffectParameters( TempObj , result , i);

			if(!showsSomething)
			{
				continue;
			}

			somebodyShowsSomething = true;

			TempObj.SetString( "UnitName", target.GetName() );
			if(target.IsA('H7CreatureStack')) 
			{
				TempObj.SetInt( "StackSize", H7CreatureStack(target).GetStackSize() );
			}
		
			// special displays:
			// flanking is standard modifiers, but gets special display
			TempObj.SetString("FlankingType", String(result.GetFlankingType(i)));
			// cover
			TempObj.SetBool( "IsCovered", result.IsCovered() ); 
			// retaliate
			if(target.IsA('H7CreatureStack')) 
			{
				TempObj.SetBool("DisplayRetaliate", result.ShowRetaliationLine(i) );
				TempObj.SetBool("Retaliate", WillRetaliate(result,i) );
			}
		
			// modifier detail list & triggered effects (chain reactions) list
			if(ShowExtentedTooltip())
			{
				TempObj.SetObject( "ModList", CreateModListObject(result,i) );
				TempObj.SetObject( "EffectList", CreateTriggeredEffectListObject(result,i) );
			}
		
			
		}
		else if( target.IsA( 'H7CombatMapCell' ) )
		{
			continue;
		}
		else
		{
			TempObj = CreateObject("Object");
			;
		}

		dataProvider.SetElementObject( i, TempObj );
	}

	result.SetShowsSomething(somebodyShowsSomething);

	if(!somebodyShowsSomething)
	{
		;
		ShowTooltip(false);
		return false;
	}	

	SetBool("mHasModifiers",HasModifiers(result));
	SetString("mType",  "spellAttack" );
	SetObject( "mData" , dataProvider);

	Update();

	return true;
}

function bool WillRetaliate( H7CombatResult result,int defenderIndex )
{
	local bool willRetaliate;
	local H7IEffectTargetable defender;

	if( result.HasRetaliationSuppressEffect( defenderIndex ) ) return false;

	defender = result.GetDefender( defenderIndex );
	willRetaliate = result.HasTriggeredEffectFromSource(H7CreatureStack(defender).GetRetaliationAbility(),defenderIndex);

	return willRetaliate;
}


// NOTE: currently not used
// TODO should work with CombatResult
function ShowDeadTooltip(H7CreatureStack stack)
{
	local GFxObject dataProvider,TempObj;
	local Color unrealColor;
	dataProvider = CreateArray();

	TempObj = CreateObject("Object");
	TempObj.SetString("UnitName", stack.GetCreature().GetName());
	TempObj.SetString("IconPath", stack.GetCreature().GetFlashIconPath());
	TempObj.SetInt("originalSize", stack.GetInitialStackSize());
	TempObj.SetBool("resurrectable", stack.GetCreature().IsResurrectable());
	TempObj.SetString( "PlayerName", stack.GetCombatArmy().GetPlayer().GetName() );
	unrealColor = stack.GetCombatArmy().GetPlayer().GetColor();
	TempObj.SetInt("r",unrealColor.R);
	TempObj.SetInt("g",unrealColor.G);
	TempObj.SetInt("b",unrealColor.B);
	dataProvider.SetElementObject(0, TempObj);
	
	SetString( "mType", "deadTooltip");
	SetObject( "mData", dataProvider);

	Update();
}






///////////////////////////////////////////////////////////////
// HELPER /////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////





function CorrectPlacement()
{
	Actionscriptvoid("CorrectPlacement");
}

function int GetExtendDelayTimeMS() 
{
	return 500;
}

function SwitchToAppropiateState()
{
	if(mVisible)
	{
		ShowAbilityPreview( class'H7CombatController'.static.GetInstance().GetCursor().GetLastResult() );
	}
}

function bool ShowExtentedTooltip()
{
	local int timeNow,timeDown;

	if(class'H7PlayerController'.static.GetPlayerController().GetHud().GetRightMouseDown())
	{
		timeNow = class'H7PlayerController'.static.GetPlayerController().GetHud().GetPlayTime();
		timeDown = class'H7PlayerController'.static.GetPlayerController().GetHud().GetRightMouseDownSince();
		if(timeNow - GetExtendDelayTimeMS() > timeDown)
		{
			return true;
		}
		// not yet time, but show some signs and feedback:
		if(!mFlashShowsBar)
		{
			mFlashShowsBar = true;
			ActionScriptVoid("WaitingToExtend");
		}
	}
	else
	{
		mFlashShowsBar = false;
		ActionScriptVoid("StopBar");
	}
	return false;
}

function bool HasModifiers(H7CombatResult result)
{
	local array<H7TooltipMultiplier> mods;
	local int i;
	for( i = 0; i < result.GetDefenderCount(); i++ )
	{
		mods = result.GetMultipliers(i);
		if(mods.Length > 0) return true;
	}
	return false;
}

function GFxObject CreateTriggeredEffectListObject(H7CombatResult result,optional int idx)
{
	local GFxObject effectList,effectObject;
	local int i;
	local array<H7Effect> effects;
	local H7Effect effect;

	effects = result.GetTriggeredEffects(idx);
	effectList = CreateArray();
	i = 0;

	if(!class'H7GUIGeneralProperties'.static.GetInstance().GetOptionDamageTooltipEffectsEnabled()) return effectList; // empty list

	foreach effects(effect)
	{
		;
		effectObject = CreateObject("Object");
		effectObject.SetString("Desc",effect.GetTooltipLine(false,none,false,true));

		effectList.SetElementObject(i,effectObject);
		i++;
	}

	return effectList;
}

function GFxObject CreateModListObject(H7CombatResult result,optional int idx)
{
	local GFxObject modList,modObject;
	local int i;
	local array<H7TooltipMultiplier> mods;
	local H7TooltipMultiplier mod;

	mods = result.GetMultipliers(idx);
	modList = CreateArray();
	i = 0;

	foreach mods(mod)
	{
		modObject = CreateObject("Object");
		modObject.SetString("Name",mod.name);
		modObject.SetFloat("Value",mod.value);

		modList.SetElementObject(i,modObject);
		i++;
	}

	return modList;
}

function bool AddDamageAndEffectParameters(out GFxObject TempObj , H7CombatResult result , int i,optional bool forceDamageShow=false)
{
	local array<H7Effect> effects;
	local H7Effect effect;
	local GFxObject effectLines;
	local int effectNr;
	local H7BaseAbility ability;
	local String attackName;
	local EFlankingType flankingType;

	effectLines = CreateArray();
	effectNr = 0;

	// special hack to move effect from chain reaction list to primary list
	effects = result.GetTriggeredEffects( i );
	foreach effects( effect )
	{
		if(effect.IsA('H7EffectDamage') && H7EffectDamage( effect ).GetData().mUseMagicAbs)
		{
			;
			effectLines.SetElementString(effectNr,effect.GetTooltipLine(false,result.GetDefender(i)));
			effectNr++;
		}
	}

	// primary effects
	effects = result.GetTooltipEffects(i);
	foreach effects(effect)
	{
		if(effect.IsA('H7EffectDamage'))
		{
			if( H7EffectDamage( effect ).GetData().mUseMagicAbs )
			{
				continue;
			}
			;
			forceDamageShow = true;
		} 
		else if(class'H7GUIGeneralProperties'.static.GetInstance().GetOptionDamageTooltipEffectsEnabled())
		{
			;
			effectLines.SetElementString(effectNr,effect.GetTooltipLine(false,result.GetDefender(i)));
			effectNr++;
		}
	}

	if(forceDamageShow) // if there is a damage-effect or we forced it
	{
		;
		// Damage
		TempObj.SetFloat( "FinalMultiplier", result.GetFinalDamageModifier(i) );

		TempObj.SetString( "SchoolIcon", class'H7EffectContainer'.static.GetSchoolFlashPath( result.GetDamageSchool(i) ) );
		TempObj.SetString( "SchoolDamageName", class'H7EffectContainer'.static.GetSchoolDamageName( result.GetDamageSchool(i) ) );
		TempObj.SetString( "SchoolColor", class'H7EffectContainer'.static.GetSchoolColor( result.GetDamageSchool(i) ) );

		TempObj.SetBool( "ShowDamage",true );
		TempObj.SetInt( "DamageMin", result.GetDamageLow(i) );
		TempObj.SetInt( "DamageMax", result.GetDamageHigh(i) );
		TempObj.SetInt( "KillsMin", result.GetKillsLow(i) );
		TempObj.SetInt( "KillsMax", result.GetKillsHigh(i) );
	}
	else
	{
		;
	}

	// ============ Done Effects ==============

	TempObj.SetObject( "EffectLines", effectLines ); // i.e. add buff haste

	if(result.IsHeal(i))
	{
		TempObj.SetBool( "Heal", true );
	}

	// ============ AttackName ==============
	
	if( result.GetContainer() != none
		&& ( H7BaseAbility(result.GetContainer()) != none && H7BaseBuff(result.GetContainer()) != none ) )
	{
		attackName = result.GetContainer().GetName();
	}
	else if(result.GetFirstEffect() != none)
	{
		ability = H7BaseAbility(result.GetFirstEffect().GetSource());
		attackName = ability.GetName();
	}
	else if(result.GetCurrentEffect() != none && result.GetCurrentEffect().GetSource() != none)
	{
		ability = H7BaseAbility(result.GetCurrentEffect().GetSource());
		attackName = ability.GetName();
	}
	else if( effects[0] != none && effects[0].GetSource() != none )
	{
		attackName = effects[0].GetSource().GetName();
	}
	else
	{
		attackName = "Unknown Attack";
	}

	flankingType = result.GetFlankingType(i);
	if(flankingType == FULL_FLANKING)
	{
		attackName = attackName @ "(" $ class'H7Loca'.static.LocalizeSave("FULL_FLANKING","H7Combat") $ ")";
	}
	else if(flankingType == FLANKING)
	{
		attackName = attackName @ "(" $ class'H7Loca'.static.LocalizeSave("FLANKING","H7Combat") $ ")";
	}
	
	TempObj.SetString( "AttackName", attackName );
	
	return effectNr > 0 || forceDamageShow;
}

function Update( ) 
{
	if(!IsAllowedToShow()) return;

	ActionscriptVoid("Update");
}

function bool IsAllowedToShow()
{
	// we hide the tooltip when clicking to cast, but the next frame(s) show it again, so all these frames need to be prevented from showing it with these checks
	if(!class'H7CombatController'.static.GetInstance().GetCommandQueue().IsEmpty())
	{
		;
		return false;
	}
	if(!class'H7CombatController'.static.GetInstance().GetCommandQueue().IsReadyToEndTurn())
	{
		;
		return false;
	}
	return true;
}

function ShowTooltip(optional bool val=true)
{
	if(!IsAllowedToShow()) return;

	//if(val)
	//{
	//	ScriptTrace();
	//}

	ActionScriptVoid("ShowTooltip");
	mVisible = val;
}

function bool IsVisible()
{
	return mVisible;
}
