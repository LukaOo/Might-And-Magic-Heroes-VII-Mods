//=============================================================================
// H7AbilityManager
//=============================================================================
//
// ...
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7AbilityManager extends Object
	dependsOn(H7BaseAbility)
	native(Tussi)
	savegame;

var protected array<H7BaseAbility> mAbilities;
var protected array<H7BaseAbility> mVolatileAbilities;  //from Items/Buffs...everything not actually learned by the hero
var protected array<H7HeroAbility> mLearnableAbilities;
var protected H7BaseAbility mPendingAbility;

// !! This is backup list and support old saves, new lists are saved in SavegameHeroStruct !!
var savegame array<string> mHeroSpellArchetypeReferences;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
var savegame array<int> mHeroSpellIDs;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
var savegame array<string> mHeroVolatileSpellArchetypeReferences;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
var savegame array<int> mHeroVolatileSpellIDs;    // a list all spell abilities the hero has learned, to have a reference to the orignal archetype in the project
var savegame array<string> mHeroAbilityArchetypeReferences;
var savegame array<int> mHeroAbilityIDs;


// References to learned spell hero had before combat
var protected transient array<string> mPreCombatSpellArchetypeRefs;

var protected H7BaseAbility mPreparedAbility; // ability that is waiting for a target, none = no ability is prepared

var protected H7ICaster mOwner;

function array<string> GetHeroSpellArchRefs() { return mHeroSpellArchetypeReferences; }

function SetOwner( H7ICaster owner )  { mOwner = owner ; } // important for H7EditorHero.OverrideAbilityManager() as newly learned abilities (during combat) need the CombatHero on Init

function array<H7HeroAbility> GetLearnableAbilities()
{
	return mLearnableAbilities;
} 

function AddLearnableAbility( H7HeroAbility ability )
{
	local H7HeroAbility tmpAbility;
	tmpAbility = new class'H7HeroAbility'( ability );
	tmpAbility.SetCaster( mOwner );
	tmpAbility.InstanciateEffectsFromStructData( false );
	mLearnableAbilities.AddItem( tmpAbility );
}

function StoreLearnedSpells()
{
	mPreCombatSpellArchetypeRefs = mHeroSpellArchetypeReferences;
}

function RestoreLearnedSpells()
{
	local int i, j;
	local bool isOnList;
	local array<H7BaseAbility> spellsToUnlearn;

	// Check if all spells are on stored list! If not, Unlearn it.
	for( i = 0; i < mAbilities.Length; ++i)  //IsSpell()
	{
		// Not a spell
		if(!mAbilities[i].IsSpell())
		{
			continue;
		}

		isOnList = true;

		for( j = 0; j < mPreCombatSpellArchetypeRefs.Length; ++j)
		{
			// This spell is on original list -> Skip;
			if( class'H7GameUtility'.static.GetArchetypePath(mAbilities[i]) == mPreCombatSpellArchetypeRefs[j] )
			{
				isOnList = true;

				break;
			}

			isOnList = false;
		}

		if(!isOnList)
		{
			spellsToUnlearn.AddItem(H7BaseAbility(mAbilities[i].ObjectArchetype));
		}
	}

	//`LOG_MP("SkillTrack: "@self@"of owner"@mOwner@"requests RestoreLearnedSpells! He will unlearn"@spellsToUnlearn.Length@"spells!");
	ScriptTrace();

	for(i = 0; i < spellsToUnlearn.Length; ++i)
	{
		UnlearnAbility(spellsToUnlearn[i]);
	}
	
}


function UnlearnBugTrack(H7BaseAbility removeAbility)
{
	//`LOG_MP("SkillTrack : Ability" @removeAbility@ "is being removed from" @self@ "for owner" @mOwner@"!");
	ScriptTrace();
}

