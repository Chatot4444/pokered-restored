	db DEX_EXEGGUTORA ; pokedex id

	db  95,  105,  85,  45, 125
	;   hp  atk  def  spd  spc

	db GRASS, DRAGON ; type
	db 45 ; catch rate
	db 212 ; base exp

	INCBIN "gfx/pokemon/front/exeggutora.pic", 0, 1 ; sprite dimensions
	dw ExeggutoraPicFront, ExeggutoraPicBack

	db BARRAGE, HYPNOSIS, CONFUSION, IRON_HEAD ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM, FLAMETHROWER,                   \
	     MEGA_DRAIN,   SOLARBEAM, DRAGON_RAGE, EARTHQUAKE,  PSYCHIC_M,    TELEPORT,     MIMIC,        \
	     DOUBLE_TEAM,  REFLECT,                      SELFDESTRUCT, SLUDGE_BOMB,  FIRE_BLAST,   \
	     REST,         PSYWAVE,      EXPLOSION,    SUBSTITUTE,   STRENGTH
	; end

	db 0 ; padding
