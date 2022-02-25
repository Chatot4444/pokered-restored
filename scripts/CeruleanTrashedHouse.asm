CeruleanTrashedHouse_Script:
	call EnableAutoTextBoxDrawing
	ret

CeruleanTrashedHouse_TextPointers:
	dw CeruleanHouseTrashedText1
	dw CeruleanHouseTrashedText2
	dw CeruleanHouseTrashedText3

CeruleanHouseTrashedText1:
	text_asm
	CheckEvent EVENT_BEAT_CERULEAN_ROCKET_THIEF
	jr z, .no_dig_tm
	ld hl, CeruleanHouseTrashedText_1d6b0
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
	lb bc, TM_DIG, 1
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
	ld hl, ReceivedTM28Text3
	call PrintText
	jr .done
.choseNo
	ld hl, .RefuseText
	jr .printText
.printText
	call PrintText
	jr .done
.no_dig_tm
	ld hl, CeruleanHouseTrashedText_1d6ab
	call PrintText
.done
	jp TextScriptEnd
	
.RefuseText
	text_far _CeruleanHouseTrashedNoText
	text_end

.NoMoneyText
	text_far _CeruleanHouseTrashedNoMoneyText
	text_end

.bag_full
	ld hl, CeruleanHouseTrashedNoRoomText
	jr .printText
	
	
CeruleanHouseTrashedNoRoomText:
	text_far _CeruleanHouseTrashedNoRoomText
	text_end

ReceivedTM28Text3:
	text_far _ReceivedTM28Text3
	text_end

CeruleanHouseTrashedText_1d6ab:
	text_far _CeruleanTrashedText_1d6ab
	text_end

CeruleanHouseTrashedText_1d6b0:
	text_far _CeruleanTrashedText_1d6b0
	text_end

CeruleanHouseTrashedText2:
	text_far _CeruleanHouseTrashedText2
	text_end

CeruleanHouseTrashedText3:
	text_far _CeruleanHouseTrashedText3
	text_end
