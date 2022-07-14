MtMoonSummit_Script:
	call EnableAutoTextBoxDrawing
	ld hl, MtMoonSummitTrainerHeaders
	ld de, MtMoonSummit_ScriptPointers
	ld a, [wMtMoonSummitCurScript]
	call ExecuteCurMapScriptInTable
	ld [wMtMoonSummitCurScript], a
	ret

MtMoonSummit_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	
MtMoonSummit_TextPointers:
	dw ArticunogText
	dw BoulderText

MtMoonSummitTrainerHeaders:
	def_trainers 7
ArticunogTrainerHeader:
	trainer EVENT_BEAT_ARTICUNOG, 0, ArticunogBattleText, ArticunogBattleText, ArticunogBattleText
	db -1 ; end

ArticunogText:
	text_asm
	ld hl, ArticunogTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

ArticunogBattleText:
	text_far _ArticunoBattleText
	text_asm	
	ld a, ARTICUNOG
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd