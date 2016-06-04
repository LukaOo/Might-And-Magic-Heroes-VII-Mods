/*=============================================================================
 * H7SeqAct_ChangeLayerVisiblity
 * 
 * Changes visiblity of poses of given layers
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 *=============================================================================*/

class H7SeqAct_ChangeLayerVisibility extends SequenceAction
	implements(H7IAliasable)
	native;


// If true will hide layer, false will show
var(LayerProperties) protected bool mShouldHide<DisplayName="Should Hide">;
// If true hide flags enabled, false disabled
var(LayerProperties) protected bool mHideFlags<DisplayName="Hide Council Table flags">;
var(LayerProperties) protected array<name> mLayers<DisplayName="Layers">;

function Activated()
{
	local int i, k;
	local H7CouncilManager councilManager;
	local H7AdventureController adventureController;
	local array<InterpActor> interpActors;
	local H7CouncilMapManager mapManager;
	local array<CampaignsMapData> flags;

	councilManager = class'H7CouncilManager'.static.GetInstance();
	if(councilManager != none && H7CouncilPlayerController(councilManager.GetALocalPlayerController()) != none)
	{
		interpActors = H7CouncilPlayerController(councilManager.GetALocalPlayerController()).GetCouncilInterpActors();

		for(i = 0; i < interpActors.Length; ++i)
		{
			for(k = 0; k < mLayers.Length; ++k)
			{
				if(InStr(interpActors[i].Layer, mLayers[k],, true,) != -1 )
				{
					if(mShouldHide)
					{
						interpActors[i].SetHidden(true);
						interpActors[i].SetCollisionType(COLLIDE_NoCollision);

					}
					else
					{
						interpActors[i].SetHidden(false);
						interpActors[i].SetCollisionType(COLLIDE_BlockAll);
					}
						
				}
			}
		}
	}

	adventureController =  class'H7AdventureController'.static.GetInstance();

	if(councilManager != none)
	{
		mapManager = councilManager.GetMapManager();
	}
	else if(adventureController != none)
	{
		mapManager = adventureController.GetCouncilMapManager();
	}

	if( mapManager != none )
	{
		

		if(!mHideFlags)
		{
			mapManager.ShowAllUnlockedFlags();
		}
		else
		{
			flags = mapManager.GetCampaignFlags();

			for(i = 0; i < flags.Length; ++i)
			{
				for(k = 0; k < flags[i].campaignFlags.Length; ++k)
				{   
					flags[i].campaignFlags[k].Hide();
					flags[i].campaignFlags[k].DisableOutline();
				}   
			}
		}

	}

}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

