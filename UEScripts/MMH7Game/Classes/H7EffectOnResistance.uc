//=============================================================================
// H7EffectOnResistance
//
// - if an effect does somthing with resistance / immunuity / vulnerability, it's this type
// - uses data from the H7ResistanceEffect-struct
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectOnResistance extends H7Effect
	native(Tussi);

var() protected H7ResistanceStruct mResMod;
var() protected H7ResistanceEffect mData;

function H7ResistanceEffect GetData() { return mData; }

event bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }

event InitSpecific(H7ResistanceEffect data,H7EffectContainer source,optional bool registerEffect=true)
{
	local ESpellTag tag;
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	properties.mConditions = data.mConditions;

	InitEffect(properties, source,registerEffect);
	mData = data;
	mResMod = mData.mResistance;

	foreach mResMod.tags(tag)
	{
		if(tag == TAG_MAX) class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(mSourceOfEffect.GetDebugName() @ "has a corrupted tag in a resistance effect",MD_QA_LOG);;
	}	
}

// not called at, all resistance effects are persistant
protected event Execute(optional bool isSimulated = false)
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local ESpellTag tag;
	local String tagList;

	if( isSimulated ) return;

	foreach mData.mResistance.tags(tag)
	{
		tagList = tagList @ "," $ tag;
	}

	GetTargets( targets );

	if( GetSource().IsAbility() && H7BaseAbility( GetSource() ).IsPassive() ) 
	{
		H7BaseAbility( GetSource() ).DoParticleFXCaster( GetSource().GetCasterOriginal() );
	}

	if( GetData().mFX.mUseCasterPosition ) 
	{
		GetSource().GetCasterOriginal().GetEffectManager().AddToFXQueue( mData.mFX, self );
	}
	else
	{
		foreach targets(target)
		{
			;
		
			target.GetEffectManager().AddToFXQueue( mData.mFX, self );
		}
	}

}

native function bool Matches(EAbilitySchool attackSchool,array<ESpellTag> tags);

function String GetTagList()
{
	local ESpellTag tag;
	local String list,comma;
	local int i;

	foreach mResMod.tags(tag,i)
	{
		comma = (i>0)? ", " : "";
		list = list $ comma $ class'H7Loca'.static.LocalizeSave(String(tag),"H7Abilities");
	}
	return list;
}
