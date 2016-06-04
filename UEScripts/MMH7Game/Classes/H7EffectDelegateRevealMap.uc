//=============================================================================
// H7EffectDelegateRevealMap
//
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectDelegateRevealMap extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var(Effect,Properties) protected int mRevealRadius<DisplayName=Reveal Radius|ClampMin=1>;

var protected H7AdventureHero mActiveHero;
var protected H7HeroAbility mSourceAbility;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<EPlayerNumber> allies;
	local H7EffectContainer effectContainer;
	local H7AdventureMapGridController gridCtrl;
	local H7AdventureMapCell gridCell;
	local H7FOWController fogCtrl;
	local H7IEffectTargetable target;
	local array<IntPoint> visiblePoints;
	local H7ICaster caster;
	local int i;


	if( isSimulated ) return;

	effectContainer = effect.GetSource();
	
	caster = effectContainer.GetCaster().GetOriginal();
	mSourceAbility = H7HeroAbility( effectContainer );
	mActiveHero = H7AdventureHero( caster );
	if( mActiveHero == none || mSourceAbility == none ) return;

	// the target must be a cell
	target=mSourceAbility.GetTarget();
	gridCell=H7AdventureMapCell( target );
	if( gridCell == none )
	{
		gridCtrl = class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( Actor( target ).Location ).GetGridOwner();
		gridCell = gridCtrl.GetCell( target.GetGridPosition().X, target.GetGridPosition().Y );
	}
	else
	{
		gridCtrl=gridCell.GetGridOwner();
	}
	if( gridCtrl==None ) return;
	fogCtrl=gridCtrl.GetFOWController();
	if( fogCtrl==None ) return;

	class'H7Math'.static.GetMidPointCirclePoints( visiblePoints, gridCell.GetCellPosition(), mRevealRadius);

	class'H7TeamManager'.static.GetInstance().GetAllAlliesAndSpectatorNumbers( mActiveHero.GetPlayer().GetPlayerNumber(), allies );
	allies.AddItem( mActiveHero.GetPlayer().GetPlayerNumber() );

	for( i = 0; i < allies.Length; ++i )
	{
		fogCtrl.HandleExploredTiles( allies[i], visiblePoints );
	}
	fogCtrl.ExploreFog();
}

function String GetTooltipReplacement() 
{
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_REVEAL_ZONE","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%value", mRevealRadius);

	return ttMessage;
}

function String GetDefaultString()
{
	return class'H7GameUtility'.static.FloatToString(mRevealRadius);
}
