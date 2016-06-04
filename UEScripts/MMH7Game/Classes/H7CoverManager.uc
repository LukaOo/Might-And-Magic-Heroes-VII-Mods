//================================================ Might & Magic - Heroes VII =
// H7CoverManager
//=============================================================================
// Manager for the cover system using the line of sight
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CoverManager extends Actor;

var protected array<H7CombatMapCell> mCoverCells;
var protected H7CombatMapCell mTargetCell;
var protected H7UnitCoverManager mSelectedUnitCoverManager;

var protected Texture mCoveredTexture, mNotCoveredTexture;
var protected Vector savedCoverTarget;
var protected array<ParticleSystemComponent> coverLOSParticle;
var protected H7CreatureStack savedCoverCreature;

// references to controllers
var protected H7PlayerController mPlayerController;
var protected H7CombatController mCombatContoller;
var protected H7CombatMapGridController mGridController;

// properties Get/Set methods
// ==========================

// methods ...
// ===========

function PostBeginPlay()
{
	mPlayerController =  class'H7PlayerController'.static.GetPlayerController();
	mCombatContoller = class'H7CombatController'.static.GetInstance();
	mGridController = class'H7CombatMapGridController'.static.GetInstance();
}

event Tick(float deltaTime)
{
	local H7Unit activeUnit;
	local H7CreatureStack targetUnit;
	local array<H7CombatMapCell> mouseOverCells;
	local H7IEffectTargetable target;

	super.Tick(deltaTime);

	if( mPlayerController.IsUnrealAllowsInput() )
	{
		activeUnit = mCombatContoller.GetActiveUnit();
		if( activeUnit != none && activeUnit.GetEntityType() == UNIT_CREATURESTACK )
		{
			target = mGridController.GetCurrentHoverTarget();
			targetUnit = H7CreatureStack( target );

			if( mCombatContoller.GetCombatConfiguration().IsShowCoverSystemDebug() )
			{
				if( H7CreatureStack(activeUnit).GetCreature().IsRanged() && targetUnit != none && !targetUnit.IsDead() && activeUnit.GetCombatArmy() != targetUnit.GetCombatArmy() )
				{
					// active unit is range and is hovering over an enemy unit that is in cover -> show cover of the target unit
					ShowCreatureCover( targetUnit );
					return;
				}
			}

			if( targetUnit == activeUnit )
			{
				// hovering over the active unit -> show cover of the active unit
				ShowCreatureCover( H7CreatureStack(activeUnit) );
				return;
			}

			
			if( targetUnit == none)
			{
				// show cover of the active unit on the target position
				ShowCreatureCover( H7CreatureStack(activeUnit) );
				return;
			}
			else
			{
				mouseOverCells = mGridController.GetCurrentAttackPosition();
				if( mouseOverCells.Length > 0  )
				{
					// show cover of the active unit on the target position
					ShowCreatureCover( H7CreatureStack(activeUnit), mouseOverCells[0] );
					return;
				}
			}
		}
	}
	ClearCoverCells();
}

// lines that show the cone that is used to calculate the cover cells
function RenderDebugLines( Canvas myCanvas )
{
	local Vector startPos, endPos;
	local array<Vector> coverLines;
	local Vector linesOrigin, currentLine;
	local int redColor;
	local bool updateColor;

	if( mSelectedUnitCoverManager != none )
	{
		redColor = 255;
		updateColor = true;

		coverLines = mSelectedUnitCoverManager.GetCoverLines();
		linesOrigin = mSelectedUnitCoverManager.GetLinesOrigin();

		startPos = myCanvas.Project( linesOrigin );

		foreach coverLines( currentLine )
		{
			endPos = myCanvas.Project( linesOrigin + Normal(currentLine) * 1200.f );

			myCanvas.Draw2DLine( startPos.X , startPos.Y , endPos.X , endPos.Y , MakeColor(redColor,0,0,255) );

			updateColor = !updateColor;
			if( updateColor )
			{
				redColor -= 100;
			}
		}
	}
}

