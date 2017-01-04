//=============================================================================
// Don't modify this file, it's only purpose is creating Adventure Ai. 
// Only method used in this class is InitAdventureAI.
//=============================================================================
//
//=============================================================================
// H7AdventureController
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class AIModAdventureAiBuilder extends H7BaseGameController
	dependson(H7Player, H7StructsAndEnumsNative, H7AiAdventureMap)
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	;

const RETREAT_TIMER = 20;

var(AdventureMap) protected array<H7Player>     mEditorPlayers<DisplayName=Players>;

var(AdventureConfiguration) protected archetype H7AdventureConfiguration mAdventureConfiguration<DisplayName=Adventure Configuration>;

var protected array<H7AbilityTrackingData> mAbilityTrackingData;
var protected int mNumberOfFightsTotal;
var protected int mNumberOfFightsManual;
var protected int mNumberOfFightsQuickCombat;
var protected int mNumberOfRoundsInFightsTotal;
var protected int mNumberOfRoundsInFightsAutoCombat;

var bool mIsDeserializing;

var protected bool mWeekPassed;

var protected array<SeqAct_Interp> mLoadSaveMatinees;
var protected array<SeqAct_Interp> mToReopenMatinees;

var protected string mConfigPath;

var protected H7CampaignDefinition     mCampaign;
var protected H7RawCampaignData        mRawCampaign;
var protected H7LobbyDataMapSettings   mMapSettings;
var protected H7LobbyDataGameSettings  mGameSettings;
var protected array<PlayerLobbySelectedSettings> mPlayerSettings;

var protected H7Calendar				mCalendar;
var protected bool						mIsHeroFXHidden;
var protected bool						mIsHeroActive;
var protected string                   mUniqueGameName;
var protected H7AdventureGridManager			mGridManager;

var protected H7CounciLMapManager               mCouncilMapManager;
var protected Vector                            mCouncilMapOffset;
var protected bool                              mCouncilMapActive;
var protected bool                              mCouncilMapInTransition;
var protectedwrite name                         mCouncilMapLevel;

var protected int                      mIdCounter;

var protectedwrite float				mDifficultyPlayerStartResourcesMultiplier;
var protectedwrite float				mDifficultyCritterStartSizeMultiplier;
var protectedwrite float				mDifficultyCritterGrowthRateMultiplier;

// list references
var protected array<H7Player>          mPlayers;
var protected array<H7AdventureArmy>            mArmies;
var protected array<H7CaravanArmy>              mActiveCarravans;
var protected array<H7Teleporter>               mTeleporterList;
var protected array<H7Mine>                     mMineList;
var protected array<H7Town>                     mTownList;
var protected array<H7Fort>                     mFortList;
var protected array<H7Dwelling>                 mDwellingList;
var protected array<H7CustomNeutralDwelling>    mCostumNeutralDwelling;
var protected array<H7Merchant>                 mMerchantList;
var protected array<H7AreaOfControlBuffSite>    mAoCBuffSiteList;
var protected array<H7DestructibleObjectManipulator>  mDestructionManipulators;
var protected array<H7AdventureObject>		    mAdventureObjectList;
var protected array<H7Garrison>		            mGarrisonList;
var protected array<H7PermanentBonusSite>       mPermanentBonusSiteList;
var protected array<Landscape>                  mLandscapesList;
var protected array<H7BattleSite>               mBattleSiteList;
var protected array<H7DenOfThieves>             mDenOfThievesList;
var protected float                    mNeutralGrowthMultiplier;
var protected int                               mAmountOfObelisks;
var protected IntPoint					mTearOfAshaCoordinates;
var protected int						mTearOfAshaGridIndex;
var protected bool						mTearOfAshaRetrieved;
var protected bool                              mHasUpgradeCostWeekEffect;
var protected float                             mUpgradeCostWeekEffect;
var protected float                             mGlobalTradeModifier;
var protected bool                              mTurnTimerPaused;
var protected bool                              mSimTurnOfAI;

var protected AIModH7AiAdventureMap                  mAI;
var protected H7AdventureArmy					mSelectedArmy;
var protected H7AdventureArmy					mHoveredArmy;
var protected int						mCurrentPlayerIndex;
var protected H7AdventureMapCell                mBeforeBattleCell;
var protected H7AreaOfControlSite				mBeforeBattleArea;
var protected H7BattleSite                      mCurrentBattleSite;
var protected H7RunicBox                        mCurrentRunicBoxSite;
var protected int						mTurnCounter;
var protected H7AdventureCursor				    mCursor;
var protected H7AdventureArmy                   mArmyAttacker, mArmyDefender;
var protected H7CombatArmy                      mArmyAttackerCombat, mArmyDefenderCombat;
var protected H7TownCastingStage                mPreparedCastingStage;
var protected string                            mCombatMapName;
var protectedwrite string              mAdventureMapName;
var protected H7PlayerController                mPlayerControllerInstance;

var protected bool                              mRestoreSFX;

var protected H7HallOfHeroesManager	mHallOfHeroesManager;

var protected H7CameraActionController          mCameraActionTemplate;

var protected H7TeamManager                     mTeamManager;

var protected bool                              mIsInitialized;
var bool                                        mIsCaravanTurnFinished;
var protected bool                              mIsPlayerTurn;
var protected int                      mIsHotSeat; // -1 - don't know, 0 - no, 1 - yes

var protected H7HeroEventParam	                mHeroEventParam;
var protected H7PlayerEventParam                mPlayerEventParam;

var protected bool                              mAutomatedAIEnabled;
var protected bool                              mSkipMove;
var protected bool                              mAIAllowQuickCombat;

var protected bool                              mKismetAllowsFlee;
var protected bool                              mKismetAllowsSurrender;

var protected bool                     mChooseMe;

var protected H7MapInfo                         mMapInfo;
var protected H7SynchRNG                        mSynchRNG;

var protected H7HashRandom                      mRNGQuickCombat;

var protected float								mCurrentTurnTimeLeft;
var protected float                             mCurrentRetreatTimeLeft;

var protected H7AdventurePlayerController       mAdventurePlayerController;
var protected transient PostProcessChain        mAdventurePP;

var protected array<SequenceOp>                 mSeqsToReopen;

var protected float                    mSessionGameplayTimeSec;
var protected int                      mSessionGameplayTimeMin;

var protected array<SequenceAction>    mCellPassChanges;
var protected array<SequenceAction>    mCellLayerChanges;
var protected array<SequenceAction>    mCellFOWChanges;

var protected int                               mBeforeCombatUAC;
var protected int                               mBeforeCombatRandomCounter;
var protected int                               mBeforeCombatIdCounter;
var protected H7InstantCommandFinishCombat      mPreparedFinishCombatCommand;
var protected array<H7InstantCommandLearnSpell> mPreparedSpellsToLearn;

var protected transient bool                    mTrackingMapEndSend;
var protected int                               mLastDetectedOOSUAC;

// Revision when game session was created
var string                             mGameRevisionOriginal;
// Revision when game session was last played
var string                             mGameRevisionLatest;
var int                                mArmiesSizeOnSave;

var bool                               mIsRMGMap;
var transient bool                              mNoMatineeAllowed;

var protected H7CombatEndReason mLastCombatEndReason;

public delegate OnScreenshotComplete();

//=============================================================================
// Getters and Query functions
//=============================================================================
function float                                  GetGlobalTradeModifier()                            { return mGlobalTradeModifier; }
function                                        SetGlobalTradeModifier(float f)                     { mGlobalTradeModifier = f; }
function float                                  GetUpgradeCostWeekEffect()                          { return mUpgradeCostWeekEffect; }
function                                        SetUpgradeCostWeekEffect(float mult)                { mUpgradeCostWeekEffect = mult; }
function bool                                   HasUpradeCostWeekEffect()                           { return mHasUpgradeCostWeekEffect; }
function                                        SetHasUpgradeCostWeekEffect(bool bvalue)            { mHasUpgradeCostWeekEffect = bvalue; }
function bool                                   IsTearOfAshaRetrieved()                             { return mTearOfAshaRetrieved; }
function                                        SetTearOfAshaRetrieved( bool val )                  { mTearOfAshaRetrieved = val; }
function int                                    GetTearOfAshaGridIndex()                            { return mTearOfAshaGridIndex; }
function IntPoint                               GetTearOfAshaCoordinates()                          { return mTearOfAshaCoordinates; }
function H7AdventureMapCell                     GetTearOfAshaCell()                                 { return mGridManager.GetCell( mTearOfAshaCoordinates.X, mTearOfAshaCoordinates.Y, mTearOfAshaGridIndex ); }
function int                                    GetAmountOfObelisks()                               { return mAmountOfObelisks; }
function                                        IncrementObeliskCount()                             { ++mAmountOfObelisks; }
function H7AdventureConfiguration				GetConfig()											{ return mAdventureConfiguration; }
function H7AdventureCursor						GetCursor()											{ if(mCursor == none) scripttrace(); return mCursor; }
function										SetBeforeCombatCell( H7AdventureMapCell cell )		{ mBeforeBattleCell = cell; }
function H7Player						GetCurrentPlayer() {return NONE;}
function array<H7Player>						GetPlayers()										{ return mPlayers; }
function int						            GetNumOfPlayers()									{ return mPlayers.Length; }
function H7AdventureArmy						GetSelectedArmy()									{ return mSelectedArmy;}
function int									GetTurns()											{ return mTurnCounter; }
function H7AdventureArmy						GetArmyAttacker()									{ return mArmyAttacker; }
function										SetArmyAttacker( H7AdventureArmy army )				{ mArmyAttacker = army; }
function H7AdventureArmy						GetArmyDefender()									{ return mArmyDefender; }
function										SetArmyDefender( H7AdventureArmy army )				{ mArmyDefender = army; }
function H7CombatArmy							GetArmyAttackerCombat()								{ return mArmyAttackerCombat; }
function										SetArmyAttackerCombat( H7CombatArmy army )			{ mArmyAttackerCombat = army; }
function H7CombatArmy							GetArmyDefenderCombat()								{ return mArmyDefenderCombat; }
function										SetArmyDefenderCombat( H7CombatArmy army )			{ mArmyDefenderCombat = army; }
function AIModH7AiAdventureMap						GetAI()												{ return mAI; }
function										AddTeleporter( H7Teleporter porter )				{ mTeleporterList.AddItem( porter ); }
function										AddTown( H7Town town )								{ mTownList.AddItem( town ); SortTownList(); }
function										AddFort( H7Fort fort )								{ mFortList.AddItem( fort ); }
function										AddDwelling( H7Dwelling dwelling )					{ mDwellingList.AddItem( dwelling ); }
function										AddCustomNeutralDwelling( H7CustomNeutralDwelling costumDwelling ) { mCostumNeutralDwelling.AddItem( costumDwelling ); }
function										AddMine( H7Mine mine )								{ mMineList.AddItem( mine ); }
function										AddMerchant( H7Merchant mine )						{ mMerchantList.AddItem( mine ); }
function array<H7Mine>							GetMines()								            { return mMineList; }
function										AddAoCBuffSite( H7AreaOfControlBuffSite aocBuffSite ){ mAoCBuffSiteList.AddItem( aocBuffSite ); }
function										AddPermanentBonusSite( H7PermanentBonusSite site)	{ mPermanentBonusSiteList.AddItem( site ); }
function										AddBattleSite( H7BattleSite site)	                { mBattleSiteList.AddItem( site ); }
function										AddGarrison( H7Garrison garrison )					{ mGarrisonList.AddItem( garrison ); }
function										AddAdvObject( H7AdventureObject objectissimo )		{ mAdventureObjectList.AddItem( objectissimo ); }
function										RemoveAdvObject( H7AdventureObject objectissimo )	{ mAdventureObjectList.RemoveItem( objectissimo ); }
function array<H7AdventureObject>				GetAdvObjectList()									{ return mAdventureObjectList; }
function array<H7Teleporter>					GetTeleporterList()									{ return mTeleporterList; }
function array<H7Merchant>					    GetMerchantList()									{ return mMerchantList; }
function array<H7Town>							GetTownList()										{ return mTownList; }
function array<H7Fort>							GetFortList()										{ return mFortList; }
function array<H7DestructibleObjectManipulator> GetDestructionManipulators()						{ return mDestructionManipulators; }
function										AddDestructionManipulator( H7DestructibleObjectManipulator obj ) { mDestructionManipulators.AddItem( obj ); }
function H7HallOfHeroesManager					GetHallOfHeroesManager()							{ return mHallOfHeroesManager; }
function array<H7CaravanArmy>					GetCurrentCaravanArmies()							{ return mActiveCarravans; }
function H7AreaOfControlSite					GetBeforeBattleArea()								{ return mBeforeBattleArea; }
function										SetBeforeBattleArea( H7AreaOfControlSite site )		{ mBeforeBattleArea = site; }
function H7BattleSite                           GetCurrentBattleSite()                              { return mCurrentBattleSite; }
function                                        SetCurrentBattleSite( H7BattleSite site)            { mCurrentBattleSite = site; }
function H7RunicBox                             GetCurrentRunicBoxSite()                            { return mCurrentRunicBoxSite; }
function                                        SetCurrentRunicBoxSite( H7RunicBox site)            { mCurrentRunicBoxSite = site; }
function H7TownCastingStage						GetPreparedCastingStage()							{ return mPreparedCastingStage; }
function										SetPreparedCastingStage( H7TownCastingStage stage )	{ mPreparedCastingStage = stage; }
function bool									IsAllHeroFXHidden()									{ return mIsHeroFXHidden; }
function H7AdventureGridManager					GetGridController()									{ return mGridManager; }
function array<Landscape>						GetLandscapes()										{ return mLandscapesList;}
function H7TeamManager							GetTeamManager()									{ return mTeamManager; }
function bool									IsInitialized()										{ return mIsInitialized; }
function bool                                   IsAutomatedTestingAIEnabled()                       { return mAutomatedAIEnabled; }
function                                        SetAutomatedTestingAI(bool isEnabled)               { mAutomatedAIEnabled = isEnabled; }
function bool                                   ShouldSkipMove()                                    { return mSkipMove; }
function                                        SetSkipMove(bool isEnabled)                         { mSkipMove = isEnabled; }
function										SetAIAllowQuickCombat(bool canQuickCombat)			{ mAIAllowQuickCombat = canQuickCombat; }
function bool									GetAIAllowQuickCombat()			                    { return mAIAllowQuickCombat; }
function										SetKismetAllowsFlee(bool canFlee)					{ mKismetAllowsFlee = canFlee; }
function										SetKismetAllowsSurrender(bool canSurrender)			{ mKismetAllowsSurrender = canSurrender; }
function bool									KismetAllowsFlee()									{ return mKismetAllowsFlee; }
function bool									KismetAllowsSurrender()								{ return mKismetAllowsSurrender; }
function H7Calendar                             GetCalendar()                                       { return mCalendar; }
function float                                  GetNeutralGrowthMultiplier()                        { return mNeutralGrowthMultiplier; }
function                                        SetNeutralGrowthMultiplier(float f)                 { mNeutralGrowthMultiplier = f ; } 
function array<H7DenOfThieves>                  GetDenOfThievesList()                               { return mDenOfThievesList; }
function                                        AddDenOfThieves(H7DenOfThieves den)                 { mDenOfThievesList.AddItem(den); }

function H7CampaignDefinition            GetCampaign() {return NONE;}
function H7CouncilMapManager                    GetCouncilMapManager()                              { return mCouncilMapManager; }
function                                        SetCouncilMapManager(H7CouncilMapManager newValue)  { mCouncilMapManager = newValue; }
function bool                                   IsCouncilMapActive()                                { return mCouncilMapActive; }
function bool                                   IsCouncilMapTransition()                            { return mCouncilMapInTransition; }
function                                        SetTurnTimerPaused(bool paused)                     { mTurnTimerPaused = paused; }
function bool                                   IsSimTurnOfAI()                                     { return mSimTurnOfAI; }
// lobby settings
function H7LobbyDataMapSettings                 GetMapSettings()                    { return mMapSettings; }
function H7LobbyDataGameSettings                GetGameSettings()                   { return mGameSettings; }
function                                        SetGameSettingsSpeedAdv( float s )  { mGameSettings.mGameSpeedAdventure = s; }
function                                        SetGameSettingsSpeedCmb( float s )  { mGameSettings.mGameSpeedCombat = s; }
function                                        SetGameSettingsSpeedAi( float s )   { mGameSettings.mGameSpeedAdventureAI = s; }
function array<PlayerLobbySelectedSettings>     GetPlayerSettings()                 { return mPlayerSettings; }
function EForceQuickCombat					    GetForceQuickCombat()               { return mGameSettings.mForceQuickCombat; }
function bool									GetTeamTrade()                      { return mGameSettings.mTeamsCanTrade; }
function bool									GetRandomSkilling()                 { return mGameSettings.mUseRandomSkillSystem; }
function                                        SetRandomSkilling(bool val)         { mGameSettings.mUseRandomSkillSystem = val; }
// true -> the spectators can watch the combats, false -> they just see a progress bar screen
function bool									IsSpectatorMode()                   { return mGameSettings.mSpectatorMode; }
function int                                    GetBeforeCombatUAC()                { return mBeforeCombatUAC; }
function                                        SetPreparedFinishCombatCommand(H7InstantCommandFinishCombat command) { mPreparedFinishCombatCommand = command; }
function                                        AddPreparedSpellToLearn(H7InstantCommandLearnSpell command) { mPreparedSpellsToLearn.AddItem(command); }
function float                                  GetCurrentTimeLeft()                { return mCurrentTurnTimeLeft; }
function int                                    GetCurrentRetreatTimeLeft()         { return int(mCurrentRetreatTimeLeft); }
function int                                    GetLastDetectedOOSUAC()             { return mLastDetectedOOSUAC; }
function                                        SetLastDetectedOOSUAC(int uac)      { mLastDetectedOOSUAC = uac; }
function H7CombatEndReason                      GetLastCombatEndReason()            { return mLastCombatEndReason; }

function string                                 GetMapFileName()                    { return mAdventureMapName; } 

function SetCombatEndReason(H7CombatEndReason reason) { mLastCombatEndReason = reason; }

function IncrementTrackingRoundCounter()
{
	++mNumberOfRoundsInFightsTotal;
}

function IncrementTrackingRoundCounterAutoCombat()
{
	++mNumberOfRoundsInFightsAutoCombat;
}

function InitTradeModifier(){}

function AddAbilityTrackingData( H7AbilityTrackingData data )
{
	local int index;
	index = mAbilityTrackingData.Find( 'AbilityName', data.AbilityName );
	if( index == INDEX_NONE )
	{
		data.NumberOfCasts = 1;
		mAbilityTrackingData.AddItem( data );
		index = mAbilityTrackingData.Length - 1;
	}
	else
	{
		mAbilityTrackingData[ index ].NumberOfCasts = mAbilityTrackingData[ index ].NumberOfCasts + 1;
		//mAbilityTrackingData[ index ].CasterName = mAbilityTrackingData[ index ].CasterName @ data.CasterName;
	}
	;
}

function array<H7AbilityTrackingData> GetAbilityTrackingData()
{
	return mAbilityTrackingData;
}

function AddLoadSaveMatinee( SeqAct_Interp mat )
{
	mLoadSaveMatinees.AddItem( mat );
}

/**
 * Returns all the armies currently present on the map,
 * which means it SHOULD exclude garrisoned armies.
 * 
 * */
function GetArmiesCurrentlyOnMap( out array<H7AdventureArmy> armies ){}

function HunsAreComing(){}

// dont needed, adventure controller is a special case
function bool IsMarkedForDeletion(){}
function MarkForDeletion(bool val){}

// there is only one adventure controller per level
static function H7AdventureController GetInstance()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetAdventureController();
}

static function WorldInfo GetWorldinfo() { return class'WorldInfo'.static.GetWorldInfo(); }
function H7MapInfo GetMapInfo() { return mMapInfo; }
function bool IsSkirmish() 
{ 
	return mMapInfo.GetMapType() == SKIRMISH; 
}

//=============================================================================
// Initialization
//=============================================================================

event FinalizeSerialize()
{
	mIsDeserializing = false;
	
	if( GetCurrentPlayer() == GetLocalPlayer() )
	{
		UpdateHUD( GetCurrentPlayer().GetHeroes(), GetCurrentPlayer().GetLastSelectedArmy(), true, true);
	}
	else if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		UpdateHUD( GetLocalPlayer().GetHeroes(), GetLocalPlayer().GetLastSelectedArmy(), true, true);
	}
}

function SortMatineesByLoadPriority(out array<SequenceObject> matineesToSort){}

event PostSerialize()
{
	local SeqAct_Interp matineeSeq;
	local SeqAct_Destroy destroySeq;
	local SeqAct_Toggle toggleSeq;
	local Sequence gameSeq;
	local array<SequenceObject> allSeqObs;
	local SequenceObject seqOb;
	local int i, j;
	local Object varObject;

	mNoMatineeAllowed = true;

	mGameRevisionLatest = class'H7GameData'.static.GetRevisionStr();

	mAdventureConfiguration = H7AdventureConfiguration( DynamicLoadObject( mConfigPath, class'H7AdventureConfiguration' ) );

	if(mArmiesSizeOnSave > 0)
	{
		mArmies.Length = mArmiesSizeOnSave;
	}

	for(i = 0; i < mPlayerSettings.Length; ++i )
	{
		if(mPlayerSettings[i].mFactionRef != "" && mPlayerSettings[i].mFaction == none)
		{
			mPlayerSettings[i].mFaction = class'H7GameData'.static.GetInstance().GetFactionByArchetypeID( mPlayerSettings[i].mFactionRef );

			if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() ) // Clear string for MP
			{
				mPlayerSettings[i].mFactionRef = "";
			}
		}

		if(mPlayerSettings[i].mStartHeroRef != "" && mPlayerSettings[i].mStartHero == none)
		{
			mPlayerSettings[i].mStartHero = class'H7GameData'.static.GetInstance().GetHeroByArchetypeID( mPlayerSettings[i].mStartHeroRef );

			if(mPlayerSettings[i].mStartHero == none) // If its still none, load it from package
			{
				mPlayerSettings[i].mStartHero = H7EditorHero( DynamicLoadObject( mPlayerSettings[i].mStartHeroRef , class'H7EditorHero') );
			}

			if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() ) // Clear string for MP
			{
				mPlayerSettings[i].mStartHeroRef = "";
			}
		}
	}


	// After loading check if there is maybe saved rawData for campaign
	if(mCampaign == none || (mCampaign != none && mCampaign.mCampaignMaps.Length == 0))
	{
		if(mRawCampaign.mCampaignMaps.Length > 0)
		{
			mCampaign = new class'H7CampaignDefinition';
			mCampaign.InitFromRawData(mRawCampaign);
		}
	}
	
	InitAdvCntl();
	UpdatePlayerProfileStats(); 

	StreamInCouncilMap();

	gameSeq = WorldInfo.GetGameSequence();
	gameSeq.FindSeqObjectsByClass( class'SeqAct_Interp', true, allSeqObs );
	SortMatineesByLoadPriority(allSeqObs);

	foreach allSeqObs( seqOb )
	{
		matineeSeq = SeqAct_Interp( seqOb );
		if( matineeSeq.ActivateCount > 0 )
		{
			/*if(matineeSeq.LastActivatedInputLinkSavegame == 1)
			{
				matineeSeq.ForceActivateInput(1);
			}
			else
			{
				matineeSeq.ForceActivateInput(0);
			}*/
			
			mLoadSaveMatinees.AddItem( matineeSeq );
		}
	}

	allSeqObs.Length = 0;
	gameSeq.FindSeqObjectsByClass( class'SeqAct_Toggle', true, allSeqObs );

	foreach allSeqObs( seqOb )
	{
		toggleSeq = SeqAct_Toggle( seqOb );
		/*if( toggleSeq.ActivateCount > 0 && !toggleSeq.mDontFireOnLoad)
		{
			for( j = 0; j < toggleSeq.OutputLinks.Length; ++j )
			{
				toggleSeq.OutputLinks[j].bDisabled = true;
				toggleSeq.OutputLinks[j].bDisabledPIE = true;
			}
			
			// For each Target (property) if is not infinite remove it to not play it again
			for(j = toggleSeq.Targets.Length - 1; j >= 0; --j)
			{
				if( Emitter(toggleSeq.Targets[j]) != none )
				{
					if(Emitter(toggleSeq.Targets[j]).ParticleSystemComponent.GetMaxLifespan() > 0.0f)
					{
						toggleSeq.Targets.Remove(j, 1);
					}
				}
			}

			// For each Target (by variable) if is not infinite remove it to not play it again
			for(i = 0; i < toggleSeq.VariableLinks.Length; ++i)
			{
				for(j = toggleSeq.VariableLinks[i].LinkedVariables.Length - 1; j >= 0; --j)
				{
					if(SeqVar_Object(toggleSeq.VariableLinks[i].LinkedVariables[j]) != none)
					{
						varObject = SeqVar_Object(toggleSeq.VariableLinks[i].LinkedVariables[j]).GetObjectValue();
					
						if( Emitter(varObject) != none)
						{
							if(Emitter(varObject).ParticleSystemComponent.GetMaxLifespan() > 0.0f)
							{
								toggleSeq.VariableLinks[i].LinkedVariables.Remove(j, 1);
							}
						}
					}
				}
			}

			if(SequenceOp(seqOb) != none)
			{
				mSeqsToReopen.AddItem(SequenceOp(seqOb));
			}
			toggleSeq.ForceActivateInput(toggleSeq.LastActivatedInputLinkSavegame);

			

		}*/
	}

	allSeqObs.Length = 0;
	gameSeq.FindSeqObjectsByClass( class'SeqAct_Destroy', true, allSeqObs );

	foreach allSeqObs( seqOb )
	{
		destroySeq = SeqAct_Destroy( seqOb );
		if( destroySeq.ActivateCount > 0 )
		{
			for( j = 0; j < destroySeq.OutputLinks.Length; ++j )
			{
				destroySeq.OutputLinks[j].bDisabled = true;
				destroySeq.OutputLinks[j].bDisabledPIE = true;
			}

			if(SequenceOp(seqOb) != none)
			{
				mSeqsToReopen.AddItem(SequenceOp(seqOb));
			}
			//destroySeq.ForceActivateInput(destroySeq.LastActivatedInputLinkSavegame);

		}
	}

	mPlayerControllerInstance.GetHud().SetFrameTimer(3,ReopenSequences);
	mPlayerControllerInstance.GetHud().SetFrameTimer(2,ReopenMatinees);
	mPlayerControllerInstance.GetHud().SetFrameTimer(1,RestoreCellState);
	mPlayerControllerInstance.GetHud().SetFrameTimer(5,AllowMatinees);

	if(mLoadSaveMatinees.Length == 0)
	{
		//Stops all matinee sfx
		self.PlayAkEvent(class'H7SoundController'.static.GetInstance().GetStopAllExceptMusicEvent());

		mRestoreSFX = true;
	}
}

function AllowMatinees()
{
	mNoMatineeAllowed = false;
}

function ReopenSequences()
{
	local int i, j;

	if(mLoadSaveMatinees.Length != 0)
	{
		mPlayerControllerInstance.GetHud().SetFrameTimer(2,ReopenSequences);
		return;
	}

	for(i = mSeqsToReopen.Length - 1; i >= 0; --i)
	{
		if(mSeqsToReopen[i] != none)
		{
			if(!mSeqsToReopen[i].bActive)
			{
				for( j = 0; j < mSeqsToReopen[i].OutputLinks.Length; ++j )
				{
					mSeqsToReopen[i].OutputLinks[j].bDisabled = false;
					mSeqsToReopen[i].OutputLinks[j].bDisabledPIE = false;
				}

				mSeqsToReopen.Remove(i, 1);
			}
		}
	}

	if(mSeqsToReopen.Length > 0)
	{
		mPlayerControllerInstance.GetHud().SetFrameTimer(2,ReopenSequences);
	}
}

function ReopenMatinees()
{
	local int i, j;

	for(i = mToReopenMatinees.Length - 1; i >= 0; --i)
	{
		if(!mToReopenMatinees[i].bIsPlaying && !mToReopenMatinees[i].bActive)
		{
			for( j = 0; j < mToReopenMatinees[i].OutputLinks.Length; ++j )
			{
				mToReopenMatinees[i].OutputLinks[j].bDisabled = false;
				mToReopenMatinees[i].OutputLinks[j].bDisabledPIE = false;
			}

			mToReopenMatinees.Remove(i, 1);
		}
	}

	if(mToReopenMatinees.Length > 0)
	{
		mPlayerControllerInstance.GetHud().SetFrameTimer(2,ReopenMatinees);
	}
}


function HandleLoadSaveMatinees()
{
	local SeqAct_Interp matinee;
	local array <InterpData> matineeInterpData;
	local float endPos;
	local int i, j;


	for( i = mLoadSaveMatinees.Length - 1; i >= 0; --i )
	{
		matinee =  mLoadSaveMatinees[i];

		if(!matinee.bIsPlaying && !matinee.bReversePlayback)
		{
			continue;
		}

		matinee.GetInterpDataVars(matineeInterpData);
			
		if(matineeInterpData.Length <= 0)
		{
			mLoadSaveMatinees.Remove( i, 1 );

			continue; // No interp data
		}

		endPos = 0.0f;

		if(!matinee.bLooping)
		{
			for( j = 0; j < matinee.OutputLinks.Length; ++j )
			{
				matinee.OutputLinks[j].bDisabled = true;
				matinee.OutputLinks[j].bDisabledPIE = true;
			}
		}
		
		for(j = 0; j < matineeInterpData.Length; ++j)
		{
			endPos += matineeInterpData[j].InterpLength;
		}

		if(matinee.bReversePlayback)
		{
			// Reverse play -> Move it to the end without firing events
			matinee.SetPosition(endPos, true);

			// Now play it back with events fired -_-
			matinee.SetPosition(0.0f, false);
		}
		else
		{
			matinee.SetPosition(endPos, false);
		}

		mToReopenMatinees.AddItem(mLoadSaveMatinees[i]);

		mLoadSaveMatinees.Remove( i, 1 );

	}

	// If this is last matinee make sure we have HUD and not in cinematic
	if(mLoadSaveMatinees.Length == 0)
	{
		if(mPlayerControllerInstance.GetHud().GetHUDMode() == HM_CINEMATIC_SUBTITLE)
		{
			mPlayerControllerInstance.GetHud().SetHUDMode(HM_NORMAL);
			mPlayerControllerInstance.GetHud().ShowHUD();
		}

		if(mPlayerControllerInstance.IsInCinematicView())
		{
			mPlayerControllerInstance.ToggleCinematicView(false);
		}

		//Stops all matinee sfx
		self.PlayAkEvent(class'H7SoundController'.static.GetInstance().GetStopAllExceptMusicEvent());

		mRestoreSFX = true;
		
	}
}

function RestoreSFX()
{
	//If the map is loaded thourgh a savegame, reset all variables and stop the music timed for restart
	class'H7TransitionData'.static.GetInstance().SetIsReplayCombat(false);
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_ALL_MUSIC");
	SetTimer(1.1f, false, 'NewTurnInitAdventureMapMusic');
	//Restart the ambient nodes and refresh the list
	class'H7SoundController'.static.GetInstance().GetSoundManager().GetAmbientSoundNodeList();
	class'H7SoundController'.static.GetInstance().EnableSoundChannel( true );
	class'H7TransitionData'.static.GetInstance().SetIsMainMenu(false);

	mRestoreSFX = false;
}

function PreCompileShaders(){}

function RestoreCellState()
{
	// Restore Passability
	RestoreCellPassability();
	// Restore Layer 
	RestoreCellLayer();
	// Restore FOW
	RestoreCellFOW();
}

function RestoreCellPassability(){}

function RestoreCellLayer(){}

function RestoreCellFOW(){}

event AddCellPassabilityChange(SequenceAction cellChangeNode)
{
	mCellPassChanges.AddItem(cellChangeNode);
}

event AddCellLayerChange(SequenceAction cellChangeNode)
{
	mCellLayerChanges.AddItem(cellChangeNode);
}

event AddCellFOWChange(SequenceAction cellChangeNode)
{
	mCellFOWChanges.AddItem(cellChangeNode);
}

function PostBeginPlay()
{
	mGridManager = class'H7AdventureGridManager'.static.GetInstance();

	mPlayerControllerInstance = class'H7PlayerController'.static.GetPlayerController();
	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		InitAdvCntl();
		UpdatePlayerProfileStats();

		StreamInCouncilMap();

		mGameRevisionOriginal = class'H7GameData'.static.GetRevisionStr();
	}
}

function SetNewQuickCombatSeed( int seed )
{
	mRNGQuickCombat.InitRandom( seed );
}

function UpdatePlayerProfileStats()
{
	class'H7PlayerProfile'.static.GetInstance().HandleMapStart(mAdventureMapName, GetCampaign());
	// Tell profile about diff from Save
	class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(mGameSettings.mDifficultyParameters);
}

function StreamInCouncilMap()
{
	local array<name> mapArray;

	// Do it only for campaigns
	if(GetMapInfo() != none && GetMapInfo().GetMapType() == CAMPAIGN)
	{
		mapArray.AddItem(mCouncilMapLevel);

		ConsoleCommand("DisableAllScreenMessages");

		class'WorldInfo'.static.GetWorldInfo().PrepareMapChange(mapArray);

		class'H7Camera'.static.GetInstance().mCouncilGridCenter = mCouncilMapOffset;

		//class'WorldInfo'.static.GetWorldInfo().MapChangePositionOffset = mCouncilMapOffset;
		class'WorldInfo'.static.GetWorldInfo().CommitMapChange(true);
	}

	mCouncilMapInTransition = false;
}

function SwitchToCouncilMap()
{
	if(GetMapInfo() != none && GetMapInfo().GetMapType() == CAMPAIGN)
	{
		class'H7Camera'.static.GetInstance().UseCameraCouncilMap();

		mCouncilMapInTransition = true;
	}
}

// Called by camera when rendering of table is ready
function SwitchToCouncilMapReady()
{
	local LocalPlayer lp;

	if(GetMapInfo() != none && GetMapInfo().GetMapType() == CAMPAIGN)
	{
		H7AdventurePlayerController(GetALocalPlayerController()).SetFog(false);

		lp = LocalPlayer(mPlayerControllerInstance.Player);

		lp.RemoveAllPostProcessingChains();
		lp.InsertPostProcessingChain(mCouncilMapManager.GetMapPP(),INDEX_NONE,true);

		mPlayerControllerInstance.GetHUD().SetHUDMode(HM_MAPVIEW);
		mPlayerControllerInstance.GetHUD().GetDialogCntl().InitMapGUI();

		mCouncilMapActive = true;
		
	}

	mCouncilMapInTransition = false;
}

