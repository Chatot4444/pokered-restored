TowerGrounds_Object:
	db $3 ; border block
	
	def_warp_events
	warp_event 17, 43, POKEMON_TOWER_1F, 4
	warp_event 18, 43, POKEMON_TOWER_1F, 5
	
	def_bg_events
	
	def_object_events
	object_event 5, 5, SPRITE_BIRD, STAY, DOWN, 1, MOLTRESG, 50 | OW_POKEMON
	object_event 8, 32, SPRITE_POKE_BALL, STAY, NONE, 2, PP_UP
	object_event 17, 40, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 3 ; person
	object_event 21, 11, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 4 ; person
	
	def_warps_to TOWER_GROUNDS