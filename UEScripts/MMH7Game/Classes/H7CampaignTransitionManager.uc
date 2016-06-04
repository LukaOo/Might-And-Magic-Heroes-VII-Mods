//=============================================================================
// H7CampaignTransitionManager
//=============================================================================
// 
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CampaignTransitionManager extends Object
	dependson(H7StructsAndEnumsNative)
;

struct H7InventoryItem
{
	var string ItemArchRef;

	var IntPoint InventoryPos;
};

struct H7TransitionHero
{
	// Hero
	var string HeroArchRef;

	// Level
	var int Level;
	var int SkillPoints;
	var int Xp;

	// Stats
	var int Might;
	var int Defence;
	var int Magic;
	var int Spirit;
	var int Leadership;
	var int Destiny;
	var int MinDamage;
	var int MaxDamage;
	var int MaxManaBouns;
	var int Movement;
	var int ArcaneKnowledgeBase;
	
	// Inventory
	var array<H7InventoryItem> Inventory;

	// Equipment
	var string HelmetArchRef;
	var string WeaponArchRef;
	var string ChestArmorArchRef;
	var string GlovesArchRef;
	var string ShoesArchRef;
	var string NecklaceArchRef;
	var string Ring1ArchRef;
	var string CapeArchRef;

	// Skills
	var array<H7SkillProxy> SkillRefs;

	var array<string> AbilityRefs;

	// Spells
	var array<string> SpellArchRefs;

	structdefaultproperties
	{
		HeroArchRef = ""
	}
};

struct H7TransistionMap
{
	// When map ends TransitionData is sealed, so if somebody tries to write to it, has to overwrite it
	var bool Sealed;

	var string MapFileName;

	var array<H7TransitionHero> TransitionHeros;

	structdefaultproperties
	{
		Sealed = false
	}
};

var protected array<H7TransistionMap> mCampaignTransData;

// Holds players choice from Final1 to Final2, set/get by kismet nodes. -1 Invalid, for meaning of 0 and up ask Ramirooooooooooooooooooooooooooooooooooooo
var protected int mFinalHeroChoice;

function int GetFinalHeroChoice() { return mFinalHeroChoice; }
function SetFinalHeroChoice(int newValue) { mFinalHeroChoice = newValue; }

// Returns index of given mapFile from transition datas
function int GetTransitionMapIndex(string mapFileName)
{
	local int i;

	for( i = 0; i < mCampaignTransData.Length; ++i)
	{
		if(mCampaignTransData[i].MapFileName == Caps(mapFileName))
		{
			return i;
		}
	}

	return -1;
}

function int GetHeroArchRefIndex(H7TransistionMap mapProxy, string heroArchRef)
{
	local int i;

	if(heroArchRef == "" || Caps(heroArchRef) == "NONE")
	{
		;

		return -1;
	}

	for(i = mapProxy.TransitionHeros.Length-1; i >= 0; --i)
	{
		if(mapProxy.TransitionHeros[i].HeroArchRef == heroArchRef)
		{
			return i;
		}
	}

	return -1;
}

// Check if transition map is already on list
function bool HasTransitionMap(string mapFileName)
{
	local int i;

	for( i = 0; i < mCampaignTransData.Length; ++i)
	{
		if(mCampaignTransData[i].MapFileName == Caps(mapFileName))
		{
			return true;
		}
	}

	return false;
}

function GatherRelevantHeros(out array<H7AdventureHero> foundHeros)
{
	local H7AdventureArmy army;
	local WorldInfo currentWorldInfo;

	currentWorldInfo = class'WorldInfo'.static.GetWorldInfo();

	if (currentWorldInfo == None)
	{
		;
		return;
	}

	// Check armies for heros
	foreach currentWorldInfo.DynamicActors(class'H7AdventureArmy', army)
	{
		if(army.GetHeroTemplate() != none && army.GetHeroTemplate().GetSaveProgress())
		{
			foundHeros.AddItem(army.GetHero());
		}
	}
}

