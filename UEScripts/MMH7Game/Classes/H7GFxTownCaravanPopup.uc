// Caravanserai Popup
// with commented code for caravan realm window
class H7GFxTownCaravanPopup extends H7GFxTownPopup;

function Update(H7AreaOfControlSiteLord lord)
{
	local array<ArrivedCaravan> arrivedCaravans;
	local ArrivedCaravan arrivedCaravan;
	local GFxObject data,caravanData,list;
	local int i;

	data = CreateObject("Object");
	list = CreateArray();
	i = 0;
	arrivedCaravans = lord.GetArrivedCaravans();
	foreach arrivedCaravans(arrivedCaravan)
	{
		caravanData = CreateCaravanObjectFromData(arrivedCaravan);
		list.SetElementObject(i,caravanData);
		i++;
	}

	data.SetString("BannerIconPath", lord.GetFaction().GetFactionBannerIconPath());
	data.SetObject("CaravanList",list);

	SetObject("mData", data);
	
	ActionScriptVoid("Update");
	//Update();
}
















/*
function SetData(array<H7Town> towns)
{
	local GFxObject mData,list,townData;
	local H7Town town;
	local int i;

	`log_gui("Caravan SetData Towns:" @ towns.Length);
	mData = CreateObject("Object");
	list = CreateArray();

	i = 0;
	foreach towns(town)
	{
		townData = CreateDataObject();
		town.GUIWriteInto(townData);
		townData.SetBool("TownCanAcceptCaravan",town.CanAcceptCaravan(class'H7TownHudCntl'.static.GetInstance().GetTown()));
		list.SetElementObject(i,townData);
		i++;
	}
	mData.SetObject("towns",list);
	
	SetObject("mData", mData);
	
	Update();
}

function SetCaravans(array<H7CaravanArmy> caravans,array<ArrivedCaravan> arrivedCaravans)
{
	local GFxObject mData,list,caravanData;
	local H7CaravanArmy caravan;
	//local ArrivedCaravan arrivedCaravan;
	local int i;

	`log_gui("Caravan SetData caravans:" @ caravans.Length);
	mData = CreateObject("Object");
	list = CreateArray();

	i = 0;
	foreach caravans(caravan)
	{
		caravanData = CreateCaravanObject(caravan);
		list.SetElementObject(i,caravanData);
		i++;
	}
	/*
	`log_gui("Caravan SetData arrivedCaravans:" @ caravans.Length);
	foreach arrivedCaravans(arrivedCaravan)
	{
		caravanData = CreateCaravanObjectFromData(arrivedCaravan);
		list.SetElementObject(i,caravanData);
		i++;
	}
	*/

	mData.SetObject("caravans",list);

	SetObject("mData", mData);

	Update();
}

function Update()
{
	ActionscriptVoid("Update");
}

// uc -> flash
function SelectCaravanTown(int id)
{
	ActionScriptVoid("SelectTown");
}

function HoverCaravanTown(int id,optional bool val=true)
{
	// Deprecated ... Minimap-stuff
	`log_minimap("TOM IS REMOVING DEPRECATED STUFF!");
}


// uc -> flash
function SelectCaravan(int id)
{
	ActionScriptVoid("SelectCaravan");
}

function HoverCaravan(int id,optional bool val=true)
{
	`log_minimap("You know the drill...deprecated stuff being removed...toms fault...");
}

function SetMinimap(TextureRenderTarget2D texture)
{
	SetExternalTexture("CaravanMinimap",texture);
}
*/
