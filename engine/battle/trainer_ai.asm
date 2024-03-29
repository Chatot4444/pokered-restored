; creates a set of moves that may be used and returns its address in hl

; unused slots are filled with 0, all used slots may be chosen with equal probability
AIEnemyTrainerChooseMoves:
	ld a, [wActionResultOrTookBattleTurn]
	cp 3
	jr nz, .skipLoadingOldType
	ld a, [wTrainerClass]
	cp PSYCHIC_TR
	jr c, .loadOldType
	cp GIOVANNI
	ld b, $7F
	jr z, .getRandom
	cp CHANNELER
	jr nc, .getRandom
	ld b, $3F
.getRandom	
	call Random
	cp b
	jr c, .skipLoadingOldType
.loadOldType
	ld a, [wSwitchedMonType1]
	ld b, a
	ld a, [wBattleMonType]
	ld [wSwitchedMonType1], a
	ld a, b
	ld [wBattleMonType], a
	ld a, [wSwitchedMonType2]
	ld b, a
	ld a, [wBattleMonType2]
	ld [wSwitchedMonType2], a
	ld a, b
	ld [wBattleMonType2], a
	ld hl, wUnusedC000
	set 6, [hl]
.skipLoadingOldType
	ld a, $a
	ld hl, wBuffer ; init temporary move selection array. Only the moves with the lowest numbers are chosen in the end
	ld [hli], a   ; move 1
	ld [hli], a   ; move 2
	ld [hli], a   ; move 3
	ld [hl], a    ; move 4
	
	;joenote - make a backup buffer
	push hl
	ld a, $ff
	inc hl
	ld [hli], a	;backup 1
	ld [hli], a	;backup 2
	ld [hli], a	;backup 3
	ld [hl], a	;backup 4
	pop hl
	
	;joenote - backup the power of the last moved used
	ld a, [wEnemyMovePower]
	ld [wAILastMovePower], a
	
	ld a, [wEnemyDisabledMove] ; forbid disabled move (if any)
	swap a
	and $f
	jr z, .noMoveDisabled
	ld hl, wBuffer
	dec a
	ld c, a
	ld b, $0
	add hl, bc    ; advance pointer to forbidden move
	ld [hl], $50  ; forbid (highly discourage) disabled move
.noMoveDisabled
	ld hl, TrainerClassMoveChoiceModifications
	ld a, [wTrainerClass]
	ld b, a
.loopTrainerClasses
	dec b
	jr z, .readTrainerClassData
.loopTrainerClassData
	ld a, [hli]
	and a
	jr nz, .loopTrainerClassData
	jr .loopTrainerClasses
.readTrainerClassData
	ld a, [hl]
	and a
	jp z, .useOriginalMoveSet
	push hl
.nextMoveChoiceModification
	pop hl
	ld a, [hli]
	and a
	jr z, .loopFindMinimumEntries_backupfirst
	push hl
	ld hl, AIMoveChoiceModificationFunctionPointers
	dec a
	add a
	ld c, a
	ld b, 0
	add hl, bc    ; skip to pointer
	ld a, [hli]   ; read pointer into hl
	ld h, [hl]
	ld l, a
	ld de, .nextMoveChoiceModification  ; set return address
	push de
	jp hl         ; execute modification function
.loopFindMinimumEntries_backupfirst	;joenote - make a backup of the scores
	ld hl, wBuffer  ; temp move selection array
	ld de, wBuffer + NUM_MOVES  ;backup buffer
	ld bc, NUM_MOVES
	call CopyData
.loopFindMinimumEntries ; all entries will be decremented sequentially until one of them is zero
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.loopDecrementEntries
	ld a, [de]
	inc de
	and a
	jr z, .loopFindMinimumEntries
	dec [hl]
	jr z, .minimumEntriesFound
	inc hl
	dec c
	jr z, .loopFindMinimumEntries
	jr .loopDecrementEntries
.minimumEntriesFound
	ld a, c
.loopUndoPartialIteration ; undo last (partial) loop iteration
	inc [hl]
	dec hl
	inc a
	cp NUM_MOVES + 1
	jr nz, .loopUndoPartialIteration
	ld hl, wBuffer  ; temp move selection array
	ld de, wEnemyMonMoves  ; enemy moves
	ld c, NUM_MOVES
.filterMinimalEntries ; all minimal entries now have value 1. All other slots will be disabled (move set to 0)
	ld a, [de]
	and a
	jr nz, .moveExisting
	ld [hl], a
.moveExisting
	ld a, [hl]
	dec a
	jr z, .slotWithMinimalValue
	xor a
	ld [hli], a     ; disable move slot
	jr .next
.slotWithMinimalValue
	ld a, [de]
	ld [hli], a     ; enable move slot
.next
	inc de
	dec c
	jr nz, .filterMinimalEntries
	ld hl, wBuffer    ; use created temporary array as move set
	jr .switchBackType
.useOriginalMoveSet
	ld hl, wEnemyMonMoves    ; use original move set
.switchBackType
	push hl
	ld hl, wUnusedC000
	bit 6, [hl]
	jr z, .notSwitched
	res 6, [hl]
	ld a, [wSwitchedMonType1]
	ld b, a
	ld a, [wBattleMonType]
	ld [wSwitchedMonType1], a
	ld a, b
	ld [wBattleMonType], a
	ld a, [wSwitchedMonType2]
	ld b, a
	ld a, [wBattleMonType2]
	ld [wSwitchedMonType2], a
	ld a, b
	ld [wBattleMonType2], a
.notSwitched
	pop hl
	ret

AIMoveChoiceModificationFunctionPointers:
	dw AIMoveChoiceModification1 ; status moves
	dw AIMoveChoiceModification2 ; setup moves
	dw AIMoveChoiceModification3 ; effectiveness
	dw AIMoveChoiceModification4 ; used for switching now

; discourages moves that cause no damage but only a status ailment if player's mon already has one
AIMoveChoiceModification1:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - kick out if no-attack bit is set
	ld a, [wUnusedC000]
	bit 2, a
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wBattleMonStatus]
	and a
	;joenote - don't return yet. going to check for dream eater. will do this later
	;ret z ; return if no status ailment on player's mon
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use effects that end battle because this is a trainer battle and they do not work
	;ld a, [wEnemyMoveEffect]	;load the move effect
	;cp SWITCH_AND_TELEPORT_EFFECT	;see if it is a battle-ending effect
	;jp z, .heavydiscourage	;heavily discourage if so
