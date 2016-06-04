/*=============================================================================
 * H7ObjectLayerFilter
 *
 * Copyright 2013-2015 Limbic Entertainment GmbH. All Rights Reserved.
=============================================================================*/

class H7ObjectLayerFilterConfig extends Object
	config(ObjectLayerFilter)
	native(Ed);

struct native ObjectLayerFilter
{
	var string RootPath;
	var string MatchedPrefix;
	var string MatchedPackage;
	var string IgnoredPackage;
	var string MatchedClass;
	var string IgnoredAsset;
};

var config array<ObjectLayerFilter> ObjectLayerFilters;
