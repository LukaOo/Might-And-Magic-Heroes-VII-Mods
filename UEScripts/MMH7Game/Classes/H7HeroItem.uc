//=============================================================================
// H7HeroItem
//
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7HeroItem extends H7EffectContainer
	implements(H7IThumbnailable, H7ILocaParamizable)
	native
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement/*,Display*/)
	showcategories(Display)
	savegame;

/** The type of the artifact */
var(Artifact) protected EItemType mType<DisplayName=Item Type>;
/** The tier of the artifact */
var(Artifact) protected ETier mTier<DisplayName=Artifact Tier>;
/** The set the artifact belongs to */
var(Artifact) protected H7ItemSet mSet<DisplayName=Part of the Set:>; // double linked list set<->items

var(Artifact) protected bool mIsStackable<DisplayName= is stackable>;

var(Artifact) protected bool mCannotUnequip<DisplayName=Cannot unequip after being equipped>;

/** The selling price of this artifact */
var(Artifact) protected int mSellPrice<DisplayName=Sell Price>;
/** The buy price of this artifact */
var(Artifact) protected int mBuyPrice<DisplayName=Buy Price>;

/** Should this object be carried over from previous map in campaign **/
var(Artifact) protected bool mIsCampaignPersistent<DisplayName=Is Campaign Persistent>;
/** Is this item part of 'Artifact Pack' UPlay reward **/
var(Artifact) protected bool mIsUPlayReward<DisplayName=Is UPlay Reward>;

/** Story items  cannot be sold or destroyed or stolen. They can still be exchanged between friendly heroes */
var(Artifact) protected bool mIsStoryitem<DisplayName="Story Item">;
/** Can this artifact be exchanged between friendly heroes? */
var(Artifact) protected bool mIsExchangeable<DisplayName="Can be exchanged">;

/** The factions that cannot use this artifact */
var(Artifact) protected archetype array<H7Faction> mForbiddenFactions<DisplayName=Forbidden Factions>;
/** The affinity that forbids using this artifact */
var(Artifact) protected array<EAttackType> mForbiddenAffinity<DisplayName=Forbidden Affinities>;
/** The ability that this artifact provides */
var(Artifact) protected archetype array<H7BaseAbility> mImprintedAbilities<DisplayName=Imprinted Abilities>;

var protected savegame int  mID;
var protected savegame bool mIsEquipped;

var(Visuals) protected StaticMeshComponent mMesh<DisplayName=Mesh>;
var(Visuals) protected ParticleSystemComponent mFX<DisplayName=FX>;
var(Visuals) protected DynamicLightEnvironmentComponent mDynamicLightEnv<DisplayName=LightEnvironment>;
var(Visuals) protected Texture2D  mMinimapIcon<DisplayName=Icon Minimap>;
var(Audio) protected AkEvent mOnPickUpSound<DisplayName=Item pick up sound>;
var(AI) protected float mPowerValueMight<DisplayName=Might Power Value>;   // power of item for autoequip might heroes
var(AI) protected float mPowerValueMagic<DisplayName=Magic Power Value>;   // power of item for autoequip magic heroes

// used by custom artefacts
struct native CustomArtefactBonusEffectInfo
{
	var string effectId;
	var int groupId;
	var int bonusIndex;
	var string tooltip;
};

var protected array<CustomArtefactBonusEffectInfo> mCustomBonusEffectInfo;
var(Dev) bool mIgnoreCustomBonusEffectInfo<DisplayName="Don't use generated tooltip for bonus effects">;

function EItemType  GetType()           { return mType; }
function String     GetTypeLoca()       { return class'H7Loca'.static.LocalizeSave(String(mType),"H7ItemAndInventory"); }
native function int GetID();			  
function ETier      GetTier()           { return mTier; }
function int        GetBuyPrice()       { return mBuyPrice; }
function int        GetSellPrice()      { return mSellPrice; }
function array<H7BaseAbility> GetImprintedAbilities() { return mImprintedAbilities; }
function H7ItemSet  GetItemSet()        { return mSet; }
function float      GetPowerValueMight()     { return mPowerValueMight; }
function float      GetPowerValueMagic()     { return mPowerValueMagic; }
function bool       CannotUnequip()     { return mCannotUnequip; }

function bool IsStackable()             { return mIsStackable; }
function bool IsExchangeable()          { return mIsExchangeable; }
function bool IsEquipped()              { return mIsEquipped; }
function bool IsCampaignPersistent()    { return mIsCampaignPersistent; }
function bool IsUPlayReward()           { return mIsUPlayReward; }
function bool IsStoryItem()             { return mIsStoryitem; }

function String     GetFlashIconPath()  { return "img://" $ PathName( GetIcon() ); }

native function TriggerEvents(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container);