function SwitchToAdventureMap()
{
	if(GetMapInfo() != none && GetMapInfo().GetMapType() == CAMPAIGN)
	{
		mCouncilMapManager.DeactivateMap();
		class'H7Camera'.static.GetInstance().UseCameraAdventure();
		class'H7Camera'.static.GetInstance().SetDeltaDelay(1.0f);
	}

	mCouncilMapInTransition = false;
}

function SwitchToAdventureMapReady()
{
	local LocalPlayer lp;
		
	if(GetMapInfo() != none && GetMapInfo().GetMapType() == CAMPAIGN)
	{
		lp = LocalPlayer(mPlayerControllerInstance.Player);
		H7AdventurePlayerController(GetALocalPlayerController()).SetFog(true);
		// Restore original PP
		lp.RemoveAllPostProcessingChains();
		lp.InsertPostProcessingChain(mAdventurePP,INDEX_NONE,false);
		mAdventurePP = lp.GetPostProcessChain(0);

		class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().InitOutline();

		mCouncilMapActive = false;

		if(class'H7DialogCntl'.static.GetInstance().GetCouncilDialog().IsVisible()) class'H7DialogCntl'.static.GetInstance().ClosePopup();
	}

	mCouncilMapInTransition = false;
}

function int GetHumanPlayerIndex()
{
	local H7Player dasPlayer;
	local int i;

	foreach mPlayers( dasPlayer, i )
	{
		if( dasPlayer.GetStatus() == PLAYERSTATUS_ACTIVE && dasPlayer.GetPlayerType() == PLAYER_HUMAN )
		{
			return i;
		}
	}
	return 0; //return neutral player if no humans are available :|
}

function InitAdvCntl()
{
	local H7MapInfo levelMapInfo;
	local int i;
	local H7ScriptingController scriptController;
	local H7DifficultyParameters difParams;
	local LocalPlayer lp;
	local bool isFromLobby;
	local array<PlayerLobbySelectedSettings> playerList;
	local H7Player tmpPlayer, foundPlayer;
	local bool foundOppositePlayers;
	local H7Message message;
	
	super.PostBeginPlay();
	
	mPlayerControllerInstance.SetInLoadingScreen( false );

	lp = LocalPlayer(mPlayerControllerInstance.Player);
	// Save instance of PP for restoring when needed
	mAdventurePP = lp.GetPostProcessChain(0);

	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("MSG_INIT_GAME",MD_LOG,,H7PlayerReplicationInfo( class'H7ReplicationInfo'.static.GetInstance().GetALocalPlayerController().PlayerReplicationInfo ).GetPlayerNumber());

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mAdventureMapName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
	}

	//class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetAdventureController( self );
	
	if( mAdventureConfiguration != none ) { mConfigPath = PathName( mAdventureConfiguration ); }
	mIsInitialized = false;
	mMapInfo = H7MapInfo(class'WorldInfo'.static.GetWorldInfo().GetVanillaMapInfo());
	mSynchRNG = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG();
	mRNGQuickCombat = new class'H7HashRandom';

	mHeroEventParam = new class'H7HeroEventParam';
	mPlayerEventParam = new class'H7PlayerEventParam';
	mNeutralGrowthMultiplier = 1.0f;
	mGlobalTradeModifier = 1.0f;
	mHasUpgradeCostWeekEffect = false;
	mUpgradeCostWeekEffect = 1.0f;

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		scriptController = Spawn(class'H7ScriptingController');
		scriptController = scriptController;
		//SoundController init
		class'H7TransitionData'.static.GetInstance().SetIsReplayCombat(false);
		class'H7TransitionData'.static.GetInstance().SetIsMainMenu(false);
		class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("STOP_ALL_MUSIC");
		class'H7TransitionData'.static.GetInstance().SetIsInMapTransition(false);
		class'H7SoundController'.static.GetInstance().GetSoundManager().GetAmbientSoundNodeList();
		SetTimer(1.1f, false, 'NewTurnInitAdventureMapMusic');
		class'H7SoundController'.static.GetInstance().SetSoundSetting( class'H7SoundController'.static.GetInstance().GetSoundSetting() );
	}
	else
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
		{
			mCurrentPlayerIndex = FindLocalPlayer().GetPlayerNumber();
		}
	}

	// I am either in an editor level where a designer placed a grid(controller) or I am in a unit test level where nothing exists
	mGridManager = class'H7AdventureGridManager'.static.GetInstance();

	if(mGridManager != none)
	{
		mLandscapesList.Add( 1 );
		mLandscapesList.Remove( 0, 1 );

		//mGridManager.SetAdventureController(self);
				
		class'H7Camera'.static.GetInstance().UseCameraAdventure();

		if( class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
		{
			// the data in H7AdventureController is the data from the loaded file

			mCalendar.init();
			class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().Update();
			InitTeamManager();
			if( class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() )
			{
				class'H7TransitionData'.static.GetInstance().GetPlayersSettings(playerList);
				for( i = 0; i < playerList.Length; ++i )
				{
					if( playerList[i].mSlotState == EPlayerSlotState_AI )
					{
						GetPlayerByNumber( EPlayerNumber( playerList[i].mPosition ) ).SetPlayerType( PLAYER_AI );
					}
					else if( playerList[i].mSlotState == EPlayerSlotState_Closed )
					{
						tmpPlayer = GetPlayerByNumber( EPlayerNumber( playerList[i].mPosition ) );

						if( !tmpPlayer.IsNeutralPlayer() && !HasPlayerReplication( tmpPlayer.GetPlayerNumber() ) && tmpPlayer.GetStatus() == PLAYERSTATUS_ACTIVE )
						{
							message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mPlayerDisconnected.CreateMessageBasedOnMe();
							message.AddRepl("%player", playerList[i].mName);
							class'H7MessageSystem'.static.GetInstance().SendMessage(message);

							tmpPlayer.SetStatus( PLAYERSTATUS_UNUSED );
							RemoveArmiesOfPlayer(tmpPlayer);
						}
					}
				}
			}			
		}
		else
		{
			levelMapInfo = GetMapInfo();
			
			// no tracking (hero recruit) for scenario maps
			if (GetMapInfo().GetMapType() != SCENARIO)  
				isFromLobby = true;
			
			// If we are not a Loaded Game
			if(!class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame())
			{
				if(class'H7TransitionData'.static.GetInstance() != none)
				{
					class'H7TransitionData'.static.GetInstance().IsStartingCampaign(mCampaign);
				}
			}
			
			if(GetCampaign() != none)
			{
				difParams = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficulty();
				mDifficultyPlayerStartResourcesMultiplier   = mAdventureConfiguration.mDifficultyPlayerStartResourcesMultiplierCampaign	[difParams.mStartResources];
				mDifficultyCritterStartSizeMultiplier    	= mAdventureConfiguration.mDifficultyCritterStartSizeMultiplierCampaign		[difParams.mCritterStartSize];
				mDifficultyCritterGrowthRateMultiplier		= mAdventureConfiguration.mDifficultyCritterGrowthRateMultiplierCampaign	[difParams.mCritterGrowthRate];
			}
			else
			{
				difParams = class'H7TransitionData'.static.GetInstance().GetGameSettings().mDifficultyParameters;
				mDifficultyPlayerStartResourcesMultiplier   = mAdventureConfiguration.mDifficultyPlayerStartResourcesMultiplier	[difParams.mStartResources];
				mDifficultyCritterStartSizeMultiplier    	= mAdventureConfiguration.mDifficultyCritterStartSizeMultiplier		[difParams.mCritterStartSize];
				mDifficultyCritterGrowthRateMultiplier		= mAdventureConfiguration.mDifficultyCritterGrowthRateMultiplier	[difParams.mCritterGrowthRate];
			}
			
			mHallOfHeroesManager = new class'H7HallOfHeroesManager'();
			mCalendar = new class'H7Calendar';
			mCalendar.init();
			mTurnCounter = 1;
			
			class'H7TransitionData'.static.GetInstance().SetupPlayers();
			
			InitTemplatePlayersAndArmies();
			InitPathfinder();
			InitTeamManager();
			mGridManager.InitFOWControllers();
			
			levelMapInfo = GetMapInfo();
			if (levelMapInfo != None)
			{
				;
				mCalendar.SetCalendarDay(levelMapInfo.GetStartDay() );
				mCalendar.SetCalendarWeek(levelMapInfo.GetStartWeek() );
				mCalendar.SetCalendarMonth(levelMapInfo.GetStartMonth() );
				mCalendar.SetCalendarYear(levelMapInfo.GetStartYear() );
			}
			else
			{
				;
			}		
			mCalendar.InitializeGameStartWeek();

			mMapSettings = class'H7TransitionData'.static.GetInstance().GetMapSettings();
			class'H7TransitionData'.static.GetInstance().GetPlayersSettings(mPlayerSettings);

			if( !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
			{
				for( i = 0; i < mPlayerSettings.Length; ++i )
				{
					if( mPlayerSettings[i].mFaction != none && mPlayerSettings[i].mFactionRef == "" )
					{
						mPlayerSettings[i].mFactionRef = mPlayerSettings[i].mFaction.GetArchetypeID();
					}
				}
			}

			mGameSettings = class'H7TransitionData'.static.GetInstance().GetGameSettings();			

			if(!class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
			{
				// Get difficulty
				if(GetCampaign() != none)
				{
					mGameSettings.mDifficulty = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficultyConverted();
					mGameSettings.mDifficultyParameters = class'H7PlayerProfile'.static.GetInstance().GetSelectedDifficulty();
				}
				else
				{
					mGameSettings.mDifficulty = class'H7TransitionData'.static.GetInstance().GetGameSettings().mDifficulty;
					mGameSettings.mDifficultyParameters = class'H7TransitionData'.static.GetInstance().GetGameSettings().mDifficultyParameters;
				}
					
			}
		}

		PreCompileShaders();

		// Set GameSpeed
		SetGameSpeed();

		InitPersistentObjects();
		
		//mHallOfHeroesManager.Init( GetPlayers(), self ); // needs the towns to be initializied
		
		if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
		{
			for(i=mPlayers.Length - 1; i > 0; i--)
			{
				if(mPlayers[i].GetStatus() == PLAYERSTATUS_ACTIVE)
				{
					EndPlayerTurn(i, false, true); // TODO StartPlayerTurn
				}
			}
		}
		else
		{
			EndPlayerTurn(mCurrentPlayerIndex, !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame(), true); // TODO StartPlayerTurn
		}

		mCursor = new class'H7AdventureCursor'();

		InitFCT();
		InitCameraActionController();
		InitAdventureAI();

		InitEventManageables();
		

		//class'H7TurnOverCntl'.static.GetInstance().InitHotSeat();

		if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager() != none)
		{
			if(class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().GetStateReward_PM() && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().CanRewardBeUsed() )
			{
				mPlayerControllerInstance.SetPixellated(true);
			}
		}
		
		if( class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
		{
			// Recrate part of GUI
			if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() || IsHotSeat())
			{
				class'H7ReplicationInfo'.static.GetInstance().InitMPTurnGUI();
			}

			class'H7AdventureHudCntl'.static.GetInstance().CheckForAdventureController();
		}


		SetTimer(1.0f, false, 'ApplyGameModeGfxSettings');
		SetTimer(1.0f, false, 'ApplyOutline');
	}
	else
	{
		;
	}

	if(GetCampaign() != none || GetMapInfo().GetMapType() == CAMPAIGN) // If this is campaign -> Disable Team Trade
	{
		mGameSettings.mTeamsCanTrade = false;
	}

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		AutoFocusArmyForPlayer(GetLocalPlayer());
		if( !mPlayerControllerInstance.IsServer() )
		{
			TrackingGameStart();
		}
	}
	else
	{
		
		if( class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
		{
			/** TRACKING */
			TrackingGameStart();
		}

		InitTransitionSaveGame();
	}

	SetTimer( 1.0f, false, 'UpdateFogAndAoCVisibilityDelayed' );

	
	/** TRACKING */
	TrackingMapStart();

	/** TRACKING */ 
	if( isFromLobby ) 	
		TrackingRecruitHero();

	if(GetALocalPlayerController() != none)
	{
		mAdventurePlayerController = H7AdventurePlayerController(GetALocalPlayerController());
	}

	if(mAI!=None) 
	{
		mAI.GetSensors().GetSensorIConsts().StartAdventure();
	}

	class'H7GameData'.static.GetInstance().ClearUsedGenericTownNames();

	class'H7ReplicationInfo'.static.GetInstance().SetAutoSaveEnabled( mPlayerControllerInstance.GetHUD().GetProperties().GetOptionAutosaveEnabled() );

	mIsInitialized = true;

	if( class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		class'H7ScriptingController'.static.TriggerEvent(class'H7SeqEvent_MapLoaded', 1);
	}
	
	// check if there are at least two opponents left after discarding disconnected players
	if(WorldInfo.GRI.IsMultiplayerGame())
	{
		foreach mPlayers(tmpPlayer)
		{
			if(!tmpPlayer.IsNeutralPlayer() && tmpPlayer.GetStatus() != PLAYERSTATUS_UNUSED)
			{
				if(foundPlayer == none)
				{
					foundPlayer = tmpPlayer;
				}
				else if(tmpPlayer.IsPlayerHostile(foundPlayer))
				{
					foundOppositePlayers = true;
					break;
				}
			}
		}

		if(!foundOppositePlayers && mPlayerControllerInstance.IsServer())
		{
			class'H7TransitionData'.static.GetInstance().SetMPServerLostConnectionToClients( true );
			class'H7ReplicationInfo'.static.GetInstance().GoToMainMenu();
		}

		H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).SetPlayerFinishedLoading();
	}

	if(!class'H7TransitionData'.static.GetInstance().GetMPServerLostConnectionToClients())
	{
		mPlayerControllerInstance.ScanForAllSaveGames();
	}

	// Ensure cleanup of useme
	if(class'H7TransitionData'.static.GetInstance().UseMe() )
	{
		class'H7TransitionData'.static.GetInstance().SetUseMe( false ); 
	}
	
	if(Caps(class'H7TransitionData'.static.GetInstance().GetRandomMapFileName()) == Caps(class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName()))
	{
		// This is RMGAdventure map, set the bool
		mIsRMGMap = true;
	}

	if(!WorldInfo.GRI.IsMultiplayerGame())
	{
		CheckYourPrivilege(GetLocalPlayer(false));
	}
}

function InitEventManageables(){}
function InitPathfinder(){}

// Check faction privilege of human players, if they dont have it. It kicks them out. This prevents trading saves vanila->addon/addon->vanilla
function CheckYourPrivilege(H7Player player){}

function SetGameSpeed()
{
	if( class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() )
	{
		class'H7ReplicationInfo'.static.GetInstance().ModifyGameSpeedMPAdventure( mGameSettings.mGameSpeedAdventure ); // FROM LOBBY MP
		class'H7ReplicationInfo'.static.GetInstance().ModifyGameSpeedMPCombat(mGameSettings.mGameSpeedCombat);
	}
	else
	{
		if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() && GetCampaign() == none )
		{
			class'H7ReplicationInfo'.static.GetInstance().ModifyGameSpeedAdventure( mGameSettings.mGameSpeedAdventure ); // FROM LOBBY SP
			class'H7ReplicationInfo'.static.GetInstance().ModifyGameSpeedCombat(mGameSettings.mGameSpeedCombat);
		}
	}
	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() && !class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() && GetCampaign() == none )
	{
		class'H7ReplicationInfo'.static.GetInstance().ModifyGameSpeedAdventureAI( mGameSettings.mGameSpeedAdventureAI );
	}
}

function CheckVictoryCondition(){}

function EGameMode GetCurrentGameMode()
{
	if( WorldInfo.GRI.IsMultiplayerGame() )
	{
		return MULTIPLAYER;
	}
	else if(IsHotSeat())
	{
		return HOTSEAT;
	}
	else
	{
		return SINGLEPLAYER;
	}
}

protected function UpdateFogAndAoCVisibilityDelayed()
{
	mGridManager.GetCurrentGrid().GetFOWController().UpdateFogVisibility();
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateAreaOfControl();
}

protected function InitAdventureMapMusic()
{
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("ADVENTURE_MAP");
}

protected function NewTurnInitAdventureMapMusic()
{
	class'H7SoundController'.static.GetInstance().SetNextTurn(true);
	class'H7SoundController'.static.GetInstance().UpdateMusicGameStateSwitch("ADVENTURE_MAP");
}

private function InitTransitionSaveGame()
{
	local string currMap;
	local int lastMapIdxInCampaignQueue;
	local H7CampaignDefinition currentCampaign;

	currentCampaign = GetCampaign();

	if( currentCampaign == none ) return;

	currMap = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();

	lastMapIdxInCampaignQueue = currentCampaign.GetMapIndex(currMap);
	lastMapIdxInCampaignQueue -= 1;

	if (lastMapIdxInCampaignQueue != INDEX_NONE && lastMapIdxInCampaignQueue > -1)
	{
		//mPlayerControllerInstance.ConsoleCommand("LoadPlayerProfileState "$"TransitionSave_" $ currentCampaign.ObjectArchetype.Name $ lastMapIdxInCampaignQueue);
	}
}

private function InitTeamManager()
{
	mTeamManager = new(self) class'H7TeamManager';
	mTeamManager.InitTeamManager();
}

function SortTownList()
{
	mTownList.Sort(TownCompare);
}

// this is how towns are sorted in the global map list
// - players will pick their town out of this while maintaining the order
// - we sort Z->A, because the list is shown from bottom to top in the GUI:
// n = Atown
// ...
// 1 = Stown
// 0 = Ztown
function int TownCompare(H7Town a,H7Town b)
{
	if(a.GetName() > b.GetName()) return 1; // ok keep it
	if(a.GetName() < b.GetName()) return -1; // swap it
	return 0;
}

function HideAllHeroFX()
{
	local H7AdventureArmy army;
	local array<H7AdventureArmy> armiesOnMap;

	GetArmiesCurrentlyOnMap(armiesOnMap);
	mIsHeroFXHidden = true;
	foreach armiesOnMap( army )
	{
		army.GetHero().GetHeroFX().HideDecalFX();
		if( army.GetFlag() != none )
		{
			army.GetFlag().SetHidden( true );
		}
	}
}

function ShowAllHeroFX()
{
	local H7AdventureArmy army;
	local array<H7AdventureArmy> armiesOnMap;

	GetArmiesCurrentlyOnMap(armiesOnMap);
	mIsHeroFXHidden = false;
	foreach armiesOnMap( army )
	{
		army.GetHero().GetHeroFX().ShowDecalFX();
		if( army.GetFlag() != none && !army.IsHidden() )
		{
			army.GetFlag().SetHidden( false );
		}
	}
	class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetFOWController().ExploreFog();
}

function SetAllAOCSitesOfPlayerToNeutral(H7Player pl)
{
	local H7AdventureObject advObj;
	local H7AreaOfControlSite site;

	foreach mAdventureObjectList( advObj )
	{
		site = H7AreaOfControlSite(advObj);

		if( site != none && site.GetPlayer() == pl )
		{
			//Prevents the SFX from playing, while preparations are made
			site.SetInitState(true);

			site.SetSiteOwner(PN_NEUTRAL_PLAYER);

			site.SetInitState(false);
		}
	}
}

function HideAllSiteFlags()
{
	local H7AdventureObject advObj;
	foreach mAdventureObjectList( advObj )
	{
		if( H7AreaOfControlSite( advObj ) != none )
		{
			if( H7AreaOfControlSite( advObj ).GetFlag() != none )
			{
				H7AreaOfControlSite( advObj ).GetFlag().SetHidden( true );
			}
		}
	}
}

function ShowAllSiteFlags()
{
	local H7AdventureObject advObj;
	foreach mAdventureObjectList( advObj )
	{
		if( H7AreaOfControlSite( advObj ) != none && !advObj.bHidden )
		{
			if( H7AreaOfControlSite( advObj ).GetFlag() != none )
			{
				H7AreaOfControlSite( advObj ).GetFlag().SetHidden( false );
			}
		}
	}
}


function ApplyGameModeGfxSettings()
{
	if (mPlayerControllerInstance == None)
	{
		SetTimer(1.0f, false, 'ApplyGfxSettings');
		return;
	}

	mPlayerControllerInstance.ApplyGameModeGfxSettings(false);
}

function ApplyOutline()
{
	if (mPlayerControllerInstance == None)
	{
		SetTimer(1.0f, false, 'ApplyOutline');
		return;
	}

	class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().ApplyGameTypeEffect(false);
}

function InitFCT()
{
	if( class'H7FCTController'.static.GetInstance() == none )
	{
		Spawn(class'H7FCTController', self);
	}
}

function InitCameraActionController()
{
	if( class'H7CameraActionController'.static.GetInstance() == none )
	{
		Spawn(class'H7CameraActionController', self,,,,mCameraActionTemplate,true);
	}
}

protected function InitAdventureAI()
{
	mAI = Spawn(class'AIModH7AiAdventureMap', self);
}

function bool IsArmyOnMap( H7AdventureArmy army ){}

// Add an army to the list of armies on the map
function int AddArmy( H7AdventureArmy army )
{
	local int index;
	index = -1;

	if( army.IsDead() )
	{ 
		;
		return index;
	} 
	
	if( mArmies.Find( army ) == INDEX_NONE )
	{
		index = mArmies.AddItem( army );
		army.HandleAddToMap();
	}
	else if( army.GetHero() != none && army.GetHero().IsHero() )
	{
		// the army is already registered, but not visible to the minimap, therefore we make it so
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddHero( army.GetHero() );
	}

	return index;
}

function AddArmyAtIndex( H7AdventureArmy army, int index )
{
	if( army.IsDead() )
	{ 
		;
		return;
	} 
	
	if( mArmies.Find( army ) == INDEX_NONE )
	{
		if(mArmies.Length < index)
		{
			if(mArmiesSizeOnSave != -1)
			{
				mArmies.Length = mArmiesSizeOnSave;
			}
			else
			{
				mArmies.Length = index + 1;
			}
			
		}

		// Ensure that we dont remove somebody from the list
		if( mArmies[index] == none)
		{
			mArmies[index] = army;
		}
		else
		{
			mArmies.AddItem( army );
		}
		
		army.HandleAddToMap();
	}
	else if( army.GetHero() != none && army.GetHero().IsHero() )
	{
		// the army is already registered, but not visible to the minimap, therefore we make it so
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddHero( army.GetHero() );
	}
}

function AddCaravan( H7CaravanArmy army )
{ 
	local H7Faction caravanFaction;
	local H7HeroVisuals caravanVisuals;

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().AddCaravan( army.GetCaravan() );

	if( mActiveCarravans.Find( army ) == -1 ) 
	{
		mActiveCarravans.AddItem( army ); 
	}

	caravanFaction = army.GetStrongestCreature().GetFaction();
	caravanVisuals = caravanFaction.GetCaravanVisuals();
	army.GetHero().SetVisuals(caravanVisuals);

	army.LoadMeshes( false );
	army.GetHero().InitFX();
	army.GetHero().SpawnAnimControl();
	army.GetHero().GetSelectionFX().SetBase( army.GetHero() );
	army.SpawnHeroFlag();
}

function GetAllTargetable( out array<H7IEffectTargetable> targets ){}

function H7Player GetPlayerByNumber( EPlayerNumber playerNumber){};

function array<H7Player> GetActivePlayers(bool ignoreNeutral)
{
	local int i;
	local array<H7Player> result;

	for(i = 0; i < mPlayers.Length; ++i )
	{
		if( ignoreNeutral && mPlayers[i].GetPlayerNumber() == PN_NEUTRAL_PLAYER )
		{
			continue;
		}

		if( mPlayers[i].GetStatus() == PLAYERSTATUS_ACTIVE )
		{
			result.AddItem(mPlayers[i]);
		}
	}
	return result;
}

function H7Player GetAnyActivePlayer(bool ignoreNeutral)
{
	local int i;

	for(i = 0; i < mPlayers.Length; ++i )
	{
		if( ignoreNeutral && mPlayers[i].GetPlayerNumber() == PN_NEUTRAL_PLAYER )
		{
			continue;
		}

		if( mPlayers[i].GetStatus() == PLAYERSTATUS_ACTIVE )
		{
			return mPlayers[i];
		}
	}
}
// Return player by index on mPlayers list
function H7Player GetPlayerByIndex( int index )
{
	if( index > -1 && index < mPlayers.Length)
	{
		return mPlayers[index];
	}
	else
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("mPlayers at index" @ index @ "has no player object, add more players to map",MD_QA_LOG);;
		//ScriptTrace();

		return GetNeutralPlayer();
	}
}

function int GetRemainingActivePlayerCount()
{
	local H7Player thePlayer;
	local int count;

	foreach mPlayers(thePlayer)
	{
		if(thePlayer.GetStatus() == PLAYERSTATUS_ACTIVE)
		{
			count++;
		}
	}

	return count;
}

function H7Player GetPlayerByID( int playerID )
{
	local int i;

	for(i = 0; i < mPlayers.Length; i++)
	{
		if(mPlayers[i].GetID() == playerID) return mPlayers[i];
	}
	
	class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("did not find player with ID" @ playerID,MD_QA_LOG);;
	return none;
}


function RemoveCaravan( H7CaravanArmy caravan ) 
{
	if( caravan == none ) 
		return; 

	mActiveCarravans.RemoveItem( caravan );
	mArmies.RemoveItem( caravan );
	caravan.GetCell().UnregisterArmy( caravan );
	caravan.ClearMeshData();
	caravan.GetHero().ClearHeroMeshData();
	caravan.Destroy();
}

function RemoveArmiesOfPlayer(H7Player pl)
{
	local H7AdventureArmy army;
	local H7CaravanArmy caravan;

	foreach mArmies( army )
	{
		if( army.GetPlayer() == pl )
		{
			RemoveArmy(army);
		}
	}

	
	foreach mActiveCarravans( caravan )
	{
		if( caravan.GetPlayer() == pl )
		{
			RemoveArmy(caravan);
		}
	}

	if (mPlayerControllerInstance.GetAdventureHud() != None)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().Update();
	}
}

event RemoveArmy( H7AdventureArmy army )
{
	if( GetSelectedArmy() == army )
	{
		SetSelectedArmy(none);
	}

	if( army.IsA('H7CaravanArmy') )
	{
		RemoveCaravan(H7CaravanArmy(army));
	}
	else
	{
		mArmies.RemoveItem( army );
	}

	army.SetIsDead( true );

	army.ClearMeshData();
	if( army.GetHero() != none )
	{
		army.GetHero().ClearHeroMeshData();
		army.GetHero().GetEffectManager().ResetFX();
	}

	if( army == GetSelectedArmy() ) // OPTIONAL how can this ever be true if above we set SetSelectedArmy(none); ?
	{
		AutoSelectArmy( true );
	}

	//update minimap icons
	if (mPlayerControllerInstance.GetAdventureHud() != None)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().Update();
	}
}

function RemoveArmyOnlyFromList( H7AdventureArmy army )
{
	if(mArmies.Find( army ) != INDEX_NONE)
	{
		mArmies.RemoveItem( army );
	}
}

function bool IsAnyArmyBeingRemoved()
{
	local H7AdventureArmy army;

	foreach mArmies( army )
	{
		if( army.IsBeingRemoved() )
		{
			return true;
		}
	}
	return false;
}

/**
 * Initialises and returns a neutral player, 
 * with a hardcoded player number.
 * */

protected function H7Player CreateNeutralPlayer()
{
	local H7Player neutralPlayer;
	
	neutralPlayer = Spawn( class'H7Player',,'name' );
	neutralPlayer.SetName( class'H7Loca'.static.LocalizeSave("NEUTRAL_PLAYER","H7General") );
	neutralPlayer.SetPlayerColor( PCOLOR_NEUTRAL );
	neutralPlayer.SetPlayerNumber( 0 );
	neutralPlayer.SetPlayerType( PLAYER_AI );

	return neutralPlayer;
}

event H7Player GetNeutralPlayer()
{
	return mPlayers[0];
}

// only called for new games, can use TransitionData
protected function InitTemplatePlayersAndArmies()
{
	local H7Player tmpPlayer;
	local H7PlayerStart newPlayerStart;
	local int i,j;
	local array<PlayerLobbySelectedSettings> playerList;
	local array<MapInfoPlayerProperty> playerListMap;
	local EPlayerType playerType;
	local bool playerCouldNotConnectToServer;
	local H7Message message;
	local H7ReplicationInfo repInfo;
	local H7Faction tempFaction;

	repInfo = class'H7ReplicationInfo'.static.GetInstance();

	playerListMap = GetMapInfo().GetPlayerProperties(); // this is a collapsed version of the settings, where all closed slots disappeared

	// If editor or direct-map-start or campaign
	if(!class'H7TransitionData'.static.GetInstance().UseMe()) 
	{
		// this is a start from editor or direct-map-start or campaign
		repInfo.InitLobbyDataByMapInfo(GetMapInfo());
		repInfo.WriteLobbyDataToTransitionData( false );
	}
	else
	{
		class'H7TransitionData'.static.GetInstance().SetUseMe( false ); 
	}
	
	;
	
	class'H7TransitionData'.static.GetInstance().GetPlayersSettings(playerList);
	
	if(!class'H7TransitionData'.static.GetInstance().UseMapDefaults()) // this is a uncollapsed version of the settings, with closed slots, like 1:1 in the lobby screen
	{
		// TeamSetup MapDefault
		if(class'H7TransitionData'.static.GetInstance().GetTeamSetup() == TEAM_MAP_DEFAULT)
		{
			for(i = 0; i < playerList.Length; i++)
			{
				j=i+1;
				if( j < playerListMap.Length)
				{
					playerList[i].mTeam = playerListMap[j].mTeam;
				}
			}
		}
	}
	
	// init neutral player
	tmpPlayer =  CreateNeutralPlayer();
	mPlayers.AddItem( tmpPlayer );
	
	// init players
	for( i = 0; i < playerListMap.Length; ++i )
	{
		j = i + 1;
		if( j >= playerListMap.Length )
		{
			break;
		}
		switch(playerListMap[j].mSlot)
		{
		case EPlayerSlot_UserDefine:

			if(playerList[i].mSlotState == EPlayerSlotState_Undefined) // play in editor or lobby fail
			{
				playerType = PLAYER_HUMAN;
			}
			else if(playerList[i].mSlotState == EPlayerSlotState_Closed)
			{
				// closed slots become...? seems to work even though there is no code here ¯\_(?)_/¯
						
			}
			else if(playerList[i].mSlotState == EPlayerSlotState_Occupied)
			{
				playerType = PLAYER_HUMAN;
			}
			else if(playerList[i].mSlotState == EPlayerSlotState_AI)
			{
				playerType = PLAYER_AI;

			}
			else if(playerList[i].mSlotState == EPlayerSlotState_Open) // open slots become hotseat humans
			{
				playerType = PLAYER_HUMAN;
			}
			else
			{
				;
			}
			break;
		case EPlayerSlot_Human:
			playerType = PLAYER_HUMAN;
			break;
		case EPlayerSlot_AI:
			playerType = PLAYER_AI;
			break;
		default:
			playerType = PLAYER_HUMAN;
			break;
		}

		// We create a player object that has the settings of a certain row (lobby) index i and the player number of the position (player) he wants to play:
		tmpPlayer = Spawn( class'H7Player',, name( playerList[i].mName ) );
		tmpPlayer.SetPlayerNumber( playerList[i].mPosition );

		tmpPlayer.SetTeamNumber( playerList[i].mTeam );
		tmpPlayer.SetName(playerList[i].mName); // set already localized name
		//`LOG("tmpPlayer.SetName"@i@playerList[i].mName);
		tmpPlayer.SetControlledByAI( playerType == PLAYER_AI );

		if( playerType == PLAYER_AI )
		{
			if( GetMapInfo().GetMapType() == CAMPAIGN || GetMapInfo().GetMapType() == SCENARIO )
			{
				tmpPlayer.SetAICreatureGrowthRateMultiplier( mAdventureConfiguration.mDifficultyAICreatureGrowthRateMultiplierCampaign[playerList[i].mAIDifficulty] );
				tmpPlayer.SetAIResourceIncomeMultiplier( mAdventureConfiguration.mDifficultyAIResourceIncomeMultiplierCampaign[playerList[i].mAIDifficulty] );
				tmpPlayer.SetAIStartResourceMultiplier( mAdventureConfiguration.mDifficultyAIStartResourcesMultiplierCampaign[playerList[i].mAIDifficulty] );
			}
			else
			{
				tmpPlayer.SetAICreatureGrowthRateMultiplier( mAdventureConfiguration.mDifficultyAICreatureGrowthRateMultiplier[playerList[i].mAIDifficulty] );
				tmpPlayer.SetAIResourceIncomeMultiplier( mAdventureConfiguration.mDifficultyAIResourceIncomeMultiplier[playerList[i].mAIDifficulty] );
				tmpPlayer.SetAIStartResourceMultiplier( mAdventureConfiguration.mDifficultyAIStartResourcesMultiplier[playerList[i].mAIDifficulty] );
			}
			tmpPlayer.SetAIAggresivenessMultiplier( mAdventureConfiguration.mDifficultyAIAggressivenessMultiplier[playerList[i].mAIDifficulty] );
		}
		else
		{
			tmpPlayer.SetAICreatureGrowthRateMultiplier( 1.0f );
			tmpPlayer.SetAIResourceIncomeMultiplier( 1.0f );
			tmpPlayer.SetAIStartResourceMultiplier( 1.0f );
			tmpPlayer.SetAIAggresivenessMultiplier( 1.0f );
		}

		tmpPlayer.SetPlayerType(playerType);
		tmpPlayer.SetDiscoveredFromStart(playerListMap[j].mDiscoveredFromStart );
		tmpPlayer.SetPlayerColor( playerList[i].mColor );
		tmpPlayer.SetForbiddenHeroes( playerListMap[j].mForbiddenHeroes );
		if (GetMapInfo() == none)
		{
			tmpPlayer.SetResourceSetTemplate( class'H7GameData'.static.GetInstance().GetResourceSet() );
		}
		else
		{
			tmpPlayer.SetResourceSetTemplate( GetMapInfo().GetResourceSet() );
		}
		
		if(playerList[i].mFaction != none) // If we have faction set it
		{
			tmpPlayer.SetFaction(playerList[i].mFaction);
		}
		else if( playerList[i].mFactionRef != "") // If not try to read from archetype
		{
			tempFaction = class'H7GameData'.static.GetInstance().GetFactionByArchetypeID( playerList[i].mFactionRef );

			if(tempFaction != none)
			{
				tmpPlayer.SetFaction(tempFaction);
			}	
		} // If all fails it will be randomly selected
		;
		
		tmpPlayer.Init();
		tmpPlayer.InitAIPlayerName();

		if( playerListMap[j].mUseCustomStartingResource )
		{
			tmpPlayer.GetResourceSet().SetResource( playerListMap[j].mCustomStartingGold.Type, playerListMap[j].mCustomStartingGold.Amount );
			tmpPlayer.GetResourceSet().SetResource( playerListMap[j].mCustomStartingWood.Type, playerListMap[j].mCustomStartingWood.Amount );
			tmpPlayer.GetResourceSet().SetResource( playerListMap[j].mCustomStartingOre.Type, playerListMap[j].mCustomStartingOre.Amount );
			tmpPlayer.GetResourceSet().SetResource( playerListMap[j].mCustomStartingDragonSteel.Type, playerListMap[j].mCustomStartingDragonSteel.Amount );
			tmpPlayer.GetResourceSet().SetResource( playerListMap[j].mCustomStartingShadowSteel.Type, playerListMap[j].mCustomStartingShadowSteel.Amount );
			tmpPlayer.GetResourceSet().SetResource( playerListMap[j].mCustomStartingStarSilver.Type, playerListMap[j].mCustomStartingStarSilver.Amount );
			tmpPlayer.GetResourceSet().SetResource( playerListMap[j].mCustomStartingDragonBloodCrystal.Type, playerListMap[j].mCustomStartingDragonBloodCrystal.Amount );
		}
		
		if( WorldInfo.GRI.IsMultiplayerGame() && playerType != PLAYER_AI)
		{
			// lets check if the player could connect to the server, if not we will consider him as a closed slot
			playerCouldNotConnectToServer = !HasPlayerReplication( tmpPlayer.GetPlayerNumber() );
			if( playerCouldNotConnectToServer && playerList[i].mSlotState != EPlayerSlotState_Closed )
			{
				message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mPlayerDisconnected.CreateMessageBasedOnMe();
				message.AddRepl("%player",playerList[i].mName);
				class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			}
		}
		else
		{
			playerCouldNotConnectToServer = false;
		}

		if( playerList[i].mSlotState == EPlayerSlotState_Closed || playerCouldNotConnectToServer )
		{
			tmpPlayer.SetStatus( PLAYERSTATUS_UNUSED );
		}
		else
		{
			tmpPlayer.SetStatus( playerListMap[j].mInitActive ? PLAYERSTATUS_ACTIVE : PLAYERSTATUS_INACTIVE );
		}
		mPlayers.AddItem( tmpPlayer );	
	}

	// set up the order of the mPlayers array so that they are ordered by playernumber
	mPlayers.Sort(PlayerCompare);	

	foreach mPlayers(tmpPlayer)
	{
		tmpPlayer.InitThievesGuildManager(mPlayers);
		if(tmpPlayer == GetLocalPlayer()) continue;
		if(tmpPlayer.GetPlayerType() == PLAYER_AI) continue;
		if(tmpPlayer.GetStatus() == PLAYERSTATUS_UNUSED) continue;
		class'H7LogSystemCntl'.static.GetInstance().GetChat().AddPlayerToChat(tmpPlayer.GetNameHTMLColored(),CHAT_WHISPER + tmpPlayer.GetPlayerNumber());
	}


	// check if the players were set in the world info
	if( mPlayers.Length == 0 )
	{
		;
	}

	InitTemplateArmies();

	// init playerstarts
	foreach GetWorldInfo().DynamicActors( class'H7PlayerStart', newPlayerStart )
	{
		newPlayerStart.Hatch();
	}

	SetCurrentPlayerIndex( 0 );

	//InitAIFog();
}

