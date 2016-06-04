class H7SeqAct_SetResource extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** The type of resource to change */
var(Developer) protected H7ResourceQuantity mResource<DisplayName="Resource DEPRECATED! Use Resources list instead">;
/** The type of resources to change */
var(Properties) protected array<H7ResourceQuantity> mResources<DisplayName="Resources">;
/** What to change about the resource */
var(Properties) protected EModQuantityOper mOper<DisplayName="Operator">;
/** Permanently change the income rate */
var(Properties) protected bool mIncome<DisplayName="Modify income rate">;
//TODO: this action belongs to one of "for one/all player action". Refactor after implementing player action
var(Properties) protected EPlayerNumber mPlayerNumber<DisplayName="Target player"|ToolTip="The player that owns the resource">;

event activated()
{
	local H7Player p;
	local H7Resource resource;
	local int val;
	local H7ResourceQuantity resourceQuantity;
	local H7AdventureController advCntl;
	local H7AdventureArmy army;
	local H7FCTController fctController;

	advCntl = class'H7AdventureController'.static.GetInstance();
	fctController = class'H7FCTController'.static.GetInstance();

	army = advCntl.GetSelectedArmy();

	p = advCntl.GetPlayerByNumber(mPlayerNumber);
	if ( p == none )
	{
		return;
	}

	foreach mResources(resourceQuantity)
	{
		val = 0;
		resource = resourceQuantity.Type;
		if (mOper == EMQO_ADD)
		{
			if(army != none)
			{
				fctController.StartFCT(FCT_RESOURCE_PICKUP, army.Location, p, "+"$resourceQuantity.Quantity , MakeColor(0,255,0,255), resource.GetIcon());
			}
			val = resourceQuantity.Quantity;
		}
		else if (mOper == EMQO_SUB)
		{
			if(army != none)
			{
				fctController.StartFCT(FCT_RESOURCE_PICKUP, army.Location, p, "-"$resourceQuantity.Quantity , MakeColor(255,0,0,255), resource.GetIcon());
			}
			val = -resourceQuantity.Quantity;
		}
		else if (mOper == EMQO_SET)
		{
			if ( mIncome )
			{
				val = resourceQuantity.Quantity - p.GetResourceSet().GetIncome(resource);
			}
			else
			{
				val = resourceQuantity.Quantity - p.GetResourceSet().GetResource(resource);
			}
		}

		if ( mIncome )
		{
			p.GetResourceSet().ModifyIncome(resource, val);
		}
		else
		{
			p.GetResourceSet().ModifyResource(resource, val);
		}
	}

	if(advCntl.GetCurrentPlayer() == advCntl.GetLocalPlayer() && advCntl.GetCurrentPlayer() == p)
	{
		class'H7AdventureHudCntl'.static.GetInstance().GetTopBar().UpdateAllResourceAmountsAndIcons( p.GetResourceSet().GetAllResourcesAsArray() );
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 4;
}

event VersionUpdated(int oldVersion, int newVersion)
{
	local H7ResourceQuantity oldQuantity;
	if(oldVersion < 3 && mResources.Length == 0)
	{
		oldQuantity = mResource;
		mResources.AddItem(oldQuantity);
	}
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

