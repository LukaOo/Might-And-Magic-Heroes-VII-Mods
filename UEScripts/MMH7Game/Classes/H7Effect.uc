//=============================================================================
// H7Effect
//
// - baseclass for everything that is statmod,resmod,damage
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7Effect extends Object
	native(Tussi);

//var protected H7EffectProperties mProperties;
// formerly known as properties
var protected ESkillRank					mRank;  
var protected int							mGroup;
var protected array<ESpellTag>				mEffectTags;		
var protected EEffectTarget					mEffectTarget;                      
var protected H7TriggerStruct				mTrigger;                 
var protected H7ConditionStruct				mConditions;
var protected H7FXStruct					mFX;

/*buff,spell,item,skill or cell*/
var protected H7EffectContainer				mSourceOfEffect;

var protected H7Unit						mCaster;
var protected H7IEffectTargetable			mTarget;
var protected H7EventContainerStruct		mEventContainer;
var protected H7IEffectTargetable			mTargetOverwrite;
var protected bool							mRemovedDuringExecution;

var protected H7EffectContainer				mTooltipBuffInstance;
var protected array<H7IEffectTargetable>	mTempTargets;


var protected bool							mIsBeingExecuted;

function H7EffectContainer					GetSource()												{ return mSourceOfEffect; }
function H7TriggerStruct					GetTrigger()											{ return mTrigger; } 
function ESkillRank							GetRequiredRank()										{return mRank; }
function H7FXStruct							GetFx()													{ return mFX;}
function array<ESpellTag>					GetTags()												{ return mEffectTags; }
function H7ConditionStruct					GetConditons()											{return mConditions; }
function									SetUnitTargetOverwrite( H7IEffectTargetable target )	{ mTargetOverwrite = target; } 
function									SetEventContainer( H7EventContainerStruct container )	{ mEventContainer = container; } 
function H7EventContainerStruct				GetEventContainer()	                                    { return mEventContainer; }
event bool								    ShowInTooltip()	                                        { }
function EEffectTarget						GetTargetEnum()                                         {return mEffectTarget; }
function int								GetGroup()                                              { return mGroup; }
function array<H7IEffectTargetable>         GetCachedTargets()	                                    { return mTempTargets; }
function                                    ClearCachedTargets()                                    { mTempTargets.Length = 0; }
native function float					    GetChance();
function									ClearTooltipContainerInstance()
{
	if( mTooltipBuffInstance == none ) return;
	mTooltipBuffInstance.DeleteAllInstanciatedEffects();
	mTooltipBuffInstance = none;
}

function InitEffect(H7EffectProperties properties,H7EffectContainer source,bool registerEffect)
{
	local ESpellTag tag;

	mRank = properties.mRank;
	mGroup = properties.mGroup;
	mEffectTarget = properties.mTarget;
	mTrigger = properties.mTrigger;
	mConditions = properties.mConditions;
	mFx = properties.mFX;
	mEffectTags = properties.mTags;

	
	mSourceOfEffect = source;
	
	// Buffs in spellbook are archetypes and don't need registered effects
	if(!mSourceOfEffect.IsArchetype() && registerEffect)
	{
		RegisterTrigger();
	}
	
	foreach mEffectTags(tag)
	{
		if(tag == TAG_MAX) class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(mSourceOfEffect.GetDebugName() @ "has an effect with a corrupted tag" @ self,MD_QA_LOG);;
	}

	if( mTrigger.mChance == 0 )
	{
		mTrigger.mChance = 100;
	}
}
 
// i.e. ATTACK_START, MOVE_START, GET_ATTACKED 
native function EventListener(Object sender, bool isSimulated, H7EventContainerStruct container );

native function TriggerEffect( bool isSimulated );

// prevents endless recursion loops
native function ExecuteSave( optional bool isSimulated = false );

protected event Execute(optional bool isSimulated = false)
{
	// ... implement in children
}

native function GetTargetsByEffectTarget( out array<H7IEffectTargetable> targets, optional EEffectTarget effectTarget = mEffectTarget );

native function GetValidTargets( out array<H7IEffectTargetable> targets, out array<H7IEffectTargetable> validTargets, optional bool ignoreImmunity = false);

static native function bool DoOperationBool( EOperationBool op, INT valueA, INT valueB );


static native function bool ConditionCheckOnArchetype( H7ConditionStruct conditions, H7IEffectTargetable target, H7ICaster initiator, H7ICaster owner, H7ICaster caster, H7EventContainerStruct eventContainer, bool targetCheckOnly, bool isStatEffect, bool isPersistentStatEffect, bool isTeleportSpell, int teleportSpellRange );
static native function bool CasterConditionCheckOnArchetype( H7CasterConditionStruct condition, H7ICaster initiator, H7ICaster itemOwner, H7ICaster buffOwner );
static native function bool TargetConditionCheckOnArchetype( H7ConditionStructExtendedTarget condition, H7IEffectTargetable target, H7ICaster initiator, H7ICaster caster, H7ICaster owner, bool isPersistentStatEffect );
static native function bool AttackConditionCheckOnArchetype( H7ConditionStructExtendAttack condition, H7EventContainerStruct eventContainer, H7ICaster initiator, H7ICaster owner, H7ICaster caster, bool isPersistentStatEffect );
static native function bool IsPreventedByImmunityOfOnArchetype( H7IEffectTargetable target, H7SpellEffect data, array<ESpellTag> tags, EAbilitySchool abilitySchool, bool isSpellEffect );

native function bool ConditionCheck(H7IEffectTargetable target, H7ICaster initiator, bool targetCheckOnly);
native function bool CasterConditionCheck( H7ICaster initiator );
native function bool TargetConditionCheck( H7IEffectTargetable target, H7ConditionStructExtendedTarget condition, H7ICaster initiator, H7ICaster caster );
native function bool AttackConditionCheck();


native function static EAlignmentType GetAlignmentType( H7ICaster caster, H7IEffectTargetable target );

/** only Immunity check 
 *  - does not check condition
 *  - does not check if the effect is even active (due to caster rankcheck)
 *  */
native function bool IsPreventedByImmunityOf( H7IEffectTargetable target );


native function bool RankCheck( H7ICaster unit );

native function bool CompareRank( ESkillRank myRank, optional ESkillType skillType = SKT_NONE );

