RocketHideoutB1F_Object:
	db $2e ; border block

	def_warps
	warp 23,  2, 0, ROCKET_HIDEOUT_B2F
	warp 21,  2, 2, GAME_CORNER
	warp 24, 19, 0, ROCKET_HIDEOUT_ELEVATOR
	warp 21, 24, 3, ROCKET_HIDEOUT_B2F
	warp 25, 19, 1, ROCKET_HIDEOUT_ELEVATOR

	def_signs

	def_objects
	object SPRITE_ROCKET, 26, 8, STAY, LEFT, 1, OPP_ROCKET, 8
	object SPRITE_ROCKET, 12, 6, STAY, RIGHT, 2, OPP_ROCKET, 9
	object SPRITE_ROCKET, 18, 17, STAY, DOWN, 3, OPP_ROCKET, 10
	object SPRITE_ROCKET, 15, 25, STAY, RIGHT, 4, OPP_ROCKET, 11
	object SPRITE_ROCKET, 28, 18, STAY, LEFT, 5, OPP_ROCKET, 12
	object SPRITE_POKE_BALL, 11, 14, STAY, NONE, 6, ESCAPE_ROPE
	object SPRITE_POKE_BALL, 9, 17, STAY, NONE, 7, HYPER_POTION
	object SPRITE_BOX, 18, 14, STAY, NONE, 8 ; person 

	def_warps_to ROCKET_HIDEOUT_B1F
