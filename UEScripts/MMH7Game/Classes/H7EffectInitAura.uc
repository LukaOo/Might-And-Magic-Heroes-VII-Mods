//=============================================================================
// H7EffectInitAura
//
// 
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectInitAura extends H7Effect;

var H7EffectProperties mData;

event bool ShowInTooltip()           { return !mData.mDontShowInTooltip; }

event InitSpecific(H7EffectProperties data,H7EffectContainer source,optional bool registerEffect=true)
{
	InitEffect(data, source,registerEffect);
	mData = data;
}

protected event Execute(optional bool isSimulated = false)
{
	local array<H7IEffectTargetable> targets, validTargets;
	local H7IEffectTargetable target;
	local array<IntPoint> points;
	local IntPoint point, casterPosition;
	local H7CombatMapGridController cmbtCntl;
	local H7AdventureGridManager advntMngr;
	local H7ICaster caster;
	local ECellSize cellSize;
	local H7AuraInstance auraInst;
	local H7EventContainerStruct container;
	local H7CombatMapCell cmbtCell;
	local array<H7Effect> effects;
	local H7AdventureMapCell advCell;
	
	local int gridX, gridY;
	
	if( isSimulated )
	{
		return;
	}

	/* TODO don't init auras during tactics phase; else either the auras fuck up or the game crashes ->
	 refactor and optimize aura updating for tactics
	 */
	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()
		&& class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().IsInNonCombatPhase()
		&& mData.mTrigger.mTriggerType == ON_ENTER_CELL)
	{
		return;
	}

	caster = H7BaseAbility(GetSource()).GetCaster().GetOriginal();

	if( !H7BaseAbility(GetSource()).GetAuraProperties().mUpdateOnStep && H7Unit( caster ) != none && H7Unit( caster ).IsMoving() ) 
	{
		return;
	}

	cmbtCntl = class'H7CombatMapGridController'.static.GetInstance();
	advntMngr = class'H7AdventureGridManager'.static.GetInstance();

	if( H7AdventureHero( caster ) != none )
	{
		advCell = H7AdventureHero( caster ).GetCell();
	}
	else if( H7VisitableSite( caster ) != none )
	{
		advCell = H7VisitableSite( caster ).GetEntranceCell();
	}
	else
	{
		if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
		{
			advCell = advntMngr.GetCell( caster.GetOriginal().GetGridPosition().X, caster.GetOriginal().GetGridPosition().Y );
		}
		else
		{
			advCell = none;
		}
	}
	

	if( H7BaseAbility(GetSource()).IsPassive() )
	{
		casterPosition = caster.GetGridPosition();

		if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			gridX = cmbtCntl.GetCombatGrid().GetXSize();
			gridY = cmbtCntl.GetCombatGrid().GetYSize();

			//TODO other dimensions ?
			cellSize = caster.IsA('H7Unit') ? H7Unit( caster ).GetUnitBaseSize() : CELLSIZE_1x1;
		}
		else
		{
			gridX = advntMngr.GetCurrentGrid().GetGridSizeX();
			gridY = advntMngr.GetCurrentGrid().GetGridSizeY();
			
			//TODO other dimensions ?
			cellSize = CELLSIZE_1x1;
		}

		switch( H7BaseAbility( mSourceOfEffect ).GetTargetType() )
		{
			case TARGET_AREA:
				class'H7Math'.static.GetPointsFromDimensions( points, casterPosition, H7BaseAbility( mSourceOfEffect ).GetTargetArea(), gridX, gridY, cellSize );
				break;
			case TARGET_CUSTOM_SHAPE:
				 class'H7Math'.static.GetPointsFromShape( points, casterPosition, H7BaseAbility( mSourceOfEffect ).GetShape(), gridX, gridY, cellSize );
				break;
			case NO_TARGET:
				GetValidTargets( targets, validTargets );
				targets = validTargets;
				
				break;
			case TARGET_SINGLE:
				points.AddItem( casterPosition );
				break;
			case TARGET_AOC:
				if( class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap() )
				{
					if( GetEventContainer().Targetable == none )
					{
						point = GetSource().GetCaster().GetOriginal().GetGridPosition();
					}
					else
					{
						point = GetEventContainer().Targetable.GetGridPosition();
						if( H7AdventureHero( GetEventContainer().Targetable ) != none )
						{
							advCell = H7AdventureHero( GetEventContainer().Targetable ).GetCell();
						}
						else if( H7VisitableSite( GetEventContainer().Targetable ) != none )
						{
							advCell = H7VisitableSite( GetEventContainer().Targetable ).GetEntranceCell();
						}
						else
						{
							advCell = advntMngr.GetCell( point.X, point.Y );
						}
					}

					advntMngr.GetAoCPointsByIntPoint( point, advntMngr.GetAoCIndexOfCell( advCell ), points );
				}
				break;
			case TARGET_ELLIPSE:
				 class'H7Math'.static.GetPointsOnEllipse( points, casterPosition, H7BaseAbility( mSourceOfEffect ).GetTargetArea().X, H7BaseAbility( mSourceOfEffect ).GetTargetArea().Y );
				 break;
			default:
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(H7BaseAbility( mSourceOfEffect ).GetTargetType()@"not implemented yet!"@self,MD_QA_LOG);;
				;
				break;
		}
	}
	else
	{ 
		GetTargets( targets );
	}

	if( points.Length == 0 )
	{
		foreach targets( target )
		{
			
			if( target != none )
			{
				point = target.GetGridPosition();
				
				if( point.X >= 0 && point.Y >= 0 && !class'H7GameUtility'.static.CellsContainIntPoint( points, point ) )
				{
					points.AddItem( point );
				}
			}
		}
	}
	
	if( points.Length == 0 ) return;

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		auraInst = class'H7AuraManager'.static.CreateAuraInstance( H7BaseAbility( GetSource() ), points );
		cmbtCntl.GetAuraManager().AddAura( auraInst, H7BaseAbility(GetSource()).GetAuraProperties().mUpdateOnStep );
	}
	else
	{
		auraInst = class'H7AuraManager'.static.CreateAuraInstance( H7BaseAbility( GetSource() ), points );
		advCell.GetGridOwner().GetAuraManager().AddAura( auraInst, H7BaseAbility(GetSource()).GetAuraProperties().mUpdateOnStep );
	}

	if( mData.mFX.mVFX != none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap()
		&& !class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().IsInNonCombatPhase() )
	{
		foreach points( point )
		{
			if( !cmbtCntl.GetCombatGrid().GetCellByIntPoint(point).HasCreatureStack() || ( GetSource().IsA('H7BaseAbility') && !H7BaseAbility(GetSource()).IsPassive() ))
			{
				cmbtCell = cmbtCntl.GetCombatGrid().GetCellByIntPoint(point);
				
				if( cmbtCell != none ) 
				{
					effects = auraInst.mAuraAbility.GetAllEffects();
					cmbtCntl.GetEffectManager().AddToFXQueue( mData.mFX, effects[0], ,, cmbtCell.GetOriginalLocation(), true );
				}
			}
		}
	}

	GetTagsPlusBaseTags( container.ActionTag );
	container.EffectContainer = GetSource();
	container.Targetable = GetSource().GetTarget();

	GetSource().GetEventManager().Raise( ON_AURA_INIT, false, container );
}
