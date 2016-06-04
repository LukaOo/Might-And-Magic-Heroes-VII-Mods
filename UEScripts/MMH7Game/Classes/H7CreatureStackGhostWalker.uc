//=============================================================================
// H7CreatureStackGhostWalker
//=============================================================================
// Class that handles fading in/out of creatures with the movement type
// Ghostwalk. The movement itself is handled by H7CreatureStackMover.
//=============================================================================
// TODO:
// - Effect while walking through obstacles? (material fading,
// "smoke cloud" particles, none?)
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureStackGhostWalker extends H7CreatureStackMover;

var bool mWalkFXDone;

function Initialize(H7Unit stack)
{
	super.Initialize( stack );
}

function MoveStack(array<H7BaseCell> path, optional H7IEffectTargetable target)
{	
	mPath = GetSmoothPath(path);
}

function UpdateGhostMovement()
{
	local H7CombatMapCell cell;
	local bool enteredObstacle;
	local ParticleSystemComponent psc;

	cell = H7CombatMapCell(mPath[0].Cell);

	if(cell != none)
	{
		if( cell.GetObstacle() != none || H7CombatMapCell( mCurrentCell ).HasCreatureStack())
		{
			if(!enteredObstacle && !mWalkFXDone)
			{
				CreateMaterialFX();
				psc = WorldInfo.MyEmitterPool.SpawnEmitter( H7CreatureStack( mMovingStack ).GetCreature().GetGhostWalkParticleFX(), mMovingStack.Location, mMovingRepresentation.Rotation );
				class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( psc );
				mWalkFXDone = true;
				enteredObstacle = true;
			}
		}
		else
		{
			enteredObstacle=false;
		}
	}
}

function ResetWalkFX()
{
	local ParticleSystemComponent psc;
	psc = WorldInfo.MyEmitterPool.SpawnEmitter( H7CreatureStack( mMovingStack ).GetCreature().GetGhostWalkParticleFX(), mMovingStack.Location, mMovingRepresentation.Rotation );
	class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( psc );
	mWalkFXDone = false;
}

function CreateMaterialFX()
{
	local H7FXStruct effect;
	local float totalMoveTime;
	local float steadyFXtime;
	local H7Creature creature;

	totalMoveTime = (mSecPerField * mPath.Length);

	//the time the creature has a constand material fx
	steadyFXtime = totalMoveTime - (H7CreatureStack( mMovingStack ).GetCreature().GetVisuals().GetGhostWalkFadeDuration() * 2);

	//ensure there are no negative values
	if(steadyFXtime < 0)
	{
		steadyFXtime = 0;
	}

	effect.mMaterialFX.Add(1);

	effect.mMaterialFX[0].MaxEffectImpact = H7CreatureStack( mMovingStack ).GetCreature().GetVisuals().GetGhostWalkOpacity()/100.f;
	effect.mMaterialFX[0].FadeInEffectStartingtime = 0.f;
	effect.mMaterialFX[0].FadeOutEffectStartingTime = 0.f;
	effect.mMaterialFX[0].FadeInEffectLength = H7CreatureStack( mMovingStack ).GetCreature().GetVisuals().GetGhostWalkFadeDuration()/2;
	effect.mMaterialFX[0].FadeOutEffectLength = H7CreatureStack( mMovingStack ).GetCreature().GetVisuals().GetGhostWalkFadeDuration();
	effect.mMaterialFX[0].SteadyEffectTime = steadyFXtime;
	effect.mMaterialFX[0].GotMaterialFX = true;
	effect.mMaterialFX[0].MaterialParamName = EMP_Opacity;

	creature = H7CreatureStack( mMovingStack ).GetCreature();
			
	creature.StartSetEffectMaterialValues(effect);

	SetTimer(totalMoveTime, false,'ResetWalkFX');

	SetTimer(totalMoveTime - effect.mMaterialFX[0].FadeOutEffectLength, false,'TriggerOutcomeWalkFX');
}

state Walking
{
	simulated event BeginState(name previousStateName)
	{
		mMoveTime = 0.0f;
	}
}
