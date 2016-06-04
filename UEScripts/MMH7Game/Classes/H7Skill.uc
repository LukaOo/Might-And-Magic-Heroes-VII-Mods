//=============================================================================
// H7Skill
//=============================================================================
// Wrapper class to hold abilities for a skill
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Skill extends H7EffectContainer
	dependson(H7StructsAndEnumsNative, H7HeroAbility)
	native(Tussi)
	savegame;


var(Container, Skill) protected localized string       mDescriptions[ESkillRank.SR_MAX]     <DisplayName=Skill Descriptions>;
var(Container, Skill) protected array<H7HeroAbility>   mSkillAbilitiesArchetype             <DisplayName=Abilities>;
var(Container, Skill) protected H7HeroAbility          mSkillUltimateAbilityArchetype       <DisplayName=Ultimate Ability>;
var(Container, Skill) protected ESkillRank             mPreSetSkillRank                     <DisplayName=Pre Defined Skill Rank>;

var(Container, Skill) protected Texture2D              mIcons[ESkillRank.SR_MAX]            <DisplayName=Skill Icons>;


var protected int                           mID;                 
var protected ESkillRank                    mCurrentSkillRank; 
var protected bool                          mUltimateRequirment;
var protected ESkillTier                    mSkillTier;


native function int GetID();

function      Texture2D                     GetSkillIcon( ESkillRank rank )		    { return mIcons[ rank ]; }
function      String                        GetFlashIconPath( ESkillRank rank )     { return "img://" $ Pathname( mIcons[ rank ] ); }
function      array<H7HeroAbility>          GetAllSkillAbilitiesArchetype()         { return mSkillAbilitiesArchetype; }
function      H7HeroAbility                 GetUltimateSkillAbiliyArchetype()       { return mSkillUltimateAbilityArchetype; }
function      ESkillRank                    GetCurrentSkillRank()                   { return mCurrentSkillRank; }
function                                    SetCurrentSkillRank(ESkillRank value)   { mCurrentSkillRank = value; }
function      bool                          IsSkill()	                            { return true; }
function      bool                          GetUltimateReqirement()                 { return mUltimateRequirment; }
function                                    SetUltimateRequirment( bool b )         { if( !mUltimateRequirment ) mUltimateRequirment = b; }
function      ESkillTier                    GetSkillTier()                          { return mSkillTier; }
function                                    SetSkillTier(EskillTier tier )          { mSkillTier = tier;}
function                                    SetSkillID(int id)                      { mID = id; }

function string GetDescription( ESkillRank rank )       
{ 
	local string descLocalized;
	local H7skill tmpSkill;

	if(IsArchetype())
	{
		tmpSkill = new self.Class(self);
		tmpSkill.SetCaster( mCaster );
		tmpSkill.SetOwner( mCaster );
		return tmpSkill.GetDescription(rank);
	}

	descLocalized = GetArchetypeDescription( rank );
	return "<font size='#TT_BODY#'>" $ GetTooltip(false,descLocalized);
}
 
function string GetArchetypeDescription( ESkillRank rank )
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		return class'H7Loca'.static.LocalizeContent(self, class'H7Loca'.static.GetArrayFieldName("mDescriptions",rank), mDescriptions[rank]);
	}
	else
	{
		return H7Skill( ObjectArchetype ).GetArchetypeDescription( rank );
	}
}

function OnInit( H7Unit owner )
{
	SetCaster( none );
	SetOwner( owner );
    
	mCurrentSkillRank = SR_UNSKILLED;

	if( mPreSetSkillRank > SR_ALL_RANKS )
		mCurrentSkillRank = mPreSetSkillRank;

	
	if(mID == 0 || !IsArchetype())
	{
		mID = class'H7ReplicationInfo'.static.GetInstance().GetNewID();
		
		// instanciate of all effects for this skill  
		InstanciateEffectsFromStructData();
	}
}

// !!! rank parameter is ignored when it is ALL_RANKS, uses current hero rank (function can not be used to get all 6 abilities) use: GetAllSkillAbilitiesArchetype
// onlyThisRank = true -> all abilities AT rank
// onlyThisRank = false -> all abilities UP TO AND INCLUDING rank
function array<H7HeroAbility> GetAbilitiesArchetypesByRank(optional ESkillRank rank, optional bool onlyThisRank ) 
{
	local int i;
	local ESkillRank checkRank;
	local array<H7HeroAbility> abilitiesByRank; 
	
	checkRank = GetCurrentSkillRank();

	if( rank != SR_ALL_RANKS )
		checkRank = rank;

	for( i = 0; i < mSkillAbilitiesArchetype.Length; ++i ) 
	{
		if( mSkillAbilitiesArchetype[i].GetRank() == checkRank ) 
		{
			abilitiesByRank.AddItem ( mSkillAbilitiesArchetype[i] );
		}
		else if( mSkillAbilitiesArchetype[i].GetRank() <= checkRank && !onlyThisRank ) 
		{
			abilitiesByRank.AddItem ( mSkillAbilitiesArchetype[i] );
		}
	}

	// check Ultimate Ability rank (should be Master)
	if(mSkillUltimateAbilityArchetype != none)
	{
		if( mUltimateRequirment && mSkillUltimateAbilityArchetype.GetRank() <= checkRank )
		{
			abilitiesByRank.AddItem(mSkillUltimateAbilityArchetype);
		}
	}
	return abilitiesByRank;
}


function bool CanLearnAbility( H7HeroAbility ability )
{
	if( ability == none )
	{
		return false;
	}
	if( ability.GetRank() <= GetCurrentSkillRank() )
	{
		if( ability.IsGrandMasterAbility() ) 
		{
			if( mUltimateRequirment ) 
				return true;
			
			return false;
		}
		else 
		{
			return true;
		}
	}

	return false;
}

function ESkillRank GetPreviousSkillRank()
{
	local int rank;

	if( GetCurrentSkillRank() == SR_UNSKILLED )
		return SR_UNSKILLED;

	rank = int(GetCurrentSkillRank()) - 1;
	return ESkillRank( rank ); 
}

function ESkillRank GetNextSkillRank()
{
	local int rank;

	if( GetCurrentSkillRank() == SR_MASTER )
		return SR_MASTER;

	rank = int(GetCurrentSkillRank()) + 1;
	return ESkillRank( rank ); 
}


function int GetInvestedPointsCount()
{
	local int investedPoints;
	local H7SkillManager manager;
	local H7HeroAbility ability;

	if(!mOwner.IsA('H7AdventureHero')) return 0;

	manager = H7AdventureHero(mOwner).GetSkillManager();
	investedPoints = mCurrentSkillRank - 1;

	foreach mSkillAbilitiesArchetype(ability)
	{
		if(manager.HasLearnedAbility(ability)) investedPoints++;
	}

	return investedPoints;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

