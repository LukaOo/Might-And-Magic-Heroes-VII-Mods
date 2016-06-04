/*=============================================================================
 * H7EditorContent
 * 
 * Contains list of data to be shown as content in the editor in addition to
 * the stuff available in H7GameData
 * 
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ===========================================================================*/
class H7EditorContent extends Object
	hidecategories(Object)
	native;

// The H7PlayerStart archetype to list in the Editor
var(Heroes) private archetype H7PlayerStart mPlayerStart<DisplayName="PlayerStart">;
// Campaign heroes that should be listed within the Editor
var(Heroes) private array<H7EditorHero> mCampaignHeroes<DisplayName="Campaign Heroes">;

// Foliage meshes available for Adventure Maps
var(Foliage) private array<H7GroupedMeshes> mAdventureFoliage<DisplayName="Adventure Map Foliage">;
// Foliage meshes available for Combat Maps
var(Foliage) private array<H7GroupedMeshes> mCombatFoliage<DisplayName="Combat Map Foliage">;

// Editor Objects to list in the Editor
var(Editor) private array<Object> mEditorObjects<DisplayName="Editor Objects">;

// Particles, Light and Sound objects to list in the Editor
var(Ambiance) private array<Object> mAmbianceObjects<DisplayName="Ambiance Objects">;

// Particles, Light and Sound objects to list in the Editor
var(Combat) private array<H7CombatObstacleObject> mCombatMapObstacles<DisplayName="Combat Map Obstacles">;
