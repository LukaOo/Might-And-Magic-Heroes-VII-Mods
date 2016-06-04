//=============================================================================
// H7AiActionParam
//=============================================================================
// Ambigous parameter types used by AiAction(s). They are defined within any
// action object.
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AiActionParam extends Object
	dependson(H7StructsAndEnumsNative);

var EAiActionParamType  mParamType[3];
var H7Unit              mUnit[3];
var H7CombatMapCell     mCMapCell[3];
var H7AdventureMapCell  mAMapCell[3];
var H7CombatArmy        mCombatArmy[3];
var H7AdventureArmy     mAdventureArmy[3];
var H7VisitableSite     mVisSite[3];
var H7Player            mPlayer[3];
var H7TownBuilding      mBuilding[3];
var H7BaseAbility       mAbility[3];
var H7Teleporter        mTeleporter[3];
var ResourceStockpile   mResourceStockpile[3];
var RecruitHeroData     mRecruitHeroData[3];
var H7BaseCreatureStack mBaseCreatureStack[3];

/// properties 

function EAiActionParamType         GetPType( EAiActionParamId pid )                                    { return mParamType[pid]; }
function                            SetPType( EAiActionParamId pid, EAiActionParamType ptype )          { mParamType[pid] = ptype; }
function H7Unit                     GetUnit( EAiActionParamId pid )                                     { return mUnit[pid]; }
function                            SetUnit( EAiActionParamId pid, H7Unit unit )                        { mUnit[pid] = unit; SetPType(pid,AP_UNIT); }
function H7CombatMapCell            GetCMapCell( EAiActionParamId pid )                                 { return mCMapCell[pid]; }
function                            SetCMapCell( EAiActionParamId pid, H7CombatMapCell cell )           { mCMapCell[pid] = cell; SetPType(pid,AP_CMAPCELL); }
function H7AdventureMapCell         GetAMapCell( EAiActionParamId pid )                                 { return mAMapCell[pid]; }
function                            SetAMapCell( EAiActionParamId pid, H7AdventureMapCell cell )        { mAMapCell[pid] = cell; SetPType(pid,AP_AMAPCELL); }
function H7CombatArmy               GetCombatArmy( EAiActionParamId pid )                               { return mCombatArmy[pid]; }
function                            SetCombatArmy( EAiActionParamId pid, H7CombatArmy army )            { mCombatArmy[pid] = army; SetPType(pid,AP_COMBATARMY); }
function H7AdventureArmy            GetAdventureArmy( EAiActionParamId pid )                            { return mAdventureArmy[pid]; }
function                            SetAdventureArmy( EAiActionParamId pid, H7AdventureArmy army )      { mAdventureArmy[pid] = army; SetPType(pid,AP_ADVENTUREARMY); }
function H7VisitableSite            GetVisSite( EAiActionParamId pid )                                  { return mVisSite[pid]; }
function                            SetVisSite( EAiActionParamId pid, H7VisitableSite site )            { mVisSite[pid] = site; SetPType(pid,AP_VISSITE); }
function H7Player                   GetPlayer( EAiActionParamId pid )                                   { return mPlayer[pid]; }
function                            SetPlayer( EAiActionParamId pid, H7Player player )                  { mPlayer[pid] = player; SetPType(pid,AP_PLAYER); } 
function H7TownBuilding             GetTownBuilding( EAiActionParamId pid )                             { return mBuilding[pid]; }
function                            SetTownBuilding( EAiActionParamId pid, H7TownBuilding build )       { mBuilding[pid] = build; SetPType(pid,AP_BUILDING); }
function H7BaseAbility              GetAbility( EAiActionParamId pid )                                  { return mAbility[pid]; }
function                            SetAbility( EAiActionParamId pid, H7BaseAbility ability )           { mAbility[pid] = ability; SetPType(pid,AP_ABILITY); }
function H7Teleporter               GetTeleporter( EAiActionParamId pid )                               { return mTeleporter[pid]; }
function                            SetTeleporter( EAiActionParamId pid, H7Teleporter tele )            { mTeleporter[pid] = tele; SetPType(pid,AP_TELEPORTER); }
function ResourceStockpile          GetResource( EAiActionParamId pid )                                 { return mResourceStockpile[pid]; }
function                            SetResource( EAiActionParamId pid, ResourceStockpile rs )           { mResourceStockpile[pid] = rs; SetPType(pid,AP_RESOURCE); }
function RecruitHeroData            GetRecruitHeroData( EAiActionParamId pid )                          { return mRecruitHeroData[pid]; }
function                            SetRecruitHeroData( EAiActionParamId pid, RecruitHeroData rhd )     {  mRecruitHeroData[pid] = rhd; SetPType(pid,AP_RECRUIT_HERO_DATA); }
function H7BaseCreatureStack        GetBaseCreatureStack( EAiActionParamId pid )                        { return mBaseCreatureStack[pid]; }
function                            SetBaseCreatureStack( EAiActionParamId pid, H7BaseCreatureStack c ) { mBaseCreatureStack[pid] = c; SetPType(pid,AP_BASECREATURESTACK); }

