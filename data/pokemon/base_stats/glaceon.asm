	db DEX_GLACEON ; pokedex id

	db 65,  60,  110,  65, 130
	;   hp  atk  def  spd  spc

	db ICE, ICE ; type
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/front/glaceon.pic", 0, 1 ; sprite dimensions
	dw GlaceonPicFront, GlaceonPicBack

	db SIGNAL_BEAM, TACKLE, SAND_ATTACK, ICE_BEAM ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,              DIG,      \
	     MIMIC,        DOUBLE_TEAM,  REFLECT,                      SWIFT,        \
	     SKULL_BASH, DREAM_EATER,   REST,        PSYWAVE,        SUBSTITUTE  
	; end

	db 0 ; padding
