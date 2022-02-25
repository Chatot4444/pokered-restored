	db DEX_ZAPDOSG ; pokedex id

	db  90,  125,  90, 100, 85
	;   hp  atk  def  spd  spc

	db FIGHTING, FLYING ; type
	db 3 ; catch rate
	db 216 ; base exp

	INCBIN "gfx/pokemon/front/zapdosg.pic", 0, 1 ; sprite dimensions
	dw ZapdosgPicFront, ZapdosgPicBack

	db PECK, COUNTER, FEINT_ATTACK, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE,  SWORDS_DANCE,   WHIRLWIND,  MEGA_KICK,   TOXIC,     TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM, SUBMISSION, COUNTER,              EARTHQUAKE,            MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,                      SWIFT,        SKY_ATTACK,   \
	     REST,          SUBSTITUTE,   FLY,          FLASH
	; end

	db 0 ; padding
