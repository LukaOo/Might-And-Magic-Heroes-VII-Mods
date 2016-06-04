//=============================================================================
// H7Calendar
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Calendar extends Object implements ( H7ICaster )
hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
native
	savegame;

var protected savegame int				mCalendarYear;
var protected savegame int				mCalendarMonth;
var protected savegame int				mCalendarWeek;
var protected savegame int				mCalendarDay;
var protected savegame int				mMaxMonthPerYear;
var protected savegame int				mMaxWeeksPerMonth;
var protected savegame int				mMaxDaysPerWeek;
var protected savegame int				mID;
var protected H7AdventureController		mAdventureController;
var protected H7ScriptingController		mScriptingController;
var protected savegame array<H7Month>	mMonth;
var protected savegame H7WeekManager	mWeekManager;   
var protected savegame int              mDaysPassed;

function String                     GetName()										{}
function H7EffectManager            GetEffectManager()								{}
function                            DataChanged(optional String cause)				{}

function                            PrepareAbility(H7BaseAbility ability)			{}
function                            UsePreparedAbility(H7IEffectTargetable target)  {}
function H7BaseAbility              GetPreparedAbility()                            {}
function ECommandTag                GetActionID( H7BaseAbility ability )            {}
function int                        GetDaysPassed()                                 { return mDaysPassed; }

function float GetMinimumDamage(){	}
function float GetMaximumDamage(){	}
function int GetAttack(){}
native function int GetLuckDestiny(); //{  }
function int GetMagic(){   }
function int GetStackSize(){    }
function EAbilitySchool GetSchool() {  }
native function int GetID();
function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) {}

native function EUnitType           GetEntityType()                                 {}
native function H7CombatArmy		GetCombatArmy()									{}
native function H7AbilityManager	GetAbilityManager()								{}
native function H7BuffManager       GetBuffManager()                                {}
native function bool                IsDefaultAttackActive()                         {}
native function Vector              GetLocation()                                   {}
native function IntPoint            GetGridPosition()                               {}
native function H7Player            GetPlayer()                                     {}

native function H7ICaster           GetOriginal()                                   {}

native function H7EventManager      GetEventManager();
function H7WeekManager              GetWeekManager()              { return mWeekManager; }

function int                          GetCalendarYearForGUI()       { return GetStartYear()==0?0:mCalendarYear; } // starts in legends, always in legends
function int                          GetCalendarYear()             { return mCalendarYear; }
function int                          GetCalendarMonth()            { return mCalendarMonth; }
function int                          GetCalendarWeek()             { return mCalendarWeek; }
function int                          GetCalendarDay()              { return mCalendarDay; } 
function int                          GetWeeksPassed()              { return mCalendarWeek + mCalendarMonth*mMaxWeeksPerMonth + mCalendarYear*mMaxMonthPerYear*mMaxWeeksPerMonth; }

function H7Week                       GetCurrentWeek()              { return mWeekManager.GetCurrentWeek(); }
function H7Week                       GetNextWeek()                 { return mWeekManager.GetUpcomingWeek(); }

function int GetStartYear()
{
	local H7CampaignDefinition thecampaign;
	// find campaign
	thecampaign = class'H7AdventureController'.static.GetInstance().GetCampaign();
	if(thecampaign != none)
	{
		return thecampaign.GetYearOfMap(class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName());
	}
	return -1;
}

function                              SetCalendarYear(int year)     { mCalendarYear = year; }
function                              SetCalendarMonth(int month)   { mCalendarMonth = month; }
function                              SetCalendarWeek(int week)     { mCalendarWeek = week; }
function                              SetCalendarDay(int day)       { mCalendarDay = day; }
function H7Month GetCurrentMonth()  
{ 
	return mMonth[mCalendarMonth-1];
}

function init()
{
	local int i;
	local array<string> months;
	local array<string> weeks;
	local string forbiddenWeekName;

	mAdventureController = class'H7AdventureController'.static.GetInstance();
	mScriptingController = class'H7ScriptingController'.static.GetInstance();

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		mDaysPassed = 0;
		mMaxMonthPerYear = mAdventureController.GetConfig().mMaxMonthPerYear;
		mMaxWeeksPerMonth = mAdventureController.GetConfig().mMaxWeeksPerMonth;
 		mMaxDaysPerWeek = mAdventureController.GetConfig().mMaxDayPerWeek;

		months = mAdventureController.GetConfig().mMonth;

		for( i=0;i<months.Length;++i)
		{
			mMonth.AddItem( H7Month( DynamicLoadObject( months[i], class'H7Month' ) ) );
		}
		mWeekManager = new class'H7WeekManager'();

		weeks = mAdventureController.GetConfig().mWeeks;
		// Exlude weeks that are forbidden in the map info
		foreach mAdventureController.GetMapInfo().mForbiddenWeeks (forbiddenWeekName)
		{
			//The fully qualified object name requires adding class name
			forbiddenWeekName = ("H7Week'") $ forbiddenWeekName $ ("'");
			weeks.RemoveItem(forbiddenWeekName);
		}
		mWeekManager.Init(weeks, mAdventureController.GetConfig().mDefaultStartingWeek);
	}
}

