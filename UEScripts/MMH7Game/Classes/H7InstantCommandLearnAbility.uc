//=============================================================================
// H7InstantCommandLearnAbility
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandLearnAbility extends H7InstantCommandBase;

var private H7EditorHero mHero;
var private int mSkillId;
var private string mAbilityId;

function Init( H7EditorHero hero, int skillID, string abilityId )
{
	mHero = hero;
	mSkillId = skillId;
	mAbilityId = abilityId;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7EditorHero(eventManageable);
	mSkillId = command.IntParameters[1];
	mAbilityId = command.StringParameter;
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_LEARN_ABILITY_FROM_SKILL;
	command.StringParameter = mAbilityId;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mSkillID;
	
	return command;
}

function Execute()
{
	local H7AdventureHud hud;
	local bool success;

	success = mHero.GetSkillManager().LearnAbilityfromSkillByIDComplete( mSkillId, mAbilityId );

	if(success && mHero.GetPlayer().IsControlledByLocalPlayer())
	{
		hud = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud();
		if(hud != none)
		{
			if(hud.GetSkillwheelCntl().GetPopup().IsVisible())
			{
				hud.GetSkillwheelCntl().LearnSkillAbilityComplete();
			}
			
			if(class'H7AdventureController'.static.GetInstance().GetRandomSkilling())
			{
				hud.GetRandomSkillingPopUpCntl().LearnSkillAbilityComplete(mHero);
			}
		}
	}
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
