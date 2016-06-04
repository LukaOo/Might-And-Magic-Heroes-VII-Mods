//=============================================================================
// H7Army
//=============================================================================
//
// Class representing the Army in the editor. Should only contain 
// editor-related functionality. Ingame logic for the Army should be specified
// in H7CombatArmy or H7AdventureArmy, of which this class maintains a reference for in game use.
// 
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EditorArmy extends H7EditorMapObject
	implements(H7DynGridObjInterface, H7IOwnable, H7IAliasable)
	dependsOn(H7Creature, H7EditorHero, H7GameTypes, H7IAliasable)
	notplaceable
	native
	config(game)
	//hidecategories(Attachment,Collision,Physics,Advanced,Debug,Mobile,SkeletalMeshActor,Visuals,Occlusion)
	showcategories(Movement, Display, Object)
	savegame;

const MAX_ARMY_SIZE = 7;

/** Whether it should create an sub-archetype from the source */
var(Developer) private bool mCustomizeHeroArchetype<DisplayName="Customize Hero">;
/** Defines the commanding hero of the army */
var(Properties) protected savegame archetype H7EditorHero mHeroArchetype<DisplayName="Hero">;
/** Defines the enlisted creature stacks of the army */
var(Properties) protected array<CreatureStackProperties> mCreatureStackProperties<DisplayName="Army">;
/** Defines the war units of the army */
var(Properties) protected savegame archetype array<H7EditorWarUnit> mWarUnitTemplates<DisplayName="Warfare Units">;
var(Properties) protected editconst config int cMaxArmySize<DisplayName="Maximum Army Size">;
/** The player that owns this army */
var(Properties) savegame protected EPlayerNumber mPlayerNumber<DisplayName="Player">;
/** Army cannot flee or surrender. */
var(Properties) savegame bool mDisableFleeSurrender<DisplayName="Disable flee/surrender">;
/** If checked, this army will trigger an ambush */
var(Properties) savegame bool mIsAmbush<DisplayName="Ambush">;
/** If checked, the army won't act as enemy or ally */
var(Properties) savegame bool mIsNPC<DisplayName="NPC Hero">;
/** If checked, the army can be talked to */
var(Properties) savegame bool mIsTalking<DisplayName="Is talking"|EditCondition=mIsNPC>;
/** If checked, this army has to be fought manually, and not via quick combat. */
var(Properties) savegame bool mForceManualCombat<DisplayName="Force manual combat">;

var(Visuals) protectedwrite SkeletalMeshComponent mHorseMesh;
var(Visuals) protectedwrite StaticMeshComponent mWeaponMesh;
var(Visuals) protectedwrite SkeletalMeshComponent mWeaponSkMesh;
var protected array<ParticleSystemComponent> mEmitterPoolParticleComps;

var SkeletalMesh mLlamaMesh;
var AnimSet mLlamaAnims;

var protected savegame array<H7BaseCreatureStack>	mBaseCreatureStacks; 
var protected savegame H7Deployment			mDeployment;
var protected H7Player						mPlayer;
var protected savegame H7EditorWarUnit      mSiegeUnit;

var protected savegame bool                 mIsStarterHero;

// Enables to use an amount of xp to define the strength of this army. When unchecked the army will be created from random stacksizes.
var(Random) protected bool  mUseXPStrength<DisplayName="Use XP Strength">;
// This amount of experience points will be divided through the number of stacks and then devided through the single xp of the respective chosen creature to get the stacksizes.
var(Random) protected int   mXPStrength<DisplayName="XP Strength"|EditCondition=mUseXPStrength>;

/** Used for cinematics and special scenes, uses purely dynamic lights with no LightEnvironment ignoring the Creature properties */
var(Display) bool mOnlyDynamicLights;

// AI focuses on this army while conquering further areas
var(AISettings) protected savegame bool mAiIsBorderControl<DisplayName="Is Border Control">;

// Native functions
// =======
function native ClearMeshData();
function native LoadMeshes( optional bool useStrongestCreature );
function native UpdateMeshes( optional H7Creature creature );
function native UpdateWeaponAttachments();
function native CleanComponents();

// Get / Set
// =======

function bool IsStarterHero() { return mIsStarterHero; } 
function SetStarterHero(bool newValue) { mIsStarterHero = newValue; }

// returns true if the hero army can be dismissed
function bool CanFleeOrSurrender() 
{ 
	local H7EditorHero hero;
	local array<H7BaseBuff> buffs;
	local H7BaseBuff buff;
	local array<H7Effect> effects;
	local H7Effect effect;
	local H7IEffectDelegate delegate;

	hero = GetEditorHero();
	if(hero != none && hero.IsHero())
	{
		hero.GetBuffManager().GetActiveBuffs(buffs);

		foreach buffs(buff)
		{
			effects = buff.GetEffectsOfType( 'H7EffectSpecial' );

			foreach effects(effect)
			{
				delegate = H7EffectSpecial(effect).GetFunctionProvider();
				if(H7EffectSpecialDisableFleeSurrender(delegate) != none)
				{
					return false;
				}
			}
		}
	}

	return !mDisableFleeSurrender; 
}
function bool IsNPC() { return mIsNPC; }
function bool IsTalking() { return mIsTalking; }
function SetNPC(bool isNPC) 
{ 
	mIsNPC = isNPC; 
}
function SetTalking(bool isTalking) { mIsTalking = isTalking; }
function bool IsForcingManualCombat() { return mForceManualCombat; }
function SetForcingManualCombat(bool value) { mForceManualCombat = value; }
function SetArmyIsAmbush(bool value) { mIsAmbush = value; }