native function bool CheckMagicSynergy(H7ICaster attacker, H7IEffectTargetable target);

native function GetTargets( out array<H7IEffectTargetable> targets, optional bool ignoreImmunity = true );

native function protected SetAreaAroundXTargets( out array<H7IEffectTargetable> targets, EEffectTarget effectTarget );

function H7CombatResult GenerateCombatAction(optional H7CombatResult baseCombatAction )
{
	//local array<H7IEffectTargetable> targets;
	local H7CombatResult action;
	local array<H7Effect> effects;
	local H7ICaster attacker, caster;
	local H7UnitSnapShot attackerSnapShot;
	local bool fromScroll;

	GetTargets( mTempTargets );

	;
	
	if( mTempTargets.Length == 0)
		 ;

	if(baseCombatAction != none) action = baseCombatAction;
	else action = new class'H7CombatResult';

	action.SetCurrentEffect( self );
	effects.AddItem(self);
	action.SetEffects(effects);
	fromScroll = H7BaseAbility( mSourceOfEffect ) != none && H7BaseAbility( mSourceOfEffect ).IsFromScroll();
	attacker = mSourceOfEffect.GetInitiator();
	if(mSourceOfEffect.IsA('H7HeroItem') || fromScroll )
	{
		// unequipped items tend to have no initiator, so fake one
		// to avoid game crashes (remove this line and i will punch you)
		if(attacker == none) attacker = mSourceOfEffect.GetOwner();
	}
			
	if( H7UnitSnapShot( attacker ) != none )
	{
		attackerSnapShot = attackerSnapShot;
	}
	else
	{
		if( mSourceOfEffect.GetCaster() != none && action.GetAttacker() != none && mSourceOfEffect.GetCaster().GetOriginal() == action.GetAttacker().GetOriginal() )
		{
			caster = mSourceOfEffect.GetCaster();
			if( H7UnitSnapShot( caster ) != none )
			{
				attackerSnapShot = H7UnitSnapShot( caster );
				attackerSnapShot.UpdateSnapShot();
			}
		}

		if( attackerSnapShot == none || attackerSnapShot.GetOriginal() == none )
		{
			attackerSnapShot = new class'H7UnitSnapShot';
			attackerSnapShot.TakeSnapShot(attacker);
		}
	}

	if( fromScroll )
	{
		attackerSnapShot.SetMagic( mSourceOfEffect.SCROLL_MAGIC_POWER );
	}
	
	action.SetAttacker( attackerSnapShot );

	return action;
}

// atm:
// effects of passive abilites have to register at ability
// effects of active abilities/spells have to register at spell
// effects of skills register at unit
// effects of buffs have to register at target-unit*
// effects of items have to register at items
// *unit can be target or caster
native function RegisterTrigger();

// can be unit (hero,stack) or effectcontainer (ability,buff,item,skill)
native function H7IEventManagingObject GetRegistrator();

native function UnregisterTrigger();

native function bool HasTag( ESpellTag searchTag );

native function GetTagsPlusBaseTags( out array<ESpellTag> tags );










// -----------------------------------------------------------------------------------------------------------
// --------------------------------- Everything below is GUI (tooltips) --------------------------------------
// -----------------------------------------------------------------------------------------------------------
function string             GetProperty(string prop,optional ESkillRank considerOnlyEffectsOfRank = SR_ALL_RANKS, optional H7UnitSnapShot myCaster)
{
	local H7EffectContainer tmpEffectContainer,effectContainerArchetype;
	local string resolveStr,recPlaceholder,tmpValue;
	local H7IEffectDelegate delegate;
	local int nr;

	//`log_dui("      GetProperty" @ self @ prop);

	// trim last "."
	if(InStr(prop,".",false,true,Len(prop)-1) != INDEX_NONE)
	{
		prop = Left(prop,Len(prop)-1);
	}

	switch(prop)
	{
		// design requests:
		case "":return GetDefaultString();
		case "chance":return string(int(GetChance()*100));
		case "min":return GetMinString();
		case "max":return GetMaxString();
		case "mincap":return GetMinCap();
		case "maxcap":return GetMaxCap();
		case "icon":return GetIconString();
		case "norm":case "absval":return GetAbsValueAsString();
		// bonus:
		case "name":return GetName();
		case "val":return GetValueAsString();
		case "val1":
		case "val2":
		case "val3":
			nr = int(Right(prop,1));
			if(H7EffectSpecial(self) != none)
			{
				delegate = H7EffectSpecial(self).GetFunctionProvider();
				if(H7EffectSpecialShieldEffect(delegate) != none) 
					return H7EffectSpecialShieldEffect(delegate).GetValue(nr);
				if(H7EffectSpecialPushback(delegate) != none)
					return H7EffectSpecialPushback(delegate).GetValue(nr);
				if(H7EffectSpecialInitialDamageReduction(delegate) != none)
					return H7EffectSpecialInitialDamageReduction(delegate).GetValue(nr);
				if(H7EffectSpecialModifiedDamageOverTime(delegate) != none)
					return H7EffectSpecialModifiedDamageOverTime(delegate).GetValue(nr);
				if(H7EffectSpecialConditionalStatMod(delegate) != none)
					return H7EffectSpecialConditionalStatMod(delegate).GetValue(nr);
				if(H7EffectSpecialModifyManaCost(delegate) != none)
					return H7EffectSpecialModifyManaCost(delegate).GetValue(nr);
				if(H7EffectSpecialNecromancy(delegate) != none)
					return H7EffectSpecialNecromancy(delegate).GetValue(nr);
				if(H7EffectSpecialSummonCreatureStack(delegate) != none)
				{
					// set temporary caster so the internal SpellScaling function will work
					H7EffectSpecialSummonCreatureStack(delegate).SetCaster( myCaster );
					
					tmpValue = H7EffectSpecialSummonCreatureStack(delegate).GetValue(nr);

					// unset caster to prevent game crashes
					H7EffectSpecialSummonCreatureStack(delegate).SetCaster( none );
					return tmpValue;
				}
			}
			return "?";
		case "desc":
		case "short":return GetTooltipReplacement();
		case "tt":
		case "long":return GetTooltipLine();
		default:
			// recursion OPTIONAL better
			if( Left(prop,4) == "buff" || Left(prop,5) == "spell") // looking inside %buff or %spell 
			{
				if(H7EffectWithSpells(self).GetData().mSpellStruct.mSpell != none)
				{
					if( mTooltipBuffInstance == none )
					{
						effectContainerArchetype = H7EffectWithSpells(self).GetData().mSpellStruct.mSpell;
						tmpEffectContainer = new effectContainerArchetype.Class(effectContainerArchetype);

						// if ability applies buff, use buff duration in ability-tooltip
						if(H7BaseBuff(tmpEffectContainer) != none)
						{
							//`log_dui(tmpEffectContainer.GetName() @ "buff temporarily instanciating for tooltip while asking for" @ prop);
							H7BaseBuff(tmpEffectContainer).Init(GetSource().GetTarget(),myCaster != none ? H7ICaster( myCaster ) : GetSource().GetInitiator(),true);
							//`log_dui("with duration" @ H7BaseBuff(tmpEffectContainer).GetCurrentDuration());
							//AddRepl("%t",String(H7BaseBuff(tmpEffectContainer).GetDuration()));
						}
						else
						{
							tmpEffectContainer.SetCaster( myCaster != none ? H7ICaster( myCaster ) : GetSource().GetInitiator() );
							tmpEffectContainer.InstanciateEffectsFromStructData();
						}

						mTooltipBuffInstance = tmpEffectContainer;
						mTooltipBuffInstance.SetRankOverride( mSourceOfEffect.GetRankOverride() );
					}

					// buff => 
					// buff.tt => %tt
					// buff.durini => %durini
					if(Left(prop,4) == "buff")
					{
						recPlaceholder = Mid(prop,4,Len(prop));
					}
					else
					{
						recPlaceholder = Mid(prop,5,Len(prop));
					}

					if(Left(recPlaceholder,1) == ".") // preceding dot?
					{
						recPlaceholder = "%" $ Mid(recPlaceholder,1,Len(recPlaceholder));
					}
					resolveStr = mTooltipBuffInstance.ResolvePlaceholder(recPlaceholder,true,considerOnlyEffectsOfRank, myCaster);
					//mTooltipBuffInstance.DeleteAllInstanciatedEffects(); // will be done by effectcontainer when tooltip is built
					return resolveStr;
				}
			}
			; 
	}
	return prop;
}