function H7TransitionHero FindLatestStoredHero(H7AdventureHero hero, bool currentMap /* should search for data in current map? */)
{
	local H7AdventureController advController;
	local int transitionMapIndex, bestMapIndex, currentMapIndex, heroIndex, i;
	local H7TransitionHero dummy;

	advController = class'H7AdventureController'.static.GetInstance();

	transitionMapIndex = -1;

	if(advController != none && advController.GetCampaign() != none)
	{
		// First find proxy from current map and take it if its unsealed !
		if(currentMap)
		{
			for(i = 0; i < mCampaignTransData.Length; ++i)
			{
				if(mCampaignTransData[i].MapFileName == Caps(advController.GetMapFileName()) && !mCampaignTransData[i].Sealed)
				{
					// Check if there is hero data in this map info
					heroIndex = GetHeroArchRefIndex(mCampaignTransData[i], Pathname( hero.GetSourceArchetype() ) );

					if(heroIndex <= -1) // Support 1.2 chnage
					{
						// Check if there is hero data in this map info
						heroIndex = GetHeroArchRefIndex(mCampaignTransData[i], Pathname( hero.GetOriginArchetype() ) );
					}

					if(heroIndex > -1)
					{
						transitionMapIndex = i;
				
						break;
					}
				}
			}
		}

		// If we never saved during this map playthrough, try to find hero data on previous maps
		if(transitionMapIndex < 0)
		{
			bestMapIndex = -1;

			for(i = 0; i < mCampaignTransData.Length; ++i)
			{
				if(mCampaignTransData[i].MapFileName != Caps(advController.GetMapFileName()) )
				{
					// Index of map in campaign
					currentMapIndex = advController.GetCampaign().GetMapIndex( mCampaignTransData[i].MapFileName );

					if(currentMapIndex > -1 && currentMapIndex < advController.GetCampaign().GetMapIndex(advController.GetMapFileName()) )
					{
						// Check if there is hero data in this map info
						heroIndex = GetHeroArchRefIndex(mCampaignTransData[i], Pathname( hero.GetSourceArchetype() ) );

						if(heroIndex <= -1) // Support 1.2 and older file
						{
							// Check if there is hero data in this map info
							heroIndex = GetHeroArchRefIndex(mCampaignTransData[i], Pathname( hero.GetOriginArchetype() ) );
						}
							
						// Is index bigger then best found?
						if(heroIndex > -1 && bestMapIndex < currentMapIndex )
						{
							bestMapIndex = currentMapIndex;
							transitionMapIndex = i;
						}
					}
				}
			}
		}
	}


	if(transitionMapIndex > -1)
	{
		heroIndex = GetHeroArchRefIndex(mCampaignTransData[transitionMapIndex], Pathname( hero.GetSourceArchetype() ));

		if(heroIndex <= -1) // Support 1.2 and older file
		{
			// Check if there is hero data in this map info
			heroIndex = GetHeroArchRefIndex(mCampaignTransData[transitionMapIndex], Pathname( hero.GetOriginArchetype() ) );
		}

		return mCampaignTransData[transitionMapIndex].TransitionHeros[ heroIndex ];
	}
	else
	{
		return dummy;
	}
}

// Called when QuestController 'Wins' map
function SaveTransitionMap(string mapFileName)
{
	local array<H7AdventureHero> saveHeros;
	local int i, transitionMapIndex;
	local H7TransistionMap transitionMap;

	if(mapFileName == "")
	{
		return;
	}

	transitionMapIndex = GetTransitionMapIndex(mapFileName);

	// There no tansition for this map -> create
	if(transitionMapIndex < 0)
	{
		// Save map data
		transitionMap.MapFileName = Caps(mapFileName);

		transitionMapIndex = mCampaignTransData.Length;
		mCampaignTransData.AddItem(transitionMap);

	}
	else // There is transition for this map -> override
	{
		if(mCampaignTransData[transitionMapIndex].Sealed) // If its sealed it means nobody touched it during map
		{
			transitionMap.MapFileName = Caps(mapFileName);
	
			// Clear map data with new struct
			mCampaignTransData[transitionMapIndex] = transitionMap;
		}
		
	}

	// Save hero data
	GatherRelevantHeros(saveHeros);

	for( i = 0; i < saveHeros.Length; ++i)
	{
		if(saveHeros[i] != none)
		{
			mCampaignTransData[transitionMapIndex].TransitionHeros.AddItem( SaveTransitionHero(saveHeros[i]) );
		}
	}

	// Seal it
	mCampaignTransData[transitionMapIndex].Sealed = true;
}

