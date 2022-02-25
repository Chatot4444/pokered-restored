	db DEX_TANGELA ; pokedex id

	db  100,  100, 125,  50, 100
	;   hp  atk  def  spd  spc

	db GRASS, GRASS ; type
	db 30 ; catch rate
	db 187 ; base exp

	INCBIN "gfx/pokemon/front/tangrowth.pic", 0, 1 ; sprite dimensions
	dw TangrowthPicFront, TangrowthPicBack

	db CONSTRICT, BIND, VINE_WHIP, KARATE_CHOP ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,                    MEGA_DRAIN,   SOLARBEAM, EARTHQUAKE,   MIMIC,        \
	     DOUBLE_TEAM,  SLUDGE_BOMB,    SKULL_BASH,   REST,         SUBSTITUTE,   \
	     CUT,         STRENGTH
	; end

	db 0 ; padding
