//=============================================================================
// H7CombatMapPathPreviewer
//
//
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatMapPathPreviewer extends H7BasePathPreviewer;

var int PREVIEW_DOTS_PER_CELL;
var int mCurveMaxSteps;
var int mCurveDivision;

function ShowPreview(array<H7CombatMapCell> path, ECellSize size)
{
	local array<Vector> smoothPath;
	local Vector currentPos;
	local Rotator decalRot;
	local H7PathDot dot;
	local H7CombatMapCell cell;
	local int smoothIndex, cellIndex;

	HidePreview();
	if( class'H7PlayerController'.static.GetPlayerController().IsInCinematicView() || class'H7ReplicationInfo'.static.GetInstance().GetCommandQueue().IsCommandRunning()  )
	{
		return;
	}

	smoothPath = GetSmoothPath(path, size);
	
	if( smoothPath.Length <= 1 ) return;

	for(smoothIndex = 0; smoothIndex < smoothPath.Length; smoothIndex++)
	{
		cellIndex = Round(smoothIndex * (float(path.Length - 1)/float(smoothPath.Length - 1)));
		cell = path[cellIndex];

		currentPos = smoothPath[smoothIndex];
		currentPos.Z = cell.GetLocation().Z + DECAL_OFFSET;
		decalRot = cell.GetRotation();

		if( mUnusedDots.Length > 0 )
		{
			dot = mUnusedDots[0];

			dot.SetHidden( false );
			dot.SetLocation( currentPos );
			dot.SetRotation( decalRot );
			mUsedDots.AddItem( dot );
			mUnusedDots.RemoveItem( dot );
		}
		else
		{
			dot = Spawn(class'H7PathDot', self, ,currentPos, decalRot);
			dot.SetMaterial( MaterialInterface'FX_Units.Adventure.M_PathSpot' );
			dot.SetProjectOnAll();
			dot.SetDimensions();
			
			dot.SetHidden( false );
			mUsedDots.AddItem( dot );
		}
	}
}

protected function array<Vector> GetSmoothPath(array<H7CombatMapCell> path, ECellSize size)
{
	local array<Vector> smoothPath;
	local array<Vector> controlPoints, chunkPoints;
	//local H7CombatMapCell cell;
	local Vector bezierPoint;
	local float t;
	local int i, j, totalDots, dotsPerCell, dotShortIndex, chunkDots;

	for(i = 0; i < path.Length; i++)
	{
		controlPoints.AddItem(path[i].GetCenterPosBySize(size, false));
		if (i + 1 < path.Length)
		{
			for (j = 1; j < mCurveDivision; j++)
			{
				controlPoints.AddItem( VLerp(path[i].GetCenterPosBySize(size, false), path[i+1].GetCenterPosBySize(size, false), float(j) / float(mCurveDivision)) );
			}
		}
	}

	dotsPerCell = PREVIEW_DOTS_PER_CELL / mCurveDivision;
	totalDots = (dotsPerCell * controlPoints.Length) - dotsPerCell;

	dotShortIndex = 1;
	for(i = 1; i <= totalDots; i++)
	{
		// calculate the bezier curve with a chunk of only as much as mCurveMaxSteps points
		chunkPoints = controlPoints;
		if (chunkPoints.Length > mCurveMaxSteps)
			chunkPoints.Length = mCurveMaxSteps;

		chunkDots = dotsPerCell * (chunkPoints.Length - 1);

		t = float(dotShortIndex) / float(chunkDots);
		bezierPoint = class'H7Math'.static.Bezier(t, chunkPoints);

		//`log(i$", "$dotShortIndex$", "$chunkPoints.Length$", "$chunkDots$", "$t);
		//DrawDebugSphere(bezierPoint, 10, 4, 255,0,0, true);

		smoothPath.AddItem(bezierPoint);

		// rearrange the path chunk for the next iteration
		if (i % dotsPerCell == 0)
		{
			//`log("rearranging path "$dotShortIndex$" >= "$chunkPoints.Length * dotsPerCell / 2);
			if (dotShortIndex >= chunkPoints.Length * dotsPerCell / 2)
			{
				controlPoints.Remove(0, 1);
				dotShortIndex -= dotsPerCell;
			}
		}
		dotShortIndex++;
	}

	return smoothPath;
}

