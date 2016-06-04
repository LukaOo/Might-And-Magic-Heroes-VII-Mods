//=============================================================================
// H7GFxInitiativeList
//
// Wrapper for InitiativeList.as
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxInitiativeList extends H7GFxUIContainer;

var GFxObject mData;
var array<String> mMapping; // this array points to mData, so that we don't have to read mData directly (expensive)
var array<int> mUnitsSendToFlash;

function InitList( )                            {	ActionscriptVoid("InitList");               }
function Update( )                              {	ActionscriptVoid("Update");                 }
function AnimateList()                          {	ActionScriptvoid("AnimateList");            }
function SetHightLight( int id )                {   ActionscriptVoid("SetHightLight");          }
function SetDehightLight( int id )              {	ActionscriptVoid("SetDehightLight");        }
function SetSelect( int id )                    {	ActionscriptVoid("SetSelect");              }
function SetDeselect( int id )                  {	ActionscriptVoid("SetDeselect");            }
function EnableTurn( bool val )                 {   ActionscriptVoid("EnableTurn");             }
function DisplayTurnAnimation(string turnName)
{
	ActionscriptVoid("DisplayTurnAnimation");
}

// causes the next SetInitiativeInfo to send fullData slots
function ResetInitiativeInfo()
{
	mData = none;
	mMapping.Length = 0;
	mUnitsSendToFlash.Length = 0;
}

function SetInitiativeInfo()
{
	;

	if(mData == none)
	{
		mData = CreateFullList();
		SetObject( "mData" , mData);
		InitList();
	}
	else
	{
		mData = CreateOrderList();
		SetObject( "mData" , mData);
	}

	Update();
	AnimateList();
}

// used for full list and order list
function array<H7Unit> GetCurrentTurnUnits()
{
	local array<H7Unit> heroList,waitingCreatureList,initiativeQueue,finalList;
	
	//heroes_normal + units_normal
	initiativeQueue = class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetInitiativeQueue();
	;
	//units_waiting
	waitingCreatureList = class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetWaitingUnitStack();
	;
	//heroes_waiting
	heroList = class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetActiveHeroList();
	;

	finalList = class'H7GameUtility'.static.Concatenate_Units(initiativeQueue,waitingCreatureList);
	finalList = class'H7GameUtility'.static.Concatenate_Units(finalList,heroList);
	//finalList = DoubleUnits(finalList,false); // removed by design 11245

	return finalList;
}

function array<H7Unit> GetNextTurnUnits()
{
	local array<H7Unit> finalList;

	finalList = class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetPrevQueue();
	//finalList = DoubleUnits(finalList,true); // removed by design 11245

	return finalList;
}

function array<H7Unit> DoubleUnits(array<H7Unit> singleList,bool future)
{
	local array<H7Unit> doubleList;
	local H7Unit unit;
	local int moral;

	foreach singleList(unit)
	{
		doubleList.AddItem(unit);

		if(unit.IsA('H7CreatureStack'))
		{
			moral = H7CreatureStack(unit).GetMorale();
		}
		else if(unit.IsA('H7CombatHero'))
		{
			moral = H7CombatHero(unit).GetDestiny();
		}
		else
		{
			moral = 0;
		}
		if((moral >= 100 && (future || !unit.IsMoralTurn())) || unit.GetAttackCount() > 1 || unit.GetMoveCount() > 1)
		{
			doubleList.AddItem(unit);
		}
	}

	return doubleList;
}

// full list for init of combat start
function GFxObject CreateFullList()
{
	local GFxObject iniList;
	local int providerIndex; 
	local array<H7Unit> initiativeQueue;
	local GFxObject TempObj;
	local int projectedTurnCounter;
	
	iniList = CreateArray();
	
	projectedTurnCounter = Max( class'H7CombatController'.static.GetInstance().GetCurrentTurn() + 1 , 2); // current turn can be 0
	
	// current turn
	initiativeQueue = GetCurrentTurnUnits();
	providerIndex = CopyList( initiativeQueue       , iniList , 0 , 0 , projectedTurnCounter-1);
	
	// turn icon
	;
	TempObj = CreateObject("Object");
	TempObj.SetString( "Turn", "TurnIcon" );
	TempObj.SetString( "TurnNumber", string(projectedTurnCounter) );
	TempObj.SetString( "SlotID", string(projectedTurnCounter) );
	iniList.SetElementObject(providerIndex, TempObj);
	providerIndex++;

	// next turn
	initiativeQueue = GetNextTurnUnits();
	providerIndex = CopyList( initiativeQueue       , iniList , 0 , providerIndex , projectedTurnCounter,true);
	
	// hack crap fill
	while(providerIndex < 12)
	{
		projectedTurnCounter += 1;

		;
		TempObj = CreateObject("Object");
		TempObj.SetString( "Turn", "TurnIcon" );
		TempObj.SetString( "TurnNumber", string(projectedTurnCounter) );
		TempObj.SetString( "SlotID", string(projectedTurnCounter) );
		iniList.SetElementObject(providerIndex, TempObj);
		providerIndex++;

		;

		providerIndex = CopyList( initiativeQueue       , iniList , 0 , providerIndex , projectedTurnCounter,true, (12-providerIndex));
	}
	
	return iniList;
}

