// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqAct_DeactivateEvent extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The Event to deactivate.
var(Properties) protected H7SeqCon_Event mEvent<DisplayName="Event">;

function Activated()
{
	if(mEvent != none && mEvent.GetStatus() == ES_ACTIVE )
	{
		mEvent.ForceActivateInput(4);
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

