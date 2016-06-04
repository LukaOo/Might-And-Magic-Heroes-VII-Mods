/*=============================================================================
 * H7SeqAct_ModBuildingBuffs
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_ModBuildingBuffs extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

// The player that should get buffs modified
var(Properties) savegame H7VisitableSite mTargetSite<DisplayName="Target site">;
// Adding or removing buffs
var(Properties) EBuffsMod mBuffOperation<DisplayName="Buff operation">;
// The buffs that are added or removed
var(Properties) archetype array<H7BaseBuff> mBuffs<DisplayName="Buffs">;

function Activated()
{
	local array<H7BaseBuff> buffs;
	local H7BaseBuff buff;
	local H7AdventureMapGridController adventureMapGridController;

	adventureMapGridController = class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid();
	
	if( mTargetSite != none  )
	{
		if ( mBuffOperation == EBM_ADD )
		{
			foreach mBuffs( buff )
			{
				mTargetSite.GetBuffManager().AddBuff( buff, adventureMapGridController );
			}
		}
		else
		{
			if( mBuffOperation == EBM_REMOVE_ALL )
			{
				mTargetSite.GetBuffManager().GetActiveBuffs(buffs);
			}
			else 
			{
				buffs = mBuffs;
			}

			foreach buffs( buff )
			{
				mTargetSite.GetBuffManager().RemoveBuff( buff );
			}
		}
	}
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7VisitableSite'))
	{
		if(mTargetSite == randomObject)
		{
			mTargetSite = H7VisitableSite(hatchedObject);
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

