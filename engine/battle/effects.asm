JumpMoveEffect:
	call _JumpMoveEffect
	ld b, $1
	ret

_JumpMoveEffect:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .next1
	ld a, [wEnemyMoveEffect]
.next1
	dec a ; subtract 1, there is no special effect for 00
	add a ; x2, 16bit pointers
	ld hl, MoveEffectPointerTable
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl ; jump to special effect handler

INCLUDE "data/moves/effects_pointers.asm"

SleepEffect:
	ld de, wEnemyMonType2
	ld bc, wEnemyBattleStatus2
	ld hl, wPlayerMoveType
	ldh a, [hWhoseTurn]
	and a
	jp z, .sleepEffect
	ld de, wBattleMonType2
	ld bc, wPlayerBattleStatus2
	ld hl, wEnemyMoveType
.sleepEffect
	call CheckTargetSubstitute ; test bit 4 of d063/d068 flags [target has substitute flag]
	jr nz, .didntAffect; jump if they have a substitute, can't effect them
	ld a, [hl]   ; if using a grass move, check if target is grass type
	cp GRASS
	jr nz, .notGrass
	ld l, a
	ld a, [de]
	cp l
	jp z, PrintDoesntAffectText
	dec de
	ld a, [de]
	cp l
	jp z, PrintDoesntAffectText
	inc de
.notGrass
	dec de
	dec de
	ld a, [de] ; dont check recharge if already statused
	and a
	jr nz, .skipRecharge
	ld a, [bc]
	bit NEEDS_TO_RECHARGE, a ; does the target need to recharge? (hyper beam)
	res NEEDS_TO_RECHARGE, a ; target no longer needs to recharge
	ld [bc], a
	jr nz, .setSleepCounter ; if the target had to recharge, all hit tests will be skipped
.skipRecharge
	ld a, [de]
	ld b, a
	and $7
	jr z, .notAlreadySleeping ; can't affect a mon that is already asleep
	ld hl, AlreadyAsleepText
	jp PrintText
.notAlreadySleeping
	ld a, b
	and a
	jr nz, .didntAffect ; can't affect a mon that is already statused
	push de
	call MoveHitTest ; apply accuracy tests
	pop de
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
.setSleepCounter
; set target's sleep counter to a random number between 1 and 7
	ld a, [wIsTrainerBattle]
	and a
	ld a, $7
	jr z, .wild
	ld a, $3
.wild
	ld b, a
.sleepLoop
	call BattleRandom
	and b
	jr z, .sleepLoop
	ld [de], a
	call PlayCurrentMoveAnimation2
	ld hl, FellAsleepText
	jp PrintText
.didntAffect
	jp PrintDidntAffectText

FellAsleepText:
	text_far _FellAsleepText
	text_end

AlreadyAsleepText:
	text_far _AlreadyAsleepText
	text_end

PoisonEffect:
	ld hl, wEnemyMonStatus
	ld de, wPlayerMoveNum
	ldh a, [hWhoseTurn]
	and a
	jr z, .poisonEffect
	ld hl, wBattleMonStatus
	ld de, wEnemyMoveNum
.poisonEffect
	call CheckTargetSubstitute
	jp nz, .noEffect ; can't poison a substitute target
	ld a, [hli]
	ld b, a
	and a
	jp nz, .noEffect ; miss if target is already statused
	ld a, [hli]
	cp POISON ; can't poison a poison-type target
	jp z, .noEffect
	ld a, [hld]
	cp POISON ; can't poison a poison-type target
	jp z, .noEffect
	ld a, [de]
	inc de
	cp POISONPOWDER
	jr nz, .notPoisonPowder
	ld a, [hli]
	cp GRASS
	jp z, .noEffect
	ld a, [hld]
	cp GRASS
	jp z, .noEffect
.notPoisonPowder
	ld a, [de]
	cp POISON_SIDE_EFFECT1
	ld b, 20 percent + 1 ; chance of poisoning
	jr z, .sideEffectTest
	cp POISON_SIDE_EFFECT2
	ld b, 40 percent + 1 ; chance of poisoning
	jr z, .sideEffectTest
	dec de
	ld a, [de]
	inc de
	cp TOXIC
	jp nz, .notToxic
	ld bc, wBattleMonType1
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerTurn
	ld bc, wEnemyMonType1
.playerTurn
	ld a, [bc]
	cp POISON ; if poison type, toxic has perfect accuracy
	jr z, .inflictPoison
	inc bc
	ld a, [bc]
	cp POISON
	jr z, .inflictPoison
.notToxic
	push hl
	push de
	call MoveHitTest ; apply accuracy tests
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
	jr .inflictPoison
.sideEffectTest
	call BattleRandom
	cp b ; was side effect successful?
	ret nc
.inflictPoison
	dec hl
	set 3, [hl] ; mon is now poisoned
	push de
	dec de
	push hl
	ldh a, [hWhoseTurn]
	and a
	ld b, ANIM_C7
	ld hl, wPlayerBattleStatus3
	ld a, [de]
	ld de, wPlayerToxicCounter
	jr nz, .ok
	ld b, ANIM_A9
	ld hl, wEnemyBattleStatus3
	ld de, wEnemyToxicCounter
.ok
	cp POISON_FANG
	jr z, .toxicPoison
	cp TOXIC
	jr nz, .normalPoison ; done if move is not Toxic
.toxicPoison	
	set BADLY_POISONED, [hl] ; else set Toxic battstatus
	pop hl 
	set BADLY_POISONED_STATUS, [hl] ;set toxic in status so it is saved when switching out
	xor a
	ld [de], a
	ld hl, BadlyPoisonedText
	jr .continue
.normalPoison
	pop hl
	ld hl, PoisonedText
.continue
	pop de
	ld a, [de]
	cp POISON_EFFECT
	jr z, .regularPoisonEffect
	ld a, b
	call PlayBattleAnimation2
	jp PrintText