;and dont try to use rage either
;	cp RAGE_EFFECT	
;	jp z, .heavydiscourage
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use dream eater if enemy not asleep, otherwise encourage it
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp DREAM_EATER_EFFECT	;see if it is dream eater
	jr nz, .notdreameater	;skip out if move is not dream eater
	ld a, [wBattleMonStatus]	;load the player pkmn non-volatile status
	and $7	;check bits 0 to 2 for sleeping turns
	jp z, .heavydiscourage	;heavily discourage using dream eater on non-sleeping pkmn
	dec [hl]	;else slightly encourage dream eater's use on a sleeping pkmn
	jp .nextMove
.notdreameater	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use counter against a non-applicable move
	ld a, [wEnemyMoveNum]	
	cp COUNTER
	jr nz, .countercheck_end	;if this move is not counter then jump out
	ld a, [wPlayerMovePower]
	and a
	jp z, .heavydiscourage	;heavily discourage counter if enemy is using zero-power move
	ld a, [wPlayerMoveType]
	cp SPECIAL
	jr c, .countercheck_end	; skip ahead if countering physical move
	ld a, [wPlayerMoveEffect]
	cp PHYS_BURN_SIDE_EFFECT1 ;check for elemental punches (they are physical in this hack) 
	jr nc, .countercheck_end
	jp .heavydiscourage	;else heavily discourage since the player move type is not applicable to counter
.countercheck_end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use moves that are ineffective against substitute if a substitute is up
	ld a, [wPlayerBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a	;check for substitute bit
	jr z, .noSubImm	;if the substitute bit is not set, then skip out of this block
	ld a, [wEnemyMoveEffect]	;get the move effect into a
	push hl
	push de
	push bc
	ld hl, SubstituteImmuneEffects
	ld de, $0001
	call IsInArray	;see if a is found in the hl array (carry flag set if true)
	pop bc
	pop de
	pop hl
	jp c, .heavydiscourage	;carry flag means the move effect is blocked by substitute
	;else continue onward
.noSubImm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Heavily discourage healing or exploding moves if HP is full. Encourage if hp is low
;Exploding has a slight preference over healing because overall this hurts the player more than the AI
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp HEAL_EFFECT	;see if it is a healing move
	jr z, .heal_explode	;skip out if move is not
	cp EXPLODE_EFFECT	;what about an explosion effect?
	jr nz, .not_heal_explode	;skip out if move is not
	dec [hl]	;give a slight edge to exploding
.heal_explode
	ld a, 1	;
	call AICheckIfHPBelowFraction
	jp nc, .heavydiscourage	;heavy discourage if hp at max (heal +5 & explode +4)
	inc [hl]	;1/2 hp to max hp - slight discourage (heal +1 & explode 0)
	ld a, 2	;
	call AICheckIfHPBelowFraction
	jp nc, .nextMove	;if hp is 1/2 or more, get next move
	dec [hl]	;else 1/3 to 1/2 hp - neutral (heal 0 & explode -1)
	ld a, 3	;
	call AICheckIfHPBelowFraction
	jp nc, .nextMove	;if hp is 1/3 or more, get next move
	dec [hl]	;else 0 to 1/3 hp - slight preference (heal -1 & explode -2)
	jp .nextMove	;get next move
.not_heal_explode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wEnemyMovePower]
	and a
	jp nz, .nextMove	;go to next move if the current move is not zero-power
;At this line onward all moves are assumed to be zero power
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use haze if user has no status or neutral stat mods
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp HAZE_EFFECT	;see if it is haze
	jp nz, .hazekickout	;move on if not haze
;using haze at this point
	ld a, [wEnemyMonStatus]	;get status
	and a
	jp z, .heavydiscourage	;discourage if status is clear
	push hl
	push bc
	xor a
	ld b, 6
	ld hl, wEnemyMonStatMods
.hazeloop
	add [hl]
	inc hl
	dec b
	jr nz, .hazeloop
	pop bc
	pop hl
	cp 42
	jp nc, .heavydiscourage	;discourage if summed stat mods are same or more than 42 (7 per mod is neutral)
.hazekickout
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use disable on a pkmn that is already disabled
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp DISABLE_EFFECT
	jr nz, .notdisable
	ld a, [wPlayerDisabledMove]	
	and a
	jp nz, .heavydiscourage	
.notdisable
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use substitute if not enough hp
	ld a, [wEnemyMoveEffect]
	cp SUBSTITUTE_EFFECT
	jr nz, .notsubstitute
	ld a, 4	;
	call AICheckIfHPBelowFraction
	jp c, .heavydiscourage
.notsubstitute
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use moves that are blocked by mist
	ld a, [wPlayerBattleStatus2]
	bit PROTECTED_BY_MIST, a	;check for mist bit
	jr z, .noMistImm	;if the mist bit is not set, then skip out of this block
	ld a, [wEnemyMoveEffect]	;get the move effect into a
	push hl
	push de
	push bc
	ld hl, MistBlockEffects
	ld de, $0001
	call IsInArray	;see if a is found in the hl array (carry flag set if true)
	pop bc
	pop de
	pop hl
	jp c, .heavydiscourage	;carry flag means the move effect is blocked by mist
	;else continue onward
.noMistImm	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use defense-up moves if opponent is special attacking
	ld a, [wEnemyMoveEffect]	;get the move effect
	cp DEFENSE_UP1_EFFECT	
	jr z, .do_def_check
	cp DEFENSE_UP2_EFFECT
	jr nz, .nodefupmove
.do_def_check
	ld a, [wPlayerMoveEffect]
	cp SPECIAL_DAMAGE_EFFECT
	jp z, .heavydiscourage	;don't bother boosting def against static damage attacks
	cp OHKO_EFFECT
	jp z, .heavydiscourage	;don't bother boosting def against OHKO attacks
	cp PHYS_BURN_SIDE_EFFECT1
	jr nc, .nodefupmove
	ld a, [wPlayerMovePower]	;all regular damage moves have a power of at least 10
	cp 10
	jr c, .nodefupmove
	ld a, [wPlayerMoveType]	;physical move types are numbers $00 to $08 while special is $14 to $1A
	cp SPECIAL
	jp c, .heavydiscourage	;at this point, heavy discourage defense-boosting because player is using a special move of 10+ power
