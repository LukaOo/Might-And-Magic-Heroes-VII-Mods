class H7SeqAct_SetArmyFXVisibility extends SequenceAction;

var(Properties) bool mIsVisible<DisplayName="Set Visibility To">;

/** Use a specific army */
var protected H7AdventureArmy mTargetArmy;

event Activated()
{
	if( mIsVisible )
	{
		mTargetArmy.GetHero().GetHeroFX().ShowDecalFX();
		if( mTargetArmy.GetFlag() != none )
		{
			mTargetArmy.GetFlag().SetHidden( false );
		}
	}
	else
	{
		mTargetArmy.GetHero().GetHeroFX().HideDecalFX();
		if( mTargetArmy.GetFlag() != none )
		{
			mTargetArmy.GetFlag().SetHidden( true );
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

