//=============================================================================
// H7EffectSpecialChangeMovementType
//
// Mechanic to change the movement type of a unit.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialChangeMovementType extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


/** Changes the movement type of the targeted creature(s). */
var(Movement) EMovementType mNewMovementType <DisplayName=New Movement Type|EditCondition=!mSetToOriginal>;
var(Movement) bool mSetToOriginal<DisplayName=Set To Original>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targetUnits;
	local H7IEffectTargetable targetUnit;

	if( isSimulated ) { return; }

	effect.GetTargets( targetUnits );
	
	if(targetUnits.Length > 0)
	{
		foreach targetUnits(targetUnit)
		{
			if(H7CreatureStack(targetUnit) != none)
			{
				if( mSetToOriginal )
				{
					H7CreatureStack( targetUnit ).SetMovementType( H7CreatureStack( targetUnit ).GetCreature().GetMovementType() );
				}
				else
				{
					// only allow walkers to be shrouded
					if( ( H7CreatureStack( targetUnit ).GetMovementType() != CMOVEMENT_WALK ) && mNewMovementType == CMOVEMENT_SHROUD  )
					{
						; // TODO: check JUMP movement type
						return;
					}
					else
					{
						H7CreatureStack( targetUnit ).SetMovementType(mNewMovementType);
					}
				}
				
				;
				// reachable cells might change (for instance, on a siege map a unit that had flying has suddenly walking, the cells behind the wall shouldn't
				// have a highlight anymore)
				if( class'H7CombatController'.static.GetInstance() != none && class'H7CombatController'.static.GetInstance().GetActiveUnit() == targetUnit )
				{
					class'H7CombatMapGridController'.static.GetInstance().RecalculateReachableCells();
				}
			}
		}
	}
	else
	{
		;
	}
}


function String GetTooltipReplacement() 
{	
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_REFUND_MANA","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%movetype", mNewMovementType);
	return ttMessage;
}
