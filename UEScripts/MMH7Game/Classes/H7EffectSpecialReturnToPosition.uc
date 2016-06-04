//=============================================================================
// H7EffectSpecialReturnToPosition
//
// Enable scouting for an adventure hero.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialReturnToPosition extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var(ReturnToPosition) protected bool mRestoreRotation<DisplayName=Restore Rotation From Beginning of Turn>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7BaseCell> inversePath, lastPath;
	local int i;
	local H7Unit unit;
	local H7ICaster caster;
	local H7EventContainerStruct container2;
	local H7CombatMapCell currentCell;
	local H7Command delayedMoveCommand;

	if( isSimulated ) 
	{
		return;
	}

	container2 = effect.GetEventContainer();
	if( H7BaseAbility( container.EffectContainer ) != none )
		container2.ActionTag = H7BaseAbility( container.EffectContainer ).GetTags();
	else if( H7BaseBuff( container.EffectContainer ) != none )
		container2.ActionTag = H7BaseBuff( container.EffectContainer ).GetTags();
	else
		container2.ActionTag = effect.GetTags();

	effect.SetEventContainer( container2 );
	
	caster = effect.GetSource().GetCasterOriginal();
	unit = H7Unit( caster );

	lastPath = unit.GetLastWalkedPath();
	if( lastPath.Length == 0 ) return;

	if( H7CreatureStack( unit ) != none )
	{
		if( H7CreatureStack( unit ).IsDead() || H7CreatureStack( unit ).GetCreature().GetAnimControl().IsDying() )
		{
			// no return for dead guys (in case caster died by Retaliation)
			return;
		}

		currentCell = H7CreatureStack( unit ).GetCell();
	}
	
	if( unit != none && effect.AttackConditionCheck() )
	{
		if( !CheckPlaceability( lastPath[0], caster ) )
		{
			// for some reason, the original cell is blocked. since this
			// is creepy as fuck, let's just forget about the whole thing and stay here...
			return;
		}
		for( i = lastPath.Length - 1; i >= 0; --i )
		{
			inversePath.AddItem( lastPath[i] );
		}

		delayedMoveCommand = class'H7Command'.static.CreateCommand( unit, UC_MOVE, ACTION_MOVE,,,inversePath, false,,,false );
	}

	if( currentCell != none && delayedMoveCommand != none )
	{
		H7CreatureStack( unit ).SetDelayedCommand( delayedMoveCommand );
		if( mRestoreRotation ) H7CreatureStack( unit ).DoRestoreRotationAfterTurn();
		H7CreatureStack( unit ).SetStrikeAndReturnCell(currentCell);
	}
}

function bool CheckPlaceability( H7BaseCell cell, H7ICaster caster )
{
	local H7CreatureStack stack;

	if( cell == none ) return false; // don't place on none (wat)
	if( caster == none ) return false; // no source, no caster, no return to position

	stack = H7CreatureStack( caster );
	if( stack == none ) return false; // if we have warunits or obstacles that do strike and return, PLEASE KILL ME (srsly)

	if( class'H7CombatMapGridController'.static.GetInstance().CanPlaceCreature( cell.GetGridPosition(), stack ) )
	{
		// YAY let's go home!!
		return true;
	}

	// meh
	return false;
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_STRIKE_AND_RETURN","H7TooltipReplacement");
}

