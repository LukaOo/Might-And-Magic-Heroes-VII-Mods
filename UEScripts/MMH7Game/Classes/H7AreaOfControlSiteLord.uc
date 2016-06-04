/*=============================================================================
* H7AreaOfControlSiteLord
* =============================================================================
*  Class for adventure map objects that own other sites in an Area of Control.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7AreaOfControlSiteLord extends H7AreaOfControlSite
	native
	placeable
	dependson( H7Dwelling )
	savegame;

var protected savegame array<H7AreaOfControlSiteVassal> mVassals;
var protected savegame int mAreaOfControlID;
var protected savegame array<ArrivedCaravan> mArrivedCaravans;
var protected savegame bool mCanCreateCaravanThisTurn;
var protected savegame bool mHasUncheckedCaravans; // when caravan arrives and it cannot be unloaded this is true to add blinking tooltip to quickslot

var protected savegame H7AdventureArmy mGarrisonArmy; // the garrison hero with the garrison units
var protected savegame H7AdventureArmy mGuardingArmy; // the outside army guarding this building

// Creature pool for AoC - tmp variable - calculated/overwritten - recruitment for garrison
var protected savegame array<H7DwellingCreatureData> mAoCCreaturePool;

// modifier for recruitment costs (used by CalculateRecruitmentCosts);
var protected savegame float mRecruitmentCostModifier;

var protected array<H7Creature> mHasRequiredDwellingFor; // used for buffering

var(Defense) protected RandomLordDefenseData mDefenseData<DisplayName="Default Garrison Army Data">;



var protected array<H7AdventureMapCell> mBorderCells; 

/** The initial level of this town or fort */
var(Developer) protected savegame int mLevel<DisplayName="Initial Level"|ClampMin=1>;


function int GetLevel()                                     { return mLevel; }
function SetLevel( int level )                              { mLevel = level; }
function array<H7AreaOfControlSiteVassal> GetVassals()      { return mVassals; }
function int GetAreaOfControlID()                           { return mAreaOfControlID; }
function array<H7DwellingCreatureData> GetCreaturePool()    { return mAoCCreaturePool; }
function SetRecruitmentCostModifier(float modifier)         { mRecruitmentCostModifier = modifier; }
function float GetRecruitmentCostModifier()                 { return mRecruitmentCostModifier; }

function bool HasWaitingCaravans()                                         { return mArrivedCaravans.Length > 0; }
function array<ArrivedCaravan>  GetArrivedCaravans()                       { return mArrivedCaravans; }
function                        AddArrivedCaravan( ArrivedCaravan value  ) { mArrivedCaravans.AddItem( value); }
function bool                   HasUncheckedCaravans()                     {return mHasUncheckedCaravans;}
function                        SetUncheckedCaravans(bool val)             {mHasUncheckedCaravans = val;}
event H7AdventureArmy           GetGarrisonArmy()              { return mGarrisonArmy; }
function                        SetGarrisonArmy( H7AdventureArmy army )
{ 
	mGarrisonArmy = army; 
	if(mGarrisonArmy!=None) 
	{
		mGarrisonArmy.SetGarrisonedSite( self );
		mGarrisonArmy.HideArmy(); 
		mGarrisonArmy.SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ) ); 
	}
}
function H7AdventureArmy        GetGuardingArmy( )                      { return mGuardingArmy; }
function                        SetGuardingArmy( H7AdventureArmy army ) { mGuardingArmy=army; }
function                        SetArmy( H7AdventureArmy army )         { mGarrisonArmy = army; }

function bool SpendPickupCostsOnVisit(H7AdventureHero visitingHero)
{
	return false;
}

event InitAdventureObject()
{
	super.InitAdventureObject();

	if( !class'H7ReplicationInfo'.static.GetInstance().IsLoadedGame() )
	{
		SpawnGarrisonedArmy();
	}
}

simulated function InitBorderCells()
{
	local array<H7AreaOfControlCells> cellData;
	cellData = class'H7AdventureGridManager'.static.GetInstance().GetAoCCells();
	if( mBorderCells.Length == 0 && cellData.length > mAreaOfControlID )
	{
		mBorderCells = cellData[mAreaOfControlID].BorderCells;
		;
	}
}

/**
 * Returns a complete creature pool from all the dwellings in the AoC.
 * Creature pools will be merged, so 2 dwellings with the same creatures
 * will have their numbers merged in the array this function returns.
 * 
 * @return          Merged creature pool from all the owned dwellings in the Lord's AoC
 */
function array<H7DwellingCreatureData> GetAoCCreaturePool()
{
	local H7AreaOfControlSiteVassal vassal;
	local H7Dwelling dwelling;
	local array<H7DwellingCreatureData> dwellingCreaturePool;
	local H7DwellingCreatureData creatureData;
	local int creatureDataIndex;
	
	// clear array
	mAoCCreaturePool.Length = 0;
	
	// iterate over dwellings
	foreach mVassals( vassal )
	{
		if( vassal.IsA( 'H7Dwelling' ) && vassal.GetPlayerNumber() == mSiteOwner )
		{
			dwelling = H7Dwelling( vassal );
		}
		else
		{
			continue;
		}
		dwellingCreaturePool = dwelling.GetCreaturePool();
		foreach dwellingCreaturePool( creatureData )
		{
			creatureDataIndex = mAoCCreaturePool.Find( 'Creature', creatureData.Creature );
			if( creatureDataIndex != -1)
			{
				mAoCCreaturePool[creatureDataIndex].Income += creatureData.Income;
				mAoCCreaturePool[creatureDataIndex].Reserve += creatureData.Reserve;
			}
			else
			{
				mAoCCreaturePool.AddItem( creatureData );
			}
		}
	}
	return mAoCCreaturePool;
}

function array<H7Dwelling> GetOutsideDwellings()
{
	local H7AreaOfControlSiteVassal vassal;
	local array<H7Dwelling> dwellings;
	foreach mVassals( vassal )
	{
		if(H7Dwelling( vassal ) != none && H7CustomNeutralDwelling( vassal ) == none ) 
		{
			dwellings.AddItem( H7Dwelling( vassal ) ); 
		}
	}
	return dwellings;
}

function RenderDebugInfo( Canvas myCanvas )
{
	local Color textColor, bgColor;
	local Font textFont;
	local Vector textLocation, lordPosition, vassalPosition, cellPosition;
	local float textLength, textHeight;
	local string displayText;
	local H7AreaOfControlSiteVassal vassal;
	local H7AdventureMapCell cell;

	InitBorderCells();
	lordPosition = myCanvas.Project( Location );

	foreach mVassals( vassal )
	{
		vassalPosition = myCanvas.Project( vassal.Location );
		myCanvas.SetPos( lordPosition.X-2, lordPosition.Y-2 );
		myCanvas.Draw2DLine( lordPosition.X, lordPosition.Y, vassalPosition.X, vassalPosition.Y, MakeColor( 255, 128, 0, 255 ) );
	}

	foreach mBorderCells( cell )
	{
		myCanvas.SetDrawColorStruct( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ).GetColor() );
		cellPosition = myCanvas.Project( cell.GetLocation() );
		myCanvas.SetPos( cellPosition.X-3, cellPosition.Y-3 );
		myCanvas.DrawRect( 20, 20 );
	}

	textColor.A = 255;

	bgColor.R = 255;
	bgColor.G = 128;
	bgColor.B = 0;
	bgColor.A = 255;

	textFont = Font'enginefonts.TinyFont';
	myCanvas.Font = textFont;
	myCanvas.DrawColor = textColor;

	displayText = " Name: " @ GetName() @ " | " @ "AoC: " @ mAreaOfControlID @ " ";

	myCanvas.StrLen( displayText, textLength, textHeight );
	textLocation = myCanvas.Project( self.Location );
	textLocation.X -= textLength / 2;

	myCanvas.SetPos( textLocation.X, textLocation.Y );
	myCanvas.DrawColor = bgColor;
	myCanvas.DrawRect(textLength, textHeight);
	
	myCanvas.SetPos( textLocation.X, textLocation.Y );
	myCanvas.DrawColor = textColor;
	myCanvas.DrawText( displayText );
}

function array<H7BaseCreatureStack> GetVisitorStacks()
{
	return mVisitingArmy.GetBaseCreatureStacks();
}

function array<H7BaseCreatureStack> GetGarrisonStacks()
{
	return mGarrisonArmy.GetBaseCreatureStacks();
}

function SetSiteOwner( EPlayerNumber newOwner, optional bool showPopup = true ) 
{
	local H7Player newPlayer;
	local H7AdventureController adventureController;
	local H7AreaOfControlSiteVassal vassal;

	if(mSiteOwner == newOwner)
	{
		return; // Already owned
	}

	adventureController = class'H7AdventureController'.static.GetInstance();

	newPlayer = adventureController.GetPlayerByNumber( newOwner );

	if( mGarrisonArmy != none )
	{
		if(mGarrisonArmy.GetHero() != none ) 
		{
			if( mGarrisonArmy.GetHero().IsHero() )
			{
				adventureController.RemoveArmy(mGarrisonArmy);
				adventureController.GetHallOfHeroesManager().AddDefeatedHero( mGarrisonArmy );
				SetGarrisonArmy( none );
				CreateEmptyGarrison();
			}
			mGarrisonArmy.SetPlayer( newPlayer );
		}
		else 
		{
			mGarrisonArmy.SetPlayer( newPlayer );
		}
	}

	super.SetSiteOwner(newOwner, showPopup);

	if( mSiteOwner != PN_NEUTRAL_PLAYER )
	{
		// Capture any non-neutral Vassals which are in the AoC, and not already owned
		foreach mVassals( vassal )
		{
			if( vassal == none ) continue;
				
			if( vassal.GetPlayerNumber() != PN_NEUTRAL_PLAYER && vassal.GetPlayerNumber() != newPlayer.GetPlayerNumber() )
			{
				if( vassal.GetGarrisonArmy() != none )
				{
					vassal.GetGarrisonArmy().SetPlayer( newPlayer );
				}
				vassal.SetSiteOwner( newPlayer.GetPlayerNumber(), false );
			}
		}
	}

	class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().UpdateAreaOfControl();
}

