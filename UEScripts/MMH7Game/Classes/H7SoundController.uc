//=============================================================================
// H7SoundController
//
// SoundController to play and control sound events, settings and sound game behaviour
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7SoundController extends Object
	config(game)
	native
	placeable;

var protected Name                                  mCurrentTileName;
var protected float                                 mExecMusicTargetTime;
var protected string                                mCurrentMapType;
var protected string                                mCurrentTownScreenFaction;
var protected bool                                  mIsMusicPlaying;
var protected bool                                  mNextTurn;
var protected bool                                  mInCinematicMode;
var protected float                                 mCurrentAttenuationDistance;

var protected Name                                  mCurrentUnitUndergroundName;

//AI Music
var (AI_Music) protected AkEvent                                  mPlayAITurnMusic                <DisplayName = Play AI Turn Music AkEvent>;
var (AI_Music) protected AkEvent                                  mResumeAITurnMusic              <DisplayName = Resume AI Turn Music AkEvent>;

//Credits Music
var (Credits_Music) protected AkEvent                             mPlayCreditsMusic               <DisplayName = Play AI Turn Music AkEvent>;

//Play TownScreen Music Events
var (Music_Events_Town_Screen) protected AkEvent                  mPlayAcademyTownMusic           <DisplayName = Play Academy Town Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mPlayHavenTownMusic             <DisplayName = Play Haven Town Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mPlayStrongholdTownMusic        <DisplayName = Play Stronghold Town Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mPlayNecropolisTownMusic        <DisplayName = Play Necropolis Town Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mPlaySylvanTownMusic            <DisplayName = Play Sylvan Town Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mPlayDungeonTownMusic           <DisplayName = Play Dungeon Town Music AkEvent>;

//Resume TownScreen Music
var (Music_Events_Town_Screen) protected AkEvent                  mResumeAcademyTownMusic        <DisplayName = Resume Academy Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mResumeHavenTownMusic           <DisplayName = Resume Haven Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mResumeStrongholdTownMusic      <DisplayName = Resume Stronghold Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mResumeNecropolisTownMusic      <DisplayName = Resume Necropolis Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mResumeSylvanTownMusic          <DisplayName = Resume Sylvan Town Music AkEvent>;
var (Music_Events_Town_Screen) protected AkEvent                  mResumeDungeonTownMusic         <DisplayName = Resume Dungeon Town Music AkEvent>;

//AM TOWN Music bool states
var protected bool                                                mAcademyTownIsPlaying;
var protected bool                                                mStrongholdTownIsPlaying;
var protected bool                                                mHavenTownIsPlaying;
var protected bool                                                mDungeonTownIsPlaying;
var protected bool                                                mSylvanTownIsPlaying;
var protected bool                                                mNecropolisTownIsPlaying;
var protected bool                                                mMusicIsPlaying;
var protected bool                                                mCombatMusicIsPlaying;

//Various Play Music Events
var (Music_Events_Combat_Map) protected AkEvent                   mCombatMusic                    <DisplayName = Combat Music AkEvent>;
var (Music_Events_Victory_Screen) protected AkEvent               mVictoryMusic                   <DisplayName = Victory Music AkEvent>;
var (Music_Events_Defeat_Screen) protected AkEvent                mDefeatMusic                    <DisplayName = Defeat Music AkEvent>;
var (Music_Events_Main_Menu) protected AkEvent                    mMainMusic                      <DisplayName = MainMenu Music AkEvent>;

// Various Resume Music Events
var (Music_Events_Main_Menu) protected AkEvent                    mResumeMainMusic                <DisplayName = Resume MainMenu Music AkEvent>;
var (Music_Events_Combat_Map) protected AkEvent                   mResumeCombatMusic              <DisplayName = Resume Combat Music AkEvent>;

var (Controlling_Music_Events) protected AkEvent                  mPauseAllMusic                  <DisplayName = Pause All Music AkEvent>;
var (Controlling_Music_Events) protected AkEvent                  mStopAllMusic                   <DisplayName = Stop All Music AkEvent>;
var (Controlling_Music_Events) protected AkEvent                  mStopAllCombatMusic             <DisplayName = Stop All combat Music AkEvent>;
var (Controlling_Music_Events) protected AkEvent                  mStopAllExceptMusic             <DisplayName = Stop All except Music AkEvent>;


