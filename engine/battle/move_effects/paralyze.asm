ParalyzeEffect_:
	ld hl, wEnemyMonStatus
	ld de, wPlayerMoveType
	ldh a, [hWhoseTurn]
	and a
	jp z, .next
	ld hl, wBattleMonStatus
	ld de, wEnemyMoveType
.next
	ld a, [hl]
	and a ; does the target already have a status ailment?
	jr nz, .didntAffect
	push hl
	farcall CheckTargetSubstitute ; test bit 4 of d063/d068 flags [target has substitute flag]
	pop hl
	jr nz, .didntAffect ; return if they have a substitute, can't effect them
; check if the target is immune due to types
	ld b, h
	ld c, l
	inc bc
	ld a, [de]
	cp NORMAL
	jr z, .hitTest
	cp ELECTRIC
	ld d, a
	jr nz, .hitTest
	ld a, [bc]   ; if using thunder wave, check if target is ground type
	cp GROUND
	jr z, .doesntAffect
	inc bc
	ld a, [bc]
	cp GROUND
	jr z, .doesntAffect
.sameTypeTest
	ld a, [bc]  ; if not using glare, check if target is same type as attack
	cp d
	jr z, .doesntAffect
	dec bc
	ld a, [bc]
	cp d
	jr z, .doesntAffect
.hitTest 
	push hl
	callfar MoveHitTest
	pop hl
	ld a, [wMoveMissed]
	and a
	jr nz, .didntAffect
	set PAR, [hl]
	callfar QuarterSpeedDueToParalysis
	ld c, 30
	call DelayFrames
	callfar PlayCurrentMoveAnimation
	jpfar PrintMayNotAttackText
.didntAffect
	ld c, 50
	call DelayFrames
	jpfar PrintDidntAffectText
.doesntAffect
	ld c, 50
	call DelayFrames
	jpfar PrintDoesntAffectText
