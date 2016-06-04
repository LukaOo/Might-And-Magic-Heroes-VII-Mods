/*=============================================================================
* H7FracturedWalkableObject
* =============================================================================
*  Done by the CCU. Handle with care!
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7FracturedWalkableObject extends H7GameplayFracturedMeshActor
	implements(H7WalkableInterface, SaveGameStateInterface, H7IAliasable, H7IThumbnailable)
	native
	placeable;

var(ScanOverride) editoronly PrimitiveComponent ScanOverride_Collider;
var(ScanOverride) editoronly H7AdventureLayerCellProperty ScanOverride_LayerCellModifier;

var protected bool				mLoadGameKeepAlive;

function bool IsMarkedForDeletion() { return !mLoadGameKeepAlive; }
function MarkForDeletion(bool val) { mLoadGameKeepAlive = !val; }

function native PrimitiveComponent GetScanOverrideCollider() const; //override H7WalkableInterface
function native H7AdventureLayerCellProperty GetScanOverrideModifier() const; //override H7WalkableInterface

simulated function PostBeginPlay()
{
	super.PostBeginPlay();

	Role = ROLE_Authority;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function String Serialize()
{
	local JSonObject JSonObject;
	
	if( mIsClone )
	{
		return "";
	}
	else
	{
		// Instance the JSonObject, abort if one could not be created
		JSonObject = new () class'JSonObject';
		if (JSonObject == None)
		{
			;
			return "";
		}

		// Serialize the path name so that it can be looked up later
		JSonObject.SetStringValue("Name", PathName(Self));

		// Serialize the object archetype, in case this needs to be spawned
		JSonObject.SetStringValue("ObjectArchetype", PathName(ObjectArchetype));

		// Save the state booleans
		JSonObject.SetBoolValue( "IsDestroying", mIsDestroying );
		JSonObject.SetBoolValue( "IsRepairing", mIsRepairing );
		JSonObject.SetBoolValue( "IsFractured", mIsFractured );
		JsonObject.SetBoolValue( "IsClone", mIsClone );
		
		// Send the encoded JSonObject
		return class'JSonObject'.static.EncodeJson(JSonObject);
	}
}

/**
 * Deserializes the actor from the data given
 *
 * @param    Data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data)
{
	mIsDestroying = Data.GetBoolValue( "IsDestroying" );
	mIsRepairing = Data.GetBoolValue( "IsRepairing" );
	mIsFractured = Data.GetBoolValue( "IsFractured" );
	mIsClone = Data.GetBoolValue( "IsClone" );
}

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame){}

