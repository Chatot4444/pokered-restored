	db DEX_RAPIDASHG ; pokedex id

	db  65, 100,  70, 105,  80
	;   hp  atk  def  spd  spc

	db PSYCHIC_TYPE, FAIRY ; type
	db 60 ; catch rate
	db 192 ; base exp

	INCBIN "gfx/pokemon/front/rapidashg.pic", 0, 1 ; sprite dimensions
	dw RapidashgPicFront, RapidashgPicBack

	db CONFUSION, DRILL_RUN, RECOVER, HORN_DRILL ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm TOXIC,  SWORDS_DANCE,   MEGA_KICK,    HORN_DRILL,   BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE,  \
	     HYPER_BEAM,             PSYCHIC_M, TELEPORT,   MIMIC,        DOUBLE_TEAM,  REFLECT,      \
	      METRONOME,   SWIFT,        SKULL_BASH,   REST,    PSYWAVE,     \
	     SUBSTITUTE
	; end

	db 0 ; padding
