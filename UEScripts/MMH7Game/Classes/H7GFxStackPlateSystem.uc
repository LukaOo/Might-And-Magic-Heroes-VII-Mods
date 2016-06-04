//=============================================================================
// H7GFxStackPlateSystem
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxStackPlateSystem extends GFxObject; // IN flash this is the whole stackplatesystem

var protected GFxObject mMultiUpdateList;

function int CreatePlate(int x,int y, int stackSize, int r, int g, int b )
{
	local int i;
	
	//`log_dui("Create Plate" @ stackSize);
	
	i = ActionScriptInt("CreatePlate");
	
	return i;
}


function Update(int id,int x,int y, int stackSize, bool visible)
{
	;
	ActionScriptVoid("Update");
}

function StartMultiUpdate()
{
	if(mMultiUpdateList == none)
	{
		mMultiUpdateList = CreateObject("Object");
		SetObject( "mData" , mMultiUpdateList);
	}
}

function AddUpdate(int id,int x,int y, int stackSize, bool visible, EStackPlateOrientation plateOrientation, bool unitIsActive)
{
	local GFxObject TempObj;

	TempObj = mMultiUpdateList.GetObject(string(id));

	if(TempObj == none)
	{
		TempObj = CreateObject("Object");
		mMultiUpdateList.SetObject(string(id), TempObj);
	}

	TempObj.SetInt( "id", id );
	TempObj.SetInt( "x", x );
	TempObj.SetInt( "y", y );
	TempObj.SetInt( "stack", stackSize );
	TempObj.SetBool( "visible", visible );
	TempObj.SetString("Orientation", String(plateOrientation));
	TempObj.SetBool("unitIsActive", unitIsActive);

	//`log_dui("MultiUpdate.AddUpdate" @ id @ x @ y @ stackSize @ visible @ plateOrientation);
}

function MultiUpdate()
{
	//`log_dui("Multi Update");
	
	ActionScriptVoid("MultiUpdate");
}

function DeletePlate(int id)
{
	ActionScriptVoid("DeletePlate");
}

function Clear()
{
	//`log_dui("Delete all Plate");
	mMultiUpdateList = none;

	ActionScriptVoid("Clear");
}

// Default properties block
