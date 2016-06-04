//=============================================================================
// H7EditorHero
//=============================================================================
// Editor shell for the hero for sanity checks. Creates a H7CombatHero using the
// properties set in the editor
//=============================================================================
// TODO: 
// Sanity checks for:
// Adding a learned skill (check if it is class template)
// Adding a learned ability (check prerequisites, check if its master skill 
// has it in its ability list)
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorHero extends H7Unit
	implements(H7IThumbnailable,H7IOwnable,H7IAliasable,H7ILocaParamizable)
	native
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display,SkeletalMeshActor)
	savegame;

const MANA_MULTIPLIER = 10;

var protected transient H7EditorHero                        mOriginArchetype;
var protected transient string                              mTransientName;

//Always needed visuals faction specialization frame
var(Visuals) protected Texture2D                            mFactionSpecializationFrame<DisplayName=Specialization Frame>;
var(Visuals) protected Texture2D                            mFactionBGHeroWindow<DisplayName=Hero Window Background>;
var(Visuals) dynload protected Texture2D	                        mImage<DisplayName=Fullbody Image (Hero Window)>;
var(Visuals) protected int                                  mImageXOffset<DisplayName=Fullbody Iamage X Offset>;
var(Visuals) protected int                                  mImageYOffset<DisplayName=Fullbody Iamage Y Offset>;
var(Visuals) protected Color                                mColor<DisplayName=Fallback Color (when not on map)>;

var(Visuals) dynload protected H7HeroVisuals                mVisuals<DisplayName=Hero Visuals>; // DO NOT USE THIS VARIABLE DIRECTLY, ONLY USE WITH THE GETTER

var(Faction)  H7EditorWarUnit	                            mWarfareSiege<DisplayName=Siege Catapult>;

// == class and class overwrite == 
var(Properties) protected H7HeroClass						mClass<DisplayName=Hero Class|EditCondition=!mOverrideHeroClassSkills>;
var(Properties) protected bool                              mOverrideHeroClassSkills<DisplayName="Use Override Hero Class Skills">;
// Important: This will override the current HeroClass skill setup on the same pos  
var(Properties) protected H7HeroSkill                       mPreLearnedSkills[10]<DisplayName="Override Hero Class Skills"|EditCondition=mOverrideHeroClassSkills>;

// == start setup init stuff ==
var(Properties) protected H7HeroAbility						mStartingAbility<DisplayName=Specialization Ability>;
var(Properties) protectedwrite H7Skill                      mStartSkills[2]<DisplayName=Free 2 Pre-Learned Start Skills (on Novice)>;
var(Properties) protected array<H7HeroAbility>				mStartingSpellArchetypes<DisplayName=Starting Spells>; //Only for editor-entries, which are copied into the H7AbilityManager
var(Properties) protected H7HeroEquipment			        mEquipment<DisplayName=Equipment>;
var(Properties) protected H7Inventory				        mInventory<DisplayName=Iventory>;
var(Properties) protected bool                              mSaveHeroProgress<DisplayName=Save Hero Progress?>;
var(Properties) protected array<H7HeroBioData>              mHeroBioData<DisplayName=HeroBio Data>;
var(Properties) protected H7EditorHero                      mHeropediaOverwrite<DisplayName=Heropedia Hero Overwrite>;

// == stats ==
var(Stats) protected int									mMagic<DisplayName=Magic|ClampMin=0>;
var(Stats) protected int                                    mMaxManaBonus<DisplayName=Bonus Maximum Mana>;
var(Stats) protected int									mSpirit<DisplayName=Spirit|Clamp=0>;
var(Stats) protected int									mLevel<DisplayName=Level|ClampMin=1|ClampMax=30>;
var(Stats) protected int                                    mMaxDeploymentNumber<DisplayName=Max Creatures to Deploy|ClampMin=1>;
var(Stats) protected int                                    mMaxDeploymentRows<DisplayName=Max Deployment Rows|ClampMin=1>;   

// == default army to use in the hall of heroes ==
var(HallOfHeroes) protected array<CreatureStackProperties>  mHoHDefaultArmy<DisplayName="Default army">;

// === AI ==
var(Ai) protected EHeroAiControlType                        mAiControlType<DisplayName=AI Control Type>;
var(Ai) protected EHeroAiAggressiveness                     mAiAggressiveness<DisplayName=Aggressiveness Level>;
var(Ai) protected bool                                      mAiInHibernation<DisplayName=Is in hibernation mode>;
var(Ai) protected H7VisitableSite                           mAiHomeSite<DisplayName=Home Site>;
var(Ai) protected float                                     mAiHomeRadius<DisplayName=Home Radius>;
var(Ai) protected H7VisitableSite                           mAiObjectiveSite<DisplayName=Objective Site>;
var(Ai) protected H7AdventureArmy                           mAiObjectiveArmy<DisplayName=Objective Army>;
var(Ai) protected H7AiPatrolController                      mAiPatrolController<DisplayName=Patrol Controller>;
var(Ai) protected bool                                      mAiOnPatrol<DisplayName=On Patrol>;
var(Ai) protected EHeroAiRole                               mAiPreferedRole<DisplayName=Prefered Role>;
var(Ai) protected EHeroAiRole                               mAiRole<DisplayName=Role>;
var protected savegame int                                  mAiRolePriority; // only used for HRL_MAIN at the moment

// Sound
var(HeroSounds) protected AkEvent                          mMountedAttackSound_Might<DisplayName=Mounted Attack (might)>;
var(HeroSounds) protected AkEvent                          mMountedRangeAttackSound_Might<DisplayName=Mounted Range Attack (might)>;
var(HeroSounds) protected AkEvent                          mMountedAbilitySound_Might<DisplayName=Mounted Ability (might)>;
var(HeroSounds) protected AkEvent                          mMountedDefeatSound_Might<DisplayName=Mounted Battle Defeat (might)>;
var(HeroSounds) protected AkEvent                          mMountedVictorySound_Might<DisplayName=Mounted Battle Victory (might)>;
var(HeroSounds) protected AkEvent                          mMountedCommandSound_Might<DisplayName=Mounted Command (might)>;
var(HeroSounds) protected AkEvent                          mStartMountedIdleSound_Might<DisplayName=Mounted Idle (might)>;
var protected AkEvent                                      mEndMountedIdleSound_Might;
var(HeroSounds) protected AkEvent                          mMountedAttackSound_Magic<DisplayName=Mounted Attack (magic)>;
var(HeroSounds) protected AkEvent                          mMountedRangeAttackSound_Magic<DisplayName=Mounted Range Attack (magic)>;
var(HeroSounds) protected AkEvent                          mMountedAbilitySound_Magic<DisplayName=Mounted Ability (magic)>;
var(HeroSounds) protected AkEvent                          mMountedDefeatSound_Magic<DisplayName=Mounted Battle Defeat (magic)>;
var(HeroSounds) protected AkEvent                          mMountedVictorySound_Magic<DisplayName=Mounted Battle Victory (magic)>;
var(HeroSounds) protected AkEvent                          mMountedCommandSound_Magic<DisplayName=Mounted Command (magic)>;
var(HeroSounds) protected AkEvent                          mStartMountedIdleSound_Magic<DisplayName=Mounted Idle (magic)>;
var protected AkEvent                                      mEndMountedIdleSound_Magic;
var(HeroSounds) protected AkEvent                          mStartMountedRandomMoveSounds<DisplayName=Random Mounted Move sound>;
var protected AkEvent                                      mEndMountedRandomMoveSounds;
var(HeroSounds) protected AkEvent                          mStartShipRandomMoveSounds<DisplayName=Random Ship Move sound>;
var protected AkEvent                                      mEndShipRandomMoveSounds;
var(HeroSounds) protected AkEvent                          mMountedTurnLeftSounds<DisplayName=Turn left sound>;
var(HeroSounds) protected AkEvent                          mMountedTurnRightSounds<DisplayName=Turn right sound>;
var(HeroSounds) protected AkEvent                          mLevelUpSounds<DisplayName=Level up sound>;
var(HeroSounds) protected AkEvent                          mCombatPopUpScreenStartSounds<DisplayName=Engage enemy sound>;
var(HeroSounds) protected AkEvent                          mEngageManuallySounds<DisplayName=Engage manually sound>;
var(HeroSounds) protected AkEvent                          mEngageQuickCombatSounds<DisplayName=Engage quickcombat sound>;
var(HeroSounds) protected AkEvent                          mBoardShipSounds<DisplayName=Board Ship sound>;
var(HeroSounds) protected AkEvent                          mShipTurningSounds<DisplayName=Turn Ship sound>;
var(HeroSounds) protected AkEvent                          mStartShipIdleSounds<DisplayName=Ship Idle sound>;
var protected AkEvent                                      mEndShipIdleSounds;

var(Developer) protected H7GlobalName mGlobalName<DisplayName="Global Name">;

// visuals  3D rep-
var() SkeletalMeshComponent			        mHeroSkeletalMesh;
var() StaticMeshComponent				    mWeaponMesh;
var() SkeletalMeshComponent			        mHorseSkeletalMesh;

// Archetype used to match up sub-archetyped heroes, created by the Hero Army Property Window, during custom campaign map transition
var() protected H7EditorHero mCampaignTransitionHeroArchetype<DisplayName="Campaign Transition Hero Archetype">;

var protected bool											mIsHero;
var protected H7HeroProgress								mXpProgress;
var protected H7Player										mOwningPlayer;
var protected array<H7HeroAbility>							mQuickBarCombat;
var protected array<H7HeroAbility>							mQuickBarAdventure;

var protectedwrite EScriptedBehaviour						mScriptedBehaviour;

var protected H7HeroFX										mFX;
var protected H7HeroAnimControl								mAnimControl;
var protected H7SkillManager						        mSkillManager;

// == runtime dynamic auto-calculated values ==
var transient protected int						            mXp<DisplayName=Experience Points (Use Stats.Level!)|ClampMin=0>; // if you want to set start level use (Stats)Level
var transient protected int							        mSkillPoints<DisplayName=Skill Points (Use Stats.Level!)>; // if you want to set start skillpoints set a level (Stats)Level
var transient protected float						        mCurrentMovementPoints<DisplayName=Movement Points Current|ClampMin=0>;
var transient protected float                               mSaveMovementPoints; // Used during save/load for restoration of mp AFTER buff are applied 
var transient protected int			 						mCurrentMana<DisplayName=Mana Current|ClampMin=0>;
// @CB1 - This can be deleted after Closed Beta and all methods using this value. ManaRegen is now based on HeroSpirit x Multiplier (set in AdvConf)
var transient protected int									mManaRegenBase<DisplayName=Base Mana Regeneration %|ClampMin=0|ClampMax=100>;

var protected int                                           mBattleRage;
var protected int                                           mMetamagic;
var protected int                                           mArcaneKnowledgeBase;
var protected int                                           mMinDamagePerLevel;
var protected int                                           mMaxDamagePerLevel;
var protected Texture2D                                     mOverwriteIcon; // TODO save path into savegame struct and restore

