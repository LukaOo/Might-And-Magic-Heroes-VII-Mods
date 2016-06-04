//=============================================================================
// H7EffectAddRandomBuffFromList
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectAddRandomBuffFromList extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);

var() bool mCheckVulnerability<DisplayName=Take Vulnerability Into Account>;
var() bool mRemoveCurrentDebuffs<DisplayName=Dont Add Debuff Twice>;
var() bool mFakeRandom<DisplayName=Use Fake Random Buff|ToolTip=Remember randomly chosen buff and target for this combat (works only for ONE random buff/target!)>;
var(Target) bool mUseOnAllTargets<DisplayName=Use On All Targets>;
var(Target) bool mUseRandomTarget<DisplayName=Use Random Target Creature|EditCondition=mUseOnAllTargets>;
var(Target) bool mUseOnlyAlliedCreatures<DisplayName=Use Only On Friendly Creatures|EditCondition=mUseOnAllTargets>;
var(Target) bool mUseOnlyOnCreatures<DisplayName=Use Only On Creatures|EditCondition=mUseOnAllTargets>;


var() array<H7BaseBuff> mBuffList<DisplayName=Buff List >;
var array<H7BaseBuff> mCurrentBuffList;
var array<H7BaseBuff> mCurrentVulnerabiltyBuffList;  
var int mCurrentRandomBuff, mCurrentRandomTarget;
var bool mHasFakeRandomNumbers;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<H7IEffectTargetable> targets,allAllyTargets,effectedTargerts, someTargets;
	local H7IEffectTargetable randomTarget;
	local int i,j;
	local bool success;

	if( isSimulated ) return;

	success = false;

	mCurrentRandomTarget = class'H7ReplicationInfo'.static.GetInstance().GetFakeRandomTarget();
	mCurrentRandomBuff = class'H7ReplicationInfo'.static.GetInstance().GetFakeRandomBuff();

	mHasFakeRandomNumbers = true;
	if( mCurrentRandomBuff < 0 && mCurrentRandomTarget < 0 ) mHasFakeRandomNumbers = false;

	;
	
	// Entropic Touch get targets with event raise
	// TODO this seems hardcoded
	if( effect.GetTrigger().mTriggerType == ON_ANY_ABILITY_ACTIVATE )
		effect.GetSource().SetTargets( container.TargetableTargets );
	
	if( mUseOnAllTargets )
	{
		effect.GetTargets( effectedTargerts );

		class'H7CombatController'.static.GetInstance().GetAllTargetable(targets);
		if( mUseOnlyAlliedCreatures )
		{
			for( i=0;i<targets.Length;++i)
			{
				if( class'H7Effect'.static.GetAlignmentType( none, targets[i] ) == AT_FRIENDLY )
				{
					if( mUseOnlyOnCreatures  ) 
					{
						if(  targets[i].isA('H7CreatureStack') )  
						{
							allAllyTargets.AddItem( targets[i] );
						}
					}
					else 
					{ 
						allAllyTargets.AddItem( targets[i] ); 
					}
				}
			}	

			// set new targets
			effect.GetSource().SetTargets( allAllyTargets );
		}
		
		

		if( mUseRandomTarget )
		{
			// clear targets 
			targets.Remove(0,targets.Length );
		
			for ( j=0; j<effectedTargerts.Length; ++j ) 
			{
				effect.GetTargets( someTargets );
				randomTarget = PickRandomCreature( someTargets );
				targets.AddItem( randomTarget );
				;
			}
		}

		;
	}
	else 
	{
		// check for conditions
		effect.GetTargets( targets );
	}
	
	if( effect.GetSource().IsAbility() && H7BaseAbility( effect.GetSource() ).IsPassive() ) 
	{
		H7BaseAbility( effect.GetSource() ).DoParticleFXCaster( effect.GetSource().GetCasterOriginal() );
	}

	if( effect.GetFx().mUseCasterPosition) 
	{
		effect.GetSource().GetCasterOriginal().GetEffectManager().AddToFXQueue( effect.GetFx(), effect );
		for(i=0;i<targets.Length;++i)
		{
			mCurrentBuffList = mBuffList;
			success = AddBuff(effect, targets[i]);
		}
	}
	else
	{
		for(i=0;i<targets.Length;++i)
		{
			mCurrentBuffList = mBuffList;
			success = AddBuff(effect, targets[i]);
			targets[i].GetEffectManager().AddToFXQueue( effect.GetFx(), effect );
		}
	}

	// remember successful numbers
	if( success )
	{
		class'H7ReplicationInfo'.static.GetInstance().SetFakeRandomBuff( mCurrentRandomBuff );
		class'H7ReplicationInfo'.static.GetInstance().SetFakeRandomTarget( mCurrentRandomTarget );
	}
}