.regularPoisonEffect
	call PlayCurrentMoveAnimation2
	jp PrintText
.noEffect
	ld a, [de]
	cp POISON_EFFECT
	ret nz
.didntAffect
	ld c, 50
	call DelayFrames
	jp PrintDidntAffectText

PoisonedText:
	text_far _PoisonedText
	text_end

BadlyPoisonedText:
	text_far _BadlyPoisonedText
	text_end

DrainHPEffect:
	jpfar DrainHPEffect_

ExplodeEffect:
	ld hl, wBattleMonHP
	ld de, wPlayerBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .faintUser
	ld hl, wEnemyMonHP
	ld de, wEnemyBattleStatus2
.faintUser
	xor a
	ld [hli], a ; set the mon's HP to 0
	ld [hli], a
	inc hl
	ld [hl], a ; set mon's status to 0
	ld a, [de]
	res SEEDED, a ; clear mon's leech seed status
	ld [de], a
	ret


TriAttackEffect:
	ld bc, wPlayerMoveEffect
	ld hl, wPlayerMoveType
	ldh a, [hWhoseTurn]
	and a
	jr z, .getEffect
	ld bc, wEnemyMoveEffect
	ld hl, wEnemyMoveType
.getEffect
	call BattleRandom
	cp $39
	jr c, .burn
	cp $72
	jr c, .freeze
	cp $AB
	ret nc
	ld a, PARALYZE_SIDE_EFFECT2 ;.paralyze
	ld [bc], a
	ld a, ELECTRIC
	ld [hl], a
.next
	push bc
	push hl
	call FreezeBurnParalyzeEffect
	pop hl 
	pop bc
	ld a, TRI_ATTACK_EFFECT
	ld [bc], a
	ld a, NORMAL
	ld [hl], a
	ret
.burn
	ld a, BURN_SIDE_EFFECT2 
	ld [bc], a
	ld a, FIRE
	ld [hl], a
	jr .next
.freeze
	ld a, FREEZE_SIDE_EFFECT2 
	ld [bc], a
	ld a, ICE
	ld [hl], a
	jr .next
	
ElementalPunchEffect:
FreezeBurnParalyzeEffect:
	xor a
	ld [wAnimationType], a
	call CheckTargetSubstitute ; test bit 4 of d063/d068 flags [target has substitute flag]
	ret nz ; return if they have a substitute, can't effect them
	ldh a, [hWhoseTurn]
	and a
	jp nz, .opponentAttacker
	ld a, [wEnemyMonStatus]
	and a
	jp nz, CheckDefrost ; can't inflict status if opponent is already statused
	ld a, [wPlayerMoveType]
	cp NORMAL
	jr z, .normalMove
	cp FLYING
	jr z, .normalMove
	ld b, a
	ld a, [wEnemyMonType1]
	cp b ; do target type 1 and move type match?
	ret z  ; return if they match (an ice move can't freeze an ice-type, body slam can't paralyze a normal-type, etc.)
	ld a, [wEnemyMonType2]
	cp b ; do target type 2 and move type match?
	ret z  ; return if they match
.normalMove	
	ld a, [wPlayerMoveEffect]
	cp PHYS_PARALYZE_SIDE_EFFECT1
	jr nz, .checkIcePunch
	ld a, PARALYZE_SIDE_EFFECT1
.checkIcePunch
	cp PHYS_FREEZE_SIDE_EFFECT 
	jr nz, .checkFirePunch
	ld a, FREEZE_SIDE_EFFECT
.checkFirePunch
	cp PHYS_BURN_SIDE_EFFECT1
	jr nz, .checkChance
	ld a, BURN_SIDE_EFFECT1
.checkChance
	cp PARALYZE_SIDE_EFFECT1 + 1
	ld b, 10 percent + 1
	jr c, .regular_effectiveness
; extra effectiveness
	ld b, 30 percent + 1
	sub BURN_SIDE_EFFECT2 - BURN_SIDE_EFFECT1 ; treat extra effective as regular from now on
.regular_effectiveness
	push af
	call BattleRandom ; get random 8bit value for probability test
	cp b
	pop bc
	ret nc ; do nothing if random value is >= 1A or 4D [no status applied]
	ld a, b ; what type of effect is this?
	cp BURN_SIDE_EFFECT1
	jr z, .burn1
	cp FREEZE_SIDE_EFFECT
	jr z, .freeze1
; .paralyze1
	ld a, 1 << PAR
	ld [wEnemyMonStatus], a
	call QuarterSpeedDueToParalysis ; quarter speed of affected mon
	ld a, ANIM_A9
	call PlayBattleAnimation
	jp PrintMayNotAttackText ; print paralysis text
.burn1
	ld a, 1 << BRN
	ld [wEnemyMonStatus], a
	ld a, ANIM_A9
	call PlayBattleAnimation
	ld hl, BurnedText
	jp PrintText
.freeze1
	call ClearHyperBeam ; resets hyper beam (recharge) condition from target
	ld a, 1 << FRZ
	ld [wEnemyMonStatus], a
	ld a, ANIM_A9
	call PlayBattleAnimation
	ld hl, FrozenText
	jp PrintText
.opponentAttacker
	ld a, [wBattleMonStatus] ; mostly same as above with addresses swapped for opponent
	and a
	jp nz, CheckDefrost
	ld a, [wEnemyMoveType]
	cp NORMAL
	jr z, .enemyNormalMove
	cp FLYING
	jr z, .enemyNormalMove
	ld b, a
	ld a, [wBattleMonType1]
	cp b
	ret z
	ld a, [wBattleMonType2]
	cp b
	ret z
.enemyNormalMove
	ld a, [wEnemyMoveEffect]
	cp PHYS_PARALYZE_SIDE_EFFECT1
	jr nz, .checkEnemyIcePunch
	ld a, PARALYZE_SIDE_EFFECT1