var protected H7BaseAbility                                 mCurrentPreviewAbility;
var protected bool                                          mIsPendingLevelUp;

// Scripting
var H7HeroEventParam mHeroEventParam;

var array<MaterialInstanceConstant> HeroMaterials;

native function int GetQuickCombatSubstituteImpact( EQuickCombatSubstitute substitute );
native function int GetAmountOfWarcries();

native function EUnitType				GetEntityType();

/*************                       GET / SET FUNCTIONS                           ********/
function string                         GetArchetypeID()                                { return class'H7GameUtility'.static.IsArchetype(self)?String(self): H7EditorHero(ObjectArchetype).GetArchetypeID();}               
function								SetIsHero( bool value )							{ mIsHero = value; }
function bool							IsHero()										{ return mIsHero; }
function H7HeroAnimControl				GetAnimControl()								{ return mAnimControl; }
function Vector							GetHorseRiderOffset()							{ return GetVisuals().GetHorseRiderOffset(); }

function                                SetCurrentPreviewAbility( H7BaseAbility ab )    { mCurrentPreviewAbility = ab; }
function                                SetPendingLevelUp( bool b )                     { mIsPendingLevelUp = b;}
function bool                           HasPendingLevelUp()                             { return mIsPendingLevelUp; }



function RestoreSavedMovementPoints()
{
	if(mSaveMovementPoints >= 0.0f)
	{
		mCurrentMovementPoints = mSaveMovementPoints;
		DataChanged();

		mSaveMovementPoints = - 1;
	}
}

function string GetName()
{
	if(mTransientName != "")
	{
		return mTransientName;
	}
	else
	{
		if(mGlobalName == none)
		{
			return super.GetName();
		}
		else
		{
			return mGlobalName.GetName();
		}
	}
}

function EAttackRange					GetAttackRange()								{ return CATTACKRANGE_FULL; }
function H7Player						GetPlayer()										{ return mOwningPlayer; }
function H7HeroEquipment				GetEquipment()									{ return mEquipment; }
function H7Inventory					GetInventory()									{ return mInventory; }
function array<H7HeroAbility>			GetQuickBarSpells(bool combat)					{ if(combat) return mQuickBarCombat;else return mQuickBarAdventure; }
function String							GetFlashMinimapPath()							{ return "img://" $ Pathname( GetVisuals().GetMinimapIcon() ); }
//function String							GetFlashImagePath()							    { return "img://" $ Pathname( mImage ); }
function int                            GetPrevLevelXp()                                { if(mLevel > 30){ return  mXpProgress.mXpTable[29]; }else { return mXpProgress.mXpTable[mLevel-1]; }}
function int							GetNextLevelXp()								{ return mXpProgress.GetXPDelta(mLevel); }
function int							GetLevelXPRange( int level )					{ return mXpProgress.GetXPDelta(level); }
function bool                           GetIsOverrideHeroClass()                        { return mOverrideHeroClassSkills; }
function                                SetOverrideHeroClass( bool val )                { mOverrideHeroClassSkills = val; }
function								SetScriptedBehaviour( EScriptedBehaviour value) { mScriptedBehaviour = value; }
function bool							GetIsScripted()									{ return mScriptedBehaviour != ESB_None; }
// selected redirect wrapper functions for easy base stat access
function int							GetAttackBase()									{ return GetBaseStatByID( STAT_ATTACK );}
function int							GetDefenseBase()								{ return GetBaseStatByID( STAT_DEFENSE );}
function int							GetMagicBase()									{ return GetBaseStatByID( STAT_MAGIC );}
function int							GetSpiritBase()									{ return GetBaseStatByID( STAT_SPIRIT );}
function int							GetManaRegenBase()								{ return GetBaseStatByID( STAT_MANA_REGEN ); }
function int							GetMinimumDamageBase()							{ return GetBaseStatByID( STAT_MIN_DAMAGE ) + mXpProgress.GetMinimumDamageAdd(mLevel); }
function int							GetMaximumDamageBase()							{ return GetBaseStatByID( STAT_MAX_DAMAGE ) + mXpProgress.GetMaximumDamageAdd(mLevel); }
function int                            GetArcaneKnowledgeBaseAsInt()	                { return GetBaseStatByID( STAT_ARCANE_KNOWLEDGE ); }
function int							GetMaxManaBase()								{ return GetBaseStatByID( STAT_MANA ); }
function int                            GetMaxManaBonus()                               { return mMaxManaBonus; }
// -
function int							GetMagic()										{ return GetModifiedStatByID( STAT_MAGIC ); }
function int							GetSpirit()										{ return GetModifiedStatByID( STAT_SPIRIT ); }
function int                            GetArcaneKnowledgeAsInt()	                    { return GetModifiedStatByID( STAT_ARCANE_KNOWLEDGE ); }
function float                          GetDiplomacyMod()	                            { return GetModifiedStatByID( STAT_DIPLOMACY_MOD ); }
function int                            GetBattleRage()                                 { return GetModifiedStatByID( STAT_BATTLERAGE); }
function int                            GetMetamagic()                                  { return GetModifiedStatByID( STAT_METAMAGIC); }
function int                            GetMaxDeploymentRow()                           { return GetModifiedStatByID( STAT_MAX_DEPLOY_ROW); }
function int                            GetMaxDeploymentNumber()                        { return GetModifiedStatByID( STAT_MAX_DEPLOY_NUM); }
function int							GetMinimumDamagePerLevel()						{ return GetModifiedStatByID( STAT_HERO_MIN_DAMAGE_PER_LEVEL ) * GetLevel(); }
function int							GetMaximumDamagePerLevel()						{ return GetModifiedStatByID( STAT_HERO_MAX_DAMAGE_PER_LEVEL ) * GetLevel(); }
function float							GetMinimumDamage()						        { return super.GetMinimumDamage() + GetMinimumDamagePerLevel() + mXpProgress.GetMinimumDamageAdd(mLevel); }
function float							GetMaximumDamage()							    { return super.GetMaximumDamage() + GetMaximumDamagePerLevel() + mXpProgress.GetMaximumDamageAdd(mLevel); }
function int							GetCurrentMana()								{ return mCurrentMana; }
function int							GetMaxMana()									{ return GetModifiedStatByID( STAT_MANA ); }
function int							GetManaRegen()									{ return GetModifiedStatByID( STAT_MANA_REGEN ); }
function int							GetLevel()    							        { return mLevel; }
function int							GetExperiencePoints()							{ return mXp; }
function int                            GetLvl30XPNeeded()                              { return mXpProgress.mXpTable[29] - mXpProgress.mXpTable[28]; }
function H7HeroClass					GetHeroClass()									{ return mClass; }
function H7EditorWarUnit                GetSiegeWarUnitTemplate()                       { return mWarfareSiege; }
function H7HeroAbility                  GetSpecialization()                             { return mStartingAbility; }
function array<H7ClassSkillData>        GetSkillsArchetype()							{ return mClass.GetSkills(); }
function int							GetSkillPoints()								{ return mSkillPoints; }
function array<CreatureStackProperties> GetHoHDefaultArmy()								{ return mHoHDefaultArmy; }
function H7SkillManager					GetSkillManager()								{ return mSkillManager; }
function EHeroAiControlType             GetAiControlType()                              { return mAiControlType; }
function EHeroAiAggressiveness          GetAiAggressivness()                            { return mAiAggressiveness; }
function bool                           GetAiHibernationState()                         { return mAiInHibernation; }
function H7VisitableSite                GetAiHomeSite()                                 { return mAiHomeSite; }
function float                          GetAiHomeRadius()                               { return mAiHomeRadius; }
function bool                           GetAiOnPatrol()                                 { return mAiOnPatrol; }
function H7AiPatrolController           GetAiPatrolController()                         { return mAiPatrolController; }
function H7VisitableSite                GetAiObjectiveSite()                            { return mAiObjectiveSite; }
function H7AdventureArmy                GetAiObjectiveArmy()                            { return mAiObjectiveArmy; }
function EHeroAiRole                    GetAiRole()                                     { return mAiRole; }
function int                            GetAiRolePriority()                             { return mAiRolePriority; }
function EHeroAiRole                    GetAiPreferedRole()                             { return mAiPreferedRole; }
function H7HeroFX                       GetHeroFX()                                     { return mFX; }
function bool                           GetSaveProgress()                               { return mSaveHeroProgress; }
function String                         GetFactionBGHeroWindow()                        { return "img://" $ Pathname( mFactionBGHeroWindow );}
function String                         GetFactionSpecializationFrame()                 { return "img://" $ Pathname( mFactionSpecializationFrame );}
function H7EditorHero                   GetOriginArchetype()                            { return mOriginArchetype; }
function H7EditorHero                   GetCampaignTransitionHeroArchetype()            { return mCampaignTransitionHeroArchetype; }
function int                            GetArcangeKnowlageBase()                        { return mArcaneKnowledgeBase; }
// Returns the parent archetype if this hero is a sub-archetype created by the Hero Army Property Window
function H7EditorHero GetSourceArchetype()
{
	return (mCampaignTransitionHeroArchetype == none) ? mOriginArchetype : mCampaignTransitionHeroArchetype;
}

function array<H7HeroBioData>           GetHeroBioData()                                { return mHeroBioData; }
function H7EditorHero                   GetHeropediaOverwrite()                         { return mHeropediaOverwrite; }

