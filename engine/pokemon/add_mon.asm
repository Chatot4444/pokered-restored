_AddPartyMon::
; Adds a new mon to the player's or enemy's party.
; [wMonDataLocation] is used in an unusual way in this function.
; If the lower nybble is 0, the mon is added to the player's party, else the enemy's.
; If the entire value is 0, then the player is allowed to name the mon.
	ld de, wPartyCount
	ld a, [wMonDataLocation]
	and $f
	jr z, .next
	ld de, wEnemyPartyCount
.next
	ld a, [de]
	inc a
	cp PARTY_LENGTH + 1
	ret nc ; return if the party is already full
	ld [de], a
	ld a, [de]
	ldh [hNewPartyLength], a
	add e
	ld e, a
	jr nc, .noCarry
	inc d
.noCarry
	ld a, [wcf91]
	ld [de], a ; write species of new mon in party list
	inc de
	ld a, $ff ; terminator
	ld [de], a
	ld hl, wPartyMonOT
	ld a, [wMonDataLocation]
	and $f
	jr z, .next2
	ld hl, wEnemyMonOT
.next2
	ldh a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wPlayerName
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMonDataLocation]
	and a
	jr nz, .skipNaming
	ld hl, wPartyMonNicks
	ldh a, [hNewPartyLength]
	dec a
	call SkipFixedLengthTextEntries
	ld a, NAME_MON_SCREEN
	ld [wNamingScreenType], a
	predef AskName
.skipNaming
	ld hl, wPartyMons
	ld a, [wMonDataLocation]
	and $f
	jr z, .next3
	ld hl, wEnemyMons
.next3
	ldh a, [hNewPartyLength]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	push hl
	ld a, [wcf91]
	ld [wd0b5], a
	call GetMonHeader
	ld hl, wMonHeader
	ld a, [hli]
	ld [de], a ; species
	inc de
	pop hl
	push hl
	ld a, [wMonDataLocation] 
	and $f  ; check if adding mon to enemy trainer party
	jr z, .playerMon
	ld a, [wGymLeaderNo]
	and a
	jr z, .notGymLeaderRematch
	cp $9
	ld b, $4
	jr z, .gotTrainerNo
	srl b
.gotTrainerNo
	ld a, [wTrainerNo]
	cp b
	jr nz, .notGymLeaderRematch
	ld hl, wCurEnemyLVL
	ld a, [wRematchWinCount]
	inc a
.rematchLoop
	dec a
	jr z, .notGymLeaderRematch
	inc [hl]
	jr .rematchLoop
	
.notGymLeaderRematch
	ld a, [wDVOptions]
	and %00001100
	jr nz, .notNormalEnemy
	ld a, ATKDEFDV_TRAINER  ; set enemy trainer mon IVs to fixed average values
	ld b, SPDSPCDV_TRAINER
	jr .next4
.notNormalEnemy
	cp $1
	jr z, .random
	cp $3
	ld a, $FF
	ld b, a
	jr z, .next4
	xor a
	ld b, a
	jr .next4
	
; If the mon is being added to the player's party, update the pokedex.
.playerMon	
	ld a, [wcf91]
	ld [wd11e], a
	push de
	predef IndexToPokedex
	pop de
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_TEST
	ld hl, wPokedexOwned
	call FlagAction
	ld a, c ; whether the mon was already flagged as owned
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	push bc
	call FlagAction
	pop bc
	ld hl, wPokedexSeen
	call FlagAction

	pop hl
	push hl

	ld a, [wIsInBattle]
	and a ; is this a wild mon caught in battle?
	jr z, .notWild
	ld a, [wDVOptions]
	and %00000011
	cp $3
	jr nz, .copyEnemyMonData
	xor a
	ld b, a
	jr .next4

; Not wild.
.notWild
	ld a, [wDVOptions]
	and %00000011
	jr nz, .notNormal
.random
	call Random
	ld b, a
	call Random
	jr .next4
