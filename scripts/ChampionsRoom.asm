ChampionsRoom_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ChampionsRoom_ScriptPointers
	ld a, [wChampionsRoomCurScript]
	jp CallFunctionInTable

ResetGaryScript:
	xor a
	ld [wJoyIgnore], a
	ld [wChampionsRoomCurScript], a
	ret

ChampionsRoom_ScriptPointers:
	dw GaryScript0
	dw GaryScript1
	dw GaryScript2
	dw GaryScript3
	dw GaryScript4
	dw GaryScript5
	dw GaryScript6
	dw GaryScript7
	dw GaryScript8
	dw GaryScript9
	dw GaryScript10

GaryScript0:
	ret

GaryScript1:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, GaryEntrance_RLEMovement
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $2
	ld [wChampionsRoomCurScript], a
	ret

GaryEntrance_RLEMovement:
	db D_UP, 1
	db D_RIGHT, 1
	db D_UP, 3
	db -1 ; end

GaryScript2:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	call Delay3
	xor a
	ld [wJoyIgnore], a
	ld hl, wOptions
	res 7, [hl]  ; Turn on battle animations to make the battle feel more epic.
	CheckEvent EVENT_BECOME_CHAMPION
	jr z, .firstBattle
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, GaryRematchDefeatedText
	ld de, GaryRematchVictoryText
	jr .rematch
.firstBattle
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
	call Delay3
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, GaryDefeatedText
	ld de, GaryVictoryText
.rematch
	call SaveEndBattleTextPointers
	ld a, OPP_RIVAL3
	ld [wCurOpponent], a
	CheckEvent EVENT_BECOME_CHAMPION
	jr nz, .isRematch
	; select which team to use during the encounter
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .NotStarter2
	ld a, $1
	jr .saveTrainerId
.NotStarter2
	cp STARTER3
	jr nz, .NotStarter3
	ld a, $2
	jr .saveTrainerId
.NotStarter3
	ld a, $3
	jr .saveTrainerId
.isRematch
	ld a, [wRivalStarter]
	cp STARTER2
	jr nz, .NotStarter2Rematch
	ld a, $5
	jr .saveTrainerId
.NotStarter2Rematch
	cp STARTER3
	jr nz, .NotStarter3Rematch
	ld a, $6
	jr .saveTrainerId
.NotStarter3Rematch
	ld a, $7
.saveTrainerId
	ld [wTrainerNo], a
	ld a, $A
	ld [wGymLeaderNo], a
	ld a, 1
	ld [wIsTrainerBattle], a

	xor a
	ldh [hJoyHeld], a
	ld a, $3
	ld [wChampionsRoomCurScript], a
	ret

GaryScript3:
	ld a, [wIsInBattle]
	cp $ff
	jp z, ResetGaryScript
	xor a
	ld [wIsTrainerBattle], a
	call UpdateSprites
	SetEvent EVENT_BEAT_CHAMPION_RIVAL
	ld a, $f0
	ld [wJoyIgnore], a
	ld a, $1
	ldh [hSpriteIndexOrTextID], a
	CheckEvent EVENT_BECOME_CHAMPION
	jr z, .firstTime
	SetEvent EVENT_BEAT_CHAMPION_REMATCH
	ld a, $6
	ldh [hSpriteIndexOrTextID], a
.firstTime
	call GaryScript_760c8
	ld a, $1
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld a, $4
	ld [wChampionsRoomCurScript], a
	ret

GaryScript4:
	farcall Music_Cities1AlternateTempo
	ld a, $2
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $2
	ldh [hSpriteIndex], a
	call SetSpriteMovementBytesToFF
	ld de, OakEntranceAfterVictoryMovement
	ld a, $2
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef ShowObject
	ld a, $5
	ld [wChampionsRoomCurScript], a
	ret

OakEntranceAfterVictoryMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

GaryScript5:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, PLAYER_DIR_LEFT
	ld [wPlayerMovingDirection], a
	ld a, $1
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_LEFT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $2
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $3
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $6
	ld [wChampionsRoomCurScript], a
	ret

GaryScript6:
	ld a, $2
	ldh [hSpriteIndex], a
	ld a, SPRITE_FACING_RIGHT
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $4
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld a, $7
	ld [wChampionsRoomCurScript], a
	ret

