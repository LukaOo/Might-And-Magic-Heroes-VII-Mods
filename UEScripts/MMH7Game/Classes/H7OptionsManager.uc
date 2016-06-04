//=============================================================================
// H7OptionsManager
//=============================================================================
// 
// collects all settings and options from all archetypes, ini files, console commands and flash
// to create one unified central place for all
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7OptionsManager extends Object
	dependson(H7KeybindManager, H7StructsAndEnumsNative)
;


enum EOptionType
{
	OT_BOOL,
	OT_FLOAT,
	OT_ENUM,
	OT_KEYBIND
};

enum EOptionCategory
{
	OC_VIDEO,
	OC_SOUND,
	OC_GAMEPLAY,
	OC_GUI,
	OC_KEYBINDINGS,
	OC_DEBUG
};

enum EOptionChangeMode
{
	OM_LIVE,
	OM_APPLY,
	OM_RESTART
};

//////////////////////////////////////////////

struct OptionBoolStruct
{
	var() delegate<SetBoolDelegate> SetFunction;
	var() delegate<GetBoolDelegate> GetFunction;
};

struct OptionFloatStruct
{
	var() delegate<SetFloatDelegate> SetFunction;
	var() delegate<GetFloatDelegate> GetFunction;
	var() delegate<GetFloatConstraintsDelegate> GetConstraintsFunction;
};

struct OptionEnumStruct
{
	var() delegate<SetEnumDelegate> SetFunction;
	var() delegate<GetEnumDelegate> GetFunction;
	var() delegate<GetEnumListDelegate> GetListFunction;
};

struct OptionKeyStruct
{
	var() H7Keybind keybind;
};

struct OptionStruct
{
	var() String IDkey; // i.e. LOG_ENABLED, SOUND_VOLUME, FOG_ACTIVATED...
	var() EOptionCategory category;
	var() EOptionType type;
	var() EOptionChangeMode mode; 
	var() bool enabled;

	var() OptionBoolStruct boolFunctions;
	var() OptionFloatStruct floatFunctions;
	var() OptionEnumStruct enumFunctions;
	var() OptionKeyStruct keybindFunctions;

	structdefaultproperties 
	{
		enabled=true
	}
};

//////////////////////////////////////////////

var protected array<OptionStruct> mOptionList;
var protected bool mRewardOptionsBuilded;

//////////////////////////////////////////////

public delegate SetBoolDelegate(bool val);
public delegate bool GetBoolDelegate();

public delegate SetFloatDelegate(float val);
public delegate float GetFloatDelegate();
public delegate Vector2D GetFloatConstraintsDelegate();

public delegate SetEnumDelegate(int val);
public delegate int GetEnumDelegate();
public delegate array<String> GetEnumListDelegate();

//////////////////////////////////////////////

public static function H7OptionsManager GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetOptionManager(); }

//////////////////////////////////////////////

function array<OptionStruct> GetOptions()   {	return mOptionList;     }
function OptionStruct GetOptionStruct(string optionKey)
{
	local OptionStruct option;
	foreach mOptionList(option)
	{
		if(option.IDkey == optionKey)
		{
			return option;
		}
	}
	return option;
}

function SaveAllConfigs()
{
	local H7GUISoundPlayer soundplayer;
	local H7SoundController soundcontroller;
	local H7GUIGeneralProperties guiproperties;
	local H7PlayerController playercntl;
	local H7Gameinfo gameinfoClass;
	local H7ReplicationInfo replInfoClass;
	local H7PostprocessManager postprocessmgr;

	;

	soundcontroller = class'H7SoundController'.static.GetInstance();
	soundplayer = class'H7GUISoundPlayer'.static.GetInstance();
	playercntl = class'H7PlayerController'.static.GetPlayerController();
	guiproperties = playercntl.GetHUD().GetProperties();
	gameinfoClass = class'H7GameInfo'.static.GetH7GameInfoInstance();
	replInfoClass = class'H7ReplicationInfo'.static.GetInstance();
	postprocessmgr = replInfoClass.GetPostprocessManager();

	soundcontroller.SaveConfig();
	playercntl.SaveConfig();
	soundplayer.SaveConfig();
	guiproperties.SaveConfig();
	gameinfoClass.SaveConfig();
	postprocessmgr.SaveConfig();

	class'H7PlayerProfile'.static.GetInstance().Save();
}

function ResetAllOptions()
{
	class'H7SoundController'.static.GetInstance().ResetOptions();
	class'H7PlayerController'.static.GetPlayerController().ResetOptions();
	class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().ResetOptions();
	//class'H7GameInfo'.static.GetH7GameInfoInstance().ResetOptions();
	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().ResetOptions();
}

