MtMoonSummit_Object:
	db $3 ; border block
	
	def_warp_events
	warp_event 7, 11, MT_MOON_1F, 6
	
	def_bg_events
	
	def_object_events
	object_event 21,  1, SPRITE_BIRD, STAY, DOWN, 1, ARTICUNOG, 50 | OW_POKEMON
	object_event  9,  8, SPRITE_BOULDER, STAY, BOULDER_MOVEMENT_BYTE_2, 2 ; person
	
	def_warps_to MT_MOON_SUMMIT