WildMonEncounterSlotChances:
; There are 10 slots for wild pokemon, and this is the table that defines how common each of
; those 10 slots is. A random number is generated and then the first byte of each pair in this
; table is compared against that random number. If the random number is less than or equal
; to the first byte, then that slot is chosen.  The second byte is double the slot number.
	db  50, $00 ; 51/256 = 19.9% chance of slot 0
	db 95, $02  ; 45/256 = 17.5% chance of slot 1
	db 125, $04 ; 30/256 = 11.7% chance of slot 2
	db 150, $06 ; 25/256 =  9.8% chance of slot 3
	db 175, $08 ; 25/256 =  9.8% chance of slot 4
	db 200, $0A ; 25/256 =  9.8% chance of slot 5
	db 215, $0C ; 15/256 =  5.8% chance of slot 6
	db 230, $0E ; 15/256 =  5.8% chance of slot 7
	db 245, $10 ; 15/256 =  5.8% chance of slot 8
	db 255, $12 ; 10/256 =  3.9% chance of slot 9
