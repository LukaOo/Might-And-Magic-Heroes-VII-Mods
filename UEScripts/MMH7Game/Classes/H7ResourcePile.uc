//=============================================================================
// H7ResourcePile
//=============================================================================
// Represents a pile of resources that can be collected from the adventure map.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ResourcePile extends H7VisitableSite implements(H7IPickable, H7ITooltipable, H7IHideable)
	native
	dependson(H7IPickable,H7ITooltipable, H7StructsAndEnumsNative)
	placeable
	hidecategories(Visuals, SkeletalMeshActor, Properties)
	savegame;

/** Resources contained in this pile */
var(Developer) protected savegame array<H7ResourceQuantity> mResourceGains<DisplayName="Resource Gains">;
/** Experience points contained in this pile */
var(Developer) protected savegame int mExp<DisplayName="Exp Gain"|ClampMin=1>;
/** This pile is handled as a chest */
var(Developer) protected savegame bool mIsChest<DisplayName="Is Chest">;

var(Developer) savegame bool mUseContainerMesh;
var(Developer) savegame protected H7Resource mContainerResource<DisplayName="Container Resource Visuals" | EditCondition=mUseContainerMesh>;

var(Audio) protected AkEvent mOnPickUpSound<DisplayName=Pick up sound>;
var(Audio) protected AkEvent mOnGainXPSound<DisplayName=Gain XP sound>;
var(Audio) protected AkEvent mPopUpRequestSound<DisplayName=PopUp request sound>;

var protected savegame bool mLooted;

var protected savegame bool mIsHidden;

// Minimal this amount of resources will be granted on picking this object.
var(Random) bool    mUseRandom<DisplayName="Use Random">;

native function bool IsHiddenX();
function native UpdateProperties();

function AddResource( H7Resource resource, int quantity ) 
{ 
	local int idx;

	quantity = Max( 0, quantity );

	mResourceGains.Add(1);
	idx = mResourceGains.Length-1;

	mResourceGains[idx].Type = resource;
	mResourceGains[idx].Quantity = quantity;
}

function bool UseContainerMesh() { return mUseContainerMesh; }
function SetUseContainerMesh( bool useContainerMesh ) { mUseContainerMesh = useContainerMesh; }

function H7Resource GetContainerResource() { return mContainerResource; }
function SetContainerResource( H7Resource resource ) { mContainerResource = resource; }

function AkEvent GetGainXPSound() {return mOnGainXPSound; }
function AkEvent GetPickUpSound() {return mOnPickUpSound; }

function bool IsLooted() { return mLooted; }

function bool SpendPickupCostsOnVisit(H7AdventureHero visitingHero) { return true; }

function SetIsChest( bool isChest ) { mIsChest = isChest; }
function SetXP( int xp ) 
{ 
	mExp = Max( 0, xp ); 
}

function bool IsChest()     { return mIsChest; }
function int  GetExp()      { return mExp; }

event InitAdventureObject()
{
	local int i;
	super.InitAdventureObject();

	UpdateProperties();

	if( mLooted )
	{
		DestroySecure();
	}

	if( mUseRandom && !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		for( i = 0; i < mResourceGains.Length; ++i  )
		{
			mResourceGains[i].Quantity = ( mResourceGains[i].RandomQuantityMin + class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mResourceGains[i].RandomQuantityMax - mResourceGains[i].RandomQuantityMin + 1 ) ) * mResourceGains[i].RandomQuantityMultiplier;
		}
	}
}

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit( hero );

	if( !IsChest() )
	{
		hero.UseMovementPoints(hero.GetModifiedStatByID(STAT_PICKUP_COST));

		PickUp( hero );
	}
	else
	{
		hero.TriggerEvents( ON_OPEN_CHEST, false );

		if( hero.GetPlayer().IsControlledByAI() )
		{
			hero.UseMovementPoints(hero.GetModifiedStatByID(STAT_PICKUP_COST));

			if( hero.GetAiRole() == HRL_GENERAL || hero.GetAiRole() == HRL_MAIN || hero.GetAiRole() == HRL_SECONDARY )
			{
				PickUpXP(hero);
			}
			else
			{
				PickUpGold(hero);
			}
		}
		else
		{
			if( hero.GetPlayer().IsControlledByLocalPlayer() )
			{
				PickUpRequested();
			}
		}
	}
}

