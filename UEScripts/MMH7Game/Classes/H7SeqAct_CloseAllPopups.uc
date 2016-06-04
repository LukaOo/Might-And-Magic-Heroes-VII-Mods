//=============================================================================
// H7SeqAct_CloseAllPopups
//=============================================================================
// Kismet action to close all the current popup/townscreen and go back to adv map
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SeqAct_CloseAllPopups extends SequenceAction;

event Activated()
{
	if(class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().IsVisible())
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Kismet can not close request popups",MD_SIDE_BAR);;
		return;
	}

	class'H7PlayerController'.static.GetPlayerController().GetHUD().CloseCurrentPopup();
	
	if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInAnyScreen())
	{
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().Leave();
	}
}

