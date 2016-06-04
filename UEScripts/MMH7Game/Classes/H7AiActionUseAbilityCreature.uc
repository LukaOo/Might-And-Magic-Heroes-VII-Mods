//=============================================================================
// H7AiActionUseAbilityCreature
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionUseAbilityCreature extends H7AiActionBase;

var protected H7AiUtilityCrAbilityAcidBreath            mUAcidBreath;
var protected H7AiUtilityCrAbilitySolderingHands        mUSolderingHands;
var protected H7AiUtilityCrAbilityMagicAbsorption       mUMagicAbsorption;
var protected H7AiUtilityCrAbilityResurrection          mUResurrection;
var protected H7AiUtilityCrAbilityPiercingShot          mUPiercingShot;
var protected H7AiUtilityCrAbilityFeralCharge           mUFeralCharge;
var protected H7AiUtilityCrAbilityBackstab              mUBackstab;
var protected H7AiUtilityCrAbilityCharge                mUCharge;
var protected H7AiUtilityCrAbilityEntanglingRoots       mUEntanglingRoots;
var protected H7AiUtilityCrAbilityFatalStrike           mUFatalStrike;
var protected H7AiUtilityCrAbilityFieryEye              mUFieryEye;
var protected H7AiUtilityCrAbilityInspiringPresence     mUInspiringPresence;
var protected H7AiUtilityCrAbilityLifeDrain             mULifeDrain;
var protected H7AiUtilityCrAbilityLeafDaggers           mULeafDaggers;
var protected H7AiUtilityCrAbilityLivingShelter         mULivingShelter;
var protected H7AiUtilityCrAbilityMightyPounce          mUMightyPounce;
var protected H7AiUtilityCrAbilityNova                  mUNova;
var protected H7AiUtilityCrAbilityPoisonedBlades        mUPoisonedBlades;
var protected H7AiUtilityCrAbilitySixHeaded             mUSixHeaded;
var protected H7AiUtilityCrAbilitySplash                mUSplash;
var protected H7AiUtilityCrAbilitySoulFlayingBreath     mUSoulFlayingBreath;
var protected H7AiUtilityCrAbilitySoulReaver            mUSoulReaver;
var protected H7AiUtilityCrAbilityStrikeAndReturn       mUStrikeAndReturn;
var protected H7AiUtilityCrAbilityStrikeAndReturnMelee  mUStrikeAndReturnMelee;
var protected H7AiUtilityCrAbilitySweepingBash          mUSweepingBash;
var protected H7AiUtilityCrAbilityThorns                mUThorns;
var protected H7AiUtilityCrAbilityWitheringBreath       mUWitheringBreath;
var protected H7AiUtilityCrAbilityWitheringVenom        mUWitheringVenom;
var protected H7AiUtilityCrAbilityDivingAttack          mUDivingAttack;
var protected H7AiUtilityCrAbilityFireNova              mUFireNova;
var protected H7AiUtilityCrAbilityWhirlingDeath         mUWhirlingDeath;
var protected H7AiUtilityCrAbilityArmourPiercing        mUArmourPiercing;
var protected H7AiUtilityCrAbilityBreathOfLight         mUBreathOfLight;

function String DebugName()
{
	return "Use Ability";
}

