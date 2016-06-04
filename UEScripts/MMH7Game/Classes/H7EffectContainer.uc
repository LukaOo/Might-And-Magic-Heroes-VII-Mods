//=============================================================================
// H7EffectContainer
//=============================================================================
//
// Buffs,Abilities,Spells,Items,SetBoni,(in future: Cells?) extend from this, because their values can be modified by stats of the casting unit
// - also handles tooltip for both
// - and handles modifiers to change unit stats
// 
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectContainer extends Object
	perobjectconfig
	hidecategories(Object)
	dependson( H7CombatMapCell, H7Faction, H7GameTypes, H7StructsAndEnumsNative, H7StructsAndEnumsNative )
	implements(H7IEventManagingObject, H7IAliasable)
	native
	savegame;

const SCROLL_MAGIC_POWER = 30;

/* Name of the Spell/Ability/Buff/Skill etc. */
var(Container) protected localized string         mName<DisplayName="Name">;
/* Name of the Spell/Ability/Buff/Skill etc. */
var transient protected string                    mNameInst;
/* Tooltip of the Spell/Ability/Buff/Skill etc. */
var(Container) protected localized string         mTooltip<DisplayName="Tooltip">;

var(Container) protected editoronly string        mComment<DisplayName="Editor Tooltip"|MultilineWithMaxRows=10>;

/* archetypes localize the tooltip once and save it here */
var protected transient string                    mTooltipLocalized;
/* Icon of the Spell/Ability/Buff/Skill etc. */
var(Container) protected dynload Texture2D        mIcon<DisplayName="Icon">;

/** If set this will be displayed ingame (Tooltip/InfoWindow etc.) */
var(Container) protected bool                     mIsDisplayed<DisplayName="Gets Displayed">;

/** Needs to be set for Abilities/Spells that are related to a School of Magic/Might */
var(Container) protected EAbilitySchool           mAbilitySchool<DisplayName="School">;
/** Needs to be set for Skills/Abilites/Spells that have a Rank relationship to a Skill */
var(Container) protected ESkillType               mSkillType<DisplayName="Related Skill">;

var(Container, EffectList) protected array<H7DamageEffect>      mDamageEffects<DisplayName="Damage Effects">;
var(Container, EffectList) protected array<H7StatEffect>        mStatModEffects<DisplayName="Stat Modifier Effects">;
var(Container, EffectList) protected array<H7ResistanceEffect>  mResistanceEffects<DisplayName="Resistance Effects">;
var(Container, EffectList) protected array<H7SpellEffect>       mSpellEffects<DisplayName="Ability/Spell/Buff Effects">;
var(Container, EffectList) protected array<H7CommandEffect>     mCommandEffects<DisplayName="Command Effects">;
var(Container, EffectList) protected array<H7SpecialEffect>     mSpecialEffects<DisplayName="Special Coding Effects">;
var(Container, EffectList) protected array<H7AudioVisualEffect> mAudioVisualEffects<DisplayName="Audiovisual Effects (No gameplay!)">;

var protected array<H7TooltipReplacementEntry>    mTooltipMapping;
var protected array<H7TooltipLogEntry>            mTooltipLog;
var protected array<H7IEffectTargetable>          mTargets;                 // if spell=target where i click, if buff=there where buff hangs
var protected H7ICaster					          mCaster;                  // if spell=caster, if buff=caster
var protected H7UnitSnapShot			          mCasterSnapShot;          // if spell=caster, if buff=caster
var protected H7ICaster		                      mOwner;                   // if item or building
var protected H7EffectContainer                   mSourceContainer;

var protected H7EventManager                      mEventManager;
var protected array<Vector>                       mTargetVectors;           // used, if target is gridcontroller to specify affected gridcells (maybe used for other future target types where appropiate)
var protected array<H7Effect>                     mInstanciatedEffects;
var protected bool                                mInstanciatedEffectsByTooltip;
var protected bool                                mInstanciatedEffectsDone;
var protected bool                                mProducesResources;
var protectedwrite bool	                          mEventuallySuppressesRetaliation;
var protectedwrite bool	                          mEventuallySuppressesRetaliationChecked;

/** set when we want to override the caster's rank with a custom rank */
var protected ESkillRank              mRankOverride;

static native function bool TargetIsImmuneToAllExecutingEffectsOnArchetype( H7IEffectTargetable target, 
																			H7ICaster initiator, 
																			H7ICaster owner, 
																			H7ICaster caster, 
																			H7EventContainerStruct eventContainer, 
																			bool targetCheckOnly, 
																			bool isStatEffect, 
																			bool isPersistentStatEffect, 
																			bool isTeleportSpell, 
																			int teleportSpellRange,
																			H7EffectContainer effectContainer,
																			array<ESpellTag> tags,
																			EAbilitySchool abilitySchool );

native function bool                        GetEffectFunctionProvider( H7IEffectDelegate effectDelegate, out H7IEffectDelegate instance);

native function bool						ProvidesCover();
function bool								ProducesResources()                                     { return mProducesResources; }
function									SetProducesResources(bool boool)                        { mProducesResources = boool; }
native function H7ICaster					GetOwner();
function									SetOwner( H7ICaster owner)                              { mOwner = owner; }
native function array<H7IEffectTargetable>	GetTargets();
function                                SetTargets(array<H7IEffectTargetable> targets)          { mTargets = targets; }
native function H7IEffectTargetable     GetTarget();
function                                SetTarget(H7IEffectTargetable target)                   { if(target==none) return; if(mTargets.Length > 0 && mtargets.Find( target ) == -1 ) mTargets[0] = target; else if( mtargets.Find( target ) == -1 ) mTargets.AddItem(target); }
function array<Vector>                  GetTargetVectors()                                      { return mTargetVectors; }
function                                SetTargetVectors(array<Vector> vecs)                    { mTargetVectors = vecs; }
function Vector                         GetTargetVector()                                       { if(mTargetVectors.Length > 0) return mTargetVectors[0]; return Vect( 0.f, 0.f, 0.f); }
function                                SetTargetVector(Vector vec)                             { if(mTargetVectors.Length > 0) mTargetVectors[0] = vec; else mTargetVectors.AddItem(vec); }
function H7ICaster                      GetCasterOriginal()                                     { return mCaster; }
function EAbilitySchool                 GetSchool()                                             { return mAbilitySchool; }
function ESkillType                     GetSkillType()                                          { return mSkillType; }
function bool			                IsDisplayed()		                                    { return mIsDisplayed; }
function 			                    SetDisplayed( bool display )		                    { mIsDisplayed = display;}
function bool                           DidInstanciateEffects()                                 { return mInstanciatedEffectsDone; }
function bool	                        IsAbility()	                                            { return false; }
function bool	                        IsBuff()	                                            { return false; }
native function bool	                IsSkill();                                            
native function bool                    IsHeroItem();
function                                SetStatModEffects( array<H7StatEffect> effects )        { mStatModEffects = effects; }
function bool                           HasStatModEffects()                                     { return mStatModEffects.Length > 0; }
function array<H7SpellEffect>           GetSpellEffects()                                       { return mSpellEffects; }
function                                AddSpellEffect( H7SpellEffect spellEffect )             { mSpellEffects.AddItem( spellEffect ); }
function                                ClearSpellEffects()                                     { mSpellEffects.Length = 0; }

