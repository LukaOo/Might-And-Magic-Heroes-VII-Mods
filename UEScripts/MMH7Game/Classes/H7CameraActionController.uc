//=============================================================================
// H7CameraActionManager
//
// Manages events that occur on the adventure map that triggers the camera to move to a certain place
//
// Copyright 1998-2014 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7CameraActionController extends Actor
	HideCategories(Movement,Display,Attachment,Collision,Physics,Advanced,Debug,Object,Mobile);

struct AMEventAction
{
	var Actor startTarget;
	var Actor endTarget;
	var delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction;
	var delegate<H7AMEventCameraAction.OnMidAction> midActionFunction;
	var H7AMEventCameraAction amEventTemplate;
};

var(CameraAction) H7ZoomInCameraAction	        mZoomInTemplate<DisplayName=Zoom In>;
var(CameraAction) H7ZoomOutCameraAction	        mZoomOutTemplate<DisplayName=Zoom Out>;

var(CameraAction) H7AMEventCameraAction	        mAMEventTemplate<DisplayName=AM Event>;
var(CameraAction) H7PresentArmyCameraAction	    mPresentArmyTemplate<DisplayName=Present Army>;
var(CameraAction) H7AttackCameraAction	        mMeleeAttackTemplate<DisplayName=Melee Attack>;
var(CameraAction) H7AttackCameraAction	        mRangedAttackTemplate<DisplayName=Ranged Attack>;
var(CameraAction) H7AbilityCastCameraAction	    mAbilityCastTemplate<DisplayName=Ability Cast>;

var(CameraAction) H7ArmyVictoryCameraAction	    mArmyVictoryTemplate<DisplayName=Army Victory>;
var(CameraAction) H7IntroduceHeroCameraAction	mIntroduceHeroTemplate<DisplayName=Introduce Hero>;

var protected MaterialEffect                    mFadeToBlackPP;
var protected MaterialInstanceConstant          mFadeToBlackPPMat;
var protected float                             mFadeToBlackAlpha;

var protected MaterialEffect                    mCombatStartEffect;
var protected MaterialInstanceConstant          mCombatStartEffectMat;

var protected float                             mFadingDuration;
var protected bool                              bFadingToBlack;
var protected bool                          	bFadingToNormal;

//var protected array<CameraEventData> mActionQueue;
var protected H7CameraAction	                mCurrentAction;
var protected H7AMEventCameraAction             mContinuingAction;
var protected float                             mPreviousViewDistance;
var protected float                             mPreviousFOV;
var protected Vector                            mPreviousVRP;

var protected H7Unit                            mLastAttacker;
var protected H7Unit                            mLastDefender;

var array<AMEventAction>                        mAMEventQueue;

static function H7CameraActionController GetInstance()
{
	if(class'H7ReplicationInfo'.static.GetInstance() == none) return none;
	return class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().GetCameraActionController();
}

function H7CameraAction GetCurrentAction() { return mCurrentAction; }

function bool HasAMEventActionsInQueue() {return mAMEventQueue.Length > 0;}

function bool CanCancelCurrentCameraAction()
{
	if(mCurrentAction == none)
	{
		return false;
	}
	
	return mCurrentAction.Class != class'H7ZoomInCameraAction' && mCurrentAction.Class != class'H7ZoomOutCameraAction';
}

function CancelCurrentCameraAction()
{
	if(mCurrentAction != none)
	{
		mCurrentAction.StopAction();
	}
}

function PostBeginPlay()
{
	super.PostBeginPlay();

	class'H7ReplicationInfo'.static.GetInstance().GetControllerManager().SetCameraActionController( self );

	mFadeToBlackPP = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPFadeToBlack'));
	if (mFadeToBlackPP != None)
	{
		mFadeToBlackPPMat = new(self) class'MaterialInstanceConstant';
		mFadeToBlackPPMat.SetParent(mFadeToBlackPP.Material);
		mFadeToBlackPP.Material = mFadeToBlackPPMat;
	}

	mFadeToBlackPPMat.GetScalarParameterValue('Alpha', mFadeToBlackAlpha);

	mCombatStartEffect = MaterialEffect(LocalPlayer(class'H7PlayerController'.static.GetPlayerController().Player).PlayerPostProcess.FindPostProcessEffect('PPCombatStart'));
	if (mCombatStartEffect != None)
	{
		mCombatStartEffectMat = new(self) class'MaterialInstanceConstant';
		mCombatStartEffectMat.SetParent(mCombatStartEffect.Material);
		mCombatStartEffect.Material = mCombatStartEffectMat;
	}
}