var (Adjustable_Music_Variables) protected float                  mMusicDuckingValue              <DisplayName = Music ducking value>;

//Ambient Controlling Events
var (Ambient_Controlling) protected AkEvent                       mBasicAmbientStop               <DisplayName = Basic Ambient Stop>;

//Voice Over Controlling Events
var (VoiceOver_Controlling) protected AkEvent                     mVoiceOverStop                  <DisplayName = VoiceOver Stop>;

//AM Cell Dependant Music Variables
var protected AkEvent                                             mCurrentMusicEvent;
var protected AkEvent                                             mResumeMusicEvent;
var protected AkEvent                                             mLastMusicEvent;
var protected AkEvent                                             mCurrentAmbientEvent;
var protected AkEvent                                             mFoWAmbientEvent;
var protected AkEvent                                             mLastAmbientEvent;
var protected array <AkEvent>                                     mPlayedMusicEvents;
var protected H7AdventureLayerCellProperty                        mLastVisitedCell;

//General Sound Setting
var protected config bool                           cMusicSetting;
var protected config float                          cMusicVolume;
var protected config bool                           cSoundSetting;
var protected config float                          cSoundVolume;
var protected config bool                           cVoiceOverSetting;
var protected config float                          cVoiceOverVolume;
//Master Sound Settings
var protected globalconfig float                    cMasterVolume;
var protected config bool                           cMasterSetting;
//Ambient Sound Setting
var protected config bool                           cAmbientSoundSetting;
var protected config float                          cAmbientSoundVolume;

//Get Functions
function bool               GetMusicSetting()               { return cMusicSetting; }
function bool               GetSoundSetting()               { return cSoundSetting; }
function float              GetMusicVolume()                { return cMusicVolume; }
function float              GetSoundVolume()                { return cSoundVolume; }
function float              GetMasterVolumeSettings()       { return cMasterVolume; }
function bool               GetMasterSettings()             { return cMasterSetting; }
function bool               GetAmbientSoundSettings()       { return cAmbientSoundSetting; }
function float              GetAmbientSoundVolume()         { return cAmbientSoundVolume; }
function bool               GetVoiceOverSetting()           { return cVoiceOverSetting; }
function float              GetVoiceOverVolume()            { return cVoiceOverVolume; }
function AKEvent            GetBasicAmbientStopEvent()      { return mBasicAmbientStop; }
function AKEvent            GetLastAmbientEvent()           { return mLastAmbientEvent; }
function AkEvent            GetVoiceOverStopAllEvent()      { return mVoiceOverStop; }
function AkEvent            GetMainMusicResumeEvent()           { return mResumeMainMusic; }
function AkEvent            GetStopAllExceptMusicEvent()    { return mStopAllExceptMusic; }
function AkEvent            GetCreditsMusicEvent()          { return mPlayCreditsMusic; }

//Enables the possibility for a music change on the adventuremap
function SetNextTurn( bool val ) { mNextTurn = val; } 

function Initialize(optional bool silentSFX = false)
{
	//On start initialisation
	SetAmbientSoundVolume(cAmbientSoundVolume);
	SetSoundVolume(cSoundVolume);
	if(silentSFX)
	{
		EnableSoundChannel(false);	
	}
	SetMusicVolume(cMusicVolume);
	SetVoiceOverVolume(cVoiceOverVolume);
	SetMasterVolumeSettings(cMasterVolume);

	mMusicIsPlaying = false;
}

singular event Destroyed()
{
	if(!class'H7TransitionData'.static.GetInstance().GetIsInMapTransition())
	{
		GetSoundManager().PlayAkEvent(mStopAllMusic,true,,true);
		mMusicIsPlaying = false;
	}
}

function H7SoundManager GetSoundManager()
{
	return class'H7ReplicationInfo'.static.GetInstance().GetSoundManager();
}

///////////////////////////////////////////////////////////////////
//AMBIENT SOUND
///////////////////////////////////////////////////////////////////

function SetLastAmbientEvent(AKEvent event){ mLastAmbientEvent = event; }

