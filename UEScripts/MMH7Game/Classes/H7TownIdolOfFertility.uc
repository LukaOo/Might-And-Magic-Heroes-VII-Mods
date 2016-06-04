//=============================================================================
// H7TownIdolOfFertility
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TownIdolOfFertility extends H7TownBuilding
	savegame;

var protected savegame bool mActive;


function bool CanBeActivated() { return mActive; }
function      ResetTimer()     { mActive = true; }

function InitTownBuilding( H7Town town )
{
	super.InitTownBuilding( town);
	mActive = true;
}

function AddGrowthToPool( H7TownDwelling dwelling )
{
	local int basedwelling,grwothbonus;
	
	// safety first
	if( dwelling.GetCreaturePool().CreatureTier == CTIER_CHAMPION )
	{
		mActive = false;
		return;
	}
	// creature Pool = creature epool + income wekkly
	
	basedwelling = dwelling.GetCreatureIncome();
	grwothbonus = mTown.GetGrowthBonus( dwelling.GetCreaturePool().Creature );
	dwelling.CarryReserveForUpgrade( basedwelling + grwothbonus );
	mActive = false;
}
