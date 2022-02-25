MrPsychicsHouse_Script:
	jp EnableAutoTextBoxDrawing

MrPsychicsHouse_TextPointers:
	dw SaffronHouse2Text1

SaffronHouse2Text1:
	text_asm
	CheckEvent EVENT_GOT_TM29
	jr nz, .got_item
	ld hl, TM29PreReceiveText
	call PrintText
	lb bc, TM_PSYCHIC_M, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, ReceivedTM29Text
	call PrintText
	SetEvent EVENT_GOT_TM29
	ld hl, TM29ExplanationText
	call PrintText
	jr .done
.bag_full
	ld hl, TM29NoRoomText
	call PrintText
	jr .done
.got_item	
	ld hl, .Text1
	call PrintText
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jp nz, .choseNo
	ldh [hMoney], a
	ldh [hMoney + 2], a
	ld a, $40
	ldh [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, .NoMoneyText
	jr .printText
.enoughMoney
	lb bc, TM_PSYCHIC_M, 1
	call GiveItem
	jr nc, .bag_full
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, $40
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, ReceivedTM29Text
	call PrintText
	jr .done
.choseNo
	ld hl, .RefuseText
	jr .printText
.printText
	call PrintText

.done
	jp TextScriptEnd

.Text1
	text_far _MrPsychicText1
	text_end

.RefuseText
	text_far _MrPsychicNoText
	text_end

.NoMoneyText
	text_far _MrPsychicNoMoneyText
	text_end


TM29PreReceiveText:
	text_far _TM29PreReceiveText
	text_end

ReceivedTM29Text:
	text_far _ReceivedTM29Text
	sound_get_item_1
	text_end

TM29ExplanationText:
	text_far _TM29ExplanationText
	text_end

TM29NoRoomText:
	text_far _TM29NoRoomText
	text_end