function String GetLocaNameForTrigger(ETrigger h7trigger)
{
	return LocalizeFailSafe(String(h7trigger));
}

function String GetLocaNameForSpellOperation(ESpellOperation op)
{
	return LocalizeFailSafe(String(op));
}

function String LocalizeFailSafe(String locaKey)
{
	local String localizedString;

	localizedString = class'H7Loca'.static.LocalizeSave(locaKey,"H7Abilities");
	
	if(class'H7Loca'.static.LocalizeFailed(localizedString)) 
	{
		localizedString = "[" $ locaKey $ "]";
		;
	}

	return localizedString;
}

// long version
// i.e: [If Novice: ][On Getting Attacked: ][casterconditions][10% Chance: ][+10 Initiative to Target][ to target with some condition]
// used in:
// - spell debug tooltip
// - attack tooltip attack effects
// - attack tooltip triggered effects
// OPTIONAL - hide trigger
// OPTIONAL - hide target 
function String GetTooltipLine(optional bool extendedVersion=false,optional H7IEffectTargetable actualTarget,optional bool showRank=false,optional bool showCause=false)
{
	local String tooltip,ttMessage;
	local int chance;
	local ETrigger event;
	local H7ICaster caster;
	local H7IEventManagingObject registrator;
	local EAlignmentType alignment;
	local EOperationBool op;

	tooltip = "";

	// rank
	if(showRank && mRank != SR_ALL_RANKS)
	{
		tooltip = tooltip $ "If" @ LocalizeFailSafe(String(mRank)) $ ": ";
	}
	
	// cause and trigger
	event = mTrigger.mTriggerType;
	switch(event)
	{
		 // skip cause and trigger for these triggers 
		case ON_SELF_ABILITY_ACTIVATE:break;
		default:

		// who / actor / cause (item/unit/hero/ability) / initiator or registrator ?
		if(showCause)
		{
			registrator = GetRegistrator();
			tooltip = tooltip $ "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ H7EffectContainer(registrator).GetInitiator().GetName() $ "'s " $ registrator.GetName() $ "</font> ";
		}

		// trigger
		tooltip = tooltip $ GetLocaNameForTrigger( mTrigger.mTriggerType) $ ": ";
	}
	

	// chance
	if( (mTrigger.mChance != 100) || mTrigger.mUseLuckRoll)
	{
		if( mTrigger.mUseLuckRoll) 
		{
			caster = mSourceOfEffect.GetCasterOriginal();
			chance = caster.IsA('H7Unit') ? H7Unit(caster).GetLuckDestiny() : 100; // TODO or GetOwner() or getTarget()
		}
		else
		{
			chance = mTrigger.mChance;
		}

		tooltip = tooltip $ Repl(class'H7Loca'.static.LocalizeSave("TT_CHANCE","H7Effect"),"%chance",chance) $ ": ";
	}


	// effect - inserts short version here
	tooltip = tooltip $ self.GetTooltipReplacement();

	// target
	if(self.mEffectTarget != TARGET_DEFAULT)
	{
		if(actualTarget == none)
		{
			tooltip = tooltip @ class'H7Loca'.static.LocalizeSave("TT_TO","H7Effect") 
				@ "<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ class'H7Loca'.static.LocalizeSave(String(self.mEffectTarget),"H7Abilities")  $ "</font>";
			//														String(self.mTarget)
			//                                                      String(H7EffectCommand(self).GetData().mTarget)
			//                                                      TODO difference here between those targets?
			//                                                      TODO resolve to actual attacker name if possible
			
			// TODO all conditions

			// hostile/friendly
			if(GetConditons().mExtendedTargetParameters.UseUnit)
			{
				op = GetConditons().mExtendedTargetParameters.UAOperation;
				alignment = GetConditons().mExtendedTargetParameters.UAAlignment;
				tooltip = tooltip @ class'H7Loca'.static.LocalizeSave(String(op),"H7Abilities") @ class'H7Loca'.static.LocalizeSave(String(alignment),"H7Abilities");
			}

			// [not] has buff
			if(self.GetConditons().mExtendedTargetParameters.CTBuff != none)
			{
				op = GetConditons().mExtendedTargetParameters.BuffOp;
				if(op == OP_TYPE_BOOL_EQUAL) tooltip = tooltip @ class'H7Loca'.static.LocalizeSave("TT_GOT_BUFF","H7Effect");
				if(op == OP_TYPE_BOOL_NOTEQUAL) tooltip = tooltip @ class'H7Loca'.static.LocalizeSave("TT_GOT_NOT_BUFF","H7Effect");
				
				tooltip = tooltip @	"<font color='" $ class'H7TextColors'.static.GetInstance().UnrealColorToHTMLColor(class'H7TextColors'.static.GetInstance().mReplacementColor) $ "'>" $ self.GetConditons().mExtendedTargetParameters.CTBuff.GetName() $ "</font>";
				if(self.GetConditons().mExtendedTargetParameters.CTBuff.IsMultipleBuffable())
				{
					if(mSourceOfEffect.GetCaster() == none)
					{
						tooltip = tooltip @ class'H7Loca'.static.LocalizeSave("TT_SAME_CASTER_UNKNOWN","H7Effect");
					}
					else
					{
						Localize("H7Effect", "TT_SAME_CASTER", "MMH7Game" );
						ttMessage = Repl(ttMessage, "%target", mSourceOfEffect.GetCaster().GetName());
						tooltip = tooltip @ ttMessage;
					}
				}
			}
		}
		else
		{
			tooltip = tooltip @ class'H7Loca'.static.LocalizeSave("TT_TO","H7Effect") @ actualTarget.GetName();
		}
	}
	else
	{
		//tooltip = tooltip @ "to default";
	}

	return tooltip;
}