function Setup()
{
	mUAcidBreath = new class'H7AiUtilityCrAbilityAcidBreath';
	mUSolderingHands = new class'H7AiUtilityCrAbilitySolderingHands';
	mUMagicAbsorption = new class'H7AiUtilityCrAbilityMagicAbsorption';
	mUResurrection = new class'H7AiUtilityCrAbilityResurrection';
	mUPiercingShot = new class'H7AiUtilityCrAbilityPiercingShot';
	mUFeralCharge = new class'H7AiUtilityCrAbilityFeralCharge';
	mUBackstab = new class'H7AiUtilityCrAbilityBackstab';
	mUCharge = new class'H7AiUtilityCrAbilityCharge';
	mUEntanglingRoots = new class'H7AiUtilityCrAbilityEntanglingRoots';
	mUFatalStrike = new class'H7AiUtilityCrAbilityFatalStrike';
	mUFieryEye = new class'H7AiUtilityCrAbilityFieryEye';
	mUInspiringPresence = new class'H7AiUtilityCrAbilityInspiringPresence';
	mULeafDaggers = new class'H7AiUtilityCrAbilityLeafDaggers';
	mULifeDrain = new class'H7AiUtilityCrAbilityLifeDrain';
	mULivingShelter = new class'H7AiUtilityCrAbilityLivingShelter';
	mUMightyPounce = new class'H7AiUtilityCrAbilityMightyPounce';
	mUNova = new class'H7AiUtilityCrAbilityNova';
	mUPoisonedBlades = new class'H7AiUtilityCrAbilityPoisonedBlades';
	mUSixHeaded = new class'H7AiUtilityCrAbilitySixHeaded';
	mUSplash = new class'H7AiUtilityCrAbilitySplash';
	mUSoulFlayingBreath = new class'H7AiUtilityCrAbilitySoulFlayingBreath';
	mUSoulReaver = new class'H7AiUtilityCrAbilitySoulReaver';
	mUStrikeAndReturn = new class'H7AiUtilityCrAbilityStrikeAndReturn';
	mUStrikeAndReturnMelee = new class'H7AiUtilityCrAbilityStrikeAndReturnMelee';
	mUSweepingBash = new class'H7AiUtilityCrAbilitySweepingBash';
	mUThorns = new class'H7AiUtilityCrAbilityThorns';
	mUWitheringBreath = new class'H7AiUtilityCrAbilityWitheringBreath';
	mUWitheringVenom = new class'H7AiUtilityCrAbilityWitheringVenom';
	mUDivingAttack = new class'H7AiUtilityCrAbilityDivingAttack';
	mUFireNova = new class'H7AiUtilityCrAbilityFireNova';
	mUWhirlingDeath = new class'H7AiUtilityCrAbilityWhirlingDeath';
	mUArmourPiercing = new class'H7AiUtilityCrAbilityArmourPiercing';
	mUBreathOfLight = new class'H7AiUtilityCrAbilityBreathOfLight';
}

