//=============================================================================
// H7GFxDeploymentBar
//
// Wrapper for DeploymentBar.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxDeploymentBar extends H7GFxArmyRow;

var GFxObject mData;
var GFxObject mUnitOnMouse;


function InitBar()
{
	mData = CreateDeployObject();
	SetObject( "mData" , mData);
	Update2();
}

function GFxObject CreateDeployObject()
{
	local GFxObject object;
	//local array<H7CreatureStack> unitList;
	local array<H7StackDeployment> deploymentList;

	object = CreateArray();

	if( class'H7CombatController'.static.GetInstance() != none)
	{
		deploymentList = class'H7CombatController'.static.GetInstance().GetStackDeployments();
		
		//unitList = class'H7CombatController'.static.GetInstance().GetUnitsForDeployment();
		CreateList(deploymentList, object);
	}

	return object;
}

/// Helper Function
function int CreateList( array<H7StackDeployment> list, out GFxObject object, optional int startIndex, optional int providerIndex, optional int turn )
{
	local int i;
	local GFxObject TempObj;
	local Color unrealColor;
	//local H7CreatureStack stack;
	//local CreatureStackProperties stackProperties;
	local H7BaseCreatureStack stackBase;
	local H7StackDeployment stackDeployment;
	local H7Creature stackType;
	local H7CombatArmy currentlyDeployingArmy;
	local EUnitType entityType;

	currentlyDeployingArmy = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy();

	;

	for ( i = startIndex; i < list.Length ; ++i) 
	{
		stackDeployment = list[i];
		TempObj = CreateObject("Object");	
		
		;
		
		if(stackDeployment.SourceSlotId != INDEX_NONE && stackDeployment.StackInfo.Creature != none // saved deployment says it wants a unit here (because it previously had)
			&& stackDeployment.SourceSlotId < currentlyDeployingArmy.GetBaseCreatureStackLength()   // but the unit can be dead,reduced, or slot 8,9 so it can be missing
			&& currentlyDeployingArmy.GetBaseStackBySourceSlotId(stackDeployment.SourceSlotId) != none)                                                                                    
		{

			//stackProperties = stackDeployment.StackInfo;
			stackBase = currentlyDeployingArmy.GetBaseStackBySourceSlotId(stackDeployment.SourceSlotId);
			//stack = ???
			stackType = stackBase.GetStackType(); // stack.GetCreature();
			entityType = UNIT_CREATURESTACK;
			unrealColor = currentlyDeployingArmy.GetPlayer().GetColor();

			TempObj = CreateUnitObjectAdvanced(stackType);
			TempObj.SetString(  "IconPath", stackType.GetFlashIconPath() );
			TempObj.SetString(  "UnitName", stackType.GetName() );
			TempObj.SetInt(     "StackSize", stackBase.GetStackSize());
			TempObj.SetBool(    "IsAttacker", currentlyDeployingArmy.IsAttacker() );
			TempObj.SetBool(    "Deployed", stackBase.IsDeployed() );
			TempObj.SetString(  "UnitType", String(entityType) );
			TempObj.SetInt(     "UnrealID", stackDeployment.SourceSlotId ); // now in fact the index; OPTIONAL change to unit id to be consitent
			TempObj.SetString(  "SlotID", turn $ "_" $ stackDeployment.SourceSlotId );
			TempObj.SetObject(  "Color", CreateColorObject(unrealColor));
			
			;
		}
		else if(i < class'H7CombatController'.static.GetInstance().GetMaxDeployNumber())
		{
			//currentlyDeployingArmy.EnsureBaseStackSlotExistence(i);
			//`LOG_GUI("DEPLOYSLOT"@ (turn $ "_" $ stackDeployment.SourceSlotId) @"    EMPTY ARMY SLOT" );
		}
		else if(i < 9)
		{
			;
			TempObj.SetBool(  "Locked", true );
		}
		else if(i < 9+class'H7CombatController'.static.GetInstance().GetLocalGuardSlots())
		{
			;
		}
		else
		{
			;
			TempObj.SetBool(  "Locked", true );
		}
		object.SetElementObject(providerIndex, TempObj);
		++providerIndex;
	}
	
	return providerIndex;
}





function Update2( )
{
	ActionscriptVoid("Update");
	SetVisibleSave(true);
}

// just so flash knows which unit is on mouse (later used for when dropped on the bar, then informs unreal with UnitDroppedOnBar())
function UnitWasPickedUp(H7Unit unit)
{ 
	local int id;
	local H7BaseCreatureStack baseStack;

	baseStack = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy().GetBaseStackBySpawnedStack(H7CreatureStack(unit));
	id = class'H7CombatController'.static.GetInstance().GetCurrentlyDeployingArmy().GetBaseCreatureStackIndex(baseStack);
	baseStack.SetDeployed(false);

	;
	
	mUnitOnMouse = CreateObject("Object");
	mUnitOnMouse.SetInt( "UnrealID", id );

	SetObject( "mUnitOnMouse" , mUnitOnMouse);
	NewUnitIsOnMouse();
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DRAG");
}
function NewUnitIsOnMouse()
{ 
	ActionscriptVoid("NewUnitIsOnMouse");
}

// deploy effect (alpha 0.5)
function MarkAsDeployed(int id)
{
	;
	SetObject( "mUnitOnMouse" , none);
	ActionscriptVoid("MarkAsDeployed");
}

// normal effect (alpha 1)
function MarkAsUnDeployed(int id)
{
	;
	SetObject( "mUnitOnMouse" , none);
	ActionscriptVoid("MarkAsUnDeployed");
}

// hover effects (white square)
function SetHighlight( int id )
{
	;
	ActionscriptVoid("SetHighlight");
}
function SetDehighlight( int id )
{
	;
	ActionscriptVoid("SetDehighlight");
}

// current active/dragging unit cleared (stained glass)
function ClearSelection()
{
	ActionscriptVoid("ClearSelection");
}

function SetMaxDeployed(bool val)
{
	ActionscriptVoid("SetMaxDeployed");
}
