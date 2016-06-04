//=============================================================================
// H7BuffManager
//=============================================================================
//
// TODO: Serialization
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7BuffManager extends Object
	dependson(H7StructsAndEnumsNative)
	native(Tussi)
	savegame;

var protected savegame array<SavegameBuffStruct> mBuffReferences;
var protected array<H7BaseBuff> mBuffs;
var protected array<H7BaseBuff> mStoredBuffsOnDeath;

var protected H7IEffectTargetable mOwner;

var protected transient int mMaxFrameDelayCount;

function SetOwner( H7IEffectTargetable owner ) { mOwner = owner; }
function array<H7BaseBuff> GetBuffs() { return mBuffs; }

function RemoveAllAuraBuffs()
{
	local int i;
	local bool removedAny;
	local H7EffectContainer src;
	local array<H7BaseBuff> removeThat;

	for( i = 0; i < mBuffs.Length; ++i )
	{
		src = mBuffs[i].GetSourceEffect();
		if( src.IsAbility() && H7BaseAbility( src ).IsAura() )
		{
			removeThat.AddItem( mBuffs[i] );
		}
	}

	removedAny = removeThat.Length > 0;

	for( i = 0; i < removeThat.Length; ++i )
	{
		RemoveBuff( removeThat[i], removeThat[i].GetInitiator(), false, false );
	}

	if( removedAny ) UpdateBuffsDisplay();
}


function RemoveAllDisplayableBuffs(optional bool debuffsOnly = false )
{
	local H7BaseBuff buff;
	local array<H7BaseBuff> removeBuffs;
	local bool updateGui;

	updateGui = false;
	foreach mBuffs( buff )
	{
		if( buff.IsDisplayed())
		{
			if(debuffsOnly && !buff.IsDebuff()) { continue; }

			removeBuffs.AddItem(buff);
			updateGui = true;
		}
	}

	foreach removeBuffs(buff)
	{
		RemoveBuff(buff, buff.GetInitiator());
	}

	if( updateGui ) UpdateBuffsDisplay();
}

function RemoveAllBuffsFromMagicSource()
{
	local H7BaseBuff buff;
	local array<H7BaseBuff> removeBuffs;
	local bool updateGui;

	updateGui = false;
	foreach mBuffs( buff )
	{
		if( buff.IsFromMagicSource())
		{
			removeBuffs.AddItem(buff);
			updateGui = true;
		}
	}

	foreach removeBuffs(buff)
	{
		RemoveBuff(buff, buff.GetInitiator(),,false);
	}

	if( updateGui ) UpdateBuffsDisplay();
}

function RemoveAllDisplayableBuffsBySchool(optional EAbilitySchool filterBySchool )
{
	local H7BaseBuff buff;
	local array<H7BaseBuff> removeBuffs;
	local bool updateGui;

	updateGui = false;
	foreach mBuffs( buff )
	{
		if( buff.IsDisplayed())
		{
			if(buff.GetSchool() != filterBySchool) { continue; }

			removeBuffs.AddItem(buff);
			updateGui = true;
		}
	}

	foreach removeBuffs(buff)
	{
		RemoveBuff(buff, buff.GetInitiator(),, false);
	}

	if( updateGui ) UpdateBuffsDisplay();
}


