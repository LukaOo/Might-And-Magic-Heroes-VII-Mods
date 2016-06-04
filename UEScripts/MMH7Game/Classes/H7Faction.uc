//=============================================================================
// H7Faction
//=============================================================================
// The class is the data model containing all the properties that define a
// faction editable via archetypes. This is the place to define the terrain
// modifiers for the faction and other data.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Faction extends Object
	dependson(H7StructsAndEnumsNative)
	implements(H7IAliasable)
	perobjectconfig
	hidecategories(Object)
	native
	savegame;

// faction name
var(Faction) protected localized String	        mFactionName<DisplayName="Name">;

// faction color
var(Faction) protected localized Color	        mColor<DisplayName="Official Color">;

// list of allied factions
var(Faction) protected array<H7Faction>         mAlliedFactions<DisplayName="Allied Factions">;
// list of enemy factions
var(Faction) protected array<H7faction>         mEnemyFactions<DisplayName="Enemy Factions">;

//default name for captured Forts
var(Faction) protected localized String	        mFactionFortName<DisplayName="Default Fort Name">;
var(Faction) protected localized String	        mFactionArmyName<DisplayName="Numbered Army Name (Duels)">;

// small visuals
var(Visuals) protected Texture2D			    mFactionIcon<DisplayName="Colored Icon (GUI)">;
var(Visuals) protected Texture2D			    mFactionSymbol<DisplayName="Sepia Symbol (Flags & GUI)">;
var(Visuals) protected Texture2D			    mFactionBanner<DisplayName="Banner BG (Flags & GUI)">;
var(Visuals) protected Texture2D			    mFactionBannerStripes<DisplayName="Banner BG Stripes (Flags & GUI)">;
var(Visuals) protected Texture2D			    mFactionMarker<DisplayName="Map Marker Icon (GUI)">;
var(Visuals) protected String                   mTownBuildTreeLayout<DisplayName="GUI Build Tree Layout">;

// dynamic visuals
var(Visuals) dynload protected Texture2D        mFactionBannerIcon<DisplayName="Banner Icon">;
var(Visuals) dynload protected Texture2D        mStainedGlassGrid<DisplayName="Stained Glass Grid">;
var(Visuals) dynload protected Texture2D        mStainedGlassHighlight<DisplayName="Stained Glass Highlight">;
var(Visuals) dynload protected Texture2D        mStainedGlassBase<DisplayName="Stained Glass Base">;
var(Visuals) dynload protected Texture2D        mCouncilLeftStainedGlassGrid<DisplayName="Left Council Stained Glass Grid">;
var(Visuals) dynload protected Texture2D        mCouncilLeftStainedGlassHighlight<DisplayName="Left Council Stained Glass Highlight">;
var(Visuals) dynload protected Texture2D        mCouncilLeftStainedGlassBase<DisplayName="Left Council Stained Glass Base">;
var(Visuals) dynload protected Texture2D        mCouncilRightStainedGlassGrid<DisplayName="Right Council Stained Glass Grid">;
var(Visuals) dynload protected Texture2D        mCouncilRightStainedGlassHighlight<DisplayName="Right Council Stained Glass Highlight">;
var(Visuals) dynload protected Texture2D        mCouncilRightStainedGlassBase<DisplayName="Right Council Stained Glass Base">;
var(Visuals) dynload protected Texture2D        mDecalOuter<DisplayName="Decal Outer">;
var(Visuals) dynload protected Texture2D        mDecalInner<DisplayName="Decal Inner">;
var(Visuals) dynload protected Texture2D        mDecalOuterUPLAY<DisplayName="Decal Outer UPLAY">;
var(Visuals) dynload protected Texture2D        mDecalInnerUPLAY<DisplayName="Decal Inner UPLAY">;

var(Visuals) dynload protected Texture2D        mPuzzle1<DisplayName="Puzzle Piece 1">;
var(Visuals) dynload protected Texture2D        mPuzzle2<DisplayName="Puzzle Piece 2">;
var(Visuals) dynload protected Texture2D        mPuzzle3<DisplayName="Puzzle Piece 3">;
var(Visuals) dynload protected Texture2D        mPuzzle4<DisplayName="Puzzle Piece 4">;
var(Visuals) dynload protected Texture2D        mPuzzle5<DisplayName="Puzzle Piece 5">;
var(Visuals) dynload protected Texture2D        mPuzzle6<DisplayName="Puzzle Piece 6">;
var(Visuals) dynload protected Texture2D        mPuzzle7<DisplayName="Puzzle Piece 7">;
var(Visuals) dynload protected Texture2D        mPuzzle8<DisplayName="Puzzle Piece 8">;

