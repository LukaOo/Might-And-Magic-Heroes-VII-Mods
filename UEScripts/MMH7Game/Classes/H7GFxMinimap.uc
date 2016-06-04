/*=============================================================================
* H7GFxMinimap
* =============================================================================
* Small representational overview of the adventuremap.
* =============================================================================
* TODO: QUESTS
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* =============================================================================*/

class H7GFxMinimap extends H7GFxUIContainer;


const                               FIELD_OF_VIEW = 50.0f;

var protected H7MinimapNative               mNative;
var protected H7AdventureGridManager		mGridManager;
var protected H7AdventureController         mAdvCntl;
var protected GFxObject                     mData;
var protected GFxObject                     mPath;
var protected GFxObject                     mGridWrapper;
var protected GFxObject                     mGrids;

var protected array<Vector2D>               mCurrentFrustumData;

var protected int                           mLastGridIndex;

var Array<H7AdventureHero>                  mHeroList;
var Array<H7Caravan>                        mCaravanList; 
var Array<H7VisitableSite>                  mVisitableList;

var array<Actor>                            mUnprocessedActors;

var Array<H7IQuestTarget>                   mMovableQuestTargets;
var Array<GFxObject>                        mGFxQuests;

//Frustum
var protected H7Camera                      mGameCam;

var protected PostProcessChain              mPostProcessChain;
var protected array<Actor>					mHiddenActors;

var protected bool                          bInitialized;
var protected bool                          bAreaOfControlOnce;


var private int                             mMaxAOCDepth;
var private int                             mAOCIterationCount;

var protected bool                          bQuestLogMode;

// hotkey helper
var protected bool                          mExtensionsVisible;

var protected bool                          mPendingVisibilityUpdate;

function ForceReset()
{
	bInitialized = false;
	Update();
}

function int GetWidth()
{
	if(!bQuestLogMode) return 290;
	else return 500;
}

function Actor GetActor(int id)
{
	local int i;

	for(i = 0; i < mHeroList.Length; i++)
	{
		if(mHeroList[i].GetID() == id)
		{
			return mHeroList[i]; 
		}
	}
	for(i = 0; i < mVisitableList.Length; i++)
	{
		if(mVisitableList[i].GetID() == id) 
		{
			return mVisitableList[i]; 
		}
	}
	for(i = 0; i < mCaravanList.Length; i++)
	{
		if(mCaravanList[i].GetID() == id) 
		{
			return mCaravanList[i]; 
		}
	}
	return none;
}

function ActivateTreasure()
{
	GetObject("mMinimapExtension").ActionScriptVoid("ActivateTreasure");
}

/**
 * Should be called whenever something (map-related) changes, initializes Minimap on its own
 */
function Update()
{
	if( bInitialized )
	{
		UpdateVisibility();
	} 
	else
	{
		Initialize();
	}

	if(mGridManager.GetCurrentGrid().GetIndex() != mLastGridIndex)
	{
		mLastGridIndex  =   mGridManager.GetCurrentGrid().GetIndex();
		UpdateBackground();
		mData.SetInt("currentGridLayer"     , mGridManager.GetCurrentGrid().GetIndex());
	}	

	if( mGridManager.IsFogOfWarUsed() )
	{
		if(true) //If there is vivaldi information about FOW
		{
			UpdateFogOfWar();
		}
		else
		{
			DrawFoWRect(0 ,0 , mGridManager.GetCurrentGrid().GetGridSizeX(), mGridManager.GetCurrentGrid().GetGridSizeY());
		} 
	}

	UpdateMoveableQuestTargets();	

	SetObject( "mData" , mData );	 

	ActionScriptVoid( "Update" );
}

/**
  * Creates basic structures for ActionScript, Background and AreaOfControl
  */
