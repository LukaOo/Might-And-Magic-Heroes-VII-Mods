//=============================================================================
// H7PatchingController
//=============================================================================
// 
// class for special coding regarding patch fixes
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7PatchingController extends Object
	config(Game);

var config bool mAppliedGameplayWaitsForAnimFix;
var config bool mAppliedRotateFix;
var config bool mAppliedPopupKeybinding;
var config bool mAppliedInitialSubtitle;

static function H7PatchingController GetInstance()
{
	return class'H7PlayerController'.static.GetPlayerController().GetPatchingController();
}

public function PerformGUIPatching(H7GUIGeneralProperties guiprop)
{
	local array<string> langWithVO;
	if(!mAppliedGameplayWaitsForAnimFix)
	{
		guiprop.SetGameplayWaitsForAnim(true);
		guiprop.SaveConfig();
		mAppliedGameplayWaitsForAnimFix = true;
		SaveConfig();
	}
	if(!mAppliedRotateFix)
	{
		guiprop.SetRightMouseRotatingEnabled(true);
		guiprop.SaveConfig();
		mAppliedRotateFix = true;
		SaveConfig();
	}
	if(!mAppliedInitialSubtitle)
	{
		mAppliedInitialSubtitle = true;
		langWithVO.AddItem("INT");
		langWithVO.AddItem("DEU");
		langWithVO.AddItem("FRA");
		langWithVO.AddItem("POL");
		langWithVO.AddItem("RUS");
		langWithVO.AddItem("CHN");
		if(langWithVO.Find(guiprop.GetLanguage()) == INDEX_NONE)
		{
			guiprop.SetSubtitelEnabled(true);
		}
		SaveConfig();
	}
}

public function PerformPopupKeyBindingPatching(H7PopupKeybindings keybinds)
{
	if(!mAppliedPopupKeybinding)
	{
		keybinds.ChangeKeybind("ShowGameMenu",'Escape');
		mAppliedPopupKeybinding = true;
		SaveConfig();
	}
}
