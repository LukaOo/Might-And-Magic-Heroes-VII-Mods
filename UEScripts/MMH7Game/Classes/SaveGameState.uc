//=============================================================================
// SaveGameState: Object which handles loading and saving of the game state
//
// This object can be instanced to then perform saving of the world. It can 
// also be instanced, loaded using BasicLoadObject and then loading the game
// state can occur.
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class SaveGameState extends Object;

// SaveGameState revision number
const SAVEGAMESTATE_REVISION = 1;
// File name of the map that this save game state is associated with
var string PersistentMapFileName;
// Game info that this save game state is associated with
var string GameInfoClassName;
// File names of the streaming maps that this save game state is associated with
var protected array<string> StreamingMapFileNames;
// Serialized world data
var protected array<String> SerializedWorldData;

// Infos about the save game (to display in GUI)
var String mSaveGameInfoJSON; // serialized version of H7SaveGameInfoActor // the savegame header

// Deserialize references system
struct DeserializeData
{
	var JsonObject JsonObj;
	var SaveGameStateInterface ActorInterface;
};
var protected array<DeserializeData> mActorsToDeserializeReferences;

// Deserialize Kismet
struct KismetDeserializeData
{
	var JsonObject JsonObj;
	var string KismetObjectName;
};
var protected array<KismetDeserializeData> mKismetObjectsToDeserialize;

// ARRAYS USED FOR THE LOAD/SAFE REFERENCE SYSTEM
var protected array<H7AdventureHero>	mHeroes;
var protected array<H7Player>			mPlayers;
var protected array<H7VisitableSite>	mVisitableSites;

/**
 * Saves the game state by serializing all of the actors that implement the SaveGameStateInterface, Kismet and Matinee.
 */
function SerializeEverything() // DEPRECATED
{
	local WorldInfo WorldInfo;
	local Actor Actor;
	local String SerializedActorData;
	local SaveGameStateInterface currentSaveInterface;
	local int i;

	// Get the world info, abort if the world info could not be found
	WorldInfo = class'WorldInfo'.static.GetWorldInfo();
	if (WorldInfo == None)
	{
		return;
	}

	// Save the persistent map file name
	PersistentMapFileName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();
	PersistentMapFileName = class'H7Loca'.static.GetMapFileName(PersistentMapFileName);

	// Save the currently streamed in map file names
	if (WorldInfo.StreamingLevels.Length > 0)
	{
		// Iterate through the streaming levels
		for (i = 0; i < WorldInfo.StreamingLevels.Length; ++i)
		{
			// Levels that are visible and has a load request pending should be included in the streaming levels list
			if (WorldInfo.StreamingLevels[i] != None && (WorldInfo.StreamingLevels[i].bIsVisible || WorldInfo.StreamingLevels[i].bHasLoadRequestPending))
			{				
				StreamingMapFileNames.AddItem(String(WorldInfo.StreamingLevels[i].PackageName));
			}
		}
	}

	// Save the game info class 
	GameInfoClassName = PathName(WorldInfo.Game.Class);

	// Iterate through all of the actors that implement SaveGameStateInterface and ask them to serialize themselves
	ForEach WorldInfo.DynamicActors(class'Actor', Actor, class'SaveGameStateInterface')
	{
		// Type cast to the SaveGameStateInterface
		currentSaveInterface = SaveGameStateInterface(Actor);
		if (currentSaveInterface != None)
		{
			;
			// Serialize the actor
			SerializedActorData = currentSaveInterface.Serialize();
			;
			// If the serialzed actor data is valid, then add it to the serialized world data array
			if (SerializedActorData != "")
			{
				SerializedWorldData.AddItem(SerializedActorData);
				//if(H7SaveGameInfoActor(Actor) != none)
				//{
				//	`log_loadsave("found savegameinfo actor and saving shortcut");
				//	mSaveGameInfoJSON = SerializedActorData;
				//}
			}
		}
	}

	// Serialize Matinee
	SerializeMatineeState();
}

/**
 * Saves the Matinee game state
 */
