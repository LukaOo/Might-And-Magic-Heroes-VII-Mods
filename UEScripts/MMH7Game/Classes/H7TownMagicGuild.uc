	/*=============================================================================
* H7TownMagicGuild
* =============================================================================
*  Class for the in-town Magic Guild - contains and teaches spells.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownMagicGuild extends H7TownBuilding
	savegame
	native;

const MaxSpellsRankUnskilled = 7;
const MaxSpellsRankNovice = 6;
const MaxSpellsRankExpert = 4;
const MaxSpellsRankMaster = 2;

// all available spells in the game
var() protected ESkillRank mRank;

// the determined spells
var protected array<H7HeroAbility> mSpells; // contains instances because tooltip needs real effects inside
var protected array<H7HeroAbility> mRemovedSpellBuffer;
var protected array<H7HeroAbility> mPossibleSpells;
var protected savegame array<string> mSpellsRefs; // contains instances because tooltip needs real effects inside
var protected savegame bool mSpellsSet;
var protected savegame int mMaxSpellCount;
// Magic specialisation choosen by the player
//var protected EAbilitySchool mGuildSpecialisation;
var protected savegame array<EAbilitySchool> mMagicGuildSpecPossibilities;
var protected savegame H7Faction mFaction;
var protected savegame bool mSeenByPlayer;
var protected savegame bool mSeenLibrarySpells;

var protected transient bool mWasPostSerialized;

function array<H7HeroAbility> GetSpells() { return mSpells; }
function int GetMaxSpellCount() { return mMaxSpellCount; }
function ESkillRank GetRank() { return mRank; }
function bool GetSpellSetStatus(){ return mSpellsSet; }
function SetSeenByPlayer(bool val) {mSeenByPlayer = val;}
function bool WasSeenByPlayer() {return mSeenByPlayer;}
function SetSeenLibrarySpells(bool val) {mSeenLibrarySpells = val;}
function bool HasSeenLibrarySpells() {return mSeenLibrarySpells;}

function SetFaction(H7Faction faction) { mFaction = faction; }

function SetMageGuildSpecialisation(EAbilitySchool electedSchool, H7Town town)
{
	local H7Town dependingTown;
	dependingTown = town;

	if(!dependingTown.GetMageGuildSpecialisationStatus())
	{
		dependingTown.SetSpecialisation(electedSchool);
		dependingTown.SetMageGuildSpecialisationStatus( true );
	}
}

function SelectRandomGuildSpecialisation(H7Town town)
{
	local int rnd;
	local EAbilitySchool spec;

	rnd = 1 + class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( 7 );
	spec = EAbilitySchool(rnd);
	SetRandomGuildSpecialisation(spec, town);
}

function SetRandomGuildSpecialisation(EAbilitySchool school, H7Town town)
{
	local EAbilitySchool spec;

	spec = school;
	
	if (spec != mFaction.GetForbiddenAbilitySchool() && spec != mFaction.GetPreferredAbilitySchool())
	{ 
		SetMageGuildSpecialisation(spec, town);
	}
	else
	{ 
		SelectRandomGuildSpecialisation(town); 
	}
}

native function InitSpells(array<H7HeroAbility> predefinedSpells, H7Town town);
native private function AddSpell(H7HeroAbility spell);
native private function InitMaxSpellCount();
event PostSerialize()
{
	local string spellRef;
	local H7HeroAbility spell, spellTemplate;
	local int MaxSpellCount;

	MaxSpellCount = MaxSpellsRankUnskilled + MaxSpellsRankNovice + MaxSpellsRankExpert + MaxSpellsRankMaster;

	if(mSpellsRefs.Length > MaxSpellCount) // oh boy, here we go! (there is more spells then max count allows! cut it!)
	{
		mSpellsRefs.Length = MaxSpellCount;
	}

	foreach mSpellsRefs( spellRef )
	{
		spellTemplate = H7HeroAbility( DynamicLoadObject( spellRef, class'H7HeroAbility') );
		spell = new class'H7HeroAbility'( spellTemplate );
	
		mSpells.AddItem( spell );
	}

	mSpellsRefs.Length = 0;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

