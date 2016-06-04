//=============================================================================
// H7AiSensorOpportunity
//=============================================================================
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorOpportunity extends H7AiSensorBase;

/// overrides ...

function float GetValue1( H7AiSensorParam param0 )
{
	local H7CombatMapCell   cell;
	cell = param0.GetCMapCell();
	if( param0.GetPType() == SP_CMAPCELL )
	{
		 return cell.GetOpportunity();
	}
	// wrong parameter types
	return 0.0f;
}


