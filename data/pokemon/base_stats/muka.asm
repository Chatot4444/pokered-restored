	db DEX_MUKA ; pokedex id

	db 105, 105,  75,  50,  65
	;   hp  atk  def  spd  spc

	db POISON, DARK ; type
	db 75 ; catch rate
	db 157 ; base exp

	INCBIN "gfx/pokemon/front/muka.pic", 0, 1 ; sprite dimensions
	dw MukaPicFront, MukaPicBack

	db ICE_PUNCH, CRUNCH, LICK, DISABLE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    HYPER_BEAM,     FLAMETHROWER,               MEGA_DRAIN,   \
	         MIMIC,        DOUBLE_TEAM,   ROCK_TOMB,               \
	     SELFDESTRUCT, SLUDGE_BOMB, FIRE_BLAST,   REST,         EXPLOSION,    SUBSTITUTE
	; end

	db 0 ; padding
