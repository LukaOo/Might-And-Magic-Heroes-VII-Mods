//=============================================================================
// H7EffectSpecialStackRegeneration
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialStackRegeneration extends Object 
	implements(H7IEffectDelegate) 
	hidecategories( Object )
	native(Tussi);

var(Properties) protected int mRegenPercentage<DisplayName=Amount of dead creatures resurrected in %|ClampMin=0|ClampMax=100>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7CreatureStack stack;
	local int resurrectedAmount;

	effect.GetTargets( targets );

	foreach targets( target )
	{
		stack = H7CreatureStack( target );
		if( stack != none )
		{
			resurrectedAmount = ( float( stack.GetInitialStackSize() - stack.GetStackSize() ) * float( mRegenPercentage ) / 100.0f );
			if( resurrectedAmount > 0 )
			{
				stack.SetStackSize( FMin( stack.GetStackSize() + resurrectedAmount, stack.GetInitialStackSize() ) );
				class'H7FCTController'.static.GetInstance().startFCT(FCT_RESURRECTION, stack.GetMeshCenter(), none, "+"$resurrectedAmount, MakeColor(255,255,255));
			}
		}
	}
}


function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_ETERNAL_SERVITUDE_EFFECT","H7TooltipReplacement");
}

function string GetDefaultString()
{
	return class'H7Effect'.static.GetHumanReadablePercentAbs(float(mRegenPercentage)/100.f);
}