function private SpawnGarrisonedArmy()
{
	// reject if building is neither a town or a fort. all other building do not need an garrison army
	if( !Self.IsA('H7Town') && !Self.IsA('H7Fort') && !Self.IsA('H7Dwelling') ) return;

	if( mDefenseData.mUseThis && GetPlayerNumber() == PN_NEUTRAL_PLAYER )
	{
		CreateDefaultGarrison();
	}

	if( mEditorArmy == none ) 
	{ 
		CreateEmptyGarrison();
	}
	else
	{
		if( class'H7GameUtility'.static.IsArchetype( mEditorArmy ) )
		{
			mGarrisonArmy = Spawn( class'H7AdventureArmy',,,,, mEditorArmy );
			mGarrisonArmy.Init( GetPlayer(),, Location );
			mGarrisonArmy.SetGarrisonedSite( self );
			mGarrisonArmy.HideArmy();
			mGarrisonArmy.SetPlayer( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mSiteOwner ) );
		}
		else
		{
			SetGarrisonArmy( mEditorArmy );
			mGarrisonArmy.SetGarrisonedSite( self );
		}
		mGarrisonArmy.SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ) );
	}
}


function CreateEmptyGarrison()
{
	if( mGarrisonArmy == none )
	{
		mGarrisonArmy = Spawn( class'H7AdventureArmy' );
		mGarrisonArmy.Init( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( GetPlayerNumber() ),, Location );
		mGarrisonArmy.SetGarrisonedSite( self );
		mGarrisonArmy.HideArmy();
	}
}

function CreateDefaultGarrison()
{
	local H7RandomCreatureStack randomStack;
	local H7AdventureArmy army;

	if( mGarrisonArmy == none  )
	{
		randomStack = Spawn( class'H7RandomCreatureStack', self,,Location,Rotation);
		mDefenseData.mReferenceLord = self;
		randomStack.InitFromStruct( mDefenseData );
		army = randomStack.HatchRandomCreatureStack();

		SetGarrisonArmy( army );
		randomStack.DisposeShell();
	}
}


function array<H7BaseCreatureStack> GetLocalStacks()
{
	local array<H7DwellingCreatureData> props;
	local H7DwellingCreatureData prop;
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;

	stack = new class'H7BaseCreatureStack'();
	
	props = mAoCCreaturePool;

	foreach props( prop )
	{
		stack.SetStackType( prop.Creature );
		stack.SetStackSize( prop.Reserve );
		stacks.AddItem( stack );
	}

	return stacks;
}

function H7BaseCreatureStack GetLocalCreatureStackByIndex( int index )
{
	local array<H7DwellingCreatureData> props;
	local H7BaseCreatureStack stack;

	stack = new class'H7BaseCreatureStack'();

	props = mAoCCreaturePool;
	
	if( index > props.Length-1 || index < 0 )
	{
		stack = none;
	}
	else
	{
		stack.SetStackType( props[index].Creature );
		stack.SetStackSize( props[index].Reserve ); 
	}

	return stack;
}

function TransferHero( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	local H7InstantCommandTransferHero command;

	command = new class'H7InstantCommandTransferHero';
	command.Init( self, fromArmy, toArmy );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );	
}

function bool TransferHeroComplete( EArmyNumber fromArmy, EArmyNumber toArmy ) // HeroTransferComplete
{
	local H7AdventureArmy tmpArmy;
	local array<H7AdventureArmy> armies;
	local H7BaseCreatureStack stack, garrisonStack;
	local array<H7BaseCreatureStack> stacks, garrisonStacks;
	local bool mergedStack;
	local bool visitArmyWasReal;
	local int i, j;

	;

	// Garrison to Visiting
	if(fromArmy == ARMY_NUMBER_GARRISON && toArmy == ARMY_NUMBER_VISIT)
	{
		if( !mGarrisonArmy.GetHero().IsHero() )
		{
			;
			return false;
		}
		if( mVisitingArmy != none && mVisitingArmy.GetPlayer() != GetPlayer() || GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayer() != GetPlayer() )
		{
			;
			return false;
		}
		// Take the entire army if there is no visiting army
		if( mVisitingArmy == none)
		{
			;
			;
			// set the visiting army to be the garrisoned army now, since visiting army is empty
			SetVisitingArmy( mGarrisonArmy );
			// reset the reference to the garrison army
			SetGarrisonArmy( none );
			// the garrison army must always exist, so create a new empty one (with a dummy hero)
			
			// show the garrisoned army outside the town now
			mVisitingArmy.SetGarrisonedSite( none );
			mVisitingArmy.ShowArmy();
			mVisitingArmy.SetCell( GetEntranceCell() );
			mVisitingArmy.SetLocation(mVisitingArmy.GetHero().Location);
			mVisitingArmy.SetHardAttach(true);
			mVisitingArmy.SetBase(mVisitingArmy.GetHero());
			CreateEmptyGarrison();
			// register it as an army in the adventure controller
			armies = class'H7AdventureController'.static.GetInstance().GetArmies();
			if( armies.Find( mVisitingArmy ) == INDEX_NONE )
			{
				class'H7AdventureController'.static.GetInstance().AddArmy( mVisitingArmy );
			}
			// We just created an CreateEmptyGarrison , this deletes it again *?* removed because did see the sense
			//if( armies.Find( mGarrisonArmy ) != INDEX_NONE )
			//{
			//	class'H7AdventureController'.static.GetInstance().RemoveArmy( mGarrisonArmy );
			//}
			;

		}
		else if( mGarrisonArmy.GetHero().IsHero() && mVisitingArmy.GetHero().IsHero() ) // if both armies exist, swap them
		{
			//tmpArmy = mVisitingArmy;
			//mVisitingArmy = mGarrisonArmy;
			//mGarrisonArmy = tmpArmy;
			
			visitArmyWasReal = mVisitingArmy != none;

			; // swapping was reversed here, because compiler fail #coderswag #hack
			tmpArmy = mGarrisonArmy;
			mGarrisonArmy.SetCell(none);
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( tmpArmy );

			mVisitingArmy.SetGarrisonedSite( none );
			mVisitingArmy.SetCell( GetEntranceCell() );
			mVisitingArmy.ShowArmy();
			if(mVisitingArmy != none)
			{
				mVisitingArmy.SetLocation(mVisitingArmy.GetHero().Location);
				mVisitingArmy.SetHardAttach(true);
				mVisitingArmy.SetBase(mVisitingArmy.GetHero());
			}

			mGarrisonArmy.SetGarrisonedSite( self );
			mGarrisonArmy.SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ) );
			mGarrisonArmy.HideArmy();
			;
			
			if(mGarrisonArmy == none)
			{
				;
				;
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("mGarrisonArmy was lost UnrealScript Compiler Fail",MD_QA_LOG);;
				;
			}
			if(mVisitingArmy == none && visitArmyWasReal)
			{
				;
				;
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("mVisitingArmy was lost UnrealScript Compiler Fail",MD_QA_LOG);;
				;
			}
			;
			;

		}
		
		if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == none || mVisitingArmy != none)
		{
			class'H7AdventureController'.static.GetInstance().SelectArmy(mVisitingArmy, true);
		}

		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMinimap().UpdateVisibility();
		return true;
	}
	// Visiting to Garrison
	else if( fromArmy == ARMY_NUMBER_VISIT && toArmy == ARMY_NUMBER_GARRISON )
	{
		if( mGarrisonArmy == none)
		{
			//army = class'H7AdventureController'.static.GetInstance().Spawn( class'H7AdventureArmy' );
			;
			CreateEmptyGarrison();
			return false;
		}

		if( mVisitingArmy != none && mVisitingArmy.GetPlayer() != GetPlayer() || GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayer() != GetPlayer() )
		{
			;
			return false;
		}

		if( mGarrisonArmy.GetHero().IsHero() ) // hero is in garrison 
		{
			// if both armies exist, swap them
			tmpArmy = mGarrisonArmy;
			mGarrisonArmy.SetCell(none);
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( tmpArmy );
			
			mVisitingArmy.SetGarrisonedSite( none );
			mVisitingArmy.ShowArmy();
			mVisitingArmy.SetCell( GetEntranceCell() );
			mVisitingArmy.SetLocation(mVisitingArmy.GetHero().Location);
			mVisitingArmy.SetHardAttach(true);
			mVisitingArmy.SetBase(mVisitingArmy.GetHero());

			if(mGarrisonArmy != none)
			{
				mGarrisonArmy.SetGarrisonedSite( self );
				mGarrisonArmy.HideArmy();
				mGarrisonArmy.SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Location ) );
			}
			else
			{
				CreateEmptyGarrison();
			}
			;

			if(mVisitingArmy!=None)
			{
				if(mVisitingArmy.GetPlayer().IsControlledByAI()==false)
				{
					class'H7AdventureController'.static.GetInstance().SelectArmy(mVisitingArmy, true);
					class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMinimap().UpdateVisibility();
				}
			}
			return true;
		}
		else if( !mGarrisonArmy.HasUnits( true ) && !mGarrisonArmy.GetHero().IsHero() ) // empty garrison
		{
			// if the garrisoned army is without units and without a hero, then set the visiting army to the garrisoned army
			;
			tmpArmy = mGarrisonArmy;
			tmpArmy.SetGarrisonedSite( none );
			SetGarrisonArmy( mVisitingArmy );
			class'H7AdventureController'.static.GetInstance().RemoveArmy( tmpArmy );
			SetVisitingArmy( none );
			if(mGarrisonArmy.GetPlayer().IsControlledByLocalPlayer() || mGarrisonArmy.GetPlayer().IsControlledByAI())
			{
				class'H7AdventureController'.static.GetInstance().AutoSelectArmy();
			}
			return true;
		}
		else if( !mGarrisonArmy.GetHero().IsHero() && GetUniqueStackTypeCount(mGarrisonArmy, mVisitingArmy) <= 7) // garrison with creatures //&& mGarrisonArmy.GetNumberOfFilledSlots() + mVisitingArmy.GetNumberOfFilledSlots() <= mGarrisonArmy.GetMaxArmySize() )
		{
			//add check for amount of different creature types
			//if more then 7 -> return;
			//we can not merge 2 armies with more than 7 unique creature types

			// if there is no garrison hero, then merge armies!
			// get all the visiting army stacks
			stacks = mVisitingArmy.GetBaseCreatureStacks();
			// add them to the garrisoned army

			foreach stacks( stack )
			{
				mergedStack = false;
				// if user had the same stacktype seperated in his army, keep them seperated if possible. Else, allways merge.
				if(mVisitingArmy.IsTheFirstStackOfItsKind(stack) || mGarrisonArmy.GetNumberOfFilledSlots() >= 7)
				{
					garrisonStacks = mGarrisonArmy.GetBaseCreatureStacks();
					foreach garrisonStacks( garrisonStack )
					{
						if( garrisonStack.GetStackType() == stack.GetStackType())
						{
							garrisonStack.SetStackSize( garrisonStack.GetStackSize() + stack.GetStackSize() );
							mergedStack = true;
							break;
						}
					}
				}
				if( !mergedStack )
				{
					if(mGarrisonArmy.GetNumberOfFilledSlots() >= 7)
					{
						mGarrisonArmy.MergeToTargetStackCount(6);
					}
					mGarrisonArmy.PutCreatureStackToEmptySlot( stack );
				}
			}

			// to preserve stack positioning in the army slots, set the visiting army's stacks to be those of the garrisoned army's, and then transfer the entire visiting army over as the garrisoned army

			mVisitingArmy.SetBaseCreatureStacks( mGarrisonArmy.GetBaseCreatureStacks() );
			class'H7AdventureController'.static.GetInstance().RemoveArmy( mGarrisonArmy );
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( none );
			;
			if(mGarrisonArmy.GetPlayer().IsControlledByLocalPlayer() || mGarrisonArmy.GetPlayer().IsControlledByAI())
			{
				class'H7AdventureController'.static.GetInstance().AutoSelectArmy();
			}
			return true;
		}
		else if( !mGarrisonArmy.GetHero().IsHero() && GetUniqueStackTypeCount(mGarrisonArmy, mVisitingArmy) > 7 && mVisitingArmy.GetHero().GetIsScripted() )
		{
			// SCRIPTED EXCEPTION

			// get all the visiting army stacks
			stacks = mVisitingArmy.GetBaseCreatureStacksDereferenced();
			// add them to the garrisoned army
			garrisonStacks = mGarrisonArmy.GetBaseCreatureStacksDereferenced();
			foreach stacks( stack )
			{
				garrisonStacks.AddItem( stack );
			}

			for( i = 0; i < garrisonStacks.Length; ++i )
			{
				for( j = 0; j < garrisonStacks.Length; ++j )
				{
					if( i != j && garrisonStacks[i].GetStackType() == garrisonStacks[j].GetStackType() )
					{
						garrisonStacks[i].SetStackSize( garrisonStacks[i].GetStackSize() + garrisonStacks[j].GetStackSize() );
						garrisonStacks[j].SetStackSize( 0 );
					}
				}
			}

			for( i = garrisonStacks.Length - 1; i >= 0; --i )
			{
				if( garrisonStacks[i].GetStackSize() == 0 )
				{
					garrisonStacks.Remove( i, 1 );
				}
			}

			garrisonStacks.Sort( SortStackPoolMerge );

			if( garrisonStacks.Length > 7 )
			{
				garrisonStacks.Length = 7;
			}

			mVisitingArmy.SetBaseCreatureStacks( garrisonStacks );
			class'H7AdventureController'.static.GetInstance().RemoveArmy( mGarrisonArmy );
			SetGarrisonArmy( mVisitingArmy );
			SetVisitingArmy( none );
		}
		else
		{
			// something probably went wrong.
			;
			return false;
		}
	}
	else
	{
		;
		return false;
	}
}