native function int						GetID();
function String						    GetArchetypeID()							            { return IsArchetype()?String(self):H7EffectContainer(ObjectArchetype).GetArchetypeID(); }
function String                         GetDebugName()                                          { if(IsArchetype()) return Pathname(self) @ "(Arch)";else return Pathname(ObjectArchetype) @ "(Inst)" @ String(self) @ GetName(); }
function								SetRankOverride( ESkillRank rank )						{ mRankOverride = rank; }
function ESkillRank						GetRankOverride()										{ return mRankOverride; }
function                                SetSourceEffect( H7EffectContainer effectContainer )    { mSourceContainer = effectContainer; }
function H7EffectContainer              GetSourceEffect()                                       { return mSourceContainer; }
function bool                           IsMight()                                               { return mAbilitySchool == MIGHT; }

function Texture2D GetIcon()
{
	if(IsArchetype())
	{
		if(mIcon == none)
		{
			self.DynLoadObjectProperty('mIcon');
		}
		return mIcon;
	}
	else
	{
		if(InStr(string(ObjectArchetype),"Default__") != INDEX_NONE)
		{
			// sorry have to load icon into the instance
			if(mIcon == none)
			{
				self.DynLoadObjectProperty('mIcon');
			}
			return mIcon;
		}
		else
		{
			return H7EffectContainer(ObjectArchetype).GetIcon();
		}
	}
}

function string	ApplyHelperReplacements(string baseLocalizedString)	                                    
{ 
	// useful helper replacements	
	baseLocalizedString = Repl(baseLocalizedString,"%d ","%dam ");
	baseLocalizedString = Repl(baseLocalizedString,"%d.","%dam.");
	baseLocalizedString = Repl(baseLocalizedString,"%dam_min","%dam.min");
	baseLocalizedString = Repl(baseLocalizedString,"%dam_max","%dam.max");

	if(!self.IsA('H7BaseBuff'))
	{
		baseLocalizedString = Repl(baseLocalizedString,"%t","%buff.buff.durini.val");
		baseLocalizedString = Repl(baseLocalizedString,"%bn1","%buff1.name");
		baseLocalizedString = Repl(baseLocalizedString,"%bn2","%buff2.name");
		baseLocalizedString = Repl(baseLocalizedString,"%bn","%buff.name");
	
		baseLocalizedString = Repl(baseLocalizedString,"%bt2","%buff2.buff.tt");
		baseLocalizedString = Repl(baseLocalizedString,"%bt1","%buff1.buff.tt");
		baseLocalizedString = Repl(baseLocalizedString,"%bt","%buff.buff.tt");
	}
	else
	{
		baseLocalizedString = Repl(baseLocalizedString,"%t","%durini.val");
	}

	return baseLocalizedString;
}

// returns normal tooltip
function string	GetTooltipLocalized( H7ICaster initiator )	                                           
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		if( mTooltipLocalized == "")
		{
			mTooltipLocalized = class'H7Loca'.static.LocalizeContent( self, "mTooltip", mTooltip );
			mTooltipLocalized = ApplyHelperReplacements(mTooltipLocalized);
		}
		return mTooltipLocalized;
	}
	else
	{
		return H7EffectContainer( ObjectArchetype ).GetTooltipLocalized( initiator );
	}
}

native function string GetNameNative();

event string	GetName()	                                           
{
	if( class'H7GameUtility'.static.IsArchetype( self ) )
	{
		LocalizeName();
		return mNameInst;
	}
	else
	{
		return H7EffectContainer( ObjectArchetype ).GetName();
	}
}

function LocalizeName()	                                           
{ 
	local string dasName;

	if( mNameInst == "" ) 
	{
		if( mName == "" )
		{
			dasName = "No Name for" @ GetDebugName();
		}
		else
		{
			dasName = mName;
		}
		mNameInst = class'H7Loca'.static.LocalizeContent( self, "mName", dasName );
	}
}

// common term for owner|caster
native function H7ICaster GetInitiator();

native function bool HasStasisEffect();
native function bool CanRemoveStasis();

function bool HasInitiator()
{
	if(GetCasterOriginal() == none && GetOwner() == none) return false;
	return true;
}


// cleanup archetypes by calling SetCaster(none);
function SetCaster(H7ICaster caster)                                
{ 
	if(IsArchetype()) 
	{
		; 
		return;
	}

	mCaster = caster; 

	if(caster != none)
	{
		if( mCasterSnapShot != none && mCasterSnapShot.GetOriginal() == mCaster ) return; // no need to update

		// got a snapshot? don't make a new one
		if( H7UnitSnapShot( mCaster ) != none )
		{
			mCasterSnapShot = H7UnitSnapShot( mCaster );
			mCaster = H7UnitSnapShot( mCaster ).GetOriginal();
			return;
		}

		mCasterSnapShot = new class'H7UnitSnapShot';
		mCasterSnapShot.TakeSnapShot(mCaster);
	}
	else
	{
		mCasterSnapShot = none;
	}
}

// cleanup archetypes by calling SetCaster(none);
function OverrideCaster(H7ICaster caster)                                
{ 
	if(IsArchetype()) 
	{
		; 
		return;
	}

	mCaster = caster; 
}

// is sometimes called to check if there is one
native function H7ICaster GetCaster();


function GetModifiedStatsAndValues(out array<EStat> modifiedStats, out array<float> values)
{
	local H7Effect effect;
	local H7EffectOnStats statEffect;
	local array<H7Effect> effects;
	
	GetEffects( effects, none ); 

	foreach effects(effect)
	{
		statEffect = H7EffectOnStats(effect);
		if(statEffect != none)
		{
			modifiedStats.AddItem(statEffect.GetStatModType());
			values.AddItem(stateffect.GetStatModValue());
		}
	}
}

function bool HasStatModFor( EStat stat )
{
	local int i;
	local array<EStat> stats;
	local array<float> values;

	GetModifiedStatsAndValues( stats, values );

	for( i = 0; i < stats.Length; ++i )
	{
		if( stats[i] == stat )
		{
			return true;
		}
	}

	return false;
}

native function H7SpellEffect GetArchetypeEffect(Class effectClass,ETrigger triggerType);

