class SaveGameTransition extends Object;

var string PersistentMapFileName;

var protected array<JsonObject> SerializedHeroes;

function Save()
{
	local WorldInfo WorldInfo;
	local H7AdventureHero Hero;

	WorldInfo = class'WorldInfo'.static.GetWorldInfo();
	if (WorldInfo == None)
	{
		return;
	}

	PersistentMapFileName = class'H7ReplicationInfo'.static.GetInstance().GetCurrentMapName();

	ForEach WorldInfo.DynamicActors(class'H7AdventureHero', Hero)
	{
		SerializedHeroes.AddItem ( Hero.Serialize() );
	}
}
