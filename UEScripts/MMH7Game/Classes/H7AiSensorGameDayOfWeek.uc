//=============================================================================
// H7AiSensorGameDayOfWeek
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorGameDayOfWeek extends H7AiSensorBase;

/// overrides ...

function float GetValue0( )
{
	local int day;
	day = class'H7AdventureController'.static.GetInstance().GetCalendar().GetCalendarDay();
	if( day<=1 ) return 0.5f;
	if( day==2 ) return 1.0f;
	if( day==3 ) return 0.5f;
	if( day==4 ) return 0.4f;
	if( day==5 ) return 0.3f;
	if( day==6 ) return 0.2f;
	return 0.1f;
}