function SetAmbientSoundVolume(float fVol)
{
	cAmbientSoundVolume = fVol;

	if(cAmbientSoundSetting && cMasterSetting)
	{
		if(GetSoundManager() != none)
		{
			//Dont enable ambient in townscreen
			if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() == none || !class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInTownScreen())
			{
				GetSoundManager().SetRTPCValueBus ('Ambience_Volume', cAmbientSoundVolume*100);
				GetSoundManager().StartAmbientLayers();
			}
		}
	}
	else
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('Ambience_Volume', 0);
			GetSoundManager().StopAmbientLayers();
		}
	}

	;
	
	SaveConfig();
}

//Wrapper for the Options Manager
function SetAmbientSoundSettingsBool(bool bVal)
{
	SetAmbientSoundSettings(bVal);
	UpdateMasterSetting();
}

function SetAmbientSoundSettings(bool bVal)
{
	cAmbientSoundSetting = bVal;

	SetAmbientSoundVolume(cAmbientSoundVolume);
}

function EnableAmbientChannel( bool enable )
{
	if( !cAmbientSoundSetting || !cMasterSetting || enable==false )
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('Ambience_Volume', 0.f);
		}
	}
	else if( cAmbientSoundSetting && cMasterSetting && enable==true )
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('Ambience_Volume', cAmbientSoundVolume*100);
		}
	}
}

// FOW disables covered SoundNodes
event UpdateHearableAmbientSoundNodes()
{
	GetSoundManager().UpdateHearableAmbientSoundNodes();
}

function bool FogOfWarIsRevealedCheck( optional Vector objectLocation )
{
	local H7FOWController fogController;
	local H7AdventureMapGridController gridController;
	local H7AdventureMapCell currentCell;
	local IntPoint gridLocation;
	local int playerNumber;
	local bool result;
	local H7AdventureController advController;

	advController = class'H7AdventureController'.static.GetInstance();
	if(advController == none || advController.GetGridController() == none)
	{
		return false;
	}

	if( class'H7Camera'.static.GetInstance() != none && objectLocation == vect(0,0,0) )
	{
		currentCell = advController.GetGridController().GetCurrentGrid().GetCellByWorldLocation(class'H7Camera'.static.GetInstance().GetCurrentVRP());
	}
	else
	{
		currentCell = advController.GetGridController().GetCurrentGrid().GetCellByWorldLocation( objectLocation );
	}

	if( currentCell == none ){ return false; }

	if(currentCell.GetGridOwner() != none)
	{
		gridController = currentCell.GetGridOwner();
	}

	if(gridController != none && gridController.GetFOWController() != none)
	{
		gridLocation = currentCell.GetGridPosition();
		playerNumber = advController.GetLocalPlayer().GetPlayerNumber();
		fogController = gridController.GetFOWController();
		result = fogController.CheckExploredTile(playerNumber, gridLocation);

		return result;
	}
	
	return false;
}

//---------------------------------------------------------------END

///////////////////////////////////////////////////////////////////
//MASTER
///////////////////////////////////////////////////////////////////

function SetMasterVolumeSettings(float fVol)
{
	cMasterVolume = fVol;

	if(cMasterSetting)
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('Master_Volume', cMasterVolume*100);
		}

		class'H7EngineUtility'.static.SetMusicVolumeSetting(cMasterVolume * cMusicVolume);
		class'H7EngineUtility'.static.SetVoiceVolumeSetting(cMasterVolume * cVoiceOverVolume);
	}
	else
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('Master_Volume', 0.f);
		}

		class'H7EngineUtility'.static.SetMusicVolumeSetting(0.f);
		class'H7EngineUtility'.static.SetVoiceVolumeSetting(0.f);
	}
	 

	;

	SaveConfig();
}

function SetMasterSettings(bool bVal)
{
	cMasterSetting = bVal;

	SetMasterVolumeSettings(cMasterVolume);
	SetMusicSetting(cMusicSetting);
	SetSoundSetting(cSoundSetting);
	SetAmbientSoundSettings(cAmbientSoundSetting);

	cMasterSetting = bVal; // make sure it's really how we wanted it, because the others could set it back to false
}

