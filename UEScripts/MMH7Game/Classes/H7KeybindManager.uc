//=============================================================================
// H7KeybindManager
//=============================================================================
// 
// manages all keybindings:
// There are 2 lists.
// 1) unreal list - contains each key once and then piped commands (also contains aliases)
//    key1 -> command1 | command2 | command3
//    key2 -> command1
//    key3 -> alias1
//    alias1 -> command1
// 2) self.mKeybindList - contains key multiple times split apart in categories (primary,secondary) 
//    (does not contain aliases->command entries) 
//		(from unreal-list: mainly key->alias links)
//    (but does contain popup keybinds, that are not in the unreal list)
//      (from popups: mainly key->command or key->function links)
//    alias1 -> key1 key2 category1
//    alias2 -> key1      category2
//    alias3 -> key1      category3
//    popupcommand -> key3  popup_category1
// 3) gui list - same as 2)
//    
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7KeybindManager extends Object dependson(H7PopupKeybindings);

enum EKeybindCategory
{
	KC_GENERAL,
	KC_ADVENTURE,
	KC_COMBAT,
	KC_TOWN,
	KC_CAMERA,
	KC_MOVEMENT,
	KC_CHEATS,
	// windows/poups:
	KC_WINDOW_UNDEFINED,
	KC_WINDOW_GAME_MENU,
	KC_WINDOW_REQUEST,
	KC_WINDOW_DIALOG,
	KC_WINDOW_COMBAT,
	KC_WINDOW_BUILDING,
	KC_WINDOW_WEEKLY,
	KC_WINDOW_LOADSAVE,
	KC_WINDOW_QUESTCOMPLETE
	// ...
};

struct H7Keybind
{
	var() Keybind keybind; // primary
	var() Keybind secondaryKeybind; // secondary
	var() EKeybindCategory category;
	var() delegate<KeybindFunctionDelegate> keybindFunction;
};

////////////////////// vars ////////////////////////

// Unreal only has another list of currently active keybinds, keys and aliases
var protected array<H7Keybind>  mKeybindList;   // this is a list of all potential keybinds (settable in the optionsmenu) // but no aliases
var protected H7PopupKeybindings mPopupKeybindings;

////////////////////// delegate functions ////////////////////////

public delegate KeybindFunctionDelegate(); // a function with no params and no return values can be called by key presses

/////////////////////// static functions ///////////////////////

public static function H7KeybindManager GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetKeybindManager(); }

/////////////////////// normal functions ///////////////////////

function string GetConflictCategory(EKeybindCategory category)
{
	switch(category)
	{
		case KC_COMBAT:return "combat,general";
		case KC_TOWN:return "town";
		case KC_ADVENTURE:return "adv,general";
		case KC_WINDOW_UNDEFINED:return "undef";
		case KC_WINDOW_GAME_MENU:return "pop1";
		case KC_WINDOW_REQUEST:return "pop2";
		case KC_WINDOW_DIALOG:return "pop3";
		case KC_WINDOW_COMBAT:return "pop4";
		case KC_WINDOW_BUILDING:return "pop5";
		case KC_WINDOW_WEEKLY:return "pop6";
		case KC_WINDOW_LOADSAVE:return "pop7";
		case KC_WINDOW_QUESTCOMPLETE:return "pop8";
		
		case KC_CHEATS:return "cheats";

		case KC_GENERAL:
		case KC_CAMERA:
		case KC_MOVEMENT:
		default:return "general";
	}
}

// add new main categories here:
function bool IsPopupCategory(EKeybindCategory category)
{
	switch(category)
	{
		case KC_ADVENTURE:case KC_COMBAT:case KC_GENERAL:case KC_CAMERA:case KC_MOVEMENT:case KC_TOWN:case KC_CHEATS:
			return false;
	}
	return true;
}

function H7PopupKeybindings GetPopupKeybindingUserSettings()
{
	if(mPopupKeybindings == none)
	{
		mPopupKeybindings = new class'H7PopupKeybindings';
		class'H7PatchingController'.static.GetInstance().PerformPopupKeyBindingPatching(mPopupKeybindings);
	}
	return mPopupKeybindings;
}

function array<H7Keybind> GetKeybindList()   { return mKeybindList; }

function array<H7Keybind> GetKeybindListByCategory(EKeybindCategory cat)   
{	
	local array<H7Keybind> keybinds;
	local H7Keybind keybind;
	foreach mKeybindList(keybind)
	{
		if(keybind.category == cat)
			keybinds.AddItem(keybind);	
	}
	return keybinds;
}