function H7BaseAbility  GetPreparedAbility()                        { return mPreparedAbility; } 
function                PrepareAbility ( H7BaseAbility ability )    
{ 
	local H7EventContainerStruct container;
	local H7BaseAbility instAbility, tmpAbiliy;
	local array<H7IEffectTargetable> empty;

	DestroyEffectsSpecialVisualEffects();
	
	if( ability == none )
	{
		mPreparedAbility = none;
		if( H7EditorHero( mOwner ) != none )
			H7EditorHero( mOwner ).SetCurrentPreviewAbility( none );
		return;
	}

	instAbility = GetAbilityByID( ability.GetID() );

	if(instAbility.IsSuppressed())
	{
		;
		instAbility = none;
	}
	
	if( instAbility != none )
	{
		container.Action = ACTION_ABILITY;
		container.Targetable = instAbility.GetTarget();
		container.ActionSchool = instAbility.GetSchool();
		container.ActionTag = instAbility.GetTags();
		container.EffectContainer = instAbility;
	
		instAbility.GetEventManager().Raise( ON_ABILITY_PREPARE, false, container );

		if( instAbility.IsRanged() && !instAbility.HasTag( TAG_DAMAGE_DIRECT ) && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() &&
			H7EditorHero( mOwner ) == none && H7WarUnit( mOwner ) == none )
		{
			class'H7CombatMapGridController'.static.GetInstance().ResetSelectedAndReachableCells();
		}
	}

	if( (mPreparedAbility != none && !ability.IsEqual( mPreparedAbility )) || ( ability == none && mPreparedAbility != none ) )
	{
		tmpAbiliy = GetAbilityByID( mPreparedAbility.GetID() );
		if( tmpAbiliy != none )
		{
			if( class'H7ReplicationInfo'.static.GetInstance().GetTeleportTargetID() != -1
				&& class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() 
				&& mPreparedAbility.IsTeleportSpell())
			{
				class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().RefreshAllUnits();
				class'H7ReplicationInfo'.static.GetInstance().SetTeleportTargetID(-1);
			}

			if( tmpAbiliy.IsTeleportSpell() )
			{
				class'H7CombatController'.static.GetInstance().TeleportSpellWasCanceled();
			}

			if( instAbility.HasTag( TAG_DAMAGE_DIRECT ) && H7EditorHero( mOwner ) == none && H7WarUnit( mOwner ) == none )
			{
				class'H7CombatMapGridController'.static.GetInstance().SelectUnit( H7Unit( mOwner ),true );
				class'H7CombatController'.static.GetInstance().RefreshAllUnits();
			}

			tmpAbiliy.GetEventManager().Raise( ON_ABILITY_UNPREPARE, false, container );
			tmpAbiliy.OverrideTargetType( EAbilityTarget_MAX );
			empty.Length = 0;
			tmpAbiliy.SetTarget( none );
			tmpAbiliy.SetTargets( empty );
		}
	}

	mPreparedAbility = instAbility;
}

function DestroyEffectsSpecialVisualEffects()
{
	if( H7CombatHero( mOwner ) != none && mPreparedAbility != none && class'H7ReplicationInfo'.static.GetInstance().IsCombatMap() )
	{
		class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCombatController().DestroyAllStackGhosts();
	}
}

native function CleanAbilitiesAfterCombat();

native function GetAbilities( out array<H7BaseAbility> allAbilities );

function array<H7BaseAbility> GetNonVolatileAbilities()
{
	return mAbilities;
}


native function GetHeroAbilities( out array<H7HeroAbility> allAbilities );

native function GetResourceProducingAbilities(out array<H7EffectSpecialAddResources> produc);

function LearnScrollSpell( H7BaseAbility abilityToLearn, H7EffectContainer source )
{
	local H7BaseAbility ability, newAbility;

	if( mVolatileAbilities.Length > 0 )
	{
		foreach mVolatileAbilities( ability )
		{
			// example look for ability "Fireball" that has the same ReferenceSource like "FireBallScroll"
			if( abilityToLearn.IsEqual( ability ) )// && source.IsEqual( ability.GetSourceEffect() ) )
			{
				// already exists
				return;
				//ability.SetCurrentCharges( ability.GetCurrentCharges() + charges );
			}
		}
		// doesn't exist, because did not jump out of function, so learn it
		newAbility = LearnVolatileAbility( abilityToLearn, source );
		// set The New Sets for Scrolls            
		if( H7HeroAbility( newAbility ) != none )
		{
			H7HeroAbility( newAbility ).SetManaCost( 0 );
		}
		//newAbility.SetCurrentCharges( ability.GetCurrentCharges() + charges );
	}
	else
	{
		// doesn't exist so learn it
		newAbility = LearnVolatileAbility( abilityToLearn, source );
		// set The New Sets for Scrolls            
		if( H7HeroAbility( newAbility ) != none )
		{
			H7HeroAbility( newAbility ).SetManaCost( 0 );
		}
		//newAbility.SetCurrentCharges( charges );
	}
}

