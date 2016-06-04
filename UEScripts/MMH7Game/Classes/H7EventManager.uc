//=============================================================================
// H7EventManager
//
// - 
//
// Copyright 2002-2015 Limbic Entertainment All Rights Reserved.
//=============================================================================
class H7EventManager extends Object
	savegame
	native;

var protected ETrigger mCurrentEvent;






var array<delegate<OnOnSelfActivate> > OnSelfActivate;                 // When Ability/Spell is klicked
var array<delegate<OnOnAnyActivate> > OnAnyActivate;                 // When any Ability/Spell is klicked
var array<delegate<OnOnAfterAnyActivate> > OnAfterAnyActivate;           // When any Ability/Spell is klicked
var array<delegate<OnOnImpact> > OnImpact;               
var array<delegate<OnOnFinish> > OnFinish;
var array<delegate<OnOnInit> > OnInit;
var array<delegate<OnOnGetAttacked> > OnGetAttacked;
var array<delegate<OnOnAnyGetAttacked> > OnAnyGetAttacked;
var array<delegate<OnOnGetDamage> > OnGetDamage; 
var array<delegate<OnOnGetBuffed> > OnGetBuffed;
var array<delegate<OnOnAddBuff> > OnAddBuff;
var array<delegate<OnOnDoDamage> > OnDoDamage;
var array<delegate<OnOnPostDoDamage> > OnPostDoDamage;
var array<delegate<OnOnDoCrit> > OnDoCrit;
var array<delegate<OnOnStartCombat> > OnStartCombat;
var array<delegate<OnOnEndCombat> > OnEndCombat;
var array<delegate<OnOnEndQuickCombat> > OnEndQuickCombat;
var array<delegate<OnOnCombatTurnStart> > OnCombatTurnStart;
var array<delegate<OnOnCombatTurnEnd> > OnCombatTurnEnd;
var array<delegate<OnOnPreRetaliation> > OnPreRetaliation;
var array<delegate<OnOnPostRetaliation> > OnPostRetaliation;
var array<delegate<OnOnUnitTurnStart> > OnUnitTurnStart;
var array<delegate<OnOnUnitTurnEnd> > OnUnitTurnEnd;
var array<delegate<OnOnBeginOfDay> > OnBeginOfDay;
var array<delegate<OnOnEndOfDay> > OnEndOfDay;
var array<delegate<OnOnBeginOfWeek> > OnBeginOfWeek;
var array<delegate<OnOnEndOfWeek> > OnEndOfWeek;
var array<delegate<OnOnCreatureDie> > OnCreatureDie;
var array<delegate<OnOnAnyCreatureDie> > OnAnyCreatureDie;
var array<delegate<OnOnKillCreature> > OnKillCreature;
var array<delegate<OnOnEndOfEveryCreaturesTurn> > OnEndOfEveryCreaturesTurn;
var array<delegate<OnOnBeginOfEveryUnitsTurn> > OnBeginOfEveryUnitsTurn;
var array<delegate<OnOnGoodLuck> > OnGoodLuck;
var array<delegate<OnOnBadLuck> > OnBadLuck;
var array<delegate<OnOnGoodMoral> > OnGoodMoral;
var array<delegate<OnOnAnyGoodMoral> > OnAnyGoodMoral;
var array<delegate<OnOnBadMoral> > OnBadMoral;
var array<delegate<OnOnDoAttack> > OnDoAttack;
var array<delegate<OnOnMoralTurnStart> > OnMoralTurnStart;
var array<delegate<OnOnMoralTurnEnd> > OnMoralTurnEnd;
var array<delegate<OnOnGetImpact> > OnGetImpact;
var array<delegate<OnOnWaveImpact> > OnWaveImpact;
var array<delegate<OnOnMoveAttackStart> > OnMoveAttackStart;
var array<delegate<OnOnPreCommand> > OnPreCommand;
var array<delegate<OnOnPostCommand> > OnPostCommand;
var array<delegate<OnOnBuffExpire> > OnBuffExpire;
var array<delegate<OnOnAbilityPrepare> > OnAbilityPrepare;
var array<delegate<OnOnAbilityUnprepare> > OnAbilityUnprepare;
var array<delegate<OnOnAuraInit> > OnAuraInit;
var array<delegate<OnOnAuraDestroy> > OnAuraDestroy;
var array<delegate<OnOnApplyAura> > OnApplyAura;
var array<delegate<OnOnRemoveAura> > OnRemoveAura;
var array<delegate<OnOnEnterCell> > OnEnterCell;
var array<delegate<OnOnLeaveCell> > OnLeaveCell;
var array<delegate<OnOnBuildingBuilt> > OnBuildingBuilt;
var array<delegate<OnOnBuildingDestroy> > OnBuildingDestroy;
var array<delegate<OnOnBuildingChangeOwner> > OnBuildingChangeOwner;
var array<delegate<OnOnGovernorAssign> > OnGovernorAssign;
var array<delegate<OnOnGovernorUnassign> > OnGovernorUnassign;
var array<delegate<OnOnVisit> > OnVisit;
var array<delegate<OnOnPostVisit> > OnPostVisit;
var array<delegate<OnOnLeave> > OnLeave;
var array<delegate<OnOnMeet> > OnMeet;
var array<delegate<OnOnAnyActivateByAny> > OnAnyActivateByAny;
var array<delegate<OnOnMove> > OnMove;
var array<delegate<OnOnHeroDie> > OnHeroDie;
var array<delegate<OnOnBuildingConquered> > OnBuildingConquered;
var array<delegate<OnOnGetTargeted> > OnGetTargeted;
var array<delegate<OnOnTargetAbilityActivated> > OnTargetAbilityActivated;
var array<delegate<OnOnPrePostCommand> > OnPrePostCommand;
var array<delegate<OnOnBattleWon> > OnBattleWon;
var array<delegate<OnOnJumpPitch> > OnJumpPitch;
var array<delegate<OnOnDoCriticalDamage> > OnDoCriticalDamage;
var array<delegate<OnOnReceiveItem> > OnReceiveItem;
var array<delegate<OnOnLoseItem> > OnLoseItem;
var array<delegate<OnOnConsumeItem> > OnConsumeItem;
var array<delegate<OnOnGridPositionChanged> > OnGridPositionChanged;
var array<delegate<OnOnAnyCreatureMove> > OnAnyCreatureMove;
var array<delegate<OnOnSkillLevelUp> > OnSkillLevelUp;
var array<delegate<OnOnMagicSynergyTriggered> > OnMagicSynergyTriggered;
var array<delegate<OnOnCombatXPGain> > OnCombatXPGain;
var array<delegate<OnOnAfterXPGain> > OnAfterXPGain;
var array<delegate<OnOnOpenTresureChest> > OnOpenTresureChest;
var array<delegate<OnOnCloseTresureChest> > OnCloseTresureChest;
var array<delegate<OnOnEquipItem> > OnEquipItem;
var array<delegate<OnOnUnequipItem> > OnUnequipItem;
var array<delegate<OnOnTriggerRetaliation> > OnTriggerRetaliation;
var array<delegate<OnOnEmbark> > OnEmbark;
var array<delegate<OnOnDisembark> > OnDisembark;
var array<delegate<OnOnSummonEnter> > OnSummonEnter;
var array<delegate<OnOnHeroRecruit> > OnHeroRecruit;
var array<delegate<OnOnPassThrough> > OnPassThrough;
var array<delegate<OnOnLordConquered> > OnLordConquered;
var array<delegate<OnOnPreNextCommand> > OnPreNextCommand;
var array<delegate<OnOnOtherBuildingBuilt> > OnOtherBuildingBuilt;
var array<delegate<OnOnPostBuildingProduction> > OnPostBuildingProduction;
var array<delegate<OnOnCaravanCreated> > OnCaravanCreated;
var array<delegate<OnOnAfterBuffAdd> > OnAfterBuffAdd;

