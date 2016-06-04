//=============================================================================
// H7EffectResetRandomBuffDuration
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectResetRandomBuffDuration extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var()bool mForConditions    <DisplayName=Reset for Condition>;
var()bool mForBuffs         <DisplayName=Reset for Buffs>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local int i,j;
	local array<H7IEffectTargetable> units; 
	local H7Unit unit;
	local H7BaseBuff modBuff;
	local array<H7BaseBuff> buffs,modifyBuffList;

	if( isSimulated ) return;

	;
	
	// get all targets you need 
	if( effect.GetTrigger().mTriggerType == ON_ANY_ABILITY_ACTIVATE )
		effect.GetSource().SetTargets( container.TargetableTargets );

	effect.GetTargets( units );

	for( i=0; i<units.Length; ++i )
	{
		// fishy but be sure use a Unit
		unit = H7Unit( units[i] );
		unit.GetBuffManager().GetVisibleMagicBuffs(buffs);
		
		for( j=0; j<buffs.Length; ++j ) 
		{
			if ( mForBuffs && !buffs[j].IsDebuff() )     {	modifyBuffList.AddItem( buffs[j] ) ; }
		    if ( mForConditions && buffs[j].IsDebuff() ) {	modifyBuffList.AddItem( buffs[j] ) ; }
		}

		if( modifyBuffList.Length > 0 ) 
		{
			modBuff = PickRandomBuff( modifyBuffList );
			modBuff.SetCurrentDuration( modBuff.GetDuration() ); // TODO MODIFY this by Elemental Endurance ability
		}
	}
}


function H7BaseBuff PickRandomBuff( array<H7BaseBuff> buffs )
{
	if( buffs.Length <= 0) 
		return none;

	return buffs[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( buffs.Length - 1 ) ];
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_RESET_BUFF_DURATION","H7TooltipReplacement");
}
