	db DEX_TENTACRUEL ; pokedex id

	db  80,  70,  65, 100, 120
	;   hp  atk  def  spd  spc

	db WATER, POISON ; type
	db 60 ; catch rate
	db 205 ; base exp

	INCBIN "gfx/pokemon/front/tentacruel.pic", 0, 1 ; sprite dimensions
	dw TentacruelPicFront, TentacruelPicBack

	db SIGNAL_BEAM, ICY_WIND, ACID, CONFUSE_RAY ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,                    \
	     MEGA_DRAIN,   MIMIC,        DOUBLE_TEAM,  REFLECT,     SLUDGE_BOMB,   \
	     SKULL_BASH,   REST,         SUBSTITUTE,   CUT,          SURF,  FLASH
	; end

	db 0 ; padding