/// Helper Function
// creates a GFxObject list out of a H7Unit list
function int CopyList( array<H7Unit> sourceList, out GFxObject targetList, int sourceStartIndex, int targetStartIndex, int turn,optional bool future,int sourceEndIndex=-1,bool fullData=true)
{
	local int i,targetListInsertI,multicounter;
	local String slotID; 
	local GFxObject TempObj;
	
	if(sourceEndIndex == -1) sourceEndIndex = sourceList.Length;

	targetListInsertI = targetStartIndex;
	for ( i = sourceStartIndex; i < sourceEndIndex ; ++i) 
	{
		if(i >= sourceList.Length) break;

		multiCounter = 1;
		if(i > 0 && sourceList[i-1].GetID()==sourceList[i].GetID())
		{
			multiCounter++;
		}
		else if(!future)
		{
			multiCounter=class'H7CombatController'.static.GetInstance().GetInitiativeQueue().GetActedCount(sourceList[i])+1;
		}

		slotID = turn $ "_" $ sourceList[i].GetID() $ "#" $ multiCounter;

		if(fullData || IsNewUnit(sourceList[i]))
		{
			TempObj = BuildFullDataSlot(sourceList[i],slotID,future);
			mUnitsSendToFlash.AddItem(sourceList[i].GetID());
			mMapping[targetListInsertI] = "null"; // we need to kill the link because it no longer points to a order slot it would now point to a fulldata slot
			;
			//`LOG_GUI("SLOTflash " @ slotID @ "GetID=" @ TempObj.GetID() @ sourceList[i].GetName() @ sourceList[i].GetStackSize() @ "ini" $ sourceList[i].GetInitiative() @ " -> " @ targetListInsertI);
		}
		else
		{
			TempObj = BuildOrderSlot(sourceList[i],slotID,future);
			mMapping[targetListInsertI] = slotID;
			;
			//`LOG_GUI("ORDERSLOTF " @ ".SlotID" @ TempObj.GetString("SlotID")  @ ".UnrealID" @ TempObj.GetString("UnrealID") @ ".Initiative" @ TempObj.GetString("Initiative") );
		}

		targetList.SetElementObject(targetListInsertI, TempObj);
		targetListInsertI++;
	}
	
	return targetListInsertI;
}

// summoned unit
function bool IsNewUnit(H7Unit unit)
{
	return mUnitsSendToFlash.Find(unit.GetID()) == INDEX_NONE;
}

