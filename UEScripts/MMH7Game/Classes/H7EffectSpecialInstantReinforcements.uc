//=============================================================================
// H7EffectSpecialInstantReinforcements
//
// - special effect for "Instant Reinforcements" (Prime magic):
//   Player can teleport garrisoned creatures from the nearest town
//   and add them to the casting hero's adventure army.
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialInstantReinforcements extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var protected H7AdventureController mAdventureController;
var protected H7HeroAbility mSourceAbility;
var protected H7Effect mEffect;

/** The transfer costs depending on the casting hero's skill rank. */
var(InstantReinforcements) array<H7TeleportCosts> mTeleportCosts     <DisplayName=Teleport Costs>;
/** Set FX here to avoid it playing even if no creature was teleported. */
var(InstantReinforcements) protected H7FXStruct mCasterFXS           <DisplayName=Caster Particle Effect>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster;
	local H7AdventureHero initiator;
	local H7TeleportCosts actualCosts;
	local H7Town nearestTown;

	// no simulation!
	if(isSimulated) { return; }

	mEffect = effect;
	caster = effect.GetSource().GetInitiator();
	if(caster == none) { return; }
	initiator = H7AdventureHero(caster);
	if(initiator == none) { return; }

	mAdventureController = class'H7AdventureController'.static.GetInstance();

	mSourceAbility = H7HeroAbility( effect.GetSource() );
	if(mSourceAbility == none) { return; }
	actualCosts = GetTeleportCostsForCaster(initiator);

	nearestTown = GetNearestTown(initiator);

	// check if any town was found
	if(nearestTown == none)
	{
		class'H7FCTController'.static.GetInstance().startFCT(FCT_ERROR, initiator.Location, caster.GetPlayer(),  class'H7Loca'.static.LocalizeSave("FCT_NO_TOWN_FOUND","H7FCT"));
		initiator.SetCastedSpellThisTurn( false );
		return;
	}

	// check if town has a garrison
	if(nearestTown.GetGarrisonArmy().GetCreatureAmountTotal() == 0)
	{
		class'H7FCTController'.static.GetInstance().startFCT(FCT_ERROR, initiator.Location, caster.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_NEAREST_TOWN_NO_GARRISON","H7FCT") );
		initiator.SetCastedSpellThisTurn( false );
		return;
	}

	caster.GetPlayer().SetOriginalReinforcementStacksArmy( initiator.GetAdventureArmy().GetBaseCreatureStacks());
	caster.GetPlayer().SetOriginalReinforcementStacksTown( nearestTown.GetGarrisonArmy().GetBaseCreatureStacks());

	if( initiator.GetPlayer().IsControlledByLocalPlayer() )
	{
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetHud().GetCombatPopUpCntl().StartReinforceMerger(initiator.GetAdventureArmy(), nearestTown, actualCosts, ManaCostDelegate);
	}
}

// delegate for playing FX on caster
function ManaCostDelegate(bool creatureWasTransferred)
{
	local H7ICaster caster;
	// popup did:
	// - calculate mana costs for each creature tier
	// - add creature stacks to the army
	// - pay mana costs

	class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCombatPopUpCntl().ClosePopupHard();
	caster = mEffect.GetSource().GetInitiator();

	if(creatureWasTransferred)
	{
		if( mCasterFXS.mVFX != none )
		{
			if( caster.GetEffectManager() != none )
			{
				caster.GetEffectManager().AddToFXQueue( mCasterFXS, mEffect );
			}
		}
	}
	else
	{
		H7AdventureHero( caster ).SetCastedSpellThisTurn( false );
	}
}

// Get teleporting costs according to the casting hero's rank
function H7TeleportCosts GetTeleportCostsForCaster(H7AdventureHero caster)
{
	local ESkillRank rank;
	local ESkillType skillType;
	local H7Skill skill;
	local H7TeleportCosts currentCosts;
	local H7TeleportCosts costs;

	if(mTeleportCosts.Length == 0)
	{
		;
		return costs;
	}

	skillType = mSourceAbility.GetSkillType();
	skill = caster.GetSkillManager().GetSkillBySkillType(skillType);

	if( skill != none )
		rank = caster.GetSkillManager().GetSkillBySkillType(skillType).GetCurrentSkillRank();
	else
		rank = SR_UNSKILLED;
	
	foreach mTeleportCosts(currentCosts)
	{
		if( currentCosts.HeroRank == rank)
		{
			return currentCosts;
		}
	}
}

// ------- copied code from H7EffectPortalOfAsha ---------- //
function protected H7Town GetNearestTown(H7AdventureHero hero)
{
	local array<H7Town> allTowns;
	local H7Town closestTown, currentTown;
	local int currentDistance, bestDistance;

	bestDistance = MaxInt;
	
	allTowns = mAdventureController.GetTownList();

	foreach allTowns( currentTown )
	{
		if( IsOnSameGrid( currentTown, hero ) && OwnTown( currentTown, hero ) && HasTownPortal( currentTown ) )
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

function protected bool IsOnSameGrid( H7Town town, H7AdventureHero hero )
{
	return ( town.GetEntranceCell().GetGridOwner() == hero.GetCell().GetGridOwner() ); 
}

function protected bool HasTownPortal( H7Town town )
{
	return town.IsBuildingBuiltByClass(class'H7TownPortal');
}

function protected int GetDistance( H7Town town, H7AdventureHero hero )
{
	local int distance;
	local Vector start, destination;

	start = hero.GetTargetLocation();
	destination = town.GetTargetLocation();
	
	// ignore the Z-Location of the object
	start.Z = 0;
	destination.Z = 0;
	
	distance = VSize( start - destination );

	return distance;
}

function protected bool OwnTown( H7Town town, H7AdventureHero hero )
{
	return mAdventureController.GetPlayerByNumber( town.GetPlayerNumber() ) == hero.GetPlayer() ? true : false;
}
// -------------------------------------------------------- //

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_REINFORCEMENTS","H7TooltipReplacement");
}
