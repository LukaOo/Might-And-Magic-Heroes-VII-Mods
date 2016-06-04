class H7GUISoundPlayer extends Object
	config(game)
	placeable;

//"globalconfig"
var(GUISound_Generic) AkEvent mClickCommandButton<DisplayName=Click Command Button>;
var(GUISound_Generic) AkEvent mClickInactiveCommandButton<DisplayName=Click Inactive Command Button>;
var(GUISound_Generic) AkEvent mClickCloseCommandButton<DisplayName=Click Close Command Button>;
var(GUISound_Generic) AkEvent mInventoryItemGrabbed<DisplayName=Drag>;
var(GUISound_Generic) AkEvent mInventoryItemDropped<DisplayName=Drop>;
var(GUISound_Generic) AkEvent mHoverButtonSound<DisplayName= On Hover>;
var(GUISound_Generic) AkEvent mPopUpOpenSound<DisplayName= Pop Up Open>;
var(GUISound_Generic) AkEvent mPopUpCloseSound<DisplayName= Pop Up Close>;
var(GUISound_Generic) AkEvent mClickCheckBox<DisplayName= Click Checkbox>;
var(GUISound_Generic) AkEvent mRadioButtonSound<DisplayName= Radio Button>;
var(GUISound_Generic) AkEvent mToggleSound<DisplayName= Toggle Button>;
var(GUISound_Generic) AkEvent mIconSelected<DisplayName= Icon Selected>;
var(GUISound_Generic) AkEvent mInvalid<DisplayName= Invalid Select>;
var(GUISound_Generic) AkEvent mTextButtonSelected<DisplayName=Text Button Selected>;

var(GUISound_Combat) AkEvent mClickFleeSurrenderAbortButton<DisplayName=Combat: Click Flee Surrender Abort Button>;
var(GUISound_Combat) AkEvent mFleeSurrenderWindowShown<DisplayName=Combat: Flee Surrender Window Shown>;
var(GUISound_Combat) AkEvent mClickFleeSurrenderTextButton<DisplayName=Combat: Click Flee Surrender Text Button>;
var(GUISound_Combat) AkEvent mEnterCombat<DisplayName=Combat: Enter Combat>;
var(GUISound_Combat) AkEvent mVictoryWindowShown<DisplayName=Combat: Victory Window Shown>;
var(GUISound_Combat) AkEvent mDefeatWindowShown<DisplayName=Combat: Defeat Window Shown>;
var(GUISound_Combat) AkEvent mGainXPSound<DisplayName=Combat: Gain XP Combat Results>;
var(GUISound_Combat) AkEvent mGainXPEndSound<DisplayName=Combat: Gain XP Combat Results End>;
var(GUISound_Combat) AkEvent mLostUnitsSound<DisplayName=Combat: Units Lost Combat Results Loop>;
var(GUISound_Combat) AkEvent mLostUnitsEndSound<DisplayName=Combat: Units Lost Combat Results End>;
var(GUISound_Combat) AkEvent mFightAgainSound<DisplayName=Combat: Fight Again>;
var(GUISound_Combat) AkEvent mWaitSound<DisplayName=Combat: Wait Button>;
var(GUISound_Combat) AkEvent mDefendSound<DisplayName=Combat: Defend Button>;
var(GUISound_Combat) AkEvent mStopCombatJingleSound <DisplayName=Combat: Stop Combat Jingle Sound>;
var(GUISound_Combat) AkEvent mEngageQuickCombat <DisplayName=Combat: Engage Quick Combat Sound>;
var(GUISound_Combat) AkEvent mEngageCombat <DisplayName=Combat: Engage Manual Combat Sound>;
var(GUISound_Combat) AkEvent mAbilitySound <DisplayName=Combat: Ability Selected Sound>;
var(GUISound_Combat) AkEvent mWinQuickCombatSound<DisplayName= Quick Combat PopUp: Win sound>;
var(GUISound_Combat) AkEvent mLoseQuickCombatSound<DisplayName= Quick Combat PopUp: Lose sound>;