function RemoveScrollSpell( H7BaseAbility abilityToUnLearn, H7EffectContainer source, bool removeItem)
{
	local H7BaseAbility ability;
	local H7HeroItem scroll;
	//local H7ICaster ownerer;
	local bool otherScrollsOfSameAbilityStillPresent;

    foreach mVolatileAbilities( ability )
    {
        // example look for ability "Fireball" that has the same ReferenceSource like "FireBallScroll"
        if( abilityToUnLearn.IsEqual( ability ) && source.IsEqual( ability.GetSourceEffect() ))
        {
            // already exists Sub charges
			//ability.SetCurrentCharges( ability.GetCurrentCharges() - 1 );
			scroll = H7HeroItem( ability.GetSourceEffect() );
            if(removeItem)
            { 
            	H7EditorHero(mOwner).GetInventory().RemoveItem(scroll);
				H7EditorHero(mOwner).GetInventory().AddUsedConsumable(scroll);
            }
			otherScrollsOfSameAbilityStillPresent = H7EditorHero(mOwner).GetInventory().GetItemByName(scroll.GetName()) != none;
            if(otherScrollsOfSameAbilityStillPresent)
            {
				ability.SetSourceEffect(H7EditorHero(mOwner).GetInventory().GetItemByName(scroll.GetName()));
            }
			/*if( scroll != none && scroll.GetType() == ITYPE_SCROLL )
            {
				ownerer = scroll.GetOwner();
                // remove Scroll item from inventory when a Scrol is used or traded.
				if( H7EditorHero( ownerer ).GetInventory().GetItemByID( scroll.GetID() ) != none )
				{
					H7EditorHero( ownerer ).GetInventory().RemoveItemComplete( scroll );
				}
            }*/
            if( !otherScrollsOfSameAbilityStillPresent)
            {
				;
            	// remove couz no charges left
				UnlearnVolatileAbility( ability );
            }      
        }
    }
}

// newAbility can be archetype or instance 
function H7BaseAbility LearnVolatileAbility(H7BaseAbility newAbility, optional H7EffectContainer sourceContainer, optional int abilityID )
{
	local H7Message           message;

	;
	
	if(newAbility.IsArchetype())
	{
		newAbility = new newAbility.Class(newAbility);
	}

	newAbility.SetSourceEffect( sourceContainer );
	mPendingAbility = newAbility;
	newAbility.OnInit( mOwner, , abilityID );

	mVolatileAbilities.AddItem(newAbility);
	mPendingAbility = none;

	if( newAbility.IsSpell() && !newAbility.IsFromScroll() && mHeroVolatileSpellArchetypeReferences.Find( class'H7GameUtility'.static.GetArchetypePath( newAbility ) ) == INDEX_NONE )
	{
		mHeroVolatileSpellArchetypeReferences.AddItem( class'H7GameUtility'.static.GetArchetypePath( newAbility ) );
		mHeroVolatileSpellIDs.AddItem(newAbility.GetID());
	}

	if( mOwner.IsA('H7AdventureHero') && H7AdventureHero(mOwner).IsGovernourOfTown() )
	{
		newAbility.GetEventManager().Raise( ON_GOVERNOR_ASSIGN, false );
	}

	if(newAbility.IsDisplayed())
	{
		message = new class'H7Message';
		message.text = "MSG_LEARNED";
		message.AddRepl("%owner",mOwner.GetName());
		message.AddRepl("%ability",newAbility.GetName());
		message.destination = MD_LOG;
		message.settings.referenceObject = mOwner;
		message.mPlayerNumber = mOwner.GetPlayer().GetPlayerNumber();
		class'H7MessageSystem'.static.GetInstance().SendMessage(message);
	}

	return newAbility;
}

