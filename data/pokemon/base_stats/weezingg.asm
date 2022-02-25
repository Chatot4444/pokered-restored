	db DEX_WEEZINGG ; pokedex id

	db  65,  90, 120,  60,  85
	;   hp  atk  def  spd  spc

	db POISON, FAIRY ; type
	db 60 ; catch rate
	db 173 ; base exp

	INCBIN "gfx/pokemon/front/weezingg.pic", 0, 1 ; sprite dimensions
	dw WeezinggPicFront, WeezinggPicBack

	db TACKLE, SMOG, PSYBEAM, SHADOW_BALL ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,    BODY_SLAM,  DOUBLE_EDGE,   HYPER_BEAM,  FLAMETHROWER,                  THUNDERBOLT,  THUNDER,      \
	     MIMIC,        DOUBLE_TEAM,                  SELFDESTRUCT, SLUDGE_BOMB, FIRE_BLAST,   \
	     REST,         EXPLOSION,    SUBSTITUTE
	; end

	db 0 ; padding
