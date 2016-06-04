//=============================================================================
// H7AiAdventureSensors
//=============================================================================
// collection of sensors used by combat map ai. Its sole purpose is to create
// all the sensors to be used by utility objects and parameter object for
// calling GetValue<n>()
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiAdventureSensors extends H7AiSensorBase
	dependson(H7StructsAndEnumsNative)
	dependsOn(H7AiSensorInputConst);


var protected array<H7AiSensorBase>     mSensors;
var protected H7AiSensorInputConst      mConsts;
var protected EAiSensorIConst           mConstSelect[2];
var protected int                       mConstIter[2];
var protected int                       mConstLength[2];
var protected H7AiSensorParam           mParam[2];

function H7AiSensorBase         GetSensor( EAiAdventureSensor sensor )  { return mSensors[sensor]; }
function H7AiSensorParam        GetParam0()                             { return mParam[0]; }
function H7AiSensorParam        GetParam1()                             { return mParam[1]; }
function H7AiSensorInputConst   GetSensorIConsts()                      { return mConsts; }

function UpdateConsts(bool isTown)
{
	mConsts.Reset(false,isTown);
}

function ResetConsts()
{
	mConsts.ResetConsts();
}

/** Used to clean up AI calculations mid-thought */
function ResetCalc()
{
	mConsts.ResetCalc();
}

function float CallSensor( EAiAdventureSensor sensor )
{
	switch(sensor)
	{
		// 0 parameter types ...
		case AAS_GameProgress:
		case AAS_GameDayOfWeek:
			return GetSensor(sensor).GetValue0();
			break;
		// 1 parameter types ...
		case AAS_ArmyStrength:
		case AAS_HeroCount:
		case AAS_PoolGarrison:
		case AAS_TownDistance:
		case AAS_TownBuilding:
		case AAS_ResourceStockpile:
		case AAS_TownArmyCount:
		case AAS_HireHeroCount:
		case AAS_TownThreat:
			return GetSensor(sensor).GetValue1(GetParam0());
		// 2 parameter types ...
		case AAS_ArmyStrengthCombined:
		case AAS_ArmyStrengthCombinedNoHero:
		case AAS_ArmyStrengthCombinedReverse:
		case AAS_ArmyStrengthCombinedGlobal:
		case AAS_ArmyStrengthCombinedGlobalReverse:
		case AAS_DistanceToTarget:
		case AAS_TargetInterest:
		case AAS_PlayerArmiesCompare:
		case AAS_SiteAvailable:
		case AAS_InstantRecall:
		case AAS_TeleportInterest:
		case AAS_TradeResource:
		case AAS_CanUpgrade:
		case AAS_UpgradeStrength:
		case AAS_TownDefense:
		case AAS_TargetThreat:
		case AAS_TargetCutoffRange:
			return GetSensor(sensor).GetValue2(GetParam0(),GetParam1());
	};
	return 0.0f;
}

function CallBegin( EAiSensorIConst sic0, EAiSensorIConst sic1 )
{
	local int i;

	mConstSelect[0] = sic0;
	mConstIter[0] = 0;
	mConstSelect[1] = sic1;
	mConstIter[1] = 0;

	for(i=0;i<2;i++)
	{
		switch(mConstSelect[i])
		{
			case SIC_DISABLED:
				mConstLength[i] = 0;
				break;
			case SIC_GRIDCELLS:
				mConstLength[i] = mConsts.GetCellNumAdv();
				break;
			case SIC_CREATURESTACKS:
				mConstLength[i] = mConsts.GetCreatureStackNum();
				break;
			case SIC_OPPONENT_CREATURESTACKS:
				mConstLength[i] = mConsts.GetOppCreatureStackNum();
				break;
			case SIC_OPPONENT_ARMIES:
				mConstLength[i] = mConsts.GetArmyNumAdv();
				break;
			case SIC_TOWN_ARMIES:
				mConstLength[i] = mConsts.GetTownArmyNumAdv();
				break;
			case SIC_VISSITES:
				mConstLength[i] = mConsts.GetVisSiteNum();
				// this is a hack to only run over the top 15 targets if there are more. they have already been sorted by distance
				if(mConstLength[i]>15) mConstLength[i]=15;
				break;
			case SIC_OTHER_PLAYERS:
				mConstLength[i] = mConsts.GetOtherPlayersNum();
				break;
			case SIC_THIS_BUILDINGS:
				mConstLength[i] = mConsts.GetBuildingsNum();
				break;
			case SIC_TOWNS:
				mConstLength[i] = mConsts.GetTownsNum();
				break;
			case SIC_TELEPORTERS:
				mConstLength[i] = mConsts.GetTeleportersNum();
				break;
			case SIC_RESOURCES:
				mConstLength[i] = mConsts.GetResourcesNum();
				break;
			default:
				mConstLength[i] = 1;
		}
	}

	if( (mConstLength[0]+mConstLength[1]) == 0 ) mConstLength[0]=1;

//	`LOG_AI("Const.CallBegin" @ mConstSelect[0] @ mConstLength[0] @ mConstSelect[1] @ mConstLength[1] );
}

