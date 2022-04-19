	db DEX_SANDSLASHA ; pokedex id

	db  75, 100, 120,  65,  45
	;   hp  atk  def  spd  spc

	db ICE, STEEL ; type
	db 90 ; catch rate
	db 163 ; base exp

	INCBIN "gfx/pokemon/front/sandslasha.pic", 0, 1 ; sprite dimensions
	dw SandslashaPicFront, SandslashaPicBack

	db X_SCISSOR, SCRATCH, AURORA_BEAM, DEFENSE_CURL ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	    ICE_BEAM, BLIZZARD,  HYPER_BEAM,   SUBMISSION,   SEISMIC_TOSS,                  EARTHQUAKE,   \
	          DIG,          MIMIC,        DOUBLE_TEAM, REFLECT,                \
	     SWIFT,        SKULL_BASH,   REST,         ROCK_SLIDE,   SUBSTITUTE,   \
	     CUT,          STRENGTH
	; end

	db 0 ; padding
