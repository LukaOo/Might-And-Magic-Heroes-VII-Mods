//=============================================================================
// H7EffectSpecialManeuver
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectSpecialManeuver extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var(Maneuver) protected array<H7CreatureAbility> mInterruptThese<DisplayName=Interrupt Execution If Maneuverer has one of these Abilities|Tooltip=Useful for Preemptive Strike: Interrupt original Melee Attack to avoid Attacker hitting Empty Space>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CreatureStack attacker, maneuverer;
	local H7ICaster caster;
	local H7CombatMapCell destinationCell;
	local H7CommandQueue queue;
	local array<H7CombatMapCell> path;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7BaseAbility abi;
	local bool head;

	if( isSimulated )
	{
		return;
	}

	if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		;
		return;
	}

	if( H7BaseAbility( effect.GetSource() ) != none && H7BaseAbility( effect.GetSource() ).IsSuppressed() ) return;
	
	// we know it should be the mTargetOverwrite
	effect.GetTargets( targets );
	if(targets.Length == 0) return;

	target = targets[0];

	head = false;
	caster = container.EffectContainer.GetInitiator();
	attacker = H7CreatureStack( caster );
	if( attacker != none )
	{
		maneuverer = H7CreatureStack( target );
		if( maneuverer != none )
		{
			destinationCell = GetManeuverPosition( maneuverer, attacker );
			queue = class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue();

			// check if we can retaliate or if something suppressed it
			abi = maneuverer.GetAbilityManager().GetAbility(maneuverer.GetRetaliationAbility());
			if(abi != none && abi.IsSuppressed()) { return; }

			if( destinationCell != none )
			{
				//move and shoot (and maybe interrupt)
				maneuverer.GetPathfinder().GetPathByCell( destinationCell, path );
				head = CheckInterrupt(maneuverer);
				if(head)
				{
					// these will be backwards since each inserts to head
					// so we do     retaliate -> move -> interrupt
					// to get	    interrupt -> move -> retaliate
					queue.Enqueue( class'H7Command'.static.CreateCommand(
						maneuverer, UC_ABILITY, ACTION_RANGED_RETALIATE,
						maneuverer.GetAbilityManager().GetAbility(maneuverer.GetRangedAttackAbility()),
						attacker,, false,,,true ) );

					queue.Enqueue( class'H7Command'.static.CreateCommand( maneuverer, UC_MOVE, ACTION_MOVE,,,path, false,,,true ) );

					queue.Enqueue( class'H7Command'.static.CreateCommand( maneuverer, UC_ABILITY, ACTION_INTERRUPT,,attacker,,false,,,true) );

					// force end turn for interrupted unit
					// TODO make a buff or shit? this seems hackish :/
					ForceEndTurnForInterrupted( attacker );
				
				}
				else
				{
					// this is normal behaviour without interrupt
					queue.Enqueue( class'H7Command'.static.CreateCommand( maneuverer, UC_MOVE, ACTION_MOVE,,,path, false,,,true ) );
					queue.Enqueue( class'H7Command'.static.CreateCommand(
						maneuverer, UC_ABILITY, ACTION_RANGED_RETALIATE,
						maneuverer.GetAbilityManager().GetAbility(maneuverer.GetRangedAttackAbility()),
						attacker,, false,,,false ) );

				}
			}
			else
			{
				//regular retaliation
				queue.Enqueue( class'H7Command'.static.CreateCommand(
					maneuverer, UC_ABILITY, ACTION_RETALIATE,
					maneuverer.GetAbilityManager().GetAbility(maneuverer.GetMeleeAttackAbility()),
					attacker,, false,,,false ) );
				// no interrupt check necessary
			}
		}
	}
}

function ForceEndTurnForInterrupted(H7CreatureStack theInterrupted)
{
	theInterrupted.UseMove();
	theInterrupted.UseAttack();
}

function bool CheckInterrupt(H7CreatureStack maneuverer)
{
	local int i;

	for(i=0; i<mInterruptThese.Length; ++i)
	{
		if(mInterruptThese[i] == none) continue;

		if( maneuverer.GetAbilityManager().HasAbility( mInterruptThese[i] ))
		{
			return true;
		}
	}

	return false;
}

//Is this just fantasy? NOPE syntax error
function H7CombatMapCell GetManeuverPosition( H7CreatureStack maneuverer, H7CreatureStack attacker )
{
	local H7CombatMapGrid grid;
	local array<H7CombatMapCell> reachableCells, neighbourCells, validCells;
	local H7CombatMapCell tmpCell, closestCell, maneuvererCell;


	grid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();
	maneuvererCell = grid.GetCellByIntPoint( maneuverer.GetGridPosition() );
	neighbourCells = grid.GetNeighbourCells( grid.GetCellByIntPoint( attacker.GetGridPosition() ).GetMergedCells() );
	grid.GetAllReachableCells( maneuverer, reachableCells );
	foreach reachableCells( tmpCell )
	{
		if( neighbourCells.Find( tmpCell ) == INDEX_NONE && !tmpCell.HasUnit() )
		{
			validCells.AddItem( tmpCell );
		}
	}

	if( validCells.Length > 0 )
	{
		closestCell = validCells[0];
		foreach validCells( tmpCell )
		{
			if( Abs( tmpCell.mPosition.X - maneuvererCell.mPosition.X ) + Abs( tmpCell.mPosition.Y - maneuvererCell.mPosition.Y ) < Abs( closestCell.mPosition.X - maneuvererCell.mPosition.X ) + Abs( closestCell.mPosition.Y - maneuvererCell.mPosition.Y )  )
			{
				closestCell = tmpCell;
			}
		}
		return closestCell;
	}
	else
	{
		return none;
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_MANEUVER","H7TooltipReplacement");
}
