TryFieldMove:: ; predef
	call GetPredefRegisters
	call TrySurf
	ret z
	call TryCut
	ret

TrySurf:
	ld a, [wWalkBikeSurfState]
	cp 2 ; is the player already surfing?
	jr z, .no
	callfar IsNextTileShoreOrWater
	jr c, .no
	ld hl, TilePairCollisionsWater
	call CheckForTilePairCollisions2
	jr c, .no
	ld d, SURF
	call HasPartyMove
	jr nz, .no
	ld a, [wObtainedBadges]
	bit 4, a ; SOUL BADGE
	jr z, .no
	ld a, HM_SURF
	ld [wLastFieldMoveID], a
	call HasHM
	jr z, .no
	callfar IsSurfingAllowed
	ld hl, wd728
	bit 1, [hl]
	res 1, [hl]
	jr z, .no
	call InitializeFieldMoveTextBox
	ld hl, PromptToSurfText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, .no2
	call GetPartyMonName2
	ld a, SURFBOARD
	ld [wcf91], a
	ld [wPseudoItemID], a
	call UseItem
.yes2
	call CloseFieldMoveTextBox
.yes
	xor a
	ret
.no2
	call CloseFieldMoveTextBox
.no
	ld a, 1
	and a
	ret

TryCut:
	call IsCutTile
	jr nc, TrySurf.no
	call InitializeFieldMoveTextBox
	ld hl, ExplainCutText
	call PrintText
	call ManualTextScroll
	ld d, CUT
	call HasPartyMove
	jr nz, TrySurf.no2
	ld a, [wObtainedBadges]
	bit 1, a ; CASCADE BADGE
	jr z, TrySurf.no2
	ld a, HM_CUT
	ld [wLastFieldMoveID], a
	call HasHM
	jr z, TrySurf.no2
	ld hl, PromptToCutText
	call PrintText
	call YesNoChoice
	ld a, [wCurrentMenuItem]
	and a
	jr nz, TrySurf.no2
	call GetPartyMonName2
	callfar Cut2
	call CloseFieldMoveTextBox
	jr TrySurf.yes2

IsCutTile:
; partial copy from UsedCut
	ld a, [wCurMapTileset]
	and a ; OVERWORLD
	jr z, .overworld
	cp GYM
	jr nz, .no
	ld a, [wTileInFrontOfPlayer]
	cp $50 ; gym cut tree
	jr nz, .no
	jr .yes
.overworld
	ld a, [wTileInFrontOfPlayer]
	cp $3d ; cut tree
	jr nz, .no
.yes
	scf
	ret
.no
	and a
	ret

HasPartyMove::
; Return z (optional: in wWhichTrade) if a PartyMon has move d.
; Updates wWhichPokemon.
	push bc
	push de
	push hl

	ld a, [wPartyCount]
	and a
	jr z, .no
	ld b, a
	ld c, 0
	ld hl, wPartyMons + (wPartyMon1Moves - wPartyMon1)
.loop
	ld e, NUM_MOVES
.check_move
	ld a, [hli]
	cp d
	jr z, .yes
	dec e
	jr nz, .check_move

	ld a, wPartyMon2 - wPartyMon1 - NUM_MOVES
	add l
	ld l, a
	adc h
	sub l
	ld h, a

	inc c
	ld a, c
	cp b
	jr c, .loop
	jr .notYet

.yes
	ld a, c
	ld [wWhichPokemon], a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld a, [hl]
	ld [wcf91], a
	xor a ; probably redundant
	ld [wWhichTrade], a
	jr .done
.notYet
	ld hl, wPartyMons
	ld e, 0
.loop2
	ld a, [hl]
	ld bc, MonFieldMoves
	add c
	ld c, a
	adc b
	sub c
	ld b, a
	ld a, [bc]
	cp d
	ld c, e
	jr z, .yes
	inc e
	ld bc, wPartyMon2 - wPartyMon1
	add hl, bc
	ld a, [wPartyCount]
	cp e
	jr nz, .loop2
.no
	ld a, 1
	and a
	ld [wWhichTrade], a
.done
	pop hl
	pop de
	pop bc
	ret

InitializeFieldMoveTextBox:
	call EnableAutoTextBoxDrawing
	ld a, 1 ; not 0
	ld [hSpriteIndexOrTextID], a
	callfar DisplayTextIDInit
	ret

CloseFieldMoveTextBox:
	ld a,[hLoadedROMBank]
	push af
	jp CloseTextDisplay

HasHM::       ; input: HM constant in wLastFieldMoveID output: z
	ld a, [wOptions] ;to do: make new options
	bit 7, a
	ret nz
	ld a, [wLastFieldMoveID]
	ld b, a
	push bc
	call IsItemInBag
	pop bc
	jr nz, .next
	call IsItemInPC
	jr nz, .next
	ld a, HM_CUT
	ld b, a
	ld a, [wLastFieldMoveID]
	sub b
	add a
	ld b, 0
	ld c, a
	ld hl, .gotHMEvents
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl
.gotHMEvents
	dw .cut
	dw .fly
	dw .surf
	dw .strength
	dw .flash
.cut
	CheckEvent EVENT_GOT_HM01
	jp .next
.fly
	CheckEvent EVENT_GOT_HM02
	jp .next
.surf
	CheckEvent EVENT_GOT_HM03
	jp .next
.strength
	CheckEvent EVENT_GOT_HM04
	jp .next
.flash
	CheckEvent EVENT_GOT_HM05
.next    ; if can use, z flag will be reset
	ret
	
	

PromptToSurfText:
	text "The water is calm."
	line "Would you like to"
	cont "SURF?@@"

ExplainCutText:
	text "This tree can be"
	line "CUT!@@"

PromptToCutText:
	text "Would you like to"
	line "use CUT?@@"