// lists all StaMod-Effects for the tooltip - but now uses TUSSI
function String GetTooltipModifierList()
{
	local array<H7Effect> modList;
	local H7Effect effect;
	local String tooltip;

	modList = GetEffectsOfType( 'H7EffectOnStats' );
	
	if(modList.Length > 0)
	{
		if( !IsHeroItem() ) 
		{
			tooltip = "\n\nModifies Stats:";
		}

		foreach modList(effect)
		{
			tooltip = tooltip $ "<li>";
			if(H7EffectOnStats(effect).GetData().mTrigger.mTriggerType != PERSISTENT)
			{
				tooltip = tooltip $ effect.GetLocaNameForTrigger(H7EffectOnStats(effect).GetData().mTrigger.mTriggerType) $ " ";
			}
			tooltip = tooltip $ GetStringForOperation(H7EffectOnStats(effect).GetStatModCombineOp() ,H7EffectOnStats(effect).GetStatModValue() ) @ GetLocaNameForStat( H7EffectOnStats(effect).GetStatModType() , false ) $ "</li>"; 
		}
	}
	else
	{
		if( IsHeroItem() ) // only items show this
		{
			tooltip = tooltip $ "<li>Modifies No Stats</li>";
		}
		
	}

	return tooltip;
}

function static String GetStringForOperation(EOperationType op,float value)
{
	switch(op)
	{
		case OP_TYPE_ADD:
			if(value < 1) // all ADD 0.05, ADD 0.5, etc... are assumed to be percent
			{
				return class'H7Effect'.static.GetHumanReadablePercent(value);
			}
			else
			{
				return class'H7GameUtility'.static.FloatToString(value,true);
			}
		case OP_TYPE_ADDPERCENT:return class'H7GameUtility'.static.FloatToString(value,true) $ "%";
		case OP_TYPE_SET:return "=" $ class'H7GameUtility'.static.FloatToString(value);
		case OP_TYPE_MULTIPLY:return "*" $ class'H7GameUtility'.static.FloatToString(value);
		case OP_TYPE_CHOOSE_ADD:return class'H7GameUtility'.static.FloatToString(value,true);
		case OP_TYPE_BUY_ADD:return class'H7GameUtility'.static.FloatToString(value,true);
	}
}

function static String GetLocaNameForStat(EStat stat,bool forHero)
{
	local String statAsString;
	statAsString = String(stat);
	if(forHero)
	{
		// deal with double stats
		if(stat == STAT_MORALE_LEADERSHIP) statAsString = "STAT_LEADERSHIP";
		if(stat == STAT_LUCK_DESTINY) statAsString = "STAT_DESTINY";
		if(stat == STAT_ATTACK) statAsString = "STAT_MIGHT";
	}

	return class'H7Loca'.static.LocalizeSave(statAsString,"H7Abilities");
}

native function bool IsEqual(H7EffectContainer container); // matches

function static float DoOperation(EOperationType op,float baseValue,float modificator)
{
	local float finalValue;

	switch(op)
	{
		case OP_TYPE_ADD:
			finalValue = baseValue + modificator;
			;
			break;
		case OP_TYPE_ADDPERCENT:
			finalValue = baseValue * (1 + modificator / 100);
			;
			break;
		case OP_TYPE_MULTIPLY:
			finalValue = baseValue * modificator;
			;
			break;
		case OP_TYPE_SET:
			finalValue = modificator; // ignores baseValue
			;
			break;
		default:;
	}

	return finalValue;
}


// !!! CHECK castingUnit is not even used
function H7RangeValue GetDamageRange( H7SpellValue damage, H7Unit castingUnit, optional ESkillRank forceRankValue )
{
	local H7CombatHero heroUnit; 
	local array<H7Skill> heroSkills; 
	local H7Skill   heroSkill;
	
	// look for related skill
	if( castingUnit != none && castingUnit.IsA( 'H7CombatHero' ) )
	{
		heroUnit = H7CombatHero( castingUnit );

		heroSkills = heroUnit.GetSkillManager().GetAllSkills();
		foreach heroSkills( heroSkill ) 
		{
			if( heroSkill.GetSchool() == GetSchool() )
			{
				forceRankValue = heroskill.GetCurrentSkillRank();
			}
		}
	
	}
	
	// get the damage range arcording the Rank
	switch( forceRankValue ) 
	{
		case SR_NOVICE:
			return damage.mNovice;
		case SR_EXPERT:
			return damage.mExpert;
		case SR_MASTER:
			return damage.mMaster;
		case SR_UNSKILLED:
		default :
			return damage.mUnskilled;
	}
	return damage.mUnskilled;
}

// unused
// - was planned at some point to group effects to categories
function AddLog(ELogType type,float value)
{
	local H7TooltipLogEntry entry;
	entry.type = type;
	entry.value = value;
	mTooltipLog.AddItem(entry);
	// OPTIONAL consolidate 1 entry per type and SUM 
}

function AddRepl(String placeholder,String value)
{
	local H7TooltipReplacementEntry entry;
	entry.placeholder = placeholder;
	entry.value = value;
	mTooltipMapping.AddItem(entry);
}

function bool IsArchetype()
{
	return class'H7GameUtility'.static.IsArchetype(self);
}

function bool IsLocaKey(string unknown)
{
	return class'H7Loca'.static.IsLocaKey(unknown);
}

// retrieves all placeholders from the string and adds them to the self.mTooltipMapping Replacement Buffer to be used in GetTooltip()
function AddPlaceholdersToReplBuffer(string stringContainingPlaceholders,optional ESkillRank considerOnlyEffectsOfRank = SR_ALL_RANKS, optional H7UnitSnapShot myCaster)
{
	local array<string> placeholders;
	local string placeholder;
	local H7Effect effect;

	placeholders = GetPlaceHolders(stringContainingPlaceholders);
	foreach placeholders(placeholder)
	{
		ResolvePlaceholder(placeholder,false,considerOnlyEffectsOfRank, myCaster);
	}

	// clean up eventual buffs/other effect containers that were generated
	foreach mInstanciatedEffects(effect)
	{
		effect.ClearTooltipContainerInstance();
	}
}

