//=============================================================================
// H7AdventureController
//=============================================================================
// NOT USED CURRENTLY
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7ItemController extends Object;

var H7HeroItem testStaff;
var H7HeroItem testSword;
var array<H7HeroItem> items;

function Initialize()
{
	/*if (testStaff != None)
	{
		testStaff.Init();
		items.AddItem(testStaff);
	}
	if (testSword != None)
	{
		testSword.Init();
		items.AddItem(testSword);
	}*/
}

function H7HeroItem GetTestItem()
{
	return testSword;
}

function array<H7HeroItem> GetTestItems()
{
	return items;
}

function H7HeroItem GetItemByID(int id)
{
	local H7HeroItem item;

	ForEach items(item)
	{
		if(item.GetID() == id) return item;
	}
	;
	return none;
}