.nodefupmove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - heavily discourage stat modifying moves if it would hit the mod limit and be ineffective
	;check for stat down effects
	ld a, [wEnemyMoveEffect]	;get the move effect
	cp ATTACK_DOWN1_EFFECT	
	jr c, .nostatdownmod	;if value is < the ATTACK_DOWN1_EFFECT value, jump out
	cp EVASION_DOWN2_EFFECT	+ $1
	jr nc, .nostatdownmod	;if value >= EVASION_DOWN2_EFFECT value + $1, jump out
	cp EVASION_DOWN1_EFFECT	+ $1
	jr c, .statdownmod	;if value < EVASION_DOWN1_EFFECT value + $1, there is a stat down move
	cp ATTACK_DOWN2_EFFECT	
	jr nc, .statdownmod	;if value is >= the ATTACK_DOWN2_EFFECT value, there is a stat down move
	jr .nostatdownmod; else the effect is something else in-between the target values
.statdownmod
	sub ATTACK_DOWN1_EFFECT	;normalize the effects from 0 to 5 to get an offset
	cp EVASION_DOWN1_EFFECT + $1 - ATTACK_DOWN1_EFFECT ; covers all -1 effects
	jr c, .statdowncheck
	sub ATTACK_DOWN2_EFFECT - ATTACK_DOWN1_EFFECT ; map -2 effects to corresponding -1 effect
.statdowncheck	
	push hl
	push bc
	ld hl, wPlayerMonStatMods	;load the player's stat mods
	ld c, a
	ld b, $0
	add hl, bc	;use offset to shift to the correct stat mod
	ld b, [hl]
	dec b ; decrement corresponding stat mod
	pop bc
	pop hl
	jr nz, .endstatmod ; if stat mod was > 1 before decrementing, then it's fine to lower
	;else can't be lowered anymore
	jp .heavydiscourage
.nostatdownmod
	;check for stat up effects
	ld a, [wEnemyMoveEffect]	;get the move effect
	cp GROWTH_EFFECT
	jr z, .growth
	cp ATTACK_UP1_EFFECT
	jr c, .endstatmod	;if value is < the ATTACK_UP1_EFFECT value, jump out
	cp EVASION_UP2_EFFECT + $1
	jr nc, .endstatmod	;if value >= EVASION_UP2_EFFECT value + $1, jump out
	cp EVASION_UP1_EFFECT + $1
	jr c, .statupmod	;if value < EVASION_UP1_EFFECT value + $1, there is a stat up move
	cp ATTACK_UP2_EFFECT	
	jr nc, .statupmod	;if value is >= the ATTACK_UP2_EFFECT value, there is a stat up move
	jr .endstatmod; else the effect is something else in-between the target values
.growth
	ld a, [wEnemyMonAttackMod]
	cp 13 ; max stat mods
	jp z, .heavydiscourage
	ld a, [wEnemyMonSpecialMod]
	cp 13 ; max stat mods
	jp z, .heavydiscourage
	jr .endstatmod
.statupmod
	sub ATTACK_UP1_EFFECT	;normalize the effects from 0 to 5 to get an offset
	cp EVASION_UP1_EFFECT + $1 - ATTACK_UP1_EFFECT ; covers all +1 effects
	jr c, .statupcheck
	sub ATTACK_UP2_EFFECT - ATTACK_UP1_EFFECT ; map +2 effects to corresponding +1 effect
.statupcheck	
	push hl
	push bc
	ld hl, wEnemyMonStatMods	;load the enemy's stat mods
	ld c, a
	ld b, $0
	add hl, bc	;use offset to shift to the correct stat mod
	ld b, [hl]
	inc b ; increment corresponding stat mod
	ld a, $0d
	cp b ; can't raise stat past +6 ($0d or 13)
	pop bc
	pop hl
	jr nc, .endstatmod ; if stat mod was < $0d before incrementing, then it's fine to raise
	;else can't be raised anymore
	jp .heavydiscourage
.endstatmod
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - heavily discourage moves that do not stack
	;check each of the stackabe effects one by one and jump to the corresponding section
	ld a, [wEnemyMoveEffect]
	cp FOCUS_ENERGY_EFFECT
	jr z, .checkfocus
	cp LIGHT_SCREEN_EFFECT
	jr z, .checkscreen
	cp REFLECT_EFFECT
	jr z, .checkreflect
	cp SUBSTITUTE_EFFECT
	jr z, .checksub
	cp MIST_EFFECT
	jr z, .checkmist
	cp LEECH_SEED_EFFECT
	jr z, .checkseed
	jr .endstacking
.checkfocus	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus2]
	bit GETTING_PUMPED, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkscreen ;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus3]
	bit HAS_LIGHT_SCREEN_UP, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkreflect	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus3]
	bit HAS_REFLECT_UP, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkmist	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus2]
	bit PROTECTED_BY_MIST, a
	jp nz, .heavydiscourage
	jr .endstacking
.checksub	;check status, and heavily discourage if bit is set
	ld a, [wEnemyBattleStatus2]
	bit HAS_SUBSTITUTE_UP, a
	jp nz, .heavydiscourage
	jr .endstacking
.checkseed
	;first check to make sure leech seed isn't used on a grass pokemon
	push bc
	push hl
	ld hl, wBattleMonType
	ld b, [hl]                 ; b = type 1 of player's pokemon
	inc hl
	ld c, [hl]                 ; c = type 2 of player's pokemon
	ld a, b		;load type 1 into a
	cp GRASS	;is type 1 grass?
	jr z, .seedgrasstest	;skip ahead if type1 is grass
	ld a, c		;load type 2 into a
.seedgrasstest
	pop hl
	pop bc
	cp GRASS	;a is either type 1 grass or it is type 2 yet to be confirmed
	jp z, .heavydiscourage	;heavily discourage if either of the types are grass
	;else, not to make sure it isn't already used
	;check status, and heavily discourage if bit is set
	ld a, [wPlayerBattleStatus2]
	bit SEEDED, a
	jp nz, .heavydiscourage
.endstacking
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - discourage using confuse-only moves on confused pkmn
	ld a, [wEnemyMoveEffect]
	cp CONFUSION_EFFECT	;see if the move has a confusion effect
	jr nz, .notconfuse	;skip out if move is not a zero-power confusion move
	ld a, [wPlayerBattleStatus1]	;load the player pkmn volatile status
	and $80	;check bit 7 for confusion bit
	jp nz, .heavydiscourage	;heavily discourage using zero-power confusion moves on confused pkmn
.notconfuse
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;don't use a status move against a status'd target
	ld a, [wEnemyMoveEffect]
	push hl
	push de
	push bc
	ld hl, StatusAilmentMoveEffects
	ld de, $0001
	call IsInArray
	pop bc
	pop de
	pop hl
	jr nc, .nostatusconflict
	ld a, [wBattleMonStatus]
	and a
	jr nz, .heavydiscourage
