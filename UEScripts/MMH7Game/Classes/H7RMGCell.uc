//=============================================================================
// H7RMGCell
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGCell extends Object
	native(RMG);

var private IntPoint                    mPosition;
var private Vector                      mLocation;

var private H7RMGCellPathfinderData     mPathfinderData;

var private array<H7RMGCell>            mNeighbours;
var private array<H7RMGCell>            mMergedCells;
var private H7RMGCell                   mMasterCell;

var private bool                        mIsBlocked;
var private bool                        mHasPickup; // has pickup, not reliable for other things
var private bool                        mHasNeighborPickup;
var private bool                        mHasVisibleRoad;
var private bool                        mHasInvisibleRoad;
var private bool                        mForcePassabiltiy;

var protectedwrite H7RMGZoneInfluence   mZoneInfluence;
var protectedwrite H7RMGBuilding        mBuilding;

var protectedwrite bool                 mIsAreaBorder;

function IntPoint GetPosition() { return mPosition; }
function Vector   GetCellLocation() { return mLocation; }

native function bool IsNextToBorder( int distance, H7RMGGrid grid );


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