protected function SerializeMatineeState()
{
	local WorldInfo WorldInfo;
	local array<Sequence> RootSequences;
	local array<SequenceObject> SequenceObjects;
	local SeqAct_Interp SeqAct_Interp;
	local int i, j;
	local JSonObject JSonObject;

	// Get the world info, abort if it does not exist
	WorldInfo = class'WorldInfo'.static.GetWorldInfo();
	if (WorldInfo == None)
	{
		return;
	}

	// Get all of the root sequences within the world, abort if there are no root sequences
	RootSequences = WorldInfo.GetAllRootSequences();
	if (RootSequences.Length <= 0)
	{
		return;
	}
	
	// Serialize all SequenceEvents and SequenceVariables
	for (i = 0; i < RootSequences.Length; ++i)
	{
		if (RootSequences[i] != None)
		{
			// Serialize Matinee Kismet Sequence Actions
			RootSequences[i].FindSeqObjectsByClass(class'SeqAct_Interp', true, SequenceObjects);
			if (SequenceObjects.Length > 0)
			{
				for (j = 0; j < SequenceObjects.Length; ++j)
				{
					SeqAct_Interp = SeqAct_Interp(SequenceObjects[j]);
					if (SeqAct_Interp != None)
					{
						// Attempt to serialize the data
						JSonObject = new () class'JSonObject';
						if (JSonObject != None)
						{
							// Save the path name of the SeqAct_Interp so it can found later
							JSonObject.SetStringValue("Name", PathName(SeqAct_Interp));
							// Save the current position of the SeqAct_Interp
							JSonObject.SetFloatValue("Position", SeqAct_Interp.Position);
							// Save if the SeqAct_Interp is playing or not
							JSonObject.SetIntValue("IsPlaying", (SeqAct_Interp.bIsPlaying) ? 1 : 0);
							// Save if the SeqAct_Interp is paused or not
							JSonObject.SetIntValue("Paused", (SeqAct_Interp.bPaused) ? 1 : 0);
							// Encode this and append it to the save game data array
							SerializedWorldData.AddItem(class'JSonObject'.static.EncodeJson(JSonObject));
						}
					}
				}
			}
		}
	}
}

/**
 * Loads the game state by deserializing all of the serialized data and applying the data to the actors that implement the SaveGameStateInterface, Kisment and Matinee.
 */
function LoadGameState( H7AdventureController adventureController, H7ScriptingController scriptController )
{
	local WorldInfo theWorldInfo;
	local int i;
	local JSonObject aJSonObject;
	local String objectName;
	local SaveGameStateInterface aSaveGameStateInterface;
	local Actor anActor, actorArchetype, currentActor;
	local DeserializeData currentDeserializeData;
	local KismetDeserializeData currentKismetDeserializeData;
	
	// No serialized world data to load!
	if (SerializedWorldData.Length <= 0)
	{
		return;
	}

	// Grab the world info, abort if no valid world info
	theWorldInfo = class'WorldInfo'.static.GetWorldInfo();
	if (theWorldInfo == None)
	{
		return;
	}

	;

	// For each serialized data object
	for (i = 0; i < SerializedWorldData.Length; ++i)
	{
		if (SerializedWorldData[i] != "")
		{
			// Decode the JSonObject from the encoded string
			aJSonObject = class'JSonObject'.static.DecodeJson(SerializedWorldData[i]);
			if (aJSonObject != None)
			{
				// Get the object name
				objectName = aJSonObject.GetStringValue("Name");
				// Check if the object name contains SeqAct_Interp, if so deserialize Matinee
				if (InStr(objectName, "SeqAct_Interp",, true) != INDEX_NONE)
				{
					LoadMatineeState(objectName, aJSonObject);
				}
				// Check if the object name contains SeqEvent or SeqVar, if so deserialize Kismet
				else if (IsKismetObjectName(objectName) )
				{
					currentKismetDeserializeData.JsonObj = aJSonObject;
					currentKismetDeserializeData.KismetObjectName = objectName;
					mKismetObjectsToDeserialize.AddItem(currentKismetDeserializeData);
				}
				else if( objectName == "AdventureController" )
				{
					currentDeserializeData.JsonObj = aJSonObject;
					currentDeserializeData.ActorInterface = SaveGameStateInterface(adventureController);
					mActorsToDeserializeReferences.AddItem( currentDeserializeData );
					//adventureController.Deserialize( aJSonObject );
				}
				// Otherwise it is some other type of actor
				else
				{
					// Try to find the persistent level actor
					anActor = Actor(FindObject(objectName, class'Actor'));

					// If the actor was not in the persistent level, then it must have been transient then attempt to spawn it
					if (anActor == None)
					{
						// Spawn the actor
						actorArchetype = GetActorArchetypeFromName(aJSonObject.GetStringValue("ObjectArchetype"));
						if (actorArchetype != None)
						{
							anActor = theWorldInfo.Spawn(actorArchetype.Class,,,,, actorArchetype, true);
							;
						}
					}

					if (anActor != None)
					{
						// Cast to the save game state interface
						aSaveGameStateInterface = SaveGameStateInterface(anActor);
						if (aSaveGameStateInterface != None)
						{
							// insert the actor to the array of actors
							currentDeserializeData.JsonObj = aJSonObject;
							currentDeserializeData.ActorInterface = aSaveGameStateInterface;
							mActorsToDeserializeReferences.AddItem( currentDeserializeData );

							// Deserialize the actor
							aSaveGameStateInterface.Deserialize(aJSonObject);
							aSaveGameStateInterface.MarkForDeletion(false);
							;
						}
					}
				}
			}
		}
	}

	// delete all marked actors
	foreach theWorldInfo.DynamicActors( class'Actor', currentActor, class'SaveGameStateInterface' )
	{
		;
		if( SaveGameStateInterface(currentActor).IsMarkedForDeletion() )
		{
			;
			currentActor.Destroy();
		}
	}

	// deserialize the references
	InitActorArrays();
	foreach mActorsToDeserializeReferences( currentDeserializeData )
	{
		currentDeserializeData.ActorInterface.DeserializeReferences( currentDeserializeData.JsonObj, self );
	}
	// clean arrays after usage
	ClearActorArrays();
	mActorsToDeserializeReferences.Length = 0;
	mKismetObjectsToDeserialize.Length = 0;
}