function								SetInitiative(int initiative )					{ mInitiative = initiative;  }
function								SetMagic( int magic )							{ mMagic = magic; }
function                                SetMaxManaBonus (int maxManaBonus )             { mMaxManaBonus = maxManaBonus; }
function								SetSpirit( int spirit )							{ mSpirit = spirit; }
function								SetAttack( int attack )							{ mAttack = attack; }
function                                SetBattleRage( int battlerage )                 { mBattleRage = battlerage; }
function								SetMinimumDamage( int minimumDamage )			{ mMinimumDamage = minimumDamage; }
function								SetMaximumDamage( int maximumDamage )			{ mMaximumDamage = maximumDamage; }
function								SetDefense( int defense )						{ mDefense = defense; }
function								SetTransientName( string localizedHeroName )	{ mTransientName = localizedHeroName; }
function								SetLeadership( int leadership )					{ mLeadership = leadership; }
function								SetDestiny( int destiny )						{ mDestiny = destiny; }
function								SetXp( int xp )									{ mXp = xp; }
function								SetImage( Texture2D image )						{ mImage = image; }
function                                SetImageXOffset(int val)                        { mImageXOffset = val; }
function                                SetImageYOffset(int val)                        { mImageYOffset = val; }
//function								SetMinimapIcon( Texture2D icon )				{ mMinimapIcon = icon; }
function								SetCurrentMovementPoints( float value )			{ mCurrentMovementPoints = value; DataChanged(); }
function								SetMaxMovementPoints( int value )				{ mMovementPoints = value; DataChanged();}
function                                SetPlayer( H7Player value )						{ mOwningPlayer = value; UpdateOutline(); }
function								SetInventory( H7Inventory inventory)			{ mInventory = inventory; }
function								SetClass( H7HeroClass heroClass )				{ mClass = heroClass; }
function								SetFaction( H7Faction faction )					{ mFaction = faction; }
function								SetSkillPoints( int points )					{ mSkillPoints = points;DataChanged(); }
function								SetManaRegeneration( int regen )				{ mManaRegenBase = regen; }
function								SetAiControlType( EHeroAiControlType ct )		{ mAiControlType = ct; }
function								SetAiAggressivness( EHeroAiAggressiveness ag )	{ if( ag != mAiAggressiveness )  { mAiAggressiveness = ag; if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ; } }
function								SetAiHibernationState( bool state )				{ mAiInHibernation = state; }
function                                SetAiHomeSite( H7VisitableSite site )           { mAiHomeSite = site; }
function                                SetAiHomeRadius( float radius )                 { mAiHomeRadius = radius; }
function                                SetAiRole( EHeroAiRole nrole )                  { mAiRole = nrole; }
function                                SetAiRolePriority( int newPrio )                { mAiRolePriority = newPrio; }
function                                SetAiPreferedRole( EHeroAiRole nrole )          { mAiPreferedRole = nrole; }
function								SetLevel(int level)								{ mLevel = level; }
function                                SetSpecialization(H7HeroAbility ability)        { mStartingAbility = ability; }
function                                SetSiegeWarUnitTemplate(H7EditorWarUnit unit)   { mWarfareSiege = unit; }
function                                SetOriginArchetype(H7EditorHero hero)           { mOriginArchetype = hero; }
function                                SetFactionBGHeroWindow(Texture2D texture)       { mFactionBGHeroWindow = texture; }
function                                SetFactionSpecializationFrame(Texture2D texture){ mFactionSpecializationFrame = texture; }
function                                SetStartSkills( H7Skill startSkills[2] )        { mStartSkills[0] = startSkills[0]; mStartSkills[1] = startSkills[1]; }
function                                SetSaveProgress( bool shouldSave )              { mSaveHeroProgress = shouldSave; }
function                                SetHeropediaOverwrite(H7EditorHero hero)        { mHeropediaOverwrite = hero; }
function                                SetArcangeKnowledgeBase(int newValue)            { mArcaneKnowledgeBase = newValue; }

function SetCampaignTransitionHeroArchetype(H7EditorHero hero) { mCampaignTransitionHeroArchetype = hero; }

function bool                           IsMightHero()                                   { return GetSchool()==MIGHT; }
function bool                           IsMagicHero()                                   { return GetSchool()!=MIGHT; }

event                                   SetIcon(Texture2D newIcon)                      { mOverwriteIcon = newIcon; DataChanged(); }

function Texture2d GetIcon()
{
	if(mOverwriteIcon != none)
	{
		return mOverwriteIcon;
	}
	else if(!class'H7GameUtility'.static.IsArchetype(self) && InStr(string(ObjectArchetype),"Default__") != INDEX_NONE && mOriginArchetype != none)
	{
		// instance was wrongly constructed, not based on archetype, have to use the manual archetype link
		return mOriginArchetype.GetIcon();
	}
	else
	{
		return super.GetIcon();
	}
	return mIcon;
}

function String	GetFlashImagePath()	
{ 
	local string path;
	
	if( mImage == none ) 
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mImage');
		}
		else
		{
			if( GetOriginArchetype() != none )
			{
				return GetOriginArchetype().GetFlashImagePath();
			}
		}
	}
	
	path = "img://" $ Pathname( mImage );
	
	return path;
}

function DeleteImage()
{
	if(!class'Engine'.static.IsEditor())
	{
		mImage = none;
	}
}

// Used for saving hero struct! Don't change 
function GetDamageRangeBase(out int minDamage, out int maxDamage)
{
	minDamage = GetBaseStatByID( STAT_MIN_DAMAGE );
	maxDamage = GetBaseStatByID( STAT_MAX_DAMAGE );
}

function H7HeroVisuals GetVisuals()
{
	if( mVisuals == none ) 
	{
		if( class'H7GameUtility'.static.IsArchetype( self ) )
		{
			self.DynLoadObjectProperty('mVisuals');
		}
		else
		{
			if( GetOriginArchetype() != none )
			{
				mVisuals = GetOriginArchetype().GetVisuals();
			}
		}
	}
	return mVisuals;	
}

function UpdateOutline()
{
	if( GetPlayer() == None ) // not sure why this ever could be the case, but it happend that CombatHero(es) are present in the adventure map
	{
		return;
	}
	if( mHeroSkeletalMesh != none )
	{
		mHeroSkeletalMesh.SetOutlineColor( GetPlayer().GetColor() );
	}
	if( mHorseSkeletalMesh != none )
	{
		mHorseSkeletalMesh.SetOutlineColor( GetPlayer().GetColor() );
	}
	if( mArmy != none )
	{
		if( mArmy.SkeletalMeshComponent != none )
		{
			mArmy.SkeletalMeshComponent.SetOutlineColor( GetPlayer().GetColor() );
		}
		if( mArmy.mHorseMesh != none )
		{
			mArmy.mHorseMesh.SetOutlineColor( GetPlayer().GetColor() );
		}
	}
}

function Texture2D GetFactionAuraInnerDecalTexture()               
{ 
	if( GetFaction() != none )
	{
		return GetFaction().GetDecalInnerTexture(); 
	}
	else
	{
		return none;
	}
}

function Texture2D GetFactionAuraOuterDecalTexture()               
{ 
	if( GetFaction() != none )
	{
		return GetFaction().GetDecalOuterTexture(); 
	}
	else
	{
		return none;
	}
}

function Color GetColor()
{
	local array<H7Player> players;
	local H7Player player;
	local array<H7AdventureArmy> armies;
	local H7AdventureArmy army;
	if(mArmy != none) return mArmy.GetPlayer().GetColor();
	else 
	{
		// assume I am an archetype
		// look if a hero of me is on the map
		if(class'H7AdventureController'.static.GetInstance() != none)
		{
			players = class'H7AdventureController'.static.GetInstance().GetPlayers();
			foreach players(player)
			{
				armies = class'H7AdventureController'.static.GetInstance().GetPlayerArmies(player,true);
				foreach armies(army)
				{
					if(army.GetHero().GetOriginArchetype() == self)
					{
						return army.GetPlayer().GetColor();
					}
				}
			}
		}
		// no player color -> try fallback color
		if((mColor.R != 0 || mColor.G != 0 || mColor.B != 0) && (mColor.R != 255 || mColor.G != 255 || mColor.B != 255)) // black and white don't count
		{
			return mColor;
		}
		// no fallback color -> try faction color
		if(mFaction != none)
		{
			return mFaction.GetColor();
		}
		// no faction color -> default color: neutral color (copy&paste from H7Player.GetColor())
		mColor.R = 228;
		mColor.G = 228;
		mColor.B = 228;
		mColor.A = 255;
		return mColor;
	}
}

function SetVisuals( H7HeroVisuals visuals )
{
	mVisuals = visuals;
}

function array<H7BaseAbility>			GetAbilities()	                                
{
	local array<H7BaseAbility> abilities; 
	mAbilityManager.GetAbilities(abilities); 
	return abilities; 
}

function ClearScriptedBehaviour()
{
	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
	{
		GetAdventureArmy().ClearLatentAction(class'SeqAct_AIMoveToActor');
	}
	mScriptedBehaviour = ESB_None;
}

/***
 * * 
 * be careful this are just templates/archetypes   
 */
function GetPreLearnedHeroSkills(out array<H7HeroSkill> PreLearnedSkills)                  
{
	local int i;

	for ( i=0; i < ArrayCount( mPreLearnedSkills ); ++i )
		if( mPreLearnedSkills[i].LearnedAbilities.Length > 0 || mPreLearnedSkills[i].Skill != none )
			PreLearnedSkills.AddItem( mPreLearnedSkills[i] );
	
} 

native function float GetManaCostForSpell( H7HeroAbility spell );

native function float GetMoveCostForTerrainType( H7AdventureLayerCellProperty terrainArchetype, ECellMovementType movementType );

function float GetCurrentMovementPoints()
{
	return mCurrentMovementPoints;
}

native function Vector GetSocketLocation( name socketName );

function                                SetHoHDefaultArmy( array<CreatureStackProperties> defaultArmy ) { mHoHDefaultArmy = defaultArmy; }
/**
 * Overrides the ability manager for the current hero based on abilities
 * owned by the ability manager parameter.
 * We need to set the references of the ability to ourselves to
 * ensure consistency between abilities having right owners in
 * adventuremap/combatmap
 * */
function OverrideAbilityManager( H7AbilityManager manager )              
{ 
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;

	mAbilityManager = manager;
	mAbilityManager.SetOwner( self );
	mAbilityManager.GetAbilities(abilities);

	// necessary to revive the caster reference when bouncing back-and-forth from combat<->adventure and vice versa
	foreach abilities( ability )
	{
		ability.OverrideCaster( self );
	}

	// once caster reference is definitely restored, we can set the caster and thus create a caster snapshot
	foreach abilities( ability )
	{
		ability.SetCaster( self );
		ability.SetOwner( none );
	}
}  

event OverrideBuffManager( H7BuffManager manager, H7EditorHero hero )
{
	local array<H7BaseBuff> buffs;
	local int i;

	mBuffManager = manager;
	mBuffManager.SetOwner( self );
	buffs = mBuffManager.GetBuffs();

	for( i = 0; i < buffs.Length; ++i )
	{
		if( buffs[i].GetCasterOriginal() == hero )
		{
			buffs[i].SetCaster( self );
		}
		// owner is always the hero dude, regardless who/what casted the buff
		buffs[i].SetOwner( self );
	}
}

function OverrideSkillManager( H7SkillManager manager ) 
{ 
	local array<H7Skill> skills;
	local H7Skill skill;

	mSkillManager = manager;
	mSkillManager.SetOwner( self );
	skills = mSkillManager.GetAllSkills();

	foreach skills( skill )
	{
		skill.SetCaster( none );
		skill.SetOwner( self );
	}
}    // used to convert AdvHero->CombatHero


/** basicly override function for QA to setup spells that are known at start */
function  SetStartingSpellArchetypes( array<H7HeroAbility> abilities )    { mStartingSpellArchetypes = abilities; }
/** basicly override function for QA to setup skills that are known at start (this will override Class Skills)*/
function  SetPreLearnedSkills( H7HeroSkill preSkills[10] )
{
	local int i;

	for(i=0;i<ArrayCount(mPreLearnedSkills); ++i )
	{
		if( preSkills[i].LearnedAbilities.Length > 0 || preSkills[i].Skill != none )
			mPreLearnedSkills[i] = preSkills[i];
	}
}

