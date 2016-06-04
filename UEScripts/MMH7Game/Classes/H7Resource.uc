//=============================================================================
// H7Resource
//=============================================================================
//
// Modifiable resource with name and icon property to represent in-game
// resources in Adventure Map mode and used in storing player resources
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7Resource extends Object
	hidecategories(Object)
	implements(H7IAliasable, H7ILocaParamizable)
	perobjectconfig
	native
	savegame;

// resource name
var(Resource) localized string mResourceName<DisplayName="Name">;
var(Developer) protected string mCustomTooltipKey<DisplayName="Custom Tooltip LocaKey (for Random piles)">;
var protected transient string mNameInst;
//
var(Resource) string mResourceTypeIdentifier<DisplayName=Type Identifier>;
// resource icon
var(Resource) protected Texture2D mResourceIcon<DisplayName=Icon>;

var(Resource) EResourceRank mRank<DisplayName=Resource Rank>;

var(Visuals) protected StaticMeshComponent mMesh<DisplayName=Mesh>;
var(Visuals) protected ParticleSystemComponent mFX<DisplayName=FX>;
var(Visuals) protected DynamicLightEnvironmentComponent mDynamicLightEnv<DisplayName=LightEnvironment>;

var(Audio) protected AKEvent mOnPickUpSound<DisplayName=Pick up sound>;
var(Audio) protected AKEvent mOnGainXPSound<DisplayName=Gain XP sound>;
var(Audio) protected AKEvent mPopUpRequestSound<DisplayName=PopUp request sound>;

var(AI) protected int mAiTradeThresholdNeed<DisplayName=Trade threshold need>;
var(AI) protected int mAiTradeThresholdGreed<DisplayName=Trade threshold greed>;

var(GUI) protected int mGUIPriority<DisplayName=Preferred position in the GUI>;

function String GetEditorName() {return mResourceName;}
function Texture2D GetIcon() { return mResourceIcon; }

function String GetTypeIdentifier() 
{ 
	return mResourceTypeIdentifier;
} 
function string GetCustomTooltipKey() { return mCustomTooltipKey; }
function EResourceRank GetRank() { return mRank; }
function int GetTradeThreshold(bool isNeed) { if(isNeed==true) return mAiTradeThresholdNeed; return mAiTradeThresholdGreed; }
function int GetGUIPriority() { return mGUIPriority; }

function string GetName()
{
	if(class'H7GameUtility'.static.IsArchetype(self))
	{
		LocalizeName();
		return mNameInst;
	}
	else
	{
		return H7Resource(ObjectArchetype).GetName();
	}
}

function string GetIDString() 
{
	if(class'H7GameUtility'.static.IsArchetype(self))
	{
		return String(self);
	}
	else 
	{
		return String(ObjectArchetype);
	}
}

function LocalizeName()
{ 
	if(mNameInst == "") 
	{
		mNameInst = class'H7Loca'.static.LocalizeContent(self, "mResourceName", mResourceName);
	}
}

function String GetIconPath()
{
	return "img://" $ PathName(mResourceIcon);
}

static function int CostResourceCompareGUI( H7ResourceQuantity a, H7ResourceQuantity b )
{
	if( a.Type.GetGUIPriority() > b.Type.GetGUIPriority() ) return -1;
	if( a.Type.GetGUIPriority() < b.Type.GetGUIPriority() ) return 1;
	return 0;
}

native function bool IsEqual(H7Resource resource); // matches

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