function InitAIFog()
{
	local H7Player tmpPlayer;

	foreach mPlayers( tmpPlayer )
	{
		if( tmpPlayer.IsControlledByAI() )
		{
			class'H7AdventurePlayerController'.static.GetAdventurePlayerController().RevealFog( tmpPlayer.GetPlayerNumber() );
		}
	}
}

function InitTemplateArmies(){}

protected function bool HasPlayerReplication( EPlayerNumber playerNumber )
{
	local array<PlayerReplicationInfo> PRIarray;
	local PlayerReplicationInfo PRI;
	local H7PlayerReplicationInfo H7PRI;

	PRIarray = class'H7ReplicationInfo'.static.GetInstance().PRIArray;
	foreach PRIarray( PRI )
	{
		H7PRI = H7PlayerReplicationInfo(PRI);
		if( H7PRI.GetPlayerNumber() == playerNumber )
		{
			return true;
		}
	}

	return false;
}

protected function int PlayerCompare(H7Player a,H7player b)
{
	if(a.GetPlayerNumber() < b.GetPlayerNumber()) return 1; // ok keep it
	if(a.GetPlayerNumber() > b.GetPlayerNumber()) return -1; // swap it
	return 0;
}

protected function InitPersistentObjects()
{
	local bool isLoaded;

	isLoaded = class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame();

	InitPersistentObjectsNative( isLoaded );

	;
	if( class'Engine'.static.IsEditor() && mTearOfAshaCoordinates.X != -1 && mTearOfAshaCoordinates.Y != -1 )
	{
		DrawDebugSphere( mGridManager.GetCell( mTearOfAshaCoordinates.X, mTearOfAshaCoordinates.Y, mTearOfAshaGridIndex ).GetLocation(), 100, 16, 255, 0, 0, true );
	}
}

function InitPersistentObjectsNative( bool isLoaded ){}

function DehighlightAdventureObjects(){}

function OutlineAdventureObject(H7AdventureObject advObject, optional Color outlineColor, optional bool showOutline=true){}
//{
//	//if(!advObject.GetMeshComp().bOutlined)
//	//{
//	//	`warn("H7AdventurePlayerController: Want to outline"@advObject@advObject.GetName()@"but it can't be outlined!");
//	//	return;
//	//}

//	advObject.GetMeshComp().SetOutlined( showOutline );

//	if(showOutline)
//	{
//		advObject.GetMeshComp().SetOutlineColor( outlineColor );
//	}
//}

function H7Town GetAoCOwnerByWorldLocation( Vector point )
{
	local H7AdventureMapCell cell;
	local H7AdventureGridManager gridManager;
	local H7Town currentTown;
	local int areaOfControlIndex;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	cell = class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( point );

	areaOfControlIndex = gridManager.GetAoCIndexOfCell( cell );
	
	if( areaOfControlIndex == -1 )
	{
		return none;
	}

	foreach mTownList( currentTown )
	{
		if( currentTown.GetAreaOfControlID() == areaOfControlIndex )
		{
			return currentTown;
		}
	}
	return none;
}

//=============================================================================
// Actions
//=============================================================================

public function bool CanQueueCommand()
{
	return !class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() 
		|| !mPlayerControllerInstance.IsCommandRequested()
		|| GetCurrentPlayer().IsControlledByAI();
}

function SetActiveUnitCommand_Move( array<H7BaseCell> path )
{
	if(!CanQueueCommand())
	{
		return;
	}
	// MOVE
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_MOVE, ACTION_MOVE,,,path ) );
}

function SetActiveUnitCommand_MoveMeet( array<H7AdventureMapCell> path, H7IEffectTargetable target )
{
	if(!CanQueueCommand())
	{
		return;
	}
	// MOVE
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_MOVE, ACTION_MOVE_MEET,,,path ) );
	// MEET
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_MEET,,, target,,,,,,,,false ) );
}

function SetActiveUnitCommand_MoveVisit( array<H7AdventureMapCell> path, H7VisitableSite targetSite )
{
	if(!CanQueueCommand())
	{
		return;
	}
	// MOVE
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_MOVE, ACTION_MOVE_VISIT,,,path ) );
	// VISIT
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_VISIT,,, targetSite,,,,,,,,false ) );
}

function SetActiveUnitCommand_MoveVisitAndRecruit( array<H7AdventureMapCell> path, H7VisitableSite targetSite )
{
	// MOVE && VISIT
	SetActiveUnitCommand_MoveVisit( path, targetSite );
	// RECRUIT
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_RECRUIT,,, targetSite,,,,,,,,false ) );
}

function SetActiveUnitCommand_VisitAndRecruit( H7VisitableSite targetSite )
{
	// VISIT
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_VISIT,,, targetSite ) );
	// RECRUIT
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_RECRUIT,,, targetSite,,,,,,,,false ) );
}

function SetActiveUnitCommand_MoveVisitAndGarrison( array<H7AdventureMapCell> path, H7VisitableSite targetSite )
{
	// MOVE && VISIT
	SetActiveUnitCommand_MoveVisit( path, targetSite );
	// GARRISON
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_GARRISON,,, targetSite,,,,,,,,false ) );
}

event EnableMapView()
{
	class'H7GUIGeneralProperties'.static.GetInstance().HideMinimapOptions();
}

function SetActiveUnitCommand_MoveVisitAndUpgrade( array<H7AdventureMapCell> path, H7VisitableSite targetSite )
{
	// MOVE && VISIT
	SetActiveUnitCommand_MoveVisit( path, targetSite );
	// UPGRADE ARMY
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_UPGRADE,,, targetSite,,,,,,,,false ) );
}

function SetActiveUnitCommand_MovePatrol( array<H7BaseCell> path )
{
	// MOVE / PATROL
	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_MOVE, ACTION_MOVE_PATROL,,,path ) );
}

function SetActiveUnitCommand_PrepareAbility( H7BaseAbility ability )
{
	if(mSelectedArmy == none || mSelectedArmy.GetHero() == none)
	{
		;
		return;
	}

	if(ability.GetTargetType() == NO_TARGET)
	{
		mSelectedArmy.GetHero().PrepareAbility(ability);
		SetActiveUnitCommand_UsePreparedAbility(none);
	}
	else
	{
		mSelectedArmy.GetHero().PrepareAbility(ability);
	}
}

function SetActiveUnitCommand_UsePreparedAbility( H7IEffectTargetable targetable ) 
{

	if(!CanQueueCommand() || mSelectedArmy == none || mSelectedArmy.GetHero() == none)
	{
		;
		return;
	}

	mCommandQueue.Enqueue( class'H7Command'.static.CreateCommand( mSelectedArmy.GetHero(), UC_ABILITY, ACTION_ABILITY, mSelectedArmy.GetHero().GetPreparedAbility(), targetable) );
}

protected function StartCombatDelayed()
{
	if( !class'WorldInfo'.static.GetWorldInfo().IsPreparingMapChange() )
	{
		SetTimer( 0, true, nameof(StartCombatDelayed) ); // reset the timer
		class'H7ReplicationInfo'.static.GetInstance().SetIsAdventureMap();
		StartCombat( mArmyAttacker, mArmyDefender, true );
	}
}

/**
 * Get the threat level from two adventure armies
 * 
 * */
function EAPRLevel GetAPRLevel( H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy, optional array<H7BaseCreatureStack> additionalStacks )
{
	local float attackerPower, defenderPower, relation;

	if( attackingArmy == none || defendingArmy == none )
	{
		return APR_NONE;
	}
	
	attackerPower = attackingArmy.GetStrengthValue( attackingArmy.GetHero().IsHero() );
	defenderPower = defendingArmy.GetStrengthValue( attackingArmy.GetHero().IsHero(), additionalStacks );

	if(defenderPower == 0) return APR_TRIVIAL;

	relation = attackerPower / defenderPower;

	
	if( relation >= mAdventureConfiguration.mAPRLevels[0] )
	{
		return APR_TRIVIAL;
	}
	else if( relation > mAdventureConfiguration.mAPRLevels[1] && relation <= mAdventureConfiguration.mAPRLevels[0] )
	{
		return APR_LOW;
	}
	else if( relation > mAdventureConfiguration.mAPRLevels[2] && relation <= mAdventureConfiguration.mAPRLevels[1] )
	{
		return APR_MODEST;
	}
	else if( relation > mAdventureConfiguration.mAPRLevels[3] && relation <= mAdventureConfiguration.mAPRLevels[2] )
	{
		return APR_AVERAGE;
	}
	else if( relation > mAdventureConfiguration.mAPRLevels[4] && relation <= mAdventureConfiguration.mAPRLevels[3] )
	{
		return APR_SEVERE;
	}
	else if( relation > mAdventureConfiguration.mAPRLevels[5] && relation <= mAdventureConfiguration.mAPRLevels[4])
	{
		return APR_HIGH;
	}
	else // relation <= mAdventureConfiguration.mAPRLevels[5]
	{
		return APR_DEADLY;
	}
}

function float GetBaseNegotiationChance( EAPRLevel threatLevel )
{
	switch( threatLevel )
	{
		case APR_TRIVIAL:
			return mAdventureConfiguration.mNegotiationBaseChances[0];
		case APR_LOW:
			return mAdventureConfiguration.mNegotiationBaseChances[1];
		case APR_MODEST:
			return mAdventureConfiguration.mNegotiationBaseChances[2];
		case APR_AVERAGE:
			return mAdventureConfiguration.mNegotiationBaseChances[3];
		case APR_SEVERE:
			return mAdventureConfiguration.mNegotiationBaseChances[4];
		case APR_HIGH:
			return mAdventureConfiguration.mNegotiationBaseChances[5];
		case APR_DEADLY:
			return mAdventureConfiguration.mNegotiationBaseChances[6];
		default:
			return 0;
	}
}

function float GetNegotiationImpressionModifier( EAPRLevel threatLevel )
{
	switch( threatLevel )
	{
		case APR_TRIVIAL:
			return mAdventureConfiguration.mNegotiationImpressionMods[0];
		case APR_LOW:
			return mAdventureConfiguration.mNegotiationImpressionMods[1];
		case APR_MODEST:
			return mAdventureConfiguration.mNegotiationImpressionMods[2];
		case APR_AVERAGE:
			return mAdventureConfiguration.mNegotiationImpressionMods[3];
		case APR_SEVERE:
			return mAdventureConfiguration.mNegotiationImpressionMods[4];
		case APR_HIGH:
			return mAdventureConfiguration.mNegotiationImpressionMods[5];
		case APR_DEADLY:
			return mAdventureConfiguration.mNegotiationImpressionMods[6];
		default:
			return 0;
	}
}

function CarryOutNegotiationAI(H7AdventureArmy heroArmy, H7AdventureArmy creatureArmy, bool join, optional array<H7ResourceQuantity> cost, optional bool force, optional bool forceFlee=false)
{
	local H7InstantCommandLetEnemyFlee command;
	local H7InstantCommandDoCombat combatCommand;

	if(!mAI.IsAiEnabled())
	{
		return;
	}

	if(join==false || forceFlee)
	{
		// fleeing. Do we let them?
		if( heroArmy.GetHero().GetAiAggressivness()==HAG_SHEEP ||
			heroArmy.GetHero().GetAiAggressivness()==HAG_CONTAINED ||
			forceFlee)
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			// TODO: MP command to destroy arbitrary army
			//RemoveArmy(creatureArmy);
			command = new class'H7InstantCommandLetEnemyFlee';
			command.Init( creatureArmy, heroArmy);
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
			return;
		}
		else
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			// no ... fight
			heroArmy.GetHero().PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);
			combatCommand = new class'H7InstantCommandDoCombat';
			combatCommand.Init(heroArmy.GetHero(), creatureArmy.GetHero(), true, false, none);
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( combatCommand );
			return;
		}
	}

	if(heroArmy.CanMergeArmy(creatureArmy)==true)
	{
		if(cost.Length>0)
		{
			// check if we could pay the iron price and do that
			if( heroArmy.GetPlayer().GetResourceSet().CanSpendResources(cost)==true )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				heroArmy.GetPlayer().GetResourceSet().SpendResources(cost,false,true);
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				combatCommand = new class'H7InstantCommandDoCombat';
				combatCommand.Init(heroArmy.GetHero(), creatureArmy.GetHero(), true, false, none);
				class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( combatCommand );
				return;
			}
		}

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		heroArmy.JoinArmy(creatureArmy,join,true);
		return;
	}
	
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	combatCommand = new class'H7InstantCommandDoCombat';
	combatCommand.Init(heroArmy.GetHero(), creatureArmy.GetHero(), true, false, none);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( combatCommand );
}

function NegotiateAI( H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy )
{
	local bool succeededNegotiation;
	local float negotiationChance, roll, impression, tmpCosts;
	local array<H7ResourceQuantity> armyCosts, newCosts;
	local H7ResourceQuantity armyCostComponent;
	local NegotiationData data;
	local int lastNegotiationResult;
	local array<EPlayerNumber> playersWithDisposition;
	local bool playerHasDisposition;
	local EDispositionType dispType;
	local H7InstantCommandDoCombat combatCommand;

	if(!mAI.IsAiEnabled())
	{
		return;
	}

	data.Army = defendingArmy;
	defendingArmy.GetPlayerDispositions( playersWithDisposition );
	dispType = defendingArmy.GetDiplomaticDisposition();
	if( playersWithDisposition.Find( attackingArmy.GetPlayerNumber() ) != INDEX_NONE || playersWithDisposition.Length == 0 )
	{
		playerHasDisposition = true;
		if( attackingArmy.GetHero().IsAlliedWithEverybody() && dispType == DIT_JOIN_PRICE )
		{
			dispType = DIT_JOIN_FREE;
		}
	}

	if( playerHasDisposition )
	{
		switch( dispType ) // TODO create unify function with GetArmyActionByHero
		{
			case DIT_NEGOTIATE:
				// negotiationchance is an out variable and will get assigned in the function
				if( !attackingArmy.HasNegotiatedWith( defendingArmy, lastNegotiationResult ) )
				{
					negotiationChance = GetBaseNegotiationChance( GetAPRLevel( attackingArmy, defendingArmy ) );

					;
					negotiationChance += attackingArmy.GetHero().GetNegotiationChance();
					roll = FRand();
					succeededNegotiation = roll <= negotiationChance;
					data.NegotiationResult = succeededNegotiation ? 1 : 0;
					;
					attackingArmy.AddNegotiatedArmy( data );
				}
				else
				{
					succeededNegotiation = lastNegotiationResult == 1 ? true : false;
					;
				}

				///////////DEBUG///////////////
				//succeededNegotiation = true;

				;

				;
				if( succeededNegotiation )
				{
					impression = GetNegotiationImpressionModifier( GetAPRLevel( attackingArmy, defendingArmy ) );
					if( !attackingArmy.GetHero().IsAlliedWithEverybody() )
					{
						armyCosts = defendingArmy.GetArmyCost( attackingArmy.GetHero().GetDiplomacyMod() );
						foreach armyCosts(armyCostComponent)
						{
							tmpCosts = float( armyCostComponent.Quantity ) * impression;
							armyCostComponent.Quantity = FFloor( tmpCosts ); // round down costs according to design
							newCosts.AddItem(armyCostComponent);
						}
					}
					;
					CarryOutNegotiationAI(attackingArmy, defendingArmy, true, newCosts);
					return;
				}
				else
				{
					;
					attackingArmy.GetHero().PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);
					
					combatCommand = new class'H7InstantCommandDoCombat';
					combatCommand.Init(attackingArmy.GetHero(), defendingArmy.GetHero(), true, false, none);
					class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( combatCommand );
				}
				break;
			case DIT_JOIN_PRICE:
				// open popup with option to fight or buy them
				CarryOutNegotiationAI(attackingArmy, defendingArmy, true, defendingArmy.GetArmyCost( attackingArmy.GetHero().GetDiplomacyMod() ));
				break;
			case DIT_JOIN_FREE:
				;
				CarryOutNegotiationAI(attackingArmy, defendingArmy, true);
				break;
			case DIT_FORCE_JOIN:
				;
				CarryOutNegotiationAI(attackingArmy, defendingArmy, true,, true);
				break;
			case DIT_ALWAYS_FIGHT:
				;
				attackingArmy.GetHero().PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);
				combatCommand = new class'H7InstantCommandDoCombat';
				combatCommand.Init(attackingArmy.GetHero(), defendingArmy.GetHero(), true, false, none);
				class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( combatCommand );
				break;
			case DIT_FLEE:
				;
				CarryOutNegotiationAI(attackingArmy, defendingArmy, false, ,,true);
				break;
		}
	}
	else
	{
		// negotiationchance is an out variable and will get assigned in the function
		if( !attackingArmy.HasNegotiatedWith( defendingArmy, lastNegotiationResult ) )
		{
			negotiationChance = GetBaseNegotiationChance( GetAPRLevel( attackingArmy, defendingArmy ) );

			;
			negotiationChance += attackingArmy.GetHero().GetNegotiationChance();
			roll = FRand();
			succeededNegotiation = roll <= negotiationChance;
			data.NegotiationResult = succeededNegotiation ? 1 : 0;
			;
			attackingArmy.AddNegotiatedArmy( data );
		}
		else
		{
			succeededNegotiation = lastNegotiationResult == 1 ? true : false;
			;
		}

		///////////DEBUG///////////////
		//succeededNegotiation = true;

		;

		;
		if( succeededNegotiation )
		{
			impression = GetNegotiationImpressionModifier( GetAPRLevel( attackingArmy, defendingArmy ) );
			if( !attackingArmy.GetHero().IsAlliedWithEverybody() )
			{
				armyCosts = defendingArmy.GetArmyCost( attackingArmy.GetHero().GetDiplomacyMod() );
				foreach armyCosts(armyCostComponent)
				{
					tmpCosts = float( armyCostComponent.Quantity ) * impression;
					armyCostComponent.Quantity = FFloor( tmpCosts ); // round down costs according to design
					newCosts.AddItem(armyCostComponent);
				}
			}
			;
			CarryOutNegotiationAI(attackingArmy, defendingArmy, true, newCosts);
			return;
		}
		else
		{
			;
			attackingArmy.GetHero().PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);

			combatCommand = new class'H7InstantCommandDoCombat';
			combatCommand.Init(attackingArmy.GetHero(), defendingArmy.GetHero(), true, false, none);
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( combatCommand );
		}
	}
}

function Negotiate( H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy )
{
	local bool succeededNegotiation;
	local float negotiationChance, roll, impression, tmpCosts;
	local array<H7ResourceQuantity> armyCosts, newCosts;
	local H7ResourceQuantity armyCostComponent;
	local NegotiationData data;
	local int lastNegotiationResult;
	local array<EPlayerNumber> playersWithDisposition;
	local bool playerHasDisposition;
	local EDispositionType dispType;

	data.Army = defendingArmy;

	defendingArmy.GetPlayerDispositions( playersWithDisposition );
	dispType = defendingArmy.GetDiplomaticDisposition();
	if( playersWithDisposition.Find( attackingArmy.GetPlayerNumber() ) != INDEX_NONE || playersWithDisposition.Length == 0 )
	{
		playerHasDisposition = true;
		if( attackingArmy.GetHero().IsAlliedWithEverybody() && dispType == DIT_JOIN_PRICE )
		{
			dispType = DIT_JOIN_FREE;
		}
	}

	if( playerHasDisposition )
	{
		switch( dispType ) // TODO create unify function with GetArmyActionByHero
		{
			case DIT_NEGOTIATE:
				// negotiationchance is an out variable and will get assigned in the function
				if( !attackingArmy.HasNegotiatedWith( defendingArmy, lastNegotiationResult ) )
				{
					negotiationChance = GetBaseNegotiationChance( GetAPRLevel( attackingArmy, defendingArmy ) );

					;
					negotiationChance += attackingArmy.GetHero().GetNegotiationChance();
					roll = mSynchRNG.GetRandomFloat();
					
					succeededNegotiation = roll <= negotiationChance;
					data.NegotiationResult = succeededNegotiation ? 1 : 0;
					;
					attackingArmy.AddNegotiatedArmy( data );
				}
				else
				{
					succeededNegotiation = lastNegotiationResult == 1 ? true : false;
					;
				}

				///////////DEBUG///////////////
				//succeededNegotiation = true;

				;

				;
				if( succeededNegotiation )
				{
					impression = GetNegotiationImpressionModifier( GetAPRLevel( attackingArmy, defendingArmy ) );
					if( !attackingArmy.GetHero().IsAlliedWithEverybody() )
					{
						armyCosts = defendingArmy.GetArmyCost( attackingArmy.GetHero().GetDiplomacyMod() );
						foreach armyCosts(armyCostComponent)
						{
							tmpCosts = float( armyCostComponent.Quantity ) * impression;
							armyCostComponent.Quantity = FFloor( tmpCosts ); // round down costs according to design
							newCosts.AddItem(armyCostComponent);
						}
					}
					;
					// open popup with option to fight or buy them
					mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().UpdateNegotiationPopUp(attackingArmy, defendingArmy, true, newCosts);
					return;
				}
				else
				{
					;
					mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().ShowStartCombatPopUp( attackingArmy, defendingArmy );

					if(attackingArmy.GetPlayerNumber() == GetCurrentPlayer().GetPlayerNumber())
					{
						class'H7Camera'.static.GetInstance().SetFocusActor(attackingArmy, attackingArmy.GetPlayerNumber());
					}
					else
					{
						class'H7Camera'.static.GetInstance().SetFocusActor(defendingArmy, attackingArmy.GetPlayerNumber());
					}
				
					//Play combat overview HeroPopUp sound
					attackingArmy.GetHero().PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);
				}
				break;
			case DIT_JOIN_PRICE:
				// open popup with option to fight or buy them
				mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().UpdateNegotiationPopUp(attackingArmy, defendingArmy, true, defendingArmy.GetArmyCost( attackingArmy.GetHero().GetDiplomacyMod() ));
				break;
			case DIT_JOIN_FREE:
				;
				// open popup with option to fight or let them join for free
				mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().UpdateNegotiationPopUp(attackingArmy, defendingArmy, true);
				break;
			case DIT_FORCE_JOIN:
				;
				// open popup with option to fight or let them join for free
				mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().UpdateNegotiationPopUp(attackingArmy, defendingArmy, true,, true);
				break;
			case DIT_ALWAYS_FIGHT:
				;
				mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().ShowStartCombatPopUp( attackingArmy, defendingArmy );

				if(attackingArmy.GetPlayerNumber() == GetCurrentPlayer().GetPlayerNumber())
				{
					class'H7Camera'.static.GetInstance().SetFocusActor(attackingArmy, attackingArmy.GetPlayerNumber());
				}
				else
				{
					class'H7Camera'.static.GetInstance().SetFocusActor(defendingArmy, attackingArmy.GetPlayerNumber());
				}
				
				//Play combat overview HeroPopUp sound
				attackingArmy.GetHero().PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);
				// open regular Combat popup
				break;
			case DIT_FLEE:
				// instantly flee (might be used for cowardly story characters?)
				class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetAdventureController().RemoveArmy( defendingArmy );
				break;
		}
	}
	else
	{
		// negotiationchance is an out variable and will get assigned in the function
		if( !attackingArmy.HasNegotiatedWith( defendingArmy, lastNegotiationResult ) )
		{
			negotiationChance = GetBaseNegotiationChance( GetAPRLevel( attackingArmy, defendingArmy ) );

			;
			negotiationChance += attackingArmy.GetHero().GetNegotiationChance();
			roll = mSynchRNG.GetRandomFloat();
			succeededNegotiation = roll <= negotiationChance;
			data.NegotiationResult = succeededNegotiation ? 1 : 0;
			;
			attackingArmy.AddNegotiatedArmy( data );
		}
		else
		{
			succeededNegotiation = lastNegotiationResult == 1 ? true : false;
			;
		}

		///////////DEBUG///////////////
		//succeededNegotiation = true;

		;

		;
		if( succeededNegotiation )
		{
			impression = GetNegotiationImpressionModifier( GetAPRLevel( attackingArmy, defendingArmy ) );
			if( !attackingArmy.GetHero().IsAlliedWithEverybody() )
			{
				armyCosts = defendingArmy.GetArmyCost( attackingArmy.GetHero().GetDiplomacyMod() );
				foreach armyCosts(armyCostComponent)
				{
					tmpCosts = float( armyCostComponent.Quantity ) * impression;
					armyCostComponent.Quantity = FFloor( tmpCosts ); // round down costs according to design
					newCosts.AddItem(armyCostComponent);
				}
			}
			;
			// open popup with option to fight or buy them
			mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().UpdateNegotiationPopUp(attackingArmy, defendingArmy, true, newCosts);
		}
		else
		{
			;
			mPlayerControllerInstance.GetHud().GetCombatPopUpCntl().ShowStartCombatPopUp( attackingArmy, defendingArmy );
			class'H7Camera'.static.GetInstance().SetFocusActor(defendingArmy, attackingArmy.GetPlayerNumber());
				
			//Play combat overview HeroPopUp sound
			attackingArmy.GetHero().PlayHeroSound(HEROTYPE_MAGIC, HEROSOUND_COMBAT_SCREEN_START);
		}
	}
}

function StartRecruitedCaravans(H7Player playerFilter = none)
{
	local H7Town town;
	local H7Fort fort;
	local H7CaravanArmy caravan;


	// start any prepared caravans. If the player has a recruitment popup still open he could have already payed for caravan units that didn't start yet.
	foreach mTownList(town)
	{
		if(playerFilter != none && playerFilter != town.GetPlayer())
		{
			continue;
		}

		if(town.GetCaravanArmy() != none && town.GetCaravanArmy().GetFreeSlotCount() != 7)
		{
			caravan = town.GetCaravanArmy();
			caravan.StartCaravanComplete( town );
		}
	}

	foreach mFortList(fort)
	{
		if(playerFilter != none && playerFilter != fort.GetPlayer())
		{
			continue;
		}

		if(fort.GetCaravanArmy() != none && fort.GetCaravanArmy().GetFreeSlotCount() != 7)
		{
			caravan = fort.GetCaravanArmy();
			caravan.StartCaravanComplete( fort );
		}
	}
	
}

// 0.0 zoom start               (StartCombat)
// 1.4 hud disable + fade start (StartCombatFading)
// 2.4 loading screen start     (ShowCombatLoadingScreen)

function StartCombat( H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy, bool isReplayCombat ) // gotocombatmap
{
	local string mapName;
	local H7Town town;
	local H7Fort fort;
	local H7Garrison garrison;
	local H7BattleSite battleSite;

	class'H7AdventureGridManager'.static.GetInstance().DeleteLastHitActor(); // OPTIONAL this is not reliable, sometimes there is still one set again afterwards

	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("ENTER_COMBAT");
	
	class'H7ReplicationInfo'.static.GetInstance().SetIsReplayCombat( isReplayCombat );

	if(class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
	{
		mBeforeCombatUAC = class'H7ReplicationInfo'.static.GetInstance().GetUnitActionsCounter();
		mBeforeCombatRandomCounter = mSynchRNG.GetCounter();
		mBeforeCombatIdCounter = class'H7ReplicationInfo'.static.GetInstance().GetIdCounter();
		class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().SetCombatMode(true);
	}

	if(mPlayerControllerInstance.GetHUD().GetCurrentContext() == mPlayerControllerInstance.GetHUD().GetCombatPopUpCntl())
	{
		if(!attackingArmy.GetPlayer().IsControlledByLocalPlayer() && !defendingArmy.GetPlayer().IsControlledByLocalPlayer())
		{
			mPlayerControllerInstance.GetHUD().GetCombatPopUpCntl().ClosePopupHard();
		}
	}
	else
	{
		mPlayerControllerInstance.GetHUD().CloseCurrentPopup();
	}

	class'H7AdventureHudCntl'.static.GetInstance().GetActorTooltip().ShutDown();

	// replay combat map
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) 
	{
		ShowCombatLoadingScreenNative();
		ReleaseCombatMap( true );
		SetTimer( 0.001f, true, nameof(StartCombatDelayed) );
		return;
	}

	if( mBeforeBattleArea != none && ( mBeforeBattleArea.IsA( 'H7Town') || mBeforeBattleArea.IsA( 'H7Fort' ) || mBeforeBattleArea.IsA( 'H7Garrison' ) ) )
	{
		town = H7Town( mBeforeBattleArea );
		if( town != none )
		{
			mapName = town.GetCombatMapName();
		}

		fort = H7Fort( mBeforeBattleArea );
		if( fort != none )
		{
			mapName = fort.GetCombatMapName();
		}

		garrison = H7Garrison( mBeforeBattleArea );
		if( garrison != none )
		{
			mapName = garrison.GetCombatMapName();
		}

		// TODO: Create system that calculates the default siege map for towns and forts
		// set the default siege map if the town or fort doesnt have one assigned
		if( mapName == "" || mapName == "None" )
		{
			if( mBeforeBattleArea.IsA( 'H7Fort' ) )
			{
				mapName = "CM_Desert_Ruin";
			}
			else if( mBeforeBattleArea.IsA( 'H7Garrison' ) )
			{
				mapName = "SG_Haven_01";
			}
			else
			{
				mapName = "SG_Haven_01";
			}
		}
	}
	else if (mCurrentBattleSite != none)
	{
		battleSite = mCurrentBattleSite;
		mapName = battleSite.GetCombatMapName();
		defendingArmy = battleSite.GetDefenderArmy();
		if( mapName == "" || mapName == "None" )
		{
			mapName = "CM_Desert_neutral_00";
		}
	}
	else
	{
		mapName = GetCombatMapName( defendingArmy );
	}

	// If it's a replay we don't want to change the CombatMapName so it loads the same map
	if(!isReplayCombat)
	{
		mCombatMapName = mapName;
		++mNumberOfFightsManual;
	}

	if(!isReplayCombat)
	{
		if(attackingArmy.GetHero() != none && attackingArmy.GetHero().GetAbilityManager() != none)
		{
			attackingArmy.GetHero().GetAbilityManager().StoreLearnedSpells();
		}

		if(defendingArmy.GetHero() != none && defendingArmy.GetHero().GetAbilityManager() != none)
		{
			defendingArmy.GetHero().GetAbilityManager().StoreLearnedSpells();
		}
	}
	else
	{
		if(attackingArmy.GetHero() != none && attackingArmy.GetHero().GetAbilityManager() != none)
		{
			attackingArmy.GetHero().GetAbilityManager().RestoreLearnedSpells();
		}

		if(defendingArmy.GetHero() != none && defendingArmy.GetHero().GetAbilityManager() != none)
		{
			defendingArmy.GetHero().GetAbilityManager().RestoreLearnedSpells();
		}
	}
	//Setup data for enter battle 
	attackingArmy.SetIsInCombat( true );
	defendingArmy.SetIsInCombat( true ); 
	SetArmyAttacker( attackingArmy );
	attackingArmy.SetIsAttacker( true );
	SetArmyDefender( defendingArmy );
	defendingArmy.SetIsDefender( true );
	attackingArmy.GetPlayer().SetCombatPlayerType( COMBATPT_ATTACKER );
	if( defendingArmy.IsGarrisoned() )
	{
		mBeforeBattleCell = defendingArmy.GetGarrisonedSite().GetEntranceCell();
	}
	else
	{
		mBeforeBattleCell = defendingArmy.GetCell();
	}

	mPreparedCastingStage = class'H7TownCastingStage'.static.CheckAndHandleCastingStage( attackingArmy, defendingArmy );

	if (!isReplayCombat && attackingArmy.GetHero() != none)
	{
		// Usefull in SimTurns
		if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
		{
			StartRecruitedCaravans();
		}
		

		mHeroEventParam.mEventHeroTemplate = attackingArmy.GetHeroTemplateSource();
		mHeroEventParam.mEventPlayerNumber = attackingArmy.GetHero().GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventEnemyPlayerNumber = defendingArmy.GetHero().GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventTargetArmy = defendingArmy;
		mHeroEventParam.mCombatMapName = mCombatMapName;
		mHeroEventParam.mBeforeBattleCell = mBeforeBattleCell;
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_Combat', mHeroEventParam, attackingArmy, 0/*start combat*/);
	}

	if( !isReplayCombat )
	{

		attackingArmy.SyncBaseStackStartingSizeToCurrentSize();
		attackingArmy.CreateCreatureStackProperies(); // sync the properties/basestacks right before engaging
		defendingArmy.SyncBaseStackStartingSizeToCurrentSize();
		defendingArmy.CreateCreatureStackProperies(); // sync the properties/basestacks right before engaging

		if( mPlayerControllerInstance.GetAdventureHud().GetTownHudCntl().IsInTownScreen() )
		{
			mPlayerControllerInstance.GetAdventureHud().GetTownHudCntl().LeaveTownScreen();
		}

		// the zoom in effect is only done for the owner of the attacking army
		if( attackingArmy.GetPlayer().IsControlledByLocalPlayer() )
		{
			class'H7CameraActionController'.static.GetInstance().StartZoomInAction( defendingArmy.Location );
		}
		else
		{
			class'H7CameraActionController'.static.GetInstance().StartZoomInAction( class'H7Camera'.static.GetInstance().Location );
		}

		SetTimer( 1.4f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, 'StartCombatFading' );
		SetTimer( 2.4f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, 'ShowCombatLoadingScreenNative' );
		SetTimer( 2.4f / class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed(), false, 'PerformCombatMapSwitch_NotReplay' ); // Milestone 22 trick

		
		// play hero animation for starting combat
		if( attackingArmy.GetHero().IsHero() )
		{
			attackingArmy.GetHero().GetAnimControl().PlayAnim( HA_VICTORY );
		}
		
		mPlayerControllerInstance.SetIsUnrealInputAllowed( true );
		mPlayerControllerInstance.SetCommandRequested(false);

		PrepareAdventureMapForCombat();

		

		gotostate( 'GoingToCombat' );
	}
	else
	{
		class'H7ReplicationInfo'.static.GetInstance().SwitchToCombatState( mCombatMapName, isReplayCombat );
	}
}

