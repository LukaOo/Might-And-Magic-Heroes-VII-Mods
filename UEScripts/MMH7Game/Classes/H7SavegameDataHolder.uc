class H7SavegameDataHolder extends Object
	dependson(H7StructsAndEnums)
	native(Core); 

struct native H7SavegameData
{
	// unique savegame only data
	var savegame init string                        mName; // savegame name "The one where I am winning" (NOT the filename (if we want to separate it))
	var savegame int                                mSaveTimeUnix; // time in (fake) unix int
	var savegame init string                        mSaveTime; // time in human-readable string
	var savegame ESaveType                          mSaveType;
	var savegame int                                mSaveGameCheckSum;

	// data copy from Lobby/TransitionData/State of the game
	var savegame EGameMode                          mGameMode;
	var savegame int                                mTurnCounter;
	var savegame init string                        mCampaignID; // archetype name
	var savegame H7LobbyDataMapSettings             mMapSettings; // for when we create a lobby from it
	var savegame H7LobbyDataGameSettings            mGameSettings; // for when we create a lobby from it
	var savegame init array<PlayerLobbySelectedSettings> mPlayersSettings; // for when we create a lobby from it, to know the names
	
	// data copy from Map/mapinfo/mapheader
	var savegame init string                        mMapFilePath; // file path to the map "folder/filename.umap"
	var savegame init string                        mMapFileName; // file name to a map file (*.umap)
	var savegame EMapType                           mMapType;
	var savegame init string                        mMapInfo; // name of the object in the map that contains the mapname and description (used in loca key)
	var savegame init string                        mMapName; // copy of the hardcoded entry the map maker put into [map].mName (used if loca fails)

	var savegame int                                mEnding; // the struct get memory corrupted during serialization if it ends by a string

	structcpptext
	{
		FH7SavegameData()
		{
		}
		FH7SavegameData(EEventParm)
		{
			this->Init();
		}

#if _DEBUG
	#define CUSTOM_INLINING		FORCENOINLINE		// Used to allow breakpointing in debug
#else
	#define CUSTOM_INLINING
#endif

		CUSTOM_INLINING void Init()
		{
			appMemZero<FH7SavegameData>(*this);
		}

		CUSTOM_INLINING void SerializeData(const UStructProperty* structProp, FArchive& Ar)
		{
			structProp->SerializeItem(Ar, (BYTE*)this, 0, NULL);
		}

		CUSTOM_INLINING void CopyFrom(const UStructProperty* structProp, const FH7SavegameData& other)
		{
			structProp->CopyCompleteValue( (BYTE*)this, (BYTE*)(&other) );
		}

		CUSTOM_INLINING void Reset(const UStructProperty* structProp)
		{
			structProp->ClearValue( (BYTE*)this );
		}
	
#undef CUSTOM_INLINING
	}
};

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