protected function Initialize()
{
	local array<H7AdventureMapGridController> allGrids;
	local int i;
	local GFxObject someGrid;

	bInitialized = true;
	mGridManager         = class'H7AdventureGridManager'.static.GetInstance();
	mAdvCntl             = class'H7AdventureController'.static.GetInstance();
	allGrids             = mGridManager.GetAllGrids();
	mGameCam             = class'H7Camera'.static.GetInstance();
	if(mNative == none) mNative = new class'H7MinimapNative';

	mData                = CreateObject("Object");
	mPath                = CreateObject("Object");
	mGridWrapper         = CreateObject("Object");
	mGrids               = CreateArray();

	for (i = 0; i < allGrids.Length; i++ )
	{
		someGrid = CreateObject("Object");
		someGrid.SetInt("MapWidth" , allGrids[i].GetGridSizeX());
		someGrid.SetInt("MapHeight", allGrids[i].GetGridSizeY());
		mGrids.SetElementObject(i, someGrid);
	}
	mGridWrapper.SetObject("mGrids", mGrids);
	SetObject( "mGridWrapper", mGridWrapper ); 

	mData.SetInt("currentGridLayer"     , mGridManager.GetCurrentGrid().GetIndex());
	
	UpdateBackground();
	UpdateAreaOfControl();

	AddUnproccessedActors();

	mExtensionsVisible = false;
}

function AddUnproccessedActors()
{
	local Actor unprocessedActor;
	foreach mUnprocessedActors(unprocessedActor)
	{
		;
		if(unprocessedActor.IsA('H7VisitableSite'))
		{
			AddVisitableSite(H7VisitableSite(unprocessedActor));
		}
		else if(unprocessedActor.IsA('H7AdventureHero'))
		{
			AddHero(H7AdventureHero(unprocessedActor));
		}
		else
		{
			;
		}
	}
}

/** Updates a hero's icon-position to its current cell-location */
function HeroMoved(H7AdventureHero hero)
{
	local IntPoint heroPos;
	heroPos = hero.GetCell().GetCellPosition();
	UpdateIconGridPos( hero.GetID(), heroPos.X, heroPos.Y, hero.GetCell().GetGridOwner().GetIndex() );
}

/** Updates a ship's icon-position to its current cell-location */
function ShipMoved(H7Ship ship)
{
	local IntPoint shipPos;
	local H7AdventureMapCell cell;
	cell = mGridManager.GetCellByWorldLocation( ship.Location );
	shipPos = cell.GetCellPosition();
	UpdateIconGridPos( ship.GetID(), shipPos.X, shipPos.Y, cell.GetGridOwner().GetIndex() );
} 

/** Updates a minimap-icon by ID to its new coordinates and grid-ID */
function UpdateIconGridPos(int iconID,int newX,int newY, int layer)
{
	ActionScriptVoid("UpdateIconGridPos");
}

/////////////////////////////////////////
/////// QUEST HIGHLIGHT//////////////////
/////////////////////////////////////////

/** Long lost feature to indicate quest-locations on the minimap at given position */
function CreateQuestHighlight(int posX, int posY, int gridIdx)
{
	;
	ActionScriptVoid("CreateQuestHighlight");
}

function SetQuestLogMode(bool val, float mapX, float mapY, float mapWidth, float mapHeight)
{
	bQuestLogMode = val;
	   
	ActionScriptVoid("SetQuestLogMode");
}

/*
 *  A player can have W quests, with X objectives, with Y conditions at Z locations! 
 *  But we only add one quest, so 
 *  we start with the objectives
 *  and give them multiple conditions
 *  at multiple locations
 */
function AddQuestTracker(H7SeqAct_Quest_NewNode quest, H7SeqAct_QuestObjective objective, H7IQuestTarget questTarget)
{
	if( questTarget.IsMovable() ) 
	{
		mMovableQuestTargets.AddItem(questTarget);
	}

	quest.SetTracked(true);

	AddQuestIcon(	questTarget.GetQuestTargetID(),                                                                     // int  targetID
					quest.GetID(),                                                                                      // string questID //<- this is weird    
					questTarget.GetCurrentPosition().GetGridPosition().X,                                               // int  posX
					questTarget.GetCurrentPosition().GetGridPosition().Y,												// int  posY
					questTarget.GetCurrentPosition().GetGridOwner().GetIndex(),											// int  gridLayer
					quest.GetPlayerNumber(),																			// int  playerNum
					false,																				                // we don't care if target is hidden (under fog) you always see the marker
					quest.IsTracked(),																					// bool tracked
					"img://" $ PathName(class'H7GUIGeneralProperties'.static.GetInstance().mButtonIcons.mQuestTracked),	// string iconPath
					objective.GetDescription()																			// string description
					);

	UpdateMoveableQuestTargets();
}

