//=============================================================================
// H7Month
//
// class to represent current month
// 
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7Month extends Object
	hidecategories(Object,Attachment,Collision,Physics,Advanced,Debug,Mobile,Movement,Display)
	native
	savegame;

var( Month ) protected string mMonthName<DisplayName=Name>;
var( Month ) protected string mMonthDescription<DisplayName=Description>;
var( Month ) protected int mMonthNumber<DisplayName=Month Number>;

function string GetMonthName() { return mMonthName; }
function string GetMonthDescription() { return mMonthDescription; }

function SetMonthName( string monthName ) { mMonthName = monthName; }
function SetMonthDescription( string monthDescription ) { mMonthDescription = monthDescription; }