// returns primary or secondary
function Keybind GetPreferedKeybindByCommand(string command)
{
	local H7Keybind entry;
	entry = GetKeybindByCommand(command);
	if(entry.keybind.Name != 'None')
	{
		return entry.keybind;
	}
	else if(entry.secondaryKeybind.Name != 'None')
	{
		return entry.secondaryKeybind;
	}
	else
	{
		return entry.keybind;
	}
}

// if command = command -> return alias
// if command = alias -> return key
function H7Keybind GetKeybindByCommand(String command)
{
	local H7Keybind keybind,emptyKeybind;
	local Keybind unrealKeybind;
	
	// search in manager key->command
	foreach mKeybindList(keybind)
	{
		if(keybind.keybind.Command == command)
		{
			//`log_dui("command" @ command @ "finds keybind:" @ keybind.category @ keybind.keybind.Command @ keybind.keybind.Name @ keybind.secondaryKeybind.Name);
			return keybind;
		}
	}

	// search in unreal list alias->command
	unrealKeybind = class'H7PlayerController'.static.GetPlayerController().GetBindOrAliasByCommand(command);
	if(IsAlias(unrealKeybind.Name))
	{
		return GetKeybindByCommand(String(unrealKeybind.Name)); // search in manager key->alias
	}

	return emptyKeybind;
}

// reads unreal list and puts it into Manager.list
function CreateSetup() // Init
{
	local PlayerInput   playerInput;
	local int		    i,j;
	local bool          linked;
	local H7Keybind     tmp,newKeybind;
	local keybind       empty;
	local array<H7Keybind> keybinds;
	local name          alias;
	
	;

	// reset 
	// - delete all keybinds from manager that are in the ini live list of unreal, except popup keybinds
	for(i = mKeybindList.Length-1;i >= 0;i--)
	{
		if(!IsPopupCategory(mKeybindList[i].category))
		{
			//`log_dui("remove because reset" @ mKeybindList[i].keybind.Name @ mKeybindList[i].keybind.Command);
			mKeybindList.Remove(i,1);
		}
	}

	// order in which AddKeybindToManager() should come from alias->command (fixed) order, not from key->alias order (can change when deleting,merging)
	playerInput = class'H7PlayerController'.static.GetPlayerController().GetPlayerInput();
	for(i = 0;i < PlayerInput.Bindings.Length;i++)
	{
		if(IsAlias(PlayerInput.Bindings[i].Name))
		{
			alias = PlayerInput.Bindings[i].Name;
			linked = false;
			// create a new keybind entry for the options menu:
			newKeybind.category = GetCategoryForCommand(string(alias));
			newKeybind.keybind = empty;
			newKeybind.secondaryKeybind = empty;
			newKeybind.keybindFunction = none;
			
			// find the up to 2 keys that link to this alias
			for(j = 0;j < PlayerInput.Bindings.Length;j++)
			{
				keybinds = SplitKeybind(PlayerInput.Bindings[j]);
				foreach keybinds(tmp)
				{
					if(tmp.keybind.Command == String(alias))
					{
						linked = true;
						if(newKeybind.keybind == empty)
						{
							newKeybind.keybind = tmp.keybind;
						}
						else if(newKeybind.secondaryKeybind == empty)
						{
							newKeybind.secondaryKeybind = tmp.keybind;
						}
						else
						{
							;
						}
					}
				}
			}

			if(!linked)
			{
				;
				newKeybind.keybind.Name = '';
				newKeybind.keybind.Command = string(alias);
				newKeybind.secondaryKeybind.Command = string(alias);
			}

			if(!linked || HasRealKey(newKeybind.keybind) || HasRealKey(newKeybind.secondaryKeybind)) // used to exclude mouse-bindings
			{
				;
				AddKeybindToManager(newKeybind);
			}
		}
	}

	/*
	// create new
	// - well, first I guess we just read the currently active keybinding list from unreal, which comes from the user's MMH7Input.ini
	keybind.category = KC_GENERAL;
	playerInput = class'H7PlayerController'.static.GetPlayerController().GetPlayerInput();
	for(i = 0;i < PlayerInput.Bindings.Length;i++)
	{
		PlayerInput.Bindings[i] = ApplyPostLaunchFixes(PlayerInput.Bindings[i]);

		keybind.keybind = PlayerInput.Bindings[i];

		if(HasRealKey(keybind.keybind))
		{
			//`log_dui(GetDebugString(keybind.keybind));
			// if it is merged keybinding, split apart into multiples:
			keybinds = SplitKeybind(keybind.keybind);
			foreach keybinds(keybind)
			{
				keybind.category = GetCategoryForCommand(keybind.keybind.Command);
				// [real key] -> alias
				AddKeybindToManager(keybind);
			}
		}
		else
		{
			`log_dui(keybind.keybind.Name @ "->" @ keybind.keybind.Command @ "has not a real key");
		}
	}

	// find aliases that currently have no key and add them to the manager as well, with no key assigned
	for(i = 0;i < PlayerInput.Bindings.Length;i++)
	{
		keybind.keybind = PlayerInput.Bindings[i];

		if(!HasRealKey(keybind.keybind))
		{
			// we found alias->exec function or mouse->alias
			//`log_dui(keybind.keybind.Name @ "->" @ keybind.keybind.Command);
			if(left(keybind.keybind.Name,1) == "A")
			{
				linked = false;
				// now it's alias->exec function
				// check if there is another entry that links to that alias (either key or mouse)
				for(j = 0;j < PlayerInput.Bindings.Length;j++)
				{
					keybinds = SplitKeybind(PlayerInput.Bindings[j]);
					foreach keybinds(tmp)
					{
						if(tmp.keybind.Command == String(keybind.keybind.Name) 
							&& tmp.keybind.Name != ' ' // needed to filter out the piped empty keybinds created on release, they don't count as binding an alias (Bindings=(Name=" ",Command="APanUp | APanLeft | APanDown | APanRight | AMoveSouthWest",)
						) 
						{
							linked = true;
							break;
						}
					}
				}
				if(!linked) // truly it is an orphaned alias->exec function
				{
					if(keybind.keybind.Name == 'AQuickBar7' || keybind.keybind.Name == 'AQuickBar8' 
						|| keybind.keybind.Name == 'AQuickBar9' || keybind.keybind.Name == 'AQuickBar10')
					{
						continue; // they should be abandoned
					}
					//          name        -> command
					// is:      alias       -> exec function
					// should:  [empty key] -> alias
					keybind.category = GetCategoryForCommand(string(keybind.keybind.Name));
					keybind.keybind.Command = string(keybind.keybind.Name);
					keybind.keybind.Name = '';
					`log_dui("added orphaned alias" @ keybind.keybind.Name @ "->" @ keybind.keybind.Command);
					AddKeybindToManager(keybind);
				}
			}
		}
	}
	*/
	// Window specific keybinds (Get from window?)
	// - were kept alive for now from previous state

	OrderList();
}