// removes all buffs from creature stack (except the hero army bonus buff)
function RemoveBuffsFromDeadOwner()
{
	local H7ICaster goddammitUnreal;
	local H7BaseBuff buff;
	local H7BaseBuff armyBonusBuff;
	local bool updateGui;
	local array<H7DurationModifierEffect> durMods;
	local bool expireBuff;

	updateGui = false;
	foreach mBuffs( buff )
	{
		// don't remove this, because it won't be applied again until the next combat!
		if(buff.IsA('H7BuffHeroArmyBonus')) { armyBonusBuff = buff; continue; }

		expireBuff = true;

		mOwner.GetEventManager().UnregisterBySource(buff);
		mOwner.GetEffectManager().RemovePermanentFXBySource(buff);

		if( buff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() ) updateGui = true;

		goddammitUnreal = buff.GetInitiator().GetOriginal();
		// save buffs from passive hero abilities (avoids triggering ON_COMBAT_START on hero again)
		if( buff.IsFromMagicSource() || H7EditorHero( goddammitUnreal ) != none )
		{
			durMods = buff.GetDurationModifierEffects();
			if( durMods.Length == 0 &&
				H7HeroAbility( buff.GetSourceEffect() ) != none &&
				H7HeroAbility( buff.GetSourceEffect() ).IsPassive() )
			{
				mStoredBuffsOnDeath.AddItem( buff );
				expireBuff = false;
			}
		}

		buff.OnExpire(expireBuff);
	}

	mBuffs.Length = 0;
	if(armyBonusBuff != none)
		mBuffs.AddItem(armyBonusBuff);

	if( updateGui ) { UpdateBuffsDisplay(); mOwner.DataChanged("RemoveBuff"); }
}

function RestoreStoredBuffs()
{
	local int i;

	if( mStoredBuffsOnDeath.Length == 0 ) return;

	for( i = 0; i < mStoredBuffsOnDeath.Length; ++i )
	{
		AddBuff( mStoredBuffsOnDeath[i], mStoredBuffsOnDeath[i].GetInitiator().GetOriginal(), mStoredBuffsOnDeath[i].GetSourceEffect(), true );
	}

	mStoredBuffsOnDeath.Length = 0;
}

native function GetActiveBuffs( out array<H7BaseBuff> buffs );

native function bool HasCondition();

native function bool HasPositiveBuff();

native function GetVisibleMagicBuffs( out array<H7BaseBuff> buffs );

function Init( H7IEffectTargetable owner ) 
{
	mOwner = owner;
}

event InitBuffs()
{
	local array<H7BaseBuff> buffs;
	local H7BaseBuff buff;

	buffs = GetBuffs();
	foreach buffs( buff )
	{
		buff.GetEventManager().Raise( ON_INIT, false );
	}
}

native function bool HasBuffMechanic( Class wantedBuffClass);

native function H7BaseBuff GetBuffMechanic( Class buffMechanicClass);

native function GetBuffsByMechanic( out array<H7BaseBuff> buffs, Class buffMechanicClass );

native function bool BuffMatches(H7BaseBuff instanciatedBuff, H7BaseBuff unknownMethodBuff);

native function bool HasBuff( H7BaseBuff wantedBuff, H7ICaster caster, bool isTargetConditionCheck );

native function int GetSizeOfBuffStack(H7BaseBuff newBuff);

native function bool CanStackBuff( H7BaseBuff newBuff, H7ICaster caster );

native function H7BaseBuff GetBuff( H7BaseBuff wantedBuff );