var(Visuals) protected H7HeroVisuals            mCaravanVisuals<DisplayName="Caravan Visuals">;

// the ability school the faction prefers (magic guild always have a spell of this school)
var(Abilities) protected EAbilitySchool         mPreferredAbilitySchool<DisplayName="Preferred Ability School">;
// the ability school that is forbidden for the faction (heros cannot learn spells of this school)
var(Abilities) protected EAbilitySchool         mForbiddenAbilitySchool<DisplayName="Forbidden Ability School">;

var(Warfare) protected H7EditorWarUnit          mDefaultSiegeWarUnit<DisplayName="Default Siege Unit">;
var(Warfare) protected H7EditorWarUnit          mDefaultAttackWarUnit<DisplayName="Default Attack Unit">;
var(Warfare) protected H7EditorWarUnit          mDefaultSupportWarUnit<DisplayName="Default Support Unit">;
var(Warfare) protected H7EditorWarUnit          mDefaultHybridWarUnit<DisplayName="Default Hybrid Unit">;

var(StartBuildings) dynload protected archetype H7Town mStartTown<DisplayName="Starting Town">;
var(StartBuildings) dynload protected archetype H7Fort mLevel1Fort<DisplayName="Starting Fort">;
var(StartBuildings) dynload protected archetype H7Dwelling mCoreDwelling<DisplayName="Core Dwelling">;
var(StartBuildings) dynload protected archetype H7Dwelling mEliteDwelling<DisplayName="Elite Dwelling">;
var(StartBuildings) dynload protected archetype H7Dwelling mChampionDwelling1<DisplayName="Champion Dwelling 1">;
var(StartBuildings) dynload protected archetype H7Dwelling mChampionDwelling2<DisplayName="Champion Dwelling 2">;

var(Defense) protected H7AdventureArmy mDefaultGarrisonArmyTown<DisplayName="Default Garrison Army (Town)">;
var(Defense) protected H7AdventureArmy mDefaultGarrisonArmyFort<DisplayName="Default Garrison Army (Fort)">;

/** Faction-Specific Loadscreen background 
 *  - CURRENTLY NOT USED. Only Campaign-specific loadscreen background is used */
var(LoadScreeen) dynload protected MaterialInterface mLoadScreenBackground<DisplayName="Load Screen Background">;

// for town fort outpost
function String                     GetFactionBannerIconPath()              { if( mFactionBannerIcon == none ) DynLoadObjectProperty('mFactionBannerIcon'); return "img://" $ Pathname( mFactionBannerIcon ); }
function                            DelFactionBannerIconRef()               { mFactionBannerIcon = none; }


function string GetArchetypeID()
{
	 return class'H7GameUtility'.static.IsArchetype(self)?String(self):String(ObjectArchetype);
}

function H7EditorWarUnit        GetDefaultWarUnitByType( EWarUnitClass type )
{
	switch( type )
	{
		case WCLASS_SIEGE:
			return GetDefaultSiegeWarUnit();
		case WCLASS_ATTACK:
			if( GetDefaultHybridWarUnit() != none )
			{
				return GetDefaultHybridWarUnit();
			}
			else
			{
				return GetDefaultAttackWarUnit();
			}
		case WCLASS_SUPPORT:
			if( GetDefaultHybridWarUnit() != none )
			{
				return GetDefaultHybridWarUnit();
			}
			else
			{
				return GetDefaultSupportWarUnit();
			}
		case WCLASS_HYBRID:
			return GetDefaultHybridWarUnit();
		default:
			return none;
	}
}

function H7AdventureArmy        GetDefaultGarrisonTown()               { return mDefaultGarrisonArmyTown; }
function H7AdventureArmy        GetDefaultGarrisonFort()               { return mDefaultGarrisonArmyFort; }
function H7EditorWarUnit        GetDefaultSiegeWarUnit()               { return mDefaultSiegeWarUnit; }
function H7EditorWarUnit        GetDefaultAttackWarUnit()              { return mDefaultAttackWarUnit; }
function H7EditorWarUnit        GetDefaultSupportWarUnit()             { return mDefaultSupportWarUnit; }
function H7EditorWarUnit        GetDefaultHybridWarUnit()              { return mDefaultHybridWarUnit; }


// random heroes that will be used in the Hall of Heroes
//var(Heroes) protected array<archetype H7EditorHero> mRandomArchetypeHeroes<DisplayName=Random Heroes>; // TODO delete

