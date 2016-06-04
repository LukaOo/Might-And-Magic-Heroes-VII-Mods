//=============================================================================
// H7GFxTownList
//
// (!!!) - This is actually in the AdventureHUD
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxTownList extends H7GFxUIContainer;

var protected GFxObject mData;

function SetData(array<H7Town> towns)
{
	local H7Town town;
	local int i;
	local GFXObject townData;

	// old towns
	if( mData != none )
	{
		i = 0;
		while(mData.GetElementObject(i) != none)
		{
			class'H7ListeningManager'.static.GetInstance().RemoveListener(mData.GetElementObject(i));
			i++;
		}
	}

	mData = CreateArray();
	i = 0;

	// go list from back to front, because it's build from bottom to top
	for(i=towns.Length-1;i>=0;i--)
	{
		town = towns[i];
		townData = CreateDataObject();
		town.GUIWriteInto(townData);
		town.GUIAddListener(townData);
		mData.SetElementObject(towns.Length-1-i,townData);
	}

	SetObject("mData",mData);
	Update();
}

function Select(H7Town town)
{
	SelectTown(town.GetID());
}

function SelectTown(int id)
{
	ActionScriptVoid("SelectTown");
}

function SetTownMode(optional bool val)
{
	ActionScriptVoid("SetTownMode");
}

private function Update()
{
	ActionScriptVoid("Update");
}

function DisableMe()
{
	ActionScriptVoid("Disable");
}

function EnableMe()
{
	ActionScriptVoid("Enable");
}

function SetVisibleSave(bool val)
{
	super.SetVisibleSave(val);
}
