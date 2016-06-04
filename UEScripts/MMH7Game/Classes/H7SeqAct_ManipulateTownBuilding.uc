/*=============================================================================
 * H7SeqAct_ActivateNpcScene
 * 
 * Needed for noob editor
 *  
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================*/

class H7SeqAct_ManipulateTownBuilding extends SequenceAction
	implements(H7IAliasable, H7IActionable)
	native;

/** The town which building to manipulate */
var (Properties) H7Town mTown<DisplayName="Town to manipulate">;
var(Properties) protected H7TownBuilding mBuilding<DisplayName="Building to manipulate">;
var(Properties) protected bool mBuild<DisplayName="True: Build, False: Disable">;

function Activated()
{
	if( mTown != none && mBuilding != none )
	{
		if( mBuild )
		{
			mTown.BuildBuildingForced( mBuilding.GetName() );
		}
		else
		{
			mTown.DisableBuilding( mBuilding );
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion();
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

