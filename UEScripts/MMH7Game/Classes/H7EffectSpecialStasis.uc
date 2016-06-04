//=============================================================================
// H7EffectSpecialStasis
//
// - puts the target into stasis
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialStasis extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);

var(Stasis) bool mSetStasis<DisplayName=Set (true) or remove (false) stasis effect>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;
	local H7CreatureStack stack;
	local H7BaseBuff sourceBuff, buff;

	sourceBuff = H7BaseBuff( effect.GetSource() );

	if( isSimulated ) { return; }


	effect.GetTargets( targets );

	foreach targets( target )
	{
		stack = H7CreatureStack( target );
		if( stack != none )
		{
			if( mSetStasis )
			{
				if( sourceBuff != none )
				{
					stack.AddStasisBuff( sourceBuff );
				}
			}
			else
			{
				if( sourceBuff != none && stack.HasStasisBuff( sourceBuff ) )
				{
					// we want to remove ourselves!
					stack.GetBuffManager().RemoveBuff( sourceBuff, sourceBuff.GetCaster() );
					stack.RemoveStasisBuff( sourceBuff );
				}
				else
				{
					buff = stack.GetStasisBuff();
					if( buff != none )
					{
						stack.GetBuffManager().RemoveBuff( buff, buff.GetCaster() );
						stack.RemoveFirstStasisBuff();
					}
				}
			}
		}
	}
}

function String GetTooltipReplacement()
{
	if( mSetStasis )
	{
		return class'H7Loca'.static.LocalizeSave("TTR_SET_STASIS","H7TooltipReplacement");
	}
	else
	{
		return class'H7Loca'.static.LocalizeSave("TTR_RELEASE_STASIS","H7TooltipReplacement");
	}
}