function bool AddBuff( H7Effect effect, H7IEffectTargetable creature )
{
	local H7BaseBuff buff,debuff,buffToRemove;
	local array<H7BaseBuff> currentDebuffs;
	local H7ICaster caster;
	local array<EAbilitySchool> listOfVulnerabilitySchools;
	local bool NoImmunity;

	listOfVulnerabilitySchools.Remove( 0, listOfVulnerabilitySchools.Length );

	caster = effect.GetSource().GetCasterOriginal();
	;
	
	if( caster != none ) 
	{
		// remove all debuffs that are already app
		if( mRemoveCurrentDebuffs )
		{
			creature.GetBuffManager().GetActiveBuffs(currentDebuffs);

			foreach  currentDebuffs( debuff )
			{
				buffToRemove=none; 

				// only if its a debuff
				if( !debuff.IsDebuff() )
					continue;
				
				// EffectListBuff (archetype) vs BuffManagerBuff(instance)
				foreach mCurrentBuffList(buff)
				{
					if( buff.GetName() == debuff.GetName() )
						buffToRemove = buff;
				}

				// remove buff archetype
				if( buffToRemove != none ) 
				{
					;
					mCurrentBuffList.RemoveItem( buffToRemove );
				}
			}

		}

		// Check for vulnerability if necessary  -> create a list of buffs 
		if( mCheckVulnerability )
		{
			foreach mCurrentBuffList( buff )
			{
				if( creature.GetResistanceModifierFor( buff.GetSchool(), buff.GetTags() ) > 0  )
				{
					;
					mCurrentVulnerabiltyBuffList.AddItem( buff );
				}
			}
		}

		NoImmunity = false;
		// endless loop prevention check
		foreach mCurrentBuffList(buff)
		{
			if(creature.GetResistanceModifierFor( buff.GetSchool(), buff.GetTags() ) != 0.0f)
			{
				NoImmunity = true;
				break;
			}
		}
		if(!NoImmunity) 
		{
			;
			return false;
		}

		// picks buffs as long as it CurretnBuffList has buffs avaiable or choosen buff fits
		while( mCurrentBuffList.Length > 0 )
		{
			buff = none;
			
			if( mCheckVulnerability ) 
			{   
				// check all vulnerability related buffs
				while ( mCurrentVulnerabiltyBuffList.Length > 0 ) 
				{   
					buff = PickRandomBuffFromVulList();
			
					if( buff == none ) 
						break; 
					
					// found one
					if( mCurrentBuffList.Find( buff )  != -1 ) 
						break;
					
					// if not available then pick a new one 
					mCurrentVulnerabiltyBuffList.RemoveItem( buff );
					buff=none;
				}
			}

			if( buff == none ) 
				buff = PickRandomBuff(); 
			
			if( buff == none ) 
				break;

			;
			
			NoImmunity = creature.GetResistanceModifierFor( buff.GetSchool(), buff.GetTags() ) != 0.0f;
			if( NoImmunity )
				break;
		}

		if( buff != none )
		{
			if(buff.IsArchetype() && (buff.IsStackable() || buff.IsMultipleBuffable()))
			{
				buff = new buff.Class(buff);
				buff.Init(creature, caster);
			}
			creature.GetBuffManager().AddBuff( buff, caster, effect.GetSource() );
			return true;
		}
		else if( buff == none && !NoImmunity )
		{
			;
		}
		else
		{
			;
		}
	}

	return false;
}

function H7BaseBuff PickRandomBuffFromVulList()
{
	if( mCurrentVulnerabiltyBuffList.Length <= 0) 
		return none;

	if( !mHasFakeRandomNumbers || !mFakeRandom )
		mCurrentRandomBuff = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mCurrentVulnerabiltyBuffList.Length );
	
	return mCurrentVulnerabiltyBuffList[ mCurrentRandomBuff ];
}


function H7BaseBuff PickRandomBuff()
{
	if( mCurrentBuffList.Length <= 0) 
		return none;

	// fake random numbers were not initialized or are irrelevant -> get new random number
	if( !mHasFakeRandomNumbers || !mFakeRandom )
		mCurrentRandomBuff = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( mCurrentBuffList.Length );

	return mCurrentBuffList[ mCurrentRandomBuff ];
}

function H7IEffectTargetable PickRandomCreature( array<H7IEffectTargetable> units ) 
{
	if( units.Length <= 0 ) 
		return none;

	if( !mHasFakeRandomNumbers || !mFakeRandom )
		mCurrentRandomTarget = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt( units.Length );

	return units[ mCurrentRandomTarget ];
}

function String GetTooltipReplacement() 
{
	return class'H7Loca'.static.LocalizeSave("TTR_RANDOM_BUFF","H7TooltipReplacement");
}

