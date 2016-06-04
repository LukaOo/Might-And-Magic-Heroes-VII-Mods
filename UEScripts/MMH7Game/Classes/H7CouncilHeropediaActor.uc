//=============================================================================
// H7CouncilHeropediaActor
//=============================================================================
//
// Used on Council Map to represent maps in Selected Campaign
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilHeropediaActor extends H7CouncilInteractive
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