// Used DURING map when heros are Destroyed by Kismet (on demand) -> Look H7SeqAct_RemoveHero
function StoreHero(H7AdventureHero hero)
{
	local H7AdventureController advController;
	local H7TransitionHero savedHero;
	local H7TransistionMap transitionMap;
	local int transitionMapIndex, transitionHeroIndex, i;

	advController = class'H7AdventureController'.static.GetInstance();
	

	if(advController != none && advController.GetCampaign() != none)
	{
		savedHero = SaveTransitionHero(hero);

		transitionMapIndex = GetTransitionMapIndex( advController.GetMapFileName() );

		if(transitionMapIndex < 0)
		{
			// Save map data
			transitionMap.MapFileName = Caps(advController.GetMapFileName());

			transitionMapIndex = mCampaignTransData.Length;
			mCampaignTransData.AddItem(transitionMap);

			mCampaignTransData[transitionMapIndex].TransitionHeros.AddItem(savedHero);
		}
		else
		{
			if(mCampaignTransData[transitionMapIndex].Sealed) // -> overwrite
			{
				// Overwrite map data
				mCampaignTransData[transitionMapIndex].TransitionHeros.Length = 0;
				mCampaignTransData[transitionMapIndex].Sealed = false;

				mCampaignTransData[transitionMapIndex].TransitionHeros.AddItem(savedHero);
			}
			else // -> fresh, add data
			{
				transitionHeroIndex = -1;
				// Check if hero is already saved
				for(i = 0; i < mCampaignTransData[transitionMapIndex].TransitionHeros.Length; ++i)
				{
					if(mCampaignTransData[transitionMapIndex].TransitionHeros[i].HeroArchRef == savedHero.HeroArchRef)
					{
						transitionHeroIndex = i;

						break;
					}
				}

				if(transitionHeroIndex < 0)
				{
					mCampaignTransData[transitionMapIndex].TransitionHeros.AddItem(savedHero);
				}
				else
				{
					mCampaignTransData[transitionMapIndex].TransitionHeros[transitionHeroIndex] = savedHero;
				}
			}
		}
	}
}

// Saves only relevant data for transition
function H7TransitionHero SaveTransitionHero(H7AdventureHero hero)
{
	local H7TransitionHero transitionHero;
	local int i;
	local H7Inventory tempInventory;
	local array<H7HeroItem> tempItems;
	local H7InventoryItem inventoryItem;
	local array<H7Skill> tempSkills;
	local array<H7HeroAbility> tempAbilities;
	local H7SkillProxy skillProxy;

	// Save Ref
	transitionHero.HeroArchRef = Pathname( hero.GetSourceArchetype() );

	// Save Level
	transitionHero.Level = hero.GetLevel();
	transitionHero.Xp = hero.GetExperiencePoints();
	transitionHero.SkillPoints = hero.GetSkillPoints();

	// Save Stats
	transitionHero.Might = hero.GetAttackBase();
	transitionHero.Defence = hero.GetDefenseBase();
	transitionHero.Magic = hero.GetMagicBase();
	transitionHero.Spirit = hero.GetSpiritBase();
	transitionHero.Leadership = hero.GetLeadershipBase();
	transitionHero.Destiny = hero.GetDestinyBase();
	hero.GetDamageRangeBase(transitionHero.MinDamage, transitionHero.MaxDamage);
	transitionHero.MaxManaBouns = hero.GetMaxManaBonus();
	transitionHero.Movement = hero.GetMovementPointsBase();
	transitionHero.ArcaneKnowledgeBase = hero.GetArcangeKnowlageBase();
	
	// Save Inventory
	tempInventory = hero.GetInventory();
	tempItems = tempInventory.GetItems();

	for( i = 0; i < tempItems.Length; ++i)
	{
		if(tempItems[i].IsCampaignPersistent() )
		{
			inventoryItem.ItemArchRef = Pathname( tempItems[i].ObjectArchetype );
			
			inventoryItem.InventoryPos = tempInventory.GetItemPosByItem(tempItems[i]);

			transitionHero.Inventory.AddItem(inventoryItem);
		}
	}

	// Save Equipment
	if(hero.GetEquipment().GetHelmet() != none && hero.GetEquipment().GetHelmet().IsCampaignPersistent())
	{
		transitionHero.HelmetArchRef = Pathname(hero.GetEquipment().GetHelmet().ObjectArchetype);
	}
	if(hero.GetEquipment().GetWeapon() != none && hero.GetEquipment().GetWeapon().IsCampaignPersistent())
	{
		transitionHero.WeaponArchRef = Pathname(hero.GetEquipment().GetWeapon().ObjectArchetype);
	}
	if(hero.GetEquipment().GetChestArmor() != none && hero.GetEquipment().GetChestArmor().IsCampaignPersistent())
	{
		transitionHero.ChestArmorArchRef = Pathname(hero.GetEquipment().GetChestArmor().ObjectArchetype);
	}
	if(hero.GetEquipment().GetGloves() != none && hero.GetEquipment().GetGloves().IsCampaignPersistent())
	{
		transitionHero.GlovesArchRef = Pathname(hero.GetEquipment().GetGloves().ObjectArchetype);
	}
	if(hero.GetEquipment().GetShoes() != none && hero.GetEquipment().GetShoes().IsCampaignPersistent())
	{
		transitionHero.ShoesArchRef = Pathname(hero.GetEquipment().GetShoes().ObjectArchetype);
	}
	if(hero.GetEquipment().GetNecklace() != none && hero.GetEquipment().GetNecklace().IsCampaignPersistent())
	{
		transitionHero.NecklaceArchRef = Pathname(hero.GetEquipment().GetNecklace().ObjectArchetype);
	}
	if(hero.GetEquipment().GetRing1() != none && hero.GetEquipment().GetRing1().IsCampaignPersistent())
	{
		transitionHero.Ring1ArchRef = Pathname(hero.GetEquipment().GetRing1().ObjectArchetype);
	}
	if(hero.GetEquipment().GetCape() != none && hero.GetEquipment().GetCape().IsCampaignPersistent())
	{
		transitionHero.CapeArchRef = Pathname(hero.GetEquipment().GetCape().ObjectArchetype);
	}

	// Save Skills & Abilities
	tempSkills = hero.GetSkillManager().GetAllSkills();

	for( i = 0; i < tempSkills.Length; ++i) 
	{
		if( tempSkills[i].GetCurrentSkillRank() != SR_UNSKILLED)
		{
			skillProxy.SkillArchRef = Pathname( tempSkills[i].ObjectArchetype );
			skillProxy.SkillRank = tempSkills[i].GetCurrentSkillRank();
			skillProxy.UltimateRequirment = tempSkills[i].GetUltimateReqirement();

			transitionHero.SkillRefs.AddItem( skillProxy );
		}
	}   
	
	tempAbilities = hero.GetSkillManager().GetLearnedAbilites();

	for( i = 0; i < tempAbilities.Length; ++i ) 
	{
		transitionHero.AbilityRefs.AddItem( PathName( tempAbilities[i].ObjectArchetype ) );		
	}

	// Save Spells
	transitionHero.SpellArchRefs = hero.GetAbilityManager().GetHeroSpellArchRefs();

	return transitionHero;
}

