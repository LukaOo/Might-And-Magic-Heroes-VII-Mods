//=============================================================================
// H7HeroAbility
//=============================================================================
// Adds rank-restrictions and mana-consumption to BaseAbility.
//=============================================================================
// Copyright 1998-2013 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7HeroAbility extends H7BaseAbility
	native(Tussi)
	savegame;

// Use this if this container is a Hero Spell (be sure to set the TAG_SPELL aswell) // TODO why the redundancy?
var(Container, Ability) protected bool             mIsSpell                            <DisplayName=Spellbook Spell>;                   

// Is this Ability used in Combat, ( else it is an adventuremap ability)
var(Container, Ability) protected bool             mIsCombatAbility                    <DisplayName=Combat Ability>;

// Mana needed to cast the ability (only useful for active abilities)
var(Container, Ability) protected int              mManaCost                           <DisplayName=Mana Cost>;

// If not zero the spell/ability is on a cooldown timer and can't be casted a second time before it refreshed works only for adventuremap spells
var(Container, Ability) protected int              mCooldownTimer                      <DisplayName=Cooldown Timer (Days)>;

// Minimum Rank to learn this ability
var(Container, Ability) protected ESkillRank       mRank                               <DisplayName=Minimum Required Rank>;

var(Container, Ability) protected bool             mIsUltimate                         <DisplayName=Is GrandMaster Ability>;

var(Container, SoundAndVisuals) protected AkEvent  mAbilitySound                       <DisplayName=Ability sound>;

var protected int                           mCooldownTimerCurrent;
var protected ESkillRank                    mMinimumRankOverride;              


function ESkillRank                         GetMinimumRankOverride()                { return mMinimumRankOverride; }
function                                    SetMinimumRankOverride( ESkillRank r )  { mMinimumRankOverride = r; }

function bool                               IsCombatAbility()                   { return mIsCombatAbility; }
function                       				SetManaCost( int cost )             { mManaCost = cost; }
function ESkillRank                         GetRank()                           { return mRank; }
function bool                               IsGrandMasterAbility()              { return mIsUltimate; }
function bool			                    IsSpell()					        { return mIsSpell; }

function int                    			GetCooldownTimer()                  { return mCooldownTimer; }
function int                    			GetCooldownTimerCurrent()           { return mCooldownTimerCurrent; }
function                        			UpdateCooldownTimer()               { if( mCooldownTimerCurrent > 0 ) mCooldownTimerCurrent--; }
function bool                   			IsOnCooldown()                      { return mCooldownTimerCurrent > 0 ? true : false; }
function int                                GetManaCost()                       
{
	local H7EditorHero caster;
	local float baseCostModified, finalCost;
	
	caster = H7EditorHero( mCaster );
	
	if( caster == none ) 
	{
		return mManaCost;
	}
	else
	{
		baseCostModified = caster.GetManaCostForSpell( self );

		finalCost = ( baseCostModified + caster.GetAddBoniOnStatByID( STAT_MANA_COST ) ) * caster.GetMultiBoniOnStatByID( STAT_MANA_COST );
		if( finalCost > 0 )
		{
			return finalCost;
		}
		else
		{
			return 0;
		}
	}
}

function float GetQuickCombatValue( float armyRelation, float relationThreshold )
{
	local float spellValue;
	local H7EditorHero caster;
	local int skillRankInt, spellTierInt;
	local H7Skill skill;
	local ESkillRank rank;

	caster = H7EditorHero( mCaster );
	skill = caster.GetSkillManager().GetSkillBySkillType( GetSkillType() );
	
	if( skill != none )
	{
		rank = skill.GetCurrentSkillRank();
		switch( rank )
		{
			case SR_UNSKILLED:
				skillRankInt = 1;
				break;
			case SR_NOVICE:
				skillRankInt = 2;
				break;
			case SR_EXPERT:
				skillRankInt = 3;
				break;
			case SR_MASTER:
				skillRankInt = 4;
				break;
			default:
				skillRankInt = 1;
		}
	}
	else
	{
		skillRankInt = 1;
	}

	switch( mRank )
	{
		case SR_UNSKILLED:
			spellTierInt = 1;
			break;
		case SR_NOVICE:
			spellTierInt = 2;
			break;
		case SR_EXPERT:
			spellTierInt = 3;
			break;
		case SR_MASTER:
			spellTierInt = 4;
			break;
		default:
			spellTierInt = 1;
	}

	spellValue = GetManaCost() * ( ( spellTierInt + skillRankInt + 1 ) ** FMin( 3.0f, FMax( 0.5f, relationThreshold / armyRelation ) ) );

	return spellValue;
}


