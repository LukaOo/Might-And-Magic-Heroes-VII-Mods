//=============================================================================
// H7CouncilInteractive
//=============================================================================
//
// Used on Council Map for actors that perform actions on interaction
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilInteractive extends StaticMeshActor
	abstract
	placeable;

var protected bool mMouseOver;

function bool IsMouseOver() { return mMouseOver; } 

function Hide()
{
	SetHidden(true);
	SetCollisionType(COLLIDE_NoCollision);
}

function Show()
{
	SetHidden(false);
	SetCollisionType(COLLIDE_BlockAll);
}

function EnableOutline(optional Color outlineColor = MakeColor(0, 0, 0) )
{
	StaticMeshComponent.SetOutlined(true);
	if(outlineColor != MakeColor(0, 0, 0))
	{
		StaticMeshComponent.SetOutlineColor(outlineColor);
	}
}

function DisableOutline() 
{
	StaticMeshComponent.SetOutlined(false);
}

// Called when actor is clicked (has to be called by tracer)
function ClickedOn()
{
	
}

// Called when mouse is over actor (first frame)
function MouseOverStart()
{
	mMouseOver = true;
}

// Called when mouse is not over actor anymore (first frame)
function MouseOverStop()
{
	mMouseOver = false;
}


	// WorldInfo.AddOnScreenDebugMessage(-1, 3.0f, MakeColor(255, 0, 0, 255) , "Some text." );