protected function StartCombatFading() // transistion adv -> combat (fromadventuremap tocombatmap)
{
	class'H7TownHudCntl'.static.GetInstance().Leave();
	mPlayerControllerInstance.GetHud().SetAdventureHudVisible(false);
	mPlayerControllerInstance.GetAdventureHud().GetAdventureHudCntl().GetNoteBar().SetVisibleSave(false);
	class'H7CameraActionController'.static.GetInstance().FadeToWhite(1);
}

function ShowCombatLoadingScreenNative(){}

protected event ShowCombatLoadingScreen() // fromadventuremap tocombatmap
{
	// initialize the loadscreen
	mPlayerControllerInstance.InitLoadingScreen(None, true);
	class'Engine'.static.PlayLoadMapMovie();
	mPlayerControllerInstance.SetInLoadingScreen( true );

	class'H7CameraActionController'.static.GetInstance().FadeFromWhite(0.0f);
	class'H7MessageSystem'.static.GetInstance().DeleteAllMessagesFromSideBar();
	class'H7Camera'.static.GetInstance().EnableAudioListener(false);
	class'H7LogSystemCntl'.static.GetInstance().GetLog().ClearLog();
	class'H7AdventureHudCntl'.static.GetInstance().GetActorTooltip().ShutDown();

}

protected function PerformCombatMapSwitch_NotReplay()
{
	//TODO: (after Milestone 22) PrepareMapChange should be moved as soon as we engage the stack (which makes appearing the combat map popup)
	// and CommitMapChange when we click StartCombat or cancel the PrepareMapChange if we cancel.
	// Loading Scaleform-Stuff related to the combat map should be non-blocking also to have smooth animation while it loads.
	class'H7AdventureHudCntl'.static.GetInstance().GetActorTooltip().ShutDown();
	class'H7ReplicationInfo'.static.GetInstance().SwitchToCombatState( mCombatMapName, false ); // Move
}

function string GetCombatMapName( H7AdventureArmy defendingArmy )
{
	if(defendingArmy!=None)
	{
		if( defendingArmy.IsGarrisoned() )
		{
			if( H7Town( defendingArmy.GetGarrisonedSite() ) != none )
			{
				return H7Town (defendingArmy.GetGarrisonedSite() ).GetCombatMapName();
			}
			else if( H7Fort ( defendingArmy.GetGarrisonedSite() ) != none )
			{
				return H7Fort (defendingArmy.GetGarrisonedSite() ).GetCombatMapName();
			}
			else if( H7Garrison( defendingArmy.GetGarrisonedSite() ) != none )
			{
				return H7Garrison (defendingArmy.GetGarrisonedSite() ).GetCombatMapName();
			}
			else if( H7BattleSite ( defendingArmy.GetGarrisonedSite() ) != none )
			{
				return H7BattleSite (defendingArmy.GetGarrisonedSite() ).GetCombatMapName();
			}
			else if( H7RunicBox ( defendingArmy.GetGarrisonedSite() ) != none )
			{
				return H7RunicBox (defendingArmy.GetGarrisonedSite() ).GetEntranceCell().GetCombatMapName();
			}
			else if( H7AbandonedMine ( defendingArmy.GetGarrisonedSite() ) != none )
			{
				return H7AbandonedMine (defendingArmy.GetGarrisonedSite() ).GetEntranceCell().GetCombatMapName();
			}
			else if( H7CaravanOutpost ( defendingArmy.GetGarrisonedSite() ) != none )
			{
				return H7CaravanOutpost (defendingArmy.GetGarrisonedSite() ).GetEntranceCell().GetCombatMapName();
			}
		}
		else
		{
			return defendingArmy.GetCell().GetCombatMapName();
		}
	}
	return mCombatMapName;
}

function GotoNextMap()
{
	local H7ReplicationInfo repInfo;
	local string nextMap;
	local string currMap;
	local int currMapIdxInCampaignQueue;
	local H7CampaignDefinition currentCampaign;

	currMap = class'H7GameUtility'.static.GetAdventureMapName();
	repInfo = class'H7ReplicationInfo'.static.GetInstance();

	// if the map currently belongs to a campaign, load next map from campaign data - this is the proper system
	currentCampaign = GetCampaign();
	if (currentCampaign != none)
	{
		currMapIdxInCampaignQueue = currentCampaign.GetMapIndex(currMap);
		if (currMapIdxInCampaignQueue != INDEX_NONE && currMapIdxInCampaignQueue+1 < currentCampaign.mCampaignMaps.Length)
		{
			class'H7TransitionData'.static.GetInstance().SetCampaignDefinition(currentCampaign);
			nextMap = currentCampaign.mCampaignMaps[currMapIdxInCampaignQueue+1].mFileName;
			// initialize the loadscreen
			currentCampaign.DynLoadObjectProperty('mLoadScreenBackground');
			mPlayerControllerInstance.InitLoadingScreen(currentCampaign.GetLoadscreenBackground());
		}
	}
	
	// secondarily use map info next map - this is the hardcode hack
	if (nextMap == "")
	{
		if (GetMapInfo() != None)
		{
			nextMap = GetMapInfo().GetNextMap();
			// initialize the loadscreen
			mPlayerControllerInstance.InitLoadingScreen(None);
		}
	}

	if (nextMap != "" && nextMap != "None")
	{
		//mPlayerControllerInstance.ConsoleCommand("SavePlayerProfileState "$"TransitionSave_"$ currentCampaign.ObjectArchetype.Name $ currMapIdxInCampaignQueue);
		
		repInfo.StartMap(nextMap);
		//ConsoleCommand("open "$nextMap);
	}
	else
	{
		// no next map
		
		;
		;

		// if last map of campaign, goto council+start endmatinee
		if(currentCampaign != none)
		{
			;
			if(Caps(currentCampaign.GetLastMap()) == Caps(currMap))
			{
				;

				//class'H7TransitionData'.static.GetInstance().SetPendingMatinee(currentCampaign.mEndMatineeName);

				repInfo.StartMap( class'H7GameData'.static.GetInstance().GetHubMapName() );
				return;
			}
		}

		;
		// TODO back to main menu, living ashan menu, duel menu, council end campaign handling ???
		// go back to main menu for now
	}
}

//=============================================================================
// Armies
//=============================================================================

function array<H7AdventureArmy> GetArmies()
{
	return mArmies;
}

function H7AdventureArmy GetArmyByHeroID(int heroID)
{
	local H7AdventureArmy army;
	foreach mArmies( army ) 
	{
		if(army.GetHero() != none && army.GetHero().GetID() == heroID)
		{
			return army;
		}
	}
}

function SelectArmyByHeroID( int heroID )
{
	local H7AdventureArmy army;

	army = GetArmyByHeroID(heroID);
	if(army != none)
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		SelectArmy( army, true );
	}
	else
	{
		;
	}
}

function SoftSelectArmy(H7AdventureArmy army)
{
	if( mSelectedArmy!=none )
	{
		mSelectedArmy.Select( false, false );
		if(mSelectedArmy.GetHero()!=none && mSelectedArmy.GetHero().HasPreparedAbility())
		{
			mPlayerControllerInstance.UnLoadCursorObject();
			if (mPlayerControllerInstance.GetHud() != None)
				mPlayerControllerInstance.GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
		}
		if( mSelectedArmy.IsGarrisoned()==false )
		{
			mSelectedArmy.GetFlag().StopAnim();
			mSelectedArmy.SetCollisionType( COLLIDE_BlockAll );
		}
	}
	mSelectedArmy=army;

}

function SelectArmy( H7AdventureArmy army , optional bool doFocus = false )
{
	local array<H7VisitableSite> sites;
	local array<H7AdventureArmy> armies;
	local array<float> sitesDistance;
	local array<float> armiesDistance;
//	`LOG_AI("SELECT ARMY TO" @ army);
	
	
	if(mAI!=None)
	{
		mAI.ResetThink();
	}

	if(army == none)
	{
		// neccessary if someone garrisons all their armies (yes, that's possible)
		SetSelectedArmy(none);
		return;
	}

	// ungarrison before selecting!
	if( army.IsGarrisoned() || !army.GetHero().IsHero() )
	{
		return;
	}

	if(!army.GetPlayer().IsControlledByLocalPlayer() && !army.GetPlayer().IsControlledByAI())
	{
		// don't select heroes of other players in simturns
		return;
	}
	
	// the player cannot select another army when he has to retreat with the current one
	//if( class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetRetreatingArmy() != none )
	//{
	//	return;
	//}
	
	if( mSelectedArmy != army )
	{
		if( mSelectedArmy != none )
		{
			mSelectedArmy.Select( false, false );
			if(mSelectedArmy.GetHero() != none && mSelectedArmy.GetHero().HasPreparedAbility())
			{
				mPlayerControllerInstance.UnLoadCursorObject();
				if (mPlayerControllerInstance.GetHud() != None)
					mPlayerControllerInstance.GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
			}
			mSelectedArmy.GetFlag().StopAnim();
			mSelectedArmy.SetCollisionType( COLLIDE_BlockAll );
		}

		if( army != none && ( mSelectedArmy == none || army.GetPlayer() != mSelectedArmy.GetPlayer() ) && army.GetPlayer().IsControlledByLocalPlayer() )
		{
			class'H7Camera'.static.GetInstance().SetFocusActor( army.GetHero(), army.GetPlayerNumber(), false );
		}

		SetSelectedArmy(army);

		if( mSelectedArmy != none )
		{
			mSelectedArmy.SetCollisionType( COLLIDE_NoCollision );
			mSelectedArmy.Select( true, doFocus );
			mSelectedArmy.GetPlayer().SetLastSelectedArmy( mSelectedArmy );
		
			if(mSelectedArmy.GetHero() != none && mPlayerControllerInstance.GetHud() != None && !mSelectedArmy.GetPlayer().IsControlledByAI() )
			{
				mPlayerControllerInstance.GetHud().GetSpellbookCntl().SetHero(mSelectedArmy.GetHero());
				mPlayerControllerInstance.GetHud().GetSpellbookCntl().GetQuickBar().SetData(mSelectedArmy.GetHero(),false);
			}

			mSelectedArmy.GetFlag().ShowAnim( true );
		}
	}
	else if(doFocus)
	{
		if( army.GetPlayer().IsControlledByLocalPlayer() )
		{
			class'H7Camera'.static.GetInstance().SetFocusActor( mSelectedArmy.GetHero(), army.GetPlayerNumber(), false );
		}

		// after loading a game the selected army will be selected again, but gui will be in virgin status, so update it:
		if(mSelectedArmy.GetHero() != none && mPlayerControllerInstance.GetHud() != None && !mSelectedArmy.GetPlayer().IsControlledByAI())
		{
			mPlayerControllerInstance.GetHud().GetSpellbookCntl().SetHero(mSelectedArmy.GetHero());
			mPlayerControllerInstance.GetHud().GetSpellbookCntl().GetQuickBar().SetData(mSelectedArmy.GetHero(),false);
		}
	}

	if( mSelectedArmy != none )
	{
		mSelectedArmy.GetHero().ResetPreparedAbility();
		
		if( !mSelectedArmy.IsGarrisoned() && mSelectedArmy.GetPlayer().GetPlayerType() == PLAYER_HUMAN )
		{
			mGridManager.GetPathfinder().GetReachableSitesAndArmies( mSelectedArmy.GetCell(), mSelectedArmy.GetPlayer(), mSelectedArmy.HasShip(), sites, armies, sitesDistance, armiesDistance, mSelectedArmy.GetHero().IsControlledByAI() );

			mSelectedArmy.SetReachableArmies( armies );
			mSelectedArmy.SetReachableSites( sites );
			mSelectedArmy.SetReachableArmiesDistances( armiesDistance );
			mSelectedArmy.SetReachableSitesDistances( sitesDistance );
		}
	}

//	`LOG_AI("SELECT ARMY POST" @ mSelectedArmy);
}

function SetSelectedArmy(H7AdventureArmy army)
{
	mSelectedArmy = army;
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function EHeroAiAggressiveness GetAIAggressivenessFromDifficulty( EAIDifficulty diff )
{
	switch( diff )
	{
		case AI_DIFFICULTY_EASY:
			return HAG_SHEEP;
		case AI_DIFFICULTY_NORMAL:
			return HAG_BALANCED;
		case AI_DIFFICULTY_HARD:
			return HAG_HOSTILE;
		case AI_DIFFICULTY_HEROIC:
			return HAG_NEFARIOUS;
		default:
			return HAG_BALANCED;
	}
}

function PlayerLobbySelectedSettings GetPlayerSettingsFromPlayerNumber( EPlayerNumber playerNumber )
{
	local int i;
	local PlayerLobbySelectedSettings failSettings;

	for( i = 0; i < mPlayerSettings.Length; ++i )
	{
		if( int( playerNumber ) == int( mPlayerSettings[i].mPosition ) )
		{
			return mPlayerSettings[i];
		}
	}

	;
	return failSettings;
}

// get all the heros of me/myself/the local player
function array<H7AdventureHero> GetLocalPlayerHeroes( optional bool withoutGarrison = false )
{
	local array<H7AdventureHero> currentPlayerHeros;
	local H7AdventureArmy army;
	local H7AdventureHero hero;
	local int k,l;
	local bool needSorting;

	needSorting=false;
	foreach mArmies( army )
	{
		if( army.GetPlayer() == GetLocalPlayer() )
		{
			if( army.GetHero() != none && army.GetHero().IsHero() == true && army.GetHero().IsDead() == false)
			{
				if( ( army.IsGarrisoned() && !army.GetGarrisonedSite().IsA('H7Shelter') ) && withoutGarrison ) continue;

				currentPlayerHeros.AddItem( army.GetHero() );

				if(army.GetPlayer().IsControlledByAI()==true )
				{
					needSorting=true;
				}
			}
		}
	}
	// sort the list by assigned hero roles MAIN(GENERAL)->SECONDARY->SCOUT->SUPPORT
	if( needSorting==true )
	{
		for(k=0;k<(currentPlayerHeros.Length-1);k++)
		{
			for(l=k+1;l<currentPlayerHeros.Length;l++)
			{
				if( currentPlayerHeros[l].GetAiRole() < currentPlayerHeros[k].GetAiRole() )
				{
					hero=currentPlayerHeros[l];
					currentPlayerHeros[l]=currentPlayerHeros[k];
					currentPlayerHeros[k]=hero;
				}
			}
		}
	}
	return currentPlayerHeros;
}

// get all the heros of current player
function array<H7AdventureHero> GetCurrentPlayerHeroes( optional bool withoutGarrison = false )
{
	local array<H7AdventureHero> currentPlayerHeros;
	local H7AdventureArmy army;
	local H7AdventureHero hero;
	local int k,l;
	local bool needSorting;

	needSorting=false;
	foreach mArmies( army )
	{
		if( army!= None && army.GetPlayer() == GetCurrentPlayer() )
		{
			if( army.GetHero() != none && army.GetHero().IsHero() == true && army.GetHero().IsDead() == false )
			{
				if( ( army.IsGarrisoned() && !army.GetGarrisonedSite().IsA('H7Shelter') ) && withoutGarrison ) continue;

				currentPlayerHeros.AddItem( army.GetHero() );

				if(army.GetPlayer().IsControlledByAI()==true )
				{
					needSorting=true;
				}
			}
		}
	}
	
	// sort the list by assigned hero roles MAIN(GENERAL)->SECONDARY->SCOUT->SUPPORT
	if( needSorting==true )
	{
		for(k=0;k<(currentPlayerHeros.Length-1);k++)
		{
			for(l=k+1;l<currentPlayerHeros.Length;l++)
			{
				if( currentPlayerHeros[l].GetAiRole() < currentPlayerHeros[k].GetAiRole() )
				{
					hero=currentPlayerHeros[l];
					currentPlayerHeros[l]=currentPlayerHeros[k];
					currentPlayerHeros[k]=hero;
				}
			}
		}
	}
	return currentPlayerHeros;
}

function H7AdventureArmy GetAdvArmyOnCombatByPlayer( H7Player fromPlayer )
{
	local array<H7AdventureArmy> armies;
	local int i;

	armies = GetPlayerArmies( fromPlayer );

	for( i=0; i<armies.Length;++i)
	{
		if( armies[i].IsInCombat() )
		{
			return armies[i];
		}
	}
}

function array<H7AdventureArmy> GetPlayerArmies( H7Player fromPlayer, optional bool checkHasHero = false ){}

// called every frame if mouse over adventurecell/terrain/landscape
function UnhoverArmy()
{
	if(mHoveredArmy != none)
	{
		mHoveredArmy.SetHoverHighlight(false);
		mHoveredArmy = none;
	}
}

function SetHoverArmy(H7AdventureArmy army)
{
	if(army != mHoveredArmy)
	{
		UnhoverArmy();
		mHoveredArmy = army;
		if(army != none) 
		{
			army.SetHoverHighlight(true); // TODO how does this look, does not seem to work
		}
	}
}

event ChangeGameSpeed(H7EditorArmy army)
{
	if(H7AdventureArmy(army) != none && H7AdventureArmy(army).GetVisitedCellCount() > 25)
	{
		SetGameSettingsSpeedAdv( 0.1f ); 
		SetGameSettingsSpeedCmb( 0.1f );
		SetGameSettingsSpeedAi( 0.1f );

		SetGameSpeed();
	}
	else if(H7CombatArmy(army) != none && H7CombatArmy(army).GetTotalSelectionCount() > 12)
	{
		SetGameSettingsSpeedAdv( 0.1f ); 
		SetGameSettingsSpeedCmb( 0.1f );
		SetGameSettingsSpeedAi( 0.1f );

		SetGameSpeed();
	}
}

//=============================================================================
// Turn handling
//=============================================================================

function UpdateEvents( ETrigger eventTrigger, optional EPlayerNumber playerID = PN_MAX, optional H7EventContainerStruct container, optional array<H7EditorHero> excludeHeroes ){}

event UpdateProduction( EPlayerNumber playerID )
{
	local H7Player player;
	local array<H7TownBuildingData> abuildings;
	local array<H7ResourceQuantity> aquant;
	local H7ResourceQuantity quant;
	local H7TownBuildingData building, override_building;
	local H7Mine mine;
	local H7Town town;
	
	// clear player's resource incomes
	player = GetPlayerByNumber(playerID);
	if(player==None) return;

	// for all towns owned by player ...
	// for all mines ...
	foreach mMineList( mine )
	{
		if( mine.GetPlayerNumber() == playerID )
		{
			mine.ProduceResource(); // the function does modify the produced resource income value for the player
		}
	}

	foreach mTownList( town )
	{
		if( town.GetPlayerNumber() == playerID )
		{
			abuildings=town.GetBuildings();
			foreach abuildings(building)
			{
				override_building=town.GetBestBuilding(building);
				if(override_building==building)
				{
					aquant=building.Building.GetIncome();
					foreach aquant(quant)
					{
						if( quant.Type != player.GetResourceSet().GetCurrencyResourceType() )
						{
							player.GetResourceSet().ModifyIncome( quant.Type, quant.Quantity );
						}
					}
				}
			}
			player.GetResourceSet().ModifyIncome( player.GetResourceSet().GetCurrencyResourceType(), town.GetModifiedStatByID( STAT_PRODUCTION ) );
		}
	}
}

function UpdateProductionPostIncome( EPlayerNumber playerID )
{
	local H7Player player;
	local array<H7TownBuildingData> abuildings;
	local array<H7ResourceQuantity> aquant;
	local H7ResourceQuantity quant;
	local H7TownBuildingData building, override_building;
	local H7Town town;

	// remove temporary income that should not be displayed in the resource bar
	player = GetPlayerByNumber(playerID);
	if(player==None) return;

	foreach mTownList( town )
	{
		if( town.GetPlayerNumber() == playerID )
		{
			abuildings=town.GetBuildings();
			foreach abuildings(building)
			{
				override_building=town.GetBestBuilding(building);
				if(override_building==building && !building.Building.ShouldDisplayIncome())
				{
					aquant=building.Building.GetIncome();
					foreach aquant(quant)
					{
						if( quant.Type != player.GetResourceSet().GetCurrencyResourceType() )
						{
							player.GetResourceSet().ModifyIncome( quant.Type, -quant.Quantity );
						}
					}
				}
			}
		}
	}
}

function UpdateSpells( EPlayerNumber playerID )
{
	local H7AdventureArmy currentArmy;

	// for all heroes that player has
	foreach mArmies( currentArmy )
	{
		if( currentArmy.GetHero().IsHero() && currentArmy.GetPlayerNumber() == playerID )
		{
			currentArmy.GetHero().UpdateSpells();
		}
	}
}

function EndMyTurn()
{
	local H7InstantCommandEndturn command;

	if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
	{
		mPlayerControllerInstance.GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().SetEndSimTurn(true);
		// set my own turn finished. Once turns of all players are finished, this will be called again
		H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).SetTurnFinished();
	}
	else if(mIsPlayerTurn)
	{
		command = new class'H7InstantCommandEndturn';
		command.Init( class'H7AdventureController'.static.GetInstance().GetLocalPlayer() );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
	}
}

function EndAITurn()
{
	local H7InstantCommandEndturn command;
	local H7Player player;
	local H7Town town;
	local array<H7Town> towns;

	towns = GetCurrentPlayer().GetTowns();
	foreach towns( town )
	{
		town.SetAiDone( false );
	}

	UpdateTownsAI( GetCurrentPlayer(), false );

	// If one of the players is in combat -> don't end turn until finish Combat command was processed
	if( class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
	{
		foreach mPlayers(player)
		{
			if(!player.IsNeutralPlayer() && player.IsInCombat())
			{
				return;
			}
		}
	}

	if(mAI.IsAiEnabled() && !mPlayers[mCurrentPlayerIndex].HasEndedTurn())
	{
		command = new class'H7InstantCommandEndturn';
		command.Init( GetCurrentPlayer() );
		class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);
	}
}

function EndMyTurnComplete()
{
	local int i;

	mPlayers[mCurrentPlayerIndex].SetEndedTurn(true);
	if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
	{
		// DO AI turn after regular players
		if(!mSimTurnOfAI)
		{
			mPlayerControllerInstance.GetHUD().CloseCurrentPopup();
			if( mPlayerControllerInstance.GetAdventureHud().GetTownHudCntl().IsInTownScreen() )
			{
				mPlayerControllerInstance.GetAdventureHud().GetTownHudCntl().LeaveTownScreen();
			}
			mSimTurnOfAI = true;
			if(SetNextAIPlayerInSimTurns(0))
			{
				return;
			}
		}
		else if(SetNextAIPlayerInSimTurns(mCurrentPlayerIndex))
		{
			return;
		}

		// No AI players left that need to do their turn, end turn normal now
		mSimTurnOfAI = false;

		for(i=1; i<mPlayers.Length; i++)
		{
			if(mPlayers[i].GetStatus() == PLAYERSTATUS_ACTIVE)
			{
				StartRecruitedCaravans(mPlayers[i]);
			}
		}
	}
	else
	{
		// Send all non-full non-empty caravans
		StartRecruitedCaravans(mPlayers[mCurrentPlayerIndex]);
	}

	GoToState('CaravanTurn');
}

// returns true if there is still an AI player left that needs to do his turn
function bool SetNextAIPlayerInSimTurns(int currentPlayerIdx)
{
	local int i;

	mPlayers[mCurrentPlayerIndex].SetEndedTurn(false);
	for(i=currentPlayerIdx + 1; i<mPlayers.Length; i++)
	{
		if(GetPlayerByIndex(i).IsControlledByAI() && GetPlayerByIndex(i).GetStatus() == PLAYERSTATUS_ACTIVE )
		{
			SetCurrentPlayerIndex(i);
			mPlayerControllerInstance.GetHud().SetHUDMode(HM_WAITING_FOR_AI);
			StartAITurn();
			return true;
		}
	}

	return false;
}

function BeginTurn()
{
	local int i;
	local bool humanPlayersLeft;

	;

	if(class'H7SoundController'.static.GetInstance() != none)
	{
		//Update the adventure music, it's a new turn
		SetTimer(2.0f, false, 'NewTurnInitAdventureMapMusic');
	}

	mPlayerControllerInstance.SetCaravanTurn(false);
	mIsCaravanTurnFinished = true;
	// complete previous turn
	if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
	{
		mPlayerControllerInstance.GetHud().SetHUDMode(HM_NORMAL);

		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().AutoSaveGame();
		
		for(i=mPlayers.Length - 1; i > 0; i--)
		{
			if(mPlayers[i].GetStatus() == PLAYERSTATUS_ACTIVE)
			{
				EndPlayerTurn(i);

				if(mPlayers[i].IsHuman())
				{
					humanPlayersLeft = true;
				}
			}
		}

		if(!humanPlayersLeft)
		{
			EndMyTurnComplete();
		}

		mPlayerControllerInstance.GetAdventureHud().GetAdventureHudCntl().GetCommandPanel().SetEndSimTurn(false);
	}
	else
	{
		EndPlayerTurn(mCurrentPlayerIndex);
	}
}

function RequestCancelEndTurn()
{
	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().RequestCancelEndTurn();
}

function FinishHeroTurn()
{
	local H7Player curPlayer;
	local H7AdventureHero hero;
	local array<H7AdventureHero> playerHeroes;
	local H7AdventureArmy army, visArmy;
	local H7VisitableSite garSite;
	local H7AreaOfControlSiteLord garLord;
	local H7Garrison garr;
	local H7Shelter shelter;

	// reset think function
	if(mAI!=None)
	{
		mAI.ResetThink();
	}

	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().DehighlightAdventureObjects();

	curPlayer=GetCurrentPlayer();
	if( curPlayer==None )
	{
		;
		return;
	}
	if( curPlayer.IsControlledByAI()==false )
	{
		// if not controlled by AI the player selects its acting heroes manually, hence this function should not be called at all.
		return;
	}
	
	if( mSelectedArmy==None )
	{
		// nothing to finish really ...
		EndAITurn();
		return;
	}
	
	hero=mSelectedArmy.GetHero();
	if( hero==None )
	{
		// should never be none
		;
		return;
	}
	
	;
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	hero.SetFinishedCurrentTurn(true);
	
	// get all heroes of current player and search for one has not acted this turn
	playerHeroes = GetCurrentPlayerHeroes(false);
	army = GetArmyToSelect(playerHeroes);

	if( army==None ) // all armies/heroes of player have acted so we 'click' EndTurn
	{
		// proceed normaly
		EndAITurn();
		return;
	}

	if( mAI.IsAiEnabled() && 
		army.IsGarrisoned()==true && 
		army.GetHero()!=None && 
		army.GetHero().GetAiHibernationState()==false &&
		army.GetHero().GetAiControlType()!=HCT_SCRIPT_OVERRIDE )
	{
		garSite = army.GetGarrisonedSite();
		if(garSite!=None)
		{
			visArmy = garSite.GetEntranceCell().GetArmy();
			if(visArmy!=None && curPlayer.IsPlayerAllied(visArmy.GetPlayer())==false && visArmy.GetPlayer() != curPlayer)
			{
				// entrance blocked by enemy hero ... we are besieged silly as that is
				SoftSelectArmy(army);
				FinishHeroTurn();
				return;
			}
			else
			{
				garLord = H7AreaOfControlSiteLord(garSite);
				if(garLord!=None)
				{
					if(garLord.GetAiThreatLevel()==0)
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						garLord.TransferHero(ARMY_NUMBER_GARRISON,ARMY_NUMBER_VISIT);
					}
				}
				garr = H7Garrison(garSite);
				if(garr!=None)
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					garr.TransferHero(ARMY_NUMBER_GARRISON,ARMY_NUMBER_VISIT);
				}
				shelter = H7Shelter(garSite);
				if(shelter!=None)
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					shelter.ExpelArmy();
				}
			}
		}
	}
	if(army.IsGarrisoned()==true) // if it still is we need to skip that bugger
	{
		army.GetHero().SetFinishedCurrentTurn( true );
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		SoftSelectArmy(army);
		FinishHeroTurn();
	}
	else
	{
		if( curPlayer.GetPlayerType() == PLAYER_HUMAN )
		{
			UpdateHUD(playerHeroes, army, true);
		}
		else
		{
			SelectArmy( army, false );
		}

		//
		mAI.LevelUpHeroes(curPlayer);
		mAI.ReassignHeroRoles(curPlayer);
		mAI.AutoequipHeroes(curPlayer);
		mAI.MergeArmyCreatureStacks(curPlayer);
		mAI.UpdateTensionParameters(curPlayer);
	}
}

function bool AllPlayersHaveQuit()
{
	local H7Player iPlayer;
	foreach mPlayers(iPlayer)
	{
		if(iPlayer.GetPlayerNumber() != PN_NEUTRAL_PLAYER && iPlayer.GetStatus() != PLAYERSTATUS_QUIT && iPlayer.GetStatus() != PLAYERSTATUS_UNUSED) return false;
	}
	return true;
}