function ClearLastAttackerDefender()
{
	mLastAttacker = none;
	mLastDefender = none;
}

function ClearCurrentAction()
{
	mCurrentAction = none;
}

function FadeToColor(float duration, LinearColor targetColor)
{
	SetFadeColor(targetColor);

	if(duration == 0.0f)
	{
		SetFadeAlpha(0.0f);
		bFadingToBlack  = false;
		bFadingToNormal = false;
		return;
	}
	
	SetFadeAlpha(1.0f);
	mFadingDuration = duration;
	bFadingToBlack  = true;
	bFadingToNormal = false;
}

function FadeToBlack(float duration)
{
	FadeToColor(duration, MakeLinearColor(0, 0, 0, 1));
}

function FadeToWhite(float duration)
{
	FadeToColor(duration, MakeLinearColor(1, 1, 1, 1));
}

function FadeFromColor(float duration, LinearColor sourceColor)
{
	SetFadeColor(sourceColor);

	if(duration == 0.0f)
	{
		SetFadeAlpha(1.0f);
		bFadingToBlack  = false;
		bFadingToNormal = false;
		return;
	}

	SetFadeAlpha(0.0f);
	mFadingDuration = duration;
	bFadingToBlack  = false;
	bFadingToNormal = true;
}

function FadeFromBlack(float duration)
{
	FadeFromColor(duration, MakeLinearColor(0, 0, 0, 1));
}


function FadeFromWhite(float duration)
{
	FadeFromColor(duration, MakeLinearColor(1, 1, 1, 1));
}

/** 0.0f means fully black, 1.0f means game-view, -1.0f indicates an error */
function float GetFadeAlpha()
{
	if(mFadeToBlackPPMat != none)
	{
		mFadeToBlackPPMat.GetScalarParameterValue('Alpha', mFadeToBlackAlpha);
		return mFadeToBlackAlpha;
	}
	return -1.0f;
}

/** 0.0f means fully black, 1.0f means game-view (clamped) */
function SetFadeAlpha(float val)
{
	mFadeToBlackAlpha = FClamp(val, 0.0f, 1.0f);

	if(mFadeToBlackPPMat != none)
	{
		mFadeToBlackPPMat.SetScalarParameterValue('Alpha', mFadeToBlackAlpha);
	}

	mFadeToBlackPP.bShowInGame = (mFadeToBlackAlpha < 1.0f);
}

function SetFadeColor(LinearColor col)
{
	if(mFadeToBlackPPMat != none)
	{
		mFadeToBlackPPMat.SetVectorParameterValue('Color', col);
	}
}

function SetCombatStartEffectStrength(float strength)
{
	mCombatStartEffectMat.SetScalarParameterValue('EffectStrength', strength);

	if (class'H7ReplicationInfo'.static.GetInstance().GetPostprocessManager().GetPostProcessQuality() < 1)
	{
		mCombatStartEffect.bShowInGame = false;
		return;
	}

	mCombatStartEffect.bShowInGame = (strength > 0.0f);
}

function StartAction(H7CameraAction action)
{
	if(mCurrentAction != none)
	{
		mCurrentAction.StopAction();
	}
	mCurrentAction = action;
	action.StartAction();
}

function StartZoomInAction(Vector targetPos, delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction = none)
{
	local H7ZoomInCameraAction action;

	mPreviousViewDistance = class'H7Camera'.static.GetInstance().GetTargetViewingDistance();
	mPreviousFOV = class'H7Camera'.static.GetInstance().GetFOVAngle();
	mPreviousVRP = class'H7Camera'.static.GetInstance().GetCurrentVRP();

	action = Spawn(class'H7ZoomInCameraAction',self,,,, mZoomInTemplate ,true);
	action.Init(targetPos, actionCompletedFunction);
	StartAction(action);
}