function MergeArmies( EArmyNumber fromArmy, EArmyNumber toArmy )
{
	local H7InstantCommandMergeArmiesLord command;

	command = new class'H7InstantCommandMergeArmiesLord';
	command.Init( self, fromArmy, toArmy );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );	
}

function bool MergeArmiesComplete( EArmyNumber fromArmy, EArmyNumber toArmy ) // HeroTransferComplete
{
	local H7BaseCreatureStack stack, garrisonStack, visitingStack;
	local array<H7BaseCreatureStack> stacks, garrisonStacks, visitingStacks;
	local bool mergedStack;

	;

	// Garrison to Visiting
	if(fromArmy == ARMY_NUMBER_GARRISON && toArmy == ARMY_NUMBER_VISIT)
	{
		if( mVisitingArmy != none && mVisitingArmy.GetPlayer() != GetPlayer() || GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayer() != GetPlayer() )
		{
			;
			return false;
		}
		// Take the entire army if there is no visiting army
		if( mVisitingArmy == none)
		{
			;
			return false;
		}
		else if( GetUniqueStackTypeCount(mGarrisonArmy, mVisitingArmy) <= 7)
		{
			//we can not merge 2 armies with more than 7 unique creature types

			// if there is no garrison hero, then merge armies!
			// get all the visiting army stacks
			stacks = mGarrisonArmy.GetBaseCreatureStacks();
			// add them to the garrisoned army

			foreach stacks( stack )
			{
				mergedStack = false;
				// if user had the same stacktype seperated in his army, keep them seperated if possible. Else, allways merge.
				if(mGarrisonArmy.IsTheFirstStackOfItsKind(stack) || mVisitingArmy.GetNumberOfFilledSlots() >= 7)
				{
					visitingStacks = mVisitingArmy.GetBaseCreatureStacks();
					foreach visitingStacks( visitingStack )
					{
						if( visitingStack.GetStackType() == stack.GetStackType())
						{
							visitingStack.SetStackSize( visitingStack.GetStackSize() + stack.GetStackSize() );
							mergedStack = true;
							break;
						}
					}
				}
				if( !mergedStack )
				{
					if(mVisitingArmy.GetNumberOfFilledSlots() >= 7)
					{
						mVisitingArmy.MergeToTargetStackCount(6);
					}
					mVisitingArmy.PutCreatureStackToEmptySlot( stack );
				}
			}

			// to preserve stack positioning in the army slots, set the visiting army's stacks to be those of the garrisoned army's, and then transfer the entire visiting army over as the garrisoned army

			mGarrisonArmy.RemoveAllCreatureStacksComplete();
			return true;
		}
		
		if(class'H7AdventureController'.static.GetInstance().GetSelectedArmy() == none || mVisitingArmy != none)
		{
			class'H7AdventureController'.static.GetInstance().SelectArmy(mVisitingArmy, true);
		}

		class'H7PlayerController'.static.GetPlayerController().GetAdventureHud().GetAdventureHudCntl().GetMinimap().UpdateVisibility();
		return true;
	}
	// Visiting to Garrison
	else if( fromArmy == ARMY_NUMBER_VISIT && toArmy == ARMY_NUMBER_GARRISON )
	{
		if( mGarrisonArmy == none)
		{
			//army = class'H7AdventureController'.static.GetInstance().Spawn( class'H7AdventureArmy' );
			;
			CreateEmptyGarrison();
		}

		if( mVisitingArmy != none && mVisitingArmy.GetPlayer() != GetPlayer() || GetEntranceCell().GetArmy() != none && GetEntranceCell().GetArmy().GetPlayer() != GetPlayer() )
		{
			;
			return false;
		}

		if( !mGarrisonArmy.HasUnits( true ) ) // empty garrison
		{
			// if the garrisoned army is without units, then move all units from visit to garrison
			;
	
			mGarrisonArmy.SetBaseCreatureStacks(mVisitingArmy.GetBaseCreatureStacks());
			mVisitingArmy.RemoveAllCreatureStacksComplete();
			return true;
		}
		else if( GetUniqueStackTypeCount(mGarrisonArmy, mVisitingArmy) <= 7)
		{
			//we can not merge 2 armies with more than 7 unique creature types

			// if there is no garrison hero, then merge armies!
			// get all the visiting army stacks
			stacks = mVisitingArmy.GetBaseCreatureStacks();
			// add them to the garrisoned army

			foreach stacks( stack )
			{
				mergedStack = false;
				// if user had the same stacktype seperated in his army, keep them seperated if possible. Else, allways merge.
				if(mVisitingArmy.IsTheFirstStackOfItsKind(stack) || mGarrisonArmy.GetNumberOfFilledSlots() >= 7)
				{
					garrisonStacks = mGarrisonArmy.GetBaseCreatureStacks();
					foreach garrisonStacks( garrisonStack )
					{
						if( garrisonStack.GetStackType() == stack.GetStackType())
						{
							garrisonStack.SetStackSize( garrisonStack.GetStackSize() + stack.GetStackSize() );
							mergedStack = true;
							break;
						}
					}
				}
				if( !mergedStack )
				{
					if(mGarrisonArmy.GetNumberOfFilledSlots() >= 7)
					{
						mGarrisonArmy.MergeToTargetStackCount(6);
					}
					mGarrisonArmy.PutCreatureStackToEmptySlot( stack );
				}
			}

			// to preserve stack positioning in the army slots, set the visiting army's stacks to be those of the garrisoned army's, and then transfer the entire visiting army over as the garrisoned army

			mVisitingArmy.RemoveAllCreatureStacksComplete();
			return true;
		}
		else
		{
			// something probably went wrong.
			;
			return false;
		}
	}
	else
	{
		;
		return false;
	}
}