.nostatusconflict
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote: fix spamming of buff/debuff moves
	;See if the move has an effect that should not be dissuaded
	ld a, [wEnemyMoveEffect]
	push hl
	push de
	push bc
	ld hl, EffectsToNotDissuade
	ld de, $0001
	call IsInArray
	pop bc
	pop de
	pop hl
	jp c, .skipoutspam	;If found on list, do not run anti-spam on it
;heavily discourage 0 BP moves if health is below 1/3 max
	ld a, 3
	call AICheckIfHPBelowFraction
	jp c, .heavydiscourage
;heavily discourage 0 BP moves if one was used just previously
	ld a, [wAILastMovePower]
	and a
	jp z, .heavydiscourage
;else apply a random bias to the 0 bp move we are on
	call Random	
;outcome desired: 	50% chance to heavily discourage and would rather do damage
;					12.5% chance to slightly encourage
;					else neither encourage nor discourage
	cp 128	;don't set carry flag if number is >= this value
	jp nc, .heavydiscourage	
	cp 32
	jp c, .givepref	;if not discouraged, then there is a chance to slightly encourage to spice things up
	;else neither encourage nor discourage
.skipoutspam
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - end of this AI layer
	jp .nextMove
.heavydiscourage
	ld a, [hl]
	add $5 ; heavily discourage move
	ld [hl], a
	jp .nextMove
.givepref	;joenote - added marker
	dec [hl] ; slightly encourage this move
	jp .nextMove

EffectsToNotDissuade:
	db CONFUSION_EFFECT
	db LEECH_SEED_EFFECT
	db DISABLE_EFFECT
	db HEAL_EFFECT
	db FOCUS_ENERGY_EFFECT
	db SUBSTITUTE_EFFECT
	;fall through
StatusAilmentMoveEffects:
	db $01 ; unused sleep effect
	db SLEEP_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
	db $FF

SubstituteImmuneEffects:	;joenote - added this table to track for substitute immunities
	db $01 ; unused sleep effect
	db SLEEP_EFFECT
	db POISON_EFFECT
	db PARALYZE_EFFECT
	db CONFUSION_EFFECT
	db DRAIN_HP_EFFECT
	db LEECH_SEED_EFFECT
	db DREAM_EATER_EFFECT
	;fall through
MistBlockEffects:	;joenote - added this table to track for things blocked by mist
	db ATTACK_DOWN1_EFFECT
	db DEFENSE_DOWN1_EFFECT
	db SPEED_DOWN1_EFFECT
	db SPECIAL_DOWN1_EFFECT
	db ACCURACY_DOWN1_EFFECT
	db EVASION_DOWN1_EFFECT
	db ATTACK_DOWN2_EFFECT
	db DEFENSE_DOWN2_EFFECT
	db SPEED_DOWN2_EFFECT
	db SPECIAL_DOWN2_EFFECT
	db ACCURACY_DOWN2_EFFECT
	db EVASION_DOWN2_EFFECT
	db $FF

SpecialZeroBPMoves:	;joenote - added this table to tracks 0 bp moves that should not be treated as buffs
	db METRONOME
	db THUNDER_WAVE
	db $FF

; slightly encourage moves with specific effects.
; in particular, stat-modifying moves and other move effects
; that fall in-between
AIMoveChoiceModification2:
;joenote - kick out if no-attack bit is set
	ld a, [wUnusedC000]
	bit 2, a
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld a, [wBattleMonStatus]
	and SLP_MASK | (1 << FRZ) | (1 << PAR)
	jr nz, .safeToUse
	ld a, [wPlayerBattleStatus1]
	and 1 << CONFUSED
	jr nz, .safeToUse
	ld a, [wEnemyBattleStatus2]
	and 1 << HAS_SUBSTITUTE_UP
	jr nz, .safeToUse
	ld a, [wAILayer2Encouragement]
	cp $1
	ret nz
.safeToUse
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
	ld a, [wEnemyMoveEffect]
	cp FOCUS_ENERGY_EFFECT
	jr z, .preferMove
	cp GROWTH_EFFECT
	jr z, .preferMove
	cp ATTACK_UP1_EFFECT
	jr c, .nextMove
	cp BIDE_EFFECT
	jr c, .preferMove
	cp ATTACK_UP2_EFFECT
	jr c, .nextMove
	cp POISON_EFFECT
	jr c, .preferMove
	jr .nextMove
.preferMove
	dec [hl] ; slightly encourage this move
	jr .nextMove

; encourages moves that are effective against the player's mon (even if non-damaging).
; discourage damaging moves that are ineffective or not very effective against the player's mon,
; unless there's no damaging move that deals at least neutral damage
AIMoveChoiceModification3:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - kick out if no-attack bit is set
	ld a, [wUnusedC000]
	bit 2, a
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld hl, wBuffer - 1 ; temp move selection array (-1 byte offset)
	ld de, wEnemyMonMoves ; enemy moves
	ld b, NUM_MOVES + 1
.nextMove
	dec b
	ret z ; processed all 4 moves
	inc hl
	ld a, [de]
	and a
	ret z ; no more moves in move set
	inc de
	call ReadMove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;don't use poison-effect moves on poison-tpe pokemon
	ld a, [wEnemyMoveEffect]
	cp POISON_EFFECT
	jr nz, .notpoisoneffect
	ld a, [wBattleMonType]
	cp POISON
	jr z, .heavydiscourage2
	ld a, [wBattleMonType + 1]
	cp POISON
	jr z, .heavydiscourage2
.notpoisoneffect
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;check on certain moves with zero bp but are handled differently
	ld a, [wEnemyMoveNum]
	push hl
	push de
	push bc
	ld hl, SpecialZeroBPMoves
	ld de, $0001
	call IsInArray	;see if a is found in the hl array (carry flag set if true)
	pop bc
	pop de
	pop hl
	jp c, .specialBPend	;If found on list, treat it as if it were a damaging move

	;otherise only handle moves that deal damage from here on out
	ld a, [wEnemyMovePower]
	and a
	jp z, .nextMove	;go to next move if the current move is zero-power
.specialBPend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote: static damage value moves should not be accounted for typing
;at the same type, randomly bump their preference to spice things up
	ld a, [wEnemyMovePower]	;get the base power of the enemy's attack
	cp $1	;check if it is 1. special damage moves assumed to have 1 base power
	jr nz, .skipout4	;skip down if it's not a special damage move
	call Random	;else get a random number between 0 and 255
	cp $40	
	jp c, .givepref	;(25% chance) slightly encourage
	jp .nextMove	;else neither encourage nor discourage