.checkEnemyIcePunch
	cp PHYS_FREEZE_SIDE_EFFECT 
	jr nz, .checkEnemyFirePunch
	ld a, FREEZE_SIDE_EFFECT
.checkEnemyFirePunch
	cp PHYS_BURN_SIDE_EFFECT1
	jr nz, .checkEnemyChance
	ld a, BURN_SIDE_EFFECT1
.checkEnemyChance
	cp PARALYZE_SIDE_EFFECT1 + 1
	ld b, 10 percent + 1
	jr c, .regular_effectiveness2
; extra effectiveness
	ld b, 30 percent + 1
	sub BURN_SIDE_EFFECT2 - BURN_SIDE_EFFECT1 ; treat extra effective as regular from now on
.regular_effectiveness2
	push af
	call BattleRandom
	cp b
	pop bc
	ret nc
	ld a, b
	cp BURN_SIDE_EFFECT1
	jr z, .burn2
	cp FREEZE_SIDE_EFFECT
	jr z, .freeze2
; .paralyze2
	ld a, 1 << PAR
	ld [wBattleMonStatus], a
	call QuarterSpeedDueToParalysis
	jp PrintMayNotAttackText
.burn2
	ld a, 1 << BRN
	ld [wBattleMonStatus], a
	ld hl, BurnedText
	jp PrintText
.freeze2
; hyper beam bits are reseted for opponent's side
	call ClearHyperBeam ; resets hyper beam (recharge) condition from target
	ld a, 1 << FRZ
	ld [wBattleMonStatus], a
	ld hl, FrozenText
	jp PrintText

BurnedText:
	text_far _BurnedText
	text_end

FrozenText:
	text_far _FrozenText
	text_end

CheckDefrost:
; any fire-type move that has a chance inflict burn (all but Fire Spin) will defrost a frozen target
	and 1 << FRZ ; are they frozen?
	ret z ; return if so
	ldh a, [hWhoseTurn]
	and a
	jr nz, .opponent
	;player [attacker]
	ld a, [wPlayerMoveType]
	sub FIRE
	ret nz ; return if type of move used isn't fire
	ld [wEnemyMonStatus], a ; set opponent status to 00 ["defrost" a frozen monster]
	ld hl, wEnemyMon1Status
	ld a, [wEnemyMonPartyPos]
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hl], a ; clear status in roster
	ld hl, FireDefrostedText
	jr .common
.opponent
	ld a, [wEnemyMoveType] ; same as above with addresses swapped
	sub FIRE
	ret nz
	ld [wBattleMonStatus], a
	ld hl, wPartyMon1Status
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	xor a
	ld [hl], a
	ld hl, FireDefrostedText
.common
	jp PrintText

FireDefrostedText:
	text_far _FireDefrostedText
	text_end

AncientpowerEffect:
	call BattleRandom
	cp $1A
	ret nc
	ld b, ATTACK_UP1_EFFECT
	ld c, $4
	ld hl, wEnemyMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr nz, .loop
	ld hl, wPlayerMoveEffect
.loop
	ld a, b
	ld [hl], a
	push bc
	push hl
	call StatModifierUpEffect
	pop hl
	pop bc
	inc b
	dec c
	jr nz, .loop
	ret
	
GrowthEffect:
	ld hl, wEnemyMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr nz, .enemy
	ld hl, wPlayerMoveEffect
.enemy
	ld a, ATTACK_UP1_EFFECT
	ld [hl], a
	push hl
	call StatModifierUpEffect
	pop hl
	ld a, SPECIAL_UP1_EFFECT
	ld [hl], a
	jp StatModifierUpEffect
	
StatModifierUpEffect:
	ld hl, wPlayerMonStatMods
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .statModifierUpEffect
	ld hl, wEnemyMonStatMods
	ld de, wEnemyMoveEffect
.statModifierUpEffect
	ld a, [de]
	sub ATTACK_UP1_EFFECT
	cp EVASION_UP1_EFFECT + $3 - ATTACK_UP1_EFFECT ; covers all +1 effects
	jr c, .incrementStatMod
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to equivalent +1 effect
.incrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	inc b ; increment corresponding stat mod
	ld a, $d
	cp b ; can't raise stat past +6 ($d or 13)
	jp c, PrintCantRaiseStatText
	ld a, [de]
	cp ATTACK_UP1_EFFECT + $8 ; is it a +2 effect?
	jr c, .ok
	inc b ; if so, increment stat mod again
	ld a, $d
	cp b ; unless it's already +6
	jr nc, .ok
	ld b, a
.ok
	ld [hl], b
	ld a, c
	cp $4
	jr nc, UpdateStatDone ; jump if mod affected is evasion/accuracy
	push hl
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
	ldh a, [hWhoseTurn]
	and a
	jr z, .pointToStats
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
.pointToStats
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .checkIf999
	inc d ; de = unmodified (original) stat
.checkIf999
	pop bc
	; check if stat is already 999
	ld a, [hld]
	sub LOW(MAX_STAT_VALUE)
	jr nz, .recalculateStat
	ld a, [hl]
	sbc HIGH(MAX_STAT_VALUE)
	jp z, RestoreOriginalStatModifier
.recalculateStat ; recalculate affected stat
                 ; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ldh [hMultiplicand], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply
	ld a, [hl]
	ldh [hDivisor], a
	ld b, $4
	call Divide
	pop hl
; cap at MAX_STAT_VALUE (999)
	ldh a, [hProduct + 3]
	sub LOW(MAX_STAT_VALUE)
	ldh a, [hProduct + 2]
	sbc HIGH(MAX_STAT_VALUE)
	jp c, UpdateStat
	ld a, HIGH(MAX_STAT_VALUE)
	ldh [hMultiplicand + 1], a
	ld a, LOW(MAX_STAT_VALUE)
	ldh [hMultiplicand + 2], a

