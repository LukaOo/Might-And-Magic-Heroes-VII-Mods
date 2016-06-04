//=============================================================================
// H7EffectSpecialRetrieveTearOfAsha
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialRetrieveTearOfAsha extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var(FX) protected ParticleSystem    mRevealFX<DisplayName="Reveal FX">;
var(FX) protected ParticleSystem    mRevealFailFX<DisplayName="Reveal Fail FX">;
var(FX) protected float             mRevealTimer<DisplayName="Reveal Timer">;

var protected H7AdventureHero mHero;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster;
	local H7AdventureHero hero;
	local H7HeroItem tearTemplate,tear;
	local H7AdventureController advCntl;
	local string fctMessage;
	local array<H7AdventureMapCell> neighbours;
	local H7AdventureMapCell neighbour;
	local bool found;

	if( isSimulated || class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) { return; }

	caster = effect.GetSource().GetCasterOriginal();
	hero = H7AdventureHero( caster );
	advCntl = class'H7AdventureController'.static.GetInstance();
	tearTemplate = advCntl.GetMapInfo().mTearOfAshaTemplate;
	mRevealTimer = 2.0f;
	
	if( hero != none )
	{
		if( !advCntl.IsTearOfAshaRetrieved() )
		{
			neighbours = hero.GetCell().GetNeighbours();
			neighbours.AddItem( hero.GetCell() );
			foreach neighbours( neighbour )
			{
				if( neighbour.GetGridPosition() == advCntl.GetTearOfAshaCoordinates() && neighbour.GetGridOwner().GetIndex() == advCntl.GetTearOfAshaGridIndex() )
				{
					hero.SetTimer( mRevealTimer, false, 'DelayedTearOfAshaRevealMessageSuccess' );
					if( tearTemplate.IsA( 'H7TearOfAsha' ) )
					{
						hero.SetHasTearOfAsha( true );
						tear = new class'H7TearOfAsha'( tearTemplate );
					}
					else
					{
						tear = new class'H7HeroItem'( tearTemplate );
					}
					hero.GetInventory().AddItemToInventoryComplete( tear );
					advCntl.SetTearOfAshaRetrieved( true );
					if( !hero.GetPlayer().IsControlledByAI() && hero.GetPlayer().IsControlledByLocalPlayer() )
					{
						advCntl.SendTrackingTreasureHunt();
					}
					class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter( mRevealFX, hero.GetLocation() );
					RevealFog( hero.GetCell() );
					found = true;
					break;
				}
			}
			if( !found )
			{
				hero.SetTimer( mRevealTimer, false, 'DelayedTearOfAshaRevealMessageFail' );
				class'WorldInfo'.static.GetWorldInfo().MyEmitterPool.SpawnEmitter( mRevealFailFX, hero.GetLocation() );
			}
		}
		else
		{
			fctMessage = class'H7Loca'.static.LocalizeSave("FCT_RETRIEVED_TEAR_OF_ASHA","H7FCT");
			fctMessage = Repl( fctMessage, "%item", tearTemplate.GetName() );
			class'H7FCTController'.static.GetInstance().StartFCT( FCT_TEXT, hero.GetLocation(), hero.GetPlayer(), fctMessage, MakeColor( 255, 0, 0, 255 ) );
		}
	}
}

static function RevealFog( H7AdventureMapCell cell )
{
	local array<H7Player> players;
	local array<IntPoint> visiblePoints;
	local H7FOWController fogController;
	local H7AdventureMapGridController gridController;
	local int i;

	if( cell != none )
	{
		gridController = cell.GetGridOwner();
		fogController = gridController.GetFOWController();
	
		if( fogController != none )
		{
			class'H7Math'.static.GetMidPointCirclePoints( visiblePoints, cell.GetCellPosition(), cell.GetArmy().GetHero().GetScoutingRadius() );

			players = class'H7AdventureController'.static.GetInstance().GetPlayers();
			
			for( i = 0; i < players.Length; ++i )
			{
				if( players[i].GetPlayerNumber() != PN_NEUTRAL_PLAYER )
				{
					fogController.HandleExploredTiles( players[i].GetPlayerNumber(), visiblePoints, false );
				}
			}
		}
	}
	class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid().GetFOWController().ExploreFog();
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_RETRIEVE_TEAR_OF_ASHA","H7TooltipReplacement");
}
