//=============================================================================
// H7AiActionCastSpellHero
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionCastSpellHero extends H7AiActionBase;

var protected H7AiUtilitySpellTargetCheck               mUSpellTargetCheck;
var protected H7AiUtilitySpellSingleDamage              mUSpellSingleDamage;
var protected H7AiUtilitySpellMultiDamage               mUSpellMultiDamage;

// Fire
var protected H7AiUtilityHeAbilityFireBolt              mUFireBolt;
var protected H7AiUtilityHeAbilityBurningDetermination  mUBurningDetermination;
var protected H7AiUtilityHeAbilityInnerFire             mUInnerFire;
var protected H7AiUtilityHeAbilityFireWall              mUFireWall;
var protected H7AiUtilityHeAbilityFrenzy                mUFrenzy;
var protected H7AiUtilityHeAbilityFireBall              mUFireBall;
var protected H7AiUtilityHeAbilityArmageddon            mUArmageddon;
// Earth
var protected H7AiUtilityHeAbilityStoneSkin             mUStoneSkin;
var protected H7AiUtilityHeAbilityRegeneration          mURegeneration;
var protected H7AiUtilityHeAbilityEntangle              mUEntangle;
var protected H7AiUtilityHeAbilityPoisonSpray           mUPoisonSpray;
var protected H7AiUtilityHeAbilityStoneSpikes           mUStoneSpikes;
var protected H7AiUtilityHeAbilityEarthquake            mUEarthquake;
var protected H7AiUtilityHeAbilityPoisonCloud           mUPoisonCloud;
// Water
var protected H7AiUtilityHeAbilityFogShroud             mUFogShroud;
var protected H7AiUtilityHeAbilityBlizzard              mUBlizzard;
var protected H7AiUtilityHeAbilityFrostBolt             mUFrostBolt;
var protected H7AiUtilityHeAbilityIceStrike             mUIceStrike;
var protected H7AiUtilityHeAbilityCircleOfWinter        mUCircleOfWinter;
var protected H7AiUtilityHeAbilityLiquidMembrane        mULiquidMembrane;
var protected H7AiUtilityHeAbilityTsunami               mUTsunami;
// Air
var protected H7AiUtilityHeAbilityLightningBurst        mULightningBurst;
var protected H7AiUtilityHeAbilityStormArrows           mUStormArrows;
var protected H7AiUtilityHeAbilityLightningBolt         mULightningBolt;
var protected H7AiUtilityHeAbilityGustOfWind            mUGustOfWind;
var protected H7AiUtilityHeAbilityLightningReflexes     mULightningReflexes;
var protected H7AiUtilityHeAbilityCyclone               mUCyclone;
var protected H7AiUtilityHeAbilityChainLightning        mUChainLightning;
// Dark
var protected H7AiUtilityHeAbilityDespair               mUDespair;
var protected H7AiUtilityHeAbilityWeakness              mUWeakness;
var protected H7AiUtilityHeAbilityPurge                 mUPurge;
var protected H7AiUtilityHeAbilityFaceOfFear            mUFaceOfFear;
var protected H7AiUtilityHeAbilityShadowImage           mUShadowImage;
var protected H7AiUtilityHeAbilityAgony                 mUAgony;
var protected H7AiUtilityHeAbilityShadowCloak           mUShadowCloak;
// Light
var protected H7AiUtilityHeAbilityHeal                  mUHeal;
var protected H7AiUtilityHeAbilitySunBeam               mUSunBeam;
var protected H7AiUtilityHeAbilityCelestialArmour       mUCelestialArmour;
var protected H7AiUtilityHeAbilityCleansingLight        mUCleansingLight;
var protected H7AiUtilityHeAbilityRetribution           mURetribution;
var protected H7AiUtilityHeAbilitySunBurst              mUSunBurst;
var protected H7AiUtilityHeAbilityResurrection          mUResurrection;
// Prime
var protected H7AiUtilityHeAbilityTimeControl           mUTimeControl;
var protected H7AiUtilityHeAbilityFortune               mUFortune;
var protected H7AiUtilityHeAbilityTeleport              mUTeleport;
var protected H7AiUtilityHeAbilityDispelMagic           mUDispelMagic;
var protected H7AiUtilityHeAbilityImplosion             mUImplosion;
var protected H7AiUtilityHeAbilitySummonElemental       mUSummonElemental;
var protected H7AiUtilityHeAbilityTimeStasis            mUTimeStasis;
// Warcry
var protected H7AiUtilityHeAbilityAdvance               mUAdvance;
var protected H7AiUtilityHeAbilityHoldPositions         mUHoldPositions;
var protected H7AiUtilityHeAbilityOpenFire              mUOpenFire;
var protected H7AiUtilityHeAbilityEngage                mUEngage;
var protected H7AiUtilityHeAbilityAttention             mUAttention;

