//=============================================================================
// H7AuraManager
//=============================================================================
//
// This class is responsible for handling auras on grids
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AuraManager extends Object
	native(Tussi);

var protected array<H7AuraInstance> mActiveAuras;
var protected array<H7AuraInstance> mActiveAurasBuffer;
var protected array<IntPoint> mActiveAuraPoints;
var protected H7ICaster mOwner;
var protected bool mIsOnCombatMap;

function array<H7AuraInstance> GetAuraInstances() { return mActiveAuras; }

function ModifyAuraArea( int auraIndex, array<IntPoint> newArea )
{
	if( auraIndex >= mActiveAuras.Length || auraIndex < 0 ) return;

	mActiveAuras[auraIndex].mAffectedCells = newArea;

	UpdateAuras();
}

function SetIsOnCombatMap( bool isItReally ) { mIsOnCombatMap = isItReally; }

function SetOwner( H7ICaster owner ) { mOwner = owner; }

native protected function AddAuraNative( H7AuraInstance aura );
/** Updates aura instances with new targets and cells, gets arrays of targets to add/remove for events - targetsToAdd/abilitiesToAdd and targetsToRemove/abilitiesToRemove are in a 1:1 relation */
native protected function UpdateAurasNative( out array<H7IEffectTargetable> targetsToAdd, out array<H7IEffectTargetable> targetsToRemove, out array<H7BaseAbility> abilitiesToAdd, out array<H7BaseAbility> abilitiesToRemove, bool onlyEveryStepAuras, bool forceReapplyForTactics, H7IEffectTargetable targetToUpdate, optional array<H7BaseAbility> auras, optional H7BaseCell newCell, optional H7BaseCell oldCell );
native protected function int GetLatestBufferedAuraIndex( H7BaseAbility potatoAbility );
native function GetAuraAbilitiesForCell( H7BaseCell cell, out array<H7BaseAbility> foundAuras );
native function bool CheckIsInAura( H7BaseCell cell, H7IEffectTargetable target, H7BaseAbility auraAbility );

function array<H7AuraInstance> GetAuraInstancesForAbility( H7BaseAbility ability )
{
	local array<H7AuraInstance> instances;
	local int i;

	for( i = 0; i < mActiveAuras.Length; ++i )
	{
		if( ability.ObjectArchetype == mActiveAuras[i].mAuraAbility.ObjectArchetype )
		{
			instances.AddItem( mActiveAuras[i] );
		}
	}

	return instances;
}   

function AddAura( H7AuraInstance aura, bool onlyEveryStepAuras )
{
	AddAuraNative( aura );
	UpdateAuras( onlyEveryStepAuras );
}

function UpdateAuras( optional bool onlyEveryStepAuras = false, optional array<H7BaseAbility> auras, optional H7BaseCell newCell, optional H7BaseCell oldCell, optional H7IEffectTargetable target )
{
	local array<H7IEffectTargetable> targetsToAdd;
	local array<H7IEffectTargetable> targetsToRemove;
	local array<H7BaseAbility> abilitiesToAdd;
	local array<H7BaseAbility> abilitiesToRemove;
	
	local bool isTactics;

	isTactics = false;
	if(class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		// TODO enable aura updating for tactics phase again, but refactor that stuff first (else, game crash :/)
		//isTactics = class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().IsInTacticsPhase();
		isTactics = false;
	}

	UpdateAurasNative( targetsToAdd, targetsToRemove, abilitiesToAdd, abilitiesToRemove, onlyEveryStepAuras, isTactics, target, auras, newCell, oldCell );
}

function AddLog(ETrigger event,H7IEffectTargetable target,H7BaseAbility aura)
{
	local H7Message message;

	message = new class'H7Message';
	if(event == ON_APPLY_AURA) message.text = "MSG_APPLY_AURA";
	if(event == ON_REMOVE_AURA) message.text = "MSG_REMOVE_AURA";

	message.AddRepl("%target",target.GetName());
	message.AddRepl("%aura",aura.GetName());

	message.settings.referenceObject = target;
	message.destination = MD_LOG;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
}