function KeyBind ApplyPostLaunchFixes(KeyBind userKeybind)
{
	if(userKeybind.Name == 'ADollyForward')
	{
		userKeybind.Command = "Axis aBaseY Speed=-1.0";
	}
	if(userKeybind.Name == 'ADollyBackward')
	{
		userKeybind.Command = "Axis aBaseY Speed=1.0";
	}
	if(userKeybind.Name == 'Home' && userKeybind.Command == "ADollyBackward")
	{
		userKeybind.Command = "ADollyForward";
	}
	if(userKeybind.Name == 'End' && userKeybind.Command == "ADollyForward")
	{
		userKeybind.Command = "ADollyBackward";
	}
	return userKeybind;
}

// during Setup, from Unreal ini list
// does not add it to Unreal live ini list
function AddKeybindToManager(H7Keybind newKeybind)
{
	local H7Keybind keybind;
	local int i;

	//`log_dui("AddKeybindToManager" @ newKeybind.category @ newKeybind.keybind.Name @ newKeybind.keybind.Command);

	// check if command is already in our list: then it will become the secondary keybind of this entry
	foreach mKeybindList(keybind,i)
	{
		if(keybind.keybind.Command == newKeybind.keybind.Command && keybind.category == newKeybind.category)
		{
			//`log_dui(keybind.keybind.Command @ "has secondary:" @ GetKeyComboString(keybind.keybind) @ GetKeyComboString(newKeybind.keybind) );
			mKeybindList[i].secondaryKeybind = newKeybind.keybind;
			return;
		}
	}

	mKeybindList.AddItem(newKeybind);
}

