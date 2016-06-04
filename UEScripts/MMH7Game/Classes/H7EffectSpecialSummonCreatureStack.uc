//=============================================================================
// H7EffectSpecialSummonCreatureStack
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialSummonCreatureStack extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var(Properties) bool mIsCopy<DisplayName=Copy a target creature?>;
var(Properties) array<H7Creature> mCreaturePool<DisplayName=Creature list from which to summon>;
var(Properties) H7SpellScaling mScalingStruct<DisplayName=Spell Scaling Modifier>;
var(Properties) H7BaseBuff mBuff<DisplayName=Buff to apply to summoned stack>;
var(Properties) bool mPlayDeathAnim<DisplayName=Creature Plays Death Animation When Killed|ToolTip=Uncheck if Creature should skip its Dying Animation>;
var(Properties) float mFakeDyingDelay<DisplayName=Remove Creature After Seconds|ToolTip=Instead of Playing the Death Animation, wait Amount of Seconds and Then Remove The Summoned Creature|EditCondition=!mPlayDeathAnim|ClampMin=0.0>;
var(Properties) ECellSize mCellHighlight<DisplayName=Ability Highlight Size>;

var protected H7CombatMapGridController mCombatMapGridController;

var private float mPercent;
var private int mStacksize;
var private string mFormular;
var private H7ICaster mCaster;

function SetCaster( H7ICaster caster )
{
	mCaster = caster;
}

function bool DoesCopyStack() { return mIsCopy; }

function Initialize( H7Effect effect ) 
{
	mStacksize = SpellScaling( effect.GetSource().GetInitiator() );
	// 50 -> 1/2
	// 100 -> 1
	// 200 -> 2
	mPercent = mStacksize / 100.0;
	mCaster = effect.GetSource().GetInitiator();
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CombatHero hero;
	local H7ICaster caster;
	local H7CreatureStack stack;
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7CombatMapGridController gridCntl;
	local H7InitiativeQueue iniQueue;
	local H7CombatController cmbtCntl;
	local IntPoint dimensions;
	local IntPoint point;
	local array<IntPoint> points;
	local bool summonSuccess;
	local H7Creature creatureToSummon;
	local H7EventContainerStruct conti;
	local int myStackSize;

	mCaster = effect.GetSource().GetInitiator();

	effect.GetTargets( targets );
	
	// no targets, no copy
	if(targets.Length == 0)
	{
		mCombatMapGridController = none;
		mCaster = none;
		return;
	}

	effect.GetSource().SetTargets( targets );

	if( isSimulated )
	{
		if(!mIsCopy)
		{
			// since the damn spell can't highlight shit, we do it ourselves
			if( mCombatMapGridController == none )
			{
				mCombatMapGridController = class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatGridController();
			}

			ShowCellPreview( targets );
		}
		
		mCombatMapGridController = none;
		mCaster = none;
		return;
	}

	gridCntl = class'H7CombatMapGridController'.static.GetInstance();
	cmbtCntl = class'H7CombatController'.static.GetInstance();
	iniQueue = cmbtCntl.GetInitiativeQueue();
	caster = effect.GetSource().GetCasterOriginal();
	hero = H7CombatHero( caster );

	foreach targets( target )
	{
		if( mIsCopy )
		{
			if( H7CreatureStack( target ) != none )
			{
				creatureToSummon = H7CreatureStack( target ).GetBaseCreatureStack().GetStackType();
				myStackSize = H7CreatureStack( target ).GetStackSize() * mPercent;
				myStackSize = Max ( myStackSize, 1 ); // min stack size is 1
				//stack size is in percentage of the original in the case of a copy
				stack = SpawnStack( creatureToSummon, myStackSize, hero );
				dimensions.X = gridCntl.GetGridSizeX();

				dimensions.Y = gridCntl.GetGridSizeY();
				class'H7Math'.static.GetSpiralIntPointsByDimension( points, target.GetGridPosition(), dimensions );
				foreach points( point )
				{
					if( gridCntl.CanPlaceCreature( point, stack ) &&
						!( point.X < 2 || point.X > gridCntl.GetGridSizeX() ||
						point.Y < 0 || point.Y > gridCntl.GetGridSizeY() ) )
					{
						stack.SetGridPosition( point );
						summonSuccess= true;
						break; 
					}
				}
			}
			else
			{
				;
			}

		}
		else
		{
			if( mCreaturePool.Length == 0 )
			{
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("no summonable creatures assigned to"@effect.GetSource(),MD_QA_LOG);;
				;
				mCombatMapGridController = none;
				mCaster = none;
				return;
			}
			else if( mCreaturePool.Length == 1 )
			{
				creatureToSummon = mCreaturePool[ 0 ];
			}
			else
			{
				creatureToSummon = mCreaturePool[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mCreaturePool.Length ) ];
			}
			dimensions.X = creatureToSummon.GetBaseSize() == CELLSIZE_2x2 ? 2 : 1;
			dimensions.Y = dimensions.X;
			mStacksize = SpellScaling( effect.GetSource().GetInitiator() );
			myStackSize = Max(mStacksize, 1);
			stack = SpawnStack( creatureToSummon, myStackSize, hero );
			point = H7CombatMapCell( target ).GetCellPosition();
			if( H7CombatMapCell( target ) != none && gridCntl.CanPlaceCreature( point, stack ) &&
				!( point.X < 2 || point.X > gridCntl.GetGridSizeX() || point.Y < 0 || point.Y > gridCntl.GetGridSizeY() ) )
			{
				stack.SetGridPosition( point );
				summonSuccess = true;
				break;
			}
		}
	}

	if( summonSuccess )
	{
		hero.GetCombatArmy().AddCreatureStackOnMap( stack );
		stack.Show( true );
		stack.SetIsSummoned( true );
		stack.SetSkipDeathAnim(!mPlayDeathAnim);
		stack.SetFakeDeathDelay(mFakeDyingDelay);
		if( mBuff != none )
		{
			stack.GetBuffManager().AddBuff( mBuff, stack, effect.GetSource() );
		}
		iniQueue.AddUnitToIndex( stack, 1 );
		stack.TriggerEvents( ON_COMBAT_START, false ); // dude we're having a combat here

		// mr hero, you summoned a guy!
		conti.Action = ACTION_ABILITY;
		conti.EffectContainer = effect.GetSource();
		conti.ActionSchool = effect.GetSource().GetSchool();
		conti.Targetable = stack;

		// reuse targets array because we won't use it anymore anyway
		targets.Length = 0;
		targets.AddItem(stack);
		conti.TargetableTargets = targets;
		// in case hero wants to add some buff to the dude
		hero.TriggerEvents(ON_SUMMON_ENTER_COMBAT, false, conti);
		hero.ClearStatCache();
		// in case someone else wants to add some buff to the dude
		cmbtCntl.RaiseEventOnArmiesStacks( ON_SUMMON_ENTER_COMBAT, hero.GetCombatArmy(), false, conti );
		cmbtCntl.GetArmyAttacker().UpdatedAlliesAndEnemies();
		cmbtCntl.GetArmyDefender().UpdatedAlliesAndEnemies();
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().ResetInitiativeInfo();
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().SetInitiativeInfo();
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateStackSize( stack );
	}
	else
	{
		stack.Destroy();
	}
	mCombatMapGridController = none;
	mCaster = none;

}

