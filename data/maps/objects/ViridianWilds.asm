ViridianWilds_Object:
	db $3 ; border block
	
	def_warp_events
	warp_event 43, 3, VIRIDIAN_FOREST, 7
	
	def_bg_events
	
	def_object_events
	object_event 6, 10, SPRITE_BIRD, STAY, DOWN, 1, ZAPDOSG, 50 | OW_POKEMON
	object_event 11, 25, SPRITE_POKE_BALL, STAY, NONE, 2, RARE_CANDY	
	object_event 13, 16, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 3 ; person


	def_warps_to VIRIDIAN_WILDS