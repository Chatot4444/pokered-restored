	db DEX_PERSIANA ; pokedex id

	db  65,  60,  60, 115,  75
	;   hp  atk  def  spd  spc

	db DARK, DARK ; type
	db 90 ; catch rate
	db 148 ; base exp

	INCBIN "gfx/pokemon/front/persiana.pic", 0, 1 ; sprite dimensions
	dw PersianaPicFront, PersianaPicBack

	db SCRATCH, GROWL, BITE, HEAT_WAVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  BUBBLEBEAM,   \
	     WATER_GUN,    HYPER_BEAM,   PAY_DAY,                       THUNDERBOLT,  \
	     THUNDER,      MIMIC,        DOUBLE_TEAM,                  SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE
	; end

	db 0 ; padding