function CreateSetup() // Init
{
	local OptionStruct option;
	local H7SoundController soundcontroller;
	local H7GUIGeneralProperties guiproperties;
	local H7PlayerController playercntl;
	local H7ReplicationInfo replInfoClass;
	local array<H7Keybind> keybinds;
	local H7Keybind keybind;
	local H7KeybindManager keybindManager;
	local H7AdventureController advCntl;
	//local H7TransitionData transitionData;
	//local H7CombatConfiguration combatconfig;
	local bool hasHud;
	local H7PostprocessManager postprocessManager;
	
	playercntl = class'H7PlayerController'.static.GetPlayerController();
	if(playercntl == none) {;}

	replInfoClass = class'H7ReplicationInfo'.static.GetInstance();
	if(replInfoClass == none) {;}

	postprocessManager = replInfoClass.GetPostprocessManager();
	keybindManager = class'H7PlayerController'.static.GetPlayerController().GetKeybindManager();
	
	//transitionData = class'H7TransitionData'.static.GetInstance();
	//if(transitionData == none) `warn("H7TransitionData not available for OptionsManager");

	advCntl = class'H7AdventureController'.static.GetInstance();
	//if(advCntl == none) `warn("H7AdventureController not available for OptionsManager");

	soundcontroller = class'H7SoundController'.static.GetInstance(); 
	if(soundcontroller == none) {;}

	hasHud = (playercntl.GetHUD() != none);
	if(hasHud)
	{
		guiproperties = playercntl.GetHUD().GetProperties();
		if(guiproperties == none) {;}
	}
	else
	{
		;
	}

	// TODO not availabe yet
	//combatconfig = class'H7CombatController'.static.GetInstance().GetCombatConfiguration();
	//if(combatconfig == none) {`warn("combatconfig not available for OptionsManager");}

	// TODO TASKFORCE release shipping etc.
	
	/*
	`if(`isdefined(FORCE_NO_CHEATS))
		// force cheats and debugs to false:
		guiproperties.SetDebugCheats(false);
		guiproperties.SetDebugControls(false);
		guiproperties.SetDebugOptions(false);
		guiproperties.SetDebugWindow(false);
	`endif
	// else 
		// use ini file
	*/

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.category = OC_VIDEO;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	option.IDkey = "AA_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = postprocessManager.GetAA;
	option.boolFunctions.SetFunction = postprocessManager.SetAA;
	mOptionList.AddItem(option);

	option.IDkey = "GRAPHICS_CARD";
	option.enabled = false;
	option.type = OT_ENUM; 
	option.mode = OM_RESTART;
	option.enumFunctions.GetFunction = guiproperties.GetGraphicsCard;
	option.enumFunctions.SetFunction = guiproperties.SetGraphicsCard;
	option.enumFunctions.GetListFunction = guiproperties.GetGraphicsCardList;
	mOptionList.AddItem(option);

	option.IDkey = "RESOLUTION";
	option.enabled = true;
	option.type = OT_ENUM; 
	option.mode = OM_APPLY;
	option.enumFunctions.GetFunction = guiproperties.GetResolution;
	option.enumFunctions.SetFunction = guiproperties.SetResolution;
	option.enumFunctions.GetListFunction = guiproperties.GetResolutionList;
	mOptionList.AddItem(option);

	option.IDkey = "WINDOWMODE";
	option.type = OT_ENUM;
	option.mode = OM_APPLY;
	option.enumFunctions.GetFunction = playercntl.GetWindowMode;
	option.enumFunctions.SetFunction = playercntl.SetWindowMode;
	option.enumFunctions.GetListFunction = playercntl.GetWindowModeList;
	mOptionList.AddItem(option);

	option.IDkey = "VSYNC_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_APPLY;
	option.boolFunctions.GetFunction = playercntl.GetVSync;
	option.boolFunctions.SetFunction = playercntl.SetVSync;
	mOptionList.AddItem(option);

	option.IDkey = "AMBIENT_OCLLUSION";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = guiproperties.GetAmbientOcclusion;
	option.boolFunctions.SetFunction = guiproperties.SetAmbientOcclusion;
	mOptionList.AddItem(option);

	option.IDkey = "TEXTURE_QUALITY";
	option.type = OT_ENUM; 
	option.mode = OM_APPLY;
	option.enumFunctions.GetFunction = guiproperties.GetTextureQuality;
	option.enumFunctions.SetFunction = guiproperties.SetTextureQuality;
	option.enumFunctions.GetListFunction = guiproperties.GetTextureQualityList;
	mOptionList.AddItem(option);

	option.IDkey = "DYNSHADOWS_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = playercntl.GetDynamicShadows;
	option.boolFunctions.SetFunction = playercntl.SetDynamicShadows;
	mOptionList.AddItem(option);

	option.IDkey = "BLOOM_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = playercntl.GetBloom;
	option.boolFunctions.SetFunction = playercntl.SetBloom;
	mOptionList.AddItem(option);

	option.IDkey = "DISTORTION_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = playercntl.GetDistortion;
	option.boolFunctions.SetFunction = playercntl.SetDistortion;
	mOptionList.AddItem(option);

//	option.IDkey = "SHADER_QUALITY";
//	option.type = OT_ENUM;
//	option.mode = OM_RESTART;
//	option.enumFunctions.GetFunction = playercntl.GetShaderQuality;
//	option.enumFunctions.SetFunction = playercntl.SetShaderQuality;
//	option.enumFunctions.GetListFunction = playercntl.GetShaderQualityList;
//	mOptionList.AddItem(option);

	option.IDkey = "POSTPROCESS_QUALITY";
	option.type = OT_ENUM;
	option.mode = OM_LIVE;
	option.enumFunctions.GetFunction = postprocessManager.GetPostProcessQuality;
	option.enumFunctions.SetFunction = postprocessManager.SetPostProcessQuality;
	option.enumFunctions.GetListFunction = postprocessManager.GetPostProcessQualityList;
	mOptionList.AddItem(option);

	option.IDkey = "FOG_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = postprocessManager.GetFog;
	option.boolFunctions.SetFunction = postprocessManager.SetFog;
	mOptionList.AddItem(option);

	option.IDkey = "SKELMESH_QUALITY";
	option.type = OT_ENUM; 
	option.mode = OM_APPLY;
	option.enumFunctions.GetFunction = playercntl.GetSkelMeshQuality;
	option.enumFunctions.SetFunction = playercntl.SetSkelMeshQuality;
	option.enumFunctions.GetListFunction = playercntl.GetSkelMeshQualityList;
	mOptionList.AddItem(option);

	option.IDkey = "STATICMESH_QUALITY";
	option.type = OT_ENUM; 
	option.mode = OM_APPLY;
	option.enumFunctions.GetFunction = playercntl.GetStaticMeshQuality;
	option.enumFunctions.SetFunction = playercntl.SetStaticMeshQuality;
	option.enumFunctions.GetListFunction = playercntl.GetStaticMeshQualityList;
	mOptionList.AddItem(option);

	option.IDkey = "PARTICLE_QUALITY";
	option.type = OT_ENUM; 
	option.mode = OM_APPLY;
	option.enumFunctions.GetFunction = playercntl.GetParticleQuality;
	option.enumFunctions.SetFunction = playercntl.SetParticleQuality;
	option.enumFunctions.GetListFunction = playercntl.GetParticleQualityList;
	mOptionList.AddItem(option);

	option.IDkey = "LANDSCAPE_QUALITY";
	option.type = OT_ENUM; 
	option.mode = OM_LIVE;
	option.enumFunctions.GetFunction = playercntl.GetLandscapeQuality;
	option.enumFunctions.SetFunction = playercntl.SetLandscapeQuality;
	option.enumFunctions.GetListFunction = playercntl.GetLandscapeQualityList;
	mOptionList.AddItem(option);

	option.IDkey = "COLOR_CODE_MODELS";
	option.type = OT_BOOL; 
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetOptionColorCodeModels;
	option.boolFunctions.SetFunction = guiproperties.SetOptionColorCodeModels;
	mOptionList.AddItem(option);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.category = OC_SOUND;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.mode = OM_LIVE;

	option.IDkey = "MASTER_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = soundcontroller.GetMasterSettings;
	option.boolFunctions.SetFunction = soundcontroller.SetMasterSettings;
	mOptionList.AddItem(option);

	option.IDkey = "MASTER_VOLUME";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = soundcontroller.GetMasterVolumeSettings;
	option.floatFunctions.SetFunction = soundcontroller.SetMasterVolumeSettings;
	option.floatFunctions.GetConstraintsFunction = GetSoundConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "SOUND_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = soundcontroller.GetSoundSetting;
	option.boolFunctions.SetFunction = soundcontroller.SetSoundSetting;
	mOptionList.AddItem(option);

	option.IDkey = "SOUND_VOLUME";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = soundcontroller.GetSoundVolume;
	option.floatFunctions.SetFunction = soundcontroller.SetSoundVolume;
	option.floatFunctions.GetConstraintsFunction = GetSoundConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "MUSIC_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = soundcontroller.GetMusicSetting;
	option.boolFunctions.SetFunction = soundcontroller.SetMusicSetting;
	mOptionList.AddItem(option);

	option.IDkey = "MUSIC_VOLUME";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = soundcontroller.GetMusicVolume;
	option.floatFunctions.SetFunction = soundcontroller.SetMusicVolume;
	option.floatFunctions.GetConstraintsFunction = GetSoundConstraints;
	mOptionList.AddItem(option);
	
	option.IDkey = "AMBIENT_SOUND_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = soundcontroller.GetAmbientSoundSettings;
	option.boolFunctions.SetFunction = soundcontroller.SetAmbientSoundSettingsBool;
	mOptionList.AddItem(option);
	
	option.IDkey = "AMBIENT_SOUND_VOLUME";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = soundcontroller.GetAmbientSoundVolume;
	option.floatFunctions.SetFunction = soundcontroller.SetAmbientSoundVolume;
	option.floatFunctions.GetConstraintsFunction = GetSoundConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "VOICEOVER_SOUND_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = soundcontroller.GetVoiceOverSetting;
	option.boolFunctions.SetFunction = soundcontroller.SetVoiceOverSetting;
	mOptionList.AddItem(option);
	
	option.IDkey = "VOICEOVER_SOUND_VOLUME";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = soundcontroller.GetVoiceOverVolume;
	option.floatFunctions.SetFunction = soundcontroller.SetVoiceOverVolume;
	option.floatFunctions.GetConstraintsFunction = GetSoundConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "AUDIO_LANGUAGE";
	option.type = OT_ENUM;
	option.mode = OM_RESTART;
	option.enumFunctions.GetFunction = guiproperties.GetAudioLanguageExt;
	option.enumFunctions.SetFunction = guiproperties.SetAudioLanguageExt;
	option.enumFunctions.GetListFunction = guiproperties.GetAudioLanguageList;
	mOptionList.AddItem(option);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.category = OC_GUI;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	option.IDkey = "SUBTITLE_ENABELED";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = guiproperties.GetSubtitelEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetSubtitelEnabled;
	mOptionList.AddItem(option);

	option.IDkey = "MOUSE_INVERTION_ENABLE";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = playercntl.GetMousePanInvertion;
	option.boolFunctions.SetFunction = playercntl.SetMousePanInvertion;
	mOptionList.AddItem(option);

	option.IDkey = "BORDER_PANNING_ENABLE";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = playercntl.GetBorderPan;
	option.boolFunctions.SetFunction = playercntl.SetBorderPan;
	mOptionList.AddItem(option);

	option.IDkey = "GENERAL_PANNING_SENSITIVITY";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = playercntl.GetGeneralPanningSensitivity;
	option.floatFunctions.SetFunction = playercntl.SetGeneralPanningSensitivity;
	option.floatFunctions.GetConstraintsFunction = GetPanningPercentConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "KEYBOARD_PANNING_SENSITIVITY";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = playercntl.GetKeyboardPanningSensitivity;
	option.floatFunctions.SetFunction = playercntl.SetKeyboardPanningSensitivity;
	option.floatFunctions.GetConstraintsFunction = GetPanningPercentConstraints;
	mOptionList.AddItem(option);
	
	option.IDkey = "KEYBOARD_ROTATING_SENSITIVITY";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = playercntl.GetKeyboardRotatingSensitivity;
	option.floatFunctions.SetFunction = playercntl.SetKeyboardRotatingSensitivity;
	option.floatFunctions.GetConstraintsFunction = GetPanningPercentConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "RIGHT_MOUSE_ROTATION_ENABLE";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetRightMouseRotatingEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetRightMouseRotatingEnabled;
	mOptionList.AddItem(option);

	option.IDkey = "MOUSE_ROTATING_SENSITIVITY";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = playercntl.GetMouseRotatingSensitivity;
	option.floatFunctions.SetFunction = playercntl.SetMouseRotatingSensitivity;
	option.floatFunctions.GetConstraintsFunction = GetPanningPercentConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "WINDOW_MOUSE_LOCK";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = playercntl.IsMouseLockedToWindow;
	option.boolFunctions.SetFunction = playercntl.SetMouseLockedToWindow;
	mOptionList.AddItem(option);

	option.IDkey = String(GetEnum(Enum'EOption',OPT_PATH_HOVER_DECAL));
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetHoverDecalEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetHoverDecalEnabled;
	mOptionList.AddItem(option);

	option.IDkey = "NOTE_BAR_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetNoteBarStatus;
	option.boolFunctions.SetFunction = guiproperties.SetNoteBarStatus;
	mOptionList.AddItem(option);

	option.IDkey = "LOG_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetLogStatus;
	option.boolFunctions.SetFunction = guiproperties.SetLogStatus;
	mOptionList.AddItem(option);

	option.IDkey = "AUTO_PLAY_DIALOGS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionAutoPlayDialogs;
	option.boolFunctions.SetFunction = guiproperties.SetOptionAutoPlayDialogs;
	mOptionList.AddItem(option);

	option.IDkey = "SIDEBAR_COLLAPSE_TIME"; // for note-bar (permanent messages)
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = guiproperties.GetOptionSideBarCollapseTime;
	option.floatFunctions.SetFunction = guiproperties.SetOptionSideBarCollapseTime;
	option.floatFunctions.GetConstraintsFunction = guiproperties.GetSideBarCollapseConstraints;
	mOptionList.AddItem(option);
	
	option.IDkey = "TOOLTIP_DELAY_TIME";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = guiproperties.GetOptionTooltipDelayTime;
	option.floatFunctions.SetFunction = guiproperties.SetOptionTooltipDelayTime;
	option.floatFunctions.GetConstraintsFunction = guiproperties.GetTooltipCooldownTimeConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "TOOLTIP_COOLDOWN_TIME";
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = guiproperties.GetOptionTooltipCooldownime;
	option.floatFunctions.SetFunction = guiproperties.SetOptionTooltipCooldownTime;
	option.floatFunctions.GetConstraintsFunction = guiproperties.GetTooltipCooldownTimeConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "TURN_OVER_POPUP";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionTurnOverPopup;
	option.boolFunctions.SetFunction = guiproperties.SetOptionTurnOverPopup;
	mOptionList.AddItem(option);

	option.IDkey = "WEEKLY_POPUP";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionWeeklyPopup;
	option.boolFunctions.SetFunction = guiproperties.SetOptionWeeklyPopup;
	mOptionList.AddItem(option);

	option.IDkey = "LANGUAGE";
	option.type = OT_ENUM;
	option.mode = OM_RESTART;
	option.enumFunctions.GetFunction = guiproperties.GetLanguageExt;
	option.enumFunctions.SetFunction = guiproperties.SetLanguageExt;
	option.enumFunctions.GetListFunction = guiproperties.GetLanguageList;
	mOptionList.AddItem(option);

	

	/*
	option.IDkey = "FLASH_CURSOR";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionFlashCursor;
	option.boolFunctions.SetFunction = guiproperties.SetOptionFlashCursor;
	mOptionList.AddItem(option);

	option.IDkey = "CANVAS_CURSOR";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionCanvasCursor;
	option.boolFunctions.SetFunction = guiproperties.SetOptionCanvasCursor;
	mOptionList.AddItem(option);
	*/

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.category = OC_DEBUG;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	option.IDkey = "SHOW_DEBUG_OPTIONS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetDebugOptions;
	option.boolFunctions.SetFunction = guiproperties.SetDebugOptions;
	mOptionList.AddItem(option);

	option.IDkey = "SHOW_DEBUG_CONTROLS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetDebugControls;
	option.boolFunctions.SetFunction = guiproperties.SetDebugControls;
	mOptionList.AddItem(option);

	option.IDkey = "SHOW_DEBUG_CHEATS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetDebugCheats;
	option.boolFunctions.SetFunction = guiproperties.SetDebugCheats;
	mOptionList.AddItem(option);

	option.IDkey = "SHOW_DEBUG_WINDOW";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetDebugWindow;
	option.boolFunctions.SetFunction = guiproperties.SetDebugWindow;
	mOptionList.AddItem(option);

	option.IDkey = "SKIP_TACTICS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetSkipTactics;
	option.boolFunctions.SetFunction = guiproperties.SetSkipTactics;
	mOptionList.AddItem(option);

	option.IDkey = "TECHNICAL_SPELL_TOOLTIP";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetAutoTooltipState;
	option.boolFunctions.SetFunction = guiproperties.SetAutoTooltipState;
	mOptionList.AddItem(option);
	
	option.IDkey = "QA_LOG_ENABLED";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetQALogStatus;
	option.boolFunctions.SetFunction = guiproperties.SetQALogStatus;
	mOptionList.AddItem(option);

	option.IDkey = "SHOW_HIDDEN_BUFFS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionHiddenBuffs;
	option.boolFunctions.SetFunction = guiproperties.SetOptionHiddenBuffs;
	mOptionList.AddItem(option);

	option.IDkey = "LOG_HIDDEN_BUFFS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionHiddenBuffsLog;
	option.boolFunctions.SetFunction = guiproperties.SetOptionHiddenBuffsLog;
	mOptionList.AddItem(option);

	if(advCntl != none)
	{
		option.IDkey = "RANDOM_SKILLING";
		option.type = OT_BOOL;
		option.boolFunctions.GetFunction = advCntl.GetRandomSkilling;
		option.boolFunctions.SetFunction = advCntl.SetRandomSkilling;
		mOptionList.AddItem(option);
	}

	option.IDkey = "SHOW_HIDDEN_EFFECTS";
	option.type = OT_BOOL;
	option.boolFunctions.GetFunction = guiproperties.GetOptionHiddenEffects;
	option.boolFunctions.SetFunction = guiproperties.SetOptionHiddenEffects;
	mOptionList.AddItem(option);

	option.IDkey = "SIDEBAR_ALIVE_TIME"; // for side-bar (tmp messages)
	option.type = OT_FLOAT;
	option.floatFunctions.GetFunction = guiproperties.GetOptionSideBarLiveTime;
	option.floatFunctions.SetFunction = guiproperties.SetOptionSideBarLiveTime;
	option.floatFunctions.GetConstraintsFunction = guiproperties.GetSideBarAliveConstraints;
	mOptionList.AddItem(option);

	option.IDkey = "SHOW_LOCA_KEYS";
	option.type = OT_BOOL;
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetOptionShowLocaKeys;
	option.boolFunctions.SetFunction = guiproperties.SetOptionShowLocaKeys;
	mOptionList.AddItem(option);

	option.IDkey = "CAMPAIGNS_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetOptionCampaignsEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetOptionCampaignsEnabled;
	mOptionList.AddItem(option);

	option.IDkey = "DEMO_DUELS";
	option.type = OT_BOOL;
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetDemoDuels;
	option.boolFunctions.SetFunction = guiproperties.SetDemoDuels;
	mOptionList.AddItem(option);

	option.IDkey = "SKIRMISH_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetOptionSkirmishEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetOptionSkirmishEnabled;
	mOptionList.AddItem(option);

	option.IDkey = "DUEL_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetOptionDuelEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetOptionDuelEnabled;
	mOptionList.AddItem(option);

	option.IDkey = "CHAT_ENABLED";
	option.type = OT_BOOL;
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetOptionChatEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetOptionChatEnabled;
	mOptionList.AddItem(option);

	
	if(H7AdventurePlayerController(playercntl) != none)
	{
		option.IDkey = "FOG_OF_WAR";
		option.type = OT_BOOL;
		option.mode = OM_LIVE;
		option.boolFunctions.GetFunction = H7AdventurePlayerController(playercntl).GetFog;
		option.boolFunctions.SetFunction = H7AdventurePlayerController(playercntl).SetFog;
		mOptionList.AddItem(option);
	}

	// deprecated and moved to cheats until final remove
	option.IDkey = "BUILD_TREE_SHOW_ALL";
	option.type = OT_BOOL;
	option.mode = OM_RESTART;
	option.boolFunctions.GetFunction = guiproperties.GetOptionBuildTreeShowAll;
	option.boolFunctions.SetFunction = guiproperties.SetOptionBuildTreeShowAll;
	mOptionList.AddItem(option);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.category = OC_GAMEPLAY;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	if( !class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() )
	{
		option.IDkey = "GAMESPEED_ADVENTURE_AI";
		option.type = OT_FLOAT;
		option.mode = OM_LIVE;
		option.floatFunctions.GetFunction = replInfoClass.GetGameSpeedAdventureAIConfig;
		option.floatFunctions.SetFunction = replInfoClass.ModifyGameSpeedAdventureAI;
		option.floatFunctions.GetConstraintsFunction = replInfoClass.GetGameSpeedConstraintsAI;
		mOptionList.AddItem(option);

		option.IDkey = "GAMESPEED_ADVENTURE";
		option.type = OT_FLOAT;
		option.mode = OM_LIVE;
		option.floatFunctions.GetFunction = replInfoClass.GetGameSpeedAdventureConfig;
		option.floatFunctions.SetFunction = replInfoClass.ModifyGameSpeedAdventure;
		option.floatFunctions.GetConstraintsFunction = replInfoClass.GetGameSpeedConstraints;
		mOptionList.AddItem(option);

		option.IDkey = "GAMESPEED_COMBAT";
		option.type = OT_FLOAT;
		option.mode = OM_LIVE;
		option.floatFunctions.GetFunction = replInfoClass.GetGameSpeedCombatConfig;
		option.floatFunctions.SetFunction = replInfoClass.ModifyGameSpeedCombat;
		option.floatFunctions.GetConstraintsFunction = replInfoClass.GetGameSpeedConstraints;
		mOptionList.AddItem(option);
	}

	option.IDkey = "GAMEPLAY_WAITS_FOR_ANIM";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = guiproperties.GetGameplayWaitsForAnim;
	option.boolFunctions.SetFunction = guiproperties.SetGameplayWaitsForAnim;
	mOptionList.AddItem(option);

	option.IDkey = "COOL_CAM_CHANCE";
	option.type = OT_FLOAT;
	option.mode = OM_LIVE;
	option.floatFunctions.GetFunction = guiproperties.GetCoolCamChanceFloat;
	option.floatFunctions.SetFunction = guiproperties.SetCoolCamChanceFloat;
	option.floatFunctions.GetConstraintsFunction = GetPercentConstraints;
	mOptionList.AddItem(option);
	
	option.IDkey = "COOL_CAM_ACTIONS";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = guiproperties.GetCoolCamCombatActionAllowed;
	option.boolFunctions.SetFunction = guiproperties.SetCoolCamCombatActionAllowed;
	mOptionList.AddItem(option);

	// TODO enable when implemented
	if(false && class'H7AdventureController'.static.GetInstance() != none && !class'H7AdventureController'.static.GetInstance().GetRandomSkilling()) // OPTIONAL grey out when random skilling is on (atm hidden)
	{
		option.IDkey = "AUTOMATIC_SKILLING";
		option.enabled = false; // BETA HACK
		option.type = OT_BOOL;
		option.mode = OM_RESTART; // TBD
		option.boolFunctions.GetFunction = playercntl.GetAutoSkilling;
		option.boolFunctions.SetFunction = playercntl.SetAutoSkilling;
		mOptionList.AddItem(option);
		// TODO integrate into gamecode:
		//class'H7PlayerController'.static.GetPlayerController().GetAutoSkilling();
	}

	option.IDkey = "AUTOSAVE";
	option.type = OT_BOOL;
	option.mode = OM_LIVE;
	option.boolFunctions.GetFunction = guiproperties.GetOptionAutosaveEnabled;
	option.boolFunctions.SetFunction = guiproperties.SetOptionAutosaveEnabled;
	option.enabled = playercntl.IsServer();
	mOptionList.AddItem(option);

	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.category = OC_KEYBINDINGS;
	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	option.mode = OM_APPLY;
	option.enabled = true;

	if( keybindManager != none )
	{
		keybinds = keybindManager.GetKeybindList();

		foreach keybinds(keybind)
		{
			option.IDkey = keybind.keybind.Command;
			option.type = OT_KEYBIND;
			option.keybindFunctions.keybind = keybind; // Creates copy!
			mOptionList.AddItem(option);
		}
	}

	if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().AreRewardsPulled())
	{
		CreateRewardOptions();
	}


	;
}

