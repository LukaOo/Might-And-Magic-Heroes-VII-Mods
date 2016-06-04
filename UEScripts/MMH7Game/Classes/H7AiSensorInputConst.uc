//=============================================================================
// H7AiSensorParam
//=============================================================================
// Ambigous parameter type used by AiSensor objects. In C++ I would have used
// a union struct but afaik we do not have such things in UScript.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiSensorInputConst extends Object
	dependson(H7StructsAndEnumsNative)
	native;

const MAX_ELAPSED_TIME_FOR_CALCULATION_PER_FRAME = 18.0f;

var protected array<H7CombatMapCell>          mConstCells;
var protected H7CombatMapCell                 mConstSourceCell;
var protected H7CombatMapCell                 mConstTargetCell;
var protected H7CreatureStack                 mConstThisCreatureStack;
var protected array<H7CreatureStack>          mConstCreatureStacks;
var protected array<H7CreatureStack>          mConstOppCreatureStacks;
var protected H7WarUnit                       mConstThisWarUnit;
var protected H7CombatHero                    mConstThisHero;
var protected H7AdventureHero                 mConstThisHeroAdv;
var protected H7CombatHero                    mConstOppHero;
var protected H7CombatArmy                    mConstThisArmy;
var protected H7CombatArmy                    mConstOppArmy;
var protected H7CreatureStack                 mConstTargetCreatureStack;
var protected array<H7AdventureMapCell>       mConstCellsAdv;
var protected H7AdventureMapCell              mConstSourceCellAdv;
var protected H7AdventureMapCell              mConstTargetCellAdv;
var protected H7AdventureArmy                 mConstThisArmyAdv;
var protected array<H7AdventureArmy>          mConstArmiesAdv;
var protected array<H7AdventureArmy>          mConstBorderArmiesAdv;
var protected array<H7AdventureArmy>          mConstNeutralArmiesAdv;
var protected array<H7AdventureArmy>          mConstTownArmiesAdv;
var protected array<H7AdventureArmy>          mConstHiddenArmiesAdv;
var protected H7VisitableSite                 mConstThisVisSite;
var protected array<H7VisitableSite>          mConstVisSites;
var protected H7AdventureArmy                 mConstTargetArmyAdv;
var protected H7AdventureArmy                 mConstMakeshiftArmyAdv;
var protected H7VisitableSite                 mConstTargetVisSite;
var protected array<H7VisitableSite>          mConstThisAoCSites;
var protected array<H7VisitableSite>          mConstOppAoCSites;
var protected H7Player                        mConstThisPlayer;
var protected array<H7Player>                 mConstOtherPlayers;
var protected array<H7TownBuilding>           mConstBuildings;
var protected array<H7Town>                   mConstTowns;
var protected array<H7Fort>                   mConstForts;
var protected array<H7HeroAbility>            mConstHeroAbilities;
var protected H7CreatureAbility               mConstCreatureAbility;
var protected array<H7VisitableSite>          mConstHiddenVisSites;
var protected array<H7VisitableSite>          mConstBuffSites;
var protected array<H7VisitableSite>          mConstCollectibles;
var protected array<H7VisitableSite>          mConstStudySites;
var protected array<H7VisitableSite>          mConstCommissionSites;
var protected array<H7VisitableSite>          mConstShopSites;
var protected array<H7VisitableSite>          mConstBattleSites;
var protected array<H7VisitableSite>          mConstKeymasterSites;
var protected array<H7VisitableSite>          mConstRunicGateSites;
var protected array<H7VisitableSite>          mConstObservatorySites;
var protected array<H7VisitableSite>          mConstDestructibleSites;
var protected array<H7VisitableSite>          mConstObeliskSites;
var protected array<H7VisitableSite>          mConstShelterSites;
var protected array<H7VisitableSite>          mConstTrainingSites;
var protected array<H7AdventureHero>          mConstOwnHeroes;
var protected H7HeroAbility                   mConstUseHeroAbility;
var protected array<H7Teleporter>             mConstTeleporters;
var protected H7Teleporter                    mConstTargetTeleporter;
var protected array<H7Teleporter>             mConstHiddenTeleporters;
var protected array <ResourceStockpile>       mConstResources;
var protected ResourceStockpile               mConstTargetResource;
var protected array<RecruitHeroData>          mConstRecruitHeroes;
var protected RecruitHeroData                 mConstTargetRecruitHero;
var protected H7Town                          mConstTargetTown;
var protectedwrite array<H7VisitableSite>     mConstCurrentReachableSites;
var protected array<H7AdventureArmy>          mConstCurrentReachableArmies;
var protectedwrite array<float>               mConstCurrentReachableSitesDistance;
var protected array<float>                    mConstCurrentReachableArmiesDistance;
var protected H7BaseCreatureStack             mConstTargetBaseCreatureStack;
var protected ETargetStat                     mConstCreatureStat;
var protected ECreatureTier                   mConstCreatureTier;

var protected array<float>                    mDistances;

var protectedwrite int                        mCalcStep; // used to scatter categories of distance calculation over multiple frames
var protectedwrite float                      mLastDeltaTime;
var protectedwrite int                        mCalcArrayIndex; // used to scatter large array calculations for paths over multiple frames
var protectedwrite H7AdventureMapCell         mCalcLastCell; // used to scatter large array calculations for paths over multiple frames
var protectedwrite float                      mCalcElapsedTime; // used to scatter large array calculations for paths over multiple frames
var protectedwrite bool                       mCalcDone;
var protected H7AdventureController           mAdvCntl;
var protected H7AdventureGridManager	      mGridManager;

var protected int                             mConstNumCollectiblesAtStart;
var protected int                             mConstHireHeroLimit;

/// properties 

function ResetCalc()
{
	mCalcStep = 0;
	mLastDeltaTime = 0;
	mCalcArrayIndex = 0;
	mCalcElapsedTime = 0;
	mCalcDone = false;
}

