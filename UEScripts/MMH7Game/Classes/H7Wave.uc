//=============================================================================
// H7Wave
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Wave extends Actor
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	dependson( H7StructsAndEnumsNative );


/** Movement speed of the projectile **/
var(projectile) protected float                             mMovementSpeed<DisplayName=Movement speed>;
var(projectile) protected ParticleSystemComponent           mProjectileFX<DisplayName=Wave particle effect>;
// Trajectory variables
var protected Vector                                        mStartPos;
var protected Vector                                        mTargetPos;
var protected Vector                                        mMovementDir;

var protected array<H7IEffectTargetable>                    mAffectedTargets;
var protected array<H7IEffectTargetable>                    mHitTargets;

var protected H7CombatMapCell                               mPosCell;
var protected bool                                          mFinished;


delegate OnHitFunc( H7IEffectTargetable unit ){}
delegate OnNextColum( array<H7CombatMapCell> cells ){}

function InitWave( Vector startPos,Vector targetPos,  array<H7IEffectTargetable> affectedTargets, optional delegate<OnHitFunc> onHitExternal, optional delegate<OnNextColum> onNextCol  )
{
	mAffectedTargets = affectedTargets;
	mTargetPos = targetPos;
	mStartPos = startPos;
	OnHitFunc = onHitExternal;
	OnNextColum = onNextCol;
	mFinished = false;

	mMovementDir = Normal( mTargetPos - mStartPos );
	
	SetRotation( Rotator( mMovementDir ) );

	if( mProjectileFX != none )
	{
		AttachComponent( mProjectileFX );
		mProjectileFX.ActivateSystem();
	}
}

event Tick( float deltaTime )
{
	CustomTimeDilation = class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();

	super.Tick( deltaTime );

	Update(deltaTime);
}


function Update(float deltatime)
{
	local Vector newMovementDir;
	local H7CombatMapGridController gridController;
	local H7CombatMapCell newPos;
	local array<H7CombatMapCell> currAffectedCells;
	local int i;

	gridController = class'H7CombatMapGridController'.static.GetInstance();

	Move( mMovementDir * mMovementSpeed * deltaTime );
	newMovementDir = Normal( mTargetPos - Location );
	
	newPos = gridController.GetCell( Location );

	// only when position changes
	if( newPos != none && newPos!= mPosCell )
	{
		mPosCell = newPos;
		gridController.GetCellsInColumn (currAffectedCells, mPosCell ); 
		
		if ( currAffectedCells.Length > 0 ) 
		{
			for ( i=0; i<currAffectedCells.Length; ++i)
			{
				CheckHit( currAffectedCells[i].GetTargetable() );
			}
		}

		OnNextColum(currAffectedCells);
	}	
	
	// check if reached the target position
	if( !mFinished && ( (mMovementDir.X > 0 && newMovementDir.X < 0) || (mMovementDir.X < 0 && newMovementDir.X > 0) || 
		(mMovementDir.Y > 0 && newMovementDir.Y < 0) || (mMovementDir.Y < 0 && newMovementDir.Y > 0) ) )
	{
		Finish();
	}
}

protected function MoveCasualties( Vector dir ) 
{
	local H7IEffectTargetable hitTarget;
	local H7CreatureStack stack;

	foreach mHitTargets( hitTarget ) 
	{
		stack = H7CreatureStack( hitTarget ) ;
		if( stack != none ) 
		{
			stack.GetMovementControl().LerpStackToLocation( dir );
		}
	}

}

protected function CheckHit(H7IEffectTargetable target)
{
	if( target == none )
		return; 

	if( target != none && mAffectedTargets.Find( target ) != -1 && mHitTargets.Find( target ) == -1 )
	{
		// add hit target to hit units list to not hit them mutliple times
		mHitTargets.AddItem( target );
		// call hit on currently passing unit
		OnHitFunc( target );
	}
}

protected function Finish()
{
	mFinished = true;
	class'H7CombatController'.static.GetInstance().RefreshAllUnits();
	class'H7CombatMapGridController'.static.GetInstance().RecalculateReachableCells();
	FinishParticleFX();
}

protected function FinishParticleFX()
{
	if(mProjectileFX != none)
	{
		mProjectileFX.DeactivateSystem();
	}
}