UpdateStat:
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	pop hl
UpdateStatDone:
	ld b, c
	inc b
	call PrintStatText
	ld hl, wPlayerBattleStatus2
	ld de, wPlayerMoveNum
	ld bc, wPlayerMonMinimized
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerTurn
	ld hl, wEnemyBattleStatus2
	ld de, wEnemyMoveNum
	ld bc, wEnemyMonMinimized
.playerTurn
	ld a, [de]
	cp MINIMIZE
	jr nz, .notMinimize
 ; if a substitute is up, slide off the substitute and show the mon pic before
 ; playing the minimize animation
	bit HAS_SUBSTITUTE_UP, [hl]
	push af
	push bc
	ld hl, HideSubstituteShowMonAnim
	ld b, BANK(HideSubstituteShowMonAnim)
	push de
	call nz, Bankswitch
	pop de
.notMinimize
	ld a, [de]
	push de
	cp SKULL_BASH
	jr z, .applyBadgeBoostsAndStatusPenalties
	cp ANCIENTPOWER
	jr z, .applyBadgeBoostsAndStatusPenalties
	call PlayCurrentMoveAnimation
	ld a, [de]
	cp MINIMIZE
	jr nz, .applyBadgeBoostsAndStatusPenalties
	pop de
	pop bc
	ld a, $1
	ld [bc], a
	ld hl, ReshowSubstituteAnim
	ld b, BANK(ReshowSubstituteAnim)
	pop af
	push de
	call nz, Bankswitch
.applyBadgeBoostsAndStatusPenalties
	pop de
	inc de    ;MoveEffect
	ld a, [de]
	cp ATTACK_UP2_EFFECT
	jr c, .oneStage
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to equivalent +1 effect
.oneStage
	ld [de], a
	push de
	ld a, [wOptions2]
	bit 1, a
	jr z, .skipGlitchFix
	ld b, a
	ldh a, [hWhoseTurn]
	and a
	jr nz, .checkBit
	sla b
.checkBit
	bit 3, b
	jr z, .finishedBadgeBoost
	ld a, [de]
	sub ATTACK_UP1_EFFECT
	cp MOD_ACCURACY
	jr nc, .finishedBadgeBoost
	add a
	ld c, a
	ld b, $0
	ld hl, wBattleMonAttack
	ldh a, [hWhoseTurn]
	and a
	ld a, [wObtainedBadges]
	jr z, .playerTurn2
	ld hl, wEnemyMonAttack
	ld a, [wGymLeaderNo]
	and a
	ld a, [wObtainedBadges]
	jr z, .playerTurn2
	ld a, $ff
.playerTurn2
	add hl, bc
.badgeLoop
	dec c
	jr c, .gotBadges
	srl a
	srl a
	jr .badgeLoop
.gotBadges
	ld b, a
	ld c, $1
	call ApplyBadgeStatBoosts.loop
	jr .finishedBadgeBoost
.skipGlitchFix
	ldh a, [hWhoseTurn]
	and a
	ld a, [wOptions2]
	jr z, .playerBoost
	bit 3, a
	call nz, ApplyBadgeStatBoosts.ApplyToEnemy
	jr .finishedBadgeBoost
.playerBoost
	bit 2, a
	call nz, ApplyBadgeStatBoosts ; whenever the player uses a stat-up move, badge boosts get reapplied again to every stat,
	                             ; even to those not affected by the stat-up move (will be boosted further)
.finishedBadgeBoost
	ldh a, [hWhoseTurn]
	xor $1
	ldh [hWhoseTurn], a
	pop de
	ld a, [de]
	cp SPEED_UP1_EFFECT
	call z, QuarterSpeedDueToParalysis ; apply speed penalty to the player whose turn is not, if it's paralyzed
	ldh a, [hWhoseTurn]
	xor $1
	ldh [hWhoseTurn], a
	ld hl, MonsStatsRoseText
	jp PrintText

; these shouldn't be here
	;and they aren't

RestoreOriginalStatModifier:
	pop hl
	dec [hl]

PrintCantRaiseStatText:
	ld b, c
	inc b
	call PrintStatText
	ld hl, MonsStatsWontRiseText
	jp PrintText

MonsStatsWontRiseText:
	text_far _MonsStatsWontRiseText
	text_end

MonsStatsRoseText:
	text_far _MonsStatsRoseText
	text_asm
	ld hl, GreatlyRoseText
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .playerTurn
	ld a, [wEnemyMoveEffect]
.playerTurn
	cp ATTACK_DOWN1_EFFECT
	ret nc
	ld hl, RoseText
	ret

GreatlyRoseText:
	text_pause
	text_far _GreatlyRoseText
; fallthrough
RoseText:
	text_far _RoseText
	text_end

StatModifierDownEffect:
	ld hl, wEnemyMonStatMods
	ld de, wPlayerMoveEffect
	ld bc, wEnemyBattleStatus1
	ldh a, [hWhoseTurn]
	and a
	jr z, .statModifierDownEffect
	ld hl, wPlayerMonStatMods
	ld de, wEnemyMoveEffect
	ld bc, wPlayerBattleStatus1
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr z, .statModifierDownEffect
.statModifierDownEffect
	call CheckTargetSubstitute ; can't hit through substitute
	jp nz, MoveMissed
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	jr c, .nonSideEffect
	; this is where new stuff starts
	dec de ;wPlayerMoveNum or wEnemyMoveNum
	ld a, [de]
	inc de ;wPlayerMoveEffect or wEnemyMoveEffect
	cp ROCK_TOMB
	jr z, .guaranteed ; skips the random chance if rock tomb
	cp MUD_SHOT
	jr z, .guaranteed ; skips the random chance if mud shot 
	cp THUNDER_KICK
	jr z, .guaranteed
	cp ICY_WIND
	jr z, .guaranteed
	cp ACID_SPRAY
	jr z, .guaranteed
	;end of new stuff mostly
	call BattleRandom
	cp 33 percent + 1 ; chance for side effects
	ret nc
