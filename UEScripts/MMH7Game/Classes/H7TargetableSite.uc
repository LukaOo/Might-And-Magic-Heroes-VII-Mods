/*=============================================================================
 * H7TargetableSite
 * ============================================================================
 * A site that can be targeted with a spell (and does nothing else).
 * It is used to be able to trigger kismet events after it was hit by a spell.
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/
class H7TargetableSite extends H7AdventureObject implements (H7IEffectTargetable)
	perobjectconfig
	placeable
	native;

var protected savegame bool mFetchedID;
var protected savegame H7AbilityManager mAbilityManager;
var protected savegame H7BuffManager mBuffManager;
var protected H7EventManager mEventManager;
var protected H7EffectManager mEffectManager;

/** The ingame name of this targetable site */
var(Properties) protected localized string mName<DisplayName="Name">;
var protected string mNameInst;

/* ===================================
 * H7IEffectTargetable implementations
 * ===================================*/

native function int GetID();

function int GetQuestTargetID() 
{
	if(!mFetchedID && !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
		mFetchedID = true;
	}
	return mID; 
}

event InitAdventureObject()
{
	super.InitAdventureObject();
	InitTargetableSite();

	mEventManager = new(self) class 'H7EventManager';
	mEffectManager.Init(self);
}

function InitTargetableSite()
{
	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mAbilityManager = new class'H7AbilityManager';
		mAbilityManager.SetOwner( self );
		mBuffManager = new class'H7BuffManager';
		mBuffManager.Init( self );
	}
}

function string GetName()
{
	if(class'H7GameUtility'.static.IsArchetype(self))
	{
		LocalizeName();
		return mNameInst;
	}
	else
	{
		return H7TargetableSite(ObjectArchetype).GetName();
	}
}

function LocalizeName()
{ 
	if(mNameInst == "") 
	{
		mNameInst = class'H7Loca'.static.LocalizeContent(self, "mName", mName);
	}
}

native function H7AbilityManager GetAbilityManager();

native function H7BuffManager GetBuffManager();

native function H7EventManager GetEventManager();

function H7EffectManager GetEffectManager()
{
	if(mEffectManager == none)
	{
		mEffectManager = new class 'H7EffectManager';
		mEffectManager.Init(self);
	}
	return mEffectManager;
}

function IntPoint GetGridPosition() 
{ 
	return class'H7AdventureGridManager'.static.GetInstance().GetClosestGridToPosition(Location).GetCellByWorldLocation(Location).GetGridPosition();
}

native function EUnitType GetEntityType();

native function H7Player GetPlayer();

native function float GetResistanceModifierFor(EAbilitySchool school, array<ESpellTag> tags, optional bool checkOnlyBuffs = false); // { return 1; }

simulated function ApplyDamage(H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container){}


function int GetStackSize()  {} 
function int GetHitPoints()  {}

// Game Object needs to know what to do when its data changes (usually they just call ListeningManager)
function DataChanged(optional String cause)
{
	;
	class'H7ListeningManager'.static.GetInstance().DataChanged(self);
}