var(GUISound_Spellbook) AkEvent mClickSpellBookButton<DisplayName=Spell Book: Click Button>;
var(GUISound_Spellbook) AkEvent mClickSpellBookCloseButton<DisplayName=Spell Book: Click Close Button>;
var(GUISound_Spellbook) AkEvent mClickSelectSpell<DisplayName=Spell Book: Click Select Spell>;
var(GUISound_Spellbook) AkEvent mSpellBookTurnPageUpSound<DisplayName= Spell Book: Turn Page Up>;
var(GUISound_Spellbook) AkEvent mSpellBookTurnPageDownSound<DisplayName= Spell Book: Turn Page Down>;
var(GUISound_Spellbook) AkEvent mSpellBookMagicSchoolSound<DisplayName= Spell Book: Magic School Tab click>;
var(GUISound_Spellbook) AkEvent mAddSpellIcon<DisplayName= Spell Book: Add Spell to Cursor>;
var(GUISound_Spellbook) AkEvent mRemoveSpellIcon<DisplayName= Spell Book: Remove Spell from Cursor>;

var(GUISound_TownScreen) AkEvent mBuildBuilding<DisplayName=Townscreen: Create Building>;
var(GUISound_TownScreen) AkEvent mAddBuilding<DisplayName=Townscreen: Add Building>;
var(GUISound_TownScreen) AkEvent mBuyHeroSound<DisplayName=Townscreen: Buy Hero>;
var(GUISound_TownScreen) AkEvent mRecruitArmySound<DisplayName=Townscreen: Recruit Army>;
var(GUISound_TownScreen) AkEvent mEnterSound<DisplayName=Townscreen: Enter>;
var(GUISound_TownScreen) AkEvent mLeaveSound<DisplayName=Townscreen: Leave>;
var(GUISound_TownScreen) AkEvent mSplitStackSound<DisplayName=Townscreen: Troops Split Stack>;
var(GUISound_TownScreen) AkEvent mUpgradeUnitSound<DisplayName=Townscreen: Upgrade Unit>;
var(GUISound_TownScreen) AkEvent mDestroyBuildingLevelSound<DisplayName=Townscreen: Destroy Building Level>;
var(GUISound_TownScreen) AkEvent mOpenBuildTree<DisplayName=Townscreen: Open Build Tree>;

var(GUISound_TownScreen_MarketPlace) AkEvent mMarketGoldSound<DisplayName= Marketplace: Gold Button>;
var(GUISound_TownScreen_MarketPlace) AkEvent mMarketOreSound<DisplayName= Marketplace: Ore Button>;
var(GUISound_TownScreen_MarketPlace) AkEvent mMarketWoodSound<DisplayName= Marketplace: Wood Button>;
var(GUISound_TownScreen_MarketPlace) AkEvent mMarketDragonBloodCrystalSound<DisplayName= Marketplace: DragonBloodCrystal Button>;
var(GUISound_TownScreen_MarketPlace) AkEvent mMarketDragonSteelSound<DisplayName= Marketplace: DragonSteel Button>;
var(GUISound_TownScreen_MarketPlace) AkEvent mMarketShadowSteelSound<DisplayName= Marketplace: ShadowSteel Button>;
var(GUISound_TownScreen_MarketPlace) AkEvent mMarketStarSilverSound<DisplayName= Marketplace: Starsilver Button>;
var(GUISound_TownScreen_MarketPlace) AkEvent mMarketTradeSound<DisplayName= Marketplace: Trade Button>;

