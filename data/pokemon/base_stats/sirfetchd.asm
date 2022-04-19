	db DEX_SIRFETCHD ; pokedex id

	db  62,  135,  95,  65,  68
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db 94 ; base exp

	INCBIN "gfx/pokemon/front/sirfetchd.pic", 0, 1 ; sprite dimensions
	dw SirfetchdPicFront, SirfetchdPicBack

	db IRON_HEAD, X_SCISSOR, PECK, FOCUS_ENERGY ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE,   SWORDS_DANCE, WHIRLWIND,    TOXIC,        BODY_SLAM,    \
	     TAKE_DOWN,     DOUBLE_EDGE, HYPER_BEAM, SUBMISSION,  COUNTER, SEISMIC_TOSS,                   MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,                      SWIFT,        SKULL_BASH,  SKY_ATTACK,   REST,         \
	     SUBSTITUTE,   CUT,          FLY
	; end

	db 0 ; padding