/// functions
function bool Compare( H7AiActionParam other )
{
	local int pid;
	if(other==None) return false;
	for(pid=0;pid<3;pid++) 
	{
		if(mParamType[pid]!=other.mParamType[pid]) return false;
		switch( mParamType[pid])
		{
			case AP_UNIT:   if(mUnit[pid]!=other.mUnit[pid]) return false;
							break;
			case AP_CMAPCELL: if(mCMapCell[pid]!=other.mCMapCell[pid]) return false;
							break;
			case AP_AMAPCELL: if(mAMapCell[pid]!=other.mAMapCell[pid]) return false;
							break;
			case AP_COMBATARMY: if(mCombatArmy[pid]!=other.mCombatArmy[pid]) return false;
							break;
			case AP_ADVENTUREARMY: if(mAdventureArmy[pid]!=other.mAdventureArmy[pid]) return false;
							break;
			case AP_VISSITE: if(mVisSite[pid]!=other.mVisSite[pid]) return false;
							break;
			case AP_PLAYER: if(mPlayer[pid]!=other.mPlayer[pid]) return false;
							break;
			case AP_BUILDING: if(mBuilding[pid]!=other.mBuilding[pid]) return false;
							break;
			case AP_ABILITY: if(mAbility[pid]!=other.mAbility[pid]) return false;
							break;
			case AP_TELEPORTER: if(mTeleporter[pid]!=other.mTeleporter[pid]) return false;
							break;
			case AP_RESOURCE: if(mResourceStockpile[pid]!=other.mResourceStockpile[pid]) return false;
							break;
			case AP_RECRUIT_HERO_DATA: if(mRecruitHeroData[pid]!=other.mRecruitHeroData[pid]) return false;
							break;
			case AP_BASECREATURESTACK: if(mBaseCreatureStack[pid]!=other.mBaseCreatureStack[pid]) return false;
							break;
		}
	}
	return true;
}

function Copy(H7AiActionParam other)
{
	local int k;
	if(other==None) return;
	for(k=0;k<3;k++)
	{
		mParamType[k]=other.mParamType[k];
		mUnit[k]=other.mUnit[k];
		mCMapCell[k]=other.mCMapCell[k];
		mAMapCell[k]=other.mAMapCell[k];
		mCombatArmy[k]=other.mCombatArmy[k];
		mAdventureArmy[k]=other.mAdventureArmy[k];
		mVisSite[k]=other.mVisSite[k];
		mPlayer[k]=other.mPlayer[k];
		mBuilding[k]=other.mBuilding[k];
		mAbility[k]=other.mAbility[k];
		mTeleporter[k]=other.mTeleporter[k];
		mResourceStockpile[k]=other.mResourceStockpile[k];
		mRecruitHeroData[k]=other.mRecruitHeroData[k];
		mBaseCreatureStack[k]=other.mBaseCreatureStack[k];
	}
}