static function string ResolveIconPlaceholder(string selector)
{
	local Texture2D iconTexture;

	if(Caps(Left(selector,5)) == "%ICON")
	{
		iconTexture = class'H7PlayerController'.static.GetPlayerController().GetHud().GetSchoolIcons().GetSchoolIconByStr("school" $ Mid(selector,5)); // %icon_might -> school_might // OPTIONAL schoolInText
		if(iconTexture == none)
		{ 
			iconTexture = class'H7PlayerController'.static.GetPlayerController().GetHud().GetStatIconsInText().GetStatIconByStr("stat" $ Mid(selector,5)); // %icon_xp -> stat_gold
		}
		if(iconTexture == none)
		{
			if(class'H7AdventureController'.static.GetInstance() != none
				&& class'H7AdventureController'.static.GetInstance().GetLocalPlayer() != none)
			{
				iconTexture = class'H7AdventureController'.static.GetInstance().GetLocalPlayer().GetResourceSet().GetIconByStr(Mid(selector,6)); // %icon_gold -> gold // OPTIONAL resourceInText
			}
			else if(class'H7GameData'.static.GetInstance().GetResourceSet() != none)
			{
				iconTexture = class'H7GameData'.static.GetInstance().GetResourceSet().GetIconByStr(Mid(selector,6));
			}
			else
			{
				;
			}
		}
	}
	if(iconTexture == none)
	{
		return selector; // could not replace it with icon, leave it
	}
	else
	{
		return "<img src='img://" $ PathName(iconTexture) $ "' width='#TT_POINT#' height='#TT_POINT#'>";
	}
}

// placeholder = %dam.val
// shouldReturn=false   adds all data to AddRepl to be later integrated into the tooltip
// shouldReturn=true    returns the string that the placeholder would become
function string ResolvePlaceholder(string placeholder,optional bool shouldReturn=false,optional ESkillRank considerOnlyEffectsOfRank = SR_ALL_RANKS, optional H7UnitSnapShot myCaster)
{
	local string selector,prop,resolveStr;
	local int numberOfEffects,group,tmp;
	local H7Effect effect;
	
	//`log_dui("  ResolvePlaceholder" @ placeholder @ self);
	
	SplitPlaceholder(placeholder,selector,group,prop);

	switch(selector)
	{
		// selecting my properties %tt %name
		case "%":resolveStr = GetName();break;
		case "%name":case "%name.":resolveStr = GetName();break;
		case "%x":tmp = H7BaseAbility(self).GetTargetArea().X;resolveStr = String(tmp);break;
		case "%y":tmp = H7BaseAbility(self).GetTargetArea().Y;resolveStr = String(tmp);break;
		case "%durnow":
			if(H7BaseBuff(self) != none)
			{
				tmp = H7BaseBuff(self).GetCurrentDuration();
				resolveStr = String(tmp);
			}
			else
			{
				return "?";
			}
			break; // %durini %durmod (there are no properties like that, there are only effects like that)
		// selecting effect properties (i.e. %buff.name %stat.val)
		default:
		
		if(selector == "%e")
		{
			// don't for now, let the old    system handle it, it's better result
			resolveStr = placeholder;
		}
		else if(Caps(left(selector,5)) == "%ICON")
		{
			resolveStr = ResolveIconPlaceholder(selector);
		}
		else
		{
			effect = GetEffectBySelector(selector,myCaster == none ? GetInitiator() : H7ICaster( myCaster ),numberOfEffects,group,considerOnlyEffectsOfRank);
			if(numberOfEffects == 0)
			{
				if(class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenEffects())
				{
					resolveStr = "0effects(" $ GetName() $ considerOnlyEffectsOfRank $ "->" $ placeholder $ ")";
				}
				else
				{
					// unknown/unresolvable placeholder go here
					resolveStr = placeholder; // keep this as long as %e1 etc can be later resolved correctly or %x or %y
				}
				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(GetDebugName() @ "hits no effects with" @ placeholder,MD_QA_LOG);;
			}
			else if(numberOfEffects == 1)
			{
				resolveStr = effect.GetProperty(prop,considerOnlyEffectsOfRank, myCaster);
			}
			else // >1 >1effects >1 effects
			{
				// special hack if we want icon and hit multiple effects => just take any one, because we assume (hope) that all effects have same icon
				if(prop == "icon")
				{
					resolveStr = effect.GetProperty(prop,considerOnlyEffectsOfRank, myCaster);
				}
				else
				{
					if(class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenEffects())
					{
						resolveStr = numberOfEffects $ "effects(" $ GetName() $ considerOnlyEffectsOfRank $ "->" $ placeholder $ ")";
					}
					else
					{
						resolveStr = ""; // empty so that guild spells show empty, in theory can be changed once no guildspell has placeholder anymore // OPTIONAL
					}
					class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(GetDebugName() @ "hits multiple effects with" @ placeholder,MD_QA_LOG);;
				}
			}
		}
	}

	if(shouldReturn)
	{
		//`log_dui("return" @ placeholder @ resolveStr);
		return resolveStr;
	}
	else
	{
		//`log_dui("AddRepl" @ placeholder @ resolveStr);
		AddRepl(placeholder,resolveStr);
		return "";
	}
}

// placeholder  ->  selector    group   prop
// %stat1.val   ->  stat        1       val
function SplitPlaceholder(string placeholder,out string selector,out int group,out string prop)
{
	local int i;
	local string selectorEnd;

	selector = "";
	group = 0;
	prop = "";

	i = InStr(placeholder,".");
	if(i > INDEX_NONE)
	{
		selector = Mid(placeholder,0,i);
		prop = Mid(placeholder,i+1,Len(placeholder));
	}
	else
	{
		selector = placeholder;
	}

	selectorEnd = Right(selector,1);
	if(int(selectorEnd) > 0)
	{
		selector = Mid(selector,0,Len(selector)-1);
		group = int(selectorEnd);
	}

	//`log_dui("    SplitPlaceholder done" @ placeholder @ "->" @ selector @ group @ prop);
}

static function bool IsAllowedChar(string char)
{
	local int c;

	c = Asc(char);
	if( c == Clamp(c, 48, 57) ) // 0-9
		return true;
	else if ( c == Clamp(c, 65, 90) ) // A-Z
		return true;
	else if ( c == Clamp(c, 97, 122) ) // a-z
		return true;
	else if( char == "." )
		return true;
	else if( char == "_" )
		return true;
	
	return false;
}

static function array<string> GetPlaceholdersNew(string str)
{
	local string placeholder;
	local array<string> placeholders;
	local int current,start,end,i;

	current = 0;
	
	while(current < Len(str) && current != INDEX_NONE)
	{
		start = InStr(str,"%",false,true,current); // find next %
		if(start != INDEX_NONE)
		{
			i = start + 1;
			while(i < Len(str) && IsAllowedChar(Mid(str,i,1)))
			{
				i++;
			}
			end = i; // i reached the first not-allowed char, which is now the end

			if(end == start) break; // in case % is at the end of the string

			placeholder = Mid(str,start,end-start);
			
			// kill end "."
			if(Instr(placeholder,".",false,false,Len(placeholder)-1) != INDEX_NONE) placeholder = Mid(placeholder,0,Len(placeholder)-1);

			if(placeholder != "%")
			{
				placeholders.AddItem(placeholder);
				//`log_dui("found placeholder" @ placeholder @ start @ minend @ self);
			}
			//`log_dui("current = minend" @ minend);
			current = end;
		}
		else 
		{
			// exit
			current = Len(str);
			break;
		}
	}
	return placeholders;
}

