/*=============================================================================
* H7TownUtilityUnitDwelling
* =============================================================================
*  Class for describing dwellings that can be built in towns.
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7TownUtilityUnitDwelling extends H7TownBuilding
	savegame;

var( UtilityUnitDwelling ) H7EditorWarUnit  mEditorWarUnit<DisplayName=War Unit>;

var savegame H7EditorWarUnit mWarUnit;

function H7EditorWarunit GetWarunitTemplate()
{
	return mEditorWarUnit;
}

function array<H7AdventureArmy> GetTownArmies()
{
	local array<H7AdventureArmy> armies;

	if( mTown.GetGarrisonArmy() != none && mTown.GetGarrisonArmy().GetHero().IsHero() )
	{
		armies.AddItem( mTown.GetGarrisonArmy() );
	}

	if( mTown.GetVisitingArmy() != none && mTown.GetGarrisonArmy().GetHero().IsHero() )
	{
		armies.AddItem( mTown.GetVisitingArmy() );
	}

	return armies;
}

function bool CanHireWarUnit( H7AdventureArmy army )
{
	if( mWarUnit == none ) 
	{
		;
		return false;
	}

	/*
	if( army.HasWarUnitType( mWarUnit.GetWarUnitClass() ) )
	{
		`LOG_TOWN( army.GetHero().GetName()@"already has"@mWarUnit.GetName());
		return false; // already has this kind of warunit
	}
	*/

	if( !CanAffordWarUnit( army ) )
	{
		;
		return false; // not enough resources
	}

	return true;
}

function bool CanAffordWarUnit( H7AdventureArmy army )
{
	if( mWarUnit == none || army == none ) return false;

	return CanPlayerAffordWarUnit(army.GetPlayer());
}

function bool CanPlayerAffordWarUnit(H7Player player)
{
	return player.GetResourceSet().CanSpendResources( mWarUnit.GetUnitCost() );
}

function bool HireWarUnit( H7AdventureArmy army )
{
	if( !CanHireWarUnit( army ) ) return false;

	army.GetPlayer().GetResourceSet().SpendResources( mWarUnit.GetUnitCost() );
    army.AddWarUnitTemplate( mWarUnit );      

	;
	
	return true;
}

function InitTownBuilding( H7Town town )
{
	super.InitTownBuilding( town );

	mWarUnit = GetWarunitTemplate();
}

