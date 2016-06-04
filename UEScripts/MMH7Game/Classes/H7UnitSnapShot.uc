//=============================================================================
// H7UnitSnapShot
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7UnitSnapShot extends Object implements(H7ICaster)
	native(Tussi)
	savegame;

var protected savegame int mDamageMin;
var protected savegame int mDamageMax;
var protected savegame int mAttack;
var protected savegame int mLuckDestiny;
var protected savegame int mMagic;
var protected savegame int mStackSize;
var protected savegame int mMoraleLeadership;
var protected savegame EAbilitySchool mSchool;

var protected H7ICaster mCasterOriginal;

function float						GetMinimumDamage()									{ return mDamageMin; }
function float						GetMaximumDamage()									{ return mDamageMax; }
function int						GetAttack()											{ return mAttack; }
function int						GetLeadership()										{ return mMoraleLeadership; }
function int						GetMagic()											{ return mMagic; }
function int						GetStackSize()										{ return mStackSize; }
function EAbilitySchool	            GetSchool()											{ return mSchool; }

// ---- debug functions ----
//function int						GetMinimumDamage()									{ return mCasterOriginal.GetMinimumDamage(); }
//function int						GetMaximumDamage()									{ return mCasterOriginal.GetMaximumDamage(); }
//function int						GetAttack()											{ return mCasterOriginal.GetAttack(); }
//function int						GetLeadership()										{ if( H7Unit( mCasterOriginal ) != none ) return H7Unit( mCasterOriginal ).GetLeadership(); else return 1; }
//function int						GetMagic()											{ if( H7EditorHero( mCasterOriginal ) != none ) return H7EditorHero( mCasterOriginal ).GetMagic(); else return 1; }
//function int						GetStackSize()										{ return H7CreatureStack( mCasterOriginal ) != none ? H7CreatureStack( mCasterOriginal ).GetStackSize() : 1; }
//function EAbilitySchool	            GetSchool()											{ return mCasterOriginal.GetSchool(); }
// --------------------------

// redirects
function String	                    GetName()											{ return mCasterOriginal.GetName(); }
function bool	                    Is( Name myName )									{ return mCasterOriginal.IsA(myName); }
function H7EffectManager            GetEffectManager()									{ return mCasterOriginal.GetEffectManager(); }
native function H7EventManager      GetEventManager();
function                            DataChanged( optional String cause )				{ mCasterOriginal.DataChanged(cause); }

function                            PrepareAbility( H7BaseAbility ability )				{ mCasterOriginal.PrepareAbility(ability); }
function                            UsePreparedAbility( H7IEffectTargetable target )	{ mCasterOriginal.UsePreparedAbility(target); }
function H7BaseAbility              GetPreparedAbility()								{ return mCasterOriginal.GetPreparedAbility(); }
function ECommandTag                GetActionID( H7BaseAbility ability )				{ return mCasterOriginal.GetActionID(ability); }

native function H7ICaster	        GetOriginal();
native function int					GetLuckDestiny();
native function Vector              GetLocation();
native function IntPoint            GetGridPosition();
native function H7Player            GetPlayer();
native function H7AbilityManager	GetAbilityManager();
native function H7BuffManager		GetBuffManager();
native function EUnitType           GetEntityType();
native function H7CombatArmy        GetCombatArmy();
native function bool                IsDefaultAttackActive();
native function int					GetID();





function	                        TriggerEvents( ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container )
{
	mCasterOriginal.TriggerEvents(triggerEvent,forecast,container);
}

// used for casting from scrolls
function SetMagic( int magic ) 
{
	mMagic = magic;
}

function TakeSnapShot(H7ICaster unit)
{
	local H7Unit casterUnit;
	local H7EditorHero hero;
	local H7CreatureStack stack;
	local H7UnitSnapShot other;

	if(unit == none)
	{
		; 
		ScriptTrace();
	}

	// in case of bullshittery...
	if( H7UnitSnapShot( unit ) != none )
	{
		;
		other = H7UnitSnapShot( unit );
		mCasterOriginal = other.GetOriginal();
		mDamageMin = other.GetMinimumDamage();
		mDamageMax = other.GetMaximumDamage();

		mAttack = other.GetAttack();
		mLuckDestiny = other.GetLuckDestiny();
		mSchool = other.GetSchool();
		mMoraleLeadership = other.GetLeadership();

		mMagic = other.GetMagic();
		mStackSize = other.GetStackSize();
		return;
	}

	mCasterOriginal = unit;

	casterUnit = H7Unit( unit );

	if( casterUnit == none ) return;

	//casterUnit.ClearStatCache();

	if( H7WarUnit( casterUnit ) != none )
	{
		mDamageMin = 1;
		mDamageMax = 1;
	}
	else
	{
		mDamageMin = casterUnit.GetMinimumDamage();
		mDamageMax = casterUnit.GetMaximumDamage();
	}
	mAttack = casterUnit.GetAttack();
	mLuckDestiny = casterUnit.GetLuckDestiny();
	mSchool = casterUnit.GetSchool();
	mMoraleLeadership = casterUnit.GetLeadership();

	hero = H7EditorHero(casterUnit);
	if(hero != none)
	{
		mMagic = hero.GetMagic();
	}
	else
	{
		mMagic = 1;
	}

	stack = H7CreatureStack(casterUnit);
	if(stack != none)
	{
		mStackSize = stack.GetStackSize();
	}
	else
	{
		mStackSize = 1;
	}
}

function UpdateSnapShot(optional bool updateLuck = true, optional bool updateLeadership = true, optional bool clearCache = false)
{
	local H7Unit casterUnit;
	local H7EditorHero hero;
	local H7CreatureStack stack;
	
	casterUnit = H7Unit( mCasterOriginal );
	if( casterUnit == none ) return;

	if( clearCache ) casterUnit.ClearStatCache();

	if( H7WarUnit( casterUnit ) != none )
	{
		mDamageMin = 1;
		mDamageMax = 1;
	}
	else
	{
		mDamageMin = casterUnit.GetMinimumDamage();
		mDamageMax = casterUnit.GetMaximumDamage();
	}
	mAttack = casterUnit.GetAttack();
	mSchool = casterUnit.GetSchool();

	if( updateLeadership)
		mMoraleLeadership = casterUnit.GetLeadership();

	if( updateLuck )
		mLuckDestiny = casterUnit.GetLuckDestiny();

	hero = H7EditorHero(casterUnit);
	if(hero != none)
	{
		mMagic = hero.GetMagic();
	}
	else
	{
		mMagic = 1;
	}

	stack = H7CreatureStack(casterUnit);
	if(stack != none)
	{
		mStackSize = stack.GetStackSize();
	}
	else
	{
		mStackSize = 1;
	}
}
