/*=============================================================================
* H7TrainingGrounds
* =============================================================================
*  Grants upgrade creature stack oppertunity for visiting armies
* =============================================================================
*  Copyright 2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TrainingGrounds extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

/**Factor, 1.5 = 150% of the original price*/
var() protected float           mUpgradeCostModifier <DisplayName = "Upgrade Cost Modifier">;
var protected savegame bool     mIsHidden;
var protected savegame H7AdventureArmy   mTrainingGroundsArmy;

native function bool IsHiddenX();

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit(hero);
	mVisitingArmy = hero.GetAdventureArmy();
	if(hero.GetPlayer().GetPlayerNumber() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber())
		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTrainingGroundsPopUpCntl().Update(self, H7AdventureArmy(hero.GetArmy()));
}

/**
 * Gets upgrade costs and the amount of creatures that can be
 * upgraded by out parameter.
 * 
 * @param creature The creature for which to create the upgrade data
 * @param slotID If you set this pararamter you also have to set the next one
 * @param isVisitingArmy If the upgrade action should take place in the visiting army rather than the garrison
 * @param numOfUpgCreatures Shows how many creatures could be upgraded currently
 * @param singleUpgCost contains to cost to upgrad only one creature of the stack, only use when numOfUpgCreatures is 0
 * 
 * */
function array<H7ResourceQuantity> GetUpgradeInfo( bool isVisitingArmy, out int numOfUpgCreatures, H7BaseCreatureStack creature=none,optional int slotID=-1, optional H7AdventureArmy remoteArmy=None, optional out array<H7ResourceQuantity> singleUpgCost)
{
	local array<H7ResourceQuantity> upgradeCosts;
	local int i;
	local array<H7BaseCreatureStack> stacks;

	numOfUpgCreatures = 0;

	if(slotID!=-1 && mVisitingArmy != none )
	{
		stacks = mVisitingArmy.GetBaseCreatureStacks();
		creature = stacks[ slotID ];
	}
	
	if(creature == none || creature.GetStackType().GetUpgradedCreature() == none)
	{
		return upgradeCosts;
	}

	// Get the cost of upgrading ONE creature
	class'H7GameUtility'.static.CalculateCreatureCosts( creature.GetStackType().GetUpgradedCreature(), 1, upgradeCosts, true, creature.GetStackType(), mUpgradeCostModifier );

	/// Week of Training or Idle
	if( class'H7AdventureController'.static.GetInstance().HasUpradeCostWeekEffect())
	{
		for (i=0;i<upgradeCosts.Length;++i)
		{
			if( upgradeCosts[i].Type == GetPlayer().GetResourceSet().GetCurrencyResourceType() )
			{
				upgradeCosts[i].Quantity *= class'H7AdventureController'.static.GetInstance().GetUpgradeCostWeekEffect();
			}
		}
	}

	if(mVisitingArmy!=None)
		numOfUpgCreatures = mVisitingArmy.GetPlayer().GetResourceSet().CanSpendResourcesTimes(upgradeCosts);
	else if(remoteArmy!=None)
		numOfUpgCreatures = remoteArmy.GetPlayer().GetResourceSet().CanSpendResourcesTimes(upgradeCosts);

	if(numOfUpgCreatures > creature.GetStackSize()) numOfUpgCreatures = creature.GetStackSize();

	// return upgCost for one creature so we can show it in gui
	if(numOfUpgCreatures == 0)
		singleUpgCost = upgradeCosts;
		

	//multiply the single upgrade costs by the amount of actualy upgradeable creatures
	for(i = 0; i < upgradeCosts.Length; i++)
		upgradeCosts[i].Quantity *= numOfUpgCreatures;

	return upgradeCosts;
}

function UpgradeUnit( int slotID, bool isVisitingArmy, int count )
{
	local H7InstantCommandUpgradeUnit command;

	command = new class'H7InstantCommandUpgradeUnit';
	command.Init( self, slotID, isVisitingArmy, count );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function UpgradeUnitComplete( int slotID, bool isVisitingArmy, int count )
{
	local H7AdventureArmy army;
	local H7BaseCreatureStack newStack, stack, upgradedStack;
	local array<H7ResourceQuantity> costs;
	local H7Player thePlayer;
	local array<H7BaseCreatureStack> stacks;

	thePlayer = mVisitingArmy.GetPlayer();

	if( isVisitingArmy ) { army = mVisitingArmy; }

	stacks = army.GetBaseCreatureStacks();
	costs = GetUpgradeInfo( isVisitingArmy, count, stacks[ slotID ]);

	stack = stacks[ slotID ];
	// upgrade all creatures in stack
	if( stack.GetStackSize() == count )
	{
		stack.SetStackType( stack.GetStackType().GetUpgradedCreature() );
	}
	else
	{
		// if we upgrade part of the stack, prefer splitting the stack to merging a new stack with an exisitng one
		if( army.CheckFreeArmySlot() )
		{
			newStack = new class'H7BaseCreatureStack'();
			newStack.SetStackType( stack.GetStackType().GetUpgradedCreature() );
			newStack.SetStackSize( count );
			army.PutCreatureStackToEmptySlot(newStack);
			stack.SetStackSize( stack.GetStackSize() - count );
		}
		else
		{
			upgradedStack = army.GetStackByName(stack.GetStackType().GetUpgradedCreature().GetName());
			if(upgradedStack != none)
			{
				upgradedStack.SetStackSize( upgradedStack.GetStackSize() + count );
				stack.SetStackSize( stack.GetStackSize() - count );
			}
			else
			{
				;
				return;
			}
		}
	}

	if( thePlayer.GetResourceSet().CanSpendResources( costs ) )
	{
		thePlayer.GetResourceSet().SpendResources( costs );
	}
	
	if( thePlayer.IsControlledByLocalPlayer() )
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons(thePlayer.GetResourceSet().GetAllResourcesAsArray());
	}
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;	

	data.type = TT_TYPE_STRING;
	data.Title = self.GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_TRAINING_GROUNDS","H7AdvMapObjectToolTip") $ "</font>\n";

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
