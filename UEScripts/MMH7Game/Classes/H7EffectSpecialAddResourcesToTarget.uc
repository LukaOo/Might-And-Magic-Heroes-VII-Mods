//=============================================================================
// H7EffectSpecialAddResourcesToTarget
//
// - add an amount of a resource to the player's income
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialAddResourcesToTarget extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);


/** If this is checked, the player will receive a random resource. */
var(Resources) protected bool            mUseRandomResource<DisplayName=Use Random Resource By Rank>;
/** The amount of the specified or random resource (can be negative to remove resources). */
var(Resources) protected int             mAmount<DisplayName=Amount>;

var(Resources) protected array<H7ResourceQuantity> mPossibleResourcesMin<DisplayName=ResourceTypes and Min amount value>;
var(Resources) protected array<H7ResourceQuantity> mPossibleResourcesMax<DisplayName=ResourceTypes and Max amount value>;

var protected H7ResourceQuantity mPreparedResources;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local int randomValue;
	local H7Player player;
	local H7IEffectTargetable hero;
	local array<H7IEffectTargetable> targets;

	effect.GetTargets( targets );
	if( targets.Length == 0 ) return;

	// don't do simulations
	if(isSimulated) { return; }

	ForEach targets(hero)
	{
	
		if( hero == none || H7EditorHero(hero) == none ) 
		{
			continue;
		}

		player = H7EditorHero( hero ).GetPlayer();

		// in case the resource used previously was deleted/moved or left empty and random is unchecked, inform datamanager and/or coder
		if( mPossibleResourcesMin.Length == 0 && mPossibleResourcesMax.Length == 0 )
		{
			;
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("H7EffectSpecialAddResourceToTarget has no defined Resource"@effect.GetSource().GetName()$")",MD_QA_LOG);;
			return;
		}

		//Create random amount of random Resource once per week
		randomValue = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomInt(mPossibleResourcesMin.Length);
		mPreparedResources.Type = mPossibleResourcesMin[randomValue].Type;
		randomValue = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomIntRange( mPossibleResourcesMin[randomValue].Quantity, mPossibleResourcesMax[randomValue].Quantity + 1);
		mPreparedResources.Quantity = randomValue;

		// add amount of random resource
		player.GetResourceSet().ModifyResource( mPreparedResources.Type, mPreparedResources.Quantity, true );
		
		class'H7FCTController'.static.GetInstance().StartFCT(FCT_RESOURCE_PICKUP, class'H7AdventureController'.static.GetInstance().GetGridController().GetCell(hero.GetGridPosition().X, hero.GetGridPosition().Y).GetLocation(), player, "+" $ mPreparedResources.Quantity , MakeColor(0,255,0,255) , mPreparedResources.Type.GetIcon() );
	
	}
}

function String GetDefaultString()
{
	return mPossibleResourcesMin[0].Quantity $ "-" $ mPossibleResourcesMax[0].Quantity;
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_ADD_RESOURCE","H7TooltipReplacement");
}

function Texture2d GetIcon()
{
	if(mUseRandomResource)
	{
		return mPreparedResources.Type.GetIcon(); // TODO Fails
	}
	else
	{
		return none;
	}
}