function RenderFX( Canvas myCanvas )
{
	local H7CreatureStack selectedCreature, currentCreature;
	local H7CombatArmy enemyArmy;
	local array<H7CreatureStack> enemyCreatures;
	local array<H7CombatMapCell> coverCells;
	local array<H7CombatMapCell> mouseOverCells;
	local Vector startLinePos, endLinePos, coverVelocity, coverKillBox, coverFireBounds, coverHeightAccel;
	local Color currentColor;
	local Texture currentTexture;
	local ParticleSystemComponent CoverParticle;
	//local Vector hitLocation;
	local H7IEffectTargetable target;

	if( mSelectedUnitCoverManager != none )
	{
		selectedCreature = mSelectedUnitCoverManager.GetOwner(); // TODO this shit might be none?!
		if( selectedCreature == none )
		{
			;
			ScriptTrace();
			return;
		}
		selectedCreature.GetCoverManager().GetCoverCells( mGridController.GetCurrentMouseOverCell() );
		enemyArmy = mCombatContoller.GetOpponentArmy( selectedCreature.GetCombatArmy() );
		enemyCreatures = enemyArmy.GetCreatureStacks();
		
		if (mSelectedUnitCoverManager.GetLinesOrigin() != savedCoverTarget || savedCoverCreature != selectedCreature)
		{
			ClearCoverParticles();
		}
		savedCoverCreature = selectedCreature;

		// show lines for active unit (from enemy range unit to the active unit)
		if( mCoverCells.Length > 0 )
		{
			foreach enemyCreatures( currentCreature )
			{
				if( currentCreature.GetCreature().IsRanged() && !currentCreature.IsDead() )
				{
					startLinePos = myCanvas.Project( mSelectedUnitCoverManager.GetLinesOrigin() );
					endLinePos = myCanvas.Project( currentCreature.Location );
					if( mSelectedUnitCoverManager.IsInCover( currentCreature.GetCell().GetMergedCells(), mCoverCells, mTargetCell ) )
					{
						currentColor = MakeColor(255,255,0,255) ;
						currentTexture = mCoveredTexture;
						if (mSelectedUnitCoverManager.GetLinesOrigin() != savedCoverTarget)
						{
							coverFireBounds = Vect(0,0,0);
							coverFireBounds.Z = (currentCreature.GetCreature().GetMeshCenter().Z - currentCreature.Location.Z) * 2.0f;
							CoverParticle = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'H7Effects.combat.PS_CoverArrow', currentCreature.Location + coverFireBounds, Rotator(mSelectedUnitCoverManager.GetLinesOrigin() - currentCreature.Location));
							if (CoverParticle != None)
							{
								class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( CoverParticle );
								coverVelocity = Vect(0, 0, 200.0f);
								coverVelocity.X = VSize(mSelectedUnitCoverManager.GetLinesOrigin() - currentCreature.Location) / 3.0f;
								CoverParticle.SetVectorParameter('Velocity', coverVelocity);
								coverKillBox.X = VSize(mSelectedUnitCoverManager.GetLinesOrigin() - currentCreature.Location) - (class'H7BaseCell'.const.CELL_SIZE * 1.5f);
								coverKillBox.Y = 50000.0f;
								coverKillBox.Z = 1000.0f;
								CoverParticle.SetVectorParameter('KillBox', coverKillBox);
								//CoverParticle.SetFloatParameter('Spawn', 0.5f + VSize(mSelectedUnitCoverManager.GetLinesOrigin() - currentCreature.Location) / 1920.0f);
								coverHeightAccel = Vect(0,0,0);
								coverHeightAccel.Z = -coverFireBounds.Z / 5.0f;
								CoverParticle.SetVectorParameter('AccelCorrection', coverHeightAccel);
								CoverParticle.ActivateSystem();
								coverLOSParticle.AddItem(CoverParticle);
							}
						}
					}
					else
					{
						currentColor = MakeColor(255,0,0,255);
						currentTexture = mNotCoveredTexture;
						if (mSelectedUnitCoverManager.GetLinesOrigin() != savedCoverTarget)
						{
							coverFireBounds = Vect(0,0,0);
							coverFireBounds.Z = (currentCreature.GetCreature().GetMeshCenter().Z - currentCreature.Location.Z) * 2.0f;
							CoverParticle = WorldInfo.MyEmitterPool.SpawnEmitter(ParticleSystem'H7Effects.combat.PS_UnCoverArrow', currentCreature.Location + coverFireBounds, Rotator(mSelectedUnitCoverManager.GetLinesOrigin() - currentCreature.Location));

							if (CoverParticle != None)
							{
								class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( CoverParticle );
								coverVelocity = Vect(0, 0, 200.0f);
								coverVelocity.X = VSize(mSelectedUnitCoverManager.GetLinesOrigin() - currentCreature.Location) / 3.0f;
								CoverParticle.SetVectorParameter('Velocity', coverVelocity);
								//CoverParticle.SetFloatParameter('Spawn', 1.0f + VSize(mSelectedUnitCoverManager.GetLinesOrigin() - currentCreature.Location) / 1920.0f);
								coverHeightAccel = Vect(0,0,0);
								coverHeightAccel.Z = -coverFireBounds.Z / 5.0f;
								CoverParticle.SetVectorParameter('AccelCorrection', coverHeightAccel);
								CoverParticle.ActivateSystem();
								CoverLOSParticle.AddItem(CoverParticle);
							}
						}
					}
				}
			}
		}
		else
		{
			ClearCoverParticles();
		}

		if( mCombatContoller.GetCombatConfiguration().IsShowCoverSystemDebug() )
		{
			// show lines for covered units if the active unit is range (from active unit to the covered enemy unit)
			if( selectedCreature == mCombatContoller.GetActiveUnit() && selectedCreature.GetCreature().IsRanged() )
			{
				mouseOverCells = mGridController.GetMouseOverCells();
				//target = mGridController.GetMouseOverTarget( hitLocation );
				target = mGridController.GetCurrentHoverTarget();
				if( H7CombatMapCell( target ) != none ) target = H7CombatMapCell( target ).GetUnit();
				if( H7Unit( target ) == none && mouseOverCells.Length > 1 )
				{
					mouseOverCells.Remove( mouseOverCells.Length-1, 1 );
					foreach enemyCreatures( currentCreature )
					{
						coverCells = currentCreature.GetCoverManager().GetCoverCells();
						if( coverCells.Length > 0 )
						{
							startLinePos = myCanvas.Project( currentCreature.Location + vect(0,0,100.f) );
							endLinePos = myCanvas.Project( mSelectedUnitCoverManager.GetLinesOrigin() + vect(0,0,100.f) );
							if( currentCreature.GetCoverManager().IsInCover( mouseOverCells ) )
							{
								currentColor = MakeColor(255,255,0,255) ;
								currentTexture = mCoveredTexture;
							}
							else
							{
								currentColor = MakeColor(255,0,0,255);
								currentTexture = mNotCoveredTexture;
							}
							myCanvas.DrawTextureLine( startLinePos, endLinePos, 0.f, 10.f, currentColor, currentTexture, 90.f, 155.f, 330.f, 200.f );
						}
					}
				}
			}
		}

		if (mSelectedUnitCoverManager.GetLinesOrigin() == Vect(0,0,0))
		{
			ClearCoverParticles();
		}
		savedCoverTarget = mSelectedUnitCoverManager.GetLinesOrigin();
	}
	else
	{
		ClearCoverParticles();
	}

	if( mCombatContoller.GetCombatConfiguration().IsShowCoverSystemDebug() )
	{
		RenderDebugLines( myCanvas );
	}
}

