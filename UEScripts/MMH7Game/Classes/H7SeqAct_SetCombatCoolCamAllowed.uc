/*=============================================================================
 * H7SeqAct_SetCombatCoolCamAllowed

 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_SetCombatCoolCamAllowed extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/* Enable or disable the combat cool cam. */
var(Properties) protected bool mCoolCamCombatActionAllowed<DisplayName="Combat CoolCam Allowed">;

function Activated()
{
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().SetCoolCamCombatActionAllowed(mCoolCamCombatActionAllowed);
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

