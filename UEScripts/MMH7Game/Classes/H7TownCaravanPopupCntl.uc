class H7TownCaravanPopupCntl extends H7FlashMovieTownPopupCntl;

var protected H7AreaOfControlSiteLord mLord;
var protected H7GFxTownCaravanPopup mCaravanPopup;
var protected int mPendingCaravanDeleteIndex;

function H7GFxTownCaravanPopup GetCaravanPopup() { return mCaravanPopup; }
function H7GFxUIContainer GetPopup() {	return mCaravanPopup;}
static function H7TownCaravanPopupCntl GetInstance() { return class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetCaravanCntl(); }

function bool Initialize()
{
	;
	
	LinkToTownPopupContainer();

	//Super.Start();
	//AdvanceDebug(0);
	//super.Initialize();
	//LoadComplete();

	return true;
}

function LoadComplete()
{
	mCaravanPopup = H7GFxTownCaravanPopup(mRootMC.GetObject("aTownCaravanPopup", class'H7GFxTownCaravanPopup'));
	mCaravanPopup.SetVisibleSave(false);
}

function Update(H7Town town)
{
	//mLord = town;
	super.Update(town);
	UpdateFromLord(town);
	//mContainer.SetExternalInterface(self);
	//mCaravanPopup.Update(mTown);
	//mCaravanPopup.SetVisibleSave(true);
	//if(GetHUD().GetCurrentContext() != self) OpenPopup();
}

function UpdateFromLord(H7AreaOfControlSiteLord lord)
{
	mLord = lord;
	mCaravanPopup.Update(lord);
	mCaravanPopup.SetVisibleSave(true);
	if(GetHUD().GetCurrentContext() != self) OpenPopup();
}

function UnloadAll()
{
	if( mLord != none )
	{
		mLord.UnloadCaravans();
		mCaravanPopup.Update(mLord);
	}
	TriggerMiddleHudUpdate();

}

function TriggerMiddleHudUpdate()
{
	if( mLord != none )
	{
		if(mLord.IsA('H7Town'))	class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().SetDataFromTown(H7Town(mLord));
		else class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().SetDataFromFort(H7Fort(mLord));
	}
}

function DeleteCaravan(int caravanIndex)
{
	;
	
	mPendingCaravanDeleteIndex = caravanIndex;

	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("PU_DELETE_CARAVAN_CONFIRM","YES","NO",DeleteCaravanConfirm,none);
}

function DeleteCaravanConfirm()
{
	mLord.DeleteCaravan( mPendingCaravanDeleteIndex );
	mCaravanPopup.Update( mLord );
	TriggerMiddleHudUpdate();
}

function Pickedup(int caravanIndex,int unitIndex)
{
	local ArrivedCaravan caravan;
	local H7BaseCreatureStack pickedUpStack;
	//local Rotator rot;
	//local Texture2d icon;
	
	;
	caravan = mLord.GetArrivedCaravanByIndexReadOnly(caravanIndex);
	pickedUpStack = caravan.stacks[unitIndex];

	;

	//icon = pickedUpStack.GetStackType().GetIcon();
	//GetHUD().SetSoftwareCursor(none,rot,,,icon); 
	class'H7TownHudCntl'.static.GetInstance().PutUnitOnCursorByBaseStack(pickedUpStack);
	
	class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().DragFromOutside(pickedUpStack,caravanIndex,unitIndex);
}

function bool OpenPopup()
{
	GetHUD().BlockUnreal();
	return super.OpenPopup();
}

function Closed()
{
	ClosePopup();
}

function ClosePopup()
{
	GetHUD().UnblockUnreal();
	super.ClosePopup();

	if(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().IsInFortScreen())
	{
		GetHUD().BlockUnreal();
	}
}

/* This code will be part of realm caravan popup (if it makes it)

function UpdatePopup(array<H7Town> towns,optional array<H7CaravanArmy> caravans,optional array<ArrivedCaravan> arrivedCaravans)
{
	mCaravanPopup.SetCaravans(caravans,arrivedCaravans);

	mCaravanPopup.SetData(towns);
	OpenPopup();
}

function Update(H7Town town)
{
	// redirection:
	UpdatePopup(
		class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns(class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetTown())
	);
}

// flash selected town
function SelectCaravanTown(int id)
{
	local array<H7Town> towns;
	local H7Town town, currentTown; 

	//`log_dui("SelectCaravanTown" @ id);

	towns = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetTowns();
	currentTown = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetTown();

	foreach towns( town ) 
	{	
		if( town != currentTown && id == town.GetID() ) 
		{ 
			currentTown.GetCaravanArmy().SetTargetLordLocation( town.GetEntranceCell() );
			currentTown.GetCaravanArmy().SetTargetSite( town );
		}
	}

}

// flash selected caravan
function SelectCaravan(int heroID)
{
	// inform minimap
	`log_minimap("Tom is removing deprecated code, sorry if something broke :( ");
}


// final send, for real
function SendCaravan()
{
	local H7Town currentTown; 
	local bool success;
	
	currentTown = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetTownHudCntl().GetTown();
	
	ClosePopup();

	if( currentTown.GetCaravanArmy().GetTargetLordLocation() != none ) 
	{
		success = currentTown.GetCaravanArmy().CreateCaravan();
	}
	else 
	{
		`warn("StartCaravan - Failed");
	}

	// update GUI
	class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().SetDataFromTown(currentTown);
	class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().SetCaravanMode(false);
	if(success)
	{
		class'H7TownHudCntl'.static.GetInstance().GetMiddleHUD().EnableCaravan(false);
	}

}


function HoverCaravan(int id,bool val)
{

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().HoverCaravan(id,val);
}


function DeleteCaravan(int caravanIndex) // all caravans on map and arrived
{
	`log_gui("DeleteCaravan" @ caravanIndex);
	mPendingCaravanDeleteIndex = caravanIndex;

	class'H7RequestPopupCntl'.static.GetInstance().GetRequestPopup().YesNoPopup("Do you really want to delete the caravan and all of its creatures?","Yes","No",DeleteCaravanConfirm,none);
}

function DeleteCaravanConfirm()
{
	
	class'H7AdventureController'.static.GetInstance().DeleteCaravan( mPendingCaravanDeleteIndex );

	mCaravanPopup.SetCaravans(
		class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetCaravans(),
		class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetAllArrivedCaravans()
		);
}

function SetMinimapDimensions(int x,int y,int w,int h)
{
	`log_gui("SetMinimapDimensions" @ x @ y @ w @ h);

	//class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().SetCaravanMode(true,x,y,w,h); //Probably outdated, as there is now CaravanPopup anymore anyway..?
}
*/

