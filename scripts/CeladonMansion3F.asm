CeladonMansion3F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, CeladonMansion3F_ScriptPointers
	ld a, [wCeladonMansion3FCurScript]
	jp CallFunctionInTable

CeladonMansion3F_TextPointers:
	dw ProgrammerText
	dw GraphicArtistText
	dw WriterText
	dw DirectorText
	dw ChelleText
	dw GameFreakPCText1
	dw GameFreakPCText2
	dw GameFreakPCText3
	dw GameFreakSignText
	dw ChellePCText
	dw CeladonMansion3FTextB
	

CeladonMansion3F_ScriptPointers:
	dw CeladonMansion3FScript0
	dw ChelleAfterBattleScript

CeladonMansion3FResetScript:
	xor a
	ld [wJoyIgnore], a
	ld [wCeladonMansion3FCurScript], a
	ld [wCurMapScript], a
	ret

CeladonMansion3FScript0:
	ret

ProgrammerText:
	text_far _ProgrammerText
	text_end

GraphicArtistText:
	text_far _GraphicArtistText
	text_end

WriterText:
	text_far _WriterText
	text_end

DirectorText:
	text_asm
	ld hl, wPokedexOwned
	ld b, wPokedexOwnedEnd - wPokedexOwned
	call CountSetBits
	ld a, [wNumSetBits]
	cp NUM_POKEMON
	jr nc, .completed_dex
	ld hl, .GameDesignerText
	jr .done
.completed_dex
	SetEvent EVENT_GOT_DIPLOMA
	ld hl, .CompletedDexText
.done
	call PrintText
	jp TextScriptEnd

.GameDesignerText:
	text_far _GameDesignerText
	text_end

.CompletedDexText:
	text_far _CompletedDexText
	text_promptbutton
	text_asm
	callfar DisplayDiploma
	ld a, TRUE
	ld [wDoNotWaitForButtonPressAfterDisplayingText], a
	jp TextScriptEnd

GameFreakPCText1:
	text_far _CeladonMansion3Text5
	text_end

GameFreakPCText2:
	text_far _CeladonMansion3Text6
	text_end

GameFreakPCText3:
	text_far _CeladonMansion3Text7
	text_end

GameFreakSignText:
	text_far _CeladonMansion3Text8
	text_end

ChellePCText:
	text_far _ChellePCText
	text_end

ChelleText:
	text_asm
	ld hl, ChelleShhText
	call PrintText
	CheckEvent EVENT_BECOME_CHAMPION
	jr nz, .isChampion
	ld hl, ChelleNotYetText1
	call PrintText
	jp .done
.isChampion
	CheckEvent EVENT_BEAT_BROCK2
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_MISTY2
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_LT_SURGE2
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_ERIKA2
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_KOGA2
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_SABRINA2
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_BLAINE2
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_VIRIDIAN_GYM_RIVAL
	jr z, .gymLeader
	CheckEvent EVENT_BEAT_GIOVANNI2
	jr z, .giovanni
	CheckEvent EVENT_BEAT_CHAMPION_REMATCH
	jr nz, .readyToBattle
	ld hl, ChelleNotYetText4 ; .eliteFour
	call PrintText
	jr .done
.gymLeader
	ld hl, ChelleNotYetText2
	call PrintText
	jr .done
.giovanni
	ld hl, ChelleNotYetText3
	call PrintText
	jr .done
.readyToBattle
	ld hl, ChelleBattleText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .cancel
	ld hl, ChelleBattleConfirm
	call PrintText
	ld hl, wd72d
	set 6, [hl]
	set 7, [hl]
	ld hl, ChelleBattleWin
	ld de, ChelleBattleWin
	call SaveEndBattleTextPointers
	ldh a, [hSpriteIndex]
	ld [wSpriteIndex], a
	;call EngageMapTrainer
	;call InitBattleEnemyParameters
	ld a, OPP_CHELLE
	ld [wCurOpponent], a
	xor a
	ldh [hJoyHeld], a
	ld a, $1
	ld [wCeladonMansion3FCurScript], a
	ld [wCurMapScript], a
	ld [wTrainerNo], a
	ld [wIsTrainerBattle], a
	jr .done
.cancel
	ld hl, ChelleBattleCancelText
	call PrintText
.done
	jp TextScriptEnd
	
ChelleAfterBattleScript:
	ld a, [wIsInBattle]
	cp $ff
	jp z,  CeladonMansion3FResetScript
	ld a, $f0
	ld [wJoyIgnore], a
ChelleAfterBattleWin:
	ld a, $B
	ldh [hSpriteIndexOrTextID], a
	call DisplayTextID
.done
	jp CeladonMansion3FResetScript

CeladonMansion3FTextB:
	text_asm
	ld hl, ChelleAfterBattleText
	call PrintText
	CheckEvent EVENT_GOT_DIPLOMA
	jr nz, .done
	ld hl, ChelleDiplomaText
	call PrintText
.done
	jp TextScriptEnd


ChelleShhText:
	text_far _ChelleShhText
	text_end

ChelleBattleCancelText:
	text_far _ChelleBattleCancelText
	text_end
	
ChelleBattleText:
	text_far _ChelleBattleText
	text_end

ChelleBattleConfirm:
	text_far _ChelleBattleConfirm
	text_end
	
ChelleBattleWin:
	text_far _ChelleBattleWin
	text_end
	
ChelleAfterBattleText:
	text_far _ChelleAfterBattleText
	text_end
	
ChelleDiplomaText:
	text_far _ChelleDiplomaText
	text_end
	
ChelleNotYetText1:
	text_far _ChelleNotYetText1
	text_end
	
	
ChelleNotYetText2:
	text_far _ChelleNotYetText2
	text_end
	
	
ChelleNotYetText3:
	text_far _ChelleNotYetText3
	text_end
	
	
ChelleNotYetText4:
	text_far _ChelleNotYetText4
	text_end