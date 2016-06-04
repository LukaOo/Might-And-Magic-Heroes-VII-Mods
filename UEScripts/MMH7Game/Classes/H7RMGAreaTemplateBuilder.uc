//=============================================================================
// H7RMGAreaTemplateBuilder
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGAreaTemplateBuilder extends Object
	dependson(H7RMGStructsAndEnums)
	native(RMG);

var private array<H7RMGZoneTemplate> mTemplates;

var private float mCurrentPZ;
var private float mMaxPZ;

var private int mPlayerCount;

native function bool CreateMapTemplates( out H7RMGProperties properties, out pointer outTemplates{TArray<UH7RMGZoneTemplate*>} );

native function DestroyTemplateBuilder();
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