function LoadTransitionMap(string mapFileName)
{
	local array<H7AdventureHero> loadHeroes;
	local int j, transitionMapIndex;
	local H7TransitionHero transHero;

	if(mapFileName == "")
	{
		return;
	}

	transitionMapIndex = GetTransitionMapIndex(mapFileName);

	if(transitionMapIndex < 0)
	{
		return;
	}

	GatherRelevantHeros(loadHeroes);
	
	for(j = 0; j < loadHeroes.Length; ++j)
	{
		transHero = FindLatestStoredHero( loadHeroes[j], false);

		if(loadHeroes[j] != none && transHero.HeroArchRef != "")
		{
			LoadTransitionHero(loadHeroes[j], transHero);
		}
	}
	
}

// Used DURING map when heros are Spawned by Kismet (on demand) -> Look H7SeqAct_SpawnArmy
function LoadStoredHero(H7AdventureHero hero)
{
	local H7TransitionHero transHero;

	transHero = FindLatestStoredHero(hero, true);

	// If found load the the data onto hero actor
	if(transHero.HeroArchRef != "")
	{
		LoadTransitionHero(hero, transHero);
	}
}

// Loads only relevant data for transition
function LoadTransitionHero(H7AdventureHero hero, H7TransitionHero heroData)
{
	local int i, j;
	local H7HeroAbility abilityArch;
	local array<H7Skill> tempSkills;

	if(hero == none)
	{
		return;
	}

	// Load Level
	hero.SetXp( heroData.Xp );
	hero.SetSkillPoints( heroData.SkillPoints );
	hero.SetLevel( heroData.Level );

	// Load Stats
	hero.SetAttack(heroData.Might);
	hero.SetDefense(heroData.Defence);
	hero.SetMagic(heroData.Magic);
	hero.SetSpirit(heroData.Spirit);
	hero.SetLeadership(heroData.Leadership);
	hero.SetDestiny(heroData.Destiny);
	hero.SetMinimumDamage(heroData.MinDamage);
	hero.SetMaximumDamage(heroData.MaxDamage);
	hero.SetMaxManaBonus(heroData.MaxManaBouns);
	hero.SetCurrentMana(hero.GetMaxMana());
	hero.SetMaxMovementPoints(heroData.Movement);
	hero.SetArcangeKnowledgeBase(heroData.ArcaneKnowledgeBase);

	// Load Equipment
	if(heroData.HelmetArchRef != "" && heroData.HelmetArchRef != "None")
	{
		hero.GetEquipment().SetHelmet( class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.HelmetArchRef , class'H7HeroItem') )) );
	}
	if(heroData.WeaponArchRef != "" && heroData.WeaponArchRef != "None")
	{
		hero.GetEquipment().SetWeapon(class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.WeaponArchRef , class'H7HeroItem') )) );
	}
	if(heroData.ChestArmorArchRef != "" && heroData.ChestArmorArchRef != "None")
	{
		hero.GetEquipment().SetChestArmor(class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.ChestArmorArchRef , class'H7HeroItem') )) );
	}
	if(heroData.GlovesArchRef != "" && heroData.GlovesArchRef != "None")
	{
		hero.GetEquipment().SetGloves(class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.GlovesArchRef , class'H7HeroItem') )));
	}
	if(heroData.ShoesArchRef != "" && heroData.ShoesArchRef != "None")
	{
		hero.GetEquipment().SetShoes(  class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.ShoesArchRef , class'H7HeroItem') ) ));
	}
	if(heroData.NecklaceArchRef != "" && heroData.NecklaceArchRef != "None")
	{
		hero.GetEquipment().SetNecklace(class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.NecklaceArchRef , class'H7HeroItem') )));
	}
	if(heroData.Ring1ArchRef != "" && heroData.Ring1ArchRef != "None")
	{
		hero.GetEquipment().SetRing1(class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.Ring1ArchRef , class'H7HeroItem') )));
	}
	if(heroData.CapeArchRef != "" && heroData.CapeArchRef != "None")
	{
		hero.GetEquipment().SetCape(class'H7HeroItem'.static.CreateItem(H7HeroItem( DynamicLoadObject( heroData.CapeArchRef , class'H7HeroItem') )));
	}

	// Load Inventory (must come after Load Equipment to avoid issues with auto-equip
	for(i = 0; i < heroData.Inventory.Length; ++i)
	{
		if( heroData.Inventory[i].ItemArchRef != "" )
		{
			hero.GetInventory().AddItemToInventory( H7HeroItem( DynamicLoadObject( heroData.Inventory[i].ItemArchRef, class'H7HeroItem') ), heroData.Inventory[i].InventoryPos.X, heroData.Inventory[i].InventoryPos.Y );
		}
	}

	// Load Skills & Abilities
	tempSkills = hero.GetSkillManager().GetAllSkills();

	for( i = 0; i < heroData.SkillRefs.Length; ++i )
	{
		if(heroData.SkillRefs[i].SkillRank != SR_UNSKILLED)
		{   
			for(j = 0; j < tempSkills.Length; ++j)
			{
				if(Pathname( tempSkills[j].ObjectArchetype ) == heroData.SkillRefs[i].SkillArchRef )
				{
					tempSkills[j].SetCurrentSkillRank(ESkillRank(heroData.SkillRefs[i].SkillRank) );
					tempSkills[j].SetUltimateRequirment(heroData.SkillRefs[i].UltimateRequirment);
				}
			}
		}  
	}

	for( i = 0; i < heroData.AbilityRefs.Length; ++i )
	{
		abilityArch = H7HeroAbility(DynamicLoadObject(heroData.AbilityRefs[i], class'H7HeroAbility'));

		if(abilityArch != none && !hero.GetSkillManager().HasLearnedAbility(abilityArch) )
		{
			hero.GetSkillManager().DoLearnAbility(abilityArch);
		}
	}

	// Load Spells
	for( i = 0; i < heroData.SpellArchRefs.Length; ++i )
	{
		abilityArch = H7HeroAbility(DynamicLoadObject(heroData.SpellArchRefs[i], class'H7HeroAbility'));

		if(abilityArch != none)
		{
			hero.GetAbilityManager().LearnAbility( H7HeroAbility(DynamicLoadObject(heroData.SpellArchRefs[i], class'H7HeroAbility')) );
		}
	}   
	 
}






