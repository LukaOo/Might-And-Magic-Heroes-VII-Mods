//=============================================================================
// H7CaravanArmy
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CaravanArmy extends H7AdventureArmy
	notplaceable
	native
	savegame;


var protected savegame bool						mIsInLord;
var protected savegame H7AreaOfControlSiteLord	mSourceLord;
var protected savegame H7AreaOfControlSiteLord	mTargetLord;
var protected H7AdventureMapCell				mTargetLocation;
var protected savegame bool						mIsBlocked;

// savegame
var savegame AdventureMapCellCoords mTargetCoordinates;

// Checking if the caravan is actually in a town to exclude it from armies currently on the map
function bool IsGarrisoned() { return mIsInLord; }

function bool       IsInTown()                                              { return mIsInLord; }
function            SetIsInLord( bool value )                               { mIsInLord = value; }

function H7AreaOfControlSiteLord     GetSourceLord()                           { return mSourceLord; }
function            SetSourceLord( H7AreaOfControlSiteLord value )             { mSourceLord = value; }

function H7AreaOfControlSiteLord  GetTargetLord()                           { return mTargetLord; }
function            SetTargetLord( H7AreaOfControlSiteLord value )          { mTargetLord = value; }


event bool       IsACaravan()                                            { return true; }

function H7AdventureMapCell GetTargetLordLocation()                             { return mTargetLocation; }
function                    SetTargetLordLocation( H7AdventureMapCell cell )    { mTargetLocation = cell; }     

function H7Caravan GetCaravan() { return H7Caravan( mHero ); }

/**
 * Overriden EditorArmy function
 * */
event Init( H7Player playerOwner, optional H7AdventureMapCell startPos, optional Vector caravanLocation, optional bool pruneStacks )
{
	if( mHeroArchetype == none ) { ; mHeroArchetype = Spawn( class'H7Caravan' ); mHeroArchetype.SetIsHero( false ); }
	
	SetHeroTemplate( mHeroArchetype );
	SetCreatureStackProperties( mCreatureStackProperties );
	
	SetPlayer( playerOwner );

	mHeroEventParam = new class'H7HeroEventParam';
	mPlayerEventParam = new class'H7PlayerEventParam';

	CreateHero();

	SetDrawScale(DrawScale);
	SetDrawScale3D(DrawScale3D);

	if( caravanLocation == vect(0,0,0) )
	{
		SetCell( startPos,, false, true );
	}
	else
	{
		SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( caravanLocation ),, false, true );
	}
}

/**
 * Overriden EditorArmy function
 * */
function CreateHero( optional SavegameHeroStruct saveGameData )
{
	local H7Creature stronkCreature;
	if(mHero != none)
	{
		//Because a new hero is created (based on stronkest creature) the old hero's minimap-icon has to get deleted
		if (class'H7PlayerController'.static.GetPlayerController().GetAdventureHud() != None)
		{
			class'H7AdventureHudCntl'.static.GetInstance().GetMinimap().RemoveIcon(mHero.GetID());
		}
	}

	if( mHeroArchetype != none )
	{	
		mHero = H7Caravan( mHeroArchetype.CreateHero( self,, Location, true,,,mHero ) );
		mHero.SetMaxMovementPoints(class'H7AdventureController'.static.GetInstance().GetConfig().mCaravanMaxMovementPoints);
	
		stronkCreature = GetStrongestCreature();
		if( stronkCreature != none )
		{
			;
			mHero.SetFaction(stronkCreature.GetFaction());
		}

		
		mHero.SetPlayer( GetPlayer() );

		SetCollision( false, false, false );
		SetCollisionType( COLLIDE_BlockAll );
		
		// deserialize the data after the creation of the hero
		if( saveGameData.HasData )
		{
			mHero.RestoreState( saveGameData );
			SetIsDead( mIsDead ); // update the dead state
		}

		
		mHero.GetAnimControl().Init( mHero );
	}
	else
	{
		;
	}
}

/**
 * Called when Caravan arrives the target town
 */
function CaravanArrived()
{
	local ArrivedCaravan aCaravan;
	
	aCaravan.stacks = GetBaseCreatureStacks();
	aCaravan.sourceLord = GetSourceLord();
	aCaravan.targetLord = GetTargetLord();
	aCaravan.index = GetTargetLord().GetArrivedCaravans().length+1;

	GetTargetLord().AddArrivedCaravan( aCaravan );
	GetTargetLord().UnloadCaravan( aCaravan );
	if(GetTargetLord().GetVisitingArmy() == self)
	{
		GetTargetLord().SetVisitingArmy(none);
	}
	class'H7AdventureController'.static.GetInstance().RemoveCaravan( self );
}

