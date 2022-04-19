	db DEX_SCIZOR ; pokedex id

	db  70, 130,  100, 65,  55
	;   hp  atk  def  spd  spc

	db BUG, STEEL ; type
	db 25 ; catch rate
	db 175 ; base exp

	INCBIN "gfx/pokemon/front/scizor.pic", 0, 1 ; sprite dimensions
	dw ScizorPicFront, ScizorPicBack

	db FEINT_ATTACK, QUICK_ATTACK, IRON_HEAD, X_SCISSOR ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, SWORDS_DANCE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	                      MIMIC,        DOUBLE_TEAM,   ROCK_TOMB,               SWIFT,        \
	     SKULL_BASH,   REST,         SUBSTITUTE,   CUT, STRENGTH
	; end

	db 0 ; padding
