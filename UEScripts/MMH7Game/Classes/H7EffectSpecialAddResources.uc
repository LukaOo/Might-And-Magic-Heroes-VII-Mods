//=============================================================================
// H7EffectSpecialAddResources
//
// - add an amount of a resource to the player's income
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EffectSpecialAddResources extends Object 
	implements(H7IEffectDelegate) 
	hidecategories(Object)
	native(Tussi);


/** If this is checked, the player will receive a random resource. */
var(Resources) protected bool            mUseRandomResource<DisplayName=Use Random Resource By Rank>;
/** The rank of the random resource. */
var(Resources) protected EResourceRank   mResourceRank<DisplayName=Rank of Resource|EditCondition=mUseRandomResource>;
/** The resource the player receives. Must be specified if "Use Random Resource By Rank" is unchecked. */
var(Resources) protected H7Resource      mResource<DisplayName=Resource|EditCondition=!mUseRandomResource>;
/** The amount of the specified or random resource (can be negative to remove resources). */
var(Resources) protected int             mAmount<DisplayName=Amount>;
var(Resources) protected bool            mAddInstantly<DisplayName=Add Instantly>;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local array<ResourceStockpile> resources;
	local ResourceStockpile currentResource;
	local array<H7Resource> resourcesByRank;
	local float randomFloat;
	local H7Player player;
	local H7ICaster caster;
	local H7Resource res;

	// don't do simulations
	if(isSimulated) { return; }

	// check if caster of effect source is a hero
	caster = effect.GetSource().GetInitiator();
	if( caster == none ) 
	{
		return;
	}

	player = caster.GetPlayer();

	// in case the resource used previously was deleted/moved or left empty and random is unchecked, inform datamanager and/or coder
	if( mResource == none && !mUseRandomResource )
	{
		;
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("H7EffectSpecialAddResources: No resource given and Use Random Resource is false! (effect was"@effect.GetSource().GetName()$")",MD_QA_LOG);;
		return;
	}
	
	if(mUseRandomResource)
	{
		randomFloat = class'H7ReplicationInfo'.static.GetInstance().GetSynchRNG().GetRandomFloat();
		resources = player.GetResourceSet().GetResources();
		// find resources with specified rank
		foreach resources(currentResource)
		{
			if(currentResource.Type.GetRank() == mResourceRank)
			{
				resourcesByRank.AddItem(currentResource.Type);
			}
		}
		// in case a new rank is added or the editor screws up drop downs again
		if(resourcesByRank.Length == 0)
		{
			;
			class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage("H7EffectSpecialAddResources: Could not find resource with rank"@mResourceRank@"!",MD_QA_LOG);;
			return;
		}
		// add amount of random resource
		
		res = resourcesByRank[ Round( randomFloat * ( resourcesByRank.Length - 1 ) ) ];
		if( mAddInstantly )
		{
			player.GetResourceSet().ModifyResource( res, mAmount, true );
		}
		else
		{
			player.GetResourceSet().ModifyIncome( res, mAmount );
		}
	}
	else
	{
		// add amount of specified resource
		if( mAddInstantly )
		{
			player.GetResourceSet().ModifyResource( mResource, mAmount, true );
		}
		else
		{
			player.GetResourceSet().ModifyIncome( mResource, mAmount );
		}
	}
}

function String GetTooltipReplacement()
{
	return class'H7Loca'.static.LocalizeSave("TTR_ADD_RESOURCE","H7TooltipReplacement");
}

function String GetDefaultString()
{
	return class'H7GameUtility'.static.FloatToString( mAmount );
}

function Texture2d GetIcon()
{
	return mResource.GetIcon();
}