// adds the info to flash array + set visibility + set position
function AddQuestIcon(int targetID,string questID, int posX, int posY, int gridLayer, int playerNum, bool bHidden, bool tracked, string iconPath, string description)
{
	;
	ActionScriptVoid("AddQuestIcon");
}

function RemoveQuestIcon(int targetID)
{
	;
	ActionScriptVoid("RemoveQuestIcon");
}

/* A player can have W quests (questIdx), with X objectives, with Y conditions at Z locations! */
function EditQuestTrackStatus( string wantedQuestID, bool tracked )
{
	;

	ActionScriptVoid("EditQuestTrackStatus");
}

// in case it moved?
function EditQuestIcon(int targetID, int posX, int posY, int gridLayer, bool bHidden)
{
	ActionScriptVoid("EditQuestIcon");
}

// why are non-moveable icons never hidden/shown?
function UpdateMoveableQuestTargets()
{	
	local H7IQuestTarget questTarget;
	foreach mMovableQuestTargets(questTarget)
	{
		if(questTarget.GetCurrentPosition() == none)
		{
			;
			continue;
		}
		EditQuestIcon(questTarget.GetQuestTargetID(),                                                                 // int  targetID
					  questTarget.GetCurrentPosition().GetGridPosition().X,                                           // int  posX
					  questTarget.GetCurrentPosition().GetGridPosition().Y,                                           // int  posY
					  questTarget.GetCurrentPosition().GetGridOwner().GetIndex(),                                     // int  gridLayer
					  questTarget.IsHidden()                                                                          // bool bHidden
					  );
	}
	ActionScriptVoid("UpdateMoveableQuestTargets");
} 

/////////////////////////////////////////
//////// MINIMAP BACKGROUND /////////////
/////////////////////////////////////////

function SetBackground(string path)
{
	;
	ActionScriptVoid("SetBackground");
}

function UpdateBackground()
{
	local H7AdventureMapGridController currentGrid;

	if(!bInitialized)
	{
		return;
	}

	currentGrid = mGridManager.GetCurrentGrid();
	if(currentGrid != none && currentGrid.mMinimapCapture != none)
	{
		SetBackground("img://" $ PathName(currentGrid.mMinimapCapture));
	}
	else
	{
		SetBackground("img://None");
	}
}


/////////////////////////////////////////
//////// MINIMAP AOC        /////////////
/////////////////////////////////////////

function SetAoC(string path) // OPTIONAL this is called by Camera SetCurrentGridByPos every frame, investigate if needed
{
	//`log_dui("SetAoC" @ path);
	ActionScriptVoid("SetAoC");
}

function UpdateAreaOfControl( optional bool generateTexture = true )
{
	local H7AdventureMapGridController currentGrid;
	local Texture2DDynamic aocTexture;

	if(!bInitialized)
	{
		return;
	}

	currentGrid = mGridManager.GetCurrentGrid();
	if( generateTexture )
	{
		currentGrid.GenerateAOCTexture(); // TODO only call when conquer change and on Init
	}
	aocTexture = currentGrid.GetAOCTexture();

	if(currentGrid != none && aocTexture != none)
	{
		SetAoC("img://" $ PathName(aocTexture));
	}
	else
	{
		SetAoC("img://None");
	}
}


/////////////////////////////////////////
//////// ICON CREATION //////////////////
/////////////////////////////////////////