function                                SetCreatureStackProperties(array<CreatureStackProperties> stackProperties)  { mCreatureStackProperties = stackProperties; mBaseCreatureStacks.Length = 0; CreateBaseCreatureStack(); }
function array<CreatureStackProperties> GetCreatureStackProperties()                                                {return mCreatureStackProperties; }
function	                            ClearCreatureStackProperties()                                              { mCreatureStackProperties.Length = 0; mBaseCreatureStacks.Length = 0; CreateBaseCreatureStack(); }
function int                            GetMaxArmySize()                                                            { return cMaxArmySize; }
function int                            GetBaseCreatureStackIndex(H7BaseCreatureStack stack)                        { return mBaseCreatureStacks.Find(stack); }
function array<H7BaseCreatureStack>     GetBaseCreatureStacks()                                                     { return mBaseCreatureStacks; }
function H7BaseCreatureStack            GetBaseStackBySourceSlotId(int id)                                          { return mBaseCreatureStacks[id];}
function int                            GetBaseCreatureStackLength()                                                { return mBaseCreatureStacks.Length; }

function EnsureBaseStackSlotExistence(int index) // add none entries until [index] has a none entry
{
	while(index >= mBaseCreatureStacks.Length)
	{
		mBaseCreatureStacks.AddItem(none); // later gets cut down again to 0-6 when army is written from combat to adventure
	}
}

function array<H7BaseCreatureStack>     GetBaseCreatureStacksDereferenced()
{
	local array<H7BaseCreatureStack> derefArray;
	local H7BaseCreatureStack newStack;
	local int i;

	for(i = 0; i < mBaseCreatureStacks.Length; i++)
	{
		if(mBaseCreatureStacks[i] != none)
		{
			newStack = new class'H7BaseCreatureStack'(mBaseCreatureStacks[i]);
			derefArray.AddItem(newStack);
		}
		else
		{
			derefArray.AddItem(none);
		}
	}
	return derefArray;
}

event int GetNumberOfMeleeStacks() // because I can't implement 
{
	local int number, i;
	local H7CombatArmy combatArmy;
	local array<H7CreatureStack> stacks;

	combatArmy = H7CombatArmy( self );

	if( combatArmy == none )
	{
		return 0;
	}
	else
	{
		stacks = combatArmy.GetCreatureStacks();
		for( i = 0; i < stacks.Length; ++i )
		{
			if( stacks[i] == none || stacks[i].IsDead() ) { continue; }
		
			if( !stacks[i].IsRanged() )
			{
				++number;
			}
		}
	}
	return number;
}

function H7Player	                    GetPlayer()						                                            { return mPlayer; }
function			                    SetPlayer( H7Player newPlayer )	                                            
{ 
	if( newPlayer == none )
	{
		;
		ScriptTrace();
	}
	else
	{
		mPlayer = newPlayer; 
		mPlayerNumber = newPlayer.GetPlayerNumber(); 
	}
}

function                                SetHeroTemplate(H7EditorHero hero)                                          { mHeroArchetype = hero; }
function H7EditorHero                   GetHeroTemplate()                                                           { return mHeroArchetype; }
event H7EditorHero GetHeroTemplateSource()
{
	if(mHeroArchetype != none && mHeroArchetype.GetCampaignTransitionHeroArchetype() != none)
	{
		return mHeroArchetype.GetCampaignTransitionHeroArchetype();
	}
	else
	{
		return mHeroArchetype;
	}
}

function H7Deployment                   GetDeployment()                                                             { return mDeployment; }
function                                SetDeployment( H7Deployment value )
{
	if(mDeployment == none && value == none )
	{
		value = new class'H7Deployment';
	}
	mDeployment = value;
	if( mDeployment != none ) mDeployment.DebugLogSelf();
}

function                                InsertCreatureStack( int index, H7BaseCreatureStack stack )                 
{ 
	mBaseCreatureStacks.InsertItem( index, stack ); 
	if( stack != none )
	{
		stack.SetStartingSize( stack.GetStackSize() );
	}
	if( !IsA( 'H7CombatArmy' ) )
	{
		OverrideDeploymentFromBaseStacks( true );
	}
	else
	{
		OverrideDeploymentFromBaseStacks( false );
	}
}
function                                AddCreatureStack( H7BaseCreatureStack stack, optional bool isInit = false )                               
{ 
	mBaseCreatureStacks.AddItem( stack ); 
	if( stack != none )
	{
		stack.SetStartingSize( stack.GetStackSize() );
	}
	if( !isInit )
	{
		if( !IsA( 'H7CombatArmy' ) )
		{
			OverrideDeploymentFromBaseStacks( true );
		}
		else
		{
			OverrideDeploymentFromBaseStacks( false );
		}
	}
}

function array<H7EditorWarUnit>         GetWarUnitTemplates()                                                       { return mWarUnitTemplates; }
function                                SetWarUnitTemplates( array<H7EditorWarUnit> warUnitTemplates)               { mWarUnitTemplates = warUnitTemplates; }
function                                AddWarUnitTemplate( H7EditorWarUnit warUnit )                               { mWarUnitTemplates.AddItem( warUnit ); }

function EPlayerNumber					GetPlayerNumber()															{ return mPlayerNumber; }
function H7EditorHero					GetEditorHero()																{ return none; } // needs to be overriden

