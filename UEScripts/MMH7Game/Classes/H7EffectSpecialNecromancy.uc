//=============================================================================
// H7EffectSpecialNecromancy
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialNecromancy extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var(Necromancy) protected bool                              mUseCreatureArchetype<DisplayName=Raise Specific Creature|ToolTip=If set to false, the same creature as in the stack that lost it is raised and added back to the stack>;
var(Necromancy) protected H7Creature						mRaisedCreature<DisplayName=Creature type raised|EditCondition=mUseCreatureArchetype>;
var(Necromancy) protected int								mRaisePercentage<DisplayName=Amount of HP used for resurrection in %|ClampMin=0|ClampMax=100>;
var(Necromancy) protected int                               mMaxResCreatures<DisplayName=Maximum Amount of Raised Creatures (0 = no cap)|ClampMin=0|ToolTip="Don't raise more creatures than specified. Enter zero if there is no cap necessary. This works ONLY if a specific creature is raised (aka Necromancy; Elrath's Infinite Mercy won't use the cap).">;
var(Necromancy) protected bool                              mModifyWithStat<DisplayName=Add Hero Stat "Necromancy" to Raise Rate>;
var(Necromancy) protected array<H7BaseAbility>			    mAbilityRestrictions<DisplayName=Will not raise creatures who have any of these abilities>;
var(Necromancy) protected array<H7Creature>                 mOmittedCreatures<DisplayName=Will not raise any of these specific creatures>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster;
	local H7AdventureController advCntl;
	local H7CombatArmy attackerArmy, defenderArmy, combatWinArmy;
	local H7AdventureArmy adventureArmy, winningArmy;
	local int healthPool, numOfRaisedCreatures, rate;
	local array<H7CreatureStack> stacks;
	local H7CreatureStack stack;
	local H7BaseCreatureStack raisedStack;
	local bool attackerWon, casterCheck;


	if( effect.GetTrigger().mTriggerType != ON_BATTLE_WON ) 
	{
		return;
	}


	caster = effect.GetSource().GetInitiator();
	if( mUseCreatureArchetype )
	{
		casterCheck = effect.CasterConditionCheck( caster );
		if( !casterCheck )
		{
			return;
		}
	}
	advCntl = class'H7AdventureController'.static.GetInstance();
	if( advCntl == none )
	{
		;
		return;
	}

	if( H7EditorHero( caster ) == none )
	{
		// Elrath's Infinite Mercy: caster is the town building -> hero is just the buff owner
		caster = effect.GetSource().GetOwner();
		if( caster == none || H7EditorHero( caster ) == none )
		{
			;
			return;
		}
	}

	if(mModifyWithStat)
	{
		rate = mRaisePercentage + H7EditorHero( caster ).GetModifiedStatByID( STAT_NECROMANCY );
	}
	else
	{
		rate = mRaisePercentage;
	}

	healthPool = 0; // just in case...

	attackerWon = advCntl.GetArmyAttackerCombat().WonBattle();
	winningArmy = advCntl.GetArmyAttackerCombat().WonBattle() ? advCntl.GetArmyAttacker() : advCntl.GetArmyDefender();

	attackerArmy = advCntl.GetArmyAttackerCombat();
	defenderArmy = advCntl.GetArmyDefenderCombat();

	if( attackerArmy.IsForQuickCombat() )
	{
		// quick combat
		if(mUseCreatureArchetype)
		{
			// necromancy
			adventureArmy = advCntl.GetArmyAttacker();
			GetHealthPoolSumForArmy( attackerArmy.GetBaseCreatureStacks(), adventureArmy.GetBaseCreatureStacks(), (adventureArmy == winningArmy), healthPool);

			adventureArmy = advCntl.GetArmyDefender();
			GetHealthPoolSumForArmy( defenderArmy.GetBaseCreatureStacks(), adventureArmy.GetBaseCreatureStacks(), (adventureArmy == winningArmy), healthPool);
		}
		else
		{
			// elrath's infinite mercy (-> tear of asha + haven)
			combatWinArmy = advCntl.GetArmyAttackerCombat().WonBattle() ? attackerArmy : defenderArmy;
			GetHealthPoolSumForArmy( combatWinArmy.GetBaseCreatureStacks(), winningArmy.GetBaseCreatureStacks(), true, healthPool, true, rate );
		}
	}
	else
	{
		if(mUseCreatureArchetype)
		{
			// necromancy
			stacks = attackerArmy.GetCreatureStacks();
			foreach stacks( stack )
			{
				if( CanRaise( stack.GetCreature() ) )
				{
					healthPool += ( stack.GetInitialStackSize() - stack.GetStackSize() ) * stack.GetCreature().GetHitPointsBase();
				}
			}

			stacks = defenderArmy.GetCreatureStacks();
			foreach stacks( stack )
			{
				if( CanRaise( stack.GetCreature() ) )
				{
					healthPool += ( stack.GetInitialStackSize() - stack.GetStackSize() ) * stack.GetCreature().GetHitPointsBase();
				}
			}
		}
		else
		{
			// elrath
			combatWinArmy = attackerWon ? attackerArmy : defenderArmy;
			stacks = combatWinArmy.GetCreatureStacks();
			foreach stacks( stack )
			{
				if( CanRaise( stack.GetCreature() ) )
				{
					healthPool = stack.GetInitialStackSize() - stack.GetStackSize();
					numOfRaisedCreatures = healthPool * rate / 100;
					// check if cap is speficied
					if( mMaxResCreatures > 0 )
					{
						numOfRaisedCreatures = Min( numOfRaisedCreatures, mMaxResCreatures );
					}
					//stack.SetStackSize( stack.GetStackSize() + numOfRaisedCreatures); // doesn't work anymore because the trigger was moved
					stack.GetBaseCreatureStack().SetStackSize( stack.GetStackSize() + numOfRaisedCreatures );
				}
			}
		}
	}


	// necromancy: add new stack of mRaisedCreature creatures (elrath don't need that)
	if(mUseCreatureArchetype)
	{
		numOfRaisedCreatures = healthPool * rate / 100 / mRaisedCreature.GetHitPointsBase();

		if( mMaxResCreatures > 0 )
		{
			numOfRaisedCreatures = Min( numOfRaisedCreatures, mMaxResCreatures );
		}

		if(numOfRaisedCreatures > 0)
		{
			raisedStack = new class'H7BaseCreatureStack';
			raisedStack.SetStackType( mRaisedCreature );
			raisedStack.SetStackSize( numOfRaisedCreatures );

			winningArmy.AddStackToMergePool(raisedStack,"MERGE_POOL_NECROMANCY");
		}
	}
}

