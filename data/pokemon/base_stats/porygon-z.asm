	db DEX_PORYGONZ ; pokedex id

	db  85,  80,  70,  90,  130
	;   hp  atk  def  spd  spc

	db NORMAL, NORMAL ; type
	db 30 ; catch rate
	db 241 ; base exp

	INCBIN "gfx/pokemon/front/porygon-z.pic", 0, 1 ; sprite dimensions
	dw PorygonZPicFront, PorygonZPicBack

	db TACKLE, SHARPEN, CONVERSION, ICY_WIND ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, TOXIC,        TAKE_DOWN,    DOUBLE_EDGE,  ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SOLARBEAM,     THUNDERBOLT,  THUNDER,      PSYCHIC_M,    \
	     TELEPORT,     MIMIC,        DOUBLE_TEAM,  REFLECT,      SLUDGE_BOMB,                \
	     SWIFT,        SKULL_BASH,   REST,         THUNDER_WAVE, PSYWAVE,      \
	     TRI_ATTACK,   SUBSTITUTE,   FLASH
	; end

	db 0 ; padding
