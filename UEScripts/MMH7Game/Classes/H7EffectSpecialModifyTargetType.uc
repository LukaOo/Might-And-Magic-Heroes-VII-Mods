//=============================================================================
// H7EffectSpecialModifyTargetType
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialModifyTargetType extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var() protected EAbilityTarget mNewTargetType;
var() protected IntPoint mAreaOfEffectSize;
var() protected array<IntPoint> mAreaOfEffectShape;
var() protected H7ConeStruct mTargetCone;
var() protected bool mIsAreaFilled<DisplayName=Filled?>;


function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7BaseAbility ability;

	ability = H7BaseAbility( effect.GetSource() );

	if( ability != none )
	{
		if( effect.GetConditons().mConditionAbility && !effect.CasterConditionCheck( ability.GetCasterOriginal() ) )
		{
			return;
		}
		ability.OverrideTargetType( mNewTargetType );
		if( mNewTargetType == NO_TARGET )
		{
		}
		else if( mNewTargetType == TARGET_SINGLE )
		{
		}
		else if( mNewTargetType == TARGET_AREA || mNewTargetType == TARGET_ELLIPSE )
		{
			ability.SetTargetArea( mAreaOfEffectSize );
			ability.SetAreaFilled( mIsAreaFilled );
		}
		else if( mNewTargetType == TARGET_LINE )
		{
		}
		else if( mNewTargetType == TARGET_DOUBLE_LINE )
		{
		}
		else if( mNewTargetType == TARGET_CONE || mNewTargetType == TARGET_SWEEP )
		{
			ability.SetTargetCone( mTargetCone );
		}
		else if( mNewTargetType == TARGET_CUSTOM_SHAPE )
		{
			ability.SetShape( mAreaOfEffectShape );
		}
		else if( mNewTargetType == TARGET_AOC )
		{
		}
		else if( mNewTargetType == TARGET_SUNBURST )
		{
		}
		else if( mNewTargetType == TARGET_TSUNAMI )
		{
		}
	}
	
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_MOD_TARGET_TYPE_EFFECT","H7TooltipReplacement");
}
