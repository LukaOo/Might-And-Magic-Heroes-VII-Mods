class H7GFxTownBuildingPopup extends H7GFxTownPopup;

function SetData(H7Town town)
{
	local GFxObject data;
	local GFxObject list;
	local array<H7TownBuildingData> buildings;
	local H7TownBuildingData building;
	local int i;
	local string layout;

	data = CreateObject("Object");

	list = CreateArray();
	buildings = town.GetBuildingTree();
	i = 0;
	;
	foreach buildings(building)
	{
		list.SetElementObject(i,CreateBuildingObject(building,town));
		i++;
	}
	data.SetObject("List",list);

	data.SetString("FactionBG",town.GetFactionBGTownHallPath()); 
	town.DelFactionBGTownHallRef();
	data.SetObject("Color",CreateColorObject(class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetColor()));
	
	data.SetObject("DestroyInfo",CreateDestroyInfo(town));

	SetObject("mData", data);

	Update();

	//`log_dui("use config:" @ town.GetFaction().GetGUIconfig());

	// use layout from town if exists, else from faction
	layout = town.GetGUIconfig();
	if(Len(layout) == 0)
	{
		layout = town.GetFaction().GetTownBuildTreeLayout();
	}
	
	SetGUIConfig(layout,class'Engine'.static.GetCurrentWorldInfo().IsPlayInEditor());

}

function UpdateAfterBuilding(H7Town town)
{
	local GFxObject list;
	local array<H7TownBuildingData> buildings;
	local H7TownBuildingData building;
	local int i;

	;

	list = CreateArray();
	buildings = town.GetBuildingTree();
	i = 0;
	;
	foreach buildings(building)
	{
		list.SetElementObject(i,CreateBuildingObject(building,town));
		i++;
	}
	SetObject("mData",list);
	ActionscriptVoid("UpdateAfterBuilding");
}

function GFxObject CreateDestroyInfo(H7Town town)
{
	local GFxObject destroyInfo;
	local String blockReason,headline;
	local array<H7ResourceQuantity> list;

	destroyInfo = CreateObject("Object");
	
	destroyInfo.SetString("DestroyIcon","img://" $ PathName(GetHud().GetProperties().mButtonIcons.mDestroy));

	destroyInfo.SetBool("CanDestroy", (!town.IsOnlyTownHallBuilt() && !town.HasDestroyedToday()) );

	if(town.IsOnlyTownHallBuilt()) blockReason = "TT_DESTROY_ONLY_TOWN_HALL";
	if(town.HasDestroyedToday()) blockReason = "TT_DESTROY_ONLY_ONCE";
	destroyInfo.SetString("BlockReason",blockReason);

	town.DeleteRefundBuffer();
	town.SetRefundHero(none);

	town.DestroyBuildingsOfLevelComplete( town.GetHighestBuildingLevel() , true);
	list = town.GetRefundBuffer();

	if(list.Length > 0) // a hero reacted and put refunds into the buffer
	{
		headline = class'H7Loca'.static.LocalizeSave("TT_DISMANTLE","H7Town");
		headline = Repl(headline, "%i",string(town.GetHighestBuildingLevel()));
		headline = Repl(headline, "%percent", "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $"'>" $ town.GetRefundPercentage() $ "</font>" );
		destroyInfo.SetString("Headline",headline );
		destroyInfo.SetObject("Refund", CreateResourceArray(list) );
		destroyInfo.SetString("RefundHero", Repl( class'H7Loca'.static.LocalizeSave("TT_DISMANTLE_HERO","H7Town") , "%hero" , "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ town.GetRefundHero().GetName() $ "</font>"));
	}
	else
	{
		destroyInfo.SetString("Headline", Repl(class'H7Loca'.static.LocalizeSave("TT_DESTROY","H7Town"),"%i",string(town.GetHighestBuildingLevel())) );
	}

	town.DeleteRefundBuffer();
	town.SetRefundHero(none);

	return destroyInfo;
}

function SetGUIConfig(String str,bool canEdit)
{
	//`if(`isdefined(FINAL_RELEASE)) // TODO QA-Build: don't force to false , final-build: do force to false
	//	canEdit = false;
	//`endif
	ActionscriptVoid("SetGUIConfig");
}

function SetTownLevel(int level)
{
	ActionscriptVoid("SetTownLevel");
}

function CloseConfirmPopup()
{
	ActionscriptVoid("CloseConfirmPopup");
}

function Update()
{
	ActionscriptVoid("Update");
}