function UpdateMasterSetting()
{
	if(!cMusicSetting && !cSoundSetting && !cAmbientSoundSetting && !cVoiceOverSetting && cMasterSetting)
	{
		cMasterSetting = false;
		class'H7OptionsMenuCntl'.static.GetInstance().GetOptionsMenu().SetCheckBox("MASTER_ENABLED",false);
	}
}

//---------------------------------------------------------------END

///////////////////////////////////////////////////////////////////
//MUSIC
///////////////////////////////////////////////////////////////////


function SetMusicSetting( bool val )
{
	cMusicSetting = val;
	
	if(cMusicSetting && cMasterSetting)
	{
		UpdateMusicGameStateSwitch( mCurrentMapType, mCurrentTownScreenFaction );
	}

	SetMusicVolume(cMusicVolume);
	UpdateMasterSetting();
}

function SetMusicVolume(float value)
{
	cMusicVolume = value;

	if(cMusicSetting && cMasterSetting)
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('Music_Volume', cMusicVolume*100);
		}

		class'H7EngineUtility'.static.SetMusicVolumeSetting(cMasterVolume * cMusicVolume);
	}
	else
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('Music_Volume', 0.f);
		}

		class'H7EngineUtility'.static.SetMusicVolumeSetting(0.f);
	}

	;

	SaveConfig();
}

function InCinematicMode(bool val)
{
	mInCinematicMode = val;
}

//The H7AdventuremapLayerCellProperty contains two arrays with play and resume music events and a general ambient sound event for both cases

function AdventureMapCellInput()
{
	local H7AdventureLayerCellProperty currentCell;
	local H7AdventureMapCell viewCell;
	local H7AdventureController advController;

	advController = class'H7AdventureController'.static.GetInstance();
	if(advController == none)
	{
		return;
	}
	
	if(advController.GetSelectedArmy() != none)
	{
		if(advController.GetSelectedArmy().GetCell() != none)
		{
			currentCell = advController.GetSelectedArmy().GetCell().GetSourceLayerCellData();
			mLastVisitedCell = currentCell;
		}
	}
	else
	{
		if(mLastVisitedCell != none)
		{
			currentCell = mLastVisitedCell; // No hero selected. The hero is defeated/in town, take last known position
		}
		else
		{
			// if there is no hero selected and no last visited cell stored, take the cell in the VRP of the camera
			viewCell = advController.GetGridController().GetCurrentGrid().GetCellByWorldLocation(class'H7Camera'.static.GetInstance().GetCurrentVRP());
			if( viewCell != none )
			{
				currentCell = viewCell.GetSourceLayerCellData();
				mLastVisitedCell = currentCell;
			}
		}
	}

	if( currentCell != none )
	{
		if( currentCell.mPlayAkEvents != none && mNextTurn )
		{
			mCurrentMusicEvent = currentCell.mPlayAkEvents;
		}

		if( currentCell.mResumeAkEvents != none && mNextTurn )
		{
			mResumeMusicEvent = currentCell.mResumeAkEvents;
		}

		if( currentCell.mPlayAmbientAkEvents != none )
		{
			mCurrentAmbientEvent = currentCell.mPlayAmbientAkEvents;
		}

		if(currentCell.mPlayFoWAmbientAkEvents != none )
		{
			mFoWAmbientEvent = currentCell.mPlayFoWAmbientAkEvents;
		}
	}

	if( advController.GetSelectedArmy() != none && advController.GetCurrentPlayer().GetPlayerType() == PLAYER_AI && mNextTurn )
	{
		//Play AI Music
		mCurrentMusicEvent = mPlayAITurnMusic;
		mResumeMusicEvent = mResumeAITurnMusic;
	}

	//the Basic Ambient is updated frequently
	if( mCurrentMapType == "ADVENTURE_MAP" && cAmbientSoundSetting && cMasterSetting && !mInCinematicMode )
	{
		if(!FogOfWarIsRevealedCheck() && mLastAmbientEvent != mFoWAmbientEvent && mFoWAmbientEvent != none)
		{
			if(GetSoundManager() != none)
			{
				GetSoundManager().PlayAkEvent(mFoWAmbientEvent,true,, true);
			}

			SetLastAmbientEvent(mFoWAmbientEvent);
		}
		else if (FogOfWarIsRevealedCheck() && mLastAmbientEvent != mCurrentAmbientEvent && mCurrentAmbientEvent != none )
		{
			if(GetSoundManager() != none)
			{
				GetSoundManager().PlayAkEvent(mCurrentAmbientEvent, true,, true);
			}
			//Save the Last Ambient Event for the "is already playing check"
			SetLastAmbientEvent(mCurrentAmbientEvent);
		}
	}
}