.notNormal
	and %00000010
	ld a, $FF
	ld b, a
	jr z, .next4
	xor a
	ld b, a

.next4
	push bc
	ld bc, wPartyMon1DVs - wPartyMon1
	add hl, bc
	pop bc
	ld [hli], a
	ld [hl], b         ; write IVs
	ld bc, (wPartyMon1HPExp - 1) - (wPartyMon1DVs + 1)
	add hl, bc
	ld a, 1
	ld c, a
	xor a
	ld b, a
	call _CalcStat      ; calc HP stat (set cur Hp to max HP)
	ldh a, [hMultiplicand+1]
	ld [de], a
	inc de
	ldh a, [hMultiplicand+2]
	ld [de], a
	inc de
	xor a
	ld [de], a         ; box level
	inc de
	ld [de], a         ; status ailments
	inc de
	jr .copyMonTypesAndMoves
.copyEnemyMonData
	ld bc, wEnemyMon1DVs - wEnemyMon1
	add hl, bc
	ld a, [wEnemyMonDVs] ; copy IVs from cur enemy mon
	ld [hli], a
	ld a, [wEnemyMonDVs + 1]
	ld [hl], a
	ld a, [wEnemyMonHP]    ; copy HP from cur enemy mon
	ld [de], a
	inc de
	ld a, [wEnemyMonHP+1]
	ld [de], a
	inc de
	xor a
	ld [de], a                ; box level
	inc de
	ld a, [wEnemyMonStatus]   ; copy status ailments from cur enemy mon
	ld [de], a
	inc de
.copyMonTypesAndMoves
	ld hl, wMonHTypes
	ld a, [hli]       ; type 1
	ld [de], a
	inc de
	ld a, [hli]       ; type 2
	ld [de], a
	inc de
	ld a, [hli]       ; catch rate (held item in gen 2)
	ld [de], a
	ld hl, wMonHMoves
	ld a, [hli]
	inc de
	push de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	ld a, [hli]
	inc de
	ld [de], a
	push de
	dec de
	dec de
	dec de
	xor a
	ld [wLearningMovesFromDayCare], a
	predef WriteMonMoves
	pop de
	ld a, [wPlayerID]  ; set trainer ID to player ID
	inc de
	ld [de], a
	ld a, [wPlayerID + 1]
	inc de
	ld [de], a
	push de
	ld a, [wCurEnemyLVL]
	ld d, a
	callfar CalcExperience
	pop de
	inc de
	ldh a, [hExperience] ; write experience
	ld [de], a
	inc de
	ldh a, [hExperience + 1]
	ld [de], a
	inc de
	ldh a, [hExperience + 2]
	ld [de], a
	xor a
	ld b, NUM_STATS * 2
.writeEVsLoop              ; set all EVs to 0
	inc de
	ld [de], a
	dec b
	jr nz, .writeEVsLoop
	inc de
	inc de
	pop hl
	call AddPartyMon_WriteMovePP
	inc de
	ld a, [wCurEnemyLVL]
	ld [de], a
	inc de
	ld a, [wIsInBattle]
	dec a
	jr nz, .calcFreshStats
	ld hl, wEnemyMonMaxHP
	ld bc, $a
	call CopyData          ; copy stats of cur enemy mon
	pop hl
	jr .done
.calcFreshStats
	pop hl
	ld bc, wPartyMon1HPExp - 1 - wPartyMon1
	add hl, bc
	ld b, $0
	call _CalcStats         ; calculate fresh set of stats
.done
	scf
	ret

LoadMovePPs:
	call GetPredefRegisters
	; fallthrough
AddPartyMon_WriteMovePP:
	ld b, NUM_MOVES
.pploop
	ld a, [hli]     ; read move ID
	and a
	jr z, .empty
	dec a
	push hl
	push de
	push bc
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wcd6d
	ld a, BANK(Moves)
	call FarCopyData
	pop bc
	pop de
	pop hl
	ld a, [wcd6d + 5] ; PP is byte 5 of move data