function CreateRewardOptions()
{
	local OptionStruct option;
	local H7AchievementManager achManager;
	local array<H7UPlayReward> rewards;
	local int i, j;

	// Just everyday uc things
	option = option;

	if(class'H7PlayerProfile'.static.GetInstance() != none)
	{
		achManager = class'H7PlayerProfile'.static.GetInstance().GetAchievementManager();
	}

	if(achManager != none && !mRewardOptionsBuilded)
	{
		rewards = achManager.GetPlayerProfile().mUPlayRewards;

		if(rewards.Length == 0)
		{
			return;
		}
			
		option.category = OC_GAMEPLAY;

		i = achManager.GetRewardIndexByID("MMH7REWARD01");
		option.IDkey = rewards[i].idUtf8;
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
		{
			option.enabled = rewards[i].redeemed;
		}
		else
		{
			option.enabled = false;
		}
		option.type = OT_BOOL;
		option.mode = OM_APPLY;
		option.boolFunctions.GetFunction = achManager.GetStateReward_HD;
		option.boolFunctions.SetFunction = achManager.SetStateReward_HD;
		mOptionList.AddItem(option);

		i = achManager.GetRewardIndexByID("MMH7REWARD02");
		option.IDkey = rewards[i].idUtf8;
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController() ) != none )
		{
			option.enabled = rewards[i].redeemed;
		}
		else
		{
			option.enabled = false;
		}
		option.type = OT_BOOL;
		option.mode = OM_APPLY;
		option.boolFunctions.GetFunction = achManager.GetStateReward_PM;
		option.boolFunctions.SetFunction = achManager.SetStateReward_PM;
		mOptionList.AddItem(option);

		i = achManager.GetRewardIndexByID("MMH7REWARD03");
		option.IDkey = rewards[i].idUtf8;
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
		{
			option.enabled = rewards[i].redeemed;
		}
		else
		{
			option.enabled = false;
		}
		option.type = OT_BOOL;
		option.mode = OM_APPLY;
		option.boolFunctions.GetFunction = achManager.GetStateReward_BH;
		option.boolFunctions.SetFunction = achManager.SetStateReward_BH;
		mOptionList.AddItem(option);

		i = achManager.GetRewardIndexByID("MMH7REWARD04");
		option.IDkey = rewards[i].idUtf8;
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
		{
			option.enabled = rewards[i].redeemed;
		}
		else
		{
			option.enabled = false;
		}
		option.type = OT_BOOL;
		option.mode = OM_APPLY;
		option.boolFunctions.GetFunction = achManager.GetStateReward_AP;
		option.boolFunctions.SetFunction = achManager.SetStateReward_AP;
		mOptionList.AddItem(option);

		i = achManager.GetRewardIndexByID("MMH7REWARD05");
		option.IDkey = rewards[i].idUtf8;
		if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
		{
			option.enabled = rewards[i].redeemed;
		}
		else
		{
			option.enabled = false;
		}
		option.type = OT_BOOL;
		option.mode = OM_APPLY;
		option.boolFunctions.GetFunction = achManager.GetStateReward_LM;
		option.boolFunctions.SetFunction = achManager.SetStateReward_LM;
		mOptionList.AddItem(option);

		mRewardOptionsBuilded = true;
	}
	else if(mRewardOptionsBuilded) // If the options were build, but somebody tries to build again -> REPLACE
	{
		rewards = achManager.GetPlayerProfile().mUPlayRewards;

		if(rewards.Length == 0)
		{
			return;
		}

		i = achManager.GetRewardIndexByID("MMH7REWARD01");
		j = GetSettingIndex("MMH7REWARD01");
		if(j > -1 && i > -1)
		{
			if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
			{
				mOptionList[j].enabled = rewards[i].redeemed;
			}
			else
			{
				mOptionList[j].enabled = false;
			}
		}

		i = achManager.GetRewardIndexByID("MMH7REWARD02");
		j = GetSettingIndex("MMH7REWARD02");
		if(j > -1 && i > -1)
		{
			if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
			{
				mOptionList[j].enabled = rewards[i].redeemed;
			}
			else
			{
				mOptionList[j].enabled = false;
			}
		}

		i = achManager.GetRewardIndexByID("MMH7REWARD03");
		j = GetSettingIndex("MMH7REWARD03");
		if(j > -1 && i > -1)
		{
			if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
			{
				mOptionList[j].enabled = rewards[i].redeemed;
			}
			else
			{
				mOptionList[j].enabled = false;
			}
		}

		i = achManager.GetRewardIndexByID("MMH7REWARD04");
		j = GetSettingIndex("MMH7REWARD04");
		if(j > -1 && i > -1)
		{
			if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
			{
				mOptionList[j].enabled = rewards[i].redeemed;
			}
			else
			{
				mOptionList[j].enabled = false;
			}
		}

		i = achManager.GetRewardIndexByID("MMH7REWARD05");
		j = GetSettingIndex("MMH7REWARD05");
		if(j > -1 && i > -1)
		{
			if(H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none )
			{
				mOptionList[j].enabled = rewards[i].redeemed;
			}
			else
			{
				mOptionList[j].enabled = false;
			}
		}

	}
}