// UpdateTurnCounter == false && isGameStart == false           -> FAKE EndPlayerTurn (it's game load)
// UpdateTurnCounter == false && isGameStart == true            -> FAKE EndPlayerTurn (it's game init)
// UpdateTurnCounter == true  && isGameStart doesn't matter     -> REAL EndPlayerTurn
// Actually it's all more complicated and the game start actually calls with UpdateTurnCounter=true but not in sim turns and it's all unclear but we are afraid to touch it now
function EndPlayerTurn( int currentPlayerIndex, optional bool UpdateTurnCounter = true, optional bool isGameStart = false )
{
	local H7Hud currentHud;
	local H7Player currentPlayer;
	
	currentPlayer = mPlayers[currentPlayerIndex];

	if( !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && UpdateTurnCounter && !isGameStart && currentPlayer != none && currentPlayer.GetPLayerType() == PLAYER_HUMAN && !currentPlayer.GetQuestController().IsGameEnd())
	{ // maybe add GetCurrentGameMode() == SINGLEPLAYER ?
		//class'H7AdventurePlayerController'.static.GetAdventurePlayerController().QueueAutoSaveGame();
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().AutoSaveGame();
	}

	;

	currentHud = mPlayerControllerInstance.GetHud();

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
	mPlayers[mCurrentPlayerIndex].SetEndedTurn(false);

	if( mPlayers[currentPlayerIndex].IsControlledByLocalPlayer() )
	{
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().DehighlightAdventureObjects();
		H7AdventureHud(mPlayerControllerInstance.GetHud()).GetTownHudCntl().Leave();
		
		if(mPlayerControllerInstance.GetHud().GetCurrentContext() != none && 
			mPlayerControllerInstance.GetHud().GetCurrentContext().IsA('H7ItemSlotMovieCntl') )
		{
			H7ItemSlotMovieCntl(mPlayerControllerInstance.GetHud().GetCurrentContext()).RemoveItemIconFromCursor();
		} // USE GODDAMN BRACKETS AND NULL CHECKS
		
		H7AdventureHud(mPlayerControllerInstance.GetHud()).CloseCurrentPopup();
	
		if( currentHud.GetHeropedia().GetPopup().IsVisible() )
			currentHud.GetHeropedia().Closed();
	}

	// only wipe notifications when local player ends his turn, to keep notes generated for local player during ai or human turns
	if(mPlayers[currentPlayerIndex] == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
	{
		class'H7MessageSystem'.static.GetInstance().DeleteAllMessagesFromNoteBar();
	}

	currentPlayer = mPlayers[currentPlayerIndex];
	
	if( UpdateTurnCounter )
	{
		//Player ends turn event
		mPlayerEventParam.mEventPlayerNumber = mPlayers[currentPlayerIndex].GetPlayerNumber();
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerTurn', mPlayerEventParam, mPlayers[currentPlayerIndex], 3);

		if(mSelectedArmy!=None)
		{
			mSelectedArmy.GetFlag().StopAnim();
			mSelectedArmy.SetCollisionType( COLLIDE_BlockAll );

			// Make sure we don't set someone's else army to us (save my last selected army for next turn)
			if(mSelectedArmy.GetPlayer() == mPlayers[ currentPlayerIndex ] && !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
			{
				if(!mSelectedArmy.IsDead())
				{
					mPlayers[ currentPlayerIndex ].SetLastSelectedArmy( mSelectedArmy );
				}
				else
				{
					mPlayers[ currentPlayerIndex ].SetLastSelectedArmy( none );
				}
			
				SetSelectedArmy(none);
			}
		}

		// find the player of the next turn (this block increments mCurrentPlayerIndex++)
		currentPlayerIndex = SetNextPlayer(currentPlayerIndex, isGameStart);
		while(mPlayers[currentPlayerIndex].GetStatus() == PLAYERSTATUS_QUIT || mPlayers[currentPlayerIndex].GetStatus() == PLAYERSTATUS_UNUSED)
		{
			currentPlayerIndex = SetNextPlayer(currentPlayerIndex, isGameStart);
			if(AllPlayersHaveQuit())
			{
				// TODO handling for this, we just abort here because while loop goes endless
				return;
			}
		}
		currentPlayer = mPlayers[currentPlayerIndex];
		// ------------------------------------------------------------------------------
	}

	// ----- new turn begin turn newturn beginturn of a player -----
	// TODO SOMEONE HAS TO TAKE CARE OF AI TURNS - NEEDS PROPER SOLUTION FOR MP GAMES
	
	// start turn popup for hotseat
	if(class'H7GUIGeneralProperties'.static.GetInstance().mTurnOverPopupEnabled )
	{
		if( IsHotSeat() && !currentPlayer.IsControlledByAI() && UpdateTurnCounter && !isGameStart )
		{
			currentHud.SetHUDMode(HM_IN_BETWEEN_TURNS_FOR_HOTSEAT);

			class'H7CameraActionController'.static.GetInstance().FadeToBlack(0);
			
			class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(
				Repl( class'H7Loca'.static.LocalizeSave("HOTSEAT_PLAYER_START_TURN","H7Adventure"),"%t", GetCurrentPlayer().GetName() )
				,class'H7Loca'.static.LocalizeSave("START_TURN","H7Adventure"),StartPlayerTurnConfirmed
			);
			return;
		}
	}

	StartPlayerTurn(currentPlayerIndex, UpdateTurnCounter,isGameStart);
}

function StartPlayerTurnConfirmed()
{
	class'H7CameraActionController'.static.GetInstance().FadeFromBlack(1);
	StartPlayerTurn( mCurrentPlayerIndex );
}

// starts the turn for the player who is currentPlayerIndex
// - updates everything in the hud to the new player
// - does actual game play changes and event if updateTurnCounter = true
function StartPlayerTurn(int currentPlayerIndex, optional bool updateTurnCounter = true, optional bool isGameStart = false )
{
	local array<H7AdventureHero> localPlayerHeroes;
	local H7AdventureHero hero;
	local H7AdventureArmy armyToSelect;
	local H7Player currentPlayer;
	local H7Hud currentHud;
	local array<H7VisitableSite> sites;
	local array<H7AdventureArmy> armies;
	local array<float> sitesDistance;
	local array<float> armiesDistance;
	local array<H7Town> towns;
	local H7Town town;


	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local array<H7Creature> testedCreatures;
	
	// this needs to be before the weekly popup, or it will unblock the hud under it
	mPlayerControllerInstance.GetHud().UnblockAllFlashMovies(); // not sure why needed (somehow related to MP timer)

	// the player who just started it's turn
	currentPlayer = mPlayers[currentPlayerIndex];
	mIsPlayerTurn = true;

	if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && currentPlayer.mWonGame)
	{
		return;
	}
	

	// this is the use of the hotseat popup text for simturns
	// TODO this needs a fullscreen animated floating text in the future
	/*if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && currentPlayer.IsControlledByLocalPlayer() && !IsHotSeat() && updateTurnCounter && !isGameStart ) // OPTIONAL option to turn it off?
	{
		// this breaks with weekly popup:
		class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().OKPopup(
			Repl( `Localize("H7Adventure", "HOTSEAT_PLAYER_START_TURN" , "MMH7Game" ),"%t", GetCurrentPlayer().GetName() )
			,`Localize("H7Adventure", "START_TURN" , "MMH7Game" ), none	);
		
		// doing emergency side bar note instead:
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(
			Repl( `Localize("H7Adventure", "HOTSEAT_PLAYER_START_TURN" , "MMH7Game" ),"%t", GetCurrentPlayer().GetName() ),MD_SIDE_BAR
		);
	}*/

	if( currentPlayer.IsControlledByAI() )
	{
		localPlayerHeroes = currentPlayer.GetHeroes();
		foreach localPlayerHeroes( hero )
		{
			if( hero.GetAdventureArmy().IsAITimeOut() )
			{
				hero.GetAdventureArmy().DecrementTimeOut();
			}
			if( !hero.IsDead() && hero.IsHero() )
			{
				stacks = hero.GetAdventureArmy().GetBaseCreatureStacks();
				foreach stacks( stack )
				{
					if( testedCreatures.Find( stack.GetStackType() ) == INDEX_NONE )
					{
						if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
						testedCreatures.AddItem( stack.GetStackType() );
					}
				}
			}
			hero.SetHasTradedToday( false );
		}
		//currentPlayer.DumpQuickCombatLosses();
		//currentPlayer.DumpActionCounters();
	}

	// mutliplayer && !simTurns
	if( class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() && !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		H7AdventureHud(mPlayerControllerInstance.GetHUD()).GetAdventureHudCntl().GetMPTurnInfo().Update(
			class'H7ReplicationInfo'.static.GetInstance()
		);
	}

	if( !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		class'H7DestructibleObjectManipulator'.static.CountDownForAll();
	}

	if(updateTurnCounter) // actual gameplay changes only if it really was a turn-transition (so that starting game and loading game will not trigger this) *exceptions apply
	{
		// Test if weekly popup can be here:
		if( (!isGameStart || GetMapInfo().GetMapType() == SKIRMISH) && mCalendar.GetCalendarDay() == 1 && GetCurrentPlayer().IsControlledByLocalPlayer() )
		{
			// for multiplayer we need to close the "waiting for others to connect" popup first
			if(class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().IsVisible())
			{
				class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().Finish();
			}
			class'H7WindowWeeklyCntl'.static.GetInstance().setData(
				mCalendar.GetCurrentWeek().GetName(), mCalendar.GetCurrentWeek().GetDescription()
			);
		}

		if(mPlayerControllerInstance.GetAdventureHud().GetWindowWeeklyCntl().GetPopup().IsVisible())
		{
			// wait with the events until popup closed
		}
		else
		{
			TriggerStartOfTurnEvents();
		}

		towns = currentPlayer.GetTowns();
		foreach towns( town )
		{
			town.SetAiDone( false );
		}

		if( mTurnCounter != 1 ) 
		{
			// NEW DAY
			currentPlayer.GetResourceSet().ClearPreviousIncome();
			GetCurrentPlayer().TriggerEvents( ON_BEGIN_OF_DAY, false ); // deathmarch debuff
			UpdateEvents(ON_BEGIN_OF_DAY, currentPlayer.GetPlayerNumber());
			if( mCalendar.GetCalendarDay() == 1 )
			{
				currentPlayer.GetResourceSet().ModifyCurrency( currentPlayer.GetInterest(), true );
			}
			UpdateProduction( currentPlayer.GetPlayerNumber() );
			UpdateSpells( currentPlayer.GetPlayerNumber() );
			currentPlayer.GetResourceSet().HandleIncome( false );
			UpdatePlunderDelayForMines( currentPlayer.GetPlayerNumber() );
			UpdateBuiltTodayForTowns( currentPlayer.GetPlayerNumber() );
			UpdatePlunderDelayForAoCBuffSites( currentPlayer.GetPlayerNumber() );
			UpdateEvents(ON_POST_BUILDING_PRODUCTION, currentPlayer.GetPlayerNumber());
		}
	}

	// update the fog of war for new player
	//class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetFOWController().RestoreNextPlayer();
	if( mGridManager.IsFogOfWarUsed() )
	{
		if( mGridManager.GetCurrentGrid().GetFOWController() != none )
		{
			mGridManager.GetCurrentGrid().GetFOWController().ExploreFog();
		}
	}
	// update minimap fog
	currentHud = mPlayerControllerInstance.GetHud();
	H7AdventureHud(currentHud).GetAdventureHudCntl().GetMinimap().ResetFog();

	// set hud mode, start turn messages, and autosave
	if( !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		if(currentPlayer.IsControlledByLocalPlayer())
		{
			currentHud.SetHUDMode(HM_NORMAL);
			// Send start of turn messages:
			HandleStartOfTurnMessages(currentPlayer);
		} 
		else if(currentPlayer.GetPlayerType() == PLAYER_AI)
		{
			currentHud.SetHUDMode(HM_WAITING_FOR_AI);
		}
		else
		{
			currentHud.SetHUDMode(HM_WAITING_FOR_OTHERS_TURN);
		}
		
		// AutoSave
		//if( updateTurnCounter && !isGameStart && currentPlayer.GetPLayerType() == PLAYER_HUMAN && !currentPlayer.GetQuestController().IsGameEnd())
		//{ // maybe add GetCurrentGameMode() == SINGLEPLAYER ?
		//	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().QueueAutoSaveGame();
		//}
	}
	else if(GetLocalPlayer().GetStatus() != PLAYERSTATUS_ACTIVE )
	{
		currentHud.SetHUDMode(HM_WAITING_FOR_OTHERS_TURN);
	}

	// get all the heros of the local player
	localPlayerHeroes = GetCurrentPlayerHeroes(false); // Everybody should get withGarrison now, human and AI

	if(updateTurnCounter) // actual gameplay changes only if it really was a turn-transition (otherwise starting game and loading game will trigger this) *exceptions apply
	{
		foreach localPlayerHeroes( hero )
		{
			hero.SetCastedSpellThisTurn( false );
			hero.GetAdventureArmy().ResetNumTimesAlreadyRetreated();
			if( !hero.GetAdventureArmy().IsGarrisoned() && currentPlayer.GetPlayerType() == PLAYER_HUMAN )   
			{
				if(mSelectedArmy != none)
				{
					mGridManager.GetPathfinder().GetReachableSitesAndArmies( hero.GetCell(), currentPlayer, hero.GetAdventureArmy().HasShip(), sites, armies, sitesDistance, armiesDistance, mSelectedArmy.GetHero().IsControlledByAI() );
				}
				hero.GetAdventureArmy().SetReachableArmies( armies );
				hero.GetAdventureArmy().SetReachableSites( sites );
				hero.GetAdventureArmy().SetReachableArmiesDistances( armiesDistance );
				hero.GetAdventureArmy().SetReachableSitesDistances( sitesDistance );
			}
		}
	}

	if( !currentPlayer.IsControlledByAI() && (!class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() || currentPlayer.IsControlledByLocalPlayer()) )
	{
		armyToSelect = (currentPlayer.GetLastSelectedArmy() == none || currentPlayer.GetLastSelectedArmy().IsBeingRemoved() || currentPlayer.GetLastSelectedArmy().IsDead()) ? GetArmyToSelect(localPlayerHeroes) : currentPlayer.GetLastSelectedArmy();
		UpdateHUD( localPlayerHeroes, armyToSelect, true, true, mTurnCounter != 1 ? updateTurnCounter : false);
	}

	if(updateTurnCounter && mTurnCounter != 1)
	{
		UpdateProductionPostIncome( currentPlayer.GetPlayerNumber() );
	}

	if(IsHotSeat())
	{
		mPlayerControllerInstance.GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().UpdateHotSeat();
	}

	// is it me... that starts the turn?
	if(currentPlayer.IsControlledByLocalPlayer())
	{
		GetCursor().SetCursor(CURSOR_NORMAL);

		// this is message system now, the Cntl is TradeResultCntl dummy
		if(H7AdventureHud(currentHud).GetTradeResultCntl().PlayerReceivedItemsCreautes())
		{
			;
			if(currentPlayer.IsControlledByAI())
			{
				H7AdventureHud(currentHud).GetTradeResultCntl().ClearTradeList();
			}
			else
			{
				H7AdventureHud(currentHud).GetTradeResultCntl().Update();
			}
		}
	
		if(!class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
		{
			foreach localPlayerHeroes( hero )
			{
				if( hero.HasPendingLevelUp() )
				{
					hero.InvokeLevelUp();
					hero.SetPendingLevelUp(false);
				}
			}
		}
	}

	if(currentPlayer.IsControlledByAI() && !class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
	{
		StartAITurn();
	}

	ResetCurrentTurnTimer();
	CalculateInputAllowed();

	class'H7LogSystemCntl'.static.GetInstance().GetLog().ClearLog();

	mPlayerControllerInstance.SetPause(false);
}

function StartAITurn()
{
	local H7Player currentPlayer;
	local H7AreaOfControlSite garSite;
	local H7AreaOfControlSiteLord garLord;
	local H7Garrison garr;
	local array<H7AdventureHero> localPlayerHeroes;
	local H7AdventureArmy armyToSelect;

	currentPlayer = mPlayers[mCurrentPlayerIndex];

	UpdateTownsAI(currentPlayer);
	currentPlayer.RecalcAiPowerBalance();

	localPlayerHeroes = GetCurrentPlayerHeroes(false);
	// AI is ordering its heroes so the MAIN is always acting first
	armyToSelect = GetArmyToSelect(localPlayerHeroes);
	if( armyToSelect != none && mAI.IsAiEnabled() && armyToSelect.GetHero().GetAiHibernationState()==false && armyToSelect.GetHero().GetAiControlType()!=HCT_SCRIPT_OVERRIDE )
	{
		garSite = H7AreaOfControlSite( armyToSelect.GetGarrisonedSite() );
		if(garSite!=None)
		{
			garLord = H7AreaOfControlSiteLord(garSite);
			if(garLord!=None)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				garLord.TransferHero(ARMY_NUMBER_GARRISON,ARMY_NUMBER_VISIT);
			}
			garr = H7Garrison(garSite);
			if( garr != none )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				garr.TransferHero(ARMY_NUMBER_GARRISON,ARMY_NUMBER_VISIT);
			}
		}
		if( H7Shelter( armyToSelect.GetGarrisonedSite() ) != none )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			H7Shelter( armyToSelect.GetGarrisonedSite() ).ExpelArmy();
		}
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	mAI.ResetThink();

	UpdateHUD( localPlayerHeroes, armyToSelect, true, true, true );
}

function TriggerStartOfTurnEvents() // for kismet
{
	local int lastDayCount, lastWeekCount, lastMonthCount, eventOutputNum, eventOutputIdx;

	lastDayCount = mCalendar.GetCalendarDay();
	lastWeekCount = mCalendar.GetCalendarWeek();
	lastMonthCount = mCalendar.GetCalendarMonth();

	//Player starts turn event, detect day/week/month change
	eventOutputNum = 0;
	if ( lastMonthCount != mCalendar.GetCalendarMonth() )
	{
		eventOutputNum = 2;//Month changed
	}
	else if ( lastWeekCount != mCalendar.GetCalendarWeek() )
	{
		eventOutputNum = 1;//week
	}
	else if ( lastDayCount != mCalendar.GetCalendarDay() )
	{
		eventOutputNum = 0;
	}
	
	// triggers kismet scripts - player start turn event
	mPlayerEventParam.mEventPlayerNumber = GetCurrentPlayer().GetPlayerNumber();
	for(eventOutputIdx = 0; eventOutputIdx <= eventOutputNum; eventOutputIdx++)//e.g. trigger day AND week if it's new week, day AND week AND month if month
	{
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerTurn', mPlayerEventParam, GetCurrentPlayer(), eventOutputIdx);
	}
}

function ResetCurrentTurnTimer()
{
	switch( mGameSettings.mTimerAdv )
	{
		case TIMER_ADV_NONE: mCurrentTurnTimeLeft = -1.f; break;
		case TIMER_ADV_2_MINUTES: mCurrentTurnTimeLeft = 120.f; break;
		case TIMER_ADV_3_MINUTES: mCurrentTurnTimeLeft = 180.f; break;
		case TIMER_ADV_5_MINUTES: mCurrentTurnTimeLeft = 300.f; break;
		case TIMER_ADV_10_MINUTES: mCurrentTurnTimeLeft = 600.f; break;
		case TIMER_ADV_15_MINUTES: mCurrentTurnTimeLeft = 900.f; break;
	}
	//mCurrentTurnTimeLeft = 15.f; // TODO: REMOVE AFTER TEST
	if( mCurrentTurnTimeLeft != -1.f )
	{
		mPlayerControllerInstance.GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SetTimerMax( mCurrentTurnTimeLeft );
	}
}

function UpdateCurrentTurnTimer( float elapsedTime )
{
	local int previousSecond, currentSecond;
	local H7Player player;

	if(mTurnTimerPaused)
	{
		return;
	}

	foreach mPlayers(player)
	{
		if(!player.IsNeutralPlayer() && player.IsInCombat())
		{
			return;
		}
	}

	if( mCurrentTurnTimeLeft != -1.f && mCurrentTurnTimeLeft != 0.f )
	{
		previousSecond = mCurrentTurnTimeLeft;
		mCurrentTurnTimeLeft -= elapsedTime;
		currentSecond = mCurrentTurnTimeLeft;

		if( currentSecond != previousSecond )
		{
			mPlayerControllerInstance.GetAdventureHud().GetAdventureHudCntl().GetMPTurnInfo().SetCurrentTimeLeft( mCurrentTurnTimeLeft <= 0.f ? 0 : int(mCurrentTurnTimeLeft) );
		}
		
		if( mCurrentTurnTimeLeft <= 0.f
			&& !mPlayerControllerInstance.IsCommandRequested() && mPlayerControllerInstance.GetHud().GetHUDMode() == HM_NORMAL 
			&& !class'H7AdventurePlayerController'.static.GetAdventurePlayerController().IsNormalCombatAboutToBegin() 
			&& class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetRetreatingArmy() == none
			&& !GetLocalPlayer().GetQuestController().IsGameEnd())
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("ADV FORCED END TURN", 0);;
			mCurrentTurnTimeLeft = 0.f;
			if( GetCurrentPlayer().IsControlledByLocalPlayer() )
			{
				EndMyTurn();
				if(WorldInfo.GRI.IsMultiplayerGame())
				{
					mPlayerControllerInstance.GetHud().SetHUDMode(HM_WAITING_FOR_OTHERS_TURN);
					mPlayerControllerInstance.SetIsUnrealInputAllowed(false);
				}
			}
		}
	}
}

function ResetCurrentRetreatTimer()
{
	mCurrentRetreatTimeLeft = RETREAT_TIMER;
}

function CleanCurrentRetreatTimer()
{
	mCurrentRetreatTimeLeft = 0.0f;
	class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().HandleRetreatCancelled(class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetRetreatingArmy().GetHero().GetID());
}

function UpdateCurrentRetreatTimer(float elapsedTime)
{
	local int previousSecond, currentSecond;

	if( mCurrentRetreatTimeLeft > 0.f )
	{
		previousSecond = mCurrentRetreatTimeLeft;
		mCurrentRetreatTimeLeft -= elapsedTime;
		currentSecond = mCurrentRetreatTimeLeft;
		
		if( currentSecond != previousSecond )
		{
			// TODO: Update GUI
		}

		if(mCurrentRetreatTimeLeft <= 0.f)
		{
			mCurrentRetreatTimeLeft = 0.f;
			class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().HandleRetreatCancelled(class'H7AdventurePlayerController'.static.GetAdventurePlayerController().GetRetreatingArmy().GetHero().GetID());
		}
	}
}

function ClearRetreatTimer()
{
	// TODO: Update GUI
}

// ends days, starts next day, triggers weekly popups
function int SetNextPlayer(int currentPlayer, bool isGameStart)
{
	local H7Player player;

	if( currentPlayer == mPlayers.Length - 1 )
	{
		UpdateEvents(ON_END_OF_DAY);

		SetCurrentPlayerIndex( 1 );
		currentPlayer = 1;
		++mTurnCounter;
		
		if( GetAI().GetRecruitStep() + 1 == mAdventureConfiguration.mAiAdvMapConfig.mConfigRecruitmentInterval )
		{
			GetAI().SetRecruitStep( 0 );
		}
		else
		{
			GetAI().SetRecruitStep( GetAI().GetRecruitStep() + 1 );
		}

		mCalendar.NextDay();
		UpdateHerosNewTurn();

		if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
		{
			// don't ever deffer game logic in multiplayer..
			mHallOfHeroesManager.UpdateEndDay( mCalendar.GetCalendarDay() == 1 );
		}
		else if( mCalendar.GetCalendarDay() == 1 )
		{
			//deferred spawning of heroes
			mPlayerControllerInstance.GetHud().SetFrameTimer(10,UpdateEndDayDelayedWeekStart);
		}
		else
		{
			mHallOfHeroesManager.UpdateEndDay(false);
		}
		
		// if new week -> update spyInfo
		if(mCalendar.GetCalendarDay() == 1)
		{
			foreach mPlayers(player)
			{ 
				if(!player.IsNeutralPlayer()) player.GetThievesGuildManager().UpdateSpyInfo(); 
			}
		}
	}
	else
	{
		SetCurrentPlayerIndex( currentPlayer + 1 );
		currentPlayer++;
	}

	//  show weekly popup (moved to StartPlayerTurn now for testing)
	/*
	if( !isGameStart && mCalendar.GetCalendarDay() == 1 && GetCurrentPlayer().IsControlledByLocalPlayer() )
	{
		mPlayerControllerInstance.GetAdventureHud().GetWindowWeeklyCntl().setData(mCalendar.GetCurrentWeek().GetName(), mCalendar.GetCurrentWeek().GetDescription());
	}
	*/

	;

	return currentPlayer;
}

function HandleStartOfTurnMessages(H7Player currentPlayer) // startturn
{
	local array<H7AdventureHero> heroes;
	local H7AdventureHero hero;
	local array<H7Town> towns;
	local H7Town town;
	local H7Message message;
	// are there heroes with skillpoints?
	heroes = GetCurrentPlayerHeroes(false);
	foreach heroes(hero)
	{
		if(hero.GetSkillPoints() > 0)
		{
			// this message will either go to random skilling or skill wheel when clicked, depening on setting
			// OPTIONAL make different worded message for each setting
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroSkillpoints.CreateMessageBasedOnMe();
			message.mPlayerNumber = hero.GetPlayer().GetPlayerNumber();
			message.AddRepl("%hero",hero.GetName());
			message.AddRepl("%skillpoints",String(hero.GetSkillPoints()));
			message.settings.referenceObject = hero;
			message.settings.referenceWindowCntl = mPlayerControllerInstance.GetAdventureHud().GetSkillwheelCntl(); 
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}

	// are there towns without specs?
	towns = GetTownList();
	foreach towns(town)
	{
		if(town.GetPlayer() == currentPlayer)
		{
			town.UpdateMagicGuildMessage();
		}
	}
	
}

function CalculateInputAllowed( optional H7Player thePlayer = none )
{
	if( thePlayer == none )
	{
		thePlayer = GetCurrentPlayer();
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && !thePlayer.IsControlledByLocalPlayer() )
	{
		return;
	}

	mPlayerControllerInstance.SetIsUnrealInputAllowed( thePlayer.IsControlledByLocalPlayer() );
}

// whoami getme
function H7Player GetLocalPlayer(optional bool allowNone=false){}

// Used of out of sync checks in multiplayer
function int GetTotalUnitsCount()
{
	local int unitsCount;
	local H7AdventureArmy army;

	foreach mArmies(army)
	{
		if(army.GetPlayer().IsNeutralPlayer())
		{
			continue;
		}

		unitsCount += army.GetCreatureAmountTotal();
	}

	return unitsCount;
}

// Used of out of sync checks in multiplayer
function int GetTotalResCount()
{
	local int resCount, i, resAmount;
	local array<int> resAmounts;
	local H7Player pl;

	for(i=1; i<mPlayers.Length; i++)
	{
		pl = GetPlayerByNumber(EPlayerNumber(i));
		resAmounts = pl.GetResourceSet().GetAllResourceAmounts();

		foreach resAmounts(resAmount)
		{
			resCount += resAmount;
		}

		resAmounts = pl.GetAiSaveUpSpendingHero().GetAllResourceAmounts();

		foreach resAmounts(resAmount)
		{
			resCount += resAmount;
		}

		resAmounts = pl.GetAiSaveUpSpendingRecruitment().GetAllResourceAmounts();

		foreach resAmounts(resAmount)
		{
			resCount += resAmount;
		}

		resAmounts = pl.GetAiSaveUpSpendingTownDev().GetAllResourceAmounts();

		foreach resAmounts(resAmount)
		{
			resCount += resAmount;
		}
	}

	return resCount;
}

function H7Player FindLocalPlayer(){}

function bool IsHotSeat(){}

function UpdateTownsAI( H7Player ply, optional bool calcHeroRecruit = true )
{
	local array<H7Town> towns;
	local H7Town town;
	local bool townIsThreatened;
	local H7Dwelling dwelling;
	local array<H7Fort> forts;
	local H7Fort fort;

	if( ply==None ) return;

	
	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	foreach mDwellingList( dwelling )
	{
		if( dwelling.GetPlayer() == ply && !dwelling.IsUpgraded() )
		{
			dwelling.Upgrade( ply );
		}
	}

	forts = ply.GetForts();

	foreach forts( fort )
	{
		mAI.ThinkTown( fort );
	}

	towns=ply.GetTowns();
	
	foreach towns( town )
	{
		town.CalculateThreat();
		if( town.GetAiThreatLevel() > 0 )
		{
			townIsThreatened = true;
		}
	}
	
	RecalculateTownCaravanChainAI( ply );
	if( townIsThreatened )
	{
		towns.Sort( SortTownByThreatDescending );
		foreach towns( town )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			mAI.ThinkTown( town, calcHeroRecruit );
		}
	}
	else
	{
		foreach towns( town )
		{
			if(town!=None && !town.IsAiDone() && town.GetAiIsMain()==true)
			{
				mAI.ThinkTown( town, calcHeroRecruit );
			}
		}
		foreach towns( town )
		{
			if(town!=None && !town.IsAiDone() && town.GetAiIsMain()==false)
			{
				mAI.ThinkTown( town, calcHeroRecruit );
			}
		}
	}
}

function RecalculateTownCaravanChainAI( H7Player dasPlayer )
{
	local array<H7Town> towns, targets;
	local H7Town town, target;
	local int targetAmount;
	local int targetCounter;

	if(!mAI.IsAiEnabled())
	{
		return;
	}

	towns = dasPlayer.GetTowns();
	targets = dasPlayer.GetCaravanTargets();
	targetAmount = targets.Length;
	if( targetAmount == 0 )
	{
		return;
	}
	foreach towns( town )
	{
		town.SetCurrentCaravanTarget( none );
		town.ClearCaravanSources();
	}

	foreach targets( town )
	{
		towns.RemoveItem( town );
	}

	targetCounter = 0;
	foreach towns( town )
	{
		if( town.GetAiThreatLevel() <= 0.0f && targets.Find( town ) == INDEX_NONE )
		{
			target = targets[ targetCounter % targetAmount ];
			town.SetCurrentCaravanTarget( target );
			target.AddCaravanSource( town );
			++targetCounter;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}
}

function int SortTownByThreatDescending( H7Town a, H7Town b )
{
	return a.GetAiThreatLevel() < b.GetAiThreatLevel() ? -1 : 0; 
}

// from a list of heroes, determines which one should be selected (i.e. at the start of a player's turn)
// OPTIONAL select the one which with the last turn was ended
function H7AdventureArmy GetArmyToSelect(array<H7AdventureHero> heroes){}

function GetPlayerArmyToSelect(){}

// armyWHero = armyToSelect
function UpdateHUD(optional array<H7AdventureHero> heroes, optional H7AdventureArmy armyToSelect, optional bool shouldSelectArmy = true, optional bool shouldFocus = false, optional bool isNewTurn = false )
{
	local H7AdventureHudCntl advHUDCntl;
	local array<H7Town> towns;

	if( mIsDeserializing ) { return; } // no need to update the HUD if we are currently only loading data

	if(GetLocalPlayer() == none ) return;
	
	if(heroes.Length == 0)
	{
//		heroes = GetLocalPlayerHeroes(true);
		heroes = GetCurrentPlayerHeroes(false);
		if( armyToSelect == none )
		{
			armyToSelect = GetArmyToSelect(heroes);
		}
	}

	advHUDCntl = class'H7AdventureHudCntl'.static.GetInstance();

	// player buffs
	advHUDCntl.GetPlayerBuffs().SetPlayer(class'H7AdventureController'.static.GetInstance().GetLocalPlayer());

	// phasing out with listeners:
	if ( advHUDCntl != None && GetCurrentPlayer().GetPlayerType() != PLAYER_AI )
	{
		advHUDCntl.GetHeroHUD().SetHeroes(heroes);
		if( armyToSelect != none && shouldSelectArmy )
		{
			advHUDCntl.GetHeroHUD().SelectHeroByHero( armyToSelect.GetHero() );
		}
		advHUDCntl.GetTownList().SetData(GetLocalPlayer().GetTowns());
	}
	
	// stays in (for now):
	if (advHUDCntl != None && GetLocalPlayer().GetPlayerNumber() > 0 )
	{
		if(isNewTurn)
			advHUDCntl.GetTopBar().UpdateAllResourceAmountsAndIconsNewTurn(GetLocalPlayer().GetResourceSet().GetAllResourcesAsArray());
		else
			advHUDCntl.GetTopBar().UpdateAllResourceAmountsAndIcons(GetLocalPlayer().GetResourceSet().GetAllResourcesAsArray());
		
		//advHUDCntl.GetTopBar().UpdateAllResourceAmountsAndIcons(GetLocalPlayer().GetResourceSet().GetAllResourcesAsArray());
		//advHUDCntl.GetTopBar().UpdateAllResourceAmountsAndIconsNewTurn(GetLocalPlayer().GetResourceSet().GetAllResourcesAsArray());
		advHUDCntl.GetCommandPanel().UpdateDate( mCalendar.GetCalendarDay(), mCalendar.GetCalendarWeek(), mCalendar.GetCalendarMonth(), mCalendar.GetCalendarYearForGUI(),mCalendar.GetCurrentWeek().GetName(), mCalendar.GetCurrentWeek().GetDescription() ); 
		advHUDCntl.GetMinimap().Update();
	}

	if( shouldSelectArmy ) 
	{
		towns = GetCurrentPlayer().GetTowns();

		if(armyToSelect != none && !armyToSelect.IsGarrisoned() && !armyToSelect.IsDead())
		{
			SelectArmy( armyToSelect, shouldFocus );
		}
		else // can not select armyToSelect or is none
		{
			SelectArmy(none);
			advHUDCntl.GetHeroHUD().SelectHeroByHero(none); // GUI will select no one
			if(towns.Length > 0 && GetCurrentPlayer().IsControlledByLocalPlayer()) // If there is not army to select, select current players town with highest level
			{
				class'H7Camera'.static.GetInstance().SetFocusActor(GetCurrentPlayer().GetBestTown(),, true);
			}
		}
	}

	if( armyToSelect == none )
	{
		mGridManager.GetPathPreviewer().HidePreview();
	}
}

protected function UpdateHerosNewTurn()
{
	local H7AdventureArmy army;
	local H7Caravanarmy caravan;

	// refill movement points and 'finished-turn' indicator
	foreach mArmies( army )
	{
		if( army.GetHero() != none )
		{
			army.GetHero().SetCurrentMovementPoints( army.GetHero().GetMovementPoints() );
			army.GetHero().RegenMana();
			army.GetHero().SetFinishedCurrentTurn(false);
		}
	}
	foreach mActiveCarravans (caravan)
	{
		caravan.GetHero().SetCurrentMovementPoints( caravan.GetHero().GetMovementPoints() );
	}
}

function ReleaseCombatMap( bool isReplayCombat )
{
	local WorldInfo myWorld;
	local array<name> mapArray;
	local H7CombatMapGridController gridController;
		
	myWorld = class'WorldInfo'.static.GetWorldInfo();

	if( myWorld != None )
	{
		if( isReplayCombat )
		{
			mapArray.AddItem( name("empty") );
		}
		else
		{
			PrepareAdventureMapForCombatReturn();
//			mapArray = class'H7ReplicationInfo'.static.GetInstance().GetPreviousStreamingLevels();

			if( mapArray.Length == 0 )
			{
				mapArray.AddItem( name("empty") ); // we need to add at least one map so unreal will unload the combat map( we just load an empty map )
			}
		}

		gridController = class'H7CombatMapGridController'.static.GetInstance();

		gridController.UnregisterEvents();
		gridController.ClearParticles();
		gridController.DestroyGrid();
		CleanCombatMapForGC( mCombatMapName );

		myWorld.PrepareMapChange( mapArray );
		myWorld.CommitMapChange(true);
	}
}

function CleanCombatMapForGC( string combatMapName ){}
function PrepareAdventureMapForCombat(){}
function PrepareAdventureMapForCombatReturn(){}

function ResetAdventurePostProcess( ){}

public function DoBackToAdventureFromCombat( H7AdventureArmy victoriousArmy, H7AdventureArmy defeatArmy) // gobacktoadv
{
	local H7PlayerController playerCtrl;
	local int i;

	playerCtrl = mPlayerControllerInstance;

	ReleaseCombatMap( false );

	class'H7ReplicationInfo'.static.GetInstance().ResetFakeRandomNumbers();
	mPlayerControllerInstance.GetHUD().GetCombatPopUpCntl().mOnCombatMap = false;

	// set up back the adventure map
	class'H7ReplicationInfo'.static.GetInstance().SetIsAdventureMap();
	playerCtrl.ResetHUDOverCounter();
	CalculateInputAllowed();
	

	// Make sure there are no commands left from combat, we assume all commands in queue were called in combat
	if( mCommandQueue.GetCurrentCommand() != none 
		&& mCommandQueue.GetCurrentCommand().GetCommandSource() != none
		&& (mCommandQueue.GetCurrentCommand().GetCommandSource().GetPlayer() == victoriousArmy.GetPlayer() || mCommandQueue.GetCurrentCommand().GetCommandSource().GetPlayer() == defeatArmy.GetPlayer()))
	{
		mCommandQueue.GetCurrentCommand().CommandStop();
	}
	mPlayerControllerInstance.SetCommandRequested(false);
	
	// AI Automated test build.
	if (!class'H7AdventureController'.static.GetInstance().IsAutomatedTestingAIEnabled())
	{
		// Safeguard so Control over HumanPlayers returns to Humans
		if(victoriousArmy.GetPlayer().GetPlayerType() == PLAYER_HUMAN && victoriousArmy.GetPlayer().IsControlledByAI())
		{
			victoriousArmy.GetPlayer().SetControlledByAI(false);
		}
		
		if(defeatArmy.GetPlayer().GetPlayerType() == PLAYER_HUMAN && defeatArmy.GetPlayer().IsControlledByAI())
		{
			defeatArmy.GetPlayer().GetPlayer().SetControlledByAI(false);
		}
	}

	// set back huds
	playerCtrl.GetCombatMapHud().SetCombatHudVisible(false);
	class'H7LogSystemCntl'.static.GetInstance().GetLog().ClearLog();
	playerCtrl.GetHud().SetAdventureHudVisible(true);
	mPlayers[mCurrentPlayerIndex].IsControlledByLocalPlayer() ? playerCtrl.GetHud().SetHUDMode(HM_NORMAL) : playerCtrl.GetHud().SetHUDMode(HM_WAITING_FOR_OTHERS_TURN);

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().ForceReset();
	class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SetTransitioningToCombat( false );

	class'H7Camera'.static.GetInstance().UseCameraAdventure();

	// select army
	if(victoriousArmy.GetPlayer() == GetCurrentPlayer() || defeatArmy.GetPlayer() == GetCurrentPlayer())
	{
		mAi.DeferExecution(0.1f);

		if( victoriousArmy != none && victoriousArmy.GetPlayer() == GetCurrentPlayer() && !victoriousArmy.IsGarrisoned() && !victoriousArmy.IsDead() )
		{
			SelectArmy( victoriousArmy, true );
		}
		else
		{
			SetSelectedArmy(none);
			AutoSelectArmy();
		}
	}	

	ApplyOutline();

	UpdateHUD( , mSelectedArmy, true, true );

	// TODO: remove after GUI rework (not recreating adventure map gui every time)
	SetTimer(0.1f, false, 'DoBackToAdventureFade');

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().SetCombatMode(false);

		class'H7ReplicationInfo'.static.GetInstance().SetUnitActionsCounter(mBeforeCombatUAC);
		//`LOG("ResetUAC:"@mBeforeCombatUAC);
		mSynchRNG.SetCounter(mBeforeCombatRandomCounter);
		class'H7ReplicationInfo'.static.GetInstance().ResetIDCounterToNewId(mBeforeCombatIdCounter);
		class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().UnqueuePreparedCommands();

		
		if(mPreparedFinishCombatCommand != none)
		{
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(mPreparedFinishCombatCommand);
			mPreparedFinishCombatCommand = none;
		}

		if(mPreparedSpellsToLearn.Length > 0)
		{
			for(i=0; i<mPreparedSpellsToLearn.Length; i++)
			{
				class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(mPreparedSpellsToLearn[i]);
			}

			mPreparedSpellsToLearn.Length = 0;
		}
	}

	if( GetSelectedArmy() != none && GetSelectedArmy().GetPlayer().IsControlledByLocalPlayer() )
	{
		class'H7Camera'.static.GetInstance().SetFocusActor( GetSelectedArmy().GetHero(), GetSelectedArmy().GetPlayerNumber(), false, true );
	}
	class'H7CameraActionController'.static.GetInstance().StartZoomOutToPreviousValues(victoriousArmy.GetPlayer().IsControlledByLocalPlayer() || defeatArmy.GetPlayer().IsControlledByLocalPlayer());
	class'H7CameraActionController'.static.GetInstance().ClearLastAttackerDefender();
	
	InitAdventureMapMusic();
}

