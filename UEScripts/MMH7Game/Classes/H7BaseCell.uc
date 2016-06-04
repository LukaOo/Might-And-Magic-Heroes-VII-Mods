//=============================================================================
// H7BaseCell
//=============================================================================
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BaseCell extends Object
	implements ( H7IEffectTargetable, H7ICaster )
	native;

// size of the cell, width and height are equal (must be the same value as the decal width/height)
// must be the same as CELL_SIZE in H7EditorMapGrid
const CELL_SIZE = 192.0f;

var() IntPoint mPosition;
var protected Vector mWorldCenter;
var protected Vector mWorldCenterOrig;
var protected Rotator mRotation;
var protected int mID;
var protected array<H7BaseAbility> mAuraAbilities;

// function from H7IEffectTargetable
function String                     GetName()                               { return "Cell at"@mPosition.X@mPosition.Y; }
native function H7AbilityManager	GetAbilityManager();
native function H7BuffManager		GetBuffManager();
native function H7EventManager      GetEventManager();
function H7EffectManager            GetEffectManager()                      { return none; }
native function H7CombatArmy        GetCombatArmy();

function                            DataChanged(optional String cause)      { }
native function int					GetID();
native function EUnitType  			GetEntityType();
native function H7Player            GetPlayer();
native function float               GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);

function                            PrepareAbility(H7BaseAbility ability)			{}
function                            UsePreparedAbility(H7IEffectTargetable target)  {}
function H7BaseAbility              GetPreparedAbility()                            { return none; }
function ECommandTag                GetActionID( H7BaseAbility ability )            { return ACTION_ABILITY; }
native function bool                IsDefaultAttackActive();
native function IntPoint            GetGridPosition();
native function H7ICaster           GetOriginal();
native function RemoveAuraAbility( H7BaseAbility ability );
native function AddAuraAbility( H7BaseAbility ability );

function bool HasAuras() { return mAuraAbilities.Length > 0; }
function array<H7BaseAbility> GetAuras() { return mAuraAbilities; }

function float GetMinimumDamage(){	return 0;}
function float GetMaximumDamage(){	return 0;}
function int GetAttack(){	return 0;}
native function int GetLuckDestiny(); //{  return 0;}
function int GetMagic(){    return 0;}
function int GetStackSize(){    return 1;}
function EAbilitySchool GetSchool() { return ABILITY_SCHOOL_NONE; }
function int GetHitPoints()  {}

simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}

function IntPoint GetCellPosition() { return mPosition; }
function SetCellPosition( int X, int Y) { mPosition.X = X; mPosition.Y = Y; }

// override in children
function H7IEffectTargetable GetTargetable()
{
	
}

native function Vector GetLocation();
function Rotator GetRotation() { return mRotation; }
function SetLocation( Vector newLocation ) { mWorldCenter = newLocation; }
function SetRotation( Rotator newRotation ) { mRotation = newRotation; }

function Vector GetOriginalLocation() { return mWorldCenterOrig; }
function SetOriginalLocation( Vector newLocation ) { mWorldCenterOrig = newLocation; }

// returns the center of the (theoretical) merged cell, as if there were a creature with this size 
function Vector GetCenterByCreatureDim(int creatureDim)
{
	local Vector center;
	center = mWorldCenter;
	center.X += (creatureDim-1)*CELL_SIZE/2;
	center.Y += (creatureDim-1)*CELL_SIZE/2;
	return center;
}

function Vector GetCenterPosByDimensions( IntPoint dim )
{
	local Vector center;
	center = mWorldCenter;
	center.X += (dim.X-1)*CELL_SIZE/2;
	center.Y += (dim.Y-1)*CELL_SIZE/2;
	return center;
}

function TriggerEvents (ETrigger trigger, bool simulate, optional H7EventContainerStruct container)
{
	GetEventManager().Raise(trigger, simulate, container);
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
