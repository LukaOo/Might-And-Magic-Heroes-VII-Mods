//=============================================================================
// H7Ship
//=============================================================================
// Boat.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Ship extends H7VisitableSite
	implements(H7DynGridObjInterface, H7ITooltipable, H7IHideable)
	native
	placeable
	savegame;

const SHIP_OFFSET_ROT = Rot( 0, -32768, 0 );

var(Visuals) StaticMeshComponent	mSailMesh1<DisplayName=Sail Mesh 1>;
var(Visuals) StaticMeshComponent	mSailMesh2<DisplayName=Sail Mesh 2>;
//var(Developer) protected Texture2D	mMinimapIcon<DisplayName=Icon Minimap>;
var protected savegame H7Player				mPlayer;
var protected savegame EPlayerNumber		mPlayerNumber;
//The army that is currently on the ship
var protected savegame H7AdventureArmy		mArmy; 

var protected savegame bool					mIsHidden;

var protected savegame Vector mSaveLocation;
var protected savegame Rotator mSaveRotation;

native function H7AdventureMapCell GetEntranceCell();
function SetArmy(H7AdventureArmy army) { mArmy = army; }
function H7AdventureArmy GetArmy() { return mArmy; }
function H7Player GetPlayer() { return mPlayer; }
function EPlayerNumber GetPlayerNumber() { return mPlayerNumber; }
function String   GetFlashMinimapPath() { return "img://" $ Pathname( mMinimapIcon ); }
function bool     IsH7Hidden() { return mIsHidden; }

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit( hero );
}

function SetPlayer(H7Player player)
{
	mPlayer = player;
	mPlayerNumber = player.GetPlayerNumber();
}

function Color GetColor()
{
	if(GetPlayer() != None)
	{
		return GetPlayer().GetColor();
	}
	return class'H7AdventureController'.static.GetInstance().GetNeutralPlayer().GetColor();
}

event InitAdventureObject()
{
	class'H7ReplicationInfo'.static.PrintLogMessage("H7Ship.Init"@self, 0);;
	super.InitAdventureObject();

	class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ).RegisterShip( self );
}

function ToggleVisibility()
{
	if(mIsHidden)
	{
		Reveal();
	}
	else
	{
		Hide();
	}
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function SetVisibility(bool show)
{
	if(show)
	{
		Reveal();
	}
	else
	{
		Hide();
	}
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	if( mArmy == none)
	{
		data.type = TT_TYPE_STRING;
		data.Title = GetName(); // `Localize("H7AdvMapObjectToolTip", "TT_SHIP_HEAD", "MMH7Game");
		data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_SHIP_DESC","H7AdvMapObjectToolTip") $ "</font>";
		data.Visited = "<font size='22' color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_AVAILABLE","H7AdvMapObjectToolTip") $ "</font>";
	}
	else if( mArmy.GetHero().IsHero() )
	{
		data.type = TT_TYPE_HERO_ARMY;
		data.addRightMouseIcon = true;
	}
	else
	{
		data.type = TT_TYPE_CRITTER_ARMY;
		data.addRightMouseIcon = true;
	}
	return data;
}

event PostSerialize()
{
	// Make sure ship is not registered at any of (possible) location
	class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( mOriginalLocation ).UnregisterShip( self );
	class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ).UnregisterShip( self );

	SetRotation( mSavedRotation );
	SetLocation( mSavedLocation );
	class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( mSavedLocation ).RegisterShip( self );

	ForceUpdateComponents(false, false);

	if(mArmy != none && !mIsHidden)
	{
		mArmy.GetFlag().SetHidden(false);
	}

	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );

	super.SetVisibility(!mIsHidden);
	mSailMesh1.SetHidden(mIsHidden);
	mSailMesh2.SetHidden(mIsHidden);
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );

	super.SetVisibility(!mIsHidden);
	mSailMesh1.SetHidden(mIsHidden);
	mSailMesh2.SetHidden(mIsHidden);
}

native function bool IsHiddenX();

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


