//=============================================================================
// H7EffectSpecialDeathMarch
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialDeathMarch extends Object
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);



var() float mStackReduction<DisplayName=Reduce Stacksize by this % value>;

var transient int mDeathCount;

function Initialize( H7Effect effect ) 
{

}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7Player targetPlayer;

	mDeathCount = 0;

	targetPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();

	StarvingTowns( targetPlayer );
	StarvingForts( targetPlayer );
	StarvingArmies( targetPlayer.GetArmies() );
	
	SendNotes();
}

function SendNotes()
{
	local H7Message message;
	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mStarvation.CreateMessageBasedOnMe();
	message.AddRepl("%amount",string(mDeathCount));
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mStarvation.CreateMessageBasedOnMe();
	message.destination = MD_LOG;
	message.AddRepl("%amount",string(mDeathCount));
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
}

function StarvingGarrison( H7Player targetPlayer )
{
	// not Implemented Yet
}

function StarvingArmies( array<H7AdventureArmy> armies )
{
	local int i;
	
	for( i=0;i<armies.Length;++i)
	{
		StarvingArmy( armies[i] );
	}
}

function StarvingForts( H7Player targetPlayer ) 
{
	local array<H7Fort> forts;
	local int i;
	forts = targetPlayer.GetForts();

	for( i=0;i<forts.Length;++i)
	{
		StarvingArmy( forts[i].GetCaravanArmy() );
		StarvingStacks ( forts[i].GetLocalStacks() );
	}
	
}

function StarvingTowns( H7Player targetPlayer ) 
{
	local array<H7Town> towns;
	local int i;
	towns = targetPlayer.GetTowns();

	for( i=0;i<towns.Length;++i)
	{
		StarvingArmy( towns[i].GetCaravanArmy() );
		StarvingStacks ( towns[i].GetLocalStacks() );
	}

}

function StarvingArmy( H7AdventureArmy army )
{
	
	local int i,loss;
	local array<H7BaseCreatureStack> stacks;
	local array<H7CreatureCounter> creatureLosses;
	local H7CreatureCounter creatureLoss;
	
	stacks = army.GetBaseCreatureStacks();
	
	for ( i=0;i< stacks.Length;++i)
	{
		if( stacks[i] == none ) 
			continue;

		loss = FCeil( stacks[i].GetStackSize() * mStackReduction );
		stacks[i].SetStackSize( stacks[i].GetStackSize() - loss );
		
		if( stacks[i].GetStackSize() <= 0 ) 
		{
			stacks[i] = none;
		}

		mDeathCount += loss;
		creatureLoss.Counter = loss;
		creatureLoss.Creature = stacks[i].GetStackType();
		creatureLoss.PlayerID = army.GetPlayerNumber();
		creatureLoss.EnemyID = PN_PLAYER_NONE;
		creatureLosses.AddItem(creatureLoss);
	}

	class'H7ScriptingController'.static.GetInstance().UpdateAfterCombatLosses(creatureLosses, army.GetPlayerNumber());

	army.SetBaseCreatureStacks( stacks );
}

function StarvingStacks( array<H7BaseCreatureStack> stacks )
{
	local int i,loss;

	for ( i=0;i< stacks.Length;++i)
	{
		if( stacks[i] == none ) 
			continue;

		loss = FCeil( stacks[i].GetStackSize() * mStackReduction );
		stacks[i].SetStackSize( stacks[i].GetStackSize() - loss );
		
		if( stacks[i].GetStackSize() <= 0 ) 
		{
			stacks[i] = none;
		}

		mDeathCount += loss;
	}
}

function String GetTooltipReplacement() 
{
	local String loss;
	loss = class'H7Effect'.static.GetHumanReadablePercent(mStackReduction);
	return Repl(class'H7Loca'.static.LocalizeSave("TTR_DEATH_MARCH","H7TooltipReplacement"),"%percent","<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ loss $ "</font>");
}

function string GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercentAbs(mStackReduction);
}
