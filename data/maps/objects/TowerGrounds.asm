TowerGrounds_Object:
	db $3 ; border block
	
	def_warps
	warp 17, 43, 3, POKEMON_TOWER_1F
	warp 18, 43, 4, POKEMON_TOWER_1F
	
	def_signs
	
	def_objects
	object SPRITE_BIRD, 5, 5, STAY, DOWN, 1, MOLTRESG, 50 | OW_POKEMON
	object SPRITE_BOULDER, 17, 40, STAY, BOULDER_MOVEMENT_BYTE_2, 2 ; person
	object SPRITE_BOULDER, 21, 11, STAY, BOULDER_MOVEMENT_BYTE_2, 3 ; person
	
	def_warps_to TOWER_GROUNDS