//=============================================================================
// H7CouncilLampActor
//=============================================================================
//
// Used on Council Map to enable/disable map effects
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilLampActor extends H7CouncilInteractive
	placeable;

function ClickedOn()
{
	super.ClickedOn();
}

function MouseOverStart()
{
	super.MouseOverStart();

	//EnableOutline();
}

function MouseOverStop()
{
	super.MouseOverStart();

	//DisableOutline();
}
