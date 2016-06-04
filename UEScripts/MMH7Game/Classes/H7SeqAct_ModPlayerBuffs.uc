/*=============================================================================
 * H7SeqAct_ModPlayerBuffs
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_ModPlayerBuffs extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

// The player that should get buffs modified
var(Properties) EPlayerNumber mTargetPlayer<DisplayName="Player">;
// Adding or removing buffs
var(Properties) EBuffsMod mBuffOperation<DisplayName="Buff operation">;
// The buffs that are added or removed
var(Properties) archetype array<H7BaseBuff> mBuffs<DisplayName="Buffs">;

var protected H7AdventureController mAdventureController;


function Activated()
{
	local H7Player thePlayer;
	local H7BaseBuff buff;
	local array<H7BaseBuff> buffs;
	local H7AdventureMapGridController adventureMapGridController;
	
	if(mAdventureController == none)
	{
		mAdventureController = class'H7AdventureController'.static.GetInstance();
	}

	adventureMapGridController = class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid();

	thePlayer = mAdventureController.GetPlayerByNumber(mTargetPlayer);

	if(thePlayer != none)
	{
		if ( mBuffOperation == EBM_ADD )
		{
			foreach mBuffs( buff )
			{
				thePlayer.GetBuffManager().AddBuff( buff, adventureMapGridController );
			}
		}
		else
		{
			if( mBuffOperation == EBM_REMOVE_ALL )
			{
				thePlayer.GetBuffManager().GetActiveBuffs(buffs);
			}
			else 
			{
				buffs = mBuffs;
			}

			foreach buffs( buff )
			{
				thePlayer.GetBuffManager().RemoveBuff( buff );
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 2;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

