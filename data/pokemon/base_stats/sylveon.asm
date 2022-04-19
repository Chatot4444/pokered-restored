	db DEX_SYLVEON ; pokedex id

	db  95,  65,  65,  60,  130
	;   hp  atk  def  spd  spc

	db FAIRY, FAIRY ; type
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/front/sylveon.pic", 0, 1 ; sprite dimensions
	dw SylveonPicFront, SylveonPicBack

	db HEAT_WAVE, TACKLE, SAND_ATTACK, PLAY_ROUGH ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm   TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE, HYPER_BEAM,           MEGA_DRAIN,       \
	  PSYCHIC_M,   TELEPORT, MIMIC,        DOUBLE_TEAM,  REFLECT,    METRONOME,    SWIFT,        \
	     SKULL_BASH, DREAM_EATER,   REST,  PSYWAVE,       SUBSTITUTE, CUT,   FLASH
	; end

	db 0 ; padding
