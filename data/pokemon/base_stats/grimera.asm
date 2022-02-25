	db DEX_GRIMERA ; pokedex id

	db  80,  80,  50,  25,  40
	;   hp  atk  def  spd  spc

	db POISON, DARK ; type
	db 190 ; catch rate
	db 90 ; base exp

	INCBIN "gfx/pokemon/front/grimera.pic", 0, 1 ; sprite dimensions
	dw GrimeraPicFront, GrimeraPicBack

	db LICK, DISABLE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        BODY_SLAM,    FLAMETHROWER,                 MEGA_DRAIN,     \
	         MIMIC,        DOUBLE_TEAM,   ROCK_TOMB,               SELFDESTRUCT, \
	     SLUDGE_BOMB,  FIRE_BLAST,   REST,         EXPLOSION,    SUBSTITUTE
	; end

	db 0 ; padding