function bool                           GetAiIsBorderControl()                                                      { return mAiIsBorderControl; }
function                                SetAiIsBorderControl(bool enable)                                           { mAiIsBorderControl=enable; }

function bool HasWarUnitType( EWarUnitClass unitClass ) 
{
	local int i;

	for( i = 0; i < mWarUnitTemplates.Length; ++i )
	{
		if( mWarUnitTemplates[i] != none )
		{
			if( mWarUnitTemplates[i].GetWarUnitClass() == unitClass )
			{
				return true;
			}
		
			if( mWarUnitTemplates[i].GetWarUnitClass() == WCLASS_HYBRID )
			{
				if( unitClass == WCLASS_ATTACK || unitClass == WCLASS_SUPPORT )
				{
					return true;
				}
			}
		}
	}
	
	return false;
}

function H7EditorWarUnit GetWarUnitByType( EWarUnitClass unitClass )
{
	local int i;

	for( i = 0; i < mWarUnitTemplates.Length; ++i )
	{
		if( mWarUnitTemplates[i].GetWarUnitClass() == unitClass )
		{
			return mWarUnitTemplates[i];
		}
		
		if( mWarUnitTemplates[i].GetWarUnitClass() == WCLASS_HYBRID )
		{
			if( unitClass == WCLASS_ATTACK || unitClass == WCLASS_SUPPORT )
			{
				return mWarUnitTemplates[i];
			}
		}
	}

	return none;
}

function AddWarUnit(H7EditorWarUnit warUnit)
{
	local int i;

	for( i = 0; i < mWarUnitTemplates.Length; ++i )
	{
		if(mWarUnitTemplates[i] == none)
		{
			mWarUnitTemplates[i] = warUnit;
			return;
		}
	}
	if(mWarUnitTemplates.Length < 4)
		mWarUnitTemplates.AddItem(warUnit);

}

function RemoveWarUnit(H7EditorWarUnit warUnit)
{
	mWarUnitTemplates.RemoveItem(warUnit);
}

function bool HasHybridWarUnit()
{
	local int i;

	for( i = 0; i < mWarUnitTemplates.Length; ++i )
	{
		if(mWarUnitTemplates[i] == none && mWarUnitTemplates[i].GetWarUnitClass() == WCLASS_HYBRID)
		{
			return true;
		}
	}
	return false;
}

// methods
// =======

// The objects inside the army will assume the data* of objects inside 'stacks'
// WILL NOT USE REFERENCE - WILL USE COPY
// *size,type and custom position
function SetBaseCreatureStacksToCopy( array<H7BaseCreatureStack> stacks )
{
	local int i;

	for( i = 0; i < stacks.Length; i++ )
	{
		if(stacks[i] != none)
		{
			if(mBaseCreatureStacks[i] == none)
			{
				mBaseCreatureStacks[i] = new class'H7BaseCreatureStack';
			}
			mBaseCreatureStacks[i].SetStackSize(stacks[i].GetStackSize());
			mBaseCreatureStacks[i].SetStackType(stacks[i].GetStackType());
			mBaseCreatureStacks[i].SetCustomPosition(stacks[i].GetCustomPositionBool(),stacks[i].GetCustomPositionX(),stacks[i].GetCustomPositionY());
		}
		else
		{
			mBaseCreatureStacks[i] = none;
		}
	}
	CreateCreatureStackProperies(); 
	if( !IsA( 'H7CombatArmy' ) )
	{
		OverrideDeploymentFromBaseStacks( true );
	}
	else
	{
		OverrideDeploymentFromBaseStacks( false );
	}
}

// The objects (pointer) inside the army will be set to the objects inside 'stacks' (if they are instances)
// WILL USE REFERENCE - WILL NOT USE COPY (except if given archetypes, will create instances)
function SetBaseCreatureStacks( array<H7BaseCreatureStack> stacks )
{ 
	local int i;

	for( i = 0; i < stacks.Length; i++ )
	{
		if( stacks[i] != none && class'H7GameUtility'.static.IsArchetype(stacks[i]) )
		{
			mBaseCreatureStacks[i] = new class'H7BaseCreatureStack'( stacks[i] );
		}
		else if(stacks[i] != none && !class'H7GameUtility'.static.IsArchetype(stacks[i]))
		{
			mBaseCreatureStacks[i] = stacks[i];
		}
		else
		{
			mBaseCreatureStacks[i] = none;
		}
	}
	CreateCreatureStackProperies(); 
	if( !IsA( 'H7CombatArmy' ) )
	{
		OverrideDeploymentFromBaseStacks( true );
	}
	else
	{
		OverrideDeploymentFromBaseStacks( false );
	}
}

function float GetHeroPower() { }

function int GetNumberOfFilledSlots()
{
	local H7BaseCreatureStack stack;
	local int amount;

	foreach mBaseCreatureStacks( stack )
	{
		amount++;
	}

	return amount; 
}

