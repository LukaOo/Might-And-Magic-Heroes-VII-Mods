//=============================================================================
// H7EffectFlanking
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectFlanking extends Object 
	implements(H7IEffectDelegate)
	hidecategories( Object )
	native(Tussi);

var() protected bool mOnlyAllowOnOwningAbility<DisplayName=Only trigger on owning Ability>;

var() protected float mFlankingMultiplier<DisplayName=Flanking Multipier>;
var() protected float mFullFlankingMultiplier<DisplayName=Full Flanking Multiplier>;

var protected H7CombatMapGridController mGridController;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	if( container.Result == none ) {;return;}

	if( mGridController == none ) mGridController = class'H7CombatMapGridController'.static.GetInstance();

	if( mGridController == none || container.Result.GetAttacker().GetOriginal().GetEntityType() != UNIT_CREATURESTACK ) {;return;}

	if( PreparedAbilityHasFlanking( effect ) && effect.GetSource().GetCaster().GetOriginal().GetPreparedAbility() == effect.GetSource())
	{
		CheckForFlanking( effect, container.Result , isSimulated );
	}
	else if( !mOnlyAllowOnOwningAbility )
	{
		CheckForFlanking( effect, container.Result, isSimulated );
	}
	else
	{
		;
		//`log_uss( String(PreparedAbilityHasFlanking( effect )) );
		//`log_uss( String(effect.GetSource().GetCaster().GetOriginal().GetPreparedAbility()) );
		//`log_uss( String(effect.GetSource()) );
	}
}

function bool PreparedAbilityHasFlanking( H7Effect effect )
{
	local array<H7Effect> effects;
	local H7Effect dasEffect;
	local bool flankingFound;

	if( effect.GetSource().GetCaster().GetOriginal().GetPreparedAbility() == none ) return false;

	effect.GetSource().GetCaster().GetOriginal().GetPreparedAbility().GetEffects( effects, effect.GetSource().GetCaster().GetOriginal() );

	foreach effects( dasEffect ) 
	{
		if( dasEffect.IsA( 'H7EffectSpecial' ) && H7EffectSpecial( dasEffect ).GetData().mTrigger.mTriggerType == effect.GetTrigger().mTriggerType )
		{
			//#coderswag
			//checks if the parent of the effect has flanking (self) assigned to it
			if( H7EffectSpecial( dasEffect ).GetData().mFunctionProvider.Class == self.Class )
			{
				flankingFound = true;
			}
		}
	}

	return flankingFound;
}

function CheckForFlanking( H7Effect effect, H7CombatResult result, bool simulate )
{
	local int i;
	local float multiplierBonus;
	local array<H7IEffectTargetable> targets;

	targets = result.GetDefenders();
	;

	for( i  = 0; i < targets.Length; ++i )
	{
		switch( CalculateFlankingType( result.GetAttacker().GetOriginal(), targets[i], multiplierBonus, simulate ) )
		{
			case FLANKING: AddMultiplier( MT_FLANK_HALF, result, i, multiplierBonus ); 
				break;
			case FULL_FLANKING: AddMultiplier( MT_FLANK_FULL, result, i, multiplierBonus ); 
				break;
			default:
				;
				break;
		}
	}
}

function EFlankingType CalculateFlankingType( H7ICaster attacker, H7IEffectTargetable target, out float multBonus, bool simulate )
{
	local array<H7CombatMapCell> mouseOverCells;
	local Rotator attackerkRot, defenderRot;
	local Vector attackerCenterPos;
	local float rotationDifference; // degrees
	local H7CreatureStack attackingStack;
	local H7CreatureStack targetStack;
 
	attackingStack = H7CreatureStack( attacker );
	targetStack = H7CreatureStack( target );
	
	if( targetStack == none || attackingStack == none ) return NO_FLANKING;

	mGridController.GetMovementPreviewCells( mouseOverCells );

	if( simulate && mouseOverCells.length > 0 )
	{
		attackerCenterPos = mouseOverCells[0].GetCenterPosBySize( attackingStack.GetUnitBaseSize() );
	}
	else
	{
		attackerCenterPos = attackingStack.Location;
	}
	
	// get multiplier bonus from attacker
	multBonus = attackingStack.GetModifiedStatByID(STAT_FLANKING_MULTIPLIER_BONUS);
	// remove the default value (1) from multiplier bonus (it's there for OP_ADD_PERCENT which would result in 0 if it's zero)
	multBonus = FClamp(multBonus - 1, -1.0f , MaxInt);

	attackerkRot = rotator(attackerCenterPos - targetStack.GetCreature().Location);
	defenderRot = targetStack.GetCreature().Rotation;
	rotationDifference = RDiff(attackerkRot, defenderRot);
	
	if( rotationDifference >= 140.f && targetStack.GetCreature().IsFullFlankable() )
	{
		return FULL_FLANKING;
	}
	else if( rotationDifference >= 85.f &&  targetStack.GetCreature().IsFlankable() )
	{
		return FLANKING;
	}

	return NO_FLANKING;
}

function AddMultiplier( H7MultiplierType multiplierType, H7CombatResult result, int index, float multBonus )
{
	local float multiplier;

	multiplier = multiplierType == MT_FLANK_HALF ? (mFlankingMultiplier + multBonus) : multiplierType == MT_FLANK_FULL ? (mFullFlankingMultiplier + multBonus) : 1.0f;

	result.AddMultiplier( multiplierType, multiplier, index );
}

function String GetTooltipReplacement() 
{ 
	return class'H7Loca'.static.LocalizeSave("TTR_FLANK","H7TooltipReplacement"); 
}