function RemoveBuff( H7BaseBuff buff, optional H7ICaster caster, optional bool showLog=true, optional bool updateGui = true)
{
	local H7Message message;
	local int i;

	local bool buffWasRemoved, needUpdateHUD;

	if( H7Unit( mOwner ) != none )
	{
		H7Unit( mOwner ).ClearStatCache();
	}

	;

	needUpdateHUD = false;
	for( i = mBuffs.Length - 1; i >= 0; --i )
	{   
		if( BuffMatches(mBuffs[i],buff) )
		{
			if( !buff.IsMultipleBuffable() || mBuffs[i].GetInitiator() == caster
				|| (caster.GetOriginal() != none && caster.GetOriginal() == mBuffs[i].GetInitiator().GetOriginal() && caster.GetOriginal() == buff.GetInitiator().GetOriginal() ) )
			{
				// if stackable, check for duration and same source
				if(buff.IsStackable()
					//&& mBuffs[i].GetCurrentDuration() != buff.GetCurrentDuration()
					&& !( buff.GetInitiator() != none && mBuffs[i].GetInitiator().GetOriginal() == buff.GetInitiator().GetOriginal() || caster != none && mBuffs[i].GetInitiator().GetOriginal() == caster ) )
				{
					continue;
				}

				mOwner.GetEventManager().UnregisterBySource(mBuffs[i]);
				mOwner.GetEffectManager().RemovePermanentFXBySource(mBuffs[i]);
				mOwner.DataChanged("RemoveBuff");

				if(showLog 
					&& (buff.GetLogTextOption() == LTO_ALWAYS 
						|| (buff.GetLogTextOption() == LTO_AS_DISPLAYED && buff.IsDisplayed())
						|| class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffsLog()
						)
					)
				{
					message = new class'H7Message';
					message.text = "MSG_LOSE_BUFF";
					message.AddRepl("%owner",mOwner.GetName());
					message.AddRepl("%buff",mBuffs[i].GetName());
					message.destination = MD_LOG;
					message.settings.referenceObject = mOwner;
					class'H7MessageSystem'.static.GetInstance().SendMessage(message);
				}

				// check if HUD needs to update
				if( !needUpdateHUD)
				{
					needUpdateHUD = !( H7BaseAbility( mBuffs[i].GetSourceEffect() ) != none &&
						H7BaseAbility( mBuffs[i].GetSourceEffect() ).IsAura() &&
						H7BaseAbility( mBuffs[i].GetSourceEffect() ).IsPassive() &&
						class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() ) &&
						( mBuffs[i].IsDisplayed() ||
						class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() );
				}

				mBuffs[i].OnExpire();
				mBuffs.RemoveItem( mBuffs[i] );
				buffWasRemoved = true;
			}
		}
	}

	if(buffWasRemoved)
	{
		if( H7Unit( mOwner ) != none )
		{
			H7Unit( mOwner ).ClearStatCache();
		}
		if( needUpdateHUD && updateGui || !class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
		{
			UpdateBuffsDisplay();
		}
	}
	else
	{
		;
	}
}

private function UpdateBuffsDisplay()
{
	if( Actor( mOwner ) != none )
	{
		Actor( mOwner ).SetTimer( 0.3f, false, nameof(UpdateBuffsDisplayDelayed), self );
	}
}

private function UpdateBuffsDisplayDelayed()
{
	if( class'H7CombatHud'.static.GetInstance() != none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateBuffs( H7Unit(mOwner) );
	}
	else if( class'H7AdventureController'.static.GetInstance() != none )
	{
		class'H7AdventureController'.static.GetInstance().UpdateHUD();
	}
}


function H7BaseBuff AddBuff( H7BaseBuff newBuff, H7ICaster caster, optional H7EffectContainer sourceContainer, optional bool restoreOnResurrect = false )
{
	local H7EventContainerStruct eventContainer;
	local H7Message message;
	local bool removedAndAdded,stacked;
	local array<H7Effect> effects;
	local H7Effect effect;

	;

	// no buffs for dead people!
	if(H7CreatureStack(mOwner) != none && H7CreatureStack(mOwner).IsDead() && !newBuff.CanAffectDead()) return none;

	if( H7Unit( mOwner ) != none )
	{
		H7Unit( mOwner ).ClearStatCache();
	}
	if(newBuff.IsArchetype())
	{
		newBuff = new newBuff.Class(newBuff);
	}

	if( sourceContainer != none )
	{
		newBuff.SetSourceEffect( sourceContainer );
		newBuff.SetRankOverride( sourceContainer.GetRankOverride() );
	}
	else if( newBuff.GetSourceEffect() == none )
	{
		;
	}

	if( !newBuff.HasInitiator() )
	{
		newBuff.Init( mOwner, caster );
	}

	//	In case a buff has to be applied and the creature already has the buff, 
	//	then the buff is removed and the new one is applied. If the buff can be
	//	stacked, don't remove it.
	if( HasBuff( newBuff, caster, false ) )
	{
		if(!CanStackBuff(newBuff, caster))
		{
			RemoveBuff( newBuff, caster , false );
			removedAndAdded = true;
		}
		stacked = true;
	}

	mBuffs.AddItem( newBuff );
	mOwner.DataChanged("AddBuff");

	mOwner.TriggerEvents(ON_GET_BUFFED, false);
	
	// tell the buff that it was added
	newBuff.GetEventManager().Raise(ON_ADD_BUFF, false);


	// tell the buff that it has been initialized 
	newBuff.GetEventManager().Raise(ON_AFTER_BUFF_ADD, false, eventContainer );

	if(	!restoreOnResurrect &&
		!( removedAndAdded && sourceContainer != none && H7BaseAbility( sourceContainer ) != none &&
		H7BaseAbility( sourceContainer ).IsAura() && H7BaseAbility( sourceContainer ).GetAuraProperties().mForceReapply ) ) // avoid force-reapply spam
	{
		if( H7VisitableSite( mOwner ) != none || (H7EditorHero(mOwner) != none && !H7EditorHero(mOwner).IsHero()) )
		{
			if( H7VisitableSite( mOwner ) != none && H7Week( newBuff.GetSourceEffect() ) != none )
			{
				H7VisitableSite( mOwner ).AddBuffFlag( newBuff );
			}
			// no log for buildings or fake Heroes
		}
		else
		{
			if( newBuff.GetLogTextOption() == LTO_ALWAYS 
				|| (newBuff.GetLogTextOption() == LTO_AS_DISPLAYED && newBuff.IsDisplayed())
				|| class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffsLog()
				)
			{
				message = new class'H7Message';
				if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap()) // on combat everybody gets it; on adv only owner
				{
					message.mPlayerNumber = mOwner.GetPlayer().GetPlayerNumber();
				}
				if(removedAndAdded) message.text = "MSG_REFRESH_BUFF";
				else if(stacked) message.text = "MSG_STACKS_UP_BUFF";
				else message.text = "MSG_RECIEVE_BUFF";
				message.AddRepl("%owner", mOwner.GetName());
				message.AddRepl("%buff", newBuff.GetName());
				message.destination = MD_LOG;
				message.settings.referenceObject = mOwner;
				class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			}
		}

		// floating texts for creatures:
		if(H7CreatureStack( mOwner ) != none)
		{
			// buff name float:
			if( newBuff.GetFloatingTextOption() == FTO_ALWAYS ||
				newBuff.GetFloatingTextOption() == FTO_AS_DISPLAYED && newBuff.IsDisplayed() )
			{
				message = new class'H7Message';
				message.settings.floatingLocation = H7CreatureStack( mOwner ).GetFloatingTextLocation();
				if(newBuff.IsDebuff()) message.settings.color = MakeColor(255,0,0,255);
				else message.settings.color = MakeColor(0,255,0,255);
				message.settings.floatingType = FCT_BUFF;
				message.settings.referenceObject = mOwner;
				//message.settings.icon = newBuff.GetIcon();

				class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(newBuff.GetName(),MD_FLOATING,message.settings, mOwner.GetPlayer().GetPlayerNumber() );
			}

			// all stats floats:
			newBuff.GetEffects( effects, newBuff.GetInitiator().GetOriginal() );
			foreach effects(effect)
			{
				if(effect.IsA('H7EffectOnStats') && effect.GetTrigger().mTriggerType == PERSISTENT 
					&& H7EffectOnStats(effect).GetData().mStatMod.mShowFloatingText
					&& (effect.GetValue() != 0 
						|| H7EffectOnStats(effect).GetData().mStatMod.mCombineOperation == OP_TYPE_MULTIPLY 
						|| H7EffectOnStats(effect).GetData().mStatMod.mCombineOperation == OP_TYPE_SET
						)
				)
				{
					message = new class'H7Message';
					message.settings.floatingLocation = H7CreatureStack( mOwner ).GetFloatingTextLocation();
					message.text = effect.GetOperation() $ effect.GetValueAsString();
					message.destination = MD_FLOATING;
					message.settings.icon = class'H7GUIGeneralProperties'.static.GetInstance().mStatIcons.GetStatIcon(H7EffectOnStats(effect).GetData().mStatMod.mStat,H7Unit(mOwner));
					if(newBuff.IsDebuff()) message.settings.color = MakeColor(255,0,0,255);
					else message.settings.color = MakeColor(0,255,0,255);
					message.settings.floatingType = FCT_TEXT;
					message.settings.referenceObject = mOwner;
					message.mPlayerNumber = mOwner.GetPlayer().GetPlayerNumber();

					class'H7MessageSystem'.static.GetInstance().SendMessage(message);
				}
			}
		}

	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		// update GUI for buffs that are displayed and aren't applied by an aura (for those, the aura manager will tell the GUI when it's time to update)
		if( ( newBuff.IsDisplayed() || class'H7GUIGeneralProperties'.static.GetInstance().GetOptionHiddenBuffs() ) &&
			!restoreOnResurrect &&
			!( newBuff.GetSourceEffect() == none || newBuff.GetSourceEffect().IsA('H7CreatureAbility') &&
			H7CreatureAbility( newBuff.GetSourceEffect() ).IsPassive() &&
			H7CreatureAbility( newBuff.GetSourceEffect() ).IsAura() ) )
		{
			class'H7CombatHudCntl'.static.GetInstance().GetInitiativeList().UpdateBuffs( H7Unit(mOwner) );
		}
	}
	else
	{
		// TODO check if removable since the listener updates after a new buff?
		if( mOwner.isA( 'H7AdventureHero' ) && mOwner.GetPlayer() == class'H7AdventureController'.static.GetInstance().GetLocalPlayer())
		{
			// keep the current selection of heroes
			class'H7AdventureController'.static.GetInstance().UpdateHUD( class'H7AdventureController'.static.GetInstance().GetLocalPlayerHeroes( false ), H7AdventureHero( mOwner ).GetAdventureArmy(), false );
		}
	}

	// tell the caster that it added a buff
	if( caster != none  )
	{
		eventContainer.EffectContainer = newBuff;
		eventContainer.Targetable = mOwner;
		caster.TriggerEvents( ON_ADD_BUFF, false, eventContainer );
	}

	if( class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() &&  H7Unit(mOwner) != none && newBuff.ChangesInitiative() )
	{
		if( class'H7CombatController'.static.GetInstance().GetInitiativeQueue() != none )
		{
			class'H7CombatController'.static.GetInstance().GetInitiativeQueue().Sort();
		}
	}

	if( H7Unit( mOwner ) != none )
	{
		H7Unit( mOwner ).ClearStatCache();
	}



	return newBuff;
}

