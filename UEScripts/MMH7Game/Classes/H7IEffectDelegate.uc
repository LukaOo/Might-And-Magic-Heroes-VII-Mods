//=============================================================================
// H7IEffectDelegate
//=============================================================================
// Interface to rig Object(s) with a script function to be executed by
// H7EffectSpecial inplace of the standard execute to allow for more variety
// in spell mechanics.
//=============================================================================
// Copyright 2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
interface H7IEffectDelegate
	dependson(H7StructsAndEnumsNative)
	native(Tussi);

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false ) {}

function String GetTooltipReplacement() {}

//function string GetDefaultString()
//{
//	`log_eui(self @ "GetDefaultString not implemented");
//}
