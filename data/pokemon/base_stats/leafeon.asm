	db DEX_LEAFEON ; pokedex id

	db  65,  110,  130,  95,  65
	;   hp  atk  def  spd  spc

	db GRASS, GRASS ; type
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/front/Leafeon.pic", 0, 1 ; sprite dimensions
	dw LeafeonPicFront, LeafeonPicBack

	db IRON_HEAD, TACKLE, SAND_ATTACK, RAZOR_LEAF ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_KICK,  AERIAL_ACE, SWORDS_DANCE,  TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE, HYPER_BEAM,                  \
		MEGA_DRAIN,  SOLARBEAM,  DIG,         MIMIC,        DOUBLE_TEAM,  REFLECT,                      SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE,  CUT
	; end

	db 0 ; padding
