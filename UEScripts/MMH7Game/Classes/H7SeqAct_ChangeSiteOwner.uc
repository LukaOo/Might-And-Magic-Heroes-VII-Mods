//=============================================================================
// Changing owner of AoCSites
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqAct_ChangeSiteOwner extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

/** The town or fort that gets a new owner */
var(Properties) protected savegame H7AreaOfControlSite mTargetSite<DisplayName="Area of Control site">;
/** Affected players */
var(Properties) protected EPlayerTargetType mPlayerTargetType<DisplayName="Of players">;
/** Affect specific player */
var(Properties) protected EPlayerNumber mTargetPlayer<DisplayName="Target player"|EditCondition=mUseTargetPlayer>;
/** Restriction to area */
var(Properties) protected H7Area mTargetArea<DisplayName="In target area">;
/** The new player that owns the town or fort */
var(Properties) protected EPlayerNumber mNewOwner<DisplayName="New owner">;

var bool mUseTargetPlayer;

function Activated()
{
	local array<H7AreaOfControlSite> sites;
	local H7AreaOfControlSite site;

	sites = GetTargetSites();

	foreach sites(site)
	{
		site.SetSiteOwner(mNewOwner);
	}
	class'H7AdventureController'.static.GetInstance().UpdateHUD();
}

function array<H7AreaOfControlSite> GetTargetSites() 
{
	local array<H7AreaOfControlSite> sites;
	local array<H7VisitableSite> tempSites;
	local array<H7AdventureMapGridController> grids;
	local H7AdventureMapGridController grid;
	local H7VisitableSite tempSite;
	local H7AreaOfControlSite aocSite;
	local int i;

	if(mTargetSite != none)
	{
		sites.AddItem(mTargetSite);
	}
	else
	{
		grids = class'H7AdventureGridManager'.static.GetInstance().GetAllGrids();
		
		foreach grids(grid)
		{
			tempSites = grid.GetVisitableSites();

			foreach tempSites(tempSite)
			{
				aocSite = H7AreaOfControlSite(tempSite);
				if(aocSite == none)
				{
					continue;
				}

				if(mTargetArea == none || mTargetArea.IsInside(aocSite.Location))
				{
					sites.AddItem(aocSite);
				}
			}
		}
	}

	// check player restriction
	if(mPlayerTargetType == PLAYER_TYPE_ONE)
	{
		for(i = sites.Length -1; i >= 0; i--)
		{
			if(sites[i].GetPlayerNumber() != mTargetPlayer)
			{
				sites.Remove(i, 1);
			}
		}
	}
	// TODO: PLAYER_TYPE_ALL_ENEMIES & PLAYER_TYPE_ALL_ALLIES once we have an ally system

	return sites;
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(randomObject.IsA('H7AreaOfControlSite'))
	{
		if(mTargetSite == randomObject)
		{
			mTargetSite = H7AreaOfControlSite(hatchedObject);
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