GaryScript7:
	ld a, $2
	ldh [hSpriteIndex], a
	xor a ; SPRITE_FACING_DOWN
	ldh [hSpriteFacingDirection], a
	call SetSpriteFacingDirectionAndDelay
	ld a, $5
	ldh [hSpriteIndexOrTextID], a
	call GaryScript_760c8
	ld de, OakExitGaryRoomMovement
	ld a, $2
	ldh [hSpriteIndex], a
	call MoveSprite
	ld a, $8
	ld [wChampionsRoomCurScript], a
	ret

OakExitGaryRoomMovement:
	db NPC_MOVEMENT_UP
	db NPC_MOVEMENT_UP
	db -1 ; end

GaryScript8:
	ld a, [wd730]
	bit 0, a
	ret nz
	ld a, HS_CHAMPIONS_ROOM_OAK
	ld [wMissableObjectIndex], a
	predef HideObject
	ld a, $9
	ld [wChampionsRoomCurScript], a
	ret

GaryScript9:
	ld a, $ff
	ld [wJoyIgnore], a
	ld hl, wSimulatedJoypadStatesEnd
	ld de, WalkToHallOfFame_RLEMovment
	call DecodeRLEList
	dec a
	ld [wSimulatedJoypadStatesIndex], a
	call StartSimulatingJoypadStates
	ld a, $a
	ld [wChampionsRoomCurScript], a
	ret

WalkToHallOfFame_RLEMovment:
	db D_UP, 4
	db D_LEFT, 1
	db -1 ; end

GaryScript10:
	ld a, [wSimulatedJoypadStatesIndex]
	and a
	ret nz
	xor a
	ld [wJoyIgnore], a
	ld a, $0
	ld [wChampionsRoomCurScript], a
	ret

GaryScript_760c8:
	ld a, $f0
	ld [wJoyIgnore], a
	call DisplayTextID
	ld a, $ff
	ld [wJoyIgnore], a
	ret

ChampionsRoom_TextPointers:
	dw GaryText1
	dw GaryText2
	dw GaryText3
	dw GaryText4
	dw GaryText5
	dw GaryText6

GaryText1:
	text_asm
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	ld hl, GaryChampionIntroText
	jr z, .printText
	ld hl, GaryText_76103
.printText
	call PrintText
	jp TextScriptEnd

GaryChampionIntroText:
	text_far _GaryChampionIntroText
	text_end

GaryDefeatedText:
	text_far _GaryDefeatedText
	text_end

GaryVictoryText:
	text_far _GaryVictoryText
	text_end

GaryText_76103:
	text_far _GaryText_76103
	text_end

GaryText2:
	text_far _GaryText2
	text_end

GaryText3:
	text_asm
	ld a, [wPlayerStarter]
	ld [wd11e], a
	call GetMonName
	ld hl, GaryText_76120
	CheckEvent EVENT_BECOME_CHAMPION
	jr z, .printText
	ld hl, OakAfterWinToPlayerText
.printText
	call PrintText
	jp TextScriptEnd

GaryText_76120:
	text_far _GaryText_76120
	text_end

GaryText4:
	text_asm
	CheckEvent EVENT_BECOME_CHAMPION
	ld hl, ThisWasGaryText4
	jr z, .printText
	ld hl, OakAfterWinToGaryText
.printText
	call PrintText
	jp TextScriptEnd
	
ThisWasGaryText4:
	text_far _GaryText_76125
	text_end

GaryText5:
	text_asm
	CheckEvent EVENT_BECOME_CHAMPION
	ld hl, ThisWasGaryText5
	jr z, .printText
	ld hl, OakAfterWinVictoryText
.printText
	call PrintText
	jp TextScriptEnd
	
ThisWasGaryText5:
	text_far _GaryText_7612a
	text_end

GaryText6:
	text_asm
	CheckEvent EVENT_BEAT_CHAMPION_RIVAL
	ld hl, GaryChampionRematchIntroText
	jr z, .printText
	ld hl, GaryAfterLossText
.printText
	call PrintText
	jp TextScriptEnd
	
GaryChampionRematchIntroText:
	text_far _GaryChampionRematchIntroText
	text_end
	
GaryAfterLossText:
	text_far _GaryAfterLossText
	text_end
	
OakAfterWinToPlayerText:
	text_far _OakAfterWinToPlayerText
	text_end
	
OakAfterWinToGaryText:
	text_far _OakAfterWinToGaryText
	text_end
	
OakAfterWinVictoryText:
	text_far _OakAfterWinVictoryText
	text_end
	
GaryRematchDefeatedText:
	text_far _GaryRematchDefeatedText
	text_end
	
GaryRematchVictoryText:
	text_far _GaryRematchVictoryText
	text_end