// when changing popup keybinds
function OverwritePopupKeybindToManagerAndIniList(H7Keybind newKeybind)
{
	local H7Keybind keybind;
	//local KeyCommand keyCommandForIniList;
	local int i;
	//local bool found;

	;

	// find it and replace it
	foreach mKeybindList(keybind,i)
	{
		if(keybind.keybind.Command == newKeybind.keybind.Command && keybind.category == newKeybind.category)
		{
			;
			mKeybindList[i] = newKeybind;

			// also change it in the ini file
			SaveNewPopupKeybind(newKeybind);

			return;
		}
	}

	/*
	if(!found) // new default popup that is not yet in the user's ini file or the user deleted it
	{
		mKeybindList.AddItem(newKeybind);

		keyCommandForIniList.command = newKeybind.keybind.Command;
		keyCommandForIniList.keyPrimary = newKeybind.keybind;
		keyCommandForIniList.keySecondary = newKeybind.secondaryKeybind;
		mPopupKeybindings.mPopupKeybindings.AddItem(keyCommandForIniList);
	}
	*/

	;
}

function SaveNewPopupKeybind(H7Keybind newKeybind)
{
	local KeyCommand keybind;
	local int i;
	local bool saved;

	foreach mPopupKeybindings.mPopupKeybindings(keybind,i)
	{
		if(keybind.command == newKeybind.keybind.Command)
		{
			mPopupKeybindings.mPopupKeybindings[i].keyPrimary = newKeybind.keybind;
			mPopupKeybindings.mPopupKeybindings[i].keySecondary = newKeybind.secondaryKeybind;
			saved = true;
			break;
		}
	}

	if(!saved)
	{
		;
	}

	mPopupKeybindings.SaveConfig();
}

// does not add it to Unreal live list
// adds or updates only manager.list
function AddPopupKeybindToManager(H7Keybind popupKeybind)
{
	local H7Keybind existingKeybind;
	local int i;
	local bool merged;

	// if in live list:
	// - use key from live list
	// - use functionDelegate from default
	// - use category from default
	foreach mKeybindList(existingKeybind,i)
	{
		if(existingKeybind.keybind.Command == popupKeybind.keybind.Command 
			&& existingKeybind.category == popupKeybind.category)
		{
			// add secondary
			if(existingKeybind.keybind.Name != popupKeybind.keybind.Name)
			{
				if(existingKeybind.secondaryKeybind.Name == 'None') 
					existingKeybind.secondaryKeybind = popupKeybind.keybind;
				else 
					;
			}
			// in any case link the function:
			mKeybindList[i].keybindFunction = popupKeybind.keybindFunction;
			mKeybindList[i].category = popupKeybind.category;
			merged = true;
		}
	}

	if(!merged)
	{
		mKeybindList.AddItem(popupKeybind);
	}
}

// split unreal-keybinds that have multiple commands, into multiple H7 keybinds that can have different categories
function array<H7Keybind> SplitKeybind(Keybind keybind)
{
	local String command;
	local array<String> commandArray;
	local H7Keybind newKeybind;
	local array<H7Keybind> keybindArray;

	newKeybind.keybind = keybind;
	
	commandArray = SplitString(keybind.Command," | ");
	foreach commandArray(command)
	{
		newKeybind.keybind.Command = command; // OPTIONAL why not add category here as well?
		keybindArray.AddItem(newKeybind);
	}
	return keybindArray;
}

function int KeybindCompare(H7Keybind a,H7Keybind b)
{
	if(a.category < b.category) return 1;
	else if(a.category > b.category) return -1;
	else
	{
		// H7Keybinds are ([key1]->alias,[key2]->alias) entries, order them according to the alias order
		//if(mAliasOrder.Find(Name(a.keybind.Command)) < mAliasOrder.Find(Name(b.keybind.Command))) return 1;
		//else return -1;
		return 1; // keep order of file - alphabetic sort not good idea (loca)
		//if(Caps(a.keybind.Command) <= Caps(b.keybind.Command)) return 1; // correct order
		//else return -1; // not correct
	}
}

function OrderList()
{
	mKeybindList.Sort(KeybindCompare);
}

// calls the function that is registered on this keybind
function CallKeybindFunction(H7Keybind keybind)
{
	KeybindFunctionDelegate = keybind.keybindFunction;
	KeybindFunctionDelegate();
}