function int SortStackPoolMerge( H7BaseCreatureStack a, H7BaseCreatureStack b )
{
	return a.GetCreatureStackStrength() - b.GetCreatureStackStrength();
}

function static int GetUniqueStackTypeCount(H7AdventureArmy army1, H7AdventureArmy army2)
{
	local H7BaseCreatureStack stack;
	local array<H7BaseCreatureStack>stacks;
	local array<H7Creature> uniqueCreatures;

	stacks = army1.GetBaseCreatureStacks();
	foreach stacks(stack)
	{
		if(uniqueCreatures.Find(stack.GetStackType()) == -1) uniqueCreatures.AddItem(stack.GetStackType());
	}

	stacks = army2.GetBaseCreatureStacks();
	foreach stacks(stack)
	{
		if(uniqueCreatures.Find(stack.GetStackType()) == -1) uniqueCreatures.AddItem(stack.GetStackType());
	}
	return uniqueCreatures.Length;
}

function static int GetFreeSlotIndexOfArmy( H7AdventureArmy targetArmy, optional H7BaseCreatureStack transferStack )
{
	local array<H7BaseCreatureStack> targetArmyStacks;
	local int i;

	targetArmyStacks = targetArmy.GetBaseCreatureStacks();

	for( i = 0; i < class'H7EditorArmy'.const.MAX_ARMY_SIZE; ++i )
	{
		if( targetArmyStacks[i] == none )
		{
			return i;
		}

		if( transferStack != none )
		{
			if( targetArmyStacks[i].GetStackType().ObjectArchetype == transferStack.GetStackType().ObjectArchetype ) // if the current slot contains the same creature like the transfer unit
			{
				return i;
			}
		}

		if( i < class'H7EditorArmy'.const.MAX_ARMY_SIZE - 1 && i == targetArmyStacks.Length - 1 ) // if targetArmyStacks array is shorter than the possible max
		{
			return i + 1;
		}
	}

	return INDEX_NONE; // army full
}

/**
 * Recruits a certain amount of a creature from either the
 * Area of Control or a Town, if the SiteLord is a Town.
 * 
 * @param creatureName      The name of the creature
 * @param count             The amount of creatures to recruit
 * @param isHiringFromAoC   Are we recruiting from the AoC or from a local pool
 * @param targetIndex       The army slot index into which new recruits have been added
 * @param originDwelling    The dwelling in the Lord's AoC from which to recruit.
 * @param recruitToCaravan  Defines wether to recruit directly to a caravan or the usual way to garrison or visiting army
 * 
 * */
