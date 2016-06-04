/*============================================================================
* H7SeqAct_RemoveCaravans
*
* Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
*=============================================================================*/
class H7SeqAct_RemoveCaravans extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

/** Player owning the caravans. */
var(Properties) protected EPlayerNumber mPlayer<DisplayName="Player">;
/** Routes from which caravans should get removed. */
var(Properties) protected savegame array<H7CaravanRoute> mCaravanRoutes<DisplayName="Caravan routes">;
/** Remove all caravans from the Player. */
var(Properties) protected bool mAllCaravans<DisplayName="Remove all">;

event Activated()
{
	local array<H7CaravanArmy> caravans;
	local H7CaravanArmy caravan;
	local H7CaravanRoute route;

	caravans = class'H7AdventureController'.static.GetInstance().GetCurrentCaravanArmies();

	foreach caravans(caravan)
	{
		if(caravan.GetPlayer().GetPlayerNumber() == mPlayer)
		{
			if(mAllCaravans)
			{
				RemoveCaravan(caravan);
			}
			else
			{
				foreach mCaravanRoutes(route)
				{
					if(caravan.GetSourceLord() == route.SourceLord && caravan.GetTargetLord() == route.TargetLord)
					{
						RemoveCaravan(caravan);
					}
				}
			}
		}
	}
}

function RemoveCaravan(H7CaravanArmy caravan)
{
	caravan.StartRemoveEffect();
	caravan.RemoveArmyAfterCombat();
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	local int i;

	if(hatchedObject.IsA('H7AreaOfControlSiteLord'))
	{
		for(i = 0; i < mCaravanRoutes.Length; ++i)
		{
			if(mCaravanRoutes[i].SourceLord == randomObject)
			{
				mCaravanRoutes[i].SourceLord = H7AreaOfControlSiteLord(hatchedObject);
			}

			if(mCaravanRoutes[i].TargetLord == randomObject)
			{
				mCaravanRoutes[i].TargetLord = H7AreaOfControlSiteLord(hatchedObject);
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

