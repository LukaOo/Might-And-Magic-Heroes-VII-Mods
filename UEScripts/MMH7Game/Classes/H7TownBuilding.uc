/*=============================================================================
* H7TownBuilding
* =============================================================================
*  Class for describing buildings that can be built in towns.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownBuilding extends Object
	implements( H7IEffectTargetable, H7IAliasable )
	perobjectconfig
	native
	savegame;

var(Properties) localized string mName<DisplayName=Names>;
var(Properties) localized string mDesc<DisplayName=Description>;
var(Properties) protected bool mIsUnique<DisplayName=Is Unique>;
var(Properties) H7TownBuilding mUpgrade<DisplayName=Upgrade>;
var(Properties) H7TownBuilding mAlternate<DisplayName=Alternate To>;
var(Properties) array<H7TownBuilding> mPrerequisites<DisplayName=Prerequisite Buildings>;
var(Properties) protected int mRequiredLevel<DisplayName=Prerequisite Level|ClampMin=1|ClampMax=30>;
var(Properties) array<H7ResourceQuantity> mCosts<DisplayName=Costs>;
var(Properties) array<H7ResourceQuantity> mProduction<DisplayName=Resource Production>;
var(Properties) dynload H7TownAsset mTownAsset<DisplayName=Primary Town Asset Visual>;
var(Properties) dynload array<H7TownAsset> mTownAssets<DisplayName=Secondary Additional Town Assets Visuals>;
var(Properties) dynload Texture2D mIcon<DisplayName=Icon>;
var(Properties) ETownPopup mPopup<DisplayName=Popup when clicked>;
var(Properties) protected archetype H7BaseAbility mAbility<DisplayName=Ability>;
var(Ai) float mAiBaseUtility;
var protected savegame H7Town mTown;
var protected H7EventManager mEventManager;
var protected savegame H7AbilityManager mAbilityManager;

var protected transient string mNameInst; // all localized strings have to be transient!

function string	GetName()	                                           
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		LocalizeName();
		return mNameInst;
	}
	else
	{
		return H7TownBuilding( ObjectArchetype ).GetName();
	}
}

function LocalizeName()	                                           
{ 
	if( mNameInst == "" ) 
	{
		if( mName == "" )
		{
			mNameInst = "No Name for" @ ObjectArchetype.Name;
		}
		else
		{
			mNameInst = class'H7Loca'.static.LocalizeContent( self, "mName", mName );
		}
	}
}


function SetTown(H7Town town)       { mTown = town; }

native function H7AbilityManager	GetAbilityManager();
native function H7BuffManager		GetBuffManager();
native function H7EventManager      GetEventManager();                       


function H7EffectManager            GetEffectManager()                      { return mTown.GetEffectManager(); }
native function int					GetID();
native function IntPoint            GetGridPosition();
function                            DataChanged(optional String cause)      { mTown.DataChanged( cause ); }
function int GetStackSize()  {} 
function int GetHitPoints()  {}

native function EUnitType           GetEntityType();
native function H7Player            GetPlayer();

native function float                      GetResistanceModifierFor(EAbilitySchool school,array<ESpellTag> tags, optional bool checkOnlyBuffs = false);//   { return 1; }

native function H7Town                     GetTown();
function bool                       IsUnique()      { return mIsUnique; }


simulated function ApplyDamage( H7CombatResult result, int resultIdx, bool isForecast, optional bool isRetaliation = false, optional bool raiseEvent = true ) {}

function TriggerEvents(ETrigger triggerEvent, bool forecast, optional H7EventContainerStruct container) 
{
	if( GetEventManager() != none )
	{
		GetEventManager().Raise( triggerEvent, forecast, container );                       // wtf no words....
	}
	if( GetAbilityManager() != none )
	{
		GetAbilityManager().UpdateAbilityEvents( triggerEvent, forecast, container );       // they should have send a poet
	}
}

function int                        GetPrerequisiteLevel() { return mRequiredLevel; }
function SetPrerequisiteLevel( int level ) { mRequiredLevel = level; }

function H7TownAsset GetTownAsset()
{
	if(!IsArchetype())
	{
		return H7TownBuilding(ObjectArchetype).GetTownAsset();
	}
	else
	{
		if(mTownAsset == none)
		{
			self.DynLoadObjectProperty('mTownAsset');
		}
	}
	return mTownAsset;
}

function bool HasTownAssetLoaded()
{
	if(!IsArchetype())
	{
		return H7TownBuilding(ObjectArchetype).HasTownAssetLoaded();
	}
	else
	{
		return mTownAsset != none;
	}
}

function DelTownAsset()
{
	if(!IsArchetype())
	{
		H7TownBuilding(ObjectArchetype).DelTownAsset();
	}
	else if(!class'Engine'.static.IsEditor())
	{
		mTownAsset = none;
	}
}

function String GetFlashIconPath()  
{   
	if(!IsArchetype())
	{
		return H7TownBuilding(ObjectArchetype).GetFlashIconPath();
	}
	else 
	{
		if(mIcon == none)
		{
			self.DynLoadObjectProperty('mIcon');
		}
	}
	return "img://" $ Pathname( mIcon );
}

function DelIcon()
{
	if(!IsArchetype())
	{
		H7TownBuilding(ObjectArchetype).DelIcon();
	}
	else if(!class'Engine'.static.IsEditor())
	{
		mIcon = none;
	}
}

function array<H7TownAsset> GetTownAssets()
{
	if(!IsArchetype())
	{
		return H7TownBuilding(ObjectArchetype).GetTownAssets();
	}
	else
	{
		if(mTownAssets.Length > 0 && mTownAssets[0] == none)
		{
			self.DynLoadObjectArrayProperty('mTownAssets');
		}
	}
	return mTownAssets;
}

function bool HasTownAssetsLoaded()
{
	if(!IsArchetype())
	{
		return H7TownBuilding(ObjectArchetype).HasTownAssetsLoaded();
	}
	else
	{
		return mTownAssets.Length == 0 || mTownAssets[0] != none;
	}
}

function DelTownAssets()
{
	local int i;
	if(!IsArchetype())
	{
		H7TownBuilding(ObjectArchetype).DelTownAssets();
	}
	else if(!class'Engine'.static.IsEditor())
	{
		for(i=0;i<mTownAssets.Length;i++)
		{
			mTownAssets[i] = none;
		}
	}
}

function string                     GetDesc() { return GetArchetypeDescription(); }

function string GetArchetypeDescription()
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		return class'H7Loca'.static.LocalizeContent(self, "mDesc", mDesc );
	}
	else
	{
		return H7TownBuilding( ObjectArchetype ).GetArchetypeDescription();
	}
}
function array<H7ResourceQuantity>  GetCost(optional H7Town town)
{
	local float modifier;
	local H7ResourceQuantity cost;
	local H7ResourceQuantity costModifier;
	local array<H7ResourceQuantity> finalQuantity;
	local H7Player player;

	if(mTown!=None)
	{
		player = mTown.GetPlayer();
		modifier = mTown.GetBuildingCostModifier();
	}
	else if(town!=None)
	{
		player = town.GetPlayer();
		modifier = town.GetBuildingCostModifier();
	}
	else
	{
		modifier = 1.0f;
	}
	
	foreach mCosts( cost )
	{
		
		if( player != none && cost.Type == player.GetResourceSet().GetCurrencyResourceType() )
		{
			costModifier.Quantity = Round( cost.Quantity * modifier);
		}
		else 
		{
			costModifier.Quantity = Round( cost.Quantity );
		}
		costModifier.Type = cost.Type;
		finalQuantity.AddItem(costModifier);
		
	}

	finalQuantity.Sort( CostResourceCompareGUI );

	return finalQuantity;
}

function OnBeginDay() {}

function int CostResourceCompareGUI( H7ResourceQuantity a, H7ResourceQuantity b )
{
	if( a.Type.GetGUIPriority() > b.Type.GetGUIPriority() ) return -1;
	if( a.Type.GetGUIPriority() < b.Type.GetGUIPriority() ) return 1;
	return 0;
}

function H7TownBuilding             GetUpgrade()    {   return mUpgrade; }
function H7TownBuilding             GetAlternate()  {   return mAlternate;}
function ETownPopup                 GetPopup()      {   return mPopup;}

function array<H7ResourceQuantity>  GetIncome()     {   return mProduction; }
function bool ShouldDisplayIncome()                 { return true; }

function array<H7TownBuilding>      GetPrerequisites()  {   return mPrerequisites; }


function String                     GetFlashInfoIconPath(bool build)  
{
	return build ? "img://" $ Pathname( Texture2D'H7TextureGUI.Town_full' ) : "img://" $ Pathname( Texture2D'H7TextureGUI.Town_buildable' );
}
function string GetIDString() 
{
	if(IsArchetype()) return String(self);
	else return String(ObjectArchetype);
}
function bool IsArchetype()
{
	return class'H7GameUtility'.static.IsArchetype(self);
}

function InitTownBuilding( H7Town town )
{
	;
	mTown = town;
	mEventManager = new(self) class'H7EventManager';
	mAbilityManager = new(self) class'H7AbilityManager';
	mAbilityManager.SetOwner( self );
}

function float                      GetBuildingBaseUtility() { return mAiBaseUtility; }

native function int GetIncomeForResource( H7Resource resource );

function JsonObject Serialize()
{
	local JSonObject JSonObject;
	
	// Instance the JSonObject, abort if one could not be created
	JSonObject = new () class'JSonObject';
	if (JSonObject == None)
	{
		;
	}

	// Send the encoded JSonObject
	return JSonObject;
}

function Deserialize(JsonObject data)
{
	
}

function H7TownBuilding GetAlternateBothways(H7Town town)  
{   
	local array<H7TownBuildingData> allAvaliableBuildings;
	local H7TownBuildingData entry;

	// me -> alternate
	if(mAlternate != none) return mAlternate;

	// alternate -> me
	allAvaliableBuildings = town.GetBuildingTree();
	foreach allAvaliableBuildings(entry)
	{
		if(entry.Building != none && town.IsBuildingEqual(entry.Building.GetAlternate(),self)) 
		{
			return entry.Building;
		}
	}

	return none;
}

public function H7BaseAbility GetAbility() { return mAbility; }

event PostSerialize()
{
	if(!IsArchetype())
	{
		mEventManager = new(self) class'H7EventManager';
		
		if(mAbility != none && mTown != none)
		{
			if(!mTown.GetAbilityManager().HasAbility(mAbility))
			{
				mTown.GetAbilityManager().LearnAbility( mAbility );
			}

			if(mAbility.IsAura())
			{
				mTown.GetAbilityManager().GetAbility(mAbility).GetEventManager().Raise( ON_BUILDING_BUILT, false );
				mTown.GetEntranceCell().GetGridOwner().GetAuraManager().UpdateAuras();
			}
			
		}
	}
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