function StartZoomOutToPreviousValues(bool armyOfLocalPlayer)
{
	if(armyOfLocalPlayer)
	{
		StartZoomOutAction(false, mPreviousViewDistance, mPreviousFOV);
	}
	else
	{
		class'H7Camera'.static.GetInstance().SetTargetViewingDistance(mPreviousViewDistance);
		class'H7Camera'.static.GetInstance().SetFOV(mPreviousFOV);
		class'H7Camera'.static.GetInstance().SetTargetVRP(mPreviousVRP);
		class'H7Camera'.static.GetInstance().SetCurrentVRP(mPreviousVRP);
	}
}

function StartZoomOutAction(bool toGridCenter, float targetViewDistance, float targetFOV, delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction = none)
{
	local H7ZoomOutCameraAction action;

	action = Spawn(class'H7ZoomOutCameraAction',self,,,, mZoomOutTemplate ,true);
	action.Init(toGridCenter, targetViewDistance, targetFOV, actionCompletedFunction);
	StartAction(action);
}

function StartAMEventAction(Actor startTarget, Actor endTarget = none, delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction = none, delegate<H7AMEventCameraAction.OnMidAction> midActionFunction = none, optional H7AMEventCameraAction amEventTemplate = none)
{
	local H7AMEventCameraAction action;
	local AMEventAction queueAction;

	if(mCurrentAction != none)
	{
		queueAction.startTarget = startTarget;
		queueAction.endTarget = endTarget;
		queueAction.actionCompletedFunction = actionCompletedFunction;
		queueAction.midActionFunction = midActionFunction;
		queueAction.amEventTemplate = amEventTemplate;
		mAMEventQueue.AddItem(queueAction);
		return;
	}

	if(amEventTemplate == none)
	{
		amEventTemplate = mAMEventTemplate;
	}

	action = Spawn(class'H7AMEventCameraAction',self,,,, amEventTemplate ,true);
	action.Init(startTarget, endTarget, false, actionCompletedFunction, midActionFunction);
	StartAction(action);	
}

function StartSpawnedAMEventAction(H7AMEventCameraAction action, Actor startTarget, Actor endTarget = none, bool continues = false, delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction = none)
{
	action.Init(startTarget, endTarget, continues, actionCompletedFunction);
	action.SetContinuingAction(mContinuingAction);
	StartAction(action);

	if(continues)
	{
		if(mContinuingAction == none)
		{
			mContinuingAction = action;
		}
	}
	else
	{
		mContinuingAction = none;
	}
}

function StartAttackAction(H7Unit attacker, H7Unit defender, bool isRetaliation, bool isRanged)
{
	local H7AttackCameraAction action;
	local bool sameAttackerDefender, inversedAttackerDefender;

	if( !CanPlayCombatCoolCamByChance() ) return;	

	if(mCurrentAction != none)
	{
		if(mCurrentAction.Class == class'H7AttackCameraAction' && isRetaliation)
		{
			mCurrentAction.SetDuration(mCurrentAction.GetDuration() - 1);
			mCurrentAction.ResetDuration();
		}

		return;
	}

	// don't repeat camera action for same units twice
	sameAttackerDefender = mLastAttacker == attacker && mLastDefender == defender;
	inversedAttackerDefender = mLastAttacker == defender && mLastDefender == attacker;
	if(sameAttackerDefender || inversedAttackerDefender)
	{
		return;
	}

	mLastAttacker = attacker;
	mLastDefender = defender;
	
	if( isRanged )
	{
		action = Spawn(class'H7AttackCameraAction',self,,,, mRangedAttackTemplate,true);
	}
	else
	{
		action = Spawn(class'H7AttackCameraAction',self,,,, mMeleeAttackTemplate,true);
	}
	action.Init(attacker, defender);
	if(!isRetaliation)
	{
		action.SetDuration(action.GetDuration() + 1);
	}
	StartAction(action);
}

function StartAbilityCastAction(H7Unit caster)
{
	local H7AbilityCastCameraAction action;

	if( !CanPlayCombatCoolCamByChance() ) return;

	if(!class'H7ReplicationInfo'.static.GetInstance().IsCombatMap())
	{
		return;
	}

	action = Spawn(class'H7AbilityCastCameraAction',self,,,, mAbilityCastTemplate,true);
	action.Init(caster);
	StartAction(action);
}


