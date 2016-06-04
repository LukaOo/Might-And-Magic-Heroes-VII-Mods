//=============================================================================
// H7InstantCommandOverwriteSkill
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7InstantCommandOverwriteSkill extends H7InstantCommandBase;

var private H7EditorHero mHero;
var private int mOldSkillId;
var private string mNewSkillAId;

function Init( H7EditorHero hero, int oldSkillId, string newSkillAId )
{
	mHero = hero;
	mOldSkillId = oldSkillId;
	mNewSkillAId = newSkillAId;
}

/**
 * Inits the command from the data that was send from multiplayer
 */
function InitFromMPData( MPInstantCommand command )
{
	local H7IEventManagingObject eventManageable;

	eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( command.IntParameters[0] );
	mHero = H7EditorHero(eventManageable);
	mOldSkillId = command.IntParameters[1];
	mNewSkillAId = command.StringParameter;
}

/**
 * Creates Data in a form that can be send in multiplayer
 */
function MPInstantCommand CreateMPCommand()
{
	local MPInstantCommand command;

	command.Type = ICT_OVERWRITE_SKILL;
	command.StringParameter = mNewSkillAId;
	command.IntParameters[0] = mHero.GetID();
	command.IntParameters[1] = mOldSkillId;
	
	return command;
}

function Execute()
{
	mHero.GetSkillManager().OverwriteSkillComplete( mOldSkillId, mNewSkillAId );
}

/**
 * returns the player the command belongs to
 */
function H7Player GetPlayer()
{
	return mHero.GetPlayer();
}