function PlayAdventureMapMusic()
{
	local int j;

	if(mInCinematicMode || !cMusicSetting || !cMasterSetting )
	{
		return;
	}

	//Check if the music was played before and is in paused state
	if( mCurrentMapType == "ADVENTURE_MAP" )
	{
		for (j = 0; j < mPlayedMusicEvents.Length; j++ )
		{
			if( mCurrentMusicEvent == mPlayedMusicEvents[j] )
			{
				if(mResumeMusicEvent != none)
				{
					mCurrentMusicEvent = mResumeMusicEvent;
				}
			}
		}
		
		if( mLastMusicEvent != mCurrentMusicEvent && mCurrentMusicEvent != none )
		{
			PostEvent(mCurrentMusicEvent,false);
			mMusicIsPlaying = true;
			//Save the Last Music Event for the "is already playing check"
			mLastMusicEvent = mCurrentMusicEvent;
			mNextTurn = false;
		}
	}
}

function UpdateMusicGameStateSwitch(string mapType, optional string faction)
{
	local string townFaction;
	local AkEvent customMusic, customAmbient;
	local H7CombatMapGridController combatGridController;

	townFaction = faction;

	//Only map types are referenced
	if(mCurrentMapType != mapType && ( mapType == "ADVENTURE_MAP" || mapType == "COMBAT_MAP" || mapType == "TOWN_SCREEN" || mapType == "MAIN_MENU" ))
	{
		mCurrentMapType = mapType;

		;
	}

	if(mCurrentTownScreenFaction != faction)
	{
		mCurrentTownScreenFaction = faction;

		;
	}

	switch(mapType)
	{
		case "ADVENTURE_MAP": 

			if( mInCinematicMode ){ return; }

			if(mNextTurn || !mMusicIsPlaying)
			{
				AdventureMapCellInput();

				if(GetSoundManager() != none)
				{
					GetSoundManager().StartDynamicMusicTimerLoop();
				}
			}
			//Stop all combat musics in WWise after returning to AM
			PlayGlobalAkEvent(mStopAllCombatMusic,true);
			mCombatMusicIsPlaying = false;

			if(mCurrentAmbientEvent != none && mCurrentAmbientEvent != mLastAmbientEvent && GetSoundManager() != none)
			{
				GetSoundManager().PlayAkEvent(mCurrentAmbientEvent, true,, true);
			}

			//Prevents that the townscreen music is overwritten by the AM Music
			if(!class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInTownScreen())
			{
				PlayAdventureMapMusic();
			}

			EnableSoundChannel(true);
			EnableAmbientChannel(true);

		break;

		case "COMBAT_MAP": 
		
			if( cMasterSetting )
			{
				combatGridController = class'H7CombatMapGridController'.static.GetInstance();
				if( cMusicSetting && !mCombatMusicIsPlaying )
				{
					if( combatGridController != none && combatGridController.GetMapSpecialMusic() != none )
					{
						//For the case the special music is not part of the music set
						GetSoundManager().PlayAkEvent( mPauseAllMusic,true);

						customMusic = combatGridController.GetMapSpecialMusic();
						GetSoundManager().PlayAkEvent( customMusic,true,,false );

						mLastMusicEvent = customMusic;
						mCombatMusicIsPlaying = true;
						mMusicIsPlaying = true;
					}
					else
					{
						GetSoundManager().PlayAkEvent( mCombatMusic,true,,false );

						mLastMusicEvent = mCombatMusic;
						mCombatMusicIsPlaying = true;
						mMusicIsPlaying = true;
					}
				}

				if( cAmbientSoundSetting )
				{
					//If there is a special defined basic ambience -> play it
					if(combatGridController != none && combatGridController.GetMapSpecialAmbient() != none)
					{
						customAmbient = combatGridController.GetMapSpecialAmbient();
						GetSoundManager().PlayAkEvent( customAmbient,true,,true );
						SetLastAmbientEvent( customAmbient);
					}
				}
			}

		break;

		case "TOWN_SCREEN": 

			if(townFaction != "" && townFaction != "Generic")
			{
				townFaction = Caps( townFaction );
				SwitchTownScreenMusic( townFaction );
				EnableSoundChannel(true);
				EnableAmbientChannel(false);
				//Resets the last AM Music, so the resume event can be triggered
				ResetLastMusicEvent();
			}
			break;

		case "VICTORY_SCREEN":
			EnableAmbientChannel(false);
			break;

		case "DEFEAT_SCREEN":
			EnableAmbientChannel(false);
			break; 

		case "MAIN_MENU": 

			if(cMasterSetting && cMusicSetting)
			{
				if(!mMusicIsPlaying && !class'H7TransitionData'.static.GetInstance().GetIsMainMenu())
				{
					GetSoundManager().PlayAkEvent(mMainMusic,true,,false);
					mCombatMusicIsPlaying = false;
					mMusicIsPlaying = true;
				}
			}

			EnableSoundChannel(true);
			EnableAmbientChannel(true);
			ResetLastMusicEvent();
			GetSoundManager().StopAmbientLayers();

			break;

		case "CINEMATIC":
			GetSoundManager().PlayAkEvent(mPauseAllMusic,true);
			//For Events in the middle of a turn reset the music event so it can resume
			ResetLastMusicEvent();
			EnableSoundChannel(false);
			EnableAmbientChannel(false);
			break;

		case "STOP_AMBIENT": 
			GetSoundManager().StopAmbientLayers();
			break;

		case "PAUSE_GAME_THEME": 
			GetSoundManager().PlayAkEvent(mPauseAllMusic,true);
			break;

		case "CLICK_PLAY_PAUSE_MUSIC_BUTTON" : 
			GetSoundManager().PlayAkEvent(mPauseAllMusic,true);
			break;

		case "STOP_ALL_MUSIC": 
			GetSoundManager().PlayAkEvent(mStopAllMusic,true);
			mMusicIsPlaying = false;
			ResetMusicVariables();
			GetSoundManager().StopAmbientLayers();
			break;

		default:;
	}
}

