/*=============================================================================
* H7NeutralSite
* =============================================================================
* Base class for adventure map objects that are unaffected by Area of Controls.
* 
* Note: Not all map objects that fall under this category extend this class.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7NeutralSite extends H7VisitableSite implements(H7IDefendable, H7INeutralable)
	dependson( H7Creature )
	native
	placeable
	savegame;

/** The garrisoned army that protects this building */
var(Defenses) protected H7AdventureArmy	mEditorArmy<DisplayName="Garrison Army">;
var(Audio) protected AkEvent                mOnVisitSound<DisplayName="OnVisit sound">;
//var(Developer) protected Texture2D			mMinimapIcon<DisplayName="Icon Minimap">;
var(Developer) protected bool				mHasMinimapIcon<DisplayName="Show Minimap Icon">;
var protected savegame H7AdventureArmy		mArmy;
var protected savegame H7AdventureArmy		mGuardingArmy;

function H7AdventureArmy GetArmy()						{ return mArmy; }
function				SetArmy( H7AdventureArmy army )	{ mArmy = army; }
function bool			GetHasMinimap()					{ return mHasMinimapIcon; }
function Texture2D		GetMinimapIcon()				{ return mMinimapIcon; }
function String			GetFlashMinimapPath()			{ return "img://" $ Pathname( mMinimapIcon ); }

// IDefendable implementation
event H7AdventureArmy GetGarrisonArmy()				    { return mArmy; }
function H7AdventureArmy GetGuardingArmy()				{ return mGuardingArmy; }
function SetGuardingArmy( H7AdventureArmy army )		{ mGuardingArmy=army; }

// H7INeutralable implementation
function bool IsNeutral() { return true; }

function SetGarrisonArmy( H7AdventureArmy army )
{
	mArmy = army;
	if(mArmy!=None)
	{
		mArmy.SetGarrisonedSite( self ); 
	}
}

function H7VisitableSite GetSite()						{ return Self; }

function RenderDebugInfo( Canvas myCanvas ) {}

function bool SpendPickupCostsOnVisit(H7AdventureHero visitingHero) { return false; }

event InitAdventureObject()
{
	super.InitAdventureObject();

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		SpawnGarrisonedArmy();
	}
}

function private SpawnGarrisonedArmy()
{
	if( mEditorArmy == none ) { return; }
	mArmy = Spawn( class'H7AdventureArmy',,,,, mEditorArmy );
	mArmy.Init( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( PN_NEUTRAL_PLAYER ),, Location );
	mArmy.SetGarrisonedSite( self );
	mArmy.HideArmy();
}

function OnVisit( out H7AdventureHero hero )
{
	super.OnVisit( hero );

	if(mOnVisitSound!=None && mVisitingArmy.GetPlayer().IsControlledByLocalPlayer())
	{
		class'H7SoundController'.static.PlayGlobalAkEvent(mOnVisitSound,true);
	}
}

function Color GetVisitedColor()
{
	local Color datColor;
	datColor.R = 153;
	datColor.G = 153;
	datColor.B = 153;
	return datColor;
}

function Color GetNotVisitedColor()
{
	local Color datColor;
	datColor.R = 0;
	datColor.G = 255;
	datColor.B = 0;
	return datColor;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