.empty
	inc de
	ld [de], a
	dec b
	jr nz, .pploop ; there are still moves to read
	ret

; adds enemy mon [wcf91] (at position [wWhichPokemon] in enemy list) to own party
; used in the cable club trade center
_AddEnemyMonToPlayerParty::
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	scf
	ret z            ; party full, return failure
	inc a
	ld [hl], a       ; add 1 to party members
	ld c, a
	ld b, $0
	add hl, bc
	ld a, [wcf91]
	ld [hli], a      ; add mon as last list entry
	ld [hl], $ff     ; write new sentinel
	ld hl, wPartyMons
	ld a, [wPartyCount]
	dec a
	ld bc, wPartyMon2 - wPartyMon1
	call AddNTimes
	ld e, l
	ld d, h
	ld hl, wLoadedMon
	call CopyData    ; write new mon's data (from wLoadedMon)
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonOT
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's OT name (from an enemy mon)
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
	ld hl, wEnemyMonNicks
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
	ld bc, NAME_LENGTH
	call CopyData    ; write new mon's nickname (from an enemy mon)
	ld a, [wcf91]
	ld [wd11e], a
	predef IndexToPokedex
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, FLAG_SET
	ld hl, wPokedexOwned
	push bc
	call FlagAction ; add to owned pokemon
	pop bc
	ld hl, wPokedexSeen
	call FlagAction ; add to seen pokemon
	and a
	ret                  ; return success

_MoveMon::
	ld a, [wMoveMonType]
	and a   ; BOX_TO_PARTY
	jr z, .checkPartyMonSlots
	cp DAYCARE_TO_PARTY
	jr z, .checkPartyMonSlots
	cp PARTY_TO_DAYCARE
	ld hl, wDayCareMon
	jr z, .findMonDataSrc
	; else it's PARTY_TO_BOX
	ld hl, wBoxCount
	ld a, [hl]
	cp MONS_PER_BOX
	jr nz, .partyOrBoxNotFull
	jr .boxFull
.checkPartyMonSlots
	ld hl, wPartyCount
	ld a, [hl]
	cp PARTY_LENGTH
	jr nz, .partyOrBoxNotFull
.boxFull
	scf
	ret
.partyOrBoxNotFull
	inc a
	ld [hl], a           ; increment number of mons in party/box
	ld c, a
	ld b, 0
	add hl, bc
	ld a, [wMoveMonType]
	cp DAYCARE_TO_PARTY
	ld a, [wDayCareMon]
	jr z, .copySpecies
	ld a, [wcf91]
.copySpecies
	ld [hli], a          ; write new mon ID
	ld [hl], $ff         ; write new sentinel
.findMonDataDest
	ld a, [wMoveMonType]
	dec a
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
	ld a, [wPartyCount]
	jr nz, .addMonOffset
	; if it's PARTY_TO_BOX
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	ld a, [wBoxCount]
.addMonOffset
	dec a
	call AddNTimes
.findMonDataSrc
	push hl
	ld e, l
	ld d, h
	ld a, [wMoveMonType]
	and a
	ld hl, wBoxMons
	ld bc, wBoxMon2 - wBoxMon1 ; $21
	jr z, .addMonOffset2
	cp DAYCARE_TO_PARTY
	ld hl, wDayCareMon
	jr z, .copyMonData
	ld hl, wPartyMons
	ld bc, wPartyMon2 - wPartyMon1 ; $2c
.addMonOffset2
	ld a, [wWhichPokemon]
	call AddNTimes
.copyMonData
	push hl
	push de
	ld bc, wBoxMon2 - wBoxMon1
	call CopyData
	pop de
	pop hl
	ld a, [wMoveMonType]
	and a ; BOX_TO_PARTY
	jr z, .findOTdest
	cp DAYCARE_TO_PARTY
	jr z, .findOTdest
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld a, [hl] ; hl = Level
	inc de
	inc de
	inc de
	ld [de], a ; de = BoxLevel
