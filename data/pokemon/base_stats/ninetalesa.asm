	db DEX_NINETALESA ; pokedex id

	db  73,  67,  75, 109, 100
	;   hp  atk  def  spd  spc

	db ICE, FAIRY ; type
	db 75 ; catch rate
	db 178 ; base exp

	INCBIN "gfx/pokemon/front/ninetalesa.pic", 0, 1 ; sprite dimensions
	dw NinetalesaPicFront, NinetalesaPicBack

	db ICY_WIND, TAIL_WHIP, PLAY_ROUGH, OMINOUS_WIND ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE, ICE_BEAM, BLIZZARD, HYPER_BEAM,   \
	                      DIG,          MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	                        SWIFT,        SKULL_BASH,   REST,   PSYWAVE,      \
	     SUBSTITUTE, FLASH
	; end

	db 0 ; padding
