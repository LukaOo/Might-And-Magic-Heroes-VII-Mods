//=============================================================================
// H7SeqCon_SitesVisited
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_SitesVisited extends H7SeqCon_Player
	implements(H7IConditionable)
	native
	savegame;

/** The armies that should be defeated */
var(Properties) protected array<H7VisitableSite> mSites<DisplayName="Sites to visit">;

var protected savegame int mPreviousVisitedSites;

function protected bool IsConditionFulfilledForPlayer( H7Player player )
{
	local int visitedSites;

	// Condition already fulfilled
	if(mPreviousVisitedSites == mSites.Length)
	{
		return true;
	}

	visitedSites = GetVisitedSitesCount( player );

	if(visitedSites > mPreviousVisitedSites)
	{
		ConditionProgressed();
		mPreviousVisitedSites = visitedSites;
	}

	return visitedSites == mSites.Length;
}

function protected int GetVisitedSitesCount( H7Player player )
{
	local int visitedSites;
	local array<H7SiteVisitData> visitData;
	local H7SiteVisitData currentVisitData;

	visitData = class'H7ScriptingController'.static.GetInstance().GetVisitedSites();

	foreach visitData(currentVisitData)
	{
		if( mSites.Find( currentVisitData.Site ) != INDEX_NONE && currentVisitData.PlayerID == player.GetPlayerNumber() )
		{
			++visitedSites;
		}
	}

	return visitedSites;
}

function array<H7IQuestTarget> GetQuestTargets()
{
	local array<H7IQuestTarget> targets;
	local H7VisitableSite site;
	local array<H7SiteVisitData> visitData;
	local H7SiteVisitData currentVisitData;
	local array<H7VisitableSite> visitedSites;
	local H7Player currentPlayer;

	currentPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();

	visitData = class'H7ScriptingController'.static.GetInstance().GetVisitedSites();
	foreach visitData( currentVisitData )
	{
		if(currentVisitData.PlayerID == currentPlayer.GetPlayerNumber())
		{
			visitedSites.AddItem( currentVisitData.Site );
		}
	}

	foreach mSites( site )
	{
		if( visitedSites.Find( site ) == INDEX_NONE )
		{
			targets.AddItem( site );
		}
	}
	return targets;
}

function protected string GetProgress()
{
	if(mProgress == "")
	{
		InitProgress();
	}
	return mProgress;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("SITES_VISITED_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int currentCount;

	currentCount = GetVisitedSitesCount( class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() );

	progress.CurrentProgress = Min(currentCount, mSites.Length);
	progress.MaximumProgress = mSites.Length;
	progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
	progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));
	progresses.AddItem(progress);

	return progresses;
}

function bool HasProgress() { return mSites.Length > 0; }

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

