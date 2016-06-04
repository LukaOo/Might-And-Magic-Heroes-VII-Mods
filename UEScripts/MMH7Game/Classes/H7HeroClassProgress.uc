//=============================================================================
// H7ClassProgress
//=============================================================================
// Defines what stats a class will get when leveling up
//=============================================================================
// Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroClassProgress extends Object;

var(Progress) protected float                  mStatProbabilityAttack<DisplayName=Probability that Might Attack increases on level up>;
var(Progress) protected float                  mStatProbabilityDefense<DisplayName=Probability that Might Defense increases on level up>;
var(Progress) protected float                  mStatProbabilityMagic<DisplayName=Probability that Magic increase on level uo>;
var(Progress) protected float                  mStatProbabilitySpirit<DisplayName=Probability that Spirit increase on level uo>;


function float GetStatProbabilityAttack()  { return mStatProbabilityAttack; };
function float GetStatProbabilityDefense() { return mStatProbabilityDefense; };
function float GetStatPropabilityMagic()   { return mStatProbabilityMagic; };
function float GetStatPropabilitySpirit()  { return mStatProbabilitySpirit; };
