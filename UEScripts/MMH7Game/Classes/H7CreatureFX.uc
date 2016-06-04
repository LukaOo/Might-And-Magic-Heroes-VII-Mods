//=============================================================================
//  H7CreatureFX
// 
//  Class that handles the material of a creature and colors it depending on
//  the team the creature belongs to and when the mouse hovers over the
//  creature.
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7CreatureFX extends Object;

var protected SkeletalMeshComponent mMesh;
var protected MaterialInstanceConstant	mMatInst;
var protected LinearColor mAttackerColor, mDefenderColor;
						
function InitFX(SkeletalMeshComponent creatureMesh)
{
	mMesh = creatureMesh;
	mMesh.SetOutlined(false);
}

function SetTeamColor( int teamID ) 
{
	//	TODO: Implement mesh embedded team color
}

function SetIsHovering(bool isHovering)
{
	if(mMesh != none)
	{
		mMesh.SetOutlined( isHovering && !class'H7PlayerController'.static.GetPlayerController().IsInCinematicView() );
	}
}

