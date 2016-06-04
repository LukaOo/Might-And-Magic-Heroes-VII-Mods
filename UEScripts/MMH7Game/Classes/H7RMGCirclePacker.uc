//=============================================================================
// H7RMGCirclePacker
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGCirclePacker extends Object
	native(RMG);

var Vector2D mCenter;

function float SizeSquared( Vector2D temp )
{
	return temp.X*temp.X + temp.Y*temp.Y;
}

function float DistanceToCenterSq( H7RMGZoneTemplate temp )
{
    return SizeSquared( temp.mPosition - mCenter );
}

function int Comparer( H7RMGZoneTemplate t1, H7RMGZoneTemplate t2 )
{
    local float d1;
    local float d2;

	d1 = DistanceToCenterSq(t1);
	d2 = DistanceToCenterSq(t2);

	return (d1-d2)*(-1);
}

event SortArray( array<H7RMGZoneTemplate> templates )
{
	templates.Sort( Comparer );
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
