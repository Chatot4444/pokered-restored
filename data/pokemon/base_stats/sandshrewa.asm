	db DEX_SANDSHREWA ; pokedex id

	db  50,  75,  90,  40,  25
	;   hp  atk  def  spd  spc

	db ICE, STEEL ; type
	db 255 ; catch rate
	db 93 ; base exp

	INCBIN "gfx/pokemon/front/sandshrewa.pic", 0, 1 ; sprite dimensions
	dw SandshrewaPicFront, SandshrewaPicBack

	db SCRATCH, AURORA_BEAM, DEFENSE_CURL, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     ICE_BEAM, BLIZZARD, SUBMISSION,   SEISMIC_TOSS,                  EARTHQUAKE,       \
	     DIG,          MIMIC,        DOUBLE_TEAM, REFLECT,                SWIFT,        \
	     SKULL_BASH,   REST,         ROCK_SLIDE,   SUBSTITUTE,   CUT,          \
	     STRENGTH
	; end

	db 0 ; padding
