CeladonMart1F_Script:
	xor a
	ld [wUnusedCC5B], a
	jp EnableAutoTextBoxDrawing

CeladonMart1F_TextPointers:
	dw CeladonMart1Text1
	dw CeladonMart1Text2
	dw CeladonMart1Text3

CeladonMart1Text1:
	text_far _CeladonMart1Text1
	text_end

CeladonMart1Text2:
	text_far _CeladonMart1Text2
	text_end

CeladonMart1Text3:
	text_far _CeladonMart1Text3
	text_end
