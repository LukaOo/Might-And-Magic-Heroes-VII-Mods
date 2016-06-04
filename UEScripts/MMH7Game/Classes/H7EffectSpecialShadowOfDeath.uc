//=============================================================================
// H7EffectSpecialShadowOfDeath
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialShadowOfDeath extends Object
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);




var() float mPercentage<DisplayName=Imprison % StackSize |ClampMin=0|ClampMax=1>; // 0 -> 1

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{   
	local int i;
	local array<H7IEffectTargetable> targets;
	
	if( isSimulated )
		return;
	
	effect.GetTargets( targets );

	for( i=0;i<targets.Length;++i)
	{
		if( H7CreatureStack( targets[i] ) != none ) 
		{
			Imprison( H7CreatureStack( targets[i] ) );
		}
	}
}


function Imprison( H7CreatureStack stack  ) 
{
	local int imprisonSize;
	local H7BaseCreatureStack imprisonStack;
	local H7AdventureController advCntl;
	local H7AdventureArmy enemyArmy;
	local string text;

	imprisonSize =  float(stack.GetStackSize() ) * mPercentage;
	stack.SetInitialStackSize( stack.GetInitialStackSize() - imprisonSize);
	stack.SetStackSize( stack.GetStackSize() - imprisonSize);
	
	// All imprisoned
	if( stack.GetInitialStackSize() <= 0  && stack.GetStackSize() <= 0 ) 
	{
		stack.RemoveCreature();
	} // die in case of there creatures left to resurrect 
	else if ( stack.GetInitialStackSize() != stack.GetStackSize() && stack.GetStackSize() <= 0 )
	{
		stack.Kill();
	}

	if( imprisonSize > 0 ) 
	{

		text = GetFloatingText(imprisonSize);
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, stack.GetLocation() , stack.GetPlayer(), text, MakeColor(255,255,0,255));
		text = GetMessageLog();
		class'H7MessageSystem'.static.GetInstance().AddReplForNextMessage("%size", string(imprisonSize));
		class'H7MessageSystem'.static.GetInstance().AddReplForNextMessage("%name", stack.GetName() );
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(text , MD_LOG);


		advCntl = class'H7AdventureController'.static.GetInstance();
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateStackSize( stack );	
		imprisonStack = new class'H7BaseCreatureStack';
		imprisonStack.SetStackType( stack.GetCreature() );
		imprisonStack.SetStackSize( imprisonSize );
		
		enemyArmy = advCntl.GetAdvArmyOnCombatByPlayer( stack.GetPlayer() );
		enemyArmy.AddStackToMergePool(imprisonStack,"MERGE_POOL_SHADOW_OF_DEATH");
	}
}



function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_SHADOW_OF_DEATH","H7TooltipReplacement");
}

function String GetFloatingText(int size)
{
	return  Repl(class'H7Loca'.static.LocalizeSave("TT_ABILITY_SHAOW_OF_DEATH_FCT","H7Abilities"),"%size",size);
}

function String GetMessageLog()
{
	return class'H7Loca'.static.LocalizeSave("TT_ABILITY_SHAOW_OF_DEATH_LOG","H7Abilities");
}

function String GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercentAbs(mPercentage);
}

