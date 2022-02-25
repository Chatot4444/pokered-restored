ViridianWilds_Object:
	db $3 ; border block
	
	def_warps
	warp 43, 3, 6, VIRIDIAN_FOREST
	
	def_signs
	
	def_objects
	object SPRITE_BIRD, 6, 10, STAY, DOWN, 1, ZAPDOSG, 50 | OW_POKEMON
	object SPRITE_BOULDER, 13, 16, STAY, BOULDER_MOVEMENT_BYTE_2, 2 ; person
	
	def_warps_to VIRIDIAN_WILDS