protected function ClearCoverParticles()
{
	local ParticleSystemComponent CoverParticle;
	local int i;

	for( i = CoverLOSParticle.Length - 1; i >= 0; --i )
	{
		CoverParticle = CoverLOSParticle[i];
		if (CoverParticle != None)
		{
			if( CoverParticle.Template == ParticleSystem'H7Effects.combat.PS_UnCoverArrow' || CoverParticle.Template == ParticleSystem'H7Effects.combat.PS_CoverArrow' )
			{
				CoverParticle.DeactivateSystem();
			}
			CoverParticle = None;
		}
		CoverLOSParticle.Remove( i, 1 );
	}
}

protected function ClearCoverCells()
{
	if( mCoverCells.Length == 0 )
	{
		return;
	}

	mCoverCells.Remove( 0, mCoverCells.Length );
	mSelectedUnitCoverManager = none;
}

protected function ShowCreatureCover( H7CreatureStack creature, optional H7CombatMapCell targetCell )
{
	local array<H7CombatMapCell> creatureCoverCells;

	
	mSelectedUnitCoverManager = creature.GetCoverManager();
	creatureCoverCells = mSelectedUnitCoverManager.GetCoverCells( targetCell );

	if( mCombatContoller.GetCombatConfiguration().IsShowCoverSystemDebug() )
	{
		// TODO: something else for showing cover as decal
	}

	// update the cover cells
	mCoverCells = creatureCoverCells;
	mTargetCell = targetCell;
}

