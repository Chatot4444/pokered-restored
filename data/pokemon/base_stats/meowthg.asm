	db DEX_MEOWTHG ; pokedex id

	db  50,  65,  55,  40,  40
	;   hp  atk  def  spd  spc

	db STEEL, STEEL ; type
	db 255 ; catch rate
	db 69 ; base exp

	INCBIN "gfx/pokemon/front/meowthg.pic", 0, 1 ; sprite dimensions
	dw MeowthgPicFront, MeowthgPicBack

	db SCRATCH, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    PAY_DAY,                       THUNDERBOLT,  THUNDER,      \
	     MIMIC,        DOUBLE_TEAM,                  SWIFT,        SKULL_BASH,   \
	     REST,         SUBSTITUTE
	; end

	db 0 ; padding
