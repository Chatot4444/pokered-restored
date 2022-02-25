FuchsiaMart_Script:
	call FuchsiaMart_Badge_Script
	jp EnableAutoTextBoxDrawing

FuchsiaMart_Badge_Script:
	xor a
	ld [wUnusedCC5B], a
	ld a, [wObtainedBadges]
	bit BIT_SOULBADGE, a
	jr z, .done
	ld a, $1
	ld [wUnusedCC5B], a	
.done
	ld hl, FuchsiaMart_TextPointers
	ld a, l
	ld [wMapTextPtr], a
	ld a, h
	ld [wMapTextPtr+1], a
	ret


FuchsiaMart_TextPointers:
	dw FuchsiaCashierText
	dw FuchsiaMartText2
	dw FuchsiaMartText3



FuchsiaMartText2:
	text_far _FuchsiaMartText2
	text_end

FuchsiaMartText3:
	text_far _FuchsiaMartText3
	text_end
