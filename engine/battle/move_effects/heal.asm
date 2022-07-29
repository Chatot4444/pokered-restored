HealEffect_:
	ldh a, [hWhoseTurn]
	and a
	ld de, wBattleMonHP
	ld hl, wBattleMonMaxHP
	ld a, [wPlayerMoveNum]
	jr z, .healEffect
	ld de, wEnemyMonHP
	ld hl, wEnemyMonMaxHP
	ld a, [wEnemyMoveNum]
.healEffect
	ld b, a
	ld a, [de]
	cp [hl] ; most significant bytes comparison is no longer ignored
	inc de
	inc hl
	jr nz, .passed
	ld a, [de]
	sbc [hl]
	jp z, .failed ; no effect if user's HP is already at its maximum
.passed
	ld a, b
	cp REST
	jp nz, .healHP
	push hl
	push de
	push af
	ld c, 50
	call DelayFrames
;remove status if using rest
.checkToxic	;remove toxic and clear toxic counter
	ld hl, wPlayerBattleStatus3	;load in for toxic bit
	ld de, wPlayerToxicCounter	;load in for toxic counter
	ldh a, [hWhoseTurn]
	and a
	jr z, .undoToxic
	ld hl, wEnemyBattleStatus3	;load in for toxic bit
	ld de, wEnemyToxicCounter	;load in for toxic counter
.undoToxic
	res BADLY_POISONED, [hl] ; heal Toxic status
	xor a	;clear a
	ld [de], a	;write a to toxic counter
	ldh a, [hWhoseTurn]
	and a
	jr nz, .enemyStats
; reset player stats
	ld hl, wPartyMon1Stats
	ld a, [wPlayerMonNumber]
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld de, wBattleMonStats
	ld bc, NUM_STATS * 2
	call CopyData ; copy party stats to in-battle stat data
	xor a
	ld [wCalculateWhoseStats], a
	callfar CalculateModifiedStats
	ld a, [wOptions2]
	bit 2, a
	callfar_z ApplyBadgeStatBoosts
	jr .finishedStatReset
; reset enemy stats
.enemyStats
	ld de, wEnemyMonStats
	ld hl, wEnemyMonUnmodifiedMaxHP
	ld bc, NUM_STATS * 2
	call CopyData
	ld a, $1
	ld [wCalculateWhoseStats], a
	callfar CalculateModifiedStats
	ld a, [wOptions2]
	bit 3, a
	callfar_z ApplyBadgeStatBoosts.ApplyToEnemy
;reload the initial status info so the correct condtions can be cleared
.finishedStatReset
	ld hl, wBattleMonStatus
	ldh a, [hWhoseTurn]
	and a
	jr z, .noCondition
	ld hl, wEnemyMonStatus
.noCondition
;;;;;;;;
	ld a, [hl]
	and a
	ld [hl], 2 ; clear status and set number of turns asleep to 2
	ld hl, StartedSleepingEffect ; if mon didn't have a status
	jr z, .printRestText
	ld hl, FellAsleepBecameHealthyText ; if mon had a status
.printRestText
	call PrintText
	pop af
	pop de
	pop hl
.healHP
	ld a, [hld]
	ld [wHPBarMaxHP], a
	ld c, a
	ld a, [hl]
	ld [wHPBarMaxHP+1], a
	ld b, a
	jr z, .gotHPAmountToHeal
; Recover and Softboiled only heal for half the mon's max HP
	srl b
	rr c
.gotHPAmountToHeal
; update HP
	ld a, [de]
	ld [wHPBarOldHP], a
	add c
	ld [de], a
	ld [wHPBarNewHP], a
	dec de
	ld a, [de]
	ld [wHPBarOldHP+1], a
	adc b
	ld [de], a
	ld [wHPBarNewHP+1], a
	inc hl
	inc de
	ld a, [de]
	dec de
	sub [hl]
	dec hl
	ld a, [de]
	sbc [hl]
	jr c, .playAnim
; copy max HP to current HP if an overflow occurred
	ld a, [hli]
	ld [de], a
	ld [wHPBarNewHP+1], a
	inc de
	ld a, [hl]
	ld [de], a
	ld [wHPBarNewHP], a
.playAnim
	ld hl, PlayCurrentMoveAnimation
	call EffectCallBattleCore
	ldh a, [hWhoseTurn]
	and a
	hlcoord 10, 9
	ld a, $1
	jr z, .updateHPBar
	hlcoord 2, 2
	xor a
.updateHPBar
	ld [wHPBarType], a
	predef UpdateHPBar2
	ld hl, DrawHUDsAndHPBars
	call EffectCallBattleCore
	ld hl, RegainedHealthText
	jp PrintText
.failed
	ld c, 50
	call DelayFrames
	ld hl, PrintButItFailedText_
	jp EffectCallBattleCore

StartedSleepingEffect:
	text_far _StartedSleepingEffect
	text_end

FellAsleepBecameHealthyText:
	text_far _FellAsleepBecameHealthyText
	text_end

RegainedHealthText:
	text_far _RegainedHealthText
	text_end
