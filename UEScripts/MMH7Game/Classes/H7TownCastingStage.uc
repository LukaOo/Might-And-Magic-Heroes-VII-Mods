/*=============================================================================
* H7TownCastingStage
* =============================================================================
*  Class for custom academy building "Casting Stage"
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownCastingStage extends H7TownBuilding  implements( H7ICaster )
	native;

var( CastingStage ) protected array<H7BaseAbility> mAbilities<DisplayName=Possible Spells>; //TODO: take the pool of all spells
var protected H7CombatHero mCaster;
var protected H7Town mTownOwner;

function        SetTown( H7Town town )  { mTownOwner = town; }
function H7Town GetTownOwner()          { return mTownOwner; }

native function H7ICaster           GetOriginal();
native function H7AbilityManager	GetAbilityManager();
native function H7BuffManager       GetBuffManager();
function H7EffectManager            GetEffectManager()								{ return none; }
native function H7EventManager      GetEventManager();
function                            DataChanged(optional String cause)				{}
native function int					GetID();
native function EUnitType           GetEntityType();

function                            PrepareAbility(H7BaseAbility ability)			{ GetAbilityManager().PrepareAbility( ability ); }
function H7BaseAbility              GetPreparedAbility()                            { return GetAbilityManager().GetPreparedAbility(); }
function ECommandTag                GetActionID( H7BaseAbility ability )            { return ACTION_ABILITY; }
native function bool                IsDefaultAttackActive(); //                         { return false; }
native function Vector              GetLocation();
native function IntPoint            GetGridPosition();
native function H7Player            GetPlayer();
native function H7CombatArmy        GetCombatArmy();

function float GetMinimumDamage(){	return 0;}
function float GetMaximumDamage(){	return 0;}
function int GetAttack(){	return 0;}
native function int GetLuckDestiny();
function int GetMagic(){    return 0;}
function int GetStackSize(){    return 1;}
function EAbilitySchool GetSchool() { return ABILITY_SCHOOL_NONE; }

function                            UsePreparedAbility(H7IEffectTargetable target) 
{ 
	local H7BaseGameController bgController;

	if(!class'H7AdventureController'.static.GetInstance().CanQueueCommand())
	{
		return;
	}

	bgController = class'H7BaseGameController'.static.GetBaseInstance();
	bgController.GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( self, UC_ABILITY, ACTION_ABILITY, GetPreparedAbility(), target ) );
}

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) {}


function InitTownBuilding(  H7Town town  )
{
	super.InitTownBuilding( town );

	LearnAbilities();
}

function protected LearnAbilities()
{
	local H7BaseAbility ability;

	foreach mAbilities( ability )
	{
		GetAbilityManager().LearnAbility( ability );
	}
}

/**
 * returns a random ability from the ability pool
 */
function protected H7BaseAbility GetRandomAbility()
{
	local array<H7BaseAbility> negativeAbilities;
	local H7BaseAbility currentAbility;
	local int MagicGuildRank;
	
	MagicGuildRank = MagicGuildRank; // to avoid script warnings
	MagicGuildRank = GetMagicGuild( mTownOwner ).GetRank();
	
	foreach mAbilities( currentAbility )
	{
		if( currentAbility.HasNegativeEffect() 
			&& currentAbility.GetTargetType() == TARGET_SINGLE
			&& currentAbility.IsSpell()/* && 
			currentAbility.GetRank() == MagicGuildRank*/ ) //TODO: enable this if needed.... disabled because of too less spells
		{
			negativeAbilities.AddItem( currentAbility );
		}
	}

	return negativeAbilities.Length > 0 ? negativeAbilities[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( negativeAbilities.Length ) ] : none;
}

function static H7TownCastingStage GetBuiltCastingStageInTown( H7Town town )
{
	local array<H7TownBuildingData> townBuildings;
	local H7TownBuildingData currentBuilding;

	if( town == none )
		return none;

	townBuildings = town.GetBuildings();

	foreach townBuildings( currentBuilding )
	{
		if( currentBuilding.Building.IsA( 'H7TownCastingStage' ) && currentBuilding.IsBuilt )
		{
			return H7TownCastingStage(currentBuilding.Building);
		}
	}

	return none;
}

/**
 * checks if the battle starts inside of an AoC with a built Casting Stage
 * and adds a buff
 */
function static H7TownCastingStage CheckAndHandleCastingStage( H7AdventureArmy attacker, H7AdventureArmy defender )
{
	local H7Town town;
	local H7TownCastingStage castingStage;
	local H7BaseAbility ability;
	
	town = class'H7AdventureController'.static.GetInstance().GetAoCOwnerByWorldLocation(defender.GetTargetLocation());

	if( town == none ) return none;

	castingStage = GetBuiltCastingStageInTown( town );
	
	if( castingStage == none ) return none;

	castingStage.SetTown( town );

	ability = castingStage.GetRandomAbility();

	castingStage.PrepareAbility( ability );

	return castingStage;
}

static function UseCastingStageAbility( H7CombatController cmbtContrl )
{
	local H7AdventureController advenCntl;
	local H7TownCastingStage stage;
	local array<H7CreatureStack> stacks;

	advenCntl = class'H7AdventureController'.static.GetInstance();

	if( advenCntl != none )
	{
		stage = advenCntl.GetPreparedCastingStage();

		if( stage != none )
		{
			if( stage.GetTownOwner().GetPlayerNumber() == cmbtContrl.GetArmyAttacker().GetPlayerNumber() )
			{
				stacks = cmbtContrl.GetArmyDefender().GetCreatureStacks();
			}
			else if( stage.GetTownOwner().GetPlayerNumber() == cmbtContrl.GetArmyDefender().GetPlayerNumber() )
			{
				stacks = cmbtContrl.GetArmyAttacker().GetCreatureStacks();
			}
			
			if( stacks.Length > 0 )
			{
				stage.UsePreparedAbility( stage.GetRandomTarget( stage.GetAbilityManager().GetAbility( stage.GetPreparedAbility() ), stacks ) );
			}
		}

		advenCntl.SetPreparedCastingStage( none );
	}
}

protected function static H7TownMagicGuild GetMagicGuild( H7Town town )
{
	local array<H7TownBuildingData> buildings;
	local H7TownBuildingData currentBuildingData;
	local H7TownMagicGuild magicGuild;
	
	buildings = town.GetBuildings();
	foreach buildings( currentBuildingData )
	{
		if( currentBuildingData.Building.IsA( 'H7TownMagicGuild' ) && currentBuildingData.IsBuilt )
		{
			break;
		}
	}

	if( currentBuildingData.Building != none )
	{
		magicGuild = H7TownMagicGuild( town.GetBestBuilding(currentBuildingData).Building );
	}

	return magicGuild;
}

static function H7IEffectTargetable GetRandomTarget( H7BaseAbility ability, array<H7CreatureStack> stacks )
{
	local array<H7IEffectTargetable> targetableStacks;
	local H7CreatureStack stack;
	foreach stacks( stack )
	{
		if( ability.CanCastOnTargetActor( stack ) )
		{
			targetableStacks.AddItem( H7IEffectTargetable( stack ) );
		}
	}

	if( targetableStacks.Length > 0 )
	{
		return targetableStacks[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( targetableStacks.Length ) ];
	}
	return none;
}
