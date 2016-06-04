//=============================================================================
// H7AiUtilityDamagePotentialReduction
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityDamagePotentialReduction extends H7AiUtilityCombiner;

var H7AiUtilityMeleeCreatureDamage      mInUCreatureDamage;
var H7AiUtilityMeleeCasualityCount      mInUCasualityCount;

var H7AiUtilityMeleeCreatureDamageRet   mInUCreatureDamageRet;
var H7AiUtilityMeleeCasualityCountRet   mInUCasualityCountRet;

/// overrides ...
function UpdateInput()
{
	local array<float> casualityCount;
	local array<float> creatureDamage;
	local array<float> casualityCountRet;
	local array<float> creatureDamageRet;
	local float drp, drpRet, atkDamageRel;
	local int k;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mInUCreatureDamage == None ) { mInUCreatureDamage = new class 'H7AiUtilityMeleeCreatureDamage'; }
    if( mInUCasualityCount == None ) { mInUCasualityCount = new class 'H7AiUtilityMeleeCasualityCount'; }
	if( mInUCreatureDamageRet == None ) { mInUCreatureDamageRet = new class 'H7AiUtilityMeleeCreatureDamageRet'; }
    if( mInUCasualityCountRet == None ) { mInUCasualityCountRet = new class 'H7AiUtilityMeleeCasualityCountRet'; }

	mInValues.Remove(0,mInValues.Length);

	mInUCasualityCount.UpdateInput();
	mInUCasualityCount.UpdateOutput();
	casualityCount = mInUCasualityCount.GetOutValues();

	mInUCreatureDamage.UpdateInput();
	mInUCreatureDamage.UpdateOutput();
	creatureDamage = mInUCreatureDamage.GetOutValues();

	mInUCasualityCountRet.UpdateInput();
	mInUCasualityCountRet.UpdateOutput();
	casualityCountRet = mInUCasualityCountRet.GetOutValues();

	mInUCreatureDamageRet.UpdateInput();
	mInUCreatureDamageRet.UpdateOutput();
	creatureDamageRet = mInUCreatureDamageRet.GetOutValues();

	if( casualityCount.Length >= 1 && casualityCount.Length == creatureDamage.Length )
	{
		for(k=0;k<casualityCount.Length;k++) 
		{
			drp = casualityCount[k] * creatureDamage[k];
			drpRet = casualityCountRet[k] * creatureDamageRet[k];
			if(drp>0.0f && drpRet>0.0f)
			{
				atkDamageRel = drpRet / drp;
				if(atkDamageRel>0.0f) 
				{
					mInValues.AddItem(atkDamageRel);
				}
			}
		}
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