function string GetTierColorHTML(optional bool considerQuestItemColor=true)
{
	local Color nameColor;

	if(IsStoryItem() && considerQuestItemColor) nameColor = class'H7TextColors'.static.GetInstance().mQuestItemColor; // gold
	else if(GetTier() == ITIER_CONSUMABLE || GetType() == ITYPE_CONSUMABLE) nameColor = class'H7TextColors'.static.GetInstance().mTierColors[ITIER_CONSUMABLE]; // beige
	else if(GetTier() == ITIER_MINOR) nameColor = class'H7TextColors'.static.GetInstance().mTierColors[ITIER_MINOR]; //turquis
	else if(GetTier() == ITIER_MAJOR) nameColor = class'H7TextColors'.static.GetInstance().mTierColors[ITIER_MAJOR]; //blue
	else if(GetTier() == ITIER_RELIC) nameColor = class'H7TextColors'.static.GetInstance().mTierColors[ITIER_RELIC]; //purple
	else nameColor = MakeColor(200,200,200,255);

	return class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(nameColor);
}

function string GetColoredName()
{
	return "<font color='" $ GetTierColorHTML() $ "'>" $ super.GetName() $ "</font>";
}

function SetEquipped( bool val, H7EditorHero owningHero ) 
{
	mIsEquipped = val;
	SetOwner( owningHero );
}

function Consume()
{
	if( mType == ITYPE_CONSUMABLE )
	{
		if( CanConsume() )
		{
			mOwner.GetEventManager().Raise( ON_CONSUME_ITEM, false );
			GetEventManager().Raise( ON_CONSUME_ITEM, false );
			H7EditorHero( mOwner ).GetInventory().RemoveItem( self );
			H7EditorHero( mOwner ).DataChanged();
			MarkForKill();
		}
	}
	else
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("Tried to consume non-consumable item"@self@GetName(),MD_QA_LOG);;
	}
}

function bool CanConsume()
{
	if( H7EditorHero( mOwner ) != none && !TargetIsImmuneToAllExecutingEffects( H7EditorHero( mOwner ) ) )
	{
		return true;
	}
	return false;
}

native function MarkForKill();

function bool       IsHeroItem()        { return true; }

event bool       CheckRestricted(H7AdventureHero currentHero)
{
	local H7Faction   faction;
	local EAttackType affinity;
	foreach mForbiddenFactions(faction)
	{
		if(faction == currentHero.GetFaction())
		{ ; return true;}
	}
	foreach mForbiddenAffinity(affinity)
	{
		if(affinity == currentHero.GetAttackType()) 
		{ ; return true;}
	}
	
	return false;
}

static event H7HeroItem CreateItem( H7HeroItem itemArchetype, optional int overwriteId )
{
	local H7HeroItem item;

	if( itemArchetype == none )
	{
		return none;
	}

	if(!itemArchetype.IsArchetype())
	{
		return itemArchetype;
	}

	item = new() class'H7HeroItem'(itemArchetype);
	
	item.Init(overwriteId);

	return item;
}

function Init(optional int overwriteId)
{
	mID = overwriteId > 0 ? overwriteId : class'H7ReplicationInfo'.static.GetInstance().GetNewID();
	class'H7ReplicationInfo'.static.GetInstance().RegisterEventManageable( self );
	mIsEquipped = false;

	// instanciate all effects
	InstanciateEffectsFromStructData();
}
// where to call this?
//class'H7ReplicationInfo'.static.GetInstance().UnregisterEventManageable( self );

function String GetTooltipForOwner(H7EditorHero hero, optional bool extendedVersion,optional string overwriteBaseString,optional ESkillRank considerOnlyEffectsOfRank=SR_ALL_RANKS)
{
	local H7HeroItem tmpItem;
	local H7ICaster prevOwner;
	local string tt;

	if(IsArchetype())
	{
		tmpItem = new self.Class(self);
		if(hero != none) tmpItem.SetOwner(hero);
		tt = tmpItem.GetTooltip(extendedVersion, overwriteBaseString, considerOnlyEffectsOfRank);
	}
	else
	{
		prevOwner = mOwner;
		mOwner = hero;
		tt = GetTooltip(extendedVersion, overwriteBaseString, considerOnlyEffectsOfRank);
	}
	mOwner = prevOwner;
	return tt;
}

