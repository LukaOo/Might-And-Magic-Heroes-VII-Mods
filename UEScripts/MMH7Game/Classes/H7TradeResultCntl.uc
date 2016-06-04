//=============================================================================
// H7TradeResultCntl
//
// IMPORTANT: only the player that receives items or creatures actualy adds an entry to its mTradeData
// for all other player the mTradeData remains empty until they reveive items or creatures
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TradeResultCntl extends H7FlashMovieBlockPopupCntl; 

var protected H7GFxTradeResult mTradeResultPopup;

var protected Array<H7AlliedTradeData> mTradeData;
var protected H7AlliedTradeData mCurrentTradeData;
var protected bool mFound;
var protected int mFoundIndex;

function H7GFxTradeResult GetTradeResultPopup() {return mTradeResultPopup;}
function H7GFxUIContainer GetPopup()            {return mTradeResultPopup;}

function bool Initialize()
{
	;
	Super.Start();
	AdvanceDebug(0);

	mTradeResultPopup = H7GFxTradeResult(mRootMC.GetObject("aTradeResult", class'H7GFxTradeResult'));

	mTradeResultPopup.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function Update()
{
	local H7Message message;
	local H7AlliedTradeData tradeDataEntry;
	local H7StackCount stack;
	local H7HeroItem item;
	local string tooltip;
	tooltip = "";

	ForEach mTradeData(tradeDataEntry)
	{
		ForEach tradeDataEntry.receivedCreatures(stack)
		{
			tooltip = tooltip $ "\n" $  stack.count $ "x" @ "<img src='" $ stack.type.GetFlashIconPath() $ "' width='#TT_BODY#' height='#TT_BODY#'>" @ stack.type.GetName();
		}

		if(tooltip != "")
		{
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroReceivedCreatures.CreateMessageBasedOnMe();
			message.mPlayerNumber = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(tradeDataEntry.receivingHeroID).GetPlayerNumber();
			message.AddRepl("%recHero",tradeDataEntry.receivingHeroName);
			message.AddRepl("%giverHero",tradeDataEntry.givingHeroName);
			message.settings.referenceObject = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(tradeDataEntry.receivingHeroID).GetHero();
			tooltip = message.GetFormatedText() $ tooltip;
			message.mTooltip = tooltip;
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	
		tooltip = "";
		ForEach tradeDataEntry.receivedItems(item)
		{
			tooltip = tooltip $ "\n" $ "<img src='" $ item.GetFlashIconPath() $ "' width='#TT_BODY#' height='#TT_BODY#'>" @ item.GetName();
		}

		if(tooltip != "")
		{
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroReceivedItems.CreateMessageBasedOnMe();
			message.mPlayerNumber = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(tradeDataEntry.receivingHeroID).GetPlayerNumber();
			message.AddRepl("%recHero",tradeDataEntry.receivingHeroName);
			message.AddRepl("%giverHero",tradeDataEntry.givingHeroName);
			message.settings.referenceObject = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(tradeDataEntry.receivingHeroID).GetHero();
			tooltip = message.GetFormatedText() $ tooltip;
			message.mTooltip = tooltip;
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}
	ClearTradeList();
	

	/*mTradeResultPopup.Update(mTradeData[0]);
	mTradeData.RemoveItem(mTradeData[0]);
	mTradeResultPopup.SetVisibleSave(true);
	OpenPopup();*/
}

function AddReceivedItem(int itemID, H7AdventureHero receivingHero, H7AdventureHero givingHero)
{
	;
	setTradeEntry(receivingHero, givingHero);

	mTradeData[mFoundIndex].receivedItems.AddItem(receivingHero.GetInventory().GetItemByID(itemID));

	;
	resetLogic();
}

function RemoveReceivedItem(int itemID, H7AdventureHero receivingHero, H7AdventureHero givingHero)
{
	;
	setTradeEntry(receivingHero, givingHero);

	mTradeData[mFoundIndex].receivedItems.RemoveItem(givingHero.GetInventory().GetItemByID(itemID));//receivingHero.GetInventory().GetItemByID(itemID));

	CheckAndRemoveEmptyTradeData();
	resetLogic();
}

function AddReceivedCreature(H7StackCount stackCount, H7AdventureHero receivingHero, H7AdventureHero givingHero)
{
	//local array<H7BaseCreatureStack> stacks;
	// prevent crash
	if(receivingHero == none || givingHero == none) return;
	if(!receivingHero.IsHero()) return;
	if(!givingHero.IsHero()) return;
	if(stackCount.count == 0) return; //for some reason this method is called for every creature type in the 
	                                  //receiving heroes army, so it is called with 0 stack size

	;
	setTradeEntry(receivingHero, givingHero);

	//stacks = receivingHero.GetAdventureArmy().GetBaseCreatureStacks();
	mTradeData[mFoundIndex].receivedCreatures.AddItem(stackCount);

	;
	resetLogic();
}

/*function RemoveReceivedCreature(int slotIndex, H7AdventureHero receivingHero, H7AdventureHero givingHero)
{
	local array<H7BaseCreatureStack> stacks;
	// prevent crash
	if(receivingHero == none || givingHero == none) return;
	if(!receivingHero.IsHero()) return;
	if(!givingHero.IsHero()) return;

	`log_gui("H7TradeResultCntl.RemoveReceivedCreature" @ receivingHero @ givingHero);
	setTradeEntry(receivingHero, givingHero);

	stacks = givingHero.GetAdventureArmy().GetBaseCreatureStacks();
	if( mTradeData[mFoundIndex].receivedCreatures.Find( stacks[slotIndex] ) != -1 )
	{
		mTradeData[mFoundIndex].receivedCreatures.RemoveItem(stacks[slotIndex]);
	}
	CheckAndRemoveEmptyTradeData();
	resetLogic();
}*/

function CheckAndRemoveEmptyTradeData()
{
	if(mTradeData[mFoundIndex].receivedItems.Length == 0 && mTradeData[mFoundIndex].receivedCreatures.Length == 0)
	{
		;
		mTradeData.RemoveItem(mTradeData[mFoundIndex]);
	}
	else
	{
		;
	}
}

/**
 * set mFoundIndex to the correct tradeTable entry based on the receiving and giving hero
 */
function setTradeEntry(H7AdventureHero receivingHero, H7AdventureHero givingHero)
{
	local H7AlliedTradeData tradeEntry, emptyEntry;
	local bool found;
	local int i;

	;

	// look for entry with right combination of receiving/giving hero
	foreach mTradeData(tradeEntry)
	{
		if(tradeEntry.receivingHeroID == receivingHero.GetID() && tradeEntry.givingHeroID == givingHero.GetID()) 
		{
			;
			found = true;
			break;
		}
		i++;
	}

	// if not entry with the receiving/giving hero was found, set up a new one
	if(!found)
	{
		;
		tradeEntry = emptyEntry;
		tradeEntry.givingHeroID = givingHero.GetID();
		tradeEntry.givingHeroName = givingHero.GetName();
		tradeEntry.receivingHeroID = receivingHero.GetID();
		tradeEntry.receivingHeroName = receivingHero.GetName();
		mTradeData.AddItem(tradeEntry);
	}

	mFound = found;
	mFoundIndex = found ? i : mTradeData.Length-1;
}

function H7AlliedTradeData GetTradeDataByReceivingPlayer(H7Player player)
{
	local array<H7AdventureArmy> playerArmies;
	local H7AdventureArmy playerArmy;
	local H7AlliedTradeData tradeEntry, emptyEntry;

	playerArmies = player.GetArmies();

	ForEach playerArmies(playerArmy)
	{
		if(playerArmy.GetHero().IsHero())
		{
			ForEach mTradeData(tradeEntry)
			{   
				if(tradeEntry.receivingHeroID == playerArmy.GetHero().GetID())
					return tradeEntry;
			}
		}
	}

	return emptyEntry;
}

/**
 * Check all player heroes ids with all trade entries
 * returns true if any player hero id is found an any tradeEntry as the receiving hero
 */
function bool PlayerReceivedItemsCreautes()
{
	if(mTradeData.Length > 0) return true;
	return false;
}

function ClearTradeList()
{
	;
	mTradeData.Length = 0;
	;
}

function resetLogic()
{
	mFound = false;
	mFoundIndex = 0;
}

function Closed()
{
	if(mTradeData.Length > 0)
	{
		Update();
	}
	else
	{
		ClosePopup();
	}
}

