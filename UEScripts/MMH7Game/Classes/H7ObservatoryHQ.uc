/*=============================================================================
* H7ObservatoryHQ
* =============================================================================
*  Reveals an area around linked observatories
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7ObservatoryHQ extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var protected savegame bool mIsHidden;
var(Properties) protected array<H7Observatory> mLinkedObservatories<DisplayName="Linked Observatories">;
/** Cost to reveal linked observatories */
var(Properties) protected array<H7ResourceQuantity> mCosts<DisplayName="Cost">;
var(Developer) protected float mRevealTimer<DisplayName="Delay for showing explored tiles">;
var protected savegame array <EPlayerNumber> mVisitedPlayers;

var protected savegame int      mRevealedForPlayer[EPlayerNumber.PN_PLAYER_NONE];

//Fallback if visiting Army moves away before the areas are revealed
var protected H7AdventureHero   mLastHeroVisited;

native function bool IsHiddenX();

function H7AdventureHero GetLastHeroVisited(){ return mLastHeroVisited; }

function bool IsRevealed( EPlayerNumber playerNumber )
{
	if( mRevealedForPlayer[playerNumber] == 1 )
	{
		return true;
	}
	return false;
}

function bool CanAffordIt( H7Player player )
{
	if(player!=None)
	{
		if( player.GetResourceSet().CanSpendResources( mCosts ) == true )
		{
			return true;
		}
	}
	return false;
}

event InitAdventureObject()
{
	local H7Observatory observatory;
	foreach mLinkedObservatories( observatory )
	{
		observatory.SetHQ( self );
	}
	super.InitAdventureObject();
}

function OnVisit( out H7AdventureHero hero )
{
	local string popUpMessage;
	local Vector HeroMsgOffset;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	HeroMsgOffset = Vect(0,0,600);

	super.OnVisit(hero); // moved call to top as it should always be the first thing

	//Fallback Reference, for the case the Hero moves away before the areas are revealed
	if( hero != none )
	{
		mLastHeroVisited = hero;
	}

	// dont show the pop up for the other players
	if( !hero.GetPlayer().IsControlledByLocalPlayer() && !hero.GetPlayer().IsControlledByAI() )
	{
		return;
	}

	if(CheckVisited())
	{
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT") , MakeColor(255,255,0,255));
		return;
	}

	if( hero.GetPlayer().GetResourceSet().CanSpendResources( mCosts ) )
	{
		if( hero.GetPlayer().IsControlledByAI() == false )
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("PU_OBSERVATORY_HQ","H7PopUp");
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_REVEAL","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), ConfirmReveal, None, mCosts );
		}
		else
		{
			ConfirmReveal();
		}
	}
	else
	{
		if( hero.GetPlayer().IsControlledByAI() == false )
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("PU_OBSERVATORY_HQ","H7PopUp");
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_REVEAL","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), none, none, mCosts );
		}
	}
			
}

function ConfirmReveal()
{
	local EPlayerNumber plyNum;
	local H7Observatory observatory;

	mVisitingArmy.GetPlayer().GetResourceSet().SpendResources( mCosts, true, true );
	plyNum=mVisitingArmy.GetPlayer().GetPlayerNumber();
	mVisitedPlayers.AddItem(plyNum);

	mRevealedForPlayer[plyNum]=1;

	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() || mVisitingArmy.GetPlayer().IsControlledByAI() )
	{
		foreach mLinkedObservatories( observatory )
		{
			observatory.RevealFog( plyNum );
		}
	}
	else
	{
		SetCameraFocusTimersForReveal();
	}
}

function bool CheckVisited()
{
	local EPlayerNumber plyNum, currentNum;

	plyNum = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetPlayerNumber();

	foreach mVisitedPlayers (currentNum) 
	{
		if(currentNum == plyNum)
		{
			return true;
		}
	}

	return false;
}

function SetCameraFocusTimersForReveal()
{
	local H7Observatory observatory;
	local float timerTime;

	foreach mLinkedObservatories( observatory )
	{
		timerTime += mRevealTimer;
		
		observatory.SetFocusAndRevealTimer( timerTime );
	}
	timerTime += mRevealTimer;

	SetTimer( timerTime, false, 'FocusCameraHere' );
}

function FocusCameraHere()
{
	local H7AdventureController advCntl;
	advCntl = class'H7AdventureController'.static.GetInstance();
	if( advCntl.GetCurrentPlayer() == advCntl.GetLocalPlayer() && !advCntl.GetCurrentPlayer().IsControlledByAI() )
	{
		class'H7CameraActionController'.static.GetInstance().CancelCurrentCameraAction();
		class'H7Camera'.static.GetInstance().SetCurrentVRP( Location );
		class'H7Camera'.static.GetInstance().SetTargetVRP( Location );
	}
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local string visited;
	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ Repl(class'H7Loca'.static.LocalizeSave("TT_OBSERVATORY_HQ","H7ObservatoryHQ"),"%building",GetName())$"</font>";
	
	if( CheckVisited() )
	{
		visited = GetVisitString(true);
	}
	else
	{
		visited = GetVisitString(false);
	}

	data.Visited = visited;

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