//function bool Recruit( string creatureName, int count, bool isHiringFromAoC, optional out int targetIndex, optional H7Dwelling originDwelling, 
//						optional out EArmyNumber targetArmy, optional bool recruitToCaravan = false, optional bool recruitToDwellingVisitor, optional bool doMultiplayerSynchro = true )
function Recruit( string creatureName, int count, bool isHiringFromAoC, optional H7Dwelling originDwelling, optional bool recruitToCaravan = false, optional bool recruitToDwellingVisitor, optional H7AreaOfControlSite caravanTarget, optional bool updateGui = true )
{
	local H7InstantCommandRecruit command;

	command = new class'H7InstantCommandRecruit';
	command.Init( self, creatureName, count, isHiringFromAoC, originDwelling, recruitToCaravan, recruitToDwellingVisitor, caravanTarget, updateGui );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function bool RecruitComplete( string creatureName, int count, bool isHiringFromAoC, optional out int targetIndex, optional H7Dwelling originDwelling, 
						optional out EArmyNumber targetArmy, optional bool recruitToCaravan = false, optional bool recruitToDwellingVisitor, optional H7AreaOfControlSite caravanTarget )
{
	local H7DwellingCreatureData dwellingData;
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local bool isMatch, hasUpgrade;
	local int indexSource, i;
	local array<H7DwellingCreatureData> creaturePool;
	local H7Player thePlayer;
	local H7Creature creature;
	local array<H7ResourceQuantity> recruitmentCosts;
	local array<H7TownBuildingData> dwellings;

	;

	thePlayer = GetPlayer();

	if( count <= 0 ) { return false; }

	if( isHiringFromAoC )
	{
		if( originDwelling == none ) 
		{
			;
			return false;
		}
		creaturePool = originDwelling.GetCreaturePool();
	}
	else if( self.IsA( 'H7Town' ) )
	{
		H7Town( self ).GetDwellings( dwellings );
		creaturePool = H7Town( self ).GetCreaturePool();
	}

	for( i = 0; i < creaturePool.Length; i++ )
	{
		if( creaturePool[ i ].Creature.GetBaseCreature() != none )  { creature = creaturePool[ i ].Creature.GetBaseCreature(); }
		else                                                        { creature = creaturePool[ i ].Creature; }

		// check if the creature name sent is the base creature itself or any of its upgrades
		do 
		{
			if( creature.GetIDString() == creatureName || creature.GetOverwriteIDString() != "" && creature.GetOverwriteIDString() == creatureName )
			{
				isMatch = true;
				indexSource = i;
				break;
			}
			if( creature.GetUpgradedCreature() != none )
			{
				hasUpgrade = true;
				creature = creature.GetUpgradedCreature();
			}
			else
			{
				hasUpgrade = false;
			}
		} 
		until( !hasUpgrade );
		// break the search if we have a match. This means if we have 2 separate entries for the same creature, only the first one will ever be detected.
		if( isMatch ) break;
	}

	if( !isMatch ) { ; return false; }

	// only possible to recruit as much as the current reserve
	if( count > creaturePool[ indexSource ].Reserve ) { count = creaturePool[ indexSource ].Reserve; }

	;
	CalculateRecruitmentCosts( creature, count, recruitmentCosts );

	if( thePlayer.GetResourceSet().CanSpendResources( recruitmentCosts ) )
	{
		thePlayer.GetResourceSet().SpendResources( recruitmentCosts );
		
		if(recruitToCaravan)
		{
			targetArmy = ARMY_NUMBER_CARAVAN;
			if(mCaravanArmy == none) CreateEmptyCaravan();
				
			mCaravanArmy.SetTargetLord(H7AreaOfControlSiteLord(caravanTarget));
			mCaravanArmy.SetTargetLordLocation(caravanTarget.GetEntranceCell());
			stack = mCaravanArmy.GetStackByIDString( creatureName );
			if( stack != none )
			{
				stack.SetStackSize( stack.GetStackSize() + count );
				targetIndex = mCaravanArmy.GetIndexOfStack(stack);
			}
			else
			{
				stack = new class'H7BaseCreatureStack'();
				stack.SetStackType( creature );
				stack.SetStackSize( count );
				targetIndex = mCaravanArmy.PutCreatureStackToEmptySlot(stack); 
			}
				
			;
		}
		else if(recruitToDwellingVisitor)
		{
			//targetArmy = originDwelling.GetVisitingArmy();
			targetArmy = ARMY_NUMBER_VISIT;
			stack = originDwelling.GetVisitingArmy().GetStackByIDString( creatureName );
			if( stack != none )
			{
				stack.SetStackSize( stack.GetStackSize() + count );
				targetIndex = originDwelling.GetVisitingArmy().GetIndexOfStack(stack);
			}
			else if( originDwelling.GetVisitingArmy().CheckFreeArmySlot() )
			{
				stack = new class'H7BaseCreatureStack'();
				stack.SetStackType( creature );
				stack.SetStackSize( count );
				targetIndex = originDwelling.GetVisitingArmy().PutCreatureStackToEmptySlot(stack); 
			}
		}
		else
		{
			stack = mGarrisonArmy.GetStackByIDString(creatureName);
			if( stack == none )
			{	
				if( mGarrisonArmy.CheckFreeArmySlot(  ) )
				{
					stack = new class'H7BaseCreatureStack'();
					stack.SetStackType( creature );
					stack.SetStackSize( count );
					targetIndex = mGarrisonArmy.PutCreatureStackToEmptySlot(stack);
					targetArmy = ARMY_NUMBER_GARRISON;
				}
				else if( mVisitingArmy != none )
				{
					targetArmy = ARMY_NUMBER_VISIT;
					stack = mVisitingArmy.GetStackByIDString( creatureName );
					if( stack != none )
					{
						stack.SetStackSize( stack.GetStackSize() + count );
						targetIndex = mVisitingArmy.GetIndexOfStack(stack);
					}
					else if( mVisitingArmy.CheckFreeArmySlot() )
					{
						stack = new class'H7BaseCreatureStack'();
						stack.SetStackType( creature );
						stack.SetStackSize( count );
						targetIndex = mVisitingArmy.PutCreatureStackToEmptySlot(stack); 
					}
					else
					{
						; 
						return false;
					}
				}
			}
			else
			{
				targetArmy = ARMY_NUMBER_GARRISON;
				stack.SetStackSize( stack.GetStackSize() + count );
				targetIndex = mGarrisonArmy.GetIndexOfStack(stack);
			}
		}

		// Reduce the reserve of the dwelling
		if( isHiringFromAoC )   { originDwelling.HireUnits( creature.GetIDString(), count ); }
		else                    { H7TownDwelling( dwellings[ indexSource ].Building ).HireUnits( count ); }

		// huge ass log
		stacks = mGarrisonArmy.GetBaseCreatureStacks();
		;
		;
		for( i = 0; i < stacks.Length; i++ )
		{
			if( stacks[i] != none )
				;
			else
				;
		}
		;
		;
	
		;
		;
		foreach creaturePool( dwellingData )
		{
			if( dwellingData.Creature.GetBaseCreature() != none )
				;
			else
				;
		}
		;
		;

		return true;
	}
	else
	{
		return false;
	}
}

/**
 * Calcualtes the amount of free army slots for recruit all
 *  - If caravan is highlighted, then first free caravanslots are counted and then free garissons slos are added
 *  - Else, First free garisson slots are counted and then free visisting Army slots are added
 */
function int getFreeStackSlots()
{
	local int freeSlots;

	if(class'H7TownHudCntl'.static.GetInstance().IsCaravanHighlight())
	{
		freeSlots = mCaravanArmy.GetFreeSlotCount() + mGarrisonArmy.GetFreeSlotCount();
	}
	else
	{
		if(mGarrisonArmy != none)
		{
			freeSlots =  mGarrisonArmy.GetFreeSlotCount();
		}
		else
		{
			freeSlots = 7;
		}
		if( mVisitingArmy != none)
		{
			freeSlots += mVisitingArmy.GetFreeSlotCount();
		}
	}
	
	return freeSlots;
}
/**
 * optional parameter is aiArmy is only used for H7Dwelling and H7CustomNeutralDwelling for AI purposes
 */
function array<H7RecruitmentInfo> GetRecruitAllData(optional bool checkGarrison=false, optional int freeSlots = -1, optional H7AdventureArmy aiArmy )
{
	local array<H7RecruitmentInfo> tempRecInfo, actualRecInfo;
	local H7ResourceSet resourceSet;

	// duplicate the current resource set as a "simulation" resource set to calculate costs
	resourceSet = new class'H7ResourceSet' ( GetPlayer().GetResourceSet() );
	if(freeSlots == -1) freeSlots = getFreeStackSlots();

	getAllCreaturesFromVassels(tempRecInfo);
	getAllCreaturesFromTown(tempRecInfo);
	writeActualRecuitmentData(actualRecInfo, tempRecInfo, resourceSet, freeSlots, checkGarrison);

	

	return actualRecInfo;
}

function String GetRecruitAllBlockReason(optional int freeSlots = -1)
{
	local array<H7RecruitmentInfo> tempRecInfo;
	local H7ResourceSet resourceSet;
	local H7RecruitmentInfo singleRecInfo;
	local int recruitableAmount;

	local bool allReservesEmpty, noResources, noFreeSlots;
	allReservesEmpty = true;
	noResources = true;
	noFreeSlots = true;

	// duplicate the current resource set as a "simulation" resource set to calculate costs
	resourceSet = new class'H7ResourceSet' ( GetPlayer().GetResourceSet() );
	if(freeSlots == -1) freeSlots = getFreeStackSlots();

	getAllCreaturesFromVassels(tempRecInfo);
	getAllCreaturesFromTown(tempRecInfo);

	foreach tempRecInfo(singleRecInfo)
	{
		if(singleRecInfo.Count == 0)
			continue;

		allReservesEmpty = false;

		recruitableAmount = GetPossibleRecruitCount( singleRecInfo.Creature, resourceSet, singleRecInfo.Count );

		if(recruitableAmount == 0)
			continue;

		noResources = false;

	}

	if(tempRecInfo.Length == 0) return "NO_DWELLINGS";
	if(allReservesEmpty) return "ALL_RESERVES_EMPTY";
	if(noResources)      return "NOT_ENOUGH_RESOURCES";
	if(noFreeSlots)      return "NO_FREE_UNIT_SLOTS";

	return "";
}

function array<H7RecruitmentInfo> GetRecruitAllDataForCaravan()
{
	local array<H7RecruitmentInfo> actualRecInfo, tempRecInfo;
	local H7ResourceSet resourceSet;
	local int freeSlots;
	
	// duplicate the current resource set as a "simulation" resource set to calculate costs
	resourceSet = new class'H7ResourceSet' ( GetPlayer().GetResourceSet() );
	freeSlots = mCaravanArmy == none ? class'H7EditorArmy'.const.MAX_ARMY_SIZE : mCaravanArmy.GetFreeSlotCount();

	getAllCreaturesFromVassels(tempRecInfo);
	getAllCreaturesFromTown(tempRecInfo);
	writeActualRecuitmentData(actualRecInfo, tempRecInfo, resourceSet, freeSlots);

	return actualRecInfo;
}

function String GetRecruitAllBlockReasonForCaravan()
{
	local array<H7RecruitmentInfo> tempRecInfo;
	local H7ResourceSet resourceSet;
	local H7RecruitmentInfo singleRecInfo;
	local int recruitableAmount;
	//local int freeSlots;

	local bool allReservesEmpty, noResources, noFreeSlots;
	allReservesEmpty = true;
	noResources = true;
	noFreeSlots = true;

	// duplicate the current resource set as a "simulation" resource set to calculate costs
	resourceSet = new class'H7ResourceSet' ( GetPlayer().GetResourceSet() );
	//freeSlots = mCaravanArmy == none ? class'H7EditorArmy'.const.MAX_ARMY_SIZE : mCaravanArmy.GetFreeSlotCount();

	getAllCreaturesFromVassels(tempRecInfo);
	getAllCreaturesFromTown(tempRecInfo);

	foreach tempRecInfo(singleRecInfo)
	{
		if(singleRecInfo.Count == 0)
			continue;

		allReservesEmpty = false;

		recruitableAmount = GetPossibleRecruitCount( singleRecInfo.Creature, resourceSet, singleRecInfo.Count );

		if(recruitableAmount == 0)
			continue;

		noResources = false;

	}

	if(tempRecInfo.Length == 0) return "NO_DWELLINGS";
	if(allReservesEmpty) return "ALL_RESERVES_EMPTY";
	if(noResources)      return "NOT_ENOUGH_RESOURCES";
	if(noFreeSlots)      return "NO_FREE_UNIT_SLOTS";

	return "";
}

function writeActualRecuitmentData(out array<H7RecruitmentInfo> actualRecruitmentData, array<H7recruitmentInfo> tempRecInfos, H7ResourceSet resourceSet, int freeSlots, optional bool checkGarrisonArmy = false)
{
	local H7RecruitmentInfo singleRecInfo;
	local array<H7ResourceQuantity> potentialCosts;
	local int recruitableAmount;
	local bool isAlreadyInRecruitmentInfos;

	;

	foreach tempRecInfos(singleRecInfo)
	{
		;
		
		potentialCosts.Length = 0;
		recruitableAmount = GetPossibleRecruitCount( singleRecInfo.Creature, resourceSet, singleRecInfo.Count );
		CalculateRecruitmentCosts( singleRecInfo.Creature, recruitableAmount, potentialCosts );

		singleRecInfo.Count = recruitableAmount;
		singleRecInfo.Costs = potentialCosts;

		isAlreadyInRecruitmentInfos = isRecruitingCreatureAlready(actualRecruitmentData, singleRecInfo.Creature);

		// add the recruitment data
		if(checkGarrisonArmy && freeSlots <= 0 && !mGarrisonArmy.HasCreature(singleRecInfo.Creature)
			&& !isAlreadyInRecruitmentInfos)
			continue;

		if(recruitableAmount > 0 &&
 		    !isRecruitingUpgradedVersionFromDwelling(actualRecruitmentData, singleRecInfo, false) 
		  )
		{
			;
			actualRecruitmentData.AddItem( singleRecInfo );
			resourceSet.SpendResources( potentialCosts, false );
			potentialCosts.Length = 0;
			// If check garrison army && garrison army doesnt contain creature
			// OR dont check garrison -> reduce free slot count
			// AND the recruitmentInfos does not already contain that creature
			if(((checkGarrisonArmy && !mGarrisonArmy.HasCreature(singleRecInfo.Creature)) 
				|| !checkGarrisonArmy)
			    && !isAlreadyInRecruitmentInfos) freeSlots--; 
			if(!checkGarrisonArmy && freeSlots == 0) break;
		}
	}
}

function writeActualRecruitmentDataForCaravan(out array<H7RecruitmentInfo> actualRecruitmentData, array<H7recruitmentInfo> tempRecInfos, H7ResourceSet resourceSet, int freeSlots)
{
	local H7RecruitmentInfo singleRecInfo;
	local array<H7ResourceQuantity> potentialCosts;
	local int recruitableAmount;
	local bool isAlreadyInRecruitmentInfos;

	;

	foreach tempRecInfos(singleRecInfo)
	{
		;
		
		potentialCosts.Length = 0;
		recruitableAmount = GetPossibleRecruitCount( singleRecInfo.Creature, resourceSet, singleRecInfo.Count );
		CalculateRecruitmentCosts( singleRecInfo.Creature, recruitableAmount, potentialCosts );

		singleRecInfo.Count = recruitableAmount;
		singleRecInfo.Costs = potentialCosts;

		isAlreadyInRecruitmentInfos = isRecruitingCreatureAlready(actualRecruitmentData, singleRecInfo.Creature);

		if(recruitableAmount > 0 &&
 			!isRecruitingUpgradedVersionFromDwelling(actualRecruitmentData, singleRecInfo)
			&& (freeSlots > 0 || (mCaravanArmy != none && mCaravanArmy.HasCreature(singleRecInfo.Creature)))
		 )
		{
			;
			actualRecruitmentData.AddItem( singleRecInfo );
			resourceSet.SpendResources( potentialCosts, false );
			potentialCosts.Length = 0;
			if((mCaravanArmy != none && mCaravanArmy.HasCreature(singleRecInfo.Creature))
			   || !isAlreadyInRecruitmentInfos)
				freeSlots--;
		}
	}
}

function getAllCreaturesFromTown(out array<H7RecruitmentInfo> tempRecInfo)
{
	local H7RecruitmentInfo recData;
	local H7DwellingCreatureData creaturePool;
	local array<H7TownBuildingData> buildingsData;
	local H7Creature bestCreature;
	local array<H7Creature> creatures;
	local int i, j;

	if(!self.IsA('H7Town'))return;

	recData.OriginDwelling = none;

	H7Town( self ).GetDwellings( buildingsData );
	for( i = 0; i < buildingsData.Length; i++ )
	{   
		creatures = H7TownDwelling( buildingsData[i].Building ).GetRecruitableCreatures();
		if( creatures.Length == 0 )
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("dwelling"@buildingsData[i].Building@buildingsData[i].Building.GetName()@"has invalid creature pool data",MD_QA_LOG);;
			continue;
		}
		creaturePool = H7TownDwelling( buildingsData[i].Building ).GetCreaturePool();
		if(creaturePool.Reserve <= 0) continue;

		for(j = 0; j < creatures.Length; j++)
		{
			bestCreature = creatures[j];

			// check if how many we can recruit (not more than the reserve)
			//potentialCosts.Length = 0;
			//recruitableAmount = GetPossibleRecruitCount( bestCreature, resourceSet, creaturePool.Reserve );
			//CalculateRecruitmentCosts( bestCreature, recruitableAmount, potentialCosts );

			//recData.Count = recruitableAmount;
			recData.Creature = bestCreature;
			recData.Count = creaturePool.Reserve;

			//isAlreadyInRecruitmentInfos = isRecruitingCreatureAlready(recruitmentInfos, recData.Creature);

			if(recData.Count > 0)
			{
				sortRecDataInArray(recData, tempRecInfo);
			}
		}
	}
}

