//=============================================================================
// H7ICaster
//=============================================================================
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7ICaster
	extends H7IEventManagingObject
	dependson(H7StructsAndEnumsNative)
	native; // Not in Tussi header to avoid circular reference

function String                     GetName()										{}
native function H7AbilityManager	GetAbilityManager()								{}
native function H7BuffManager       GetBuffManager()                                {}
function H7EffectManager            GetEffectManager()								{}
native function H7EventManager      GetEventManager()                               {}
function                            DataChanged(optional String cause)				{}
native function EUnitType           GetEntityType()                                 {}
native function H7CombatArmy		GetCombatArmy()									{}

function                            PrepareAbility(H7BaseAbility ability)			{}
function                            UsePreparedAbility(H7IEffectTargetable target)  {}
function H7BaseAbility              GetPreparedAbility()                            {}
function ECommandTag                GetActionID( H7BaseAbility ability )            {}
native function bool                IsDefaultAttackActive()                         {}
native function Vector              GetLocation()                                   {}
native function IntPoint            GetGridPosition()                               {}
native function H7Player            GetPlayer()                                     {}

native function H7ICaster           GetOriginal()                                   {}

function float GetMinimumDamage(){	}
function float GetMaximumDamage(){	}
function int GetAttack(){}
native function int GetLuckDestiny(){  }
function int GetMagic(){   }
function int GetStackSize(){    }
function EAbilitySchool GetSchool() {  }

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) {}
