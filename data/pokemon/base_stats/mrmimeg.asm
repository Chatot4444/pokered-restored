	db DEX_MR_MIMEG ; pokedex id

	db  50,  65,  65,  100, 90
	;   hp  atk  def  spd  spc

	db ICE, PSYCHIC_TYPE ; type
	db 45 ; catch rate
	db 136 ; base exp

	INCBIN "gfx/pokemon/front/mr.mimeg.pic", 0, 1 ; sprite dimensions
	dw MrMimegPicFront, MrMimegPicBack

	db CONFUSION, BARRIER, AURORA_BEAM, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,  AERIAL_ACE,  MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  ICE_BEAM,  BLIZZARD,   HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	                    MEGA_DRAIN,     SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,                      \
	     METRONOME,    SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     SUBSTITUTE,   FLASH
	; end

	db 0 ; padding
