//=============================================================================
// H7SeqAct_SetSurrenderFlee
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class  H7SeqAct_SetSurrenderFlee extends SequenceAction 
	implements(H7IAliasable)
	native;

var(Properties) protected bool CanFlee<DisplayName=Can Use Flee Mechanic>;
var(Properties) protected bool CanSurrender<DisplayName=Can Use Surrender Mechanic>;


event Activated()
{
	class'H7AdventureController'.static.GetInstance().SetKismetAllowsFlee(CanFlee);
	class'H7AdventureController'.static.GetInstance().SetKismetAllowsSurrender(CanSurrender);
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

