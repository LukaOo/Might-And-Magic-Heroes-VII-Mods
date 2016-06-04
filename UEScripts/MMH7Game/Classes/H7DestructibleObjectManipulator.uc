/*=============================================================================
* H7DestructibleObjectManipulator
* =============================================================================
* http://weknowmemes.com/2012/03/what-the-fuck-are-you-doing-cat/
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7DestructibleObjectManipulator extends H7NeutralSite
	hideCategories(Defenses)
	implements( H7ITooltipable, H7IHideable )
	dependson( H7ITooltipable )
	placeable
	savegame
	native;

var protected array<H7GameplayFracturedMeshActor> mTargetObjects;
var protected array<H7IDestructible> mTargetDestructibles;
/** Cost to repair the attached destructible object */
var(Properties) protected array<H7ResourceQuantity> mCosts<DisplayName="Repair Cost">;
/** Destruction cost **/
var(Properties) protected array<H7ResourceQuantity> mDestructionCosts<DisplayName="Destruction Cost">;
/** Turns to repair the attached destructible object */
var(Developer) protected int mRepairDuration<DisplayName="Repair Duration"|ClampMin=0>;
/** Turns to destroy the attached destructible object */
var(Developer) protected int mDestroyDuration<DisplayName="Destruction Duration"|ClampMin=0>;
/** Keep movement points on destroy */
var(Developer) protected bool mKeepMovementPointsOnDestroy<DisplayName="Keep movement points on destroy">;
/** Disable repairing **/
var(Developer) protected bool mDisableRepair<DisplayName="Disable repairing">;
var(Developer) protected bool mDisableCameraEvent<DisplayName="Disable Camera Event">;

var protectedwrite savegame int mManipulationCounter;
var protected savegame bool mIsDestroyed, mManipulationInitiated, mIsDestroying, mIsRepairing, mInformedGUI;
var array<H7DestructibleObjectManipulator> mManipulators;



var(Properties) protected bool mHideRepairTooltip<DisplayName="Hide Repair Tooltip">;
var(Properties) protected bool mHideDestroyTooltip<DisplayName="Hide Destroy Tooltip">;

var protected savegame bool    mIsHidden;

var private transient string TT_REPAIR_DESC;
var private transient string TT_DESTROY_DESC;
var private transient string TT_DESTROY;
var private transient string TT_REPAIR;
var private transient string TT_TURNS;

function AddDestructibleObject( H7GameplayFracturedMeshActor obj ) { mTargetObjects.AddItem( obj ); }
function AddDestructibleObjectByInterface( H7IDestructible obj ) { mTargetDestructibles.AddItem( obj ); }

function bool IsManipulationInitiated() { return mManipulationInitiated; }

function H7AdventureArmy GetVisitingArmy() { return mVisitingArmy; }
function SetVisitingArmy( H7AdventureArmy army ) 
{
	mVisitingArmy = army; 
	if( !mInformedGUI )
	{
		SetTimer( 1.0f, true, 'CheckHUD' );
	}
}

// HACK because bridges are inited before GUI, they need to wait until GUI comes online
function CheckHUD()
{
	if( class'H7PlayerController'.static.GetPlayerController() != none )
	{
		if( class'H7PlayerController'.static.GetPlayerController().GetHud() != none )
		{
			if( mManipulationInitiated )
			{
				if(mRepairDuration > 1) class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().CreateProgressBar( mVisitingArmy.GetHero() , GetProgressPercent() );
				mInformedGUI = true;
				ClearTimer( 'CheckHUD' );
				return;
			}
		}
	}
}

event InitAdventureObject()
{
	local H7GameplayFracturedMeshActor currentObject;
	local H7IDestructible destructible;

	super.InitAdventureObject();

	class'H7AdventureController'.static.GetInstance().AddDestructionManipulator( self );
	
	// if one target object is broken, count their status as Destroyed
	foreach mTargetObjects( currentObject )
	{
		if( currentObject.IsFractured() )
		{
			mIsDestroyed = true;
		}
	}
	foreach mTargetDestructibles( destructible )
	{
		if( destructible.IsDestroyed() )
		{
			mIsDestroyed = true;
		}
	}

	TT_REPAIR_DESC = class'H7Loca'.static.LocalizeSave("TT_REPAIR_DESC","H7DestructibleObjectManipulator");
	TT_DESTROY_DESC = class'H7Loca'.static.LocalizeSave("TT_DESTROY_DESC","H7DestructibleObjectManipulator");
	TT_DESTROY = class'H7Loca'.static.LocalizeSave("TT_DESTROY","H7DestructibleObjectManipulator");
	TT_REPAIR = class'H7Loca'.static.LocalizeSave("TT_REPAIR","H7DestructibleObjectManipulator");
	TT_TURNS = class'H7Loca'.static.LocalizeSave("TT_TURNS","H7DestructibleObjectManipulator");
}

