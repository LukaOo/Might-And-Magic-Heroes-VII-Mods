//=============================================================================
// H7GFxActorTooltip
//
// This class has the capability to add a flash tooltip to the side of an Unreal3dObject/Actor
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7GFxActorTooltip extends H7GFxUIContainer
	dependson(H7StructsAndEnumsNative);

var protected Actor mActor;
var protected bool mActivatedBy3DWorld; // if this is true the tooltip will be shutdown as soon as cursor moves over GUI, as opposed to ActorTooltips started by GUI (minimap,heroslots)

// debug
var protected array<BoundingPoint> mBoundingPoints;
var protected float mLeft,mRight,mTop,mBottom;
var protected Box mActorBox;
var protected bool mReadActorBox;

// only used by 3DWorld
// sets the actor to what the mouse hits (buffered from grid)
// called every frame
function SetActor(Actor hoveredActor)
{
	//`log_dui("SetActor" @ hoveredActor);
	// special handling for the weird hero-army structure
	if(H7AdventureHero(hoveredActor) != none)
	{
		hoveredActor = H7AdventureHero(hoveredActor).GetAdventureArmy();
	}
	
	if(mActor == hoveredActor) return;
	if(class'H7PlayerController'.static.GetPlayerController().IsMouseOverHUD()) return; 
	
	mActor = hoveredActor; 
	ActorChanged();

	// for when the actor under tooltip changes, we update the tooltip as well
	if(H7IGUIListenable(hoveredActor) != none) 
	{
		ListenTo(hoveredActor);
	}
}

// checks whether the tooltip should be refreshed, because the unterlying actor changed data
// - called on event
function ListenUpdate(H7IGUIListenable gameEntity)
{
	BuildTooltip(mActor);
}

// checks whether the tooltip should be activated or deactivated now with the new actor
// - called on event
protected function ActorChanged()
{
	if(mActor == none || class'H7PlayerController'.static.GetPlayerController().IsInLoadingScreen()) 
	{
		ShutDown();
	}
	else if(mActor.bHidden && (!mActor.IsA('H7AdventureArmy') || H7AdventureArmy(mActor).GetShip() == none)) // allow hidden armies in a ship
	{
		ShutDown();
	}
	else if(mActor.IsA('Landscape'))
	{
		ShutDown();
	}
	else if(StaticMeshActor(mActor) != none && H7CouncilPlayerController(class'H7PlayerController'.static.GetPlayerController()) != none)
	{
		mReadActorBox = true;
		SetVisibleSave(true);
		mActivatedBy3DWorld = true;
	}
	else if(H7ITooltipable(mActor) == none)
	{
		ShutDown();
	}
	else if(H7IHideable(mActor) != none && H7IHideable(mActor).IsHiddenX())
	{
		ShutDown();
	}
	else
	{
		mReadActorBox = true;
		BuildTooltip(mActor,GetHud().GetRightMouseDown());
		SetVisibleSave(true);
		mActivatedBy3DWorld = true;
	}
}

function StartRightClickTooltip()
{
	;
	if(mActor != none)
	{
		BuildTooltip(mActor,true);
	
		StartAutoShowTooltipTimer(); // in case of the minimap the mouse will not be over the anchor (anchor is under the minimap) so we manually need to start the tt timer

		SetVisibleSave(true);
	}
}

function StartAutoShowTooltipTimer()
{
	ActionScriptVoid("StartShowTooltip");
}

function StopRightClickTooltip()
{
	BuildTooltip(mActor,false);
}

//////////////////////////////////////////////
// Actor -> H7ITooltipable -> H7TooltipData //
//////////////////////////////////////////////

// Builds the Tooltip data and visuals, but does not position it or activate/deactivate it , but sends the data to flash also
// - position is done in Update() every frame
function BuildTooltip(Actor forActor,optional bool rightClickVersion = false)
{
	//`log_dui("BuildTooltip" @ forActor @ H7ITooltipable(forActor) @ rightClickVersion);

	if( H7ITooltipable(forActor) != none )
	{
		BuildTooltipForTooltipable(H7ITooltipable(forActor),rightClickVersion);
	}
	else if(forActor != none)
	{
		;
	}
}

