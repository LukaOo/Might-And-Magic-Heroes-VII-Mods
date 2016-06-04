//=============================================================================
// H7EffectSpecialKill
// Avada Kedavra 
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialKill extends Object implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets;
	local H7IEffectTargetable target;

	if( isSimulated )
	{
		return;
	}

	effect.GetTargets( targets );

	foreach targets( target )
	{
		switch( target.GetEntityType() )
		{
				case UNIT_HERO:      
					break;
				case UNIT_CREATURESTACK:
					H7CreatureStack( target ).Kill();
					break;
				case UNIT_WARUNIT:              
					H7WarUnit( target ).SetDestroyed();
					break;
				case UNIT_TOWER:                      
					//H7TowerUnit( target )
					break;
				case ENTITY_TYPE_ADV_BUILDING:
					break;
				case ENTITY_TYPE_CELL:                            
					break;
				case ENTITY_TYPE_OBSTACLE:                        
					break;
				case ENTITY_TYPE_ADV_GRID:                        
					break;
				case ENTITY_TYPE_COMBAT_GRID:                     
					break;
				case ENTITY_TYPE_PLAYER:                          
					break;
				case ENTITY_TYPE_TOWN:                            
					break;
				case ENTITY_TYPE_FORT:                            
					break;
				case ENTITY_TYPE_DWELLING:                        
					break;
				case ENTITY_TYPE_MINE:                            
					break;
				case ENTITY_TYPE_ADVENTURE_OBJECT:                
					break;
				case ENTITY_TYPE_TOWN_BUILDING:                   
					break;
		}
	}
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_KILL_EFFECT","H7TooltipReplacement");
}