function int                    GetCellNum()                                { return mConstCells.Length; }
function int                    GetCreatureStackNum()                       { return mConstCreatureStacks.Length; }
function int                    GetOppCreatureStackNum()                    { return mConstOppCreatureStacks.Length; }
function H7CombatMapCell        GetCell( int idx )                          { return mConstCells[idx]; }
function H7CreatureStack        GetThisCreatureStack()                      { return mConstThisCreatureStack; }
function                        SetThisCreatureStack(H7CreatureStack cs)    { mConstThisCreatureStack=cs; }
function H7CreatureStack        GetCreatureStack( int idx )                 { return mConstCreatureStacks[idx]; }
function H7CreatureStack        GetOppCreatureStack( int idx )              { return mConstOppCreatureStacks[idx]; }
function H7CombatHero           GetHero()                                   { return mConstThisHero; }
function H7AdventureHero        GetHeroAdv()                                { return mConstThisHeroAdv; }
function H7CombatHero           GetOppHero()                                { return mConstOppHero; }
function H7CombatArmy           GetArmy()                                   { return mConstThisArmy; }
function H7CombatArmy           GetOppArmy()                                { return mConstOppArmy; }
function                        SetSourceCell( H7CombatMapCell cell )       { mConstSourceCell=cell; }
function H7CombatMapCell        GetSourceCell()                             { return mConstSourceCell; }
function                        SetTargetCell( H7CombatMapCell cell )       { mConstTargetCell=cell; }
function H7CombatMapCell        GetTargetCell()                             { return mConstTargetCell; }
function                        SetTargetCreatureStack( H7CreatureStack stack ) { mConstTargetCreatureStack=stack; }
function H7CreatureStack        GetTargetCreatureStack()                    { return mConstTargetCreatureStack; }
function int                    GetCellNumAdv()                             { return mConstCellsAdv.Length; }
function int                    GetArmyNumAdv()                             { return mConstArmiesAdv.Length; }
function int                    GetNeutralArmyNumAdv()                      { return mConstNeutralArmiesAdv.Length; }
function int                    GetBorderArmyNumAdv()                       { return mConstBorderArmiesAdv.Length; }
function int                    GetTownArmyNumAdv()                         { return mConstTownArmiesAdv.Length; }
function H7AdventureMapCell     GetCellAdv( int idx )                       { return mConstCellsAdv[idx]; }
function H7AdventureArmy        GetArmyAdv()                                { return mConstThisArmyAdv; }
function                        SetSourceCellAdv( H7AdventureMapCell cell ) { mConstSourceCellAdv=cell; }
function H7AdventureMapCell     GetSourceCellAdv()                          { return mConstSourceCellAdv; }
function                        SetTargetCellAdv( H7AdventureMapCell cell ) { mConstTargetCellAdv=cell; }
function H7AdventureMapCell     GetTargetCellAdv()                          { return mConstTargetCellAdv; }
function H7AdventureArmy        GetOtherArmyAdv( int idx )                  { return mConstArmiesAdv[idx]; }
function H7AdventureArmy        GetBorderArmyAdv( int idx )                 { return mConstBorderArmiesAdv[idx]; }
function H7AdventureArmy        GetNeutralArmyAdv( int idx )                { return mConstNeutralArmiesAdv[idx]; }
function H7AdventureArmy        GetTownArmyAdv( int idx )                   { return mConstTownArmiesAdv[idx]; }
function int                    GetHiddenArmyAdvNum()                       { return mConstHiddenArmiesAdv.Length; }
function H7AdventureArmy        GetHiddenArmyAdv( int idx )                 { if( mConstHiddenArmiesAdv.Length > idx ) return mConstHiddenArmiesAdv[idx]; return None;}
function H7VisitableSite        GetThisVisSite()                            { return mConstThisVisSite; }
function int                    GetVisSiteNum()                             { return mConstVisSites.Length; }
function H7VisitableSite        GetVisSite( int idx )                       { if( mConstVisSites.Length > idx ) return mConstVisSites[idx]; return None; }
function int                    GetAoCSiteNum()                             { return mConstThisAoCSites.Length; }
function H7VisitableSite        GetAoCSite( int idx )                       { if( mConstThisAoCSites.Length > idx ) return mConstThisAoCSites[idx]; return None; }
function int                    GetOppAoCSiteNum()                          { return mConstOppAoCSites.Length; }
function H7VisitableSite        GetOppAoCSite( int idx )                    { if( mConstOppAoCSites.Length > idx ) return mConstOppAoCSites[idx]; return None; }
function                        SetTargetArmyAdv( H7AdventureArmy army, optional bool ignoreSite=false )
{
	mConstTargetArmyAdv=army; 
	if(ignoreSite==false) 
	{
		SetTargetVisSiteFromArmyAdv(); 
	}
}
function H7AdventureArmy        GetTargetArmyAdv()                          { return mConstTargetArmyAdv; }
function                        SetMakeshiftArmyAdv( H7AdventureArmy army ) { mConstMakeshiftArmyAdv=army; }
function H7AdventureArmy        GetMakeshiftArmyAdv()                       { return mConstMakeshiftArmyAdv; }
function                        SetTargetVisSite( H7VisitableSite site, optional bool ignoreArmy=false )
{
	mConstTargetVisSite=site;
	if(ignoreArmy==false)
	{
		SetTargetArmyAdvFromVisSite();
	}
	SetBuildingsFromVisSite();
}
function H7VisitableSite        GetTargetVisSite()                          { return mConstTargetVisSite; }
function                        SetPlayer( H7Player player )                { mConstThisPlayer=player; }
function H7Player               GetPlayer()                                 { return mConstThisPlayer; }
function int                    GetOtherPlayersNum()                        { return mConstOtherPlayers.Length; }
function H7Player               GetOtherPlayer( int idx )                   { return mConstOtherPlayers[idx]; }
function int                    GetBuildingsNum()                           { return mConstBuildings.Length; }
function H7TownBuilding         GetBuilding( int idx )                      { if( mConstBuildings.Length > idx ) return mConstBuildings[idx]; return None; }
function int                    GetTownsNum()                               { return mConstTowns.Length; }
function H7Town                 GetTown( int idx )                          { if( mConstTowns.Length > idx ) return mConstTowns[idx]; return None; }
function int                    GetFortsNum()                               { return mConstForts.Length; }
function H7Fort                 GetFort( int idx )                          { if( mConstForts.Length > idx ) return mConstForts[idx]; return None; }
function int                    GetHeroAbilityNum()                         { return mConstHeroAbilities.Length; }
function H7HeroAbility          GetHeroAbility( int idx )                   { if( mConstHeroAbilities.Length > idx ) return mConstHeroAbilities[idx]; return None; }
function                        SetCreatureAbility( H7CreatureAbility ca )  { mConstCreatureAbility=ca; }
function H7CreatureAbility      GetCreatureAbility()                        { return mConstCreatureAbility; }
function int                    GetHiddenVisSiteNum()                       { return mConstHiddenVisSites.Length; }
function H7VisitableSite        GetHiddenVisSite( int idx )                 { if( mConstHiddenVisSites.Length > idx ) return mConstHiddenVisSites[idx]; return None; }
function int                    GetBuffSiteNum()                            { return mConstBuffSites.Length; }
function H7VisitableSite        GetBuffSite( int idx )                      { if( mConstBuffSites.Length > idx ) return mConstBuffSites[idx]; return None; }
function int                    GetCollectiblesNum()                        { return mConstCollectibles.Length; }
function H7VisitableSite        GetCollectibles( int idx )                  { if( mConstCollectibles.Length > idx ) return mConstCollectibles[idx]; return None; }
function int                    GetStudySiteNum()                           { return mConstStudySites.Length; }
function H7VisitableSite        GetStudySite( int idx )                     { if( mConstStudySites.Length > idx ) return mConstStudySites[idx]; return None; }
function int                    GetCommissionSiteNum()                      { return mConstCommissionSites.Length; }
function H7VisitableSite        GetCommissionSite( int idx )                { if( mConstCommissionSites.Length > idx ) return mConstCommissionSites[idx]; return None; }
function int                    GetShopSiteNum()                            { return mConstShopSites.Length; }
function H7VisitableSite        GetShopSite( int idx )                      { if( mConstShopSites.Length > idx ) return mConstShopSites[idx]; return None; }
function int                    GetBattleSiteNum()                          { return mConstBattleSites.Length; }
function H7VisitableSite        GetBattleSite( int idx )                    { if( mConstBattleSites.Length > idx ) return mConstBattleSites[idx]; return None; }
function int                    GetKeymasterSiteNum()                       { return mConstKeymasterSites.Length; }
function H7VisitableSite        GetKeymasterSite( int idx )                 { if( mConstKeymasterSites.Length > idx ) return mConstKeymasterSites[idx]; return None; }
function int                    GetObservatorySiteNum()                     { return mConstObservatorySites.Length; }
function H7VisitableSite        GetObservatorySite( int idx )               { if( mConstObservatorySites.Length > idx ) return mConstObservatorySites[idx]; return None; }
function int                    GetDestructibleSiteNum()                    { return mConstDestructibleSites.Length; }
function H7VisitableSite        GetDestructibleSite( int idx )              { if( mConstDestructibleSites.Length > idx ) return mConstDestructibleSites[idx]; return None; }
function int                    GetObeliskSiteNum()                         { return mConstObeliskSites.Length; }
function H7VisitableSite        GetObeliskSite( int idx )                   { if( mConstObeliskSites.Length > idx ) return mConstObeliskSites[idx]; return None; }
function int                    GetShelterSiteNum()                         { return mConstShelterSites.Length; }
function H7VisitableSite        GetShelterSite( int idx )                   { if( mConstShelterSites.Length > idx ) return mConstShelterSites[idx]; return None; }
function int                    GetTrainingSiteNum()                        { return mConstTrainingSites.Length; }
function H7VisitableSite        GetTrainingSite( int idx )                  { if( mConstTrainingSites.Length > idx ) return mConstTrainingSites[idx]; return None; }
function int                    GetOwnHeroesNum()                           { return mConstOwnHeroes.Length; }
function H7AdventureHero        GetOwnHeroes( int idx )                     { if( mConstOwnHeroes.Length > idx ) return mConstOwnHeroes[idx]; return None; }
function                        SetUseHeroAbility( H7HeroAbility ability )  { mConstUseHeroAbility=ability; }
function H7HeroAbility          GetUseHeroAbility()                         { return mConstUseHeroAbility; }
function int                    GetTeleportersNum()                         { return mConstTeleporters.Length; }
function H7Teleporter           GetTeleporter( int idx )                    { if( mConstTeleporters.Length > idx ) return mConstTeleporters[idx]; return None; }
function                        SetTargetTeleporter( H7Teleporter tele )    { mConstTargetTeleporter=tele; }
function H7Teleporter           GetTargetTeleporter()                       { return mConstTargetTeleporter; }
function int                    GetHiddenTeleportersNum()                   { return mConstHiddenTeleporters.Length; }
function H7Teleporter           GetHiddenTeleporter( int idx )              { if( mConstHiddenTeleporters.Length > idx ) return mConstHiddenTeleporters[idx]; return None; }
function int                    GetResourcesNum()                           { return mConstResources.Length; }
function ResourceStockpile      GetResource( int idx )                      { if( mConstResources.Length > idx ) return mConstResources[idx]; return mConstResources[0]; }
function                        SetTargetResource( ResourceStockpile rs )   { mConstTargetResource=rs; }
function ResourceStockpile      GetTargetResource()                         { return mConstTargetResource; }
function int                    GetRecruitHeroNum()                         { return mConstRecruitHeroes.Length; }
function RecruitHeroData        GetRecruitHero( int idx )                   { if( mConstRecruitHeroes.Length > idx ) return mConstRecruitHeroes[idx]; return mConstRecruitHeroes[0]; }
function                        SetTargetRecruitHero( RecruitHeroData rhd ) { mConstTargetRecruitHero=rhd; }
function RecruitHeroData        GetTargetRecruitHero()                      { return mConstTargetRecruitHero; }
function                        SetTargetTown( H7Town town )                { mConstTargetTown=town; }
function H7Town                 GetTargetTown()                             { return mConstTargetTown; }
function                        SetTargetBaseCreatureStack(H7BaseCreatureStack c) { mConstTargetBaseCreatureStack=c; }
function H7BaseCreatureStack    GetTargetBaseCreatureStack()                { return mConstTargetBaseCreatureStack; }
function int                    GetHireHeroLimit()                          { return mConstHireHeroLimit; }
function ETargetStat            GetCreatureStat()                           { return mConstCreatureStat; }
function                        SetCreatureStat( ETargetStat stat )         { mConstCreatureStat=stat; }
function ECreatureTier          GetCreatureTier()                           { return mConstCreatureTier; }
function                        SetCreatureTier( ECreatureTier tier )       { mConstCreatureTier=tier; }

