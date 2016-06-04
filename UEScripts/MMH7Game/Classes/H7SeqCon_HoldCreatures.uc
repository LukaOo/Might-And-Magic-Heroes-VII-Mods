//=============================================================================
// H7SeqCon_HoldCreatures
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HoldCreatures extends H7SeqCon_Player
	dependson(H7StructsAndEnumsNative)
	implements(H7IConditionable)
	native
	savegame;

struct native H7CreatureDat
{
	/** The type of creature */
	var() savegame archetype H7Creature creature<DisplayName=Creature to hold>; 
	/** How to compare */
	var() savegame ECompareOp mOper<DisplayName=Relation>;
	/** Specify amount as percentage */
	var() savegame bool usePercent<DisplayName=Percentage>;
	/** The amount of creatures */
	var() savegame int amount<DisplayName=Amount|editcondition=!usePercent|ClampMin=0>;
	/** The amount of creatures in percent */
	var() savegame int percent<Displayname=Percent|UIMin=0|UIMax=100|ClampMin=0|ClampMax=100|editcondition=usePercent>;

	var savegame bool InitedArmyCreatureAmount;
	var savegame int InitAmount;
	var savegame int PreviousAmount;
};

/** Creatures to hold */
var(Properties) protected savegame array<H7CreatureDat> mCreatures<DisplayName="Creatures">;
/** Target Creature Container. If set to none, the overall amount of creatures that the player has are checked */
var(Properties) protected H7IStackContainer mCreatureContainer<DisplayName="Target Creature Container">;

var protected string mProgressPercent;

var object mArmy;

function protected bool IsConditionFulfilledForPlayer(H7Player thePlayer)
{
	local array<H7IStackContainer> containers;
	local int amount;
	local int creatureIdx;
	local float checkAmount;

	containers = GetStackContainers(thePlayer);

	if(mCreatures.Length == 0)
	{
		amount = GetCurrentAmount(-1, containers);
		return (amount == 0);
	}

	for(creatureIdx = 0; creatureIdx < mCreatures.Length; creatureIdx++)
	{
		amount = GetCurrentAmount(creatureIdx, containers);
		checkAmount = (mCreatures[creatureIdx].usePercent ? 
			(0.01) * mCreatures[creatureIdx].percent * mCreatures[creatureIdx].InitAmount : 
				float(mCreatures[creatureIdx].amount));

		if(amount != mCreatures[creatureIdx].PreviousAmount)
		{
			ConditionProgressed(creatureIdx);
			mCreatures[creatureIdx].PreviousAmount = amount;
		}
		
		if (!Eval(mCreatures[creatureIdx].mOper, amount, checkAmount))
		{
			return false;
		}
	}
	return true;
}

function protected int GetCurrentAmount(int creatureIndex, array<H7IStackContainer> containers)
{
	local array<H7IStackContainer> localContainers;
	local H7IStackContainer currentContainer;
	local H7CreatureDat currentCreature;
	local int amount;

	localContainers = containers;
	amount = 0;

	if(creatureIndex < 0 || creatureIndex > mCreatures.Length - 1)
	{
		foreach localContainers( currentContainer )
		{
			amount += currentContainer.GetCreatureAmountTotal();
		}
	}
	else
	{
		currentCreature = mCreatures[creatureIndex];
		foreach localContainers( currentContainer )
		{
			if ( currentCreature.creature != none )
			{
				amount += currentContainer.GetCreatureAmount( currentCreature.creature );
			}
			else
			{
				amount += currentContainer.GetCreatureAmountTotal();
			}
		}
	}

	if (!currentCreature.InitedArmyCreatureAmount)
	{
		// Directly access the array instead of local currentCreature, otherwise these values will not persist
		mCreatures[creatureIndex].InitedArmyCreatureAmount = true;
		mCreatures[creatureIndex].InitAmount = amount;
		mCreatures[creatureIndex].PreviousAmount = 0;
	}

	return amount;
}

function array<H7IStackContainer> GetStackContainers(H7Player thePlayer)
{
	local array<H7IStackContainer> stackContainers;
	local H7IStackContainer fromVariable, fromProperty;

	fromProperty = H7IStackContainer(mCreatureContainer);
	fromVariable = H7IStackContainer(mArmy);

	if ( fromProperty == none && fromVariable == none )
	{
		stackContainers = GetPlayerStackContainers( thePlayer );
	}
	else
	{
		if(fromProperty != none)
		{
			stackContainers.AddItem(fromProperty);
		}
		else // if( fromVariable != none )
		{
			stackContainers.AddItem(fromVariable);
		}
	}

	return stackContainers;
}

function array<H7IStackContainer> GetPlayerStackContainers( H7Player fromPlayer )
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local array<H7IStackContainer> containers;
	local H7IStackContainer container;

	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies(fromPlayer);

	foreach armies( army )
	{
		container = H7IStackContainer(army);
		if( container != none )
		{
			containers.AddItem( container );
		}
	}
	return containers;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("HOLD_CREATURES_NUM_PROGRESS","H7ConditionProgress");
}

function protected InitProgress_Percent()
{
	mProgressPercent = class'H7Loca'.static.LocalizeSave("HOLD_CREATURES_PERCENT_PROGRESS","H7ConditionProgress");
}

function protected string GetProgress_Percent()
{
	if(mProgressPercent == "")
	{
		InitProgress_Percent();
	}
	return mProgressPercent;
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local string progressString;
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local array<H7IStackContainer> containers;
	local H7CreatureDat currentCreature;
	local int creatureIdx;
	local string maximumProgress;

	containers = GetStackContainers(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer());

	for(creatureIdx = 0; creatureIdx < mCreatures.Length; creatureIdx++)
	{
		currentCreature = mCreatures[creatureIdx];

		progressString = (currentCreature.usePercent) ? GetProgress() : GetProgress_Percent();

		progress.MaximumProgress = currentCreature.usePercent ? (0.01)*currentCreature.percent*currentCreature.InitAmount : float(currentCreature.amount);
		progress.CurrentProgress = Min(GetCurrentAmount(creatureIdx, containers), progress.MaximumProgress);
		maximumProgress = currentCreature.usePercent ? class'H7GameUtility'.static.FloatToString(progress.MaximumProgress) : ""$int(progress.MaximumProgress);
		progress.ProgressText = Repl(Repl(progressString, "%current", int(progress.CurrentProgress)), "%maximum", maximumProgress);
		progresses.AddItem(progress);
	}

	return progresses;
}

function bool HasProgress() { return mCreatures.Length > 0; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