function private ShowCellPreview( array<H7IEffectTargetable> cells )
{
	local int i;
	local H7CombatMapCell cell;
	local array<H7CombatMapCell> allCells;

	// target is apparently not TARGET_AREA, so get the rest of the cells from the grid controller
	if( cells.Length == 1 )
	{
		cell = H7CombatMapCell( cells[0] );
		cell.GetCellsHitByCellSize( mCellHighlight, allCells, true );
	}
	else
	{
		for( i = 0; i < cells.Length; ++i )
			if( H7CombatMapCell( cells[i] ) != none )
				allCells.AddItem( H7CombatMapCell( cells[i] ) );
	}
	
	// highlight those dudes
	mCombatMapGridController.SetAbilityHighlightCells( allCells );

	// force update to show the correct cell highlights
	mCombatMapGridController.ForceGridStateUpdate();
}


function H7CreatureStack SpawnStack( H7Creature creature, int size, H7CombatHero hero )
{
	local H7CreatureStack creatureStack;
	local H7BaseCreatureStack baseStack;
	
	baseStack = new class'H7BaseCreatureStack';
	baseStack.SetStackSize( size );
	baseStack.SetStackType( creature );

	creatureStack = hero.GetCombatArmy().SpawnStack(baseStack);
	creatureStack.ApplyHeroArmyBonusBuff();
	creatureStack.StartFadeIn();

	return creatureStack;
}

protected function int SpellScaling( H7ICaster caster )
{
	local int value;

	if( caster == none || caster.GetEntityType() != UNIT_HERO )
	{
		// we are in magic guild
		mFormular = class'H7GameUtility'.static.FloatToString(mScalingStruct.mIntercept) $ "+" $ class'H7GameUtility'.static.FloatToString(mScalingStruct.mSlope) @ "*" @ class'H7Loca'.static.LocalizeSave("STAT_MAGIC","H7Abilities"); 
		return -1;
	}

	value = ( mScalingStruct.mSlope * caster.GetMagic() ) + mScalingStruct.mIntercept;
    
	if( mScalingStruct.mUseCap )
	{
		value = FMax( mScalingStruct.mMinCap, FMax( value, mScalingStruct.mMaxCap ) );
	}

	return value;
}

function string GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercentAbs(mPercent);
}

function string GetValue(int nr)
{
	if(mStacksize > -1)
	{
		mStacksize = SpellScaling( mCaster );
		return class'H7GameUtility'.static.FloatToString(mStacksize);
	}
	else if(mFormular != "")
		return mFormular;
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_SUMMON_EFFECT","H7TooltipReplacement");
}

