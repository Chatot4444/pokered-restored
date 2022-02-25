CeruleanMart_Script:
	call CeruleanMart_Badge_Script
	jp EnableAutoTextBoxDrawing

CeruleanMart_Badge_Script:
	xor a
	ld [wUnusedCC5B], a
	ld a, [wObtainedBadges]
	bit BIT_CASCADEBADGE, a
	jr z, .done
	ld a, $1
	ld [wUnusedCC5B], a
.done
	ld hl, CeruleanMart_TextPointers
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	ret


	
CeruleanMart_TextPointers:
	dw CeruleanCashierText
	dw CeruleanMartText2
	dw CeruleanMartText3
	

CeruleanMartText2:
	text_far _CeruleanMartText2
	text_end

CeruleanMartText3:
	text_far _CeruleanMartText3
	text_end
