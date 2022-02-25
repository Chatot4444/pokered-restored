	db DEX_AERODACTYL ; pokedex id

	db  80, 105,  65, 130,  60
	;   hp  atk  def  spd  spc

	db ROCK, FLYING ; type
	db 45 ; catch rate
	db 202 ; base exp

	INCBIN "gfx/pokemon/front/aerodactyl.pic", 0, 1 ; sprite dimensions
	dw AerodactylPicFront, AerodactylPicBack

	db WING_ATTACK, ANCIENTPOWER, HEAT_WAVE, HURRICANE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE,   WHIRLWIND,    TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,   FLAMETHROWER,                 DRAGON_RAGE, EARTHQUAKE,  MIMIC,        DOUBLE_TEAM,  \
	     REFLECT,      ROCK_TOMB,                FIRE_BLAST,   SWIFT,        SKY_ATTACK,   \
	     REST,         SUBSTITUTE,   FLY
	; end

	db 0 ; padding