function OverrideDeploymentFromBaseStacks(optional bool markAllStacksAsUndeployed=true)
{
	local int i;
	local H7BaseCreatureStack baseStack;
	local int idx, idxCStack, idxGStack;
	local IntPoint originalPos;

	if(mDeployment==None) // if we are starting a combat map directly instead of coming from an adventure map the deployment structure needs to be created
	{
		mDeployment = new class 'H7Deployment';
	}

	// reset deployment
	mDeployment.Reset();


	idxCStack = 0;
	idxGStack = 9;

	// setup deployment array
	for(i=0;i<mBaseCreatureStacks.Length;i++)
	{
		baseStack = mBaseCreatureStacks[i];
		if( baseStack != none)
		{
			if( baseStack.IsLocalGuard() == false )
			{
				idx = idxCStack;
				idxCStack++;
			}
			else
			{
				idx = idxGStack;
				idxGStack++;
			}
			
			mDeployment.SetStackInfo(idx, i, baseStack, mBaseCreatureStacks[i].GetSpawnedStackOnMap() );
			mDeployment.IncNumberOfStacksToDeploy();
		
			if(markAllStacksAsUndeployed)
			{
				baseStack.SetDeployed(false);
			}
			else
			{
				if( baseStack.IsDeployed() && 
					baseStack.GetSpawnedStackOnMap() != none && 
					baseStack.GetSpawnedStackOnMap().GetCell().GetGridPosition().X != -1 &&
					baseStack.GetSpawnedStackOnMap().GetCell().GetGridPosition().Y != -1 )
				{
					originalPos = baseStack.GetSpawnedStackOnMap().GetCell().GetGridPosition();
					originalPos.X -= class'H7EditorCombatGrid'.const.WARFARE_UNIT_GRID_BUFFER_SIZE / 2;
					mDeployment.SetStackGridPos( idx, originalPos );
				}
			}
		}
		else
		{
			// empty army slot
			idx = idxCStack;
			idxCStack++;
		}
	}
}

/**
 * Puts the stack into the first empty slot
 * 
 * @return the index of the slot. -1 if no slot found
 * 
 * */
function int PutCreatureStackToEmptySlot( H7BaseCreatureStack stack )
{
	local int i;
	for( i = 0; i < cMaxArmySize; i++ )
	{
		if( mBaseCreatureStacks[i] == none )
		{
			mBaseCreatureStacks[i] = stack;
			if( stack != none )
			{
				stack.SetStartingSize( stack.GetStackSize() );
			}
			if( !IsA( 'H7CombatArmy' ) )
			{
				OverrideDeploymentFromBaseStacks( true );
			}
			else
			{
				OverrideDeploymentFromBaseStacks( false );
			}

			return i;
		}
	}
	return -1;
}

function H7CombatArmy CreateCombatArmy()
{
	local H7CombatArmy combatArmy;
	local SkeletalMeshComponent comp;
	local StaticMeshComponent bs;
	local Vector somewhereElse;

	combatArmy = Spawn( class'H7CombatArmy' );
	if( mHeroArchetype == none ) { mHeroArchetype = Spawn( class'H7EditorHero' ); mHeroArchetype.SetIsHero( false ); }
	combatArmy.SetHeroTemplate( mHeroArchetype );
	combatArmy.SetCreatureStackProperties( mCreatureStackProperties );
	combatArmy.SetWarUnitTemplates( mWarUnitTemplates );
	combatArmy.SetDeployment( GetDeployment() );
	foreach combatArmy.ComponentList( class'SkeletalMeshComponent', comp )
	{
		comp.SetActorCollision( false, false, false );
		comp.SetTraceBlocking( false, false );
	}
	foreach combatArmy.ComponentList( class'StaticMeshComponent', bs )
	{
		bs.SetActorCollision( false, false, false );
		bs.SetTraceBlocking( false, false );
	}
	combatArmy.SetCollision( false, false, false );
	combatArmy.SetCollisionType( COLLIDE_NoCollision );
	somewhereElse = combatArmy.Location;
	somewhereElse.Z += 10000;
	somewhereElse.Y += 10000;
	somewhereElse.Z += 10000;
	combatArmy.SetLocation(somewhereElse);

	return combatArmy;
}

function int GetExperienceForDefeating()
{
	local H7BaseCreatureStack stack;
	local int xp;
	
	foreach mBaseCreatureStacks( stack )
	{
		xp += stack.GetStackType().GetExperiencePoints() * stack.GetStackSize();
	}

	return xp;
}

// dont call this function on every frame or on GUI stuff. This function creates armies that are registered and need synchronization in multiplayer
function H7CombatArmy CreateCombatArmyUsingAdventureArmy( H7AdventureArmy army, bool isAttacker, bool isForQuickCombat = false )
{
	local H7CombatArmy combatArmy;

	// copy bullshit
	army.GetHero().SetArmy( army ); // important crosslink because sometimes we only have the HeroObject
	combatArmy = Spawn( class'H7CombatArmy', class'H7CombatController'.static.GetInstance() );
	combatArmy.SetHeroTemplate( army.GetHeroTemplate() );
	combatArmy.SetBaseCreatureStacks( army.GetBaseCreatureStacksDereferenced() );
	combatArmy.SetWarUnitTemplates( army.GetWarUnitTemplates() );
	combatArmy.SetAdventureHero( army.GetHero() );
	combatArmy.SetHero( army.GetHero().Convert( combatArmy ) );
	combatArmy.SetDeployment( army.GetDeployment() );
	combatArmy.SetIsForQuickCombat( isForQuickCombat );
	if( army.GetDeployment() != none )
	{
		;
	}
	combatArmy.SetPlayer( army.GetPlayer() );
	combatArmy.SetIsAttacker( isAttacker );
	combatArmy.SetAdventureHero( army.GetHero() );
	combatArmy.SetHidden( true );
	combatArmy.SetVisibility( false );
	combatArmy.GetHero().SetHidden( true );
	return combatArmy;
}

function CreateHero( optional SavegameHeroStruct saveGameData ) { }
function PostCreateHero() {}