/**
 * Create the Caravan Hero and make army visible 
 * if there is a path to target town
 */
function bool CreateCaravan()
{
	if( !CanMoveToAOCLord( GetTargetLord() ) )
		return false; 

	// create hero when caravan is started
	CreateHero();

	// remove it from Soruce Town; 
	GetSourceLord().CaravanLeaveTown();
	SetIsInLord( false );
	ShowArmy();

	return true;
}

/**
 * Check if the caravan can move to target town
 * 
 * @param lord target site lord
 * @return bool ture if path>0 
 */
function bool CanMoveToAOCLord( optional H7AreaOfControlSiteLord lord )
{
	local array<H7AdventureMapCell> path;

	path = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPath( mSourceLord.GetEntranceCell(), lord.GetEntranceCell(), mPlayer, HasShip() );

	return path.length > 0;
}

function PlaceOnMap()
{
	local H7AdventureMapCell cell1, cell2;
	local array<H7AdventureMapCell> neighbours1, neighbours2;

	if(mSourceLord == none)
	{
		;
		return;
	}

	if(!mSourceLord.GetEntranceCell().IsBlocked())
	{
		class'H7AdventureController'.static.GetInstance().AddCaravan( self );
		SetCell(mSourceLord.GetEntranceCell());
		return;
	}
	else
	{   
		neighbours1 = mSourceLord.GetEntranceCell().GetNeighbours();
		foreach neighbours1(cell1)
		{
			if(!cell1.IsBlocked())
			{
				class'H7AdventureController'.static.GetInstance().AddCaravan( self );
				SetCell(cell1);
				return;
			}
			neighbours2 = cell1.GetNeighbours();
			foreach neighbours2(cell2)
			{
				if(!cell2.IsBlocked()) 
				{
					class'H7AdventureController'.static.GetInstance().AddCaravan( self );
					SetCell(cell2);
					return;
				}
			}	
		}
	}
	;
}

/**
 * Move the Caravan to target town for this turn
 */
function array<H7AdventureMapCell> MoveToTown(array<H7AdventureMapCell> endCellBuffer)
{
	local array<H7AdventureMapCell> overallPath;
	local int walkealeCells, i; 
	local H7AdventureMapCell start;
	local bool endPointCollides;
	local H7Message message;

	// dont move; source and target are conquered
	if( AreLordsNotOwnedByCaravanOwner( GetTargetLord(), GetSourceLord() ) )
	{
		return endCellBuffer;
	}
	
	// return home; target is conquered
	if( GetTargetLord().GetPlayerNumber() != GetPlayerNumber() )
	{
		message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mCaravanReturn.CreateMessageBasedOnMe();
		message.AddRepl("%homesite",GetSourceLord().GetName());
		message.AddRepl("%destinationsite",GetTargetLord().GetName());
		message.settings.referenceObject = self;
		message.mPlayerNumber = GetPlayerNumber();
		message.mTooltip = class'H7Loca'.static.LocalizeSave("MSG_CARAVAN_RETURN","H7Message");
		message.mTooltip = Repl(message.mTooltip,"%homesite",GetSourceLord().GetName());
		message.mTooltip = Repl(message.mTooltip,"%destinationsite",GetTargetLord().GetName());
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);

		SetTargetLord( GetSourceLord() );
		SetTargetLordLocation( GetSourceLord().GetEntranceCell() );
	}

	start = GetHero().GetCell();
	overallPath = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPath( start, GetTargetLordLocation(), GetHero().GetPlayer(), HasShip() );

	;
	//`log_gui("path cost"@ class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetMovementCost( start, GetTargetLordLocation(), GetTargetLordLocation(), GetHero().GetPlayer().GetPlayerNumber(), self, HasShip() ) );

	// calculate walkable cells 
	class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( overallPath, start,  GetHero().GetMovementPoints(), walkealeCells );

	if(walkealeCells == 0) // I am blocked!
	{
		if(!mIsBlocked)
		{
			mIsBlocked = true; // state change
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mCaravanBlocked.CreateMessageBasedOnMe();
			message.AddRepl("%site",GetTargetLord().GetName());
			message.settings.referenceObject = self;
			message.mPlayerNumber = GetPlayerNumber();
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}
	else // I walk
	{
		if(mIsBlocked)
		{
			mIsBlocked = false; // state change
			message = class'H7MessageSystem'.static.GetInstance().GetMessageTemplates().mCaravanContinue.CreateMessageBasedOnMe();
			message.AddRepl("%site",GetTargetLord().GetName());
			message.settings.referenceObject = self;
			message.mPlayerNumber = GetPlayerNumber();
			class'H7MessageSystem'.static.GetInstance().SendMessage(message);
		}
	}

	// if overall path is bigger than current movementpoints
	if ( overallPath.Length > walkealeCells ) 
	{
		overallPath.Remove(  walkealeCells , overallPath.Length - walkealeCells );
	}

	// check if the end cell of the path collides with another end point of any caravan or an army standing on it
	endPointCollides  = true;
	while(endPointCollides)
	{
		if(overallPath.Length == 0)
		{
			break;
		}

		for(i=0; i<endCellBuffer.Length; i++)
		{
			if(endCellBuffer[i] == overallPath[overallPath.Length - 1])
			{
				overallPath.Remove(overallPath.Length -1, 1);
				continue;
			}
		}

		if(overallPath[overallPath.Length - 1].IsBlocked())
		{
			overallPath.Remove(overallPath.Length -1, 1);
			continue;
		}

		endPointCollides = false;
	}
	endCellBuffer.AddItem(overallPath[overallPath.Length - 1]);

	GetHero().SetCurrentPath(overallPath);
	
	class'H7BaseGameController'.static.GetBaseInstance().GetCommandQueue().Enqueue( class'H7Command'.static.CreateCommand( GetHero(), UC_MOVE,,,,overallPath, false ) );

	return endCellBuffer;
}

