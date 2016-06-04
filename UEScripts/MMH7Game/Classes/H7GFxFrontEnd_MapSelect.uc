//=============================================================================
// H7GFxFrontEnd_MapSelect
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7GFxFrontEnd_MapSelect extends H7GFxUIContainer;

/** Reference to the list. */
var GFxClikWidget ListMC;

/** Reference to the list's dataProvider array in AS. */
var GFxObject ListDataProvider;

/** Reference to image scroller. Image scroller update is handled by AS. */
var GFxClikWidget ImgScrollerMC;

/** Reference to the left menu. Animation controller. */
var GFxObject MenuMC;

/** Avaiable maps list, provided by the MapInfo DataProvider. */
var array<H7UIDataProvider_MapInfo> MapList;

var int LastSelectedItem;

function DisableWindow()
{
	SetVisibleSave( false );
}


function EnableWindow( ) 
{
	SetVisibleSave( true );
}
