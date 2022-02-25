HallOfFame_Script:
	call EnableAutoTextBoxDrawing
	ld hl, HallOfFame_ScriptPointers
	ld a, [wHallOfFameCurScript]
	jp CallFunctionInTable

HallofFameRoomScript_5a4aa:
	xor a
	ld [wJoyIgnore], a
	ld [wHallOfFameCurScript], a
	ret

HallOfFame_ScriptPointers:
	dw HallofFameRoomScript0
	dw HallofFameRoomScript1
	dw HallofFameRoomScript2
	dw HallofFameRoomScript3

HallofFameRoomScript3:
	ret

HallofFameRoomScript2:
	call Delay3
	ld a, [wLetterPrintingDelayFlags]
	push af
	xor a
	ld [wJoyIgnore], a
	predef HallOfFamePC
	pop af
	ld [wLetterPrintingDelayFlags], a
	ld hl, wFlags_D733
	res 1, [hl]
	inc hl
	set 0, [hl]
	xor a
	ld hl, wLoreleisRoomCurScript
	ld [hli], a ; wLoreleisRoomCurScript
	ld [hli], a ; wBrunosRoomCurScript
	ld [hl], a ; wAgathasRoomCurScript
	ld [wLancesRoomCurScript], a
	ld [wHallOfFameCurScript], a
	; Elite 4 events
	ResetEventRange ELITE4_EVENTS_START, ELITE4_CHAMPION_EVENTS_END, 1
	SetEvent EVENT_BECOME_CHAMPION
	xor a
	ld [wHallOfFameCurScript], a
	ld a, PALLET_TOWN
	ld [wLastBlackoutMap], a
	farcall SaveSAVtoSRAM
	ld b, 5
.delayLoop
	ld c, 600 / 5
	call DelayFrames
	dec b
	jr nz, .delayLoop
	call WaitForTextScrollButtonPress
	jp Init

HallofFameRoomScript0:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, RLEMovement5a528
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $1
	ld [wHallOfFameCurScript], a
	ret

RLEMovement5a528:
	db D_UP, 5
	db -1 ; end

HallofFameRoomScript1:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	ld a, PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	call Delay3
	xor a
	ld [wJoyIgnore], a
	inc a ; PLAYER_DIR_RIGHT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ResetEvent EVENT_BEAT_MEWTWO
	ResetEvent EVENT_BEAT_ARTICUNO
	ResetEvent EVENT_BEAT_ZAPDOS
	ResetEvent EVENT_BEAT_MOLTRES
	ResetEvent EVENT_BEAT_MOLTRESG
	ResetEvent EVENT_BEAT_ROUTE16_SNORLAX
	ResetEvent EVENT_BEAT_ROUTE12_SNORLAX
	ResetEvent EVENT_GOT_MEW
	ld a, HS_MEWTWO
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ARTICUNO
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ZAPDOS
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_MOLTRES
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_MOLTRESG
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ROUTE_12_SNORLAX
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ROUTE_16_SNORLAX 
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_CERULEAN_CAVE_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BROCK
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BROCK2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_MISTY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_MISTY2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_LT_SURGE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_LT_SURGE2
	ld [wMissableObjectIndex], a
	predef ShowObject	
	ld a, HS_ERIKA
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ERIKA2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_KOGA
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_KOGA2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_SABRINA
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_SABRINA2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_BLAINE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BLAINE2
	ld [wMissableObjectIndex], a
	predef ShowObject	
	ld a, HS_VIRIDIAN_GYM_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_LEADER_BLUE
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_LANCE
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_LANCE2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_LORELEI
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_LORELEI2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_BRUNO
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_BRUNO2
	ld [wMissableObjectIndex], a
	predef ShowObject	
	ld a, HS_AGATHA
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_AGATHA2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ROCKET_HIDEOUT_B4F_GIOVANNI2
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, HS_ROCKET_HIDEOUT_B4F_GIOVANNI
	ld [wMissableObjectIndex], a
	predef HideObject
	CheckEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	jr nz, .hasSilphScope
	SetEvent EVENT_BEAT_ROCKET_HIDEOUT_GIOVANNI
	ld a, HS_ROCKET_HIDEOUT_B4F_ITEM_4
	ld [wMissableObjectIndex], a
	predef ShowObject
.hasSilphScope
	ld a, $2
	ld [wHallOfFameCurScript], a
	ret

HallOfFame_TextPointers:
	dw HallofFameRoomText1

HallofFameRoomText1:
	text_asm
	CheckEvent EVENT_BECOME_CHAMPION
	ld hl, HallofFameFirstTimeText
	jr z, .printText
	ld hl, HallofFameRematchText
.printText
	call PrintText
	jp TextScriptEnd

HallofFameFirstTimeText:
	text_far _HallofFameRoomText1
	text_end

HallofFameRematchText:
	text_far _HallofFameRematchText
	text_end