// Player set a path with Adventure hero
class H7SeqEvent_PathSet extends H7SeqEvent_PlayerEvent;

//var(Properties) protected string mPopupName<DisplayName="Popup to monitor">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		return true;
	}
	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

