/*=============================================================================
* H7Cartographer
* =============================================================================
*  Reveals a type of land
* =============================================================================
*  Copyright 2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Cartographer extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var protected savegame bool mIsHidden;
/** Cost to reveal */
var(Properties) protected array<H7ResourceQuantity> mCosts<DisplayName=Cost>;
var(Properties) protected ECartographerType         mType<DisplayName=Type>;

var protected savegame array<EPlayerNumber> mRevealedPlayers;

native function bool IsHiddenX();

function bool HasVisited( EPlayerNumber playerNumber )
{
	return mRevealedPlayers.Find( playerNumber ) != INDEX_NONE;
}

function OnVisit( out H7AdventureHero hero )
{
	local string popUpMessage;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }

	if( HasVisited( hero.GetPlayer().GetPlayerNumber() ) )
	{
		AlreadyVisited(hero);

		if(mOnVisitSound!=None)
		{
			class'H7SoundController'.static.PlayGlobalAkEvent(mOnVisitSound,true);
		}

		return;
	}

	if( !hero.IsControlledByAI() )
	{
		if( hero.GetPlayer().IsControlledByLocalPlayer() )
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("PU_CARTOGRAPHER","H7PopUp");
			popUpMessage = Repl(popUpMessage, "%price", "" );
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( 
				popUpMessage, class'H7Loca'.static.LocalizeSave("PU_REVEAL","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), ConfirmRevealMap, None, mCosts, true);
		}
	}
	else
	{
		ConfirmRevealMap();
	}
	super.OnVisit(hero);
}

function AlreadyVisited(H7AdventureHero hero)
{
	local Vector HeroMsgOffset;

	HeroMsgOffset = Vect(0,0,600);
	class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT") , MakeColor(255,255,0,255));
}

function ConfirmRevealMap()
{
	mVisitingArmy.GetPlayer().GetResourceSet().SpendResources( mCosts, true, true );
	RevealMap();

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}
native function RevealMap();

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local string visited;
	local H7ResourceQuantity cost;
	local array<H7ResourceQuantity> costs;

    if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none )
	{
		if(	HasVisited( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetPlayerNumber() ) )
			visited = GetVisitString(true);
		else
			visited = GetVisitString(false);
	}

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_CARTOGRAPHER","H7Cartographer");
	costs = mCosts;
	costs.Sort( class'H7Resource'.static.CostResourceCompareGUI );
	foreach costs(cost)
	{
		data.Description = data.Description $ "\n" $ class'H7GUIGeneralProperties'.static.GetIconHTMLByIcon(cost.Type.GetIcon()) @ String(cost.Quantity) @ cost.Type.GetName();
	}
	data.Description = data.Description $ "</font>";
	data.Visited = "<font size='22'>" $ visited $ "</font>";
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