var int Dubstep;

function String DebugName()
{
	return "Cast Hero Spell";
}

function Setup()
{
	mUSpellTargetCheck = new class'H7AiUtilitySpellTargetCheck';
	mUSpellSingleDamage = new class'H7AiUtilitySpellSingleDamage';
	mUSpellMultiDamage = new class'H7AiUtilitySpellMultiDamage';

	mULightningBurst = new class'H7AiUtilityHeAbilityLightningBurst';
	mUTsunami =  new class'H7AiUtilityHeAbilityTsunami';
	mUCircleOfWinter = new class'H7AiUtilityHeAbilityCircleOfWinter';
	mUHeal = new class'H7AiUtilityHeAbilityHeal';
	mULightningBolt = new class'H7AiUtilityHeAbilityLightningBolt';
	mUChainLightning = new class'H7AiUtilityHeAbilityChainLightning';
	mUFireBolt = new class'H7AiUtilityHeAbilityFireBolt';
	mUFireBall = new class'H7AiUtilityHeAbilityFireBall';
	mUFrostBolt = new class'H7AiUtilityHeAbilityFrostBolt';
	mUSunBeam = new class'H7AiUtilityHeAbilitySunBeam';
	mUCyclone = new class'H7AiUtilityHeAbilityCyclone';
	mUBlizzard = new class'H7AiUtilityHeAbilityBlizzard';
	mUStoneSpikes = new class'H7AiUtilityHeAbilityStoneSpikes';
	mUIceStrike = new class'H7AiUtilityHeAbilityIceStrike';
	mULiquidMembrane = new class'H7AiUtilityHeAbilityLiquidMembrane';
	mUCelestialArmour = new class'H7AiUtilityHeAbilityCelestialArmour';
	mURetribution = new class'H7AiUtilityHeAbilityRetribution';
	mUResurrection = new class'H7AiUtilityHeAbilityResurrection';
	mUArmageddon = new class'H7AiUtilityHeAbilityArmageddon';
	mUFogShroud = new class'H7AiUtilityHeAbilityFogShroud';
	mUFrenzy = new class'H7AiUtilityHeAbilityFrenzy';
	mUInnerFire = new class'H7AiUtilityHeAbilityInnerFire';
	mUBurningDetermination = new class'H7AiUtilityHeAbilityBurningDetermination';
	mUPoisonCloud = new class'H7AiUtilityHeAbilityPoisonCloud';
	mUEarthquake = new class'H7AiUtilityHeAbilityEarthquake';
	mUPoisonSpray = new class'H7AiUtilityHeAbilityPoisonSpray';
	mUEntangle = new class'H7AiUtilityHeAbilityEntangle';
	mURegeneration = new class'H7AiUtilityHeAbilityRegeneration';
	mUStoneSkin = new class'H7AiUtilityHeAbilityStoneSkin';
	mUTimeStasis = new class'H7AiUtilityHeAbilityTimeStasis';
	mUImplosion = new class'H7AiUtilityHeAbilityImplosion';
	mUFortune = new class'H7AiUtilityHeAbilityFortune';
	mUShadowCloak = new class'H7AiUtilityHeAbilityShadowCloak';
	mUWeakness = new class'H7AiUtilityHeAbilityWeakness';
	mUDespair = new class'H7AiUtilityHeAbilityDespair';
	mULightningReflexes = new class'H7AiUtilityHeAbilityLightningReflexes';
	mUStormArrows = new class'H7AiUtilityHeAbilityStormArrows';
	mUSunBurst = new class'H7AiUtilityHeAbilitySunBurst';
	mUCleansingLight = new class'H7AiUtilityHeAbilityCleansingLight';
	mUFireWall = new class'H7AiUtilityHeAbilityFireWall';
	mUTimeControl = new class'H7AiUtilityHeAbilityTimeControl';
	mUTeleport = new class'H7AiUtilityHeAbilityTeleport';
	mUDispelMagic = new class'H7AiUtilityHeAbilityDispelMagic';
	mUGustOfWind = new class'H7AiUtilityHeAbilityGustOfWind';
	mUSummonElemental = new class'H7AiUtilityHeAbilitySummonElemental';
	mUAdvance = new class'H7AiUtilityHeAbilityAdvance';
	mUHoldPositions = new class'H7AiUtilityHeAbilityHoldPositions';
	mUEngage = new class'H7AiUtilityHeAbilityEngage';
	mUOpenFire = new class'H7AiUtilityHeAbilityOpenFire';
	mUAttention = new class'H7AiUtilityHeAbilityAttention';
	mUPurge = new class'H7AiUtilityHeAbilityPurge';
	mUFaceOfFear = new class'H7AiUtilityHeAbilityFaceOfFear';
	mUShadowImage = new class'H7AiUtilityHeAbilityShadowImage';
	mUAgony = new class'H7AiUtilityHeAbilityAgony';

	Dubstep=-1;
}

