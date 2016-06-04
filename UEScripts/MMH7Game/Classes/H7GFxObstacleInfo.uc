//=============================================================================
// H7GFxObstacleInfo
//
// Wrapper for UnitInfo.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxObstacleInfo extends H7GFxUIContainer;

var protected H7CombatObstacleObject mOldDisplayedObstacle;

function Update( )
{
	ActionscriptVoid("Update");
}

function H7CombatObstacleObject GetCurrentlyDisplayedObstacle()
{
	return mOldDisplayedObstacle;
}

function SetObstacleInfo(H7CombatObstacleObject target)
{	
	local GFxObject data;
	
	data = CreateObject("Object");
	data.SetBool("IsWall", target.IsA('H7CombatMapWall') );
	data.SetInt("CurrentHP", target.GetHitpoints());
	data.SetInt("MaxHP", target.GetMaxHitpoints());

	SetObject( "mData" , data);
	Update();
	mOldDisplayedObstacle = target;

	ListenTo(target);
}

function ListenUpdate(H7IGUIListenable obstacle)
{
	SetObstacleInfo(H7CombatObstacleObject(obstacle));
}

function Hide()
{
	;
	SetVisibleSave(false);
	mOldDisplayedObstacle = none;
	class'H7ListeningManager'.static.GetInstance().RemoveListener(self);
}
