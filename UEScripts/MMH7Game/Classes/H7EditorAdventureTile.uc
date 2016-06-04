//=============================================================================
// H7EditorAdventureTile
//=============================================================================
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorAdventureTile extends H7BaseCell
	dependson(H7VisitableSite)
	native;

// Gameplay data
var() privatewrite ECellMovementType mMovementType; // Computed by the landscape scanner, overriden by Passability painting
var() private H7AdventureLayerCellProperty mSourceLayerCellData; // Defined on save, computed by what's painted
var() private string mForcedCombatMapLine; // Painted (empty if no combat map painted, can contains multiple seperated by a comma)
var() float mCameraHeight; // Computed by the grid at save, twaeked by the camera volumes
var() int mAreaOfControl; // Painted
var() bool IsShoreTile; // Computed by the scanner, calculated at save
var() bool IsWet; // Computed by the scanner
var() H7VisitableSite mVisitableSite; // computed by the grid at save
var() H7TargetableSite mTargetableSite; // computed by the grid at save
var() H7IDefendable mDefendableSiteOnTop; // computed by the grid at save
var() array<H7IAdventureMapCellInteractor> mInteractorList; // computed by the grid at save
var() bool IsAoCBorder; // computed by the grid on save
var() EFoWOverrideState mFoWOverrideState; // painted information

// Purely editor data
var() editoronly int CombatListLayerInfoIndex; // 0 = none, 1+ = combat list index stored in landscape
var() editoronly int BlockingOverridenStatus; // TODO: bind it to an enum instead of an int



/////////////////////////
// Movement Cost

function H7AdventureLayerCellProperty GetSourceLayerCellData()
{
	return mSourceLayerCellData;
}

native function float GetMovementCost();
native function SetMovementType(ECellMovementType mNewMovementType);

/////////////////////////
// Cell Layer Data

native function SetNewLayerData(H7AdventureLayerCellProperty newCellLayerData);

/////////////////////////
// Combat Map

function string PickAppropriateCombatMap()
{
	if (Len(mForcedCombatMapLine) > 0)
	{
		return PickRandomStringFromLine(mForcedCombatMapLine);
	}

	if (IsWet && mSourceLayerCellData.mWetCombatMapList.Length > 0)
	{
		return PickRandomStringFromArray(mSourceLayerCellData.mWetCombatMapList);
	}

	if (mSourceLayerCellData.mCombatMapList.Length <= 0)
	{
		;
		return "";
	}

	return PickRandomStringFromArray(mSourceLayerCellData.mCombatMapList);
}

function string PickRandomStringFromLine(string inputline)
{
	return PickRandomStringFromArray( SplitString(inputline, ";", true) );
}

function string PickRandomStringFromArray(array<string> inArray)
{
	return inArray[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(inArray.Length) ];
}