function getAllCreaturesFromVassels(out array<H7RecruitmentInfo> tempRecInfo)
{
	local H7Dwelling dwelling;
	local H7AreaOfControlSiteVassal vassal;
	local H7RecruitmentInfo recData;
	local array<H7DwellingCreatureData> pool;
	local int i;
	
	foreach mVassals( vassal )
	{   
		if( vassal.IsA( 'H7Dwelling' ) && vassal.GetPlayerNumber() == mSiteOwner )
		{
			dwelling = H7Dwelling( vassal );
		}
		else
		{
			continue;
		}

		pool = dwelling.GetCreaturePool();

		for(i = 0; i < pool.Length; i++)
		{
			if(pool[i].Reserve <= 0) 
				continue;
		
			recData.Creature = pool[i].Creature;
			recData.Count = pool[i].Reserve;
			recData.OriginDwelling = dwelling;

			if(recData.Count > 0)
			{
				sortRecDataInArray(recData, tempRecInfo);
			}

			if(dwelling.IsUpgraded())
			{
				recData.Creature = pool[i].Creature.GetUpgradedCreature();
				recData.Count = pool[i].Reserve;
				recData.OriginDwelling = dwelling;
				
				if(recData.Count > 0)
					sortRecDataInArray(recData, tempRecInfo);
			}
		}
	}
}

function sortRecDataInArray(H7RecruitmentInfo recData, out array<H7RecruitmentInfo> tempRecInfo)
{
	local int i;

	if(tempRecInfo.Length == 0)
	{
		;
		tempRecInfo.AddItem(recData);
		return;
	}


	for(i = 0; i < tempRecInfo.Length; i++)
	{
		//new creature is stronger than anyone else
		if(i == 0 && recData.Creature.GetCreaturePower() > tempRecInfo[i].Creature.GetCreaturePower())
		{
			;
			tempRecInfo.InsertItem(i, recData);
			return;
		}			

		// new creature is as strong as current creature
		if(tempRecInfo[i].Creature.GetCreaturePower() == recData.Creature.GetCreaturePower())
		{
			;
			tempRecInfo.InsertItem(i+1, recData);
			return;
		}

		// new creature is stronger or weaker than last creature in array
		if(tempRecInfo.Length == i+1)
		{
			;
			//i is at the last index of the array now
			if(tempRecInfo[i].Creature.GetCreaturePower() < recData.Creature.GetCreaturePower())
				tempRecInfo.InsertItem(i, recData);
			else
				tempRecInfo.AddItem(recData);
			
			return;
		}

		// new creature is weaker than current creature but stronger than next creature
		if(tempRecInfo[i].Creature.GetCreaturePower() > recData.Creature.GetCreaturePower() &&
		   tempRecInfo.Length > i && 
		   tempRecInfo[i+1].Creature.GetCreaturePower() < recData.Creature.GetCreaturePower())
		{
			;
			tempRecInfo.InsertItem(i+1, recData);
			return;
		}
	}

	
}

// check if we already want to recruit the upgraded version of this creature from the same dwelling
function bool isRecruitingUpgradedVersionFromDwelling(array<H7RecruitmentInfo> recruitmentInfos, H7RecruitmentInfo recruitmentInfoToTest, bool checkDwelling = false)
{
	local H7RecruitmentInfo recInfo;

	if( recruitmentInfoToTest.Creature.GetUpgradedCreature() == none)
		return false;

	foreach recruitmentInfos(recInfo)
	{
		if(checkDwelling || recruitmentInfoToTest.OriginDwelling != none)
		{
			// recruitmentInfoToTest has same dwelling as one of the ones already contained on recruitmentInfo
			// && the one in the infos contains the upgraded version
			// THEN if we would add the recruitmentInfoToTest to the recruitmentInfos we would recruit for example 
			// Collosi AND Titan from the same dwelling
			if(recInfo.OriginDwelling == recruitmentInfoToTest.OriginDwelling 
			   && recInfo.Creature == recruitmentInfoToTest.Creature.GetUpgradedCreature())
			return true; 
		}
		else
		{
			// for TOWNS ONLY it is enough to just check the creature types, so if the recruitmentInfo already contains for example
			// Titans and the recruitmentInfoToTest contains Collosi, it would mean the we would recruit theese two creatures from the same dwelling
			if(recInfo.Creature == recruitmentInfoToTest.Creature.GetUpgradedCreature())
			return true;
		}
	}

	return false;
}

//check if recruitmentInfo already has that creature
function bool isRecruitingCreatureAlready(array<H7RecruitmentInfo> recruitmentInfos, H7Creature creature)
{
	local int i;

	for(i = 0; i < recruitmentInfos.Length; i++)
	{
		if(recruitmentInfos[i].Creature == creature)
			return true;
	}
	return false;
}

function getRecruitAllDataFromTownForCaravan( bool recruitBaseVersion, out H7ResourceSet resourceSet, out int freeSlots, out array<H7RecruitmentInfo> recruitmentInfos)
{
	local H7RecruitmentInfo recData;
	local H7DwellingCreatureData creaturePool;
	local array<H7TownBuildingData> buildingsData;
	local array<H7ResourceQuantity> potentialCosts;
	local int recruitableAmount;
	local H7Creature bestCreature;
	local array<H7Creature> creatures;
	local int i;
	local bool isAlreadyInRecruitmentInfos;

	if(!self.IsA('H7Town'))return;

	recData.OriginDwelling = none;

	H7Town( self ).GetDwellings( buildingsData );
	for( i = 0; i < buildingsData.Length; i++ )
	{   
		creatures = H7TownDwelling( buildingsData[i].Building ).GetRecruitableCreatures();
		if( creatures.Length == 0 )
		{
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("dwelling"@buildingsData[i].Building@buildingsData[i].Building.GetName()@"has invalid creature pool data",MD_QA_LOG);;
			continue;
		}
		creaturePool = H7TownDwelling( buildingsData[i].Building ).GetCreaturePool();
		if( creatures.Length <= 1 && !recruitBaseVersion) continue;
		if( creatures.Length > 1 && !recruitBaseVersion )
		{
			bestCreature = creatures[ creatures.Length - 1];
		}
		else
		{
			bestCreature = creatures[0];//H7TownDwelling( buildingsData[i].Building ).GetCreaturePool().Creature;
		}

		// check if how many we can recruit (not more than the reserve)
		potentialCosts.Length = 0;
		recruitableAmount = GetPossibleRecruitCount( bestCreature, resourceSet, creaturePool.Reserve );
		CalculateRecruitmentCosts( bestCreature, recruitableAmount, potentialCosts );

		recData.Count = recruitableAmount;
		recData.Creature = bestCreature;
		recData.Costs = potentialCosts;

		isAlreadyInRecruitmentInfos = isRecruitingCreatureAlready(recruitmentinfos, recData.Creature);

		// add the recruitment data

		if(recruitableAmount > 0 &&
 			(!recruitBaseVersion || 
				( recruitBaseVersion && !isRecruitingUpgradedVersionFromDwelling(recruitmentInfos, recData) ) 
			)
			&& (freeSlots > 0 || (mCaravanArmy != none && mCaravanArmy.HasCreature(recData.Creature)))
		)
		{
			;
			recruitmentInfos.AddItem( recData );
			resourceSet.SpendResources( potentialCosts, false );
			potentialCosts.Length = 0;
			if((mCaravanArmy != none && mCaravanArmy.HasCreature(recData.Creature))
			   || !isAlreadyInRecruitmentInfos)
				freeSlots--;
		}
	}
}

function RecruitAll( bool fromAoC, optional bool toDwellingVisitor, optional out array<int> recruitmentSlotIndixes, optional out array<EArmyNumber> reenforcedArmies)
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local H7RecruitmentInfo data;

	recruitmentInfo = GetRecruitAllData( );

	foreach recruitmentInfo( data )
	{
		Recruit( data.Creature.GetIDString(), data.Count, fromAoC, data.OriginDwelling, false , toDwellingVisitor );
	}
}

function AIRecruitAllFromTown()
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local H7RecruitmentInfo data;

	recruitmentInfo = GetRecruitAllData( );

	foreach recruitmentInfo( data )
	{
		Recruit( data.Creature.GetIDString(), data.Count, false, data.OriginDwelling, false , false );
	}
}

function AIRecruitAllFromTownIntoCaravan( H7AreaOfControlSite caravanTarget )
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local H7RecruitmentInfo data;
	local H7CaravanArmy caravan;
	recruitmentInfo = GetRecruitAllData( );

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	foreach recruitmentInfo( data )
	{
		Recruit( data.Creature.GetIDString(), data.Count, false, data.OriginDwelling, true, false, caravanTarget );
	}
	
	caravan = GetCaravanArmy();
	if( caravan == none )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	}
	else
	{
		if( caravan.HasUnits() )
		{
			caravan.StartCaravan( self );
		}
	}
}