function BuildTooltipForTooltipable(H7ITooltipable forActor,optional bool rightClickVersion = false)
{
	local H7TooltipData tooltip,tooltipData;

	tooltip = forActor.GetTooltipData(rightClickVersion);
	switch(tooltip.type)
	{
		case TT_TYPE_STRING:
			if(tooltip.strData == "" && tooltip.Description=="" && tooltip.Title == "") ShutDown();
			else
			{
				BuildTooltipBuilding(tooltip);
				SetObject("mData", tooltip.objData);
				UpdateFlashTooltip("TT_TYPE_STRING","",rightClickVersion,!rightClickVersion && tooltip.addRightMouseIcon);
			}
			break;
		case TT_TYPE_DWELLING:
			BuildTooltipDwelling(tooltip, H7Dwelling(forActor));
			SetObject("mData", tooltip.objData);
			UpdateFlashTooltip(String(tooltip.type), "", false, false);
			break;
		case TT_TYPE_RESOURCE_PILE:
			UpdateFlashTooltip("TT_TYPE_STRING",tooltip.strData,rightClickVersion,!rightClickVersion && tooltip.addRightMouseIcon);
			break;
		case TT_TYPE_TOWN:
			tooltipData = BuildTooltipTown(H7AreaOfControlSite(forActor),rightClickVersion,H7AreaOfControlSite(forActor).IsInScoutingRangeOfLocalPlayer());
			SetObject("mData",tooltipData.objData);
			UpdateFlashTooltip(String(tooltip.type),"",rightClickVersion,!rightClickVersion && tooltip.addRightMouseIcon);
			break;
		case TT_TYPE_ITEM:
			tooltipData = BuildTooltipItemPile(H7ItemPile(forActor));
			SetObject("mData", tooltipData.objData);
			UpdateFlashTooltip(String(tooltip.type),"",rightClickVersion,!rightClickVersion && tooltip.addRightMouseIcon);
			break;
		case TT_TYPE_BUILDING_BUFFABLE:
			tooltipData = BuildTooltipBuildingBuffable(H7VisitableSite(forActor));
			SetObject("mData",tooltipData.objData);
			UpdateFlashTooltip(String(tooltip.type),"",rightClickVersion,!rightClickVersion && tooltip.addRightMouseIcon);
			break;
		case TT_TYPE_BATTLESITE:
			tooltipData = BuildTooltipBattleSite(H7BattleSite(forActor), rightClickVersion);
			SetObject("mData",tooltipData.objData);
			UpdateFlashTooltip(String(tooltip.type),"",rightClickVersion,!rightClickVersion && tooltipData.addRightMouseIcon);
			break;
		case TT_TYPE_CRITTER_ARMY:
			if(H7AdventureHero(forActor) != none)
			{
				forActor = H7AdventureHero(forActor).GetAdventureArmy();
			}
			if(H7Ship(forActor) != none)
			{
				forActor = H7Ship(forActor).GetArmy();
			}

			if(rightClickVersion)
			{
				tooltipData = BuildTooltipArmyExtended(H7AdventureArmy(forActor),H7AdventureArmy(forActor).IsInScoutingRangeOfLocalPlayer());
			}
			else
			{
				tooltipData = BuildTooltipArmyBasic(H7AdventureArmy(forActor),H7AdventureArmy(forActor).IsInScoutingRangeOfLocalPlayer());
			}
			SetObject("mData",tooltipData.objData);
			UpdateFlashTooltip("TT_TYPE_CRITTER_ARMY", ,rightClickVersion,!rightClickVersion && tooltip.addRightMouseIcon);
			break;
		case TT_TYPE_HERO_ARMY:
			if(!rightClickVersion)
			{
				if(forActor.IsA('H7AdventureArmy') ) 
				{
					tooltipData = BuildTooltipHeroBasic(H7AdventureArmy(forActor).GetHero());
				}
				else if(forActor.IsA('H7Ship'))
				{
					tooltipData = BuildTooltipHeroBasic(H7Ship(forActor).GetArmy().GetHero());
				}
				else
				{
					tooltipData = BuildTooltipHeroBasic(H7AdventureHero(forActor));
				}
			}
			else
			{
				if(forActor.IsA('H7AdventureArmy') ) 
				{
					tooltipData = BuildTooltipHeroExtended(H7AdventureArmy(forActor).GetHero(),H7AdventureArmy(forActor).IsInScoutingRangeOfLocalPlayer());
				}
				else if(forActor.IsA('H7Ship'))
				{
					tooltipData = BuildTooltipHeroExtended(H7Ship(forActor).GetArmy().GetHero(),H7Ship(forActor).GetArmy().IsInScoutingRangeOfLocalPlayer());
				}
				else
				{
					tooltipData = BuildTooltipHeroExtended(H7AdventureHero(forActor),H7AdventureHero(forActor).GetAdventureArmy().IsInScoutingRangeOfLocalPlayer());
				}
			}
			SetObject("mData",tooltipData.objData);
			UpdateFlashTooltip("TT_TYPE_HERO_ARMY", ,rightClickVersion,!rightClickVersion && tooltip.addRightMouseIcon);
			break;
		default:
			;
			UpdateFlashTooltip("TT_TYPE_STRING","Actor:" @ String(forActor) @ tooltip.type);
	}
}

// for when the tooltip should not be placed based on the 3d-unreal-projection
function ActivateActorTooltipAtCustomPosition(Actor forActor,int x1,int y1,int x2,int y2, optional bool rightClickVersion = false)
{
	if(forActor == none) ;

	if(mActor != forActor)
	{
		mActor = forActor;
		//ActorChanged(); // don't call it because, ...
		BuildTooltip(forActor, rightClickVersion);
	}
	
	UpdateFlashAnchor(x1,y1,x2,y2);
	SetVisibleSave(true);
}