function CreateOptionsFromKeybinds()
{
	local OptionStruct option;
	local int i;
	local array<H7Keybind> keybinds;
	local H7Keybind keybind;
	local H7KeybindManager keybindManager;

	keybindManager = class'H7PlayerController'.static.GetPlayerController().GetKeybindManager();
	
	for(i=mOptionList.Length-1;i>0;i--)
	{
		if(mOptionList[i].type == OT_KEYBIND)
		{
			//`log_dui("delete from options i=" @ i @ mOptionList[i].keybindFunctions.keybind.keybind.Command);
			mOptionList.Remove(i,1);
		}
	}

	keybinds = keybindManager.GetKeybindList();

	option.category = OC_KEYBINDINGS;
	option.mode = OM_APPLY;

	foreach keybinds(keybind)
	{
		//`log_dui("add to options:" @ keybind.category @ keybind.keybind.Name @ keybind.keybind.Command);
		option.IDkey = keybind.keybind.Command;
		option.type = OT_KEYBIND;
		option.keybindFunctions.keybind = keybind; // Creates copy!
		mOptionList.AddItem(option);
	}
}

function Vector2d GetSoundConstraints()
{
	local Vector2d constraints;
	constraints.X = 0;
	constraints.Y = 1; // TODO 2
	return constraints;
}

