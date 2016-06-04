//=============================================================================
// H7GFxBattleMapResultWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxOptionsMenu extends H7GFxUIContainer;

function GFxObject CreateOptionObject(OptionStruct option)
{
	local GFxObject entry,enumListData;
	local array<String> enumList;
	local String enumString;
	local int j;
	
	//`log_dui("Option" @ option.IDkey);

	entry = CreateObject("Object");
	entry.SetString("name",option.IDkey);
	entry.SetBool("enabled",option.enabled);
	entry.SetString("category",String(option.category));
	entry.SetString("type",String(option.type));
	entry.SetString("mode",String(option.mode));
	if(option.type == OT_FLOAT)
	{
		entry.SetFloat("min",class'H7OptionsManager'.static.GetInstance().GetSettingConstraints(option.IDkey).X);
		entry.SetFloat("max",class'H7OptionsManager'.static.GetInstance().GetSettingConstraints(option.IDkey).Y);
		entry.SetFloat("value",class'H7OptionsManager'.static.GetInstance().GetSettingFloat(option.IDkey));
		//`log_dui(class'H7OptionsManager'.static.GetInstance().GetSettingFloat(option.IDkey));
	}
	else if(option.type == OT_BOOL)
	{
		entry.SetBool("value",class'H7OptionsManager'.static.GetInstance().GetSettingBool(option.IDkey));
		//`log_dui(class'H7OptionsManager'.static.GetInstance().GetSettingBool(option.IDkey));
	}
	else if(option.type == OT_ENUM)
	{
		entry.SetInt("value",class'H7OptionsManager'.static.GetInstance().GetSettingEnum(option.IDkey));

		enumList = class'H7OptionsManager'.static.GetInstance().GetSettingEnumList(option.IDkey);
		enumListData = CreateArray();

		foreach enumList(enumString,j)
		{
			enumListData.SetElementString(j,enumString);
		}

		entry.SetObject("list",enumListData);

		//`log_dui(class'H7OptionsManager'.static.GetInstance().GetSettingEnum(option.IDkey));
	}
	else if(option.type == OT_KEYBIND)
	{
		//`log_dui("  " @ class'H7KeybindManager'.static.GetInstance().GetKeyComboString(option.keybindFunctions.keybind.keybind) 
		//		      @ class'H7KeybindManager'.static.GetInstance().GetKeyComboString(option.keybindFunctions.keybind.secondaryKeybind)
		//		);

		entry.SetObject("keyCombo",CreateGFXKeyCombo(option.keybindFunctions.keybind.keybind));
		entry.SetObject("keyComboSecondary",CreateGFXKeyCombo(option.keybindFunctions.keybind.secondaryKeybind));
			
		//entry.SetString("keyCombo",class'H7KeybindManager'.static.GetInstance().GetKeyComboString(option.keybindFunctions.keybind.keybind));
		//entry.SetString("keyComboSecondary",class'H7KeybindManager'.static.GetInstance().GetKeyComboString(option.keybindFunctions.keybind.secondaryKeybind));
			
		entry.SetString("subCategory",String(option.keybindFunctions.keybind.category));
		entry.SetString("conflictCategory",class'H7KeybindManager'.static.GetInstance().GetConflictCategory(option.keybindFunctions.keybind.category) );
		//`log_dui(option.keybindFunctions.keybind.category);
	}

	return entry;
}

