	db DEX_MAROWAKA ; pokedex id

	db  60,  80, 110,  45,  50
	;   hp  atk  def  spd  spc

	db FIRE, GHOST ; type
	db 75 ; catch rate
	db 124 ; base exp

	INCBIN "gfx/pokemon/front/marowaka.pic", 0, 1 ; sprite dimensions
	dw MarowakaPicFront, MarowakaPicBack

	db FIRE_SPIN, SCREECH, BONE_CLUB, GROWL ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_PUNCH,  AERIAL_ACE, SWORDS_DANCE, MEGA_KICK,    TOXIC,        BODY_SLAM,    TAKE_DOWN,    \
	     DOUBLE_EDGE,    ICE_BEAM,     BLIZZARD,     \
	     HYPER_BEAM,   SUBMISSION,   COUNTER,      SEISMIC_TOSS,  FLAMETHROWER,  THUNDERBOLT, THUNDER,     \
	     EARTHQUAKE,   FISSURE,      DIG,          MIMIC,        DOUBLE_TEAM,  \
	     ROCK_TOMB,                FIRE_BLAST,   SKULL_BASH, DREAM_EATER,   REST,         SUBSTITUTE,   \
	     STRENGTH
	; end

	db 0 ; padding