// methods ...
// ===========
function Init( optional bool fromSave ) // !!! EditorHero is not inited, the AdvenutreHero who copies data from EditorHero is inited
{
	local array<H7HeroItem> items;
	local H7HeroItem item;
	local int devnull;

	super.Init( fromSave );

	SetPlayer( mArmy.GetPlayer() ); 

	;

	// simulate the x level ups:
	// set xp according to start level
	mXpProgress.GetXPRange(mLevel,mXp,devnull);

	// set skillpoints according to start level
	mSkillPoints = 0; //24.02.15 new design  = mLevel-1; // Level 1 = Skillpoints 0
	// stats:
	// no

	// init Skillmanager
	mSkillManager = new class 'H7SkillManager';
	mSkillManager.Init(self);

	if(mEquipment != none)
	{
		mEquipment = new class'H7HeroEquipment'(mEquipment);
	}
	else
	{
		mEquipment = new class'H7HeroEquipment';
		
	}
	
	
	if ( mEquipment != None )
	{
		mEquipment.Init(fromSave);
		mEquipment.SetEquipmentOwner( self );
	
		mEquipment.GetItemsAsArray(items);
		foreach items( item )
		{
			LearnItemAbilities(item);
		}
	}

	InitSkillsAndAbilities(fromSave);

	if( mInventory != none )
	{
		mInventory = new class'H7Inventory'(mInventory);
	}
	else
	{
		mInventory = new class'H7Inventory';
	}

	if(!fromSave) // For saves invetory is initialized in AdventureHero->RestoreState
	{
		mInventory.Init( self );
	}

	
	
	

	mHeroEventParam = new class'H7HeroEventParam';

	// cap mana
	if(GetCurrentMana() > GetMaxMana())
	{
		SetCurrentMana(GetMaxMana());
	}

	SetMovementAudioType();

	class'H7ReplicationInfo'.static.PrintLogMessage("Hero created" @ GetName() @ self, 0);;
	;
}

function SetEquipment( H7HeroEquipment equip )  
{ 
	mEquipment = equip; // could be archetype, will be instanciated in Init()
}

function float GetBaseStatByID(Estat desiredStat)
{
	switch(desiredStat)
	{
		case STAT_CURRENT_MOVEMENT:
			return mCurrentMovementPoints;
		case STAT_BATTLERAGE:
			return mBattleRage;
		case STAT_METAMAGIC:
			return mMetamagic;
		case STAT_NECROMANCY:
			return 0;
		case STAT_HERO_MIN_DAMAGE_PER_LEVEL:
			return mMinDamagePerLevel;
		case STAT_HERO_MAX_DAMAGE_PER_LEVEL:
			return mMaxDamagePerLevel;
		case STAT_NEUTRAL_CREATURE_COST:
			return 1.0f;
		case STAT_ARCANE_KNOWLEDGE:
			return mArcaneKnowledgeBase;
		default:
			return super.GetBaseStatByID(desiredStat);
	}
}

function float IncreaseBaseStatByID( Estat desiredStat, optional int amount = 1 )
{
	local float actualchangedAmount;
	actualchangedAmount = amount; // unless overwritten otherwise
	ClearStatCache();
	switch(desiredStat)
	{
		case STAT_CURRENT_MANA:
			actualchangedAmount = AddMana( amount );
			break;
		case STAT_MANA:
			AddMaxManaBonus( amount );
			break;
		case STAT_MAGIC:
			mMagic += amount;
			break;
		case STAT_SPIRIT:
			mSpirit += amount;
			break;
		case STAT_CURRENT_MOVEMENT:
			actualchangedAmount = FMin(amount, GetModifiedStatByID(STAT_MAX_MOVEMENT) - mCurrentMovementPoints);
			mCurrentMovementPoints += actualchangedAmount;
			mCurrentMovementPoints = FMax(mCurrentMovementPoints, 0);
			break;
		case STAT_MAX_MOVEMENT:
			super.IncreaseBaseStatByID(desiredStat, amount);
			break;
		case STAT_CURRENT_XP:
			actualchangedAmount = AddXp( amount );
			break;
		case STAT_BATTLERAGE:
			mBattleRage += amount;
			return amount;
			break;
		case STAT_METAMAGIC:
			mMetamagic += amount;
			return amount;
			break;
		case STAT_HERO_MIN_DAMAGE_PER_LEVEL:
			mMinDamagePerLevel += amount;
			break;
		case STAT_HERO_MAX_DAMAGE_PER_LEVEL:
			mMaxDamagePerLevel += amount;
			break;
		case STAT_ARCANE_KNOWLEDGE:
			mArcaneKnowledgeBase += amount;
			break;
		default:
			actualchangedAmount = super.IncreaseBaseStatByID(desiredStat, amount);
	}
	return actualchangedAmount;
}

function DecreaseBaseStatByID( Estat desiredStat, optional int amount = 1 )
{
	switch(desiredStat)
	{
		case STAT_MAGIC:
			mMagic = FClamp(mMagic - amount, 0, MaxInt);
			break;
		case STAT_SPIRIT:
			mSpirit = FClamp(mSpirit - amount, 0, MaxInt);
			break;
		case STAT_BATTLERAGE:
			mBattleRage = FClamp( mBattleRage - amount, 0, MaxInt );
			break;
		case STAT_METAMAGIC:
			mMetamagic = FClamp( mMetamagic - amount, 0, MaxInt );
			break;
		case STAT_HERO_MIN_DAMAGE_PER_LEVEL:
			mMinDamagePerLevel = FClamp( mMinDamagePerLevel - amount, 0, MaxInt );
			break;
		case STAT_HERO_MAX_DAMAGE_PER_LEVEL:
			mMaxDamagePerLevel = FClamp( mMaxDamagePerLevel - amount, 0 , MaxInt );
			break;
		case STAT_ARCANE_KNOWLEDGE:
			mArcaneKnowledgeBase -= amount;
			break;
		default:
			super.DecreaseBaseStatByID(desiredStat, amount);
	}
}

function SetBaseStatByID( Estat desiredStat, int newValue )
{
	ClearStatCache();
	switch(desiredStat)
	{
		case STAT_MAGIC:
			mMagic = newValue;
			break;
		case STAT_SPIRIT:
			mSpirit = newValue;
			break;
		case STAT_BATTLERAGE:
			mBattleRage = newValue;
			break;
		case STAT_METAMAGIC:
			mMetamagic = newValue;
			break;
		case STAT_HERO_MIN_DAMAGE_PER_LEVEL:
			mMinDamagePerLevel = newValue;
			break;
		case STAT_HERO_MAX_DAMAGE_PER_LEVEL:
			mMaxDamagePerLevel = newValue;
			break;
		case STAT_ARCANE_KNOWLEDGE:
			mArcaneKnowledgeBase = newValue;
			break;
		default:
			super.SetBaseStatByID(desiredStat, newValue);
	}
}

function SetCurrentMana( int value ) 
{ 
	mCurrentMana = value; 
	DataChanged(); 
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateHeroManaOf( H7CombatHero(self) );
	}
}

function RegenMana() 
{
	local int maxMana, regenValue;

	if( !IsHero() ) { return; }

	maxMana = GetMaxMana();
	regenValue = GetManaRegen() * GetSpirit();

	if( mCurrentMana + regenValue <= maxMana )
	{
		mCurrentMana += regenValue;
	}
	else
	{
		mCurrentMana = maxMana;
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateHeroManaOf( H7CombatHero(self) );
	}
	DataChanged();
}

function float AddMana( int amount )
{
	local float actualChangedAmount;
	if( mCurrentMana + amount <= GetMaxMana() )
	{
		mCurrentMana += amount;
		actualChangedAmount = amount;
	}
	else
	{
		actualChangedAmount = GetMaxMana() - mCurrentMana;
		mCurrentMana = GetMaxMana();
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateHeroManaOf( H7CombatHero(self) );
	}
	DataChanged();
	return actualChangedAmount;
}

function AddMaxManaBonus(int amount )
{
	SetMaxManaBonus( mMaxManaBonus + amount );
}

function InitSkillsAndAbilities(bool fromSave)
{
	local H7Skill startSkill;
	local int i;
	local array<H7HeroAbility> forbiddenSpells, allowedStartingSpells;
	local H7HeroAbility spell;

	// TODO check this (maybe some unwanted spells get in the array while dueling?
	if( class'H7AdventureController'.static.GetInstance() != none )
	{
		// init spells, considering disallowed spells in map info
		forbiddenSpells = class'H7AdventureController'.static.GetInstance().GetMapInfo().mForbiddenSpells;
		foreach mStartingSpellArchetypes (spell)
		{
			if (forbiddenSpells.Find(spell) == INDEX_NONE)
			{
				allowedStartingSpells.AddItem(spell);
			}
		}
	}
	else
	{
		// for duels and such
		foreach mStartingSpellArchetypes( spell )
		{
			allowedStartingSpells.AddItem(spell);
		}
	}
	mAbilityManager.Init( self, allowedStartingSpells);

	// init skills defined by hero class
	;
	if( mRangedAttackAbilityTemplate != none )
	{
		mAbilityManager.LearnAbility( mRangedAttackAbilityTemplate );
	}
	if( mMeleeAttackAbilityTemplate != none )
	{
		mAbilityManager.LearnAbility( mMeleeAttackAbilityTemplate );
	}
	if( mWaitAbility != none )
	{
		mAbilityManager.LearnAbility( mWaitAbility );
	}
	if( GetLuckAbility() != none )
	{
		mAbilityManager.LearnAbility( GetLuckAbility() );
	}
	if( mClass != none )
	{
		;
		;
			mClass.Init(self) ;
	}
	else
	{
		;
	}

	if(!fromSave)
	{
		if( mStartingAbility != none )
		{
			mAbilityManager.LearnAbility( mStartingAbility );
		}
	}

		// Dont increase starting skills if comming from save
	if(!fromSave)
	{
		for(i=0;i<2;i++)
		{
			startSkill = mStartSkills[i];
			if( startSkill != none )
			{
				// init starting skill, costs no skillpoints
				if(GetSkillManager()!=None && GetSkillManager().GetSkillInstance(,startSkill)!=None )
				{
					GetSkillManager().IncreaseSkillRankComplete( GetSkillManager().GetSkillInstance(,startSkill).GetID(), false, true );
				}
			}
		}
	}
	
}

native function TriggerEvents(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container);
native function GetProductionEffects(out array<H7EffectSpecialAddResources> produc);

native function GetModifiersByID( out array<H7MeModifiesStat> outStats, Estat desiredStat, optional EOperationType exclusiveFirstOT = -1, optional EOperationType exclusiveSecondOT = -1, optional bool nextRound );
native function GetBoniFromItemSet(Estat desiredStat, array<H7HeroItem> container,  out array<H7MeModifiesStat> statMods, EOperationType checkForOperation1 , EOperationType checkForOperation2);
native function GetModifierByContainer(Estat desiredStat, array<H7EffectContainer> container,  out array<H7MeModifiesStat> statMods , EOperationType checkForOperation1 , EOperationType checkForOperation2);


