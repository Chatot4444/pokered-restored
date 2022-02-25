SilphCo1F_Script:
	call EnableAutoTextBoxDrawing
	CheckEvent EVENT_BEAT_SILPH_CO_GIOVANNI
	ret z
	CheckAndSetEvent EVENT_SILPH_CO_RECEPTIONIST_AT_DESK
	ret nz
	ld a, HS_SILPH_CO_1F_RECEPTIONIST
	ld [wMissableObjectIndex], a
	predef_jump ShowObject
	ld a, HS_SILPH_CO_1F_CASHIER
	ld [wMissableObjectIndex], a
	predef_jump ShowObject

SilphCo1F_TextPointers:
	dw SilphCo1Text1
	dw SilphCo1CashierText

SilphCo1Text1:
	text_far _SilphCo1Text1
	text_end

SilphCo1CashierText::
	script_mart TM_SWORDS_DANCE, TM_WATER_GUN, TM_PAY_DAY, TM_FLAMETHROWER, TM_SOLARBEAM, TM_THUNDER, TM_TELEPORT, TM_SELFDESTRUCT, TM_SWIFT, TM_SKULL_BASH, TM_REST