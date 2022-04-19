CeladonMart2F_Script:
	call CeladonMart_Badge_Script
	jp EnableAutoTextBoxDrawing

CeladonMart_Badge_Script:
	xor a
	ld [wUnusedCC5B], a
	ld a, [wObtainedBadges]
	bit BIT_RAINBOWBADGE, a
	jr z, .done
	ld a, $1
	ld [wUnusedCC5B], a
.done
	ret



CeladonMart2F_TextPointers:
	dw CeladonMart2Clerk1Text
	dw CeladonMart2Clerk2Text
	dw CeladonMart2Text3
	dw CeladonMart2Text4
	dw CeladonMart2Text5


	
CeladonMart2Text3:
	text_far _CeladonMart2Text3
	text_end

CeladonMart2Text4:
	text_far _CeladonMart2Text4
	text_end

CeladonMart2Text5:
	text_far _CeladonMart2Text5
	text_end
