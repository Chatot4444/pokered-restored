CeladonMart3F_Script:
	jp EnableAutoTextBoxDrawing

CeladonMart3F_TextPointers:
	dw CeladonMart3Text1
	dw CeladonMart3Text2
	dw CeladonMart3Text3
	dw CeladonMart3Text4
	dw CeladonMart3Text5
	dw CeladonMart3Text6
	dw CeladonMart3Text7
	dw CeladonMart3Text8
	dw CeladonMart3Text9
	dw CeladonMart3Text10
	dw CeladonMart3Text11
	dw CeladonMart3Text12
	dw CeladonMart3Text13
	dw CeladonMart3Text14
	dw CeladonMart3Text15
	dw CeladonMart3Text16
	dw CeladonMart3Text17

CeladonMart3Text1:
	text_asm
	CheckEvent EVENT_GOT_TM18
	jr nz, .got_item
	ld hl, TM18PreReceiveText
	call PrintText
	lb bc, TM_COUNTER, 1
	call GiveItem
	jr nc, .bag_full
	SetEvent EVENT_GOT_TM18
	ld hl, ReceivedTM18Text
	call PrintText
	ld hl, TM18ExplanationText
	jr .done
.bag_full
	ld hl, TM18NoRoomText
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
	ld a, $20
	ldh [hMoney + 1], a
	call HasEnoughMoney
	jr nc, .enoughMoney
	ld hl, .NoMoneyText
	jr .printText
.enoughMoney
	lb bc, TM_COUNTER, 1
	call GiveItem
	jr nc, .bag_full
	xor a
	ld [wPriceTemp], a
	ld [wPriceTemp + 2], a
	ld a, $20
	ld [wPriceTemp + 1], a
	ld hl, wPriceTemp + 2
	ld de, wPlayerMoney + 2
	ld c, $3
	predef SubBCDPredef
	ld a, MONEY_BOX
	ld [wTextBoxID], a
	call DisplayTextBoxID
	ld hl, ReceivedTM18Text
	call PrintText
	jr .done
.choseNo
	ld hl, .RefuseText
	jr .printText
.printText
	call PrintText
.done
	call PrintText
	jp TextScriptEnd

.Text1
	text_far _CeladonMart3Text1
	text_end

.RefuseText
	text_far _CeladonMart3NoText
	text_end

.NoMoneyText
	text_far _CeladonMart3NoMoneyText
	text_end

TM18PreReceiveText:
	text_far _TM18PreReceiveText
	text_end

ReceivedTM18Text:
	text_far _ReceivedTM18Text
	sound_get_item_1
	text_end

TM18ExplanationText:
	text_far _TM18ExplanationText
	text_end

TM18NoRoomText:
	text_far _TM18NoRoomText
	text_end

CeladonMart3Text2:
	text_far _CeladonMart3Text2
	text_end

CeladonMart3Text3:
	text_far _CeladonMart3Text3
	text_end

CeladonMart3Text4:
	text_far _CeladonMart3Text4
	text_end

CeladonMart3Text5:
	text_far _CeladonMart3Text5
	text_end

CeladonMart3Text12:
CeladonMart3Text10:
CeladonMart3Text8:
CeladonMart3Text6:
	text_far _CeladonMart3Text6
	text_end

CeladonMart3Text7:
	text_far _CeladonMart3Text7
	text_end

CeladonMart3Text9:
	text_far _CeladonMart3Text9
	text_end

CeladonMart3Text11:
	text_far _CeladonMart3Text11
	text_end

CeladonMart3Text13:
	text_far _CeladonMart3Text13
	text_end

CeladonMart3Text14:
	text_far _CeladonMart3Text14
	text_end

CeladonMart3Text17:
CeladonMart3Text16:
CeladonMart3Text15:
	text_far _CeladonMart3Text15
	text_end