/** Returns Waitbuff or None*/
native function static H7BaseBuff GetWaitBuff( H7Unit unit );

native function static H7BaseBuff GetDefendBuff( H7Unit unit );

native function static H7BaseBuff GetMoralBuff( H7Unit unit );


native function CleanBuffsAfterCombat();


native function UpdateBuffEvents( ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container );

native function ResetSimDurations();

native function GetBuffsFromSource( out array<H7BaseBuff> buffs, H7EffectContainer container );

event PostSerialize()
{
	local SavegameBuffStruct buffRef;
	local H7BaseBuff buff, newBuff;
	local H7IEventManagingObject eventManageable;
	local H7ICaster caster;
	local H7EffectContainer container, sauce;

	foreach mBuffReferences( buffRef )
	{
		if(buffRef.BuffReference == "" || buffRef.BuffReference == "MMH7Game.Default__H7BaseBuff") continue; // This should not be serialized in the first place

		buff = H7BaseBuff( DynamicLoadObject( buffRef.BuffReference, class'H7BaseBuff' ) );
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( buffRef.CasterReferenceID );
		container = H7EffectContainer( DynamicLoadObject( buffRef.SourceReference, class'H7EffectContainer' ) );

		caster = H7ICaster( eventManageable );

		if(caster == none) // If there is no caster there is high chance he is not loaded yet, try in one frame (simplest solution, we need object prio for save/load)
		{
			class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(2,DelayedInit);
			return;
		}

		if( H7BaseBuff( container ) != none )
		{
			sauce = caster.GetBuffManager().GetBuff( H7BaseBuff( container ) );
		}
		else if( H7BaseAbility( container ) != none )
		{
			sauce = caster.GetAbilityManager().GetAbility( H7BaseAbility( container ) );
		}
		else if( H7HeroItem( container ) != none && H7AdventureHero( caster ) != none )
		{
			sauce = H7AdventureHero( caster ).GetInventory().GetItem( H7HeroItem( container ) );
		}
		else if( H7Skill( container ) != none && H7AdventureHero( caster ) != none )
		{
			sauce = H7AdventureHero( caster ).GetSkillManager().GetSkillInstance( ,H7Skill( container ) );
		}
		else if( H7Week( container ) != none )
		{
			sauce = class'H7AdventureController'.static.GetInstance().GetCalendar().GetWeekManager().GetCurrentWeek();
		}
		newBuff = AddBuff( buff, caster, sauce );
		newBuff.SetDuration( buffRef.RemainingDuration );
	}

	// Restore all Heroe save values that might have been clamped by initial buff calculation etc.
	if(H7Editorhero(mOwner) != none)
	{
		H7Editorhero(mOwner).RestoreSavedMovementPoints();
	}
}

