//=============================================================================
// H7GFxTownInfo
//
//
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxTownInfo extends H7GFxUIContainer;

function SetData(H7Town town , optional array<H7Town> towns)
{
	local GFxObject data,townlist,townData;
	local H7Town tmpTown;
	local int i;

	data = CreateObject("Object");
	data.SetInt("TownID",town.GetID());
	data.SetString("TownName",town.GetName());
	data.SetString("TownLevel","Level" @ town.GetLevel());
	data.SetInt("TownIncome", town.GetModifiedStatByID( STAT_PRODUCTION ) );
	data.SetString("TownIncomeIcon",town.GetIncomeIcon());
	data.SetString("TownInfoIcon",town.GetInfoIconPath());
	data.SetString("TownLore",town.GetInfoIconPath());

	townlist = CreateArray();
	i = 0;
	foreach towns(tmpTown)
	{
		townData = CreateDataObject();
		tmpTown.GUIWriteInto(townData);
		townlist.SetElementObject(i,townData);
		i++;
	}

	if(towns.Length > 0)
	{ 
		data.SetObject("TownList",townlist);
	}

	SetObject("mData",data);
	Update();
}

function SetDataFromDwelling(H7Dwelling dwelling)
{
	local GFxObject data;
	
	data = CreateObject("Object");
	data.SetString("TownName", dwelling.GetName());
	data.SetString("TownLevel","TODO: Dwelling type");
	data.SetBool("DwellingMode", true);

	SetObject("mData",data);
	Update();
}

// ---------- private helper functions -----------------

private function Update()
{
	;
	ActionScriptVoid("Update");
}
