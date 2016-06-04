class H7SeqEvent_PlayerWinLoseGame extends H7SeqEvent_PlayerEvent
	native;

//actually, there is no other conditions to check.
event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	return super.CheckH7SeqEventActivate(evtParam);
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

