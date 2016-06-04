// Warning, this is not a Player Profile, 
// 
// this is 1 save for one map in the form of TransitionSave_[CAMPAIGNNAME][MAPINDEX]

class PlayerProfileState extends Object;

const SAVEGAMESTATE_REVISION = 1;

struct HeroTransitionSaveStruct
{
	var string mHeroArchetypeName;
	var string mSerializedHeroes;
};

var array<HeroTransitionSaveStruct> HeroProfileSaveData;

// writes data from the rest of the game/actors into it's member vars
//function Save() 
//{
//	//local H7AdventureHero hero;
//	//local H7AdventureArmy army;
//	//local HeroTransitionSaveStruct data;
	
//	//local WorldInfo currentWorldinfo;
//	//currentWorldinfo = class'WorldInfo'.static.GetWorldInfo();

//	//if (currentWorldinfo == None)
//	//{
//	//	`warn("No World Info");
//	//	return;
//	//}
	
//	//// Save every Hero flagged to be saved 
//	//ForEach currentWorldinfo.DynamicActors(class'H7AdventureArmy', army)
//	//{
//	//	if(army.GetHeroTemplate() != none && army.GetHeroTemplate().GetSaveProgress() )
//	//	{
//	//		hero = army.GetHero();
//	//		data.mSerializedHeroes = class'JSonObject'.static.EncodeJson(hero.Serialize());
//	//		data.mHeroArchetypeName = hero.GetName();
//	//		HeroProfileSaveData.AddItem ( data );
//	//	}
//	//}
//}

// writes data from it's member vars into the rest of the game/actors
//function Load() 
//{
//	//local H7AdventureHero hero;
//	//local H7AdventureArmy army;
//	//local H7VisitableSite site;
//	//local int i;
//	//local string currentHeroName;
//	//local WorldInfo currentWorldinfo;

//	//currentWorldinfo = class'WorldInfo'.static.GetWorldInfo();

//	//if (currentWorldinfo == None)
//	//{
//	//	`warn("No World Info");
//	//	return;
//	//}

//	//// For each serialized data object
//	//for (i = 0; i < HeroProfileSaveData.Length; i++)
//	//{
//	//	if (HeroProfileSaveData[i].mHeroArchetypeName != "")
//	//	{
//	//		//Check all armies for heroes
//	//		ForEach currentWorldinfo.DynamicActors(class'H7AdventureArmy', army)
//	//		{
//	//			if(army.GetHeroTemplate() != none && army.GetHeroTemplate().GetSaveProgress())
//	//			{
//	//				hero = army.GetHero();
//	//				currentHeroName = hero.GetName();
					
//	//				if(currentHeroName == HeroProfileSaveData[i].mHeroArchetypeName)
//	//				{
//	//					hero.Deserialize(class'JSonObject'.static.DecodeJson(HeroProfileSaveData[i].mSerializedHeroes));
//	//				}
//	//			}
//	//		}
//	//		//Check all sites for visiting heroes
//	//		ForEach currentWorldinfo.DynamicActors(class'H7VisitableSite', site)
//	//		{
//	//			if(site.GetVisitingArmy().GetHero() != none && hero.GetSaveProgress())
//	//			{
//	//				hero = site.GetVisitingArmy().GetHero();
//	//				currentHeroName = hero.GetName();

//	//				if(currentHeroName == HeroProfileSaveData[i].mHeroArchetypeName)
//	//				{
//	//					hero.Deserialize(class'JSonObject'.static.DecodeJson(HeroProfileSaveData[i].mSerializedHeroes));
//	//				}
//	//			}
//	//		}
//	//	}
//	//}
//}
