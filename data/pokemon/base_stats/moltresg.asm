	db DEX_MOLTRESG ; pokedex id

	db  90, 100,  90,  90, 125
	;   hp  atk  def  spd  spc

	db DARK, FLYING ; type
	db 3 ; catch rate
	db 217 ; base exp

	INCBIN "gfx/pokemon/front/moltresg.pic", 0, 1 ; sprite dimensions
	dw MoltresgPicFront, MoltresgPicBack

	db GUST, FEINT_ATTACK, DRAGONBREATH, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,                    MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	                     SLUDGE_BOMB,   SWIFT,        SKY_ATTACK,   REST,         \
	     SUBSTITUTE,   FLY
	; end

	db 0 ; padding
