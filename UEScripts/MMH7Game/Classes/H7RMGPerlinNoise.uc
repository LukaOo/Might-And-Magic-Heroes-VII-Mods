//=============================================================================
// H7RMGPerlinNoise
//=============================================================================
//
//
//
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7RMGPerlinNoise extends Object
	native(RMG);

var protectedwrite native transient pointer	mPermutation{ INT };
var protectedwrite native transient pointer	mPerlin{ INT };

var protectedwrite INT		mPermutationLength;
var protectedwrite INT		mPLength;

var protectedwrite FLOAT	mFrequency;
var protectedwrite FLOAT	mAmplitude;
var protectedwrite FLOAT	mPersistency;
var protectedwrite INT		mOctaves;
var protectedwrite INT      mSeed;


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
