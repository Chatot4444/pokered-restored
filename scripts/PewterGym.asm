PewterGym_Script:
	ld hl, wCurrentMapScriptFlags
	bit 6, [hl]
	res 6, [hl]
	call nz, .LoadNames
	call EnableAutoTextBoxDrawing
	ld hl, PewterGymTrainerHeader0
	ld de, PewterGym_ScriptPointers
	ld a, [wPewterGymCurScript]
	call ExecuteCurMapScriptInTable
	ld [wPewterGymCurScript], a
	ret

.LoadNames:
	ld hl, .CityName
	ld de, .LeaderName
	jp LoadGymLeaderAndCityName

.CityName:
	db "PEWTER CITY@"

.LeaderName:
	db "BROCK@"

PewterGymScript_5c3bf:
	xor a
	ld [wJoyIgnore], a
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	ret

PewterGym_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	dw PewterGymScript3
	dw PewterGymScript4

PewterGymScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, PewterGymScript_5c3bf
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, [wLevelCap]
	cp 21
	jr nc, .skipCap
	ld a, 21
	ld [wLevelCap], a
.skipCap
PewterGymScript_5c3df:
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_BEAT_BROCK
	lb bc, TM_ROCK_TOMB, 1
	call GiveItem
	jr nc, .BagFull
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	SetEvent EVENT_GOT_TM34
	jr .gymVictory
.BagFull
	ld a, $7
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.gymVictory
	ld hl, wObtainedBadges
	set BIT_BOULDERBADGE, [hl]
	ld hl, wBeatGymFlags
	set BIT_BOULDERBADGE, [hl]

	ld a, HS_GYM_GUY
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, HS_ROUTE_22_RIVAL_1
	ld [wMissableObjectIndex], a
	predef HideObject

	ResetEvents EVENT_1ST_ROUTE22_RIVAL_BATTLE, EVENT_ROUTE22_RIVAL_WANTS_BATTLE

	; deactivate gym trainers
	SetEvent EVENT_BEAT_PEWTER_GYM_TRAINER_0

	jp PewterGymScript_5c3bf

PewterGym_TextPointers:
	dw PewterGymText1
	dw PewterGymText2
	dw PewterGymText3
	dw PewterGymText4
	dw PewterGymText5
	dw PewterGymText6
	dw PewterGymText7
	dw PewterGymText8

PewterGymTrainerHeader0:
	trainer EVENT_BEAT_PEWTER_GYM_TRAINER_0, 5, PewterGymBattleText1, PewterGymEndBattleText1, PewterGymAfterBattleText1
	db -1 ; end

PewterGymText1:
	text_asm
	CheckEvent EVENT_BEAT_BROCK
	jr z, .beginBattle
	CheckEventReuseA EVENT_GOT_TM34
	jr nz, .gymVictory
	call z, PewterGymScript_5c3df
	call DisableWaitingAfterTextDisplay
	jr .done
.gymVictory
	ld hl, PewterGymText_5c4a3
	call PrintText
	jr .done
.beginBattle
	ld hl, PewterGymText_5c49e
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, PewterGymText_5c4bc
	ld de, PewterGymText_5c4bc
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $1
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, $3
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
.done
	jp TextScriptEnd

PewterGymText_5c49e:
	text_far _PewterGymText_5c49e
	text_end

PewterGymText_5c4a3:
	text_far _PewterGymText_5c4a3
	text_end

PewterGymText5:
	text_far _TM34PreReceiveText
	text_end

PewterGymText6:
	text_far _ReceivedTM34Text
	sound_get_item_1
	text_far _TM34ExplanationText
	text_end

PewterGymText7:
	text_far _TM34NoRoomText
	text_end

PewterGymText_5c4bc:
	text_far _PewterGymText_5c4bc
	sound_level_up ; probably supposed to play SFX_GET_ITEM_1 but the wrong music bank is loaded
	text_far _PewterGymText_5c4c1
	text_end

PewterGymText2:
	text_asm
	ld hl, PewterGymTrainerHeader0
	call TalkToTrainer
	jp TextScriptEnd

PewterGymBattleText1:
	text_far _PewterGymBattleText1
	text_end

PewterGymEndBattleText1:
	text_far _PewterGymEndBattleText1
	text_end

PewterGymAfterBattleText1:
	text_far _PewterGymAfterBattleText1
	text_end

PewterGymText3:
	text_asm
	ld a, [wBeatGymFlags]
	bit BIT_BOULDERBADGE, a
	jr nz, .asm_5c50c
	ld hl, PewterGymText_5c515
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .asm_5c4fe
	ld hl, PewterGymText_5c51a
	call PrintText
	jr .asm_5c504
.asm_5c4fe
	ld hl, PewterGymText_5c524
	call PrintText
.asm_5c504
	ld hl, PewterGymText_5c51f
	call PrintText
	jr .asm_5c512
.asm_5c50c
	ld hl, PewterGymText_5c529
	call PrintText
.asm_5c512
	jp TextScriptEnd

PewterGymText_5c515:
	text_far _PewterGymText_5c515
	text_end

PewterGymText_5c51a:
	text_far _PewterGymText_5c51a
	text_end

PewterGymText_5c51f:
	text_far _PewterGymText_5c51f
	text_end

PewterGymText_5c524:
	text_far _PewterGymText_5c524
	text_end

PewterGymText_5c529:
	text_far _PewterGymText_5c529
	text_end

PewterGymText4:
	text_asm
	ld hl, PewterGymText_Rematch
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cancel
	ld hl, PewterGymText_RematchConfirm
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, PewterGymText_RematchWin
	ld de, PewterGymText_RematchWin
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	call EngageMapTrainer
	call InitBattleEnemyParameters
	ld a, $1
	ld [wGymLeaderNo], a
	xor a
	ldh [hJoyHeld], a
	ld a, $4
	ld [wPewterGymCurScript], a
	ld [wCurMapScript], a
	jr .done
.cancel
	ld hl, PewterGymText_RematchCancel
	call PrintText
.done
	jp TextScriptEnd
	
	
PewterGymScript4:
	ld a, [wIsInBattle]
	cp $ff
	jp z,  PewterGymScript_5c3bf
	ld a, $f0
	ld [wJoyIgnore], a
PewterGymScript_AfterRematch:
	CheckAndSetEvent EVENT_BEAT_BROCK2
	jr nz, .alreadyWon
	ld hl, wRematchWinCount
	inc [hl]
	ld hl, wLevelCap
	inc [hl]
.alreadyWon
	ld a, $8
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	jp PewterGymScript_5c3bf
	
PewterGymText_Rematch:
	text_far _PewterGymText_Rematch
	text_end

PewterGymText_RematchConfirm:
	text_far _PewterGymText_RematchConfirm
	text_end

PewterGymText_RematchCancel:
	text_far _PewterGymText_RematchCancel
	text_end
	
PewterGymText_RematchWin:
	text_far _PewterGymText_RematchWin
	text_end
	
PewterGymText8:
	text_far _PewterGymText8
	text_end
