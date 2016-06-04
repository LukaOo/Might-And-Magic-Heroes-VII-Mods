//=============================================================================
// H7AdventureHud
//
// Handles the Adventure-HUD. 
//
// The hud consist of multiple flash-movies (=GFXMoviePlayer) on top of each other
// 
// High level class which is accessed by other modules to inform the HUD about 
// changes in the game that need to be visualized in the HUD.
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AdventureHud extends H7CombatHud;

var protected H7AdventureHudCntl mAdventureHud;
var protected H7WindowWeeklyCntl mWindowWeeklyCntl;
//var protected H7HeroWindowBaseCntl mHeroWindowBaseCntl;
var protected H7HeroWindowCntl mHeroWindowCntl;
var protected H7SkillwheelCntl mSkillwheelCntl; 
var protected H7TownHudCntl mTownHudCntl;
var protected H7TownRecruitmentPopupCntl mTownRecruitmentCntl;
var protected H7TownBuildingPopupCntl mTownBuildingCntl;
var protected H7MarketPlacePopupCntl mMarketPlaceCntl;
var protected H7HallOfHerosPopupCntl mHallOfHerosCntl;
var protected H7MagicGuildPopupCntl mMagicGuildCntl;
var protected H7ThievesGuildPopupCntl mThievesGuildCntl;
var protected H7TownCaravanPopupCntl mCaravanCntl;
var protected H7TownWarfarePopupCntl mWarfareCntl;
var protected H7HeroTradeWindowCntl mHeroTradeWindowCntl;
var protected H7TownGuardPopupCntl mTownGuardCntl;
var protected H7GateGuardPopupCntl mGateGuardCntl;
var protected H7TurnOverCntl mTurnOverPopup;
var protected H7QuestLogCntl mQuestLogCntl;
var protected H7QuestCompleteCntl mQuestCompleteCntl;
var protected H7TradeResultCntl mTradeResultCntl;
var protected H7MerchantPopUpCntl mMerchantPopUpCntl;
var protected H7TrainingGroundsPopUpCntl mTrainingGroundsPopUpCntl;

var protected H7ArtifactRecyclerPopupCntl mArtifactRecyclerCntl;
var protected H7InscriberPopupCntl mInscriberCntl;
var protected H7AltarOfSacrificeCntl mAltarOfSacrificeCntl;

var protected H7ContainerCntl mTownPopupCntl;
var protected H7TreasureHuntCntl mTreasureHuntCntl;
var protected H7RandomSkillingPopUpCntl mRandomSkillingPopUpCntl;

static function H7AdventureHud GetAdventureHud() {  return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud(); }

function H7AdventureHudCntl GetAdventureHudCntl() { return mAdventureHud; }
function H7WindowWeeklyCntl GetWindowWeeklyCntl() { return mWindowWeeklyCntl; }
//function H7HeroWindowBaseCntl GetHeroWindowBaseCntl(){ return mHeroWindowBaseCntl;}
function H7HeroWindowCntl   GetHeroWindowCntl()   { return mHeroWindowCntl; };
function H7SkillwheelCntl   GetSkillwheelCntl()   { return mSkillwheelCntl; };
function H7TownHudCntl      GetTownHudCntl()   { return mTownHudCntl; };
function H7TownRecruitmentPopupCntl GetTownRecruitmentCntl() {return mTownRecruitmentCntl;};
function H7TownBuildingPopupCntl GetTownBuildingCntl() {return mTownBuildingCntl;};
function H7MarketPlacePopupCntl GetMarketPlaceCntl() {return mMarketPlaceCntl;}
function H7MagicGuildPopupCntl GetMagicGuildCntl() {return mMagicGuildCntl;}
function H7ThievesGuildPopupCntl GetThievesGuildCntl() {return mThievesGuildCntl;}
function H7HallOfHerosPopupCntl GetHallOfHerosCntl() {return mHallOfHerosCntl;}
function H7MerchantPopUpCntl GetMerchantPopUpCntl() {return mMerchantPopUpCntl;}
function H7TrainingGroundsPopUpCntl GetTrainingGroundsPopUpCntl() {return mTrainingGroundsPopUpCntl;}

