//=============================================================================
// H7CouncilMapManager
//=============================================================================
//
// This is an actor that sits in the councilscene_map.umap and is streamed with it
// It manages display effects, story points etc.
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CouncilMapManager extends Actor 
	dependson(H7CouncilGameInfo)
	dependson(H7PlayerProfile)
	dependson(H7StructsAndEnums)
	placeable
;

var(HighlightColors) protected Color mCampaignHighlight;
var(HighlightColors) protected Color mSelectedHighlight;

var(MapCamera) protected CameraActor mCameraActor;
var(MapCamera) protected PostProcessChain mMapPP;

var(Map) protected StaticMeshActor mContinentMesh;
var(Map) protected StaticMeshActor mTableMesh;
var(Map) protected H7CouncilScrollActor mCouncilScroll;

var array<CampaignsMapData> mCampaignMaps;

var protected bool mIsActive;

var protected int mHighlightedCampaignIndex;
var protected int mHighlightedFlagIndex;

var protected H7CouncilGameInfo mCouncilGameInfo;
var protected H7AdventureMapInfo mAdventureGameInfo;

var protected H7PlayerProfile mPlayerProfile;

var protected H7CouncilPlayerController mCouncilPlayerController;

var protected int mSelectedCampaignIndex;
var protected int mSelectedFlagIndex;

function static H7CouncilMapManager GetInstance() 
{
	if(class'H7AdventureController'.static.GetInstance() != none)
		return class'H7AdventureController'.static.GetInstance().GetCouncilMapManager();
	else if(class'H7CouncilManager'.static.GetInstance() != none)
		return class'H7CouncilManager'.static.GetInstance().GetMapManager();
}

////////////////////////
// Getters / Setters
///////////////////////

function bool IsActive() { return mIsActive; } 

function H7CouncilScrollActor GetScroll() { return mCouncilScroll; }
function StaticMeshActor GetContinentMesh() { return mContinentMesh; } 
function StaticMeshActor GetTableMesh() { return mTableMesh; } 

function CameraActor GetMapCamera() { return mCameraActor; } 
function PostProcessChain GetMapPP() { return mMapPP; }

function array<CampaignsMapData> GetCampaignFlags() { return mCampaignMaps; } 

//////////////////////
// Functions
/////////////////////

function PostBeginPlay()
{
	;

	super.PostBeginPlay();

	// Report for duty
	if(H7CouncilGameInfo(WorldInfo.Game) != none) // We are in council
	{
		mCouncilGameInfo = H7CouncilGameInfo(WorldInfo.Game);
		mCouncilGameInfo.GetCouncilManager().SetMapManager(self);
	}
	else if(H7AdventureMapInfo(WorldInfo.Game) != none) // We are on adventure map
	{
		mAdventureGameInfo = H7AdventureMapInfo(WorldInfo.Game);
		
		if(class'H7AdventureController'.static.GetInstance() != none)
		{
			class'H7AdventureController'.static.GetInstance().SetCouncilMapManager(self);
		}
	}


	// If we were activated prepare for action
	if(mCouncilGameInfo != none || mAdventureGameInfo != none)
	{
		mPlayerProfile = class'H7PlayerProfile'.static.GetInstance();

		FindAllCampaignFlags();

		UpdateMap();
	}
	
	DeactivateMap();
}

function ActivateMap()
{
	mIsActive = true;

	ShowAllUnlockedFlags();

	if(mPlayerProfile.GetCurrentCampaign().CampaignRef != none)
	{
		// Get last played campaign from profile for start
		ChangeSelectedCampaign(mPlayerProfile.GetCurrentCampaign().CampaignRef);
	}

	mSelectedFlagIndex = GetFlagIndexByMapName(mPlayerProfile.GetCurrentCampaign().CurrentMap.MapFileName);

	SelectFlag( mCampaignMaps[mSelectedCampaignIndex].campaignFlags[mSelectedFlagIndex]);

	if(class'H7AdventureController'.static.GetInstance() == none)
	{
		PlayCouncillorSelectedVoiceOver(mCampaignMaps[mSelectedCampaignIndex].campaignFlags[mSelectedFlagIndex].GetCampaign());
	}
}

function DeactivateMap()
{
	mIsActive = false;

	class'H7SoundController'.static.PlayGlobalAkEvent(class'H7SoundController'.static.GetInstance().GetVoiceOverStopAllEvent(),true);

	DeactivateFlagEffects();
}

function UpdateMap()
{
	ShowAllUnlockedFlags();
}


// Create CouncilMapManager to handle all of this stuff
function FindAllCampaignFlags()
{
	local array<H7CouncilFlagActor> mapFlags;
	local H7CouncilFlagActor flag;

	foreach WorldInfo.DynamicActors( class'H7CouncilFlagActor', flag)
	{
		mapFlags.AddItem(flag);
	}


	SortFlags(mapFlags, mCampaignMaps);
}

