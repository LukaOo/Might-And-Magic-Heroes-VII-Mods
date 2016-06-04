//=============================================================================
// SaveGameStateInterface: Interface which allows actors to be serialized and
// deserialized using SaveGameState
//
// This interface is scanned for when the SaveGameState object wants to 
// serialize the world actors. Only actors that implement this interface will
// be serialized and deserialized.
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface SaveGameStateInterface;

function bool IsMarkedForDeletion();

function MarkForDeletion(bool val);

/**
 * Serializes the actor's data into JSon
 *
 * @return		JSon data representing the state of this actor
 */
function String Serialize();

/**
 * Deserializes the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data);

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame);