function Vector2d GetPercentConstraints()
{
	local Vector2d constraints;
	constraints.X = 0;
	constraints.Y = 1;
	return constraints;
}

function Vector2d GetPanningPercentConstraints()
{
	local Vector2d constraints;
	constraints.X = 0.25;
	constraints.Y = 4;
	return constraints;
}

function bool GetSettingBool(String key)
{
	local OptionStruct option;
	option = GetSetting(key);
	GetBoolDelegate = option.boolFunctions.GetFunction;

// testers and players don't get MP cheats

	if(key == "SHOW_DEBUG_CHEATS" && class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
	{
		return false;
	}


	if(key == "GAMEPLAY_WAITS_FOR_ANIM" && class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
	{
		return false;
	}
	return GetBoolDelegate();
}

function float GetSettingFloat(String key)
{
	local OptionStruct option;
	option = GetSetting(key);
	GetFloatDelegate = option.floatFunctions.GetFunction;
	return GetFloatDelegate();
}

function int GetSettingEnum(String key)
{
	local OptionStruct option;
	option = GetSetting(key);
	GetEnumDelegate = option.enumFunctions.GetFunction;
	return GetEnumDelegate();
}

function array<String> GetSettingEnumList(String key)
{
	local OptionStruct option;
	option = GetSetting(key);
	GetEnumListDelegate = option.enumFunctions.GetListFunction;
	return GetEnumListDelegate();
}

function SetSettingBool(String key,bool val)
{
	local OptionStruct option;
	option = GetSetting(key);

	SetBoolDelegate = option.boolFunctions.SetFunction;

	SetBoolDelegate(val);
}

function SetSettingFloat(String key,float val)
{
	local OptionStruct option;
	option = GetSetting(key);
	SetFloatDelegate = option.floatFunctions.SetFunction;
	SetFloatDelegate(val);
}

function SetSettingEnum(String key,int val)
{
	local OptionStruct option;
	option = GetSetting(key);
	SetEnumDelegate = option.enumFunctions.SetFunction;
	SetEnumDelegate(val);
}

/*
function bool SetSettingKeybind(String id,bool shift,bool alt,bool control,String key)
{
	local H7KeybindManager keybindManager;
	keybindManager = class'H7PlayerController'.static.GetPlayerController().GetKeybindManager();

	return keybindManager.SetKeybind(id,key,shift,alt,control);
}
*/

function Vector2d GetSettingConstraints(String key)
{
	local OptionStruct option;
	local Vector2d constraints;
	option = GetSetting(key);
	GetFloatConstraintsDelegate = option.floatFunctions.GetConstraintsFunction;
	constraints =  GetFloatConstraintsDelegate();
	return constraints;
}

function OptionStruct GetSetting(String key)
{
	local OptionStruct option;

	if(class'H7PlayerController'.static.GetPlayerController().GetHUD() == none) { return option; }

	foreach mOptionList(option)
	{
		if(option.IDkey == key)
		{
			return option;
		}
	}

	;
	return option;
}

function int GetSettingIndex(String key)
{
	local int i;

	if(class'H7PlayerController'.static.GetPlayerController().GetHUD() == none) { return -1; }

	for(i = 0; i < mOptionList.Length; ++i)
	{
		if(mOptionList[i].IDkey == key)
		{
			return i;
		}
	}


	;
	return -1;
}
