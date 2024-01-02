ViridianWilds_Script:
	call EnableAutoTextBoxDrawing
	ld hl, ViridianWildsTrainerHeaders
	ld de, ViridianWilds_ScriptPointers
	ld a, [wViridianWildsCurScript]
	call ExecuteCurMapScriptInTable
	ld [wViridianWildsCurScript], a
	ret

ViridianWilds_ScriptPointers:
	dw CheckFightingMapTrainers
	dw DisplayEnemyTrainerTextAndStartBattle
	dw EndTrainerBattle
	
ViridianWilds_TextPointers:
	dw ZapdosgText
	dw PickUpItemText
	dw BoulderText


ViridianWildsTrainerHeaders:
	def_trainers 0
ZapdosgTrainerHeader:
	trainer EVENT_BEAT_ZAPDOSG, 0, ZapdosgBattleText, ZapdosgBattleText, ZapdosgBattleText
	db -1 ; end

ZapdosgText:
	text_asm
	ld hl, ZapdosgTrainerHeader
	call TalkToTrainer
	jp TextScriptEnd

ZapdosgBattleText:
	text_far _ZapdosBattleText
	text_asm	
	ld a, ZAPDOSG
	call PlayCry
	call WaitForSoundToFinish
	jp TextScriptEnd