// this function is called for all players independant if they traveled to the combat map or not
public function FinishCombat(H7AdventureArmy victoriousArmy, H7AdventureArmy defeatArmy, bool attackerWon, H7BattleSite battleSite, H7RunicBox runicBox, H7AreaOfControlSite aocSite)
{
	local array<H7Town> towns;
	local int i;
	local H7EventContainerStruct conti;

	if( battleSite != none )
	{
		if(!attackerWon)
		{
			battleSite.OnAttackerLostBattle( defeatArmy.GetHero() );
		}
		else
		{
			battleSite.OnAccept( victoriousArmy.GetHero() );
			battleSite.GetReward( victoriousArmy.GetHero() );
		}
	}

	if( H7CaravanOutpost( victoriousArmy.GetGarrisonedSite() ) != none )
	{
		H7CaravanOutpost( victoriousArmy.GetGarrisonedSite() ).UpdateAfterCombat();
	}

	// if they were fighting for a city, update the owner of the city
	if( defeatArmy.GetPlayer() == aocSite.GetPlayer() )
	{
		if( aocSite != none && ( aocSite.IsA( 'H7Town' ) || aocSite.IsA( 'H7Fort' ) || aocSite.IsA( 'H7Garrison' ) ) )
		{
			aocSite.Conquer( victoriousArmy.GetHero() );
		}
		if( aocSite != none && defeatArmy.GetGarrisonedSite() == aocSite && H7CaravanOutpost( aocSite ) != none )
		{
			H7CaravanOutpost( aocSite ).DestroyOutpost( true );
		}
	}

	towns = victoriousArmy.GetPlayer().GetTowns();
	for( i=0; i<towns.Length;++i)
	{
		towns[i].TriggerEvents( ON_BATTLE_WON, false, conti );
	}	

	if( runicBox != none )
	{
		if( attackerWon )
		{
			runicBox.PickUp( victoriousArmy.GetHero() );
		}
		else
		{
			runicBox.RestoreStacks();
		}
	}

	if( H7AbandonedMine( aocSite ) != none )
	{
		if( attackerWon )
		{
			H7AbandonedMine( aocSite ).RestoreMine( victoriousArmy.GetHero() );
		}
	}

	TriggerGlobalEventClass( class'H7SeqEvent_AdvCombatTransition', self, 1 );
	TriggerCombatEvent(victoriousArmy, defeatArmy);

	victoriousArmy.SetIsInCombat( false );
	defeatArmy.SetIsInCombat( false );

	SetBeforeBattleArea(none);
	mCurrentBattleSite = none;
}

protected function DoBackToAdventureFade()
{
	class'H7CameraActionController'.static.GetInstance().FadeFromBlack(0.5f);
}

function AtLeastOneWeekHasPassed()
{
	mWeekPassed = true;
}

/**
 * Utility function to change army selection at any given time
 * for the local player to the first army on his list if
 * there is nothing selected.
 * */
public function AutoSelectArmy( optional bool shouldFocus = true )
{
	local H7AdventureArmy army;

	if( GetSelectedArmy() == none || GetSelectedArmy().IsGarrisoned() || GetSelectedArmy().IsDead() )
	{
		foreach mArmies( army )
		{
			if( !army.IsGarrisoned() && army.GetPlayerNumber() == GetCurrentPlayer().GetPlayerNumber() && !army.IsDead() && army.GetHero().IsHero())
			{
				SelectArmy( army, shouldFocus );
				return;
			}
		}
		
		SelectArmy( none, false);
		if( mBeforeBattleCell != none && !class'H7TownHudCntl'.static.GetInstance().IsInAnyScreen())
		{
			class'H7AdventureHudCntl'.static.GetInstance().MinimapCameraShiftGrid( mBeforeBattleCell.GetCellPosition().X, mBeforeBattleCell.GetCellPosition().Y );
		}
	}
	else
	{
		SelectArmy( GetSelectedArmy(), shouldFocus );
	}
}

public function AutoFocusArmyForPlayer(H7Player pl)
{
	local H7AdventureArmy army;

	foreach mArmies( army )
	{
		if( !army.IsGarrisoned() && army.GetPlayerNumber() == pl.GetPlayerNumber() )
		{
			class'H7Camera'.static.GetInstance().SetFocusActor( army.GetHero(), army.GetPlayerNumber(), true );
			break;
		}
	}
}

public function TriggerQuickCombatStartEvent(H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy)
{
	mHeroEventParam.mEventHeroTemplate = attackingArmy.GetHeroTemplateSource();
	mHeroEventParam.mEventPlayerNumber = attackingArmy.GetHero().GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventEnemyPlayerNumber = defendingArmy.GetHero().GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventTargetArmy = defendingArmy;
	mHeroEventParam.mCombatMapName = mCombatMapName;
	mHeroEventParam.mBeforeBattleCell = mBeforeBattleCell;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_Combat', mHeroEventParam, attackingArmy, 0/*start combat*/);
}

/**
 * Triggers Combat - win/lose event
 * */
public function TriggerCombatEvent(H7AdventureArmy victoriousArmy, H7AdventureArmy defeatArmy)
{
	if( victoriousArmy != none )
	{
		// End potentially ongoing H7SeqAct_AttackArmy action
		victoriousArmy.GetHero().ClearScriptedBehaviour();

		mHeroEventParam.mEventHeroTemplate = victoriousArmy.GetHeroTemplateSource();
		mHeroEventParam.mEventPlayerNumber = victoriousArmy.GetHero().GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventEnemyPlayerNumber = defeatArmy.GetHero().GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventTargetArmy = defeatArmy;
		mHeroEventParam.mCombatMapName = mCombatMapName;
		mHeroEventParam.mEventVictoriousArmy = victoriousArmy;
		mHeroEventParam.mBeforeBattleCell = mBeforeBattleCell;
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_Combat', mHeroEventParam, victoriousArmy, 1/*win*/);

		if(GetCurrentBattleSite() != none && mArmyAttacker == victoriousArmy)
		{
			mHeroEventParam.mBattleSite = GetCurrentBattleSite();
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_BattlesiteWon', mHeroEventParam, victoriousArmy);
		}
	}

	// trigger "combat - lose" event for the defeat army
	if( defeatArmy != none )
	{
		// End potentially ongoing H7SeqAct_AttackArmy action
		defeatArmy.GetHero().ClearScriptedBehaviour();

		mHeroEventParam.mEventHeroTemplate = defeatArmy.GetHeroTemplateSource();
		mHeroEventParam.mEventPlayerNumber = defeatArmy.GetHero().GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventEnemyPlayerNumber = victoriousArmy.GetHero().GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventTargetArmy = victoriousArmy;
		mHeroEventParam.mCombatMapName = mCombatMapName;
		mHeroEventParam.mEventVictoriousArmy = victoriousArmy;
		mHeroEventParam.mBeforeBattleCell = mBeforeBattleCell;
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_Combat', mHeroEventParam, defeatArmy, 2/*lost*/);

		if(GetCurrentBattleSite() != none && mArmyAttacker == defeatArmy)
		{
			mHeroEventParam.mBattleSite = GetCurrentBattleSite();
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_BattlesiteLost', mHeroEventParam, defeatArmy);
		}
	}

	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

function UpdatePlunderDelayForMines( EPlayerNumber currentPlayerNumber )
{
	local H7Mine mine;

	foreach mMineList( mine ) 
	{	
		if( mine.GetPlayerNumber() == currentPlayerNumber )
		{
			mine.UpdatePlunderDelay(); 
		}
	}
}

function UpdatePlunderDelayForAoCBuffSites( EPlayerNumber currentPlayerNumber )
{
	local H7AreaOfControlBuffSite lightHouse;

	foreach mAoCBuffSiteList( lightHouse ) 
	{	
		if( lightHouse.GetPlayerNumber() == currentPlayerNumber )
		{
			lightHouse.UpdatePlunderDelay(); 
		}
	}
}

function UpdateBuiltTodayForTowns( EPlayerNumber currentPlayerNumber )
{
	local H7Town town;

	foreach mTownList( town )
	{
		if( town.GetPlayerNumber() == currentPlayerNumber )
		{
			town.SetBuiltToday( false );
			town.SetDestroyedToday( false );
		}
	}
}

function ResetBuildingStateWeekly()
{
	local H7DenOfThieves den;

	foreach mDenOfThievesList( den )
	{
		den.WeeklyReset();
	}
}

/**
 * Is Called in the end of a day to produce units
 */
event ProduceDayUnits()
{
	local H7Town town;
	local H7Fort fort;
	local H7Garrison garrison;

	foreach mTownList( town )
	{
		town.ProduceDayUnits();
	}

	foreach mFortList( fort )
	{
		fort.ProduceDayUnits();
	}

	foreach mGarrisonList( garrison )
	{
		garrison.ProduceDayUnits();
	}
}

function UpdatePlayerPlunder()
{
	local H7Player dasPlayer;
	local array<H7Player> players;

	players = GetPlayers();
	players.RemoveItem( GetNeutralPlayer() );
	
	foreach players( dasPlayer )
	{
		dasPlayer.ExecutePlunder();
	}
}

/**
 * Is Called in the end of a week to produce units
 */
event ProduceUnitsForSites()
{
	local H7Town town;
	local H7Dwelling dwelling; 
	local H7CustomNeutralDwelling costumDwelling;
	local H7BattleSite battleSite;

	foreach mTownList( town )
	{
		town.ProduceUnits();
	}
	foreach mDwellingList( dwelling )
	{
		dwelling.ProduceUnits();
	}
	foreach mCostumNeutralDwelling( costumDwelling)
	{
		costumDwelling.ProduceUnits();
	}
	foreach mBattleSiteList( battleSite )
	{
		battleSite.WeeklyBattleSideArmyGrowth();
	}
}

function  DeleteCaravan( int caravanID )
{
	local int i; 

	for( i=0; i<mActiveCarravans.Length; ++i) 
	{
		if ( mActiveCarravans[i].GetHero().GetID() == caravanID )
		{
			RemoveCaravan( mActiveCarravans[i] );
			break;
		}
	}
}

// returns if is a siege combat
function bool PreQuickCombatWithCombatArmies( H7AdventureArmy defendingArmy, out H7CombatArmy defendingArmyCombat, out array<H7BaseCreatureStack> localGuardStacks, out H7SiegeTownData siegeTownData )
{
	local int defenderFreeSlots, i;
	local H7Town town;
	local H7Fort fort;
	local H7Garrison garrison;
	local bool isSiege;
	local array<H7BaseCreatureStack> localGuards;

	if( ( defendingArmy.IsGarrisoned() || defendingArmy.IsGarrisonedButOutside() ) )
	{
		town = H7Town( defendingArmy.GetGarrisonedSite() );
		fort = H7Fort( defendingArmy.GetGarrisonedSite() );
		garrison = H7Garrison( defendingArmy.GetGarrisonedSite() );
		if( town != none )
		{
			isSiege = true;
			siegeTownData.Faction = town.GetFaction();
			siegeTownData.WallAndGateLevel = 3;
			siegeTownData.TownLevel = town.GetBuildingLevelByType( class'H7TownHall' );
			siegeTownData.SiegeObstacleTower = town.GetCombatMapTower();
			siegeTownData.SiegeObstacleWall = town.GetCombatMapWall();
			siegeTownData.SiegeObstacleMoat = town.GetCombatMapMoat();
			siegeTownData.SiegeObstacleGate = town.GetCombatMapGate();
			siegeTownData.SiegeDecorationList = town.GetCombatMapDecoList();
			localGuards = town.GetLocalGuardAsBaseCreatureStacks();
			localGuardStacks = town.GetLocalGuardAsBaseCreatureStacks();
		}
		else if( fort != none )
		{
			isSiege = true;
			siegeTownData.Faction = fort.GetFaction();
			siegeTownData.WallAndGateLevel = 3;
			siegeTownData.SiegeObstacleTower = fort.GetCombatMapTower();
			siegeTownData.SiegeObstacleWall = fort.GetCombatMapWall();
			siegeTownData.SiegeObstacleMoat = fort.GetCombatMapMoat();
			siegeTownData.SiegeObstacleGate = fort.GetCombatMapGate();
			siegeTownData.SiegeDecorationList = fort.GetCombatMapDecoList();
			localGuardStacks = fort.GetLocalGuardAsBaseCreatureStacks();
			localGuards = fort.GetLocalGuardAsBaseCreatureStacks();
		}
		else if( garrison != none )
		{
			isSiege = true;
			siegeTownData.Faction = garrison.GetFaction();
			siegeTownData.WallAndGateLevel = 3;
			siegeTownData.SiegeObstacleTower = garrison.GetCombatMapTower();
			siegeTownData.SiegeObstacleWall = garrison.GetCombatMapWall();
			siegeTownData.SiegeObstacleMoat = garrison.GetCombatMapMoat();
			siegeTownData.SiegeObstacleGate = garrison.GetCombatMapGate();
			siegeTownData.SiegeDecorationList = garrison.GetCombatMapDecoList();
			localGuardStacks = garrison.GetLocalGuardAsBaseCreatureStacks();
			localGuards = garrison.GetLocalGuardAsBaseCreatureStacks();
		}
	}

	//merge local guard and defending army
	if(localGuardStacks.Length > 0)
	{
		defenderFreeSlots = class'H7EditorArmy'.const.MAX_ARMY_SIZE - defendingArmy.GetNumberOfFilledSlots();
		
		if(defenderFreeSlots > 0)
		{
			for(i = localGuards.Length-1; i >= 0; i--)
			{
				if( localGuards[ i ] == none || localGuards[ i ].GetStackType() == none
					|| localGuards[ i ].GetStackSize() <= 0)
					continue;

				defendingArmyCombat.AddCreatureStack( localGuards[ i ] );
				;
			
				if(defendingArmyCombat.GetNumberOfFilledSlots() >= class'H7EditorArmy'.const.MAX_ARMY_SIZE)
					break;
			}
		}
	}

	return isSiege;
}

function LogQuickCombatHeroData(H7QuickCombatHero hero)
{
	//if(hero.Hero != none)
	//{
	//	`LOG("--- combatArmy ---"@hero.Hero.GetName());
	//}
	//else
	//{
	//	`LOG("--- combatArmy ---");
	//}
	//`LOG("allowedToCast"@hero.AllowedToCast);
	//`LOG("AmountOfWarcries"@hero.AmountOfWarcries);
	//`LOG("Attack"@hero.Attack);
	//`LOG("DamageMax"@hero.DamageMax);
	//`LOG("DamageMin"@hero.DamageMin);
	//`LOG("Defense"@hero.Defense);
	//`LOG("HasArtilleryBarrage"@hero.HasArtilleryBarrage);
	//`LOG("HasPerfectWarfare"@hero.HasPerfectWarfare);
	//`LOG("HasSiegeWarfare"@hero.HasSiegeWarfare);
	//`LOG("HasWarcry"@hero.HasWarcry);
	//`LOG("HasWarlord"@hero.HasWarlord);
	//`LOG("IsHero"@hero.IsHero);
	//`LOG("Luck"@hero.Luck);
	//`LOG("Mana"@hero.Mana);
	//`LOG("Morale"@hero.Morale);
	//`LOG("Spells count:"@hero.Spells.Length);
	//`LOG("SumSpellValue"@hero.SumSpellValue);
	//`LOG("WarcryRank"@hero.WarcryRank);
	//`LOG("WarfareRank"@hero.WarfareRank);
}

/**
 * Calculates quick combat values for two armies, and modifies armies
 * according to combat results. At the end of this function, one of
 * the armies will be defeated, i.e. taken out of the map and the
 * other will have its stack properties and Hero XP altered.
 * 
 * 
 * @param   attackingArmy           The army that initiated the combat
 * @param   defendingArmy           The army that is currently defending
 * 
 * @return  attackerWon             Return true if attacker won, false if attacker lost
 * */
function bool QuickCombatWithCombatArmies( out H7CombatArmy attackingArmy, out H7CombatArmy defendingArmy, optional bool isSiege, optional H7SiegeTownData siegeData )
{
	local array<H7BaseCreatureStack> baseStacksAttacker, baseStacksDefender;
	local H7QuickCombatHero quickCombatHeroAttacker, quickCombatHeroDefender;
	local array<H7QuickCombatStack> quickCombatStacksAttacker, quickCombatStacksDefender, quickCombatTowers, quickCombatWarfareAttacker, quickCombatWarfareDefender;
	local array<H7QuickCombatStack> queue;
	local H7QuickCombatStack stack;
	local bool isOngoing, attackerWon, isAIAgainstNeutral;
	local int i, targetIndex, queueIndex, roundCount, j, wasFriendly;
	local float armyRelation, originalAttackerStrength, originalDefenderStrength;
	local H7HeroAbility usedSpell;
	local array<int> targetIndices;
	local string recapString;
	local bool canMove;
	local float wallStrength, wuDamage, minRound, minChance, maxRound;
	local bool moralePenalty;
	local float stackHealthMultiplier;
	local int stackIndex;
	//local array<H7BaseCreatureStack> stacks;
	//local H7BaseCreatureStack sstack;

	originalAttackerStrength = originalAttackerStrength;
	originalDefenderStrength = originalDefenderStrength;

	if( isSiege )
	{
		if( siegeData.WallAndGateLevel == 0 )
		{
			canMove = true;
		}
		else
		{
			wallStrength = siegeData.WallAndGateLevel + 1;
			if( siegeData.HasShootingTowers )
			{
				CreateQuickCombatTowers( siegeData.SiegeObstacleTower.GetTowerUnitArchetype(), quickCombatTowers );
			}
			canMove = false;
		}
	}
	else
	{
		canMove = true;
	}
	attackingArmy.UpdatedAlliesAndEnemies();
	defendingArmy.UpdatedAlliesAndEnemies();

	baseStacksAttacker = attackingArmy.GetBaseCreatureStacks();
	baseStacksDefender = defendingArmy.GetBaseCreatureStacks();

	originalAttackerStrength = attackingArmy.GetStrengthValue();
	originalDefenderStrength = defendingArmy.GetStrengthValue();
	if(defendingArmy.GetStrengthValue(attackingArmy.GetHero().IsHero())>0.0f)
	{
		armyRelation = attackingArmy.GetStrengthValue( attackingArmy.GetHero().IsHero() ) / defendingArmy.GetStrengthValue( attackingArmy.GetHero().IsHero() );
	}
	else
	{
		armyRelation = attackingArmy.GetStrengthValue(attackingArmy.GetHero().IsHero());
	}

	CreateQuickCombatHero( attackingArmy.GetHero(), quickCombatHeroAttacker, armyRelation );
	CreateQuickCombatHero( defendingArmy.GetHero(), quickCombatHeroDefender, armyRelation );

	//LogQuickCombatHeroData(quickCombatHeroAttacker);
	//stacks = attackingArmy.GetBaseCreatureStacks();
	//`LOG("attacker stacks.Length:"@stacks.Length);
	//foreach stacks(sstack)
	//{
	//	`LOG("attacker Creature:"@sstack.GetStackType().GetName()@sstack.GetStackSize());
	//}
	//LogQuickCombatHeroData(quickCombatHeroDefender);
	//stacks = defendingArmy.GetBaseCreatureStacks();
	//`LOG("defender stacks.Length:"@stacks.Length);
	//foreach stacks(sstack)
	//{
	//	`LOG("defender Creature:"@sstack.GetStackType().GetName()@sstack.GetStackSize());
	//}

	//bonus for AI vs Neutral Stacks
	if( attackingArmy.GetPlayer().IsControlledByAI() && attackingArmy.GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER && defendingArmy.GetPlayerNumber() == PN_NEUTRAL_PLAYER )
	{
		stackHealthMultiplier = mAdventureConfiguration.mAiAdvMapConfig.mConfigHPBoostVsNeutralMultiplier;
		isAIAgainstNeutral = true;
	}
	else
	{
		stackHealthMultiplier = 1.0f;
	}
	moralePenalty = attackingArmy.GetFactionsInArmyCount() >= 2;

	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	CreateQuickCombatStacks( baseStacksAttacker, quickCombatHeroAttacker, quickCombatStacksAttacker, true, moralePenalty, stackHealthMultiplier ); 
	if( defendingArmy.GetPlayer().IsControlledByAI() && defendingArmy.GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER && attackingArmy.GetPlayerNumber() == PN_NEUTRAL_PLAYER )
	{
		stackHealthMultiplier = mAdventureConfiguration.mAiAdvMapConfig.mConfigHPBoostVsNeutralMultiplier;
	}
	else
	{
		stackHealthMultiplier = 1.0f;
	}
	moralePenalty = defendingArmy.GetFactionsInArmyCount() >= 2;
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;

	CreateQuickCombatStacks( baseStacksDefender, quickCombatHeroDefender, quickCombatStacksDefender, false, moralePenalty, stackHealthMultiplier ); 
	CreateQuickCombatWarfareUnits( attackingArmy.GetWarUnitTemplates(), quickCombatWarfareAttacker, true );
	CreateQuickCombatWarfareUnits( defendingArmy.GetWarUnitTemplates(), quickCombatWarfareDefender, false );
	
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;

	foreach quickCombatStacksAttacker( stack )
	{
		queue.AddItem( stack );
	}
	foreach quickCombatStacksDefender( stack )
	{
		queue.AddItem( stack );
	}
	foreach quickCombatWarfareAttacker( stack )
	{
		if( stack.BaseWarUnit.GetWarUnitClass() == WCLASS_HYBRID )
		{
			queue.AddItem( stack );
		}
		queue.AddItem( stack );
	}
	foreach quickCombatWarfareDefender( stack )
	{
		if( stack.BaseWarUnit.GetWarUnitClass() == WCLASS_HYBRID )
		{
			queue.AddItem( stack );
		}
		queue.AddItem( stack );
	}
	foreach quickCombatTowers( stack )
	{
		queue.AddItem( stack );
	}

	queue.Sort( ShuffleQuickCombatQueue );
	queue.Sort( SortQuickCombatQueue );
	foreach queue( stack )
	{
		if( stack.StackType == QCST_CREATURE )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		else if( stack.StackType == QCST_WARFARE )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
		else if( stack.StackType == QCST_TOWER )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}
	wuDamage = 1 + float( quickCombatHeroAttacker.WarfareRank ) / 2.0f;
	minRound = wallStrength / wuDamage;
	minChance = 1 / wallStrength ** ( wallStrength - 1 );
	maxRound = 5 * ( wallStrength - 1 );

	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	isOngoing = true;
	roundCount = 0;
	while( isOngoing )
	{
		if( !canMove )
		{
			if( quickCombatHeroAttacker.HasSiegeWarfare )
			{
				wallStrength -= 2 * wuDamage;
				if( wallStrength <= 0 )
				{
					canMove = true;
				}
			}
			else
			{
				if( roundCount >= wallStrength / wuDamage )
				{
					if( mRNGQuickCombat.GetFloatNative() <= minChance + ( 1 - minChance ) * FMax( 0.0f, ( roundCount - minRound ) / ( maxRound - minRound ) ) )
					{
						canMove = true;
					}
				}
			}
		}

		for( i = 0; i < queue.Length; ++i )
		{
			if( queue[i].IsDead || // skip when already dead
				isAIAgainstNeutral && !queue[i].IsAttacker && roundCount < 5 ) //or skip enemies in the first few rounds when AI is fighting against neutral
			{ 
				//`LOG("SKIP AI FOR NOW"@queue[i].BaseStack.GetStackType().GetName());
				continue; 
			}

			if( queue[i].IsAttacker )
			{
				if( !quickCombatHeroAttacker.MadeTurn && quickCombatHeroAttacker.IsHero )
				{
					usedSpell = none;
					targetIndices = DoQuickCombatHeroAction( quickCombatHeroAttacker, quickCombatStacksDefender, quickCombatStacksAttacker, armyRelation, usedSpell );
					
					if( usedSpell != none && usedSpell.GetQuickCombatTargetType() )
					{
						for( j = 0; j < targetIndices.Length; ++j )
						{
							queueIndex = queue.Find( 'BaseStack', quickCombatStacksAttacker[ targetIndices[j] ].BaseStack );
							queue[ queueIndex ] = quickCombatStacksAttacker[ targetIndices[j] ];
						}
					}
					else
					{
						for( j = 0; j < targetIndices.Length; ++j )
						{
							queueIndex = queue.Find( 'BaseStack', quickCombatStacksDefender[ targetIndices[j] ].BaseStack );
							queue[ queueIndex ] = quickCombatStacksDefender[ targetIndices[j] ];
						}
						for( j = 0; j < targetIndices.Length; ++j )
						{
							if( quickCombatStacksDefender[ targetIndices[j] ].IsDead )
							{
								quickCombatStacksDefender.Remove( targetIndices[j], 1 );
							}
						}
					}
				}
				if( queue[i].StackType == QCST_CREATURE )
				{
					targetIndex = DoQuickCombatCreatureAction( queue[i], quickCombatStacksDefender, canMove );
				}
				else if( queue[i].StackType == QCST_WARFARE )
				{
					targetIndex = DoQuickCombatWarfareUnitAction( queue[i], quickCombatStacksAttacker, quickCombatStacksDefender, wasFriendly, quickCombatHeroAttacker );
				}

				stackIndex = quickCombatStacksAttacker.Find( 'BaseStack', queue[i].BaseStack );
				if( queue[i].BaseWarUnit == none  )
				{
					quickCombatStacksAttacker[ stackIndex ] = queue[i];
				}

				if( targetIndex != INDEX_NONE )
				{
					if( queue[i].StackType == QCST_WARFARE && wasFriendly == 1 )
					{
						queueIndex = queue.Find( 'BaseStack', quickCombatStacksAttacker[ targetIndex ].BaseStack );
						queue[ queueIndex ] = quickCombatStacksAttacker[ targetIndex ];
					}
					else
					{
						queueIndex = queue.Find( 'BaseStack', quickCombatStacksDefender[ targetIndex ].BaseStack );
						queue[ queueIndex ] = quickCombatStacksDefender[ targetIndex ];
						if( quickCombatStacksDefender[ targetIndex ].IsDead )
						{
							quickCombatStacksDefender.Remove( targetIndex, 1 );
						}
					}
				}

			}
			else
			{
				if( !quickCombatHeroDefender.MadeTurn && quickCombatHeroDefender.IsHero )
				{
					usedSpell = none;
					targetIndices = DoQuickCombatHeroAction( quickCombatHeroDefender, quickCombatStacksAttacker, quickCombatStacksDefender, armyRelation, usedSpell );
					if( usedSpell != none && usedSpell.GetQuickCombatTargetType() )
					{
						for( j = 0; j < targetIndices.Length; ++j )
						{
							queueIndex = queue.Find( 'BaseStack', quickCombatStacksDefender[ targetIndices[j] ].BaseStack );
							queue[ queueIndex ] = quickCombatStacksDefender[ targetIndices[j] ];
						}
					}
					else
					{
						for( j = 0; j < targetIndices.Length; ++j )
						{
							queueIndex = queue.Find( 'BaseStack', quickCombatStacksAttacker[ targetIndices[j] ].BaseStack );
							queue[ queueIndex ] = quickCombatStacksAttacker[ targetIndices[j] ];
						}
						for( j = 0; j < targetIndices.Length; ++j )
						{
							if( quickCombatStacksAttacker[ targetIndices[j] ].IsDead )
							{
								quickCombatStacksAttacker.Remove( targetIndices[j], 1 );
							}
						}
					}
				}

				if( queue[i].StackType == QCST_CREATURE )
				{
					targetIndex = DoQuickCombatCreatureAction( queue[i], quickCombatStacksAttacker, canMove );
				}
				else if( queue[i].StackType == QCST_WARFARE )
				{
					targetIndex = DoQuickCombatWarfareUnitAction( queue[i], quickCombatStacksDefender, quickCombatStacksAttacker, wasFriendly, quickCombatHeroDefender );
				}
				else if( queue[i].StackType == QCST_TOWER )
				{
					targetIndex = DoQuickCombatTowerAction( queue[i], quickCombatStacksAttacker );
				}

				stackIndex = quickCombatStacksDefender.Find( 'BaseStack', queue[i].BaseStack );
				if( queue[i].BaseWarUnit == none )
				{
					quickCombatStacksDefender[ stackIndex ] = queue[i];
				}

				if( targetIndex != INDEX_NONE )
				{
					if( queue[i].StackType == QCST_WARFARE && wasFriendly == 1 )
					{
						queueIndex = queue.Find( 'BaseStack', quickCombatStacksDefender[ targetIndex ].BaseStack );
						queue[ queueIndex ] = quickCombatStacksDefender[ targetIndex ];
					}
					else
					{
						queueIndex = queue.Find( 'BaseStack', quickCombatStacksAttacker[ targetIndex ].BaseStack );
						queue[ queueIndex ] = quickCombatStacksAttacker[ targetIndex ];
						if( quickCombatStacksAttacker[ targetIndex ].IsDead )
						{
							quickCombatStacksAttacker.Remove( targetIndex, 1 );
						}
					}
				}
			}
		}
		if( quickCombatStacksAttacker.Length == 0 || quickCombatStacksDefender.Length == 0 )
		{
			isOngoing = false;
			attackerWon = quickCombatStacksDefender.Length == 0 ? true : false;
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		}
		if( isOngoing )
		{
			ResetQuickCombatRound( queue, quickCombatHeroAttacker, quickCombatHeroDefender );
		}
		recapString = "Round"@roundCount+1@"ended with |";
		foreach quickCombatStacksAttacker( stack )
		{
			recapString = recapString @ stack.StackSize @ stack.BaseStack.GetStackType().GetName() $ " | ";
		}
		recapString = recapString @ "for attacker";
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		if( !isOngoing )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}

		recapString = "Round"@roundCount+1@"ended with |";
		foreach quickCombatStacksDefender( stack )
		{
			recapString = recapString @ stack.StackSize @ stack.BaseStack.GetStackType().GetName() $ " | ";
		}
		recapString = recapString @ "for defender";
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		if( !isOngoing )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}

		++roundCount;
	}

	// POST COMBAT HANDLING START
	// dont add xp to heroes here! because there is still a chance for playing combat manually and then we cant
	// remove the xp{
	//`LOG("Quick Combat lasted for"@roundCount@"rounds");
	foreach queue( stack )
	{
		//if( isAIAgainstNeutral && stack.IsAttacker && stack.BaseStack != none && stack.BaseStack.GetStackSize() - stack.StackSize > 0 )
		//{
		//	AddLossesForPlayer( attackingArmy.GetPlayer(), (stack.BaseStack.GetStackSize() - stack.StackSize), stack.BaseStack.GetStackType() );
		//}
		stack.BaseStack.SetStackSize( stack.StackSize );
	}

	attackingArmy.SetBaseCreatureStacks( baseStacksAttacker );
	defendingArmy.SetBaseCreatureStacks( baseStacksDefender );

	attackingArmy.SetWonBattle( attackerWon );
	defendingArmy.SetWonBattle( !attackerWon );

	mLastCombatEndReason = CER_KILLED;

	if( attackingArmy.GetPlayer().IsControlledByAI() )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	
	return attackerWon;
}

