/*=============================================================================
* H7Observatory
* =============================================================================
*  Reveals an area around the visiting hero.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Observatory extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

/** The radius of fog of war that is lifted around the observatory */
var(Properties) protected int   mRadius<DisplayName="Revelation Radius"|ClampMin=1|ClampMax=300>;
var protected H7ObservatoryHQ   mHeadquarters;
var protected savegame bool     mIsHidden;
var protected savegame int      mRevealedForPlayer[EPlayerNumber.PN_PLAYER_NONE];

native function bool IsHiddenX();

function                    SetHQ( H7ObservatoryHQ hq )     { mHeadquarters = hq; }
function H7ObservatoryHQ    GetHQ()                         { return mHeadquarters; }

function int GetRadius() { return mRadius; }
function H7ObservatoryHQ GetHeadquarters()
{
	return mHeadquarters;
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit(hero); // moved call to top as it should always be the first thing

	if(IsRevealed(hero.GetPlayer().GetPlayerNumber()))
	{
		AlreadyVisited(hero);
	}

	if( mHeadquarters == none )
	{
		RevealFog( hero.GetPlayer().GetPlayerNumber() );
	}
	else
	{
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(
			Repl(class'H7Loca'.static.LocalizeSave("OBSERVATORY_VISIT_HQ","H7Observatory"),"%hq",mHeadquarters.GetName()),"OK"
		);
	}
}

function AlreadyVisited(H7AdventureHero hero)
{
	local Vector HeroMsgOffset;

	HeroMsgOffset = Vect(0,0,600);
	class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.GetLocation() + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_VISITED","H7FCT") , MakeColor(255,255,0,255));
}

function RevealFog( EPlayerNumber playerNumber )
{
	local array<EPlayerNumber> allies;
	local array<IntPoint> visiblePoints;
	local H7FOWController fogController;
	local H7AdventureMapGridController gridController;
	local int i;
	local H7AdventureMapCell cell;

	cell = GetEntranceCell();

	if( cell != none && playerNumber != PN_NEUTRAL_PLAYER )
	{
		gridController = cell.GetGridOwner();
		fogController = gridController.GetFOWController();
	
		if( fogController != none )
		{
			class'H7Math'.static.GetMidPointCirclePoints( visiblePoints, cell.GetCellPosition(), mRadius );

			class'H7TeamManager'.static.GetInstance().GetAllAlliesAndSpectatorNumbers( playerNumber, allies ); // share FoW with allied players
			allies.AddItem( playerNumber );

			for( i = 0; i < allies.Length; ++i )
			{
				fogController.HandleExploredTiles( allies[i], visiblePoints, false );
			}
		}
	}
	GetEntranceCell().GetGridOwner().GetFOWController().ExploreFog();
	mRevealedForPlayer[playerNumber]=1;
}

function bool IsRevealed( EPlayerNumber playerNumber )
{
	if( mRevealedForPlayer[playerNumber] == 1 )
	{
		return true;
	}
	return false;
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local String str, visited;
	local H7AdventureHero hero;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();

	data.type = TT_TYPE_STRING;
	data.Title = GetName();

	if(hero != none && IsRevealed(hero.GetPlayer().GetPlayerNumber()))
	{
		visited = "<font color='#999999'>" $ class'H7Loca'.static.LocalizeSave("TT_VISITED","H7PermanentBonusSite") $ "</font>";
	}
	
	//TT_OBSERVATORY = Reveal an area around the %building with a radius of %radius
	//TT_OBSERVATORY_WITH_HQ = You can reveal the area by visiting the %hq associated with the %building
	if( mHeadquarters != none )
	{
		str = class'H7Loca'.static.LocalizeSave("TT_OBSERVATORY_WITH_HQ","H7Observatory");
		str = Repl(str,"%hq","<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ mHeadquarters.GetName() $ "</font>");
		str = Repl(str,"%building",GetName());
		str = Repl(str,"%radius","<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ String(GetRadius()) $ "</font>");
		data.Description = "<font size='#TT_BODY#'>" $ str $ "</font>";
		data.Visited = visited;
	}
	else
	{
		str = class'H7Loca'.static.LocalizeSave("TT_OBSERVATORY","H7Observatory");
		str = Repl(str,"%building",GetName());
		str = Repl(str,"%radius","<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ String(GetRadius()) $ "</font>");
		data.Description = data.strData $ "<font size='#TT_BODY#'>" $ str $ "</font>";
		data.Visited = visited;
	}

	return data;
}

function SetFocusAndRevealTimer( float time )
{
	SetTimer( time, false, 'FocusCameraHereAndReveal' );
}

function FocusCameraHereAndReveal()
{
	local H7AdventureController advCntl;
	advCntl = class'H7AdventureController'.static.GetInstance();
	if( advCntl.GetCurrentPlayer() == advCntl.GetLocalPlayer() && !advCntl.GetCurrentPlayer().IsControlledByAI() )
	{
		class'H7CameraActionController'.static.GetInstance().CancelCurrentCameraAction();
		class'H7Camera'.static.GetInstance().SetCurrentVRP( Location );
		class'H7Camera'.static.GetInstance().SetTargetVRP( Location );
		class'H7CameraActionController'.static.GetInstance().StartAMEventAction( self, self );
	}

	if(mHeadquarters.GetVisitingArmy() == none)
	{
		RevealFog( mHeadquarters.GetLastHeroVisited().GetPlayer().GetPlayerNumber() );
	}
	else
	{
		RevealFog( mHeadquarters.GetVisitingArmy().GetPlayerNumber() );
	}
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

