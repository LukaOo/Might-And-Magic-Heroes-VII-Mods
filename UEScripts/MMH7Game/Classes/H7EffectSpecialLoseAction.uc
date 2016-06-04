//=============================================================================
// H7EffectSpecialChangeMovementType
//
// Mechanic to change the movement type of a unit.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialLoseAction extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var(SkipTurn) bool	        mActiveUnit<DisplayName=Active Unit>;
var(SkipTurn) bool          mUseCustomDelay<DisplayName=Use Custom Skip Turn Delay (else Bad Morale Delay is used)>;
var(SkipTurn) bool          mNoDelay<DisplayName=Do not Use Delay|EditCondition=mUseCustomDelay>;
var(SkipTurn) float         mSkipTurnDelay<DisplayName=Delay in Seconds|EditCondition=mUseCustomDelay>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;

	if( isSimulated ) { return; }


	if( mActiveUnit )
	{
		if( !mNoDelay )
		{
			// do skip turn delay
			class'H7CombatController'.static.GetInstance().StartBadMoraleDelay( mUseCustomDelay ? mSkipTurnDelay : -1.f, true );
		}

		// set attack and move count to 0
		class'H7CombatController'.static.GetInstance().GetActiveUnit().ClearTurns();

		if( mNoDelay )
		{
			// no skip turn delay
			class'H7CombatController'.static.GetInstance().SetActiveUnitCommand_SkipTurn( false );
		}

		return;
	}

	// this is not affected by the delay since the dudes are removed from the current combat turn anyway
	effect.GetTargets( targets );
	foreach targets(target)
	{
		if(H7Unit(target) != none)
		{
			if(class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsARemainingUnit(H7Unit(target)))
			{
				class'H7CombatController'.static.GetInstance().GetInitiativeQueue().SkipUnitTurn(H7Unit(target));
			}
			else
			{
				H7Unit( target ).MarkForTurnSkip( true );
			}
		}
	}

	
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_LOSE_ACTION","H7TooltipReplacement");
}