.skipout4
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - heavily discourage attack moves that have no effect due to typing
	push hl
	push bc
	push de
	;reset type-effectiveness bit before calling function
	ld hl, wUnusedC000
	res 3, [hl] 
	callfar AIGetTypeEffectiveness
	pop de
	pop bc
	pop hl

	ld a, [wTypeEffectiveness]	;get the effectiveness
	and a 	;check if it's zero
	jr nz, .skipout2	;skip if it's not immune
.heavydiscourage2	;at this line the move has no effect due to immunity or other circumstance
	ld a, [hl]	
	add $5 ; heavily discourage move
	ld [hl], a
	jp .nextMove
.skipout2
	;if thunder wave is being used against a non-immune target, neither encourage nor discourage it
	ld a, [wEnemyMoveNum]
	cp THUNDER_WAVE
	jr nz, .ohkoCheck
	ld a, [wBattleMonType]
	cp ELECTRIC
	jr z, .heavydiscourage2
	jp .nextMove
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - do not use ohko moves on faster opponents, since they will auto-miss
.ohkoCheck
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp OHKO_EFFECT	;see if it is ohko move
	jr nz, .skipout3	;skip ahead if not ohko move
	push hl
	push bc
	push de
	call StrCmpSpeed	;do a speed compare
	pop de
	pop bc
	pop hl
	jp c, .nextMove	;ai is fast enough so ohko move viable
	;else ai is slower so don't bother
	jp .heavydiscourage2
.skipout3
	ld a, [wEnemyMoveNum]	;load the move index
	cp QUICK_ATTACK ;see if it is quick attack
	jr nz, .speedDownCheck
	ld a, [wPlayerHPBarColor]
	cp HP_BAR_RED
	jr z, .checkSpeed
	ld a, [wEnemyHPBarColor]
	cp HP_BAR_RED
	jr nz, .speedDownCheck
.checkSpeed
	push hl
	push bc
	push de
	call StrCmpSpeed	;do a speed compare
	pop de
	pop bc
	pop hl
	jr c, .speedDownCheck ; skip if already faster
	dec [hl]  ; if slower, encourage this move
	dec [hl]
.speedDownCheck
	ld a, [wEnemyMoveEffect]	;load the move effect
	cp SPEED_DOWN_SIDE_EFFECT	;see if it is speed down move
	jr nz, .hyperBeamCheck	
	push hl
	push bc
	push de
	call StrCmpSpeed	;do a speed compare
	pop de
	pop bc
	pop hl
	jr c, .hyperBeamCheck ; skip if already faster
	dec [hl]  ; if slower, encourage this move
	dec [hl]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.hyperBeamCheck
	ld a, [wEnemyMoveEffect]
	cp HYPER_BEAM_EFFECT
	jr nz, .effectivenessCheck
	ld a, [wPlayerHPBarColor]
	and a ; HP_BAR_GREEN = 0
	jr nz, .effectivenessCheck
	inc hl ;slightly discourage if player in green hp
	inc hl
	jr .effectivenessCheck
.effectivenessCheck
	ld a, [wTypeEffectiveness]
	cp $0A
	jp z, .nextMove
	jr c, .notEffectiveMove
	;at this line, move is super effective
.givepref	;joenote - added marker
	dec [hl] ; slightly encourage this move
	dec [hl]
	dec [hl]
	jp .nextMove
.notEffectiveMove ; discourages non-effective moves if better moves are available 
	push hl
	push de
	push bc
	ld a, [wEnemyMoveType]
	ld d, a
	ld hl, wEnemyMonMoves  ; enemy moves
	ld b, NUM_MOVES + 1
	ld c, $0
.loopMoves
	dec b
	jr z, .done
	ld a, [hli]
	and a
	jr z, .done
	call ReadMove
	ld a, [wEnemyMoveEffect]
	cp SUPER_FANG_EFFECT
	jr z, .betterMoveFound ; Super Fang is considered to be a better move
	cp SPECIAL_DAMAGE_EFFECT
	jr z, .betterMoveFound ; any special damage moves are considered to be better moves
	ld a, [wEnemyMoveType]
	cp d
	jr z, .loopMoves
	ld a, [wEnemyMovePower]
	and a
	jr nz, .betterMoveFound ; damaging moves of a different type are considered to be better moves
	jr .loopMoves
.betterMoveFound
	ld c, a
.done
	ld a, c
	pop bc
	pop de
	pop hl
	and a
	jp z, .nextMove
	inc [hl] ; slightly discourage this move
	inc [hl]
	jp .nextMove
	
AIMoveChoiceModification4:	;this unused routine now handles intelligent trainer switching
	ld a, [wUnusedC000]
	set 5, a ; sets the bit that signifies trainer has intelligent switching
	ld [wUnusedC000], a
	ld a, [wPlayerBattleStatus1]
	and 1 << USING_TRAPPING_MOVE
	ret nz
	push hl
	push bc
	callfar ScoreAIParty	;carry is cleared if current mon score >= highest score of remaining roster; don't switch
	pop bc
	pop hl
	jp nc, .skipSwitchEnd	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;better chance to switch if afflicted with toxic-style poison
	ld a, [wEnemyBattleStatus3]
	bit 0, a	;check a for the toxic bit (sets or clears zero flag)
	jr z, .skipSwitchToxicEnd	;not badly poisoned if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	cp $55	;set carry if rand num < $55
	jp c, .setSwitch	;34% chance to switch
.skipSwitchToxicEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;chance to switch if afflicted with confusion
	ld a, [wEnemyBattleStatus1]
	bit 7, a	;check a for the confusion bit (sets or clears zero flag)
	jr z, .skipSwitchConfuseEnd	;not confused if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	cp $80	;set carry if rand num < $80
	jp c, .setSwitch	;50% chance to switch
.skipSwitchConfuseEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;12.5% chance to switch if afflicted with sleep counter > 3
	ld a, [wEnemyMonStatus]
	and %00000111	;check for sleep counter
	jr z, .skipSwitchNVSLEEPstatEnd	;no NV status if zero flag set
	push bc
	srl a
	srl a
	ld b, a
	call Random
	and %00000111
	cp b
	pop bc
	jp c, .setSwitch
.skipSwitchNVSLEEPstatEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;slight chance to switch if afflicted with leech seed
	ld a, [wEnemyBattleStatus2]
	bit 7, a	;check a for the leech seed bit (sets or clears zero flag)
	jr z, .skipSwitchSeedEnd	;not seeded if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	cp $20	;set carry if rand num < $20
	jp c, .setSwitch	;12.5% chance to switch
.skipSwitchSeedEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;slight chance to switch if move disabled
	ld a, [wEnemyDisabledMove] ; get disabled move (if any)
	swap a
	and $f
	jr z, .skipSwitchDisableEnd	;no disabled moves if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	cp $20	;set carry if rand num < $20
	jp c, .setSwitch	;12.5% chance to switch
.skipSwitchDisableEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;chance to switch if stat mods are too low
	push bc
	;use b for storage and a for loading
	ld a, [wEnemyMonAttackMod]	
	ld b, a 
	ld a, [wEnemyMonDefenseMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonSpeedMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonSpecialMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonAccuracyMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, [wEnemyMonEvasionMod]
	cp b
	call c, CondLDBA	;if a < b, then load a into b
	ld a, b	;but b back into a
	pop bc
	cp $07	;is the lowest stat mod the normal vale of 7?
	jr nc, .skipSwitchModEnd	;lowest stat mod is not negative (value below 7)
	push bc
	ld b, a	;put the lowest mod into b
	ld a, $07	; put 7 into a
	sub b	;a = 7 - b, so a becomes 6 (-6 stages) to 1 (-1 stage)
	ld b, a	;put a back into b
	call Random	;put a random number in 'a' between 0 and 255
	and $07	;use only bits 0 to 2 for a random number of 0 to 7
	cp b
	pop bc
	jp c, .setSwitch	;switch if random number < mod 1 (-1 stage) to 6 (-6 stages)
.skipSwitchModEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;switch if supereffective move is being used against enemy
	ld a, [wPlayerMovePower]	;get the power of the player's move
	cp $2	;regular damaging moves have power > 1
	jr c, .skipSwitchEffectiveEnd	;skip out if the move is not a normal damaging move
	push hl
	push bc
	push de
	;set type-effectiveness bit before calling function
	ld a, [wUnusedC000]
	set 3, a 
	ld [wUnusedC000], a
	callfar AIGetTypeEffectiveness
	pop de
	pop bc
	pop hl
	ld a, [wTypeEffectiveness]	;get the multiplier effectiveness for the player's move
	cp $14	;is it < 20?
	jr c, .skipSwitchEffectiveEnd	;if so, skip to end of this block
	push bc
	ld a, [wPlayerMovePower]	;get the power of the player's move into a
	srl a	;halve the power
	srl a	;quarter the power
	ld b, a	;put quarter power into b
	ld a, [wPlayerMovePower]	;get the power of the player's move into a
	srl a	;halve the power
	add b	;add b to get 3/4ths power into a
	ld b, a
	call Random	;put a random number in 'a' 
	cp b; see if a < b and set carry if true
	pop bc
	jr nc, .skipSwitchEffectiveEnd	;if carry flag is set, switch pkmn
	;Before switching, flag the mon being switched out.
	;It will be used as a penalty in scoring since there
	;is clearly something disfavorable about it.
	push bc
	push hl
	push de
	ld de, wEnemyMonPartyPos
	callfar SetAISwitched
	pop de
	pop bc
	pop hl
	jp .setSwitchKeepFlagged	
.skipSwitchEffectiveEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;do not switch if this pkmn was flagged
	push hl
	push bc
	push de
	ld de, wEnemyMonPartyPos
	callfar CheckAISwitched
	pop de
	pop bc
	pop hl
	jp nz, .skipSwitchEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;switch if HP is low. 
;but don't switch based on low HP if enemy outspeeds player mon
	ld a, 3	;
	call AICheckIfHPBelowFraction
	jr nc, .skipSwitchHPend	;if hp not below 1/3 then skip to the end of this block
	call Random	;put a random number in 'a' between 0 and 255
	cp $40	;set carry if rand num < $40	/	;25% chance to switch
	jr nc, .skipSwitchHPend
	ld a, [wBattleMonSpeed]
	push bc
	ld b, a	;store hi byte of player speed in b
	ld a, [wEnemyMonSpeed]	;store hi byte of enemy speed in a
	cp b
	pop bc
	jr nz, .next1	;if bytes are not equal, then rely on carry bit to see which is greater
	;else check the lo bytes
	ld a, [wBattleMonSpeed + 1]
	push bc
	ld b, a	;store lo byte of player speed in b
	ld a, [wEnemyMonSpeed + 1]	;store lo byte of enemy speed in a
	cp b
	pop bc
.next1
	jp c, .setSwitch	;if carry is set, then enemy mon has less speed --> switch out
.skipSwitchHPend
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;chance to switch if afflicted with non-volatile status (except sleep)
	ld a, [wEnemyMonStatus]
	and %11111000	;check for any non-volatile status except sleep
	jr z, .skipSwitchNVstatEnd	;no NV status if zero flag set
	call Random	;put a random number in 'a' between 0 and 255
	cp $40	;set carry if rand num < $40
	jp c, .setSwitch	;25% chance to switch
.skipSwitchNVstatEnd
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	jr .skipSwitchEnd	;jump to the end and get out of this line is reached.
.setSwitch	;this line will only be reached if a switch is confirmed.
	push bc
	push hl
	push de
	ld de, wEnemyMonPartyPos
	callfar ClearAISwitched	;clear any switch flags on the mon being switched out
	pop de
	pop bc
	pop hl
.setSwitchKeepFlagged
	call SetSwitchBit
.skipSwitchEnd
	ret

;joenote - function for loading A into B so it can be called conditionally
CondLDBA:
	ld b, a
	ret

ReadMove:
	push hl
	push de
	push bc
	dec a
	ld hl, Moves
	ld bc, MOVE_LENGTH
	call AddNTimes
	ld de, wEnemyMoveNum
	ld a, BANK(Moves)
	call FarCopyData2
	pop bc
	pop de
	pop hl
	ret
	
;joenote - takes move in d, returns its power in d and type in e
ReadMoveForAIscoring:
	dec d
	ld a, d
	ld hl, Moves
	ld bc, MoveEnd - Moves
	call AddNTimes
	inc hl	
	inc hl ;point to move power
	ld a, [hli]
	ld d, a	;store power in d
	ld a, [hl]
	ld e, a ;store type in e
	ret


INCLUDE "data/trainers/move_choices.asm"

INCLUDE "data/trainers/pic_pointers_money.asm"

INCLUDE "data/trainers/names.asm"

INCLUDE "engine/battle/misc.asm"

INCLUDE "engine/battle/read_trainer_party.asm"

INCLUDE "data/trainers/special_moves.asm"

INCLUDE "data/trainers/parties.asm"

TrainerAI:
	and a
	ld a, [wIsInBattle]
	dec a
	ret z ; if not a trainer, we're done here
	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z ; if in a link battle, we're done as well
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - AI should not use actions if in a move that prevents such a thing
	ld a, [wEnemyBattleStatus2]
	and %01100000 
	ret nz
	ld a, [wEnemyBattleStatus1]
	and %01110011 
	ret nz
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - switch if the switch bit is set	
	call AICheckIfEnoughMons
	jr z, .cantSwitch
	call CheckandResetSwitchBit
	jp nz, SwitchEnemyMon	;switch if bit was initially set
	;jp SwitchEnemyMon	;joedebug - use this to make trainer ai constantly switch
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
.cantSwitch
	ld a, [wTrainerClass] ; what trainer class is this?
	dec a
	ld c, a
	ld b, 0
	ld hl, TrainerAIPointers
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [wAICount]
	and a
	ret z ; if no AI uses left, we're done here
	inc hl
	inc a
	jr nz, .getpointer
	dec hl
	ld a, [hli]
	ld [wAICount], a
.getpointer
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Random
	jp hl

INCLUDE "data/trainers/ai_pointers.asm"

JugglerAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXSpecial

BlackbeltAI:
	cp 13 percent - 1
	ret nc
	jp AIUseXAttack

GiovanniAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXAccuracy

CooltrainerMAI:
	cp 25 percent + 1
	ret nc
	jp AIUseXAttack

CooltrainerFAI:
	; The intended 25% chance to consider switching will not apply.
	; Uncomment the line below to fix this.
	cp 25 percent + 1
	; ret nc
	ld a, 10
	call AICheckIfHPBelowFraction
	jp c, AIUseHyperPotion
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	call AICheckIfEnoughMons
	ret z
	jp SwitchEnemyMon

BrockAI:
	cp 25 percent + 1
	ret nc
	jp AIUseDireHit

MistyAI:
	; if her active monster has a status condition, use a full heal
	ld a, [wEnemyMonStatus]
	and a
	ret z
	jp AIUseFullHeal

LtSurgeAI:
	cp 50 percent + 1
	ret nc
	ld a, 2
	call AICheckIfHPBelowFraction
	ret c
	jp AIUseXSpecial

ErikaAI:
	cp 25 percent + 1
	ret nc
	ld a, 3
	call AICheckIfHPBelowFraction
	ret c
	jp AIUseXSpeed

KogaAI:
	cp 25 percent + 1
	ret nc
	ld a, 2
	call AICheckIfHPBelowFraction
	jp c, AIUseXDefend
	jp AIUseSuperPotion

BlaineAI:
	cp 25 percent + 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseHyperPotion

SabrinaAI:
	cp 25 percent + 1
	ret nc
	ld a, 10
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseHyperPotion

Rival2AI:
	cp 13 percent - 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseSuperPotion

Rival3AI:
	cp 13 percent - 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseFullRestore

LoreleiAI:
	cp 50 percent + 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseHyperPotion

BrunoAI:
	cp 25 percent + 1
	ret nc
	ld a, 2
	call AICheckIfHPBelowFraction
	ret c
	jp AIUseXAttack

AgathaAI:
	cp 50 percent + 1
	ret nc
	ld a, 4
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseHyperPotion

LanceAI:
	cp 50 percent + 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseFullRestore
	
ChelleAI:
	cp 50 percent + 1
	ret nc
	ld a, 5
	call AICheckIfHPBelowFraction
	ret nc
	jp AIUseFullRestore

GenericAI:
	and a ; clear carry
	ret

; end of individual trainer AI routines

;joenote - added these functions to check if the ai switching bit is set
;need to have 'a' accumulator and flag register freed up to use this function
CheckandResetSwitchBit:	
	ld a, [wUnusedC000]
	bit 0, a	;check a for switch pkmn bit (sets or clears zero flag)
	res 0, a ; resets the switch pkmn bit (does not affect flags)
	ld [wUnusedC000], a
	ret
SetSwitchBit:	
	ld a, [wUnusedC000]
	set 0, a ; sets the switch pkmn bit
	ld [wUnusedC000], a
	ret

DecrementAICount:
	ld hl, wAICount
	dec [hl]
	scf
	ret

AIPlayRestoringSFX:
	ld a, SFX_HEAL_AILMENT
	jp PlaySoundWaitForCurrent

AIUseFullRestore:
	call AICureStatus
	ld a, FULL_RESTORE
	ld [wAIItem], a
	ld de, wHPBarOldHP
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld a, [hl]
	ld [de], a
	inc de
	ld hl, wEnemyMonMaxHP + 1
	ld a, [hld]
	ld [de], a
	inc de
	ld [wHPBarMaxHP], a
	ld [wEnemyMonHP + 1], a
	ld a, [hl]
	ld [de], a
	ld [wHPBarMaxHP+1], a
	ld [wEnemyMonHP], a
	jr AIPrintItemUseAndUpdateHPBar

AIUsePotion:
; enemy trainer heals his monster with a potion
	ld a, POTION
	ld b, 20
	jr AIRecoverHP

AIUseSuperPotion:
; enemy trainer heals his monster with a super potion
	ld a, SUPER_POTION
	ld b, 50
	jr AIRecoverHP

AIUseHyperPotion:
; enemy trainer heals his monster with a hyper potion
	ld a, HYPER_POTION
	ld b, 200
	; fallthrough

AIRecoverHP:
; heal b HP and print "trainer used $(a) on pokemon!"
	ld [wAIItem], a
	ld hl, wEnemyMonHP + 1
	ld a, [hl]
	ld [wHPBarOldHP], a
	add b
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [hl]
	ld [wHPBarOldHP+1], a
	ld [wHPBarNewHP+1], a
	jr nc, .next
	inc a
	ld [hl], a
	ld [wHPBarNewHP+1], a
.next
	inc hl
	ld a, [hld]
	ld b, a
	ld de, wEnemyMonMaxHP + 1
	ld a, [de]
	dec de
	ld [wHPBarMaxHP], a
	sub b
	ld a, [hli]
	ld b, a
	ld a, [de]
	ld [wHPBarMaxHP+1], a
	sbc b
	jr nc, AIPrintItemUseAndUpdateHPBar
	inc de
	ld a, [de]
	dec de
	ld [hld], a
	ld [wHPBarNewHP], a
	ld a, [de]
	ld [hl], a
	ld [wHPBarNewHP+1], a
	; fallthrough

AIPrintItemUseAndUpdateHPBar:
	call AIPrintItemUse_
	hlcoord 2, 2
	xor a
	ld [wHPBarType], a
	predef UpdateHPBar2
	jp DecrementAICount

AICheckIfEnoughMons:
; resets z flag if there are 2 or more unfainted mons in party
	ld a, [wEnemyPartyCount]
	ld c, a
	ld hl, wEnemyMon1HP

	ld d, 0 ; keep count of unfainted monsters

	; count how many monsters haven't fainted yet
.loop
	ld a, [hli]
	ld b, a
	ld a, [hld]
	or b
	jr z, .Fainted ; has monster fainted?
	inc d
.Fainted
	push bc
	ld bc, wEnemyMon2 - wEnemyMon1
	add hl, bc
	pop bc
	dec c
	jr nz, .loop

	ld a, d ; how many available monsters are there?
	dec a
	and a
	ret

SwitchEnemyMon:

; prepare to withdraw the active monster: copy hp, number, and status to roster

	xor a
	ld [wDamage], a
	ld [wDamage + 1], a
	ld [wEnemyMovePower], a
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1HP
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	ld d, h
	ld e, l
	ld hl, wEnemyMonHP
	ld bc, 4
	call CopyData

	ld hl, AIBattleWithdrawText
	call PrintText

	; This wFirstMonsNotOutYet variable is abused to prevent the player from
	; switching in a new mon in response to this switch.
	ld a, 1
	ld [wFirstMonsNotOutYet], a
	callfar EnemySendOut
	xor a
	ld [wFirstMonsNotOutYet], a

	ld a, [wLinkState]
	cp LINK_STATE_BATTLING
	ret z
	ld a, $1
	ld [hWhoseTurn], a
	scf
	ret

AIBattleWithdrawText:
	text_far _AIBattleWithdrawText
	text_end

AIUseFullHeal:
	call AIPlayRestoringSFX
	call AICureStatus
	ld a, FULL_HEAL
	jp AIPrintItemUse

AICureStatus:
; cures the status of enemy's active pokemon
	ld a, [wEnemyMonPartyPos]
	ld hl, wEnemyMon1Status
	ld bc, wEnemyMon2 - wEnemyMon1
	call AddNTimes
	xor a
	ld [hl], a ; clear status in enemy team roster
	ld [wEnemyMonStatus], a ; clear status of active enemy
	ld hl, wEnemyBattleStatus3
	res BADLY_POISONED, [hl]
	dec hl
	dec hl
	res CONFUSED, [hl]
	ret

AIUseXAccuracy: ; unused
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 0, [hl]
	ld a, X_ACCURACY
	jp AIPrintItemUse

AIUseGuardSpec:
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 1, [hl]
	ld a, GUARD_SPEC
	jp AIPrintItemUse

AIUseDireHit: ; unused
	call AIPlayRestoringSFX
	ld hl, wEnemyBattleStatus2
	set 2, [hl]
	ld a, DIRE_HIT
	jp AIPrintItemUse

AICheckIfHPBelowFraction:
; return carry if enemy trainer's current HP is below 1 / a of the maximum
;joenote - first preserve stuff onto the stack
	push hl
	push bc
	push de
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;joenote - handle an 'a' value of 1
	cp 1
	jr nz, .not_one
	ld a, [wEnemyMonMaxHP]
	ld b, a
	ld a, [wEnemyMonHP]
	cp b	;a = HP MSB an b = MAXHP MSB so do a - b and set carry if negative
	jr c, .return
	ld a, [wEnemyMonMaxHP + 1]
	ld b, a
	ld a, [wEnemyMonHP + 1]
	cp b	;a = HP LSB an b = MAXHP LSB so do a - b and set carry if negative
	jr .return
.not_one
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ld [hDivisor], a
	ld hl, wEnemyMonMaxHP
	ld a, [hli]
	ld [hDividend], a
	ld a, [hl]
	ld [hDividend + 1], a
	ld b, 2
	call Divide
	ld a, [hQuotient + 3]
	ld c, a
	ld a, [hQuotient + 2]
	ld b, a
	ld hl, wEnemyMonHP + 1
	ld a, [hld]
	ld e, a
	ld a, [hl]
	ld d, a
	ld a, d
	sub b
	jr nz, .return
	ld a, e
	sub c
.return	;joenote - consolidating returns with the stack
	pop de
	pop bc
	pop hl
	ret

AIUseXAttack:
	ld b, $A
	ld a, X_ATTACK
	jr AIIncreaseStat

AIUseXDefend:
	ld b, $B
	ld a, X_DEFEND
	jr AIIncreaseStat

AIUseXSpeed:
	ld b, $C
	ld a, X_SPEED
	jr AIIncreaseStat

AIUseXSpecial:
	ld b, $D
	ld a, X_SPECIAL
	; fallthrough

AIIncreaseStat:
	ld [wAIItem], a
	push bc
	call AIPrintItemUse_
	pop bc
	ld hl, wEnemyMoveEffect
	ld a, [hld]
	push af
	ld a, [hl]
	push af
	push hl
	ld a, ANIM_AF
	ld [hli], a
	ld [hl], b
	callfar StatModifierUpEffect
	pop hl
	pop af
	ld [hli], a
	pop af
	ld [hl], a
	jp DecrementAICount

AIPrintItemUse:
	ld [wAIItem], a
	call AIPrintItemUse_
	jp DecrementAICount

AIPrintItemUse_:
; print "x used [wAIItem] on z!"
	ld a, [wAIItem]
	ld [wd11e], a
	call GetItemName
	ld hl, AIBattleUseItemText
	jp PrintText

AIBattleUseItemText:
	text_far _AIBattleUseItemText
	text_end

StrCmpSpeed:	;joenote - function for AI to compare pkmn speeds
	ld de, wBattleMonSpeed ; player speed value
	ld hl, wEnemyMonSpeed ; enemy speed value
	ld c, $2	;bytes to copy
.spdcmploop	
	ld a, [de]	
	cp [hl]
	ret nz
	inc de
	inc hl
	dec c
	jr nz, .spdcmploop
	;At this point:
	;zero flag set means speeds equal
	;carry flag not set means player pkmn faster
	;carry flag set means ai pkmn faster
	ret