function SortFlags( array<H7CouncilFlagActor> flags, out array<CampaignsMapData> campaignInfo)
{
	local bool hasCampaign;
	local int i, j;
	local int campaignIndex;
	local CampaignsMapData tempData;

	hasCampaign = false;

	for( j = 0; j < flags.Length; ++j)
	{
		for( i = 0; i < campaignInfo.Length; ++i )
		{
			if(campaignInfo[i].campaignDef == flags[j].GetCampaign())
			{
				hasCampaign = true;
				campaignIndex = i;
				break;
			}
		}

		if(hasCampaign)
		{
			campaignInfo[campaignIndex].campaignFlags.AddItem(flags[j]);

			hasCampaign = false;
			campaignIndex = 0;
		}
		else // Flag for not added campaign
		{
			tempData.campaignFlags.Length = 0;

			tempData.campaignDef = flags[j].GetCampaign();
			tempData.campaignFlags.AddItem(flags[j]);

			campaignInfo.AddItem(tempData);

			hasCampaign = false;
			campaignIndex = 0;
		}
	}
}

// Hide/Unhide relevant flags
function ShowAllUnlockedFlags()
{
	local int i, j;

	if(mPlayerProfile == none)
	{
		return;
	}
	
	for( i = 0; i < mCampaignMaps.Length; ++i)
	{
		// Check if campaign was ever played
		if(!mPlayerProfile.IsCampaignEverStarted(mCampaignMaps[i].campaignDef) ) // Campaign wasn't started
		{
			// If campaign wasn't even started hide all flags
			for( j = 0; j < mCampaignMaps[i].campaignFlags.Length; ++j )
			{
				if(mCampaignMaps[i].campaignFlags[j].IsFirstMap() ) // @TODO check if owners UplayIds have this campaign
				{
					if(class'H7PlayerProfile'.static.GetInstance() != none && mCampaignMaps[i].campaignFlags[j].GetCampaign().IsIvanCampaign())
					{
						if( class'H7PlayerProfile'.static.GetInstance().GetNumCompletedCampaigns() >= 2 )
						{
							mCampaignMaps[i].campaignFlags[j].Show();
						}
						else
						{
							mCampaignMaps[i].campaignFlags[j].Hide();
						}
					}
					else
					{
						mCampaignMaps[i].campaignFlags[j].Show();
					}
					
				}
				else
				{
					mCampaignMaps[i].campaignFlags[j].Hide();
				}

				
			}
		}
		else // Campaign was played
		{
			for( j = 0; j < mCampaignMaps[i].campaignFlags.Length; ++j )
			{
				// Show only completed/in_progress flags
				if(mPlayerProfile.WasMapPlayed( mCampaignMaps[i].campaignFlags[j].GetCampaign(), mCampaignMaps[i].campaignFlags[j].GetMapName() ) )
				{
					mCampaignMaps[i].campaignFlags[j].Show();
				}
				else
				{
					mCampaignMaps[i].campaignFlags[j].Hide();
				}
			}
		}   
	}
	
}

function GetUnlockedMapsName(out array<string> mapsName)
{
	local int i, j;

	for( i = 0; i < mCampaignMaps.Length; ++i)
	{
		for( j = 0; j < mCampaignMaps[i].campaignFlags.Length; ++j )
		{
			if(!mCampaignMaps[i].campaignFlags[j].bHidden)
			{
				mapsName.AddItem(mCampaignMaps[i].campaignFlags[j].GetMapName());
			}
		}
	}
}

function string GetSelectedMapName()
{
	return mCampaignMaps[mSelectedCampaignIndex].campaignFlags[mSelectedFlagIndex].GetMapName();
}

function int GetCampaignIndex(H7CampaignDefinition campaignRef)
{
	local int i;

	for(i = 0; i < mCampaignMaps.Length; ++i)
	{
		if(mCampaignMaps[i].campaignDef == campaignRef)
		{
			return i;
		}
	}

	return 0;
}

function H7CouncilFlagActor GetFlagByMapName(string mapName)
{
	local int i, j;

	for( i = 0; i < mCampaignMaps.Length; ++i)
	{
		for( j = 0; j < mCampaignMaps[i].campaignFlags.Length; ++j )
		{
			if(Caps(mCampaignMaps[i].campaignFlags[j].GetMapName()) == Caps(mapName))
			{
				 return mCampaignMaps[i].campaignFlags[j];
			}
		}
	}

	return none;
}

function int GetFlagIndexByMapName(string mapName)
{
	local int j;

	for( j = 0; j < mCampaignMaps[mSelectedCampaignIndex].campaignFlags.Length; ++j )
	{
		if(mCampaignMaps[mSelectedCampaignIndex].campaignFlags[j].GetMapName() == mapName)
		{
			return j;
		}
	}

	return 0;
}

// Returns flag index inside CampaignsMapData struct of selected campaign
function int GetFlagIndex(Actor flagActor)
{
	local int j;

	for( j = 0; j < mCampaignMaps[mSelectedCampaignIndex].campaignFlags.Length; ++j )
	{
		if(mCampaignMaps[mSelectedCampaignIndex].campaignFlags[j] == flagActor)
		{
			return j;
		}
	}

	return 0;
}