function String					GetName()							{ return class'H7Loca'.static.LocalizeContent(self, "mFactionName", mFactionName); }

function Color                  GetColor()                          { return mColor; }

function String					GetDefaultFortName()				{ return class'H7Loca'.static.LocalizeContent(self, "mFactionFortName", mFactionFortName); }
function String					GetNumberedArmyName(int nr)			{ return Repl(class'H7Loca'.static.LocalizeContent(self, "mFactionArmyName", mFactionArmyName),"%number",nr); }


function Texture2D				GetFactionMarkerIcon()		        { return mFactionMarker; } // marker version
function String                 GetFactionMarkerIconPath()          { return "img://" $ Pathname( mFactionMarker );}
function Texture2D				GetFactionColorIcon()		        { return mFactionIcon; } // color version
function String                 GetFactionColorIconPath()           { return "img://" $ Pathname( mFactionIcon );}
function Texture2D				GetFactionSepiaIcon()				{ return mFactionSymbol; } // sepia version
function String                 GetFactionSepiaIconPath()           { return "img://" $ Pathname( mFactionSymbol );}
function Texture2D				GetFactionBanner()					{ return mFactionBanner; }
function String                 GetFactionBannerPath()              { return "img://" $ Pathname( mFactionBanner );}
function Texture2D				GetFactionBannerStripes()   		{ return mFactionBannerStripes; }
function String                 GetFactionBannerStripesPath()       { return "img://" $ Pathname( mFactionBannerStripes );}
function String                 GetTownBuildTreeLayout()            { return mTownBuildTreeLayout; }

function array<H7Faction>       GetAlliedFactions()					{ return mAlliedFactions; }
function array<H7Faction>       GetEnemyFactions()					{ return mEnemyFactions; }

function bool					IsAlliedFaction( H7Faction faction ){ return mAlliedFactions.Find( faction ) != INDEX_NONE; }
function bool					IsEnemyFaction( H7Faction faction )	{ return mEnemyFactions.Find( faction ) != INDEX_NONE; }

function EAbilitySchool         GetPreferredAbilitySchool()         { return mPreferredAbilitySchool; }
function EAbilitySchool         GetForbiddenAbilitySchool()         { return mForbiddenAbilitySchool; }

function H7HeroVisuals          GetCaravanVisuals()                 { return mCaravanVisuals; }

function MaterialInterface      GetLoadscreenBackground()           { return mLoadScreenBackground; }

//function array<H7EditorHero>	GetRandomArchetypeHeroes()          { return mRandomArchetypeHeroes; }

// dynload functions
function String GetStainedGlassGrid()
{
	if( mStainedGlassGrid == none )
	{
		self.DynLoadObjectProperty('mStainedGlassGrid');
	}
	return "img://" $ Pathname( mStainedGlassGrid );
}
function DelStainedGlassGrid()
{
	if(!class'Engine'.static.IsEditor())
	{
		mStainedGlassGrid = none;
	}
}

function String GetStainedGlassHighlight()
{
	if( mStainedGlassHighlight == none )
	{
		self.DynLoadObjectProperty('mStainedGlassHighlight');
	}
	return "img://" $ Pathname( mStainedGlassHighlight );
}
function DelStainedGlassHighlight()
{
	if(!class'Engine'.static.IsEditor())
	{
		mStainedGlassHighlight = none;
	}
}

function String GetStainedGlassBase()
{
	if( mStainedGlassBase == none )
	{
		self.DynLoadObjectProperty('mStainedGlassBase');
	}
	return "img://" $ Pathname( mStainedGlassBase );
}
function DelStainedGlassBase()
{
	if(!class'Engine'.static.IsEditor())
	{
		mStainedGlassBase = none;
	}
}

// dynload functions
function String GetCouncilLeftStainedGlassGrid()
{
	if( mCouncilLeftStainedGlassGrid == none )
	{
		self.DynLoadObjectProperty('mCouncilLeftStainedGlassGrid');
	}
	return "img://" $ Pathname( mCouncilLeftStainedGlassGrid );
}
function DelCouncilLeftStainedGlassGrid()
{
	if(!class'Engine'.static.IsEditor())
	{
		mCouncilLeftStainedGlassGrid = none;
	}
}

function String GetCouncilLeftStainedGlassHighlight()
{
	if( mCouncilLeftStainedGlassHighlight == none )
	{
		self.DynLoadObjectProperty('mCouncilLeftStainedGlassHighlight');
	}
	return "img://" $ Pathname( mCouncilLeftStainedGlassHighlight );
}
function DelCouncilLeftStainedGlassHighlight()
{
	if(!class'Engine'.static.IsEditor())
	{
		mCouncilLeftStainedGlassHighlight = none;
	}
}

