/*=============================================================================
* H7Shipyard
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7Shipyard extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	dependson(H7ITooltipable)
	hidecategories(Defenses)
	placeable
	native
	savegame;

var(Properties) protected array<H7ResourceQuantity> mCosts<DisplayName="Ship build costs">;
var(Developer) protected archetype H7Ship mShip <DisplayName ="Ship">;
var(Developer) protected Vector2D mSpawnOffset<DisplayName="Ship spawn point offset">;

var protected editoronly transient SpriteComponent mShipSpawnSprite;

var protected H7AdventureMapCell    mShipSpawnPosition;
var protected bool                  mResourcesReady, mFreeWaterTile;
var protected savegame bool         mIsHidden;

native function bool IsHiddenX();

function Vector2D GetSpawnOffset() { return mSpawnOffset; }
function H7AdventureMapCell GetShipSpawnPosition() { return mShipSpawnPosition; }

event InitAdventureObject()
{
	super.InitAdventureObject();

	SetShipSpawnPosition();
}

function array<H7ResourceQuantity> GetCosts() { return mCosts; }

function bool CanPlaceShip()
{
	if(!mShipSpawnPosition.IsBlocked() && 
		mShipSpawnPosition.mMovementType==MOVTYPE_WATER && 
		class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation(mShipSpawnPosition.GetLocation()).GetShip()==none )
	{
		return true;
	}
	return false;
}

function bool WillBenefitFromVisit( H7AdventureHero hero )
{
	if( hero==None ) return false;
	if( hero.GetPlayer().GetResourceSet().CanSpendResources(mCosts) == false ) return false;
	if( CanPlaceShip()==false ) return false;
	return true;
}

function OnVisit( out H7AdventureHero hero )
{
	local string popUpMessage;

	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }

	super.OnVisit(hero);

	mVisitingArmy = hero.GetAdventureArmy();

	if(hero.GetPlayer().IsControlledByLocalPlayer() || (hero.GetPlayer().IsControlledByAI() && class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled()) )
	{
		if( hero.GetPlayer().GetResourceSet().CanSpendResources( mCosts ))
		{
			if(!hero.IsControlledByAI())
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("PU_BUY_SHIP","H7PopUp");
				popUpMessage = Repl(popUpMessage,"Costs: %price","");
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( 
					popUpMessage, class'H7Loca'.static.LocalizeSave("PU_BUILD","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Build, Leave, mCosts, true);
			}
			else
			{
				Build();
			}
		}
		else
		{
			if(!hero.IsControlledByAI())
			{
				popUpMessage = class'H7Loca'.static.LocalizeSave("PU_NOT_ENOUGH_RES_SHIP","H7PopUp");
				popUpMessage = Repl(popUpMessage,"Costs: %price","");
				class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( 
					popUpMessage, class'H7Loca'.static.LocalizeSave("PU_BUILD","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), Build, Leave, mCosts, true);
			}
			else
			{
				Leave();
			}
		}
	}
}

function Build()
{
	local H7InstantCommandBuildShip command;

	command = new class'H7InstantCommandBuildShip';
	command.Init( mVisitingArmy.GetHero(), self );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

// this should be called only from the H7InstantCommandBuildShip
function BuildComplete()
{
	local Vector pos;
	local H7Ship ship;

	if(mShipSpawnPosition.mMovementType!=MOVTYPE_WATER)
	{
		;
	}
	
	if(CanPlaceShip()==false)
	{
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, Location, mVisitingArmy.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_AVAILABLE_WATER_TILE","H7FCT") );
		return;
	}

	//Place Ship, Remove resources
	pos = mShipSpawnPosition.GetLocation();
	ship = Spawn(class'H7Ship',,, pos,,mShip );
	ship.InitAdventureObject();
		
	mVisitingArmy.GetPlayer().GetResourceSet().SpendResources( mCosts );
}

function Leave()
{
	mVisitingArmy = none;
}

native function Vector GetShipPos();

function SetShipSpawnPosition()
{
	local H7AdventureGridManager advGrid;

	advGrid = class'H7AdventureGridManager'.static.GetInstance();

	mShipSpawnPosition = advGrid.GetCellByWorldLocation( GetShipPos() );
}


function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local H7ResourceQuantity cost;
	local array<H7ResourceQuantity> costs;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>"$Localize("H7AdvMapObjectToolTip","TT_SHIPYARD", "MMH7Game" );
	
	costs = mCosts;
	costs.Sort( class'H7Resource'.static.CostResourceCompareGUI );
	foreach costs(cost)
	{
		data.Description = data.Description $ "\n" $ class'H7GUIGeneralProperties'.static.GetIconHTMLByIcon(cost.Type.GetIcon()) @ String(cost.Quantity) @ cost.Type.GetName();
	}
	data.Description = data.Description $ "</font>";
	return data;
}

function Hide()
{
	mIsHidden=true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden=false;
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

