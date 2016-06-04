//=============================================================================
// H7CombatUnitInfoCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CombatUnitInfoCntl extends H7FlashMovieCntl;

var protected H7GFxUnitInfo mUnitInfoAttacker;
var protected H7GFxUnitInfo mUnitInfoDefender;
var protected H7GFxObstacleInfo mObstacleInfo;

function	H7GFxUnitInfo		GetUnitInfoAttacker() { return mUnitinfoAttacker; }
function	H7GFxUnitInfo		GetUnitInfoDefender() { return mUnitinfoDefender; }
function	H7GFxObstacleInfo		GetObstacleInfo() { return mObstacleInfo; }

function bool Initialize() 
{
	;
	// Start playing the movie
    //Super.Start();
	// Initialize all objects in the movie
    //AdvanceDebug(0);

	mUnitInfoAttacker = H7GFxUnitInfo(H7CombatHud(GetHUD()).GetCombatHudCntl().GetRoot().GetObject("aUnitInfoAttacker", class'H7GFxUnitInfo'));
	mUnitInfoDefender = H7GFxUnitInfo(H7CombatHud(GetHUD()).GetCombatHudCntl().GetRoot().GetObject("aUnitInfoDefender", class'H7GFxUnitInfo'));
	mObstacleInfo     = H7GFxObstacleInfo(H7CombatHud(GetHUD()).GetCombatHudCntl().GetRoot().GetObject("aObstacleInfo", class'H7GFxObstacleInfo')); 
	mUnitInfoAttacker.SetVisibleSave(false);
	mUnitInfoDefender.SetVisibleSave(false);
	mObstacleInfo.SetVisibleSave(false);

	//Super.Initialize();
	return true;
}

function ShowUnitInfo(H7Unit unit)
{
	if(class'H7CombatController'.static.GetInstance().IsLocalPlayerSpectator()) return;
	
	;
	//check if left or rightn UnitInfoWindow should be displayed
	if( class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult() != none )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult().ClearConditionalStatMods();
	}
    if( unit.GetCombatArmy() == class'H7CombatController'.static.GetInstance().GetArmyAttacker() )
	{
		if( mUnitInfoAttacker.GetCurrentlyDisplayedUnit() == unit )
		{
			mUnitInfoAttacker.Hide();
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_CLOSE_SOUND");
		}
		else
		{
			mUnitInfoAttacker.SetUnitInfo( unit );
			mUnitInfoAttacker.SetVisibleSave(true);
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_OPEN_SOUND");
		}
	}
	else
	{
		if( mUnitInfoDefender.GetCurrentlyDisplayedUnit() == unit )
		{
			mUnitInfoDefender.Hide();
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_CLOSE_SOUND");
		}
		else
		{
			mUnitInfoDefender.SetUnitInfo( unit );
			mUnitInfoDefender.SetVisibleSave(true);
			class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("POP_UP_OPEN_SOUND");
		}
	}
}

function ShowObstacleInfo(H7CombatObstacleObject obstacle)
{
	if(mObstacleInfo.GetCurrentlyDisplayedObstacle() == obstacle)
	{
		mObstacleInfo.Hide();
	}
	else
	{
		mObstacleInfo.SetObstacleInfo(obstacle);
		mObstacleInfo.SetVisibleSave(true);
	}
}

function UpdateHeroMana(H7EditorHero hero, int currentMana, int maxMana)
{
	//check if left or rightn UnitInfoWindow should be updated
	if(hero.GetCombatArmy() == class'H7CombatController'.static.GetInstance().GetArmyAttacker())
	{
		mUnitInfoAttacker.UpdateHeroMana(currentMana, maxMana);
	}
	else
	{
		mUnitInfoDefender.UpdateHeroMana(currentMana, maxMana);
	}
}

function CloseAll()
{
	mUnitInfoAttacker.Hide();
	mUnitInfoDefender.Hide();
	mObstacleInfo.Hide();
}