/** Sends data for new minimap-icon to flash (flash creates the icon) 
 *  @param type     Important for minimap-filters, valid types are: fort town dwelling mine shipyard entry teleporter neutral hero caravan ship artifact
 *  @param id       Important for tooltips (on hover) and moving/hiding already existent icons (UpdateVisibility)
 *  @param iconPath The path for the image-file in flash (e.g. img://H7TextureGUI.icon_Minimap_Hero )
 *  @param posX     horizontal cell-coordinate
 *  @param posY     vertical cell-coordinate
 *  @param bHidden  Should the icon stay hidden (garrisoned, StaticMesh is hidden ...)
 *  @param red      0-255
 *  @param green	0-255
 *  @param blue	    0-255
 */
protected function CreateIcon(string type,int id,string iconPath,int posX, int posY, bool bHidden, int gridLayer, int red, int green, int blue)
{
	;
	
	// on the first frame or in cases where there is a pending update, we can set icons to invisible to reduce first frame rendering
	// they are eventually turned on by UpdateVisibilityDo 1 frame later (in the same frame? then this is not really useful)
	// if there is no pending update we use the real visibility
	if(mPendingVisibilityUpdate)
	{
		bHidden = true; 
	}

	ActionScriptVoid("CreateNewIcon");
}

// informs the minimap that there is an object (with an minimap icon?)
// heroes-armies / caravans get their own function
/** Adds new icon for specific H7VisitableSite(shipyard, entry, teleporter or the like) to the minimap, if it is not offgrid (carefull! multiple icons possible! ) */
function AddVisitableSite(H7VisitableSite visitableSite)
{
	local H7AdventureMapCell currentCell;
	local Color currentColor;
	local string type;
	local IntPoint tmpPoint;
	local H7AreaOfControlSite aocSite;

	if(!bInitialized)
	{
		;
		mUnprocessedActors.AddItem(visitableSite);
		return;
	}
	//`log_minimap("    AddVisitableSite"@visitableSite@"ID:"@visitableSite.GetID() );

	if(mVisitableList.Find(visitableSite) != INDEX_NONE)
	{
		;
		return;
	}

	currentColor = visitableSite.GetColor();
	currentCell = visitableSite.GetEntranceCell();
	if(currentCell == none) 
	{
		;
		return; //Off-grid-objects won't receive a Minimap-icon!
	}
	if( visitableSite.GetHasMinimap() )
	{
		tmpPoint = currentCell.GetCellPosition();
			
		if(H7Shipyard(visitableSite) != None)
		{
			type = "shipyard";
		}
		else if(H7Ship(visitableSite) != None)
		{
			type = "ship";
		}
		else if(H7Teleporter(visitableSite) != None)
		{
			if(H7Stairway(visitableSite) != none)
			{
				type = "entry";
			}
			else
			{
				type = "teleporter";
			}
		}
		else if(H7Keymaster(visitableSite) != none || H7KeymasterGate(visitableSite) != none)
		{
			type = "altarseal";
		}
		else if(H7ItemPile(visitableSite) != none)
		{
			type = "artifact";
			//mArtifactList.AddItem(H7ItemPile(visitableSite));
		}
		else if(H7AreaOfControlSite(visitableSite) != none)
		{
			aocSite = H7AreaOfControlSite(visitableSite);
			//mAoCList.AddItem(aocSite);
			if(H7Fort(aocSite) != None)
			{
				type = "fort";
			}
			else if(H7Town(aocSite) != None)
			{
				type = "town";
			}
			else if(H7CustomNeutralDwelling(aocSite) != None)
			{
				type = "neutral";
			}
			else if(H7Dwelling(aocSite) != None)
			{
				type = "dwelling";
			}
			else if(H7Mine(aocSite) != None)
			{
				type = "mine";
			}
			else if(H7Garrison(aocSite) != none)
			{
				type = "garrison";
			}
			else 
			{
				;
				type = "unknown";
			}
		}
		else
		{
			type = "neutral";
		}

		;
		CreateIcon(type, visitableSite.GetID(), visitableSite.GetFlashMinimapPath(),
					tmpPoint.X, tmpPoint.Y,
					visitableSite.bHidden || mGridManager.GetCellByWorldLocation( visitableSite.Location ).GetGridOwner() != mGridManager.GetCurrentGrid(), 
					visitableSite.GetEntranceCell().GetGridOwner().GetIndex(),
					currentColor.R,	currentColor.G,	currentColor.B
					);

		mVisitableList.AddItem(visitableSite);
	}
}

