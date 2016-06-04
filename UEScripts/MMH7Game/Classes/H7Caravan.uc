//=============================================================================
// H7Caravan
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Caravan extends H7AdventureHero;

var() Texture2D         mCaravanIcon;

function H7CaravanArmy	GetCaravanArmy()				{ return H7CaravanArmy(mArmy); }
function string         GetName()                       { return H7CaravanArmy(mArmy).GetName(); }
function bool           IsHero()                        { return false; }

// overwritten because we have no visuals but need the minimap icon
function String			  GetFlashMinimapPath()			{ return "img://" $ Pathname( mCaravanIcon ); }

function H7EditorHero CreateHero(optional H7EditorArmy army, optional name herotag,	optional vector heroLocation, optional bool isAdventureHero, optional bool onlyHero, optional bool fromSave, optional H7EditorHero oldHero ) 
{ 
	local H7EditorHero hero;
	local H7Creature strongestCreature;

	if(oldHero == none)
	{
		hero = Spawn( class'H7Caravan' , army, herotag, heroLocation );
	}
	else
	{
		hero = oldHero;
	}
	
	hero.SetIsHero( false );
	hero.SetArmy(army);

	hero.SetMeshes( none, none, army );
		
	hero.SetAttack( 0 );
	hero.SetMinimumDamage( 0 );
	hero.SetMaximumDamage( 0 );
	hero.SetDefense( 0 );
	hero.SetLeadership( 0 );
	hero.SetDestiny( 0 );
	hero.SetXp( 0 );
	hero.SetCurrentMana( 0 );
	hero.SetMagic( 0 );
	hero.SetSpirit( 0 );
	strongestCreature = army.GetStrongestCreature();
	if( strongestCreature != none )
	{
		hero.SetIcon( strongestCreature.GetIcon() );
	}
	
	hero.SetInventory(mInventory);
	hero.SetHoHDefaultArmy(mHoHDefaultArmy);
	hero.Init( fromSave );

	if (army != None)
	{
		hero.SetRotation(army.Rotation);
	}

	army.SetCollision(false, false, true);
	army.SetLocation(hero.Location);
	army.SetHardAttach(true);
	army.SetBase(hero);


	return hero;
}


function EndMoving( optional bool ignoreTargetNotReachedMessage )
{
	super.EndMoving( ignoreTargetNotReachedMessage );

	if( ( GetCaravanArmy().GetTargetLordLocation() == GetCaravanArmy().GetCell() || 
		GetCaravanArmy().GetTargetLordLocation().IsNeighbour( GetCaravanArmy().GetCell() ) ) ) 
	{
		GetCaravanArmy().CaravanArrived();
	}
}

