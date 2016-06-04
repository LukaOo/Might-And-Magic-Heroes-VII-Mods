//=============================================================================
// H7EffectSpecialKillCreaturesOnHeroArmy
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialKillCreaturesOnHeroArmy extends Object
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var() float mStackReduction<DisplayName=Reduce Stacksize by this % value>;

var transient int mDeathCount;

function Initialize( H7Effect effect )  { }

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7EditorHero hero;

	mDeathCount = 0;

	if( isSimulated )
	{
		return;
	}

	effect.GetTargets( targets );

	foreach targets( target )
	{
		if ( H7EditorHero( target ) == none ) 
			continue;
	
		hero = H7EditorHero ( target );
		StarvingArmy( hero.GetArmy() );
		SendNotes(hero);
	}
}


function SendNotes(H7EditorHero hero)
{
	local H7Message message;
	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mCyclopsBuff.CreateMessageBasedOnMe();
	message.AddRepl("%amount",string(mDeathCount));
	message.AddRepl("%hero", hero.GetName());
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mCyclopsBuff.CreateMessageBasedOnMe();
	message.destination = MD_LOG;
	message.AddRepl("%amount",string(mDeathCount));
	message.AddRepl("%hero", hero.GetName());
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
}



function StarvingArmy( H7EditorArmy army )
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
	return Repl(class'H7Loca'.static.LocalizeSave("TTR_CYCLOPS_ATTACK_BUFF","H7TooltipReplacement"),"%percent","<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ loss $ "</font>");
}

function string GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercentAbs(mStackReduction);
}