static function array<string> GetPlaceholders(string str)
{
	local string placeholder,endchar;
	local array<string> placeholders,endchars;
	local int current,start,end,minend;

	return GetPlaceholdersNew(str);

	// possible ends of a placeholder: (ending . is filtered later, because it can be in the middle of a placeholder)
	endchars.AddItem(" ");
	endchars.AddItem("?"); // this is the special french space bar LOL
	endchars.AddItem("\n");
	endchars.AddItem(",");
	endchars.AddItem("%");
	endchars.AddItem("-");
	endchars.AddItem("/");
	endchars.AddItem("<");
	endchars.AddItem("?");
	endchars.AddItem("?");
	endchars.AddItem("?");
	endchars.AddItem(":");
	endchars.AddItem(",");
	endchars.AddItem(")");
	endchars.AddItem(Chr(12290));
	endchars.AddItem(Chr(65289));
	endchars.AddItem(Chr(65292));

	// OPTIONAL invert the whole function and switch to regex of a placeholder

	//str = GetTooltipLocalized( GetInitiator() );

	current = 0;
	
	while(current < Len(str) && current != INDEX_NONE)
	{
		start = InStr(str,"%",false,true,current);
		if(start != INDEX_NONE)
		{
			minend = 9999;
			foreach endchars(endchar)
			{
				end = InStr(str,endchar,false,true,start+1);
				//`log_dui("start" @ start @ "endchar" @ endchar @ "at position:" @ end $ "/" $ Len(str) );
				if(end != INDEX_NONE) minend = Min(minend,end);
			}

			if(minend == start) break; // in case % is at the end of the string

			placeholder = Mid(str,start,minend-start);
			
			// kill end "."
			if(Instr(placeholder,".",false,false,Len(placeholder)-1) != INDEX_NONE) placeholder = Mid(placeholder,0,Len(placeholder)-1);

			if(placeholder != "%")
			{
				placeholders.AddItem(placeholder);
				//`log_dui("found placeholder" @ placeholder @ start @ minend @ self);
			}
			//`log_dui("current = minend" @ minend);
			current = minend;
		}
		else 
		{
			// exit
			current = Len(str);
			break;
		}
	}
	return placeholders;
}

function string GetTooltip(optional bool extendedVersion,optional string overwriteBaseString,optional ESkillRank considerOnlyEffectsOfRank=SR_ALL_RANKS, optional bool resetRankOverride = true)
{ 
	local H7TooltipReplacementEntry entry;
	local String valueColoredHTML;
	local String valueColor;
	local String displayedValue;
	local String displayedTooltip;
	local H7Effect effect;
	local array<H7Effect> effectsAtThisRank;
	local int i;
	local H7ICaster casterOriginal;

	// archetypes can no longer return tooltips, because they don't have a caster
	if(IsArchetype())
	{
		;
		scripttrace();
		return "IsArchetype";
	}

	// auto instanciate effects - will be cleaned up at end of function
	if(!mInstanciatedEffectsDone)
	{
		mInstanciatedEffectsByTooltip = true;
		InstanciateEffectsFromStructData();
	}

	if(mCaster != none)
	{
		casterOriginal = mCaster.GetOriginal();
		if( mCasterSnapShot != none && casterOriginal != none && mCasterSnapShot.GetOriginal() == casterOriginal )
		{
			if( casterOriginal == none ) casterOriginal = mCasterSnapShot.GetOriginal();
			if( H7BaseAbility( self ) != none && H7EditorHero( casterOriginal ) != none )
			{
				H7EditorHero( casterOriginal ).SetCurrentPreviewAbility( H7BaseAbility( self ) );
				mCasterSnapShot.UpdateSnapShot();
			}
		}
		else
		{
			if( casterOriginal != none && H7EditorHero( casterOriginal ) != none && H7BaseAbility( self ) != none )
			{
				H7EditorHero( casterOriginal ).SetCurrentPreviewAbility( H7BaseAbility( self ) );
				if( mCasterSnapShot == none )
					mCasterSnapShot = new class'H7UnitSnapShot'();

				if( mCasterSnapShot.GetOriginal() != casterOriginal )
					mCasterSnapShot.TakeSnapShot( casterOriginal );
				else
					mCasterSnapShot.UpdateSnapShot();
			}
		}
	}
	if(overwriteBaseString != "")
	{
		displayedTooltip = overwriteBaseString;
	}
	else
	{
		displayedTooltip = GetTooltipLocalized( mCasterSnapShot );
	}
	
	// ------ main replacement action ------
	AddPlaceholdersToReplBuffer(displayedTooltip,considerOnlyEffectsOfRank, mCasterSnapShot);
	// ------ main replacement action ------
	
	// add effect lists automatically
	if(class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mAutogeneratedTooltipExtension)
	{
		displayedTooltip = "<font size='#TT_POINT#'>" $ GetTooltipEffectLists() $ "</font>" $ "<br>" $ displayedTooltip;;
	}                                                

	// old %e replacements, still kept in for now
	GetEffects( effectsAtThisRank, mCasterSnapShot != none ? mCasterSnapShot.GetOriginal() : mCaster );
	foreach effectsAtThisRank(effect,i)
	{
		AddRepl("%e"$(i+1),effect.GetTooltipReplacement());
	}

	if(mInstanciatedEffectsByTooltip) 
	{
		mInstanciatedEffectsByTooltip = false;
		DeleteAllInstanciatedEffects();
	}

	SortTooltipMapping();

	// visuals	
	foreach mTooltipMapping(entry)
	{
		//`log_dui("replacing" @ entry.placeholder @ entry.value @ "in" @ displayedTooltip);
		if( InStr(displayedTooltip,entry.placeholder) == INDEX_NONE ) continue;

		switch(entry.placeholder)
		{
			// OPTIONAL modable
			//case "%d":case "%dmin":case "%dmax":valueColor = GetSchoolColor(GetSchool()); break; // [d]damage
			case "%h":case "%hmin":case "%hmax":valueColor = GetSchoolColor(GetSchool()); break; // [h]eal
			case "%s":valueColor = "ff9900";break; // [s]severity
			case "%t":valueColor = "66ffff";break; // [t]urns / duration
			case "%e":valueColor = "cc00bb";break; // ar[e]a of Effect
			case "%bn":valueColor = "ffcc99";break; // [b]uff[n]ame
			case "%bt":valueColor = "";break; // [b]uff[t]ooltip -> no special color
			case "%e1":case "%e2":case "%e3":case "%e4":case "%e5":case "%e6":case "%e7":case "%e8":case "%e9":case "%e10":valueColor = "ffcc99";break;
			default:
				valueColor = class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.UnrealColorToHex(class'H7GUIGeneralProperties'.static.GetInstance().mTextColors.mReplacementColor);
				//valueColor = "cccccc";
			break; // no specific type defined -> default color grey
		}
		
		displayedValue = entry.value;
		
		// apply color
		if(valueColor != "" && InStr(displayedValue,"<img") == INDEX_NONE) // only add color if there is no img (color+img destroys everything)
		{
			valueColoredHTML = "<font color='#"$valueColor$"'>"$displayedValue$"</font>";
		}
		else
		{
			valueColoredHTML = displayedValue;
		}

		// school icon and school name for damage and heal
		//if(entry.placeholder == "%d" || entry.placeholder == "%h" )
		//{
		//	valueColoredHTML = valueColoredHTML @ "<img width='#TT_POINT#' height='#TT_POINT#' src='" $ GetSchoolFlashPath(GetSchool()) $ "'>" @ GetSchoolName(GetSchool());
		//}

		// buff sub tooltip, used to be wrapped in <li>
		if(entry.placeholder == "%bt")
		{
			valueColoredHTML = "<p>"$valueColoredHTML$"</p>";
		}
		
		displayedTooltip = Repl(displayedTooltip,entry.placeholder,valueColoredHTML);
	}
	
	// overall wrapper
	displayedTooltip = "<font size='#TT_BODY#'>" $ displayedTooltip $ "</font>";

	// cleanup
	mTooltipMapping.Remove(0,mTooltipMapping.Length);
	
	//`log_dui("Final tt" @ displayedTooltip);
	if( casterOriginal != none && H7EditorHero( casterOriginal ) != none )
	{
		H7EditorHero( casterOriginal ).SetCurrentPreviewAbility( none );
	}
	if( class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult() != none )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetGameProcessor().GetMainResult().ClearConditionalStatMods();
	}

	if( resetRankOverride )
	{
		mRankOverride = SR_MAX;
	}

	return displayedTooltip;
}