function SetCell( H7AdventureMapCell newCellPos, optional bool updateHeroWorldLocation = true, optional bool registerCell = true, optional bool isInit = true ){}

simulated event PostBeginPlay()
{
	Super.PostBeginPlay();

	// cleaning creature stacks that doesnt have a creature assigned
	PruneStackProperties();

	UpdateWeaponAttachments();
}

event Init( H7Player playerOwner, optional H7AdventureMapCell startPos, optional Vector garrisonLocation, optional bool pruneStacks )
{
	local float startStackSizeModifier;
	local int i;
	local bool isHero;
	local array<EPlayerNumber> disposition;

	SetPlayer( playerOwner );
	if( mHeroArchetype == none ) 
	{ 
		; 
		mHeroArchetype = Spawn( class'H7EditorHero', self ); 
		mHeroArchetype.SetIsHero( false ); 
		isHero = false;
	}
	else
	{
		isHero = true;
	}
	
	SetHeroTemplate( mHeroArchetype );

	
	if( mUseXPStrength )
	{
		InitRandomValues();
	}
	else
	{
		if( H7AdventureArmy( self ) != none )
		{
			H7AdventureArmy( self ).GetPlayerDispositions( disposition );
			if( mPlayerNumber == PN_NEUTRAL_PLAYER && pruneStacks && !isHero && H7AdventureArmy( self ).GetDiplomaticDisposition() == DIT_NEGOTIATE && disposition.Length == 0 )
			{
				startStackSizeModifier = class'H7AdventureController'.static.GetInstance().mDifficultyCritterStartSizeMultiplier;
				for( i = 0; i < mCreatureStackProperties.Length; ++i )
				{
					mCreatureStackProperties[i].Size = FMax( 1.0f, float( mCreatureStackProperties[i].Size ) * startStackSizeModifier );
				}
			}
		}
	}
	SetCreatureStackProperties( mCreatureStackProperties );
	//SetWarUnitTemplates( mWarUnitTemplates );
	
	mSiegeUnit = GetHeroTemplate().GetSiegeWarUnitTemplate();
	
	// every army has a catapult
	AddWarUnitTemplate( mSiegeUnit );

	CreateHero();
	PostCreateHero();

	if( garrisonLocation == vect(0,0,0) )
	{
		if( startPos != none )
		{
			SetCell( startPos );
		}
	}
	else
	{
		SetCell( class'H7AdventureGridManager'.static.GetInstance().GetCellByWorldLocation( garrisonLocation ), , , true );
	}
}

function SyncBaseStackStartingSizeToCurrentSize()
{
	local H7BaseCreatureStack stack;

	foreach mBaseCreatureStacks( stack ) 
	{
		if( stack.GetStackType() != none )
		{
			stack.SetStartingSize( stack.GetStackSize() );
		}
		else
		{
			stack.SetStartingSize( 0 );
			stack.SetStackSize( 0 );
		}
	}
}


function CreateCreatureStackProperies()
{
	local H7BaseCreatureStack stack;

	if( mBaseCreatureStacks.Length == 0 )
		return;

	mCreatureStackProperties.Length = 0;

	foreach mBaseCreatureStacks( stack ) 
	{
		mCreatureStackProperties.AddItem( CreateStackPropertyFromBase( stack ) );
	}
}

function CreatureStackProperties CreateStackPropertyFromBase( H7BaseCreatureStack stack ) 
{
	local CreatureStackProperties properties; 

	properties.Creature = stack.GetStackType();
    properties.Size = stack.GetStartingSize();
	
    return properties; 
}

function CreateBaseCreatureStack()
{
	local CreatureStackProperties properties;
	local H7BaseCreatureStack     stack;
	local int                     i;

	if( mBaseCreatureStacks.Length == 0 ) 
	{
		for(i = 0; i < mCreatureStackProperties.Length; ++i )
		{
			properties = mCreatureStackProperties[i];
			if(properties.Creature != none)
			{
				stack = new class'H7BaseCreatureStack';
				stack.SetStackSize( properties.Size );
				stack.SetStartingSize( properties.Size );
				stack.SetStackSizeAtMapStart( properties.Size );
				stack.SetStackType( properties.Creature );
				stack.SetCustomPosition( self.mIsAmbush, properties.CustomPositionX, properties.CustomPositionY );
				AddCreatureStack( stack, true );
			}
		}
		
		PruneStackProperties();
	}
	// fill up the army with empty slots
	if( mBaseCreatureStacks.Length < cMaxArmySize )
	{
		mBaseCreatureStacks.Add( cMaxArmySize - mBaseCreatureStacks.Length );
	}
}

native function PruneStackProperties();

function int GetCreatureAmount( H7Creature creature )
{
	local int amount;
	local H7BaseCreatureStack currentStack;

	amount = 0;

	foreach mBaseCreatureStacks( currentStack )
	{
		if( currentStack.GetStackType() == creature )
		{
			amount += currentStack.GetStackSize();
		}
	}

	return amount;
}

function int GetCreatureAmountTotal( )
{
	local int amount;
	local H7BaseCreatureStack currentStack;
	amount = 0;
	foreach mBaseCreatureStacks( currentStack )
	{
		amount += currentStack.GetStackSize();
	}
	return amount;
}

function int GetCreatureAmountOfTier( ECreatureTier tier )
{
	local int amount;
	local H7BaseCreatureStack currentStack;

	amount = 0;

	foreach mBaseCreatureStacks( currentStack )
	{
		if( currentStack.GetStackType().GetTier() == tier )
		{
			amount += currentStack.GetStackSize();
		}
	}

	return amount;
}



