VermilionMart_Script:
	call VermilionMart_Badge_Script
	jp EnableAutoTextBoxDrawing

VermilionMart_Badge_Script:
	xor a
	ld [wUnusedCC5B], a
	ld a, [wObtainedBadges]
	bit BIT_THUNDERBADGE, a
	jr z, .done
	ld a, $1
	ld [wUnusedCC5B], a
.done
	ret



VermilionMart_TextPointers:
	dw VermilionCashierText
	dw VermilionMartText2
	dw VermilionMartText3


VermilionMartText2:
	text_far _VermilionMartText2
	text_end

VermilionMartText3:
	text_far _VermilionMartText3
	text_end
