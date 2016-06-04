class H7HeroWindowCntl extends H7ItemSlotMovieCntl
	dependson(H7StructsAndEnumsNative);

var protected H7GFxHeroWindow mHeroWindow;
var protected H7GFxArmyRow mArmyRow;
var protected H7GFxWarfareUnitRow mWarfareUnitRow;
var protected H7GFxUIContainer mHeroInfo;

var protected H7AdventureArmy mCurrentArmy;
var protected int mHeroIDToDismiss;

var protected int mCreatureIndexToDismiss;

function    H7GFxHeroWindow     GetHeroWindow(){ return mHeroWindow; }
function    H7GFxUIContainer    GetPopup(){ return mHeroWindow; }

function bool Initialize()
{
	;
	Super.Start();

	AdvanceDebug(0);

	mHeroWindow = H7GFxHeroWindow(mRootMC.GetObject("aHeroWindow", class'H7GFxHeroWindow'));
	
	mHeroInfo = H7GFxUIContainer(mHeroWindow.GetObject("aHeroInfo", class'H7GFxUIContainer'));
	mInventory = H7GFxInventory(mHeroWindow.GetObject("aInventory", class'H7GFxInventory'));
	mHeroEquip = H7GFxHeroEquip(mHeroWindow.GetObject("aHeroEquip", class'H7GFxHeroEquip'));
	mArmyRow = H7GFxArmyRow(mHeroWindow.GetObject("aArmyRow", class'H7GFxArmyRow'));
	mWarfareUnitRow = H7GFxWarfareUnitRow(mHeroWindow.GetObject("aWarfareRow", class'H7GFxWarfareUnitRow'));
	

	//mCloseButton = GFxCLIKWidget(mHeroWindow.GetObject("mCloseButton", class'GFxCLIKWidget'));

	mHeroWindow.SetVisibleSave(false);

	cursorItemID = -1;

	Super.Initialize();
	return true;
}

function Update(int heroID)
{
	local H7HeroItem ring1;
	local array<H7HeroItem> items;
	;
	if(heroID == 0) return;
	OpenPopup();
	
	mCurrentArmy = class'H7AdventureController'.static.GetInstance().GetArmyByHeroID(heroID);
	mCurrentHero = mCurrentArmy.GetHero();
	mHeroWindow.Update(mCurrentArmy, mCurrentHero);
	class'H7AdventureController'.static.GetInstance().SelectArmy( mCurrentArmy );

	mInventory.Update(mCurrentHero.GetInventory().GetItems(),mCurrentHero);
	mCurrentHero.GetEquipment().GetItemsAsArray(items);
	if(mCurrentHero.GetEquipment().GetRing1() != none) ring1 = mCurrentHero.GetEquipment().GetRing1();
	mHeroEquip.Update( items, ring1, mCurrentHero );

	mInventory.ListenTo(mCurrentHero);
	mHeroEquip.ListenTo(mCurrentHero);
	
	mArmyRow.Update(mCurrentArmy);
	mWarfareUnitRow.Update(mCurrentArmy);
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(false);
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTownList().SetVisibleSave(false);
	mHeroWindow.SetVisibleSave(true);
}

function HeroClick(int id)
{
	mHeroWindow.Reset();
	Update(id);	
}

function btnDismissHeroClicked(int heroID)
{
	mHeroIDToDismiss = heroID;
	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup(class'H7Loca'.static.LocalizeSave("DO_YOU_WANT_TO_DISMISS_THIS_HERO","H7HeroWindow"), class'H7Loca'.static.LocalizeSave("PU_YES","H7PopUp"), class'H7Loca'.static.LocalizeSave("PU_NO","H7PopUp"), dismissHero, none);
}

function dismissHero()
{
	local H7InstantCommandDismissHero command;

	;

	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;

	command = new class'H7InstantCommandDismissHero';
	command.Init( class'H7AdventureController'.static.GetInstance().GetArmyByHeroID( mHeroIDToDismiss ).GetHero() );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	;
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true);
	mHeroWindow.SetVisibleSave(false);
	mHeroWindow.Reset();
	class'H7ListeningManager'.static.GetInstance().RemoveListener(mHeroWindow);
	class'H7ListeningManager'.static.GetInstance().RemoveListener(mInventory);
	class'H7ListeningManager'.static.GetInstance().RemoveListener(mHeroEquip);
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("CLOSE_HERO_SCREEN");
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetHeroHUD().SelectHeroByHero(class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero());
	H7AdventureHud(GetHUD()).GetAdventureHudCntl().GetTopBar().SetVisibleSave(true); 
	super.ClosePopup();
}