/** Matinee stuff **/
simulated function CacheAnimNodes()
{
	local AnimNodeSlot SlotNode;

	if( SkeletalMeshComponent.Animations != none )
	{
		Super.CacheAnimNodes();
	}

	// Cache all AnimNodeSlots.
	if (mHorseMesh.Animations != None)
	{
		foreach mHorseMesh.AllAnimNodes(class'AnimNodeSlot', SlotNode)
		{
			SlotNodes[SlotNodes.Length] = SlotNode;
		}
	}
	if (mWeaponSkMesh.Animations != None)
	{
		foreach mWeaponSkMesh.AllAnimNodes(class'AnimNodeSlot', SlotNode)
		{
			SlotNodes[SlotNodes.Length] = SlotNode;
		}
	}
}

native function H7Creature GetStrongestCreature();
native function H7Creature GetStrongestPropertyCreature();
native function float GetCreaturePropertyStrength( CreatureStackProperties stackProperty );

/**
 * Checks if a stack slot is free in the army, returns
 * true if it does, false if it doesn't. Also provides
 * the index of the creature stack inside the army.
 * 
 * @param army              The army that is being checked
 * 
 * */
function bool CheckFreeArmySlot()
{
	local int i;
	local array<H7BaseCreatureStack> stacks;

	stacks = GetBaseCreatureStacks();
	for( i = 0; i < stacks.Length; i++ )
	{
		if( stacks[ i ] == none )
		{
			return true;
		}
	}
	return false;
}

function H7BaseCreatureStack GetStackByName( string creatureName )
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	
	stacks = GetBaseCreatureStacks();

	foreach stacks( stack )
	{
		if( stack.GetStackType().GetName() == creatureName )
		{
			return stack;
		}
	}

	return none;
}

function H7BaseCreatureStack GetStackByIDString( string creatureName )
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	
	stacks = GetBaseCreatureStacks();

	foreach stacks( stack )
	{
		if( stack.GetStackType().GetIDString() == creatureName )
		{
			return stack;
		}
	}

	return none;
}

function int GetIndexOfStack(H7BaseCreatureStack compareStack)
{
	local array<H7BaseCreatureStack> stacks;
	local H7BaseCreatureStack stack;
	local int index;
	
	stacks = GetBaseCreatureStacks();

	foreach stacks( stack, index )
	{
		if( stack == compareStack )
		{
			return index;
		}
	}
	return -1;
}

// function used by AI and GUI/Quick Combat to get an comparable value to match two armies against each other
native function float GetStrengthValue( optional bool withHero = false, optional array<H7BaseCreatureStack> additionalStacks );
static native function float GetHeroStrengthValue(INT heroLevel);

