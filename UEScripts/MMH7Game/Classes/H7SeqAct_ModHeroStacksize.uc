/*=============================================================================
 * H7SeqAct_ModHeroStacksize
 * 
 * Reduces/increases/sets all creature stack sizes by a certain
 * percentage
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_ModHeroStacksize extends H7SeqAct_ManipulateHero
	native;

/** How to change the creature stack sizes. */
var(Properties) protected EModQuantityOper mOper<DisplayName="Operator">;
/** The percentage by which the creature stack sizes are changed. */
var(Properties) protected int mPercentage<DisplayName="Percentage"|ClampMin=0|ClampMax=100>;

function Activated()
{
	local H7AdventureArmy army;
	local array<H7BaseCreatureStack> stacks;   
	local H7BaseCreatureStack stack;
	local int newSize, changeAmount, i;
	local H7FCTController fctController;

	army = GetTargetArmy();

	if(army == none)
	{
		return;
	}

	fctController = class'H7FCTController'.static.GetInstance();

	stacks = army.GetBaseCreatureStacks();
	foreach stacks(stack, i)
	{
		if(stack != none)
		{
			changeAmount = Round((float(stack.GetStackSize())*float(mPercentage))/100.f);
			if(mOper == EMQO_ADD)
			{
				newSize = stack.GetStackSize() + changeAmount;

				if(stack.GetStackType() != none && changeAmount > 0)
				{
					fctController.StartFCT(FCT_TEXT, army.Location, army.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_RECIEVED_UNIT","H7FCT"), MakeColor(0,255,0,255), stack.GetStackType().GetIcon());
				}
			}
			else if(mOper == EMQO_SUB)
			{
				newSize = stack.GetStackSize() - changeAmount;
			}
			else //if(mOper == EMQO_SET)
			{
				newSize = changeAmount;

				if(stack.GetStackType() != none && newSize > stack.GetStackSize())
				{
					fctController.StartFCT(FCT_TEXT, army.Location, army.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_RECIEVED_UNIT","H7FCT"), MakeColor(0,255,0,255), stack.GetStackType().GetIcon());
				}
			}

			if(newSize <= 0)
			{
				army.RemoveCreatureStackByIndex( i );
			}
			else
			{
				stack.SetStackSize(newSize);
			}
		}
	}
}

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

