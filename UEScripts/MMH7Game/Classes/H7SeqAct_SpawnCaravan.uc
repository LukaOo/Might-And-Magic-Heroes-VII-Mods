/*=============================================================================
 * H7SeqAct_SpawnCaravan
 *
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/

class H7SeqAct_SpawnCaravan extends SequenceAction
	implements(H7IAliasable, H7IActionable, H7IRandomPropertyOwner)
	native
	savegame;

/** The tile marker where the caravan should be spawned */
var(Properties) protected H7TileMarker mTargetTileMarker<DisplayName="Target tile marker">;
/** Caravan destination */
var(Properties) protected savegame H7AreaOfControlSiteLord mCaravanTarget<DisplayName="Caravan destination">;
/** Defines the creature stacks in the caravan */
var(Properties) protected CreatureStackProperties mCreatureStackProperties[7]<DisplayName="Creature Stacks">;
/** The player that is the owner of the spawned caravan */
var(Properties) protected EPlayerNumber mPlayerNumber<DisplayName="Owning player">;

event Activated()
{
	local H7CaravanArmy caravanArmy;
	local H7AdventureMapCell target;
	local H7BaseCreatureStack stack;
	local int i;
	target = class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( mTargetTileMarker.Location );

	caravanArmy =  mCaravanTarget.Spawn( class'H7CaravanArmy');
	caravanArmy.Init( class'H7AdventureController'.static.GetInstance().GetPlayerByNumber( mPlayerNumber ), target ) ;
	caravanArmy.HideArmy(true);
	caravanArmy.SetIsInLord( false );
	caravanArmy.SetTargetLord( mCaravanTarget );
	caravanArmy.SetTargetLordLocation( mCaravanTarget.GetEntranceCell() );
	for( i=0;i< ArrayCount( mCreatureStackProperties); ++i)
	{
		if ( mCreatureStackProperties[i].Creature == none )
			continue;

		stack = new class'H7BaseCreatureStack'();
		stack.SetStackType( mCreatureStackProperties[i].Creature );
		stack.SetStackSize( mCreatureStackProperties[i].Size );
		caravanArmy.PutCreatureStackToEmptySlot(stack); 
	}

	caravanArmy.CreateHero();
	caravanArmy.ShowArmy();
	
	class'H7AdventureController'.static.GetInstance().AddCaravan( caravanArmy );
}

function UpdateRandomProperties(Object randomObject, Object hatchedObject)
{
	if(hatchedObject.IsA('H7AreaOfControlSiteLord'))
	{
		if(mCaravanTarget == randomObject)
		{
			mCaravanTarget = H7AreaOfControlSiteLord(hatchedObject);
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