function bool IsTownArmy( H7AdventureArmy army )
{
	if( mConstTownArmiesAdv.Find(army) != -1 ) return true;
	return false;
}

function SetTargetVisSiteFromArmyAdv()
{
	local int                           k;
	local H7IDefendable                 defSite;

	if( mConstTargetArmyAdv != None )
	{
		mConstTargetVisSite = None;
		
		//if( IsTownArmy(mConstTargetArmyAdv) == true )
		//	`LOG_AI("Lookup VisSite for army" @ mConstTargetArmyAdv @ "(town) in" @ mConstVisSites.Length @ "sites." );
		//else
		//	`LOG_AI("Lookup VisSite for army" @ mConstTargetArmyAdv @ "in" @ mConstVisSites.Length @ "sites." );

		if( mConstTargetArmyAdv.IsGarrisoned() == true /*&& IsTownArmy(mConstTargetArmyAdv) == true */)
		{
			for( k=0; k<mConstVisSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstVisSites[k]);
				if(defSite!=None && (defSite.GetGarrisonArmy()==mConstTargetArmyAdv || defSite.GetGuardingArmy()==mConstTargetArmyAdv) )
				{
					mConstTargetVisSite = mConstVisSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstHiddenVisSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstHiddenVisSites[k]);
				if(defSite!=None && (defSite.GetGarrisonArmy()==mConstTargetArmyAdv || defSite.GetGuardingArmy()==mConstTargetArmyAdv) )
				{
					mConstTargetVisSite = mConstHiddenVisSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstThisAoCSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstThisAoCSites[k]);
				if(defSite!=None && (defSite.GetGarrisonArmy()==mConstTargetArmyAdv || defSite.GetGuardingArmy()==mConstTargetArmyAdv) )
				{
					mConstTargetVisSite = mConstThisAoCSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstOppAoCSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstOppAoCSites[k]);
				if(defSite!=None && (defSite.GetGarrisonArmy()==mConstTargetArmyAdv || defSite.GetGuardingArmy()==mConstTargetArmyAdv) )
				{
					mConstTargetVisSite = mConstOppAoCSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstCollectibles.Length; k++ )
			{
				defSite=H7IDefendable(mConstCollectibles[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstCollectibles[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstBuffSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstBuffSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstBuffSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstShopSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstShopSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstShopSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstCommissionSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstCommissionSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstCommissionSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstKeymasterSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstKeymasterSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstKeymasterSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstObservatorySites.Length; k++ )
			{
				defSite=H7IDefendable(mConstObservatorySites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstObservatorySites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstStudySites.Length; k++ )
			{
				defSite=H7IDefendable(mConstStudySites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstStudySites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstBattleSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstBattleSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstBattleSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstDestructibleSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstDestructibleSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstDestructibleSites[k];
//					`LOG_AI("  found at" @ mConstTargetVisSite);
					return;
				}
			}
			for( k=0; k<mConstObeliskSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstObeliskSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstObeliskSites[k];
//					`LOG_AI("  found at" @ mConstObeliskSites);
					return;
				}
			}
			for( k=0; k<mConstTeleporters.Length; k++ )
			{
				defSite=H7IDefendable(mConstTeleporters[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstTeleporters[k];
//					`LOG_AI("  found at" @ mConstTeleporters);
					return;
				}
			}
			for( k=0; k<mConstHiddenTeleporters.Length; k++ )
			{
				defSite=H7IDefendable(mConstHiddenTeleporters[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstHiddenTeleporters[k];
//					`LOG_AI("  found at" @ mConstHiddenTeleporters);
					return;
				}
			}
			for( k=0; k<mConstShelterSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstShelterSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstShelterSites[k];
//					`LOG_AI("  found at" @ mConstShelterSites);
					return;
				}
			}
			for( k=0; k<mConstTrainingSites.Length; k++ )
			{
				defSite=H7IDefendable(mConstTrainingSites[k]);
				if(defSite!=None && defSite.GetGuardingArmy()==mConstTargetArmyAdv )
				{
					mConstTargetVisSite = mConstTrainingSites[k];
//					`LOG_AI("  found at" @ mConstTrainingSites);
					return;
				}
			}
		}
	}
}

function SetTargetArmyAdvFromVisSite()
{
	local H7IDefendable             defSite;
	local array<H7AdventureArmy>    controllingArmies;
	local H7AdventureArmy           zocArmy;

	if( mConstTargetVisSite != None )
	{
		mConstTargetArmyAdv = None;
		defSite = H7IDefendable(mConstTargetVisSite);
		if( defSite != None )
		{
			if( defSite.GetGuardingArmy() != none && defSite.GetGuardingArmy().GetPlayer() == mConstTargetVisSite.GetPlayer() )
			{
				mConstTargetArmyAdv = defSite.GetGuardingArmy();
			}
			if( mConstTargetArmyAdv == None )
			{
				mConstTargetArmyAdv = defSite.GetGarrisonArmy();
			}

			// dismiss shell armies (no units)
			if( mConstTargetArmyAdv != None && mConstTargetArmyAdv.HasUnits() == false )
			{
				mConstTargetArmyAdv=None;
			}
		}

		if( mConstTargetArmyAdv==None )
		{
			// check for ZoC army
			controllingArmies=mConstTargetVisSite.GetEntranceCell().GetControllingArmies();
			foreach controllingArmies(zocArmy)
			{
				if(zocArmy!=None && (mConstThisPlayer.IsPlayerHostile(zocArmy.GetPlayer())==true || zocArmy.GetPlayerNumber()==PN_NEUTRAL_PLAYER) )
				{
					mConstTargetArmyAdv=zocArmy;
//					`LOG_AI("  ZoC hostile army" @ zocArmy @ "found at site" @ mConstTargetVisSite );
					return;
				}
			}
		}
	}
}

function SetBuildingsFromVisSite()
{
	local H7Town     town;
	local array<H7TownBuildingData> buildData;
	local H7TownBuildingData build;

	mConstBuildings.Remove(0,mConstBuildings.Length);

//	`LOG_AI("SetBuildingsFromVisSite");

	if( mConstTargetVisSite!=None && mConstThisPlayer!=None)
	{
		// check if building is a town and is owned/controlled by current player
		town=H7Town(mConstTargetVisSite);
		if(town!=None && town.GetPlayerNumber()==mConstThisPlayer.GetPlayerNumber())
		{
			buildData=town.GetBuildingTree();
//			`LOG_AI("  Town found with" @ buildData.Length @ "buildings in build-tree.");
			foreach buildData( build )
			{
				if( build.IsBuilt==false )
				{
//					`LOG_AI("  " @ build.Building.GetName() @ "can be build.");
					mConstBuildings.AddItem(build.Building);
				}
				else
				{
//					`LOG_AI("  " @ build.Building.GetName() @ "already build. IGNORED");
				}
			}
		}
	}
}

/// functions
function ResetCombat()
{
	local H7CombatController combatCntl;
	local H7CombatMapGrid grid;
	local int gx, gy;
	local H7Unit currentUnit;
	local H7CombatArmy armyAtk, armyDef;
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;
	local array<H7Effect> effects;
	local H7HeroAbility heroAbility;

	ResetConsts();

	combatCntl = class'H7CombatController'.static.GetInstance();
	grid = class'H7CombatMapGridController'.static.GetInstance().GetCombatGrid();

	// collect all cells of grid
	for(gy=0;gy<grid.GetYSize();gy++)
	{
		for(gx=0;gx<grid.GetXSize();gx++)
		{
			mConstCells.AddItem(grid.GetCellFast(gx,gy));
		}
	}
	
	armyAtk = combatCntl.GetArmyAttacker();
	armyDef = combatCntl.GetArmyDefender();

	currentUnit = combatCntl.GetActiveUnit();

	if( currentUnit.GetEntityType() == UNIT_CREATURESTACK )
	{
		mConstThisCreatureStack = H7CreatureStack(currentUnit);

		if( armyAtk == mConstThisCreatureStack.GetCombatArmy() ) 
		{
			mConstThisArmy = armyAtk;
			mConstOppArmy = armyDef;
			mConstThisHero = armyAtk.GetCombatHero();
			mConstOppHero = armyDef.GetCombatHero();
		}
		else
		{
			mConstThisArmy = armyDef;
			mConstOppArmy = armyAtk;
			mConstThisHero = armyDef.GetCombatHero();
			mConstOppHero = armyAtk.GetCombatHero();
		}
	}
	else if( currentUnit.GetEntityType() == UNIT_HERO )
	{
		mConstThisCreatureStack = None;

		mConstThisHero = H7CombatHero(currentUnit);

		if( armyAtk == mConstThisHero.GetCombatArmy() ) 
		{
			mConstThisArmy = armyAtk;
			mConstOppArmy = armyDef;
			mConstOppHero = armyDef.GetCombatHero();
		}
		else
		{
			mConstThisArmy = armyDef;
			mConstOppArmy = armyAtk;
			mConstOppHero = armyAtk.GetCombatHero();
		}
	}
	else if( currentUnit.GetEntityType() == UNIT_WARUNIT )
	{
		mConstThisCreatureStack = None;

		mConstThisHero = None;

		mConstThisWarUnit = H7WarUnit( currentUnit );

		if( armyAtk == mConstThisWarUnit.GetCombatArmy() ) 
		{
			mConstThisArmy = armyAtk;
			mConstOppArmy = armyDef;
			mConstOppHero = armyDef.GetCombatHero();
		}
		else
		{
			mConstThisArmy = armyDef;
			mConstOppArmy = armyAtk;
			mConstOppHero = armyAtk.GetCombatHero();
		}
	}
	else if( currentUnit.GetEntityType() == UNIT_TOWER )
	{
		// TODO UNIT TOWER
	}

	mConstThisArmy.GetSurvivingCreatureStacks(mConstCreatureStacks);
	mConstOppArmy.GetSurvivingCreatureStacks(mConstOppCreatureStacks);

	// filter out current creature stack 

	if( mConstCreatureStacks.Find(mConstThisCreatureStack) != -1 )
	{
		mConstCreatureStacks.RemoveItem(mConstThisCreatureStack);
	}

	// collect current hero abilities

	if(mConstThisHero!=None)
	{
		abilities = mConstThisHero.GetAbilities();
		// filter out abilities that can't be casted
		foreach abilities( ability )
		{
			if(ability!=None)
			{
				heroAbility = H7HeroAbility(ability);
				if(heroAbility!=None)
				{
					// get effects does the rank check internally
					heroAbility.GetEffects( effects, mConstThisHero );

					// enough mana and sufficient rank and combat spell
					if( heroAbility.GetManaCost() < mConstThisHero.GetCurrentMana() &&
						effects.Length > 0 &&
						heroAbility.IsCombatAbility() &&
						heroAbility.IsSpell() ) 
					{
						mConstHeroAbilities.AddItem(heroAbility);
//						`LOG_AI("added hero ability" @ ability.GetName() );
					}
				}
				else
				{
					if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				}
			}
		}
	}
}

function bool IsPermanentBonusSite( H7VisitableSite site )
{
	return site.IsA('H7PermanentBonusSite');
}

function bool IsBuffSite( H7VisitableSite site )
{
	return site.IsA('H7BuffSite');
}

function bool IsMine( H7VisitableSite site )
{
	return site.IsA('H7Mine');
}

function bool IsShop( H7VisitableSite site )
{
	if( site.IsA('H7Merchant') ||
		site.IsA('H7TradingPost') ||
		site.IsA('H7Shipyard') ||
		site.IsA('H7CustomNeutralDwelling') ||
		site.IsA('H7RunicForge') )
	{
		return true;
	}
	return false;
}

function bool IsWeeklyResources( H7VisitableSite site )
{
	return site.IsA('H7ResourceDepot');
}

function bool IsDwelling( H7VisitableSite site )
{
	if( site.IsA('H7Dwelling') ||
		site.IsA('H7CustomNeutralDwelling') )
	{
		return true;
	}
	return false;
}

function bool IsQuickTravel( H7VisitableSite site )
{
	return site.IsA('H7Teleporter');
}

function bool IsBattleSite( H7VisitableSite site )
{
	return site.IsA('H7BattleSite');
}

function bool IsTownOrFort( H7VisitableSite site )
{
	if( site.IsA('H7Town') ||
		site.IsA('H7Fort') )
	{
		return true;
	}
	return false;

}

function bool IsObservatory( H7VisitableSite site )
{
	if( site.IsA('H7Observatory') ||
		site.IsA('H7ObservatoryHQ') )
	{
		return true;
	}
	return false;
}

function bool IsShelter( H7VisitableSite site )
{
	return site.IsA('H7Shelter');
}

function bool IsGarrison( H7VisitableSite site )
{
	return site.IsA('H7Garrison');
}

function bool IsResourcePile( H7VisitableSite site )
{
	if( site.IsA('H7ResourcePile') /*|| site.IsA('H7RandomResource') || site.IsA('H7RandomCampfire') || site.IsA('H7RandomTreasureChest')*/ )
	{
		return true;
	}
	return false;
}

function bool IsItemPile( H7VisitableSite site )
{
	if( site.IsA('H7ItemPile') /*|| site.IsA('H7RandomArtifact')*/ )
	{
		return true;
	}
	return false;
}

function bool IsObelisk( H7VisitableSite site )
{
	if( site.IsA('H7Obelisk') )
	{
		return true;
	}
	return false;
}

function bool IsStudy( H7VisitableSite site )
{
	if( site.IsA('H7ArcaneLibrary') ||
		site.IsA('H7ArcaneAcademy') ||
		site.IsA('H7SchoolOfWar') ||
		site.IsA('H7BlindBrotherMonastery') )
	{
		return true;
	}
	return false;
}

function bool IsKeymaster( H7VisitableSite site )
{
	if( site.IsA('H7Keymaster') ||
		site.IsA('H7KeymasterGate') )
	{
		return true;
	}
	return false;
}

function bool IsRunicGate( H7VisitableSite site )
{
	if( site.IsA('H7RunicGate') )
	{
		return true;
	}
	return false;
}

function bool IsDestructible( H7VisitableSite site )
{
	if( site.IsA('H7DestructibleObjectManipulator') )
	{
		return true;
	}
	return false;
}

function bool IsTrainingGrounds( H7VisitableSite site )
{
	if( site.IsA('H7TrainingGrounds') )
	{
		return true;
	}
	return false;
}

// TODO: collected vars need to be serialized ... 
function StartAdventure()
{
	local array<H7AdventureMapGridController> allGridCtrl;
	local array<H7VisitableSite>    allSites;
	local int                       k,g;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	if( mAdvCntl == none )
	{
		mAdvCntl = class'H7AdventureController'.static.GetInstance();
	}
	if( mGridManager == none )
	{
		mGridManager = class'H7AdventureGridManager'.static.GetInstance();
	}

	mConstCellsAdv.Remove(0,mConstCellsAdv.Length);
	mConstNumCollectiblesAtStart=0;

	// we collect the adv.cells to keep the collectibles positions even after they have picked up to be used by the explore action
	allGridCtrl=mGridManager.GetAllGrids();

	for(g=0;g<allGridCtrl.Length;g++)
	{
		allSites = allGridCtrl[g].GetVisitableSites();
//		`LOG_AI("  Collecting VisSites." @ allSites.Length @ "sites available in grid with idx" @ allGridCtrl[g].GetIndex() );

		// pruning out ships and others we don't consider ai targets. removing player owned/controlled or allied structures keeping only neutral or enemy
		for( k=0; k<allSites.Length; k++ )
		{
			if( allSites[k]==None ) continue;

			if( IsResourcePile(allSites[k])==true || IsItemPile(allSites[k])==true ) 
			{
				mConstNumCollectiblesAtStart++;
				mConstCellsAdv.AddItem( allSites[k].GetEntranceCell() );
			}
		}
	}

//	`LOG_AI("   Num Collectibles:" @ mConstNumCollectiblesAtStart );
}

function ResetConsts()
{
	mConstCells.Remove(0,mConstCells.Length);
	mConstSourceCell=None;
	mConstTargetCell=None;
	mConstThisCreatureStack=None;
	mConstCreatureStacks.Remove(0,mConstCreatureStacks.Length);
	mConstOppCreatureStacks.Remove(0,mConstOppCreatureStacks.Length);
	mConstThisWarUnit=None;
	mConstThisHero=None;
	mConstThisHeroAdv=None;
	mConstOppHero=None;
	mConstThisArmy=None;
	mConstOppArmy=None;
	mConstTargetCreatureStack=None;
//	mConstCellsAdv.Remove(0,mConstCellsAdv.Length);
	mConstSourceCellAdv=None;
	mConstTargetCellAdv=None;
	mConstThisArmyAdv=None;
	mConstArmiesAdv.Remove(0,mConstArmiesAdv.Length);
	mConstBorderArmiesAdv.Remove(0,mConstBorderArmiesAdv.Length);
	mConstNeutralArmiesAdv.Remove(0,mConstNeutralArmiesAdv.Length);
	mConstTownArmiesAdv.Remove(0,mConstTownArmiesAdv.Length);
	mConstThisVisSite=None;
	mConstVisSites.Remove(0,mConstVisSites.Length);
	mConstTargetArmyAdv=None;
	mConstTargetVisSite=None;
	mConstThisAoCSites.Remove(0,mConstThisAoCSites.Length);
	mConstOppAoCSites.Remove(0,mConstOppAoCSites.Length);
	mConstThisPlayer=None;
	mConstOtherPlayers.Remove(0,mConstOtherPlayers.Length);
	mConstBuildings.Remove(0,mConstBuildings.Length);
	mConstTowns.Remove(0,mConstTowns.Length);
	mConstForts.Remove(0,mConstForts.Length);
	mConstHeroAbilities.Remove(0,mConstHeroAbilities.Length);
	mConstCreatureAbility=None;
	mConstHiddenVisSites.Remove(0,mConstHiddenVisSites.Length);
	mConstBuffSites.Remove(0,mConstBuffSites.Length);
	mConstCollectibles.Remove(0,mConstCollectibles.Length);
	mConstStudySites.Remove(0,mConstStudySites.Length);
	mConstCommissionSites.Remove(0,mConstCommissionSites.Length);
	mConstShopSites.Remove(0,mConstShopSites.Length);
	mConstBattleSites.Remove(0,mConstBattleSites.Length);
	mConstKeymasterSites.Remove(0,mConstKeymasterSites.Length);
	mConstObservatorySites.Remove(0,mConstObservatorySites.Length);
	mConstDestructibleSites.Remove(0,mConstDestructibleSites.Length);
	mConstObeliskSites.Remove(0,mConstObeliskSites.Length);
	mConstShelterSites.Remove(0,mConstShelterSites.Length);
	mConstTrainingSites.Remove(0,mConstTrainingSites.Length);
	mConstOwnHeroes.Remove(0,mConstOwnHeroes.Length);
	mConstUseHeroAbility=None;
	mConstTeleporters.Remove(0,mConstTeleporters.Length);
	mConstTargetTeleporter=None;
	mConstHiddenTeleporters.Remove(0,mConstHiddenTeleporters.Length);
	mConstResources.Remove(0,mConstResources.Length);
	mConstTargetResource.Type=None;
	mConstTargetResource.Quantity=0;
	mConstTargetResource.Income=0;
	mConstRecruitHeroes.Remove(0,mConstRecruitHeroes.Length);
	mConstTargetRecruitHero.Army=None;
	mConstTargetRecruitHero.Cost=0;
	mConstTargetRecruitHero.IsAvailable=false;
	mConstTargetRecruitHero.IsNew=true;
	mConstTargetRecruitHero.RandomHeroesIndex=-1;
	//mConstTargetTown=None;
	mConstCurrentReachableSites.Remove(0,mConstCurrentReachableSites.Length);
	mConstCurrentReachableArmies.Remove(0,mConstCurrentReachableArmies.Length);
	mConstTargetBaseCreatureStack=None;
	mConstMakeshiftArmyAdv=None;
	mDistances.Remove(0,mDistances.Length);
	mConstHireHeroLimit=1;
	mConstHiddenArmiesAdv.Remove(0,mConstHiddenArmiesAdv.Length);
	mConstCreatureStat=TS_STAT_NONE;
	mConstCreatureTier=CTIER_CORE;
}

function ResetCalcStep()
{
	mCalcStep = 0;
}

function ResetAdventure(bool isTown)
{
	local array<H7AdventureArmy>    allArmies;
	local array<H7VisitableSite>    allSites;
	local array<H7Teleporter>       allTeleporters;
	local int                       k,l,g, siteCategory, mainTownIdx;
	local H7AreaOfControlSite       aocSite;
	local EPlayerNumber             activePlayerNumber;
	local float                     distance;
	local IntPoint                  distIP;
	local H7AdventureMapGridController gridCtrl;
	local array<H7AdventureMapGridController> allGridCtrl;
	local H7FOWController           fogCtrl;
	local H7AreaOfControlSiteVassal aocSiteVassal;
	local H7AreaOfControlSiteLord   aocSiteLord;
	local H7IHideable               hideableSite;
	local H7ResourceSet             resourceSet;
	local int                       townLevel;
	local int                       forceAoC;
	local bool                      rejectSite;
	local int                       mineTowns;

	if( mAdvCntl == none )
	{
		mAdvCntl = class'H7AdventureController'.static.GetInstance();
	}
	if( mGridManager == none )
	{
		mGridManager = class'H7AdventureGridManager'.static.GetInstance();
	}

	if( mCalcStep == 0 )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		ResetConsts();

		mConstThisPlayer = mAdvCntl.GetCurrentPlayer();
		if( mConstThisPlayer != None )
		{
			activePlayerNumber = mConstThisPlayer.GetPlayerNumber();
			mConstTowns = mConstThisPlayer.GetTowns();
			mConstForts = mConstThisPlayer.GetForts();
		}
		else
		{
			activePlayerNumber = PN_MAX;
		}

		mConstOtherPlayers = mAdvCntl.GetPlayers();
		mConstOtherPlayers.Remove( mConstOtherPlayers.Find(mConstThisPlayer), 1 );

		resourceSet=mConstThisPlayer.GetResourceSet();
	
		mConstResources=resourceSet.GetAllResourcesAsArray();
		mConstTargetResource=mConstResources[0];

		//`LOG_AI("  RS-------------------------------------------------");
		//mConstThisPlayer.AiDumpResources(mConstThisPlayer.GetResourceSet());
		//`LOG_AI("  RS TownDev-----------------------------------------");
		//mConstThisPlayer.AiDumpResources(mConstThisPlayer.GetAiSaveUpSpendingTownDev());
		//`LOG_AI("  RS Hire Hero---------------------------------------");
		//mConstThisPlayer.AiDumpResources(mConstThisPlayer.GetAiSaveUpSpendingHero());
		//`LOG_AI("  ---------------------------------------------------");

		for(k=0;k<mConstForts.Length;k++)
		{
			// check for garrison army
			if( mConstForts[k].GetGarrisonArmy()!=None )
			{
				mConstTownArmiesAdv.AddItem(mConstForts[k].GetGarrisonArmy());
			}
		}

		townLevel=0;
		mainTownIdx=-1;
		for(k=0;k<mConstTowns.Length;k++)
		{
			// get recruit hero list from current town
			if( mConstTowns[k]==mConstTargetTown )
			{
				mConstRecruitHeroes=class'H7AdventureController'.static.GetInstance().GetHallOfHeroesManager().GetHeroesPool( mConstThisPlayer, mConstTowns[k] );
			}
			// check for main town
			mConstTowns[k].SetAiIsMain(false);
			if( mConstThisPlayer.GetAiCapitol()!=mConstTowns[k])
			{
				if( mConstTowns[k]!=None && mConstTowns[k].GetLevel()>townLevel ) 
				{
					townLevel=mConstTowns[k].GetLevel();
					mainTownIdx=k;
				}
			}
			else
			{
				mainTownIdx=k;
				townLevel=911;
			}

			// check for garrison army
			if( mConstTowns[k].GetGarrisonArmy()!=None )
			{
				mConstTownArmiesAdv.AddItem(mConstTowns[k].GetGarrisonArmy());
			}

		}
		if(mainTownIdx>=0)
		{
			mConstTowns[mainTownIdx].SetAiIsMain(true);
			if(mConstThisPlayer.GetAiCapitol()==None)
			{
				mConstThisPlayer.SetAiCapitol(mConstTowns[mainTownIdx]); // it will stay capitol until end of all times
			}
		}

		forceAoC=-1;
		mConstThisArmyAdv = mAdvCntl.GetSelectedArmy();
		if( mConstThisArmyAdv != None )
		{
			forceAoC=mConstThisArmyAdv.GetAiStayInAoC();
			mConstThisHeroAdv = mConstThisArmyAdv.GetHero();

			if(mConstThisPlayer!=None)
			{
				mConstThisPlayer.AddDiscoveredAoC( mConstThisArmyAdv.GetCell().GetAreaOfControl() );
			}
			
		}

		allArmies = mAdvCntl.GetArmies();
//		`LOG_AI("Collecting Armies." @ allArmies.Length @ "armies available." );
		// pruning out None references and empty armies ...
		for( k=0; k<allArmies.Length; k++ )
		{
			rejectSite=false;
			if(allArmies[k]==None)
			{
	//			`LOG_AI("  pruning entry (None)");
			}
			else if( allArmies[k].GetPlayerNumber()==activePlayerNumber )
			{
				//`LOG_AI("  pruning entry (" @ allArmies[k] @ ") - Owned by current player.");
				// we collect the heroes of the armies
				if(allArmies[k].GetHero()!=mConstThisHeroAdv && allArmies[k].IsDead() == false )
				{
					mConstOwnHeroes.AddItem( allArmies[k].GetHero() );
				}
			}
			else if( allArmies[k].IsDead() == true )
			{
	//			`LOG_AI("  pruning entry (" @ allArmies[k] @ ") - It is dead Jim.");
			}
			else if(allArmies[k].IsGarrisoned()==false)
			{
				gridCtrl=allArmies[k].GetCell().GetGridOwner();
				if( gridCtrl==None ) continue;
				fogCtrl=gridCtrl.GetFOWController();
				if( fogCtrl==None ) continue;
			
				if(forceAoC>=0 && forceAoC!=allArmies[k].GetCell().GetAreaOfControl())
				{
					rejectSite=true;
				}

				if( fogCtrl.CheckExploredTile( activePlayerNumber, allArmies[k].GetCell().GetCellPosition() ) == false )
				{
	//			   `LOG_AI("  pruning entry (" @ allArmies[k] @ ") - army hidden by FoW.");
					if( allArmies[k].GetAiIsBorderControl()==true && rejectSite==false )
					{
						mConstHiddenArmiesAdv.AddItem(allArmies[k]);
					}
				}
				else
				{
					if(rejectSite==false) 
					{
						if( allArmies[k].GetAiIsBorderControl() ) // border is preferred first
						{
							mConstBorderArmiesAdv.AddItem( allArmies[k] );
						}
						else if( allArmies[k].GetPlayerNumber() == PN_NEUTRAL_PLAYER ) // check if it's neutral
						{
							mConstNeutralArmiesAdv.AddItem(allArmies[k]);
						}
						else
						{
							mConstArmiesAdv.AddItem(allArmies[k]); // we can assume now it's from another player
						}
					}
				}
			}
			else
			{
				if( allArmies[k].GetAiIsBorderControl()==true )
				{
					if(forceAoC>=0)
					{
						if(allArmies[k].GetGarrisonedSite()!=None && forceAoC!=allArmies[k].GetGarrisonedSite().GetEntranceCell().GetAreaOfControl() )
						{
							rejectSite=true;
						}
						else if(allArmies[k].GetGarrisonedSite()==None && forceAoC!=allArmies[k].GetCell().GetAreaOfControl() )
						{
							rejectSite=true;
						}
					}
					if(rejectSite==false)
					{
						gridCtrl=allArmies[k].GetCell().GetGridOwner();
						if( gridCtrl==None ) continue;
						fogCtrl=gridCtrl.GetFOWController();
						if( fogCtrl==None ) continue;
						if( fogCtrl.CheckExploredTile(activePlayerNumber,allArmies[k].GetCell().GetCellPosition())==false )
						{
							mConstHiddenArmiesAdv.AddItem(allArmies[k]);
						}
						else
						{
							mConstArmiesAdv.AddItem(allArmies[k]);
						}
					}
				}
				else if( H7Garrison( allArmies[k].GetGarrisonedSite() ) != none )
				{
					mConstBorderArmiesAdv.AddItem(allArmies[k]);
				}
				else
				{
					mConstArmiesAdv.AddItem(allArmies[k]);
				}
			}
		}

		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

		if(isTown==true)
		{
			// for town AI we are done at this point ... besides collecting some statistics

			mineTowns=0;
			allGridCtrl=mGridManager.GetAllGrids();
			for(g=0;g<allGridCtrl.Length;g++)
			{
				allSites = allGridCtrl[g].GetVisitableSites();
				for( k=0; k<allSites.Length; k++ )
				{
					if( allSites[k]==None ) continue;

//					`LOG_AI(" #"$g$","$k@"SITE"@allSites[k].GetName()@allSites[k]);

					aocSite = H7AreaOfControlSite(allSites[k]);
					if(aocSite!=None && aocSite.IsA('H7Town') )
					{
						if( aocSite.GetPlayerNumber() == activePlayerNumber )
						{
							mineTowns++;
						}
					}
				}
			}
			
			mConstHireHeroLimit=1;
			if(mConstThisPlayer!=None)
			{
				// New formular (all good things go by threes) : 1 + 1 per owned town + 1 per aoc moved on for the first time
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				mConstHireHeroLimit += mConstThisPlayer.GetDiscoveredAoC() + mineTowns;
			}
			mConstHireHeroLimit=Clamp(mConstHireHeroLimit,1,8);
			return;
		}

		allGridCtrl=mGridManager.GetAllGrids();

		for(g=0;g<allGridCtrl.Length;g++)
		{
			allSites = allGridCtrl[g].GetVisitableSites();
//			`LOG_AI("Collecting VisSites." @ allSites.Length @ "sites available in grid with idx" @ allGridCtrl[g].GetIndex() );

			// pruning out ships and others we don't consider ai targets. removing player owned/controlled or allied structures keeping only neutral or enemy
			for( k=0; k<allSites.Length; k++ )
			{
				if( allSites[k]==None ) continue;

				siteCategory=0;

				if(forceAoC>0 && forceAoC!=allSites[k].GetEntranceCell().GetAreaOfControl())
				{
					rejectSite=true;
				}
				else
				{
					rejectSite=false;
				}

				aocSite = H7AreaOfControlSite(allSites[k]);
				if(aocSite!=None && !aocSite.IsA('H7CustomNeutralDwelling') )
				{
					if( aocSite.GetPlayerNumber() == activePlayerNumber )
					{
						siteCategory=1;
					}
					else if( aocSite.GetPlayer().IsPlayerAllied(mConstThisPlayer)==true )
					{
						siteCategory=2;
					}
					else if( aocSite.IsA('H7Dwelling') == true || aocSite.IsA('H7Mine') == true )
					{
						aocSiteVassal=H7AreaOfControlSiteVassal(aocSite);
						if(aocSiteVassal!=None)
						{
							if( aocSiteVassal.GetPlayerNumber() != PN_NEUTRAL_PLAYER )
							{
								aocSiteLord=aocSiteVassal.GetLord();
								if(aocSiteLord!=None)
								{
									if( mConstThisPlayer.IsPlayerAllied( aocSiteLord.GetPlayer() ) == false )
									{
										siteCategory=3;
									}
									else if( aocSiteLord.GetPlayerNumber() == activePlayerNumber )
									{
										siteCategory=1;
									}
									else
									{
										siteCategory=2;
									}
								}
							}
							else
							{
								siteCategory=4;
							}
						}
					}
					else if( aocSite.IsA('H7Town')==true || aocSite.IsA('H7Fort')==true || aocSite.IsA('H7Garrison')==true )
					{
						if( aocSite.GetPlayerNumber()==PN_NEUTRAL_PLAYER )
						{
							siteCategory=4;
						}
						else
						{
							siteCategory=3;
						}
					}
				}

				hideableSite=H7IHideable(allSites[k]);
				
				if( siteCategory==1 )
				{
		//			`LOG_AI("  pruning entry (" @ allSites[k] @ ") - Owned by current player. Adding to owned aoc sites");
					if(rejectSite==false) 
					{
						mConstThisAoCSites.AddItem(allSites[k]);
					}
				}
				else if( siteCategory==2 )
				{
		//			`LOG_AI("  pruning entry (" @ allSites[k] @ ") - Owned by allied player.");
				}
				else if( siteCategory==3 )
				{
		//			`LOG_AI("  pruning entry (" @ allSites[k] @ ") - Owned by enemy player.");
					if(rejectSite==false) 
					{
						mConstOppAoCSites.AddItem(allSites[k]);
					}
				}
				else if( siteCategory==4 )
				{
		//			`LOG_AI("  pruning entry (" @ allSites[k] @ ") - Owned by neutral player.");
					if(rejectSite==false) 
					{
						mConstOppAoCSites.AddItem(allSites[k]);
					}
				}
				else if( hideableSite!=None && hideableSite.IsHiddenX()==true )
				{
		//			`LOG_AI("  pruning entry (" @ allSites[k] @ ") - Hidden object.");
				}
				else
				{
					gridCtrl= allSites[k].GetEntranceCell().GetGridOwner();
					if( gridCtrl==None ) continue;
					fogCtrl=gridCtrl.GetFOWController();
					if( fogCtrl==None ) continue;
			
					if( fogCtrl.CheckExploredTile( activePlayerNumber, allSites[k].GetEntranceCell().GetCellPosition() ) == false )
					{
		//				`LOG_AI("  pruning entry (" @ allSites[k] @ ") - hidden by FoW." @ allSites[k].GetEntranceCell() @ allSites[k].GetEntranceCell().mPosition.X @ allSites[k].GetEntranceCell().mPosition.Y );
						if(rejectSite==false) 
						{
							mConstHiddenVisSites.AddItem(allSites[k]);
						}
					}
					else
					{
						if(rejectSite==false) 
						{
							if( IsPermanentBonusSite(allSites[k]) || IsBuffSite(allSites[k]) )
							{
								mConstBuffSites.AddItem(allSites[k]);
							}
							else if( IsResourcePile(allSites[k]) || IsItemPile(allSites[k]) )
							{
								mConstCollectibles.AddItem(allSites[k]);
							}
							else if( IsStudy(allSites[k]) )
							{
								mConstStudySites.AddItem(allSites[k]);
							}
							else if( IsWeeklyResources(allSites[k]) )
							{
								mConstCommissionSites.AddItem(allSites[k]);
							}
							else if( IsShop(allSites[k]) )
							{
								mConstShopSites.AddItem(allSites[k]);
							}
							else if( IsBattleSite(allSites[k]) )
							{
								mConstBattleSites.AddItem(allSites[k]);
							}
							else if( IsKeymaster(allSites[k]) )
							{
								mConstKeymasterSites.AddItem(allSites[k]);
							}
							else if( IsRunicGate(allSites[k]) )
							{
								mConstRunicGateSites.AddItem(allSites[k]);
							}
							else if( IsObservatory(allSites[k]) )
							{
								mConstObservatorySites.AddItem(allSites[k]);
							}
							else if( IsDestructible(allSites[k]) )
							{
								mConstDestructibleSites.AddItem(allSites[k]);
							}
							else if( IsObelisk(allSites[k]) )
							{
								mConstObeliskSites.AddItem(allSites[k]);
							}
							else if( IsShelter(allSites[k]) )
							{
								mConstShelterSites.AddItem(allSites[k]);
							}
							else if( IsTrainingGrounds(allSites[k]) )
							{
								mConstTrainingSites.AddItem(allSites[k]);
							}
							else
							{
								mConstVisSites.AddItem(allSites[k]);
							}
						}
					}
				}
			}
		}
	

		//`LOG_AI("  ==> Own AoC Sites" @ mConstThisAoCSites.Length );
		//`LOG_AI("  ==> Other AoC Sites" @ mConstOppAoCSites.Length );
		//`LOG_AI("  ==> Hidden Sites" @ mConstHiddenVisSites.Length );
		//`LOG_AI("  ==> Buff Sites" @ mConstBuffSites.Length );
		//`LOG_AI("  ==> Collectibles" @ mConstCollectibles.Length );
		//`LOG_AI("  ==> Study Sites" @ mConstBuffSites.Length );
		//`LOG_AI("  ==> Commission Sites" @ mConstCommissionSites.Length );
		//`LOG_AI("  ==> Shop Sites" @ mConstShopSites.Length );
		//`LOG_AI("  ==> Battle Sites" @ mConstBattleSites.Length );
		//`LOG_AI("  ==> Keymaster Sites" @ mConstKeymasterSites.Length );
		//`LOG_AI("  ==> Observatory Sites" @ mConstObservatorySites.Length );
		//`LOG_AI("  ==> Destructible Sites" @ mConstDestructibleSites.Length );
	
		allTeleporters = mAdvCntl.GetTeleporterList();
		//`LOG_AI("Collecting Teleporters." @ allTeleporters.Length );

		for( k=0; k<allTeleporters.Length; k++ )
		{
			hideableSite=H7IHideable(allTeleporters[k]);

			if(hideableSite!=None && allTeleporters[k].IsHiddenX()==true)
			{
	//			`LOG_AI("  pruning entry (" @ allTeleporters[k] @ ") - Hidden object.");
			}
	//		else if(allTeleporters[k].GetEntranceCell().GetGridOwner().GetIndex() != mGridManager.GetCurrentGrid().GetIndex() )
	//		{
	////			`LOG_AI("  pruning entry (" @ allTeleporters[k] @ ") - Different Grid.");
	//		}
			else
			{
				gridCtrl= allTeleporters[k].GetEntranceCell().GetGridOwner();
				if( gridCtrl==None ) continue;
				fogCtrl=gridCtrl.GetFOWController();
				if( fogCtrl==None ) continue;
			
				if(forceAoC>=0 && forceAoC!=allTeleporters[k].GetEntranceCell().GetAreaOfControl())
				{
					rejectSite=true;
				}
				else
				{
					rejectSite=false;
				}

				if( fogCtrl.CheckExploredTile( activePlayerNumber,  allTeleporters[k].GetEntranceCell().GetCellPosition() ) == false )
				{
	//				`LOG_AI("  pruning entry (" @ allTeleporters[k] @ ") - hidden by FoW." @ allTeleporters[k].GetEntranceCell() );
					if(rejectSite==false) 
					{					
						mConstHiddenTeleporters.AddItem(allTeleporters[k]);
					}
				}
				else
				{
					if(rejectSite==false) 
					{					
						mConstTeleporters.AddItem(allTeleporters[k]);
					}
				}
			}
		}

		//`LOG_AI("  ==> Teleporters" @ mConstTeleporters.Length );
		//`LOG_AI("  ==> Hidden Teleporters" @ mConstHiddenTeleporters.Length );

		//++mCalcStep;
		mCalcStep = 11;
		mCalcArrayIndex = 0;
		return;
	}

	if(mConstThisArmyAdv!=None)
	{
		if( mCalcStep == 11 )
		{
			mLastDeltaTime = FMin( mAdvCntl.WorldInfo.DeltaSeconds * 1000 / 2, MAX_ELAPSED_TIME_FOR_CALCULATION_PER_FRAME );
			mCalcDone = mGridManager.GetPathfinder().GetReachableSitesAndArmies( mConstThisArmyAdv.GetCell(), mConstThisArmyAdv.GetPlayer(), mConstThisArmyAdv.HasShip(), mConstCurrentReachableSites, mConstCurrentReachableArmies, mConstCurrentReachableSitesDistance, mConstCurrentReachableArmiesDistance, true, mLastDeltaTime );

			if( !mCalcDone )
			{
				return;
			}
			else
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
				mConstThisArmyAdv.SetReachableArmies(mConstCurrentReachableArmies);
				mConstThisArmyAdv.SetReachableArmiesDistances(mConstCurrentReachableArmiesDistance);
				mConstThisArmyAdv.SetReachableSites(mConstCurrentReachableSites);
				mConstThisArmyAdv.SetReachableSitesDistances(mConstCurrentReachableSitesDistance);
				mCalcStep = 1;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
				mCalcLastCell = none;
			}
		}
		
	}

	//CalcSortDistances( mConstVisSites, mDistances );
	//CalcSortDistances( mConstHiddenVisSites, mDistances );
	//CalcSortDistances( mConstOppAoCSites, mDistances );
	//CalcSortDistances( mConstBuffSites, mDistances );
	//CalcSortDistances( mConstCollectibles, mDistances );
	//CalcSortDistances( mConstStudySites, mDistances );    
	//CalcSortDistances( mConstCommissionSites, mDistances );
	//CalcSortDistances( mConstShopSites, mDistances );
	//CalcSortDistances( mConstBattleSites, mDistances );
	//CalcSortDistances( mConstKeymasterSites, mDistances );
	//CalcSortDistances( mConstObservatorySites, mDistances );

	if(mConstThisArmyAdv!=None)
	{
		mLastDeltaTime = FMin( mAdvCntl.WorldInfo.DeltaSeconds * 1000 / 2, MAX_ELAPSED_TIME_FOR_CALCULATION_PER_FRAME );
		if( mCalcStep == 1 )
		{
			CalcSortMovementDistancesArmies( mConstArmiesAdv, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 2 )
		{
			CalcSortMovementDistancesArmies( mConstHiddenArmiesAdv, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 3 )
		{
			CalcSortMovementDistances( mConstVisSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 4 )
		{
			CalcSortMovementDistances( mConstHiddenVisSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 5 )
		{
			CalcSortMovementDistances( mConstOppAoCSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 6 )
		{
			CalcSortMovementDistances( mConstBuffSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 7 )
		{
			CalcSortMovementDistances( mConstCollectibles, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 8 )
		{
			CalcSortMovementDistances( mConstStudySites, mDistances );    
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 9 )
		{
			CalcSortMovementDistances( mConstCommissionSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 10 )
		{
			CalcSortMovementDistances( mConstShopSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 11 )
		{
			CalcSortMovementDistances( mConstBattleSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 12 )
		{
			CalcSortMovementDistances( mConstKeymasterSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 13 )
		{
			CalcSortMovementDistances( mConstObservatorySites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 14 )
		{
			CalcSortMovementDistances( mConstDestructibleSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 15 )
		{
			CalcSortMovementDistances( mConstObeliskSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 16 )
		{
			CalcSortMovementDistances( mConstShelterSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 17 )
		{
			CalcSortMovementDistances( mConstTrainingSites, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 18 )
		{
			CalcSortMovementDistancesArmies( mConstBorderArmiesAdv, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 19 )
		{
			CalcSortMovementDistancesArmies( mConstNeutralArmiesAdv, mDistances );
			if( !mCalcDone )
			{
				return;
			}
			else
			{
				++mCalcStep;
				mCalcArrayIndex = 0;
				mCalcElapsedTime = 0.0f;
				mCalcDone = false;
			}
		}
		if( mCalcStep == 20 )
		{
			// sort teleporters for their geometric (grid-)distance
			mDistances.Remove(0,mDistances.Length);
			for( k=0; k<mConstTeleporters.Length; k++ )
			{
				distIP = mConstThisArmyAdv.GetCell().GetCellPosition();
				distIP.X -= mConstTeleporters[k].GetEntranceCell().GetCellPosition().X;
				distIP.Y -= mConstTeleporters[k].GetEntranceCell().GetCellPosition().Y;
				distance = sqrt( abs(distIP.X)**2 + abs(distIP.Y)**2 );
				mDistances.AddItem( distance );
			}
			for( k=0; k<mConstTeleporters.Length-1; k++ )
			{
				for( l=k+1; l<mConstTeleporters.Length; l++ )
				{
					if( mDistances[l] < mDistances[k] )
					{
						distance=mDistances[l]; mDistances[l]=mDistances[k]; mDistances[k]=distance;
						mConstTargetTeleporter=mConstTeleporters[l]; mConstTeleporters[l]=mConstTeleporters[k]; mConstTeleporters[k]=mConstTargetTeleporter;
					}
				}
			}

			// sort hidden teleporters for their geometric (grid-)distance
			mDistances.Remove(0,mDistances.Length);
			for( k=0; k<mConstHiddenTeleporters.Length; k++ )
			{
				distIP = mConstThisArmyAdv.GetCell().GetCellPosition();
				distIP.X -= mConstHiddenTeleporters[k].GetEntranceCell().GetCellPosition().X;
				distIP.Y -= mConstHiddenTeleporters[k].GetEntranceCell().GetCellPosition().Y;
				distance = sqrt( abs(distIP.X)**2 + abs(distIP.Y)**2 );
				mDistances.AddItem( distance );
			}
			for( k=0; k<mConstHiddenTeleporters.Length-1; k++ )
			{
				for( l=k+1; l<mConstHiddenTeleporters.Length; l++ )
				{
					if( mDistances[l] < mDistances[k] )
					{
						distance=mDistances[l]; mDistances[l]=mDistances[k]; mDistances[k]=distance;
						mConstTargetTeleporter=mConstHiddenTeleporters[l]; mConstHiddenTeleporters[l]=mConstHiddenTeleporters[k]; mConstHiddenTeleporters[k]=mConstTargetTeleporter;
					}
				}
			}
			mCalcStep = INDEX_NONE;
			mCalcArrayIndex = 0;
			mCalcElapsedTime = 0.0f;
			mCalcDone = false;
		}
		
	}

	mCalcStep = INDEX_NONE;
	return;
}

function Reset( optional bool isCombatMapDomain = true, optional bool isTownDomain = false )
{
	if( isCombatMapDomain == true )
	{
		ResetCombat();
	}
	else
	{
		ResetAdventure(isTownDomain);
	}
}

function CalcSortDistances( out array<H7VisitableSite> sites, out array<float> sitesDistance )
{
	local int                       k,l;
	local float                     distance;
	local IntPoint                  distIP;

	sitesDistance.Remove(0,sitesDistance.Length);

	// sort vis-sites for their geometric (grid-)distance
	for( k=0; k<sites.Length; k++ )
	{
		distIP = mConstThisArmyAdv.GetCell().GetCellPosition();
		distIP.X -= sites[k].GetEntranceCell().GetCellPosition().X;
		distIP.Y -= sites[k].GetEntranceCell().GetCellPosition().Y;
		distance = sqrt( abs(distIP.X)**2 + abs(distIP.Y)**2 );
		sitesDistance.AddItem( distance );
	}
	for( k=0; k<sites.Length-1; k++ )
	{
		for( l=k+1; l<sites.Length; l++ )
		{
			if( sitesDistance[l] < sitesDistance[k] )
			{
				distance=sitesDistance[l]; sitesDistance[l]=sitesDistance[k]; sitesDistance[k]=distance;
				mConstTargetVisSite=sites[l]; sites[l]=sites[k]; sites[k]=mConstTargetVisSite;
			}
		}
	}
}

native function CalcSortMovementDistances( out array<H7VisitableSite> sites, out array<float> sitesDistance );

function CalcSortMovementDistancesArmies( out array<H7AdventureArmy> armies, out array<float> armyDistance )
{
	local int                           k,l;
	local float                         distance, elapsedTime;

	if( mConstThisArmyAdv==None || mConstThisArmyAdv.GetCell() == none )
	{
		mCalcDone = true;
		return;
	}

	if( mCalcArrayIndex == 0 )
	{
		armyDistance.Remove(0,armyDistance.Length);
	}

	for( k=mCalcArrayIndex; k<armies.Length; k++ )
	{
		elapsedTime = 0;
		mAdvCntl.Clock( elapsedTime );
		if( mConstCurrentReachableArmies.Find( armies[k] ) == INDEX_NONE ) 
		{
			armyDistance.AddItem( class'H7AdventureMapPathfinder'.const.INFINITE + k );
		}
		else
		{
			l = mConstCurrentReachableArmies.Find( armies[k] );
			if( l != INDEX_NONE )
			{
				distance = mConstCurrentReachableArmiesDistance[l];
			}
			else
			{
				;
				distance = class'H7AdventureMapPathfinder'.const.INFINITE + k;
			}
			armyDistance.AddItem( distance );
		}
		mAdvCntl.UnClock( elapsedTime );
		mCalcElapsedTime += elapsedTime;
		if( mCalcElapsedTime > mLastDeltaTime )
		{
			mCalcElapsedTime = 0;
			k++;
			break;
		}
	}
	if( k == armies.Length )
	{
		mCalcDone = true;
	}
	mCalcArrayIndex = k;
	
	if( mCalcDone )
	{
		elapsedTime = 0;
		mAdvCntl.Clock( elapsedTime );
		for( k=0; k<armies.Length-1; k++ )
		{
			for( l=k+1; l<armies.Length; l++ )
			{
				if( armyDistance[l] < armyDistance[k] )
				{
					distance=armyDistance[l]; armyDistance[l]=armyDistance[k]; armyDistance[k]=distance;
					mConstTargetArmyAdv=armies[l]; armies[l]=armies[k]; armies[k]=mConstTargetArmyAdv;
				}
			}
		}

		for( k=0; k<armies.Length; k++ )
		{
			if(armyDistance[k]>=class'H7AdventureMapPathfinder'.const.INFINITE) break;
		}

		if(k<armies.Length)
		{
			armies.Remove(k,armies.Length-k);
		}
		mAdvCntl.UnClock( elapsedTime );
	}
}
