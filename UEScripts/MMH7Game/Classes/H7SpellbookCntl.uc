//=============================================================================
// H7SpellbookCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SpellbookCntl extends H7FlashMovieBlockPopupCntl;

var protected H7GFxSpellbook mSpellbook;
var protected H7GFxQuickBar mQuickBar;

var protected H7EditorHero mCurrentHero;

var protected bool mHasSpellOnCursor;
var protected bool mFilterIconsSet;

function H7GFxUIContainer GetPopup() { return mSpellbook;}
function H7GFxSpellbook GetSpellbook() { return mSpellbook;}
function H7GFxQuickBar GetQuickBar() { return mQuickBar;}
function bool HasSpellOnCursor() { return mHasSpellOnCursor;}

static function H7SpellbookCntl GetInstance()
{
	if(class'H7PlayerController'.static.GetPlayerController().GetHud() == none) { ScriptTrace(); }
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl(); 
}

function bool Initialize()
{
	;
	// Start playing the movie
    Super.Start();
	// Initialize all objects in the movie
    AdvanceDebug(0);

	mSpellbook = H7GFxSpellbook(mRootMC.GetObject("aSpellbook", class'H7GFxSpellbook'));
	mSpellbook.SetVisibleSave(false);

	mQuickBar = H7GFxQuickBar(mRootMC.GetObject("aQuickBar", class'H7GFxQuickBar'));
	mQuickBar.SetVisibleSave(false);

	mHasSpellOnCursor = false;

	Super.Initialize();
	
	return true;
}

function bool CanBeStopped()
{
	return false; // sadly must always run, because it's a "hud" in repect that the quickbar has to be always accessable
}

function SetData(H7EditorHero hero)
{
	if(hero == none) return;
	if(CanOpenPopup())
	{
		OpenPopup();
		if(!mFilterIconsSet)
		{
			mSpellbook.SetFilterIcons(mPlayerController.GetHud().GetSchoolIcons());
			mSpellbook.SetBGs(mPlayerController.GetHud().GetSchoolIcons());
			mSpellbook.SetTitleIcons(mPlayerController.GetHud().GetSchoolIcons());
			mSpellbook.SetSpellFrames(mPlayerController.GetHud().GetSchoolIcons());
			mFilterIconsSet = true;
		}
	
		mCurrentHero = hero;
		mSpellbook.SetData( hero, class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() );
		mQuickBar.SetSpellbookOpen(true);
	}
}

function SetHero(H7EditorHero hero)
{
	mCurrentHero = hero;
}

function HeroClick(int id)
{
	local H7AdventureHero hero;

	mSpellbook.Reset();
	hero = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(id).GetHero();
	SetData( hero );
}

/*
function SetActive(bool active) // TODO who calls this, why, why is it only deactivating
{
	if(active)return;
	ClosePopup();
}
*/

function SpellClicked(int spellID,optional bool fromQuickBar)
{
	local H7AdventureController adventureController;
	local H7HeroAbility spell;
	local string message;

	;
	;
	
	spell = H7HeroAbility(mCurrentHero.GetAbilityManager().GetAbilityByID(spellID));

	;
 
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLICK_SELECT_SPELL");

	
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		// we are on the combatmap
		// don't do anything if:
		// - hero is already casting
		// - hero's trying to cast an adventure spell (could happen)
		// - spell can't cast (for whatever reasons)
		if(mCurrentHero.IsCasting() || !spell.IsCombatAbility() || !spell.CanCast() )// || !class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsARemainingUnit( mCurrentHero ) )
		{
			;
			;
			message = class'H7Loca'.static.LocalizeSave("MSG_CANNOT_CAST","H7Message");
			message = Repl(message, "%ability", spell.GetName());
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage( message ,MD_SIDE_BAR);
			return;
		}

		// switch control to hero (CanCast already checks if the combat hero can still act or not)
		class'H7CombatController'.static.GetInstance().SetActiveUnitHero();

		mCurrentHero.PrepareAbility( spell );
		if( spell.GetTargetType() == NO_TARGET )
		{
			// close on instant execute
			ClosePopup();
			if(!class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() || class'H7AdventureController'.static.GetInstance().CanQueueCommand())
			{
				class'H7CombatController'.static.GetInstance().GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( mCurrentHero, UC_ABILITY, ACTION_ABILITY, spell ) );
			}
		}
		class'H7CombatController'.static.GetInstance().RefreshAllUnits();

		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectSpellbookButton();
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectAttackButton(false);
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetCreatureAbilityButtonPanel().SelectAbilityButton(-1);

	}
	else
	{
		// we are on the adventuremap
		adventureController = class'H7AdventureController'.static.GetInstance();
		if(adventureController.GetSelectedArmy().GetHero().IsCasting() || spell.IsCombatAbility() || !spell.CanCast())
		{
			;
			;
			;
			return;
		}
		adventureController.SetActiveUnitCommand_PrepareAbility( mCurrentHero.GetAbilityManager().GetAbilityByID(spellID) );
	}
	
	ClosePopup();

	if( mCurrentHero.GetAbilityManager().GetAbilityByID(spellID).GetTargetType() == NO_TARGET )
	{
		H7HeroAbility(mCurrentHero.GetPreparedAbility()).DoSpellFinishUpdates();
		return;
	}
	
	mQuickBar.SelectSpell( spellID );
	mHasSpellOnCursor = true;
	AddSpellIconToCursor( mCurrentHero.GetAbilityManager().GetAbilityByID(spellID).GetName() , spellID );
	
}

function AddSpellIconToCursor(string spellName, optional int spellID)
{
	local H7BaseAbility spell;

	;

	spell = mCurrentHero.GetAbilityManager().GetAbilityByID(spellID);
	if(spell == none) return;
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatController'.static.GetInstance().GetCursor().UpdateCombatCursorWithSpell(spell);
	}
	else
	{
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithSpell(spell);
	}

	if( mCurrentHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ADD_SPELL_ICON");
	}
	//class
	//cursorItemID = itemID;
}

function RemoveSpellFromCursor()
{
	//`log_gui("RemoveSpellFromCursor");
	
	mHasSpellOnCursor = false;
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatController'.static.GetInstance().GetCursor().UpdateCombatCursorWithSpell();
	}
	else
	{
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithSpell();
	}
}

// called from Flash
function Closed()
{
	;
	ClosePopup();
}

// called from UC by hotkey
// also when clicking spells
// also when opening other popups
function ClosePopup()
{
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		class'H7PlayerController'.static.GetPlayerController().GetCombatMapHud().GetCombatHudCntl().GetInitiativeList().SelectSpellbookButton(false);
	}

	mQuickBar.SetSpellbookOpen(false);
	mSpellbook.Reset();
	super.ClosePopup();
}

// Quickbar
function SaveQuickBar(array<int> spellIDs)
{
	local int spellID,i;
	local array<H7HeroAbility> spells,quickbar;
	local H7HeroAbility spell;
	local bool spellFound;

	i = 0;
	mCurrentHero.GetSpells(spells);
	;
	
	foreach spellIDs(spellID)
	{
		;
		if(spellID > 0)
		{
			foreach spells(spell)
			{
				if(spell.GetID() == spellID)
				{
					quickbar.AddItem(spell);
					spellFound = true;
				}
			}
			if(!spellFound)
			{
				;
			}
		}
		else
		{
			quickbar.Insert(i,1);
		}
		i++;
	}

	mCurrentHero.SetQuickBarSpells( quickbar, class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() );
}

