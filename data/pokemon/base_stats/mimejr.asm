	db DEX_MIME_JR ; pokedex id

	db  20,  25,  45,  60, 70
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FAIRY ; type
	db 151 ; catch rate
	db 78 ; base exp

	INCBIN "gfx/pokemon/front/mimejr.pic", 0, 1 ; sprite dimensions
	dw MimeJrPicFront, MimeJrPicBack

	db CONFUSION, BARRIER, DRAININGKISS, SIGNAL_BEAM ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,  AERIAL_ACE,  MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS, \
	                      SOLARBEAM,    THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,                      \
	     METRONOME,    SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     SUBSTITUTE,   FLASH
	; end

	db 0 ; padding