//
function ActivateTooltipableAtCustomPosition(H7ITooltipable ttObject,int x1,int y1,int x2,int y2, optional bool rightClickVersion = false)
{
	mActor = none; // because we display tooltip of a quest and not of an actor
	BuildTooltipForTooltipable(ttObject,rightClickVersion);
	UpdateFlashAnchor(x1,y1,x2,y2);
	SetVisibleSave(true);
}

// Update Position for current Actor
// called every frame
function Update()
{
	if(!class'H7PlayerController'.static.GetPlayerController().IsInputAllowed() && mActivatedBy3DWorld)
	{
		// shutdown 3dworld tooltips when mouse over hud, reactivates automatically via next SetActor();
		ShutDown();
		mActor = none;
		;
		return;
	}

	if(mActor != none && mActivatedBy3DWorld)
	{
		AnalyseBoundingBox(mActor);
		ConvertPixels();
		UpdateFlashAnchor(mLeft,mTop,mRight,mBottom);
	}
	else
	{
		//UpdateFlashAnchor(0,0,0,0);
	}
}

function ShutDown()
{
	if(IsVisible() || class'H7PlayerController'.static.GetPlayerController().IsInLoadingScreen()) // protection against constant calling, but prevented shutdown during loadingscreen
	{
		SetVisibleSave(false);
		ActionScriptVoid("ShutDown"); // this resets the cooldown and should not be called every frame
	}

	mActivatedBy3DWorld = false;
	mActor = none; // do it or don't do it??? // when mouse over gui it needs to be set to none, so that gui rightclicks don't activate the last mActor.tooltip
	// although every frame sets it back to landscape, and its a fight landcape,none,landcape,none,landscape,none.... // OPTIONAL fix better
}

function UpdateFlashAnchor(int x1,int y1,int x2,int y2)
{
	ActionScriptVoid("UpdateFlashAnchor");
}

function UpdateFlashTooltip(String type,optional String tooltip,optional bool isExtendedVersion,optional bool rightClickTooltipAvailable)
{
	ActionScriptVoid("UpdateFlashTooltip");
}


// HELPER FUNCTIONS

function ConvertPixels()
{
	local vector2d unrealPixel,flashPixel;

	unrealPixel.X = mLeft;
	unrealPixel.Y = mTop;
	flashPixel = class'H7AdventureHudCntl'.static.GetInstance().UnrealPixels2FlashPixels(unrealPixel);
	mLeft = flashPixel.X;
	mTop = flashPixel.Y;

	unrealPixel.X = mRight;
	unrealPixel.Y = mBottom;
	flashPixel = class'H7AdventureHudCntl'.static.GetInstance().UnrealPixels2FlashPixels(unrealPixel);
	mRight = flashPixel.X;
	mBottom = flashPixel.Y;
}

function array<Vector2d> Get8BoundingPixels(Actor actor)
{
	local array<Vector2d> pixels;
	local Vector2d pixel;
	local Vector worldLoc;
	local bool setBackToNoCollision;

	if(mReadActorBox)
	{
		mReadActorBox = false;

		// ensure that the actor has a active box:
		if(actor.CollisionType == COLLIDE_NoCollision)
		{
			actor.SetCollisionType( COLLIDE_BlockAll );
			setBackToNoCollision = true;
		}

		/* does not work
		if(actor.IsA('StaticMeshActor'))
		{
			mActorBox.IsValid = 1;
			mActorBox.Min = StaticMeshActor(actor).StaticMeshComponent.Bounds.Origin;
			mActorBox.Max = StaticMeshActor(actor).StaticMeshComponent.Bounds.BoxExtent; 
		}
		else if(actor.IsA('SkeletalMeshActor'))
		{
			mActorBox.Min = SkeletalMeshActor(actor).SkeletalMeshComponent.Bounds.Origin;
			mActorBox.Max = SkeletalMeshActor(actor).SkeletalMeshComponent.Bounds.BoxExtent; 
		}
		else
		{
			actor.GetComponentsBoundingBox(mActorBox);
		}*/

		mActorBox = class'H7GameUtility'.static.GetMeshComponentsBoundingBox(actor);

		// set back to how it was
		if(setBackToNoCollision)
		{
			actor.SetCollisionType( COLLIDE_NoCollision );
		}
	}

	if(mActorBox.IsValid == 0)
	{
		return pixels; // empty array
	}

	pixel = GetPixel(mActorBox.Min);	pixels.AddItem( pixel );
	pixel = GetPixel(mActorBox.Max);	pixels.AddItem( pixel );

	worldLoc = mActorBox.Min;worldLoc.X = mActorBox.Max.X;
	pixel = GetPixel(worldLoc);	pixels.AddItem( pixel );

	worldLoc = mActorBox.Min;worldLoc.Y = mActorBox.Max.Y;
	pixel = GetPixel(worldLoc);	pixels.AddItem( pixel );

	worldLoc = mActorBox.Min;worldLoc.Z = mActorBox.Max.Z;
	pixel = GetPixel(worldLoc);	pixels.AddItem( pixel );

	worldLoc = mActorBox.Max;worldLoc.X = mActorBox.Min.X;
	pixel = GetPixel(worldLoc);	pixels.AddItem( pixel );

	worldLoc = mActorBox.Max;worldLoc.Y = mActorBox.Min.Y;
	pixel = GetPixel(worldLoc);	pixels.AddItem( pixel );

	worldLoc = mActorBox.Max;worldLoc.Z = mActorBox.Min.Z;
	pixel = GetPixel(worldLoc);	pixels.AddItem( pixel );

	return pixels;
}