function GFxObject BuildFullDataSlot(H7Unit unit,String slotID,bool future)
{
	local GFxObject TempObj;
	local GFxObject colorObject;
	local Color unrealColor;
	local EUnitType unitType;

	TempObj = CreateObject("Object");

	if(unit == none) 
	{
		;
		return TempObj;
	}
		
	unitType = unit.GetEntityType();

	if( unit.GetEntityType() == UNIT_CREATURESTACK)
	{
		TempObj.SetString( "IconPath", H7CreatureStack(  unit ).GetCreature().GetFlashIconPath()  );
		TempObj.SetInt( "Initiative",  unit.GetInitiative() );
		if(class'H7CombatController'.static.GetInstance().IsLocalPlayerSpectator())
		{
			TempObj.SetInt( "StackSize", 0 );
		}
		else
		{
			TempObj.SetInt( "StackSize", H7CreatureStack( unit ).GetStackSize());
		}
		TempObj.SetInt( "InitiativeDisplay",  unit.GetInitiative() );
		TempObj.SetBool( "IsAttacker", unit.IsAttacker() );
		TempObj.SetBool("HasActiveAbilities", H7CreatureStack(unit).GetAbilityManager().HasActiveAbilities());
		unrealColor = H7CreatureStack(unit).GetStackColor();
	}
	else if( unit.GetEntityType() == UNIT_HERO )
	{
		TempObj.SetString( "UnitName", unit.GetName() );
		TempObj.SetString( "IconPath", H7CombatHero(  unit ).GetFlashIconPath() );
		TempObj.SetInt( "Initiative",  unit.GetInitiative() );
		TempObj.SetInt( "InitiativeDisplay",  unit.GetInitiative() );
		TempObj.SetBool( "IsAttacker", unit.IsAttacker() );
		TempObj.SetInt( "Level", H7CombatHero(unit).GetLevel() );
		TempObj.SetBool( "IsMight", H7CombatHero(unit).IsMightHero() );

		TempObj.SetInt( "Mana", H7CombatHero(unit).GetCurrentMana() );
		TempObj.SetInt( "ManaMax", H7CombatHero(unit).GetMaxMana() );
		TempObj.SetInt( "ManaPct", (float(H7CombatHero(unit).GetCurrentMana()) / float(H7CombatHero(unit).GetMaxMana()) * 100) );
			
		TempObj.SetInt( "Mana", H7CombatHero(unit).GetCurrentMana() );
		TempObj.SetInt( "ManaMax", H7CombatHero(unit).GetMaxMana() );
		TempObj.SetInt( "ManaPct", (float(H7CombatHero(unit).GetCurrentMana()) / float(H7CombatHero(unit).GetMaxMana()) * 100) );
			
		TempObj.SetInt( "Movement", H7CombatHero(unit).GetCurrentMovementPoints() );
		TempObj.SetInt( "MovementMax", H7CombatHero(unit).GetMovementPoints() );

		//causes Turn Item to change Color to player Color
		unrealColor = H7CombatHero(unit).GetCombatArmy().GetPlayer().GetColor();
	}
	else if( unit.GetEntityType() == UNIT_WARUNIT )
	{
		TempObj.SetString( "UnitName", unit.GetName() );
		TempObj.SetString( "IconPath", H7WarUnit(  unit ).GetFlashIconPath() );
		TempObj.SetInt( "Initiative",  unit.GetInitiative() );
		TempObj.SetInt( "InitiativeDisplay",  unit.GetInitiative() );
		TempObj.SetBool( "IsAttacker", unit.IsAttacker() );

		//causes Turn Item to change Color to player Color
		unrealColor = H7WarUnit(unit).GetCombatArmy().GetPlayer().GetColor();
	}
	else if( unit.GetEntityType() == UNIT_TOWER )
	{
		TempObj.SetString( "UnitName", unit.GetName() );
		TempObj.SetString( "IconPath", H7TowerUnit(  unit ).GetFlashIconPath() );
		TempObj.SetInt( "Initiative",  unit.GetInitiative() );
		TempObj.SetInt( "InitiativeDisplay",  unit.GetInitiative() );
		TempObj.SetBool( "IsAttacker", unit.IsAttacker() );

		//causes Turn Item to change Color to player Color
		unrealColor = unit.GetCombatArmy().GetPlayer().GetColor();
	}

	TempObj.SetInt( "UnrealID", unit.GetID() );
	TempObj.SetString( "SlotID", slotID );
	TempObj.SetString( "UnitType", String(unitType) );
	TempObj.SetBool( "Waiting",  future?false:class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsAWaitingUnit(unit) );
		
	AttachBuffList( unit, TempObj, 0, false );

	colorObject = CreateObject("Object");
	colorObject.SetInt("r",unrealColor.R);
	colorObject.SetInt("g",unrealColor.G);
	colorObject.SetInt("b",unrealColor.B);
	TempObj.SetObject("Color", colorObject);	

	return TempObj;
}