// super-short version = only operation
// i.e. +,*,= , 0 , used for Messages to merge them
function String GetOperation()
{
	local EOperationType op;
	if(H7EffectOnStats(self) != none)
	{
		op = H7EffectOnStats(self).GetData().mStatMod.mCombineOperation;
		return GetOperationString(op,GetValue());
	}
	else
	{
		;
		return "?";
	}
}

static function string GetOperationString(EOperationType op,float value)
{
	switch(op)
	{
		case OP_TYPE_ADD:if(value < 0) return ""; else return "+";
		case OP_TYPE_MULTIPLY:return "*";
		case OP_TYPE_SET:return "=";
		case OP_TYPE_ADDPERCENT:return "+%"; // OPTIONAL negative numbers and encapsulated numbers "+[30]%"
		default:return String(op);
	}
}

// super-short version = only value
// i.e. 10 , 0 , -2 
// - used for Messages to merge (add) them
// - also logs/float texts
// - and now also the new replacement system for .val (%durini.val %durmod.val %stat.val ...) // which does not make sense, since it needs to be humanreadable in this case
function float GetValue()
{
	if(H7EffectOnStats(self) != none)
	{
		return H7EffectOnStats(self).GetStatModValue();
	}
	else if(H7EffectOnResistance(self) != none)
	{
		return H7EffectOnResistance(self).GetData().mResistance.damageMultiplier;
	}
	else if(H7EffectDuration(self) != none)
	{
		return H7EffectDuration(self).GetData().mDuration.MaxValue;
	}
	else if(H7EffectDurationModifier(self) != none)
	{
		return H7EffectDurationModifier(self).GetData().mModifierValue;
	}
	else
	{
		;
		return 0;
	}
}

function String GetValueAsString()
{
	return class'H7GameUtility'.static.FloatToString( GetValue() );
}

// super-short version = only name
// i.e. Initiative , used for Messages to merge them
function String GetName()
{
	if(H7EffectOnStats(self) != none)
	{
		return mSourceOfEffect.GetLocaNameForStat(H7EffectOnStats(self).GetData().mStatMod.mStat,false);
	}
	else if(H7EffectOnResistance(self) != none)
	{
		return mSourceOfEffect.GetSchoolName(H7EffectOnResistance(self).GetData().mResistance.school) @ H7EffectOnResistance(self).GetTagList();
	}
	else if(H7EffectWithSpells(self) != none)
	{
		return H7EffectWithSpells(self).GetData().mSpellStruct.mSpell.GetName();
	}
	else if(H7EffectDuration(self) != none)
	{
		return class'H7Loca'.static.LocalizeSave("TT_DURATION","H7Effect");
	}
	else if(H7EffectDurationModifier(self) != none)
	{
		return GetSource().GetTimeEntityByEvent(H7EffectDurationModifier(self).GetData().mTrigger.mTriggerType);
	}
	else
	{
		;
		return "?";
	}
}

function String GetMinString()
{
	local H7RangeValue range;
	if(H7EffectDamage(self) != none)
	{
		range = H7EffectDamage(self).GetDamageRangeFinal(true);
		if(H7EffectDamage(self).GetData().mUseSpellScaling && range.MinValueFormular != "")
		{
			return range.MinValueFormular;
		}
		else
		{
			return string(range.MinValue);
		}
	}
	else
	{
		// TODO min vor special effect add resources
		;
		return "?";
	}
}

function String GetMinCap()
{
	if(H7EffectOnStats(self) != none)
	{
		return String(H7EffectOnStats(self).GetData().mStatMod.mScalingModifierValue.mMinCap);
	}
	else
	{
		;
		return "?";
	}
} 

function String GetMaxCap()
{
	if(H7EffectOnStats(self) != none)
	{
		return String(H7EffectOnStats(self).GetData().mStatMod.mScalingModifierValue.mMaxCap);
	}
	else
	{
		;
		return "?";
	}
} 

function String GetMaxString()
{
	local H7RangeValue range;
	if(H7EffectDamage(self) != none)
	{
		range = H7EffectDamage(self).GetDamageRangeFinal(true);
		if(H7EffectDamage(self).GetData().mUseSpellScaling && range.MaxValueFormular != "")
		{
			return range.MaxValueFormular;
		}
		else
		{
			return string(range.MaxValue);
		}
	}
	else
	{
		;
		return "?";
	}
}

