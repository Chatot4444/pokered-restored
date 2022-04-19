RedsHouse2F_Script:
	call EnableAutoTextBoxDrawing
	ld hl, RedsHouse2F_ScriptPointers
	ld a, [wRedsHouse2FCurScript]
	jp CallFunctionInTable

RedsHouse2F_ScriptPointers:
	dw RedsHouse2FScript0
	dw RedsHouse2FScript1

RedsHouse2FScript0:
	xor a
	ldh [hJoyHeld], a
	ld a, PLAYER_DIR_UP
	ld [wPlayerMovingDirection], a
	ld a, 1
	ld [wRedsHouse2FCurScript], a
	ret

RedsHouse2FScript1:
	ret

RedsHouse2F_TextPointers:
	dw RedsHouse2FText1
	
RedsHouse2FText1:
	text_far _GameGenieInstructions
	text_end
	
	
	; text_asm
	; ld hl, .OptionsText
	; call PrintText
	; call YesNoChoice
	; ld a, [wCurrentMenuItem]
	; and a
	; jp nz, .done
	; ld hl, .FieldMoveOptionText
	; call PrintText
	; call YesNoChoice
	; ld a, [wCurrentMenuItem]
	; ld b, a
	; ld a, [wOptions2]
	; or b
	; ld [wOptions2], a
	; ld hl, .BadgeBoostGlitchOptionText
	; call PrintText
	; call YesNoChoice
	; ld a, [wCurrentMenuItem]
	; sla a
	; ld b, a
	; ld a, [wOptions2]
	; or b
	; ld [wOptions2], a
	; ld hl, .BadgeBoostEnableOptionText
	; call PrintText
	; call YesNoChoice
	; ld a, [wCurrentMenuItem]
	; sla a
	; sla a
	; ld b, a
	; ld a, [wOptions2]
	; or b
	; ld [wOptions2], a
	; ld hl, .BadgeBoostEnemyOptionText
	; call PrintText
	; call YesNoChoice
	; ld a, [wCurrentMenuItem]
	; sla a
	; sla a
	; sla a
	; ld b, a
	; ld a, [wOptions2]
	; or b
	; ld [wOptions2], a
; .done
	; jp TextScriptEnd
	
	
; .OptionsText
	; text_far _NewOptionsText
	; text_end

; .FieldMoveOptionText
	; text_far _FieldMoveOptionText
	; text_end
	
; .BadgeBoostGlitchOptionText
	; text_far _BadgeBoostGlitchOptionText
	; text_end
	
; .BadgeBoostEnableOptionText
	; text_far _BadgeBoostEnableOptionText
	; text_end
	
; .BadgeBoostEnemyOptionText
	; text_far _BadgeBoostEnemyOptionText
	; text_end
	