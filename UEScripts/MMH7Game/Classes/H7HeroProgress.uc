//=============================================================================
// H7HeroProgress
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroProgress extends Object;

var(XPTable) int        mXpTable[30]<DisplayName=XP Progress Table>;
var(StatLevelUp) int    mStatIncrease<DisplayName=Stat Increase (Might/Magic/Spirit/Defense)>;

var(StatLevelUp) int    mMinDamageInc[30]<DisplayName=Minimum Damage Increase>;
var(StatLevelUp) int    mMaxDamageInc[30]<DisplayName=Maximum Damage Increase>;

var(StatLevelUp) int    mMinDamageInclvl30<DisplayName=Minimum Damage Increase After Level 30>;
var(StatLevelUp) int    mMaxDamageInclvl30<DisplayName=Maximum Damage Increase After Level 30>;

function int GetLevel( int xp )
{
	local int k;
	if( mXpTable[29] > xp)
	{
		for(k=0;k<30;k++) 
		{
			if( mXpTable[k] <= xp && ( k == 29 || mXpTable[k+1] > xp ) ) 
			{
				return k+1;// index0 = level1
			}
		}
	}
	else 
	{
		 return 30 + (xp - mXpTable[29] ) / (mXpTable[29] - mXpTable[28]);
	}

	;
	return 0;
}

function int GetXPRange( int level, out int lo, out int hi )
{
	local int rval;
	rval=0;
	if(level<30)
	{
		lo=mXpTable[level-1];
		hi=mXpTable[level];
	}
	else // over the former level cap
	{
		lo= mXpTable[29] + (( level - 30 ) * ( mXpTable[29] - mXpTable[28] ));
		hi= mXpTable[29] + (( 1 + level - 30 ) * ( mXpTable[29] - mXpTable[28] ));
	}
	rval=lo;
	return rval;
}

function int GetXPDelta( int level )
{
	local int lo,hi;
	GetXPRange( level, lo, hi );
	return hi-lo;
}

function int GetTotalXPByLvl(int level)
{
	// since we use the same xp as for lvl 30
	if( level > 30 )
	{
		return mXpTable[level - 1] * GetLevel(level);
	}

	return mXpTable[level - 1];
}

function int GetMinimumDamageAdd( int level )
{
	if( level > 30 )
	{
		return mMinDamageInc[29] + (level - 30 ) * mMinDamageInclvl30;
	}

	if( level >= 0 && level <= 30 ) 
	{
		return mMinDamageInc[level-1];
	}
	return 0;
}

function int GetMaximumDamageAdd( int level )
{
	if( level > 30 )
	{
		return mMaxDamageInc[29] + (level - 30 ) * mMaxDamageInclvl30;
	}

	if( level >= 0 && level <= 30 ) 
	{
		return mMaxDamageInc[level-1];
	}
	return 0;
}

function LevelUpHeroStats( H7EditorHero hero, int levelDelta )
{
	local float pick,attackP,defenseP,magicP,spiritP;
	local int i;
	local Vector HeroMsgOffset;
	local H7LevelUpData levelUpData; 

	if( hero == None ) return;

	if( hero.GetHeroClass().GetClassProgress() == none)
	{
		attackP = 0.25;
		defenseP = 0.25;
		magicP = 0.25;
		spiritP = 0.25;
	}
	else
	{
		attackP = hero.GetHeroClass().GetClassProgress().GetStatProbabilityAttack();
		defenseP = hero.GetHeroClass().GetClassProgress().GetStatProbabilityDefense();
		magicP = hero.GetHeroClass().GetClassProgress().GetStatPropabilityMagic();
		spiritP =  hero.GetHeroClass().GetClassProgress().GetStatPropabilitySpirit();
	}


	HeroMsgOffset = Vect(0,0,600);
	levelUpData.Value = mStatIncrease;

	class'H7FCTController'.static.GetInstance().StartFCT(FCT_TEXT, hero.location + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_LEVEL_UP","H7FCT"), MakeColor(255,255,0,255));
	class'H7AdventureController'.static.GetWorldinfo().MyEmitterPool.SpawnEmitter( class'H7AdventureController'.static.GetInstance().GetConfig().mLevelUpParticle, hero.Location, hero.Rotation, hero );
	
	for( i = 0; i < levelDelta; i++ )
	{
		levelUpData.Level = hero.GetLevel() + i + 1;
		pick = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomFloat() * 100.0f;

		if( pick <= attackP )
		{
			levelUpData.Stat = STAT_ATTACK;
			hero.SetAttack( hero.GetAttackBase() + mStatIncrease );
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_STAT_MOD, hero.location + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_PLUS_MIGHT","H7FCT"), MakeColor(0,255,0,255));
		}
		else if( (pick-attackP) <= defenseP )
		{
			levelUpData.Stat = STAT_DEFENSE;
			hero.SetDefense( hero.GetDefenseBase() + mStatIncrease );
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_STAT_MOD, hero.location + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_PLUS_DEFENSE","H7FCT"), MakeColor(0,255,0,255));
		}
		else if ( pick-(attackP + defenseP ) <= magicP )
		{
			levelUpData.Stat = STAT_MAGIC;
			hero.SetMagic( hero.GetMagicBase() + mStatIncrease );
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_STAT_MOD, hero.location + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_PLUS_MAGIC","H7FCT"), MakeColor(0,255,0,255));
		}
		else if ( pick-(attackP + defenseP + magicP) <= spiritP )
		{
			levelUpData.Stat = STAT_SPIRIT;
			hero.SetSpirit( hero.GetSpiritBase() + mStatIncrease );
			class'H7FCTController'.static.GetInstance().StartFCT(FCT_STAT_MOD, hero.location + HeroMsgOffset, hero.GetPlayer(), class'H7Loca'.static.LocalizeSave("FCT_PLUS_SPIRIT","H7FCT"), MakeColor(0,255,0,255));
		}

		
		hero.AddSkillPoint();
		
		if( class'H7AdventureController'.static.GetInstance().GetRandomSkilling() )
		{   
			hero.GetSkillManager().GetRndSkillManager().QueueStatIncrease(levelUpData);
		}
	}
}