// only accepts commands that have been split apart (no piped commands!)
function EKeybindCategory GetCategoryForCommand(String command)
{
	local EKeybindCategory category;
	local H7Keybind keybind;

	// OPTIONAL fix hardcoded mapping? :-(
	switch(command)
	{
		case "ASelectHeroDefaultAttack":
		case "ADoDefend":
		case "ADoWait":
		case "AToggleCreatureHpBars":
			category = KC_COMBAT;
			break;
		case "AOpenMainBuilding":
		case "AOpenRecruitmentWindow":
		case "ABuyAllRecruits":
		case "AOpenGuildOfThieves":
		case "AOpenMagicGuild":
		case "AOpenMarketPlace":
		case "AOpenHallOfHeroes":
		case "AOpenCaravan":
		case "AOpenCustom1":
		case "AOpenCustom2":
		case "AOpenTownDefense":
		case "AOpenWarfare":
		case "AMergeArmyUp":
		case "AMergeArmyDown":
		case "ASwapArmies":
		case "ATownNext":
		case "ATownPrev":
			category = KC_TOWN;
			break;
		case "APanUp":
		case "APanLeft":
		case "APanDown":
		case "APanRight":
		case "ADollyForward":
		case "ADollyBackward":
		case "ARotateClockwise":
		case "ARotateCounterClockwise":
		case "AResetCamera":
			category = KC_CAMERA;
			break;
		case "AMoveEast":
		case "AMoveWest":
		case "AMoveNorth":
		case "AMoveSouth":
		case "AMoveNorthEast":
		case "AMoveNorthWest":
		case "AMoveSouthEast":
		case "AMoveSouthWest":
			category = KC_MOVEMENT;
			break;
		case "AShowRealmOverview": 
		case "AOpenHeropedia":	
			category = KC_CHEATS;			break; // TODO move if window is there
		case "AHighlightAdventureObjects":
		case "AOpenHeroWindow":
		case "AToggleMiniMapOptions":
		case "AEndTurn":
		case "AOpenQuestLog":
		case "AOpenSKillwheel":
		case "AOpenSpellBook":
		case "AContinueHeroMove":
		case "AToggleTable":
		case "ASelectHero1":case "ASelectHero2":case "ASelectHero3":case "ASelectHero4":case "ASelectHero5":
		case "ASelectHero6":case "ASelectHero7":case "ASelectHero8":case "ASelectHero9":case "ASelectHero10":
		case "ASelectTown1":case "ASelectTown2":case "ASelectTown3":case "ASelectTown4":case "ASelectTown5":
		case "ASelectTown6":case "ASelectTown7":case "ASelectTown8":case "ASelectTown9":case "ASelectTown10":
			category = KC_ADVENTURE;
			break;
		// real cheats
		case "ATeleportHero":case "APlusLevel":case "APlusResources":case "ABuildAll":case "AToggleFog":case "APlusSkillPoint":case "ADoubleArmy":
		// debug  helps
		case "F1":case "F2":case "F3":
		case "viewmode wireframe": case "viewmode unlit": case "viewmode lit":
		// stuff we want to hide from the user
		case "AContinueContext": // because conflict to heromove and self-evident
		case "ADollyForwardInstant": // because mouse
		case "ADollyBackwardInstant": // because mouse
			category = KC_CHEATS;
			break;
		case "AToggleEventLog":// + QuickBarSlots
		default:
			// popups hopefully added their keybinds to the manager, including category, so we can ask if there is a matching one there
			// commands forgotten to add to the list above will get KC_GENERAL
			keybind = GetKeybindByCommand(command);

			// we can not distinguish here between keybinds that were not found and keybinds that are unassigned :-(
			if(keybind.keybind.Name == 'None' && keybind.category == KC_GENERAL) // at least it does not matter for general:
			{
				category = KC_GENERAL;
			}
			else
			{
				if(IsPopupCategory(keybind.category))
				{
					category = keybind.category;
				}
				else
				{
					category = KC_GENERAL;
				}
			}
	}
	return category;
}

////////////////////////////////////////////////////////////////////////////////
// dealing with the unreal system and the unreal keybind ini live list
////////////////////////////////////////////////////////////////////////////////

// collapses keybinds that all have the same key, into one piped command keybind for unreal ini list
function H7Keybind CollapseKeybinds(array<H7Keybind> keybinds)
{
	local H7Keybind combinedKeybind;
	local H7Keybind keybind;
	local int i;

	combinedKeybind.keybind.Alt = keybinds[0].keybind.Alt;
	combinedKeybind.keybind.Control = keybinds[0].keybind.Control;
	combinedKeybind.keybind.Shift = keybinds[0].keybind.Shift;
	combinedKeybind.keybind.Name = keybinds[0].keybind.Name;

	foreach keybinds(keybind,i)
	{
		combinedKeybind.keybind.Command = combinedKeybind.keybind.Command $ (i==0?"":" | ") $ keybind.keybind.Command;
	}

	return combinedKeybind;
}

