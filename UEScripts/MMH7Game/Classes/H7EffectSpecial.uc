//=============================================================================
// H7EffectSpecial
//
// - if an effect does something crazy, it's this type
// - uses data from the H7SpecialEffect-struct
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecial extends H7Effect
	native(Tussi);

var() protected H7SpecialEffect         mData;
var() protected H7IEffectDelegate       mFunctionProvider;
var() protected Bool                    mDoesDamage<DisplayName=Special Function does Damage>;


function H7IEffectDelegate GetFunctionProvider() { return mFunctionProvider; }
event bool ShowInTooltip()                       { return !mData.mDontShowInTooltip; }
function bool DoesDamage()                       { return mDoesDamage; }
function      RemoveEvent( bool value )          { mRemovedDuringExecution = value; }

event InitSpecific(H7SpecialEffect data,H7EffectContainer source,optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	properties.mConditions = data.mConditions;

	if( source == none || source.GetInitiator() == none)
	{
		;
		ScriptTrace();
	}
	
	InitEffect(properties, source,registerEffect);
	mData = data;
	mDoesDamage = data.mDoesDamage;

	if( data.mFunctionProvider != none )
	{
		// add here the link 
		if(mSourceOfEffect.GetEffectFunctionProvider( data.mFunctionProvider, mFunctionProvider ) )
		{
			// link the mFunctionProvider to the existing instance
		}
		else
		{
			mFunctionProvider = new data.mFunctionProvider.class( data.mFunctionProvider );
			mFunctionProvider.Initialize(self); // only once 
		}
	}
	else
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("no function provider for effect"@self@"in"@mSourceOfEffect.GetName()@mSourceOfEffect,MD_QA_LOG);;
	}
}

function H7SpecialEffect GetData()
{
	return mData;
}

protected event Execute(optional bool isSimulated = false)
{
	local array<H7IEffectTargetable> targets;

	if( mSourceOfEffect == none )
	{
		;
	}

	if( (mEffectTarget == TARGET_TARGET || mEffectTarget == TARGET_DEFAULT ) && ( mSourceOfEffect != none && ( H7BaseAbility( mSourceOfEffect ) != none || H7BaseBuff( mSourceOfEffect ) != none )  && !H7BaseAbility(  mSourceOfEffect ).IsTsunami() ))
	{
		UnpackContainer();
	}

	if( mFunctionProvider != none &&
		( mSourceOfEffect != none && mSourceOfEffect.GetInitiator() != none && RankCheck( mSourceOfEffect.GetInitiator() ) ) )
	{
		if( !isSimulated && mEffectTags.Length > 0 )
		{
			ClearCachedTargets();
			GetTargets( targets, false );
			if( targets.Length == 0 ) return; // don't execute function provider if there are no valid targets
		}
		mFunctionProvider.Execute(Self, GetEventContainer(), isSimulated );
	}
}