// returns normal tooltip combined with custom artefact tooltips (only init once)
function string	GetTooltipLocalized( H7ICaster initiator )	                                           
{
	local int bonusEffectIdx;
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		if( mTooltipLocalized == "")
		{
			mTooltipLocalized = class'H7Loca'.static.LocalizeContent( self, "mTooltip", mTooltip );

			if (mCustomBonusEffectInfo.Length > 0 && !mIgnoreCustomBonusEffectInfo)
			{
				mTooltipLocalized = mTooltipLocalized $ "\n";
				for (bonusEffectIdx = 0; bonusEffectIdx < mCustomBonusEffectInfo.Length; bonusEffectIdx++)
				{
					mTooltipLocalized = mTooltipLocalized $ mCustomBonusEffectInfo[bonusEffectIdx].tooltip $ "\n";
				}
				mCustomBonusEffectInfo.Length = 0;
			}

			mTooltipLocalized = ApplyHelperReplacements(mTooltipLocalized);
		}
		return mTooltipLocalized;
	}
	else
	{
		return H7EffectContainer( ObjectArchetype ).GetTooltipLocalized( initiator );
	}
}

// item tooltip is 3 parts:
// main tooltip (name,desc)
// set tooltip (set name, set items, set boni)
// info tooltip (equip info,exchange info, campaign info)
function string GetTooltip(optional bool extendedVersion,optional string overwriteBaseString,optional ESkillRank considerOnlyEffectsOfRank=SR_ALL_RANKS, optional bool resetRankOverride = true)
{
	local String tooltip,matchColor;
	local H7Faction faction;
	local EAttackType affinity;
	local H7BaseAbility ability;
	local bool canBeEquipped;
	local H7AdventureHero ghostHero; //can be either, if item is in inventory or placed on the map
	local array<H7SpellEffect> spells;
	local int i;

	if(GetOwner() != none)
	{
		ghostHero = H7AdventureHero(mOwner); //tooltip from artifact in herowindow
	}
	else
	{
		if( class'H7AdventureController'.static.GetInstance().GetSelectedArmy() != none )
		{
			ghostHero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero(); //tooltip from artifact on map (assuming there's a selected army)
			if(ghostHero == none)
			{
				class'H7AdventureController'.static.GetInstance().AutoSelectArmy();
				ghostHero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
			}
		}
	}

	if(GetType() == ITYPE_SCROLL && extendedVersion) // the extended tooltip of scroll is the normal tooltip of the spell
	{
		spells = GetSpellEffects();
		return H7HeroAbility(spells[0].mSpellStruct.mSpell).GetTooltipForCaster(ghostHero) $ "-SPLITTOOLTIPHERE-";
	}

	canBeEquipped = (mType != ITYPE_INVENTORY_ONLY);

	// main tooltip
	tooltip = super.GetTooltip(extendedVersion) $ "\n";
	// main tooltip

	if(mImprintedAbilities.Length > 0)
	{
		tooltip = tooltip $ "\n <font size='#TT_POINT#'>" $ class'H7Loca'.static.LocalizeSave("TT_GRANT_ABILITY","H7HeroItem");
		foreach mImprintedAbilities(ability)
		{
			if( mOwner != none )
			{
				ability.SetOwner(ghostHero);
			}
			tooltip = tooltip $ "<li>" $ ability.GetName();
			if(extendedVersion)
			{
				tooltip = tooltip $ "\n<font size='#TT_DESCRIPTION#'>" $ ability.GetTooltip() $ "</font>";
			}
			
			if(ability.IsArchetype())
			{
				ability.SetOwner(none);
			}
		}
		tooltip = tooltip $ "</font>";
	}
	/*
	if(extendedVersion)
	{
		tooltip = tooltip $ "-SPLITTOOLTIPHERE-";
	}

	if(mSet != none)
	{
		mSet.SetOwner(ghostHero);
		
		tooltip = tooltip $ "\n<font size='#TT_DESCRIPTION#'>";
		if(extendedVersion)
		{
			tooltip = tooltip $ "\n" $ mSet.GetTooltip();
		}
		else
		{
			tooltip = tooltip $ "\n" $ mSet.GetName() $ "\n"; //mSet.GetTooltip() already contains Set-name, so append name if it's not extended
		}

		if(mSet.IsArchetype()) mSet.SetOwner(none);
		tooltip = tooltip $ "</font>";
	}
	*/
	tooltip = tooltip $ "-SPLITTOOLTIPHERE-";

	// basic:
	// set name
	// equip info

	// extend:
	// set name
	// equip table
	// equip info
	// campaign
	// exchangable
	// consume (flash)
	// not unequip (flash)
	
	if(mIsStoryitem)
	{
		matchColor = class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.UnrealColorToHTMLColor(class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.mQuestItemColor);
		tooltip = tooltip $ "<font color='" $ matchColor $ "' size='#TT_POINT#'>" $ class'H7Loca'.static.LocalizeSave("TT_QUEST_ITEM","H7HeroItem") $ "</font>\n";
	}

	// matchColor set to red because forbidden faction/affinity should always be red
	if(mForbiddenFactions.Length > 0)
	{
		if(extendedVersion) tooltip = tooltip $ "<font size='#TT_DESCRIPTION#'>" $ class'H7Loca'.static.LocalizeSave("TT_FORBIDDEN_FACTION","H7HeroItem") $ "<li>";
		foreach mForbiddenFactions(faction,i)
		{
			matchColor = "ff0000";
			if(extendedVersion) tooltip = tooltip $ "<font color='#" $ matchColor $ "'>" $ faction.GetName() $ "</font>" $ (i+1!=mForbiddenFactions.Length)?", ":"";
			if(ghostHero != none && ghostHero.GetFaction() == faction)
			{
				canBeEquipped = false;
			}
		}
		if(extendedVersion) tooltip = tooltip $ "</li></font>";	
	}

	if(mForbiddenAffinity.Length > 0)
	{
		if(extendedVersion) tooltip = tooltip $ "<font size='#TT_DESCRIPTION#'>" $ class'H7Loca'.static.LocalizeSave("TT_FORBIDDEN_AFFINITY","H7HeroItem");
		foreach mForbiddenAffinity(affinity)
		{
			matchColor = "ff0000";
			if(extendedVersion) tooltip = tooltip $ "<li><font color='#" $ matchColor $ "'>" $ class'H7Loca'.static.LocalizeSave(String(affinity),"H7Combat") $ "</font></li>";
			if(ghostHero != none && ghostHero.GetAttackType() == affinity)
			{
				canBeEquipped = false;
			}
		}
		if(extendedVersion) tooltip = tooltip $ "</font>";
	}

	if(ghostHero != none && mType != ITYPE_SCROLL && mType != ITYPE_CONSUMABLE && !ghostHero.GetEquipment().HasItemEquipped(self,true))
	{
		if(canBeEquipped)
		{
			tooltip = tooltip $ "<font color='#00ff00' size='#TT_POINT#'>" $ class'H7Loca'.static.LocalizeSave("TT_CAN_EQUIP","H7HeroItem") $ "</font>";
		}
		else
		{
			tooltip = tooltip $ "<font color='#ff0000' size='#TT_POINT#'>" $ class'H7Loca'.static.LocalizeSave("TT_CANNOT_EQUIP","H7HeroItem") $ "</font>";
		}
		tooltip = tooltip $ "\n";
	}
	
	if(extendedVersion)
	{
		if(!IsExchangeable())
		{
			tooltip = tooltip $ "<font color='#ff0000' size='#TT_POINT#'>" $ class'H7Loca'.static.LocalizeSave("TT_CANNOT_EXCHANGE","H7HeroItem") $ "</font>\n";
		}

		if(IsCampaignPersistent() && class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMapType() == CAMPAIGN)
		{
			tooltip = tooltip $ "<font color='#ff33ff' size='#TT_POINT#'>" $ class'H7Loca'.static.LocalizeSave("TT_CAMPAIGN_PERSISTENT","H7HeroItem") $ "</font>\n";
		}
	}

	// IsConumable() sentence added in flash
	// IsNotUnequipable() sentance added in flash
	
	// hack to prevent double icons (scaleform doubles icons when they are at the end of a </font> tag
	// <img src='img://H7TextureStatIconsInText.Stat_Might_Defense' width='20' height='20'></FONT>
	// inserting a space helps:
	// <img src='img://H7TextureStatIconsInText.Stat_Might_Defense' width='20' height='20'> </FONT>
	tooltip = Repl(tooltip,"'></FONT>","'> </FONT>");
	// #scaleform_don't_ask

	return tooltip;
}