.findOTdest
	ld a, [wMoveMonType]
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonOT
	jr z, .findOTsrc
	dec a
	ld hl, wPartyMonOT
	ld a, [wPartyCount]
	jr nz, .addOToffset
	ld hl, wBoxMonOT
	ld a, [wBoxCount]
.addOToffset
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.findOTsrc
	ld hl, wBoxMonOT
	ld a, [wMoveMonType]
	and a
	jr z, .addOToffset2
	ld hl, wDayCareMonOT
	cp DAYCARE_TO_PARTY
	jr z, .copyOT
	ld hl, wPartyMonOT
.addOToffset2
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.copyOT
	ld bc, NAME_LENGTH
	call CopyData
	ld a, [wMoveMonType]
.findNickDest
	cp PARTY_TO_DAYCARE
	ld de, wDayCareMonName
	jr z, .findNickSrc
	dec a
	ld hl, wPartyMonNicks
	ld a, [wPartyCount]
	jr nz, .addNickOffset
	ld hl, wBoxMonNicks
	ld a, [wBoxCount]
.addNickOffset
	dec a
	call SkipFixedLengthTextEntries
	ld d, h
	ld e, l
.findNickSrc
	ld hl, wBoxMonNicks
	ld a, [wMoveMonType]
	and a
	jr z, .addNickOffset2
	ld hl, wDayCareMonName
	cp DAYCARE_TO_PARTY
	jr z, .copyNick
	ld hl, wPartyMonNicks
.addNickOffset2
	ld a, [wWhichPokemon]
	call SkipFixedLengthTextEntries
.copyNick
	ld bc, NAME_LENGTH
	call CopyData
	pop hl
	ld a, [wMoveMonType]
	cp PARTY_TO_BOX
	jr z, .done
	cp PARTY_TO_DAYCARE
	jr z, .done
	push hl
	srl a
	add $2
	ld [wMonDataLocation], a
	call LoadMonData
	farcall CalcLevelFromExperience
	ld a, d
	ld [wCurEnemyLVL], a
	pop hl
	ld bc, wBoxMon2 - wBoxMon1
	add hl, bc
	ld [hli], a
	ld d, h
	ld e, l
	ld bc, -18
	add hl, bc
	ld b, $1
	call _CalcStats
.done
	and a
	ret

_CalcStats::
	ld c, $0
.statsLoop
	inc c
	call _CalcStat
	ldh a, [hMultiplicand+1]
	ld [de], a
	inc de
	ldh a, [hMultiplicand+2]
	ld [de], a
	inc de
	ld a, c
	cp NUM_STATS
	jr nz, .statsLoop
	ret

_CalcStat::
	push hl
	push de
	push bc
	ld a, b
	ld d, a
	push hl
	ld hl, wMonHeader
	ld b, $0
	add hl, bc
	ld a, [hl]          ; read base value of stat
	ld e, a
	pop hl
	push hl
	sla c
	ld a, d
	and a
	jr z, .statExpDone  ; consider stat exp?
	add hl, bc          ; skip to corresponding stat exp value
.statExpLoop            ; calculates ceil(Sqrt(stat exp)) in b
	xor a
	ldh [hMultiplicand], a
	ldh [hMultiplicand+1], a
	inc b               ; increment current stat exp bonus
	ld a, b
	cp $ff
	jr z, .statExpDone
	ldh [hMultiplicand+2], a
	ldh [hMultiplier], a
	call Multiply
	ld a, [hld]
	ld d, a
	ldh a, [hProduct + 3]
	sub d
	ld a, [hli]
	ld d, a
	ldh a, [hProduct + 2]
	sbc d               ; test if (current stat exp bonus)^2 < stat exp
	jr c, .statExpLoop
