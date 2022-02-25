	db DEX_ARTICUNOG ; pokedex id

	db  90,  85, 85,  95, 125
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FLYING ; type
	db 3 ; catch rate
	db 215 ; base exp

	INCBIN "gfx/pokemon/front/articunog.pic", 0, 1 ; sprite dimensions
	dw ArticunogPicFront, ArticunogPicBack

	db GUST, HYPNOSIS, SHADOW_BALL, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	        HYPER_BEAM,   \
	               PSYCHIC_M,  TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,   \
	     SWIFT,    DREAM_EATER,    SKY_ATTACK,   REST,  PSYWAVE,    SUBSTITUTE,   FLY
	; end

	db 0 ; padding
