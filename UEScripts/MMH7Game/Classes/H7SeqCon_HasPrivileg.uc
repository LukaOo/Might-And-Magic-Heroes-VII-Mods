// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.

class H7SeqCon_HasPrivileg extends SequenceCondition
	native;

var(Developer) bool mPreorderArtifacts<DisplayName="Pre-Order Artifacts">;

native function Activated();

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 1;
}