////////////////////ARMY ROW////////////////////////////////////////

function RequestTransfer(int fromArmy,int fromIndex,int toArmy,int toIndex,optional int splitAmount)
{
	// index defines slot number, can be -1 if units are being split, because then there is no dropSlot set
	if( toIndex != -1 && splitAmount == 0 )
	{
		class'H7EditorArmy'.static.TransferCreatureStacksByArmy( mCurrentArmy, mCurrentArmy, mCurrentArmy, fromIndex, toIndex);
	}
	else
	{
		class'H7EditorArmy'.static.SplitCreatureStackToEmptySlot( mCurrentArmy, mCurrentArmy, fromIndex, splitAmount, toIndex );
	}
	
	// Remove unit icon from cursor
	class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack();
}

function CompleteTransfer(bool success, int toIndex)
{
	mArmyRow.TransferResult(success,false,toIndex);
	mArmyRow.Update(mCurrentArmy);
}

function DismissStack(int unitIndex,optional int armyIndex)
{
	if(class'H7ReplicationInfo'.static.GetInstance().mIsTutorial) return;

	if( mCurrentArmy.GetBaseStackBySourceSlotId( unitIndex ).IsDismissDisabled() )
	{
		return;
	}

	mCreatureIndexToDismiss = unitIndex;
	GetHUD().GetRequestPopupCntl().GetRequestPopup().YesNoPopup( class'H7Loca'.static.LocalizeSave("REALLY_DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("DISMISS","H7General"),class'H7Loca'.static.LocalizeSave("CANCEL","H7General"),DismissConfirm, DismissDenied);
}

function DismissConfirm()
{
	mCurrentArmy.RemoveCreatureStackByIndex(mCreatureIndexToDismiss);
	mArmyRow.StackDismissed();
}

function DismissDenied()
{
	mCreatureIndexToDismiss = -1;
}

function RemoveUnitFromCursor()
{
	mIsDragginUnit = false;
	class'H7GUISoundPlayer'.static.GetInstance().PlaySoundStr("DROP");
	GetHUD().UnLoadCursorObject();
}

///////////////////STATS///////////////////////////////////////

function GetStatModSourceList(String statStr,int unrealID)
{
	local H7Unit unit;
	local EStat stat;
	local array<H7StatModSource> mods;
	local int i;

	;

	unit = mCurrentHero;

	for(i=0;i<=STAT_MAX;i++)
	{
		stat = EStat(i);
		if(String(stat) == statStr)
		{
			break;
		}
	}

	// special redirects
	if(statStr == "DAMAGE") stat = STAT_MIN_DAMAGE; 
	if(statStr == "STAT_MOVEMENT_TYPE") stat = STAT_MAX_MOVEMENT;

	if(stat == STAT_MAX)
	{
		;
		return;
	}

	;

	mods = unit.GetStatModSourceList(stat);

	mHeroInfo.SetStatModSourceList(mods);
}

///////////////////INVENTORY///////////////////////////////////////



function AddUnitIconToCursor(int slotID)
{
	local array<H7BaseCreatureStack> stacks;
	mIsDragginUnit = true;
	stacks = mCurrentArmy.GetBaseCreatureStacks();
	class'H7AdventureController'.static.GetInstance().GetCursor().UpdateAdventureCursorWithStack(stacks[slotID]);
}

function DropItemInInventory(int x, int y)
{
	Super.DropItemInInventory(x,y);
}

function MergeItemsInInventory(int itemIDinDropSlot, int dragSlotX, int dragSlotY, int dropSlotX, int dropSlotY)
{
	Super.MergeItemsInInventory(itemIDinDropSlot, dragSlotX, dragSlotY, dropSlotX, dropSlotY);
	mInventory.Update(mCurrentHero.GetInventory().GetItems(),mCurrentHero);
}

function bool EquipItem()
{
	if(!isItemOnCursor()) return false;
	if( Super.EquipItem() ) 
	{
		//mHeroWindow.Update(mCurrentArmy, mCurrentHero);
		return true;
	}
	return false;
}

function UnequipItem(int dropSlotX, int dropSlotY)
{
	super.UnequipItem(dropSlotX, dropSlotY);
	//mHeroWindow.Update(mCurrentArmy, mCurrentHero);
}

