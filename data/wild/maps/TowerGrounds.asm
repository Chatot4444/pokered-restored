TowerGroundsMons:
	def_grass_wildmons 25 ; encounter rate
	db  25, GASTLY
	db  26, RATTATAA
	db  28, RATTATAA
IF DEF(_RED)
	db  27, MEOWTHA
ENDC
IF DEF(_BLUE)
	db  27, MEOWTHG
ENDC
	db  26, GASTLY
	db  25, CUBONE
	db  30, HAUNTER
	db  32, RATICATEA
	db  28, GRIMERA
	db  34, MAROWAKA
	end_grass_wildmons

	def_water_wildmons 0 ; encounter rate
	end_water_wildmons