function static TransferCreatureStacksByArmy( H7EditorArmy requesterArmy, H7EditorArmy sourceArmy, H7EditorArmy targetArmy, int indexSource, int indexTarget, optional int splitAmount, optional bool forceTransferToTargetArmy )
{
	local H7InstantCommandSplitCreatureStack command;
	if( targetArmy == none )
	{
		;
		return;
	}

	command = new class'H7InstantCommandSplitCreatureStack';
	command.Init( sourceArmy, targetArmy, indexSource, splitAmount, indexTarget, requesterArmy, forceTransferToTargetArmy );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function static bool TransferCreatureStacksByArmyComplete(H7EditorArmy sourceArmy, H7EditorArmy targetArmy, int indexSource, int indexTarget, optional int splitAmount)
{
	local array<H7BaseCreatureStack> sourceStacks,targetStacks;
	local bool success;

	sourceStacks = sourceArmy.GetBaseCreatureStacks();
	targetStacks = targetArmy.GetBaseCreatureStacks();

	success = class'H7BaseCreatureStack'.static.TransferCreatureStacksByArray(sourceStacks,targetStacks,indexSource,indexTarget,splitAmount,sourceArmy==targetArmy);

	if(success)
	{
		// create CreatureStackProperties while in the Adventuremap
		sourceArmy.SetBaseCreatureStacks(sourceStacks);
		targetArmy.SetBaseCreatureStacks(targetStacks);
	}

	return success;
}

// if no slot is free, will be split to the first slot of the same type
function static SplitCreatureStackToEmptySlot( H7EditorArmy sourceArmy, H7EditorArmy targetArmy, int sourceIndex, int splitCount, optional int targetIndex = -1, optional bool forceTransferToTargetArmy = false )
{
	local H7InstantCommandSplitCreatureStack command;

	// TODO sync in tactics
	command = new class'H7InstantCommandSplitCreatureStack';
	command.Init( sourceArmy, targetArmy, sourceIndex, splitCount, targetIndex, sourceArmy.GetPlayer().IsControlledByLocalPlayer() ? sourceArmy : targetArmy, forceTransferToTargetArmy );
	class'H7ReplicationInfo'.static.GetInstance().GetInstantCommandManager().StartCommand( command );
}

function static bool SplitCreatureStackToEmptySlotComplete( H7EditorArmy sourceArmy, H7EditorArmy altArmy, int indexSource, int splitCount, out int targetIndex, bool forceTransferToTargetArmy )
{
	local H7BaseCreatureStack stack;
	local array<H7BaseCreatureStack> stacks, altStacks;
	local bool sourceHasSpace, alternativeHasSpace, merge;
	local int i, freeIndex;

	;

	merge = false;
	if( indexSource < 0 || indexSource > 13 ) { ; return false; }

	stacks = sourceArmy.GetBaseCreatureStacks();
	if( stacks[ indexSource ] == none ) { ; return false; }

	sourceHasSpace = false;
	for( i = 0; ( (i < stacks.Length) && !sourceHasSpace ); ++i )
	{
		if( stacks[ i ] == none )
		{
			sourceHasSpace = true;
			freeIndex = i;
		}
	}
	if( !sourceHasSpace && stacks.Length < MAX_ARMY_SIZE )
	{
		sourceHasSpace = true;
		freeIndex = stacks.Length;
	}

	if( !sourceHasSpace || forceTransferToTargetArmy)
	{
		alternativeHasSpace = false;
		if( altArmy != none )
		{
			stacks = altArmy.GetBaseCreatureStacks();
			for( i = 0; ( (i < stacks.Length) && !alternativeHasSpace ); ++i )
			{
				if( stacks[ i ] == none )
				{
					alternativeHasSpace = true;
					freeIndex = i;
				}
			}
			if( !alternativeHasSpace && stacks.Length < MAX_ARMY_SIZE )
			{
				alternativeHasSpace = true;
				freeIndex = stacks.Length;
			}
		}
		if( !alternativeHasSpace )
		{
			stacks = sourceArmy.GetBaseCreatureStacks();
			for( i = 0; ( (i < stacks.Length) && !sourceHasSpace ); i++ )
			{
				if( stacks[ i ].GetStackType().GetName() == stacks[ indexSource ].GetStackType().GetName() && i != indexSource )
				{
					sourceHasSpace = true;
					freeIndex = i;
					merge = true;
				}
			}
		}
	}

	// check if source and target slot have the same creature type -> set to TRUE
	if(altArmy!=none && targetIndex!=-1)
	{
		stacks = sourceArmy.GetBaseCreatureStacks();
		altStacks = altArmy.GetBaseCreatureStacks();
		if(altStacks[targetIndex] != none && 
		   stacks[indexSource].GetStackType() == altStacks[targetIndex].GetStackType())
			merge = true;
	}
		
	if( !sourceHasSpace && !alternativeHasSpace ) { ; return false; }

	if( sourceHasSpace && !forceTransferToTargetArmy) { altArmy = sourceArmy; }

	if(targetIndex != -1) freeIndex = targetIndex;
		
	stacks = sourceArmy.GetBaseCreatureStacks();
	stacks[ indexSource ].SetStackSize( stacks[ indexSource ].GetStackSize() - splitCount );

	stack = new class'H7BaseCreatureStack'();
	stack.SetDeployed(false); // new stacks always count as undeployed
	stack.SetStackType( stacks[ indexSource ].GetStackType() );
	stack.SetStackSize( splitCount );

	stacks = altArmy.GetBaseCreatureStacks();
	if( freeIndex != stacks.Length && !merge)
	{
		stacks.Remove( freeIndex, 1 );
		altArmy.SetBaseCreatureStacks( stacks );
	}
	if( !merge )
	{
		stacks.InsertItem( freeIndex, stack );
		altArmy.SetBaseCreatureStacks( stacks );
	}
	else
	{
		stacks[freeIndex].SetStackSize( stacks[freeIndex].GetStackSize() + splitCount );
	}
	targetIndex = freeIndex;

	stacks = sourceArmy.GetBaseCreatureStacks();
	;
	;
	for( i = 0; i < stacks.Length; i++ )
	{
		if( stacks[i] != none )
			;
		else
			;
	}
	;
	;

	stacks = altArmy.GetBaseCreatureStacks();
	;
	;
	for( i = 0; i < stacks.Length; i++ )
	{
		if( stacks[i] != none )
			;
		else
			;
	}
	;
	;

	return true;
}

function InitRandomValues()
{
	local int xpAmount, i;

	xpAmount = mXPStrength * class'H7AdventureController'.static.GetInstance().mDifficultyCritterStartSizeMultiplier;

	for( i = 0; i < mCreatureStackProperties.Length; ++i )
	{
		mCreatureStackProperties[i].Size = GetRandomCreatureStackSize( mCreatureStackProperties[i].Creature, float( xpAmount ) / float( mCreatureStackProperties.Length ) );
	}
}

function int GetRandomCreatureStackSize( H7Creature creature, float xpToUse )
{
	local float creatureXP;

	if( creature != none )
	{
		creatureXP = Max( 1, creature.GetExperiencePoints() );

		return FCeil( xpToUse / creatureXP );
	}

	return 0;
}

event bool UseLlamaMesh()
{
	if(class'H7PlayerProfile'.static.GetInstance() != none && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager() != none)
	{
		if(class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().GetStateReward_LM()  && class'H7PlayerProfile'.static.GetInstance().GetAchievementManager().CanRewardBeUsed()
		&& IsStarterHero() )

		return true;
	}

	return false;
}

// We override and copy the SkeletalMesh version of this PlayParticleEffect so we can store on this skeletal mesh the particles that uses the skeletalmesh component.
// We can then cleanup them when this actor is destroyed in CleanupEmitterPools so it avoid an engine assert that uses the destroyed skeletalmesh component.
event bool PlayParticleEffect( const AnimNotify_PlayParticleEffect AnimNotifyData )
{
	local vector Loc;
	local rotator Rot;
	local ParticleSystemComponent PSC;
	local bool bPlayNonExtreme;
	local H7EmitterSpawnable emitterActor;

	if (WorldInfo.NetMode == NM_DedicatedServer)
	{
		;
		return true;
	}

	// should I play non extreme content?
	bPlayNonExtreme = ( AnimNotifyData.bIsExtremeContent == TRUE ) && ( WorldInfo.GRI.ShouldShowGore() == FALSE ) ;

	// if we should not respond to anim notifies OR if this is extreme content and we can't show extreme content then return
	if( ( bShouldDoAnimNotifies == FALSE )
		// if playing non extreme but no data is set, just return
		|| ( bPlayNonExtreme && AnimNotifyData.PSNonExtremeContentTemplate==None )
		)
	{
		// Return TRUE to prevent the SkelMeshComponent from playing it as well!
		return true;
	}

	// now go ahead and spawn the particle system based on whether we need to attach it or not
	if( AnimNotifyData.bAttach == TRUE )
	{
		PSC = new(self) class'ParticleSystemComponent';  // move this to the object pool once it can support attached to bone/socket and relative translation/rotation
		if ( bPlayNonExtreme )
		{
			PSC.SetTemplate( AnimNotifyData.PSNonExtremeContentTemplate );
		}
		else
		{
			PSC.SetTemplate( AnimNotifyData.PSTemplate );
		}

		if( AnimNotifyData.SocketName != '' )
		{
			SkeletalMeshComponent.AttachComponentToSocket( PSC, AnimNotifyData.SocketName );
		}
		else if( AnimNotifyData.BoneName != '' )
		{
			SkeletalMeshComponent.AttachComponent( PSC, AnimNotifyData.BoneName );
		}
		else if( SkeletalMeshComponent.GetBoneName(0) != '' ) // LIMBIC
		{
			SkeletalMeshComponent.AttachComponent( PSC, SkeletalMeshComponent.GetBoneName(0) );
		}

		PSC.ActivateSystem();
		PSC.OnSystemFinished = OnPooledAttachedParticleSystemFinished;

		AllocatePooledEmitter(PSC);
	}
	else
	{
		// find the location
		if( AnimNotifyData.SocketName != '' )
		{
			SkeletalMeshComponent.GetSocketWorldLocationAndRotation( AnimNotifyData.SocketName, Loc, Rot );
		}
		else if( AnimNotifyData.BoneName != '' )
		{
			Loc = SkeletalMeshComponent.GetBoneLocation( AnimNotifyData.BoneName );
			Rot = QuatToRotator(SkeletalMeshComponent.GetBoneQuaternion(AnimNotifyData.BoneName));
		}
		else
		{
			Loc = Location;
			Rot = rot(0,0,1);
		}

		//PSC = WorldInfo.MyEmitterPool.SpawnEmitter( AnimNotifyData.PSTemplate, Loc,  Rot); // these fail to be GC'd if they use SkelVertSurf. using an Emitter actor now instead
		emitterActor = Spawn(class'H7EmitterSpawnable', self,, Loc, Rot,, false);
		if (emitterActor != None)
		{
			emitterActor.SetDrawScale(DrawScale);
			emitterActor.SetDrawScale3D(DrawScale3D);
			PSC = emitterActor.ParticleSystemComponent;
		}
		if (PSC != None)
		{
			if ( bPlayNonExtreme )
			{
				//PSC.SetTemplate( AnimNotifyData.PSNonExtremeContentTemplate );
				emitterActor.SetTemplate( AnimNotifyData.PSNonExtremeContentTemplate, true );
			}
			else
			{
				//PSC.SetTemplate( AnimNotifyData.PSTemplate );
				emitterActor.SetTemplate( AnimNotifyData.PSTemplate, true );
			}

			PSC.SetScale(SkeletalMeshComponent.Scale);
			PSC.SetScale3D(SkeletalMeshComponent.Scale3D);
		}
	}

	if( PSC != None && AnimNotifyData.BoneSocketModuleActorName != '' )
	{
		PSC.SetActorParameter(AnimNotifyData.BoneSocketModuleActorName, self);
	}

	return true;
}

native function AllocatePooledEmitter( ParticleSystemComponent PSC );

simulated function OnPooledAttachedParticleSystemFinished( ParticleSystemComponent PSC )
{
	SkelMeshActorOnParticleSystemFinished(PSC);
	RecyclePooledEmitter(PSC);
}

simulated function RecyclePooledEmitter( ParticleSystemComponent PSC )
{
	local int poolIndex;
	
	poolIndex = mEmitterPoolParticleComps.Find(PSC);
	if (mEmitterPoolParticleComps.Find(PSC) != INDEX_NONE)
	{
		mEmitterPoolParticleComps[poolIndex].CleanupEmitters();
		mEmitterPoolParticleComps[poolIndex].DeactivateSystem();
		mEmitterPoolParticleComps[poolIndex] = None;
	}
}

event CleanupEmitterPools()
{
	local ParticleSystemComponent PSC;
	foreach mEmitterPoolParticleComps(PSC)
	{
		PSC.CleanupEmitters();
		PSC.DeactivateSystem();
	}
	mEmitterPoolParticleComps.Length = 0;
}

function PrintStateToLog(optional string armyName)
{
	local array<H7BaseCreatureStack> stacks;
	local int i;
	stacks = GetBaseCreatureStacks();
	if(armyName != "")
	{
		;
	}
	else
	{
		;
	}
	;
	for( i = 0; i < stacks.Length; i++ )
	{
		if( stacks[i] != none )
			;
		else
			;
	}
	;
	;
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
// (cpptext)
// (cpptext)