.guaranteed	;this label is also new
	ld a, [de]
	sub ATTACK_DOWN_SIDE_EFFECT ; map each stat to 0-3
	jr .decrementStatMod
.nonSideEffect ; non-side effects only
	push hl
	push de
	push bc
	call MoveHitTest ; apply accuracy tests
	pop bc
	pop de
	pop hl
	ld a, [wMoveMissed]
	and a
	jp nz, MoveMissed
	ld a, [bc]
	bit INVULNERABLE, a ; fly/dig
	jp nz, MoveMissed
	ld a, [de]
	sub ATTACK_DOWN1_EFFECT
	cp EVASION_DOWN1_EFFECT + $3 - ATTACK_DOWN1_EFFECT ; covers all -1 effects
	jr c, .decrementStatMod
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map -2 effects to corresponding -1 effect
.decrementStatMod
	ld c, a
	ld b, $0
	add hl, bc
	ld b, [hl]
	dec b ; dec corresponding stat mod
	jp z, CantLowerAnymore ; if stat mod is 1 (-6), can't lower anymore
	ld a, [de]
	cp ATTACK_DOWN2_EFFECT - $16 ; $24
	jr c, .ok
	cp EVASION_DOWN2_EFFECT + $5 ; $44
	jr nc, .ok
	dec b ; stat down 2 effects only (dec mod again)
	jr nz, .ok
	inc b ; increment mod to 1 (-6) if it would become 0 (-7)
.ok
	ld [hl], b ; save modified mod
	ld a, c
	cp $4
	jr nc, UpdateLoweredStatDone ; jump for evasion/accuracy
	push hl
	push de
	ld hl, wEnemyMonAttack + 1
	ld de, wEnemyMonUnmodifiedAttack
	ldh a, [hWhoseTurn]
	and a
	jr z, .pointToStat
	ld hl, wBattleMonAttack + 1
	ld de, wPlayerMonUnmodifiedAttack
.pointToStat
	push bc
	sla c
	ld b, $0
	add hl, bc ; hl = modified stat
	ld a, c
	add e
	ld e, a
	jr nc, .noCarry
	inc d ; de = unmodified stat
.noCarry
	pop bc
	ld a, [hld]
	sub $1 ; can't lower stat below 1 (-6)
	jr nz, .recalculateStat
	ld a, [hl]
	and a
	jp z, CantLowerAnymore_Pop
.recalculateStat
; recalculate affected stat
; paralysis and burn penalties, as well as badge boosts are ignored
	push hl
	push bc
	ld hl, StatModifierRatios
	dec b
	sla b
	ld c, b
	ld b, $0
	add hl, bc
	pop bc
	xor a
	ldh [hMultiplicand], a
	ld a, [de]
	ldh [hMultiplicand + 1], a
	inc de
	ld a, [de]
	ldh [hMultiplicand + 2], a
	ld a, [hli]
	ldh [hMultiplier], a
	call Multiply
	ld a, [hl]
	ldh [hDivisor], a
	ld b, $4
	call Divide
	pop hl
	ldh a, [hProduct + 3]
	ld b, a
	ldh a, [hProduct + 2]
	or b
	jp nz, UpdateLoweredStat
	ldh [hMultiplicand + 1], a
	ld a, $1
	ldh [hMultiplicand + 2], a

UpdateLoweredStat:
	ldh a, [hProduct + 2]
	ld [hli], a
	ldh a, [hProduct + 3]
	ld [hl], a
	pop de
	pop hl
UpdateLoweredStatDone:
	ld b, c
	inc b
	push de
	call PrintStatText
	pop de
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	jr nc, .ApplyBadgeBoostsAndStatusPenalties
	call PlayCurrentMoveAnimation2
.ApplyBadgeBoostsAndStatusPenalties
	ld a, [de]
	cp ATTACK_DOWN_SIDE_EFFECT
	jr nc, .sideEffect
	cp ATTACK_DOWN2_EFFECT
	jr c, .oneStage
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map +2 effects to equivalent +1 effect
	jr .oneStage
.sideEffect
	sub ATTACK_DOWN_SIDE_EFFECT - ATTACK_DOWN1_EFFECT
.oneStage
	ld [de], a
	push de
	ld a, [wOptions2]
	bit 1, a
	jr z, .skipGlitchFix
	ld b, a
	ldh a, [hWhoseTurn]
	and a
	jr z, .checkBit
	sla b
.checkBit
	bit 3, b
	jr z, .finishedBadgeBoost
	ld a, [de]
	sub ATTACK_DOWN1_EFFECT
	cp MOD_ACCURACY
	jr nc, .finishedBadgeBoost
	add a
	ld c, a
	ld b, $0
	ld hl, wBattleMonAttack
	ldh a, [hWhoseTurn]
	and a
	ld a, [wObtainedBadges]
	jr nz, .playerTurn2
	ld hl, wEnemyMonAttack
	ld a, [wGymLeaderNo]
	and a
	ld a, [wObtainedBadges]
	jr z, .playerTurn2
	ld a, $ff
.playerTurn2
	add hl, bc
	inc c
.badgeLoop
	dec c
	jr z, .gotBadges
	srl a
	srl a
	jr .badgeLoop
.gotBadges
	ld b, a
	ld c, $1
	call ApplyBadgeStatBoosts.loop
	jr .finishedBadgeBoost
.skipGlitchFix
	ldh a, [hWhoseTurn]
	and a
	ld a, [wOptions2]
	jr nz, .playerBoost
	bit 3, a
	call nz, ApplyBadgeStatBoosts.ApplyToEnemy
	jr .finishedBadgeBoost
.playerBoost
	bit 2, a
	call nz, ApplyBadgeStatBoosts ; whenever the player uses a stat-down move, badge boosts get reapplied again to every stat,
	                              ; even to those not affected by the stat-up move (will be boosted further)
