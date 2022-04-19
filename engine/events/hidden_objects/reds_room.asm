PrintRedSNESText:
	call EnableAutoTextBoxDrawing
	ld a, [wHiddenObjectFunctionArgument]
	call PrintPredefTextID
	ret


RedBedroomSNESText::
	text_far _RedBedroomSNESText
	text_asm
	ld a, "▼"
	ldcoord_a 18, 16 ; place down arrow in lower right corner of dialogue text box
	push bc
	ldh a, [hDownArrowBlinkCount1]
	push af
	ldh a, [hDownArrowBlinkCount2]
	push af
	xor a
	ldh [hDownArrowBlinkCount1], a
	ld a, $6
	ldh [hDownArrowBlinkCount2], a
.loop
	push hl
	ld a, [wTownMapSpriteBlinkingEnabled]
	and a
	jr z, .skipAnimation
	call TownMapSpriteBlinkingAnimation
.skipAnimation
	hlcoord 18, 16
	call HandleDownArrowBlinkTiming
	pop hl
	call JoypadLowSensitivity
	predef CableClub_Run
	ldh a, [hJoy5]
	and A_BUTTON | B_BUTTON | SELECT
	jr z, .loop
	pop af
	ldh [hDownArrowBlinkCount2], a
	pop af
	ldh [hDownArrowBlinkCount1], a
	ld a, SFX_PRESS_AB
	call PlaySound
	pop bc
	ld a, " "
	ldcoord_a 18, 16 ; overwrite down arrow with blank space
	ldh a, [hJoy5]
	cp SELECT
	jr z, GameGenieSNESText.startHere
	ld hl, RedBedroomSNESText2
	call PrintText
	jp TextScriptEnd
	

RedBedroomSNESText2::
	text_far _RedBedroomSNESText2
	text_end

GameGenieSNESText::
	text_asm
.startHere
	ld hl, .GameGenieEnabledText
	call PrintText
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
.mainLoop
	ld hl, .OptionsText
	call PrintText
	ld hl, GameGenieItemList
	call LoadItemList
	ld hl, wItemList
	ld a, l
	ld [wListPointer], a
	ld a, h
	ld [wListPointer + 1], a
	xor a
	ld [wPrintItemPrices], a
	ld [wMenuItemToSwap], a
	ld a, SPECIALLISTMENU
	ld [wListMenuID], a
	call DisplayListMenuID
	jp c, .done
	ld hl, OptionPointers
	ld a, [wCurrentMenuItem]
	push af
	ld a, [wcf91]
	sub FIELD_MOVE
	push af
	add a
	ld d, $0
	ld e, a
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call PrintText
	pop af
	cp $8
	jr z, .playerDV
	cp $9
	jr z, .enemyDV
	ld c, a
	push bc
	call YesNoChoice
	pop bc
	ldh a, [hJoy5]
	bit BIT_B_BUTTON, a
	jr nz, .next
	ld a, [wCurrentMenuItem]
	xor 1
	ld d, $FE
	inc c
.loop	
	dec c
	jr z, .finishedloop
	sla a
	rlc d
	jr .loop
.finishedloop
	ld b, a
	ld a, [wOptions2]
	and d
	or b
	ld [wOptions2], a
	jr .next
.playerDV
	ld hl, PlayerDVOptionText
	ld de, PlayerDVOptionList
	call DisplayDVChoiceTextBox
	ldh a, [hJoy5]
	bit BIT_B_BUTTON, a
	jr nz, .next
	ld a, [wCurrentMenuItem]
	ld b, a
	ld d, %11111100
	ld a, [wDVOptions]
	and d
	or b
	ld [wDVOptions], a
	jr .next
.enemyDV
	ld hl, EnemyDVOptionText
	ld de, EnemyDVOptionList
	call DisplayDVChoiceTextBox
	ldh a, [hJoy5]
	bit BIT_B_BUTTON, a
	jr nz, .next
	ld a, [wCurrentMenuItem]
	ld b, a
	ld d, %11110011
	sla b
	sla b
	ld a, [wDVOptions]
	and d
	or b
	ld [wDVOptions], a
.next
	pop af
	ld [wCurrentMenuItem], a
	jp .mainLoop
.done
	xor a
	ld [wCurrentMenuItem], a
	ld [wListScrollOffset], a
	inc a
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

.GameGenieEnabledText
	text_far _GameGenieEnabledText
	text_end
	
.OptionsText
	text_far _NewOptionsText
	text_end

FieldMoveOptionText:
	text_far _FieldMoveOptionText
	text_end
	
BadgeBoostGlitchOptionText:
	text_far _BadgeBoostGlitchOptionText
	text_end
	
BadgeBoostEnableOptionText:
	text_far _BadgeBoostEnableOptionText
	text_end
	
BadgeBoostEnemyOptionText:
	text_far _BadgeBoostEnemyOptionText
	text_end

LevelCapOptionText:
	text_far _LevelCapOptionText
	text_end
	
SoloModeOptionText:
	text_far _SoloModeOptionText
	text_end
	
InstantTextOptionText:
	text_far _InstantTextOptionText
	text_end
	
RedBarOptionText:
	text_far _RedBarOptionText
	text_end

PlayerDVOptionText:
	text_far _PlayerDVOptionText
	text_end

EnemyDVOptionText:	
	text_far _EnemyDVOptionText
	text_end
	
PlayerDVOptionList:
	db   "NORMAL"
	next "MAX"
	next "ZERO"
	next "RUDE"
	db   "@"
	
EnemyDVOptionList:
	db   "NORMAL"
	next "RANDOM"
	next "ZERO"
	next "MAX"
	db   "@"

GameGenieItemList:
	db 10 ; #
	db FIELD_MOVE ;bit 0
	db BADGE_BOOST_1 ;bit 1
	db BADGE_BOOST_2 ;bit 2
	db BADGE_BOOST_3 ;bit 3
	db LEVEL_CAP ;bit 4
	db SOLO_MODE ;bit 5
	db INSTANT_TEXT ;bit 6
	db RED_BAR ;bit 7
	db DVS_PLAYER
	db DVS_ENEMY
	db -1 ; end

OptionPointers:
	dw FieldMoveOptionText
	dw BadgeBoostGlitchOptionText
	dw BadgeBoostEnableOptionText
	dw BadgeBoostEnemyOptionText
	dw LevelCapOptionText
	dw SoloModeOptionText
	dw InstantTextOptionText
	dw RedBarOptionText
	dw PlayerDVOptionText
	dw EnemyDVOptionText
	
DisplayDVChoiceTextBox:
	push de
	call SaveScreenTilesToBuffer1
	hlcoord 0, 0
	ld b, $a
	ld c, $9
	call TextBoxBorder
	pop de
	hlcoord 2, 2
	call PlaceString
	call UpdateSprites
	xor a
	ld [wCurrentMenuItem], a
	ld [wLastMenuItem], a
	inc a
	ld [wTopMenuItemX], a
	inc a
	ld [wTopMenuItemY], a
	inc a
	ld [wMaxMenuItem], a
	ld [wMenuWatchedKeys], a ; A_BUTTON | B_BUTTON
	call HandleMenuInput
	jp LoadScreenTilesFromBuffer1

OpenRedsPC:
	call EnableAutoTextBoxDrawing
	tx_pre_jump RedBedroomPCText

RedBedroomPCText::
	script_players_pc
