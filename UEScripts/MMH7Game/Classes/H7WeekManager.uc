//=============================================================================
// WeekManager
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7WeekManager extends Object
native
	savegame;


var protected savegame array<string>    mAvailableWeeks;
var protected H7Week                    mCurrentWeek;
var protected H7Week                    mDefaultWeek;
var protected H7week                    mUpcomingWeek;
var protected savegame int              mDelay;
var protected savegame array<string>    mPreviousWeeks;
var protected savegame string           mCurrentWeekRef;
var protected savegame string           mUpcomingWeekRef;
var protected savegame string           mDefaultWeekRef;



function H7Week     GetCurrentWeek()    { return mCurrentWeek; } 
function H7Week     GetUpcomingWeek()  { return mUpcomingWeek; }

function Init(array<string> availableWeeks, string defaultStartingWeek)
{
	mDelay = availableWeeks.Length / 3;
	mAvailableWeeks = availableWeeks;

	mCurrentWeek = PickNewWeek(true, defaultStartingWeek);
	//mPreviousWeeks.AddItem( PathName( mCurrentWeek ) );
	mUpcomingWeek = PickNewWeek();
	mCurrentWeek.OnInit( class'H7AdventureController'.static.GetInstance().GetCalendar() );
}

function H7Week PickNewWeek(optional bool isDefaultWeek = false, optional string defaultWeekClass)
{
	local int randomIndex, weekCount;
	local H7Week week,weekclass; 

	if( mAvailableWeeks.Length <= 0 )
	{
		if (H7Week(DynamicLoadObject(mCurrentWeekRef, class'H7Week')) != H7Week(DynamicLoadObject(mDefaultWeekRef, class'H7Week') ) ) 
		{
			mAvailableWeeks.AddItem( mCurrentWeekRef );
		}
		else 
		{
			;
			return new class'H7Week';
		}
	}

	if( isDefaultWeek && defaultWeekClass != "" )
	{
		mDefaultWeekRef = defaultWeekClass;
		weekclass = H7Week( DynamicLoadObject( defaultWeekClass, class'H7Week') );
		week = new weekclass.Class(weekclass);
		mDefaultWeek = week;
	}
	else
	{
		while( weekclass == none && weekCount < mAvailableWeeks.Length )
		{
			randomIndex = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mAvailableWeeks.Length );
			weekclass = H7Week(DynamicLoadObject(mAvailableWeeks[randomIndex], class'H7Week'));
			++weekCount;
		}

		if( weekclass == none )
		{
			week = new class'H7Week';
			;
		}
		else
		{
			week = new weekclass.Class(weekclass);
			mAvailableWeeks.Remove(randomIndex,1);
		}
	}

	return week;
}


function UpdateweekEvents(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container)
{
	mCurrentWeek.GetEventManager().Raise(triggerEvent, simulate, container);
}

function UpdatePreviousWeeks()
{
	if(mPreviousWeeks.Length > 0 &&  mPreviousWeeks.Length >= mDelay )
	{
		if( class'H7AdventureController'.static.GetInstance().GetCalendar().GetCalendarWeek() > 1 )  // frist weeks drops out
		{
			mAvailableWeeks.AddItem( mPreviousWeeks[0] );
			mPreviousWeeks.Remove(0,1); // top
		}
		
	}
}


function NextWeek()
{
	local H7Week UpcomingWeek;
	UpcomingWeek = PickNewWeek();
	mCurrentWeek.DeleteAllInstanciatedEffects();  // remove all effects for the old week
	
	// we dont want the start week back in the pool
	if( mCurrentWeek != mDefaultWeek )
		mPreviousWeeks.AddItem( PathName(mCurrentWeek) );
	
	mCurrentWeek = mUpcomingWeek;
	mCurrentWeek.OnInit( class'H7AdventureController'.static.GetInstance().GetCalendar() );
	mUpcomingWeek = UpcomingWeek;
   
	UpdatePreviousWeeks();
}


/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function JSonObject Serialize()
{
	local JSonObject JSonObject;
	local int i;

	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	if (JSonObject == None)
	{
		;
		return JSonObject;
	}

	JsonObject.SetStringValue("CurrentWeek", PathName(mCurrentWeek));
	JsonObject.SetStringValue("UpcomingWeek", PathName(mUpcomingWeek));
	
	JsonObject.SetIntValue("NumOfPreviousWeeks", mPreviousWeeks.Length);

	for (i = 0; i <  mPreviousWeeks.Length; i++)
	{
		JsonObject.SetStringValue("PreviousWeek"$i, mPreviousWeeks[i]);
	}

	// Send the encoded JSonObject
	return JSonObject;
}

event PostSerialize()
{
	local H7Week template;
	template = H7Week(DynamicLoadObject(mCurrentWeekRef, class'H7Week'));
	mCurrentWeek = new class'H7Week'( template );
	mCurrentWeek.OnInit( class'H7AdventureController'.static.GetInstance().GetCalendar() );
	template = H7Week(DynamicLoadObject(mUpcomingWeekRef, class'H7Week') );
	mUpcomingWeek = new class'H7Week'( template );
	template = H7Week(DynamicLoadObject(mDefaultWeekRef, class'H7Week') );
	mDefaultWeek = new class'H7Week'(template );
}


function Deserialize(JSonObject Data)
{
	local string currentArchetype;
	local int NumOfPrevWeeks, i;

	mCurrentWeek =  H7Week(DynamicLoadObject(Data.GetStringValue("CurrentWeek"), class'H7Week'));
	mUpcomingWeek = H7Week(DynamicLoadObject(Data.GetStringValue("UpcommingWeek"), class'H7Week'));
	mDefaultWeek =  H7Week(DynamicLoadObject(Data.GetStringValue("UpcommingWeek"), class'H7Week'));
	mPreviousWeeks.Length = 0;

	NumOfPrevWeeks = Data.GetIntValue("NumOfPreviousWeeks");

	for(i = 0; i < NumOfPrevWeeks; i++)
	{
		currentArchetype = Data.GetStringValue("PreviousWeek"$i);
		mPreviousWeeks.AddItem(currentArchetype);
	}
}


// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