/** Adds new icon for specific hero to the minimap, if it does not already have one. */
function AddHero(H7AdventureHero newHero)
{
	local H7AdventureMapCell cell;
	local Color col;

	//`log_minimap("    ADDhero"@newHero@"ID:"@newHero.GetID()@"Name:"@newHero.GetName() );

	if(!bInitialized)
	{
		;
		mUnprocessedActors.AddItem(newHero);
		return;
	}

	if(newHero == None || newHero.GetID() == 0 || !newHero.IsHero()) 
	{
		;
		return;
	}

	if(mHeroList.Find(newHero) != INDEX_NONE)
	{
		;
		return;
	}

	mHeroList.AddItem(newHero);
	col = newHero.GetAdventureArmy().GetPlayer().GetColor();
	cell = mGridManager.GetCellByWorldLocation( newHero.Location );
	if( cell != none )
	{
		CreateIcon("hero", newHero.GetID(), newHero.GetFlashMinimapPath()
					,cell.GetCellPosition().X, cell.GetCellPosition().Y,
					newHero.GetAdventureArmy().bHidden,
					cell.GetGridOwner().GetIndex(),
					col.R, col.G, col.B
					);
	}
	else
	{
		CreateIcon("hero", newHero.GetID(), newHero.GetFlashMinimapPath(),
					-1,-1,
					newHero.GetAdventureArmy().bHidden,
					-1,
					col.R, col.G, col.B
					);
	}
}

/** Adds new icon for specific caravan to the minimap, if it does not already have one. */
function AddCaravan(H7Caravan newCaravan)
{
	local Color col;

	//`log_minimap("    ADDcaravan"@newCaravan@"ID:"@newCaravan.GetID() );

	if(newCaravan == None) 
	{
		;
		return;
	}

	if(mCaravanList.Find(newCaravan) == -1)
	{
		mCaravanList.AddItem(newCaravan);
	
		col = newCaravan.GetPlayer().GetColor();
		CreateIcon("caravan", newCaravan.GetID(), newCaravan.GetFlashMinimapPath(),
					newCaravan.GetGridPosition().X, newCaravan.GetGridPosition().Y,
					newCaravan.bHidden,
					newCaravan.GetCell().GetGridOwner().GetIndex(),
					col.R, col.G, col.B
					);
	} 
	else 
	{
		;// @ newCaravan.GetHero().GetID());
	}
}

/////////////////////////////////////////
/////////// FOG OF WAR //////////////////
/////////////////////////////////////////

////////////////////////
// Recursive Quadtree //
////////////////////////

function SetFog(string path)
{
	//`log_dui("SetFog" @ path);
	ActionScriptVoid("SetFog");
}

/** Sets the texture into flash */
private function UpdateFogOfWar()
{
	local H7FOWController   fowController;
	local Texture2DDynamic  fogTexture;
	
	if(! bInitialized) { ; return; }
	if(mAdvCntl.GetLocalPlayer(true) == none) { ; return; }

	fowController = mGridManager.GetCurrentGrid().GetFOWController();
	if( fowController != none )
	{
		fogTexture = fowController.GetFogTexture();
		//`log_dui("fowController.GetFogTexture()" @ fogTexture.SizeX @ fogTexture.SizeY);
		SetFog("img://" $ PathName( fogTexture ));
	}
}

/** Draws a single rectangular in flash onto the minimap */
private function DrawFoWRect(int posX, int posY, int rectWidth, int rectHeight)
{
	Actionscriptvoid("drawFoWRect");
}

/** Resets the Fog Of War on the minimap */
function ResetFog()
{
	if( mGridManager.IsFogOfWarUsed() )
	{
		if(true) //If there is vivaldi information about FOW (steve meant 'valid')
		{
			UpdateFogOfWar();
		}
		else
		{
			DrawFoWRect(0 ,0 , mGridManager.GetCurrentGrid().GetGridSizeX(), mGridManager.GetCurrentGrid().GetGridSizeY());
		}
	} 
	else
	{
		Actionscriptvoid("clearFoW");
	}
}