function String GetIconString()
{
	local H7IEffectDelegate delegate;
	local Texture2D icon;
	local EAbilitySchool school;
	local H7GUIGeneralProperties guiProperties;

	guiProperties = class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties();

	if(H7EffectDamage(self) != none)
	{
		school = H7EffectDamage(self).GetSource().GetSchool();
		icon = guiProperties.mMagicSchoolIcons.GetSchoolIcon(school);
	}
	else if(H7EffectOnStats(self) != none)
	{
		icon = guiProperties.mStatIconsInText.GetStatIcon(H7EffectOnStats(self).GetData().mStatMod.mStat);
	}
	else if(H7EffectWithSpells(self) != none)
	{
		icon = H7EffectWithSpells(self).GetData().mSpellStruct.mSpell.GetIcon();
	}
	else if(H7EffectSpecial(self) != none)
	{
		delegate = H7EffectSpecial(self).GetFunctionProvider();
		if(H7EffectSpecialAddResources(delegate) != none) icon = H7EffectSpecialAddResources(delegate).GetIcon();
		else if(H7EffectSpecialAddResourcesToTarget(delegate) != none) icon = H7EffectSpecialAddResourcesToTarget(delegate).GetIcon();
		else if(H7EffectSpecialModifyManaCost(delegate) != none) icon = H7EffectSpecialModifyManaCost(delegate).GetIcon();
		else if(H7EffectDivergeEnemyHeroManaCost(delegate) != none) icon = H7EffectDivergeEnemyHeroManaCost(delegate).GetIcon();
		else if(H7EffectSpecialConditionalStatMod(delegate) != none) icon = H7EffectSpecialConditionalStatMod(delegate).GetIcon();
		else 
		{
			;
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(delegate @ "has no GetIconString, call coder",MD_QA_LOG);;
			return "?";
		}
	}
	else
	{
		;
		return "?";
	} 

	//return "<img src='img://" $ Pathname(icon) $ "' width='16' height='16'>";
	return "<img src='img://" $ Pathname(icon) $ "' width='#TT_POINT#' height='#TT_POINT#'>";
}

function string GetAbsValueAsString()
{
	local string str;
	str = GetDefaultString();
	if(left(str,1) == "-" || left(str,1) == "+")
	{
		return right(str,len(str)-1);
	}
	else
	{
		return str;
	}
}

// does not do special value manipulations i.e. battlerage, metamagic, overwrites, pathmultiplies...
static function string GetHumanReadableStatMod(H7MeModifiesStat statMod)
{
	local H7SpellScaling spellScalingStruct;
	local string tmp;
	
	if(statMod.mStat == STAT_NEGOTIATION
		|| statMod.mStat == STAT_GOLDGAIN_CHEST
		|| statMod.mStat == STAT_XP_RATE
	)
	{
		if(statMod.mCombineOperation == OP_TYPE_ADDPERCENT)
		{
			return GetHumanReadablePercent(statMod.mModifierValue/100.f);
		}
		else
		{
			return GetHumanReadablePercent(statMod.mModifierValue);
		}
	}
	else if(statMod.mStat == STAT_FLANKING_MULTIPLIER_BONUS) // designer version 3, 29.07 Anselm "We never wanted %"
	{
		if(statMod.mCombineOperation == OP_TYPE_ADDPERCENT)
		{
			return GetHumanReadablePercentInt(statMod.mModifierValue/100.f);
		}
		else
		{
			return GetHumanReadablePercentInt(statMod.mModifierValue);
		}
	}
	else
	{
		if(statMod.mCombineOperation == OP_TYPE_ADDPERCENT)
		{
			return GetHumanReadablePercent(statMod.mModifierValue/100.f); // (addp -25) -> -25%
		}
		else if(statMod.mCombineOperation == OP_TYPE_MULTIPLY)
		{
			return GetHumanReadableMultiplier(statMod.mModifierValue); // (* 0,75) -> -25%
		}
		else
		{
			if(statMod.mUseSpellScaling)
			{
				// show formular // OPTIONAL unify with GetTooltipReplacement
				spellScalingStruct = statMod.mScalingModifierValue;
				// OPTIONAL operation relevant?
				if(spellScalingStruct.mIntercept != 0)
					tmp = class'H7GameUtility'.static.FloatToString(spellScalingStruct.mIntercept);
				tmp = tmp $ (spellScalingStruct.mSlope>0?"+":"") $ class'H7GameUtility'.static.FloatToString(spellScalingStruct.mSlope) $ "*" $ class'H7Loca'.static.LocalizeSave("STAT_MAGIC","H7Abilities");
				return tmp;
			}
			else
			{
				return class'H7GameUtility'.static.FloatToString(statMod.mModifierValue,true); // no * =             yes - +             "Multipliziert damage by 2" = "+100% damage"
			}
		}
	}
}

