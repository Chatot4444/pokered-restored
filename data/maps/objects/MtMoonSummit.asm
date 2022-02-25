MtMoonSummit_Object:
	db $3 ; border block
	
	def_warps
	warp 7, 11, 5, MT_MOON_1F
	
	def_signs
	
	def_objects
	object SPRITE_BIRD, 21,  1, STAY, DOWN, 1, ARTICUNOG, 50 | OW_POKEMON
	object SPRITE_BOULDER,  9,  8, STAY, BOULDER_MOVEMENT_BYTE_2, 2 ; person
	
	def_warps_to MT_MOON_SUMMIT