function array<H7Resource> GetResources() 
{
	local array<H7Resource> resources;
	local H7ResourceQuantity currentResource;

	foreach mResourceGains( currentResource )
	{
		resources.AddItem( currentResource.Type );
	}

	return resources;
}

function array<int> GetResourceAmounts() 
{
	local array<int> amounts;
	local H7ResourceQuantity currentResource;

	foreach mResourceGains( currentResource )
	{
		amounts.AddItem( currentResource.Quantity );
	}

	return amounts;
}

function PickUpXP(H7AdventureHero hero )
{
	PickUp( hero, LOOT_TYPE_EXP, true );
}

function PickUpGold(H7AdventureHero hero )
{
	PickUp( hero, LOOT_TYPE_GOLD, true );
}

// only for local player, involved GUI
function PickUpRequested()
{
	local H7Player lootingPlayer;
	local string question;
	local string button1,button2;
	local int exp; 

	lootingPlayer = class'H7AdventureController'.static.GetInstance().GetLocalPlayer();
	if(mIsChest)
	{
		exp = int( mExp * (1 + class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetAddBoniOnStatByID(STAT_XP_RATE)) * class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetMultiBoniOnStatByID(STAT_XP_RATE));
		question = class'H7Loca'.static.LocalizeSave("REQ_GOLDORXP","H7Adventure");
		question = Repl(question,"%gold",GetGoldGain(lootingPlayer,IsChest()));
		question = Repl(question,"%icon_gold",class'H7GUIGeneralProperties'.static.GetInstance().GetCurrencyIconHTML());
		question = Repl(question,"%xp",exp);
		question = Repl(question,"%icon_xp",class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(STAT_XP_RATE));
		question = class'H7Loca'.static.ResolveIconPlaceholders(question);

		button1 = Repl(Repl(class'H7Loca'.static.LocalizeSave("REQ_GOLD","H7Adventure"),"%amount",GetGoldGain(lootingPlayer,IsChest())),"%icon_gold",class'H7GUIGeneralProperties'.static.GetInstance().GetCurrencyIconHTML());
		button1 = class'H7Loca'.static.ResolveIconPlaceholders(button1);

		button2 = Repl(Repl(class'H7Loca'.static.LocalizeSave("REQ_XP","H7Adventure"),"%amount",exp),"%icon_xp",class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(STAT_XP_RATE));
		button2 = class'H7Loca'.static.ResolveIconPlaceholders(button2);

		class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().YesNoPopup(
			question,
			button1,
			button2,
			PickUpGoldChosen,PickUpXPChosen,true, ClosePopupChosen
		);

		if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero().GetLevel() 
			>= class'H7AdventureController'.static.GetInstance().GetMapInfo().GetMaxHeroLevelForPlayer( lootingPlayer.GetPlayerNumber() ) )
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().GetRequestPopupCntl().GetRequestPopup().SetNoButtonState(false,"PU_MAX_LEVEL_REACHED");
		}

		if(mPopUpRequestSound!=None)
		{
			class'H7SoundManager'.static.PlayAkEventOnActor(self,mPopUpRequestSound,true,true,self.Location);
		}
	}
	else
	{
		;
	}
}

function PickUpGoldChosen()
{
	local H7AdventureHero hero;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	hero.UseMovementPoints(hero.GetModifiedStatByID(STAT_PICKUP_COST));
	PickUp( hero, LOOT_TYPE_GOLD, true );
	
	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendInteractionFinished( hero.GetID() );
	}

	
	hero.TriggerEvents( ON_CLOSE_CHEST, false );
}

function PickUpXPChosen()
{
	local H7AdventureHero hero;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();
	hero.UseMovementPoints(hero.GetModifiedStatByID(STAT_PICKUP_COST));
	PickUp( hero, LOOT_TYPE_EXP, true );

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendInteractionFinished( hero.GetID() );
	}

	hero.TriggerEvents( ON_CLOSE_CHEST, false );
}

