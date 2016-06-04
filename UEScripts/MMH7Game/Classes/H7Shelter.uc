/*=============================================================================
* H7Shelter
* =============================================================================
*  Reveals an area around the visiting hero.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Shelter extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var protected savegame bool     mIsHidden;

var protected savegame H7AdventureArmy mShelteredArmy;

native function bool IsHiddenX();

event InitAdventureObject()
{
	super.InitAdventureObject();
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit(hero);

	if( hero==None || (!hero.GetPlayer().IsControlledByLocalPlayer() && !hero.GetPlayer().IsControlledByAI()) )
	{
		return;
	}

	if(mShelteredArmy==None)
	{
		if( !hero.GetPlayer().IsControlledByAI() )
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("PU_ENTER_SHELTER","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_YES","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_NO","H7PopUp"), EnterShelter, none );
		}
		else
		{
			EnterShelter();
		}
	}
	else
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ERROR,hero.Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_OCCUPIED","H7FCT"),MakeColor(255,255,0,255));
	}
}

function bool IsUnoccupied()
{
	if(mShelteredArmy!=None) return false;
	return true;
}

function EnterShelter()
{
	local H7InstantCommandEnterLeaveShelter command;

	command = new class'H7InstantCommandEnterLeaveShelter';
	command.Init( self, mVisitingArmy.GetHero(), true );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function ExpelArmy()
{
	local H7InstantCommandEnterLeaveShelter command;

	command = new class'H7InstantCommandEnterLeaveShelter';
	command.Init( self, mShelteredArmy.GetHero(), false );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function SetShelteredArmy(H7AdventureArmy army)
{
	mShelteredArmy = army;
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local string occupied;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();

	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_SHELTER","H7Shelter") ;

	if( mShelteredArmy != none )
	{
		occupied = "\n <font color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_OCCUPIED","H7Shelter") $ "</font>" @  "<img width='#TT_BODY#' height='#TT_BODY#' src='" $  "img://" $ PathName( mShelteredArmy.GetHero().GetIcon() ) $ "'>";
	}
	else
	{
		occupied = "\n <font color='#00ff00'>" $ class'H7Loca'.static.LocalizeSave("TT_UNOCCUPIED","H7Shelter") $ "</font>";
	}

	data.Description = data.Description;
	data.Visited = occupied;
	return data;
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