// returns the str for tooltip replacements without property selection.
// i.e. %stat %dam %durini %res
function String GetDefaultString()
{
	local string tmp;
	local H7IEffectDelegate delegate;
	local H7SpellScaling spellScalingStruct;
	local H7RangeValue range;
	local H7ICaster caster;

	if(H7EffectOnStats(self) != none)
	{
		if(H7EffectOnStats(self).GetData().mStatMod.mStat == STAT_NEGOTIATION
			|| H7EffectOnStats(self).GetData().mStatMod.mStat == STAT_GOLDGAIN_CHEST
			|| H7EffectOnStats(self).GetData().mStatMod.mStat == STAT_XP_RATE
		)
		{
			if(H7EffectOnStats(self).GetData().mStatMod.mCombineOperation == OP_TYPE_ADDPERCENT)
			{
				return GetHumanReadablePercent(GetValue()/100.f);
			}
			else
			{
				return GetHumanReadablePercent(GetValue());
			}
		}
		else if(H7EffectOnStats(self).GetData().mStatMod.mStat == STAT_FLANKING_MULTIPLIER_BONUS) // designer version 3, 29.07 Anselm "We never wanted %"
		{
			if(H7EffectOnStats(self).GetData().mStatMod.mCombineOperation == OP_TYPE_ADDPERCENT)
			{
				return GetHumanReadablePercentInt(GetValue()/100.f);
			}
			else
			{
				return GetHumanReadablePercentInt(GetValue());
			}
		}
		else
		{
			if(H7EffectOnStats(self).GetData().mStatMod.mCombineOperation == OP_TYPE_ADDPERCENT)
			{
				return GetHumanReadablePercent(GetValue()/100.f);
			}
			else if(H7EffectOnStats(self).GetData().mStatMod.mCombineOperation == OP_TYPE_MULTIPLY)
			{
				return GetHumanReadableMultiplier(GetValue());
			}
			else
			{
				if(H7EffectOnStats(self).GetData().mStatMod.mUseSpellScaling && !H7EffectOnStats(self).IsValueCalculated())
				{
					// show formular // OPTIONAL unify with GetTooltipReplacement
					spellScalingStruct = H7EffectOnStats(self).GetData().mStatMod.mScalingModifierValue;
					// OPTIONAL operation relevant?
					if(spellScalingStruct.mIntercept != 0)
						tmp = class'H7GameUtility'.static.FloatToString(spellScalingStruct.mIntercept);
					tmp = tmp $ (spellScalingStruct.mSlope>0?"+":"") $ class'H7GameUtility'.static.FloatToString(spellScalingStruct.mSlope) $ "*" $ class'H7Loca'.static.LocalizeSave("STAT_MAGIC","H7Abilities");
					return tmp;
				}
				else
				{
					return class'H7GameUtility'.static.FloatToString(GetValue(),true); // no * =             yes - +             "Multipliziert damage by 2" = "+100% damage"
				}
			}
		}
	}
	else if(H7EffectOnResistance(self) != none)
	{
		if(H7EffectOnResistance(self).GetData().mResistance.MultiplyResByMetamagic) // special case because of wrong use of resistances by designers
		{
			caster = mSourceOfEffect.GetInitiator().GetOriginal();
			return GetHumanReadablePercent(GetValue() * H7EditorHero(caster).GetMetamagic());
		}
		return GetHumanReadableMultiplier(GetValue());
	}
	else if(H7EffectDuration(self) != none)
	{
		return class'H7GameUtility'.static.FloatToString(GetValue());
	}
	else if(H7EffectDamage(self) != none)
	{
		if(H7EffectDamage(self).GetData().mUsePercentStackDamage)
		{
			if(H7EffectDamage(self).GetData().mPercentUseCasterSpellPower)
			{
				if(mSourceOfEffect != none && mSourceOfEffect.GetCaster() != none)
				{
					return GetHumanReadablePercentAbs(H7EffectDamage(self).GetData().mPercentStackDamage * mSourceOfEffect.GetCaster().GetMagic() + H7EffectDamage(self).GetData().mAddPercentStackDamage );
				}
				else
				{
					return GetHumanReadablePercentAbs(H7EffectDamage(self).GetData().mPercentStackDamage + H7EffectDamage(self).GetData().mAddPercentStackDamage ) @ "*" @ class'H7Loca'.static.LocalizeSave("STAT_MAGIC","H7Abilities"); 
				}
			}
			else
			{
				return GetHumanReadablePercentAbs(H7EffectDamage(self).GetData().mPercentStackDamage + H7EffectDamage(self).GetData().mAddPercentStackDamage );
			}
		}
		else
		{
			range = H7EffectDamage(self).GetDamageRangeFinal(true);
			if(H7EffectDamage(self).GetData().mUseSpellScaling && range.MinValueFormular != "" && range.MaxValueFormular != "")
			{
				return range.MinValueFormular @ class'H7Loca'.static.LocalizeSave("TT_TO","H7Effect") @ range.MaxValueFormular;
			}
			else
			{
				return range.MinValue $ "-" $ range.MaxValue;
			}
		}
	}
	else if(H7EffectDurationModifier(self) != none)
	{
		return GetSource().GetTimeEntityByEvent(H7EffectDurationModifier(self).GetData().mTrigger.mTriggerType);
	}
	else if(H7EffectSpecial(self) != none)
	{
		delegate = H7EffectSpecial(self).GetFunctionProvider();
		if(H7EffectDelegateRevealMap(delegate) != none) return H7EffectDelegateRevealMap(delegate).GetDefaultString();
		else if(H7EffectSpecialPushback(delegate) != none) return H7EffectSpecialPushback(delegate).GetDefaultString();
		else if(H7EffectSpecialRemoveBuffs(delegate) != none) return H7EffectSpecialRemoveBuffs(delegate).GetDefaultString();
		else if(H7EffectSpecialShieldEffect(delegate) != none) return H7EffectSpecialShieldEffect(delegate).GetDefaultString();
		else if(H7EffectSpecialAddResources(delegate) != none) return H7EffectSpecialAddResources(delegate).GetDefaultString();
		else if(H7EffectSpecialAddResourcesToTarget(delegate) != none) return H7EffectSpecialAddResourcesToTarget(delegate).GetDefaultString();
		else if(H7EffectSpecialModifyManaCost(delegate) != none) return H7EffectSpecialModifyManaCost(delegate).GetDefaultString();
		else if(H7EffectDivergeEnemyHeroManaCost(delegate) != none) return H7EffectDivergeEnemyHeroManaCost(delegate).GetDefaultString();
		else if(H7EffectModifyBuffDuration(delegate) != none) return H7EffectModifyBuffDuration(delegate).GetDefaultString();
		else if(H7EffectSpecialShadowOfDeath(delegate) != none) return H7EffectSpecialShadowOfDeath(delegate).GetDefaultString();
		else if(H7EffectSpecialCastOnRandomTarget(delegate) != none) return H7EffectSpecialCastOnRandomTarget(delegate).GetDefaultString();
		else if(H7EffectCharge(delegate) != none) return H7EffectCharge(delegate).GetDefaultString();
		else if(H7EffectLuck(delegate) != none) return H7EffectLuck(delegate).GetDefaultString();
		else if(H7EffectSpecialDecreaseBuildingCosts(delegate) != none) return H7EffectSpecialDecreaseBuildingCosts(delegate).GetDefaultString();
		else if(H7EffectSpecialDecreaseRecruitingCosts(delegate) != none) return H7EffectSpecialDecreaseRecruitingCosts(delegate).GetDefaultString();
		else if(H7EffectSpecialModifyStackSize(delegate) != none) return H7EffectSpecialModifyStackSize(delegate).GetDefaultString();
		else if(H7EffectTeachExperience(delegate) != none) return H7EffectTeachExperience(delegate).GetDefaultString();
		else if(H7EffectSpecialBuffDurationModifier(delegate) != none) return H7EffectSpecialBuffDurationModifier(delegate).GetDefaultString();
		else if(H7EffectRefundManaCost(delegate) != none) return H7EffectRefundManaCost(delegate).GetDefaultString();
		else if(H7EffectSpecialNecromancy(delegate) != none) return H7EffectSpecialNecromancy(delegate).GetDefaultString();
		else if(H7EffectSpecialInitialDamageReduction(delegate) != none) return H7EffectSpecialInitialDamageReduction(delegate).GetDefaultString();
		else if(H7EffectSpecialSoulReaver(delegate) != none) return H7EffectSpecialSoulReaver(delegate).GetDefaultString();
		else if(H7EffectSpecialModifiedDamageOverTime(delegate) != none) return H7EffectSpecialModifiedDamageOverTime(delegate).GetDefaultString();
		else if(H7EffectSpecialConditionalStatMod(delegate) != none) return H7EffectSpecialConditionalStatMod(delegate).GetDefaultString();
		else if(H7EffectSpecialSummonCreatureStack(delegate) != none) return H7EffectSpecialSummonCreatureStack(delegate).GetDefaultString();
		else if(H7EffectSpecialTeleport(delegate) != none) return H7EffectSpecialTeleport(delegate).GetDefaultString();
		else if(H7EffectSpecialAdditionalCounter(delegate) != none) return H7EffectSpecialAdditionalCounter(delegate).GetDefaultString();
		else if(H7EffectSpecialDeathMarch(delegate) != none) return H7EffectSpecialDeathMarch(delegate).GetDefaultString();
		else if(H7EffectSpecialStackRegeneration(delegate) != none) return H7EffectSpecialStackRegeneration(delegate).GetDefaultString();
		else 
		{
			;
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(delegate @ "has no GetDefaultString, call coder",MD_QA_LOG);;
			return "?";
		}
	}
	else if(H7EffectWithSpells(self) != none)
	{
		return H7EffectWithSpells(self).GetData().mSpellStruct.mSpell.GetName();
	}
	else
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(self @ ObjectArchetype @ ".GetDefaultString() not implemented, call coder",MD_QA_LOG);;
		return "?";
	}
}