function AIRecruitAllFromDwelling( H7Dwelling dwelling )
{
	local array<H7RecruitmentInfo> recruitmentInfo;
	local H7RecruitmentInfo data;
	recruitmentInfo = GetRecruitAllData( );
	foreach recruitmentInfo( data )
	{
		if(data.OriginDwelling==dwelling)
		{
			Recruit( data.Creature.GetIDString(), data.Count, true, data.OriginDwelling, false , false );
		}
	}
}

function H7Creature GetUpgradedCreature( string creatureName )
{
	return none;
}

/**
 * Gets upgrade costs and the amount of creatures that can be
 * upgraded by out parameter.
 * 
 * @param creature The creature for which to create the upgrade data
 * @param slotID If you set this pararamter you also have to set the next one
 * @param isVisitingArmy If the upgrade action should take place in the visiting army rather than the garrison
 * @param numOfUpgCreatures Shows how many creatures could be upgraded currently
 * @param lockNum don't change numOfUpgCreatures
 * 
 * */
function array<H7ResourceQuantity> GetUpgradeInfo( bool isVisitingArmy, out int numOfUpgCreatures, H7BaseCreatureStack creature=none,optional int slotID=-1, optional out array<H7ResourceQuantity> singleUpgCost, optional bool lockNum = false)
{
	local array<H7ResourceQuantity> upgradeCosts;
	local int i;
	local array<H7BaseCreatureStack> stacks;
	if(!lockNum)
	{
		numOfUpgCreatures = 0;
	}
	
	if(slotID!=-1 && isVisitingArmy && mVisitingArmy != none )
	{
		stacks = mVisitingArmy.GetBaseCreatureStacks();
		creature = stacks[ slotID ];
	}
	else if(slotID!=-1)
	{
		stacks = mGarrisonArmy.GetBaseCreatureStacks();
		creature = stacks[ slotID ];
	}
	
	if( creature == none || creature.GetStackType().GetUpgradedCreature() == none || !HasRequiredDwelling(creature.GetStackType().GetUpgradedCreature()) )
	{
		return upgradeCosts;
	}

	//get the cost to upgrade ONE creature
	CalculateRecruitmentCosts( creature.GetStackType().GetUpgradedCreature(), 1, upgradeCosts, true, creature.GetStackType() );

	/// Week of Training or Idle
	if( class'H7AdventureController'.static.GetInstance().HasUpradeCostWeekEffect())
	{
		for (i=0;i<upgradeCosts.Length;++i)
		{
			if( upgradeCosts[i].Type == GetPlayer().GetResourceSet().GetCurrencyResourceType() )
			{
				upgradeCosts[i].Quantity *= class'H7AdventureController'.static.GetInstance().GetUpgradeCostWeekEffect();
			}
		}
	}

	if(!lockNum)
	{
		numOfUpgCreatures = GetPlayer().GetResourceSet().CanSpendResourcesTimes(upgradeCosts);	
	}
	if(numOfUpgCreatures > creature.GetStackSize()) numOfUpgCreatures = creature.GetStackSize();

	// return upgCost for one creature so we can show it in gui
	if(numOfUpgCreatures == 0)
		singleUpgCost = upgradeCosts;

	//multiply the single upgrade costs by the amount of actualy upgradeable creatures
	for(i = 0; i < upgradeCosts.Length; i++)
		upgradeCosts[i].Quantity *= numOfUpgCreatures;

	return upgradeCosts;
}


/**
 * Upgrades a specific stack to the next available "upgrade" creature.
 * 
 * @param slotID            The slot number of the stack (in the army) to be upgraded
 * @param isVisitingArmy    Determines whether the command came from the visiting army/garrisoned army
 * @param count             How many of the stack will be upgraded
 * */
function UpgradeUnit( int slotID, bool isVisitingArmy, int count )
{
	local H7InstantCommandUpgradeUnit command;

	command = new class'H7InstantCommandUpgradeUnit';
	command.Init( self, slotID, isVisitingArmy, count );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function bool UpgradeUnitAI( H7AdventureArmy army, H7BaseCreatureStack crStack, optional bool doSynchronise = true )
{
	local bool                          isVisiting;
	local array<H7BaseCreatureStack>    armyStacks;
	local int                           k;
	local int                           numOfUpgCreatures;
	local array<H7ResourceQuantity>     upgRes;

	isVisiting=false;
	if(army==None || crStack==None)
	{
		return false;
	}
	if(GetVisitingArmy()==army)
	{
		isVisiting=true;
	}
	// get slotID 
	armyStacks=army.GetBaseCreatureStacks();
	for(k=0;k<armyStacks.Length;k++)
	{
		if(crStack.IsLockedForUpgrade() && armyStacks[k]==crStack)
		{
			upgRes=GetUpgradeInfo(isVisiting,numOfUpgCreatures,crStack);
			if(upgRes.Length>0)
			{
				if(doSynchronise)
				{
					UpgradeUnit(k,isVisiting,numOfUpgCreatures);
				}
				else
				{
					UpgradeUnitComplete(k,isVisiting,numOfUpgCreatures);
				}
				return true;
			}
		}
	}
	return false;
}

function UpgradeUnitComplete( int slotID, bool isVisitingArmy, int count )
{
	local H7AdventureArmy army;
	local H7BaseCreatureStack newStack, stack, upgradedStack;
	local array<H7ResourceQuantity> costs;
	local H7Player thePlayer;
	local array<H7BaseCreatureStack> stacks;

	thePlayer = GetPlayer();

	costs = GetUpgradeInfo( isVisitingArmy,count, none, slotID, , true);

	if( isVisitingArmy ) { army = mVisitingArmy; }
	else                 { army = mGarrisonArmy; }

	stacks = army.GetBaseCreatureStacks();
	stack = stacks[ slotID ];
	
	// upgrade all creatures in stack
	if( stack.GetStackSize() == count )
	{
		stack.SetStackType( stack.GetStackType().GetUpgradedCreature() );
	}
	else
	{
		// if we upgrade part of the stack, prefer splitting the stack to merging a new stack with an exisitng one
		if( army.CheckFreeArmySlot() )
		{
			newStack = new class'H7BaseCreatureStack'();
			newStack.SetStackType( stack.GetStackType().GetUpgradedCreature() );
			newStack.SetStackSize( count );
			army.PutCreatureStackToEmptySlot(newStack);
			stack.SetStackSize( stack.GetStackSize() - count );
		}
		else
		{
			upgradedStack = army.GetStackByName(stack.GetStackType().GetUpgradedCreature().GetName());
			if(upgradedStack != none)
			{
				upgradedStack.SetStackSize( upgradedStack.GetStackSize() + count );
				stack.SetStackSize( stack.GetStackSize() - count );
			}
			else
			{
				;
				return;
			}
		}
	}

	if( thePlayer.GetResourceSet().CanSpendResources( costs ) )
	{
		thePlayer.GetResourceSet().SpendResources( costs );
	}

	if( thePlayer.IsControlledByLocalPlayer() )
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons(thePlayer.GetResourceSet().GetAllResourcesAsArray());
	}
}

function bool HasRequiredDwelling( H7Creature upgradedCreature )
{
	local array<H7Dwelling> dwellings;
	local H7Dwelling dwelling;
	local array <H7DwellingCreatureData> creatures;
	local H7DwellingCreatureData creature;

	if( mHasRequiredDwellingFor.Find( upgradedCreature ) != INDEX_NONE ) { return true; }

	dwellings = GetOutsideDwellings();
	foreach dwellings( dwelling )
	{
		if(dwelling.GetPlayerNumber() != self.GetPlayerNumber())continue;
		creatures = dwelling.GetCreaturePool();
		foreach creatures( creature )
		{
			if(creature.Creature.GetUpgradedCreature() == upgradedCreature) 
			{
				mHasRequiredDwellingFor.AddItem( upgradedCreature );
				return true;
			}
		}
	}
	return false;
}

protected function bool HasRequiredDwellingTier( ECreatureTier tier )
{
	local H7DwellingCreatureData creature;

	foreach mAoCCreaturePool( creature )
	{
		if(creature.Creature.GetTier() == tier) return true;
	}
	return false;
}

native function int GetPossibleRecruitCount( H7Creature creature, H7ResourceSet resourceSet, int maxCount );

/**
 * Calculates creature costs into a parameter, enabling stacking up costs, if necessary
 * 
 * @param creature      The creature data
 * @param count         Amount of creatures (multiplier)
 * @param costs         The costs array
 * 
 * */
native function CalculateRecruitmentCosts( H7Creature creature, int count, out array<H7ResourceQuantity> costs, optional bool upgrade, optional H7Creature baseCreature );

function Conquer( H7AdventureHero conqueror )
{
	local H7Player currentPlayer;

	currentPlayer = conqueror.GetPlayer();
	if( mGarrisonArmy != none )
	{
		mGarrisonArmy.SetPlayer( currentPlayer );
	}

	super.Conquer( conqueror );	
	CreateEmptyGarrison();
}

protected function HandleOwnership( H7AdventureHero visitingHero )
{
	local H7AreaOfControlSiteVassal vassal;
	local H7Player currentPlayer;

	super.HandleOwnership( visitingHero );

	currentPlayer = visitingHero.GetPlayer();
	if( mGarrisonArmy == none )
	{
		CreateEmptyGarrison();
	}

	// Check if the AoC Lord has a garrisoned army and if it's a different player
	if( !mGarrisonArmy.HasUnits() && GetPlayer().IsPlayerHostile( currentPlayer )  )
	{   
		// If the Lord is unguarded and from a different player, capture it
		if( H7Town( self ) != none )
		{
			Conquer( visitingHero );
		}
		else
		{
			SetSiteOwner( currentPlayer.GetPlayerNumber() );
		
			mGarrisonArmy.SetPlayer( currentPlayer );
			if( mSiteOwner != PN_NEUTRAL_PLAYER )
			{
				// Capture any non-neutral Vassals which are in the AoC, and not already owned
				foreach mVassals( vassal )
				{
					if( vassal == none ) continue;

					if( vassal.GetPlayerNumber() != PN_NEUTRAL_PLAYER && vassal.GetPlayerNumber() != currentPlayer.GetPlayerNumber() )
					{
						if( vassal.GetGarrisonArmy() != none )
						{
							vassal.GetGarrisonArmy().SetPlayer( currentPlayer );
						}
						vassal.SetSiteOwner( currentPlayer.GetPlayerNumber(), false );
					}
				}
			}
		}
	}
}