function ChangeSelectedCampaign(H7CampaignDefinition campaignRef)
{
	mSelectedCampaignIndex = GetCampaignIndex(campaignRef);

	if(class'H7AdventureController'.static.GetInstance() == none)
	{
		PlayCouncillorSelectedVoiceOver(campaignRef);
	}

	SelectCampaignFlags(mCampaignMaps[mSelectedCampaignIndex].campaignDef);
}

function PlayCouncillorSelectedVoiceOver(H7CampaignDefinition campaignRef)
{
	local H7CouncilManager councilManager;
	local Array <CouncillorData> dataArray;
	local CouncillorData data;
	local AkEvent currentVoiceOver;
	local int i;

	if(mCouncilPlayerController == none)
	{
		mCouncilPlayerController = H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController());
	}

	if(mCouncilPlayerController == none)
	{
		return;
	}

	class'H7SoundController'.static.PlayGlobalAkEvent( class'H7SoundController'.static.GetInstance().GetVoiceOverStopAllEvent(), true );

	councilManager = mCouncilPlayerController.GetCouncilManager();
	dataArray = councilManager.GetCouncilMemeber();

	for(i = 0; i < dataArray.Length; i++)
	{
		if(dataArray[i].councillorCampaign == campaignRef)
		{
			data = dataArray[i];
			//Set the current councillor info so it is up to date
			councilManager.SetCurrentCouncillorInfo(data);
			break;
		}
	}

	if(!data.isIvan)
	{
		// Playing the Councillor Selected AkEvent, when the Player selects the Actor
		currentVoiceOver = mCouncilPlayerController.GetProgressDependantCouncillorAkEvent(data);
	}
	else
	{
		currentVoiceOver = mCouncilPlayerController.GetGameProgressDependantIvanVoiceOver(data);
	}
					
	if(currentVoiceOver != none)
	{
		class'H7SoundController'.static.PlayGlobalAkEvent(currentVoiceOver,true);
	}
}

function SelectCampaignFlags(H7CampaignDefinition campaignRef)
{
	local int i, j;
	local bool select;

	for( i = 0; i < mCampaignMaps.Length; ++i)
	{
		select = false;

		if(campaignRef == mCampaignMaps[i].campaignDef)
		{
			select = true;
		}

		for( j = 0; j < mCampaignMaps[i].campaignFlags.Length; ++j )
		{
			if(select)
			{
				mCampaignMaps[i].campaignFlags[j].StaticMeshComponent.SetOutlineColor(mCampaignMaps[i].campaignFlags[j].GetCampaign().GetFaction().GetColor());
				mCampaignMaps[i].campaignFlags[j].StaticMeshComponent.SetOutlined(true);
			}
			else
			{
				mCampaignMaps[i].campaignFlags[j].StaticMeshComponent.SetOutlined(false);
			}
		}

	}
}

function SelectFlag(H7CouncilFlagActor testActor,optional bool sendEventToGUI = true)
{
	if(testActor == none)
	{
		return;
	}

	// Check if selected flag is of same campaign as currently selected
	if(testActor.GetCampaign() != mCampaignMaps[mSelectedCampaignIndex].campaignDef)
	{
		// If not change current campaign
		ChangeSelectedCampaign(testActor.GetCampaign());

		mSelectedFlagIndex = GetFlagIndex(testActor);

		mCampaignMaps[mSelectedCampaignIndex].campaignFlags[mSelectedFlagIndex].EnableOutline(mSelectedHighlight);
	}
	else // Same campaign
	{
		mCampaignMaps[mSelectedCampaignIndex].campaignFlags[mSelectedFlagIndex].EnableOutline(mCampaignMaps[mSelectedCampaignIndex].campaignFlags[mSelectedFlagIndex].GetCampaign().GetFaction().GetColor());

		mSelectedFlagIndex = GetFlagIndex(testActor);

		mCampaignMaps[mSelectedCampaignIndex].campaignFlags[mSelectedFlagIndex].EnableOutline(mSelectedHighlight);

	}

	if(sendEventToGUI) 
	{
		if(mCouncilGameInfo != none)
		{
			class'H7PlayerProfile'.static.GetInstance().SetSelectedDifficulty(class'H7PlayerProfile'.static.GetInstance().GetCampaignMapData(GetSelectedMapName()).HighestDifficulty);
		}
		
		class'H7DialogCntl'.static.GetInstance().DisplayMap(GetSelectedMapName());
	}
}


function DeactivateFlagEffects()
{
	local int i, j;

	for( i = 0; i < mCampaignMaps.Length; ++i)
	{
		for( j = 0; j < mCampaignMaps[i].campaignFlags.Length; ++j )
		{
			mCampaignMaps[i].campaignFlags[j].DisableOutline();
			mCampaignMaps[i].campaignFlags[j].SetCollisionType(COLLIDE_NoCollision);
		}
	}
}