function InitializeGameStartWeek()
{
	GetCurrentWeek().OnInit( self );
	UpdateWeekEvents( ON_BEGIN_OF_DAY, false );
	mAdventureController.UpdateEvents( ON_BEGIN_OF_WEEK );
	UpdateWeekEvents( ON_BEGIN_OF_WEEK, false );
}

function UpdateWeekEvents(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container)
{
	mWeekManager.UpdateweekEvents( triggerEvent, simulate, container );
}

function NextDay()
{
	DayPassed();
	mCalendarDay++;
	DayStart();
	mDaysPassed++;
	if( mCalendarDay > mMaxDaysPerWeek)
	{
		mCalendarDay=1;
		NextWeek();
	}
}

function NextWeek()
{
	WeekPassed();
	mCalendarWeek++;
	mWeekManager.NextWeek();
	
	WeekStart();
	if( mCalendarWeek > mMaxWeeksPerMonth )
	{
		mCalendarWeek = 1;
		NextMonth();
	}
}

function NextMonth()
{
	mCalendarMonth++;
	if( mCalendarMonth > mMaxMonthPerYear )
	{
		mCalendarMonth=1;
		NextYear();
	}
}

function NextYear()
{
	mCalendarYear++;
}

function DayPassed()
{
	UpdateWeekEvents( ON_END_OF_DAY, false );

	if( class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		class'H7DestructibleObjectManipulator'.static.CountDownForAll();
	}
	mScriptingController.UpdateTurn(EH7SeqCondUpdateTurnPeriod_Day);
}

function DayStart()
{
	UpdateWeekEvents( ON_BEGIN_OF_DAY, false );

	if( mAdventureController.GetConfig().mEnableDailyGrowth )
	{
		mAdventureController.ProduceUnitsForSites();
	}
	mAdventureController.ProduceDayUnits();
}


function WeekPassed()
{
	class'H7AdventureArmy'.static.ClearAllArmyNegotiationData();
	mAdventureController.UpdateEvents( ON_END_OF_WEEK );
	UpdateWeekEvents( ON_END_OF_WEEK, false ) ;
	mScriptingController.UpdateTurn(EH7SeqCondUpdateTurnPeriod_Week);
}

function WeekStart()
{
	mAdventureController.UpdateEvents( ON_BEGIN_OF_WEEK );
	UpdateWeekEvents( ON_BEGIN_OF_WEEK, false );
	if( !mAdventureController.GetConfig().mEnableDailyGrowth )
	{
		mAdventureController.ProduceUnitsForSites();
	}

	mAdventureController.UpdatePlayerPlunder();
	mAdventureController.ResetBuildingStateWeekly();

	class'H7AdventureArmy'.static.GrowEveryCritterArmy();
}

function string GetTotalPlayTimeString()
{
  	local int daysPerYear, daysPassed;
	local int weeks, months, years;
	local String time;

	daysPassed = mDaysPassed;
    daysPerYear = mMaxDaysPerWeek * mMaxWeeksPerMonth * mMaxMonthPerYear;

	years = FFloor(float(daysPassed / daysPerYear));
	if(years >= 1) daysPassed = daysPassed % (daysPerYear * years);

	months = FFloor(float(daysPassed / (mMaxDaysPerWeek * mMaxWeeksPerMonth)));
	if(months >= 1) daysPassed = daysPassed % ((mMaxDaysPerWeek * mMaxWeeksPerMonth) * months);

	weeks = FFloor(float(daysPassed / mMaxDaysPerWeek));
	if(weeks >= 1) daysPassed = daysPassed % (mMaxDaysPerWeek * weeks);

	time = class'H7Loca'.static.LocalizeSave("TOTAL_PLAY_TIME","H7General");// $":" @ daysPassed @ 
	time = Repl( time,"%d", daysPassed );
	time = Repl( time,"%w", weeks );
	time = Repl( time,"%m", months );
	time = Repl( time,"%y", years );

	return time;
}

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function JSonObject Serialize()
{
	local JSonObject JSonObject;
	
	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	if (JSonObject == None)
	{
		;
		return JSonObject;
	}

	JsonObject.SetIntValue( "Year", mCalendarYear );
	JsonObject.SetIntValue( "Month", mCalendarMonth );
	JsonObject.SetIntValue( "Week", mCalendarWeek );
	JsonObject.SetIntValue( "Day", mCalendarDay );
	JSonObject.SetObject( "WeekManager", mWeekManager.Serialize() );
	
	// Send the encoded JSonObject
	return JSonObject;
}


/**
 * Deserializes the actor from the data given
 *
 * @param    Data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject Data)
{
	mCalendarYear = Data.GetIntValue( "Year" );
	mCalendarMonth = Data.GetIntValue( "Month" );
	mCalendarWeek = Data.GetIntValue( "Week" );
	mCalendarDay = Data.GetIntValue( "Day" );

	mWeekManager.Deserialize(Data);	
}

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame){}


