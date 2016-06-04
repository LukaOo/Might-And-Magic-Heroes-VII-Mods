//=============================================================================
// H7AdventureObject
//=============================================================================
// Base class for adventure map objects
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureObject extends H7EditorMapObject
	implements(H7IQuestTarget)
	native
	dependson(H7StructsAndEnumsNative)
	placeable
	savegame;

var protected float frameCount;

var(Floating) protected bool mIsFloating<DisplayName=Is Floating>;
var(Floating) protected float mFloatRotationIntensity<DisplayName=Rotation intensity>;
var(Floating) protected float mFloatSwayIntensity<DisplayName=Sway intensity>;
var(Developer) const EPassabilityType mPassabilityType<DisplayName=Passability>;
var protected savegame int mID;
var protected vector mOriginalLocation;

function                    ClearQuestFlag()     {}
function                    AddQuestFlag()       {}    

function bool IsFloating()  { return mIsFloating; }
event String GetName() { return "Adventure Object"; }

event InitAdventureObject()
{
	class'H7AdventureController'.static.GetInstance().AddAdvObject( self );
	mOriginalLocation = Location;

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
	}
}

native function ReferenceSelfToCells();

native function GetCellsUnderMe( out array<H7AdventureMapCell> outCells );

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Role=ROLE_Authority;
}

function SetFloating( bool newFloating, float floatRot, float floatSway )
{
	mIsFloating = newFloating;
	mFloatRotationIntensity = floatRot;
	mFloatSwayIntensity = floatSway;
}

native function UpdateFloating( float deltaTime );

//function Tick( float deltaTime )
//{
//	super.Tick( deltaTime );

//	if( !(WorldInfo.TimeSeconds - LastRenderTime < 1.5f ) || bHidden )
//	{
//		return;
//	}	
	
//	UpdateFloating( deltaTime );
//}

// Implementation of H7IQuestTarget
function int GetQuestTargetID() { return mID; }
function H7AdventureMapCell GetCurrentPosition()
{
	return class'H7AdventureGridManager'.static.GetInstance().GetClosestGridToPosition(Location).GetCellByWorldLocation(Location);
}
function bool IsHidden() { return bHidden; }
function bool IsMovable() { return false; }

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

function OnVisit( out H7AdventureHero hero ) 
{ 
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}
function OnLeftClick() { }
function OnRightClick() { }
function OnDoubleClick() { }