function ClosePopupChosen()
{
	local H7AdventureHero hero;

	hero = class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero();

	if( class'WorldInfo'.static.GetWorldInfo().GRI.IsMultiplayerGame() && class'H7ReplicationInfo'.static.GetInstance().IsSimTurns() )
	{
		class'H7AdventurePlayerController'.static.GetAdventurePlayerController().SendInteractionFinished( hero.GetID() );
	}
}

function PickUp( H7AdventureHero lootingHero, optional ELootType lootType = LOOT_TYPE_MAX, optional bool doMultiplayerSynchro = false ) 
{
	local H7Player player;
	local H7ResourceQuantity currentResource;
	local Vector floatLocation;
	local H7InstantCommandHeroAddXp xpCommand;
	local H7InstantCommandIncreaseResource resCommand;
	
	floatLocation = self.Location; //GetHeightPos( 50.f );

	// TODO more security checks? with which hero? Is the hero next to it? sim-turn conflicts? ...?
	if(mLooted)
	{
		;
		return;
	}

	player = lootingHero.GetPlayer();

	if(mOnPickUpSound!=None)
	{
		class'H7SoundManager'.static.PlayAkEventOnActor(self,mOnPickUpSound,true,true,self.Location);
	}

	if( lootType == LOOT_TYPE_MAX )
	{
		foreach mResourceGains( currentResource )
		{
			player.GetResourceSet().ModifyResource( currentResource.Type, currentResource.Quantity, true );
			
			if( player.GetResourceSet().GetResource( currentResource.Type ) != INDEX_NONE ) 
			{
				class'H7FCTController'.static.GetInstance().StartFCT(FCT_RESOURCE_PICKUP, floatLocation, lootingHero.GetPlayer(), "+"$currentResource.Quantity , MakeColor(0,255,0,255) , currentResource.Type.GetIcon() );
			}
		}
	}
	else if( lootType == LOOT_TYPE_GOLD )
	{
		if(!lootingHero.IsControlledByAI() || class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
		{
			resCommand = new class'H7InstantCommandIncreaseResource';
			resCommand.Init(player, player.GetResourceSet().GetCurrencyResourceType().GetIDString(), GetGoldGain( player, IsChest()), self );
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( resCommand );
		}
	}
	else // XP
	{
		if(!lootingHero.IsControlledByAI() || class'H7AdventureController'.static.GetInstance().GetAI().IsAiEnabled())
		{
			xpCommand = new class'H7InstantCommandHeroAddXp';
			xpCommand.Init( class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero(), mExp , self );
			class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( xpCommand );
		}
	}
	DestroySecure();
	class'H7ReplicationInfo'.static.GetInstance().IncGameStateCounter();
}

function DestroySecure()
{
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell cell;
	local H7AdventureController advController;

	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	advController = class'H7AdventureController'.static.GetInstance();

	//class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons(player.GetResourceSet().GetAllResourcesAsArray());

	mLooted = true;
	advController.RemoveAdvObject( self );
	gridManager.RemoveVisitableSite(Self);
	// remove object from cell and get rid of the actor itself 
	cell = gridManager.GetCellByWorldLocation( Location );
	cell.SetVisitableSite( none );
	cell.SetHasPickable( false );
	if( cell.mIsDeepWater )
	{
		cell.SetMovementType( MOVTYPE_WATER );
	}
	else
	{
		cell.SetMovementType( MOVTYPE_GROUND );
	}
	SetHidden(true);
	SetCollisionType( COLLIDE_NoCollision );
}

function protected string GetModifierString(H7Player looterPlayer)
{
	local string effectNames;
	local H7AdventureArmy army;
	local array<H7EffectContainer> effects;
	local int i, goldGain, goldGainDif;

	army = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();

	if( army == none ) return "";
	
	effects = army.GetHero().GetEffectContainerForStat( STAT_GOLDGAIN_CHEST );

	for( i = 0; i < effects.Length; ++i )
	{
		if( effectNames != "" )
		{
			effectNames = effectNames $ ", ";
		}
		effectNames = effectNames $ effects[i].GetName();
	}

	goldGain = GetGoldGain(looterPlayer);
	goldGainDif = FFloor( ( goldGain * army.GetHero().GetModifiedStatByID( STAT_GOLDGAIN_CHEST ) ) - goldGain );

	if( goldGainDif <= 0 )
	{
		return "";
	}

	return " +"@ goldGainDif @ effectNames;
}

function int GetGoldGain( H7Player looterPlayer, optional bool modified = false )
{
	local int i, value;
	local H7Resource currency;
	local H7AdventureArmy army;

	value = 0;

	currency = looterPlayer.GetResourceSet().GetCurrencyResourceType();
	army = class'H7AdventureController'.static.GetInstance().GetSelectedArmy();

	for( i = 0; i < mResourceGains.Length; ++i )
	{
		if( mResourceGains[i].Type.IsEqual( currency ) )
		{
			value += mResourceGains[i].Quantity;
		}
	}

	if( army != none && modified )
	{
		return value * army.GetHero().GetModifiedStatByID( STAT_GOLDGAIN_CHEST );
	}

	return value;
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local H7ResourceQuantity currentResource;

	data.type = TT_TYPE_STRING;

	if(!mIsChest)
	{
		//data.Title = `Localize("H7ResourcePile", "TT_Pile", "MMH7Game");
		data.Title = GetName();

		data.Description = "<font size='#TT_BODY#'>";
		if(mCustomTooltipKey != "")
		{
			data.Description = data.Description $ class'H7Loca'.static.LocalizeSave(mCustomTooltipKey,"H7AdvMapObjectToolTip") $ "\n";
		}
		else
		{
			foreach mResourceGains( currentResource )
			{
				data.Description = data.Description $ currentResource.Type.GetName() $ ":" @ currentResource.Quantity $ "\n";
			}
		}
		data.Description = data.Description $ "</font>";
	}
	else
	{
		data.Title = class'H7Loca'.static.LocalizeSave("TT_CHEST","H7ResourcePile");
		
		data.Description = "<font size='#TT_BODY#'>";
		if(mCustomTooltipKey != "")
		{
			data.Description = data.Description $ class'H7Loca'.static.LocalizeSave(mCustomTooltipKey,"H7AdvMapObjectToolTip");
			data.Description = Repl(data.Description,"%icon_xp",class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(STAT_XP_RATE));
		}
		else
		{
			data.Description = data.Description $ GetGoldGain(class'H7AdventureController'.static.GetInstance().GetLocalPlayer()) 
				@ class'H7GUIGeneralProperties'.static.GetInstance().GetCurrencyIconHTML()
				$ GetModifierString(class'H7AdventureController'.static.GetInstance().GetLocalPlayer()) 
				@ class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetCurrencyResourceType().GetName()
				@ class'H7Loca'.static.LocalizeSave("TT_FILLER_OR","H7General") 
				@ mExp 
				@ class'H7GUIGeneralProperties'.static.GetInstance().mStatIconsInText.GetStatIconPathHTML(STAT_XP_RATE,class'H7AdventureController'.static.GetInstance().GetSelectedArmy().GetHero()) 
				@ class'H7Loca'.static.LocalizeSave("XP","H7General");
		}
		data.Description = data.Description $ "</font>";
	}

	return data;
}

function Hide()
{
	mIsHidden = true;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_NoCollision );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function Reveal()
{
	mIsHidden = false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
}

function string GetName()
{
	if( mResourceGains.Length == 1 )
	{
		return mResourceGains[0].Type.GetName();
	}

	if(mGlobalName != none && !mUseCustomName)
	{
		return mGlobalName.GetName();
	}
	else
	{
		return GetCustomName();
	}
}

function string GetCustomName()
{
	LocalizeCustomName();
	return mCustomNameInst;
}

function LocalizeCustomName()
{
	if(mCustomNameInst == "" || mCustomNameInst == "mName" )
	{
		mCustomNameInst = class'H7Loca'.static.LocalizeMapObject(self, "mName", mName);
	}
}

event PostSerialize()
{
	local H7AdventureMapCell cell;
	if( mLooted )
	{
		DestroySecure();
		return;
	}
	UpdateProperties();
	cell = GetEntranceCell();

	if( cell != none )
	{
		cell.SetHasPickable( true );
		cell.SetVisitableSite( self );
	}
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
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

