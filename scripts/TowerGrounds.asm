TowerGrounds_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MoltresgTrainerHeader
	ld de, TowerGrounds_ScriptPointers
	ld a, [wTowerGroundsCurScript]
	call ExecuteCurMapScriptInTable
	ld [wTowerGroundsCurScript], a
	ret

TowerGrounds_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	
TowerGrounds_TextPointers:
	dw MoltresgText
	dw BoulderText
	dw BoulderText

MoltresgTrainerHeader:
	trainer EVENT_BEAT_MOLTRESG, 0, MoltresgBattleText, MoltresgBattleText, MoltresgBattleText
	db -1 ; end

MoltresgText:
	text_asm
	ld hl, MoltresgTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

MoltresgBattleText:
	text_far _MoltresgBattleText
	text_asm	
	ld a, MOLTRESG
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd