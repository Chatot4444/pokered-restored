	db DEX_MAGNEZONE ; pokedex id

	db  70,  70,  115,  60, 130
	;   hp  atk  def  spd  spc

	db ELECTRIC, STEEL ; type
	db 30 ; catch rate
	db 241 ; base exp

	INCBIN "gfx/pokemon/front/magnezone.pic", 0, 1 ; sprite dimensions
	dw MagnezonePicFront, MagnezonePicBack

	db HEAT_WAVE, TACKLE, SCREECH, THUNDERSHOCK ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,                    \
	     THUNDERBOLT,  THUNDER,      TELEPORT,     MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,                      SWIFT,        REST,         THUNDER_WAVE, \
	    TRI_ATTACK,    SUBSTITUTE,   FLASH
	; end

	db 0 ; padding
