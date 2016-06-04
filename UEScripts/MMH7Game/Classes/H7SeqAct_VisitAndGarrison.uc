/*=============================================================================
 * H7SeqAct_VisitAndGarrison
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_VisitAndGarrison extends SequenceAction
	implements(H7IRandomPropertyOwner)
	native
	savegame;

// Building to visit and garrison
var(Properties) savegame H7AreaOfControlSite mInteractingSite<DisplayName="Target Building">;
// The hero that visis and garrisons
var(Properties) H7AdventureArmy mInteractingHero<DisplayName="Visiting Hero">;

event activated()
{
	local H7AdventureHero hero;
	local EScriptedBehaviour previousBehaviour;
	if ( mInteractingHero != none && mInteractingSite != none )
	{
		hero = mInteractingHero.GetHero();
		mInteractingSite.OnVisit(hero);
		if( H7AreaOfControlSiteLord( mInteractingSite ) != none || H7Garrison( mInteractingSite ) != none )
		{
			previousBehaviour = hero.mScriptedBehaviour;
			hero.SetScriptedBehaviour( ESB_Scripted );
			mInteractingSite.TransferHeroComplete( ARMY_NUMBER_VISIT, ARMY_NUMBER_GARRISON );
			hero.SetScriptedBehaviour( previousBehaviour );
		}
		else
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(mInteractingSite@mInteractingSite.GetName()@"does not support garrisons",MD_QA_LOG);;
		}
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7AreaOfControlSite'))
	{
		if(mInteractingSite == randomObject)
		{
			mInteractingSite = H7AreaOfControlSite(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

