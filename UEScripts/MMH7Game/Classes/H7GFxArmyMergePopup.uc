//=============================================================================
// H7GFxArmyMergePopup
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxArmyMergePopup extends H7GFxUIContainer;

function SetArmyStacks(H7AdventureArmy army,array<H7BaseCreatureStack> joiners,optional String title) // quest merging
{
	local GFxObject data;

	data = CreateObject("Object");
	data.SetString("Title",title);
	data.SetObject("LeftArmy",CreateArmyObject(army)); // lower // main army // taking army
	data.SetObject("RightArmy",CreateArmyObjectFromStacks(joiners)); // higher // sub army // giving army
	
	SetObject("mData", data);
	Update();
}

function SetArmyCaravanArmy(H7AdventureArmy heroArmy, H7AdventureArmy caravanArmy, String title)
{
	local GFxObject data;

	data = CreateObject("Object");
	data.SetString("Title",title);
	data.SetObject("LeftArmy",CreateArmyObject(heroArmy)); // lower // main army // taking army
	data.SetObject("RightArmy",CreateArmyObject(caravanArmy)); // higher // sub army // giving army
	
	SetObject("mData", data);
	Update();
}

function SetArmyArmy(H7AdventureArmy uppperArmy,H7AdventureArmy lowerArmy,String title,optional bool costMode,optional int maxCosts,optional H7TeleportCosts costs) // normal + reinforce merging
{
	local GFxObject data;

	data = CreateObject("Object");
	data.SetString("Title",title);
	data.SetObject("LeftArmy",CreateArmyObject(lowerArmy,false)); // lower // main army // taking army
	data.SetObject("RightArmy",CreateArmyObject(uppperArmy,false,,costMode,costs)); // higher // sub army // giving army

	if(costMode)
	{
		data.SetBool("CostMode",costMode);
		data.SetInt("MaxCosts",maxCosts);
		data.SetInt("CurrentCosts",0);
		data.SetString("CostImage",class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIcons.GetStatIconPath(STAT_MANA));
	}

	SetObject("mData", data);
	Update();
}

function UpdateCosts(int current)
{
	ActionscriptVoid("UpdateCosts");
}

function Update()
{
	ActionscriptVoid("Update");
}
