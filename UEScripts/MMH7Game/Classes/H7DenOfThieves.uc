/*=============================================================================
* H7DenOfThieves
* =============================================================================
*  Grants access to a additional spy, same functionality as Thieves Guild
* =============================================================================
*  Copyright 2015 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7DenOfThieves extends H7NeutralSite
	implements(H7ITooltipable, H7IHideable)
	hidecategories(Defenses)
	dependson(H7ITooltipable)
	placeable
	native
	savegame;

var() protectedwrite int                 mInstantSpyMissions <DisplayName = "Number of Instant Spy Missions">;
var protectedwrite savegame int          mInstantSpyMissionsRemaining;
var protected savegame H7Player          mWeeklyOwner;
var protected savegame bool              mIsHidden;
var protected savegame bool              mIsVisited;

function int GetInstantSpyMission() {return mInstantSpyMissions;}
function int GetInstantSpyMissionRemaining() {return mInstantSpyMissionsRemaining;}

native function bool IsHiddenX();

event InitAdventureObject()
{
	super.InitAdventureObject();
	class'H7AdventureController'.static.GetInstance().AddDenOfThieves( self );
	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mInstantSpyMissionsRemaining = mInstantSpyMissions;
	}
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit(hero);

	mVisitingArmy = hero.GetAdventureArmy();

	//The Den of Thieves can only be conquered once a week
	if( !mIsVisited || mWeeklyOwner == hero.GetPlayer())
	{
		if(!mIsVisited)
		{
			mWeeklyOwner = hero.GetPlayer();
			mWeeklyOwner.GetThievesGuildManager().SetInstantSpyMissions(mInstantSpyMissionsRemaining);
		}

		if( hero.GetPlayer().IsControlledByLocalPlayer() )
		{
			class'H7ThievesGuildPopupCntl'.static.GetInstance().UpdateFromDenOfThieves(self);
		}
	}
}

function SpyUsed()
{
	--mInstantSpyMissionsRemaining;
	mIsVisited = true;
}

function OnLeave()
{
	//Set the instant spy tokens to 0 when leaving the den
	mWeeklyOwner.GetThievesGuildManager().SetInstantSpyMissions(0);

	if(!mIsVisited)
	{
		mWeeklyOwner = none;
	}
}

function WeeklyReset()
{
	mWeeklyOwner = none;
	mIsVisited = false;
	mInstantSpyMissionsRemaining = mInstantSpyMissions;
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;	

	data.type = TT_TYPE_STRING;
	data.Title = GetName();
	data.Description = "<font size='#TT_BODY#'>" $ class'H7Loca'.static.LocalizeSave("TT_DEN_OF_THIEVES","H7AdvMapObjectToolTip") $ "</font>\n";
	data.Visited = GetVisitString(mIsVisited);

	return data;
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

event PostSerialize()
{
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