function AddLossesForPlayer( H7Player dasPlayer, int losses, H7Creature creatureType )
{
	dasPlayer.AddQuickCombatLoss( creatureType, losses );
}

function ResetQuickCombatRound( out array<H7QuickCombatStack> queue, out H7QuickCombatHero attackerHero, out H7QuickCombatHero defenderHero )
{
	local int i;

	for( i = 0; i < queue.Length; ++i )
	{
		if( !queue[i].IsDead )
		{
			queue[i].IsMoraleTurn = false;
			queue[i].CanMorale = false;
			queue[i].CanRetaliate = true;
			queue[i].HybridSupportDone = false;
		}
	}
	attackerHero.MadeTurn = false;
	defenderHero.MadeTurn = false;
}

function array<int> DoQuickCombatHeroAction( out H7QuickCombatHero hero, out array<H7QuickCombatStack> enemyStacks, out array<H7QuickCombatStack> myStacks, float armyRelation, out H7HeroAbility usedSpell )
{
	local array<H7HeroAbility> castableSpells;
	local H7HeroAbility castableSpell;
	local float spellValueCounter;
	local int randomSpellValue, spellIndex;
	local H7QuickCombatStack stack;
	local array<H7QuickCombatStack> validTargets, finalTargets;
	local array<ESpellTag> resistanceTags;
	local int i, targetIndex, damage, numOfTargets;
	local array<QuickCombatImpact> impacts, finalImpacts;
	local QuickCombatImpact impact;
	local array<int> targetIndices;
	local bool isUpgraded;
	resistanceTags = resistanceTags;

	GetCastableSpellsForQuickCombatHero( hero, castableSpells );
	if( hero.AllowedToCast && hero.Mana > 0 )
	{
		GetCastableSpellsForQuickCombatHero( hero, castableSpells );
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		if( castableSpells.Length > 0 )
		{
			if( armyRelation <= mAdventureConfiguration.mQuickCombatArmyRelationThreshold )
			{
				randomSpellValue = mRNGQuickCombat.GetIntNative( hero.SumSpellValue + 1 );
				
				foreach castableSpells( castableSpell )
				{
					if( spellValueCounter < randomSpellValue )
					{
						spellIndex = hero.Spells.Find( castableSpell );
						spellValueCounter += hero.SpellValues[ spellIndex ];
						usedSpell = castableSpell;
					}
					else
					{
						usedSpell = castableSpell;
						break;
					}
				}
				if( usedSpell.GetQuickCombatTargetType() )
				{
					validTargets = myStacks;
				}
				else
				{
					foreach enemyStacks( stack )
					{
						if( stack.BaseStack.GetStackType().GetResistanceModifierFor( usedSpell.GetSchool(), resistanceTags ) > 0 )
						{
							validTargets.AddItem( stack );
						}
					}
				}
				isUpgraded = usedSpell.IsUpgraded( hero.Hero );
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;

				impacts = usedSpell.GetQuickCombatSubstitutes();
				foreach impacts( impact )
				{
					if( impact.IsUpgraded && isUpgraded || //only upgraded versions will be taken
						!impact.IsUpgraded && !isUpgraded ) //only basic versions will be taken
					{
						finalImpacts.AddItem( impact );
					}
				}
				numOfTargets = isUpgraded ? usedSpell.GetQuickCombatNumOfTargetsUpgraded() : usedSpell.GetQuickCombatNumOfTargets();
				if( numOfTargets >= validTargets.Length )
				{
					finalTargets = validTargets;
				}
				else
				{
					for( i = 0; i < numOfTargets; ++i )
					{
						stack = validTargets[ mRNGQuickCombat.GetIntNative( validTargets.Length ) ];
						validTargets.RemoveItem( stack );
						finalTargets.AddItem( stack );
					}
				}

				foreach finalTargets( stack )
				{
					foreach finalImpacts( impact )
					{
						if( usedSpell.GetQuickCombatTargetType() )
						{
							targetIndex = myStacks.Find( 'BaseStack', stack.BaseStack );
							targetIndices.AddItem( targetIndex );
							ApplyQuickCombatImpact( stack, usedSpell, impact, hero );
							myStacks[ targetIndex ] = stack;
						}
						else
						{
							targetIndex = enemyStacks.Find( 'BaseStack', stack.BaseStack );
							if(targetIndex!=INDEX_NONE)
							{
								targetIndices.AddItem( targetIndex );
								ApplyQuickCombatImpact( stack, usedSpell, impact, hero );
								enemyStacks[ targetIndex ] = stack;
								if( enemyStacks[ targetIndex ].HitPoints == 0 )
								{
									enemyStacks[ targetIndex ].IsDead = true;
								}
							}
						}
					}
					
				}
				hero.Mana -= usedSpell.GetManaCost();
				hero.Hero.SetCurrentMana( hero.Mana );
				hero.MadeTurn = true;
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				return targetIndices;
			}
		}
	}
	else if( hero.HasWarcry && armyRelation <= mAdventureConfiguration.mQuickCombatArmyRelationThreshold )
	{
		foreach myStacks( stack )
		{
			targetIndex = myStacks.Find( 'BaseStack', stack.BaseStack );
			targetIndices.AddItem( targetIndex );
			ApplyQuickCombatImpactWarcry( stack, hero );
			myStacks[ targetIndex ] = stack;
		}
	}
	
	targetIndex = mRNGQuickCombat.GetIntNative( enemyStacks.Length );
	if(targetIndex>=0 && targetIndex<enemyStacks.Length)
	{
		targetIndices.AddItem( targetIndex );
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		damage = GetQuickCombatHeroActionDamage( hero, enemyStacks[ targetIndex ] );
		enemyStacks[ targetIndex ].HitPoints = Max( 0, enemyStacks[ targetIndex ].HitPoints - damage );
		enemyStacks[ targetIndex ].StackSize = FCeil( float( enemyStacks[ targetIndex ].HitPoints ) / float( enemyStacks[ targetIndex ].HitPointsSingle ) );
		if( enemyStacks[ targetIndex ].HitPoints == 0 )
		{
			enemyStacks[ targetIndex ].IsDead = true;
		}
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	hero.MadeTurn = true;
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	return targetIndices;
}

function ApplyQuickCombatImpactWarcry( out H7QuickCombatStack stack, H7QuickCombatHero hero )
{
	local int impact;

	impact = hero.WarcryRank * hero.AmountOfWarcries * mAdventureConfiguration.mQuickCombatWarcryAttackBonusFactor;
	if( hero.HasWarlord )
	{
		impact *= mAdventureConfiguration.mQuickCombatWarcryAttackBonusMultiplier;
	}
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	stack.Attack += impact;
}

function ApplyQuickCombatImpact( out H7QuickCombatStack stack, H7HeroAbility spell, QuickCombatImpact currentImpact, H7QuickCombatHero hero )
{
	local int damageMin, damageMax, damage;
	local EQuickCombatSubstitute substitute;
	local H7EffectDamage damageEffect;

	substitute = currentImpact.Substitute;
	switch( substitute )
	{
		case QC_DEFENSE:
			if( !spell.GetQuickCombatTargetType() )
			{
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				stack.Defense = FMax( 0, stack.Defense - mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * currentImpact.Intensity );
			}
			else
			{
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				stack.Defense += mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * currentImpact.Intensity;
			}
			break;
		case QC_ATTACK:   
			if( !spell.GetQuickCombatTargetType() )
			{
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				stack.Attack = FMax( 0, stack.Attack - mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * currentImpact.Intensity );
			}
			else
			{
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				stack.Attack += mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * currentImpact.Intensity;
			}
			break;
		case QC_DAMAGE:    
			damageEffect = spell.GetDamageEffect( hero.Hero );
			if( damageEffect != none )
			{
				damageMin = damageEffect.GetDamageRangeFinal().MinValue;
				damageMax = damageEffect.GetDamageRangeFinal().MaxValue;
				damage = damageMin + mRNGQuickCombat.GetIntNative( damageMax - damageMin + 1 );
			}
			if( !spell.GetQuickCombatTargetType() )
			{
				// Kill some stuff
				stack.HitPoints = Max( 0, stack.HitPoints - damage );
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			}
			else
			{
				// Don't create new units by healing
				stack.HitPoints = Min( stack.HitPoints + damage, stack.BaseStack.GetStackSize() * stack.HitPointsSingle );
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			}

			stack.StackSize = FCeil( float( stack.HitPoints ) / float( stack.HitPointsSingle ) );
			if( stack.HitPoints == 0 )
			{
				stack.IsDead = true;
			}
			break;
		default:
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
}

function GetCastableSpellsForQuickCombatHero( H7QuickCombatHero hero, out array<H7HeroAbility> spells )
{
	local H7HeroAbility spell;

	foreach hero.Spells( spell )
	{
		if( spell.GetManaCost() <= hero.Mana )
		{
			spells.AddItem( spell );
		}
	}
}

function int DoQuickCombatTowerAction( out H7QuickCombatStack stack, out array<H7QuickCombatStack> enemyStacks )
{
	local int targetIndex, damage;

	targetIndex = mRNGQuickCombat.GetIntNative( enemyStacks.Length );
	damage = mRNGQuickCombat.GetIntNative( stack.DamageMax - stack.DamageMin + 1 ) + stack.DamageMin;
	enemyStacks[ targetIndex ].HitPoints = Max( 0, enemyStacks[ targetIndex ].HitPoints - damage );
	enemyStacks[ targetIndex ].StackSize = FCeil( float( enemyStacks[ targetIndex ].HitPoints ) / float( enemyStacks[ targetIndex ].HitPointsSingle ) );

	if( enemyStacks[ targetIndex ].HitPoints == 0 )
	{
		enemyStacks[ targetIndex ].IsDead = true;
	}

	return targetIndex;
}

function int DoQuickCombatWarfareUnitAction( out H7QuickCombatStack stack, out array<H7QuickCombatStack> myStacks, out array<H7QuickCombatStack> enemyStacks, out int wasFriendly, H7QuickCombatHero hero )
{
	local QuickCombatImpact imp;
	local array<QuickCombatImpact> impacts;
	local int targetIndex;
	local H7EffectDamage damageEffect;
	local float damageMin, damageMax, damage;
	local H7BaseAbility supportAbility;
	
	targetIndex = -1;
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	
	if( stack.BaseWarUnit.GetWarUnitClass() == WCLASS_SUPPORT || stack.BaseWarUnit.GetWarUnitClass() == WCLASS_HYBRID && !stack.HybridSupportDone )
	{
		if( stack.BaseWarUnit.GetWarUnitClass() == WCLASS_HYBRID )
		{
			supportAbility = stack.BaseWarUnit.GetDefaultSupportAbility();
		}
		else
		{
			supportAbility = stack.BaseWarUnit.GetDefaultAttackAbility();
		}
		impacts = supportAbility.GetQuickCombatSubstitutes();
		if( impacts.Length > 0 )
		{
			imp = impacts[0];
		}
		else
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			return INDEX_NONE;
		}
		
		if( supportAbility.GetQuickCombatTargetType() )
		{
			if( myStacks.Length  == 0 )
			{
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				return INDEX_NONE;
			}
			targetIndex = mRNGQuickCombat.GetIntNative( myStacks.Length );
			wasFriendly = 1;
		}
		else
		{
			if( enemyStacks.Length == 0 )
			{
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				return INDEX_NONE;
			}
			targetIndex = mRNGQuickCombat.GetIntNative( enemyStacks.Length );
			wasFriendly = 0;
		}
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;

		switch( imp.Substitute )
		{
			case QC_DEFENSE:
				if( !supportAbility.GetQuickCombatTargetType() )
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					enemyStacks[ targetIndex ].Defense = FMax( 0, enemyStacks[ targetIndex ].Defense - mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * imp.Intensity );
				}
				else
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					myStacks[ targetIndex ].Defense += mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * imp.Intensity;
				}
				break;
			case QC_ATTACK:   
				if( !supportAbility.GetQuickCombatTargetType() )
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					enemyStacks[ targetIndex ].Attack = FMax( 0, enemyStacks[ targetIndex ].Attack - mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * imp.Intensity );
				}
				else
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					myStacks[ targetIndex ].Attack += mAdventureConfiguration.mQuickCombatAttackDefenseMightMagicFactor * imp.Intensity;
				}
				break;
			case QC_DAMAGE:    
				damageEffect = supportAbility.GetDamageEffect( stack.BaseWarUnit );
				if( damageEffect != none )
				{
					damageMin = damageEffect.GetDamageRangeFinal().MinValue;
					damageMax = damageEffect.GetDamageRangeFinal().MaxValue;
					damage = damageMin + mRNGQuickCombat.GetIntNative( damageMax - damageMin + 1 );
				}
				if( !supportAbility.GetQuickCombatTargetType() )
				{
					// Kill some stuff
					if( hero.HasArtilleryBarrage )
					{
						damage *= 3;
					}
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					enemyStacks[ targetIndex ].HitPoints = Max( 0, enemyStacks[ targetIndex ].HitPoints - damage );
					enemyStacks[ targetIndex ].StackSize = FCeil( float( enemyStacks[ targetIndex ].HitPoints ) / float( enemyStacks[ targetIndex ].HitPointsSingle ) );
					if( enemyStacks[ targetIndex ].HitPoints == 0 )
					{
						enemyStacks[ targetIndex ].IsDead = true;
					}
				}
				else
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					// Don't create new units by healing
					myStacks[ targetIndex ].HitPoints = Min( myStacks[ targetIndex ].HitPoints + damage, myStacks[ targetIndex ].BaseStack.GetStackSize() * myStacks[ targetIndex ].HitPointsSingle );
					myStacks[ targetIndex ].StackSize = FCeil( float( myStacks[ targetIndex ].HitPoints ) / float( myStacks[ targetIndex ].HitPointsSingle ) );
				}

				
				break;
			default:
		}

		if( stack.BaseWarUnit.GetWarUnitClass() == WCLASS_HYBRID )
		{
			stack.HybridSupportDone = true;
		}
	}
	else
	{
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		targetIndex = mRNGQuickCombat.GetIntNative( enemyStacks.Length );
		if( enemyStacks.Length == 0 )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			return targetIndex;
		}
		damageMin = stack.DamageMin;
		damageMax = stack.DamageMax;
		damage = mRNGQuickCombat.GetIntNative( damageMax - damageMin + 1 ) + damageMin;

		if( hero.HasArtilleryBarrage )
		{
			damage *= 3;
		}
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		enemyStacks[ targetIndex ].HitPoints = Max( 0, enemyStacks[ targetIndex ].HitPoints - damage );
		enemyStacks[ targetIndex ].StackSize = FCeil( float( enemyStacks[ targetIndex ].HitPoints ) / float( enemyStacks[ targetIndex ].HitPointsSingle ) );

		if( enemyStacks[ targetIndex ].HitPoints == 0 )
		{
			enemyStacks[ targetIndex ].IsDead = true;
		}
		wasFriendly = 0;
	}
	return targetIndex;
}

function int DoQuickCombatCreatureAction( out H7QuickCombatStack stack, out array<H7QuickCombatStack> enemyStacks, bool canMove )
{
	local int moraleRoll, i, targetIndex, damage;
	local H7QuickCombatStack target;
	local array<H7QuickCombatStack> validTargets;

	targetIndex = -1;

	if( ( canMove || stack.MovementType != CMOVEMENT_WALK ) && stack.Range == CATTACKRANGE_ZERO )
	{
		stack.MovedTiles += stack.Movement;
	}

	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	
	if( stack.IsAllowedToMorale )
	{
		moraleRoll = mRNGQuickCombat.GetIntNative( 101 );
		if( stack.Morale < 0 && moraleRoll < Min( 50, Abs( stack.Morale ) ) )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			// BAD MORALE
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			return targetIndex;
		}
		else if( moraleRoll > Min( 50, Abs( stack.Morale ) ) )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			//Go on
		}
		else if( stack.Morale > 0 && moraleRoll < Min( 50, Abs( stack.Morale ) ) )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			// GOOD MORALE
			stack.CanMorale = true;
		}
	}
	else
	{
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}

	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	for( i = 0; i < enemyStacks.Length; ++i )
	{
		if( stack.Range == CATTACKRANGE_ZERO )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			if( enemyStacks[i].Range != CATTACKRANGE_ZERO )
			{
				if( mAdventureConfiguration.mQuickCombatMapWidth <= stack.MovedTiles )
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					validTargets.AddItem( enemyStacks[i] );
				}
				else
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				}
			}
			else
			{
				if( mAdventureConfiguration.mQuickCombatMapWidth <= ( stack.MovedTiles + enemyStacks[i].MovedTiles ) )
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
					validTargets.AddItem( enemyStacks[i] );
				}
				else
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				}
			}
		}
		else
		{
			validTargets = enemyStacks;
			break;
		}
	}

	if( validTargets.Length > 0 )
	{
		target = validTargets[ mRNGQuickCombat.GetIntNative( validTargets.Length ) ];
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	else
	{
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		return targetIndex;
	}

	// get the index, we need to modify the out array and the specific element because we have a struct!
	targetIndex = enemyStacks.Find( 'BaseStack', target.BaseStack );
	if( targetIndex != INDEX_NONE )
	{
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		// Do damage
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		damage = GetQuickCombatUnitActionDamage( stack, enemyStacks[ targetIndex ] );
		enemyStacks[ targetIndex ].HitPoints = Max( 0, enemyStacks[ targetIndex ].HitPoints - damage );
		enemyStacks[ targetIndex ].StackSize = FCeil( float( enemyStacks[ targetIndex ].HitPoints ) / float( enemyStacks[ targetIndex ].HitPointsSingle ) );
		if( stack.Range == CATTACKRANGE_ZERO )
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			enemyStacks[ targetIndex ].HitByMelee = true;
		}
		if( enemyStacks[ targetIndex ].HitPoints == 0 )
		{
			enemyStacks[ targetIndex ].IsDead = true;
			
		}
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		if( !enemyStacks[ targetIndex ].IsDead  )
		{
			// Retaliation
			if( enemyStacks[ targetIndex ].CanRetaliate )
			{
				if( stack.Range != CATTACKRANGE_ZERO && stack.HitByMelee || stack.Range == CATTACKRANGE_ZERO )
				{
					damage = GetQuickCombatUnitActionDamage( enemyStacks[ targetIndex ], stack );
					stack.HitPoints = Max( 0, stack.HitPoints - damage );
					stack.StackSize = FCeil( float( stack.HitPoints ) / float( stack.HitPointsSingle ) );
					enemyStacks[ targetIndex ].CanRetaliate = false;
					if( stack.HitPoints == 0 )
					{
						stack.IsDead = true;
					}
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				}
				else
				{
					if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
				}
			}
			// Morale turn
			if( !stack.IsDead && stack.CanMorale )
			{
				stack.IsMoraleTurn = true;
				damage = GetQuickCombatUnitActionDamage( stack, enemyStacks[ targetIndex ] );
				enemyStacks[ targetIndex ].HitPoints = Max( 0, enemyStacks[ targetIndex ].HitPoints - damage );
				enemyStacks[ targetIndex ].StackSize = FCeil( float( enemyStacks[ targetIndex ].HitPoints ) / float( enemyStacks[ targetIndex ].HitPointsSingle ) );

				if( enemyStacks[ targetIndex ].HitPoints == 0 )
				{
					enemyStacks[ targetIndex ].IsDead = true;
				}
				// Morale turn end
				stack.IsMoraleTurn = false;
				if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
			}
		}
	}
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	return targetIndex;
}