function UpdateVisibility()
{
	mPendingVisibilityUpdate = true;
}

function CheckUpdateVisibility() // called every frame
{
	if(mPendingVisibilityUpdate) UpdateVisibilityDo();
	mPendingVisibilityUpdate = false;
}

/** Updates the position, color and hidden-property of all icons,
 *  also removing artifact's icons that are looted, calls UpdateAreaOfControl! (gets called quite a lot lately) */
function UpdateVisibilityDo()
{
	local H7AdventureHero       currentHero;
	local H7VisitableSite       currentSite;
	local H7Caravan             currentCaravan;
	local Color                 currentColor;

	//`LOG_MINIMAP("UpdateVisibility");

	mData.SetInt("currentGridLayer" , mGridManager.GetCurrentGrid().GetIndex());
	
	foreach mHeroList(currentHero)
	{
		currentColor = currentHero.GetAdventureArmy().GetPlayer().GetColor();
		UpdateIconVisibility(currentHero.GetID(),
							 currentHero.bHidden || ( H7AdventureArmy(currentHero.GetArmy()) != none && H7AdventureArmy(currentHero.GetArmy()).IsDead()) || mGridManager.GetCellByWorldLocation( currentHero.Location ).GetGridOwner() != mGridManager.GetCurrentGrid(),
							 mGridManager.GetCellByWorldLocation( currentHero.Location ).GetGridOwner().GetIndex(),
							 currentColor.R, currentColor.G, currentColor.B
							);
	}

	foreach mVisitableList(currentSite)
	{
		if(currentSite.GetEntranceCell() == none) ;
		if(currentSite.IsA('H7ItemPile') && H7ItemPile(currentSite).IsLooted())
		{
			RemoveIcon(currentSite.GetID());
			continue;
		}
		currentColor = currentSite.GetColor();
		UpdateIconVisibility(currentSite.GetID(),
							currentSite.IsHidden() || currentSite.bHidden || mGridManager.GetCellByWorldLocation( currentSite.Location ).GetGridOwner() != mGridManager.GetCurrentGrid(),
							currentSite.GetEntranceCell().GetGridOwner().GetIndex(),
							currentColor.R, currentColor.G, currentColor.B
							);
	}

	foreach mCaravanList(currentCaravan)
	{
		currentColor = currentCaravan.GetPlayer().GetColor();
		UpdateIconVisibility(currentCaravan.GetID(),
							 currentCaravan.bHidden || mGridManager.GetCellByWorldLocation( currentCaravan.Location ).GetGridOwner() != mGridManager.GetCurrentGrid(),
							 mGridManager.GetCellByWorldLocation( currentCaravan.Location ).GetGridOwner().GetIndex(),
							 currentColor.R, currentColor.G, currentColor.B
							 );
	}

	ActionScriptVoid("UpdateQuests"); // UpdateQuestIconVisibility();
}

/** Updates a single icon by ID, for hidden-property, color and if it's on the right grid
 *  @param id generic id of the corresponding object 
 *  @param hidden if the icon should stay hidden (override) e.g. kismet-scripted as hidden
 *  @param gridLayer index of the gridLayer the object is currently on
 */
private function UpdateIconVisibility(int id, bool hidden, int gridLayer ,optional int red=-1, optional int green=-1, optional int blue=-1)
{
	ActionScriptVoid("UpdateIconVisibility");
}

/** Removes single icon from the minimap 
 *  @param id generic id of the corresponding object 
 */
public function RemoveIcon(int id)
{
	ActionScriptVoid("RemoveIcon");
}

/////////////////////////////////////////
////////////// FRUSTUM //////////////////
/////////////////////////////////////////