function CountDown()
{
	if( !mManipulationInitiated ) { return; }

	if( mManipulationCounter > 0 )
	{
		mManipulationCounter--;
	}

	if( mManipulationCounter > 0 )
	{
		//0 the movement of the hero, while not finished with the manipulation
		mVisitingArmy.GetHero().SetCurrentMovementPoints( 0 );
	}

	if( mManipulationCounter <= 0 )
	{
		if( mDisableCameraEvent || class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
		{
			ManipulateObjects();
		}
		else
		{
			SetTimer(1, false, 'ViewObjects');
		}
	}
}

function ViewObjects()
{
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		return;
	}

	if( mTargetObjects.Length > 0 && !mDisableCameraEvent )
	{
		class'H7CameraActionController'.static.GetInstance().StartAMEventAction(mTargetObjects[0], mTargetObjects[mTargetObjects.Length - 1], , ManipulateObjects);
	}
	if( mTargetDestructibles.Length > 0 && !mDisableCameraEvent )
	{
		class'H7CameraActionController'.static.GetInstance().StartAMEventAction(Actor( mTargetDestructibles[0] ), Actor( mTargetDestructibles[mTargetDestructibles.Length - 1] ), , ManipulateObjects );
	}
}

function RebuildStatus()
{
	local H7GameplayFracturedMeshActor currentObject;
	local H7IDestructible destructible;
	// check on visit, if some targets are destroyed, because targets can have multiple manipulators
	mIsDestroyed = false;
	mIsDestroying = false;
	mIsRepairing = false;
	foreach mTargetObjects( currentObject )
	{
		if( currentObject.IsFractured() )
		{
			mIsDestroyed = true;
		}
		if( currentObject.IsDestroying() )
		{
			mIsDestroying = true;
		}
		if( currentObject.IsRepairing() )
		{
			mIsRepairing = true;
		}
	}
	foreach mTargetDestructibles( destructible )
	{
		if( destructible.IsDestroyed() )
		{
			mIsDestroyed = true;
		}
		if( destructible.IsDestroying() )
		{
			mIsDestroying = true;
		}
		if( destructible.IsRepairing() )
		{
			mIsRepairing = true;
		}
	}


}