// short version = only value + name
// i.e. +10 Initiative , Immunity againt Fire ,
// - used for %e1 ... %e9 replacements in tooltips (but will be phased out there in favor of more detailed bricks like %d_number, %d_icon, %d_school
// - used for extended guild spell tooltip
// - for long version see: GetTooltipLine()
function String GetTooltipReplacement(optional bool resolveBuff=false)
{
	local String tooltip,damageRangeStr,tmp;
	local H7EffectContainer source;
	local H7RangeValue range;
	local EAbilitySchool school;
	local string ttMessage;
	local H7SpellScaling SpellScalingStruct;
	local string replColor;

	replColor = class'H7TextColors'.static.GetInstance().UnrealColorToHex(class'H7TextColors'.static.GetInstance().mReplacementColor);

	if(H7EffectOnStats(self) != none)
	{
		// OPTIONAL and all the other settings? // OPTIONAL unify with GetDefaultString
		if(H7EffectOnStats(self).GetData().mStatMod.mUseSpellScaling && !H7EffectOnStats(self).IsValueCalculated())
		{
			SpellScalingStruct = H7EffectOnStats(self).GetData().mStatMod.mScalingModifierValue;
			
			// OPTIONAL operation relevant?
			if(SpellScalingStruct.mIntercept != 0)
				tmp = class'H7GameUtility'.static.FloatToString(SpellScalingStruct.mIntercept);
			tmp = tmp $ (SpellScalingStruct.mSlope>0?"+":"") $ class'H7GameUtility'.static.FloatToString(SpellScalingStruct.mSlope) $ "*" $ class'H7Loca'.static.LocalizeSave("STAT_MAGIC","H7Abilities");
			tooltip = tooltip $ tmp @ mSourceOfEffect.GetLocaNameForStat(H7EffectOnStats(self).GetStatModType(),false);
		}
		else
		{
			tooltip = tooltip $ mSourceOfEffect.GetStringForOperation(
								H7EffectOnStats(self).GetStatModCombineOp(),
								H7EffectOnStats(self).GetStatModValue()
							) 
							@ mSourceOfEffect.GetLocaNameForStat(H7EffectOnStats(self).GetStatModType(),false);
		}
	}
	else if(H7EffectDamage(self) != none)
	{
		// should look the same as %d
		source = H7EffectDamage(self).GetSource();
		
		if(H7EffectDamage(self).GetData().mUseDefaultSchool)
		{
			school = mSourceOfEffect.GetInitiator().GetSchool();
		}
		else if( H7EffectDamage(self).GetData().mUseRandomSchool )
		{
			school = ABILITY_SCHOOL_NONE;
		}
		else
		{
			school = source.GetSchool();
		}

		range = H7EffectDamage(self).GetDamageRangeFinal(true);
		if(H7EffectDamage(self).GetData().mUseSpellScaling && range.MinValueFormular != "" && range.MaxValueFormular != "")
		{
			damageRangeStr = range.MinValueFormular @ class'H7Loca'.static.LocalizeSave("TT_TO","H7Effect") @ range.MaxValueFormular;
		}
		else
		{
			damageRangeStr = range.MinValue $ "-" $ range.MaxValue;
		}

		tooltip = tooltip $ 
			"<font color='#"$ class'H7EffectContainer'.static.GetSchoolColor( school ) $"'>"
				$ damageRangeStr
			@ "<img width='#TT_POINT#' height='#TT_POINT#' src='" $ class'H7EffectContainer'.static.GetSchoolFlashPath(school) $ "'>"
			$ ( H7EffectDamage(self).IsHeal() ? class'H7Loca'.static.LocalizeSave("TT_HEAL","H7Effect") : ( class'H7EffectContainer'.static.GetSchoolName( school ) @ class'H7Loca'.static.LocalizeSave("TT_DAMAGE","H7Effect")))
			$ "</font>";
	}
	else if(H7EffectOnResistance(self) != none)
	{
		if(H7EffectOnResistance(self).GetData().mResistance.damageMultiplier == 0)
		{
			tooltip = class'H7Loca'.static.LocalizeSave("MT_IMMUNE","H7Abilities");
		}
		else if(H7EffectOnResistance(self).GetData().mResistance.damageMultiplier < 0)
		{
			tooltip = class'H7Loca'.static.LocalizeSave("MT_RESIST","H7Message");
		}
		else
		{
			tooltip = class'H7Loca'.static.LocalizeSave("MT_VUL","H7Abilities");
		}
		tooltip = tooltip @ class'H7Loca'.static.LocalizeSave("TT_TO","H7Effect") @ mSourceOfEffect.GetSchoolName(H7EffectOnResistance(self).GetData().mResistance.school) 
					@ H7EffectOnResistance(self).GetTagList();

		if(H7EffectOnResistance(self).GetData().mResistance.damageMultiplier != 0)
		{
			tooltip = tooltip @ "(" $ GetHumanReadableMultiplier(H7EffectOnResistance(self).GetData().mResistance.damageMultiplier) $ ")";
		}
	}
	else if(H7EffectWithSpells(self) != none)
	{
		tooltip = tooltip $ class'H7Loca'.static.LocalizeSave(String(H7EffectWithSpells(self).GetData().mSpellStruct.mSpellOperation),"H7Abilities") $ ": " 
			$ H7EffectWithSpells(self).GetData().mSpellStruct.mSpell != none ? H7EffectWithSpells(self).GetData().mSpellStruct.mSpell.GetName() : "";
		if(resolveBuff)
		{
			
		}
	}
	else if(H7EffectSpecial(self) != none)
	{
		if(H7EffectSpecial(self).ShowInTooltip() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenEffects())
		{
			if(H7EffectSpecial(self).GetFunctionProvider() != none)
			{
				tooltip = tooltip $ H7EffectSpecial(self).GetFunctionProvider().GetTooltipReplacement();
			}
			else
			{
				//`warn(mSourceOfEffect.GetName()@"has a special coding effect without a function provider!");
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(mSourceOfEffect.GetName()@"has a special coding effect without a function provider!",MD_QA_LOG);;
			}
		}
	}
	else if(H7EffectDuration(self) != none)
	{
		ttMessage = class'H7Loca'.static.LocalizeSave("TT_DURATION_X","H7Effect");
		ttMessage = Repl(ttMessage, "%duration", H7EffectDuration(self).GetData().mDuration.MaxValue);
		tooltip = tooltip $ ttMessage;
	}
	else if(H7EffectDurationModifier(self) != none)
	{
		ttMessage = class'H7Loca'.static.LocalizeSave("TT_DURATION_CHANGE","H7Effect");
		ttMessage = Repl(ttMessage, "%change", mSourceOfEffect.GetStringForOperation( H7EffectDurationModifier(self).GetData().mCombineOperation ,  H7EffectDurationModifier(self).GetData().mModifierValue ));
		tooltip = tooltip $ ttMessage;
	}
	else if(H7EffectCommand(self) != none)
	{
		tmp = class'H7Loca'.static.LocalizeSave("EFFECTCOMMAND","H7Abilities");
		tmp = Repl(tmp,"%unit","<font color='" $ replColor $ "'>" $ class'H7Loca'.static.LocalizeSave(String(H7EffectCommand(self).GetData().mCommandRecipient),"H7Abilities") $ "</font>");
		tmp = Repl(tmp,"%command","<font color='" $ replColor $ "'>" $ 
			Localize("H7Abilities",String(H7EffectCommand(self).GetData().mCommandTag),"MMH7Game") 
			$ ((H7EffectCommand(self).GetData().mAbility!=none)?(" " $ H7EffectCommand(self).GetData().mAbility.GetName()):"") 
			$ "</font>"
		);
		//tmp = Repl(tmp,"%target","<font color='#ffcc99'>" $ `Localize("H7Abilities",String(H7EffectCommand(self).GetData().mTarget),"MMH7Game") $ "</font>");

		tooltip = tooltip $ tmp;
	}
	else
	{
		tooltip = tooltip $ class'H7Loca'.static.LocalizeSave("TT_UNKNOWN_FX","H7Effect");
	}
	return tooltip;
}