function ReplaceAddScore(out array<AiActionScore> scores, AiActionScore score)
{
	local int idx;

	idx=scores.Length;

	if(idx<=0)
	{
		scores.AddItem(score);
		return;
	}

	if(scores[idx-1].action==score.action && scores[idx-1].params.GetAbility(APID_2)==score.params.GetAbility(APID_2) )
	{
		if( scores[idx-1].score<score.score )
		{
			scores.Remove(idx-1,1);
			scores.AddItem(score);
		}
	}
	else
	{
		scores.AddItem(score);
	}
	
}

function bool RunScoresForAbility( H7AiCombatSensors sensors, H7CombatHero hero, out array<AiActionScore> scores, H7HeroAbility ability, float manaCost )
{
	local AiActionScore             score;
	local H7AiSensorInputConst      sic;
	local array<float>              utOut;
	local int                       k;
	local H7AiUtilityCombiner       currentUtility;
	local float                     genUtil;
	local bool                      selectSingleAllied;
	local bool                      selectSingleEnemy;
	local bool                      selectMassAllied;
	local bool                      selectMassEnemy;
	local bool                      selectCell;

	if(ability==None) return false;

	sic = sensors.GetSensorIConsts();

	selectCell=false;
	selectSingleAllied=false;
	selectSingleEnemy=false;
	selectMassAllied=false;
	selectMassEnemy=false;

	score.action = Self;
	score.score = 0.0f;

	     if( ability.GetArchetypeID() == "A_LightningBurst" )       { currentUtility = mULightningBurst; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_Tsunami" )              { currentUtility = mUTsunami; sic.SetTargetCell( mUTsunami.GetOptimalTsunamiTargetCell(hero,ability.GetTsunamiRows()) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_CircleOfWinter" )       { currentUtility = mUCircleOfWinter; sic.SetTargetCell( mUCircleOfWinter.GetOptimalCircleOfWinterTargetCell(hero,ability.GetTargetArea(),ability.IsAreaFilled()) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_Heal" )                 { currentUtility = mUHeal; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_LightningBolt" )        { currentUtility = mULightningBolt; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_ChainLightning" )       { currentUtility = mUChainLightning; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Firebolt" )             { currentUtility = mUFireBolt; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_FrostBolt" )            { currentUtility = mUFrostBolt; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Fireball" )             { currentUtility = mUFireBall; sic.SetTargetCell( mUFireBall.GetOptimalFireBallTargetCell(hero,ability.GetTargetArea()) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_SunBeam" )              { currentUtility = mUSunBeam; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Cyclone" )              { currentUtility = mUCyclone; sic.SetTargetCell( mUCyclone.GetOptimalCycloneTargetCell(hero,ability.GetTargetArea()) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_Blizzard" )             { currentUtility = mUBlizzard; sic.SetTargetCell( mUBlizzard.GetOptimalBlizzardTargetCell(hero,ability.GetTargetArea()) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_StoneSpikes" )          { currentUtility = mUStoneSpikes; sic.SetTargetCell( mUStoneSpikes.GetOptimalStoneSpikeTargetCell(hero) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_IceStrike" )            { currentUtility = mUIceStrike; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_LiquidMembrane" )       { currentUtility = mULiquidMembrane; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_CelestialArmor" )       { currentUtility = mUCelestialArmour; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_Retribution" )          { currentUtility = mURetribution; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_Resurrection" )         { currentUtility = mUResurrection; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_Frenzy" )               { currentUtility = mUFrenzy; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_InnerFire" )            { currentUtility = mUInnerFire; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_FogShroud" )            { currentUtility = mUFogShroud; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Armageddon" )           { currentUtility = mUArmageddon; sic.SetTargetCell( mUArmageddon.GetOptimalArmageddonTargetCell(hero) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_BurningDetermination" ) { currentUtility = mUBurningDetermination; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_PoisonCloud" )          { currentUtility = mUPoisonCloud; sic.SetTargetCell( mUPoisonCloud.GetOptimalPoisonCloudTargetCell(hero,ability.GetTargetArea()) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_Earthquake" )           { currentUtility = mUEarthquake; sic.SetTargetCell( mUEarthquake.GetOptimalEarthquakeTargetCell(hero) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_PoisonSpray" )          { currentUtility = mUPoisonSpray; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Entangle" )             { currentUtility = mUEntangle; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Regeneration" )         { currentUtility = mURegeneration; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_StoneSkin" )            { currentUtility = mUStoneSkin; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_TimeStasis" )           { currentUtility = mUTimeStasis; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Implosion" )            { currentUtility = mUImplosion; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Fortune" )              { currentUtility = mUFortune; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_ShadowCloak" )          { currentUtility = mUShadowCloak; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_Weakness" )             { currentUtility = mUWeakness; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Despair" )              { currentUtility = mUDespair; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_LightningReflexes" )    { currentUtility = mULightningReflexes; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_StormArrows" )          { currentUtility = mUStormArrows; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_SunBurst" )             { currentUtility = mUSunBurst; sic.SetTargetCell( mUSunBurst.GetOptimalSunBurstTargetCell(hero) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_CleansingLight" )       { currentUtility = mUCleansingLight; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_FireWall" )             { currentUtility = mUFireWall; sic.SetTargetCell( mUFireWall.GetOptimalFireWallTargetCell(hero,ability.GetTargetArea()) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_TimeControl" )          { currentUtility = mUTimeControl; selectSingleAllied=true; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_Teleport" )             { currentUtility = mUTeleport; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_DispelMagic" )          { currentUtility = mUDispelMagic; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_GustOfWind" )           { currentUtility = mUGustOfWind; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_SummonElemental" )      { currentUtility = mUSummonElemental; sic.SetTargetCell( mUSummonElemental.GetOptimalSummonElementalTargetCell(hero) ); selectCell=true; }
	else if( ability.GetArchetypeID() == "A_Advance" )              { currentUtility = mUAdvance; selectMassAllied=true; }
	else if( ability.GetArchetypeID() == "A_HoldPositions" )        { currentUtility = mUHoldPositions; selectMassAllied=true; }
	else if( ability.GetArchetypeID() == "A_Engage" )               { currentUtility = mUEngage; selectMassAllied=true; }
	else if( ability.GetArchetypeID() == "A_OpenFire" )             { currentUtility = mUOpenFire; selectMassAllied=true; }
	else if( ability.GetArchetypeID() == "A_Attention" )            { currentUtility = mUAttention; selectMassAllied=true; }
	else if( ability.GetArchetypeID() == "A_Purge" )                { currentUtility = mUPurge; selectSingleEnemy=true; }
	else if( ability.GetArchetypeID() == "A_FaceOfFear" )           { currentUtility = mUFaceOfFear; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_ShadowImage" )          { currentUtility = mUShadowImage; selectSingleAllied=true; }
	else if( ability.GetArchetypeID() == "A_Agony" )                { currentUtility = mUAgony; selectSingleEnemy=true; }
	else
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		return false;
	}

	sic.SetUseHeroAbility(ability);

	hero.PrepareAbility(ability);

	genUtil = ability.GetAiGeneralUtility();
//	if(genUtil==0.0f) genUtil=1.0f;

	if( selectCell==true )
	{
		score.dbgString = "Action.CastSpellHero; (cell) " $ ability @ ability.GetName() $ "; Target NO; AB(" $ ability.GetTargetType() $ ",AE=" $ ability.CanAffectEnemy() $ ",AA=" $ ability.CanAffectAlly() $ "); ";
		currentUtility.UpdateInput();
		currentUtility.UpdateOutput();
		utOut = currentUtility.GetOutValues();
		if(utOut.Length>=1 && utOut[0]>0.0f)
		{
			score.params = new () class'H7AiActionParam';
			score.params.Clear();
			score.params.SetCMapCell(APID_1,sic.GetTargetCell());
			score.params.SetAbility(APID_2,ability);
			score.score=utOut[0] * manaCost * genUtil;
			score.dbgString = score.dbgString $ "MC(" $ manaCost $ ") UV(" $ utOut[0] $ ") GU(" $ genUtil $ "); ";
			scores.AddItem(score);
		}
	}

	if( selectSingleAllied==true )
	{
		// for all friendly creature stacks ...
		for( k=0; k<sic.GetCreatureStackNum(); k++ )
		{
			score.dbgString = "Action.CastSpellHero; (ally) " $ ability.GetName() $ "; Target " $ sic.GetCreatureStack(k).GetName() $ "; AB(" $ ability.GetTargetType() $ ",AE=" $ ability.CanAffectEnemy() $ ",AA=" $ ability.CanAffectAlly() $ "); ";

			sic.SetTargetCreatureStack(sic.GetCreatureStack(k));
			sic.SetThisCreatureStack(sic.GetCreatureStack(k));

			if( ability.CanCastOnTargetActor(sic.GetCreatureStack(k)) == true )
			{
				currentUtility.UpdateInput();
				currentUtility.UpdateOutput();
				utOut = currentUtility.GetOutValues();
				if(utOut.Length>=1 && utOut[0]>0.0f)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetUnit(APID_1,sic.GetCreatureStack(k));
					score.params.SetAbility(APID_2,ability);
					score.score=utOut[0] * manaCost * genUtil;
					score.dbgString = score.dbgString $ "MC(" $ manaCost $ ") UV(" $ utOut[0] $ ") GU(" $ genUtil $ "); ";
					ReplaceAddScore(scores,score);
					//scores.AddItem(score);
				}
			}
		}
	}

	if( selectSingleEnemy==true )
	{
		// for all friendly creature stacks ...
		for( k=0; k<sic.GetOppCreatureStackNum(); k++ )
		{
			score.dbgString = "Action.CastSpellHero; (enemy) " $ ability.GetName() $ "; Target " $ sic.GetOppCreatureStack(k).GetName() $ "; AB(" $ ability.GetTargetType() $ ",AE=" $ ability.CanAffectEnemy() $ ",AA=" $ ability.CanAffectAlly() $ "); ";

			sic.SetTargetCreatureStack(sic.GetOppCreatureStack(k));
			sic.SetThisCreatureStack(sic.GetOppCreatureStack(k));

			if( ability.CanCastOnTargetActor(sic.GetOppCreatureStack(k)) == true )
			{
				currentUtility.UpdateInput();
				currentUtility.UpdateOutput();
				utOut = currentUtility.GetOutValues();
				if(utOut.Length>=1 && utOut[0]>0.0f)
				{
					score.params = new () class'H7AiActionParam';
					score.params.Clear();
					score.params.SetUnit(APID_1,sic.GetOppCreatureStack(k));
					score.params.SetAbility(APID_2,ability);
					score.score=utOut[0] * manaCost * genUtil;
					score.dbgString = score.dbgString $ "MC(" $ manaCost $ ") UV(" $ utOut[0] $ ") GU(" $ genUtil $ "); ";
					ReplaceAddScore(scores,score);
					//scores.AddItem(score);
				}
			}
		}
	}

	if( selectMassAllied==true )
	{
		score.dbgString = "Action.CastSpellHero; (ally) " $ ability.GetName() $ "; Target MASS; AB(" $ ability.GetTargetType() $ ",AE=" $ ability.CanAffectEnemy() $ ",AA=" $ ability.CanAffectAlly() $ "); ";

		sic.SetTargetCreatureStack(sic.GetCreatureStack(0));
		sic.SetTargetCell(sic.GetCell(0));

		if( ability.CanCastOnTargetActor(sic.GetCreatureStack(0))==true )
		{
			currentUtility.UpdateInput();
			currentUtility.UpdateOutput();
			utOut = currentUtility.GetOutValues();
			if(utOut.Length>=1 && utOut[0]>0.0f)
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetUnit(APID_1,sic.GetCreatureStack(0));
				score.params.SetAbility(APID_2,ability);
				score.score=utOut[0] * manaCost * genUtil;
				score.dbgString = score.dbgString $ "MC(" $ manaCost $ ") UV(" $ utOut[0] $ ") GU(" $ genUtil $ "); ";
				ReplaceAddScore(scores,score);
				//scores.AddItem(score);
			}
		}
	}

	if( selectMassEnemy==true )
	{
		score.dbgString = "Action.CastSpellHero; (enemy) " $ ability.GetName() $ "; Target MASS; AB(" $ ability.GetTargetType() $ ",AE=" $ ability.CanAffectEnemy() $ ",AA=" $ ability.CanAffectAlly() $ "); ";

		sic.SetTargetCreatureStack(sic.GetOppCreatureStack(0));
		sic.SetTargetCell(sic.GetCell(0));

		if( ability.CanCastOnTargetActor(sic.GetOppCreatureStack(0))==true )
		{
			currentUtility.UpdateInput();
			currentUtility.UpdateOutput();
			utOut = currentUtility.GetOutValues();
			if(utOut.Length>=1 && utOut[0]>0.0f)
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetUnit(APID_1,sic.GetOppCreatureStack(0));
				score.params.SetAbility(APID_2,ability);
				score.score=utOut[0] * manaCost * genUtil;
				score.dbgString = score.dbgString $ "MC(" $ manaCost $ ") UV(" $ utOut[0] $ ") GU(" $ genUtil $ "); ";
				ReplaceAddScore(scores,score);
				//scores.AddItem(score);
			}
		}
	}

	hero.ResetPreparedAbility();

	return true;
}

function bool RunScoresForDamageSpell( H7AiCombatSensors sensors, H7CombatHero hero, out array<AiActionScore> scores, H7HeroAbility ability, float manaCost )
{
	local AiActionScore             score;
	local H7AiSensorInputConst      sic;
	local float                     targetScale, sourceScale, effectRatio;
	local float                     killScale;
	local array<float>              uKillScale;
	local int                       k,n;

	if(ability==None) return false;

	sic = sensors.GetSensorIConsts();

	score.action = Self;
	score.score = 0.0f;

	sic.SetUseHeroAbility(ability);

	if(ability.IsDamageFilter())
	{
		hero.PrepareAbility(ability);

		// no target spells
		if(ability.GetTargetType()==NO_TARGET)
		{
			score.dbgString = "Action.CastSpellHero; " $ ability.GetName() $ "; AB(" $ ability.GetTargetType() $ ",AE=" $ ability.CanAffectEnemy() $ ",AA=" $ ability.CanAffectAlly() $ "); ";

			sic.SetTargetCreatureStack(sic.GetOppCreatureStack(0));

			mUSpellMultiDamage.UpdateInput();
			mUSpellMultiDamage.UpdateOutput();
			uKillScale = mUSpellMultiDamage.GetOutValues();

			targetScale = 0.0f;
			sourceScale = 0.0f;

			if(ability.CanAffectEnemy()==true)
			{
				targetScale = float(sic.GetOppCreatureStackNum()) / 14.0f + 0.5f;
			}
			if(ability.CanAffectAlly()==true)
			{
				sourceScale = float(sic.GetCreatureStackNum()) / 14.0f + 0.5f;
			}
			
			effectRatio=targetScale-sourceScale;
			if(effectRatio<0.0f) effectRatio=0.0f;
			if(effectRatio>1.0f) effectRatio=1.0f;

			killScale=0.0f;
			for(n=0;n<uKillScale.Length;n++)
			{
				killScale+=uKillScale[n];
			}
			if(uKillScale.Length>0)
			{
				killScale/=uKillScale.Length;
			}
			
			score.score = manaCost * killScale * effectRatio * ability.GetAiGeneralUtility();

			score.dbgString = score.dbgString $ "MC(" $ manaCost $ ") KS(" $ killScale $ " ER(" $ effectRatio $ ") GU(" $ ability.GetAiGeneralUtility() $ "); ";

			if(score.score>0.0f)
			{
				score.params = new () class'H7AiActionParam';
				score.params.Clear();
				score.params.SetUnit(APID_1,sic.GetOppCreatureStack(0));
				score.params.SetAbility(APID_2,ability);

				scores.AddItem(score);
			}
		}
		else
		{
			// for all enemy creatures ...
			for(k=0;k<sic.GetOppCreatureStackNum();k++)
			{
				sic.SetTargetCreatureStack(sic.GetOppCreatureStack(k));

				mUSpellMultiDamage.UpdateInput();
				mUSpellMultiDamage.UpdateOutput();
				uKillScale = mUSpellMultiDamage.GetOutValues();

				if( ability.GetTargetType()==TARGET_DEFAULT ||
					ability.GetTargetType()==TARGET_AREA ||
					ability.GetTargetType()==TARGET_SINGLE ||
					ability.GetTargetType()==TARGET_TSUNAMI ||
					ability.GetTargetType()==TARGET_AREA_AROUND_TARGET ||
					ability.GetTargetType()==TARGET_CUSTOM_SHAPE ||
					ability.GetTargetType()==TARGET_TARGET )
				{
					for(n=0;n<uKillScale.Length;n++)
					{
						score.dbgString = "Action.CastSpellHero; " $ ability.GetName() $ "; Target " $ sic.GetOppCreatureStack(k).GetName() $ "; AB(" $ ability.GetTargetType() $ ",AE=" $ ability.CanAffectEnemy() $ ",AA=" $ ability.CanAffectAlly() $ "); ";

						score.score = manaCost * uKillScale[n] * ability.GetAiGeneralUtility();

						score.dbgString = score.dbgString $ "MC(" $ manaCost $ ") KS(" $ uKillScale[n] $ ") GU(" $ ability.GetAiGeneralUtility() $ "); ";

						if( score.score > 0.0f )
						{
							score.params = new () class'H7AiActionParam';
							score.params.Clear();
							score.params.SetUnit(APID_1,sic.GetOppCreatureStack(k));
							score.params.SetAbility(APID_2,ability);

							scores.AddItem(score);
						}
					}
				}
			}
		}
	}
	return true;
}

/// override function(s)

function RunScores( H7AiCombatSensors sensors, H7Unit currentUnit, out array<AiActionScore> scores )
{
	local H7AiSensorInputConst    sic;
	local H7CombatHero      hero;
	local H7HeroAbility     ability;
	local float             uManaCost;

	hero=H7CombatHero(currentUnit);
	if(hero==None) return;

	sic = sensors.GetSensorIConsts();

	if(Dubstep!=-1)
	{
		if(Dubstep<sic.GetHeroAbilityNum())
		{
			ability=sic.GetHeroAbility(Dubstep);
			if(ability==None)
			{
				Dubstep++;
				return;
			}

			if(ability.GetManaCost()<=0)
			{
				uManaCost=1.0f;
			}
			else if(hero.GetCurrentMana()>=ability.GetManaCost())
			{
				uManaCost = 1.0f - float(hero.GetCurrentMana()) / float(ability.GetManaCost());
				if(uManaCost<0.0f) uManaCost=0.0f;
				if(uManaCost>1.0f) uManaCost=1.0f;

				// transpose
				uManaCost = Lerp(0.25f,1.0f,uManaCost);
			}
			else
			{
				uManaCost=0.0f;
			}
			
			if(uManaCost>0.0f)
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				if(RunScoresForAbility(sensors,hero,scores,ability,uManaCost)==false)
				{
					RunScoresForDamageSpell(sensors,hero,scores,ability,uManaCost);
				}
			}
			Dubstep++;
			return;
		}
		Dubstep=-1;
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
		unit.PrepareAbility( score.params.GetAbility( APID_2 ) );
		if(score.params.GetUnit(APID_1)!=None)
		{
			ctrl.SetActiveUnitCommand_UsePreparedAbility( grid_ctrl.GetCombatGrid().GetCellByIntPoint( score.params.GetUnit(APID_1).GetGridPosition() ) );
		}
		else if( score.params.GetCMapCell(APID_1)!=None)
		{
			ctrl.SetActiveUnitCommand_UsePreparedAbility( grid_ctrl.GetCombatGrid().GetCellByIntPoint( score.params.GetCMapCell(APID_1).GetGridPosition() ) );
		}
		return true;
	}
	return false;
}