function SortTooltipMapping()
{
	mTooltipMapping.Sort(TooltipMappingCompare);
}

// longest ones first
function int TooltipMappingCompare(H7TooltipReplacementEntry a, H7TooltipReplacementEntry b)
{
	if(Len(b.placeholder) < Len(a.placeholder)) return 1; // ok keep it
	if(Len(a.placeholder) < Len(b.placeholder)) return -1; // swap it
	return 0;
}

// OPTIONAL more global & more modable
static function string GetSchoolFlashPath(EAbilitySchool school)
{
	return class'H7PlayerController'.static.GetPlayerController().GetHud().GetProperties().mMagicSchoolIcons.GetSchoolIconPath(school);
}

static function string GetSchoolName(EAbilitySchool school)
{
	return class'H7Loca'.static.LocalizeSave("SCHOOL_" $ school,"H7Abilities");
}

static function string GetSchoolDamageName(EAbilitySchool school)
{
	return class'H7Loca'.static.LocalizeSave("DAMAGE_SCHOOL_" $ school,"H7Abilities");
}

static function string GetSchoolColor(EAbilitySchool school)
{
	local string valueColor;

	switch(school)
	{
		case MIGHT:valueColor = "646464";break;
		case AIR_MAGIC:valueColor = "BBC5CA";break;
		case DARK_MAGIC:valueColor = "382E83";break;
		case EARTH_MAGIC:valueColor = "7AA03B";break;
		case FIRE_MAGIC:valueColor = "D52707";break;
		case LIGHT_MAGIC:valueColor = "FFE275";break;
		case PRIME_MAGIC:valueColor = "592A7B";break;
		case WATER_MAGIC:valueColor = "4F6DAB";break;
	}

	return valueColor;
}

function DeleteAllInstanciatedEffects()
{
	local H7Effect effect;

	//`log_dui(self @ self.GetName() @ "DeleteAllInstanciatedEffects");

	foreach mInstanciatedEffects(effect)
	{
		if(!effect.GetSource().IsArchetype())
		{
			effect.UnregisterTrigger();
		}
		effect.ClearTooltipContainerInstance();
	}
	mInstanciatedEffects.Remove(0, mInstanciatedEffects.Length );
	mInstanciatedEffectsDone = false;
}
// and register
native function InstanciateEffectsFromStructData(optional bool registerEffects=true);

native function GetProductionEffectSpecials(out array<H7EffectSpecialAddResources> produc);

function array<H7Effect> GetEffectsOfType( name typeName )
{
	local array<H7Effect> effects;
	local H7Effect currentEffect;

	foreach mInstanciatedEffects( currentEffect )
	{
		if( currentEffect.IsA( typeName ) )
		{
			effects.AddItem( currentEffect );
		}
	}

	return effects;
}

// dios mio
native function int GetTeleportEffectRange();

native function GetEffects( out array<H7Effect> effects, H7ICaster caster );

function array<H7Effect> GetEffectOnRank(ESkillRank rank)
{
	local array<H7Effect> rankEffects;
	local H7Effect effect;

	foreach mInstanciatedEffects(effect)
	{
		if(effect.GetRequiredRank() == rank || effect.GetRequiredRank() == SR_ALL_RANKS )
		{
			rankEffects.AddItem(effect);
		}
	}

	return rankEffects;
}