function DeletePopupKeybinding(string command)
{
	local int i;

	// popup keybindings are in the manager list and the popup ini list

	// 'delete' from popup ini list by only setting the bindings to "" [empty]
	for(i=mPopupKeybindings.mPopupKeybindings.Length-1;i>=0;i--)
	{
		if(mPopupKeybindings.mPopupKeybindings[i].command == command)
		{
			mPopupKeybindings.mPopupKeybindings[i].keyPrimary.Name = '';
			mPopupKeybindings.mPopupKeybindings[i].keySecondary.Name = '';
		}
	}

	mPopupKeybindings.SaveConfig();

	// 'delete' from manager list by only setting the bindings to "" [empty]
	for(i=mKeybindList.Length-1;i>=0;i--)
	{
		if(mKeybindList[i].keybind.Command == command)
		{
			mKeybindList[i].keybind.Name = '';
			mKeybindList[i].secondaryKeybind.Name = '';
		}
	}
}

function DeleteFromUnreal(String command)
{
	local PlayerInput playerInput;
	local int		BindIndex,i;
	local array<H7Keybind> keybinds;
	local H7Keybind keybind;

	;
	playerInput = class'H7PlayerController'.static.GetPlayerController().GetPlayerInput();
	
	// replace it
	for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(InStr(PlayerInput.Bindings[BindIndex].Command,command) > -1)
		{
			if(InStr(PlayerInput.Bindings[BindIndex].Command,"|") > -1)
			{
				;
				// it's a piped entry, we have to surgically remove our command:
				keybinds = SplitKeybind(PlayerInput.Bindings[BindIndex]);
				for(i=keybinds.Length-1;i>=0;i--)
				{
					if(keybinds[i].keybind.Command == command)
					{
						keybinds.Remove(i,1);
					}
				}
				// and build it back together
				keybind = CollapseKeybinds(keybinds);
				// and replace it:
				PlayerInput.Bindings[BindIndex].Command = keybind.keybind.Command;
				;
			}
			else
			{
				;
				// remove the entire entry
				PlayerInput.Bindings.Remove(BindIndex,1);
			}
		}
	}

	PlayerInput.SaveConfig();
}

// called from GUI cntl when save|apply
// delete keybind when pkey / skey = " "
function bool SetKeybind(String command,bool pshift,bool palt,bool pcontrol,String pkey,bool sshift,bool salt,bool scontrol,String skey)
{
	local keybind newKeybind;
	local keybind oldKeybind;
	local EKeybindCategory category;
	local H7Keybind managerKeybind;

	;

	// delete command from all existing keybinds:
	DeleteFromUnreal(command);

	category = GetCategoryForCommand(command);

	if(!IsPopupCategory(category)) // popup keybinds are not added to unreal ini live list, because they should not be active all the time
	{
		;
		if(pkey != "None" && pkey != " ")
		{
			// add primary keyCombo:
			newKeybind.Name = Name(pkey);
			newKeybind.Shift = pshift;
			newKeybind.Alt = palt;
			newKeybind.Control = pcontrol;
			newKeybind.Command = command;

			oldKeybind = GetConflictUnrealKeybind(newKeybind); // get keybind with the same keybindcombo

			AddToUnreal(newKeybind,oldKeybind);
		}
		if(skey != "None" && skey != " ")
		{
			// add secondary keyCombo:
			newKeybind.Name = Name(skey);
			newKeybind.Shift = sshift;
			newKeybind.Alt = salt;
			newKeybind.Control = scontrol;
			newKeybind.Command = command;

			oldKeybind = GetConflictUnrealKeybind(newKeybind); // get keybind with the same keybindcombo

			AddToUnreal(newKeybind,oldKeybind);
		}
	}
	else
	{
		;
		
		// delete command from all existing keybinds, and only re-add it if the user has set keys
		DeletePopupKeybinding(command);

		managerKeybind = GetKeybindByCommand(command); // this will be empty since we just deleted it

		if(pkey != "None" && pkey != " ")
		{
			// add primary keyCombo:
			newKeybind.Name = Name(pkey);
			newKeybind.Shift = pshift;
			newKeybind.Alt = palt;
			newKeybind.Control = pcontrol;
			newKeybind.Command = command;

			managerKeybind.keybind = newKeybind;
		}
		if(skey != "None" && skey != " ")
		{
			// add secondary keyCombo:
			newKeybind.Name = Name(skey);
			newKeybind.Shift = sshift;
			newKeybind.Alt = salt;
			newKeybind.Control = scontrol;
			newKeybind.Command = command;

			managerKeybind.secondaryKeybind = newKeybind;
		}

		if(managerKeybind.keybind.Name != '' || managerKeybind.keybind.Name != '') // user set something
		{
			OverwritePopupKeybindToManagerAndIniList(managerKeybind);
		}
	}

	/* was moved to be done once per key changing session into H7OptionsMenuCntl
	// also set it equivalent in mKeybindList
	CreateSetup();

	// and refresh list in Options:
	class'H7OptionsManager'.static.GetInstance().CreateOptionsFromKeybinds();
	*/
	return true;
}

