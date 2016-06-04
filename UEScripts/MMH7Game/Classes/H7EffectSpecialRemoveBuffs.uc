//=============================================================================
// H7EffectSpecialRemoveBuffs
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialRemoveBuffs extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


/** Choose a random buff/debuff for removal. */
var(RemoveAllBuffs) bool mRemoveRandom            <DisplayName=Remove Random Buff>;
/** Amount of random buff that will be removed from the target. */
var(RemoveAllBuffs) int mAmount                   <DisplayName=Amount of Buffs to Remove|EditCondition=mRemoveRandom>;
/** Don't remove buffs, only debuffs. */
var(RemoveAllBuffs) bool mRemoveDebuff            <DisplayName=Remove Debuff(s)>;
/** Remove Buff by Ability School. */
var(RemoveAllBuffs) bool mBySchool                <DisplayName=Remove By School>; 
var(RemoveAllBuffs) EAbilitySchool mRemoveSchool  <DisplayName=School|EditCondition=mBySchool>;
/** Don't remove random buffs, just remove every buffs that was applied by spells or other magic sources. */
var(RemoveAllBuffs) bool mAllMagicSource          <DisplayName=Remove All Buffs From Magic Source|EditCondition=!mRemoveRandom>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local int i,j,a;
	local array<H7IEffectTargetable> targets;
	local array<H7BaseBuff> creatureBuffs,removeableBuffs; 

	if( isSimulated ) { return; }

	
	// Elemental cleansing gets targets with event raise
	// TODO this seems hardcoded
	if( effect.GetTrigger().mTriggerType == ON_ANY_ABILITY_ACTIVATE )
	{
		effect.GetSource().SetTargets( container.TargetableTargets );
	}
	
	effect.GetTargets( targets );
	
	for( i=0;i<targets.Length;++i)
	{
		if( targets[i] == none ) 
		{
			continue;
		}

		targets[i].GetBuffManager().GetVisibleMagicBuffs(creatureBuffs);

		for( j=0;j<creatureBuffs.Length;++j)
		{
			if( mRemoveDebuff && creatureBuffs[j].IsDebuff() ) { removeableBuffs.AddItem( creatureBuffs[j] ); }
			else if( !mRemoveDebuff)                           { removeableBuffs.AddItem( creatureBuffs[j] ); }
		}
	
		if(mRemoveRandom)
		{
			// pick amount $mAmount random buffs and remove them
			for(a=0; a<mAmount; ++a)
			{
				targets[i].GetBuffManager().RemoveBuff( PickARandomBuff( removeableBuffs ) );
			}
		}
		else if(mAllMagicSource)
		{
			// remove all buffs from magic sources
			for(a=0; a<removeableBuffs.Length; ++a)
			{
				targets[i].GetBuffManager().RemoveBuff( removeableBuffs[a] );
			}
		}
		else
		{   
			if( mBySchool )
			{
				// remove all buffs from school 
				targets[i].GetBuffManager().RemoveAllDisplayableBuffsBySchool( mRemoveSchool );
			}
			else 
			{
				// remove everything
				targets[i].GetBuffManager().RemoveAllDisplayableBuffs( mRemoveDebuff );
			}
		}
	}
}

function H7BaseBuff PickARandomBuff( array<H7baseBuff> buffs ) 
{
	if( buffs.Length <= 0 )
	{
		return none;
	}

	return buffs[ class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( buffs.Length ) ];

}

function String GetDefaultString()
{
	return String(mAmount);
}

function String GetTooltipReplacement() 
{
	return Repl(class'H7Loca'.static.LocalizeSave("TTR_REMOVE_BUFFS","H7TooltipReplacement"),"%amount",mAmount);
}

