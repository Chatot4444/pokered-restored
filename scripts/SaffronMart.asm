SaffronMart_Script:
	call SaffronMart_Badge_Script
	jp EnableAutoTextBoxDrawing

SaffronMart_Badge_Script:
	xor a
	ld [wUnusedCC5B], a
	ld a, [wObtainedBadges]
	bit BIT_MARSHBADGE, a
	jr z, .done
	ld a, $1
	ld [wUnusedCC5B], a
.done
	ret


SaffronMart_TextPointers:
	dw SaffronCashierText
	dw SaffronMartText2
	dw SaffronMartText3


SaffronMartText2:
	text_far _SaffronMartText2
	text_end

SaffronMartText3:
	text_far _SaffronMartText3
	text_end
