//=============================================================================
// H7GFxBattleMapResultWindow
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxResultWindow extends GFxClikWidget;


function Update( )
{
	ActionscriptVoid("Update");
}


function SetData(string msg, string msgXp, H7CombatArmy winnerCntl)
{
	local GFxObject data;
	data = CreateObject("Object");
	CreateScreenObject( msg, msgXp, winnerCntl, data );
	SetObject( "mData" , data);
	Update();
}


function CreateScreenObject( string msg, string msgXp, H7CombatArmy ActiveArmyCntl, out GFxObject object)
{
	local array<H7CreatureStack> stacks;
	local H7CombatArmy opponent;
	local GFxObject lostCreatures, killedCreatures;
	local int i;

	/// basic localization + Result Text 
	object.setString( "ResultScreenTitle", class'H7Loca'.static.LocalizeSave("RESULT_SCREEN_TITLE","H7CombatPopUp")) ;
	object.SetString( "ResultMsg", msg );
	object.SetString( "ResultMsgXP", msgXp );
	object.setString( "ResultScreenLostCreatureLabel", class'H7Loca'.static.LocalizeSave("RESULT_SCREEN_LOST_CREATURES","H7CombatPopUp")) ;
	object.setString( "ResultScreenKilledCreatureLabel", class'H7Loca'.static.LocalizeSave("RESULT_SCREEN_KILLED_CREATURES","H7CombatPopUp")) ;
	object.setString( "ResultScreenButton", class'H7Loca'.static.LocalizeSave("RESULT_SCREEN_BUTTON_OK","H7CombatPopUp")) ;

	opponent = class'H7CombatController'.static.GetInstance().GetOpponentArmy( ActiveArmyCntl );

	lostCreatures = CreateArray();
	killedCreatures = CreateArray();

	// Lost creatures 
	i=0;
    if(ActiveArmyCntl != none)   
    {
    	ActiveArmyCntl.GetKilledCreatureStacks( stacks );
    }
	KilledStack( stacks, lostCreatures, i );
	
	if(ActiveArmyCntl != none)
	{
		ActiveArmyCntl.GetSurvivingCreatureStacks( stacks);
	}
	LostStack( stacks, lostCreatures, i );

	object.SetObject( "LostCreatures", lostCreatures );

	// Killed creatures
	stacks.Remove(0, stacks.length);
	i=0;
	
	opponent.GetKilledCreatureStacks( stacks );
	KilledStack( stacks, killedCreatures, i );
	opponent.GetSurvivingCreatureStacks( stacks );
	LostStack( stacks, killedCreatures, i );
	
	object.SetObject( "KilledCreatures", killedCreatures );

}

function KilledStack(  array<H7CreatureStack> stacks ,out GFxObject creatures, optional out int i ) 
{
	local H7CreatureStack stack;
	local GFxObject tempObj; 

	foreach stacks(stack)
	{
		tempObj = CreateObject( "Object" );
		tempObj.SetString( "UnitType", stack.GetCreature().GetName() );
		tempObj.SetString( "IconPath", stack.GetCreature().GetFlashIconPath()  );
		tempObj.SetInt( "StackSize", stack.GetInitialStackSize() );
		creatures.SetElementObject(i, tempObj);
		i++;
	}
}

function LostStack( array<H7CreatureStack> stacks ,out GFxObject creatures, optional int i ) 
{
	local H7CreatureStack stack;
	local GFxObject tempObj; 

	foreach stacks( stack )
	{
		if( !stack.IsDead() && stack.CountDeadCreatures() > 0 ) 
		{
			tempObj = CreateObject( "Object" );
			tempObj.SetString( "UnitType", stack.GetCreature().GetName() );
			tempObj.SetString( "IconPath", stack.GetCreature().GetFlashIconPath()  );
			tempObj.SetInt( "StackSize", stack.CountDeadCreatures() );
			creatures.SetElementObject(i, tempObj);
			i++;
		}
	}
}
