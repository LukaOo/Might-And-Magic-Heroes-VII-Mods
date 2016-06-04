//=============================================================================
// H7EffectPortalOfAsha
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectPortalOfAsha extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var protected H7AdventureController mAdventureController;
var protected H7AdventureHero mActiveHero;
var protected H7Camera mCamera;
var protected H7Town mTargetTown;
var protected H7HeroAbility mSourceAbility;
var protected array<H7Town> mTownsWithPortals;

function Initialize( H7Effect effect ) {}

function bool CanCast(out string blockReason, H7ICaster caster)
{
	if(H7AdventureHero(caster).HasTearOfAsha())
	{
		blockReason = "TT_CAN_NOT_CAST_WITH_TEAR";
		return false;
	}
	return true;
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7EffectContainer effectContainer;
	local H7ICaster caster;
	local string popUpMessage;

	if( isSimulated ) return;

	mAdventureController = class'H7AdventureController'.static.GetInstance();
	mCamera = class'H7Camera'.static.GetInstance();

	if( mAdventureController == none || mCamera == none ) return;

	effectContainer = effect.GetSource();
	
	caster = effectContainer.GetCaster().GetOriginal();

	mSourceAbility = H7HeroAbility( effectContainer );
	mActiveHero = H7AdventureHero( caster );

	if( mActiveHero == none || mSourceAbility == none ) return;

	mActiveHero.AddMana( mSourceAbility.GetManaCost() ); // restores used mana before even making a decision...
	mAdventureController.UpdateHUD();

	// multiplayer:  the selected player option will be replicated when the player do the RequestPopup
	if( !mActiveHero.GetPlayer().IsControlledByLocalPlayer() )
	{
		mActiveHero.GetEffectManager().RemovePermanentFXBySource( mSourceAbility );
		return;
	}

	mActiveHero.GetEffectManager().AddToFXQueue( effect.GetFx(), effect );
	
	// Find if there are any owned towns with portal
	if( mActiveHero.HasTearOfAsha() )
	{
		mActiveHero.GetEffectManager().RemovePermanentFXBySource( mSourceAbility );
		mActiveHero.SetCastedSpellThisTurn( false );
	}
	else if( FindOwnedTownPortals() )
	{
		// Find if any of the owned towns with portal can be entered
		if( FindClosestAccessibleTown() )
		{
			popUpMessage = class'H7Loca'.static.LocalizeSave("PU_ASHA_TELEPORT","H7PopUp");
			popUpMessage = Repl(popUpMessage, "%ability", mSourceAbility.GetName() );
			popUpMessage = Repl(popUpMessage, "%targettown", mTargetTown.GetName() );
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( popUpMessage, class'H7Loca'.static.LocalizeSave("PU_YES","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_NO","H7PopUp"),ActivateTeleportation,AbortAbility);
		}
		else
		{
			// No owned town portals with free entrance found
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, mActiveHero.GetTargetLocation(), mActiveHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_FREE_TOWN_FOUND","H7FCT") );
			mActiveHero.GetEffectManager().RemovePermanentFXBySource( mSourceAbility );
			mActiveHero.SetCastedSpellThisTurn( false );
		}
	}
	else
	{
		// Did not found any owned town with portal
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, mActiveHero.GetTargetLocation(), mActiveHero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_TOWN_FOUND","H7FCT") );
		mActiveHero.GetEffectManager().RemovePermanentFXBySource( mSourceAbility );
		mActiveHero.SetCastedSpellThisTurn( false );
	}
}

function protected ActivateTeleportation()
{
	local H7AdventurePlayerController playerControl;
	local H7InstantCommandTeleportToTown command;
	
	playerControl = H7AdventurePlayerController( class'H7PlayerController'.static.GetPlayerController() );

	if( playerControl == none )
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("No Player Controller found",MD_FLOATING);;
		return;
	}

	command = new class'H7InstantCommandTeleportToTown';
	command.Init(mTargetTown, mActiveHero, mSourceAbility.GetManaCost());
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);

	mActiveHero.GetEffectManager().RemovePermanentFXBySource( mSourceAbility );
}

function protected AbortAbility()
{
	mActiveHero.GetEffectManager().RemovePermanentFXBySource( mSourceAbility );
	ScrollBackToHero();
	mActiveHero.SetCastedSpellThisTurn( false );
}

