//=============================================================================
// H7CouncilStatueActor
//=============================================================================
//
// Used on Council Map to show bonus for completing campaign (that is assign to it)
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilStatueActor extends H7CouncilInteractive
	placeable;

function ClickedOn()
{
	super.ClickedOn();
}

function MouseOverStart()
{
	super.MouseOverStart();

	// TODO show tooltip like prevON
}

function MouseOverStop()
{
	super.MouseOverStart();

	// TODO switch back to the selected map PrevON
}