.finishedBadgeBoost
	pop de
	ld a, [de]
	cp SPEED_DOWN1_EFFECT
	call z, QuarterSpeedDueToParalysis
	ld hl, MonsStatsFellText
	jp PrintText
	

CantLowerAnymore_Pop:
	pop de
	pop hl
	inc [hl]

CantLowerAnymore:
	ld b, c
	inc b
	call PrintStatText
	ld hl, MonsStatsWontFallText
	jp PrintText

MoveMissed:
	ld a, [de]
	cp $44
	ret nc
	jp ConditionalPrintButItFailed

MonsStatsWontFallText:
	text_far _MonsStatsWontFallText
	text_end

MonsStatsFellText:
	text_far _MonsStatsFellText
	text_asm
	ld hl, FellText
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveEffect]
	jr z, .playerTurn
	ld a, [wEnemyMoveEffect]
.playerTurn
; check if the move's effect decreases a stat by 2
	cp BIDE_EFFECT
	ret c
	cp ATTACK_DOWN_SIDE_EFFECT
	ret nc
	ld hl, GreatlyFellText
	ret

GreatlyFellText:
	text_pause
	text_far _GreatlyFellText
; fallthrough
FellText:
	text_far _FellText
	text_end

PrintStatText:
	ld hl, StatModTextStrings
	ld c, "@"
.findStatName_outer
	dec b
	jr z, .foundStatName
.findStatName_inner
	ld a, [hli]
	cp c
	jr z, .findStatName_outer
	jr .findStatName_inner
.foundStatName
	ld de, wStringBuffer
	ld bc, $a
	jp CopyData

INCLUDE "data/battle/stat_mod_names.asm"

INCLUDE "data/battle/stat_modifiers.asm"

ThrashPetalDanceEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ldh a, [hWhoseTurn]
	and a
	jr z, .thrashPetalDanceEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
.thrashPetalDanceEffect
	set THRASHING_ABOUT, [hl] ; mon is now using thrash/petal dance
	call BattleRandom
	and $1
	inc a
	inc a
	ld [de], a ; set thrash/petal dance counter to 2 or 3 at random
	ldh a, [hWhoseTurn]
	add ANIM_B0
	jp PlayBattleAnimation2

SwitchAndTeleportEffect:
	ldh a, [hWhoseTurn]
	and a
	jp nz, .handleEnemy
	ld a, [wIsInBattle]
	dec a
	jr nz, .notWildBattle1
	ld a, [wCurEnemyLVL]
	ld b, a
	ld a, [wBattleMonLevel]
	cp b ; is the player's level greater than the enemy's level?
	jr nc, .playerMoveWasSuccessful ; if so, teleport will always succeed
	add b
	ld c, a
	inc c ; c = playerLevel + enemyLevel + 1
.rejectionSampleLoop1
	call BattleRandom
	cp c ; get a random number between 0 and c
	jr nc, .rejectionSampleLoop1
	srl b
	srl b  ; b = enemyLevel / 4
	cp b ; is rand[0, playerLevel + enemyLevel] >= (enemyLevel / 4)?
	jr nc, .playerMoveWasSuccessful ; if so, allow teleporting
.playerMoveFailed
	ld c, 50
	call DelayFrames
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp PrintButItFailedText_
.playerMoveWasSuccessful
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wPlayerMoveNum]
	jp .playAnimAndPrintText
.notWildBattle1
	ld a, [wPlayerMoveNum]
	cp TELEPORT
	jp nz, .roarOrWhirlwind
	call AnyPartyAlive
	ld a, d
	cp 2
	jp c, .playerMoveFailed
	ld a, [wPlayerMoveNum]
	call PlayBattleAnimation
	ld c, 20
	call DelayFrames
	call SaveScreenTilesToBuffer1
	jp ChooseNextMon
.roarOrWhirlwind
	callfar AICheckIfEnoughMons
	jr z, .playerMoveFailed
	ld a, [wPlayerMoveNum]
	call PlayBattleAnimation
	ld c, 20
	call DelayFrames
	callfar SwitchEnemyMon
	jp MainInBattleLoop
.handleEnemy
	ld a, [wIsInBattle]
	dec a
	jr nz, .notWildBattle2
	ld a, [wBattleMonLevel]
	ld b, a
	ld a, [wCurEnemyLVL]
	cp b
	jr nc, .enemyMoveWasSuccessful
	add b
	ld c, a
	inc c
.rejectionSampleLoop2
	call BattleRandom
	cp c
	jr nc, .rejectionSampleLoop2
	srl b
	srl b
	cp b
	jr nc, .enemyMoveWasSuccessful
.enemyMoveFailed
	ld c, 50
	call DelayFrames
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, PrintDidntAffectText
	jp PrintButItFailedText_
.enemyMoveWasSuccessful
	call ReadPlayerMonCurHPAndStatus
	xor a
	ld [wAnimationType], a
	inc a
	ld [wEscapedFromBattle], a
	ld a, [wEnemyMoveNum]
	jr .playAnimAndPrintText
.notWildBattle2
	ld a, [wEnemyMoveNum]
	cp TELEPORT
	jp nz, .roarOrWhirlwind2
	callfar AICheckIfEnoughMons
	jr z, .enemyMoveFailed
	ld a, [wEnemyMoveNum]
	call PlayBattleAnimation
	ld c, 20
	call DelayFrames
	jpfar SwitchEnemyMon
.roarOrWhirlwind2
	call AnyPartyAlive
	ld a, d
	cp 2
	jp c, .enemyMoveFailed
	ld a, [wEnemyMoveNum]
	call PlayBattleAnimation
	ld c, 20
	call DelayFrames
.newRandomNumber	
	call BattleRandom
	and $7
	ld b, a
	ld a, [wPartyCount]
	dec a
	cp b
	jr c, .newRandomNumber
	ld a, [wPlayerMonNumber]
	cp b
	jr z, .newRandomNumber
	ld a, b
	ld [wWhichPokemon], a
	call HasMonFainted
	jr z, .newRandomNumber
	ld a, [wWhichPokemon]
	ld hl, wPartySpecies
	ld b, 0
	ld c, a
	add hl, bc
	ld a, [hl]
	ld [wcf91], a
	ld [wBattleMonSpecies2], a
	call SwitchPlayerMonNoAnim
	jp MainInBattleLoop
