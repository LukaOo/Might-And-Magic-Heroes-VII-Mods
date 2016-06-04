//=============================================================================
// H7AiUtilityRecruitmentScore
//=============================================================================
// ...
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiUtilityRecruitmentScore extends H7AiUtilityCombiner;

var H7AiUtilityPoolGarrison             mInUPoolGarrison;
var H7AiUtilityTownDistanceCombined     mInUTownDistance;
var H7AiUtilityGameDayOfWeek            mInUGameDayOfWeek;


/// overrides ...
function UpdateInput()
{
	local array<float> poolGarrison;
	local array<float> townDistance;
	local array<float> gameDOW;
	local float        recruitmentScore;

//	`LOG_AI("Utility.RecruitmentScore");

    if( mInUPoolGarrison == None ) { mInUPoolGarrison = new class 'H7AiUtilityPoolGarrison'; }
    if( mInUTownDistance == None ) { mInUTownDistance = new class 'H7AiUtilityTownDistanceCombined'; }
    if( mInUGameDayOfWeek == None ) { mInUGameDayOfWeek = new class 'H7AiUtilityGameDayOfWeek'; }

	mInValues.Remove(0,mInValues.Length);

	mInUGameDayOfWeek.UpdateInput();
	mInUGameDayOfWeek.UpdateOutput();
	gameDOW = mInUGameDayOfWeek.GetOutValues();

	mInUPoolGarrison.UpdateInput();
	mInUPoolGarrison.UpdateOutput();
	poolGarrison = mInUPoolGarrison.GetOutValues();

	mInUTownDistance.UpdateInput();
	mInUTownDistance.UpdateOutput();
	townDistance = mInUTownDistance.GetOutValues();

	// they all should return exactly 1 result but better make sure first before proceeding
	if( poolGarrison.Length >= 1 && townDistance.Length >= 1 && gameDOW.Length >= 1 )
	{
		// CreatureRecruitmentPriority = uDangerLevel * uTownPosition * uCreaturePool
		recruitmentScore = poolGarrison[0] * townDistance[0] * (1.0f-gameDOW[0]);

//		`LOG_AI("  ED"@enemyDistance[0]@"PG"@poolGarrison[0]@"TD"@townDistance[0]@"GD"@gameDOW[0]@"=>"@recruitmentScore);

		if(recruitmentScore>0.0f)
		{
			mInValues.AddItem(recruitmentScore);
		}
	}
}

function UpdateOutput()
{
	ApplyFunction();
	ApplyOutputWeigth();
}

/// functions

