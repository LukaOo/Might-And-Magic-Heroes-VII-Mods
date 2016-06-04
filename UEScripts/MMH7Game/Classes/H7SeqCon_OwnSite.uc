//=============================================================================
// H7SeqCond_OwnSiteCondition
//
// 
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SeqCon_OwnSite extends H7SeqCon_Player
	implements(H7IRandomPropertyOwner, H7IConditionable)
	native
	savegame;

/** The buildings that should be owned */
var(Properties) savegame array<H7AreaOfControlSite> mSites<DisplayName=Sites>;

var protected savegame int mPreviousOwnedSiteCount;

function protected bool IsConditionFulfilledForPlayer(H7Player player)
{
	local int ownedSiteCount;

	// Condition already fulfilled for 'normal' incremental case
	if(!self.mNot && mPreviousOwnedSiteCount == mSites.Length)
	{
		return true;
	}

	ownedSiteCount = GetTeamOwnedSiteCount(player);

	if(ownedSiteCount != mPreviousOwnedSiteCount)
	{
		ConditionProgressed();
		mPreviousOwnedSiteCount = ownedSiteCount;
	}

	return ownedSiteCount == mSites.Length;
}

function protected int GetTeamOwnedSiteCount(H7Player player)
{
	local H7AreaOfControlSite currentSite;
	local int onwedSiteCount;
	local array<H7Player> team;

	onwedSiteCount = 0;
	team = class'H7TeamManager'.static.GetInstance().GetAllAlliesIncludingSelf(player);

	foreach mSites( currentSite )
	{
		;
		if( team.Find( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( currentSite.GetPlayerNumber() ) ) != INDEX_NONE )
		{
			onwedSiteCount++;
		}
	}

	return onwedSiteCount;
}

function array<H7IQuestTarget> GetQuestTargets()
{
	local array<H7IQuestTarget> targets;
	local H7AreaOfControlSite site;
	local H7Player currentPlayer;

	currentPlayer = class'H7AdventureController'.static.GetInstance().GetCurrentPlayer();

	foreach mSites(site)
	{
		if( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber(site.GetPlayerNumber()) != currentPlayer )
		{
			targets.AddItem(site);
		}
	}
	return targets;
}

function protected InitProgress()
{
	mProgress = class'H7Loca'.static.LocalizeSave("OWN_SITES_PROGRESS","H7ConditionProgress");
}

// interface H7IProgressable
function array<H7ConditionProgress> GetCurrentProgresses()
{
	local array<H7ConditionProgress> progresses;
	local H7ConditionProgress progress;
	local int currentCount;

	local H7Player currentPlayer;
	local array<H7Player> players;

	players = GetPlayers();

	foreach players(currentPlayer)
	{
		currentCount = GetTeamOwnedSiteCount(currentPlayer);
		progress.CurrentProgress = Min(currentCount, mSites.Length);
		progress.MaximumProgress = mSites.Length;
		progress.ProgressText = Repl(GetProgress(), "%current", int(progress.CurrentProgress));
		progress.ProgressText = Repl(progress.ProgressText, "%maximum", int(progress.MaximumProgress));
		progresses.AddItem(progress);
	}
	return progresses;
}

function bool HasProgress() { return mSites.Length > 0; }

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	local int i;

	if(hatchedObject.IsA('H7AreaOfControlSite'))
	{
		for(i = 0; i < mSites.Length; ++i)
		{
			if(mSites[i] == randomObject)
			{
				mSites[i] = H7AreaOfControlSite(hatchedObject);
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