function String DebugString(EAiActionParamId pid)
{
	local String str;

	str="EMPTY";
	switch( GetPType(pid) )
	{
		case AP_UNIT:   str="UNIT ";
						if(GetUnit(pid)!=None) str=str$GetUnit(pid).GetName(); else str=str$"(none)";
						break;
		case AP_CMAPCELL:   str="CELL ";
						if(GetCMapCell(pid)!=None) str=str$GetCMapCell(pid); else str=str$"(none)";
						break;
		case AP_AMAPCELL:   str="CELL ";
						if(GetAMapCell(pid)!=None) str=str$GetAMapCell(pid); else str=str$"(none)";
						break;
		case AP_COMBATARMY:   str="ARMY ";
						if(GetCombatArmy(pid)!=None) str=str$GetCombatArmy(pid); else str=str$"(none)";
						break;
		case AP_ADVENTUREARMY:   str="ARMY ";
						if(GetAdventureArmy(pid)!=None) str=str$GetAdventureArmy(pid); else str=str$"(none)";
						break;
		case AP_VISSITE:   str="SITE ";
						if(GetVisSite(pid)!=None) str=str$GetVisSite(pid).GetName(); else str=str$"(none)";
						break;
		case AP_PLAYER:   str="PLAYER ";
						if(GetPlayer(pid)!=None) str=str$GetPlayer(pid).GetName(); else str=str$"(none)";
						break;
		case AP_BUILDING:   str="BUILDING ";
						if(GetTownBuilding(pid)!=None) str=str$GetTownBuilding(pid).GetName(); else str=str$"(none)";
						break;
		case AP_ABILITY:   str="ABILITY ";
						if(GetAbility(pid)!=None) str=str$GetAbility(pid).GetName(); else str=str$"(none)";
						break;
		case AP_TELEPORTER: str="TELEPORTER ";
						if(GetTeleporter(pid)!=None) str=str$GetTeleporter(pid).GetName(); else str=str$"(none)";
						break;
		case AP_RESOURCE: str="RESOURCE ";
						if(GetResource(pid).Type!=None) str=str$GetResource(pid).Type.GetName()$","$GetResource(pid).Quantity; else str=str$"(none)";
						break;
		case AP_RECRUIT_HERO_DATA: str="RECRUIT HERO ";
						if(GetRecruitHeroData(pid).Army!=None && GetRecruitHeroData(pid).Army.GetHeroTemplate()!=None) str=str$GetRecruitHeroData(pid).Army.GetHeroTemplate().GetName(); else str=str$"(none)";
						break;
		case AP_BASECREATURESTACK: str="CREATURE STACK ";
						if(GetBaseCreatureStack(pid)!=None) str=GetBaseCreatureStack(pid).GetStackType().GetName(); else str=str$"(none)";
						break;
	}

	return str;
}

function Clear()
{
	local int k;
	for(k=0;k<__APID_NUM;k++)
	{
		mParamType[k]=AP_NOTHING;
		mUnit[k]=None;
		mCMapCell[k]=None;
		mAMapCell[k]=None;
		mCombatArmy[k]=None;
		mAdventureArmy[k]=None;
		mVisSite[k]=None;
		mPlayer[k]=None;
		mBuilding[k]=None;
		mAbility[k]=None;
		mTeleporter[k]=None;
		mResourceStockpile[k].Type=None;
		mResourceStockpile[k].Quantity=0;
		mResourceStockpile[k].Income=0;
		mRecruitHeroData[k].Army=None;
		mRecruitHeroData[k].Cost=0;
		mRecruitHeroData[k].IsAvailable=false;
		mRecruitHeroData[k].IsNew=true;
		mRecruitHeroData[k].RandomHeroesIndex=-1;
		mBaseCreatureStack[k]=None;
	}
}