function CaravanLeaveTown()
{
	// remove old ref.
	RemoveCaravanArmy();
}

function CreateNewCaravan()
{	
	// only one caravan in town and one per Turn
	if( CanHaveCaravan() ) 
	{
		CreateEmptyCaravan();
		mCanCreateCaravanThisTurn = false;
		
	}
}

function bool CanCreateCaravan()
{
	if( (GetCaravanArmy() != none && GetCaravanArmy().GetFreeSlotCount() != GetCaravanArmy().GetMaxArmySize() ))
		return true;
	return false;
}

// can create one
function bool CanHaveCaravan()
{
	return GetCaravanArmy() == none && mCanCreateCaravanThisTurn;
}

function bool CanAcceptCaravan(optional H7AreaOfControlSiteLord sourceLord)
{
	return sourceLord.GetCaravanArmy().CanMoveToAOCLord( self );
}

// changes done to the returned object will have no effect
function ArrivedCaravan GetArrivedCaravanByIndexReadOnly(int index)
{
	local int i; 
	local ArrivedCaravan caravan;
	for(i=0;i<mArrivedCaravans.Length;i++)
	{
		if(mArrivedCaravans[i].index == index)
		{
			return mArrivedCaravans[i];
		}
	}
	;
	return caravan;
}

function SetArrivedCaravanStacks(int index,array<H7BaseCreatureStack> stacks)
{
	local int i;
	for(i=0;i<mArrivedCaravans.Length;i++)
	{
		if(mArrivedCaravans[i].index == index)
		{
			mArrivedCaravans[i].stacks = stacks;
			//TODO if(empty) delete
			return;
		}
	}
	;
	return;
}

function UnloadCaravans()
{
	local ArrivedCaravan caravan;
	foreach mArrivedCaravans( caravan ) 
	{
		UnloadCaravan( caravan, false);
	}
}

// automatic unload
// manual unload
function bool UnloadCaravan( ArrivedCaravan caravan , optional bool automatic = true)
{
	local int i;
	local H7BaseCreatureStack strongestStack;
    local ArrivedCaravan tempCaravan; 
	local bool unload;
	local H7Message message;
   
	if( mArrivedCaravans.Find( 'index' ,caravan.index ) == -1 )
	{
	 	;
		return false;
	}


	tempCaravan = caravan;
	unload = true;
	
	// check all stacks in caravan
	for ( i=0;i<caravan.stacks.Length;++i )
	{
		strongestStack = GetStrongestStack( tempCaravan );
		
		// if creatures left
		if( strongestStack != none )
		{
			// if Garrison alrdy have this stack type -> merge
			if( GetGarrisonArmy().HasStackType( strongestStack ) )
			{
				if( GetGarrisonArmy().GetStackCount( strongestStack ) > 1 )
				{
					GetGarrisonArmy().DistributeUnits( strongestStack );	
					tempCaravan.stacks.RemoveItem( strongestStack );
				}
				else 
				{
					GetGarrisonArmy().AddRestUnits( strongestStack, strongestStack.GetStackSize() );	
					tempCaravan.stacks.RemoveItem( strongestStack );
				}
			}
			else 
			{
				// look for an empty slot
				if( GetGarrisonArmy().HasEmptySlot() ) 
				{
					GetGarrisonArmy().AddStack( GetGarrisonArmy().GetEmptySlotIndex() , strongestStack );
					GetGarrisonArmy().CreateCreatureStackProperies();
					tempCaravan.stacks.RemoveItem( strongestStack );
				}    
				else
				{
					// no space left for me *sobsob*
					unload = false;
				}
			}
		}
	}

	//stock up the rest
	if( GetStrongestStack( tempCaravan )  != none )
	{
		// failed to unload entire caravan
		if(automatic) mHasUncheckedCaravans = true; // activate blinking
		mArrivedCaravans[mArrivedCaravans.Find('index', caravan.index)] = tempCaravan;
	}
	else
	{
		mArrivedCaravans.RemoveItem( caravan );
	}


	// messages
	if(unload)
	{
		message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mCaravanArrived.CreateMessageBasedOnMe();
	}
	else
	{
		message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mCaravanUnload.CreateMessageBasedOnMe();
	}
	message.AddRepl("%site",GetName());
	message.settings.referenceObject = self;
	message.mPlayerNumber = GetPlayerNumber();
	class'H7MessageSystem'.static.GetInstance().SendMessage(message);

	return unload;	
}

function H7BaseCreatureStack GetStrongestStack( ArrivedCaravan aCaravan )
{
	local int i;
    local H7BaseCreatureStack strongestStack;
	local float strength;

	
	for (i=0; aCaravan.stacks.Length>i; ++i )
	{
		if( aCaravan.stacks[i] == none ) 
			continue;

		if( aCaravan.stacks[i].GetCreatureStackStrength() >= strength ) 
		{
			strength = aCaravan.stacks[i].GetCreatureStackStrength();
			strongestStack =  aCaravan.stacks[i];
		}
	}
	
	return strongestStack;
}

function bool IsCaravanEmpty( int caravanIndex )
{
	return GetStrongestStack( GetArrivedCaravanByIndexReadOnly( caravanIndex ) ).GetStackSize() == 0; // master function recycle!
}

function DeleteCaravan( int caravanIndex )
{
	local int index;
	
	index = mArrivedCaravans.Find( 'index', caravanIndex );
	if( index == -1 )
	{
	 	;
		return;
	}
	
	// remove it from list;
	mArrivedCaravans.Remove(index ,1 );
}

function DbgDumpArmies()
{
	local int i;
	local array<H7BaseCreatureStack> homStacks, visStacks, grdStacks;

	grdStacks = mGuardingArmy.GetBaseCreatureStacks();
	homStacks = mGarrisonArmy.GetBaseCreatureStacks();
	visStacks = mVisitingArmy.GetBaseCreatureStacks();

	if( mGuardingArmy != mVisitingArmy )
	{
if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		for( i=0; i<grdStacks.Length; i++ )
		{
			if( grdStacks[i] != None )
			{
				if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
			}
		}
	}
if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	for( i=0; i<homStacks.Length; i++ )
	{
		if( homStacks[i] != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}
if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	for( i=0; i<visStacks.Length; i++ )
	{
		if( visStacks[i] != None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}

if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
	for( i=0; i<mLocalGuard.Length; i++ )
	{
		if( mLocalGuard[i].Creature!=None )
		{
			if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		}
	}
}

// this function is called by the Ai to upgrade any creatures in the visiting army
function AiUpgradeCreatures()
{
	local array<H7BaseCreatureStack> visStacks;
	local H7BaseCreatureStack cstack;
	local array<ResourceStockpile> stockpiles;
	local ResourceStockpile stockpile;

	// make sure we have a visiting army
	if( mVisitingArmy == None ) return;

	if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;

	//DbgDumpArmies();

	visStacks = mVisitingArmy.GetBaseCreatureStacks();
	stockpiles = mVisitingArmy.GetAIReplenishStash().GetAllResourcesAsArray();
	foreach stockpiles( stockpile )
	{
		if( ( class'H7AdventureController'.static.GetInstance() != none && class'H7AdventureController'.static.GetInstance().GetConfig().mAiAdvMapConfig.mConfigOutputToLog ) || class'H7AdventureController'.static.GetInstance() == none ) ;
		GetPlayer().GetResourceSet().ModifyResource( stockpile.Type, stockpile.Quantity, false );
	}
	mVisitingArmy.ResetAIReplenishStash();

	foreach visStacks(cstack)
	{
		UpgradeUnitAI(mVisitingArmy,cstack);
		cstack.SetLockedForUpgrade( false );
	}

	mVisitingArmy.UnifyStacks();
}

// this function is called by the Ai to move garrisoned creatures to the visiting heroes army
function AiPickupCreatures()
{
	// make sure we have a garrison army as a visiting army
	if( mVisitingArmy == None || mGarrisonArmy == None ) return;

	mGarrisonArmy.MergeArmiesAI( mVisitingArmy );
}

// needs to be called after every action that changes the local guard data
function CalculateLocalGuard(H7TownGuardBuilding responsibleBuilding)
{
	mLocalGuard = responsibleBuilding.GetCorrectedTownGuard(mLocalGuard,self.GetFaction());

	UpdateLocalGuardGUI();
}

function DowngradeLocalGuard(H7TownGuardBuilding responsibleBuilding, optional H7TownGuardGrowthEnhancer guardEnhancer)
{
	mLocalGuard = responsibleBuilding.DowngradeTownGuard(mLocalGuard, guardEnhancer);

	UpdateLocalGuardGUI();
}

function UpdateLocalGuardGUI()
{
	
}

function OnVisit( out H7AdventureHero hero )
{
	super.OnVisit(hero);

	if( mGarrisonArmy == none )
	{
		CreateEmptyGarrison();
	}

	mHeroEventParam.mEventHeroTemplate = hero.GetAdventureArmy().GetHeroTemplateSource();
	mHeroEventParam.mEventPlayerNumber = hero.GetPlayer().GetPlayerNumber();
	mHeroEventParam.mEventSite = self;
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_VisitTown', mHeroEventParam, hero.GetAdventureArmy());
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

