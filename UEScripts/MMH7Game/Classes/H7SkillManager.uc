//=============================================================================
// H7SkillManager
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7SkillManager extends Object
	dependsOn(H7BaseAbility)
	native(Tussi);

var protected array<H7Skill>		        mAvailableSkills;
var protected array<H7HeroAbility>			mLearnedAbilities;
var protected H7EditorHero			        mOwner;
var protected H7RndSkillManager				mRndSkillManager;
var protected H7HeroEventParam              mEventParam;
var protected int                           mSkillPointsSpend; // only for tracking

function    SetOwner(H7EditorHero owner)    {  mOwner = owner ; } // important for H7EditorHero.OverrideSkillManager() as newly learned skills (during combat) need the CombatHero on Init
function    SetSkillPointsSpend(int value ) { mSkillPointsSpend = value ; }

function array<H7Skill>         GetAllSkills()              { return mAvailableSkills; }
function array<H7HeroAbility>   GetLearnedAbilites()        { return mLearnedAbilities; }
function H7RndSkillManager      GetRndSkillManager()        { return mRndSkillManager; }

function Init( H7Unit owner )
{
	mOwner = H7EditorHero( owner );
	// for duels, random skill manager is not necessary (if it becomes necessary, go fix the none accesses!)
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		mRndSkillManager = new class'H7RndSkillManager'();
		mRndSkillManager.Init( self );
	}
	mSkillPointsSpend = 0;
	mEventParam = new class'H7HeroEventParam';


}

function InitializeSkill( H7Skill skill, ESkillTier tier, int overWriteIndex=INDEX_NONE )
{
    local H7Skill newSkill,deletedSkill; 

	if(skill==none) ;

	// instanciate skill
	newSkill = new skill.Class( skill ); 
	newSkill.OnInit(mOwner);
	newSkill.SetSkillTier( tier );

	// regular
	if( overWriteIndex == INDEX_NONE)
	{
		mAvailableSkills.AddItem( newSkill );
	}
	else // cheat
	{
		deletedSkill = mAvailableSkills[overWriteIndex];
		mOwner.GetAbilityManager().DeleteAllAbilitiesFromSkill(deletedSkill);
		mAvailableSkills.Remove(overWriteIndex,1);
		mAvailableSkills.InsertItem(overWriteIndex, newSkill);
		mOwner.DataChanged();
	}

	AddLearnableAbilities( newSkill );
}

function AddLearnableAbilities( H7Skill forSkill )
{
	local array<H7HeroAbility> allAbilities;
	local H7HeroAbility ability;

	allAbilities = forSkill.GetAllSkillAbilitiesArchetype();
	foreach allAbilities( ability )
	{
		if( forSkill.GetSkillTier() == SKTIER_MINOR && ability.GetRank() > SR_EXPERT )
		{
			continue;
		}
		
		mOwner.GetAbilityManager().AddLearnableAbility( ability );
	}

	if( forSkill.GetSkillTier() == SKTIER_GARNDMASTER )
	{
		mOwner.GetAbilityManager().AddLearnableAbility( forSkill.GetUltimateSkillAbiliyArchetype() );
	}
}

native function CleanSkillsAfterCombat();

function IncreaseRandomMagicSkillRank()
{
	local H7Skill skill;
	local array<H7Skill> skills;

	foreach	mAvailableSkills( skill )
	{
		if( ( skill.GetSchool() == DARK_MAGIC || skill.GetSchool() == LIGHT_MAGIC || skill.GetSchool() == WATER_MAGIC || skill.GetSchool() == AIR_MAGIC || skill.GetSchool() == FIRE_MAGIC || skill.GetSchool() == EARTH_MAGIC || skill.GetSchool() == PRIME_MAGIC ) && 
			skill.GetCurrentSkillRank() >= SR_NOVICE && 
			( skill.GetSkillTier() == SKTIER_MINOR && skill.GetCurrentSkillRank() != SR_EXPERT || skill.GetSkillTier() != SKTIER_MINOR && skill.GetCurrentSkillRank() != SR_MASTER ) )
		{
			skills.AddItem( skill );
		}
	}
	if( skills.Length > 0 )
	{
		IncreaseSkillRank( skills[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( skills.Length ) ].GetID(), false, true );
	}
}