function OnVisit( out H7AdventureHero hero )
{
	local H7GameplayFracturedMeshActor currentObject;
	local H7DestructibleObjectManipulator manipulator;
	local array<H7DestructibleObjectManipulator> manipulators;
	local string popUpMessage;
	local H7IDestructible destructible;

	if( IsHiddenX() ) { return; }

	RebuildStatus();

	// Somebody is already interacting/reparing it
	if( mManipulationInitiated && mVisitingArmy != none)
	{
		if(mIsRepairing)
		{
			;
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_BEING_REPAIRED","H7FCT") );
		}

		return;
	}

	super.OnVisit( hero );

	;

	// http://weknowmemes.com/2012/03/what-the-fuck-are-you-doing-cat/ <- blame the designers
	if( mIsDestroying )
	{
		if( hero.GetPlayer().IsControlledByLocalPlayer() )
		{
			;
			foreach mTargetObjects( currentObject )
			{
				manipulators = currentObject.GetManipulators();
				foreach manipulators( manipulator )
				{
					if( manipulator != self )
					{
						if( manipulator.GetVisitingArmy() != none && manipulator.GetVisitingArmy().GetPlayerNumber() != hero.GetPlayer().GetPlayerNumber() )
						{
							class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCombatPopUpCntl().ShowStartCombatPopUp( hero.GetAdventureArmy(), manipulator.GetVisitingArmy() );
						}
					}
				}
			}
			foreach mTargetDestructibles( destructible )
			{
				manipulators = destructible.GetManipulators();
				foreach manipulators( manipulator )
				{
					if( manipulator != self )
					{
						if( manipulator.GetVisitingArmy() != none && manipulator.GetVisitingArmy().GetPlayerNumber() != hero.GetPlayer().GetPlayerNumber() )
						{
							class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCombatPopUpCntl().ShowStartCombatPopUp( hero.GetAdventureArmy(), manipulator.GetVisitingArmy() );
						}
					}
				}
			}
		}
	}
	else if( mIsRepairing )
	{
		;
		class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ALREADY_BEING_REPAIRED","H7FCT") );
	}
	else if( mIsDestroyed )
	{
		if( mDisableRepair )
		{
			return;
		}
		;

		mVisitingArmy = hero.GetAdventureArmy();

		if( hero.IsControlledByAI()==false )
		{
			if( hero.GetPlayer().IsControlledByLocalPlayer() )
			{
				if( hero.GetPlayer().GetResourceSet().CanSpendResources( mCosts ) )
				{
					mIsDestroying = false;
					popUpMessage = class'H7Loca'.static.LocalizeSave("PU_BRIDGE_REPAIR","H7PopUp");
					popUpMessage = Repl(popUpMessage, "%duration", mRepairDuration );
					popUpMessage = Repl(popUpMessage, "%price", "" );
					class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( 
						popUpMessage, class'H7Loca'.static.LocalizeSave("PU_REPAIR","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), BeginCountDown, Leave, mCosts, true );
				}
				else
				{
					class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_RESOURCES_TO_REPAIR","H7FCT") );
				}
			}
		}
		else if(class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
		{
			if( hero.GetPlayer().GetResourceSet().CanSpendResources( mCosts ) )
			{
				mIsDestroying = false;
				BeginCountDown();
				hero.SetFinishedCurrentTurn(true);
			}
			else
			{
				class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_RESOURCES_TO_REPAIR","H7FCT") );
			}
		}
	}
	else
	{
		mVisitingArmy = hero.GetAdventureArmy();

		;

		if( hero.IsControlledByAI()==false )
		{
			mIsDestroying = true;
			if( hero.GetPlayer().IsControlledByLocalPlayer() )
			{
				if( hero.GetPlayer().GetResourceSet().CanSpendResources( mDestructionCosts) )
				{
					popUpMessage = class'H7Loca'.static.LocalizeSave("PU_BRIDGE_DESTROY","H7PopUp");
					popUpMessage = Repl(popUpMessage, "%duration", mDestroyDuration );
					popUpMessage = Repl(popUpMessage, "%price", "" );
					class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoCostPopup( 
						popUpMessage, class'H7Loca'.static.LocalizeSave("PU_DESTROY","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_ABORT","H7PopUp"), BeginCountDown, Leave, mDestructionCosts, true );
				}
				else
				{
					class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_RESOURCES_TO_DESTROY","H7FCT") );
				}
			}
		}
		else if(class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
		{
			if( hero.GetPlayer().GetResourceSet().CanSpendResources( mDestructionCosts ) )
			{
				mIsDestroying = true;
				BeginCountDown();
				hero.SetFinishedCurrentTurn(true);
			}
			else
			{
				class'H7FCTController'.static.GetInstance().StartFCT( FCT_ERROR, Location, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_RESOURCES_TO_DESTROY","H7FCT") );
			}
		}
	}
}

protected function Leave()
{
	class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, Location, mVisitingArmy.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NO_ACTION_TAKEN","H7FCT") );
	mVisitingArmy = none;
	mManipulationInitiated = false;
}

protected function ManipulateObjects()
{
	local H7GameplayFracturedMeshActor currentObject;
	local H7IDestructible destructible;
	local vector emptyVect;

	emptyVect = Vect(0,0,0);

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().RemoveBar( mVisitingArmy.GetHero() );

	mVisitingArmy.SetArmyLocked( false );
	mVisitingArmy = none;
	mManipulationInitiated = false;
	mIsDestroyed = true;

	foreach mTargetObjects( currentObject )
	{
		if( mIsDestroying )
		{
			currentObject.TakeDamage(100000,none,emptyVect,emptyVect,none);
			currentObject.SetDestroying( false );
			currentObject.SetRepairing( false );
			mIsDestroyed = true;

			TriggerGlobalEventClass(class'H7SeqEvent_CompletesDestruction', self);
			class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		}
		else
		{
			currentObject.TakeDamage(-100000,none,emptyVect,emptyVect,none);
			currentObject.SetDestroying( false );
			currentObject.SetRepairing( false );
			mIsDestroyed = false;

			TriggerGlobalEventClass(class'H7SeqEvent_CompletesReparation', self);
			class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		}
	}

	foreach mTargetDestructibles( destructible )
	{
		if( mIsDestroying )
		{
			destructible.DestroyDestructibleObject();
			destructible.SetDestroying( false );
			destructible.SetRepairing( false );
			mIsDestroyed = true;

			TriggerGlobalEventClass(class'H7SeqEvent_CompletesDestruction', self);
			class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		}
		else
		{
			destructible.RepairDestructibleObject();
			destructible.SetDestroying( false );
			destructible.SetRepairing( false );
			mIsDestroyed = false;

			TriggerGlobalEventClass(class'H7SeqEvent_CompletesReparation', self);
			class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		}
	}

}

function int GetProgressPercent()
{
	local int max;
	if(mIsDestroying)
		max = mDestroyDuration;
	else
		max = mRepairDuration;

	return (1-float(mManipulationCounter)/float(max))*100;
}

function BeginCountDown()
{
	StartDestructionOrReparation();
}

function StartDestructionOrReparation()
{
	local H7InstantCommandStartDestructionOrReparation command;

	command = new class'H7InstantCommandStartDestructionOrReparation';
	command.Init( self );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function StartDestructionOrReparationComplete()
{
	local H7GameplayFracturedMeshActor dasObject;

	if( mIsDestroying )
	{
		mManipulationCounter = mDestroyDuration;
		foreach mTargetObjects( dasObject )
		{
			if( dasObject.IsArmyOnTiles() )
			{
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, location, mVisitingArmy.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_ARMY_ON_BRIDGE_CANT_DESTROY","H7FCT"), MakeColor(255,0,255,255));
				return;
			}
			dasObject.BlockTiles();
			dasObject.SetDestroying( true );
			dasObject.SetRepairing( false );

			TriggerGlobalEventClass(class'H7SeqEvent_StartsDestruction', self);
			class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		}
		mVisitingArmy.GetPlayer().GetResourceSet().SpendResources( mDestructionCosts );
	}
	else
	{
		foreach mTargetObjects( dasObject )
		{
			dasObject.SetDestroying( false );
			dasObject.SetRepairing( true );
			//Movementpoints to 0 at use
			mVisitingArmy.GetHero().SetCurrentMovementPoints( 0 );
			TriggerGlobalEventClass(class'H7SeqEvent_StartsReparation', self);
			class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
		}
		mVisitingArmy.GetPlayer().GetResourceSet().SpendResources( mCosts );
		mManipulationCounter = mRepairDuration;
	}

	if( mIsDestroying && !mKeepMovementPointsOnDestroy )
	{
		mVisitingArmy.GetHero().SetCurrentMovementPoints( 0 );
	}

	if( mManipulationCounter <= 0 )
	{
		ManipulateObjects();
	}
	else
	{
		mVisitingArmy.SetArmyLocked( true );
		mManipulationInitiated = true;
		if(mDestroyDuration > 1) class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().CreateProgressBar( mVisitingArmy.GetHero() , 0);
		mInformedGUI = true;
	}
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local string costData;
	local H7ResourceQuantity cost;
	local string lineBreak;
	local array<H7ResourceQuantity> costs;

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	
	costData = "<font size='#TT_BODY#'>";

	if(!mHideRepairTooltip && mCosts.Length > 0)
	{
		costData = costData $ TT_REPAIR_DESC;
		costs = mCosts;
		costs.Sort( class'H7Resource'.static.CostResourceCompareGUI );
		foreach costs( cost )
		{
			costData = costData @ "\n" $ class'H7GUIGeneralProperties'.static.GetIconHTMLByIcon(cost.Type.GetIcon()) @ cost.Quantity @ cost.Type.GetName();
		}
	}

	if(!mHideDestroyTooltip && mDestructionCosts.Length > 0)
	{
		lineBreak = (!mHideRepairTooltip && mCosts.Length > 0) ? "\n" : "";
		costData = costData $ lineBreak $ TT_DESTROY_DESC;
		costs = mDestructionCosts;
		costs.Sort( class'H7Resource'.static.CostResourceCompareGUI );
		foreach mDestructionCosts( cost )
		{
			costData = costData @ "\n" $ class'H7GUIGeneralProperties'.static.GetIconHTMLByIcon(cost.Type.GetIcon()) @ cost.Quantity @ cost.Type.GetName();
		}
	}

	if(!mHideDestroyTooltip)
	{
		lineBreak = "\n";
		costData = costData $ lineBreak $ TT_DESTROY @ mDestroyDuration @ TT_TURNS;
	}

	if(!mHideRepairTooltip)
	{
		lineBreak = "\n";
		costData = costData $ lineBreak $ TT_REPAIR @ mRepairDuration @ TT_TURNS;
	}

	costData = costData @ "</font>";
	data.Description = costData;
	
	return data;
}

function AbortMyManipulation()
{
	local H7ResourceQuantity cost;
	local H7GameplayFracturedMeshActor dasObject;

	;

	if( !mIsDestroying )
	{
		foreach mCosts( cost )
		{
			;
			mVisitingArmy.GetPlayer().GetResourceSet().ModifyResource( cost.Type, cost.Quantity );
		}
	}

	foreach mTargetObjects( dasObject )
	{
		if( !dasObject.IsFractured() )
		{
			dasObject.UnBlockTiles();
		}
		dasObject.SetDestroying( false );
		dasObject.SetRepairing( false );
	}

	class'H7PlayerController'.static.GetPlayerController().GetHud().GetOverlaySystemCntl().RemoveBar( mVisitingArmy.GetHero() );
	mManipulationInitiated = false;
	mVisitingArmy.SetArmyLocked( false );
	mVisitingArmy = none;
}

static function CountDownForAll()
{
	local array<H7DestructibleObjectManipulator> manipulator;
	local H7DestructibleObjectManipulator currentManipulator;
	local H7AdventureController advCntl;

	advCntl = class'H7AdventureController'.static.GetInstance();
	
	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		manipulator = advCntl.GetDestructionManipulators();

		foreach manipulator( currentManipulator )
		{
			currentManipulator.CountDown();
		}
	}
	else
	{
		manipulator = advCntl.GetDestructionManipulators();

		foreach manipulator( currentManipulator )
		{
			if( currentManipulator.GetVisitingArmy() != none && advCntl.GetCurrentPlayer() == currentManipulator.GetVisitingArmy().GetPlayer() )
			{
				currentManipulator.CountDown();
			}
		}
	}
}

static function AbortManipulation( H7AdventureArmy army )
{
	local array<H7DestructibleObjectManipulator> manipulator;
	local H7DestructibleObjectManipulator currentManipulator;
	
	manipulator = class'H7AdventureController'.static.GetInstance().GetDestructionManipulators();

	foreach manipulator( currentManipulator )
	{
		if( army == currentManipulator.GetVisitingArmy() )
		{
			currentManipulator.AbortMyManipulation();
		}
	}
}

static function H7DestructibleObjectManipulator GetObjectByArmy(H7AdventureArmy army)
{
	local array<H7DestructibleObjectManipulator> manipulator;
	local H7DestructibleObjectManipulator currentManipulator;
	
	manipulator = class'H7AdventureController'.static.GetInstance().GetDestructionManipulators();

	foreach manipulator( currentManipulator )
	{
		if( army == currentManipulator.GetVisitingArmy() )
		{
			return currentManipulator;
		}
	}

	return none;
}

function bool CanBeDestroyed( H7AdventureHero hero )
{
	RebuildStatus();

	if( mIsDestroyed == true || mIsDestroying == true ) 
	{
		return false;
	}
	return true;
}

function bool CanBeRepaired( H7AdventureHero hero )
{
	RebuildStatus();

	if( mIsDestroyed==true && mIsRepairing==false )
	{
		// for a given hero (player) we also check if he could affort the cost
		if( hero==None || hero.GetPlayer().GetResourceSet().CanSpendResources(mCosts) )
		{
			return true;
		}
	}
	return false;
}

//H7IHideable
native function bool IsHiddenX();

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	mMesh.SetHidden( mIsHidden );
	if(mHideMeshAndFX)
	{
		SetVisibility(!mIsHidden);
		SkeletalMeshComponent.SetHidden( mIsHidden );
	}
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	mMesh.SetHidden( mIsHidden );
	if(mHideMeshAndFX)
	{
		SetVisibility(!mIsHidden);
		SkeletalMeshComponent.SetHidden( mIsHidden );
	}
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	super.PostSerialize();

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