function AnalyseBoundingBox(Actor actor)
{
	local Vector2D anchor;
	local Vector2D pixel;
	local array<Vector2d> pixels;
	local BoundingPoint bp;

	mBoundingPoints.Remove(0,mBoundingPoints.Length);
	anchor = GetPixel(actor.Location);
	mLeft = anchor.X;
	mRight = anchor.X;
	mTop = anchor.Y;
	mBottom = anchor.Y;

	// GO
	pixels = Get8BoundingPixels(actor);
	if(pixels.Length > 0)
	{
		foreach pixels(pixel)
		{
			mLeft = min(mLeft,pixel.X);
			mRight = max(mRight,pixel.X);
			mTop = min(mTop,pixel.Y);
			mBottom = max(mBottom,pixel.Y);

			bp.pixel = pixel;
			bp.hit = true;
			mBoundingPoints.AddItem( bp );
		}
	}
	else
	{
		// build emergency box
		mLeft-=50;
		mRight+=50;
		mTop-=50;
		mBottom+=50;
	}

	// quick fix hack for tooltips on actors with out bounding box / collision (activated via cell)
	
	
}

function DebugDrawBoundingBox(Canvas canvas)
{
	local BoundingPoint point;
	local Color boxColor;

	if(mActor == none || !mActivatedBy3DWorld) return;

	AnalyseBoundingBox( mActor );

	foreach mBoundingPoints(point)
	{
		if(point.hit)
		{
			boxColor = MakeColor(0,255,0,255);
		}
		else
		{
			boxColor = MakeColor(255,0,0,255);
		}
		canvas.DrawColor = boxColor;
		canvas.SetPos( point.pixel.X-1, point.pixel.Y-1 );
		canvas.DrawBox(3,3);
	}

	// box
	canvas.DrawColor = MakeColor(255,255,255,255);
	canvas.Draw2DLine(mLeft,0,mLeft,9999,canvas.DrawColor);
	canvas.Draw2DLine(mRight,0,mRight,9999,canvas.DrawColor);
	canvas.Draw2DLine(0,mTop,9999,mTop,canvas.DrawColor);
	canvas.Draw2DLine(0,mBottom,9999,mBottom,canvas.DrawColor);

}


function Vector2d GetPixel(Vector worldLocation)
{
	local LocalPlayer localPlayer;
	local Vector2D viewportSize;
	local vector2d pixel;

	localPlayer = class'H7PlayerController'.static.GetLocalPlayer();
	localPlayer.ViewportClient.GetViewportSize( viewportSize );
	pixel = localPlayer.Project(worldLocation);
	pixel.x *= viewportSize.x;
	pixel.y *= viewportSize.y;

	return pixel;
}










///////////////////////////////////////////////////////////////////////
// Building specific tooltips
///////////////////////////////////////////////////////////////////////
// WARNING - event thought they all reaturn H7TooltipData, only .objData is used
// .type .strData .addRightmouseIcon is discarded
// OPTIONAL refactor all to return GFxObject

function H7TooltipData BuildTooltipHeroBasic(H7AdventureHero hero) // normal hero tooltip
{
	local H7TooltipData data;

	data.type = TT_TYPE_HERO_ARMY;
	data.objData = CreateObject("Object");

	data.objData.SetString("Name", hero.GetName());
	
	hero.AddBuffsToDataObject(data.objData, self);

	AddThreatInfo(data.objData,hero.GetAdventureArmy());

	AddPlayerInfo(data.objData,hero.GetAdventureArmy().GetPlayer());

	return data;
}

