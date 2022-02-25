	db DEX_PONYTAG ; pokedex id

	db  50,  85,  55,  90,  65
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, PSYCHIC_TYPE ; type
	db 190 ; catch rate
	db 152 ; base exp

	INCBIN "gfx/pokemon/front/ponytag.pic", 0, 1 ; sprite dimensions
	dw PonytagPicFront, PonytagPicBack

	db CONFUSION, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,    MEGA_KICK,    HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	                PSYCHIC_M,  TELEPORT,       MIMIC,        DOUBLE_TEAM,  REFLECT,  METRONOME, \
	       SWIFT,        SKULL_BASH,   REST,    PSYWAVE,      SUBSTITUTE
	; end

	db 0 ; padding