function AddSkillPoint() { mSkillPoints++; DataChanged();}
function SpendSkillPoint() 
{ 
	mSkillPoints--; 
	if(mSkillPoints<0) 
	{
		mSkillPoints = 0; 
	}
	DataChanged(); 
}

function LearnItemAbilities(H7HeroItem currentItem, optional bool unlearnInstead = false) 
{
	local H7BaseAbility currentAbility;
	local array<H7BaseAbility> imprintedAbilities;

	imprintedAbilities = currentItem.GetImprintedAbilities();

	foreach imprintedAbilities( currentAbility ) 
	{
		if( unlearnInstead )
		{
			GetAbilityManager().UnlearnVolatileAbility( currentAbility );
		} 
		else 
		{
			GetAbilityManager().LearnVolatileAbility( currentAbility );
		}
	}
}

function SetMeshes( SkeletalMeshComponent horseSkelMesh, SkeletalMeshComponent heroSkelMesh, optional H7EditorArmy army, optional Vector riderOffset )
{
	if( mIsHero )
	{
		if( horseSkelMesh != none )
		{
			mHorseSkeletalMesh = new class'SkeletalMeshComponent'( horseSkelMesh );
			mHorseSkeletalMesh.SetActorCollision( true, true, true );
			mHorseSkeletalMesh.SetTraceBlocking( true, true );
			mHorseSkeletalMesh.SetLightEnvironment( LightEnvironment );
			AttachComponent( mHorseSkeletalMesh );

			if (mArmy != None && mArmy.UseLlamaMesh())
			{
				mHorseSkeletalMesh.SetSkeletalMesh(mArmy.mLlamaMesh);
				mHorseSkeletalMesh.AnimSets[0] = mArmy.mLlamaAnims;
			}
		}

		if( heroSkelMesh != none )
		{
			mHeroSkeletalMesh = new class'SkeletalMeshComponent'( heroSkelMesh );
			mHeroSkeletalMesh.SetActorCollision( true, true, true );
			mHeroSkeletalMesh.SetTraceBlocking( true, true );
			mHeroSkeletalMesh.SetLightEnvironment( LightEnvironment );
			AttachComponent( mHeroSkeletalMesh );
			SkeletalMeshComponent=mHeroSkeletalMesh;
		}
	}

	SpawnAnimControl();
}

function SpawnAnimControl()
{
	mAnimControl = Spawn( class'H7HeroAnimControl', self );
	mAnimControl.Init( self ); // needs to be initialized every time is done the setmeshes and not only when the animcontr
}

function ClearHeroMeshData()
{
	mHorseSkeletalMesh = none;
	mHeroSkeletalMesh = none;
	mVisuals = none;
}

// the function is called to end the last turn for this unit and start with the new
function bool BeginTurn()
{
	super.BeginTurn();
	
	mFX.ShowFX();

	return true;
}

function EndTurn()
{
	super.EndTurn();

	mFX.HideFX();
}

/** 
 *  Adds XP to the hero and returns the stat-modified value of the XP that was really added to the XP pool
 *  
 *  @param xp The amount of base XP to be added
 *  
 *  @return The amount of XP that was actually added
 *  */
function int AddXp( int xp )
{
	local int newLevel, oldLevel;
	local int xpToAdd;
	local int maxLevel, potentialNewLevel;

	// neutral heros dont get any xp :(
	if(GetPlayer() != none && GetPlayer().GetPlayerNumber() == PN_NEUTRAL_PLAYER || !mIsHero ) { return 0; }

	maxLevel = class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( GetPlayer().GetPlayerNumber() );
	if( mLevel >= maxLevel )
	{
		;

		return 0;
	}

	// AddBoni are used for accomulated multiplier boni, f. e. paragon 20% + Enlightened Leader 50% =  * 1.7, not * 1.2 * 1.5
	xpToAdd = xp * (1 + GetAddBoniOnStatByID(STAT_XP_RATE)) * GetMultiBoniOnStatByID(STAT_XP_RATE);
	;
	mXp += xpToAdd;

	potentialNewLevel = mXpProgress.GetLevel(mXp);
	newLevel = Min( potentialNewLevel, maxLevel );

	if( newLevel > mLevel && !self.IsA('H7CombatHero')) // levelup level up (combatheroes do not level up, they just add their xp to the adv hero after combat)
	{
		mXpProgress.LevelUpHeroStats( self, newLevel-mLevel );
		oldLevel = mLevel;
		mLevel = newLevel;
		if( mLevel >= maxLevel )
		{
			;
			mXp = mXpProgress.GetTotalXPByLvl(maxLevel);
		}

		if(GetPlayer().IsControlledByAI() == false && H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHud())!=none )
		{
			// Its Me
			if( GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer() && GetPlayer() == class'H7AdventureController'.static.GetInstance().GetCurrentPlayer() )
			{
				InvokeLevelUp();
			}
			else // not me
			{
				SetPendingLevelUp( true );
			}
		}

		mHeroEventParam.mEventHeroTemplate = class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() ? GetAdventureArmy().GetHeroTemplateSource() : GetCombatArmy().GetHeroTemplateSource();
		mHeroEventParam.mEventPlayerNumber = GetPlayer().GetPlayerNumber();
		mHeroEventParam.mEventHeroLevel = mLevel;
		mHeroEventParam.mEventOldHeroLevel = oldLevel;
		class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_ReachLevel', mHeroEventParam, self);
	}

	TriggerEvents( ON_AFTER_XP_GAIN, false );

	return xpToAdd;
}

function InvokeLevelUp()
{
	local H7Message message;

	if(class'H7AdventureController'.static.GetInstance().GetRandomSkilling() )
	{
		if(GetSkillManager().GetRndSkillManager().IsReset())
			GetSkillManager().GetRndSkillManager().GenerateNewBatch();
				
		if( !GetAdventureArmy().IsDead() )
		{
			H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHud()).GetRandomSkillingPopUpCntl().Update(self);
		}
				
				
	}

	H7AdventureHud(class'H7PlayerController'.static.GetPlayerController().GetHud()).GetSkillwheelCntl().AddLeveldUpHero(self);
	DataChanged();
			
	if(mLevelUpSounds != none)
	{
		self.PlayAkEvent(mLevelUpSounds,true,,true);
	}
			
	message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mHeroLevelUp.CreateMessageBasedOnMe();
	message.mPlayerNumber = GetPlayer().GetPlayerNumber();
	message.AddRepl("%hero",GetName());
	message.AddRepl("%level",String(GetLevel()));
	message.settings.referenceObject = self;
	message.settings.referenceWindowCntl = class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetSkillwheelCntl(); 
	message.creationContext = MCC_ADV_MAP;
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);
}


function InitFX()
{
	local MaterialInstanceConstant MatInst;
	local Texture OpacityTexture;
	local bool bFoundTexture;
	local MaterialInterface parentMat;

	// slot FX
	mFX = Spawn(class'H7HeroFX', self );
	if( H7AdventureHero( self ) != none || IsHero() )
	{
		mFX.InitFX(self);
	}
	
	if( mHorseSkeletalMesh != none )
	{
		MatInst = new(self) Class'MaterialInstanceConstant';
		MatInst.SetParent(Material'H7FXMatAura.matWhiteAura');
		MatInst.SetScalarParameterValue('WorldScale', mHorseSkeletalMesh.Scale3D.X * mHorseSkeletalMesh.Scale);
		MatInst.SetScalarParameterValue('AuraThickness', 4.5f);
		parentMat = mHorseSkeletalMesh.GetMaterial(0);
		if (parentMat != None)
		{
			bFoundTexture = mHorseSkeletalMesh.GetMaterial(0).GetTextureParameterValue('DiffMap', OpacityTexture);
		}
		if (bFoundTexture)
		{
			MatInst.SetTextureParameterValue('DiffMap_Opacity', OpacityTexture);
		}
	}
	
	if( mHeroSkeletalMesh != none )
	{
		MatInst = new(self) Class'MaterialInstanceConstant';
		MatInst.SetParent(Material'H7FXMatAura.matWhiteAura');
		MatInst.SetScalarParameterValue('WorldScale', mHeroSkeletalMesh.Scale3D.X * mHeroSkeletalMesh.Scale);
		MatInst.SetScalarParameterValue('AuraThickness', 4.5f);
		parentMat = mHorseSkeletalMesh.GetMaterial(0);
		if (parentMat != None)
		{
			bFoundTexture = mHeroSkeletalMesh.GetMaterial(0).GetTextureParameterValue('DiffMap', OpacityTexture);
		}
		if (bFoundTexture)
		{
			MatInst.SetTextureParameterValue('DiffMap_Opacity', OpacityTexture);
		}
	}
}

simulated event Destroyed()
{
	if( mFX != none ) 
	{
		mFX.Destroy();
	}
	if( mAnimControl != none )
	{
		mAnimControl.Destroy();
	}

	super.Destroyed();
}

native function ESkillRank GetArcaneKnowledge();

function UseMana( int value )
{
	if(class'H7GUIGeneralProperties'.static.GetInstance().GetUnlimitedMana()) return;

	mCurrentMana -= value;
	if( mCurrentMana < 0 ) mCurrentMana = 0;
	if( mCurrentMana > GetMaxMana() ) mCurrentMana = GetMaxMana();
	
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateHeroManaOf( H7CombatHero(self) );
	}
	
	DataChanged();
}

function bool UseMovementPoints( float value )
{
	if(mScriptedBehaviour == ESB_Scripted)
	{
		return true;
	}

	if(class'H7GUIGeneralProperties'.static.GetInstance().GetUnlimitedMovement() && !IsControlledByAI()) return true;

	if(value > mCurrentMovementPoints)
	{
		;
		mCurrentMovementPoints=0.0f;
		return false;
	}
	;
	mCurrentMovementPoints -= value;
	;
	if( mCurrentMovementPoints > GetMovementPoints() ) mCurrentMovementPoints = GetMovementPoints();

	DataChanged();

	return true;
}

function GetSpells( out array<H7HeroAbility> spells )
{
	local H7BaseAbility ability;
	local H7HeroAbility heroAbility;
	local array<H7BaseAbility> abilities;

	GetAbilityManager().GetAbilities(abilities);

	foreach abilities( ability ) 
	{
		if( !ability.IsA('H7HeroAbility') ) continue;

		heroAbility = H7HeroAbility(ability);
		
		if( heroAbility.IsSpell() ) 
		{
			spells.AddItem( heroAbility );
		}
	}
}

function vector GetMeshCenter()
{
	if(GetAdventureArmy() != none)
	{
		// use adventure army's skeletal mesh component's position because origins just return 0,0,0
		return GetAdventureArmy().SkeletalMeshComponent.GetPosition();
	}
	else
	{
		// use origin on combat map because it actually works
		return mHeroSkeletalMesh.Bounds.Origin;
	}
}