/**
 *  Checks if both target and source lord are not under player owner control 
 *  @param (H7AreaOfControl) target lord 
 *  @param (H7AreaOfControl) source lord 
 *  @return (bool) true if both towns are not under control 
 * */
function bool AreLordsNotOwnedByCaravanOwner( H7AreaOfControlSiteLord target, H7AreaOfControlSiteLord source )
{
	return target.GetPlayerNumber() != GetPlayerNumber() && source.GetPlayerNumber() != GetPlayerNumber();
}


/**
 * Get the estimate turn arrival
 *
 * @return    (int) counter for turns
 */
function int GetETA() 
{
	local int i;
	local array<H7AdventureMapCell> path;
	local array<float> movementCost;
	local float cost;
	local H7AdventureMapCell start;
	
	
	if( GetTargetLord() == none )
		return -1;
	
	if( GetHero() == none )
	{
		start = GetSourceLord().GetEntranceCell();
	}
	else 
	{
		start =  GetHero().GetCell();
	}

	path = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPath( start , GetTargetLordLocation(), mPlayer, HasShip() );
	movementCost = class'H7AdventureGridManager'.static.GetInstance().GetPathfinder().GetPathCosts( path, start );
	
	for (i=0;i<movementCost.Length;++i)
	{
		cost += movementCost[i];
	}

	return FCeil( cost / GetHero().GetMovementPoints() );
}

function StartCaravan( H7AreaOfControlSiteLord lord )
{
	local H7InstantCommandStartCaravan command;

	command = new class'H7InstantCommandStartCaravan';
	command.Init( self, lord );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function StartCaravanComplete( H7AreaOfControlSiteLord lord )
{
	local H7EventContainerStruct conti;
	local array<H7IEffectTargetable> targets;
	local H7PlayerEventParam eventParam;

 	CreateHero();
	PostCreateHero();

	lord.CaravanLeaveTown();
	SetIsInLord( false );

	PlaceOnMap();
	ShowArmy();

	// in case of Golden Path: buff the caravan on leaving
	targets.AddItem( GetHero() );
	conti.Targetable = GetHero();
	conti.TargetableTargets = targets;
	lord.TriggerEvents( ON_CARAVAN_CREATED, false, conti );

	// update this shit for Golden Path manually since shipping does stuff in the wrong order
	GetHero().SetCurrentMovementPoints( GetHero().GetMovementPoints() );

	// trigger kismet event: H7SeqEvent_PlayerStartsCaravan
	eventParam = new class'H7PlayerEventParam';
	eventParam.mEventPlayerNumber = self.GetPlayerNumber();
	class'H7ScriptingController'.static.TriggerEventParam(class'H7SeqEvent_PlayerStartsCaravan', eventParam, self);

	lord.CreateNewCaravan();
}

function Vector GetHeroFlagLocation()
{
	local Vector flagLoc;

	flagLoc.Z = HERO_FLAG_OFFSET + 200.0f;

	return flagLoc;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