function IncreaseRandomMightSkillRank()
{
	local H7Skill skill;
	local array<H7Skill> skills;

	foreach	mAvailableSkills( skill )
	{
		if( skill.GetSchool() == MIGHT && 
			skill.GetCurrentSkillRank() >= SR_NOVICE && 
			( skill.GetSkillTier() == SKTIER_MINOR && skill.GetCurrentSkillRank() != SR_EXPERT || skill.GetSkillTier() != SKTIER_MINOR && skill.GetCurrentSkillRank() != SR_MASTER ) )
		{
			skills.AddItem( skill );
		}
	}
	if( skills.Length > 0 )
	{
		IncreaseSkillRank( skills[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( skills.Length ) ].GetID(), false, true );
	}
}

function H7HeroAbility GetAbilityByArchetypeID(int skillID, string abilityArchetypeID)
{
	local array<H7HeroAbility> learnableAbilities;
	local int i;
 
	learnableAbilities = mOwner.GetAbilityManager().GetLearnableAbilities();

	for(i=0; i< learnableAbilities.Length; ++i) 
	{
		if( learnableAbilities[i].GetArchetypeID() == abilityArchetypeID )
		{
			return learnableAbilities[i];
		}
	}

	;
	return none;
}

function bool CanIncreaseSkillRank( int SkillID )
{
	local H7Skill skill;
	local array<H7HeroAbility> rankAbilites;
	local H7HeroAbility ability; 

	skill = GetSkillInstance(skillID);
	
	 if( skill.GetCurrentSkillRank() == SR_MASTER )
		return false;

	 if( skill.GetSkillTier() == SKTIER_MINOR && skill.GetCurrentSkillRank() == SR_EXPERT )
		return false;

	 if( skill.GetCurrentSkillRank() == SR_UNSKILLED )
		return true;

	 rankAbilites = skill.GetAbilitiesArchetypesByRank( skill.GetCurrentSkillRank() , true );
	 foreach rankAbilites(ability)
	 {
		if( mOwner.GetAbilityManager().HasAbility( ability )) 
			return true;
	 }

	 return false;
}

function bool CanLearnSkillRank(int skillID, ESkillRank desiredRank)
{
	local H7SKill skill;
	local array<H7HeroAbility> rankAbilies;
	local H7HeroAbility ability;

	skill = GetSkillInstance(skillID);

	switch(desiredRank)
	{
		case SR_NOVICE: return true;
		case SR_MASTER: rankAbilies = skill.GetAbilitiesArchetypesByRank(SR_EXPERT, true);
						break;
		case SR_EXPERT: rankAbilies = skill.GetAbilitiesArchetypesByRank(SR_NOVICE, true);
						break;
	}

	foreach rankAbilies(ability)
	{
		if(HasLearnedAbility(ability)) return true;
	}
	return false;
}

