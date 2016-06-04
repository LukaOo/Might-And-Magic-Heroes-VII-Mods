/*=============================================================================
 * H7SeqCon_HasHeroWithItem
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * 
 * This class should actually extend H7SeqCon_HasHeroWith for unified hero
 * handling, but since savegames/maps containing nodes of this type already
 * exist, this is better left as it is.
 * =============================================================================*/

class H7SeqCon_HasHeroWithItem extends H7SeqCon_Player
	implements(H7IHeroReplaceable, H7IRandomPropertyOwner, H7IConditionable)
	native
	savegame;

/* The hero should have a minimum amount of items */
var(Properties) protected bool mCheckCount<DisplayName="Needs at least">;
/* Required minimum amount of items */
var(Properties) protected int mItemTotalCountAtLeast<DisplayName="Count"|EditCondition=mCheckCount|ClampMin=0>;
/* The hero that is checked. If this is set to none, all heroes are checked */
var(Properties) protected archetype H7EditorHero mHero<DisplayName="Check specific hero">;
/* The hero should have a specific item */
var(Properties) protected bool mAnyItem<DisplayName="Any artifact?">;
/* The required item type */
var(Properties) protected archetype H7HeroItem mItemToHave<DisplayName="Artifact"|EditCondition=!mAnyItem>;
/* The hero must be in a specific town */
var(Properties) protected bool mMustInTown<DisplayName="In Town">;
/* The town */
var(Properties) protected savegame H7Town mTown<DisplayName="Town"|EditCondition=mMustInTown>;

var protected H7AdventureArmy mHeroArmy;

var protected savegame int mPreviousHighestProgress;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local int itemCountToReach;
	local int itemHighestCount;
	itemCountToReach = mCheckCount ? mItemTotalCountAtLeast : 1;

	// Condition already fulfilled
	if(mPreviousHighestProgress == itemCountToReach)
	{
		return true;
	}

	itemHighestCount = GetHighestItemCount(player);

	if(itemHighestCount > mPreviousHighestProgress)
	{
		ConditionProgressed();
		mPreviousHighestProgress = itemHighestCount;
	}

	return (itemHighestCount >= itemCountToReach);
}

function int GetHighestItemCount(H7Player thePlayer)
{
	local array<H7AdventureHero> playerHeroes;
	local H7AdventureHero hero;
	local int highestCurrentProgress;
	local int itemCurrCount;

	highestCurrentProgress = 0;
	playerHeroes = thePlayer.GetHeroes();

	foreach playerHeroes(hero)
	{
		itemCurrCount = GetCurrentItemCount(hero);
		if (itemCurrCount > highestCurrentProgress)
		{
			highestCurrentProgress = itemCurrCount;
		}
	}

	return highestCurrentProgress;
}

function int GetCurrentItemCount(H7AdventureHero hero)
{
	local H7AdventureHero townHero;
	local H7EditorHero heroToCheck;
	local array<H7AdventureArmy> townArmies;
	local H7AdventureArmy army;
	local bool bHeroInTownMatched;
	local array<H7HeroItem> items;
	local int itemCurrCount;

	itemCurrCount = 0;
	heroToCheck = (mHeroArmy == none) ? mHero : mHeroArmy.GetHeroTemplateSource();
	
	if(heroToCheck == none || heroToCheck == hero.GetAdventureArmy().GetHeroTemplateSource())
	{
		if ( mMustInTown && mTown != none )
		{
			bHeroInTownMatched = false;
			townArmies.AddItem(mTown.GetGarrisonArmy());
			townArmies.AddItem(mTown.GetVisitingArmy());
			foreach townArmies (army)
			{
				if (army != none)
				{
					townHero = army.GetHero();
					if (townHero != none && townHero.IsHero() && townHero == hero)
					{
						bHeroInTownMatched = true;
						break;
					}
				}
			}
			if (!bHeroInTownMatched)
			{
				return itemCurrCount;
			}
		}

		if ( mAnyItem )
		{
			hero.GetEquipment().GetItemsAsArray(items);
			itemCurrCount += items.Length;
			items = hero.GetInventory().GetItems();
			itemCurrCount += items.Length;
		}
		else
		{
			itemCurrCount += hero.GetEquipment().CountItem(mItemToHave);
			itemCurrCount += hero.GetInventory().CountItem(mItemToHave);
		}
	}

	return itemCurrCount;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("HERO_COLLECTED_ITEMS_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int current;

	current = GetHighestItemCount(class'H7AdventureController'.static.GetInstance().GetCurrentPlayer());

	progress.CurrentProgress = Min(current, mItemTotalCountAtLeast);
	progress.MaximumProgress = mItemTotalCountAtLeast;
	progress.ProgressText = Repl(Repl(GetProgress(), "%current", int(progress.CurrentProgress)), "%maximum", int(progress.MaximumProgress));
	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return mCheckCount; }

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7Town'))
	{
		if(mTown == randomObject)
		{
			mTown = H7Town(hatchedObject);
		}
	}
}

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
// (cpptext)

