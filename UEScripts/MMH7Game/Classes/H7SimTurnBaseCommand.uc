//=============================================================================
// H7SimTurnBaseCommand
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SimTurnBaseCommand extends Object
	dependson(H7StructsAndEnumsNative);

var protected H7SimTurnCommandManager mSimTurnCommandManager; // reference to the H7SimTurnCommandManager
var protected H7CombatPlayerController mSender;

function SetSimTurnCommandManager( H7SimTurnCommandManager newManager ) { mSimTurnCommandManager = newManager; }
function SetSender( H7CombatPlayerController newSender ) { mSender = newSender; }

function H7CombatPlayerController GetSender() { return mSender; }

function bool CanBeExecuted(){ return false; }
function ExecuteCommand() {}

// if the conditions of the command are different in the server than the sender of the command -> cancel it and send cancel's reason to the sender
function bool CancelCommandIfIlegal() { return false; }

function int GetSourceId() { return -1; }
function int GetTargetId() { return -1; }

function bool IsRetreat( int targetId ) { return false; }

function UpdateTradeFinished( H7AdventureHero target ){}

function string GetDebugInfo() { return "This should not be instanciated."; }

// returns true if the command is a ICT_DO_COMBAT normal combat (quick combat not included)
function bool IsDoNormalCombat(){ return false; }

// ignoreDistanceDetection -> will return true if any army is currently moving
protected function bool IsAnyoneMovingAround( Vector initialPos, Vector targetPos, optional bool ignoreDistanceDetection )
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local float safeDistance;
	local array<H7AdventureMapCell> path;

	armies = class'H7AdventureController'.static.GetInstance().GetArmies();
	foreach armies( army ) 
	{
		if( army.GetHero().IsMoving() )
		{
			// Example: safe case -> if the army will use a teleporter and there is at least another army moving -> conflict
			if( ignoreDistanceDetection )
			{
				return true;
			}

			safeDistance = VSize( targetPos - initialPos );
			if( army.GetHero().GetCurrentPath().length > 0 )
			{
				// safe case: armies that will use a teleport will conflict with everyone
				if( HasThePathATeleporter( army.GetHero().GetCurrentPath() ) )
				{
					return true;
				}
				path = army.GetHero().GetCurrentPath();
				safeDistance += VSize( path[path.Length-1].GetLocation() - army.GetHero().GetCell().GetLocation() );
			}
			safeDistance += class'H7BaseCell'.const.CELL_SIZE * 4.f; // safe margin
			if( VSize( initialPos - army.GetHero().GetCell().GetLocation() ) < safeDistance )
			{
				return true;
			}
		}
	}

	return false;
}

protected function bool HasThePathATeleporter( array<H7BaseCell> path )
{
	local H7BaseCell cell;
	local H7AdventureMapCell advCell;

	foreach path( cell )
	{
		advCell = H7AdventureMapCell(cell); // should always be adventurecells because the simturn is only used in the adventure map
		if( advCell.GetVisitableSite() != none && H7Teleporter(advCell.GetVisitableSite()) != none )
		{
			return true;
		}
	}
	return false;
}
