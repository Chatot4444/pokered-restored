	db DEX_GENGAR ; pokedex id

	db  60,  65,  60, 110, 130
	;   hp  atk  def  spd  spc

	db GHOST, POISON ; type
	db 45 ; catch rate
	db 190 ; base exp

	INCBIN "gfx/pokemon/front/gengar.pic", 0, 1 ; sprite dimensions
	dw GengarPicFront, GengarPicBack

	db ICY_WIND, LICK, CONFUSE_RAY, NIGHT_SHADE ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE, ICE_BEAM, HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	                      MEGA_DRAIN,   THUNDERBOLT,  THUNDER,      PSYCHIC_M,  TELEPORT,   \
	     MIMIC,        DOUBLE_TEAM,                  METRONOME,    SELFDESTRUCT, \
	    SLUDGE_BOMB,  SKULL_BASH,   DREAM_EATER,  REST,         PSYWAVE,      EXPLOSION,    \
	     SUBSTITUTE,   STRENGTH
	; end

	db 0 ; padding
