//=============================================================================
// H7Math
//=============================================================================
//
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7Math extends Object native
	dependson( H7GameUtility );

static function int GetRotationDiff(int rot1, int rot2)
{
	local Rotator r1, r2;

	r1.Yaw = rot1;
	r2.Yaw = rot2;

	return ( RDiff(r1,r2) * DegToUnrRot );
}

static function float GetDistance(Vector a, vector b)
{
	return VSize(a-b);  
}

static function float GetDistanceIntPoints( IntPoint a, IntPoint b )
{
	local Vector distanceVector;

	distanceVector.X = ( a.X - b.X );
	distanceVector.Y = ( a.Y - b.Y );

	return VSize( distanceVector );  
}

static native function float GetDiagonalShortcutDistanceIntPoints( IntPoint a, IntPoint b );

static native function float GetDistanceIntPointsP( IntPoint a, IntPoint b, float p );

// convert the degree to 15bit fixed point value
static function int ConvertDegreeToUnrealDegree( float Degree )
{
	return ( DegToUnrRot * Degree );
}

/**
 * Calculates a "matrix index" for a 1-dimensional array,
 * which pretends to be a matrix (with a length x*y).
 * 
 * @param       x       Column index
 * @param       y       Row index
 * @param       xSize   Column length
 * 
 * @return      The index of a 1-dimensional array that is acting as a matrix
 * 
 * */
static native function int CalcMatrixIndex(int x, int y, int xSize);

/**
 * Reverse-engineers a 1-dimensional array index into
 * x and y coordinates, presented as in IntPoint.
 * 
 * @param       index   1-dimensional array index
 * @param       xSize   Column length
 * 
 * @return      The indexes of a 2-dimensional array as an IntPoint
 * 
 * */
static native function IntPoint CalcIntPointFromMatrixIndex( int index, int xSize );

/**
 * Calculates an intersection point between two
 * lines that are defined with two points.
 * 
 * @param       A1          First point of first line      
 * @param       A2          Second point of first line  
 * @param       B1          First point of second line
 * @param       B2          Second point of second line
 * @param       AB          Intersection point as "out" variable
 * 
 * @return      If the intersection was successful
 * 
 * */
static native function bool CalcLineIntersection( IntPoint A1, IntPoint A2, IntPoint B1, IntPoint B2, out IntPoint AB );

/**
 * Provides a cell array parameter with cells that run from
 * the origin cell until the target cell. Uses a supercover
 * line algorithm based on Bresenham's line algorithm:
 * http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
 * 
 * @param   lineCells       Combat map cell array that will hold the resulting cells that are covered by the line
 * @param   originPoint     The starting point
 * @param   targetPoint     The target point
 * 
 * */
static function GetLineCellsSuperCover( out array<H7CombatMapCell> lineCells, IntPoint originPoint, IntPoint targetPoint )
{
	local int i, xStep, yStep, error, prevError, x, y, dx, dy, ddx, ddy;
	local H7CombatMapGrid grid;

	grid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();
	x = originPoint.X;
	y = originPoint.Y;
	dx = targetPoint.X - x;
	dy = targetPoint.Y - y;
	if( dx < 0 )
	{  
		xStep = -1;
		dx = -dx;
	}
	else
	{
		xStep = 1;
	}

	if( dy < 0 )
	{
		yStep = -1;
		dy = -dy;
	}
	else
	{
		yStep = 1;
	}
	
	ddx = 2 * dx;
	ddy = 2 * dy;

	if( ddx >= ddy )
	{
		error = dx;
		prevError = error;
		for( i = 0; i < dx; i++ )
		{
			x += xStep;
			error += ddy;
			if( error > ddx )
			{
				y += yStep;
				error -= ddx;
				if( error + prevError < ddx )
				{
					lineCells.AddItem( grid.GetCellByPos( x, y - yStep ) );
				}
				else if( error + prevError > ddx )
				{
					lineCells.AddItem( grid.GetCellByPos( x - xStep, y ) );
				}
				else
				{
					lineCells.AddItem( grid.GetCellByPos( x - xStep, y ) );
					lineCells.AddItem( grid.GetCellByPos( x, y - yStep ) );
				}
			}
			lineCells.AddItem( grid.GetCellByPos( x, y ) );
			prevError = error;
		}
	}
	else
	{
		error = dy;
		prevError = error;
		for( i = 0; i < dy; i++ )
		{
			y += yStep;
			error += ddx;
			if( error > ddy )
			{
				x += xStep;
				error -= ddy;
				if( error + prevError < ddy )
				{

					lineCells.AddItem( grid.GetCellByPos( x - xStep, y ) );
				}
				else if( error + prevError > ddy )
				{
					lineCells.AddItem( grid.GetCellByPos( x, y - yStep ) );
				}
				else
				{
					lineCells.AddItem( grid.GetCellByPos( x - xStep, y ) );
					lineCells.AddItem( grid.GetCellByPos( x, y - yStep ) );
				}
			}
			lineCells.AddItem( grid.GetCellByPos( x, y ) );
			prevError = error;
		}
	}
}