.statExpDone
	srl c
	pop hl
	push bc
	ld bc, wPartyMon1DVs - (wPartyMon1HPExp - 1) ; also wEnemyMonDVs - wEnemyMonHP
	add hl, bc
	pop bc
	ld a, c
	cp $2
	jr z, .getAttackIV
	cp $3
	jr z, .getDefenseIV
	cp $4
	jr z, .getSpeedIV
	cp $5
	jr z, .getSpecialIV
.getHpIV
	push bc
	ld a, [hl]  ; Atk IV
	swap a
	and $1
	sla a
	sla a
	sla a
	ld b, a
	ld a, [hli] ; Def IV
	and $1
	sla a
	sla a
	add b
	ld b, a
	ld a, [hl] ; Spd IV
	swap a
	and $1
	sla a
	add b
	ld b, a
	ld a, [hl] ; Spc IV
	and $1
	add b      ; HP IV: LSB of the other 4 IVs
	pop bc
	jr .calcStatFromIV
.getAttackIV
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getDefenseIV
	ld a, [hl]
	and $f
	jr .calcStatFromIV
.getSpeedIV
	inc hl
	ld a, [hl]
	swap a
	and $f
	jr .calcStatFromIV
.getSpecialIV
	inc hl
	ld a, [hl]
	and $f
.calcStatFromIV
	ld d, $0
	add e
	ld e, a
	jr nc, .noCarry
	inc d                     ; de = Base + IV
.noCarry
	sla e
	rl d                      ; de = (Base + IV) * 2
	srl b
	srl b                     ; b = ceil(Sqrt(stat exp)) / 4
	ld a, b
	add e
	jr nc, .noCarry2
	inc d                     ; de = (Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4
.noCarry2
	ldh [hMultiplicand+2], a
	ld a, d
	ldh [hMultiplicand+1], a
	xor a
	ldh [hMultiplicand], a
	ld a, [wCurEnemyLVL]
	ldh [hMultiplier], a
	call Multiply            ; ((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level
	ldh a, [hMultiplicand]
	ldh [hDividend], a
	ldh a, [hMultiplicand+1]
	ldh [hDividend+1], a
	ldh a, [hMultiplicand+2]
	ldh [hDividend+2], a
	ld a, $64
	ldh [hDivisor], a
	ld a, $3
	ld b, a
	call Divide             ; (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100
	ld a, c
	cp $1
	ld a, 5 ; + 5 for non-HP stat
	jr nz, .notHPStat
	ld a, [wCurEnemyLVL]
	ld b, a
	ldh a, [hMultiplicand+2]
	add b
	ldh [hMultiplicand+2], a
	jr nc, .noCarry3
	ldh a, [hMultiplicand+1]
	inc a
	ldh [hMultiplicand+1], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level
.noCarry3
	ld a, 10 ; +10 for HP stat
.notHPStat
	ld b, a
	ldh a, [hMultiplicand+2]
	add b
	ldh [hMultiplicand+2], a
	jr nc, .noCarry4
	ldh a, [hMultiplicand+1]
	inc a                    ; non-HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + 5
	ldh [hMultiplicand+1], a ; HP: (((Base + IV) * 2 + ceil(Sqrt(stat exp)) / 4) * Level) / 100 + Level + 10
.noCarry4
	ldh a, [hMultiplicand+1] ; check for overflow (>999)
	cp HIGH(MAX_STAT_VALUE) + 1
	jr nc, .overflow
	cp HIGH(MAX_STAT_VALUE)
	jr c, .noOverflow
	ldh a, [hMultiplicand+2]
	cp LOW(MAX_STAT_VALUE) + 1
	jr c, .noOverflow
.overflow
	ld a, HIGH(MAX_STAT_VALUE) ; overflow: cap at 999
	ldh [hMultiplicand+1], a
	ld a, LOW(MAX_STAT_VALUE)
	ldh [hMultiplicand+2], a
.noOverflow
	pop bc
	pop de
	pop hl
	ret
	