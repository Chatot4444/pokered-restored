	db DEX_RAICHUA ; pokedex id

	db  60,  85,  50, 110,  95
	;   hp  atk  def  spd  spc

	db ELECTRIC, PSYCHIC_TYPE; type
	db 75 ; catch rate
	db 122 ; base exp

	INCBIN "gfx/pokemon/front/raichua.pic", 0, 1 ; sprite dimensions
	dw RaichuaPicFront, RaichuaPicBack

	db THUNDERBOLT, THUNDER_WAVE, PLAY_ROUGH, PSYCHIC_M ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   PAY_DAY,      SUBMISSION,   SEISMIC_TOSS, \
	                   MEGA_DRAIN,     THUNDERBOLT,  THUNDER,   PSYCHIC_M, TELEPORT,   MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,     METRONOME,         SWIFT,        SKULL_BASH,   REST,         \
	     THUNDER_WAVE, PSYWAVE,  SUBSTITUTE, SURF,  FLASH
	; end

	db 0 ; padding
