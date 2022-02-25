	db DEX_RATICATEA ; pokedex id

	db  75,  71,  70,  77,  80
	;   hp  atk  def  spd  spc

	db DARK, NORMAL ; type
	db 90 ; catch rate
	db 116 ; base exp

	INCBIN "gfx/pokemon/front/raticatea.pic", 0, 1 ; sprite dimensions
	dw RaticateaPicFront, RaticateaPicBack

	db IRON_HEAD, CONFUSE_RAY, PSYBEAM, X_SCISSOR ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm SWORDS_DANCE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    ICE_BEAM,     BLIZZARD,     HYPER_BEAM,                    \
	     THUNDERBOLT,  THUNDER,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	       SLUDGE_BOMB,              SWIFT,        SKULL_BASH,   REST,         SUBSTITUTE
	; end

	db 0 ; padding
