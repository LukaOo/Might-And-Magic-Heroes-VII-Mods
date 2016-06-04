//=============================================================================
// H7MagicGuildPopupCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7MagicGuildPopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7GFxMagicGuildPopup mMagicGuildPopup;

static function H7MagicGuildPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetMagicGuildCntl(); }
function H7GFxMagicGuildPopup GetMagicGuildPopup() {return mMagicGuildPopup;}
function bool IsActive() { return mTown != none; }

function bool Initialize()
{
	;
	LinkToTownPopupContainer();

	return true;
}

function LoadComplete()
{
	mMagicGuildPopup = H7GFxMagicGuildPopup(mRootMC.GetObject("aMagicGuildPopup", class'H7GFxMagicGuildPopup'));
	mMagicGuildPopup.SetVisibleSave(false);
}

function Update(H7Town pTown)
{
	mTown = pTown;
	mMagicGuildPopup.Update(mTown);
	OpenPopup();
}

function SelectSchool(int enumInt)
{
	local H7InstantCommandSelectSpecialisation command;
	;

	command = new class'H7InstantCommandSelectSpecialisation';
	command.Init(mTown, enumInt);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);	
}

function SelectSchoolComplete()
{
	mMagicGuildPopup.Update(mTown);
	mTown.UpdateMagicGuildMessage();
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	mMagicGuildPopup.Reset();

	super.ClosePopup();

	mTown = none;
}

function H7GFxUIContainer GetPopup()
{
	return mMagicGuildPopup;
}

