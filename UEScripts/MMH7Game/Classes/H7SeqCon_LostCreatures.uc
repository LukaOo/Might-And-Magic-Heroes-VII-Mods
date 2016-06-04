/*=============================================================================
 * H7SeqCon_LostCreatures
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqCon_LostCreatures extends H7SeqCon_Player
	dependson(H7StructsAndEnumsNative)
	implements(H7IConditionable)
	native
	savegame;

/** The type and amount of creature to lose */
var(Properties) H7CreatureCounter mCreatureCounter<DisplayName=Creature type and amount to lose>; 
/** How to compare */
var(Properties) ECompareOp mOper<DisplayName=Relation>;

var protected savegame int mPreviousBodyCount;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local int bodyCount;

	// Condition already fulfilled
	if(Eval(mOper, mPreviousBodyCount, mCreatureCounter.Counter))
	{
		return true;
	}

	bodyCount = GetBodyCount(player);

	if(bodyCount > mPreviousBodyCount)
	{
		ConditionProgressed();
		mPreviousBodyCount = bodyCount;
	}

	return Eval(mOper, bodyCount, mCreatureCounter.Counter);
}

function protected int GetBodyCount(H7Player player)
{
	local array<H7CreatureCounter> armyCreatureLosses;
	local H7CreatureCounter currentArmyCreatureLoss;
	local int bodyCount;

	if(mCreatureCounter.Creature == none)
	{
		bodyCount = GetAnyCreatureLostAmount(player);
	}
	else
	{
		armyCreatureLosses = class'H7ScriptingController'.static.GetInstance().GetCreatureLosses();
		foreach armyCreatureLosses(currentArmyCreatureLoss)
		{
			if(currentArmyCreatureLoss.Creature == mCreatureCounter.Creature && currentArmyCreatureLoss.PlayerID == player.GetPlayerNumber())
			{
				bodyCount += currentArmyCreatureLoss.Counter;
			}
		}
	}

	return bodyCount;
}

protected function int GetAnyCreatureLostAmount(H7Player player)
{
	local array<H7CreatureCounter> currentCreatureLosses;
	local H7CreatureCounter currentCreatureLoss;
	local int bodyCount;

	bodyCount = 0;

	currentCreatureLosses = class'H7ScriptingController'.static.GetInstance().GetCreatureLosses();
	foreach currentCreatureLosses( currentCreatureLoss )
	{
		if(currentCreatureLoss.PlayerID == player.GetPlayerNumber())
		{
			bodyCount += currentCreatureLoss.Counter;
		}
	}

	return bodyCount;	// No creatures lost
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("LOST_CREATURES_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int currentCount;

	currentCount = GetBodyCount(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer());

	progress.CurrentProgress = Min(currentCount, mCreatureCounter.Counter);
	progress.MaximumProgress = mCreatureCounter.Counter;

	progress.ProgressText = Repl(GetProgress(), "%current", Round((progress.CurrentProgress/progress.MaximumProgress)*100));

	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return true; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

