//=============================================================================
// H7GFxTradeResult
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxTradeResult extends H7GFxUIContainer;

function Update(H7AlliedTradeData data)
{
	/*local GFxObject object, itemObj, creatureObj, itemList, creatureList;
	local H7HeroItem item;
	local H7BaseCreatureStack stack;
	local int i;

	object = CreateObject("Object");
	itemList = CreateArray();
	creatureList = CreateArray();

	ForEach data.receivedItems(item, i)
	{
		itemObj = CreateItemObject(item);
		itemList.SetElementObject(i, itemObj);
	}

	ForEach data.receivedCreatures(stack, i)
	{
		creatureObj = CreateUnitObjectFromStack(stack);
		creatureList.SetElementObject(i, creatureObj);
	}	

	object.SetObject("receivedItems", itemList);
	object.SetObject("receivedCreatures", creatureList);

	object.SetString("ReceivingHeroName", data.receivingHeroName);
	object.SetInt( "ReceivingHeroPlayerColorR", class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(data.receivingHeroID).GetPlayer().GetColor().R);
	object.SetInt( "ReceivingHeroPlayerColorG", class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(data.receivingHeroID).GetPlayer().GetColor().G);
	object.SetInt( "ReceivingHeroPlayerColorB", class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(data.receivingHeroID).GetPlayer().GetColor().B);

	object.SetString("GivingHeroName", data.givingHeroName);
	object.SetInt( "GivingHeroPlayerColorR", class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(data.givingHeroID).GetPlayer().GetColor().R);
	object.SetInt( "GivingHeroPlayerColorG", class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(data.givingHeroID).GetPlayer().GetColor().G);
	object.SetInt( "GivingHeroPlayerColorB", class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(data.givingHeroID).GetPlayer().GetColor().B);

	SetObject("mData", object);
	ActionScriptVoid("Update");*/
}