// sum up health of all lost creatures that fit the description and store it in healthPool
function GetHealthPoolSumForArmy(array<H7BaseCreatureStack> currentArmy, array<H7BaseCreatureStack> advArmy, bool isWinningArmy, out int healthPool, optional bool isElrath=false, optional int rate)
{
	local int baseCreatureStackIndex, numOfRaisedCreatures;
	local H7BaseCreatureStack baseCreatureStack, originalBaseCreatureStack;
	local H7Creature creatureType;
	
	for(baseCreatureStackIndex = 0; baseCreatureStackIndex < currentArmy.Length; ++baseCreatureStackIndex)
	{
		baseCreatureStack = currentArmy[baseCreatureStackIndex];
		originalBaseCreatureStack = advArmy[baseCreatureStackIndex];

		if(baseCreatureStack != none && originalBaseCreatureStack != none)
		{
			creatureType = originalBaseCreatureStack.GetStackType();
			if( CanRaise( creatureType ) )
			{
				if(isElrath)
				{
					healthPool = originalBaseCreatureStack.GetStackSize() - baseCreatureStack.GetStackSize();
					numOfRaisedCreatures = healthPool * rate / 100;
					baseCreatureStack.SetStackSize( baseCreatureStack.GetStackSize() + numOfRaisedCreatures );
				}
				else
				{
					if( !isWinningArmy )
					{
						healthPool += originalBaseCreatureStack.GetStackSize() * creatureType.GetHitPointsBase();
					}
					else
					{
						healthPool += ( originalBaseCreatureStack.GetStackSize() - baseCreatureStack.GetStackSize() ) * creatureType.GetHitPointsBase();
					}
				}
			}
			
		}
		else if(baseCreatureStack != none && originalBaseCreatureStack == none)
		{
			creatureType = baseCreatureStack.GetStackType();
			if( CanRaise( creatureType ) )
			{
				if(isElrath)
				{
					healthPool = baseCreatureStack.GetStartingSize();
					numOfRaisedCreatures = healthPool * rate / 100;
					baseCreatureStack.SetStackSize( baseCreatureStack.GetStackSize() + numOfRaisedCreatures );
				}
				else
				{
					healthPool += baseCreatureStack.GetStartingSize() * creatureType.GetHitPointsBase();
				}
			}
		}
	}
}

function bool CanRaise( H7Creature creature )
{
	local H7BaseAbility ability, creatureAbility;
	local array<H7BaseAbility> abilities;
	local H7Creature omittedCreature;

	abilities = creature.GetAbilities();

	foreach mAbilityRestrictions( ability )
	{
		foreach abilities( creatureAbility )
		{
			if( ability.IsEqual( creatureAbility ) )
			{
				return false;
			}
		}
	}
	foreach mOmittedCreatures( omittedCreature )
	{
		if( omittedCreature == creature )
		{
			return false;
		}
	}
	return true;
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_NECROMANCY_EFFECT","H7TooltipReplacement");
}

function string GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercentAbs(mRaisePercentage/100.f);
}
// .val1
function string GetValue(int nr)
{
	return class'H7GameUtility'.static.FloatToString(mMaxResCreatures);
}