function SwitchTownScreenMusic(string faction)
{
	local string townFaction;

	townFaction = faction;
	
	if(!cMasterSetting || !cMusicSetting)
	{
		return;
	}

	Switch(townFaction)
	{
	case "H7FACTIONACADEMY": 

		if(!mAcademyTownIsPlaying)
		{
			PostEvent(mPlayAcademyTownMusic,false);
			mAcademyTownIsPlaying = true;
			mCombatMusicIsPlaying = false;
			mMusicIsPlaying = true;
		}
		else
		{
			PostEvent(mResumeAcademyTownMusic,false);
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}

		break;
	case "H7FACTIONHAVEN": 
		
		if(!mHavenTownIsPlaying)
		{
			PostEvent(mPlayHavenTownMusic,false);
			mHavenTownIsPlaying = true;
			mCombatMusicIsPlaying = false;
			mMusicIsPlaying = true;
		}
		else
		{
			PostEvent(mResumeHavenTownMusic,false);
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}

		break;
	case "H7FACTIONSTRONGHOLD": 
		
		if(!mStrongholdTownIsPlaying)
		{
			PostEvent(mPlayStrongholdTownMusic,false);
			mStrongholdTownIsPlaying = true;
			mCombatMusicIsPlaying = false;
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}
		else
		{
			PostEvent(mResumeStrongholdTownMusic,false);
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}

		break;
	case "H7FACTIONSYLVAN": 

		if(!mSylvanTownIsPlaying)
		{
			PostEvent(mPlaySylvanTownMusic,false);
			mSylvanTownIsPlaying = true;
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}
		else
		{
			PostEvent(mResumeSylvanTownMusic,false);
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}

		break;
	case "H7FACTIONDUNGEON": 

		if(!mDungeonTownIsPlaying)
		{
			PostEvent(mPlayDungeonTownMusic,false);
			mDungeonTownIsPlaying = true;
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}
		else
		{
			PostEvent(mResumeDungeonTownMusic,false);
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}

		break;
	case "H7FACTIONNECROPOLIS": 

		if(!mNecropolisTownIsPlaying)
		{
			PostEvent(mPlayNecropolisTownMusic,false);
			mNecropolisTownIsPlaying = true;
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}
		else
		{
			PostEvent(mResumeNecropolisTownMusic,false);
			mMusicIsPlaying = true;
			mCombatMusicIsPlaying = false;
		}

		break;
	}
}