function DelayedInit()
{
	local SavegameBuffStruct buffRef;
	local H7BaseBuff buff, newBuff;
	local H7IEventManagingObject eventManageable;
	local H7ICaster caster;
	local H7EffectContainer container, sauce;

	foreach mBuffReferences( buffRef )
	{
		buff = H7BaseBuff( DynamicLoadObject( buffRef.BuffReference, class'H7BaseBuff' ) );
		eventManageable = class'H7ReplicationInfo'.static.GetInstance().GetEventManageable( buffRef.CasterReferenceID );
		container = H7EffectContainer( DynamicLoadObject( buffRef.SourceReference, class'H7EffectContainer' ) );

		caster = H7ICaster( eventManageable );

		if(caster == none && mMaxFrameDelayCount > 0) // If there is no caster there is high chance he is not loaded yet, try in one frame (simplest solution, we need object prio for save/load)
		{
			--mMaxFrameDelayCount;
			class'H7PlayerController'.static.GetPlayerController().GetHud().SetFrameTimer(1,DelayedInit);
			return;
		}
		else if(caster == none)
		{
			return;
		}

		if( H7BaseBuff( container ) != none )
		{
			sauce = caster.GetBuffManager().GetBuff( H7BaseBuff( container ) );
		}
		else if( H7BaseAbility( container ) != none )
		{
			sauce = caster.GetAbilityManager().GetAbility( H7BaseAbility( container ) );
		}
		else if( H7HeroItem( container ) != none && H7AdventureHero( caster ) != none )
		{
			sauce = H7AdventureHero( caster ).GetInventory().GetItem( H7HeroItem( container ) );
		}
		else if( H7Skill( container ) != none && H7AdventureHero( caster ) != none )
		{
			sauce = H7AdventureHero( caster ).GetSkillManager().GetSkillInstance( ,H7Skill( container ) );
		}
		else if( H7Week( container ) != none )
		{
			sauce = class'H7AdventureController'.static.GetInstance().GetCalendar().GetWeekManager().GetCurrentWeek();
		}
		newBuff = AddBuff( buff, caster, sauce );
		newBuff.SetDuration( buffRef.RemainingDuration );
	}

	// Restore all Heroe save values that might have been clamped by initial buff calculation etc.
	if(H7Editorhero(mOwner) != none)
	{
		H7Editorhero(mOwner).RestoreSavedMovementPoints();
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)