/** Computes the player's view-frustum on minimap */
//by quadrouple raytracing the screen's edges onto grid-origin heighted plane
//TODO: use the Canvas version where possible as it already has the necessary information, whereas this function must gather it and is therefore slower ( http://wiki.beyondunreal.com/UE3:LocalPlayer_%28UDK%29#DeProject )
function ComputeMinimapFrustum()
{
	local LocalPlayer localPlayer;
	local Vector gridLoc;  //viewTargetLoc;
	local Vector worldOrigin, worldDirection;
	local Vector hitLocation;
	local Vector2D viewportSize, myScreenPos;
	local GFxObject frustumArray;
	local GFxObject frustumCorner;
	local array<Vector2D> frustumData;
	local Vector2D frustumCornerData;
	local int i;

	if(! bInitialized ) { ; return; }

	localPlayer = class'H7PlayerController'.static.GetLocalPlayer();
	
	if( localPlayer != None && localPlayer.ViewportClient != None )
	{
		gridLoc = mGridManager.GetCurrentGrid().Location;
		gridLoc.Z = class'H7Camera'.static.GetInstance().GetCurrentVRP().Z;
		// Get the deprojection coordinates from the screen location
		localPlayer.ViewportClient.GetViewportSize( viewportSize );

		//BottomLeft
		myScreenPos.x = 0.0;
		myScreenPos.y = 1.0;
		localPlayer.DeProject( myScreenPos, worldOrigin, worldDirection );
		class'H7Math'.static.LinePlaneIntersection(worldOrigin, worldOrigin + worldDirection * 66666, gridLoc * Vect(0,0,1) ,Vect(0,0,1), hitLocation);

		frustumCornerData.X = (hitLocation.X - gridLoc.X) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumCornerData.Y = (hitLocation.Y - gridLoc.Y) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumData.AddItem(frustumCornerData);

		//BottomRight
		myScreenPos.x = 1.0;
		myScreenPos.y = 1.0;
		localPlayer.DeProject( myScreenPos, worldOrigin, worldDirection );
		class'H7Math'.static.LinePlaneIntersection(worldOrigin, worldOrigin + worldDirection * 66666, gridLoc * Vect(0,0,1) ,Vect(0,0,1),hitLocation);
		
		frustumCornerData.X = (hitLocation.X - gridLoc.X) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumCornerData.Y = (hitLocation.Y - gridLoc.Y) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumData.AddItem(frustumCornerData);

		//TopRight
		myScreenPos.x = 1.0;
		myScreenPos.y = 0.0;
		localPlayer.DeProject( myScreenPos, worldOrigin, worldDirection );
		class'H7Math'.static.LinePlaneIntersection(worldOrigin, worldOrigin + worldDirection * 66666, gridLoc * Vect(0,0,1) ,Vect(0,0,1),hitLocation);
		
		frustumCornerData.X = (hitLocation.X - gridLoc.X) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumCornerData.Y = (hitLocation.Y - gridLoc.Y) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumData.AddItem(frustumCornerData);

		//TopLeft
		myScreenPos.x = 0.0;
		myScreenPos.y = 0.0;
		localPlayer.DeProject( myScreenPos, worldOrigin, worldDirection );
		class'H7Math'.static.LinePlaneIntersection(worldOrigin, worldOrigin + worldDirection * 66666, gridLoc * Vect(0,0,1) ,Vect(0,0,1),hitLocation);
			
		frustumCornerData.X = (hitLocation.X - gridLoc.X) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumCornerData.Y = (hitLocation.Y - gridLoc.Y) / class'H7EditorCombatGrid'.const.CELL_SIZE;
		frustumData.AddItem(frustumCornerData);		
	}

	if(!IsFrustumDataEqual(frustumData))
	{
		if(frustumArray == none)
		{
			frustumArray = CreateArray();
			SetObject("mFrustum", frustumArray);
		}
		for(i=0;i<frustumData.Length;i++)
		{
			frustumCorner = frustumArray.GetElementObject(i);
			if(frustumCorner == none)
			{
				frustumCorner = CreateObject("Object");
				frustumArray.SetElementObject(i, frustumCorner);
			}
			frustumCorner.SetFloat("x",frustumData[i].X);
			frustumCorner.SetFloat("y",frustumData[i].Y);
		}
		ActionScriptVoid("drawFrustum");
		mCurrentFrustumData = frustumData;
	}
}

