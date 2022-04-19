RedsHouse2F_Object:
	db $a ; border block

	def_warps
	warp  7,  1, 2, REDS_HOUSE_1F

	def_signs

	def_objects
	object SPRITE_CLIPBOARD,  4,  1, STAY, NONE, 1 ; person
	
	def_warps_to REDS_HOUSE_2F