function UnlearnVolatileAbility(H7BaseAbility oldAbility)
{
	local H7BaseAbility ability;
	local H7Message message;
	local H7EventContainerStruct container;

	if(oldAbility == none) { return; }

	foreach mVolatileAbilities( ability )
	{
		if( ability.IsEqual( oldAbility ) )
		{
			// kill aura if ability has one
			if(ability.IsAura())
			{
				container.EffectContainer = ability;
				ability.GetEventManager().Raise(ON_AURA_DESTROY, false, container);
			}

			;

			mOwner.GetEventManager().UnregisterBySource( ability );
			mVolatileAbilities.RemoveItem(ability);

			if(oldAbility.IsDisplayed())
			{
				message = new class'H7Message';
				message.text = "MSG_FORGET";
				message.AddRepl("%owner",mOwner.GetName());
				message.AddRepl("%ability",oldAbility.GetName());
				message.destination = MD_LOG;
				message.settings.referenceObject = mOwner;
				class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			}

			return;
		}
	}
}

function H7BaseAbility LearnAbility(H7BaseAbility ability, optional H7EffectContainer sourceContainer, optional int abilityID )
{
	local H7BaseAbility newAbility;
	local H7EventContainerStruct eventContainer;
	
	if(ability == none)
	{
		;
		return none;
	}
	if(!ability.IsArchetype())
	{
		// Somebody wants to create an instance based on an instance, applying emergency fix...
		ability = H7BaseAbility(ability.ObjectArchetype);
		if(!ability.IsArchetype())
		{
			;
			ScriptTrace();
			return none;
		}
	}
	// do not allow multipile instances of the same ability
	if( ability.isA('H7CreatureAbility') && HasAbility( ability )  )
	{
		return newAbility;
	}

	// avoid multiple instances of spells or abilities (DON'T let the GUI code sort that out)
	if( ability.IsA('H7HeroAbility') && HasAbility( ability ) )
	{
		newAbility = GetAbility( ability );
		return newAbility;
	}

	if(mOwner != none && (H7Town(mOwner) != none || H7ResourceDepot(mOwner) != none) && HasAbility( ability ))
	{
		newAbility = GetAbility( ability );
		return newAbility;
	}


	// do not allow multipile instances of the same ability
	newAbility = new ability.Class( ability );
	newAbility.SetSourceEffect( sourceContainer );
	mPendingAbility = newAbility;
	newAbility.OnInit( mOwner, , abilityID);

	if(H7AdventureHero(mOwner) != none && newAbility.IsGovernorEffect() )
	{
		H7AdventureHero(mOwner).AddGovernorAbility(newAbility);
	}

	mAbilities.AddItem( newAbility );
	mPendingAbility = none;

	if(ability.IsSpell() && mHeroSpellArchetypeReferences.Find( class'H7GameUtility'.static.GetArchetypePath( ability ) ) == INDEX_NONE )
	{
		mHeroSpellArchetypeReferences.AddItem( class'H7GameUtility'.static.GetArchetypePath( ability ) );
		mHeroSpellIDs.AddItem( newAbility.GetID() );
		
	}
	if( !ability.IsSpell() && mHeroAbilityArchetypeReferences.Find( class'H7GameUtility'.static.GetArchetypePath( ability ) ) == INDEX_NONE )
	{
		mHeroAbilityArchetypeReferences.AddItem( class'H7GameUtility'.static.GetArchetypePath( ability ) );
		mHeroAbilityIDs.AddItem( newAbility.GetID() );
	}

	if( mOwner.IsA('H7AdventureHero') && H7AdventureHero(mOwner).IsGovernourOfTown() )
	{
		eventContainer.EffectContainer = newAbility;
		eventContainer.Targetable = H7AdventureHero( mOwner ).GetGovernedTown();
		eventContainer.TargetableTargets.AddItem( H7IEffectTargetable( mOwner ) );
		eventContainer.TargetableTargets.AddItem( H7AdventureHero( mOwner ).GetGovernedTown() );
		newAbility.GetEventManager().Raise( ON_GOVERNOR_ASSIGN, false, eventContainer );
	}

	return newAbility;
	
}

