	db DEX_MAGMORTAR ; pokedex id

	db  75,  95,  67,  83,  123
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 30 ; catch rate
	db 243 ; base exp

	INCBIN "gfx/pokemon/front/magmortar.pic", 0, 1 ; sprite dimensions
	dw MagmortarPicFront, MagmortarPicBack

	db EMBER, FIRE_PUNCH, THUNDERPUNCH, FIRE_SPIN ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	     FLAMETHROWER,          SOLARBEAM,    THUNDERBOLT,  EARTHQUAKE,   PSYCHIC_M,    TELEPORT,     MIMIC,        DOUBLE_TEAM,  \
	    ROCK_TOMB,  METRONOME,    SLUDGE_BOMB,    FIRE_BLAST,   SKULL_BASH,   REST,         \
	     PSYWAVE,      ROCK_SLIDE,    SUBSTITUTE,   STRENGTH, FLASH
	; end

	db 0 ; padding