function H7TooltipData BuildTooltipTown(H7AreaOfControlSite site,bool extendedVersion,bool scouting)
{
	local H7TooltipData data;
	local H7Town town;
	local H7AdventureArmy garrison;
	local H7TownBuildingData buildingData;
	local GFxObject guardObj, garrisonObj, garrisonHero;
	local bool obfuscate,hostile;
	local int wallAndGateLevel;
	local array<H7BaseCreatureStack> localGuardStacks;

	data.type = TT_TYPE_TOWN;
	data.objData = CreateObject("Object");

	hostile = site.GetPlayer().IsPlayerHostile(class'H7AdventureController'.static.GetInstance().GetLocalPlayer());
	
	data.objData.SetString("Name",site.GetName());
	data.objData.SetString("Icon",site.GetIconPath());
	
	// fortifications
	if(site.IsA('H7Town'))
	{
		town = H7Town(site);
		
		data.objData.SetInt("Level",site.GetLevel());

		// income
		data.objData.SetInt("Income", town.GetIncomeByResource(town.GetIncomeResource()));
		data.objData.SetString("IncomeImg", town.GetIncomeResource().GetIconPath());
		/*str = "<font size='24'>" $ town.GetIncomeByResource(town.GetIncomeResource()) $ "</font>" 
			$ "<img src='" $ town.GetIncomeResource().GetIconPath() $ "' width='20' height='20'></img>" 
			$ "<font size='24'>/" $ `Localize("H7General","DAY","MMH7Game")  $ "</font>";
		data.objData.SetString("Income",str);*/

		
		// wall
		buildingData = town.GetBuildingDataByType(class'H7TownGuardBuilding');
		if(buildingData.IsBuilt)
		{
			wallAndGateLevel = town.GetBuildingLevelByType(class'H7TownGuardBuilding');
			buildingData = town.GetBestBuilding(buildingData);
			data.objData.SetBool("WallsBuilt", true);
			data.objData.SetInt("WallLevel", wallAndGateLevel);
				
			// moat (icon is in townbuilding)
			buildingData = town.GetBuildingDataByType(class'H7TownMoat');
			data.objData.SetBool("MoatBuilt", buildingData.IsBuilt);

			// tower (icon is in town)
			buildingData = town.GetBuildingDataByType(class'H7TownTower');
			data.objData.SetBool("TowerBuilt", buildingData.IsBuilt);

			// TODOD
			if(false)
			{
			// super wall (icon is in town)
			buildingData = town.GetBuildingDataByType(class'H7TownGuardBuilding');
			data.objData.SetBool("WallAdv", buildingData.IsBuilt);
			}

		}
		else
		{
			//str = "-";
		}
		data.objData.SetString("Fortifications",class'H7Loca'.static.LocalizeSave("TT_FORTIFICATIONS","H7GFxActorTooltip"));
		
	}
	else if( site.IsA( 'H7Fort' ) )
	{
		data.objData.SetBool("WallsBuilt", true);
		data.objData.SetInt("WallLevel", 3);
		data.objData.SetString("Fortifications",class'H7Loca'.static.LocalizeSave("TT_FORTIFICATIONS","H7GFxActorTooltip"));
	}

	if( hostile )
	{
		localGuardStacks = site.GetLocalGuardAsBaseCreatureStacks();
		AddThreatInfo( data.objData, site.GetGarrisonArmy(), localGuardStacks );
	}
	
	// TODO buffs/effects

	AddPlayerInfo(data.objData,site.GetPlayer());

	if(extendedVersion)
	{
		obfuscate = hostile;
		if(scouting) obfuscate = false;
		
		// guard
		guardObj = CreateArmyObjectFromSite(site,obfuscate);
		data.objData.SetObject("Guard",guardObj); 

		if(site.GetGarrisonArmy().GetHero() != none && site.GetGarrisonArmy().GetHero().IsHero())
		{
			garrisonHero = CreateObject("Object");
			garrisonHero.SetString("Icon", site.GetGarrisonArmy().GetHero().GetFlashIconPath());
			garrisonHero.SetInt("Level", site.GetGarrisonArmy().GetHero().GetLevel());
			garrisonHero.SetBool("IsMight", site.GetGarrisonArmy().GetHero().IsMightHero());
			data.objData.SetObject("GarrisonHero", garrisonHero);
		}

		// garrison
		if(site.IsA('H7Garrison'))
		{
			garrison = H7Garrison(site).GetGarrisonArmy();
		}
		else if(site.IsA('H7AreaOfControlSiteLord'))
		{
			garrison = H7AreaOfControlSiteLord(site).GetGarrisonArmy();
		}
		garrisonObj = CreateArmyObject(garrison,obfuscate);
		data.objData.SetObject("Garrison",garrisonObj); 
	}
	
	return data;
}

