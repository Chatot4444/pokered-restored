CinnabarMart_Script:
	call CinnabarMart_Badge_Script
	jp EnableAutoTextBoxDrawing

CinnabarMart_Badge_Script:
	xor a
	ld [wUnusedCC5B], a
	ld a, [wObtainedBadges]
	bit BIT_VOLCANOBADGE, a
	jr z, .done
	ld a, $1
	ld [wUnusedCC5B], a
.done
	ret


CinnabarMart_TextPointers:
	dw CinnabarCashierText
	dw CinnabarMartText2
	dw CinnabarMartText3


CinnabarMartText2:
	text_far _CinnabarMartText2
	text_end

CinnabarMartText3:
	text_far _CinnabarMartText3
	text_end