function OnInit( H7ICaster owner, optional H7EventContainerStruct container, optional int abilityID )
{
	super.OnInit( owner, container, abilityID );
	if( mCaster != none && mCaster.GetEntityType() != UNIT_HERO )
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(GetDebugName() @ " can be assigned only to heroes (is a HeroAbility). Currently assigned to " @ mCaster.GetName(),MD_QA_LOG);;
	}
}

function bool CanCast(optional out String blockReason)
{
	local array<H7Effect> effects;
	local H7Effect effect;
	local H7IEffectDelegate specialEffectScript;

	if(GetCasterOriginal() == none)
	{
		blockReason = "no caster!";
		return false;
	}
	// check for skill rank
	if(mSkillType == SKT_NONE && mRank != SR_UNSKILLED && mRank != SR_ALL_RANKS)
	{
		class'H7MessageSystem'.static.GetInstance().CreateAndSendMessage(GetDebugName() @ "is not linked to a skill but requires a rank" @ mRank,MD_QA_LOG);;
	}

	// "normal" ability
	if( !mIsSpell
		&& H7EditorHero(mCaster).GetSkillManager().GetSkillBySkillType(mSkillType) != none 
		&& H7EditorHero(mCaster).GetSkillManager().GetSkillBySkillType(mSkillType).GetCurrentSkillRank() < mRank )
	{
		if( mMinimumRankOverride != SR_MAX
			&& H7EditorHero(mCaster).GetSkillManager().GetSkillBySkillType(mSkillType).GetCurrentSkillRank() < mMinimumRankOverride
			|| mMinimumRankOverride == SR_MAX )
		{
			blockReason = "TT_SKILL_TOO_LOW";
			return false;
		}
	}

	if( H7AdventureHero( mCaster ) != none && H7AdventureHero( mCaster ).HasCastedSpellThisTurn() ) // adventure heroes
	{
		blockReason = "TT_ALREADY_CASTED";
		return false;
	}
	else if( H7CombatHero( mCaster ) != none && // combat heroes
		mIsSpell && ( H7CombatHero( mCaster ).GetAttackCount() <= 0 ||
		!class'H7CombatController'.static.GetInstance().CanHeroDoActionInCreatureTurn() &&
		!class'H7CombatController'.static.GetInstance().IsHeroInCreatureTurn() ) )
	{
		blockReason = "TT_ALREADY_CASTED";
		return false;
	}

	if( mOncePerCombat && mCastedOnce )
	{
		blockReason = "TT_CASTED_ONCE";
		return false;
	}

	// check for mana cost
	if( H7EditorHero(mCaster).GetCurrentMana() < GetManaCost() ) 
	{
		blockReason = "TT_NOT_ENOUGH_MANA";
		return false;
	}

	// check for cooldown
	if( IsOnCooldown() == true ) 
	{
		blockReason = "TT_ABILITY_IS_COOLDOWN";
		return false;
	}

	GetEffects( effects, GetInitiator() );
	if(effects.Length == 0) return false;

	// check if a special effect has special checks
	foreach effects( effect )
	{
		if( effect.IsA('H7EffectSpecial'))
		{
			specialEffectScript = H7EffectSpecial(effect).GetFunctionProvider();
			if(H7EffectPortalOfAsha(specialEffectScript) != none && !H7EffectPortalOfAsha(specialEffectScript).CanCast(blockReason,mCaster))
			{
				return false;
			}
		}
	}

	if( mTargetType == NO_TARGET )
	{
		foreach effects( effect )
		{
			if( effect.CasterConditionCheck( mCaster ) )
			{
				return true;
			}
		}
	}
	else
	{
		return true;
	}
	//blockReason = "TT_NO_EFFECT";
	return false;
}


