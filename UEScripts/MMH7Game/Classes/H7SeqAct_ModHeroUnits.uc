//=============================================================================
// Adding/Removing units from an hero/army
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_ModHeroUnits extends H7SeqAct_ManipulateHero
	native;

/** What to do with the units */
var(Properties) protected EModQuantityOper mOper<DisplayName="Operator">;
/** The type of unit to change */
var(Properties) protected archetype H7Creature mUnit<DisplayName="Target stack">;
/** The amount of units to change */
var(Properties) protected int mQuantity<DisplayName="Quantity"|ClampMin=1>;

//TEST
/** Will stack be controlled by AI */
var(Properties) protected bool mAILock<DisplayName="AI Control Lock !TEST!">;
/** Can stack be dismissed */
var(Properties) protected bool mDismissDisabled<DisplayName="Disable Dismiss !TEST!">;

function Activated()
{
	local H7AdventureArmy army;
	local H7BaseCreatureStack stack;
	local int newSize;
	local H7FCTController fctController;

	army = GetTargetArmy();

	if(army == none || mUnit == none)
	{
		return;
	}

	stack = army.GetStackByName(mUnit.GetName());

	if(stack != none)
	{
		fctController = class'H7FCTController'.static.GetInstance();

		if(mOper == EMQO_ADD)
		{
			newSize = stack.GetStackSize() + mQuantity;

			if(stack.GetStackType() != none && mQuantity > 0)
			{
				fctController.StartFCT(FCT_TEXT, army.Location, army.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_RECIEVED_UNIT","H7FCT"), MakeColor(0,255,0,255), stack.GetStackType().GetIcon());
			}
		}
		else if(mOper == EMQO_SUB)
		{
			newSize = stack.GetStackSize() - mQuantity;
		}
		else //if(mOper == EMQO_SET)
		{
			newSize = mQuantity;

			if(stack.GetStackType() != none && newSize > stack.GetStackSize())
			{
				fctController.StartFCT(FCT_TEXT, army.Location, army.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_RECIEVED_UNIT","H7FCT"), MakeColor(0,255,0,255), stack.GetStackType().GetIcon());
			}
		}

		stack.SetAILock( mAILock );
		stack.SetDismissDisabled( mDismissDisabled );

		if(newSize <= 0)
		{
			army.RemoveCreatureStackByIndex( army.GetIndexOfStack(stack) );
		}
		else
		{
			stack.SetStackSize(newSize);
		}
	}
	else if(mQuantity > 0 && mOper != EMQO_SUB)
	{
		stack = new class'H7BaseCreatureStack'();
		stack.SetStackType( mUnit );
		stack.SetStackSize( mQuantity );
		stack.SetAILock( mAILock );
		stack.SetDismissDisabled( mDismissDisabled );
		army.PutCreatureStackToEmptySlot(stack);
	}

	// update creature stack properties after base creature stacks changed
	army.CreateCreatureStackProperies();
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

