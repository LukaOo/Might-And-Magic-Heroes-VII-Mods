//=============================================================================
// H7ItemPile
//=============================================================================
// Represents a pile of item(s) that can be collected from the adventure map.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7ItemPile extends H7VisitableSite
	implements(H7IPickable, H7ITooltipable, H7IHideable)
	native
	dependson(H7IPickable,H7ITooltipable)
	placeable
	hidecategories(Visuals, SkeletalMeshActor, Editor)
	savegame;


/** The artifacts contained in this pile */
var(Developer) protected savegame archetype array<H7HeroItem> mItems<DisplayName=Artifacts>;
var protected savegame array<string> mItemRefs;
//var(Developer) protected Texture2D mMinimapIcon<DisplayName="Icon Minimap">;
var protected savegame bool mLooted;
var protected savegame bool mIsHidden;
var(Audio) protected AkEvent mOnPickUpSound<DisplayName=Pick up sound>;

native function bool IsHiddenX();

function String GetFlashMinimapPath()          { return "img://" $ Pathname( mMinimapIcon ); }
function bool IsLooted() {return mLooted;}

function array<H7HeroItem> GetItems()
{
	return mItems;
}

function AddItem( H7HeroItem item )
{
	if( item != none )
	{
		mItems.AddItem(item);
	}
}

function native UpdateProperties();

event PostSerialize()
{
	local H7HeroItem item, itemTemplate;
	local string path;
	if( mLooted )
	{
		DestroySecure();
		return;
	}
	if( mIsHidden )
	{
		Hide();
	}
	else
	{
		Reveal();
	}
	mItems.Length = 0;
	foreach mItemRefs( path )
	{
		itemTemplate = H7HeroItem(DynamicLoadObject(path, class'H7HeroItem') );
		item = class'H7HeroItem'.static.CreateItem( itemTemplate );
		mItems.AddItem( item );
	}
}

event InitAdventureObject()
{
	local int i;

	super.InitAdventureObject();

	if(mOnPickUpSound == none)
	{
		mOnPickUpSound = AkEvent'H7SFX_Pickup.pickup_artifact';
	}
	
	for( i=0; i<mItems.Length; ++i )
	{
		mItems[i] = class'H7HeroItem'.static.CreateItem( mItems[i] );
	}

	if( mLooted )
	{
		DestroySecure();
	}
	else
	{
		UpdateProperties();
	}
}

native function UpdateFloating( float deltaTime );

function OnVisit( out H7AdventureHero hero )
{
	// NO INTERACTIONS WITH HIDEABLES
	if( IsHiddenX() ) { return; }
	super.OnVisit( hero );
	PickUp(hero);
}

function PickUp( H7AdventureHero lootingHero, optional ELootType lootType = LOOT_TYPE_MAX, optional bool doMultiplayerSynchro = false ) 
{
	local H7AdventureHero hero;
	local H7HeroItem item;
	local H7EventContainerStruct eventContainer;
	local H7HeroItem tearTemplate;

	tearTemplate = class'H7AdventureController'.static.GetInstance().GetMapInfo().mTearOfAshaTemplate;

	if(mOnPickUpSound!=None)
	{
		self.PlayAkEvent(mOnPickUpSound,true,true);
	}
	else
	{
		mOnPickUpSound = AkEvent'H7SFX_Pickup.pickup_artifact';
		self.PlayAkEvent(mOnPickUpSound,true,true);
	}

	hero = lootingHero;
	foreach mItems( item )
	{
		hero.GetInventory().AddItemToInventoryComplete( item,, );
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_ITEM_PICKUP, location, lootingHero.GetPlayer(), "+"$item.GetName() , MakeColor(0,255,0,255) , item.GetIcon() );
		eventContainer.EffectContainer = item;
		eventContainer.Targetable = hero;
		item.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
		hero.TriggerEvents( ON_RECEIVE_ITEM, false, eventContainer );
		if( item.IsEqual( tearTemplate ) )
		{
			hero.SetHasTearOfAsha( true );
			class'H7AdventureController'.static.GetInstance().SetTearOfAshaRetrieved( true );
			if( !hero.GetPlayer().IsControlledByAI() && hero.GetPlayer().IsControlledByLocalPlayer() )
			{
				class'H7AdventureController'.static.GetInstance().SendTrackingTreasureHunt();
			}
			class'H7EffectSpecialRetrieveTearOfAsha'.static.RevealFog( hero.GetCell() );
			hero.SetTimer( 0.1f, false, 'DelayedTearOfAshaRevealMessageSuccess' );
		}
	}

	// TODO more security checks? with which hero? Is the hero next to it? sim-turn conflicts? ...?
	if( mLooted )
	{
		;
		return;
	}

	DestroySecure();

	if (class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().Update();
	}

	mHeroEventParam.mEventHeroTemplate = hero.GetAdventureArmy().GetHeroTemplateSource();
	mHeroEventParam.mEventPlayerNumber = hero.GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventSite = self;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_Loot', mHeroEventParam, hero.GetAdventureArmy());
}

function DestroySecure()
{
	local H7AdventureGridManager gridManager;
	local H7AdventureMapCell cell;
	local H7AdventureController advController;

	mLooted = true;
	gridManager = class'H7AdventureGridManager'.static.GetInstance();
	advController = class'H7AdventureController'.static.GetInstance();
	advController.RemoveAdvObject( self );
	gridManager.RemoveVisitableSite(Self);
	// remove object from cell and get rid of the actor itself 
	cell = gridManager.GetCellByWorldLocation( Location );
	cell.SetVisitableSite( none );
	cell.SetHasPickable( false );
	cell.SetAdventureObject( none );
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

function Color GetColor()
{
	return class'H7AdventureController'.static.GetInstance().GetNeutralPlayer().GetColor();
}

function H7TooltipData GetTooltipData(optional bool extendedVersion)
{
	local H7TooltipData data;
	local H7HeroItem item;
	
	data.type = TT_TYPE_ITEM;

	if(mItems.Length == 1)
	{
		data.Title = mItems[0].GetName();
		data.Description = mItems[0].GetTooltip(extendedVersion);
		if(mItems[0].GetItemSet() != none)
		{
			data.addRightMouseIcon = true;
		}
	}
	else
	{
		data.Title = class'H7Loca'.static.LocalizeSave("TT_ITEMS","H7Adventure");
		foreach mItems( item )
		{
			data.Description = (data.Description!=""?(data.Description $ "\n"):"") $ item.GetColoredName();
		}
	}



	/*data.Description = (data.Description!=""?(data.Description $ "\n"):"") $ "<font size='#TT_SUBTITLE#' "; 
			if(item.IsStoryItem()) data.Description = data.Description $ "color='#ff9900'>"; // gold
			else if(item.CanConsume()) data.Description = data.Description $ "color='#ff99ff'>"; // beige
			else if(item.GetTier() == ITIER_MINOR) data.Description = data.Description $ "color='#33ff99'>"; //turquis
			else if(item.GetTier() == ITIER_MAJOR) data.Description = data.Description $ "color='#3f3fff'>"; //blue
			else if(item.GetTier() == ITIER_RELIC) data.Description = data.Description $ "color='#ff0fff'>"; //purple
			else data.Description = data.Description $ ">";*/

	//`log_dui("Final tt" @ data.Description);

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
	mIsHidden=false;
	SetHidden( mIsHidden );
	SetCollisionType( COLLIDE_BlockAll );
	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateVisibility();
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