function vector GetHeightPos( float offset )
{
	if( mHeroSkeletalMesh == none || mHeroSkeletalMesh.SkeletalMesh == None )
	{
		if (GetAdventureArmy() != None && GetAdventureArmy().SkeletalMeshComponent != None)
		{
			return GetAdventureArmy().SkeletalMeshComponent.SkeletalMesh.Bounds.Origin + Vect( 0.f, 0.f, 1.f ) * (GetAdventureArmy().SkeletalMeshComponent.SkeletalMesh.Bounds.BoxExtent.Z + offset) * GetAdventureArmy().SkeletalMeshComponent.Scale3D.Z * GetAdventureArmy().SkeletalMeshComponent.Scale;
		}
		else
		{
			return Vect( 0.f, 0.f, 0.f );
		}
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		return mHeroSkeletalMesh.Bounds.Origin + Vect( 0.f, 0.f, 1.f ) * (mHeroSkeletalMesh.Bounds.BoxExtent.Z + offset);
	}
	else
	{
		return mHeroSkeletalMesh.SkeletalMesh.Bounds.Origin + Vect( 0.f, 0.f, 1.f ) * (mHeroSkeletalMesh.SkeletalMesh.Bounds.BoxExtent.Z + offset);
	}
}

function vector GetRelativeHeightPos( float offset )
{
	if( mHeroSkeletalMesh == none || mHeroSkeletalMesh.SkeletalMesh == None )
	{
		if( GetAdventureArmy() != None && GetAdventureArmy().SkeletalMeshComponent != None && GetAdventureArmy().mHorseMesh.SkeletalMesh != none )
		{
			return Vect( 0.f, 0.f, 1.f ) * (GetAdventureArmy().mHorseMesh.SkeletalMesh.Bounds.BoxExtent.Z + offset);
		}
		else if( GetAdventureArmy() != none && GetAdventureArmy().SkeletalMeshComponent != none )
		{
			return Vect( 0.f, 0.f, 1.f ) * (GetAdventureArmy().SkeletalMeshComponent.SkeletalMesh.Bounds.BoxExtent.Z + offset);
		}
		else
		{
			return Vect( 0.f, 0.f, 0.f );
		}
	}

	return Vect( 0.f, 0.f, 1.f ) * (mHeroSkeletalMesh.SkeletalMesh.Bounds.BoxExtent.Z + offset);
}

function AddBuffsToDataObject(out GfxObject data, H7GfxUIContainer objectFactory)
{
	local H7BaseBuff buff;
	local array<H7BaseBuff> buffs;
	local GFxObject adventureBuffsObj, combatBuffsObj, buffObj, modifiedStatsObj, modifyValuesObj;
	local int comBuffs, advBuffs;
	local array<EStat> modifiedStats;
	local array<float> modifyValues;
	local int i, k;

	GetBuffManager().GetActiveBuffs(buffs);

	adventureBuffsObj = objectFactory.GetNewArray();
	combatBuffsObj = objectFactory.GetNewArray();
	comBuffs = 0; advBuffs = 0;
	
	foreach buffs(buff)
	{
		if( buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() )
		{

			buffObj = objectFactory.GetNewObject();

			buffObj.SetBool( "BuffIsDisplayed", buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
			buffObj.SetBool( "BuffIsDebuff", buff.IsDebuff() );
			buffObj.SetString( "BuffName", buff.GetName() ); 
			buffObj.SetString( "BuffTooltip", buff.GetTooltip() );
			buffObj.SetString( "BuffIcon", buff.GetFlashIconPath() );
			buffObj.SetInt( "RemainingDuration", buff.GetCurrentDuration() );
			buffObj.SetInt( "Duration", buff.GetDuration());
		
			;

			buff.GetModifiedStatsAndValues(modifiedStats, modifyValues);
			modifiedStatsObj = objectFactory.GetNewArray();
			modifyValuesObj = objectFactory.GetNewArray();
			k = 0;

			for(i=0; i<modifiedStats.Length; i++)
			{
				modifiedStatsObj.SetElementString(k, String(GetEnum(Enum'EStat', modifiedStats[i])));
				modifyValuesObj.SetElementFloat(k, modifyValues[i]);
				k++;
			}
			
			buffObj.SetObject( "ModifiedStats", modifiedStatsObj );
			buffObj.SetObject( "ModifyValues", modifyValuesObj );


			if(buff.IsCombatBuff())
			{
				combatBuffsObj.SetElementObject(comBuffs, buffObj);
				comBuffs++;
			}
			else
			{   
				adventureBuffsObj.SetElementObject(advBuffs, buffObj);
				advBuffs++;
			}
		}
	}
	data.SetObject("AdventureBuffs", adventureBuffsObj);
	data.SetObject("CombatBuffs", combatBuffsObj);
}

function AddItemBoniToDataObject(out GfxObject data, H7GFxUIContainer objectFactory)
{
	local array<H7HeroItem> items;
	local H7heroItem item;
	local GfxObject modifiedStatsObj, modifyValuesObj, itemEffectObj, itemEffectsObj;
	local array<EStat> modifiedStats;
	local array<float> modifyValues;
	local int i, k, j;

	k = 0;
	GetEquipment().GetItemsAsArray(items);
	itemEffectsObj = objectFactory.GetNewArray();

	foreach items(item)
	{
		if(modifiedStats.Length > 0) modifiedStats.Remove(0, modifiedStats.Length);
		if(modifyValues.Length > 0) modifyValues.Remove(0, modifyValues.Length);
		item.GetModifiedStatsAndValues(modifiedStats, modifyValues);
		modifiedStatsObj = objectFactory.GetNewArray();
		modifyValuesObj = objectFactory.GetNewArray();
		j = 0;

		for(i=0; i<modifiedStats.Length; i++)
		{
			modifiedStatsObj.SetElementString(j, String(GetEnum(Enum'EStat', modifiedStats[i])));
			modifyValuesObj.SetElementFloat(j, modifyValues[i]);
			j++;
		}

		if(i > 0)
		{
			itemEffectObj = objectFactory.GetNewObject();
			itemEffectObj.SetString("BuffName", item.GetName());
			itemEffectObj.SetObject("ModifiedStats", modifiedStatsObj);
			itemEffectObj.SetObject("ModifyValues", modifyValuesObj);
			itemEffectsObj.SetElementObject(k, itemEffectObj);
			k++;
		}

	}
	data.SetObject("ItemEffects", itemEffectsObj);
}

function SetQuickBarSpells(array<H7HeroAbility> spells,bool combat)
{
	local int i;
	
	if(combat)
	{
		mQuickBarCombat = spells;
		// set me as owner
		for(i=0;i<6;i++)
		{
			if(i < mQuickBarCombat.Length && mQuickBarCombat[i] != none)
			{
				mQuickBarCombat[i].SetCaster(self);
			}
		}
	}
	else
	{
		mQuickBarAdventure = spells;
		// set me as owner
		for(i=0;i<6;i++)
		{
			if(i < mQuickBarAdventure.Length && mQuickBarAdventure[i] != none)
			{
				mQuickBarAdventure[i].SetCaster(self);
			}
		}
	}
}

function CheckQuickBar()
{
	local int i;
	return;
	;
	for(i=0;i<6;i++)
	{
		if(i < mQuickBarCombat.Length && mQuickBarCombat[i] != none)
			;
		else
			;
	}
}

function bool HasBuffFromAbility(H7HeroAbility ability)
{
	local array<H7BaseBuff> buffs;
	mBuffManager.GetBuffsFromSource( buffs, ability );
	return buffs.Length > 0;
}

function H7EditorHero CreateHero(optional H7EditorArmy army, optional name herotag,	optional vector heroLocation, optional bool isAdventureHero, optional bool onlyHero, optional bool fromSave, optional H7EditorHero oldHero ) 
{ 
	local H7EditorHero hero;
	
	if(oldHero == none)
	{
		hero = Spawn( isAdventureHero ? class'H7AdventureHero' : class'H7CombatHero', army, herotag, heroLocation );
	}
	else
	{
		hero = oldHero;
	}
	
	hero.SetIsHero( mIsHero );
	hero.SetArmy(army);
	
	if(class'H7GameUtility'.static.IsArchetype(self))
	{
		hero.SetOriginArchetype(self);
		hero.SetCampaignTransitionHeroArchetype(mCampaignTransitionHeroArchetype);
	}
	else
	{
		hero.SetOriginArchetype(none);
	}

	
		
	if( mIsHero )
	{
		if (army != None)
		{
			hero.SetDrawScale(army.DrawScale);
			hero.SetDrawScale3D(army.DrawScale3D);
		}
		hero.SetInitiative(mInitiative);

		hero.SetAttack( mAttack );
		hero.SetMinimumDamage( mMinimumDamage );
		hero.SetMaximumDamage( mMaximumDamage );
		hero.SetDefense( mDefense );
		hero.SetTransientName( GetName() );
		hero.SetStartingSpellArchetypes(mStartingSpellArchetypes);
		hero.SetLeadership( mLeadership );
		hero.SetDestiny( mDestiny );
		hero.SetLevel( mLevel );
		//hero.SetCurrentMana( mCurrentMana );
		hero.SetMaxManaBonus( mMaxManaBonus );
		hero.SetCurrentMovementPoints( mCurrentMovementPoints );
		hero.SetManaRegeneration( mManaRegenBase );
		hero.SetMaxMovementPoints( mMovementPoints );
		hero.SetCurrentMovementPoints( mMovementPoints );
		hero.SetImage( mImage );
		hero.SetImageXOffset(mImageXOffset);
		hero.SetImageXOffset(mImageYOffset);
		hero.SetFactionBGHeroWindow(mFactionBGHeroWindow);
		hero.SetFactionSpecializationFrame(mFactionSpecializationFrame);
		hero.SetStartSkills( mStartSkills );
		hero.SetSiegeWarUnitTemplate( mWarfareSiege );
		//hero.SetIcon( mIcon );
		//hero.SetMinimapIcon( GetVisuals().GetMinimapIcon());
		hero.SetClass( mClass );
		hero.SetFaction( mFaction );
		hero.SetSchoolType( mSchoolType );
		hero.SetMagic(mMagic);
		hero.SetSpirit(mSpirit);
		hero.SetMeleeAttackAbility( mMeleeAttackAbilityTemplate );
		hero.SetRangedAttackAbility( mRangedAttackAbilityTemplate );
		hero.SetWaitAbility( mWaitAbility );
		hero.SetPreLearnedSkills( mPreLearnedSkills ); //disabled to get actual class skills (for testing skillwheel)
		hero.SetAiControlType( mAiControlType );
		hero.SetAiAggressivness( mAiAggressiveness );
		hero.SetAiHibernationState( mAiInHibernation );
		hero.SetAiPreferedRole( mAiPreferedRole );
		hero.SetOverrideHeroClass( mOverrideHeroClassSkills );
		hero.SetSaveProgress ( mSaveHeroProgress );
		hero.SetPendingLevelUp( mIsPendingLevelUp );

		// fill Mana (after Spirit was set; else the dude won't have full mana)
		mCurrentMana = GetModifiedStatByID( STAT_MANA );
		hero.SetCurrentMana( mCurrentMana );

		if(mHeropediaOverwrite != none) hero.SetHeropediaOverwrite( mHeropediaOverwrite );
		if(mStartingAbility != none) hero.SetSpecialization(mStartingAbility);
	}
	else
	{
		if( army.GetStrongestCreature() != none ) 
		{ 
			hero.SetMeshes( army.GetStrongestCreature().GetVisuals().GetSkeletalMesh(), none, isAdventureHero ? army : None );
			hero.SetInitiative(mInitiative);
		
			hero.SetAttack( 0 );
			hero.SetMinimumDamage( 0 );
			hero.SetMaximumDamage( 0 );
			hero.SetDefense( 0 );
			hero.SetLeadership( 0 );
			hero.SetDestiny( 0 );
			hero.SetXp( 0 );
			hero.SetCurrentMana( 0 );
			hero.SetSpirit( 0 );
			hero.SetMagic( 0 );
			hero.SetIcon( army.GetStrongestCreature().GetIcon() );
			hero.SetFaction( army.GetStrongestCreature().GetFaction() );
		}
	}

	hero.SetInventory(mInventory);
	hero.SetEquipment(mEquipment);
	hero.SetHoHDefaultArmy(mHoHDefaultArmy);
	
	if (army != None)
	{
		hero.SetRotation(army.Rotation);
	}

	//army.SetCollision(false, false, true);
	army.SetLocation(hero.Location);
	army.SetHardAttach(true);
	army.SetBase(hero);
	
	hero.Init( fromSave );

	if(mIsHero) // need to be executed after managers init
	{
		//hero.GetHeroClass().Init( hero );
		//hero.OverrideSkillManager( mSkillManager );         // copy ref if coverting AdvHero -> CombatHero
		//hero.OverrideAbilityManager( mAbilityManager );     // copy ref if coverting AdvHero -> CombatHero
	} 

	return hero;
}

function int GetClampedCurrentMana()
{
	local int current, maximum;

	current = GetCurrentMana();
	maximum = GetMaxMana();

	return Clamp( current, 0, maximum );
}

/** Make sure the current mana is not higher than the actual maximum */
function ClampCurrentMana()
{
	local int clamped;

	clamped = GetClampedCurrentMana();
	if(clamped != GetCurrentMana())
	{
		SetCurrentMana( clamped );
	}
}

function string GetHPArchetypeID()
{
	local string archetypeID;

	if(mHeropediaOverwrite != none)
		archetypeID = mHeropediaOverwrite.GetArchetypeID();
	else if(class'H7GameUtility'.static.IsArchetype(self))
		archetypeID = String(self);
	else
		archetypeID = GetSourceArchetype().GetArchetypeID();

	return archetypeID;
}

function int GetCurrentXPForNextLevel()
{
	local int XPLow, devnull;
	mXpProgress.GetXPRange(mLevel, XPLow, devnull);
	return (Max(0, GetExperiencePoints() - XPLow));
}

// the future of GUI (demonstration)
function GUIWriteInto(GFxObject data,optional H7ListenFocus focus,optional H7GFxUIContainer flashFactory)
{
	// make sure correct values are displayed
	ClampCurrentMana();

	data.SetString("Name",GetName());
	data.SetString( "ManaIcon", class'H7StatIcons'.static.GetInstanceForText().GetStatIconPathHTML(STAT_CURRENT_MANA) );
	data.SetInt( "Mana", GetCurrentMana() );
	data.SetInt( "ManaMax", GetMaxMana() );

	data.SetString( "MovementIcon", class'H7StatIcons'.static.GetInstanceForText().GetStatIconPathHTML(STAT_CURRENT_MOVEMENT) );
	data.SetInt( "Movement", GetCurrentMovementPoints() );
	data.SetInt( "MovementMax", GetMovementPoints() );

	data.SetInt( "UnrealID", GetID() );
	data.SetString( "HeroIcon", GetFlashIconPath() );
	data.SetInt( "Level", GetLevel() );
	data.SetBool( "CanSkill", GetSkillPoints() > 0 );
	data.SetBool( "IsMight", IsMightHero() );
	data.SetBool( "IsGarrisoned", GetAdventureArmy().IsGarrisoned() );
	data.SetString("ArchetypeID", GetHPArchetypeID());

	data.SetBool("HeropediaAvailable", class'H7HeropediaCntl'.static.GetInstance().IsHeroDataAvailable( GetHPArchetypeID()));

	if(GetAdventureArmy() != none && GetAdventureArmy().IsGarrisoned())
	{
		data.SetString( "GarrisonIcon", GetAdventureArmy().GetGarrisonedSiteIconPath() );
		data.SetString( "GarrisonTooltip", Repl(class'H7Loca'.static.LocalizeSave("TT_HERO_GARRISONED","H7General"),"%site",GetAdventureArmy().GetGarrisonedSite().GetName()));
	}

	if(focus == LF_EVERYTHING || focus == LF_HERO_WINDOW)
	{
		// hero info
		data.SetString( "HeroName", GetName() );
		data.SetString( "FactionName", GetFaction().GetName());
		data.SetBool("AffinityMight", IsMightHero()); // can be removed, once all flash who used it are recompiled
		data.SetString( "Icon" , GetFlashIconPath() );
		data.SetString( "PlayerName", GetAdventureArmy().GetPlayer().GetName() );
		data.SetString( "FactionIcon", GetFaction().GetFactionColorIconPath());;

		if(GetHeroClass() == none)
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("hero" @ GetDebugName() @ "has no class",MD_QA_LOG);;
		}
		else 
		{
			data.SetString( "Class", GetHeroClass().GetName());
		}

		data.SetInt( "XP", GetCurrentXPForNextLevel() );
		data.SetInt( "MaxXP", GetNextLevelXp() ); // it is the xp delta from current to next level not the accumulated xp sum !
		
		data.SetInt("MaxLevel", class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( GetPlayer().GetPlayerNumber() ));
		if(GetLevel() >= class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( GetPlayer().GetPlayerNumber() ))
		{
			data.SetInt("XP", 1);
			data.SetInt("MaxXP", 1);
		}

		data.SetString( "SchoolName" , string( GetEnum( Enum'EAbilitySchool', mMeleeAttackAbilityTemplate.GetSchool() ) ) );

		// basic stats
		data.SetInt( "MinDamageOriginal", GetMinimumDamageBase() ); 
		data.SetInt( "MinDamage", GetMinimumDamage() );
		
		data.SetInt( "MaxDamageOriginal", GetMaximumDamageBase() );
		data.SetInt( "MaxDamage", GetMaximumDamage() );
		
		data.SetInt( "AttackOriginal", GetBaseStatByID(STAT_ATTACK) );
		data.SetInt( "Attack", GetAttack() );
		
		data.SetInt( "DefenseOriginal", GetBaseStatByID(STAT_DEFENSE) );
		data.SetInt( "Defense", GetDefense() );

		data.SetInt( "MagicOriginal", GetBaseStatByID(STAT_MAGIC));
		data.SetInt( "Magic", GetMagic());

		data.SetInt( "ManaOriginal", GetBaseStatByID(STAT_MANA));
		data.SetInt( "Mana", GetCurrentMana());

		data.SetInt( "ArcaneKnowledgeOriginal", GetBaseStatByID(STAT_ARCANE_KNOWLEDGE));
		data.SetInt( "ArcaneKnowledge", GetArcaneKnowledgeAsInt());

		data.SetInt( "SpiritOriginal", GetBaseStatByID(STAT_SPIRIT));
		data.SetInt( "Spirit", GetSpirit());
		
		data.SetInt( "DestinyOriginal", GetBaseStatByID(STAT_LUCK_DESTINY) );
		data.SetInt( "Destiny", GetDestiny() );

		data.SetInt( "LeadershipOriginal", GetBaseStatByID(STAT_MORALE_LEADERSHIP) );
		data.SetInt( "Leadership", GetLeadership() );

		data.SetInt( "MoveOriginal", GetBaseStatByID(STAT_MAX_MOVEMENT));
		data.SetInt( "Move", GetMovementPoints());
	}
}