.playAnimAndPrintText
	push af
	call PlayBattleAnimation
	ld c, 20
	call DelayFrames
	pop af
	ld hl, RanFromBattleText
	cp TELEPORT
	jr z, .printText
	ld hl, RanAwayScaredText
	cp ROAR
	jr z, .printText
	ld hl, WasBlownAwayText
.printText
	jp PrintText

RanFromBattleText:
	text_far _RanFromBattleText
	text_end

RanAwayScaredText:
	text_far _RanAwayScaredText
	text_end

WasBlownAwayText:
	text_far _WasBlownAwayText
	text_end

TwoToFiveAttacksEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld bc, wPlayerNumHits
	ldh a, [hWhoseTurn]
	and a
	jr z, .twoToFiveAttacksEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
	ld bc, wEnemyNumHits
.twoToFiveAttacksEffect
	bit ATTACKING_MULTIPLE_TIMES, [hl] ; is mon attacking multiple times?
	ret nz
	set ATTACKING_MULTIPLE_TIMES, [hl] ; mon is now attacking multiple times
	ld hl, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .setNumberOfHits
	ld hl, wEnemyMoveEffect
.setNumberOfHits
	ld a, [hl]
	cp TWINEEDLE_EFFECT
	jr z, .twineedle
	cp ATTACK_TWICE_EFFECT
	ld a, $2 ; number of hits it's always 2 for ATTACK_TWICE_EFFECT
	jr z, .saveNumberOfHits
; for TWO_TO_FIVE_ATTACKS_EFFECT 3/8 chance for 2 and 3 hits, and 1/8 chance for 4 and 5 hits
	call BattleRandom
	and $3
	cp $2
	jr c, .gotNumHits
; if the number of hits was greater than 2, re-roll again for a lower chance
	call BattleRandom
	and $3
.gotNumHits
	inc a
	inc a
.saveNumberOfHits
	ld [de], a
	ld [bc], a
	ret
.twineedle
	ld a, POISON_SIDE_EFFECT1
	ld [hl], a ; set Twineedle's effect to poison effect
	jr .saveNumberOfHits

FlinchSideEffect:
	call CheckTargetSubstitute
	ret nz
	ld hl, wEnemyBattleStatus1
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	jr z, .flinchSideEffect
	ld hl, wPlayerBattleStatus1
	ld de, wEnemyMoveEffect
.flinchSideEffect
	ld a, [de]
	cp FLINCH_SIDE_EFFECT1
	ld b, 10 percent + 1 ; chance of flinch (FLINCH_SIDE_EFFECT1)
	jr z, .gotEffectChance
	ld b, 30 percent + 1 ; chance of flinch otherwise
.gotEffectChance
	call BattleRandom
	cp b
	ret nc
	set FLINCHED, [hl] ; set mon's status to flinching
	call ClearHyperBeam
	ret

OneHitKOEffect:
	jpfar OneHitKOEffect_

ChargeEffect:
	jpfar ChargeEffect_

TrappingEffect:
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerNumAttacksLeft
	ld bc, wEnemyMonType1
	ldh a, [hWhoseTurn]
	and a
	jr z, .trappingEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyNumAttacksLeft
	ld bc, wBattleMonType1
.trappingEffect
	ld a, [bc] ; check if target is ghost type. If so, skip the trapping effect
	cp GHOST
	ret z
	inc bc
	ld a, [bc]
	cp GHOST
	ret z
	bit USING_TRAPPING_MOVE, [hl]
	ret nz
	call ClearHyperBeam ; since this effect is called before testing whether the move will hit,
                        ; the target won't need to recharge even if the trapping move missed
	set USING_TRAPPING_MOVE, [hl] ; mon is now using a trapping move
	call BattleRandom ; 3/8 chance for 2 and 3 attacks, and 1/8 chance for 4 and 5 attacks
	and $3
	cp $2
	jr c, .setTrappingCounter
	call BattleRandom
	and $3
.setTrappingCounter
	inc a
	ld [de], a
	ret

MistEffect:
	jpfar MistEffect_

FocusEnergyEffect:
	jpfar FocusEnergyEffect_

RecoilEffect:
	jpfar RecoilEffect_

ConfusionSideEffect:
	call CheckTargetSubstitute ; test bit 4 of d063/d068 flags [target has substitute flag]
	ret nz ; return if they have a substitute, can't effect them
	call BattleRandom
	cp 10 percent ; chance of confusion
	ret nc
	jr ConfusionSideEffectSuccess

ConfusionEffect:
	call CheckTargetSubstitute
	jr nz, ConfusionEffectFailed
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, ConfusionEffectFailed

ConfusionSideEffectSuccess:
	ldh a, [hWhoseTurn]
	and a
	ld hl, wEnemyBattleStatus1
	ld bc, wEnemyConfusedCounter
	ld a, [wPlayerMoveEffect]
	jr z, .confuseTarget
	ld hl, wPlayerBattleStatus1
	ld bc, wPlayerConfusedCounter
	ld a, [wEnemyMoveEffect]
.confuseTarget
	bit CONFUSED, [hl] ; is mon confused?
	jr nz, ConfusionEffectFailed
	set CONFUSED, [hl] ; mon is now confused
	push af
	call BattleRandom
	and $3
	inc a
	inc a
	ld [bc], a ; confusion status will last 2-5 turns
	pop af
	cp CONFUSION_SIDE_EFFECT
	call nz, PlayCurrentMoveAnimation2
	ld hl, BecameConfusedText
	jp PrintText

BecameConfusedText:
	text_far _BecameConfusedText
	text_end