function UnlearnAbility(H7BaseAbility oldAbility)
{
	local H7EventContainerStruct container;
	local H7BaseAbility ability;
	local H7Message message;
	local string abilityToRemove;

	if( oldAbility == none ) return;

	UnlearnBugTrack(oldAbility);

	foreach mAbilities( ability )
	{
		if( ability.IsEqual( oldAbility ) )
		{
			// kill aura if ability has one
			if(ability.IsAura())
			{
				container.EffectContainer = ability;
				ability.GetEventManager().Raise(ON_AURA_DESTROY, false, container);
			}

			mOwner.GetEventManager().UnregisterBySource( ability );

			if(H7AdventureHero(mOwner) != none && ability.IsGovernorEffect() )
			{
				H7AdventureHero(mOwner).RemoveGovernorAbility(ability);
			}

			abilityToRemove = class'H7GameUtility'.static.GetArchetypePath( ability );
			if(ability.IsSpell())
			{
				mHeroSpellArchetypeReferences.RemoveItem( abilityToRemove );
				mHeroSpellIDs.RemoveItem( ability.GetID() );

				//`LOG_MP("SkillTrack : Spell" @abilityToRemove@ "is removed from mHeroSpellArchetypeReferences for owner" @mOwner@"! Remaning entries in list: "@mHeroSpellArchetypeReferences.Length@".");
			}
			else
			{
				mHeroAbilityArchetypeReferences.RemoveItem( abilityToRemove );
				mHeroAbilityIDs.RemoveItem( ability.GetID() );

				//`LOG_MP("SkillTrack : Ability" @abilityToRemove@ "is removed from mHeroAbilityArchetypeReferences for owner" @mOwner@"! Remaning entries in list: "@mHeroAbilityArchetypeReferences.Length@".");
			}

			mAbilities.RemoveItem(ability);

			//`LOG_MP("SkillTrack : Ability" @ability@ "is removed from mAbilities for owner" @mOwner@"! Remaning entries in list: "@mAbilities.Length@".");
			ScriptTrace();

			if(oldAbility.IsDisplayed())
			{
				message = new class'H7Message';
				message.text = "MSG_FORGET";
				message.AddRepl("%owner",mOwner.GetName());
				message.AddRepl("%ability",oldAbility.GetName());
				message.destination = MD_LOG;
				message.settings.referenceObject = mOwner;
				class'H7MessageSystem'.static.GetInstance().SendMessage(message);
			}

			return;
		}
	}
}

function Init( H7Unit owner, array<H7BaseAbility> abilities )
{
	local H7BaseAbility ability;
	
	mOwner = owner;
	
	// add the abilities
	foreach abilities( ability )
	{
		LearnAbility( ability );
	}
}

event InitAbilities()
{
	local array<H7BaseAbility> abilities;
	local H7BaseAbility ability;

	GetAbilities(abilities);
	foreach abilities( ability )
	{
		ability.GetEventManager().Raise( ON_INIT, false );
	}
}

native function UpdateAbilityEvents(ETrigger triggerEvent, bool simulate, optional H7EventContainerStruct container);

native function bool HasAbility( H7BaseAbility wantedAbility );

native function bool HasVolatileAbility( H7BaseAbility wantedAbility );

native function H7BaseAbility GetAbility( H7BaseAbility ability );

native function H7BaseAbility GetAbilityByID( int abilityId );

native function bool HasActiveAbilities();

native function H7BaseAbility GetSpellByName( string spellName );

function SuppressAbility( H7BaseAbility ability )
{
	local H7BaseAbility foundAbility;


	foundAbility = GetAbility( ability );

	if( foundAbility == none ) return;

	foundAbility.Suppress( true );
}