var(GUISound_AdventureMap) AkEvent mEndTurnSound<DisplayName=Adv. map: End turn button>;
var(GUISound_AdventureMap) AkEvent mNextWeekSound<DisplayName=Adv. map: Next Week sound>;
var(GUISound_AdventureMap) AkEvent mVictorySound<DisplayName=Adv. map: Victory sound>;
var(GUISound_AdventureMap) AkEvent mDefeatSound<DisplayName=Adv. map: Defeat sound>;
var(GUISound_AdventureMap) AkEvent mAlreadyVisited<DisplayName=Adv. map: Building already visited sound>;
var(GUISound_AdventureMap) AkEvent mCannotMoveThere<DisplayName=Adv. map: Cannot move there sound>;
var(GUISound_AdventureMap) AkEvent mNotEnoughMovePoints<DisplayName=Adv. map: Not enough move points sound>;
var(GUISound_AdventureMap) AkEvent mBlockedByArmy<DisplayName=Adv. map: Blocked by army sound>;
var(GUISound_AdventureMap) AkEvent mClickHeroPortraitSound<DisplayName=Adv. map: Hero portrait clicked sound>;
var(GUISound_AdventureMap) AkEvent mSelectSpellSound<DisplayName=Adv. map: Select spell sound>;
var(GUISound_AdventureMap) AkEvent mWidgetHeroButtonSound<DisplayName=Adv. map: Hero button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetSpellbookButtonSound<DisplayName=Adv. map: Spellbook button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetSkillWheelButtonSound<DisplayName=Adv. map: Skillwheel button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetQuestlogButtonSound<DisplayName=Adv. map: Questlog button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetMoveButtonSound<DisplayName=Adv. map: Move button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetMinimapMenu<DisplayName=Adv. map: Minimap menu button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetMinimapAoc<DisplayName=Adv. map: Minimap AoC button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetMinimapPlane<DisplayName=Adv. map: Minimap select plane button sound>;
var(GUISound_AdventureMap) AkEvent mWidgetMinimapToggle<DisplayName=Adv. map: Minimap menu toggle button sound>;
var(GUISound_AdventureMap) AkEvent mQuestComplete<DisplayName=Adv. map: Quest Complete sound>;
var(GUISound_AdventureMap) AkEvent mQuestRecieved<DisplayName=Adv. map: Quest Recieved sound>;
var(GUISound_AdventureMap) AkEvent mDestroyedArmy<DisplayName=Adv. map: Destroyed Army sound>;
var(GUISound_AdventureMap) AkEvent mWinMapSound<DisplayName=Adv. map: Win Map sound>;
var(GUISound_AdventureMap) AkEvent mLoseMapSound<DisplayName=Adv. map: Lose Map sound>;
var(GUISound_AdventureMap) AkEvent mStopMapResultJingle<DisplayName=Adv. map: Stop Map Result Jingle>;

var(GUISound_CharacterScreen) AkEvent mUnEquipItem<DisplayName=Character Screen: UnEquipItem>;
var(GUISound_CharacterScreen) AkEvent mEquipItem<DisplayName=Character Screen: EquipItem>;
var(GUISound_CharacterScreen) AkEvent mOpenSkillWheelSound<DisplayName= Character Screen: Open Skillwheel>;
var(GUISound_CharacterScreen) AkEvent mCloseSkillWheelSound<DisplayName= Character Screen: Close Skillwheel>;
var(GUISound_CharacterScreen) AkEvent mConfirmSkillWheelSound<DisplayName= Character Screen: Confirm Skill on Skillwheel>;
var(GUISound_CharacterScreen) AkEvent mSelectSkillWheelSound<DisplayName= Character Screen: Select Skill on Skillwheel>;
var(GUISound_CharacterScreen) AkEvent mHeroScreenOpenSound<DisplayName= Character Screen: Open Hero Screen>;
var(GUISound_CharacterScreen) AkEvent mHeroScreenCloseSound<DisplayName= Character Screen: Close Hero Screen>;

///////////////////////////////////////////////////////////////////
//SOUND_PLAYER
///////////////////////////////////////////////////////////////////

