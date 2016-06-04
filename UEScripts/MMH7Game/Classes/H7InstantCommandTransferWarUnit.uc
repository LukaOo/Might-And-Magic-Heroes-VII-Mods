//=============================================================================
// H7InstantCommandSplitCreatureStack
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandTransferWarUnit extends H7InstantCommandBase;

var private H7AdventureArmy mArmy1;
var private H7AdventureArmy mArmy2;
var private EWarUnitClass mDragSlotClass;
var private int mDragSlotArmyID;
var private EWarUnitClass mDropSlotClass;

function Init( H7AdventureArmy army1, H7AdventureArmy army2, EWarUnitClass dragSlotClass, int dragSlotArmyID, EWarUnitClass dropSlotClass )
{
	mArmy1 = army1;
	mArmy2 = army2;
	mDragSlotClass = dragSlotClass;
	mDragSlotArmyID = dragSlotArmyID;
	mDropSlotClass = dropSlotClass;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mArmy1 = H7AdventureHero(eventManageable).GetAdventureArmy();
	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[1] );
	mArmy2 = H7AdventureHero(eventManageable).GetAdventureArmy();
	mDragSlotClass = EWarUnitClass(command.IntParameters[2]);
	mDragSlotArmyID = command.IntParameters[3];
	mDropSlotClass = EWarUnitClass(command.IntParameters[4]);
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	
	command.Type = ICT_TRANSFER_WAR_UNIT;
	command.IntParameters[0] = mArmy1.GetHero().GetID();
	command.IntParameters[1] = mArmy2.GetHero().GetID();
	command.IntParameters[2] = mDragSlotClass;
	command.IntParameters[3] = mDragSlotArmyID;
	command.IntParameters[4] = mDropSlotClass;

	return command;
}

function Execute()
{
	local array<H7EditorWarUnit> sourceWarUnits, targetWarUnits;
	local H7EditorArmy sourceArmy, targetArmy;
	local H7EditorWarUnit sourceWarUnit, targetWarUnit;
	local H7EditorWarUnit unit;
	local H7AdventureHud hud;
	
	if(mDragSlotArmyID == mArmy1.GetHero().GetID()) 
	{ 
		sourceWarUnit = mArmy1.GetWarUnitByType(mDragSlotClass); 
		sourceArmy = mArmy1;
		sourceWarUnits = mArmy1.GetWarUnitTemplates();
		targetArmy = mArmy2;
		targetWarUnits = mArmy2.GetWarUnitTemplates();
		if(mDropSlotClass >= 0) targetWarUnit = mArmy2.GetWarUnitByType(mDropSlotClass);
	}
	else
	{ 
		sourceWarUnit = mArmy2.GetWarUnitByType(mDragSlotClass); 
		sourceArmy = mArmy2;
		sourceWarUnits = mArmy2.GetWarUnitTemplates();
		targetArmy = mArmy1;
		targetWarUnits = mArmy1.GetWarUnitTemplates();
		if(mDropSlotClass >= 0) targetWarUnit = mArmy1.GetWarUnitByType(mDropSlotClass); 
	}

	targetArmy.AddWarUnit(sourceWarUnit);
	sourceArmy.RemoveWarUnit(sourceWarUnit);

	if(targetWarUnit!=none)
	{
		;
		sourceArmy.AddWarUnit(targetWarUnit);
		targetArmy.RemoveWarUnit(targetWarUnit);

		if(mDragSlotClass == WCLASS_HYBRID)
		{
			;
			targetWarUnits = targetArmy.GetWarUnitTemplates();
			foreach targetWarUnits(unit)
			{
				if(unit.GetWarUnitClass() != WCLASS_SIEGE && unit.GetWarUnitClass() != mDragSlotClass)
				{
					;
					targetArmy.RemoveWarUnit(unit);
					sourceArmy.AddWarUnit(unit);
				}
			}
		}
			
		if(mDropSlotClass == WCLASS_HYBRID)
		{
			;
			sourceWarUnits = sourceArmy.GetWarUnitTemplates();
			foreach sourceWarUnits(unit)
			{
				if(unit.GetWarUnitClass() != WCLASS_SIEGE && unit.GetWarUnitClass() != sourceWarUnit.GetWarUnitClass() && unit.GetWarUnitClass()!=WCLASS_HYBRID)
				{
					;
					sourceArmy.RemoveWarUnit(unit);
					targetArmy.AddWarUnit(unit);
				}
			}
		}
	}
	else if(mDragSlotClass == WCLASS_HYBRID)
	{       
		;
		targetWarUnits = targetArmy.GetWarUnitTemplates();
		foreach targetWarUnits(unit)
		{
			if(unit.GetWarUnitClass() != WCLASS_SIEGE && unit.GetWarUnitClass() != mDragSlotClass)
			{
				;
				targetArmy.RemoveWarUnit(unit);
				sourceArmy.AddWarUnit(unit);
			}
		}
	}

	if(mArmy1.GetPlayer().IsControlledByLocalPlayer() || mArmy2.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetHeroTradeWindowCntl().GetPopup().IsVisible())
		{
			hud.GetHeroTradeWindowCntl().RequestWarfareUnitTransferComplete();
		}
	}
}

/**
 * Sim Turns:
 * Determines if this instant command waits for ongoing move/startCombat commands in the area of the command location
 */
function bool WaitForInterceptingCommands()
{
	return true;
}

/**
 * Sim Turns:
 * used to check for intersection with ongoing move commands
 */
function Vector GetInterceptLocation()
{
	return mArmy1.GetHero().GetLocation();
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mArmy1.GetPlayer();
}
