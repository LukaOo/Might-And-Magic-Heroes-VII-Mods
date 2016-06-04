/*=============================================================================
* H7Inscriber
* =============================================================================
*  
*  
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Inscriber extends H7TownBuilding
	savegame;

var (properties) savegame protected array<H7HeroItem> mScrolls<DisplayName=Scroll pool>;
var (properties) savegame protected ETrigger mRefreshOffers<DisplayName=New Scrolls To Offer>;

var protected savegame array<int> mScrollRandValues;
var protected savegame array<IntPoint> mScrollPosses;
var protected savegame array<H7HeroItem> mCurrentScrolls;

function array <H7HeroItem> GetCurrentlyAvailableScrolls() {return mCurrentScrolls;}


function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container)
{
	if(triggerEvent == mRefreshOffers)
	{
		SetCurrentScrolls();
	}
	super.TriggerEvents(triggerEvent, forecast, container);
}

function InitTownBuilding(H7Town town)
{
	local int i;
	local IntPoint pos;

	super.InitTownBuilding( town );

	for(i = 0; i < 40; i++)
	{
		pos.X = i%4;
		pos.Y = i/4;
		mScrollPosses.AddItem(pos);
	}
	SetCurrentScrolls();
}

function SetCurrentScrolls()
{
	local int i, j, currentHighestRandValue, currentHighestRandValueIndex;
	currentHighestRandValue = 0;

	//generate the random values for scrolls
	;
	mScrollRandValues.Length = mScrolls.Length;
	for(i = 0; i < mScrolls.Length; i++)
	{
		mScrollRandValues[i] += class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(100000);			
	}
	
	//select scrolls for sale by their random value
	for(i = 0; i < 6; i++)
	{
		for(j = 0; j < mScrolls.Length; j++)
		{
			if(mScrollRandValues[j] > currentHighestRandValue)
			{
				currentHighestRandValue = mScrollRandValues[j];
				currentHighestRandValueIndex = j;
			}
		}

		mCurrentScrolls[i] = class'H7HeroItem'.static.CreateItem( mScrolls[currentHighestRandValueIndex] );
		//give scroll another randValue so it could come up again
		mScrollRandValues[currentHighestRandValueIndex] = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(100000);
		;
		currentHighestRandValue = 0;
		currentHighestRandValueIndex = 0;
	}

	// make sure we have 6 scrolls for sale
	if(mCurrentScrolls.Length < 6)
	{
		for(i = 0; i < mScrolls.Length; i++)
		{
			mCurrentScrolls.AddItem(class'H7HeroItem'.static.CreateItem( mScrolls[i] ));
			if(mCurrentScrolls.Length == 6)
				return;
		}
	}
}

function IntPoint GetScrollPosByIndex(int index)
{
	return mScrollPosses[index];
}

function H7HeroItem GetScrollByID(int id)
{
	local H7HeroItem scroll;

	foreach mCurrentScrolls(scroll)
	{
		if(scroll.GetID() == id) return scroll;
	}

	;
	return none;
}

function H7HeroItem BuyScrollByID(int id)
{
	local H7HeroItem scrollToBuy;

	scrollToBuy = GetScrollByID(id);
	if(scrollToBuy == none) return none;

	mCurrentScrolls[mCurrentScrolls.Find(scrollToBuy)] = none;
	return scrollToBuy;
}

function JsonObject Serialize()
{
	local JSonObject JSonObject;
	local int i;

	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	
	if (JSonObject == None)
	{
		;
	}

	for(i = 0; i < mCurrentScrolls.Length; i++)
	{
		if(mCurrentScrolls[i] != none)
			JSonObject.SetStringValue("Scroll"$i, PathName( mCurrentScrolls[i].ObjectArchetype ));
		else
			JSonObject.SetStringValue("Scroll"$i, "null");
	}	
	
	for(i = 0; i < mScrollRandValues.Length; i++)
	{
		JSonObject.SetIntValue("ScrollRandValue"$i, mScrollRandValues[i]);
	}

	JSonObject.SetIntValue("CurrentScrollCount", mCurrentScrolls.Length);
	JSonObject.SetIntValue("ScrollRandValueCount", mScrollRandValues.Length);


	// Send the encoded JSonObject
	return JSonObject;
}

function Deserialize(JSonObject data)
{
	local int i, currentScrollCount, scrollRandValueCount;
	local IntPoint pos;

	currentScrollCount = data.GetIntValue("CurrentScrollCount");
	scrollRandValueCount = data.GetIntValue("ScrollRandValueCount");

	for(i = 0; i < currentScrollCount; i++)
	{
		if(data.GetStringValue("Scroll"$i) == "null")
			mCurrentScrolls[i] = none;
		else
			mCurrentScrolls[i] = H7HeroItem(DynamicLoadObject(data.GetStringValue("Scroll"$i), class'H7HeroItem'));
	}

	for(i = 0; i < currentScrollCount; i++)
	{
		if(mCurrentScrolls[i]!=none)
			mCurrentScrolls[i] = class'H7HeroItem'.static.CreateItem( mCurrentScrolls[i] );
	}

	for(i = 0; i < scrollRandValueCount; i++)
	{
		mScrollRandValues[i] = data.GetIntValue("SrollRandValue"$i);
	}

	for(i = 0; i < 40; i++)
	{
		pos.X = i%4;
		pos.Y = i/4;
		mScrollPosses.AddItem(pos);
	}
}