function H7ArtifactRecyclerPopupCntl GetArtifactRecyclerCntl() {return mArtifactRecyclerCntl;}
function H7InscriberPopupCntl GetInscriberCntl() {return mInscriberCntl;}
function H7AltarOfSacrificeCntl GetAltarOfSacrificeCntl() {return mAltarOfSacrificeCntl;}

function H7TownGuardPopupCntl GetTownGuardCntl() {return mTownGuardCntl;}
function H7GateGuardPopupCntl GetGateGuardCntl() {return mGateGuardCntl;}
function H7TownCaravanPopupCntl GetCaravanCntl() {return mCaravanCntl;}
function H7HeroTradeWindowCntl GetHeroTradeWindowCntl() {return mHeroTradeWindowCntl;}
function H7TurnOverCntl      GetTurnOverCntl()  { return mTurnOverPopup;}
function H7QuestLogCntl      GetQuestLogCntl()  { return mQuestLogCntl;}
function H7QuestCompleteCntl GetQuestCompleteCntl()  { return mQuestCompleteCntl;}
function H7TradeResultCntl   GetTradeResultCntl() {return mTradeResultCntl;}
function H7TownWarfarePopupCntl   GetTownWarfareCntl() {return mWarfareCntl;}

function H7ContainerCntl   GetTownPopupContainerCntl() {return mTownPopupCntl;}
function H7TreasureHuntCntl GetTreasureHuntCntl() {return mTreasureHuntCntl;}
function H7RandomSkillingPopUpCntl GetRandomSkillingPopUpCntl() {return mRandomSkillingPopUpCntl;}

simulated function Init()
{
	if(mIsInitialised)
	{
		return;
	}

	mIsInitialised = true;

	PreInit();

	// list of all movies in no order
	mHeroWindowCntl = new class'H7HeroWindowCntl';
	mAdventureHud = new class'H7AdventureHudCntl';
	mWindowWeeklyCntl = new class'H7WindowWeeklyCntl';
	mSkillwheelCntl = new class'H7SkillwheelCntl';
	mTurnOverPopup  = new class'H7TurnOverCntl';
	mQuestLogCntl = new class'H7QuestLogCntl';	
	mQuestCompleteCntl = new class'H7QuestCompleteCntl';
	mTradeResultCntl = new class'H7TradeResultCntl';
	mTownHudCntl = new class'H7TownHudCntl';
	mTownRecruitmentCntl = new class'H7TownRecruitmentPopupCntl';
	mTownBuildingCntl = new class'H7TownBuildingPopupCntl';
	mMarketPlaceCntl = new class'H7MarketPlacePopupCntl';
	mHallOfHerosCntl = new class'H7HallOfHerosPopupCntl';
	mWarfareCntl = new class'H7TownWarfarePopupCntl';
	mCaravanCntl = new class'H7TownCaravanPopupCntl';
	mHeroTradeWindowCntl = new class'H7HeroTradeWindowCntl';
	mMagicGuildCntl = new class'H7MagicGuildPopupCntl';
	mThievesGuildCntl = new class'H7ThievesGuildPopupCntl';
	mTownGuardCntl = new class'H7TownGuardPopupCntl';
	mGateGuardCntl = new class'H7GateGuardPopupCntl';
	mArtifactRecyclerCntl = new class'H7ArtifactRecyclerPopupCntl';
	mInscriberCntl = new class'H7InscriberPopupCntl';
	mTownPopupCntl = new class'H7ContainerCntl';
	mTreasureHuntCntl = new class'H7TreasureHuntCntl';
	mAltarOfSacrificeCntl = new class'H7AltarOfSacrificeCntl';
	mMerchantPopUpCntl = new class'H7MerchantPopUpCntl';
	mRandomSkillingPopUpCntl = new class'H7RandomSkillingPopUpCntl';
	mTrainingGroundsPopUpCntl = new class'H7TrainingGroundsPopUpCntl';

	// bg
	mMovies.AddItem(mBackgroundImageCntl);
	
	// logs
	mMovies.AddItem(mLogSystemCntl);

	// combat hud
	InitCombatHud(true);

	// hud
	// town building windows (under hud)
	mMovies.AddItem(mTownPopupCntl); // container first!
	
	mMovies.AddItem(mHallOfHerosCntl);
	mMovies.AddItem(mMarketPlaceCntl);
	mMovies.AddItem(mTownRecruitmentCntl);
	mMovies.AddItem(mTownBuildingCntl);
	mMovies.AddItem(mMagicGuildCntl);
	mMovies.AddItem(mThievesGuildCntl);
	mMovies.AddItem(mTownGuardCntl);
	mMovies.AddItem(mGateGuardCntl);
	mMovies.AddItem(mWarfareCntl);
	mMovies.AddItem(mArtifactRecyclerCntl);
	mMovies.AddItem(mInscriberCntl);
	mMovies.AddItem(mAltarOfSacrificeCntl);
	mMovies.AddItem(mCaravanCntl);
	// --- town hud ---
	mMovies.AddItem(mTownHudCntl);

	// adventure hud windows (under hud)
	mMovies.AddItem(mSkillwheelCntl);
	mMovies.AddItem(mHeroWindowCntl);
	mMovies.AddItem(mQuestLogCntl);
	mMovies.AddItem(mSpellbookCntl);
	mMovies.AddItem(mTreasureHuntCntl);
	mMovies.AddItem(mHeroTradeWindowCntl);

	// ------- adventure hud ---------
	mMovies.AddItem(mAdventureHud);
	
	// adventure windows (over hud)
	
	// adventure popups
	mMovies.AddItem(mWindowWeeklyCntl);
	mMovies.AddItem(mTurnOverPopup);
	mMovies.AddItem(mTradeResultCntl);
	mMovies.AddItem(mQuestCompleteCntl);
	mMovies.AddItem(mMerchantPopUpCntl);
	mMovies.AddItem(mTrainingGroundsPopUpCntl);
	mMovies.AddItem(mRandomSkillingPopUpCntl);

	mDelayInit = false;

	PostInit();
}