function bool IsFrustumDataEqual(array<Vector2D> frustumData)
{
	local int i;
	if(mCurrentFrustumData.Length != frustumData.Length) return false;
	for(i=0;i<frustumData.Length;i++)
	{
		if(frustumData[i].X != mCurrentFrustumData[i].X || frustumData[i].Y != mCurrentFrustumData[i].Y)
		{
			return false;
		}
	}
	return true;
}

/** Lets a certain AoC start pulsing to show something interesting */
// functionality got lost with AoC refactor OPTIONAL restore
function HighlightAoC(int aocIdx)
{
	return;
	ActionScriptVoid("HighlightAoC");
}

/** Stops a highlight-pulse */
function UnHighlightAoC()
{
	return;
	ActionScriptVoid("UnHighlightAoC");
}



/////////////////////////////////////////
////// HOTKEY HELPER FUNCTIONS //////////
/////////////////////////////////////////

function ToggleMinimapOptions() // TODO if toggled in flash mExtensionsVisible is never set
{
	if(mExtensionsVisible)
		CloseExtension();
	else
		OpenExtension();

	mExtensionsVisible = !mExtensionsVisible;
}

function SetPopupMode(bool val)
{
	ActionScriptVoid("SetPopupMode");
}

function CloseExtension()
{
	ActionScriptVoid("CloseExtension");
}

function OpenExtension()
{
	ActionScriptVoid("OpenExtension");
}

/////////////////////////////////////////
////////////// CARAVAN //////////////////
/////////////////////////////////////////
/** Shows a path from start-AoC-site to end-AoC-site on the minimap*/
function ShowPathAoC2AoC(H7AreaOfControlSite start, H7AreaOfControlSite end)
{
	ShowPathC2C(start.GetEntranceCell(), end.GetEntranceCell());
}

/** Shows a path from a startCell to a targetCell */
function ShowPathC2C(H7AdventureMapCell startCell, H7AdventureMapCell targetCell)
{
	local GFxObject                 allGFxCells;
	local GFxObject                 someCell;

	local array<H7AdventureMapCell> allPathCells;
	local H7AdventureMapCell        pathCell;

	local int i;

	allGFxCells = CreateArray();

	allPathCells = mGridManager.GetPathfinder().GetPath(startCell, targetCell, mAdvCntl.GetLocalPlayer(), false);

	// Unreal to GFxConversion
	i = 0;
	foreach allPathCells(pathCell)
	{
		someCell = CreateObject("Object");
		someCell.SetInt("posX", pathCell.GetCellPosition().X);
		someCell.SetInt("posY", pathCell.GetCellPosition().Y);
		someCell.SetInt("currentGridIndex", mGridManager.GetCurrentGrid().GetIndex() );
		allGFxCells.SetElementObject(i, someCell);
		i++;
	}

	mData.SetInt("currentGridLayer"     , mGridManager.GetCurrentGrid().GetIndex());
	mPath.SetObject( "allGFxCells", allGFxCells );
	SetObject( "mPath" , mPath );	
	ActionScriptVoid("ShowPath");
}

/** Deletes the visuals for ShowPathC2C(startCell, targetCell) */
function DeletePath()
{
	ActionScriptVoid("DeletePath");
} 

function DisableMe()
{
	ActionScriptVoid("Disable");
}

function EnableMe()
{
	ActionScriptVoid("Enable");
}

/** Shows future path of a hovered caravan on the minimap */
function HoverCaravan(int id, bool val=true)
{
	local H7CaravanArmy         caravan;
	local array<H7CaravanArmy>  allCaravans;

	if(!val)
	{
		DeletePath();
		return;
	}

	allCaravans = class'H7AdventureController'.static.GetInstance().GetCurrentCaravanArmies();

	foreach allCaravans(caravan)
	{
		if(caravan.GetCaravan().GetID() == id)
		{
			ShowPathC2C( caravan.GetCell(), caravan.GetTargetLord().GetEntranceCell() );
			return;
		}
	}
}

/** Wether the player has the townscreen currently open */
function UpdateCameraMode(bool activeTownscreen)
{
	ActionScriptVoid("SetTownScreen");
}

