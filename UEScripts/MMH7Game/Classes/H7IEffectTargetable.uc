//=============================================================================
// H7IEffectTargetable
//=============================================================================
//
// They need to be registered/unregistered after getting the Id with the following line:
// class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self );
// class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( self );
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IEffectTargetable
	extends H7IEventManagingObject
	dependson(H7StructsAndEnumsNative)
	native; // Not in Tussi header to avoid circular reference

function String                     GetName()                               {}
native function H7AbilityManager	GetAbilityManager()				        {}
native function H7BuffManager		GetBuffManager()				        {}
native function H7EventManager      GetEventManager()                       {}
function H7EffectManager            GetEffectManager()                      {}
function IntPoint                   GetGridPosition()                       {}
function                            DataChanged(optional String cause)      {}
function int                        GetStackSize()                          {} 
function int                        GetHitPoints()                          {}

native function EUnitType           GetEntityType()                         {}
native function H7Player            GetPlayer()                             {}
native function float               GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false)   {}


simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}
function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) {}