/**
 * Provides a cell array parameter with cells that run from
 * the origin cell until the target cell. Uses Bresenham's 
 * line algorithm:
 * http://en.wikipedia.org/wiki/Bresenham%27s_line_algorithm
 * 
 * @param   lineCells       Combat map cell array that will hold the resulting cells that are covered by the line
 * @param   originPoint     The starting point
 * @param   targetPoint     The target point
 * 
 * */
native static function GetLineCellsBresenham( out array<H7CombatMapCell> lineCells, IntPoint originPoint, IntPoint targetPoint );

native static function int GetLineCellsLengthBresenham( IntPoint originPoint, IntPoint targetPoint );

/**
 * Calculates points visible around a central point within a 
 * given radius. Uses the Midpoint Circle Algorithm:
 * http://en.wikipedia.org/wiki/Midpoint_circle_algorithm
 * 
 * @param       centerPoint The central point
 * @param       r           The radius
 * 
 * @return      Returns the points that are located within, 
 *              or on the circle
 * 
 * */
static native function GetMidPointCirclePoints( out array<IntPoint> outPoints, IntPoint centerPoint, int r );

static native function bool CheckPointInCircle( IntPoint centerPoint, IntPoint checkPoint, int r );

/**
 * Gets points going as a spiral from the specified center point
 * based on provided dimensions. Also works for non-square dimensions,
 * such as 3x4 etc.
 * 
 * @param       centerPoint The central point
 * @param       dimensions  The x and y dimensions of the spiral
 * 
 * @return      Returns the points spiralling around the center point with the center point included
 * 
 * */
static native function GetSpiralIntPointsByDimension( out array<IntPoint> outPoints, IntPoint centerPoint, IntPoint dimensions );

/**
 * Calculates points visible around a central point within two given 
 * radii. Basing on the Bresenham Algorihm:
 * http://de.wikipedia.org/wiki/Bresenham-Algorithmus
 * 
 * @param   centerPoint The central point
 * @param   r1 horizontal radius of the ellipse
 * @param   r2 vertical radius of the ellipse
 * 
 * @return  Returns the points that are located on the ellipse
 * */
static native function GetPointsOnEllipse( out array<IntPoint> outPoints, IntPoint centerPoint, int r1, int r2 );

/**
 * Gets cells in a rectangle from the grid based on a center point and the
 * rectangle dimensions (X&Y) in IntPoint form
 * 
 * @param targetPoint   The central point
 * @param dim           The dimensions of the rectangle
 * 
 * */
native static function GetPointsFromDimensions( out array<IntPoint> outPoints, IntPoint targetPoint, IntPoint dim, int gridSizeX, int gridSizeY, optional ECellSize originSize = CELLSIZE_1x1, optional bool filled = true );

/**
 * Gets cells in a the shape specified as offsets from the targetCell
 * 
 * @param targetPoint    The central cell
 * @param shape         The offsets from the central point from which to draw the shape
 * 
 * */
native static function GetPointsFromShape( out array<IntPoint> outPoints, IntPoint targetPoint, array<IntPoint> shape, int gridSizeX, int gridSizeY, optional ECellSize originSize = CELLSIZE_1x1 );

/**
 * Re-maps a number from one range to another.
 * 
 * @param value The incoming value to be converted
 * @param start1 Lower bound of the value's current range
 * @param stop1 Upper bound of the value's current range
 * @param start2 Lower bound of the value's target range
 * @param stop2 Upper bound of the value's target range
 * 
 */
static native function float Map( float value, float start1, float stop1, float start2, float stop2 );

/**
 * Calculates the intersection point between a line and a plane. Copied from UDKMOBA!
 *
 * @param		LineA					Point A representing the start or end of the line
 * @param		LineB					Point B representing the start or end of the line
 * @param		PlanePoint				Point somewhere on the plane
 * @param		PlaneNormal				Normal of the plane
 * @param		IntersectionPoint		Intersection point where the line intersects with the plane
 * @return								Returns true if there was an interesection between the line and the plane
 * @network								All
 */
static function bool LinePlaneIntersection(Vector LineA, Vector LineB, Vector PlanePoint, Vector PlaneNormal, out Vector IntersectionPoint)
{
	local Vector U, W;
	local float D, N, sI;

	U = LineB - LineA;
	W = LineA - PlanePoint;

    D = PlaneNormal dot U;
    N = (PlaneNormal dot W) * -1.f;

    if (Abs(D) < 0.000001f)
	{
		return false;
	}

	sI = N / D;
	if (sI < 0.f || sI > 1.f)
	{
		return false;
	}

	IntersectionPoint = LineA + sI * U;
	return true;
}

static native function float NChooseR(int n, int r );

static native function Vector Bezier(float t, array<Vector> controlPoints );

static native function GetPointsOnCircle( out array<IntPoint> outPoints, IntPoint center, int radius );

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
