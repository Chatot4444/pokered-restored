	db DEX_DIGLETTA ; pokedex id

	db  10,  55,  30,  90,  45
	;   hp  atk  def  spd  spc

	db GROUND, STEEL ; type
	db 255 ; catch rate
	db 81 ; base exp

	INCBIN "gfx/pokemon/front/digletta.pic", 0, 1 ; sprite dimensions
	dw DiglettaPicFront, DiglettaPicBack

	db SCRATCH, NO_MOVE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,                   \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM, ROCK_TOMB, \
	      SLUDGE_BOMB,               REST,         ROCK_SLIDE,   SUBSTITUTE
	; end

	db 0 ; padding