function String GetEffectOnRankAsLine(ESkillRank rank) // rankline
{
	local array<H7Effect> rankEffects;
	local H7Effect effect;
	local String line,and,durationDisplay,durationTickEvent,buffLine;
	local int duration;
	local H7Basebuff buff;

	//else line = "(";

	and = "";

	rankEffects = GetEffectOnRank(rank);
	foreach rankEffects(effect)
	{
		if(effect.IsA('H7EffectDuration') || effect.IsA('H7EffectDurationModifier')) continue; // don't show duration mods here, they are added at the bottom
		if(effect.GetConditons().mExtededAbilityParameters.HasAbility != none) continue; // don't show skill conditional effects
		if(self.IsA('H7BaseBuff') && effect.IsA('H7BaseBuff')) continue; // don't show buffs in buffs
		if(effect.GetRequiredRank() == SR_ALL_RANKS) 
		{
			// don't show all ranks
			// except if it is a buff, it could have ranks inside it
			if(effect.IsA('H7EffectWithSpells') && H7EffectWithSpells(effect).GetData().mSpellStruct.mSpell.IsA('H7BaseBuff'))
			{
				// show it
			}
			else
			{
				continue;
			}
		}

		// only for abilities, look inside their buffs and show buff effects
		if(effect.IsA('H7EffectWithSpells') && H7EffectWithSpells(effect).GetData().mSpellStruct.mSpell.IsA('H7BaseBuff'))
		{
			if(!self.IsA('H7HeroAbility')) 
			{
				;
				line = line $ and $ effect.GetTooltipReplacement();
			}
			else
			{
				buff = H7Basebuff(H7EffectWithSpells(effect).GetData().mSpellStruct.mSpell);
				buff = new buff.Class(buff);
				buff.Init(,,true);
				buffLine = buff.GetEffectOnRankAsLine(rank);
				if(buffLine != "") // buff did indeed have rank specific stuff inside of it
				{
					line = line $ and $ buffLine;
				}
				//if( buff.DidInstanciateEffects() )
				//{
				//	buff.DeleteAllInstanciatedEffects();
				//}
			}
		}
		else
		{
			line = line $ and $ effect.GetTooltipReplacement();
		}
		and = " " $ class'H7Loca'.static.LocalizeSave("AND","H7General") $ " ";
	}

	// if this is a buff we get the duration effect and add it to the line at the end
	if(self.IsA('H7BaseBuff'))
	{
		// we need 2 infos for buff durations:
		// 1) the time-number (H7EffectDuration)
		//    - if there are multiples we are screwed here
		// 2) the time-entity - the event(s) the number ticks down (H7EffectDurationModifier)
		//    - if there are multiples we are screwed here
		//    - if there are not -1 we are screwed here
		// 1) the time-number
		foreach rankEffects(effect)
		{
			if(!effect.IsA('H7EffectDuration')) continue;
			if(effect.GetRequiredRank() == SR_ALL_RANKS) continue; // don't show all ranks

			duration = H7EffectDuration(effect).GetFinalDuration(durationDisplay);

			if(durationDisplay == "") durationDisplay = String(duration);
			else ;
		}
		// 2) the time-entity (charges, days, weeks, turns, movements, turn ends, turn starts, .........)
		foreach rankEffects(effect)
		{
			if(!effect.IsA('H7EffectDurationModifier')) continue;
			
			if(durationTickEvent == "") durationTickEvent = GetTimeEntityByEvent(H7EffectDurationModifier(effect).GetTrigger().mTriggerType);
			else ;
		}

		if(durationDisplay != "") // there was a rank dependent duration number
		{
			line = line @ Repl(Repl(class'H7Loca'.static.LocalizeSave("BUFF_TIME","H7Abilities"),"%number",durationDisplay),"%turns",durationTickEvent);
		}

		//line = line $ ")";
	}

	if(line != "")
	{
		if(!self.IsA('H7BaseBuff')) line = "<b>" $ class'H7Loca'.static.LocalizeSave(String(rank),"H7Abilities") $ ":</b>" @ line;
	}

	return line;
}

function String GetTimeEntityByEvent(ETrigger event)
{
	local string key;
	switch(event)
	{
		case ON_DO_DAMAGE:case ON_DO_ATTACK:case ON_GET_ATTACKED:case ON_GET_IMPACT:case ON_GET_DAMAGE:
			key = "TIME_ENTITY_ATTACKS";break;
		case ON_UNIT_TURN_START:case ON_UNIT_TURN_END:
			key = "TIME_ENTITY_UNIT_TURNS";break;
		case ON_COMBAT_TURN_START:case ON_COMBAT_TURN_END:
			key = "TIME_ENTITY_COMBAT_TURNS";break;
		case ON_COMBAT_START:case ON_COMBAT_END:
			key = "TIME_ENTITY_COMBATS";break;
		case ON_BEGIN_OF_DAY:case ON_END_OF_DAY:
			key = "TIME_ENTITY_DAYS";break;
		case ON_END_OF_WEEK:
			key = "TIME_ENTITY_WEEKS";break;
		case ON_MOVE:
			key = "TIME_ENTITY_MOVES";break;
		default:
			return class'H7Loca'.static.LocalizeSave("TIME_ENTITY_UNKNOWN","H7Abilities") @ class'H7Loca'.static.LocalizeSave(String(event),"H7Abilities");
	}
	return class'H7Loca'.static.LocalizeSave(key,"H7Abilities");	
}

function array<H7Effect> GetAllEffects()
{
	return mInstanciatedEffects;
}

function int GetEffectsLength()
{
	return mInstanciatedEffects.Length;
}

function ESkillRank GetCorrespondingRank()
{
	if(mCaster != none && H7CombatHero(mCaster) != none)
	{
		return H7CombatHero(mCaster).GetSkillManager().GetSkillBySkillType( GetSkillType() ).GetCurrentSkillRank();
	}
	else if(mOwner != none && H7CombatHero(mOwner) != none)
	{
		return H7CombatHero(mOwner).GetSkillManager().GetSkillBySkillType( GetSkillType() ).GetCurrentSkillRank();
	}
	else
	{
		;
		return SR_NOVICE;
	}
}

// autogenerated effect list (for debug tooltips)
function String GetTooltipEffectLists(optional bool allRanks=true)
{
	local H7Effect effect;
	local array<H7Effect> effects;
	local String tooltip;

	if(allRanks)
	{
		effects = mInstanciatedEffects;
	}
	else
	{
		effects = GetEffectOnRank(GetCorrespondingRank());		
	}
	
	if(effects.Length > 0)
	{
		tooltip = tooltip $ "<li><font color='#ffcc99'>Effects:</font></li>";
			
		foreach effects(effect)
		{
			tooltip = tooltip $ "<li>" $ effect.GetTooltipLine(false,none,allRanks) $ "</li>";
		}
	}
	else
	{
		tooltip = tooltip $ "<li><font color='#999999'>No Instanciated Effects found</font></li>";
	}
	
	return tooltip;
}

function int GetNumGroups(name effectClassName)
{
	local H7Effect effect;
	local array<int> groups;

	foreach mInstanciatedEffects(effect)
	{
		if(effect.isA(effectClassName))
		{
			if(groups.Find(effect.GetGroup()) == INDEX_NONE)
			{
				groups.AddItem(effect.GetGroup());
			}
		}
	}
	return groups.Length;
}