function PostEvent(AKEvent newEvent, bool stopWhenOwnerDestroyed)
{
	local AKEvent currentEvent;
	local AkEvent notedEvent;
	local bool isNoted;

	currentEvent = newEvent;

	if(!cMasterSetting)
	{
		return;
	}

	if(class'H7BaseGameController'.static.GetBaseInstance() != none)
	{	
		if(GetSoundManager() != none)
		{
			GetSoundManager().PlayAkEvent(currentEvent,true,,stopWhenOwnerDestroyed);
		}
	}
	
	foreach mPlayedMusicEvents (notedEvent)
	{
		if(notedEvent == currentEvent)
		{
			isNoted = true;
		}
	}

	if(!isNoted)
	{
		mPlayedMusicEvents.AddItem(currentEvent);
	}
}

function PlayPauseMusic()
{
	if(mIsMusicPlaying)
	{
		GetSoundManager().PlayAkEvent(mPauseAllMusic,true);
	}
	else
	{
		UpdateMusicGameStateSwitch( mCurrentMapType, mCurrentTownScreenFaction );
	}
}

function ResetLastMusicEvent()
{
	;

	mLastMusicEvent = none;
}

function ResetLastAmbientEvent()
{
	;

	SetLastAmbientEvent(none);
}

//Call this function, if you want to play all the music from the beginning
function ResetMusicVariables()
{
	local int i;

	;
		//flushing the music arrays references
		for (i=0; i< mPlayedMusicEvents.Length; i++)
		{
			mPlayedMusicEvents[i] = none;
		}
		
		ResetLastMusicEvent();
		ResetLastAmbientEvent();

		mNecropolisTownIsPlaying = false;
		mDungeonTownIsPlaying = false;
		mSylvanTownIsPlaying = false;
		mStrongholdTownIsPlaying = false;
		mHavenTownIsPlaying = false;
		mAcademyTownIsPlaying = false;
}

function StartMusicDucking()
{
	if(GetSoundManager() != none)
	{
		GetSoundManager().SetRTPCValue('Sidechain_GUI', mMusicDuckingValue);
	}
}

//---------------------------------------------------------------END


///////////////////////////////////////////////////////////////////
//VOICEOVER
///////////////////////////////////////////////////////////////////

function SetVoiceOverSetting( bool val )
{
	cVoiceOverSetting = val;

	SetVoiceOverVolume(cVoiceOverVolume);
	UpdateMasterSetting();
}

function SetVoiceOverVolume(float value)
{
	cVoiceOverVolume = value;

	if(cVoiceOverSetting && cMasterSetting)
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('VoiceOver_Volume', cVoiceOverVolume*100);
		}

		class'H7EngineUtility'.static.SetVoiceVolumeSetting(cMasterVolume * cVoiceOverVolume);
	}
	else
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('VoiceOver_Volume', 0.f);
		}

		class'H7EngineUtility'.static.SetVoiceVolumeSetting(0.f);
	}

	;

	SaveConfig();
}

function EnableVoiceChannel( bool enable )
{
	if( !cVoiceOverSetting || !cMasterSetting || enable==false )
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('VoiceOver_Volume', 0.f );
		}
	}
	else if( cVoiceOverSetting && cMasterSetting && enable==true )
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('VoiceOver_Volume', cVoiceOverVolume*100);
		}
	}
}

//---------------------------------------------------------------END


///////////////////////////////////////////////////////////////////
//SOUND
///////////////////////////////////////////////////////////////////

function SetSoundVolume( float value )
{
	cSoundVolume = value;

	if(cSoundSetting && cMasterSetting)
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('SFX_Volume', cSoundVolume*100);
			GetSoundManager().SetRTPCValueBus ('SFX_NoCutscene_Volume', cSoundVolume*100);
		}
	}
	else
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('SFX_Volume', 0.f);
			GetSoundManager().SetRTPCValueBus ('SFX_NoCutscene_Volume', 0.f);
		}
	}
	
	;
	
	SaveConfig();
}

