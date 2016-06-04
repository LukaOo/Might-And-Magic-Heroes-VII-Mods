/*=============================================================================
* H7ArtifactRecycler
* =============================================================================
*  
*  
* =============================================================================
*  Copyright 2013 Limbic Entertainment All Rights Reserved.
* ============================================================================= */

class H7ArtifactRecycler extends H7TownBuilding;

var(properties) protected H7ArtifactRecyclingTable mRecyclingTable<DisplayName=Recycling Values Table>;

function H7ArtifactRecyclingTable GetRecyclingTable() {return mRecyclingTable;}