function ChildCompleted()
{
	if( WorldInfo.GRI.IsMultiplayerGame() )
	{
		GetAdventureHudCntl().SetWaitingForPlayers( true );
	}
}

function ResolutionChanged(Vector2D newRes)
{
	local Vector2d newResFlash;
	local H7FlashMovieCntl openMovie;
	
	super.ResolutionChanged(newRes);

	newResFlash = mRequestPopupCntl.UnrealPixels2FlashPixels(newRes);
	mRequestPopupCntl.GetRequestPopup().Realign(newResFlash.x,newResFlash.y);

	newResFlash = mAdventureHud.UnrealPixels2FlashPixels(newRes);
	mAdventureHud.GetHeroHUD().Realign(newResFlash.x,newResFlash.y);
	mAdventureHud.GetTopBar().Realign(newResFlash.x,newResFlash.y);
	mAdventureHud.GetCommandPanel().Realign(newResFlash.x,newResFlash.y);
	mAdventureHud.GetMinimap().Realign(newResFlash.x, newResFlash.y);
	mAdventureHud.GetMinimap().UpdateBackground();
	mAdventureHud.GetTownList().Realign(newResFlash.x, newResFlash.y);
	mAdventureHud.GetPlayerBuffs().Realign(newResFlash.x, newResFlash.y);
	mAdventureHud.GetMPTurnInfo().Realign(newResFlash.x, newResFlash.y);
	mAdventureHud.GetNoteBar().Realign(newResFlash.x, newResFlash.y);

	mSkillwheelCntl.ResolutionChanged();

	mHeroWindowCntl.GetHeroWindow().Realign(newResFlash.x, newResFlash.y);

	newResFlash = mDialogCntl.UnrealPixels2FlashPixels(newRes);
	mDialogCntl.GetNarrationDialog().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetNarrationTop().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetDialog().Realign(newResFlash.x,newResFlash.y);
	mDialogCntl.GetCouncilDialog().Realign(newResFlash.x,newResFlash.y);

	// town hud
	newResFlash = mTownHudCntl.UnrealPixels2FlashPixels(newRes);
	mTownHudCntl.GetTownInfo().Realign(newResFlash.x, newResFlash.y);
	mTownHudCntl.GetMiddleHUD().Realign(newResFlash.x, newResFlash.y);
	
	// current popup
	openMovie = GetCurrentContext();
	if(openMovie != none && openMovie.IsA('H7FlashMoviePopupCntl'))
	{
		newResFlash = openMovie.UnrealPixels2FlashPixels(newRes);
		H7FlashMoviePopupCntl(openMovie).GetPopup().Realign(newResFlash.x,newResFlash.y);
		if(openMovie == class'H7QuestLogCntl'.static.GetInstance())
		{
			class'H7QuestLogCntl'.static.GetInstance().GetQuestLog().GetMinimapDummyBounds();
		}
	}



}