function String GetCouncilLeftStainedGlassBase()
{
	if( mCouncilLeftStainedGlassBase == none )
	{
		self.DynLoadObjectProperty('mCouncilLeftStainedGlassBase');
	}
	return "img://" $ Pathname( mCouncilLeftStainedGlassBase );
}
function DelCouncilLeftStainedGlassBase()
{
	if(!class'Engine'.static.IsEditor())
	{
		mCouncilLeftStainedGlassBase = none;
	}
}

// dynload functions
function String GetCouncilRightStainedGlassGrid()
{
	if( mCouncilRightStainedGlassGrid == none )
	{
		self.DynLoadObjectProperty('mCouncilRightStainedGlassGrid');
	}
	return "img://" $ Pathname( mCouncilRightStainedGlassGrid );
}
function DelCouncilRightStainedGlassGrid()
{
	if(!class'Engine'.static.IsEditor())
	{
		mCouncilRightStainedGlassGrid = none;
	}
}

function String GetCouncilRightStainedGlassHighlight()
{
	if( mCouncilRightStainedGlassHighlight == none )
	{
		self.DynLoadObjectProperty('mCouncilRightStainedGlassHighlight');
	}
	return "img://" $ Pathname( mCouncilRightStainedGlassHighlight );
}
function DelCouncilRightStainedGlassHighlight()
{
	if(!class'Engine'.static.IsEditor())
	{
		mCouncilRightStainedGlassHighlight = none;
	}
}

function String GetCouncilRightStainedGlassBase()
{
	if( mCouncilRightStainedGlassBase == none )
	{
		self.DynLoadObjectProperty('mCouncilRightStainedGlassBase');
	}
	return "img://" $ Pathname( mCouncilRightStainedGlassBase );
}
function DelCouncilRightStainedGlassBase()
{
	if(!class'Engine'.static.IsEditor())
	{
		mCouncilRightStainedGlassBase = none;
	}
}

function string GetPuzzle1() { if(mPuzzle1==none) self.DynLoadObjectProperty('mPuzzle1'); return "img://" $ Pathname(mPuzzle1); }
function string GetPuzzle2() { if(mPuzzle2==none) self.DynLoadObjectProperty('mPuzzle2'); return "img://" $ Pathname(mPuzzle2); }
function string GetPuzzle3() { if(mPuzzle3==none) self.DynLoadObjectProperty('mPuzzle3'); return "img://" $ Pathname(mPuzzle3); }
function string GetPuzzle4() { if(mPuzzle4==none) self.DynLoadObjectProperty('mPuzzle4'); return "img://" $ Pathname(mPuzzle4); }
function string GetPuzzle5() { if(mPuzzle5==none) self.DynLoadObjectProperty('mPuzzle5'); return "img://" $ Pathname(mPuzzle5); }
function string GetPuzzle6() { if(mPuzzle6==none) self.DynLoadObjectProperty('mPuzzle6'); return "img://" $ Pathname(mPuzzle6); }
function string GetPuzzle7() { if(mPuzzle7==none) self.DynLoadObjectProperty('mPuzzle7'); return "img://" $ Pathname(mPuzzle7); }
function string GetPuzzle8() { if(mPuzzle8==none) self.DynLoadObjectProperty('mPuzzle8'); return "img://" $ Pathname(mPuzzle8); }

function DelPuzzle1() { if(!class'Engine'.static.IsEditor()) mPuzzle1 = none; }
function DelPuzzle2() { if(!class'Engine'.static.IsEditor()) mPuzzle2 = none; }
function DelPuzzle3() { if(!class'Engine'.static.IsEditor()) mPuzzle3 = none; }
function DelPuzzle4() { if(!class'Engine'.static.IsEditor()) mPuzzle4 = none; }
function DelPuzzle5() { if(!class'Engine'.static.IsEditor()) mPuzzle5 = none; }
function DelPuzzle6() { if(!class'Engine'.static.IsEditor()) mPuzzle6 = none; }
function DelPuzzle7() { if(!class'Engine'.static.IsEditor()) mPuzzle7 = none; }
function DelPuzzle8() { if(!class'Engine'.static.IsEditor()) mPuzzle8 = none; }