function IncreaseSkillRank( int skillID , optional bool overwriteCheck=false, bool forfree=false )
{
	local H7InstantCommandIncreaseSkill command;
	local JsonObject obj;
	local ESkillRank jrank;
	if(skillID == 0) 
	{
		;
		return;
	}
	
	mSkillPointsSpend++;

	/** TRACKING **/	
	if(  !mOwner.GetPlayer().IsControlledByAI() && mOwner.GetPlayer().IsControlledByLocalPlayer() )
	{
		obj = new class'JsonObject'();
		obj.SetStringValue("heroId",  mOwner.GetOriginArchetype().GetArchetypeID() );
		obj.SetStringValue("heroClass", string ( mOwner.GetHeroClass().Name ));
		obj.SetStringValue("playerFaction", string(mOwner.GetPlayer().GetFaction().Name ));
		obj.SetStringValue("skillId",  GetSkillInstance(skillID).GetArchetypeID()  );
		obj.SetStringValue("skillName", GetSkillInstance(skillID).GetName() );
		jrank = GetSkillInstance(skillID).GetNextSkillRank();
		obj.SetStringValue("skillRank", string( jrank ) );
		obj.SetIntValue("playerPosition", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() );
		obj.SetIntValue("skillPointsSpent", mSkillPointsSpend);
		obj.SetIntValue("nbTurns", class'H7AdventureController'.static.GetInstance().GetCalendar().GetDaysPassed()); 
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_ABILITY_LEARNT","skill.learnt", obj );
	}

	

	command = new class'H7InstantCommandIncreaseSkill';
	command.Init( mOwner, skillID, overwriteCheck, forfree );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function bool IncreaseSkillRankComplete( int skillID , optional bool overwriteCheck=false, bool forfree=false )
{
	local int rank;
	local H7Skill skill;

	if(skillID == 0) 
	{
		;
		return false;
	}

	skill =  GetSkillInstance(skillID);
	rank  = int(skill.GetCurrentSkillRank());

	if(skill.GetCurrentSkillRank() == SR_MASTER) return false;

	if( !CanIncreaseSkillRank( skillID ) && !overwriteCheck)
	{
		;
		return false; 
	}

	rank++;

	skill.SetCurrentSkillRank( ESkillRank(rank)  );
   
	if(!forfree) { mOwner.SpendSkillPoint(); }

	mEventParam.mEventHeroTemplate = class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ? mOwner.GetAdventureArmy().GetHeroTemplateSource() : mOwner.GetCombatArmy().GetHeroTemplateSource();
	mEventParam.mEventPlayerNumber = class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ? mOwner.GetAdventureArmy().GetPlayerNumber() : mOwner.GetCombatArmy().GetPlayerNumber();
	mEventParam.mEventSkill = skill;
	mEventParam.mEventSkillRank = ESkillRank(rank);
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnSkill', mEventParam, mOwner);
	Skill.GetEventManager().Raise( ON_SKILL_LEVEL_UP, false );

	if(class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetRandomSkilling())
		GetRndSkillManager().Reset();

	return true;
}

function bool HasSkillMaxedOut( int skillID, ESkillTier tier ) 
{
	local H7Skill skill;
	local array<H7HeroAbility> abilities;
	local H7HeroAbility ability;

	skill = GetSkillInstance( skillID );
	
	if( tier == SKTIER_GARNDMASTER )
	{
		// get all abilites for that skill;
		abilities = skill.GetAllSkillAbilitiesArchetype();
		abilities.AddItem( skill.GetUltimateSkillAbiliyArchetype() );	
	}
	else if ( tier == SKTIER_MASTER ) 
	{
		abilities = skill.GetAbilitiesArchetypesByRank( SR_MASTER );
	}
	else  if( tier == SKTIER_MINOR ) 
	{
		abilities = skill.GetAbilitiesArchetypesByRank( SR_EXPERT );
	}

	foreach abilities(ability)
	{
		if( !HasLearnedAbility( ability ) ) 
			return false;	
	}

	return true;
}



function LearnAbilityfromSkillByID( int skillID, String abilityID )
{
	local H7InstantCommandLearnAbility command;
	local JsonObject obj;

	mSkillPointsSpend++;

	/** TRACKING **/	
	if(  !mOwner.GetPlayer().IsControlledByAI() && mOwner.GetPlayer().IsControlledByLocalPlayer() )
	{
		obj = new class'JsonObject'();
		obj.SetStringValue("heroId", mOwner.GetOriginArchetype().GetArchetypeID());
		obj.SetStringValue("heroClass", string ( mOwner.GetHeroClass().Name ));
		obj.SetStringValue("playerFaction", string(mOwner.GetPlayer().GetFaction().Name ));
		obj.SetStringValue("abilityId", abilityID );
		obj.SetStringValue("abilityName", GetAbilityByArchetypeID(skillID, abilityID ).GetName() );
		obj.SetIntValue("playerPosition", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() );
		obj.SetIntValue("skillPointsSpent", mSkillPointsSpend);
		obj.SetIntValue("nbTurns", class'H7AdventureController'.static.GetInstance().GetCalendar().GetDaysPassed()); 
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_ABILITY_LEARNT","ability.learnt", obj );
	}

	
	command = new class'H7InstantCommandLearnAbility';
	command.Init( mOwner, skillID, abilityID );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function bool LearnAbilityfromSkillByIDComplete( int skillID, String abilityID )
{
	local array<H7HeroAbility> skillAbilities;
	local array<H7HeroAbility> masterAbilities;
	local H7Skill skill;
	local int i,skillIndex;

	skill = GetSkillInstance( skillID );

	// get all possible abilites by my current rank 
	skillAbilities = skill.GetAbilitiesArchetypesByRank(skill.GetCurrentSkillRank());
		
	if(class'H7AdventureController'.static.GetInstance().GetRandomSkilling())
		GetRndSkillManager().Reset();

	for(i=0; i< skillAbilities.Length; ++i) 
	{
		;
		if( skillAbilities[i].GetArchetypeID() != abilityID )
			continue;

		// we dont want it to learn again
		if( mOwner.GetAbilityManager().HasAbility( skillAbilities[i] ) )
			return false;

		DoLearnAbility( skillAbilities[i] );
		mOwner.SpendSkillPoint();

		//check the ability we just learnd is the master ability and if so
		//set ultimateRequirement to true
		masterAbilities = skill.GetAbilitiesArchetypesByRank(SR_MASTER, true);
		skillIndex = mAvailableSkills.Find(skill);
		if(masterAbilities[0] == skillAbilities[i] && skillIndex != INDEX_NONE && skillIndex < 3  ) skill.SetUltimateRequirment(true);

		mEventParam.mEventHeroTemplate = class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ? self.mOwner.GetAdventureArmy().GetHeroTemplateSource() : 
			self.mOwner.GetCombatArmy().GetHeroTemplateSource();
		mEventParam.mEventPlayerNumber = self.mOwner.GetPlayer().GetPlayerNumber();
		mEventParam.mEventSkill = skill;
		mEventParam.mEventLearnedAbility = skillAbilities[i];

		if(skillAbilities[i].IsSpell())
		{
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnSpell', mEventParam, mOwner);
		}
		else
		{
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnAbility', mEventParam, mOwner);
		}

		return true;
	}
	return false;
}

// TODO deprecate and move to LearnAbilityfromSkillByID 
function bool LearnAbilityfromSkill( int skillID, string abilityName )
{
	local array<H7HeroAbility> skillAbilities;
	local H7Skill skill;
	local int i;

	skill = GetSkillInstance( skillID );

	// get all possible abilites by my current rank 
	skillAbilities = skill.GetAbilitiesArchetypesByRank(skill.GetCurrentSkillRank());
		
	for(i=0; i< skillAbilities.Length; ++i) 
	{
		if( skillAbilities[i].GetName() != abilityName )
			continue;

		// we dont want it to learn again
		if( mOwner.GetAbilityManager().HasAbility( skillAbilities[i] ) )
			return false;

		DoLearnAbility( skillAbilities[i] );
		mOwner.SpendSkillPoint();

		mEventParam.mEventHeroTemplate = class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ? self.mOwner.GetAdventureArmy().GetHeroTemplateSource() : 
			self.mOwner.GetCombatArmy().GetHeroTemplateSource();
		mEventParam.mEventPlayerNumber = self.mOwner.GetPlayer().GetPlayerNumber();
		mEventParam.mEventSkill = skill;
		mEventParam.mEventLearnedAbility = skillAbilities[i];

		if(skillAbilities[i].IsSpell())
		{
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnSpell', mEventParam, mOwner);
		}
		else
		{
			class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_LearnAbility', mEventParam, mOwner);
		}
		return true;
	}
	return false;
}

function OverwriteSkill( int oldSkillID, String newSkillAID )
{
	local H7InstantCommandOverwriteSkill command;

	command = new class'H7InstantCommandOverwriteSkill';
	command.Init( mOwner, oldSkillID, newSkillAID );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function OverwriteSkillComplete( int oldSkillID, String newSkillAID )
{
	local H7Skill newSkill;
	local array<H7HeroAbility> skillabilites;
	local H7HeroAbility skillability;
	local int skillId;

	// find new skill archetype:
	newSkill = class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().GetCheatData().GetSkillByName( newSkillAID );
	
	if( newSkill == none ) 
		return;
	
	skillId = GetSkillIndex( oldSkillID );

	// archetype->instance
	InitializeSkill( newSkill, mAvailableSkills[skillId].GetSkillTier(), skillId);

	//delete old skill abilities
	skillabilites= GetSkillInstance(oldSkillID).GetAllSkillAbilitiesArchetype();

	foreach skillabilites(skillability)
	{
		if( mOwner.GetAbilityManager().HasAbility(skillability) )
		{
			mOwner.GetAbilityManager().UnlearnAbility( skillability );
		}
	}
	
	
	// TODO:delete old skill
}

function bool CanLearnUltimate(int skillID)
{
	local array<H7HeroAbility> skillAbilities;
	local H7Skill skill;
	local bool learnedAbility;
	local int i;

	skill = GetSkillInstance( skillID );
	if(skill.GetCurrentSkillRank() != SR_MASTER) return false;
	
	skillAbilities = skill.GetAbilitiesArchetypesByRank(skill.GetCurrentSkillRank());

	//check if at least one novice ability is learned
	skillAbilities = skill.GetAbilitiesArchetypesByRank(SR_NOVICE, true);
	for(i=0; i< skillAbilities.Length; i++) 
	{
		if(HasLearnedAbility(skillAbilities[i])) learnedAbility = true;
	}
	if(!learnedAbility) return false;

	//check if at least one expert ability is learnd
	learnedAbility = false;
	skillAbilities = skill.GetAbilitiesArchetypesByRank(SR_EXPERT, true);
	for(i=0; i< skillAbilities.Length; i++) 
	{
		if(HasLearnedAbility(skillAbilities[i])) learnedAbility = true;
	}
	if(!learnedAbility) return false;

	//check if master ability is learned
	skillAbilities = skill.GetAbilitiesArchetypesByRank(SR_MASTER, true);
	if(!HasLearnedAbility(skillAbilities[0])) return false;

	return true;
}

/// TODO more designer magic here 
function LearnUltimate( int skillID, string abilityID )
{
	local H7InstantCommandLearnAbility command;
	local H7Skill skill;
	local JsonObject obj;

	skill = GetSkillInstance( skillID );

	// only once
	if( mOwner.GetAbilityManager().HasAbility( skill.GetUltimateSkillAbiliyArchetype() ) )
	{
		return;
	}

	mSkillPointsSpend++;

	/** TRACKING **/	
	if(  !mOwner.GetPlayer().IsControlledByAI() && mOwner.GetPlayer().IsControlledByLocalPlayer() )
	{
		obj = new class'JsonObject'();
		obj.SetStringValue("heroId", mOwner.GetOriginArchetype().GetArchetypeID());
		obj.SetStringValue("heroClass", string ( mOwner.GetHeroClass().Name ));
		obj.SetStringValue("playerFaction", string(mOwner.GetPlayer().GetFaction().Name ));
		obj.SetStringValue("abilityId", abilityID );
		obj.SetStringValue("abilityName", GetAbilityByArchetypeID(skillID, abilityID ).GetName() );
		obj.SetIntValue("playerPosition", class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetPlayerNumber() );
		obj.SetIntValue("skillPointsSpent", mSkillPointsSpend);
		obj.SetIntValue("nbTurns", class'H7AdventureController'.static.GetInstance().GetCalendar().GetDaysPassed()); 
		OnlineSubsystemUPlay(class'GameEngine'.static.GetOnlineSubsystem()).PushEvent("UTT_ABILITY_LEARNT","ability.learnt", obj );
	}

	command = new class'H7InstantCommandLearnAbility';
	command.Init( mOwner, skillID, skill.GetUltimateSkillAbiliyArchetype().GetArchetypeID() );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function int GetSkillIndex(int ID)
{
	local int i;

	for ( i=0; i<mAvailableSkills.Length; ++i )
	{

		if( mAvailableSkills[i] != None )
		{
			if(ID != 0 &&  mAvailableSkills[i].GetID() == ID )
				return i;
		}
	}

	;
	return INDEX_NONE;
}

function H7Skill GetSkillInstance( optional int ID, optional H7Skill skill )
{
	local int i;

	for ( i=0; i<mAvailableSkills.Length; ++i )
	{
		if( mAvailableSkills[i] != None )
		{
			if(ID != 0 &&  mAvailableSkills[i].GetID() == ID )
			{
				return mAvailableSkills[i];
			}
		
			if( skill != none && mAvailableSkills[i].GetName() == skill.GetName() )
			{
				return mAvailableSkills[i];
			}
		}
	}

	return none;
}

native function GetProductionSkills(out array<H7EffectSpecialAddResources> produc);

native function H7Skill GetSkillBySkillType(ESkillType type);

function InitializePreLearnedAbilities( array<H7HeroAbility> abilities ) 
{
	local H7HeroAbility ability;

	foreach abilities(ability)
	{
		DoLearnAbility( ability );
		// check if skill ultimate is learnable (in case of nice LDs who are generous with pre-learned abilities)
		if( !ability.IsSpell() && ability.GetRank() == SR_MASTER )
		{
			GetSkillBySkillType( ability.GetSkillType() ).SetUltimateRequirment( true );
		}
	}	
}

// Hero will learn this ability
function DoLearnAbility(H7HeroAbility ability)
{
	local H7HeroAbility ablilityLearned;

	if(ability == none)
	{
		;

		return;
	}

	ablilityLearned = H7HeroAbility( mOwner.GetAbilityManager().LearnAbility( ability ) );

	if(ability == none)
	{
		//`LOG_MP("SkillTrack: "@self@"of owner"@mOwner@" is about to learn"@ablilityLearned@"that comes from"@ability@"!");
		ScriptTrace();
	}
	

	mLearnedAbilities.AddItem( ablilityLearned );
}

function AddToLearnedAbilities( H7HeroAbility ability )
{
	if( !ability.IsArchetype() && !HasLearnedAbility(ability))
	{   
		if(ability == none)
		{
			//`LOG_MP("SkillTrack: "@self@"of owner"@mOwner@" is about to learn"@ability@"!");
			ScriptTrace();
		}
		
		mLearnedAbilities.AddItem( ability );
	}
}

function RemoveFromLearnedAbilities( H7HeroAbility ability )
{
	if( !ability.IsArchetype() )
	{
		//`LOG_MP("SkillTrack : Removing ability" @ability@ "of archetype path" @class'H7GameUtility'.static.GetArchetypePath(ability)@ "from SkillManager" @self@ "of owner"@mOwner@"! Currently there is"@mLearnedAbilities.Length@"abilities on the list.");
		ScriptTrace();

		mLearnedAbilities.RemoveItem( ability );
	}
}


function array<H7HeroAbility> GetAllUnlearnedAbilites(bool onlyForCurrRank)
{
	local array<H7HeroAbility> unlearnedAbilites, abilities;
	local H7HeroAbility ability;
	local H7Skill skill;

	foreach mAvailableSkills(skill)
	{
			abilities = skill.GetAbilitiesArchetypesByRank(skill.GetCurrentSkillRank(), onlyForCurrRank);
			foreach abilities(ability)
			{
				if( mOwner.GetAbilityManager().HasAbility( ability ) )
					continue;

				if( ability.GetRank() > skill.GetCurrentSkillRank() )
					continue;
				
				if( ability.IsGrandMasterAbility() && !CanLearnUltimate( skill.GetID() ) )
					continue;
				unlearnedAbilites.AddItem( ability );
			}
	}
		
	return unlearnedAbilites;
}

function JSonObject Serialize()
{
	local JSonObject json;
	local int i;

	json = new () class'JSonObject';

	json.SetIntValue("SkillAmount", mAvailableSkills.Length); // get amount of skills
	json.SetIntValue("AbilityAmount", mLearnedAbilities.Length); // get amount of abilities

	for(i=0; i<mAvailableSkills.Length; ++i)
	{
		json.SetStringValue("Skill"$i, PathName(mAvailableSkills[i].ObjectArchetype));
		json.SetIntValue("Rank"$i, mAvailableSkills[i].GetCurrentSkillRank());
	}

	for(i=0; i<mLearnedAbilities.Length; ++i)
	{
		json.SetStringValue("Ability"$i, PathName(mLearnedAbilities[i].ObjectArchetype));
	}

	return json;
}

function Deserialize(JSonObject Data)
{
	local H7Skill currentSkill;
	local H7HeroAbility currentAbility;
	local string currentArchetype;
	local int skillAmount, abilityAmount, i, x;
	local ESkillRank rank;

	skillAmount = Data.GetIntValue("SkillAmount"); // get amount of skills
	abilityAmount = Data.GetIntValue("AbilityAmount"); // get amount of abilities

	for(i=0; i<skillAmount; ++i)
	{
		currentArchetype = Data.GetStringValue("Skill"$i);
		if(FindObject(currentArchetype, class'H7Skill') != none)
		{
			currentSkill = H7Skill(DynamicLoadObject(currentArchetype, class'H7Skill'));
			rank = ESkillRank( Data.GetIntValue("Rank"$i) );
			if(rank == SR_UNSKILLED) continue;

			for(x=0; x<mAvailableSkills.Length; ++x)
			{
				if(currentSkill.IsEqual(mAvailableSkills[x]))
				{
					mAvailableSkills[i].SetCurrentSkillRank(rank);
					break;
				}
			}
		}
	}

	for(i=0; i<abilityAmount; ++i)
	{
		currentArchetype = Data.GetStringValue("Ability"$i);
		if(FindObject(currentArchetype, class'H7HeroAbility') != none)
		{
			currentAbility = H7HeroAbility(DynamicLoadObject(currentArchetype, class'H7HeroAbility'));
			DoLearnAbility(currentAbility);
		}
	}
}

function bool HasLearnedAbility(H7HeroAbility ability )
{
	local int i;
	
	for( i=0; i< mLearnedAbilities.Length; ++i ) 
		if( mLearnedAbilities[i].GetName() == ability.GetName()  ) 
			return true;
		
	return false;
}

native function RaiseEvent(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container);

function GetAbilityByAbilityId( string abilityId)
{

}

/* Logs current game state for OOS */
function DumpCurrentState()
{
	local H7HeroAbility ability;
	local H7Skill skill;
	local array<H7HeroAbility> abilities;
	class'H7ReplicationInfo'.static.PrintLogMessage("    Skills:", 0);;

	foreach mAvailableSkills(skill)
	{
		if(skill.GetCurrentSkillRank() > SR_UNSKILLED)
		{
			class'H7ReplicationInfo'.static.PrintLogMessage("     "@skill.GetName()@skill.GetCurrentSkillRank(), 0);;

			abilities = skill.GetAllSkillAbilitiesArchetype();

			foreach abilities(ability)
			{
				if(HasLearnedAbility(ability))
				{
					ability = ability; // warning hack
					class'H7ReplicationInfo'.static.PrintLogMessage("       "@ability.GetName(), 0);;
				}
			}
		}
	}
}
