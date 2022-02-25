	db DEX_GRAVELERA ; pokedex id

	db  55,  95, 115,  35,  45
	;   hp  atk  def  spd  spc

	db ROCK, ELECTRIC ; type
	db 120 ; catch rate
	db 134 ; base exp

	INCBIN "gfx/pokemon/front/gravelera.pic", 0, 1 ; sprite dimensions
	dw GraveleraPicFront, GraveleraPicBack

	db TACKLE, DEFENSE_CURL, THUNDERSHOCK, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     SUBMISSION,   COUNTER,      SEISMIC_TOSS, FLAMETHROWER,          THUNDERBOLT, THUNDER,  EARTHQUAKE,   \
	     FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,   ROCK_TOMB,               \
	     METRONOME,    SELFDESTRUCT, FIRE_BLAST,   REST,  THUNDER_WAVE,       EXPLOSION,    \
	     ROCK_SLIDE,   SUBSTITUTE,   STRENGTH
	; end

	db 0 ; padding
