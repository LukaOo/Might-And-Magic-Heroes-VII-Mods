//=============================================================================
// H7EffectCharge
//
// 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================

class H7EffectCharge extends Object 
	implements(H7IEffectDelegate)
	hidecategories(Object)
	native(Tussi);


var() protected H7BaseBuff mBuff<DisplayName=Buff>;
var() protected array<EStat> mStatsToModify<DisplayName=Stats to modify>;
var() protected int mValuePerStep<DisplayName=Stat gain per step>;

var protected H7Effect mEffect;
var protected H7CreatureStack mOwner;
var protected H7IEffectTargetable mTarget;
var protected H7CombatController mCombatController;
var protected H7EventContainerStruct mContainer;
var protected bool mIsSimulated;

function Initialize( H7Effect effect ) {}

function Execute( H7Effect effect, H7EventContainerStruct container, optional bool isSimulated = false )
{
	local H7ICaster caster/*,attacker*/;
	local H7BaseBuff buff;
	//local H7CombatResult result;

	if( effect == none ) return;

	mCombatController = class'H7CombatController'.static.GetInstance();


	mEffect = effect;
	mTarget = container.Targetable;
	caster = effect.GetSource().GetCaster().GetOriginal();
	mOwner = H7CreatureStack(caster);
	mIsSimulated = isSimulated;
	mContainer = container;

	if( mTarget != none && mCombatController != none && mOwner != none ) 
	{
		// TODO CHECK buff is not applied via GameProcessor here: // <- this is fine btw; all important things are done in the buff manager now
		if( !mOwner.GetBuffManager().HasBuff( mBuff, mOwner, true ) )
		{
			buff = new mBuff.Class(mBuff);
			buff.Init(mTarget, caster, isSimulated);
			mOwner.GetBuffManager().AddBuff( buff, effect.GetSource().GetCaster().GetOriginal(), effect.GetSource() );
		}
		else
		{
			buff = mOwner.GetBuffManager().GetBuff( mBuff );
			buff.SetCaster( mOwner );
		}

		IncreaseStatMods( mOwner );
	}
	mContainer.Path.Length = 0;
	mContainer.EffectContainer = none;
	mContainer.TargetableTargets.Length = 0;
}

function protected IncreaseStatMods( H7CreatureStack caster )
{
	local array<H7EffectOnStats> modifier;
	local H7StatEffect statEffect;
	local H7EffectContainer container;
	local H7ICaster containerCaster;
	local int i;

	container = caster.GetBuffManager().GetBuff( mBuff );

	if( !GetStatModifier( container, modifier ) ) return;

	mOwner.ClearStatCache();
	for( i = 0; i < modifier.Length; ++i )
	{
		statEffect = modifier[i].GetData();
		
		statEffect.mStatMod.mModifierValue = GetDistance( mTarget ) * mValuePerStep;
		modifier[i].SetData( statEffect );
		mOwner.DataChanged();
	}

	containerCaster = container.GetCaster();
	if( H7UnitSnapShot( containerCaster ) != none )
		H7UnitSnapShot( containerCaster ).UpdateSnapShot();

	if( !mIsSimulated )	caster.GetEffectManager().AddToFXQueue( mEffect.GetFx(), mEffect );
}

function protected int GetDistance( H7IEffectTargetable target )
{
	local array<H7BaseCell> path;

	local H7CreatureStack tmpTarget;

	tmpTarget = H7CreatureStack( target );

	if( tmpTarget == none ) return 0;

	path = mContainer.Path;
	
	return path.Length > 0 ? path.Length-1 : 0;
}

function protected bool GetStatModifier( H7EffectContainer container, out array<H7EffectOnStats> modifier )
{
	local H7MeModifiesStat currentStatMod;
	local array<H7Effect> effects;
	local H7Effect effect;
	local H7ICaster buffOwner;

	if( container == none ) return false;
	mOwner.ClearStatCache();

	if( H7BaseBuff( container ) != none )
	{
		buffOwner = H7BaseBuff( container ).GetOwner();
		if( buffOwner != none && H7UnitSnapShot( buffOwner ) != none )
			H7UnitSnapShot( buffOwner ).UpdateSnapShot(false,false);
	}

	effects = container.GetEffectsOfType( 'H7EffectOnStats' );

	foreach effects( effect )
	{
		currentStatMod = H7EffectOnStats( effect ).GetData().mStatMod;

		if( mStatsToModify.Find( currentStatMod.mStat ) != -1 )
		{
			modifier.AddItem( H7EffectOnStats( effect ) );
		}
	}

	return ( modifier.Length > 0 );
}

function String GetTooltipReplacement() 
{
	local string ttMessage;
	ttMessage = class'H7Loca'.static.LocalizeSave("TTR_CHARGE","H7TooltipReplacement");
	ttMessage = Repl(ttMessage, "%value", mValuePerStep);
	ttMessage = Repl(ttMessage, "%statlist", mValuePerStep);

	return ttMessage;
}

function String GetDefaultString()
{
	return String(mValuePerStep);
}

function String GetStatList()
{
	local EStat stat;
	local String list;
	local int i;

	list = "";

	foreach mStatsToModify(stat,i)
	{
		list = list $ (i>0?", ":"") $ class'H7EffectContainer'.static.GetLocaNameForStat(stat,false);
	}

	return list;
}

