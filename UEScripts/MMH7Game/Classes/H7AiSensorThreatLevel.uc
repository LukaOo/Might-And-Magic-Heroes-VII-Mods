//=============================================================================
// H7AiSensorThreatLevel
//=============================================================================
//
// implements: GetValue1(GridCell)
//             => +1.0 highest threat (enemies around)
//             =>  0.0 neutral threat (can not be reached by anyone)
//             => -1.0  lowest threat (friendlies around)
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorThreatLevel extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0 )
{
	local H7CombatMapCell   cell;
	cell = param0.GetCMapCell();
	if( param0.GetPType() == SP_CMAPCELL )
	{
		 return cell.GetThreat();
	}
	// wrong parameter types
	return 0.0f;
}


