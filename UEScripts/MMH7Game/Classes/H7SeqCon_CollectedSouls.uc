/*=============================================================================
 * H7SeqCon_CollectedSouls
 * 
 * Checks fallen creatures from both sides in combats fought by a certain
 * player.
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqCon_CollectedSouls extends H7SeqCon_Player
	implements(H7IConditionable)
	dependson(H7StructsAndEnumsNative)
	native
	savegame;

/** Amount of souls (fallen creatures from both sides) that have been collected during combat. */
var(Properties) int mSoulCounter<DisplayName="Amount of souls to collect"|ClampMin=0>;
/** How to compare */
var(Properties) ECompareOp mOper<DisplayName=Relation>;

var protected savegame int mPreviousBodyCount;

function protected bool IsConditionFulfilledForPlayer(H7Player thePlayer)
{
	local int bodyCount;

	// Condition already fulfilled
	if(Eval(mOper, mPreviousBodyCount, mSoulCounter))
	{
		return true;
	}

	bodyCount = GetBodyCount(thePlayer);

	if(bodyCount > mPreviousBodyCount)
	{
		ConditionProgressed();
		mPreviousBodyCount = bodyCount;
	}

	return Eval(mOper, bodyCount, mSoulCounter);
}

function protected int GetBodyCount(H7Player thePlayer)
{
	local array<H7CreatureCounter> armyCreatureLosses;
	local H7CreatureCounter currentArmyCreatureLoss;
	local int bodyCount;
	
	armyCreatureLosses = class'H7ScriptingController'.static.GetInstance().GetCreatureLosses();
	foreach armyCreatureLosses(currentArmyCreatureLoss)
	{
		if(currentArmyCreatureLoss.PlayerID == thePlayer.GetPlayerNumber() || currentArmyCreatureLoss.EnemyID == thePlayer.GetPlayerNumber())
		{
			bodyCount += currentArmyCreatureLoss.Counter;
		}
	}

	return bodyCount;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("COLLECTED_SOULS_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int current;

	current = GetBodyCount(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer());
	progress.CurrentProgress = Min(current, mSoulCounter);
	progress.MaximumProgress = mSoulCounter;
	progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
	progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));
	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return true; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