function Texture2D GetDecalOuterTexture()
{
	if( class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().GetStateReward_HD() && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().CanRewardBeUsed() && 
		( class'H7AdventureController'.static.GetInstance() == none || class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMapType() != CAMPAIGN ) )
	{
		return GetDecalOuterTextureUPLAY();
	}
	if( mDecalOuter == none )
	{
		self.DynLoadObjectProperty('mDecalOuter');
	}
	return mDecalOuter;
}
function DelDecalOuterTexture()
{
	if(!class'Engine'.static.IsEditor())
	{
		mDecalOuter = none;
	}
}

function Texture2D GetDecalInnerTexture()
{
	if( class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().GetStateReward_HD() && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().CanRewardBeUsed() )
	{
		return GetDecalInnerTextureUPLAY();
	}
	if( mDecalInner == none )
	{
		self.DynLoadObjectProperty('mDecalInner');
	}
	return mDecalInner;
}
function DelDecalInnerTexture()
{
	if(!class'Engine'.static.IsEditor())
	{
		mDecalInner = none;
	}
}

function Texture2D GetDecalOuterTextureUPLAY()
{
	if( mDecalOuterUPLAY == none )
	{
		self.DynLoadObjectProperty('mDecalOuterUPLAY');
	}
	if( mDecalInnerUPLAY == none )
	{
		self.DynLoadObjectProperty('mDecalOuter');
		return mDecalOuter;
	}
	return mDecalOuterUPLAY;
}
function DelDecalOuterTextureUPLAY()
{
	if(!class'Engine'.static.IsEditor())
	{
		mDecalOuterUPLAY = none;
	}
}

function Texture2D GetDecalInnerTextureUPLAY()
{
	if( mDecalInnerUPLAY == none )
	{
		self.DynLoadObjectProperty('mDecalInnerUPLAY');
	}
	if( mDecalInnerUPLAY == none )
	{
		self.DynLoadObjectProperty('mDecalInner');
		return mDecalInner;
	}
	return mDecalInnerUPLAY;
}
function DelDecalInnerTextureUPLAY()
{
	if(!class'Engine'.static.IsEditor())
	{
		mDecalInnerUPLAY = none;
	}
}

function H7Town GetStartTown()
{
	if( mStartTown == none )
	{
		self.DynLoadObjectProperty('mStartTown');
	}
	return mStartTown;
}
function DelStartTown()
{
	if(!class'Engine'.static.IsEditor())
	{
		mStartTown = none;
	}
}

function H7Fort GetStartFort()
{
	if( mLevel1Fort == none )
	{
		self.DynLoadObjectProperty('mLevel1Fort');
	}
	return mLevel1Fort;
}
function DelStartFort()
{
	if(!class'Engine'.static.IsEditor())
	{
		mLevel1Fort = none;
	}
}

function H7Dwelling GetStartDwelling(EH7RandomDwellingType type, EH7ChampionDwellingChoice championChoice)
{
	if(type == E_H7_RDT_CORE)
	{
		if( mCoreDwelling == none )
		{
			self.DynLoadObjectProperty('mCoreDwelling');
		}
		return mCoreDwelling;
	}
	else if(type == E_H7_RDT_ELITE)
	{
		if( mEliteDwelling == none )
		{
			self.DynLoadObjectProperty('mEliteDwelling');
		}
		return mEliteDwelling;
	}
	else if(type == E_H7_RDT_CHAMPION)
	{
		if(championChoice == E_H7_CDC_1)
		{
			if( mChampionDwelling1 == none )
			{
				self.DynLoadObjectProperty('mChampionDwelling1');
			}
			return mChampionDwelling1;
		}
		else if(championChoice == E_H7_CDC_2)
		{
			if( mChampionDwelling2 == none )
			{
				self.DynLoadObjectProperty('mChampionDwelling2');
			}
		}
		return mChampionDwelling2;
	}
	return none;
}
function DelStartDwelling(EH7RandomDwellingType type, EH7ChampionDwellingChoice championChoice)
{
	if(!class'Engine'.static.IsEditor())
	{
		if(type == E_H7_RDT_CORE)
		{
			mCoreDwelling = none;
		}
		else if(type == E_H7_RDT_ELITE)
		{
			mEliteDwelling = none;
		}
		else if(type == E_H7_RDT_CHAMPION)
		{
			if(championChoice == E_H7_CDC_1)
			{
				mChampionDwelling1 = none;
			}
			else if(championChoice == E_H7_CDC_2)
			{
				mChampionDwelling2 = none;
			}
		}
	}
}

function SetTownBuildTreeLayout(string layout)   { mTownBuildTreeLayout = layout; }

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