// sets the keybind in the real unreal playerinput live list
// adds it to a long piped list of x | y | z .... commands if neccessary
function AddToUnreal(Keybind keybind,Keybind oldKeybind)
{
	local PlayerInput playerInput;
	local int		BindIndex;

	;
	playerInput = class'H7PlayerController'.static.GetPlayerController().GetPlayerInput();
	
	if(oldKeybind.Name != 'None')
	{
		// merge it
		;
		keybind.Command = oldKeybind.Command @ "|" @ keybind.Command;

		// replace it
		for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
		{
			if(HasEqualKeyCombo(PlayerInput.Bindings[BindIndex],keybind))
			{
				PlayerInput.Bindings[BindIndex].Command = keybind.Command;
			}
		}
	}
	else
	{
		// add it:
		;
		PlayerInput.Bindings[PlayerInput.Bindings.Length] = keybind;
	}

	// save it to ini
	PlayerInput.SaveConfig();
}

function bool HasEqualKeyCombo(Keybind key1,Keybind key2)
{
	if(key1.Name == key2.Name
		&& key1.Shift == key2.Shift
		&& key1.Alt == key2.Alt
		&& key1.Control == key2.Control
	)
		return true;
	return false;
}

// checks the list of currently active keybinds to see if there is one that conflicts with the given keybind
function Keybind GetConflictUnrealKeybind(Keybind newKeybind)
{
	local PlayerInput playerInput;
	local int		BindIndex;
	local KeyBind   empty;

	empty.Name = 'None';

	playerInput = class'H7PlayerController'.static.GetPlayerController().GetPlayerInput();

	for(BindIndex = PlayerInput.Bindings.Length-1;BindIndex >= 0;BindIndex--)
	{
		if(HasEqualKeyCombo(PlayerInput.Bindings[BindIndex],newKeybind))
		{
			return PlayerInput.Bindings[BindIndex];
		}
	}

	return empty;
}

function String GetDebugString(Keybind keybind)
{
	return GetKeyComboString(keybind) @ "            " @ keybind.Command;
}

function String GetKeyComboString(Keybind keybind)
{
	return (keybind.Shift?"Shift+":"") $ (keybind.Alt?"Alt+":"") $ (keybind.Control?"Ctrl+":"") $ keybind.Name;
}

// key to alias = real
// key to execfunction = real
// alias to execfunction = not real
function bool HasRealKey(Keybind keybind)
{
	if(keybind.Control || keybind.Alt || keybind.Shift) 
	{
		return true;
	}
	
	return IsRealKey(keybind.Name);
}