function bool CallNext()
{
	local int p;

	if( mConstIter[0] >= mConstLength[0] && mConstIter[1] >= mConstLength[1] ) return false;

	// set params
	for(p=0;p<2;p++)
	{
		if( mConstSelect[p] != SIC_DISABLED )
		{
			if( mConstIter[p] < mConstLength[p] ) 
			{
				switch(mConstSelect[p])
				{
					case SIC_GRIDCELLS: 
						mParam[p].SetAMapCell(mConsts.GetCellAdv(mConstIter[p]));
						break;
					case SIC_THIS_CREATURESTACK:
						mParam[p].SetUnit(mConsts.GetThisCreatureStack());
						break;
					case SIC_CREATURESTACKS:
						mParam[p].SetUnit(mConsts.GetCreatureStack(mConstIter[p]));
						break;
					case SIC_OPPONENT_CREATURESTACKS:
						mParam[p].SetUnit(mConsts.GetOppCreatureStack(mConstIter[p]));
						break;
					case SIC_THIS_HERO:
						mParam[p].SetUnit(mConsts.GetHeroAdv());
						break;
					case SIC_OPPONENT_HERO:
						mParam[p].SetUnit(mConsts.GetOppHero());
						break;
					case SIC_THIS_ARMY:
						mParam[p].SetAdventureArmy(mConsts.GetArmyAdv());
						break;
					case SIC_TARGET_ARMY:
						mParam[p].SetAdventureArmy(mConsts.GetTargetArmyAdv());
						break;
					case SIC_TARGET_VISSITE:
						mParam[p].SetVisSite(mConsts.GetTargetVisSite());
						break;
					case SIC_OPPONENT_ARMIES:
						mParam[p].SetAdventureArmy(mConsts.GetOtherArmyAdv(mConstIter[p]));
						break;
					case SIC_TOWN_ARMIES:
						mParam[p].SetAdventureArmy(mConsts.GetTownArmyAdv(mConstIter[p]));
						break;
					case SIC_SOURCE_GRIDCELL:
						mParam[p].SetAMapCell(mConsts.GetSourceCellAdv());
						break;
					case SIC_TARGET_GRIDCELL:
						mParam[p].SetAMapCell(mConsts.GetTargetCellAdv());
						break;
					case SIC_TARGET_CREATURESTACK:
						mParam[p].SetUnit(mConsts.GetTargetCreatureStack());
						break;
					case SIC_VISSITES:
						mParam[p].SetVisSite(mConsts.GetVisSite(mConstIter[p]));
						break;
					case SIC_THIS_PLAYER:
						mParam[p].SetPlayer(mConsts.GetPlayer());
						break;
					case SIC_OTHER_PLAYERS:
						mParam[p].SetPlayer(mConsts.GetOtherPlayer(mConstIter[p]));
						break;
					case SIC_THIS_BUILDINGS:
						mParam[p].SetBuilding(mConsts.GetBuilding(mConstIter[p]));
						break;
					case SIC_TOWNS:
						mParam[p].SetTown(mConsts.GetTown(mConstIter[p]));
						break;
					case SIC_TELEPORTERS:
						mParam[p].SetTeleporter(mConsts.GetTeleporter(mConstIter[p]));
						break;
					case SIC_TARGET_TELEPORTER:
						mParam[p].SetTeleporter(mConsts.GetTargetTeleporter());
						break;
					case SIC_RESOURCES:
						mParam[p].SetResource(mConsts.GetResource(mConstIter[p]));
						break;
					case SIC_TARGET_RESOURCE:
						mParam[p].SetResource(mConsts.GetTargetResource());
						break;
					case SIC_TARGET_BASECREATURESTACK:
						mParam[p].SetBaseCreatureStack(mConsts.GetTargetBaseCreatureStack());
						break;
					case SIC_MAKESHIFT_ARMY:
						mParam[p].SetAdventureArmy(mConsts.GetMakeshiftArmyAdv());
						break;
				}
			}
		}
	}	

	mConstIter[1]++;
	if( mConstIter[1] >= mConstLength[1] )
	{
		mConstIter[1]=0;
		mConstIter[0]++;
		if( mConstIter[0] > mConstLength[0] )
		{
			// end of list
			return false;
		}
	}
	return true;
}

