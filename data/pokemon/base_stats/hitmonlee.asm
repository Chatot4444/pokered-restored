	db DEX_HITMONLEE ; pokedex id

	db  50, 120,  53,  87,  110
	;   hp  atk  def  spd  spc

	db FIGHTING, FIGHTING ; type
	db 45 ; catch rate
	db 139 ; base exp

	INCBIN "gfx/pokemon/front/hitmonlee.pic", 0, 1 ; sprite dimensions
	dw HitmonleePicFront, HitmonleePicBack

	db DOUBLE_KICK, MEDITATE, ICE_PUNCH, IRON_HEAD ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,   MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,  SUBMISSION,   COUNTER,      SEISMIC_TOSS,                  \
	     MIMIC,        DOUBLE_TEAM,  ROCK_TOMB,                METRONOME,    SWIFT,        \
	     SKULL_BASH,   REST,     ROCK_SLIDE,    SUBSTITUTE,   STRENGTH
	; end

	db 0 ; padding
