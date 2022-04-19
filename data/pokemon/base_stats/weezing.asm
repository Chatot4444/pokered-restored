	db DEX_WEEZING ; pokedex id

	db  65,  90, 120,  60,  85
	;   hp  atk  def  spd  spc

	db POISON, POISON ; type
	db 60 ; catch rate
	db 173 ; base exp

	INCBIN "gfx/pokemon/front/weezing.pic", 0, 1 ; sprite dimensions
	dw WeezingPicFront, WeezingPicBack

	db CRUNCH, HEAT_WAVE, TACKLE, SMOG ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        HYPER_BEAM,                    THUNDERBOLT,  THUNDER, FLAMETHROWER,     \
	     MIMIC,        DOUBLE_TEAM,                  SELFDESTRUCT, SLUDGE_BOMB, FIRE_BLAST,   \
	     REST,         EXPLOSION,    SUBSTITUTE
	; end

	db 0 ; padding