event PlayHeroSound( EHeroTypeId tid, EHeroSoundId sid )
{
	local AkEvent sound;
	sound = None;

	if( tid == HEROTYPE_MIGHT )
	{
		switch( sid )
		{
			case HEROSOUND_MOUNTED_ATTACK: sound=mMountedAttackSound_Might; break;
			case HEROSOUND_MOUNTED_RANGEATTACK: sound=mMountedRangeAttackSound_Might; break;
			case HEROSOUND_MOUNTED_COMMAND: sound=mMountedCommandSound_Might; break;
			case HEROSOUND_MOUNTED_ABILITY: sound=mMountedAbilitySound_Might; break;
			case HEROSOUND_MOUNTED_VICTORY: sound=mMountedVictorySound_Might; break;
			case HEROSOUND_MOUNTED_DEFEAT: sound=mMountedDefeatSound_Might; break;
			case HEROSOUND_MOUNTED_TURNLEFT: sound=mMountedTurnLeftSounds; break;
			case HEROSOUND_MOUNTED_TURNRIGHT: sound=mMountedTurnRightSounds; break;
			case HEROSOUND_LEVEL_UP: sound=mLevelUpSounds; break;
			case HEROSOUND_COMBAT_SCREEN_START: sound=mCombatPopUpScreenStartSounds; break;
			case HEROSOUND_ENGAGE_COMBAT: sound=mEngageManuallySounds; break;
			case HEROSOUND_ENGAGE_QUICK_COMBAT: sound=mEngageQuickCombatSounds; break;
			case HEROSOUND_BOARDING_SHIP: sound=mBoardShipSounds; break;
			case HEROSOUND_SHIP_TURNING: sound=mShipTurningSounds; break;
			case HEROSOUND_MOUNTED_MOVE: sound=mStartMountedRandomMoveSounds; break;
			case HEROSOUND_MOUNTED_MOVE_END: sound=mEndMountedRandomMoveSounds; break;
			case HEROSOUND_MOVE_SHIP: sound=mStartShipRandomMoveSounds; break;
			case HEROSOUND_MOVE_SHIP_END: sound=mEndShipRandomMoveSounds; break;
			case HEROSOUND_SHIP_IDLE: sound=mStartShipIdleSounds; break;
			case HEROSOUND_SHIP_IDLE_END: sound=mEndShipIdleSounds; break;
			case HEROSOUND_MOUNTED_IDLE: sound=mStartMountedIdleSound_Might; break;
			case HEROSOUND_MOUNTED_IDLE_END: sound=mEndMountedIdleSound_Might; break;
		}
	}
	else
	{
		switch( sid )
		{
			case HEROSOUND_MOUNTED_ATTACK: sound=mMountedAttackSound_Magic; break;
			case HEROSOUND_MOUNTED_RANGEATTACK: sound=mMountedRangeAttackSound_Magic; break;
			case HEROSOUND_MOUNTED_COMMAND: sound=mMountedCommandSound_Magic; break;
			case HEROSOUND_MOUNTED_ABILITY: sound=mMountedAbilitySound_Magic; break;
			case HEROSOUND_MOUNTED_VICTORY: sound=mMountedVictorySound_Magic; break;
			case HEROSOUND_MOUNTED_DEFEAT: sound=mMountedDefeatSound_Magic; break;
			case HEROSOUND_MOUNTED_TURNLEFT: sound=mMountedTurnLeftSounds; break;
			case HEROSOUND_MOUNTED_TURNRIGHT: sound=mMountedTurnRightSounds; break;
			case HEROSOUND_COMBAT_SCREEN_START: sound=mCombatPopUpScreenStartSounds; break;
			case HEROSOUND_ENGAGE_COMBAT: sound=mEngageManuallySounds; break;
			case HEROSOUND_ENGAGE_QUICK_COMBAT: sound=mEngageQuickCombatSounds; break;
			case HEROSOUND_LEVEL_UP: sound=mLevelUpSounds; break;
			case HEROSOUND_BOARDING_SHIP: sound=mBoardShipSounds; break;
			case HEROSOUND_SHIP_TURNING: sound=mShipTurningSounds; break;
			case HEROSOUND_MOUNTED_MOVE: sound=mStartMountedRandomMoveSounds; break;
			case HEROSOUND_MOUNTED_MOVE_END: sound=mEndMountedRandomMoveSounds; break;
			case HEROSOUND_MOVE_SHIP: sound=mStartShipRandomMoveSounds; break;
			case HEROSOUND_MOVE_SHIP_END: sound=mEndShipRandomMoveSounds; break;
			case HEROSOUND_SHIP_IDLE: sound=mStartShipIdleSounds; break;
			case HEROSOUND_SHIP_IDLE_END: sound=mEndShipIdleSounds; break;
			case HEROSOUND_MOUNTED_IDLE: sound=mStartMountedIdleSound_Magic; break;
			case HEROSOUND_MOUNTED_IDLE_END: sound=mEndMountedIdleSound_Magic; break;
		}
	}
	if( sound != None )
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( self, sound,true,,self.Location);
	}
}

