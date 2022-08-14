ChargeEffect_::
	ld hl, wPlayerBattleStatus1
	ld de, wPlayerMoveEffect
	ldh a, [hWhoseTurn]
	and a
	ld b, XSTATITEM_ANIM
	jr z, .chargeEffect
	ld hl, wEnemyBattleStatus1
	ld de, wEnemyMoveEffect
	ld b, ANIM_AF
.chargeEffect
	set CHARGING_UP, [hl]
	ld a, [de]
	dec de ; de contains enemy or player MOVENUM
	cp FLY_EFFECT
	jr nz, .notFly
	set INVULNERABLE, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	ld b, TELEPORT ; load Teleport's animation
.notFly
	ld a, [de]
	cp DIG
	jr nz, .notDigOrFly
	set INVULNERABLE, [hl] ; mon is now invulnerable to typical attacks (fly/dig)
	set USING_DIG, [hl]
	ld b, ANIM_C0
.notDigOrFly
	xor a
	ld [wAnimationType], a
	ld a, b
	ld [wAnimationID], a
	farcall PlayBattleAnimationGotID
	ld a, [de]
	ld [wChargeMoveNum], a
	ld hl, ChargeMoveEffectText
	cp SKULL_BASH
	jp nz, PrintText
	push de
	call PrintText
	pop de
	inc de
	ld a, DEFENSE_UP1_EFFECT
	ld [de], a
	push de
	farcall StatModifierUpEffect
	pop de
	ld a, CHARGE_EFFECT
	ld [de], a
	ret

ChargeMoveEffectText:
	text_far _ChargeMoveEffectText
	text_asm
	ld a, [wChargeMoveNum]
	cp SOLARBEAM
	ld hl, TookInSunlightText
	jr z, .gotText
	cp SKULL_BASH
	ld hl, LoweredItsHeadText
	jr z, .gotText
	cp SKY_ATTACK
	ld hl, SkyAttackGlowingText
	jr z, .gotText
	cp FLY
	ld hl, FlewUpHighText
	jr z, .gotText
	cp DIG
	ld hl, DugAHoleText
	jr z, .gotText
	cp BOUNCE
	ld hl, SprangUpText
.gotText
	ret

TookInSunlightText:
	text_far _TookInSunlightText
	text_end

LoweredItsHeadText:
	text_far _LoweredItsHeadText
	text_end

SkyAttackGlowingText:
	text_far _SkyAttackGlowingText
	text_end

FlewUpHighText:
	text_far _FlewUpHighText
	text_end

DugAHoleText:
	text_far _DugAHoleText
	text_end

SprangUpText:
	text_far _SprangUpText
	text_end