/**
 * Returns an actor archetype from the name
 *
 * @return		Returns an actor archetype from the string representation
 */
function Actor GetActorArchetypeFromName(string ObjectArchetypeName)
{
	local WorldInfo worldInfo;
	
	worldInfo = class'WorldInfo'.static.GetWorldInfo();
	if (worldInfo == None)
	{
		return None;
	}

	;

	// Use static look ups if on the console, for static look ups to work
	//  * Force cook the classes or packaged archetypes to the maps
	//  * Add packaged archetypes to the StartupPackage list
	//  * Reference the packages archetypes somewhere within Unrealscript
	if (worldInfo.IsConsoleBuild())
	{
		return Actor(FindObject(ObjectArchetypeName, class'Actor'));
	}
	else // Use dynamic look ups if on the PC
	{
		return Actor(DynamicLoadObject(ObjectArchetypeName, class'Actor'));
	}
}

function bool IsKismetObjectName(string objectName)
{
	return (InStr(objectName, "SeqEvent",, true) != INDEX_NONE || 
			InStr(ObjectName, "SeqCon",, true) != INDEX_NONE ||
			InStr(ObjectName, "SeqAct",, true) != INDEX_NONE ||
			InStr(ObjectName, "SeqVar",, true) != INDEX_NONE);
}

/**
 * Loads up the Matinee state based on the data
 *
 * @param		ObjectName		Name of the Matinee Kismet object
 * @param		Data			Saved Matinee Kismet data 
 */
function LoadMatineeState(string ObjectName, JSonObject Data)
{
	local SeqAct_Interp SeqAct_Interp;
	local float OldForceStartPosition;
	local bool OldbForceStartPos;

	// Find the matinee kismet object
	SeqAct_Interp = SeqAct_Interp(FindObject(ObjectName, class'Object'));
	if (SeqAct_Interp == None)
	{
		return;
	}
	
	if (Data.GetIntValue("IsPlaying") == 1)
	{
		OldForceStartPosition = SeqAct_Interp.ForceStartPosition;
		OldbForceStartPos = SeqAct_Interp.bForceStartPos;

		// Play the matinee at the forced position
		SeqAct_Interp.ForceStartPosition = Data.GetFloatValue("Position");
		SeqAct_Interp.bForceStartPos = true;
		SeqAct_Interp.ForceActivateInput(0);

		// Reset the start position and start pos
		SeqAct_Interp.ForceStartPosition = OldForceStartPosition;
		SeqAct_Interp.bForceStartPos = OldbForceStartPos;
	}
	else
	{
		// Set the position of the matinee
		SeqAct_Interp.SetPosition(Data.GetFloatValue("Position"), true);
	}

	// Set the paused 
	SeqAct_Interp.bPaused = (Data.GetIntValue("Paused") == 1);
}

protected function InitActorArrays()
{
	local Actor currentActor;

	foreach class'H7AdventureController'.static.GetWorldInfo().AllActors( class'Actor', currentActor )
	{
		if( H7AdventureHero(currentActor) != none )
		{
			mHeroes.AddItem( H7AdventureHero(currentActor) );
		}
		else if( H7Player(currentActor) != none )
		{
			mPlayers.AddItem( H7Player(currentActor) );
		}
		else if( H7VisitableSite(currentActor) != none )
		{
			mVisitableSites.AddItem( H7VisitableSite(currentActor) );
		}
	}

}

protected function ClearActorArrays()
{
	mHeroes.Length = 0;
	mPlayers.Length = 0;
	mVisitableSites.Length = 0;
}

function H7AdventureArmy GetArmyByHeroId( int heroId )
{
	local H7AdventureHero currentHero;

	if( heroId == -1 )
	{
		return none;
	}

	foreach mHeroes( currentHero )
	{
		if( currentHero.GetID() == heroId )
		{
			return currentHero.GetAdventureArmy();
		}
	}

	ScriptTrace();
	;
	return none;
}

function H7Player GetPlayerByNumber( EPlayerNumber playerNumber )
{
	local H7Player currentPlayer;

	foreach mPlayers( currentPlayer )
	{
		if( currentPlayer.GetPlayerNumber() == playerNumber )
		{
			return currentPlayer;
		}
	}

	ScriptTrace();
	;
	return none;
}

function H7VisitableSite GetVisitableSite( int siteId )
{
	local H7VisitableSite currentSite;

	if( siteId == -1 )
	{
		return none;
	}

	foreach mVisitableSites( currentSite )
	{
		if( currentSite.GetID() == siteId )
		{
			return currentSite;
		}
	}

	ScriptTrace();
	;
	return none;
}
