//=============================================================================
// H7SeqCon_HoldCreaturesByTier
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_HoldCreaturesByTier extends H7SeqCon_Player
	dependson(H7StructsAndEnumsNative)
	implements(H7IConditionable)
	native
	savegame;

/** Creatures to hold */
var(Properties) protected ECreatureTier mCreatureTier<DisplayName=Creature Tier>;
var(Properties) ECompareOp mOper<DisplayName=Relation>;
var(Properties) protected int mCreatureAmount<DisplayName=Amount>;

var protected savegame int mPreviousCount;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local int count;

	// Condition already fulfilled
	if(Eval(mOper, mPreviousCount, mCreatureAmount))
	{
		return true;
	}

	count = GetCount(player);

	if(count > mPreviousCount)
	{
		ConditionProgressed();
		mPreviousCount = count;
	}

	return Eval(mOper, count, mCreatureAmount);
}

function protected int GetCount(H7Player player)
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local int count;

	armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies(player);
	count = 0;
	foreach armies(army)
	{
		count += army.GetCreatureAmountOfTier(mCreatureTier);
	}

	return count;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("HOLD_CREATURES_NUM_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int currentCount;

	currentCount = GetCount(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer());

	progress.CurrentProgress = Min(currentCount, mCreatureAmount);
	progress.MaximumProgress = mCreatureAmount;
	progress.ProgressText = Repl(Repl(GetProgress(), "%current", int(progress.CurrentProgress)), "%maximum", int(progress.MaximumProgress));

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