function int GetQuickCombatUnitActionDamage( H7QuickCombatStack stack, H7QuickCombatStack target )
{
	local int luckRoll, damage;
	local float M;
	// Critical hit (luck roll)
	luckRoll = mRNGQuickCombat.GetIntNative( 101 );
	if( stack.Luck < 0 && luckRoll < Min( 50, Abs( stack.Luck ) ) )
	{
		damage = 1.5 * stack.DamageMax;
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	else if( luckRoll > Min( 50, Abs( stack.Luck ) ) )
	{
		damage = stack.DamageMin + mRNGQuickCombat.GetIntNative( stack.DamageMax - stack.DamageMin + 1 );
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	else if( stack.Luck > 0 && luckRoll < Min( 50, Abs( stack.Luck ) ) )
	{
		damage = 0.75 * stack.DamageMin;
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	

	if( stack.Range != CATTACKRANGE_ZERO )
	{
		// Melee penalty
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		if( stack.HasMeleePenalty && stack.HitByMelee )
		{
			damage *= 0.5;
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		}
		// Half range penalty
		else if( stack.Range == CATTACKRANGE_HALF && mAdventureConfiguration.mQuickCombatMapWidth <= mAdventureConfiguration.mQuickCombatMapWidth / 2 + target.MovedTiles )
		{
			damage *= 0.5;
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		}
		else
		{
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		}
	}

	// Strength Modifier
	if( stack.Attack > target.Defense )
	{
		M = FMin( 3, 1 + 0.05 * ( float( stack.Attack - target.Defense ) ) );
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	else
	{
		M = FMax( 0.3, 1 + 0.025 * ( float( stack.Attack - target.Defense ) ) );
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}

	// Morale turn
	if( stack.IsMoraleTurn )
	{
		damage *= 0.5;
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	return stack.StackSize * damage * M;
}

function int GetQuickCombatHeroActionDamage( H7QuickCombatHero hero, H7QuickCombatStack target )
{
	local int damage;
	local float M;

	damage = hero.DamageMin + mRNGQuickCombat.GetIntNative( hero.DamageMin - hero.DamageMax + 1 );
	// Strength Modifier
	if( hero.Attack > target.Defense )
	{
		M = FMin( 3, 1 + 0.05 * ( float( hero.Attack - target.Defense ) ) );
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}
	else
	{
		M = FMax( 0.3, 1 + 0.025 * ( float( hero.Attack - target.Defense ) ) );
		if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	}

	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
	return damage * M;
}

function CreateQuickCombatHero( H7EditorHero hero, out H7QuickCombatHero quickCombatHero, float armyRelation )
{
	local int i;
	local float spellValue;

	if( hero.IsHero() && !mAdventureConfiguration.mQuickCombatIgnoreHeroes )
	{
		quickCombatHero.Hero = hero;
		quickCombatHero.DamageMin = hero.GetMinimumDamage() + hero.GetQuickCombatSubstituteImpact( QC_DAMAGE );
		quickCombatHero.DamageMax = hero.GetMaximumDamage() + hero.GetQuickCombatSubstituteImpact( QC_DAMAGE );
		quickCombatHero.Attack = hero.GetAttack() + hero.GetQuickCombatSubstituteImpact( QC_ATTACK );
		quickCombatHero.Defense = hero.GetDefense() + hero.GetQuickCombatSubstituteImpact( QC_DEFENSE );
		quickCombatHero.Luck = hero.GetDestiny() + hero.GetQuickCombatSubstituteImpact( QC_LUCK );
		quickCombatHero.Morale = hero.GetLeadership() + hero.GetQuickCombatSubstituteImpact( QC_MORALE );
		quickCombatHero.Mana = hero.GetCurrentMana();
		quickCombatHero.MadeTurn = false;
		quickCombatHero.IsHero = true;
		quickCombatHero.AllowedToCast = mAdventureConfiguration.mQuickCombatAllowSpellCast;
		quickCombatHero.HasWarcry = hero.GetSkillManager().GetSkillBySkillType( SKT_WARCRIES ) != none && hero.GetSkillManager().GetSkillBySkillType( SKT_WARCRIES ).GetCurrentSkillRank() >= SR_NOVICE;
		if( quickCombatHero.HasWarcry )
		{
			quickCombatHero.WarcryRank = hero.GetSkillManager().GetSkillBySkillType( SKT_WARCRIES ).GetCurrentSkillRank() - 1; // -1 is offset for enumeration, SR_NOVICE is "2" as integer
		}
		quickCombatHero.AmountOfWarcries = hero.GetAmountOfWarcries();
		quickCombatHero.WarfareRank = hero.GetSkillManager().GetSkillBySkillType( SKT_WARFARE ) != none ? hero.GetSkillManager().GetSkillBySkillType( SKT_WARFARE ).GetCurrentSkillRank() - 1 : 0; // -1 is offset for enumeration, SR_NOVICE is "2" as integer

		quickCombatHero.HasWarlord = hero.GetAbilityManager().HasAbility( mAdventureConfiguration.mQuickCombatWarcryAbilityReference );
		quickCombatHero.HasArtilleryBarrage = hero.GetAbilityManager().HasAbility( mAdventureConfiguration.mQuickCombatAttackWarfareReference );
		quickCombatHero.HasPerfectWarfare = hero.GetAbilityManager().HasAbility( mAdventureConfiguration.mQuickCombatWarfareAbilityReference );
		quickCombatHero.HasSiegeWarfare = hero.GetAbilityManager().HasAbility( mAdventureConfiguration.mQuickCombatSiegeAbilityReference );
 
		hero.GetSpells( quickCombatHero.Spells );

		for( i = 0; i < quickCombatHero.Spells.Length; ++i )
		{
			spellValue = quickCombatHero.Spells[i].GetQuickCombatValue( armyRelation, mAdventureConfiguration.mQuickCombatArmyRelationThreshold );
			quickCombatHero.SpellValues.AddItem( spellValue );
			quickCombatHero.SumSpellValue += spellValue;
		}
	}
	else
	{
		quickCombatHero.IsHero = false;
	}
	if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
}

function CreateQuickCombatTowers( H7TowerUnit towerTemplate, out array<H7QuickCombatStack> towers )
{
	local H7QuickCombatStack quickCombatStack;
	towers.Length = 0;
	
	quickCombatStack.StackType = QCST_TOWER;
	quickCombatStack.Attack = towerTemplate.GetAttack();
	quickCombatStack.DamageMin = towerTemplate.GetMinimumDamageBase();
	quickCombatStack.DamageMax = towerTemplate.GetMaximumDamageBase();
	quickCombatStack.Initiative = towerTemplate.GetInitiative();
	towers.AddItem( quickCombatStack );
	towers.AddItem( quickCombatStack );
}

function CreateQuickCombatWarfareUnits( array<H7EditorWarUnit> templates, out array<H7QuickCombatStack> warfareUnits, bool isAttacker )
{
	local H7QuickCombatStack quickCombatStack;
	local H7EditorWarUnit template;
	warfareUnits.Length = 0;
	
	foreach templates( template )
	{
		if( template.GetWarUnitClass() != WCLASS_SIEGE )
		{
			quickCombatStack.StackType = QCST_WARFARE;
			quickCombatStack.BaseWarUnit = template;
			quickCombatStack.Attack = template.GetAttack();
			quickCombatStack.DamageMin = template.GetMinimumDamage();
			quickCombatStack.DamageMax = template.GetMaximumDamage();
			quickCombatStack.Initiative = template.GetInitiative();
			quickCombatStack.IsAttacker = isAttacker;
			warfareUnits.AddItem( quickCombatStack );
		}
	}
}

function CreateQuickCombatStacks( array<H7BaseCreatureStack> baseStacks, H7QuickCombatHero hero, out array<H7QuickCombatStack> quickCombatStacks, bool isAttacker, bool moralePenalty, float healthMultiplier )
{
	local H7BaseCreatureStack baseStack;
	local H7QuickCombatStack quickCombatStack;
	local H7Creature creature;

	foreach baseStacks( baseStack )
	{
		if( baseStack != none && baseStack.GetStackType() != none )
		{
			creature = baseStack.GetStackType();
			quickCombatStack.StackType = QCST_CREATURE;
			quickCombatStack.BaseStack = baseStack;
			quickCombatStack.StackSize = baseStack.GetStackSize();
			quickCombatStack.Initiative = creature.GetInitiative() + creature.GetQuickCombatSubstituteImpact( QC_INITIATIVE );
			quickCombatStack.HitPointsSingle = ( creature.GetHitPointsBase() + creature.GetQuickCombatSubstituteImpact( QC_HITPOINTS ) ) * healthMultiplier;
			if( hero.IsHero )
			{
				quickCombatStack.HitPointsSingle += hero.Hero.GetQuickCombatSubstituteImpact( QC_HITPOINTS );
				quickCombatStack.Initiative += hero.Hero.GetQuickCombatSubstituteImpact( QC_INITIATIVE );
			}
			quickCombatStack.HitPoints = quickCombatStack.HitPointsSingle * quickCombatStack.StackSize;
			quickCombatStack.DamageMin = creature.GetMinimumDamage() + creature.GetQuickCombatSubstituteImpact( QC_DAMAGE );
			quickCombatStack.DamageMax = creature.GetMaximumDamage() + creature.GetQuickCombatSubstituteImpact( QC_DAMAGE );
			quickCombatStack.Attack = creature.GetAttack() + hero.Attack + creature.GetQuickCombatSubstituteImpact( QC_ATTACK );
			quickCombatStack.Defense = creature.GetDefense() + hero.Defense + creature.GetQuickCombatSubstituteImpact( QC_DEFENSE );
			quickCombatStack.Range = creature.GetAttackRange();
			quickCombatStack.Luck = creature.GetDestiny() + hero.Luck + creature.GetQuickCombatSubstituteImpact( QC_LUCK );
			quickCombatStack.IsAllowedToMorale = creature.CanMoraleInQuickCombat( mAdventureConfiguration.mQuickCombatMoraleImmunityCriteria );
			if( quickCombatStack.IsAllowedToMorale )
			{
				quickCombatStack.Morale = creature.GetLeadership() + hero.Morale + creature.GetQuickCombatSubstituteImpact( QC_MORALE );
				if( moralePenalty )
				{
					quickCombatStack.Morale -= 10;
				}
			}
			if( quickCombatStack.Range == CATTACKRANGE_ZERO )
			{
				quickCombatStack.Movement = creature.GetMovementPoints();
			}
			else
			{
				// Ranged units don't move
				quickCombatStack.Movement = 0;
			}
			quickCombatStack.HasMeleePenalty = creature.HasMeleePenalty();
			quickCombatStack.IsMoraleTurn = false;
			quickCombatStack.CanMorale = false;
			quickCombatStack.CanRetaliate = true;
			quickCombatStack.IsDead = false;
			quickCombatStack.IsAttacker = isAttacker;

			quickCombatStacks.AddItem( quickCombatStack );
			if( class'H7AdventureController'.static.GetInstance().GetConfig().mQuickCombatOutputToLog ) ;
		}
	}
}

function int SortQuickCombatQueue( H7QuickCombatStack a, H7QuickCombatStack b )
{
	return a.Initiative - b.Initiative;
}

function int ShuffleQuickCombatQueue( H7QuickCombatStack a, H7QuickCombatStack b )
{
	return mRNGQuickCombat.GetIntNative( 3 ) - 1;
}

// called in the middle of CombatResult Popup handling
function FinalizeAfterCombat(out H7AdventureArmy attackingArmy,out H7AdventureArmy defendingArmy,H7CombatArmy attackingArmyCombat, H7CombatArmy defendingArmyCombat, optional bool quickcombat = false, optional bool addLocalGuard = true, optional bool updateLocalGuard = false)
{
	local array<H7Town> towns;
	local int i;
	local H7Player playerWon;
	local int attackerLosses;
	local int defenderLosses;
	local H7EventContainerStruct conti;
	local array<H7HeroItem> transferItems;
	local H7HeroItem item;
	local H7Message message;
	local string tooltip;
	local bool transferedItems;
	local array<H7EditorHero> combatHeroes;
	local H7AreaOfControlSite garrisonSite;
	local array<H7BaseCreatureStack> localGuardStacks;
	local bool defenderWasGarrisoned;
	local H7AdventureArmy victoriousArmy;
	local array<H7AdventureMapCell> cells;
	local H7AdventureMapCell cell;
	local IntPoint dim;

	// merge local guard to defender army so we can calculate the xp gain 
	
	if(!quickcombat)
	{
		attackingArmy.GetPlayer().SetIsInCombat(false);
		defendingArmy.GetPlayer().SetIsInCombat(false);
	}

	garrisonSite = H7AreaOfControlSite( defendingArmy.GetGarrisonedSite() );
	defenderWasGarrisoned = defendingArmy.IsGarrisoned() || defendingArmy.IsGarrisonedButOutside();


	dim.X = 5;
	dim.Y = 5;
	if( defendingArmy.GetCell() != none && attackingArmy.GetPlayer().IsControlledByAI() && defendingArmy.GetPlayerNumber() == PN_NEUTRAL_PLAYER )
	{
		defendingArmy.GetCell().GetGridOwner().GetCellsFromDimensions( defendingArmy.GetCell(), dim, cells );
		foreach cells( cell )
		{
			if( cell.GetVisitableSite() != none )
			{
				attackingArmy.AddAiLiberatedSite( cell.GetVisitableSite() );
			}
		}
	}


	if(addLocalGuard)
	{
		if( defenderWasGarrisoned && garrisonSite != none )
		{
			localGuardStacks = garrisonSite.GetLocalGuardAsBaseCreatureStacks();

			if(localGuardStacks.Length > 0)
			{		
				if(class'H7EditorArmy'.const.MAX_ARMY_SIZE - defendingArmy.GetNumberOfFilledSlots() > 0)
				{
					for(i = 0; i < localGuardStacks.Length; i++)
					{
						if( localGuardStacks[ i ] == none || localGuardStacks[ i ].GetStackType() == none
							|| localGuardStacks[ i ].GetStackSize() <= 0)
							continue;

						defendingArmy.AddCreatureStack( localGuardStacks[ i ] );
			
						if(defendingArmy.GetNumberOfFilledSlots() >= class'H7EditorArmy'.const.MAX_ARMY_SIZE)
							break;
					}
				}
			}
		}
	}
	
	//XP Attacking Player
	attackingArmy.GetHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
	attackingArmy.GetHero().AddXp( defendingArmy.GetExperienceForDefeating() - defendingArmyCombat.GetExperienceForDefeating() );
	//XP Defending Player
	defendingArmy.GetHero().TriggerEvents( ON_BATTLE_XP_GAIN, false );
	defendingArmy.GetHero().AddXp( attackingArmy.GetExperienceForDefeating() - attackingArmyCombat.GetExperienceForDefeating() );

	//attackerWon = attackingArmyCombat.WonBattle();

	if( attackingArmyCombat.WonBattle() )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	if(updateLocalGuard)
	{
		defendingArmy.UpdateLocalGuardAfterCombatByBaseCreatureStacks(defendingArmyCombat);
	}   
	attackerLosses = attackingArmy.UpdateAfterCombat( attackingArmyCombat, defendingArmy.GetPlayerNumber(), quickcombat );
	defenderLosses = defendingArmy.UpdateAfterCombat( defendingArmyCombat, attackingArmy.GetPlayerNumber(), quickcombat );
	
	//Winner Management
	if(attackingArmyCombat.WonBattle())
	{
		victoriousArmy = attackingArmy;
		playerWon = attackingArmy.GetPlayer();
		conti.Targetable = attackingArmy.GetHero();
		attackingArmy.GetHero().TriggerEvents( ON_BATTLE_WON, false );
		
		// item transfer
		if( attackingArmy.GetHero().IsHero() && mLastCombatEndReason == CER_KILLED )
		{
			if( defendingArmy.GetHero().IsHero() )
			{
				defendingArmy.TransferItems( attackingArmy );
			}

			transferItems = defendingArmy.GetHero().GetInventory().GetItems();
			
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroReceivedItems.CreateMessageBasedOnMe();
			message.mPlayerNumber = attackingArmy.GetPlayerNumber();
			message.AddRepl("%recHero",attackingArmy.GetHero().GetName());
			message.AddRepl("%giverHero",defendingArmy.GetHero().GetName());
			message.settings.referenceObject = attackingArmy.GetHero();
			tooltip = message.GetFormatedText() $ tooltip;
			
			foreach transferItems( item )
			{
				tooltip = tooltip $ "\n" $ "<img src='" $ item.GetFlashIconPath() $ "' width='#TT_BODY#' height='#TT_BODY#'>" @ item.GetName();
				transferedItems = true;
			}
			defendingArmy.GetHero().GetEquipment().GetItemsAsArray( transferItems );
			foreach transferItems( item )
			{
				tooltip = tooltip $ "\n" $ "<img src='" $ item.GetFlashIconPath() $ "' width='#TT_BODY#' height='#TT_BODY#'>" @ item.GetName();
				transferedItems = true;
			}
			message.mTooltip = tooltip;

			if(!attackingArmy.GetPlayer().IsControlledByAI() && transferedItems)
			{
				class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			}
		}

		if( defenderWasGarrisoned )
		{
			if( garrisonSite != none)
			{
				if(class'H7CombatPopUpCntl'.static.GetInstance().GetPopup().IsVisible()
					&& !class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame())
				{
					// We can not conquer here, because it triggers scripts and the whole CombatPopup process is not completed yet
					class'H7CombatPopUpCntl'.static.GetInstance().QueueConquer(garrisonSite,attackingArmy.GetHero());
				}
				else // proceed as normal for AI on AI action without popup
				{
					if( garrisonSite != none && ( garrisonSite.IsA( 'H7Town' ) || garrisonSite.IsA( 'H7Fort' ) || garrisonSite.IsA( 'H7Garrison' ) ) )
					{
						garrisonSite.Conquer( attackingArmy.GetHero() );
					}
					
					
					if( garrisonSite != none && H7CaravanOutpost( garrisonSite ) != none )
					{
						H7CaravanOutpost( garrisonSite ).DestroyOutpost( true );
					}
				}
			}
		}
		
		if( defendingArmy.GetPlayer() == GetLocalPlayer() )
		{
			UpdateHUD( , , false );
			AutoSelectArmy( false );
		}

		
	}
	else
	{
		victoriousArmy = defendingArmy;
		playerWon = defendingArmy.GetPlayer();
		conti.Targetable = defendingArmy.GetHero();
		defendingArmy.GetHero().TriggerEvents( ON_BATTLE_WON, false );

		// item transfer

		if( defendingArmy.GetHero().IsHero() && mLastCombatEndReason == CER_KILLED)
		{
			attackingArmy.TransferItems( defendingArmy );
		}

		if( attackingArmy.GetPlayer() == GetLocalPlayer() )
		{
			UpdateHUD( , , false );
			AutoSelectArmy( false );
		}
	}

	if( H7CaravanOutpost( victoriousArmy.GetGarrisonedSite() ) != none )
	{
		H7CaravanOutpost( victoriousArmy.GetGarrisonedSite() ).UpdateAfterCombat();
	}
	
	if(quickcombat) // manual combat still needs it in DoBackToAdventureFromCombat and will reset it there
	{
		SetBeforeBattleArea(none);

		towns = playerWon.GetTowns();
		for( i=0; i<towns.Length;++i)
		{
			towns[i].TriggerEvents( ON_BATTLE_WON, false, conti );
		}

		// this event is raised in the combat controller after manual combat,
		// so raise it here for quick combat (later, it's raised on EVERYTHING except
		// the two heroes)
		attackingArmy.GetHero().TriggerEvents( ON_COMBAT_END, false );
		defendingArmy.GetHero().TriggerEvents( ON_COMBAT_END, false );
		// quckcombat 
		attackingArmy.GetHero().TriggerEvents( ON_QUICKCOMBAT_END, false );
		defendingArmy.GetHero().TriggerEvents( ON_QUICKCOMBAT_END, false );
	}
	
	class'H7ScriptingController'.static.GetInstance().SetLastCombatLosses(attackerLosses + defenderLosses);

	if( attackingArmyCombat.WonBattle() )
	{
		if( attackingArmy.GetHero() != none && !attackingArmy.GetHero().IsHero() )
		{
			attackingArmy.LoadMeshes(true);
		}
	}
	else
	{
		if( defendingArmy.GetHero() != none && !defendingArmy.GetHero().IsHero() && !defendingArmy.IsACaravan() )
		{
			defendingArmy.LoadMeshes(true);
		}
	}

	++mNumberOfFightsTotal;

	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		attackingArmy.GetFlag().ReturnFromSimTurnsCombat();
		defendingArmy.GetFlag().ReturnFromSimTurnsCombat();
	}

	// heroes already got that event because else they'd keep a LOT of stuff from combat which is wrong
	// anyway, don't update them again here
	combatHeroes.AddItem( attackingArmy.GetHero() );
	combatHeroes.AddItem( defendingArmy.GetHero() );
	UpdateEvents(ON_COMBAT_END,,,combatHeroes);
	
	if( quickcombat )
	{
		attackingArmyCombat.Destroy();
		defendingArmyCombat.Destroy();
	}
}

function bool QuickCombatWithAdventureArmies( H7AdventureArmy attackingArmy, H7AdventureArmy defendingArmy )
{
	local H7CombatArmy attackingArmyCombat, defendingArmyCombat;
	local bool success;
	local H7SiegeTownData siegeTownData;
	local bool isSiege;
	local array<H7BaseCreatureStack> localStacks;
	local H7AdventureController adventureController;

	adventureController = class'H7AdventureController'.static.GetInstance();

	mArmyAttacker = attackingArmy;
	mArmyDefender = defendingArmy;

	attackingArmyCombat = attackingArmy.CreateCombatArmyUsingAdventureArmy( attackingArmy, true, true );
	defendingArmyCombat = defendingArmy.CreateCombatArmyUsingAdventureArmy( defendingArmy, false, true );

	isSiege = PreQuickCombatWithCombatArmies( defendingArmy, defendingArmyCombat, localStacks, siegeTownData );

	mArmyAttackerCombat = attackingArmyCombat;
	mArmyDefenderCombat = defendingArmyCombat;

	success = QuickCombatWithCombatArmies( attackingArmyCombat, defendingArmyCombat, isSiege, siegeTownData );

	mLastCombatEndReason = CER_KILLED;
	FinalizeAfterCombat(mArmyAttacker,mArmyDefender,mArmyAttackerCombat,mArmyDefenderCombat, true);

	if( (attackingArmyCombat.WonBattle() == false && attackingArmy.GetPlayer().IsControlledByAI() == true) /* || (defendingArmyCombat.WonBattle() == false && defendingArmy.GetPlayer().IsControlledByAI() == true) */ )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		adventureController.FinishHeroTurn();
	}

	if(class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor())
	{
		if (attackingArmyCombat.WonBattle())
		{
			adventureController.TriggerCombatEvent(attackingArmy, defendingArmy);
		}
		else
		{
			adventureController.TriggerCombatEvent(defendingArmy, attackingArmy);
		}
	}

	return success;
}

protected function SetCurrentPlayerIndex( int newCurrentPlayerIndex )
{
	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && !mSimTurnOfAI )
	{
		mCurrentPlayerIndex = FindLocalPlayer().GetPlayerNumber();
		
	}
	else
	{
		mCurrentPlayerIndex = newCurrentPlayerIndex;
	}
}

function Defeat(){}

//=============================================================================
// States:
//=============================================================================

// # intitial state
auto state Beginning
{
	event BeginState(name previousStateName)
	{
		;

		UpdateHUD(,,false);
		class'Engine'.static.StopMovie(true); // stop the movie loading screen (after a small delay to cover the first frame)
		;
		// This will not fire after loading savegame, since ScriptingController is loaded from save
		if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
		{
			class'H7ScriptingController'.static.TriggerEvent(class'H7SeqEvent_MapLoaded', 0);
		}
		GotoState('AdventureMap');
	}

	event EndState(name nextStateName)
	{
		;
	}
}

state AdventureMap
{
	function TryTurnEnd()
	{
		if( !mCommandQueue.IsCommandRunningForAnyPlayer() && mCommandQueue.GetQueueLength() == 0)
		{
			if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
			{
				// synchronous begin turn in sim turn mode
				H7PlayerReplicationInfo( GetALocalPlayerController().PlayerReplicationInfo ).SetCanBeginNextTurn();
			}
			else
			{
				BeginTurn();
			}
		}
		else
		{
			SetTimer( 0.1f, false, 'TryTurnEnd' );
		}

		
	}
	event BeginState(name previousStateName)
	{
		;

		mIsCaravanTurnFinished = false;

		if( previousStateName == 'CaravanTurn' )
		{
			TryTurnEnd();
		}
		else if(previousStateName == 'Combat')
		{
			mIsCaravanTurnFinished = true;
		}
		else if( previousStateName == 'Beginning' )
		{
			mIsCaravanTurnFinished = true;
		}
	}

	event EndState(name nextStateName)
	{
		;
	}

	event Tick(float deltaTime)
	{
		local H7Player dasPlayer;
		local H7Player player;

		super.Tick(deltaTime);
		
		CheckReturningFromCombatPopUp();

		if(mRestoreSFX)
		{
			RestoreSFX();
		}

		if(mLoadSaveMatinees.Length > 0)
		{
			HandleLoadSaveMatinees();
		}

		if( WorldInfo.GRI.IsMultiplayerGame() )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().Update();
		}
		if( !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			foreach mPlayers( dasPlayer )
			{
				if( dasPlayer.GetQuestController() == none ) { continue; }
				if( dasPlayer.GetQuestController().IsQueuedForLoss() )
				{
					dasPlayer.GetQuestController().GetLoseSeq().Activated();
				}
				if( dasPlayer.GetQuestController().IsQueuedForWin() )
				{
					dasPlayer.GetQuestController().GetWinSeq().Activated();
				}
			}
		}
		if( GetCurrentGameMode() == SINGLEPLAYER && GetLocalPlayer().GetQuestController().IsGameEnd() )
		{
			return;
		}


		mCommandQueue.UpdateCommand();

		UpdateCurrentTurnTimer( deltaTime );
		UpdateCurrentRetreatTimer( deltaTime );

		if( !mIsCaravanTurnFinished )
		{
			return;
		}

		if( GetCurrentPlayer().IsControlledByAI() && mAI.IsAiEnabled() )
		{
			if( !mCommandQueue.IsCommandRunning() )
			{
				mAI.TickAITimeBetweenThink( deltaTime );
			}

			if( mAI.GetTimeSinceLastThink() > 15.0f ) // after 15 seconds of inactivity, end the AI turn
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				;
				mAI.ResetTimeSinceLastThink();
				FinishHeroTurn();
			}
		}

		// If one of the players is in combat -> AI should not think!
		if( class'H7ReplicationInfo'.static.GetInstance().IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
		{
			foreach mPlayers(player)
			{
				if(!player.IsNeutralPlayer() && player.IsInCombat())
				{
					return;
				}
			}
		}
		
//`LOG_AI("TICK #0" @ mSelectedArmy @ "Hero" @ mSelectedArmy.GetHero().GetName() @ "AICT" @ mSelectedArmy.GetHero().GetAiControlType() @ "PT" @ mSelectedArmy.GetPlayer().IsControlledByAI() @ "PLY" @ mSelectedArmy.GetPlayer().GetName() @ "TEAM" @ mSelectedArmy.GetPlayer().GetTeamNumber() @ "MP" @ mSelectedArmy.GetHero().GetCurrentMovementPoints() );
		if( mCommandQueue.IsCommandRunning() || mCommandQueue.GetQueueLength() > 0 )
		{
			mAI.DeferExecution(0.000001f);

			if( mSelectedArmy!=none && mSelectedArmy.GetPlayer().IsControlledByAI() == true && !mSelectedArmy.IsInCombat() && mSelectedArmy.GetHero().GetCurrentMovementPoints() < 1.0f )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				FinishHeroTurn();
			}
		}
		else if( mSelectedArmy != none )
		{
//`LOG_AI("TICK #1" @ mSelectedArmy @ "Hero" @ mSelectedArmy.GetHero().GetName() @ "AICT" @ mSelectedArmy.GetHero().GetAiControlType() @ "PT" @ mSelectedArmy.GetPlayer().IsControlledByAI() @ "PLY" @ mSelectedArmy.GetPlayer().GetName() @ "TEAM" @ mSelectedArmy.GetPlayer().GetTeamNumber() );
			if( mSelectedArmy.GetPlayer().IsControlledByAI() == true && !mSelectedArmy.IsInCombat() )
			{
//`LOG_AI("TICK #2" @ mSelectedArmy @ "Hero" @ mSelectedArmy.GetHero().GetName() @ "AICT" @ mSelectedArmy.GetHero().GetAiControlType() @ "PT" @ mSelectedArmy.GetPlayer().IsControlledByAI() @ "PLY" @ mSelectedArmy.GetPlayer().GetName() @ "TEAM" @ mSelectedArmy.GetPlayer().GetTeamNumber() );
				if( mSelectedArmy.GetHero().GetAiHibernationState() == true )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					FinishHeroTurn();
				}
				if( mSelectedArmy.IsAITimeOut() == true )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					FinishHeroTurn();
				}
				// TODO: Check if this is still needed. Kismet action "Finish current Hero Turn" should do the trick in dire situations
				//else if( mSelectedArmy.GetHero().GetAiControlType() == HCT_SCRIPT_OVERRIDE && mSelectedArmy.GetHero().GetIsScripted() == false )
				//{
				//	`LOG_AI("_EOT for army" @ mSelectedArmy @ "(script override)");
				//	FinishHeroTurn();
				//}
				else if( mSelectedArmy.GetPlayer().GetPlayerNumber() == PN_NEUTRAL_PLAYER )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					FinishHeroTurn();
				}
				else if( mSelectedArmy.GetHero().HasFinishedCurrentTurn() == true )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					FinishHeroTurn();
				}
				else if( mSelectedArmy.GetHero().GetCurrentMovementPoints() < 1.0f )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					FinishHeroTurn();
				}
				else if( mSelectedArmy.IsDead() )
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					;
					FinishHeroTurn();
				}
				else if( mAI.GetTimeSinceLastThink() > 15.0f ) // after 15 seconds of inactivity, end the AI turn
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
					;
					FinishHeroTurn();
				}
				else if( mSelectedArmy.GetHero().GetAiControlType() != HCT_SCRIPT_OVERRIDE )
				{
//					`LOG_AI("Regular think for army" @ mSelectedArmy );
					mAI.Think( mSelectedArmy.GetHero(), deltaTime );
				}

			}
		}
		else if( GetCurrentPlayer().IsControlledByAI() && mSelectedArmy==None ) // no heroes/armies left to command around ... hand over token to next player in line
		{
			// TODO: if AI doesn't have an Army at the start of the turn it just skips the turn, not recruiting new ones
			EndAITurn();
		}
	}

	protected function CheckReturningFromCombatPopUp()
	{
		local array<PlayerReplicationInfo> PRIarray;
		local PlayerReplicationInfo PRI;

		if( class'H7AdventureHudCntl'.static.GetInstance().IsWaitingForReturningPlayersPopupOpen() )
		{
			PRIarray = class'H7ReplicationInfo'.static.GetInstance().PRIArray;
			foreach PRIarray( PRI )
			{
				if( H7PlayerReplicationInfo(PRI).IsInCombatMap() )
				{
					return;
				}
			}
			class'H7AdventureHudCntl'.static.GetInstance().SetWaitingForReturningPlayers( false );

			if(mPlayerControllerInstance.IsServer())
			{
				class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendUpdateArmyXP(mArmyAttacker);
				class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendUpdateArmyXP(mArmyDefender);
			}
		}
	}
}

state GoingToCombat
{
	event BeginState(name previousStateName)
	{
		;
	}

	event EndState(name nextStateName)
	{
		;
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SetNormalCombatAboutToBegin( false );
	}

	event Tick(float deltaTime)
	{
		if( WorldInfo.GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
		{
			class'H7ReplicationInfo'.static.GetInstance().GetMpCommandManager().Update();
		}
	}
}

state Combat
{
	event BeginState(name previousStateName)
	{
		;
	}

	event EndState(name nextStateName)
	{
		;
	}
}

state CaravanTurn
{
	event BeginState(name previousStateName)
	{
		local H7CaravanArmy currentCaravan;
		local bool isCurrentPlayer;
		local array<H7AdventureMapCell> endCellBuffer;

		;
		mPlayerControllerInstance.SetCaravanTurn(true);

		mIsPlayerTurn = false;

		foreach mActiveCarravans(currentCaravan)
		{
			isCurrentPlayer = mPlayers[mCurrentPlayerIndex] == currentCaravan.GetPlayer();
			if(class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
			{
				isCurrentPlayer = true;
			}
			if( !currentCaravan.IsInTown() && isCurrentPlayer )
			{
				endCellBuffer = currentCaravan.MoveToTown(endCellBuffer);
			}
		}	

		GotoState('AdventureMap');
	}

	event EndState(name nextStateName)
	{
		local H7Town town;
		foreach mTownList( town ) 
		{
			if( town.GetPlayerNumber() == GetCurrentPlayer().GetPlayerNumber() || class'H7ReplicationInfo'.static.GetInstance().IsSimTurns())
			{
				town.CanBuildCaravanThisTurn( true );
			}
		}

		;
	}
}

function TickSessionGameplayTime( float deltaTime)
{
	mSessionGameplayTimeSec += deltaTime;

	// Every 60s clear timer, leave leftovers
	if(mSessionGameplayTimeSec >= 60.0f)
	{
		mSessionGameplayTimeSec -= 60.0f;

		mSessionGameplayTimeMin += 1;
	}
}

function SendTrackingCombatData()
{
	local JsonObject obj;
	obj = new class'JsonObject'() ;
	obj.SetIntValue("nbFights", mNumberOfFightsTotal);
	obj.SetIntValue("nbFightsManual", mNumberOfFightsManual);
	obj.SetIntValue("nbRounds", mNumberOfRoundsInFightsTotal);
	obj.SetIntValue("nbRoundsAutoCombat", mNumberOfRoundsInFightsAutoCombat);
	obj.SetIntValue("playerPosition", GetLocalPlayer().GetPlayerNumber() );
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_COMBAT_RECAP","combats.recap", obj );
	//`LOG("Combat recap: Number of fights total:"@mNumberOfFightsTotal@"manual fights"@mNumberOfFightsManual@"number of rounds total"@mNumberOfRoundsInFightsTotal@"number of rounds autocombat"@mNumberOfRoundsInFightsAutoCombat);
}

function SendTrackingTreasureHunt() 
{
	local JsonObject obj;

	obj = new class'JsonObject'();
	obj.SetStringValue("mapID", mMapSettings.mMapFileName);
	obj.SetIntValue("playerPosition", GetLocalPlayer().GetPlayerNumber() );
	obj.SetIntValue("nbTurns", GetCalendar().GetDaysPassed() );
	obj.SetIntValue("nbObelisksFound",  GetLocalPlayer().GetVisitedObelisks().Length );
	obj.SetIntValue("nbObelisksTotal", mAmountOfObelisks );
	obj.SetBoolValue("tearOfAshaFound", mTearOfAshaRetrieved );

	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_TREASUREHUNT","treasurehunt.step", obj );	
}


function SendTrackingSpellUsed()
{
	local array<H7AbilityTrackingData> trackingData;
	local H7AbilityTrackingData data;
	local JsonObject obj;
	
	trackingData = GetAbilityTrackingData();
	foreach trackingData( data )
	{
			obj = new class'JsonObject'();
			obj.SetIntValue("playerPosition", data.CasterPlayerPosition );
			obj.SetStringValue("playerFaction", data.CasterPlayerFaction );
			obj.SetStringValue( "spellId",			data.AbilityName );
			obj.SetStringValue( "spellName", data.AbilityName );
			obj.SetIntValue( "nbUses",			data.NumberOfCasts );
			OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_SPELL_USED","spell.used", obj );
	}

	mAbilityTrackingData.Length = 0;
	
}

function TrackingMapStart()
{
		local JsonObject obj;
		local int i,year,month,day,hours,minutes,seconds,dayoftheweek,mseconds;
		local string userID;
		
		
		obj = new class'JsonObject'() ;
		obj.SetIntValue("mapOrderId",class'H7PlayerProfile'.static.GetInstance().GetNumOfMapStarts() );
		obj.SetStringValue("mapID", mMapSettings.mMapFileName);
		obj.SetBoolValue("isSaveGame", class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() );
		for(i=0;i<mPlayerSettings.Length;++i)
		{
			if( mPlayerSettings[i].mSlotState != EPlayerSlotState_Undefined && mPlayerSettings[i].mSlotState != EPlayerSlotState_Closed )
			{
				if(mPlayerSettings[i].mFaction != none)
				{
					obj.SetStringValue("player"$i+1$"Faction",  mPlayerSettings[i].mFaction.GetArchetypeID());
				}
				else if( mPlayerSettings[i].mFactionRef != "")
				{
					obj.SetStringValue("player"$i+1$"Faction",  mPlayerSettings[i].mFactionRef);
				}
				else
				{
					obj.SetStringValue("player"$i+1$"Faction",  "Invalid faction data");
				}
				
			}
			else
			{
				obj.SetStringValue("player"$i+1$"Faction",  "None");
			}
			
			obj.SetStringValue("player"$i+1$"SlotType", string( mPlayerSettings[i].mSlotState ));
			if( mPlayerSettings[i].mSlotState == EPlayerSlotState_AI )
			{
				obj.SetStringValue("player"$i+1$"AIDifficulty", string( mPlayerSettings[i].mAIDifficulty) );

			}
			else
			{
				obj.SetStringValue("player"$i+1$"AIDifficulty", "N/A" );
			}
			
			obj.SetIntValue("player"$i+1$"Team",int( mPlayerSettings[i].mTeam ));
			
		}
		
		obj.SetStringValue("mapDifficulty",string( mGameSettings.mDifficulty ));
		//`LOG("Map difficulty START"@mGameSettings.mDifficulty@obj.GetStringValue("mapDifficulty"));
		obj.SetBoolValue("simTurns", mGameSettings.mSimTurns );
		obj.SetBoolValue("areRandomSkillsEnabled", mGameSettings.mUseRandomSkillSystem );
		obj.SetBoolValue("isHost",  mPlayerControllerInstance.IsServer() );
		mPlayerControllerInstance.GetSystemTime(year,month,dayoftheweek,day,hours,minutes,seconds,mseconds);

		if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )  
		{
			if(class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame())
			{
				mUniqueGameName = class'H7TransitionData'.static.GetInstance().GetUPlayHostID() $ "_" $ class'H7TransitionData'.static.GetInstance().GetMPTimeStamp();
			}
			else
			{
				OnlineGameInterfaceUPlay(class'GameEngine'.static.GetOnlineSubsystem().GameInterface).GetUPlayUserID( userID );
				mUniqueGameName = userID $ "_" $ year$month$day$hours$minutes$seconds;
			}
		}
	
		obj.SetStringValue("uniqueGameName", mUniqueGameName );
		
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_MAP_START", mMapSettings.mMapFileName, obj );
}



function TrackingRecruitHero()
{
	local int i;
	local JsonObject obj;
	local H7Player playerOwner;
	
	// not available to campaign, since there is not lobby
	if( GetCampaign() != none ) 
		return;

	for(i=0;i<mPlayerSettings.Length;++i)
	{
		if( mPlayerSettings[i].mSlotState != EPlayerSlotState_Undefined && mPlayerSettings[i].mSlotState != EPlayerSlotState_Closed )
		{
			playerOwner = GetPlayerByIndex( mPlayerSettings[i].mPosition );

			if(!playerOwner.IsControlledByAI() && playerOwner.IsControlledByLocalPlayer() && mPlayerSettings[i].mSlotState != EPlayerSlotState_Closed )
			{
				obj = new class'JsonObject'();
				obj.SetStringValue("heroId", mPlayerSettings[i].mStartHero.GetArchetypeID() );
				obj.SetStringValue("heroName", mPlayerSettings[i].mStartHero.GetName());
				obj.SetIntValue("heroLevel", mPlayerSettings[i].mStartHero.GetLevel());
				obj.SetStringValue("heroClass", string ( mPlayerSettings[i].mStartHero.GetHeroClass().Name ));
				obj.SetBoolValue("isOwnHero", false);
				obj.SetBoolValue("isOtherPlayerHero", false);
				obj.SetStringValue("playerFaction", string( playerOwner.GetFaction().Name ));
				obj.SetIntValue("playerPosition", int( playerOwner.GetPlayerNumber()) );
				obj.SetIntValue("nbTurns", class'H7AdventureController'.static.GetInstance().GetCalendar().GetDaysPassed()); 
				if(class'GameEngine'.static.GetOnlineSubsystem() != none
					&& OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()) != none)
				{
					OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_HERO_RECRUITED","hero.recruited", obj );
				}
			}
		}
	}

}


function TrackingMapEnd(string reason)
{
	local int i,j,year,month,day,hours,minutes,seconds,dayoftheweek,mseconds;
	local JsonObject obj;
	local bool hasWon, setWon;

	// This is here to ensure we dont send this data multiple times when user leaves the map. 
	// Extra call might come from OnUPlayMessage->UPlay_Event_Exit most often.
	if(mTrackingMapEndSend)
	{
		return;
	}

	mTrackingMapEndSend = true;

	SendTrackingSpellUsed();
	SendTrackingCombatData();

	obj = new class'JsonObject'() ;
	mPlayerControllerInstance.GetSystemTime(year,month,dayoftheweek,day,hours,minutes,seconds,mseconds);
	obj.SetIntValue("mapOrderId",class'H7PlayerProfile'.static.GetInstance().GetNumOfMapStarts() );
	obj.SetStringValue("mapID", mMapSettings.mMapFileName);
	
	for(i=0;i<mPlayerSettings.Length;++i)
	{
		setWon = false;
		if( mPlayerSettings[i].mSlotState != EPlayerSlotState_Closed && mPlayerSettings[i].mSlotState != EPlayerSlotState_Undefined )
		{
			if(mPlayerSettings[i].mFaction != none)
			{
				obj.SetStringValue("player"$i+1$"Faction",  mPlayerSettings[i].mFaction.GetArchetypeID());
			}
			else if( mPlayerSettings[i].mFactionRef != "")
			{
				obj.SetStringValue("player"$i+1$"Faction",  mPlayerSettings[i].mFactionRef);
			}
			else
			{
				obj.SetStringValue("player"$i+1$"Faction",  "Invalid faction data");
			}
		}
		else
		{
			obj.SetStringValue("player"$i+1$"Faction",  "None");
		}
		obj.SetStringValue("player"$i+1$"SlotType", string( mPlayerSettings[i].mSlotState ));
		//if( mPlayerSettings[i].mSlotState == EPlayerSlotState_AI )
		//{
		//	obj.SetStringValue("player"$i+1$"AIDifficulty", string( mPlayerSettings[i].mAIDifficulty) );

		//}
		//else
		//{
		//	obj.SetStringValue("player"$i+1$"AIDifficulty", "N/A" );
		//}

		for (j=0;j<mPlayers.Length;++j)
		{
			if( EPlayerNumber(int(mPlayerSettings[i].mPosition)) == mPlayers[j].GetPlayerNumber() &&  mPlayers[j].GetQuestController() != none) 
			{
				hasWon = mPlayers[j].GetQuestController().IsGameWon();
				obj.SetBoolValue("player"$i+1$"HasWon", hasWon);
				setWon = true;
				break;
			}
			else if(  EPlayerNumber(int(mPlayerSettings[i].mPosition)) == mPlayers[j].GetPlayerNumber() && !mPlayers[j].IsControlledByAI() )
			{
				;
				break;
			}
		}
		if( !setWon )
		{
			obj.SetBoolValue("player"$i+1$"HasWon", false);
		}
		obj.SetIntValue("player"$i+1$"Team",int( mPlayerSettings[i].mTeam ));
	}
		

	obj.SetStringValue("endReason",reason);
	obj.SetStringValue("mapDifficulty", string( mGameSettings.mDifficulty ) );
	obj.SetIntValue("nbTurns", GetCalendar().GetDaysPassed() );
	//`LOG("Map difficulty END"@mGameSettings.mDifficulty@obj.GetStringValue("mapDifficulty"));
	//if(GetCampaign() != none)
	//{
	//	obj.SetIntValue("playTime", class'H7PlayerProfile'.static.GetInstance().GetCampaignMapGameplayTimeMin(GetMapFileName()));
	//}
	//else
	//{
	//	obj.SetIntValue("playTime", class'H7PlayerProfile'.static.GetInstance().GetNormalMapGameplayTimeMin(GetMapFileName()) );
	//}
	obj.SetIntValue("playTime", mSessionGameplayTimeMin );
	
	obj.SetIntValue("nbMapLaunchUntilCompletion", class'H7PlayerProfile'.static.GetInstance().GetBasicMapData(mMapSettings.mMapFileName).StartTimesUntilCompleted );      
	obj.SetBoolValue("isHost",  mPlayerControllerInstance.IsServer() );
	obj.SetStringValue("uniqueGameName", mUniqueGameName);
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_MAP_STOP",  mMapSettings.mMapFileName, obj );
}

function TrackingGameStart()
{
	local EMapType maptype;
	local EGameMode gamemode;
	gamemode = GetCurrentGameMode();
	maptype = EMapType(  mMapInfo.GetMapType() );

	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_GAMEMODE_START", string(maptype)$"."$string(gamemode), new class'JsonObject'()  );

	if(maptype == CAMPAIGN)
	{
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_CAMPAIGN_START",string(mCampaign), new class'JsonObject'()  );	
	}
}

function TrackingGameModeEnd()
{
	local EMapType maptype;
	local EGameMode gamemode;
	gamemode = GetCurrentGameMode();
	maptype = EMapType(  mMapInfo.GetMapType() );


	class'H7ReplicationInfo'.static.PrintLogMessage("TRACKING - GAMEMODE "@string(maptype)$"."$string(gamemode), 0);;

	if(maptype == CAMPAIGN)
	{
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_CAMPAIGN_STOP",string(mCampaign), new class'JsonObject'()  );	
	}
	
	OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_GAMEMODE_STOP", string(maptype)$"."$string(gamemode), new class'JsonObject'()  );	
}

function ClearAllArmyNegotiationData(){}

/* Logs current game state for OOS */
function DumpCurrentState(H7Player pl)
{
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	local H7Town town;

	if(!class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() && GetCurrentPlayer() == pl)
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Player"@int(pl.GetPlayerNumber())@pl.GetName()@"Current Player!", 0);;
	}
	else
	{
		class'H7ReplicationInfo'.static.PrintLogMessage("Player"@int(pl.GetPlayerNumber())@pl.GetName(), 0);;
	}

	class'H7ReplicationInfo'.static.PrintLogMessage("  Resources Gold:"@pl.GetResourceSet().GetCurrency()
		@"Wood:"@pl.GetResourceSet().GetResource(pl.GetResourceSet().GetResourceByResourceTypeIdentifier("Wood"))
		@"Ore:"@pl.GetResourceSet().GetResource(pl.GetResourceSet().GetResourceByResourceTypeIdentifier("Ore"))
		@"Dragon Blood Crystal:"@pl.GetResourceSet().GetResource(pl.GetResourceSet().GetResourceByResourceTypeIdentifier("Dragon Blood Crystal"))
		@"Starsilver:"@pl.GetResourceSet().GetResource(pl.GetResourceSet().GetResourceByResourceTypeIdentifier("Starsilver"))
		@"Dragon Steel:"@pl.GetResourceSet().GetResource(pl.GetResourceSet().GetResourceByResourceTypeIdentifier("Dragon Steel"))
		@"Shadowsteel:"@pl.GetResourceSet().GetResource(pl.GetResourceSet().GetResourceByResourceTypeIdentifier("Shadowsteel")), 0);;

	class'H7ReplicationInfo'.static.PrintLogMessage("  Armies:", 0);;
	armies = GetPlayerArmies(pl);
	foreach armies(army)
	{
		army.DumpCurrentState();
	}

	class'H7ReplicationInfo'.static.PrintLogMessage("  Towns:", 0);;
	foreach mTownList(town)
	{
		if(town.GetPlayer() == pl)
		{
			town.DumpCurrentState();
		}
	}
}

function UpdateEndDayDelayedWeekStart()
{
	mHallOfHeroesManager.UpdateEndDay( true );
}

///////////////////////////////////////////////////////////////////////////////////////////////////


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

