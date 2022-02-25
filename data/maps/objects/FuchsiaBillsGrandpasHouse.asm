FuchsiaBillsGrandpasHouse_Object:
	db $a ; border block

	def_warps
	warp  2,  7, 1, LAST_MAP
	warp  3,  7, 1, LAST_MAP

	def_signs

	def_objects
	object SPRITE_MIDDLE_AGED_WOMAN,  2,  4, STAY, DOWN, 1 ; person
	object SPRITE_GAMBLER,  5,  4, STAY, DOWN, 2 ; person
	object SPRITE_YOUNGSTER,  7,  2, STAY, UP, 3 ; person

	def_warps_to FUCHSIA_BILLS_GRANDPAS_HOUSE