public function StartPresentArmy(delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction = none, optional H7PresentArmyCameraAction presentArmyTemplate = none)
{
	local H7PresentArmyCameraAction action;

	if( IsCoolCamCameraActionDisabled() ) 
	{
		if(actionCompletedFunction != none)
		{
			actionCompletedFunction();
		}
		return;
	}

	if(presentArmyTemplate == none)
	{
		presentArmyTemplate = mPresentArmyTemplate;
	}

	action = Spawn(class'H7PresentArmyCameraAction',self,,,, presentArmyTemplate ,true);
	action.Init(actionCompletedFunction);
	StartAction(action);
}

public function StartArmyVictory(delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction = none, optional H7ArmyVictoryCameraAction armyVictoryTemplate = none)
{
	local H7ArmyVictoryCameraAction action;

	if( IsCoolCamCameraActionDisabled() ) 
	{
		if(actionCompletedFunction != none)
		{
			actionCompletedFunction();
		}
		return;
	}

	if(armyVictoryTemplate == none)
	{
		armyVictoryTemplate = mArmyVictoryTemplate;
	}

	action = Spawn(class'H7ArmyVictoryCameraAction',self,,,, armyVictoryTemplate ,true);
	action.Init(actionCompletedFunction);
	StartAction(action);
}

public function StartIntroduceHero(delegate<H7CameraAction.OnActionCompleted> actionCompletedFunction = none, optional H7IntroduceHeroCameraAction introduceHeroTemplate = none)
{
	local H7IntroduceHeroCameraAction action;
	
	if( IsCoolCamCameraActionDisabled() )
	{
		if(actionCompletedFunction != none)
		{
			actionCompletedFunction();
		}
		return;
	}

	if(introduceHeroTemplate == none)
	{
		introduceHeroTemplate = mIntroduceHeroTemplate;
	}
	action = Spawn(class'H7IntroduceHeroCameraAction',self,,,, introduceHeroTemplate ,true);
	action.Init(actionCompletedFunction);
	StartAction(action);
}

function Tick( float deltaTime)
{
	deltaTime = deltaTime * class'H7ReplicationInfo'.static.GetInstance().GetGameSpeed();

	if(mCurrentAction != none)
	{
		mCurrentAction.Update(deltaTime);

		if(mCurrentAction.IsActionFinished())
		{
			bFadingToNormal     = false;
			bFadingToBlack      = false;
			mCurrentAction.StopAction();
			return;
		}
	}
	else if(mAMEventQueue.Length > 0)
	{
		StartAMEventAction(mAMEventQueue[0].startTarget, mAMEventQueue[0].endTarget, mAMEventQueue[0].actionCompletedFunction, mAMEventQueue[0].midActionFunction, mAMEventQueue[0].amEventTemplate);
		mAMEventQueue.Remove(0, 1);
	}

	if(bFadingToBlack)
	{
		bFadingToNormal = false;
		mFadeToBlackAlpha -= deltaTime / mFadingDuration;
		if(mFadeToBlackAlpha <= 0.0f )
		{
			
			mFadeToBlackAlpha   = 0.0f;
			bFadingToBlack      = false;
		}
		SetFadeAlpha(mFadeToBlackAlpha); 
	}
	else if(bFadingToNormal)
	{
		bFadingToBlack = false;
		mFadeToBlackAlpha += deltaTime / mFadingDuration;
		if(mFadeToBlackAlpha >= 1.0f )
		{
			mFadeToBlackAlpha   = 1.0f;
			bFadingToNormal     = false;
		}
		SetFadeAlpha(mFadeToBlackAlpha); 
	}
}
protected function bool IsCoolCamCameraActionDisabled()
{
	return !class'H7PlayerController'.static.GetPlayerController().GetHUD().GetProperties().GetCoolCamCombatActionAllowed();
}
protected function bool CanPlayCombatCoolCamByChance()
{
	local H7PlayerController playerCntl;

	playerCntl = class'H7PlayerController'.static.GetPlayerController();

	// ROLL THE DICE
	if( RandRange( 0, 100 ) > playerCntl.GetHUD().GetProperties().GetCoolCamChance() )
	{
		return false;
	}

	return true;
}