/*
1.25
	* 1.25 +25%

0.25
	wert + wert * 0.25 +25%
*/

// 0 -> -100%
// 0.25 -> -75%
// 0.1 -> -90%
// 0.3 -> -70%
// 0.75 -> -25%
// 1.0 -> 0%
// 1.25 -> +25%
// 2 -> +100%
static function String GetHumanReadableMultiplier(float multiplier)
{
	local String str;
	str = ((multiplier-1>0)?"+":"");
	str = str $ class'H7GameUtility'.static.FloatToString((multiplier-1.0) * 100);
	str = str $ "%";
	return str;
}
// same as above but without +/- and without %
static function String GetHumanReadableMultiplierAbsInt(float multiplier)
{
	local String str;
	str = str $ class'H7GameUtility'.static.FloatToString(Abs((multiplier-1.0) * 100));
	return str;
}
// same as above but without +/- and but with %
static function String GetHumanReadableMultiplierAbs(float multiplier)
{
	return class'H7GameUtility'.static.FloatToString(Abs((multiplier-1.0) * 100)) $ "%";
}

// -0.5 -> -50%
// 0.25 -> +25%
// 0   -> 0%
// 0.1 -> +10%
// 1.0 -> +100%
// 1.2 -> +120%
// 1.33333 -> +130.33%
// "+20% chance to undead debuff" "-20% damage to undead debuff"
static function String GetHumanReadablePercent(float percent)
{
	local String str;
	str = (percent>0)?"+":"";
	str = str $ class'H7GameUtility'.static.FloatToString(percent * 100);
	str = str $ "%";
	return str;
}
// same as above but without +/- and without %
// "Decreases luck by 20 percent points" "Increases luck by 20 percent points"
static function String GetHumanReadablePercentAbsInt(float percent)
{
	return class'H7GameUtility'.static.FloatToString(Abs(percent * 100));
}
// same as above but without +/- and but with % 
// "Decreases chance by 40%" "Increases chance by 40%"
static function String GetHumanReadablePercentAbs(float percent)
{
	return class'H7GameUtility'.static.FloatToString(Abs(percent * 100)) $ "%";
}
// same as above but with +/- and without %
// "+20 percent points to luck" "-20 percent points to luck" 
static function string GetHumanReadablePercentInt(float percent)
{
	local String str;
	str = (percent>0)?"+":"";
	return str $ class'H7GameUtility'.static.FloatToString(percent * 100); // @ `Localize("H7Abilities","PERCENT_POINTS");
}

native function DebugFunction( bool isSimulated );

function UnpackContainer( )
{
	if( GetEventContainer().Targetable != none ) 
	{
		SetUnitTargetOverwrite( GetEventContainer().Targetable );
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
