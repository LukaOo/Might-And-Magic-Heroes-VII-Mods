//=============================================================================
// H7GFxDateDisplay
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxTopBar extends H7GFxUIContainer
	dependson(H7ResourceSet);
//////////////////////////////////////////////////////////////////////////////////
// ResourceBar 
//////////////////////////////////////////////////////////////////////////////////

/*function ShowResourceIncome(H7ResourceSet resources)
{
	local array<ResourceStockpile> set;
	local ResourceStockpile pile;
	local int index;
	
	if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == none || class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerType() == PLAYER_AI ||
        (class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()))
		return;
	
	set = resources.GetAllResourcesAsArray();
	
	index = 0;
	foreach set(pile)
	{
		if(pile.Income == 0){ index++; continue; }
		UpdateResourceAmountAndIcon(index, pile.Type.GetIconPath(), pile.Type.GetName(), pile.Quantity - pile.Income, index == set.Length-1 ? true : false);
		TweenResourceAmountAndIcon(index, pile.Type.GetIconPath(), pile.Type.GetName(), pile.Quantity);
		index++;
	}
}*/

function UpdateAllResourceAmountsAndIcons(array<ResourceStockpile> set)
{
	local ResourceStockpile pile;
	local int index;
	local EPlayerNumber playerNumber;
	
    if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == none || class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerType() == PLAYER_AI ||
        (class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()))
		return;

	playerNumber = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber();
	index = 0;
	foreach set(pile)
	{
	  
		if(index == set.Length - 1)
		{
			UpdateResourceAmountAndIcon(index, pile.Type.GetIconPath(), pile.Type.GetName(), pile.Quantity, pile.Income, playerNumber, true);
		}
		else
		{
			UpdateResourceAmountAndIcon(index, pile.Type.GetIconPath(), pile.Type.GetName(), pile.Quantity, pile.Income, playerNumber, false);
		}
		
		index++;
	}
}

function UpdateAllResourceAmountsAndIconsNewTurn(array<ResourceStockpile> set)
{
	local ResourceStockpile pile;
	local int index;
	local EPlayerNumber playerNumber;
	local bool lastResource;
	
	ActionScriptVoid("RemoveAllResourceTweens");

    if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == none || class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerType() == PLAYER_AI ||
        (class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()))
		return;

	playerNumber = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber();
	index = 0;
	foreach set(pile)
	{
		if(set[set.Length-1] == pile) lastResource = true;
		if(pile.Income == 0)
		{
			UpdateResourceAmountAndIcon(index, pile.Type.GetIconPath(), pile.Type.GetName(), pile.Quantity, pile.Income, playerNumber, lastResource);
		}
		else
		{
			UpdateResourceAmountAndIcon(index, pile.Type.GetIconPath(), pile.Type.GetName(), pile.Quantity - pile.Income, pile.Income, playerNumber, lastResource);
			TweenResourceAmountAndIcon(index, pile.Type.GetIconPath(), pile.Type.GetName(), pile.Quantity, playerNumber);
		}
		lastResource = false;
		index++;
	}
	LastResourceIndex(index - 1);
}

function LastResourceIndex(int index)
{
	ActionScriptVoid("LastResourceIndex");
}

function UpdateResourceAmounts()
{
	local array<int> allResourceAmounts;
	
	if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == none || class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerType() == PLAYER_AI ||
        (class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()))
		return;

	allResourceAmounts = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetAllResourceAmounts();
	updateResourceAmoutns(allResourceAmounts);
}

private function UpdateResourceAmountAndIcon(int index, String iconName, String resourceName, int resourceAmount, int income, EPlayerNumber playerNumber, bool lastResource)
{
	ActionScriptVoid("UpdateResourceAmountAndIcon");
}

function TweenResourceAmountAndIcon(int index, String iconName, String resourceName, int resourceAmount, optional int playerNumber=-1)
{
	if(class'H7AdventureController'.static.GetInstance().GetLocalPlayer() == none || class'H7AdventureController'.static.GetInstance().GetCurrentPlayer().GetPlayerType() == PLAYER_AI ||
        (class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer()))
		return;

	playerNumber = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber();

	ActionScriptVoid("TweenResourceAmountAndIcon");
}

private function updateResourceAmoutns(array<int> allResourceAmounts)
{
	ActionScriptVoid("UpdateResourceAmounts");
}

function ShowOtherPlayerPlaying(string playerName, String playerColor)
{
	ActionScriptVoid("ShowOtherPlayerPlaying");
}

function UpdateResourceIncome(string resourceName, int newIncome)
{
	ActionScriptVoid("UpdateResourceIncome");
}

//////////////////////////////////////////////////////////////////////////////////
//  DateDisplay
//////////////////////////////////////////////////////////////////////////////////


function UpdateDisplay(String date)
{
	ActionScriptVoid("UpdateDateDisplay");
}

function UpdateTooltip(int day, int week, int month, int year, string weekName, string weekDescription)
{
	ActionScriptVoid("UpdateDateTooltip");
}