function H7TooltipData BuildTooltipHeroExtended(H7AdventureHero hero,optional bool scouting) // the one with stats
{
	// TODO Robert: enable combatbuff code as soon as the ?s a disticntion between combat and adventure buffs
	local H7TooltipData data;
	local H7BaseBuff buff;
	local array<H7BaseBuff> buffs;
	local GFxObject heroObj, armyObj;
	local GFxObject adventureBuffsObj, combatBuffsObj, buffObj;
	local int advBuffs, comBuffs;
	local H7AdventureArmy army;
	local bool obfuscate;

	advBuffs = 0;
	comBuffs = 0;
	army = hero.GetAdventureArmy();

	data.type = TT_TYPE_HERO_ARMY;
	data.objData = CreateObject("Object");
	heroObj = CreateObject("Object");
	armyObj = CreateArray();
	adventureBuffsObj = CreateArray();
	combatBuffsObj = CreateArray();
	
	hero.GUIWriteInto(heroObj, LF_EVERYTHING);
	data.objData.SetObject("Hero", heroObj);
	
	// Army
	obfuscate = army.GetPlayer().IsPlayerHostile(class'H7AdventureController'.static.GetInstance().GetLocalPlayer());
	if(scouting) obfuscate = false;
	armyObj = CreateArmyObject(army,obfuscate);
	if(obfuscate) AddThreatInfo(data.objData, army);
	data.objData.SetObject("Army",armyObj); 
	
	army.GetHero().GetBuffManager().GetActiveBuffs(buffs);
	
	foreach buffs(buff)
	{
		if( buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() )
		{

			buffObj = CreateObject("Object");

			buffObj.SetBool( "BuffIsDisplayed", buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs());
			buffObj.SetBool( "BuffIsDebuff", buff.IsDebuff() );
			buffObj.SetString( "BuffName", buff.GetName() ); 
			buffObj.SetString( "BuffTooltip", buff.GetTooltip() );
			buffObj.SetString( "BuffIcon", buff.GetFlashIconPath() );
			buffObj.SetInt( "BuffDuration", buff.GetCurrentDuration() );
			if(buff.GetDurationModifierTrigger()==ON_COMBAT_START)
			{
				combatBuffsObj.SetElementObject(comBuffs, buffObj);
				comBuffs++;
			}
			else
			{   
				adventureBuffsObj.SetElementObject(advBuffs, buffObj);
				advBuffs++;
			}
	
		}
	}

	// extended heroes have no threatinfo

	AddPlayerInfo(data.objData,hero.GetAdventureArmy().GetPlayer());

	data.objData.SetObject("AdventureBuffs", adventureBuffsObj);
	data.objData.SetObject("CombatBuffs", combatBuffsObj);
	return data;
}