// called every tick/frame
event PostRender()
{
	if(!IsLoaded()) return;

	// every frame that is not mouse over hud, the tooltip gets the buffered hitactor, so that we don't have to trace every frame?
	if (class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() && GetAdventureHudCntl().GetActorTooltip() != none)
	{
		if(class'H7PlayerController'.static.GetPlayerController().IsInputAllowed())
		{
			GetAdventureHudCntl().GetActorTooltip().SetActor(class'H7AdventureGridManager'.static.GetInstance().GetLastHitActor());
		}
		GetAdventureHudCntl().GetActorTooltip().Update();
	}
	
	if( bShowDebugInfo )
	{
		if( ShouldDisplayDebug('boundingbox') )
		{
			if (GetAdventureHudCntl().GetActorTooltip() != none)
			{
				GetAdventureHudCntl().GetActorTooltip().DebugDrawBoundingBox(Canvas);
			}
		}

		if( ShouldDisplayDebug('aoc') )
		{
			DebugDrawAoC();
		}

		if( ShouldDisplayDebug('simturns') )
		{
			DebugSimTurns();
		}
	}

	if (mAdventureHud.GetMinimap() != none)
	{
		if(!GetTownHudCntl().IsInTownScreen() && !class'H7TreasureHuntCntl'.static.GetInstance().GetTreasureHuntPopup().IsFilming())
		{
			GetAdventureHudCntl().GetMinimap().ComputeMinimapFrustum();
		}
	
		mAdventureHud.GetMinimap().CheckUpdateVisibility();
	}
	
	super.PostRender();
}

function DebugDrawAoC()
{
	local WorldInfo myWorld;
	local H7AreaOfControlSite aocSite;

	myWorld = class'WorldInfo'.static.GetWorldInfo();

	if( myWorld != None )
	{
		foreach myWorld.DynamicActors ( class'H7AreaOfControlSite', aocSite )
		{
			aocSite.RenderDebugInfo( Canvas );
		}
	}
}

function DebugSimTurns()
{
	if( class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager() != none )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetSimTurnCommandManager().RenderDebug( Canvas );
	}
}

// @nikos: do we still need this?
function DynamicSMActor_Spawnable GetBlackPreviewPlane()
{
	local DynamicSMActor_Spawnable meshActor;
	local SpriteComponent sprite;

	sprite = new class'SpriteComponent'();
	sprite.SetSprite(Texture2D'H7Backgrounds.DummyTown');
	sprite.SetRotation( Rotator(Vect(10000,0,0)) );

	meshActor = Spawn( class'DynamicSMActor_Spawnable' );
	//meshActor.SetStaticMesh( StaticMesh'Temp_CodeRequests.BlackPlane' );
	meshActor.AttachComponent(sprite);

	meshActor.SetLocation( Vect(1,1,1) );
	meshActor.SetRotation( Rotator(Vect(0,0,0)) );
	
	return meshActor;
}

event Tick( float deltaTime )
{
	super.Tick( deltaTime );

	if(!mIsInitialised)
	{
		return;
	}
}

function SetAdventureHudVisible(bool visible)
{
	mAdventureHud.GetActorTooltip().ShutDown();
	mAdventureHud.SetVisible(visible);
	mLogSystemCntl.SetVisible(visible);
}

