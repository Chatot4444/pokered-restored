PowerPlantMons:
	def_grass_wildmons 10 ; encounter rate
	db 21, VOLTORB
	db 21, MAGNEMITE
	db 20, PIKACHU
	db 24, GEODUDEA
	db 23, MAGNEMITE
	db 23, VOLTORB
	db 32, MAGNETON
IF DEF(_RED)
	db 35, ELECTABUZZ
	db 36, ELECTABUZZ
	db 26, ELEKID
ENDC
IF DEF(_BLUE)
	db 35, RAICHU
	db 36, ELECTABUZZ
	db 26, ELEKID
ENDC
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