function PlaySoundStr(string str)
{
	local AkEvent sound;
	local bool soundSetting;
	local bool masterSoundSetting;

	soundSetting = class'H7SoundController'.static.GetInstance().GetSoundSetting();
	masterSoundSetting = class'H7SoundController'.static.GetInstance().GetMasterSettings();

	switch(str)
	{
		case "WAIT_BUTTON_CLICK": sound = mWaitSound; break;
		case "DEFEND_BUTTON_CLICK": sound = mDefendSound; break;
		
		case "REMOVE_SPELL_ICON": sound = mRemoveSpellIcon;break; // cancel spell
		case "ADD_SPELL_ICON": sound = mAddSpellIcon;break;
		case "SELECT_SPELL": sound = mSelectSpellSound;break;
		case "CLICK_SELECT_SPELL": sound = mClickSelectSpell;break;
		case "ABILITY_SELECTED": sound = mAbilitySound; break;
		
		case "CLICK_COMMAND_BUTTON": sound = mClickCommandButton;break;
		case "CLICK_INACTIVE_COMMAND_BUTTON": sound = mClickInactiveCommandButton;break;
		case "CLICK_SPELL_BOOK_BUTTON": sound = mClickSpellBookButton;break;
		case "CLICK_SPELL_BOOK_CLOSE_BUTTON": sound = mClickSpellBookCloseButton;break;
		case "FLEE_SURRENDER_WINDOW_SHOWN": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mFleeSurrenderWindowShown;
			break;
		case "CLICK_TEXT_BUTTON": sound = mTextButtonSelected;break;
		case "CLICK_CHECKBOX": sound = mClickCheckBox;break;
		case "POP_UP_OPEN_SOUND": sound = mPopUpOpenSound;break;
		case "POP_UP_CLOSE_SOUND": sound = mPopUpCloseSound;break;
		case "VICTORY_SOUND": sound = mVictorySound;break;
		case "DEFEAT_SOUND": sound = mDefeatSound;break;
		case "ENTER_COMBAT": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mEnterCombat;
			break;
		case "VICTORY_WINDOW_SHOWN": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mVictoryWindowShown;
			break;
		case "DEFEAT_WINDOW_SHOWN": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mDefeatWindowShown;
			break;
		case "DEFEAT_QUICK_COMBAT": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mLoseQuickCombatSound;
			break;
		case "VICTORY_QUICK_COMBAT": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mWinQuickCombatSound;
			break;
		case "WIN_MAP": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mWinMapSound; break;
		case "LOSE_MAP": 
			class'H7SoundController'.static.GetInstance().StartMusicDucking();
			sound = mLoseMapSound; break;
		case "STOP_COMBAT_JINGLE": sound = mStopCombatJingleSound; break;
		case "END_TURN_BUTTON": sound = mEndTurnSound;break;
		case "NEW_WEEK": sound = mNextWeekSound; break;
		case "DRAG": sound = mInventoryItemGrabbed;break;
		case "DROP": sound = mInventoryItemDropped;break;
		case "UNEQUIP_ITEM": sound = mUnEquipItem;break;
		case "EQUIP_ITEM": sound = mEquipItem;break;
		case "SPELLBOOK_TURN_PAGE_UP": sound = mSpellBookTurnPageUpSound;break;
		case "SPELLBOOK_TURN_PAGE_DOWN": sound = mSpellBookTurnPageDownSound;break;
		case "SPELLBOOK_MAGIC_SCHOOL_SWITCH": sound = mSpellBookMagicSchoolSound;break;
		case "GAIN_XP": sound = mGainXPSound;break;
		case "GAIN_XP_END": sound = mGainXPEndSound;break;
		case "ON_HOVER": sound = mHoverButtonSound;break;
		case "CREATE_BUILDING": sound = mBuildBuilding;break;
		case "ENTER_TOWN": sound = mEnterSound;break;
		case "LEAVE_TOWN": sound = mLeaveSound;break;
		case "BUY_HERO": sound = mBuyHeroSound;break;
		case "RECRUIT_ARMY": sound = mRecruitArmySound;break;
		case "OPEN_SKILLWHEEL": sound = mOpenSkillWheelSound;break;
		case "CLOSE_SKILLWHEEL": sound = mCloseSkillWheelSound;break;
		case "CONFIRM_SKILL_SKILLWHEEL": sound = mConfirmSkillWheelSound;break;
		case "SELECT_SKILL_SKILLWHEEL": sound = mSelectSkillWheelSound;break;
		case "MARKET_GOLD": sound = mMarketGoldSound;break;
		case "MARKET_ORE": sound = mMarketOreSound;break;
		case "MARKET_WOOD": sound = mMarketWoodSound;break;
		case "MARKET_BLOOD_CRYSTAL": sound = mMarketDragonBloodCrystalSound;break;
		case "MARKET_DRAGON_STEEL": sound = mMarketDragonSteelSound;break;
		case "MARKET_SHADOW_STEEL": sound = mMarketShadowSteelSound;break;
		case "MARKET_STAR_SILVER": sound = mMarketStarSilverSound;break;
		case "MARKET_TRADE": sound = mMarketTradeSound;break;
		case "LOST_UNIT_COUNT": sound = mLostUnitsSound;break;
		case "LOST_UNIT_COUNT_END": sound = mLostUnitsEndSound;break;
		case "FIGHT_AGAIN": sound = mFightAgainSound;break;
		case "OPEN_HERO_SCREEN": sound = mHeroScreenOpenSound;break;
		case "CLOSE_HERO_SCREEN": sound = mHeroScreenCloseSound;break;
		case "SPLIT_STACK_BUTTON": sound = mSplitStackSound;break;
		case "CLICK_CLOSE_COMMAND_BUTTON": sound = mClickCloseCommandButton;break;
		case "ALREADY_VISITED": sound = mAlreadyVisited;break;
		case "CANNOT_MOVE_THERE": sound = mAlreadyVisited;break;
		case "NOT_ENOUGH_MOVE_POINTS": sound = mAlreadyVisited;break;
		case "BLOCKED_BY_ARMY": sound = mBlockedByArmy;break;
		case "CLICK_HERO_PORTRAIT": sound = mClickHeroPortraitSound;break;
		case "UPGRADE_UNIT": sound = mUpgradeUnitSound;break;
		case "HUD_HERO_CLICK_WIDGET": sound = mWidgetHeroButtonSound;break;
		case "HUD_SPELLBOOK_CLICK_WIDGET": sound = mWidgetSpellbookButtonSound;break;
		case "HUD_SKILLWHEEL_CLICK_WIDGET": sound = mWidgetSkillWheelButtonSound;break;
		case "HUD_QUESTLOG_CLICK_WIDGET": sound = mWidgetQuestlogButtonSound;break;
		case "HUD_MOVE_CLICK_WIDGET": sound = mWidgetMoveButtonSound;break;
		case "MINIMAP_MENU_CLICK": sound = mWidgetMinimapMenu;break;
		case "MINIMAP_TOGGLE_AOC": sound = mWidgetMinimapAoc;break;
		case "MINIMAP_TOGGLE_PLANE": sound = mWidgetMinimapPlane;break;
		case "MINIMAP_TOGGLE": sound = mWidgetMinimapToggle;break;
		case "QUEST_COMPLETE": sound = mQuestComplete;break;
		case "QUEST_RECIEVED": sound = mQuestRecieved;break;
		case "DESTROY_BUILDING_LEVEL": sound = mDestroyBuildingLevelSound;break;	
		case "DESTROY_ARMY_SOUND": sound = mDestroyedArmy; break;
		case "ADD_BUILDING": sound = mAddBuilding; break;
		case "STOP_MAP_RESULT_JINGLE": sound = mStopMapResultJingle; break;
		case "ENGAGE_COMBAT": sound = mEngageCombat; break;
		case "ENGAGE_QUICK_COMBAT": sound = mEngageQuickCombat; break;
		case "ICON_SELECT": sound = mIconSelected; break; // selecting school, army, map, anything (except spell,checkboxes)
		case "INVALID_SELECT": sound = mInvalid; break;
		case "OPEN_BUILD_TREE": sound = mOpenBuildTree; break;
		case "TOGGLE": sound = mToggleSound; break;
		case "FLEE_SURRENDER_SELECTED": sound = mClickFleeSurrenderTextButton; break;
		case "RADIO_BUTTON": sound = mRadioButtonSound; break; // radio button uses minimap_toggle
		
		default:;
	}
	if(sound != none && soundSetting && masterSoundSetting && class'H7SoundController'.static.GetInstance() != none)
	{
		class'H7SoundController'.static.PlayGlobalAkEvent(sound,true);
	}
}

//---------------------------------------------------------------END


static function H7GUISoundPlayer GetInstance()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetGUISoundPlayer();
}