function bool IsRealKey(Name keyStr)
{
	if(Left(keyStr,1) == "A")
	{
		// either an Alias or a key that starts with "A"
		switch(keyStr)
		{
			// real keys starting with A
			case 'A':case 'Add': // these are all (see: http://udn.epicgames.com/Three/KeyBinds.html )
				return true;
			default:
				return false;
		}
	}

	switch(keyStr)
	{
		case 'F1':case 'F2':case 'F3':case 'F4':case 'F5':case 'F6':case 'F7':case 'F8':case 'F9':case 'F10':case 'F11':case 'F12':
		case 'A':case 'B':case 'C':case 'D':case 'E':case 'F':case 'G':case 'H':case 'I':case 'J':case 'K':case 'L':case 'M':case 'N':
		case 'O':case 'P':case 'Q':case 'R':case 'S':case 'T':case 'U':case 'V':case 'W':case 'X':case 'Y':case 'Z':
		case 'Escape':
		case 'Tab':
		case 'Tilde':
		case 'ScrollLock':
		case 'Pause':
		case 'one':
		case 'two':
		case 'three':
		case 'four':
		case 'five':
		case 'six':
		case 'seven':
		case 'eight':
		case 'nine':
		case 'zero':
		case 'Underscore':
		case 'Equals':
		case 'Backslash':
		case 'LeftBracket':
		case 'RightBracket':
		case 'Enter':
		case 'CapsLock':
		case 'Semicolon':
		case 'Quote':
		case 'LeftShift':
		case 'Comma':
		case 'Period':
		case 'Slash':
		case 'RightShift':
		case 'LeftControl':
		case 'LeftAlt':
		case 'SpaceBar':
		case 'RightAlt':
		case 'RightControl':
		case 'Left':
		case 'Up':
		case 'Down':
		case 'Right':
		case 'Home':
		case 'End':
		case 'Insert':
		case 'PageUp':
		case 'Delete':
		case 'PageDown':
		case 'NumLock':
		case 'Divide':
		case 'Multiply':
		case 'Subtract':
		case 'Add':
		case 'PageDown':
		case 'NumPadOne':
		case 'NumPadTwo':
		case 'NumPadThree':
		case 'NumPadFour':
		case 'NumPadFive':
		case 'NumPadSix':
		case 'NumPadSeven':
		case 'NumPadEight':
		case 'NumPadNine':
		case 'NumPadZero':
		case 'Decimal':
			return true;
	}

	return false;
}















function bool IsAlias(Name aliasOrKey)
{
	if(Left(aliasOrKey,1) == "A" && aliasOrKey != 'A')
	{
		return true;
	}
	return false;
}


// deprecated


/*
function ExecuteUnrealKeybind(Keybind keybind)
{
	local String command;
	local array<H7Keybind> keybinds;
	local H7Keybind keybindEntry;
	local Keybind keybindToExecute;

	// possible redirect:
	if(IsAlias(keybind.Command))
	{
		`log_dui("alias");
		keybindToExecute = class'H7PlayerController'.static.GetPlayerController().GetBindByKey(Name(keybind.Command));
		if(keybindToExecute.Name == 'None')
		{
			`log_dui("oops not an alias afterall, or function does not exist");
			keybindToExecute = keybind; // set it back to original param
		}
	}

	// execute all piped commands:
	keybinds = SplitKeybind(keybindToExecute);
	foreach keybinds(keybindEntry)
	{
		command = keybindEntry.keybind.Command;
		`log_dui("Manually exec:" @ command);
		if(Left(command,9) == "onrelease")
		{
			command = Split(command,"onrelease ",true);
		}
		class'H7PlayerController'.static.GetPlayerController().ConsoleCommand(command);
	}
}
*/

// check if conflict
function bool CausesConflict(String command,String key,bool shift,bool alt,bool control)
{
	local keybind newKeybind;
	local H7Keybind entry;

	;

	newKeybind.Name = Name(key);
	newKeybind.Shift = shift;
	newKeybind.Alt = alt;
	newKeybind.Control = control;
	newKeybind.Command = command;

	entry = GetConflictKeyComboFromManagerList(newKeybind);

	if(entry.keybind.Name != 'None')
	{
		// conflict!!!
		;
		return true;
	}

	// OPTIONAL check if a command exists in 3 or more keys

	return false;
}


// search if any entry has the keycombo in primary or secondary field
function H7Keybind GetConflictKeyComboFromManagerList(Keybind keybind)
{
	local H7Keybind entry;
	local EKeybindCategory newCategory;

	newCategory = GetCategoryForCommand(keybind.Command);

	foreach mKeybindList(entry)
	{
		if(HasEqualKeyCombo(keybind,entry.keybind) || HasEqualKeyCombo(keybind,entry.secondaryKeybind))
		{
			// same category?
			if(newCategory == entry.category)
			{
				// conflict! (unless it's the same command)
				if(keybind.Command == entry.keybind.Command)
				{
					// conflict averted! (unless it's the same in primary and secondary)
					// we don't know here if the new keybind will be primary or secondary
				}
				else
				{
					return entry;
				}
			}
			else
			{
				// it's ok do have the same keycombos in each category once
				// i.e.
				// H -> opens hero screen (adventuremap-hud)
				// H -> opens hero hall (townscreen)
				// H -> toggles healthbars (combatmap-hud)
			}
		}
	}

	entry.keybind.Name = 'None';
	return entry;
}
