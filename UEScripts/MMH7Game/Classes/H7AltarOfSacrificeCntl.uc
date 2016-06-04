//=============================================================================
// H7AltarOfSacrificeCntl
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AltarOfSacrificeCntl extends H7FlashMovieTownPopupCntl
	dependson(H7StructsAndEnumsNative);

var protected H7GFxAltarOfSacrifice mAltarOfSacrificePopUp;

var H7TownUnitConverter mAltarOfSacrifice;
var H7BaseCreatureStack mDraggedStack;
var int mFirstDraggedStackOriginalSize;
var array<int> mDraggedStackIndicesGarrison;
var array<int> mDraggedStackIndicesVisiting;
var bool mergedCreatures;
var bool mergedCreaturesConverted;
var bool firstStackIsGarrison;

static function H7AltarOfSacrificeCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAltarOfSacrificeCntl(); }
function H7GFxAltarOfSacrifice GetAltarOfSacrifice() {return mAltarOfSacrificePopUp;}

function bool Initialize()
{
	;
	//Super.Start();
	//AdvanceDebug(0);
	//LoadComplete();
	//Super.Initialize();

	LinkToTownPopupContainer();

	return true;
}

function LoadComplete()
{
	mAltarOfSacrificePopUp = H7GFxAltarOfSacrifice(mRootMC.GetObject("aAltarOfSacrifice", class'H7GFxAltarOfSacrifice'));
	mAltarOfSacrificePopUp.SetVisibleSave(false);
}

function Update(H7Town town)
{
	mTown = town;
	mAltarOfSacrifice = H7TownUnitConverter( mTown.GetBuildingByType(class'H7TownUnitConverter'));

 	if( mTown.IsBuildingBuilt(mAltarOfSacrifice.GetUpgradedDwelling()) )
		mAltarOfSacrificePopUp.Update(mAltarOfSacrifice.GetUpgradedCreature());
	else
		mAltarOfSacrificePopUp.Update(mAltarOfSacrifice.GetBaseCreature());
	
	OpenPopup();
}

function SlotToSacrificeMouseIsUp()
{
	local H7BaseCreatureStack draggedStack;

	draggedStack = H7AdventureHud(GetHUD()).GetTownHudCntl().GetDraggedStack();

	if(draggedStack == none) return;
	
	//can not convert creatures available in the altar of sacrifice
	if(draggedStack.GetStackType() == mAltarOfSacrifice.GetBaseCreature() ||
		draggedStack.GetStackType() == mAltarOfSacrifice.GetUpgradedCreature())
		return;
		
	if(!mAltarOfSacrifice.CanConvert(draggedStack.GetStackType()))
		return;

	if(mDraggedStack != none) 
	{	
		if(mDraggedStack.GetStackType() == draggedStack.GetStackType())
		{
			mDraggedStack.SetStackSize( mDraggedStack.GetStackSize() + draggedStack.GetStackSize() );
			mAltarOfSacrificePopUp.UpdateWithUnitToSacrifice(mDraggedStack, mAltarOfSacrifice.GetConvertedCreatureAmount(mDraggedStack), mAltarOfSacrifice.GetConvertingCost(mDraggedStack));		
			H7AdventureHud(GetHUD()).GetTownHudCntl().SetDraggedSlotInUse();
			
			if(H7AdventureHud(GetHUD()).GetTownHudCntl().GetDraggedStackArmyNr() == ARMY_NUMBER_GARRISON) 
				mDraggedStackIndicesGarrison.AddItem(H7AdventureHud(GetHUD()).GetTownHudCntl().GetDraggedStackIndex());
			else
				mDraggedStackIndicesVisiting.AddItem(H7AdventureHud(GetHUD()).GetTownHudCntl().GetDraggedStackIndex());
			
			mergedCreatures = true;
			return;
		}
		else
		{
			H7AdventureHud(GetHUD()).GetTownHudCntl().SetDraggedSlotUnused();
			mDraggedStack.SetStackSize(mFirstDraggedStackOriginalSize);
			mergedCreatures = false;
		}
	}
	mDraggedStackIndicesVisiting.Length = 0;
	mDraggedStackIndicesGarrison.Length = 0;
	mDraggedStack = draggedStack;
	mFirstDraggedStackOriginalSize = mDraggedStack.GetStackSize();
	mAltarOfSacrificePopUp.UpdateWithUnitToSacrifice(draggedStack, mAltarOfSacrifice.GetConvertedCreatureAmount(draggedStack), mAltarOfSacrifice.GetConvertingCost(draggedStack));		
		
	if(H7AdventureHud(GetHUD()).GetTownHudCntl().GetDraggedStackArmyNr() == ARMY_NUMBER_GARRISON) 
	{
		firstStackIsGarrison = true;
		mDraggedStackIndicesGarrison.AddItem(H7AdventureHud(GetHUD()).GetTownHudCntl().GetDraggedStackIndex());
	}
	else
	{
		firstStackIsGarrison = false;
		mDraggedStackIndicesVisiting.AddItem(H7AdventureHud(GetHUD()).GetTownHudCntl().GetDraggedStackIndex());
	}

	mergedCreatures = false;
	mergedCreaturesConverted = false;
	H7AdventureHud(GetHUD()).GetTownHudCntl().SetDraggedSlotInUse();
}

function BtnSacrificeClicked()
{
	local H7InstantCommandSacrifice command;

	mDraggedStack.SetStackSize(mFirstDraggedStackOriginalSize);

	command = new class'H7InstantCommandSacrifice';
	command.Init(mTown, mDraggedStackIndicesGarrison, mDraggedStackIndicesVisiting, firstStackIsGarrison);
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand(command);

	if(mergedCreatures) mergedCreaturesConverted = true;
	mDraggedStack = none;

	if( mTown.IsBuildingBuilt(mAltarOfSacrifice.GetUpgradedDwelling()) )
		mAltarOfSacrificePopUp.Update(mAltarOfSacrifice.GetUpgradedCreature());
	else
		mAltarOfSacrificePopUp.Update(mAltarOfSacrifice.GetBaseCreature());
}

function H7GFxUIContainer GetPopup()
{
	return mAltarOfSacrificePopUp;
}

function ClosePopUp()
{
	super.ClosePopup();
	if(mergedCreatures && !mergedCreaturesConverted) mDraggedStack.SetStackSize(mFirstDraggedStackOriginalSize);
	mFirstDraggedStackOriginalSize = 0;
	mDraggedStack = none;
	mDraggedStackIndicesGarrison.Length = 0;
	mDraggedStackIndicesVisiting.Length = 0;
	H7AdventureHud(GetHUD()).GetTownHudCntl().SetDraggedSlotUnused();
	mergedCreatures = false;
	mergedCreaturesConverted = false;
}
	
