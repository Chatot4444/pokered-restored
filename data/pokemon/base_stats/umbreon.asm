	db DEX_UMBREON ; pokedex id

	db  95,  65,  110,  65,  130
	;   hp  atk  def  spd  spc

	db DARK, DARK ; type
	db 45 ; catch rate
	db 184 ; base exp

	INCBIN "gfx/pokemon/front/umbreon.pic", 0, 1 ; sprite dimensions
	dw UmbreonPicFront, UmbreonPicBack

	db IRON_HEAD, TACKLE, SAND_ATTACK, CRUNCH ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm MEGA_KICK,  TOXIC,        BODY_SLAM,    TAKE_DOWN,    DOUBLE_EDGE, HYPER_BEAM, PAY_DAY,                  \
	     TELEPORT, MIMIC,        DOUBLE_TEAM,  REFLECT,                      SWIFT,        \
	     SKULL_BASH, DREAM_EATER,   REST,         SUBSTITUTE
	; end

	db 0 ; padding
