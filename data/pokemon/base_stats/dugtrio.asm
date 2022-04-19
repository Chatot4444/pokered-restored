	db DEX_DUGTRIO ; pokedex id

	db  35,  100,  50, 120,  70
	;   hp  atk  def  spd  spc

	db GROUND, GROUND ; type
	db 50 ; catch rate
	db 153 ; base exp

	INCBIN "gfx/pokemon/front/dugtrio.pic", 0, 1 ; sprite dimensions
	dw DugtrioPicFront, DugtrioPicBack

	db TRI_ATTACK, FEINT_ATTACK, ANCIENTPOWER, SCRATCH  ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm AERIAL_ACE, TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  HYPER_BEAM,   \
	                      EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        \
	     DOUBLE_TEAM,    ROCK_TOMB,  SLUDGE_BOMB,            REST,         ROCK_SLIDE,   SUBSTITUTE
	; end

	db 0 ; padding
