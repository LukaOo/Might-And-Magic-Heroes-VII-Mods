/*=============================================================================
 * H7SeqAct_ToggleCutscene
 * 
 * Enables/Disables cutscene mode (ex. gamespeed)
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/
class H7SeqAct_ToggleCutscene extends SequenceAction
	implements(H7IAliasable)
	native;

function Activated()
{
	local int i;

	for(i = 0; i < InputLinks.Length; ++i)
	{
		if(InputLinks[i].bHasImpulse)
		{
			if( InputLinks[i].LinkDesc == "Enable")
			{
				class'H7ReplicationInfo'.static.GetInstance().SetCutsceneMode(true);
				break;
			}
			else if ( InputLinks[i].LinkDesc == "Disable" )
			{
				class'H7ReplicationInfo'.static.GetInstance().SetCutsceneMode(false);
				break;
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


