/*=============================================================================
 * H7SeqAct_ModHeroBuffs
 * ============================================================================
 * Copyright 2013-2015 Limbic Entertainment All Rights Reserved.
 * ============================================================================
 */
class H7SeqAct_ModHeroBuffs extends H7SeqAct_ManipulateHero
	native;

// Adding or removing buffs
var(Properties) EBuffsMod                   mBuffOperation<DisplayName="Buff operation">;
// The buffs that are added or removed
var(Properties) archetype array<H7BaseBuff> mBuffs<DisplayName="Buffs">;

var protected H7AdventureMapGridController	mGridController;


function Activated()
{
	local H7AdventureArmy army;
	local H7AdventureHero hero;
	local H7BaseBuff buff;
	local array<H7BaseBuff> buffs;
	

	if( mGridController == none )
	{
		mGridController = class'H7AdventureGridManager'.static.GetInstance().GetCurrentGrid();
	}

	army = GetTargetArmy();

	if(army != none)
	{
		hero = army.GetHero();
		
		if(hero != none)
		{
			if ( mBuffOperation == EBM_ADD )
			{
				foreach mBuffs( buff )
				{
					hero.GetBuffManager().AddBuff( buff, mGridController );
				}
			}
			else
			{
				if( mBuffOperation == EBM_REMOVE_ALL )
				{
					 hero.GetBuffManager().GetActiveBuffs( buffs );
				}
				else 
				{
					buffs = mBuffs;
				}

				foreach buffs( buff )
				{
					hero.GetBuffManager().RemoveBuff( buff );
				}
			}
		}
	}
}

static event int GetObjClassVersion()
{
	return Super.GetObjClassVersion() + 3;
}

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