ConfusionEffectFailed:
	cp CONFUSION_SIDE_EFFECT
	ret z
	ld c, 50
	call DelayFrames
	jp ConditionalPrintButItFailed

ParalyzeEffect:
	jpfar ParalyzeEffect_

SubstituteEffect:
	jpfar SubstituteEffect_

HyperBeamEffect:
	ld hl, wPlayerBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .hyperBeamEffect
	ld hl, wEnemyBattleStatus2
.hyperBeamEffect
	set NEEDS_TO_RECHARGE, [hl] ; mon now needs to recharge
	ret

ClearHyperBeam:
	push hl
	ld hl, wEnemyBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerTurn
	ld hl, wPlayerBattleStatus2
.playerTurn
	res NEEDS_TO_RECHARGE, [hl] ; mon no longer needs to recharge
	pop hl
	ret

MimicEffect:
	ld c, 50
	call DelayFrames
	call MoveHitTest
	ld a, [wMoveMissed]
	and a
	jr nz, .mimicMissed
	ldh a, [hWhoseTurn]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerBattleStatus1]
	jr nz, .enemyTurn
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	jr nz, .letPlayerChooseMove
	ld hl, wEnemyMonMoves
	ld a, [wEnemyBattleStatus1]
.enemyTurn
	bit INVULNERABLE, a
	jr nz, .mimicMissed
.getRandomMove
	push hl
	call BattleRandom
	and $3
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [hl]
	pop hl
	and a
	jr z, .getRandomMove
	ld d, a
	ldh a, [hWhoseTurn]
	and a
	ld hl, wBattleMonMoves
	ld a, [wPlayerMoveListIndex]
	jr z, .playerTurn
	ld hl, wEnemyMonMoves
	ld a, [wEnemyMoveListIndex]
	jr .playerTurn
.letPlayerChooseMove
	ld a, [wEnemyBattleStatus1]
	bit INVULNERABLE, a
	jr nz, .mimicMissed
	ld a, [wCurrentMenuItem]
	push af
	ld a, $1
	ld [wMoveMenuType], a
	call MoveSelectionMenu
	call LoadScreenTilesFromBuffer1
	ld hl, wEnemyMonMoves
	ld a, [wCurrentMenuItem]
	ld c, a
	ld b, $0
	add hl, bc
	ld d, [hl]
	pop af
	ld hl, wBattleMonMoves
.playerTurn
	ld c, a
	ld b, $0
	add hl, bc
	ld a, d
	ld [hl], a
	ld [wd11e], a
	call GetMoveName
	call PlayCurrentMoveAnimation
	ld hl, MimicLearnedMoveText
	jp PrintText
.mimicMissed
	jp PrintButItFailedText_

MimicLearnedMoveText:
	text_far _MimicLearnedMoveText
	text_end

LeechSeedEffect:
	jpfar LeechSeedEffect_

SplashEffect:
	call PlayCurrentMoveAnimation
	jp PrintNoEffectText

DisableEffect:
	jpfar DisableEffect_

PrintMoveWasDisabledText:
	ld hl, MoveWasDisabledText
	jp PrintText

MoveWasDisabledText:
	text_far _MoveWasDisabledText
	text_end

PayDayEffect:
	jpfar PayDayEffect_

ConversionEffect:
	jpfar ConversionEffect_

HazeEffect:
	jpfar HazeEffect_

HealEffect:
	jpfar HealEffect_

TransformEffect:
	jpfar TransformEffect_

ReflectLightScreenEffect:
	jpfar ReflectLightScreenEffect_

NothingHappenedText:
	text_far _NothingHappenedText
	text_end

PrintNoEffectText:
	ld hl, NoEffectText
	jp PrintText

NoEffectText:
	text_far _NoEffectText
	text_end

ConditionalPrintButItFailed:
	ld a, [wMoveDidntMiss]
	and a
	ret nz ; return if the side effect failed, yet the attack was successful

PrintButItFailedText_:
	ld hl, ButItFailedText
	jp PrintText

ButItFailedText:
	text_far _ButItFailedText
	text_end

PrintDidntAffectText:
	ld hl, DidntAffectText
	jp PrintText

DidntAffectText:
	text_far _DidntAffectText
	text_end

IsUnaffectedText:
	text_far _IsUnaffectedText
	text_end

PrintMayNotAttackText:
	ld hl, ParalyzedMayNotAttackText
	jp PrintText

ParalyzedMayNotAttackText:
	text_far _ParalyzedMayNotAttackText
	text_end

CheckTargetSubstitute:
	push hl
	ld hl, wEnemyBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .next1
	ld hl, wPlayerBattleStatus2
.next1
	bit HAS_SUBSTITUTE_UP, [hl]
	pop hl
	ret

PlayCurrentMoveAnimation2:
; animation at MOVENUM will be played unless MOVENUM is 0
; plays wAnimationType 3 or 6
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z

PlayBattleAnimation2:
; play animation ID at a and animation type 6 or 3
	ld [wAnimationID], a
	ldh a, [hWhoseTurn]
	and a
	ld a, $6
	jr z, .storeAnimationType
	ld a, $3
.storeAnimationType
	ld [wAnimationType], a
	jp PlayBattleAnimationGotID

PlayCurrentMoveAnimation:
; animation at MOVENUM will be played unless MOVENUM is 0
; resets wAnimationType
	xor a
	ld [wAnimationType], a
	ldh a, [hWhoseTurn]
	and a
	ld a, [wPlayerMoveNum]
	jr z, .notEnemyTurn
	ld a, [wEnemyMoveNum]
.notEnemyTurn
	and a
	ret z

PlayBattleAnimation:
; play animation ID at a and predefined animation type
	ld [wAnimationID], a

PlayBattleAnimationGotID::
; play animation at wAnimationID
	push hl
	push de
	push bc
	predef MoveAnimation
	callfar Func_78e98
	pop bc
	pop de
	pop hl
	ret
