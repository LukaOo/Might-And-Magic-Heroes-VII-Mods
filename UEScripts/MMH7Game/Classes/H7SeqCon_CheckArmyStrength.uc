/*=============================================================================
 * H7SeqCon_CheckArmyStrength
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqCon_CheckArmyStrength extends H7SeqCon_Player
	implements(H7IHeroReplaceable, H7IConditionable)
	native
	savegame;

/** The hero whose level is used to calculate the army strength to check against */
var(Properties) archetype H7EditorHero mHero<DisplayName="Hero for calculation">;
/** The stacks used to calculate the army strength to check against */
var(Properties) protected H7CreatureCounter mCreatureStacks[7]<DisplayName="Creature stacks for calculation">;
/** Calculate Army Strength */
var(Properties) protected editconst float mArmyStrength<DisplayName="Caclulcated army strength to check against">;
/** How to compare */
var(Properties) protected ECompareOp mCompareOper<DisplayName="Relation">;
/** Only consider these factions for total army strength calculation */
var(Properties) protected array<H7Faction> mConsideredFactions<DisplayName="Considered factions">;

var protected savegame float mPreviousStrengthLoss;

function protected bool IsConditionFulfilledForPlayer(H7Player derPlayer)
{
	local float totalStrengthLoss;

	// Condition already fulfilled?
	if(Eval(mCompareOper, mPreviousStrengthLoss, mArmyStrength))
	{
		return true;
	}

	totalStrengthLoss = GetTotalStrengthLoss(derPlayer);

	if(totalStrengthLoss > mPreviousStrengthLoss)
	{
		ConditionProgressed();
		mPreviousStrengthLoss = totalStrengthLoss;
	}

	return Eval(mCompareOper, totalStrengthLoss, mArmyStrength);
}

function protected float GetTotalStrengthLoss(H7Player derPlayer)
{
	local float totalStrengthLoss;
	local array<H7ArmyStrengthParams> armyStrengthLosses;
	local H7ArmyStrengthParams armyStrengthLoss;
	local array<H7StackStrengthParams> stackStrengthLosses;
	local H7StackStrengthParams stackStrengthLoss;
	local EPlayerNumber playerID;
	local float heroMod, stackStrength;

	totalStrengthLoss = 0;
	playerID = derPlayer.GetPlayerNumber();
	armyStrengthLosses = class'H7ScriptingController'.static.GetInstance().GetArmyStrengthLosses();

	foreach armyStrengthLosses(armyStrengthLoss)
	{
		if(armyStrengthLoss.PlayerID == playerID)
		{
			stackStrengthLosses = GetFilteredStackStrengths(armyStrengthLoss.StackStrengths);
			stackStrength = 0;
			foreach stackStrengthLosses(stackStrengthLoss)
			{
				stackStrength += stackStrengthLoss.CreaturePower;
			}
			if(mConsideredFactions.Length == 0 || mConsideredFactions.Find(armyStrengthLoss.HeroFaction) >= 0)
			{
				heroMod = class'H7AdventureArmy'.static.GetHeroStrengthValue(armyStrengthLoss.HeroLevel);
			}
			else
			{
				heroMod = 1.0;
			}
			totalStrengthLoss = stackStrength * heroMod;
		}
	}

	return totalStrengthLoss;
}

function protected array<H7StackStrengthParams> GetFilteredStackStrengths(array<H7StackStrengthParams> unfilteredStackStrengths)
{
	local array<H7StackStrengthParams> localUnfilteredStackStrengths;
	local H7StackStrengthParams stackStrength;
	local array<H7StackStrengthParams> filteredStackStrengths;

	localUnfilteredStackStrengths = unfilteredStackStrengths;

	if(mConsideredFactions.Length == 0)
	{
		filteredStackStrengths = localUnfilteredStackStrengths;
	}
	else
	{
		foreach localUnfilteredStackStrengths(stackStrength)
		{
			if( mConsideredFactions.Find(stackStrength.Faction) >= 0 )
			{
				filteredStackStrengths.AddItem(stackStrength);
			}
		}
	}

	return filteredStackStrengths;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("LOSE_ARMY_STRENGTH_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int current;

	current = GetTotalStrengthLoss(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer());
	progress.CurrentProgress = Min(current, mArmyStrength);
	progress.MaximumProgress = mArmyStrength;

	progress.ProgressText = Repl(GetProgress(), "%current", Round((progress.CurrentProgress/progress.MaximumProgress)*100));

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