// multi shortcut, returns first match
// info - caster rank has higher priority than considerOnlyEffectsOfRank
function H7Effect GetEffectBySelector(string selector, optional H7ICaster caster, optional out int number, optional int group = INDEX_NONE,optional ESkillRank considerOnlyEffectsOfRank = SR_ALL_RANKS)
{
	local H7Effect effect,returnEffect;
	local name effectClassName;
	local int i;

	number = 0;
	foreach mInstanciatedEffects(effect,i)
	{
		effectClassName = GetClassNameBySelector(selector);
		if(effect.IsA(effectClassName)
			&& (group == INDEX_NONE || group == 0 || effect.GetGroup() == group || (selector == "%e" && i+1 == group)) // OPTIONAL remove tmp %e fix
			&& ( 
				(caster == none && (considerOnlyEffectsOfRank == SR_ALL_RANKS || considerOnlyEffectsOfRank == effect.GetRequiredRank() || effect.GetRequiredRank() == SR_ALL_RANKS) ) 
				|| ( caster != none && effect.RankCheck( caster.GetOriginal()) ) 
				)
			&& FullfillsSpecialSelectorCondition(selector,effect)
			)
		{
			if(returnEffect == none) returnEffect = effect;
			number++;
		}
	}

	// hack to find effects you don't really have the rank for, redo search without rankcheck, and take the first groupmatching effect it finds
	// (when a master hero wants to find a novice effect, this is used in defense,offense,leadership and righteousness)
	if(caster != none && number == 0)
	{
		foreach mInstanciatedEffects(effect,i)
		{
			effectClassName = GetClassNameBySelector(selector);
			if(effect.IsA(effectClassName)
				&& (group == INDEX_NONE || group == 0 || effect.GetGroup() == group || (selector == "%e" && i+1 == group)) // OPTIONAL remove tmp %e fix
				&& FullfillsSpecialSelectorCondition(selector,effect)
				)
			{
				if(returnEffect == none) returnEffect = effect;
				number++;
				return returnEffect;
			}
		}
	}

	return returnEffect;
}

function bool FullfillsSpecialSelectorCondition(string selector,H7Effect effect)
{
	if(selector == "%buff")
	{
		if(H7EffectWithSpells(effect).GetData().mSpellStruct.mSpell.IsA('H7BaseBuff') 
			&& H7EffectWithSpells(effect).GetData().mSpellStruct.mSpellOperation == ADD_BUFF
			)
			return true;
		else return false;
	}
	return true;
}

function Name GetClassNameBySelector(string selector)
{
	switch(selector)
	{
		case "%damage":case "%dam":case "%d":return 'H7EffectDamage';
		case "%stat":return 'H7EffectOnStats';
		case "%res":return 'H7EffectOnResistance';
		case "%command":return 'H7EffectCommand';
		case "%special":return 'H7EffectSpecial';
		case "%buff":return 'H7EffectWithSpells';
		case "%spell":return 'H7EffectWithSpells';
		case "%stat":return 'H7EffectOnStats';
		case "%durini":return 'H7EffectDuration';
		case "%durmod":return 'H7EffectDurationModifier';
		case "%e":return 'H7Effect';
		default: ; 
	}
	return 'none';
}

function H7DamageEffect GetEffectDamage()
{
	local int i;
	local H7DamageEffect damage;

	for( i = 0; i < mDamageEffects.Length; ++i )
	{
		return mDamageEffects[i];
	}

	return damage;
}

// Damage shortcut
function H7EffectDamage GetDamageEffect(H7ICaster caster, optional out int number)
{
	local H7Effect effect;
	local H7EffectDamage returnEffect;
	number = 0;

	if( IsArchetype() || mInstanciatedEffects.Length == 0 )
	{
		;
		return returnEffect;
	}
	foreach mInstanciatedEffects(effect)
	{
		if(H7EffectDamage(effect) != none && (caster == none || effect.RankCheck(caster)))
		{
			if(returnEffect == none) returnEffect = H7EffectDamage(effect);
			number++;
		}
	}
	return returnEffect;
}

// Buff shortcut
function H7EffectWithSpells GetBuffEffect(H7ICaster caster = none, optional out int number)
{
	local H7Effect effect;
	local H7EffectWithSpells returnEffect;
	number = 0;
	foreach mInstanciatedEffects(effect)
	{
		if(H7EffectWithSpells(effect) != none && H7EffectWithSpells(effect).GetData().mSpellStruct.mSpell.IsA('H7BaseBuff') 
			&& H7EffectWithSpells(effect).GetData().mSpellStruct.mSpellOperation == ADD_BUFF
			&& (caster == none || effect.RankCheck(caster)))
		{
			if(returnEffect == none) returnEffect = H7EffectWithSpells(effect);
			number++;
		}
	}
	return returnEffect;
}

// item - owner
// buff - caster,target
// skill - owner
// ability - caster,target
// TODO immunity check needed?
native function GetPermanentStatMods( out array<H7MeModifiesStat> outStats, H7IEffectTargetable target );  // GetPersistentStatMods

native function GetPersistentResistanceEffects( out array<H7EffectOnResistance> effects );

native function bool CanAffectAlly();

native function bool CanAffectEnemy();

native function bool CanAffectDead();

native function GetShieldEffects( out array<H7EffectSpecialShieldEffect> effects );

// still returns true, even if the effect is not used/executed due to rank or condition
function bool HasNegativeEffect()
{
	local array<H7Effect> effects;
	local H7Effect effect;

	GetEffects( effects, none );

	foreach effects( effect )
	{
		if( effect.HasTag( TAG_NEGATIVE_EFFECT ) )
		{
			return true;
		}
	}
	return false;
}

// still returns true, even if the effect is not used/executed due to rank or condition
function bool HasPositiveEffect(optional H7IEffectTargetable target)
{
	local array<H7Effect> effects;
	local H7Effect effect;
	local array<ESpellTag> tags;

	GetEffects( effects, none );

	foreach effects( effect )
	{
		if( effect.HasTag( TAG_POSITIVE_EFFECT ) )
		{
			if(target != none && effect.HasTag(TAG_HEAL))
			{
				tags.AddItem(TAG_HEAL);
				// check for construct creatures, that have a resistance against all healing effects
				if(target.GetResistanceModifierFor(ALL_MAGIC, tags) == 0.0f)
				{
					return false;
				}
			}
			return true;
		}
	}
	return false;
}

// still returns false, even if the effect is not used/executed due to rank or condition
// ! does not do Ability.CheckValidTargets which checks the ClassIdentifierthings
function bool TargetIsImmuneToAllEffects(H7IEffectTargetable target)
{
	local H7Effect effect;
	local array<ESpellTag> tags;
	local float modifier;

	foreach mInstanciatedEffects( effect )
	{
		effect.GetTagsPlusBaseTags( tags );
		modifier = target.GetResistanceModifierFor(GetSchool(),tags);
		if(modifier > 0) {return false; }// found one effect that will work
	}

	return true;
}

// 3 checks need to be done for all effects, and if at least one comes through all checks, it's not immune
// 1/3 rankcheck
// 2/3 conditioncheck
// 3/3 resistancecheck
// ! does not do Ability.CheckValidTargets which checks the ClassIdentifierthings
native function bool TargetIsImmuneToAllExecutingEffects(H7IEffectTargetable target);

native function H7EventManager GetEventManager();

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
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

