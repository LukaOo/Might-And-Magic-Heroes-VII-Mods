//=============================================================================
// H7EffectSpecialModifyStackSize
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialModifyStackSize extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() EOperationType    mOperationType<DisplayName=Operation>;
var() float             mModifier<DisplayName=Modifier>;
/** If this is checked, the initial stack size is used, NOT the current one. */
var() bool              mUseInitialStackSize<DisplayName=Use Initial Stack Size>;
var() bool              mOverrideInitialStackSize<DisplayName=Adjust Initial Stack Size|ToolTip="If the modified stack size is bigger than the original size, modify the initial size">;
/**After Combat the the Reinforcements won't leave the hero army, if the casulties are over the threshold of the reinforcements value. For example 100 Units + 5 Reinforcements -> 5 Casulties in combat -> 100 will stay after combat. Else 5 will leave to 95 remaining.*/
var() bool              mTakeCasultiesFromReinforcements<DisplayName=Casulties are taken from the reinforcements>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7CreatureStack stack;
	local int i;

	if( isSimulated ) { return; }

	effect.GetTargets( targets );

	if( targets.Length == 0 ) return;

	for( i = 0; i < targets.Length; ++i )
	{
		if( targets[i].IsA('H7CreatureStack') )
		{
			stack = H7CreatureStack( targets[i] );
			ModifyStackSize( stack );
		}
	}
}

protected function ModifyStackSize( H7CreatureStack stack )
{
	local int dif, modifiedValue, stackSize, casulties;

	stackSize = GetStackSize( stack );

	if( mModifier >= 0 )
		modifiedValue = FCeil( class'H7EffectContainer'.static.DoOperation( mOperationType, stackSize, mModifier ) );
	else
		modifiedValue = FFloor( class'H7EffectContainer'.static.DoOperation( mOperationType, stackSize, mModifier ) );

	dif = modifiedValue - stackSize;

	if(!mTakeCasultiesFromReinforcements)
	{
		stack.SetStackSize( class'H7EffectContainer'.static.DoOperation( OP_TYPE_ADD, stack.GetStackSize(), dif ) );
	}
	else
	{
		casulties = stackSize - stack.GetStackSize();

		if(casulties < 0 )
		{
			stack.SetStackSize( class'H7EffectContainer'.static.DoOperation( OP_TYPE_ADD, stack.GetStackSize(), casulties ) );
		}
	}

	if( mOverrideInitialStackSize && dif > 0 )
	{
		stack.SetInitialStackSize( stack.GetStackSize() );
	}

	if( stack.GetStackSize() <= 0 ) 
	{
		stack.Kill();
	}
}

protected function int GetStackSize( H7CreatureStack stack )
{
	return mUseInitialStackSize ? ( stack.GetBaseCreatureStack() != none ? stack.GetBaseCreatureStack().GetStackSize() : stack.GetInitialStackSize() ) : stack.GetStackSize();
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_MOD_SIZE","H7TooltipReplacement");
}

function String GetDefaultString()
{
	if(mOperationType == OP_TYPE_ADDPERCENT) return class'H7Effect'.static.GetHumanReadablePercent(mModifier/100.f); // 5 / 100 -> 0.05 factor --humanread--> 5% 
	else return class'H7GameUtility'.static.FloatToString(mModifier,true);
}

