	db DEX_VENUSAUR ; pokedex id

	db  80,  82,  83,  80, 100
	;   hp  atk  def  spd  spc

	db GRASS, POISON ; type
	db 45 ; catch rate
	db 208 ; base exp

	INCBIN "gfx/pokemon/front/venusaur.pic", 0, 1 ; sprite dimensions
	dw VenusaurPicFront, VenusaurPicBack

	db DRAGONBREATH, TACKLE, GROWL, LEECH_SEED ; level 1 learnset
	db GROWTH_MEDIUM_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,                    MEGA_DRAIN,   SOLARBEAM, EARTHQUAKE,    MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,   SLUDGE_BOMB,      REST,         SUBSTITUTE,   \
	     CUT
	; end

	db 0 ; padding