// attaches buffs of unit to object
function int AttachBuffList( H7Unit unit, out GFxObject object, optional int i, optional bool withBuffTooltip = true)
{
	local GFxObject dataProviderBuffs,TempObj;
	local H7BaseBuff buff;
	local array<H7BaseBuff> buffs;

	if( unit == none ) return 0;
		
	dataProviderBuffs = CreateArray();
	unit.GetBuffManager().GetActiveBuffs(buffs);
	
	foreach buffs(buff)
	{
		// animationup/down+tooltips permanentPortraitOverlay
		if( buff.IsDisplayed() || buff.IsOverPortrait() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs())
		{
			TempObj = CreateObject("Object");
			TempObj.SetBool( "BuffIsDisplayed", buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
			TempObj.SetBool( "BuffIsOverPortrait", buff.IsOverPortrait() );
			TempObj.SetBool( "BuffIsDebuff", buff.IsDebuff() );
			TempObj.SetString( "BuffName", buff.GetName() ); 
			if(withBuffTooltip)
			{
				TempObj.SetString( "BuffTooltip", buff.GetTooltip() );
			}
			else
			{
				TempObj.SetString( "BuffTooltip", "" );
			}
			TempObj.SetString( "BuffIcon", buff.GetFlashIconPath() );
			TempObj.SetInt( "BuffDuration", buff.GetCurrentDuration() );
			dataProviderBuffs.SetElementObject(i, TempObj);
			i++;
		}
	}
	object.SetObject("Buffs", dataProviderBuffs);
		
	return i;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Performance List & Order
///////////////////////////////////////////////////////////////////////////////////////////////////

function int GetOrderSlotIndex(String slotID)
{
	local String mappingEntry;
	local int i;
	i = 0;
	foreach mMapping(mappingEntry)
	{
		if(mappingEntry == slotID)
		{
			return i;
		}
		i++;
	}
	return -1;
}

function GFxObject GetOrderSlot(String slotID)
{
	local int i;
	i = GetOrderSlotIndex(slotID);
	if(i == -1)
	{
		;
		return none;
	}
	else
	{
		//`log_dui("using old mData order-data-object at index"@i);
		return mData.GetElementObject(i);
	}
}

// limited time-saving version of CreateInitiveObject()
function GFxObject CreateOrderList()
{
	local GFxObject iniList;
	local int providerIndex; 
	local array<H7Unit> initiativeQueue;
	local GFxObject TempObj;
	local int projectedTurnCounter;

	iniList = CreateArray();

	projectedTurnCounter = Max( class'H7CombatController'.static.GetInstance().GetCurrentTurn() + 1 , 2); // current turn can be 0
	
	// current turn
	initiativeQueue = GetCurrentTurnUnits();
	providerIndex = CopyList( initiativeQueue, iniList , 0 , 0 , projectedTurnCounter-1,false,-1,false);

	// turn icon
	;
	TempObj = CreateObject("Object");
	TempObj.SetString( "Turn", "TurnIcon" );
	TempObj.SetString( "TurnNumber", string(projectedTurnCounter) );
	TempObj.SetString( "SlotID", string(projectedTurnCounter) );
	iniList.SetElementObject(providerIndex, TempObj);
	mMapping[providerIndex] = string(projectedTurnCounter);
	providerIndex++;

	// next turn
	initiativeQueue = GetNextTurnUnits();
	providerIndex = CopyList( initiativeQueue       , iniList , 0 , providerIndex , projectedTurnCounter, true , -1 , false);
	
	// hack crap fill
	while(providerIndex < 12)
	{
		projectedTurnCounter += 1;

		;
		TempObj = CreateObject("Object");
		TempObj.SetString( "Turn", "TurnIcon" );
		TempObj.SetString( "TurnNumber", string(projectedTurnCounter) );
		TempObj.SetString( "SlotID", string(projectedTurnCounter) );
		iniList.SetElementObject(providerIndex, TempObj);
		mMapping[providerIndex] = string(projectedTurnCounter);
		providerIndex++;

		;

		providerIndex = CopyList( initiativeQueue       , iniList , 0 , providerIndex , projectedTurnCounter,true, (12-providerIndex) , false);
	}

	return iniList;
}

// should not be used to build order slot for unit that has not been seen yet, BuildFullDataSlot instead
function GFxObject BuildOrderSlot(H7Unit unit,String slotID,bool future)
{
	local GFxObject TempObj;
	local bool waiting;
	local int initiative;
	
	waiting = (future?false:class'H7CombatController'.static.GetInstance().GetInitiativeQueue().IsAWaitingUnit(unit));
	initiative =  future?unit.GetNextInitiative():unit.GetInitiative();

	//`log_dui("Mapping state before searching for" @ slotID);
	//for(i=0;i<mMapping.Length;i++)
	//{
	//	`log_dui("          " @ i @ mMapping[i] @ "actual data: " @ mData.GetElementObject(i).GetString("SlotID") );
	//}

	TempObj = GetOrderSlot(slotID);
	if(TempObj == none) // order slot did not exist yet, create it
	{
		;
		TempObj = CreateObject("Object");
		TempObj.SetInt( "UnrealID", unit.GetID() );
		TempObj.SetString( "SlotID", slotID );
	}

	// update old order slot or fill in data of new order slot
	TempObj.SetInt( "Initiative", initiative); 
	if(class'H7CombatController'.static.GetInstance().IsLocalPlayerSpectator())
	{
		TempObj.SetInt( "InitiativeDisplay", 0 );
	}
	else
	{
		TempObj.SetInt( "InitiativeDisplay", initiative );
	}
	TempObj.SetBool( "Waiting", waiting );
	return TempObj;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// Performance increased with targeted updates
///////////////////////////////////////////////////////////////////////////////////////////////////

// informs the GUI that a unit had stack size changes
function UpdateStackSize( H7Unit unit)
{
	local GFxObject TempObj;
	
	TempObj = CreateObject("Object");
	TempObj.SetInt( "UnrealID", unit.GetID() );
	if(class'H7CombatController'.static.GetInstance().IsLocalPlayerSpectator())
	{
		TempObj.SetInt( "StackSize", 0 );
	}
	else
	{
		TempObj.SetInt( "StackSize", H7CreatureStack( unit ).GetStackSize() );
	}
	SetObject( "mChangedUnit" , TempObj);
	UpdateUnitStackSize(); 
}
function UpdateUnitStackSize()
{
	ActionScriptVoid("UpdateUnitStackSize");
}

// informs the GUI that a unit was skipped (bad moral)
function UpdateSkip( H7Unit unit)
{
	local GFxObject TempObj;
	
	TempObj = CreateObject("Object");
	TempObj.SetInt( "UnrealID", unit.GetID() );
	TempObj.SetString( "SlotID", class'H7CombatController'.static.GetInstance().GetCurrentTurn() $ "_" $ unit.GetID());
	TempObj.SetBool( "Skip", true );
	SetObject( "mChangedUnit" , TempObj);
	UpdateUnitSkip(); 
}
function UpdateUnitSkip()
{
	ActionScriptVoid("UpdateUnitSkip");
}

// informs the GUI that a unit (hero) did an action
function UpdateAction( H7Unit unit , H7HeroAbility action)
{
	local GFxObject TempObj;
	
	;

	TempObj = CreateObject("Object");
	TempObj.SetInt( "UnrealID", unit.GetID() );
	TempObj.SetString( "SlotID", class'H7CombatController'.static.GetInstance().GetCurrentTurn() $ "_" $ unit.GetID());
	TempObj.SetString( "ActionIcon", action.GetFlashIconPath() );
	TempObj.SetString( "ActionIconTooltip", "Hero did:" @ action.GetName() ); // special specialbuff
	SetObject( "mChangedUnit" , TempObj);
	UpdateUnitAction(); 
}
function UpdateUnitAction()
{
	ActionScriptVoid("UpdateUnitAction");
}

// informs the GUI that a hero had mana changes
function UpdateHeroManaOf( H7CombatHero hero)
{
	local GFxObject TempObj;

	if(hero == none)
	{
		return;
	}
	
	TempObj = CreateObject("Object");
	TempObj.SetInt( "UnrealID", hero.GetID() );
	TempObj.SetInt( "Mana", hero.GetCurrentMana() );
	TempObj.SetInt( "ManaMax", hero.GetMaxMana() );
	if(hero.GetMaxMana() > 0)
	{
		TempObj.SetInt( "ManaPct", (float(hero.GetCurrentMana()) / float(hero.GetMaxMana()) * 100) );
	}
	SetObject( "mChangedUnit" , TempObj);
	UpdateHeroMana(); 
}
function UpdateHeroMana()
{
	ActionScriptVoid("UpdateHeroMana");
}

// informs the GUI that a unit had buff changes
function UpdateBuffs( H7Unit unit , optional bool withBuffTooltips )
{
	local GFxObject TempObj;
	
	if( unit == none ) return;
	if( !IsVisible() ) return;

	TempObj = CreateObject("Object");
	TempObj.SetInt( "UnrealID", unit.GetID() );
	AttachBuffList(unit,TempObj,0,withBuffTooltips);
	SetObject( "mChangedUnit" , TempObj);
	UpdateUnitBuffs(); 
}

function UpdateUnitBuffs()
{
	ActionScriptVoid("UpdateUnitBuffs");
}


// hacks

function SelectSpellbookButton(optional bool val=true)
{
	ActionScriptVoid("SelectSpellbookButton");
}

function SelectAttackButton(optional bool val=true)
{
	ActionScriptVoid("SelectAttackButton");
}

// reset

function Reset()
{
	ActionScriptVoid("Reset");
}

// Default properties block
