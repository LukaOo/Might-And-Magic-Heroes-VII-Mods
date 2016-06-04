/*=============================================================================
 * H7IProgressable
 * ============================================================================
 * 
 * Interface for objects that have information about quest progress
 * =============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * =============================================================================
 */

interface H7IProgressable;

function bool HasProgress() {}
function array<H7ConditionProgress> GetCurrentProgresses() {}
