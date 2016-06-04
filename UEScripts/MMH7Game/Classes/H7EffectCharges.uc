//=============================================================================
// H7EffectCharges
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectCharges extends H7Effect
	native(Tussi);

var() protected H7ChargeEffect    mData;

function H7ChargeEffect             GetData()                 { return mData; }
event bool                       ShowInTooltip()           { return !mData.mDontShowInTooltip; }

event InitSpecific(H7ChargeEffect data, H7EffectContainer source, optional bool registerEffect=true)
{
	local H7EffectProperties properties;
	properties.mRank = data.mRank;
	properties.mGroup = data.mGroup;
	properties.mTags = data.mTags;
	properties.mTarget = data.mTarget;
	properties.mTrigger = data.mTrigger;
	properties.mFX = data.mFX;
	properties.mConditions = data.mConditions;

	super.InitEffect(properties, source,registerEffect);
	mData = data;

	SetData();
}

function SetData()
{
	if( mSourceOfEffect.IsA( 'H7WarfareAbility' ) ) 
	{
		H7WarfareAbility( mSourceOfEffect ).SetCurrentCharges( mData.mChargeCounter );
		H7WarfareAbility( mSourceOfEffect ).SetNumCharges( mData.mChargeCounter );
	}
	else if ( mSourceOfEffect.IsA( 'H7CreatureAbility' ))
	{
		H7CreatureAbility( mSourceOfEffect ).SetCurrentCharges(mData.mChargeCounter );
		H7CreatureAbility( mSourceOfEffect ).SetNumCharges( mData.mChargeCounter );
	}
}

protected event Execute(optional bool isSimulated = false)
{

	if( mData.mConditions.mConditionAbility )
	{
		if( !CasterConditionCheck( GetSource().GetCaster() ) )
		{
			return;
		}
	}
	
	// Only for WarfareUnits and CreatureAbilities 
	if( mSourceOfEffect.IsA('H7WarfareAbility') )
	{
		 if(mData.mOp == OP_TYPE_SET )
		 {
		 	H7WarfareAbility(mSourceOfEffect).SetCurrentCharges( mData.mChargeCounter );
		 }
	}
	else if (mSourceOfEffect.IsA('H7CreatureAbility') ) 
	{
		if(mData.mOp == OP_TYPE_SET )
		 {
		 	H7CreatureAbility(mSourceOfEffect).SetCurrentCharges( mData.mChargeCounter );
		 }
	
	}
}