public event CheckSetitem( ETrigger trigger ) 
{
	local H7AdventureHero ghostHero;
	local int itemCounter;
	local array<H7HeroAbility> abilities;
	local H7HeroAbility ability;

	if( GetItemSet() != none )
	{
		if(GetOwner() != none)
		{
			ghostHero = H7AdventureHero(mOwner);
			itemCounter = ghostHero.GetEquipment().HasSetItemsEquipped( GetItemSet() ) ;

			if( trigger == ON_EQUIP_ITEM ) 
			{
				abilities = GetItemSet().GetSetBonusAbilities( itemCounter + 1 );
			}
			else if( trigger == ON_UNEQUIP_ITEM && mIsEquipped) 
			{
				abilities = GetItemSet().GetSetBonusAbilities( itemCounter - 1 , true ) ;
			}


			foreach abilities(ability)
			{

				if( trigger == ON_EQUIP_ITEM && !ghostHero.GetAbilityManager().HasVolatileAbility( ability ) ) 
					ghostHero.GetAbilityManager().LearnVolatileAbility( ability );

				if( trigger == ON_UNEQUIP_ITEM && mIsEquipped && ghostHero.GetAbilityManager().HasVolatileAbility( ability )) 
					ghostHero.GetAbilityManager().UnlearnVolatileAbility( ability );
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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