simulated delegate OnOnSelfActivate(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnSelfActivate> handler; 
local array<delegate<OnOnSelfActivate> > localCopy; 
localCopy=OnSelfActivate;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAnyActivate(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAnyActivate> handler; 
local array<delegate<OnOnAnyActivate> > localCopy; 
localCopy=OnAnyActivate;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAfterAnyActivate(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAfterAnyActivate> handler; 
local array<delegate<OnOnAfterAnyActivate> > localCopy; 
localCopy=OnAfterAnyActivate;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBeginOfDay(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBeginOfDay> handler; 
local array<delegate<OnOnBeginOfDay> > localCopy; 
localCopy=OnBeginOfDay;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEndOfDay(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEndOfDay> handler; 
local array<delegate<OnOnEndOfDay> > localCopy; 
localCopy=OnEndOfDay;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnUnitTurnStart(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnUnitTurnStart> handler; 
local array<delegate<OnOnUnitTurnStart> > localCopy; 
localCopy=OnUnitTurnStart;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnUnitTurnEnd(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnUnitTurnEnd> handler; 
local array<delegate<OnOnUnitTurnEnd> > localCopy; 
localCopy=OnUnitTurnEnd;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnDoCrit(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnDoCrit> handler; 
local array<delegate<OnOnDoCrit> > localCopy; 
localCopy=OnDoCrit;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnCombatTurnStart(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnCombatTurnStart> handler; 
local array<delegate<OnOnCombatTurnStart> > localCopy; 
localCopy=OnCombatTurnStart;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnCombatTurnEnd(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnCombatTurnEnd> handler; 
local array<delegate<OnOnCombatTurnEnd> > localCopy; 
localCopy=OnCombatTurnEnd;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPreRetaliation(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPreRetaliation> handler; 
local array<delegate<OnOnPreRetaliation> > localCopy; 
localCopy=OnPreRetaliation;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPostRetaliation(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPostRetaliation> handler; 
local array<delegate<OnOnPostRetaliation> > localCopy; 
localCopy=OnPostRetaliation;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnImpact(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnImpact> handler; 
local array<delegate<OnOnImpact> > localCopy; 
localCopy=OnImpact;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnFinish(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnFinish> handler; 
local array<delegate<OnOnFinish> > localCopy; 
localCopy=OnFinish;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGetAttacked(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGetAttacked> handler; 
local array<delegate<OnOnGetAttacked> > localCopy; 
localCopy=OnGetAttacked;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAnyGetAttacked(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAnyGetAttacked> handler; 
local array<delegate<OnOnAnyGetAttacked> > localCopy; 
localCopy=OnAnyGetAttacked;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGetDamage(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGetDamage> handler; 
local array<delegate<OnOnGetDamage> > localCopy; 
localCopy=OnGetDamage;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnDoDamage(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnDoDamage> handler; 
local array<delegate<OnOnDoDamage> > localCopy; 
localCopy=OnDoDamage;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPostDoDamage(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPostDoDamage> handler; 
local array<delegate<OnOnPostDoDamage> > localCopy; 
localCopy=OnPostDoDamage;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnInit(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnInit> handler; 
local array<delegate<OnOnInit> > localCopy; 
localCopy=OnInit;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGetBuffed(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGetBuffed> handler; 
local array<delegate<OnOnGetBuffed> > localCopy; 
localCopy=OnGetBuffed;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAddBuff(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAddBuff> handler; 
local array<delegate<OnOnAddBuff> > localCopy; 
localCopy=OnAddBuff;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnStartCombat(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnStartCombat> handler; 
local array<delegate<OnOnStartCombat> > localCopy; 
localCopy=OnStartCombat;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEndCombat(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEndCombat> handler; 
local array<delegate<OnOnEndCombat> > localCopy; 
localCopy=OnEndCombat;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEndQuickCombat(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEndQuickCombat> handler; 
local array<delegate<OnOnEndQuickCombat> > localCopy; 
localCopy=OnEndQuickCombat;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBeginOfWeek(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBeginOfWeek> handler; 
local array<delegate<OnOnBeginOfWeek> > localCopy; 
localCopy=OnBeginOfWeek;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEndOfWeek(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEndOfWeek> handler; 
local array<delegate<OnOnEndOfWeek> > localCopy; 
localCopy=OnEndOfWeek;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnCreatureDie(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnCreatureDie> handler; 
local array<delegate<OnOnCreatureDie> > localCopy; 
localCopy=OnCreatureDie;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
; 
simulated delegate OnOnAnyCreatureDie(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAnyCreatureDie> handler; 
local array<delegate<OnOnAnyCreatureDie> > localCopy; 
localCopy=OnAnyCreatureDie;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
; 
simulated delegate OnOnKillCreature(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnKillCreature> handler; 
local array<delegate<OnOnKillCreature> > localCopy; 
localCopy=OnKillCreature;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEndOfEveryCreaturesTurn(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEndOfEveryCreaturesTurn> handler; 
local array<delegate<OnOnEndOfEveryCreaturesTurn> > localCopy; 
localCopy=OnEndOfEveryCreaturesTurn;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBeginOfEveryUnitsTurn(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBeginOfEveryUnitsTurn> handler; 
local array<delegate<OnOnBeginOfEveryUnitsTurn> > localCopy; 
localCopy=OnBeginOfEveryUnitsTurn;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGoodLuck(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGoodLuck> handler; 
local array<delegate<OnOnGoodLuck> > localCopy; 
localCopy=OnGoodLuck;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBadLuck(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBadLuck> handler; 
local array<delegate<OnOnBadLuck> > localCopy; 
localCopy=OnBadLuck;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGoodMoral(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGoodMoral> handler; 
local array<delegate<OnOnGoodMoral> > localCopy; 
localCopy=OnGoodMoral;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAnyGoodMoral(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAnyGoodMoral> handler; 
local array<delegate<OnOnAnyGoodMoral> > localCopy; 
localCopy=OnAnyGoodMoral;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBadMoral(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBadMoral> handler; 
local array<delegate<OnOnBadMoral> > localCopy; 
localCopy=OnBadMoral;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnDoAttack(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnDoAttack> handler; 
local array<delegate<OnOnDoAttack> > localCopy; 
localCopy=OnDoAttack;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnMoralTurnStart(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnMoralTurnStart> handler; 
local array<delegate<OnOnMoralTurnStart> > localCopy; 
localCopy=OnMoralTurnStart;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnMoralTurnEnd(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnMoralTurnEnd> handler; 
local array<delegate<OnOnMoralTurnEnd> > localCopy; 
localCopy=OnMoralTurnEnd;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGetImpact(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGetImpact> handler; 
local array<delegate<OnOnGetImpact> > localCopy; 
localCopy=OnGetImpact;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnWaveImpact(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnWaveImpact> handler; 
local array<delegate<OnOnWaveImpact> > localCopy; 
localCopy=OnWaveImpact;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnMoveAttackStart(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnMoveAttackStart> handler; 
local array<delegate<OnOnMoveAttackStart> > localCopy; 
localCopy=OnMoveAttackStart;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPreCommand(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPreCommand> handler; 
local array<delegate<OnOnPreCommand> > localCopy; 
localCopy=OnPreCommand;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPostCommand(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPostCommand> handler; 
local array<delegate<OnOnPostCommand> > localCopy; 
localCopy=OnPostCommand;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBuffExpire(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBuffExpire> handler; 
local array<delegate<OnOnBuffExpire> > localCopy; 
localCopy=OnBuffExpire;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAbilityPrepare(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAbilityPrepare> handler; 
local array<delegate<OnOnAbilityPrepare> > localCopy; 
localCopy=OnAbilityPrepare;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAbilityUnprepare(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAbilityUnprepare> handler; 
local array<delegate<OnOnAbilityUnprepare> > localCopy; 
localCopy=OnAbilityUnprepare;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAuraInit(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAuraInit> handler; 
local array<delegate<OnOnAuraInit> > localCopy; 
localCopy=OnAuraInit;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAuraDestroy(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAuraDestroy> handler; 
local array<delegate<OnOnAuraDestroy> > localCopy; 
localCopy=OnAuraDestroy;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnApplyAura(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnApplyAura> handler; 
local array<delegate<OnOnApplyAura> > localCopy; 
localCopy=OnApplyAura;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnRemoveAura(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnRemoveAura> handler; 
local array<delegate<OnOnRemoveAura> > localCopy; 
localCopy=OnRemoveAura;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEnterCell(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEnterCell> handler; 
local array<delegate<OnOnEnterCell> > localCopy; 
localCopy=OnEnterCell;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnLeaveCell(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnLeaveCell> handler; 
local array<delegate<OnOnLeaveCell> > localCopy; 
localCopy=OnLeaveCell;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBuildingBuilt(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBuildingBuilt> handler; 
local array<delegate<OnOnBuildingBuilt> > localCopy; 
localCopy=OnBuildingBuilt;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBuildingDestroy(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBuildingDestroy> handler; 
local array<delegate<OnOnBuildingDestroy> > localCopy; 
localCopy=OnBuildingDestroy;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBuildingChangeOwner(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBuildingChangeOwner> handler; 
local array<delegate<OnOnBuildingChangeOwner> > localCopy; 
localCopy=OnBuildingChangeOwner;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGovernorAssign(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGovernorAssign> handler; 
local array<delegate<OnOnGovernorAssign> > localCopy; 
localCopy=OnGovernorAssign;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGovernorUnassign(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGovernorUnassign> handler; 
local array<delegate<OnOnGovernorUnassign> > localCopy; 
localCopy=OnGovernorUnassign;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnVisit(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnVisit> handler; 
local array<delegate<OnOnVisit> > localCopy; 
localCopy=OnVisit;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPostVisit(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPostVisit> handler; 
local array<delegate<OnOnPostVisit> > localCopy; 
localCopy=OnPostVisit;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnLeave(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnLeave> handler; 
local array<delegate<OnOnLeave> > localCopy; 
localCopy=OnLeave;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnMeet(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnMeet> handler; 
local array<delegate<OnOnMeet> > localCopy; 
localCopy=OnMeet;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAnyActivateByAny(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAnyActivateByAny> handler; 
local array<delegate<OnOnAnyActivateByAny> > localCopy; 
localCopy=OnAnyActivateByAny;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnMove(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnMove> handler; 
local array<delegate<OnOnMove> > localCopy; 
localCopy=OnMove;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnHeroDie(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnHeroDie> handler; 
local array<delegate<OnOnHeroDie> > localCopy; 
localCopy=OnHeroDie;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBuildingConquered(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBuildingConquered> handler; 
local array<delegate<OnOnBuildingConquered> > localCopy; 
localCopy=OnBuildingConquered;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGetTargeted(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGetTargeted> handler; 
local array<delegate<OnOnGetTargeted> > localCopy; 
localCopy=OnGetTargeted;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnTargetAbilityActivated(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnTargetAbilityActivated> handler; 
local array<delegate<OnOnTargetAbilityActivated> > localCopy; 
localCopy=OnTargetAbilityActivated;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPrePostCommand(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPrePostCommand> handler; 
local array<delegate<OnOnPrePostCommand> > localCopy; 
localCopy=OnPrePostCommand;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnBattleWon(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnBattleWon> handler; 
local array<delegate<OnOnBattleWon> > localCopy; 
localCopy=OnBattleWon;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnJumpPitch(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnJumpPitch> handler; 
local array<delegate<OnOnJumpPitch> > localCopy; 
localCopy=OnJumpPitch;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnDoCriticalDamage(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnDoCriticalDamage> handler; 
local array<delegate<OnOnDoCriticalDamage> > localCopy; 
localCopy=OnDoCriticalDamage;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnReceiveItem(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnReceiveItem> handler; 
local array<delegate<OnOnReceiveItem> > localCopy; 
localCopy=OnReceiveItem;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnLoseItem(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnLoseItem> handler; 
local array<delegate<OnOnLoseItem> > localCopy; 
localCopy=OnLoseItem;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnConsumeItem(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnConsumeItem> handler; 
local array<delegate<OnOnConsumeItem> > localCopy; 
localCopy=OnConsumeItem;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnGridPositionChanged(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnGridPositionChanged> handler; 
local array<delegate<OnOnGridPositionChanged> > localCopy; 
localCopy=OnGridPositionChanged;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAnyCreatureMove(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAnyCreatureMove> handler; 
local array<delegate<OnOnAnyCreatureMove> > localCopy; 
localCopy=OnAnyCreatureMove;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnSkillLevelUp(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnSkillLevelUp> handler; 
local array<delegate<OnOnSkillLevelUp> > localCopy; 
localCopy=OnSkillLevelUp;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnMagicSynergyTriggered(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnMagicSynergyTriggered> handler; 
local array<delegate<OnOnMagicSynergyTriggered> > localCopy; 
localCopy=OnMagicSynergyTriggered;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnCombatXPGain(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnCombatXPGain> handler; 
local array<delegate<OnOnCombatXPGain> > localCopy; 
localCopy=OnCombatXPGain;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnOpenTresureChest(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnOpenTresureChest> handler; 
local array<delegate<OnOnOpenTresureChest> > localCopy; 
localCopy=OnOpenTresureChest;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnCloseTresureChest(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnCloseTresureChest> handler; 
local array<delegate<OnOnCloseTresureChest> > localCopy; 
localCopy=OnCloseTresureChest;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAfterXPGain(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAfterXPGain> handler; 
local array<delegate<OnOnAfterXPGain> > localCopy; 
localCopy=OnAfterXPGain;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEquipItem(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEquipItem> handler; 
local array<delegate<OnOnEquipItem> > localCopy; 
localCopy=OnEquipItem;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnUnequipItem(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnUnequipItem> handler; 
local array<delegate<OnOnUnequipItem> > localCopy; 
localCopy=OnUnequipItem;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnTriggerRetaliation(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnTriggerRetaliation> handler; 
local array<delegate<OnOnTriggerRetaliation> > localCopy; 
localCopy=OnTriggerRetaliation;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnEmbark(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnEmbark> handler; 
local array<delegate<OnOnEmbark> > localCopy; 
localCopy=OnEmbark;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnDisembark(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnDisembark> handler; 
local array<delegate<OnOnDisembark> > localCopy; 
localCopy=OnDisembark;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnSummonEnter(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnSummonEnter> handler; 
local array<delegate<OnOnSummonEnter> > localCopy; 
localCopy=OnSummonEnter;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnHeroRecruit(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnHeroRecruit> handler; 
local array<delegate<OnOnHeroRecruit> > localCopy; 
localCopy=OnHeroRecruit;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPassThrough(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPassThrough> handler; 
local array<delegate<OnOnPassThrough> > localCopy; 
localCopy=OnPassThrough;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnLordConquered(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnLordConquered> handler; 
local array<delegate<OnOnLordConquered> > localCopy; 
localCopy=OnLordConquered;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPreNextCommand(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPreNextCommand> handler; 
local array<delegate<OnOnPreNextCommand> > localCopy; 
localCopy=OnPreNextCommand;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnOtherBuildingBuilt(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnOtherBuildingBuilt> handler; 
local array<delegate<OnOnOtherBuildingBuilt> > localCopy; 
localCopy=OnOtherBuildingBuilt;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnPostBuildingProduction(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnPostBuildingProduction> handler; 
local array<delegate<OnOnPostBuildingProduction> > localCopy; 
localCopy=OnPostBuildingProduction;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnCaravanCreated(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnCaravanCreated> handler; 
local array<delegate<OnOnCaravanCreated> > localCopy; 
localCopy=OnCaravanCreated;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;
simulated delegate OnOnAfterBuffAdd(object sender, bool arg1, H7EventContainerStruct arg2 ) 
{ 
local delegate<OnOnAfterBuffAdd> handler; 
local array<delegate<OnOnAfterBuffAdd> > localCopy; 
localCopy=OnAfterBuffAdd;
foreach localCopy(handler) 
{ 
handler(sender, arg1, arg2); 
} 
}
;

native function OnOnSelfActivateNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAnyActivateNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAfterAnyActivateNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBeginOfDayNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEndOfDayNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnUnitTurnStartNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnUnitTurnEndNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnDoCritNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnCombatTurnStartNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnCombatTurnEndNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPreRetaliationNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPostRetaliationNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnImpactNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnFinishNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGetAttackedNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAnyGetAttackedNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGetDamageNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnDoDamageNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPostDoDamageNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnInitNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGetBuffedNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAddBuffNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnStartCombatNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEndCombatNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEndQuickCombatNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBeginOfWeekNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEndOfWeekNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnCreatureDieNative (object sender, bool arg1, H7EventContainerStruct arg2 ); 
native function OnOnAnyCreatureDieNative (object sender, bool arg1, H7EventContainerStruct arg2 ); 
native function OnOnKillCreatureNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEndOfEveryCreaturesTurnNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBeginOfEveryUnitsTurnNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGoodLuckNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBadLuckNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGoodMoralNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAnyGoodMoralNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBadMoralNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnDoAttackNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnMoralTurnStartNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnMoralTurnEndNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGetImpactNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnWaveImpactNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnMoveAttackStartNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPreCommandNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPostCommandNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBuffExpireNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAbilityPrepareNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAbilityUnprepareNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAuraInitNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAuraDestroyNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnApplyAuraNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnRemoveAuraNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEnterCellNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnLeaveCellNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBuildingBuiltNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBuildingDestroyNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBuildingChangeOwnerNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGovernorAssignNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGovernorUnassignNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnVisitNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPostVisitNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnLeaveNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnMeetNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAnyActivateByAnyNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnMoveNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnHeroDieNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBuildingConqueredNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGetTargetedNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnTargetAbilityActivatedNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPrePostCommandNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnBattleWonNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnJumpPitchNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnDoCriticalDamageNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnReceiveItemNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnLoseItemNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnConsumeItemNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnGridPositionChangedNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAnyCreatureMoveNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnSkillLevelUpNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnMagicSynergyTriggeredNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnCombatXPGainNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnOpenTresureChestNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnCloseTresureChestNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAfterXPGainNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEquipItemNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnUnequipItemNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnTriggerRetaliationNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnEmbarkNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnDisembarkNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnSummonEnterNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnHeroRecruitNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPassThroughNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnLordConqueredNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPreNextCommandNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnOtherBuildingBuiltNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnPostBuildingProductionNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnCaravanCreatedNative (object sender, bool arg1, H7EventContainerStruct arg2 );
native function OnOnAfterBuffAddNative (object sender, bool arg1, H7EventContainerStruct arg2 );

function ETrigger GetCurrentEvent() { return mCurrentEvent; }

function DebugLogSelf(optional H7EventContainerStruct container)
{
	local array<ESpellTag> tags;
	local int i;

	;

	if( container.Targetable != none )
		;
	else
		;

	;

	if( container.EffectContainer != none )
		;
	else
		;

	;
	;
	;
	if( container.ActionTag.Length == 0 )
		;
	else
	{
		tags = container.ActionTag;
		for( i=0; i<tags.Length; ++i )
			;
	}
	;
	;
	if( container.Result != none )
		container.Result.DebugLogSelf(true);
	else
		;
} 

// Events
native function Raise(ETrigger event,bool simulate, optional H7EventContainerStruct container);

native function RegisterListener(H7Effect effect, ETrigger event);

native function  UnregisterListener(H7Effect effect, ETrigger event);

native function UnregisterAll( H7Effect effect );

native function UnregisterBySource(H7EffectContainer container, optional ETrigger event = ETrigger_MAX );