function protected bool ScrollToTown()
{
	mTargetTown = GetClosestTown( mActiveHero );

	if( mTargetTown == none ) return false;

	mCamera.SetTargetVRP( mTargetTown.GetTargetLocation() );

	return true;
}

function protected ScrollBackToHero()
{
	mCamera.SetTargetVRP( mActiveHero.GetTargetLocation() );
}

// Returns true if any owned town has portal
function protected bool FindOwnedTownPortals()
{
	local array<H7Town> allTowns;
	local H7Town currentTown;

	allTowns = mAdventureController.GetTownList();

	mTownsWithPortals.Length = 0;

	foreach allTowns ( currentTown )
	{
		if( OwnTown( currentTown, mActiveHero ) && HasTownPortal( currentTown ) )
		{
			mTownsWithPortals.AddItem( currentTown );
		}
	}

	return mTownsWithPortals.Length > 0 ? true : false;
}

// Returns true if found accessible town with portal !! CARE: Operates on list populated in FindOwnedTownPortals
function protected bool FindClosestAccessibleTown()
{
	local H7Town closestTown, currentTown;
	local int currentDistance, bestDistance;

	bestDistance = MaxInt;

	foreach mTownsWithPortals( currentTown )
	{
		if( OwnTown( currentTown, mActiveHero ) && HasTownPortal( currentTown ) )
		{
			if( !IsEntranceFree( currentTown )) 
			{
				 // Braindead? back to where you come from 
				 if( currentTown.GetVisitingArmy() != none  && currentTown.GetVisitingArmy().GetHero() == mActiveHero ||
				 	 currentTown.GetEntranceCell().GetArmy() != none && currentTown.GetEntranceCell().GetArmy().GetHero() == mActiveHero )
				 {
					 closestTown = currentTown;
					 break;
				 }
			}
			else
			{
				currentDistance = GetDistance( currentTown, mActiveHero );
				if( currentDistance < bestDistance )
				{
					closestTown = currentTown;
					bestDistance = currentDistance;
				}
			}
		}
	}

	if(closestTown != none)
	{
		mTargetTown = closestTown;

		mCamera.SetTargetVRP( mTargetTown.GetTargetLocation() );

		return true;
	}

	mTargetTown = none;

	return false;
}

static function H7Town GetClosestTown( H7AdventureHero hero )
{
	local array<H7Town> allTowns;
	local H7Town closestTown, currentTown;
	local int currentDistance, bestDistance;

	bestDistance = MaxInt;
	
	allTowns = class'H7AdventureController'.static.GetInstance().GetTownList();

	foreach allTowns( currentTown )
	{
		if( OwnTown( currentTown, hero ) && HasTownPortal( currentTown ) && IsEntranceFree( currentTown ) )
		{
			currentDistance = GetDistance( currentTown, hero );
			if( currentDistance < bestDistance )
			{
				closestTown = currentTown;
				bestDistance = currentDistance;
			}
		}
	}

	return bestDistance < MaxInt ? closestTown : none;
}

static function protected bool HasTownPortal( H7Town town )
{
	return town.IsBuildingBuiltByClass(class'H7TownPortal');
}

static function bool IsEntranceFree( H7Town town )
{
	local bool hasVisitingArmy, isEntranceUnblocked;

	hasVisitingArmy = town.GetVisitingArmy() == none ? true : false;

	isEntranceUnblocked = town.GetEntranceCell().GetArmy() == none ? true : false;

	return (hasVisitingArmy && isEntranceUnblocked);
}

static function protected int GetDistance( H7Town town, H7AdventureHero hero )
{
	local int distance;
	local Vector start, destination;

	start = hero.GetCell().GetLocation();
	destination = town.GetEntranceCell().GetLocation();
	
	// ignore the Z-Location of the object
	start.Z = 0;
	destination.Z = 0;
	
	distance = VSize( start - destination );

	return distance;
}

static function bool OwnTown( H7Town town, H7AdventureHero hero )
{
	return class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( town.GetPlayerNumber() ) == hero.GetPlayer() ? true : false;
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_TELEPORTING","H7TooltipReplacement");
}
