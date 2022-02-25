CinnabarLabMetronomeRoom_Script:
	jp EnableAutoTextBoxDrawing

CinnabarLabMetronomeRoom_TextPointers:
	dw Lab3Text1
	dw Lab3Text2
	dw Lab3Text3
	dw Lab3Text4
	dw Lab3Text5

Lab3Text1:
	text_asm
	CheckEvent EVENT_GOT_TM35
	jr nz, .got_item
	ld hl, TM35PreReceiveText
	call PrintText
	lb bc, TM_METRONOME, 1
	call GiveItem
	jr nc, .bag_full
	ld hl, ReceivedTM35Text
	call PrintText
	SetEvent EVENT_GOT_TM35
	ld hl, TM35ExplanationText
	call PrintText
	jr .done
.bag_full
	ld hl, TM35NoRoomText
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
	lb bc, TM_METRONOME, 1
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
	ld hl, ReceivedTM35Text
	call PrintText
	ld hl, TM35ExplanationText
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
	text_far _CinnabarLabMetronomeRoomText1
	text_end
	
.RefuseText
	text_far _CinnabarLabMetronomeRoomNoText
	text_end

.NoMoneyText
	text_far _CinnabarLabMetronomeRoomNoMoneyText
	text_end
	
TM35PreReceiveText:
	text_far _TM35PreReceiveText
	text_end

ReceivedTM35Text:
	text_far _ReceivedTM35Text
	sound_get_item_1
	text_end

TM35ExplanationText:
	text_far _TM35ExplanationText
	text_end

TM35NoRoomText:
	text_far _TM35NoRoomText
	text_end

Lab3Text2:
	text_far _Lab3Text2
	text_end

Lab3Text4:
Lab3Text3:
	text_far _Lab3Text3
	text_end

Lab3Text5:
	text_far _Lab3Text5
	text_end
