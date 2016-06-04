/*=============================================================================
 * H7SeqCon_HasVisitedTownBuilding
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqCon_HasVisitedSite extends H7SeqCon_Player
	implements(H7IConditionable)
	native;

var(Properties) protected array<H7VisitableSite> mTargetSites<DisplayName="Required Sites">;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local array<H7SiteVisitData> visitData;
	local H7SiteVisitData currentVisitData;
	local array<H7VisitableSite> visitedSites;
	local H7VisitableSite site;

	visitData = class'H7ScriptingController'.static.GetInstance().GetVisitedSites();

	foreach visitData(currentVisitData)
	{
		if(currentVisitData.PlayerID == player.GetPlayerNumber())
		{
			visitedSites.AddItem(currentVisitData.Site);
		}
	}

	foreach mTargetSites(site)
	{
		if (visitedSites.Find(site) == INDEX_NONE)
		{
			return false;
		}
	}

	if(class'H7TreasureHuntCntl'.static.GetInstance().GetTreasureHuntPopup().IsVisible())
	{
		return false; // don't trigger now, check back later
	}

	return true;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("SITES_VISITED_PROGRESS","H7ConditionProgress");
}

function bool HasProgress() { return mTargetSites.Length > 0; }

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local array<H7SiteVisitData> visitData;
	local H7SiteVisitData currentVisitData;
	local array<H7VisitableSite> visitedSites;
	local H7VisitableSite site;
	local H7Player dasPlayer;

	dasPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();

	visitData = class'H7ScriptingController'.static.GetInstance().GetVisitedSites();

	foreach visitData(currentVisitData)
	{
		if(currentVisitData.PlayerID == dasPlayer.GetPlayerNumber())
		{
			visitedSites.AddItem(currentVisitData.Site);
		}
	}

	foreach mTargetSites(site)
	{
		if (visitedSites.Find(site) != INDEX_NONE)
		{
			progress.CurrentProgress += 1;
		}
	}

	progress.MaximumProgress = mTargetSites.Length;
	progress.ProgressText = Repl(Repl(GetProgress(), "%current", int(progress.CurrentProgress)), "%maximum", int(progress.MaximumProgress));
	progresses.AddItem( progress );

	return progresses;
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