function SetSoundSetting(bool bVal)
{
	cSoundSetting = bVal;

	SetSoundVolume(cSoundVolume);
	UpdateMasterSetting();
}

function EnableSoundChannel( bool enable )
{
	if( !cSoundSetting || !cMasterSetting || enable==false )
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('SFX_Volume', 0.f );
		}
	}
	else if( cSoundSetting && cMasterSetting && enable==true )
	{
		if(GetSoundManager() != none)
		{
			GetSoundManager().SetRTPCValueBus ('SFX_Volume', cSoundVolume*100);
		}
	}
}

// SFX_NoCutscene_Volume is used for the SFX sounds that we dont want to hear if there is a cutscene. For example: victory_sound.
function EnableSoundCutsceneChannel( bool enable )
{
	if( !cSoundSetting || !cMasterSetting || enable==false )
	{
		if(GetSoundManager() != none)
		{
			//GetSoundManager().SetRTPCValueBus ('SFX_NoCutscene_Volume', 0.f );
		}
	}
	else if( cSoundSetting && cMasterSetting && enable==true )
	{
		if(GetSoundManager() != none)
		{
			//GetSoundManager().SetRTPCValueBus ('SFX_NoCutscene_Volume', cSoundVolume*100);
		}
	}
}

//---------------------------------------------------------------END

///////////////////////////////////////////////////////////////////
//SPECIAL BEHAVIOUR
///////////////////////////////////////////////////////////////////

function LoadingScreenEnabled(bool val)
{
	if(val)
	{
		//To ensure the music can resume after loading, if still of the same kind
		ResetLastMusicEvent();
		EnableSoundChannel(false);
		EnableAmbientChannel(false);
	}
	else
	{
		EnableSoundChannel(true);
		EnableAmbientChannel(true);
	}
}

function UpdateCameraDistanceAttenuation(float currentDistance, float cameraMin, float cameraMax)
{
	local float distanceRange, distancePercentage, distanceFinal;

	if(mCurrentAttenuationDistance != currentDistance)
	{
		distanceRange = cameraMax - cameraMin;
		distancePercentage = distanceRange/100.f;
		distanceFinal = (currentDistance-cameraMin)/distancePercentage;

		SetDistanceAttenuationValue(distanceFinal);
		mCurrentAttenuationDistance = currentDistance;

		;
	}
}

function SetDistanceAttenuationValue(float value)
{
	if(GetSoundManager() != none)
	{
		//Updates Wwise with the attenuation values from 0-100%, in dependency of the camera distance to the ground
		GetSoundManager().SetRTPCValueBus('CAMERA_Distance_Attenuation_Value', value);
	}
}

function ResetOptions()
{
	// hack because can't access real default values
	SetMasterSettings(True);
	SetMasterVolumeSettings(1);
	cMusicSetting=True;
	SetMusicVolume(1);
	cSoundSetting=True;
	SetSoundVolume(1);
	cVoiceOverSetting=True;
	SetSoundVolume(1);
	cAmbientSoundSetting=True;
	SetAmbientSoundVolume(1);
	cVoiceOverSetting=true;
	SetVoiceOverVolume(1);
}

static function PlayGlobalAkEvent(AkEvent InSoundCue, optional bool bNotReplicated, optional bool bNoRepToOwner, optional bool bStopWhenOwnerDestroyed, optional vector SoundLocation, optional bool bNoRepToRelevant)
{
	if(GetInstance().GetSoundManager() != none)
	{
		GetInstance().GetSoundManager().PlayAkEvent(InSoundCue, bNotReplicated, bNoRepToOwner, bStopWhenOwnerDestroyed, SoundLocation, bNoRepToRelevant);
	}
}

static function H7SoundController GetInstance()
{
	local H7ReplicationInfo theReplicationInfo;

	theReplicationInfo = class'H7ReplicationInfo'.static.GetInstance();
	if( theReplicationInfo == none || theReplicationInfo.GetControllerManager() == none )
	{
		return none;
	}

	return theReplicationInfo.GetControllerManager().GetSoundController();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