function EnableAdventureIdleBridge(bool val)
{
	//Enables the idle bridge sounds with the different attenuations for the different map types
	if(val)
	{
		SetRTPCValue('Idle_Bridge_AdventureMap', 100.f);
		SetRTPCValue('Idle_Bridge_CombatMap', 0.f);
	}
	else
	{
		SetRTPCValue('Idle_Bridge_AdventureMap', 0.f);
		SetRTPCValue('Idle_Bridge_CombatMap', 100.f);
	}
}

function SetMovementAudioType()
{
	if(IsHero()==false || GetAdventureArmy()==None)
	{
		SetRTPCValue('Hero_Land_Volume', 0.f);
		SetRTPCValue('Hero_Water_Volume', 0.f);
	}
	else if(GetAdventureArmy().GetShip() != none)
	{
		SetRTPCValue('Hero_Land_Volume', 0.f);
		SetRTPCValue('Hero_Water_Volume', 100.f);
	}
	else
	{
		SetRTPCValue('Hero_Land_Volume', 100.f);
		SetRTPCValue('Hero_Water_Volume', 0.f);
	}
}

// We override and copy the H7Unit version of this PlayParticleEffect because we need the particles into the mHeroMesh
event bool PlayParticleEffect( const AnimNotify_PlayParticleEffect AnimNotifyData )
{
	local vector Loc;
	local rotator Rot;
	local ParticleSystemComponent PSC;
	local bool bPlayNonExtreme;
	local EmitterSpawnable emitterActor;

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		;
		return true;
	}

	// should I play non extreme content?
	bPlayNonExtreme = ( AnimNotifyData.bIsExtremeContent == TRUE ) && ( WorldInfo.GRI.ShouldShowGore() == FALSE ) ;

	// if we should not respond to anim notifies OR if this is extreme content and we can't show extreme content then return
	if( ( bShouldDoAnimNotifies == FALSE )
		// if playing non extreme but no data is set, just return
		|| ( bPlayNonExtreme && AnimNotifyData.PSNonExtremeContentTemplate==None )
		)
	{
		// Return TRUE to prevent the SkelMeshComponent from playing it as well!
		return true;
	}
	;

	// now go ahead and spawn the particle system based on whether we need to attach it or not
	if( AnimNotifyData.bAttach == TRUE )
	{
		;
		PSC = new(self) class'ParticleSystemComponent';  // move this to the object pool once it can support attached to bone/socket and relative translation/rotation
		if ( bPlayNonExtreme )
		{
			PSC.SetTemplate( AnimNotifyData.PSNonExtremeContentTemplate );
		}
		else
		{
			PSC.SetTemplate( AnimNotifyData.PSTemplate );
		}

		if( AnimNotifyData.SocketName != '' )
		{
			;
			mHeroSkeletalMesh.AttachComponentToSocket( PSC, AnimNotifyData.SocketName );
		}
		else if( AnimNotifyData.BoneName != '' )
		{
			;
			mHeroSkeletalMesh.AttachComponent( PSC, AnimNotifyData.BoneName );
		}
		else if( mHeroSkeletalMesh.GetBoneName(0) != '' ) // LIMBIC
		{
			;
			mHeroSkeletalMesh.AttachComponent( PSC, mHeroSkeletalMesh.GetBoneName(0) );
		}

		PSC.ActivateSystem();
		PSC.OnSystemFinished = OnPooledAttachedParticleSystemFinished;

		AllocatePooledEmitter(PSC);
	}
	else
	{
		// find the location
		if( AnimNotifyData.SocketName != '' )
		{
			mHeroSkeletalMesh.GetSocketWorldLocationAndRotation( AnimNotifyData.SocketName, Loc, Rot );
		}
		else if( AnimNotifyData.BoneName != '' )
		{
			Loc = mHeroSkeletalMesh.GetBoneLocation( AnimNotifyData.BoneName );
			Rot = QuatToRotator(mHeroSkeletalMesh.GetBoneQuaternion(AnimNotifyData.BoneName));
		}
		else
		{
			Loc = Location;
			Rot = rot(0,0,1);
		}

		//PSC = WorldInfo.MyEmitterPool.SpawnEmitter( AnimNotifyData.PSTemplate, Loc,  Rot,self); // these fail to be GC'd if they use SkelVertSurf. using an Emitter actor now instead
		emitterActor = Spawn(class'EmitterSpawnable', self,, Loc, Rot,, false);
		if (emitterActor != None)
		{
			emitterActor.SetTickIsDisabled(false);
			emitterActor.SetDrawScale(DrawScale);
			emitterActor.SetDrawScale3D(DrawScale3D);
			PSC = emitterActor.ParticleSystemComponent;
		}

		if (PSC != None)
		{
			if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
			{
				//class'H7CombatMapGridController'.static.GetInstance().AddParticleSystemToMonitorList( PSC );
			}

			if ( bPlayNonExtreme )
			{
				PSC.SetTemplate( AnimNotifyData.PSNonExtremeContentTemplate );
			}
			else
			{
				PSC.SetTemplate( AnimNotifyData.PSTemplate );
			}

			PSC.SetScale(SkeletalMeshComponent.Scale);
			PSC.SetScale3D(SkeletalMeshComponent.Scale3D);
		}
	}

	if( PSC != None && AnimNotifyData.BoneSocketModuleActorName != '' )
	{
		PSC.SetActorParameter(AnimNotifyData.BoneSocketModuleActorName, self);
	}

	return true;
}

/**
 * Serializes the actor's data into JSon
 *
 * @return    JSon data representing the state of this actor
 */
function JSonObject Serialize()
{
	local JSonObject myJSonObject;

	myJSonObject = super.Serialize();

	myJSonObject.SetIntValue( "Level", mLevel );
	myJSonObject.SetIntValue( "Xp", mXp );
	myJSonObject.SetIntValue( "Spirit", mSpirit );
	myJSonObject.SetIntValue( "Magic", mMagic );
	myJSonObject.SetFloatValue( "CurrentMovementPoints", mCurrentMovementPoints );
	myJSonObject.SetIntValue( "CurrentMana", mCurrentMana );
	myJSonObject.SetIntValue( "MaxManaModifier", mMaxManaBonus );
	myJSonObject.SetIntValue( "ManaRegen", mManaRegenBase );
	myJSonObject.SetIntValue( "SkillPoints", mSkillPoints );
	myJSonObject.SetBoolValue( "IsHero", mIsHero );

	myJSonObject.SetIntValue( "PlayerNumber", mOwningPlayer.GetPlayerNumber() );
	myJSonObject.SetObject( "Equipment", mEquipment.Serialize() );
	myJSonObject.SetObject( "Inventory", mInventory.Serialize() );
	myJSonObject.SetObject( "Skills", mSkillManager.Serialize() );
	myJSonObject.SetObject( "HeroSpells", mAbilityManager.Serialize() );

	// AI
	myJSonObject.SetBoolValue("AiInHibernation", mAiInHibernation);
	myJSonObject.SetIntValue("AiAggressiveness", mAiAggressiveness);

	// Send the encoded JSonObject
	return myJSonObject;
}

/**
 * Deserializes the actor from the data given
 *
 * @param    data    JSon data representing the differential state of this actor
 */
function Deserialize(JSonObject data)
{
	super.Deserialize( data );

	mLevel = data.GetIntValue("Level");
	mXp = data.GetIntValue("Xp");
	mMagic = data.GetIntValue("Magic");
	mSpirit = data.GetIntValue("Spirit");
	mCurrentMovementPoints = data.GetIntValue("CurrentMovementPoints");
	mCurrentMana = data.GetIntValue("CurrentMana");
	mMaxManaBonus = data.GetIntValue("MaxManaModifier");
	mManaRegenBase = data.GetIntValue("ManaRegen");
	mSkillPoints = data.GetIntValue("SkillPoints");
	mIsHero = data.GetBoolValue("IsHero");

	mEquipment.Deserialize( Data.GetObject( "Equipment" ) );
	mInventory.Deserialize( Data.GetObject( "Inventory" ) );
	mSkillManager.Deserialize( Data.GetObject( "Skills" ) );
	mAbilityManager.Deserialize( Data.GetObject( "HeroSpells" ) );

	// AI
	mAiInHibernation = data.GetBoolValue("AiInHibernation");
	mAiAggressiveness = EHeroAiAggressiveness(data.GetIntValue("AiAggressiveness"));
}

/**
 * Deserializes the references of the actor from the data given
 *
 * @param		Data		JSon data representing the differential state of this actor
 * @param		saveGame	SaveGameState used to search actors by id
*/
function DeserializeReferences(JSonObject Data, SaveGameState saveGame)
{
	super.DeserializeReferences( Data, saveGame );

	mOwningPlayer = saveGame.GetPlayerByNumber( EPlayerNumber( Data.GetIntValue( "PlayerNumber" ) ) );
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