native function RemoveAuraFromSource( H7EffectContainer container);

function bool CheckTacticsDeployment( H7ICaster initiator )
{
	local H7CreatureStack auraDude;
	local H7BaseCreatureStack baseCr;
	local IntPoint gPos;
	local bool retVal;

	auraDude = H7CreatureStack( initiator );
	if(auraDude == none) { return false; }

	baseCr = class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().GetCurrentlyDeployingArmy().GetBaseStackBySpawnedStack( auraDude );
	// remove aura if dude is not deployed anyway
	retVal = ( baseCr != none && !baseCr.IsDeployed() );
	if(!retVal)
	{
		gPos = auraDude.GetGridPosition();
		// remove aura if dude seemn to be deployed, but his grid position might still be -1, -1
		retVal = ( gPos.X == -1 );
	}

	return retVal;
}

function RemoveAurasFromCaster( H7ICaster caster ) 
{
	local int i, j;
	local H7CombatMapGridController combatGridController;
	local H7AdventureMapGridController adventureGridController;

	combatGridController = H7CombatMapGridController( mOwner );
	adventureGridController = H7AdventureMapGridController( mOwner );

	for( i = mActiveAuras.Length-1; i >= 0; --i )
	{
		if( mActiveAuras[i].mAuraAbility.GetCaster().GetOriginal() == caster )
		{
			mActiveAuras[i].mAuraAbility.GetEventManager().Raise( ON_BUFF_EXPIRE, false );

			mActiveAurasBuffer.AddItem( mActiveAuras[i] );
			
			for( j = 0; j < mActiveAuras[i].mAffectedCells.Length; ++j )
			{
				if( !mIsOnCombatMap )
				{
					adventureGridController.GetCell( mActiveAuras[i].mAffectedCells[j].X, mActiveAuras[i].mAffectedCells[j].Y ).RemoveAuraAbility( mActiveAuras[i].mAuraAbility );
				}
				else
				{
					combatGridController.GetCombatGrid().GetCell( mActiveAuras[i].mAffectedCells[j].X, mActiveAuras[i].mAffectedCells[j].Y ).RemoveAuraAbility( mActiveAuras[i].mAuraAbility );
				}
			}

			mActiveAuras.Remove( i, 1 );

		}
	}
}

function TriggerEvents( Etrigger triggerr, bool simulate, optional H7EventContainerStruct container, optional H7ICaster source )
{
	local int i;

	for( i = mActiveAuras.Length-1; i >= 0; --i )
	{
		if( source == none || source == mActiveAuras[i].mAuraAbility.GetCaster() )
		{
			mActiveAuras[i].mAuraAbility.GetEventManager().Raise( triggerr, simulate, container );
		}
	}
}

function static H7AuraInstance CreateAuraInstance( H7BaseAbility ability,  array<IntPoint> affectedCells )
{
	local H7AuraInstance aura;

	if( !ability.IsPassive() )
	{
		aura.mAuraAbility = new ability.Class( ability );
		aura.mAuraAbility.OnInit( ability.GetCaster().GetOriginal() );
	}
	else
	{
		aura.mAuraAbility = ability;
	}
	
	aura.mAffectedCells = affectedCells;

	return aura;
}

event ClearAuras()
{
	local int i;
	for( i = 0; i < mActiveAuras.Length; ++i )
	{
		mActiveAuras[i].mAffectedCells.Length = 0;
		mActiveAuras[i].mAffectedTargets.Length = 0;
		mActiveAuras[i].mAuraAbility = none;
	}
	for( i = 0; i < mActiveAurasBuffer.Length; ++i )
	{
		mActiveAurasBuffer[i].mAffectedCells.Length = 0;
		mActiveAurasBuffer[i].mAffectedTargets.Length = 0;
		mActiveAurasBuffer[i].mAuraAbility = none;
	}
	mActiveAuras.Length = 0;
	mActiveAurasBuffer.Length = 0;
	mOwner = none;
}
