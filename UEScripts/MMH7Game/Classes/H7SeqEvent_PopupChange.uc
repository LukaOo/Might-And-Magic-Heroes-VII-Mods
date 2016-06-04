// Player opened or closed a popup
class H7SeqEvent_PopupChange extends H7SeqEvent_PlayerEvent;

var(Properties) protected string mPopupName<DisplayName="Popup to monitor (empty means any popup not the townscreen,gamemenu,options,loadsave)">;

event bool CheckH7SeqEventActivate(H7EventParam evtParam)
{
	local H7PlayerEventParam param;
	if ( super.CheckH7SeqEventActivate(evtParam) )
	{
		param = H7PlayerEventParam(evtParam);
		if (param != none)
		{
			if(param.mPopupName == mPopupName 
				|| (mPopupName == "" && param.mPopupName != "aTownScreen" && param.mPopupName != "aGameMenu" && 
					param.mPopupName != "aOptionsMenu" && param.mPopupName != "aLoadSaveWindow"
					)
				) 
				return true;
		}
	}
	return false;
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