function Setup()
{
	mSensors.InsertItem(AAS_ArmyStrength,new class 'H7AiSensorArmyStrength');
	mSensors.InsertItem(AAS_ArmyStrengthCombined,new class 'H7AiSensorArmyStrengthCombined');
	mSensors.InsertItem(AAS_DistanceToTarget,new class 'H7AiSensorDistanceToTarget');
	mSensors.InsertItem(AAS_TargetInterest,new class 'H7AiSensorTargetInterest');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedNoHero,new class 'H7AiSensorArmyStrengthCombinedNoHero');
	mSensors.InsertItem(AAS_HeroCount,new class 'H7AiSensorHeroCount');
	mSensors.InsertItem(AAS_GameProgress,new class 'H7AiSensorGameProgress');
	mSensors.InsertItem(AAS_TownDistance,new class 'H7AiSensorTownDistance');
	mSensors.InsertItem(AAS_PlayerArmiesCompare,new class 'H7AiSensorPlayerArmiesCompare');
	mSensors.InsertItem(AAS_PoolGarrison,new class 'H7AiSensorPoolGarrison');
	mSensors.InsertItem(AAS_TownBuilding,new class 'H7AiSensorTownBuilding');
	mSensors.InsertItem(AAS_GameDayOfWeek,new class 'H7AiSensorGameDayOfWeek');
	mSensors.InsertItem(AAS_TradeResource,new class 'H7AiSensorTradeResource');
	mSensors.InsertItem(AAS_ResourceStockpile,new class 'H7AiSensorResourceStockpile');
	mSensors.InsertItem(AAS_TownDefense,new class 'H7AiSensorTownDefense');
	mSensors.InsertItem(AAS_TownArmyCount,new class 'H7AiSensorTownArmyCount');
	mSensors.InsertItem(AAS_HireHeroCount,new class 'H7AiSensorHireHeroCount');
	mSensors.InsertItem(AAS_SiteAvailable,new class 'H7AiSensorSiteAvailable');
	mSensors.InsertItem(AAS_InstantRecall,new class 'H7AiSensorRecall');
	mSensors.InsertItem(AAS_TeleportInterest,new class 'H7AiSensorTeleportInterest');
	mSensors.InsertItem(AAS_CanUpgrade,new class 'H7AiSensorCanUpgrade');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedReverse,new class 'H7AiSensorArmyStrengthCombinedReverse');
	mSensors.InsertItem(AAS_UpgradeStrength,new class 'H7AiSensorUpgradeStrength');
	mSensors.InsertItem(AAS_TownThreat,new class 'H7AiSensorTownThreat');
	mSensors.InsertItem(AAS_TargetThreat,new class 'H7AiSensorAdvTargetThreat');
	mSensors.InsertItem(AAS_TargetCutoffRange, new class 'H7AiSensorTargetCutoffRange');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedGlobal,new class 'H7AiSensorArmyStrengthCombinedGlobal');
	mSensors.InsertItem(AAS_ArmyStrengthCombinedGlobalReverse,new class 'H7AiSensorArmyStrengthCombinedGlobalReverse');

	mConsts = new class 'H7AiSensorInputConst';
	mParam[0] = new class 'H7AiSensorParam';
	mParam[1] = new class 'H7AiSensorParam';

	mConstSelect[0] = SIC_DISABLED;
	mConstLength[0] = 0;
	mConstSelect[1] = SIC_DISABLED;
	mConstLength[1] = 0;
}