function RunScoresForAbility( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores, H7BaseAbility ability )
{
	local AiActionScore             score;
	local H7AiSensorInputConst      sic;
	local array<float>              utOut;
	local int                       k;
	local H7AiUtilityCombiner       currentUtility;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	     if( ability.GetArchetypeID() == "A_MagicAbsorption" )      { currentUtility = mUMagicAbsorption; }
	else if( ability.GetArchetypeID() == "A_Resurrection" )         { currentUtility = mUResurrection; }
	else if( ability.GetArchetypeID() == "A_SolderingHands" )       { currentUtility = mUSolderingHands; }
	else if( ability.GetArchetypeID() == "A_PiercingShot" )     	{ currentUtility = mUPiercingShot; }
	else if( ability.GetArchetypeID() == "A_PiercingShot_Apprentice" )     	{ currentUtility = mUPiercingShot; }
	else if( ability.GetArchetypeID() == "A_FeralCharge" )          { currentUtility = mUFeralCharge; }
	else if( ability.GetArchetypeID() == "A_Backstab" )             { currentUtility = mUBackstab; }
	else if( ability.GetArchetypeID() == "A_Charge" )               { currentUtility = mUCharge; }
	else if( ability.GetArchetypeID() == "A_EntanglingRoots" )      { currentUtility = mUEntanglingRoots; }
	else if( ability.GetArchetypeID() == "A_FatalStrike" )          { currentUtility = mUFatalStrike; }
	else if( ability.GetArchetypeID() == "A_FieryEye" )             { currentUtility = mUFieryEye; }
	else if( ability.GetArchetypeID() == "A_InspiringPresence" )    { currentUtility = mUInspiringPresence; }
	else if( ability.GetArchetypeID() == "A_LeafDaggers" )          { currentUtility = mULeafDaggers; }
	else if( ability.GetArchetypeID() == "A_LifeDrain" )            { currentUtility = mULifeDrain; }
	else if( ability.GetArchetypeID() == "A_LivingShelter" )        { currentUtility = mULivingShelter; }
	else if( ability.GetArchetypeID() == "A_MightyPounce" )         { currentUtility = mUMightyPounce; }
	else if( ability.GetArchetypeID() == "A_Nova" )                 { currentUtility = mUNova; }
	else if( ability.GetArchetypeID() == "A_PoisonedBlades" )       { currentUtility = mUPoisonedBlades; }
	else if( ability.GetArchetypeID() == "A_SixHeaded" )            { currentUtility = mUSixHeaded; }
	else if( ability.GetArchetypeID() == "A_Splash" )               { currentUtility = mUSplash; }
	else if( ability.GetArchetypeID() == "A_SoulFlayingBreath" )    { currentUtility = mUSoulFlayingBreath; }
	else if( ability.GetArchetypeID() == "A_SoulReaver" )           { currentUtility = mUSoulReaver; }
	else if( ability.GetArchetypeID() == "A_StrikeAndReturn" )      { currentUtility = mUStrikeAndReturn; }
	else if( ability.GetArchetypeID() == "A_StrikeAndReturn_Disable" ) { currentUtility = mUStrikeAndReturnMelee; }
	else if( ability.GetArchetypeID() == "A_SweepingBash" )         { currentUtility = mUSweepingBash; }
	else if( ability.GetArchetypeID() == "A_Thorns" )               { currentUtility = mUThorns; }
	else if( ability.GetArchetypeID() == "A_WitheringBreath" )      { currentUtility = mUWitheringBreath; }
	else if( ability.GetArchetypeID() == "A_WitheringVenom" )       { currentUtility = mUWitheringVenom; }
	else if( ability.GetArchetypeID() == "A_AcidBreath" )           { currentUtility = mUAcidBreath; }
	else if( ability.GetArchetypeID() == "A_ArmourPiercing" )       { currentUtility = mUArmourPiercing; }
	else if( ability.GetArchetypeID() == "A_DivingAttack" )         { currentUtility = mUDivingAttack; }
	else if( ability.GetArchetypeID() == "A_FireNova" )             { currentUtility = mUFireNova; }
	else if( ability.GetArchetypeID() == "A_WhirlingDeath" )        { currentUtility = mUWhirlingDeath; }
	else if( ability.GetArchetypeID() == "A_BreathOfLight" )        { currentUtility = mUBreathOfLight; }
	else if( ability.GetArchetypeID() == "A_MobileShooter" ) {
		// passive that is handled within attack and move action
		return;
	}
	else if( ability.GetArchetypeID() == "A_MobileShooter_Skip_Ability" ) {
		// we don't do anything with
		return;
	}
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return;
	}

	// can we use the ability et all atm?
	if( H7CreatureAbility(ability).CanCast() == false )
	{
		return;
	}

	sic.SetCreatureAbility(H7CreatureAbility(ability));
	
	if( currentUtility == mUDivingAttack )
	{
		sic.SetTargetCell( mUDivingAttack.GetOptimalDivingAttackTargetCell(currentUnit.GetCombatArmy().GetCombatHero()) );
		score.dbgString = "Action.UseAbility (cell); " $ ability @ ability.GetName() $ "; Target " $ sic.GetTargetCell() $ "; ";
		if( mUDivingAttack.mTargetCell!=None)
		{
			currentUtility.UpdateInput();
			currentUtility.UpdateOutput();
			utOut = currentUtility.GetOutValues();
			if( utOut.Length >= 1 )
			{
				if(utOut[0]>0.0f)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetUnit(APID_1,currentUnit);
					score.params.SetAbility(APID_2,ability);
					score.params.SetCMapCell(APID_3,mUDivingAttack.mTargetCell);
					score.score=utOut[0] + 0.1f; // * ability.GetAiGeneralUtility();
					scores.AddItem(score);
				}
			}
			utOut.Remove(0,utOut.Length);
		}
		return;
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	if( ability.CanAffectAlly() == true )
	{
		// for all friendly creature stacks ...
		for( k=0; k<sic.GetCreatureStackNum(); k++ )
		{
			score.dbgString = "Action.UseAbility (ally); " $ ability @ ability.GetName() $ "; Target " $ sic.GetCreatureStack(k).GetName() $ "; ";

			sic.SetTargetCreatureStack(sic.GetCreatureStack(k));
			sic.SetTargetCell(sic.GetCreatureStack(k).GetCell());
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

			if( ability.CanCastOnTargetActor(sic.GetCreatureStack(k)) == true )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				currentUtility.UpdateInput();
				currentUtility.UpdateOutput();
				utOut = currentUtility.GetOutValues();
				if( utOut.Length >= 1 )
				{
					if(utOut[0]>0.0f)
					{
						score.params = new () class'H7AiActionParam';
						score.params.Clear();
						score.params.SetUnit(APID_1,sic.GetCreatureStack(k));
						score.params.SetAbility(APID_2,ability);
						score.params.SetCMapCell(APID_3,sic.GetCreatureStack(k).GetCell());
						score.score=utOut[0] + 0.1f; // * ability.GetAiGeneralUtility();
						scores.AddItem(score);
					}
				}

				utOut.Remove(0,utOut.Length);
			}
		}
	}

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	if( ability.CanAffectEnemy()==true )
	{
		// for all enemy creature stacks ...
		for( k=0; k<sic.GetOppCreatureStackNum(); k++ )
		{
			score.dbgString = "Action.UseAbility (enemy); " $ ability @ ability.GetName() $ "; Target " $ sic.GetOppCreatureStack(k).GetName() $ "; ";

			sic.SetTargetCreatureStack(sic.GetOppCreatureStack(k));
			sic.SetTargetCell(sic.GetOppCreatureStack(k).GetCell());

			if( ability.CanCastOnTargetActor(sic.GetOppCreatureStack(k)) == true )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				currentUtility.UpdateInput();
				currentUtility.UpdateOutput();
				utOut = currentUtility.GetOutValues();
				if( utOut.Length >= 1 )
				{
					if(utOut[0]>0.0f)
					{
						score.params = new () class'H7AiActionParam';
						score.params.Clear();
						score.params.SetUnit(APID_1,sic.GetOppCreatureStack(k));
						score.params.SetAbility(APID_2,ability);
						score.params.SetCMapCell(APID_3,sic.GetOppCreatureStack(k).GetCell());
						score.score=utOut[0] + 0.1f; // * ability.GetAiGeneralUtility();
						scores.AddItem(score);
					}
				}

				utOut.Remove(0,utOut.Length);
			}
		}
	}
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local array<H7BaseAbility> filteredAbilities;
	local H7BaseAbility cAbility;
	local array<H7CreatureAbility> creatureAbilities;
	local H7CreatureAbility creatureAbility;
	local H7CreatureStack cstack;

	cstack=H7CreatureStack(currentUnit);

	// get all creature ability templates that are not the defaults and filter out all passive abilities
	creatureAbilities = cstack.GetCreature().GetAbilities();
	foreach creatureAbilities(creatureAbility)
	{
		if( !creatureAbility.IsPassive() )
		{
			filteredAbilities.AddItem(creatureAbility);
		}
	}

	if( filteredAbilities.Length >= 1 )
	{
		if( currentUnit.GetAbilityManager().HasAbility(filteredAbilities[0]) )
		{
			cAbility = currentUnit.GetAbilityManager().GetAbility(filteredAbilities[0]);
			currentUnit.GetAbilityManager().PrepareAbility(cAbility);
			if(cAbility.CanCast()==true)
				RunScoresForAbility(sensors,currentUnit,scores,cAbility);
		}
	}
	if( filteredAbilities.Length >= 2 )
	{
		if( currentUnit.GetAbilityManager().HasAbility(filteredAbilities[1]) )
		{
			cAbility = currentUnit.GetAbilityManager().GetAbility(filteredAbilities[1]);
			currentUnit.GetAbilityManager().PrepareAbility(cAbility);
			if(cAbility.CanCast()==true)
				RunScoresForAbility(sensors,currentUnit,scores,cAbility);
		}
	}
}

function bool PerformAction( H7Unit unit, AiActionScore score )
{
	local H7CombatController ctrl;
	local H7CombatMapGridController grid_ctrl;

	ctrl = class'H7CombatController'.static.GetInstance();
	grid_ctrl = class'H7CombatMapGridController'.static.GetInstance();

	if( unit!=None && ctrl!=None )
	{
		unit.GetAbilityManager().PrepareAbility( score.params.GetAbility(APID_2) );
		return grid_ctrl.DoAbility(score.params.GetCMapCell(APID_3));

		//ctrl.SetActiveUnitCommand_UsePreparedAbility(score.params.GetCMapCell(APID_3));
		//return true;
	}

	return false;
}