function H7TooltipData BuildTooltipArmyBasic(H7AdventureArmy army,bool scouting) // basic Tooltip neutral critters without hero 
{
	local H7TooltipData data;
	
	data.type = TT_TYPE_CRITTER_ARMY;
	data.objData = CreateObject("Object");

	data.objData.SetString("headline", army.GetName()); 

	if(army.GetPlayer() != class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
		AddThreatInfo(data.objData,army);
	
	if(H7CaravanArmy(army) != none)
		AddPlayerInfo(data.objData, army.GetPlayer());

	return data;
}

function H7TooltipData BuildTooltipArmyExtended(H7AdventureArmy army,bool scouting) // Extended Tooltip neutral critters without hero 
{
	local H7TooltipData data;
	local GFxObject unitArray;
	local bool obfuscate;

	data.type = TT_TYPE_CRITTER_ARMY;
	data.objData = CreateObject("Object");

	data.objData.SetString("headline", army.GetName() ); 

	AddThreatInfo(data.objData,army);

	if(H7CaravanArmy(army) != none)
		AddPlayerInfo(data.objData, army.GetPlayer());

	obfuscate = army.GetPlayer().IsPlayerHostile(class'H7AdventureController'.static.GetInstance().GetLocalPlayer());
	if(scouting) obfuscate = false;

	unitArray = CreateArmyObject(army,obfuscate);
	data.objData.SetObject("Army",unitArray); 

	return data;
}

function AddThreatInfo(GFxObject data,H7AdventureArmy army, optional array<H7BaseCreatureStack> additionalStacks)
{
	local ECurrentArmyAction action;
	local EAPRLevel threat;
	local H7AdventureArmy selectedArmy;
	local Color unrealColor;
	local String colorHTML,line,bracketInfo;
	local float outcomeChance;
	
	selectedArmy = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();
	if( !selectedArmy.GetPlayer().IsControlledByLocalPlayer() )
	{
		selectedArmy = none;
	}

	threat = class'H7AdventureController'.static.GetInstance().GetAPRLevel( selectedArmy, army, additionalStacks );
	if( army.IsGarrisoned() && army.GetStrengthValue( , additionalStacks ) == 0 )
	{
		return;
	}

	action = class'H7AdventureGridManager'.static.GetInstance().GetArmyActionByHero(army.GetHero(),outcomeChance);
	switch(action)
	{
		case CAA_TALK:
			threat = APR_NONE;
			bracketInfo = "(" $ class'H7Loca'.static.LocalizeSave("TT_THREAT_END_TALK","H7GFxActorTooltip") $ ")";
			break;
		case CAA_NOTHING:
			threat = APR_NONE;
			bracketInfo = "(" $ class'H7Loca'.static.LocalizeSave("TT_THREAT_END_NONE","H7GFxActorTooltip") $ ")";
			break;
		case CAA_BRIBE:
			//if(outcomeChance < 1) bracketInfo = "(" $ Repl(`Localize("H7GFxActorTooltip", "TT_THREAT_END_CHANCE_PAY", "MMH7Game"),"%i",class'H7GameUtility'.static.FloatToPercent(outcomeChance)) $ ")";
			//else bracketInfo = "(" $ `Localize("H7GFxActorTooltip", "TT_THREAT_END_PAY", "MMH7Game") $ ")";
			break;
		case CAA_ATTACK_ARMY:
			bracketInfo = "(" $ class'H7Loca'.static.LocalizeSave("TT_THREAT_END_FIGHT","H7GFxActorTooltip") $ ")";
			break;
		case CAA_JOIN_FORCE:
			if(outcomeChance < 1) bracketInfo = "(" $ Repl(class'H7Loca'.static.LocalizeSave("TT_THREAT_END_CHANCE_JOIN_FORCE","H7GFxActorTooltip"),"%i",class'H7GameUtility'.static.FloatToPercent(outcomeChance)) $ ")";
			else bracketInfo = "(" $ class'H7Loca'.static.LocalizeSave("TT_THREAT_END_JOIN_FORCE","H7GFxActorTooltip") $ ")";
			break;
		case CAA_JOIN_OFFER:
			if(outcomeChance < 1) bracketInfo = "(" $ Repl(class'H7Loca'.static.LocalizeSave("TT_THREAT_END_CHANCE_JOIN","H7GFxActorTooltip"),"%i",class'H7GameUtility'.static.FloatToPercent(outcomeChance)) $ ")";
			else bracketInfo = "(" $ class'H7Loca'.static.LocalizeSave("TT_THREAT_END_JOIN","H7GFxActorTooltip") $ ")";
			break;
		case CAA_FLEE:
			if(outcomeChance < 1) bracketInfo = "(" $ Repl(class'H7Loca'.static.LocalizeSave("TT_THREAT_END_CHANCE_FLEE","H7GFxActorTooltip"),"%i",class'H7GameUtility'.static.FloatToPercent(outcomeChance)) $ ")";
			else bracketInfo = "(" $ class'H7Loca'.static.LocalizeSave("TT_THREAT_END_FLEE","H7GFxActorTooltip") $ ")";
			break;
		case CAA_MEET_ARMY:
			threat = APR_NONE;
			bracketInfo = "(" $ class'H7Loca'.static.LocalizeSave("TT_THREAT_END_MEET","H7GFxActorTooltip") $ ")";
			break;
		case CAA_SELECT_ARMY:
			data.SetString("Subline","");
			return;
		default:
			threat = APR_NONE;
			bracketInfo = "(unknown)";
			;
			
	}		

	unrealColor = GetHud().GetProperties().mAPRColorMapping.GetColor(threat);
	colorHTML = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().UnrealColorToHTMLColor(unrealColor);
	line = class'H7Loca'.static.LocalizeSave("TT_THREAT","H7GFxActorTooltip") @ "<font color='" $ colorHTML $ "'>" $ class'H7Loca'.static.LocalizeSave(String(threat),"H7Adventure") $ "</font>";
	if(bracketInfo != "")
	{
		line = line @ bracketInfo;
	}

	if(selectedArmy != none && army.GetPlayer() == selectedArmy.GetPlayer())
		line = "";

	data.SetString("Subline",line);
}

function AddPlayerInfo(GFxObject data,H7Player aplayer)
{
	local H7Player mePlayer;
	data.SetString( "PlayerName", aplayer.GetName() );
	data.SetInt( "PlayerColorR", aplayer.GetColor().R);
	data.SetInt( "PlayerColorG", aplayer.GetColor().G);
	data.SetInt( "PlayerColorB", aplayer.GetColor().B);
	data.SetString( "Color" , GetHud().GetDialogCntl().UnrealColorToFlashColor( aplayer.GetColor() ) );

	mePlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
	if(aplayer == mePlayer)
	{
		data.SetString("PlayerRelation",class'H7Loca'.static.LocalizeSave("RELATION_YOU","H7GFxActorTooltip"));
	}
	else if(aplayer.IsPlayerHostile(mePlayer))
	{
		data.SetString("PlayerRelation",class'H7Loca'.static.LocalizeSave("RELATION_ENEMY","H7GFxActorTooltip"));
	}
	else
	{
		data.SetString("PlayerRelation",class'H7Loca'.static.LocalizeSave("RELATION_ALLIED","H7GFxActorTooltip"));
	}
}

function BuildTooltipBuilding(out H7TooltipData data)
{
	local GFxObject obj;
	local string descwIcon,placeholder;
	local array<string> placeholders;

	descwIcon = data.Description;
	placeholders = class'H7EffectContainer'.static.GetPlaceholders(descwIcon);
	foreach placeholders(placeholder)
	{
		descwIcon = Repl(descwIcon,placeholder,class'H7EffectContainer'.static.ResolveIconPlaceholder(placeholder));
	}

	obj = CreateObject("Object");
	obj.SetString("Title", data.Title);
	obj.SetString("Description", descwIcon);
	if(data.strData != "") obj.SetString("StrData", data.strData);
	obj.SetString("Visited", data.Visited);
	data.objData = obj;
}

function BuildTooltipDwelling(out H7TooltipData data, H7Dwelling dwelling)
{
	local GFxObject dwellingObj;//, creatures, creatureObj;
	local array<H7DwellingCreatureData> creatureData;
	local String creatures,replColor;
	local int i;
	
	replColor = class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor);
	dwellingObj = CreateObject("Object");
	//creatures = CreateArray();
	creatureData = dwelling.GetCreaturePool();

	for(i = 0; i < creatureData.Length; i++)
	{
		if(i == 0)
			creatures = "<font color='" $ replColor $ "'>" $ creatureData[i].Reserve $ "</font>x" @ creatureData[i].Creature.GetName() @ "(+" $ "<font color='" $ replColor $ "'>" $ creatureData[i].Income $ "</font>" @ class'H7Loca'.static.LocalizeSave("TT_PER_WEEK","H7General") $ ")";
		else
			creatures = creatures $ "\n" $ "<font color='" $ replColor $ "'>" $ creatureData[i].Reserve $ "</font>x" @ creatureData[i].Creature.GetName() @ "(+" $ "<font color='" $ replColor $ "'>" $ creatureData[i].Income $ "</font>" @ class'H7Loca'.static.LocalizeSave("TT_PER_WEEK","H7General") $ ")";
	}
	
	dwellingObj.SetString("Creatures", "<font size='#TT_POINT#'>" $ creatures $ "</font>");
	dwellingObj.SetString("Name", dwelling.GetName());
	dwellingObj.SetString("Description", dwelling.GetLord() != none ? class'H7Loca'.static.LocalizeSave("TT_DWELLING","H7General") : class'H7Loca'.static.LocalizeSave("TT_DWELLING_NO_LORD","H7General"));
 	
	if(dwelling.GetLord()!=none && H7CustomNeutralDwelling(dwelling) == none) 
 		dwellingObj.SetString("BelongsTo", Repl(class'H7Loca'.static.LocalizeSave("TT_BELONGS_TO","H7General"),"%aocLord", "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ dwelling.GetLord().GetName() $ "</font>") );

	if(H7CustomNeutralDwelling(dwelling) != none)
		dwellingObj.SetString("Description", class'H7Loca'.static.LocalizeSave("TT_CUSTOM_NEUTRAL_DWELLING","H7AdvMapObjectToolTip"));

	AddPlayerInfo(dwellingObj, dwelling.GetPlayer());

	data.objData = dwellingObj;
}

function H7TooltipData BuildTooltipItemPile(H7ItemPile itemPile)
{
	local H7TooltipData data;
	local array<H7HeroItem> items;
	local H7EditorHero lookingHero;

	items = itemPile.GetItems();
	if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none
		&& class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().IsHero())
	{
		lookingHero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	}

	data.type = TT_TYPE_ITEM;
	data.objData = CreateItemObject(items[0],lookingHero);

	return data;
}

function H7TooltipData BuildTooltipBuildingBuffable(H7VisitableSite site)
{
	local H7TooltipData data;
	local GFxObject buffArray,TempObj;
	local array<H7BaseBuff> buffs;
	local H7BaseBuff buff;
	local int i;

	data.type = TT_TYPE_BUILDING_BUFFABLE;
	data.objData = CreateObject("Object");

	buffArray = CreateArray();
	i = 0;
	site.GetBuffManager().GetActiveBuffs(buffs);

	foreach buffs(buff)
	{
		if( buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs())
		{
			TempObj = CreateObject("Object");
			TempObj.SetBool( "BuffIsDisplayed", buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
			TempObj.SetBool( "BuffIsDebuff", buff.IsDebuff() );
			TempObj.SetString( "BuffName", buff.GetName() ); 
			TempObj.SetString( "BuffTooltip", buff.GetTooltip() );
			TempObj.SetString( "BuffIcon", buff.GetFlashIconPath() );
			TempObj.SetInt( "BuffDuration", buff.GetDuration() );
			buffArray.SetElementObject(i, TempObj);
			i++;
			;
		}
	}
	data.objData.SetObject("buffs",buffArray); 
	data.objData.SetString("Title",H7ITooltipable(site).GetTooltipData().Title );
	data.objData.SetString("strData",H7ITooltipable(site).GetTooltipData().strData );
	data.objData.SetString("Description", H7ITooltipable(site).GetTooltipData().Description);

	if(site.GetPlayer().GetPlayerNumber() != PN_NEUTRAL_PLAYER)
		AddPlayerInfo(data.objData, site.GetPlayer());
	
	return data;
}

function H7TooltipData BuildTooltipBattleSite(H7BattleSite battleSite, bool advanced)
{
	local H7TooltipData data;
	local GFxObject obj, armyObj;

	data.type = TT_TYPE_BATTLESITE;
	obj = CreateObject("Object");
	obj.SetString("Name", battleSite.GetName());
	AddThreatInfo(obj, battleSite.GetGarrisonArmy());	
	armyObj = CreateArmyObject(battleSite.GetGarrisonArmy(), true);
	obj.SetObject("Army",armyObj); 
	obj.SetObject("Rewards", GetBattleSiteRewardsObject(none, battleSite));
	if(battleSite.IsMultiHero())
		obj.SetBool("AlreadyLootedByHero", battleSite.WasLootedByCurrentHero());
	else
		obj.SetBool("IsLooted", battleSite.IsLooted());
	obj.SetBool("Advanced", advanced);
	if(advanced) obj.SetString("Desc", battleSite.GetDescription());
	else
	{
		data.addRightMouseIcon = true;
	}
	data.objData = obj;
	return data;
}
