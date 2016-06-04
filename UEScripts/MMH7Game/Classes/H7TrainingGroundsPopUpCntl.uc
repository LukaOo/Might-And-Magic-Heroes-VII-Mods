//=============================================================================
// H7TrainingGroundsPopUpCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7TrainingGroundsPopUpCntl extends H7FlashMovieBlockPopupCntl; 

var protected H7GFxTrainingGroundsPopUp mTrainingGroundsPopup;
var protected H7GFxArmyRow mArmyRow;

var protected H7TrainingGrounds mGrounds;
var protected H7AdventureArmy mVisitingArmy;

var protected int mCreatureIndexToDismiss;

function H7GFxTrainingGroundsPopUp GetTrainingGroundsPopup() {return mTrainingGroundsPopup;}
function H7GFxUIContainer GetPopup()            {return mTrainingGroundsPopup;}

function bool Initialize()
{
	;
	Super.Start();
	AdvanceDebug(0);

	mTrainingGroundsPopup = H7GFxTrainingGroundsPopUp(mRootMC.GetObject("aTrainingGroundsPopUp", class'H7GFxTrainingGroundsPopUp'));
	mArmyRow = H7GFxArmyRow(mTrainingGroundsPopup.GetObject("mArmyRow", class'H7GFxArmyRow'));

	mTrainingGroundsPopUp.SetVisibleSave(false);

	Super.Initialize();
	return true;
}

function RemoveItemIconFromCursor()
{
	if(GetPopup().IsVisible())
	{
		class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithItem();
	}
}

function Update(H7TrainingGrounds grounds, H7AdventureArmy army)
{
	mGrounds = grounds;
	mVisitingArmy = army;
	mArmyRow.Update(army);
	mTrainingGroundsPopup.Update(grounds, army);
	OpenPopup();
}

function UpgradeCreature(int slotID, bool isVisitor, int count)
{
	;

	mGrounds.UpgradeUnit(slotID, isVisitor, count);
	GetPopup().Reset();
	Update(mGrounds, mVisitingArmy);
}

////////////////////ARMY ROW////////////////////////////////////////

function RequestTransfer(int fromArmy,int fromIndex,int toArmy,int toIndex,optional int splitAmount)
{
	// index defines slot number, can be -1 if units are being split, because then there is no dropSlot set
	if( toIndex != -1 && splitAmount == 0 )
	{
		class'H7EditorArmy'.static.TransferCreatureStacksByArmy( mVisitingArmy, mVisitingArmy, mVisitingArmy, fromIndex, toIndex);
	}
	else
	{
		class'H7EditorArmy'.static.SplitCreatureStackToEmptySlot( mVisitingArmy, mVisitingArmy, fromIndex, splitAmount, toIndex );
	}
	
	// Remove unit icon from cursor
	class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack();
}

function CompleteTransfer(bool success, int toIndex)
{
	mArmyRow.TransferResult(success,false,toIndex);
	Update(mGrounds, mVisitingArmy);
}

function DismissStack(int unitIndex,optional int armyIndex)
{
	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;

	mCreatureIndexToDismiss = unitIndex;
	GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("REALLY_DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("CANCEL","H7General"),DismissConfirm, DismissDenied);
}

function DismissConfirm()
{
	mVisitingArmy.RemoveCreatureStackByIndex(mCreatureIndexToDismiss);
	Update(mGrounds, mVisitingArmy);
}

function DismissDenied()
{
	mCreatureIndexToDismiss = -1;
}

function AddUnitIconToCursor(int slotID)
{
	local array<H7BaseCreatureStack> stacks;
	mIsDragginUnit = true;
	stacks = mVisitingArmy.GetBaseCreatureStacks();
	class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack(stacks[slotID]);
}

function RemoveUnitFromCursor()
{
	mIsDragginUnit = false;
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
	GetHUD().UnLoadCursorObject();
}


function Closed()
{
	ClosePopup();
	
	mGrounds = none;
	mVisitingArmy = none;
}

