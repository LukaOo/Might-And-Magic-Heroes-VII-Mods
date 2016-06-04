//=============================================================================
// H7EffectSpecialConditionalStatMod
//
// - I want to die
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialConditionalStatMod extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var(StatModifier) H7MeModifiesStat mStatMod<DisplayName="Stat Modifier">;

var H7Effect mSourceEffect;

function Initialize( H7Effect effect ) 
{
	mSourceEffect = effect;
}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7CombatResult currentResult;
	local array<H7IEffectTargetable> myTargets;
	local array<H7IEffectTargetable> allTargets;
	local H7ICaster attacker;
	local H7IEffectTargetable attackerAsTarget;
	local int i;
	local ConditionalStatMod cond;
	local bool didDisplayForAttacker;
	local H7ICaster casterOriginal;

	if(isSimulated)
		currentResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult();
	else
		currentResult = class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetCurrentResult();
	allTargets = currentResult.GetDefenders();
	attacker = currentResult.GetAttacker();
	casterOriginal = attacker.GetOriginal();
	attackerAsTarget = H7IEffectTargetable( casterOriginal );
	effect.GetTargets( myTargets );

	cond.StatMod = mStatMod; 
	cond.Source = effect.GetSource();

	cond.Target = attackerAsTarget;

	if( myTargets.Find( attackerAsTarget ) != INDEX_NONE )
	{
		currentResult.AddConditionalStatMod( cond );
		currentResult.UpdateDamageRange();
		if( !isSimulated ) DisplaySignsAndFeedback(cond);
		didDisplayForAttacker = true;
	}

	for(i=0; i<allTargets.Length; ++i)
	{
		if( myTargets.Find( allTargets[i] ) != INDEX_NONE )
		{
			cond.Target = allTargets[i];
			currentResult.AddConditionalStatMod( cond );
			currentResult.UpdateDamageRange(i);
			if( H7Unit( cond.Target ) != none )
			{
				H7Unit( cond.Target ).ClearStatCache();
			}
			if( didDisplayForAttacker && attackerAsTarget == allTargets[i] ) continue;
			if( !isSimulated ) DisplaySignsAndFeedback(cond);
		}
	}
}

function DisplaySignsAndFeedback( ConditionalStatMod c )
{
	local EOperationType displayOperation;

	// Signs & Feedback (copied from H7EffectOnStats)
	displayOperation = c.StatMod.mCombineOperation == OP_TYPE_SET ? OP_TYPE_SET : OP_TYPE_ADD;

	// log
	if(H7Unit(c.Target) != none && c.Source.IsDisplayed())
	{
		H7Unit(c.Target).DisplayStatChangeLog(c.StatMod.mStat,displayOperation,c.StatMod.mModifierValue,c.Source);
	}
	// floats
	if(H7Unit(c.Target) != none && c.StatMod.mShowFloatingText ) // mShowFloatingText overwrites GetSource().IsDisplayed() 
	{
		H7Unit(c.Target).DisplayStatChangeFloat(c.StatMod.mStat,displayOperation,c.StatMod.mModifierValue,c.Source);
	}
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_ADD_COUNTER","H7TooltipReplacement");
}

function Texture2D GetIcon()
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mStatIconsInText.GetStatIcon(mStatMod.mStat);
}

// needed due to miscommunication and the texts are already done
function string GetValue(int nr)
{
	local Texture2D tmpIcon;

	if(nr == 1)
	{
		return GetDefaultString();
	}
	else if(nr == 2) 
	{
		tmpIcon = GetIcon();
		return "<img src='img://" $ Pathname(tmpIcon) $ "' width='#TT_POINT#' height='#TT_POINT#'>";
	}
	else
	{
		return "?";
	}
}

function string GetDefaultString()
{
	local H7EffectOnStats statEffect;
	local H7StatEffect statStruct;

	statEffect = new class'H7EffectOnStats';
	statStruct.mStatMod = mStatMod;
	statEffect.InitSpecific(statStruct,mSourceEffect.GetSource(),false);
	
	return statEffect.GetDefaultString();
}

