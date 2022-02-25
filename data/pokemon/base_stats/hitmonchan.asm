	db DEX_HITMONCHAN ; pokedex id

	db  50, 105,  79,  76,  110
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db 140 ; base exp

	INCBIN "gfx/pokemon/front/hitmonchan.pic", 0, 1 ; sprite dimensions
	dw HitmonchanPicFront, HitmonchanPicBack

	db COMET_PUNCH, AGILITY, HI_JUMP_KICK, IRON_HEAD  ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS,                  \
	     MIMIC,        DOUBLE_TEAM,   ROCK_TOMB,               METRONOME,    SWIFT,        \
	     SKULL_BASH,   REST,   ROCK_SLIDE,      SUBSTITUTE,   STRENGTH
	; end

	db 0 ; padding
