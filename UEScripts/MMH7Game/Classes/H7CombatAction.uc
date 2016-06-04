//=============================================================================
// H7CombatAction
//=============================================================================
// Input object for GameProcessor to setup all parameters.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatAction extends Object
	dependson(H7StructsAndEnumsNative)
	dependsOn(H7Unit)
	native;


// attacker
var protected H7ICaster			                mAttackerUnit;

// defender object(s)
var protected array<H7IEffectTargetable>		mDefenders;

// base damage from caster (without targets)
var protected H7RangeValue				        mBaseDamageRange;

// action to handle
var protected ECommandTag				        mAction;
var protected array<H7Effect>                   mEffects;
var protected H7Effect                          mCurrentProcessedEffect;

// only GUI tooltip relevant, to display name
var protected H7EffectContainer                 mContainer; // ability/spell with which to attack

function H7ICaster       	            GetAttacker()										{ return mAttackerUnit; }

native function H7IEffectTargetable	    GetDefender( optional int idx );				

function array<H7IEffectTargetable>     GetDefenders()                                      { return mDefenders; }
function					            SetActionId(ECommandTag action)					    { mAction = action; }
function ECommandTag		            GetActionId()										{ return mAction; }
function int				            GetDefenderCount()									{ return mDefenders.Length; }

function H7RangeValue		            GetBaseDamageRange()								{ return mBaseDamageRange; }
function					            SetBaseDamageRange( H7RangeValue damager )    	    { mBaseDamageRange = damager;}

function H7Effect                       GetCurrentEffect()                                  { return mCurrentProcessedEffect; }
function                                SetCurrentEffect( H7Effect effect )                 { mCurrentProcessedEffect = effect; }
function                                SetEffects( array<H7Effect> effects)                { mEffects = effects; }
function array<H7Effect>                GetEffects()                                        { return mEffects; }
function H7Effect                       GetFirstEffect()                                    { if(mEffects.Length > 0) return mEffects[0]; else return none; }
function H7EffectContainer              GetContainer()                                      { return mContainer; }
function                                SetContainer(H7EffectContainer container)           { mContainer = container;}
function								SetAttacker( H7ICaster attacker )				    { mAttackerUnit = attacker; }

// setting the defending unit
function AddDefender( H7IEffectTargetable defender, optional bool resetPool, optional bool multipleInsert = false  )
{
	if( resetPool )
	{
		mDefenders.Length = 0;
	}

	if( defender == None ) return;

	if( !multipleInsert && mDefenders.Find(defender) != -1 ) return;

	mDefenders.AddItem(defender);
}

function DebugLogSelf(optional bool showForEventHandlingLogs = false)
{
	local H7IEffectTargetable defender;
	local int defnum;

	;
	;
	if( mAttackerUnit != None )
	{
		;
	}
	else
	{
		;
	}

	defnum=0;

	if( mDefenders.Length > 0 )
	{
		foreach mDefenders(defender)
		{
			if( defender != None )
			{
				defnum++;
				;
			}
		}
	}
	if( defnum==0 )
	{
		;
	}
}

function Reset()
{
	mAttackerUnit = none;
	mDefenders.Length = 0;
	mContainer = none;
}
