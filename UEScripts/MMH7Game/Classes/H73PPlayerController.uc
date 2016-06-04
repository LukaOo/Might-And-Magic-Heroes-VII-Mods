class H73PPlayerController extends H7AdventurePlayerController;

var Vector mCurrFreeMoveDir;

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	InitSetup();
	SetTimer(1.0f, false, 'InitSetup');
}

function InitSetup()
{
	ConsoleCommand("FOV 40");
}

event PlayerTick( float DeltaTime )
{
	super.PlayerTick(DeltaTime);

	FreeMoveArmy(DeltaTime);
}

function float GetPanningVertical()
{
	local float pan;

	pan = super.GetPanningVertical();
	mCurrFreeMoveDir.Y = -pan;

	return 0;
}

function float GetPanningHorizontal()
{
	local float pan;

	pan = super.GetPanningHorizontal();
	mCurrFreeMoveDir.X = pan;

	return 0;
}

function FreeMoveArmy( float DeltaTime )
{
	local H7AdventureArmy currArmy;
	local H7AdventureHero currHero;
	local H7AdventureMapCell currCell, targetCell;
	local H7AdventureGridManager gridManager;
	local Vector FinalMoveDir, HitLocation, HitNormal;
	local Rotator OffsetRot;
	local Actor TraceGround;

	currArmy = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();
	if (currArmy == None)
		return;

	currHero = currArmy.GetHero();
	if (currHero == None)
		return;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	if (gridManager == None)
		return;

	class'H7Camera'.static.GetInstance().SetFocusActor( currHero, , true );	

	if (VSize(mCurrFreeMoveDir) > 0)
	{
		OffsetRot.Yaw = 65536/4;
		OffsetRot += class'H7Camera'.static.GetInstance().Rotation;
		FinalMoveDir = TransformVectorByRotation(OffsetRot, mCurrFreeMoveDir);
		FinalMoveDir.Z = 0;
		FinalMoveDir *= 2000.0f * DeltaTime; // Speed of the Hero
		currHero.SetRotation(RLerp(currHero.Rotation, Rotator(Normal(FinalMoveDir)), 0.3f, true));

		currHero.SetPhysics(PHYS_Walking);
		currCell = gridManager.GetCellByWorldLocation(currArmy.Location);
		targetCell = gridManager.GetCellByWorldLocation(currArmy.Location + FinalMoveDir);
		//DrawDebugSphere(targetCell.GetLocation(), 40, 4, 255,0,0,false);

		if( currCell == targetCell || !targetCell.IsBlocked() )
		{
			TraceGround = Trace(HitLocation, HitNormal, currArmy.Location + FinalMoveDir + Vect(0,0,-200), currArmy.Location + FinalMoveDir + Vect(0,0,200), true);
			if (TraceGround != None)
			{
				//DrawDebugSphere(HitLocation, 50, 4, 255,0,0, false);
				FinalMoveDir = HitLocation + Vect(0,0,10);
			}
			else
			{
				FinalMoveDir = currArmy.Location + FinalMoveDir;
			}
			currHero.SetLocation(FinalMoveDir);
			currArmy.SetCell(targetCell, false);

			currHero.GetAnimControl().PlayAnim( HA_MOVE );
		}
		else
		{
			currHero.GetAnimControl().PlayAnim( HA_IDLE );
			if (targetCell.GetArmy() != None)
			{
			}
			else if (targetCell.GetVisitableSite() != None)
			{
				targetCell.GetVisitableSite().OnVisit( currHero );
			}
		}
	}
	else if (currHero.Physics != PHYS_Interpolating)
	{
		currHero.GetAnimControl().PlayAnim( HA_IDLE );
		currHero.SetPhysics(PHYS_Interpolating);
	}
}
