/*=============================================================================
 * H7SeqAct_MoveTo
 * 
 * Abtract base class for movement actions
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_MoveTo extends H7SeqAct_LatentArmyAction
	abstract
	native;

/** The army only moves as long as it has enough movement points */
var(Properties) protected bool mUseMovementPoints<DisplayName="Use Movement Points">;
/** Teleport instantly to the target instead of moving */
var(Properties) protected bool mTeleport<DisplayName="Teleport">;
/** Let the camera follow the movement or not */
var(Properties) protected bool mCamFollow<DisplayName="Camera follows">;

function bool IsMovingNearTarget() { return false; }
function bool IsUsingMovementPoints() { return mUseMovementPoints; }
function bool IsTeleporting() { return mTeleport; }
function bool IsCamFollowing() { return mCamFollow; }

function H7AdventureMapCell GetTargetCell()
{
	return none;	// Implement in child classes
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