function UnsuppressAbility( H7BaseAbility ability )
{
	local H7BaseAbility foundAbility;

	foundAbility = GetAbility( ability );

	if( foundAbility == none ) return;

	foundAbility.Suppress( false );
}

native function GetAbilitiesFromSource( H7EffectContainer container, out array<H7BaseAbility> foundAbilities );

native function GetAbilitiesEffectsByTrigger( out array<H7Effect> allAbilities, ETrigger triggerType );

function DeleteAllAbilitiesFromSkill(H7Skill skill)
{
	local array<H7HeroAbility> abilities;
	local H7HeroAbility ability;

	abilities = skill.GetAllSkillAbilitiesArchetype();
	foreach abilities(ability)
	{
		if(HasAbility(ability)) UnlearnAbility(ability);
	}
}

function JSonObject Serialize ( )
{
	local JSonObject json;
	local int i;

	json = new () class'JSonObject';

	json.SetIntValue("HeroSpellAmount", mHeroSpellArchetypeReferences.Length);

	for (i = 0; i <  mHeroSpellArchetypeReferences.Length; i++)
	{
		json.SetStringValue("HeroSpell"$i, mHeroSpellArchetypeReferences[i]);
	}

	return json;
}

function Deserialize (JSonObject Data)
{
	local H7HeroAbility currentAbility;
	local string currentArchetype;
	local int abilityAmount, i;

	abilityAmount = Data.GetIntValue("HeroSpellAmount");

	for(i = 0; i < abilityAmount; i++)
	{
		currentArchetype = Data.GetStringValue("HeroSpell"$i);

		if( FindObject(currentArchetype, class'H7HeroAbility') != none )
		{
			currentAbility = H7HeroAbility(DynamicLoadObject(currentArchetype, class'H7HeroAbility'));
			LearnAbility(currentAbility);
		}
	}
}

event PostSerialize()
{
	//`LOG_MP("SkillTrack :  AbilityManger"@self@"is post serialized!");
	if(H7ResourceDepot(mOwner) != none)
	{
		RestoreAbilitiesFromRefs();
	}
}

event RestoreAbilitiesFromRefs()
{
	local H7BaseAbility currentAbility;
	local H7BaseAbility newAbility;
	local int i;

	for( i = 0; i < mHeroSpellArchetypeReferences.Length; ++i )
	{
		currentAbility = H7BaseAbility(DynamicLoadObject(mHeroSpellArchetypeReferences[i], class'H7BaseAbility'));
		if(currentAbility == none) continue;
		// savegame compatibility check
		if(i < mHeroSpellIDs.Length)
		{
			LearnAbility(currentAbility, , mHeroSpellIDs[i]);
		}
		else
		{
			// synching up for next save
			newAbility = LearnAbility(currentAbility);
			mHeroSpellIDs.AddItem(newAbility.GetID());
		}
	}

	for( i = 0; i < mHeroVolatileSpellArchetypeReferences.Length; ++i )
	{
		currentAbility = H7BaseAbility(DynamicLoadObject(mHeroVolatileSpellArchetypeReferences[i], class'H7BaseAbility'));
		if(currentAbility == none) continue;
		// savegame compatibility check
		if(i < mHeroVolatileSpellIDs.Length)
		{
			LearnVolatileAbility(currentAbility, , mHeroVolatileSpellIDs[i]);
		}
		else
		{
			// synching up for next save
			newAbility = LearnVolatileAbility(currentAbility);
			mHeroVolatileSpellIDs.AddItem(newAbility.GetID());
		}
	}

	for( i = 0; i < mHeroAbilityArchetypeReferences.Length; ++i )
	{
		currentAbility = H7BaseAbility(DynamicLoadObject(mHeroAbilityArchetypeReferences[i], class'H7BaseAbility'));
		if(currentAbility == none) continue;
		// savegame compatibility check
		if(i < mHeroAbilityIDs.Length)
		{
			LearnAbility(currentAbility, ,mHeroAbilityIDs[i]);
		}
		else
		{
			// synching up for next save
			newAbility = LearnAbility(currentAbility);
			mHeroAbilityIDs.AddItem(newAbility.GetID());
		}
	}
	
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