function Update()
{
	local GFxObject mData,list,entry;
	local array<OptionStruct> options;
	local OptionStruct option;
	local int i;

	;

	// read all the options list from OptionsManager
	options = class'H7OptionsManager'.static.GetInstance().GetOptions();
	i = 0;
	list = CreateObject("Array");
	foreach options(option)
	{
		if(option.category == OC_DEBUG && !class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_OPTIONS")) continue;
		if(option.category == OC_KEYBINDINGS && option.keybindFunctions.keybind.category == KC_CHEATS && !class'H7OptionsManager'.static.GetInstance().GetSettingBool("SHOW_DEBUG_CHEATS")) continue;
		
		// keybinds we want to hide from users
		if(option.category == OC_KEYBINDINGS && option.keybindFunctions.keybind.category == KC_WINDOW_BUILDING) continue;
		if(option.category == OC_KEYBINDINGS && option.keybindFunctions.keybind.category == KC_WINDOW_WEEKLY) continue;
		if(option.category == OC_KEYBINDINGS && option.keybindFunctions.keybind.category == KC_WINDOW_LOADSAVE) continue;
		if(option.category == OC_KEYBINDINGS && option.keybindFunctions.keybind.category == KC_WINDOW_QUESTCOMPLETE) continue;

		entry = CreateOptionObject(option);

		list.SetElementObject(i,entry);
		i++;
	}

	mData = CreateObject("Object");

	mData.SetObject("Options",list);
	SetObject("mData",mData);

	ActionscriptVoid("Update");
}


function GFxObject CreateGFXKeyCombo(Keybind keybind)
{
	local GFxObject ob;

	ob = CreateObject("Object");
	ob.SetBool("Shift",keybind.Shift);
	ob.SetBool("Alt",keybind.Alt);
	ob.SetBool("Control",keybind.Control);
	ob.SetString("Key",String(keybind.Name));
	ob.SetString("Command",keybind.Command);
	ob.SetString("DisplayKey",keybind.Name=='None'?" ":GetDisplayOfKey(keybind.Name));

	return ob;
}

// converts some unrealKeyNames into loca directly
// converts other unrealKeyNames into keycodes and gets the char for that keycode
function string GetDisplayOfKey(name unrealKeyName)
{
	local bool success;
	local int keyCode;
	local string displayString;

	switch(unrealKeyName)
	{
		case 'F1':case 'F2':case 'F3':case 'F4':case 'F5':case 'F6':case 'F7':case 'F8':case 'F9':case 'F10':case 'F11':case 'F12':
		case 'NumLock':case 'Divide':case 'Multiply':case 'Subtract':case 'Add':case 'Decimal':
		case 'Home':case 'End':case 'Insert':case 'PageUp':case 'PageDown':case 'Delete':
		case 'NumPadZero':case 'NumPadOne':case 'NumPadTwo':case 'NumPadThree':case 'NumPadFour':
		case 'NumPadFive':case 'NumPadSix':case 'NumPadSeven':case 'NumPadEight':case 'NumPadNine':
		case 'Backspace':case 'Tab':case 'Enter':case 'CapsLock':case 'Escape':case 'SpaceBar':
		case 'Left':case 'Up':case 'Down':case 'Right':
		case 'LeftShift':case 'RightShift': case 'LeftAlt':case 'RightAlt': case 'LeftControl':case 'RightControl': 
			return class'H7Loca'.static.LocalizeSave("KEY_" $ Caps(unrealKeyName),"H7Keys");
		default:
			success = class'H7EngineUtility'.static.KeyMapNameToVirtualKey(unrealKeyName,keyCode);
			if(success)
			{
				success = class'H7EngineUtility'.static.VirtualKeyToChar(keyCode,displayString);
				if(success) 
				{
					return displayString;
				}
				else
				{
					return string(keyCode);
				}
			}
			else
			{
				return class'H7Loca'.static.LocalizeSave("KEY_" $ Caps(unrealKeyName),"H7Keys");
			}
	}
}

function RefreshResolutionList(int windowMode)
{
	local array<string> resolutions;
	local GFxObject ob,enumListData;
	local string enumString;
	local OptionStruct option;
	local int j;

	option = class'H7OptionsManager'.static.GetInstance().GetOptionStruct("RESOLUTION");
	ob = CreateOptionObject(option);

	resolutions = class'H7GUIGeneralProperties'.static.GetInstance().GetResolutionListForWindowMode(windowMode,false);
	enumListData = CreateArray();
	foreach resolutions(enumString,j)
	{
		;
		enumListData.SetElementString(j,enumString);
	}
	ob.SetObject("list",enumListData);
	ob.SetInt("value",class'H7GUIGeneralProperties'.static.GetInstance().GetResolutionIndexInList(windowMode));

	SetObject("mData",ob);
	SetDropDownList("RESOLUTION");
}

function SetDropDownList(string optionKey)
{
	ActionScriptVoid("SetDropDownList");
}

function SetCheckBox(string optionKey,bool val)
{
	ActionScriptVoid("SetCheckBox");
}

function int IsInAssignMode()
{
	return ActionScriptInt("IsInAssignMode");
}

function DiscardAllChanges()
{
	ActionScriptVoid("DiscardAllChanges");
}
