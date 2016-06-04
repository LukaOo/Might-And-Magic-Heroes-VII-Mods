/* Copyright 2013-2016 Limbic Entertainment All Rights Reserved.
 * 
 * Class to create reusable archetypes containing strings.
 * The pinnacle of engineering culture at Limbic.
 * 
 */
class H7PathList extends Object
	native
	hideCategories(Object);

var(Properties) protected array<string> mPaths<DisplayName="Paths">;

function array<string> GetPaths() { return mPaths; }
