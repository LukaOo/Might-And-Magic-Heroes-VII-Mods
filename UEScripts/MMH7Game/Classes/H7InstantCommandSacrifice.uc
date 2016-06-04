//=============================================================================
// H7InstantCommandSacrifice
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandSacrifice extends H7InstantCommandBase;

var private H7Town mTown;
var private bool mFirstStackIsGarrison;
var array<int> mDraggedStackIndicesGarrison;
var array<int> mDraggedStackIndicesVisiting;

function Init( H7Town town, array<int> draggedStacksGarrison, array<int> draggedStacksVisiting, bool firstStackIsGarrison )
{
	mTown = town;
	mFirstStackIsGarrison = firstStackIsGarrison;
	mDraggedStackIndicesGarrison = draggedStacksGarrison;
	mDraggedStackIndicesVisiting = draggedStacksVisiting;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;
	local String garrisonString, visitingString;
	local array<string> garrisonSplitted, visitingSplitted;
	local int i;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );	
	mTown = H7Town(eventManageable);
	mFirstStackIsGarrison = bool(command.IntParameters[1]);

	garrisonString = Left(command.StringParameter, InStr(command.StringParameter, ";"));
	visitingString = Mid(command.StringParameter, InStr(command.StringParameter, ";") + 1);
	garrisonSplitted = SplitString(garrisonString, ",", true);
	visitingSplitted = SplitString(visitingString, ",", true);

	for(i=0; i<garrisonSplitted.Length; i++)
	{
		mDraggedStackIndicesGarrison.AddItem(int(garrisonSplitted[i]));
	}

	for(i=0; i<visitingSplitted.Length; i++)
	{
		mDraggedStackIndicesVisiting.AddItem(int(visitingSplitted[i]));
	}
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;
	local String IndicesString;
	local int i;

	command.Type = ICT_SACRIFICE;
	command.IntParameters[0] = mTown.GetID();
	command.IntParameters[1] = mFirstStackIsGarrison ? 1 : 0;

	for(i=0; i<mDraggedStackIndicesGarrison.Length; i++)
	{
		if(i!= 0)
		{
			IndicesString = IndicesString$",";
		}

		IndicesString = IndicesString$mDraggedStackIndicesGarrison[i];
	}

	IndicesString = IndicesString$";";

	for(i=0; i<mDraggedStackIndicesVisiting.Length; i++)
	{
		if(i!= 0)
		{
			IndicesString = IndicesString$",";
		}

		IndicesString = IndicesString$mDraggedStackIndicesVisiting[i];
	}

	command.StringParameter = IndicesString;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local int i;
	local array<H7BaseCreatureStack> stacks;
	local H7ResourceQuantity cost;
	local array<H7ResourceQuantity> costArray;
	local H7TownUnitConverter altarOfSacrifice;
	local H7BaseCreatureStack draggedStack;

	if(mFirstStackIsGarrison)
	{
		draggedStack = mTown.GetGarrisonArmy().GetBaseCreatureStacks()[mDraggedStackIndicesGarrison[0]];
	}
	else
	{
		draggedStack = mTown.GetVisitingArmy().GetBaseCreatureStacks()[mDraggedStackIndicesVisiting[0]];
	}

	altarOfSacrifice = H7TownUnitConverter( mTown.GetBuildingByType(class'H7TownUnitConverter'));
	cost.Type = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrencyResourceType();
	cost.Quantity =  altarOfSacrifice.GetConvertingCost(draggedStack);
	costArray.AddItem(cost);
	mTown.GetPlayer().GetResourceSet().SpendResources(costArray, true);

	//'delete' other stacks that have been merged into the sacrificed stack
	stacks = mTown.GetGarrisonArmy().GetBaseCreatureStacks();
	i = mFirstStackIsGarrison ? 1 : 0;
	for(i = i; i < mDraggedStackIndicesGarrison.Length; i++)
	{
		draggedStack.SetStackSize(draggedStack.GetStackSize() + stacks[mDraggedStackIndicesGarrison[i]].GetStackSize());
		stacks[mDraggedStackIndicesGarrison[i]] = none;
	}
	mTown.GetGarrisonArmy().SetBaseCreatureStacks(stacks);
	
	stacks = mTown.GetVisitingArmy().GetBaseCreatureStacks();
	i = mFirstStackIsGarrison ? 0 : 1;
	for(i = i; i < mDraggedStackIndicesVisiting.Length; i++)
	{
		draggedStack.SetStackSize(draggedStack.GetStackSize() + stacks[mDraggedStackIndicesVisiting[i]].GetStackSize());
		stacks[mDraggedStackIndicesVisiting[i]] = none;
	}
	mTown.GetVisitingArmy().SetBaseCreatureStacks(stacks);

	altarOfSacrifice.ConvertCreature(draggedStack);	

	// notify gui
	if(mTown.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud.GetTownHudCntl().GetMiddleHUD().IsVisible())
		{
			hud.GetTownHudCntl().GetMiddleHUD().SetDataFromTown(mTown, true);
			hud.GetTownHudCntl().SetDraggedSlotUnused();
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
	return mTown.GetLocation();
}


/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mTown.GetPlayer();
}