// user clicked to start the spell
function DoSpellStartUpdates()
{
	class'H7PlayerController'.static.GetPlayerController().GetHud().GetSpellbookCntl().GetQuickBar().UnSelectSpell();
	class'H7PlayerController'.static.GetPlayerController().GetHud().UnLoadCursorObject();
}

// spell effect finished running, particle system is finished, this is done with EndTurn() on combat map, but needs to be called on adventure map
// - call this in child.OnFXFinished()
function DoSpellFinishUpdates()
{
	mIsCasting = false;
	if(class'H7ReplicationInfo'.static.GetInstance().IsAdventureMap())
	{
		H7AdventureHero( mCaster ).ResetPreparedAbility();
		class'H7AdventureController'.static.GetInstance().CalculateInputAllowed( mCaster.GetPlayer() );
	}
	else
	{
		class'H7CombatController'.static.GetInstance().CalculateInputAllowed();
	}
}

function bool IsDamageFilter()
{
	local int i;
	for( i=0; i<mTags.Length; ++i )
	{
		if( mTags[i] == TAG_FILTER_DAMAGE )
			return true;
	}
	return false;
}

function bool IsUtilityFilter()
{
	local int i;
	for( i=0; i<mtags.Length; ++i)
	{
		if( mTags[i] == TAG_FILTER_UTILITY )
			return true;
	}

	return false;
}

function ExecuteHeroAbility()
{
	if( mAbilitySound != none && !class'H7SpectatorHUDCntl'.static.GetInstance().GetPopup().IsVisible())
	{
		class'H7SoundManager'.static.PlayAkEventOnActor( Actor(mCaster), mAbilitySound,true,true, Actor(mCaster).Location );
	}
}

// tooltip data for right of icon:
// [      ]   Tier 3 Spell
// [ icon ] Adventure Spell
// [      ]  Cast as Expert
function string GetInfoBox(H7EditorHero hero,optional bool withCastOnInfo=true)
{
	local string infoString;
	local ESkillRank castOn;

	// info box
	if(GetRank() == 0)
	{
		infoString = class'H7Loca'.static.LocalizeSave("TIER_SCROLL_SPELL","H7Abilities");
	}
	else
	{
		infoString = Repl(class'H7Loca'.static.LocalizeSave("TIER_X_SPELL","H7Abilities"),"%tier",int(GetRank()));
	}
	if(IsCombatAbility())
	{
		infoString = infoString $ "\n" $ class'H7Loca'.static.LocalizeSave("COMBAT_SPELL","H7Abilities");
	}
	else
	{
		infoString = infoString $ "\n" $ class'H7Loca'.static.LocalizeSave("ADVENTURE_SPELL","H7Abilities");
	}

	if(withCastOnInfo)
	{
		castOn = SR_UNSKILLED;
		if(GetSkillType() != SKT_NONE
			&& hero.GetSkillManager().GetSkillBySkillType(GetSkillType()) != none)
		{
			castOn = hero.GetSkillManager().GetSkillBySkillType(GetSkillType()).GetCurrentSkillRank();
		}
		if( GetRankOverride() != SR_MAX ) castOn = GetRankOverride();
		infoString = infoString $ "\n" $ class'H7Loca'.static.LocalizeSave(String(castOn) $ "_CAST","H7Combat");
	}

	return infoString;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)


/* TODO
New Properties for H7HeroAbility:
* "Advanced Tooltip": localized string 
* "Display advanced Tooltips for all ranks": bool
The text is displayed once for each rank in the advanced tooltip of the magic guild - starting with the minimum required rank of the spell up to master rank. There is a checkbox that can be ticked to have the text be displayed once for every rank independent of the spell's minimum required rank.

The text placeholder system can be applied to these tooltips as well but needs to be extended:
If the effect container uses "Use Spell Scaling", the ".min" and the ".max" placeholders for the advanced tooltips print the following: 

Y+a*M	(Y is printed without plus or minus sign)
a*M		(if Y is 0 it is omitted completely)
Note: Let Y be the Y-Intercept property; let a be the Slope/Gradient property; let M be the localized(!) name of the hero attribute "Magic". 

The complete content of the placeholder is printed in the highlight font color also used for other placeholders.
*/
